Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6E4CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3B46B0005; Tue, 12 May 2026 16:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75466B008A; Tue, 12 May 2026 16:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A6C6B008C; Tue, 12 May 2026 16:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C95D36B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:32:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6280F1205CE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:21 +0000 (UTC)
X-FDA: 84759915282.19.D666441
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id BFB5D100003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o5sn4ElN;
	spf=pass (imf14.hostedemail.com: domain of 3Uo4DagYKCNM4BzNA35DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--fmayle.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Uo4DagYKCNM4BzNA35DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778617939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZFtakTJB5Vs+VUIE17YL6aA+lS3I+iyXqjPjtCVuM/s=;
	b=NnY30Qy26dtnRFNZUScUV5jZ1LrV7bmKzOOJD+k2nu8ixqIr+SJ7E/nxAfiQgaRV6HX1WP
	SAJkg8R+zrtCu7QK5TxkwBJhJ+y8PJXq6Yf8lbCw6p4r9DZ+60nSJn1N0ayXjksWMhgMTp
	YfUazLnmOGEBH+6QFKAOV4qfCCMLds4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778617939; a=rsa-sha256;
	cv=none;
	b=s6HIScmScEwIJnwz+ixuG1qi3q7cw41ZZ3+6yJei0jxYAi0PR9D1J2DP/11t2PSRZU+DCp
	lrfkU8PDFQ3QSyIGQveFefEms8Vw8a7XAMtAxKuD9PrUxhWsUNeAPzD3a+AJXP2sJ2qMgg
	/wRITR9mDNBjEEGR91i2IK3VbxONqD0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o5sn4ElN;
	spf=pass (imf14.hostedemail.com: domain of 3Uo4DagYKCNM4BzNA35DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--fmayle.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Uo4DagYKCNM4BzNA35DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-368ac44b26dso1752013a91.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778617938; x=1779222738; darn=kvack.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZFtakTJB5Vs+VUIE17YL6aA+lS3I+iyXqjPjtCVuM/s=;
        b=o5sn4ElNCf/s9CLplT2aXf1HC/cLKT523b0JugdSA3/NoDUJLumewQLMIxodV2WBjU
         XmuKuf68D8b8f7rCBX0PMDG6Z0TiIcEIMx44qalK0+c8ZKLjyphsPtJR533UtxbK54rL
         vXyvaemjStk759R4esaJdeGEW5viV11Hi1dRrnTIV5B5wRMNVbFSsw+qC0jmc1C+cxJn
         mWGnbVm729tCd6ssyrT0CZQ3Z65uG/cYm/YiZmxzu89264seQAUny/hNQDMSVAC0xPEW
         7rK6AzsL5dmeBbOnX/13ep9GtiCCQAM7RsTm6Bx9m5Y+vfV3A2xmrokMo6kn/NxFSNpR
         GevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778617938; x=1779222738;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFtakTJB5Vs+VUIE17YL6aA+lS3I+iyXqjPjtCVuM/s=;
        b=RcnTMnAlU+R7ZM/C85jaKjdtAA7Qbix2E45iH7TgEBGNwN/M3aVxnvEfqfAt7h//jH
         lF0aT4lYPcD8ev7pa17K5MKdqBbfqJVEhW5VlD3469BTMvZEh9RXULyNqAfl7gsd2ySl
         WhdPbWFuwdUJ0kT+Ky9bCylmfcQ3Cq4avq0Mtl5R5vmbVgmgnsrtCwSzugbFthbftqdB
         wgBn4mGsUUjwB7VgR1wzp1XKOY91cHv3R2cHUw8OzTxJoVU78frtAsjfVvRWGeiBnWkQ
         i3s6Abr3HHzpDReY14+t5FWG/OXYsjgy30Vu6k/8uxEzzYcjG2/Px5vaWBp9DmlP5hyK
         /jrg==
X-Forwarded-Encrypted: i=1; AFNElJ8GWcJCYW7KOMIGQ1p5Y9Afz5PjK+SkNJXDhcSfibomYzLBHOyobrAMcrQW0kf+za+F9qPfa/+m1A==@kvack.org
X-Gm-Message-State: AOJu0YzF9TeJvDKIOqc5f8Q/XdHyF87wjAhnspEdON/Q3SRCCeyH2/lR
	S6P+Ptd5AGijBx3WDhWZInRYI3D9hoEkTkgIYZTe7ycsRL5pJnrmAC162xDh9qpxzVm01e5c36F
	ZIR0ekQ==
X-Received: from pjxx6.prod.google.com ([2002:a17:90b:58c6:b0:366:191:7105])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c02:b0:35d:a38a:a117
 with SMTP id 98e67ed59e1d1-368f3e6ffabmr627464a91.15.1778617938317; Tue, 12
 May 2026 13:32:18 -0700 (PDT)
Date: Tue, 12 May 2026 13:31:34 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512203154.754075-1-fmayle@google.com>
Subject: [PATCH 0/2] mm: document read_pages and simplify usage
From: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, 
	Frederick Mayle <fmayle@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BFB5D100003
X-Stat-Signature: xw7szp4gdfi9nn3wdctngu8k5xsd9ays
X-Rspam-User: 
X-HE-Tag: 1778617939-975011
X-HE-Meta: U2FsdGVkX1+bQC8oilfUuxv7RToBNZGhXpEcM7BxPZvNCm1Y5442UlyuFHq8gXXx3raymujg+ctc5pqpmFbN2DAoHmNZH2T+Vj3Rj3EGtrTw+dBtLuTwxUHyT+ghIhRe04lFlUGHCzRlwmfLxkd8+AnFoqfsqM286g54ApN0f1ydOvB4n4Sfdx49y+TRhMzo1UFx2sefJLy79Kss+JrEH9PdTp07KpvpgQX9Xu/PrG64wHeKSu12EHX6Wf7WehFwYkYSy1TT9vrUExGoOTLvxI1hT5/yQG9+2CsYSnITQpN20WxZK746sMf9N4Thg24YJiJZphy2Qne45iO/iCk88rFF1A4vrwU7x01YKKX9dgcGsgeXz7SkQk399D6/13nTuXGQhUjW821FidAcRuZbW5I6mxorx6xwgexKVYkCVx4SyxZbCjpFnYXoGsLLs5ivGMDy5aY7kwG6/tSawtrZCIlqTswnZ8vRDG8W6ztb8+yMnJwiHyNKbCVV7h2ZJh3d1JkkLT0MutgJr/K3W7/JnMMV0LVClmlT0VV0jnIPBHKEt1EId3Ni+kj0XjAx1lMpPCSe4vEgFFvkh/Vxw/hngqcq/psnqqzG610NprtGe7XElW6P/gSIUGv17E7nrJK84wrRiBcecv45GUeln+iL+a3UsPyiORJI4dKK6DO0f5JWXn1HHP8ohDzIfeKAeilOZx7k3lesRoKn4qkjP/eu4+DCOyED91TIkNSh4EQw7NSgga25I4qjnTJhdVqLJ1veP2B+d26EFa1eHk9BTB9SAaPQm0VIqnOfDBlZwkcG+iKLAJbQ1P2x7WPa5UFpAIO7tQzrHOhVbl/myAO2iti3Zas5g+bV1LGprECAdwxgaBef7HfbVuuHBFouuD69GvXnXt4hrJKV52odypAvLsbTT7ARoeDMMAhSCDh9kniVktffTKFNBaUd4hUeq3wXy7O+inO3ZdvJCxXQWFD4JVU
 +I84vjkw
 E4kbusR4y4Iuqf8Z1IldgBeSrZfY1d1UKD6O5aoJJkDYvbD+AZatpGSjgbYwbrrlq3DxhE97H8gtQ9NVxaLjfYjEasIyiRbL/Qv/aXG8hSGt2M+y3SVEcdcoX206qkj79pOZOVVjY3xN6VHhkZbjOaQ4ZUu5IthUBQG79fO5RTygQMExO878EWVHBVSjBb9kmWEAIRs++InFk6zEuiZ30l55aLwwTLWsnjS0LebuF4UprPZX3T/HW2QOR0vOmY5Lw2YmMMuHb8bgdLAFeQkRipYsvLo+Ai6DBXP0fopk/VKjFbJhKRU+xtxYx//xuaQgrHJlk/dVkdnZYzeGYSNfHSLR0geLcYzeoZN5+RsVsHFhRIYVzsrChUleaoWYDmXZT7PK9S8tmym8IbzWbiB2NhNg49e/k3/dS+kbtC7cuRpEJyAZyFqKZRF9OBExdQzyKGM0kb+8jWZOizxFPjqT6yDF36FD+mPekXjVJuP6TaB9ege3cY/ndIVXd/u4V1/1AHUXdLPnN+TayD7rQ087Bp5NK/TObhZjUvvofMLznryN9qv8FeL6DNzQLmWH2Z9l0ujBWyDMd4Afet5zqB0r11QI/eAZQwYmQqVXIuQayNHWibPiMd70eeJwEKIaYu7I6EsWmubwm5zAmGdHiwnptpoZ8NF0ehmp/f1IHKj6+nS735of5Jqh7QSDiSOSnDttzDAFCiQp7jhfC4ssyzMq3bGnaexAoOygF+ziQ0ohlIcgyiiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kerneldoc for read_pages() to formalize an invariant and then use
it to simplify the callers in page_cache_ra_unbounded().

Frederick Mayle (2):
  mm/readahead: add kerneldoc for read_pages
  mm/readahead: simplify page_cache_ra_unbounded loop counter reset

 mm/readahead.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)


base-commit: 972c53e0ec3abfc6f5fe2cb503640710fb23cf95
-- 
2.54.0.563.g4f69b47b94-goog


