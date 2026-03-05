Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E7BEEF329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806CD6B008A; Thu,  5 Mar 2026 03:46:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2F86B008C; Thu,  5 Mar 2026 03:46:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707206B0092; Thu,  5 Mar 2026 03:46:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 614986B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:46:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29905BB791
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:46:36 +0000 (UTC)
X-FDA: 84511378392.22.4756E51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4FDB720003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:46:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m/NmWyfJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772700394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+L7mo2Hd0f5y0NCQycXVOybRLbBVMcRhRP1dRte4oyA=;
	b=QQpRxoL/Xrr0OKPicRKpAZJH18U7zL5p395go9jt3zomhVVSurZlEhtV3TMDjouH64hVV6
	8yMDV9QtSqff3EUPBSvShzCFxaxc+0gi4tWSkqVbGMQr4NsbTgBZYHd0mS3cp9JAbpFOs4
	ZqrY+ZSfew8hOIdCSZUaFhLzF7WfmkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772700394; a=rsa-sha256;
	cv=none;
	b=Rj3wzi4NSnd8A9TG3c/N5aDNxLeRBQS4yuQFpv5xq1xih/BoQV4bGqF0TZ5d5d9FriLpO3
	2W+YYQ84bNBXJ6v7wA9HzZe0ylclK1Nd+EEQ5TenIZDgq6PuMDuRTW1Far/nmMARN8sgg0
	fLJP3paPNuMv+Dx1rybYQCBSREzHe+A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m/NmWyfJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76EF743231;
	Thu,  5 Mar 2026 08:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3DBC116C6;
	Thu,  5 Mar 2026 08:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772700393;
	bh=fyVzRgMWMfn3zGWnwhkhoImi31MZExIN1JROrOw0QNA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m/NmWyfJo8yyCM6A3RkFwXmUbJIPhBpZOF7aXEWBmGJVnEdl+4fneNINNbBe2AeZ7
	 PhPafWXDJXvz5HYwpM2uXM/foYdr3VpYbRz7mr22buOvMf387rFKsJv20slrVhyg8K
	 ha6AXfaDrlxGIBE777goNZVDHCiCsjekavrkVBgIJ403EuwCqv6Ow09jhWrSdW3oCj
	 dXCP9WjlMLs984Ee9CVlf2W51Z/7raoSDl2mB9bcgYfErEfXPUe764N71iPHV0gS3t
	 mR8ezg6NIiWnRblOaXWU7UJSBNw3pfns29sOb1WXwHBd9hl7LgMgWRXCx1zp3dTdaD
	 pRpXKXqxNqgPA==
Message-ID: <31f26c9c-1596-40b0-832c-89f4134b9e58@kernel.org>
Date: Thu, 5 Mar 2026 09:46:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add mm-related procfs files to MM sections
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
References: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4FDB720003
X-Stat-Signature: 8cm7o63uygguowdxyo5ieyidgacjo5cm
X-Rspam-User: 
X-HE-Tag: 1772700394-179182
X-HE-Meta: U2FsdGVkX1/gMg6x7/iRMSGjpDtTJAXlCWx3Sq8qv5dQuQqi2F0N2yXnuNszwYDsqVcs6yw/DVuR+JLuCNl1R8kUdpQPCb05i4GElaS0vbUdxlCBYSddX0nIPi0PRmr7aTaT/Suv63cD9CKsPUHyrGUotv2aDb6kEBC8eL/FJZT1/00GdjtA2a1wQAwLObldXi+XijNzqBLDHGQXIt7WG/wT7t7zc4gT4AjFYg7H5pkixBxhPSwgGO5gVfoWzDFIf3ZPYIjbDb+vdBDtjUypaL6SMezg6U/wqK+dzNvP6Cw9bhjycm7c9610BTL72KalBZb+IeznNFPZH5fTxH1D4s7234trl0BkRHFyA15Pb4aatMUcfdH8QPJ5bLc9P9hVQJnRAn+KNPayzaRHRJrySCf++c6HQqXO3i58YoKSuDG9eSvP0UQHCDsfwK/nJEE2YCOnbg+qwykyeXPfL+p3cpPzxLjqnjwJ15/jgJ6DcQMS64ZsewkU2P0poH1ea98jOTxWuWIDefFyXqz0SDGC2dwlJ+o/5CXpFGF02J0Dr2VZxRUzu+U2apapS9mUR/DY0ijPvbhCL2cS00Ie9KfwLRqeo54ULlR6T1qraLQIivqn18VCHdR2YRPSj2hdZk6X78hBQ0bwakLqAxu9N7dzjMQ8GIBu4SjGkjgLoQigovKXzo4R14j5Id+4xLOeUhz7PZKygsWh3koUNIBjRgcBPyeAGe3xVK9U1qLXiBACHBipJj+fCXhXMmvzjabnC+6Imj1AaKV8tQw7lO0tyTXWpcB5d2OBmUiGrmxwN82fOQFtErBi6e72X1/TpTp+YUn2EsIWoEoL9RL4p3R3GcSOJ1sviF9UaM16mMWhS9xya/ue11MJ+Uv6ll14h6pN9eiELhka0BEOvitcOgV0dB2v8GtuqajcLJklSMZrd5i10Np6xredAh71DlKeJhnNnzhpKo7DD9Bg2FuQwcKCYUC
 PbGuioWZ
 c0fjhxGVjmzMM/kp4AJjFDowqqFt7sSWl+MWtGrZrGxghCXMshwfDYXqwjlnkHrT0vdfVtA6fyFX1ERYdPD/N1q6txbP0qWIeZImrYblgsCIALwZsA1Iq1CIudrqv/M99pgGCMSMKlwGxhu33wElqJejsefFT+cFsDImxFu4/DeKv2jt6UFvbQmbrwSQA/EEnXCSAGAB7MEH/yJTYNxNfeDKPqROY6BSY5/ZG2EKMR9pZG6UAzQtn9OQ10DWhRLArTfFqX7aT1Nf8wiiCF2le+8FP7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 09:26, Vlastimil Babka (SUSE) wrote:
> Some procfs files are very much related to memory management so let's
> have MAINTAINERS reflect that.
> 
> Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.
> 
> Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

