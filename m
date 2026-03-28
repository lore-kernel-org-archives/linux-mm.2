Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F41C10F3DC9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D2B6B0095; Fri, 27 Mar 2026 22:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3801B6B0096; Fri, 27 Mar 2026 22:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26FDC6B0098; Fri, 27 Mar 2026 22:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2766B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:29:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C49BD1B9C6B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:29:38 +0000 (UTC)
X-FDA: 84593890836.30.27B93C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 42C474000A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:29:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=miGLYYay;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774664977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hI+cXh+ezn6PRe4LmpL97yY3lb+YJEI5H2OSaehEWmE=;
	b=Wh03Q4hsdL1uxid0h6J1Rkgo08mG8ADdmWzKlhnmFqTd1zZ/YQ80OBG/fOmdm62boZMHb3
	xYgmr2+9LpnqeoX1KkTVoiGsX6PeXECaz09bR1nWgeNSzE/rn7I7/R04rmdipmwNE0yx4x
	7HNlyMgA70dUp5JHohxSTpyTdYNFa2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774664977; a=rsa-sha256;
	cv=none;
	b=cji04rBq18Uf2tDita7E7KTCxnkxMvLsXONLP5/VsCH1PGJhSIaHxIKXIqWWzilmVqse8W
	LWyelQw/8rbI52no+Boxtn5xrh9YK+TleGFb+OrOczy261USD9pHBOe0u3wFrLsXMY3+A6
	waotIl1ql0uVRUt0QzhvS8rfYKtFC14=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=miGLYYay;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58843600AE;
	Sat, 28 Mar 2026 02:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4EBC19423;
	Sat, 28 Mar 2026 02:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774664976;
	bh=KIRDEFAguIVpfVlhSaHcJ5jZR8gN8as3jIvYc9PGgXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miGLYYayVCNceD2OXh6QKBXfU8CTnJl+b82BkRUhaTA/k6ODzrOx0b8TEYV0KJ0oX
	 se8k4zWiFyYxURTNC7XQOx47yhsvrGdMnxgevVZdxzO/DK+EX+2e0FVhUOTlwrsnEG
	 tzY/bId9pELVkvNagx8DzwA82BJzfEoQYuEOfa1OrirgXu5kn6xf8LOmMAodyQftry
	 hNh28or2L08B/b/KdvVHMqnIHOtyAcavnWDfKnH1XD8oVs4Pm6kmLQMOU6JTMMTeeR
	 t+pbE/OlFTnTEcMKvJgbtu0i2ZzYMpModYejXbu/hQwLdWZSlTfqzzukz61Vc8uqvZ
	 WqV67lgCxPS+Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH 0/2] mm/damon/core: validate damos_quota_goal->nid
Date: Fri, 27 Mar 2026 19:29:33 -0700
Message-ID: <20260328022933.8306-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328005412.7606-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: cnd3zjnah4sscj6co7fgmc161fq8axpo
X-Rspamd-Queue-Id: 42C474000A
X-Rspam-User: 
X-HE-Tag: 1774664977-979171
X-HE-Meta: U2FsdGVkX1+oYbJpxz3Aa+zVBrypanFrzIuwpIZREiQtqM3t9ha8NhXjvmLe7sskW1dTHm5ib3p4MBPztZmg6U3ldlBN3d9Kt1hfBC/YdFcQ/DsXDClSL9dH+oBfm86wIHcJP0mVaB+pKDlGC+7eSTOoHiYkW1zA0o/wBux9eMPyI8MA11hRAdb1TuflftNhmJLdxQqb7CZcyPktiiF4LMoh2nZUYgn8tzwUk9IK90wECaPA8vA7W3jd6oBSp5ZT+np8bqQHPUWrYjScS9fBfK7eVwRJSjYU9cgFRbNwPTT5oIfsX8FSc2ezsYyQqnxd/3NYN8uFrcZdXJV/dbSWn8R1LV+9GpCNL5GU2Mx1ynJrua/IDGa6jZ1pq9KN7ezDkqlSe33/swy+iZW1HY39iXfyq3L2XTHTp4NjUtUZs6QDz4PfioN6iSyLQ+DtJu8b7zpqTj0DhFRYBYGABDgb0U2Rbc598Y35LpRK9aS5LVT09CnhsTomDWkztjUGZ44b9weq0IDwyYY6IO2xztGpWaQOQfdR1jV2G+p9WS46KliUZ5/lox5NUYRVDyRbXYc5vMUzebiszuSL8JNMTRs50BoeuwCa9tBkZw93CazFnd+yYEMI/ABQb8oubziD0+IL3UZBVSc/MdIqEM6HzERyEsP3R31zMd0xbhN57pz+XJxFAQCpXl9O6fhJ2D60PFNS1A/YfGToJ8ET5JjM/38JT3RInldF6apjH19SqodrK/qrQ+DqcRao7R6OqtOB747BemofSlf6zU8ronPd37u7lm2oGpXuNxdlgnOkBtLAfYXslUDwVXmFDyaAUixhdpz++OIrfG/ttAEf0rzPwUCJC/1uxmnebLx6XCEtij4NadTTuP1pItoF651VTD1zQXlDmkKK26MHSqhaGVjDB1A9fEejFQTTM8G74Gr+fX9/ZJ0naWP0YlKHdY4Dot0dH0YPQKHxC+qLcCbxHJu/Boq
 tNzFZTgd
 w21hsTHSqYU14twVIfQAWrGm0/4DHyi1awDqvEW0V1vPlTXnUVQ/JNWmKgsH2Uua7cQ7a3zkItj2oyXbqrpURV9ceynEXNgRm0Yxj9IkAbzF2NMas2OXiqzY4AxwpehKh5ZqFm+8b3Z48nBOXF7cFF5dVdQpz4+US+TCu7uQ+FSqmlFQGTOdNT1OQonUZnBeO3KOh7mrMWDroWUQWUNISEzn0w3DCPrUaNiq/WPW5I7Ne4E3FmkToxfqWqabVSn1gc+1MZO7V0vRHclmF5/LCO5CcJBcPxfnTAFiapdMYcydXWwO1dyAl+ZL7jA+JUGIdGKqPth/ndAm2hSePJYFzeNa+oM06xdkqWeKS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260328005412.7606-1-sj@kernel.org

- [RFC PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
  - status: Reviewed
  - review: ISSUES MAY FOUND

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260328005412.7606-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

