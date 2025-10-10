Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E23CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BAC58E000D; Thu,  9 Oct 2025 22:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844478E0002; Thu,  9 Oct 2025 22:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7335F8E000D; Thu,  9 Oct 2025 22:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5818E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:56:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED9D21A012F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:56:36 +0000 (UTC)
X-FDA: 83980691592.05.F3AF7CD
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85633120005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:56:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760064995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+V6njfA+CchsIKhHVoblfZJHstWgq9ADH6BL8PwwxlI=;
	b=l5WE9bDUfj5rJ8ulHFf+S4nyWVzWlN5bhsqQmoeNu2GqEm1CdE6nm5T920pOLQDGclArti
	YWVH0wFIRd1YQTFp6nqzUAfkz+UFZ0XwacwpHexsowhDW4Qni6aEaf2LNkE+hGF1yQhRXM
	k1rBzsNi0LPgJp2MlqFs/gUHDFmGXLI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760064995; a=rsa-sha256;
	cv=none;
	b=B/JTCHsL0k67ESVGvY/uWsEZzcDLIoeZBFyA+xi6IRlRfScPqym0/KS5TFoW4ry7U6U624
	KUW2QJ8hSCFOI1MkOM+wFnJFmuLgYGCjuNxcVvVEclxzY0/svIHEd7s5tJGUpLxfU1L31q
	yh/wIWkBFB1lnveKATl+BwBSc072Kkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 10 Oct 2025 11:56:29 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 10 Oct 2025 11:56:29 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org, kasong@tencent.com, baohua@kernel.org,
	nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Message-ID: <aOh13R8OwgnGNryo@yjaykim-PowerEdge-T330>
References: <20251001043436.41338-1-bhe@redhat.com>
 <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
 <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv>
 <CACePvbVV7b+o4x04JS_SiQv1f8=gZv-fr-EhFT=AjkEsfg35qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVV7b+o4x04JS_SiQv1f8=gZv-fr-EhFT=AjkEsfg35qw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 68q1mt18s3ayx5iu6p4rmc4j89aguax5
X-Rspam-User: 
X-Rspamd-Queue-Id: 85633120005
X-HE-Tag: 1760064993-88992
X-HE-Meta: U2FsdGVkX18Om9gaXnJpw4QqE/SZ0tbjLK1IV3wxBykFVy2SVB2HhrGWsepGYp7UbUe6uOk8oR1/6YUCAa/qY9fa85GquUL1ch/5mFUk1as0PrO6tgbg0Bw6aUhogXf1ZYdeDnXvFDAzqFFXyR9XdTnzp6JuosdNhihZxZF5CWET/fZ/N+V2wm0mk4SBuv5/ztOy3yWFmUY8eDQQvPaHIrbdNMrJ7j5gLORR/3H1X5N2HHpeZOTvThsFUUU1I8yxJZNDTwQ3WhpF0MY8jUEAPS0ktlHYIu2XZg+VaUlTP8p6D62Mqs9sQHEl4dH0qcF7wmdSOPdZ87n9xqy/gUoFkCP8Mv86MvAxl2o0xd+ChHoxOZIZydLVX+DK1qT4W3Azmut20NQT+oKmwPVgYm8ehMX+VSY8rzM8gBLC39ptFVfumeULuRyq/X5gN5BZio2DeDxCCKheu2NgqpipSA4mD27myP107X853ovzSSuPOqOFWcu6EcRsiStS0oY3pJvcob99KgZL0sRylrkMuBItYRqcTkdnpZIqBlyrSqXMPPIgVQ95thIJmXGwnH3GdI0hrt0BD/L7hZNFi/CAgJ8ikjkGiEe90wgJfy5STOF2dD4eZ6l161CwmyVKx/gqCCKJuoVo/9HUbOss1o2ea2/Ihaygax8sYOyDWUrHCtU1KkTAWuafzYaefYzZVnSkA29QFPgfH6MnJgVUl98UVJmShFqVes/ZUrOBiVaP56C+WhR2bZQPsrpjOMDjLmDM/7V0lt0HSPP1WArV90mrbdpkRfno2KLBUZhlL33TOgcp9YQalF0ROfog4v1TAzDZRTCHR8/3S/w5Y96yFM3TJwnI3l0ge/hso1c2BtA6Up6zAqudwd8KL5mKHV36CMaGcH5SavOFg0OEiMFnwQ2AcT7xFYvc8tA9rq6wJhqZhuolvypEV/EnLa6Ug89QlIr4NTC2OX5uM/NUozbgysvyaw7
 ravcyri/
 HSs+3a9PcIoL0fCrLTcDjbPn8iKZ+/6Yw0HAAufoMTu04p04dL5WxV4sTbKkdvr3BTcljypijUGgLqI1h4VeB1DSeZh+OiforfAQvsgxTphbai4raVkZnSAL+Er2g4sE8jeUp+iIeo30nqejD3usECBvDrDHDk+Wut5NBphppqqgQBO5cxX1mOCZL29Rcy5EHOewOl7PkPbjVNxvD4J2FNlh1AoGquook4b5O1Mtkcl8p+bZyn3ONsCQwFU1BFUap+vK5JjLa9VH+KMDsSst8psgr40SYt4bI4gIG/tsBwv8FUCLmSlMonHB5EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 10:09:56AM -0700, Chris Li wrote:
> Hi Baoquan,
> 
> On Thu, Oct 9, 2025 at 12:47 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > By the way, Chris worried the plist swap_active_head could be reused by
> > the ongoing swap-tier work and suggested to hold off this patchset till
> > swap-tier work is clear. Now seems it won't impact swap-tier, I will
> > send a v2 against mm-new.
> 
> Sorry I haven't made it clear earlier. I withdraw the NACK because
> that is my misunderstanding of the code behavior. It does not mean I
> clear the swap tiers will not use swap_active_head yet, I actually
> haven't done that investigation.
> 
> I still suggest deferring this series which deletes the
> "swap_active_head". Wait until YoungPark's swap tiers to be sent out

Thanks Chris. 
"swap_active_head" is used on my current working patch.

> on the list. Let's wait for about 1 month or so, we should have a much

Yes, I am on the construct writing swap tier RFC.
it takes a few weeks to share on LKML.

> better understanding if the swap tiers series needs to use the
> "swap_active_head". We are not in a hurry to remove it, right? The
> earliest this can go into the official tree is 6.19 anyway. We still
> have some time.
> YoungPark, do you know if you want to use "swap_active_head" in your

On current version of my patch, I use "swap_active_head" 
on swap_tier assignment logic when traversing current swapfile.
It is efficient to use "swap_active_head" on traversing the swapfile 
in priority order.

I think about more on this part.

> pending patch series? Even better send your pending RFC patches to the
> list and Baoquan can collaborate on it.

As mentioned above, share it a few weeks later.

Thanks,
Youngjun Park

