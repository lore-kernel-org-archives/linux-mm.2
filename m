Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4B9F55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97976B009B; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D976B009D; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45016B009E; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9BEC26B009B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 790691BFC8
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:11 +0000 (UTC)
X-FDA: 84520318302.15.700011C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E7AF840008
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FSOiYs1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1DpT5ALmiFo+rsHnbTk4MTUM0Yz4VbiHpiUR0U6IiU=;
	b=x29Hmj1lsjDW/UO7EluVKA4AYWa1c8fc2/1/R2UYRRlNuxc75h+pK+aoefF6VAqI2STnP/
	3b5CtgxTuyf+P45L3UNQ8yT7KPYh1QD8qczuMLCKpLVDuFC3RH3TAP2j9xwz9fFj6KFvU3
	8Q7zlUqdNXKZTEYQiLi97xAFl+P1q48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913250; a=rsa-sha256;
	cv=none;
	b=hrm6STgaaDk2b0hWEGd4h3WaYvXPCHKHQCzgkxD8/6+bJjS+i3BwmndoqWyt8jmO/29wPD
	ftOqr03scbCnnA1wpMem91NlahGr0r082k1EQYTpsNiXQhF9Rt5BlSioHP+rGQFhJMLX99
	Eu/BNKsfHzzxUiX1zmxYUcqmEVsz3TI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FSOiYs1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AEF74457B;
	Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B39C4AF10;
	Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913249;
	bh=aXU5Q1Q+3FzifQR8qcbWlvPD8SNvGBDeL5AQyGi3NNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSOiYs1b2B/+nNgtIR8T1MYGu38lIX3TFEhAazL66ct1GCypCUfspGzVQbYE/HhCM
	 210DDt3yYiTv0sasfiK0pv62AHXnD1Mig/VY7E+ZHdh1DDAwyG4iPiXtragubZU6U+
	 2WBYCtG1FzeiQlBddfdwmOEiAmQJAhmTgBzcL6a/cCxI/dweD3ed5dLrJS/qgDWE7L
	 uA5fMuqQLjpt1hbDvQroNeVfEJn+R8iMcTpe0bZKLLU5iR3UX4jlOcNukNqe2wqO0P
	 3hw6VVXPsf1WfFd6//Ig+4bJeeHuWA2K4GGZuW4VXGnHDgIpF+dRN+ZrMg7rs5ZyGy
	 6QIEZEpiZkjPg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] Docs/mm/damon/maintainer-profile: use flexible review cadence
Date: Sat,  7 Mar 2026 11:53:54 -0800
Message-ID: <20260307195356.203753-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E7AF840008
X-Stat-Signature: mcp3mq5fubjmhtb19jmadtca5rd1f665
X-Rspam-User: 
X-HE-Tag: 1772913249-908804
X-HE-Meta: U2FsdGVkX193FbT31eX3BlFxgirkopFpilixFU7HMPs1w0+cuXRQmaLHppmxTYYPrKNUW8TvDb/kwvGIEoLu65skJ3jR01b7LtRUHarPf/uc6iI3+zpxkLc3cBhvFD2/01JFa6g6HEw8FMqSzEQYAacF+3K60i/juUffNiFuHr31aUrN2qrMiPo9opPRt64G9yuTXBWvE8zc2LVshegSTdxwrCVdhdlAEiD3RiNRYc3GBdAnuxYC83m7uYvf8TGbl5Rxrs0rzE2Ofwm1VfVWjM68DUR1C2UEgAG9kDXWnfvQgt0YIHkvBULOuipg52GIm5g2dQw7qDfHj7dFglftbzwm3v0QMg3vTNxbtKz3n2VAQsSxqhFHjSWVAOYQQsHHzf1P8Ux0D1WAHe7Ps2PWYaBlm352Xuf0/WPaog0hDtgxepFQP4ZyCNStf2i6ljNl+aITzm4BAMiITSyNyWhU4V0b4Uw9c0ghyiJBBUVY+3RcAUx8n4Si9iHZbk3HyJgmEG2HHsCN3B02F81y+KMISGeq1xtwQ+ZGkG61Ny47ezZCna2nXrAfhlTE+seJfVPVZO+L5L/vK+B9W/+tCa4nVyOg4KjAyVUDj3IeoM66A8NeMIERqmnNNyLNChJ0XJ2JX/s8YUwA1CtfjYDDOb7dfmWispl1D/C8AqrzWXzJ5gVHDxpwk56ZMbkQbGcySWoCa852F/+aqPD8gmo9rXAG7cOgCVZbqZowxzQLxvh6czsgAeDIfgMxqrE+jdcQowpg94MsROSEIR7tutZMNiV+v6qcxNXQBn0rl7oZdUhSdUhmk4OqgQEa2kyoZUZdGoGgaL8iUduQxcOURaCmHtvGdZDozKZ00NrHSeX0IjfEqMXtzPPGdc06KBxLQHbYOY/Kudr7CLsgYjqpKIK4Sgi4Ufhw7lx23gw6QoQChdJ6mR85x2wtLIlQ2IJDlSXaimKIS9MpBtcnhJqJleG+mR0
 fQOwmdKM
 e+K+lbUQTFpBPrGqjfBRWVDeNrTe6lRp3xM33lb+5ap9CttLPzy40NYFAaAlNbawn5wMyqaBPraPN1RFnizGWngHkgxmP0CwRa6t0zyO5vBLLWAPzlYYuX5x2falDpyLCeeu26NzhyeO9GKP6NQmg4ITVoN7i/uzhM0VvRbzJf6c1ErYtQlhyxHAji3XtOE2rkmJdCiQmhyCO4Ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The document mentions the maitainer is working in the usual 9-5 fashion.
The maintainer nowadays prefers working in a more flexible way.  Update
the document to avoid contributors having a wrong time expectation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index 41b1d73b9bd7b..bcb9798a27a86 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -63,10 +63,10 @@ management subsystem maintainer.
 Review cadence
 --------------
 
-The DAMON maintainer does the work on the usual work hour (09:00 to 17:00,
-Mon-Fri) in PT (Pacific Time).  The response to patches will occasionally be
-slow.  Do not hesitate to send a ping if you have not heard back within a week
-of sending a patch.
+The DAMON maintainer usually work in a flexible way, except early morning in PT
+(Pacific Time).  The response to patches will occasionally be slow.  Do not
+hesitate to send a ping if you have not heard back within a week of sending a
+patch.
 
 Mailing tool
 ------------
-- 
2.47.3

