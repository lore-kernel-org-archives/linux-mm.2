Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E545D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B146B00A7; Tue, 16 Dec 2025 03:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03746B00A9; Tue, 16 Dec 2025 03:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD2A6B00AA; Tue, 16 Dec 2025 03:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7476B00A7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:02:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69E9C592DC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:01 +0000 (UTC)
X-FDA: 84224590842.13.35C2FCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C498E14000F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzFqQZhW;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXIrqjw1RbZh9mM5rX7YXg46J4nnw4+UUqj3L7fdYI8=;
	b=gyTdKIt2LyT56TLjy/dS2cX5BbaQt09DBHMtvdhNNxaKnKBShlV5JxmA1rwybMktCxp+3y
	BUnKtS9bwzERjJ6M1VH+deyg9QpvRzjSdUAPKA0+UkdQw4Q0DnDLkHnkMOPwxR+SX7WNv6
	8ZCJsE/HOC8RrCxblda1mIXBw13noh8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzFqQZhW;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872119; a=rsa-sha256;
	cv=none;
	b=NwytcrPQtyAs9losjzeEpcJk8mGekC5GnPohTzvI/yn6CLdHMhZ9ZrvzQxBAwVMmcdQOnK
	DPfT5hb2+8GKsahwFJVvV4QTiCWrmt0vMo3XHDWV2c9/fIe0aIVFhurNb1qRO7zdvTLdvY
	orDUb6FzaclZsRYrnkOrx119haZs1ro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C63F60188;
	Tue, 16 Dec 2025 08:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16C3C4CEF1;
	Tue, 16 Dec 2025 08:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872119;
	bh=iXEcDN8E6cxYy3isQfAsdFaACSzfCgupWIVQKmv8ny4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzFqQZhW+kHU5WrBW6RZ23p3Qb2kf/dRFUSMa86acEKSvHeojbpJLeGaMmqexz71o
	 K8kxkxMR210pM3fBllz/7N5XsSpMNgeGU/tIIwcqyK4ub4blSBVCz3+mOQtGXbHxSh
	 AK/v+B/Th0UUrm8Oe+fr6OPKNPlGXS82LoQl2dHHo8yexLPJeq29mJAdhnhwHgTxEi
	 zuHsnDhJ/MqQNaV85OdnvkAgCSYhwQhK0zu9NRJ4+UqwsdTate1Dr9j0dmzfQOZwyt
	 5llRl01Y7mp6mcGyiAXSPlLdHjsvqpRpWesdxzFF2t7mDx4rf/SqgB2cayVzluOtp6
	 eZrA8h/bAgzWg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/12] Docs/mm/damon/design: update for max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:22 -0800
Message-ID: <20251216080128.42991-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C498E14000F
X-Stat-Signature: i85bo73ywkyyz1wzkezy3dnxyp1u4krr
X-Rspam-User: 
X-HE-Tag: 1765872119-952896
X-HE-Meta: U2FsdGVkX1/K5OIHcimD2qGPE0v168Pt5P/FH87w+TpYBrJ3U3hPKWDYLylx8xmNPqgaDvG8v5GVPTtttGUVBD4S8YwCGs28CxY9+JcRsfnrJG54HFuV3nU0tlqPCvdR4g9VoGMpScy1HUCt499XyVa8FeiHJW/1CtQVyYioWi/Bwb3kUhGSPLYF4BsNO9bnMoPGYqI6kKXZhvyhNOMlj3vJgAg+9vKWZGIsZSlsCmtPXR90PtiyNhTEFc6ZWZNO6o349jpbD+dz/L3xmQNYrnD3J0QnC3xvcBuYYTEQ43FiBadx4x7rluPrrE3Ez2x+A9M66GRG8LL9V9SwXv6AylcvnpAbqfBmovq/I9mdP0+k0zuucjsHnIBCePKMNdvtcxJ7shEjvGcYL2MmalDDn8oLrNhKHqRCWIyvwHPb7wm511F4JOg5GLP228NtShI7IsC5IzE9c3eRuRwZtYtmkep2FGLsj5vhT1pf1tQsw9zkAzAoboXqO1FF7ftL63NHqYmyHjfhQNC9PGkB8Vbq6HDXffHeF3z260fI+SM0NuvEUBGUyWlcT9066N4RrC4D2tjdD02EKxQZjoMZCfgz75/kUU5W/dCClGSBoRUmt+JrP+k4NmpMQIForwFTLfJ9rvzliJWypslEShYXYHJb3AjOSWWvCA5HKeWlXf8he/w1MXr5O5xKQPzW24NDOtyeyyIC+hPTyb06AjLvrhtcxKb3HeyMCGO2IrW8oMede4DvJAsfN+4KWSU24mcTdwGG9NLehu0/oyrKWOEutXtxh61iEbjDYy5C19i6it6/cK6hIa+scW4InVRaGu8KZtTdP5JtBWxRncPIlAPxR55LhYJObYRPMt9P/BW9/yIAIKM9JOlX+QA5C5AifYriwdV6NPHew2ZnKp7t1fXgEQga/F6Yzm7FRSnr1v45UEK5nmRg0yu99VRAg7rsmosg+3yz7OAYPalu74uqaObnJ5J
 gEjzxdEo
 4fV0V5pbvcx+0RxZDYZdb3lS1XvMuWsMIsaGpgCwIuusEsv4iQrMf8D6d33Me5aUofT4OpybQH8bXAeCf2kp4doePfYFWI9PLWTxFKdsMtFHq1pOSXjBTsKs7LXCpANk82kVxX6fyS8QI0Sf2VNzCZ1+uOoBx7YyTSOr9KNmuhlMsR3+efRpOBrmTZ4q/xjvQukmBqdHwji/tQF4Ysoo5EKJ6/IuhWRpmHD5zRTtNUPH5SWgvJ/e1bZ32vTbH3LjOsxIcf9ye+fTxR4DaH23O/ph2ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added snapshot level DAMOS
deactivation feature, max_nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 5cc7b7d662be..7fd819b8bbf7 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -720,6 +720,7 @@ scheme's execution.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
 - ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
   be applied.
+- ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
 the region is eligible to apply the scheme's :ref:`action
@@ -741,6 +742,10 @@ to exclude anonymous pages and the region has only anonymous pages, or if the
 action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
+Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
+non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
+scheme is deactivated.
+
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
 documentation.
-- 
2.47.3

