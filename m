Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A392DCD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46176B0093; Fri, 22 May 2026 02:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6BA6B0095; Fri, 22 May 2026 02:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C086B0096; Fri, 22 May 2026 02:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFC2B6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:43:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40F3E1618F7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:43:48 +0000 (UTC)
X-FDA: 84794115336.01.852B3BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9840A180003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:43:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcvsNjb1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779432226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biF+ouRtY89p1pL4sTu4taHmkX2yen+lW/Wuq/AnoKM=;
	b=XC6dYWisGAO00uboGcyoJZYNtj4Ae12s7utBH8S3SuH5XjMU2denR+rx3qSgzMmhh0avhT
	JyrrMDtSajgxraLuN/WmHf3kb/LAiZil7n1KHXHOgaWubkQ6SQJ5VZaq5WQYwtlW5asCwk
	q0AOIMt3upbgSFPscfTQsbZhHt0ZUnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779432226; a=rsa-sha256;
	cv=none;
	b=31t166JJkgczS4SvQnrSv2a71CIJ63f+s6lODOyK2riC/2k/M2pUsBAT6H8rY8Px3bl0FX
	IoV/mMaVa2mYppIyxL9A8ysMobjwlBXON9vmZ8q6MmFZ6tm5taau1sUpg5aZGGqSWmszuy
	4oawq/imXqyRxRpTJK+s1UY8MY5we6c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcvsNjb1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C8844401D;
	Fri, 22 May 2026 06:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3E01F000E9;
	Fri, 22 May 2026 06:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779432225;
	bh=biF+ouRtY89p1pL4sTu4taHmkX2yen+lW/Wuq/AnoKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RcvsNjb15fzr+4Z7dHAxMo1Iia90big6KI/HwskLZRrlIC2H8APnZX+0Rc/31+AX4
	 fuDot/glB+tpt5/lZbVvRKtzyZVXSVd1dQdpwTjMdGTxgQOd+4wF1xS3csCSMKl9QZ
	 Gql3rJbibgLp91tXTkObSdPiicc093EzscwOlccZgLUT8svKdA0bvJijdT5jyw9lpR
	 g5TyDqhH+MxoPmaibC/g7GGPOh4R83M96M8B6e2ldMObGd/1//iX81IJ7kHmV05IRe
	 8gHNGEHIOEu90cyrkPqmBoag3TzPAZmLqS9q5kujy67K8zYDKX+r6dJhLdyNcaqTcv
	 RtLS3td7q8YzQ==
Message-ID: <093abd25-939a-4f67-9049-24206aab1c3f@kernel.org>
Date: Fri, 22 May 2026 08:43:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ipc/msg: Use dedicated slab buckets for msg_msgseg
To: Philipp Weber <kernel@phwe.de>, akpm@linux-foundation.org
Cc: kees@kernel.org, brauner@kernel.org, jack@suse.cz, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260518182636.58134-1-kernel@phwe.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260518182636.58134-1-kernel@phwe.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9840A180003
X-Stat-Signature: iufdu4m793cjaszz3noabko7ssp31mje
X-Rspamd-Server: rspam06
X-HE-Tag: 1779432226-131197
X-HE-Meta: U2FsdGVkX1+Cy5q6mloh2lz0D9WAmxVce2ZVJObwJvk3FsVnfOdqhHcW48nofVu1sS0yQ7Z3Rie5E4bpK1avWcJ3Opi1qCGSsNvkVD0TZlZCNrsLUJ3/+hfkIEJz8uUmHFx9yT+yDefXcJWdy0QypxXhZraZ8DDDSzxEMR2Q+tkEg2dcIw1U9PCBHw+NpkikxcmwNM2e+KPjdeDgDf85dr8fBPcymDTX6jdVjl2yskwt39DhNtJkWLHdKbQ79KdZ9wQGWk71+6yFU60yzP7GPT9B9hHth0sHtQe+tziF+txoRQSCmA/x04A4Td5kIkapgKIJ17AXQ6oN3dG/nJQ1aJu4NvAr3xYiSXRIjskiRDI9si3eLDXJ2BW5ORTLhzUhkAv/QsxaH0xopuG36mLoBPnqN99ZL/bUFlhP6qUqpvN2S53M3F+WS4nqUQ4b9MqQZSV+TM+EMnAHfckDGTyW70KJEQgkzkGDAuy1LLX2+SihsTLU8DBrp2sHaKfFfuSceJbbi9U8ZTzyz8EqhHaQjZdZA9wN3M7Z/fm9iQ4rUUA/dyqOqreAQJqbBp1qeFI0MyialeEJXfge8bGBFRA9/kkX+aCavqoo/2jwjpGq0IvK3tFCz/oNT/Qk1xclOohA5jhxH7MSBxDCWrAToPkV/MgzCcZECCMTNUT4SuRd9zDD+KAuXm/MZOM7Sen6KQocYS8CvcWRaKX8KhFHtSH7ZaZLaoS1EQyog4C5zesarrIXJ0fE8RWoGc+zuAEj5UthzsgYpYiEC4R5XgMbRSev7a6bJNuJBtIIL7jYouZaFWaj8oGyC17ooARjGiJ2i5Drj4oPxCUnngiusxj7MwsU6RmO0R70QGt7jIqPMZtPK0GlodEgr6/wBMYWI4QUCHPyk2YmdtqcYAQiJQyGVzq+mNpxFhO37EpEe2Lb/csGXGDCGvxCPKh8mLExqApHmC9unSjaCP0H/t/bnpIHCol
 NPZK0m6u
 CnVHFH2ZNYzJgc6iWnRYoBOcZUuh6pW9aPhjPLzBC/yZyGpxqrVhesVeMLolKyZMZXLD9y3FTpDg8Sc8avC4xoSb0VqbTNL53EsvPlREBthUJSL8yNzqj9PMhFZ/jD0bYQYRK6snT7f9IbNG1a3Y+J3pWKlqfzMevhlTnzIVn58F0e4a4NgVuLw3t2Ar6UMFwYJdF+JYrHrNL43nKeZuTE32cqvcy4zHqq1tOMIrJdQ08AMMjFZFb7QWfSQRkPfdBw2cQQONs5zuAzb93esfNTRYynH+DpyHjDjp2peHnF7oKLJ5ZGkf5Xv7ES9J+AhHrIoBlqqvS6Wl3pu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 20:26, Philipp Weber wrote:
> System V message queues already allocate struct msg_msg from dedicated
> kmem buckets, so user-controlled variable-sized message allocations do
> not share generic kmalloc buckets.
> 
> Large messages allocate additional struct msg_msgseg objects for the
> remaining payload. These allocations are also user-controlled in size
> and contents, but still come from generic kmalloc-cg buckets.
> 
> Allocate msg_msgseg objects from a dedicated bucket set as well, so the
> segmented payload path follows the same heap-isolation model as the
> main msg_msg allocation.
> 
> The free path remains unchanged because these allocations are freed
> with kfree(), matching the existing msg_msg bucket allocation.
> 
> Signed-off-by: Philipp Weber <kernel@phwe.de>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


