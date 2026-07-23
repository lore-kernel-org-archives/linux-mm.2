Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AABC531D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2466B00A2; Thu, 23 Jul 2026 10:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B6D6B00A3; Thu, 23 Jul 2026 10:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649F46B00A4; Thu, 23 Jul 2026 10:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECDC6B00A2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB287804D2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:14 +0000 (UTC)
X-FDA: 85020278868.21.D684BC1
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD6B3100016
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FDkKWlB5;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zAg+xMWc/xZ3o/AF2/ksssRntRxa3XS2KXW4/UcoJg=;
	b=lkTsmoRJkoAvvhHZTgbnrs4nErXNCPcHPzlfZnbMJSUX6del57f2d7mNqgLEkQQYApVkWw
	h5J1UumXKRShKoQPB2zRyWdkgCfj5I4//Cbh29TYuIX11ksglSW0bfxnakNCvEdc2NKh/q
	kfZjg0nyiV9Hwc+gE1PJj7h5Fbzg33s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817073;
	b=snLcbHsfPq5aNB2u59yGrONNatYK2aHVfqzz/S7m3zn10RJVJRDGkSyTFM+7GEnU0+lSNp
	oczbjT0y6lP17+FB+8i8kvkELw/R5roYMX8ux0J5Dfv3wu5x8OcYkwIaBOdRJ84ZLemAwc
	lfVWdKRAxPJCVr//jzPRFXqnxEmfQ3I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FDkKWlB5;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-526f963372aso7007031cf.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784817072; x=1785421872; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1zAg+xMWc/xZ3o/AF2/ksssRntRxa3XS2KXW4/UcoJg=;
        b=FDkKWlB555jE022hve+YmwjzW9yC5f0vJYUokusOdMfGtypAqlcav+mw+t9Ji1XKab
         uWw7Kyg3m96VD/U4b1eujA+OeT0ymWfzwL/fSvoL20H6m3P83R0OuujO126oLLwUBz8F
         CXrgSozYBzVzM/LknU0K2uUNRxcQ0xaOCpLRAskQHR3gpIohUS1IdIaxOzuvLy2pyDsq
         hcg05xn/YHylx6EJV/fFJ+TE6yiwFVxxZk6k/EzF2LkoFiQOfULYZQuGN1a9AVukS68S
         ciMhvJ+8+LWYmjxnD42cUpWw0kXvJgnNKwRx2Q6vKPy/xbd3ptIv8J42LK2iQcd4Fx4R
         /Cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784817072; x=1785421872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1zAg+xMWc/xZ3o/AF2/ksssRntRxa3XS2KXW4/UcoJg=;
        b=YS0ivUotlTj286qDk5obo8PKlm4zVgHRZLNemawfJWadELKPygjhqAzbAzlBv0F9Ao
         c+xIbk+CQCMGC5TTpa77pmTbboSWDsA244DOpB9LIy8JohcjQnHaH72ICKQ0yJ9T/zs6
         Lp2e6hQIM30IRuxNUqRIlgvNsYzFCZ4TBXSdd2HoXkc2r90g3jq2Li1gPr28vcrqBjAz
         YrQlWF44IciibkOUVr0+Dbl6KUMgZGi52byE0QR2K+x7e/pWxtv0M2Yezau0u7vj+sDZ
         iKhVSMh9eBlw8alIl2zby9S4uGIqRbaIjIKPAoES7zY9YVm6ilepI/3GY7wB/EiiKxWw
         Fdbg==
X-Forwarded-Encrypted: i=1; AHgh+RrxyKg/O2/D3toYai+3/+/TDxTu/61qi017Kghzb2915SHekiQ/9wosaVVNkxvNiB8ASMawHkkKPg==@kvack.org
X-Gm-Message-State: AOJu0YwLabsx1ZpMLQKexpy++0S4t8DqD4RCyxZ+amCzF5cULVC0Dh65
	kp/pWonaErTLbiO0HgXA3legLs3/Q2ESJ3+xkjoqRzY/f6dOrVNYBSy8giXuRsDj+f4=
X-Gm-Gg: AR+sD11DmBR1o0rs35S8KbTj/jL9dbIQkZYi8Ut1oP1GnXRv+HLafK5bDqjftZ9uWpT
	09HwGdqyX85IKqw0Ip1gdQ/guyGgsjXnu1Ki20FbzD+ymicOEpGN3J3gf68Fyne/eKXDBT1pvix
	PFCfveYSW73jK9GqYpWxViJwHszUHT3j4VklsOZuug3+H+ian+KMPJrIqr9zHCNaI/bDC4MFWxZ
	DMgnKHyvrArmwJpSoZZJBl0e/Rqqd9Tegaz5OqZx8lFrXtsGO6jb87sD/mMdxetR4iXWvUofC+/
	vodjlVR+umL3DzA2N6ewjKl8mebS9bdVOf+plVkxRtNxW73YbQLyafIJperaEx10uuKfNOLy4DY
	Rpy/yqbQtyc8zFKdNTrTykBydzeoAOyr01EDlgabpR6D4i25w7cdO6cs/S9Q80uJ3+VdToAObRC
	7H
X-Received: by 2002:a05:622a:1196:b0:51a:8c97:938d with SMTP id d75a77b69052e-5283df677edmr29089161cf.68.1784817071384;
        Thu, 23 Jul 2026 07:31:11 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a4f11fsm424226585a.36.2026.07.23.07.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:31:08 -0700 (PDT)
Date: Thu, 23 Jul 2026 10:31:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: h@yjaykim-poweredge-t330.kvack.org, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amIlqHQ40baRoz3O@cmpxchg.org>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <amDCIl51NoNPL7Op@cmpxchg.org>
 <amH9alaO97YqT8pY@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amH9alaO97YqT8pY@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD6B3100016
X-Stat-Signature: heg9mqd89oo6qi8su8zdaixm31yrcaqk
X-HE-Tag: 1784817072-458764
X-HE-Meta: U2FsdGVkX19qeSn0fHgZBMkS273ar8ILWamMwH3lPv2C+oapOQz8IqSaouLnEpPn5MmjFBagSQT+b6QhQH/sugToQNUbjb52DY+70s1+lzCcR8KCKX1ruLMutbIZRfEs1j+PrCotH1UQyuFvTDut6zMeBuV+vcmsYv/HbxhfX/PAORyJ+cmh1b3D7KmQYsKVV20dFDrACGxfgy5BI6Kna77fSwbhXRcXL40tNy1oKWi/J/zCxDT29kB5z2CgyF3GHE3AsK8fzfLLqSZ+ZRT8mAOuxSq2+5GU23D4Ek+JV/nAsALQWlNYhFbVvQIEJbbUt6tyfdiZCZ/0V2QWK6mcC1wQKe/X0K0u8QAfScY3sIMvA6UlguSmICdNSn3W8dDfqh/CHQ7sZpcpsuBvw1T2EvaoTRJ+KZciG6LkKOW1H2XqgLwbwJPeD6XioZ2+UjyzK7h70GURzVNn+XhKUT3uN9734G8UGv4j/ZjPl13o5OJwlNzURKwtZ4KGt8GpBiqrIenecgXxPRfkOuJVERsFwSRZgWEpESQnozjD7dS6zDgLLNBUGG1GllFCp81mDk1Ng7uxqhmMLVh8RmfdKIPuQq0viz9bRpsydNc8L2vPZJ/gtGoAZVEb8E1XhjvtBsSPAfo4FVMuFC9aHmc8agDaQVSyc92CGVQlJ/ETf1R0tfki/R3rPaxYy/msmiWcPDZcYfKiwYNqyq9wKkY55stcOzwAp4WNvCM9mduIeP/2PQdvkT89Ydl2tnghURLEDOyXy5AV3L900K6HsrzkLIWTrK1Y2431MVA6zKjuSTeP0sMqDzkAQpn/RJQ0wMoRCj+yGnUAURhQQotRncyCXGfriYIgJtqGgoEWeaSOSPfk7nSG6rBSrBYgRtIFlS8XxagBBBrAtZKCGVMFPbeXACxZyN6JIZFoKQNr4HEQJpdpiAykExVLprW0HpW04FaNrMjLWK8OWBNvp2Q31XoW8Me
 RR6jVZ/z
 xqTChpsYVAJrTRE6R3N2Ju0DXg70od+eYq2/Lmwqe2OtQDFJv2LapgHJGnRqu+c7ZtMaIy6mwAE585qlI63MnL7yw0Dd+lpjBY/x9voIVd6JV26rSODaQubD78nK+W1JykQtCo+3mUewARe52dEU4nMBhlz40ca7SvGY6ggIYFrICdqtaIx/aueboAyM2BMwZpIy0+vLWkh1X9yAculu5cacKvsnIVKT2TmyicADwnyNA5Cn3P2EJabqqu5lyKzbZJrFl4AjRCLE5ohc58MHx2ws43elY+jMSkqttKYL+03Ayvo0UhJ5JG4CYhwyzqAd3ubfmA6jTt6iGsTEAJADjkc63HU6Hvn1NddoJPWIr4u659V8puLdE3d0h00TQB27YUMlhE6e0nYpu9Y/tYts3iZf8EMDs0TZBfy6Gw9VVim1WNLgt2IG10UOcV9rx3NVZo1qpnVSOD+f7drzQ5gSCqkPAXgLtK9tNLA3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Youngjun,

On Thu, Jul 23, 2026 at 08:39:22PM +0900, Youngjun Park wrote:
> On Wed, Jul 22, 2026 at 09:14:10AM -0400, Johannes Weiner wrote:
> 
> Hello Johannes!
> 
> > Zswap is a first-order swap destination with writeback semantics. The
> > way the discussion around zswap has been going in this thread is
> > disappointing, and I don't feel comfortable adding permanent user
> > interfaces on this basis.
> 
> I have given this a lot of thought. First, could you clarify exactly which
> part of the discussion or consensus makes you hesitate? Understanding this
> will help me re-evaluate my proposal.
> 
> To make sure we are on the same page, I would like to share my thoughts and
> vision for the present and future of the tier interface semantics for your
> further consideration.
> 
> The interface should provide the swap amount allocated to a tier and allow
> the use of the swap device defined by that tier via swap.tiers.max.
> Currently, it would only support 0 and 'max' (essentially on/off for
> explicit usage). Auto-demotion is planned for the future, and specifying
> exact capacity limits is still to be determined. (I have also reviewed
> potential interface collisions and duplications based on Yosry's guidance.)

This is the part that makes me uncomfortable. The interface as
proposed now is just a small subset of what should eventually be "swap
tiers" - with limits, hierarchies and demotion rules. It seems to be
an unordered blacklist/whitelist for swapfiles right now.

And how the final form looks like depends on the indirection layer.

As Chris says upthread, virtual swap will be a whole new world. But
unfortunately interfaces are permanent. So I'm sorry, but it's
premature to start tying us to an ABI direction here.

> > We will not be merging a memcg swap tier interface until the swap side
> > has a story for indirection and backend migration.
> 
> Regarding this point, is your position that an indirect layer (I see
> this is virtualized swap) must be implemented first?

It is implemented. There have been patches floating around since the
beginning of 2025. Initial proposals date back to 2023.

But we need settled consensus before we can start adding interfaces
that are supposed to control that very layer long-term.

