Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A09CC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 17:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0736B007B; Sat, 18 Jul 2026 13:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91186B0088; Sat, 18 Jul 2026 13:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6F16B008A; Sat, 18 Jul 2026 13:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 833016B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:22:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD375C044A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 17:21:59 +0000 (UTC)
X-FDA: 85002565158.11.7442F2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5802140007
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 17:21:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGNL6kXo;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784395318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3zF7fQwUKoNE5eqD36Ay9nz96+mxu218W1M+/Y5HIk=;
	b=e0Qn40OglKBCC91YIgQOVdG/7yQg+sGVyd9e+94mvOrVwvlY1jILXCDz5gXQ7QcC7T+O0F
	lnlk8s6pyyUjQOw/xtE56Z/24JeJGYXaLIK5McbNCxEMoRmf+1DlX7kxJtg6Unh7wtuwbp
	ks004Jla/AGofKAozPiOkFr2nrHnOn8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGNL6kXo;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784395318;
	b=U3ftbCQXy4MfqBMKdkr9fHst4sTn7rfn0AV0RTjXnclyZlIxlHBaOqDtI7GlqdFU6UmHcK
	cWhMyBox2YV2tq2v6O4x8slIf2iWczsNkklE/JAoPP+lPaS18tKbn6A8YGS+64l9N6xWij
	IAmgsrJ3dKsStCOkdp7TkRR6w1rN2gw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C546360018;
	Sat, 18 Jul 2026 17:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82401F000E9;
	Sat, 18 Jul 2026 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784395317;
	bh=u3zF7fQwUKoNE5eqD36Ay9nz96+mxu218W1M+/Y5HIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGNL6kXoOYwOpibJRxflDNDon+6aCUMlKuw6KGRZ7VHYzBolgaq9QxuQ/bNnbq0dQ
	 /E/B8tzEMLtRj7NHuubbsnxi0UUrtuJAeFR8KIexOyCNAgkq9c4FvXhMbzF5qD0yvL
	 u+tj1PyaXx0LjslbANxnJa51SMbUwqWdGTaML4QO5gVoVHG5FwOAPW2GMZalSUoMn8
	 bMyhqq6+LoqxDSPNPBNdDlLR1T642dLY5efynodVIfD9oearsBEoGOdsIEE3XhAxWG
	 cOo/dJjpFV3yiAzlQAoTAiny58zIWqvHcclSxaf1zMApW7vvCHQ6bVH2AZdRfnlBA6
	 CmZZ5HJm96KwQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Sat, 18 Jul 2026 10:21:46 -0700
Message-ID: <20260718172147.87900-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718163708.84113-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5802140007
X-Stat-Signature: rijrfkpnq5cunb8xeuxjkgm7t6msrmdu
X-HE-Tag: 1784395318-134646
X-HE-Meta: U2FsdGVkX19ri/ln/VR1MeLATs9Y1MMB7pzlz5aOai25JJonTVUOrWEHlJNxybVD+NEyst3G9QrXWE0Ff3gYYGnoBUaXO/RPZMQRCF/i3IGsjMWtdU3ar0pYPzRbDhxTh86r0iuilqp65pK0d9MbRFq3SzZw3+FsAuSgKlKsP2s75IN+R/6F2EknqXQMMajqVtIrLz8Y3jxBUX1VYUrjtMrZ6VqzPiYAusbqbTeZcnVt293UbN4CpjXurwSvAhJxOmAX6Yv/Q07LpaC35vBg4Idg3+3SsGuilYSkJgTSWEvIZoY4BO0MHD/qOirHc/kD/XbjjQnMS5r3Br6mTA3PS7KhqsVJsARuMiPVWYnlHtRD9fs3zRnIaVSSeEvO2IHOES/pzCh+mR21XSKFHg4Ws1ysWowdAfpKzPpe6nu8ZUASekLSOHc0dAaX4btOMQBpcA8m5OkrztNiXoQkp/WZNo645LdlWtd+u5tyaZ/Nk3c8HdSzGgBugFU5v6BpHK77TmG0ggxUyYyuLHMLAktknVb9FxBdxgosIrsey/DJnT1tUZa7qlZnON6FA6QxSewO7eoDJo6QI8FEGX0rqOAoKqRjtDgRuck4VcRLUE57ZenrdKRrKZp6wrFr4h7rzONSiQL+NoD1bPxCaNnUrpYcudcWolbGAUXf5/F5g8S/x75X2ru0I1zuAge2qV/Jv6BBdzkY6lPwjuJ+k2DlG2uEEL2q62S5mJGlwv/4M6uNjitGpBXkrMIsNP+/vuiDZmoMLWm9Zqdpp/nKJvGCgMtqqUDOQaciSnFqwZsPUONNyynfBdD241+q08Uw+n880eWWn9KG7S3tHWj+cQbIE96vFaimidG0phaxWJWuEl8Lg0TM6fCY1UhN4/nwpvtEq0PZznn+j3pKy8mT5m2tt2N9IIdL1LY9b4b7XvZybHudepdkQwgls4kkIn6AmxAW0Qomx5uP7WpLXWcC/MtqSjo
 7U5UNLsW
 qERqeVzf2y+CDD3YwhTXpfqATCYXV8bNQ7AxO/IeTUeGwPzHVtbhCpAMxG7qKg6B7dbQXKRgLKimHbE0monbkZXRA6uEeQm+IMMN8D7fcMGbr7lf6i2dXmhr/tJop59e7K41fLJommutrF1pWYspU5xf934AVnpxFMWTITdHojJ5zWY7q9tp2rWmbbrbfXaaggVX1kiz31rI9IEIysY4L+37k98EsNCdRTPqf8qr9nHSLO9yujhx22VT1PTmEb89sIHfT6wepyNHemJofcNYsF8H88g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Jul 2026 09:37:06 -0700 SJ Park <sj@kernel.org> wrote:

> damon_apply_min_nr_regions() repeatedly split each region until its size
> becomes small enough to meet the user-defined low limit of the number of
> regions.  The loop assumes the split operation (damon_split_region_at())
> will always succeed and create the new region.  But the operation could
> silently fail for memory allocation failures, for example.  If such
> failure happens and the region was the last region, the linked
> list-based next region fetching returns invalid pointer.  As a result,
> invalid memory dereference and corruption could happen.  Fix by breaking
> the loop in the corner case.

Sashiko found a room to improve in this patch.  I will post a new revision with
the improvement.  Please don't add this to mm-new.


Thanks,
SJ

[...]

