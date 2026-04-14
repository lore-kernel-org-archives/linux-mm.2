Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E98FF9D0CB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CAC6B0092; Tue, 14 Apr 2026 08:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014086B0093; Tue, 14 Apr 2026 08:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C2E6B0095; Tue, 14 Apr 2026 08:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6E736B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:18:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78E3616057E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:08 +0000 (UTC)
X-FDA: 84657063456.21.2CF09BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C329E1C0009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T0M98o8d;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776169086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPezp2ITcZkdDANmMAapdSgeqRrrkiq9XkdWx7o6Opw=;
	b=f78RSWfuK9ORRilHxY/JMbyh09dUddboCnCzBsOjNaadcLTwMccducXPPcLqLO4h2cSJlp
	nquujzwCfQ8/B7vVFyLlOMd6jrfcJLOFXO8SvCC+Ka7q5KndCO6OQRY2Pgsc1h7BN5rWwz
	ZNbPkJBEx3H7XSMzej2SGz2t6W0s1b4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776169086; a=rsa-sha256;
	cv=none;
	b=hG5lIOu+ItJCW9S1f7cF5nSq7k0vWzl7IoLQfypdsJ9wl9h8r1LqjWpYQ4nIhAXH83gu9B
	MZ3A+pdaEuMihh6oca5NYtKulvXx83+7jly5Ocmtrjn7lkbmGtXiHLrGYuEBDlDg+BSvRD
	A8MyIOiEY0/RTg53B9bj+rmASKS+XOk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T0M98o8d;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9E5C409D3;
	Tue, 14 Apr 2026 12:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D58C2BCB5;
	Tue, 14 Apr 2026 12:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776169085;
	bh=C8aNWw0AbQoUzlLKddK8Zjdqea5+Y0/v3eZoxdIwDQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0M98o8dweNBxTJhaWK3u8rQ7z1SfMNuA+rueB7kiH1oylkCUSsbU62eSYn7jdXss
	 YwaRpyX8FuP6VObBMD0F6PtzT90BP1PEMoGDIWM8YfcRZAUnudMZfSwElHMGArXPbO
	 PascLPYk7Q0dge1QUCe+kOYmE8+tvEEe3ohH369SHT6KxFcJeCm2sG6KQQlpydJiJt
	 uRS7L+fWk3ehBDzwWK4OaTFEp+DxiPpwlpqBHMbWIx5stKVouGnzhhk3/VXVl0Ajot
	 2F9grHKy/5Asws7FOmiplUxPrka4eW1DRWOxc4cfYcUZAX8TNTTVF+uK9MnnEBlpu7
	 jeMqz87u/FxAw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] MAINTAINERS: update KHO and LIVE UPDATE maintainers
Date: Tue, 14 Apr 2026 12:17:18 +0000
Message-ID: <20260414121752.1912847-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
In-Reply-To: <20260414121752.1912847-1-pratyush@kernel.org>
References: <20260414121752.1912847-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wmf689bmrd7161bf9nakh6m3q55z96a4
X-Rspamd-Queue-Id: C329E1C0009
X-Rspam-User: 
X-HE-Tag: 1776169086-667835
X-HE-Meta: U2FsdGVkX1+I4s1qXFeNZQNCGpujPq+a2lxEBOHWqVq/WN+HyZjRhIxPahdML+cOv+rp6K/kxORk08Xb5sxE3t32QQPoMz7rK+FLpGEbY0rVLaMJ3GKYLS+9I/79jSQe/QMs8zrCLdPGHY8pTSPgioLyTnxez1xdFxrzQsYm+VaWh2C9jFz+t6/vqLCwReFMBTGqAuj2Q6CrKTFDQN+n93RL8yVYv85sbi9K/eF4M0YJLuu5ssmwGBVCl6KK5InET8WCTMbx9mYX3+OZm3RdPWM26ycS0+PQ2BEKrQ8H/3MacrCENWffWB3WYtuHXZ4YURbNxk+2BYpLhlwefzZZgj2t7AdeSmcLV6uHRKTLX55jHqCSBoBwTQlL6zLxZjSxZPiGb0VdlLfY6uIcZHfNXF05Kq4TNaLqsF9SW8N6xR9nZQp7SBJDrLwyg1iYHp0UA7QMpo9Hz/vjN4yiBIXG4zqrc8lFaaG6p+SpQXT42pqiW670PRgxwWkYzEiPmc1ssIkYVl0XWI2typUjNZfwJF61lCoY8k6vf+0OJlLBnSdBCLCWKmu1WbbLiyd4znxT48gvky+j+YMs0h9u/c+xeGZQZbRo2K3gL9BYb4fGfg17mYpPMJ9WjjRPkncX/v22Q7cFVcGdCZij3XUmEf2iwBVWmtlTfafXzavknXKMO95MowU6x2enJ5YptY8ilKNpgjdorq8hr6y3RNDvqFLU3qB6af6I9VWqCBLocDZLjiQIdB+rBkkmxuMBroza3vGtlPDXDy/OyY9ZF8Zqdbes3qlwAPCgUZcH3ivk6csEYlJm0pRC6LthB1eri1fQM11KNsQCD7GsEzLpHwCfkIJ5CmfgaVRhmX45NgaiGB1PAuWmE81aJFvSdLgl0eVK/m+PpeVRE2AWsjCozEUP51wZk75u2UKnlbPXovY2YbAlkgf1hY2PwyFv20Dn0gzsOp46Kd6/xQXW6wtDFN1Tiad
 UtaT0ULc
 5KniJq06p+eZFbQhvWVGxaAQBK8ioFjP6dDMY8qXT/oFx8k4TmF0E1RMgJF3pzi5UWo7oEaA564bCqM8Kfq4aTu0L9KyRS6ZQwBUvUeHLSIyJR6SvOQjFsCyA2rKUK0sbSDD/o8q/jKDfNTv4ztmBBq5LkQOhmJ7rtcD+PSeRez6wgIOyavBF1JMyVcniMag5GuTdaR+GXouL+3RMHcLKp2JV3StbX4SAkRF4w1RbgqADotcuQrSsL/tbXS6LMqSbJp17lKm77A7u4EymziY7X3nztSmBVYE16coo1BnGqUI4IDgdJmHRH5lK/DHatjCgW/zolB2LiJqqfd3qYVcJ3ij9Ej6Y4XibRT0m3hJgVWTPYs+cvojrVgHFsxXnPrreo7v7vENMT+vaKVi6dWLIMC/tsEIPO0tyVvhlic/qfbXFVvJhuaZ+3i/Fgoli8M+a631lL8BTrXASvlIJXu29YCke1LNMlsirgBfDxiBe6AX9wtX9jKUP41y2wtwpE6mq6FajjMFBkyx70UffoWoEG9XhKmzE2mCHs0xW8JbBABlr5PQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

I have been helping out with reviewing and developing KHO. I would also
like to help maintain it. Change my entry from R to M for KHO and live
update. Alex has been inactive for a while, so to avoid over-crowding
the KHO entry and to keep the information up-to-date, move his entry
from M to R.

We also now have a tree for KHO and live update at liveupdate/linux.git
where we plan to start maintaining those subsystems and start queuing
the patches. List that in the entries as well.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index 9091bac3d2da..9173508b4e03 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1456,6 +1456,10 @@ N: Andy Gospodarek
 E: andy@greyhouse.net
 D: Maintenance and contributions to the network interface bonding driver.
 
+N: Alexander Graf
+E: graf@amazon.com
+D: Kexec Handover (KHO)
+
 N: Wolfgang Grandegger
 E: wg@grandegger.com
 D: Controller Area Network (device drivers)
diff --git a/MAINTAINERS b/MAINTAINERS
index 915f074c3577..97820188a600 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14109,13 +14109,14 @@ F:	include/uapi/linux/kexec.h
 F:	kernel/kexec*
 
 KEXEC HANDOVER (KHO)
-M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
-R:	Pratyush Yadav <pratyush@kernel.org>
+M:	Pratyush Yadav <pratyush@kernel.org>
+R:	Alexander Graf <graf@amazon.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
@@ -14802,9 +14803,10 @@ F:	tools/testing/selftests/livepatch/
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Mike Rapoport <rppt@kernel.org>
-R:	Pratyush Yadav <pratyush@kernel.org>
+M:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/core-api/liveupdate.rst
 F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
-- 
2.54.0.rc0.605.g598a273b03-goog


