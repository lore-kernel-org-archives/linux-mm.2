Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF23C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A6D6B00A1; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932036B00A2; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFA36B00A4; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66F616B00A1
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A8E71A05C8
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:16 +0000 (UTC)
X-FDA: 84345856392.21.38BEC17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8099C40006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9Lg8HKk;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cA88XQgvLelHq2XuYxW3B3VuhDPKatQ0yuDs9QGHOrQ=;
	b=mgrlXbQtrwHcuDhYKFYm7SlO8ynjW0xjkcWzki6gEY5efdqW4XB+D+LvVreEy9zkfCAmQQ
	V+33GTQ2nYJNy/lc+VB+Swh1ym95YvkKtV8YjHp1ANnBzu1brJeXgMuu2C3RjbECbJQTbE
	dvdVIK/FZGuet/nQeDVPC1hxd1rHCVw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9Lg8HKk;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759394; a=rsa-sha256;
	cv=none;
	b=T+EpN4Ug7MWY8Nv0rPw2uBwJXONB+0pBXPw6kLYXhjxipes/oTC6tsYFs2+B049j3zQcCL
	KAbelWosxzGeUI2D7IYVqfp9m2C8L0qQF3bWwjCutRRZWIJJNCyCWXXVPDP+FuAluaTxeH
	CH702hFTQrO/cXuDnPqFLhClTXYELj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AB1544129;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304EEC19425;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759393;
	bh=CpkInp8OpjPiUKQxZORXcWjG5Pmwu5eA5tM4rzL8LFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9Lg8HKkYM4sv5a6oLEZG9b89pl/Fd++MYtPd4kiHVDHOHfpfpdzZw0FX4WliRbZm
	 TaLCVsdHX4ji3hbO85tBz2FhQ2JJWa+8aEIICc3n+lcPOLcEl+KxrD19C1j3vBgz1F
	 fpPYtfEUQ2d3fGKiXJpzMtpY2CWSmx3QsRvO4LNh+7nczjOsdZigYW2P6OtDXCy+0t
	 cJGYEztROSVCdULhwwRhUSqWMiLkhTU82CJHSZLtF0MCR7IbUMP80cXRX5taizIDZ9
	 3Q3d3Yv5qBxSMyL4Iip3d+NyqsLH4wQXijKdnt4L7YvrXZYTON1Bt1Td8fRgvYcjJi
	 R9zbvlfIFMyLg==
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
Subject: [PATCH 5/8] Docs/admin-guide/mm/damon/usage: introduce DAMON modules at the beginning
Date: Sun, 18 Jan 2026 10:02:56 -0800
Message-ID: <20260118180305.70023-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8099C40006
X-Stat-Signature: 9obx97mr7pyz33gjo18nstpjxcg913ps
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768759394-625600
X-HE-Meta: U2FsdGVkX18pqpn8A8d7JODfMzxStxbo4WZlEsE/MdzaoL8qRv5EEjcjeJQooy8+sBxc3mlGaPz09HUt6eC9S96sFCtOARcOh2jUei5dnKrnNjLjOl56XWEPk/c87BqcA9u86bFUDG2HawOaoRQmfRyjoCalsvedDpNVLXVeINCzQylJzZDUfhAIDSOSWDZK4HmgPAnJFi7eMJNKqtS5wpL6kWJbZhK+q1870VYcJ2EKD+w5iJ5GDoa1AD0QhSxF0z3HYTbgCwWcIwhPwBRVWVesSw3n6cH6bRURfz59ri2am76eeY5ABeHOVyANTq8ThPufWItUXDT/jNdCqRcQaEk3ZPW117AW5Z33fvVVnPkkpJFo4gNcfBFdnlFs89I7KelfENV+Q19skd3/089yI+d5TJqogHiYnWC3EMQY2xMRt0a5qBkmSU4XTRERRk9MhJJHN40simVIBcgDM6iSG/UjL7cbAQg+xvqNik302G6fSWS+yJcYGHwDOaKcmwSiAPg9umnkOKcHiKcbSMJ8c0+8Tp3JCxrdDZ8+Us2zkzPTjRut6iXPoc8dTbscuN43wmTk7Qq9bskD2FbTYYE+93qw35dqEIQKsDKev7oy3YGbrpRJiOz+oqcrx3WlcRzQ0jXGnWM0L1DawLjzcla7cORBkM/Kh0G5oFR6pRh8wedcrng4UpV6899mXmvYoPxQeaoPNFwciaS4WIIhj7aIcqzQ7WpBeGAvRBZTH97O535zhU9YOYm0Xnc+rc6KnCf/9C2oYuh2zwpj5KbxLsRrHoH7LBGK4ID2943FIQw98omDlLFu5Llr+J4r63Hf7ZGqqQ+OBrRrhhFkJM528xipcY70Nc8Gbqi2jtBCEo5/O18gq5ZYAHSg7jpaI8jtiaEqdiBuJt0I8H7swtDjh2FBv/4//6zM6M9KLvc9JvRaZlT1SUm1U+ajxq2DqFU0QEvkC+MOTy54XFEjONmFF9B
 BIys10g0
 D3mxYEoIjyWH4+fA/RInWAzn+ZQ/bCBiZquzRmdPnkTYOBdUCTrFY6bsyWT5fCByTWyuiH+zkaFlXS2pFBNWSoMyGQt4JToHoG+PLr24IdhHiDjOUkMJ3Z6Wt8+SgskA420NPwMuAX4cNMXGfaOyySK9FiyNHoc8suJIV+A+ap3z5xbVqRLTTI+CEHXGWNoHUmk7ZNvmi8Sr7Vp465oG1LjFQmWh8Wf4XZTGRDgoWmMrJHst+Ih8LCDy+ZDKi091WvtZJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON usage document provides a list of available DAMON interfaces with
brief introduction at the beginning of the doc.  The list is missing
DAMON modules for special purposes, while it is one of the major
suggested interfaces.  Add an item for those to the list.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 5 +++++
 Documentation/mm/damon/design.rst            | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 7da4c002cb39..bfaee977c37c 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -6,6 +6,11 @@ Detailed Usages
 
 DAMON provides below interfaces for different users.
 
+- *Special-purpose DAMON modules.*
+  :ref:`This <damon_modules_special_purpose>` is for people who are building,
+  distributing, and/or administrating the kernel with special-purpose DAMON
+  usages.  Using this, users can use DAMON's major features for the given
+  purposes in build, boot, or runtime in simple ways.
 - *DAMON user space tool.*
   `This <https://github.com/damonitor/damo>`_ is for privileged people such as
   system administrators who want a just-working human-friendly interface.
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index c10a3dea3aa8..dd64f5d7f319 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -817,6 +817,8 @@ available.  Please refer to the ABI :ref:`doc <sysfs_interface>` for details of
 the interfaces.
 
 
+.. _damon_modules_special_purpose:
+
 Special-Purpose Access-aware Kernel Modules
 -------------------------------------------
 
-- 
2.47.3

