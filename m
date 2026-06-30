Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F39C5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4EE6B00B6; Tue, 30 Jun 2026 03:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50636B00B7; Tue, 30 Jun 2026 03:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16D96B00B8; Tue, 30 Jun 2026 03:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A20756B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:13:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C291C1E45
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:13:06 +0000 (UTC)
X-FDA: 84935712372.26.DE538B8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A69A1C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:13:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U7jSTV9Y;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782803584;
	b=H411jhmywR3OR6bFtK5mWl2jBOyql8mtn84lDa9DSYfYvwxOpHiJW7n/Rxh7R/lxcutkbW
	BhZ9u+LY4+frHYCA+LuzfDyhdJxGERiZ3rSrp2eERSD/flDAxdaXXQZBSoqgLwjLpkmcIN
	javwzLb0Z84mM/7u2JyTJsQCiNwPVbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782803584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltn8huQzDTLXUab9Q5n+aJGIzC9O84HSVZQu7VwWF48=;
	b=LE680+uEB1dHSbxGS6gfiNu50rWjaElrVYUN0Ah9nGFPCbSa13HaSfBBvhsc3YACyzvAnX
	1wwaIOLgKiagABhRZKJFTuqBSlKL9DpvbK4KijlrzoDwOK5cf7JXvdOWYh1YuxSKUGFy2M
	cwcNVtflZdR02zc5O2cIjH3e55BIWZk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U7jSTV9Y;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ltn8huQzDTLXUab9Q5n+aJGIzC9O84HSVZQu7VwWF48=; b=U7jSTV9Y9V8TPzGDfgpk+Nc3iQ
	N51s2r0UBvtoa5D5Cwqa1wU/zyBEV0nJDoaH72pn7R1vMzMTjOWVMOTWdvAVrPaym0wUfyk3K3vOv
	WK+VzKtrfRhtgOQwEJRceav6gmuPgAkhSYFsr6krFi6gcL1rs37IS/Y3EyYt/Lytc3kofSJs9gQED
	dmeJ11zvvjXpkOjC0SYKqqpBJx3ZFBPdXknV4qClRrJjfPfHUlK7kLPOGg582MnAk8mUe/w67uhnI
	C3/NqqVIf/cgWaXb+EILlhOs0+BrNKwZAR/CWqVYH62uROyL+X6uc/wEaFmmip8y6IpU0b4dtd85C
	pNaW6ZcA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weSeR-00000004TzX-0PFH;
	Tue, 30 Jun 2026 07:12:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EC4A930036F; Tue, 30 Jun 2026 09:12:57 +0200 (CEST)
Date: Tue, 30 Jun 2026 09:12:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-hardening@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <20260630071257.GQ1181229@noisy.programming.kicks-ass.net>
References: <20260626173444.2252041-1-xmei5@asu.edu>
 <yu6l7zo4dmqcnho7thkf7sk42lt6xkz6uxxwxmg73x23vihlnp@pe7vdut4o2jc>
 <CAPpSM+Qwmv_wsNFnEjtk3GbLdZB_JtH5vW0v-Cj-CyiE8M_UEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPpSM+Qwmv_wsNFnEjtk3GbLdZB_JtH5vW0v-Cj-CyiE8M_UEw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A69A1C0007
X-Stat-Signature: hb87tondog5ud9so5ggpcxqtug6y6ue8
X-HE-Tag: 1782803583-668938
X-HE-Meta: U2FsdGVkX1/YhA0E28Ewyo85Rlr7O3TkkwGQoPztgUF/+LBxHsgfHQbOiRIFG/r3WgufDxYmnCoilflW88ZPV/zL9u2qyizyNlpMKiu0KUuVy5wHuW8kJqtAcPPTZyotNyi9ZNYr0YZHWxp0xyA5l4foMewSn71sNJx4JIKkEY2nOZeBPS+KLd50sHXKEVDifOVP1eI7XSmUA/5HoDgG25YJJYvuGAmNpqsKLIX+qq/ALfzQjP+FOu8rsx4Zvh7gNTwsR/bz1QJotxBqQTIzlj9ZYpR8So+Wf5TkIM2bscUvHAyYU9EsSBt884f5gdqeUj+scwBUfGF17OSeHJ/jVADvMtNfcgI4i+xwRV4vLUiCKRjen4y2QQ7wUlg4HocA6kp/8sVbS+S6e1VxVbK/mn7uj4z+OOxGzbkn15FbsF+jpRDMzF5s8+r0nmMbT2YY1QegNFAXBcMxEvLqwXn1LEs/G8j3XYMdQp36phmnNAYBv4QOgwZ7n6Nf/BIAx5+mkZF8oINS4lrg9/KMd2Xrl+bPgVE0LOiz78O3IrJV5AbbmZVa/afARJP5G1tgdMpG1FxxhWO82PZFNpLjFtkRUpy+zlHgQuR3t4+9Cn9PCRk1PAkHq2qUg1hZfTMxEcC3DfXWZ6tXuWoI5EAQyL5/Blja86p4ao0HRte3VRPrj4+9EQmc4xnsPgP/6n2P4jPOhK3pXXde3z9KiEebt2VVacw4XDaU8HKSbgjX4ZL8UYKwsTQTacVBs/t1FJdBuyYwS+ErTMNKyuVA16uTWQT+mmqbYcb54gS3skt+e659fTCsBDvegS+nyZxUAivLEbHeoZEwf+TT7bEhzmcIlZ4Ky1Qp3glC+FbCh9PMdQ8KH5LeP6gwF97iEVCQIygfP6/0qofDmjziKPqKhx4lDfYkEgw4pVPZnW7zbu7p8O8Dl/WvLPKa0k2VZr11mwnvxN5hgNvAaGhwLX9KXj176b0
 coe11a4M
 dPt40NipVI+WvUjEcy0qK/OkJknQakPf2ORQNkRcTXrf88q+8pK01svS2o9TxyR7dbL/FsNpn5abIkCIOxmptEpKPsauwedpxW1gls9A1iSWsEHS6thUCmXXKG+DPdwaJ8wALrcCDRXgMU+zS28nMm9SKGAs2pbMTZmW0e9UhzF8/v+PGEMkQMjTFmX/Wyuq7Pwkx4MTpBq6mmlDITAqzyFGtqaSqlTKkPjHUpsvzaaFfv48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:48:46AM -0700, Xiang Mei wrote:

> >   - The displacement is attacker-chosen (via the immediates) up to 0x100ff,
> >     so the pivot can clear any guard narrower than that in one step.
> >   - ENTER is reachable as a gadget, so a pivot of this size is available
> >     without depending on register state at the hijack site.
> >   - The pivot happens after the control transfer, so it is not constrained
> >     by forward-edge CFI (kCFI / FineIBT).

> Please ignore this line; it is not related since we assume we already
> have a CFH primitive. Sorry for the confusion.

So I am still confused by all this. CFI does remove a ton of CFH
primitives. Until we have Shadow Stacks sorted, ROP will obviously be
the main alternative, but I'm really struggling to justify adding 16
guard pages rather than going after any actual control flow hijacking
primitives.

I mean, if you have a reliable CFH, we should be fixing that. But
somehow I'm thinking that if you do have one, ENTER isn't going to be
the worst of it.

Or am I missing something here?

