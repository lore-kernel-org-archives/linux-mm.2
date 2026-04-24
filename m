Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB5AFED3EA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 16:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94EAF6B0005; Fri, 24 Apr 2026 12:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926566B008C; Fri, 24 Apr 2026 12:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863506B0092; Fri, 24 Apr 2026 12:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 721996B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:25:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 273C51B7028
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:25:26 +0000 (UTC)
X-FDA: 84693974652.24.02CEE2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6AC4118000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:25:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RqzM5Bpl;
	spf=pass (imf06.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777047924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3d0aE7ZEmu5z0O8D6DR/IZJj1KFsjW8/ucJ4LWU1ig=;
	b=lahMD2us5KCUo38hiuJ58fJJwqb8rWf+Pg5venvvaB2hw5luqK71UcYa8eleseGvUc61SN
	OZh3i/XgFgkOCEk3sRYU9xGWMJWdax8uzOGqMDzlIaupHeEtRSy16Fi1AEAb7lMInZo86Q
	Y6sI2SW3z/Ni3FpVR16Kv1IKxhbWOhw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RqzM5Bpl;
	spf=pass (imf06.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777047924; a=rsa-sha256;
	cv=none;
	b=3QfzlLWx8IK1fXaBOE9Q7j3A/ihv+2qAG0ObE545TsGVw5Kne/DldO2IHSUnZhb5cBW8Gl
	2K/PTw5azAAYf/yFJLE0WOY0F9B2kNxAcw4tucRN96JKK+OjIhE/f5kZ5Ujv20sYwyd58R
	oZTECZmJKTCoLKANFYcnCMMz1TTnADc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E3DD44320;
	Fri, 24 Apr 2026 16:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AC0C19425;
	Fri, 24 Apr 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777047923;
	bh=eGhe9aNnH5LnKxC4OpgHMgoNYHmd5+rksM+bwGfBi2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RqzM5BplaihQXibm6nlVaBDDzmIOWIvxhK0wlXszfxFg5Pw05CvTodjLQN6z6pRYz
	 nANf/DnX2Ocy7PIgOh414gzXsvylzZC5lJzDH0iVw3/Vi41Ajzl6SCsvarMlcpcwSd
	 3NICzOyF4HLY9QslihWNlh7qbuC9kPbsIts0K/k7zWM+lTGhX5AgwzCTIfAgJfoqA7
	 YYPSfO0UTHNJq2yOXCVPYU+h0/UXpHqkQQ0BXofd3PqVTzHN42SMUYV/ii0XxfKlsB
	 YQlhb+i+f07L7K36MV7c1/GePQiYPFKssXHt/NpvHdqF7S12CNTIOUTcjcZvtO7oFd
	 53gsmbbEeEl2g==
Date: Fri, 24 Apr 2026 12:25:21 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net,
	ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, skhan@linuxfoundation.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
Message-ID: <aeuZcY0u_7PIQb6R@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <b001932c-e376-462e-895a-5e4a9c7c0dc5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b001932c-e376-462e-895a-5e4a9c7c0dc5@kernel.org>
X-Stat-Signature: j36i5ecyh4g6kjitgbcbbspn9sib9ugm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6AC4118000F
X-HE-Tag: 1777047924-171200
X-HE-Meta: U2FsdGVkX1+5BQOnHWCdTzyfeYsznSrYnzn8MaabrfjiEq5WUopyU9RVxXuxkcnYcGDBiBK0E7ZOiVC+SBXcd4O56uMuCp29I4m568IrfY1MYooGv4OcddZO+tumNxaSVM2EKfD6zATS7aCfKTGjP/1dkISDEyX0PP8CsBtOGNz0seGkXVV9FLS4ZeMTZSFw+rLmW84IKKEMvhYfmk02VAbIp1LME+A6mtIbn+4v2wIJBJzLTwEGHvXhEa0QqGSx/mBbOX38FAhI7aiknH1x+d8ld2tQ+M08YucKWGeJbaAvBOgCKqWN2AiKmozA+1Nmkk+rtEt/nDlHBmb4QmNjvIYwClkbQ1klqOmtz8+lC3lcTSGbgMhK0Ym/pCFjvv6k7yZDfDa6dnDnwOnImtggVKfdhxKYzkvlxXZz8uCuTFB0mcNEJDY0ChDf7kDP9m7PITrLmbpeSn1IePlaUwuSXTYrWXrGxIfcrLVQSef2oUWhqzqK5dbvHerQxiqBrEMyHLBzLk8eq7oc7hP8TAkQ8dSmrTPmoZHY7SNQTubTskpZ5aIML4So/UFNegumw/TrP+3z+Jx27TNzfwjFsP87AsRZbkj04clqhLBJdAyDFJE4U4CZTdg9dPMGSCb6sHSoeaedSnwE3nE75yW1A8i2+Jx7bUQrPbWmqkWc4iySGPknn4N+ysQj47Kqc+LaNxs/A1O6lGAMq76JuN2e/UNxjst+kCKTryFjr5Oo5vS+FB10zVHavJrW4acv/50P3wGGym6hbHZr5K2E31AZ6UNij9hMKJL7OX1bKpg3ngEu75fFe51ptnFPqztOMPXkro8qco0uKv/8EVfp2ZHTokDKgtRrn7SZUsyDII13J851eqPbFIXpNNSUakKBfsVYA/UMcsnX1ByPEveARqF1dIRey5fmx4imy5MCNvOasvu4UtwhpbUV0vZDgaG2w9tHI4HmqttTnxjUsNov1736kNq
 fuaDhFCu
 hjdIHiVl5My3Gr1JlKIzPcPaozzm0BS13c8aRj9SxqMKTV1wD1iFqxwf433f7tiUjsOfkmNlIpJNn42FSGoEF/7rXl2lKPwzW3XRp7mZJGlQc9ka2rSGTpeD+rL5VLrqW64a1IIc1u6DQOLsonA66A7Ol7ZoFXku+YBup0qJUQtfynAWHlzsgmg4+kTv3HF9FXail9PJWp/EIwtMJwyhTg193H6DAsYkj5FmHpjJiaOHtTlrC/Qwcl5dZm+pJ2e8xo+oc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 05:42:53PM +0200, Vlastimil Babka (SUSE) wrote:
>On 4/24/26 16:00, Sasha Levin wrote:
>> Existing memory debugging tools - KASAN, KFENCE, page_poisoning - detect
>> access violations and content corruption, but none of them can detect
>> silent corruption in the page allocator's own metadata. If a hardware
>> bit flip corrupts an allocation bitmap, the allocator hands out a page
>
>An allocation what? The page allocator is a buddy allocator, it has no
>bitmap to track free/allocated state of pages?

You're right, the cover letter is misleading there. Buddy doesn't use a bitmap:
PageBuddy lives in page_type, the free list is a list, and page->private holds
the order. The dual-bitmap is new metadata the feature adds, maintained from
the alloc/free hooks.

What it actually catches is the same PFN being handed out twice before it's
freed, or freed without having been allocated. Not every kind of buddy
corruption shows up that way, but the common bad ones do. Corruption of the
bitmap itself shows up through the complement invariant.

I'll fix the wording in v2.

-- 
Thanks,
Sasha

