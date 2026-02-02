Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 594D1E7316F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8C76B00AF; Mon,  2 Feb 2026 08:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686A66B00B3; Mon,  2 Feb 2026 08:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EC16B00B4; Mon,  2 Feb 2026 08:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 433A46B00AF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:37:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8404C0637
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:37:25 +0000 (UTC)
X-FDA: 84399618450.04.5DB12C4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id B46D720003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ZiKWp/m1";
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770039444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t61KUNmsZghpo+fJJU80H5pumxWKhCMO8GKrlURQ4wQ=;
	b=5cmXqQUfyWsadgg67NNcULACfZymoqn/+ej3NSj+dqcaKgbQsTDJrWNFgODdxflnIa54xb
	+rxvEkjAM+eUEZm4wuJZMmam4NmCq+GctHjSSMCPmXgGqMPf3o7FU0tPV8Tr5T2UWoP5/4
	9+E+P9yWZok6iloCrrF17MJ8p+pTd1k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ZiKWp/m1";
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770039444; a=rsa-sha256;
	cv=none;
	b=PWPpHTfGSzPCQ5CV51pPZ8tmT/ywMc7DAtm4lHzAcs8pUWSVuCvNLx6hUvEnH/Fe78KVCP
	sN1upIOP0Wqv2DqOvnbv1ijHUDbzh5xHgb3QxOaxho22ynM1pOUET9OuRIZnrSrBydG/8t
	dGJ7ZQLFKw+p0IRhc9LS4cr1h9a8TcU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t61KUNmsZghpo+fJJU80H5pumxWKhCMO8GKrlURQ4wQ=; b=ZiKWp/m1VUvheQfpZBsJlo+xqX
	MvTJAzi4Wgg4L+g/2Wqe7Zabjpx9F1XuPmiJQA4YR9Fn3U/nPUD2+16RTy6zqY739JBzsH3b/HLWI
	TSI9WIELkDa5xuTV3hdpEDssUMC/1nuE4sVpX9+pK5mkB1bDwePeeGJtEpUi16k1lWB+MyLVWAWmc
	dEMuNlE6e/CC33uCK3Gk2hWNT0Re92/ST4NKKE3wek1XG0lmFxYGKoDyZGa+sGv3vTa61jzhzsYca
	ArGL5D9+g8/U98MgGhfQ2Kh8Vuy+WPOUJCZRcVw7NZLN08Yj2iOgeMYG/IfzjSd9AFZG+dT9tHjDC
	5TjBMpbg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmu77-0000000GYC9-2S0m;
	Mon, 02 Feb 2026 13:37:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 22BE63008E2; Mon, 02 Feb 2026 14:37:13 +0100 (CET)
Date: Mon, 2 Feb 2026 14:37:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com,
	bp@alien8.de, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@kernel.org, dev.jain@arm.com, hpa@zytor.com, hughd@google.com,
	ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
	kvm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
	npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
	ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
	tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
	x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Message-ID: <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
X-Stat-Signature: pfq53xwq5rc3zqiy6kdx1tuy8acngexo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B46D720003
X-HE-Tag: 1770039443-732661
X-HE-Meta: U2FsdGVkX18sKgX8bKROWIRXUcPd2sbl7HzKssShn4VPIPYrwMjR3fXoz46UkcG6C+sDMHcSd4eIYKqwFZyR4Noq6bSbnm8zDYcS2nAoiUiBwOzA1tBONsovzZ52xsgMbZkiey1frHf4dvesl9sM7p+MCU86s6SqPSVCWNTazvzcupk9xQQ8lrUImnZuigD/zd6OmhpTdjO3vQ6QgkJfY7voTC/hAiEqFoQtaNvs8pgBkMkq6bWFf2Vx7WB1mYjsXtEEk0doKeCSk6EPsS/G5L6PDeus3NKkoIYol0RyXT/rAx0B8Y9WIhe3VxishXhpeMoYfVG7kEVxXaxBwNxMRysh6IF1fObSn5QP8B0IL9uVRE7+cdZ80ougQFXGaPb+NkL75eBh3x1SgmGPzG9yH5oxfxSNYHivW9/nFPepHtyBT3J/jocj2B+czW66+u1SCNELrDhcXqR6zxRFhWM4WvB0x94N0nKPn54e7j0QrwFHcsbbfs3nP9iTUNOxSZPzHU+o+AHD3HUB9N7YnlNq1chXw3Ca5aVo+fuHQXqtcZknsviySEEizxigeJBksGbV54ozNL44AHUQSA1LqQBlgxIvJKEjeZpn927ir+AOLjVeiSSSXFgRGDSCKHV/K4evbBQ8wAjCqqXVpIotonu0lhbf9ENFXo/zzChX3i7uA8H2vh3IHuyYBbCYxdfNss8v055UYyEdnQigCDpvfTNKtOIn0QjQ0jweA1Pk7jIVBlGTkx7SQ6aaGrOfRaEziw6pjWTWsm13rsruYgz++eMrdaLGS+7RqvxlqjXRb57hvxwL+3ZuQZlRDbO3XtfQE9jpI9bBPQsLd3hUypNw7dD5VJHdwgN8VcTtSaeFdl1pSJIUmI4zCnEhcb42ELndrzJNsQ+4Ofp6GF0Gy78j5tJhN8fS+FwlzpJzKFkH6KI1C7nNmlD0oKE1tcHiPX2aXUxyzyZZMZPeVIxumqcCcAw
 TvH6H9nh
 LjmStb4ZX8DyW+XLoR2+HZ5u8g4pQ2A9j29f5mP+cAqI491wsN7LVGg77HCvBbeT6ebICkwxWV/Ts2bJ5nAcH2SR8pYrrm/SmfMkPVaRK2JlLWqiiJnAqm3TQMjPQ4vnqik189RwF4/2MLxdbkIuRbvWB83909Yq7pplFAaltiqOsFFK25JOYZlITHJbeknfTmeBTLa0R9/xXktOGQpwsnUmhuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 09:07:10PM +0800, Lance Yang wrote:

> > > Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
> > > unconditionally and not add overhead?
> > 
> > The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
> > (khugepaged) paths, regardless of whether table free uses RCU, IIUC.
> 
> In addition: We need the sync when we modify page tables (e.g. unshare,
> collapse), not only when we free them. RCU can defer freeing but does
> not prevent lockless walkers from seeing concurrent in-place
> modifications, so we need the IPI to synchronize with those walkers
> first.

Currently PT_RECLAIM=y has no IPI; are you saying that is broken? If
not, then why do we need this at all?

