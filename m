Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D67CA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD9A6B0096; Wed, 30 Sep 2026 09:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5950E6B0098; Wed, 30 Sep 2026 09:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB716B0099; Wed, 30 Sep 2026 09:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21C6F6B0096
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:40:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4586A734D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:40:43 +0000 (UTC)
X-FDA: 85270538766.19.9BEBFF8
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id C88C21C0007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:40:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NC0NCsWy;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790775641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eojcGFVlS5R1p8FpQbuCoxDLXSD0EodVKDy7T+pbRu8=;
	b=njcSO+vsQwuEqiPMKDFcMAcfP0YSequCmawuAl1KdvAy+xBHlUtwzjm6FFC+pUW+TCl38s
	epZzOy39YbbstxxLcpBEd/8lOKcXCwIPrdZmfOXfO4Fz7MfVF3OdCRlCtAnUTJQNWB+er8
	vHYfr/7pTgZw6UOU5YWXDeVxzeUrH78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790775641;
	b=kqfQ8zDZAcakJuBmjIm3xyT4cIpXXiDToJLIrlxDs9onDDObAIFinwSjii2ooz0CgRbj6u
	i14VGfrxIszDOdIdtIr6InrXFE48uKolsrHtUWG8+t255FwjRfmYoQgq3SIhztrpmXb8pG
	twrmX2GgqM4cCkGzSEej9HQ/DKU2M40=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NC0NCsWy;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so30336725e9.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790775640; x=1791380440; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eojcGFVlS5R1p8FpQbuCoxDLXSD0EodVKDy7T+pbRu8=;
        b=NC0NCsWyvID+PllmrpPZa7U8rRhSG6uvsfyWz1SwUUkjf0rgxX5PFG9vhQHJZ5iQIZ
         65L1rSewgkeVQlp99Q4rq32fI5CP5vzvlxsaYAYYXaIEyaO8+iVnG/W8gnqGcEnBzPdG
         xbXOPsHGoyjnxCuQ/hVcn3W9mn2NilzIRtmTstiOVA08zC6Igw30NBnvBbIMCRMLIwxi
         FfaSSc2zC1hzy8FSags28rl0olVnxS76WN/QZ6tc5r+kO9Eq0x0aTebZ1zYtqkZYGEaF
         QWbvW02tnrDSkZw1x8h2waNkyFZP5UFFedhPx/j2jo+tyhZNDKMqjEVQkO0oKGnQJPxb
         rs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790775640; x=1791380440;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eojcGFVlS5R1p8FpQbuCoxDLXSD0EodVKDy7T+pbRu8=;
        b=1m/vMbIl3PliBZtvQRNe+5tj9CPci+awGuqFW3UXCjiY7F+g8LNRf6MUvG/9EG6sXJ
         osqX7rmLV9KLLluPeD+shMFefLnTaAwGnFor7a/2y+HULTh4PiqB1ThGpQ+3uKpaIwCg
         8qUv+0ryFQd9loOGnZz3JJahmhiBXdrkS2vfwaOKV4Vb0dZg9Bqq4eksEIMHLZdtoB69
         KcE+g84zsuK4fm8L51tUgLGHHbZkmDqLlD6b/tro7z8/kQQxspZUrNUhx28QkxV63rkq
         2U/mKIEus+KYHzz4FtK8jjRab7jOGsVmOi5KskqpRxLzknYvI7VXSwN9KIjtMhDq2zhZ
         f3cg==
X-Forwarded-Encrypted: i=1; AKwUvBwx0mFvFlbPfzrca5/ygomkFjgx9rUrILpEICrn/unw0uOTApOdPgYFp9sOxkcwnLE1hZBeDcBI0A==@kvack.org
X-Gm-Message-State: AFuF++n9LNJW62fACuDtRDm9OtL8xyAR+YI0r4UJOeh/Kk5R6909e/yn
	MLBpQ32OSaYXUHIlZX8+kVpXCqWdXws8b56zT1cRyQNl/xZMoFjyzl6MTJyIjhbiP7g=
X-Gm-Gg: AYBFou1rFUjf+gWwsXbZHZLlRvCWuaRrlp8VJS2ZTJWGjv4R0xev+S3erMi+JqLzn7u
	86Ppk2h3rKpvrTy9LTrZnZ+DnT2juHylgB1uN0Q5u65YIImMgzHOPDfFi4xLi6PhlB3Ckm9CNAD
	We1N5frETKDMSjr8uoYUDXxy3E0KwEg6OF+y0r40TPSZNsybC00UF+WnfDQ2fuNIrniMs/3I1TW
	WyPURE3fwnJHqDHpCWfcCaaItrRrRzUJR8epZgrCWhS2PCOC/7mx/dl+CMVXdJscln6c5xAHYqk
	ZLI8GBQMLWDT4QY8Ae/Yt2YHFOc+rt1Ag5EuX4fqGncO+d0mw7V4G8SxAjgANVhW+Ud5BtP7ppI
	gD/zxoa6BDyz/6eQquzf79QKcbBhiM8ge73ext+aXtKrVmItndXFbMjj2IEHY/BZHpMwYYweTbv
	mKvykfSxzMGqHRJqAcbIt6z5Zk8Re7K2Hht4iKK68oNciEXJ8KDaTF2xVZHfeJQnnVvsk=
X-Received: by 2002:a05:600c:45d3:b0:49f:fe39:5bc8 with SMTP id 5b1f17b1804b1-4a01aff9b3dmr20989845e9.12.1790775640194;
        Wed, 30 Sep 2026 06:40:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01e662409sm125005e9.5.2026.09.30.06.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 06:40:39 -0700 (PDT)
Date: Wed, 30 Sep 2026 09:40:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, ziy@nvidia.com, 
	joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <ar0LqjO3-cwU6-Jy@gourry-fedora-PF4VCD3F>
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
 <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
 <arz56nVu8TzSjqlg@gourry-fedora-PF4VCD3F>
 <ca35c989-9aa1-491f-a247-ed36724f10a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca35c989-9aa1-491f-a247-ed36724f10a0@kernel.org>
X-Rspam-User: 
X-Stat-Signature: tk1pwghb9775g7xrumasb5foigism1so
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C88C21C0007
X-HE-Tag: 1790775641-533626
X-HE-Meta: U2FsdGVkX18nNdgteWb8sLGeXQpLeVIy+Zo9j8G4XiVpRo647F9yZlLqxYPN/QES54wyFwwqn1cmP98Yw6vxP7SSd7sAfBWzQfY2caJxpazy+ggRzz7mm+yn7+d2vDLIl1FuspiNab6hnKZoxi20nsTts35JrnBMzV8UPEVoWoS7KqDyKbSUDjOpS6cLLxzFeetojEMBun5PFJx/93cRuXgZc3Dwkl7c3SnO3B6tRttwNdlwoSCBmEehJVkox3aef2ieXMIiVIUKhNRnaKwcqWSukL6gEUXgbctxhx/VLvLsVZ76fiu848oyNd0X3LuE4vrVt6F1SjFeih9u7i+Kx1P1uklnEQQaQDPtXduFEIVIGnPyr/RDEavw/L25OGEKLNiLcLce5uwZcmUKvizknn8Vp/TOmvwXWyTUmOM/7bLN1bSnxUMFkM3CSmHV3MEAvL8W11tF6RXPC/Tt2xUwDxjui2F+D43xAq+Q3XTly7ywWwB+kZWXZDcOOVJZxXecdICgT4lTQ59Pd2/WW6PrAy2MjrUk4uWnlxPenC/c8JVOMSb6carIFrfnY6kl8ti6Ymg6s+Kg+ahfTS+0Xy+VEUVSW/ylaat+LuUW2Bm9YNt6tMPKqnKgQ+Ak7lNKljsBlI7/SJYdJkUPLWFSz+W3zBMaC/gJcjgozsC08Vfb9ljNVClFEQYfA8sIg+oVaJ4gFO9pbDPOBSD1CRGlcMvJgljUAKyYzgDEOGL0d58vo1p/e1RfElkxIfYcQRZaGYNlQ3/v/HQrBDBTeo7IBcZwA5xllyDsvEQiIpQKlhh/pSq83tZSxPNlJfUL4HkwcToao6Ve4r86ptAA/HUVlYvfXdc8oO5Lrd5GRRVE/B00sA5mJkoOeyRsF2sQTR8hGNbZijxqqOpFXm7c5484Lw3T/qHIO3VTSgoUkoISv8mKrQAoHF1d3OKQTlaQERz9gOaLAszqMF+2R25mEhqUpvO
 pg97ltGf
 rMOXX72qPXZA0IykkvgdNY/+JnlcQGT8mYwHtcfsYe+T8qf/NehYQIPYdnI+bZmIy5owVpu32/icnMYQSJYO0laJC0pFodkCz+IM+ZnEYOU9iwOjZIAH9RwXJxH8pFuG/6g4eZTBUuePq7mNosqlhpOSxKBhuQkrQEzXpU6yyazBd2AJArWI/OeUiT9wYFH50K9Bm1W0J/tgfOMfOeOLAJfz0KsHrUr0UXSyln2dgI20lJNJHCS5sLMbhPN1ugSMlIDWBl7J95oYTl5RRperBwSSdpOGSseyKw9qGFUUluUiE1+qviM5kk5HHS6mP3dIIhJ5kVuOSH8YnJNmrvzzLbr/XLeVwjxSv2ZUxR/e9WvCFwnq1RSZ2KjjW7hR9Qp/4UOXSGUptrLBdDKmt4dbMo70XeUNPQMr9JouBCalEvAJG5sy8hyTJa3ZaXUfxAw6WCEOZ0v19vr9ad0HfWa4w6EPh9VqAAmFQzhmgTXBI/SRCY8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 02:32:16PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > Right, but you're requesting this configuration.  If you didn't set
> > F_NUMA_BALANCING then you get the existing semantics.
> > 
> > In the existing semantics, if we're INTERLEAVE and WEIGHTED_INTERLEAVE
> > we just always say "no tiering for you".
> > 
> > But as an opt-in option?  I don't quite see the argument for saying
> > interleaved regions (or tasks) to be opted-out if the user asks for it -
> > that just seems like an arbitrary limitation.
> 
> Just to be clear, what I am saying is: the proposed semantics are inconsistent
> (weighted when mechanism A honors them and mechanism B doesn't honor them), but
> once we set these semantics in stone like that, we cannot easily change them
> later because some user might depend on that behavior.
> 
> So you'll need yet another flag to say "NUMA balancing really also honors the
> weights". And that's where it all gets ugly.
> 

I would agree with you if demotion didn't entirely ignoring mempolicy.

On a tiered system, mempolicy *only* applies to initial (or fault-in)
placement, and otherwise is more or less entirely ignored.  This is
a case where it's not ignored - which is actually inconsistent with
the rest of the tiering tools (demotion, damon).

This is why I said this distinction may only make sense in TIERING
mode, while in NORMAL mode you likely just want to fault it back to
its original interleave location.

Also file interleave (indexed by offset) vs task (counter-incremented)
policies are affected by these changes very differently, which I asked
for some thought on.

As tiering develops, the less I think task-mempolicy as a whole makes
much sense (because it's at-best advisory).

~Gregory

