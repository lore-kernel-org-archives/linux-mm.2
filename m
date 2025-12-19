Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA97D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E1D6B0088; Fri, 19 Dec 2025 03:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBCE6B0089; Fri, 19 Dec 2025 03:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBAC36B008A; Fri, 19 Dec 2025 03:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B969A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 649031604C6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:58:16 +0000 (UTC)
X-FDA: 84235618992.02.1A1D487
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id A05CC80009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:58:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DMXwOJhO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766134694; a=rsa-sha256;
	cv=none;
	b=BWudCk5LfAIYyMDBvYK8yFu6XHKbvhDrJ/+7K1MavOEwHOD3WlyYP24FAWjRXNYwfAuWDt
	ieh4f9Ygtz5V70acSwJ2d8MnxayK38UxVEtpBigaHZe2iX5dgMQeurn3tNL8rTt19UqhUP
	vnZ4Mhv76Hv8X3Aq8p9gYvnaSMnl1B0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DMXwOJhO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766134694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BS6pQo1nc+d63tlPqPw7f84pjPfGdl5sB4EEvmyUkd4=;
	b=06NSlZbSwclsTsrqbl4w/3z3QFjB4yIDcX2/akwKJtqJxSF0dWs9TygNj+tjUZ357nYPUs
	EnxYMn8Gxxrwld4b1p/Xezj0KrLv2jcI/4yJfmdWZaoKoja8LjlBgAFckJwE1UjOgGFZZY
	pe6uy0IIoXQzEPTWJleSTgUT0AezW0I=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c71f462d2so1665538a91.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766134693; x=1766739493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BS6pQo1nc+d63tlPqPw7f84pjPfGdl5sB4EEvmyUkd4=;
        b=DMXwOJhOtAWc8U7lS3nxQlcNbI4NrySd2R6pvlWB+fJ1RATMv7dn40SgMMeXqkj3lx
         Y3qvtnG0b/OyUuzUuLI2sIgpm5A2ARkH3Y25pZMVAlO3IpGgHYDXoWgBpEoDFPLAh8Zc
         bcRDA4dbJxiBX33mwGMnqxe4iP8gB2J33wzKqthfo36z0jR6HFjLrW4It1fQtStqc/8H
         kS7hsVHmxpJvWiomaWAdSPZqRilC4i1++pqlO7smeQhpidpZpqMj5aIoEEHteFvlTvRC
         2WwLWDEzZIYmA5LX00GyxsycWiPsRW8wL7jVByFpW/8xhG8BcZhwsfozxkTCuJn93oUh
         fLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766134693; x=1766739493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BS6pQo1nc+d63tlPqPw7f84pjPfGdl5sB4EEvmyUkd4=;
        b=NTdv+lJbRjTKpdI2hFcbZY0qAQFmiLrlFSMShAVQbBXGm2ADm1wt+zETayMkHRl49w
         n+Oa2x7zOHjXm0eanBXw0dGrBvNmjTgo8Mmf1G+8O6noVOICsHIVErxllZIxyd/lc7CH
         Dr/SECDEkLsdbRSIyrSXaNxXKX11o+BZCiiI5y6clBdoWMsfflWu8GEOe1qee+7lSHxC
         cExG6hOyLW56Rxh6feNFL6COkxBArTGpF8JjIyMKuSbFH3smhrmh912w4vmhhFjyaobd
         DfpLa51YIUCkzLKddFzhmRtxso0QFyULR62VGRFdLkSYGi+s2ZlFHY1WB4MyduOLI0ml
         GGoA==
X-Forwarded-Encrypted: i=1; AJvYcCVR4Wpv65SyBUwOL8zCHbBkkoNxYf7dAjyliYD0qoTdsenhZCIWR7dZlzKoXjF5ITk/9nKhIhvseg==@kvack.org
X-Gm-Message-State: AOJu0Yz4c3j+RWc0etgpojZSVtGSWuxCfITy9B5GlABvA6Tl6t2t1uei
	Qs7i+A9pudYvf5LlcquSLUtl3RyITfAM30yTZ8EOB4VAXMANjr6Pt/YT
X-Gm-Gg: AY/fxX7/qscSEO+CQr8ChIlxUMg5rfagyIznDwuHfhL2cpWUPRFgz5JbdU3iXbIZPdi
	mwK7SyJbZQzlXlBBHdUjifO/v7U/WuCoCE/uBJePPrJcmfMxnT7XT+cuzNh2Ds5V7Zf+WLImJYo
	y9zMecIj3muX54OPBZJMmrw1EiE6qIPpiE07YL+oTkq9Lt/j9byzjqiYxNDV7E6LHb0pvMrJ/Yv
	a7sl40rdxJk/BhD5OVL0Ua6zCjK2iss0BErIrg3uaTzTD33JMVL/5lqzxJHa2EB9gSKK7PgIqkb
	ANlAKg+WGdjSmInpYEcRYz0c2PTalv1SF4VN8D55XDAL2of75gVc3t+tyZaOjkLNKndRKfe34OS
	E0/wZw6ynPHlOEwAwhxNsF7GyVR7buiyL1OBK/UG4SAzxY2iiF/BpBj7OLEdU9rdoxq1rNqbkqM
	ri7c8G7A98KJY9TQzVzdBSAUzJM+W+GQ==
X-Google-Smtp-Source: AGHT+IF32G2wWGBiVL5oeF6GawusnMgfMsYbsd6xXnmx006whhvQHqj/Zsa1cET2gHQWWlVoFrxiVg==
X-Received: by 2002:a17:90b:1346:b0:34a:8c77:d386 with SMTP id 98e67ed59e1d1-34e92139a88mr1751290a91.9.1766134693272;
        Fri, 19 Dec 2025 00:58:13 -0800 (PST)
Received: from LilGuy ([2409:40c2:1162:1559:f712:85ce:d14f:d48c])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3c839b7sm16474475ad.37.2025.12.19.00.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 00:58:12 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	linux-mm@kvack.org (open list:SLAB ALLOCATOR),
	linux-kernel@vger.kernel.org (open list),
	linux-rt-devel@lists.linux.dev (open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Subject: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Date: Fri, 19 Dec 2025 14:27:54 +0530
Message-ID: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A05CC80009
X-Stat-Signature: e8kfx7rgeyfn6pqi39apftt7pas87fhq
X-Rspam-User: 
X-HE-Tag: 1766134694-830688
X-HE-Meta: U2FsdGVkX19nIDTCPpU28DMayhLYmPpXDECS7hjFnD9iyhZKVkuiAciA20UzUwlsPj1B1Uc9zlIDPFtxZnNB2eRwFZXYzdF9g8iU0kaKS+BldbkW4ke/mhanOFpIIs8Rctennots2JVxFrRE11K3gXl0OuYbMcN7zAAg7kLe+oq+Gg+xhiX3aeKKfHhjTsAVcjoFnrTI98m369ZXDhojA5UNMb6WWuZR8UKYkCY1AKbSj4LUNPqPOLRIfQ5s5Iodg86zud/LcwGwqXdoKitCgC4Oe59/i0/LyAPG5O3yFx56wI2Rcr3c3mnleAvlF7WXN+pkMrfK7Dj4iLGjHAVxGwG5Hi4ncaKszylz9dDrluc5eK5jXlEMZdwuY9/3a4vagwdcL6/JHDG8HX4s8VsMlCAAun5Lv/8X3FheBNGbP8NLdB+l0CAry+CmTGKYdr2Rtri1nLE1TVtfOdKZIlQLtRSqoiVWeziTor+7KXJtrsAHUn71z6wxxBjR+WyPnCpQkvNFth2TGQMYZ6rZFXSEOMmGp3ZNCs/vLd4SxsPUd2JsfciDBC0dgcFQVWAZbkMKZNNrM5NK3D2LYgGkG6XRPSsw2RC7CAbdyEK/ylYm8DUt+pu9Lz7KokuQX8hJNKxxAJ8hYww9ec13sp/157codNCc/EsA2oMWIGOBs9wJGFCldqHoEIboeuWgW+G3bklNZ6JenK+FDLuCYDB0LOJk5g71fUUUpCUdgFWuYS094ZiDCp8BNgKOS4OkPxhu0VytdQ5/8RG+LowtQbByv8E40dakpv530WNLCCfJvCYCqmz8kZthaadK1lwua/WyJIMK3pS9WoEI/W6V8h56QiCV8XoA/H3LHp4m6Wlic0ecV7uVsJPlRMGSwIYyLR/bwPCHkwhJwKmWokoX8cBBa9W3D7kXy0PvwbBT7vjogjumiUkMCCb+uojnoKW7MqfWfmX3mMn6f+TaCiiB7r5dBdO
 hTU+Yinu
 vv+zlay3pEWDIHv7yDANPS0wLVd+20bZ1PZqA7f+k0AmPmVcHOW3kMvwUxty45bh+3Is8syxUY1JEgJxkW7Sg2Vctbu/rQkeolbDxJAgxtVHHYLu9fhTbxlDkfM18UIdY+8CxEOnLm3vWH0FfbhRrxl15LoGRKurQSPxwXPw7LaYtj44PjtvmVXk5/swIoVhR2gUWGga4wwuW6icH5a6pvzXSbVaGiNv7H30tjULuagTRfeLj0QRd9UgJulnM/8TUzBHGUsq2QJGCTVQAClIH+ntXLszewBhCPpJAJkpJbzYEDStYALPLSLUk7GcQzNfdMqGIAg9jAxcYYKHYvI8ZAnZMvxAhecy+l+b3ytDG/CaV/MPCxYTdYPkeVIV9RsnF8ea2xqzLUFBEU8dju7tMp0EjGQdt9KKzDeDX+iBEqofxXh/K+eQttczLHgLoVg3Ih6+whN4Mh+Nvg7XzAiWBFyDXJYAsMfAbIwwIOoyHqg7GTh1UfvK0KQHs2YAOt66PyktzaQg3v4y07X6IR3mhjzG9vue723IgJ2/lZJdxaS65vViNkiCuM7fhysj0Kef/ZrpaMRv3ZCw5Un3AApSU5Fhp607bYDmDQbzIe4usC+4Nb8FA8KaHkU/Vlx/gCuCWk+cDfECfXmoYjAmk1g43CDjLpqi0z+LZDmxg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
context, but misses the case where preemption is disabled.

When a BPF program runs from a tracepoint with preemption disabled
(preempt_count > 0), kmalloc_nolock() proceeds to call
local_lock_irqsave() which attempts to acquire a sleeping lock,
triggering:

  BUG: sleeping function called from invalid context
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
  preempt_count: 2, expected: 0

Fix this by also checking preempt_count() on PREEMPT_RT, ensuring
kmalloc_nolock() returns NULL early when called from any
non-preemptible context.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
Tested by building with syz config and running the syzbot
reproducer - kernel no longer crashes.

 mm/slub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2acce22590f8..1dd8a25664c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;

-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq() || preempt_count() ))
+		/*
+		 * kmalloc_nolock() in PREEMPT_RT is not supported from
+		 * non-preemptible context because local_lock becomes a
+		 * sleeping lock on RT.
+		 */
 		return NULL;
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))

base-commit: 559e608c46553c107dbba19dae0854af7b219400
--
2.52.0


