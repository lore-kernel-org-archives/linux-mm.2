Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A1D606A322
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=M7UjDaSE
Received: by kanga.kvack.org (Postfix)
	id 0B9A76B05BB; Mon, 23 Nov 2026 18:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06AD36B05BC; Mon, 23 Nov 2026 18:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3A26B05BD; Mon, 23 Nov 2026 18:39:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAD5D6B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94F32C0A79
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:44 +0000 (UTC)
X-FDA: 85468003488.28.39964E7
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id D9F2A40008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=M7UjDaSE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3vc4EawgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3vc4EawgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477183;
	b=RLTONi/+wy+dlzzP3WZJuHXalHoquRKorB4HvDYUUQD4VFAxHW+GL4lXSpRQzVWQ0da2e7
	EWT537q1uLogXDNY4sC1agBIBPU3C8hYxVm+OgAKPccPlNI+SC93kRODTi+mFz2AbTIBQ9
	c1csdU6UdO2f2rgFvgpw2/+oqTmAAGA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LV8lhNkJFfTRLs461bEq0N2TyeH7KvDdqPK2bQlIlc=;
	b=LWeGWpC+C46YfsJ5pxzI6oUNVheBdYP5gdo/x48mUz1dszdGeEKFCajUnbV09WabUxBFht
	oP9llJvqPsywIAJeH7Udz7anYPkmmkxOn+G+dFZNHbV60FYaCqHrBfli0L+yku536iZ3jq
	I3vbKMQbNeiCOa8zqy3ud0FdSoJ4Pmg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=M7UjDaSE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3vc4EawgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3vc4EawgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-57289376805so3952718b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477182; x=1796081982; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7LV8lhNkJFfTRLs461bEq0N2TyeH7KvDdqPK2bQlIlc=;
        b=M7UjDaSEU4GstUPz+ueLNdEoYFWXujk8qVKkl/753dnlvvWYYi2sz0s23L9Gt8eMEm
         MNdM6f6G3XPO+wNY3ROZjH0ZgvXIS5HmOlTmLhc75UEg9gncBVW1LQ5Vhl2IjTgMPouq
         ZdUG1/mAWvdRKmNT/RpDOa5O8oEAOt3KNxvjWrqfj+WwxiCmoxGWdNwPZaol+2+wcB0C
         WnIrF3RXdbb7M8clpniQbFizCFtDnJZk0jLpbw1YKWea9Fqs+S73yHEXqiDFf+kStwMh
         FSRHRbSCESB+ZAB37Mvy5vYGzM8ANAuVa8nz9kbRS/2jdA/k/ffeC5Fna9wd/0v9BrYG
         l8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477182; x=1796081982;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7LV8lhNkJFfTRLs461bEq0N2TyeH7KvDdqPK2bQlIlc=;
        b=fM8IXbOj1kfkr0WEtW9VMgVytglZi+xlPyXXOBwWS1TU2rd51T1GNzhu+et9JGWNxA
         T2hjQyxnPfGnY0fjpAxBPAIBP603gCV3sZoSdquWSWhNJZn3XY9vnLLqL6mDzYhyHlXM
         TOSu4ijqWW2uSLrPIDyhiuMkKpwwGACIAXdDlD67kFBNIpRB7oXYglY9EpS8WFd2WgK/
         eBt1HlaCLqGEOIiE7x1VdaJYlIHdRzwXCEsRL9C7csEpGaAMYIiYxKaxQsEdRxQtV0H/
         f5nHGseSRkGJB6nb7Ko+MCh82XVeF8c4yUEL8hP90UV3lZBf3a6n4KVSPT6wAftM8hWw
         uS4g==
X-Forwarded-Encrypted: i=1; AL+hErH6zgcDkBQ4/EsnnPuph+ItSHq9LbivevNWLuzTt72zplCqwRLm257qIV7Fqf4+rZIxtopquunu9w==@kvack.org
X-Gm-Message-State: APuU4Z9VSj/5McQpN8b4oe27JHinFxtP8w36iY/cAUIPQyfGMcfK1C7f
	Dnv8oLp7hdYCK6DgqOS0XDK51UY7TOkgRgEmuMkojov251noiEv5WnhD0+F8RBaQ/+J9j1uCGPQ
	+RcTUOm0cIZaP5Q==
X-Received: from jahq23-n2.prod.google.com ([2002:a05:6638:e017:20b0:620:2968:9641])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6711:b0:4c4:a240:9c3a with SMTP id 5614622812f47-57a077151demr13100240b6e.4.1795477181670;
 Mon, 23 Nov 2026 15:39:41 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:14 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-10-dmatlack@google.com>
Subject: [PATCH v5 09/18] mm/shmem_luo: Don't make early retrieve failures permanent
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D9F2A40008
X-Stat-Signature: 5yyfh8eurdju8wrjicfcxmrthhq61emn
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795477182-222337
X-HE-Meta: U2FsdGVkX1+MSeiNUldh2ckk4gRagxhaPGeVq6Oal4LTgEFW+ETWLZsr0zpacXPmYivHyY9FJsefTsatkRoGFWWdRClIrHNvrOeVZ+OP78TZSQipNrB6MxvdQVPP6FegtllqGjK5zTEhwklRrKqMSuOWR2/PmmaZF0BdodAWrZyuxzsTODQa6scbqKJtxnz3BWrwf+oTBt7CDX1U0iISQKk8E1+PQiImvYPA+3Ie4AzLn+gSHgyXsl+3s3feNJXPHd3l4OSohNlyxcxK/cPogOfYph8QwBlm5qMLC9Rz5aCYx1pyacKqXbxvIAlDUq4Hwt6se3Q1HIG5Zl0cd1bwTITYJ2bugQOtMd0TZjEjIq0xzc8ck6pt9hB9mr53AEBiK3VW9W4ZwMWNftMTVGa9DA8fqBxNq/FyMLKgHKpUhyTKBbyk1camQIVPLJWIwG5ebG4OxRtFWJWKnp2v4/13CP3DVWfNHkglxhx07hnbq0KrSHRAIlh6MV7p0mVA4mrdGtLcZ58NOb2ARV0KitGMu2/KgAIMzAQHhKSS+AixHuQyjmPzwk8PWaGe44/jETpEfu3o98fkblCmTrqk5omnvQifJPqVfSK5otxT5yskz3ZOh9/O80drqL0xA1RgbZnKlTxFm4idXqjp82rxycrTOcSTrEBOSk0LH7TptTmSZUbKTJ7CRJMI3AMvwGE7tYKbPfLfWewuRW14j0lHR05YvC7hjRoS5tjKCC+6pxIOK3FMzvS2eIeo3nJjenLbKGRO620tR2Y/D6kCwX5Hf0P/UeTYrtjPDkB+FJ3wSNsMEhZQz4p0xJxxLtDe64HoPZudAR2KwJ7YeMzqauSQekEenUvgBkJkeDS8zxuBbVTVu3IQynHlgB2iz3Q4QwbkD9BWoJ1pCYurtOYYiLsCtydNwRTJvhnWvHASNXtIeGXfVbdyG6caKZzbv40zLyaHfiI+pLxGukbJzIxjOzlPIvd
 WqH2bh+J
 n0gal2RGRTcwbO5fkCSNJxgDrVvviDFFol5RzotNi0TyCdgvwq0QrQ8/KilzB/PGzqOqs16bLoxDnVNcIEWhjIaXkFAcJR8Tppjqt683gGBgml6hP/RF+WhA5fvFQ8Rk8C7ENn7lJAZVyYcp7Rbv4BORznHyw6BoHlR2G9AqyuOBfcSB6rx30KlNEFjNfnJh+9jSbU/OreDAJR5n3EerAB1LF15+jEqqCnaLY3Pn+yTJafOvI2KvrWFyff82FdKpjSVVEBS8Sot4e762BlCwkgkym+cPpyA6Xi1cVMAWrq2NBjnULYVAb0AladmT6FIICZLO7ZJZ86rc2QN2s34MXljkzjhHWsoKb8RzjB3Xs5XuN3ioee4RS9PteFBSEeDPUOhkGVMfOCYgc6LPNR0C55tXPeJItjbAx5N38laR68NIU+MHeL6zLJgWHoV5URhLhhOS3qiPthu2TEn8aQ23nTDtdygkVt9GUw7Qsmc45ASSVMBz3BvwfTvyXiOpvXxIPxAtFLoCf7J1/wnpU6O2O9vRbGpQWB7qKFYwBg3PUOjaLoW0+0rXMz06w33qeIQXChCzUMH1Y8xLMJkOcgnolLpRJaSqAOwRBxg2gKGY075InztXUaIaO+HXw0iY3JoFkMQKbthi9VvpehWSsjGMX51dzeY6ls1RzOlCcRW5ESwWh8RGhByLMEb9RUZKYvBt3w5uMBjKN7WG51vp24xtkXjW0+whWQEeBxsXR/SwiaYZkLUmt9t1X7r9x8Y3WO6DakBJLIQNG75CQ3gSs8364dEe3BeWad4dYAfuruxecXSivsp+9XzuEUzVF6TG5uBghkJSxDIOU1a+36wp7bW1r3aFz6rzBEYIMSS7nXIrwlbFnVgbj+nJmSdXXh3htXRwJFpTIV0mJA9m3JqKfk82lyX9OR/y4X6/dXYQ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mark failures in shmem_luo_retrieve() before it starts restoring the
folios as retryable. If no retrieve succeeds, finish() frees the
preserved state, like it does for a file that was never retrieved.

Until the folios are restored, nothing has consumed the preserved state.
Leave it for another retrieve, which may succeed, e.g. if
memfd_alloc_file() failed with -ENOMEM.

The exception is a preserved file that this kernel can't restore, e.g.
because it has seals that this kernel doesn't support. Retrying can't
help, so keep that failure permanent: every later retrieve returns the
same error.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/shmem_luo.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index e747a0442295..46b33a00c2a2 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -532,6 +532,14 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 		goto free_ser;
 	}
 
+	/*
+	 * Nothing consumes the preserved state until the folios are restored
+	 * below. If the retrieve fails before that, leave the state for another
+	 * retrieve, or for finish() to free. The checks above can't succeed on
+	 * a retry, so they fail permanently.
+	 */
+	args->retryable = true;
+
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
 	 * later.
@@ -539,19 +547,22 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		err = PTR_ERR(file);
-		goto free_ser;
+		return PTR_ERR(file);
 	}
 
 	err = memfd_add_seals(file, ser->seals);
 	if (err) {
 		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
-		goto put_file;
+		fput(file);
+		return err;
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
+	/* The preserved state is consumed from here on. */
+	args->retryable = false;
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser) {
-- 
2.56.1.809.ga0b61035b5-goog


