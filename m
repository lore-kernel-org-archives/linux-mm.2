Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA87CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2E08E0006; Mon,  1 Sep 2025 03:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A35B8E0003; Mon,  1 Sep 2025 03:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B0B8E0006; Mon,  1 Sep 2025 03:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27F58E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:22:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8634F1406EC
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:22:52 +0000 (UTC)
X-FDA: 83839839384.14.48B40A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35245140002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:22:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QesRIq+3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756711370; a=rsa-sha256;
	cv=none;
	b=M+zVdjlo20fdwSLjyXSCRaUFGjjp0C070LCqm8lFr+zq2LYQROBEi6fL4KwZNv0PHPtXYF
	ntfJeMuEu/Pb8/3kYiWkxpVoMZ1KIElRXl+04u1IUia6gajeVKbtZhNvIG4uCToOzurRWC
	UOrydFbgsbpFDceX05iB6t1EjIcz6LE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QesRIq+3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756711370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9V4R05sdobHBJHmAx3r85pkYP3EzkYBt4hLu36K3MfI=;
	b=4LQ9aTgMQEr+CgXxBJqYr8y7ILJ/o8v/UkdDCFZ2ZtCKTo+iPzKHMui4hsKf+cY+JzXmfs
	lnYahmG41lvoWbgsUHpKbfjmgBIXmjgsx40bK1G0QQnSU9DDFc50IXs9VF9JieXBtDzPAl
	zrI0VOHr0HqS4nJ92WyETPorn+rEhz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756711369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9V4R05sdobHBJHmAx3r85pkYP3EzkYBt4hLu36K3MfI=;
	b=QesRIq+3o10cszTZBvWbkKwgZOwrko4b/imL+7PR1CfaxEX1H03qdV7OKBDtexjYyUyKIi
	HmvYm5RWyKoy+HdurAQDPdp60UMsvBUsjYL8xnSa5OB0GT8i4a4jJBq0cqFnuMHYJYuVF4
	jyJVc13SVjHOE5V0SgM4ivBKvzKhdus=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-VS5vtgB7OaCJGmOSqF8Tcw-1; Mon, 01 Sep 2025 03:22:48 -0400
X-MC-Unique: VS5vtgB7OaCJGmOSqF8Tcw-1
X-Mimecast-MFC-AGG-ID: VS5vtgB7OaCJGmOSqF8Tcw_1756711367
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ccfd90630aso1690260f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 00:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756711367; x=1757316167;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9V4R05sdobHBJHmAx3r85pkYP3EzkYBt4hLu36K3MfI=;
        b=SAqe2DOqwdefRGJJzFpfMu4xWNeuXgn0aoB9CQB79CS3KnwKLbpRbEsVBW/TRaQx9G
         t3YnA9Oj4cDC15IapmY0JZpCAnTqO/tFI6yawJcYL/JylhK/ORcZQrFDMenTjfpE4mYb
         zlmU+MULfpiBxGJRGPfrW8hsffLFHBcB5wWhWGavwb32HxBGNgE6BJlt8OLhOdbsOZvP
         aRg0wXLxK4Q0RpSaD8LgScHdsu00Mqvc01/7G7avq2ywaiqUIOIB3wz/2e4fwPfTIi0k
         GxO3F6Iwc2f1D2i1FGldNNHLrpUSHGRR/uYnxud1rOYUxCnByFEkOSZp9NtNON59yDrY
         hJ+g==
X-Gm-Message-State: AOJu0YyDrrEDJxmHVepM0MGxBi/isnTvmpRG3pqQjwLo8bC9gC+NQSFv
	bkpXNEbkcJObv9KyXoPOQxb2YLG/K4UyBIye9kRgm1obqeC/RBRNG3Ptpglv2vZAkL5YUXNLDCH
	Znlgub8mrnOSiQRO79y6P+xofJ8t3AmDFIdNYaoURamNlxngJR80h
X-Gm-Gg: ASbGncvXSGdMV9Lm/qzC8DZge24xg9cGAPDTI1P4nevF0oQz7FFr3ozzu7muyyxeAXW
	6Ne8v7B6zLhRq5IIub/rIZo6XSkQu5u72FGa9BfLT4M5X4tlMJnl0AQebK9bH2sNKy+/NySaFtb
	LFtnf4X2M5waOIojFmkwFq9axQ5iJg3ks4QT2sSpSC4p5xq+6SPq85c+qlw8pkZ+jsS04uqsFdQ
	i+1RVsf3nzgEfmDLccs5bIFxJLI6tU9BOwg91SFUm5NANwtzTVgfQXLLUXh0ZefZakn2svs0x3o
	6moEser3Tld59puvzUSga1G70EajerTivKn5iNQMRGSaNjSrZgp7xL9Or5p5ItIuT4wuXAC7I/W
	bDpET15bYYVunLP/sdNj4OKchMEMELUBtnRNsiLwInrEmXBk9816wjvbLOcvPxC2jG0k=
X-Received: by 2002:a05:6000:42c9:b0:3d1:e22d:df2f with SMTP id ffacd0b85a97d-3d1e22e12d1mr3737085f8f.23.1756711367089;
        Mon, 01 Sep 2025 00:22:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVNYjwWcm6gpW0uY4rkHHxrCMQOJdbdQbgUiX4+ObJzl258/8a6I3ZT74/QxiH1Rpl4yYyjg==
X-Received: by 2002:a05:6000:42c9:b0:3d1:e22d:df2f with SMTP id ffacd0b85a97d-3d1e22e12d1mr3737072f8f.23.1756711366670;
        Mon, 01 Sep 2025 00:22:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9cebsm13932480f8f.46.2025.09.01.00.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 00:22:45 -0700 (PDT)
Message-ID: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
Date: Mon, 1 Sep 2025 09:22:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250831022701.2595-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cOdmCqeIRTY1IA3EN4rPK252RbvV5n4kgCZQFPIJdLc_1756711367
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 35245140002
X-Stat-Signature: k7ndgjn9ank8yz8by8ojcm44n43kbizq
X-HE-Tag: 1756711370-375742
X-HE-Meta: U2FsdGVkX18M6HoCwVGHuPMkLsrvmnptwOZMGySBDswELrZdPjEFV2LwBXAy+ol3ZhzofX7pJBoU7mjG4CvX4xup8cjP1mtOTuPK6MbkBtWjyz08TvpYEGIt2FI31/PwrNDfSC11CCggeFjpnMKbc7EA3J4uhyERNMpLPAbV340670AyK0unyxy+Rr2b5+yW1aSTwkUjKrCBuKXJnobT1XngybuTB6wr7mx/MWRXkkVS7rn+BzB3ACGtjLchzCWZ5TYFwh8dW4rNl0CRpWRexVUZgJQb5I7KTxP47NgkixmIW70byOTb781fA2ysyPL4dpdJig9OrsUyaLHnVSP4liaLZlCSedUhuBNQkpJjhD112sHGw6kK966veb2Iu3o1cOLE534MAIFF7E6DsntEVp3vJ+/H/DnygdxrfK0Lu/VJKIJ/oMVQ8b41j864/VTZIFwaeZWPOQcK/YpF7hiRuDXQMpfud+kGNDGpUK7JNHe/ikcjrGO4qye/xm2rz+k23hSJly/zAhmuuqlu7wxAKbTV/OPni7qmpC/izIn3xpn0IbFiAWe5OPDrBUQ6+sBAEC9PALdqoHwW2uvVpcYoBKMHEtrGsBq9u1uJa9Ns/9QqnMDAzXwBToGyN/WAp96LLahpUfdnOzu4LP6fkigQ6YuPDS2cNgSZTHtdfX6WshNLs63EWzWZ5FIubi0HxriqLBdbdHLrYSXA7BXNYk2z9FX8ZqWF8X885xlnAvd60hzRGJFo28NTfVjDlTtHMEbCu66KNKUAUIpgIHzZ7Gb4m+1GDLURWn+cH17KqRrr3WThnpzDW6MJZReqbqD03o5O4XG40DvzN+GQDhPzUSMO6R4A1MIiJ/MH2DAXdU81yV/8OkpN5uZYVMz85Ak+lnQvD364DRtXvG2NTDNPam+ywsj5oVUirLcftafnWvspBsRYkEgZ12v5brJ8I3xCCsKCLRsHukgaEVd0HaDrDDK
 At3U2Nx+
 hbqYdE6xngDkl940MhQvC4rzUQ1uChtEPXH/9TQmqs/BSoOcZLG+BQNV/HAmBgBw6auzoloC+QiFvhHSLDthvqtfj0shO3DjAeK4FlBI/5CRJSLjyZFWI6x0B6jZ6U2fTyo+wCP4ipQGJFu9cCXWN+eidWBb4/rGd+hU/lygqnhSyu54Xy46czCZGJAEMgLiU/TtoF/7+vrAUaMQuadxpmhZR5cFIkZWW/NInWna/EwhjNR1Wg49HnOI9+84cSrjSm//pX+wrlnhsZiGNuIvLLceScJ/GDcsvxbI95AyazEMSy4bill4q/HITh5Tw+djAlvZi6BA561Hk/41SHB/UPpp1VrJY9e3BEVLej/lt7C3+nJpgC5GkeqGFACuqiUknaN+jg8OTxN5yqHtgk74NOuQYyDE4xsK8TUAVXWPb2IuvPyQDYwier0n64xSEIvemQmWhLlBut9RGvTTtexvo3c7Y8F267JTrI0m5HJc7NKh57gDh684y7/+sLByn+XgYBMSTELcA7RSvDpk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 04:27, Wei Yang wrote:

Subject: "selftests/mm: verify page content after remapping PMD through 
PTEs"

> After mremap(), add a check on content to see whether mremap corrupt
> data.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> 
> ---
> v2: add check on content instead of just test backed folio

I'm confused, don't we have that exact check later in the function?

Your v1 might have been better, unless I am missing something.

> ---
>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 10ae65ea032f..229b6dcabece 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
>   
>   	/* smap does not show THPs after mremap, use kpageflags instead */
>   	thp_size = 0;
> -	for (i = 0; i < pagesize * 4; i++)
> +	for (i = 0; i < pagesize * 4; i++) {
> +		if (pte_mapped[i] != (char)i)
> +			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> +
>   		if (i % pagesize == 0 &&
>   		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>   			thp_size++;
> +	}
>   
>   	if (thp_size != 4)
>   		ksft_exit_fail_msg("Some THPs are missing during mremap\n");

I'm a bit confused with this test in general.

We do a

pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);

which I read as a "NOP".

Questions

(a) Will this actually do anything? Also, maybe it does now, but can't 
the kernel just optimize that out in the future?

(b) Is it even guaranteed that we can access > pagesize afterwards? I 
mean, we specify MREMAP_MAYMOVE.


I would suggest to just use mprotect/madvise to pte-map a PMD-THP.

This is, of course, independent of this patch.

-- 
Cheers

David / dhildenb


