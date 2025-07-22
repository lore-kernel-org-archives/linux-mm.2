Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E81C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA2A6B009F; Tue, 22 Jul 2025 03:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881916B00A3; Tue, 22 Jul 2025 03:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770096B00A4; Tue, 22 Jul 2025 03:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 642C26B009F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:20:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 186691A0242
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:20:28 +0000 (UTC)
X-FDA: 83691052536.14.1FDADA4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97ADCA0003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:20:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HVwvqOUK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753168825; a=rsa-sha256;
	cv=none;
	b=SlQA8CEYvvv8AjGlgLkTC44JBLFtXjW9CgnMYzhliVZ+kME/i8maixNmQysonact+5FF5N
	BFo6XGwPlo2gbsJdzTxuCP00X+qV/nJ4zFMRlV6pT6TYCrjY9nAQudsdraROVSaAKnS0hV
	4/YVbrqayq894PeTwsU7A/00o3P0WMc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HVwvqOUK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753168825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CozW1E5VHLpIUqBBRyUZDnDHcxpaM139xWKAC4+LRyk=;
	b=mPaSViSRKem5dU1vD5kO9jwciVlnNszD+FHxgL5VdBjoz5zAxiYCkrnNgMpWUVcO21QriC
	PnxuVNlyDyp+tAnBBjTssf8LT22gRlAir7581MaAg4q8ewOBMWl5lDid1AYyAFCUhzpvoz
	ENDJ64WNVlI/KjypbuNHnSAUKY1PPPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753168824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CozW1E5VHLpIUqBBRyUZDnDHcxpaM139xWKAC4+LRyk=;
	b=HVwvqOUKf7AaRUWge7X8sKy+XT8DswL8tV/+xmBGlXO2C/Vgl5etcJOWVi/wcKiX+2PW3q
	9UG8dpCibT+zTtUi7JAMxs/L36TcJw76OG6Dph1Ewq3L8uh4bmtzT7mPqhnrmtzkSTlAlF
	mkBsDXP5zo3YU84Cq13bEkVGFE6ALtY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-MuPtULjIMk-nZruCAd6GlA-1; Tue, 22 Jul 2025 03:20:23 -0400
X-MC-Unique: MuPtULjIMk-nZruCAd6GlA-1
X-Mimecast-MFC-AGG-ID: MuPtULjIMk-nZruCAd6GlA_1753168822
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-456267c79deso17135135e9.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753168822; x=1753773622;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CozW1E5VHLpIUqBBRyUZDnDHcxpaM139xWKAC4+LRyk=;
        b=C5jbyQH66AkMoYJ8kKCoDSqzG4J3cd9x8B/oOGja+iQ5N9cwc6fgh8PhGcaOUmCDMW
         cjmNl98gCWlsWCrbuE66N8O+9VVGxSyOQSQF/nYYNYjPKXUhLPTK7dsdrL+Xb67OoL6G
         Khkj9y3aINH0YkiAmkdIEm+l2HUTtFHGqwemZYlfpuLRfg54ZRyhwhlmanA5OdoyoebJ
         E/1Wyfr/AYDuck6N0DfPiXtfVT0OIdiK9yhXaE7VDGZDYrI4Bvef477HeXzANsFG3ShU
         471lISC5SdRKwlmVtBKJIPS/Bybcu4xU4sNHGYJpHE1K6OQL6AfecJM8D2dQ5zrbVzXV
         bhug==
X-Forwarded-Encrypted: i=1; AJvYcCXIFtkHu/O6EZ7qlNQTV7vdCzt4OyUMTOn8fKC/Bv81PMSRYNa10m4RTEj7NgmBUm/BJVzM8qlZzQ==@kvack.org
X-Gm-Message-State: AOJu0Yyf5HFayzAnmwSbrBWwsT8+XLzVcOTfpNBj4ehDdDn8z73QAsDk
	elPT6XDjT0VBP0uFW2EkPGtnR66MO44mNuqffxXLscxf8aSIiGCSlLsH12v85cPsZxzkCcKMEnN
	ow+FJtLQ19G70CqA+sBJbsEy+VdkJ9KAJQ38Xaet6zfHWj6DkPovl
X-Gm-Gg: ASbGncvzfIj3TiCQz4L+nJdqkU67Sr/GPtiaLYbpNI1sJHlevciNb6Ipmpuffs4lGNf
	9G2xr8+XEtaJM4QYeu/2zKSfhkuVqqN0RvXO1AT5+a3gEfvju9VLPNU+kya+ilfM/aGQXKZWSqT
	mP+caKv/Yc/5199a7Y48corFZVZa1gG2ytz6zy8H98XUTUmyGj1bMQ4SRguiRZKHGFL4Tq05qwf
	Mx76upxrrmw5WFhmJ5ohrBgGcCkxH6qS/c1aH6jqAfJ/0ZgeGiZy30TUMSC+C4lHuN5AJiqVpGk
	kpqt+qpxqGQfoqgqg3PPzcBpzhvn9FkVavBMA3Brulij7WgqCETnUfnYuaDz5yQnWdCAUrA=
X-Received: by 2002:a05:600c:3e0e:b0:456:2ce8:b341 with SMTP id 5b1f17b1804b1-4562f88ae8fmr231946105e9.17.1753168821976;
        Tue, 22 Jul 2025 00:20:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9aY+RfSXeUZQOme3p3eEvdvpsM+HvGTuV3xDyatmqQO926XAYqBAK0UL30IswRl+02loPhg==
X-Received: by 2002:a05:600c:3e0e:b0:456:2ce8:b341 with SMTP id 5b1f17b1804b1-4562f88ae8fmr231945585e9.17.1753168821260;
        Tue, 22 Jul 2025 00:20:21 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0f597.dip0.t-ipconnect.de. [79.224.245.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e88474fsm185479545e9.22.2025.07.22.00.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 00:20:20 -0700 (PDT)
Message-ID: <39a75435-5fea-4816-b484-477d400c3564@redhat.com>
Date: Tue, 22 Jul 2025 09:20:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gj5im-FQeWp9_twtVG0MRT5JJkmv5wcZeWaofPbO-7A_1753168822
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97ADCA0003
X-Stat-Signature: t11gxwir4gir3kor8maodhyuy3ue9nkx
X-Rspam-User: 
X-HE-Tag: 1753168825-712540
X-HE-Meta: U2FsdGVkX1+CQ6pnEYTdPKkBhjOnoKhlxEfpg0SMuSNfaTYk7GMBOX8T/rX/8tktBnjlLg/qWuCJFw1y2df5ihcx5zbStxVu9RJ4J61PX4mnAqJSvpdEWFXzhlOpbg0Tm63SrYwKcscBaKwV3GazRNQ7KF8AMImWoMWS7l0CFUsQoOKX0WwP6mmOa9SI6OkEJYnagVsZaCQ+ct8MyIf3zXn8ANxV19qcMR4oplwL2ZJDTDrUVe8E37nRYtLs9UXPjQB2yefmReFapx+JGAEZFqenk1jiWPj435TEmk4nM4L6P2oRbiSYJyKqKftfeQ2KeuSLrew5H96J/mHsZhCBho+4ayTR6BWewwb5yS/SViXJuWuQGSL1dETgrkyDUto8dyfutV4qQBWFIouB3SxXPzObvX8wb8Ue61SHK1LBBAlqrOhdMiiHpRJWFXmRCfTwiThj3MMbCxRRWQ9kPbrEV61QBl5OSwjyDzzvsXSZETTwYhCvXfSr2CZOEhDH8KWnKk3DNkc/qWmnzXD0BXPBRNI5j6w/0s2fxiIRCP892gT5N7uMoY2xPVaYZV36RO2+vFoMhGYdNKltQlxUHgOtm6WGuFuEBW9JKZOXyfwttwR/+OcLb9/2KM8kULsoWLidbrKZ/G7npXsg/ZolfqiIpSwZpU63GGgBTTXrKXZrBDGbU3FHJplhpDVMoZx9BLHL9gEvmr/i6yzJxSP7COFNAGcRjbzW60j4Sd4IAm/Bc9M5d+7V5H3UqDQV1jHqSI4MNhzEW7V9i8OZ1Y9LFPmGRbZ8EupiPYO0J96XfD7Rek80Jf65Mt3XCK4rtoY9uJ8G+OUyOnGbvbUZO+TfSweeTMRucJV5adPxUQZcH2oGzjmp7XBPdOd3kXlGpuIeO2/1sAae2NXdYn956k7J8Cvy4BO4SV5/u+HJ4W7zx/grGMbtIp0Dau8gm5E/S642APBDO4YHDzygHDiuMem9KHd
 +7OAc5kD
 QU0D0SyOcm41R3bW4NqUfGHr0ZEA9OHFBc0GnglJRi++zdfLM9S8hTnRfNHGDdOc8aXLQ4JiseN3iUxjfBNbOAoOZW6/1uShGIQ2cziwPjMrkd8NHMwXg/hEOzH3bcniT9pUqh40zYWIaLFqXYo0gAptwzsP6moHWRMHy/PrSi6ncrMx84kk9StxvOD3D4eZx8AgU8gZ1aksqdQ5itv3+ffKPpl/mQzA6Yi1uvEMPbHaSG9OvaU8HG8V9+ubiVTfYs/NIKi8gE4iTkSQoRbLUqIjA+fJurPmnKIIiMKFYIMPHgrE/9rN27cuerFzFj/YjfqiIFzopvN6nlN+54G8uHALorTas/l64rusMxG/QdJl3DaRlnGD71idXk38aI5Y8JTuM5IHQ/UIXGQGtzg72FPppLL9+G/4wDrZJdzyOOSiEv1GTEBWYOrhC6lJo1vqpAzaN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.07.25 17:55, Lorenzo Stoakes wrote:
> Rather confusingly, setting all Transparent Huge Page sysfs settings to
> "never" does not in fact result in THP being globally disabled.
> 
> Rather, it results in khugepaged being disabled, but one can still obtain
> THP pages using madvise(..., MADV_COLLAPSE).
> 
> This is something that has remained poorly documented for some time, and it
> is likely the received wisdom of most users of THP that never does, in
> fact, mean never.
> 
> It is therefore important to highlight, very clearly, that this is not the
> ase.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Can we also somehow tone down or clarify the "entirely disabled"?

Something as simple as

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index bd49b46398c92..2267d22277238 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -107,7 +107,7 @@ sysfs
  Global THP controls
  -------------------
  
-Transparent Hugepage Support for anonymous memory can be entirely disabled
+Transparent Hugepage Support for anonymous memory can be mostly disabled
  (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
  regions (to avoid the risk of consuming more memory resources) or enabled
  system wide. This can be achieved per-supported-THP-size with one of::


-- 
Cheers,

David / dhildenb


