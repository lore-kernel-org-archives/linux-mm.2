Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F0DCA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3CD8E0012; Mon,  1 Sep 2025 11:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ABB28E0003; Mon,  1 Sep 2025 11:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8118E0012; Mon,  1 Sep 2025 11:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 415058E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:33:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18EF51608F3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:33:28 +0000 (UTC)
X-FDA: 83841075696.17.53FC4CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7718C20012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:33:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QfS1/253";
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756740806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrgTQsbjRK4plaVS2IeLRNEJop7nYsHFeJcp7M6qYU0=;
	b=oOT43acHfkZxEQM1riOTYY4s/wwM1VJROfSVDexqvh1IRxAiOMKEUUt9dMngqIO9g2LvNv
	svcbZIpxPPFQa1EB8e/f0W+t+WY/Rjl1fPZqDyK6GHt1dg6Yx7SXxkHi4FCdOzLwJp67Z1
	JwBPC3JzIURocqLwOrup8JaWmFKD6Ms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756740806; a=rsa-sha256;
	cv=none;
	b=VFavpOigDz8+jgj8GMgqaykER6gjwL1RkNy5Ke0uii5yDPMpFX3bYLJLF6+WyICirvoeLp
	v0O74T3MQlGogYr6ZhjygXhcKuVjSpseSF8lIkNtEH1tCHXPNxd2o6abpEJS510GRDb+yR
	5dvONbGWgCWYHrgEjMrPRPGn0I+v4NE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QfS1/253";
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756740805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TrgTQsbjRK4plaVS2IeLRNEJop7nYsHFeJcp7M6qYU0=;
	b=QfS1/253a/ZjeKDKHtdEGXlEm21yEv/Avzyw6HIqQxKq45jnExjR6ISlos0THZT2YQxjYh
	uh2DIT1B9CP3aNoVxI5+spBTvuIlulEGcK8ZoZEBqscMsB2AnqqMgPyUkgCY4Ucf07ePsq
	9p/VNKb9X4JIMqiBNq7xzEsIRUNsgBo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-at_GCWa8O_q74nhYssOPFg-1; Mon,
 01 Sep 2025 11:33:23 -0400
X-MC-Unique: at_GCWa8O_q74nhYssOPFg-1
X-Mimecast-MFC-AGG-ID: at_GCWa8O_q74nhYssOPFg_1756740801
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B774195609F;
	Mon,  1 Sep 2025 15:33:21 +0000 (UTC)
Received: from localhost (unknown [10.72.112.127])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CE9D180044F;
	Mon,  1 Sep 2025 15:33:20 +0000 (UTC)
Date: Mon, 1 Sep 2025 23:33:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
Message-ID: <aLW8u1Lvlcp5Y3tc@MiWiFi-R3L-srv>
References: <20250831121058.92971-1-urezki@gmail.com>
 <aLVyia16eyoYftAw@MiWiFi-R3L-srv>
 <aLV0JrSPfitu1jFV@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLV0JrSPfitu1jFV@pc638.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7718C20012
X-Stat-Signature: ea3isx5dzw7e17oo8oeambzs4zepy1tt
X-HE-Tag: 1756740806-168280
X-HE-Meta: U2FsdGVkX1/b8Gyv5afdPSOVBEL7zluQEeesmPMvkpPQDwt/2A5JBjCgEJS4tR6e/l4+SGmJl0r8+PjnHQnOZRVoISzCPfLxwdnAYDpwtu46iXPC3JoyRJe4Hd2fPU4IJPKSi4YNuND0gVZ7sfjKKm4Fli+A7+lV8eYeycHJ66EMd6iGLKXhjcg3wHLoWsjhPWoeRde1cxukRIW0gIwipzRLpZ8R9kybLmkBrWso6PrqyQwQuYEwou3RLBk8xPh12CtcF8UmxE7kBD0sq8NZNWWl2lB/dYZ0X7eHbdx8SLM/uToTLSC006ys2PvKdGGL++P1PWZEXVFAczWEar9bn7eKhHUdb1gjNrmyqP2TaY/+m8OejSyXh+B1Dr3qxbehWu1bLS08ob2ax49iO34VwjCmhcPymQtXeo8g43zb3+/XwG7swwjg5Zjdx0xLpSmh8LBvNnAo39RJYOiYHg3UlhkMeniu77HAIr9iquvXE92SLrjU2Wlrk4sAk1/pftCI69h44OijUXbta8oRA3e4XZoNrjU05X2sMFced///30o8PG/vVXfACnpBykcFYyplbHabyGC6uxvEi+PUEABkASOR4xF8xq3urAc82fOQt2q7krqEdmWZkM19be8/Z76kXsNNXXtadWbbeEhFBbHrlDPZWq8cg9DGyG+O9svEI4hBkj227BNvTDU8ib966F5SjoPcmz8F5LHihFKZv49qo5Z7T6Ppz3B6mzl41EOns9QQxSYqqA7j5ELIv92lP1JF3+LVYHeo7YvaMwrMoR0GvkeEYpfkw6SvmDGJ49cRFov590U2or6qtHLr0NtAHWB9SED4fytcdkr8nPHo6BttCyrqK82u67cOFe9eFhV4r2IJE7Wb2u3XHIlA03e/r8qABow79A9pcWNUKma2Tk976G5IOVGowLJbcn06vkWZnb6iGBMs7kNEuUTyOTkk5FMB+7cpRUZ8MSQOFfBxE9T
 YdeODsiP
 F/GjkHPL0kKyOCQLZs8IeSg6+EZQQJKRdexNTM4x0skKue3xvaQptpcGkbQq2mcJxIV/QhI1byyfpjj1FCR5lbJBjiO4CNDi4Cy49zQAKpHYDaO0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/01/25 at 12:23pm, Uladzislau Rezki wrote:
> On Mon, Sep 01, 2025 at 06:16:41PM +0800, Baoquan He wrote:
> > Hi Uladzislau,
> > 
> > On 08/31/25 at 02:10pm, Uladzislau Rezki (Sony) wrote:
> > > kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> > > and always allocate memory using the hardcoded GFP_KERNEL flag. This
> > > makes them inconsistent with vmalloc(), which was recently extended to
> > > support GFP_NOFS and GFP_NOIO allocations.
> > 
> > Is this patch on top of your patchset "[PATCH 0/8] __vmalloc() and no-block
> > support"? Or it is a replacement of "[PATCH 5/8] mm/kasan, mm/vmalloc: Respect
> > GFP flags in kasan_populate_vmalloc()" in the patchset?
> > 
> > I may not get their relationship clearly.
> > 
> It is out of series which i posted to support no-block for vmalloc. 
> I will base a new version based on this patch because it is rather
> a fix.
> 
> It is to address and complete GFP_NOFS/GFP_NOIO flags for vmalloc.

I got it now, thanks a lot.


