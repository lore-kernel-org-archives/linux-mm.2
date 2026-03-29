Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC666F3D60A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 16:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284E66B0092; Sun, 29 Mar 2026 12:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235956B0095; Sun, 29 Mar 2026 12:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14AFC6B0096; Sun, 29 Mar 2026 12:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032426B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 12:30:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CB348BAB4
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 16:30:14 +0000 (UTC)
X-FDA: 84599637948.29.F1A3FC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13D74C0011
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 16:30:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WX20iqBR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774801813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vO0CKivwy5zLP8pawQJto0YiqUyW6NZtvHKfBEhxfE=;
	b=hgo/Gi2hqXiFYN6siK6FREzw+EAunQnXZuBVS1bZXD4KOv6oULdYsI0a2FhNLPH4Nktjkq
	pB7f4dgO7buXRUJvRBzEV1MLI2b0ej8UWZf30v6qZtowiRh71gYG/0KnRGukax8ZWJCKfw
	1wko/nhPbCRUBsxC1z2chs/PBeMivus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774801813; a=rsa-sha256;
	cv=none;
	b=lFfvpAWPld7RV5dPtcyIQ1sBy2wMJfhfsbJz7FQxPopHg+rmUG4YEJGFAZvkb6nquVb1KN
	tkGuFEKnEMnc7OIL8v+rHn4p7b5wJS3oH48Pvv7kQtTJ9i2b23BtFlbkpV1qBv99zXRwrT
	blBcctfSqxBdwNA2fnCHywdFR/WcQhQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WX20iqBR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A449600AC;
	Sun, 29 Mar 2026 16:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED064C116C6;
	Sun, 29 Mar 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774801812;
	bh=wTrqNZ6KAvxHuMYghGXn848rhimlN+yguVlRQ1ZjdNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX20iqBR4LEVwbeKZmMhA9DQnisxAZuZrnqZXuwPh7EThxc4TjpnBrFFYgN/3khzc
	 wz+m3Px3nm3JFY4PYXoxfMNOquBUfSTFOlhxDj6KCm2dQppGRHlv4JNzCrrAnJooLu
	 c2kC3OdPYsRercj9mHHW4mSJMobvV2/S1lI0EhIN4g+eay8Y1uF/qjegLJntFk0vuM
	 E7j62n1i+PU4sCt/A0DXo4wW4uaYEjUE5W+jMPsShPZKfL7VseM2GFQoiWAOoFuUta
	 lzqVEGnpVBx2aXx3Dy0rkrbCoxiRlFZ95FcfvVaHdQZ+x0fsxgN8BM7wKd+6YAZp1y
	 aOsjUjgmtPPKA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/2] mm/damon/core: validate damos_quota_goal->nid
Date: Sun, 29 Mar 2026 09:30:10 -0700
Message-ID: <20260329163010.58573-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153346.46881-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13D74C0011
X-Stat-Signature: stz5ozuku8khsikxconp75n6t48psnhy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774801812-213181
X-HE-Meta: U2FsdGVkX1/OxEIUymWVgShGNWzSmxL4+80qasjrCJnjEoFXTn98Hn00SjS3hHuI4RMvmakhjXzpxpwhq1IwFlv7vsOdLp5uP8qzlJlJ0a4lPLFG995fTqmq+dLER3d0DpIySSzktDC+odsmyuofjYVsOhOznirjs1Pz/2MeFJSQPLH/gJxoIhjYUNI2c4J1q5qccw4Pe7Wn6Ximrp3/BzMbHymIP+9gI5PJ1ylPpXaa+F1EcK32/4GVe9pPPJNFomcPmVbvn0LLrGzkoi5l05c8OxrDuFJkBgLK9bdNkhJ2XDvwP6U9fRP3jrqCIgU526x4IOOly7e00hpijQNrELo5tHgCGZkv0QUn6pEeYnAl/0ZimCFW1UZFFE6M/KDVh/6lO8mdQY+2RbhHywQ/IwkFq+fCzHXtVb9qq+kTPVdwICRBw/Dsd4IwklFiMjL3Ci7A0kqsQrjSYsHjvuoFpprvsLc6FUZ4h9JECXdmtEGar3oYQJDcPCuzuiJBaCa+jFywJ9fzDMahw+1hiBUgOtrtnpFK/kPob51sI5Nr9X7HwJm6ZM1fxrE53QJXD0+VYuXX/cwHVADeYsIcrxcfx0xem2uyxNhF9sOntK5kbt3q7krk8TsmIygxP/iAaIybMBk6Fg3skHkjsVRR3QAuWFz/Rc/FtR/+ImzVdzEu961dGjnkI6ny71ezhbY1ZWbrLMjXMiaIhpRXTpJvcBKUlhgqjyYzoD2RE0ZhhViB3kuJimky+esxoNUKPR1n+ugXpLzS+baIHVVQTUtYaw4n+gfF8AYgMDXe1OqGPBXoDdKrDGeUX275UwognLfM00CnSSx6ySCpfIHgK+4UmOFrZv2RfROD9Z9+7z+snOsrDxxVzaZCtaI5qk23C5rmmQEykd5SFBtrRsDdThEPhw80ft/xeREys3/4SMTjhvqINEuzmxRTfleaPVBVmb5MNARPhxpEqcai2OUpAnfXOue
 wxZLYRmz
 UnOuA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 08:33:45 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding sashiko.dev review status for this thread.
> 
> # review url: https://sashiko.dev/#/patchset/20260329043902.46163-1-sj@kernel.org
> 
> - [PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
>   - status: Reviewed
>   - review: ISSUES MAY FOUND
> - [PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
>   - status: Reviewed
>   - review: ISSUES MAY FOUND

TL; DR: sashiko shared good findings, but not directly related to this patch
series.  I will separately work on those.


Thanks,
SJ

[...]

