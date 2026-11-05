Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47F2606B9FA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDtVrelY
Received: by kanga.kvack.org (Postfix)
	id C4B196B05C3; Thu,  5 Nov 2026 14:32:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C227B6B05C4; Thu,  5 Nov 2026 14:32:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB866B05C5; Thu,  5 Nov 2026 14:32:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF696B05C3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:32:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 016EEA0C1B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:32:43 +0000 (UTC)
X-FDA: 85402062648.03.BC3DCA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32408A0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:32:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDtVrelY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rb2ofXzgJBc5fIuQP0w05xjk/81sHfOWEL8zO3J0XUA=;
	b=HCcPDqG31tfbYghsPdXK7/diMXF9wTBVv6xHyOX3UpaY79FrhIg5085VgQa+DezW9cgWtg
	9W2tU9Ag/fxo8U9mVrCGCiRWccN2baKQ6b7DH+qMryJWIiKMcNo6Tv0BdG962vNxOvG3NU
	jNVzsv7hAKqmf5zo73fZhFXSQYqYx7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907162;
	b=QGZV95E3GJw32Dosrtfx/flYpfYiZ8rDJ7mxx+ACv9GTFe0+vlBxdziyJvMkqiZmmnEUTh
	w2iPjiFEU7tLSw5r5UgwYcwqJghVRKIewbbNpaytY7saTaoQrRhfZbqH4yKN94AI/c+yDd
	OHDBSHFmRTAt4J27B3sjJrDjyVkuokM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDtVrelY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 752B4403F9;
	Thu,  5 Nov 2026 19:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C1A1F00893;
	Thu,  5 Nov 2026 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907161;
	bh=Rb2ofXzgJBc5fIuQP0w05xjk/81sHfOWEL8zO3J0XUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eDtVrelYYt9il2577q40L8EJ4XtDnLbe9oqPCZ5DVXPhy2CZ8RykrXLqcT8lNJ9fo
	 iVvdOiFyVuQs7f9uc0KWN9MENqV2XhI4rRvK3+VjAyx04aExFaeskqW93dB8KnV1I7
	 jXPC/Dq+sLpMiFkrvl1FXVJfY5SmBtdGcpXVpAosWwzVpgGOAtgpDNtkSivs3sMb0S
	 idxJlASIgnR6P/pT9DmadA3pyNe/7F5fBJgEg6bIU8TZ5JFBDrGQZ6Q/e/u9IVIB7y
	 yZXuho1Kj6QIDbZlEjN5wDAh5ZVw8ddXkVoI6kVGhOjvfJ+tc5dncmBzIgU7aioe/k
	 V1zZhbj+ZI/kg==
Message-ID: <7dc47941-0c84-4260-bf9c-1a9bbe4d4f08@kernel.org>
Date: Thu, 5 Nov 2026 20:32:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] shmem: skip empty unmap ranges when punching holes
To: Hungyu Lin <dennylin0707@gmail.com>, hughd@google.com
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105055619.58289-1-dennylin0707@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105055619.58289-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mracykdu5ocxcxzydnceug5xiap8woqs
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32408A0008
X-HE-Tag: 1793907162-777022
X-HE-Meta: U2FsdGVkX19qgthan4Lj4SZ7zXM3dgVt47Ep5vV9MXaynRfezjqotTpKcLLcD8LW7+dROkDz7tFWbYTnduXT0N5z+b/f4EwuFbfCuTHJK8AvLGlVGxKPVNd8Hr9mo4wrseMcB8l6ppaC4gaI8uXpz5T2n+tj10QqLpsedEZ/3WdB64uvIt7qQM7JtU7D3XgYqGEn2u+0EVFWQYJDjQwFdzpaETgGDHVb5h+qJYehDTix82n2yHLK30mcFLEMViEqG3haMqJb3D3rx7KaasSlb/FtBkJLZcCBpoR0GsqfSVY/gToyvpvcWsgggvvNkSp5nHVwk3BqKLKj/y8Inxrx2xypDPjQiyU+DtbbeU0VOdLbLgo4mGosvAW9EEdcLlFXxsAOTQLv2tk8CdVMZcvoDbHda30ytYp92gA7SsMbqxhOd0gvbIUm4XlWbfd45EkaR03AKiVGd2MKIZwd9KGHTqK/wAyW12BRRaYAK8zloT1pgLasJNPnrPRLm9uX/XMcPT6KbYWrY6ZbhS+W9tp9Ng9jtWSk7rfUxv4Ue/GXue8nS6Fu9xljdBZ200NUhWqjZJYdr2uB9Nn8jI9usSzYuLCePQ20z34VOUyKKokmuqigTN4a/Qd2r5k2vkBhMab04K1K7K4lspZFHPeBXvXsLNXRzTwUR28AdK3Kxhokalu72hmp002ZVy/j1EQTgcD67uhRnzkRSM1x02JTWemiWLeIQf1b+OHhj4Bsx22fBzGrocWUbadS4iNqOeytxCbhMOGp2lpotljm+FmjtQ6tbosFDwWFodsscCO7vX1NFC8+spOdy31m/6T3Nm/lUH0E9ZKfvT0QKHEMtShsI65GXfH7TwbVkrdaaqLttwSDCe3dCKVfLu4ZXoCm1KnjkRmxynvLBwyFps/Ub0c2/6MVfw27W4FnTMkq1VOshpb5u7ggWyzkjQdZP07u+TxWHmG99vavEyzkDtaF6hslL9S
 gulXpgdv
 MfiTSCYfBUM9+7SNaEyG4AyXtsuq3Nzk8zY0GW6ac1mqmn99pHWMX0NaXgJgvaGOQEJTREduB9+MzyJsgUigNJ69XeJ/feRAdTaL9ehylV/w2Xq2bdw3RIGkSjpjxvJOC8DdvtreKtnAZ/+nJjlp0vz44Ab3hW5LS8YxQCGBpHqY4FBGZlKYJCHzOMuLOJHy9/bXbPm9YVyn845pZPfLKcgAfeOEE8wdZkjohNL+eOetkM8ud6cbpHKj6GMETRbhSSjOkpF8J4S+6YbVfgOoMfc+yw+nvCJ7g0SlK2DDWvsP3W7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 06:56, Hungyu Lin wrote:
> When a hole ends before the first page boundary, shmem_fallocate()
> calculates unmap_end as -1. Casting it to u64 makes the range check
> succeed even though the hole contains no complete pages.
> 
> For example, punching one byte at offset zero calls unmap_mapping_range()
> with a zero length, which means unmap to the end of the file. The file
> contents are preserved outside the hole, but unrelated mappings are
> removed and must fault back in. This can be reproduced with fallocate -p
> -o 0 -l 1 on a mapped tmpfs file.
> 
> Keep unmap_end as the exclusive rounded end instead of subtracting one,
> and adjust shmem_falloc.next and the unmap length accordingly. A hole
> ending before the first page boundary then has an end of zero, so the
> unsigned range check skips the empty range. Retain the unsigned
> comparison so rounding the start near the maximum file offset continues
> to be handled correctly.
> 
> Fixes: 83e4fa9c16e4 ("tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE")
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
> Changes in v2:

Thanks, I'll wait a couple of days and then queue this for the next merge window.

-- 
Cheers,

David

