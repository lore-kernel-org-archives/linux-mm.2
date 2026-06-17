Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2649CCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079116B0005; Wed, 17 Jun 2026 08:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051016B0088; Wed, 17 Jun 2026 08:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFFC6B008C; Wed, 17 Jun 2026 08:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C03926B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:06:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36C64166114
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:06:36 +0000 (UTC)
X-FDA: 84889277592.01.01C2CA0
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F98C1C000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:06:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hclS2CI/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781697994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ck9osqufKTaOTuiUl+Je1iXASF7nv09kdv16+qBIsNc=;
	b=H+HFBv+EQjW0H/zRYlyeucbcismTtJJjxS+1dJtKvhXjCgLpOGaHZ0FONni9cLm6mDq14N
	V4Dcll+jlzCVgFYJfPXoT8/rxz6Qz6eDP/NooifsFqvRoLCWvFpn75iaIpFD+/pP8tXxZq
	PzLj0RyKSpZcIbDLfYu+AMvBVaJHppk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hclS2CI/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781697994;
	b=uiagkRnm2+lmnct3RGRl4w/e2cmfSJ1Cl/OLTfsWGkamUpL/jasadk1W+U6eoqedbHxVXh
	GDE04b4Kf9yHFGy81yUtPBvz9UkEiu57YyOyg36aZKLdYismDaMqBTQgxSSjcUSKJrB9Fj
	YIGwV2szAawbvFA8LL+ad12/JTiG6Nk=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so39656105e9.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781697993; x=1782302793; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ck9osqufKTaOTuiUl+Je1iXASF7nv09kdv16+qBIsNc=;
        b=hclS2CI//qI6dXPh102ixw6R2xepr2tKJ7l1V/sIQwF2rWCR7q175kAoS5a4O/gV7W
         d4fQR+c0/CNJ/WCnRB49xcL7SRhhnkwDeWSnVujhzu6y2LViKy+AILH+9pL/Qzz2+zfD
         OqBWDdLT7LCeCzpcj1xd0WAPk2DQfuNzbmBPfXF6NscvWADlIlkTCifpS7MLan6u2xh6
         O3HOkKpXNYzZ1lxUpzA66yS4tu9mqvzOD1WxMYjdU2/O8iJXRID6TPEPnb6+mxOIb4HQ
         IF0s+E4QKcigCYTIOr9k/x4A2CuexsOraKM3LQqiyn2QuEFaSDyIoe9Jz6PA06Fo/0RY
         0cZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781697993; x=1782302793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ck9osqufKTaOTuiUl+Je1iXASF7nv09kdv16+qBIsNc=;
        b=UmDvwSyIaedrxIPG4b6DDRHZ1V8BmNvn140mCTIB6WGKTEa+xiGa8kfrLsAx0nQe5X
         v1j7VVQ27jANCYWuKLsCmBX2+7EBrGWro9NmV7Lv7wypPdxRTHwLKvp3ma/D/wJbHTjz
         02ewqpUVr8FHfxfYoOrRc1t/iDcI+IpwajPg9bA8AGc9M2mn4Z6O+4hqWX/hQX38PBJ7
         nOYUUnA0HMigeOoPUpyhN9RJu6mb2cSoKFHVIAzfLmZZ2lZR+YpF6+qHyXs6XRUIR4DF
         dN9FMWJYMPbUK8PBpjCLyNBayGONLP9i/TUDF0+dGmYldK/GMRJQgTNlTZrQRKlPRWA4
         PoZw==
X-Gm-Message-State: AOJu0Yzah+GgsJrsspF1yjfFLdYM1WAb3riybkH8Tewk2znGWtott7/r
	OWSzPJbUYcWyFqY1M6U87Xp+FZgynrbGZze7rkaZs1MzNqHlpQWZwa3NRhIG0Gnr
X-Gm-Gg: Acq92OEcBmEnHW72G19mUt6EAJJAxDIWN0UKv3DUdVEXP2AfNuDK8NX5xxJvJxqmj/l
	1D9fd3QrqSbkp+a/Ql7KFCy0TSTbabX1DV22UtdBfd4zBUbmcB7ZwJ+NBLpky4ShDDIwSII6AfZ
	8EwDTA/qW4YwoMSeq+Mr7V0mdZVbTwG70iwCq+Ri1LSS+lvUolKe/ZgGhW2s2I+KTIQ+grXHztx
	oJ0wqm7aEhNYHAdDSwi+g7lW1IW0o9dSbnbnwPEvqFZcXXXKfgj0kKCL8Upkik71G8T3TgaWPK1
	/hvaNUE2JcDoBxuSGq4MH7ZlpPDrvoueuKizv4Cr++onl0EbQaohFCvsfbPgwCJf+0GDc/6Uu0z
	HlDGxMYXc2xjTP+IvI6LDBZjYdWsNUt7Ok1Ii3KmfChylVQPO4avte8EjF567Ep+P+uzcYS7bK1
	/Nm/kTN8+kWPIiYiSXxp7L3kEANnq6iX0qDL5Uzj5NhQ03gxOIBGCTk8QltxeG9coVGFPi/T/Y
X-Received: by 2002:a05:600c:8719:b0:490:bd1d:4732 with SMTP id 5b1f17b1804b1-492333c9350mr59879495e9.23.1781697992676;
        Wed, 17 Jun 2026 05:06:32 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47d1csm158902215e9.4.2026.06.17.05.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:06:32 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: Re: [syzbot] [mm?] KASAN: use-after-free Read in ptdump_pte_entry (2)
Date: Wed, 17 Jun 2026 13:06:29 +0100
Message-ID: <20260617120629.160448-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6a287988.39669fcc.33b062.00a0.GAE@google.com>
References: <6a287988.39669fcc.33b062.00a0.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F98C1C000A
X-Stat-Signature: 8997bkbcswpxdxbwgzfexfephnftnad1
X-HE-Tag: 1781697994-527093
X-HE-Meta: U2FsdGVkX185qJO1jhYoNeCIKyeHymYIn6WW+hm22luGqhXIQZbd4r7rbbGDM2rv8I/27hOD1hArO/aq6LgEoJ1DK/07sRSyHtdbUT/5YkTeVK027CTld/3MhorI1tFby0ClaNCbu9/KN2U+Crbi4FsA75jDfi9P7G/HCX9MxZxmIBb5a4dtFSaKwXdxb33U+4hhvmB6pQO4BhOeUR9zXdDkkAJxIl4Fn/t75kt2e8ovxo9nVTHH/EwZ1ITHj5nYgg4pWvQz2sbqBp8hE+MTpdtlZtm1BKhxspKfWcF2dwCKmqrkOV6BzP9SprWuHaOBt7h7dSjI/puL/R8dnkvq7axCaqfJ8Eoo8Ti/kd1XkmIyavWKQqGiskFqqS6zV0wZXtlDveWlqHiRxIayl3wP/xqODxrU2ZsbnYA/NXR3Z+CwpObBcCXXR+swCJkMiK1vGzEIxWRAL4aaIlrHY5rImJUa2tiTrCBoqZuUhUoyDi05rZ4kG4tKk/IYN8Mq6LHhiYxzteR1qdV9284TNK7QQnT6z8KbRKQ4gWvADtylOyaniZw+XsgbVXA7Ud+LZCcACZkQtA/2s+Q6ESU03j2PIysvMmJ8R7Q1SpKgFp95yH+yTMBpe1jAJ+cJn6l8PlbuSBFkQRoDLFAZG/xl3519iZjSQp5E38480i+xKDxF3aHvZCdQaM98Xx2pxupEJ5coLtPiSEkVVVj1ZWl2s6meWxK8h6U3dHUAj/oPa7eUQ2CCy+RuqoZ1m2P/2VTq0s7pvywx+GxKDGD+Zcf5wXJAjH3TKdLkkqGgc0ubeMSukWtcb/o+ev3tcEZJTr8t68L8h/ZVq0x8GwAXuziwbVyAQQQJ2zjzmR8GxVddU9gk17xCfATRWtxMhcACqO9a76gMMsYK7FT0VxOCcC64ijTIQCSfm1aIGek0W7y6L5LhXOpWP5cfDQdOx30yx7RJo5FWNMrKXSDMbsKDttFEFrN
 0n4dkLnB
 GafCxZZZ6RFmu8VvNZeFXbqz68Wsuf7x65F4vWFi0sf5QiEtxsT08d+HdUeA1BE+rhyHWQ0Aw7RbUkL78DdpL8qa7e2H8smiO+KSo8zv3D0cHhRalX7WD2I5Fd5FYRD9Al/IN/4jtwKFyQVDSa4EEfNAJWd37YY1m4PDEYofDvIPXt2WflsGdlsNpQkqG7UvZbsxXPkdQZuDpKHYr1xT4isExANlMByz/kDN3sSaKyAMmTydKFcGLgg9qYXngH6QiKmWSXblYIQF214wGM5mWtWyc0AzUITHA8n6cm/58rSXZhdbviVe13NMjsO3JvBdS4yB9j1UwOuj41V6tv1cyJhGLB3eoM94AdIKzXzceKiYMKFX1Vw/pCz7JIFsMniWtEnc0NN8HpupDjhGx05p73/euwFFLLqbntpG4AuJXmFUgk7GU8bGmEpht0AJLXpLLwWiGj55zURVx4ShE+AurxQ4Tg2065O6+seAKyENYAVjF7B18vtNYAHQVDzyfDUzKOnKl67Aa3xXh7p/7gIGyd64XY2sx60t4C1bHVkh065A9a9tTeJn5kninnFvlQchKqPYDJ3IUvxVKnA5NS8UdRGJj2JG+yYIfDa/npGUdFsq/WYdfpA/w5O0F7idcOp6jpYUqC7CgdgNQRf0H4AVEgkL1Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptdump walks kernel page tables it does not own. While the walk runs, vmalloc
can promote a range to a huge PMD (vmap_try_huge_pmd), which collapses the
existing PTE table and frees it via pmd_free_pte_page() with no init_mm mmap
lock on x86/riscv/powerpc. So ptdump dereferences a just-freed PTE page, hence
the UAF in ptdump_pte_entry().

The race is pre-existing; 5ba2f0a15564 only widened the window by deferring
the free.

Fix posted (v5): defer the kernel page table free by an RCU grace period and
walk ptdump under rcu_read_lock().
https://lore.kernel.org/linux-mm/20260617115342.156775-1-devnexen@gmail.com/

