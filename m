Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384D7D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6306B00B1; Mon,  8 Dec 2025 01:30:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EF06B00B2; Mon,  8 Dec 2025 01:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CB86B00B3; Mon,  8 Dec 2025 01:30:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6C986B00B1
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5FAF13BF55
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:47 +0000 (UTC)
X-FDA: 84195330534.17.34C7420
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3F6851C0015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UQEDMWUt;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szoHK+JYJO/9dyOjhD0WW+lr/w/lnMcLGakhDH/TeWE=;
	b=VDRAK3sQfVHAEH/ATafgrNBYPPDYj36u9aK8I44l7NfPUe4I8OVB7R5gvHpt+JtNUzgpEj
	nmVtB53Cmy3kqvGX08PjqZnTglr8r7T42XVwZbiaADrorKhkX4JfRylqlMAmqChERIRmZs
	xbN9x4JqQI0P8t1GEf/6JNej8E99Qbk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UQEDMWUt;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175446; a=rsa-sha256;
	cv=none;
	b=hPoHi6rYaERmLhXFGHiuD+fW6/eZ35fbllR8EqoG73QwgaFCv+P+f1J8ptmGORv9bV9UZn
	8/JUfs/0BpyvJPVoT7enLJUffvrD/us1cu67FOrLgNlml5kTwK+dncMdTQubvXjzXS8sK8
	WHJ2h32rZjOdJ4GnsIcq80SUeM8rwBI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40126444AD;
	Mon,  8 Dec 2025 06:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB2EC4CEF1;
	Mon,  8 Dec 2025 06:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175445;
	bh=my96BzscRoG5OJJ+4DXHi+6nxWHst+CeituNuj8uGfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQEDMWUtVie4xcVROv00P1YKbtb+Gi24FUrk16/pvmtqaujQM4CTfk82pEL27xTj/
	 uQ4+24tBDGsoDWrertUrcW8EZmtJe4fcI5VaPxtiddAQKYIdsudknTIltccKXv/152
	 pasQqgRDZHC5BySXsw2btEm9VljjOGwpVzsgnvZPt92Q4rbWFEU5UfeSh55+6Fxxi0
	 d25dNjG+x4kKnRi/Zluf6E/Li0Q9b7/k0bOrYf35FnMYwRYC1+/0y2X4LJ6SXvg9PY
	 /qNQDlDe9+rariOO1/7b/IB6MeSd38iCF7gtJrnZ+oVprVdY3uv6xqVHhcX4zhjjmz
	 z7QJwjjugrOAg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 36/37] mm/damon/sysfs: support write-type access sample filter
Date: Sun,  7 Dec 2025 22:29:40 -0800
Message-ID: <20251208062943.68824-37-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ot654syon35hockdk4qj5tfmwsjsybgy
X-Rspamd-Queue-Id: 3F6851C0015
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765175446-650529
X-HE-Meta: U2FsdGVkX1/wRieQQIhX+r8SCiw6om9o05S2GLFMwDupewF5Y1ODRQJA79mdYihdxcW/rhw0ZvK8f/pKRQ/ysTd5wfIBlNScg7Yfs0E1aipG59rKCI64KtlmfSbau3M8Z+aZvqu2rNO0UvhjzoBEsqSDt9qJo2aP9nLDf7auV8GlHhzffwv+MPHAiMbRGBUh4aVWmklkzemS8eD2lmF1N6UjBUXwvcMA7pRcoH3gFyBGQoIcHbxGNv3Fm2HKKsMWVXn3W8ArFcUd4k0JGnNsXTkbVPqyv0J4S55fcndZrq+dyNRv9Z8h5GzG/LNu2fFxqbNCxcCUSnIy4fi90/lkuymG6dJ9NYoXZAFsBChfi1yub9uoy13HXiPrmaX+cTfDePWunMbjlM2JxeSwUwTVW3Rmed+rbyGhKX47Nkt8ImuU+Vbwp3k2m3Zr6FsC5idPnonEsVQlltoy12vrL9289b1v/6YfjzSu8UKMGXoFJ2BxciFOVh5qVcWDHMIXxK0bwb6Ew8/8zWv1lGVP3CAJoZ9+GfEPnQ40jKtMFEBZ5SkSo0TPFtOiBWItoxaadmRbRBWIhBUIqeCRigp6tNYN4yOXf1WipwWknZMhKVXQl5vt1m2m3RTAC1wR4fVP48Hk+Uy8OhW3s82+rSryZ41s49C6ZBPS6GwMWzIPUtzo0+odgGhpUmilDLAz+nE5czVOpkufNYX51WrNMW/f99JCNzwGvbKNH3Ekri3a6+81pX0v5eeBRUjQEUD0bfsq4vPyrB9oViVHLBlKJA0I3XBC1+y5H6KonNbOW3di7AuvN0eJEQ7vYNWCGZNZqxNjnln7A1aAepoRBVioZD2/1SZJfm5xYPJsxA7tYvOqrq/6NksPXfZkGJoSDwvC4+50/vWBu8fAVPg5pzD+uGGg9bPgXuW11HK059pR8a/HhxHQZc1oBkjHblc9zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow users utilizing the write/read-only access sample results
filtering, by adding a new supported input for specifying the filter is
for that purpose.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b96df2d2d17e..d6f6a012a0e2 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -782,6 +782,10 @@ damon_sysfs_sample_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_THREADS,
 		.name = "threads",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_WRITE,
+		.name = "write",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

