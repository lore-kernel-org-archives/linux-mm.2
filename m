Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECEFECD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A04F6B0099; Fri,  5 Jun 2026 17:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352D16B009B; Fri,  5 Jun 2026 17:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2402C6B009D; Fri,  5 Jun 2026 17:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCB16B0099
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB38F1C1427
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:28 +0000 (UTC)
X-FDA: 84847125216.16.BD22830
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 243DA40004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GlaoaYjy;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JknNzkAaj+qc6G+hjBE1CQp9oF9WvErr7R4W+FLnrFQ=;
	b=l49galNayUwEW5R//CcJL4R/iF+SZtt9pIiUTV0n78d2RJ+YkBncBf+4tLuKnT8r82rQIc
	UvJhXsgFeGi+4Kg49jdyL2NPpfWssoEVABRpHK295WMDbA1loyF8rxooMJdK+/KxnmZ2+N
	mLdVdtTTgLQWreRk/BF/Wbd1ZObP0Dk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GlaoaYjy;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694367;
	b=XPOiWW9hTIoNDL3PqK6HrUpWoeWO0s2oOOvMZWdUXoo1mXKYi6S7h0NgGGyWDV0LCFmy6d
	MV6uofT55lApsnOlGzEU+yEFWMYI8rfTkgu1OEjatAKTgCXvBzJG37ZWs7SPbWSfGPyd9d
	X0GvsCtYRCYGRURrinbYb42BGIVpY30=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ccdf8d4ac5so26223446d6.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694366; x=1781299166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JknNzkAaj+qc6G+hjBE1CQp9oF9WvErr7R4W+FLnrFQ=;
        b=GlaoaYjyhbpPFHMYJB1RHiUEWKozctqSiQQx6Nx6rsuPRVwr5R6ror8k8lDU+HqIpQ
         5OD7zF/15cOR1VYHjo3SQd5TmoEiQ5brCKtSFeuTN3A8pS6d6lJCKYDfrG6UMwYw7Ldc
         P8S5ntLA03YmqmJkqptE9wQz28Fto0lioum5dRGJmyHMaCeYEGnbTn71Kczz+sZVlnYa
         RVLYk732AgxTfP/zv7chP3CUQPmma6ukbNNSRXIP1HUx7YiX6Sx0PtKNXwq9i7H8Uncs
         B40KrIlg2eovVLmYxpknBlfRY2Jj/ymkqL3gEUDIt1/dkew6t0wdNGOlkNJdnMWV401A
         2yvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694366; x=1781299166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JknNzkAaj+qc6G+hjBE1CQp9oF9WvErr7R4W+FLnrFQ=;
        b=m/HbpEpZ69hnZlrDX0V+TQNamARmV3qnKEGZiGPnOx2z79P7KX9hSdaoOqtfRWI/Ol
         ThDiIoLgC9lS9i6UVmnJxD9UfzWCDGQRVm5qXpBoWc8u/AyETsoiznE9RJh76vDlLzak
         qSLvz1s7lod6DMoRiLNNSP3S1h+ypaIL8jmGSYmLtXBuJj7l7rbPAZOjHQqNBmwzI64U
         TcMBBEsEG6gQfX/nyAGBqK1h+EN+4sCr7OvUysahvmXfgjXb3kqNC5pCtXH6coEOPP+R
         y5s712CBdOXLhLBctnJ4vpcbdQGhWYQ1jPQJStzXI/FhSzXfQ4JlL6Vvf+NPhCsE00g+
         0/Cg==
X-Gm-Message-State: AOJu0YwSmazbKRwoM3h8bmVu9ZJOgbYg8okT7xToc5gsH+xVd3CXsEXr
	4KWiM4u1DnuAKHmK0bl6V6G+ovL+/qv6eoq0yDw4zMe7xZUHpkPKparVkhT++KUGUj/K8R/ueRr
	HzOBBenEHBw==
X-Gm-Gg: Acq92OG9dq61wnR82ZgKF3UObiqnRMlZ54iBU5oO/DHyAkzXVXY3pTIsYu2Fe1+4pKB
	CnZOmB+B8Q1c8fzYOL0l1FndhA7J9IBiGYNKbv02aSsK2IgOVc/AVRmSw15wgBhHe3T02jGTUOB
	UqAfR1Ng4Uby9ZDUnAEJ2SJQRr4MgSkdUBurEhyPaZ2P6eSY7zX1tFkgDoCTPFUVrhpyt1RKhRT
	asIDdEDNY6R8dVsa4MhjCv6QMy7+ex8Z8bigKdgumbrkugoakzH7VbOGTIA+g94QA5uEXOe6i4K
	KPeCXcc5dKOsTmUsV72aFepuQQKjgQCWc9O0Ob3tFHiC/zCtMtAtKoUoW+B471KBkAkJcYGebyh
	wAgPic3wcT0vRnd+hFpVwDJmJA/I0tph68HTocqBVhZ7X+bCmC7mmIzAMLY8q2SrYY/AIi4fsus
	Ktri5xuKqKbmOuJazussLKdH1cBR2Zoe5cF13SsWo1C5OiTWrJR+aBh4LgBiLpX7//mUrGYxfPg
	q/5xhKrOuvGalrmwrbA1jw=
X-Received: by 2002:a05:6214:4ed0:b0:8cc:dd20:7a46 with SMTP id 6a1803df08f44-8cee6137878mr86899206d6.37.1780694366285;
        Fri, 05 Jun 2026 14:19:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:25 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 5/9] mm/memory_hotplug: add multi-range hotunplug
Date: Fri,  5 Jun 2026 22:19:07 +0100
Message-ID: <20260605211911.2160954-6-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 243DA40004
X-Stat-Signature: gss9kytrmuhgy34fyhexew31t6y88ecw
X-Rspam-User: 
X-HE-Tag: 1780694366-508432
X-HE-Meta: U2FsdGVkX18D2MQnijFc1LuMDfBcmxr8KxWOakJdzEFeZpqqvOx1U7rCc1aqQpgmkKeopX1Z/MaLK2AaQH5272FzyFpl7mK/dN2mFWtc+qYwOvG2PMEEV5CklPr1phOn/22/mqiAxUV2tuEfb/3ziqEqLOH3uZegDN4kMg5+n3F+cjZ5uQiv6NGsNNLSXuF2+F0N1Ibwgll5RFLY66+499s67u9j0T8H6wupRuQpHz7RmL9QTV65dl4bsfRsQOKal2nY/hNUSj16mQzeB4sdRTehVSiGlL8L1E9+RWI01F9wSyt0D1wGa8ywlGuaAf5meiQcsVqi5lL+cCc2RmzmWfYIr0xfe9hyEMIfsjxlPq9yfFSXubLfN9KArTy7kNyXRoyxkVSYv5vHSO6SXpLQYO064i/1YKsalZkUOHCxtfEIsEzY8Mf57BrwGftF0UmSl1BcUBQKa99PzepuevKCdAjN57RRLJ1moL9lVqaDqzjQIuAFm9Xd3OXjbHFO7hHE6fl4mfvJ/sArUDBVY+rer9X9vUbgjxnTc0tXkisjyrrp9i+yrjfGsGOS6TjiNgzj63UW31ydvyh5qbO8933dyR9bjtszGvWTy56M/ZakgXLoxJ31adOq7PXT2U1Gd6RR+GT+j5UMn+npO6eljri2TCUhsCMstkICmMxOfSylJjduOpBW3/v/FQNZeHgKAl+4VKqKX58V36ID+mJF5maRtNU+eg/qCE+1NpR+ZSyOgC5N2dCTAe+jMUxjfCnl1FDmBfGxNPxSc9fPc+ythm3MhbBePX8B3uD/xTDoW7Z5WqPo+kOtFo6074N8HGSJXwPMgHn981ur/5DKmKK5DNUaFf/lFaznyY/0bXXPlDbCdLyVPezDUVWzJvH1ySHw/RB/U0S+PHdYez34iOnIDK8+pKxEZamkmh72uvnlHYRjaEsX29oc0bdLQ159Z39PGRmt8FVlkIvjFg6esIINvW8
 15QSS8KL
 BprBWxnOddW8RdcP+rt9xM8l6yydlaK8/feT4SiMeJWCYyqthDaJvErCEOTuBoQ3AJ98cBlyvmm6VFKkzfI+BjcUATK/h5WeuBUlVzHd/0EvnZWrz/ZePgR1o0F8/SGyQepunkyBdVtaVkf7AKXq+UY/8z0QArP+pawNfk6HPxnbrNjBBeaB9ELRUVaURd3O5MaylfNYsOBiSwGMF64MUZTMRUJ1LQUJVPbBKRFO1NUz4WoCVryrmH0cPuQPgLGgWS72DKo1Zqc3GiRh5pojqKsd8+sq7uxIqbx5c/cY9QD6/ZPWzSVP5v2MVkjTyiUabPbzFruiqWa/JU9vncZNUbubrSDqiJYTKqXsDNUTpk15aJXTWusMdoebbVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

offline_and_remove_memory() handles a single contiguous range.

Callers that manage a device composed of several ranges (e.g. dax/kmem)
currently have to call it in a loop, which gives up atomicity.

This creates a race condition where another daemon can online a block
that was just offlined while other blocks are being offlined, causing
the eventual (original) unplug operation to fail.

Add offline_and_remove_memory_ranges(), which takes an array of ranges
and processes them as one operation under a single lock_device_hotplug():

  - Phase 1 offlines every block of every range, remembering each block's
    previous online type.
  - Phase 2 removes the ranges only once all of them are offline.
  - If any offline fails, the offlining done so far is reverted and
    nothing is removed.

This gives callers all-or-nothing semantics for the offline step, so a
failed or interrupted unplug leaves every range online as before rather
than in an inconsistent partially-removed state.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  7 +++
 mm/memory_hotplug.c            | 95 ++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d3edeb80aadb..7f1da7c428dc 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -267,6 +267,7 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -283,6 +284,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_memory_ranges(const struct range *ranges,
+						   int nr_ranges)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7d145217adc6..e486d35c22b2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2483,4 +2483,99 @@ int offline_and_remove_memory(u64 start, u64 size)
 	return rc;
 }
 EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+
+/**
+ * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
+ * @ranges: array of physical address ranges to offline and remove
+ * @nr_ranges: number of entries in @ranges
+ *
+ * Offline and remove several memory ranges as one operation, serialized
+ * against other hotplug operations by a single lock_device_hotplug().
+ *
+ * Unlike calling offline_and_remove_memory() in a loop, this offlines *all*
+ * ranges before removing any of them.  If offlining any range fails, the
+ * offlining of the ranges processed so far is reverted and nothing is
+ * removed, leaving every range online as it was before the call.  This gives
+ * callers all-or-nothing semantics for the offline step, so a failed unplug
+ * does not leave a device split between online and removed ranges.
+ *
+ * Each range must be memory-block aligned in start and size.
+ *
+ * Return: 0 on success, negative errno otherwise.  On failure no range has
+ * been removed.
+ */
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
+{
+	unsigned long mb_total = 0;
+	uint8_t *online_types, *tmp;
+	int i, rc = 0;
+
+	if (!ranges || nr_ranges <= 0)
+		return -EINVAL;
+
+	for (i = 0; i < nr_ranges; i++) {
+		u64 start = ranges[i].start;
+		u64 size = range_len(&ranges[i]);
+
+		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+			return -EINVAL;
+		mb_total += size / memory_block_size_bytes();
+	}
+
+	/*
+	 * Remember the old online type of every memory block across all ranges,
+	 * so we can revert if offlining a later block fails.  All entries start
+	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
+	 */
+	online_types = kmalloc_array(mb_total, sizeof(*online_types),
+				     GFP_KERNEL);
+	if (!online_types)
+		return -ENOMEM;
+	memset(online_types, MMOP_OFFLINE, mb_total);
+
+	lock_device_hotplug();
+
+	/* Phase 1: offline every block in every range. */
+	tmp = online_types;
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
+		if (rc)
+			break;
+	}
+
+	/*
+	 * Phase 2: only once everything is offline, remove it.  This cannot
+	 * fail as the memory can no longer be onlined in the meantime.
+	 */
+	if (!rc) {
+		for (i = 0; i < nr_ranges; i++) {
+			rc = try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i]));
+			if (rc) {
+				pr_err("%s: Failed to remove memory: %d",
+				       __func__, rc);
+				break;
+			}
+		}
+	}
+
+	/*
+	 * Roll back the offlining if anything failed.  Blocks we never offlined
+	 * are marked MMOP_OFFLINE and skipped by try_reonline_memory_block().
+	 */
+	if (rc) {
+		tmp = online_types;
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
+	}
+	unlock_device_hotplug();
+
+	kfree(online_types);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.54.0


