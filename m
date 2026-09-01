Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8474C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFDB6B00A2; Mon, 31 Aug 2026 22:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4976E6B00A3; Mon, 31 Aug 2026 22:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD366B00A4; Mon, 31 Aug 2026 22:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02CF36B00A2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:53:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7875A16027D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:53:20 +0000 (UTC)
X-FDA: 85163672160.22.A075491
Received: from cu-gy11p00im-quki08153201.gy.silu.net (cu-gy11p00im-quki08153201.gy.silu.net [157.255.1.67])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5613E180004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:53:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=doRGPeHy;
	spf=pass (imf16.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.67 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788231198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFwxo/zpRCxcKDRAJKdqav95yzRNXnhbhRJMR4pdLRs=;
	b=en8GjGjuaxSh+RnshVTLJCsGw48oNpBkDEC+HcGN2/2tKbGHbay97DNBlUu0DnWG7eHr9C
	EB4QBndsKni7MsEnuZ0QHjwd+ZPCit8Si3yWcvdyl/dwxLzxvXagz+90iqtTEcOEi9LztY
	iOKzL2DODuWWCfRB3IYQSEtUVxWI5wc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=doRGPeHy;
	spf=pass (imf16.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.67 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788231198;
	b=cB2vqTMag3SQ7Cc1NATOoMIg6dsaRRUPyttxlMWY1MnGQdLIAlNJt0bKfkXp6PgC1Y8l+b
	6Eaxqq5+JlfpryUNipnfPXqqwuElBDkfvMWy0l77GBgY8X4fbzyaOCB+mP23HhobzUW59j
	oF38gaVzaqRCVjnDwsmpO96xAD7mrUo=
Received: from smtpclient.apple (gy11p00im-asmtpcmvip.gy.silu.net [112.19.199.76])
	by gy11p00im-quki08153201.gy.silu.net (Postfix) with ESMTPSA id 12D6224600BA;
	Tue,  1 Sep 2026 02:53:04 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788231194; x=1790823194; bh=XFwxo/zpRCxcKDRAJKdqav95yzRNXnhbhRJMR4pdLRs=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=doRGPeHyHd5Mavyus4jCNI4CteNrE4ZITQ3azdCrfNm+a6KNO4hp8hzxLxtfUyMy+z1EnfUq7sf8NFWJOz0iM/tO6al3V0FuTAsTXW7gpRhwTfwhDM4kzFz+QL/m4BAKG/7kVtjy3RnwYKeQNDEWI2TXeop0KbM3DKczLytzGHJxOTlg7tTWM6vWfqro36i8eNL/wtx9ApMbnANVO+Qj1CZkuwkX/Apgu2QzDrdbt76nj6gZPQjtw/fsLoncYzQLAgRwGV8WrXEzzycpBlyqJOZzldirYPS3qnb3dgMXF9HUl3ZydEbjSBYHheKlmm2vWsbaS5dXf9Wl7KY2CVEqyw==
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] mm/memcg: clear folio memcg after changing per memcg
 stats
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <20260831191126.6ced4642c6cc92ca96cf0803@linux-foundation.org>
Date: Tue, 1 Sep 2026 10:52:53 +0800
Cc: BINGFANG GUO <bingfangguo@tencent.com>,
 Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>,
 Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E5090506-F629-4DC7-8FC7-B8C3740101A7@icloud.com>
References: <20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com>
 <20260831191126.6ced4642c6cc92ca96cf0803@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDAxOSBTYWx0ZWRfXwvpMRXlq0hub
 JIy06fNU+BfbGYYy/cKxg0ODgxlz5fRk1Uifx5Mn7coscvjIcH2dS1PZXDTqi5yIEeMDi0Cc3bU
 TKgW4Kjn4EomIwCCwSfqeuAf9AvYMYpQA7O4abRuKV4rHzQJUf6UuvtimQXw3MRhc2hugs7yqJ+
 iJtf/YY6BNP0D8AhRswvsWtEqS1c3kWGcMrtrFtlSfd6ABWGNliBP5H7xqtTLXF3d/Yda9Ws9IO
 jsx2216iw1g+ilu046ZzF09GcvYN2vxEoQCFqv1PTWn/XurIY3YO/tg1qwc1oe8x7+3eaI6z9K2
 b7Lk+DLAK8yZXfuceuy+zaLHs9gnygmuGiAru7Urw==
X-Proofpoint-GUID: GXCh5jh2wpVKJlXbedFkIuR4sOiF6NYG
X-Proofpoint-ORIG-GUID: GXCh5jh2wpVKJlXbedFkIuR4sOiF6NYG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_01,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 clxscore=-2147483648 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609010019
X-Stat-Signature: nnpe74b7oqz5bxzxuupgzs8tg8io1zrd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5613E180004
X-Rspam-User: 
X-HE-Tag: 1788231198-191368
X-HE-Meta: U2FsdGVkX18V1ld2WA0Xk0enhl5jTJCEZgG+BCab7CW8wvaEgZDXLTm1NoBoXERsVff2tzDduVJZzrgacAo81If3w2WJ8I8YyxoSJ0sZ70RBXZgpdBc4tfxo0TV2yGKGlAFElmyBPVEfoo/9m81MUWf+Mj+I4DD1ZTa15iWKcdBzHwK6pQr4L8eDiFaC4e8rCW+9XzMSmqMYzuEPMpLMZc94Xl0PcOkanUClwfhCJQgBrB/ApB04Q1JCnQwyR2j6Mtn5Ozs8nZUp0HEhvbSuMD9Uzq5GpYKhZMdrPNqkgTO8C+j9pQ0tV4bBhLmU61ZDzV73m+WObpv70b0uTJwqvJtS4KVL746Ftdg70aU0FOqNfkQWTTKfUfjXJZnhg+jt4EnoZqRG4zA4WGumiTsXE0g8VGVDCjJL82WFqRdjHuL5Fvkk00NHqPfAUrPDFUO6C2R7jtXhxrzDQTUp1zKfSiZ1DModrzFkfBs1gStCukQarpp4pp8TFTfWw1vLyFYYKL0gV3KK3hupQAU5org30sO/QRpLJ7F3euaAENAuwuGJWjnjEQByeoI4hDDrjAeKOPLlitypaUFxZqm6GyuV4zYqlaL/FGaIKcb9MbQ4itO0zciznlR1eJFrKA0FegvoRH1Yhmk4cE0KPSD7teyTJG6wOwoeNFPMxoOeggHSd1kxPXGcGz5aVbumn5H3JQtkwqkRkUxOckJZ9DL0yMLl7sxziGEyK2+IIauc4leCjH4QZtcKmmkRDGOzLM3N14YElLfPrNvaJp8v2RdFzXSDPYFK5T9jcUHnf6dbI1tnuhxjE32J5cDb7g17Y8vJTCuGRZ6hQYKLGJpVrPdUhHwMcCffbcFxxGZkVNxWy4gaEZLy6ctB9dOxiXrzbjraZ3Eqh3Set7TrLVIuRFn6bHbSx7pAYcN9NtJ1U5PVl6/+sR545UG8HDO3IAJ7a9AAQCZoxPVpV6v8lFfzmi8jY5p
 NPk5+bW5
 SOtHwu5BJJBJXFs2C6zCYHxlWxVumLwyuwlQ7M6M+JU0NLO/vVl+DeT3vY+mN406A2vE4QeNEbuqB70r9dPcX7LQ0P/UFrcxpkcuN+uk3EsH0OC/tKVk+a1ImK1CCSr55dymnQJAOiI2ICVvzSkHYrHjbFE5kPRO+0APLESyQkwBQojLngj9sag2SRDfnY1mdUxiiNjqcotu4NJr0oJ+oIndyw2zuCm3srvlic/RnI5+b8Tsh2XYvyWlJx0xeG9Veo0U7QV7oJcdz6+PT0dhOz6Hp8H1ot255Z7WcZ/jtLDrxt7GiGQDiZbxG433tVn+1Yz/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew.

> On Sep 1, 2026, at 10:11, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Mon, 31 Aug 2026 11:32:43 +0800 Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
>> From: Bingfang Guo <bingfangguo@tencent.com>
>>=20
>> __memcg1_swapout() transfers the memsw charge of a folio to its swap
>> entry and clears folio->memcg_data as part of that.  In the vmscan
>> swapout path it runs before __swap_cache_del_folio(), which then
>> decrements the swapcache stats through lruvec_stat_mod_folio().  =
Since
>> folio->memcg_data has already been cleared, folio_memcg() returns =
NULL
>> and the NR_SWAPCACHE decrement only updates the node-level counter
>> instead of the memcg's lruvec, leaking the per-memcg swapcache count.
>>=20
>> Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
>> the NR_FILE_PAGES and NR_SWAPCACHE updates but before
>> __swap_cache_do_del_folio() removes the folio from the swap cache.  =
This
>> keeps the stats attributed to the folio's memcg while still recording
>> the swap cgroup with a valid folio->swap.  Add a swapout parameter so
>> the plain swap_cache_del_folio() path is left unchanged.
>=20
> As always, the most important thing to tell us when fixing a bug is
> "what are the userspace-visible runtime effects of this bug".  Please
> update your prompts to always tell us this, in the first paragraph.

Yes, of course. I will note that in the future.

> Clearly the immediate effect is messed up is messed up stats
> (memory.stat?).  But what are the subsequent runtime effects of this?

Although I don=E2=80=99t really know any user space program relying on =
this
value, I noticed this when testing another patch set by swapping pages
in and out and saw extremely high swapcached count in the per memcg
level memory.stat. It seems that the counter never gets decreased so the
value is rather useless and confusing to users trying to analyze =
problems
and read this. So I think fixing this can be helpful.

I will include this message in the patch later to make it clear.

>=20
>> Fixes: b197d41462c20 ("mm/memcg, swap: store cgroup id in cluster =
table directly")
>=20
> Quite recent.
>=20
>> The problem is reproducible using the following script and program:
>=20
> OK, thanks.  I agree with putting this info below the "---".  It's
> probably too detailed for the changelog - curious people can find it =
by
> following the Link:
>=20
> Anyway.  Sashiko points out that a CONFIG_SWAP=3Dn stub wasn't updated
> (this happens often):
>=20
> =
https://sashiko.dev/#/patchset/20260831-memcg-swapcache-stats-fix-v1-1-1c0=
819ebdb86@tencent.com

Sure. I will fix this in the next version.

>=20
> so I'll take no action at this time.  Please do update the changelog =
to
> include the runtime impact and I'd like reviewers to suggest whether =
we
> should backport.

Thanks for your reviewing and suggestions!


Regards,
Bingfang



