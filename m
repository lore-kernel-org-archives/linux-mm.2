Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D46FCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054CF8E0010; Wed, 24 Sep 2025 07:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C038E0001; Wed, 24 Sep 2025 07:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84258E0010; Wed, 24 Sep 2025 07:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD2BE8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:06:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F8CB13BBDD
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:06:53 +0000 (UTC)
X-FDA: 83923866306.25.0A27F55
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D9CEC0011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:06:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LDZWisd6;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758712011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klMbSfuXzMxOJQRVHD/MHPSONQrqHt6H8wwjZzCAfEs=;
	b=Q5wRVBZa1hv0q+xUpGLgd8XYcBW/DmUm8TT8SfsKgsw7b6xJvlGtUjVMS0lAtDKraboUzz
	s4cIvQMn8ofAiFlIJycFxit2NTdsRzS8tqn2ICRnj6//vk72L3Ew755s1J8EvLZRBwEGbD
	2YCR9DukR/yQ9PsuNMiYQ4ZySP9NkUI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LDZWisd6;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758712011; a=rsa-sha256;
	cv=none;
	b=XrrJjbo1ThkLUanrwh/Fl8g9VK8sSJrVHPXQfnrb4oWi1kJx7DBMa/3cCt3gnEY1mayMaJ
	WJBVEPAdaSOH6Km+8OC9lyIsne69JiO3fsicfpxnRKSS1cBhQ3Ei5q6hQIpMp07k+u5xq+
	YOH1K6YTXPI621NsrHyu4Yt3FOGzWE8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758712009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=klMbSfuXzMxOJQRVHD/MHPSONQrqHt6H8wwjZzCAfEs=;
	b=LDZWisd6echYtAzabdlAxDw6q8ov4sQgDiJdldVShIaRzBHrCdnA0O4g2EIObtHbeXxRH/
	kJc51I6qf9Wcf9u3yyzdSe0ftPe42Mk//uZxG9eAowmCkkLjU8xk1u1C0+XBrVaCe+0puC
	F1bKe6uszdWx6UpQr1BzafA59TbAQoI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-HrV-PIm8MzGig2Vdcdd2ww-1; Wed, 24 Sep 2025 07:06:46 -0400
X-MC-Unique: HrV-PIm8MzGig2Vdcdd2ww-1
X-Mimecast-MFC-AGG-ID: HrV-PIm8MzGig2Vdcdd2ww_1758712005
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e1e147cc0so24730485e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758712005; x=1759316805;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=klMbSfuXzMxOJQRVHD/MHPSONQrqHt6H8wwjZzCAfEs=;
        b=ob5X42WZJrldPkeiEt3jOSVMN2ZOGX7F1rUoKLe1JBhPicsf30F1kf7FD11WF4cukg
         wCbwi0cogO0bhY4+0oh3hMb9pAUsfe1U+OeKYiGm6gVkMLKiaYgK6dzLrkgFr0mrVyl4
         98l7C0jLeSwHW/nR/SenFj75B5qDvDiuKgB/jMDwdd65ZIT3z4lfFmzBXGV7lGFCbjJh
         WpH/7fvswuTPsstdnTrJsVOJbRGW1iF44KJarDMRFk6EMwj1nKF6/u9/V9CasPPSnlRd
         yebBzu0bA+rl4fnXmc0iY2xm4ZI5WJV7Zb4+IkMyaTbmxVT/GHRK2EE4ZF2vSE3I9OcQ
         AvtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc4S1MtwTpbNvrR+b4uhHws1OZ5Hk30AYJ47CGXzwRDeejIk+1mo2YF2wRj2IX9hXRWxOzLlZtlw==@kvack.org
X-Gm-Message-State: AOJu0Yxu6Nsi07i6syMZzu6JRnJzHk0His6rUFANgJIpe/NJobXo3yBo
	k/ovkxaq4GmtOor1f7/m9KK922IFavC7mXuDGOlBa/fxdzFBUf7ptezcpmtMyidsvGLguKoz9wx
	im8SvXnalf5ZqhJNFox8rx3xM9r7+e21req+/JxnYhXp6OO2ZAfTt
X-Gm-Gg: ASbGncsNIyq10jf4NTxs8NHPUE41EG/RxXjfKOWNC+ilxifU3d60eDE5dMC0lPGe4eT
	C3d8wvpBhjX/QBqaO0v9jOTSr/6+klDKXo2DcPJdImk/eXEugs60zOijEFi18GOFnBN/ScrY61p
	a0pjlWBPwzmmZ1IaV+ZQRKr195YJFMqvvC6vV6H/7mL7cEJsPFfNOZPVZvtfx8NzcG6hyOCh5j0
	LKykoAaF9SRX9AONtyBs/Sv1B0eEnRWaK9OZ3K2BR9DzNAGCor9k4wHIH5CLstf3LpEUnjA/nRm
	N2tf01sxCuoXB20XBmcdFc/One/bKNAvPMH0ECtQTvnAW8bIohr9iqXwLgjuoD9nIMKZpzu3gkg
	2mPS0sYrOq8m2P+zaJPOTRYyxM2UM7wMUEH+gzzfHN3UD8E/AquCTTObbrJd+jtKr+g==
X-Received: by 2002:a05:600c:46c9:b0:46d:f3c1:684 with SMTP id 5b1f17b1804b1-46e1dab52edmr56566565e9.20.1758712005006;
        Wed, 24 Sep 2025 04:06:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJLkhVz7awCPGzynHsrwSrqhRsmoA+KtGCiPRp3uPSe+N8fOH1QDxH0RgcAuMsM0GCOSJuRw==
X-Received: by 2002:a05:600c:46c9:b0:46d:f3c1:684 with SMTP id 5b1f17b1804b1-46e1dab52edmr56566125e9.20.1758712004586;
        Wed, 24 Sep 2025 04:06:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407d33sm27890308f8f.18.2025.09.24.04.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:06:43 -0700 (PDT)
Message-ID: <4e061f4f-cd57-4df4-a001-9eba80d1ded9@redhat.com>
Date: Wed, 24 Sep 2025 13:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/16] mm/highmem: introduce clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-12-ankur.a.arora@oracle.com>
 <6626d497-4c27-4263-9be1-1c05d2672019@redhat.com> <87ecrwewn3.fsf@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87ecrwewn3.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VbgJ4DpgiGTPF96d6QRfUE0h5JDspTRPZs0QcqxKlTk_1758712005
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D9CEC0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: izsjaumsez6gwrkacu6aoay89jmtb7xn
X-HE-Tag: 1758712009-106961
X-HE-Meta: U2FsdGVkX1/hJ6nYcMAPxIpBielhASC2r/1IMT0jKukw2zSsb2l2aPf92wvNzWjviU869im2uwKLVKCrA+QnLhjAOhFL4cqSVHJH340Cta7zaONV+7OnBFo9y9AF6XGJoZ1i6/M1Njuzrwy+K7kwDQzRlq+HtCa425xxFBhLBGwc4jbH6bfHpQy5jWa7d9fwFVcTkfmxMo4QNdmrvLo4kP808Y5YoYZltAsm9d31Ng71HX2J7YIHFihNC33/AhejHmhBusIoyoKaQJ/Hg+GpgqVyZ63EUFku40kkF8a0Nl8whNCYVFF1kupDC1cN7rwuHFkviYL8H0OGPMvoHMng/9QnZEy6D4QemspdAKzZOpxGSyZbgUcC0ZKepcoxDC5W0A9XNZ4/84iYb8xJX4VpNWpqwI74LwSIBr3QmlHOrGCoXwiPnpDaod+QRtQHiIPfX5iP7JFgLIqx3tbuJsqyLiEH1Tb5d9A0rQZtnMrm2RC3PgzdvvG9VrZK95EkWIUjk2OWRoxNNMomJ/jkAeQYHGaB38iZmn8ubO/z2KDqvMt6Yq7CXNiIK4noYlZzr5H2F5ROdLPbr5SCia4n8dljHleJZUsl0GnWhcnM6IAzG22y3F5BFyAC4gRXz1UMHFA52eaDDMy49v1Z9QuAk60eVWPTDYCHBM59J9fH3ZjW9oLVwUtG/Y3+Z+0dDWVZ6Sf7ji4ejHA5XXI4fmZ+nfV1w50J0y+e/we/xt+Tns+qPrLINGcihUa7DlC4hwT9tuWACT/zsi4gaIWqI9hXL9CQKPYejUTDs4V+2O0zIXutbBlCM5WDUnGfZRBPN8lL+A8rx8VoOORbQnzCbZAasJP6B2crqfw0RdPcJECSEYna5Fl/7b0aytvNmmlA5EzGTi7mXrTfsAsaFh2QVLkbuG0z9WK05jtbciNnLUNLyenuO/3lGd96kIKdQyf0i0hcaL8v2LILAOa5QHcBqG7uM4V
 //9+SsvO
 xs+fctQ7sqT+yVbRQ913mXpLoJGnFwEiAIMTFPn1gfpQyhqDHvzqBq6m7fOImMy3Scj2+hMUUeGNzIkMqkcnBZTEK3ERAJDVpGuYK7qPB02mxxa9xrF/LDe8DYtB4YET7NvHXGU1vPLlbJqg6qFWRomYbjuDRL4YmtNSIFSb3U6Mw+XF9fZPGP2rzsbCQX6SRLKaBDbK8qdQI9YFOBHCA0jf12uQp6h+0j6FzSJhYp8yYLF1lXrqorcC8/g3DKDhmAtjxLR6KpqZuP1RcRILAkxiKMAOTUdYeu+n2IXpltTEdr4+tbKhZNdE2bBhlaeq71pk4puGS8RQhcj109pDeitYc+IkUhLHoltbBR3LWYq2Z9vg+uOELqKQw6uNa4eOOpwKrzEZP1ZG+phVeCYxymV810IBrUDecW/guf6uUHhZ2HDCZjptyDmjqUeOAd8/eTL3b+00kCSHq64WfrepFmjZtHGpIwXnBtX8znMtdYE3+hhdRCjzdA14gEouQqPgm17g07OQ0Z8hWURY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 22:34, Ankur Arora wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 17.09.25 17:24, Ankur Arora wrote:
>>> Define clear_user_highpages() which clears pages sequentially using
>>> the single page variant.
>>> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
>>> primitive clear_user_pages().
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> ---
>>>    include/linux/highmem.h | 18 ++++++++++++++++++
>>>    1 file changed, 18 insertions(+)
>>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>>> index 6234f316468c..ed609987e24d 100644
>>> --- a/include/linux/highmem.h
>>> +++ b/include/linux/highmem.h
>>> @@ -207,6 +207,24 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>>>    }
>>>    #endif
>>>    +#ifndef clear_user_highpages
>>
>> Maybe we can add a simple kernel doc that points at the doc of clear_user_pages,
>> but makes it clear that this for pages that might reside in highmem.
> 
> Didn't add one because clear_user_highpage() didn't have one. Will add
> for both.
> 

Doesn't have to be excessive. But even I have to keep reminding myself 
when to use clear_page(), clear_user_page(), clear_user_highpage() ...

>>> +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>>> +					unsigned int npages)
>>> +{
>>> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>> +		clear_user_pages(base, vaddr, page, npages);
>>
>> Single line should work
>>
>> 		clear_user_pages(page_address(page), vaddr, page, npages);
> 
> Unfortunately not. The problem is that I'm defining the fallback version
> of clear_user_pages() as a macro in the previous patch.

Yet another sign that we have to fix that instead. :)

-- 
Cheers

David / dhildenb


