Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD92CD8CA8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 20:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9476B0005; Sun, 14 Jun 2026 16:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0776B008A; Sun, 14 Jun 2026 16:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F936B008C; Sun, 14 Jun 2026 16:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 436726B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 16:29:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD40D120816
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 20:29:51 +0000 (UTC)
X-FDA: 84879659382.16.B73891D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 22467180006
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 20:29:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYDwSm03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781468990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmUoJYqaVdVHGV7w7+TmyHFK+lvk5ocel9J4vmj8ogo=;
	b=rqHaxU8Ecw6cx0KkfG7KUag9GnXo+NdHRAQmVYYcK7g1JpBqz1RWiAWq2oYjou/qG5F8xg
	F5gqvEgcJ0lrPKhNGaU9zdAgQe22KtBso2en1pLhFDjiGVAM3kUBCEKAMp+XC4VDArCifv
	2UdgfqMox9luNt6MUeBKLCzT2H3drjQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYDwSm03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781468990;
	b=tga1Bpv+/VPUfPbF+46WtBs/eWloCYDETA17G8MWByfmmWafrZuYJb0AxJHGGH8gvUJRmW
	WUyYizALcXakPlRY77XJenDrM8zkYcCNM9dDAjPgCXum/FouuZBFt4XGhvASMlmYwdnOEM
	ufeXMJX/wZTRbCk6NuFLPtNtfQfKXDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7E4540138;
	Sun, 14 Jun 2026 20:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931491F000E9;
	Sun, 14 Jun 2026 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781468988;
	bh=cmUoJYqaVdVHGV7w7+TmyHFK+lvk5ocel9J4vmj8ogo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aYDwSm0383Gdgkg6dRBN6iou+Hh0+xVWh+A7/C9B1O+WfdGdJs/gZ2xxZ2mZFqQrG
	 3GRC3iiE++STQf19+vmj//iQnB2GlGhRi+lVqeC7AsCA7kZ5cjkmM82H19CBDRqJ+v
	 NFX5jO1S62yAnh9albUSwgXsIezzCbzQIDdSGMJtQXUmHurn3+mujGe+NHrCLD+Swf
	 f03DFhawbt9ZfNXpmeI6X2iKBw6TxVY9Ggfv6WMi8WdlGrAx8slDoWior29fxjbHb8
	 I+CsDpirW6/7E/qUt620Y41Lb7Mpty/4i37thGO6YCOHJBUCkpuu4DRe8JCUN9cDbb
	 wbRQXOn7xHBSw==
Date: Sun, 14 Jun 2026 10:29:47 -1000
From: Tejun Heo <tj@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot
 installs
Message-ID: <ai8PO0NThJeuQYzy@slm.duckdns.org>
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-2-tj@kernel.org>
 <ai50IpfcvBiTZ7Ss@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai50IpfcvBiTZ7Ss@willie-the-truck>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rw7h85gpwpcri8zrfs9sequ973sshdq4
X-Rspamd-Queue-Id: 22467180006
X-HE-Tag: 1781468989-392109
X-HE-Meta: U2FsdGVkX18C8A2V/8dxCNhJA4qUW4+6eID9Ude7e1YTrfIaT2JgtOw+pE3KXlAkKtcNFBfTtEo74u7wNzFrv0X/lPyOjHyaWuDrQ1EiekHO9Aufloa8B+9tGk/5F6FAIprraXxo3TxNxsp4x8pxfH9/W3IVYPbj1MQHIWLwsOOqGp02sbrQ52ikDxGSPGkLcDvp51ko5Abt/bvORXBB0MMritfp7S0r1FyPYt3L4QV3w8+kQCaZvOKyZAZbWtJal8VaPInhpeGzfJ2sKiV5VvecMgaBRM+HaRtp8qlY3RQPBmszAQU3WqFk5YbmqeU+HC31w5KYi29X3m2EgV9GYTVBfhaHoQJ0nIhZ955cBM7hh1KUyJAmU7YRFYP75banh0r1djuHSX+0Bzixpm3RGjR/MFmnweETgMgaYG9UC/K737JDxWepGhaTgqIOpb3J9NSK5NjK1IuunUcrpgoku9j98mDGsqpaRRiHMcAY0gHIfhGPkrPkwQ6eChU/cBf3qXqv4O6FKHMEafKd9Y3FNugZJPtKaJixvDIQHIDDWCOnm8dXvNDpQkBP618cxZq73yFein7571kkSPcG/MQg9n1xBGOajnXKaGHZ3iihWWiYKYW0OVfg91H2w160Iqe/85GmZzy72wBV/BI97gHJxIZ2EZ8vNxK53Lqqt1C/y3fKLgHkLvbNDH1arRtIW1WgTW3OP+7zD03aWfI1FEqgCnPvJh13HfNx9CY45TL2WGoGo+ohKkhuGVHHG9o9jA1F6RK2aoPD5Dv82izojmCr9OlP/wmcvFG1Px5d+UrS0oNvu1cLIEl5TVvOHzm+lxqrm+YymB8aUyGStmTS/1Ru/u95f2/XFNurKm8o36pu69tgfmVJ08e/RSfNzrCLFCt+VCcwF51jaELl6uZZtAz68zTdnTkjStS29jotHSRm/bZ6A+Pgy4rPIHEEELC8Zv9/61X2lBGRMsc58OsvBJS
 WxHqRZpI
 BQaeS2xR12UI+5cwYpk0vm25BqsB22ZpCuwIHf186DQvgzKOpWYfq0x5GluKTFoMEkh7H6r+mwiATfU+JSMHmUIaET0tJEgn8vIywn8dewYttKTyHcWGfdk//DsXgsyGRKFDQFo8gfV5D43UW5E1FZ/usPWeJ9VvPRA9gcaZLKk+EYqSu4mfsQKLKZns3ZMoMPNxMJw0PV/LtNeu+rGUBZDQZa1BkWgZauVIZ15ORD9H4Ow70/WEo+2iEqbmGv3UgXlHmJ7UUUDzDqUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Sun, Jun 14, 2026 at 10:28:02AM +0100, Will Deacon wrote:
> > +/*
> > + * Note: strictly-zero compare is narrower than pte_none(), but the gap is
> > + * harmless: a fresh kernel PTE has no software bits set.
> > + */
> 
> This comment really confused me :/
> 
> What is a "fresh" kernel PTE and why do you specifically call out "software
> bits" if the CAS requires all 64 bits to be 0? Why is that narrower than
> pte_none() given that pte_none() for arm64 is:
> 
> #define pte_none(pte)           (!pte_val(pte))

Yeah, that's complete non-sense for arm. The comment is about x86's
pte_none() excluding DIRTY and ACCESSED due to an erratum when testing none
and how that doesn't matter here. This shouldn't have been copied to arm.
I'll send a patch to remove that.

Thanks.

-- 
tejun

