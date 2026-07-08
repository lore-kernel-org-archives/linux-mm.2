Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DE4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73056B009D; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A476B009F; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39E86B00A2; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8209D6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FFF4120674
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:07 +0000 (UTC)
X-FDA: 84964077534.25.1ECAFB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7906D140003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PG6526t9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	b=QlgsJKNP1Rww9zy0Igheu5nvyOVEV0tE0bS8JbxELP6GaanPxsJaHjvnNaVkO2ZoDKYxF8
	nG/ulw8s1cgk2HV86OgBqIQSRqsFCZUPura0z2Y42Xz2BZaobt4wIhCQGaLEHiFGvxR7O7
	/9TN7Ile3IG2+vNTKqGvkj7glAvygpk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PG6526t9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478945;
	b=PQ2UM0e9Xc3ds/RikOWt+aAZb12NzbdJ1rJH3VHscCN/TDKizKP6fa7bC9q0QKD65FZZ2n
	ueaqJCjmjD3Ojzak6UMI0V/Lf44GoedLiI3JTD8K3qfP6nUxp4dk4ewrkbhKayTYYZuY7/
	/KQWZO+VkIrI0sx3NCDmWBqwO7xuMes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D63A6001D;
	Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CF01F00A3E;
	Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478944;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PG6526t9LPAJzkR8FlalEABJoYHwEKNI43XnOAjFxJc7lWlQHFl1HCjGm+G4g7Gdc
	 NaNQocy+OM38vhhaLb6/rrC6BEBnTAIVfAxGj86h5IEYVvaIRB7bd5gVQghcB/0PrB
	 HJta2RuO5YRDeDcP/BGuewAd2xe28kMAcrljHTjhngjvRiuTUDk0yCW83Yd4GKLbHQ
	 r9+ExzaDgAgOIPnY/OKM+NVM5OugDI8UPmgFe9wGPtWWRhI8qFcV2XV3LhrEbNG2bX
	 6KZ4ZpHIAoo/+mTSmwVv0VmMzJ/j2R3O6Mvmv5f1MrJqjMqRuGPRtOxHYcQQHysJ1i
	 bcNFy+83brJvQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 3/7] mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
Date: Tue,  7 Jul 2026 19:48:49 -0700
Message-ID: <20260708024855.116614-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8ctkpniozxauj3xfpkroyb3esqq84k4
X-Rspamd-Queue-Id: 7906D140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783478945-593766
X-HE-Meta: U2FsdGVkX1+oP0LDKASaVPz69UU2FlbHlvwOVa86dDZXiJfJbMIZ2L43/058UeHXgkaoNyDg5cX49QAfHINbOdcielRdjWD0R2dZzrtpMUMEi8WBmQvIrDX0dfKF8x1Q1wgJN0hLct4ZLQaHX0P+8aFWRmRirJ2Bz3vF1N8lOqjH1Wu5N8PIWFoYqax0NkL4SOnWp4aAAxkkZRaD5kUFlDnO8UhKWzFUXTwMdiWv5xUO3yJ2V3t7JfZzrtM5sdwjMpdHyr3Z/pkoPmboTr/OY7jwdqCBPf3aHXc92LiKm6b+FQhGh5hWZ5SbbOD1N7b36lXAihmAlOZjYFAPTQk1Wp7uOOWihNSd/ymjnbisy6HRx1oIAT9b/R1jvzurrz/wkeO/TJmne9OwD1dpA0sITaL0kG8PVyjuo9XApHYd8jv9gSk4Obe+PYXuNJxCKKs5Zrkx4oLA+Nj7p15wHagUKN29D7LXGwoMMiy0LfeAfoAIF7dv0neIW5HCyT8/ekG2kCArqzbefdGnhPjuC1q0WtGsRVU0HsIbXrE31svHX850AzWG5hQmrwIMXrH/WGAKFmuyAq1tJf1DdWWJHjV98XDjLHtQhcm26Hd2LKzs9IxAUuwDaitTaHF7+aUKFJkgKOC9dY08W6+pfQc6eW13Jdzff7mn36KioBbbo1Za4XHJuwZTGoxIQBnZ5lfVSH/GBA9LiuDy2ObmvkFAj66F7oaoImT5VKuxL6SOH6uDUhDDGpq7gJAvnEgl1ZyRYO+kCAjcii/Q42PC/KX9Zi+LL5Zg/YvMhAA0GMIAtv2InGjkYF9mINu43hVOnpi5eCGXKlzD0HHEKgWpfmBqzN0nCxbcXMt/Ek8ulPhaJGv4Ct5ASfSi4mHfvQXd93gcrYgGjaYGg7tpcX5nOsR0EFrHE0NXwY0DlMgQQbZqUGvNVaKl+2Zni0u7xyOhPLDT0YLX6jztUc0YEvAOB8XDE2E
 T8XWz+Ym
 VP/9YRvT4aDpftkLSC+z6GxZu6FfGHpyRaHz33/pnLSUo2IxIpWRCLnJYjyXhoBzjqSvl9et1dFENWguSvFFK3G2sxG2Z6I4JL3Oh/c7JmCp68JqoDj5wz4yKUEKKLMQLE+7QChiItzkqAbYcxLQ8e+gUvLp/xc8b6sCZYavC3FWGEkiWFGII6OVX7m9pqr8pEyWP3lX1hWc88tSF5BG2bgqpH1oCrEOOWVHjGJZdjVTrPsJw1iK/NRxIaxk8HpiVeXsVaSvvOtVloWHjdOeuf5TNqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

accesses_bp_to_nr_accesses() actually converts a positive samples ratio
to the count.  Rename it to better describe what it really does and not
confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 177e5abc981ef..dea63083917b0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -876,11 +876,11 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
 }
 
-/* convert access ratio in bp (per 10,000) to nr_accesses */
-static unsigned int damon_accesses_bp_to_nr_accesses(
-		unsigned int accesses_bp, struct damon_attrs *attrs)
+/* convert sample ratio in bp (per 10,000) to count */
+static unsigned int damon_sample_bp_to_count(
+		unsigned int bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
+	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
@@ -893,7 +893,7 @@ static unsigned int damon_nr_accesses_to_accesses_bp(
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
-	return damon_accesses_bp_to_nr_accesses(
+	return damon_sample_bp_to_count(
 			damon_nr_accesses_to_accesses_bp(
 				nr_accesses, old_attrs),
 			new_attrs);
-- 
2.47.3

