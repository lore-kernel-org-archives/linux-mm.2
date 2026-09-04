Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F7CC61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFD56B008A; Thu,  3 Sep 2026 22:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61506B008C; Thu,  3 Sep 2026 22:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950B56B0092; Thu,  3 Sep 2026 22:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA056B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:02:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5F07C06FD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:02:34 +0000 (UTC)
X-FDA: 85174430628.14.E96141C
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id DC4D9180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:02:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Axj149WK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788487352;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhTHYmKHEO3PH5BDNgKld+lAussDPjnOrykc+7iGYw8=;
	b=omqIU1Ed9VRCEUQWlM9imSMeBMQ+7ubk+/Jc0YK5mDCm5Y+MPFMNVFqa/CpiYi8M4t5NkW
	bEl1sXIDkVhxpRqwNhbi/IYEt8i0tWJqSw2mIMjhyQHh1H3s7iWg6EIRSZ/OS0yEucclP8
	349j45mUX+92FoAAxYAGhTzCk4IQD94=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Axj149WK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788487352;
	b=x1j2utThEL7nUAWoIb4Pv7SLDgYofFBsR75c1hf4N8DKy91sqC5mwISIntUhXRYeRBGc+M
	CsPz3DEOjsxtInXkNASnADzKzbYMMsVmy01WhQQhL2OAOwoygQ1bGOr+7s8SKN+qpJRtAT
	8n19Iyj7YmMDaKYiZ1AP7JFQ1AQLh6s=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b96837ca3so3191185e9.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 19:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788487351; x=1789092151; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hhTHYmKHEO3PH5BDNgKld+lAussDPjnOrykc+7iGYw8=;
        b=Axj149WK9chbqkELbCNVHeAIb/s1qvNt7/u/VVujNWCHv9OTmVmXWeMMFiV2mp8lX1
         XtEZhNRU1jekoAeMYs7yAqrQiEevTkZfgoC0kbjTxH+QXhAh7NjA4Gi5yJivs9BQ2t8Y
         mWvPHSnVddXVHSIq+PCZDFeW+bEzX8W3IcnX0EHHxXXKwZD5a5FuWVrcdp4NWicveQ3a
         q4BwZg5Km0oGGtesNcBfNu19a28sxIlQ057QZosCgUmdEgk7sGXFmv3AUJW25rqzWCQA
         iEIPt/7IJ7vRgqCMP4XONdp3uG7f7MMJ6ss99woqa6Eu6+bowEzxStG5Cn+pAFW5oP2s
         CS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788487351; x=1789092151;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hhTHYmKHEO3PH5BDNgKld+lAussDPjnOrykc+7iGYw8=;
        b=T49hUkajeJ75LERwlHovnZ5dgTSCDAu7WqtT/h8S7KFbGq+bE9OcJRATEArJZHZTMs
         wiD6eHx66Bzgrv1FBuh2RjJn3Bnr4MJmDnquJoufxSvZQc7IFayxEo028n4w5A6kvLZT
         TlYlTfxMkmy64doGIO0ZnLB3fbkqytU8KqYiuuifKLCsWf0APJwykDbOL88vVPKv/dFS
         KK+uFoZoNszxHRb5zTLazsUHHUtH6NDfDKb5cswO1GHMkWsoioALwKRpS4oHOyg09XzY
         uaydgb5bknahM/Rrud4kax0Bcs805zGEdSbwJ4hSNKYadc8CkHXAIHDt1ilN50XWShQQ
         m7DQ==
X-Forwarded-Encrypted: i=1; AKwUvBwaBxaN1PI5K97TriukBOy5+db17iTmfC09Js8O4d3d8uuCI3OkcS9a3x/XaM2T4Wg59ezw+L1QEg==@kvack.org
X-Gm-Message-State: AFuF++lzMVMmddeVSv/QEYxEJ5+NeVZhzxgUD1x4HaSEPdRVZNgX8TiT
	KToV7JRG82EsspfwQ5qtQY1a36yuLJt2mf7pI6mNtBvL9aFWtc0h2Vt7
X-Gm-Gg: AYBFou3hS8YokB5cs57SL+MFxvblThFeZGJVbn4xDQLXUnIIiJ9+EHBbb9NUiadGVJK
	b/myebk/jm8Kjec23P5UhcQ/EwPekVzsUYR291PACo+lHYCWhhR5YYex++YyDtaBL0fRPBm6DXT
	4kD/WtE8Nqquv0pVplBUkSGN3YkYNtEHEtHdH/BFIsEAQYt+F68nnk7z8RajVZSpSOlGy5eMf/C
	3VPI2aYI81yd1goryzbyu7iSX/KGAt/QhvqhOT5PKV+o0HsY6UmJYF2ixYIGS2/ydy2tkx1OA8p
	pYQQ1pJXC4O6+P6mi+ssW21Cy4ifcxRIHSRlPnpgQVP+SsVBVArGdHmvXNA2i9SmLp7XoKEDDZP
	b8A+/OL3gFHiwvWNnmiVfrLuHA6mi2n2/3VhQXU7zWG/jhLy+3kvRoLqkjuVup/b4PzHeKCYdXw
	lAu9PoJ5hKDRM/9tySNax4q0CUjwosqVRrfEAJP1tGIkqZRcaDIT6/WvFejTE=
X-Received: by 2002:a05:600c:1549:b0:499:a5fc:2087 with SMTP id 5b1f17b1804b1-49cf81f47e6mr30791955e9.6.1788487351136;
        Thu, 03 Sep 2026 19:02:31 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm115941975e9.4.2026.09.03.19.02.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Sep 2026 19:02:30 -0700 (PDT)
Date: Fri, 4 Sep 2026 02:02:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org, ljs@kernel.org,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, willy@infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lance.yang@linux.dev, Kiryl Shutsemau <kas@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20260904020229.etsxwqw74ug7c7hs@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <20260902200220.408ae7e8a28d3af4e82fd060@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902200220.408ae7e8a28d3af4e82fd060@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: axugk6dpqkkggot5idw5apmr9boipojq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC4D9180003
X-Rspam-User: 
X-HE-Tag: 1788487352-154997
X-HE-Meta: U2FsdGVkX1+MBKxjALE81hlZISY97uKpJfHnwN09WZLXruBjuD8VhnFGysGDeYL9sILS5zUO8E3K7mDX4AtOxOVJ5phZK+q/zIjWKdRyqkVo9fYpr6m1aBKSJ6lDG2T2oAlkQE7EnHZCQp336Jam3z27l6HRT9nT9P3PW6aVwhc+1sX2VN2X3L6gLJ6JxEEkZxnBAYZaKdSXOPwUJL+qfUikX6/vo+xSJzsQgr4+Sz8VT56k6rD981vWWqPwMh52hGMftl8td90pTkJAY8xwOTzu0kqDojsmQqzqYkitsao+9XRX3mMQWFg4h/tGik+gJz/7cN7Crt+Fe9KTQQ8ubCKdONZym8VK3U2Atq53qQeiVO/6NxA7WruiXtt5u2iUrusfqqKdbis9Y2uDCVHCvkD6O0SLYEtzzkJRrjeb3iIfsnbTNNUGeRA01BY2nlmIwYR+rb9G/0Oa20UfYuq5HjbDxgZPJB8+UAPhjrQcoASrATd/KiQF/39/VSbrtBjPcWmWfOFrgCJ+ZFtNM6LHpQadjeiOJUcG6JFAqiKYABMgv5MKxq6unV22OSy4sDA6sUurLLz9K4v8+SE1VRqgnVx/asB0w0uf95IicVvewo/O8kvb5HywSuhOaYsy+psmoQHY8J6biHFF9TvIlTOBnlpNXlGME8d5c2KyJOzBfAKgHQs1MYTokqdEGQOyrTICQDFewVhb7ztYtk5VJUk86yLlQPAL6izTWY/Q2iEQgS48XloPrKs/hHLODouyvSmZoIfgQqoOew2DLpiSS15ulfscDF34XVN1uZWRnyPi9sxZiME4E0HCTib4ANtLCEs6C1PyWD/bFqF9TtNYS+G6gKNAYdoCmJYPMohtlLafWQEQejOLwxRJ5wLzzDI5NswLcXon7oPrVTBBWCyqv2lNFjJPnc3eoYDvOduWiNLQyJDpGkfNuzFOS9YNy9a3uuGjUpkmB+p4ApSdhppYBW+
 MozxxAK8
 /KVbAy1gv7yMKmkSvOmMvpvEUidestwcw7S4nfUoyDIuKqrgTvAZDmdDieggYMS9d3hEN8JtdxhO8ImHLnsVTldVWJdk+61a666hvdOfCY7jPC35yD+ZIo8fJA3fX17JTGkQrHvY4w87OdA57eWfNEGdJAKG2oSij1xDT9WF8B8AKUDWPNAEgRPhGjx9WaGhZ6rlbT8puoWJbczXvUZj0ajV6EIIgaYpK0bgL1Gh8v3E2J0tME9KXXjRu8LlSq2hiUluWhYb5frH2DvwvSAvoKagTMTTPaXOBs2nRmMTamjUkomhV0VPh6grWVAutWIxEg9dWZjI1dSw5FXseMolfxIYxURoqQDLhU/f8CN7ZdcXsuriPTlOqFmVw7/vibAOxyl+4nmY14FM6EwT6hXv3TuTZOW8jV7aDyJ2+qvtRXELAHIy4WZVg8VpX8Lic/U109ODacYXXM3odlAB+I/0hXNLo1Uak+KFIYPTe+Ec38f23/M/lIl0J8X4lYCgHWoS2ClwmKthHAtgjyMPMA4iCqdqi7PDGJpjCtw+c0xkS8kqcm++LhL7D55P5mIkU5DLjhcmB77OkHa+EDPTNR5maXIGRkgFCOBGs2eMwayMn0tsz2jC9v70IMu0aWCBWEjT7494b5UOnhmqgHOJqPH1wm/0URuNnM3/B6wMHShofkBdJ0+SQd8SvgkBX3Ny9CmdbrVoXCb0aqiUgMX2IZCzdMbWRzD4qZvI+xrU1cRm9YcjtnOfps9dvQqq6m/AeiPkmyBTT2kjJ2hHujJwA+e4u8+TIdorQ8O8sZmraFK7Ru2a3ngTXfqn1RLKiZl/l9+Ygq/m+IccA8L0KQ1/brQeHZ0iTG8pOdH3YBzJA1twDAEcfrbe36xEnFmTx/IYxGXMsXTtC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 08:02:20PM -0700, Andrew Morton wrote:
>On Wed, 24 Jun 2026 08:23:59 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> The kernel test robot reported a build failure on the parisc architecture
>> when expanding HPAGE_PMD_NR in check_pmd().
>> 
>>    mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
>>      if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>>                 ^~~~~~~~~~~~
>> 
>> The config [1] in report link shows neither TRANSPARENT_HUGEPAGE nor
>> HUGETLB_PAGE is defined. Then trigger the BUILD_BUG.
>> 
>> Fix it by define check_pmd() under CONFIG_TRANSPARENT_HUGEPAGE.
>> 
>> [1]: https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config
>> 
>> Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
>>
>> ...
>>
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -136,6 +136,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>  	return true;
>>  }
>>  
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  /* Returns true if the two ranges overlap.  Careful to not overflow. */
>>  static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>  {
>> @@ -145,6 +146,12 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>  		return false;
>>  	return true;
>>  }
>> +#else
>> +static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>> +{
>> +	return false;
>> +}
>> +#endif
>>  
>>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
>>  {
>
>lgtm, thanks.
>
>You provoked Sashiko into talking about memory corruption and kernel
>panics in page_vma_mapped.c.  Usual stuff.
>
>	https://sashiko.dev/#/patchset/20260624082359.2869-1-richard.weiyang@gmail.com
>

Hi, Andrew

IIUC, the issue reported by Sashiko is fixed by 

  commit f84ca9b1888d ("mm/page_vma_mapped: fix device-private PMD handling")

>I'll cc likely suspects but boy do we need a way of being more
>organized about this.

The build error fixed here is introduced by v3 [1], in which check_pmd() is
invoked outside a conditional "if".

Then v4 [2] and v5 [3] call check_pmd() in a conditional "if" and at last
David fix this with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).

Do you suggest still conditionally define check_pmd()? I may not follow your
point.

Have a good day.

[1]: https://lore.kernel.org/all/20260622130651.23359-1-richard.weiyang@gmail.com/
[2]: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u
[3]: https://lore.kernel.org/linux-mm/20260630021540.17297-1-richard.weiyang@gmail.com/

-- 
Wei Yang
Help you, Help me

