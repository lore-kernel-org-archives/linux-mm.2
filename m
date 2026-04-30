Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66674FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06B56B00A1; Thu, 30 Apr 2026 00:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDAF6B00A3; Thu, 30 Apr 2026 00:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AC46B00A4; Thu, 30 Apr 2026 00:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B19396B00A1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:05:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66A99A0413
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:17 +0000 (UTC)
X-FDA: 84713882274.30.E2C05DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADC1FA0006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uJyCN/cP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjOwhtb3aLC8dXcF5fdBlXdpp4mSyr4Dq8lBNuOOORA=;
	b=xjWcImMw2cQHTA+oq80Jg1x1vO2GfQbgrhHuJbP2wImvk5KjTSMc0LAQLEYTeEt1DvzC0+
	5WrXP5mHlvg36j8oxcpTWTCGhG6b2jELUKQUjvigbiR234UZdO0V/m/auegtrWSA0x/AHd
	l4zswNrtQpBjXSiQmXuGVQMQkUWuQ2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521915; a=rsa-sha256;
	cv=none;
	b=3eEtVVo+IwIetD7HG+mEH3IcCgjy/GXrzVEgyeFc5EBVTjf7Cv/xybivtxs32tsvlIbe2G
	lN56VvvO5CSjmBYQtlK5s9p1xVznNw23T8LKkU0kPiizaAO9DxqfaNwIUuwUD7TZj5ro4W
	dzy07xO3EhqHrkDUQCl+N/8ZOdXhCfs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uJyCN/cP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 953E9417E4;
	Thu, 30 Apr 2026 04:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B00CC2BCC6;
	Thu, 30 Apr 2026 04:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777521914;
	bh=6MPYWPf1QbIXw7VCTkYtFV9yBQTJYYcQnuchAn2u66s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJyCN/cPD0/zuU5TMG/FWh17eVTVcTCG22wyND+Ln22vdCzvScs+KeOLVG9RmOssZ
	 jDw1d8PhCAGGbMI/IFgx4Z5EBNcmkVO03z+9/CJtVz3K4wxUxjDLHuhXQrygfZY0vj
	 Mz9EPYWMtvXMUkv1GvrXcIXqYy7f2Nbz3f61nlophvJmqpD4ikN6UOlFyXJonZi3kU
	 apK9iwjy49sl7fMM6lNjIBPwaa1bmY1pG/z4xtRWqVUh4kt9XKZhnZLwyhRWE61vDF
	 fxzmTVdxergJndpikZIoTxLjBRYHAUamicyvLwT/yqUnIVLaZSAeOqCic0yYJ36c4O
	 EWCGitvEei8LA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	pfalcato@suse.de,
	wanglian@kylinos.cn,
	chentao@kylinos.cn,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com,
	liyangouwen1@oppo.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 4/5] mm: Don't retry page fault if folio is uptodate during swap-in
Date: Thu, 30 Apr 2026 12:04:26 +0800
Message-Id: <20260430040427.4672-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260430040427.4672-1-baohua@kernel.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADC1FA0006
X-Stat-Signature: 346ezoreu49nd41h4txuq6yoqzhcqmw7
X-Rspam-User: 
X-HE-Tag: 1777521915-34784
X-HE-Meta: U2FsdGVkX19h0cRx6UccKVDWG+pQ9vsUOcHRuZiEhv45tqIAe95zudES38TndX2Q366UqJ1BAo36RfD41m0+nbvuArhuEr+uaPs/Fdxg2h8q4TPb0k12ELF8geTS8sZ6YNWPikOuRRFfMHh2MJr0BVDiS1pH//oG2REbq8hBPyG3fpDG7XJi8FmckoXyfnaiVhBvbj9XqXKOe2O3wqIHEMsri2ZcynfVGNuX05Ai9YIuakgPaoCKhtdFhkwJ51yDAaBt9kfClt0GEXqn2IA4EFY9pXBfDCxFwwMpJ+ZcCMV/Q2j4DJ2DP0u+GyALdo4S78Vnog44a4SIYJemXl6EjzLmypTZbN2tw5zSnzOLp9DHp4zm3ytNmcvWIjurY4URB014l4lDF7blpM7NqtoRVKYnwnztDINuUjLSSegoyzVcpdswEnOh/zoC12RE9P+sNncFhrYuf0Z9MwawH+wnNws8paEcTuVX5BkWjUdYucHpUQ4Ca19c97J7GW5WH2sm87XsS7mrPnBjZGxx+i9sTWo0LO6Tul+vPoh8F3k6d4krdnTqK6RGifXlZ42ChUq2HBOeZ9+rima+5RP42G4CJzSBB8Hg1kYuIE62L+4JoGymw0wdYzIihZ/xWIGo6tUfggjJU4OfvhsyOe+hGOIylw03MvOt+9uBk6CAiKL8Jkba5XIKim9lrFRPNJ65tWxsDoui5DmTJgb580NOYUmjvdqJE/Toch0c3viQywKVngGI1/t6qq3rNtZ9461929Y3TY0mxJSpqUqLZ8JHEbWYy2/04O7D4plmVlKzgtw4kdB0+PoBRRg5fz+RHTG/1uyZxcbup/oeJObfwIUVHCsErInJ7wj8v5dynBgY8sFhQHcyD2HQ8w8mxUpOC8xN0Zaoq9Q6Es6VZnSqHci4wzqzCKEVuIavLwxC6C52mtTLKM4UIC5HlcmRXqwJmbBgFGR42R2LLGdxc49GR9Lsi9s
 zLV5uf1m
 JPP/yGlmVi9995+faigTQZI7T7I0vmTMy6xOTsqYXJKZr3/0SU41HBZG1duOxPi6IPmP+OuhsOYG63SB8so0wlh0gSfME0pyaHr/bOVQ10TGPxAuY71rc3kUOsqXlWVDoXUfqvCrn6qAJtiphBL+kr4hHzUbc7Ygca4bgzXUCY8tIB1ef7NFXUESewh2zNwVEv9AxVZFBVSsNSI9VFvxUFwcryqv/XwxZ0efOvc2iNZDZ56bPb2UWUmodvMM+cNYCQDHyyyDT49UvURoTh9Pa380sXI2rUzF0o8d4d/vk6X32Ie7EGpz8RNlMaN2csJIBKwxRT5VvpE1P+XTh+aj3qjuDr+wqfE5abKy1VKLd/txBVtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we are waiting for long I/O to complete, it makes sense to
avoid holding locks for too long. However, if the folio is
uptodate, we are likely only waiting for a concurrent PTE
update to finish. Retrying the entire page fault seems
excessive.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 0c740ca363cc..a2e4f2d87ec8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4949,6 +4949,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 
 	swapcache = folio;
+	/*
+	 * If the folio is uptodate, we are likely only waiting for
+	 * another concurrent PTE mapping to complete, which should
+	 * be brief. No need to drop the lock and retry the fault.
+	 */
+	if (folio_test_uptodate(folio))
+		vmf->flags &= ~FAULT_FLAG_ALLOW_RETRY;
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY) {
 		if (fault_flag_allow_retry_first(vmf->flags) &&
-- 
2.39.3 (Apple Git-146)


