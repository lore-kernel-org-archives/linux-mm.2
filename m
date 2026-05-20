Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BDCCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3E76B0005; Wed, 20 May 2026 00:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BFC6B0088; Wed, 20 May 2026 00:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8A86B008A; Wed, 20 May 2026 00:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9946B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:32:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA4E9A00FF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:32:13 +0000 (UTC)
X-FDA: 84786526146.21.A19DC53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BCB6B40006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:32:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/RBw962";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+olvaffe.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+olvaffe.gmail.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779251531;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bXVP20ihQtvhiwXVHyH1RPdIxOk0yKXC5SL/bCtAp/I=;
	b=K3tC7lQtj7DySDJGhJsw2Z44A6sjQUCLAC6ifYrpruwyQxAenxNVsY+2mVqs68kDa9kbzL
	24ZK0IpsRFbaq4k3HBAgIZRapiGD3Z6xyf/hbnTS9tp1SQSEqVAZ3TX+InrzVYFxrENy+P
	UROYYBS3qH6bOIMcpLbd5cpogAPGMtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779251531; a=rsa-sha256;
	cv=none;
	b=sFcSKiDRO0lkiDy8n6rhwPUtxE8CrcsE20/hkyv4lft2vGnQ19IeG0Qj9X2NQdRCbVX4qL
	VkmtkHadHXEtBhEXZx1w5YTD0vhqwO1Ln4H9rD8/tWZ0cEd2KuzsmsZDyGw1yVrrUTj/6L
	spOT49sU8EBZptq58BnvG2d48z+93M0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/RBw962";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+olvaffe.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+olvaffe.gmail.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFB6B40C42;
	Wed, 20 May 2026 04:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FDE4C2BCB0;
	Wed, 20 May 2026 04:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779251530;
	bh=Wjty/wduvl+Pn1BhKceunURL0fJv0U/D5IHxoAv4Rt0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=A/RBw962Jj2myKHrueoXlYdEa9WDZDlmr/h0rk+Lsx3ZSWoBaRkPkMS3yaKYnf16u
	 G4hFe7T4bI8jGdF63H5tfDXX1TjBCXrk5qIdzLzfuCt7KWf1op8ES4LE34li1uX9ac
	 WIC4YydmL8NDvcm6Z4+Jed6dA8inrKex6/HI/QzdKoVi2KAP6w6woUMaVvmF+uP60X
	 XHbnSnQdlFU8FC5ccS5GK1tj1FF98jJ+zw1j0TGhQXbO9fIAjTlE9IJa02/Pf4LdsH
	 Cnyin0BoS8XhSjnokKak4CbAkUlAVMXXS8BraPWjf0rPt+ud1e6qDdSqz4jll58dzz
	 FTksN55K48AHQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94771CD4F5E;
	Wed, 20 May 2026 04:32:10 +0000 (UTC)
From: Chia-I Wu via B4 Relay <devnull+olvaffe.gmail.com@kernel.org>
Date: Tue, 19 May 2026 21:31:46 -0700
Subject: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for
 swap_cluster_readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
X-B4-Tracking: v=1; b=H4sIADE5DWoC/3WNwQ6CMBBEf4Xs2Rq2iFVPJiZ+gFfDodAVVqUlL
 RIN6b8LePY4kzdvRgjkmQIckhE8DRzY2SnIVQJVo21Ngs2UQaZym+YoRadt3zgvHjpoKzDdKCW
 zfakNwrTpPN34vfiucDmfoPiV4VXeqepn04w1HHrnP8vrgAv852BAgcLsTEZS5UZheaxbzc915
 VooYoxfOcyRsMEAAAA=
X-Change-ID: 20260512-panthor-kasan-10477239bad1
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Chia-I Wu <olvaffe@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1682; i=olvaffe@gmail.com;
 h=from:subject:message-id;
 bh=BTF9Nk+Dq+n2u4+GJl/PHmatAgLww9uk/603AjD4oqQ=;
 b=owGbwMvMwCV2uuv6dHcvAWnG02pJDFm8lp4vXjMX63DYH6zfsNFHOsppbc8JFS9DxY9Le/sfM
 L7/lvKmo5SFQYyLQVZMkWWn0uevgRmFl+8IN66DmcPKBDKEgYtTACYSVs3I8CN5rcGd7Bo1GbMP
 j3PDu149qa8q4PfaPDvyv3hNoNv3DEaG128X/zofue3/qnvlgc4pdk+3TCn7nRI0YelNKaaP7Mk
 3mQA=
X-Developer-Key: i=olvaffe@gmail.com; a=openpgp;
 fpr=8C8F791802BBB330399230F27CB6CD58BE1B6831
X-Endpoint-Received: by B4 Relay for olvaffe@gmail.com/default with
 auth_id=776
X-Original-From: Chia-I Wu <olvaffe@gmail.com>
Reply-To: olvaffe@gmail.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCB6B40006
X-Stat-Signature: ob18cnar7t8gb1sxtn11eh51mpxei3t8
X-Rspam-User: 
X-HE-Tag: 1779251531-941647
X-HE-Meta: U2FsdGVkX19toP8k9N3J9RA0wmnj+l1Cz6DXwyK5XpXPRcCUWodsJejRVGnnZR4ThP8wOWUBQ3EmpTN1y771Mf/S8AGx082V9N5eouDvRJ5rt+bnoqflOIIg2zMHHMDOrTZFMMCpYj8vg0JoUVywHPPzHUewRBWU9Vc9FiOBW7LFdm8CLXePyCwfUdF0QLRxphYTorBUL7Kz623WQibYLS9V9AOYJFnFlHnDogrOUAHFQOXZJUfHVB88XnktRbHo7eRWXJQlYrJPZwfvepK2ltNf+45MiBAqMZbhNYuiKGlEYH/iYs4fdrILf+QUaUge5+oXKqDXhbewsc1EMcqdWT/wXu4D2t0d1vXSxNx1novSwOLYDQEt4Xp2TLRGaXYrbbyZExFosZwPreSyYxzNiIZ438IR7XeX5ZELqBkbhqYxz2EKWWRTcy2TDdQv6NudMaFUusrARXkRtBp1qcXKGjppTatsMj+ds7L10YVylNAe+QpdOjAHT2EQ1WWyvZJFt+l7OaVABafYMwgVDpjH/IdT7Qfs//M5jg+bbqO/e5QU0m5YwTJrhO6ByfLDIuzBwYItBpXv6QSA83IAd7/V9yEErQDImdqEODl8JzTvjY+DCbl+ouTY6yIx7M7Uuj7RuJ33llAPueuk0JSGEbH7QCWywnGl6/LZsYRuv74KnjdmMWV888WXURItYfi9EKPF7P3eFl9ui0E/0c2P0ie3VaFjQGVNCcV+7uU7C42cR8vn9XyCiV8XmlZPEics+O34PgYc85YWUv6LkYQXtyPUyeSB5eBA/8/b/BLVUZ8cUd0dPt1Q7csm3rN68QjuzMCowWTXC7GG587KMyCHq3NLc8s9ZqwToYGfhPL95j9/K5rc3tZzzbw2BSpoVye3CxbogiwSyWpgsWpGKigyy2/5Xyk69/sy/Ls5H2cjDzveuwiEVs0cQSZIntNuC25oFOMVZdpt++CEoQCecvtYwx8
 dTp8uFnT
 uv5Xr9ha5NKnqn8xo5ge1I43JBtuS34uOF1WQEJ5W93LS9tLnPfhd4fIfmk+WnpM9GwEvJ4gunEBARPk7333hj+g8On2GN4jKWTejvJkzIiNTVgfuxKsMgU22oawesSsSetJdYxPUbvxb8CDVhDVwBI37KjTDDcEKyKbXMyjTioEX8YT+eXurog+DEQkS4lD2b99byMOTu/bVb2yCnmYGh0Y/H2XkR5ckReyQlKj+WQ23KbmLxW+27BjFs7LfhHWE8qa0UulM/+0w+cHVkVc1dJ9Cp8xKg6nikI/yZOnyVEnGcLP06kwa1mD5yLELEbNyIOhi19IMpSMp0PYP1up39I5T0q2OoXOux565zcb/vUct1bbThXEZF7vIcTsi3Bc73aCOqwL2yH60FT9Nf555HzncGm5C38QU1H+tr1jzy9io6c2ks4ZkrC3sJZJ1TgCrKlpQ9tfSc9xCV4/PRM9kwtjSvW9dbUhi4KoFEwZ0eJmwmYcrPBM1AsVry4X7eAmhEaUr0Af8RosGIywINk6tijeuz4rJygE7ouRAU2g3N2rcO7uUBUCnxk5t+4NRFuHEGaxfwJNNq3DeKQR9DAyvZ3WagLHSZZlf1bk+rlVzxwtt4M7kVB/Xb3LGBaSvJsHiv72r3oHEIAuruIUM1269qybvkVrI2JIBV1Oi2NHDrFkCSQWAZsLtAgn4kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chia-I Wu <olvaffe@gmail.com>

swap_cluster_readahead can allocate folios for other mappings. If the
gfp flags do not have __GFP_SKIP_KASAN, but the other mappings have
PROT_MTE, we can end up with false KASAN errors such as

  BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
  Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
  Pointer tag: [f5], memory tag: [f9]

In the above example, because __GFP_SKIP_KASAN was missing, KASAN set
both pointer tag and memory tag to 0xf5 when swap_cluster_readahead
allocated the folio. But the userspace had already set the memory tag to
0xf9 before swapped out. arch_swap_restore restored the memory tag back
to 0xf9, leading to the mismatch.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
---
Changes in v2:
- set __GFP_SKIP_KASAN for shmem instead of drm/panthor
- Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-1-d8d3e275d71b@gmail.com
---
 mm/shmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c2..db9130a8c5b76 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	pgoff_t ilx;
 	struct folio *folio;
 
+	/* swap_cluster_readahead might cross the mapping boundary and
+	 * allocate pages for other mappings. We have to skip KASAN.
+	 */
+	gfp |= __GFP_SKIP_KASAN;
+
 	mpol = shmem_get_pgoff_policy(info, index, 0, &ilx);
 	folio = swap_cluster_readahead(swap, gfp, mpol, ilx);
 	mpol_cond_put(mpol);

---
base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
change-id: 20260512-panthor-kasan-10477239bad1

Best regards,
--  
Chia-I Wu <olvaffe@gmail.com>



