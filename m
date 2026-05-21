Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22247CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2546B00C8; Thu, 21 May 2026 10:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D316B00C9; Thu, 21 May 2026 10:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54ADE6B00CB; Thu, 21 May 2026 10:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 398746B00C9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFBB1A068A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:43 +0000 (UTC)
X-FDA: 84791673246.13.3813609
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3ADE5120012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTMrLp2t;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	b=ZuoWNqv71Fu4hoWadX0is1TjKTGobQFSTf+i2xndn/eBBN+4ZQvceXD1QCf48eRWGEOjKC
	0b+ekobzd6fo2CsvJEqOm/F1egbid83te8fW556UZAqxem5cQI/RWJxbrVF7m8V/cIH3ts
	XTPsfOJOUFmT5EpNThN7WaQfuLsxUYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374082; a=rsa-sha256;
	cv=none;
	b=LS582bOjDxaleAhNFojmCmUs6+SfM3CeCElxkmJANc1oGiXLWRh+PJQkVcdUSCBZ++dSvl
	Ic444DLeee47O6lAcsDJNNJvdwqRp8CIaOBJHQ0w1QKTdo88eEr1WpKVT5Y2aycYtACtfi
	l6hHxGjXtdy9KuLOVD8+SFN26Mx8NyE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTMrLp2t;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0988060212
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858B31F00A3B;
	Thu, 21 May 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374081;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTMrLp2tMCX5YrgBj1ZWopah5kwGLQ9bIUqP6GQ7R86Qf+Ls98eZL6M+oMHMdugFK
	 ZiDFQ7zdYA78rZPuMiG2O1C+WKmIzSs3iUvsIl6Jjo1ZFN4AWbATyksDCzIjaMCkJJ
	 S+/BT6SI1KcNWwkVAJPCxlTbRVtv206SKPNT8s31dmpgRJYdwpayB/d4uddaHdh61W
	 tyQhXwxCZpdmEOutdJ64kHxLVWb6s/Yav9n87oo3roOEjz8vifutgJ3iR0O3iHonqA
	 ciYnzBgiOxbcrzBaFL1s84bDKgQrKskVReHR9vhif2YNhp9qM7nSJFcMku9Ivg2ZHP
	 ourNbu2RZ+OnA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 12/14] selftests/damon/sysfs.sh: test monitoring intervals goal dir
Date: Thu, 21 May 2026 07:34:22 -0700
Message-ID: <20260521143428.83157-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ADE5120012
X-Stat-Signature: 6orfidzmo9uaurt9o3mnqnno3yisasa9
X-Rspamd-Server: rspam06
X-HE-Tag: 1779374082-738490
X-HE-Meta: U2FsdGVkX1/Y+IQvDsttkEaIhVmwHCt6/Qq0sdOWOrIowR4sYe3nZ90jWQkINDoLp6SFhXwBji6xMP74BVSOxjskfPLAKX4qrGmVNXPRowQH/+DXuqX/H4/LWQNmwBJ/HIFxfHa8hdskGjt7ZUUpp05JLluVyRmytXTZSr0NyjEYyxJaUrJOMOULBZI3gc96zXToPlB/CLuxbHhuu9k3HLuitl1Jb7on4I9L2HIjq1ZST3JKm62R+a112f17BBcLe4Rn1AhRVARmhaepf5XhZBuudjoQ30b+Oif5Rh3TSXkJgkOoHYr+ylepEJV6+O7NV++1qxDGbhmOiCc+qDzMTXLLgrLoSiqURaxlJApuOkdMyD7Xp+LQyL7c1pXNGaDbeHjGGVfS3rXVW6QjnwfUjCgvIEWXvCPKosLEF84gS4cqQrusEPsJcDZQFAXteKe+gypgwOrqvzGQu9uI6AUV1Y+c8whVovo+LQTKPCUdFHJwgksFRI1WOwxmtIH85BwpVmi0e9gN86bVN+jq3IMc5OfRw06LbwW9jybOvzWlH7XwszHbEgniIs36/XAffCmw1qdQhvPqI2xfnxVH8JnCKbiFX0Eh0TAhudwEhakbHyjgKP+pCl9jfvkaA6y5ssqmg20sIuJyXhmATfyGgrX+L//uNLIkiWzQ4CIA1K08VubJw9zp1Hi7m1s2bYT6bDX6QzkbU0sQTsEpyBMKxfd9YMENGXPHbMQ+rjBHUw7nME3KujZf9I11KCh2MOU1TK6tWaG93M6FC/FNOK4StaK4XI1t2hKVwlMiwPmfNvb+cvODJE4xLGbA1Vzv+VramjZe4KEGRUVK2yVVEZk9UmERQ0VvpzFf9rZIm0P+M71BF6lbPrRL+U81bqiaTQZ5Wrac9QXoJ15naZpA9XOtIG8tZlym1AR9jpPYotHDuNrLqWniVTKNM9wiaRnpnkhu1zzrvFpR3icWqhLfz854/4q
 Xl4q5OS4
 InXR5qTUZbeib/yd+MCPBLX8waJXnbqDDd+Cg/150oiBRGHmqr3uwl3nplAqJoKZIOcoq4La/bwTA4GWncs6yq3CCL9nQ44lZLfOXvc5D1VdUo+FfEMzkeSrisL++iITD2EPB+PJS3ISxkc+7v9A6z4y9rdqukrmqGJgm98aOuS9p4yD+uZKD2hFU3uKJtN0Yff+YTY5lPX0QwcUxPLwZBATSW6QNxM1zfsYtVI7bkxN8QoIYiJZm6p0ETp3NlpECrwtzk40KCYwA2s7II0krOCv6ij8Ef1X/KNuAgITftBAQvog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing monitoring intervals goal
directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1ac3e2ce8e448..b3418214ed358 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -282,6 +282,17 @@ test_targets()
 	ensure_dir "$targets_dir/1" "not_exist"
 }
 
+
+test_intervals_goal()
+{
+	goal_dir=$1
+	ensure_dir "$goal_dir" "exist"
+	ensure_file "$goal_dir/access_bp" "exist" "600"
+	ensure_file "$goal_dir/aggrs" "exist" "600"
+	ensure_file "$goal_dir/min_sample_us" "exist" "600"
+	ensure_file "$goal_dir/max_sample_us" "exist" "600"
+}
+
 test_intervals()
 {
 	intervals_dir=$1
@@ -289,6 +300,7 @@ test_intervals()
 	ensure_file "$intervals_dir/aggr_us" "exist" "600"
 	ensure_file "$intervals_dir/sample_us" "exist" "600"
 	ensure_file "$intervals_dir/update_us" "exist" "600"
+	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
 test_damon_filter()
-- 
2.47.3

