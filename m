Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BDACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC366B0092; Tue, 23 Jun 2026 05:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E8E6B0093; Tue, 23 Jun 2026 05:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2606B0095; Tue, 23 Jun 2026 05:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C85136B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:24:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5275B167004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:22 +0000 (UTC)
X-FDA: 84910641564.07.A032EBD
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8B1A3A0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N/gish/x";
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206660;
	b=NPZyJaeWsT9tDkkMAx/0Gt5kTuktFSFKv6mp0nt4AWHRd+fjfWGl4awgDe7eCWxlgqRxrq
	DnYRsHshanr4Z/nuqT0e9iAWKTOFGJJEUyvcYOdTF1UQouBM8wcvj5SSIjNq48nw+7GQwB
	EXN/wJmAvKHlq6xgAnGVnCWK1hSGEDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SZ7maC10bAKA2Vue+KAWspxqEt2HCnYBjNNvBiW/T3Y=;
	b=0sBwXfXwFNWhZvqTatlm4w/frPRswCK7Ds0LS/7sHDw/7WsF/QCF6mPgRtqznH1FaG2ft7
	QzXPnEp/rQLIp+c98W70IOyfEMFRCE5N7Sqw6rcnxFMIC7DgMuPwEJUrWkODNIROdb3v97
	rHg02VFJrpZwK+V0D5aHM2Bn7Auk74s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N/gish/x";
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-695bba79ae1so1170454a12.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782206659; x=1782811459; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SZ7maC10bAKA2Vue+KAWspxqEt2HCnYBjNNvBiW/T3Y=;
        b=N/gish/xMOVNRnav4pTPmSpbEdKrygBJinMHGWkv9IiDksYKL5MtTtQyPF5S7CMIq5
         hzduCujmT2gJ+b65/bFrZmfa2dY/2WJBEmR9FBX7mBeXgeq4NzbLZFaltP7DD83v4deS
         BfzGE23nrgw3N1d/ClnmQxG2r8cDoCbOX345htlglzDDRY6CrEuI8ojAknc4YcMzhREK
         jOawZkCGVDUTYndCtpwEqZ/3lx3mreZVyYOw1fNJD9YzFlqmHcpzU2RemUFMohEzNbZb
         V5Yr/KitIofVTrV6MsXSRYJIhwuV3M0H27U8J/Jlk4yt7JqgsqZ0I2rodqZO+tqeN9VZ
         JyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782206659; x=1782811459;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZ7maC10bAKA2Vue+KAWspxqEt2HCnYBjNNvBiW/T3Y=;
        b=SFrn8Dszs83/FiNs3q55Wv3Z0+RKksn36NAyLMtC9gi+Ot6iovrokH7Uc3fVohgSbl
         DUUmdxQNvELzLAyC+Zq65z9/kv2eoETWNfnAvMdAWyJyExVLZJmtnOAgADXcTacxOx4X
         x/eZd3TRNG5FZ80VW3BAEce20+eI2MyBn7TRscsA2HO5aZ+JeZk4n+o+366nzfnU3s7R
         JZGdQ40kR6OYSHZsmmhrxe4TadZ/JDMh+umUyvu5xLi89/+mvm8PKhreUZc2NdGXd2DD
         lCqU50PfuaFuqCakze8fha9JSWGHJNBy9Eql8vHULHQ5YNwl7OVWNCcn3WidilJUyvmV
         Jn6w==
X-Gm-Message-State: AOJu0YyUxBF9Nl4g4YJcpbSGUdr9BA5o6rFBIHOdAsC+1bC6MgWxw7Bl
	PGagVquKRNOEEWSJydOKryjbq/+6iELIcLbrtKXjBgTVp8WenAaUijMR
X-Gm-Gg: AfdE7ckA7phZnpXegWcFNhWKgWgYshP9/SWVJ+MsA5en+YjMkhs5HmbpBHLWiddIh36
	reVV4f9IEc+IV0ND6JapLoI26IXi+AKxtdrL1xfoXHOard0TJYYtgzCh8gs2sIbVuFYXM3Zffgg
	4xtg+1/KMHmmEs5GWlTCwOyT7h1GDZqSawUJWFnv0mVDXH+DgquJaZx0Df/OyAbEuDu8eXrXI8O
	Bh2+fJdFvHOCiN2WAdT625UCqEWVLGJUNpT8/RWK4kBtNbcQQFrnDA3C8buAeSguylpdmaKtE5n
	aLuB/+TXc62QLnXEkYinjrFgx/tZq860MaGvGY13O3ERApq2bySA7eZVeHjoQeChOak9IOtM6Mt
	8jHiy5dqUBM2DqH18yp43nMQIA5jta4KaIiOTQllRnMjeujBNx2GDiwg2JperNQg1Msui9eZr6d
	8txSSKjZ4aLqhFm3Lfs5hwPw==
X-Received: by 2002:a17:907:c719:b0:c10:bfaf:6f73 with SMTP id a640c23a62f3a-c10bfaf941dmr64850966b.22.1782206658963;
        Tue, 23 Jun 2026 02:24:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c610e12f6sm499937066b.47.2026.06.23.02.24.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 02:24:18 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	yuan1.liu@intel.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch 1/3] mm/mm_init: adjust overlapped zone for mirror memory too
Date: Tue, 23 Jun 2026 09:23:49 +0000
Message-Id: <20260623092351.13031-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20260623092351.13031-1-richard.weiyang@gmail.com>
References: <20260623092351.13031-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B1A3A0003
X-Stat-Signature: iio3bgsnjo6tkwiucr3unp4kaas51sph
X-HE-Tag: 1782206660-994690
X-HE-Meta: U2FsdGVkX1/M2GdsTga00oiN4AS4cRkozyRorWvDTTUep8xTeRypsY84YcSoGp1snXxGKsKCyhn1gmbO96Tga649zB2pkPwdjZqJSsoEC3d9UKHg3kaOCTTbRdIPkpoyRT+vO3nB7Fi98k/O+x8wWo4g4/9moTOiBcVzLAMq9e6tUrzTrg6HJrut+D7gOE+FQyWP2beXJupuGKvZhN4IYYV69ZAgcrvfnw/HOMK388Q03pH6Q+GlDriWDbVYKdQN0AMoSODZylzeJX4VUzQRXMJFM47MvvsQUW93MYeHaAQzFrLl2MtNW9hnX7XBDd9U25LQn7zHvi4ajglwKK+JjOEE8UkVPW1TrYRlEjmaVBYAt6S4UcsekzLBjKog9nluMQRUlMyMFLaievbtQta8995sJsz2NG2SL6yZPHAJiTCqpr0LbiATgYb4OunAH++wpjuW0bH46EpsjAw3uudBg91FVvFF36tAm80p86DyIl4loEJIlk4DJ1+StDAYBUYf/RbugAzLw/aZwtySyFY7a6V5b/N2TZq+K/JrZaAKX33oBB34HnT3QDjgrl1BcdL2KF6mQVG9KUn1g6OXAqjFZ5dGPCcIU+Zg8blRz+XYgFVPoBPrdEzwyxcV3lActlLtiTwSGWXSN13SXJ/6cpNFZN7YMCjfevM4f5B10K+8dXwDAfGwFBXTZOnnoOni8fk5ciSNrWOv7oIIIdtHWgFMEzHXFFwBuktXM16RDuAcgnmtHmyAnZmMBpEvu1OlHPF2uw9tEsb5+7D1OrziZ8cx8oIPP8tv7dYou3IRaMxgJmbDzOqsEYwFGxGSJg1BVa2Vo4d7zGnuqvG5hT5pYISGxTaR4GtarJgBdL1Spn+fV5i2GzPau7vfQAm96LiEzG3QalX3+jNVOWjyxwhbQd7CQ9XPmu1iYi4GCHTbcM6HN572Yyidpn4lIDuZRVj1dJ7MH4NhE7J2WhWFHI6h6uI
 7+MS52+j
 m9JTa+N8Lq+ztYRo53WFBjrvWlJo8Pe9BOpTnHPFr6RUATOUK0KSPw3ajMdVAsLmAyh1r8iagSO+M95sxfQKTbVQpUGYJWFGSF/LpXmbVs6LEfEwZNBP0lvbZ1907fFFTxOidnceou3beJtZEcxSpiquo26ZztwuaCtfnhAmAqXLqBgOLVYXsgWRlY8kESVAuzO75eSHVAsD5ywuhF5HEHlccDUHim0TaLsKccKEF/eeMMMOxDnGfdTdMNOIiTtGK+Aw1e491wmjMfbR8ofs48J0bIuMMBuaDLFlqftVf2MjPUWkjh0AJyNnxsXyfMvKzSrkKsSxI2THx4k3dIi9oBe7UJfzG8xA9S8loNxP296cmlU2ab0lp+VrhW20PBOz9db9dY9IRwFaaikK6ZBJes56+oAqYUG77J0Hkq9Bb7dSsWlicWtpNdRj6+TdxWRIKRSJqtosPR5Jz2TlKvc5WpQgUuBT9kHl/n2VjzwtkP33tO/ZxAnGEPDDtR2y8shX16XbNmWgGVw3JxafBb6Bv1XZKJn5SrDZp1Zxb3RF4BIcJ3X9WasS/pAwkTaQrQaKF2i+pYRKiCNtDe/BS36rvfjFc7R5XFcvU0qMA3XXWIAGIC9rY9ZPafxzcNhASUaNNa/Fi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mirrored_kernelcore is set, adjust_zone_range_for_zone_movable() would
skip the adjustment if ZONE_MOVABLE starts within one zone.

This makes the zone, usually ZONE_NORMAL, ends the same as ZONE_MOVABLE.

For example, we have a system with following memory layout:

  memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x2
  memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x2
  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x2
  memory[0x3]     [0x0000000140000000-0x00000001bfffffff], 0x0000000080000000 bytes on node 0 flags: 0x0

With kernelcore=mirror set, current kernel set zone with below range:

  Normal  [100000, 1c0000]
  Movable [140000, 1c0000]

This changes the expected behavior of defer_init(), because it only expect to
defer_init() memory in last zone. As Zone Normal and Movable stops at the same
end_pfn, defer_init() would set first_deferred_pfn in Zone Normal. And what is
worse, pages belongs to Zone Normal would be counted as Zone Movable.

  Node 0, zone   Normal
          spanned  786432
          present  262144
          managed  34390
  Node 0, zone  Movable
          spanned  524288
          present  524288
          managed  715855    <- manage more pages than present

While when we look at the memory layout, we can see Zone Normal and Movable
could be not overlapped if we adjust Zone Normal just other movable zone case.
And we don't expect they would interleave.

After doing so, we have non-overlap Zones:

  Normal  [100000, 140000]
  Movable [140000, 1c0000]

And the page locality looks correct:

  Node 0, zone   Normal
          spanned  262144
          present  262144
          managed  233614
  Node 0, zone  Movable
          spanned  524288
          present  524288
          managed  524242

Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7c4af27a6557..b8ff4aff19c0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1170,8 +1170,7 @@ static void __init adjust_zone_range_for_zone_movable(int nid,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
 		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (!mirrored_kernelcore &&
-			*zone_start_pfn < zone_movable_pfn[nid] &&
+		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
 			*zone_end_pfn > zone_movable_pfn[nid]) {
 			*zone_end_pfn = zone_movable_pfn[nid];
 
-- 
2.34.1


