Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E01606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2qNYQkE
Received: by kanga.kvack.org (Postfix)
	id 9706D6B05CD; Wed, 11 Nov 2026 04:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948426B05CE; Wed, 11 Nov 2026 04:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EFD6B05CF; Wed, 11 Nov 2026 04:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF466B05CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:35:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05EE112024F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:35:48 +0000 (UTC)
X-FDA: 85422331176.13.E19BC58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3AD6620004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:35:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2qNYQkE;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389746;
	b=B3wozrtf1sg4EYSUnaoMGKEcbtKf6RPcoKbXf+HA/e/Nyva5ebiYLAEba0kXF/Un/u/bSF
	B22KwmMf79oPZm9wWSgm8aqLWTYwMHqhPEGEt3xFiE3cIY9GRO/7av33uC3qEwvT1FxHCJ
	1XkilFBFF48yvdMpwUqeew1bVx7hfjI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2qNYQkE;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9X8CCswIaiCe2k/d80ea7S7jWAHEKF+u255fg2VFMFw=;
	b=p/wE5g7KESPHBnr7bL5tXWs0syhcojuc6C7JajDU+Jv3fJsjvEFltxC6Lp+N6N4c+HdYXA
	NTktaHWeE6VIGq3xJ3F6Buja//OYFFq+4i8Dpd3Y8UwXnrpg5vtZGJvj5ZyoBzky5N+nmV
	LXfAoL1cWrmGq6/ipaIWuzDWMzYko08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8803040145;
	Wed, 11 Nov 2026 09:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19881F00A05;
	Wed, 11 Nov 2026 09:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389745;
	bh=9X8CCswIaiCe2k/d80ea7S7jWAHEKF+u255fg2VFMFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T2qNYQkE61kCIR/UriUiEp2Xe+xDAU4E1joo4LXujXTT1NiLFqQTbEsOAsAo2g5bK
	 hG0PCYjhQ2JRcdXyUEN7VcGwBsupQZ6hAxvCLVilPlRb4MlylhqRGPyxI+BFNutXCt
	 D0PHRPnp4Nz7HgQeYs1joXy4FBbJUpsLYykHZoqr4I+1MwtIetWyqpKOam8RZAV5u2
	 4ELqRRMIndDcRR4uw8FynIaqqaRRRb04+OVZl2kxVj186R/6T/2+swrwHPsSk235q0
	 LK/ktYI3fqYgg3oGJ8cVWMbvVzIdCQRYtvjdprwTT78fEBSuTVxMJBHQSIBUMepRuk
	 7nL0CN6YmKO8Q==
Message-ID: <f796b3fc-90e4-4fa7-997f-8df8cd5d2b47@kernel.org>
Date: Wed, 11 Nov 2026 10:35:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: only assert mmap locks if CONFIG_DEBUG_VM or
 lockdep is set
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-1-be293ff499a7@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261110-tame-vma-asserts-v1-1-be293ff499a7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3AD6620004
X-Stat-Signature: bcp1quxrk4cr7r6t7b6wshdmzkebg4wq
X-Rspam-User: 
X-HE-Tag: 1794389746-711397
X-HE-Meta: U2FsdGVkX19ezWXbLwQI608rLkydwnSGGcrhHuiBA7vGDEJzO0xlcgWUYTGJdBS4jiMJPRd+Y7Zk8Ejf1XU+oKSTsgypHSq8hW8JMd+mqYRxAcYNtdl+0FThxOTH3qCMeN7j3GBeQZX5BfyZLzFn1ZcOkv2heeIzv6gKLUUnIPTOcV7c4RE3jEHWSMNezLKc0IFqahAe43DrbMwsUG9SPM1mQ19w8YuJaQacmSenSO7NNOVbxJHM0pCvfKs1vVHSlj+Gh66lePtGDQN4HzchYp1tsJnSNIWrX6RTm9O4ID3ZSl1dTD5AzLfZjAAJrGNfmgM270s3GjxNldqLZ4RttVjcXX9GZNtzyK91vzYN0hkS3hrxQxHkPHSDmav62Q5TLNKy6OvQo+LWXNcL8adt+ocMpaQUyCGKPRGS2FOrQo8ilT70GLtdDwRQDuS7obqtufoopkSFKTIQwfAHqPr6TUPEkRK9JFXbhIr1K3a+5kswEh/vme/XDI4gq25ee/nG8r99Ew2HDg8WY0YiC9Q9r3sGLnzEFFrnxGFmHp0JsBY/xfTtf5iFMOYGMpR2sTZU2zPL+adgCamSfX0JFsWLst2w4PIYf0wVFJz/KYzIDi+hsdE+86gUYLvS9BqPuQ531nLGoqM6K+CePROjCWpEVr+ItouWEekyUENVJpuqnpfJ4g04Jrq46bRtSmcXEJRB6k4n/bUOClNReBI4+PQFwzsX+3RES0e4jSM3hzklYtw2b7QoI3+feP8J6AFVeKiGdVdUEPUAkt4x7hOe+hK2wGRhBSyzimWiQQLrXrm7B4qTLPYyhh6OG0659XPnijIOQw2OXO1ftR/7qvD7gYRrU6EHGn3uuFQnAIWfuGvGCpz99R8dqpAO6vOqhAU4Acnm9WGKCgXE+Ko6yhpGuqa06VsGQ5oiyyS0xwudkxwnPusP3aEx4iBSDrkexr94CiHSD4kQnqSv+abCs55CY60
 4qGs1BxW
 buieJXn9YWgNpIR1KOmUYveoXRi68yadsa4buB18JKmQuf3odbbWd8dISmy4JpWZ/Lyxdpuj/6cPhnS5uj3Jeb+tMDSkY0zWSYkOiEkySiM26/JzhARv7D8MRyP5sSY0vkIdHqq8F4inQULDPR81xomFyIrDkPGKykBCp5Im7VG9bHQvYXLBbArV40B4n2kIN6JMw1lJlryiHLplxAufN3es3dAUc8W/lzm5hQnB/6SB7pPWiJ9bDGQ5l5tVUkLC/AvYPOkg5rrgLAtWtEsuEF8fgHHvOWBKnwh6Ow0a6TIAVjUEM29OIm/W9DG6ABpVyvz/WDonjCA7UDfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 17:57, Lorenzo Stoakes (ARM) wrote:
> For a long while we have asserted the mmap lock being held regardless of
> whether or not the kernel is a debug build or not.
> 
> In general, given that these have been added as programmatic asserts that
> nobody did something stupid, production kernels are simply wasting their
> time checking for this.
> 
> It also means there is a two tier system - where some programmatic
> asserts (e.g. VM_WARN_ON_ONCE()-checked conditions) are only checked for if
> CONFIG_DEBUG_VM is enabled, whereas others are checked unconditionally.
> 
> If we genuinely want to unconditionally check for the mmap lock being held
> at runtime, then that should be made clear in the code doing it.
> 
> Regardless, if CONFIG_LOCKDEP is enabled, ensure that the lockdep
> assertions are performed.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mmap_lock.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9c3a9c6525c1..9367430ee53c 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -75,12 +75,14 @@ static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)
>  
>  static inline void mmap_assert_locked(const struct mm_struct *mm)
>  {
> -	rwsem_assert_held(&mm->mmap_lock);
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
> +		rwsem_assert_held(&mm->mmap_lock);
>  }
>  
>  static inline void mmap_assert_write_locked(const struct mm_struct *mm)
>  {
> -	rwsem_assert_held_write(&mm->mmap_lock);
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
> +		rwsem_assert_held_write(&mm->mmap_lock);
>  }
>  
>  #ifdef CONFIG_LOCKDEP
> 


