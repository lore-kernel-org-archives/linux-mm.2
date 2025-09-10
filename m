Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D2CCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950CB8E0013; Wed, 10 Sep 2025 05:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928888E0003; Wed, 10 Sep 2025 05:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816DD8E0013; Wed, 10 Sep 2025 05:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9478E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:21:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D92513BC92
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:21:13 +0000 (UTC)
X-FDA: 83872796826.14.154FB09
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 553114000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:21:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bk7liKNZ;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757496071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXsx9Ic7O7zZ84RSI3WUTXXDbyazumVEbCuc+kUHkxc=;
	b=TkTNq0yFjMkHUgE1WgfGuyqv92TKPOLmCwrKstX/lCN/s+2DqfohS2ixKsjGpQlZaOVR8d
	hF7LNP/N/csIqqdOcGDj2Ia8i9ejhU6YOvqC1174nspq+4Jnkg0obGZPRgg9vygw63S9SR
	FO0RI1TYM4er1IVZBEiqqTjteRjz08A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bk7liKNZ;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757496071; a=rsa-sha256;
	cv=none;
	b=NpNxRF22cywYgCTtnIs1xrENSluUZxWUpvYVlLaT+3zpBnRCIs+y2yvCDmiig6qfBQEKG2
	xKLzHF7NWdDuckzFqJ1mgV0LMmgNNpk4xxei2tfsNBPfbLA3NyNUK1RnAw27sNWyvcbd/D
	FSQgZmUmFKWyEoStF6JaLQYtg+YCBgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757496070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IXsx9Ic7O7zZ84RSI3WUTXXDbyazumVEbCuc+kUHkxc=;
	b=Bk7liKNZJoHBWy32ylkkfZVsiO4dMXyKZB/+W0yZcqX2wm3Ka2FXAcuYSeNCub55z6XopQ
	Yjfm+jWRHe0kDZe4ZJXpHBUwiHhXSgRAEL8oCxfjVVRUlhduPcdCKCyR0BRyVcaIjr21aA
	JKWElBDzooAt0Iu8tJLG0sHZbbwqOyI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-hke0_EeQPQyStw5aD-gSLg-1; Wed, 10 Sep 2025 05:21:09 -0400
X-MC-Unique: hke0_EeQPQyStw5aD-gSLg-1
X-Mimecast-MFC-AGG-ID: hke0_EeQPQyStw5aD-gSLg_1757496068
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45df7ca220eso1128685e9.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757496068; x=1758100868;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXsx9Ic7O7zZ84RSI3WUTXXDbyazumVEbCuc+kUHkxc=;
        b=lUGUH80trLVsMe8krHD2TdzZWRFc4qIGR+IVXtwpRQFOTCo6iVY6DLiKPDxLi9jqA3
         4V3U8lbpEzlsIDoMfCnjThWs2IHu2xqKCHrOBm4F6oBXwWYTQVRW5uSt86L25Mc9R/5X
         59mK0JWk4QoUt9//tFPA0o8K/Ep0Xu6EpOf4XN0mzTaxdsZcpMqi8OMYdEAcxp+Ogomf
         EQMjqbHY/uDmuUw3farsRQ9WrO4cIoSLnkpmVWEEhmRihXNs4dGhpkiBS7nQsFKuLZtI
         6aB9zowb2RIo7Dk7578heCUXd+lCmELOnficsO/6lslOLNHIIjhCsK7sV9N0WepLwkbA
         1I6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkTz3qxIJc/WUdIsJZtcXUpl+nbp5cc+brjEWaEcl0pNOmAeUYtz8xvW4hOZGTjRH7il4N5nVbaA==@kvack.org
X-Gm-Message-State: AOJu0Yw7pxFTRlLpBI6OdNmzDPth+ntQoprBNqnUA4olJ5uvDpXQ8w29
	g+FqNKxC0qEOGErNgTil23pWH1fo19WbCSQyJ1/FS2lcutY6cwmgydNBjiNOImKS/Ly6MKE26nx
	2aGSRVtZYheF+kFy5bOFFY3ViHtSsGKnOHq4B/igFGtuUPXiogl18
X-Gm-Gg: ASbGncvhebxc2HAzJJE+zUXxD0YIoB4zPPiUmVk1xhmmqi+uyIZ5vlwWdKNyK0j2fM4
	57WiJEk10+plAf++8c2IYAUv8Q9kIajiPSKFgbaT3S/81krM3nW4jVB1eibVLyN9+AwtIhLzMZE
	lu3a5Us2f2JiVSHYcP9enS154yvv10zae2721MgI6Me96jooWdA7+/Eda+chOCLyB4Ap7aReuIN
	VVAW5j9sT00p2VYAZxDxz2XCe82QWuUIhXpHAIvUV9ZBSQL8xwTLkZ1CDwBq+o3HSBoBJW/IxOp
	cdbG83TXPLNynaPOwAzR6igH73/2Djb9jRo+9FiwPiod7llAfuPFcwMCsHoXHe9qKF8m+t4pSB/
	RALp1XrZPHdwWDZdTNYI/TlqBhQe/wIw9EqyTmbJH/7ZYeiBb+bNW0H+luPfFOcu1uBk=
X-Received: by 2002:a5d:64c3:0:b0:3d0:3eae:576d with SMTP id ffacd0b85a97d-3e642f8f76fmr10290437f8f.22.1757496068093;
        Wed, 10 Sep 2025 02:21:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCnT1FVklH7nbjNgKoM/He/fVrE4yAXPhgf7MBYTl2+m5PkmwhD6Q2MRLgU+UZH+dNGP9RYQ==
X-Received: by 2002:a5d:64c3:0:b0:3d0:3eae:576d with SMTP id ffacd0b85a97d-3e642f8f76fmr10290400f8f.22.1757496067526;
        Wed, 10 Sep 2025 02:21:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238997sm6493544f8f.37.2025.09.10.02.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 02:21:07 -0700 (PDT)
Message-ID: <2fe10966-521f-4af5-a9cd-f55d04b12eb8@redhat.com>
Date: Wed, 10 Sep 2025 11:21:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: remove PROT_EXEC req from file-collapse
 tests
To: Wei Yang <richard.weiyang@gmail.com>, Zach O'Keefe <zokeefe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250909190534.512801-1-zokeefe@google.com>
 <20250910091622.n25zvgw27olskao2@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250910091622.n25zvgw27olskao2@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ABB3FXLJCn1o-cmF1P8acsgmvSIE_a9_ti6RDZ1pJTo_1757496068
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 553114000A
X-Stat-Signature: a7djk5e8ekwsi4dudrumtgfs84k55k7w
X-HE-Tag: 1757496071-237247
X-HE-Meta: U2FsdGVkX18Epc7ZSVIodWmkpsNWFY01e9dW9+mDbrKaKCEHhiWZtCRndVyatZnA8BFVJyUmPB2vQGtXh+M+lCKrLeFMoBo4gmnnbYj8vy/n22dsnoVQgPhF+FDKeTGxE7yls15ISIUmBagEqRYlP3HYvUV//Q/msLReGdP59OsCgHNj2cP8xqH0j9ffaUUC4pSiKChLUMBs2ZDDeuWF27gwdKAePwtTNiiulUtmFSMT4yYPJVhdcRfvF87B1Ul5JmPoIREsiiE21j2ZxItOVBePgOOlAq4RperMmIVNygNdyMUWAfd6sJ8x3SWofhzg20yZ/3fJldPVjtK4PdZ0PeKzmWDUMlwFIxDdyn6pOn6+hi5/0bibgnbwTmfpY3tTc2ZNIfqAx8cTfqS2OtzHtyN5UIwXp2bb8/M8gLvlb4cWYxNZwgbhNgdFpsV2wCsArRPYtC/e/Tz1bNJsKBYPSC70QCP7fizqJ7ueFtgYdthvg7Ve2pKwfXGVltKrrCohe9Rq7eY8NQJKq51NoKBQ8/puoNxFOH9iAoXEIZNtltbvThZ3KNADXnq5HAaY21TN6s/R5i83h9+hARdW7yIEHM181QHKGLhi4d/Rhdg1HSAFzTWg0wgdYbiU4xuhwKnWwJ6Fu7i+VzUCNPESpep4CVJbIrz3xCQkDEzuVwpaHo98ncP1vrv9k0SI9z9r4Dv4H4phrvZ4IKW5Rsq1RejA9ZnI9muKancxuRpUJJSO82yNwqATKvu5lMpxCXIVwOtBZsRsT+//1PO6nR/d3ujcalHO8VRPa1Txn3SXJHkvoo+EwuKGwMaM5+2+1zfmNuleeH+m4xNDsz1UHxBgAmBhyFWQhPuZydszpTKADJyst3cL4AsBtVvS7zLN6PXkXes2ElG7jqQGCrO+p3UQb+97+jYAQFR19lI4nEB8CSl0wdixv0Tjn48K5+3gSf2f8vAhkPc73xv5upp6TA5N5Nc
 pBwRiVp+
 BkrAB1eSLdF92+de/YxO66bW5sYi+hrLEdJXbMAD3GWmaJsGqr2wL7TvmLdr4YaGEwAtxDr/UUh4A9LVfBkJMKlMHVUybxTlNpCqE2dPNiXdUFcfVymTaDjt9VWz5UZMRQyRvX2mcDfidJZQ7Z6a9dzs9Xw1ymQg1xTGU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 11:16, Wei Yang wrote:
> On Tue, Sep 09, 2025 at 12:05:34PM -0700, Zach O'Keefe wrote:
>> As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
>> thp collapse no longer requires file-backed mappings be created with
>> PROT_EXEC.
>>
> 
> One question, what if user run this new version test on old kernel?
> 
> Is there a guideline for user?

We try to keep some older kernel working as long as it is easy, so 
people have to do less manual work of filtering out false positives if 
they happen to run these tests on older kernels.

6.8 was from end 2023, not sure if we still care about that.

-- 
Cheers

David / dhildenb


