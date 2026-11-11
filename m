Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6F9606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nrduLmqw
Received: by kanga.kvack.org (Postfix)
	id 1B7BD6B05B8; Tue, 10 Nov 2026 19:24:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FA66B05B9; Tue, 10 Nov 2026 19:24:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031366B05BA; Tue, 10 Nov 2026 19:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C65166B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 527D7A01D5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:19 +0000 (UTC)
X-FDA: 85420941438.27.C3D1766
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90062180002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nrduLmqw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3sLXzaggKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3sLXzaggKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPv+WMWcyhJBfMpWVwqvVEabR827fX5uGDPeWoliS18=;
	b=G9meFGEUMCyGUXisd7dp4jGiW303lsNzAlvM3ebw5mNSAgjpPFrUonM6URh56wxwkoI4Sp
	54Zjpkowr4NnqYHINq1q1BvC0fjEDuCEl7Jm2ja8ZD9Ou+Ga2M1jIHxgQQFcM1uwD+crkb
	jq4vkqR3a0O7Z43l4NFUoROTOi0K2QM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nrduLmqw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3sLXzaggKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3sLXzaggKCEkoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356657;
	b=vKwjHUKa2pj5vahM3SaeDvEzHCC4i3i8WGuO+YES0Yv+a/ijGAURYfAksu6G8QdHtBdQX6
	MFD7NkaQJhrORxrkJActdz3VXBoVLmZJ1A8pffG4TqEeF+Oixm9QxljQHDeZnDD+Ri7GV5
	HWS2NC8kTiwoj3ZZxaCF82ZcN13bkf0=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b37620eb73so3797945b6e.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356656; x=1794961456; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bPv+WMWcyhJBfMpWVwqvVEabR827fX5uGDPeWoliS18=;
        b=nrduLmqw1pY7OKsjySuxLJQHCAAtscc8riA0fPPG1+bW7hAEGphWgo3RkvqO0VQqsl
         ZZH6DA0pS1bPwO1fkLg7De7IwZ7j3H0/hQTw8VeQNN8jc1vqF5r4lN43s0fV5LCawZ0F
         s0C7OuC4fYco/p2kuGItSOzhSisb29AcOL2K3dVMKfEiJ89onUNlipZ1KBCaLrZo6rIE
         aKvN1kRs9w4b2eWPPxeqTPuRcApAsWKKLVr+lY3yutRoSPO+oy4pvznK3x1nobYa0qp0
         wg/toAGds5UTfKppVqZa67KI7vFh0KB4Ud9fHxKp3H5IFaT1qTiKpA+Q1/1dF/r6NZYr
         TRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356656; x=1794961456;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bPv+WMWcyhJBfMpWVwqvVEabR827fX5uGDPeWoliS18=;
        b=N+4EdY+s7XVWLQmnzwXoqX2/yhzS/wF44O3oqa6MqSLtmMJtT0KNxMZ4FsLcDMJpmG
         klUiLLqrkg2an6MU9NyG9ASWw4EIEuNJ7lkngEOMomZk6Lzjp9vqJ522iLbOzStUpcBr
         ssDtjvVedl+NjZ2C2B0taGNJov02ZpXi0kmehNj0LgZ7iNv9jUR2JlpGUl6Gu6UY845z
         U8u7cNq1Y3Fjq9IByVUE/bfgwhwkdPGTe2ZwGAyn7ZK3myq0zOrjPqQNLzTFOEAg0NpO
         aVHMkalyZt4Xge9SAGZM4JfNMxPNokhequK3N9sMpW0vFYWC4qwVQ0BXaFA5CG8A7czy
         JwCA==
X-Forwarded-Encrypted: i=1; AL+hErGUmmSfhZDXaAQ8AXteXi1cdqJHfvp/TjF7A++hTEckgfhe/e+DSI7fGQMYVG6NCGogLyOdLUR+KQ==@kvack.org
X-Gm-Message-State: APuU4Z9L7cSv+iDKotLLlqKLAfH/rZKY5k6KmCsELHYDJpAZ+d6GXuMG
	enzsdPHT8/edHkQ/fD88jKJLFFroQ9Ch26j5ynHx70nWlnLlz4GnWl3TWLqW1FdmHPZ8e4RJTIm
	aHdnPVl+tLSG82Q==
X-Received: from iocow25-n1.prod.google.com ([2002:a05:6602:c5d9:10b0:9cb:8099:40ad])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:e88:b0:4e6:db9c:9a7c with SMTP id 5614622812f47-56b9891f794mr602405b6e.63.1794356656227;
 Tue, 10 Nov 2026 16:24:16 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:45 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-8-dmatlack@google.com>
Subject: [PATCH v4 07/19] liveupdate: Add helpers to track the files that LUO manages
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90062180002
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: f8uabxrp69hh8mh78z8m3u46sz75z3b7
X-HE-Tag: 1794356657-631452
X-HE-Meta: U2FsdGVkX1/BUd1SfyuFHCLLZ654USgsTJVIkAAFGanDNkt1UYC63G/w7/aI3XWN9VbyIX/PlFZ8uMJRk2bqxcyKaYsWSY5c6d8ULC562J8QV1+YDWke/ZH1dNsBE8xzq+qfUl8hfPUtqzVyjnQppCcOxlOEt8JpJfRVvLRsuPe8I/Kmv+eSQHaRkkfK0QT4m+v/0qBt7HGjGY0BKiNBjoY9jNfYafvJcjAkXb5/JzQYwm5Sk3TXOrDJa8/okPPoayE1LQuyn3kx1dVlCXwukBazhGcHBULvi0nKhCd6W0mCUa1A/N8dxoGDfF8You2lhD47XxdieD8v99ZYvpQKh/nAQ6K/bVk8ON1tMVOqGhCvPjoNfuiuYVqRdUXwa3uY1b/vdXBhCi9/qcgLuoobwjZigNQz11uxC7HZyTV7s++2/j24Fvetb8falwnVP1HRijeayQLSEA6F48lY9nqh61OR3jBbvqgamsOjQMAsHRoKgzPORig3DqN+P91ZP8S32SDJ/ECTXOL8tMXJq3Pq94CL8nYQ5fzTwlunwRjXmrfzb6sWHTh6kAGifJt29wE+z1keLMKHIFvSK3zv3W3GnBO5djjG06Qqwq5R6DT/tjtDZ8g7JFyFeFfJTZYlMnozFQrhBKb9K5MGvzbuSAW6jgTe1fBHhcq5BTdgOEkLZ9698c3bG1/zbs8crOYlup4v5LtNpSDCGEHtwbm3xdSFKohrVt02oFnwibQ+aU3mGEPEGwRCHvam8SngUU98phTYmjmwa2pqCh6PPtptpt89sOPqdFZlHwdbfZJ9ptYI0mTVvnG7ZdmasyuI6MpG3vfl3MRQs8VuKtSeuF0W4u5bthshiKdCwQV1nFl2aN8fEMiNAW4f1rb24tlDVWOT4yq13OP+3Px5gvizwF6fwern5KwzFeYymtZ+gIgAmj65ATSBZ7toDZsZAvMo8Oi4um1ZxWRXzRUP9ErbLVFQape
 GLv/KvZE
 InJqE8PYIH9nMTGpQEPbyHvYiSqtTvVhs3uZ4/wj/qwoD8yqZD18rdDeOQkNXUP05YlAerb8XNyNH2hgC0z9iXGBIjeOmC0plDOWoXBKhdgK5sVVqQq0cGkkvcKq+taxJ/gOUpwfhIw285TRSHVbCVujw+945ia88fncX5nA2CRn+lvWQNYfEbahx0W1QQqX3I+y1PTe4jQM1eUse2oP9hcRv9pJM2c0VeHcIsyyhYC5xCGO5F9xCOZjVvXewX6KK3fc0NhdD2DIfxefiUqb+MginwRvc0pA2XiMuSaFMNSi2KReVxbU5jZUC451XxaVcjySxQkn3deJ5OApv47j3dzVfQ5hX9ASv9o/bDlDuDP/NEXAHQfF9FuSRYtHpqastHOCTK+bnKlzrkpnjp3IuA9SClwSCa+fjeO0wWfQC/nfMxUwIEtyqHM8LVc5JEzcZj54LEEmDmQsPoEjsXu3UUtSAP4vIGrsGbQc+KCdwLtuNJZNVZxvCqVd0q4gXbHdJc+mWLCpcYoq/+I+DjqvYiDAquRjMCtRYIKTsWHrk4nXo/VNWuKW2rUh3jQFUxSw40N+m23ZKKri6PycEZnJjsRR43A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add luo_track_file() and luo_untrack_file(), which add a file to and
remove it from luo_preserved_files, and use them instead of open-coding
xa_insert() and xa_erase() with luo_get_id() for preserved and retrieved
files.

The next commit lets file handlers make LUO track the file they retrieve
into, which adds more users. The helpers keep the key and the -EBUSY
behavior in one place.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 kernel/liveupdate/luo_file.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index e5d333649f76..91a2b74f71cb 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -192,6 +192,19 @@ static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
 	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
 }
 
+/* Make LUO manage @file, or fail with -EBUSY if it already does. */
+static int luo_track_file(struct liveupdate_file_handler *fh, struct file *file)
+{
+	return xa_insert(&luo_preserved_files, luo_get_id(fh, file), file,
+			 GFP_KERNEL);
+}
+
+static void luo_untrack_file(struct liveupdate_file_handler *fh,
+			     struct file *file)
+{
+	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+}
+
 static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 {
 	struct luo_file *iter;
@@ -306,14 +319,13 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
 	if (err)
 		goto err_module_put;
 
-	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
-			file, GFP_KERNEL);
+	err = luo_track_file(fh, file);
 	if (err)
 		goto err_free_arg;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
-		goto err_erase_xa;
+		goto err_untrack;
 
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
@@ -345,8 +357,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
-err_erase_xa:
-	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+err_untrack:
+	luo_untrack_file(fh, file);
 err_free_arg:
 	kfree(args.arg);
 err_module_put:
@@ -395,8 +407,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
-		xa_erase(&luo_preserved_files,
-			 luo_get_id(luo_file->fh, luo_file->file));
+		luo_untrack_file(luo_file->fh, luo_file->file);
 		module_put(luo_file->fh->ops->owner);
 
 		list_del(&luo_file->list);
@@ -668,9 +679,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return err;
 	}
 
-	err = xa_insert(&luo_preserved_files,
-			luo_get_id(luo_file->fh, args.file), args.file,
-			GFP_KERNEL);
+	err = luo_track_file(luo_file->fh, args.file);
 	if (err) {
 		/* A retrieved file is new, so it can't be tracked already. */
 		WARN_ON_ONCE(err == -EBUSY);
@@ -788,8 +797,7 @@ int luo_file_finish(struct luo_file_set *file_set)
 		luo_file_finish_one(file_set, luo_file);
 
 		if (luo_file->file) {
-			xa_erase(&luo_preserved_files,
-				 luo_get_id(luo_file->fh, luo_file->file));
+			luo_untrack_file(luo_file->fh, luo_file->file);
 			fput(luo_file->file);
 		}
 		module_put(luo_file->fh->ops->owner);
-- 
2.56.0.542.g3ef89b7020-goog


