Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1717CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482808E000A; Wed,  3 Sep 2025 04:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4329A8E0001; Wed,  3 Sep 2025 04:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3700A8E000A; Wed,  3 Sep 2025 04:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 234918E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:30:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C511FBA18C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:30:09 +0000 (UTC)
X-FDA: 83847266538.09.E281639
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8DA7C0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:30:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmGlOWkt;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756888207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ToHQA/WO9OU5kjyFTVmAcoyB7U+gWWYrhmpVg6h2BSY=;
	b=rjunxaIq0btVRoflKRYf55LNVnNYgntzP4KnY2zF8K6DUNGZZ0FS9MLjAMAUkBZD0GYfV9
	hsRtS0aBEhrAZxwegPg5hGAHGX+8xI6wOIHBpFiBQ/qCVxvKUoU737vomYK4NLGJRi/aaJ
	+TX6enzj84CaIdDfezIf4Hg2gQX0PVs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmGlOWkt;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756888207; a=rsa-sha256;
	cv=none;
	b=aBqrTWMVvT1FgSXfqXid2QLuDuOGqEpFK/k+jy6/t2oPLA4IiHLQmMYHy2JJuYrdES/gf8
	owGdXZRhY0EN10AA1WNW8ObMGDXrX8t8+KI2zuIbYpsgTtqLezHiSyCxcZbHtJQoUfNzrG
	MvmS0nm/IlrGLl0Rg1kVdbKMF1wClTM=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b042eb09948so441764266b.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756888206; x=1757493006; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToHQA/WO9OU5kjyFTVmAcoyB7U+gWWYrhmpVg6h2BSY=;
        b=HmGlOWkta2Y1h+gA+CsUg+bfehWj57j/Jxg+Ql9rAt+S3IBbiAb4XVlOhC9FdF3JDs
         ZpF/q3ix+yLDGnvgewJmNFJTwa3VWUtSRS0zybDPJcV8SPftBnoz9oO8/wI+l3vBzAta
         U0zfRX9DXJ0Sxqw9I8HCD13p/06oEr0H41/9mGLvLrf71BdBZmrsNr1y9KGNrNHFTub1
         p0f9KtnBDODOy7/ERDylWTLZDRbMaNhU1KDL4uOXUEDoLCZEI29ld+eSo/zY+RFgvVGi
         kW4XxgekxkDujLkli8zIigNKSmLgVvosZ98Ga5GyR7JZS0Tppto1tA0ApBzsZcZFXNof
         XZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756888206; x=1757493006;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ToHQA/WO9OU5kjyFTVmAcoyB7U+gWWYrhmpVg6h2BSY=;
        b=U/XqBszEOqpqmc65Sk0x3SleW97w1sz56gOv/HYb1ei4jFUzziKqAgs3dJYuiFadty
         2E0hlqKwydQlTu3734UBRmFZ9avKHL9egC4GnydWVw+6/7Dkt2aLYBBf+gHp14SlRR3i
         J9DOP0JvtfnrHhBOW0npW6ofNJseL3ZRqADyL91GI2q1LYXbSfeIrTdEO366zb8zMLgc
         alfmUu9dR4UMMbjNn7++DKuAYw71zKxZ/+6FYwyzaHnHd8bXqzCCcxyHp0umHQjzWBu4
         sdW98oZKE3cVHedpk8boLFt6sJJCPxyQ7BT/LlNVsKrZIEupeKMWQY9ejdSowOLCdlWu
         Jzaw==
X-Forwarded-Encrypted: i=1; AJvYcCVhRFfHxMymF1z5lnvoySMa/+CnOMsz3BidQ3OpXUNwRVV0tpk4Z/QKELmsGSpZGQy6WMP1wpbZfw==@kvack.org
X-Gm-Message-State: AOJu0Yyj9B7ert5sBQeD9QT1hAh3EG8Cty9Qxt3C4bzOQd0XeBCBUM3E
	r9U0ry6MvXwPSEnR02HaoY/2ziHpAzoEFJUW02olSDJF/0J3MqcaC31X
X-Gm-Gg: ASbGncset9NLUlJ7gaNGF90jbwBiXmmk4Elkq+yBZ9SdfEU2rCVq44LdOroITikYAcG
	fYHrkHIOAfWsFW/LwObYB3YRRhk+fiLBOTjb9LxlMMjtzLhyrCOVU8vIehOFPgKT5GB3bmlXEt5
	PjOvtTM+FYYdm8MzrfeSfDHYGidEso3u5xlbdI1WNbydOB/QcLK0LGNARTwjqroX8myJJgDtQor
	embE0d9l2ljbzRtDzco5Ciop5yEsdpwdZD0IEiYzSPOBi5wF+WfI9zbux4T+u2eFOWl/fB6bPRt
	Ed2BoEF0SJuZH7Coq1B9EedLRNWQ6yS+ZoZU0Y0ftwg5KKv69HcQrwT/NvxJh7bEuPzI6h8AsKE
	OMrJLdNzjnO5vEPlWwWCT6tsm8jDEiqYK8q74
X-Google-Smtp-Source: AGHT+IHhZWH7PNZnwpRWoAG/J8OSiBEeiWXq7khV4x7jT3qB2TXGk+eD0qqF3bgluLXGBMowItPzWw==
X-Received: by 2002:a17:906:9f86:b0:af9:414d:9c2 with SMTP id a640c23a62f3a-b01d8a26689mr1364322766b.3.1756888205639;
        Wed, 03 Sep 2025 01:30:05 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b040d44c9adsm949821466b.9.2025.09.03.01.30.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Sep 2025 01:30:05 -0700 (PDT)
Date: Wed, 3 Sep 2025 08:30:04 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>,
	akpm@linux-foundation.org, kas@kernel.org, willy@infradead.org,
	hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <20250903083004.rywppm5bvqskmuq4@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
 <759bff7a-3918-41ac-a184-8c07ec414bb2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <759bff7a-3918-41ac-a184-8c07ec414bb2@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 4ne4d4c8j9h1je33isgg3y1dqibzh9zw
X-Rspam-User: 
X-Rspamd-Queue-Id: B8DA7C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756888207-269163
X-HE-Meta: U2FsdGVkX19HdeRo1VoIUpn7m8D8RMz0ejLD3b7VEKawRsRLvMrP7XoeprLPJHlpGJwiWuh5YC25b2t1ODriLffEe8uY2L/4wGGA9lYC2fN424yP3bbnUyFwyqqtyckVpbVL2QROhRBLpxlm1nzlr5OtrrBKHu+LiZuX95mlJkMxCe8F0W5y4SrFk76jZmn9iGslXX6MXgeS7LkeFmsCwjo7xi3QJ10P51Ntve4Dq/tZg6qeFRBkkrpv0K3XqAMRaDleaUUZz+PAWdxa2BKwVDonHr25P/W3OwWPADULriBeyXjALD+bbkV+i6dzyoeg5MV28aFYw4E3lHAXoSRiNQQwpA9XK7BwXbhSI4hwsECrqGuMzbUQQBiQCL8qoM+3mkMdK8vYjMqKOfAlcNi2XfV8RGdmrucCbXMLKeVNlyQVijWNbm7zphT2JvppxqTf3tPqEXageQS3klUMqTl8/I/FKgIXI1YDWk79NLeARXcHgX6QoTiPfJLjmkg2/riNHaIz9yXk2Nqhibwz8uih7KDfT7DJAaAAKgc45tYm7Y7dw9CWo3qxFr6LqQiVzVex90vTvcPlDXHabvdW7FNQA5fyCqwWOfVFmf+isG4OzfDSoQvZl45lDrRag7ID4F2hxr21TO1m2BA/jysIwARJII4OJGdoSMypyQIDrffqCqbnISgg7v5CQ1NMA+B6cwlb2C2+88mtSGVQvl1c9/DnClhN5+Oa0b/KVt2GsHyxvUF4zYLT7TpLd/E+rHD8S4xdJ6wOlKN1kWmoQY2duGLyxR05BBGuOWC/3tw25gBe8uMlgG2GEUf1I8JvPbG3Z/2D+k2QMBi2XmtfN+GbcT5Tx6XEKxse0uF+h9DsIklrjlXof72sPdc0Z4aVgXRSAQbwS2GqUb08UbQZw0KmYwfqc5g55KeCdExFyS7dXR3TmkQ4gfFbMw/RUbJzeChFmdrfw7phYGPq+Z/uPn2xUSA
 QoFAipaY
 fRhYw02Ulb+wlqnx7K4VQFiWcy1GnanXll4Md2GtApXDsQl0UzepodauHoboPCAPU8pULsiEiCOrvKD9McO0YmNievsVChYzo9AaIKELY5pDb5K6orOCKqWqD/SisuZpE4TbDuCiTAOTwRvqJn0jFLNsBR2mmVFlblQg7CpRnw3/zExBE/K2soOT7/AnllQxkGYpUhBiQ8T21gfJlvU5xfNRnwl5aw4zK9ZxlpVKpTEkiW15HRjYwL0O8/rV5oZ4q16e1IMiMpOIwie98AomM9FnWAABqXLpG04RAU8cNFPVa0k76hfmtgBAqc6/aq9Mj0nq8HyIzIngVc3hTO3d4gMwqdMEL2EtTnBIP6IzuCsMekrPkNus7KQ0NNP1IsehJyn3k1lBO+akco/gHzRzzWkFUbx7mi0L4w/sTJ24DbHg4IKPhaN6MlcfR8ajGQgWiJT4YumCrkxP1exUzkQziBrw+kHu4jy59kOuzB/mpqzpD1ghFOjPagQ3ItKT6li0uYiWp8+krpmbdes+4gzX/yk/qMjA7wGbujQiIUMfR7agL/VGg/V112J0dlBOl8ZSYHo+E3rHw/pVqM9Qz77aHNnBnO58JpeB+iZHDBbF0805PkojvlNLin1CN9CHYgj1DYEeB2HCXo7SZEkN+t3U6IjRaQcWZGr7fCDw7lU6UavpXxZx+7DV8VPWiAv+O75kuWb3YXAhOEJ3Gg9mKIR4p0srTf/uWB9dCpw0/1oILsHaVY8BqQovTbkJH+2e1+VFiaN7KlIrlTsClMbtm7LVnrDK9mBHWw8XI7o08
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 10:13:35AM +0200, David Hildenbrand wrote:
>On 03.09.25 10:08, Wei Yang wrote:
>> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>> > Currently khugepaged does not collapse a region which does not have a
>> > single writable page. This is wasteful since non-writable VMAs mapped by
>> > the application won't benefit from THP collapse. Therefore, remove this
>> > restriction and allow khugepaged to collapse a VMA with arbitrary
>> > protections.
>> > 
>> > Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> > non-writable VMA, and this restriction is nowhere to be found on the
>> > manpage - the restriction itself sounds wrong to me since the user knows
>> > the protection of the memory it has mapped, so collapsing read-only
>> > memory via madvise() should be a choice of the user which shouldn't
>> > be overriden by the kernel.
>> > 
>> > On an arm64 machine, an average of 5% improvement is seen on some mmtests
>> > benchmarks, particularly hackbench, with a maximum improvement of 12%.
>> > 
>> > Signed-off-by: Dev Jain <dev.jain@arm.com>
>> > ---
>> [...]
>> > mm/khugepaged.c | 9 ++-------
>> > 1 file changed, 2 insertions(+), 7 deletions(-)
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index 4ec324a4c1fe..a0f1df2a7ae6 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> > 			writable = true;
>> > 	}
>> > 
>> > -	if (unlikely(!writable)) {
>> > -		result = SCAN_PAGE_RO;
>> > -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
>> 
>> Would this cause more memory usage in system?
>> 
>> For example, one application would fork itself many times. It executable area
>> is read only, so all of them share one copy in memory.
>> 
>> Now we may collapse the range and create one copy for each process.
>> 
>> Ok, we have max_ptes_shared, while if some ptes are none, could it still do
>> collapse?
>
>The max_ptes_shared check should handle that, so I don't immediately see a
>problem with that.
>

It seems reasonable, so

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>When I thought about the "why is this writable check there" in the past, I
>thought that maybe it was "smarter" to use THP where people are actually
>using that memory for writing (writing heap etc).
>
>But I can understand that some pure r/o users exists that can benefit as
>well.
>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

