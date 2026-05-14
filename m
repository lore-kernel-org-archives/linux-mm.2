Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0562FCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB246B0005; Thu, 14 May 2026 17:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BE66B0088; Thu, 14 May 2026 17:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52C56B008A; Thu, 14 May 2026 17:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C47866B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:50:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 324C01C0276
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:50:20 +0000 (UTC)
X-FDA: 84767369400.09.32B3B2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5534180006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:50:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c21uPsub;
	spf=pass (imf06.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JS9m7cOqrcpqYJ65WwJcAfXTNG91Q7jRPCtVdUyb1M=;
	b=ezUNDCiJ0m7WlNVj2ShxGneCw8vFyHDSBH6rZtWZ6nbyPVcVF9Y6fGnIwN3u82d097sFZR
	mD7D21ccawpBPyZulx0TWRjFQt3G3EaDNo9Jxj+Myv9D2gaR6YbUG1jlJj9/kZFE0/RVQp
	6p+71dneJvnCtJCkwC+H7DzGWNAIPRo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c21uPsub;
	spf=pass (imf06.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795418; a=rsa-sha256;
	cv=none;
	b=6TVpynec5BY2b1BqTMALQE+TjUg4MreJH6SChQR7AXmSecuc0ExArxHDNpN+65jiy18Pia
	r2TPa2OyG03Qc2AQRWS7UnBCzNaswlZq90CIe1wimsYvx7YNX1qr4Bkr2HMskZu8Khz6jF
	Awte0KA7HP5vrYDJmtBKe4eteNWEWtk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 038B960132;
	Thu, 14 May 2026 21:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F6CC2BCB3;
	Thu, 14 May 2026 21:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778795417;
	bh=L7Ez0iCQC+05BbsOTxEjlWXKRJ4hPTpPWBaZww8I3wY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c21uPsub557efwmh+L/O7rOj/eP5vUrJklcFxPiHcKwpO9+TuFlB1JFR76efGNHkl
	 zzopvWhRp6pCE73nFm75CJzCXTQ7zZ3TftFZ8/Bp83sAPradO7M3D8VAu7DlkdTQKa
	 1MZVTYeyoSl5YcwQSAoPJLh6A1xROz655vUpdsBUMz7sNY3f8+p8wHijv42jmiPUE6
	 nUulHHPtyLXKCvlH/awPftkzsQQMXQ9TDfQS+l/4Tf+KOEdcbCqNys0rzAOOlc1+lz
	 MoMbT99pFNxgR/arxCB9zGdU2Rci9qIkOvVQxUnJ3O2a+J70KMWKR4aE97I5aiV0Cx
	 e7daomm47AixQ==
Date: Thu, 14 May 2026 14:50:16 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agZDmE70VHiyKfXI@google.com>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
 <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
 <afoUt3te1k2TNao-@tiehlicka>
 <afowD31YsGVdVUBP@google.com>
 <agJN2esiIGIhUlMG@google.com>
 <agQeABD0W7wn4pCt@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQeABD0W7wn4pCt@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5534180006
X-Stat-Signature: unpbg9etindz4yrsk5zra51tbr878b6m
X-HE-Tag: 1778795418-579436
X-HE-Meta: U2FsdGVkX1942UAjP+bXNGlOofT0hA2cuHCzcdmSLTCIwJdYQXDkl1Cp5edGvyyhE0slFlmkrxOan+g99PMReJIlKGZCXdnzTjRhh2Vgy85KXjeC4D5Bv9Wh21GiTj9YG1/qoXIXAhHXlyVN3VDnS5UJlNkCUpgMeXYWP8UJ8X8b5FmKtDA2ge5Um9wiqw/I9xC5HMg52eS89g54JgkZycQUua4DWUjKM20nAmwQka5oJuUzjFF9/KPqxvBkc9Ym+3GcaUJct3R6GlUsPoi+QD7DmXC8CA/xWNQnqqjqhMI/83XV8y5oM0Q6x2mKZRsr7AWlIuG/yHxMR5KfneqMaEq6J1FMzdHKAeXh/TCTN8U+kMgTDIccku2GpcUfb3j06y1Cducgpo8avUpn4J8WHAqkztqezWzZKpAyJ69ms2FkGF9/3kdJWhPYahOT7DitsxzTOQvUWn9zspwFag3XjW0V+PfNLz1wKhHocpmVX9FC4Z5shqnV+Ayi8ACm5x4YI+BWyeAi+lYJBNfODFbkXrMb1pf2zzumxFh7MFqoCWQe55vNb0UcS2W7Fjbv2/1IvuQiuSK2YTJGV8Vd2lA9xaZWu9a4PySzw/e9hk9W9hgfqgAFNX+WdxzRWEy1vgR2RnfKLNO8P0zPtMVQUAU+mNhAFMohrKTzRalhFE2ZQxucIM2wCqv62J1/1UEUkR20/zUdY0kCyDYL6kGAK52H6yKOxy8TN2MgQDURBKRlNEbXtawWJ4ykFRKePJ/j6i/Taf9snzepiA1LhMAdRgY5YIO+0fb6ubDEnYlXKH1ivYICDR8I0bBSE2RLdEx8dlbT+OKesvscm+DcfmI9vlFEhSESJOdCWEek8YNhT//Sigj6eTdtZ0+nh6Fk09lAqkIstkSfAVYHFym4edBl5MZpmlR7Zw1Q4rMr4htCYA07grDAH5tg3v627+RBMIJIOfmm+BdEO7fOJ11w+DHiSAU
 eZtQmDMz
 36T0mUJjXIbDmsFZxnZgxv8KHNCY9yq9gxwMlhK3XX68bw6fG/4pK1+GObno36AuH1KY5I14YnHh28zl2TonE3jDUpWM1oWDFpyBKi6PN0cO9QBeJQlUNNxp2jPFILzc9gal9eFtnDv/sZDhxVrJ7qhbpu3AoaopLVC3S70IA91Y4RZ/e0gyYGQv1Gq8jOh9aMtesUuUDKJHlHu9FVgCg3IsaHOAOXzsW8UgHVYuQ9Muz6ysWqNOLd9cQ4bCzHYk7yhzJr0JSxeuDfpXfus7Ws+2XlWj4V6tIY2TIO5OL/pu6ehFmzj0AMhM9DX0uVyLKiin8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 08:45:20AM +0200, Michal Hocko wrote:
> On Mon 11-05-26 14:44:57, Minchan Kim wrote:
> > Posted v3 - https://lore.kernel.org/linux-mm/20260511214226.937793-1-minchan@kernel.org/
> 
> Is there any reason to fragment the discussion into yet another email
> threat? I believe Christian is still catching up after LSFMMBPF last
> week so give him some time to have a look at this proposal before
> sending yet another version please.

My only reason for sending v3 earlier was to demonstrate the exact code,
hoping the concrete implementation would clarify the intent.

I will gladly wait for his feedback before taking any further steps.
Thank you.



