Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE429F506D0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17AF6B0296; Mon, 16 Mar 2026 09:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC54D6B0298; Mon, 16 Mar 2026 09:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF14E6B0299; Mon, 16 Mar 2026 09:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEEE06B0296
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:47:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4313A1A0255
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:47:40 +0000 (UTC)
X-FDA: 84552053880.18.BBD04A8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6215A4000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:47:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hNvbX3li
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773668858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGSE9d/MDgSUHB7IOyMM2Jrkqp8fufTF8CqpO2g6g2c=;
	b=CiaAMk2WXeftahLC+O4wXoaxjuIBnx4N1ej3YD3N3DEfPeiHvUuOmnP5pNzU3EWq/nWc0M
	aUD2d4TZcbeVOEPFH7j5WIIYx3cUp1NxJPUksEXtOvzY5a5pdlng/nDOeF2X2nddPt5qcc
	DEMsE6XdjKgdvxwqvFalBsFNIGZ8BDk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hNvbX3li;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773668858; a=rsa-sha256;
	cv=none;
	b=J0HfuhP0ZF6WQgkmMr+B7f6gH0U1LgOuc6SuUIbQhIDcT78JPYgT4zreGdFLkoaYJQZ0XO
	tpIawwdiSvNbEalDb0bkRQ2MSYRM0zU5osEaFrxW6shvwDx55EeiQZwBhXCWsS8FWkH5NQ
	pnnpnWxkWn0Bw0TPq3iMiOOBSD4Hlnw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uGSE9d/MDgSUHB7IOyMM2Jrkqp8fufTF8CqpO2g6g2c=; b=hNvbX3lissU2Sh8U0MB52YkS6h
	VwtVXhWP7Si+x2TgVDzsn3CTWEsTNyAsA3zZq0ssPCTJSTNwxpsCiVV/q0jP4wAbOSCfqZvRMol7F
	GSckkpljJwbpegHXvl/JHF2feQFjA/Xuh1o4WTWVs6ugZtS5ulW6Pfm9tzfzqeH79IQ0Jo9GmMRfO
	CxRGI6tv0SBFFMux7RYAVOOtsqYCDJleZjXGjZMQ4WZ8YIFkAPS7DO/rA99KR8EYUxPRvIGUjVCxd
	gJG1qiKVuzu2rcBFveZ0A3iBjF4NFg4/zE9hDUY2vkkjKQlze4++FVmpumfJZ+fZ5NAH2mNvk2xEW
	fQfaL5FA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w28I6-0029i2-6h; Mon, 16 Mar 2026 13:47:29 +0000
Date: Mon, 16 Mar 2026 06:47:23 -0700
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] selftests/mm: add THP sysfs interface test
Message-ID: <abgJtJYQsGMPsTHr@gmail.com>
References: <20260309-thp_selftest_v2-v1-1-a00cef41da44@debian.org>
 <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cb63c24-eaff-4954-97d5-2a422a0401fc@lucifer.local>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 6215A4000D
X-Stat-Signature: iei6t4kdmnteapeuzkxgifpsupajb6dn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773668858-271688
X-HE-Meta: U2FsdGVkX1/AksB4z35zoyaJndAWJaqQ0ModzgO2GdYA0FzAHOfhoOPdwTalJo6SSyoJ36BHKKRd5YnI5puOy2KP1YOzGFGJ+G+yw68d4aKQWnfw+mQaaUdwyu69HvTeoGP9it6d/Ft232+hWLto+okLYe7/cHZk6NHZJJFN+D4FHg680KvxBIS0hn2oyYHNcMxRHvU+z8gm03bf04J048KFcaYSdOUt/q9jHW349y9AhdO7vPOqrJKNEQqHImPWAbQkB6XBe2A+YOaQfeNTbSwWu/9AQOIhGdg6J/dxZT+pATxRnFzkMciCsN00XHR5ISpfZv+/TS/QURnRt3lOt91/RbBL/ApjBg6NVgaGRRpUhkvRBjV1wWJkpqwubCNmY8kRDfBuk6qzUVkUFruuM8MubuQJAtxWnNqnUhffVLdMFEJ43kAcSMoX6j3RjKdmYyf5NAPkLsKGk823Al/djY/E8zkCxGKElFU3tiTLiKvrI8sogjP7+4XRstgfjq7vxyqNKzoXkUA6yzkwdvrl4anNmXYDFGuXV0YsO1Rs0Vaa9Q0EZ/viJxoAsQEwVqELiqvzye6r4OaN6pzfU/heaQUB0uatHXistkgCM5cZPLXq917f/dHK7hu0oZRW0jZB0SPGtUTvFCb3v82c9MDoQqlFBn2GWlnhVCb0okWWrP5rTh6yn/ChMg7EIZJnby8z9M7yJJsIG4SAiNJ5Fq5m2CpbxefZJP1h4b2govZ7W/SkfVsx80i+OYwaQozeeaVJpz5XoqELZ75wzx5HNKQNYiThDhPKFKtXgZgW3iQ2dkZYAeH8Hb4+HVg9ff38/0amJY1XR3WeHMwSO0vtrLyiMBUvVUW59yGlsqEi8m1RYixFX+0fzIjYYJRLeVSCKn6ak0tvxzlXjCAf1kC4fh9plhdIJO0H0EHdiIW/CL0fJkt+nxTNABzhMqfwCQQ5mXAP1OcYRmBUtag4mnlSXY1
 TkCU23bw
 Hwu57wBxTnVnqz35XgE4jnVxnfOrY+daVmNBIi/CaIblmf08y2Qyd5Sy7nbWOkDX3/8+sdfSr5bRPAy9yTObeJ+PrQR6cEVctuAy/v7dl746+H8YGHinn9RKU20rFkEqF6E4JBYQP8O5hMAfdA/qW9A0MZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:55:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 09, 2026 at 05:00:34AM -0700, Breno Leitao wrote:
> > Add a shell-based selftest that exercises the full set of THP sysfs
> > knobs: enabled (global and per-size anon), defrag, use_zero_page,
> > hpage_pmd_size, shmem_enabled (global and per-size), shrink_underused,
> > khugepaged/ tunables, and per-size stats files.
> >
> > Each writable knob is tested for valid writes, invalid-input rejection,
> > idempotent writes, and mode transitions where applicable. All original
> > values are saved before testing and restored afterwards.
> >
> > The test uses the kselftest KTAP framework (ktap_helpers.sh) for
> > structured TAP 13 output, making results parseable by the kselftest
> > harness. The test plan is printed at the end since the number of test
> > points is dynamic (depends on available hugepage sizes and sysfs files).
> >
> > This is particularly useful for validating the refactoring of
> > enabled_store() and anon_enabled_store() to use sysfs_match_string()
> > and the new change_enabled()/change_anon_orders() helpers.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> The test is broken locally for me, returning error code 127.
> 
> I do appreciate the effort here, so I'm sorry to push back negatively, but I
> feel a bash script here is pretty janky, and frankly if any of these interfaces
> were as broken as this it'd be a major failure that would surely get picked up
> far sooner elsewhere.
> 
> So while I think this might be useful as a local test for your sysfs interface
> changes, I don't think this is really suited to the mm selftests.

That is totally fine. This test is what I have been using to test the
changes, and I decide to share it in case someone find it useful.

Let's drop it.

