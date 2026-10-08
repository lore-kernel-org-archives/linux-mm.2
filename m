Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C000ECA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C020B6B0092; Thu,  8 Oct 2026 07:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2D76B0093; Thu,  8 Oct 2026 07:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8D06B0095; Thu,  8 Oct 2026 07:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3C36B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:37:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 232721601D3
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:37:13 +0000 (UTC)
X-FDA: 85299257946.20.DC4ADF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 426A4180003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:37:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhJjO88l;
	spf=pass (imf06.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791459431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=vK96+N8Ow9ams/JAiHfjfV2uXZUYzla6HGl9CXeaKaQ=;
	b=CrvVKCxasD+ZxeubtvwAecqFUwTV9DD5O+IkdhoZUA0FSpUVcpw30/NFrl4+Ep08jEOiGS
	RXtaek3zEoOapqXJQnGKfgDoBb1ttLNpayr0ij2f9JbZxF3M8LnwqR4B2Q8JPpw+4ariv2
	mUm6zPpRF4hFLC2+R+x/GDTbyJDCHKw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791459431;
	b=3ZBXM0+7WqPqKdglboSfEO4E2Re7tA5ZTMV99EBu+6mT9XGelgAF8CUIVMyW1yi/SnN6Y9
	BRGQKnXXh875hhEDu8gUQUTgv4N2XAN0314KtMszoDTDjftH8i1aFFqpsLW8GzemZGjoi7
	Ou9924KWtP0nHtAASk2w2XK/j7rAAtg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhJjO88l;
	spf=pass (imf06.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 617DA4394B;
	Thu,  8 Oct 2026 11:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B9A1F000FF;
	Thu,  8 Oct 2026 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459430;
	bh=vK96+N8Ow9ams/JAiHfjfV2uXZUYzla6HGl9CXeaKaQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JhJjO88lIml/f3TVY4LCcW3l3XTZV+FNDfe1hH59ka+hC7yDIwuGFE73Uks269UOZ
	 aiep0cRHS2C/U244JTI5b6ZgHj6weeY7TNnazm5+Gmw1S35WWWIODzpjmDCDt4MB4E
	 FWkVwNC4GDC7Ai8GyjKAC+eaCwUdoy+GyxXi5ZcVOOsx/G/9K64MyzhFzo7dHerBFg
	 0tP8MxzJVnYNwHymoLefwFmjlduIXkVON7dVbUXkFLYtttQQD2HRdvcBgcXkJKomT2
	 zfOpc2JaHgmPA9H/6hHKZm9KY2AnNFSVjAgInBv0GhS1Ib+TTG3uGNI075NKhOl/ev
	 KS2U8adahlpgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A4DC380AA4F;
	Thu,  8 Oct 2026 11:37:10 +0000 (UTC)
Subject: Re: [GIT PULL]  MM hotfixes for 7.3-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
References: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-10-07-21-48
X-PR-Tracked-Commit-Id: 80ce29104123be4d61b5912dae543c70af0fcb75
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b732c98215831db36eff1cbbcd0df2f98b765f4e
Message-Id: <179145942878.227328.1450292004861249270.pr-tracker-bot@kernel.org>
Date: Thu, 08 Oct 2026 11:37:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 426A4180003
X-Stat-Signature: wyeqgokyadtiwcqfnzbd41z6fsb19hrw
X-HE-Tag: 1791459431-213827
X-HE-Meta: U2FsdGVkX1/p7xCz3ouhV+1+p22QZ05Pjhvfxe7cEZcWGKvuAvW0EjJlzcwA22yapKonoauCx/I4FLV0+3OUwDNGpj/+HJRiGmsGjzKHuwfTPqkyA6Cp5zb6ni4TiWgB8nadrvh7lNcyCK8eoNXaEtjy8Km+/DjwKfoFUcYxaGALgZME1ywCPUGV741/6Av2kHn94m07uejCh1AQPhTEM7t7diMNcmMn+INwgrvHNigxDkskKdeyT8MQ3HUN8piwohAS6+9JjKoVKGkd90VIuP/8r4tzADUgDbFFF4riogRMuA67PCm7MkfJvR37sRnAxNJoBaRuhBaixX4664nnky/tNNJ2JL0Mt4LDdDG+CvxWnZsMkzsqjdWE5F5NBEd3JkNzOZLfbri7SLflic1HOzOtfh54CfCM6zMq+Jb4T8/gDDn1icc/5AXXIXjvpQegmhfbC9zWkrU/+wQgUmVX/tJ3zAjoJTj80Kr7MeeCj80AlqpcC0KSxKjGgL0I/8GKGX6zKl99tKO4kmXts+EdVlJNh5GRGMINHy7Kf8Sd4RiOr+MzRB41alNxkLXLf/ztgAFW1/QEgfTezfb6mH+epK9xXOtvLaSo4bTarHobDLXjc8f5A8sSJqoGS8LVGtOwuytpWzX3TjbeWp7zLamDp5tixzBkJIWamJzBlux1LbZQaVzXhjKX1hPaCOfMCdUWYzkAxcwG6gOn0SsFtm78J5YJg0MhbVdrpcsYV3TzAOkQ96xMPtmSNOI0lRiOufm5u57g0zW3KISoLl1OMdn60ZZtj0Ic/mo40DNpwTUM/AwNMcwdkLk6GEQdeL6fMa7KP3HBTuifx067GB0yvcKIJGiGl+QDQ7Br7KHPey7wK1reJTs0uzSkpH4bZoCI4PGysyV/qf8nlS+9cI9FDZpa6RNMohH7MjXQJXDr3LiYEvaXZatlkUNIOaw58HsclSSkh4FVrl+dEj3C5N0y1ty
 NlEx87MQ
 HmZnCNl3k/HvR3EjghHuU/8o3JS2HI9g8NUQiL31eddXek+mGu28RF+zRnn5+fr/UwEkeRu/RvACHDXEpEWEOpNVhv3q0ccZKYuEZTMJH/1QDNKmiOalPlpVvsER3KOQ+AEHFHqvp3tQinftJJWvBBXclmNCIeZQqtcFSdEcQRggtFvZ9jwglO1JMWuupsb3Un+vLkIhaJ5KnKKwe+IWLBE3HwpZm68RfWdQ0jQ/mfvw2Z2ivYaP/C4ogECN+prvAZH/BADZMr98ij0jw6GBsLBXcTqqhSthQbDbHM2rQVuLyL1ExyQpZ6OYR9/gZ2BQa2mA+8Vwl9dY3Dmf1jKODXdg8RF3G+Y5Q1VtHRIsupqreL8pIFMUKUo/oxAyYDIdiA7iV6B+Wf7DXB6vF//Zzj9Y42aeRuZGCAnjgAz3zH8D/Zn7u5AYqZGV7Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 7 Oct 2026 21:52:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-10-07-21-48

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b732c98215831db36eff1cbbcd0df2f98b765f4e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

