Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93CB1CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47A36B008C; Tue, 12 May 2026 22:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8C86B0092; Tue, 12 May 2026 22:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E466B0093; Tue, 12 May 2026 22:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4636B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:14:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45945C240B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:14:45 +0000 (UTC)
X-FDA: 84760778130.04.F9F3F6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 731AF1C0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:14:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g8FwxyNO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jaDFx07foUF1awndDFOQLrH47FCu+gPZ4CPx0nu7Gs=;
	b=T+y7pszh8v7YNzfUSfMEUP8UZhR518bBqjy0tnGqsZ6HLal1ZV8iivby/q+i7FhytDPJC4
	3o5ZkWF1/+lTV+GZ+1f2JRSqf7Z3ABlNb77qUmeU8HBI68V7JeQ/rY1rDHKdLkDde1JZXY
	/tIakvOff+W7qePYD9oMeIrYGGAogXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638483; a=rsa-sha256;
	cv=none;
	b=hB3b7l2opY8+MoBixrcaULDy8zADjbQ0c572DBudXoFZ8r2sJ6t3NBrC9pCBRu2xgmR+oE
	c+EACqIBVy/DRREM7WNIYwNq19qAihcJJ6ot4tSusNIcYLA8qVodnMF872saPIOrRp+msn
	F6vQK96XbEE27In/jqbMiQ/CtIP6p9U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g8FwxyNO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 484F340441;
	Wed, 13 May 2026 02:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EE6C2BCB0;
	Wed, 13 May 2026 02:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638482;
	bh=O/ddZqxcWhwBINLytCJFvAuCnJUEDwehGHtAA7PXYTI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g8FwxyNOW9AKOG3ojvuKqlesFKDRaGo1cBCUnwWQ+Wq5ihLFVYckbY0epcRhW7jmC
	 +/mUSooio+QhEqdHXlGxKfH1D6wm5SXHP5mK4KeXxyh73kK1DbyqwPbiOHh3+jjYaa
	 CftAc2fGSbureGPyqi43jl81k5+1F6jejDK8XbdU=
Date: Tue, 12 May 2026 19:14:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Frederick Mayle <fmayle@google.com>, android-mm@google.com,
 kernel-team@android.com, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/readahead: add kerneldoc for read_pages
Message-Id: <20260512191441.c535e288077895b127a5794f@linux-foundation.org>
In-Reply-To: <agOWHm00w2vlh1_o@casper.infradead.org>
References: <20260512203154.754075-1-fmayle@google.com>
	<20260512203154.754075-2-fmayle@google.com>
	<agOWHm00w2vlh1_o@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 731AF1C0007
X-Stat-Signature: 1bx136d8opdegrn5k5jck83s1ejoh76i
X-Rspam-User: 
X-HE-Tag: 1778638483-459049
X-HE-Meta: U2FsdGVkX1/xAoVT5FBUw8EGy7jXlcQ9JIayqmFXlNdFqu6uwIVHwj5W+dxr6Cue1hTr3VN0b+fAMavmh08ZAi7kQ5iJwLkSeTESv2Hlg/kLjnyC6EPEJ8GaFwiDPkwaO/wzRFzRdEk4RXn06SFsErfUJSjVrn1ySQGzsYYxUWH0UgE0xknhmxuSH4rUs51O8uBqsAAEKZNu2ZZyxTeeCBf1aeBZfgFRDsvaRyVZv9zasKU2LZIUVCyxP5OLtmXxmRnTInraG4WYj7b8VwJDnHE3HrgOFPQxE5xflzZpVesBhGDDIj9L5m2RQA5v/DCMHpYI/sEffDr1IGDNKPBdpgLnXoJezP7UB5prEifDaeFoYeSgVgbI9JjgI7CeDdbypT5QgeyyBbyYSlG5ItbtKA7Y7dJxEKc68KTocQ2Xva+NXMWKS9b2KZtS0tN96/0wUmFAnEwYf6E+17ZovmN+JjByaanSXNOJ2Bi1D2xSVRoxFA+30NbU+3V5PfWuTKeZcLV5ZcfFXOqzaAb6HJBEr8rsF36KPwAFXMv5Nbm6AEOR2kD2AW/kVuZQxjfFkZxKo2+b4XoY7oFUwo5XVtNHGVXKYB8Y5JJuFxY/nZ3TwID6SUBHM86O3xBRPm+ND3H9OVS5noq3enXrxIT4dyB8AYznZT+3G/FPuQeR1iO4BTjY0r9iVoWBdX1np5LM5b4TYGIeToKSqJvbGp+c7/LECDrekJIN1rTVmFUSO/pbK85DTyzO2CQTl58L3/H+q7OAxgCr0rS6Yq2ixNoxlM9XEkkSQaI51qTjy2LxJul8wmgCFgkRSiZNuJks4VytCbmCsryryK8Ck6k7euBKnp5eSw9U+v4BIGfU/irPjrJuUK5/cT0SHOJwohCSC8GdMZqJHLtla4eFJg3qz17aSHDh/CxR8Zy4YbDYumRF5lDX5aZH6KH/9dQx4CO+8yCBaPmy91hmA2VWDIOIHSEXq8m
 qOGlOXyc
 o2kEIWv7SvLMmAQjYc8OaZxIs64y3x90yPKAIbHhiC/tqTbhIi+GWB/SCumY9h92Q42qCKQbXt0AJxPyQe1MYQf3jjC/aZCF/uwciPGMSR3LFHFJDxqHpc6JCjmuJffWOpw6/TQZl1JbbeWwSsvyeKAUF5xMlgczCkSU53drBcDqIt4WM8tier/k4RQpxaY6+TcC7BLLDE/xlNBSLrIGSPWSChdhlnvI1E0T/PetT6CEdK7Cg6lPjY9QA2f0w+f7dcjA5Z7vAx1s3Lu6XrjXkYExkVDYphcMp/4fYTlVsEWSrsH4HNT9lDDso7b9bJAGs7rlKGob8zSMxpY9aEuOYr4shkAOqnCVB+BDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 22:05:34 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, May 12, 2026 at 01:31:35PM -0700, Frederick Mayle wrote:
> > Formalize one of the invariants provided by the current implementation
> > so that callers can depend on it, as discussed in [1].
> 
> We don't normally write kerneldoc for static functions.  I'm not sure
> why Andrew told you to do this.  I have no objection to adding
> documentation, but I don't think it should be marked as kerneldoc.
> And if it's not kerneldoc, it doesn't have to be written in such a
> stifling style.

I'm OK either way.  The main point here is that [2/2] relies on
unobvious and possibly fragile behaviour of read_pages().


