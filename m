Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AD8C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2376B0092; Mon, 13 Jul 2026 21:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699786B0095; Mon, 13 Jul 2026 21:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF546B0096; Mon, 13 Jul 2026 21:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D14B76B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:45:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3330780201
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:45:19 +0000 (UTC)
X-FDA: 84985689558.21.DEBC200
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59E23160003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:45:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YdDNa83P;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993517;
	b=JXCN5CsDLKUqTwCy4HfaRVISWQpL0aPup66KorBr9ue0l9y3hEQVqM7OCWZlMrdZs7v4qs
	AeklNUbcrJ1Wx+vAvkoUE47/rmKUU4jNSalyJxoh8ejGsIZYtOWEBBknQqUnJG27qbnK/d
	nIvQ3ELmJiBcd5P6WOF2AcM+z5OWQFc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YdDNa83P;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73xB3qrx3acG77JE8xn8xw37lKaovvRLQMvPzLm4bDo=;
	b=I9SXaslqqQUcYn9ei5j2gGr5+7Lj2zgZYfaNa6QYn4xrva36McG3xD2foqt7Gghz4cM1hd
	D8i2UKOCpayeG50X/XM46UJ0ZbNL4MsERP5HPZhUsIIIogWG8CjPMGiuGf328nI+gb9Ocu
	c1CuBycd6PU6GIc9FMC/xCWOGQGzi7M=
Received: by mail-pj2-f4.google.com with SMTP id d9443c01a7336-2cad1448ddcso31479495ad.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783993516; x=1784598316; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=73xB3qrx3acG77JE8xn8xw37lKaovvRLQMvPzLm4bDo=;
        b=YdDNa83Ptf0TUPsdwxEhRRZDZv35lWM58/AmIoB2Yy+hjfU4nHdAIG/bKg9xJ80Qes
         YygiGHpqN35rcHuhoA4WE8UhVHd16Yzy8O99Db3gDzp1P9fV82JjXVNPJx/8zhNmaqj3
         UgG2Hw9JDPv/vsbiTe+jU3/JbAq9hB64USx0QNZ7DoKbP6gAUP++/88m28tu3dPAaCEH
         dMIw/Dx76qNnx1+GVJ8y2JGhUFydzw+IQXeJu+KSNUw9Uy8+j6aafJYGYO5SmqyABO8E
         eH74TooRNcUbLYazaEgtP4S696Sp8omBHY9DLNHbqiZnBs6bNfgKy6PBcItlfk4VNU/S
         9T2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783993516; x=1784598316;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=73xB3qrx3acG77JE8xn8xw37lKaovvRLQMvPzLm4bDo=;
        b=gnYLDIzIcPPW84rn+EOAjGQn+E20bZlHG1c1r2sgmMyESy0Q+OLWRvWVW36PxRfMRe
         7w3Wmm8FZLP6tsbqkbpzv7gEsi+HS39J2wLSNCsbMcH/ohrSHl4sap/9On24Ic1WrNyQ
         OXiHfgPXhnVOXx871UPcd/55xDSgG0z1VpefW/qQgbM1UT7T+JyvkmLVciqeWxvvBK9+
         SXKE/nrmI6Bh/Wi7c8mtUqzyQjTnF40XR/ZJyOrl8hJsSmCjcuxWwmTMXKTkuqZmktp3
         /Z6ZW6Eve2sdkCB1q30rzNE4dh4sRRlgMF39ciT6WwgHlUjBB/b4Iok7gWFqfT+9xc1j
         sqzQ==
X-Forwarded-Encrypted: i=1; AHgh+RrZmuVF+pGQEq/aMUbP3LlQp2edUWt+lmdlrdLXoOI5NCxqQtHcLx59FY8dCWZKJ/fkAEYRo8cxXw==@kvack.org
X-Gm-Message-State: AOJu0YxqHcxfGq4PKsQV4YiHSBrcVyMvSPcVDCHFnFMStjJvin/owEGf
	FsYKiPuPXfuTGkFCbr39NbvYN2OQ80WVGQ1DS9kg/A2h4X2XQG4/pSoY
X-Gm-Gg: AfdE7ckwTPYOJ47OYEKh8o0y/+qT48oHlQ2FGY2jWYwaRH3aQWQkNhOdMUI/HWiwPUu
	b/gqUChMfI7txc9zBHVsH0cwumz3B2EnUawocZjJIcE/eecQcE7DgMlIuWF1RcNEaVZBFG7T/ud
	HnS7lyeADZaVyA65FC8K71W6kRV9KGQJK9ed4ruE4Xbd7NN4VGqQ5MDTDlIV8EJW0TpvO9xvfDz
	IDmqUvxxm8WWCLynSQwE/4L8cAKEIEXaz23YRa+yLkU+1HQ8SgpUUgaQdFf185lNbV4mgqrQOeF
	5Y6QO1ekoc5oLC5/0hO9WnlChbvElxXdELwK7EK1e8mIr0Bvan7g7ZwFyvj5DeSidqfTWrJwI0Q
	NOQVLAmAR3vkvNwDaGBajU6PE+Uywm0u6SD3vawUdyx2J+nTx/lu7e8bAsGVMQ0Zz2iaFpPwoNu
	fBFGS3vhvfEhGS2Yn38bcq
X-Received: by 2002:a17:903:3205:b0:2c7:f4bd:91b5 with SMTP id d9443c01a7336-2cee98446f9mr17408505ad.0.1783993516159;
        Mon, 13 Jul 2026 18:45:16 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb86bsm107793465ad.11.2026.07.13.18.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 18:45:15 -0700 (PDT)
Message-ID: <97c1dccb-8f17-45f3-8058-023da96620c8@gmail.com>
Date: Tue, 14 Jul 2026 09:45:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into
 VM_LOCKED VMAs under compaction
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-2-chenwandun1@gmail.com> <akz7ythMxfIZeT0d@lucifer>
 <ak0EsCeucJarlI7G@lucifer> <f33a9dca-03d6-45f8-bd25-717b9033c75c@gmail.com>
 <ak-2VAwNNuCD98Jv@lucifer>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <ak-2VAwNNuCD98Jv@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59E23160003
X-Stat-Signature: 8aunxqd4ewe6d6znbn5bqceh3hom1i16
X-HE-Tag: 1783993517-127966
X-HE-Meta: U2FsdGVkX1/BehV+R70GLxlJPqMQgJDMqzGaOyC2NQC4Lx7FuXP16qH9g7+tYPIvExXsGExgHdvpW3PuWxS8z3TOEuD9JLgUwGz5Ndpng2sevh/udhy3O/f8Sz0AmyV3b8AUYx0YaSduyZoWWKo7wFS/RS/abxGEE5AFogARwjCzq9WoZfZ6kM3assg8lvP7ZNL8Ks4B5QTXjpKegvPixRIKG3II4VXrU/htX3mvrsJhxlauTvTJSP40A18h0w9/Y1OYO8NORTbOSzIv//RWlj/81e9jy6O2EApMN8gtIwHRh/BZE7SPGbNHAfi62VA5yLjwdiw25dgW1OQp1COSMTbvB5Eb1etP8hvUlDRO9x3FPhhv/5qktdTnKOtpInOpSyg+msas4jfPUJnQY54UrppkCJ950C6qJSSWmv9bogk9upikqprJ5JwOGMuuiP+rZw2WDx9caK7MieXHK0yFD0ZO1HIE/8lBNCsNGuLLzeCsGN4fHOaYtmg4IKg38/jvJwpJALHJD0lHIYlfVp1nBbzCdGcjJuy6PsuCFKKPqXnd0XpUJ8OxXfvW8GnN3GkcfDkefSrH9e+OnztEPVa9c0RoTdk+D45/YsfgIaCtv4Vgedrgn0KBkK9/+RO2RMpuuddZW1ExGXJ2Li0EafyiG9y9GZtbDG6GQWRImGFPqF5zagli4z2CPijpZDMGQROTkkdyvRGyIWHQjxT6yxeNu7gc43VBpyFDImM4v3yGpXNt3/z5pA8Ta91NgPxO30eVPmO3w21HonQmD3us46Ot32g+1OaqSoqKxgGswllKLPNfVYCoXcq5h9Jrc7YJtVYu45pxyfvT2jJHWuAcSaEiFHgwrQwprustsuk0YfssuG9Q2Ofkka/TMw99TUp5PZnip/vfx/w3pBY6yQ6IwFfbXT1CwcCob9c8SCYaMoENqYwbEVpq6n9KUtREh8RJaQMM8V17nJnSTCmzJyuRq3w
 O6/vd2tc
 cryjWr53qmrrLmtlN653Np6aM1chYAgK6VbroRXu8Scnuyc2jkamOnQ6zeaGePZV3cZpHlIcHnXyb/SJiNmKz8iWhoHYZ0jGUA6UCV1RJElxT66HBRAbeGnRY3odMv4SE6tB4ocY5RgIhn3ooQ3ioiKcvR90uhbEfPNG1qHG6LXhp/GzxbSc2ftPgbroewj8JqbMxtTY+1mvjIIp5AF6QPO26rTzdCGcpV8h7BfZKmp/YVoE5486+uqT5VxjAPH6EGqRIqBmSLkiNWrG+8AyDcex+sx0mysYTJz4PJ08u2NYKI3no2d2OdVPDqGQY5GJNFqc9gwehz2zSLg07M7Eem5H8QtM/MZi1jQ5GMR5kESFPDJk5Se5btTGNEdok+DG60EYEXjT1/worB1Tv0QrTUtkjjyr9vqk7guj8QIlOEloy4Ad/88WRcE3vue74JSnUWfbSpKYYz2p6V1ObZeD9gzGvpbXNCn6ElbzhgoMai8tgfwK0Oiy1UaKfXGAFyUMYLz7Z/FpbNfNr1ERyLIGr7QVE08jlcPpgxfILp9Y2uAmUfuJitffG0o1hhqGMD4edD362lUVS584FTV5JcCAY/UUGu1bPrLPGmzAe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/9/26 23:00, Lorenzo Stoakes wrote:
> On Thu, Jul 09, 2026 at 04:25:27PM +0800, Wandun wrote:
>>
>>
>> On 7/7/26 21:55, Lorenzo Stoakes wrote:
>>> On Tue, Jul 07, 2026 at 02:44:50PM +0100, Lorenzo Stoakes wrote:
>>>> See above about deduplicating.
>>>>
>>>>> +			ttu |= TTU_RESPECT_MLOCK;
>>>>
>>>> Hmm. I don't love 'respect mlock'. I guess we only know about the reason
>>>> being compaction here.
>>>>
>>>> But I'm confused anyway. We have the folio, why aren't we just checking for
>>>> PG_mlocked() here instead of getting the rmap to see if it's mapped
>>>> anywhere with VMA_LOCKED_BIT?
>>>
>>> Also, since compaction_allow_unevictable() is a function that is accessible
>>> elsewhere, you could literally just have a TTU_MIGRATION here instead and have
>>> the rmap logic call compaction_allow_unevictable() instead rather than this.
>> Do you mean:
>> 1. change TTU_RESPECT_MLOCK to TTU_MIGRATION, that'is OK.
>> 2. move call compaction_allow_unevictable() to try_to_migrate_one? but as you suggested
>>    migrate_mlock_allowed function, it already called compaction_allow_unevictable()
>>    in order to determine whether TTU_MIGRATION needs to be added. Did I misunderstand
>>    something somewhere?
> 
> The next paragraph addresses this.
> 
>>
>>>
>>> And then you could adapt the function I suggested before not to take a reason
>>> parameter but rather a 'is_migration' one instead possibly and then pass (ttu &
>>> TTU_MIGRATION) in.
> 
> 
>>>
>>> BUT. I still question whether this is at all needed since you have the folio you
>>> can check for PG_mlocked...
>>
>> I described a race scenario at this link:
>> https://lore.kernel.org/lkml/c372e68f-2bfc-45b6-a431-01bf55717247@gmail.com/
> 
> OK thanks. You really have to spell this out in the code in a comment, this is
> really non-obvious.

I will address these in the next version.

Thanks,
Wandun

> 
> I will try to look at your reply in due course (am between jobs atm).
> 
>>
>>
>>>
>>> Cheers, Lorenzo
>>
> 
> Thanks, Lorenzo


