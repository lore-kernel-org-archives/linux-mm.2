Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF80360A2613
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGnVxSpJ
Received: by kanga.kvack.org (Postfix)
	id C02286B05B2; Fri, 20 Nov 2026 13:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB29D6B05B5; Fri, 20 Nov 2026 13:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0F86B05B6; Fri, 20 Nov 2026 13:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765C96B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:35:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFAE1160160
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:35:22 +0000 (UTC)
X-FDA: 85456350084.25.D3B0CDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 47FF816000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:35:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGnVxSpJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199721;
	b=XaI1THbBlGTruKiEe7xjjnuSPyHvvMZCpINWNGsCZy0nBEknTAYqeBhOJMNlG0JbgCb0WK
	1GIv9pAJrKoTr9+H1qnC+iREZeQn7RvS24DasFsYK4v432UMEfe9p5dTUoXK6iy8m44oDx
	0K04k8rjRbq5WJXgC4VeMalnwE3nxOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199721;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9i7EBLWiLY+Ax+szjOTrErjeUkWZA+e5Jk/kHB2fTnM=;
	b=iZMFz93i3YeZJXNlZi6vafSXqF12A8eVuI9rolGT6UyOYOEwl7j/oynAGz64qSPAYCNMqu
	CJxovpIO5jiB/g0GS3yNraeCdty8TcDcsqccFk1o88QpoK5F8BwnKe/YBgDLCxRAwA+kB7
	CE7U9AslxHcMOA6SCnfVXkBjyYiavj0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGnVxSpJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80B7F44465;
	Fri, 20 Nov 2026 18:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B9F1F00A03;
	Fri, 20 Nov 2026 18:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199720;
	bh=9i7EBLWiLY+Ax+szjOTrErjeUkWZA+e5Jk/kHB2fTnM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hGnVxSpJ97jRelrIDpBEeoCAz9DdKg+K4WDztt2Qh2dV7u04H+j3/tDRMMG4IOG8M
	 RxxlIx9iSqG9HlgwOS5hj6DXh4Asq+yz0rOgg81LQELzo5cE/pjnQBqWpEqCqwnwOe
	 g0QyeLFtJq2weIGX8bCivqiVgN5Ocp8vzj1MxdcKGRlJwN8Z8A4SCAtyWmd/40Ttr4
	 z9uYk9u8MPceZH9f6nWh5By8yRNux2WZNL6fqAXOorjmOaP0U+naK4eFrZsKa2b8bG
	 1GDe17P+olC0crZjKZLqdbnbhOc3jOxxt+2eTAfpmCfZjk4TVEuW3NVVGcD/rRHe+I
	 Oa5btytoKzgPQ==
Message-ID: <sashiko-outbox-225847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 58/60] selftests/dax: test memory policy on private
 nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, "Yury
 Norov" <yury.norov@gmail.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Johan
 Hovold" <johan@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Byungchul Park" <byungchul@sk.com>, "Alistair
 Popple" <apopple@nvidia.com>, "SJ Park" <sj@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Michal Hocko" <mhocko@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Pavel Machek" <pavel@kernel.org>, "Len
 Brown" <lenb@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, "Jann Horn" <jannh@google.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Dan
 Williams" <djbw@kernel.org>, "Vishal Verma" <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Alison Schofield" <alison.schofield@intel.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <20261120-private_nodes_v6-v1-58-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-58-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:35:15 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47FF816000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yfajrzqqeb15nue8iz8dbgqe3c8ajpii
X-HE-Tag: 1795199721-281537
X-HE-Meta: U2FsdGVkX19Wg07vPYEySLgJCqwoXqSkvXX0fcY5i9E+XXcpZwax1qQAEYU6srZM8IQgQ/5uZaLz4IzzcwdxgubjYJqVy3+nl3pwm+gqj4uKC3BBZYSKoAmC8aDYRp7DD39jguJmpWx9tdhYCUDYnhc8nn60B25aqFYmYlg8DqnNioZW8AWZMMlo1dsTAe3R1n0x5ZGQ36SAjCmwk4Q9elphbBDQPAfQjS276PiwJ84Jzh7gylfy8Y+IOhKcBrxJQf0DTcslrcyhpnNuW/7wPcKs0rOmnC1ztVo3Irl26plmsP1TEvwxRfnlvZyU4pFxRXfMMKrzEzdDaM+RkNm++Tpbp0Tl8jlc3eyrzx5lU8OFW3ShFlqlgjkrR/4KVazCrRBTogpxvI4/LaRUXNZA8+eB4ho86vDTccD95iJRsfERtnzWyULGMCSXqCicl2UYo/hYKembYFpHDDS40KOjqbzDFFN7YDdozetdGQ3TOHutKbK7nkzbXdNKrD5AfyIQb4fd0bZNjs1Lk/hUijh0TxjgwoXDsj6XLADx0+O7fFeRWaFJNTSFru5qcUnUmWaYTES4NdbInQVP0Lp80kUetYzxSKJtHpjA3IXihQeLbm3AdNVpdHj2MQTa7UeK/Z0XNjdbglxDyxYnZ3d8cSEbilC5ZzLUOJjkUV6oBxFtb1J4+cylR2UAB5iEU6+nskK4nRJtWe0fi0MRadIHBaqvMlVLgIj/V0dQRJ3ToDqIuz5FJNr/jvjVdl//Yty6xWScyEniGfK1Lw0nd4aKYhpZ1XmP6Nt0vNtJTrVkSaLkmG+mGK7qctAIlAZ+kbrWvnyp/wyVtSa156g/UuFEatoRJ+2HmkbY36pMizyK/OcwYd/Voy7tFNmuWKtC5I0Cd3k5RFS0H1QdD6z2qTZx7sScwNWo8S/TPuj/PVRBqja/nWMCVPD4xh5ZOTL3w0awTDUpxHljxYi18ks9QmPKv0m
 ROYnTeXr
 UqxZYFNFiQNMib4OKBRmJDAUxlCnEGTFIIklQETdBEiBc1WLJebXEHPb+PLbzao/mARyDyIDzoHU6dUdEi2uuSBg6k/sB5tacSwby4+Q5xVKprhNnPbcze9WGQXC7bkQq/zFqbCJ64rj/wQn9D+Zey93H5pyjmd8bjHXFF23rw25Eo0oSfsd0YWfpVnlHEIBYUxRC+hRPIv407vJ3IvvRKsL5lDbJqjJ2fh33QyYVTvYCr6oPQDe4L0NS1BPXXdVkl6zxCgUglQePP3UV6VU9bPTEtP6fknKfmdWzVbpRHpbl/FmIZTlD10WzXdYel2H2SZdRX0of/+GBa8RoEjwwkGYau9pheAw22j++WVLXa8G+RU9AJeM+uws0+kfAnWNxHk8OhcklK3zJrfW1vKfBpcgsqvpEZkAUcjhIACTySZUD4c2IB8/+6Cs9LantYt0S/xNgpwoiVR90AaUkyTpmbdN4H92seHue6smO59EGREJgNsQAXygX2mNeiyuemacIorT00gpwT8Zku+Ocr42GIEB1hzSuFMVCmKtb1BGxZgUJQ/2+Ab+6BhC1kj6HTvfDaXK6yFDd+/CJYsYN4tfBgbdqb2XDyEohY5aoLS54cWqszTuSpdjFx8haf5PL/tDyMnoI3PckLnBmnJv1gABdypxwjwEN6vvmmSEBSmKRhTC1b74vri8wfPBdFJDHCO4tVWA74oKS2Uu2NMUeXSwa98fubnP8EbCR8eE6BcjAigWO0T1Z/DDqMgmdt8B/zUiogMg817C2ZCd0JZuE3uDDNNt6+G8GlkLUCxUCQLC4Aknhe8RDn+28s+d94USY/KK6tnR46Y5RjA1IhKlVH9MVIwtDth76WTrZOVg33aG+Porshs9EYCXoCoSr96knl0vNeDEXzF6+BVRggtViHrMAIK82mv5IUMgoC4Uu1nwdR0jCvW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] selftests/dax: common_policy() resets task policy before
  faulting pages
--

commit 2c509a362d5823231bce734e3d872af08303fbb5
Author: Gregory Price (Meta) <gourry@gourry.net>

selftests/dax: test memory policy on private nodes

This commit adds a selftest tool and wrapper script to verify memory policy,
migration, reclaim, and exhaustion behavior on private memory nodes.

> diff --git a/tools/testing/selftests/dax/kmem_private_policy_tool.c b/too=
ls/testing/selftests/dax/kmem_private_policy_tool.c
> new file mode 100644
> index 0000000000000..0769436b6068e
> --- /dev/null
> +++ b/tools/testing/selftests/dax/kmem_private_policy_tool.c

[ ... ]

> +/*
> + * A relative or static policy whose mask names the private node must st=
ill
> + * place memory on common nodes, and keep the user's mask.
> + */
> +static int common_policy(void *addr, size_t len, int nid, int requested_=
mode,
> +			 unsigned long mask, int task_policy)
> +{
> +	unsigned long reported =3D 0;
> +	int mode =3D 0;
> +	long rc;
> +
> +	if (task_policy) {
> +		if (syscall(SYS_mbind, addr, len, MPOL_DEFAULT, NULL, 0UL, 0UL))
> +			return FAIL;
> +		rc =3D syscall(SYS_set_mempolicy, requested_mode, &mask, MAXNODE);
> +	} else {
> +		rc =3D mbind_mask(addr, len, requested_mode, mask);
> +	}
> +	if (rc)
> +		return FAIL;
> +
> +	rc =3D syscall(SYS_get_mempolicy, &mode, &reported, MAXNODE,
> +		     task_policy ? NULL : addr, task_policy ? 0 : MPOL_F_ADDR);
> +	if (task_policy)
> +		syscall(SYS_set_mempolicy, MPOL_DEFAULT, NULL, 0UL);
> +	if (rc || mode !=3D requested_mode || reported !=3D mask ||
> +	    madvise(addr, len, MADV_DONTNEED))
> +		return FAIL;
> +	memset(addr, PATTERN, len);
> +	return pages_on_node(addr, NR_PAGES, nid) =3D=3D 0 ? PASS : FAIL;
> +}

[Severity: Medium]
Does resetting the task policy to MPOL_DEFAULT before madvise(MADV_DONTNEED)
and memset() prevent the task_policy cases from testing page placement under
requested_mode?  When task_policy is set, both the VMA policy and the task
policy are back to MPOL_DEFAULT by the time memset() faults the pages in, so
the relative and static task policy tests always allocate under MPOL_DEFAUL=
T.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D58

