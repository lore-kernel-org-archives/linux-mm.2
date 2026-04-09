Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AD1F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAF56B0098; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C1B6B0096; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED176B009D; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 212F96B0099
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 933AF1A082A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:03 +0000 (UTC)
X-FDA: 84639231726.23.AF917B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4DFEC0008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYT5oBO6;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744521; a=rsa-sha256;
	cv=none;
	b=pnFwmaNw9nzeT36bmCztpVA/Jobask2DCU2iaZK0HxbXUh0pk1IScM+7I1Zx140vRkd5cN
	AFA5XK/MxW/A0J0QBU6Q6djKEVTiAfisahimO5HQ+nv3Q8Nkt/BtcRGe4whg9T9pJoKRQa
	DpvtlGVZ60wbvKulMYfHDJpWFzInlAE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=q8SKpq4tqsu+MvKK+dtoVEE+j+fxIWpjmNHosTprRUlTHSLdl62sNDKdCnSfGlDefPF01g
	6wbxIwM9ORumF0BhIxEqGaEeFHYNdY3tFgjBD8weNI+LCKwMBoD8ua+8TAK/sqkcIrgf52
	OFZ9koPRG/tgzMbkcWDUhCatKtE5RRs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYT5oBO6;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 086144457F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1611C116C6;
	Thu,  9 Apr 2026 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744520;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYT5oBO6tiXFMuvEgp+KNnQo1cmvDK0jPdcht+aCfb+Pa4+rQHAWdVN1XOsqusoPU
	 Sc0PzqGmmzvIdU5tM/b7Jw7EBbCx8jj0SUp8ZJvuOSGEG9HFwRCB21ISKaV5I42nsx
	 j9MrDL3JV50XuRcYNRWTTo46hRr394ljnaMadDWtdbN4BAdCBqWgmJRctVV4erRP1a
	 tq3cyC1BsN7DFp3q42OS3kAA35WkUAfNzu7y6n9OBZe/K/oOmtYwPmvCG9F2guUhHK
	 Wk2i6s2F5A/RY3Qr2BMQjPqH24MUrho/vINs+aIA1W+2qCh6ngfOnrXYSanPm1ygIk
	 TWkQM6t+2ffEw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Thu,  9 Apr 2026 07:21:42 -0700
Message-ID: <20260409142148.60652-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C4DFEC0008
X-Stat-Signature: knyhwun5r75q9fe3b6ngaxku715awz6k
X-HE-Tag: 1775744521-69179
X-HE-Meta: U2FsdGVkX19fIummLxMTjUAg4mnAGtM6rrbG3UgW8eiHbcvvJNQzQHaGGP4Znc5h9u3toswHelvK1shsGx3uAp22xJ8cT0rgbT7EvAh64HBMYlpGZgQUOTT5uACRJMUWH3ZneoHM8VO2KoTPpYTdLKxIFuzj0uPHyFSlJLS9Q0YXNFANdqM8Bl7f3nPxWsaRxsvLGmQb4Y+Mg7jiY9tzCrDboA8QU8V8iXPizen7yEoOFNvCh7449FX//Ss4gDX1MRZqn9OQdv7hd4+/Yq/dyjEIO5ejHDBlrPxvkCqua8DdfKhVvVN1t40c91PPN0Jxl1qvJHiCvvWKsDPd6TS3aLLLlxBZbLFKueihjGMyTtWpM9iDKFyZywEsf1j8s2nYB2/JbOdyUih6PIjCBld0VU62MG7IXdXvbKeEIou7iYybROGBcN1Xi6RFEicAEL3Y6zfaFkw2Ga96gkPKlh44x5wtV/ec96BpdJBotOmTM4+TP1dxHR0uD6/mWq5QtuE+UL/Vv+8Oa+rkoNOPV8dn+bi26CAgJhvSlBPsKrezn1dBPANnULnz7WbCIh0BgPuVOIHiN7gjCQvK/v5BxRpqeBVF4u7WFXN7KqGWgBWHpmfK4N/gtVnJwSyi6YnHSXpglzsGVVGFovJQwvym4PExKLnXZFO0CsNjFex30APFUAYjt3esFm8cMQ6CgfpNDUn1mIu9xjHaNfeZ3N8xnIsZGSHRYY6VIDRlWzGnXqznYyYCNQqdgydNi0DtamhaBmHuBV6EH85YR+hSXm5Wx81LkX4MG9QYX7jl5EwzmPzP/SpBKO+qAdt0rheopXB0xxStyUiclyrTyZnBvm136LZa3mcmuCNOIMi57Z4OqoyrF/ihCdI3AsnT461pW2dWPAl8kEJ1tSdlgOliwEPUli7poyd+YzZe+uWPi2wT52TBxKiCZdcTq3f1UllBLNwsw3VXyc4hEqJU7qy/YJTY/Rp
 9W0uAgHu
 vMLhv0OZ2nLKIePwBDTv6bqgXS2srhWsofMeAMinzh9xyN29KzVeT+7dKga8c4uMF/2ZDQ6Q5EfqfyTyz5Lv6lj/utBSZyugWo2pWp1YH5t20ldM/0GE2kj56J0LbQ1HZudkTKkc5dtk6DZyek2bB2Ow//sI6RL+PkrKUldUTL9Wj6BqE+0KvSGfSxHuZKm+rQPW0ni2IT+JMB13XszO5HfvMpdrxg2etfzLX3CIiKgir7XOghNt6weVpdEJcIp3qJyEXVm/LKbf9uTinBNuEE0uuNbUYaYcbd9xkuTnyC6++fNLIAoG1VR3qTrM7heucsRqTXW671AndF/j2asZcKXDz3eoxMNhNugCTCaF3+lWiWXk6vFpJr63bF/M1dCnB8N5c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

