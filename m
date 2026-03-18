Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32E2FCD0DA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F7F6B013A; Wed, 18 Mar 2026 04:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFE16B013B; Wed, 18 Mar 2026 04:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106706B013C; Wed, 18 Mar 2026 04:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00BAC6B013A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:54:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBE88C222C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:54:34 +0000 (UTC)
X-FDA: 84558572868.23.690C63A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5118F40013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:54:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ixm5qREE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773824073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsfCubdXNrYEj4rnIeuBjTAwLlMZQkaBAOba0MklbMw=;
	b=sSnUfCRW2XyWnx0hb9Oxv5ZnpzsMmyR+KtbDO83y/BjGZXqvS1ymR3G3condv+U7W6M6YX
	qIkzMDfB4PAvaXh6JZgsHprcHTLHidUIr6JRsM4ffnPKnYwOouu5TJ11f/3JZXDJHIsi9Z
	FVOZp1F17TXVXWeu4j1YkhfLxxO5FY0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ixm5qREE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773824073; a=rsa-sha256;
	cv=none;
	b=kLLa4myIhT+Nx6UYppRogz39pydpmWZkZ8riHseNAXRuD0k+WMf+JN6Q1uGHmmd7cXtW3z
	So5s9yfFnHIavFBtLQpddo/PyFpiKtnbykIzV0379AOv4ck9UI/Y1TtSMIMNx/MKAtJgLY
	wKavvUTUJC/M5D0rXRudZSq+pRN2W1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A614C60121;
	Wed, 18 Mar 2026 08:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB52C19424;
	Wed, 18 Mar 2026 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773824072;
	bh=JSANhBrI2HAH9lxhnIO6pJDDCpJuA14LafX1GypTuSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ixm5qREEy738mLJYRkrJGQTu7eQjZTx+BVITP+UR8VfgktM9BHCR8h58zh2pF8fYY
	 AftnKJHHDPC4nT6b4pUKaPpPMKA4DyPZi8lFvQvcjXoEj4pY55YbxwsPRVhlLub+4a
	 w8JenOZvD+wAFtRIghG1DAlWD+rSkwqVXZW8QeAAM12/G1bQl9ZMDtBqhQ6YhO1QlH
	 ZnUM9kx840rWYkU7rkbfV/05QqwnJ8bpO6C7a+S26s7xUh986FfI4V5qfIld8bX4tS
	 /Z2kZV2/JGu0jO04HXcZ7wn+Nq0WcJkAN0dMChcmdxJFwoiETOLkUJKL0BBodL+dNN
	 QCpBKbUuWqJeQ==
Date: Wed, 18 Mar 2026 10:54:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 12/14] mm/sparse: move sparse_init_one_section() to
 internal.h
Message-ID: <abpoQWT0kY2Ybx98@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-13-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-13-david@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5118F40013
X-Stat-Signature: pu89rmet6a359abttbdtzw1x8j9kx3do
X-Rspam-User: 
X-HE-Tag: 1773824073-23141
X-HE-Meta: U2FsdGVkX19aA1c2e12uwqmmPXPlYXlMwpW/VJk/BMP6ysJZ3ne6xDIF5M+YMw1xtoiABuYcuMotcwByDh8fuYjImkaWCoLOsn3jXoyCzsRLTgnWEMtCPXT6HgRDuYSoutjreHVlr5439f5PEfGnRnV+Xi1EoAqu0d7TJCrWXGHeDDFl9Y4pqcCCe1euy+FFQSqD6eH9opfUcfsLhv6mWGqtBzPxX2G/skqWpBrfGkhy0etJKDZaXd3guckGdJoqF0/HZkPBqniuSEJKSOMMZEe80XeNv6KK8S30GMHycmKRFkejHRNTyfxBJuAD1dn6XkdT0sncYfm2kw7iFosYTewVxrHQ+ArpkClzeOkyd9Aw0o+YZ6gEDljspU87xbwhVwHHPoh8YUhs9/qfsG0C8UxITqeUrz92Qv1mc609eOSx1M5h7FNp5jX0xSWRYSIH0F7LjQWTNBKM3ICPgdyuIoc4pna3WU8SsWiHHy5DXSm84ea7v+EAB/i4kAPpWMWJF2ZbvW7YXS7zJoWFhRias/KokEHWVaUxS3kpjDxWJ8WwlC4UzpLX8R3FzY0W1icfoxzksQ4bQINwd4CPa/c+TkWiFohFdIfeBH27s2bz5BvkLBMpuY89Hwq2WrfrnwXQmBxU3dpFuEd92HgHX9jzCM3wkP+gPU3d4gCOHQLFeD/FckT3V1XnxHQc78/CeT5d15mT+He0N0FT5J1e4KsIlm5iUisterDWiTD7gfJ484f2hscjREK3VtE3zfCCvPVNkYt/lO5TYJbSda9DjVjI8XIY6vKP1yVezCjdt34xTRcKBX7kyAVkyyAILTQ5xDvtTFluD/deRD9WX9jKWZWf2vo69IV/DMwBuExeuhMvIxKLPi4XmOvrgfZWhZdwTY+bmeuFOTdMX7SCtNsOVGama9mCyqmyC8OJQeOUpWNOfbCaFb0kHccbdK9LpYec/ZYLb5DMmDxikP+8BCkLJ6r
 VA41ILcR
 LoC05
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:50PM +0100, David Hildenbrand (Arm) wrote:
> While at it, convert the BUG_ON to a WARN_ON, avoid long lines, and merge
> sparse_encode_mem_map() into sparse_init_one_section().

... merge sparse_encode_mem_map() into its only caller
sparse_init_one_section().

> 
> Clarify the comment a bit, pointing at page_to_pfn().
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmzone.h |  2 +-
>  mm/internal.h          | 22 ++++++++++++++++++++++
>  mm/sparse.c            | 24 ------------------------
>  3 files changed, 23 insertions(+), 25 deletions(-)

-- 
Sincerely yours,
Mike.

