Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504D1C87FCA
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 02:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45C06B008A; Fri,  1 Aug 2025 22:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6976B008C; Fri,  1 Aug 2025 22:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5B26B0092; Fri,  1 Aug 2025 22:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E71A6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:33:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B614590BF
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 02:33:58 +0000 (UTC)
X-FDA: 83730247356.22.534A149
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 38A78180004
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 02:33:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8PVETmB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754102036; a=rsa-sha256;
	cv=none;
	b=XTLWgoAyGGkCuqlSaEc6GRTHvW17eshjKoQJSSkbt+OKXYpOOKkDd4sSc/pweJPIs4TAyo
	No//nRe4juu9F8O7xFIb88EhLglJeBMQBiiAlYSvc2c0jT3xZ+Y1AgO4n9eRH4ewtfkB/B
	6xmO16TKlemjq3RYFQXEEM8aAHpHwUU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8PVETmB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754102036;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5hSBiZ/cKqJM58oRIaionb2Z3usqZlXR2SNTwitsQU=;
	b=H0UQ51pY6DXclRgWf2LCguFhJnbwcOk58QXiv/4w6ui9BXMdd/J3kD9bILZX372B9oH4+6
	Yz4CEDy2FjaxkZNnbm2TsmE9riRlHri0cCg1/vezUAbyr2qUjLO1WIpMWjuC4JuhvloqqM
	BVoIwHrg6NVntPVWnMaxtxDQ0O0K4Z8=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-615c29fc31eso3769077a12.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 19:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754102035; x=1754706835; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5hSBiZ/cKqJM58oRIaionb2Z3usqZlXR2SNTwitsQU=;
        b=N8PVETmBw5Aw14B1t5atBI+CF/QcgfX80gVRuFxljdl30Gz2YxalsxLT5l6371sLr6
         24ohntpqJcZoB2i3F1MSntT3rtVsqyqUsC0PVmjbRcBopdiUsdGDTR60fjtCSr2Vozq2
         VCEhzpenNMnPa36ZC10VI2t8LwlHZS0XDcuCTUq7RcWxpCI747Q0qp3xioxuNAfDHp5E
         vk/u7cD20wL69r4gZEc4bEfHE8lOlhOUItzbBZiiNrk8xyWBKFcKlJ4rhXfbxhE8l1BQ
         8bdnt3VTuz80PHH200CneQQ1Z2TTDFeTv81tY+6zs63XxyqJP3vW056vJz6W8qCjM0un
         WwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754102035; x=1754706835;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r5hSBiZ/cKqJM58oRIaionb2Z3usqZlXR2SNTwitsQU=;
        b=KMV55O2HzGD1b8cZzR22mifMfOZx5XS+DRr5B6bDB1NhPv6zCIEZa7W7C4WM679WRN
         VbF0wY4KtCZHNYw3c/7IJU/nxDOLPb/NX5kKFoBWg5HSJ2G3jvNw/PxklZg/4o9dTTfy
         FfmJC318o+i3c73OrC1qTY7Wh/LXTROxycfynYEnUr5tDaMrbedji1Yed8QUWjW5CrC/
         gHaRAylFB0iyWVcQmQk9/eCgnhswTYDoeai3FWTeYulYeZPtF6uEZxToMprlC/5EOanp
         TizigFpc2xisfekZo84gsAV2BKyVV2vg09ZgzlXcmjsXL7l9CTf6wR2t0mruT9idUVDd
         1mcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTqY+Z9jJXbMNZABXN6zwbEFqwjakR/ABdo+Cl0H5DDjbkjLsyHlzckgcV1PN9lm1u6EIl8qB58g==@kvack.org
X-Gm-Message-State: AOJu0Yxd1YoluLg9URG6WqlGzMpJQ7lkHq2ZxPLMwl32Y6CRl+7IJkJk
	Os6I9uA6/db/Wbpff30ptwE+FeQsSakCjXD3t1cDhw4om49EDOhLMOCX
X-Gm-Gg: ASbGncu4xrwHGZgExxczkapY1RdTeIw1B2JhXNTD21oQTsvr6zMKLutwm8jN13touBW
	wAkOO4pbNMAL7ylDExe/I/mfIsH714ig64YMXzyP0G0Z9hBpK8hRRpug2/pcaN9tRj5Pfpw+2rq
	rQxoPwJnH+SxC3uJE6yKddFZnOq+rbYhJ+H56QfmBl0gdb/9XJgcHf27r2sJiMdLw2jY9N7tyCw
	XMys2hCBfEhcfVS7i5npIwHqtA59eVPkzTheklnP59dvBt2nFaoMqX0585VWp63ZTphfB1o3otp
	cJUCSU73WEXyDixJ5wi/HvVVllYVeThbwWKmeV+i+8S83h+fMioRZclGLqL2vhH3Qq+9pf0MYoB
	D6TyNTnIcnWw/LRmdu/avjw==
X-Google-Smtp-Source: AGHT+IEYXjXLB/W/F13Bzhx+kA582GaDn8mNpPncwxNcA1mYi2Mc3vcqPib7FOBB07/wQRnY02U11w==
X-Received: by 2002:a05:6402:3510:b0:615:4728:f07 with SMTP id 4fb4d7f45d1cf-615e6ef372dmr1495701a12.15.1754102034533;
        Fri, 01 Aug 2025 19:33:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f15a66sm3591482a12.16.2025.08.01.19.33.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Aug 2025 19:33:54 -0700 (PDT)
Date: Sat, 2 Aug 2025 02:33:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] selftests/mm: link with thp_settings when necessary
Message-ID: <20250802023353.jknszntp64x2lvih@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250801085444.27182-1-richard.weiyang@gmail.com>
 <566ff1f0-e6f4-4888-a901-4995a84d15b7@redhat.com>
 <de1d81bd-0178-4649-97a7-016f6f349cf4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de1d81bd-0178-4649-97a7-016f6f349cf4@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38A78180004
X-Stat-Signature: 9zwmim9idqsg3kk1xgrapsjy7k9w4e8w
X-HE-Tag: 1754102036-648997
X-HE-Meta: U2FsdGVkX192JwH+ny7Q+lc3DiA3m3aKQ87GWZR46IPHPQB9PuySEh5caP8xrsVHOozMr3a715Eh9VUoReDuqAqh7pAOvYofDEocuiZq5inoTGv5Y5jCzeRtJo/mVFgjMkjly4/pjoXI/yMeHwrEVtZ6ouuxhMjzCmkQbC+sEXtNGWyZcy4RqzieTnIhw5/8MkdyTU+j9/S/FRDR+54qTSBViDhBKB5ZmoYA1ybjrFUNiOyE00UI5i2BFvz56Qa91xzE3uozEDrsTeJ4OVFrvK2Q3n/rlzsota/QtoHjB9Zbv3pPz7YHIJO2YoXXv1S4a9REoqhbLCK/9fEZHtcujVlmXolRyI2v59+ava5GUXzmdogl4ryWWIXG1Y1Siw6bXtdAAhJwFbuI3NZ5TJpm7B++OW8azddA9hlhlx0il4XtQmz7QbIoioYFXmKF5IaEJWAIu2ps/smEWO+rtTxE9rW6VDGLJWLa2PycFrLnIAE9WpKDZ0HgdnKbhvNJ83SmtriS6b+wT5mfdG2nWIbn22A8tOZtSAPloEn8fqhHSfKL1mm7j47EXZusi4c0eGPNkIc6yG2oWbJWbAchRwTdapwzt67fVm6uz4SKWqLzdZYdk/zMrzRV3e4VodMU0ansnZk6WpxPrOnKmrwWQeE0l5V+W+0dIoLt4EZt6mMpJEK92QUC6JyeWhpzKAQTeeY3CxTPdX8MkPBzNu6GkMOx6j/OP4OeLt8Cebzn6HvD7Phe1EI3Sapc3AFHT0K3GD4D4DFRQl7BLl0HVHAj/0JnKGWKeAveSeo7EVI4uhp89DNjq2nfggh0rSCPs2wehXngSlp8iAbEffLCZtCf+3CU4/F5ICNYjxkQh2TXv2XRnytLhNaECg7Qsp16zZPGTi3Aolp5GgtXhSzqlcJxkbDtADYxZJazenWPLZegZswx5dYsTt53PtL2zwfAnlYp2+/GgfbBLdr/eyyaWffmX/6
 MM0pgsU4
 QqnkvHAmiln5PE4r1lHv1ICpjvPEQ/J1/4p2bJbAkHi8A6pMv9ItRAXjHrmABhWcp8IIrzcEcwQSlIogyMZvyef9B4hKvjjhmlHCY06/OKBYzVm8TolKJ7DxibVLbZKaDCd5NzUds/syEkK+KLVzwHl9L9f3rM4x2xAlpEy83DRAopWNbdjCF+c/Mp9Vqj+4Tfl1rDcv+i6kjb/7MuR7E/Q3IXWxvYAY9apapQeUpvJtG7kzdRalY37tHw0CwQYo5dr5oCkLv0g7j3uq6ImYa/iU7hpoUAJXg3bDi6R6rlIyIm1Ey8uGkBr0WRjf3jV0/WIvmqgoHFKpkh3qB71Vf5M6gH4499jJrv4rw9AFMBaQPy4im6cmDsd+0nFoGldtWdz34y4dMEe49MS1kiR44NHjuNlznzawCuJjVJ6/oLDQDBYW1H61bv5gFRIfOOfLgKr7KTXKr8fAfo5qeEKUmrJYbig9FZ8ntd/q1DpOBpLIOeRMFtW9TY2ZyOeD+BXgUespamUVNqrzVEiPgTnduETzro3WyoQbJyNs1nUDNqo+a0dmXzDoyvjHrsyGDWIhfP8y1ZF/7dYD5Sum7ISGKfxOs6qNv3J6Nt6330DK3B5iLKHjiCZRX2M6htZVCOJRQEzQbTdYRKlNfGcMFN+AGwcI5gAsKHiBqgccak+QeZnS+oIW1Uhclx2HQEhizb3fX4DZx7zUHMFY3htYB+oognloZ9THgYaZ7DFAI5G+bPjbLI7WeRKF37urD6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 12:14:34PM +0100, Lorenzo Stoakes wrote:
>On Fri, Aug 01, 2025 at 11:02:35AM +0200, David Hildenbrand wrote:
>> On 01.08.25 10:54, Wei Yang wrote:
>> > Currently all test cases are linked with thp_settings, while only 6
>> > out of 50+ targets rely on it.
>> >
>> > Instead of making thp_settings as a common dependency, link it only
>> > when necessary.
>>
>>
>> You don't state why we should care about that? I don't see how binary size
>> is a problem, why do you think it is?
>
>Yeah overall I'm with David on this, I'd rather we keep things simple (so
>you don't need to remember to link against this file) and just plonk all
>the stuff you need to link to together in the Makefile.

I have thought about this, while current implementation do specify its
necessary dependency for some target like uffd-common.c/pkey_util.c.

So I thought we may keep the same style.

>
>It's not really a big deal when it comes to test stuff I don't think.
>

Yes, this is not a big deal in general. I come up with this idea because my test
machine is too old. This change could same me some time during
coding/debugging.

>Cheers, Lorenzo

-- 
Wei Yang
Help you, Help me

