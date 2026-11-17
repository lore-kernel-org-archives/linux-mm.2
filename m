Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDD5606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KU7N+Fsh
Received: by kanga.kvack.org (Postfix)
	id 950696B05D5; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9CB6B05B1; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB686B05D9; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEDD36B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1406216060A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:12 +0000 (UTC)
X-FDA: 85446189024.08.3A2D9C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EFC0520002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KU7N+Fsh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957790;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4F70HveUXtSu/VzsmjPy4tHZsFCCJi8A8Mell8WdKc=;
	b=fV2NbSjiKaqpRy4Yv6JGdUm/5elW/xOyBmtgo2Q2k0FPCWlK0mlb3qIrtYamzGzRvL8gYv
	sHFhLji9EFRvHeYJPQ6Kgixof1zNEcTPHmWn2ITBqMrkL7ImY1q/rP+1KtHFMWUcP2BEl7
	BhLzQqqQV+PEeil0YTcVE7RP6Tq61Fs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KU7N+Fsh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957790;
	b=fuu5piP7kEWTO4VciRf4yHI/n31+NPjzeh9d3rBjXxSD8Iay0l+EbA54UvfoIPNZBlr/Mm
	HGy9zGJ5nOwkxWNNyPDw0xPIUpMz42guPFqISYYHFVzjnuX9eD620HyzIcwJWVMPRRsbvo
	n2B2UVBhxwv6NSSMaHvqTCpt4boi/gs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F73A45A64;
	Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957789;
	b=C5hSpsejT9Csu6JI2yDzDeAREi7cXTkRC+nKrIjKctp31/jCNQVGbztRGm5WvHFtzXcc
	 ywpvs1koacXG5YnK1MRXrj39wJp3sT7kslsocU7XrfiRQx/p/JfRhpFNFAE2XOT/LsPuL
	 QvO8EkQ+9ClKmOpGanuNuduv11Rdvx+yVo9O4Hf6fWBjsqiKEeaCLicYCgcqz1N4HQKlQ
	 Q71cUoMiemq4aiQtksP9Lo0/ddidcQP35j6rawDTm9Ho/bqa8TDX2xRe7NQgBzAqFJ431
	 xMroPBxytZ9hEDDju5myFSCnYP3/wVELd/Hv7tRh/MEQ5so1b0TCSjT4CQyO2vRAJTA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957789;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=M4F70HveUXtSu/VzsmjPy4tHZsFCCJi8A8Mell8WdKc=;
	b=L1MBYU/dmoAktWFbZlhIdcHsQQV01bbvFIwJC0kbnLBW4NRIGnFMjUTOJfL9OAgJiti9
	 mSqdmSKdE9FoYYcl9ppl2/v73VEIcl1mqmBwP0Rr5AGtA7Zi/I3T/RQbwXAiQmaqhRYOP
	 FUQliz9I2WFh+fJqaxhrG2nvPw7uUWdBCg0yqr8HYq5bXxPa2RycX+cfMaS8X9fNlb1DB
	 w67X6ksTiJ1HuCB2ZfLwqweCDLYbR0p5pRASNyNpE/pfdXgODBhTMCPXXtKi+Zw567UbJ
	 akEy/56GZymoknwK8ytDpCCbb9G2OYu0aVkDFUFiEkGqxQTYSHS4To4s0t+gqCWrjzQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4450F1F000C6;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957789;
	bh=M4F70HveUXtSu/VzsmjPy4tHZsFCCJi8A8Mell8WdKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KU7N+Fshcp+njvgxSQjWz8ncBC2t8clOh8fDbqHDxWNDQG+ost49IPXS3At17d8oG
	 yzrUq2f8CzNgla56ovD/C1g3PDNho1xAMJ3LIOR1ivjJX/UHh9FuqjoQOUrYCPtjnB
	 w6iQ9MOR/d7hkbryXAxtkMOGvCpHEWaz0HOQi/w8auLNeATLghSQQLMnfSFvK/37xY
	 WjElk4B6NdFPai+GQUck3j3SZfLvSK7resWeZpOnwwySP1Uj87YzBYH3UPaVgoeqwX
	 qva0f2Ru0PXVY9L4UhQmeXmJok+5Pc9Q/wDp+neUV6FOaQzZEMeKorjAafaKk9AGNm
	 3IULMFAcacvdA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C5A804AB40;
	Tue, 17 Nov 2026 23:23:07 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Tue, 17 Nov 2026 23:22:16 +0000
Subject: [PATCH v2 2/6] mm/damon/sysfs-schemes: add
 sz_ops_filter_passed_last file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-damon-sz-ops-b4-v2-2-439888fa04ac@uber.com>
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=2833;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=u1DV0UDoFEvDL3o7weOFk6krr3N8RcXJkWhDsTcSkS8=;
 b=ub0fqxaKw5XbPxgkwtlZcCSSAhhCeMDHpt+Ei20JZ5Gyd00+YxJp1oD+Btjq9e5umYV/NAQ6p
 kcAFeK4nKn4DVQOxzviNFD7DIYF18kXYmSqXQEBZipJIznYH4z62KJQ
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFC0520002
X-Rspam-User: 
X-Stat-Signature: fnp4y73t5b48ftsz81po3gctwzy5t6ps
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794957789-236302
X-HE-Meta: U2FsdGVkX1+vDW/8X5LpfHfls2L5YpjJu0ie5SIHEfdtWUSKHK1/X2JMl2gb88hxX2HkPRjDB+/7BpOxWyzhHoD8mu1tgzuwbUQ5+3u4cjObe29L+dpveeov4aEyZwlsLg81n2BHcqweOlB+dxG5a1gZ3o77swnMk0y+DKIA9my6ok1ihWUxDb7dmhWx8GaERIO5giGZt/JThlGBIuqKXwY2Cp4fUivi6M+BCe4i/LitkUJP5R5BWynQeXpcBKi0Tz+PdTbp/d0p9aiizCMlMpXO/QxZwMI7FlwtP6NsvlFo7htDHkoLEiyG1z/Y3iYErmkznBgubKJ7jboQqqBqBTtouZtBqR7guFNvU3Gnxc1+kMzdwB4+US6gdA9z1fmmfrKiiHlwHk8DIwHznMSB9t1vryWUleWbD1t8XvLmqX5SDFlrBEzlKjy4mprcKjCv8g/HOqK1cTGBXts8jOrOhjm62uI3PjPwl8psJLXDDsheHjl47ApyUHBc24By2RlTIxpbl7uvXvfGd11mNeZ64WfvlpNrdbgi4RFa6hNuB40e/eQPlKVdwvE7u35EtoYi1GKblQZ6QwF1jPkCn+TGoTNvc8z5E7Ssr9BHBBv5+0QF0rADBDExjVaBrU7vxpb8TbLQ1s4kpMBc/R4bepps0Gt8p0KD/D5chO+GAJkZenY45Pixls8KW5cTVHcAXJQzQadUNxnyjdTssfIiIApR6P/zox6+nd2NhQeiBUkPbDgJL0B+lkUAhyPS5ku49V1oPfRtd/KKRXx5/49YXzZcLMxEeJBEwUIKCpuE3SExk6amEORSx5nXbhx1XPEKVN6knj6QugG35LHpjieSM3NAzuL5YAkGBM7mSTJCW3R8VCY4yK06kxxnDJRo8fKKP0SPGwHYleUXP7KsKGPtlLmAjaK1f3MzxUkhujSq3O/CObt9LZvDBU4HkA78EmJALucgeS2y19Xo/AwCrCv4biT
 MqVqYC+I
 K1KcaxRjVxl2QcOq9L20G5CquWulgPo09pN5NP5s6l2da8gkJAO5zKeQqpnS2+q+NIKD393eu/FQ2YGHsS0ozlGSmgijHVdieExKwJ04Tb69PCdM/37i3yXy4G50B2vM+9M8Z1pDj8FSqI4rP1wE9jI4/50FdokEjYlwW5+iFw+lYmkhGAO1X5F2XEyea2fZunSkxLj623ElkjSxcvugfrBa7kK8DXGqglG6jRHFUsIRVTnvWZYbjZcJS/VnvUp2NaLiTXFDxK6Z9xZFJ0ymWGLpF0I+K0JgBEj8Bes7MXYpX69EpHfsJr+NeTOpkc9tV4gvOD2Im3oCaO8UPJCToBiz7NbjqYJfMo3Pq4f0jcvMKk/yNZP4CIQaEhcOpsxcxYlEY3bQ6M7t55uSvSpBw224KGJrlXyABBGNrvJWGQ4hjdYIb5eh28KdLnnpHKFYviGMlmZIkV91UpYUa2biqS0NhZ8bT0YWIDdLZZGg8gu6NHw83nzHWBkVSr+gg170S1qxwuAa6H23Kn7hahBJPa6rV2UwgyAqccy4gv/hqa0LZQ662Zbbg132KKSRl4zlYtxngVt/x0lrgnyPq2tsJi0vdtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Introduce a new DAMON sysfs interface file for exposing the newly added
DAMOS stat, sz_ops_filter_passed_last.  The file has the same
name as the stat and is placed under the DAMOS stats directory.  Like
other stats files, it is updated when the stats are refreshed via
refresh_ms or the update_schemes_stats command.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 mm/damon/sysfs-schemes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 230987efac3a..750f70f0c31b 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -370,6 +370,7 @@ struct damon_sysfs_stats {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 	unsigned long max_nr_snapshots;
@@ -425,6 +426,15 @@ static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
 }
 
+static ssize_t sz_ops_filter_passed_last_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed_last);
+}
+
 static ssize_t qt_exceeds_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -485,6 +495,9 @@ static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
 static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
 		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_last_attr =
+		__ATTR_RO_MODE(sz_ops_filter_passed_last, 0400);
+
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
@@ -500,6 +513,7 @@ static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_applied_attr.attr,
 	&damon_sysfs_stats_sz_applied_attr.attr,
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
+	&damon_sysfs_stats_sz_ops_filter_passed_last_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
 	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
@@ -3130,6 +3144,8 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
+		sysfs_stats->sz_ops_filter_passed_last =
+			scheme->stat.sz_ops_filter_passed_last;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}

-- 
2.54.0-uber3



