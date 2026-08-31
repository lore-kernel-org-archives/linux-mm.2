Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BF0C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607F06B0095; Mon, 31 Aug 2026 12:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEFA6B0096; Mon, 31 Aug 2026 12:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B826B0098; Mon, 31 Aug 2026 12:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32FE76B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:52:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4A55A01D0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:52:32 +0000 (UTC)
X-FDA: 85162158144.22.AFE3133
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0FCCA40005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:52:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=uTRr6wo2;
	spf=pass (imf11.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788195151;
	b=fcGHFtEK8QuZPFFqB0pT0+k2gka1BgzeFBjErpa1fOJ2mBoZmBIsKt02vnT9gvBZOe7HKR
	xm+5fZiiDpIG0RoWJ0n827DmAZoYBLtxo2Sl0wewi0h/dF3wV73X5KKScyIRfLR/VzT7+L
	jB1Bw+inkvJiwj5Z3B64U0C2QlTZ1XQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788195151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxMzrz6sR3jfa+iRFIT0ZhWPe/MchItnNfVuCF4v0vE=;
	b=ZDncCFDG3Di/VlbzDdJ5zA05CydwwX3tUWYTync500+ql0Q3zu+h8atUb+O8n45ytzMOgs
	5PQCfscrp04XlPoD98o3UHCF9lMGsxY6popSkDdwScMnvs//JXMhVpt0x8Cp22weGRVHu4
	u633Mzy1GkQLYMMG3IV6TeLBpEpvWo0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=uTRr6wo2;
	spf=pass (imf11.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1788195148;
	bh=PS9gcAYzeHfejVxPpV+vxCosTIOYM5e3fDncZAqqlB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uTRr6wo2HhJ4ZiqcxLFjJa8QCaQct784UPFzGTwjJzoGfhM0DfrvYM7mNwIvKkbTr
	 3LKXT/vudsHTyl3wNQANK3jiXY1gQKCYl4aDCfvHedYPIukFzYfdgJ6iQYGw15yOeJ
	 bLuTMekOrq5Y5tbUjUqVWYtl9GDV2eDLSaUPqB/Q=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id 9965D63F88; Mon, 31 Aug 2026 18:52:28 +0200 (CEST)
Date: Mon, 31 Aug 2026 09:52:28 -0700
From: Andi Kleen <andi@firstfloor.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Andi Kleen <ak@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org,
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <apWxTNwhaMU3XiZP@firstfloor.org>
References: <20260831143511.1133029-1-ak@kernel.org>
 <nq4g527ozizmp2iqmozau7xwgdq4cny43onciw2mw7vu4bwabg@uzkdpjchygkn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nq4g527ozizmp2iqmozau7xwgdq4cny43onciw2mw7vu4bwabg@uzkdpjchygkn>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0FCCA40005
X-Stat-Signature: jbhafa7dpdt9e3e8cuqoifdgjwtuciw3
X-HE-Tag: 1788195150-889696
X-HE-Meta: U2FsdGVkX18/gZFezP5tnLfkIqrX12CmPxy+I1WRtP1J2si5JQdFfw0bw9DjdpopfFhmegKh7EwScTi40Bvby44iqlc7Si3tktffo/SNZGtWRFhM9E0KD/PIGMVxCiB//7nLTQfmwQwyVVTi+vxmchuPmZ9BYC/UAzLbIC8A3KJGz1jaKkbxyQQ8Xwgtmdybj2m95tnMq5d+jnjInpwJWngNoDJRdvXn7YorvXWXt7Mt808+brX6/7wsUMsBN0KldL8RlhqKXOXrLWe9mRbjSvx0y/58ltUAeJbz93gho0nb+DSspyrFxa6hzy5QcBhTjb8rMhReNrflSI1a1kf1roNmjSHjyalUpfj49i/xE7YVjiunWuZBb09RLXkfl6Ot6Lnk90bRFHitQW9bE/+h1bSOr8Ll0cIcwJD9QRWA/8Bwo0SWNBHp+T3bLA6gqZkmmkObdN/WnHB9+ijssotKeir3z35Vl4Zt0UE9bl9pxyPuVVaMusUG83SdnrQA9ro4f6i7De0Bi2mPBMZK4U8nKUYUKC6pz3FXDokuHgz/xBC03PYSrg9W2Q4J3dhDx4yE0Capm4wfipuFrVVvxQ8RedyRZQkXiVCYBQwEIc0OJoNW35+Q/s24MzREombxXTn4SBM6U9Xosk60mTkvEiuJbmaxKTAGWd9Np6QB8+VAsZDjdFaG0EVTXycBgFTZWM4qLGgJxy6vXBRSSkcOpDNAkHn887pPqgTzYsuPXCpIvCimOiP8i+Z6EHaLIZAM7RYno+VhLRPPgTr0FHN/ZL8DFMEINywu3L2bLh5JR0coOL8t3LgBLJG50POzWfImtWzCrkLxuCvBvfajJqGEzQWbfeLXIf6gGR3QztBrzDWkoLUI4xpkqjTX9oAiafys5HE8aXnoab5YanGQTm3ufeQ2jJrdl8h6jxNk9qrlhqLIkYz4miek5aozj11ufgD/qz5tyuZK2oSgSEvhvTOEZvc
 hMu5vH3Z
 FxoAXeoe3wOGE9af8AbNTPpI9RmGcaS0NQk68c5DXw88VO9pPPx3RmsFCkIqt6h1bFISpetcJkXTuUMorb5V+kKGjQ9dT6uvu5M2kZqFBfhKq5bm4dsurolHu/4G9nznNrR1uGyKka+XEJaRN5GblUPe0ZLwoWFfr9EqZye1hNgttfAubB0IRMvL0WW9JaOfRYUpRQ2sjCr3FjeCg3bYV5ObyF6zmbftwWyzDHH86i34T/Q4AFC6JfG9e1VYIjJt/GzKe8hCpAvSc0hU03wkdP+a5hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Did you check this with lockdep?

Yes all tests were running with lockdep, and it didn't trigger.

> 
> Any access to the maple tree without holding the write lock or the rcu
> read lock will cause lockdep to complain.

Hmm, seems that's not working for some reason?

The VM callers of for_each_vma clearly don't take rcu read locks.

> 
> Likewise, any sleeping while holding the rcu read lock would produce
> warnings.

Right but the walkers don't use the read lock.
 
> Note that you do not need to hold the rcu read lock on the vma maple
> tree if you have the write lock.  This looks to be the case for most (or
> all?) of the cases you have below.

Yes the write lock is hold (like I discussed).  The problem isn't parallel
modification but that splitting during the walk invalidates the
iterator caching if you sleep too. That's all purely on the local
thread. The only contribution from others is to cause more sleeping
due to memory pressure or rescheduling.

-Andi

