Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA074CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BEE8E004C; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C798E005D; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAB68E0084; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C75F48E005E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 809331198B4
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:18 +0000 (UTC)
X-FDA: 84008892156.22.9C1AC5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 105F61C0013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgsO98Fv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736437; a=rsa-sha256;
	cv=none;
	b=FSt6SIXE7Tw/4Pp9YD1kJm2Ef6V5NS/bzyd+P3GcOqw+9kcwjkwVi5wFIpBpuCc7jHMaz5
	ot17JImuQ5FroGFpR5cFeEEuLtfpY1iWH6DH0kLpeitIfnh4gInpRe8BIDak/53vzn2FAI
	OWX+ZU4f9SRWyP/MV+oghQ4EHlbV8IE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgsO98Fv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKQm0cjsr4UIfw72EQtJSK5ovE6PAH653PkJPOnCl04=;
	b=IwPyo0yV954Mifm163wPQBE+PKmiFfWcn/ebVaaQMvrOCmW+oZFxAryFPLKjtrjEMPckq9
	cxaDvZZ1xxzA3KzvcZ/Tie4VrChkahJDKdgMokoGVArmxLLclxRtqr831volIkBasux+xJ
	sXdFNAsBQlOofWOZGzJNGIWgCCTHMBg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9827E645C0;
	Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B79C4CEF9;
	Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736436;
	bh=7XL7RxGNEj8c6993fvAFt0s4Fr/lZea2SH1v+aqXmgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgsO98FvaV+BXTnvfVps7yKqGihceycqqSVJVMPwFMoebj+z6AbjR6yy+miS1xeqb
	 I3CT+uF7OFfFcULkZQYdopgQmCG34P4QtAocVwNFA5plEujtnqanJX0RA62Zt7nas3
	 3YPi51UtDvyGWhxAgh5sFfsuQzqD0FWWbYa0ZQ2Rbv5q282UYaSRCZPdp/+fgqd6FA
	 F/V6llAPmDJwZ/zV0Nk5KrnuY1WAnpbAjQb2MBmqxduVO2QzSZeenpw6jVjNKeZ2o2
	 FggeUkALvzrU6lo6CIneHbaOgByciKZjGLPmvTV72LRApmmdgjOK6FNOMCuCPH1xx5
	 h9+aR6vEVOwRQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/10] Docs/ABI/damon: document DAMOS quota goal path file
Date: Fri, 17 Oct 2025 14:27:02 -0700
Message-ID: <20251017212706.183502-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 105F61C0013
X-Stat-Signature: 5hh8hwyrj9574gicnn39nywnzrmuq4hj
X-HE-Tag: 1760736436-91362
X-HE-Meta: U2FsdGVkX1+Zf5a68JA7xaPd0qMbAjh4hSX+EX2HsIZVcSGHbtR2aQZUWBqGxI5PMDwkQ3FilT1U5hbt7mj/poP3KC7+GioL38KaQvq71AYVx0WtEPRwNfLHePXIg8SbVfG7Oja4ASVd5hR3xKM24f3kNYVm+t+fGRNQD/wCjlO6z6Hae0K8bd+/8OMD354bLoTDW7TEuIyFvSKzOtd7dc83AyLZiflMST6XvrZ/O53RemClgKHcRspj/7Sga0OwootyliDan5EzI581uhQH8QYuSR2ymWCj5iaPowLn9Pc7Ze7iCyhdCurHVucgYzmIUBUu+Y1brhUObmxGK/1NVQK7/mng+EDqvMXwB/fm7XlsPk45WlbmzBOFZ/hTaOlegtZJpUEfvvgiirWPGoueVd91ZoGKqfKLFLRyEcyX8Rr0rymmIDAUOd37QKcdDDa+toi0cLwI6Ch4y4mEc5Oc30KWOsLeVbioc1U27NAHIRS5Ktcb1Sgxs3I8jMV5mc2C2pSTgoR/+IbxwcwZlQhw620eSkjOD9GlxurNKTHAJrLlf68KaDVRKG9DvK9Szpy+WLLZz60tzeOguDhdaHFfjyZtXgGRjmheJmx57+UfhUBSPPOtfueZONzOJxRjJwkXuH+FZfjZ/zuxvJqNnSZZlbClHLqu00RYnH5NR96i/FHS+FMoWt6dMXWk1MZLmXYDX+nPgeVQJiEH8buHCfFcCBpSa4+t5go49iGulPTz3N1ApTNshnlMpWY5svEtbIQqTFu8IKhnRol6buJMfngyCTo4JeYCPx1/LRkP8Y6Wp18+K90HIZ+p8Vtn+62MFYj+RDuIKnOpuXJ/PUcNGVoOuVeFUaIy1PdcRd5rH0JCGMwsfOcvkY1Mp5umGFNWXGw88l1WPwZo0U17NyBAg+g8FPHPDUd1cS3aqodNx6NdRPrwfJn7pOADwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A DAMON sysfs interface file for DAMOS quota goal's optional path
argument has been added.  Document it on the ABI doc.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index b6b71db36ca7..dce6c2cda4e8 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -303,6 +303,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the nid
 		parameter of the goal.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/path
+Date:		Oct 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the path
+		parameter of the goal.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

