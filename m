Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA8A3CE7B03
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 12:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F188E0003; Fri, 14 Nov 2025 07:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73ED98E0002; Fri, 14 Nov 2025 07:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E438E0003; Fri, 14 Nov 2025 07:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 482548E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:36:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E459513A95E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:36:12 +0000 (UTC)
X-FDA: 84109160184.15.2465F49
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A7B7160009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:36:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y+33MYuG;
	spf=pass (imf08.hostedemail.com: domain of 3OSIXaQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OSIXaQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763123771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxQT1ueN0Bj88cVZcCku+VDcMMej+3QPEoT+7oXlEUc=;
	b=Dt8cOfpscJBqShW4WbY1xVMio6Pl56+REI7ActcuL23y4WD57nW5vvDpUVIsQITmeyJH+e
	dz9IGJ66H7EvSKDwUFvHVZsaLxHZFElvJhX6qGYqsbIprqiH7pf3zWdIBe96wqU42/P+Ov
	es7OBmBOoA1NyyFTOMOmDAXdL+LFIt8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y+33MYuG;
	spf=pass (imf08.hostedemail.com: domain of 3OSIXaQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OSIXaQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763123771; a=rsa-sha256;
	cv=none;
	b=RPl2duTiVA5H/AgQw4nQ4wNGv0olBUIcfaGcMZP9L8ZuaNLmK81GZjwGSdsIpmyLIeVO0L
	lOHiTI1RFEi8L2wYc8m2TsqNgdz9meElSgsQbm5zEoUW4Kyq8OBN4Tr0+nwR1b/8Hk4MHD
	jRNrHcXiV4HS0f332nAvotTM9rY6HyE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477563e531cso17250385e9.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763123769; x=1763728569; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxQT1ueN0Bj88cVZcCku+VDcMMej+3QPEoT+7oXlEUc=;
        b=Y+33MYuGXJilOFJDqDznzkrdyQcF9quhlsx0FNQxvDK0Ynd8j5qLBe8S9qCzGBDx8Z
         /M5N08QQ+iW9YyJ9oHUftethsCE3chZRTiP6sEEtf1H9VSzwp19rdaYltI1GF2o2pOZp
         9I6mLRDUqIU2USZPf8xfN0vxRQb9RxHrobokgjvLnu4T0qfinx+xHqk5I/1jVCKcL62H
         URm5fqIsTby4y6M/WNuJrht/7rx5APbC/qj7BwztoSUra00vRejq31FMsWsL7TDsk//S
         dQ+2HzVBCnjZ6Fg+QbVSPJj3Rii+mjCrgT3MqphiFDq69WqJFlby+VsIb/nE45ROOL50
         CPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763123769; x=1763728569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IxQT1ueN0Bj88cVZcCku+VDcMMej+3QPEoT+7oXlEUc=;
        b=QYbBmqGJBwFogaCPULMMqtEl+dHe4mFt3SOqkY+1lpwa+f2L2hChGIRF0CwCVmSr9L
         Fp1+Misfvdurm2Q4ltAiSZuzr2s6BrjrT77+nfbCy+3AUV+nKWb2UDFXm03Do9IPdDoB
         b30xrlrtyeK8k5AHoMdPzLWj4DOvub55IRy1jO4oE1FDivHzZKVjrUtom/C6gAscQFdx
         lY/ULjvwD8mt1Lcpi+9T4EoTaOGDjKAbdwududMbP3VCMGGIEBY/9Y05ZSWIoiq+y7sn
         zz1ifm9j3W0UVTGRZQ1gV2GOLi1UvDtWLvAvF/69WWStqiDjRn07nkWLD9kp4E06iqku
         dweg==
X-Forwarded-Encrypted: i=1; AJvYcCWBO08qHAwNFdGWpMNrGSDkBEjOWNLyxmP/8tswGFVNaS9OeCbW0wnjrKutzzasq60MrarZyd4Ywg==@kvack.org
X-Gm-Message-State: AOJu0Yy0072ZZYidtEQ6Pv+7dnpQ2oZwkRN7efACB/GHO4Hig178y+ZT
	JovKlJ1JA3B/Tbo9w3UK2KMrRVaUVpZXqELX7uqKRI79AJamqx0jF9UCM6v4twzdOCG4Zj4QAlE
	TdPfINdIyyvLnTg==
X-Google-Smtp-Source: AGHT+IECtIVfoHR4KIma4m4xNaSR56A1fkqF050K07bUAlHAQawhC7HGe3mmGgV7rlzdWxH4OyA8KDgAIxJQhA==
X-Received: from wmpl35.prod.google.com ([2002:a05:600c:8a3:b0:475:d8de:fe5b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4744:b0:46e:48fd:a1a9 with SMTP id 5b1f17b1804b1-4778fea8ab2mr28900845e9.33.1763123769520;
 Fri, 14 Nov 2025 04:36:09 -0800 (PST)
Date: Fri, 14 Nov 2025 12:36:08 +0000
In-Reply-To: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
Mime-Version: 1.0
References: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
Subject: Re: [PATCH] mm/page_alloc: optimize lowmem_reserve max lookup using monotonicity
From: Brendan Jackman <jackmanb@google.com>
To: fujunjie <fujunjie1@qq.com>, <akpm@linux-foundation.org>
Cc: <vbabka@suse.cz>, <surenb@google.com>, <mhocko@suse.com>, 
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3A7B7160009
X-Stat-Signature: 6iih5xbwohaip3cxobhajrgxips9xjcb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763123770-250224
X-HE-Meta: U2FsdGVkX18N4Ywnb4NOs9C9U8/3vIl7VLNM9AOhggJJs6p3YmzqyGplwXdsHFmZ4+1HYwaFov7coMN+iODB0zpDrzo+Znxn2jSJqo+tCXWD6aWTqegd8x8pe6QzoogZiXeynzt70tJlOXmhv/JQxU/lUcdvwmRw+EUFgvwnErL5006cUP+yFMF5yBga5Ueu2Zh/NXLFVwOjfD2iJyHcsaPDWXC8zeFz3uN68o+tHBLezcxIzCTooCjh0+65cdvt7SiFQ55QpsCoVJd4hzvxQqttCWgsN3ZA+VUW72xNc//rb5mvvvk5SPhdzVEW+gYxIEUO2eFgHGoCae+qpGQSiuNt8dfRmJmbMz5rJOMzFjpp28q5voEfAt8EwIH7PQ/ur54zepFA1XNdsmlTkbKjC4O6wSKFyBLwh+/2m4GJ7zyVRaGyK2oc+fcFcky56BNkA2ZDn5VXLGYNssqCVCueAystg0T91CVH2BP5OpjE8FwsrxZy/ISYtbJN7WwwjzikBlYJVN7rGaKhIoRNo+/LlZ9VxibuzCncVwuv1hlx48KY8KgRNY9dpF0ri/Ml9WhMULM24kuuSNqPWExG/nx8exLayL1lIGP3SrUvXkZv1G0oeu+BD1Yv7QfyzyLkbmWUI00SuOjFtWj/7aZk9bMB57osFI/EFTOC8RUUddCltRVt5yCWlu4Rkp2F8jrwiquMjgPXsk02fyIlK5wlrN2qBo2crT+3Dy5f3cF7n7mvsQztsMit4CZ5Qv0we+6UG6eSjn058aZedWkxERdP+xiRyOfgOFsC4MjBOlCSZQc7qSLJ8YP8P1grh+6XAS3gws1P5W6PMGVmgE8d9o7xL4jinIoRigUZ4Tws/JOzWtf+hxPmmHFrcNJgRW2v3Uvryxwmvt/u3yM3vyxPct9sRSZHyKw2wcnlBURskuWbaZ+Zk4JqTut3nYDb3CTWlbIjRIzfNTyVXH6kj8AqwnGY5O0
 gSHgvMGF
 IQXVLEGBzef8P6qJf1RgkRIUbnlODhlGAMGF9kN84+HGtNARY2K3aWGw+UyelRbikU9Xkik/aj7zCRL1N66ALtFTp5VOZF7VW4SO4EnADogIfS31KpakM6yp5/vNbpcj6j4TrTzoSXVwhR0sD2d9vGPpEraX4RLRZ6QKp9cncR1eKdxufLLoaxU4+hNyrvdz/cNxkKY7mPgw+ODKlGP5eEjcR7CNw7nD9ommepdlRz8xB/xVxniQKrPICiEp1QY9yvsbJAEbi2VRf3K8ne9/fL6XWY0XXfJEI2en1DTyXVK8lQGp1kbW2rPZ9noFwONbwkHFASR7w7iiml6BHuL/xONJcUXvhqWGGDIcp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Nov 14, 2025 at 10:40 AM UTC, fujunjie wrote:
> Although this code is not on a hot path, the revised form is clearer

Is it...?

If people do think it is clearer, let's at least write the right comment
in the right place. Instead of having one piece of code
(calculate_totalreserve_pages()) describe at a distance the behaviour of
another piece of code (setup_per_zone_lowmem_reserve()), let's describe
an invariant of the data ("lowmem_reserve is monotonic, up to the first
zero value"), at the site where the data is defined.

I know sometimes in code this complex we do need these
"spooky-action-at-a-distance" comments but this doesn't seem like one of
those places to me.

