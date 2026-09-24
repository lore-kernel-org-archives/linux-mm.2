Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5882C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D4F6B0088; Thu, 24 Sep 2026 05:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B145B6B008C; Thu, 24 Sep 2026 05:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BAC6B0092; Thu, 24 Sep 2026 05:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 783946B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:23:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 987231C22F1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:23:14 +0000 (UTC)
X-FDA: 85248117108.16.BE52FA2
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6A78120008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:23:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S7TQWtTF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790241792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7QZ8HgImhCopDFDWHquBQ0HUnxqZBWvfTbRoX5PG3mc=;
	b=Kp8va9oxGgitY0L/TWljp12igYGOELBWZj48FWmB0gkMyAgjk2apgMzJwIv6beqRcLUmxU
	W6vHGpe8hZBy8C2L3FGbPOyjvVG0BDtRow6Cb7WFR/cFqwCgx2A17lZGIIeguQ0MAVZR6k
	wONbMbucq+qyuOGY9DQpJhSzSxWHT40=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S7TQWtTF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790241792;
	b=Sz3yIe84CSmp/hMMbdr9hVuOAk7PqaSz3jKmsJ7+PP60NsBhAfjysV562+jPtiBAmoEFg0
	mp/h8nQjekrHk3WlvW8Yumk5Ooz39Zjouoo91orHP9lJVC3T6BJi3AOSXLZ/KQY13rsGdl
	qSxQUwXRv/cGgKM+EnfX6WM56dVd68c=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-486e1a044c5so1494838f8f.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790241791; x=1790846591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7QZ8HgImhCopDFDWHquBQ0HUnxqZBWvfTbRoX5PG3mc=;
        b=S7TQWtTFbRnk+2wFaYyQ25op1KqP6DyjgeXzLsjoFP5tkD4amwnOsxXuDvu1zakaHh
         I/UF09R5CEMMSKZtmkDYtyvAIB84s1G3E7mqTjAF9E35jkTCsyecL81RoTgR3vxTB2BK
         Rqh9+E7G77qr0hkfs0ULeb8UdUOZ3y80TYyhdqVX6iS04eUH5FxWCrcIbphFWth3MRQ9
         CVfz+DnZTEPNvaC8jNFrKsQhkQvlvkHTadtP/Sw26W4TlhCRHypEiNIxeATbBpWGd0Mm
         rGQzs8L+6qBp4pWVzm3FUOxRJZPzGDwTBwNLtZnfBoPSZdP/ykEDxxdrgvnPqeU7+5q1
         qNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790241791; x=1790846591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7QZ8HgImhCopDFDWHquBQ0HUnxqZBWvfTbRoX5PG3mc=;
        b=kMAWkrUCaXyrUvJPVosl8RMZcDHZ54RzjZlx3D7yqJ4oliyVNT7EMrY6GnokI5qIT1
         ZGsvaf1L2C5jMBQl1nLN/IYtg9JybzpGFT82XDkY+7V4eKUZ0y863up16ov1gM0QTgzA
         NnKqbTl7tIjLf6kr9zHqJ5EpmbvC/jvDN+UdSDa78JO+tRUX1aLOEbuGdBdn5oSQPcrt
         eI/Yg7yzP83nghWwvf/tTGPuXOZUz9MUTHhqh01DFpzYKedG7WZoooH0S/NehsE+4zdA
         JVD55KpfLD2Et0xLKmA+rl+Q8gDruX/8hdBKzgld8Dsvk3dQKOo7XjTkRTu/uF4sWoY9
         nsXA==
X-Forwarded-Encrypted: i=1; AKwUvBwTC963V7Dthi1deYxfX0Qw/qqPcHvb5jujdRbKSfM68P5ulrHQ2pvMlDAVHKu7Z+8Su0DINB7ioA==@kvack.org
X-Gm-Message-State: AFuF++linqleLJR0adH7oRg1vBapXz1y2Sb9yHm4nWFwHiMonlBp+EAf
	tQUBDGxwrwwO+quy/kqPJFzQVde1vMwd22164Y8LDAj8YYLH0ZIj05vy
X-Gm-Gg: AYBFou0xA/zhuJ9HDfnVKEkcxZ55CaZ78yU/UA9k5+WNHI82slwoTI8QOmAbIplFZGQ
	wGDs1rTs/FPRbdvbP6hy432ON9uEhY0pAQON3pR9+NVsyXsdHhyw9bxgCvE1BeSVjOisURwO9CN
	/oLE94Qzxj2Hc4v2/I8+DUrALztCHOmPLgs934DGOmPHR66f5dmjf55seyE+gVDKoOFalfDu4S7
	5zg4rqANATQxOhnCUWifHYz10dSh3cL8wAPnmdCs4+h0i+Eb1QL2nN0/bZJ5z8QKLy2CP6I4kgU
	RB3Ciki0Ubd3buYozsU3XDKOBA1SphyF6I+pD6eoEDtNnLIDjW8w+jA6+wts6Fpn19ivI+FDlKi
	yXr0sEDwmCJ02ePLwipQc/EoeGXkqxANx/GtZmFCbjfpHSFMYnT5WfNKWJZHXsAAm/uBnIaci/F
	9c1hTbZhJiCN+7TS4CGSxg/nu+vC8ACiFRBSnjnVLLqFH4lpuwvh3ZOAb4eYkYs9svlieTjbPYK
	WtHpreRCIbl4Ahdd9vq0YtalcjH04H3KX9HZ218psEf7Tlb88IZLL4F4zFGAhz+JlDo9oV1
X-Received: by 2002:a05:6000:2c07:b0:486:fa7b:d3aa with SMTP id ffacd0b85a97d-4887172d776mr3144237f8f.23.1790241791054;
        Thu, 24 Sep 2026 02:23:11 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488684862a3sm12164848f8f.7.2026.09.24.02.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 02:23:10 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	x86@kernel.org,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH v2] mm: don't schedule deferred kernel page table freeing while booting
Date: Thu, 24 Sep 2026 14:23:07 +0500
Message-ID: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pjo96et6ac4u97betsgpzboukje7i7kt
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6A78120008
X-HE-Tag: 1790241792-952549
X-HE-Meta: U2FsdGVkX19noqD1/8YBNR8iguS1/yh3Ihpnm+KgxcuHe3hBZYzOioN+dTOjFCWotM0tWw47WPkx+QnD+iWOHXG2ISCRpLXj6kSIZ3kT7IYU4P/OwF41Ti+q5WNZNPOFJ+YdgkTEGlOwIgukLvQhrVMbZXB50GnyWlZF8qxzMNSyW48soEflsSMy31Uejks7wB/oUxD91u+vRpLtO9x22OCHLw3mufEZA/UUe1mJQvIc0lHGqWqjFQz4Ad3TDNhp4qV7L7x5J4PrxQXNFYMt+KhKTOEdfRKuKOX4RX2ZDeAR+IiXL686u6RfmVJQkWrmvGjHbhvT81uIdf9AFc9NF9LJ8gn0g0Ps0tMCivbahqrQ4C3z4HusgVgPjiWNDuAjVSsRCqreGLI26ZFop0fsk9+SgalhM9QlERI9j7eUIi8g8QIldUfc9QTjtY82e08e55SUVoNR+sHzBjKPcqiYtJOJylCkQ7iy6JtVRQkyS4m2T/14O/GjMRLJQ9hpq4mPIQJTwwVx/BcfZzaUBW2i9kJbCfCkAHM/JTfhaxU7+yJVtcR8pYqmzLXyu9i833nSlOppqhc1QdXD/mSzviiA2mg1Lq8vI29v6Wfk2hhpEs1tn7PF0Vm1caD/L0qSHxaNJknT5TUeJGiPeIgg8DqidoROXIx5x5d6V9DutHxcM9KXcPuxKEqVHf7NvQ1zBcn03nXg8xux0j1ndwxYDU7hVj/zoT9HfXxG1vX79YLm4S442WtVHRu5Lh1Uvorg7FkKXGZLoN+FGe6lePGSnJyHDUBMizRTfE5vy9aTU0LkKVRh8ImfnbhOPZxVcDWItQwE80JiwFTIKBTibTs6mV7Ob3H9U5Lk6P4h6fd1WNIghVOoszu88yaxuI6vykI/VhI2Yw+8pWoVGhOURdTKyCwPO+2wlqjltt/fiiC+hDXtwfAgyUMth5yNtQNdQQgsxaFb5tJjIt4HrlQVkEYXnca
 QCFSyibM
 iObg/QdVKnU6Gn/n6FchTGHRu7maZn++ofyyDusoneS1kl6RoP3L7nyps/gu42Rfx7slIWZQOxeXkNunMIVyg6nhB05zszxK78bnhGS4YtJSBvZGGhF7epct5PMpp4ypoXbBbHpmqTd/cAsxsrTPKGGu4mJFJ9Gb5E+ndNaK+B+07M3LoNIgdBcW+lRDLlLSIgntSOT2kC975XTm0RcuHwc17Z1nLnvuhdZQNqPdX9wTBb2sk7/0s4gBcQD1rHEGmt0GOjSzRlYzUH8m7z9fdL4THgdTAIQQS38sCA4pbdznlDTm6q3jNBx2+KKbr5jNXfVw4BAQO63al0wdscGi+lAi5Fg9NpdDMAPnGypGZakyLnlh9NNBKslXhwnK5LcUkLH5/7+vaqIIDTlhviZ7yW+nouKw6OwsHE5qDbhE/poC6QoxeKcAIKU0YbtE9ABphTMQuXzZkaWLJgolnNkOGtlQ0qj/jmgHyI7mci2W35bRKzkDGHNSPDaV9r1EL+vC+mygifn+RjMKxz7bLvvDMOBQTwJXnb0ndPIs9UYu5yKwudn+BDrgQY+lPQUg92xkGfgqynAMw/fSOJ1uuXD8cqF9vsU7vNRbZTwxhrBtdcSWhAWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Booting with a boot-time function tracer and a filter, for example

  ftrace=function ftrace_filter=pud_free_pmd_page

panics on 7.3-rc4 as soon as the tracer starts:

  [   23.531178] Starting tracer 'function'
  [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
  [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
  [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
  [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
  [   25.981629] Call Trace:
  [   26.125727]  <TASK>
  [   26.413912]  ? pagetable_free_kernel+0x20/0x120
  [   26.990283]  queue_work_on+0x97/0xf0
  [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
  [   27.566662]  cpa_flush+0x394/0x620
  [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
  [   29.151729]  set_memory_rox+0xa2/0xf0
  [   29.584018]  create_trampoline+0x431/0x6f0
  ...
  [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!

The boot-time tracer is started from early_trace_init(), which runs
before workqueue_init_early().  Making its trampoline read-only splits a
large page, and CPA collapses it again right away.  The split table has
been a kernel page table since commit 9e4a3ec3411b
("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
collapse frees it through pagetable_free_kernel(), which queues work on
system_percpu_wq - still NULL at that point.  That commit is correct in
itself; it only lets CPA reach pagetable_free_kernel() before the
workqueue that function relies on exists.

Keep putting the table on the list, but don't schedule the work while
the system is still booting.  The next kernel page table freed after
boot schedules it, and the work then frees the early table too, after
the same IOMMU flush as any other.  If no kernel page table is freed
after boot, the ones freed during boot stay on the list.

Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
---
v2:
 - Keep the table on the list and only skip scheduling the work while
   booting, instead of freeing it directly (David Hildenbrand)
 - Say that 9e4a3ec3411b is correct in itself and only exposes the
   problem (Lorenzo Stoakes)
v1: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com

Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX, lockdep and KASAN
enabled, on 7.3-rc4 (fe2ec83746e5) with the same unrelated local
changes as noted for v1, booting with

  ftrace=function ftrace_filter=pud_free_pmd_page,pagetable_free_kernel,kernel_pgtable_work_func

The boot that panicked without the fix completes.  The table freed
while the tracer installs itself does not show up in the trace, since
the tracer is not live yet at that point, but the first kernel page
table freed after boot does: systemd-modules-load freeing one from
__cpa_collapse_large_pages() schedules the work, and
kernel_pgtable_work_func() runs 0.8 ms later and drains the list.  From
then on every pagetable_free_kernel() in the trace (660 entries, none
lost) is followed by a work run within a few milliseconds.  So on this
box the early tables wait until the first module is loaded, and no
separate drain is needed.

 mm/pgtable-generic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..f7f504f57914 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -444,6 +444,12 @@ void pagetable_free_kernel(struct ptdesc *pt)
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);
 
-	schedule_work(&kernel_pgtable_work.work);
+	/*
+	 * The workqueue may not exist yet while the system is booting.
+	 * The next kernel page table freed after boot schedules the work,
+	 * which then frees this one as well.
+	 */
+	if (system_state != SYSTEM_BOOTING)
+		schedule_work(&kernel_pgtable_work.work);
 }
 #endif
-- 
2.55.0


