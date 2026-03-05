Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E7EEEF320
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188FD6B0088; Thu,  5 Mar 2026 03:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1373C6B0089; Thu,  5 Mar 2026 03:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018CA6B008A; Thu,  5 Mar 2026 03:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4D956B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:30:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94C5B160866
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:30:39 +0000 (UTC)
X-FDA: 84511338198.23.76E358B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A1E0C0010
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:30:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+6pE2pM;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772699438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQh/uxdYRJuasUsr11rILvKcyQps57qG8/msfSLncZg=;
	b=M+MLSJVsVlyKTSXYQ40tLPuLVPkphS1gL/VIdQJfO+Onkx3oOyivBI1bkBAVB5Mli2rW/h
	TElnY1hu7oQfemz49LkPdWlMIFWPp8n4F7pl/0T519wSb8kVWN4plW/G51ISaO1BivoqVy
	EIFPg3XDS4S1/Y3kCrRmgVV1JB4G7wY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772699438; a=rsa-sha256;
	cv=none;
	b=624P1RJb/bu7TJcgpaRiwqRp+qPEnY7l/VGjRHxASLbJZIB67X1PjIB46r4SQ2DXoCcIT3
	EHga5NlkDG0oroYRrWFl+VNYpR54B6zC38Lk2gZUOYUIXpER35XTik8WhQ43oyjFzQHhS+
	8OHmoU6hHfXMyA8+sMU5deRulYS9hz0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+6pE2pM;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FEA261339;
	Thu,  5 Mar 2026 08:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B27C116C6;
	Thu,  5 Mar 2026 08:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772699437;
	bh=IyyJMi7zPwn5aDcvOkYvk2n/48jPMfx+VyvC/C5ynGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L+6pE2pMJ8eA/sgIrVOnNXfzfmGrnCAf9YRW/w3MFdSoxh0qseE/ROGlo4PanvJf7
	 WzhVLQ0CA6FEYFDoFKOv+W17RHOvtGBEgUsjEuZhfH11Sa7Gt3YuUwc1QSg4C2v/+U
	 +wdU5Dfb3L17RoNi+8WWFkLYDJHOaa7oLfbOdMTR3gsiepGviK+VNLOCqo0VZCXvQq
	 JPLoJ4uIvi0Rjq+c6nlPR0RTDMwPanwmKJDQKyl8bnb84Nll6FfiWeqpLdY/o3URLo
	 26mivd0iDu+XZ67R4QhUFijMbgAcX69YcGAkJauoS2So1AcINF0T9gcINiCviXpcLm
	 vmepa4yQh15Yw==
Date: Thu, 5 Mar 2026 08:30:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add mm-related procfs files to MM sections
Message-ID: <2cb16db9-75c8-4df6-b4e9-ea2a8b260d1b@lucifer.local>
References: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
X-Rspam-User: 
X-Stat-Signature: n6cynrhw6uaf18b56xy764qwz7wkad7j
X-Rspamd-Queue-Id: 3A1E0C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772699438-83012
X-HE-Meta: U2FsdGVkX1860mJYhkMuXUA4nL+foTECjcdMhIU5BOb3qcW4ZHjQfT0mKwHvgBEwynlygbF9cH3bnfJqJW5aOIChD5d1w2Xv1Dzyx4J//0kI8MA5RZkESM3Sp5csOYHHKG8zTbO55wtkI8w+5U+t2p7meXuDwIQL1S460xqMNIo1INEOaLM5mW+Pm2CmPnFELE0i742gBaVVsc04SLt8gcuMgxm/HKPztni/nIewpLr6Ps+HuOq/7Jlg3sdLCoO4v7TLdSGuz1SpBm1+ltLTxHdGH1tzmCLvzVdNvLC2IV5HwfE6iufsV7+rsbemB84zRrJ9KopgoLfl3CJbTbIvWSlyFqKHQb2vCPcZ/ybMHDoTMMI1RWHM7L8pxfiMIbc3MdFpYazEeyfclfxt8Wil13Agnc5XS/nxP+GxOB5v33E9Wi1jm6u3c/QpTi6w1InmzDg1QDfD5H85oiDrLdtnKVT1VLZrzZAmFh8WOO0rF52zVA70VrxMOHZPK0rT9FMXjvDi9j6Q51bbjMWR+use1f+G3UGG2ZgPVuNQtYXGXpfZnJyN9PddylU3NjoNgzjPVDIHl/52iYKLls1K1+5SvqnPZIST+YzPxgSk/8XHxrAIk0FLO8wvZPTUd9SiQjezkPUimBajihCC1rZKpvdPI8rLp0ejl8YMsCnkKGCmcw6TG4YhYJ43VHql3AJ46zn+8THAW4XVMwR/iO1K5My9SRixMsWE4tUDdzcMxM7ayz0O9zhDD7tvdQKlXoL7fBQTv8OULJr9x9I/140XTUZaVjH8dtkajmETH47y9vfHyIU0XKQcW0lAPnFvjtLH10weM2m54O1Y0rY/Hp2GoktYKv+DujnxlaxptP71b+1IHK4JV7D5bWO4na6c+KO+jx4pxWQCLY6RIsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 09:26:29AM +0100, Vlastimil Babka (SUSE) wrote:
> Some procfs files are very much related to memory management so let's
> have MAINTAINERS reflect that.
>
> Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.
>
> Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3553554019e8..39987895bcfc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16683,6 +16683,7 @@ F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
>  F:	include/trace/events/zone_lock.h
> +F:	fs/proc/meminfo.c
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> @@ -16998,6 +16999,8 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/trace/events/mmap.h
> +F:	fs/proc/task_mmu.c
> +F:	fs/proc/task_nommu.c
>  F:	mm/interval_tree.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>
> ---
> base-commit: 7fcd8889fbf318409163ff5033fe161dd2a73243
> change-id: 20260305-maintainers-proc-30e45ca9e434
>
> Best regards,
> --
> Vlastimil Babka (SUSE) <vbabka@kernel.org>
>

