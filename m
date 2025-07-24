Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE70C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FECC8E0099; Thu, 24 Jul 2025 12:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6728E007C; Thu, 24 Jul 2025 12:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5758E0099; Thu, 24 Jul 2025 12:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9FE8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:16:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8915714046D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:16:19 +0000 (UTC)
X-FDA: 83699660478.16.4ED5DC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9F701C001B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:16:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3ICvg8+;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753373777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=di4gWAxFsDjFLqbJUOd8tyFS0ca5NTkMWzqIRwPP148=;
	b=Sbh+fI6KL3Avd9o5RtSr/1Frr9xeGfOxxt/EYsvwwRv7lAzSwkiPV6acdI3PJR36JhDfEH
	JjimGGk5xdkElT3qYWRdn8HOhkFOCslsXLHBGGkiNED+mkl/Q1I2xec2L5IaPRT/IC4LKY
	TQtQv/fh+X40S4suW3hQ9yDVtQFa7CQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3ICvg8+;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753373777; a=rsa-sha256;
	cv=none;
	b=Aobkhq2hLYB3DRVrlnPoAn1XgGkmCgsLx91a58O5J+n9P69/qH8OxmX2bE6c95vgBcWKpQ
	q3iUxvF4r83xhC2dtJf5qkr8PwZ/jupgnNCJUiNC9zJZTJEZDTow/BjQ/r3SJbwSwE6rOP
	EjQQ3cnYykEXbgykPlhGeRRFtp7tzdw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753373776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=di4gWAxFsDjFLqbJUOd8tyFS0ca5NTkMWzqIRwPP148=;
	b=N3ICvg8+aw6QSd2xUG2iKo0NAHHO0S06Q7dfeqyoUpLIZTLj68JBIa0fe99XD/VyrP+5/7
	9m0FMoomacKeRfkIwbgihIu7eUot3C5sz46BQ/2hvb/jSDAQ8vpAFjwVqsGi47RQoHGGch
	ajA6mFDCuqVUMCAc3k6pKIX23JNG0Fs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-nXuK3o0zP-28fG_6W-hJFw-1; Thu, 24 Jul 2025 12:16:14 -0400
X-MC-Unique: nXuK3o0zP-28fG_6W-hJFw-1
X-Mimecast-MFC-AGG-ID: nXuK3o0zP-28fG_6W-hJFw_1753373773
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561bc2f477so5692485e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753373773; x=1753978573;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=di4gWAxFsDjFLqbJUOd8tyFS0ca5NTkMWzqIRwPP148=;
        b=U4gxruzH7nb/h+fNHq76jpmyQjKF7tXaBFDxwAuiz267uh9oFUSKztCR9vKGbNLDB+
         olFNyYh+x0Ws5rrB56y/KavdUCXy42rnp1KOJ8ZF+JXGvylM2vxULpvSqzTfOKRf2hDq
         CjluRazT+VISV2ZX/BKDAuHXWzhXypUoqHvjRgvG9rgsogcCjcyT6d7CgJE9FKtYUJey
         oIgXj7XPOew+SgAJ631MvmTqiIEFSKsiFXMcmIEqawgZvcR+PY59fqjVVSt0dSPQ1WaY
         5rGQ1ftpv7/0KfFgDDtiudL/Un57Rrgzgcw7LP76umgJvDis4lHwLcZnsJpOusO8xouE
         lZQA==
X-Forwarded-Encrypted: i=1; AJvYcCW+MkUzCupfBy/UrFaQPlK8kSqd0ICaib3h3V5D5TTOoamJPg2awYJY0Vtze5Xlkbk+W1CcldfD1g==@kvack.org
X-Gm-Message-State: AOJu0Yz80ILlJ+dz8NOhExxtDTDo0xFAgTbjBFPdHwXXFcN6OD/Fy7dG
	uTrVslo5P7JpWJNqJRCm3xVtCCzS+DO4jBvUr3JaNOIbM2kK4xUcfNXkAQQap46fDEpjTjpjNc2
	1ToNKic6QGzi8tCiL7uxvM65kPEfVJGyQaDCFFkemByAmcIp3jr7/
X-Gm-Gg: ASbGncvpkELJL88xAvhnRtD3OCJ5HQ1pMVBLzF1vcy/adAjs/CIKWYgYOLhWcNrS4jn
	F/lFDlGV2qezpPjQ0UcelNOwsOjR98SiH6yejEjuPmC4CDqWDsYkwFDTzSWuAGnqOqrvxPWX/6V
	h+Lq6eymHqP2jiiGEp9Z35jVCuKsOwJN+kGi1gCvUFhW/O2ydhvWmPDJci+x4pPYj6/w11xKtkX
	V0x6k8REs59r1M+RL6IY5iPJbEFsFX4B8BHYfAfxOnSk4b+c05UcIU/j2BwJzwmhqe+pxAxABFQ
	2LQ4ZefUVRhQ0ZKgD0VRigmhKj3JlpppgiQCm7VDofqVysmWKnXcW6YMGFB96kDdx0OWY0WYX+W
	Qqb0gM5itfRJs5pSoGsMTPnl/x/SkXfvjg0AkZrgl7sU9YuAT2dEkFRzdR7Wvk19M
X-Received: by 2002:a05:6000:290c:b0:3b4:990b:9ee7 with SMTP id ffacd0b85a97d-3b768cb1b11mr5816994f8f.22.1753373773349;
        Thu, 24 Jul 2025 09:16:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEguCEVAG7lxnHoKX5dL9PwnXhiPldiban8ysf/Zd3Xyvw6UneOlwrJCPgjQknaAEGwBWPU9Q==
X-Received: by 2002:a05:6000:290c:b0:3b4:990b:9ee7 with SMTP id ffacd0b85a97d-3b768cb1b11mr5816963f8f.22.1753373772881;
        Thu, 24 Jul 2025 09:16:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc7724esm2590591f8f.32.2025.07.24.09.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 09:16:12 -0700 (PDT)
Message-ID: <ee6df343-6500-4443-9af1-4d15040e39c9@redhat.com>
Date: Thu, 24 Jul 2025 18:16:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove io-mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
 <199a9d2c-9e50-4740-b29a-6ffe906e7d9d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <199a9d2c-9e50-4740-b29a-6ffe906e7d9d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DFZkPxL8ZZz62qoXbf0vXjDSjoAsMJKsWLlke9sx9BA_1753373773
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E9F701C001B
X-Rspamd-Server: rspam06
X-Stat-Signature: xyzrk5s3egh5n1cjk13jwftupb9pm474
X-HE-Tag: 1753373776-35929
X-HE-Meta: U2FsdGVkX1+D2T3BVM3SBrd39NQuyv7Manqu/O7J1E9Zr/aksfn/Ri1/idqK9durgBXtIXGEYfRlwCtOJemccFHhA/Gxdxv7YSemxJIJnjslC83HexoPJL0QiphfpRNzobd4/g1EroTl9LVBZ6mbHoZtNulR5A7Gy1jh4L/TgUa0EIdqJaV42ZQmo+x26AgkIqV/N8ZUqZS5rSxz+WuqgmznOgKbiSPuqSeB6hTg6GJOB2b7m5eaSBpRB9ZOVrxl01kglpl9gx/9ISev9qf45fHjmbbmtNizCVVKU0jZNpo02vkhQaNDJpGLBVS8f4xeAzEPbIS8jLWtEGLjwJkHcbWOQD9dkSJRtTWuulSS90Z9siPg6UB1ZvDbzy1cxM3QC2qNHwVUVIxMHVeA0AcbE389CEhnzcclNYuAcuqhzJkl5i8pyhOR0qfn5Yf3vlPPO0QD1/CE3JwDVcpHFwvS8f1fuXYqOFyGfLII0GRnZ0kMrbPHDDHzqcFNtQsDbDIWx0R6W3U+KBAi/gNH+LsMmXXq+8LIsdj/flh0p+qyMD77TbIkDI+heEYcIa0iW6UREI099k5Sqtt0TDd+fb1JxYLORhVezPsUQOrHOwqT9oFCNabuO4PfmaoPJ9W4CPuX5t5OpIXE42PjroQ2t9Yp4zO1iKa/J8DBCI/IoD1/9bsnbtH/6JnU6qPGQZ/CV9lol+E+S9q4TG09RfQNHgNXWmbGL89gZ8UEQUL/BsysbBYtTV5XEEA2yhfJAqZ3DO03KQHuYTUp2q31H7c+VFRLgR7aEXIG5VGQ0YfUtDzb+aVu8Vlqud4RmIyCnFN+YGMFknOAFH5H3AiJXgEPuGQSkI6t60zQ5wRsb3Fh38gfyiZeQsd9VNkPgghmc+p8CN5e6w3fPrp3xdHdP1s2S0nyadsNyUy5u5S6XGPGdJINTg9ZbE36YQbvYhAqr8+zec7kZ7R6vBbNvlZajR8BT4S
 KzusOnd7
 uNzNjagaavVE1oTLaOk+mzs/wzYgNDqyWduXfk7LM89E/iVVqnMasbwZPW9HHgcthJHZwBchlsiHQj84vv2eoEHgVwECx3TjTrz0CIv3jJDQ9FhlujzQwGE2vyeisOkPeCdsgarev17F/dNF3AFfyYUfkkNmPKZ/1EaFSJnCdkgAU7otUbaOrbGmXoYjh+jWJyF7pow+4cmIIzvnWuSBtJYb7BLpGlaxdzIGyzVMgaH2OIATr3hQTEVxfDmvauzqGdhAyKGDv9YQQcXWJr5IWI7d40abkq9spcGbyi8Ytcjf+kGliH46gYJ5jiW9cp2Jybff2pCWyORPezcGJOIrV4EE67RtgHC28L2VESF/cQOMYnBNBzH/3GZKtSXSaCBOSKw6wtBAZnToH+NeKJTPPwZrYenPaDc/NAqdgo5fXaVaIMIM7Sm8etB+9bEa+0BicfGbcao2aU7YLhX1K8+gKMjZdEwKDhymv4LECsDWxt1SIXXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 17:39, Lorenzo Stoakes wrote:
> Sorry Andrew please ignore this for now, I'll send a v2 later.
> 
> I'm not having a great day here...
> 
> I wrongly assumed that, since this is wholly unused in practice, that nobody
> would refer to it or include the header, but it turns out that's incorrect.

So, do we have to keep all (and keep it in MAINTAINERS) or is it just 
about cleaning up the headers?

-- 
Cheers,

David / dhildenb


