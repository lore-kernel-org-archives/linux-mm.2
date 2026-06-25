Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B173BCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BD86B009E; Thu, 25 Jun 2026 01:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373026B009F; Thu, 25 Jun 2026 01:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2899D6B00A0; Thu, 25 Jun 2026 01:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F13B06B009E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6ADB21C5F80
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:23 +0000 (UTC)
X-FDA: 84917254086.03.BB5F9FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D5D75140008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXmjOlvo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364101;
	b=NlGqyVQsrekA+JpRE3zcH0eoxMQYtrr7lHcSnjHyusj4+yreRzGxkV38sDcld13UuEbnqf
	LTQ3h+m8QjLvsmI3DtwnxS8Zq2y8aU29hXraVXtdx6BeH4XOjTcx0JDjNWvkvdS+knFcxs
	NesRzTVTbHq44JhN4MKaPXf1sPI03ZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdSH2MRv6NGKB8iMyxrijXWFPfgdd88XHA0wpbHvk+g=;
	b=jJVGFRFsBTG4nMcUev+24//iGC1NInozJ0ddubW2Ehv7bsUZn5J/0nGdKBtDGC3ndE0Zcu
	wn+YPh8E+IiBqBiy6h1njTNuFgEmIja999wIu3qCOvGM4TOOTEW5rrvTT9FsAUTc6a7bxy
	WMErMO0XGJLiD+g6mMl+c74vjsJLcp4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXmjOlvo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BA11600FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EEA1F00A3F;
	Thu, 25 Jun 2026 05:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364101;
	bh=cdSH2MRv6NGKB8iMyxrijXWFPfgdd88XHA0wpbHvk+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXmjOlvoBSA+R/FxQs4eki71+5iBL+SrEZNBykwv30cCMD2KdzmCY6D13T358GAXk
	 wFftkkPcL+zHZ2eE3Pc0kB/+XdzIa/bwxB4RPy58lXSKsbVeqUK4sSX91a357wzw1S
	 QA9eqi5ZqGWwKslc1rpm2jJTtnqCCR2YGFTw9VF4xptS9S9J8468OrBH9rLXaR4PP9
	 NSSrY+rK2GnT/hYOXqY1IBromG6qcMxS+9ZU7ZoG7C4by7T1MR0CXvhbO5jm11CnFg
	 Bm44d8jZBJtH38FneAhYjVXu4f6zowXO326b7wP9Qyz0vAUjiFv/isVLApFYgcbnJ9
	 BUkc0NsbcE0zA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 07/11] selftests/damon/sysfs.sh: test all files in quota goal dir
Date: Wed, 24 Jun 2026 22:07:50 -0700
Message-ID: <20260625050756.91115-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5D75140008
X-Rspam-User: 
X-Stat-Signature: 64rpnf4ohxp7cbsd1kthi9jhim56ndid
X-HE-Tag: 1782364101-637554
X-HE-Meta: U2FsdGVkX19/E7a3AFjE4dX+mmjryhopqHwFJ1/JKXeEoD7LqkyfjPXPJSCNZqwK5DJL6T2tVhY4slKBHSJ/r5rHKzyViNidlkHN0yFs1blbASVUwgo5hkwdTrj+OQWa7e92MGKnJ8l9F4HbpSZ53FlDo4F5DhTeSpKM0UwT2YU9Qv9PaqlBGSMzeIolEf4ru0HkpRGAd5zbQ1QWo8ATZeUX3tj2g2Uco6suuX9Kw55vXsvVx/qYknyhWLF6P1HsowZKQQ88yAzgGeLXT6GfB1kxp6rI31EGBKiVBMlYpqFQMDCsjq+smBR/Fzh991uavsK7ngIjGsg7GtbVVUWXZdCdXkVIa0kBdviNUrOeKSuCPyJWmBTlVTfyQFFUecJae3OYm4l64jrJZN8teo4phs9NzYAzd4HrG2CsYdzUcjkzuV7ZiiRGom1CNcH4+E5jHUb5nrukjQC0IWz1Cqa+eRm2GELm/x2mIFsoCRYtdUNCbRgkwza14ytXqk/rMd2LHX0rBxPvpWeA8dW7KRXwi0H0Mjce9yEuILx6L7/OMG2JrHn5LKqbPar7C7OjKCVcnT6ixMu5Fuyy+6skdPK49yOXpFfCCLD7BsCR3IZYFFYmpvv3m1GLw5xscLp7WteFo5BQEfAN+W7d2/HvHicvuLnooj/FTnLZ6Vp76UMyPyt+eZ3Bbu40HOegas09lpvPAj7//A7GHBkRCRfYjEuiKshASEEboMDTxG6AqYReemjn+EhR9WfbqKtUxzcVTO+0QDztTfkiYVhQ3ah62lSVi0BlgZK0W5g0rhZg5W9alcfP0TfsWUWTftQDJjI4a8LgtC2le1zy0zBrSppdnJX+IMaIgsfxSBeCcolWmGLFHxlXxP5ChjfUBpJIL3VRE3Le+K/h6zuX0dWt8TQ1HQuPcyZMuOziHM4+E7IjSYKoaMdrWRaHIzwEaoelolSngcKjaZG/w1crd9QhWvW6/Gv
 Mr3CDUuh
 qnaiizjma/Vu2OrA62gqPjbZTDXO4wJ095BCVetN7L4Zmb5brlt+kZ0jAV19jZ6eEpdzstxZsSYmVVQCJwcbB4tnd5MbKSvry+ogod8Aaorv231rhgNgnXOFh3MOrr4OB99AMOznlcaGGcKezS3I9XxSQ6LoubcIHeTbSoPhbioWdjdKArDxYAU1btj5wYA16BkyitgyaAzqTdHNQgkZHElctrBIAH0mQznrdnrQexGaadVuhz79WEdPur2AfmjMBohdtPHOnQTbfccxx+v8eekTSIDVT3pepLLFIUjnthURBRuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface for DAMOS quota has quite extended since its
initial introduction.  The test case for that in DAMON sysfs interface
essential file operations test (sysfs.sh) has not accordingly extended,
though.  Extend the test case to test all existing files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index ffa8413b5ab3d..15fb9df928818 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -199,6 +199,20 @@ test_goal()
 	ensure_dir "$goal_dir" "exist"
 	ensure_file "$goal_dir/target_value" "exist" "600"
 	ensure_file "$goal_dir/current_value" "exist" "600"
+	ensure_file "$goal_dir/target_metric" "exist" "600"
+	local fpath="$goal_dir/target_metric"
+	ensure_write_succ "$fpath" "user_input" "valid input"
+	ensure_write_succ "$fpath" "some_mem_psi_us" "valid input"
+	ensure_write_succ "$fpath" "node_mem_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_mem_free_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_free_bp" "valid input"
+	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/nid" "exist" "600"
+	ensure_file "$goal_dir/path" "exist" "600"
 }
 
 test_goals()
-- 
2.47.3

