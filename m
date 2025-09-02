Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74A5CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD838E000F; Tue,  2 Sep 2025 16:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E498E0001; Tue,  2 Sep 2025 16:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055498E000F; Tue,  2 Sep 2025 16:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E45408E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:16:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9638884297
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:16:48 +0000 (UTC)
X-FDA: 83845418496.25.1198C82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3101F100005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:16:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aTx1Sgt4;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756844206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moCSkIRbJKOTPrlGJxHnzsTIsOlS9Ui0Q813Wpu9jNY=;
	b=t7K4vdQscZ1STCyBSdnR1x8/+Bvm/mQPgIvQ7ME9fm3BPvs1+2VItU4/YoZc4S7THvgGbx
	sZ+eyVQwKHog+qvaap+YhhrfredkbLhrhPUu7vNhwDRkE1n8tV5TYw5/HYcGMdSBh63dlx
	3foo1Ujz4GRqkdXgV1TbkGEJcgQBg9Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aTx1Sgt4;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756844206; a=rsa-sha256;
	cv=none;
	b=Tzpp1U2mlMwda0tQdC4sUh0ceYN156H3s3U/7Al5Pw/Q295zRhcgNEUIlcvXKqzSJtpUCt
	Dw9o593JzbQMoUI3FXfxyDIMHipjg2+8kGUkGy1FygmrGgYyQo8VdlaaN0tvbcqXzrSGIG
	3/dVvAKovGwR8q543DPLNjr40hVvD5U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756844205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=moCSkIRbJKOTPrlGJxHnzsTIsOlS9Ui0Q813Wpu9jNY=;
	b=aTx1Sgt4gPAWcsBgDGlFmQwl0eI9FhmbTq05fc5vfZ2J219yp2ZXFOTzxvmgt45/DXH3O+
	CQ59hSgIM2u03IgDUWNiBE/wyPhOD92gaacvzsZs3WJpR4BBR0LvLpDBDuxt0958ChPls4
	D9QGTRE2RgG8bxRG4Vim05YDWmE+VvY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-FfWbF76BMq-HRyhPULs3Mg-1; Tue, 02 Sep 2025 16:16:44 -0400
X-MC-Unique: FfWbF76BMq-HRyhPULs3Mg-1
X-Mimecast-MFC-AGG-ID: FfWbF76BMq-HRyhPULs3Mg_1756844203
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b9c1b74d0so5536905e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756844203; x=1757449003;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=moCSkIRbJKOTPrlGJxHnzsTIsOlS9Ui0Q813Wpu9jNY=;
        b=eghNGFcEqGGe5lXXnX5l1kMt4KuTqJ+/gi2crLHiqwbloIafPvlLoTvQJ38cr+Yynt
         QYkeL7nNjH5CMqKMXg9Jqw5MUvYVzO/xPWsQ2FXFO7TSNEsqfGqmzEtX8KNRCYvDAcqy
         dms2hLButpvz+a9sbPF1TWgjCmePINzw74MBdkX+TmuvsU7MF/kNzHMRCVBe6eocXpUd
         Msr8LEYg2KRXRAbWBEBYwh3FfXE6RM40TNkbesPy99CFqYgouKrmuisLmvJu2RK2YG4H
         ZePv+ZlWjUP9FtadLrnIK7bx1+8EA6spQPSgggdOmUufcCc4mNSyN/MKwoa36fhoxXas
         7IEQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1oHXtxmqNkP/+Cjbgy2LEOvClkKKubpXyylrVSMJskwtGP0zktBojBwfS4lqiBHNGQxhSeQBfwQ==@kvack.org
X-Gm-Message-State: AOJu0YyxiL2IVUEq304srHHiln0P1Fm7ODLHLStTgpXL/9B3ZYcv0aYn
	JHitsoO7G0ree4a1cfvjznsNIYH+FGnAyO7AlIph2IVDwICCngB79xo7ZokuLlczXX/DwGv5gkG
	W4PtFu/C2RZ3pNb6eslCC9wj6px+IOWzAILF62xe5Bz8VVAN8mSCh
X-Gm-Gg: ASbGnct9Jjk3A8cIQ2qNnf2mBhTR8ZpwL41lYYCC9tXF8hVDQpXvRG3ACoqh1idOFX7
	ggGOAX1rMjsPGQYKMZ6hGvJ8fWGREDGsQ9YRtv1xjS5/5wQZ0XfpCHhNfmPeZR16AmUclGTEv2X
	N5tyjz7qhhIYeXXwvorMeszjcDvriEqRwxQnb55btrwwrSrtxpNsk2HVvGamHKcOVMpDK+I+dGF
	Nht4aE4evxWQAH8VBgDt3SI047wcLRgrOQJFT/UDCetrjgT/bOgUM19U/oBSgO3UBofbrWXunQc
	dVyGW/t7sJ1QvEfc0G2/OBMylusMIs8wjHG57nav0x/cQCdsnFSNsUc03Wf2XTMzMdLo4slbQdz
	H2pvX946AZOvqfmuojbzincNwnbenf8j/yq5fPu376hGhU58uwxp1PTjHAkPtJ7Jukg0=
X-Received: by 2002:a05:600c:3556:b0:45b:8822:d6c1 with SMTP id 5b1f17b1804b1-45b88321bf8mr98213365e9.12.1756844203251;
        Tue, 02 Sep 2025 13:16:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+ddkAwvHhUuDPpLEBDSnfyG/LNzI9bvDVvc79AySZ+2YyJ0o9p378EsY7AzMcoSpYVEgtyA==
X-Received: by 2002:a05:600c:3556:b0:45b:8822:d6c1 with SMTP id 5b1f17b1804b1-45b88321bf8mr98213215e9.12.1756844202821;
        Tue, 02 Sep 2025 13:16:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9dbfsm20804803f8f.43.2025.09.02.13.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 13:16:42 -0700 (PDT)
Message-ID: <643f5482-cd34-4534-8cd8-69f32482bc27@redhat.com>
Date: Tue, 2 Sep 2025 22:16:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/15] mm: define clear_pages(), clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
 <20250902080816.3715913-12-ankur.a.arora@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902080816.3715913-12-ankur.a.arora@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vM9xdNjUyZhvAkFBRloRjXmtkQxABFaIe6IgQGBij_E_1756844203
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3101F100005
X-Rspam-User: 
X-Stat-Signature: uwqjwkjq3xkaqoeikquf97godmbiwrmm
X-Rspamd-Server: rspam09
X-HE-Tag: 1756844206-524209
X-HE-Meta: U2FsdGVkX19m5klBF63+/35zacYI02PViy6wOwIedOaoYhUBgyoZu4TzSahsGQvwJDgG0tzeWKSyrhn7ORLIm6aeC1FRXa5/hZKFqsW//MLAJVLP2yPYlZFa9iiGHYVwldwT9kZo1CY/0poi5tpgwAfuE4J5+MRldQOBWahn3x3RofbzIgMyJgXAKpwfdvVsER896d+Inl/wuYq4RdYKS2k/JodXzMOcnYAJ50oZz+MUoYDNeG+YCNPoPfPvRZlyE8YhA1s+YaaZ712XFMq5lau/QSdaRSGmZYlpFah7O19OrLC4MxmkIqeLMTEX6gZof/tRNgCyQLUdrbeLKHjVFgA0KvprYk776jk8q1rLk4yzUbCIN3osBCKxXhNy5Y4EjcBK+7/7lpRBR+Kd9XXLT+2wuX8eFxxGFJH39S/9fFT/dEAPV0OqM1b8aHNoS44ecPmezBG/VrKjBaNOV1m2HUuFgfczHPNtvUJ2iLqa95y8hL6C/BLJd42szMfso33D1ErywoQLiNPuVs3NY2J1EGqZ0NrEj/KZhTAJ1h8jUYODEsPxkJL4ygm2yKE8MwpdTa7U5P9dIJ+xB1Se2WKBk6ivVB6DYspgfgGMwzPX/pYRHA+j/x1rTZXf2hM1qsWS5AMS9H7l8qiakjQCDtEtmBw7fWXPDkcNIRPbVE7VtteZjcKdDdJZzzth6+7fQ91V3iYamDtERP05HOHEm/oB44TTJLZro7JlG8wBcf4cQhpcgiHorXvwzUyotUiG/uRWs0frtXXAM5jrxeUM40Ywdg0+HFxNtcBuEQoMTXKJdwPi5vK86a6XKh3xTu86Ajz8VzOdpM3/6a7q2yKzMg6X+tnpqIiRNguafPZCePfkLx95DIyq2XV0Tas9ydgC9bxIlaDtxeIf7n5GgedG5BcKJkfratrxPmB9exVZ8NKnPYbiPh4F/Ek/gF74KSes/Viwso8cYuiA4QRL+Kus7oh
 tTsuPVi6
 8UhMZh48KXBPVn/ObscjtPLh6lV+zk+H9TW59GfeO6REUGQjJGxAhwM5tCPsPc7uoMVuUYNRWAfI5UHu815CeFM4Vso6F+hpHyMqJaj+bxPQOBdvp9OGp/zJ5dAvMVym7fh8tee36XR0ISjFrLJlyhxiOis90iPveXxWf9v2u6asNKdmFztLtFmiR37VZzoBAOvJjBQ+BNqwaRCNyJSUwbKOXcTdX8SDu5bL/mV61FNCq3nTJZ938DrPiduAvMFNX1x4ffTIG4e088hgnNs2JZUvl7hVEkUo60qQXNer0FmtTYcZv1iIhcGwU4mT3AClfiUGkRMLyTcYuPKzVNxmW74/+vZULW8l3DQyzDB54fh3h8xEdnDGx8iMY1l/dnOkzwaXcU4GJeoSsrXzHMrQZfRrQlWX7CGHM2kopHyDHKQ52TmzW5JrnpHVmD02pbVvbGAgFka7mtlz/Xj9+oHK5nMZCk6VBs4jybWn9Py8KL7dUMUEcuGp9zEcEXfimtkmfR303Fly8LM+XP+QzEr7vKe1z0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 10:08, Ankur Arora wrote:
> Define fallback versions of clear_pages(), clear_user_pages().
> 
> In absence of architectural primitives, these just do straight clearing
> sequentially.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   include/linux/mm.h | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..b8c3f265b497 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3768,6 +3768,38 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>   				unsigned int order) {}
>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>   
> +#ifndef ARCH_PAGE_CONTIG_NR
> +#define PAGE_CONTIG_NR	1
> +#else
> +#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
> +#endif
> +

These likely don't belong into this aptch :)

> +#ifndef clear_pages
> +/*

/**

for proper kernel doc

> + * clear_pages() - clear kernel page range.
> + * @addr: start address of page range
> + * @npages: number of pages
> + *
> + * Assumes that (@addr, +@npages) references a kernel region.
> + * Like clear_page(), this does absolutely no exception handling.
> + */
> +static inline void clear_pages(void *addr, unsigned int npages)
> +{
> +	for (int i = 0; i < npages; i++)
> +		clear_page(addr + i * PAGE_SIZE);

If we know that we will clear at least one page (which we can document)

do {
	clear_page(addr);
	addr += PAGE_SIZE;
} while (--npages);

Similarly for the case below.

> +}
> +#endif
> +
> +#ifndef clear_user_pages

Can we add kernel doc here as well?

> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
> +				    struct page *pg, unsigned int npages)
> +{
> +	for (int i = 0; i < npages; i++)
> +		clear_user_page(addr + i * PAGE_SIZE,
> +				vaddr + i * PAGE_SIZE, pg + i);
> +}
> +#endif
> +
>   #ifdef __HAVE_ARCH_GATE_AREA
>   extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>   extern int in_gate_area_no_mm(unsigned long addr);


-- 
Cheers

David / dhildenb


