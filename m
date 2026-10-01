Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE64CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5046B0088; Thu,  1 Oct 2026 11:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACB56B008A; Thu,  1 Oct 2026 11:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3036B008C; Thu,  1 Oct 2026 11:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02AC76B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:34:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 905BC140466
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:34:01 +0000 (UTC)
X-FDA: 85274453082.16.31585A4
Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id C00E8C0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:33:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lHkgwCW7;
	spf=pass (imf10.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790868839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7R/8/9AITUujGUpkgkK/lwuX+Zqo9Tj1z8OfLHWk1D8=;
	b=Pgl/BiGQ3zfwsONXkBCs80TKWl/wYpYQ3ntpd4DdVM0oRa2XoCyFyvN3rribOXXbGujbvA
	eh23XQ3dfgMXTtLvBjhE09Gc0kRphR7eEKM9xZeuPB384865mWHTIgIsDAmeJ0sHVtgyVe
	/tGcq17xWaR3i/Z2YO2ASHA9WNcAI68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790868839;
	b=vK93uvQSzPmVo7NYhB2DfZ/Lcz5Pf2vzqQu7EhVa8Plyekwz+2lgPhutI0ka356IBlo/Zl
	uAx3xGdXb8f/qXibCTF9aWpwoAd8U0/LlMO8WiRpY2KNlqFYV2vZmL/jra7ngG/Y9571Sw
	sBTdvAVp1kV3yBWEGa38wbpoFYIdTxQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lHkgwCW7;
	spf=pass (imf10.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd025d06so4901212c88.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790868838; x=1791473638; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7R/8/9AITUujGUpkgkK/lwuX+Zqo9Tj1z8OfLHWk1D8=;
        b=lHkgwCW7BnAxyAdQKNMsxmBka38M674BZC/htR4Ac4GxvCupCx3OPMrmc6+i/ht5kg
         5SCrV8oOVyDMDzQoTGI8HPnZUA4PcaAmbynZIlrDNDQh1m1h9KddR4cJogLc0NsPLH/g
         nqYnWXi3gn8rrMP20jVTn7uo7IDT93JRgf8pVumvKWGfL3+SRGr+SXCu3rTunTWe9cZa
         Pl0Y0xIDB4CRkSSTnrp7secf5viq6V+i44MoluMqVmSYtgBRYf7XyND8XzFnFPlFplF2
         Vgenkj3H6C/FY3Stdwvtj6x1tHwpB2PjHWrgKqIRBNKCmeYO/mobN/A+0wxtXfYY9tE0
         tb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790868838; x=1791473638;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7R/8/9AITUujGUpkgkK/lwuX+Zqo9Tj1z8OfLHWk1D8=;
        b=MnGh9J1WrvMd9EniOX4t1BV9e3Lh1+OYPivFMhC1HzEIUcKnFzFuOzcTL5tAOM5IMP
         fymCIp0ck28ZCZgVv6D3iWUjw4XKEkzJBxYq9Pa+3p8TrUqpelnUpIC1VwdZsmsZEJD2
         mxHFRA18uIBnxWXivyeArWFYfcfiqBUVGMYuUr8YTPekF2+oPvjxigJD+7iyrufuGa3i
         4BnO+X9+0fGvM4+l9jr6YeAPzyWEbCSwrs5VpCj8YtaTUo07LNz6no2PuXedMNnzzrKg
         r/ZsMMM0tXYmXcvFiqRs5urjqDMqh1AK1qPiZiaI1f5rkM5ioUeUW1lVARsEGQm9Q8cb
         caVw==
X-Gm-Message-State: AFuF++lplLHWc60fJBWvKyfjTVRj+mFwmkLqOL2SuLlQX2WYAA8YkGgI
	CAI02ABbYWgJFzotyzR+d45my3t5NUyGHHQr1ti8T9PFN3whPlcDz3er
X-Gm-Gg: AYBFou1v2hTwsOPfjWWgBnwVRDc8ThKA0MAKfxQFZ15JpKPm2bffuZicBKA53No1Lyh
	j/WZF9EFxGKfu33jq0PxPDCN1Cf2o1bXFexdwCg4UABvQ8M1Pgd/T1JFcKATyK9XcpmlKqaYx3m
	y9zLAyXzUIAwj7kuDKXaY8PMl/T1JQvGrrmXDKoYuPnIaEslUS4F50DhV4Vk1lqN1lFphTERYUn
	4DEa3fjrnBfJI2HQm8BlkQ8BTtG7ab+vA1QGsAirURGZi+uzw/CaG/D33SO1UjdG1gKVvGU5+r5
	ZIEbTKn2/JtMwNS1YgLJ//dOFKC13tITVwWesUQiZJHymAPuxcZ7jPEDj4VwOTwfNMGJu063EuK
	L49V5r7Mdk/mJqE4MHMIWXe9Mh8vpTQB5wF3UQyrvmKCoIOf+9Sfxm/L0bMt+WyPBugAWkehVMe
	98KHlKjPmh6oBQzJsU335QhSK8rl71rzAiPf225mfiuWDrypaigNd9+R1vqN1OtJKkXQ==
X-Received: by 2002:a05:7022:eb57:10b0:143:50a0:56be with SMTP id a92af1059eb24-14d31c6d41fmr5203438c88.14.1790868838309;
        Thu, 01 Oct 2026 08:33:58 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f266d1156sm146683c88.6.2026.10.01.08.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:33:57 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH 0/2] mm/compaction: stop repeating failed async compaction
 on every THP fault
Date: Thu, 01 Oct 2026 23:33:47 +0800
Message-Id: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFt9vmoC/x3NSQqEMBBA0atIrS3IgNL0VcRFhorWIjEkKjbi3
 Tu4fJv/b6hUmCp8uxsKnVx5Sw2y78CtJi2E7JtBCTVKISTaY8EYcV8zmvpLDt0Ws3E7egpU0H6
 0HqQNVg0eWiQXCny9g2l+nj92WGescAAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C00E8C0002
X-Stat-Signature: hezteckgw8xndwm4qep88sq95pc16ke5
X-HE-Tag: 1790868839-44740
X-HE-Meta: U2FsdGVkX1/PdsZ8md/1eX/2/QH+ZVlseV4r+Jnt9uT9DYyCc7XKf/O4KitVB96RuyEX070n0T2gXlvPyhTPnUu9KQQoDeyQd8ZUISBH4GAF039CIu9AKcxORJz/0rp82vWFXhIlVekm/SiBKouEGfG5gKT2TQVIVYEc9Y69RhQIRdr849A9AcPZmRxCoI2P0hVdotqLdYymESANlbB1DRQoOiTntOtvdmgp7w5mcoceEBDw2nt+7mSewiU6IexnlXsMrdViHM5g6TrOZOdbGzSwVI92ftE9/MtvPyiCed+AIV1HZ0GjyVEwT0AX21z0wI7VQXHjpOlABA5t7Nzxx+IyykoY9oDpVKK9daM+dFYAvbI6uQNJPU0dAOS0a7LdoC2EASXarpB00NDI2qQczdRN8ZeCPTd5dJ0apk1GjD9BR1plswE6tM9MNKaxWxAC2cSqq2wfu/eqSsF9nyjCzmpEoIuVwzBcC6QvOdhvHHEe9Vmf1N9vK67YDDsZhwvJa6DXSgoxlwATmo4JQ0VHQh+jPgJfFrQT8h4skW8H3EfVyihaFFAXtwS5fmjtkbYIqk75aDO0Y/RZ0RhuO62H4DULOQmjJjm99gW76+JF6d+N4VjH6SaJEDoxdGZW743pJiT8MkTRJCcJzXYp8e1Rr1C9TD6asH7VPBv1+enL6/MdYPqgfa60ljahbxIKPtnm43PIyXw7Tbaeg9W8K/NDjXMDvKLXwtFnisnRR5aKm6nqb7OeCQimWooKPeBGmCD96dUHefcM8bTRt0kKL8XoDw9kC+Ba7PBHwFXzigCuhNlIlY95XSV+fSCi7oGEBd2kK4lfhTC8DSn6HPjv7CVyYIrD7Lm4dPgrKu2+k0EfeJ9JDcneHodxo6+HDtfCZpFieHi690HgbgJu6cXBMQum/j5XjkvIB9d5cBCngDX2P1O2q6+eT3wGEI+5Jrx1o+TZj6oxLqszn+vtHOzRZbG
 aVV3Qmxe
 y3kbyqAMtIeXYI512TwrLMBaijNE5eGR3HZxcXzwq2CdvC1LZOn2cOmYkoTlhkU2oAPX/a348scAFKtyeAEdEQWJX/1ysg7N/AOLWyJdqzalFv2l/zsx0GTeFYBHnZGu/b++U+d4xbQQexLGGgqAJA0dtIUJoShgZQuPo++G4aN7i8JuyOWqGHj2q+h7X60KJBMoyxfzV/JGcIhlro/1AfVQcbY6RrlY9dmx7RDWZjQB1ag+B49SbwKBLanRhcKX3ulFujVUpN+ikCfLGf9ynzPoxg4GC4gOQhcHcylsW+gNUFt9O+BfkiIPjs9tB9pNcl6VAasiMg0mfeZQTOtx1uXOh0brIXxFqa9arqK1kO3GmvBziMs9FAjpFeX0HHJHumBQkfcNxcXyJzkNOpdnz7W7Q+8/n0S0SHfevDdioUHa6CamsnTbBTCTBiq3ITgf4LuyWmrmM3UjBHYbF62x7TgWSpdt0cg3llDoHKy9LJ6iy/3vuZ1PwiPfb0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A THP fault on a MADV_HUGEPAGE VMA tries the local node first with a
single round of async direct compaction. A failed async run is never
deferred, so when the local node is fragmented by memory that can't be
migrated, such as long-term RDMA pins, every 2M fault scans the zone
again before falling back to another node.

Patch 1 splits the deferral state by migration mode. Patch 2 defers
async compaction on its own state after it fails, leaving sync
compaction as it is.

Populating a 4 GiB MADV_HUGEPAGE buffer on a node fragmented by pinned
memory, direct compactions drop from 735 to 15 and the time spent in
compaction from 122.7 ms to 3.6 ms. Fewer of the THPs are allocated on
the local node, 1126 instead of 1313; the rest come from the other
node. Details and the movable-memory case are in patch 2.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
Qiliang Yuan (2):
      mm/compaction: keep compaction deferral state per migration mode
      mm/compaction: defer failed async direct compaction

 include/linux/mmzone.h            |  7 ++--
 include/trace/events/compaction.h | 27 ++++++++------
 mm/compaction.c                   | 77 ++++++++++++++++++++++-----------------
 3 files changed, 63 insertions(+), 48 deletions(-)
---
base-commit: 551c722f40809618230001baccf219193e22fc5a
change-id: 20261001-bug-mm-thp-async-compact-defer-b83351bfb25d

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


