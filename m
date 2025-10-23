Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6295CCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92E28E001F; Thu, 23 Oct 2025 08:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF56B8E001E; Thu, 23 Oct 2025 08:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9962E8E0021; Thu, 23 Oct 2025 08:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82FB28E001A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:01:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 516BD129BAB
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:01:23 +0000 (UTC)
X-FDA: 84029238846.24.5FAA8D1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABBA21C0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:01:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y65wUZXg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fAx7tjmP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x1nM2Jay;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NZt1RgMs;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220881; a=rsa-sha256;
	cv=none;
	b=J07x1yiZ2K98Wcs+TP3qvL4q3j/cpqIjz6rt15mQnWHRrtbb1FAqO431EvQo93TqozW5IE
	Rr1B8nh3KSlhMoN4bWwpAzU65eFnAnGbhAfXjyomH2X4JKSfppO5sV4lkcjyPBlpnzL2MX
	pQfSSdbc+uF0JUVXUCfWqGjsk47Shhg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y65wUZXg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fAx7tjmP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x1nM2Jay;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NZt1RgMs;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W7p5nQWyCEhm9BH1MPA6rOHeMDHeFHPXgItAhkK0bBk=;
	b=GGUhO6HXSvWZ+4gK6R/eCmnHJrcGq/gpA3k9vz/kA4mFCkvJUgPt3ZRsHbDgqElCDa1ZZx
	XBTGMfZE4efGeNwDHEBubMiOuXvLQc5zilhp6jJ/No4qSGgwX+ine1kZz0rtunmyCCmUUk
	NH0k2/zIIj2wPldPKTEMLUxlHLinxSw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC4481F391;
	Thu, 23 Oct 2025 12:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761220875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W7p5nQWyCEhm9BH1MPA6rOHeMDHeFHPXgItAhkK0bBk=;
	b=Y65wUZXgkVndE5aov4Vu25yrlvdnxDZF3KzFeLn+HtrfNV3Iwwz+836Hf7159IhzEFhUXC
	qvMqHvgttwJppRWWJeaCrN5n2JP3LbXxpUf8iRV/RMtxtGiyuDb+3bjejOvD4ji6ok1agf
	MnNYi/ATJqjOvie+1QWIR9+wog5Ky78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761220875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W7p5nQWyCEhm9BH1MPA6rOHeMDHeFHPXgItAhkK0bBk=;
	b=fAx7tjmP7SKp9lZ681IeFhbTwixq4xnXi8JX/vOO3wl/XEHU8CTIo/c7bEybwUTrmJfrCV
	FWxWBcPtBAvSaLDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761220870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W7p5nQWyCEhm9BH1MPA6rOHeMDHeFHPXgItAhkK0bBk=;
	b=x1nM2JaysuHh7Y6m6973jnSjlTihU14/4NCNonFKNyHk3uvwnQLkIdABqpdNwwbgizp3cX
	NvBwlEdWC2rgs2HQm8fuO9y69yefbL5zqhONs6lxS7ft2YL9h8tkOsQpSuDkK8IzjcNWX6
	EPyu7eVFnXQQSR49v206zI1WGuixCVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761220870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W7p5nQWyCEhm9BH1MPA6rOHeMDHeFHPXgItAhkK0bBk=;
	b=NZt1RgMsq8Jh6U9g028u8q8R3hXsTJbXTD9xq6Ofp3N+CJ5Kh89YxRtVmccdmYbbdGBaXp
	sJ3IRG0cCsai6aDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADD2913285;
	Thu, 23 Oct 2025 12:01:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 73glKgYZ+mjtVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 12:01:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 14:01:07 +0200
Subject: [PATCH v2] slab: fix slab accounting imbalance due to
 defer_deactivate_slab()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
X-B4-Tracking: v=1; b=H4sIAAIZ+mgC/32NQQ6CMBBFr0Jm7Zi2RCCuvIdh0ZYpTGJa0wGiE
 u5u5QAu38//728glJkErtUGmVYWTrGAOVXgJxtHQh4Kg1HmopUxGPiF8rAOrfdpiTPHEYOyzg2
 2s00IUJbPTKV2WO994YllTvl9nKz6l/73rRo1mrZrFfm6qT3dZBE6+w/0+75/AfnahGu0AAAA
X-Change-ID: 20251022-fix-slab-accounting-f0abbda8a6ff
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2365; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=Zlay6eCbvp2/Sw6UVOR2JhIolZPjDd3LN1tdgEkO/9U=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWT8kmTZvKlyzQm2Pcc9Jp95ELVgk/UJvSeiXG8XWi53T
 vsn66W4upPRn4WBkYPBUkyRpXr3CUfRmcoe0zx8P8IMYmUCmSIt0sAABCwMfLmJeaVGOkZ6ptqG
 eoaGOkAmAxenAEz168ccDK2HIg3n6Vw6br03rFdNcraScK391WSDCxY3Ui4szLuy7X1f3Z2d3LK
 5KRPv8F+//LCtv4Zpo2z/7Nki6466usRGi26q8ctL+v7K3dXzX+LCet5lr/jVSteveGcrEaH7l7
 /VKME78pVfSFwYtzPTi2WPBKYd/akw9zNrGPMmllT9FY0fj3BcsGPlYj+TcnOT6ldJpRhlwcqFt
 6dH2Rhsfhko27LmnCN3go7C3IDLNW83v5pSddz30DROrk3zw06Wmx6Sf/OtUG3rRRYOuQuxkZzL
 f074EvjX7XjzvjdVB+t/8VomaGm25tv7PL30vbSu/32RWDv3bEvfK90Hf23T27dcwb/gTfqRxaG
 uM86dAgA=
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABBA21C0005
X-Stat-Signature: r8ftsxocjg7s6ug6ybgqo8iewpmjgf56
X-HE-Tag: 1761220880-349169
X-HE-Meta: U2FsdGVkX192AiuHBnSILVBnx0qkojIBnjhrNnJfPhnT8UWUMnhl2+NUTvFAoQtBwcDSMvx4FdCfEltjpMnORts2TrfvMkiKwQ0QZ1aKa0Q5BQ9x/u3lGeeCg4whEMU4FHTzhcc6t6uYGlVSo9R+amE9UdLjgKFrDtmE4b4/Yq/N+5TIwfVQr25OM6H6f6ReEZpF9OCV91fZGJYhOVP6lK332P+J+h1oOdLddO7pU4VdlilI42PiPKTcppHkvM5PqZhbNP5B2eHRG1ikE5e4NGSGAL6/6Tz0FSO28ryPgke6dp0pFIztV4Wi3VXobVDA/OxmbEWNojsacLyYwTIAHU2YO153bP1ONEbAPyofhXTkkqgUGkFRVU0BjOLZZ/Kx96mqC4lOMZUheymmn/WWD1lX5M7ZK5+GUdKPcuCyULiAQQi1j11+RBVBI3GnauIXK5lZCqM6XknuhFRB5i1i28wVQpBDG6NnDNV4yNewru8WC40tnRTcF3/gRPILmaR7jk0L7eT3TdCIrye34yO2CiIGjjgLBy1D0oNJidyN+cS8CKaRhbNc55cJ/QcQsmFFqL9lvAJg0ldgtK/8qJVTnlzE6zCiUzbAOjDOtgRthGFRmfhI5kv1KJyFNRS15XnfkMEcXvmE0lqkBX/PBiHfY/Vlfp6yz5T3MTeGFKgHAHTIEBPifChp2x/bPCNikzi6AEztgRPpiyyM3meanm0mnkUf53vGrb6Q4AC2oEvWgH/lIb9tyWuvA9x2SmLLnqNdnB6NIoww08x6sO59jOUgcELijpYpUp7UQUYPriZ+Ifs+IeOYSwCMWFVCy+oKcJeF8VfL5srP60lF8PhmjLHoQGHUTRYXjAjNxAc2C+VZJfocLHBORowDSzmWr3j6eQ9Rbzk1cnp66BVHnXuDzjGP41MnItbzHwEpRwgLZ4olIoWjr29iUoqs7nxXZsoiQAPEDMhvXgeGr1rzDKZFe78
 Tys9e8wb
 V+gHJdasxeTT416YW1EzOhpYtN+0ZI3Ft/QT/aJ2y7+oGqjLV3dQXE0kL35gNn0WgM3J1k4EioMEMWNZM9UmHp2SoSX8MRx+UzKA7jOT0geuMQNMQnTdkSuOmJktoL1I6BzUM21964RrtAEsBC2mjsy2BnQfgIcjkgLPUqxikBsIeuEndpi8Ps3vsy/8VnD6TYVNRQGSuj5btjx/YJsnGrjuuPT+yoOxf+yoRDqfvAsHsSnN6G9x6kTR9CVqfJFnPJvNkuXIieYT4TWFIkK9IO/C3IAp1baoVmIj2cRIGC5GsudLx7lNzlMfWOChm5oCHYkAtBNeQ03DzvjyRHR2As0Uu2ODlXkCWUIL3CJUh4yN8n73KROPHnG+0hbscfhrUShEK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
that we discard the newly allocated slab if we can't spin and we fail to
trylock. As a result we don't perform inc_slabs_node() later in the
function. Instead we perform a deferred deactivate_slab() which can
either put the unacounted slab on partial list, or discard it
immediately while performing dec_slabs_node(). Either way will cause an
accounting imbalance.

Fix this by not marking the slab as frozen, and using free_slab()
instead of deactivate_slab() for non-frozen slabs in
free_deferred_objects(). For CONFIG_SLUB_TINY, that's the only possible
case. By not using discard_slab() we avoid dec_slabs_node().

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Changes in v2:
- Fix the problem differently. Harry pointed out that we can't move
  inc_slabs_node() outside of list_lock protected regions as that would
  reintroduce issues fixed by commit c7323a5ad078
- Link to v1: https://patch.msgid.link/20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz
---
 mm/slub.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 23d8f54e9486..87a1d2f9de0d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3422,7 +3422,6 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 	if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
 		/* Unlucky, discard newly allocated slab */
-		slab->frozen = 1;
 		defer_deactivate_slab(slab, NULL);
 		return NULL;
 	}
@@ -6471,9 +6470,12 @@ static void free_deferred_objects(struct irq_work *work)
 		struct slab *slab = container_of(pos, struct slab, llnode);
 
 #ifdef CONFIG_SLUB_TINY
-		discard_slab(slab->slab_cache, slab);
+		free_slab(slab->slab_cache, slab);
 #else
-		deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
+		if (slab->frozen)
+			deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
+		else
+			free_slab(slab->slab_cache, slab);
 #endif
 	}
 }

---
base-commit: 6ed8bfd24ce1cb31742b09a3eb557cd008533eec
change-id: 20251022-fix-slab-accounting-f0abbda8a6ff

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


