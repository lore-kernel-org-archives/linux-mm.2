Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFA6E9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2362A6B00A7; Sun,  5 Apr 2026 11:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0016B00A8; Sun,  5 Apr 2026 11:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCBA6B00A9; Sun,  5 Apr 2026 11:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA63B6B00A7
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DB8F1B90CF
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:43 +0000 (UTC)
X-FDA: 84624844206.02.169D350
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA668140002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2kMOVNR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QO0HMgZR6Q1HucKxNFx50+mXtq1QtftwQyXEIAQyxA=;
	b=79sZ4C82S+BSBSRdo+ivdR7M7NwxNq0219RrgYM0EGtgxkWQdApyKT4Knoet0IlW49nthk
	4B+ogiIflXLnUB3tz8jyCpR1oa48gr/2dIKKzYCziOjQw2KyiCyz+IAG8/vgiCR3f4YFUm
	RO9xdk9L9uDqLgGN6o/Knp2jZOKjbnU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401962; a=rsa-sha256;
	cv=none;
	b=u57ogvhtNMhaCn/g28lUdhn6urDlnzVm+IRsDVv3+POGeeH4xaJAe3J6ZyyhRkQJVeQa3z
	VSvbJHCvhk6Qy78oCkLJwOWCMQdkEn6wcZLzMA9siLQJihENDtpkekrpuiCRuaxFU8EjaO
	ubZsA6AFnhLpesOEZn1vdBJulZPWtuk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h2kMOVNR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 109DF44221
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93460C116C6;
	Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401960;
	bh=6J24o91UAsIJGEgFo2jYtnFEeYvJuiRUU82+7XJIPqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2kMOVNRWSW6XjBLcKnf8r1Yhmubg+RSZg8ZAJ5XrBACZASdZwQHw2VvOMI5n08Pl
	 QDu+yi2V86xvB7440s527202C9AyrCoNXba+rdi3JqH2m9KFnfYbkJcYdg7Pky2eF0
	 m3sQvq6g6cIeTrCG9j/jA3P5QKqsjHlnZgbl8dx8e+V4F+srMV/e3vWOTiVcLU79yS
	 N9ZxL7Ci9yAZGNs5tecXu2efi8n/WPMmCqkRnvkmt+XkTogY7LTrzFZq9gBLGq5rUK
	 R4rJ3ArHQaMavK8CSvNssWb6gObIrf+fAcwMb5g5+0ZDD/sN+3YO4DhGreOjizWoDU
	 KGx7iYhCbmF6w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 9/9] selftets/damon/sysfs.py: test failed region quota charge ratio
Date: Sun,  5 Apr 2026 08:12:27 -0700
Message-ID: <20260405151232.102690-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA668140002
X-Stat-Signature: ytsih8dpy5dgd5iujakb9heuiqpsb7xf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775401961-738765
X-HE-Meta: U2FsdGVkX1811fHaRVtzQjPc0BAPOaa0/j85CmW9lOzb0ophf3xf1tHoE2BgQ/Ubd2kybRvt+HwhXRs9XaM8vL39IJsNqmGLRkTZyfhpRwTpGClZPiLb6JWxfCDET1A/rQQqu2VDhoOHZxvIEpkBn6jrD0sGWkcd8h8kQzpIP+qDWToIC3IXkdbnkmnqYA0TPwR4skN9A2F+txkN/g9qr6FN4bPlyeYkqyyxSLr5iXO3yDXHJCjNehOfmbsI9Rnx6JTt1K1eFYQV7jOD078jmd2qkCCbsxgtjNzr/A5QsdRKyoCF+pqbp0mdi6h6BF9DLpFPUdjsFNamkILTl1RLWnTBMaAQpZRRy5hX9Zd6m/8znrnrP9IL/XFQzo8x1mcJSR7CYfQKxtXPE1mm/6TwLQKgeV2IwG1NY4wlLG9+4CAlpceZQPtzRHM1Ug51YahVPu7NI7MKjVWgE6odY+xPRXfM5jA5+4t43We9Cfhfod3YWpPK4rDtUV4hZs5XXnIFIyyUmVwCYA/OuRRxvHZo5j5VWBgQHTpNZ3ZnbIsn2cWj0yjbfrbhiToCxThKCNGfevPb7o6J6Q2sEIxzg67MEArfimbBoZD1zDU1DJWYVzdZPJAKOdIG7z/q5dSFroRhU7rIUuETCRJBAWt3pnROIKsIxQ78qvb9dzIhIHFSihcjrDaJ0hk4wwdBTnMOHRjoQZsSz0ndm8SmeUF7WmNa98Y2Jwn+ILUwSG9PIqzYwCW9c4j2rz9gzjFMDKZyg0ppIy4+TR96bcf2BGx/cTqyZ0okI5QlY7KwA7czJ0sF8GycIV3H5jd6BHN7zfjcsgxlZX62Q956X8gvHymRX1TZhu2URBMbzpjYqcCEOY7Y+JzEu00rv23kFFdRcUoMD/xds1TxPCeCUpL1kF7zpB6KJqFICBkdDrxSrQfWS9V5zgaph3fKch/7qrhznUakb/kngUYKo7ksv7Zcu+6QLqy
 exBQwphp
 BsstEVJkvMvRpAHjtj3tnLuXaxLSl9LJE+PxZusTkJKIvNmomDK0Pte//zbSk5IzI39LkBS7dEKEf7moENu0YAyow7lKigyfs/1gxToGX4QfmWb/PUZYAz1WBgU/5b7Ja7xf+hMrX0Cm9porubiI1wg3f9Pj3N7oLETMliudHmv3gCXQ2fYsBt2c68B9lQpR7jA0kA4rPXJqz+ilkoxTtMgjRcPd1IwMOSLZpdE0fLgKabEdpQ6hC/ZW3BMXOnrLL/cy8af778ZkXPk61cePuHNgZcsYoBDeTQD/eVfwO0PzzB7g=
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
index b8d6e0f8fd906..d8d4717128898 100755
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
@@ -277,6 +281,8 @@ def main():
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

