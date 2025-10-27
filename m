Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FE4CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69448008A; Mon, 27 Oct 2025 15:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A418000A; Mon, 27 Oct 2025 15:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08818008A; Mon, 27 Oct 2025 15:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFA48000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:24:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FD5412A1C0
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:24:48 +0000 (UTC)
X-FDA: 84044871456.08.6568EAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id BEF34180012
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:24:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CTxnc5hj;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761593086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e58DvebilYhZuqhMmqG9yr1jzlYsH5UePdTi/B++WBI=;
	b=1qCMLaiasfrTJdMHspWo0yo05IVsjrk0TByRA73rFlIiDzBJ+75ZgXJlRR+DffAXFCRPOv
	UrfWEEk5gQUKxZsE3GWzL0HPS9xk7P8E2ogxeowdZ9QSVP+FxQIVt8frMP/kV38Pbx54I6
	NmIf/lElfwLV0RbolbFBlBfBGqxl7GU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CTxnc5hj;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761593086; a=rsa-sha256;
	cv=none;
	b=qRzxvuUA0wA0Rh6YbnMfG4a5z6MFZQmUzneSN9dHXRwtfe9SzMl9tWDOInJR5s1ESCaNYV
	R4mbdUvi/0c2e5GavEA6fC0sXb5jdK9smgbX2SXUm64HM+neLsLTBmBgKtWByRd2MBQ9lH
	AtSMHc1E0FugjwO7klRemdqjXLPKdIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761593085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e58DvebilYhZuqhMmqG9yr1jzlYsH5UePdTi/B++WBI=;
	b=CTxnc5hj9hYgmyCszJ1lhn+Jm9ZAsmbIg36ZFlkR4NV+FD9SGOoMu83eQsNkZhdli3o+tZ
	9NIPAvCjZxH9hk1HjiixjHOpk3OwSVC7FkHowY77fzT5BM7t2WOoRiAQXPYfNHvpHtebXx
	3NJajJl5idVsQJKw0UowvGNlMtAJc10=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-Ka2HjrfRPgu69smW6Qm6mA-1; Mon, 27 Oct 2025 15:24:43 -0400
X-MC-Unique: Ka2HjrfRPgu69smW6Qm6mA-1
X-Mimecast-MFC-AGG-ID: Ka2HjrfRPgu69smW6Qm6mA_1761593082
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42992cb2ee8so1589903f8f.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761593082; x=1762197882;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e58DvebilYhZuqhMmqG9yr1jzlYsH5UePdTi/B++WBI=;
        b=PV5VWMrqQsiygg3Mw+NmyyLZGkYTWOQys8CzYadEstRpo0nLr+W2v+ZBPjnxY/yv3q
         gTUgk37B5m3I1V8Dj8y8cGBTcS8r0nH/UqwpucWTKZq7yOIyocZ4JqhTiAjwFiYhuu62
         HScz8hlgskV4sHp1bv2VHaSYJ6PWm+TzjFWr1uOcQqjbtEMTmyjvHv+z9Kvxh+1l1ADu
         5kqznpfgIH4YZyaKhwTomb5cWOdLOraak6BQfMsrXq2Xj4Y5SqO/WBOvA01oEDETg2k/
         xYVP5gjBUgIA1lOdXtBlVLPQItPSXTkghZzv5HqfMfWBOeVrjYIk38/e+vUOHu8dDhB8
         Hygw==
X-Gm-Message-State: AOJu0YzwQ9EN3aQXhddONZEzX6hB7eRe6wgB09zLKzhkoZcyWk+2e3LW
	9ZbGRTpcL2sNe+B0I4d5v/IfWcL/qxcHqkn4hfYZnuV+6lTZtEMkOAYy3gaXrrrLOJFEaryzPlZ
	gYUapM5W6ZqafW+eMLGGQ8CNDLYYHgxBYd4H1x8CHbccs0NmwRnkn
X-Gm-Gg: ASbGncvGjgvGqLxGC83vNpttbTkNCDbga0x5VeEZwifBOlwFcbr4XjnV5wXV+vCoZox
	2ZFN06jyne1pC4CX7zLL4gyDn796LCLoBG5vZwW1U5NQkaYfIlFSf/aJBsrV61fTaDAdCn2v8FK
	IVPWbTlJdReqr4uuOa95XU4mipwt4QI7+rOjUAKhWLgrvPf0aESkAXDDZitGhNOlaFHAlTM8lS+
	SxsjLvDpfzJojOOpZxQ/qo7/AxK+6ySsL+dhHbEvsMMQsrq+r20kkrwAc4hBSFbbANYxDVRLUyd
	H2ckEq6mVOjapySM4v0nAdmZ5bXCKiTzOrYRyJC6V9tpiH86cm/exwB8mI02qP6bvyQJhArWUC5
	ocAlVvopAjNY0bOxVC5upxoyGKbyyB/+B8nrZIBVT7dXj9Nn/ILFMg2QpwTzjGI5KCB9T7UXH7x
	CQfHVdYfAY1weRj+YkmPBqL2LiESE=
X-Received: by 2002:a05:6000:310e:b0:427:699:a9cf with SMTP id ffacd0b85a97d-429a7e7c2ecmr756557f8f.33.1761593082165;
        Mon, 27 Oct 2025 12:24:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmYO5y4v58+ZSE63Crr2PZi/3WTpkjLTjdfIsd5tClOy8zlTOiogUy6ohkLE34sEfq/MC1Qg==
X-Received: by 2002:a05:6000:310e:b0:427:699:a9cf with SMTP id ffacd0b85a97d-429a7e7c2ecmr756531f8f.33.1761593081711;
        Mon, 27 Oct 2025 12:24:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7dcsm16467040f8f.11.2025.10.27.12.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:24:41 -0700 (PDT)
Message-ID: <276b70aa-9853-40cc-8e7d-e790166706b5@redhat.com>
Date: Mon, 27 Oct 2025 20:24:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm: Introduce can_pte_batch_count() for PTEs
 batch optimization.
To: Zhang Qilong <zhangqilong3@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jannh@google.com,
 pfalcato@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
 <20251027140315.907864-2-zhangqilong3@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251027140315.907864-2-zhangqilong3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6HbbkIfAlcAkhn7SbbT8fXA1Bw63B6Ilf1q-IwceF34_1761593082
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tejartwupnp9rrajrkjcp96ts6gxtd8c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEF34180012
X-HE-Tag: 1761593085-882153
X-HE-Meta: U2FsdGVkX1/vZkD8OBgxHgj5I0JWG2Su8cjH2YmVE8xmA1IpiUMqqNRXUsez0O7Sgkeyh3a+BINRBU+BhdQzYDOKKVLllBRtZ3mRlg2CJIk3j4sZPdhVqcQjeZWg0RMGM6DYPKb07L9WPW13K36jG/i9WWDL51ltJ/cxYkVoD3UqVgBaV+mfA41dfQCvyX8bhlTAA9NpKUnDraLqaW8nCCLYk354OujEFfrLJmlGv1u7hRkxc0Hb6lL3YmOVuwLZAVWrcfFQe+DA+1MUuXwmr7mrf4TL3ST6REj5d1nauPqe1UhYGDYUxbSn70mSwBRmn7RZ1wYZM+m319nxNPIAA+bbkwS+hFvyxvgHsnGf3B91vr6nWgeb3MzXy3+lQWWfVHuk63FNPZ9xg399ayv2iVxmRwR/Qwguk3WDnX48NhSZ5EGAu7gRE2hS8/mceALAhBinIWUqTVIopfx0z8Q8H5Lx0BL0gehwJwxyHSlT9GNaGJzBgVsnl9g7SR+39HrEaQc/XRzXdS1BWtK+OUgZCv7YesGQfDX57d7DKa15fiM7i7B8A7r4OFbIDrnp5tz/9Ej4aJJgx2PtYqK5D2nZKGOYvq9qxxhj9d3p6xq5SuVAZE/mcm/JvZ2USZlCZmnDoJH6KCPmGgzOIVD50XhGfSYhw/LqBZVRL8XGAT37fdP3XDn97lhVJKWth7unyBe/ameW5R2oENLPd/ZEEWGUPU0lBlcMp2duC4zJTWAZ/1faqjAO/DKqvDZ/IrjsZoKovgZTgfHVrFf6RN9fu8wA+Ahh8s06dZP477xC9pYjCGHLnLJuq/KKx5IVx0S0eKGHHn4B9a33lUSi72EGGjUzde/zaMoVcbJZ5Ii0o3g3vBfuUlTVPgMNqN4+f9EMpE45DON4IBF8sfttA9AF3zunLj3KZsGMEM+PeY81FYzaO9JbYyRWghC+Y7oAAkqIXOQLWzs/cuav1J3qOkvGlr2
 SPgTUi7A
 kmcfiywWW5GX4X2XhCd+/kZTqPTGevTK/huQ3dsx8aywRfIb/GN7g83+PGqgxTQHYBNk+1rbdPA4yLQN4LbfTmiz3yniS/Qx20tGLDXqSxp0qUp7giq/R+NnNCcuGzPGBxgHgMu31d1gkw4XvPU1uxDYNXAz2ZUZk8LhxXCcXJzhoo+fDF62kn36UCfIWYFcW1h2/DaPmWL4C73SxoMWrLobcCl75NZBm7pEA+t6rvxmFBPbMW4w5QRUkcQ/y2C7ZWgJXYssOceJ8LmLomxoHseQSIAT/8XKGn0MTUFWj2+RZpMU5djqUiYxOBySxHV+3uSuoTkdv1s3oqVIlCU+48W8mheMY3GxCSmK/hjEx053x9W5jSU+atjYY87KwFg0a3slgpMQvUSlaYyygvfvvSkG6nTcF7G5xbUwRSrW/JM4t43P6gxK4BL/Up8je+4X4JM8S4GMVFrzhyNVB5oBMwhEqAR/dF9aay+0eB3hpqqVzDbI6mN9MED+6oy38bA0IxPwVqLVc+NEM440=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 15:03, Zhang Qilong wrote:
> Currently, the PTEs batch requires folio access, with the maximum
> quantity limited to the PFNs contained within the folio. However,
> in certain case (such as mremap_folio_pte_batch and mincore_pte_range),
> accessing the folio is unnecessary and expensive.
> 
> For scenarios that do not require folio access, this patch introduces
> can_pte_batch_count(). With contiguous physical addresses and identical
> PTE attribut bits, we can now process more page table entries at once,
> in batch, not just limited to entries mapped within a single folio. On
> the other hand, it avoid the folio access.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>   mm/internal.h | 76 +++++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 58 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..92034ca9092d 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -233,61 +233,62 @@ static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
>   		pte = pte_wrprotect(pte);
>   	return pte_mkold(pte);
>   }
>   
>   /**
> - * folio_pte_batch_flags - detect a PTE batch for a large folio
> - * @folio: The large folio to detect a PTE batch for.
> + * can_pte_batch_count - detect a PTE batch in range [ptep, to ptep + max_nr)

I really don't like the name.

Maybe it's just pte_batch().

>    * @vma: The VMA. Only relevant with FPB_MERGE_WRITE, otherwise can be NULL.
>    * @ptep: Page table pointer for the first entry.
>    * @ptentp: Pointer to a COPY of the first page table entry whose flags this
>    *	    function updates based on @flags if appropriate.
>    * @max_nr: The maximum number of table entries to consider.
>    * @flags: Flags to modify the PTE batch semantics.
>    *
> - * Detect a PTE batch: consecutive (present) PTEs that map consecutive
> - * pages of the same large folio in a single VMA and a single page table.
> + * This interface is designed for this case that do not require folio access.
> + * If folio consideration is needed, please call folio_pte_batch_flags instead.
> + *
> + * Detect a PTE batch: consecutive (present) PTEs that map consecutive pages
> + * in a single VMA and a single page table.
>    *
>    * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
>    * the accessed bit, writable bit, dirty bit (unless FPB_RESPECT_DIRTY is set)
>    * and soft-dirty bit (unless FPB_RESPECT_SOFT_DIRTY is set).
>    *
> - * @ptep must map any page of the folio. max_nr must be at least one and
> + * @ptep point to the first entry in range, max_nr must be at least one and
>    * must be limited by the caller so scanning cannot exceed a single VMA and
>    * a single page table.
>    *
>    * Depending on the FPB_MERGE_* flags, the pte stored at @ptentp will
>    * be updated: it's crucial that a pointer to a COPY of the first
>    * page table entry, obtained through ptep_get(), is provided as @ptentp.
>    *
> - * This function will be inlined to optimize based on the input parameters;
> - * consider using folio_pte_batch() instead if applicable.
> + * The following folio_pte_batch_flags() deal with PTEs that mapped in a
> + * single folio. However can_pte_batch_count has the capability to handle
> + * PTEs that mapped in consecutive folios. If flags is not set, it will ignore
> + * the accessed, writable and dirty bits. Once the flags is set, the respect
> + * bit(s) will be compared in pte_same(), if the advanced pte_batch_hint()
> + * respect pte bit is different, pte_same() will return false and break. This
> + * ensures the correctness of handling multiple folio PTEs.
> + *
> + * This function will be inlined to optimize based on the input parameters.
>    *
>    * Return: the number of table entries in the batch.
>    */

I recall trouble if we try batching across folios:

commit 7b08b74f3d99f6b801250683c751d391128799ec (tag: mm-hotfixes-stable-2025-05-10-14-23)
Author: Petr Vaněk <arkamar@atlas.cz>
Date:   Fri May 2 23:50:19 2025 +0200

     mm: fix folio_pte_batch() on XEN PV
     
     On XEN PV, folio_pte_batch() can incorrectly batch beyond the end of a
     folio due to a corner case in pte_advance_pfn().  Specifically, when the
     PFN following the folio maps to an invalidated MFN,
     
             expected_pte = pte_advance_pfn(expected_pte, nr);
     
     produces a pte_none().  If the actual next PTE in memory is also
     pte_none(), the pte_same() succeeds,
     
             if (!pte_same(pte, expected_pte))
                     break;
     
     the loop is not broken, and batching continues into unrelated memory.
     
...


-- 
Cheers

David / dhildenb


