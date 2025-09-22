Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB25CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4251B8E000F; Mon, 22 Sep 2025 04:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC8C8E0001; Mon, 22 Sep 2025 04:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB2C8E000F; Mon, 22 Sep 2025 04:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA8C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:24:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4AA41DF588
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:24:09 +0000 (UTC)
X-FDA: 83916198618.19.4BE024C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id BEA6E1A0005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:24:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pt7fQ9Uv;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LDmzSNY//3bfqaJ6YjqbvFTHQWUglXrj6TuZ+YI6XM=;
	b=HV1XshjjXVHx/wSh/+KZ1l/F0hFcTvrYhtJdNrZRbl4F0YTHv364jkYro+4PttYHKDE2Rv
	WE2rNx/KGk9BfnEzDDiM47+XqGUXaXrSy3lnCMqMGZjovVT46E7acItIRWsqXgDFS5P6Gy
	Z2O7s7JDfeSse/BC83top4WGGbVdteA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529447; a=rsa-sha256;
	cv=none;
	b=tOOnVEvNGGSZy8WNwNCqlUkZUmE39Wuk11VDks6JSwgCFY6eBJ2UvmWspeEmwpCzfMdicr
	DSX/Ofo44v3/abCwipWCyONnTeJTqgq35MEa4kjx4SVPuwDdzS7FmryNCLMXMaqT2UDyDA
	JqO6FTmXPxaK3JXsgdlQ1cchn6JuqPo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pt7fQ9Uv;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3f1aff41e7eso2922950f8f.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758529446; x=1759134246; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4LDmzSNY//3bfqaJ6YjqbvFTHQWUglXrj6TuZ+YI6XM=;
        b=Pt7fQ9UvCd5wyAN/OClF3k+culaDboBz74kr9u/8UauqCGws8mPAZl/TkCUgM62Vbv
         4hN6FPwapkIjxVGEqPlJHN9uWpS9N2FWakLsdl6Jy+nPbIscPBVvrxnrNffps5YI3mvW
         TnSAbvjuVJ4iZh5mu8Yb7pWj/nA3mgPtCNXODdxUUqmjfTmFTVCSBpjtBwM9KF0j/9AX
         kPXOCvYG2p1SE/JkIvSFjrqewF11Qp8ncj/GTDnSYtnwZbMSJUrHAuPTTkrb9kLpUPGe
         iWcZmUmk3wx3QFZg0azHYBh0lFR1d04tyqs6BWXZNl1qnupx8z9aSkvpz5krI9VnJtMm
         0fsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758529446; x=1759134246;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LDmzSNY//3bfqaJ6YjqbvFTHQWUglXrj6TuZ+YI6XM=;
        b=Hu1Yv0LufnDBFmJvuG6tHfaInGEhHO09rAITwJ7OrAbp2M3/AZSFIqqIDECF1EFlwG
         bG2Au6dBOy0Sug8tipsTYszBccVaKlKKkKO5illDXYXWY8J9TRFLdtJva01gtBcN5PU1
         dOycOZhiI6xNArDtDAI6KznLaQBtaE3dtlPYhLYdQch8IAsDqaUnojMKaZKgdXhi1u34
         DbjdMCH8KatNvZ0vrEQ2QMR4DJrcKpYwYZ/9ZE6QhXIsCFykF0be3u9exCSCb5dX2no1
         7r9d3hakF3Y5WJZDl0b9jGS8mvmMaSMo+n1tItch5oLy0WID0t9WJf3cdtlhbDghYCke
         rRpw==
X-Forwarded-Encrypted: i=1; AJvYcCXiwrOSKqjcjY9cQEJhIoxAJq0M1fKg2N9CXGaNvXmFkTZea1rAz5matK24WtoWDm0Mz2let8iV1Q==@kvack.org
X-Gm-Message-State: AOJu0YygWIZkEmliwV0zqWPVc26B1gtMHG9sG+zNWpKpwFkSsH6S4akp
	nB7xI2tDqKP954GugcHTbqHolscnvZ4khSHmdyI+xB8GDrj/6mYFR5Gp
X-Gm-Gg: ASbGncvm2DqYDApEkzCf+Qhd+p+32dnVNww6+Ryt1ihcb2FIklqk2ZL5kQA4x7oh1Wp
	Leli3sND2DJRlPFQkfAGU8gvmJb+2pjytwY4ABYft2X+i3VxPF2GtrddE5JK8nod6pHH9P1+num
	8fQ84DXfefy8hV2HbiDK6H81VEbvdFLT9+Mzoz9pcxzoup/YTcgKJfgvVQw73qgyh4WHwxhuH65
	6VR8ZpRq2ZtZT4eEulG7gAysnad0jz4+dCCcLo5zxJFyHti1TV8snkeQZkewo+b3jMOIJmNhnAy
	+HwCIZxf1u6jImlmKA9nloNK35R6m+zzmtf+ydYL6WBu2O2dgX08jT05jrmodI3V7nee25ujg6q
	o237GBy+rEPQo0qAEGn9C/TFWAGkxQiuMGqiy74ph/w==
X-Google-Smtp-Source: AGHT+IH5Ss/MexQLwWH32bSqKyK5FwYfHlZSIMK20q+jLV1U7CXiGcXfpzejzl0MccyrWKA2QZ6x2w==
X-Received: by 2002:a5d:524d:0:b0:3f2:97a6:db6b with SMTP id ffacd0b85a97d-3f297a70589mr6175117f8f.3.1758529445981;
        Mon, 22 Sep 2025 01:24:05 -0700 (PDT)
Received: from [172.20.10.9] ([148.252.145.101])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ef166e62e5sm13972312f8f.40.2025.09.22.01.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:24:05 -0700 (PDT)
Message-ID: <8884d7df-9709-4f5f-abfc-6b74aa220295@gmail.com>
Date: Mon, 22 Sep 2025 10:24:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Content-Language: en-GB
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
 catalin.marinas@arm.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250922021458.68123-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tjyysa5tq54hnfqpzawkg9qu4eft1o1m
X-Rspam-User: 
X-Rspamd-Queue-Id: BEA6E1A0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758529447-350546
X-HE-Meta: U2FsdGVkX18Lx7Sip0+AbOIuM+uOE4WwUkAybELDbQ40tHoselqz5oy7suM26l7KZWhpcDKSgBu88wURFRUBgEvymwQAwdY8aqKBbkotMN+1li9h+AEVRjVL4sUW46Qm8tWYaihteidrJ6n/rcM1Cwu0Pl7sJwHYzg7whbhyF531y1mKUttDYoedq/pw1gtnWzfReHmEKPxFwFqDwwakTOg96JCD0tSuuVNgAn2zlPbewPJfjmxenBIM2NsaWBu7cyJFtTOsiz4d/Lu1ZC6VwJ2v0/CG0HUsSun7Gd9ef6SKKKUTYAJfbtIIs3Scf5xsoJ4ZxTRmYdzBRaGXfhnZiRIaKIizWppX574crl6klp+YvKWN0RHGR1kdHQ6t7HoCtdYbRY2YOju1vLak+uYrig9F2AuKN7G9Gi7pB/7I2xHOsa0AEgsQbqwmDLgup+Mii4367NU+LF0hxV8+G0B7h14vuWIQEo+RsK0k588y3TNFS4KycmZrQdN/GOBIYtp4o7pKYIRCMRwsF1iSeSTf9pd4gQEhVKtHJiUGM5p7LBokhwJY5nhU7LRb23mWK3I0Sm6L8/NDXyzB8Rd5HnnLFTltDBrBFm4PLCzTlaZTRrG4PRtYFByVgtWz/XuBA3pD60TxgWay58+ETueBLH099Shv9kgsgdT1ZKSK/KbmZW/jdkVbNsUTuzv8p0Nz4RA3SMwK6jR/kJGvn/sNLoUTFN2LZWFx+ujiaSgVjue5G+GtVQ3etQT4hVhoKyDusIlyGfct6qwxkAZcXwMxHXi72ZOvRCR+Umcth2UY5ldBvNbfIdNN7aYD4gMycCA6m93RgZPQ+4dYkSngf0b4PZUwvZMcJnRUeSKuL5pTCK1TCK2ucd/CaYxDfDm4Jve0PBJRAaeKzkFEkRP2t2HZa0u8D6oE35/jcYtO9OmsrzDVpnTAeFY979Mq9eSvwM6bcWYu4aaUdbOz2p8dnuXIf3q
 UvRHVCIx
 PoCh0MU4UCpiYNduyh6TRywzIIM5T/HQGTpnGyZ2WUfVgVhGJniqVFR8wJcl2XbnA0e57L2ur33SSfITGxyWjShr9h8SW/+cvaSBFAHlpwdleA0jKJxozAJo+TzFL8gNQbxNEfKzkrRw7MYQRCkDyy27C+jjH3tcwaA3cDzTF+q52XiiMbl+jXdNx/dsUV3WMIEwIXcyuKYDJz+B/EubX6hJ50a0K8fzyUYRD+NVEUW9DCgP0+tM6uPovk2Rf8JrTzhgOsCGdVXK19tNPJngEIuOy6MvKgkIqdyjG1UGW05qyyiOyuiEF1aMiRvuqkSqDyti2lGelgRMDFsD/K0NxFG6G4jBpUgr/TOkygG6BXefflpRAgyib+sAsOHxO3lokZKHOv7l59zfFFURMQzBuCuxuVd58KytVdPeTClBheIPUdbuNmhLOqxXs1eRPeIhBlyr7qsZUxZ205GNiQ7UOR4O68iw5LI6XTKqedbG7KMo1b1W4uTfmRVmKgJildf8PyzQX/e+l+cIuyfcrAsxV6SXOkNVT14Nmjn+gYavMxzW9mCFbINrDUTm8TAR1JywqVN2PEg1xo4u08guhe3U0+IVNpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/09/2025 03:14, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When both THP and MTE are enabled, splitting a THP and replacing its
> zero-filled subpages with the shared zeropage can cause MTE tag mismatch
> faults in userspace.
> 
> Remapping zero-filled subpages to the shared zeropage is unsafe, as the
> zeropage has a fixed tag of zero, which may not match the tag expected by
> the userspace pointer.
> 
> KSM already avoids this problem by using memcmp_pages(), which on arm64
> intentionally reports MTE-tagged pages as non-identical to prevent unsafe
> merging.
> 
> As suggested by David[1], this patch adopts the same pattern, replacing the
> memchr_inv() byte-level check with a call to pages_identical(). This
> leverages existing architecture-specific logic to determine if a page is
> truly identical to the shared zeropage.
> 
> Having both the THP shrinker and KSM rely on pages_identical() makes the
> design more future-proof, IMO. Instead of handling quirks in generic code,
> we just let the architecture decide what makes two pages identical.
> 
> [1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
> Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Tested on x86_64 and on QEMU for arm64 (with and without MTE support),
> and the fix works as expected.
> 
>  mm/huge_memory.c | 15 +++------------
>  mm/migrate.c     |  8 +-------
>  2 files changed, 4 insertions(+), 19 deletions(-)
> 

Thanks for the fix!

Acked-by: Usama Arif <usamaarif642@gmail.com>

