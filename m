Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D06CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 12:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7509E6B0133; Sun, 31 May 2026 08:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7286F6B0134; Sun, 31 May 2026 08:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666006B0135; Sun, 31 May 2026 08:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 522B06B0133
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:32:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E453A14041F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:32:29 +0000 (UTC)
X-FDA: 84827653218.10.0297936
Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	by imf01.hostedemail.com (Postfix) with ESMTP id 433894000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:32:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=kftf0BIl;
	spf=pass (imf01.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.233 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780230747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/IQEuJKp1VJoy4udOyAYdmQ9yI1MCUv8iwbFRHaF/w=;
	b=IbmX5xgpLK89u7ssThrlCTJffwhQdgWtIazLqs6H2j/V6yQlIylTuh9dSjVMyrdUitHI9x
	rT+SA/qYmLdftO53HPIm72u9H5pkT7sGO3X1jT7RMSQMSd+Up8aySXZ0zWm289QpmRJMUu
	yC9bsIY2RlLpLuTiBE4c88olUU4sJLU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=kftf0BIl;
	spf=pass (imf01.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.233 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780230747; a=rsa-sha256;
	cv=none;
	b=MybzQE1Lik4qpv/SQOQJAwnZJWgPlUwcbGVXlZ7z/+RD8XkZvjNYXpja1+6HAWN0xNepYC
	RiHMBCxKbisKvyr/xDXluWl/lf3cDAvZPXjZ4AZ5Qa0lqfK8KnzEt74PLQKBLwnv+9CPI6
	rFGLVRYP0tAyOyWdcimUvL7GFTf7e6o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780230743; bh=K/IQEuJKp1VJoy4udOyAYdmQ9yI1MCUv8iwbFRHaF/w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kftf0BIlJOXU74s4m6Rfgownd3BoHPEeSUPOXkIE7C78ZT+ixejWWpuYNasZhJBvv
	 UtMefi1uccD7M8i6pfNnmRCDdJMkCYn6ZDAFyRmhszQA8A1PtyxoxMHBWfyEME50YU
	 SMDmYHip9ZxNCaXd3uyFsxctn5U6mZKT2B2e9rtM=
Received: from [10.24.9.42] ([123.112.11.230])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 81406E17; Sun, 31 May 2026 20:32:20 +0800
X-QQ-mid: xmsmtpt1780230740tnz4j5psh
Message-ID: <tencent_5D829B5E0B0E2EE9E703C5BAF9210FC71107@qq.com>
X-QQ-XMAILINFO: MpYZqmNm/7vMIRPcSJYS9hiFZYUADiR5EYlaoZ1a5F9FpE3aEtCjwILTebpTgx
	 m0lgVEFF38sLsaT+yIBZ9NdVeNb6kboHgTsMn0Ne/41wot7N69LdHhxJt7KqRciskmoSNEwwm/35
	 EuKhAOkqBAJLEOhhKsbk4PrAjgWnxEnDE/UJbWcqXNdt2r5ColifSlvqEHzoJ2pUxQgSIOlVPiS9
	 b8I3Xlp7QzK1QboGHHHGrPL56yDbouGJEDh8eIn5Texl73wzUSLf0rOajeboX/dm0tpLzC3qhXts
	 42iBE5GDiYMJW1a8CcTTkK+y8Qfmn5Dybj+RKlUZf2IZ9g/wUlBlBoEB/vimcBpyEOcpG9ESdDIf
	 ha/ulXdPQiL9DshvMFfPzkinOCxcmVz2dJL1pdkoCJgMojdTrJ6AH4+rANyiPN92G5oRNCsCXUDP
	 2FypvGcz4CKASuv0Yx6/sL0lw+ZsGE6fnz35xjwkrPcZAJwwijtupa9dFOtwcaNndy+Hh5kn3Sgn
	 KZPkpAvJuEu1BiKfGou2oRB0jgHLE4P/OacvwZhxlO4ZkA2wL/EVJ8aF9Ikf2HSU4wIs9vqpb/LY
	 3l6yVaZsE5Xv69MUi/V35C4n91MDnYfldMUhtqnfOshD2tiyUowjaedy8RaMfbnSpfsW2TNFe1AR
	 HTf7yIHtGV7JJxW+UxwqjFbIR+i+bGpfoVW/r1n/jL7ykyhElMZem1U0hRP7aFaBUGHNYjbY3j94
	 7r4Dko43tQVwZTFumK4vuk0EfRV7VLeJWzzgYp2s44Rtzz5mtc4gMHKgbx+wfoqcT+ctvQohNiYq
	 eF4bukIIPqcW9uwXtoZUNJEp9j4ha476RjiKQCUBP4/Co1cSD77skwPXAE0FabimMdLz/Z6LKV4C
	 j5hgfz266huOfWJrBAE9TEWcH+qpPVwwGA/uW5C9AQfF+TdkD+KFr0pY2vZ+60BcOJusq1JI1A9U
	 ofEO0+t1QWIQRHrcQ2NUbLu+IxvMEKscgcnFtqe3BDFChEBwMVsi5WzfmKxfQAAojiKWbO4gmMPb
	 8KeCenDVVFgR29nPcLxNT0ohaehScugj7SIx6UlAM3ilMISz2jjADPFrR4ViteBZ4o12J9WUKCoV
	 kEhpluSKFT84+H1P6NSNABgmc1HA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-OQ-MSGID: <abbc260f-1fc4-4469-95e0-bc9d8c2ed2b0@qq.com>
Date: Sun, 31 May 2026 20:32:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/9] mm: support zswap-backed large folio swapin
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>,
 Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <CAKEwX=PdQb2nDbFaZYuRa9_mYrMCnMEJHpxxABebKkVz+OgDHg@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAKEwX=PdQb2nDbFaZYuRa9_mYrMCnMEJHpxxABebKkVz+OgDHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: c6hyhip7azusgpbj6auatjn34pzqkcge
X-Rspam-User: 
X-Rspamd-Queue-Id: 433894000D
X-HE-Tag: 1780230745-651058
X-HE-Meta: U2FsdGVkX1+mFjq3E1eX6jyrnkm1Rg7yAi911Vwlx5+sxdYER69Ob+KNXh3GwsdM8Gd6Acf6lMVJDYrVtC4zDbeqtuVNhCK69NmBt4kANyv1HvR1yDOFyvUkWNMgtU6SZQ8tPzigSerWqT7A490uBYz06hYfMn8bx+MAZ5/dzU+UqOcaKSElFEuq3o8PGxGd/uJV80uxoQgNO75CbmwggN/3elb2qQTXqd6ips1g+zf5/WAeB4Osirb9s6ZPujSnCvUnXSpCA8uUB7/O62Mhx7v7MK9nB4tfXVmv7LxK57XPVjDtx905H3X3QGHizxzs8fAfY2dZcRf4zuQ+XwDfi/lIerd2lqDp4Uw5oHsQYzJ9xx2wtTp1laRZHEuJ67k40YFoGzFW7MboPqabtZGtflOjFhxfrb93N0Sa0hZv7+/TMJptpAQSMaKa55R7JwnkWy25Gt/uwAlg7nvMQ1EIwLQZC2/lreSoGJuJa2SBaeZTHwCrMIfENMAtbuvyOv83w9aUQZBVDga5Dai5ztcdRdw147Q/Db6AQGdR1yuZCEnVve0LfdmlTOii6oSyA2UbeFGV/P9u1wZkmJ9vIWHlNRhoRtGzHbR8uzrYwuktt0Bc1v3rYehhPjwhJhqqoZa1WYO5F8kxe9DvpXKXabW13P9teo+PMtteuCJFf1TPY3hZrwM4DfEX/QSjoOkb5GNoRNvZYmGTJfdAA94BTb/q6cCJMb2g68732XOY9+OdYdQyS7eIyxN44UJ3DlCkcogIqwoH5RmScywJrKw/A7Sek5cNdIlFYpMj2yfTgJ4QroxsnJS4IDbJJY82gti7xsJI72/otxaF5IUbEY4GynjVmLxocTs+QFbWU64MN3PY/5zykQicI+DASxBuGZ7W4vvgPaf4JyQSnhw3+Z4JMlravSqiEfUrpXIU+ZC50Lo6AjcwHEyDHxhv9dwYslzQwx+5zyjFWVxjuZ8dVCoKHnY
 BsIXc914
 KhC64nUiYzo6MJqSf8R025JBG38paQX7Qn0a0Isj301QUxNAvJq1mzvIW+HSwBzlPo/bhd8pztJW46avSRx/LXEJmeREhgOtEUkEMyvDCU4RhyN1hz9kwQ2IPd9R0vP/MxQCohZIzVztmKPaa5uH9OIMCpPTVnZSNmUPpHdd0nLyQbeyZez/wnjJiOFWZUBfNqBlGk8HSVfbkO6wF+EDrZHpS4jTzEDL3zvrHOgnIQKS0CK+/X4oU6oYirFsJfngszx84qsGiy2gcrGl0mdqGE/KrlHE50uet0ZtgI8zi0Q23SVLdwVz+qiv95bVN6h8TN/xoAEoJjKzi6Q8wBGTLz3hGlC6ltJaTx6iIV69n8EeiK3D5wBxPK0AIIrJ88D7kpMrq+5M5oOEW42hcT7MPDP39udTTt8zyN+97ObD+BP7msiDdBiGTz5db7ZrJA2y9UFwPZYdgKxotT2Ry6xujX/lHTupc0VTrZsAcJLElXFCtkr7B6/z51g6yKJJ/tyJbqsqI6BoFgz234u94BjDry7u4Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/30/2026 2:06 AM, Nhat Pham wrote:
> On Fri, May 29, 2026 at 5:17 AM fujunjie <fujunjie1@qq.com> wrote:
>>
>> Hi,
>>
>> This RFC explores large-folio swapin for ranges that are still fully backed
>> by zswap.
>>
>> Large swapin is currently disabled once zswap is in the picture. Anonymous
>> faults stop considering large orders after zswap has ever been enabled,
>> shmem does the same, and zswap_load() refuses large swapcache folios. That
>> keeps mixed zswap/disk cases safe, but it also loses the dense case where
>> every slot in an aligned 64K range is still resident in zswap.
>>
>> The series keeps the policy in common swapin code:
>>
>>   - zswap reports backend facts and provides the large-folio load helper.
>>   - swapin_sync() filters candidate orders by backend range.
>>   - all-disk and zeromap ranges keep the existing Kairui large-swapin path.
>>   - mixed zswap/disk ranges stay order-0.
>>   - all-zswap ranges may use a 64K folio after locality admission.
>>   - anon provides locality evidence from VMA hints and PTE young density.
>>   - shmem starts with explicit VMA-hint evidence only.
>>   - swap readahead uses its existing VMA/cluster window as locality
>>     evidence; it does not also run the anon PTE-young rule.
>>
>> The backend range probe is only a snapshot. If the backend changes after a
>> fresh large swapcache folio is allocated, the common path drops that folio
>> and falls back to order-0. zswap_load() can also return -EAGAIN for the
>> same retry path. If a late fault retry keeps the large folio in swapcache
>> instead of deleting it, the cgroup v1 memsw swap owner is committed before
>> returning.
>>
>> This is mTHP/large-folio swapin. The mappings installed by do_swap_page()
>> are still PTE mappings, not PMD mappings. The expected win is fewer faults,
>> batched PTE/rmap work, and preserving the large folio across zswapin
>> instead of rebuilding the working set as order-0 pages.
>>
>> Prior art: Usama Arif posted a related RFC on 2024-10-18:
>>
>>   mm: zswap: add support for zswapin of large folios
>>   https://lore.kernel.org/linux-mm/20241018105026.2521366-1-usamaarif642@gmail.com/
>>
>> This RFC keeps the same broad goal, but moves admission into common swapin
>> code. zswap does not decide the policy. Mixed zswap/disk ranges are
>> rejected before large IO, and the first cap is 64K.
>>
>> This is a rewrite of the RFC posted on 2026-05-08:
>>
>>   [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio swapin
>>   https://lore.kernel.org/linux-mm/tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com/
>>
>> The v1 series was anonymous-only and kept too much of the policy near the
>> anon fault and zswap paths. This version is rebuilt on top of Kairui Song's
>> common swapin infrastructure. It keeps admission in common swapin code,
>> rejects mixed zswap/disk large ranges, and adds separate locality producers
>> for anon, shmem and swap readahead.
>>
>> Performance and behavior
>> ========================
>>
>> The A/B tables are 10-run measurements. Elapsed values are seconds,
>> shown as mean +/- sample standard deviation. "phase" or "refault" is the
>> measured refault subphase. "zswpin" counts zswap loads. "pswpin" counts
>> swap-ins from the real swap device; pswpin=0 means the refaults were served
>> by zswap even when a disk swap device was configured. "RFC 64K" is the mean
>> number of successful 64K swapins.
>>
>> The numbers below show where the large path is used and where it is
>> rejected.
>>
>> zram-backed zswap microbench, 64K mTHP, 8G guest:
>>
>> +-----------------+----------------+----------------+--------+--------+--------+----------+
>> | workload        | base elapsed   | RFC elapsed    | delta  | phase  | zswpin | RFC 64K  |
>> +-----------------+----------------+----------------+--------+--------+--------+----------+
>> | usama_1g        | 11.260+/-0.235 | 10.301+/-0.140 | -8.5%  | -22.2% | 1.000x | 16381.1  |
>> | nohint_seq64    |  4.398+/-0.085 |  4.025+/-0.022 | -8.5%  | -21.1% | 1.000x |  6221.1  |
>> | seqhint_seq64   |  4.283+/-0.060 |  3.948+/-0.062 | -7.8%  | -20.6% | 1.000x |  6223.5  |
>> | stride64_sparse |  3.095+/-0.051 |  3.086+/-0.025 | -0.3%  |  +5.8% | 1.002x |     1.0  |
>> | random64_sparse |  3.095+/-0.046 |  3.076+/-0.016 | -0.6%  |  +0.7% | 1.001x |     0.0  |
>> | random64_full   |  4.423+/-0.067 |  4.405+/-0.018 | -0.4%  |  +0.1% | 1.000x |     0.0  |
>> +-----------------+----------------+----------------+--------+--------+--------+----------+
>>
>> The usama_1g row follows the shape of the 2024 RFC benchmark: allocate 1G,
>> fill it with compressible per-page data, reclaim it through memory.reclaim,
>> then time the full integrity-check refault. The seq64 rows use a 512M
>> target and 768M of pressure. "sparse" touches one 4K page per 64K region, while
>> "full" touches every 4K page. "seqhint" uses MADV_SEQUENTIAL; "nohint" does
>> not.
>>
>> Virtio-block swap device present, zswap enabled:
>>
>> +-----------------+---------------+---------------+--------+---------+--------+--------+---------+
>> | workload        | base elapsed  | RFC elapsed   | delta  | refault | pswpin | zswpin | RFC 64K |
>> +-----------------+---------------+---------------+--------+---------+--------+--------+---------+
>> | seq64           | 4.399+/-0.100 | 4.279+/-0.216 | -2.7%  | -10.5%  | 0      | 1.000x | 3110.7  |
>> | stride64_sparse | 3.103+/-0.047 | 3.119+/-0.086 | +0.5%  |  +6.2%  | 0      | 0.999x |    0.0  |
>> | random64_sparse | 3.142+/-0.112 | 3.097+/-0.030 | -1.4%  |  -2.2%  | 0      | 0.999x |    0.1  |
>> | random64_full   | 4.473+/-0.147 | 4.445+/-0.088 | -0.6%  |  +0.9%  | 0      | 1.000x |    0.4  |
>> +-----------------+---------------+---------------+--------+---------+--------+--------+---------+
>>
>> This run uses a real block swap device, but the refaulted data stayed in
>> zswap. It covers the all-zswap hit path with disk swap configured, not disk
>> read IO.
>>
>> Virtio-block pressure/mixed run, zswap max_pool_percent=1,
>> low-compressibility full fill:
>>
>> +-------------------------------+---------------+---------------+--------+---------+----------------+------------+---------+----------+
>> | workload                      | base elapsed  | RFC elapsed   | delta  | refault | pswpin base/RFC | RFC zswpin | RFC 64K | fallback |
>> +-------------------------------+---------------+---------------+--------+---------+----------------+------------+---------+----------+
>> | seq64_full_pressure           | 5.908+/-0.195 | 5.790+/-0.235 | -2.0%  |  +3.0%  | 90258/99038    | 20327      |   0.0   | 3730     |
>> | random64_sparse_full_pressure | 5.104+/-0.069 | 5.068+/-0.090 | -0.7%  |  -9.1%  |  6201/6196     |  1297      |   0.0   |    0     |
>> +-------------------------------+---------------+---------------+--------+---------+----------------+------------+---------+----------+
>>
>> This run reaches the disk-backed path: pswpin is non-zero in both base and
>> RFC. It is mainly fallback coverage. The RFC does not install 64K folios
>> for these disk/mixed-heavy ranges.
> 
> Ok this results above look good. Basically, if we don't have spatial
> locality in access patterns, we don't do THP zswapin. Nice.
> 
>>
>> Policy matrix, virtio-block swap device present:
>>
>> +------------------------------+----+------+--------+--------+-------+----------+
>> | case                         | pc | hint | pswpin | zswpin | zswpwb| 64K in   |
>> +------------------------------+----+------+--------+--------+-------+----------+
>> | pc0_seq                      | 0  | none | 0      | 99559  | 0     | 0        |
>> | pc3_seq                      | 3  | none | 0      | 99498  | 0     | 0        |
>> | pc4_seq                      | 4  | none | 0      | 99512  | 0     | 3109     |
>> | pc5_seq                      | 5  | none | 0      | 99657  | 0     | 3113     |
>> | hint_none_random_sparse      | 5  | none | 0      |  6265  | 0     | 0        |
>> | hint_random_seq              | 5  | rand | 0      | 99488  | 0     | 0        |
>> | mixed_seq_full               | 5  | none | 97725  | 20147  | 84    | 569      |
>> | mixed_random_sparse_full     | 5  | none |  6230  |  1302  | 0     | 0        |
>> +------------------------------+----+------+--------+--------+-------+----------+
>>
>> The pc rows show the readahead-window gate. The hint_random_seq row shows
>> the explicit random hint veto. The mixed rows use a small zswap pool to
>> force disk/zswap split backing; most mixed ranges are rejected, while any
>> remaining 64K successes were all-zswap at the time of the fault.
>>
>> Kbuild pressure, zram swap, 384M memcg:
>>
>> +----------------------+----------+----------+--------+--------+----------+
>> | setup                | base     | RFC      | delta  | zswpin | RFC 64K  |
>> +----------------------+----------+----------+--------+--------+----------+
>> | zram swap, 384M memcg| 2060.323 | 2047.516 | -0.6%  | 0.991x | 2797     |
>> +----------------------+----------+----------+--------+--------+----------+
>>
>> This is a single-run zram pressure smoke. It did not show Kbuild
>> regression, and the RFC run installed 64K zswap-backed folios. The result
>> should not be read as a tuned-performance claim.
>>
>> Kbuild pressure, virtio-block swap device, 512M memcg:
>>
>> +-------------------------+----------+----------+--------+--------+----------+
>> | setup                   | base     | RFC      | delta  | pswpin | RFC 64K  |
>> +-------------------------+----------+----------+--------+--------+----------+
>> | disk swap, 512M memcg   | 1420.671 | 1409.263 | -0.8%  | 0      | 7497     |
>> +-------------------------+----------+----------+--------+--------+----------+
>>
>> This is a single-run pressure smoke. The disk-swap Kbuild run also stayed
>> on the all-zswap hit path, so it is pressure coverage with a disk swap device
>> present rather than proof of disk-read large swapin.
> 
> Why a single-run?

I did run Kbuild a few times while debugging the series and did not see a
significant difference either way. Because of that I only kept one fresh run
with the final tree before sending the RFC, so this should be read only as a
smoke test, not as performance evidence.

For the next version I will rerun Kbuild properly with multiple fresh
iterations and report it, so it can be used as a more reliable
performance comparison instead of just smoke coverage.

> 
>>
>> Shmem smoke, tmpfs huge=always, 64K shmem mTHP:
>>
>> +----------------------------+---------------+---------+-------------+----------+
>> | case                       | refault hint  | touched | 64K shmem   | 64K in   |
>> +----------------------------+---------------+---------+-------------+----------+
>> | nohint_seq                 | none          | 65536   | 4096        | 0        |
>> | seq_refault_hint           | sequential    | 65536   | 4096        | 4096     |
>> | random_refault_hint_sparse | random        |  4096   | 4096        | 0        |
>> +----------------------------+---------------+---------+-------------+----------+
>>
>> That matches the current shmem producer: explicit sequential refault hints
>> allow large zswap swapin; no hint and random hints do not.
>>
>> What this RFC does not establish
>> ================================
>>
>> The 64K cap is deliberate, but it is not tuned. The anon PTE-young rule is
>> only anon evidence. Shmem has the framework and explicit VMA hints in this
>> RFC, not a page-cache locality producer. For larger orders, the anon
>> producer should probably use bounded sampling instead of walking every PTE
>> in a 1M or larger candidate range. The mixed-backend tests cover fallback
>> behavior, but this series does not add mixed zswap/disk large IO.
> 
> The mixed IO can be deferred, but I think we should figure out a rule
> to extend this hint to arbitrarily sized ranges, and preferrably shmem
> too.

That makes sense.

The current 64K cap was intentionally conservative, but the locality rule is
too tied to that size. For v3 I will look at making the admission rule
order-independent, probably with bounded sampling rather than walking every
PTE for larger ranges.

For shmem, this RFC only uses explicit VMA hints, so it does not yet have a
real page-cache locality producer. I will think through how to add a shmem
producer with similar semantics, so the rule is not anon-only.

Thanks,
Fujunjie



