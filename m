Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA205FF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4756B0096; Tue, 28 Apr 2026 04:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C526B0098; Tue, 28 Apr 2026 04:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1E36B0099; Tue, 28 Apr 2026 04:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9DA6B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:52:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0A6E120516
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:46 +0000 (UTC)
X-FDA: 84707349132.27.CBCF366
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id F006080003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aOjg8wgQ;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777366365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSJ/Zlq/U4yHk19v3uYTHivwFzozYncFCgI5ZpuZJfE=;
	b=4mBAXgN5Kie08/swO70HO8w10YIkfGilDv9rWHEcYBDjm1lYDhkC+eH3kIQIKCI7OkZJSc
	Jx9Jzs3ranTPwntlyaskmV1NBFCbhiqNEDX8y4QE5JsLbxFNAbP4KykX/jueii5ItOGanp
	L7seMahmrsXZ2TntEexWeyEoMaIxHSE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aOjg8wgQ;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777366365; a=rsa-sha256;
	cv=none;
	b=Xqjd3IOsyv4KP5exkJUlROOlnZ+1zQCoaEykxzP4ZeVQ9kDtJQqV26J7NvJbltm08Dz8P2
	uW59hM8jKEKvLt2Y2DkxwR5N2IOyrHxVVkXBH6trq2qJevG6kYn647HBQ1rYg9Bm6zCNFi
	McrQhqoX+iv4KX0p8l8AQD/Iq0xBR9A=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35fc0d7c310so7242159a91.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777366364; x=1777971164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSJ/Zlq/U4yHk19v3uYTHivwFzozYncFCgI5ZpuZJfE=;
        b=aOjg8wgQKRM8Wb9XNUsXboCauqg1iWjgSFCEQAP7CJuNEyqY1olr8r6f7Ad/edvEIW
         XxPnnt+v9JRdxXD28jacKgUnS0WlrWSUbUrHu41YJinMNaRE1dk8b2BBawyC28if5v80
         KClCHdp0H6VIuH66cM8qjtzmQDsOQIBPt4FVPwiCp/nEuLGwAQ2U0nnB0MwpAkhNAsSz
         mSEWEttxaocXUhS3SmvvdKs5eiv7OmlMiZ19TTvdNj+rA6eqiSSLfAOuTq1ifocvizX0
         GbTEVUsyP16yrKRpJYWfMFfWnZFE7bjAWrGFjkoZ72JQ8+3EsRz5ZjZCoAsCchnY26+F
         28KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777366364; x=1777971164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MSJ/Zlq/U4yHk19v3uYTHivwFzozYncFCgI5ZpuZJfE=;
        b=E7BNRxmYP1SpVz1BFcPu9GqmHZrJ8js5aYExnNTQdKi4JR1I5c8og+0ZC5t/5+bNZ2
         PH8nwjFzgvxpZpw/Lj5DW+NuWIEQbVuFiOjoebNkIlaiqI9dbqXA6Gn+zn9NCgqzJGBI
         WKFfRJbeyXUNudj16HsgWmirAo0zPec5g1673PMj2jDzUJi5Gsve84DLVZv/SprL+Z0l
         ztCIc1NKFKUj2mdA4RauVnF8qhVF/O8ZPB2cO0jRRQPrbuLPYv4y/jLNAVkpun2Fx0N5
         KoXDDuYF25jA4+u0viQDo3TP2EoIdAH5Xh3xrGnY+spVpn9KOTmDunW939AOMPipyxSB
         bbrQ==
X-Forwarded-Encrypted: i=1; AFNElJ93d/2X/QTBQTSHI1DOaPot4WF0xp8jwhvWx/shqI6VPXM7gGJHh27scQ1cmccWZdu1sPVrAp925Q==@kvack.org
X-Gm-Message-State: AOJu0YythGDzjZL8yuUFLuzamALzdE43Z0Y/gkIbLVNiBX0kcG1fs3Yh
	mqD0nW4oFRI1YH8gGy7d88SCzgXOL5MFCoofspcHJUUs6A3wgiE9GTxm4uqF+zcmC80=
X-Gm-Gg: AeBDieumSv77fEKvMEdmYfDy0/UmQC1a/nUWsaHCQseRfOujn9JtjERB+yCf5b7J3t4
	BxLdIlp07259tfSEpq2EOh4p4qHOibexidfBtpRf9uxMpkeel8b2Q6qYd8V8ZAo66i5b3wvtCnG
	gXYlbHD5V8HQAY0Pz/vF4o5LnlqjcZMz0+zjUZnLUZ2tfYQViHY1MHBR1B7QG44v4I01t+E/xlz
	N4YvF/AyIOvfJwf9WNNo/WbKICbv7kJ1YVymikRkRchcMNPuJ4SNzP+LqyMKEWvLpC3ZcNWvY1l
	fYJz193x4waDmT9bhThJSX5vTd38vhmq/Csb13NLwYePOaqxE29vMoLCM5zUkRo4kmlqt0/og3L
	bXjYub4oRvpXBlAqlx9ixz4QTtFanFXkHja5KhjABQgZsFwfg+z6QK3jJdS1j2E92ajeKmLEd/U
	e4u8J6we4U4eIx1a5LKcjVgew5sOizS3HsJ8go6AG3f/I+ogJNUFjhhl8=
X-Received: by 2002:a17:90a:fc4d:b0:35b:e4f8:7cc5 with SMTP id 98e67ed59e1d1-36492068746mr2311671a91.25.1777366363725;
        Tue, 28 Apr 2026 01:52:43 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364902e7debsm2889080a91.15.2026.04.28.01.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:52:43 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH v2 3/3] drivers/base/memory: fix locking for poison accounting lookup
Date: Tue, 28 Apr 2026 16:52:19 +0800
Message-Id: <20260428085219.1316047-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428085219.1316047-1-songmuchun@bytedance.com>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F006080003
X-Rspam-User: 
X-Stat-Signature: pcd8xeagugndsxzu7dgythe39jcamm9m
X-HE-Tag: 1777366364-387272
X-HE-Meta: U2FsdGVkX19fdAEUsDX0ZtbMzDI4tq1KZdyfu1I7l0SolQ4YrxxtaSjONE0vS4ltSE/5rqsZjd7oQzdsMpgMH7N6yXlfAD07Pny9ZaSm5kra6qKXsizzOj2iujmpMu3y9kU7s1Y47j2eE0VP16q5dFNotlzhWcFaeRj8c9T9UrDhHzy0SlLaNeK7I3ke1dpxeUQKvKmGb2WvsHULaioGm4sCONL+hAs5807AC/HUtIp0Y9k4UvxC7LATM8jAQ16yKtA1nQPRRSbq8dCpKgtk2zRVzPw3E9/B6LnWM6hcrEQYsbkIOS2P43X0BWu1LG2DrM/5gct9Zyi/aItyzRdw94RhIxyWESjSVFxszhq/5y4C6XkQzXrwxOZt55tWSrqg0RdnWHOl91l6q7pBBPvQKxbJMNbxZD+88W+e9FxQgfo3DMCUqKeStvhR8AJRbJ/rkKcFMeAisrDJABfRbj09FNR0S9zVt6cN3eSyG1VUqUd365q6hqRdaETW8MzG6llWUlZsuebDe26io9DoVBad1InrlBRHh79vAJq9J/uv58yxtMMCPN0aC0HAAIltX8XQ8H8MFyb2iO6l784HwHwapqs99g9P3DV37H7FmdoJJg2S4djBYE33xMLC8jsNql0daDKBf149fPdlMF4V2TfyUL+5BTHN/qfMVNwHH8X9jTc29v1GqbVAtIb8b+3wVIAbXkLIwxSOYS7JiJR9EufPUVteU5U/7aSzJigjWm2PXBPptT+Lv8ohAMyBKGB6LgNrMT+/mKPBzgQaWLh7ts83JQrUK1fLzN93jhXnoPL6QsCj+cYMPsJLYUZYKXbiN9S6hztNwPrd29wYe6k7ytKdTpCtbm/K33+sAhm2aBIS+6lZEuCl1AY0X3F/gv5ITaHF1pNx7GAql/R5dBwieaSmFRrrTBd6wnV2oyoxmmYA6LUg+7f/43GF+nSBb6wnsDFYT+iMta7Jb4s5B2dMDjr
 db6zxVPH
 fNslJYZsGMCZqw9/3eJqp5OJWeP4JLnR6sHl3NtTe3TkjHSoIunOlLDSMFXLLON3Jm/ee+X79p2ZxB5+Icfk8imqeS6z6kLQbxcJEqq24puonn33aNoWz0x8fEF4UhW6kZA9XvJQouxZMVDtPhVVbLI98f8aEWsy94TDbxy882MyeXQZluZo/zV4s5hWcIXc6TUqnVXVnyU7oYFZyMKo5LuglpXQJcn9LbhHda6EOiJajddMDRmgAiDOtL2djHwmFeZERk1ogRh0NnLCF4YNVzLWdCA8cwt4t3Qr6lDz60W+5NHOT5IafwLS5T0pXIslkhlT/MNLVgLigQESKn0+m6q0HxWjm7PpoWEfz3btx/IygpOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memblk_nr_poison_inc() and memblk_nr_poison_sub() call
find_memory_block_by_id(), which requires device_hotplug_lock to
serialize the xarray lookup against memory block removal.

Take device_hotplug_lock around the lookup and nr_hwpoison update so
the memory block cannot disappear between xa_load() and get_device().

Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/base/memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 6981b55d582a..f76aee29e9a5 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
 void memblk_nr_poison_inc(unsigned long pfn)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem;
 
+	lock_device_hotplug();
+	mem = find_memory_block_by_id(block_id);
 	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
 		put_device(&mem->dev);
 	}
+	unlock_device_hotplug();
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
 {
 	const unsigned long block_id = pfn_to_block_id(pfn);
-	struct memory_block *mem = find_memory_block_by_id(block_id);
+	struct memory_block *mem;
 
+	lock_device_hotplug();
+	mem = find_memory_block_by_id(block_id);
 	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
 		put_device(&mem->dev);
 	}
+	unlock_device_hotplug();
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)
-- 
2.20.1


