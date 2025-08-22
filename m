Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E963CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB7D440159; Fri, 22 Aug 2025 13:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DC08E009D; Fri, 22 Aug 2025 13:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9C9440159; Fri, 22 Aug 2025 13:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 888B78E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:10:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F1D457DED
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:10:21 +0000 (UTC)
X-FDA: 83805031842.06.951275D
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A6FC140009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:10:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUabDw3xJ9lObSyqXroZFH85/q36+EGXlX7Bn2jvj0E=;
	b=Y86Wfyd24iO5odWT2Z9VP6QWWOrJhE6s57NAaYTlU/Szie5H1eB509O431nRizD2/sMEH2
	sEzH4SRLJcgklnTXAF8cwTf9ZV2817YqiHBCK4DGjxYcY0YKDmfH57BJlz2bsBSwjPVxzH
	fneZAP9/Fo6DmHzV2NBocHzHV8Z87m8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755882619; a=rsa-sha256;
	cv=none;
	b=Ae/IGtcCg8EARrXs23vsleqUJeK3pZUbnDAYFPEz3TbHawWbHXMv3j2/ZsEdsd/8MwhtH7
	pG6dwYmDK/JLsjuzS5rr+l0T52KUj+12AF50tVElU2NhshZ7sKGaU6fqyHHjYVU1eqtoLW
	Eo0Y77YAgekdQbbrhcXFSxSy84g/Oho=
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5736EB7A90;
	Fri, 22 Aug 2025 17:10:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 3CDD26000F;
	Fri, 22 Aug 2025 17:10:16 +0000 (UTC)
Date: Fri, 22 Aug 2025 13:10:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: YoungJun Park <youngjun.park@lge.com>, ksummit@lists.linux.dev,
 chrisl@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
 linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: Re: [TECH TOPIC] Per-cgroup Swap Device Control
Message-ID: <20250822131022.4df59a60@gandalf.local.home>
In-Reply-To: <aKihqI8PWLFL1b5i@casper.infradead.org>
References: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330>
	<aKihqI8PWLFL1b5i@casper.infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19LWSoxWBbW+ZtdStBOczpzKGU7lR8YkQU=
X-HE-Meta: U2FsdGVkX1/ulOwYB5xVWtXm0MAwONwqumRc8x8A18URrWHtS+u2SgBpr1PuG7HI6bLcwev9pHrvj43UHdexy9Fg9Wr36c+zB2u8KmqQlvd1SecK9oNXA8cgwKcBLphDbNwy+qVLtOi0r+7zoKHXswj5iZ/jGlQwa7om9oprPL1RWNIisQq3VY77TERSiU66Yfnyo6woojcuLvWcrI8QZg1KFRm9Wslyvv/KFBOFr/9dqIf5/0WHWZzz6ZxxGpFiX8lmgz0nV51Y0FgsA2ARlsWD4N6CHMfE7kqFEnmM+NE6a/UkZg4ASS+jcjEFTq1JSjkbVlxOC/0tjTZ8zgaD13Mk2pJvwEuD0Uf1Prb5ldGi9J25A2KBNc3hQiUvBIXcdFT9+2fV60So4eVe5/IqzAA0brV1cvXXVsNgb7/xxsZ9/gpQ9QWRBlmJRMzP8iS7Nk5Ssy0eff4EuAczA5X8LJxH5NTlOVTTay0nJFkOpOk=
X-Rspamd-Queue-Id: 7A6FC140009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: smoto593x5w5tpffe4axnt76woxwfnry
X-HE-Tag-Orig: 1755882616-508620
X-HE-Tag: 1755882619-148553
X-HE-Meta: U2FsdGVkX18mpwB3bAD0vddDB9Lq2FdJOKLyatARhaIxa74CSfOd+wn+PEMPiwYEbLQR1IyK4KT3Ljit709RectdhPBsA0B0ATKGNakuyl1wbp52trX86YuTAQ9/y5YdytMVyzPTVClhUGvfdgvkkVWAZp/QGnpSNJp3g1iQV7H8WibUckW3RkkTi393fi92pBwdw6e/GmSnhlsnhalIeDNlJ2GsGMJmbUYbo3JePB4/aAtWp1B4gqkE+V1Uge/kej+5ib8aelFb8bJN62HbQ7Rm5GbqQd+pqKucRveJVbO3ntIRPtQjUy8HBvijdTCq4xy1jiP5BpBs0wptCGcBs303gPZHPHudLdsnqZwIzTqH16XGLD2j5EnbhhRdAwTUn0Hjzx5fEhtkXvGltRZZBZOPtIhhQ/GnJTir6y62nBKTHhs0f9KyJC4ltb0y7AOCF3DugGzieAAjDtaHQwiwaT9ImNvNl1NGtjiyW32zPRuI5G3m8g8SNHrFeX5rCXcVMYSAYsh68avcek/DdxCBarrpzes89B/bUKDaWEMrpRVN9K8f3sC9GS7mrVtUTiOOllj/xHgl/hGpE2RTsXXzO7vxLupNVRjW5j9B0fXX/tl+qsWSEiaemsIkJsUGMZlliSkQQ87/bUbyBF1lYmm4emYpahlyH9rV/opaWzjm4u882zsrHm3ldlAKRZXVMkRPJrFy2EAz/o85Di6nbY+iAqCuV7q/ByGXqZbZ0fF3QEqC6XzEeHeYAUEu1rRi5yMDDXgGYC6j09dBF1QsoS8/DxtiT4l/zM+NFybU+UV9MWHLRvyCBdUEYVEpqDzj/fZyuuQ4gpUCYY3/1MkbXXI7DCQbBwNwGTKlizSlHBRJjKUxRWtDRJ05/Ct3Ndg/y5IPAOUncwGyrwtq1b762+sPQUGiQzsBuMqRQVJ+ow3Jr13CcRYG080kS3eoxTnsbrI3GPXWehbOdQuPhtTITnW
 rUsphXld
 iWUz4h0xvbNSWaTHWXNHyyz56wRAtx3ZAkzLFvvhZSXEpvOaXB+tqAGfZVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 17:58:16 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> > Proposal:
> > I am developing on a restricted internal platform where there is a
> > technical requirement to use idle devices as extended memory. =20
>=20
> I don't think this is appropriate for the maintainer summit.  You
> can submit it to the Plumbers MM microconf [1] or LSFMM in May.
>=20
> [1] https://lpc.events/event/19/contributions/1995/
>=20
> Also you should have cc'd linux-mm for this kind of thing, adding
> it now.  Preserving the rest of the proposal for those who are
> interested.

=46rom Ted's original email: https://lore.kernel.org/all/20250805144357.GA762=
104@mit.edu/

  Related to the Maintainer's Summit, the Kernel Summit is organized as a
  track which is run in parallel with the other tracks at the Linux
  Plumbers Conference (LPC), and is open to all registered attendees of
  LPC.  The goal of the Kernel Summit track will be to provide a forum to
  discuss specific technical issues that would be easier to resolve in
  person than over e-mail.  The program committee will also consider
  "information sharing" topics if they are clearly of interest to the wider
  development community (i.e., advanced training in topics that would be
  useful to kernel developers).

  To suggest a topic for the Kernel Summit, please do two things. by
  September 10th, 2025. First, please send e-mail with a subject prefix of
  [TECH TOPIC] to ksummit@lists.linux.dev.  As before, please use a
  separate e-mail for each topic.

So this appears to be appropriate.

-- Steve

