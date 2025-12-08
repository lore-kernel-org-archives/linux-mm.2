Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF3ED3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 17:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542C36B0005; Mon,  8 Dec 2025 12:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3AB6B0007; Mon,  8 Dec 2025 12:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2716B0008; Mon,  8 Dec 2025 12:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEEE6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:32:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C800D57ABB
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 17:32:01 +0000 (UTC)
X-FDA: 84196996842.01.0F31B1C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62A02140017
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 17:31:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ek8IKmY8;
	spf=pass (imf09.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765215119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRPbf4ywtrBif5u8FvR4fJIgXpdQsnXNbd/L15InNNA=;
	b=vVAMNAQJxc4Uxyi5l/QE3Y8oXEaAvQprWL+/BGnDWENIEV66zA9hCQQRiHlNjmQLOFQLiK
	y4p77Qqj3PR2AbQui1LZY/mNVUDyKo+oXEBcK1YxdC2AEx8CSvlINlk+WLifVPaAzXEW+S
	2LVS4YpezVdDHbmXZPevx/nW18z3fVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765215119; a=rsa-sha256;
	cv=none;
	b=rn06t+EUDalMzuuKzyIXRPOQX/JJAPol2+TdZZE+K3ylblCO4l5kSWkEZ0lrmULm3GSqI1
	GwBMmYaDm2GnUtFUUnUGEn+943Eyh3SpuSB6mb9n9T7oVbo/LYJIwaAjzPtOQG6qH+l7sW
	UFIN8glJHmvqlk/M+p5Qg1f0TT/l2N4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ek8IKmY8;
	spf=pass (imf09.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B87HoTL002688;
	Mon, 8 Dec 2025 17:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NRPbf4
	ywtrBif5u8FvR4fJIgXpdQsnXNbd/L15InNNA=; b=Ek8IKmY8Pm0iIgnFpvH3EW
	VXo7NYGHn3S8hikBkvvZxkSLXmk0Jp8UW7Y2/lSXdBxPYFoyxh7aSjjzSBOJb2hb
	2I2WdX3XkwSonXq0R3m+uSigYqV7jMmd5DYBQESX4dh5tGgly9DSE5MTlJLfni3B
	Cv7FYfecbDxEykC2n6KC6mrxwflrXiO02Pf+TVA9Pw+tNNrJakf70MikwA/dASbH
	Tw/hwfL1XbuV4IZ+JjTq+QsOaPg3XU0tpJvl/x4ftOq/uONBsJZ+JvsrGFi82Iud
	zZHtXjQNIqvgJ+q8qwe8Ofmy6bHZqU5azteky6J+RfxSuA7wNB5yISAN6BLChvkA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4avawv0nac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Dec 2025 17:31:53 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B8HR1iQ028942;
	Mon, 8 Dec 2025 17:31:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4avawv0naa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Dec 2025 17:31:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B8FY7q3012812;
	Mon, 8 Dec 2025 17:31:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aw0ajprab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Dec 2025 17:31:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B8HVoHo16777532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Dec 2025 17:31:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 185C820043;
	Mon,  8 Dec 2025 17:31:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C62B020040;
	Mon,  8 Dec 2025 17:31:46 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.36.5.167])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Dec 2025 17:31:46 +0000 (GMT)
Message-ID: <d35eca2bbdf8675c43d528571bb61c7520e669cb.camel@linux.ibm.com>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction
 reads lock-free
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, gourry@gourry.net,
        mhocko@suse.com, david@kernel.org
Cc: vbabka@suse.cz, surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
        ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
		 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Date: Mon, 08 Dec 2025 23:00:46 +0530
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: adW5n7PXyjOhYlUV2HCe3nlMUBU9jlrz
X-Proofpoint-ORIG-GUID: -f4J37UvQXOw_46QqKsl_df0HLLnOb-I
X-Authority-Analysis: v=2.4 cv=aY9sXBot c=1 sm=1 tr=0 ts=69370b89 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=GEmWsRkYQ48VsW4USWEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDAwNyBTYWx0ZWRfX3KytDWOEC8O4
 Tmp/tkle4v7H0P+F59MU70PbP35tXUr8uwPZymbGBqHs0Y1edLKbqBU3cHWLKK0MMUL/AIuCpWP
 YejRNsieP9nwoqRCyh/erBHrAIGtc5czE2NRchlNyKh8VSwSgfFYjtGXSIxFCTICe6uhFpQUuWK
 E6fseK7dKAdYg8J0fCYZSbXUEl0Y5lpW6psWdC+196LI24LZJvDasOIqryznoDDj+pHeIBF7aKQ
 v51DwWHKWm5Lz3REzFb710qYewRFU5hHyvAV3tNq68dKiTjfgnE12jfjfvm6F7irLEqilxwU7eB
 X/lBM0GzK58MTCitvlta48encY6FuQzeuUQlmLvTln4FO4SLH7FXGzFWXkN+hnQe1ePn51jKfyt
 8zMJy57MOJLhTkI+RKHzCl0DHwznLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512060007
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62A02140017
X-Stat-Signature: 9hrdqcbbt4hwgmrtymwiua3mp1wn71af
X-Rspam-User: 
X-HE-Tag: 1765215119-857132
X-HE-Meta: U2FsdGVkX1+YDKRcOujGJ2BRfTBhtcFdixFkhxR5gKQtq631PFTwvQvGUggX/0kz0QL8/R4+/fzde/48epjKUTXMSIvQwQbMqs9bfFVtmtUvxEGZqkS1lzBrzOMuFWlNyrfi4BjiGRD/Qph/dLS8qFA0SOb3M7KZLOSZ1g013jURyFqA1azeWINciAmXNqLxoL1ggERh6eopIkLrIhBHWSGCxHoaMxpFcoMwHPDwi2eCxcuR0ORan3VeJjP+/B4NRi0rDlIJDl9v4QpX4lSBDdUiVzcp8Ui6a+tb/RCeLXtd+Dn+9SEO7xl27aMf5WjXXKRnDqV7ktuzKU7udQQKdsqmtmhpSvp3c8NXEdrsScdLWliR0rHLAN6laN8Xp8mB9B6oMA1dI2te4zKp6CmnNwFXzkenkmc34y82Ywy1DFoFhdrVQNmOFIZ+gd7m6+s/9Z9bXrFZvMlzb5MgR8zdll2a/5MDEAlBfmWRwza3cVKaLJfAyFdY9e1sJS601zJREpLjlz2AVTps6lI1f2l+2Xt4VBBI/1ojCS4FaBlnFSNGLewQv7/zSxV9ETXtKG5t9D/C/fYG8iD7k2FWk13hluZnwez1jJQTKwDEEloS383GWrKWLsiQ5TwaHPlRpQjeRf0PpsO/Z+tWGSLSUc/EeQCpmGKHhq9FD9kBtp6zklhQs97pi+TvHzfsG9Nhx4/pfFj3AflU1R9x20Xvb7WK1zoCx2wQQKwhcEHh5qlQLoksl8dgE+H9kh5drXbZ6NNyFyEiGEiu4ByiHRyms8M4XcpBWc1ZSjH6CRzaYRmNa4zJpSGT2MPPHof99FjF9BOTNbbjAGm1bFZE5ZxJugbEdtZmMmSNwT3YuWJ3wvMuoQxAPVviEqc63l2iEFFmtg/yiZjY0HddZhcVmWYx9Nl46jnpGC0EVfTRKpzMewuMfKTxQokvk8dp7zG/BtsS8gfhOQqfrv0O+UH4f2+D8Xz
 I00AyrG5
 S521zzgGW7QgcAMDfPJ/pEFNB+CTY2jYzYaaxkUsCrzDToiAC3GpLcfkhVhb52CSME3SoqI82SapUq62fMK8WLPXnEEC7s+ryRD33gQ98OlylGzV7YQ2AW40RxbcI6z5PKmrTUdXIbFDoQQfAWUTFTRyq5bfd2vlnyvU6W6QfVkfYJMysAMWsbkQ0dC5OcCaFHlkzr12ZgBIN4PFKxSdwzoG3DgtWoyj7AvL+Xj5xmsOJjx7Y00o5wZ89Kza1EDkmWmJh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-12-01 at 09:41 -0800, Andrew Morton wrote:
> On Mon,=C2=A0 1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux=
.ibm.com> wrote:
>=20
> > When page isolation loops indefinitely during memory offline, reading
> > /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_loc=
k,
> > causing hung task warnings.
>=20
> That's pretty bad behavior.
>=20
> I wonder if there are other problems which can be caused by this
> lengthy hold time.
>=20
> It would be better to address the lengthy hold time rather that having
> to work around it in one impacted site.


Sorry for the delayed response, I spent some time recreating this issue.


I've encountered this lengthy hold time several times during memory hot-unp=
lug, with
operations hanging indefinitely (20+ hours). It occurs intermittently, and =
it has=C2=A0
different failure signatures, here's one example where isolation fails on a=
 single
slab page continuously:

..
[83310.373699] page dumped because: isolation failed
[83310.373704] failed to isolate pfn 4dc68
[83310.373708] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0x4dc68
[83310.373714] flags: 0x23ffffe00000000(node=3D2|zone=3D0|lastcpupid=3D0x1f=
ffff)
[83310.373722] page_type: f5(slab)
[83310.373727] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5dea=
dbeef0000122
[83310.373735] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000=
000000000000
[83310.373741] page dumped because: isolation failed
[83310.373749] failed to isolate pfn 4dc68
[83310.373753] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0x4dc68
[83310.373760] flags: 0x23ffffe00000000(node=3D2|zone=3D0|lastcpupid=3D0x1f=
ffff)
[83310.373767] page_type: f5(slab)
[83310.373770] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5dea=
dbeef0000122
[83310.373774] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000=
000000000000
[83310.373778] page dumped because: isolation failed
[83310.373788] failed to isolate pfn 4dc68
[83310.373791] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0x4dc68
[83310.373794] flags: 0x23ffffe00000000(node=3D2|zone=3D0|lastcpupid=3D0x1f=
ffff)
[83310.373797] page_type: f5(slab)
[83310.373799] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5dea=
dbeef0000122
[83310.373803] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000=
000000000000
[83310.373809] page dumped because: isolation failed
[83315.383370] do_migrate_range: 1098409 callbacks suppressed
[83315.383377] failed to isolate pfn 4dc68
[83315.383406] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0x4dc68
[83315.383411] flags: 0x23ffffe00000000(node=3D2|zone=3D0|lastcpupid=3D0x1f=
ffff)
[83315.383416] page_type: f5(slab)
[83315.383420] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5dea=
dbeef0000122
[83315.383423] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000=
000000000000
[83315.383426] page dumped because: isolation failed
[83315.383431] failed to isolate pfn 4dc68
[83315.383433] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0x4dc68
[83315.383442] flags: 0x23ffffe00000000(node=3D2|zone=3D0|lastcpupid=3D0x1f=
ffff)
[83315.383448] page_type: f5(slab)
[83315.383454] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5dea=
dbeef0000122
[83315.383462] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000=
000000000000
[83315.383470] page dumped because: isolation failed
...
...
...


Given the following statement in the documentation, should this behavior be=
 considered
expected?

From Documentation/admin-guide/mm/memory-hotplug.rst:
"Further, memory offlining might retry for a long time (or even forever), u=
ntil
aborted by the user."


There's also a TODO in the code that confirms this issue:

mm/memory_hotplug.c
/*
 * TODO: fatal migration failures should bail
 * out
 */
do_migrate_range(pfn, end_pfn);


A possible improvement would be to add a retry limit or timeout for pages t=
hat repeatedly
fail isolation, returning -EBUSY after N attempts instead of looping indefi=
nitely for
umovable pages. This would make the behavior more predictable.


-----


In addition to the above, I've also seen test_pages_isolated() return -EBUS=
Y at the final
isolation check for the same page-block continuously

int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
			enum pb_isolate_mode mode)
{
	...

	/* Check all pages are free or marked as ISOLATED */
	zone =3D page_zone(page);
	spin_lock_irqsave(&zone->lock, flags);
	pfn =3D __test_page_isolated_in_pageblock(start_pfn, end_pfn, mode);=20
	spin_unlock_irqrestore(&zone->lock, flags);

	ret =3D pfn < end_pfn ? -EBUSY : 0;=20
        ...

out:
	...
	return ret;
}

When __test_page_isolated_in_pageblock() encounters a page that isn't PageB=
uddy, PageHWPoison,
or PageOffline with count 0, it returns that pfn, causing -EBUSY.=C2=A0


I'll work on capturing more traces for this failure scenario and follow up.

>=20
> > Make procfs reads lock-free since percpu_pagelist_high_fraction is a si=
mple
> > integer with naturally atomic reads, writers still serialize via the mu=
tex.
> >=20
> > This prevents hung task warnings when reading the procfs file during
> > long-running memory offline operations.
> >=20
> > ...
> >=20
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6611,11 +6611,14 @@ static int percpu_pagelist_high_fraction_sysctl=
_handler(const struct ctl_table *
> > =C2=A0	int old_percpu_pagelist_high_fraction;
> > =C2=A0	int ret;
> > =C2=A0
> > +	if (!write)
> > +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> > +
> > =C2=A0	mutex_lock(&pcp_batch_high_lock);
> > =C2=A0	old_percpu_pagelist_high_fraction =3D percpu_pagelist_high_fract=
ion;
> > =C2=A0
> > =C2=A0	ret =3D proc_dointvec_minmax(table, write, buffer, length, ppos)=
;
> > -	if (!write || ret < 0)
> > +	if (ret < 0)
> > =C2=A0		goto out;
> > =C2=A0
> > =C2=A0	/* Sanity checking to avoid pcp imbalance */
>=20
> That being said, I'll grab the patch and shall put a cc:stable on it,
> see what people think about this hold-time issue.

Thanks.


Regards,
Aboorva

