Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F68F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FB66B00B6; Mon, 13 Apr 2026 14:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540C16B00B7; Mon, 13 Apr 2026 14:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4576D6B00B8; Mon, 13 Apr 2026 14:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 350376B00B6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:52:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF8C18ACF1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:52:47 +0000 (UTC)
X-FDA: 84654429174.18.BBF05E7
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10586100006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:52:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AgY0CqZw;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lmdIWRECgQvWI5XNgsDoZsRZtmlBed1efnAUPIgyp8Q=;
	b=kHZfXEXGPxxrN2cAeI7+zutzaea6fLO1oinKHGR87TmXJ/qGgUrPoGe5GJ4zWGXGSKKjXd
	/D5od9KWmmXKa/CgtQhBPyI/ppQNPQFeHOx4FjFMJtgdIvL8t3N1Dc5Il21qyw9cmG7+4w
	icUiIZs/mBLlg6qnjZIEgowrVo+hAcA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AgY0CqZw;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106366; a=rsa-sha256;
	cv=none;
	b=w++aQ/H06v6Zpam9z6KmMOvV/vtbN5V4pWrNnuGhnPlrJ+XbN6r5n9eC2w5cv33S3XEpye
	M4E08CKusAw1S6ymBbYs8BCfWK9GJs8A3AeyDKhdnFUX0KbvbeP83xnWMVrOeh3rBM7ffF
	zdx9ElvIuTe/rEGS/RrtkHCFvwAQn/k=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3585ec417f6so1801018a91.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776106365; x=1776711165; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lmdIWRECgQvWI5XNgsDoZsRZtmlBed1efnAUPIgyp8Q=;
        b=AgY0CqZwKTDZNEwQsAVJ8rUV8pnsyRMvaCbfinIgbeGaCMSyb48TLXRkbzG0ppba1D
         cwdZ6ylSeqzybe+Bb4gRGW5Zt3mCGdA55OuylQP2RilpET3izReAHTKZ+YSxv5jcjCuC
         xqBUsf61egASX4kX2hSKwSSI4RJ81Tq2A2o4ExTrOJb1SvewOf8okdBy1x1Y17dkkqmw
         /ttgroPH3DlHdiubpBQqgfyWzls/wCjPy7eg1yW19XkV0WppWH8egeWvSZw2vJ3ymsXT
         X8Ld2LSDCCEyqdPjrnqhBujdSzCCFJkyrf8Gdy6dt1NsrdEJwcRn8hIFxXU7Kv1zPv+Y
         srsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106365; x=1776711165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmdIWRECgQvWI5XNgsDoZsRZtmlBed1efnAUPIgyp8Q=;
        b=eSWXQrpW1PFS5Uahh36t47MAOtZjRplz16ybwK9yCvy9STiTUwYh7uVFnl/Ck30YY3
         JSk5s0sbbPf0qmXoLEn2rNXisasJSab5emPUqvYXcTYunOb4skv9UiyiEBIMObjYgv0v
         D03+fGBTK8vBAiVEroDvV6uhSMoNQ8EZHWj35jrQZvS7CbV4nczUIMYtZaoOcYX12NA2
         b0amw0oFTLwnAzG19b0jbIUpyBrywe3YYmtEu97cCGZhANJT7hMhcBZ+TTb8GPwnvg5E
         9xI21DzoTCFTeecQ7v3rzglAkmN+9UmQAFhku+nuQYTG/0AsOscsebnsFmNG0y09NZuh
         DSIA==
X-Forwarded-Encrypted: i=1; AFNElJ9/QKlyJ4Z2Sef0my7TkmnJ0FNA2alnNclBRmTK2ekO6jhvwzLpkDid9L5CKxXFnPAkUHUHuFCFXQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8QSShV3waHrqrTPYHT+lIPvGTpAITrX9DbAuIAtUSWI5AS90a
	g/pEcqAGAc0GIJ9we77kHZzE0CeqS8enVwL0dCfDBtNzeFEaEi15Y3gUVD2suQ==
X-Gm-Gg: AeBDieu7sKWNtIygb+aSVKRvafogxxdynIPHeux/Cb99ctWRHkkyRIu6zU2ao8somyC
	wl91sdSbbbezZP0dod6gqgXPAtRJSi64ov9DtG0JZJ4qZi6wY7NSUy9jO9ATsGUnlDvFyVTEoJ8
	lXvFga//A0HS5Nna1pyjo7Ni9mCx63KFT+WM9BUkPm6zjqXsS5z90JRnEbsCecdUwDLNla0D+2a
	G+4ACHOXX2hbmLyQP9VUJq5Hb0F95w0BiZ85j+yNuQ310Aivtp7Watwcgljy8PHxHGgigd/wzFv
	tmjSd2ceXKV8Efj7fa5itl5ADs8hGpy7SnhtCyyj3x+jvfIuNhXi1SrmhZIgBefxpcwGlURScuM
	lTHt4TfpRThX57p52oqfjg8y6x/SQ7MaXmAWKQjKDHm4XMdkifDRZZZTwwwqPMPBTnsObocdYB8
	GzPkiab365aNq1IIv7V1XC25tnss1Zz1HY8qd2pB3sAEJ4ushOnro=
X-Received: by 2002:a17:90b:4e88:b0:35f:b230:5889 with SMTP id 98e67ed59e1d1-35fb2305a05mr4561961a91.6.1776106364836;
        Mon, 13 Apr 2026 11:52:44 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fc2adae0dsm1225435a91.3.2026.04.13.11.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:52:44 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 14 Apr 2026 02:52:47 +0800
Message-ID: <20260413185249.5921-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10586100006
X-Stat-Signature: zsywrg5he8m5b8bns5ma9h61m1bne1qo
X-Rspam-User: 
X-HE-Tag: 1776106365-463280
X-HE-Meta: U2FsdGVkX19XBUpobdn3mGbaBsIW5SVgGSNiZMLbsn9ULAcjyWUzyc0wZMwKhBuEWHMPvOiF6OFqv55/+5c2UaNy1Ck74sbHI/N4u5p3HjgALvncNwbhSN1V6BNSLJKAh10cUsv3D3owyxgMDp+EGDh5qeiwD1JmqAHQF442xHqN5VpEG/HZVG2nEwY5+lua7zNj8nM7fVHP8IOw/LQtlzfz3mqlZ3VngALvqQ0XB9AB8wU9Kej2Dzs9DMaS6nkQ2vCQ8wlF2fbHMiXFFShodc/ezTjW2QcU8yFCsdZbsQRGWZGiJQnRDLnlJXzroCzdjZ+sow5lvS92aq+IEwPqOga39vKNegsPCW711cEvBn4/IGGxmffidgysQMbJiUCOUbnFkhGgWgp9hBIjH3mo5I+BtldYQUSdUZjafCtMwJrpD0IFGdk1EYmt2v3JnmbJ8B3tduHUhFcDEwXUK6ziexnXb0vbLL853AU49tNWGhKSD7svgtH3VqL8aK5rnLYd3i78hNWboQPizTbRgig49CGFPFs/Rhq+OrZEhqawRC5gQo7vsZp/qMZwna0VoeCgYHj+9baCeDQULT8ddIheeoSrjbcMaAzEpS7arxsmIb4Qo7rx0tNCrt6DdhKhwrGlw/bSSU8hGFjQk9WeO27J61n4hYldvXQqq2Lqh0CbaLZ5VVEP3VzW/A1EHerpzDmKpR2E25ltioUUlGd3T8jCc03IKALy2Y2MSJpGIudKc/H45U6Rt6I50MHbem+Wwyo85NPYKlnytzdyedEqDN0paPr0SODD1O6AjTLxNqA9t33huKv365TLc6YSj6Z1QESdsvpzcfbWa7AiNIhElNS1fkZKT26dkV+tzVchn5vs8MsrcFZ6veBb44olWAprdreZPx+dEWbGWfQ979giAILS0YE1Y9zQuEVKHxAb/tsdINbFDAPBPAo3ruX4n4rBpTsSYXNJSBui70DmFfqj54s
 mU5zggah
 SMQcnh0nJLFIwhGLF1Rmx20g3ej4px4qPjGu2F1H2zOZnjxucwlsrnVJVwV9CbLnSeonj2WG6HlzBFTsh2xSAo30dF69tP39il9Ij1Kupv6B+T6MYZLLwZikUdBAiQvRPJTltLWCAsTyiiwVhv1O9jfI9oABqE5f9Stq365zL7n0s070KpSdPjpChKs+1cy3cMxYeD27bqhPZ80gXy4JtZwfuiCWbHtIQ/sH1WusR49g//vrz8izTVqZB4SY6m3NEP8A8HUGDCG5OBEGbAnfvwFn32cJZad57snkWqKB7zdE3kml7VHELL4mk81zBsTBZQDrBqIOR81G5i1oC/6yJXjbZCwB7im4JyBdlykWXgq9sZywD1Mk0136L7VwVJuo0yt75IJ17KwwVDqdJz1bcDMSLiREQDvz4zrGusfkjktj41g/HtpsCOv2Q9VkZ6n4KTnKf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
========
When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
'kdamond_pid' remains stale. This prevents user from restarting DAMON
because both writing 'Y' and 'N' to 'enabled' will fail.

"Unexpected termination" here means the kdamond exits without any user
request (e.g., not by writing 'N' to 'enabled').

User Impact
===========
Once kdamond terminates this way, it cannot be restarted via sysfs
because:

1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
   be unloaded and reloaded at runtime.
2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
   Writing 'Y' does nothing, as 'enabled' is already Y.

As a result, the only way to restore DAMON functionality is a full
system reboot.

Solution
========
damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
sets it to false upon successful completion. When 'maybe_corrupted'
remains true, kdamond will terminate eventually.

Therefore:
1. In damon_{lru_sort, reclaim}_turn(): Add fallback logic to reset
   parameters when damon_stop() fails but kdamond is not running.
2. In damon_{lru_sort, reclaim}_apply_parameters(): Reset parameters
   when damon_commit_ctx() fails, as kdamond will terminate due to
   maybe_corrupted mechanism.

Changes from RFC-v1
(https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com)
- Remove RFC tag.
- Remove 'damon_thread_status' structure and damon_update_thread_status()
  (SJ pointed out this was too much extension of core API for a problem
  that can be fixed more simply).
- Add a fallback in damon_{lru_sort, reclaim}_turn() 'N' path. If
  damon_stop() fails but kdamond is not running, forcefully reset the
  parameters.
- Reset 'enabled' and 'kdamond_pid' when damon_commit_ctx() fails in
  damon_{lru_sort, reclaim}_apply_parameters() (kdamond will terminate
  eventually in this case).

Liew Rui Yan (2):
  mm/damon/lru_sort: reset thread status parameters upon kdamond
    termination
  mm/damon/reclaim: reset thread status parameters upon kdamond
    termination

 mm/damon/lru_sort.c | 13 +++++++++++--
 mm/damon/reclaim.c  | 13 +++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.53.0


