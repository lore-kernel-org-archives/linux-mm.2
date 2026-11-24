Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2FE606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9m0cGTx
Received: by kanga.kvack.org (Postfix)
	id 065166B07A3; Tue, 24 Nov 2026 11:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31B96B07A4; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22FC6B07A6; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8EFA6B07A3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 358A91A0BF7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:46 +0000 (UTC)
X-FDA: 85470478212.04.44B5684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA7C84002A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9m0cGTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536104;
	b=RZtobDfCEDUXwK3Oap+H5z6ihuFRZO63uBYw2DtGatBMZRMFZzOx6lp8d0evWaHQPKetAF
	VRb4lsuChqvon0Fu6Me7agPBO6I6FpObmqoqFc5vT/qsoMfNh+aUmrbNHuCx1vpcHC7BL6
	Vuvs6savsWCZ5iRIVADrCireXL2r60I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xi3zTL53/C0IsEtzXdFhLsnsp6QQLU3JdQrRy1JaaPk=;
	b=T6oRoRo7c3NzHiyKCda/0RBFs/0E4HQl4w3YqIxnCk3gm4VpvpyxeLzsVLAM050oxcMcGc
	2aAOLsI/JfiQObzYC3RNr1/dZE0HMgOMVBD/ewQI3ujPX3dyq6GU9zG8LgcEGfj88uVLE9
	NUeUM3Roa7av4Hpq/M4KpgivFliCq2s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9m0cGTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ECDE6278C;
	Tue, 24 Nov 2026 16:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3561F000EC;
	Tue, 24 Nov 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536103;
	bh=xi3zTL53/C0IsEtzXdFhLsnsp6QQLU3JdQrRy1JaaPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9m0cGTxFlXMWBvDogU+U5G7ey9rbNsM5GBHrH7X0OcvdXfuWXWLxrWpAe6Yn6vif
	 50LT0m5pcHJlKX8a/gIPTdvLMtHSQUinzAqK562ZlZ1yvCVrOy5SWIFb4zF2E7dDU0
	 RWPkTJeBlj3qsSJV4qwa6vV25/46BGezOTX65CT+nQKEcs8Bx4hWRCToPk61LhzLhw
	 Fb7G1M3UTARQRRcp3x4Ab2FeQvru2CO4v3u5UFoeL6HgEkT6Yl//dkypvfufm19eM8
	 LbwkKIrgNLQNPQU5JtOw+dltieXzPofh1dZdTMMjVGtOZerrC6m7/UhQ/lnqMAK50w
	 ypNX3IvR+xeEg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new 3/4] Docs/mm/damon/maintainer-profile: drop 'SCM Trees' section
Date: Tue, 24 Nov 2026 08:01:21 -0800
Message-ID: <20261124160124.93482-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124160124.93482-1-sj@kernel.org>
References: <20261124160124.93482-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA7C84002A
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: shi94tdebfeajo6ecgc9rq7esaz8w4yh
X-HE-Tag: 1795536103-771521
X-HE-Meta: U2FsdGVkX1/hzmNNpwD4NV8ykOXrqehYj1rE99CRLiUxjGdUaJl5WQabzDYj/c39II/tuh7YLt9zz+nLXkM+N6Z5ekTmTi/438CmAwxtPm3/MS0HhxZBZPGbVSg/I210VFBM7zPtcGG6/1mARvcGPBiElcxo0qqnVDtJrMQqAuNFH0Tp2AecApz4itVTp9gXYYu6m9aVpo8xwFPTKHlK6EzNlWV6jMhrt3P0tLcFauH5kyxWKkwlRF+oIprnxiRZsHcBi0dILPYcwU+UNL/Lkj29lBN9wjnI4N2VqP6z6stWn5UmzDqdCZN3oEtkdqkJJlrdAFVS1MgC/dJy8+yHH9w8anPKd+OUsPgGzyBcmpbpMhrBqlRx/Dh7G3xPF2REm8wvxnRf5ZScd2ASwmur4RvP8scBdLcNBITmiVQ3vAaSocxwlVktphtp/I2eWs12wDTAUyMWR3YTfGAdgj5jCFfn09wfQAJOqlq5F08jJy9GtKF4aKYheX+fheHjayW0hdFu72VeyRDBTUXzp2NK7SZRmm1Bo7yEM/JqLJmKFFzYS1Q+29xuIueOf9IHc5Onm2SGC0e09/pt+AIy5/ADZQHL1RuIu4AkjFRoWcNPMZjC5SIFvCDMM4WkGeKSifQALIMk1s5jgDpODfp1r2hRTypG4MwcqiYGF9fc2pU8R59v6iAPoi7kPiPkfq/LNq8tGA4oSGmzm6Ms8MQTqWomZHcX9mmR4/2onwyNFC8PUmN8zp3dGVcO6YiSlbB8LYxiSsSpuHEbV96p9DuX5MNRk5YlnfTFJHKdzZz7pDOOtRif1G99HrHgNfLTM/MPKm9qydtWTedtdUBssTusi+2Nqq0WvU74kEbDq7gxrC4ZgcW7s63UGw/vOw7cOFelBF5wFXcCypzzzMTYm4WfDlV9vPd78M+xwsEofVja96YlNmLacUa4i1PAKkT0oJEAnCp6uVImX2322OPfCijsW0C
 +yrhZsJa
 cWEY+XQUroMv11TBpqLW4AODCcTrUwzCDJszyfZ3oG3JTiZ31v0VOYM/Xjb6LNN53ch8iprckIDzcmOam1fk96Smyb8r8C+/7RXbd7t3Jc9fMxXwMNEPu9PJIiCIGwH6Fixq5280bH5kOVoBw9Ec5tWGOBCdmp01QRHs6FenO8H1LcBmvgRoHV9eUeYLobn9aYetdrg6mkrdhbFQHDwsk85nsVGFN99b/lNShgw7i+72TQZ//En1j2R8kZO/a+nKyqdjyUdTsMCLL35fuYNr+1ISaa1yC8hhdmZm2ePzQ1srOgutLI3ELB2xn0Wt8S2x3sc70H0gQJyf5KfWCjbucT1O29piFCibJ7XOnyvK3yLIhT5fslFnkyYviv0pJnU7H1NKpYxk2rMyu2WbbXi4+XjSll/J7UvNxFF8YB3940ya+glhWjGDdKahaszAxeViHRHp3wgvRu4JZlRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].  The
major change is that it will use damon.git [2] as its SCM tree.  'SCM
Trees' section on the maintainer profile document will be outdated.  The
updates for the new process would make the roles of the new trees clear.
Hence 'SCM Trees' section would be no more necessary.  Remove the
section.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index cc6b79c066a64..f9a8df2b11e73 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -18,26 +18,6 @@ the reason and what baseline is used.
 
 Patches should be posted to the mailing lists whenever possible.
 
-SCM Trees
----------
-
-There are multiple Linux trees for DAMON development.  Patches under
-development or testing are queued in `damon/next
-<https://git.kernel.org/sj/h/damon/next>`_ by the DAMON maintainer.
-Sufficiently reviewed patches will be queued in `mm-new
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ by the memory management subsystem
-maintainer.  As more sufficient tests are done, the patches will move to
-`mm-unstable <https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and then to
-`mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_.  And finally those
-will be pull-requested to the mainline by the memory management subsystem
-maintainer.
-
-Note again the patches for `mm-new tree
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
-subsystem maintainer.  If the patches require some patches in `damon/next tree
-<https://git.kernel.org/sj/h/damon/next>`_ which have not yet merged in mm-new,
-please make sure the requirement is clearly specified.
-
 Submit checklist addendum
 -------------------------
 
-- 
2.47.3

