Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4E210775FC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1EB06B02CA; Wed, 18 Mar 2026 13:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6096B02CC; Wed, 18 Mar 2026 13:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE50B6B02CD; Wed, 18 Mar 2026 13:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA7B6B02CA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:53:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 540B11DB23
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:53:13 +0000 (UTC)
X-FDA: 84559930266.04.5089404
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6604C40012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:53:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MMm77PkX;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773856391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjV2QZzHL9l+hZN/pbl5bOZQEFWnVMl5pJ0Dn0m8n2Y=;
	b=BB6WHx3TLor/PVkTKz7OI8blAfSVpmAL4VrjkagR1iflqpCVEvr/Jg97hJgyA9qVOUCarX
	68U1f8Bfx8YcxiisQp+DtjW9/JHt/VU8wNbLTa5ZopyXT4Yn8thA/+mD7GQsS7pGo6aglV
	QjrJHettS8qih9fk0JGLV7c2sqzBufY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MMm77PkX;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773856391; a=rsa-sha256;
	cv=none;
	b=gtaXDdmA0p/OwbvJl/ZlrHxyeEo3oAadxRHG7DA4T5a1t2TxzK7RT5XV/EOgH9vF6d5p7m
	5UC2A4hGc2OK8f6jgIFihPMusky67+SY+fWEDhmlVt8FOq2InseUywpdo8bnQjNqUCw6p5
	O2uwyawEKFgoQrcSrDicEOVAvzRwX98=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a1307438ddso124066e87.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773856390; x=1774461190; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QjV2QZzHL9l+hZN/pbl5bOZQEFWnVMl5pJ0Dn0m8n2Y=;
        b=MMm77PkX3u3tgnviahCXjKp8U9BRKEVW4RLdfXp89qy5TrgofFoE2u7ALWl05pgii3
         YCUCMKFLEPcogzGBB3tpEtj76Way+kT7LofPYsWCj/fGN5MQt9Td7m+3mAoIEKBqKlxl
         SpLLQOaOrdGHoZ3zaDHxBiRjEECH8tk7PmWgnkfs74RE14xYWa5Ywo6Odw6YaYrIpRGK
         p7nGBa0OriHglqpeQAWL0F0OeMJ6yKln33S64C+Yybl2SQqg56EgGXcisoZg4Br2zQHj
         xhvB0v9Y8KcJ5Gg6uapAiVw42AJ9hysirueNaMb64R1hbbE4I2aadXiiiN7PiVhx+V++
         m0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773856390; x=1774461190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjV2QZzHL9l+hZN/pbl5bOZQEFWnVMl5pJ0Dn0m8n2Y=;
        b=G3w4Zu94czV0YdbHCXSq+ecYMSyQbsKGxOA8/7iqatdQfPRz8rc2cxfZNKEAEqsXoU
         X42MJBMwUyzCJNTbayDiUAMnbFV11BtkgWrnvATuuzgq+GVgazqsJxgsdi26yyzu2p3e
         xOsvlK9G0HznRc5SS7Sm41vjDawFAXZLn+k2qc147x6q1brVaC/Eekl0ey2gNjU3wbmD
         Oi9UNovxosAKtEgJpfm4nd8bN6Yea9M594oSOv0ADAObDcqF2Ri4rjIBAUImzksuqKbK
         e4ypBNFLDe8qteciUQMR02BHPO5/FxlF4cNsJAzSrq+3nACywr/v5M5187kgKi6QblX3
         3uAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrA6mgBBsYysltU9meMG3FMENfFf0anTnrfWjO2mijHyWCxYhPlKVP/fmz3bQ1MxaTQcpyfnhP/g==@kvack.org
X-Gm-Message-State: AOJu0Yy//GrpaT3/kg9sEH0k64ydmrbWZkJn4rc3pt7lWkwJsEAn1fSH
	7TgOH2kKjkCGXhDBbeLu6pfhi/z1f5OWdHJY52zZg1PQl9mL7ki/eEcL
X-Gm-Gg: ATEYQzzYj6FL/+Qy/XKimlRTKG3UkMztv5LzrdbMk9dRQC+aSLRdXUftJu/TCxir2cA
	KO7aI/ioazx5dtg1MrfSjHg/1SICSj9EE20vy3yPLyDW7WJIbD08LjOPThgrPTwj+k4tmRhP1WI
	QEKbb75L8ugOrcDY2pUYixtVHDID39VTsgfNbKNwTw5dNq7TKrxhjKOudJXY9L0hS/QH68b3lZf
	yJgytRw/YFpdVramrzWhSuweo1NIsVPAw3rlL7CY5okdag3nfQ7YAjGKshcE7ZbM8SLOQ9fsGvB
	ycFiYlSP4ss6rutQ+jjVwcVL1eP+YAxUbvxMkUT95nknUfHirzILzXj+YJeZfSP16fe2ccNBE1d
	eMYmIFhgtjaJC5ORTP9cCpiulhCszMtGklqyasFH3CxuiUn72G4B9hzljp601HJ6Vp3YyKSuAkL
	M=
X-Received: by 2002:a05:6512:2390:b0:5a1:34d2:b6da with SMTP id 2adb3069b0e04-5a2796b3872mr1813995e87.31.1773856389225;
        Wed, 18 Mar 2026 10:53:09 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a279c79442sm669216e87.70.2026.03.18.10.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 10:53:08 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Mar 2026 18:53:07 +0100
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v5 1/3] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
Message-ID: <abrmgwxireNnqra6@milan>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
 <20260317-vmalloc-shrink-v5-1-bbfbf54c5265@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317-vmalloc-shrink-v5-1-bbfbf54c5265@zohomail.in>
X-Rspamd-Queue-Id: 6604C40012
X-Rspamd-Server: rspam07
X-Stat-Signature: ozh4a4kjuk9jiuikgjztxdg4ib1g1hcu
X-Rspam-User: 
X-HE-Tag: 1773856391-677989
X-HE-Meta: U2FsdGVkX1/fhVI8td4HHtHZz9pdEegiK1utbWx8Q6sKpsc6IpqRRl+AyHLmBOyfLQSW8Oh62f4fETBT5Dj7DRMw3ptDdHUa6/NmkcUZFl/ygAAMIhqQ97gmAQolHLZs00EIntDe8c9ECkpqg/XF0+DtxDlDw7J4GkCTs6vj7dWb5fa3QunSHF+wBKWaamLcipxsGoN8a4jAPUznYtmQFbi3FYbFxCJ/X1PCXh36hLfNwPZDFcXGyX09/yNpI5GsXf0AkoordywX2M6RS/oP7wyWWv0g4NKvoscozwBr34EHca09gYtrghbn5+sMAUwt4/mbeoZWCAaa3hhdko7J4eKTPaF7fmSt6/GeSoXkBfANH6tsU726nxKFvbCTj7932NzpbhQlUuXIzMIkqpuI9U5xZL9t6lP2UYVXsF8pSCbpK1C/g+S/52hdOPihpzbFDfw4oxwWosuBt/aTrnDTVkEfDdbM32s+Hy7a/mEDLrgYYQiuZHStJx1A7Hl0AU3O5XWcXKgo6qI3TZI7y0sHOjrSONUwywryUPVd4L5VdV27SUsyo7ALw6O0cqR0IoofZQEetvnFWmfUNfNh+Kzsmun+ENNk9OwCiVyfZbFOeOC9DRpniTg2qb44ADiYHvvhzvifYMiigUdbQUxqr5rWcIINjjqdP63nveQP5HdkrLJhMjLXKa/BH7v2zvyx3f+ivLR/gNNYPOsieFrhIcVmNbrdJ1B722J5q+VrSbygHPjS/oxRoOQl7wB4b1liOtHGokQWe4rohAr/or8403PIIj3iPSF9yplo+QCERR/i2tFRpUi3aQFNr2J0wRfnc+Og00z2ivqvmmWLj7XHU+Km4wy5tmPO6zh6z5r3qCcOdqeS5hInttmgSKa4n/GotJT18TmcsAnSIhuuOLCUEDGXEHktmqoFUaf3tl11WuU4eykiEFkRkNWVmHAFeKPGyGbMpo9t2bmcZM/wWp6i8Pb
 Cg2uLJ3v
 PVBap6WztHAWPAZd5tchTnjYsZeje4ULQ+8T8tM8bl9RMBMcCGJ+b4CwVLbIXnLwe8ccLT/tRCdJt4bbh+QGaxGqN+lM2Yb7JcSSQ/M71YJxseKhVeyVYEqGc2iCIv0EUBZOr2y+sSyYbGLXDRhCWR1tS7MXr5C3ROM9Q4pCQeFsHSGWq7Wae7YrPt/MqiPNiIiMpDwxuy916S0uILFySQOLikdZzAyNdV/I26Gb+tIZQ7Okpl+7EN/l5JYzptBZ0P7OVGbhn9yBr0NvQHTfY5UPdSPNtn2mbmhJQk/sLfZwhCKM6pL0hmM3iaxEzYc/StJjrzJtIXnA3cwD/9s8O2+E4CLTeLySv1hMg+VEGE8ZB9wjYH+TLfN6nQcGQPaYoa0Im9RT+atH02HUpAhCiS4KMC5gXG5JqfEAAVWsJr8q1dIaQVwg2gqQOeoQzaDkRQTk+8ZgU7kryOwKnw60iTmu4FrlQf8ansLH9xaBjpUemdue6tbT53UXrw9BnW1iOexFHkskoKc+4KCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 01:47:33PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vm_area_free_pages() helper. The helper operates
> on a range [start, end) of pages from a vm_struct, making it suitable
> for both full free (vfree) and partial free (upcoming vrealloc shrink).
> 
> Freed page pointers in vm->pages[] are set to NULL to prevent stale
> references when the vm_struct outlives the free (as in vrealloc shrink).
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 33 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a..b29bf58c0e3f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
>  		schedule_work(&p->wq);
>  }
>  
> +/*
> + * vm_area_free_pages - free a range of pages from a vmalloc allocation
> + * @vm: the vm_struct containing the pages
> + * @start: first page index to free (inclusive)
> + * @end: last page index to free (exclusive)
> + *
> + * Free pages [start, end) updating NR_VMALLOC stat accounting.
> + * Freed vm->pages[] entries are set to NULL.
> + * Caller is responsible for unmapping (vunmap_range) and KASAN
> + * poisoning before calling this.
> + */
> +static void vm_area_free_pages(struct vm_struct *vm, unsigned int start,
> +			       unsigned int end)
> +{
> +	unsigned int i;
> +
> +	for (i = start; i < end; i++) {
> +		struct page *page = vm->pages[i];
> +
> +		BUG_ON(!page);
> +		/*
> +		 * High-order allocs for huge vmallocs are split, so
> +		 * can be freed as an array of order-0 allocations
> +		 */
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> +		__free_page(page);
> +		vm->pages[i] = NULL;
> +		cond_resched();
> +	}
> +}
> +
>
Since you will update second patch, probably you can also improve this
one. To me start/end variables sound like a VA range whereas it is
indices in the array.

Any thoughts?

--
Uladzislau Rezki

