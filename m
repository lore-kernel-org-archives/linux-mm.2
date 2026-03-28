Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 142BD10F3DC1
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45106B0099; Fri, 27 Mar 2026 20:54:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8FA6B009B; Fri, 27 Mar 2026 20:54:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D74A6B009D; Fri, 27 Mar 2026 20:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE606B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:54:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DEEC161472
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:54:18 +0000 (UTC)
X-FDA: 84593650596.08.97F7DF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A007C40002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:54:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HFCSSc/2";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774659256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X3RBaH/ehUVEeHy1n5aJjzK9ImFwoWhGFrKn7re9ILE=;
	b=OeUO62vNOPA0L7Sg4dd+vFyiAKnGjqwVQCzdK3DpwpVQtLnpjz+5HRobfF0oQb8AnevPg0
	47N9k0MRmOyohAaa/BVU1035e0UpZfG80xCHhFJLv5f7EejV/1Z88Yd+i6CMCe+5erCxWL
	pF+z7GYhtOwbJGuM2VGg361pxq+FTiY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HFCSSc/2";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774659256; a=rsa-sha256;
	cv=none;
	b=U3b13BayLdqAZu1gNoPa0LlgS9QdutZE3K8BVsFcWGSRZg4CxVaE1y2bqyzzLo0rRlza25
	xsURidH6lP+5NcASaIsHfzAHnpQvgALOivOXJSv8H8OI6xQQ2iijG4Fw8JepFGchOVO8Fo
	liwIMNa3yru8LXaVyNCpUVqMN/T27mI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB7924094D;
	Sat, 28 Mar 2026 00:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7F6C2BC87;
	Sat, 28 Mar 2026 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774659255;
	bh=eqhm9Aq5Rmy+djcCUmMPesUDKO1sEknpkkUB6CDAm+M=;
	h=From:To:Cc:Subject:Date:From;
	b=HFCSSc/23NanR4XsIuzvw0l1DNRe67PZcYr5rpdC+unT7lDLwnmnHVoZHVMbDXNeW
	 4ViAhTUYX8STYy6HUjLOOUq3Mhrf7LXxtec9l6SJ9Njta7pVwYeGUCrG9xIjelMJdo
	 noGWmSGemPgTi//MkGwY/95WwuGvJtx9D6pyCLjeZQQ7o4KG9VIVR4xI46yoQelvpE
	 /v0T41RB8MoDhneqA2t29DJCLDylRWjB0O4w4khxDwIoxsjHNR3catYhwDg0ULwhD2
	 4y1VvF64zfdtYJ5WbwIWsd+33A/Lz2po6My64SXupstxAZ5ZcIRChzjoMGRDqfbN47
	 DskMYTdJrKsjg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/core: validate damos_quota_goal->nid
Date: Fri, 27 Mar 2026 17:54:08 -0700
Message-ID: <20260328005412.7606-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dstp9am1n61on6qc5tpgh5hdnemeqiyy
X-Rspamd-Queue-Id: A007C40002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774659256-16994
X-HE-Meta: U2FsdGVkX184HVNr79qizXAUyDjoQd50uHtQVvh4uU1ENi7AainMvj7VEMeQgDkqWumqpSlVAOPQMujmoJPsUvWRhBXRUc57VstNfKykMCxCIKy4n7HGKDjn6QqWobatmNdZeqSmtIRz9T+4Cuz4tCQXwCdz6v4M4xwakiS0TaZg+Fx3MD/XzNsvc+hqT1n+IekI8J7u6k1y8zDcbiUyVQfHJlt1YEtmv4Der/waL7C+5EUL8rD7n3KZSr1tAWSvWfO4LbQ0OjfT8ZuO/EPBXICQL/NB3NwXJB56ho1paZm0NbMEYFs1vjiqZ+G0e5xugbIBv3tE0ZGbFjPc/eNLJDPfi53Sn/odcQwhY1+PJDhIRjAONo2mThCfsKlmOSCn+b+LSG1sfWyrv93DKWWqRrZmMWYVB7DdN4Mb7L4n99A8jz6TabK5Ac30ynz/sMwSMOi4jGky5VfXu6y14bdrSctND7IrYTwxweKFfXPasp49sm3zLbr/atxFBtYwZLk4D/AJxTAOGBgT1jkAK35mBu+n6nIWRb28iUAKgE5Qck5S5Bfw3HGvB0K3XThUiXI4MuwQhU42E0XxFXQ/bxmlFhBkxlJWK38HUZZ78qh2XI0A/ICI/zFwcMZP6rBjpgOLPSNqUcnc6CXjmSauJo2ih9ukkcqnoK4cc0TwW/pSIV4/CjLBCTZa8Hc/Fr9ySAekqX6DRRordy/k/kYvYgqEYYVOJtvPLwLmdr3thAhgYPFBCsEyC76901AsCV7jE2WkTvb/a+Du6A+PIuR5lpwIcF7qO/b0RKC8Ec6OJD0Okc3/fC1Fz2EmbT9VMG/5JOeZSHAFpQLWmH8pwnD5nk+NtS8FGiIpdYEOvy40DJq+rPgBrDCmYBd76vt3hJwbQ6viwnggqAMa8Nr5fhYIYb93+392tZuILJq6XfALlheVFTQ9AWwwWPhO9sHbAEDlejG6dJe3jLouQFhHKdxbmdL
 4t7FhZdY
 rnfttU36g91DkHw4dIpJzYMhSCuz+ATMA8r4K1gHrqiNSYFBBNBJI9lFUDjwfS3VFEHTL+R2w4XYtXdpJSW22DLW97MHLhtNAjcyEyy7obrnDOBh1YO8IvnP15jce/3M4xXdqG/ycf8CN19rrzgqGHlnSJPVVROZDvRt0Yvt5Wo/P52eaxP65aECcoet4aEUmGI2dyCD17k0APvdIGfZ35tcXpobIQdCndE/8MOIY/a5Zn4JjUxKABRgxV+pGYzPE5IXeFpcUzLWXHKXfZ2hQRVNwqPwIK5eF5RPpNYxuBrwM/kzJr7Fgr5VJL0RRQ0Wx0vdIdj40YgPTJudw9Yx6i+dEjyUrm4SohE/bxOkIKbVtVpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

node_mem[cg]_{used,free}_bp DAMOS quota goals receive the node id.  The
node id is used for si_meminfo_node() and NODE_DATA() without proper
validation.  As a result, privileged users can trigger an out of bounds
memory access using DAMON_SYSFS.  Fix the issues.

The issue was originally reported [1] with a fix by another author.  The
original author announced [2] that they will stop working including the
fix that was still in the review stage.  Hence I'm restarting this.

[1] https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org
[2] https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org

SeongJae Park (2):
  mm/damon/core: validate damos_quota_goal->nid for
    node_mem_{used,free}_bp
  mm/damon/core: validate damos_quota_goal->nid for
    node_memcg_{used,free}_bp

 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


base-commit: 7da5718476562bc8136c08216a1621aac09bcb51
-- 
2.47.3

