Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB07606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgub/jGu
Received: by kanga.kvack.org (Postfix)
	id 6DD596B0ACD; Wed, 25 Nov 2026 16:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4A86B0ACF; Wed, 25 Nov 2026 16:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CD96B0AD0; Wed, 25 Nov 2026 16:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32E786B0ACD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:38:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFB141A0142
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:11 +0000 (UTC)
X-FDA: 85474954782.01.7DE1896
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05BB340009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bgub/jGu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642690;
	b=063xByMRpsMaXxU55/48pYrE2FIL2bvKrlAJBO2++sh8SemxfcIu860g8zolQdBWIwtZ5U
	50gpTSukX30BjDQv30w6L8/tDpf9FPGm2Q/x44/7a2yQ10LclhR4h4yw+eOFtmQtB68ntK
	EmksoRtrD/lDOGLaJaoLL1Weg2KjpeY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCsoMM2SYli9GoRF0mLPGTdzPc1rzk/bVTpp4cBDCP4=;
	b=zSTM3eUsbmvSqR+Ce0h8ty9bgr8fo8gNtmi1YD75BikVJFlGZZl3quAg0Oa31uS7Jzppug
	GVt8uOEb20VqhCC/9B5PtDL/O76NE8+yr+zTj3TxI4S5Q8E95iqObNsnfnYIU3GmqrQBUj
	Nq/dK5PqDRHJLtgd6d+pJqC9grgEew8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bgub/jGu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61B8D41238;
	Wed, 25 Nov 2026 21:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB31F00A01;
	Wed, 25 Nov 2026 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642688;
	bh=xCsoMM2SYli9GoRF0mLPGTdzPc1rzk/bVTpp4cBDCP4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bgub/jGuSEEzlxOWoTN7Ri1uIOUtEnJPzRZ7jyIAu/Ja9fIAdurhc8RTtdT1s+Cu8
	 rKWwPTC3yFW1CmOupwJi1qUMhA1LnLYi94769K29JPagk7GVbdXviTD2ZD5NZyLVbu
	 hrJXLTjlWhzAH9rUFY5yKCQ7OPf5lglAy/d7JRIBKJjUXCIK9CQGFNwpXFAa4crnjE
	 P3+WDFuxzA2FpXgHO/xwdjxoY+/ViEg6k6KF/4l4z70Bt0yFXuheeXEo5KwewFCs3S
	 YzL7SGRJglCp8vhbDDPAxIVK/YBg+YuEbDqUfSU4CtgnuZ+Koj59Y3kZGjZbISaO+N
	 2cbb3QvteIhvg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:03 +0000
Subject: [PATCH slab/for-next v2 02/14] lib/maple_tree: specify
 SLAB_MAY_ACCOUNT for maple_node cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-2-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, maple-tree@lists.infradead.org
X-Mailer: b4 0.16.0
X-Stat-Signature: tbcmnkiypx64xk43ermg6y3zcrbq8pts
X-Rspamd-Queue-Id: 05BB340009
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642689-690963
X-HE-Meta: U2FsdGVkX1/co8HPCgJQUWeDB+VBf5r7YMySzGkBMXM+LBSgg+dd7c4MLLvkxRdBClthSS1AUl38xEHDfFI6LOlDcRx2WSIvSDXXQWbQ6Cx1vjML8+IIm80rC9CLLYQi+KuBh0pHzvJC/6KFbwOjl+3kSaTDGiqtU7P3CX1NlLCi5SvxoRtlXu1voIMdWZTOXMEPbn1vpwRpzKp3IKrYP5RKNL852jYf9J1wqGjmsqSuAS+si/2E/pJDRlQTUGvKvdF+UvxAI7YoJYI+ucaazYsjPCw+vHyPOU3Ps8UBqOyyf6DkM5GLlg74zz4kAFghFD957UEWsp2skjJq+9R1Fxy9dVmwcZaWusP+918erYtH874i00A81hAh+e0P6f6D1Blvb8r38ZQTOe1UHOZBCte0V9g34BKoACIczdmUOVDDK/VCACfnalIxxpObs08gPd+9DBNQ5kG1a6lLPx4v6sRIsOLSdUPC4nAFc5KivnPv/VFtfVVaDFa3FDsVjI6HriUjuzBZYsHLQUzp5RV4qMYtH590vgLNWjnyrru2FAVVTBXAJHvs/I8OCc6CYGvrnrlhfGuxmIRnH+XLvFFSkjwrdhVTYhX0Q/YsrU4p6qiEe+nGt3Bvrf47vKNCl7o0AxLsM06Eq8aVfRe9p4izBd96pRY6TFIad66rofAdYT9iBgiQ1jUeTfrcM6IYttNrdDWM4ntThaxr/isf55hdBgZU1C4/S39AXvOuorF0kEosk+A7pp9kIJsXO08CiN8HtBDkTTjIF6eoPaGilYkbL4TIHuba881glwHH2mdCWv8h3XGQFRJMuO2Zp1sQ0iNDEJOIdO6q06wUSchfVC2Mptm8vbhy0TSyqKIDtXcaJoCKCPT6Xnv79/KnIwGdcNCSRbDMcQdaH9DHOaNgIYknMPWRQ6eK0nDTSkD1Rr7e1Z6+fZk6U9F9woMmLTkp6o+2FXAsSme81vwSr3DYuAB
 4y7oYyzk
 +Ax31zMpxm1KlJgMxO9Uwwtc6LNgqon33i2lBbwfXV/rSZUAx17YXp5FSi/NFleWDkQ9sVsFBftBbY8oaqf3kA/867Mp2mx2rwN/w4jC5HPEmFowMQo3W/QFdqqH3ho9riEbMlFXFeg9srYPA/w/NWm4vAbpjaChusRYWKI9Xe/x6E4NxMOdLfx5UYZaJPYopLta/5zo9cVk6+SMdAtEQYq7TDSx5juDmFakBeoovURXsB6D6budIdXRUYuj7Elo+a7imWF9OOSwmYvuNk2J5JtneWUi0M8henhkogSOAvJqNbGrDDeKrta1QBV/6HFZg8taOYeKDTzZJ/ZD/K3bvzYDoOpam48T28cs29B5pws9+zyemnbq1r9RUmg2nJIykjN8WPjnD2zFjvFiGnyuh/2v0zWxr/VsHC7j1u17MLtSeBTk34rrlS3EzFxZLEYUocPAQF8cvUy2DqVF9f3tf+tfnZskA9DeKpU/b3HvgDVQcJkqZsuNxc9JhNnqQED4G+FPFf69sRDvTZ3jW3eVwm4I8+DX258fqjcPej+OfAxEER4k7vxyZX5slLkr21jfMznHkE0T4ZBny9tpNJDXE85nh6etWZuxDzjeCbw0plq6qMeC5nl0B0FOzQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Maple tree users can pass accounted gfp flags down to node allocations
(e.g. arm64 KVM's smccc_filter uses GFP_KERNEL_ACCOUNT). Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: mtree_insert_range(GFP_KERNEL_ACCOUNT) -> mas_nomem()
  -> mas_alloc_nodes() -> kmem_cache_alloc(maple_node_cache)

Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: maple-tree@lists.infradead.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index f7f51f1b40d9..5ff176f1a021 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5815,7 +5815,7 @@ void __init maple_tree_init(void)
 
 	maple_node_cache = kmem_cache_create("maple_node",
 			sizeof(struct maple_node), &args,
-			SLAB_PANIC);
+			SLAB_PANIC | SLAB_MAY_ACCOUNT);
 }
 
 /**

-- 
2.54.0


