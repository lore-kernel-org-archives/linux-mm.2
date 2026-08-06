Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AEADC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7248C6B0098; Thu,  6 Aug 2026 10:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC276B0099; Thu,  6 Aug 2026 10:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB4B6B009B; Thu,  6 Aug 2026 10:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 391EE6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:02:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15253A07DC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:02:10 +0000 (UTC)
X-FDA: 85071008820.14.6BDD55C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3C9F91C0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:02:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G3mH/ZAJ";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024928;
	b=Lo6GWqMz3XVDZv2qpyiVzwb79e9Ol2MES55+M/gEjZ5e8s1CzQqbbYh6ALlOY+Cc0xLzhP
	4QDI7w2pHjW4NmxjD85g6wT0xZxu69YDVypgBsWW81zYJDqnd41O3sf3G00qqPenY68bLN
	bkcDnqLOMXSWqpjP97HkenbYOSaT2OU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G3mH/ZAJ";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sj8CY+ONiryU5APtwGc/YgR+xr5XRUh8Uhoc/B/yfJM=;
	b=CKLh/6+RWRK5Mv9gSUwppHhUICzHV1vfj0KFBF2Ud1nfLSUiIKz1FzRstKqh8fXo263z0B
	csmEmknPbMd0gsNsehOV1uRTe20KE97irhoU9814Hy2w8HzVthWs19XOlEe110inuNYz8j
	KYm7OGiQj3EVgv0CLxOBAyfdUwJWggo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D76B40C2C;
	Thu,  6 Aug 2026 14:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5371F000E9;
	Thu,  6 Aug 2026 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024927;
	bh=sj8CY+ONiryU5APtwGc/YgR+xr5XRUh8Uhoc/B/yfJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G3mH/ZAJKCJgwvR/WrgftIJm0005B7WQFMvcWeCYDpwdVnLh7nNFwwWciAmB/E4Fc
	 cvegeZcVis1f2q0QFmnlkIOgrIdHYQTUs3lBuIaFyetIg23BXmPc5dFGbcAssiZGOn
	 9uaI9TV/EPRa9wHchr/EtZYg+s5birOeVhMfpVny0x7NFRC6TP9NbPV9rFFu3WZ86e
	 SRArRbZedRs8ijk1OKnZQTg5Boe7IQVsAlpcgmM6tEZr8wmQipGDbpBuXvTEcuVard
	 57/TDa5Wnq/eqrkTTHDUCrOMNmdtgmWwvrkaoY+stU6YUTGAAM9mLz0B7/1hYlhwFk
	 wcKf4BErxoW+w==
Message-ID: <8c763f1b-85ad-44b9-b36c-becd7598fe77@kernel.org>
Date: Thu, 6 Aug 2026 16:01:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
To: Xin Zhao <jackzxcui1989@163.com>, brauner@kernel.org, ljs@kernel.org,
 rppt@kernel.org, pfalcato@suse.de, viro@zeniv.linux.org.uk, corbet@lwn.net,
 skhan@linuxfoundation.org, akpm@linux-foundation.org, liam@infradead.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 mjguzik@gmail.com, ebiederm@xmission.com, jack@suse.cz, jlayton@kernel.org,
 chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de,
 keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com,
 allen.lkml@gmail.com
Cc: kuba@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20260804001703.1340667-1-jackzxcui1989@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804001703.1340667-1-jackzxcui1989@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C9F91C0003
X-Stat-Signature: 14ioin1h8o6n7u6e4tsjaxanrry4a7ns
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786024928-237693
X-HE-Meta: U2FsdGVkX18thul9qlSYUbvZSjwzkniFyqh+wEQtL181IxwhjYldccyUPSJge5bNfJzN2XO98gO8ARRZSEBbXdVXF3PLXmrHNBJg4NXVEcadX/xX4Q+kSlb3Hu2kbOXk28GqOcKj5gpHFeEdkb/FfWjdzDyVfht+aCLcV6ltkxUAkfx9Wi/uTw1UznGCZE4QJy53U+Vy61PbDIoeWRszawS+zLmC0mJVGVeu8fw7an52r+BXCgbpDbKFCBkeHg4BWdfcZgGLde7m0wKiO5bUQDzaf76OMoNzEhA/qb7vXuKoBhBY0mdUWApuEzqFGQoz3He4USzNkALjQtVjOhnP4rW+y61ilar0PfrsvZll+/HMd4TEx2qsfUqCvrO2iKE43WGS6KqNABrK0BJ1/P45VuA/9pSsZ8GpK3Nw9b0ZOjSQXI89j/kP7JwghFm7qqPvXEn1VYb0/YkORGrqL8xeOR3RUCpn/0kcBnAwy1qrNgPXpa61mcwVxo9m8otbHGB2bNhXcFcViqZCQZ7BE3aOy0JCKfdV2utDEakELwTNGyk7W5UTsweZC3B165zL5znF/pjO6jbewEmWNG4K2rPn0bEBK5qftmUMpAEzpYVerZhowJLLllE+xOKbsf9yldLo6amdgefDx+y46GwoL793DYf50ntcF/WmE46ccfBz8CQX9mbEevNIib1OAau7kgN29rFv6t25GhZtUQPDpn9Uy5AeyyBkCJ8jNP6+kpcrJPLwQO9qY3rUBTnplyVKCeAVpkOP19Ez8V2CQoVXW9Fr1pmeigiW/Ic9tVvmscCOcUYnkKA4ZKLbbNlD5ICoS+5lAUGaTZbQIcD+khbY0Azt32iPrgRAgNKmYal60xje2ME1KMQKfYHMTbhyt2p1/28f6HjGma6W1qatvPuj2+OGGojvu1NU1RvjWeI4zn3fSolW5OqhWJ+EnWa2YmR1jQLQTYR5eyetR8/agPBa9IO
 VGSGQsAT
 P2Akok1BW5kOUQN1Y0VAdAhAUVESlqT8rr0hQD8EPlqrDSN1uAjkZp805KIRTiRvhn4NwE7CWJWS8e7nA16NXQw4fP/8U9gwUkXQI9XAknK8cxJ5KNpFZPTmoDEMb9+j4hTQ0mkB67lT1ijCvtYtvwxYyuI3gFIUT2+MtbuVzv28aZ1R7j5KDwHZ8dD40ABnrPyTnYbLKXv0fE1wozBnD51DEg3uw430B5h4JqFbIAAI2X8Y1+McaqVRqTeuteWu/UJ6k27NZgFTwMDegpWq2tP+EMmo9XlJ+UEHCwCzmv6RCebAOCWsZKVM2z1MHidwPJzihbOaepqQHcQH/bFm3wrI+L9rGUQYiGaiYLR0XxUy+86XEGIJyuc4LIa1MIxRP9sJoxKW4VXKd7FDpJOBXKDpSnjWwlaypQq5/ykqPARnqgQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 02:17, Xin Zhao wrote:
> A coredump typically takes seconds or even longer to complete. If we
> happen to hold a write lock with flock just before triggering the
> coredump, that write lock will not be released during the entire coredump
> process. As a result, other processes attempting to acquire the same write
> lock may experience significant delays. Another typical scenario is that
> some custom management modules for shared memory also need to release the
> reference counts of the related buffers as soon as possible, rather than
> waiting until the coredump is complete.
> 
> Add a new bit(9) of coredump_filter to tag whether need to dump fd list.
> We set it by default because tools like systemd-coredump go through the
> fds. Some other coredump pipe programs like minicoredump do not use fds by
> default. If you are sure that your coredump backend does not use the fds,
> you can clear bit 9, which will allow some file resources without VMA
> references to be released earlier.
> 
> In fput(), check FP_DUMPCORE task flags to NOT release file by task work,
> otherwise file put operation will NOT execute util coredump finish.
> 
> Test Case One - flock
> Test program send signal SIGABRT to the program which owns the flock,
> output the wait time(unit ms) to successfully attach the flock.
> Test program malloc 500MB heap and memset it.
> If NOT set bit9 of coredump_filter, waitms is 11280.
> If set bit9 of coredump_filter, waitms is 0.
> 
> Test Case Two - ion buffer
> Test programs include ion buffer publisher and ion buffer subscriber.
> Ion buffer publisher output the ion buffer hold_time if the subscriber
> NOT send ack to publisher and NOT release it. The subscriber will trig
> coredump by itself in some time.
> If NOT set bit9 of subscriber coredump_filter, max hold_time is 19591ms.
> If set bit9 of subscriber coredump_filter, max hold_time is 320ms.
> 
> Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
> ---
> 
> Change in v6:
> - Fix operator precedence in PF_KTHREAD/PF_DUMPCORE check.
> 
> Change in v5:
> - Not add another bootargs for the feature,
>   as suggested by Christian Brauner and Lorenzo Stoakes.
>   Add bit9 of coredump_filter to tag whether need to dump fd list.
>   Set bit9 to 1 as default.
> - Al Viro, Christian Brauner and Lorenzo Stoakes point out so many
>   problems of the code related to umap that was added in v4, delete all of
>   it which is unnecessary. The management of reference counting for shared
>   memory generally does not need to be released through the release
>   operation of files that have VMA references. Traversing all the threads
>   within the process and executing exit_files() is sufficient.
> - Fulfill comments and commit log,
>   as suggested by Pedro Falcato and Lorenzo Stoakes.
> - Link to v5: https://lore.kernel.org/all/20260630075604.52533-1-jackzxcui1989@163.com/
> 
> Change in v4:
> - Christian pointed out that the coredump process will traverse file
>   descriptors (fd), so certain fds should not be closed by default.
>   Rework the whole feature, add /proc/<pid>/coredump_pre_exit for user
>   pre-exit resources selection, default is NOT pre-exit anything.
> - Mateusz suggested that walking the fd table and release the file-lock is
>   reasonable. No longer release all the fd(s). Based on user config, only
>   the flock fd(s) and the fd(s) correspondent to file-backed shared memory
>   will be released at most.
> - Link to v4: https://lore.kernel.org/all/20260624145552.70143-1-jackzxcui1989@163.com/
> 
> Change in v3:
> - Add comment and commit-log to explain why do the MMF_DUMP_MAPPED_SHARED
>   mm_flags_test() check, note that memory mapped files keep their own
>   separate references to the files. The case to work around is that early
>   unlocking a flock on a file allows other processes to lock and modify
>   the mapped data protected by the flock,
>   as suggested by Pedro Falcato.
> - Link to v3: https://lore.kernel.org/all/20260619122419.3954581-1-jackzxcui1989@163.com/
> 
> Change in v2:
> - Get rid of the implement of adding new fcntl API, the issue does not
>   worth inflicting the cost on everyone,
>   as suggested by Al Viro.
> - Call exit_files() in coredump_wait(),
>   as suggested by Eric W. Biederman.
>   Add MMF_DUMP_MAPPED_SHARED mm_flags_test() check to filter cases that
>   need to dump file-backed shared memory.
> - Link to v2: https://lore.kernel.org/lkml/20260618150301.3226517-1-jackzxcui1989@163.com/
> 
> v1:
> - Link to v1: https://lore.kernel.org/all/20260618030700.2511668-1-jackzxcui1989@163.com/
> ---
>  Documentation/filesystems/proc.rst | 14 ++++++++++++--
>  fs/coredump.c                      | 21 +++++++++++++++++++++
>  fs/file_table.c                    |  7 ++++++-
>  include/linux/mm_types.h           |  6 ++++--
>  4 files changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index db6167bef..d590a1dda 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
>    - (bit 6) hugetlb shared memory
>    - (bit 7) DAX private memory
>    - (bit 8) DAX shared memory
> +  - (bit 9) fd list

"The following 9 memory types are supported: ... fd list"

What?

-- 
Cheers,

David

