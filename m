Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF6E606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJ7DXGEs
Received: by kanga.kvack.org (Postfix)
	id 5D0436B0ADF; Wed, 25 Nov 2026 16:39:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A70C6B0AE1; Wed, 25 Nov 2026 16:39:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD996B0AE2; Wed, 25 Nov 2026 16:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D23E6B0ADF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:39:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C13858011D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:40 +0000 (UTC)
X-FDA: 85474958520.09.03C65DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F56B2000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJ7DXGEs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642779;
	b=My68/mrowOU6GVnNMJGC2zK2QDY4tDxp1itjVVJ77FimqSHvUsB6IYyDWVJw9O7873rs6R
	PjlkYvdkhy2uY7G3QnxMe5+K97oERbjhD0FYyRtjDCJhyvUlWaWJpx3hRC1E4+0mCcFcul
	sNxhd0CLGaghEWcIkjSfNT4PddbEQTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEcqqNm19OuH8f10/Y2MYPCdnWCdxBstah0njeHlZsU=;
	b=3Hv1n66ghKiHnlASO0hTkA8MFd8DOr9lfI25Ez/qYFTgrtR+ZwHVOqoD92+BWCmmI6SIZx
	ZJssD0pl/uuGddjMibRSW3NXrnxdwwG6Nw+M+f+QoCwiTEhA0lcBzcIuqyGPD+aCxj0a88
	QUY9DCHS0aRdioFOIlae7LsAsMvo0gY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJ7DXGEs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4AF460230;
	Wed, 25 Nov 2026 21:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE611F0089F;
	Wed, 25 Nov 2026 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642777;
	bh=vEcqqNm19OuH8f10/Y2MYPCdnWCdxBstah0njeHlZsU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JJ7DXGEs5MKX+mzY34S5pcC47lEO+Z3xW5ExnajvXeyp6B4cTkEBKBLKwRfYJ30Fz
	 lLNpO7huIkAceYpnk7nrSIDfc3PjICL3cqJQOiLMp7p5bm9TWqZxiN8Ef/M95VULzT
	 fHuKQo0NOfAybTCSxsCbnnpdX681msyNEwt4gK3mAOyU7j1c+c+DPuJH8a/Ket8aRT
	 gbr4kXFfaBWZDxC3OE8WLPrq1UI42pL+JEsiyxGoNQ/cgvNany+6roREwPJkRXgvWA
	 wEQW3ZqS1Ng6/z3Q84rN0+87qHe/dj7XUTNrb7i4h4TviMkgm/tk1TPgKT9zYetvzs
	 wkLns7a/xnjJA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:12 +0000
Subject: [PATCH slab/for-next v2 11/14] smack: specify SLAB_MAY_ACCOUNT for
 smack_rule cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-11-7c680f02a734@kernel.org>
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
X-Stat-Signature: hef99cnaa1yjkygz8b41mnd678rxskfx
X-Rspamd-Queue-Id: 2F56B2000E
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642778-637653
X-HE-Meta: U2FsdGVkX19BS2C9JwwaEYGZuziTKQp1uoXvzIagfVOdK2jwK4R3oNNeohyl0/2pLXvAM96KATuboQXR9kckj9Mut/X0/+jBNKxBMwvy+yHTeftbekFNnCKcfdI1gqOyXf5hSTldRRZbxvHEbc8fxsvKMVm+xaoGiJbqwCL+exYv8kGkwQKvx/lWhMs/ZI0FTNeIRu2t9lRN9rYCqX55QZ+4JSejtirfH/EY+I6lRkZjBaSvamPn3BWn1F9OC3+l7b8ATM9VBwXrurRTDkv/4gb22IHfgI8fYdTdimR4tUjt08iCaracdTHmDWFFVpYNTi42DDbm2J3zOl+n1xXRoG26ihoqnXmCE35l3cPRqt63h396s08wwJ0py9HSnSffbcbFA4/4fO8qxUIDDkq7u8J82Rk3HUncAqJTPPsmGgkQBDrAysENUEALGAtsXDRHaictAHxAfs7nVA7VEmr4dWczR39d63uXgx9/Cc1abIqvnpVw/9IMKdWazmHWvCJvr/3+KruQF444gwTp5cqU9lTJpv/xJDyi8EhCcfvKpNHzt6wNIi90gJhZSgQgsclwnvHc4KhvYHHIYYRiBrzmA5D76jQVNe/UTHhGAOyieT26sMKZoclt/AkmON2tHs6ITJuucJv9MOV6l+870ZkzYUPZuq7UuCz+OgfIEQ49aH+E3/cHFBFenWJL60YRNKGerfETGmRvhr9fmN3sJNxky+njqMouSakL5hh6ovndL0jOs5Pq0aJkbQYZD+meUinRL1BnuiGuehds/oOlz2PY6h/nqAnGHChTBHGL5fzfmTJF78rn3n2d5JzUDqeA+lxEj8I2kHhmAVGOcVVH0Vcrz1v8fkdfh7swmlYA5spw7cZdxFmLUOcxtzZLDkF+5EByjvs8T0D9xutyLqEMFRe92o5JUWBn2vVUmxFSu4jgU7aHivGhot/HM2Y+9f9Mdt27rpJr9vx0JP7u7atSjgY
 U8KeXcZd
 XMOdTIqVD6LX/Ac9pb76kjsZHztaAd66iwyKgV2eExUGSODIH+8dFrWJpXUavXRcExsyt/6U14cUM33ygklXGgMyDLvVj3UerdSvq80Pspmz7a08Uqgik2xtOIclqpnwxeEEUBn6poLWj81ZIQN59GTn1o3hKCc06nbD0nsHyooaE7WDczUsSi/hhpyUFqJUd5AV2x18I48bVBIDUjx5X8MzrfxmbnUkJZQ1+ORDvaj8mW/hv1Z/qQyNSJkU3ab9cWbmyy4FocA1mOVRVlUAVfIFidzZ35e5VSiTt+bgraiQmnpAKeJhe4GwwduNzZhQUgyIzGFaXJ78KeqwjyOEW3HOZMd9e7r+G8iBbhCe/O+rkmz3G+khaiAXm2T8O3B2MdNINUZOtZxQUX6KzqsEmgY4nZWYQa/C2CW8UMgNeKGHEq1xjFNuFku0jusdCilXBhMN7VcJCX3GB0g/b+ovwJtmM1I+NgDfhdnTHpPch7SBULywBoMygUVtWERmnKFIN82cWHWJg/GJjr6RNbtKo1I/drh8xdDboa+T/rFMq5ktuPMj1j5Q0e1kXJTac/LWbB1BgkKw3KIMfHrq0ktgOVUU2OPfJbyoJhc6Zo9j1GBYi6oiFXpinFGk/hv3v4fVca1leAyrfqW8v2kpYHRfu9AU+Bw/2fD2+PkSMEVkMwOjPRs4HevSzmMyAKGd7ojArhmNCEia4Y2jvKwM6n5c0Y+pOdnO9vofVasQKKKXw5yIvfqKTRnOdXgHaTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smk_copy_rules() allocates rules with the gfp passed from
security_prepare_creds(), which is GFP_KERNEL_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: fork() -> copy_creds() -> prepare_creds()
  -> security_prepare_creds(GFP_KERNEL_ACCOUNT) -> smack_cred_prepare()
  -> smk_copy_rules() -> kmem_cache_zalloc(smack_rule_cache)

Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3a4a33568297..f4454dc8e232 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -5359,7 +5359,7 @@ static __init int smack_init(void)
 	struct cred *cred = (struct cred *) current->cred;
 	struct task_smack *tsp;
 
-	smack_rule_cache = KMEM_CACHE(smack_rule, 0);
+	smack_rule_cache = KMEM_CACHE(smack_rule, SLAB_MAY_ACCOUNT);
 	if (!smack_rule_cache)
 		return -ENOMEM;
 

-- 
2.54.0


