Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F60EDEC08
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2707E6B0093; Tue,  3 Mar 2026 23:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204026B0099; Tue,  3 Mar 2026 23:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090CD6B009B; Tue,  3 Mar 2026 23:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA5C16B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A763F58BD0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:32 +0000 (UTC)
X-FDA: 84507132024.10.9DCE1E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2044A180003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owu092Bd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YY3w76yaP1+vxQGh9szEkkcRD1UYMuWGT8JryoousaE=;
	b=rrVnWUNuGHg4eo3JDBG1wzj0XgE3S7zA2czCum+weG+ZTF8GCrd1lgwKr9KshVMSjtDNSp
	b91Z0ZaqLyrKH3f2BDI8np8K20m4gXo+vVnr1Eu6UuxZbvLDEPNW3XXLur3CubR8tfoP0+
	7z9qP2dKV28nF3EXKLuhl+xQM9OfeUk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owu092Bd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599291; a=rsa-sha256;
	cv=none;
	b=S0eYlZZqBV1s4h/saYcg6+wfiM5ASlJ5U/d8gPlzh+6Ki3szYOiW0atdgjCxXPln0nqnnZ
	n9FadAUomTZxuGmSwW2XZBruTlsJI5wf6bms7KNTNkNXXlVfynQsfVlTYbW9sJVO0VmpCd
	rMlxgXgLPux2sq1oJ+9Z3mb5hvvmJzg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3CFC60097
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41343C2BCAF;
	Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599290;
	bh=AVTjUet9MVkl4nT/vo+5gBPPg8P0HSyE/9BxBCU3HWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owu092BdW9Ght3CUa+CqgGkZcipfpcKbiZKHQwtZs5mwggraKUlXSfK5aQE1ryiWO
	 kRy1S4peBQ2sKet+Q9ZKi8PzIxPpRE3ENPgEudPWnO7WRXv5tQIuBtbp2kpp6b3P+s
	 bUAcY7mvUnqXAMtx7mJAeIOwX2+C1IHfRXBE7GR8rW41Is0CHb47g6JxO56Ip8vtTo
	 10WiSO0k8VVuH1f955KMYieZqcF8T0jT+LEi4VG3XI0jjrb3XZ0WcYlj74/GtihrnE
	 WuyQFxKATb+Y3u6rM5p93iCur43EgVmQ9ZGHwYyVFXlOQgB17P0S92YAn5xn3vEo38
	 SXkk6NOVEqFAA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/10] selftests/damon/sysfs.py: test goal_tuner commit
Date: Tue,  3 Mar 2026 20:41:19 -0800
Message-ID: <20260304044122.79394-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2044A180003
X-Stat-Signature: 3mend1f4rxb8k1cyky61ycek6hiaqwti
X-Rspam-User: 
X-HE-Tag: 1772599290-305018
X-HE-Meta: U2FsdGVkX199gJGV5n1ZIAL7OrLHSee29Rmy0YNFj6YRBih5PEGH8Tz8fayDYSw3naOOzEenJaK6MQmqab3uloUK8YHBioko9V2bI7YefQ47jc6Z/OAQ3oqaDFx2D6Ht6Dvg1ckUKGxdJ+cgac3FGsjhEyA29mGtBkvLlYR4MMRwEnHR6ohZerU1YVoDS+OVTEkfZabehwf7BbjmPCJOuE4CPb7hnA3azHVPxVkOaWdCj4uz066rVC1z7NZi4RwIgKbMI/z/qgdTm/Ivl4Agqjv6gCFvpRZo6UXDBuZTSkdGJv95JdTD+fr9R/F0mSaM53D0bBPlkSOPg7aHUYMOL2NCPVWMiV6uZQcFqk4Mm9KN9vMEI7amg183wC9J9A7ikGVmoSAHvmBLEoUGG4hkZAYGswb6QcFxX9pXdlKvZfglikfvrLp+KaZLFSygG1oVbc5RnXG55DHb7g10bLTTrRr61dU0U1NqWZex8EvyBE2DdSuzdASKq9Xj0kTnHh37rR/Iv6AtNbAbZifnp9SearK5EAnQr/+qcnMjLGBFkeE7D3KoHuiyzBXVbcO6UzHxKXaGiPqOfew5J+TByz2BQl5s682so04lOhpcO4ya6PI0J1KM9/XdLDjhqIP7HcV+CNzj7d2w7dCDuBkVs+lNz+SPQifJ6DunqqoqBZjav8WcaQaN5IWWwc5ML8lVIbJDaA2sGRAI1ukBTAEgxR2kK+SIxoawAUFUZ3ME80vbk15lZefbM33B1uxyZdm5EDTAQ64l1x+BBOIWumIL5YrDMnSEiVACqvpC+UgI3cPLoxmUHfJddJAFSHvGTlDKiVO3UDns9MliXC1BYAg0dPYt9TpHJ0ptLvJv43AQOTMV1xanOEBEsH4FoBE9EwYxQkdwAwqcavQ4m628iRw2M5QJrhK9S7Uy4B+T+klrVIOX5pPIM117Z3P9l8GXkuG8Ylg4d+igdORprybgfV7BOHZ
 Uw+JnWNu
 C9dRjMN//lMHKiBt4C668eHsnXtwSnaKkFah9q8h6YXdIgQxAvfJI8jstacc0nH50GlVGp+icqDQk1mJB3xnY7YEiGmUZzsQaT/9AbCyDUunTmlWF61SdMi32GiT9Z43/ILY6Rw1UxSd1vBx2631GfUS05adFGCUye3I/3G+F4jJ8AwChBIKBC9JI2qIa7JFXv7l+nFcLv4zofVwD4xN+HZcvt11R+q2X3g506Vlx3KipwNXBrbGGm02zrW3V7fsoaELTarEoyO45o50aodo4hj7alR4z9aZi6+3Ds1XQCFWNkGGOSS8rmgwc8Ke07RtWmDzR9g6qX7fnHfgwHRKmcjMu9lGteHggDAXw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the near-full DAMON parameters commit selftest to commit
goal_tuner and confirm the internal status is updated as expected.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 9cca71eb0325e..3aa5c91548a53 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -67,6 +67,12 @@ def assert_quota_committed(quota, dump):
     assert_true(dump['sz'] == quota.sz, 'sz', dump)
     for idx, qgoal in enumerate(quota.goals):
         assert_quota_goal_committed(qgoal, dump['goals'][idx])
+    tuner_val = {
+            'consist': 0,
+            'temporal': 1,
+            }
+    assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
+                'goal_tuner', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -231,6 +237,7 @@ def main():
                         metric='node_mem_used_bp',
                         target_value=9950,
                         nid=1)],
+                    goal_tuner='temporal',
                     reset_interval_ms=1500,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
-- 
2.47.3

