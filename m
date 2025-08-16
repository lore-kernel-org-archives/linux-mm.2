Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C840CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E628E0228; Fri, 15 Aug 2025 20:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8668E0008; Fri, 15 Aug 2025 20:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6D08E0228; Fri, 15 Aug 2025 20:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 779BC8E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:36:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF02814031E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:36:09 +0000 (UTC)
X-FDA: 83780753658.18.26C64D3
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id BCDE0C0007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:36:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iMUd6wcP;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755304567;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zFH+Y0FcVX7zqy9EY4F4eO5HqOSc8gM1dWxE+jbUbo=;
	b=n4qsrQbUKa/SBiPhDdXARcBfmHvikhk3La5XyQ2kECH+Gt0v846VkkHEySX0yVk8Dd4i/w
	hdgU8HrNU16CpduxfC+lyS6wUaMbnwLbJPpumwamYJNq3yQnXbbRgeqBAuMJNdkDpb2W7Z
	g5a9nVTVTzxdd+4dMqtgBtgB0E3czZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755304567; a=rsa-sha256;
	cv=none;
	b=crJvVZwjjRW2xaL6Yzqak9uL6j56a6oss3ZjNj5FRQwrHIQCrUG50bJACR8bNWqQEQWfY3
	O1SBuzR9H/ODvcjQVPllaTVgdA9GdVfRQIxCHf4Oj0vokPB2CXQBr8hJLP8Zok8HQCTLVQ
	aXapxDD4Dau9U5hspMwFZac7VxYhIjU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iMUd6wcP;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7a0550cso372990966b.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755304566; x=1755909366; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zFH+Y0FcVX7zqy9EY4F4eO5HqOSc8gM1dWxE+jbUbo=;
        b=iMUd6wcPDGQJ6V3u83/L4yxeQp3BlzorJ2a12p6mhK+LQFIieAJt3WInYDTC6Ze1NX
         VaFW1c9WN08DW6UC/ikoQScpHiYbor+XOlkY+weGKnmat+O5KotRF85dyzlD4HZvF5IT
         Q9Aib5v1fYiGuo1prQ56ry3zxYS3ZP66IQo4Lc4rzL4rir2YGE4THsgFW8JungJDRhV8
         yrigQOybqxt0XJVl5phqAfQNjHbOVKq7uC/XrONpbZqHuzh10b1ZqnNzetn1tsqZfg9+
         j2Bu1I5cU09WUBUqOEe73Aa+jRL3JpgUdbPECkrKM0NWKCdBqoNzQNXt5kio8XiH5+ir
         52zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755304566; x=1755909366;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7zFH+Y0FcVX7zqy9EY4F4eO5HqOSc8gM1dWxE+jbUbo=;
        b=JZ4Jtc6cLKuxZTB/TBF3I2xcD1/ZvBJrH00y14SRrOb93S3E4hIg0egueTubjhNrE0
         yc4AG4yigAd8v2EWUZlfY5pLMycb6DUwGtCqlyAp36iR7yb1EJZS4lKsHIihmk3tn/Ff
         ynwddvBy0ji8UinqnQ4VIWjNuGqFgEhFQPRqz5xpCHVrsQW578U6gmGKPxKaAdDvVO50
         emKMWGGaeL1HZyTui1RRPwu45ay6JHIiX2HfeQqTNMgLuZl4US4mbOL7fnuc1aVUmAtF
         KBjr2cifplaiVZbq7HCt4VIL3r6R/W2pBHMHj4i3EazwMi/hZft9Y7xgnrX9dZZJAlz9
         /TtA==
X-Forwarded-Encrypted: i=1; AJvYcCUGa7o1+GaCYRDiM9zXR5FMRl6v/tXj02bZ2tv575Q0qjaXk9AYnRafaUZuXJ3A1LPmnN4nrA3p5A==@kvack.org
X-Gm-Message-State: AOJu0YxuNWm1SqczuOfBBeTh70wwsCuZ1xZORgMYxPlbgUF663kaHmZM
	VDMQet+xZ+Nh9c0SEyvXBIVTY+ydXv+RP5caAEO7PDijywD1aMPN3seQ
X-Gm-Gg: ASbGncvLUBp7j8OkYMlPjeqQup4Fyha/qGB6BgqIRnNYMohkw556gBAiNlHK/GGt4yp
	pcykAc3STlXceZcmcT6/F4kDJb3IM0ElIoJA+S7+k0cZ59s/jHRPwTMq/f9uJV6nf/iWWhnX2pV
	5SLEH9jGYTrU56h18YJJZ5lPruWK7kWPo69lBgRwjIAsKNzxM8hLLkTETo8jQT51uQNKlIAqQVj
	vJqlKp1+yppmdLL9LcV83JLUIXqcxXuyvsScOtLzc8R90b/30tu6xQH+WWblfQOkoj/u2W1K8vd
	cjo9wKBGaAlRyKsiFwIsP+vwKFSh5kOC/PJskXUxNiQUBLAtbttZdJXd+NfKIPxoUuUbOHbyn3e
	880C4HLDY6EkTkrj51VQAtg==
X-Google-Smtp-Source: AGHT+IHb88CZJ51sP3swnuaG9CbLttwdPbdH6DCN85qc1c0hpqAZ1e1FYe8W8pmEBvoHXyZPQo4L9Q==
X-Received: by 2002:a05:6402:430d:b0:615:5cc1:3453 with SMTP id 4fb4d7f45d1cf-618b0514024mr2725180a12.9.1755304566265;
        Fri, 15 Aug 2025 17:36:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618af9e042fsm2279534a12.27.2025.08.15.17.36.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Aug 2025 17:36:05 -0700 (PDT)
Date: Sat, 16 Aug 2025 00:36:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, riel@surriel.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm/rmap: small cleanup for __folio_remove_rmap()
Message-ID: <20250816003603.agl5ixvcfjqen4el@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <d9da4b04-7537-421e-b712-5e694056893a@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9da4b04-7537-421e-b712-5e694056893a@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCDE0C0007
X-Stat-Signature: goazrnzra1rtkbpequ7w13gx8zumedx9
X-HE-Tag: 1755304567-25048
X-HE-Meta: U2FsdGVkX19mmD1ekNuwFOy3uwdoonYGk7F/Y5e08oItuhklodPwdbjMKlZI5iu4v/bIyLJOOZ8jZpsNMMiRasvj10zw0U+gEdyJF4nr4OYmTAfXawyEQtDWLGJcmESuVQchaIjR050vYEshv0XdV/L/6CrxENnTVJ4OZ/fLTz/i+lqVjz9P9HAfxDcwIm9y0VeBSIsL/Z9z4jkdbQnvUNgux8hLg09XCpAjnOaS83v4kiJN1ozm9jJWKFkwy1kzQj/k8JnkDzRQ25TzcL2wi41jcTilXxKWHNTouaGu5xISzFiyId9T2Tp9eXA4ajNiWxVTuvv7wePiaBnw5xBHLA+troEe3277cQUzJGbVeNHJKG2ae4qUvlvbv7I8gHs1FbaqQsHwNvBmFreSZnR+yGpL+nIOrMyhP+KaOApZ08N6rIx0EEWwiDDq5OelPxP2V0hkDjx64UA4gXrqdDu9m6jaFvVM/qiRyJMKM280omIsS1S65QZt/Xwlxe1Ojt6bN7yfeAP3bji/2d5B4OZ/cdvRMWpQR+n3aVO8YJdnMluGVk2IZKfBpfY7j6VUr8cqipqUYqDpv71wjn2cpJkAD/T0NI+hNxGOnW9yoD/jDDN+Zk5qeBrRKGpb3h0xsvTAmmhYMdzg3okHYpMxgA39NEgDaAOKA+eN190p+V5aK3DFZ2bV1VRjIGBci20tF8gccJpx2h5KfXdYGIBqNyTFANuL/ZgYki5nqitLNinCQjSJ9K+2+/jFnBMUu6tllSs0TGtlTsXSilEZHGNStZd7QTqCrBB8rwlX+1NKq1GQgRv40qgaU7J8jwVEqt10lrkF358IaD2a7yxS4rFVxK0AUvMRAp4vRVPdfGT0WX7Ms74H6qSVp1FiNFe0R3a+Lvf54N4nztUqPzyDwVATIV6LBXmaibZAV+5xEHWdDQq227jIlmgYdk5sb6ChWAyLVkrM0GN/FUNSfojq0SO1QPR
 ZOf3zlsy
 21bFp1qt/ojZuUSGU8ACwoaH7It3PAVi2aDotlokH0ABIA1QaxVaSbUyslVciwk3wS28QmYjNnxObkMWXHR/GJpsZMWk3AGR6znAy0YZrlPM7fcnFalu53Cu07pLoa8zpBXKbiTwVSa1kCwpBcw958P3IotISJSuhfgw4CtpPx5rgUEkgnOgOwhQiJmjNbcGX2WIKu5MTX4t/qhnn03uHVSr0KljM/xcjBiTnf1tPHVOcMAhTBIVQBQ2cYE8Z4CKFamSDr7FSxa7KzocxnmI9JhIt+Ka+PrlFOetTjoL5o7t20ks03qoBFhg6KFmER2jeCYpeZRH9Vk+5julTgi5oBfnH5In3DntB9dZPHPJ5Irj1gInG2gh2+vmxGaCHDFJJbTA/MHVZwsxC7RHILCRQxrhI8GaKoip4+twGP1NI9dB3tLU28GECppPmLfm04jNgPEbYIoN98oaZdghSx3FSTkH1kz7lUQ1oPpoNQLcbEZ1iEFheJ0w58hSmuypWYTgY6O8wdJ/xAlyjx1M7ElljClecoh4j5CdHMYSUMsD3LPbo43Xcost3xOwLBADph5EsJT4TWaM5FIXkpOIkkNiEPR1RbA/te/oG5303p8/41AUfKWK90eXUp52wS0UPR7tAtik6yyq+KyV2kmqEAD1Btm5eoiSyizL1okLp5KUpx1iEbAYWzLwmO2JpCCRVQL2AKHmtxYMsWCCRDZx4H4PH79NY7eQIJykgB3WERqMsbNYka9cDBMLELvGOGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:11:24AM +0100, Lorenzo Stoakes wrote:
>On Fri, Aug 15, 2025 at 08:49:40AM +0000, Wei Yang wrote:
>> During code reading, I found some small places where we can improve based on
>> the knowledge we already have.
>>
>> For example, since base folio is handled in another branch, we case use
>> folio_large_nr_pages() to get the number directly.
>
>I think this cover letter is pretty weak, please describe what you are
>doing clearly and why.
>

Will adjust it.

>>
>> Hope I don't mess it up.
>
>Please don't put this kind of thing in the cover letter, it gets reproduced
>into the actual commit messages and this isn't useful for people reading
>through commit messages.
>

Sure.


-- 
Wei Yang
Help you, Help me

