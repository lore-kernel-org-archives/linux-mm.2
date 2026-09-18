Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFABC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130976B008C; Fri, 18 Sep 2026 09:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108D46B0098; Fri, 18 Sep 2026 09:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D206B009F; Fri, 18 Sep 2026 09:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAC9A6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:52:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71EE3A5D34
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:52:08 +0000 (UTC)
X-FDA: 85227021936.26.F2974F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6E9818000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:52:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2YePAF5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739526;
	b=cy1ltFgq2zRUFaSK5MHZIYWEw5a/veZ6FMeH9bdBV6u4BTIVno2BY8hPAVah0yGjxhF3CT
	aqAd3/icC/My513MOmSGIZk2uIZjMwwBCe2ihOYsc/g+GxTBmN9WG1cJJk27taHe+Sxmlo
	p1JrSeiMjaYb+jFeDYQ7ZbkQvcioAFg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2YePAF5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pigOYWPBo4f31CFMisvTOnx1I+B1RAOmv4zggET0Nwc=;
	b=2Z6Pb52kkuIZ9MYRm2vpz+DxMxab6C/lHMTCD0s+h/DCuCM0AXz+QCMGAFjEBIrGgYtt7z
	NRXzG+/BW7uS7/0sU9TZZFTzT8fuEgowwoc/MrLCjPMhO+Q0s5si41apG+lZJwR4O/tLJY
	uSUBCPaPSCBgvYLwaKPWQPzn5vmdE58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F251601FD;
	Fri, 18 Sep 2026 13:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2088D1F000FF;
	Fri, 18 Sep 2026 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739525;
	bh=pigOYWPBo4f31CFMisvTOnx1I+B1RAOmv4zggET0Nwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X2YePAF53WPKG42GvCaXfl9rzwpcUTq3WUhHUkxjkRWik1oB3RWNeqcywlR8F3GO8
	 28asPiOH+88PPpnpNJ3Olc1MDvf6jfgRE74fmS4KRQzpWFM7clBzjxF+6OHt5Vor1R
	 NxO5794YuK5jzFBOU4oZtZk8IsymnHrkrAosqsLdWEb1l0QpEokKrq3xkDwHJG2bxP
	 IW6XP9lOS9LVq2YmYC7umJJDblB+IT4e/Jh/B6CnWE3Xp9YSimYyHEAedbKCDigi4s
	 ODYaMYjACQSI1vdSCP9SDeSZ53xBGvv4UPw22jbQQfQjmGN4QITuiSiCftcV2eWV+1
	 ZVqE4BHWCLHOw==
Message-ID: <0e0a0908-8e5d-4cee-9fbb-ce730bb662e1@kernel.org>
Date: Fri, 18 Sep 2026 15:51:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/15] filemap: Add support for authoritative mappings
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-15-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805210557.1118966-15-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A6E9818000A
X-Stat-Signature: 53etct7besa97yhrmm5mifyowfnq6bhr
X-Rspam-User: 
X-HE-Tag: 1789739526-396001
X-HE-Meta: U2FsdGVkX19KaSS/Bw32g/cYFHoOZbIAMycSB/iuJ3E0FjXF2UhiVMhaJa+ZwdakjFDaUNuYSRHTiV+4dSTWRzO5JQ6QkrA8xrWla+7hQ7or+ISKy9ummIJkfRoXw9H+IlVAR0vgCNA0EK71Rz9Ht8T39WXn8JVGA1xMt4Gccwl/jG46gLFRX5x2suMoEqpyWsMraG2iSnM5O7lq9WxPzgijEpuI/6HkQf+rAlyrS4wDKnDNFSPg7iUF33uA2xC/YEfcNTzxY6o15RghmJxFQzkkQvP//DSJDC39m4MyrMsNdMYFCABZG/jWkaVt8B67ggwk56EM8kg/wmabdbpi9kIdoXNwZyc8DALtZ6hHMmH4C0vQLwkpwYEN2ZJjl5d+aWubt0tVCuzoAOH2MQCIMsCPb79iG9mIW+Udpl1XaApxT6KAXivxRIKNrM5pkv9Tv6/5MitiL9/l2VzSbg/Fb6E2cqLLfOtRjyPCnKOF8M89rcolZOoiW6EVf5cTI8JgEHjlncbqmq5JSMHYgmDJzAyvnC3EmFihpig4MesmQEJAbgt5J37RDRxsACc+L4/cF/IfX4r6D1EuLFmshPBdK98GR0+rqG/GHweQllFNsjhLxABHYhzSmVkp9glbqeu6r13x/0weG2Y4Yv2BFZwPDlgh46xywevjefJ0pbNRc/CRmRBT4y7quazcJdubrn137vJz4BPrK8FzBuXo/w7KM5ohgU6ApUQtHOx5c3ViivoH0QXaNB4VNicE5j9frEHj44EPZGxxbjCshvXCktLnIjmrgLnbrT50qhbyQP81Cy1yr1vmpactca98FbuTF+SViI2Aw3Jl9TtSJIQtjeiGEQPsGRgbWq/jaqXAZVwWKmjZoFrrbJF5lZjIwlX9PyA+oZSRrJGj+qhLfF5v6Hce/djTeHWulTusuOQbl4ThIcYT9pW6PPmIGuuMax/h6f6nla8wnGBZNseRs+H52o4
 488wIwKU
 PHsx3ORO9Z0MMqzhxKUYYj4872sTu2hiC9P9BPj49CadAklX/iGGNNRNmv5pdDUrjZwCadAayO3GSKUcRboznVK/aqwxng6H4LRWHZXhVbdB2AKMFW/Ld6Z9yCtSgjcEegPImCiOHGm06vEA+U6VGhfPUaAU4NkVJsORcSQyNfiAM3hG7Dvc4dqNiRGhlgABJ4zpmpOFXbtQPu00RM0QGfJnhcwWk3lL/bglzDll9tJAsqr8lIt6wwhKDsK0cUhYab5RXgLMeyHgr6IZvTKtlNmNpgRd5pNgRYyHDbBTuMn794cVbEWmq7v+tf6+mWLwldEkU+HQf0wsQ6L0CJAcGQKK1u8ky5FnSqGX5vR9cGJstMvRhUE/UsmMINkWfD6Q7SAeffby491UfqTlA9uDRKx5cmxrh8pWCzLHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> An authoritative mapping knows about all the folios in the mapping.
> If read() finds a missing folio, there's no reason to allocate one and
> try to read it because we know it's a zero region of the file.  We can
> just call iov_iter_zero() instead.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> ---
>  include/linux/pagemap.h | 11 +++++++++++
>  mm/filemap.c            | 18 ++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 968b791cfd14..22d48935ffda 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>  				   account usage to user cgroups */
> +	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */

Just curious if "in-memory file system" would be a different way of looking at
it. There, a hole in the page cache always expresses a hole in the file.

	AS_IN_MEMORY_FILE

Just an idea, because that's why I always had in mind regarding that (all state
in memory).

-- 
Cheers,

David

