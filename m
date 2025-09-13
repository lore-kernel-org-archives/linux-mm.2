Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A54CA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D266A6B0008; Fri, 12 Sep 2025 20:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6906B000C; Fri, 12 Sep 2025 20:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6236B000D; Fri, 12 Sep 2025 20:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A989D6B0008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:10:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A614C078F
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:10:39 +0000 (UTC)
X-FDA: 83882295798.11.597CE85
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6125240009
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:10:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TKl4rvIt;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757722237;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gh4qNOq/fXdAmcpuz4VCDjOq3KMlvlbBCKcrRvBJTss=;
	b=PB9rdsnDGkGMpmzRBM3chn/RMm2bi8VwzT/sNntYH7OF6ru5rQz+TgoLyF7jQIekOHl8aU
	rr8IZs1NUe6lL+cRQyDlbhdxv8efPWFgu+Xp8JdOEZzw/MndkIvdnxcuSeUqtWE2EX9uyd
	IWQKinhIOpk8JGNaHS04pva33nJn0hk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TKl4rvIt;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757722237; a=rsa-sha256;
	cv=none;
	b=uKBOfa1fntFaL7R6TV/2uCkELzo3W/6NhVW0yKz+wCNz1hg85AynR9MceX3edOiRcOvpcD
	K2juTK/lHfQvgbwRHwcKbYfacthDiFVbqOs8wYbcQcTLUZIPRVlZMcEcYa/+7s4aiIiWNf
	1e8EE3A4eyo7OUDqkQl3IfP6WmeWJVQ=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b0415e03e25so322076366b.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757722236; x=1758327036; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh4qNOq/fXdAmcpuz4VCDjOq3KMlvlbBCKcrRvBJTss=;
        b=TKl4rvItyO6xCYIpeuHTfIVy4qcTG9WiOr8xXC+acVFBYLvKvVpYsevxvGxjfMJOc9
         9ZWSUkht3rTDFz35yojr0cN+yRFDmQGhfG31IIkXN5/3nsRhp7CE+hHirW2WyZztXyBZ
         TXv7mxhvg0JBmCWMS2oGleS3k0iSqvJ+w82rcIDkiwUkvxm6EX73L0RAQL5sXbcR77Xc
         vG4FPP1BzLv1KKgfLeXkX6Xh65uZt26JDx1q1K+rny8dh0X8+K5zS5de9kC4Pt9frsi/
         zDNtxcXYueTOBCgEc8jBj2skxsI/CIUBVnQkmyG1JLriZV4sXth+TX9nPx0o3XKaHWKx
         e7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722236; x=1758327036;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gh4qNOq/fXdAmcpuz4VCDjOq3KMlvlbBCKcrRvBJTss=;
        b=ODz0m96CWtMoYq1pb8TfhqLd7C0Eg/DEYiclEgZfABxAxom4n1WdrYKvKj025rThwv
         GnKf6vc+/FZ5m1d4rDMlBsByF+RSEOmx1y5EX7ptq63vvz3OlcxIGHbl8lxnJLDykBQM
         MUzhanLGH763+Fx9QSdqsbhBnDnOKh5XfDuLQ4bt9SK7/FkUfNEWUCLWN+H2NUnzZ71H
         CkuvVveadCpeXNjAfqecXQkiA1Q3epyjci8sWImMv/oSVcN6tPoRHlTqB9FtMjhjcNk9
         /QEqMBn52wXAhWAlShRXSWWh7yvJ6wSqxchFdMZ7/cJunOFMRLAAsrylmCARR6+zxQtl
         ggKw==
X-Forwarded-Encrypted: i=1; AJvYcCUFgJuoUApL75mmSGdQHLeEK4qr7A/gWiDFq+b6pMG5T9PjkfL1ZqGMuzvSOoUZlVd8yyBmRtsekg==@kvack.org
X-Gm-Message-State: AOJu0YxStJdDAWb5P+zr5gR1RXwoXVcBYrYKTatfMm2NxdQM57RDefow
	ND6tq+UJQ6LeY7Y3B+id89/qojs1jchmqcVM/RFGjCHEr7nahpxobRsu
X-Gm-Gg: ASbGncv0Zi7j3mNSM0eOjx21muGR36cO19tJTxkMMjlBdPloFE3dXlYMGTVi/vY/hQB
	eggHMnKQG7TxIOJlv2WeV+/guI0EsdBPo/zrRhFRFOQmVz4tHOk/wIhRX5K46BRIE3TM7v7LZW5
	geViRYWR7M7Gxz3pjFl8dIQKbuo9pzj/uJ7h4PnuHPlW2Gf2XcLupP/B+25nVkL/g/D5d0UTvqF
	IzCz8gRGUsLBiOFNZy1mmjV9qc74xYH2UvqvM2MiuOPXF7awrtbLboX+RYvrKS0N4niu1rO8brW
	rcaAf/XDtegqAmtHObA+8ZeCIb2THA+o/Zo+db7byfHBTSpr4M9fJsposaEjeINQ2+2iETX/yQa
	SD85atTQLwGqHc+HrvpRw5yw/og==
X-Google-Smtp-Source: AGHT+IF+IFElhDrfYVuV3NnJDLLLUGoVTpNF/5sEZ66XO8Fi157c0djNevbADhBEv0DTmFyy6cy2HQ==
X-Received: by 2002:a17:907:9720:b0:b04:3c00:b934 with SMTP id a640c23a62f3a-b07c35c2876mr455826966b.21.1757722235717;
        Fri, 12 Sep 2025 17:10:35 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b30da4basm475667266b.8.2025.09.12.17.10.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Sep 2025 17:10:35 -0700 (PDT)
Date: Sat, 13 Sep 2025 00:10:34 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250913001034.wt3iw4nyrmldblhg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
 <aMMGbPX9uUj7TfoG@fedora>
 <20250912010721.zd67xbfdava2u26e@master>
 <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 6125240009
X-Stat-Signature: mzx3hmq389d5g6hdm3e615pow9r9yxob
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757722237-979488
X-HE-Meta: U2FsdGVkX19xOHaOvBVgsAeSLjZRXYx2AFaAtiWBMG4vYcaSenBHVBPLT23gRHRmwa+eE/b1g42KwgCSEbPMhGLZkarKuJrjt1/eDeQxU3J/2CdjPzInpB8KtfUtBUbJZh4zRSCrNJ+J7klVgxfuY3rsNnIeTR2knEJaevtg8JG5StqgNs45l5BnjMoNAXxz5j9XA8Pr+oQX2qxtxS2wCcGPp61OTxTIYSkkDlL9jwXMySJZW6HnajFzkXSXNsCv8hIrjUR5J2kinD8PWW88NedRtoT5t6r7l9nlSIJ8Zdu4+Q3oLtYwKuIeqr6SmgtBEwdESEY9eEXV8FXSHHjBmXCYl1OoYnaVkeFjXOH/6/y2FmYwLTB1NFN0q2XAjQpbJCTdFN3ZWzdaeqBETdp2TE+MZhvtzcwxRVzqvvoALfOCS/doA5u8R4q6i/g/GVZb987C5YDOnaPZmTaTzWdOioF+cb1tSCJ+BenN0yZrO0jRatSDQ46tlGJDetQSrGTm9Ggljldtcpj2CN/Rk0fElZbqOLXKA0GcKC+uEiyLHs4Ds66Cbzb3y781ksLqOHrk35gyomu44nHaNz31jDD4yLKHF80M5MQvokglLdChm8hA8yGN+6BqE3XA3rHdKDfbCHt2cbgScy+OuyQSq2S7DOldYwHjzKSSKBlw3sks09VoVyA5zgHtL79MCwHoqodBH6WDzxoXQncRouvgM+oyXTUFE4XmLWUWvhD/J6yjde/HG9Haj2PmueKqKVwUlUy6UFwPS5zYS+qb7YAns03qOCINEdyh+1ymjZIJsm5FqvkQmDtSS1An0c5CsTscP/pDin9IPVNnMC/CyTnU++qOHZubKirYhWWf4i1qAN/bHp4AxdgeWT/9WhqdP/ctgyw+eOvUJGexCjhAeuEye88q0ddX1AacRLrDGNMazmQahddWRustijkmTjp6JyLbV8TzsIe7EgtKMSjWiN3LQAQ
 Q8AyhzcR
 15XnxYHpY0BaGVArz0I1+01PGscjwq9OicVEwONDricYBiyhsr62gNHhK47ENPBwfLdCaio3zTC9w/nCNTmciUbIKL3kIBWuBeSTqJjmoo0sPsqRUz9xyPTf2+ys67RMCWGpmAY60boOj7eCU8W19t5QOdOd6mEjXeRCYLQ09ajf0VdmD5hRO00j5v4dJmUdqm4bcYALIURtmxMEW/FpRwf6B93ibVGUugB6OSN1++8UtOPbEUjfDbR5f0Vtg7dxAN6DHAa3UcE55k62NNEQb4RnDfuYMZRVFme4FshogiqRcCkpgok3P+HgZ0Mr8kqp2YR8Ve9aH0U6ySqiEvbSyiz9VzjMbebCbt/WDywnlAGBXVnViSFg+bg3ih3hjCBW4Ma/FgR26a0zg2LjKsTSmHgz/eQ/RlukxW+W7jV7zAMZhqVfIitD6whtZhHCdehu58AnFUA9jxjjGvR7Wcjrs4eGVH+9D1EBOuK8PwSar/hp7De0iDjpSqKAeuNx1Onr4scl62pnSYqgRzg59vUeue4XKxJ5bp/TE+PH0hw307Z828hvd3MlfwUJ1WF8SYHU8/Ee23dhb3BZFVIpm9jv5mZgi22+M/uyLoKedsmF0O0Wv+PhDU0qwgsBYgDa3R2z/Y95L/h0rSrPueuG560m26bCfExEg+kzxvDNWFyeuAb065ljPYJylVIH1e3BSGoQcUPyePmAyrJL1WVXg4ieo2Tp64NWvc6KtWUgH2YhdqUY6SXcSNg+wzmOvgWGuz1tRQoOJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:29:39PM -0400, Zi Yan wrote:
[...]
>>>
>>> For compound pages, we will always have tail pfn < head pfn, so we should
>>> always find the head page first.
>>>
>>
>> I think you want to say tail pfn > head pfn?
>>
>>> If you did find a case where we somehow encounter a tail page here, I'd
>>> love to see it. And then you'd also want to make sure the other compaction
>>> trackers are appropriately accounted for.
>>
>> I may not follow you here, below is the call flow for
>> isolate_migratepages_block() invoked during __alloc_contig_pages().
>>
>> __alloc_contig_pages(nr_pages, ..);
>>     start = ALIGN(zone->zone_start_pfn, nr_pages);
>>     alloc_contig_range_noprof(start, ..);
>>         __alloc_contig_migrate_range(.., start, ..);
>>             pfn = start;
>>             isolate_migratepages_range(.., pfn, ..);
>>                 isolate_migratepages_block(.., pfn, ..);
>>                     page = pfn_to_page(pfn);
>>     start += nr_pages;
>>
>> In the loop of __alloc_contig_pages(), it iterate on each nr_pages range. And
>> nr_pages seems could be any positive number, so it looks the first pfn checked
>> by isolate_migratepages_block() could be not aligned with page order or less
>> than MAX_PAGE_ORDER. This mean it could be a tail page per my understanding.
>>
>> Maybe I missed some point here?
>
>You are right.
>
>But nr_pages cannot be any positive number, since ALIGN only accepts
>power of 2 as the alignment. So alloc_contig_pages() might need another
>fix to handle the case nr_pages is not power of 2.
>

You are right, I missed ALIGN() requirement.

So here we should use roundup().

>Oh, after I checked pfn_range_valid_contig(), I find your example does not
>apply, since it returns false when any page in the range is PageHuge.

You are right, here hide some magic...

>This means with your example, PageHuge branch will never be executed.
>But alloc_contig_range_noprof() is exported and can be used directly,
>the @start input can be any pfn, which can be in the middle of PageHuge.
>So your fix is still needed for this case.
>

Then the next question is why we filter PageHuge() in
pfn_range_valid_contig(). Looks we can handle PageHuge() by isolating and
migrate it.

>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

