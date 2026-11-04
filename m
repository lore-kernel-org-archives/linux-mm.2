Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42AF606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fjeXHbcB;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sPziOhVE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fjeXHbcB;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sPziOhVE
Received: by kanga.kvack.org (Postfix)
	id BF9736B05B3; Wed,  4 Nov 2026 12:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82E36B05B4; Wed,  4 Nov 2026 12:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A246F6B05B5; Wed,  4 Nov 2026 12:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7357B6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:08:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00712407F9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:08:16 +0000 (UTC)
X-FDA: 85398069792.20.12F6D04
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id DCA091C0013
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:08:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fjeXHbcB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sPziOhVE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fjeXHbcB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sPziOhVE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793812095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KerPOCuXiJ/QZToY/uoNDeTIPUL/z8dbK1bs/3iiQhs=;
	b=kweJsZ7FY/wOb9+ap6TTa1yuFWPq+Ob9bGICTvdy/xgkmzPSPSJpWZB4nmkUqcugrxHQtx
	AcBXeg9Z15BJvBgAbk6DpJLNrKSm2Ajt97XPaMjZHJOlz/2JXBJ0dQpidPf1UDLxXScHRs
	otcZO4ON+1Zn6NoYnHglZ03E+4zKUiw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793812095;
	b=EgGuYIdyVeZceT+7HdWkhAKgWh9fvJTkJZzFkX2CaJrDcXNhdF8P8Yv0U6AU4/HANMC2R7
	k11zVi+pKQ84ti+RhIir9t9hNiEOklb6Pjk1lOG1p3MbihirlAew1esfgPMzUKEZ22MBf0
	2i5FABZu+jQm04f4/SiSYBseVlafeOs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fjeXHbcB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sPziOhVE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fjeXHbcB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sPziOhVE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B404E21E87;
	Wed,  4 Nov 2026 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793812093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KerPOCuXiJ/QZToY/uoNDeTIPUL/z8dbK1bs/3iiQhs=;
	b=fjeXHbcBmeGoOsQ66MGtk7GS97PTuZ0SEVrDEHqBxbJJLqTk7k413Q5Un5kc3kzCv9DGv1
	svXJGNH7HfRr8rq2ydZrKOUWAS3UWNAooQXZml6mVQGtgM7NzwVVDEzRJerTeElyCC8OPv
	o3QHY3tzXARmYC9Rw9KUCZgK7BbaYe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793812093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KerPOCuXiJ/QZToY/uoNDeTIPUL/z8dbK1bs/3iiQhs=;
	b=sPziOhVEQebu5+LUfB7+JL50/zHMNQZED0i4bMOiXVcQLwF+IIytgIue9+9NhG+mHS857y
	VJ546hT6PFr1ahBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793812093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KerPOCuXiJ/QZToY/uoNDeTIPUL/z8dbK1bs/3iiQhs=;
	b=fjeXHbcBmeGoOsQ66MGtk7GS97PTuZ0SEVrDEHqBxbJJLqTk7k413Q5Un5kc3kzCv9DGv1
	svXJGNH7HfRr8rq2ydZrKOUWAS3UWNAooQXZml6mVQGtgM7NzwVVDEzRJerTeElyCC8OPv
	o3QHY3tzXARmYC9Rw9KUCZgK7BbaYe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793812093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KerPOCuXiJ/QZToY/uoNDeTIPUL/z8dbK1bs/3iiQhs=;
	b=sPziOhVEQebu5+LUfB7+JL50/zHMNQZED0i4bMOiXVcQLwF+IIytgIue9+9NhG+mHS857y
	VJ546hT6PFr1ahBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80407134A5;
	Wed,  4 Nov 2026 17:08:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wvMBFHxm62pTFgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 04 Nov 2026 17:08:12 +0000
Date: Wed, 4 Nov 2026 17:08:10 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Richard Cochran <richardcochran@gmail.com>, "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
Message-ID: <autkT1eNM7-oSM4F@pedro-suse.tail5790ac.ts.net>
References: <20261104013139.1341582-1-bobby.prani@gmail.com>
 <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
 <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
 <287698ab-76dc-4aee-8e6c-db1f5d18974c@kernel.org>
 <aus4ag1KxpuBNSP1@gremlin>
 <CAJhHMCChBTH3QWBFS1Hp17zj5HepN6KFucvG_5tVdpaB4fjCYg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhHMCChBTH3QWBFS1Hp17zj5HepN6KFucvG_5tVdpaB4fjCYg@mail.gmail.com>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Stat-Signature: 64ekpeefi334z3kjan9ati9izb8d354e
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCA091C0013
X-HE-Tag: 1793812094-959651
X-HE-Meta: U2FsdGVkX1+rvFJqDks4GnejmgSy+l3e1sqSN2B3niH1keQPypVbHU9qJFhrH7rXXkbobb7MeGfR0TwUpn/wBiGvn2+BjwKdpHDzHaTDVLcRTXazlIGCdz/gezc6p8XSxYeNuyqTbt5P6xNLf8hIGn/pbyIqf/56VM8NoFhrRAH+SxM79GzgP1r4Bx7R+gdlyOHEra852GHLBcEXyFlT2NNw0k4XuMlHe65AAtrSjXC2bBK31Uspoey0OVmeFb3JHMiJnopgNyYNo7uC+uo+PCltUI593hja8q6j4QHOye6TJJ6LiW/ANUlQcvjOZC5/tCporFOzwOn0xtuQor1/mos6u9VIsqkpi1WhHACNbYPWzG8IkCdNHAa7sFtW79OLftXVDecjtPDGiX9oInBw3UIKiopao+GoNVmspciShJRij0Mi32fMo7niuUS2Ir99W4lT0I1ImXOFXuvbKe5/VCEb7xYAua7hBvBn3/NHAERql3T6VX7gSdRO9PX/odWSJpEe5UnsP6kL9QlOFIvSORL64CEhTUOLEZBnUKBObhDQQRbUGe5QC2Wr4qWmS583kxxtdbJ2SqF0wft8BWl2ms8uLN5I6CTlZ6TPJVWuV7bkCAL3H4hlzJm/7XbN/3RHxAzAaUilVzj65wM92AXUUAcjBm+tkPVxFVx1UFx1LMjdsD50DPXLUVMwms8za2o08O9nHEko4IxgsAVTrZsKXs+pE3h7YIropqvwsZo6gkoZfR+PUvX/bKYx8rYmgUfDrFcyVcE5KIY13BrHsCVUhGAOklk77BJEU9J1QWQmovmGCZOZrTluwnr8QQuyPGUELv+EEoS+QxLM/q9Nk9z9oYr6RpGHKg0PM+3DdKwMj8y8iyGEAo9H1B7VzgeKLpKokMqYLBg4zLisRAdNKi5WDmBSMQpjpiWqAWHVbwFkF+Ui03ocByvh+eIjWQ4kgkyXesX48AV99pir8iQd44e
 CeTxINCh
 bvfSiXO9W1OMU0/SjRtjjqyzh8+e94ehOGZ0qYbHR8wS157GBMVwqIyyYdBhozYaDB5LzfXk3X3498GG1QkgjHkux2IivLXezYFDV65LYOmUw3gxo5ERiZL9Qd8F3jZE7KW0XEJnIg4TA585Ysl3cVLkrv934gXy/5pvco8D5/dv1ZcoZNbv9lt2691qNAmQq3PZV3zdPGeOZIJc0+AiTWDsoLd4UUAl04nQ7jNf++SQZeJTNu6SV1HNeQ+xwoONDJDk6kQUyrec9ysLWSfSztWawICR3Jupa9q7Fdq96lyQRu3HgLrwyYK/vzm6HlcYKD0w6gS/PqK1/NawP7GbiznR4uDy1mEq7YwjMEmVxfOkF/KZ0acYfTRDa6utblnKbI0BXB/NXl7x8AOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 08:51:20AM -0800, Pranith Kumar wrote:
> Hi Lorenzo,
> 
> On Wed, Nov 4, 2026 at 5:55 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Wed, Nov 04, 2026 at 02:37:39PM +0100, David Hildenbrand (Arm) wrote:
> >
> > I mean 1.54%, theoretically is even less convincing for me :)
> 
> With reducing the strength of one barrier, I think this is a non-trivial gain.

Counting cycles on an arm64 simulator for a microbenchmark is completely
unconvincing.

> >
> > In any case for something touching a sensitive memory barrier operation to have
> > a stronger argument put forward for release ordering being suitable than simply
> > stating it's fine in the commit message and updating a comment.
> >
> 
> Can you please explain what information is missing? I think the commit
> message has all the details of why release is sufficient instead of
> full barrier.
 
rmap is gnarly code and I'm not sure people have an appetite towards weakening
random atomic ordering semantics for a virtual 1.54% cycles gain in some
microbenchmark, without actually explaining why it is safe. __folio_remove_rmap()
has (indirectly) a lot of callers which may subtly expect different semantics.

-- 
Pedro

