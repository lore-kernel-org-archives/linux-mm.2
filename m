Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA06BC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8125A6B00A9; Fri, 11 Sep 2026 15:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7271D6B00AB; Fri, 11 Sep 2026 15:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639666B00A9; Fri, 11 Sep 2026 15:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32A4B6B00A9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:41:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B1FD1C1B12
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:58 +0000 (UTC)
X-FDA: 85202501916.27.62D81FF
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF06E4000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OKt8760+;
	spf=pass (imf11.hostedemail.com: domain of 3g1mkagYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3g1mkagYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FgSt6854K565EW8hKNAIrNpKO8xQPyDCjbWGmWWQzU=;
	b=ABIVtu58N0kG77OUrXVeFXShwVH68L6lVaZ7gA8PCOsVJHU2jNStZJSq9GlXfulDEbAuOV
	M1QTfwwuDFC9PUGnQsupYE9Ts1pBWdxfP9BAkgzcHnv3ILqoEr3QEi1UmUHAc96V5nfS/K
	931moWnAuIdTjmxC4xZUBAxH0k7vJB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155716;
	b=MnxOQFtSZWwdU6PNu/uTNGsuiw9Z5KlPiIp56DEwd0Ew0zHmEU3G+rN/QcEAw5N+GVwv3t
	/3dIVTPNd/rkU4ZqKFsDa4Erc34ttyv0nCHlJGDXgh6MYL9KhiWG0yYufV1NcZDrES5k5w
	z5yZF1X/Z3cvBQSeaGCzgUexjJr5yj0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OKt8760+;
	spf=pass (imf11.hostedemail.com: domain of 3g1mkagYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3g1mkagYKCCQSURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8679cfe5019so1877949b3a.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155715; x=1789760515; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7FgSt6854K565EW8hKNAIrNpKO8xQPyDCjbWGmWWQzU=;
        b=OKt8760+LAlYCnskjkhVF2GjSB0hC/qdFm+lX8CIQAlNHbAf2Gy+gfhIb3sKNQazP/
         DNCyvJB+K34JVNMWe6F9O/rdNw9KGaVf0PyH/8xOh9GiaGpUgkgQtyX4C4OwmPBE5tJA
         /sB9QEzsPeOj29AYXXADEaqmvcVN+Zosc2tMEzXut7cWO96BrWHf3LbI42cUGqTXikmH
         RACigA+4ps/C4HSu/C8lsQpKCUeU8YQEP1tbfyf2kHBCAWV2KVfgBgsNeCBJMbEkrxA3
         6Nto+94vBRqVdK77YeZpUfmNRmAIHD4NMVVmYTMnCfoSv3XhOg9eOYZFgkdYtQORRNEM
         wY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155715; x=1789760515;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7FgSt6854K565EW8hKNAIrNpKO8xQPyDCjbWGmWWQzU=;
        b=eCwCIExwd4aLMeDg678sN5DBn5QU6JX395XqNajwwAwYBONhb8NGG6tF5bcGGCOJOn
         XWrMt7cpOkUzQbwVtcaF/OVYVX9PLynyWQ9rMFr5CHji17vcX/moYRDAAGb9RCJh+u9L
         JnPOzh3OSpWPOJ7I+wdqwtxf5h57aTBAMFYO4TIS8SnhqWI4/GAM0BdDwnQ+0tzfZRvm
         /m8TwIPbFRUcRBMnqywJsm1z9F8Cy1cmG6jvi3AQuEzaHexmTe3t6XPo5+DFZGnJUmZJ
         kA9gyWeVFDxKa8G5YtaPPDcSLQvHcG5gStj5w+bhjw5KkjEC8K0LoZqsHmlkaac4Spzb
         UuCw==
X-Forwarded-Encrypted: i=1; AKwUvBxsadlujKZrBnou4MwkpkDuAfLjvg2Boch6olSGGv/2gAizkrBGSW5OsiZYaNvGhsWWewOSe7q4/A==@kvack.org
X-Gm-Message-State: AFuF++l+ojznHFruJlQTUx8wPMckW55TWpJeXeaAiFy95cVZRw0VpIOs
	YKilviLngkgqjwyp2U6c6M8NSU8vY5ZyYfw4YauvSxm7iTx/oAd/zwPbAxKtCRyiHnYBF+27BXI
	WJaCMnw==
X-Received: from dyaz19-n1.prod.google.com ([2002:a05:693c:6393:10b0:339:7d9d:9439])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c8f:b0:3da:b8b4:91d7
 with SMTP id adf61e73a8af0-3daed100006mr10905880637.2.1789155715225; Fri, 11
 Sep 2026 12:41:55 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:41 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-4-surenb@google.com>
Subject: [PATCH v4 3/7] proc/task_mmu: clarify shmem mapping walk conditions
 in smap_gather_stats()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s9p87q4jmyn7jhhfqk7bdakqxh31f7da
X-Rspamd-Queue-Id: AF06E4000C
X-HE-Tag: 1789155716-578565
X-HE-Meta: U2FsdGVkX19gp9P/hi0/+71HxZZ61+8XQoxm+f0flsMzwG6e53NwYykOnDiBaQ5kMW03XHklAw7EHpmxEe1nQt6U3MJHpm1UX3mt8UMu6zL8Np7KFKK4Zew9QQG+fDR8tg0gUAHE1rFQK0hDdWowGeww2QEBVstj9sOdQJMa2/q+KunXc94XcZLbkziRCj62E63fsWj1ickP8Yfxopw+ABv6G/ZL2ypaZO5kmYtQzh07dXJ9djpn0eHb3GSCHADD/Q5IbLu87a7agCbjMaOjl515D1Sum7+et6Pki0wHJr462uT8WVmwcOUauM0r9FfkpG6zrmBWn5M+O3xnJOgeNzXdYkKxKFkMpRzBSas//2Hmc40lYPeSg5F/fZYPh2IgcM4hK3aONSFG8/PIqAA8+XM6dfuwh99mnSuENbQq4dw0qNQhQIf6E+tAClmJvuQTJiM9HfxSQB6wjsUzP4tdTqpZt3F/bAkargczkKV8C/sDhzmprbX2GHSNgqzSjBJPeNtTsYcMyjdevJOTWpt0LeLYSqqDMNSXEbsCL+Hu4i9Gp5WssBDqflKma+lhUEvreZOggup/FxqafEMn3dDOe/KgZnAkNHAqB96M9yJ+kEQS04vUA+R6H4MqOs61DnJJNzjKCR4h7NqZC5dcgT2KLgUJbyQz1zQzA5ZMoD34NpKkgrPHOGsBMc/XAlOzEggJlEi14/fTHxo6wgBGOr5ZOsHpnI9zTGNq7w7AHX1RzMkHHUgOd0/S/BCPja/56aaAmohWUyYbIxkLjeY49zY7KmJBfUh4TVxCcz/I7Wah6dVltbHAL++Qp8N14s2z4coNVPC9mW9cDnPP5wreg10q8NWTquKF/soC1m4fb7Ljzyxf9X0wWjuGd7GYued7vb4unReU2A9VSKOw+ioavi1NmlnSDsWB2wGIukL37Oq/HBoq1meGSSPo39IOWgvFBpx8w2n7RC4kuowspfxd5I0
 qzuhp/jU
 LZTIC9Ap4UpjQfXMFH/VdhqJSVLtL7z77uWKB06bR//zQP3ahjmTB2VfecUiNc82SjCkP2WvwKtU8QKws2SxWkCBDHKaUW6CI7fT5IWjtPM/aRx2E1X/ExA8wg+TrPRbyNdr4v0OmnSr0oteD1TrOQcuqVHpaoqMSM0EeBKYSZkHnL3wxk0mYuG22DkDa4H9loFyCuLQozExRiV3if+oztGjCrPQzVkXFrQjTqzaX+QnxB76/1/Yh32Nabs3PQVgD56jCu7Lqp0OilYsOuweA7D3NYuzSoDmyzmV72H7dQVPGz+XWQ1EejPpjtL91GWTH1kYHjyKB32ugSLvrOAa+XesTmSBLYTQP9HcI7NlElpcVvHiyJAzaZXMxebVkKUfJSS8VIZbSk7Uxtm0ydZ18ucLnDclGFGrE2ixagp61bCrrjpVuCO/O7PszIReAgBuQxg2B7QlPQcpF8/57DDhS0ROPv0nFETqKrf61IfPovYy7PMeGtW5KLkRbv37N8BW7UK2ihwLuklW4JJjRmMm7k4JvuVSYDVR4EUj4BPV+2T4XhCVlSsUxdV7/AzLsKEW3kuol0mAaB4Ouf3I8n3LtzrB8XFMvxuF4kw2cYB6FyiqdrHNL2oVC1vo4Qpbjk3scB65QuEdfjH9lr2b0IfgtbamiUycdyfFCyA2rZ0mDoD0aIary9dMcyJKb3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smap_gather_stats() optimizes stats gathering by skipping the walk for
shmem mappings in certain conditions. Update the comment to clarify
these conditions and use vma_is_cow_mapping() for CoW identification
instead of open-coding it.

No functional change intended.

Suggested by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cfc7af1b551d..0e53eb065a3e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1270,23 +1270,18 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
-		 * For shared or readonly shmem mappings we know that all
-		 * swapped out pages belong to the shmem object, and we can
-		 * obtain the swap value much more efficiently. For private
-		 * writable mappings, we might have COW pages that are
-		 * not affected by the parent swapped out pages of the shmem
-		 * object, so we have to distinguish them during the page walk.
-		 * Unless we know that the shmem object (or the part mapped by
-		 * our VMA) has no swapped out pages at all.
+		 * CoW mappings might map anon folios that do not belong to
+		 * shmem. Perform a less efficient page table walk in this
+		 * situation, unless we know that the shmem object (or the
+		 * part mapped by our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
-			mss->swap += shmem_swapped;
-		} else {
+		if (start || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
+		else
+			mss->swap += shmem_swapped;
 	}
 
 	if (!start)
-- 
2.55.0.1007.g17ff1f9808-goog


