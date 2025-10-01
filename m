Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3C9CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FC48E0006; Wed,  1 Oct 2025 10:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77BA8E0002; Wed,  1 Oct 2025 10:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D778E0006; Wed,  1 Oct 2025 10:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAC68E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:05:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FCBDC0A0D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:05:00 +0000 (UTC)
X-FDA: 83949716760.03.3201B65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFE354000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:04:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XodyGt5I;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759327498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wPPCW56HYmH+KQxPHAabwefVp7YnLOP8sGF8wH4S4Q=;
	b=UJyF8kxeD5cCNWmDQYtf3Q51zyt7ZF/TEr0xMBR/BVNyUgPYdnONxIcED6iVXtLxgBM3gi
	GcrF0dQlsF3YYt5NYE96ouGQaflWH44e25TsUjVt5JNKir4WTZVNm+HvHRzUfJkbb417qX
	JOk3bK8uoXbxIVInH73h4cwNTRJQlVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759327498; a=rsa-sha256;
	cv=none;
	b=lRo008fpyuOpwdn7j6It8i5A14De3NPZZ3eoRfh/i6bfTtKj7O2v6R5urRrZ7/w9ZU2xav
	BtxRTmd/+59ZfdEHNYEDQXIZcX2fO4HpN2gnFXhnX2juOaIc6PfECbzHQzPRfzDw56jh3k
	NVOgGOpW4ZCoFBm2o1llIe9ARe/FOIc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XodyGt5I;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759327497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5wPPCW56HYmH+KQxPHAabwefVp7YnLOP8sGF8wH4S4Q=;
	b=XodyGt5I+zede1QCngSo2PEKyuetWYNYTbA1iQ7KdL4109TzSRuqiVVYSam6X7+8d1LISL
	fTJCaxp1GgKUmDJ4OszS3CCYL1R7FzxVxvZA5ElnO2l8YapyCmZV5R/H3KRNMrXg8EHnCz
	A/CqA4GfROPapXabyZuh5p6bgK7nSDs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-BWdT0KIXMWOA3kMAPcx19Q-1; Wed, 01 Oct 2025 10:04:55 -0400
X-MC-Unique: BWdT0KIXMWOA3kMAPcx19Q-1
X-Mimecast-MFC-AGG-ID: BWdT0KIXMWOA3kMAPcx19Q_1759327494
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee1317b132so5685780f8f.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 07:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759327494; x=1759932294;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5wPPCW56HYmH+KQxPHAabwefVp7YnLOP8sGF8wH4S4Q=;
        b=BwrJCIrRugS2G7TdUXFC5u+Hra/hYzsy29JLUMDkdN6z59QJBtGrgN67qHC2XOUnc+
         fP/L5vXhZehTNKy7F/5jxBi0Tww0YlPSqyR7T+67AaI3m57pjxDQajqLSm+OzDOSdIj7
         m7n3icmEDTXdMQ9k+BTPjdPV7eR/hEsNx+b8YYDLvZWFGwAWRvYcX2GB1Igw8+0Zq7RI
         /YS0q6p36MpcVtKhb2LbTI7DVqOVjM8+a+IQ4IN7zMYB0yywAGKlXyZlhq7GNibPvUC9
         TiziTeML6NEEDAHlg65bb5Vdz0KISPse7Dj1Ku9hja/5iyWSSQnvaiuZRk9kiB2L3UJR
         AQ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/aX50QVCKriRlOMMxyUvE5YKJwmzKfjHDRvGrKLvI+1liLtOYoPhFw6vXAzHRdOCDDKc34H3J1w==@kvack.org
X-Gm-Message-State: AOJu0Ywwb1IWoBOEIYCKbto5Chj4WBVbol6+PzgbFqDzUH88x3ml6lSU
	UVBu9NIXvV5QWHU0LEFKJ2tmxsoDVFrbyD4fb8lBDJQlh/CVhy+GqfCpx8hF7S+GbKMtOLZj7Qu
	rvP9ExG0ATf0/p94PUbTKWTI7OiMeNiE+CbNXQv2fbgZn7VJSTBDS
X-Gm-Gg: ASbGncvucoXGwUQcUoLuePwqhxTkeKhCaSM3zFCKaZhqHeuDDbI0rycWbCF1YOCsV/a
	WtTl998n/YncTYVZD7Ic48jXfUltoS3ITyYmDAMh0Ytu37e3xBGJUY0uHjztJxrDJ+kBRhIG2RN
	ISxHrdc808LoM0OaTw1xKZvRhs7+kSPczSFwpn2lWtbNQph534wdrzYKGi1ZhwSL8N4ckZZFOS3
	ZnIurf2GYc1fWbTWeqIU7TYowfo+KbVhzq//Rw9vAvqbHtd3LFt7sec9cYA/pl3FFwb2p9Dc97r
	JklDCjttNfYZmALzFM90tPql1mfzXqWAOhnt67v+8gLlVWdI0+NtkYIGFfLSPDiOz4o1qMYPg47
	NDZJEsHEY
X-Received: by 2002:a05:6000:2310:b0:3f4:84d0:401a with SMTP id ffacd0b85a97d-425577ed6a4mr2490032f8f.4.1759327494301;
        Wed, 01 Oct 2025 07:04:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENzD4FS17jMrqlPAIsdQn+NVx/5qGSii77YOKVGiC9md7iTCov990k4EcT+GuqiLVYoBJGrA==
X-Received: by 2002:a05:6000:2310:b0:3f4:84d0:401a with SMTP id ffacd0b85a97d-425577ed6a4mr2489997f8f.4.1759327493844;
        Wed, 01 Oct 2025 07:04:53 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b63b407sm38795465e9.2.2025.10.01.07.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 07:04:53 -0700 (PDT)
Message-ID: <98cad9a6-875f-49c2-99b2-389bf4fd9b55@redhat.com>
Date: Wed, 1 Oct 2025 16:04:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm: redefine VM_* flag constants with BIT()
To: Jakub Acs <acsjakub@amazon.de>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 peterx@redhat.com, axelrasmussen@google.com, linux-kernel@vger.kernel.org
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-3-acsjakub@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001090353.57523-3-acsjakub@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uTwiXPKFOugPgA9SoxxarUZ-4xnrhqVC_a9BItBzRVc_1759327494
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFE354000D
X-Stat-Signature: gzpo8cu6646ormgss959nu6gzkdgiw4d
X-Rspam-User: 
X-HE-Tag: 1759327497-966436
X-HE-Meta: U2FsdGVkX1/uAhGtukowcGIXr3vLY/0RofQRCdiVxTB+na2WsS8H+g0CyhQs3/ph/JGKekQPadqa9TUkvsZrv2Sx7TojTklFnJjf134SfZJk1kyp6oqw450N4WokCFMdXaPhJsr+wrtLhZ1R07dKmRJ4rZLDsUqglAmwidHMkTVcDrzeTZm521Z9mR3fLuUnxTn0N/WGhc7BQAA7vlSu36rcy3YRw0D91x1uXvSgSqfGNdqVMCV6EUntCwNM5R4lOTf0WEvkYgBVznwrzGQgd5QS4AFYrO4VrRrMLzeys5d6MbCXXNoNWme1ZfUF1LSopLPUg9PJjDvPx9glX3sxwSsXyulLzlm+QKBRRAofpklmwaQ9QxH3jalbj+/bEbV5xMGCmUva1Zl3jn9sv7rY2ldGzbSVfe1jzVrmXDsKqKjWlUZUINhvOeZWosyunsYmDKZkFCSQjqKdwf3AuAN6s4x5T3850tBgisIGOJL3V+D/YrxbcGlpmXaZLxs8SU1x6BZAb0tbn0LC9JeDRSlTFVNIqztYbFZZBrCWmpT+t/CyjZfGPgV2UyZ7PLzQq+Lu0qn2CcXMvkEVexUxRvuhRyBktTDw7prANFqCUX/ap0vWU7objBSpVDWZdP0id4bS3GH0tn5MRuzCrHhbuAbPmnGeRPXKnqRC2Hdj6XqVsahUqCTTU1lZnsuzZwE2u/dwJFI+Z3VSIxIb00YGlMIMibQmcdiMZreoWFQd9Xatdh2UtcrSxTy/+bcKVF68JSzliYuduUy4vkGy3dna5gk9LkDbRSlJtQ61gbl3WNyzLYft48b/TZsr8Kmh7G2V9gONJLxmfPJrIIzz6xIvMHSwdnRaJ/51zD1N/6G88SHjtb8j8cCYQV8m1BQKqQp+/DfueXiUuNoJe92+KC6sMTitu7TiNFruo2euyIRohMoZ50kTMMAsbGOAaDsbGhaLKUEQPWAXXokBkq9dUgNG4i1
 yHyU5AaQ
 hbARQxeaybaAMnraE+9dt9yfWUl5U0DS26As+X8MFc4jmlTIwBhqVoR4Xc0OMt1oggGH5r/IKlbzQyEXUvSrHqI6mILzPfCAR1IHLLu0QFlxOJ8vKN/ut5dcyepNHYOSapf3ODn7+Lh4U5CvTSfy8gZ1SyA2zO6pF0xBJG/9xzjIw2TeyTYoxfSqOqWsp1VK5NBtYycGFTtAkwxXqhPbVoPD0Qw46k+cdVrHX/pVDvwzGIU05h45Kgbe6u8UMYHYMGiivuoEzW68UVbv5B5RI29FzCiaGEL/nZGPokmYOsoY59rZar+rHE40zGww0QkXkpIyZQLM1rrjdmhF+AVNO+Yin+PlufBKMIhyp8tV8fdWN5P6jBmFVmzJevHi6ZMCAWJPE7EOV2h3kws+VXVOK0BkoejshQdujKW9dEOi0istGpJ0OSnQPWlbUig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   
> -#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
> +#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
>   #ifdef CONFIG_MMU
> -#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
> +#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
>   #else /* CONFIG_MMU */
> -#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> +#define VM_MAYOVERLAY	BIT(10)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */

Careful: VM_UFFD_MISSING and VM_MAYOVERLAY share the same bit, depending 
on CONFIG_MMU (9).

>   #define VM_UFFD_MISSING	0
>   #endif /* CONFIG_MMU */
> -#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> -#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
> +#define VM_PFNMAP	BIT(11)		/* Page-ranges managed without "struct page", just pure PFN */

-> 10

11 is actually unused IIUC.

> +#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
>   

This seems to be correct again.


IIRC, Andrew prefers not mixing fixes and cleanups in the same series if 
possible. So you might just want to send out patch #1 separately and, 
send out patch #2 separately with a note under the --- that it depends 
on patch #1.

-- 
Cheers

David / dhildenb


