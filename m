Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5444FC44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD3F6B008A; Wed, 15 Jul 2026 15:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E596B008C; Wed, 15 Jul 2026 15:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D7F6B0092; Wed, 15 Jul 2026 15:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF5266B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:40:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B8821C021E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:40:34 +0000 (UTC)
X-FDA: 84992027988.20.FE39E7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 365AD100002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:40:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rtRWU1qY;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784144432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nbMCVDVtFVWhMbY76EutKt9ipf8/7GaWfOcZIYGuE4=;
	b=BqheYnNQs1XnEs9OI7+Qv9IJTSgfbny5hqjomDSc0JEIJ293ycAKlZfWlZEYnrFQdIMdgm
	j+6fliayDbSCnh3CslOYsiFMM3mdn7vaBiwnUE7TASY6Wi+WDvEn8f3amiT495r8jj/1rs
	MFUcluDc8uKlLdkbbkZNjvvVOyoK9kE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rtRWU1qY;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784144432;
	b=VjaRFrVOqT4ezG3fqie4vaJtzypRwl7+4EAqACU0o/28R/49+T/RDYJEAzIt8sV2tzLrRc
	JonzRjKE1RoHLH/IUlP6NaZJ92B6EiXMyHrmjYzYgaLCDsk/VzZFrOVrKvrVwSjF1UBJG9
	ZPB5+r8aesmbmLOLdpvP7nM9w1rgnGE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95F9E61878;
	Wed, 15 Jul 2026 19:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1161F000E9;
	Wed, 15 Jul 2026 19:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784144431;
	bh=5nbMCVDVtFVWhMbY76EutKt9ipf8/7GaWfOcZIYGuE4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rtRWU1qYY4JybTJn4q2H2NQdwPLy1E9KmQp4PxCsr0qJf6LEFbjPskeEQ2E3Xm59X
	 wUvR5j+ul8YNSnXwPlhfJeFxA96YomGg+bV8qNHYcqUlO6VVDx+pBMd1OKBLpwDNDb
	 ArMR+1YWqhL4Lm7OL3SWY0GiJrwOjzp0w7JUsZy0=
Date: Wed, 15 Jul 2026 12:40:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qi Zheng
 <zhengqi.arch@bytedance.com>, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm: shmem: make unused huge shrinker memcg aware
Message-Id: <20260715124030.feb2d407e5e5ae28a39674a3@linux-foundation.org>
In-Reply-To: <ba9911ee-f447-475c-bd4d-ddd6bf443bcc@linux.dev>
References: <20260714031918.308-1-qi.zheng@linux.dev>
	<20260714213223.9a03d78f4aba252c512e01b9@linux-foundation.org>
	<ba9911ee-f447-475c-bd4d-ddd6bf443bcc@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 365AD100002
X-Stat-Signature: pp95hh4p6g7m8nio7ho9gxuabaorpqcb
X-HE-Tag: 1784144432-308790
X-HE-Meta: U2FsdGVkX1/tWuwyLjHqwE6rUyiJypvuxQG9Az4X53ktadkb8jldeF9yxBQvvTh4IBkDL0zs9Svhn9tcvd6Ei+ysjRvor6r0KF5RSWLnfLyDw0CfxuVC3aVIiS0vGtr/DpD0Wu1bZRygpzf/Rnsuve/lneopLh5s15ubZ815OzGSqRp1Bc6n+OQb+FHOq9P0uHN5H5aiM9JUoNydBCIb16yUbBZNjbMieUv2e8Lk0AJI5Ee2u3Bv9CbYXXs8s4OSYuVxYvwIIwuZnE6bSa3uMOq81q1WJto/iePrLVRt2ytZaAtmQPDY++X2Nh3klBOEIcIH+ey0QLCEjJcVuANBpLC9TgMBLC25BnkqOsaDXr+CTTTP7FhqFFnVoLcaNc3AeQkPc/sy2/DXyiTQLFsYDPKqpbnEWB62PFbkrzqDqWji5Knr9eg/qRsOg5YZSWEjQy+qOsYPRMnD5BISHpBaos7Gjg61X+xadOJsIhPbfSzfEgeMNMNsVeQbtq+AdSrHQMLn8v+5xoOkxPiEGQ9q0rjFrK5oGkIE4N61RHsMaqgQ2pB6QxGSFI23i9nn677L3q9KzSDucUCtiKRw3FzqMJIyh/DyVN/XjrSpyVjQkAQOLAaulCPfz3bqotfbVO+GXhBMN+S1XWEmxEa2JqUEOzJeA7HnEdJcNgl7/CKezDXRRZmfdgrq7kKILOs/BnRH6wcFojbyPU8TVMTJTnrx1oeeyd6kHsy9IhwtAxztA2JAK0QhN8+uODczxEiCxHz7Yt9ILQCR5aProIqDdS9EL6OOxDspRKJfe6tk2dLQ9JAOElhFOmKv5///Iiqki/JFMnmTLAYL4f2sp8oo+GmX0X30A07+LzJWrdYzQrOGX5Tj19KzRyyNTYAnVY9HaPUFK/X0s8YCZ2b5KzT78OMM2GVyBiR7UTIvoCrY/wh2rsw4FaX+8NjQm3UH+JpESL/sSKclbusk8HhaC3S26m4
 hgoM50/L
 4Jlw42kJLKpATGXUho2huwhk2gF9MoSBLsycSSPLdeuM5SfO08G2J8vEtIdR9FR2P+iORd3IgU3XUaABydIQEpKYWedhgETQbBWRM7OHALcII1xRaJjVFtO6JATGGCGGQ5/PR4K5usyBrjIh1YVMqzQgWzC3szF0qfyDPN+JQc50ObOg8EUO2ZbmtTuXhzluqWxz4UYJQ+ZWiLcNV8lNpJwIHBr8S50CZCvtkuSLYCiT63/np6iYWON95v4ZL3iXK8vhIKPFyEoTGRYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 14:49:28 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> > 
> >> This patch is based on next-20260701 because it doesn't include this patch:
> >>
> >> https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/
> >>
> >> Later on, Usama will consider moving this restriction down into the fs callback.
> > 
> > I'm not understanding.  Was Usama's above patch ever included in
> > anything?
> 
> It's included in linux-next, e.g. next-20260710.

Oh, OK, it came in via Christian's vfs.git tree.

0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")

Should we be asking Christian to make some alteration here?

