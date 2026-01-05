Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6DDC2A088
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC3C6B011E; Mon,  5 Jan 2026 05:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD576B011F; Mon,  5 Jan 2026 05:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594D06B0120; Mon,  5 Jan 2026 05:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49E4E6B011E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:42:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E427C1A165A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:42:30 +0000 (UTC)
X-FDA: 84297571260.10.3E59E92
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6E32840002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:42:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zsoN00fB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oNeGNtqO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zsoN00fB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oNeGNtqO;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767609748; a=rsa-sha256;
	cv=none;
	b=3n2W3HdWQkzFgKrfbSA5mXkD0n6bePZucbgT+wp3qTV4fMOZU6RO92k6d/QH2CQ87MRPJp
	M9AsZYm1KtNbhdRS/eOR+IAt9zA8+bTqKoHKMzPqdorEmyKoZBV3eIeqMv3ITB2aGeettX
	TOu7z5C3hh5bsTBr81K+urJo4962oWY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zsoN00fB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oNeGNtqO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zsoN00fB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oNeGNtqO;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767609748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6rV1Ebw20shVV2smF8/4qjLdC7vELT+Y1I64ofr95Q=;
	b=ijJKZ2+hAk80NqBWmpyUkaYxV/dzpJU7gev/QcBQWnOiOse5OINODexc1maDLNu7tdr/cI
	/bb/1IWVZbR+1ese32rM/fHpIqON+b+amB3QOcDEd3jcNqq3avVUaMoXPFLNk5k6dsrAoT
	VnhQCaM6y57zf79FrALhHFq8Z/ooJPE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1699336E8;
	Mon,  5 Jan 2026 10:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767609746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6rV1Ebw20shVV2smF8/4qjLdC7vELT+Y1I64ofr95Q=;
	b=zsoN00fBtp43YmhTq+Iw0lWT528lh++16x22U1gKpKCRscz5drZRFFuB1w3LXGlI5gm1tN
	eoDBmX8rxUW14vE9G+S4zBrZDaZ146E9LEwOSlJohGa4jSmM+46r8K9kQFeBEDU75LzoCW
	SceOOlCgHIvF4360XMggl8x6Gdi0Qns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767609746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6rV1Ebw20shVV2smF8/4qjLdC7vELT+Y1I64ofr95Q=;
	b=oNeGNtqOI4EoABbw706jqn+aErktNh4SrgnbaV/h7srDouSL3Z3oRyIudVoUJUS0pEjBRu
	+K76y7PkPfLh1KBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767609746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6rV1Ebw20shVV2smF8/4qjLdC7vELT+Y1I64ofr95Q=;
	b=zsoN00fBtp43YmhTq+Iw0lWT528lh++16x22U1gKpKCRscz5drZRFFuB1w3LXGlI5gm1tN
	eoDBmX8rxUW14vE9G+S4zBrZDaZ146E9LEwOSlJohGa4jSmM+46r8K9kQFeBEDU75LzoCW
	SceOOlCgHIvF4360XMggl8x6Gdi0Qns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767609746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6rV1Ebw20shVV2smF8/4qjLdC7vELT+Y1I64ofr95Q=;
	b=oNeGNtqOI4EoABbw706jqn+aErktNh4SrgnbaV/h7srDouSL3Z3oRyIudVoUJUS0pEjBRu
	+K76y7PkPfLh1KBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EEC23EA63;
	Mon,  5 Jan 2026 10:42:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VF9fIZKVW2lnVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 05 Jan 2026 10:42:26 +0000
Message-ID: <e435395f-90b3-4603-b305-8a52913cd0e5@suse.cz>
Date: Mon, 5 Jan 2026 11:42:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Matthew Wilcox <willy@infradead.org>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6E32840002
X-Rspamd-Server: rspam03
X-Stat-Signature: 7eo4uycfbuzy4rc3aouyzwrw3yb7p4hd
X-Rspam-User: 
X-HE-Tag: 1767609748-965615
X-HE-Meta: U2FsdGVkX1+Eaau4lXkE0Kjf9ot6lVYlfZAI1FP5oi6uuLhqO4qPrRc1Rn1OZaXbWfrRz5T6l+NOpyRM15S46Twp0Hrl8EV3dFXlBmNeHHDodm2CBLkNC6LJiy6wAPUrvLPh7cb2xkD/Ooq5Tc99LHr0nJL/J68saSNZEWH/XxIIwkTpmDlrhcYIR4kj+mU4lV1zzG8kTYGGPAx+HVxoSEjD0LS6nGZ+eoVkBKZGiQ6oP8hdjy/h8wUgyiLljqu1DOMIbr/33xkpcu/H6JT8NqL96z/yRXHB5/zHdgyovbkNEcrRoumQOG54TG60n54LixeCE1Se8PtCeA2Hdj8SgfqVK/WTcoIzAuLgg1k5yqeDUYFQ4zAHu0YcvTxGhua1W9EWLN7BryXBNG8WYyRReT5Sz+Mnb2XSUbKAVXZ7N+GcY0oBiOigJbDQ/pFGV1rtUyQdaQh4GE0X7j2uQXTVC7iRM3/fh74YSuJQ2YKdypSEKuTD/7I+SdBWQ4FKR9x/Rbwrt1lRR1pBBavtW/HDeZPcgZKXXNqEwK46hIDf2jBQa70aZbf4P6+cXI85Rh5L22ICJJrV57ZWAY5wFKJ4vUgMOGXqfe1xjuZ/pjDDPThhLrVRsG2FfTSKbOstg+LKHsdmb+bhkqC5x7LEJYyEnbhYUtsnvqbC2HdIN6n6lq52Tm+By/sF9sdk56XTmk5zGQq/EGexeSXWVCEtSG7am7SD5tfDnUE6cK/URjKmklYpdpZUpnZhbuOcJ+2lZ4TTWDjZRNlnL8W5BrwZyotnDATZ/f7Q4aLKDx5fZwia5Y1gRp6xNgDSMpjcVsZZXRYbecxMK1C0HRtjWKA3nWN3t7iNJwMVhn9f0dY1khfGp7XOQsY1WodqPx2k3S8shuCLW9TVLaHeny8OC4MOwnVIVP0n4sepgDNa/ZxJdawAthVrbaZ5xj5Lf4HF8T1G3O/UY8+qrWUJls9uulAFXG4
 +cTGkg2Z
 NfdW9fMSu3iKH+4qCpaoXjRKEyJz6oE48z3hptQqRHhJZWcHYUMS77MbUxOYiZDiKZXAkJHiz8zPG0ZW7IWg/lrBYhlwWKsjgi0NphPaqRdFcJfenE4c5j3Zyc4cHhkPOGrGfA594EU1JjaJKDeMCS0IDI52bacXABt7jnmNa7/9JnaHRVDsOEq71i9PsAnd0Rj0RQXWokYtJjgHXeBkKUrzGAuuTqGBjwtc2pyLUNTe8SsVLevkrjdpQs0I+jOFlNv4ijc5ZP+6YZDnCAee1lQ8gnJD1JxTqBY1cPxZlrOhmL4S+v8nDvbbSFxT5viskhqMQvWHgFLJq7cJpLZsHs1VvNGpE6q2+dJgaqhDkUCacKNu05MMRTEDfC97mF+hehFZCTXhDluLF+NTE6aLeiAs+ql/5kcZAkYimXj/x2vpZl9b4qSZyihjN+9XfF+gmhHIjBxtPL1SgwIknzFQ95Sxq2asroXC9KDQ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/4/26 22:17, Mikulas Patocka wrote:
> If a process sets up a timer that periodically sends a signal in short
> intervals and if it executes some kernel code that calls
> mm_take_all_locks, we get random -EINTR failures.
> 
> The function mm_take_all_locks fails with -EINTR if there is pending
> signal. The -EINTR is propagated up the call stack to userspace and
> userspace fails if it gets this error.
> 
> In order to fix these failures, this commit changes
> signal_pending(current) to fatal_signal_pending(current) in
> mm_take_all_locks, so that it is interrupted only if the signal is
> actually killing the process.
> 
> For example, this bug happens when using OpenCL on AMDGPU. Sometimes,
> probing the OpenCL device fails (strace shows that open("/dev/kfd")
> failed with -EINTR). Sometimes we get the message "amdgpu:
> init_user_pages: Failed to register MMU notifier: -4" in the syslog.
> 
> The bug can be reproduced with the following program.
> 
> To run this program, you need AMD graphics card and the package
> "rocm-opencl" installed. You must not have the package "mesa-opencl-icd"
> installed, because it redirects the default OpenCL implementation to
> itself.
> 
> include <stdio.h>
> include <stdlib.h>
> include <unistd.h>
> include <string.h>
> include <signal.h>
> include <sys/time.h>
> 
> define CL_TARGET_OPENCL_VERSION	300
> include <CL/opencl.h>
> 
> static void fn(void)
> {
> 	while (1) {
> 		int32_t err;
> 		cl_device_id device;
> 		err = clGetDeviceIDs(NULL, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
> 		if (err != CL_SUCCESS) {
> 			fprintf(stderr, "clGetDeviceIDs failed: %d\n", err);
> 			exit(1);
> 		}
> 		write(2, "-", 1);
> 	}
> }
> 
> static void alrm(int sig)
> {
> 	write(2, ".", 1);
> }
> 
> int main(void)
> {
> 	struct itimerval it;
> 	struct sigaction sa;
> 	memset(&sa, 0, sizeof sa);
> 	sa.sa_handler = alrm;
> 	sa.sa_flags = SA_RESTART;
> 	sigaction(SIGALRM, &sa, NULL);
> 	it.it_interval.tv_sec = 0;
> 	it.it_interval.tv_usec = 50;
> 	it.it_value.tv_sec = 0;
> 	it.it_value.tv_usec = 50;
> 	setitimer(ITIMER_REAL, &it, NULL);
> 	fn();
> 	return 1;
> }
> 
> I'm submitting this patch for the stable kernels, because this bug may
> cause random failures in any code that calls mm_take_all_locks.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Link: https://lists.freedesktop.org/archives/amd-gfx/2025-November/133141.html
> Link: https://yhbt.net/lore/linux-mm/6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com/T/#u
> Cc: stable@vger.kernel.org
> Fixes: 7906d00cd1f6 ("mmu-notifiers: add mm_take_all_locks() operation")

Acked-by: Vlastimil Babka <vbabka@suse.cz>

This makes sense to me as a backportable bugfix. But I wonder if going
forward we should rather make all that locking killable instead of the
hopeful checks between individual lock attempts.

> 
> ---
>  mm/vma.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: mm/mm/vma.c
> ===================================================================
> --- mm.orig/mm/vma.c	2026-01-04 21:19:13.000000000 +0100
> +++ mm/mm/vma.c	2026-01-04 21:19:13.000000000 +0100
> @@ -2166,14 +2166,14 @@ int mm_take_all_locks(struct mm_struct *
>  	 * is reached.
>  	 */
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		vma_start_write(vma);

E.g. here I think we already added a killable variant recently?

>  	}
>  
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				is_vm_hugetlb_page(vma))
> @@ -2182,7 +2182,7 @@ int mm_take_all_locks(struct mm_struct *
>  
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				!is_vm_hugetlb_page(vma))
> @@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
>  
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->anon_vma)
>  			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> 


