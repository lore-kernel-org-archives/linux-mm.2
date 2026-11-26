Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA01606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xmi5SGfd
Received: by kanga.kvack.org (Postfix)
	id A40D36B05B5; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1FD96B05B6; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954F46B05B6; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2966B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06EECA0118
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:33 +0000 (UTC)
X-FDA: 85478503866.05.9EF2FDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 68D714000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmi5SGfd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727191;
	b=V6TpuNGprCGZGDbWBfnM3DHS6/S215g36GbTLjf5/MgiC4sVirzToyYvAmgxwz7m7RMt73
	Of8VAkt+F5Z0jfWKFzeBakS67biWI31CrWwmurlxb3g5Y+846SGirEkj8NEQLoG5UPsQ6w
	G8/SeEj51/5DaxRzJPkEVz196jMS2vw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5C1Fnmr3G939IHc82nwcjXrz6u8/TH6WDAdqRMpaBxg=;
	b=j9tjdQJjTlLzC0eEN0bRpLusCC6Xb/itNTi70FLg7Mdfir8o+SEug2S+ijJCqz4UgVBLeN
	mpwOEeMTkedlkZcFR0S98ZVcN1M0u4j62ruayXAmBZrJuXrFJA4jfYlZ+3lmKPIyyr5Vcy
	HkQTTWDp9nMJuCEH8ijGEW9k1y799+E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmi5SGfd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C5126134A;
	Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3461F00897;
	Thu, 26 Nov 2026 21:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727190;
	bh=5C1Fnmr3G939IHc82nwcjXrz6u8/TH6WDAdqRMpaBxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xmi5SGfdU0kzg0I+KEwljZ3BnPTv8vnJLZ2NblUdjVNMx8vqIJNniF2GrOUz1K87O
	 ZSrBzHWQZoHhc9+WXblmSbIpI3D0G+tR8taErL3DIa3E5ixcbXjDOtg5U6NOKQRW2h
	 kHHg/XW9ewZpbJ7sDdC3U6hYtZPz2NYCGaoU77vc+cDTh8wjq/dzKznCs6wIW7SjKV
	 iXAfkTrTckgon9Y1V4npdN8FGubP3dZRT1IsxDvTC8D7YqR6oNedsy0JQAba0OCcmu
	 qMI4e9CAeifoQU7P43hZY8YUdIOSF77LpxDRFSjszc/WdPje8M0tOFTgqueE3gWxiO
	 TZgC1OJF+xgEQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] mm/damon/sysfs: use damon_sysfs_cmd_names in state_store()
Date: Thu, 26 Nov 2026 13:06:15 -0800
Message-ID: <20261126210619.97634-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126210619.97634-1-sj@kernel.org>
References: <20261126210619.97634-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 68D714000F
X-Stat-Signature: sqjh9z31rggjdqfk4wxaurmfed99zczb
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795727191-781252
X-HE-Meta: U2FsdGVkX1+acsH3yKf2gxzgiUjVlO4De3Agu/Qr+keEtdxz8o3ctr8gIE15TGiRyam1dk3txWkZ7ViZKRQNh4/cy9IzQK8kqSCCLVypQ6RgTR68ut8xhaa0XE2KMB7qzcDnr25VPldIsjQ1Kf6LWIuhnxbPn3xf2jt/NHOLwjZxMOdXF2AG0fUaSbOveeiwSfy6vsfJaCPjZm9wwM39sOUv3unGEQpiB+RXz+nit+NTvdDOAaa35sK/I4L16noguYTgS9mZpBW60ID+xmSosy6jy2cARaDaULV0Xk5/T5ehv03CggVjfoHrAsQEZqQhA4TwLdnoMzNUGXyUzyhWXv5DD21kZk4CEenSGb2vxpcrliifRZ4BMLjHNaUOyjjsD24pf3MQSo9CsIBBpOMlAO+y7I2TnGfLL0aZm0dvgcMOiT59uPLE6r15iSyret4088TeWyu9TIBW1i6m3Q3XEJ+cmhHqXvITlqDtYrl8Qsj74ltwqM8OYU7dQer0tqqtrTVZc3Wq1ar+rtm9r16/HfaTb+S7P/SGajnCgFZf0oyHlxuavepIWUhM4FHZiRY0YOQskplMq0YDqGCSTbchde4cmtqNXqhMcn4tKccNPo5Y50iVfInAEoPFz4AKjLq2VfsgzvbDFmP4sVbw6mAfPOuPm43rNm69hjqmPK41S21HWFMozLD60E6WxNHD6YYODk2Wgoopcm3X0F+xfih3wpTwv6o3WyTrZCPtv16GRsLXIGni3SfIQZydQz6cahQiyHE7tVKitV3S12XvmlPFwh0IMPxXH1WXDgHq49Pq/gFxOE88X3rEFPc9gQzgCEsQNvya0FZIL4/uo/pUG5yV83y2B0M0cCeQ+Ytbd59CS5p1yaPANUjtDb91UzrYIqJ7vRWmFvwFQemnOKu/nDkG5k8D+u3gjjOIukQvMuHVkmiLKwAt0lDEg7PREdoyCp+VaT/XOS19X9sxRZ6/O/t
 JuEWvPJ3
 r/JeoQV5b+1ksV+IIZMhFAmtrGSiMYqLmNSr0mM1s/64uEsSQDPpP8/W7xsunisQVOxsOc22MqgRhm8tPiUWXJuWneMZStwZDjo8yShaon44QTJCJfvKV7B3Yl/GWzkLWDCnj5hJHquxUbAzYXfNwH/ordAqoUkH0qxkfirShnHp0TNJVSegTBRbuRRyJor5d0xJTUo7WHfHlIpRmIVEyhNvNQoYVc05KrcfGmBywmZiGITHCPN/LiDtloxzzbcG2cgr7QSE7fw16py/IewuACw1jN3xeDpfpQHavFqOSN18FqVIkB55jVfaYvyAHsd3Rc+8rxcBZ5mcq1xWlt1eIOyL34JMsrlSjZX267BgdIKR0o9tbsALr194970i6WsBGGkKHaJbfRdyTLZWmGO2Z6rzSb9u2M90z+hQ+FSo+miAW4JWeftxybqtMcnGcjD9ot7gK81ZjG7Zcm0fGuVFTX3ME6M/5M9kWsOFUeAxbUNYgSpkToeWZ/Uu8MTbR+asgPspa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update kdamond state file write handling function to use
damon_sysfs_cmd_names instead of damon_sysfs_strs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index c76063b703a4a..e0ddf4ed5dbb3 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2848,14 +2848,17 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	enum damon_sysfs_cmd cmd;
 	ssize_t ret = -EINVAL;
+	int i;
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return -EBUSY;
-	for (cmd = 0; cmd < NR_DAMON_SYSFS_CMDS; cmd++) {
-		if (sysfs_streq(buf, damon_sysfs_cmd_strs[cmd])) {
-			ret = damon_sysfs_handle_cmd(cmd, kdamond);
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_cmd_names); i++) {
+		const struct damon_sysfs_cmd_name *cmd_name;
+
+		cmd_name = &damon_sysfs_cmd_names[i];
+		if (sysfs_streq(buf, cmd_name->name)) {
+			ret = damon_sysfs_handle_cmd(cmd_name->cmd, kdamond);
 			break;
 		}
 	}
-- 
2.47.3

