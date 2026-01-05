Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DCBAC79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB4C6B018B; Mon,  5 Jan 2026 11:26:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8B86B018C; Mon,  5 Jan 2026 11:26:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5136B018D; Mon,  5 Jan 2026 11:26:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87D1B6B018B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:26:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48A47861C1
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:26:32 +0000 (UTC)
X-FDA: 84298438224.18.AC2BC7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D9631C0014
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:26:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PP8vSOoD;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767630390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZ2ojU87TNha0KRRGRiKIzPLP9/bRKAPV0u99QmmZ2E=;
	b=nhf19MPKFtMi3AjvlhBacl4jrOJPYcDIvnh0pSSHTwz9BuUO5AETX53FgwVjgWSw+kh4LO
	WMsTUvCI/pq0qgoZydbOeACYaINijdYsH+dEegx2Z8kjvLVcasEb4NrhaVWXewPbfiXDkG
	YdUMlQSxsEQkxOJCvivA5r7zcybvtZ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PP8vSOoD;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767630390; a=rsa-sha256;
	cv=none;
	b=G0m1Q8fSNyf1EcS26o3xRKaoyMkh0sIcPrgSDEKWYyJq7lpGmFqVucGLOZzY30Ijf92S7n
	M41S1DvZo7AgxinJ36cFIIR9gzfln4zRtLHU2aL5JrI/kyKnelhF33N4Wk+8hcKRwW1pwA
	6BKicVwMIyDUar+Dep6fNflSKB0GcIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A73B06011E;
	Mon,  5 Jan 2026 16:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08145C116D0;
	Mon,  5 Jan 2026 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767630389;
	bh=6SacAMtpQANO4psA3HZm8ayi91MqDzYKHmJBKJCg7/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PP8vSOoDTgvYUhxARFnNQCwHSjyfT5W54BbX3llSGhjKAht77UOueDxH2RC1xkhQN
	 +EDBIXbHsVGqWN+j5ATsD48xYHroVq4TH2Q7z6B/2wOl4caGKBYUH2jSI/uRFk6pAd
	 iGLFOGfEgzI/32bZIgvbGR8NcZF5zgVgRUqf9BK9VJkIYGzXaxtqWSqAlFxpI1uZpc
	 QaqTnc6WLU72idmw3vWcLL7uDv+gTxsyvzYT5prsaWRApIC92EJTRYZYRhTEiHqHqO
	 hllBkBPiZLWIl7YGpJMQA9Sdh8yDQKYKrqGuyIU9ITb3iuxGnSsRXUK0s1GsHUPiaA
	 O1C0Q0J2/fHYg==
Message-ID: <7232ac17-8fb4-482b-b820-78d6bd47c4a5@kernel.org>
Date: Mon, 5 Jan 2026 17:26:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 Ackerley Tng <ackerleytng@google.com>, Michael Roth <michael.roth@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260105161741.3952456-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ypagubjehz9r5nr4dpgakio5c4o4kuns
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D9631C0014
X-HE-Tag: 1767630390-685738
X-HE-Meta: U2FsdGVkX18K8GogdT/bRr+xsmimBbG2kHZtviNsgl/SEdSbELr+6gOMGYgv3B3ml/pHuFJWZyK4vVci1ZsUkP5Gqy/Oz2d45ES7VSbf+WFCmH30yjZi8NsShLNaSMOlD3UqxeBRVCvTQi5RqVjzX044bKvToG1e0tA3K5f5g+acupDgF/YYNyONGUV4kBEQI4zxecP2lO5lKnL/4GqM2u/OtvcI3rwiWMrgyaKb8gdGn7t14719gIFNWuV0JEjJI9BlQ2xVJwt4uhHKXLiMGOMCj6U6bdfXMLMg0zSV0vXtWcxPwRMdWUWNZkFI6NOJXHn1sM01EONIG82z3U1Ieia+xFO2be3FVqcmLvaQqGOvLXCNcyAmuZNlKt0r5ZU/9Qaf7D/BueirqBBuL9zcgYSbS+7DBprgaMwEQ/p/gNx0nFpXhXajWw9XRvJopIPwYlVrMmQxJuU8DmuBthqwrDWFyT3iLr7//XJQhCxOGz9PhoDGgpvgkG+NqQXkuCuXmQBuY+StKE8uiTIfteK5llL44HG1NkCVxzqc7VDUgC1K0gdzqzZOg8ld5Bi1UxSR8KNqPAPXmwKeky5U24MoBRtyr1Wj2xnQ7StOC5YUUpUZmZ+zsrQwttUuetpDUTmdLlyyoNXGf9hA8t6DplXMmbKBDbYgmHhGMhZtF1oK969ns/vQ6XqqaoRcYMsSzinAId4uu756pzrd3JdU1kMKrN2MiZyDnhcgtRG1Xl5eL7SksUMgvL2/rqlyjdgtcTJqTkdHkmTDd8CpHOSkQVaSsPIgwm5mPIUBbNenhbAoNscE5PWuXWRG4sa1PbEAipUciBYvV1HexlOYfeo76imw90awnEEZJHHckfa91R6B53XnS8IG5n14QpDpXLSWQjfTonGZdyF8SfByuPdlALG+XTvUGRkoiaYBJnGTHYMfbZEe02QApPdhF1lWaGS8NquCRy6JwhxOkyf35auZB/g
 K5XvJmuL
 ax3YJqhoqOJkgbunFuJ/9D4DIRrqhYxJlqtFrVJ1wFYKXxteW1kTOmdlZ5oamF3eTpveJMRNwhu0FC4AYk0+L/40cYN4pRNl7x1lVtQtd2IX6v+qU5uXSBny0o3v2uQhB7SiplfGoZqg4j/MNqVgJld1Mll8TT/3OoqbufkZ5fNY6494ZVBuDOt9x4u/6XC6jYGbtzvWNkoDZ1r5AiwE/BkNhtsIxhCv2a6UoZWo8G9ykCF/7k+CzmUJS0/ScszMKO2gCH/DNiyFAXp+1P8opXzQRVf3xaz24VhuZynNMH7r4TFFR/iSv+dduZtv83YxYyKcX8fcJ0+dROFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 17:17, Ryan Roberts wrote:
> Hi All,

Hi,

> 
> A recent change to vmalloc caused some performance benchmark regressions (see
> [1]). I'm attempting to fix that (and at the same time signficantly improve
> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.

I recently raised the utility of something like that in case we had to 
split a large folio in the page cache for guestmemfd, and then want to 
punch-hole the whole (original) thing while making sure that the whole 
thing ends up back in the buddy.

Freeing individual chunks (e.g., order-0 pages) has the problem that 
some pages might get reallocated before merged, consequently fragmenting 
the bigger chunk.

-- 
Cheers

David

