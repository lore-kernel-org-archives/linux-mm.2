Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5E1606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XzAFPkN7
Received: by kanga.kvack.org (Postfix)
	id 96EAB6B00EF; Fri, 13 Nov 2026 13:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945766B05B1; Fri, 13 Nov 2026 13:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836D26B05B2; Fri, 13 Nov 2026 13:52:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1966B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:52:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EC771601D7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:52:01 +0000 (UTC)
X-FDA: 85430990442.29.DB81165
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9E504000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:51:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XzAFPkN7;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595919;
	b=5QEwV2iFBnw+hZkDkqeF2YsXVUSgNIgBSNZrD/WNr1MgDOtOG3vt3xgT53Z4rp1scysz3U
	lJtYeOBITwBp0nWkPvlIUSYW87dikYP4T5NWZj9IyKPBud3fMQU+w/luz/UonU5qucER26
	cVTInkM5j09oi+GZTG6LOS/k59SQ6mY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XzAFPkN7;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5muRXWS1rFjtRwmxUHcdPdK+9QBRwjjtk/I3ke8eqss=;
	b=uEcJCp0+xfWOQhXTW/yhWW4LEQWRD5pXsMP5sFEplLgesMFeeSbUHC5mkgEdtfVoLjhExY
	RF/1NGAFZoWec7ryLgSRGpx82gRaQ/EGRx/uIES376uKT6ThRMUR39IMoW21rklpdE0JLD
	87u4NbhykjWEw8YIoWeOXQ41vJl5SbU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D443941B11;
	Fri, 13 Nov 2026 18:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B0F1F000C4;
	Fri, 13 Nov 2026 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595918;
	bh=5muRXWS1rFjtRwmxUHcdPdK+9QBRwjjtk/I3ke8eqss=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XzAFPkN7MUXlKgAkmPOQRLSCSAt2PwqC0Kcv+HnyUqadeayf26mt5dOB87zAhmnsL
	 rCM/LOn1v4X8mo04YABi6kewxSg+rOZSdDxrb5UOebeOVDzcvlJzot+uNTf8h7Ixtr
	 dhn82CAc62qemGvmxq0ChSKEdR1156L63Gfde8CamKm69f2i7gWALhNCtLos241caU
	 SMUSWuXj2DhPLnm+iDL0xVjmBG9PQVccC5ep41dBb7XuYBjXOcqMPAR+VbhxURTeMW
	 Ivqjv+vG9iPHvq9/l7fzKDH3I7PS44kkVRvz88GIIpeGHqch7+hqspqTFss6NGgs+4
	 90lFUZKzvLglA==
Message-ID: <3314e44d-dbfe-45da-a1b0-8337784a5e86@kernel.org>
Date: Fri, 13 Nov 2026 19:51:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-7-clopez@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112142039.907090-7-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A9E504000A
X-Stat-Signature: yb4ijj7iew4nqjanq856e44ao1pcecfa
X-Rspam-User: 
X-HE-Tag: 1794595919-598983
X-HE-Meta: U2FsdGVkX18GLULmz/bpG/cXyg4bFCSVhY3fqGyggWW0c06skOg/hiZdTuLWj+oKc2hViGT+M3N0s4+sAA0cJWNX2uwqoAeLo/YnjrA5VU0ShGCoH88IDz1v89I2H9VNTaoyKUM7CwR61xJl3zePhHsG3Q1sL8cVWG184o5t729Gij1mIPd12ZRY3/rXftL3WUXKswHd1u5eUA0GCKSpHVrEowSIKy5NfuWWmzSQOU2lGh3FtReLQm4uR8hpXxXE9WGuPQR0ckQPJM8E+ChqouiMgW1VnJiJi9FH18hFMO2fGkSitVd7qSKkDEdlG/kMRHy4rCzxt0RyXXmVr3Xfsx9F/sCqhNDNmMvjys7N0EzcEppLMpCoDA6tTN59MY8HIdsTX4ZXP/ZKZVzCAaAaViTVsgWadEZgtbAHPibJklx5tvumwQPUBoWEb5WOV/mDoLpaY0lolmRAcdKInrIFi3HsdDavaeKyJCl5GFnl3LPBS0w9rZ+BnetQjfD+9uZdcSzrlGaG7VJ1iYVJC1o2HBZyTIG227kxkgyzAz5O++kRBu+JccoLleh4tw/S1D4tvQ2xxPzRp/jEgNmckndlKeDh64ShCUC9OKPywHAmbrVoN4ZGKl7eNtjI8SKu0eco96VL2CQXNZ45TkrKzKTp0PeJ7eWzYreU9fKNbXphB42VXrZMrawie1xPJprRLHmX3hy09hvRIIZvv4zoJoXvg1ZwngIY5G622MrKFPgkcHPQauB7wGmhKNqrzD8lhdPmes08fYP6XIiMEU1vU62LU3VF4QintQyYK3J2dndPsqEa4rZcPWYoCQ999BitQeEUqwAbLZs0hf+qwSRHMoNXk5bietxiubh/gpADWCeVmCdW/247PbqLVisHrleKcN4LAK4ZEHQ0gEbTHpOI0Zk1O2EOY9joO1xGf9Zm+iQmeqGTV/ApjsR9tPE1spLiRHcI5PKtV6ONBmAwhy62X6E
 aFii5Grh
 C6bsEj0/op9p+/RACt5Z65esNXO7J2zacJ2bQaMVLYzZC9qbM1Ak6A7Uz2O3/773cy5rjjE5L/X0XSu1mRTo33ukdISxASQDwRxphpKwJrBo9s0h6RykwBzAMdqBhHSLxOjXJoZcRnVghZ8Ymlo4Wb2KpXTh3RE6oXKZGxtAsYX0eeMwh4tnWbS+l47xxy4QN8CwBCYuYCatJZfQyeWvZ4p+xI9xVhu8Hdmf75D+MPNKUSJVX5EQ+fXOgYQnk+LY8B0ZJIQLjm7jYtcM0TqV7TzqW2wn8yWXXul+PmQAnCAqWRj5rsHFmY+B3Lh6UjyyaYBkQLjJdRvnnMKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 15:20, Carlos López wrote:
> Add a change_protection() flag for changes that only add permissions,
> so that MMU notifier users can keep their mappings and fault in the new
> permissions later. mprotect() sets it when the new VMA flags only add
> read, write or execute permissions, or VM_ACCOUNT, which does not affect
> the page tables. Any other change, such as a different protection key,
> is not an upgrade.
> 
> Signed-off-by: Carlos López <clopez@suse.de>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6af3b7008f1a..001829a61405 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3585,6 +3585,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>  #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
>  #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
>  					    MM_CP_UFFD_RWP_RESOLVE)
> +/* Whether this change only upgrades/adds permissions */
> +#define  MM_CP_PERM_UPGRADE                (1UL << 6)
>  
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 84bcfe0281d3..8c0fcd10f5a3 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -767,6 +767,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
>  	.walk_lock		= PGWALK_WRLOCK,
>  };
>  
> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
> +				      vma_flags_t new_vma_flags)

Two tab indent.

> +{
> +	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
> +	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
> +	/* VM_ACCOUNT does not affect page tables */
> +	vm_flags_t mask = VM_READ | VM_WRITE | VM_EXEC | VM_ACCOUNT;

Why is VM_ACCOUNT a permission upgrade? At best it's "no change".

What am I missing?

Also, what you really care about is "no permission downgrade", and "no
permission upgrade" is not the inverse of that ;)


-- 
Cheers,

David

