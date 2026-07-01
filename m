Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E50C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983226B00A9; Wed,  1 Jul 2026 03:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A2A6B00AB; Wed,  1 Jul 2026 03:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8974D6B00AC; Wed,  1 Jul 2026 03:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64D1C6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:24:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E48381A0283
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:23:59 +0000 (UTC)
X-FDA: 84939368598.24.DF3AB37
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A696100010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:23:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HkTCwjNX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782890638;
	b=xYrP6YDErmyMMucxDc2aiYdeCu0WLkqm00g0+WTQjVjfQW59aDB1bMWijMb/90f0quEpeh
	TbwO2BcIeJzbUXmWOUMqBvv+aJApMXyGeFBjso8GHQ3B+AbMeUMMTB5H1bda2Oa+3vZbmR
	Wavgn4Re+w+kq87qCrmkrnLO1/w4b5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782890638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uGyyPWBXX00bU/7EmAFPO8s9JNCVqICKT+bwYXLH24=;
	b=MRgcFkmWguODC9zKIf4ZPjB/jDwaIzO2n20yTNAGGyQCz9Q3HzbN1+XcvuJC9NDI9c74zj
	24ibxvZR55c5q/CIbTOZPFYFA+3e5M/G/8S2E6r9IW+QzVsUTkK0lPFguYBQWgqNdFD4ji
	prtU1qeMZ/V4j34EU2PH7hUQX0J8cdE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HkTCwjNX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7uGyyPWBXX00bU/7EmAFPO8s9JNCVqICKT+bwYXLH24=; b=HkTCwjNX0nqdvnjTsta0tpZbhn
	o/sI+ePPaKOAxFSjmVtH13KzE9hzZXYWGbVjqAOk7S+zC97NPPTZVA0YuWi0pKg30UeplvI4JoC5d
	hnZfTN9uCmGGZRoP7cXQQIEhuiv2RGzy0G2DMBQ3WqgpdMwzZ+7WUCZ46tswVonzkO3lekIjMK1g4
	cuiG1UMZdohAA8zjRZ11IQTkK9zfdrO2899CmacO7mPXrVD7Q2Ce/Gyewmu6Uasq7s0Vydo8fNwFS
	iiGquqSc+afv7/SZKLIIwflig0CBhtocjoxErs1rUSfLqRjrSAB7isBfVmWkPLv/S3ni+Wq7kFffo
	r1wG0X1A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wepIX-00000002T2n-0B8e;
	Wed, 01 Jul 2026 07:23:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 42397300402; Wed, 01 Jul 2026 09:23:51 +0200 (CEST)
Date: Wed, 1 Jul 2026 09:23:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Xiang Mei <xmei5@asu.edu>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <20260701072351.GM48970@noisy.programming.kicks-ass.net>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
 <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
 <akPYNv37BCJXUg8-@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPYNv37BCJXUg8-@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A696100010
X-Stat-Signature: kkjhjb76r3nnjxbn3c9zjpd78hueuac1
X-HE-Tag: 1782890637-681323
X-HE-Meta: U2FsdGVkX193KlGhAwP+hD+Ct9DXRG2OWVh56RfirxHhBUih4ibUZF+7J4w748C8DbfRCjIWM4luGR0hmSVseziGqtqQ9FhkEgwvHwoInkDzOkTH+THkP2JlDb24nnVIyXo0Q5DmEzIFpAySIh8pxPELWSH1bRJnlTw3FYUzf9bGUPE4Gw6JjYTLAhlWrMFVPJHjd0VfRPSYGOttzHf76oLoRZlwM0C84A7V/snMxbLSbGupQ1Hxac7D84sdrslMFS/PJO94IWkhWPklIqU9AynqGrTZM4JjCb4Qh+EvCsdrEhEc7fcnNJiOrHh0abBexHulF2gnbePB/tx4lKt5qXFDZtIjf3Xgk1lLYlZ1MvZIdFSzvZCj3TFsGcG9i3EoNqvJ/gfh+KcKR6jKfPlXrouRDLFeVuv48AbSsYvvzspaVhIVGiureFbBUscYu/QmooatjcDNALGEmBRjDel1yvdJSa42Yo2GcSmrCIQE4Q52xrB4WTBk8vnG2QRXooQi1HBaFnMd/5tLrdp4eJyZFqRyL9ylVNW4eahOGf3ReBo+pwOxA5QZCV4MnPj2/4o/OPonFiO+B1HoJiOziUc2Life3T22z2PtQeYOvzUtrAqfwF7Cv0z4AgVTl//MLzCX9bcK22hImqUMjXzDEKQ3uI7DYNlCb0q2HIBjdezNRgR8ePnrj6CnktOjeWdHXAhYIhQXlZXGFW8kFdlhGVIFpfm0Wr6NJ2W9MRc9w6MY7OEy1qkanCouI8GUV1WjSWWM9qos1GXj97Kzn+nTyhdult5G7wgMXvt1C5uKqPkbOpbia2gwIDapWAAKxTy/N2FXYTSm1+0/jZftrrjbL54tSGRnP4jIc9nmen9vHkE2c4AFoTZ3P0jt5DZl79NlMtKKGn73mlEhTfuGRKE9jbhWMVgsVkbJ/bg9GhvgzvdZxmfnfL0wg9n+by7rZ9RKNY687perSqALy13vhbe20Fv
 JTDcA0Oa
 A+L4WSn1Iaxytw2bxP/fRUBnI2VyXWOLrwPRKIKwpWhrV2znqHaHGMIUYan0Sohf+bdQVGmOAuXFxR6wP16idwg8lQ9CTQa3SlRzYVkT3KaH5BCc5w/Gd123m3hczrTLUa3qt3CpyZfuRe+qixAqXpA8HUBNr4Rj8Gh8Hzrr3ahdVAO2Ag7coZqmdnX3PJ4Jcxe3iNvT6kGU/9l02R4bJlr19fGnZkQPM3aKFOdSOF/iHClwjSaRZQC0xiScxeVlohQCJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 03:58:41PM +0100, Pedro Falcato wrote:
> On Tue, Jun 30, 2026 at 07:01:48AM -0700, Dave Hansen wrote:
> > On 6/29/26 18:22, Xiang Mei wrote:
> > >> Please don't even try to send a v3 without addressing this.
> > > This is a demo exploiting CVE-2026-31419 with this technique:
> > > https://github.com/google/security-research/pull/397
> > 
> > Thanks for sharing that. That's really good info.
> > 
> > But what I want to hear a bit more about is why this new guard region is
> > a good, generic mitigation. Does it help mitigate a whole class of
> > vulnerabilities?
> 
> I guess, to add to the questions (to Xiang and/or x86 people):
> 1) Aren't initiatives like kCFI/CET/shadow stack supposed to mitigate these
> issues? Is this mitigation supposed to be applied in spite of these features?
> 2) Aren't you screwed by the time the attacker gets kernel remote code
> execution anyway?

Right; so CFI is supposed to eliminate the forward control flow
hijacking primitives, and shadow-stack will hobble the backward ones.

The whole ENTER thing is really only relevant provided you have a
control flow hijack of some sort. Once you do, it makes it easier to
build out a ROP chain.

