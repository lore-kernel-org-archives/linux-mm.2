Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A6FCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017A08E0006; Fri,  5 Sep 2025 13:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31AE8E0001; Fri,  5 Sep 2025 13:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E748E0006; Fri,  5 Sep 2025 13:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6DF58E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:47:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A55B8160229
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:47:44 +0000 (UTC)
X-FDA: 83855929248.21.9831226
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id C7277A0011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:47:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQbXEPoq;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757094462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGdmOjhJX6hBoAVuN78EeIW768m+7wCUaHh9ZJvY08E=;
	b=1PZTi5ext3b1cvkXmciwLUipjnpaA7GWCa0tjdnza92CwsBo1owwVRT/odcbrBV1Tm9FGR
	O0uETdyFRl7ybppdgF8Q8NKQ1OXgGanXzZiKMvAVfcAfDP1Fu7kZzpDRtLGX4fG4V7Hynt
	e+wr1KPys2ola3tvnRwzgP/emgHFxhU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQbXEPoq;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757094462; a=rsa-sha256;
	cv=none;
	b=D99VkZ0nmoXdvNMGWkX3lfLQJoarpTuNrUbvhFgGB1Euuq233Ak3u1jrRLVzDaZPI1o7XA
	RZx6NMiFKy1piDn6kVYR3o1xPQO1xtjThAS/xIKnogamOvmJzb319bUmXPcu8Tw4MFBIra
	rPDRPJkz65/xicu+Er+JxR/bkfuProE=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7725de6b57dso2865752b3a.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 10:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757094461; x=1757699261; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iGdmOjhJX6hBoAVuN78EeIW768m+7wCUaHh9ZJvY08E=;
        b=mQbXEPoqfzhVQX1g+7YuxzhzBhAxvJJZSTFNtwWF9nk+nrUmpwlXcDtJx+1wpQrngm
         0i1NOtkMDLZg08jxRTZldbcnTxjw1ZHQbhMQhNUQWG9YG0ovY3mBuH4yiRsx/iKRK8On
         0duVx4vhC4uXSMqO7/BNAGqxtqa6keJ4VAoQ6i+Qy6m/BPn6aQ1lloDKCWDKCDvJncx8
         s8SbTdETXTC7SMC9sd7ng0a63HtvB/5pPhRenfUw2JIrZvkHY+JsYxvZAX+dPBOdVCvV
         Bikrh7NBMaOejiG6zJHESa4b4M/TmPNlIoJjburn9o4A3AhbX9SlioV204m14nX/HlaK
         6BtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757094461; x=1757699261;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iGdmOjhJX6hBoAVuN78EeIW768m+7wCUaHh9ZJvY08E=;
        b=DPycuuv4/zPpj6IkOWNbMV1VKH3xgFm6To+EIY3eJHj6vpLk8IXrjE0I3P9m1qXfQa
         K3OwmTp29cK6vDr1TUCOPOeE3OZcItCr0vdQJ2G7Di0pkSTwPXTPv1bqDM0r/4A46Dsb
         +ax0YL3jEuACosb21qSBaYXSfAph67owEipakdTC66MoCfQOHHZC1cxz5HhSW2F9sdd8
         914sPxEGLVdGbzFXRAAl5Yi+n/QtRMKtbwoxY5ZvKUGGbANx9xYqMln66FmJLEpLrFdd
         +kOhozuKvKtLFM/1jnvcjJDw0YA5Ryv+c8Lv10zZvS8ZiIEAXe4+Cv3bGjtqrxvLKYZp
         aP5w==
X-Gm-Message-State: AOJu0Yx4/jzpEVyqDV9ryJcMKwZAcQaFreA7WcVdpzsaFYz5JorfKTYJ
	IYOoaB2guWSbMXLPcSM/m/kx9+n19odNi2EetUUl8htlvDHLA9tJEdEY
X-Gm-Gg: ASbGncsuov5Yo09UWlTH3x86e1l9F7vwJQGAshwbjMY21qTGQuF4nZ4t2ZYHmWJa7HV
	kI52t5GIgkiwL0uVKijOi/qABjKkKoREo7idKMOHwqvFB8QrnG4kEuoAmfMuqWVaVl2SFE0zpYH
	iZ1Jk0CnoRzfAdWrAzD0XCUasJ1YLO1QqA9wqtg1XVr/nzho9iMsckKc87gmySfvR3FCE6ygWTW
	Ju60iVY7URpD7HZccX8GQ9x4nNbiTFr6ZGGOFy+0cmalIaKDMEbd+4s15C61/rnBsEBlkFyAqax
	JYGo+hMjv40p/YGWF6KWZPD9IiHZ5NN7NqpA+E22OCrJHShvRtxpGGda7xnX10Fq5stzX7xZtep
	NtjbG/onuJB1HCW0yGjfImyJ6e/RlIBPse1h7vJAYLE3BL4E5g5+Kz0tnQnaMH4O4
X-Google-Smtp-Source: AGHT+IHE2lRExnIyHB3Qcc28VDoQK8iZdwHIwmBowH0wlHh4c9ugPDIVctlxj9Nc+It2M+MIg5ro8g==
X-Received: by 2002:a05:6a21:999f:b0:24c:48f3:3fd2 with SMTP id adf61e73a8af0-24c48f34120mr9732610637.24.1757094461464;
        Fri, 05 Sep 2025 10:47:41 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4f8a0a2851sm12010238a12.37.2025.09.05.10.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 10:47:40 -0700 (PDT)
Date: Fri, 5 Sep 2025 10:47:38 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: tag kernel stack pages
Message-ID: <aLsiOvvxhJnTzKO6@fedora>
References: <20250820202029.1909925-1-vishal.moola@gmail.com>
 <ea48bc1f-7ee7-48b4-b389-c3622fc4d3d1@redhat.com>
 <aLiGnSHFJdaTpMc-@fedora>
 <84297d37-b766-4cfe-9c3f-bff1cb3cb4a4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84297d37-b766-4cfe-9c3f-bff1cb3cb4a4@redhat.com>
X-Stat-Signature: gpyi66ryoxqorjokmw8uj1zcgewwrwkk
X-Rspam-User: 
X-Rspamd-Queue-Id: C7277A0011
X-Rspamd-Server: rspam05
X-HE-Tag: 1757094462-205589
X-HE-Meta: U2FsdGVkX1/FN8uaUVJRXacHpxJeymk0dVp2yeWGZTvnTZFvFryC5WACPrfS94ZYZYmPB9+Q1rmiU0CIHsh/FpXiRIXdqlOe+uVdWAtEzSwlU2gc/7x1e8J0frT9sY1eS2hKMYExbfMTEZNoNMuvlfcWoMzpTZecPD9E03JBTNQBMKfy2BYIORql8gN02SJ/cG9L+L1T0fRPZmn7N8ua8ItWbl2eJxwkgQ3ZHdBxNR4/JyROVP7RpwG55pxbasiSZJ1yrlDCxknSaLlAsjLSufKiW4ipOUgqmC83b05dDf/3rqt4+MSjq31tHPIo0cZQyJJBC2ugNUDnj+nMHdXLqdFoW/u0oYA9hNL1b11zECrBMp4O8DR2RWAAU9ymAq6Fj07Z6wc/lBsi57g52RbH/nbL3KCGLdsL/hPlAhIX1P+AbdUFMrD3YD+yCw4dN7Hp9OcfmtqoYN8kUnhu30eENUOyli84WwUSOIqURH5pRi87KK2Oo+4hCXDiea4efYRrTtXZ9xb0pR9RYErGA05n64hPG4ug5OlO2cICHzj59yN2/vCe8P3d7qsouL8mwD+7fR3r5JAmWfqhmxvyVDMQnrMe+ihESTc6fgywJPBWYtZjXFN+GioydoRzfKL8wJSeqL1V7FRX+FAEWtj7GzuBRS06Wvg1V6kR5Z2vdDW5iD0qkX3aDS3RkM51q7S2CStmd+x+zrowCfWdftviDBcwj45rDYwcPi8JksZz1L3z5jnpYqzEbenLbb3Xhr+uorD8cSe88s794E/FptL1Db7tvcIfiJ4vkRmUUF4kDyzalY1XEOfzqemVj7Z5qEeLaJruYMRvW4QASDKezdcH+3frjt/BquI0xOTGJRpgKFADWkZDz1WOD5BCFtG7kCKmJ26kFs3za/fPh73LwFIh1gfuwQEBbdSWQMLqThge0VQ/VB2mZLjnnTOHfMZz2h2v6gAwpkUAZqDWvR8frW7BjI6
 qljrXTkT
 lCeYi/TMxUOZ+iF28PpYL8KmaX+V0BGBKmOI6apxVkgIlZdzbeXiKCdQIRaIfIYlX48tkzc+AgGOM/vKwtv4HcHMOTf57EvVZVGxAkonWDJ/IgpzWftRISK4FMh9QsBB0NeIDPY9CFOJYVzKJYBvos9E5FlD2lozEbbTt6i99SDD93mLLYrW8NOAmSjX7WxvXrYCFjMFYeoZ4X6HwZ8R7G8PwyCaib7P4YUmqM4vDyDepLDs/rSq84rhaPVawnHcTccSqH+oXeSSfBHa9V53ioiqvCCd1vyriEQ6gTpMjAtGvKQcslDweB/fKwAJ6YfOM7An+48UP63OPmO+Ke1jiMpwtO41YImN0cWD/z1Oo3GKyjfJrmEOCAblk/yrU6lArju88f6YQ6pkPX332q6a6HholUdUVX/DZ7KfClotWRvzN89P1tzkiFhK03AlUgcakPOcCFlQ8ivp5PnZAmJGoAnlwppvnnRiIhUVoHTFwXd/Lx7o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 12:23:31PM +0200, David Hildenbrand wrote:
> On 03.09.25 20:19, Vishal Moola (Oracle) wrote:
> > On Wed, Sep 03, 2025 at 09:49:06AM +0200, David Hildenbrand wrote:
> > > [resending my original mail because it might have landed in the spam folder]
> > 
> > Ah, indeed the original mail was found in my spam folder. Thanks for
> > resending.
> > 
> > > On 20.08.25 22:20, Vishal Moola (Oracle) wrote:
> > > > Currently, we have no way to distinguish a kernel stack page from an
> > > > unidentified page. Being able to track this information can be
> > > > beneficial for optimizing kernel memory usage (i.e. analyzing
> > > > fragmentation, location etc.). Knowing a page is being used for a kernel
> > > > stack gives us more insight about pages that are certainly immovable and
> > > > important to kernel functionality.
> > > 
> > > It's a very niche use case. Anything that's not clearly a folio or a
> > > special movable_ops page is certainly immovable. So we can identify
> > > pretty reliable what's movable and what's not.
> > > 
> > > Happy to learn how you would want to use that knowledge to reduce
> > > fragmentation. 🙂
> > > 
> > > So this reads a bit hand-wavy.
> > 
> > My thoughts align with Matthew's response. If we decide "This doesn't add
> > enough value to merge it upstream" thats fine by me.
> > 
> > Otherwise if we think this is useful, I can respin this with your
> > suggestion below.
> 
> As raised in my other mail, I assume there is no way to just have any stack
> pages in any kernel config marked appropriately (slab allocation
> discussion)?
> 
> If so, I prefer to not add it.

I agree, this shouldn't be tied to specific kernel configs. We can leave this
out of tree.

I didn't know a page could only have one type, and trying to handle that
doesn't help explore what we're interested in right now anyway.

> If there is a way to just make it consistent, then no strong opinion from my
> side. Willy is the page-type guard :)
> 
> BTW, I was wondering if page-owner could be useful instead.

Thanks for the suggestion, page-owner looks useful for playing around with
different kernel stack allocation methods :)

> -- 
> Cheers
> 
> David / dhildenb
> 

