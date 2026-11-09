Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5060C606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s/nTbzUx
Received: by kanga.kvack.org (Postfix)
	id 6791C6B05B1; Mon,  9 Nov 2026 04:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650826B05B4; Mon,  9 Nov 2026 04:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566096B05B5; Mon,  9 Nov 2026 04:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 318686B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:05:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3B7AA061D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:05:37 +0000 (UTC)
X-FDA: 85414997514.10.D119E9F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id E450040006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:05:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="s/nTbzUx";
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794215136;
	b=b/CSoYoOcAU6IP813cJS4k4uXzahB9L2XtkVow1b9oXEebJod86TxXj1XEYdgl5ThRaVwc
	DrxHuOrUVRp09IhOFRDtooABXNU30VyHMX5BeYGIIHL4YXzFuQBokrwJBVvS//k26YR1ZV
	j1IO9sTSloC0B7or6LRzE4IyitwM2i0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="s/nTbzUx";
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794215136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgV0X4jY1dOn+LKwLYZEG/kajINoeEuxwPE9Ju7yIFg=;
	b=j33oQ097XsL3zfy30+DEUHoarmlEkjuCdI47ttXHCTdPyQ38gtwZWTvb0PB05jd/lMGVq7
	VegnqIyo9szWQBfKsyhmxKBvIMNIl2GGq82hWM6mhrgyTLssai2Dlv6/T2C1HMKNk+VM2G
	jxdkOeiQLjaCFjwG5eb/AcsABBWzIo4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e3b22e971so286401f8f.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794215134; x=1794819934; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hgV0X4jY1dOn+LKwLYZEG/kajINoeEuxwPE9Ju7yIFg=;
        b=s/nTbzUxtH+G8TeNGlb+GWam84/mNQ9nZyIXUcscrECSRpTSZsdg0irAN4f/ycM8/7
         WPW6bd1Ta11Jl6+sUSfWcL3WvRtY2v7wDaAC+3waidv8b22dcDWIhxdoQ4ngpgeH8ZzY
         n5+DDyv5myN+2QNg6J4YJvO9447cp3NwyW1am8QRsSqq1QEtfDC+e2bRPQr0T4Ah7Yak
         K1zcwmzqdzWRMoLEzxT9L1Ol1t3IA1YEXXljvix8G2KMgcatw7+3bNIdLtFN2B6wyY/r
         ffYlBcnZKm95P8SXcZuMOjd9qHf026TEWf+lkYEPkTrKb+cgA5r7LUQQu2H2wI9X9Uia
         MkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794215134; x=1794819934;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hgV0X4jY1dOn+LKwLYZEG/kajINoeEuxwPE9Ju7yIFg=;
        b=tTGplSkyv/EaaWqRVLXslikpqlBy/m0s1UlJieRkd8b2vToeeSrKGqlMZa+wwp0hYB
         fqmSnWvC/WTM76e1ejOAWMYXx/EhDu4xJWV54OOX1XzLir0hhrFUqJKJno7XFWKTHok+
         7f4lScejSaSvZYzUxVeaOIhfpEjwanxmkuRGfgA6hIRvZs9y21VX53C4r8Kc9RwvmuxU
         ArZ85fgED9yq3Cv/cdkZtVxMqdBc/NyjbRdoRHsclXTmX+MAdA7P2YVLnPpv1T3Tzy8f
         q8rKeyCNfQRnv5DkxLeWCgs7P6nk8BUsbjsM+T7EUuU9xQoVEnMpQOsrZ18Hi+RpCME8
         AUVg==
X-Gm-Message-State: APuU4Z9H4hCytBxDbQx3Xgm/IhN5WZiONjfHK6+g/ZaGQ1PKnfO+Ua+9
	FIzqpcANkJbbgw8ksXlsscPOw0+7qV1gW+aSLjkAjU/8WwMELtJau6fV
X-Gm-Gg: AYBFou3JIedbLqZ2/+TBDTT64AfSgOWkSxWRaCbIFXh9a9Kj5/CrYMkPI7+pUsM1YyW
	+PnBTH6PvK0DZS0CA6PR1oEiIesCQoRkIFl33BtWeK4+OWBKGEDJo+N/16hbOTai7ytpKnqCBku
	L7oSDBra3geK4dQNUGxXk/iMQRCZik8Zzoe5DY3F6kDrASmSlGVHJqrpyzw7PXyQvbPWfmPUVBe
	Jw4GppPjKESi2Styl+piUoOBVcY1FB1WcQJ6vCY9aTu1Fcqidtn2X0rhna/7+KzW7vl/vrZhSMq
	8VX4VZQWLFZz8hf3uQRb4ByicbILBcRdfpPxbQiWrKBbmc9X4fQU0chtLi6BOCiTVIgMGqciMv/
	vhBEOzB/z+zTKwTriu4bY8PJJ009CQY9PYCpXQJ+U/8/eC4684BEvLWPvgN1+juvVPNSz0xAYJv
	hdbQPfsBl61UPaBScxJEVUAoiJdAzOxNOByD+y7AYVQAzfIR8eJpQYU/cSSRmUSHfEonmRvIr6I
	v9Nf5IggmtrtHLOaAkTCjNWhtufULi9OALNtfDylac/rzQGsqEsAmhzMGtG3jCfdsZEjcpbIcGJ
	Lq1viPOSfwCVDkF1UPScdUo=
X-Received: by 2002:a05:6000:2210:b0:48b:a7:6396 with SMTP id ffacd0b85a97d-495844a3a48mr6683329f8f.41.1794215134134;
        Mon, 09 Nov 2026 01:05:34 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49596ea51cbsm9541323f8f.27.2026.11.09.01.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 01:05:33 -0800 (PST)
Message-ID: <8ff83fbf-2ecb-4f9b-ac8f-ee88fece67cb@gmail.com>
Date: Mon, 9 Nov 2026 10:05:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/gup: limit pagecache folio refcount when
 grabbing references
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-5-c38f6809b106@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261107-refcount_overflow_stable-v2-5-c38f6809b106@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7nxmh8p63qp65tim8z96wyjxjz9iau7b
X-Rspamd-Queue-Id: E450040006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794215135-434511
X-HE-Meta: U2FsdGVkX1/5YcFCFbQfK9kKscEHQqRsPUuTHXMvioyytAUQXB6M8pjUuyEL3mmg/ltFZ1ks6ajgdEF9YS5mSBavshhQ9ax+GL1HaZV9QLUbsLRQiEXCD34y+wxxU8iL3o0Y6xteDXVjEoPMFUUNFlTZtKXHpesrHBLmqzJZwzQ7GjC1f4UFfVmhmwSyMSBWWnyAIDubVbu1/wyF7jsUztU0S1xvzGSubwb9kxGZ6mY1Hih6/ggNHkMgTjc5sQT4LjsPtyp51tFFULwiswM1vBuzeT3P4PxPEgCgaeRljHiWLu8L6AXg5Dr53znmXmrL9r+fePOJxg0kiYOPBzSDMLd24HBVB70cZc4e0PbJ3z4BnsgCHPCvUwiz5NzMLNfl0bAQeNR3iVBCtjP2SrNVqiFsbYI5hO/31ClzmagTYCJ9rBE34gY5ftHPGEkjf0atqvD5RjChdqb+qcGN3a6U6pLgkEavi03B7i0ApA1H7T4UUuYuuVwjX6xRwvArfO+vdbCSC+4/yM6+mcrFAMbL4JpgrS428ZNdm3Xd3QNZQwmTzmFDV6D44VLPpyK3x/9snGF1CkLqg7jWoJg/GJV3K4qssYbsASl9UMIsaGFJo1TbEjuOi/OeTRzWDBP2laG19Qo25ShXlCo/FneLCdqkSvwcbHhF7GEeGSvhNk0R/0qmCFExOHlAs7Az6qhMxeYAa1NAOMU772SQoJwowibviVAo2B9zebc1FvtVkBoefPBRU73CvnqXYsJ20gb8IH9ZwMhnj9pVev0qn4ChWw1j/FCjpmjdbzFEsLRMAGtFhKgAygBRYSfUtMrGeRUSFqmOE9/rYMsQHbgDhI5HJ+N+X5yIaqa4Km+9JNSdqsPShYJbGqG6S51KtKma5mPqlZ4vEKTnU8XgS0h/KJsWcCjSUY9xOy98IG35+v+fwNeKl4d/VU/+WFk6sLeLKachvyYIazPMHee5Nfpwa5NQU2/
 NV5HWN+y
 5b23NJtBI1H7k0Bf5mrTDQxG/XFjqvBhzRLxND7cBAlZfsthuv8XRxUnfRpLmAR0rOfRfdrtsM7scTx3IPU4dSuDFBt1DdRsimypFoFuD4xTX6LwgPAMxtq4fCABBhaWguVnTsDiPL+29bxD/vDqlHaGwHE4MixXIiThT9EOFLtGHJONx7EBKHu0ZL5iwxAAfwdfticcyua1gwO552y6InX9TN+5Q/i2e7Y9XLVwPtg/4cGWZd+F/a7wYkiS8Va8yS6q8SGj9z104UV0lETVk/MEbjM9MmwI/Mr8Ymg++ED4i/unTOtamWbIbVzslY1YPd/lmoddt4SN8ndlVB/r2g/cPeH0QaueOanDUEgDbKH8NQWfMm69mrAL4MdqsUrPqIjIYSNzwU5DUeZH5NMootws5YR0wJ6cAydj+6pHjrUIhGm8ILTfb98dkCZtL0n5nzLQW9GzdQxoUBZRm2YzBYMvk7H4DJuLjnw3/RhiqIzg1yxK7lBGdxSj/nobI7ByXgxI7sJlEfUoQygFX4BPW5kvovC9fnnCB42v9yu8SNeWbxOvVqXeRkpPAvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 11:23 PM, David Hildenbrand (Arm) wrote:
> Let's add a folio_ref_count_over_limit() check in fast and slow GUP
> before acquiring additional references or pins.
> 
> Keep it simple and use the check for all folio types.
> 
> Don't check capabilities with IRQs disabled, as even unaudited capability
> checks can take locks. Refuse access to the admin reserve, so GUP-fast will
> fail and fall back to GUP-slow if possible.
> 
> Also propagate try_grab_folio() errors when grabbing additional
> references in __get_user_pages() and in memfd_pin_folios(), so hitting
> the limit returns -ENOMEM instead of -EFAULT and -EINVAL, respectively.

nice!

> Keep the existing invalid-refcount warnings.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

