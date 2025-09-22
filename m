Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3122DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F248E000B; Mon, 22 Sep 2025 09:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576C38E0001; Mon, 22 Sep 2025 09:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491FB8E000B; Mon, 22 Sep 2025 09:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33C438E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:32:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB7801A060D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:32:57 +0000 (UTC)
X-FDA: 83916976794.23.4876FE8
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6414160003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:32:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WV6jwD7R;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758547975;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sl3Yw2Q3HDduef+tk1qVxwA5GH5zx0yxRQke8Gzd8I=;
	b=SsIh6tvpi42Q7d0+xHPOJjPVCqBenXKBfG1nywFbwu/V4DHii5pRV5AaxMuI7esmUJOWtz
	dFAaGI6KqjYYwRMBx9aQPFTL0VjmlyIPhpklpK9/UXbDCbtvPdvKp5ichn20xuIQQcVuKT
	vv7YD0t0M8ctCXFyZllmg6tbFr4AiHw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WV6jwD7R;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758547975; a=rsa-sha256;
	cv=none;
	b=lTDucHMlSERN36nlmgZ27tLYR7j9qto60ML/sEG2gTTr6UMDnwTx9djlj5mKimNk1XTP2S
	BLohoxCoi3KId1YH87wE9MNtroPs9DEm/RF+g0CJHMRJXQuZH4JoL1ANpQWfNu2EmkQtTx
	+eh0BfzatxZdU6cJGM7ApB2LeBQyz5g=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb78ead12so664477166b.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758547974; x=1759152774; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3sl3Yw2Q3HDduef+tk1qVxwA5GH5zx0yxRQke8Gzd8I=;
        b=WV6jwD7Rbe5YLE7oOH+v8cg4bhHkZTXhNibQ5MH96TpGz+OVbDROYNb8A7cyADh4CA
         rw7IoDbKKtQoPTJL/16i8Anl77DjEaoHicac6Cd6Qw4ohJGK8jZQlPJDhxtrSM3uk/u5
         RLqhvmnszraD1lrAwWI2nS1xr8SsvRclR6/HtSpXfeZzhWEJAzdmyChEjW/sRbziYTa1
         G36p9P0mONeXWvY92mTixadBwu7tR8YjxMVogZRbKUrvDKGm1TVr/DEZI2HTdUhWgKwt
         aX9T8M5mlRYxEEKIiU0ysb2yWcubgPN0i2eBYqHarNHiEhnyV8YHVfc2NmnYDdNRapob
         j2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758547974; x=1759152774;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sl3Yw2Q3HDduef+tk1qVxwA5GH5zx0yxRQke8Gzd8I=;
        b=f5qzfCHIAKYZkXaQy+ZNH6KBcykIDlTiSiAUWRyhrJaojKbm6a+SR2dppWT0UCWDBL
         4+67/fdZ8jkef1AVvna0GarcJRn8uPkgm2ZD/uXxzN3wYDemC4VFlWxbNLi94cz1k41/
         +Dgfyk9EZ3CL/Q2S8YiGRPKSLF4evaXggpIejy5exMNn9inegN1evrHtO3JdE+F92ODf
         KYlaObZS0hOlS8NgC2EZ626nXDImAAbvMdBqw3SceCxVJr2XvBR0JKIp6ZTdvIQ6bTbA
         9Huhir/SpzarkHeR7EoQ7VSUVz0pnErZvs/Yhewj3FWTBZoEvRrpho1qQ08RLC//kPAH
         HCTg==
X-Forwarded-Encrypted: i=1; AJvYcCVf7iu6L+9z3x0ihXtFXa7YRXo2IoJd1h6KC/gl/KEMwQTvVHx9ShXCyYMVy7ppzFoBb2fEUjjcSA==@kvack.org
X-Gm-Message-State: AOJu0Yy9x00gx5ac7YPbtiL6ZMyPZQpFldaP+zjD5QzZ0bCkdz4Nmevh
	2qnVrGXHv6OsmWbrEwXWEVp6x67Am6rdamZrx4V+Zy20Ih9wcj8EHmZB
X-Gm-Gg: ASbGncsIh9ADF8Cr1Gte48MUfwflS340vnNjc4TUHNBkbjgkUYL/YCiDqsEvQa6sMAX
	gvnrRjyh+bwq86omv1j7orHVDP6Pu6MZYKWnjVcHpxIHnDK96nICaC2JB0XfCnnp7ivRQRwxG2J
	gYxPis5yOOkxAyU/9pEBomMo8Or32qRtaitBP5CaZnE3NEFVK++fnP3LYoyTfXKVuoyOp7Mv1Y6
	0297Epf19nh743PNYUcGQls0WD+/U7HToDg3OOoQwhCQwvjg/m7E7iznP4q94hZhtmJ/5h1JI+T
	9Mf3DD27fmVJGeT8z+5pz2QnFcphMCY0oNEyjEG8mpwhN5nz52zzabh/FUq8Z5zribHaIAuuBLz
	nTBzCs6ynFvtb/7tGBWjUiA==
X-Google-Smtp-Source: AGHT+IFjWkQfKemDLorz2GKLo5D+iVZnWYyb/UbDlzrEM/OpufPvw7ZoS/JmMl7mJnSGginZCGg0uw==
X-Received: by 2002:a17:907:d8b:b0:b2e:4504:2cee with SMTP id a640c23a62f3a-b2e45042f2bmr149899366b.41.1758547973958;
        Mon, 22 Sep 2025 06:32:53 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2c56c2389fsm265118566b.79.2025.09.22.06.32.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Sep 2025 06:32:53 -0700 (PDT)
Date: Mon, 22 Sep 2025 13:32:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Message-ID: <20250922133253.ajnffmcupzknzl4d@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
 <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
 <20250922081226.hsglokm74lh2eng6@master>
 <89afa6d6-0a02-4825-8923-3752397b38dc@redhat.com>
 <433cba08-e33f-43ba-bccc-a2b1f2b1cd50@arm.com>
 <20250922130255.lbrrbrr54iwso42i@master>
 <fb5bbaae-15bd-43c7-afbe-84a951f97044@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb5bbaae-15bd-43c7-afbe-84a951f97044@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: D6414160003
X-Rspamd-Server: rspam05
X-Stat-Signature: 1oshak381feip9sgbky7jdnseo9ff7cg
X-Rspam-User: 
X-HE-Tag: 1758547975-71445
X-HE-Meta: U2FsdGVkX1/KJ9gk/gqtvEehsytdAAzLPd/YYMfFNk72igolONIxnmhjZPFlmZ1u2ncZpiry+VvtNRjDCn4yGzfdsW51iWfYSmyp2xxZgX+fvXGXw73iwI+su1UpeaDDGmSW9GheFFQlIiVoY03DwmAEw/mlF+qzmT9yczBl24j+TFCRhW9Gy22wWojWVFuza+7gfZxz3a/+8WchVrbA7ehqp1wShUlJOI6hVlnYNF4pgBVvubYAOS0TKx4M4WhItSvY7Lc004Z+6pImA/PJn3I/YfLb/e/BS/IM/yzttx5DuoAvnbb7H1xH0kWFBkR/fe5TmLk2ITI5ppTYHZSCG2eL//X0nWCz6d8tUXHk0WwfxIQqZu3CO+3BSZFvYmFqDKyncRKtg8mJsuNXjZimf3qEHD7LjpQOvN4RwPpGGam2vPSAF6v+jfCMoGmE2S8Yy1ddU/VKBYk1JmwgyDs0EtUcuojofcEukP1ZuioIXugzz5wYN6RrV25Yzs6F1YfDon+gGHTEmOfiT9D0gva947ETIuX8/IyT+Gou7c8TJJBifDa0hoivnNp/GK6DoegNfpVia0u8g/FeHLmVYZW3lXWwynwA64wI4db5Seb0BP5dScnIjhORZrzMjmKToa4iY/UEeNmMM1dq4wwmCFy+Y1ZQyuKUOlqWSxZenpD0eTEspRcTF4Xypr3hN2gW5CbEC63YN+oOkktoGzDJwKo7pZazA6WctaJ8KFvfIK6Xq3p3AmmEZUCCTW22KcTiDMz/ycoAcmpDcDhVW06w4CyJjsX2SDc+10f5UCWQH0yFBGeC4iX/TJ2gV3aHl66/s/fC0DTGL3hqlJW3KtYQWZV9OYpHFpVDHvVYmryd13Iub1YQ7BLGLqu/O8a5R4G6hPCBNneLGTHRefoxG6kNt2KwKiH6z3IznjN5VHsufAShnwdxhLEO/9heV3F37tf50u+686rpWLSTO7IqLtgIYrP
 OQvFukDk
 WwhjMNTl1TvQGNhU26dwqVGJSAG+BjQynZrf3KQQ4UMcsAvvLba708NpfIn7sQSpUHandX2OmarfdNQhJX1vBaPf4QUR6SJTB4g/eezonbXz62z6BRlUQOQMvlWyrfO0mJ1e2KCNbgJOkEcemqNkQVrueUqb8cQrO0vQq1mJ4YxSHLxvbUwpVd9lnfc+phqdRCIyKaD2+bjahyhe3TpCX2If8DBmvWC1R2l550NIhQYg5oGGqLormFL6kxN/XW5dyh8hBRmsegxhzEPta+kSV8omcPtsbu/blTzCJaxFMKxKwfbJtnQ9tKTgTOGXI747IVLcOoCNLeHjQaMcuq+7P1rrqmnKyo9m5XDjSmNB2eD9JQBhkSKO24WXRIO+2JASWUEOjz8Xsoi4zK0d8Nb+NHczS1ddioWcKE7/V27yU5cXKUqrcWONxyBvrlkY9UavFYXXA6mj86QTtYIrA5BUqitoszXK60WLcTTCFxdaiiOJjuow7u/3FA2AHNo6UmlaEmeCQWKan66ls0ZqWbK9dOTqpgY0c9u8ltTzGWC42oWldjEtm++qde4xSucRveg9RSOEVcMFue3DKGppdKmLjnZpiFQt/t4equs1PhfZElHmcKbL1I13O8XY1ZybJT7y38wv+jdzIOD18EvBo8PY+ROA9y5lfGtt/IRnRvFGTH3Lzw8DIh3uR8qkx0kgZMfm5WU5oI+TsiM5z8plEPYGK1q1RFFnidtmWlWphLFf6KvgkOrznKdy0LGEhBzhbcEh0UlubJ1z3tMeYy0eSd0B6Y6JzzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 03:28:32PM +0200, David Hildenbrand wrote:
>On 22.09.25 15:02, Wei Yang wrote:
>> On Mon, Sep 22, 2025 at 01:56:54PM +0530, Dev Jain wrote:
>> [...]
>> > > > > 
>> > > > 
>> > > > Take another look into the code.
>> > > > 
>> > > > The change touch three functions:
>> > > > 
>> > > >     __collapse_huge_page_isolate()
>> > > >     __collapse_huge_page_swapin()
>> > > >     hpage_collapse_scan_pmd()
>> > > > 
>> > > > Use pmd_addr/pte_addr look reasonable for hpage_collapse_scan_pmd().
>> > > > And haddr/addr would be suitable for the other two.
>> > > 
>> > > haddr vs. addr is just nasty.
>> > > 
>> > > Can we call the aligned one "aligned_addr" or something like that?
>> > 
>> > This works. Let us use aligned_addr/addr everywhere then.
>> > 
>> 
>> Including hpage_collapse_scan_pmd()?
>
>Yes. Anything is better than what we have right now :)
>
>If we just want to express "this is the start of the new THP", simply
>"start_addr" might also do?
>

OK, start_addr/addr looks good to me.

Thanks

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

