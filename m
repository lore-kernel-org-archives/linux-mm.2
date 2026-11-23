Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB136606A334
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jwW2OGbS
Received: by kanga.kvack.org (Postfix)
	id 57C396B05B9; Mon, 23 Nov 2026 18:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548E16B05BA; Mon, 23 Nov 2026 18:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C646B05BB; Mon, 23 Nov 2026 18:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D86BB6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0DE8C0884
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:41 +0000 (UTC)
X-FDA: 85468003362.28.9E81763
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 36AB42000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jwW2OGbS;
	spf=pass (imf03.hostedemail.com: domain of 3u84EawgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3u84EawgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477180;
	b=tO6XUPfyq0lo/fSSg+4lwwMv39c3fXtA5uyrDWvufQrFzyw6W0Pf1Ka2wEGl5F7f6/VHbM
	PEYBKdeBNf3V+bm5/emHeOcvilDoTFckS+NN7ZH2Cb69BBciZ6dINOUFeh/57HJn20a9sp
	YnRrhOPQJBIAxjAJ07zH7bh8XZceQQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0U5hcBRCn7DYeLCXQ7hEVh/crdm6HmQ04G7xSZHONUs=;
	b=MQwIYhzbkQD3DqA5TacwxiE7daCzodG2nrTGVnO48887PI1/FL7b9Wmi3kx+5YaNqG6u/A
	GDjiY5fCLupff12YYR4TiBZIrmIr+iNHMsGDBySzit0RdwkD25MftYZgLBV0Lh6biTxi5o
	HojpmN4cYKvDIs0uUrsp/TFTZ44x/FQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jwW2OGbS;
	spf=pass (imf03.hostedemail.com: domain of 3u84EawgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3u84EawgKCMot2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-862ad1e3959so2457912a34.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477179; x=1796081979; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0U5hcBRCn7DYeLCXQ7hEVh/crdm6HmQ04G7xSZHONUs=;
        b=jwW2OGbSEH9VqGnM6IWzccVnlpkzMHbVE/W0MHXu/kp3McKV+MheLbyd5jibkADB0j
         ZpX6Kss/utM34VKWewQbej+TDKiiTqDjDNUKIzobX3bflxTkLMoxoFaZaj3QuvDT2EKp
         zj7NtqbosH5Q5qEcxFYKFF/RWLrCcteDQvewQhFRyrrqgtzpwcEvjKlaD5wXvGFu/r5b
         eysB9V/ulolqHHGhGYydkqiReYKTUIx06Kj8QmjShsL91QGu/W74c9LWfn08Bkul06KZ
         eEsqkxJrt/bhSl6cPrui0wvf3NPZ2doGLgUW0QarrN3XwEy5HNaK5bgjf2FI5+MXyJQI
         4Rog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477179; x=1796081979;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0U5hcBRCn7DYeLCXQ7hEVh/crdm6HmQ04G7xSZHONUs=;
        b=SQR+f/pju7HZ8obrJnNgCy/qH5X0xiVoIsjA6WsGzBPlf23MCPa/DKqBrKGiRIqfez
         Eq6eOLXixPl2spqyHz8ikDyz/VJmoJAwslP9Cg3ZBNY4kkuOCkwAzho7ZsI2vFLDNYYf
         itlGFlqjE4yPWQ9F8WX3f2U17w4snoJAra+l+FIcvMvSvFyzMfVxoapnLU6/L6HoxToi
         oy/V48qBD26wIrp4QlG3XbeYe6MFPfQQvSQZ6Sed1k7T9at4xnoDaA1yfWMmF0Esnblm
         X6YDSNn0xj6gSWHXjgkP3RcifYwZCvpZ1fKKw+PJfjOnNBcneV6hx70N6daGaWyiGSko
         Wcsg==
X-Forwarded-Encrypted: i=1; AL+hErF2NdLarjKuHe5QW3jkVSZeOFP9VOi2p6anohBwWmZ5P8t4EWfzE/RVJYkSY0nPYdWZ+DeOp5vWyQ==@kvack.org
X-Gm-Message-State: APuU4Z92PcRH3kcH+7a1k57YFFiDVf7KmVXYyWCGVWZGRWvHPItpmPbt
	TQTshsFFM1lwvWo0u0vkUlp6yLkwTuXKbFcyfhvHBk3iyGRoNTvm5rUctm1iDaGyypiQvv6VEgJ
	lPwOBOFHHA9x6gA==
X-Received: from ioi10-n2.prod.google.com ([2002:a05:6602:c64a:20b0:9c7:7dbd:f35a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4fc9:b0:573:4ad5:7e4d with SMTP id 5614622812f47-57a0ac2fa3bmr15601210b6e.35.1795477179082;
 Mon, 23 Nov 2026 15:39:39 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:12 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-8-dmatlack@google.com>
Subject: [PATCH v5 07/18] liveupdate: Add helpers to track the files that LUO manages
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36AB42000A
X-Stat-Signature: kewb54sgnd6zkgwr4fcs835uq6h4ckxc
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795477180-488981
X-HE-Meta: U2FsdGVkX1/lRZ7zt/Dl/xo/4YCyE4037S94CyIJtwe9H+pCZAkmfgoWtQqwHSMpeepijFRWHUm7ojSXMncfawSiLWxyLOLuksIHwXZ36U7HMgBQP2sfnnElr7gxKv0rzYiPuf5ZOXQfqNY+baiA65hIE0CkaHrvdT9fEzJJSshEe1ZY5G686v9/xm98Thi82uxuloiL/MQjIrt36cEusufdMCUX5SttisnQ0bLVCoY3pfbcmpc29iq5SxOc4p1oaADj+lQdBf0o1UFBGNuab5HZvPam1H1cGHcrgedAMhGJUfF9AUBjJKKSNrrDe8ZKNx5/K9FaWVdhWDeR5WB/7HxaRko5t+EYbIqBul6DwXpqZ0FDGUWllWFUTUvmlPrecUJJpGN6bMe2VcdAzGQykoE6kFnreqz0b3YJjVfKbhvvvNT59Vn1xAiRhbgNFXrYlD558OtLV7ThoV7X9Wy4ne2rPwQ3H99OoxLgEWvNgVq+oRzhoPNj3SNfVOUXC6ou2yMVI8ZSkpzPU7dCVz/djHv8Ms1LKJ8X9YenbDORNAsT1+zfrrpi8d2onkt12pZapiToRwBt5B+bwAg8qC4TM6QjYwvL7utbdEY4qA9s8HKUV++J7J/glpJ8i+YEPJWt+hq/yavIk2uAxVXmuikL3jeVT1+CNE+eBxMXYXlVr7zH9rTAEa5IbRt/o9wg8UMsnOPauf7LyxXwOTnGhfnPqOWBWN6ppyf+3iHnC02Bgl8OCzRaObbasjxHKfdBeNt3ZI+CfVvqCjnzFeMufPsbM3tVDFVl2GkaeSlRQCeFlA/COinbk1iVfNWFq6ghhA8dj0AeqyXbdLVahCz60df5saDOcMYAXiEl1c+ZxWKjtWEtSbWhCqsQbgtN8VOyKDESI8+lKtNrWe7SXDsTPoBLgWYAvPqgM9W3d78Z9ibP4vmVxjEUO4krOt2G0li8I3DrIDdwceEY3ukwcrAPvvJ
 heiIy+GN
 +kUBZTgqB8Jf63vT5khzFYU+pvs516d3uI6zhB+3uBgAiWQJdk7h1fZAI6HQpYrCinEcimfViE05NCpjBjJThdwn4Co9ERJwwFHHexEJ+N3wEhHUhX/hkvumgw31JUtEYKAnLyzYr3bJ5s14Mh95yv468zFgfQhRDK0gHlHnzb+NY0ufV6QPuQWfL2B6VLUleMK4l4sy+FE4xLgjSn8zRd5krDpj3ORpfduPKN46SBWvemukp2504oiJaInN6WaiWozBvjfKboHxldGW5XXuZVb085X5DBfX90gjIFpZlQiny7PoNCVZ/UA1tgnz+wabOApHLSDKC2JP/o05P9QK4oxWxUnMcLS+MW/Dvb+fj+JIQK/V3GIkGfoDXl6Nrd6Aos+h1GmQDNt3ORPpBeDiw3Tz+J481ON0FJ8iPC5rXNhMQUiH/AjWFprm9w15kbdOaP32nrB/8PRNXMUMQGalM3u2NM4oS0PBHM1IYOMuQIkt0Yg8jCKjM21/do9mMO1BvB2FxWMGUII6YNM1eQyODZhwp18tICEZnQ+HweMwymKbUTkBHHvUgQN3rIGxlZOTQrwEBj8cgmULURHC2LUEN7oU8w0eZ/vbB9IqlxoXzW4c4FeQjVahO1urNsN98eZjcWAc5TBeLZRUEOGnLO9GOIPesddyCn86zkB09SYCL3TmOk/Qjq33FCTp4V+odbk/chMkOeK/fFiR4ohoi6pW2X7itJ23fgKUD4D0zD+pTtf3pAyGeDaR6jwNW0hONXUGS/27P3jxb1tBh5mR2AvrOlMVSMdDjJbedbDmD
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
index 0755a6478aec..d51bd75723fa 100644
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
@@ -312,14 +325,13 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
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
@@ -351,8 +363,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
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
@@ -401,8 +413,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
-		xa_erase(&luo_preserved_files,
-			 luo_get_id(luo_file->fh, luo_file->file));
+		luo_untrack_file(luo_file->fh, luo_file->file);
 		module_put(luo_file->fh->ops->owner);
 
 		list_del(&luo_file->list);
@@ -675,9 +686,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return err;
 	}
 
-	err = xa_insert(&luo_preserved_files,
-			luo_get_id(luo_file->fh, args.file), args.file,
-			GFP_KERNEL);
+	err = luo_track_file(luo_file->fh, args.file);
 	if (err) {
 		/* A retrieved file is new, so it can't be tracked already. */
 		WARN_ON_ONCE(err == -EBUSY);
@@ -796,8 +805,7 @@ int luo_file_finish(struct luo_file_set *file_set)
 
 		/* Only a successfully retrieved file was tracked. */
 		if (luo_file->retrieve_status > 0)
-			xa_erase(&luo_preserved_files,
-				 luo_get_id(luo_file->fh, luo_file->file));
+			luo_untrack_file(luo_file->fh, luo_file->file);
 		if (luo_file->file)
 			fput(luo_file->file);
 		module_put(luo_file->fh->ops->owner);
-- 
2.56.1.809.ga0b61035b5-goog


