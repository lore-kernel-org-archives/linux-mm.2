Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C7FC47BDC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A016B008A; Tue,  6 Jan 2026 04:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771BA6B0093; Tue,  6 Jan 2026 04:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6675B6B0095; Tue,  6 Jan 2026 04:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D536B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:54:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D6061AA1B0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:54:18 +0000 (UTC)
X-FDA: 84301078596.09.F2029EA
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3168A100006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:54:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RX22CWfu;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767693256;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0eyoLBOuPdC8ApqYm/uvXjk9GHrnSsW/3To+GTw9X0=;
	b=Lej9v6gEFy/Fq+WXd8a/4HJhluwlp+V+7Ae/ap2bLZj+7VCstYNm0bFOek9PCpwRgSe2FS
	47STy5jqm/Hu5bF8iItJw+3koO0rFCbgB8S2PILsvZ7SAC28yqqzX8citdys7Bly7nAiZ6
	YpLl9ay2ovFoy0DE4MzhMqh2f16BLCo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RX22CWfu;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767693256; a=rsa-sha256;
	cv=none;
	b=Fbk7Mtu69NCEFF38idUV7YuqQ1Guor84O9irpg33uBIYw14Dk0sDZrO17B9ge2I3DZJYvV
	bueoDZlMq3h0AFSO58Igrv2ajYqpBuJ2wUKQJVwNCWarC1KwyxqZ8HMYpM9DkTfGfvkBRs
	EVLDN2jL/ajBVhoS3BI39dxd9YMsAqs=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b921d9e67so1249432a12.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 01:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767693254; x=1768298054; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0eyoLBOuPdC8ApqYm/uvXjk9GHrnSsW/3To+GTw9X0=;
        b=RX22CWfuSp8xD4BgXXKXVP2SC5da7sEWB/xnLASpoygwTxg5ZAy6+6Y4XbJzTrORvD
         dzS5J8FpsjGOy6gLTJYmpAXHaStI8iqVYvzc71xegygTq3s1QTbrz6w9lYYM6xcGBPM8
         dkwaC047BkiPxKm279d3pVNGOgHnPjlV3LYG+pT7kfSIYdwlbptHmKWsrstWU2fmfjzo
         gr5CSryWwbcSUHKtzdsArOOi58c1hjHMW1qZBfVXe9xUXNlOcuaco/r3kcyF+u1hu6o3
         5gbllgDMxVmZ63aCPwLlu1AQkrpQ+dZPMMM4WNkVgZtwBT/n6ap7+0yGIA7BytO7whXb
         DQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767693254; x=1768298054;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0eyoLBOuPdC8ApqYm/uvXjk9GHrnSsW/3To+GTw9X0=;
        b=UXhsTexz75Yscrs11fmlY1TVY8EjksQnvyTBts8WMYJvZxytoljW8L5yt2mg3kjZ/I
         VrXZdDBdhnAAaTPT+prb3R9suyg3ewQazE+MXPTU6DLOqokAtNAUB97c7eDhzyUtZE/d
         MDtoDTU4MR6YIFYjBnMGrEUWPBuNiOrJfW5GGmeSKuBIK88HzIME3KH5movzJSWR+6Gv
         vYEaFAnuntYzuCTzszTMsYS4+BbGceYHZjr+ClZJBctDGGjPmLL7PpINWH1lDXN2ra9z
         mKUhD7/J1oPujDtjubiU4DZO00XObOXRvnPjfLWo11RJlFl1P/mOjRaLpBNlVgbFfDTc
         bICQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLHvk4BrhPd290XP2mzrVzGKy5Fi6gSbxp/NeObfLq4GOyfUYHyvGH5DjsGWIUDs/KmSZxZeHEmw==@kvack.org
X-Gm-Message-State: AOJu0Yx94lf8XzUfS1cRHtpJtZai4cQdAvsAOzjSlu/j/U1OBrv3QV2D
	NYnvFmwDjqUxKlfxcK98Ks1TLmjzqPsg+MHw2xSjHUMO7ZPhD4lso/o9
X-Gm-Gg: AY/fxX7SMJc8qoRuw6OXHLPvWrrtHJrrlYZU7OEHL/l1e3IMxeB1eJz1KypfkIMA0OB
	+YekRo/vRRnUxTCL5LzlB4gc5MOuf2kGy1iUb/AglagLMo81oXl3n7BmhAA/Fg2+17XpGe0PqZ4
	9Bh45ADubEekR8yvBS/KcKrVnqhSGbRxT0OuUT3y+VgjcppruxfOHL3y91LPKWsx4XWqYPs7mhi
	Ztqb7ebpwb9M+D5vvuCUrxmLriLBNtDXkZEZOwW5OyfDrFBWdOPzMdiD0gAYJByP1cqPK06Anjp
	HJCcGkOIMjZVVtf/LuPMAx6LBwfPEp+rMMx5towzf255hH+E5ooACi/4X5srTtMvGDujTwB44lg
	wSHp/3gCDELpFTvQqgsMYuqYdlm8uIO43w1Jfp/ZOISAUyrh53fZVBrCB6boGIO3mbD2nrTgXv4
	rQlYlexUBNgg==
X-Google-Smtp-Source: AGHT+IG5JmLS3+ADHiEERF62cScjto4uOMG+vc1/H968gXrQDGX4tHaLpkbx2/1sQCUJAR8utHToyA==
X-Received: by 2002:a17:907:983:b0:b7a:1bde:a01a with SMTP id a640c23a62f3a-b8426c3e8d4mr242565166b.62.1767693254294;
        Tue, 06 Jan 2026 01:54:14 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a234000sm190563266b.4.2026.01.06.01.54.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 01:54:13 -0800 (PST)
Date: Tue, 6 Jan 2026 09:54:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
Message-ID: <20260106095413.aqkrh4byh32qltli@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
 <20260104023756.jufklyl3bl64fnck@master>
 <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Stat-Signature: 81pcq4ajzxidorr83tc8ihqjm3w88hqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 3168A100006
X-HE-Tag: 1767693255-124878
X-HE-Meta: U2FsdGVkX18kHRZJuFy1Un1xfjT+RLSoPeUPP6tk+J2pc7ouv5ZSeG5y9HZQjc40S5NlW6R/GLgju40/+1hcUkgCZZg9YVI8DuxkU+zDIX7sJXui8cBBvrlIpgqkq3ko00TT5hiR+ra8qs+O3X92bTkbMxW0/F+qu9mSNjzoswUU2MiTFET1t/XINOxs7pteTlYVj2wIZLQO0rIPBgjTpOG8uL4pHn63puFd14x1EaAo/wbvgWwIDYJIbIIGAnbLVSnKIr8/ZfsDykghYLlVTlGoMM2uDVuYxv5oC547SrAaZyQq9avLa84FpcGgXLoi2NXJR1TOHQW1B6j/IXFxP7JuPp8dc7cIJNwzY2lNoE/28Nf+um2bTvOvlkOJcDIjKfbVFQZRzVGSro2LaAjcxC4mTlWLmzyerFLXGWMD04DNlaDGgbJ2Y2iSS2slKOxu5nPANPR6ckQVJ/+JWCvBTYdD0PWXuPBHRevBev2EyzeCoPwxCZ+eMu28+2YmI6yCKKeQaVzsm7KxB+8a1INc/qYIOP/GMSs3igwN1nqYql8jP8ksCTtcCvh74XtR+Rg7YtIY8GAelExhwa3iMCISPVBZVFzPgvDMeK2mlW2UWS0Tiv/VanjDnWgpXdO5mcbopO8oRihE7RYU3yuouvUKuXkELLgoZtUpi24fE09Xjsx2K+0MId8IEGJvDmeUvxcXgpjZKgq8cWHE3db2viCl/FcWkkXLaKOQwVkouy4el8QsfRizfJRXoeXYSHkEGyP2peVWuRBW8g8qqh3qtBqi8CCEG9h+KwilBCnRZTQqA7Zy+nutFnubKKcVoYPuENLtXdGexlTAHMWjwH8WAq7z7tV7tn4YAg1UJG6ypi/dtfsWnIZbjqorkocUanb7QxwTdOpF5crEp03bAjrj2jMR1Ra5kLj6F7XdlGwCjqTk3RdxQz4NnOyHF+Cckz1Ecqo8sVLe4teuad99j3QZaTZ
 cZIqe/Nf
 EPoRUAbcYsW3/rMX3H3/1JLaabg4qE6UCXJxWCw0d5ljwEYtLCEOiiU8H4TbKViqwOYDDLYTcC5yUbRofiuyawLEqE9DQLdsZbZzBUOj0Nu4TvuGKPlujmZKgbrkLALBespboBMYWVjQh0ONNzBjKJpKhwzjjigSjV4MneQsSkpOuyizOoK90OQ34UM7MFO18JEOxaQYm4wwK2TaLck9D21OhgS3y4hz3dxfERY4LhKXwsXioHv0d8ffFPQJeSZYHx+8/6WVG5hnrdydtXUIOU0nhg8PT1pT+rx4E7G983zNAc4h6qMN9orR3mAmSZ6HNw1hhFhSBxz3LfHe1A4ZRwz8jjhAEuDNAhnspPRRSzqFR8lXC1/aa5BNql8ir1OzxEzjgPRf0/P5b12tky4E9JuF1rKWuity00L3d5FY1QNcknrX1TZWtEXl7HLRkDNLegKAzG0JMB62XY+hocUhQMJkVYdYulrR4sMAiGvqm/4dfNOdB38tYNX4SmLJj5PDcS1mPl5dJ+acbMCAk6M/BwwAuO1y0IaKGsIkNNzg0T5RB/FexQHdHjxSTE2B7gOOOi48hrtAqmCSK1I9KOFL+o8IancvoPEXLLJvkOH+AUnnw3D/FBNZotKrBIxN93P0HlyQt33ulwUHpPBovixQpaHEPmb/otr4f6iAKJLvuGhn8/HgBv7JM78WGdf7qn6IaoHD0872V7mKv9his3DvU6ed2y+BL3v3asrSISzrbwJIN9g+7L2XT56T+7gFmF7eKarf1vB1c6d25oGTw3ymbVX3OAOIxxxy2iV363Zkw0y3mh8QP2t1lqx50lqeFwyCFZWWpjQYc/B7KzxQbSSau0gl9JM8VUg0I0bcfK24y/uIxzus7Sc6kOnFlwcJLehn0IKmCGN50j8ZmU97X383xYsMtQEyu+YzynaAp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:16:45PM +0100, David Hildenbrand (Red Hat) wrote:
>On 1/4/26 03:37, Wei Yang wrote:
>> On Tue, Dec 23, 2025 at 12:25:39PM +0000, Wei Yang wrote:
>> > The primary goal of the folio_check_splittable() function is to validate
>> > whether a folio is suitable for splitting and to bail out early if it is
>> > not.
>> > 
>> > Currently, some order-related checks are scattered throughout the
>> > calling code rather than being centralized in folio_check_splittable().
>> > 
>> > This commit moves all remaining order-related validation logic into
>> > folio_check_splittable(). This consolidation ensures that the function
>> > serves its intended purpose as a single point of failure and improves
>> > the clarity and maintainability of the surrounding code.
>> > 
>> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > Cc: Zi Yan <ziy@nvidia.com>
>> > 
>> > ---
>> [...]
>> > @@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>> > 		/* order-1 is not supported for anonymous THP. */
>> > 		if (new_order == 1)
>> > 			return -EINVAL;
>> > -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> > -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> > -		    !mapping_large_folio_support(folio->mapping)) {
>> > -			/*
>> > -			 * We can always split a folio down to a single page
>> > -			 * (new_order == 0) uniformly.
>> > -			 *
>> > -			 * For any other scenario
>> > -			 *   a) uniform split targeting a large folio
>> > -			 *      (new_order > 0)
>> > -			 *   b) any non-uniform split
>> > -			 * we must confirm that the file system supports large
>> > -			 * folios.
>> > -			 *
>> > -			 * Note that we might still have THPs in such
>> > -			 * mappings, which is created from khugepaged when
>> > -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> > -			 * case, the mapping does not actually support large
>> > -			 * folios properly.
>> > -			 */
>> > -			return -EINVAL;
>> > +	} else {
>> > +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> > +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> > +			    !mapping_large_folio_support(folio->mapping)) {
>> > +				/*
>> > +				 * We can always split a folio down to a
>> > +				 * single page (new_order == 0) uniformly.
>> > +				 *
>> > +				 * For any other scenario
>> > +				 *   a) uniform split targeting a large folio
>> > +				 *      (new_order > 0)
>> > +				 *   b) any non-uniform split
>> > +				 * we must confirm that the file system
>> > +				 * supports large folios.
>> > +				 *
>> > +				 * Note that we might still have THPs in such
>> > +				 * mappings, which is created from khugepaged
>> > +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>> > +				 * enabled. But in that case, the mapping does
>> > +				 * not actually support large folios properly.
>> > +				 */
>> > +				return -EINVAL;
>> > +			}
>> > 		}
>> 
>> Hi, Happy New Year to all :-)
>
>Happy new year to you, too!
>
>There was an offlist discussion about some of the text below, because a
>couple of people wondered whether it was an LLM-generated reply, and whether
>it is even worth the time to read.
>
>So I am curious, did you end up using an LLM to compose this reply, and if
>so, to which degree? Only to improve your writing or also to come up with an
>analysis, code etc?
>

The first three paragraph of the mail is polished by LLM, since once upon a
time Andrew suggested me to use LLM to refine my text.

Others, including the code change is not LLM-generated.

>Feel free to use an LLM to improve your writing, analysis etc. Just a note
>that nobody here is interested in getting LLM-slopped, so don't send
>unfiltered/unchecked LLM output to the list.
>
>In general, I think it was raised already in the past, please don't send
>patches for code you don't fully understand. It consumes quite some bandwidth
>for us reviewers/maintainers here and it just gets very likely to break
>things by accident.
>
>The comment change suggestion below does not make any sense to fix a warning
>we trigger. If an LLM wrote it, you should never have sent it. If you wrote
>it, you should have invested more time to understand the problem and come up
>with a reasonable solution ... or not worked on it in the first place if you
>don't understand the details.
>
>
>To the issue at hand: Zi Yan pointed this very thing out in v1 [1], no?
>

Hmm.. this is not the same thing.

Actually before sending v2, I have talked with Zi Yan off-list and he said it
looks good.

But after triggering the warning, I re-read the history and found the logic is
correct but comment is misleading. And current upstream don't report the
warning if we want to split folio uniformly to 0 when the folio doesn't
support.

Or more worse, we should split to 0, but we didn't.

Thanks for your patience on taking a look.

>The patch as is cannot work: we cannot return -EINVAL for something that is
>not supposed to trigger a warning.
>
>[1] https://lore.kernel.org/linux-mm/01FABE3A-AD4E-4A09-B971-C89503A848DF@nvidia.com/
>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

