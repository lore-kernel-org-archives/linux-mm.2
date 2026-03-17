Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D5AFED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23EC26B00A6; Tue, 17 Mar 2026 13:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFCE6B00A7; Tue, 17 Mar 2026 13:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE656B00A8; Tue, 17 Mar 2026 13:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE2226B00A6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:17:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 928ED1602D2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:17:13 +0000 (UTC)
X-FDA: 84556210746.29.A010350
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 02EAC2000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:17:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fW3gcGAV;
	spf=none (imf13.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773767832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7UGPDzTUVntWZ7B9duUilqk99yTEBA4ZZT8dgC32yk=;
	b=D9lVnuMof9WqSh2wcZSsl6nJgOt5RRZ4CsLYXLm3ipKmfTJdrx7vMocEVI5dm26CeKgp36
	4ykakLnHKvqK20XPTNniTdNEcG/6cnMpQoDUHWoxnC6ehUrLv8qFntkMw41z6yA7K2Xmu1
	DzLnzq7TUpk4yjOxxQjADZzJma2PtWs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773767832; a=rsa-sha256;
	cv=none;
	b=f0HsOfO3L6XsTEvBpFaqFu8NMLu/VCKptzK1fJT4w2SDTJXzVzvaa8Gnz0SznuyNkF5YHO
	YbHtTk9u+KQMx3m69h/16LwzPoQT/wNA3YKrMqjDso3H/ECc9Yegsy6lqoGV38tmNT7ojF
	gy0dba5O4EAhPu+MDYc4sp/kohCbDmE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fW3gcGAV;
	spf=none (imf13.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=v7UGPDzTUVntWZ7B9duUilqk99yTEBA4ZZT8dgC32yk=; b=fW3gcGAVDEtTMh6YEqK00To3LE
	E4vX2+ido/HbsOQoVJFpyOQG8MkuNFk/E6SWu3xt9EJNv1VepyJPxAoDpYU+4gwA1lqENuoyxQQUU
	BxZlVyhx5jFqLEXJ4Blo1OEIeYj2mqnPp+tV4oOx8nM/SJ2OjN4XpA50/D1CYXVMAiqxcwljSrxtj
	aII+ZZGMUiAwqiO5CvsUoVN7Sfu+W2aZAZ1fGEGZt1XszUbplnT20qOWZO8cCD6zxGWS4ip6rIbs/
	TWmv/FFAmxU0V1/pmR8qpoj7Yta4qbnAGkCr3hDqeg8YIH9UdboGs6mLJ1e+DN2Biah/oGmGRLT8U
	XYWItKbg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2Y2R-00000006urx-0KUn;
	Tue, 17 Mar 2026 17:17:03 +0000
Message-ID: <68072e04-49e6-4418-a465-6a70dbb01f13@infradead.org>
Date: Tue, 17 Mar 2026 10:16:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 05/13] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, richard.weiyang@gmail.com,
 rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org,
 ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com,
 surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de,
 usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
 wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
 yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032427.233282-1-npache@redhat.com>
 <9f0b8790-eace-4caa-a0c0-45f66285887f@lucifer.local>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <9f0b8790-eace-4caa-a0c0-45f66285887f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02EAC2000E
X-Stat-Signature: md1bm7y9a1dqxzciad3qdjqidxfcus6o
X-Rspam-User: 
X-HE-Tag: 1773767830-943510
X-HE-Meta: U2FsdGVkX19bNNOrGCEZNrljv+AkutITTDyC2yLcRwvzLSXfxtoCQkA8gjbACMNml0e+t4o1KHt+afGP8xM9HyZKF/esafhCRQfiN6Uw2Ms7OCwmgeCtd1mwCmdwXGDDOod6Tlsegb4tZKCFZDvwnFuE4bwTHf9Qpltf9w+Qzdedo+/olNRuMqolfyYFYErx2dlve7EDQXOrROB+ThorRYk9JJDYu1uw5WzUw/CWepwbRd1E4Lorzy09f45dtoFJ7oCU+e7M6UKS2XDK8QW1A0xbzPlksE9PKYbrnpMOJfnszsM5bIWaKea9Vk7OwhYthQNOjnuxf0lUBghvquhTFjCCnR0mvjoJg2S75k35yw4UoJxxOs4hSlqQ9vl4vVNZL0lUH3jnJJjqnE2xS1JUEmqNdY3t8oO1vthWrgQlqK5dezIEbXhQ7IiTmmDDmuF0U2cyAipjUWAVqNkvMKt+MMkRjYFJTCFd/Wss05JaD9Tn60SfeKE6n4V1/una+Vq7KJuAhxzPPNI/ndbtB1G3TFea1vMOb9uKvQ4nSVDkKkhl93xLWC/8QGIrLItlnNPx0Y/snQTfpBWkPBbQyS54PmwyCSMN02jn7KzzIiZTqAhBGu+QTTJsuOtwGqYnNiBSManpw+7BOEpZPJ6+OX57ZoDZQOebaq955nYrOZo9PbhuQxqllIGKBy7M2tuedf8GmEUArrqUzGqnpLEEy+3gTUFQbMOl12GFeBDneTZhZ2rOaKBUMMj9oYXvXHUzRLN1DNzWx1v0Iq5eKFARpfqPwwWHgAgfOlOqwMPoIlKqmgWF7MIeY16lzXfITyzAdxZ8iiqYRkpPcx50F4udKUuaj9XXstFu5zltkk7hktqWce8NtjYR6T4euDyRrB0teAMEw4K0j1LOVEJ451Lp+95qFGYfQQOmYxDvplU+Kxa5VhfbiuOUGYI7xyBWETZ+DVOLWEPXTaI/AB1YJiqUW1Y
 1xJ6WYrl
 LKcvdZwCXzD03e0P6BCFJnfNhBDg34r/Zz2IksgL0h++jHr0VSYQyZCbp5HWzZWp9DqG9KIn5UGQfRauxd2CTtLzyIWiaAmEY9k9i61haodF4tuaxA925Y0VsIwieQPRwltBvruoOdwQVXxxAYTkeFzdlAjUUSxx6w9KxucnFuVyi96Fpw6bNJ54wmpRHXLF7Qu26abrgrKG3dpmOTBpT7K7tHsNVB//GHlG7t2hacgBx3DBuT9yfM1yaXvqkgILLxe+9aL5FS15BRXJE4vdYRe1GyOzSgQxNCwZBxkoY8lkOPoITTSAXtTuZS/xx9nHpsbwCiHzO5URaXUygOICRt4essn+k75AH8p1OhpFw0w6UjztLsC6qfabT5mWbwUcj1XGIpv9g5ZBY4eECHkVLCxjSg3l2LKsra+5i9lIQwIXDrTxGnyhPSvvc4rPm2bQ586prjcVaPrW62zOP1AHPuKbPU4Jr3dTA3uBDsNckWxuTE9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/17/26 9:51 AM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Feb 25, 2026 at 08:24:27PM -0700, Nico Pache wrote:
>> Pass an order and offset to collapse_huge_page to support collapsing anon
>> memory to arbitrary orders within a PMD. order indicates what mTHP size we
>> are attempting to collapse to, and offset indicates were in the PMD to
>> start the collapse attempt.
>>
>> For non-PMD collapse we must leave the anon VMA write locked until after
>> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> The '--' seems weird here 🙂 maybe meant to be ' - '?

"--" is common typewriter(!) style for "dash".
Single "-" is a hyphen.

-- 
~Randy


