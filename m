Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A31C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B454C6B0096; Mon, 27 Jul 2026 17:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF62F6B0098; Mon, 27 Jul 2026 17:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF876B0099; Mon, 27 Jul 2026 17:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A06B6B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:58:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0C21A0180
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:58:18 +0000 (UTC)
X-FDA: 85035920676.12.2CA4A31
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EDF71C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:58:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=A7rpJQNX;
	spf=pass (imf21.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.185 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785189497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbVWiCOnciwPOgW2IJVqPwmQd6+/KbTHtd51p0uPjE0=;
	b=Gaj6VwWcddjBFdWPoy/A+0d7ArAD/i50y9L08urayUUu10vB6ITXmTi66A+ZVqKT30jrzZ
	nsKMsyPTK9DG8hGgqJqN1nlGr3q9Nr27hKb17nmwV+/tY3lgE6aWO73uGg4runLmddXrJM
	NDD5qSPoBkyAxfOyCQNQkuKYqi02ngM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=A7rpJQNX;
	spf=pass (imf21.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.185 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785189497;
	b=F0d0aFisKpPa5QXQeK0W8ZB2YW0xmTkyge7CUYx+wGyZ/IEtRd0iuwkzZ77+ny/rVbqkt0
	vEjsZc4cAlfAS5zJMNLJmspVO1hdqX04RR4S7H8ABeWVFsSX/nu5+3KtSkV7mK7YI7GXK7
	zY9UzxJfdDpOgYrq21oh3dZIwYuFCJE=
X-KPN-MessageId: 43e2a7fd-8a06-11f1-9e8e-005056999439
Received: from mta.kpnmail.nl (unknown [10.31.161.191])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 43e2a7fd-8a06-11f1-9e8e-005056999439;
	Mon, 27 Jul 2026 23:58:13 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 43e135c6-8a06-11f1-91ce-00505699891e;
	Mon, 27 Jul 2026 23:58:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=kbVWiCOnciwPOgW2IJVqPwmQd6+/KbTHtd51p0uPjE0=;
	b=A7rpJQNX3I4W3P2GahNM4wr6Ik4+icLwhtghF8CztQFEFNCkEGoLFYFrqTiXTt6N8udVR3+4T5RR0
	 QfPJeYvd/meHkK7s5JS0eydOfJMmUFzRB5iFA/l4E04uncxgzgxt/JHEwuuvqlIDyBeAm7Vbfgg4qA
	 sWEDxL2LeAYkITn7uxDCags1dp2a26aP8Qm9+4RaTMidE9uspK5r5m63V3n2+7MXJTf1PVUjBiAFKZ
	 fTCC9DMSxlaE5iRO/qUTUg+tT+19orZrJaLWnGn/E+bE5UgYRBKY22xIk8rtVRCRbgjdfcdv12Lh3B
	 74FOQa2T2TU/QOiJdIZzgOzjwZwrN3A==
X-KPN-MID: 33|PTEeDplm1cnWA906pLvPrZh4h4TH02u4wSAoZNiMJnaNdL/ZxEbkbc3H1W9cWmj
 NlCfSFpIN+hzcE5wj4eCxqyVXx0sOkEWQAw/KtPEIosk=
X-CMASSUN: 33|T4ywy3E8DjAslRqqFuSgjNDbFQ/cOjqB84OKTnQCEVM82lKDQlDEfkYLtQNBo49
 Y3VPikqJ0CSpEW7t/cexCWw==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh08 (cpxoxapps-mh08.personalcloud.so.kpn.org [10.128.135.214])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 43cf5023-8a06-11f1-916a-005056995d6c;
	Mon, 27 Jul 2026 23:58:13 +0200 (CEST)
Date: Mon, 27 Jul 2026 23:58:13 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com,
	stable@vger.kernel.org
Message-ID: <1934849422.317115.1785189493726@kpc.webmail.kpnmail.nl>
In-Reply-To: <20260727-lauthals-peitschen-aufopfern-1bfd12376820@brauner>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-3-a162f7cb58d6@kernel.org>
 <amTXwUK2FXu2sHI2@lt-jori.localdomain>
 <20260727-lauthals-peitschen-aufopfern-1bfd12376820@brauner>
Subject: Re: [PATCH v3 03/24] binfmt_misc: reject a flag character as the
 field delimiter
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.226.150.234
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EDF71C0007
X-Rspamd-Server: rspam01
X-Stat-Signature: tywzkiftqd5cqgi8fqoddfeuwwbie9ef
X-HE-Tag: 1785189496-191301
X-HE-Meta: U2FsdGVkX1/9cWPj7w7qs0AzGfEztF9dR7wUanzuWlo9GU6jaCutlE+HMpV5XX5Iz+rROFAm+y1eMMbDS8X5vdJGp9vrK9DpxRzklr4ToaERoTS9SxiZDn/K/zu5oyZ/rNToT8EERpLBNlyl5y7yqFEwjVDB3j6HA8XhINf5YBI1t8HzGUJjPO33AsuglGSqcb94EHrbbMor0V+LokwB8VgqUQVippPcccrvQMbpOlz1arLuryTH5u8lqVuwix2rCXFO6u6b1WgFAUtjs9ODMwuiO5J04KFlhnOgQiGh+XROQVc1PQXiHGtRsH9kkZ+j03/Q/H/4mp4520rZAj2gTnOkzZ6o/hc0zo/zeS2HJ5apk11NIHCjH4ZkYEF2GHfDSKHQqmeK29nhS/tcxseICmnMmeoZTyyS3Fvnd+FXgkk1EHi9ckRiasEshsqZCUx5vjkM9cpsrvi20PxOzOPwpXjjM/gIXsP35sk1SA1mFP3vAPYWEQ5FvTzGF5YvUiFL2qpEX3luK6INIWy9+Apo4JNi+/X2LI5j3lOSkUhf6riwNb9Wj7IuuLmdFGaUoPDDMI4VUFkJb254WIaoHqR0yMvr2aDumMJyTnYaYQQaEn2em0FEDdUpUiieesJV5ypzsQ6WEfmVO6wBrjhEzQfnwM/MdNR6/xLz+oK1gksbGLJmUJUHj9bzu7Y6DQNLfnCtOmz6yfgDViU7SFXjCO0gQ2IyaTaZIIfu558OqHf4ht8ppE0nDgRfY62kAxZWa6a6+fQBvTvC/VGQrHg3XTJGlcdyiMvsYrAdegj5/e/i2/NfhsNvm2xNCOFslfRiN76isGQbh2Pea9CaQxBBEXIpTdpRvpyZ3yqpJTepihlB/bksZEwQKc2clTpFNnfzW7qYRbwSAkzmn3MciFcYCLhvLrjdLiIJuFgcyWwgNV0lbfrzv4wPiFGyghpLw0tF96XSP6F/Swb3l6NWrwgWA/J
 FI82RY6J
 SA0TyUO3YTuciYEbZuK62hDTgpT34O0JLkqmbdtbb/Sp8iCYbaYbH9JVdoxA9q6dLJtrKcMRUulefQW8L7Ss3YeOIuhgO2k0HZILCmymK9KBw1vSTRk44QQmVL5ls4tUBP8WenpaCJZjZSXHYBHiglG6Og/SrL55mgOWy30lCR4O0W8AM5M37Uz/Eq8oElyt4UkcpLPvh1YEI6SZWlI19I24xwzWqISCltZZA+OWfMOZOJWGkAG9Fvydkm35Ucm5XsJNUifJr5PnzpY3Jfo9h1srT841cb/G2Mw0zNLQs9efMqtQ/IfRrH/LA/3Q8dFGKPW+AntcItFyJqBqv8/h5Dy0gkiUncwanS9aJAOfGD1zU7lagy3ivBd6yWjPGg1OxA8r1Ty5PhtzJePhVvcdMetaNhmk32wYlSuYcGQQqUPOr90usYX3Z75SogJzZgFj/M5WNxf3/Jmxw4G/0WnCtlCVKCB1DyORJxXmBfDjBpzQMJ0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Op 27-07-2026 09:35 CEST schreef Christian Brauner <brauner@kernel.org>:
> 
>  
> On 2026-07-25 17:37 +0200, Jori Koolstra wrote:
> > On Fri, Jul 10, 2026 at 11:33:04AM +0200, Christian Brauner wrote:
> > > The registration string starts with a user chosen delimiter that
> > > separates the individual fields. So that the field parsers terminate
> > > even on a truncated string create_entry() pads the buffer with that
> > > same delimiter:
> > > 
> > > 	memset(buf + count, del, 8);
> > > 
> > > Most fields are scanned for the delimiter with strchr()/scanarg() and
> > > happily stop on the padding. The flags field is different: instead of
> > > scanning for the delimiter check_special_flags() consumes the flag
> > > characters 'P', 'O', 'C' and 'F' and stops at the first byte that is
> > > none of them, relying on the trailing delimiter to end the scan.
> > > 
> > > If the delimiter is itself a flag character the padding no longer acts
> > > as a terminator. The scan swallows all eight padding bytes and keeps
> > > reading past the end of the allocation until it hits a byte that is
> > > not a flag character. For example registering
> > > 
> > > 	PaPEPPxPPiP
> > > 
> > > with 'P' as the delimiter (name "a", type extension, magic "x",
> > > interpreter "i", empty flags) leaves the flag scan running off the end
> > > of the buffer. The registration is rejected in the end because the
> > > parser does not stop exactly at buf + count, but only after the out of
> > > bounds read has already happened. With an unlucky allocation layout the
> > > scan can walk into an unmapped page; under KASAN it is reported as a
> > > slab out of bounds read. binfmt_misc mounts are available to
> > > unprivileged users in a user namespace so the read is reachable without
> > > privileges.
> > > 
> > > Reject a delimiter that is one of the flag characters up front. Such a
> > > registration was always rejected anyway, only after the out of bounds
> > > read, so no valid registration string changes meaning.
> > 
> > 
> > Looks good, I see no user visible changes.
> > 
> > Can't we support a less arcane and impenetrable format, like JSON
> > or YAML?
> 
> Adding a json parser into the kernel is something I had played with but
> that has a bunch of very subtle pitfalls as the spec is underspecified
> in various ways. Also, having the kernel produce json is one thing.
> Having it _consume_ json is a whole other discussion. Ideally it would
> be done in Rust.

I might be interested in this, apart for the binfmt_misc stuff, this can
be also used in other places inside the kernel. And I would like to get
into Rust4Linux more. We could talk about it at Plumbers or MAINTAINER
SUMMIT (if I get an invite, but that's not too likely... :) )

Btw, could you CC me (if you think about it) for any of this binfmt_misc
stuff and the other such as failfs. I am very much interested and would
like to review more going forward. It's just been a bit of a slow process
as I am slowly picking up the pieces of VFS I am not familiar with yet.

Best,
Jori.

