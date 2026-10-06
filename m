Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F08FCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB776B009F; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FB66B009B; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C598C6B0092; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955196B0096
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14D9F1405A0
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.19.11041F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62E3D180006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNjDfRF9;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccnT8loHlbzY6gKdlIsiOUq8nG1NhEaTYWMJqGNG+Nw=;
	b=5zR45/ZdVsU4kUrwnZwecJm8QvTRLGWk1aVDCVKqoVJJW7nfj1nsPRLNxZzCjeH9QfC4uq
	vmy/D//WlqAn5u7rOBC+VmHG3YcP7P2yL+0+umqe0vRwjgxiSvQC1k0JcL2/uLjvSsSoHr
	3GiRWCDu+oth6VXCvqH7isFyUdEppRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278437;
	b=MzedQAM6jooFI2b24TEl2mQC9zdZOX2S6Dbzs8DScUB/sEYHxd2aBcwF/U1BPfTJcHpY/H
	d8gEzICLm6qHpgdizePSHnldMe79d4SOvhk71tS8W6FekEqc4AsBQRJHdV2x25T5AsSRfz
	lrTMT5fSUuldpNUbIYjH0ePKB8JxGoM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNjDfRF9;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BCB060546;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDFB1F00898;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=ccnT8loHlbzY6gKdlIsiOUq8nG1NhEaTYWMJqGNG+Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNjDfRF9MjDY8pC4+kVmQa56taS4A/Mks1cpkxJnt2eStLBin7XHBaqwR+h8+70XL
	 gBBZFINQKmk7CBTSc4eXm4iLsxBJg/Pie0SI4i5JpWYMlWzIshznz2BuI8lD/iwtrc
	 e7SH5BEDRCckE9rqxQf7fwbR0Q7HsyUSWCitHpJiiGd45W+OrZQE8AgYSGu1VkcqoG
	 /If8s1fsVircgS13m2yPJiL80IjDUAqFoOWE3Q1TSF2y9Ixs0GFqyo33s4QwzblVds
	 P3jsDmAlhGh5m6VYP7QPnqtbRuPfPtsbT5Ye1/VjxD/H21xguBhl3wdAFBa9fFfRY/
	 Ef1eaoE9uZnOA==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
Date: Tue,  6 Oct 2026 02:20:28 -0700
Message-ID: <20261006092035.166776-2-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1765; i=kees@kernel.org; h=from:subject; bh=Tp8/qFUjEWwmLfgAKlPf3+uMGFYcGpgvjcTyJ+Rn3GA=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9san2Z67WWLIEbElYQrLwT+f4ucfDn3AK/JGfX7CB xPei/dbOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACby04HhF7NPzR7pnoLNpUZq eziev9U8t9zjVbfapYUfJkzxOb6F5SUjw/X8Wax7yh8xnmPMWqsho7Jzcke0aNvTS5dStju3nDj UyQ0A
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62E3D180006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rhti5ew1rr5xhtindwpq31ao1uzi3yc9
X-HE-Tag: 1791278437-751835
X-HE-Meta: U2FsdGVkX195RL77oPez2HLjK4i11Q3TmizOikc6fKfUK3HpP6g5Sj1sfnrm4TKpQtzWQ1y1YbNI/HxHbgyCSyRWvwrKRtgrjllUvYP/S9OXErUohi7tUHry+J4HYlZPaR+dnnypD/A/ndTRc8QEr3MZ9rD/zHNgKHWBWZUsdA1h1Us/kzjYxBfep/dsZ44+MakA7IpnHDBoHcj2stBx/ji6EOt00oc3n2CchXDoSil2YhuLbxm50Mox/Jd7+5OmUmOAQwAKKth6wV0bXpbdB+NcmdDMAO5+vNPxiewCWwY40Tu9/b71uhmFL1cng2KQxXG0phCqCimltbzpcGRiiFCnDWDsudYLX10qQ5f86nuneF9MCoaTaLRWGL6JKiCW81MEyHwS4vHJnmaCSKd2hMkGWmaok+19sfxdvCAuTPFmxAQV2YzLM3SAXSOWQ6tsWxISCuetUV2OTXGaCECzcaOPQAm61oc5xOX3uTaanrsmZZSB4LH5Xy1uIhx+7q1VDU1GXyerKtNVuCqKKrQhrq0SIxiEzrcU6X96g9ytUEe2M7bgVQmSM+LphZlFGn3hMqaxMO4rC7bA0IsvIaVkEab8QeKXnZ3VZWj5CE0z1Wp2K5Sjw4GSNroN+lMMbOWSOggQhoPfE4wBFvAmBYDmWPg+d6YIWYPnpMTatK2o4nZuaiBjA3pmJNdW/6zYWndMF7yPWqazrB3oBmLjChxrxuNj1rB0wDKAaIOHvJv1PspNM0DaQsmVwT/gfFCbgi5o+ctIxoPzo2w19odxFKTd2RIRWgTo1nXLGiNDo78YilQGtxTBumrmYGjMla36SOjDLD3Lk+kpdsv6H29ktU/y+T3w5bji+HO1j1c8/L6PYYPR8hvH+DK1o2aP3jSm0jJLglqci3GUnevbTDkzZnv26bA8sMJ5NHp21M9EoPYrIbQ1n+iIgCNlYsDiNtK3u6APTigmdhtcyaerJWix6WN
 DotdfDUi
 n9tTtAEYu9A65kxn3a2TDjuUPKKkt9DBKZ9PIH7ipECjZVvg59x79Uk8cIswk0yyedSNtDNyccM0Pgxay8VgFq/jddJMAk33jB5Tc7lQqo///cj5Y3p/+glAoaeoyNpEwFLzVB5eDt8vNbxCb5QHUhcoW2cbBWvscKxwMAaxY1H/qPE8V0lRvQIHBqPA6JfVXmajkevsBzZHAwUH8nx9Vuzi6hLQE+LfeLp/llbdBNEZZKBHOPyxkKgS7A4qEBMyC2osjW4zfZ25wVEc2SD9T9rnhAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
accounted only through SLAB_ACCOUNT on its bucket caches. With
CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
which do not account it; the same happens when kmem_buckets_create()
fails. Either way, the allocation is not charged to the sender's memory
cgroup.

Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
charges such an allocation in whichever cache serves it, so drop the
SLAB_ACCOUNT, which no longer adds anything.

Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 ipc/msgutil.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec..1ba8e59cb255 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -43,7 +43,7 @@ static kmem_buckets *msg_buckets __ro_after_init;
 
 static int __init init_msg_buckets(void)
 {
-	msg_buckets = kmem_buckets_create("msg_msg", SLAB_ACCOUNT,
+	msg_buckets = kmem_buckets_create("msg_msg", 0,
 					  sizeof(struct msg_msg),
 					  DATALEN_MSG, NULL);
 
@@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
+				 GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
-- 
2.55.0


