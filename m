Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D28BC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BAA6B00D0; Wed, 23 Jul 2025 09:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C9D6B00D1; Wed, 23 Jul 2025 09:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534226B00D2; Wed, 23 Jul 2025 09:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1D56B00D0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECF27160689
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:14 +0000 (UTC)
X-FDA: 83695625748.22.CA3C1F9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id C390DC0006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k7TWNhIa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dhAFiZfv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k7TWNhIa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dhAFiZfv;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjspbytw5pUKmztZF0TrPMKw/E4DLanznrsR+bMZ7RQ=;
	b=Vvv4B/tn08y86ng9TTqI5vRtb7GiLgOqx69if7Dr145b6aZeHxrs6sTgZdmo6fvOxdnsZM
	p544KxWkaNxXjWTuikyg11obWIUSe/yF6ZhKTNHwIoT0+0OwrgDyAtCBGCNGuUmVbg/EqM
	U2YY7sXX3leq3xhaGNZE34nS31ytiRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277713; a=rsa-sha256;
	cv=none;
	b=edMT7fYFV+QqlCaA4ZUpY7Mu8sWqb7RbSdOuElWAfb5sP1tIirMg4YwSxa8uCWt9gx9aJk
	WSn90NIe1fzUQtSMvD+EEKg4KYBtAWOjBEXgFhHEtuEzxv2wXhQmwKEk+4oFcYMNdVCkzH
	UYtzMIcir3SkQ0N/rQW450q/Xw/q8Eg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k7TWNhIa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dhAFiZfv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k7TWNhIa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dhAFiZfv;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7ACF6218B0;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qjspbytw5pUKmztZF0TrPMKw/E4DLanznrsR+bMZ7RQ=;
	b=k7TWNhIaARnum1WkfbGe5RwoewtunZWxrgNGiLzBmp8m1PRoNoDkPEIFtd05Z9Vmv9CNtL
	u09LiDbroxL8En4mLkNAPFeHaERQ4GYqAk36oBZfEUcnG9111b6gdgRrHv8+Sjf/ha5JTr
	S5VFn7nePx0GbfOIZtvr6Cv0n630emM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qjspbytw5pUKmztZF0TrPMKw/E4DLanznrsR+bMZ7RQ=;
	b=dhAFiZfvJVtq3zZuZ5AZ8bXG7pje4bq/RsQHdv/EjrDDGaFM27AftIV7dMmKQxKE9gTQC1
	mCTB3/sdl3ceb5Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qjspbytw5pUKmztZF0TrPMKw/E4DLanznrsR+bMZ7RQ=;
	b=k7TWNhIaARnum1WkfbGe5RwoewtunZWxrgNGiLzBmp8m1PRoNoDkPEIFtd05Z9Vmv9CNtL
	u09LiDbroxL8En4mLkNAPFeHaERQ4GYqAk36oBZfEUcnG9111b6gdgRrHv8+Sjf/ha5JTr
	S5VFn7nePx0GbfOIZtvr6Cv0n630emM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qjspbytw5pUKmztZF0TrPMKw/E4DLanznrsR+bMZ7RQ=;
	b=dhAFiZfvJVtq3zZuZ5AZ8bXG7pje4bq/RsQHdv/EjrDDGaFM27AftIV7dMmKQxKE9gTQC1
	mCTB3/sdl3ceb5Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65FBF13ADD;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uDKiGAjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:41 +0200
Subject: [PATCH v5 08/14] mm, vma: use percpu sheaves for vm_area_struct
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-8-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: C390DC0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6iemn1q7bwcxyy486t8z4c847ertjia8
X-HE-Tag: 1753277712-945198
X-HE-Meta: U2FsdGVkX1/+ZvfmBucmZOX+59pi+Vd5cC97hODEk1ieLDHpg8KkcwksAU527JtP7tV1J0DkbRU2pykxqdA9Uw939z7aygQsmxthKGa+TG/0H3EUJ9gZs7uBQs4EltSmsVCht1V4pjIG0wxXG6567qeA7Nsv/hw1gVYl4x6iEr52HMxdh95/zyHhPaOx8KJQhxVhwF9jRrSeBPN6kSZkqjGV6HZ6s894atfhZ868ZiTsZTlEi1gKCpbJ5N65JmktCgGumeJPFrHGaD42pRJNZ7X+IuG+xcr7qReQPMzK11kLHtGFtvOD0WhqaLTou6dzbYeARgP5qwR+/Gz8WsoqrvSVUvL63rGMWw/AaPusSYcaCbpFCCDLpKO9d5cwx5K3pmVmk5ZFFdfudRKeuFdCG11onDyBPweEfcK1JnAvDYQtg9hqHvPN6YbDQeLc6GxLyYbgu4Ght5dwfevlwgCCe1Y+5/G2q/U8QkzQjMh8DGlrSntZACPNkvDCpxBQ/ml9AhaPqVVIhfDspU4fZHkpnSPniR3TgcvYOBN4ipOQNE5RZod8dzro0oYJrG4uZWbDpyRxgA4o0Hvpaj15JG9wREo6CgevTkmLjLuHDd8xVwmpy/MwcMLrDvUyylNkcY/bO2TlFXuLkpYbewDmmlSsaDF+btmaWMXHYVmZuOiC1I4mEv2koX/+GgSHOaGmPKmzzvKWsvkh5zTeozMWTl5fk/NMngtoVI/MFQhxNI7QMwdcp+IvOTEICcy43HZD6qtIOgIjtKedFjZGbWqoNCwKZGC/D4YIIboRED2m3xiwEKbhwbGd3bQSg7MSqTYDVVDZ/CAuxmSkBHG/0azURnRE2th3zZQ/C3rwEHX2hYCKTaL7GglwiXkluwjcXAIRLYz3w3MCtqIvYbYw9B+V6uoOyBUz0/m+Z+S19x+UMq8qfiwfYN3mnDKT/0/HWiGVumZsORszJsduJzf4Ml+ZxN3
 rzY5P1lP
 LjNVoRcF2hgTmwxSH5dvkdGJwDA/9LxU3+JpEuXV24fonvkG7iAzMCidF7pOINqBxHXgIi/hnwy2PhBU75rO8f7vkisnoKTcqSMZnGW5uGEg2cS9SqCJUmykJPvgEE6zn85rWAECm3aRUH58aWIHm005ROJGZ+dPtEctkmNbIyzblJ4sxi6iifAkieEqb9rblz13p2PuSloX6ttoGJgQUDhZhmUMH3p6pMoLQoEQarBor/O8DVJlj4CsVNp+BPIdmOf5aWR5neTY3r0HUO2W1UhhG6TrnDo2KNf5XaahvOxTp4aRk7ljd+Q39rWUkA4gIG3TG7iaolvTRuTTfgRrITtzKP7ynlnxlLj1G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create the vm_area_struct cache with percpu sheaves of size 32 to
improve its performance.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/vma_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vma_init.c b/mm/vma_init.c
index 8e53c7943561e7324e7992946b4065dec1149b82..52c6b55fac4519e0da39ca75ad018e14449d1d95 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -16,6 +16,7 @@ void __init vma_state_init(void)
 	struct kmem_cache_args args = {
 		.use_freeptr_offset = true,
 		.freeptr_offset = offsetof(struct vm_area_struct, vm_freeptr),
+		.sheaf_capacity = 32,
 	};
 
 	vm_area_cachep = kmem_cache_create("vm_area_struct",

-- 
2.50.1


