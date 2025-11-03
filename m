Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77893CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE0D8E00B1; Mon,  3 Nov 2025 12:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACCF8E0057; Mon,  3 Nov 2025 12:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A748E00B1; Mon,  3 Nov 2025 12:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A61838E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:08:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 808BE1A0203
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:08:15 +0000 (UTC)
X-FDA: 84069928950.10.A42AD40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C42BF2001C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:08:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QMW8zha/";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+5iMoNOYBcLWe0CaIaAmmUu2GFWCDHnu4ctS//CQgw=;
	b=oVc8p+hHWS2oQs3qMh7Py7T44YRN9y8rlh4/fceNJ9V8eDPDkfRephNzIz1DJJ5EG4UmCM
	Icu0ZJuAKBi/NUYPMxjuKBxVF/bQH5+5NMx0lMkrzPwZ5b2E0o7cbmkOvK1AJ+trChpo61
	hMh1wUZ6Si4zjSI4b0bNkr8eQIhXStc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QMW8zha/";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189693; a=rsa-sha256;
	cv=none;
	b=mJ+8n1piRqZXfTNvZZCCqWlGppCmm8d/MJmBpeUIcbYVIaXFG81iT8TbjtDo7O/sSFWz4M
	9nrSCYH/K5tfHzzA6GtnqoGplwWrXv9jngLaxb3Hjbgi0KqtFEdDeFVXs8mXMXk9UexOSX
	UmxSSHs911NbKR1eU4jSr7KE9D+uhU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B783343961;
	Mon,  3 Nov 2025 17:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB9BC4CEE7;
	Mon,  3 Nov 2025 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189692;
	bh=R4htJzSMPqKUheWFqD30DrfQ176o4Yn8IJrGpqBlr/E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QMW8zha/pnUwa3tfZUaFK2bT4lDcoBh/DY32ySXAvx11GfxnxoQT76C+mWa83vMqn
	 5dgf8xFQbeRRXfbsboE5M/KFKQz47hbPo+EnqmXiHpYBYZT/iaCMtvy2d2ha8kC2jD
	 kgCM8jiflgzODz8WMWnAkyrMK8wZZiWSJ/y3RPWdIflBININGH3XfgJt3QlL3aOh04
	 VQeOoh5daKWcZcWfgeCKy1wVXRC06BIkFwwa+6zb6ouw5miTUoZ6wRq1INFRkKwBf7
	 9vBqWHAjIFRuHZBjJkRpVvwlCaqTdHMs8ANOEvnniMBCsaiTXLvOqKY52FCYC86mjb
	 KIPEY48x9nSeg==
Message-ID: <28a5b824-f415-461c-af88-cb474ed37df1@kernel.org>
Date: Mon, 3 Nov 2025 18:08:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm: Document lenient map_count checks
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: rostedt@goodmis.org, hughd@google.com, kernel-team@android.com,
 android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251028212528.681081-1-kaleshsingh@google.com>
 <20251028212528.681081-2-kaleshsingh@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251028212528.681081-2-kaleshsingh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C42BF2001C
X-Stat-Signature: x38auwdj19tpc6ptmh3dcho4xfnauj49
X-Rspam-User: 
X-HE-Tag: 1762189693-14449
X-HE-Meta: U2FsdGVkX1+SetcvtgVZYJlCuPlpvsbfhb3oBx84CKok95843CmgfHSUH5gcTuzbeYai3VJ6UM9Sz98xQ7k7ggv8sQ9Fr/QSaVnNNoshtU7QIuFHhdSEHfC9N4GCmbkGXKpqZ9RWFv0pM8GhPA87etk/9whfhp+VMNrqhSJLQjsFhQtb6FBctf0VqBhoGemnI1484LRQKfYGbjv7GUNSVwwe5+ixRX+GBS4x1gFVcJolXIrxvObPdF9AWAZwEpwSO7fgGxhC6630YykshwHZj0MeQrLEBBOmAMNbExnd3UpfvhX9f/DCdbIVl8CXF5ZM31PSTvZl++xZ/xv6mhQ9abwaql7GL4NFDvMf1AzLIdHQwioVTpFz/VyfIn6klQs6WAA+WOzu8YnIOY9cGRLl9kQYjD1UmyG+hrmFJIVAMx1k9u0Z1CllhhsGVlOVnPSz8v93OBXFff01n3C+0nP54iQ60AiEJ72s+Evn978sJUkZk81Fm6SquroIHyc7DtC7emr58ibg0qYMfLhxVlItjP1Hgw4/vNyPnlzkvzfyVQQ6FGMwaFZUd0DQ5VR7nOv9i62Tc6clATCpONzikB/AJWv8NokFs8xcbGKxZkLGgLr7yb5HlFWP8CnNYeBjFpkgh3T2Vox938Tg7Jj/xGLWK8AeNutjp5DbELiW6sQkoFzvxwZZ0GrLn+HjTktSQ6LkkL84h6OdrRx9v1ScSRk2ZeXczZpuWwFas2Ni4mHqcBuiqwYeBmQCmlzBBu/4GhnVFHAxcY+yJj2VDu/cV/u3cG+/6whrCgjI01G5lbj9dAw8Sm4cKJOAOmGvY+/k9WZp9JKk/tCZAA1iKG+JgN/UDbnfwqxLOI+v9IotCZV3KA8YZFF1DpM60EUxRS8IYlAmWWfs3nV/zw4SdybHIbMEqTUeQIDr+9+lZjezlCY10INre06ZYDcxH8yqTvtOZ9rZVCn0kFQfR9ZoX//j/h6
 t5j6nn0o
 /OL2tZqMgZ6PeCYxO1jPGfnLGkyJ0dCDaVh4D4JHF1AJGQUHshfNs+z7fzYsFEWlH0EBuOvMNYRu20blFTE6kw72HeYocEpGKdij/Qs3YxGBfV+Sj4iqU0iyPBm7ZP5OdZwnq1UDTSuXkPTCLOVeTbCe2/VTfSUgfZR1THHYoX7b2DyQjlOY583hFTmjmQbmIpQyYWP25sM85uXDBm3G4aC2WGbgL4tVLo+oEEvDlk7pLIf/izr5jkDBKOH2kH8r4HGqnmHrQqcW2NPBM80LzBLGerkK2PFG3F7A6aRgj1AIy2J0gY58u5WfSWNOQuYoZbmtAOGdmlLAnIZbGjQ5CF/VNLPP9n6zXRfFu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 22:24, Kalesh Singh wrote:
> Add comments to the map_count limit checks in do_mmap() and
> do_brk_flags() to clarify their intended behavior.
> 
> The use of a strict inequality ('>') in these checks is intentional but
> non-obvious. It allows these functions to succeed when the VMA count is
> exactly at the sysctl_max_map_count limit. This historical behavior
> accounts for cases where the operation might not create a new VMA, but
> instead merge with or expand an existing one, in which case the VMA
> count does not increase.
> 
> These comments clarify the long-standing behavior and will help prevent
> future misinterpretation as an off-by-one error.
> 
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---


Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

