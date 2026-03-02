Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB34E9B36B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553D26B0089; Mon,  2 Mar 2026 06:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501786B008A; Mon,  2 Mar 2026 06:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFE16B008C; Mon,  2 Mar 2026 06:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C16E6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:47:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D159A1B8B75
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:47:46 +0000 (UTC)
X-FDA: 84500948532.09.8B53900
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06055140008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:47:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jqhgdx1e;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772452065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFo3Ih7QU9IZxDZbOcJePTkGiOdWme4psvs/TRTzUGA=;
	b=lrYSRb2NezCA++MAUVVw8XXttMkR+EZ4MyTJm3dcDDp2OonDzdlCHNmWh21KG7wMic6H6z
	Fgk2Oss51rbN0vGlivFnuyHdM5x2PX7eL4Hn94KQ8p6K6SxaImNYQTTzuiRTycfe26rWch
	DiF8SuaPZRdn6yVxf/OubZQv6mjwvu8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jqhgdx1e;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772452065; a=rsa-sha256;
	cv=none;
	b=BGDSm5xvzREe4M2POuXFNhzMJzAsL8z3XRgsx9lbxmOiRp6dk7P+nS2uZLi0/od42VFtk1
	5VI1UlvfC0Shxmy3Gpe7Vy8aOtHI0oWiuwhrs+uD3EhkCzDtyJoCn7TvVLCAgb6iqVtf0c
	IPuvCZoRorZQxV+jxNykPg0oaVy+mPs=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-389ebb0e885so78900931fa.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772452063; x=1773056863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFo3Ih7QU9IZxDZbOcJePTkGiOdWme4psvs/TRTzUGA=;
        b=jqhgdx1efHGfKO80xHA848sQq8juOLL94uF3byfSmkKJjeDT93olwQw/94ldmgBghL
         uBs3gSDfc6Zc6YwuNQoS51YzwziD2294tkDmYHdq68fahw2gY3xXxqkelItXquztlQ/O
         zCbAUTGh96vDDLzcXlRGv57saRTah4MzLzJs+mEJtTyj/AlUJb1R73QWv2uLSwHorOxB
         85GuUt/RGeMU1yYYLquftboSiDgtbOaYBTpDMdsX+fw0yxe1HmJH86jg34ctxJ0VQkQa
         rCrx346pf6zxg6NmUoJGChGHUJY/3Qcw7Bt6KZbdjkqOXGq7nhvB1D/QfjdJpmxrCvat
         hsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772452063; x=1773056863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HFo3Ih7QU9IZxDZbOcJePTkGiOdWme4psvs/TRTzUGA=;
        b=f/mg+xfzzkdnl95+5TOUI8T+gNnDJfDF1M4wwmcZ6IKj6XK0OETTrwxQe/gtcah+cf
         kadt13nNVYfOB+SghvzB/aXnvyc2jjcpHkAaWruCfTN0lIHHiORDXbyx0YgxyEGBsmCl
         8Kv6DIHAx4PjC7Dg5LSOCtW6T5G7sK8kKDbqRYQ/EmE8++65cad5/S37EvHXh8BpUU2c
         k1ismH4CHT9gv9bs98lzwIPcjpeFyckjvDELBmmdQGUqHuY7+vHwDLdIfHII+bN5RYqL
         TNCtMHWuaQa9r9liVO52NdHIGSRM7y6ubWdCPH8zWgoC5A3Xli0lSSaNjPLtJ5GrE/Lx
         BAfg==
X-Gm-Message-State: AOJu0YwpfDVHqdcFI3B8MVbmJGAfOfhv0fgpz5a2JJQhL+Vel4UKg/2K
	PW5zEMdmguJ/K8IT5uk7mI7HUtLCtqbPYYuGdRch6BqIKPmmDIE7+ugCdXJJOuvW
X-Gm-Gg: ATEYQzwdMTpuOwYu0I9ORexbOA7RUIJArgjT7yT8FTZHQuVjJ7JVWWI3g8t+XZf/rpP
	H2QpS5Y/d2SZRl0z+NnIkK1Zlof7CrbjRN9by0B5jBEuQ8AaO3ZxEAo+hPemvaTw2RkDH212Dyp
	+hl0ka8WyjKCgyGl/vvlgHoEqc3wm/T6oOxiPdnwvMTLQ/Hi9i7INFZkHQbmzltXly2RNIrX3vk
	igmZ46Riprubq4bEZPN5ek5zOhFgcS7nak832BiVJT09UPIEPKL0+GSPT+y2VUmENRUehqMWaGd
	w7jP/ZDu6VMx2r0ljGFkDBNvHcpRB1AEhl5uSi2bvWU9r7TRppiJoLBbSJiXYs1h8s/qFBPLOPX
	bxM7ds1fjCl3Muem1rgN0l2LjqFjUZY+lfi/CjsxHS0idZLoPvBPhC0DzNSFZKbtza3MkWQvT1a
	pXvvZtrruGBeJBjhI=
X-Received: by 2002:a05:651c:25d5:10b0:389:fc6b:943f with SMTP id 38308e7fff4ca-389ff119cebmr57137381fa.11.1772452063156;
        Mon, 02 Mar 2026 03:47:43 -0800 (PST)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a115bca02asm1603412e87.25.2026.03.02.03.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:47:42 -0800 (PST)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Date: Mon,  2 Mar 2026 12:47:40 +0100
Message-ID: <20260302114740.2668450-2-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302114740.2668450-1-urezki@gmail.com>
References: <20260302114740.2668450-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9afrqncrbhxj3axqbacq7kuydpqo69fw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 06055140008
X-HE-Tag: 1772452064-833097
X-HE-Meta: U2FsdGVkX19CGKK9lyIpJm3yyRQT/Adm5yX31ybo0ZIqApttxEPXtvFKcB4ZLc5yTVeBaoiE504w7y0pXZwrcOVftVi9hdVYM3PCQyxymcIlM+SfWHNwunst1j8gcdQzr/bGqUmoWU/5o2Hc51UjOslDGYGISkkR82N+01zPr8Fuympw8wOU+epckxGVMCkhbSi5ZAbg1iT8cYSxpUp/PENnDGZbmuwCOKUGBda6tHhvxP6Wujbq0zHhVmjm6ELof18mC70qavcDPoahZUVEQikSYruC+lLlP5+aXR1mputUYDZO7ZjW6BAA+zM6Hk8pbDxCGvYHAuZjrUM1Q3RM3w9Y3w0CocJbcvfjGv9daxHTpg2frKPl068bIO/hhUbIKcDUKRbT2GKlIV29anY57jlu4EqGVVebdCgJjglUGcpl+cjxCEERU9Ece2Hhznf5kX4GHqlR2Wyr4MTeYduZagXIxF6Kr4cO6G29I+6Sp6mxaRAlvrpHLNAEFxqTBLmncHKzgOu5CsWM43Icxl32ML3cRfru10F8nXNoLuhUZozh1S46xP7I6Xa9DYMi3OMvc6zZcKgZ9MKs9u5fXqQ4RD2R0MrXJYIhPL/dbAD+fLkXCWE+TfUu7sdYM7t8Y0McK/K+/dOE9zH76ozJdfbkwXSPEada0AJQ97+Rfu7mFrs4X9H/zoFwT4MIlhjzy8rqLu3M/loW6FSKiK/6/3dZwdbK0d6OhCKjfOz5l9/bPVEdj3NuJxpiEuDnAvfU318GvvQUW3KzpSj9OLmH+wYRWg3LwxkHpNKXHHcseQOpbg0IvQ639Z5OOyYFx/AnZiatkCPtxODisTUtTujgh9Nv66lrJDLnVOnBIThqqFuUo0k+3CsTtZbRnvxap6vdoZdvH+GRXRVWn7Q+EJiago+H1PgR2pOo9ZSVokvYcgOvRhrUci/ZrGkhFHPO6aUMA4DokDis2mkpfj3r7xM/XEQ
 ddYfVG4p
 4O5NiMPznDfhy2VM9mtJnIIKBlJKbwEXqYORnZwXvzkFurEww4PrJ/C6tB8QtLpYVjH4cN/TaI4k1fpsWG2qeg4TENM9tMcpTIlD3OndAsbH88zKuYXuDprpAqHkfvbeo7RW+hwzBjN2iyD26ML0K80SPwGeIzxYh1AO4GFaOEph+JKXClPM7EjfqQNZoKpvnocUb8D86rIy65eVjZiUjPDXODF8ob6SDIe+ElziLB8XB8ihTAbBsfLXX6cqz8NHb3vNICoiBkgAyA2Jb5BdAtjQajxLXFHh2vfuiTY0mr8c5ho3bPtFPqWvYyBtu4uC+G+idR/ZtFxPJXczRvIES4c1MFCvmfCHzAR2Ng+qGJgR/qLhevrjQ2ZfXcbhc3eO1vAOzP61bsxfjEdxigLA6OzwgbTo7SDuWkqd2mj4chERdlSKb8OhRTwrrgcDK75+jLsIXUYjfjot6J2KTO4cvX6YueikBlOLG0HS+J1/bK6QJci/UY15r9zlPFRo0awVicvzBC5VOHx6vywMxhrff4NuwZAN4OgxMgwhGCiPJC2Mx89Tfkp4wfYiP5x7QMQiyklu4MrRIU10HhLrWQ3Cd8wb4z11393EawqIuu0taaxE2i27IlLUSC6eYgWq086TX/X27tRBs3xwOvhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michal Hocko <mhocko@suse.com>

__GFP_RETRY_MAYFAIL and __GFP_NORETRY haven't been supported so far
because their semantic (i.e. to not trigger OOM killer) is not possible
with the existing vmalloc page table allocation which is allowing for
the OOM killer.

Example: __vmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);

<snip>
 vmalloc_test/55 invoked oom-killer:
 gfp_mask=0x40dc0(
 GFP_KERNEL|__GFP_ZERO|__GFP_COMP), order=0, oom_score_adj=0
 active_anon:0 inactive_anon:0 isolated_anon:0
  active_file:0 inactive_file:0 isolated_file:0
  unevictable:0 dirty:0 writeback:0
  slab_reclaimable:700 slab_unreclaimable:33708
  mapped:0 shmem:0 pagetables:5174
  sec_pagetables:0 bounce:0
  kernel_misc_reclaimable:0
  free:850 free_pcp:319 free_cma:0
 CPU: 4 UID: 0 PID: 639 Comm: vmalloc_test/55 ...
 Hardware name: QEMU Standard PC (i440FX + PIIX, ...
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5d/0x80
  dump_header+0x43/0x1b3
  out_of_memory.cold+0x8/0x78
  __alloc_pages_slowpath.constprop.0+0xef5/0x1130
  __alloc_frozen_pages_noprof+0x312/0x330
  alloc_pages_mpol+0x7d/0x160
  alloc_pages_noprof+0x50/0xa0
  __pte_alloc_kernel+0x1e/0x1f0
  ...
<snip>

There are usecases for these modifiers when a large allocation request
should rather fail than trigger OOM killer which wouldn't be able to
handle the situation anyway [1].

While we cannot change existing page table allocation code easily we can
piggy back on scoped NOWAIT allocation for them that we already have in
place. The rationale is that the bulk of the consumed memory is sitting
in pages backing the vmalloc allocation. Page tables are only
participating a tiny fraction. Moreover page tables for virtually allocated
areas are never reclaimed so the longer the system runs to less likely
they are. It makes sense to allow an approximation of __GFP_RETRY_MAYFAIL
and __GFP_NORETRY even if the page table allocation part is much weaker.
This doesn't break the failure mode while it allows for the no OOM
semantic.

[1] https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u

Tested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a06f4b3ea367..975592b0ec89 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
  * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
  * GFP_NOFS - memalloc_nofs_save()
  * GFP_NOIO - memalloc_noio_save()
+ * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save()
+ * to prevent OOMs
  *
  * Returns a flag cookie to pair with restore.
  */
@@ -3806,7 +3808,8 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
 {
 	unsigned int flags = 0;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
+	if (!gfpflags_allow_blocking(gfp_mask) ||
+			(gfp_mask & (__GFP_RETRY_MAYFAIL | __GFP_NORETRY)))
 		flags = memalloc_noreclaim_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
@@ -3940,7 +3943,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
-				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_NOFAIL | __GFP_ZERO |\
+				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
@@ -3971,12 +3975,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * virtual range with protection @prot.
  *
  * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
- * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
+ * Zone modifiers are not supported.
  * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
  * by __vmalloc().
  *
- * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
- * and %__GFP_RETRY_MAYFAIL are not supported.
+ * Retry modifiers: only %__GFP_NOFAIL is fully supported;
+ * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
+ * i.e. page tables are allocated with NOWAIT semantic so they might fail
+ * under moderate memory pressure.
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
-- 
2.47.3


