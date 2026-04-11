Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA75BF3ED5B
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226FF6B009F; Sat, 11 Apr 2026 12:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A756B00A0; Sat, 11 Apr 2026 12:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B4C6B00A2; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7EC96B00A0
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9372D5B764
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:33 +0000 (UTC)
X-FDA: 84646861026.15.E2A0BFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C378C0005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XO1ZhQqa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926172; a=rsa-sha256;
	cv=none;
	b=LBc14JFHrwEWyLloa27WcAo41MEjYVlVMG0bDMGOkWShHzemEwfGIrFwYQEzIYsijKKWZt
	qu3hZbVx+xjPSFjKzkuHreo7XE3BZvva/nycL2hZ92edW6+TKar/u61dpVi5XPo80bp89V
	5XzujK/IKuha3lNfQ+HqAeE2/vY+A8A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XO1ZhQqa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+++C4FbPvLuI+LhwloavFM8OGN025XzDv0RO8kBiFY=;
	b=uihvRz8RccPFD2De5OEXwC7eNZX2Xc+t06Glwsrl7JjRndR3SJ38aF4lzxSVzaqsLu9Drt
	hyudB9nn8Vj1ZTqBxniQy4sVwmMT3/ifGlJrlZx4Xf5GP9UbnY3/3sa/2CVYMXlK79LpmT
	Eufwe8RKpKCHYDeHLyCLpABrscfXfM0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C3F26133A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1385EC2BC9E;
	Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926171;
	bh=t5zJdXrSXfUqeg8E0cFC/+8XELPbXvEetq+3G/tXFao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO1ZhQqa+OnISM9rimWnjQKOpGTos1mrv87Cyt6aA1eIHbOBOyqBAASaeNPjbjsNJ
	 AkU/2tLKsI9/IE4LgCjK29GbCm8MrkrU/09034kNQKYEutm4rd/XUwfSz1BKM+dOLz
	 DOUbfmRkPg4FTjjJIm+Sy8voSRBc5UsWiAwb/15BNmVXIn2ykWImwYF188bKlHWzfh
	 D+HK99+iRyNguw0FHTYytRx822Po1gDTzNLAOXvFTLi/GYTRMLckql4WFFuklnzo5c
	 AkXg2lLQ6qAOatAVvhY2zlR3zOlIFuNgXedJ9jM1iXx7BDuDZXEFv81ysLNiXtpHtJ
	 w9W59dhBj1WCQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 11/11] selftests/damon/sysfs.py: test failed region quota charge ratio
Date: Sat, 11 Apr 2026 09:49:04 -0700
Message-ID: <20260411164908.77189-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nqf17uifbxgnnpi1yh8bjhryadoeimdu
X-Rspamd-Queue-Id: 0C378C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775926171-856113
X-HE-Meta: U2FsdGVkX19+7yMD+s9vGaJGBRtMoO8+FAsENeC7cW3qrwf8RwffKKLjE2s3py5lwQfYdd4QI6WXkNgai7vV0hx/KNfWkCyV0vPTOAUs7Wv7F62MPNau+nte0Z0hs+qxBMNeji6hhTjgH/mrC2T7HV1Ip9XABTSCoPL8mJIshaoJkPDOevj4wLAhhB86cVoNKmvZZ8M0RF+KBiFUnqUxWWMVG/MlLsNHpa6QEvf0pF+ZmPy/FWq6IQNVVgXeFH2X7XvZifNgjBEzj118QpjxssZsJSiN0OwqLDWswejqBjlZyNw2jjMIRqkKw+bvPGdPpPxMlxir3TZMhiU73hN3dC6eHlSZW/F6ZTfcLdiPpL2mjtVlqKFe3/qWVOcP1QB56Ljz4PJ5cyluntUShiBYW5802CqDsOujwApcbRuyWeG6QNgT1ns70Oh/sVl+cbxQ1kr52TJNQR4VQggwgDw5vg9VC++2c8OnN9HiUZX/J4LJLYp0PTgE8n2AkOOTvUGs3dLDLHBcs7JUxWraO156JK48Yh6SXSH6qI/G2rvEqAN/2LxDLHSZ040x+kZE7C8Fi2R27/y8rQZClpMlSbyVhx+NaZfjhWVsOvUppSnhZW0PoZtFENNG71SEmKOuiXFHKiny+xrImqb5O5erevKfNsm90dlMKNDYqZuCzWF8tIt/yuSojdPWDhaY+NEOYOx7bi+GA7WuBUd2A6gAUvUH/hvguqGub4p08h8UOTLVj15UnATlqHGXohqgYJIyREIho9PypSJ7HOj24V9WDzzr26V9/VplQENycnrBXFCWTRKbYgFvolOvp/gH0RTN/slcakQFbdYZZeCAVL9K37FR2p46XW0bf/hCxa0qrP1bTG4KPzsElvkanFNn9AUbtJllV11dBEiL3vnvgLKFKTL/+bcU+XjWWh/ItpR93OB1+otlzpYvuyInvMuGaA426WfWu4At7ClNauubU4TVlG0
 DA+3SuiF
 hFXDH+Hv57tjgNCRjBbIt2pqdqHOzs/44ElzwxgOAxoxTZ+7HmeUx/EvCjKcO+pJaaWnA6AxGEzcHPegLEPZDETpQNqr1G997IDd6SUtyM30/vl1fbR4oad77nsDtbNSjZZ+1chVi3JwUinMknW0rtHHJ1C5VHfBlg1IsAFMAZ+vi7tMACv/Hadgbsf7Utg0zOSbtcvDrYK30QqegDoNEjyh1EmHKI+WGNtoVI3uI9y2Kk382s72/0Q2bgWQCNKfgB0187d3wkGOv01CZHtnNxK6EPqw7ubAwleCdV02dDsi8Ci8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py DAMON selftest to setup DAMOS action failed region quota
charge ratio and assert the setup is made into DAMON internal state.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 387286dc449d5..cd4d82c852113 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -73,6 +73,10 @@ def assert_quota_committed(quota, dump):
             }
     assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
                 'goal_tuner', dump)
+    assert_true(dump['fail_charge_num'] == quota.fail_charge_num,
+                'fail_charge_num', dump)
+    assert_true(dump['fail_charge_denom'] == quota.fail_charge_denom,
+                'fail_charge_denom', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -278,6 +282,8 @@ def main():
                         nid=1)],
                     goal_tuner='temporal',
                     reset_interval_ms=1500,
+                    fail_charge_num=1,
+                    fail_charge_denom=4096,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
                     weight_age_permil=1000),
-- 
2.47.3

