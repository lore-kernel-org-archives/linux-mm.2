Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E34CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 17:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416AB8E0006; Wed, 22 Oct 2025 13:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6A88E0003; Wed, 22 Oct 2025 13:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F3F8E0006; Wed, 22 Oct 2025 13:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 108558E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:28:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C98F3BBF0F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:28:37 +0000 (UTC)
X-FDA: 84026434674.23.97F5EA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5815E1C0007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:28:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HfWzuNtz;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761154115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ersH+A2YnVEG4u4wWpk7ksHDpnwZb29+THsgHlY+RNw=;
	b=WcThasoM+qjJKq1XEptt1CSVx2bPEunfiZu5V94Hndrej2QNTZC+9hJTt2bHQB89ehngIh
	jZr1+O3kEPEmQrDQc149HmZhmwwUFQlRCrElIKzr38B4DRg3V5g0fKeAIEGtIo2rsGsINJ
	sPxrF3xFObNCxzB5f1YIk4s51HdLrgo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HfWzuNtz;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761154115; a=rsa-sha256;
	cv=none;
	b=GFFjSXLz+lsOrvTNfrcntc5N+dlWxpEJqjqaVOMSIuPe0jRsmhXqQn8Qc++tfvr4eqKcUh
	q641yOQk65OqQk9TlRCFOOTfXPt9RQrlTxKt4FU3ItXBGIWIyCAko03KpCfR3pcIqsYz6t
	ZeqAC/LsMWHu3CnBNW9c5gyTkMhV4ow=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761154113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ersH+A2YnVEG4u4wWpk7ksHDpnwZb29+THsgHlY+RNw=;
	b=HfWzuNtzbLalH+oGp2Kq3H7jZoILlqscLS8WUPa8gnnj1K8F02jzU51RXW7dIVa7Jw9wqJ
	yCdl6Iyz8bT+Bcg1w4Dg7PxqEiCjJcrlTd5OEQOYLA6oSDqLubppe5WalNKnFA/oSDCrXj
	W/tvVZVSN59jVH4PKV1wbNW64i/sQfs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-c8jjjWtSNECikfG5tbOPrg-1; Wed, 22 Oct 2025 13:28:31 -0400
X-MC-Unique: c8jjjWtSNECikfG5tbOPrg-1
X-Mimecast-MFC-AGG-ID: c8jjjWtSNECikfG5tbOPrg_1761154110
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4710c04a403so70962105e9.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761154110; x=1761758910;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ersH+A2YnVEG4u4wWpk7ksHDpnwZb29+THsgHlY+RNw=;
        b=r6R4lb1DQ7rtBoNOekrBlQxSdCuYEfNPQnXnmC6TL4S334V1LioBVPGD6q1p/+s9Ek
         PB0lRId9nvWAmeEhHRJaNQ18MYzqRdpRoqte+LluVhkVcNpHxU3kjHoxuguun0TMl1qy
         EryoWdv1gpia4WJAuHjvDsEwwS4K/OfmvxKd68tyV9c5saCSuImXwOzpitYp01T43iSw
         MAVzxTpYrrCKJvFJDqWIZsgDtsdBz3/8NnZNl804qZDjCqlgA5gpZ05umGjJxmIAAcjP
         fbTH4GMo/OSpMrLZ+nl+0ZlISTvQiMYtMIphcnuLoAtDqJ4FwadUqxnIbq7EHhQoAkH1
         pHMg==
X-Gm-Message-State: AOJu0YwLl0VQO3dx92Pt7of0pb1w8sShR+mRXwcY49k18b9U0JslNINO
	4oPRWNZUqYCLIvp9bdTHtlXFPUdt3KypHdLndWbwObkTR+NQ/Cu3HKATtocVMQarUn5FAsV3G41
	2/6aULFmJ5GTu7UZ4PLRVf1vsNj7nNGm5skw+9NRAl+nQDMSmQVJs
X-Gm-Gg: ASbGnctAJpTiZj5LjIxyGu1Uyj5Hb5w4CxDMH0MOCeSXVPZqxyOM81bvhCqRusOmqQa
	+2BjSZmIgGCHhoIlmNv+qmq2+EyZg2j/f7Ev6baEqjxbeKpCRF3GFzzxBN5MxuAlsTYH/Z201ez
	111Edj78Pz8wng32cT8no35HJ3TCuu6qv4hwyUqKjaeiFwfoRl5VDZ+kSnYJY1yAPfM+jlMgJCY
	WfnepJWHdMCYu/ts5USNwU8wlPv0N/Q+sp8F7tibzbqKsCZSxX9O3oJDonYOpME/lG23vdDRdPv
	7YvkPHo9KZSWGQH1wdJCi4qA+1YF3eOmMkFsibctY94KvG6IKSm6slPVMydWrT/txEfdKcPP7H+
	jxpnXQZN4Owng7UUxF1wVjf+ZQAowrU0Rmloy+RKsVtRcL3hgNXDGQHo+F46KhCCzjBzSnoD9ld
	6JPMKbk/Hi3YoNKtGgJU+XvkRwvng=
X-Received: by 2002:a05:600c:6291:b0:471:a43:123f with SMTP id 5b1f17b1804b1-471178a6882mr170490355e9.9.1761154109943;
        Wed, 22 Oct 2025 10:28:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlRHaZovyGNJpfxC/RlqXuNv/7Z+a5XDpsqOCnLx0yEjUAljMFKF3SfTdCasSCmNwsHcnW1A==
X-Received: by 2002:a05:600c:6291:b0:471:a43:123f with SMTP id 5b1f17b1804b1-471178a6882mr170490155e9.9.1761154109456;
        Wed, 22 Oct 2025 10:28:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428c62fsm56170405e9.8.2025.10.22.10.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:28:28 -0700 (PDT)
Message-ID: <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
Date: Wed, 22 Oct 2025 19:28:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20251017141536.577466-1-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251017141536.577466-1-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ksY9Zc-Ifn89ZIHTfsW0D3INktpiH8ao127HBGdQtf8_1761154110
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qqbz7axjoq3m9pa7b139nak1w57xxqkb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5815E1C0007
X-HE-Tag: 1761154114-335887
X-HE-Meta: U2FsdGVkX19vama7VAIbTuSlP0dPYmMHG29WsyAD834QDOi8kiwdR504yu6rbr0f5rmC8XUrn/ZWeAZSZ3ryMOlgc5NIhCAQS1EG0rh+bBSk3Szo8Piv13OwSfueDLmPxHmIu6bKtHEzIHA1NiBgIwGLL+3PuQMnweippbuSOVhe9TB+agZvObvamYmnoCxeQMbc0lKcnNrox2d5dQk2gnAf+xNyVCa6qkiRadkCBIbn3Vj6pjy2OSlxbMaa+w01kDUl6fKk3KYTy9Ihxm6X2hjHDd5QITOfj9neyuqtj+aZ4rhlcyP8ziI0zSAeqxYBOTgJ0tXrfA455ulb7XEAxzZQlvmCZpncls1epqkoX8blyOOXnXCa7UXXQILR0kTj4Mue/4GMT4/RbukVgvk8W6MPBhlvTjWb2JAUmWmOv+YTFe4eHtHaAR+4o71Z7du4A/wuJNpDlUJOTAjupcMLhBc3jncEI+KAM6Gd9BJeqMeH6PfBrt+iVcbv5YqdoVKhPB9miouOjS9dtN0cq5OOITz7WP0ibyMdMu/sw1caenwLHVQQKiSC+SitxPyETbTely5PpwgVBgYeKjPVCouBenToNuzueFh/D/6iU7Dm1CftdmxAR92LRgJnL181pzDMpp2QYCKlqTyKiT+zAo70+7k96V44EyO4vZ9a0CP0WHrH+XRj0XYmZwLFQgrx7vvNPt9brVGcJiWnTM8tslesui7dSVTnz9aNIjKlkHsG69Pos9O7qStzx02TB99fXsI69IeMSFk9xjchTSqaHw+tSp2fLSesruPUm9DDaYHl69+/KbrYYJML6kU/e6AJJMU4gNgfg1N4KIlt3jgKblVrIVXoysiALR+IcxngB9Pl5To31xnK85riULu+sCyowuRjTvsbL0HwxbWDyz2qT168Aiwm+E9zP20VGzOeLPFt3QfmP81qllWW3KeIN/kxQecAcdkZv40e2zAHZFBnuRp
 XZwJieTf
 mN06BJmxkOSwtmjxJ1VgY7pmUhFjPokI5W/SmmjPB2Er4DfveW2AW/722m0GYpEvuhAEjCnGoRCmLfQLNMpOcjWHNvsl/VRUK5qn8l9SaI/i3DbzfcK/n8Tb1OQmfcvCqelukH6UnbcCtxrozhSBIqPpWaHZK8hQOajPrLiCAqcN+1geBwzIgGVWr/7sIE2nSCuOrMTb9xcAqQgdNHe5MVCOtRUeiQ3bBbyaqbXVcvVD19DoPxHQE0FpAVEOP2efWrIEntRDTcPTZDLDZjI/xeFFrfUYCTKq3KVUSKI4JPayryHn4rtTga1+pk++Qy7A4fuLGVSNq4KNn0pEedaz3szG2v6FSFRle1LGRQ9jU+Xpe/mfUOoIHHoRKzQgfumu8tKKRYmmX1BgNglcxwuxlEyDcn8/3DVFHqARXNjdpSybrYkwRBIu4RLCQSz1LFnagQuX5jGPaMI4yJ6TSl9ZDF/Rbtr0m8g5ySSMUnd3YGeAMl+zAksDTAM+ULbpawIBEt/KOEMgfC/VETVk1YjSEBYCStmKaLrCqqHv4Yt5LQPwJjNAY4Qz+0nGexBShoGheXcllaiW8VNzpIbLilYw9/AEo2SmR94/y4uLl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 16:15, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The protocol for page cache lookup is as follows:
> 
>    1. Locate a folio in XArray.
>    2. Obtain a reference on the folio using folio_try_get().
>    3. If successful, verify that the folio still belongs to
>       the mapping and has not been truncated or reclaimed.
>    4. Perform operations on the folio, such as copying data
>       to userspace.
>    5. Release the reference.
> 
> For short reads, the overhead of atomic operations on reference
> manipulation can be significant, particularly when multiple tasks access
> the same folio, leading to cache line bouncing.
> 
> To address this issue, introduce i_pages_delete_seqcnt, which increments
> each time a folio is deleted from the page cache and implement a modified
> page cache lookup protocol for short reads:
> 
>    1. Locate a folio in XArray.
>    2. Take note of the i_pages_delete_seqcnt.
>    3. Copy the data to a local buffer on the stack.
>    4. Verify that the i_pages_delete_seqcnt has not changed.
>    5. Copy the data from the local buffer to the iterator.
> 
> If any issues arise in the fast path, fallback to the slow path that
> relies on the refcount to stabilize the folio.
> 
> The new approach requires a local buffer in the stack. The size of the
> buffer determines which read requests are served by the fast path. Set
> the buffer to 1k. This seems to be a reasonable amount of stack usage
> for the function at the bottom of the call stack.
> 
> The fast read approach demonstrates significant performance
> improvements, particularly in contended cases.
> 
> 16 threads, reads from 4k file(s), mean MiB/s (StdDev)
> 
>   -------------------------------------------------------------
> | Block |  Baseline  |  Baseline   |  Patched   |  Patched    |
> | size  |  same file |  diff files |  same file | diff files  |
>   -------------------------------------------------------------
> |     1 |    10.96   |     27.56   |    30.42   |     30.4    |
> |       |    (0.497) |     (0.114) |    (0.130) |     (0.158) |
> |    32 |   350.8    |    886.2    |   980.6    |    981.8    |
> |       |   (13.64)  |     (2.863) |    (3.361) |     (1.303) |
> |   256 |  2798      |   7009.6    |  7641.4    |   7653.6    |
> |       |  (103.9)   |    (28.00)  |   (33.26)  |    (25.50)  |
> |  1024 | 10780      |  27040      | 29280      |  29320      |
> |       |  (389.8)   |    (89.44)  |  (130.3)   |    (83.66)  |
> |  4096 | 43700      | 103800      | 48420      | 102000      |
> |       | (1953)     |    (447.2)  | (2012)     |     (0)     |
>   -------------------------------------------------------------
> 
> 16 threads, reads from 1M file(s), mean MiB/s (StdDev)
> 
>   --------------------------------------------------------------
> | Block |  Baseline   |  Baseline   |  Patched    |  Patched   |
> | size  |  same file  |  diff files |  same file  | diff files |
>   ---------------------------------------------------------
> |     1 |     26.38   |     27.34   |     30.38   |    30.36   |
> |       |     (0.998) |     (0.114) |     (0.083) |    (0.089) |
> |    32 |    824.4    |    877.2    |    977.8    |   975.8    |
> |       |    (15.78)  |     (3.271) |     (2.683) |    (1.095) |
> |   256 |   6494      |   6992.8    |   7619.8    |   7625     |
> |       |   (116.0)   |    (32.39)  |    (10.66)  |    (28.19) |
> |  1024 |  24960      |  26840      |  29100      |  29180     |
> |       |   (606.6)   |   (151.6)   |   (122.4)   |    (83.66) |
> |  4096 |  94420      | 100520      |  95260      |  99760     |
> |       |  (3144)     |   (672.3)   |  (2874)     |   (134.1)  |
> | 32768 | 386000      | 402400      | 368600      | 397400     |
> |       | (36599)     | (10526)     | (47188)     |  (6107)    |
>   --------------------------------------------------------------
> 
> There's also improvement on kernel build:
> 
> Base line: 61.3462 +- 0.0597 seconds time elapsed  ( +-  0.10% )
> Patched:   60.6106 +- 0.0759 seconds time elapsed  ( +-  0.13% )
> 
> Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   fs/inode.c         |   2 +
>   include/linux/fs.h |   1 +
>   mm/filemap.c       | 150 ++++++++++++++++++++++++++++++++++++++-------
>   3 files changed, 130 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index ec9339024ac3..52163d28d630 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -482,6 +482,8 @@ EXPORT_SYMBOL(inc_nlink);
>   static void __address_space_init_once(struct address_space *mapping)
>   {
>   	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
> +	seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
> +			       &mapping->i_pages->xa_lock);
>   	init_rwsem(&mapping->i_mmap_rwsem);
>   	INIT_LIST_HEAD(&mapping->i_private_list);
>   	spin_lock_init(&mapping->i_private_lock);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..c9588d555f73 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -523,6 +523,7 @@ struct address_space {
>   	struct list_head	i_private_list;
>   	struct rw_semaphore	i_mmap_rwsem;
>   	void *			i_private_data;
> +	seqcount_spinlock_t	i_pages_delete_seqcnt;
>   } __attribute__((aligned(sizeof(long)))) __randomize_layout;
>   	/*
>   	 * On most architectures that alignment is already the case; but
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 13f0259d993c..51689c4f3773 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -138,8 +138,10 @@ static void page_cache_delete(struct address_space *mapping,
>   
>   	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>   
> +	write_seqcount_begin(&mapping->i_pages_delete_seqcnt);
>   	xas_store(&xas, shadow);
>   	xas_init_marks(&xas);
> +	write_seqcount_end(&mapping->i_pages_delete_seqcnt);
>   
>   	folio->mapping = NULL;
>   	/* Leave folio->index set: truncation lookup relies upon it */
> @@ -2695,21 +2697,98 @@ static void filemap_end_dropbehind_read(struct folio *folio)
>   	}
>   }
>   
> -/**
> - * filemap_read - Read data from the page cache.
> - * @iocb: The iocb to read.
> - * @iter: Destination for the data.
> - * @already_read: Number of bytes already read by the caller.
> - *
> - * Copies data from the page cache.  If the data is not currently present,
> - * uses the readahead and read_folio address_space operations to fetch it.
> - *
> - * Return: Total number of bytes copied, including those already read by
> - * the caller.  If an error happens before any bytes are copied, returns
> - * a negative error number.
> - */
> -ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
> -		ssize_t already_read)
> +static inline unsigned long filemap_read_fast_rcu(struct address_space *mapping,
> +						  loff_t pos, char *buffer,
> +						  size_t size)
> +{
> +	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
> +	struct folio *folio;
> +	loff_t file_size;
> +	unsigned int seq;
> +
> +	lockdep_assert_in_rcu_read_lock();
> +
> +	/* Give up and go to slow path if raced with page_cache_delete() */
> +	if (!raw_seqcount_try_begin(&mapping->i_pages_delete_seqcnt, seq))
> +		return false;
> +
> +	folio = xas_load(&xas);
> +	if (xas_retry(&xas, folio))
> +		return 0;
> +
> +	if (!folio || xa_is_value(folio))
> +		return 0;
> +
> +	if (!folio_test_uptodate(folio))
> +		return 0;
> +
> +	/* No fast-case if readahead is supposed to started */
> +	if (folio_test_readahead(folio))
> +		return 0;
> +	/* .. or mark it accessed */
> +	if (!folio_test_referenced(folio))
> +		return 0;
> +
> +	/* i_size check must be after folio_test_uptodate() */
> +	file_size = i_size_read(mapping->host);
> +	if (unlikely(pos >= file_size))
> +		return 0;
> +	if (size > file_size - pos)
> +		size = file_size - pos;
> +
> +	/* Do the data copy */
> +	size = memcpy_from_file_folio(buffer, folio, pos, size);

We can be racing with folio splitting or freeing+reallocation, right? So 
our folio might actually be suddenly a tail page I assume? Or change 
from small to large, or change from large to small. Or a large folio can 
change its size?

In that case things like folio_test_uptodate() won't be happy, because 
they will bail out if called on a tail page (see PF_NO_TAIL).


But also, are we sure memcpy_from_file_folio() is save to be used in 
that racy context?


offset_in_folio() which depends on folio_size(). When racing with 
concurrent folio reuse, folio_size()->folio_order() can be tricked into 
returning a wrong number I guess and making the result of 
offset_in_folio() rather bogus.

At least that's my understanding after taking a quick look.

The concern I would have in that case
(A) the page pointer we calculate in kmap_local_folio() could be garbage
(B) the "from" pointer we return could be garbage

"garbage" as in pointing at something without a direct map, something 
that's protected differently (MTE? weird CoCo protection?) or even worse 
MMIO with undesired read-effects.


I'll note that some of these concerns would be gone once folios are 
allocated separately: we would not suddenly see a tail page.

But concurrent folio splitting or size changes could still be an issue 
IIUC Willy today once I discussed the plans about "struct folio" freeing.

Maybe I'm wrong, just wanted to raise that these functions are not 
prepared to be called when we are not holding a refcount or cannot 
otherwise guarantee that the folio cannot concurrently be 
freed/reallocated/merged/split.

-- 
Cheers

David / dhildenb


