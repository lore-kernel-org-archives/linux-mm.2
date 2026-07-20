Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6928AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141306B00D8; Mon, 20 Jul 2026 15:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CAEF6B00D9; Mon, 20 Jul 2026 15:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE206B00DA; Mon, 20 Jul 2026 15:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEEA6B00D8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:49:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09296A02B1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:49:28 +0000 (UTC)
X-FDA: 85010194416.02.050C1CC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id D81F24000E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:49:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qj/Mtlqt";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zMHoX60t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qj/Mtlqt";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zMHoX60t;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sahaS+eSnRRANxBUZMw2i+88rgrcxJQtqcGtszC7BNA=;
	b=uNVkOYXV2sh3nG9sMLYhmUe8PJOzrvb7XUeUfcJ5XopOdE7y5YEHKbxTFAmf3Ty78r9mkc
	LT2yDwTOgj6+/mRUDI5ZRHSICxeTjK3qY9cOUJG80OAobfsGeIiEg/aO9/XbgQ+HnHw0EB
	GOjQQDu+6x9zEwu4fDFSnFlPps9VkOY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576966;
	b=sKKaGAUKbxg/5enUI+/1eLW8O02QfOBuYp2PrL+/uPqEkbGxxGdO0wvP0Ahzxp/1ekKJ2G
	suOULLrw8+egDXjM+9lssfwpDaUBq7yuKub6htK2iKWhJnMXLdhfzw8eyOFjHceD2QcZ16
	RVhshFX+lFb7zx+Pcpn4ZCOVAsRrCxQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qj/Mtlqt";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zMHoX60t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Qj/Mtlqt";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zMHoX60t;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 30D777A138;
	Mon, 20 Jul 2026 19:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sahaS+eSnRRANxBUZMw2i+88rgrcxJQtqcGtszC7BNA=;
	b=Qj/MtlqtSzigt07XoXJd2XOTVfsNBPBYXpzrmvkziJ0hW88Lm1V0g9admG4giDyCkCo5fs
	oMz3Ak1c5MVUn/R7pfdT45gDveCCTDY5a81I2cqM8641V50rO0hRILnfUki7o0SAbaQp0L
	1YdLOovscQ8nsxlp1+7/IWlbk9JJXgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sahaS+eSnRRANxBUZMw2i+88rgrcxJQtqcGtszC7BNA=;
	b=zMHoX60t53GzbqDKHxPsQ1jfQ6JSA4/KXRbtQ7KPCJe5ZTobD2oa7ZD31DGxGmvtDsu5kv
	qt/V/0NPoGSwTEDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sahaS+eSnRRANxBUZMw2i+88rgrcxJQtqcGtszC7BNA=;
	b=Qj/MtlqtSzigt07XoXJd2XOTVfsNBPBYXpzrmvkziJ0hW88Lm1V0g9admG4giDyCkCo5fs
	oMz3Ak1c5MVUn/R7pfdT45gDveCCTDY5a81I2cqM8641V50rO0hRILnfUki7o0SAbaQp0L
	1YdLOovscQ8nsxlp1+7/IWlbk9JJXgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sahaS+eSnRRANxBUZMw2i+88rgrcxJQtqcGtszC7BNA=;
	b=zMHoX60t53GzbqDKHxPsQ1jfQ6JSA4/KXRbtQ7KPCJe5ZTobD2oa7ZD31DGxGmvtDsu5kv
	qt/V/0NPoGSwTEDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34123779AA;
	Mon, 20 Jul 2026 19:49:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hfILCcN7Xmr0BwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 19:49:23 +0000
Date: Mon, 20 Jul 2026 20:49:21 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/khugepaged: collapse_file() cleanups
Message-ID: <al56t4zyjYlCl-20@pedro-suse.lan>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <CAA1CXcAk1SYopaokUGbT7RK9+gPNN2Jkm2UrpMaZWShjG3-z8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcAk1SYopaokUGbT7RK9+gPNN2Jkm2UrpMaZWShjG3-z8g@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D81F24000E
X-Stat-Signature: ixwmps11ajx59og515yzyojik5zz8tb4
X-HE-Tag: 1784576965-456690
X-HE-Meta: U2FsdGVkX1+qYXzzIhjH2p2yU1yRPDpD0r/GjmTfvA784HMaakWJHttvFe5z/x5B9a4fSyYJgzY1ds50qFNcVtjSwaFQGWKtyVpwbABqFogSb/BI6WDW4Gg8wTuxDazPonDtIW80eq5bw0DFTBa9orS/UHoH8UX8ke4RMqn7ZoJCaIgrpvPZoqEyTD0hr3jDeJFLRyRqjfBc8AHAlulLrvNc2JXVIYtshdO53zLecVCeBiHt38/liXaG/PDdYiIHASdLnpVvCb0qoQKnWFr0A75SHxGLQTAlzOU2S2J9e9f4twpFTjpItpTROU6+1LzYhz6xQf/u5dCNYWxjrWOn4imXW6bRO8oIIgmw5cfPulwB3gXEO4wotRW2ErVbsDNO2O/I44Ph9BR86zPKJDnFWsB+VBpa8tJY7fQEz+9yuZJGDlgwG4I81X2lIUq8b9evIBXWPGvXn1nOkOGXrlGL1RTFgiuu4ReU4fBLRYaB0wG8DqasTtVfSP9WHm2RnJE7o9+hg2scICzttcz/UOZMarclmIDPB7JRhZbteqbRatrbRXe1KCJKTvmv79reLfYuYRK83AevJSJXQirQr1FXh6RZ7pBd2ZK4xQQ3oZh7nsMguxXqw1toul/0FlPCegtAztIvmZY6XpmE8WehmJ9aV2FW8dzeyqCm8zTG22dC2mWe3iWegPGOQa7GMsQnptJuvajnuN0sRzspuHMzyclZNToGmh88cLqeR7pRzyRzlrF5ri4EsPIX4YLhbyzEi6+QgaSXtFfMYuJlW2c4FkVpdfMUBYZliqnAPAU5pfB2htrXeMuw0xyaItqnX49quu6jViTbjCrn0hJ544rvbPvBCkBSe3Moq0Vnzj1aw64uOeiUWXU1QSEqrMcBAqH+ZyTWCcGcmu6wCM7gFZHsPFks5LeK7wnKBENd8tuNZ9nVWa5O2HJfJxozAcHHb+Zh4W5mURzrMuLF+OBXS5Jb5ny
 R5wArBNv
 +oktuaxPCZlcW/K1FyB2iLg61kjW6U7IbncOZj2i0athI7bW1tRPARG+qcxzPavxc96lYBww79N02TxPKR+E6fmzlNt4kJD8jWnohjzmcLL+Hn4lrid8gM5Qy9jBkEWQY7BYxMCyQ3BPCwX4f+z2obXEmEHl8gVSVq96c46yu+1SS+khiqQCrKR4dRvAi5M5J+ZhL4iNCBnJ9XClGgqMrfhLpaGq0ZEhTlwn/JqOkqkmD3pEmRadaKXC155WR8MACBxb0u2DFRYH3636vo3EO7VwtGUPk6uMxBaNm24ANMA/pnxY6C/5EdyYZBfeOe05C9He31s4vA1/Q5Kpbbi5WJ4ebcdLDlC+yAdl2YYk4LqbPs0vbRl3WRTE2JnzM6VeAhHx0XIHmBCTuH4qN9caLh42JcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 09:21:11AM -0600, Nico Pache wrote:
> On Mon, Jul 20, 2026 at 8:33 AM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > Here are a bunch of cleanups for collapse_file() that attempt to aid
> > code readability and understanding. This is part 1 out of N, and only
> > attempts to address the main collapse loop. The exit path is still a
> > mess but I figure it's much easier to review if I send this batch as-is,
> > versus sending the whole thing.
> 
> Hi Pedro,
> 
> I have already prepped a cleanup series for collapse_file().
> 
> I was waiting for my work here
> https://lore.kernel.org/lkml/20260715025941.1571316-1-npache@redhat.com/
> to be reviewed (and in mm-unstable) before sending it out.
> 
> Our series have several similarities; for reference, here is my version.
> https://gitlab.com/npache/linux/-/commits/khugepaged_file_refactor?ref_type=heads

Ugh, this is awkward. Do you have any suggestions on next steps?

I can try and take in some of your work on top of this series. But that might
be hairy.

This situation really does suck (I've definitely been there), but I would
prefer not to drop the patchset.

-- 
Pedro

