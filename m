Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C8CC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B726B07FE; Sun, 16 Aug 2026 05:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC246B07FF; Sun, 16 Aug 2026 05:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1356B0800; Sun, 16 Aug 2026 05:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 911AC6B07FE
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:25:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82BA31204B0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:25:38 +0000 (UTC)
X-FDA: 85106599956.16.59AEC7B
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id B92D540007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:25:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFK0aPzC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kiarash.azarnia@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kiarash.azarnia@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786872336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vm/j07+KL21gvKlwAnAdnCIMV+QoeEuexJ+hzKNEg8=;
	b=yNAV000cflCYhwdhXR5qYucVkYu53l3ub5aRT7JmP0ctAy4bIVyKxL1JYbIbKiIj0MgClP
	EQX45YSmsE2BLt72Xo1t5z+R3DbAPY/+52PkE9KMbyu/obTsMKzXReh5M/RZ+pr4B6BoA4
	NFMwTwQ0pwIEuFe5COVGZVEUp0wHvyk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFK0aPzC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kiarash.azarnia@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kiarash.azarnia@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786872336;
	b=XPggo5Nvwno590t//ytm4agG3BAFUYyaNgbf7laF5Nj6wcKAATIBsc1uzdG41qq5CL1aFy
	uIDwLCA+vxyXdl/AM1T4FUmiCsMEaLpYUmN3tQ3O2FsWcqjXeJm7QmWUXE7askDLQohiU3
	cOqaxwp1koCIJHT+vJFI5EmzJOuYqwY=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so26556915e9.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 02:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786872335; x=1787477135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/vm/j07+KL21gvKlwAnAdnCIMV+QoeEuexJ+hzKNEg8=;
        b=TFK0aPzCfgzT2AhPvyngxGOz3MVSrnmyJUdQpMd4oIIv7GZfKBmWGZ898Hf/xTy+kt
         NEwEm2/y9Cux4BtpVb5V0cTg8qO9e0xM0a9/xyQyjcGY/s7ADHvK8li/U8Ru3QKGoPnD
         Ehs6FKY8XIdit+4EFJhgavrcG8tbI4OIJaTrPfqNHHo8tqBmpSCE/P7TvusuoRwNWlKZ
         2oyCYQDYO6Wi1kOrBtdMM3CHzpKROL02t8XXNaqWRm6ZWrlpRMam2FixxyJ8xYT1A4v0
         dz3SHE4k2FcuJ3/k7GzU3UtqdxWV5nGbTkdpoRxiggkK+RkmiS6B3ABshFTeCkfvh+yJ
         x1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786872335; x=1787477135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/vm/j07+KL21gvKlwAnAdnCIMV+QoeEuexJ+hzKNEg8=;
        b=Jl56Ch+KQqoEma5OEmqc/8Fq1LZ7zDYgiQUCSeeZ8zPdw8Vg1hE/lv8mMz8qiVTAkQ
         XkOQI/sO/Q+zjjyszbAYA9K1GxSkeP3JXWsi6mbECANJoIrIS5+pJdcD7hQhi7TLDYeh
         MRGkRICWe2LiI5oNFVYjC+4T1kUQiDJlt4z12bMu7XIY0rte7cZe1ImVkWVvSpQHobQt
         XhKka1jTOt6AjhGQJ2uege6CaahEE7sFJ9wzONks/uYcJcFwpmfJawmF1mhqgEv4xa8w
         qpxfwfj37oxU3CP/8nx8ugwlE7pgcyUpPAwHTYSnvBEdmbnARqbSFZMZWumC7cGTpbyy
         PEPw==
X-Forwarded-Encrypted: i=1; AHgh+RrRz0EshVmxWfbDMT7gcNyAOFxKPmZoY+TT68lyCgi5rUxr3Qh3uLCNVKJmau9QqP6856aebzB7UQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9mJF9axwLOpvTHOignZt65fNoW1QQBVU2GlOq31/Xo43WIFbS
	iOui8QeLzFl754ssYUiTDtCELRb5mbkb2zMk4I2AzJ0vNy+pTAWYGLNT
X-Gm-Gg: AR+sD12jRz3hAn5Jwmx8DBibAIpeMQZNLuKnSK0PxztVvg9z/dZpuIPOR35enYLo3VP
	eWNbnfNgMQZOmy6ed7ZVSqSpaHsa9EILR3nSmm0HVPm6FFzG96MhfaJ9wpb1C6UdZKn8uYKrbJr
	5korSnbZtIE/jpOJrJEjfYOgatuHMzbCSEs63IWxJVJwyPgkKWcknmkTSr/opOvmYoIxt3KN9XZ
	+Z9pwOx5igrOHVcd/QblB3YmNGPkdRkcCYF0QWJnhE4p0HypTRaAZi1X5CyrxKJiWgmjJJtcpys
	gsrGzSoYKp0uIaj/CXO1x1Zee/wxZUJsJ2J5JQsGfrXCiQitvz0wyTxdDvBTSU5iI6IPKwO6Pg8
	1dUWrEtUFNAhnefGeNQLcToNx0xw1cOQflc97Ft01l7cefQUHsSpOpTQLN+Uskd8QJOjRnEmDym
	9n3MfGqxQPMKIwpVz8KXNhvQ3CgfSHaOsir7vjl20PUmuodz9B1e64A2D5
X-Received: by 2002:a05:600c:8714:b0:499:8704:242c with SMTP id 5b1f17b1804b1-499878ca13bmr307331535e9.0.1786872335384;
        Sun, 16 Aug 2026 02:25:35 -0700 (PDT)
Received: from zen ([37.203.152.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996176b8asm27309575e9.11.2026.08.16.02.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 02:25:35 -0700 (PDT)
From: Kiarash Azarnia <kiarash.azarnia@gmail.com>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: graf@amazon.com,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix signed shift UB in kho_preserved_memory_reserve()
Date: Sun, 16 Aug 2026 12:55:34 +0330
Message-ID: <20260816092534.3333563-1-kiarash.azarnia@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260816090038.3117276-1-kiarash.azarnia@gmail.com>
References: <20260816090038.3117276-1-kiarash.azarnia@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B92D540007
X-Rspamd-Server: rspam07
X-Stat-Signature: pzwekmz7za3zpz16gj397jfgoyba48so
X-HE-Tag: 1786872336-753386
X-HE-Meta: U2FsdGVkX18QpAepOhh1tIZLmxF28ruiL6LgenudoJPTd8ueE5U2438FBuy7pIKSq70cKxAdDh/PKS9vpDOFShd6q+pFKIUIr970fjVPPz52p6kJIo7yHXiopa44EzTyFgdW/bXQ3HJqls23XwoBvGA1FgAXmpg1TEcIz0lRWuaw0xK50nb8OoYXQwylDbSugPkWMvVZ9Hyim/4lqy51VO7QIWaMtIVDuT8Cp5VIHQYJAi/S9mNVOvJjnA8ekjoSewvxtH3vBtsmHVuXuZtOG3Wkxyv2rt33BEQdsbmhIaMhgf8PbMVBbnQiATnSvrU0B8K7SaTACvR0lR2XfYPBKIGVQUsuD1X9wJIddD6EA4gdEqkTMBZm88CuHsJlUq6t01wh1or0apupngtzPgqFj5Cw/FLiUf6xFkIb+n7yVqFvlQMFgnePjdcAyDhPF0ePsmkWcBUf33jkhC0E6f5V+Y1y4Zek4E9/Qg1MoOjU0xhYRnzv5Quc8Bm3pdDEtw4Ej0+fgxUy/se0RyQ15npsW6H9lt2kuZZKXbB4/IBWZ939CU1AsfTkaGVLZyV4kVt3C41Te03rO9O3VulS9qGgR5a5LAsheyOTpSefQH/62rVV+Xmw27dYOcFRDvyvmiqa6Jmycxrdrhjrc0PAheDEov7BVxdqiXXiVZ5fyBjHZ5M1H9K/xXz3uadtaW3BfVo+m8lzzdBaGBhkZnbS0E1A3snJ+08xRtNHProCl7wbjQp86Pu0nRmfvf+kuGsNvElwA/B/lpmk+GZBtMMFf7dH88vGmOOvZZQvA56sVC9nkoPI+Ji46ijGhjF/bYAbj8n08dT7918imjqnDOTxzUfZPlIKendL28R9DeQOFG+1z9PUeUc5pFOMKG/xCaIsFIk8EFMWIb3gqfZ6LMvXkqKggoqNz0dM6Ea8kDDNIl0kXIb3/t4O1oauQ6vsXyv1E9Ytz5VI/JwIU2bQJEXDwcS
 ynJpclX3
 NfX/7ox/MWosAj24p+bhQJUMMauOLm3zn2U1AjAiEhCqbJuknKNqd/22vWRcVlkK0n7xuzYaPeerknb5oAWPtckK6tCkfXGxz9svEfmpsb7V4Vi+2QUPhGuBL/MtB/2UgtA9HUSuKYFUn9i7XZ5znh2fRA/cVxMD4bvOVZqNfvmY4z5dilFzlt+muDS7SkiLKm+sMD9MONJGFLFsnjVWpgnCa+wUl4eVBd+NxdgySnB3UosCeoEeZnVuoBcmmIM7y6rOYDb9BgD5X7avoxXwAAaRN13qUNcMmBdD1FezA78IlEsYp1ooSRbDVBMNeNyvCQR4Nkv2YB67tSIakxVRwDLG6e89n9Ct3rhZtmudxqt0RW0aWqVG8OYPeOkzzFDzeuVRQ9uwilGF1+Y1SycSh4OuZgheD6IoHNMPu4XRa9S58QTHp7dVphzSWIWUH4epcZh6ag762IUh5TX356u1Ums0isg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here is how I reproduced this, in case it is useful for review.

Minimal reproducer (prints what the function computes, both ways):

  #include <stdio.h>
  #define PAGE_SHIFT 12

  int main(void)
  {
          int order;

          for (order = 18; order <= 20; order++) {
                  unsigned long long before = 1 << (order + PAGE_SHIFT);
                  unsigned long long after = (unsigned long long)1 << (order + PAGE_SHIFT);
                  printf("order=%2d before=0x%llx after=0x%llx\n", order, before, after);
          }
          return 0;
  }

prints:

  order=18 before=0x40000000 after=0x40000000
  order=19 before=0xffffffff80000000 after=0x80000000
  order=20 before=0x1 after=0x100000000

Order 19 is a 2 GiB region, reachable from a reserve_mem=2G boot.

It also shows on a real boot: with CONFIG_KEXEC_HANDOVER=y, CONFIG_LIVEUPDATE=y,
CONFIG_UBSAN unset, and

  reserve_mem=2G:2G:khotest kho_scratch=128M,128M,128M kho=on liveupdate=on
  kexec -l -s --reuse-cmdline --append=" luo_stage=2"

stage 2 warned in memblock_add_range and lost ~820 MB (MemTotal 5181908 kB vs
6004928 kB in stage 1); after the fix, no WARN, MemTotal 6004884 kB.

