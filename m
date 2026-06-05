Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391D7CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C597F6B0092; Fri,  5 Jun 2026 19:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3BC6B0093; Fri,  5 Jun 2026 19:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6B66B0095; Fri,  5 Jun 2026 19:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 782576B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:37:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26A39163928
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:01 +0000 (UTC)
X-FDA: 84847471842.05.CC38F5D
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5EC8716000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:36:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HZvKGKbg;
	spf=pass (imf08.hostedemail.com: domain of 3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702619;
	b=3wxofeNAOdVh5aF/q4hkX3gWTxCMrzVPkl0PN1vytOLnOLUXMv7I8jVaESd9jaturXwyfF
	vg9NEtumivUTvz1jQwRxVeDUsH9v51kT8DmYkaVcgY8sBfpgeqCW6ZrpQxPBkE4IHswgC5
	N3lqqCdm2pCCN6+NxfxMrsaGQXam7Ss=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HZvKGKbg;
	spf=pass (imf08.hostedemail.com: domain of 3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoFYWRQDoOC6tOfcHj/jj7qJpnwdSFC+5s/raUx2KnQ=;
	b=MbZ9RJj7znWNGPTZ5hSBg3rG26WjuNpgUtKt66r00ogi3dBUsTVRu8mYR5TPl/wmLdf8JM
	w4PacikIv3byP/pg9KiiHxlHbKOmkHU9h6E5DG69iS7dsHAxhRTJW8wXLYRK1hK4ur8zS/
	t2VWe5gV7T2N+gwIx3g3FOkulZt0lbo=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-304d8613efbso2425406eec.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702618; x=1781307418; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JoFYWRQDoOC6tOfcHj/jj7qJpnwdSFC+5s/raUx2KnQ=;
        b=HZvKGKbgusJa5ez+EukJIeBAywi11CUuDaqblF/SCBxlGx3c/O0eOj7c+vDz/IP046
         GBMljMKPSUXI4R+DJRmXufvJ4R3kmrwdDVlg7YCU+SB9GBu6cx+7/GAus8yTuswjTV4l
         38EFewhfIrHTAyNS7ELav5DLga8vcD/EF557WEYbQrnmW2FO7+AzpIdpeNoF6ZoPGCfH
         1A4/GYKhvEG3xikQqnMAuPAdhonlu4DvRyVAt6g7/3jXg58vQT7rmpaUitowipKOo51F
         b3jVLbzpyopuEpTgjGn/50y1nwufXY+W2IkvWNA6MW9nUpcTJRp8p3jN4DoPsyv9Uyra
         m9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702618; x=1781307418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JoFYWRQDoOC6tOfcHj/jj7qJpnwdSFC+5s/raUx2KnQ=;
        b=cJAC2FHr9f3iIhSvewz97kOLos4N68nhtuU9Wr31ne+7vD6JwjW6wxS/cqPiOC/7E3
         Fbfpb6iTxkOJxoLnzMSrqA7vafUFtqYcCoSYdtP4OB7pMgeTjSgCaC1YMdMWr9O90eb7
         gf9PiNh/qoocbymCbVGGqAEDzGerRUVDY8IM7ZuGM/WS20CAIZXSntIJgG2FBzn02OGF
         rtnrG7opLZMQrXM2rXW1JHjRFtOyyPF2XV4d2e2eQHT94XACOIVl+vaPPJrVHOd0nIS2
         pC69N7ZDU2SMyDBSpFukVJQovxvT/roPfUESEIiTlYBfhusPWpobhp+vbjOEV4QUPVCk
         amOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9KUQQVwjqqiGTLPD+IZ9CYsfZx43m9xtUUSjtOV/A8KQHVNyensj5xgW46AhM3rkQA2V4NJ5oKRQ==@kvack.org
X-Gm-Message-State: AOJu0YxzJ4vQeN3j+Co6ULz0Xs/ho36OXi6vck03aFK+yzHea+oEC0Z0
	PYbxCct9O546NMju8LYM3zv8z61ZyeyytqFmpoyi7Usd0ElatwSruBv7xjxLjAZVohkgPK54lzm
	/lkMWDOeRkIaC8458Ft6LqDTdd4xSY6mrtQ==
X-Received: from dyek9.prod.google.com ([2002:a05:7300:6409:b0:2f9:af7:5039])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:d517:b0:304:de94:1c2c with SMTP id 5a478bee46e88-3077b866467mr3627728eec.34.1780702618006;
 Fri, 05 Jun 2026 16:36:58 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:48 +0000
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <ef88e52368463e312086a966f10287a29d0edeca.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EC8716000B
X-Rspam-User: 
X-Stat-Signature: hwuakef6z13hme83fgt4pz813gbjpdyq
X-HE-Tag: 1780702619-419381
X-HE-Meta: U2FsdGVkX1/Fe9jUkFRBHDchkSuQMfNPa1K5AIeba6bA5sxE+jDAYoz9f4tkb6Z1JPQ09oZCLRA8uyjAhB9paa8yuafe7En9siJp6RWx0MaHeh+Tm6QM7YKyIwFab7i8jER5TcJQhDFcF6dgRSULw9VuCXfJfxalundVlzZV5fU9KFUSwezDzPtnfwxRVByyV7qgjVAizIXSTZfwjVJz5POQ0OXAf3WRu/YGE+VLMH//pJJv83kiFPV8E5zdm2w2kAK68nfBTscUrqr6z5DjqpKOKYs8+DCTG7cn781sl9br11mIP/n3zFEDiFZHgkz1QRyr5SWSG+1vaVdE3B7qI1jU/ABFywCTjT80fO07+jK1vcOH1yxskoOuEOS68YewVGz851zixoNGIY34Mk5pcxnR0tva+Sv0TrwRRqaUXYWUkZ0wbWHhFPDr/MNp/ykO4f3RS3A4lMFRYygVLGYmKu/8LXycZN+i3nyUgMs/GrTrrx7ZLth4LjdpgP3/KO6DdJseFXobE196xT20oZj1S2pmv8fUeuNBOvctySX4iw5fkJssPeYvBRDvhiSw9tYrryrMVj8H+yWSSNwERLQMmfPOyOlM6MQSsITQkM6EutGDBKnYAMHyHFA1UmWFPevuLttW0DRNZYcGCnqwLI+T2UzzX4RDMNqdeSyg4l/cKN1rYsxvfStARKEBFSd6iE/yGAag9X0GzhgMbBGrP/wXG79RCmh/FcemYq0tZugBbqEveDxM5dY3iW57Tw7NJcev8/xdw03cgl2XpOMcYxY+KUHjO80xwYzFmQ0ClFaWRTa2gDr9xkR973Qf44juf4BDWUf9dsBjvZU33v3uFBvPVsY8FEEDNsXnR4gXqa7IgofCLbqy5ItIFjaXcx4JnhJUjSnAI6Ybdm7sGPjCj6OhhD/bVx9nANiksAcffMuz90xflKPFJI6crfynBWpYSV3PK8lB7Oe6W5Jbr4zlt1x
 pXEcxQEJ
 DMjw+OuA3y7+C8oR5SyRbyG8A9M/f81/74GH0t9q9nYK844QWZixJ9We64TIPNDYjHYTKhi7gMsVjW1TXxYfiKsCOeP47lB0+ecsqjwIuTWJ38885RX+Qdegpg3a54b/KL3MBcERiYP2CeB2tboakXmxMIMePdzcf+xrfYel6Z0J7fFeOo/6IVqNIVVnorMqljMpriark/KySZVNkJMTQP+a/HqcwmTDhMuYkgp3keDxs6FHJfgPdU/gitqsYXAHYWgJiw+PWuV7oKGu7URhnGoGIEKQgq7eGpPut7KwGAVIH1or9zA+yP5Do8hmNsZLfodhdE6nMBwRUAu7rcKahW9RnCVGF6GpaweNvfBLL6DMbnX1k3BeFDNq75VmB1pHywj/gV3LokLJFll4ag2ALzx8Ud3Fx4zc/cTShj4Num3T2JbKpbn0pXrn8MgV9tkkcgtpBKvFGCYK0qu7sGeII8l7K2T16lBnIB4mKKRqcg2pXI36B1N8K9NGR8oMuNGcJiIjyPZgv/KeWllAOUtV/LxkqXOryQkUYcFf9PO0nDt0p4Wcv3zmdCVbx4F9VoZTjKpPAOctU4ziWABLaXlY63T7XioemwfeSVg2/NKq4ZBu9gqjqiPUzuReGJASNGypy7A94f8CexYX/3B+bTm/O4obsH1slylI4u2Vk
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
 include/uapi/linux/alloc_tag.h |  8 +++-
 lib/alloc_tag.c                | 68 +++++++++++++++++++++++++++-------
 2 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index cffb0c46e0b1..0e648192df4d 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -39,13 +39,17 @@ enum {
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
@@ -53,6 +57,8 @@ enum {
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
+	__u64 min_size;
+	__u64 max_size;
 };
 
 struct allocinfo_get_at {
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 93bc976ac505..ddc6946f56ab 100644
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
  * matching it's characteristics against the specified filter.
  */
-static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
+			   struct alloc_tag_counters *counters,
+			   bool *fetched_counters)
 {
 	if (!filter || !filter->mask)
 		return true;
@@ -247,20 +260,34 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 				return false;
 		} else if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
 			return false;
+		}
 	}
 
 	if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
-	    ct->function && (allocinfo_cmp_str(ct->function, filter->fields.function)))
+	    ct->function && allocinfo_cmp_str(ct->function, filter->fields.function))
 		return false;
 
 	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
-	    ct->filename && (allocinfo_cmp_str(ct->filename, filter->fields.filename)))
+	    ct->filename && allocinfo_cmp_str(ct->filename, filter->fields.filename))
 		return false;
 
 	if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
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
 
@@ -274,6 +301,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_get_at params = {0};
 	__u64 skip_count;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
@@ -281,6 +310,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
 
+	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    params.filter.min_size > params.filter.max_size)
+		return -EINVAL;
+
 	priv = m->private;
 
 	mutex_lock(&priv->ioctl_lock);
@@ -304,7 +338,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	ct = codetag_next_ct(&priv->ioctl_iter);
 
 	while (ct) {
-		if (matches_filter(ct, &priv->filter)) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
 			if (skip_count == 0)
 				break;
 			skip_count--;
@@ -313,7 +348,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	}
 
 	if (ct) {
-		allocinfo_to_params(ct, &params.data);
+		allocinfo_to_params(ct, &params.data, fetched_counters ? &counters : NULL);
 		priv->positioned = true;
 	}
 
@@ -339,6 +374,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_tag_data params;
 	int ret = 0;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	memset(&params, 0, sizeof(params));
 	priv = m->private;
@@ -352,10 +389,15 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
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
2.54.0.1032.g2f8565e1d1-goog


