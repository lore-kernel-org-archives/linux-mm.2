Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A975606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R4hcP0fm
Received: by kanga.kvack.org (Postfix)
	id 868676B05B2; Tue,  3 Nov 2026 06:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDC26B05B3; Tue,  3 Nov 2026 06:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4AE6B05B4; Tue,  3 Nov 2026 06:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4385A6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:59:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCCA916038D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:59:17 +0000 (UTC)
X-FDA: 85393662354.26.922317F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id E28D640005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:59:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=R4hcP0fm;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793707155;
	b=r/tIb5+9s6evDFIEGjXYmPEi3pdPvOxOANPalYLNN/80ba4eLS/UCGqsyJAOpWpKWBpOYc
	RpiSjqsNT1xQNk2p0XHs+4DX0C/es8qiKHMQjewZgQBHuTlgWdF2D7suiE/jv9U0s29Ihr
	bo+RYkf8IpqIlO44VcaPAEw2HY8yhds=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=R4hcP0fm;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793707155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPfT2r0DJq5yqGsInZIZFg/Iplo7x3s5azqiGNXMZiY=;
	b=N/5kOID9l5hl0dpHZss8eFd1aFlzDkdvmhtKXCi6P1LNv6lZ+L0VCYijL04Vez+hnsuBvf
	yctmtneXBIqnzhnx77dR+37qfryDGK8V6LXClNQU3/EIBhTC6Fp8jr6SiTd+QJO0w5jwe/
	UgzBuWRfGs9XNKtzGO0lR+5AMhpJzFE=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a208d93758so43518995e9.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793707154; x=1794311954; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oPfT2r0DJq5yqGsInZIZFg/Iplo7x3s5azqiGNXMZiY=;
        b=R4hcP0fmib13afpxrWyhjQ/x+cbod3Jyb5yQlarOYim57RlkJlrDqQSNakP47mUBnz
         NMYPKoi/F0dto2turo8vIBX1LZ3NNUPMYeusqj1VXX7mLTXFWxyOlEYMelN26S9yhOux
         sCaTefYKkwKCvhXNENGbC2brWePnss8F7J4y9COrJmRyANYwaZvEsndiyMqERQWxcsfi
         2DZ7VtM0/b7qw05+kejkiGKmr1IRT1lB+Ghr8f1JHDIaqad1IFEDtV8DQ2g0wQXhM8/T
         bVqkbFJ0gKZMZIy6HbuNjbirAbHHRF60VsJjNDzuiOb0Kuyg5aT0gYQwHlCfDOGggEAr
         7RyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793707154; x=1794311954;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oPfT2r0DJq5yqGsInZIZFg/Iplo7x3s5azqiGNXMZiY=;
        b=XPVIO/RJ9VYe+fMxNbp66PeKggIO54hU86NSwbxxvjVoP4quIaxEsdUHdb9GPIORyF
         K/YUiyMR1OIzmCbBD7zr/4QHmthpjANS7YuA0N6E3xYkYdPLK507TxPqEwyaC03BkF5D
         ftOYyscRMel8K8I7oR890vmz+6NwstrmKXhpNwU9Gp6OXUhLupU+1ce2igQMdx2gMHc2
         L9feaDCJ3YJxAxJFXefvbmLklLmMMDILnFz43emo396Cq6SsJBIhodkLLyGrg9pej/o4
         CX2rluWjSLXLKCm5TOZhRmv6Rj8dC9GT3BC9aZ/fpaSzwx73hGYMrgDF7Ok7fRyC9P7X
         96wQ==
X-Forwarded-Encrypted: i=1; AKwUvBw66Xync0mElO9YEbS99qVBa1dSLF1cNlnORTwSOmhZ60BRPJS3NX1b8vaRBSdp2y2883fTmdEB1w==@kvack.org
X-Gm-Message-State: APuU4Z8A8Yos/z+vq2bRwJd8x83KQESG27zmPFwtdUWk87x+9PGV+XwA
	hbeB2Yv0H5veTcM9/wYdb/HUqhwcDyOGNcwpgeS6fqj6w+g5xYb/efWJ
X-Gm-Gg: AYBFou05EgmJodYGIWiSZfmthOvS89SaL1FvLx4XC3hYPgq5pffVpVGU4LpfVebFDH9
	/dWF5DZq8Y1fdqlNFCKkAKqyDfwkcu0VLyjKFICKQIzKetKMyDdk9XcmemNtwtsFot9KIIf0dIz
	8szGFbAIfq/4cM8U0GsGQWS5hUEfizzi7RWRAPrk1f2qsriSrA8ODHdiQiaJqBYLyx+GdVSh6L6
	LfyrKVnrcnG3QTwIaX7ldhdKZeJPfLHwVjjvYlcU3Y6ucNLLLy5kH8TPCv1xLVoY/IS11Hr9tOX
	OrEwfeF+Ws9y8J4wTTaj/nWKPYeSbqvTxgPMEIV+GTsahbhO01fvAK8ORSOlHyWzAENeIHrFnOc
	V6fBDKfAxGnrWYYjTMFPCSbkwCAsX9jHgq3dNTn2lJS53wkQvTvmrlHE5TtGHykZoX0CJQ5NLsh
	NUM9BH8qvB29t5Yjstat743pmTaGwRkRgBm1bD1RJkxNUNQYNz3cJKcL1Mub9PFa0hd7kJ6nz5m
	4dQkjFicoMPFcYKd1cmzT7tBqtQkzhndpMC5BZuUz4RKQM/quVgHgjPPfvgSXOOOdgrtsmonx2F
	x8wZTQxy5Q8xVAqIp0wrf4I=
X-Received: by 2002:a05:600c:c088:b0:4ac:da92:2bd4 with SMTP id 5b1f17b1804b1-4acda922e24mr201283785e9.1.1793707154535;
        Tue, 03 Nov 2026 03:59:14 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a93232f0sm53255815e9.10.2026.11.03.03.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:59:13 -0800 (PST)
Message-ID: <41851e94-640b-418f-bdc9-45db3f9842ad@gmail.com>
Date: Tue, 3 Nov 2026 12:59:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
To: Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>
Cc: osalvador@suse.de, David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
 <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oak56c9w7ic4dy6sprsoq6fi7ipkar5g
X-Rspamd-Queue-Id: E28D640005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793707155-197420
X-HE-Meta: U2FsdGVkX19kuT+7mGRBsaLfcU1FEeifk53FPwT4aNpNumSLhBoLZj/0OK4TdbQ2Dc/4zna5Pnpg5uzuroywhI5M7O6zjxypgnygFPuRv/XYxmIzk7hXYQSOAbW7pu1Yy1oOl7Of7A0M/VUavsKixS/Bt4d1nyHTkoVI4CyN6tX8mN+1VULNcxezkHWjQMArZ6B7YtSNNTHLX4Wg0abS2MAFx0mIMQkgIouACaeZiQUIRiu7QaRfewX+7EbRNyD+ogT3PR4PibTb+/OKR4iLfW7Tx8whV1m5sB4ek2vmuF+I5MEOP+9VKB6z+Fd/s+3g0CrsshCjl17jNZwn/2BAQTsq/P5AKnQv4maocFGLcwXKm55IlZwtaGK9a63vDfdJHS0yuq18/Y3gJilzCqbLsigtDze1YRTqdSICQPhQy7YhKh7zlrJSlL3R/i9bXk8fIN2TcLPamd0lTChdzxCedAsrfzxz5MM6F6b6EmxWyiHFn2TiRouLxN3IJl4ARHQ6S6s1HcmpS/szS9d7I/xc77JeulUENhkXAl7uPFuUk4+ZC0TgltAXTVRKShI8c1D6DozSBDj7HnPXY6hY4dSGH9d8UnD71HJtbVEVNVp6iVze71HxN6BPOCmAOMlF5K69kUUZ4UMVPE6tzGaQh1UriWE9Ly6Gi+Ap1B6AAhmEn5cujOPs0F3iKA/XDI94Wwz84k/vvxus/cZ3FC3mnWCNGVG09dgdPP4MFCXoCRW7eSAcZONsS8LC9M8zUwbHJObyvzpncaC/HaFtNS853NU9PqPH7j3BPj8kLGi6IGISZvd8Ey7KQsNYcsVnChx9R5hxuDAseCR/qOAHqUmhDH+8BhYxElwd5BYWVEHpfgdQ1KvDlGiTY2Yd4nqR5hg8U4qd4gSWomnlyLKzO+/pA8+YrtsZE8nz2Fl0JVWgQUXTkAmQpF87QH3d5urtVl3jgWUjNV7tkcTOk8jg3LFmxJz
 hA66NnJQ
 CZuspX77olm6jP8k67rgXhXeoE/dWSbTBsp5X1JPhfE9oLe9wlafMXkDdWbe/tEDYIbgWuxRIwhuaw3UZNxMnggktbjdDCBu/ZQU8cNGmaEVuNDYU12WYYjf5J48TDEeGt9epFHLlkZTGwD28NQbFme+yMB7Vcf+2OpckT3FPGuxzdJWGVIV4ayAfGYmv2p4CRkvR51PAofbIuEer/lSsDw+h2ZOwV46s4tWmvKPE51Poe9wlzwcRfRUuid2NC+liHK/Dk866UTBf5P8CANIUay6Pxh0ek8Q3qg9UomhyJj9SDpWuIYct9KHnsuIGq7nzO0QmfibX4vj8YHRHyWL8TSaFU0ByDuGw5LC3K1zquobLxIs+G1KjOfO1Nbi4fS3r6B8Y5mMDbN6a+UN5SNkL9JOMmX1+bsHwl8CRHTCt/kGL80IzHeS+bykmaezfuegoTpFjioqJ9uW7KYrUsjJKb3SK49hHOTsMG2X8dZ4mdKimtSk7AhlaKpJw+XZoPoJkdsX1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 11:56 AM, Muchun Song wrote:
> 
> 
>> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> With gigantic overcommit enabled, a fault during long-term pinning
>> can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.
>>
>> The folio must then be migrated before it can be pinned. However,
>> fresh gigantic migration targets are not supported, so pinning fails
>> when the HugeTLB pool has no suitable target, even if the original
>> fault could have allocated pinnable memory outside CMA.
>>
>> Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
>> try the non-CMA fallback, or fail when allocation is restricted to CMA.
> 
> Wait... I think my Acked-by got ahead of me here. :)
> 
> There seems to be a rather odd distinction that GUP is missing.
> 
> The usual reason long-term GUP must migrate a page out of a
> MIGRATE_CMA pageblock is that the page was only borrowed from CMA by the
> normal page allocator.  The corresponding CMA bitmap range is still
> available, so a future CMA allocation relies on being able to migrate
> that page away.  A long-term pin would prevent that.
> 
> However, a HugeTLB folio returned by
> hugetlb_cma_alloc_frozen_folio() is different.  It is the actual CMA
> allocation, not merely a movable page that happens to reside in a
> MIGRATE_CMA pageblock.  Its range has already been marked allocated in
> the hugetlb CMA bitmap.
> 
> Therefore, CMA cannot allocate that range again until the HugeTLB folio
> is freed anyway.  Long-term pinning the folio does not seem to make the
> CMA area any less available than keeping the HugeTLB folio mapped for
> the same amount of time.
> 
> folio_is_longterm_pinnable() currently only sees MIGRATE_CMA and does
> not distinguish these two cases.  In that light, rejecting
> PF_MEMALLOC_PIN in hugetlb_cma_alloc_frozen_folio() looks like working
> around an overly broad GUP classification.  It also means that
> hugetlb_cma_only users will fail the fault, while other users may consume
> a gigantic contiguous range outside the dedicated hugetlb CMA area even
> when that area has free space.
> 
> Would it make more sense to fix the long-term GUP check instead, so that
> an explicitly CMA-allocated HugeTLB folio is considered pinnable, while
> ordinary pages merely borrowed from MIGRATE_CMA pageblocks remain unpinnable?
> 

makes sense to me. with hugetlb_cma_only=1 a 1G FOLL_LONGTERM pin can't
succeed at all today, even on preallocated pages.


-- 
cheers,
jose a. p-a

