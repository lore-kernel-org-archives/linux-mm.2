Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C146CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA206B0485; Tue,  2 Jun 2026 00:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263DE6B0488; Tue,  2 Jun 2026 00:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C626B0489; Tue,  2 Jun 2026 00:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1B546B0485
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:20:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D8791C20EF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:20:38 +0000 (UTC)
X-FDA: 84833671356.08.B775AD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 92F9D20002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:20:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIsWNXIT;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780374036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nq78X8IAsN7c2Wk69I/yZyMLzhG6wRb/glfd/8QjMe4=;
	b=vFrRUI0fkebXCQklApSfPf6CbMKM8IFsuVTpRtLKOfiZrccNsiK0KumkiqNkIrX5u1vF//
	0JwlaabmnsGbFdo5cxrGkYZnUnBQ1X0sayaJrBv7WHTug81UWuFv/H4HKYvZqoaEiWRzkU
	cr8XCVW1W+LqXNF1wdl8D44OVVq+jUQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIsWNXIT;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780374036;
	b=gPwKYpu8rZ8gPUL42dCnUawb7y8kjVU01c5DorvXf4GtE5hG5ZBj2WlK4zzczHEbeBz/3C
	hCTQJgfrNm4u9UendBW7QOq1T6Mh7g/ma21dU6Vtc5o6ZVW1vSY9f18xa3dc+WoiSTgIQs
	xv3Gp+tSLAmW4yCJDVfJO9Y0NV9+Iv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DB6F43B59;
	Tue,  2 Jun 2026 04:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941901F00893;
	Tue,  2 Jun 2026 04:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780374035;
	bh=nq78X8IAsN7c2Wk69I/yZyMLzhG6wRb/glfd/8QjMe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIsWNXIT0arPzB1Vjog/511JNudsPc5qce+mGYKUxfD9tKkHalM99dQFzilcyIdl6
	 WNBQR7HxXfXH2G3CjUVBfFoLuN3JAbhzPBQvXNvuFghufZy1Dt7blpE9nfTW0IWeZo
	 zXaoee+0c8gu/ghD3ByKNSWOG04HcBuWWoI3ib5eFwR2fdzYt8B3coKsIMab9e2DPW
	 amU/H9/sPNFTt1XNwL1XyqdNhcHnZpk3h/7j944IXu3FS6IoWpijoMpEJUUKvtnOxW
	 tqhw+Zc9SulL4+EleWlXefyvBLD9iSQ6ZajRUgKEERrOcMauttyzkhSH7jgrrNc0Gg
	 PAlLMc7td6uVA==
Date: Tue, 2 Jun 2026 06:20:26 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
	shuah@kernel.org, vbabka@kernel.org, jannh@google.com,
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, balbirs@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration
 pmd entry
Message-ID: <ah5aCjLl1dx546SQ@localhost.localdomain>
References: <20260529111704.1078346-1-dev.jain@arm.com>
 <a62302f8-24ea-4d21-963d-48bec766766b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a62302f8-24ea-4d21-963d-48bec766766b@kernel.org>
X-Rspamd-Queue-Id: 92F9D20002
X-Stat-Signature: s8w4dr3foy15iiigueupb6xsu5sfd8ar
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780374036-285607
X-HE-Meta: U2FsdGVkX18/bwU7xrfNuX7/nDcChh1f2O4lmuLKVzBEEOsowVCaLZawtEqJJzjMU7e4X9K74nbXzeCylrvDd96blu5ENoqQCe1XmwHEtrMJ14m0HaZU43D/N/HFek3nP6l7zaq3Gb/6MRtYe0SrMPe/nwzID4/7aBgSbU4aquRefgR6lpdx8oNuczMHXP9Bft9zjVyqJNqALseQhUN5xxUpGrsOMn4F9gVcCtHr1xowwlWKB+HUSa6Tsody1BdjyKKZrl84lqXPnIPTwX59HQyohzK+mz/qKGv53ruh1QGjPcJNeCB435YjAwad7tv+ScMeMOSzF+mlElvXlz6VJZLPdLZ4tF+0d8vqh7vgBNL+5da0XMu8DR96RagMGGiqLazTNAnU6RvYTso2TtOmAQpp6BNJJNWSZbT8RB93HrtoswfxtftnYDBBLWbEvPClJIS4LTblU8QzQwoRba3FWG/o5fHAQvY4NrSMNVWT3kUEixpjQQkwRHJ4G9Z0tvgAtmwY6lY6XlFqfDQRs9wIqs0HrlKZ7PXZtjMQ8AorHRCdBLlzmN9xuhish5luwASrRHBCb/qqY8bU+CAdbwlUZCMBirg2lF5hnm+E2+PEr7aySfIJV/06DojPDx9GWvb5JqQwry77GTARb4BBi3iEKE8ExJ9Dy068MjIYAmrIhSmi/aAMrdfUH1X+Xp+/JApbTPhjNk2ELaiL4mjqAZudhdj4lpcvcEQMygjvmbhVYragwYzespBVzGt2cSKdgHHIOFXpSRMpCYfEc0WVWPkJ6S/pUWf7yifgm3Rxhsa9bJawz1kvLiUEbpIfOdM5wrRGUAMD/VPCgIYiAgW74s75RYVUED4bL5U2gNDf4qgAPZ+6Ji4OqKdo1rQQzFs9J2nY4Ic3VwTJKN5O4Y/VFxUOF2Rp0K+9hNrUSsbGuVbR3/6qg2emH5nJ5MzJLTBarj1lgj0WaRygge7uPCQeZTa
 F5uY6aD6
 TVbDrrqyJGpMVF1a9PlQs/z/bt6CC/AEDgp+xUMeJR9oJ2OhPbLKuLpJFRKYxY7A98/i/K06DNhNweNdi5qCrTovsQM7P6VaLgRIttyZhIT5w6NFzX8soFUSVnYL7nVaEhZ8EKitz6Co+14cgYNb7r4d65qO4zM6PHznVWP7Vh3oTai4I5dAyW6etR7ntWgkwmExJSBseyTN7pXJv+bniCZOvHtzjgmb8mWiPYJmyXt4tCVNv4+6FLZKhTEILscgJU6pK8xYgmLOkBAnqvD2L91pd0PdLbAA9l/3W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 09:11:53PM +0200, David Hildenbrand (Arm) wrote:
> The whole thp_migration_supported() guard is a bit shaky, right?
> 
> I guess device-private entries currently imply thp_migration_supported(), but
> that thp_migration_supported() check is really questionable and should likely
> just go away (else if -> else).
> 
> Staring at pte_to_pagemap_entry(), likely we'd also want
> 
> if (softleaf_has_pfn(entry))
> 	page = softleaf_to_page(entry);
> 
> to prepare for PMD swap entries.

Yes, that is what I was doing for non-present PMDs when implementing the
new API [1].

[1] https://lore.kernel.org/linux-mm/20260525165528.184397-5-osalvador@suse.de/

 

-- 
Oscar Salvador
SUSE Labs

