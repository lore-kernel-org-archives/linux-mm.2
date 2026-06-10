Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA09CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CC46B009D; Tue,  9 Jun 2026 20:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF816B009E; Tue,  9 Jun 2026 20:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348456B009F; Tue,  9 Jun 2026 20:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20EC36B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCF6DA077A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:14 +0000 (UTC)
X-FDA: 84862078308.16.B948AE4
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2A5E2A0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AP3uL+MC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3F6woag0KCGoIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3F6woag0KCGoIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++tB77hzD2q8vCe8TMYSjrltZ0zPb6nZ4tH02lhBM58=;
	b=HIerBYb+0iWHNho+lpky4JQDgK3cV6nQzUOciGY/37ZCooFF3mCQJLoz0Nc2oGb2NXF4xS
	YxkPjNKiiyUGaQ0XIeZccb+PVlwjXP2EYg8crW8px5IOYj2oQ1Xc+gml4AZZzWvbBYuNh+
	ENxVBqVenJDS4j4rpRH5XwTDfRNHXZ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AP3uL+MC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3F6woag0KCGoIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3F6woag0KCGoIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050393;
	b=qc8m2qdzhr/FEoiD8Q9K6WRx6dHtinw57AOD6nugchnwG4YgI71tNVZbFc7g3T2Giuj2Lm
	FJwaFbuSQk7M634GSIVsTo5Ul1WdNDgqFiLNGBo8GeZuzNDesLDjqFShyKbSXLRdZpEjm2
	bgrRX07jyrvGAr5BSTRKVO2Hw0GCiHY=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-30762d67a64so815437eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050392; x=1781655192; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=++tB77hzD2q8vCe8TMYSjrltZ0zPb6nZ4tH02lhBM58=;
        b=AP3uL+MCAnxn6wELaXsDsgLHN54SsSvE99KCkfk/ca+EcdbOoo34F+n8skEJoWPp7Z
         MXvwGX7OPvlvB3rT+yhJPn/ZybGQcdZT1b5LjfWpZunD/gsEzdKMJqlzb3RC8OafQTqt
         sJAkoZwUnGlJAzRTsw0s85YiO9uwDGbgKzGGbnqzCA6C56afCKrGL+JAEEKdTO40SJIE
         CspM5DRvcEKe0SSbsNGUojOr1+mQFFRh4wyvNWwftx6F4TmXX2Gf86kiJfEx7zhCp2dE
         aWfe8iea/J3nggNgOp2/yENulUyAod8jGUDbmSv+1LEqLaZCuiiXOIuMxTd5gmSX1fbt
         V41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050392; x=1781655192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++tB77hzD2q8vCe8TMYSjrltZ0zPb6nZ4tH02lhBM58=;
        b=ZqM1aQZj1N5A0Lj0bzSHrgD9pEttEo4ExX+FuAPQFnm1+XN1gbC8FPhROyAZcCW8sT
         K/rHFS96F1FYHrVPyeXjCjO+gV8Lw9hcAJwyboFH60QkcjdZRvN+1qkZniqa4sx5tssK
         MyDn1d4SsJmfqFwskvgtrl+BUQgOiu5365oix0cKJEKL3ApNHyaP1O9zSGq/dNlOBkt9
         pdGdbv31GriWRmgjTuoj4ihdK1/+ifPKhb28CKTsqjREA1qhEMR7WfC9lDRzKUQ0MVrS
         J7sgEByBmPYuOfXFBUOlU3rmqSIR9XdQ9xKZyWXPICDxrMybkmuX+s5g9233S0p/JpEH
         V8Ew==
X-Forwarded-Encrypted: i=1; AFNElJ+UNcpZ0BAze50eVq10QB+jK7okGV2a5UazNNMDC1RzlakBQ03Fbv/f5Xdg2u9eV6PQVI9i3Hng1A==@kvack.org
X-Gm-Message-State: AOJu0YwVLxmTxVe3urW+WQz75U3zv+D+w39efQ6oXWspGrV6TYaXb71p
	amRBH/oPBPYyxYJvE9xRDBvQLg71ffcx9mKzNV0zALeylm2S1fF1CEWXdx8v3lUzgC7aHIR4Mrk
	KjtiNsNbU97K7Q3Mhso28QwbzG2LQOoM0bQ==
X-Received: from dynm18.prod.google.com ([2002:a05:7300:2a92:b0:2df:46bf:2390])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:9f0f:b0:303:f295:4db2 with SMTP id 5a478bee46e88-3077ae8e8femr14895652eec.0.1781050391622;
 Tue, 09 Jun 2026 17:13:11 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:56 +0000
In-Reply-To: <cover.1781042698.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <4e2a75c69fe350358e1fef3e4e25435f6a3d4e77.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nt683p69gz8mxsc3xp6gjcw55hwctnc4
X-Rspamd-Queue-Id: 2A5E2A0005
X-HE-Tag: 1781050392-422682
X-HE-Meta: U2FsdGVkX1+B89VNUs+N/t6HTPmh4NEGmScv5NojHRF7CtyFNbSI8StGKz1txe+Z7sTOrVj+VSwIoC8sUgkCkIVeX3GCNmnlsbl+N8RyatBDWjcLDv1gbjdQrBzs6EbD397z/qu7xs6eZi9HCb62/PIuOcTJLgtJN+VIz3NKEQ/MB6HZvVV/gRiw+FmSQxKuTHemlPZWZRbh0y6CXu9QXyichq0HYhqlCJ1B1KLP4nbTpt+cXhwXfNCIzU09hZZOZrNGGuM7fUa7UIn9i0oOgqqZHFFzZ/geRw3T9taYTF6+GTk3zJ9Y4iEpNYQGWSNRuiyAAQD5s38l3XbKsecVS/6kld11PR/ZNlGbQ/o5DXQTQP09G1CKQMFuINBM+GqLCr6kydikuOyPq0cDx2gTl3Nk3fbvsexjcqJEj9dWDkUhwFVlEl2tuUXWI8GPnZ+9F+eC3TDQGbUXjqqbujWMESUaK2DCJ7whBivLIFbpsqvMVb0BCVIctXfuS2/5AjSVJDwx1QxFTkH8pluEBZAqZHAMkoBpcwDcRH2l9KwY/cHHeX0+/acMM80fSaWj3xGSNTJ74TIjrQV3YYlr7IJz48YQJtCSkNGWjPVp+TiGkFsiGE5OyoJS99moQYM1auP9SOETufNSdlljPZYVvHVgnAj9NCgmV+C5bisAYWhK8yy/dvkyJxADQ0+C16+H7VR9KHkVUeDH46HHWTO+NwEqytIVsL/H4+Tr+sCggxhQNUAN3/+FZZjzAFExv+JYg/lElaatMJQTGQDYDrjVdt+ro2P+gJX0Am5K47xNbtoT6eOY09BlLdRcXEIVHoKrNo8OoZ6ubO+X6DQ/d7L9XTD7Il9zAKOAEjsnXCKbY4dFwthEp6pnU9uqyGAXvN5BHJ8fEds/MmH2giwPRkFac6I0Q/Ujx/LZkzy94wicpjEXaT+fOzWbpOsfrOcWOKouuvjXC0glswpdFJpXhriFUKD
 95pIwpNb
 y/F9LgzRUCnD5q/zFp1Em5ZiBDD5VSBTbGiU6kLkSBJSH9L375B4mWZV4p9qbJnms2udO+blp45yNL+nrSFbvPKcewVw8TunhOWcTjReSCYMFdGeCLKwLZRPqsJoFGXGhfyielK/1n/OMzMCF6XoK4QQIwaYE1Pz5Fx0KK4d8taN4wvHWbHVObt7OMDvXCtXb7gPvou9ZmCg0bg4D7UMCgacWgYR9+WsJI9g1B9DJHlSTuqbqN7Wpq1tpRqKGwGUNRLqqpteJO7tSGrXzADv1hV8+ufevOi7HHs6FBNkNmcnDrjwB8Vx+GT/rJGL0qtT6P96E2eGD+1HGtiJ5xOjMm/UtUrtbjYah5u4Aj5xpbXMmSxz5z0EW8Fmn9TTL6P56Z0C9Pk4MIwNKEPIdns/1P3/u/hIMlp8R7nraD1+5hDkZf1FfDglosHXkK6mpGq6OpuZfBkyLrCkjrbNkqMc3EqPhMh+d4ZKkl9YPmUmwV6odkTapvWTD0Mo3MBR5tOQtBVQ4r6B041ivGGpnDy+WHigXet0k6vcYBQbY1rEWkMR/OBTP7tnGy3NrMNWkj1tjG2Pox5kkvmJ6fKUTOTlg8aquON8CgkM/zRdm4K5H8uuZjEi5eBk08QxvPGNHJc6BZrDZ5wcU4pgviIOmFHhKTWVuQxheIKbd5MtK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on the total number of bytes allocated [min_size, max_size]. The
size range is inclusive.

Filtering by size involves retrieving allocinfo per-CPU counters, which
is an expensive operation. Hence, the performance of size-based
filtering will be worse than other filters.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h |  8 ++++-
 lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++------
 2 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 3b11877955b9..7f5acbb44c14 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -45,13 +45,17 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
+	ALLOCINFO_FILTER_MIN_SIZE,
+	ALLOCINFO_FILTER_MAX_SIZE,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
+#define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
@@ -59,6 +63,8 @@ enum {
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
+	__u64 min_size;
+	__u64 max_size;
 };
 
 struct allocinfo_get_at {
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 378fcd63b6c9..a936cf18611a 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -191,15 +191,26 @@ static int allocinfo_cmp_str(const char *str, const char *template)
 	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
 }
 
+/* Fetch the per-CPU counters */
+static inline struct alloc_tag_counters allocinfo_prefetch_counters(struct codetag *ct)
+{
+	return alloc_tag_read(ct_to_alloc_tag(ct));
+}
+
 /*
  * Populates the UAPI allocinfo_tag_data structure with active runtime
  * profiling counters extracted from the given kernel codetag.
  */
 static void allocinfo_to_params(struct codetag *ct,
-				struct allocinfo_tag_data *data)
+				struct allocinfo_tag_data *data,
+				struct alloc_tag_counters *counters)
 {
-	struct alloc_tag *tag = ct_to_alloc_tag(ct);
-	struct alloc_tag_counters counter = alloc_tag_read(tag);
+	struct alloc_tag_counters local_counters;
+
+	if (!counters) {
+		local_counters = allocinfo_prefetch_counters(ct);
+		counters = &local_counters;
+	}
 
 	if (ct->modname)
 		allocinfo_copy_str(data->tag.modname, ct->modname);
@@ -208,9 +219,9 @@ static void allocinfo_to_params(struct codetag *ct,
 	allocinfo_copy_str(data->tag.function, ct->function);
 	allocinfo_copy_str(data->tag.filename, ct->filename);
 	data->tag.lineno = ct->lineno;
-	data->counter.bytes = counter.bytes;
-	data->counter.calls = counter.calls;
-	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
+	data->counter.bytes = counters->bytes;
+	data->counter.calls = counters->calls;
+	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
 }
 
 /*
@@ -234,7 +245,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
  * Verifies whether a given codetag satisfies the active filtering criteria by
  * matching its characteristics against the specified filter.
  */
-static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
+			   struct alloc_tag_counters *counters,
+			   bool *fetched_counters)
 {
 	if (!filter || !filter->mask)
 		return true;
@@ -261,6 +274,19 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
+		if (!*fetched_counters) {
+			*counters = allocinfo_prefetch_counters(ct);
+			*fetched_counters = true;
+		}
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+		    counters->bytes < filter->min_size)
+			return false;
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+		    counters->bytes > filter->max_size)
+			return false;
+	}
+
 	return true;
 }
 
@@ -274,6 +300,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_get_at params = {0};
 	__u64 skip_count;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
@@ -281,6 +309,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
 
+	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    params.filter.min_size > params.filter.max_size)
+		return -EINVAL;
+
 	priv = m->private;
 
 	mutex_lock(&priv->ioctl_lock);
@@ -304,7 +337,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	ct = codetag_next_ct(&priv->ioctl_iter);
 
 	while (ct) {
-		if (matches_filter(ct, &priv->filter)) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
 			if (skip_count == 0)
 				break;
 			skip_count--;
@@ -313,7 +347,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	}
 
 	if (ct) {
-		allocinfo_to_params(ct, &params.data);
+		allocinfo_to_params(ct, &params.data, fetched_counters ? &counters : NULL);
 		priv->positioned = true;
 	}
 
@@ -339,6 +373,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_tag_data params;
 	int ret = 0;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	memset(&params, 0, sizeof(params));
 	priv = m->private;
@@ -352,10 +388,15 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
-	while (ct && !matches_filter(ct, &priv->filter))
+	while (ct) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters))
+			break;
 		ct = codetag_next_ct(&priv->ioctl_iter);
+	}
+
 	if (ct)
-		allocinfo_to_params(ct, &params);
+		allocinfo_to_params(ct, &params, fetched_counters ? &counters : NULL);
 
 	if (!ct) {
 		priv->positioned = false;
-- 
2.54.0.1099.g489fc7bff1-goog


