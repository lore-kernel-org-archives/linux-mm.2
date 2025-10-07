Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34F9CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AFD8E000E; Tue,  7 Oct 2025 03:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02578E0005; Tue,  7 Oct 2025 03:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF12E8E000E; Tue,  7 Oct 2025 03:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB6328E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:05:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B14C11AE62
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:05:08 +0000 (UTC)
X-FDA: 83970431496.01.B93CD52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E85518000B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:05:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L5c0RDS3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759820706; a=rsa-sha256;
	cv=none;
	b=W1FqVhKV6yFsa6yxOKYvWBwhNsAv0wP12R7t1A6iDl3lu4O4lG4IzTdkStqZ9iNF9XM/dd
	E6OekFITrZ0s1DnuXKiy/DGDbCValyNMlNQr8lHPTIV32SJsGYCw2K6Vz7HzS1GorOP/1J
	rctvHhfMR482sGNPs0zd3TCs/09utAM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L5c0RDS3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759820706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsgJYQtRkFw1giZqcBq1dAAAg/ofM8wyV73TVWhQW04=;
	b=3Na4mjF2QBr+0OAE3gwy/9w6KNqsFVxzx6QqPtNW/uLnCDPEErbg9N2SgmQzL0qtOfeah3
	FWkvA+7wFtjf/f9bhtobPlR6Mm5vvV17HqTsdxtWNR11QniAethv1ua9FAqgo+J4UHF3dM
	D990cL2yUWU/HSSGbD38BGLO2IcCVaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759820705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LsgJYQtRkFw1giZqcBq1dAAAg/ofM8wyV73TVWhQW04=;
	b=L5c0RDS3PTiMciV6/BAGhdCdAtb88XoIB8VEIslx/X1LWBtMU0Ujh5KckYK5dJ1br5My7L
	beJPYneR3mVBYZ317KLZ7QDRSk3u68UgPL3JKD0TlnM+H6UGEJyAQZlYAnL3aTLWGIYa6J
	wNDuopIF1lcMaym3Nmc/JmXIGZqku1Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-5PDfhPPdMz2v3_VOLc88EA-1; Tue, 07 Oct 2025 03:05:04 -0400
X-MC-Unique: 5PDfhPPdMz2v3_VOLc88EA-1
X-Mimecast-MFC-AGG-ID: 5PDfhPPdMz2v3_VOLc88EA_1759820703
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso3175005f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 00:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759820703; x=1760425503;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LsgJYQtRkFw1giZqcBq1dAAAg/ofM8wyV73TVWhQW04=;
        b=oyvc/zi/csChdFohLOShZdJTotbogDcZBr026nn2WN0m8n38JAFZEbrdu1HuF8T9Uy
         q3TmPprxfdRWJ6uGX97FBqmmPkDyiel6424sOiHXTGXcTVuu3OejpCQVmtbkuNi02Bb5
         PLzbs6T1Cdo6dIcaFuE9zklebTdVXMm5ski17jpqOkrUzAOfs1DxkgGFJFTZGf6G0b5n
         75LiETLWOrH94Uz02GammHBq6iufllxbGQ77kavd/l6SScpv8j74NoDjkF0g585bde2l
         nz3GeQ/yExubSZHkpRaEkqeisEo3VRgjWaftitk4MuLNmS6GB+Ioj+7z2BcLNRsrfDWA
         PIIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUatHNwmzk7XmNy0oa43P746T2wa2CqgXwB7OYxxNLXPQDnnWYm+vOZPke7xbu7Lj872haGfkn5+Q==@kvack.org
X-Gm-Message-State: AOJu0YzNi6JH0b1/5qUrfJzLuMJ40vbmUgqzDkwYH7tCPS/kz3LAV8Mg
	8B0uEohseoudPF9sosOyOcLRaDDOlQ8etmtID2IJIKiwWvmBdFWU1rQiu9xS9eDSE1IzTftXO2F
	+V2THEjgtgHxCX9nc92eMQoH5jh8aR7Q0GMGSaZLuZrx0GcOzv1/z
X-Gm-Gg: ASbGnct9jdiRS4f21qeEjwvzyQbn76RULt1RhZbiPxB0+13sUq/JNZoGjjjQb9PK0Vo
	Ay/w3BPBdtUzVFQ5c9HCkkFFGmz6JRuZe3kQ45Tz1cy2Lr8qfu51x+ilLjIhEXUudUtskzquphX
	0xlfSmQelQIxX8jfAjeV6io5s6mYW5Cj4EWqT1xdJih18WpHewDxuyiZP0ktcdqD+2wqMPICXTT
	vL61wSFqdDO6JLm06e8uEQfIOAOQMZsX/HW0LaLQZkjJPSpmGG86SKgN5MYiApTmtw0GiG4+8bH
	TdjwS6qMbUuJmm4JCoVRm/6DOhVUR1qwcsRJ1norbyuaFuZK912S+t63eh8xX7krf+ZmYEhPJaj
	0D+IqGpv0
X-Received: by 2002:a05:6000:26d2:b0:425:7e40:1e02 with SMTP id ffacd0b85a97d-4257e401e18mr2592446f8f.7.1759820702912;
        Tue, 07 Oct 2025 00:05:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEe+DSQyJlOgCA3XBbLClZSzFhKAVyYRCSZG97sGm0NN9M2K3Zt/pnRoF/CTSO2PMEqPUlag==
X-Received: by 2002:a05:6000:26d2:b0:425:7e40:1e02 with SMTP id ffacd0b85a97d-4257e401e18mr2592437f8f.7.1759820702507;
        Tue, 07 Oct 2025 00:05:02 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a029a0sm286626055e9.13.2025.10.07.00.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 00:05:02 -0700 (PDT)
Message-ID: <deb6c0a2-e166-4c91-9736-276c9f1741c9@redhat.com>
Date: Tue, 7 Oct 2025 09:04:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
To: Yunseong Kim <ysk@kzalloc.com>, Byungchul Park <byungchul@sk.com>,
 Hillf Danton <hdanton@sina.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 Yeoreum Yun <yeoreum.yun@arm.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
 <20251003004828.GA75385@system.software.com>
 <20251003005230.GB75385@system.software.com>
 <3b66d603-543d-4616-92a5-9e6e32f116be@kzalloc.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3b66d603-543d-4616-92a5-9e6e32f116be@kzalloc.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 36NdyuFozSx1LMv1s5o6G0PEjBcwIYrzZ5FJNrIcv2w_1759820703
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a9xkgthkgerjcxjbbi6fa73hfyoidtrx
X-Rspamd-Queue-Id: 0E85518000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759820705-280148
X-HE-Meta: U2FsdGVkX1/maoMJZTXmK447uZ3n1dTpxYtZpRklY4E4fd0BHj5XFhubL8YCrPM5g1EUmUMt85/3IPXflq+49wQqH64TAtDd4HtkKJnHkeMhSFVh3R6tjc1jIC3I8Tm9TW4ibNdXMadllDR2XRvv6rHjaWhq3how5QbKbgHBNaCPS6mrqel91BcRtIcP2ZlV18LmDOvfUEgPqrNV9NbWGHbE9bNwCS9VfcBLeL5hleSoiMpSYi8n5NHFL+PiH4HwZGz/uPSdMy7ViQEzFpyfvdABG9yjHg3IdVcaJyRWALlr7VBMtQoy9XSBCGLl48nSmht1EtkZXHWx3zV+vaFBPoCgr+kmp4kyzPixyrODT4YiOxVLkKAKS4Q1VOWDzBI7ucgkXtjYwxQxcOIjQaqD0c8lMS0hkWXuGmIr2YCgts6HAPi2JnuaTk0J1a/4R7Od5uQTXob2hMP1g4QjKawoESOXTZHrZBHzKCvAw5p7wdbz8iJoA9iSFeYZX7pcdFM8mGk0fRZHDdP/SuM++ULmwVCacORp4XkHB7do/cHJhrYi4KseqkE/kAROyKmjvYVkxWChhB9C5x2q3wW3JTFT8i3UOrYN6X73cNQ7o+yBxQnkyIHulYM6ejUR7w9P9B3hpMl5ZnVUiv37m8hmj0toRdKJLBzRD5W+7aL0AV1PFrfVX6vOqz1Lx92RiwALR9pkZZaGjBBr1EChMgMZUvb8gfgrkC32Sf0Io+SlYYGQSU9W5vM00b1UW4eCyYPFcmPYIIkQXfG0Pe07WRmOYc9SkRnAqxAIf9whNP+ejB9oTBJIUO6a9eqNx1IyNHm5ZR4PlWQ/oYAx0S3/QpLUIs7Gq3yayQYGbcy5jIZeIL/uRKHKfE9sOEn2AKxelyQBTKd7r7DbXn1f77u4ef7PTmFY6XCcM8JAP3aszwnIUh2ch/uiCBLzsdrHkIlSgZM2IKSA/ej+sV4MCNA64xc7uPo
 OuCUl5gq
 C3H3jd3PhJIojPs4MsPql/xsl1x0wo4ejfZAqHggUYwcj4HBJPNu1E44J/OLyfXQYX2dvmeOLeY5RWL6kZXeSnt5fjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.10.25 08:32, Yunseong Kim wrote:
> Hi Hillf,
> 
> Here are the syzlang and kernel log, and you can also find the gist snippet
> in the body of the first RFC mail:
> 
>   https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5
> 
> I am reviewing this issue again on the v6.17, The issue is always reproducible,
> usually occurring within about 10k attempts with the 8 procs.

I can see a DEPT splat and I wonder what happens if DEPT is disabled.

Will the machine actually deadlock or is this just DEPT complaining (and 
probably getting something wrong)?

-- 
Cheers

David / dhildenb


