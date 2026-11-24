Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7130F606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SrK4Q+wv
Received: by kanga.kvack.org (Postfix)
	id 0A2556B0781; Tue, 24 Nov 2026 10:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004666B0783; Tue, 24 Nov 2026 10:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C246B0784; Tue, 24 Nov 2026 10:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9EA26B0781
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B912C160BA5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
X-FDA: 85470415968.26.C234CC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2795418000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrK4Q+wv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534623;
	b=IWmpb8uL/GZt/4i1n6wBfdFoezLtP4vgTKP+zx4D3wkrd9rpUnYl6Kt8D60G4Jrg7jkQ3k
	d138CpUcr0614OQnFjsz2GPzsTLSThwB1vH8RS0vZcYZ1RvDoDe9S7lprkHwCdpozhxtOr
	bd5/97blWhJpRXfE1TZTn028VDxfY+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xP2PZrRzRQskbp3UIKwWTuWy1Ghia0qerPJ0DlNpJYA=;
	b=UHBk63Er9EqDBv7t0w/NspNdRiSAmBc9XyiRcxS2UorrhNxkrAOkoPbp5TDX161hAM7OZ1
	ZLIXe+N8fLGaJA0LsoScCpNRVwLRJKzTKvUo+IGWzEQKTVx58QhGQZH1yVc7FMVNxN9O8y
	tGYdWBI9JOH8DGFH98rtNBApGv1+bMo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrK4Q+wv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BC4D414DF;
	Tue, 24 Nov 2026 15:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FE91F000C0;
	Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534622;
	bh=xP2PZrRzRQskbp3UIKwWTuWy1Ghia0qerPJ0DlNpJYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrK4Q+wvIKG14ud+R+6Q3s8fJX1cOSsHoiAnPzbBOnQDp1P64o4KxtxlV3DJK+eA3
	 paJihIaYZr5X3yUgVFrHdbgG85xByonZuXvCnEyowI5JMefBN+Zr+r8Mxki7fF0eTu
	 fzZbk5jadXOJn12kBiYBlKQbR1E4J8Axl42EeEhOOy/Fres8/Bmtusd+xLrqkIiO9f
	 XXpA32TGpc7wGJiAnoMg2p7SOjHv7H7fH9qQjySlPgVl4MTtQ5n+MDRyOLHGTiTRf2
	 PW1JUxBA7KH6jxnj6gVMrmzQG3ecPTrEjjB0e+PpZ2XMAbo8II0HjX5NdMPzvEA2rV
	 JZ4W1CJL5RLcg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 23/27] mm/damon/sysfs: implement submit command for report producer
Date: Tue, 24 Nov 2026 07:36:29 -0800
Message-ID: <20261124153636.91854-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5rx3fxrpkkqxuu78kexsy5eht3ftgapp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2795418000E
X-Rspam-User:
X-HE-Tag: 1795534623-673233
X-HE-Meta: U2FsdGVkX197ue1UZXmLrc8auFwpJhv0zltwhTShbyoMPo8SuIDtTbLMa5KQCciQmCn6cc+I8AjPdLjS4eD2mdY3UuJYRLGgV4NsLXSo6YbeqRIp+0sy8mk7F9dT2dzy/0Q3Tkm+do/aNkNk/ZkL7qaFDrdJBIzGaWsrG366v7ypLb5/dnHRKEqRvhiz2udADrX8Ya8bm6PB1rRw7O2RYpZ1PprWEhV+mPj8bxDyFBhLcelA1j5PqY9aENQY+D0opIurnBwfMaV7n1yNQEBWMnLlos1XkNfA7vNWcT0t1G6Rza1IcenrtJe6fPiA7AAmEWnF1tesEfuiBgCXQuqMEF9Z9eujvvLhdu/TbQbfClyZIfEFkhac9GkbAHYX1SSIs3Dv/oY9ECl0JVh1vajP2/zzjOKznQuzd11xa6vGhbno0qe5QOd5DopcfV8DBEi/Xxc2YOgnvJW7MwilDsp0A/bTQlN8CrGseZ+AY6pxPfbEHjJ8Mnq2xO3mOMH3DIivacacZ0C6Q9W9Iz35YI95VyqaIKGANh5UDjlNVx+jKT93PTUdTeac/VbtLhXs9UOL+XUJ4Gc8Y3PZdce0gNezWOE2nXz2s3ohFb8fGRy8Mg9b9DRR/Ku98FcBG3rODGBurwapFKpLw3t43rbkJv9jC1lfrdeqRBENqrsXzXtgSeXMVf23SLniRtbd2BwW340UZXBhTJLWqxZVVBqhnk6tbRSegtvxhsBwNaCaZ87Ud9YRJHlqD81fszeENrOMIJ/6zUpLcECEmGwbN8muYKY9cPvQf0M7wRGZPLirxC0GUX1I0r9ROCvTSb2sT/7cIrVOaRM7ZQYLh3qcmXQD5MJ8TgVi2B3LI0jeffqJILvLiQlD3OJ9xfpu73sdCLi8rFmL4sD8jVuO3eNGy0PtZ8IcldYssbh83jSsY7oUVvG6us/SAHRXaX/YrxHIrDJAvHyi4WrlSQlz6Ioshojl6Qm
 7Ao++oK5
 1UDwwsoXupUEnTUWitj93z475i0A4PMGZ9uZ7qmn8YCPpnlCYVcHqaFuvzh2tOHD7gND8nlMEPv9isAkbmSzb8ByNzKCyyx0w4RkFeQHOo1uBaqZ2Lpz32LGvmgLKlc3U+isFwdZrVZs3oe+e66shDrNQ8fQdTKTTt9lRcBRAYtuzKzchW7gHycpP+wy9XbRrVRQwedUDc7pJtnFNkBjMVc8kOrnnsDsd8HQDIBi2EuPxHokMsLq+XiqerFresRG6dWm2GdrFwEF62GbxkSNsNB0qzf0TRJc+Su9nivAJpg4RHzKxw3NU2jk+iTWDsL2QFmBhf6Tax6Cp5IkJOZAC94Eiz+5a9LecbX2yAPJXOAdiZjXpeEX3GK4smaVXER3fNTVUTPjCeglwuf+LWds//XYzW0h57rk4yxfeO8da8tF+8Nb/Ojktj0B2OXz7mkp++FY81Xs5b4wzTgoeYM7rl0FTa7lFknLAXJNb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let users manually submit a report of a data attribute for a given
address range of memory.  Let producer_state receive "submit" input for
that.  For the input, generate the report based on user inputs that are
written to the appropriate sysfs files and submit to DAMON using the
core API, damon_submit_report().

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5f9bb1955dfd5..0049aac6ab974 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3107,13 +3107,26 @@ static ssize_t producer_state_store(struct kobject *kobj,
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
 			struct damon_sysfs_producer, kobj);
+	struct damon_report report;
+	int err;
 
-	if (sysfs_streq(buf, "on"))
+	if (sysfs_streq(buf, "on")) {
 		producer->enabled = true;
-	else if (sysfs_streq(buf, "off"))
+	} else if (sysfs_streq(buf, "off")) {
 		producer->enabled = false;
-	else
+	} else if (sysfs_streq(buf, "submit")) {
+		if (!producer->enabled)
+			return -EINVAL;
+		if (producer->report_type != DAMON_REPORT_TYPE_USER_REPORT)
+			return -EINVAL;
+		report.type = DAMON_REPORT_TYPE_USER_REPORT;
+		report.addr_range = producer->addr_range;
+		err = damon_submit_report(&report);
+		if (err)
+			return err;
+	} else {
 		return -EINVAL;
+	}
 	return count;
 }
 
-- 
2.47.3

