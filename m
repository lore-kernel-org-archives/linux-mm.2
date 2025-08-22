Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E88CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC958E00B6; Fri, 22 Aug 2025 13:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399098E009D; Fri, 22 Aug 2025 13:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFB78E00B6; Fri, 22 Aug 2025 13:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1CF8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:15:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF1DEB7C09
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:15:28 +0000 (UTC)
X-FDA: 83805044736.22.2751AEA
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E4A6160013
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:15:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nI2jicb9;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kW9Ipe9RMjow7N16QCydvi41AcuXAwS1+qy8Ev8rYJk=;
	b=UMESboGM5DE2wY1vtTwtQHXUJnSylFHqVt7EZ8NrfVziGDWzLuFdIK1f1SjiyYGpU1KXK0
	gD8/gZpijqp2Y/11TopnwJfA/sCRYm6kZVItbXyZ+A025zC+CdiDMJ6GrL6S16PdEolG35
	c4RxBU37IxNT0Vpe33g9DLy81KpcIk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755882927; a=rsa-sha256;
	cv=none;
	b=q6P5Svs4Rg0bXIbJQNHOLEAuOj9vu1vLglWO7Pgc86cOb24cp2+ZNnWw730GzHHCNeqmnH
	elhhbPyQ7G5Y11Msz1c4JKFYaalpeOlQcIO+zY7/WFm+oxX39RM/URMXZn3W3/KwVaY0+S
	w6Y6a/z7e3BvcryhkCpKXexhGaqjA9w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nI2jicb9;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id A2389A58B4B;
	Fri, 22 Aug 2025 17:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE37C4CEED;
	Fri, 22 Aug 2025 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755882926;
	bh=o/lfY2JBREGfJAqALJL9Cti6mmWnKMQxMnke/v3wRUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nI2jicb9UJMf755cem19q2Juk9sQHyC2XiDW0iaZXcgled01K6Q+ibt0Lfqdw5ryQ
	 uzdncDSH6oQLWBo3oW4HI+r6Cic9mmqDh8fyoiglIvqq/w4hZSOccpz3FuYQqt7RyE
	 S7N8vzj/52nFVxFvlPPeFRQb/BMspfs3c9YRfZvhwlR/d/K50TNS+kOuflT9VBIgMx
	 I1ejWuogr1prO1zAk5UrvCm19Kp87IwRURz8uPvwfuftgMV/dlEoy4QZhf7v7/iRq1
	 7crpiJcZFdyapmljkOV6xfLpfR2KJ2L7PTFxtSmYorzMdkCPlYAISPU1HOholFbGWB
	 ZZJhvptFFXO/w==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use list_xxx() helper to improve readability
Date: Fri, 22 Aug 2025 10:15:24 -0700
Message-Id: <20250822171524.53545-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822025732.9025-1-richard.weiyang@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E4A6160013
X-Stat-Signature: kpdmiteigu1kr3aswq5dkfej4egk9bs9
X-HE-Tag: 1755882927-266292
X-HE-Meta: U2FsdGVkX1+Q+iK+0dI628RqQtdlSIJAxBAts4dSiEIp1GzitEhqPEKwedRT11Z8R12BvOSlYNKDnXtgeEwwAmtRinKLcYtzezz3CbcwtWtGuoSzQF5gYcVH219IyQ6nMMJeY0BIhvP2HIOwVHoADufo17Im479YTi2Kd6jYB6JrZ7UYxL04HaatFf6Wk2tgTV3dwnKkt/LIQ7OE6jotGUOwWCx8DZYDeH+UXMZc7u/EQw6suNmQhAOHOjoIdFZP5Vb+2AfRkRFB5rzu//3WTQh0qiNTYdu91Wa3QDDnyo3zU10Yoo2lpwNYhr+b4EeyXDOeyqhWfP1XMwVkdUnG//sHfV+c3X9Vs6SdOZzB1IaJ3aiqNuV03IKf3dSYxyA1Gf0/BrlFBlG9nmE6w3Ldx8qa3j5ZTTNmqusbnU9vCxDQ20+i5+4wAy1afLAZ7wWVJ7t85FSHPwP6xxuemPIVyDgw61RTB68sEU4GqyD1/pdItCfNr/9UjDhoDr9h/Y9Ua7QUES/DIQyq73BKEJpjzuPuyx9jbl0hCCB3Jn3rsT9OEaNYDzuAxer39/m7JiLq9juQVapQXDAOLZfrL+UpgkxpfjuhBD8i9fMrvLvNhn7/B+jLgY5z9O4ygl1IogmSwiiobXWjm/BxWveF8WeUd7NgAGc+C5Dl9ijtyzlKOr2H3QbvQXLZkaRIqNipuJ1+66S2c0sKGK7+baHRXJbjjxyQ8F40vdwJMpHYBpsBqfF8LY05fCroviU5ttCgZypJx5C9EWI4tkl7w0rfuuc0qTgEFqtxu79YWzm55N1h5WpaUV74FbCioKiqOzBV06lAiEmra+4Xc61fXHnQxaRAUoFypo9/Cnocloa4EQ53VOpFRVefIvs72LZS4Q0lZi6RXinmKHYZSTp8AmEYhPLg/tYUpjB9JUDzBSR5YZ9h9IIKlgMzYbwwtsOGs3nE3AcvCz3QxwkrLDbKX8O/ZcJ
 f8gb4XWd
 YgjAmhG0bGxMDO9i1MfBBb/zinfu0ESjYP+i0EWBxv8EUEsnhtVpNSrwjhxdFKsAlyjvCy4zLTz+Uqs13VwUJNgZDPppeYZOh88NlmWcQiNuPqco3SH+Fe7onOZFBwWPUV4Juuzk120Yoi/2rf6t/8KEazK+dnIxJSSZpqklCnjMbIrDBgf4DJzs6LGa3A04S2H0uyE24ijkSGvcy5T6reCqb7Fmsw+HbYfVcvrfdfZ7fiGBrnNHaAELAjy1VCHQjKJdzy7zovzouk1c+esQnR2OGNzvlxZlSXtglcs5mRDukDGKcwh5jS5/nxl9UVtpjdLAHbY9BWvi11/DrVLvKE2Bi4ssrBrwpvGDJdmnR6V3FbH+egUCWZoCq2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 02:57:32 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
> to get a mm_struct for collapse memory.
> 
> Use list_xxx() helper would be more obvious to the list iteration
> operation.

Nice cleanup!

> 
> No functional change.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

