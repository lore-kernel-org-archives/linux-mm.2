Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F2810BA45E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D672C6B008C; Fri, 27 Mar 2026 20:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17F76B0095; Fri, 27 Mar 2026 20:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C547F6B0096; Fri, 27 Mar 2026 20:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B47526B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:42:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54C851B870A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:42:53 +0000 (UTC)
X-FDA: 84593621826.09.C54E8EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A236A40009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:42:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIQtZgA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774658571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOELZYf/c1+jZooTByqK20bqibpjrXkes+BiInHSta4=;
	b=X0YjccCK/fmYNwslWfHpX7oR8bVSb61Rbb4RhOOoVi5efrMMb/3cHCXQkap4IuRvcnQten
	KuJdjIsMivew7TbJ6sShXQfKlp0WcaPYEPzk282I4BIhBQWokW3Oz2gxDsUnljy8UsBtU1
	2IBBSgRybb/NZ3rN2yb1BGS10Wl6VW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774658571; a=rsa-sha256;
	cv=none;
	b=peA8n46IUqrJrCc8CYl7fXZogSJQM7znn0po23SWzQP8Yk7BL2U3/nP0RPBTw4PTUAH+a6
	H7rDe6y+20N8a6VT23eEWZYr86+/3FbIlDa0iGse8L0cLU4ImvgptzAzWIfSaH339SvT0K
	Xx00TQ8oxn86br0pF7nhBaoRrQvxZdM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIQtZgA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D5F2443E6;
	Sat, 28 Mar 2026 00:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596C3C19423;
	Sat, 28 Mar 2026 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774658570;
	bh=tHes9tujM299r1urFSferkNbsuKXc5jy+H3o7lTRdJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIQtZgA2OfkDInqDspKtfTq6oZwEBuFw1b2Bb3qBuqJEzI+9tRXVNkRd59vntaQvb
	 +t304fg1jVcAGb/hg5iIWKI0P13043WPWATwdg/LbXMpnEi6mQq5CAcult9oNJg9fQ
	 S1nxOHCKtQEKW62Hz6PDfUMLGVefT4kF93T7fp9e7OdCo47Dlfs3xDTmSvcwkq2B/1
	 TuwPpUrUsHItrlTe0Iw4FEibeCEqLK3Qa9ka+yv2P8IibElytBJ8UrPe8g7ZpGkQAg
	 OF/Cy5Y0Mal1pyCKx4OPAHI04Psdk1VP61gxd/V6GDQxrH9K1LY7Wtrnaos+1aPn3A
	 PU29NlSAoHOLQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/2] mm/damon/core: fix damon_call()/damos_walk() vs kdmond exit race
Date: Fri, 27 Mar 2026 17:42:48 -0700
Message-ID: <20260328004249.7135-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327233319.3528-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A236A40009
X-Stat-Signature: qcafnn8w6cufznbdowuynxn4myysw3i1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774658571-102834
X-HE-Meta: U2FsdGVkX18i+dBX413OMKJNRJgqV8bgrqXuofHfGVvKFYj0I4eyYGsn25GxMVCcnkzv8icNZcxdjk2QP8sKmgNRXzNphVgJllbzE8AdFM4uDEWDpIKSKSOpEhCEEORi9qNlvqy9AgC0z/ulZpfDI766AGal4PRJY/dFSTNPDZ/ru2BnYpQd1VEl6tETpzjyMK3DEtdXr/MyQOmgwhqkxFEgLBov3als8SGjX8zvbUpS2x0dNLQyyTvc6bUfiDUz0rjeORxDatCq7GkWCzbXneAIINZm1L2TUSq7bcX7erZhcHZYykLOCwdQqpkZWyucOy+vaRXRm2WAf27xP03QScnrgkZd0wS189zFvAdU3lyvDyAWOmbqfEPzl9Q9z8jsjmpWDZlaKJHMqvQDU54ZPNtUjt/HHXVp2H88WEm11wIgNhY5XkybvO5TqqQPOUc6OhQjs1nJSHgI/hifZY9VUPDcxrd05ukKX6RwNjJtnPk7A/5eUEHUoXJOLtZEjxX3HQKje2N8rkhDrCnVC9MPph3sutAL0EORgX2SYSd00DsazXccM/XpJnan63Ngu/rLgky02RUuwWY9Cx2DnZIpKNFFE6dyR5Q4zoeezyU78ac3yfXcHxw3yTLb1Ryb+d/OXK62FYbfQGo9WdvZmZ2AsoefbH0Af4sqw55GVUji1pIynVBD49Sh4+8bKpnFK+cwFmIhzq8l1oGrKSKAuTf1vbQ9GVmQoWrSgmJKmvgOSa/RHRqVeZXgX72bhZz2sy37Xc9LGbp5wZpGETzpEedJhuqGlEVq9+cGJcawJoNtvuvdlnT8iJ9e/zCcmVnWAt9ro86TyOhE2PK9AqxeZF2MldLtgqvJLOsTPYQ9ZvLb2OLBLKv+V4aGf4F/9rWyJz4tJaZq+czMkIhbZZFr+tNwUJ4jodG6qJJpq/D8/Nh8QynOHleV47KXhUoY2gNm/EISR0zeCYGqk8NHY4DQ3wA
 HBJMjMYB
 kR+ey5C61AVcIpwYAZDEcSjpbZwme33E8DpFFpslNthzlcF2z+wrCDlyssd0qcVeJLyQWimvo29ucviMYz4nFTCJFlHsbdWvzsKHwRTWub+aQ67S7SsPMxjU5Xrh6dVc+Zk2awSAoG1yi8ndZdcZQILXRhl7v3qsYot7l8nC7PbxgYlab68PZeu40WzLqmi6o/MoEVFOlBH0dumLbRfSnSCBUcF3UkruTPob9U6vccej8WiazFDV9XxDtKVmlnCXvL9HChTgy61rNmhMKn47ewNlruaaPnGcA4VRwQIoFS7fZCHnrTms0DzFBjThsJJ9glvTNnYl4QLcHhAwtQtg8yKCSJkKzTbl3eLdBb3e6yz3KIpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260327233319.3528-1-sj@kernel.org

- [PATCH 1/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [PATCH 2/2] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260327233319.3528-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

