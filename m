Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE93606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlnLCU6H
Received: by kanga.kvack.org (Postfix)
	id 30AF26B05B0; Mon, 16 Nov 2026 04:44:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294416B05B1; Mon, 16 Nov 2026 04:44:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E6B6B05B3; Mon, 16 Nov 2026 04:44:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D409F6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E62BA86A8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:45 +0000 (UTC)
X-FDA: 85440497730.18.85A1A29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 89A82100003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlnLCU6H;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822283;
	b=Z35sukcXXGeJlD4+pmPrnqggHeKQREKh5PLDyEGv2RlL3Ie5AH/RdLQXJkm+w6Rgu84YU5
	CgOv7vxlpPFBpeaOC2HzRoD1pWW49P/xq2ObbkJV86xSs2Bz2zpLTyQeSjBrnGX/q/0/eC
	+8YJ09EdnxgnE0lYD0qnbgkUNr/uQ8U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlnLCU6H;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auE26+fOLI72rgX+Hj3RdbPQehwMyY/pCwgCN9rlOHg=;
	b=lTdQC2PU4hJ5u1YNlCc8UpclgaD61K3oauswaxa7jx6cywykaENqkrhj+3dBqaamzBT9+7
	SLHgMAx7sFk82BicncBZfN4D6zm51gUE5hskq+M6/fpNTx+HDFQtG8Mb7b+TiYPMiFWf9e
	zCcOzdT2MCO/wqmWNlN7Bx601KwF0aE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1562962808;
	Mon, 16 Nov 2026 09:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8331F000C9;
	Mon, 16 Nov 2026 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822282;
	bh=auE26+fOLI72rgX+Hj3RdbPQehwMyY/pCwgCN9rlOHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hlnLCU6HKZ58GbvSDsseEbKhi0l5T/Jjd5dSM7eShUzehTKeI5KqY64Wu/trHe8Om
	 /oKhB7uyn0oRPF0mEyQ756tqq/4mNA20yLfHjcBaOva9NWGybNAxxrNxKABU8UKeFw
	 pUbJNBBEV4PIB+NTL2kVqfIDfNfpwPejOMzkI5FWFUjB8BoCjJLRQbceNWCcR7Ag/e
	 jO+eyvPV50FzUsER3uxy4a1ZL9KzDXuYrMhrcoqlVO8IOfXkbrppIe8qCSG6UVafAl
	 mAtwRavfw66ahhqexpZG6v7mW9TvPe/3d0CA9vfMMYNIDpUiDUtNjQPGyzN/fDgWBh
	 5v71KFl+4Kddw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:43:59 +0100
Subject: [PATCH v2 02/13] fs: add d_real_data_inode() and
 d_real_metadata_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-2-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3564; i=brauner@kernel.org;
 h=from:subject:message-id; bh=kOb9sDYc20xfRrHenkOZFrOaejChiG9k92klh14UwNE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulCwxkSKK9vcXG0dU0xarnFD/RLJ1csWLS9353WoV
 9soHfGso5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLLuhj+Ctn0Cpl/bJhb9WXB
 hoACjXvdu4/oCx4/KeaYYiZ6jP30F4b/sfktk7z3LrkdeMehiknaR1zBtdr1+Sevw7riS6d90Vz
 LAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 89A82100003
X-Stat-Signature: brz9ucfdbuxhqh4gr3uz7zeeeum1d3xm
X-Rspam-User: 
X-HE-Tag: 1794822283-868734
X-HE-Meta: U2FsdGVkX18+QBD9hk6ERR7AzlKdCaHGzAzXht1IrnrjVwCBG1/ufm366S8wTB8GimfSv6aA01ticchIk8/OyiJmvW0wYWsK7q2mni2q1WDGwxv3G8zTjvj490E4trSEsU0NK45tEF5N1CttN1TNRCBfYHjtwiIDMsjUeCjC76zZPmG6b9h4PbBqzNoVewi/zNSrxRrYbTFr4y/KMjQ5FenLWLtEXeGcLW9lPw6OTjs6KuJnHDUKoTWd9cnEKFUfkvsOOJId+rbDNFZ8S0gXcum8qRWqg1hKBmteD6GbvmZky/CDhJ2TrMnjXfQcqwv8sie9HCa4uWkytBFoDdkN2d6ZOi6M2ZKaRq/X8NQH1U8GYOkadu76dHWw9RDH1Y6iL5gJdbYgqlbR8aL9+nSvmgx1X3LaZOwH2AWDCENlDpmYd6r6jVlp6yZ3BZP0ztTUjXiTyO6pZb9wSU0k+aXrdHMMNLKgRFQAY+01p/3LXGgu1nDNAWjVQ1N1jgmsu+TgFJypNWGtny0sQd5FIqRZqMAnrOs/o0AicRIB6lP69AYqSW85Jv3P7diqaVx/xHgVDgFEA4P6L5JjG9q7iORIg/I8VM//AnitQM1zTVz5OpWzO+UrmUAD2G4zKOXog8rMIR4wf/G4ewjPbLSB4o+HQROdOg0xWNWFF7fJo/J/OYUsHa65vZFm8g+CTu0c3ofiWs/2X9gkIohzKvc2lxViFvg9OT1cze5CYgE4lyuTg425xPnOR3cpuFenP9/vPAdB8qiI3APrAHB19Ad23t19HmldHjbW14PgcYBJyko+Cvbw5+SglIcg8s+UYaRd1G9Myy+o5ISAQqkGdtusuaCfRu8TAk5eHXZLdQEw4R3UL/pu5LjVyfDriESSXpyHTntVxXKTwLUBTP4iZKsDPIT5RisGnuo3bGKICLuhcUgkwy/KyrQl8J7BVRoZ+83wj2/l6Js1trs+HRDd/D2o3vj
 SAs3lWJl
 cTUHYGcrRpMD2fqWp3td6RsV9/dHa2B0Y9jPUSE+FYN3XnoTGCQ3Kcz3rsUsRhLzfdu1sc38okmpGcIdpGSDIcAfIu5m7VR9UFHRTgd34pWdSzkvIRPyPzckGn8a8V0su28BcAOweIRrElqfzQ+erI7yuAZaC/cdcOEzUdJN575C7m8aRY/WUix0lcF7qA0ZkfFpX2LrzWxLu0RAsDvEStHGMiMRfyKSt4n9d4AyAsum0pa9ST610KVCiMV8kTUBNjc2/NF/fojcQiVKTq0I/Sgq78KFNLU4leJO6K1UiXJAPNEHaw18cddSW/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, d_real() can't fail. When overlayfs fails to look up the data
of a metacopy file in a data-only layer it hands back the overlayfs
dentry and callers silently work with the overlayfs inode. That's more
problematic than current callers realize.

For trace_uprobe and bpf's uprobe_multi it means uprobe_register() fails
with an -EIO that has nothing to do with the actual problem. For IMA it
means the stacked change detection is skipped and for IPE the file is
evaluated against an inode that has none of the properties of the real
file.

Teach d_real() to fail and teach all callers to handle errors. This adds
two helpers for the callers to switch over to:

- d_real_data_inode() returns the inode hosting the data or an ERR_PTR()
  if that can't be resolved.

- d_real_metadata_inode() returns the inode hosting the metadata or an
  ERR_PTR(). overlayfs never has to look anything up for the metadata
  but we don't want to promise that it never fails. So callers handle
  errors for it as well.

d_real() can't fail yet so this is a pure preparation. d_real_inode()
stays around until all callers are converted.

No functional changes.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/dcache.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 84b0cfe4ed0e7..a75016a713d4a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -3,6 +3,7 @@
 #define __LINUX_DCACHE_H
 
 #include <linux/atomic.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/math.h>
 #include <linux/rculist.h>
@@ -660,6 +661,50 @@ static inline struct inode *d_real_inode(const struct dentry *dentry)
 	return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
 }
 
+/**
+ * d_real_data_inode - Return the real inode hosting the data
+ * @dentry: The dentry to query
+ *
+ * If @dentry is a regular file on a union/overlay, then return the
+ * underlying, real inode that hosts its data. Otherwise return d_inode().
+ *
+ * The union/overlay may have to look up the data first. This can sleep and it
+ * can fail, e.g., because the data is missing or because its verity digest
+ * doesn't match.
+ *
+ * Return: The real inode hosting the data of @dentry, or an ERR_PTR() if it
+ * can't be resolved.
+ */
+static inline struct inode *d_real_data_inode(struct dentry *dentry)
+{
+	struct dentry *real;
+
+	real = d_real(dentry, D_REAL_DATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
+}
+
+/**
+ * d_real_metadata_inode - Return the real inode hosting the metadata
+ * @dentry: The dentry to query
+ *
+ * If @dentry is a regular file on a union/overlay, then return the
+ * underlying, real inode that hosts its metadata. Otherwise return d_inode().
+ *
+ * Return: The real inode hosting the metadata of @dentry, or an ERR_PTR() if
+ * it can't be resolved.
+ */
+static inline struct inode *d_real_metadata_inode(struct dentry *dentry)
+{
+	struct dentry *real;
+
+	real = d_real(dentry, D_REAL_METADATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
+}
+
 struct name_snapshot {
 	struct qstr name;
 	union shortname_store inline_name;

-- 
2.53.0


