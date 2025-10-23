Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E09CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1478E0018; Wed, 22 Oct 2025 21:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79EA8E0012; Wed, 22 Oct 2025 21:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C689C8E0018; Wed, 22 Oct 2025 21:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B72298E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75AFF5C0C2
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:44 +0000 (UTC)
X-FDA: 84027637008.13.BFCFB3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BBB4714000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hiqf8kaM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182742; a=rsa-sha256;
	cv=none;
	b=RxamsByvfjGbenoCANIT/sX0WCM1or0SxEpWDm8rtUqXMe8TQ8/c/iYHZlHJHSsq22Z5Dz
	RF411LO0Znjf/AxjZZlyUanQyL8bL5tVtwpCDvfoB9e1hLWygaNKgvEKb+PjoR2KQDVRkc
	9CPTOyjEpj90c+B7pF+JNGTobLkhXwM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hiqf8kaM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBmdMcxFtZX/k+GuToq4QGpejk8/ZkvayDS0bTDI7NY=;
	b=mvrTF/X71u9/FRrA+ljNcV7P7F/dZEQXna6lqUNVpued7uTswAhtBnUEFDKv8SwKLYcP7R
	Msb5CWGtG6Wns/B5nTeZSm7g/c9Io5xKx/B/I63mOSqVmRvZfcjZYVAfzdklrHos/PyvFs
	a0BWbM/H3vUHBBPpMseRtgpDVt7dAO0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2AB74A8D9;
	Thu, 23 Oct 2025 01:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDABC4CEFF;
	Thu, 23 Oct 2025 01:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182741;
	bh=oyDZN9oCVEaeb/3UXPzhIKvg1TDMd2tTbJ81AbOf+E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiqf8kaMA6/9WJy1wPmi1bMps3cEPFsKyAgqTYZtSH9LZaIsFeuSE+PsB7I/2yRzM
	 Ofhu7Edk3uQjgYLqGHd/BpkpGL5fRqXQLb5EwOiLp95Tk+W6wV7UD+F3bEfiazBpRi
	 /aN1+5J6pFnC4cQ6mAQG0COQacc+raCK0J6MtaXacibc/RPZUf3XlDitDADNzvNPUL
	 I8W0HIkAdboT4LIxSd9GbHbr9LzfP280XIzy5dCUDAWAb78TU5k7wMianWWtAVSUXt
	 pB3qyNyvR5OtOu0Xy3JUPXK9Tv2cxVUW79Bi6O+v41+bAM8+jfljm0OhJP3Les/Rx7
	 zfSk7fUZ/69CA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/9] mm/damon/sysfs: implement obsolete_target file
Date: Wed, 22 Oct 2025 18:25:27 -0700
Message-ID: <20251023012535.69625-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BBB4714000B
X-Stat-Signature: pb7w4pgzo8oh9x35zxd491uphqaomj3q
X-HE-Tag: 1761182742-625893
X-HE-Meta: U2FsdGVkX19i8CjWexYCUpuukMCqVbuVaI96DPLN+tDSsR4TdCxFPzj79aN3I6ni+ZfvsmRsk2TkBjaWAq2egYcXL7GPuEyzwYLyKOJGALrJnt0EDYR1U0WCajMHA8ddfL3HIX7e5tMVKX0MPF2WxsYYs55NoO/LdcdcdbyBV2IImKghj58wY0RUXIFTF7vRxnHbklOcHFM+6O0pLIljgW6D3RZAKX5IZYexuNdfotMfEyNWpZZ0u4VUeQEe8rMIqTMGfKsSrHL39jNHKp7nzAduTcvKxJFZGeAlFn1hjzcTq+EAA34CDuZGdihAnC6Ua0k9A9EckgBOxYqjLKg62f3CVYsfXE181maI4YtZWkEgo/MvbqurCGOHXLYh9kl4OvgFStyr5bKiSLAE4ZzXOB1C717I6jT3tbt0fO7wxgkO2pkFVMWNnXlNbvaCKqsNvPdLdKNsaTN59mLSH4jU78qSpAQcf0UjtHHSkl2VtEL47etloKAWA29bryLjcUBGr27GMinJa/U7aYKZ368vV+USe0FbRrC5Nolq7ULendsCfZocgtZcovMREYg3D3JrcFw2eKMJ35U40Ywi3opw5vr9kiC2CVb/En519z6bJs5rDOXgL5dEZksqu7layBLzK2kEZjDicu3q1S+eOgnorY3Zi9STDTUfTsoEUgTV3G5WykXGYBTdxkakRW+RHjHRZ4Yr2aCEoigiyofpRaR917SWB1xOzv/XSFF2ESHtRJcaiiu9IAUGQPXXjRHgpUuzVY+eYZ/xGB27kZQKi+nMMAJH1x/Vash4GLi66Z9O38sRVUIzoj34V+I7aj3Zp+28I9KebwiNQlak+TQupvqFk0s0Lfs5Ey6cG2A4dqMRHc3W18+Z6maDg4i0Mbor+eGRgjihbZhOP167DQoKJrSsK2bsscCRqSUtA69Qzs87Fy3nNsnkvJQQM7HxYYKr1ngnTObCbeRgGVtlk7JAMF5
 Ov//yG3t
 fCieecwIzrfl/+TtzXesv+RGoadkhrSBR3luNeSHGOYOksBtpiNOl/pxm58w9EiL9SyDpCQDGgdxZ/XiOUs5WdgNNjPObUnC/7yDdfcne/0QS3Ew+WNlO1K9FZNkjEngQ4TA5s3PDcwN6p+w7fJ1Kq8OURazw/F8UmKk+E3I/e8WhgEIOA5hL9pdKBAZ17yCPu2qYhG+FfPlONhHQ1dRirqqoIqEAprCXRwtmIEWRbKRrEr3TOiDo5rIokkOBopKrvd0TNVbGK+k7raJ50zhDroy7WbZyhd0DQPxuQ/wp22K+dztZy6CZp8BvslDwOntJHurP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no good way to remove DAMON targets in the middle of the
existing targets list.  It restricts efficient and flexible DAMON use
cases.  Improve the usability by implementing a new DAMON sysfs
interface file, namely obsolete_target, under each target directory.  It
is connected to the obsolete field of parameters commit-source targets,
so allows removing arbitrary targets in the middle of existing targets
list.

Note that the sysfs files are not automatically updated.  For example,
let's suppose there are three targets in the running context, and a user
removes the third target using this feature.  If the user writes
'commit' to the kdamond 'state' file again, DAMON sysfs interface will
again try to remove the third target.  But because there is no matching
target in the running context, the commit will fail.  It is the user's
responsibility to understand resulting DAMON internal targets list
change, and construct sysfs files (using nr_targets and other sysfs
files) to correctly represent it.

Also note that this is arguably an improvement rather than a fix of
broken things.

Reported-by: Bijan Tabatabai <bijan311@gmail.com>
Closes: https://github.com/damonitor/damo/issues/36
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
---
 mm/damon/sysfs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 0fe6ea68d311..43ee9ce4dd84 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -212,6 +212,7 @@ struct damon_sysfs_target {
 	struct kobject kobj;
 	struct damon_sysfs_regions *regions;
 	int pid;
+	bool obsolete;
 };
 
 static struct damon_sysfs_target *damon_sysfs_target_alloc(void)
@@ -263,6 +264,29 @@ static ssize_t pid_target_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t obsolete_target_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+
+	return sysfs_emit(buf, "%c\n", target->obsolete ? 'Y' : 'N');
+}
+
+static ssize_t obsolete_target_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+	bool obsolete;
+	int err = kstrtobool(buf, &obsolete);
+
+	if (err)
+		return err;
+	target->obsolete = obsolete;
+	return count;
+}
+
 static void damon_sysfs_target_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_target, kobj));
@@ -271,8 +295,12 @@ static void damon_sysfs_target_release(struct kobject *kobj)
 static struct kobj_attribute damon_sysfs_target_pid_attr =
 		__ATTR_RW_MODE(pid_target, 0600);
 
+static struct kobj_attribute damon_sysfs_target_obsolete_attr =
+		__ATTR_RW_MODE(obsolete_target, 0600);
+
 static struct attribute *damon_sysfs_target_attrs[] = {
 	&damon_sysfs_target_pid_attr.attr,
+	&damon_sysfs_target_obsolete_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
@@ -1377,6 +1405,7 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 			/* caller will destroy targets */
 			return -EINVAL;
 	}
+	t->obsolete = sys_target->obsolete;
 	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
 }
 
-- 
2.47.3

