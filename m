Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B29B606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l70qFzab
Received: by kanga.kvack.org (Postfix)
	id 9869E6B05B2; Mon,  2 Nov 2026 01:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F8B6B05B3; Mon,  2 Nov 2026 01:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E036B05B4; Mon,  2 Nov 2026 01:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB2D6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:40:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4FF6160BB0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:40:36 +0000 (UTC)
X-FDA: 85389230472.02.92A810C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0051EA0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:40:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l70qFzab;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793601635;
	b=vY6IasfPL7I3q7duLzM07KsnP3wxhvjdcE3L/ImZQrKAzSKvusZcY8clgJ1zAdUIStmbAe
	7MPmw4IMOggZYctEYeUuj3DvzXuh2dBiIZKVFks5cYxyfbVeCq78vm7xs0rLFW2gbS1iYj
	Rq0X1CTYwCJOn2MpFGWUXWEgkIKofMQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l70qFzab;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793601635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTr3vTYHZO8//WK5iKDPZ2R6+tlg46gozzv5GKa8yng=;
	b=WRMLsIawjUvoW35QnPfj+9tOzlUGpcWzMvchT07/r1KhMkslxnwLhIftSJLQ5YrJfLVJCK
	Hy4lsBgbCw1pTY+pz7QQe5FB8LVSiUYk3eW5T8LJy1u7Z+RRApefJB9Pny88lwb4p6F9kO
	YP+SwnQinAhnT/sS4j5erOsy6kmMK0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48E64418DA;
	Mon,  2 Nov 2026 06:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F30A1F000C1;
	Mon,  2 Nov 2026 06:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793601634;
	bh=PTr3vTYHZO8//WK5iKDPZ2R6+tlg46gozzv5GKa8yng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l70qFzab7Fnm3MNz4rNSkWb1PmnyKAaayewzifcEEBYaKwcea73ASJahioZNFlOtO
	 32EdTN+XUKPJTd9RZ3utPt0JY1lsCkZaCEw5+dYhRpqq6lC+XsUtd0iQNvkM4QxAkX
	 /+LXtMZL8MqVFi9Srb1AvYKJpQo3gsjaqDWeAGpW6F+3Mly4vdDxWZsHYFaPqctcCD
	 M/pV/VwI9jtJL0Zo0tjzbttOX/7k1KpDLzp5NOdEp7jqncUDn8UuU8UXILwe45TuAq
	 9FKdG0f39FWGU1SUmvtdkUA82/fQOHbAuWuIBWtWhGMD9LASKjEDYgPPq/qhiVbqsU
	 9zR+lo9tZCHkg==
Message-ID: <30db8554-8b79-4350-91d1-cc626abb8133@kernel.org>
Date: Mon, 2 Nov 2026 07:40:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] MAINTAINERS: move SLAB ALLOCATOR under MEMORY
 MANAGEMENT
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zh5fqqp6z9zj4ju69w9kk78e5j5uq86d
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0051EA0004
X-Rspam-User: 
X-HE-Tag: 1793601634-760039
X-HE-Meta: U2FsdGVkX1/MT3UzTXxgotbGbHXPJbH4fQMy1E70yt84+TSOGQxmKtVDN9gxS5Aqz5jI/mxl76ai+cB1lPa0hHDRLM27rZhAVif3WLlwtPQH/sXvfq9cl92jl+Q9CeNOm6jzNUfE10IztD8WQb40NZVgoivmQiyBchs95bzMR62D2Ekx2WAfiMqndo6/d6NPPI+CydI8lPbJUkyA21nnD9/qI2aZlAGTa9EXiafzq/DGIlw/qqs5PmnVZrZrNUive3FyclwSG6mPyNwrfifBPpX5k+f6/h/gat824ylAPUHk5iANrpWNY+MJ3Y9OTcNbnq4oyONMB8pTLphs0Cm9fDaaLqaoVVLwzp7xYGxAog1LSw9KObzpegOOmB8q3P7Nr84vKehHVvYsRNsN4ikhAzBtMYn3FhlXtL4GVIHNrbGaQuiFXzHy9N4QU17wRtrlif4p7wbwUf+XafzXwYG0/Kp3d5uQ6aXjyNOGYkGYzZxApa6kyrdqvPJpSZ+zAfuC4Uk7043Y74aqnsavcHca/zIb5op/twY/CvhyBt3yf/i1xj5THmh4o+ikYOV7TIOiyR04DoMEQaPwbUewMLklIvry237h0UpVXNpqQ8ROxxue2TkLzLd4Kllufsziguko65jdg7z8g0ai6jv+cHt9nhktCo+DxQbWV2VEQuNF8TJA2AlymoO2bSd6EFSVwAi2lhsrPX1PwRPAWmrR+0srrTcovORQC+UHY/aOTM0oEQFv2iTVR02jUsbkXO1RHOlansmx273C5O20nQkX+QVNtPc8P/PoJfszv5u4zt+DG4wqNagMPpbK1eB+Mk/n09sYlq0Y0jT5qQhbvzIzpPwQswCEbuvNw3f9YW59Np7nRC6H9EzLKh5E/sweeTJ+nD5ThpxPra0kTQycKBacT+BosHUy/B06PulFGk98Vu0PeZmlOn+A9jw6QYN+u5RepS4dr2I8qz+GZGf+oJjo744
 VzWbvyuL
 nMyXqNYa/jY8enZN00yeBJkPsjhLmIL6FY1J+QPJu9XpQimm6DutjODJaHeTaOfu19fF62Q4oZZQ/uhtCX2lv643Jn5x4RNO6U06FU1Ri4s9maeR+L77972HZCWwMq4qEAqEXMnt+SQgkjcvWD+8wxsDmR4uoxDFrs83l+Lddjw7WlIsJ1ZxwAIVwntISbLOu7U7SPH+KtW7hDU2lbj+r0j6JHdrdU0u9VRmuUQAE2bQoCn1ONi3sE/yDZZswa67qw7wcmk5X7dNvx5S7tTFtMoIuAaj1rMLSxO0j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 17:34, Vlastimil Babka (SUSE) wrote:
> Following David's consolidation of several other MM subcomponents, do
> the same for the slab allocator.
> 
> Rename the section to MEMORY MANAGEMENT - SLAB ALLOCATOR and move it to
> remain in alphabetical order.
> 
> Remove Andrew as M: to signify he's not the primary person for picking
> patches in this subcomponent. get_maintainers will continue CCing him on
> most patches via the catch-all MM entry. David prefers not being added
> for mail volume reasons.
> 
> Indicate the primary integration branch (slab/for-next) in the T: entry.
> It will now be integrrated via the mm/linux integration tree.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

