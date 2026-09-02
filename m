Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D77C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD8B6B009F; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C806B00A1; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633EE6B00A2; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8AD6B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B66BA8030C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:48:00 +0000 (UTC)
X-FDA: 85167741120.07.2C01F32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2657340006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ERR+va7v;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	b=EcWrUHyW9BilhSTXlQIMSI5LfFpg0yUgxeQYpuKyjmcXSjCKqlp8TeW0PQtL28t1QVmRJi
	4mbjo9IEJQRp1AkRxjAeAIg00b7NkjwYlGYlR4A17bhIdAd32VlHHbvim9+4vnAWSuilrw
	XaBq2BhIvbOWMrs1oE0sualr/6TVHfU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328079;
	b=5sh6knxagUuhrW3q/nln8Pk8ADxndKC1jZilrUzyRGbvrXStc90HToNDXLoDlamXUh8h9h
	QZ6vsWpvAINIoZoiUOWSlbQ47O9uCxcGuRipT4448TKUiNEJqYvnE2RxXLP88Z3Jj0+3QA
	pFGXB+gVocHjBbTkGUfmy1A7TrD0zJo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ERR+va7v;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71D4444790;
	Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFF01F00A3F;
	Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328078;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERR+va7v7jV6syjvn8R/yUBvyK/UxNaRaNVakcrmAmMgw9hQqXPpDw1mb5jZ5LYx8
	 TtN4CIzctFX1QXt5wHf49T7bWKsSfUJpb/1GU34Jl1i3mRYi+WhAIFpfPz071elkku
	 C0v/ygGvwhHF23venbP+e7sMEzvp6WiC9Ns3KNDFueKGan1dYypMzz/AyXZNht+RwK
	 iVEveqQLS/Zwp4ROh3IW8ytBFCiPVqIKpLKsjjNQtB+klPSWSEHgM/B7Luzy8vybWa
	 fi/m9nROPRr6+/7KpCblcDNz8mT+iKNT89DuO3321p1eSA6pb9TPBrUkl6l2/gLfvl
	 NQH+rzise8OVg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/12] selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
Date: Tue,  1 Sep 2026 22:47:43 -0700
Message-ID: <20260902054747.99370-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58gkkg7ecdxcr66g6frdcpaoh3fi6fuf
X-Rspamd-Queue-Id: 2657340006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788328079-888932
X-HE-Meta: U2FsdGVkX18S58D8OvBWruwmQ5lJsPJHfY3JwS5IIA49L8JIlqe6vvCZRtc939Acj9qnaiWAxNe4cQbbj/0nOfJ+bznrnidp+3FgtTtnMFXT8G44zmRbDjKUry2oFPbfXxtUicFlf0mWPHmtogtGUsFk/iS1a34XFYThn2dR+2IZ18IBf2HpMnat7zRRLMiBQAk0nVNYMiDe27jUq53lx73I1yPVflGO7p3A1wtn/9HqM2oPUYU6n9Mc+94J6HtX9pd5Iz/D2iTEZtWVpf7p0DVMZ9FXBLKVvK3At8y1tNEwVnQR0Fy+Ux78sMDdYHSrI7fq4RDWTGWnE/crNEG+NDS7tazsu+17g5oyEG4NgZ3MmogfCw6pkEqxmvqS6n0YrIHUu4myVRXDFp/vXc6vgWTaCcm1765Ofk08Leajd7Z+Cg9CBODAADyl3evlsHZIqWherGieJah90na8pOmwB4YtPw3bulhtdLqB25jGLzavTXg4IL65u1XHsWosXLTYrAn4ZD8O+Cu6nmokqdMY+5pPE0RYgmNmXcyIYExcytCcG3kaYvkRcwmc6ArBqHe56vRqtKFmoiO8YNcT5A8CXv/Jo0uMMt4H+B2V1Z/DD2bklpm1Nlx724264euv7N3lah9oQxBRv1KS7JhC3Q/giUdjs2FdPMgfEzGqSJRA2wNM3PPzznSzLNuI9fVmI4FyD1DeWE/1XVuaXO2p3UgXs21V7PDR9L2SYE38Z7P371MNrdPneHMRXCusRNHuWOPjrudKL2OMHxXBk+zSwooGzThkfBBI6AtolAs9QflM7QeOQ3t5TUXSxam4/ie6k/Wf4i/G39vjXwOwCQwBuLlsT00exIJDsqxQPLqsZzUSR3VsU3qO3ncYMvAEees62BcNFuMnLABaClPEIuvLJ+mfcYXZTfeofuJ2JNllUDRtyRklhQoLi62T9yIQ5ztkJWxjuAw27ttwYMBKSBXjqNq
 191eLFeG
 kRIDSCDvV8AaRh7ogov/HdTXMPXwxjLGsl187sz5UD1lVYkSXyrl+ahJlQLHdZeugAy1oiQu+BO79/qtaQvsEMFWVfOLTKG5fZTtDxHCfa2kp3fJ8L62/FUbms7oh+5POLwk7jsgbv6P7NmyJJ4Ut2J4fquWZRO3m/QJZz1BqN+nZ6g7IeG1IJxITcEQR/9i62ZSz/u2hGNkaBLRLtoN5PzeH0GDto1FG4P5kfm0DKSKH1DFVw/pvdGfaVBRzI2tZiQ4ytayb2atpFIG7FvDr+s/XLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs quota goal target_metric file now accepts 'hugepage_mem_bp'
input.  Test it is accepted in fundamental DAMON sysfs file operation
selftest.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index ddebde6edabe4..b66593c9ac471 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -210,6 +210,7 @@ test_goal()
 	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
 	ensure_write_fail "$fpath" "foo" "invalid input"
 	ensure_file "$goal_dir/nid" "exist" "600"
 	ensure_file "$goal_dir/path" "exist" "600"
-- 
2.47.3

