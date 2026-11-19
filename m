Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C0960A2605
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=GK3XiyZ3
Received: by kanga.kvack.org (Postfix)
	id 2CB916B05BC; Thu, 19 Nov 2026 04:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C126B05C9; Thu, 19 Nov 2026 04:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B99E6B05E6; Thu, 19 Nov 2026 04:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0AC56B05BC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:13:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8176F1209DA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:13:21 +0000 (UTC)
X-FDA: 85451305002.01.DF091F3
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30DA340003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:13:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GK3XiyZ3;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795079599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5otj8LqXuoFRDCfkaEq/wgjl2OHeIJseXXzietozvC4=;
	b=1IZ+klWuQ4fUQjk2qxpOwyreKkAsE2LHTmJMOdYFMl2o2ZisBXnoQJuPvvg14v+2H+aITl
	8vH1vZUN2Age9YgYvwT8eTHnrfWRQztzKl7J2ftPFqOfpsdgFpAOGwIcwBHlrDsbH0chzq
	C/K/E+xd40UPuEDUl5X4T+JMjO66nQo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GK3XiyZ3;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795079599;
	b=N43p/Q3hrbGNP8fdgZPJxzbzvN55WeGUccvYQnwrQJXTOvKL9uC9ukyjZFC46KOiSQTbgs
	CfSKBLB5QS3I8voxCDeZQZI8+SATyOtHPTzmDvyx+mvkj3y3f3khPOmGiQjj0Yq+VKx5oa
	KO5BJ9/bsHyTZv3brzOhNj5sL73uwd0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5otj8LqXuoFRDCfkaEq/wgjl2OHeIJseXXzietozvC4=;
	b=GK3XiyZ3IW4xxvuorR9RNJih0Lpv7RqAAGTqcDKRnsRseb27i/YtNCZbqZfhHLNqYM+CxPvR/
	qGEFJzt9DKKgSirKs2IfFS8TygX4xkfzY6xKHTru62jgy0YeGvwtp+eOv1X1uOQ8Qt7fZfm+qYY
	KmvYI9xY/heD9XRwmsQvveA=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jVXmf1gGGz1T4Fp;
	Thu, 19 Nov 2026 17:12:34 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C6C04057D;
	Thu, 19 Nov 2026 17:13:15 +0800 (CST)
Received: from [10.174.185.4] (10.174.185.4) by kwepemo200009.china.huawei.com
 (7.202.195.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 19 Nov
 2026 17:13:14 +0800
Message-ID: <4550c77f-aecd-4d6a-963f-fdaa2c243100@huawei.com>
Date: Thu, 19 Nov 2026 17:11:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] kho: drop the incoming sub-blob debugfs view
To: Mike Rapoport <rppt@kernel.org>
CC: <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>, <graf@amazon.com>, <leitao@debian.org>,
	<corbet@lwn.net>, <rdunlap@infradead.org>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <hewenliang4@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261119063800.698863-1-longwei27@huawei.com>
 <179507678647.425130.13205346175314463200.b4-review@b4>
From: "longwei (I)" <longwei27@huawei.com>
In-Reply-To: <179507678647.425130.13205346175314463200.b4-review@b4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Queue-Id: 30DA340003
X-Stat-Signature: f1fhjpepwsxzj4e8qzfaamftjo1r9skc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795079599-209473
X-HE-Meta: U2FsdGVkX18WSGOJG/Mu+Ir6ognNrDAnki5Pfmfh8Jd+Q+x7pOyMDoL/GvoCMAB6AktaMA340akzp+gCXbV3IjwiD+EuZvP24NvRkkQUJRmmcoF7YUZJvCjPLPkIxO/VTeEcKJBWRq3nZruV+h2VSuc884rufpLu6XWokF1bNfqcw3cexlqnqTghJ4/k6qCX9ndBsnEwlevDpD856JmvohdDHGPHL1RTlibsAGFJi4dEnAmvAW5zDqIFt+FMYYRQLyIxTYy7tEktNL9oEjzP/b4RNgOTne8Nitz8K+E/F1sVBmdUMwBMqdRPopPMQ82reSQJ0hkHENzH4OITUrT3g2S5cooHdwtwatEd5FT1mPknks0e6sv+hDwJgM66xouBylUP9EtjqHwvPsnntJfEJnFtJXK1i78fh4EBLnVYl9RBu33GgzEKattiyOS3qZr0KmdmOkDpocjQv5LSHabbPNE1+4PTprcRRzGDaeA9qBch27/mWw70EiqUbSauBBfrxs/aOQv55LULwtegjmUYuxsphSmau8sq1S1eppv2ADMqtsTkZsPSQXtozvTzvCu0IPg6ZRcEFW7tMKUYSaVeUVWV9WFUiY6eiDuRWmTG48PTJ4hym0PcRSJ2T5XEIH7X0JEOWC0SaWkULrM6KYf8fcV43hop7cXrB3a2+wcW0VjHnLmHQKylzCfJOhw/YU6kd2WKLBNRSLrlKgVUhwqG2e9ygtmFpYMbBiPsZWemgYwc8elj0Tw1PZQE0Tnc23a01aObqhKdpUMpH3r+eNebqrbeBbKzb5bXKt3nsdegzJo4HMlZkH9KL92mTRpd2dzI0I4H4v43oOAHpijT3Ri4W0FlLyKBDgZb61LI6ghed/q4SJpp0CAjxmvkND7Zt7QyPo37kd+6fUNscyHuUliJvt4+gs0nwqt3hXAUtearGsBCX/gwe3brkWjoSx+T614kL1IyUGm2lgO8B1kxIM5
 i3A5UBLS
 tH8wM4mkwELebdXcu9yA4p2Hwda6zTZV3dg/W5j7PY7YFKNXnsKCDRyDvtCjQaW3+aOhq81pAwH/U+s/d/loOo09M5YhAxEkrFV4ci6zEZeiNcLygtVV4t4pUrqnHL/i1NNknjkIYNCuJulWpsjnIsjZxe8vYsvhFEzphO0wU+bzd7GR+o6v029ogGwg6pKVR7An8847zgYIzNMR6L29KGiusGxaUcrIeNfmsoZqv/S+wAwDL1Pu8ACjNVluIbR6G7UNVvRcIc0z3fx3IaLoP6LLhyWsdlv4a+hGnkfjjWd4lu50Zhm71xDGIa2ChGx47NL4a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

Thanks for the detailed explanation! I now understand why c609c144b0e8
is not the right Fixes target =E2=80=94 the pages weren't freed back then=
, so
there was no UAF. The kho_restore_free() path in d376e4b55c9a0 is what
actually made it reachable.

I will send v3 with the following changes:

- Fold patch 2 (documentation removal) into patch 1, so stable
  backports pick up both code and docs together
- Update Fixes tag to d376e4b55c9a0 ("liveupdate: centralize state
  management into struct luo_ser")

Best,
Long Wei

=E5=9C=A8 2026/11/19 16:26, Mike Rapoport =E5=86=99=E9=81=93:
> Hi,
>=20
> Please don't send vN+1 as a reply to vN.
>=20
>> kho/in/sub_fdts exposes the raw contents of the sub-blobs described by=

>> the incoming KHO FDT.  KHO does not own those pages: they belong to th=
e
>> producers' consumers and have independent lifetimes.  LUO, for example=
,
>> restores and frees its state in early_initcall, before kho_init()
>> (fs_initcall) creates the debugfs view, so the blobs point at pages th=
at
>> are already back in the buddy allocator.  Reading them triggers a KASA=
N
>> use-after-free in _copy_to_user().
>>
>> The same information is already available to user space from in/fdt,
>> which KHO does own and which stays reserved.  Drop the directory rathe=
r
>> than adding another interface to describe it, keeping the -rc fix smal=
l.
>>
>> Patch 1 removes the interface, patch 2 drops its documentation.
>=20
> Patch 2 is only four lines of documentation for the interface patch 1
> removes. It could be folded into patch 1 so that a stable backport
> removes the documentation together with the code.
>=20


