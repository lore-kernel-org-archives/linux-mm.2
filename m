Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A71CCF2D9
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FAA6B015D; Mon, 19 Jan 2026 05:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C6F6B015E; Mon, 19 Jan 2026 05:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858CA6B015F; Mon, 19 Jan 2026 05:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 704106B015D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:08:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 166231406CD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:08:15 +0000 (UTC)
X-FDA: 84348288150.04.8E749F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5CE1C2000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:08:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1EvONks;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768817293; a=rsa-sha256;
	cv=none;
	b=3oTVSffgvDQorH3A3wXVfincyvHer/djSE8UX8Hx8LFUDWMO1R359nfSeNNfKxPd/x8UBM
	XvcDrA6kSoXtBf7ZjRxGTcrM14lEB2NIawNj4BiXdaJrB9bbtdU7uj+lAGNDfd+8LqutHd
	BusE99WSIZrWTEzRv+aJ2MrDGyiqlX4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1EvONks;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768817293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiUewGZHTpbcLNmueN3WjOTFJjMGXEaWSipy8xCp5DQ=;
	b=gQV6o6KhdnWkcXMCutlTaT6Bzy/3sdBo27e8MakmJYvkxxjMo+IWK6erf0UWV5b/3PYxKz
	b7+sdVdpmy6TCmihxo3+eDxHvcSF7R+GALlj56oHZzChDdUSK4KKiQtj4K8kyaF7qOqn3E
	z0GyDv7DDhwKrUs1CzNqxJwiMSAo2Ls=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6C2360140;
	Mon, 19 Jan 2026 10:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4DAC16AAE;
	Mon, 19 Jan 2026 10:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768817292;
	bh=AE57TIsmlva7rZ+tGbHhruAtmwUG689KaCOC5eS4PRA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a1EvONksaiYmLSxCFTwMjjYMbZ2a3RJ73mX0Lrnbk0OmaszKbjtEtXoNDeFE2+GYV
	 jC+rBDn/ytqQkhQKb1yWcSaslOxDh0Sddfn9Wr3zdqDpxP5A08YkpZqyMpuLiQuNC7
	 4czbEpX1QdN9cXwvyOFZFXS4GfckP7CVIRz/GLVJMjauogD40CvyGHmcmSRl2yuF7D
	 QAc+XqXVTkd+AeWDDaKCz2NaGGW3GvbdDzr4LIeeYM3L9tNf/KVxHJrr/9TrIjgrWF
	 yfZnCyJv6wOgAotqrhpcaXNWeEBRopZ8Y+fGX/haEUOitRnv8/Xj+7wB99XYg488gy
	 JhIhHAdvkE7ng==
Message-ID: <df4ca339-15aa-4346-bd66-00dc6002b630@kernel.org>
Date: Mon, 19 Jan 2026 11:08:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, linux-trace-kernel@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 Branden Moore <Branden.Moore@amd.com>
References: <20260118190939.8986-2-shivankg@amd.com>
 <20260118190939.8986-7-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260118190939.8986-7-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CE1C2000A
X-Stat-Signature: fgqk4acxkdx4zd4kci3ut7cmkwoqt8up
X-Rspam-User: 
X-HE-Tag: 1768817293-894866
X-HE-Meta: U2FsdGVkX189tGJyfZ7hqJqLYvUHM7tsbLp/VmrfwOUdOtH8NvF5TIHjeOCpqHXXuYsGWlYo1WcF9XHbREvkUJcP0XSo4ZLZ/sgCo76JEYdcBF6PGwJd8KduJElMLTsgVKkBMnv3uioardgltRnllofGlKpsjI7z519J+eKasq+3uaf+jQPp8wP9e4HL86JlNmct8BF5J5D3MBh4m7c4ZMo9gBd2f8bQJfH6/prLk4MrrgXpvvJGqnR5XRR8bYf3S7JoynA4IJsgXYjC/dOR3zepBYsoz87di7XOtm7t9hrX/+yVHcmzS0C6/Zckjv0P9+Bb3gvPf10bXJIghridBn/UAqWrO/d5xBE+KOGRUWg/fFZZdbAJKgKXse1TCuHOQAItBPZh+GygJKR+zWiFG7iOmTjtNPOxyfePiboz4dhWcedvB81yGCxlSfLLfvZRHs6b89gR7zi9zxl140h5T9brMWpvqDEhRiHYG/F8/O/ILNmGqLJTNNA50S+gbJ044bj2p7PV7umjvezzvNQ55BWqn96x9DPfRSW8xXxyYdZvrD6bc/qc+dlG9Yv0vAD2DV7OQol1CJSpDC04Huebuy141hZDuH46/S+NuikIaQUuxGbz4KCr+8/QlpsFA5+J/B2NlidaZXDqDsQQ81+QkF4yFbDAGyUXnNolITY+SKhmpYWSQz/szxjPR0YF5QyGItZsw3CYNq81SPz3xBRLA5ZpCcUAkUMa8tUgg82UC6gWEvnWGBn3ypYYVb4f/jrcrvulT/337VcXJrpDYmPagHJfU6G6BiyOr+tHZE1/sIGKc9EnzJt0Vw8IAwVZ/nUst0fbgEVHFreKQjzMrsbZcCCmRE0MYpHiuVSYBJKY6IJemxE4h+gg3O/Wz4dFnI2Khwbgd6B5ZnpflhgnR1iwfUqSYSYISwye2mG/HCVLqLZu+wtJD85z899ccgocJZ+NRgbN0+kBVkGQfLhlZ8n
 ovRbsutB
 zsZqyZcv2AK0VtmxU2FweeQxh9a2xEqbOx/bhuDYv0j6U0WOG7cWZWAjd5QK1Vqk5q0F3iBxv0OXwNWdSqAxBapKsm+sVmuLWKmxMpACU7mshx6UQkoxA08IWbm/kJQ5gAzd01Vug6mZYNDhdO12wvkhXmgqMgnsOfgtFt466Vm0uWCv03SOf42l6ReAsvbkOyPlrVJThR+bUFnlh3UJCR85HSYvJimBcj4NI+W0Ucc2xJKnG1wHzAuWJSNBNJic5mG7FXM5N9ppd3Uy5O0JLmar/D1hZceiy9OI4T6PyxWm2iHSHaELoEe0MTPikhPPRdz0mKTFIVGESc6J1Wq5+uPI8Go5/GgJWT9il
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/18/26 20:09, Shivank Garg wrote:
> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> text sections), the pages may still be dirty from recent writes.
> collapse_file() will trigger async writeback and fail with
> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
> 
> MADV_COLLAPSE is a synchronous operation where userspace expects
> immediate results. If the collapse fails due to dirty pages, perform
> synchronous writeback on the specific range and retry once.
> 
> This avoids spurious failures for freshly written executables while
> avoiding unnecessary synchronous I/O for mappings that are already clean.
> 
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Looks good to me now, thanks Shivank!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

