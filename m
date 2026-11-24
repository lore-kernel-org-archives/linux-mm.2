Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC3F606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxDm5Oh5
Received: by kanga.kvack.org (Postfix)
	id 9BAE76B074D; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B476B0751; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811666B074D; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 500956B074D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F903A87D2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:34 +0000 (UTC)
X-FDA: 85470399588.11.91665D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C39C516001A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxDm5Oh5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534232;
	b=Gdaa9pBGvIANCV7QKZ+3sVEelhj9Ex9j/NtqKIHjZpFwGDLpD//cEiryCWrzaw298KAV0s
	AN822c7wOQhGl3osp6Ub3miN0/rk6Z4KhTP2zpLmwEg0qskDT59PuwZx9xK9MzQ4SX6LeA
	wmxFBZ/7U3MUE+13P6b01QkkeEpbQv8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOP6z06Mszi9tOw3c6/ZPqKBCxHccZTSPVUgIScNGlo=;
	b=rQAWMc9ne6rkWwKaXJg/Xk9InanWlpLr+qeV9sE54nxQBt7pEm6fRYBjIEmsnOfzD9OkDm
	74evBOOk/B3UTANUOIb4QVu+T4R+kU8pedsLgpdVj/HfBk376dG6fzKe05WosOyP/iPKEF
	ncG3Zwcsw1l+y27jLlxz2OsYorlOTUo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxDm5Oh5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C95744D0E;
	Tue, 24 Nov 2026 15:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885E51F000EF;
	Tue, 24 Nov 2026 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534231;
	bh=cOP6z06Mszi9tOw3c6/ZPqKBCxHccZTSPVUgIScNGlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxDm5Oh5YyW/RiIDG+nOHWPVfuG+PMB4fa3fW5S2XucFV0371T2tkOSJ9gCN/Z2Tu
	 yzJ1ofDKTtH1chmS2ZxAjc5wm5tJ+nKaJJRNg9oh7QLz+QMpqMsS+zuLrzJ5+D7qXI
	 C3nxOci2TLDvba0udKNdt/ZDMgWK/MBIZU4Vq4yHfZS4zrz6727CP9c9w4f1hZe7Op
	 M5Nj5NffF2R37A6VUrn9dRsgZtoeiGNFklNiwBwDthIGaqSdrBUc6P/b/9jvyuhSNm
	 pb012woGppWq+lSesIjXiIat00Z07wukreOzp0Hbbls0ckUpXa4WSp+vMH9fs+WD/C
	 BRNcZlscXfUFg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] selftests/damon/damos_quota: skip the last sample when counting exceeds
Date: Tue, 24 Nov 2026 07:30:19 -0800
Message-ID: <20261124153021.90142-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153021.90142-1-sj@kernel.org>
References: <20261124153021.90142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3sxo3ex7xzzsmihndksx8xk8575pu1pf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C39C516001A
X-Rspam-User:
X-HE-Tag: 1795534232-573208
X-HE-Meta: U2FsdGVkX1/7xL2QdPLNLwH22nm6BmcdV89HxqssdxzKrCRVemsK6XIqWiyXqiiGtu/UuV1A4dhC9CcB7v5PN1CwYOv0+p3cOI8TQfi0zFLuUOXHzZfq8BI4KC7EAte7CK7QaHfKgGuOHKCA9c38c+9r0PVyjIGQLHKRHLaCMx7/mbuAjyreRtRP3Wnpuuj1Q7PzqFb+PQOJw+QFQsG3hYPux+vGqkP4ecn+psEUtpUWLPU0exbfhBbVKbGIdxhR1ywk/ABW/8iAxAA0gtMme8kOZpmT8md7cm2tQBX/IyNv8IRbO6+2VAceKeAHMzkZKbi9COq/yvPMkJe8LNE0CixYc72rxHJP42hqmQJpajvJcejnDtiwVEeQgvyKnYt7LZh1vyb4qODqTqEb6uKBVk/BRHuRZkQci9UHtCju4VPKwDROXCGnf8GsUrLAuZPrR7NfRqaBjt6loU5dkmQy44Z8rIFhbvOEG4YW27iQmmZrRYIp8VxYS8jV6JtvBoXn2X75zZsgLKA0FVyp/psryPmAYwLY0Vj3jzMMvE5C8Zge8WWWOXM1tQviY+sGwkW2jvNFGrKHKqJglpi9DbDG3c+kVv86RI8CLU0Wp/qI+cubwDOw05H589FADSKvSQVH5GgfCRpx5N3r4+Xy5Ok1sdgIiDoL/K5AfaA58LpdStvYStlF2zK83Y/PIOMWQwFRax6KKHj8gMO5Bi10Svn6wkpa0FKsz3M/gavj3vDwMprevZ67kEVBSDOroA059ZHJz64vVdxQkG21khTl5A9HlTEfXO2MROcMw5LklNoPiZAZP2wD24/IQwGS0QM1B5nq55CVF3kTTVxVQcLVEKye+iqKTnXr7VDUL4uyS7fROHME1mJ7Tnf9UeEVHJ60vDKJmkQAz80kgnsarotFhUszg+2UPa4KhxX/lkMH52WkSOwx7eyqAh859BTT1690ecxEiT8JQ/GP9BGM5sCFgg/
 zUxBlq2j
 bh48Y59g8c0QEGno0nmm53FKipxZNYYX1d0SKwRcSTzhN7mFA7q/rwISnEghIAi4e3LoYPNYvZnlDXCmTdyD6BS9cuevRd33xlwdBKCb4aL5JPWCzmeHdnOhnm1rFRZxF75WBB+cDIw58fCY+Y/gd3xqpNLbFc+DXl1t0gD0B+PQfWDQ+6I86a65zQR0htasNvibAFsXujIVYTNo6f/2CQW699Ss1p8AEmGexIezeixtyEL0rPDx6sBF1PQ0mklIcPNgZkF8Wv5gaqoFEVmJutz6/hEhr6/TugWwtkGB3iflxOaI1+JSONAFUlZiHrhlTLf+WHYGus8fUwEcD5atBGmhzBnCsV0xVYdGyTkLiV6+5WrnaIqN0kxsubW87inmYxKA37Em4kvCMZfgFyFrDZnfZiFGWaZKHMpNJ524ApKdfdc0/9UovNNyqHEvUcCH+TzkW9dVW/JlIrfT3DS0oCY14vcOd2rW9wF2p1ISwuL7KW3ihc1nyoeHKahSNQWf6k/OEOznvDvcGn9I9FN3tSkGV5fBori00HkQqUzuBYVp2X9ES7bcYU2+nhpkTnsgMbFxqy5HqtbgisI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

damos_quota.py expects qt_exceeds to be increased for every sample whose
tried_bytes equals the quota.  The kernel increases it only when the next
quota window starts, so the last full window may still be pending when
the workload exits.  The test then fails with an expected count one
higher than the actual one, e.g., 15 < 16.

Do not count the last sample.  Also drop the sorting of the samples, so
that the last one is the latest.

Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261117-fix-damon-quota-selftest-20261117-v1-1-c65d687d3def@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 tools/testing/selftests/damon/damos_quota.py | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_quota.py b/tools/testing/selftests/damon/damos_quota.py
index 879115a499bf8..bdfd22f000795 100755
--- a/tools/testing/selftests/damon/damos_quota.py
+++ b/tools/testing/selftests/damon/damos_quota.py
@@ -53,15 +53,16 @@ def main():
         wss_collected.append(scheme.tried_bytes)
         nr_quota_exceeds = scheme.stats.qt_exceeds
 
-    wss_collected.sort()
     nr_expected_quota_exceeds = 0
-    for wss in wss_collected:
+    for idx, wss in enumerate(wss_collected):
         if wss > sz_quota:
             print('quota is not kept: %s > %s' % (wss, sz_quota))
             print('collected samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
             exit(1)
-        if wss == sz_quota:
+        # qt_exceeds is updated when the next quota window starts, so skip
+        # the last sample, whose window may still be pending.
+        if wss == sz_quota and idx < len(wss_collected) - 1:
             nr_expected_quota_exceeds += 1
 
     if nr_quota_exceeds < nr_expected_quota_exceeds:
-- 
2.47.3

