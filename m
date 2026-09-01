Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C689AC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736ED6B00F0; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692FF6B00F4; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD416B00F5; Tue,  1 Sep 2026 00:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 090286B00EF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64A761602BA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
X-FDA: 85163927142.20.7A31D80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D6DF9100006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dipnz7Cb;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGq3BJdNnnCTCYeGqjvgppOd2nVk87x7Bo82sRuFOlA=;
	b=n7o1xlR+AHv7LDL+NCwruMD40mOtDtG2iT4yF4s9vTJog4pxjpL9eUT3Q40lZwpUImMviG
	1XtjPXlSNI1ZmWX02Wtih8tKe6uqPItjBpkU2fs/sU/TwfXnc23zSeBhVYeL71h6oXp3zG
	STAP8ZRQNzOuO338KdlVliYDIGHyci0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237269;
	b=Cxy/+vYUxyXpuVqYFEXSLoQBJW+xmaUVQiweSq8lkwcCIlVJ9db6orsBFATybmcgg7LTXw
	SCEdTi4/AqjVVdbwnphq+h7i0gX5dUTZ449P0YNTiyVUhirKa6de5INKCd5riPntwoS5Iz
	txGJRktST9DI7esbYYd/e1YJMgczNRc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dipnz7Cb;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26ED04016B;
	Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A671F00ACF;
	Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237269;
	bh=SGq3BJdNnnCTCYeGqjvgppOd2nVk87x7Bo82sRuFOlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dipnz7CbbjBVWIVGEHxCrzsLQn8sqLmZEK0SdDMem24OMUYjYS8f8TucC9wihNIS8
	 qhIxzQHv3T7ObDkmkiaU/hUvprTG+EbI4Afxi63kTWF01X92Lbl8ghmg0snvR3HP3F
	 sW+fuCQMzceEY8YiJIqVLN5NN0/zTcf/NU1Blle6bNwCDd9irJlCZ7A/+Y66iD9GqR
	 J8wt+JIXczDL11TV8N53AePTLuG8RzoUSStMWcGEc17bsoRFWZ6vXI74X3k7t/Lnmm
	 dXVdtSPAjDfiJqCbHjU2E1TPXw3RJFGDQ5Io9mXn3CcLgkTNJHFz1QRsBVeTZwP4oh
	 WVABe1XxVfv7g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/17] mm/damon/sysfs: implement preps/nr_preps file
Date: Mon, 31 Aug 2026 21:34:06 -0700
Message-ID: <20260901043417.2165-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6DF9100006
X-Stat-Signature: fe84q8784n16o8m4mnnpynahipzwwj4q
X-HE-Tag: 1788237269-953319
X-HE-Meta: U2FsdGVkX1+wsMnvI1wCdUWlmwTqeRFHb0zMBR8JyCKaH3LfxDcEU/HNVtWruN8BuyYsMDUvThNUYuiHxDIiLOUAInn6AgMoDmLSbM3bR3JdG/cPhaKPRgxO24YgghJqzYEdfXkjbp/LnJAOMpCfqynaKqh7U76y+5DqVlOcO8/OzhxBy/axKgcY3Gm9BVy/quS1mFcAkJRcMH+9qaHIKbpMk+2ODcoYmvdVbI8ZAE8QD8Dn2+f+Xc5istO4mjQQ+hyMKxkTBY1NqYrxN1YDzdPQLJ94f0FwysR+R2L9eHgLnLPyjGfmpLhAKtXNMdCfsBsBgH59HKM+kAUpWu/oxj9moOcjxoAK111yl9xiuy/O/C7aMJrEreLhHPbxnQuseuHLvjY81C67Dv8Fgl8J67EsXDlHlv1mzcyBmBFAO6dtNndjhJy+/fB4xSyfrjy2sdSRC6Tos7R3WxW5etaPinz4aY3U7RspnCnJAKzTdB+/YofaPTXCm5tXo8GqfxOd/Yd6fRsjukoGrYUWddUP5XBfd/xHVUrMRTxmKZrnD6VjDa6kGv+Kj8qaEljjfhx2tOSrTYO5rJX+p0HA3WoGJ2tnhEOQZR3BhsF+Zoy21e2nPL338bORzegrbvKAV/MxndZkm/WA0SBkuzfR5u/+b3XWa1ow9kwcjIo1hK3XmNIWO6dGseR4juct5VNHUb0aZhPFgStumGlfWjwAZjraGtJ2H9KMuAavWqqhLOAzbvWoU9ecDu8Lcwd1am9NM1dLodi0pQ9d59NIYKsRE0acW0lIRJ7yhJ+X0z4BcQrE071rgTPiNr15njf8NFVlnfHfNAxOYG3bF4VuNQYrdLoQZYIdM3UJiYcfXhADu3ZIMlhz9WNSA7xaLcwnssNx/ls+wqlhqYzWcMdShGhDGndsQrYdIKy/hELO2JKahPvRYjC43ijjS9jNtqOP2hGUjvxhVZKSDMlbgAJ4LqaD3Hc
 IdAYGxiz
 mEHCmk7bNzk8xjyRrK2H+TT1FRUcdcw/dywuQbap0qp5rgRcUWUik8j/lH/tGFZzHjLaue0+Ln6iQ5hiqaP6HwqH8ex/dgxuyBbrmvF/9aFYnGQvAYzkzPsRh5hFGWenVoF/fzRdxdwgON+PNDS1nPt8xOo2CqKl/+Z1uydEiwwWgZGMds0sNspONw8r0Bk5SPzsxlUAkwngaq+CEg1YtNEgZIU97JbE8tNwLGOKQMn73e5Kf+8zEb3II9RathJykew8NLKiu5M5IF1qYTRhx9pbLWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps file under the preps directory.  It will be evolved
to be used for generating sub directories that will represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 09641257d3a89..1d2d9950716e1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -755,6 +755,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	int nr;
 };
 
 static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
@@ -762,12 +763,60 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_preps);
 }
 
+static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
+{
+	preps->nr = 0;
+}
+
+static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
+		int nr_preps)
+{
+	preps->nr = nr_preps;
+	return 0;
+}
+
+static ssize_t nr_preps_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_preps *preps = container_of(kobj,
+			struct damon_sysfs_preps, kobj);
+
+	return sysfs_emit(buf, "%d\n", preps->nr);
+}
+
+static ssize_t nr_preps_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_preps *preps;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	preps = container_of(kobj, struct damon_sysfs_preps, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_preps_add_dirs(preps, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_preps_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_preps_nr_attr =
+		__ATTR_RW_MODE(nr_preps, 0600);
+
 static struct attribute *damon_sysfs_preps_attrs[] = {
+	&damon_sysfs_preps_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_preps);
@@ -1149,8 +1198,10 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (probe->preps)
+	if (probe->preps) {
+		damon_sysfs_preps_rm_dirs(probe->preps);
 		kobject_put(&probe->preps->kobj);
+	}
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

