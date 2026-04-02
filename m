Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009AAD6AAE6
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C475F6B008A; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20186B008C; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D836B0092; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7866B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F05D1B897C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:48 +0000 (UTC)
X-FDA: 84614071416.22.1339055
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C54C51C0016
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TnmIJMVs;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775145466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7Ut2FzxLY60GeyJbs7JjIJHFcXnMuqUcOxv5eRiwkQ=;
	b=2TZ7G2NnZV1wvdH7ZfGv9K6cHMPd8e0yqxp3H+pszaE9WaCJOZGcnUExfCJsGQU9VqohZS
	rhiOXsU5ds3IAEiLO7/3hCFh7YZ5HpikwbxWdv7zG3WH+OO69mOgWziy9F3J9aXHt0QkY+
	bXUxU0xwgWvhngd6wthAsm7TJAs+Xdc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TnmIJMVs;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775145466; a=rsa-sha256;
	cv=none;
	b=WDn65ZGIs/0YVc3y+ba2F68pnfnmUCCOy25LxSuadR26ShJky0FiFb7of2Rn0Vy5n31l0B
	vyggAj+4HggXwlmHjlyRHz4HfIa5SKwOe18ZmhMCuHaFKnvoqWu1Z4UYLahMA00cf4ry+N
	rY4JQbp7y0EtsNkI5KucSJEwV/JBnZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21FC760123;
	Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F29C2BCAF;
	Thu,  2 Apr 2026 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775145466;
	bh=NWZnwPLlZwgRijh5GHeOqBVHlZCMjzzOn/iStC0SCqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnmIJMVsupwRCAUIRtEW1A3hNDQOcVCalkG+q6c808nPcowDdO7ca/2WcJ+cqpRKO
	 HVWT0vNR0H7ScK2iQVAOKXJOuWMefJcVudADsb5Ao+kdqnE5YMsHRZAAPrmSKj9nzB
	 lmSaxkf/avHo7S/LNoTJtMqSPp/2rW9KlzMkEd1bxuWPrmZjHF31ZYZH62WwubBF3h
	 t2P34vHoounwhjZioul4dh1PXJwakQ9yGK6j+fO33UR1ZPlL8iz9trO0aIXjxHL//u
	 MCElcbNYpN63Fqdx19qV31xyn5ivQQnSw78gGkWaMPldV+IwPbeOIRxf05WGFqnwJi
	 Ypr/jPREyPA3w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cheng-Han Wu <hank20010209@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] Docs/admin-guide/mm/damon: fix 'parametrs' typo
Date: Thu,  2 Apr 2026 08:57:29 -0700
Message-ID: <20260402155733.77050-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402155733.77050-1-sj@kernel.org>
References: <20260402155733.77050-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C54C51C0016
X-Stat-Signature: 3g96ddw56i1eftfiq6nayh6nc8ire86i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775145466-157555
X-HE-Meta: U2FsdGVkX18aObm4u+1qLdTC52x0tFK+T9MSUCbfA4mqIo64kDvl3rLTWjOORkETOkx/6Q7sCW0VkmQOQejBylIcokpNF+MMzW8RxUMXgrBO7JZYvtk6naN9a7XBxFOOq12K9EwmFl4Fwy2p+YpAeDCsJHxu+H6jjzzW0fexNcZenPlF4Jh8YgHDvGhv9+sSRMqg+HVU8T6B9e2FyZ1tXdZz6IlT65GMlnZLxvHYc/Wz82nOKTDsrgsPESpnA8PDIFKtJqURQBHwpQ0cwLJI8A75gAP4hg8NC7oTd2H7OzCxfUSRXO45RZ+v1NsVW/5/rRWpcQekPTAM0TLXF8NMO25az6x39Usq/hckYmn30rf48Kp/EEntlFlBEoS+BV/7Vq/4pZ6p1ylYsx9ejkmI4mExj3oCZ4m92rmqfJ9EOuc+orvb9KQQgLUfe+xlduP1IOXYeEpBkQwiwFlmXu8ncpsIoSxgZTyrHpGCin2B0XVmYQzvxdSKBT8t8OGmi8e6jSG54fC55YnctgZ+OSxonUJI4QhG9MyhtLdMo4u/pd+Qf/KBt/F4uLeLo1NbtYvUJLnn9uQeGNg5cISlfQl6IMYe0S7Xx/aWChmVZKMjpE+8VDMp1SitxYQB42Ofx6Qe4+6TfC6LzJMcxTkg5jDZX7HFzqNXPiZl9i/M9B3hpQyEzaTMIZL+LehPXS5UsFg2uW2MiiW6vZ++ioqayFv1jxPCLE7KASD/iNTyS/hb3LbwyNvxP5OEB8ppUdfz9B+0VJTeHhiG3qF4B7psxujtdx2NdBNDDwhbiaLSf6+KtzTZG9v6zlVsMRyQWzqhQPE+dEmrUIPS41vP4ucdhX9TZk5Nn70YpxouhjbYqoeFx7V29cNXD0IAAQwM4QGBwKmlzs0EDa3hCuM8lEJbIfi3tvI8myA3DtYJKKk7pNkjbq9Xy9k97Ckwx+8ZzdK9L0KVc4TcNbWpCjYq28PXcXs
 /kXgYIW6
 CdsvaUwHi047dDBVtI76cckr6cDzAO1MbitWmFzszQxsKmA5lMiFUOVVbfDkCMQbcjXn77XSKYjsNeCDaDUdZYGj0ogAHtUY13bbzKPEtfhOtowhAAyZvaI2m44uvTr3sw3T80Xguzs6+r2StZeie+c3RI6p6jLI8VWYwbhJrubk7Gfj+u953pXUECSnnzL2CNw/T0JNOEKoUO8G4km3ZD+WWdr7W47cyFObjO7pddPuayiLSCzW7tuYRQ+QGVyHzXU6b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cheng-Han Wu <hank20010209@gmail.com>

Fix the misspelling of "parametrs" as "parameters" in
reclaim.rst and lru_sort.rst.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/20260324144851.12883-1-hank20010209@gmail.com)
- Rebase to latest mm-new.

 Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 14cc6b2db897..25e2f042a383 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 2068f1346b9c..17e938c319e3 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
-- 
2.47.3

