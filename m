Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FC9CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB238E008B; Mon,  3 Nov 2025 11:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC118E0057; Mon,  3 Nov 2025 11:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB52A8E008B; Mon,  3 Nov 2025 11:03:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA0BA8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:03:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A363112ACEE
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:03:55 +0000 (UTC)
X-FDA: 84069766830.02.D3FBA46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C3F702001B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:03:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ERy/tB+e";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762185833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAB1nRPhZgw2D2F/txfufevKSsNDcd09VLHZkiGFvSY=;
	b=cKLufkDg63FM4khkIEaikBFalN7S63Kuhs+tvIRL8+sPkcNb83Ta8QoFLzKlQ8cAF7PBHY
	2mQCpOL055zOt5pA286T72dYUslzmgqdaXEGFIxq6VmjMfA47/oOp1NLds6uhzEavKtrEm
	wr3yIS/Uazvn6cqoPTRmsAkE1dLVafg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ERy/tB+e";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762185833; a=rsa-sha256;
	cv=none;
	b=ZtopA8uOiLFhMwiny0UENPbD7XAO0f0DBp3tvIgZxwfW5LTPhqICTc0Y0CFKs3qkwamHk4
	ktxQcOEkz6hPNoYkA1n7i9QHW43avAFXeshxf9EFj9lHqvs4e0fyc0YxoUUi8E9uGhCLbl
	fRtyM4Hu8EQy9evl0qa3p7bALJVrv7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762185831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lAB1nRPhZgw2D2F/txfufevKSsNDcd09VLHZkiGFvSY=;
	b=ERy/tB+ehZto1IpdDRbiQl00jssLP7gyHWstsZKqt+ljYZbFZNciSW6++nCbhTFi2MiDft
	NlqifGfj7MiJvAG+UMTHqdPFLo5AfO++z2NP49AwVyIVWet/odHc15SCit5SWmvkfLPaQg
	tIxBKeB2PlX9vGY/DlViI4UN7weqXtI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-bVLB6bNHMSauhsdWD0H9Tw-1; Mon, 03 Nov 2025 11:03:47 -0500
X-MC-Unique: bVLB6bNHMSauhsdWD0H9Tw-1
X-Mimecast-MFC-AGG-ID: bVLB6bNHMSauhsdWD0H9Tw_1762185826
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47717c2737bso17705175e9.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 08:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762185825; x=1762790625;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAB1nRPhZgw2D2F/txfufevKSsNDcd09VLHZkiGFvSY=;
        b=muWD+A3DE8hHvLkL+2w7HYDiJksryMY6Kh5WMTKwZlkScLyU4/jM/tNEOi/Q7V9UFG
         CXMIF9blXqZTd4cCfFF+ZrUr1iEGjHlQjFIr7d+UJ6T7AW5P/OCLEk5pgCotgxJmx/Q/
         2+xz1r0OgGMAuMXTWJYYyJlvQo0X2Ltfl4VvUPHzKJTywxOdj68Mh2Q+Mdx+CENFRu+g
         rRgX4ZWNGJ4okdnLFAzI87UWfouk0A02UB6gcflnvN/Kk0G70aH6Ja/InLbuCGdNaCVg
         G5kORS7D2ELQFOp6xYnovywI2t2+oBLXslYTjrCa42sGeq00skJZHDKHoRMcW6dRgkOx
         MOSQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9INGzA8x954IiKKaY2SLere1VlTfQHilee0mwsqIEEI1O/qoSkdwDKYmiAeyjk7XpaqdrnATJew==@kvack.org
X-Gm-Message-State: AOJu0Ywn8WzLYSrFE7X2ZYXeSFoultxMW5rNLwCmaS4hGJZfB7NWHN1Z
	9hmaZSHLiXe/FSld2vrvGHF99kw4Zg/C9rxQSFEoWRPB3ZO9cLVqU8Uijcv66pG43fJdu0r7NZ5
	jDjt3+811hgVFa6nAD1yNYH/r35uT8p1b81G5qB97LjoXzNEPhqpo
X-Gm-Gg: ASbGncvSZTvW6IwE3sZN/8g5ZV6MxjLzhjcLbueX09Z0auOsLPvydbAeWTX+egnrd5r
	4Y1RtvvzVIX6Los6bwIccZwQWdR7jOrCZtL/wPpU8E0XMA9oCEyq82/m+boBWP/Ez1gGWYBiM6l
	8j4tAOrKPSU+nOAIWnPch7JE6aLCeZ03A4Dxn/Xx7p3pmjYI9BxWtwsp8PiRHi+J0dCDzgwxuXo
	DFkCjAZA9QspBcuyfrgFQhugJ4wbCktA2CZD27KbR368Vq7k/V72J717X+r+VWy0BEvgnq9MsS0
	U1TG9KnJI8PO5KEypKJ1eZUqcD0R6r+9MqW3yz4xRurRWFUGARAAdXR/O76Dr41uQ6Qu0X9UDqb
	51YCQu19/MfQ1f2tJ0mu4ySQdMBQQ5wsHxDTTsQ9wIukWoakBEZzoUphhHo2OIMunXp5vIcYf4R
	+4IDGhrahesSJfx8uzlfnaONgVoIw=
X-Received: by 2002:a05:600d:831c:b0:477:542a:7ed1 with SMTP id 5b1f17b1804b1-477542a7ee4mr3984995e9.19.1762185825549;
        Mon, 03 Nov 2025 08:03:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5tyJHb+sues0m+7ZNZilqyo2L9Cho1JQDhJMCuFOgAOZW6Lsc8SY3FhL38SgCM772181+5A==
X-Received: by 2002:a05:600d:831c:b0:477:542a:7ed1 with SMTP id 5b1f17b1804b1-477542a7ee4mr3984625e9.19.1762185825048;
        Mon, 03 Nov 2025 08:03:45 -0800 (PST)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c48daa0sm167032215e9.3.2025.11.03.08.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 08:03:44 -0800 (PST)
Message-ID: <b6f5b3cc-93a0-408a-b7e0-72462f3fd549@redhat.com>
Date: Mon, 3 Nov 2025 17:03:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/12] arm64: mm: replace TIF_LAZY_MMU with
 in_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-9-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-9-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EQA2HgPPnIp6yctTo-wcpgN-0uCbqMLYbV790-Z3ONA_1762185826
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3F702001B
X-Stat-Signature: fartskch7ypw53h73bax5o3yda4pcy9b
X-Rspam-User: 
X-HE-Tag: 1762185832-881789
X-HE-Meta: U2FsdGVkX1/mgLrgQsBURM63Bm5N4jORsjyq5wUBU9JyhRsBCitVrQf+d/vnE4Yf23wwmFwMhutoZQIU1virNVBUE1jayDYtFEDsp3/n6xexfl6bX21dcKlB0KeBm6Fs0lXxB6ReagAMycXwsHW5tWZHAv8y+uxHW8TMD1BE6+2i/HPsGuL3hFLP5zZy2ENaFbQGw6DLm/gWQyTuosboxfhTXBXVAtjv8/pL7piJs1nd6bCR2VSXTPzHb3jggV2PeYBNPJmoyH3rvG2KDJTNxTn4w/y75EZajXtmlC/Sy7O08vdoGCE3H4cqyCcTI7G2zxgHgEmzIbsQH/Keekv+9IvZp9nFEhhofqrR4y+NjIfdOmm/3MABULq5VO3ClyexAYcAman3JE8i/Zm9DnGkRHtmPsMYDFdsn1LBpW85+1n/R2t/iZwm47JETDi5v8Y9BNjUQbIkUO7ZszoGMBoG9WeF73j00Mq3v6PbHP7wR1k9I3AODsPZVTDTX/hrX5+UrUtgJ8LBM5/tyMep/0PHU6japJfGWhTZM6T9E2zmeivfRJ7JxtLJ5wDkySqV7lUy87YnC0gZUr2HAua1HCHu19k4mOCPnZsg1WaPRGh0b56u2Up0UAKMmXaL0Tvwe+WuIpDw+14iwG97ppfhdTqZ+cKhLT0AI6XWA+YJ83i0x/S9LPqEbHBTvdrI1PJ55IG9FQ3hmV0e1PYQ+Dstpp9njzFTFs9XrLHuvIYYT7XQb8smBm6Z0t1fM81ed5Jv+AtkmVMvVteQCpNr06MzXM3cSPrKgJ3ZvbgJLB6dGkigbv/fdekdlDn5R/QscFR5fEcvwv4Flp9/70C2B2sKSExGgrMaLanck7S+/l7A1njdwXugBxm8+R/21T0bDn0nUKjoQDxOxfZdgf1WMS9HAe2+fk+6PP0dYgB7gLu9Dp79vcpXxZDXDB8jX37I4BJl117ABulaFG16HduQ4PiugfO
 94nfQjb0
 mxjnVnrf+cEnnj0Yk8Y8PVizItz06zfdjHGrxu5QNhNplkdMSyD6H3h9HqqfxCrl9TTuHOAxPE3dFYOdPoVkGfDro49DXBFXrc5CkK6CFBGW0glSRDTw5b/FJSN3r/iZjd+J7u10xi6IEz9EQ+dFk02jsNEzQR51cUAHfKAE5w6HEnZNa4eKI0sdD7OSYEngn34IcPzOa8Yei+NK6OciQPn+Zu9RPCcGCJud6QwVidlz/vqqu62gjgSLw8cdbjaYJSYEO1RvUQrqoVQoPBSaylR3AJhHxyVNgrLTfZhjEhZSHpNcIU/tFFhijJR5GJYYu9m9IY3vwJtaKa8DzyanFkU8BWNh5PlW1OpI0hUSgeBE+xtnxtUji9/7le7b4Vx7sx0tGSp/kRu51aqlW46WrgqFZHV0Vo5dHXYbqJDhRnTqRCGEYdDxL6UgSDfibQY7V/xYsN3yRlsn4MlnZJK8BV7XRDAD+4/3HqNXB+jzF38z3U/wH1Jay8sZsR1bD8u6jdQ/j1FPbQQ6zVq3fOdgMULsBFU+OM1vUzvpf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. As a result we no longer need a TIF flag for that purpose -
> let's use the new in_lazy_mmu_mode() helper instead.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/arm64/include/asm/pgtable.h     | 16 +++-------------
>   arch/arm64/include/asm/thread_info.h |  3 +--
>   2 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 535435248923..61ca88f94551 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -62,30 +62,21 @@ static inline void emit_pte_barriers(void)
>   
>   static inline void queue_pte_barriers(void)
>   {
> -	unsigned long flags;
> -
>   	if (in_interrupt()) {
>   		emit_pte_barriers();
>   		return;
>   	}
>   
> -	flags = read_thread_flags();
> -
> -	if (flags & BIT(TIF_LAZY_MMU)) {
> -		/* Avoid the atomic op if already set. */
> -		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
> -			set_thread_flag(TIF_LAZY_MMU_PENDING);
> -	} else {
> +	if (in_lazy_mmu_mode())
> +		test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);

You likely don't want a test_and_set here, which would do a 
test_and_set_bit() -- an atomic rmw.

You only want to avoid the atomic write if already set.

So keep the current

	/* Avoid the atomic op if already set. */
	if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
		set_thread_flag(TIF_LAZY_MMU_PENDING);

-- 
Cheers

David


