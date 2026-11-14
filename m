Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697F7606A333
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=KSHm3q3f
Received: by kanga.kvack.org (Postfix)
	id AB2186B05B6; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63966B05B7; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9781C6B05B9; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63C226B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7D25803F6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:17 +0000 (UTC)
X-FDA: 85434304914.21.4CA14BE
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf03.hostedemail.com (Postfix) with ESMTP id 43E2C20004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=KSHm3q3f;
	spf=pass (imf03.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674836;
	b=UEsKZo0gfoMJrLV35xcybVzoQg8zL5/m2fJCUPEyCGz9jk4norq8yxQMLJSdNQn0I2oN4r
	B3Vm9HJhZ5JQiZNLypCHcKYdctPEw3iSs4pSPxzS9Yp/H4OfOamUypAVmiCPv0MQf96e3z
	aC5Wo3yODYCVtQG+zQOTuTH2uyvjOlk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=KSHm3q3f;
	spf=pass (imf03.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=REi7QiYPl7c6P19kM5QAhrR/RLv2O8VPnLsUnTbts/Q=;
	b=cySfgkETzM4jfbfaM5v9haSo0RZ86whPWIVpQa8jOpkx8a87Y6q84RwTAvO/lYrmIPW+fo
	HpE66DlvGMqtt/B1GjdNHSDpz/o394FzTgz6PWjYBPhCoMgIXtiLNXizBKhwmP+CbclcDu
	1F81ZtZRkTO6Q3pcRLhuYwj2+ojemJQ=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jRg5Q1jMzz4xPSr;
	Sun, 15 Nov 2026 00:47:06 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674826;
	bh=Kv5hM57oYSpwy9YfyoUCbxe7s7mgHIuA1qm7uHUVv/o=;
	h=Date:From:To:Cc:Subject;
	b=KSHm3q3fhTWqgM6niPlx6MTDaHpTB1yGTIrZT2EpzWRcmUz1ZywtiTBMBnodEt7YB
	 Wt69FUYnegYpLZmDBHD4yDWjiQm28HSEcR6znOMbSCJyuFyDyvEVs9aVlYZRbaWdT9
	 NvbIahTQNdU0nFj+nzsvZU74YO2uDzQnMyid1M5AhV9f9imnpPzRxf902GAj8higZ/
	 d+a9BdsMF5gS+GDLWGLJckpPsm01/98QOCmsi8HomXR2kJVEBZqbLdZZqnq6JY10Ya
	 1TCnS98YMQJ7/wyUmgeJBSXzCVBUFXigMlSqzpxhnzS/P6rB/x6w0UXDNyRX80zeSL
	 LgiBXMhDjy5uw==
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6AEGl2tZ089762;
	Sun, 15 Nov 2026 00:47:02 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:47:06 +0800 (CST)
X-Zmail-TransId: 2afc6af8908aa47-30a17
X-Mailer: Zmail v1.0
Message-ID: <20261115004706741mYrBkIRqmj_IWsv3oh1uZ@zte.com.cn>
Date: Sun, 15 Nov 2026 00:47:06 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <rppt@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9udW1hX2VtdWxhdGlvbjogdXNlIHRoZSByZWFsIG5vZGUgaWQgZm9yIGxlZnRvdmVyIG5vZGVz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AEGl2tZ089762
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 15 Nov 2026 00:47:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF8908A.000/4jRg5Q1jMzz4xPSr
X-Stat-Signature: ekfixp1ghm6p1ujko9m4jp1ardscqpfn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43E2C20004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794674835-462266
X-HE-Meta: U2FsdGVkX186SZpT5c7fSS8BJ5Lg0GfI3ARS0YByP9p0nUteprpt9NG1xOZT3ZRDDeFLLjjo4LmloZgIBY/Kp8/fUepatK2B9abYWbl1sumwjLKirFccZg058cw8h62iTMtSQwm/axetl+iHSWM0vw3VGaiwx8E6WfltJoA58JvG/yOdkMeCj/TC6HN+OKW4h0Z7Btw/XtGkuAK5JjvcvPjOQrKc9tPIouc+NIDuVdwBmutZ31sGF5/ARA/woO0uKVjtvpqvnYlROXOhTH/VfayWKis+PL4Ezm+9p8HEnAkrygTFyjwfozTVmQs3/8e0LcJCRe05F0OkVVsVbmaNwC5Ljph1tSLfu6AAm8Z4l5UJPW5Ttb1jSUAEwaT7qR2Gc1nl31sC18Lpw7R11O3nHx8QFT6jw6ZDQNBqoWULuiHMCqo/lTKXExnv2dDC0TKx/HwNKKDuz8GFygVW/X6WKwWa1xxlHu0cVs1OyJh4YjhsVEIKhtF6/nHCEUXotpP7qaGDdO17AGkM9m3Pg2gBEb3743b/ZM4z9OJw5djAOkbhqDQUXQTWe9EGcOCAfzOdbS2yk/HbaaElQqa1a6AJZr1ABMDJ2ry71oQgU4aU6mzp/vtEb4iU9quH1M8JalGiKH70xeex1OM1UgK/BteJqQ8R2UKNvwyv/Tq0/YsLVu4hWMkTg/m8b2Kzt8yNtGG2S+jlkVIyqWPTQMdRPksaTSBH+k2HM0qXizC/7iv9dKtbk/w1dFxhUQvmqVjAh+MRYWvtQP062BNU1XhdlMJ/0oTQJ2fHyWGLb0si62sW+r8dwofyrJHg1rSWAO5hMqkzvXilWz2aSWghSa0ulFOeCK1m3euUtYRbfGouBpM2AmFCYrTbmexXrGMcijnPRZTBgSd9Mm44t6Bwm8OGyzmNu5Jj+Jn3SaOvXUS1Tq+RiwcAAH7GPJS3Bf6PG4D6veFl7O3nBPN0pReKzr30zg3
 DjxjCd94
 FBCduGSCVLvamaSogJdWn0BdCYDfGNUr5io8AWFajaZEykJiVEvJe6vMqQl8xm3WJ5smUHtq+spZyxvaU3blpiI3fYW9t0fA6JaIfRG+4IdUISSeOrPLiDPvBoX2qoD2ZTEERyln1LxFjcQkjZivi0gas5qfnSFQemKgqChiM06rQN1pQBRtVUJ74rYkejxhHAlkRVNuGiVimwJJhlujwYQxpBKGn08HLxVEjiyrsNQEes+SlF5D5lKSKw+kA2kJs2g4KJ5yH6/tU5/TVHWxZ8Eg9hoclR4IVt3SwrHy1Ll9MgJDf7q2LDC0Kq0Yyv7HAo528Ke/ZmFSHk0iYaRmzWImfGplVNwIsG0AbQutuvjWioGDj8JdkDJzGcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/numa_emulation: use the real node id for leftover nodes

After assigning fake nodes, fix_pxm_node_maps() gives the remaining
physical nodes free slots in the emulated node space. The second
distance loop in numa_emulation() derives their physical node IDs by
subtracting max_emu_nid from those slots. The slot assignment does not
guarantee that this yields the original physical IDs.

For example, with fake nodes 0 and 1 mapped to physical nodes 0 and 1,
a remaining physical node 2 assigned slot 2 is read as physical node 1.
The wrong row of the physical distance table is then installed.

Record the physical ID when assigning each remaining node's slot and
use that mapping in the distance loop. Keep the first loop's fake-node
distances, and check the physical IDs before indexing the copied table.

Fixes: 63db8170bf34 ("mm/fake-numa: allow later numa node hotplug")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/numa_emulation.o and drivers/acpi/numa/srat.o with W=1
and CONFIG_NUMA_EMU=y on x86_64. A C harness using the actual mapping
function and distance-loop excerpts reports physical node 2 to node 0
as 24 before the fix and the expected 27 after it.
The tables and topology were synthetic; no NUMA guest boot was run.


 drivers/acpi/numa/srat.c |  2 ++
 mm/numa_emulation.c      | 24 ++++++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index f5616830f5a9755868779a76a859134671de0178..798aba14cc6e649420644c84797ad0f2dd0751ec 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -154,6 +154,8 @@ int __init fix_pxm_node_maps(int max_nid)
 			    "Number of nodes exceeds MAX_NUMNODES\n"))
 				return -1;
 			node_to_pxm_map_copy[j] = node_to_pxm_map[i];
+			/* remember the real node id for emulation distance setup */
+			emu_nid_to_phys[j] = i;
 			node_set(j, nodes_to_enable);
 			count++;
 		}
diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 55f26b22bb0be25fff4a29e2d282e7d4459b3e0c..f2321666ed42dc3b765e5eeacaaad8e96974d5c8 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -525,18 +525,22 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 			u8 dist;
 
 			/* distance between fake nodes is already ok */
-			if (emu_nid_to_phys[i] != NUMA_NO_NODE &&
-			    emu_nid_to_phys[j] != NUMA_NO_NODE)
+			if (i <= max_emu_nid && j <= max_emu_nid)
 				continue;
-			if (emu_nid_to_phys[i] != NUMA_NO_NODE)
-				physi = emu_nid_to_phys[i];
-			else
-				physi = i - max_emu_nid;
-			if (emu_nid_to_phys[j] != NUMA_NO_NODE)
-				physj = emu_nid_to_phys[j];
+			/*
+			 * For real nodes fix_pxm_node_maps() has recorded the
+			 * physical node id in emu_nid_to_phys[], so use it
+			 * instead of deriving a bogus id from the slot.
+			 */
+			physi = emu_nid_to_phys[i];
+			physj = emu_nid_to_phys[j];
+			if (physi >= numa_dist_cnt || physi < 0 ||
+			    physj >= numa_dist_cnt || physj < 0)
+				dist = physi == physj ?
+					LOCAL_DISTANCE : REMOTE_DISTANCE;
 			else
-				physj = j - max_emu_nid;
-			dist = phys_dist[physi * numa_dist_cnt + physj];
+				dist = phys_dist[physi * numa_dist_cnt + physj];
+
 			numa_set_distance(i, j, dist);
 		}
 	}

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

