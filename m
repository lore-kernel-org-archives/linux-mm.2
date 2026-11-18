Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7AA606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=e9lUJF1q
Received: by kanga.kvack.org (Postfix)
	id 5804B6B05B8; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50ABE6B05B9; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4209B6B05BA; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09F4E6B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3EABA8547
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:53 +0000 (UTC)
X-FDA: 85448854386.05.841E6A5
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id B277580014
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=e9lUJF1q;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEps8MwFBHLUNYOgsiIcXMOSURq2STHzEmDOrMOD5BI=;
	b=XkKqZ+bg7SVzWGJJVI2a+ECwl1qS+kLcbbZxy6jnrUQzwacuEltsxgXR6zXTSB2J8mbjGB
	bxXeuVRR/d2nWl+gbiJjjYROa0ZeRYlMvKoX0kRJUJ+RFu1+N5FTlrRsRYuZQqB9m/Lpkc
	LA3mlbf7ux1YTc7cE0FXCZiiYw6X1f4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=e9lUJF1q;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021251;
	b=1SVRB8DCjugbb5mEPotp7reL4P9TtLLE34gJqf+20NHNRdgH2CySOqudlfLcZeZB3R7cOg
	YxQPKFl3Ny2Ju+J80ST3UAV1PmV1fpW4tWO7QanzhPGBhUSAmHIbeKIGPKtm+466WQEZ1O
	2Jq4ra7jI8WdzxuuV6j31MDEFV7kbP8=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55d360ca878so9511151cf.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021251; x=1795626051; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yEps8MwFBHLUNYOgsiIcXMOSURq2STHzEmDOrMOD5BI=;
        b=e9lUJF1qpgCEAiSVQQ7rGux5jQ5z4+gS9IXzSwDtdM0rKYbZHCzmKxgUe5g0VmxfMk
         pk/ZyRywxCfs0n1SC7ij6kMdi+ZqS3R0qLOHTVY+/moGKMOxtx+OQn7ZsL902tJhKmZ0
         oIWDj5uXM6xqeoxsouHI0Z3RM5/4GVvBUzaUo68dHudkdESvzvm98/H2H88Lfzvj13TL
         eXCBOsWv7DYsMbR6SVdzPbtnp/n0V14VG4gA6v4eyKsPvLXTkAY7oVIXZbJJg2kWpprI
         fHJCL9fZfe8Pu9x2rbww2g8HRbFMnRYOVWhxrpwTW2mC9hTeEvLesUFxhtgDti2nOfZG
         mjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021251; x=1795626051;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yEps8MwFBHLUNYOgsiIcXMOSURq2STHzEmDOrMOD5BI=;
        b=abfJSqu0y3kykoXVwR0t347PXjIbHB9KGTtTHHTiGqE1aMZWB/ZDDvyyD78OV1pNhw
         ApvCPO+E/PSWzdjHgyvUg7SHp6I6tSWXSw0CI3NyDRMJyBMYb7OedcFLrZ54xfennKDk
         g+7mBJ6PfInM9/2LpYB8tEdLX/IMIbEDAZPWNXJKyXJ6UqLaz9tZoUqyfiFpD1/KtAhO
         Oh7WknttKht92aNCqCYqrF2DEB/Yx+Ip5v1wtB+sJf9jhjkR171mvsoWPBu2DWROeuxG
         dapG/xicq9Lt6bRleUuMYU+4D9tNa5ZDMZ2SpCm2zdBJOLefLqJ59S5dFQ311IQ306aG
         TYZA==
X-Forwarded-Encrypted: i=1; AL+hErH3sSr6BnjIpzGIfMp14WZkFTcr0dPlxXSJgeaEQLdfi0EdonXpbgktQNMzdFLTr5qvBRBrJWEEfg==@kvack.org
X-Gm-Message-State: APuU4Z/ZTRE4I4yReXXJJge3QuGI8kGiB3k3RqEiht3M4fd+3cmvy4YZ
	kJplJw+BPCf4ozTDbTuR80p4acTojIIt9i75CwPbqyGsjm6pgPdOG7zuzJ2ZYOWD+ec=
X-Gm-Gg: AYBFou26SGrHWs3w5k0JHAgfRvGh9La0Xb07EnLt01dwa5NEwRthMd3amyqB3J2fdX6
	Thx6yf+S6qEPMCLdBRCIlcfnsjSGP6SMswAD5p6pm4EQZZlhNcNVvX5keK0uOFJwOL1i8Id0i0U
	U9Od1LIiiSH5iQM9RDv9cQ6nzUKKMr4AFnnINm4LKVeUDxOBRuL9/yZyZu5vsPM335uY5si0MIJ
	+cXWNU4LmaUG711tab3xfVw5o1XDYZ5XUeMQfsDyuKedu2gCe+sT1bGoB3jMxSB4jG3UYa7AGSR
	735XHVbl1mtMm+Ulln4PqIXa0LgU53A3VEDGMlKlle86KCbcUPGn0C6JzXFt+S5dN5SBivCvVvM
	ifxjPc8e/oEwF/ltTr0BhrBypDDv2JPki1Isn6uq1Irr3xuHmTnve4UEBvVTRzgjq29iV+gABDB
	oCcrlwEUh9UCu51QmsQ8d+auq+tbs8j9Mt6MzM1fzE9bEjKdcqnawNxIIG27Q72Sr2GoIZ5ablg
	fNrBvQhxX/u3TmwG45tNoKYJ4am5OHpalM0i8bEwWuptqRipu+WBZ2HFDBnbP4JZNT8ILQ1s3YF
	7vL80sVXpUric2aMdYkzwJ7V72SbVVlAk1eH8zlpJ3AB2A==
X-Received: by 2002:a05:622a:5ce:b0:533:4da1:b5d1 with SMTP id d75a77b69052e-55d5a554cbbmr49228431cf.23.1795021250373;
        Wed, 18 Nov 2026 09:00:50 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66bcbeabsm4188701cf.18.2026.11.18.09.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:49 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:34 +0000
Subject: [PATCH RFC 2/7] mm/vma: fail the split if vm_ops->open() fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-2-c8b0209f2700@toxicpanda.com>
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=3405;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=MPo/CJoIdrgMAroeMcnW9/JGGFTQxJ+I+ZEDJqJRapQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QIQIU8ymm/ATGb23Ki+RVIc4tiCbEdK7zanAzbWtgNXmXYclrgd7Pc8yhf3pjXxej19onY10zCk
 sL2OMRGTrEwU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: B277580014
X-Stat-Signature: hna86x6epp3ee1yxan7cobtob1dxh8b8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795021251-20700
X-HE-Meta: U2FsdGVkX1+WeV0SRzyHxAzaGXMoC/XKsEXYq0082mrXeQ/1oxJyzAKuLqWSZsSV3skrOjKfLFjtpvJAVkoH5Cef1wRGBYWzyjuXiS00IVuFY4hFtB1Ns5v3Jb2HTaYCzkMl0mEi77fcLk1bX6nmNhVDFRrhmVIYLClGyVCIOE2/5C/KZnWdYt7/9U0C+jI1K8JA3mtLvpVOeS8O7ukFlhK6UX01f8mS+YuT9YTyUi9zVOtfRKKi27q+YMV7GHEKS4b5SnJEy4XLjU1HOMUqUlSFHgKi3pyxDTyeG1hVonhTGrKwc9TtyZnIb9BJWTyqm7rsW9Vs+uim1j1N5rrtCiDQBZRz2BfcX2GucZ4FX9/lIdH1BWdgKGHyybgkqvI43R0n29c4cwC1tQX2EcHCHA3kuq6Z5QH3xpWiY7K74kCmq/tuVy+InK8S4PryZ4o4y3/TznK2C5fQ070P8EbkdW88U/M7RdxE/u2q+t+vdF62wh950xwHOpVneTIk+MV+0LVUN8jQakHeP0o2kmjolj5ASXHe4pKS7BOhXN78OgCZvHgRmGKjpg/75/AtNWXzIWB4ZASkcOpHgA0Qa6XuoUii+i9DkL+H99a+eCLX1cTbVYyPPQ46uQPFv11mm5KotAe5HmSXs8QYz6vpPdsLLu8nSzTWYgVmwAOQgR9pK3h4jSvtNu9leq+krGm5POfY3I5zozxhQ/dNl7Gs3CEF0nhFe1VRQkzF3Xcnh5ISYxiATstoAd7dPc9Yd7csBJLHcB0FgeOadgXYFKewDgEkWAh8486r+IFEeyGC6hj9PXR2O/l1Bxy+Or4Z4ItKddYx3tZoL/dOJqrUi1+xn+euWR7IWvwbiP0OOsdqEYRzqZWCJN/m75hwfetEGEea/9JxqztXnCLxeoNWzkklVPe8Gu2GZDcAeKjSRLdUXmT8G4fppoOW4YZDrIgvEVL+DfI2z9umq18gCKE3OBawXSC
 fx0dZfvx
 GPpeb8xDD9sqr9i++uE7h2j3nXgxAIv9f0DMxPl95zMXB59RVIzMMWJNS5neCUdZoYOexXbGXGr8PLoxfDAxVhrxHTmB562JaxdoSXcuyNqoG7/YKosh8v2bD/4ge0RcvA1Cj7ibIjh5wngBV+fkzDBURdxN5LpOkDR3lvMb/ADjFYDYQHsOHUgVkd6mYBBAWWQeGlVY2BiWm4oFhJZ0fcqN2Wj+UqAiaiVU10HAAkRqCM1Nj7pxVxvOKUgOHh7LenZf28soWl3mg1SaXhj50VYEYrHByJDxDVD8hBaODADktspwC6/Sv8xuAKVCnRdy+Dc575d/DbKeAu6nuLwWeen5h0ekfszrJxJYka1Z3NwGKarlihUZUqW3CP+rlG6dEsm6U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__split_vma() has its failure paths in place but ignores the result of
vm_ops->open().  Add vma_open() and fail the split with its error.

Nothing has been done to the original VMA at this point, so the unwind only
has to undo the work on the new one.  The call moves ahead of get_file() so
that there's no file reference to drop, the original VMA holds one for as
long as this runs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/internal.h                      | 15 +++++++++++++++
 mm/vma.c                           |  9 ++++++---
 tools/testing/vma/include/custom.h |  3 ++-
 tools/testing/vma/include/dup.h    |  7 +++++++
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0..ae7aae28a2be 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -218,6 +218,21 @@ static inline void *folio_raw_mapping(const struct folio *folio)
 	return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
 }
 
+/*
+ * vma_open - Call vm_ops->open() for a new VMA, if there is one.
+ * @vma: The new VMA, which isn't in the VMA tree yet.
+ *
+ * On failure the caller discards the VMA without calling vma_close().
+ *
+ * Returns: 0 on success, or an error otherwise.
+ */
+static inline int vma_open(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->open)
+		return vma->vm_ops->open(vma);
+	return 0;
+}
+
 /*
  * If the VMA has a close hook then close it, and since closing it might leave
  * it in an inconsistent state which makes the use of any hooks suspect, clear
diff --git a/mm/vma.c b/mm/vma.c
index c82e9306b11a..212c2497bad4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -570,12 +570,13 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (err)
 		goto out_free_mpol;
 
+	err = vma_open(new);
+	if (err)
+		goto out_unlink_anon;
+
 	if (new->vm_file)
 		get_file(new->vm_file);
 
-	if (new->vm_ops && new->vm_ops->open)
-		new->vm_ops->open(new);
-
 	vma_start_write(new);
 
 	init_vma_prep(&vp, vma);
@@ -611,6 +612,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	return 0;
 
+out_unlink_anon:
+	unlink_anon_vmas(new);
 out_free_mpol:
 	mpol_put(vma_policy(new));
 out_free_vmi:
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 744fe874c168..66a54ca9fd7a 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -35,7 +35,8 @@ struct anon_vma {
 static inline void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	/* For testing purposes, indicate that the anon_vma was unlinked. */
-	vma->anon_vma->was_unlinked = true;
+	if (vma->anon_vma)
+		vma->anon_vma->was_unlinked = true;
 }
 
 static inline void vma_start_write(struct vm_area_struct *vma)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index d418d9000b63..83d6caf16753 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1307,6 +1307,13 @@ static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
 	return 0;
 }
 
+static inline int vma_open(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->open)
+		return vma->vm_ops->open(vma);
+	return 0;
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;

-- 
2.55.0


