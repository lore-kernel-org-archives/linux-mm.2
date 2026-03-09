Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706F1F417E7
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDAAF6B0089; Mon,  9 Mar 2026 10:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67EA6B008A; Mon,  9 Mar 2026 10:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D696B008C; Mon,  9 Mar 2026 10:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A82C96B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:40:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45E911C177
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:40:18 +0000 (UTC)
X-FDA: 84526784916.21.AC1B811
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F5B5160008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:40:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WKVmyBqz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773067216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78XiyVEUg7vGrertM04znCvlNpOyYSbTOnnNBeQMIco=;
	b=pOVpBUL+pI/jjTLvq9MJr3PuZ/62PxD4hwILuX+3ZLOBAx5EqidsXBapj4W6uQ/H92XEEH
	IAKONbubJY9gghOOWDpnrW8qDo4IcM/ftlpU7Eb1/aS2yoN+K3B2KDKFwklhfb+a2v1736
	be+9tkLj0zswrXfoWo9m1mjw3K+emfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773067216; a=rsa-sha256;
	cv=none;
	b=ejMV8/+dl1vprlEebaPoVwof+1LnJAOSH3ioALpcrq2vXiJMB6Agvy5MTeWoZG4aBGv9rA
	Li/cZ5PvjKI7PBt6J5MHbbwKW5y5/6WvkjBXrGKZnIw3anQuIpQL1mJXzVLRrSc06qIJU7
	cs5n0c00BA2nZTMGcopG/vyGiMwRL4c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WKVmyBqz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA3C860131;
	Mon,  9 Mar 2026 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCCCC4CEF7;
	Mon,  9 Mar 2026 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773067215;
	bh=ZLLLkW/s1i8/71ePIXo/PKDXbD9ammGF3iP8su6Z7Ac=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WKVmyBqz6CznqEnFUEpNoZ8OOwktJHVXETw5slKol1Q5o5AxE9VyPdjR0SjA77on2
	 +v6KL2KikLGQtFQ5seBiJrmr14KsMvtR0+qgxMU1T3CGQKOZOQauZiF2f4a48JN7ff
	 +YaNHyEaBi9PTbJcQsswv9X5wK3dyRPfN7eFT7QteKTn430P+AqtBkaG9EtcHWJG5i
	 uk/WM09jkhiffuaswXCI4UQL0fS2Xhu1uc7MAAgRD3GZEEnNGYgOwxSrKwsrwZGQ7v
	 iFeZUNeEt4gnXKnqbwZY0pWBJVWNXHpHzlEo0Lrt5I5AqiDt4X+WZWQv31v4H/oPQW
	 /O3ng9otzZVkw==
Message-ID: <7c5295ae-4546-4e33-9074-8c2adfd2bc13@kernel.org>
Date: Mon, 9 Mar 2026 15:40:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] arm64: mm: implement the architecture-specific
 test_and_clear_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F5B5160008
X-Stat-Signature: oanjpertpx9zsax465t47ez5wkt35fgk
X-Rspam-User: 
X-HE-Tag: 1773067216-258079
X-HE-Meta: U2FsdGVkX1+kGCyqkvL8RWVEMBW+Eycj1fKDjvEA+G1EgdVizyIYAPOHMfXZ783i3cYSFXro3f2w8X2quMl/AecjfkGsn5c2sRfxbUKDJr9yyNDyioP81zGAQwKA7O+mawtb8PlHy56TYo8htghghdXu7kFAZGrS5jUfdFjDtRjKvXGuHGaEfT8Tqy8cHslZPoR/AlAGNhVBi9gRmOqmfTAvHmihRqBEz3qBnWFlxTWN4rAue6rlQo/Kqs4nA3gTvhi3vYXsBHGefEUNUo5emXVEDbDgjt8UNXCbE4xWSqkEv5ztkB2MYGEzlf3iDpNejJ9Okhi4WY2cZFMRCENGYTIz7e2rOLsoefsdxLzB+Zk/4ac13rEoBpT0aXRkr1x7Hn8miBwpETiPmYnWCKysa0G1bMaeuslQpAiM96pvhrRwccPjALT3RkmsvSgpMCIwchB+mPLBbfGsLbJ+7z5O6QSJbRWs0bd/fFcrkbaYskgiFYOa+uIsUfy66aTtooyPy+NnitmQV0FHQABT4JBo/wv0DUg8+j4KY/59wY1XO75h/Dcza1a+r7pF8YrVzdQONdUMzzj24FUXPYmLqn583FGHtQGEupHbCh9KyvA0Q4fwU7L4ccavk2O2RfTS8Lz3xmGj/SGDFPO3uNFBPBGRvm03kFmsBzC7fNJp32pk5Cjf/KeUCom3/keIkIjN7+gYK+myTxI9FBTgW7IwecEIyEAASOhYxhTJ2O5bjUmWP70/ep6qC18AL0w0FloXma/H//btE6STP6VopN9auRpP+OCoPU6NVSaEG3XZ4GuBxbPq7OePsAJH9Cdu8sqSDrvJK5qnnCStMBPhF9nUFLR9D/A+e0dkd6N1gvqFsG0yGmIWeQhX4w5QYPjC7VvANFHEnCc0K+jHJHU3/KwSsUd7w+jTvbILHQxEadKtGWGPP4d56c5B+3YZcCocc6FR1iHbI++MvsOJbFb6poBp0E2
 /gxB707V
 OTM/eVUxdTbWVvdoMg3F5RYvOgWHAsLj0oZ7BE47ZoMQ070dr2asMowUgtbm4h4AXmJKoGQWRgFRYP+B9M9tVU89h+jVgXO5/YfPUxRM3BBaxILnaKT84ZZIa3TO1uaty4ZxTRthdXxDnwJ2WsWraK4TJaIMeKlJVQN2ecC3nehvYQRPQJ1qD5gFSHT6d1qkzcdQ8jaC7ZNFDsgk1lJalm09mxt6ESGS1PB4B/1EQXPPj20kQHf701FktZto2IH6RydKSKKdSEZGRay2ZoGrkb/cniOhG3fsZEhDbRl5YN7Q+9G1m/2X0HikaaN2TwGOHYVcWzN7T8ezBqr6Ij3wpXMRbH4RXK2s6cVqS/Y9CKAM0lS9xq30+IygjSO8M4mMFf2geYY2zASkInnKqaJ5Vm1J2EoRz1wXv20hy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 07:43, Baolin Wang wrote:
> Implement the Arm64 architecture-specific test_and_clear_young_ptes() to enable
> batched checking of young flags, improving performance during large folio
> reclamation when MGLRU is enabled.
> 
> While we're at it, simplify ptep_test_and_clear_young() by calling
> test_and_clear_young_ptes(). Since callers guarantee that PTEs are present
> before calling these functions, we can use pte_cont() to check the CONT_PTE
> flag instead of pte_valid_cont().
> 
> Performance testing:
> Enable MGLRU, then allocate 10G clean file-backed folios by mmap() in a memory
> cgroup, and try to reclaim 8G file-backed folios via the memory.reclaim interface.
> I can observe 60%+ performance improvement on my Arm64 32-core server (and about
> 15% improvement on my X86 machine).
> 
> W/o patchset:
> real	0m0.470s
> user	0m0.000s
> sys	0m0.470s
> 
> W/ patchset:
> real	0m0.180s
> user	0m0.001s
> sys	0m0.179s
> 
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

