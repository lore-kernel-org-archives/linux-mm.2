Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F353FD6CFBE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669356B0397; Thu, 22 Jan 2026 23:21:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637446B0398; Thu, 22 Jan 2026 23:21:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540966B0399; Thu, 22 Jan 2026 23:21:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42F8A6B0397
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:21:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93C7C13C825
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:43:43 +0000 (UTC)
X-FDA: 84361380726.18.1DAB4AC
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id C89A91C0009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:43:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CUwrWJCg;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769129021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfDbc/em5bjOki5V5/p4q24wfcBoeK7m+V9bweSJP5A=;
	b=zZ23+zePy9NpDqAJxF2yPGUz59zjWQ74r3PYghC69xV5v76Qh7bVIZwBr/XiVt+yIwBr04
	9nDBKk8lY+aQqQaPaBoJgAKGRCFPNDMNq/tL6m/ybuI3FrB9K5crEVC2JV4tvqlSqOejD9
	JElVlcjqOHPLuRW9iFMpe72ZZivPNYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769129021; a=rsa-sha256;
	cv=none;
	b=kK6UOIBAlIeZL92Exi50xoQJ03DPG5CIPa9g/Hjam+Ywm1OEc1f13MqrfAei9z3y8Op3dS
	rg9LSj5Bjjge4w3uH3xTbq5z4PmMvtcGM9nKhGWU4J542n9KNKY/+Q0ck6XWKPSAF5PSrs
	lxPEBh9uzq6KG90Mm3/EgakGZacahsk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CUwrWJCg;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-894674a4c4aso36098806d6.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769129021; x=1769733821; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UfDbc/em5bjOki5V5/p4q24wfcBoeK7m+V9bweSJP5A=;
        b=CUwrWJCgFiPbca791Z6TQ/7xiWm/XkXdtpKjGuhARgxl046aUbMIBg1Kc3ad42umeg
         xmGx1sCPIafiRo1Xh8Kmx7efprtn7wvgarMmtuqWMSuQT+eC16fxchhG648C33OECcbm
         19qdcdj9TxlmBTQYFompfC6ZpIaYWbHD1v/B+8Sf9nTuns1mZz85xf/LOXo0PybnHW84
         QABrDWvoTgsCutQ/1XJYNZcPJ+B4/0Q1bTp/exXbF8WGXB4UiZ4dtUy/k+KX1UzUITRC
         bGknpWzph+Bm53OenwLezp3/W0VRFyyvciwcng6MJrA/AdLrx3wJ2ugTNbHCj7GRdJcl
         E1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769129021; x=1769733821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UfDbc/em5bjOki5V5/p4q24wfcBoeK7m+V9bweSJP5A=;
        b=rCpS4JAZLRDhtoQUJ9ZjfeoOkdE2OgheVvdftdB8LR42zvsiLFwl7HNeUqLpyK70Ms
         Y8D9Yuf/hZaD97RcV7pFidnJj5jCGfx2x6NoXfBJzuT6/G8LFJr+689gXFTENb58NI/h
         7Kx9yGbWQrH5SUy83KwaZjl3/f0kRTpHpXJ/jOXPpob60ITqQYava45kt/ZO2OHBRiqp
         SjpOYlhcYL/6iI9V9sL9e1rnG/IBNX/t6QD4PiijOGt20qbIhwA44etEoq0tD6JlGAls
         zsW1tSiNfzrGM/22ig3ztIpCoHHubsT9sHj2l0maM17sl3OJV9w6cf71jkHfrfl3AeZG
         sWtg==
X-Gm-Message-State: AOJu0YxB/zIpZnMUG9xdwi9Bd/7m9niXeuBOcA2aXXon0lbZqeBW7Otw
	nvh0rlDbnWb/aQil07ATPJOOaH4GHvgueKN38XH7J0mylaScbWppQIfemLs4kXBEU34=
X-Gm-Gg: AZuq6aLvFh1Aj8SurNHYz8MMNK/b0v6QNCYo4+um8oIzlyWSnQS/p7YDVqBhn9ofXvA
	E45LMU5oBC/Cwxcc+0Ks+uki1YvYvzt/wsrmDb+ZEQ2XrA93BjmG8CtJoQqjMeVV7uMpOqaS97y
	gHRQmHq60hWHHdxy17BL6BV+IHWJnES7ztIJ9559p2ZoJnc7C05wk267+SJor2aTZx+Sa+4as2t
	lp+S7x/3FOGTyRQiz655jcEbzR6XVeKadXmvftztf6Fj4CZ086q3mxP1CDoVrbMbc8ZA0a0UPgO
	n0JdA4FDGLWgp8cbsV60o6AQz2NIGthP1rqxsG+hJOkNtCw0nlfMb26AfFmDcW8rmx93brw5IOV
	R9pmUW8mZq10waSBBNolqJHq2FnXw1qTycpQcHAg25i3YipdcRR943Gu1ZsncPvzz1HB5uROStN
	0gXLysI435e/1CSc4gNE3mG+aX71Gaq+0ZnQLuQr494OvAs3iqoJCR6/MSFKK9MUsJWzfxvw==
X-Received: by 2002:a05:6214:f2a:b0:88f:d4b1:4c2d with SMTP id 6a1803df08f44-894902209a0mr21597136d6.60.1769129020746;
        Thu, 22 Jan 2026 16:43:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89491853478sm5521546d6.25.2026.01.22.16.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 16:43:40 -0800 (PST)
Date: Thu, 22 Jan 2026 19:43:38 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
Message-ID: <aXLEOjgVyGYAU_zk@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
 <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
 <57c5f44f-3921-478b-843b-877fae536591@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c5f44f-3921-478b-843b-877fae536591@kernel.org>
X-Rspamd-Queue-Id: C89A91C0009
X-Stat-Signature: e97tqkymmpgjxtxa5cisphcxa1dch3ch
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769129021-90306
X-HE-Meta: U2FsdGVkX1/RiVpVMF7DnwrJyc0D+gULJiPf7uxZzCqWCZd8jDVpYKzDaFqXroztAfvT0EPRSK0sSbYRKM+qE/WBgefTA4JG69uYgxeQ0ixmRyhfL3ZWyocotylj3xTg+p9qRSXfkmEPLcxM7QdGVb3yeBDENdXVhUVgqyl2lwVio2KOwfmFImtAGJPBxq5iTxquTUSesDgrevf97VBb6SHeQVUdveTqJ3TGbb+oFZWJt2Wt5zTZpGjxGZd1fPGydLKf81LdMQqzczIiuX606OHwO6WKUm9ZPE1VDv78oqpmVEbWzBKJjSCHEw9W4t07yFX2kdaQzQIuBZeaPFW+nIRaZzL7a7amL1hlX0QFmqMiNJ1ONzIaizgtUqg4almQx5tnUUbjh6S6bxIOw8he3iiTa2w6YO09yMr3SrjtDad8DoJ9Hyc0SPnnUIh4M/vovyqiPsSRqPMwoFLUn47b+BmQq2gasZV4ev8ZqiMobIu0rML3LZuHhz51sKm5ERJ8R6/G+MWigAEg+/k+f2JmywXOYP+96h5Z1pWDDoD6rOAFCVeIm+vrBf5bAA1tHG4ggzixjq2s4LvxksCQD7SCn2orsSY9c9dAYqR19Ky0/HK4NdjW5ZzZ5kAPOnD+XweDPHMkHmKE9ZM0j/39sI1gdd1TDVLZiR8zHRrnYorAUdDe8U9zU3uOLu3KEd/B16LKp4eLGzsfhKHNXW0RNsKru8XRAC7zhr8MbItvASRXxLwGUL1sGBvIPVeiMtgeZF4bHdAd1LIFvtK9jND3ZNgFTj7UQTS2oZ/VZXsdYaguN1M9I9ueS8+jRk/4xCMRYGO8qE8solZEkQgvK4qzU24OC981UdNkloiYrI+thq59QNwsq2ByTIORE9uocD+QH8UxcZRA75UQJmyHfokJzfsoezyl50Nk11rsj/urRuSF00KYPvUpKc1ZzSYVOHiJr8mgxPP20b1pybyK7gs1+pi
 akDeQU9i
 rz9r6H+vFNaiTXysjAR+rULKNpkDxELTFWyRbjc/rs6u9xuIGE7GS3EZGIJCHp5e1YmIxMeU6hN3gARU/Wr8IvQnjnDdB6TiqV+++VeYy3/uXMhHeWHMAjEBk+ZOz1SDvdpBuolz5F/N1TdGgytD8PHLqaJieXAEpmOYnrfddvoqh/W6PsgpxvN/FW1akm4D1FVm7R1pmyp8OzVm7uf84Fo4NmhJi2KyWz56Y3wDKbL685d8Cf6n5l891L/W8whDDZZ3BniA8L83W1Ms/p/dL48Y6CUe/zLDw2/DV4KhieTrDEN3j9htOpyzZlbsuBI3txp20AQhYd6ug2Rg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:49:48PM +0100, David Hildenbrand (Red Hat) wrote:
> 
> I'm merely wondering why, in the new world, you would even want the offline
> state.
> 
> So what are the use cases for that?
> 

I don't have one, and in the 5-patch series I killed it.  You are right,
it makes no sense.

However:

> Why would user space possibly want that? [plugged-in offline blocks]
> 

I don't think anyone does.

This is baggage.

The CXL driver auto-creates dax_kmem w/ offline memory blocks

Changing this behavior breaks existing systems :[

> Can't ndctl just use the old (existing) interface if such an operation is
> requested, and the new one (you want to add) when we want to do something
> reasonable (actually use system ram? :) ).

I think we're in agreement, I think I'm doing a poor job of explaining
the interconnected issues.

summarizing the long email:

   cxl/region + dax/cxl.c + dax/bus.c auto-probe baggage for
   BIOS-configured regions prevents any userland policy from
   from being plumbed from cxl to dax.  There's no interposition step.

So yes - new interfaces would resolve this and the old interfaces
could be left for compat.

~Gregory

