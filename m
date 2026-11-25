Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479F2606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ntc1/cKL
Received: by kanga.kvack.org (Postfix)
	id 4479F6B0AD7; Wed, 25 Nov 2026 16:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41EF96B0AD9; Wed, 25 Nov 2026 16:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7E96B0ADA; Wed, 25 Nov 2026 16:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 037816B0AD7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:39:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A519A14011A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:03 +0000 (UTC)
X-FDA: 85474956966.04.B48EC3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0708820007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ntc1/cKL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642742;
	b=Pm44DYxyQhbBhuiSUlMpt60+G/Z9fSrDOcCGmYKVj+MdF4MPpTQG4PbJhxjcC+E9VqyBHN
	4AY5BzHrBEd88CINi51Do2uQSdS6OUOuxSvNe8QUEJkgt8SFM8ozIIzEz3buwWpEp6UL7h
	tMLDd6hw9f9mV90k9GgU5mAqtSp57cc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9HZ6CESqCC3IbuIZeeH60D+MFwI+V+ns81lV3Y2LAA=;
	b=Zxmv00Hn7e9Ww7ZbhsNEP4M0Iq9Prlh72BW4xQmx5pGx048igl+OaAdnidbh2alYk7Amy8
	yCWMgobJtIif0T8aXJyRN0C9CfY6zAIQNBC1E3hHE3os39DTs5WmAwIF1qwSzHP2qXSCWw
	oMLHfk6BZo0GKQyqTxfrJqkcmw7atRQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ntc1/cKL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A68460230;
	Wed, 25 Nov 2026 21:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04021F000F2;
	Wed, 25 Nov 2026 21:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642740;
	bh=g9HZ6CESqCC3IbuIZeeH60D+MFwI+V+ns81lV3Y2LAA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ntc1/cKLKb+8Patxe9n6wstPGCvrq26H4Tcsn38Rhk6RuSCvvN46w3x1WtKqjTuOA
	 6st+MQ4ErxaBFPr0iiLA0fbC0+q1sHT5uY9eBtF6toWf4QJOozqgr8246o9Rzfqm4g
	 RHwhhKuQMiZ8zzD4OaV26wbGQkS7DXl1kA5wJMECEtgr5olYRPAVYaMKkB2Bk3jpRS
	 Q3E3wfxkOTNHJTPnAp0ciFAqfe2zPqsJWRcSel/MMjcwW/BNLifvygBPDi7qNcmch0
	 Ed3INnmHFEy58vB79VTuatorZxZdMk1K/cLZHwSDHdgKhe9Xv+lHnWHjgGzXv/Kk0X
	 OrI6evbyW9T7w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:08 +0000
Subject: [PATCH slab/for-next v2 07/14] arm64/mm: specify SLAB_MAY_ACCOUNT
 for pgd_cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-7-7c680f02a734@kernel.org>
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
 Eric Dumazet <edumazet@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0708820007
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gtnbmik8a57or9oenmkkqdb91haarwxk
X-HE-Tag: 1795642741-57289
X-HE-Meta: U2FsdGVkX186Gui0WCwzkR0Ik4b+uotZKkrjo9nM2e/TAxmANqxdLH+GyuAaX2n+/k1UcnpK/EtCyasZ0x5gJ4XIJd0AUU3SwwyytV1Mngt8NVnrW1QFb0AS71LdRd+D48naVmCCV4f/u1mIcR3Rlc7A0tnzpqNTwWYb5oaFn7PtmxEtukEmBoEMyAEWyR9oMhm1BHm+9NqlxMW+anMWTU7wtFdlNBVO3r9Nq1JWDv6OEvSq0clLRUBoO/bPC5VDTmku2GQXLnz+Zn5zBUUk0i/SzeSG97TcDl6MkYE95sbaBWEC/hgNpY+k0aMNy2R3Nu8w7Z0KBNGeHpSHIJjlTHBfZ7zFJV80TK1MCxVff87Xns/p64uoYUeqRNKtocuwA+zY05SiRF2R9e76CsGDKMUrvnJiYZ9tsounz37yNIdzeuSSeOHh/w9loihlXImd8itP4SuMs/rfEjSDWi4VuCSUOnd/QXgffHlYf3cF2mShMX8F3cgD5UnfI6lZseDwucNFNbgeQ9SHuNs8xm7TrECRZ+xTcP15V7LN/FZs1sA/9qf2eLr45SqGcLP1WLo4VHGqIxZ6pE/rBVaMOEM78VSe0KvDNylCsnKUUxJK7R2SK1fFvrZYBYcLfkuoKCCxCVmXvi3155Eumj8hXbQER44S/sEG6JhK9GqIwwlldhlxbKNik/Lb800DMo9vKRHhOHE/NJUwhZrH3A0EPdkEbaiaJkBf6S14g5Uoi6m0ODuTtUlYu95RSQ/UAOoKzzZFMr89A8/1ZR6dc+b4XH76wqdiWiDHReFT/jgfkNu8uxijS9ja9eLdqgvPnzT5Wv8J7JkFZMcinjsEka27yYnVBUjco4lITBSLd3NlRaFMSEVEd1rAYb2urUzf30wTpg6pxn4035rmDGs0t6SsT1pHoCGxLCKYd7zf/8G1AGUvoTsiql8oQJvQO7RW0i13jcKztzFhJfjDloLqprfgTXk
 WPnds/bS
 MDWCS875Oka3k4WPE/s1s2Ug9AQFuAjHtZvGsdTKl1I7yMfLs03syiBcUVTojnxpaDkdmA1SeC8sbkRLR0aVMDVK+ONQ9PS1rchBNptknaUdbZOZQGGFexFls8EzNxf5MYguiMqVrAIxFubMZYJWht5BA857DjO/mIsj7d4hDZkdmuAhj6bjmqGG7dlAsXTGH989EBErVKFadJRqmcXkmsdQV9T0gQDYMiv9OYdtlvaQlWKRWDbJ8VSjoXIzRCxFnKCKy+AYRHeRPzpm2MCxVOUDSso+IukshyzNjpZkhOoNDzl8RYTJC38kUzqOcI5wxQJdHmdOCP6D2r0Ms5KghhP282voMviBazgaSB9F2z89F2vxLRSGzKLPtkvugNnr9O2Db/4iAV1uI14aS4zSqfjJkdDeOp+ZMoHbSyJYzHEvAEor9u71ATyzfEni5xFOyRAlOjkhv78bo+OJ4f5iyCo9z+uoglMNhG5RuDLSH41FlvugkEhCq47m+V2lOad26C8N8Rl2iTt3E6MqZ9bCmEggKTwKrGPGVPJrHwmEVlB/lyvUfGxJUUyPvgZGowW6NINO6l2tg9H3E/3MXAnpvcu6tnhfFt+JhoVQSpTo5kXA4bMjEtKt3JVrh2KO7cqzhfatc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When PGD_SIZE != PAGE_SIZE, user PGDs are allocated from pgd_cache
with GFP_PGTABLE_USER, which includes __GFP_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path (e.g. 64K pages): copy_process() -> mm_init() -> pgd_alloc()
  -> kmem_cache_alloc(pgd_cache, GFP_PGTABLE_USER)

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 arch/arm64/mm/pgd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
index bf5110b91e2f..0fd5b90b5160 100644
--- a/arch/arm64/mm/pgd.c
+++ b/arch/arm64/mm/pgd.c
@@ -63,5 +63,5 @@ void __init pgtable_cache_init(void)
 	 * Naturally aligned pgds required by the architecture.
 	 */
 	pgd_cache = kmem_cache_create("pgd_cache", PGD_SIZE, PGD_SIZE,
-				      SLAB_PANIC, NULL);
+				      SLAB_PANIC | SLAB_MAY_ACCOUNT, NULL);
 }

-- 
2.54.0


