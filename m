Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF4EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0846B00AC; Wed,  1 Jul 2026 02:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098566B00AD; Wed,  1 Jul 2026 02:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17A66B00AF; Wed,  1 Jul 2026 02:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEDDF6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:29:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 447A51C1B11
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:29:06 +0000 (UTC)
X-FDA: 84939230292.27.3AEA513
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9FB1240002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:29:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MI91NpoD;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782887344;
	b=xl0rU3+mbsB0LzXdIW+YIDOzCbtMvdU/HdkS/l58xAld9rnH9xX3KIjJgknLlCY1ECFGYU
	M2TQ4OEY+JF39BFkIqbvyjhauhqITqhHJN0KsCQwIIQJvrUt1O8BRT7I/gpojJqJD21gxy
	/Otlo6/lvhcLEopm+Yf6f7qX/aeCcDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782887344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjEB80gdHXQ8HLvYnrM/mzLumsoz2ua1TVBbhoJleeA=;
	b=F1MwR85d9S313648WpHrSRioeI5EHFaLl3+aycUXz0z3DaFAdqpsXrbOtt/h78FoiocGQ8
	/XslN8Kxrfil2DjePKkVk/798iN0jAIYCUYcTE0IhPiaQoi9Q8IdQnmbep2+nj2X5UJtO6
	3qinxhMsS1Vg3SwgkS5xqGaOnNC7Mt4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MI91NpoD;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 917E84072B;
	Wed,  1 Jul 2026 06:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3261F000E9;
	Wed,  1 Jul 2026 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782887343;
	bh=RjEB80gdHXQ8HLvYnrM/mzLumsoz2ua1TVBbhoJleeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MI91NpoDsHCuZusKsNpQ2MwC6vrPxT/7oauKcGLSWPF9cmT22UMcbiFv6v4O58uPP
	 bRwiELIOxcjn8A26IEoUcEkyNUmmmPXWcUhRzMC3TNQtDZTKlZ5njWZBkJKRNJ+Eg9
	 dXj1fP9GL6yVNwI2fBeH3vrk+TXHL69fe6S85+Y88xRKPuSnrM6rqtvmbDQLh+P9VT
	 JV11n49ahkNm4/hbJ8N5cKwdAbOX9Ub+300a5J+m0QovdYsdEHm/5vcMKNvnZiuA9m
	 B+x25fpJQ794+p8R0pPvE31/p4g3nmJGI9uhRvHYOU8TjuAtyR4a9IGrtdKdMMXqyw
	 vxEqTLY/OdnwQ==
Date: Wed, 1 Jul 2026 09:28:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, selinux@vger.kernel.org
Subject: Re: [PATCH v2] selinux: hooks: use kmalloc() to allocate path buffer
Message-ID: <akSzqdSyx2YuM609@kernel.org>
References: <20260630-security-v2-1-560d33c13ee6@kernel.org>
 <akOZERjhp302jhut@kernel.org>
 <CAHC9VhSekkkDajeFxpjAvaRyUnrfThX9hB1MD3aYBhYMCoRcTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhSekkkDajeFxpjAvaRyUnrfThX9hB1MD3aYBhYMCoRcTQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 66anqwnasqt7p9cj5oq36oiqu94yxmif
X-Rspamd-Queue-Id: 9FB1240002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782887344-920900
X-HE-Meta: U2FsdGVkX19KyaGBa5a9yshN2045pxdQGHPFuD2+KoMBz28NGOgtWQ+1FvC3FOaXNy/JodNC8KzDHVtyXOK7MIQiTySEO5Q/jRRcks0kezpTt2TkEv+HHcz5la/esXFSb5Gkdr3+xyEXg1SS3HILE7S2tVfNuuP/mr/yHN+Bl5rxyDxmKN9MEcss2dwsr2w6ZBn6aZpHMbHP+/wFwRzQdmNjkP//MOzJwEiqo60lZyfUHlcf/yp119GRD9KGOwBGLIdBUL4h9Ru7bfKWZIjM1vifFvROCfFZxMNMN7BeNkLWPXztk/ME9m9XOP8BDNrV5pPoKQqOwmosMXVWqi9mqTfD0VI2H+/baanJd62aaSwonxUzdvPyY5JDaiCjE1wRTeukirLGEaRK1X78N2SEZK/ggpdkGISno99N83ltLgydnkXHe3Rb4HMgZ37YagHJVG27kY4LEkHN3OTQVifhssGdWenKtOPLOKTF7SvLJZQoDnOMKcbq52lwsylcnYY6R/OdEVNbDyA75MXjSW8o1iNN3OTZVWBg5jMeOUZZEzoVbrlkMUgPF8QaQdasYuqvGanQENHT3ffkQlIkO9E6daWf9IBw8Uf9wQjAiAyb12jW8RAH/Mmp3UYNhM5SHwOIiIan58cZtXKHXgRYOn+qnamW7wbcqdeQH72sytMlY2+IiK5rBWXsAQ29lcmsdfwsfPQi8PgY7zGj0BvzchIsKrlw/Z6PZKT8lYDPth/n9T/ZBxojkBqMP0Rq+Ag4BvICYHDiYmzOb5ZDOGz6Oj6dhc3p8DsdyOtven/cqHy7nPlslX8a1d4c3ll42jTumYmTTx/4gHUSqUt4aDL0h90t74x1+Zzh55hVCHGs872wu0ZwfMSpbynNde8s+hNiEpF/H2yit5HvWrEmLwEO7DFI5+TmAOZgClROtxitCpGJssS0LeHo5X7YT1hv7cJ+B1bE/H+pcpGTCnJCHnU3Och
 zch7A7XS
 9clt6DNW+rA5dDZHdjbmW/kX7FE3BWAOjhq20ijBbGgehsdfjbckHowVtQYB425MfzYBc/EMyDKSxnhd5ETi/rQtUSLIAgt67iEIbMmoq51AM8t8HR2JkK8GWFijS/1BvfleDAu8hgNNkN//vYmerWHwDSX0eRgLjC5sp0ODm2VjUwouvjNH08R2Yo/Dtb6ZAh0PZanCAbeln+jDpVRYD6MnY7yUFb1SSz/MGy449Xb+YixYxasBl3uNZPAYPlnzE8Vv6w8WhaKDxuN0t+WE76uBXfICTxrJGIQ4sI150Jpafn57HEN8jsKzgnONwaaK1b4nOWTof1/vzNY6dUcNH3lrfs5++J7A+0w//1wwkfRNnYDHvL7VKMwruLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 09:01:08PM -0400, Paul Moore wrote:
> On Tue, Jun 30, 2026 at 6:23 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Should have been:
> >
> > Subject: [PATCH v4] selinux: hooks: use kmalloc() to allocate path buffer
> 
> No worries, I just merged the v3 patchset, it applied cleanly.

Thanks, Paul! 

-- 
Sincerely yours,
Mike.

