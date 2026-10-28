Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16395606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfbsglmg
Received: by kanga.kvack.org (Postfix)
	id C0C996B0996; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95916B0999; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999A76B0998; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7854E6B0996
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91433C023F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:13 +0000 (UTC)
X-FDA: 85370830986.05.14FAEFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0D145C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfbsglmg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793163552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnCdwdKLIRu22zpmh++d3j4s9fK6gxqvvFFUcjcNhTE=;
	b=Vl24WyMwlKnIsQzUgD9p5ZI/c7SY72u4ulnLFUgrTMxwBKdVYYlf2+C/JeM4zawjbr4Srd
	H5xN+KEwdoy2kJ9QE23Wo6WzA+/CGf9LEVRx4jj6EXBlrfnHL0Mslx8lhj+K0Vn151/nPP
	SYruArExBrahwHiXBZDgNV+2yHkd+4c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfbsglmg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793163552;
	b=ZPZvgGZ1Cai1rwIbiXlohf8v0klsxQ6lhD71V14KCyuRtccOgOxKAHWjmDayISWpwFEtEb
	e6E9ExboEXH2PvWq5VIUzcoRpSRbSFeWmD6sMsjYOykZtxnallBwPBjDt1vmKODEGsv417
	U6LA/vU2duQblM188ygJvOGd7bXst5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABAAE60202;
	Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339C21F031E2;
	Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793163551;
	bh=cnCdwdKLIRu22zpmh++d3j4s9fK6gxqvvFFUcjcNhTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfbsglmg0+TZ6THLVRX0qLqt30DIt0C9NinjEXkc87nzikN/MBclOKSoN4EZdmdLz
	 aNhVwpFXcsp3OJRBYSf68s3HbpgGD+u39Yotnh68vcoPDsRPN5EAl/EHLCvCxWCKgm
	 n+Gfok7s1IY645SH/EHgPYZhmRAaRjuR8o5ZolHbLoKEHlUUq8kJMomgC0BemNntKz
	 rT31BLcvYCutKTRgYxM6FxJqhCCr5x2tpCA1RxJqX49TZLQkGd7hgZqeeT1J12OJO5
	 uxV8gN67OboDQMHPRicSd3jfFiF9HJByiscymUDgpZIUDc1Bg2hnFnbQVKsVJaEp7J
	 7IH9jqKpL2QDg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 2/2] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Tue, 27 Oct 2026 21:59:01 -0700
Message-ID: <20261028045902.148624-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028045902.148624-1-sj@kernel.org>
References: <20261028045902.148624-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D145C0004
X-Stat-Signature: u1s15ckmdj5abzh1e6fz17addnazwq1u
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793163551-9372
X-HE-Meta: U2FsdGVkX1+nxDuxW+ku/v9S9GA0D+uJP1nCVnamIWWeh5kyO27xhRmRTHOdbdSdRxhqIUUcH3Tc2R5srVwUi07f/0qj0KvLJqU2ezMYee8hGqTrscX2bTB/2fcpkYoyrdWnHdHkfov+dZGVSWwDlaadoLjeP8XaOzj927oDlNMaZ7maYEhxpnsKFQVLI9SjfdtXbHshM8yyUHtD9SIc1VfjR0MzWBqfC3F32mqViOiNpbhW4Yl+UlEoYWQj81B2EeHWg1QUKUcVmx+iH2HWBK69KDHt5hE5IjZsb5L1NvL5BlPhgDSuN0V5WPZoc+QrzUaJAhpPDmUo3VTNFHnte+6x5j9n0bAsl5E8P6WJe4Iv1ACHYkyOWkzvI20U7k61TMjq603o1LR6jy5X8VuzVnX8QwNkaDWf8VmjIW/V2GTKqpnY77EWceUzJAYcZK9JSZmxKkrM9iRcJF/BIApxIQmiDgT543eCtbRJHrhIRsadDAAAxx9ysUc8BlJmolDcROJjTaSFcWB1EOsj8Yymume+5bPOjKMP1sx7kG8OYmS+U1bRNLh4BrNWU6xiqgt+WBtl7O7v3R2taQbtDO4ZraBd3/WIa+K360drZRNEtX/hYGT+7IyYk5/ctYaVSWvrJsg0z/Mo4qp44u40VecMDreY910b7Ek6FGepg2y8qUKtsWoR+aNXaKxPzwgmoPDmBedhU/w7dbqtnPLQ2TTTwPw/TPlKgpuORvrey57k2/O6EsCJS0a4FSEqOsvVKpgC1mMPa8u45CJYqDX2/cLTPUGdeHSPNv5qPvZO1jiS28kFHiEz26upuds9FtFlt2E4VNNbRAjxkAUWHdH5fJ2GsL+TFUZWTA/6ptM/f/bV4XyKgii8ZrXQ0cnhFmAC8Fezq9mWIwCwDQ4yiScGyBCU2J/1PI5yv1CnTzfnVdTCb7G7BWtlzOZdSYp6K4ThjbztXOvPSi/dsRzLEW85/OP
 Da9wWXPr
 Yd/JS1mUTooBNzrGoTRsn7McV9z8STHDsnLX/kqSXQIkp3t6jngCASlbibblUhV6XtNymvuSKDzinVdzvdihKyxwpLIP0tdgqFv3fE+iMRXE/fGnwMIl0OObWPk+wT0HBJZIVWnvvTwjrCShA4q/+IBdwisk/ZfMrvfK1cyWuSYb/4kt8x/5iOjXRZH6O7/AXJ3aCf6liRWPT9BPfqCsVImMH+Oar5hg0DWJmzRW3GKs31crspdBV9Mg/AgIZ0wuYpjO6w7IFuWuAoKIpQyrKzeinFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d95fda1054a00..f830b873d05fc 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1433,6 +1433,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.47.3

