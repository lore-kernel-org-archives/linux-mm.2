Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6A3CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C9A6B0098; Sat, 10 Oct 2026 04:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCFB6B0099; Sat, 10 Oct 2026 04:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC136B009B; Sat, 10 Oct 2026 04:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1E66B0098
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:14:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF08B40594
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:14:39 +0000 (UTC)
X-FDA: 85306005078.07.7EBBAB8
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1CAD1C0006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:14:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qoGIrpZc;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791620078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxKJtojMjQnrMJv4R+phcmF7V+2BSeG8Jcmd4MLnyE4=;
	b=e72eXOSLPNtdu6zm1l0mWJb7z5cwYjOpZw7pDkzc2RV0Bs90Uxk17b2pWrkLP+hCyD8Iv8
	F42dE1YJGmcYJGEGhsHLnNR0d66+A6mbGBvHDbYsCkImeRylKtoOt4AbXv5BpE4PaMhB8j
	3dNEOUk1KKhLif/XQm79Xp/8koPyXhI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qoGIrpZc;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791620078;
	b=cuGiPelXMOBu7L+a8jsip4c3bq2b686GQ+W6FrM9D4D0Qd2UAVlzPzMcGXERdThxI03+Zu
	u2bKGZBSNCTgwEHj8MvEuiK0WTUtnkcdFjOk4WHWNw0kKw4h1Bl7nk1In/WSKfvVynh/Jh
	dpgqz0ZONJQKsnvXKUgBmmaMK7+idPQ=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e836252e1dso3450105ad.3
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791620077; x=1792224877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HxKJtojMjQnrMJv4R+phcmF7V+2BSeG8Jcmd4MLnyE4=;
        b=qoGIrpZcapzTW3oEnuzQxziXqfXIPibii5iRSSpCz1BJPpXvUnPdnKJTzFLo05MwsL
         jjOBQ3OD4IgebMLl7CGUaPzjdZ4dSs/d8kP27DG3Ltt33zuBKnBa6jjHjOdl9elmaAhs
         8YZmNLkyQJmyYPkfs1SKFC1InmxcNVRCOuwJB7/MfB6H9ZrRclqJLSoFktrlN/h5V06w
         +kMSgEOlrmjyzM4CG3p8FDGGs8VK/8GTKLlRwlRYdynmqRta3tgiuydLSPv+VxB0cu/m
         T35e2TCoXlZKtDzDiNLQy6VDNVZLzzgYrqaxxTROxHCImePP5CRGu3CCcsJ+sTOg7bBZ
         c1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791620077; x=1792224877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HxKJtojMjQnrMJv4R+phcmF7V+2BSeG8Jcmd4MLnyE4=;
        b=aAPHJCy+6vPLLeOXaloDEKcDmXdU+mpojjlsRYKYarfBJvR76SwMGdei5XK6Z6N2Ip
         i2pWfTcTYu03h5EVDZKURzj+a5UfEWKqI0WQGHnTpjuU2pKBYtlXz7Q1FLOaV/fK7mnB
         avJY0gpIFgD5ZdKq3HfZLe4sa4Cr7jb9IO4MFW/bT9NzfKLoUtoTHT71u/S6zCIKMV/c
         m50F1x4lD8jVI38wQJzW1OdbpNDvxlOIdmv5N9IMtZEWJj2awAObDc3wsTqqUjCZ48MR
         r25M3qoaXGHdzik5TmCRHqcYU9M4//jHkljZH4PYj6tlVKtDSQ5TxXMNgb1w+zV1BDcr
         z57A==
X-Forwarded-Encrypted: i=1; AKwUvBx+/34210aJzQlUZVXcf9ykvzoaakATl7SJZPeDAS+YTIeJ6JKZRIvY2ResKPRSdy3pXAIOeHSTbw==@kvack.org
X-Gm-Message-State: AFq9FYIZaT+nSaP2cTe1Gf6B1N4wNbNW5kM6FscBeArtPX3Lz8mIziK1
	A5loG5VvrmkK8tAZP8wBlPDqN6Nx2RMsq/taE4Hm5Ovyr+QrcMgSAcGZ
X-Gm-Gg: AYBFou2UnffktqKftig9uRpD2CaGDBN05tO5Yd4icTlueK2aSKSR67CDJjI25b7gkps
	GvmmLLSZoMKGCqw3tM/6824mkH+fko3u+bo82+MuurcLdTb3bb+FIhqrPA32tCgLEC2awMno8Vo
	xlYRatvuWQLlppIZ7avaW6r+EDgcxxz0ROFWnAA1XOc1FNpUvM/YbjdsTsmBOJyghFF3rPR3GV7
	tdVoJM9ueuEYJ8jTFw/N9vNhcxLOmWLSaFVmf8k5kDwsaCd66a9b4XQblksQ3kYe4fV0dZDwhTm
	8PTrcffFPvlS0CULkrW80zZvoFVoGqVQDyApska1j0i41PdgCDW8FGuABHzAjPYCBt1mo3wEPrF
	y4cRQPlitDsHArdhqAts3SHJhdB3iig0StRYpzh3gU9QBt5LoDBEz+YJo+Y5ZGOGif2gsDjFZmf
	Ns+faIuKCepuF+Dm3d342MopONXrsV32Wej46t1rW25qyhfGhBJ9kxCDI0UNmz9Bz7z58Iv4Zoo
	xg=
X-Received: by 2002:a17:902:e54f:b0:2d9:216a:cdd3 with SMTP id d9443c01a7336-2e842aa7c60mr35565055ad.18.1791620076710;
        Sat, 10 Oct 2026 01:14:36 -0700 (PDT)
Received: from celestia ([2402:1980:896d:5b16:bd84:ae14:d4db:7870])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e841a0401esm21214395ad.4.2026.10.10.01.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 01:14:36 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Sat, 10 Oct 2026 16:14:07 +0800
Message-ID: <20261010081453.28212-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140041.11741-1-sj@kernel.org>
References: <20261009140041.11741-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1CAD1C0006
X-Stat-Signature: 9gtz375g1pawo4pc997yjz5adusn4mrg
X-HE-Tag: 1791620077-728633
X-HE-Meta: U2FsdGVkX1/XUoWbbn9YIP89n4oAdJeFWAQRf3NWOZe/8HBW+xNofJdSZhjWJCHDFrBwRDaJd6dtODxwA7Hj9m0WI9WZP7eiB3wHo3AXPmDsTUWWEHrn2Mpt9SYfxqc6c3zaQD/ejb7PpvQSkVy1g/zWMFF6ZSOstoArzPQqiAOiNN4xxdcIp2PjusFf3IHrx0S3MkKCiKELTMCdiuilVXQCp7tUMwU+WtMfkRbHvq8h7WvjL3DQge2jFlBcaoOifKd5mR4JhUGGzkEiCJJ/al/yTzwqWmxAOMX5xbsCq6jSHU/eQTKSZ1SSGAOWx1Uinqp9P7UJGsFJ3eEWhN6UWoEXUmlmFidzw/R26wI+Ya/m3FSouHp6QNRwRJF4SX2Zw+yBhrjLB/IkJDsA+95gK/9HUjhKh2V2YpcUBXB4P80C5w7Pwnyk+FNdvJgtHNevrCNZsJX2WyAMIvMNQyRaRk3WOoQBGXYN/3Ja18Mdp9cMFvQKBjU6UJ8tMGWFnLu+mvKl8+5wzBsJSat31U6uQB980bbG/XBBn/0Hcx3ehyTc9LsbNBv3sMZKWGNHkWHBFUKM3fu5F5086CJH3PpVDdZznoqF5n5TGy1ixhVtX9i6xqGAQ5/bJHt8irVjVe3op3SgpDyVWsTD6VZbJJLsiauG/KbEDEihb3DRBgOeIGmmQuSKUtXxQfrEhq6tbcJgb9SdZGFfGG55YxkpGP4uDWncgkkFdTcx7iAvwsxlRlcNTA8TrM8tPWMUDJ6qK2BUUhMoWUHjZ6THrtjIuXqbc1DqblyeKOOjTcQ6BWaIE2G/3QMO8BnHKNa3fWjsBBt72JczFEaekfTLPYjKxC6JclAHhRhVmB6nPTMziPq8uv0TLeNrLcNjk1nNCXm3se8M5tSxwmIozRgKPmuOB+4CsYcH1nuKkDRzLus3AuEYv15z4hnehicovxcsbt/FobeFePhlAQrz4eaogyn6huW
 hKjltPMV
 hIYqeobUp46NwoPEqTzT0rTsiwOoAUFN6Ut0tk1WN98jEBCARmwAIwkZxq9YK3VH0T9hcKg/58k+D69zezncZ+3mZw/Ne/JWJE8altAErRSBtkIJ9GX9WqLkqNsZLn1ZZN+Bxl7j5M0pYfmGIZYhqmdj0KZBXc+AYE+gRoIVcpwJcqOhiMhZTwcEqzHI39VnI8scDQ4nlXvsZ9+vFBdz1I0t7gPN+hOWHco2rzbk+j5zhex5O3IlUk/sJkpDxRFIwJLrystnbAryZzZC3s3spoQ/7lQDyt5rkCH0a4z0r0dZXQruNcUM9UCVt+c3KjPlcJ0vVgQ33pOptFyj+L4i1tqe2u9xBhgs3irB6jgZVKOcOVTHcoHlofOX0inOgcXUINmV8ojgeY6EPjnzwXnDKtUXn+Tg7gbjPYLGiuZP6fZ/A2fIvhhTDEOZjZ1qAlnhDQTtR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 09 Oct 2026 07:00:41 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Fri,  9 Oct 2026 20:08:33 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> [...]
> > Yes.  My expected behavior is to completely save and restore the DAMON
> > SYSFS configuration, including DAMOS Schemes.  But it cannot done by
> > 'damo args damon'.
> > 
> > In the script I provided, it first apply lru.json and then uses
> > 'damo args damon' to export the current configuration file.
> 
> 'damo args damon' does not export the running DAMON parameters.  Why do you
> expect so?  Has some document confused you?

Thank you for your clarify.

Actually, there is no any document confused me.  'damo args' section in
USAGE.md is good enough.  I think it is just because I made assumption
about what 'damo args damon' would do.

> 
> > I expected
> > that reapplying this exported configuration (via 'damo start --kdamonds')
> > would fully restore the previous DAMON SYSFS setup.
> 
> So this expectation is wrong.
> 
> > 
> > However, the current/unexpected behavior is that it drops the DAMOS
> > Schemes configuration entirely.  In other words, I cannot fully save
> > and restore the DAMON SYSFS configuration using 'damo args damon'.
> 
> So it looks like there is not problem.  Please let me know if I'm missing
> something.

I will reduce these kinds of false positive from the next time.  At
least, I will state what behavior I expect.

[...]

Best regards,
Rui Yan

