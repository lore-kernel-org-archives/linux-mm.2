Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2A6CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 09:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4418E0028; Mon, 18 Aug 2025 05:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B968E001E; Mon, 18 Aug 2025 05:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AD88E0028; Mon, 18 Aug 2025 05:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02DD48E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:36:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3D70BBA95
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:36:48 +0000 (UTC)
X-FDA: 83789373696.07.DF80EEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C12E40003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:36:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y2JWDO3Q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755509806; a=rsa-sha256;
	cv=none;
	b=izkhaGvQoEbLN/hGeP3fQSou0iGDcE3qAbDw/dAgtiK9KOpjmZCMCFdqkc8uPY1oWl1OAE
	ZGYkdVfC4n5XcGPkcqrPI2iKrwq7D6K6YyijHcMjBkxEm/DsmQjbWKosahyZ9Nru8eg8fD
	1Nu8OEgyVhmdaCtKT4tlPJ/N1tfsmm0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y2JWDO3Q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755509806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiAISqpfIZlY1GxKByb62pOCSdcPs9qo1N30a5HaEHM=;
	b=ZYucNhV15FZJOuTOwxF5UfM4kHwwspha3M+S4145gddjpRLiUzF5uaaKCdIMSOegE/Rd1m
	xM/Zq2d0v69j8ZufSGzVtXIrdHNlteRjy4tydv7/T7Tvl9NeXGFsM6UICceR6lmF8ZQBbz
	m2xwTbr/pqZToSlWv5OkWFZUVxj8iEA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755509805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yiAISqpfIZlY1GxKByb62pOCSdcPs9qo1N30a5HaEHM=;
	b=Y2JWDO3QfCCV3AG60oB1QbooeBuQY4OnE57AeuROaHIIg1+BuAXdKSJVHyQnnJFXykjAsJ
	jy0kGP+ksmZFTDutRZHkmiKMRsbniNzKoqWHE/jiMkGP+2vD0CBtJOcy5B4wLABWD1GjAI
	gU/jr773TRzmgPN7ryoa9S3zNsgIEgg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-NfXBdFeRM2yE-Q-Wssw2fg-1; Mon, 18 Aug 2025 05:36:40 -0400
X-MC-Unique: NfXBdFeRM2yE-Q-Wssw2fg-1
X-Mimecast-MFC-AGG-ID: NfXBdFeRM2yE-Q-Wssw2fg_1755509800
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc566cb4so2011394f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755509800; x=1756114600;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiAISqpfIZlY1GxKByb62pOCSdcPs9qo1N30a5HaEHM=;
        b=uODtYjyq5C8XeAn+f+JxrzeCvvLNY5Y1/Jevq5FaSe9D76I0qEUQX3gTGMaTX3C7HH
         Lq/Snt3KxTZIOpHjF8x8UJJEmjfyJMlecY+Z++B9EhydfSPH27dAwul7aK1kaoYrCVTM
         HuOpPuV6yqv/WekEj++wbrgdY4xeYSMzLDrugXTp0b1WVsCBakwWyUFkukWc/L09x5To
         s7sOFM+zzV479byMHTTc0UUQ1TqnncnKMjwabVjzfQT3e7BgvRfaxKzPIXsr2xBtsFJ8
         N2jtIJeoU8L+SaQBn2M1S7A5/7y0iJn+3w4ehUVdfgaMd5OIH/vHozi4YX3d0G8gnVLU
         kdBA==
X-Forwarded-Encrypted: i=1; AJvYcCU240iiji2QZj4XifLmH77QB2o0wTUkNX6PtcxLN1l9R5cm1alRg9WVPLUXmqlEfwwCH0Zlwg3h0A==@kvack.org
X-Gm-Message-State: AOJu0Yzp71GKfft8PGDAyPi6vSJHVzqThIaSUdJ9La15jF01qOUtGSmC
	RzWAXK13hqOxNTK7Ap4t/v2WsBl3B9N25Xq2glQL7nCssmjrDdUwy5cYqFW61jQjpKJhXkbV1bF
	dfmNQ6FWKty+vdhYbZc3GQzHUM/SgcHAfH0MekLGVpb01X70U7o9D
X-Gm-Gg: ASbGncs4XLUeI9GLsNzA00v423WCEsHrQXRvQE05AYaVqKV5GiQBqXNVpbRjMQ81+7h
	/E+edMaSzUw7A+bGf+wJ8OYJQMInqKaXmXHUrO1xco0w2/Ouicjmpjkcye2syl3wdealNJx2kPq
	avFZcGl2t5oTa9gcTq7DyaUkBnDr7e/uEqz+HF1Hh01Nf/Nd+W/8Xq9QYWfx3Frkph3Uk87xnam
	Bmt2SwIKTq1Q/nTwMr+QUWh/9HsxEuT2M+Laj079qBtbR6MgU2dsHnvW3rGIz90Mr55MuH+NFc1
	D4oYTyDtpEKNXxTbqnB6KOsCZ9KM1XF2cfSCT7oQKNHr+ia0xw5bWwqA3QHXegqPMa3RowYJoHL
	ymrNhi3CVi5adY21re1tKmuL9BqigKGuChd+JuBbGR0qp5LxlZOWwj5jzjiA3UoWI
X-Received: by 2002:a05:6000:25c6:b0:3b9:16e5:bd03 with SMTP id ffacd0b85a97d-3bb66564b3emr7504990f8f.6.1755509799623;
        Mon, 18 Aug 2025 02:36:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqLyNfJzB6LIHUYAl53Zj1vLQr81v6nLl+WxgYSZjEpwCks8VrRmbHnJYquHeO8D/HsOfDcg==
X-Received: by 2002:a05:6000:25c6:b0:3b9:16e5:bd03 with SMTP id ffacd0b85a97d-3bb66564b3emr7504947f8f.6.1755509799145;
        Mon, 18 Aug 2025 02:36:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22211395sm125025085e9.4.2025.08.18.02.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 02:36:38 -0700 (PDT)
Message-ID: <a385e09f-f582-4ede-9e60-1d85cee02a3c@redhat.com>
Date: Mon, 18 Aug 2025 11:36:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815135549.130506-7-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FTQrVoJ3G9yo1spYdhpkjw5DoOuZbLHGX_UIBRDT0kA_1755509800
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C12E40003
X-Stat-Signature: fd4mzb5g61xhjtrp5poz5igmo3kwntd3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755509805-422075
X-HE-Meta: U2FsdGVkX1+3OigQBtZoI0Kqj3Dvgqnsk3vctzTPTN+2ep7RSfpPqXDyHYYqL69twWUbzVTwGjPjLe52dVezFgdZqvApc05ukmz503PD2kkmggeomRMdGJuqwtBydO9keBrOHICVlJfSTYLHD8zQpMSnvhZjyB3iTHnFiJo4BUPIhUTsKgO2jBwXn/qgpmPHqHwVk11Ib5S40Pn3065RhULYLhHdYSQFvKoeK0t8sR1Nkqpav1DueuEXbRC86RjVQfWp5NCKkIbshstiisPqJ/EKHvOY9l2pFgj+w9RgGbj0/VwJELrg6+VcJIEtQQBHwaW3i19kiZi1Nc6MKHyZHDwgUvtefQknPm/hlDyZ15dmBBa4CRPvSWQhg6qpnM/Qyf7N13xSuLfWKEWVZ2skM6rH8iX0NoZD54taqjjJFaDtDwujs9FEaz0QeU8OlDtxUVzQU9TZRaIXsPpzsUcemfrDLYhsuXSeMwrZ/xrDDpPON8ErLw3f0ognmxrzPoH+2VHilke3MJjwGabhgzaj4tReu3d7Bi731JBgvoIdifOCsoASmrYPariGJMEYMJqfueDZFY6/9eT639D4q0vK/10sA6reKhsybQhonE0QFrn4Oy3a0yWcrTwtkTajlJV67vXWSNqD8xtd/NS7n2aUXKGTCoTYacQwEeUv045RGzaS9+GUoTtdesV0b1uSMEK3pz1+jAVINGHjBBe5Ai8xAbyPfe0brOTXs76RtXEqr5u0ZCWlZesEwsBMev5sWHxc/o+QEO4P5A3ypyWs6toRzbQ4Bqp9sS5foQ42RqXrdRnif3h0Th8MADZHh9+Iy4T+XcRymZ52EV1W1oT76zAvSG4NktIi5AYsRdqf9i04RGgv0TEgiY4b1pD3P6WybAfkqags5uWO+i89lKAypvJdJYfx8fhXF+3q+72MVxJHgZKr4PSyyE3hsAXRfZU3fJP0eCf3uVsry0JeD33siah
 ReQzPUPm
 jcrY2Lj7DWFUSCtAm8cLhsBug30o3AzbVE4t/M07PnM5kX6zFF+0SqQnjaEaOpGLRSPGq/djupsO4ndGyBHb+h450bGu3vhv0nAF+j9OXW/Vt+CsI60slM8OaeEzt2NGhrwJbK6d++ay3+cCKviC09eoGiEzTYME/qqPcnXDxfeIYtrRvsAoyk4D3hZ4akE052mbNEDOZeHzYOPEMOvFrkH+eyDakoMD4Hzi1x6vLL6UcbnB70uO8utx/bZRZlCAO4UXPlwAxR6x9I7gLpbqggsB4UWWIdPkBG7UvOeldV6UUKu3dTL0ZVzFV8QBUsv+yxNVr5YS8B/gnu65pGS+qvZsO8yQDSxUPh4OuBC/KoF5u3my+bnrPQ8boLaYLQnO5RIKNrTVl5pPctZeV4rLeJMjSiTH4mgdlGFXUh36XDBcXBdlaIoZbHd+LuMgVZQjHuOkuVnmHINkpCOGSoaNQu85FbzQTD9A6YXBQAW5+Uln/c+i2n6fQ/iPvhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +
> +TEST_F(prctl_thp_disable_completely, fork)
> +{
> +	int ret = 0;
> +	pid_t pid;
> +
> +	/* Make sure prctl changes are carried across fork */
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +
> +	if (!pid)
> +		prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
> +

Skimming over this once more ... this raises two questions

(a) There is nothing to wait for in the child
(b) Does it work when we return in the child from this function?

I think (b) works by design of the kselftest_harness, as this function is
itself executed from a child process.

Regarding (a), it might be cleaner to just

index 77c53a91124f1..1a48bcf2e9160 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -271,9 +271,11 @@ TEST_F(prctl_thp_disable_except_madvise, fork)
         pid = fork();
         ASSERT_GE(pid, 0);
  
-       if (!pid)
+       if (!pid) {
                 prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize,
                                                       variant->thp_policy);
+               return;
+       }
  
         wait(&ret);
         if (WIFEXITED(ret))



Same probably applies to patch #7. Feel free to send simple fixup patches
that Andrew can squash. No need for a full resend.

-- 
Cheers

David / dhildenb


