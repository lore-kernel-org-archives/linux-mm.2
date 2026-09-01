Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B5EC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B116B00DD; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904AE6B00DC; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693886B00E0; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 422366B00DB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2A451C1D07
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
X-FDA: 85163927016.13.A640443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 211EE180005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjwMQpj3;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+5n2m69nUp/8eBxRsZKrpQRqRxmZwpAKuJfK8YQaNw=;
	b=OCTFmuTbZLwOtoHGwmTkb77qPG9CgVUe9uVGAOV6rYcLmD0SB0bhecuIm1idWR3p1Q64GO
	TDZssC/MDSVoypRnL4LjqFIGzBjBc+fTelMt9R4vAQZJqALpmBQ8vCsqEqiiCdrpfP0ZUn
	jwCqoQ/SH+RDOJGHTpFZNB2qXQgE4Z8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237267;
	b=iMjgW9t7ZhPVz4Mr3SGObw8q9GAX/Ax4EDuQYHLPMGYqlnUO30k4/QIxbXlYy06nlVslJn
	lpbGk+Mu0rXhJqcvs+IgSFmfHZ1SO5rXysI9JrIEjsAsDI3GO3vulrC2195YDxy/US1liA
	WNCXM7c7/UQFGc0TTTPyrnIgpVjGPmo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjwMQpj3;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D28144013C;
	Tue,  1 Sep 2026 04:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923571F00A3D;
	Tue,  1 Sep 2026 04:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237265;
	bh=U+5n2m69nUp/8eBxRsZKrpQRqRxmZwpAKuJfK8YQaNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjwMQpj3Wrb/6erZFWASypzljTlgEQ+oER1CXJfcnVo3griBMbAIy4bpGwhfkiVtc
	 mQg0Mc48Ji/5Y/+VaSBbR395CYi0YLrtjEZLRwPF2bUPIwoQz8qsHOXbIZNWEy6Nbn
	 MdUzuH/aeom/r7+4r5mN5r7xRGRcqLboHE+OSJOdmSVFUEt9W3mjil1gqP7jU7XlmI
	 hvE3ckZMTIIOj3n2UE+YxTPQZtnZ5KOwizXfBGPUQ26uWqjhtZzie78GPMcNqgj/Ra
	 MvKYybYiR/SrnZDAKmt12QGmtHgPK0ZqWS8zM4+WkloDq/4fTojMoP9gwa4uXncHmc
	 vfJZSWNm0NUZw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/17] mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Mon, 31 Aug 2026 21:33:57 -0700
Message-ID: <20260901043417.2165-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 211EE180005
X-Stat-Signature: tskowi4xzw41ck5bs6h66ph91sjhojjh
X-HE-Tag: 1788237266-66595
X-HE-Meta: U2FsdGVkX19XBfqtjYlx8h1r/xV/AxHDEyhYP2oa8ScXDI5Pz4FKi44iEGL9fNaUvkpoWsvbvpF839vmJ8IGuXZr04fcFW4nppUE1x1+GAsQpt28Y4r3mcxVZs2bgABUsmkJA1u1Sk5J0uDcPJJwFeJYQYUqQFO5qNhxgoJPS3w/+h15m7wb0vPiCXoBhlmvmidsTogSw3z3YGZIwtyphjciwKXdKGGyKtJYpV3WvGrOW8QjZREttthBF2iMN/+ayD9TKCl0O5d4Ajg0kXI3Y8dTIfJaKASBq/vmW3Hdv+Cm1nw84ohhISrpvgu+XfCmolLnfe3bnndhbO9jaNj6qAfF+b6+ibS+zlpmbCGwdMVDXUZiG+fLO8Jvnxu6TQmf0a2VcmiHFheWFiq11FaoFuzpMv5Oth3VTTR5UmRAckqBHwp2HPMLXTEIpaXjXTNXqR1/fOL20RUKeTNQTZ13RcuGU3dK3f9hCpjvlpI6Gj/T7Byu9WgolYVCL7GC/UcoARVQJumClfnmQcioz78yi0uU9FcrKek1NVLdBimgy9Fi+u+exg53EZVwshilO63zzIEcl2wg66B5C81ncpf9BhUX39Hp2ApxKY5tbjSwCcyPXcyjUxm93ocWWjyvDX2Aun6fqqAM9cFjjK0H6Tfiv3WfOqeyrN+dsq71CA6w81tpwaNDwWSwlTqVeareZr7f94+TlRloNg+AA9fxOxYw/b9ZObVth5VAa69T9pn/vJTDwW/GakqwOEQ9hkWP1T9MSW7tYNvBKWx6CurlBymeKwWnvPNAlRp+67aDRvOHgzofBrbI1knyD7ZZrq/9AYZmTr1gUj30UomqRkWLVup125hr+GiO73zJc99zQsZQCyLcTZ/W8AD9i95BPgypDg6yGLLBq8H43EU0i8JRKgwK6RCK26LekBl9m1YfISQ2742fTUis1pcuW6EdAQTXVoztQZHnPNr4YlC0MWjabzP
 0aUyPmkr
 Gz9DrBTXFQF4hIn5bUuB8LpdLn53VAOSto8oIjkbpXazHxOTqK3eM9/dUKzlQnh+UXELHZP2XVtlYb0zuJv5YjrTi/e/jrEvOlKhilInnNnC0W71kSjIEWuxrzDJvMQzZXAB5bO84V2BdV3O7wsxN8MxxrqbnWPqV9+jesxm/zRQvhxAUPIn8Z68p1c5ZrvwVZVi9ckpuYNeoD5d8pMe0oeoT7y+LmFtMlIjztLxGkQlVE2cYEwIQaingAFAx434hPNOAG1psoRR6CRgemZ3nYpulhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON filter type, pgidle_unset.  It will match pages
that have their PG_Idle flag unset, or the page table accessed bit set.
In other words, it says if the page is accessed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 7b1b6050a8286..7a42cbe791845 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -745,12 +745,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
-- 
2.47.3

