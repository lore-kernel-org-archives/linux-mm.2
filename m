Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0869C54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720196B0093; Tue, 28 Jul 2026 16:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0E96B0096; Tue, 28 Jul 2026 16:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E78D6B0099; Tue, 28 Jul 2026 16:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABAE6B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:00:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2FF8C046F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:00:09 +0000 (UTC)
X-FDA: 85039251738.10.6AFFF01
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id C26021C000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:00:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DM870aDi;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tgq1O6q0FRitVm44o5MXQ18tOKPEm0B6ScfxrmYXMQY=;
	b=ptdOw+k3uVadHXjbdY8m4wTkqPmuZyrijFtHt2X4W8LugWQlv2Cp1YZq5FN6Y+BV7Ym5Kp
	NYdI9K7Vi2RRUT60eW48jrl0yHOlN1cZzSQbUlWZp0LwoZwiS7mutDuEElSqqoqRFyQVp5
	RoUuaN4J1yqxFyeIPby6EsP7GJND9Ug=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DM870aDi;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268807;
	b=CkyqQ8jwAw/cxVUFTTNhcwFgd5lsVslL2i1NYQqxLi8sl3AIjS6x1JkVJwoe8bLsaDaI99
	N5XMkVaiiwnp2Ey/Zif9Gpy0YrK/RC293x1+ioTWOLhcrx2hs6m6TXJxNjAJrvKbVKkrRi
	MNnj7tHNkFIxGBMTR99Hu7Wzo9r1Oqg=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so1578476d6.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785268807; x=1785873607; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tgq1O6q0FRitVm44o5MXQ18tOKPEm0B6ScfxrmYXMQY=;
        b=DM870aDiEGFvvhfL2cUe4Xs7R+lif+vfubNu34F/g/ub+TyIn2Rjlqm3jU1wZfZAlK
         irzKoSclh59Xl1OjHKo02skKU0uBz50/ZkkV2IUbgFXit5tcHMi8S8ZnztRuB3aUGRm9
         rjREQpa+rzDlSr3ab7f+xSgrvKHmyYj3F6tDVLXe39cVXh/5NZydk0zdlRaBmi/8Ck2Z
         VoeXydc3JOMhytg26xXaBx1Mqh8/0uBvvLD0BDuN1odAR12et8huWdsx1Jh74qua8Dcl
         TnssSGG01hrk0rx4xj0tGb0fTo3fGid6NJLOH8bpSpFKzLUaR6v1fy/DMNBnuA51jASf
         tjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785268807; x=1785873607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tgq1O6q0FRitVm44o5MXQ18tOKPEm0B6ScfxrmYXMQY=;
        b=dUBB2WIQYKmSpmS80LrMfXeVg1364xS3la9dxgukqvhMzSCi9dcwsw35EYdq7XfOa8
         smToExWyHxwiejCzl1RJl6JSGR8olHwGNTpLOmcZSQTADRoeVGEVE/MWDVb7qnn12ffT
         C209r1258txdkn3d9xaxlTPO1kkP+0VsM8DufRcigK0TsaPQJiLuuIKBJSGMU4lNKiy1
         hf0oet/3BbApl1BdxgLzHkwqM+dcwqjLdZewvKLzHiGe8hQKcg+pksJhOzymtGl0OwwB
         P6OA8hMSAqaimbb/mnDwOaUw10jIZOxF7uAUPSGtA6CPCY9pK5XqHVQLVRA+9rSBlXEl
         uofA==
X-Forwarded-Encrypted: i=1; AHgh+Rqeu8WsR7J7ZNKl61cXM1yeiByQI8lAniuHlP+Lu7IQIekN/ZBq5LW3JFpa4/cP6xNwOKVJotJ6Fw==@kvack.org
X-Gm-Message-State: AOJu0Yy7UoirUI8CvCagHz22Dnuz6trxtHj+8LuzG4V4yGJOim8vYkLD
	qQKz4AKhFjHIqSwMWcas3cxtKJGKMnsg7/NTpxo8zwepbuamMsujUa2Nx+yIQdzApEk=
X-Gm-Gg: AR+sD1109pGfKXKtNphTJf25JTmlbN6H9vC+jjYQt019c2dIPLQ9A+9D1t6mQCA9Wd5
	9oG/O1Mb/yk7EEV5U1bu36vWU9PsDZ3U8q68T5lUIftvyyAlRp6qvsVofWKompWNwYiSkbopajb
	O3xm2C613v9mHOvNRhvNbayqRWr+Sk9Rpffl+3P1GNJw93LZV/QzI4mlgPebvFitwzmNK3c+HQi
	F5NQDO0ZPP0QuRaQQNk9XdUr9M3jC5o1DlSm1QRtHHh8bWu186A/XY1j0cl7yuyhs1I4cDIvNhv
	q/yI4RI6VZX2k9+A9/L+I8NJfYAUiC5rDSxgr8TcEVaMOEJgHWWdsFH336bAle++xdQdRy4pXHe
	dTpgG7jbeuo9s2YF6QCKWrEAku1ADVvjCCU4i8xSpdH1f/Kq02EsjDo3MHXcm/dcUm+MUoMasIv
	SZTBMR7XnP1VZad8xV8dzfU3ZhqzCe/d77DNPuNoMndMxbwKUullBUhA7BjwZClJJXEyOS7I/HH
	SZQBu6vnvQ0NIwkg3+wI6aCgOps2CaIw2o6oYC0TnqQ
X-Received: by 2002:a05:6214:5892:b0:907:dc74:a2ec with SMTP id 6a1803df08f44-90816f640dfmr45313586d6.12.1785268805961;
        Tue, 28 Jul 2026 13:00:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd905a0sm6641656d6.44.2026.07.28.13.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 13:00:05 -0700 (PDT)
Date: Tue, 28 Jul 2026 15:59:59 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com, dave.hansen@intel.com, 
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com, 
	riel@surriel.com, rientjes@google.com, sj@kernel.org, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com, 
	xuezhengchu@huawei.com, yiannis@zptcorp.com, byungchul@sk.com, kinseyho@google.com, 
	joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com, 
	shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <amkHhuZ8oL8L1WPf@gourry-fedora-PF4VCD3F>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
 <amjz7kIDuZH6gBx9@casper.infradead.org>
 <amj3jbvruEiHIZvi@gourry-fedora-PF4VCD3F>
 <ed9e7308-09c8-4631-a012-940cd6e11bbd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed9e7308-09c8-4631-a012-940cd6e11bbd@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C26021C000D
X-Stat-Signature: ycsa81gnwmmmwrh5ue8srhtcsjhqnunx
X-HE-Tag: 1785268807-612072
X-HE-Meta: U2FsdGVkX18tSmO5okofz13bDNxo6de2owEfyllLIvFWmA5kNRz9Pz5HhnyXbh9o40FzVy8PU6Cj6z05Gg86nCt9euG8f0cGcPUPpHQncTOJODPLv1L9NAkHpKUauyy8ntVplT7KWoxWmFpnodggZ4eQAtrCHd1tnObavShzwOsiegD1Btl4Qb+mYAzFUdialt5sbLbatDJ4WNOlkBaTOq50zM/MdsvAXizYyZm1d8u8R33wN6OAOBEtswT33CMdssGdLJyzDmj0RVbIucrNNne8bG/n94hHWp0Eh9uViyb6W6ibUPAVB3n79thFaeDj88z9jsBol6/ZqcgCzpNvyfl6gTGexYnHRnzlle7gJpcH5sOG128kwF0rHa2neNhrWTEeQorauA0Cmzn5J1SCm46/RQpyNWg0GEEIdUjUW05UR7HZzSkry6hqIc1wSmobJf2yKsx6Hir7TMsg0qukvjqTMrWCoY8zzkGkxFdq8d0QUnANZeHHRjdUU11QiMPyLZl/hXjR4gs3B50aHWHJy72POIu3vNYN+946cupEi3D7oC3sPhEN6txRkn1/4kLpGS6hIP97O9q5yzMj/Nb6LECKPFeF0ngEcXM1Xe2qpuN9MhQm62q3lz0HbnGNE/WxjHw7X4dBpJeNSMU8IcSA5QarKawLpUn4EaJxEV+/OJzhm53CKmPA5ENM6Y63BefqsKLbSI/9UTKK7B4iqCc/yUADX8S3VgMWea8KZRIB5K7xTF6PXpTlb8fq2ImtCBJ8peQPI3ZEIe19i3kHzm8PftGQ38MuWF9euCcFBJXnqga9hQsZpIPS5AHNYmdoTugg8FMhQ7dtYg3aa7WRiHuA1D1ZT+k+ARAmSIVCUCxaKvNIgFfAPBpQNceATeD3hjPwt3pVT8Eh3r+60/kqdqH8oUMmCpwedlJPdvszswS67pL2yheD/clR1g66nHRciCEzzT+gDV9cQ63bxl4nCGU
 xfh63qiX
 W5wlUXnr8e3RJQslP0M/7EGu8yClSSMiIgNgHBv9ayysOVY8CiCPU10ugWoVWt9L+AXlXX30OWcDl+vjyJ6aJLqcdcKu73iVU8QrqJbeBUXRpiFx9o+7lXyL3SjyyRde7JztvBYlpGh94nHNXwCRInCnuGoGEqkQl/c2zMQ/+uFI+XkwAPUWkp6szSXUSgzmKcgehWa6YEIUbxbS6PhHEO1zMIVQrC9lqrfMKZJU4/fO0HDlRmRolt/M4t82G9RfwpAKv9FQyP/O0U+hVDvR3nuhKVHi87FrQUF123f89XmkIuqk56SZckf09h56Snydj9J22g969tp9QcHLmFH+vOBIm5mkzXI9kqjEa3qdu7nvRVmwO382nkRYTLjlXZcp9RA7V0IblND/ED8w8MjM8swa/rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:20:32PM +0200, David Hildenbrand (Arm) wrote:
> 
> The diffstat is scary, to say the least. And the x86 stuff certainly needs x86
> maintainer acks.
> 
> So far there is no real review -- we're in v8 without a single tag.
> 
> So this is far away from being mergeable.
> 
> I'm afraid this will need a lot more discussions, and likely RFC would have been
> still appropriate at this point.
> 

No disagreement here, my lament of not being able to get fleet-scale
data is more of a personal one, not a cry to merge. We're working on it.

> It's a shame this work was going on for quite a while without feedback (blame me
> if you want :) but there are only so many hours in a day), but the main problem
> is that this work in particular was not perceived to be high or even medium
> priority so far.
> 

Should note that we hold a bi-weekly working group on this to discuss
the design and micro-benchmarks - so it hasn't been developed in a
complete vacuum. We (I) owe that group some explicit on-list reviews
and testing data - that's my fault (life has been busy).

~Gregory

