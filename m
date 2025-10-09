Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC89CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1838E00A8; Thu,  9 Oct 2025 15:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9338E0002; Thu,  9 Oct 2025 15:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF778E00A8; Thu,  9 Oct 2025 15:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8F98E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:19:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D668613C0A9
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:19:25 +0000 (UTC)
X-FDA: 83979539490.10.9678698
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C66D18000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:19:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C4xXaizM;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQurpp90SeeCWbZFWp94YAV9HMnF9Yu3um4IgQUYoDg=;
	b=5nAIGbQK1jkfl3FVV0CSjya8xeykjHP7cRdw9eEK7EGiV2DV7J4CeGmLCCCTegv0VCsMA6
	VVJBYjQz6B/mW2JJ3cp2vxL6OqCNFj7k1lDTYFb6E9JWaBjUNDJ5g5WNg51S91ORcMlmrE
	JuT9bS00xqF9vakDOQPWZUSgHHkE9SI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C4xXaizM;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037563; a=rsa-sha256;
	cv=none;
	b=6ko8eohJJAbLbqqhCOzMGIZ9zC4C8+sp39ejTq8ZpHyJhYaz0/pWIsm+uRBGSN+jVd+NrS
	EgO4y2Uv/nddKHKbnPdUqO1p2UbDDP4A6pwjKyc+xUwFeWgGqlVmzMT8a3Ij+lsySLAzU3
	CJCWFV2Xs34mQLBW6spxgQnxNl+qb/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760037562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TQurpp90SeeCWbZFWp94YAV9HMnF9Yu3um4IgQUYoDg=;
	b=C4xXaizMRsOfw/oASxQ4eHGMvhvJJUCdBFaaFOlhKIxNkfgpc6dLeXnauh8Pw44X2BqSJQ
	vwoZEBmeCw96VBn96stm+p1rS3fTCqHA68JedXenS/GIScJfNC3aWi4XzUScFyGShBZ0e7
	ic1hm1LXs7pPGcO7jNn+/OkRr8b1Wns=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-uD_bEw5lNFWwavDoyQ25ew-1; Thu, 09 Oct 2025 15:19:19 -0400
X-MC-Unique: uD_bEw5lNFWwavDoyQ25ew-1
X-Mimecast-MFC-AGG-ID: uD_bEw5lNFWwavDoyQ25ew_1760037559
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e509374dcso5754825e9.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760037558; x=1760642358;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TQurpp90SeeCWbZFWp94YAV9HMnF9Yu3um4IgQUYoDg=;
        b=lTyQrqaETo5tWP9Q/m7L6MNIrJuFRq31/qf0VWBYqFI7M6tquntamu6cl6TVaiyvg0
         WpvD8Grcv+zkP5MzbBEi/dDIriQAnwNSFTXD0hkKKMutWkl+7PvX3sqIh6PDNOQPZGag
         Oz8aMZz19HOVcdll0xx9ftY2dXG/xT0FobCpXmbsvb3OMkPYsQ+/MMVq4DHCeLc27vk5
         cDF6lSo6NncDm/EmfCaublmROlMtpea3Z8URlRfO5dc+VMZ2qwTwzhB60FgyBqnuiWIn
         L3/10zG4VzrBubIJGMvdu6iPpmPPWf7BINf3BL2Y5TKzlbRedoMrk1LahIQ+JZutD9Mj
         kOwA==
X-Forwarded-Encrypted: i=1; AJvYcCUvvzLYRvwqPFInBhXkRC+LotoTeaeu+Sr1UOQBd7+bRS4JRsk67pbotMqqu8vIshdQDGNY/qSI4A==@kvack.org
X-Gm-Message-State: AOJu0YzOGeFYD9X7ZoT3ftLOIBpiUbb6wIFOlEco1CAgCQxUXRP42jNr
	/in5Vm3Qc0XW/jVazWEmcOUiDktTMwYnRNW76XovNZiubZiGXeOSB8Ik2/XNkWybjIV64oejUTI
	SBWL/bWk7rn7u8d+spcPDo7VQ1sIxaw9ugZyZmzRPE+c6jAnpGUaT
X-Gm-Gg: ASbGnctLct/VsSsFgXLhIae4Y/NAs9qmaV/4r5gJOPTyuJRceX/VWT8rElLCoB6c2fX
	j51OFDRecELlTun3JxMx3mf19+V4ASkOJty9kE6Asw7dJT5XQPnlVMDotdawZ1hkOyGcrbxjPeD
	IPoli/oRiV1padiXRez9f/CdmMf9ks56KZbuQZsUbSbKP0hB9l/kmajDpgR9CdxIsv+IGT+TChz
	Z8aWTPs8V/57RivcWz/MnSdsnZgGbm9ZDnaJ1PP228FCE9aIMF2d50pgYUljCp0FP0Zg2Um7Yih
	fyXkPvINqkoYzk3tqfdggbMplOzg6dDcScz+wI71HkKEFpoi+HVOMFpOY1QP5H/7J106INaf/T9
	wQFKH7JN7
X-Received: by 2002:a05:600c:a14:b0:45f:29ed:2cff with SMTP id 5b1f17b1804b1-46fa9b116f1mr67840605e9.35.1760037558610;
        Thu, 09 Oct 2025 12:19:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPGvbDunIELcWNQQhDPqw6NuTM3NX/huGnUquW01rlLkgxG+DlLb8fYLVnv4s+DldW5Q8i5A==
X-Received: by 2002:a05:600c:a14:b0:45f:29ed:2cff with SMTP id 5b1f17b1804b1-46fa9b116f1mr67840375e9.35.1760037558196;
        Thu, 09 Oct 2025 12:19:18 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e7e44sm407353f8f.46.2025.10.09.12.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:19:17 -0700 (PDT)
Message-ID: <6a2e341b-7aa2-4bd8-bce5-dfdbd08d92b6@redhat.com>
Date: Thu, 9 Oct 2025 21:19:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/8] mm: Actually mark kernel page table pages
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-3-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919054007.472493-3-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: liGWKcAKtXJVFRSRZgQbTXnW1wC4mIJFMivsylqxgx4_1760037559
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C66D18000C
X-Stat-Signature: shfo7r1tfaeun85n756xypb7qnay6f6t
X-Rspam-User: 
X-HE-Tag: 1760037563-373660
X-HE-Meta: U2FsdGVkX1+h9Rh/W9Vt0i4ZZV2MjU/2NTKVyIcN8JxtaXjbC4RjdTJduOQSSwMy1hTBg/MK/y6hOMT9pz26NsMIc2WDKBIlV7by8nTUchEw55oCZbOwErcy6fh5e4LPiuuQrQ4UflP0EJBAdlubp2QaTiTRs4LdquK3ujN1yZr2SH9sE/7GERCOKzgqXLj+RZbY3MgOCNqmaWOs+1fSat0gkV5r9vcP4kD+qNmq/kOPlDMp3Lb5SYsQXfaERQce+zbDwlRdGX44B2YL8fUsXKXx1Oxvo+M37mGrMFN+78eaVYoN8vvixGv3L853C1d264cdLzBC6S/Aq6WE2rO8nKk25EplRFu5zf/W318D13ISyseaCz0/HV+NmLw34L8vI0dLhj4ajVsouszJknni/+HZxscFrfa7VupBX5lz5Q6Rb7po8x0BtF5vNNrm16uRsPhpal1U1pVALfaX+4z2dy5hceoxscX+m/Obwv5SoEWJLHXdlGEzO8uvuFSNYsuWXg65rxSBoDz8u3UlshC0wJOAbp3pNP5ARYqFQmKOgHqY5wJH7g8tYQPs4nD8VhymAQYpC7NaJIy+EDsxeBiwjAs6nXR3/7N/oXRZzUpQ7gF9NPgj1tY55ZIJZhNBL891m87ervokgK4YQbpAKdvVOcQcd5RoO85C8Jk8h4gZOKhwp5vhJOE+QWN3fTSr74208ycUfyijotQJrl+aDcLEr8IOrhLoAZRK6l9JWVuM4Dzy1PKJ7cn0CXX6heMenR03IDUGVRwKqmou0dXvNlwZ+yE5lO+SgptccU+lDtI2LYb79hVAmcDrl+sekQMax4/Qhoa31li/LERS5m0OphTlY6uMVUwXKqVv5Y1BrcDe2W8QlbnuzRGCE6NTMeRX3K5wMZFvNDwxtT8+pIgloV5gZGXJoMhOglalb10VeE0Nz6ulM+jul5n3cr6KAh+N4S3jqT554s7EG0efSjIn1Uu
 EHPvIWSr
 L/bb4VxJ2SHaWzn1nmAH67bjK9phIS1e0pJXeDPS1OxgDSnWZmnN1MpdRtlrxdm/OyGm2Ifc+n3K2Xkd7LyNCVgMyfe4bjjHG58EOU6CUzlXLFUWJsY5pYy2kSV6g9W1BlTTby7fD2CaR+uxC2psZchMGv5hJFzQ1GWhp38kaLRp6ppnIARBQrt7xAiGaSPSN+C9PQScQyv0RfPz0FeYyVA3iyBvaN/pFEgXoWlTnDibiwJtKdRbuDnd1rSVCMi6rcsp5lNjXhPvuuNAvWlWpYpyWgogj4oWc29+Y9t4+WW74VWBYgA0ZIB9tmYuugGukW9z1PKMYlYZF2MHbchjdz2Xn8TCFNmBW/cpBLDasbz/dWRPiOH1fR3JsYBPRmqWF9MpZkR3n++sXiajsMCnmC+yDaCwiKWdk2KbNhKgKYK4i9Ree1nIDLS43jQMHO02i7Eyf8N1WUtTEpHrOjhVfEq5b2xk8XxxKd5t32zQzKF9Pse8RFE4rrkW3zMNR2oC7R4i5+ThVHgdmODRGxQydrcnC+5dQ7wgvgk+CW/Httwk1rjBLC1SHVxlCNgX7cFhTRB8Ol1fnEKQtWIA6Hin7VYKFwLePL3+36i1t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 07:40, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Now that the API is in place, mark kernel page table pages just
> after they are allocated. Unmark them just before they are freed.
> 
> Note: Unconditionally clearing the 'kernel' marking (via
> ptdesc_clear_kernel()) would be functionally identical to what
> is here. But having the if() makes it logically clear that this
> function can be used for kernel and non-kernel page tables.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


