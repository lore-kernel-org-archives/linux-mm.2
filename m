Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFDCC606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zp7PV80I
Received: by kanga.kvack.org (Postfix)
	id CB3426B0822; Tue, 27 Oct 2026 12:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AF96B0823; Tue, 27 Oct 2026 12:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79586B0824; Tue, 27 Oct 2026 12:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92B3A6B0822
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:12:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FD3D40A73
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:12:48 +0000 (UTC)
X-FDA: 85368899616.24.DD023B0
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64B7A180003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:12:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Zp7PV80I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2JU4hnXGHPQ1uce7Tn8xfVvyIR1SgV6yrtF0fmEwuc=;
	b=krZIXCtv/wL4pXPE1lby2Tutum0hTCLFH0BoM8iWyhEzQ8wMgyUInRu6mg7jR93CuJAI4H
	epL1HKaWSPKtaoiYljHtwlPNq3y13kIkP5Bs+5bQGyd0lQNwQ2t2R7ghOEO/JnPUjY7Hh9
	Ojinh0Zn7R64nqluRuzVtGvVtMYIL7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Zp7PV80I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117566;
	b=LYTNpwRecbKc24Mfc5k9K5OcHJM+cHgDpA90hSmkxRGmBjYn2DsBh31pGKQwpMPdCXv1HE
	t9qDdE6BQ9G/3tWz4uQSeXJlBlmXTG6COequ3esr891MxGOrv/wYTECLPKgqcGpZyl+Gc6
	YeeKllTx2fWHivNHThalIAne8KmhV4E=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso54777a12.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117565; x=1793722365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H2JU4hnXGHPQ1uce7Tn8xfVvyIR1SgV6yrtF0fmEwuc=;
        b=Zp7PV80Ir3tym5aq8TWIB7m1HRuHK63uB+9qEtTtJBDhQd43IoJG2XfP+s7CwKhWef
         CF3pbltvHU5j90FQcgrN8cUD1Fyi65bkdmmALLJHn1Dr+jlcpAJKdzAOMLddlE+T1ncb
         aabJJUPSnKUN81wMdb+VjIAuUfvNJ4mVnJJHeTf0Ndu145PEiPt5rI1jtXBJixq/ZsQb
         qUl1VdIxwe0cu09VGVgiEH6EXeZ69f8ctvfL/ihdPMpAplIEofyusxU7ninyo0Y2iS43
         YFxURGw1X8yasOxsb2rUWgnq4zUQDFHOtMSm3r6bCaboMd/ohyEeu4sm8/gzNp9s90KW
         +QkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117565; x=1793722365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H2JU4hnXGHPQ1uce7Tn8xfVvyIR1SgV6yrtF0fmEwuc=;
        b=cRoeAiEQ4SdYqwEiDZCoWJIdMFL5RhU1sLcgxUCv6mOnawWr1CObB+JBTTTMEqe55E
         GMRxSYEuGe8cTjIg7QaKDNQ7wN/TdbLHCPYU1tdRLPw3BV8KKyjrpFv2lrF6/LlMEand
         1sH9KXoE2d5BdUswEAyEdaJs+o6bJEyFfE6p+hvDI41+mbmJLnWbJZAz/9JQg7wPjapE
         TTvaW7wOr0bE72CBYnZRiVphBFRbKE5A/GOVgfaMaMghqZKY9a8oXpFR1cSoIfrcx424
         54KVeVbBhSMKkykvr8Hk0Fz7mZTGMo0rtLo6IfH3Ysdzq33vmKncOhkdCgymgTx9Hfen
         NMlQ==
X-Gm-Message-State: AFq9FYL5kCTR1JLc4ravBA9FnAvp5olaABMm4kCMSMDn6AD8TW/Fs8rB
	0t6teoHQ767xmwz1UpiVNT02eqRJ4DSoPylhFUPSi0X7UMxxvLsUnEfasCP1MQ==
X-Gm-Gg: AYBFou0H3f8bfhSlO4l2f9WPeNDhNj+9XbMP+Tlus+VDyurkIUhYnWZoEd2FzApy4yX
	Lk8mjl5YyOKydipdnSR0IPwz3l8CA2srwDcY5Jwd1ikhW1GuK+Wz+DxxpBVP2ter6D1A5FbeucH
	m4/ep01ydrPfhiUiG/Lfoopk8BCpliBvQ6PA7/VPeQxzocB8jRgEmkuRXJGoUMwNcneDxetbdz8
	lyb/kDJC3M+UrJjs3uW1ejG6MABqKVEu8eqAw/o44z0Npjt/u6t5f8sC5zsCPEYNd8dkokaFJ8Q
	5icxYkR8D4l+y8BKdDfVVz6ogYWz91CZ7zm1QBAaswmq7A4M6qZ+ewdEQJghbgiCXu3gzGS4ggP
	p7J+mULeG8XCNie+Lq4OyEWNoHomdyLkW3NsmjrMyG+Zy7Ngsr7bXt5vmd+fGGhgUi043QEVAsR
	PyIyJrx5KuDE90DMyLhzNojOa+AY60e/LkZAUu3F2XraLuq56KT4s8WATmN+/lweYW9Zq72RET0
	qbtUQS2+AoVB3BZhIzOnXuWkTAwhh22wyhFm4I2Y4qG2VGW5qNxYDZTOPML1VLw+wlVbBYQhWkj
	+fQVifCv+VjWyMWzUS0=
X-Received: by 2002:a17:90b:1b0e:b0:3ab:9c73:12f with SMTP id 98e67ed59e1d1-3adeaae626amr8746577a91.24.1793117565124;
        Tue, 27 Oct 2026 09:12:45 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066d631sm4483494a91.17.2026.10.27.09.12.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:12:44 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 15/18] mm/swap: reuse per-CPU queue readers across priority changes
Date: Wed, 28 Oct 2026 00:12:17 +0800
Message-ID: <bea2aebe1693ded274563505d92c48c4b63db46a.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64B7A180003
X-Stat-Signature: khtjfkatih96g9uy4f79bjsceq85h68i
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117566-662741
X-HE-Meta: U2FsdGVkX1/bxidhWzPeZZQtuPmxwv2APH8mP9xJWZnIjru+1Q/nMAf1bxT5sIZVluUMVf5jOi5ole7W66jRDwpJqkP/iBWsbvunT9fHmPN7Or7U8ihYPkQVKPyS58tKRiu7hFVgg6AaU5S7f/Y6cgUeOR+btGK+rjYcuZ74ntNBBdrPAiq0dcpK+5Sb+AzzQRV4jeG2QjjwwSatJUwPEvLT1LZ5ODhnlftA3zhUyQicDnye59gBLrWXFIfaoVU1hdvAHV3MgJ0sEOO7uPv3jET5R6NOWfa/gdQR24MRBIUzDDJQ9k8noKz8Ctrix03DzQUoTK+minmJ0QK/c00uP1q/DsfIlf0FUhwlMf6jwavysTH5Pd1SWpjoO/MBfZu0dXsAoNyR9bmzjFPepCcPEcGNd6P4CW8bpVLzaI32Qv4hqH9nvX7dOjfSHVUH6qSULjQtvq/H0q5Sg7VFKaQKnEdm8Fj2MEJN/IEgNUhGKHxgtuaWlhLcOXlv4mvIwaZ3qLJpGI0HrFDsTYMU0JPQhOTuFMEwR7VO9jbSfnfJqi2EVvvXWPZXxA2b9LlVbjPS2YaYKOKLXGh1EptYEAzBXT2Vg73PqESCmzkWHlnxnTzvEcTtW7Cyl/IsKAXCVGjImzO72aqxf38Cmtd+omwhsLpsJaVN/gExslFFLDOML6yQF8mBM4qInJ8FaxcWm6p7vA5Z1dovOEItY/lQTYjYboc0A2/BPzA8iPKtJU8NiChqOyFQLJWZ4mbJUd0OJaXxqNzB00Q6vjsZVt/cKGR3//ygls7XbCd9dehS8l7ebf6ICvEngNT4WvzVaLbaGQQuzD+CYL3gtMonV8nrb+auuiqmj5dzU7rTKKn4DTLY3yKSwbEUfR2tMNsVNGiRd6GtwTm7M0yUwuKpb/JBR0C+J2+yKau9GNmlSdSuvOrpACKLplgDIqbLNUHT1NjvtVD5e90hVAp2NK3S7Vx/5uA
 TaVe+3TG
 hzoV4kDoyeMvJDbjBzWs+PNAM5ygt5wJ4wcjgQNkFhHFXYFlyL9YNigIvzTQmKYuJ/12y3OshWvxSXJBp7T2zGthxLVm5PbC1EszH25tt/9qY3uJhiXBHk/3P9Fkm/gYsiBkvbPkK5BO7GFwwxpA+AlJhA6Lt9lG1pNhbpAHXusWwu2iXT2U4KtKz7WmDbIfLdhhwLvs68WqLbEdc7USL+DRS+a3sgC1xPDS0J4lwy9KuJDhsZbABKkp6SxBqTC1TNKP0zxue4peaVMcOzyfbOw4wCrNS9yDxYa6XjSTqE5WCNzU9xBeG1mjJACHoSURZnVTOLscD8YIqLw/n/6gIEQ/mCFYRhZaDVApSXnOOXtwL4xrD/cMAFx4RqCvLs7xkdzrNrAxnffEmxUpgFT0OI3MedwUgo5kzn0axsLHzdRFj3E8NxgmMIVIN6Bud6bMzgmY4cteNxW8EijApl+w5E9VTgO6GlMxJ/CzlSoCj2vNrAKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Inserting a new priority allocates a replacement per-CPU reader array
even when earlier ring removal left enough storage. An unnecessary
allocation can add swapon work or fail despite sufficient capacity.

Track the installed reader capacity and retain its high-water mark
until the queue becomes empty. Reuse existing storage when the new ring
fits, initializing every valid ring index for the new topology. Prepare
larger storage outside the writer only when growth is required and
recheck capacity under the writer before publishing.

Preserve the existing prepare/install ownership and failure rollback
protocol. Device removal continues to avoid per-CPU shrinking allocation
under the writer.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7b3520ce1e41..5b6492b1bdc6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -201,6 +201,8 @@ struct swap_queue_cursor {
 };
 
 static __percpu struct swap_queue_reader *swap_queue_readers;
+/* Keep the high-water capacity until the last priority ring is removed. */
+static unsigned int swap_queue_readers_capacity;
 
 static inline bool swap_device_masked(struct swap_info_struct *si)
 {
@@ -240,7 +242,7 @@ static bool swap_queue_needs_readers(int prio)
 			return false;
 	}
 
-	return true;
+	return swap_queue_len >= swap_queue_readers_capacity;
 }
 
 /*
@@ -288,13 +290,15 @@ static void swap_queue_reset_readers(void)
 	}
 }
 
-static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers)
+static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers,
+				       unsigned int capacity)
 {
 	int cpu;
 
 	lockdep_assert_held_write(&swapon_rwsem);
 	free_percpu(swap_queue_readers);
 	swap_queue_readers = readers;
+	swap_queue_readers_capacity = capacity;
 	if (!readers)
 		return;
 
@@ -431,7 +435,8 @@ static int swap_queue_add(struct swap_info_struct *si,
 	}
 
 	/* No ring at this priority: insert a new one at pos. */
-	if (!*readers || nr_readers <= swap_queue_len)
+	if (swap_queue_len >= swap_queue_readers_capacity &&
+	    (!*readers || nr_readers <= swap_queue_len))
 		goto failed;
 	new_queue = kmalloc_array(swap_queue_len + 1, sizeof(*swap_queue), gfp);
 	if (!new_queue)
@@ -459,8 +464,12 @@ static int swap_queue_add(struct swap_info_struct *si,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	kfree(old_queue);
 
-	swap_queue_install_readers(*readers);
-	*readers = NULL;
+	if (swap_queue_len > swap_queue_readers_capacity) {
+		swap_queue_install_readers(*readers, nr_readers);
+		*readers = NULL;
+	} else {
+		swap_queue_reset_readers();
+	}
 	return 0;
 
 add_to_ring:
@@ -503,10 +512,9 @@ static void swap_queue_del(struct swap_info_struct *si)
 	}
 
 	/*
-	 * Shrinking the small topology arrays is optional. Keep reader storage
-	 * until a new priority is inserted or the queue is empty: per-CPU
-	 * allocation must not run under this writer's noreclaim scope, which
-	 * can grant backing pages reserve access.
+	 * Shrinking the small topology arrays is optional. Keep reader capacity
+	 * until the queue is empty: per-CPU allocation must not run under this
+	 * writer's noreclaim scope, which can grant backing pages reserve access.
 	 */
 	gfp = GFP_NOIO | __GFP_HIGH | __GFP_NOMEMALLOC;
 	noreclaim_flag = memalloc_noreclaim_save();
@@ -549,7 +557,7 @@ static void swap_queue_del(struct swap_info_struct *si)
 			swap_queue = NULL;
 		}
 		if (!swap_queue_len)
-			swap_queue_install_readers(NULL);
+			swap_queue_install_readers(NULL, 0);
 	}
 	spin_unlock(&swap_queue_update_lock);
 

