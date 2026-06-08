Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45FE7CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387976B0005; Mon,  8 Jun 2026 14:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338496B0088; Mon,  8 Jun 2026 14:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E446B008A; Mon,  8 Jun 2026 14:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14E7C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:58:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49D22A0245
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:58:08 +0000 (UTC)
X-FDA: 84857655456.26.594113B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4277C0002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:58:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nRSH22uK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780945086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJ697wuTa5/76WpGI5kWSrt7Q6BzPPxhvcCh7DE3bRI=;
	b=8cgWNMcRAyNwwVNXPCuiT7h3Y3WjjITH8RxZTWsF32RgvWbPidRESioYKykIjY6XBvRXw5
	rv6jBz90CB+8pTBXI6+mE5lwZshBNbYOar0coSxyjWI4FYgHPn1qTECRLYJvyKARbfidTu
	lob41cPce6/895NspFR+MrcTv2Vr8PY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nRSH22uK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780945086;
	b=SnY6TXC2WWwfB4V11u8HGQzuLlTgUyg2WxY+/HO/Iuycg8jdDXA1jZGc1g8cjbw8HH9U/Q
	ftQO3o6g5O0ufrvAxcn+7sZIA/o5LkfDAN5t14rGeIoyny+VlWVgiq3ut6tYb9ThAciuxV
	UaD1Q0HQB/CByuafBwblq/59uife+Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46ECB6001D;
	Mon,  8 Jun 2026 18:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A381F00893;
	Mon,  8 Jun 2026 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780945086;
	bh=lJ697wuTa5/76WpGI5kWSrt7Q6BzPPxhvcCh7DE3bRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nRSH22uKswRDdqfA7o0x/dXJbEQqCA2o3y1W29hSiATYxOIgYZV3OOWFTz5zmMz6p
	 TcaGr7cJxqVom7AxDJAdC/1wmXA/AakUEjehPoRt1S1TQMYdMJYcJdlqG3hHwEpNM+
	 5Dm7kCQGgYeu10QITjiMj9LKiHUWPq4oaymzXEzilQ04vWksWifa/YhRaLnVvN3dRQ
	 er3sEooMQYAD4Sc2aJc15ujfH/+2sRf2xFxM9uHRsmBOg+bbRxSyE5BXHVxGmzaJju
	 cthmIl2akCXOeE/mghrggqBVoil55vqdtTKiQlvn4FY9GhnAytWNipATBqKYc9USWq
	 xBCh3tQAR1Z7w==
Date: Mon, 8 Jun 2026 21:57:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY
 retry
Message-ID: <aicQtr1tbnhhqmtw@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-2-rppt@kernel.org>
 <ahhAHNSZOeW49ms2@lucifer>
 <ahhUM0A8-q0UqFv1@kernel.org>
 <aia8nKXtShnhQpVY@lucifer>
 <20260608093918.68ce9d7d5694380e3055e293@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608093918.68ce9d7d5694380e3055e293@linux-foundation.org>
X-Rspamd-Queue-Id: C4277C0002
X-Rspam-User: 
X-Stat-Signature: 4hwfa1icyf1gchxz9w79713bkubxioxt
X-Rspamd-Server: rspam09
X-HE-Tag: 1780945086-841905
X-HE-Meta: U2FsdGVkX1/+oGZ3hgnd7wBiMtiLCUYBxETgQnSLPSH3uNt5KXuBSR+JetNiMmGper9j9QF69UMQL1wcuXZ1fzsOGLg8HZMprl3rJ9uF5kiIVT4he/eH0VroFrSDllByE0RvyiC5BH/wj2kjdPw5gyxYh+JpaSa8iVzeDndKtulUHcMnPUgeHpL5wJmZHbcw1TjVgPtCO5X/51oz7cIsrREeksBjnNMgZ0lxIlF4M+xAsuoDxE2WWlOYdj0l2r3LXHt7/MFxzQt+IQKXbg5uefn1TIqM+KfK9eFXNPi6VFmvQs1xp7HrF7A3xz/qq4LE50zkaZBbvHFnldIjpiY/3plAnYDw9SnJyhqrtmyqINKONVJQdQZg3i4iL4aqEjV1JnicKgAAVsW479dgL8/T+Xw6nV3jUoOBuJFJ8bjtz/Tf3ztkqJ6Q2NDRcZv25iB7VUbPA5WdKtUbWAPT8MZkd1TidcSoCFbSc2qxySE+7rkd4yYrFtOGSnYHyEz/R2x1JbG3Mw9i2Uvs85LJ/KVoNe4QQaDzyaTOOhWMkz1fZMpxslItjSafzdlWMDIdXrqEGnaEqsiylo3fggQHQMJSJ68XhUvSx5eVVqL7851HVU2UfosW5oubHejmakVsHq3CiHwCchLiCn4fPWfFFSOwsIvi3zUo0yAX9cVwQdG3WKyqgSL0JHSWP/LJcrQr9BYums+Lg8LdieN9X26NDq6rhshg47512uVNDz/9RgJbNIPQu02lUqDcLwQ/UJ2PNsEpfKuJwtOzH1eky3X4w0A40hB167gJkeqGtT+USdVd9MA/gSNc9WSPUC6d8zamL8Bwpz69w+cIY/nF41LPknF0QnxYhJG0iKGScD0HZuT0Il9iuACIrnRZfOjXWu0FAZqn6FhQV58yxiEvMsfWivaFZzX074o1FNkHaOIygDXbsdF3iJpdxa+7rnJ21FjyZ5y1Mtvcxji4S+LJuoQHJfn
 E+Him6a1
 JxVRCBFLX14H3fRfDuIEsTqRbq3rqyiZ0smuT0tlaYSC4xqojYdMWw5/8VL0oNi+gMVgHJBjGSa98SnaXS4gxfGwxgoIq5beF1Da3bCJFE3iBj5J1yvkG/4oaV5VwUDr0GnlpFp2F/NiZTMSWlWlXs7DfenHNrLEu9qgNw4BUoLXlbGyfBgwWjbFpiau9uNzb773r8nke/Sb6ZJZQCv7cY1d/6fFwXkjdFvPsscGdtgYep4y8ObsqObN9xdc0698cqw+Na6nZOgOBL8MeTUdYHINwa0McyAOlbJiKauXTVAegL2OdwfbJDgPOh2of6NgJg9zuoFVRbVlXsCjSFyUAW9zu+kILXnOgbylSTyaFWwGbqAKBmwXkYZU+QjwGv/dEGubFPEFbIW7z5w/XEbLS5N+SAxEpz/z22IX6QR4Asmtn+JU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 09:39:18AM -0700, Andrew Morton wrote:
> On Mon, 8 Jun 2026 14:03:11 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> 
> > > > > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > > > > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> > > >
> > > > Did we want a Cc: Stable?
> > >
> > > Andrew adds it when applying.
> > 
> > Hmm, I didn't think this always happened by default? :)
> 
> Nope, adding cc:stable is manual, case-by-case and the -stable
> maintainers have been asked not to automatically backport MM patches
> which contain Fixes:.
> 
> So this one snuck into mainline without the cc:stable tag.
> 
> Thanks for noticing.  Greg, Sasha: can we please add mainline's
> 85668fda932a ("userfaultfd: verify VMA state across UFFDIO_COPY retry")
> to the backporting pile?

There is no need to backport, both commits that 85668fda932a fixes are in
7.1.

-- 
Sincerely yours,
Mike.

