Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE264606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnxwhmZD
Received: by kanga.kvack.org (Postfix)
	id 0C7366B0ADD; Wed, 25 Nov 2026 16:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DBF6B0ADF; Wed, 25 Nov 2026 16:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5986B0AE0; Wed, 25 Nov 2026 16:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D222D6B0ADD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:39:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D2A61A0144
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:32 +0000 (UTC)
X-FDA: 85474958184.15.218B4C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8158214000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnxwhmZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642770;
	b=f/OX6SyneuESGOF2w7/gv/HlN/gmxAQgPUv/IvxCPml2TukyKiO7Do51sz6pz6G9+6h2BD
	WwahIdtkpaJNE/iPoXia2QzTjO8Aat6YZbAZ4E+fNpQ8xVn/M81jNnWb6Gy31q0Oq8Z4kS
	7HX0wNxhIbndUcnCgmX4S1MmxIKxxcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uchKMQEbun1KGuNSoqThhgELpVgiokvVWjr9mK1k/A4=;
	b=B3SWkCuppC+LJ+VdW9gUpa3sIMJFqx3ITkew4VJ/22c4SS+UOcHYdR16DhN8DduH5EO+7G
	/tBxpYaPI22m5kHpf6I72DWMdHBLVtwgLRQ7xZGnZtgPQDWv/wG6Rqgc3sM57gaO7XnW6X
	+5lv/JxUUmGOwuKDqof18ktoFAzLkdY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnxwhmZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C5AB43870;
	Wed, 25 Nov 2026 21:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC941F000EB;
	Wed, 25 Nov 2026 21:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642769;
	bh=uchKMQEbun1KGuNSoqThhgELpVgiokvVWjr9mK1k/A4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cnxwhmZDXM+Gsf0EhyO5VD88+p/C9GrSlfOXwoM8uURHlT5OqfIyp2Rk5t4izPM3P
	 UUx1iGYMBxTWs0cL3dCa2FA04NGRrpI4ftwFOBvtbII2klixx84KhPEvfJOjk+TwJo
	 DFc6Qi1OlbLb6T2cbEG1CRPNtaCZk/R58jMv+IibTCsr8BptHZoUgMiJ2jnJbsExBK
	 Q+MoCouRcesMmoAwbmZrOxAbLuJxUupraT9lUd2s7+j6/4EPjYtXHaUu0/aXvLlyvR
	 SEBhBNJRRsmdB4Q6buLNKRmyi35fpFhzWJhgqoKVgCyvDfHsSFNTIFHNt4CE5+GaCp
	 TsEGvbU9H6XSA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:11 +0000
Subject: [PATCH slab/for-next v2 10/14] fanotify: specify SLAB_MAY_ACCOUNT
 for event caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-10-7c680f02a734@kernel.org>
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
 Eric Dumazet <edumazet@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: qdabhmq9xehy4gs8u34a9shti3mya5zs
X-Rspamd-Queue-Id: 8158214000A
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642770-763997
X-HE-Meta: U2FsdGVkX1+HI5E7j0sP9nWFwjmhKtX+w79zDoN/RP2A5YbZy7dyEFY+aa2w9WnIowMgHEYRXtrWj4k2Kag8JGLAL5Sl0UmS+qFb3sSEmT3T7UdmirEizk1uHJB6wW9FETKD+JGGuawpezdPeKucCofzsjX5ZgexHMCGeAiddS3X0CjPBrOIMnKlbsI6Cal/6nb/Tm8CasrHLkgW2iau9GF4eLyNrJeB4TIAH+y/Un8eGAwUSzmdEDmN53upLMskj09J1K1XcWinmh+HWk30lCfafiRP5aY4yiDbzJCSRcYhN1XlM3TIvpTZzz/trd+YJCQC+GwjNOTMbhYRZ4qG4C07arMLS27gd7np1EZkJj0WNQtjrWXiG5vbolz+omcEmlt/h3XeMf73qZ7xI5a1fnpRB8/JaOnKa+vkrJgexLLo++vAC4ghLHgGEth8klu+7y/1+5fJPFIDnwj3ug+bVvKFaMKjeX7B0kG6GSLu4V8uGznUV/8DSbLJLnjb8VSPCC4sqByx7EbkxQ5H+Hr+v+fMNXPmJP4KwQN/3RYujuiu3nBe4TqMpTUcYWi6Onj9Dfp2pdYEmpxonqGVtlkgBB+Z06g6pQq1XU7yUcdGDOTm12JzchoYBHgWEeG1wJUHHNoMsHnhZKhaiNmLHndqG24KiGqu4CLegwoHBOvMc33yzs9XNElDqSgE7RPJIuVM8myVc5AblT7DyZa4Ya8jxGKSqdseCIyYbe5LGXVVpQNGi5KbLlHYvXMLTkusyTveMo2bnj7cLCUwA3E9pB/ulOw8Oi3Xt5gTYGF51RSBpPjgiaMOFB+P6gtE+7BlYk3zksWZi5mZGuSMnnPKbVg5l7Uig1tt+6cx2ifcgoHoOxxc9MKURjNHix8sDucXcy5XGOAlmWTS09ilNwFKzZuVDKeNUCUNwG8TNrqxN7peLCGbtNxJitiT517C0fA9yg0cxqzcRdObezXM49lVVt+
 tzoXU+1Z
 DSERaNGNBhVZMigyYYyIiTVyEMqF1Slthg2Bdyi3xL6QQY1X7bO8epC3zMZtQu/GMkbvbBDTNAnU4gUEhmcEDVzlnCXrTyCet4oGnIw4kquC7ExqMZf8d39pv8w8BH5sD1S1qnR5ZtjZJjMSlFGQvXDauboLgJhDdWGx0n4+rxftr5LR+XRXAoi1zyZWs8S3ffvoG9xbi+/EIfL90wrJbqtDAb9UVTLXXbJxp3XhQG8zXs7j7d0Q5Aupu4brLah+UibhIEm612F6zdpbjcKDluKJzJAqx9ePUk2IIGYkao+M1+HIQp4XSN7I/3oRMwqyS6XNVwktHOY4vPkTbsVZ9MzJ/T2MTznI7aX/tn48xpJNBgHeYyFTKoOo0uOWohbmXer8Qj/5UinuvBSXV9by3Txx0rf97KED5DZCU84aYyHIF5QyXACCZZpcIXr+9/f5jeCx3PL/iNdRFjzYs2F1Q6sujg/KcKdusT16bFglAaNBH/XY6/Zs1h3arswD6TeNdN1Qo4Us/e0KNunbMqNI8dQXOEOi2qbgaLxUO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fanotify events are allocated with GFP_KERNEL_ACCOUNT and charged to
the memcg of the listener. Specify SLAB_MAY_ACCOUNT when the object
may be charged to a memcg. __GFP_ACCOUNT without SLAB_MAY_ACCOUNT
will not be allowed.

Path: fsnotify() -> fanotify_handle_event()
  -> fanotify_alloc_event(GFP_KERNEL_ACCOUNT)
  -> kmem_cache_alloc(fanotify_{fid,path,perm,mnt}_event_cachep)

Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 63c9759fc3b0..3575c681abc1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -2184,14 +2184,16 @@ static int __init fanotify_user_setup(void)
 	fanotify_mark_cache = KMEM_CACHE(fanotify_mark,
 					 SLAB_PANIC|SLAB_ACCOUNT);
 	fanotify_fid_event_cachep = KMEM_CACHE(fanotify_fid_event,
-					       SLAB_PANIC);
+					       SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	fanotify_path_event_cachep = KMEM_CACHE(fanotify_path_event,
-						SLAB_PANIC);
+						SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	if (IS_ENABLED(CONFIG_FANOTIFY_ACCESS_PERMISSIONS)) {
 		fanotify_perm_event_cachep =
-			KMEM_CACHE(fanotify_perm_event, SLAB_PANIC);
+			KMEM_CACHE(fanotify_perm_event,
+				   SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	}
-	fanotify_mnt_event_cachep = KMEM_CACHE(fanotify_mnt_event, SLAB_PANIC);
+	fanotify_mnt_event_cachep = KMEM_CACHE(fanotify_mnt_event,
+					       SLAB_PANIC|SLAB_MAY_ACCOUNT);
 
 	fanotify_max_queued_events = FANOTIFY_DEFAULT_MAX_EVENTS;
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS] =

-- 
2.54.0


