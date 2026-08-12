Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7516C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA47F6B010D; Wed, 12 Aug 2026 06:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CD96B010E; Wed, 12 Aug 2026 06:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B925E6B010F; Wed, 12 Aug 2026 06:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 912FA6B010D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:14:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E539BA23AF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:14:55 +0000 (UTC)
X-FDA: 85092208950.27.2AEB4F0
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B76E40004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:14:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SCHKh+XV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6i2BJcq4+Poqe237T7rKheo3pdYjmKajfreOcZZTS8=;
	b=nNP+nYBbaI3ER9PrKoKMWULje9vIVdMPcqaLAR+5D7b3bKvw+NzU7Y+LPNxTzaQlWHxGZY
	4c+Z4Dzhaamezohu5qhI7K6HIbsMFukLm9Qosq0D8yqUDWTHt6iqLxeWABAJF+zcIyhhmK
	iMaGhxwrbyi+fg1PCVjUvp7kLD8Qw5g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SCHKh+XV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529694;
	b=FAdUY64Kiv/8qhxvbNHHc6DrVqMGGX/iOc4mva8YI7ZhYQwAOJsnkz8m55QkLukigOxdaa
	dWsg9CIMRwoj2zJqjnVlbICpDysD/21kMKEn5qdJi0q+Xd25dIV9HNjWdEIKsajGRkxJG6
	NtAf2wiyq1oJQ3ERjvEgJtfI77tVNSo=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbedb88aa34so580742a12.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786529693; x=1787134493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d6i2BJcq4+Poqe237T7rKheo3pdYjmKajfreOcZZTS8=;
        b=SCHKh+XVL75FznoNyRqkzhpKCtRocmgVPzjwrYhg0rkLa9vSdq4MOj40nvVKbbDB0p
         jd5U/guwFRx8k4XGGce3Cvj5O70fKSJhUfi4fRJ134f6Ul8mUmbBDWH8KFm7dL+3u4b1
         CraGAv7pgSZGjZgGkaxefmS/+VYAFFbDPLcgwaPOOVf7oiLGTp5Gvh2ffm2pSo6yS24x
         zvyFo4oCig8q4hcf5cSPq4xjpfEYj7MUwWyk/sCdvMrTTTjY5D7VzHkXJb0CUdyZe40G
         hnAJhPCdfgFakSW9zdCrE30lPGBRPc0VP7KpYpeI8nz0xezLYd099YTnHViEnUPn6E/L
         JgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786529693; x=1787134493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d6i2BJcq4+Poqe237T7rKheo3pdYjmKajfreOcZZTS8=;
        b=B6YDMRTGs+X9yQrRHMBpDx5dLRMK9qNHjoc9kQ2mXEcP9HZ75E7/14DGE2qRiVppka
         AUxpK7IwDx7bjGFY+worjTJ5HQPpy7LV2hJUK9UYrDgJwqOrsJvdJLnRQIshIrQXEuis
         22nrctUQT0hJqhRsk10NMKtEqLwWdPQzZGIN96mnwqq0cub1pjpfYaSAwa5Y1dMeGxjT
         iaeuYwzLSZ7RSV4wQeTr6KM2ij6ovu3wt6TiyUkfna8oTuheVOCyTq8Vk6eomWdmNK/0
         7+zLmBxT0GB0W08hZ5X1ByUtAftZvw2gyg+qQp1rEpl3RAhAFtJ8efSyhfRuw1ST2bKl
         eGVQ==
X-Forwarded-Encrypted: i=1; AHgh+RoILHt5lu9NcG/AZ2WZsraiPdW63hvfx/X9np0di9IFXMeWvcfoNldg3DIBcObeA5YL3wgT+rmUQg==@kvack.org
X-Gm-Message-State: AOJu0Yzi2bqOTVYS6hv7ZrOxzdAU4pjK5hg5nGu4wzpKp9TA3Cv9Zzcs
	aEq8stYkvLcK/P4Q1O8VnBD0HMBv37MABOquYa/WvrUcRyqyfVbmD7Qg
X-Gm-Gg: AR+sD122GQbAHVWiE9lnlg0uQgZ+jzMVsXFIoR15bwXKSHgk4Y64Vhl6+ws1cOhg3eN
	RAeBvYxSl6Mh5XEIKUcn/eO4vji0f9XG50LDwlgsvCPL1r3O9PauZu+AaeERQHLeEpSw6WTTb0U
	sOs9NCIzBGZP/5zi96pRdKUUGl1sIn2dwEjaFO1Y+jG+M9gY3wd+pE7dE2rPuYqY7KWcNKmmeKB
	LfSCAugqYtJXNN2ZuOPC4Uv3i2vS6cQ2WCGX9qPaGhzWTyr3a+l8VHNVKGAralzGHxPM6U7bDyN
	IEL4HH2dyCIJ+wYT+5Gft5g+EIBOf+8CUwRxBJxrwlpnkVVP8X84ZuS4KM+dQVFOFCVxiXdW1J3
	Gyq8iGrONP3NRX2YXpMZJ2SlXInllBzY7iitpehQY87EHeJit5gLr/ZzLEUf1TCjcjXt4e/3DQK
	4WdE3JVDfLdA5faDdvhqg62K+xB2xI+iQP3fpKUSFrPAkQZFjxlGkb4IuKjC6rohkg4U9rnLl4t
	tJkaMmdmTUx0Vk=
X-Received: by 2002:a05:6a20:6a1e:b0:3cb:b5f6:43d4 with SMTP id adf61e73a8af0-3cc3f734079mr3137808637.23.1786529692949;
        Wed, 12 Aug 2026 03:14:52 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf678ca12sm8940240eec.20.2026.08.12.03.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:14:50 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	liam@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Wed, 12 Aug 2026 18:14:56 +0800
Message-ID: <20260812101456.3845-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812100433.6288-1-aethernet65535@gmail.com>
References: <20260812100433.6288-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rn8e6ytq7cpxw344usgccp5ppt5y9j5h
X-Rspamd-Queue-Id: 2B76E40004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786529694-139232
X-HE-Meta: U2FsdGVkX1+k8zHnQG6mogusLZPf7t3X3gA+YxWaqtAf53bjkubRs4lS4GCWhySEx3O+eXcO4tp7YOers2WOShXa7bpDvuGpfjghv7EYh03B7niq2IL5sZpdjfmsYCmZgPbHDxp935b2q5SkpuXf0J4CJ91fII5iShVL7L1n6PkIrzTTwoBMfKAv3K9OEMQTSv9haxTJwbK/Sz9/vHiffKbhXNUlotyrBqxmOpCiNGINQz5yCiLeWM7afUUkKf3dIshP3r+22G0jWhTAciYs7XJknr3t1VY/Gd+0TPViM+4mxkrWTKJDBy2qnIfdnjRpp82C8JYOhuKJvUBsVNvEiOxncaYqWy4saSbOnGa1iELsQJG6YdRhlv7mw25r6OFq3/+Ta8EBBteqrdKIqPwm9eyASRCJmBsR8/NKEMtvCnCxwQWvr9DMxh5jEWmKxztWcURJU+GUdYny1vVDEe1O3L/yo6OadEXDQw+uUB6pXyun3/LCmDKmi3Cy5wZ9sdtFwPBPuX76omhldrgIErpjHe33cdXOjaRxFzkckIkDNslHPFBE4YLn06t8ESZg4/EV0kkMMKCkWXszMdKGLUVqt8SjwKzM9AqF16UJFnTaEb5NySejfKPPN/zMMPu1qqhfuNfs/DaicC1ezZa7p8VerD9OeTOm/YLzqKApOZzTjmL4hNYn4ZYn7SYwd00/b6nfrGaDKwJV8UZzrIPVLJ3GdpXkO+hDHBFyMscWEFVWamzNOkVy64tJ9BMN7E3nErR+L2QUQHfYUK0PHLU3gZRwZ+Fj2x32iJtDAempDItc9lCQAzhsw3f9e4/E+h0O3sFuKhCDiGkIDiZXI7iqyHMrdUQNpvZ82gqICiH0jiCNhPAHdeLsJ4LG7fqdhNGfPgtk4c30U6Rz26unCpRo4Brnb9IVxaPPg3POVRJFSFU46muydSuQ5iYjP8/tRbTPb7nbinWvuI6aS+JCLzmt++r
 U5bSeYD6
 mvkqN2SE4khNSQG5I7OU3Y9qSArkiOABA5I6VvpHk3cvD3O7k2rO6XteE3j2lLycs7jxpECNJ31FrzrNWkTr04KFGEs4Uv4y5IoK+T6rn3Y+ppFl0b+/9+cM0jqdm0Bq76dziBiIwgEbS8gJIIzrxas9kf422OYRI8KYsrHzchguuIeDYJRJVkyPGo0S/11D3L1G2oA2kIC6/TihfWGka0i9MyLBVSlmm4AuHbiYTgNm00ZdnuhWrDx4eJBSUaLqY0qej7OKu86B+eu+D/2XEJcSAKzbDXlCnXv8Z4+DPgvj3mvGzWoSrJKXiw8SrAehPfYQxGwwhbq92m5jIMhBrrH2fJoWsaUsBbsPvN7sTZ8OwN6iAJAlPeRV/k/QdFKPKMh6F3Xpbd6bSahmrUuUrbmux7PkYshHXnNAvHyiXGzUdYuHUoDg23QvFd1uaqvdRsQIFpWtZkF71twPQlLtfJFtF+EOiODzGHjW77guSx9wrF98CiMw/LFv7Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:18:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Add an explanation of nr_snapshots to avoid misunderstandings.
> 
> Liew Rui Yan (3):
>   docs/mm/damon/design: accurate semantics of nr_snapshots
>   docs/mm/damon/design: difference between watermarks and nr_snapshots
>   docs/mm/damon/design: fix typo of max_nr_snapshots
> 
>  Documentation/mm/damon/design.rst | 7 ++++---
>  include/linux/damon.h             | 5 +++--
>  2 files changed, 7 insertions(+), 5 deletions(-)

This patch series still contain some error, I will resend them later.
Please skip reviewing these patches.  Apologize for the noise.

