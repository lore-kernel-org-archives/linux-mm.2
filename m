Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F418ECCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 11:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B016B008A; Thu, 30 Apr 2026 07:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B5E6B008C; Thu, 30 Apr 2026 07:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521A06B0092; Thu, 30 Apr 2026 07:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 430306B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:35:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD52414014E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:35:22 +0000 (UTC)
X-FDA: 84715016484.09.C7970D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38333140002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:35:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NkK+A24f;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777548921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0HEra+VbZ2JQ/ogWEgYEJJRhO0Q7NHcVSbMzsx7de90=;
	b=y/utEM/BMCg6X36ioPITRdJ7N8ptBN91D1v3V0fiIRBHxwfwQQhSeb4KgaZbS9cA+fMmaw
	xKyzOZjWIUCPKEMUzBXv+eAET+fpH9heufs2jM89vMjzAOS6WGWRD+22BkrsHnRwsJIlAm
	G9rZvFjtfCHnb4h4lWy5Rj1p9B7HtrY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NkK+A24f;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777548921; a=rsa-sha256;
	cv=none;
	b=tnJ0aZ+ZieJrJqqQQziT4jCeRzDVwOMNOLSpSsFrjym5A4Z0l+xlri5twBs0hgBxYMuI8f
	pkKO4UKxjrw2YHc0ztipDT8amwJJgSkuVEO25mRl7S24KChJ4y8ogBAuFS1UiUeFosbfkr
	dMwIsKgh/8SizCiilGI2uF9oTRUcnfI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 075744017E;
	Thu, 30 Apr 2026 11:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F0EC2BCB4;
	Thu, 30 Apr 2026 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777548919;
	bh=ac6leB4j3KoPOdfV83k7rh/ndEAhPLMDO2A+/AjhvOs=;
	h=From:To:Cc:Subject:Date:From;
	b=NkK+A24fylBLjv4sQwQq0GF/PBiBqw/xH2XlqaUJU2aZovl0O8r2r4WlTqcMPPwry
	 qcY2Jc4UcV1nseDwgt2dZTByJcRjhhzX///ctLauu4aHbxYz0zKrovM5E8rtrTgB8J
	 X6C/jNuXkFG8e44mwUFaVHQaF4jQTzTsdLe9OtHGHJgk4eogLBTkpEVnzSoTEp1MOE
	 CfF/cwt0SUIcHP31C5tkoZ4xLoR0t/XSwjyjergI7FxRptWcEtotltKUffAGuU4iRy
	 QjKtbHAd2J92BGY4JMENcgyOosKrmy+4a4iVmZ1MAcfZUK63Jq1W8C5tgdLaLJUW2T
	 4iHgY8ymu5q0Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
Date: Thu, 30 Apr 2026 14:35:10 +0300
Message-ID: <20260430113512.115938-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ahhhz8nyf1uu619o4814qs8tau63xs7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38333140002
X-Rspam-User: 
X-HE-Tag: 1777548921-347829
X-HE-Meta: U2FsdGVkX1+F+obwceshgZmtkaAPfjEv+OhjZOkeFknDY4PJaKDCKuGK1ZbZkFXVsk47UD2rV5UNPYhrybT8OUmEWBiYcBlo54Kl4VKGo5huXrz2V6nIUOBuSOuEvKPnrarFLl3yk7/mG7ELcJ9zM5jC9xl2PvVypPw2cTNQRybYbIf2X1vCxMTu2vJWF5KRUKWrW1mW4kk7n7eQS5Pc/HamtxilwxtRQDZP0OLAsWVkkKce+PsSR+XrN5zZE4WrzI1PmqAUyZtGCE//QwlO8KF/Lj4MwV5//YKFMHcZ7UkbHzatrFvbQ73yt9JahqhdcbodUbb1N5sNXzVonwy+LaoW9GhpmWyLPCZWnFqlUXKMaMDxA5NggM5/YPyt8ynkCJWFOS421XmrktP7cVc4fER/NNI7qMQ/HyErCjkrKqtCQl0PjiegSOGpXRvjKLb+u9JolsR5xoEs5fA+oU69n3GsKXYKNjgVsynBjG/n79SOlC3zq1fX1irbn1Ao1VtI3tTzX5oV92mPUxCyT5DRbrA5cVliehRTzRtnMQuVtczOhQpp3RYe2IqD22Z9JLIi+RcdpRtngXjbv8oNP7yrQK/uDuqksQMMpzcFfEggZqyz81xNyuVCbr3dXgRT7SuWHj4NCqgE0H6zrE518aWscnszWZHOhF1kLB74joJr6M6okFA2epOYAJfOb2fSCm2r7e6xtMXH7rPQGiJqyZf1YwNaiws8mrmpA2iWuE3izkM0RL/HMdr/SzUSptiiictPlUodcGPJsdsOV+ZIUWaAljMWIsjRN01w0jMaQOIs31XWfqFmA+fHljZGtmoMtsutGvmR3H0uIwfJdQW+z3KqmKlUxsUGTUxrM7JyCwg2nMk+2I+YVf7KPucsRw8SQCBk82FrAqaNJbr9V5yfc0dW7D1xGNodUdKyVg/rwKJj/IZyBseDvSwruSqMyTSlw/IrIJd9aTtJguZviMjTB7C
 8pJIODWC
 ryZ7YTYS+JO7qMiUI8z6PZ658IbT38tTgR4XfCm3WeIljf9kNDlnMY7kqazrTbr5ziDI51V3dtks93ODqSvV+qItRiLiH9uUEwt/sOvO2Sq8AAiDX0wjkaUk/xOCIQ3vyczEr5VhHHxBx1Ak9bFf4EAoO3EbwWHNlz8G0TDdYjRP679KQV3bpJT+WfVuK8k57HZTX2sfSY76lYJH36YGVgfNMu+vWtkBnVzShID54CN3SRCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
functions used only inside mm/userfaultfd.c static.

Mike Rapoport (Microsoft) (2):
  userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
  userfaultfd: make functions that are not used outside uffd static

 MAINTAINERS                   |    1 -
 fs/Makefile                   |    1 -
 fs/userfaultfd.c              | 2231 --------------------------------
 include/linux/userfaultfd_k.h |   36 -
 mm/userfaultfd.c              | 2238 ++++++++++++++++++++++++++++++++-
 5 files changed, 2226 insertions(+), 2281 deletions(-)
 delete mode 100644 fs/userfaultfd.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.53.0


