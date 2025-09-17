Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8513CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E07D8E0027; Wed, 17 Sep 2025 10:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443538E0003; Wed, 17 Sep 2025 10:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B178E0027; Wed, 17 Sep 2025 10:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1337F8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:19:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADBB159B50
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:19:29 +0000 (UTC)
X-FDA: 83898950058.10.8A3A003
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B65A2000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:19:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="OSsm/kRu";
	spf=pass (imf13.hostedemail.com: domain of "prvs=535585c970=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=535585c970=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758118767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52qLIIAzvlAAHuqQ1rgp4DiAOiEC2Ql6thGY+wjkrqc=;
	b=AvHKJhtwmJLIZZXw4G1aMl+dOId6IeAoo/rCcWsUQPnFCFGkw/wipnRcMeE53bgb48wIeO
	py73mpVDJUZQgSksC2tSRKWyUhEQLJwfaI3aXpqqCD34Itg4JNKSXYIybhE+JtqE1eSg9a
	SnE4zf537G6KxE3XuK1nQ0HVWaznBUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758118767; a=rsa-sha256;
	cv=none;
	b=Ut+8sOuQh3Jd+QopOsdhY5uMvchi36LXjJYniWcqD0ZtO0pIOWRY5fPEp+VVAUmGbIie7t
	VxrX8DQhTCb/8itgLZ/Frydlf23dbM6ltKd52PB8oBWuGPLeCq3nmhXYJY17EnOC5wcTnV
	Ln2BPyAq36LPfdSAjJ/60qD8bF5+P/8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b="OSsm/kRu";
	spf=pass (imf13.hostedemail.com: domain of "prvs=535585c970=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=535585c970=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58H6jaki2876528
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:19:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=52qLIIAzvlAAHuqQ1rgp4DiAOiEC2Ql6thGY+wjkrqc=; b=OSsm/kRuZtHd
	K2uC0ZrxrljSahydEW8+jMk/QYJrg/jwTHRqqFj55LRTUaSJD3NkVyabErbQPZz9
	a+tUcMR5qEm87gh01tJmCYXZkciPyY6QWtQqWUSRe5lovAOEqxv1R47ZniyO+uvQ
	4T6bXSAUF+QGAE76YRWCjcczHLdVw814ZvTrZ8QsWmfCGTaqBNbbN2lxbVATRvPg
	MesT2waA5zn2hDb+KYsH+xoWV/OPAS1Icthh5SXKOEAxkGGyxVDl0X28Y3LnQJqU
	k0phcpCN9JqwjIyOe4GCsxr40B1kOhC5I1e7XTAmWvlCR/XBy1YicAl1foal5tdd
	06HfXxvs1Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 497r0kaqfe-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:19:25 -0700 (PDT)
Received: from twshared52133.15.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 17 Sep 2025 14:18:53 +0000
Received: by devbig091.ldc1.facebook.com (Postfix, from userid 8731)
	id 423E326F58B6; Wed, 17 Sep 2025 06:46:07 -0700 (PDT)
From: Chris Mason <clm@meta.com>
To: Donet Tom <donettom@linux.ibm.com>
CC: Chris Mason <clm@meta.com>, David Hildenbrand <david@redhat.com>,
        Andrew
 Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Zi
 Yan <ziy@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ritesh
 Harjani <ritesh.list@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Jonathan Cameron
	<Jonathan.Cameron@huawei.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Yury Norov <yury.norov@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] drivers/base/node: Handle error properly in register_one_node()
Date: Wed, 17 Sep 2025 06:45:56 -0700
Message-ID: <20250917134604.2149316-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250822084845.19219-1-donettom@linux.ibm.com>
References:
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Authority-Analysis: v=2.4 cv=HLzDFptv c=1 sm=1 tr=0 ts=68cac36d cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=nFD8B3nJBdWI0zd2dBoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE3MDE0MCBTYWx0ZWRfX25p0VcI6gA1q
 uxyKxDZWsW3j3A2OsRhxMGyUqJWKm4CEp6O1I2Fb79plqQ89xMxvYR6D5LSiNf0Gwe1KioC5uPl
 dmkjYNJAb8E0P0mtYlwzxQUteCtD3ELs6Xyvdt0F1iITss0fmeAfLaqun7Ni5LhZ/mJ2xnBUO6t
 TiHEGNuL5TRS9jLi/Z9wnC2l8vMRPEHfe2MlBmsU4dh3zUL6eu9tBwmVrFAlVAsGIYod9UprgTn
 zweuM8YkV70B+gjtQvFy2bahSt3NXFdjl2vNzLnW5d9680+UiASN3PBE0eLd7ehQomRFQ76fpxB
 AgELBGYFeQLXNoBUXiaaAwCpJlG6UUTzrNz+w59CBhEN4frTn+6XjuBYIL++MM=
X-Proofpoint-ORIG-GUID: 6iyEd8vzMoFFWX403inbFo8JztG7RO9t
X-Proofpoint-GUID: 6iyEd8vzMoFFWX403inbFo8JztG7RO9t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Stat-Signature: eksoznpcd4ibgeni8qm76z55q6fyzyqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B65A2000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1758118767-746343
X-HE-Meta: U2FsdGVkX1+57klCPaqhL79A5YAHkOY6GlX+tIHXfUX7hbp9/ZE1agihUwClPqZzJtDrsfu7Qm5v8wNgEfskd2CAvUEy/UBiLW2gZ968LG3scy61GZVyB9Z1XZOgTwfMSzfs/vz9rFbeCZq42xBa5q/FsAu+62ISSfKnb5ZF4QsvW13zpHHP7zXe2xGyaDtiON4hrkEZ8L8KkKOvuq2X+rx2v2iCsi72UP9yXFrDI3cO4B6VfCiPCw6+SgV5aUjkX2AHXZJUsA1CKqGbyHWpLa455uN6iXEtgqYdt2XLojKULAmAw2qmWBU2b5BGPwlrVF68AcEPt0teWXBCiYuMJ6N2hqC8OHWq7H/VBU6mj7oWPhJdsrAN35G3izPuiRTSU5ot3+iPzxy3Bfk6wm4DMHJZchmdJ63es10OR39Z5AUn/4YkxilOYUOmAnP9+v4EPf1fz8/x6igkBjPlZt7KgtV1gx4I1RH/dB1XljjNRXkue5e8ZttLYNw+r+SPI/tqO9mfPkfF3CeyBFujS4nsa5frfqOCAu4pRo3P9D3krxAe39/JEap3z3m34pm0BJHsYclkuLIy/aryKFFd5XcLHi6f7xY1wuerHaIuUh5OE5XK/wonwew01viLLvEkWbHALsK24i41cNiCGLaPmjZFhIc/5DnnAEBVPPL6zzrkGWUA0MdGX9w2fizarMhH+hMO4l0u/vkpxlDrZSDkryO0Unx6AfVrW+X6wSkgZiMUCyjSgy+e8F6YTrbhYE21kp+qEB+AuIszYdX5pTd3RXCVyb8VQG0mxzOvqJnzcPvRd3NJOAX9u7qTOgPUgLScB6JxtguhUjmziYc+Vsxy6bhje9s8PR2yqbD212ekoQ85nGZNs8l3gMrgFSXAWcHYiIsLmLUyRcKpQMgDyKzaTmCEjlcfSfYnXAn/wAHcPspIc/3dMcfj7gqYyIGlsH9IjhcSyW24kcDcE/HaS24WeU9
 uKHnZlQD
 FG3Jw9GJGT/gJz6lGX0skga5upsJ1/emfKPpFPc8QBq6tSHIdIG5KhuKyyw0ksUfSrZEiA4LN7knVdTrWyNditetgmvGqzjo2M/TTZfPlJZVbNTLdoIEojeC9kDq3vLupHPl7hMeYe5uInn4sFj00DInxzBT5nIoUKXtv4DM6FoahTzMXKFN+R5BMTl6hrIUT2bKfAtGfgSyWV2fw9J6dOQGAQzSvVZow4kKCZtbAXtlyJyaX6oChw6yLsaWnyqvBnig34QZ3lN52IO/Yrq3E2F8YaizcwfK8YVmrth1ugd81VsUyCL3lVPeaKTeCoj9oK+WshswFofG62WCQ3apVunnjvrpfS84BUTmiDO6GFmXoZWoPRByUEVioPO5DxoEdjgLvITCWZI0rznirTkuOi2zIHnpVjmnl6gYMhg5ypckPwRDbjp+ezuvE8VzUx/LNsfJMS1s6Z4VjiEPT0z6nNibTaZX5Tqql9vbnHW1HTzBU17wrks+UXEhtZxkD+U6Leb2q+r9H45gMMeyWdZNCXwKfr6dftXfLw+NqmfVZ1D06vJr5sh5an3GTklDWRnXGghY+yBcakmT42QLY2pl/VGeggASFOD8ypJYMjVTdEOJEzXbYsinU30C1Vp5aSXK67z9vNhY78jORME4PjaAFwUui3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 14:18:45 +0530 Donet Tom <donettom@linux.ibm.com> wro=
te:

> If register_node() returns an error, it is not handled correctly.
> The function will proceed further and try to register CPUs under the
> node, which is not correct.
>=20
> So, in this patch, if register_node() returns an error, we return
> immediately from the function.
>=20
> Fixes: 76b67ed9dce6 ("[PATCH] node hotplug: register cpu: remove node s=
truct")
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
> v1 -> v2
> Made the changes based on Oscar=E2=80=99s review comments.
>=20
> v1 - https://lore.kernel.org/all/20250702112856.295176-1-donettom@linux=
.ibm.com/
> ---
>  drivers/base/node.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index c65b4917794e..1608816de67f 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -883,6 +883,11 @@ int register_one_node(int nid)
>  	node_devices[nid] =3D node;
> =20
>  	error =3D register_node(node_devices[nid], nid);
> +	if (error) {
> +		node_devices[nid] =3D NULL;
> +		kfree(node);
> +		return error;
> +	}

Can this cause a double-free? Looking at register_node(), when=20
device_register() fails, it calls put_device(&node->dev). The put_device(=
)=20
call triggers node_device_release() which does kfree(to_node(dev)), freei=
ng
the entire node structure. So when register_node() returns an error, the=20
node memory is already freed, but this code calls kfree(node) again on th=
e
same memory.

The call chain is: register_node()->device_register() fails->
put_device()->node_device_release()->kfree(to_node(dev)).

[ This came from automated patch review, but it looks real to me ]

-chris

