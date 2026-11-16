Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE0A606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l0bpiz+b
Received: by kanga.kvack.org (Postfix)
	id 7A03E6B05B3; Mon, 16 Nov 2026 04:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D82F6B05B4; Mon, 16 Nov 2026 04:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A25A6B05B5; Mon, 16 Nov 2026 04:44:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A74B6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 897B3A86D0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:48 +0000 (UTC)
X-FDA: 85440497856.19.2CDE018
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B991B1C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0bpiz+b;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822286;
	b=HUcxJiaMD7r1AcQ73wgLiwoM57GoUJLdwpLQl+TEyoItTK0Mx+vbPmHAazMYTBgc5AFRCx
	h/TPCVB2PTGxBg4XWJ8BlVb0RKezUFTgRuyWqquhsGHBoGQ/D4hEZbBER3rE6V1v1rFfuZ
	HS9WRb1f+XscoaKjTRH71mkBW6O1p20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0bpiz+b;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c585rKXvSwLmED7cC2rmvEhiwtH0KylzGmIdBpvFN0c=;
	b=yfoO+G1xOBhPtELbH033V3GunYsdofUhtQsnEBlfDluQ8DNGwNlW3sYiMXNaAv94kRcrea
	i2u00XhvPgtE+N9AlckBX0M0oT6cuGirCC2SAUfdVC36CoJ0hDDXB83hgCrNXBRnb/JSq+
	bHIAIaooJfKrwwSgw4qUW54s6EtYlas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1528C45CA6;
	Mon, 16 Nov 2026 09:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447A21F000C8;
	Mon, 16 Nov 2026 09:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822286;
	bh=c585rKXvSwLmED7cC2rmvEhiwtH0KylzGmIdBpvFN0c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l0bpiz+bX5nx+aiaNcOiRjFcEYPY2Kqq5sqZFERf54ptoRrnBQYV/OeG47+NNf2RQ
	 3DTAYdG7Lx7+8rEeu+Jz3Vo3IfN3iFe8QkrcpI78FdMfC8sBcBcNgPSmQkkFctuF0P
	 9IFRi15L8eVokwda2Ym9sDATjq3AiEpR07/z4SBd/b9PSpippJWmxu/qirUE5Yc0BS
	 4ozq3jwrpW1RkIq7niydZWY19tlXFqMAYjjR668agVOePdg5LlLSCbdxUJyRg3olOn
	 dCnNlbitOE6myB0c2fRfd95zaPJGPxKiuAorjYxOCvQamY7T9XPOhWVVk4kfps+zCQ
	 jMmYbdllmw7bQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:00 +0100
Subject: [PATCH v2 03/13] tracing/uprobes: handle errors from resolving the
 real inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8312; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0aErZRkx+z/UpDVY9Btl01AwKpNYtmiEZh/6n+tIpZg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulD4IKhG3W9f1Smthz+9edkkFYRfcGuZmc02PBZcr
 bdlhdW2jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkon2Jk2H9sic/cFOa48/Ml
 gxNu7Ey5GGIkfuNdk4KA7NOAiy0J7Az/PWtZPBM9jnXVajTcOrRDVOq69vbgd1XnWhSu7WyJrp7
 HBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B991B1C0006
X-Stat-Signature: obciqgpo5h6sixtrdk7eu5toc43mikkw
X-Rspam-User: 
X-HE-Tag: 1794822286-514676
X-HE-Meta: U2FsdGVkX18AKvzdnQ7PI2VJGuubrXNA+CTr+LXyKn0okpRy+j9cdbBRaJpb48uXbRuZlQr/pzFNZiSWXODeORZs2JyKAq2jBjpTj9whVi1EaUMZ83BwBqFdM0srepIVV2KTRJxl0gVU+2ADRSrshthcB0D8yOLuJOl3+AZAxhPBFAvI27mRjiq5s7bXMG+yR5UtXr9LZBSZ+dEo9YgHOsirIJ4/ZoN2Nw1Rw2xhLGBKS28Rg1UDMKZ0iT1QJAYFnJzV9uoJa4iL0KsSLo3ckKH56019QJhAbsDApOa4MNWVT3H5IvV4dDA1QIlo1jBZt4Ke85r97v6Q5y0jTVfw91dwZZAh1nLLY9fEZ0N5CXO7/mnAg58AX2/x3x662KDn5JtzyietgCeSONvMU9735MRXfvwod/1hkEpVBO+WWKBygbLs78zbiBSRvqR+PMuHceVMPRBQxl0diIvTJEo1LShUBqfj75Uy1G/ZeH9PfgBUCHJ+kQ4U+o2djbkVxMBse70FAXb1rKCxzUib//t7rmYWiYwo3PnjKSKJvX3weCJ46VSGaKAwVu/oPPjeWR9dViSvFa4xbeDbAWfvP/TTSTab9G3kfGdnTqcOZoZtUM0neWgzufAoWRQrgXedeaDErH5hJ4fbxdGfXAQ0tU53zciASi3HxTIlBRCl3sDRZy0h80IVG1pmWl4ecPnUGa3DnD8FhEs94CTD35iT3HgB9QBawQOC8YOHKdWgU9VQmY59wNuFwzs5J3jvSKIkjaN1aaS/JGtrBcvfqotW72BSqtqLOC5AV6zJO7+KvvJ19KeKN+MqRQCZZsjCOQd2IrV8c0iiWzGgww1iy5LhRpS6kwLB53MCkep62vh48ZfFlv3Mxb368Hox6GmV+9eDFjdkBX2x/3BxAaPJBaG1Te8vNwpZmcwauSqsb3HOkTNoCQF3jjnvB7HzQ6RrBFZxK+hEn2FooRM4wSWgwhhYo5h
 /nkAX/8s
 Kkec3mUr8ZmuKfXI7r7cwxsSmpj7PkZ4xAI9dUDPnLFdV3e2RUeGDrvBEmL72LWESwSAtjkY8lT+D9t7iAKEcrl5bT5GhTve1dpP3SmNrIHR2DQJraRsGkK+RJyW4EwOhvptAow2wA0usMPywuo2uFqTRFJ80EUxF6GI/fbJydFr3L6GAJ9EK03gaBZgMnicC/lzEnTqqjHa+Ey4b+lEiyQ6Nb/RjV167dEb3r/+07+OQOKG/TC8miiHdrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch
trace_uprobe from d_real_inode() to d_real_data_inode() and deal with
the error.

Currently, nothing checks whether the data can be resolved when a uprobe
is created. The first resolution happens in validate_ref_ctr_offset()
under event_mutex and the last one when the event is enabled. If the
data of a metacopy file in an overlayfs data-only layer can't be found
the event is created just fine and enabling it fails later with an -EIO
from uprobe_register() because the overlayfs inode has no
->read_folio().

Instead, resolve the inode hosting the data once in
__trace_uprobe_create() right after kern_path(). That happens outside
of event_mutex and if it fails the write to uprobe_events or
dynamic_events fails with the actual error and a new NO_FILE_DATA entry
in the error log. The resolved inode is passed down to
validate_ref_ctr_offset() and trace_uprobe_has_same_uprobe() so we don't
resolve it again under event_mutex.

Both functions still resolve the existing probes they compare against.
If that fails the existing probe can't be on the same inode so we just
skip it. For validate_ref_ctr_offset() that's fine because
uprobe_register() refuses a mismatching reference counter offset for the
same uprobe anyway.

trace_uprobe_enable() returns the error and probe_event_enable()
already unwinds the probes that were enabled before.

While at it, resolve the data in create_local_trace_uprobe() as well.
perf_event_open() of a uprobe PMU event registers the probe right away
so it would fail in trace_uprobe_enable() anyway. But this way the first
resolution happens before perf_uprobe_init() takes event_mutex just like
for uprobes created through tracefs.

This is a no-op until d_real() can actually fail.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/trace/trace_probe.h  |  1 +
 kernel/trace/trace_uprobe.c | 57 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index d1fb3520700fb..91bf3a66d834a 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -610,6 +610,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(NO_EVENT_FIELD,	"This event field is not found."),		\
 	C(NO_EVENT_INFO,	"This requires both group and event name to attach"),	\
 	C(NO_EVENT_NAME,	"Event name is not specified"),		\
+	C(NO_FILE_DATA,		"Failed to resolve the data of the given file"),	\
 	C(NO_GROUP_NAME,	"Group name is not specified"),		\
 	C(NO_PTR_STRCT,		"This is not a pointer to union/structure."),	\
 	C(NO_REGULAR_FILE,	"Not a regular file"),		\
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 22cc3c8181b86..34cd4392decfd 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -415,14 +415,15 @@ static int unregister_trace_uprobe(struct trace_uprobe *tu)
 }
 
 static bool trace_uprobe_has_same_uprobe(struct trace_uprobe *orig,
-					 struct trace_uprobe *comp)
+					 struct trace_uprobe *comp,
+					 struct inode *comp_inode)
 {
 	struct trace_probe_event *tpe = orig->tp.event;
-	struct inode *comp_inode = d_real_inode(comp->path.dentry);
 	int i;
 
 	list_for_each_entry(orig, &tpe->probes, tp.list) {
-		if (comp_inode != d_real_inode(orig->path.dentry) ||
+		/* If @orig's data can't be resolved it can't be the same. */
+		if (comp_inode != d_real_data_inode(orig->path.dentry) ||
 		    comp->offset != orig->offset)
 			continue;
 
@@ -443,7 +444,8 @@ static bool trace_uprobe_has_same_uprobe(struct trace_uprobe *orig,
 	return false;
 }
 
-static int append_trace_uprobe(struct trace_uprobe *tu, struct trace_uprobe *to)
+static int append_trace_uprobe(struct trace_uprobe *tu, struct trace_uprobe *to,
+			       struct inode *inode)
 {
 	int ret;
 
@@ -454,7 +456,7 @@ static int append_trace_uprobe(struct trace_uprobe *tu, struct trace_uprobe *to)
 		trace_probe_log_err(0, DIFF_ARG_TYPE);
 		return -EEXIST;
 	}
-	if (trace_uprobe_has_same_uprobe(to, tu)) {
+	if (trace_uprobe_has_same_uprobe(to, tu, inode)) {
 		trace_probe_log_set_index(0);
 		trace_probe_log_err(0, SAME_PROBE);
 		return -EEXIST;
@@ -477,14 +479,19 @@ static int append_trace_uprobe(struct trace_uprobe *tu, struct trace_uprobe *to)
  * as the new one does not conflict with any other existing
  * ones.
  */
-static int validate_ref_ctr_offset(struct trace_uprobe *new)
+static int validate_ref_ctr_offset(struct trace_uprobe *new,
+				   struct inode *new_inode)
 {
 	struct dyn_event *pos;
 	struct trace_uprobe *tmp;
-	struct inode *new_inode = d_real_inode(new->path.dentry);
 
 	for_each_trace_uprobe(tmp, pos) {
-		if (new_inode == d_real_inode(tmp->path.dentry) &&
+		/*
+		 * If @tmp's data can't be resolved it isn't on @new_inode.
+		 * uprobe_register() still refuses a mismatching reference
+		 * counter offset for the same uprobe.
+		 */
+		if (new_inode == d_real_data_inode(tmp->path.dentry) &&
 		    new->offset == tmp->offset &&
 		    new->ref_ctr_offset != tmp->ref_ctr_offset) {
 			pr_warn("Reference counter offset mismatch.");
@@ -495,14 +502,14 @@ static int validate_ref_ctr_offset(struct trace_uprobe *new)
 }
 
 /* Register a trace_uprobe and probe_event */
-static int register_trace_uprobe(struct trace_uprobe *tu)
+static int register_trace_uprobe(struct trace_uprobe *tu, struct inode *inode)
 {
 	struct trace_uprobe *old_tu;
 	int ret;
 
 	guard(mutex)(&event_mutex);
 
-	ret = validate_ref_ctr_offset(tu);
+	ret = validate_ref_ctr_offset(tu, inode);
 	if (ret)
 		return ret;
 
@@ -515,7 +522,7 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 			trace_probe_log_err(0, DIFF_PROBE_TYPE);
 			return -EEXIST;
 		}
-		return append_trace_uprobe(tu, old_tu);
+		return append_trace_uprobe(tu, old_tu, inode);
 	}
 
 	ret = register_uprobe_event(tu);
@@ -553,6 +560,7 @@ static int __trace_uprobe_create(int argc, const char **argv)
 	char *buf __free(kfree) = NULL;
 	enum probe_print_type ptype;
 	bool is_return = false;
+	struct inode *inode;
 	int i, ret;
 
 	ref_ctr_offset = 0;
@@ -606,6 +614,17 @@ static int __trace_uprobe_create(int argc, const char **argv)
 		return -EINVAL;
 	}
 
+	/*
+	 * Resolve the inode hosting the data now and outside of event_mutex.
+	 * If that fails the probe is useless and the user should know right
+	 * away instead of when the event is enabled.
+	 */
+	inode = d_real_data_inode(path.dentry);
+	if (IS_ERR(inode)) {
+		trace_probe_log_err(0, NO_FILE_DATA);
+		return PTR_ERR(inode);
+	}
+
 	/* Parse reference counter offset if specified. */
 	rctr = strchr(arg, '(');
 	if (rctr) {
@@ -717,7 +736,7 @@ static int __trace_uprobe_create(int argc, const char **argv)
 	if (ret < 0)
 		return ret;
 
-	ret = register_trace_uprobe(tu);
+	ret = register_trace_uprobe(tu, inode);
 	if (!ret)
 		tu = NULL;
 
@@ -1105,9 +1124,13 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self, struct mm_struct *mm
 
 static int trace_uprobe_enable(struct trace_uprobe *tu, filter_func_t filter)
 {
-	struct inode *inode = d_real_inode(tu->path.dentry);
+	struct inode *inode;
 	struct uprobe *uprobe;
 
+	inode = d_real_data_inode(tu->path.dentry);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
 	tu->consumer.filter = filter;
 	uprobe = uprobe_register(inode, tu->offset, tu->ref_ctr_offset, &tu->consumer);
 	if (IS_ERR(uprobe))
@@ -1630,6 +1653,7 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 {
 	enum probe_print_type ptype;
 	struct trace_uprobe *tu;
+	struct inode *inode;
 	struct path path;
 	int ret;
 
@@ -1642,6 +1666,13 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 		return ERR_PTR(-EINVAL);
 	}
 
+	/* Fail early if the data of the file can't be resolved. */
+	inode = d_real_data_inode(path.dentry);
+	if (IS_ERR(inode)) {
+		path_put(&path);
+		return ERR_CAST(inode);
+	}
+
 	/*
 	 * local trace_kprobes are not added to dyn_event, so they are never
 	 * searched in find_trace_kprobe(). Therefore, there is no concern of

-- 
2.53.0


