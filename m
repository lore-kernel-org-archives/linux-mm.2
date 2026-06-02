Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACB7CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11F36B03AE; Tue,  2 Jun 2026 06:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8DE6B03B1; Tue,  2 Jun 2026 06:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926256B03B3; Tue,  2 Jun 2026 06:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8343B6B03AE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:07:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2709D918E3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:07:35 +0000 (UTC)
X-FDA: 84834545670.20.0BAF8BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8C96E18000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:07:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kv2fE0bp;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780394853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FArUgwzqGxSIYq6nsRbDRcCSW+jo1FsCY7Blcc7Vo5I=;
	b=lN6BBWM1YwtAX8h/QvrEIAuM4yXVYcRMa8vnXUYK2S/M3+S4N44MSV2arUne0B2julLAEL
	91kBPbzHmcAsfv8ISLa1l9pnJRJqWfz+3prUaChtlm79/ocNNFwNK7qjGmxVAnajxSelfg
	yWS/30QKHM+3aySjBruO2c8UG17SYA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780394853;
	b=phbSd+jhWsT6Y5KhB85o/dzC8Wxk2uHulWdSEFcLYAlRRIA8O5PZaOeDh5aPlJXNPV2xY+
	+aps66Ki1G/gAoy4wl1mqsjdu0ir98txb86FrRKaScULdUJYQTCgXwWatuTSEFPRrLmrUV
	rFIh05zRqF9RXACWDrjlyytFik9nqxk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kv2fE0bp;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1227160126;
	Tue,  2 Jun 2026 10:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B312A1F00893;
	Tue,  2 Jun 2026 10:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780394852;
	bh=FArUgwzqGxSIYq6nsRbDRcCSW+jo1FsCY7Blcc7Vo5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kv2fE0bpyQXoK2UWojz99uTNM13VMJzQY8pttiWpI5b8+40hTJICG1z6mCK4HxzOt
	 WGAj2y5SJlJoIl+N9iHLKqVRWu9OrrHnx+/tz3FlIfzs7MJKFsAGpGxzFWxuyG8cBM
	 WrYnPscz8yfDI3CjGm3n7wUsfcglUz6lNDXUt3emdSCW12sVz1MKY0/BHu5mWG7lyI
	 dN+nfzkHl4QQvZFfAGkcO2JVbFceEzmni/FhHhQ1tddV0QOElD5gWZUecDoh8qPAX+
	 6wu9anSgJc0s666UALU4wXlDajOMwgfjPzHsI45oaFeSPwD+x8KBz2GcGUJ7aJGPII
	 gOS5yhOmWv2XA==
Date: Tue, 2 Jun 2026 13:07:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v6 04/15] userfaultfd: test uffd VMA flags through the
 vma_flags_t API
Message-ID: <ah6rXJEYUsGfzPgi@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
 <20260529172716.357179-5-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172716.357179-5-kas@kernel.org>
X-Rspamd-Queue-Id: 8C96E18000B
X-Rspam-User: 
X-Stat-Signature: hfywqjsy8ichirsqf3pf6wa4ue7t715b
X-Rspamd-Server: rspam08
X-HE-Tag: 1780394853-577911
X-HE-Meta: U2FsdGVkX1/4egH5fOGt0EX3jusQYrwPyqWXOH8YLtJw87qp+8DvlJGuiFI19cordLGsWYrO9qD2dM4Fb+NSOe6XJEOY5DPNSDaSW/wwOR+XKHa3M7YQr/QIqWn4eXTktmGoK9AViicbVfSm1g0FaMI4uuEo7VuSXnt/6Ys0fe4jskm6mVWxzuowCeM2Nnh/2alvOCVW4At6DiFGzVKeE+UnqQ+KRP2n5U/61toruFhF7dMXl85okbAsU3d3NBFVvM5SXtDT6+3b2wHFzEYWFClr70Nb8PUgiVIdVoo/xxMy2G06qyD16yS+7UCX3nmtXIqrtUgDDG6diVeLXQskNflVumi7bbGGf9IT25agiFvDlM2KvyPZYZAwfofz6ycmHzy+o2AzmUVl1a1GTMgPP+LX1O+hCizdkDCnuldEAVVCud95fiaQTUAn6LoLVT0zy0+bgiY6lQTs7Cpe7rq3niA9STWpfHGSv0WivxSEVA3f5ikuw3xyN1LvkCEuC+FQd8Cl/Tf+Ygd5uPLKRiD4ShUJIRzLt8QOUeqRZ4x8ICRMetapLLF9AwHYvaNB1bqjfQJ1CwyPxINKBfv7GYb8bpmICRcl7Hr0XWiYEK8X5Flz31DSLjbpaJxNHKoO7VmmHqsHqtU0vJXGjRwF2C6cQtU2tlnSplmApKoBdg24TnaNAGooYCZwl9zLF04FgJzS9Q1D9WbMo0a9txUZuCZ8rP4aQHQTc1w98kYzTvrj0F/OYXqoRi7WQhljd11CuRuQ/xoFxFHFDmuat3nVz+xrLygnzqwmXrkXJQGJ8EhvPJuSU+iRUhR8c/ANf6fG4B52A/PAsqXhMjxej6eJYB40OGFZUQj7q1iQj5gi8p6JGQjcqocL4rmbvQC1ZafNquZIwRVVoAsAtAHCgR8VFM6oWj72QjVEcqsziQdeFEylpJNZiMMYnGh29wnHKTqX7sJDnWE1sacKmj+3b5JeNML
 fEM/EDnE
 I/dqNethZYmlsH7SP1ppxJ3UJVpvryCtWhWV6QWewpS/w8yo/Da3yRgoMTGmrx84jlNMs/XszxuPoH3Iu/8Cdc/NxB9rku8q9ET2tmPj01YfTWFScRNGsgoT9OaRs87ChsEYbCiagyFApPc2aHLtJoFnFyINT5DNGpXH6TJIjg7AAe5mKF80xoL3NWAe7+xjLhX6NW9aDO3dgCybRE59dCc3erUK6MTD+HZlxiBf2YTSxUVjbRHYg1hOL0znPyULO4JtiwM52P3CDqkzyGGu5B5EuFzTSu72yNU5E9pUH/yMeSQAZ54wfAFjUBpNA9g42rDfM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:26:33PM +0100, Kiryl Shutsemau (Meta) wrote:
> The uffd VMA-flag helpers read vma->vm_flags directly. Now that
> config-gated per-mode masks exist, switch them to the vma_flags_t
> accessor vma_test_any_mask(), which is the going-forward API and keeps a
> single place (the VMA_UFFD_* masks) that knows which modes are available
> on the current build.
> 
> No functional change: vma_flags_t is in union with vm_flags, so the same
> bits are read, and the masks fold to the same code the open-coded
> vm_flags tests produced -- verified identical on gcc and clang, 32- and
> 64-bit.
> 
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-8

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/userfaultfd_k.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 658740df2978..c4f2cc6dfcf0 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -178,7 +178,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> +	return vma_test_any_mask(vma,
> +		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
>  }
>  
>  /*
> @@ -190,22 +191,23 @@ static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>   */
>  static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> +	return vma_test_any_mask(vma,
> +		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
>  }
>  
>  static inline bool userfaultfd_missing(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & VM_UFFD_MISSING;
> +	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
>  }
>  
>  static inline bool userfaultfd_wp(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & VM_UFFD_WP;
> +	return vma_test_any_mask(vma, VMA_UFFD_WP);
>  }
>  
>  static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & VM_UFFD_MINOR;
> +	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
>  }
>  
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
> @@ -222,7 +224,7 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
>  
>  static inline bool userfaultfd_armed(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & __VM_UFFD_FLAGS;
> +	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
>  }
>  
>  static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

