Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AB0CD5BB4
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 01:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FEC6B0093; Fri, 22 May 2026 21:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510BA6B0095; Fri, 22 May 2026 21:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF816B0096; Fri, 22 May 2026 21:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 228056B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:59:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0287140AA5
	for <linux-mm@kvack.org>; Sat, 23 May 2026 01:59:08 +0000 (UTC)
X-FDA: 84797026776.20.745F78F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBE26140009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 01:59:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5mcvlCt;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779501547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVBzmOhRiv2foSpwE+k+Mhzsd0rAm6OOVI69ubk7/Kk=;
	b=YFNHGM+4MFIgOQYZ8zHYivNEHKXLukEyvN/V5ZAgFcjwQ05LHvg+cgU+XaOk+YXuCPBVsI
	KtKoMDstFGekQGdudAaBb+owwV0kjLa8YpqLY9hjzhgPJigLHPEWjDT0cmcXxMw/QUGwxe
	ONYiAlp4HFW4V7Vm6fRRhgaych1Nydw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5mcvlCt;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779501547; a=rsa-sha256;
	cv=none;
	b=X5syVrl6bdiaK5VgNungFyOh2wmJWf6WFWme/C+OE/mnYTogDSDtx2ZiBFGtIoH2mCKS0O
	aebknrGq6SFj3AzPMKS4JbKWVAnHSwci1d71+JyKP9skIcswsUSt4gY0D9KlCqaQ+pM481
	rp5tVxfzwfRGA+7bHkEr8k087tyy2a0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB9E243B86;
	Sat, 23 May 2026 01:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1BA1F000E9;
	Sat, 23 May 2026 01:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779501545;
	bh=cVBzmOhRiv2foSpwE+k+Mhzsd0rAm6OOVI69ubk7/Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5mcvlCtLT6pcSEzbM7VOeiYbiWyUs87hX2WxEscOTmgapdz23+WbTET3Je5eDQwC
	 oQYXhKDFES50F01o/EO4A4SuyfQSN8tNS5qTdXfsgm/UHLsMuUb7ocUuCz1rNo37ej
	 y+6H/vEstqnPu2Yaub8GeiRnKu5k09yHbkvVxYyvjRwVykkSawQhwLyYO5ut8mTdlH
	 +Kvi37xKcu4GGZPSDbvUlgg67reUsu3qUnPHddlPE08DosHV4PmHL/o05hcWlaCfSv
	 069Xc3EMhJDClztus+wz4Gpk3xTetqXb53mHgYDfWqsRjbFi4FXkrbcjFRPyz2emMZ
	 ntkBbYDoT9kRw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
Date: Fri, 22 May 2026 18:58:57 -0700
Message-ID: <20260523015858.87146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522020004.86551-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 57ctyg98fjde3joj5dwwrogktbdjyfo1
X-Rspamd-Queue-Id: EBE26140009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779501546-275427
X-HE-Meta: U2FsdGVkX18alirszPrdJV5VaFGua+GYWeTx72zJEf7EJgH/J1vqNvitPp7KDLX7igpavrU2suIQxjXt/oL5bO17FfopqYF2axaV6L9ND5rcb6mW8P3JRV8qh9YpV6qkOqJ3ZiI0pKmDYqQptywtUmrcQTovhTrP36XaY7zWhsSDr8zIsHM/GOF4Qfb5L5Ut23qgy3MN7NiwyipmudJEXqMbBNzPQMQCtPiONI6H4c2BKmsaxOVbR3d4l7Vh6y2/3EFqOOOCY1ehPtmSgiuCGblkdP/sJQePXnmEKwpPz09C26HbwD+Q0CYPV2XPKdcdaQ0JaCDMyzN+bAcx+7tpStlZzraR/MHMxT4IX0r6Wv5zn7AdV5W3U+gzNcgmL+BYBdDRj6yWi95QcFLQX5UyhoTeL9JFYr+jqdwGY+6Bn4/VPAYgpCYdk9Ruckum3XiSfu4sBsbl+iA7WAlWZ2/HiMscThAA/5sSDsktpGGeqVHOI76JN+SOwsGSvkReIwnocwjNoQubvyW6hvFsB3TL00Dzgwwpy0+30E/GsgPeW2SkoN0G/J999wiL8JssdOPVjv6SS9Z/8RTmeonm2NRy+WnwKGA/VZ/gFrNwS74drUrQfET9DnW7SorL5OOfcfO2+vwA3wR25k3NFSPeTScxLYvWPL6AFgtexlTtCYU51RMZI2fVg27vepEsFV65zsknTMcqriLC8SWkOW8GkOs71GO84sFpL0WYEF0UGkhBWCjpL+TgniSiloulXvSZObI5NvgJhg3ig6vXUePr85okCH6sEw+yu9QhNYRkrmVvHuLNKdKz5Uaq1+g4MQSLerlzC7/b98ug3lUTj4YMF2yWbjOa0G/fixy2phDY/WuGzpd6JAPETVN6bmMalW7hMmKWWEKMM72feo5hfjx3PUtv+Fo92Ey02TJujCVVNKbZtt1yZzgxxuXr2XcGVFa1PX99eZYHK6x9NsnsfBz8h7Q
 48u7///S
 GVPbSjvJuV+5EVDabgcvQ4jRSsmTnMNZgoR0JD0WRvSg5ueEKxbUJfhIrNiQOh3ArifurbDGgoCk6cn5QX5zYoLBgaOTSdPv7hAytaoWPaS+kVxWnL2ZUjLWEm66yFB7OQrn5pPeMANrZKkiGZY2kkaK4JUPh/GWeY8zU5pdt2gI0GfZAS6Plg1hPoYGAaPimsz1IowJV2kczr5B8ZENQIHCjhB1WyNL160ocMq7BRFiTnhPeUOhdSaqncFE3KGDXP7OaeN81pfBRsFLYub+1oUQQ9pYHv+dRK9K5e3zXJ60ugaRmUezSB/mSPVFr8tmmW0gxalINIYQybeEQXku7pkFNng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 19:00:03 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 21 May 2026 23:20:20 +0300 Maksym Shcherba <maksym.shcherba@lnu.edu.ua> wrote:
> 
> > The sysfs interface for DAMON quota goals includes a `current_value` file.
> > This file is not updated by the kernel and only serves to receive user
> > input.
> > 
> > Clarify in the documentation that the kernel does not update
> > `current_value`, and that reading it only has meaning when `target_metric`
> > is set to `user_input`.
> > 
> > While at it, fix missing commas in the goal files list.
> 
> Nice!  Thank you for doing these!
> 
> > 
> > Assisted-by: Antigravity:Gemini-3.1-Pro
> > Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

FYI, this patch is applied to damon/next [1] tree.  If this patch is not added
to mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew
Morton) to pick this.  So, no action from your side is needed for now.  If it
seems I also forgot doing that or you cannot wait for my action, please feel
free to directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

