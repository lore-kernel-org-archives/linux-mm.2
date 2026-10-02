Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E50DCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AC36B0092; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31A06B008C; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2236B0096; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1A8D6B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F470A0882
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:36 +0000 (UTC)
X-FDA: 85279234992.04.B9B0728
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8490D1A0005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JlKtFw36;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790982694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=il8A1RVRfAP3LmRZEt7D66Nfnu4TVGi121lkczSMSiQ=;
	b=cuoIyGS4go/qFZzCnL41JHY1VOCC/ih2NEeXp+HOC8dZW4s5YaeOXLoM3qfe9y74FaSiRp
	2oAQVj4nLyyiHmki3/OhHS09Nk08FN6KPRNKPF8ehwT8ymb8LQr5I+YLOnzVHRFPmWygsw
	GWjOAwBriR59trNB4wDmCovViVNLkLY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JlKtFw36;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790982694;
	b=SIbTCQ55GYMQnxxHZGJjKlILgONLDA7nKdu0lpl9AgCVLtDT4V/0SbiI4YHup9oqRcHW5p
	M845fDCrUpU5DEkHaHIa7HDeYYPwBe0vPj+Y09wH/mGIf6xy33W8JTGeG6Tt2o3+qbiFK0
	anXH+S8grYTODrE4gclyE7wOSCEOkVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA4E460230;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262921F00893;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=il8A1RVRfAP3LmRZEt7D66Nfnu4TVGi121lkczSMSiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlKtFw36eMlMokCbuuuhmSgbjFdvD0tBMPp4BfTVPh4znMWqlOezpIfvnGghA7Lt9
	 1/ulIEAd9JSdiW2+8S9+59b7c1R5f1loUnQMEet6ohlEp9rT80vC6BxYfkihNGWSHH
	 GhTejv/kjnALRVLtt7jKiCmLct37U6U78GlulMI4tRTIl3ioPWHlYZdpD39ONoDZjC
	 wGGtCMaf+yyp1cYUQzEsBgJOJUUtK5Z9hqmKDhrtNSomzwyGtE+YMUoz3AVBWmfhOz
	 jF0zD+5Jkk4eP3lU5K+TtK4ZF/29zAaLrA+ODnU+QiQXToxOyBESzh7HW6OflkMYDL
	 OhYhb6szA80uw==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v5 1/7] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Fri,  2 Oct 2026 16:11:21 -0700
Message-Id: <20261002231132.1646573-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1768; i=kees@kernel.org; h=from:subject; bh=AuGTrggSMMdoLaFPyZC7inBFjquZSoja7nsY11s+2D0=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrGSLN2YfELwjaF+9xSuq945av3Z70zMbxZzA3XpLR C84B2/oKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmMj/3wz/y/i2W0Ve4VA4uefW tHu/j8hE5eiVPDzOc8TywXvtMDvLFYwM0/k2L172aIVZ9fylfqsrn0V4f+0p/2MleMr164qMbzG F/AA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8490D1A0005
X-Stat-Signature: 3ppb11g4bj8c3p3dx698y8jkh7wsd5xh
X-Rspam-User: 
X-HE-Tag: 1790982694-705196
X-HE-Meta: U2FsdGVkX1/7HvvSeHafQe6HYMCb2CDaox5hGIXbsJqZXsZdjzMNzd/jzq+cQMAaZ7WkA4pRwQbgYdg+8YuT4+zz4eF0jlM75vbm+n4VfyXeUn4voBnop8UNWLkf7jWzfu3JvuYl/Dx68+Q4fU0Hmv/ExM/JxKDaUXvYQ70D9qXSxiXWW1B4uDopjUWk+MB0mZcDQClbWfqVIFePq2Fjq56+YMvkuSOGD+kqrA1G8DeUYBufAvZEzHXutvHGk8mKnpktxWhGq4kJ9NdptrJdlv0Ovzf15W+RDDsoNcHDXp8WVO0Imcs9z8VKeO0iRq+7QDbqS8m4nfUzBn3aGkXnaaO+aUos4Wd7AGVtnPcaaQAK/D4rqUEmTy+8sKEyl4y+380pbsh2/CnWvkYpLJiv7jMu3MboTvMCx6iHTldMUUcOvFXRefQ5UVKwWb9JrXQE/eo0EAUDiIL3OAxpHEVljYo9rGyrfVct/6Fn9t609o1fa+uufx++4Nco93Ja3LIpo8R88swUk3UgD6JReI4TJCEPy34+viV98qn7/KLGItYFRQosxW+FrhylxYDzpJuIM6AxelkJomN28rdOoPPgyGlrFZ9Scb/l9hcX9MiQRgSQaHHaRh0DbDgUklCtv1DtPj7PhDUdh3NK9IHR9vlyO21LdWgUgjLNBwCcH/uF5e0D1p33abhoRnXnsfXqMolCMYGYaQdNQplpjWQP30TsGmZhRtShvMnfAFURb7n1jAeL5Tb7+HFrfz5KcErWYhvXbkrWXlB9MOblQddT3c+SIFf1CMviCmDX9nmvS/aLLTKawTBFM9ply3jlzeK14s2Dw/fvDyku07N9mkZtcYTnqsknktoSohi0DxoZ4F/P+L/R+EGZN1L2qx0MusWPluEteZ6xUdT4AH5YckMyDNjWItLFT8CwMLBjSyFsW3nm8pNfChlOiVuXo0Y8U8RMaSkTlZnYixXy0MFmUe7zT6A
 aoyDkl33
 a4we/ShZCxWCPCUf5Qrfd+j4T+njw25NZDfLVO/k+3W5u8bnZManuUa/fvR3+llpj3UPlqKq5BJfpSKdyxaE2/Bbv0UuofItbbU8wN225Ss4Nqz2PZ4Q694QmGzpQMzDmsWMMM1yoF6FHNyTs7fyelJDmgGBHfrIgqsblcTRTY/F443J6tS6pcD1GAhmqJ+SczYXoG+ZJuw42g5+mfsN6CeXXJAcZcP71xeiclqlZbIA8UbCHo2UWcdsPRUPZHBiXSlIvLRpllaPALll1cGa+9LVFyRDx3h5WKrOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() had the same sentence about calling context as
kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
rendered in the body instead of as a "context" section.

Give it the missing prefix. Additionally fix the "a interrupt" typo
__kmem_cache_create_args() had.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..270408ce5a9d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -311,7 +311,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -422,7 +422,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
  *
- * Cannot be called within an interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
  * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
-- 
2.34.1


