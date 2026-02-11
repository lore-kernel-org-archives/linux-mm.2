Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB33EE9E2EF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 11:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE37C6B0005; Wed, 11 Feb 2026 06:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BA46B0089; Wed, 11 Feb 2026 06:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEED86B008A; Wed, 11 Feb 2026 06:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFB726B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:58:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68788C162E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:58:31 +0000 (UTC)
X-FDA: 84432028422.02.02A3D41
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9928EA0006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:58:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DJn80o38;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p57vAmPA;
	spf=pass (imf15.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770811109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=401OE8SAJcURYtUs2WuI0jXB1BL2uOQgKfCJza+V2mE=;
	b=vTbpKV+ZxwdLYzAz0aut1FIJcBXVQDZJyF7CQ2xiOAr0Xul5c7+qt+i7Vw4IBwuiU1QMuC
	PI76bByIL2mLhcimUg3tAnkRwsNtaXuI8wO4SlidPCadH8LGfzEs7+05vbHOPlIAvtuLw1
	5yvWUg+ToRXXeblho9DWAkgJfaP6RqE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DJn80o38;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p57vAmPA;
	spf=pass (imf15.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770811109; a=rsa-sha256;
	cv=none;
	b=Yo79P6Rxh+/RmVNI0UJ8UOb9k/9fX69zh8jyENA1VydIobUZam4NY1GjBVRpqycMhmkyfm
	MRma9F/Us1eiVqChcB5mhAhMFH/phh+UVE6IEOzWVor/0HmFzh3PpYxFpwPEiw3ijI4Gz8
	kofHyqgE5obLAeahM2AKSGpKqTcObzs=
Date: Wed, 11 Feb 2026 12:58:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1770811107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=401OE8SAJcURYtUs2WuI0jXB1BL2uOQgKfCJza+V2mE=;
	b=DJn80o382/xqN2eyGM3D+jFIQMWpP43a1JACdOfNJeSkOjTYziG+HsVpBJJQkJbAqZaOiT
	MTtuQ4vbTvpWM1vqxELc1zgfrRaNxMJunOOLozgqTxGhlm5lwPJzW4LkHv5vSdKAdsVeh3
	pMHKbSEwDcgNqk1LbgmQjpoQcxsn7kioBQtY/YsGfWdrMg0UNQnsuIatbETqMXzxYOXvnO
	k8Ef6MN5uTOHMlPnepc6EuY+tcNy8rfBp6iX95RiBFS4ckm2IeHpQVFqnkqas4oE62v4SW
	fU3qW6hvmTNVHg1E89+R+adFq6I5CxTUdP4qYhiNnOnrlM6EIQ3/FHiYrxi9wg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1770811107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=401OE8SAJcURYtUs2WuI0jXB1BL2uOQgKfCJza+V2mE=;
	b=p57vAmPAp83gMS8x5VUkXVCWGuo6Q17M+UAIpRXv0YYau23eYBT4wVT8id4ewF1gtn1VSk
	G0OeHsuyK+d/5RDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, surenb@google.com, shakeel.butt@linux.dev,
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com,
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] procfs: Prevent double mmput() in do_procmap_query()
Message-ID: <20260211115825.MLF4L4Jq@linutronix.de>
References: <20260129215340.3742283-1-andrii@kernel.org>
 <87qzqsa1br.ffs@tglx>
 <CAEf4BzZHktcrxO0_PnMer-oEsAm++R4VZKj-gCmft-mVi58P8g@mail.gmail.com>
 <87ikc49unc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ikc49unc.ffs@tglx>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9928EA0006
X-Stat-Signature: nihmuezfr8qt57zfq3n51myh51nec3hs
X-Rspam-User: 
X-HE-Tag: 1770811109-995314
X-HE-Meta: U2FsdGVkX1+XoG54QfPfOB0S+YwWqdWV4Hy6tqVCbL9o7Dv0yrJ6OWUFE/fMbdQicaTwKG6065oVn8AuZ1DeHAHwp3BK9bswd8z8+KXPgyM4TY2TSujah9QXrZxrbXH6KPI7TTz6Uf4Z/3dyrNj6yOrkE9r220f0VK7cBxRT0L50NlCCKeQs4bOjvxk1kIm7ugxMktvuJYofRwRa84CXci174vOq0YVKE1U60F6t8Ttbd/k6ydpqlR3v8SO88WAEJ31M6JbEZuyPxNYlintQ/m50XkDL5Yp+0xdC7T1mZLo2m7vHPdVCaQ90lXtUH1KPhdYek/jM3wtL/eai+M+IJ+BlWUc2oRc4zbfK5Pvur3Y2/E/4eom/0uu7quS4g0Imm6m+zCJ507YdUkfwzq5xu/i1ormNzzDXYtKZOi2pRovpGSA5GHo2+hgiSPt6nwf7W/CPWpyrKhxyO/uY08rNI4N3blcFxT4RwwBnYnHwXQCDswYjY7UUPtCwlYLsP6iQaxHLnOgjepQEcgUbnDY6mUNr78HdgI3Yt2qXk3DrzhZjNRDSA7i32G9uwdYBrQt/7wu+TnFfg4JAyE2uZO+Rsb7pBjf7bPfCcwdH75DWFwcpOtNw6X80QSiNepoaPyAKuGvJf0+W0L3Lcfp45l4vwYyYrCH+EYkBF5wr8hZ0aNlsRkPjb/2w1saNrTZSxUldAjMxg9Z5MsqBcEwmMimqkQh479a364ygWpbYWieZ01sxNLecljZnZXKf2p0LOagdof93mJVQjgJDQClpkIYssOaKS2qlysctmW7zG+Sj6BJIZjH1jipngeGGMgDbfYppoyh1NYJo1Jsi6r+kOmptDrrTQ1fnryn3Y8fR5NUfPxmLh3IUNVkR/1rRXr2e3/cXz2FJI2pSLmSODmwIrCpu8UR60EAbuBO2oqW+p4DRxSwgnf4X6uTaNjfo+FXLoLbn/4R0VrbtNg0aEhxBLWo
 PqpnQ4QN
 dVipVYhI1lQf2lEg1qo4feP+IaYWiyuTU5TbYGYWxiUjwpRyjomn0FJIxWsoxIzkK9RrEdutXjAmC6ZehGUaS7vaBm2WkLgEx21GJBLj7GDqTL0pB6brlf/tzws0Y9vJCwuElU0XYLuSadrUtSM7kiYsU7poMJ+C2WVFJkYpbArnvaHfnpWUigDiLTiz+vn6nWIZ5BU47YV4AZOOIPlSkFYnFMIhXJl/MdNdoOrcGmL8hKCF1R+gKYVWoFZLFSKOXPdWfRwqr/5pmqtZvKAKjXcYLwzC7lcgFEfRlWz9t4zp+DMxwnVcDRhhmom96/34/D54FrzyeNOQ+l5FWg7ojUllvL4OjEfDianSsdpv7dRGDbHBzy6j3KSDiVEmUHAIeaAwEgp5sFcgstxb3JxXB8MVwX5ldnJze9A/bfF+QFwSgv6kfUb+1AXWfZM6wIiV95psuVGTO6JIHQby+3GnnceP4fUyJqkBcD+jCkvegW2Ki4bN3xEhY3Lc/Tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-10 22:05:27 [+0100], Thomas Gleixner wrote:
> A recent fix moved the build ID evaluation past the mmput() of the success
> path but kept the error goto unchanged, which ends up in doing another
> quert_vma_teardown() and another mmput().
> 
> Change the goto so it jumps past the mmput() and only puts the file and
> the buffer.
> 
> Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
> Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Closes: https://lore.kernel.org/698aaf3c.050a0220.3b3015.0088.GAE@google.com/T/#u

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

