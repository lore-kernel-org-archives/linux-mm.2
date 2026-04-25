Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AED1FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 20:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3526B0088; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A24A6B008C; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AA96B008C; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562EA6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:33:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC1CB403F8
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:33:20 +0000 (UTC)
X-FDA: 84698228160.08.B11FD3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 63AE5180007
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:33:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISMfSf8B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777149199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FoPuBGAdwvckVLfGajT68F+Jrca9YJWlBH3q962J9fg=;
	b=CO4miqAedVdnP8+BE06tvwSwOuz80Aby7af5W1RNEOW1QYDMBeaC/kE2DFsy6m38OGNs48
	CBdwoCFk5Dyzx/ii4nWDw/R1TG9l1nZrt4xLQ02jc2ws/CstQaO7jNqW3pbks49CIJA67u
	VWAdw+XclOBxBqoklZstvj0whHHSbD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777149199; a=rsa-sha256;
	cv=none;
	b=TR5KqXbZ7YJHf777T/4OvGHJ7ugC28zI9qD7cWh8F6xmC/OrFNUNgnLM9lHeSKi16myS7c
	/2c1lQQ7rhagGZ9V6tk8qgjXpblW57gs24djLaovYZhhxPsgj9qdhH7bhFaMABrU4wB6DN
	vP9ql25FX/OhuUbwi58AQ0AsNLFMs18=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISMfSf8B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC09C60052;
	Sat, 25 Apr 2026 20:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE07CC2BCB0;
	Sat, 25 Apr 2026 20:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777149198;
	bh=CjM5lHlUhKQqvVPvH7UjU4XdbEsk9yGpjrvSpB7psBw=;
	h=From:To:Cc:Subject:Date:From;
	b=ISMfSf8BKWaQOyhRKMyF1fdfzSjS6trY71nemW+erw60DWG+tyXf1QJGLa36u79WG
	 XhFSPMfUCdO7cTgp+8EAcJH9gYB1iVv19yJARhMo9rNZ/aKsVOEaUW8cFYn94qvVlA
	 Bdj/N2gio+kSw4fT4UrP8rsExEgqHZkSX2AfLDyouuop8mS+YE9Zo8LLApj5nj7EZx
	 5RK3jsK2xCcIwYdXmUPvDe1WrmZRYlt40hhifvJFVvHb5MaJfkJjUV6+G0Q5n8DHJh
	 QAzhTrz8+YOmLNth0V21SWMysRzYa/Ugi171v9dqdQY+oZddFr6jRJGJVaIgFDeE68
	 x9oc89H1ZOQuQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH v2 0/2] mm/damon/stat: add kdamond_pid parameter
Date: Sat, 25 Apr 2026 13:33:05 -0700
Message-ID: <20260425203309.108879-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 63AE5180007
X-Stat-Signature: uagoq4ij9kjsyapp8dcg5ewns4zh4s87
X-Rspam-User: 
X-HE-Tag: 1777149199-694252
X-HE-Meta: U2FsdGVkX186VKJXa5zop8xekGk62VfL4BJEQvawdyKHo8QxwGd1AXC8tIBET/ge3bYGA6/dP7oM4Oj6UhasQj6gSpnUycbhypMUPNZxNPbbRGvXpWMSL8mtCq+ThSRvZ2cDWLvfeG3NhhhsjKRXbz8GEiGRCQmoVg3riJgwzi5P78kZPF+aTdoyOTjWnJPjyhN3/+IulvSvymHcDMSuzS+4Ks4lM0ucVfuV2gc9FCy4v9oEfM7dje1RaEBIKocfdoE0lOJ9tbIUVvG+mV0dHQhosXyZX6EsO6jl7BrTqsofWUvRABGnj/H4hjefr5R646PVnFotJuz9X5sLLCBKeX2Tajxq03gjeTtd5etSRVOrJhkQ4scFLHCAWLjxw3Z80pqTeHvfuTWyNaWzV8fb02jU7V3imeSoYVZSeVzFkMRf1IdMPakQxpIai22wELB1YjrtzksvVhmA0DQCrd26IC5b3oPuPO2KscI2Nm1ov0rPzp4pBF2hqBC+d7lrtdM/WRid1R9L6g4zNv62H6UThSmRNNNu9l/7+9iym8mjCFlWoWj1+CkhW3QU4QG06fEKY7DI2eFDpk1ODnxyxKuHzxxHU3nwUDNjSAsZH4sHsApJ8pOc19So9HxvBeeBQDqYRz5Fk84JJA6VvBf6+XEjWkRci+OnbZatgYBLmBHZ7qnIaGiAK2VYRIl1dAdq1g254XvsY4DCgl9g27SuVbDtzro4ktmf+LQWbyCjYrOLqb/p+ivf8Y4mjRnK5JrHdGlsWE8j5K2UMIduipzPb4mZnU7PpOoqlIxNbCXoSzziJ7H9U5rTV9Tb63f/NflJbUxxDGViDkLxG1plVCVyLVzxfYomhalGsiMnYoZD8pawfD5XPuBVei9Czx3v19Gns6PcebUVWixIIP1fclrH6evmSixkRBUuxEi1Mig6LmM54nyBIWgG2pGxnrszLMJCSErIpO855M/ieV5UluGO6Jj
 4U8OP+iG
 RJVXpgGkyo2GFPLeNM97ryIVvyllCPTtLZV//sMy+wZOIsSkcJdaBNcusjPggrS7ri2wdcBoCNCrl0GE8RcxLJaRXEmxNNkTe+VSVAerMMF0iAcpEyrXpM3jjV0ILgQio7hvauphRC0gKrDKswrmCaOB37Ro70mQ67eZub4qyb0LM9maMNRRRjdopDgMAOUXe2YPotBUsTjhFpzvxkCfcmNsoKkgy8178+dCORRPLvfCEwslc0B15Ghx2z+WRZJiSDd3rFIeUof8J/cu9sbtzxZCh6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT doesn't provide the pid of its kdamond, unlike DAMON_RECLAIM
and DAMON_LRU_SORT.  This makes user-space management of DAMON_STAT
unnecessarily complicated.  Provide the information via a new parameter,
namely kdamond_pid, and document it.

Changes from RFC v1.2
- rfc v1.2: https://lore.kernel.org/20260416002149.87090-1-sj@kernel.org
- Detect and use fresh kdamond pid.
Changes from RFC v1.1
- rfc v1.1: https://lore.kernel.org/20260414235912.98174-1-sj@kernel.org
- Close the parentheses of error handling block.
Changes from RFC
- rfc: https://lore.kernel.org/20260414053742.90296-1-sj@kernel.org
- Fix damon_kdamond_pid() failure handling.

SeongJae Park (2):
  mm/damon/stat: add a parameter for reading kdamond pid
  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

 Documentation/admin-guide/mm/damon/stat.rst |  7 ++++
 mm/damon/stat.c                             | 38 +++++++++++++++++++++
 2 files changed, 45 insertions(+)


base-commit: 4eb752fe1ea250a5339f1e70398c5fa3a18afb87
-- 
2.47.3

