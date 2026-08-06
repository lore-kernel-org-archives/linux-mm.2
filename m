Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF6DC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13B96B0099; Thu,  6 Aug 2026 15:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBFE6B00A2; Thu,  6 Aug 2026 15:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB396B00A6; Thu,  6 Aug 2026 15:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78E3B6B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:28:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A360C01FA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:28:37 +0000 (UTC)
X-FDA: 85071831474.22.D027D81
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 333D8100018
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:28:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=u1yVr8LC;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAupyRSlhOTRn+BAvQFJD4SahBYOrBgIWCm1aWD3tZQ=;
	b=2vn9j6pnMY71fjgIr+OdEaRoktS9y3gSLDcbnCtfbA5Z6jrvYhEgWa5ZQXQ8poz/HNpM5Z
	PMumjXluoj/8yv43AIV7T9PHL2Q9O4lBvMX2nz9usL4Rs5swP7iRK5iB27HXgLGoXkaMDE
	m8QsJe6fcwioqVn03/UYLoD7878RKHA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=u1yVr8LC;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044515;
	b=xkY1gbNzfgAvj2AEiEC76tpHdYUkd/Vud67xeq1egU+yv6coooeG6hrRyZSD1fdIksPslo
	SVMmWqoCEutioz+gW9wmns5LLz4bX65Twwqp8a6eKN/lNfqLQV2/JZ6U85+zBlADkTxTTc
	WEIAT/BplOFGl4Qx3ddCfRY0BIOtm6A=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e08baf860so2446350a91.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 12:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786044514; x=1786649314; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XAupyRSlhOTRn+BAvQFJD4SahBYOrBgIWCm1aWD3tZQ=;
        b=u1yVr8LC4KimfTS437mjhj6eDGIVcxZwCqwT063rtO789YV6tcJdhYL4mbb0Uya3Xr
         ClRi/MV8eisHaelR4MGhsAe1Wt91BltDyTlwwEG43prRTA6GUZ+4yfGFZLjmth9VIu55
         xcTsR7tQm077PDll3Yg91/DQvjgHZZnIa4fhtAH4NrqLwerTnFHyc9NvXF0H3kGF1yK8
         IcR18dplb/adBHaXtxhb3YjG5v3DASnfq8aWutmYj1NQM0qxWeOtNs7NAkKGpAYpb77E
         ZaUeeshwn70p1QmlVitoe15/U8EtIpblZenfRnvTDHB7W8T7/zRLFJMkkYy9vqZB+Lhj
         3wmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044514; x=1786649314;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XAupyRSlhOTRn+BAvQFJD4SahBYOrBgIWCm1aWD3tZQ=;
        b=YMzf72ln3QrVAbvPnhDCVpqR5sojFsv/nvn+xiZHaovaQYiN8GsEbRmOxCcp3RzhjN
         3226kaRI5kLEYcTTiIuUqnTM4DCxspYUw5GHdeINQsH9mqE83ExTWcV6CHbJ2bqoPq80
         brCRbE1KBQsvjCoP9gB+mivknOuDJXyXMjV1eNACsGPYUhPjS4IuNvEzr0uG+HQUxDcm
         D+JJDLMmnz6XXWP6OEfhmuQ6Rb83VQG+iCWL67JCOdqrFPRJLrd8uFqcZxoWU+nVRjKt
         LpATIzzW28wc2OoRCtJ1F8i1eV2lFwpU8molSvy/HdtP3KzjxxtbpZWHFOGH4TLlTrCj
         7m8Q==
X-Forwarded-Encrypted: i=1; AHgh+RoXne+LN5utbc5XbDDXTRWCQz+MQifJKUt/RY1rbb1XQl1/Mw1o/ZBfP64/dWYsW5Vyq7/OLdSOWw==@kvack.org
X-Gm-Message-State: AOJu0YxzuAwqVTxb5XxI995vSpO/snJZzU5YJTc8iDB8HJVUdjn19oqS
	1zBNJ1xL9cMzpFa6cNsG3WdcW38YF+JWSb/986CI0jFEIzggzhjSiMD9fNnJpuHpVb8=
X-Gm-Gg: AR+sD13DMuB6rgVSghjnnKDt/hjJ4wK8QQcC3eRIHB+Pw+KtXG/vITB8yI7PXvtQn1P
	2kmtpKBkBu3Q19pcZ6Syziyhyi4bp4tcQkB17653OAAX4P+bnwiHGnpw4pjQE3eeRnuD7ih8sW8
	OwOSmNBJx0Yjs7QyUARtx6kWdWq+q8nDVRfaFiAR3QJRu4PHvGQRowGeMvS1jSd4Z8COna0eBFz
	hTnlGFTdDWwlluirmxU6G9Jq1sBwe9wIjAnYuQGYObcMmBtIyRaPdrJxwndwIXB2n9MAVowWRyS
	QZnb5Qwf/cfCH4mzSU+jacLpoH6/IBun1SELF1Oba4LX3m3fC7f+vy46gOC348QFArFy6wT6aKc
	+tfLnV7J23TH+Za2wNOnRCKinsYUghb3EdqIIDE+7V6tQUnMSzqZGVZk/ovsLecUXt7B9Xuk0yx
	ZugeSdgWdHsR8Px7GextkC4UJoAKy0d5dB82a63Yg/AfNRm6dqQbzR5w==
X-Received: by 2002:a17:90b:4d84:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3903c5dfd9amr16227009a91.18.1786044513998;
        Thu, 06 Aug 2026 12:28:33 -0700 (PDT)
Received: from fedora ([2607:fb91:201f:cebc:3a68:390a:144e:1b87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867bc261sm30046801eec.28.2026.08.06.12.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:28:33 -0700 (PDT)
Date: Thu, 6 Aug 2026 14:28:30 -0500
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Message-ID: <anTgXv9loeo4U6YI@fedora>
References: <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
 <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
 <anS6hcgMkEJocbDJ@lucifer>
 <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
 <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
 <anTHABoAYVUn2XiH@fedora>
 <anTHSfP9Eq-2-Cng@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTHSfP9Eq-2-Cng@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: kqjhnububizi5y7uj6zrris9hwmuzaez
X-Rspamd-Queue-Id: 333D8100018
X-HE-Tag: 1786044515-110891
X-HE-Meta: U2FsdGVkX194pbVFWdp9aiv6TgMxlnnJECLql5vxrir+1ydlgZDmvP5ZPvrnl06ul6Hj2klHaksqZg8azBg0076I7aBH5zkMU4UcEgrEoXpZY1RQWP3ZFF929NtLHlKy0030Gm5X4u+52cym0PN/qg/R17J4fl9HQQAaihccmJZl2+tHtHiJoj4glFtWzTaCWAlfnVRulrM64zdMpMEXxHr9QBPTULbqtdgLcuzRTLuRjNxptdBStd08cKNn7jM2Zj5X9mV7qRBRluja+rFT6uSchkDVHhRLRSaZe3o8fNEuP5pICiFORbkurf83JsIrgWTZklwgiVxmrR1CNabs5PcYdDRBK59QAAzk7uJDJI9NKBpkeuG3Kl/XBoAS/67gov479SDHluH+tl2uP9kGZP3kGpKDWpWdpqY34tCPBfKvTw/mjz8xbRN2YpgB9kDtF5qsscdRMq3RjRzK70TBtJ92QtOn6clldnSHaosKx7o0/PKKTZ1+GHvJU1E8tDVdK4/bahAmAIW/GvlrNqb6Apkkm5ra66Lh/l7Vkz9rMr74KDgiWDyIGYU7/bw1cwRzPeX8qUoJS/zERGQOwramXEbU7lT+L8/95GiFAr8p9kk/Qj5PppMkR8FBTSVQcV7NaqaztQ/v4la/DoOpxDnhhcHBvjbFNZ6WACplPYnfmyc9x9X87LGZnHBeNI1MIQ63alXneGSDt9JXEs49IndHYrtGhJ9ou8vFKtqxdlfUExlE3GTk0g6wWuCClSZsmkcvziPF7hlgU19buSiiRMjlynfi9tjKcLrDAYTWZdU5oH+SmlHKdKRpYCaDMyQS/mO2mGzeQi7IA9UOex4XizPPeWe8EF3dkxmHS3orTo6sbl1lhJ1yiRPqu+ynnGmavXO/+vyLbna33gnj/nUiqUc12VIwIOPvI7sJmMriBWfv4fyMuz5JFd90/5ZvDZf7vitH0zk4WFOBjZN+MrV5ulP
 jKECMMxG
 08uByA/DBaC3UECkxFuuDdyI81Iayoavmj6/Z6fPByCWZjZ6O2YiuWbSBwbBpoW7Ra2gh5nl5OkPGar2vijOAlTYhQGrBI8n4wXYPjtUEknnqeu32l1V/kiwJIobiO2G6VcLsSYAHLXLrGmrW2M/Qguz0tGdkf0ehamnj8ddLjhUFdb3KfZNUBBdDtTNsLTJQIcTs6Yja9V0g9nm53AOHFW1AVtCgkFKLtSVNfvLiddWKfTtnvZhVpVZkjzgQmlM+UPCs3FqwvUR9wixN7M3dY6cKJ789tIuiL92VI8OrWNKsDdVCLp+VtexuWVoHwC4cYh+Yuhu+xYjwdSwEAjEKmw12OmRPPKe4iwkSJTGqYsUWUptMP9eqjgAucg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:42:49PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 12:40:16PM -0500, Gregory Price wrote:
> >
> > mm gets everything
> > mm-review is curated from mm to reduce noise
> >
> > Maybe would have to leverage a model though to surface critical things.
> >
> > Just an idea.
> 
> No I don't want slop going anywhere, at all. Nothing.
> 
> If you slop the reward should be silence ideally. And certainly not anything you
> slopped going to any kind of branch... :)
> 
> The slopularity is upon is Gregory. Behold the desert of the real etc.
>

I understand the sentiment, but then we have to reduce this to practice.

And unfortunately, I'm about 99% sure that identifying slop is rapidly
going to approach undecidability.  We're lucky it still emits em-dashes.

Unless we plan on converting the list to semi-public (which feels the
anti-thesis of Linux), i'm not sure how you get there from here.

So the risk is - do you over-bury and make it invisible, knowing we'll
miss legitimate bugs and fixes - or do you do something (anything) that
helps you ignore it while still being inspectable and curated.

And burning tokens to fight tokens is just blatantly a losing battle.

~Gregory

