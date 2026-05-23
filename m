Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE3BBCD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 21:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C046E6B0092; Sat, 23 May 2026 17:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4F16B0095; Sat, 23 May 2026 17:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACABE6B0096; Sat, 23 May 2026 17:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB5C6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:40:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B9E21C0A8C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 21:40:10 +0000 (UTC)
X-FDA: 84800002980.22.2866154
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C08080002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 21:40:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w7N28E0N;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779572408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fe76tELS7vRrYWmPqyIJMXzdjXWM0RGNTPYok5ZNUY=;
	b=B56BNojExqUztsMB/TA3XqUpE9k3D+HEIfF9DVz3DpVGy+wTjksa9eARItt1sQehyZ5dxy
	fo2x8lE6KewkWif4SNPm30QQPH+S0E+/PKUGNcUopTFZ0e7xfSi1rcBViN7srm/bo6B1eF
	vp6Yfa1L6dj8coq+HOrczolH0rGLjkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779572408; a=rsa-sha256;
	cv=none;
	b=Md1USaopsdYm4Mp23TvvRYVc1vdbBQs9/jHXnffxOvUta1h5Wi4KPdjAGzlj3q3nGAyEGv
	cWwiLeHYAhozijnrWqE1L4Ck2qwE5HywE7nf9P2k8hX9vfnL6b3xw5kzuNJi9cbCMZQYxu
	wd6/mWggvj0k7RT1nCEgdP+dSDSLonk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w7N28E0N;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B84986001A;
	Sat, 23 May 2026 21:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A5B1F000E9;
	Sat, 23 May 2026 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779572407;
	bh=0fe76tELS7vRrYWmPqyIJMXzdjXWM0RGNTPYok5ZNUY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=w7N28E0NuabMjOCzH4dQkIVKSjxHrz+TRnWsceBQIie/DMGKyl6ZII16A4StSyKH6
	 eCZEBtt2cPMQQUv6k8DWBZ4cZC2qK9Hjm8PCE9FOb8x0luMoOoZ9vuUKox+0K7e1jJ
	 F9aMm0jdUBo7AWxk8sWslwLpV8TKl7Zd7ZhD8YM8=
Date: Sat, 23 May 2026 14:40:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
 baohua@kernel.org, Xueyuan.chen21@gmail.com, dev.jain@arm.com,
 rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 jiangwen6@xiaomi.com
Subject: Re: [PATCH v3 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-Id: <20260523144006.a05c06c91177c98fd9fbea63@linux-foundation.org>
In-Reply-To: <CAHKocdErBXQLs0izMaEJg8fLgjPahY0fGR3jfCQ2onS49TWiog@mail.gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
	<20260522110727.fc7dccf90bc8513abd1fdbf1@linux-foundation.org>
	<CAHKocdErBXQLs0izMaEJg8fLgjPahY0fGR3jfCQ2onS49TWiog@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: z3dotdss4jbhrrmw1wpgihzrkz4199hh
X-Rspamd-Queue-Id: 8C08080002
X-Rspam-User: 
X-HE-Tag: 1779572408-869588
X-HE-Meta: U2FsdGVkX18+j6UM7SyL7flKLcFniWnTlEMhzOf+xcK2o3JPSy2JIjYBKdDf9p+pAIA5lyIsBZq6p6p+oyJJhyfBRF3Y+Xtjp0vGsj6d+47olEVDpnHwKfvAtXFgdXxyMemuaiW7BhCMdaxJCK2p+LMWe4taqf4Kil0WjDfujGg/dZ6+FbBV4wqZwYm6talnZ7uMYF+4/y65ldbh08JxVVPbzkVbDIOUlQRNRIddUssO3gW/PuJVyBJzx8+AIK65E1IW+3Eumrr/8e0QnRG83op7oo07Kq1M1D0p4tWHu7FnBCXiFNcR7MinPWY+FJiNW5+1RuXimV+T/UyI6l6cHHAi/KslQI/HWBhcwbkjkRXvO4yZaWN67B2cRB2yoUN4xRSBXbUiFsPkj0bzaTNhT48MV9PXuoN1J2dwgIqjx/3epAiSNNF9lpu7vDwZFmR5Kl+Y4pv11RaP3MZunMAPi7deud9QCqyTGttq+3QegO7sknGN5k92zyT7rm9K3qBowXymOwRCv7EnR6FtN7GkaMnQ26tcXsi5CUBB1uxvE+HgY4jlBOkbGuOOW+wKLAvUnPRp1tJS7RhqGfFGWY1E3Qw5bANGOEQ1ovKoboPDVk25fcxEHnuTMIRFOM8tO7TOF2NWWc1BCvyIQxTZu8CF0RXAjnmdZgBGJoXthEM5q50f+Kcq6WHoehkum2Jm3ughh27zzK23iepGjmHqnk7IhOkU0sT6i+XOl8Y1QH9kgJiiQ2rrtkaY7bX5UDHndoM5iEmv9yXizkSHmrDe0GFeHy54tA12QHXvf+r+fqIU9Mr8U48mx+8NVlJ46yighXYIzZ1ExDrpX0I5OrnFzf7/ygOOuk9h3IjT+AdE2RKMHXZx9BBrUxj0iAyHxd62iUQeZGq25nALumA0a5M5u9gGmXLzEcg3Tgowov6E2MCrGRMN/08Jd4cTC/hrPAkJIHvqhGjWgi8TL+3JaDLuQ0E
 C54rJgFI
 3VTcLR+055T/JEp8CCWf/A+w6f1p23y6Z3JAMdmHJiLCLH+J8EM1GWiGifF4o3ENF+9ndpAsW3g2mJi6EVNW69CLsDEshdvS9sD3vpJ7O7e6jPXgDcIxCp4vdrLRWL9lgwxkNDbbU98uIahIUYNyLhveDMBLNS/Xb+rEJ/672z0wFVd4emkWVGkKXBnEe+uT0LEYDTFXnmaHmP3SfFVj5qtoCPMlbDZTflZWJIVxB5318PHdZ1X7zDo/xpzfWilOHu9FfR7okkSSYeulHS72Ai5djN8UgNreLApWbSp3fqS9I4JGEaZxOdToiTgaBNoSA1JSsUQavAkctA0zg1miK3wXAlzxgbUGhkphl55LpMmx0bN6ippB0oppV/ncSb1NQ4f2hlkOWbXvsDQsfmaFpKOrJ8UWv03q0XM/nRqgd0shd567BbhJ3MPM1fhRe/gwQnZqVZAuYWMQqfNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 16:26:36 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> On Sat, 23 May 2026 at 02:07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 22 May 2026 13:31:40 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> >
> > > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > > is physically fully or partially contiguous.
> >
> > Thanks.  AI review asked a few things and might have found an existing
> > 32-bit bug in vmap():
> >
> >         https://sashiko.dev/#/patchset/20260522053146.83209-1-jiangwenxiaomi@gmail.com
> 
> Hi Andrew,
> 
> I've gone through the Sashiko findings:

Great, thanks.  I won't take any action at this time - let's see what
reviewers have to say.


