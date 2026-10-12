Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86891CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9B86B0088; Mon, 12 Oct 2026 08:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA2C6B008A; Mon, 12 Oct 2026 08:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798CE6B008C; Mon, 12 Oct 2026 08:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7446B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:33:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC3EFA8C56
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:33:41 +0000 (UTC)
X-FDA: 85313915442.04.F20E258
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E83E980007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:33:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TGbZnyjI;
	spf=pass (imf02.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791808419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+RxCsVLexD5GLxTANS9HeBsTLtflT43ejBiqaED07Y=;
	b=N+NPGoX8qne60Cu9UUlmkaYsJku9uuAfAvhkkWgQs1dM78fiV5tTkxVFrimhPGe/CjOt/W
	uF/EzzuMEej8l/+SXvYx1V+8hWy/6S9NYGO/3RP7q7cflETZK6U+7BKjIacv6gUISKxU3Q
	fu1J2Oi/P7UIWEAeVQZM9ESJ1wCoZZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791808419;
	b=nyxaC+G8gCFi28870xqqsjqTCLT278WN70GV4s2SdGTWaGdstK6+P0o2Pav+Bb3UWQETuL
	puSS0IX9Z/mmFCGYuGha6zmANsZnZQ2a8L+6CPFXUGtob1EqkDraYqcrAnH3M85CS5haPb
	VbuQaA3wqEHXswisu8QFb4EzU65AJLY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TGbZnyjI;
	spf=pass (imf02.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ccc7a6070b4so813188a12.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791808419; x=1792413219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q+RxCsVLexD5GLxTANS9HeBsTLtflT43ejBiqaED07Y=;
        b=TGbZnyjIeS+LbjWShXNW7cf1SPWYzHJAoChDBNWicJ7lzkOqjua9DRuY23t+m1VH0g
         al4rn4sr78HV15VClHjbLdP1w9eVS5JLVRMdtgaMEng8cypSeOgz8ufXZZHVX4QCtmil
         D8ZQ6PQZcKXMLo620CjWXf2y2uF8GdKpXs9FUrBRNkdOdBErKcONFbpWYLO1uauzY2U1
         8lzjE/RzGukbjOCP69U4lYA8cQzB9m/Styr1kiD1tESF8lxVXX1UA9471Y5uy70AeITq
         ioKBCLK5BLhEX69GsYCbGNsThxALCu+iaGBWKZblp0YFaZP6PtPDhvLZAcHKAfnVVxo+
         DX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791808419; x=1792413219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q+RxCsVLexD5GLxTANS9HeBsTLtflT43ejBiqaED07Y=;
        b=JYBP/WSe/Amm3zjaCkH3Wdx92lV0H08ixn0dfIhHHUGYCxq/Vl1aCRgdQCmuRF+brO
         bUFmxkPvs1HH178oO1xtnINis0CkSu1tlvfSxHcO8WJDUk5dfFkxqneqS1T8Xv89ZIH7
         oGXLOzgdOFpFWcRT7TWJ0DJMufTH78ZkooPD7PZkjWiTX678i02CWEpC3NsI8SGveE+a
         EjgbQNarLgWhMnxjUmMnHLqWRsD2WqOnsrQ9QWrw5vaM4N6E2K4BnUsP4OyNxwwjWo04
         gwN1oRdEia/ddUWtI+3JWx7Ob8xCQdOOWCS2fZ6DNoXrupLFUblKZvpDWg5zVjiFOdlr
         3oFA==
X-Forwarded-Encrypted: i=1; AKwUvBz0D7UuVdcMkeTQ2mzw2922ZXvFg2Z8ySK07F/60zqxFuD0sdIhgo3jm4S6QRuFGAUuEYGu3Ru6/Q==@kvack.org
X-Gm-Message-State: AFq9FYKt+qp75se7I4i/YevTmHBkfB9CpFhnUWZ8veLl2wTVK6EDJfUC
	5fVoEnmgrNEmAXbjEsAdPY7c3kjb62TBmhkDLXAPdJ4XpSJZA7pn9mFr
X-Gm-Gg: AYBFou02loOMMJhiqXVfw4p7+PeXNWGFNU+Ld1Loy8CbvaULQlzNvv2NAjiDRMsGsxl
	zpoAsN2EGTJ2h9CHCScuv9ErY2jL2Cg5ngT2Aitl6kVTNQ3gcPyoGhhiHdav+tNMptgQs1L3yiA
	if+A/G+VrTqH+c99OepTSUyTeLpTPGgUXXc7EoVX2inTvOewOYftPGNu2702GxUbgmtBpQhoxIp
	Rfi4sxUsTdRK4OP9u1V22YK08cf62Nztrry7eJUGVRdardyvUFwCMVZAdyFdy7fbTgp4i47Nop+
	tG4Sdr++X20FudUcR/M4Q4pSSDi1hUv6SXl2jW8pLuG14KYjQIML4cm4LiP+cwbtcigmdtl/29G
	PH7yinwWXJfyNvF2Pw7GWVlvPWkf+q5n+N9341AIqkuw5HMf2kHme72+T+CIvfcGlWaexBEEzbG
	a3m8ExHSZUy8qDBWWItGiszvRbjT54fCgXtHM3SVlo791cZXSBqgm2BAN5iAwAWrlaIsoiIulWS
	0Pp0UcamXge01dC
X-Received: by 2002:a17:90b:540e:b0:3a8:1ffc:391b with SMTP id 98e67ed59e1d1-3ab3a9fc979mr6592452a91.43.1791808418593;
        Mon, 12 Oct 2026 05:33:38 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371e2833sm17072745a91.17.2026.10.12.05.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:33:36 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: senozhatsky@chromium.org
Cc: baohua@kernel.org,
	akpm@linux-foundation.org,
	bigeasy@linutronix.de,
	hdanton@sina.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	ryncsn@gmail.com,
	yosry.ahmed@linux.dev,
	surenb@google.com,
	suleiman@google.com,
	zhangdongdong5@xiaomi.com
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
Date: Mon, 12 Oct 2026 20:33:28 +0800
Message-Id: <20261012123328.1138059-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <anMPLgbrf7XMC7Qw@google.com>
References: <anMPLgbrf7XMC7Qw@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E83E980007
X-Stat-Signature: 6w6jezejey5enj1qbsghptdux4wj6fyc
X-HE-Tag: 1791808419-557388
X-HE-Meta: U2FsdGVkX19o3Sxuy4xMmK3JALcXVSp82X2piSpQ6qVK5oga2QQRzUgDrUscX7xFo45Zd2ihDEKC31w2OjRTC0UpvWyOAngKJx8Fw+FJcm6AFQ9kHDBluelKZuOFJrf0OcInskN5pMOKgzBFSx/wRm42Sat/bujv6GjYlUC3Z3Ops4uXllwkuPPC/XWWAkhIlLJnDCMBwmdy+sWlVjH3O7aXy42PbxgUb2ikvwtB2JQQXiBMNEsW+m1UWmwkgTbwtFsZGuOEuDCTPHyWxQj6kpsoSxIitwAQd5LmQjlO3qLOdcQTGAImeWil3rERIlu753ylGdVyvH3llXp9YhMs1KpkkGdisO91aR015atFxnDwAZmVKhJDsi+HTX/P464LzJ9zV2B+/zh8iGacRV3NcXILtAkkAm+Z0CoByEgjoIWXrSElUCQbXlAW/P6Sij1DMXulYZVMl5WkJSgYQCEaudwI8k/YSofR5hYNwrbF4uecghb9mGGWCqp1YIhI55odLFncyrNeph6oKv4fElQ2VI4Z/1Qvohe1ZNb0QH3GP05MOH+R3JYMRE5EYhJA6PFJQAQbLazHiWz3qMDwjfv0QP8KK2Tjyv4BnUJpXXjh9R84HyJvap/h9cddQNsFgV/ZpIOUluEZRG2hoPgVtXSAe+tQyl1Yc7aGKF5so6MGy016Lki7a33z9FJaTTmy2R1GFN5Vybt1DAIoQukqocfWSwM417HmUVrr6Q9+mhaE+r/QiL7e13IwOLLwrpWjpaBRwdIWRUmsw0nTGGFdM9t5ggikJde7boW6t9A/kABxjzCxgaiC2lLsat6q5AFK+3QQ3vlyOhMt+FjKs8ZS7jlG0Oms0ABwq03Zy/ehCLNizwYGYaPS14ZA4z+DHfC9+IY6FPapJkWMuO1x4SbJBXQjBRNBDP5sdeQpHCF1b1wnbyesqa6le158i7t8z2/C0K50F4V3ZJflZyK2Og2hyWe
 lU2kltKC
 Vb7S4R9c44NWeJin9RCsl9FiHhnGHygx1pEaLoUO5bZpO0ooiYfp/RYAisOIcB/b08QAo2JtNqtSQ1oLWj9UIY3jGmOeA2b0Ht1cVvR8hKCTGI9Ph3SBAR82RC4jNaKSRhibP/7uNKEEoXhd1YWq4e4hocjEWONPK90US8NzGqbnFJI4fw0iQIu1lppawfRLJzSgyw7pQN44ZkKr+lT+SwaWerQYtI3yZzJzJ0s/GE3evGtP/Rv/EUe7BUEW/NhsgfSU1CrKwtyGYKk420haWuU/ra8zh7Bu85bhIP/yaG7OMNItAuxfmMtUw9y5hJ48Xis2mjXD9BdjN7iaZ20xtksHPH07WC0+SP7KP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/05 19:25), Sergey Senozhatsky wrote:
> quick and dirty patch.  Just curious if this improves anything on your
> side.

Hi Sergey, Barry,

I ran an A/B of the three approaches on a real Android device
(MemTotal ~7.7GB, zram ~8GB). Same workload for all three: cycle 20
memory-heavy apps through fg/bg to force swap-out/in, 8 rounds (~550s).
The stream mutex is instrumented with a trylock-based counter; the
measurement code is identical across all three builds, so the only
difference is the patch.

                      baseline    preempt-disable   read/write split
  contended count     8,765       150               6,557
  wait_ns total       52.28 s     1.29 s            65.86 s
  wait_ns max         95.6 ms     46.2 ms           130.7 ms
  swap-out volume     ~2.86 GB    ~3.04 GB          ~2.87 GB

For the split build, contention by stream:
  read (decompress): 6,349 (96.8%)
  write (compress):    208 ( 3.2%)

Summary:
- preempt-disable: contention -98% (8765 -> 150), total wait -97.5%
  (52.3s -> 1.29s), worst case halved.
- read/write split: barely helps (-25%), total wait and worst case
  actually got worse.

The split doesn't help because 96.8% of the contention is on the read
stream alone, which is concurrent swap-in decompressions queuing on the
same per-CPU read stream while the holder gets preempted/migrated (big
-> little core), not readers vs writers. Splitting by direction doesn't
address that, and it doubles per-CPU stream memory.

So in our workload the root cause is the holder being preemptible
or migratable, which preempt-disable addresses directly.

Happy to share scripts or re-run any variation.

Thanks,
Bo


