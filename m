Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB22CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534B26B0088; Tue, 13 Oct 2026 11:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4E66B00BD; Tue, 13 Oct 2026 11:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4223D6B00BF; Tue, 13 Oct 2026 11:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 216E46B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:28:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0AA2140CBA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:28:45 +0000 (UTC)
X-FDA: 85317985410.07.240CE15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2B1A14000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:28:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwTOQBRG;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905324;
	b=PFZQi4eWoDnjk38BkjO7yiqQGsBkk8KbQ37sbPE01akx0Z6EUwRzd8J/GNLpw3/yN71Nuz
	1KpTqasacLGCY0U/IRZmTIh6fcbj3j7hWl5driorsy5cGi/fu44JuY/vToeJ5p5xiY4q6P
	tgglKGhD9d0M8yV4vdDrEW6onuMThHc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwTOQBRG;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpQaXQHsfNbA2Umv0Rjna/4DmJUX1U/rU1Wpq5ut3+g=;
	b=IfEadQjy+12cSWTlSE2DoMHRS9GSdWBuZsGjslOetBHdXFkVJTvH0X12r0pBOBSWP3aRbm
	sFRnl6WiSSvhRIg3lA/Lwl67Tqk1fP3PtE3hV0bRpXsKI0ZwgH0mTwwCIq54uicTMc6e2e
	xE557fNe/qf9Izpsg3xJVg1mHcoonTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4191D42DB3;
	Tue, 13 Oct 2026 15:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7671F000FF;
	Tue, 13 Oct 2026 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905323;
	bh=rpQaXQHsfNbA2Umv0Rjna/4DmJUX1U/rU1Wpq5ut3+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MwTOQBRGVY7W2Yhfo7LL1mQkXqfrGrnudQPxAzNuEe5IMwWPmMK1eSwbS2QClo3zR
	 TU3e5hgcgXuasBi2Ib1HD5PBnPIrxAzkYHQcTH45QV5qSQr9cfA2d9QmYrOx4rF2cQ
	 xvBx/aHYTlqC52w/i7gB8l31YNz0ODhtp2srIp5DS4xKFAS7I1lr4szn8EUiGaCJXU
	 PmACM5psGRfyjW84bvScwf91VQAWTQ6ajf8hmsoiLLEoj3rYkfbbrytClpq1OtOQbt
	 iW/26OxYS0u36xmtz1iGPaftKJIS8pftvkSe07OMW8bzBX71mciLCppKOZdyINpEN2
	 Ed9NGlN8s/XIA==
Date: Tue, 13 Oct 2026 16:28:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Andreas Larsson <andreas@gaisler.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fs/proc/task_mmu: fix lost maps entries above 2^63
Message-ID: <as5M1BSWcPDHjEWt@gremlin>
References: <20261013152106.1834364-1-stian@itx.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013152106.1834364-1-stian@itx.no>
X-Stat-Signature: rzs37cnis5rtsknf33xjerjx8fhia3qd
X-Rspamd-Queue-Id: F2B1A14000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791905323-915206
X-HE-Meta: U2FsdGVkX19Jc0/9h1bthBMuhUnvNPlci2LBIeuh/+uD8ebrOxD35GO5znmiTHWDDMU252XZhXz2Z0wFPA0kfHx2Qd99IX7EI4aqypIjJK6tlf8FyHlS/Ks60ZMl+08wA8Hel/3/gWM7KXUmOJPD1mqiFHjqCwKi/LB1w6JYBhecslmwqoy/k6yT+FKZG7VYQI6w3Eox+1BPhGntpNCbR8iYIhkZ6XZcquO2xovF0/SlkMzJuAKtiIQTj4RTtGQJS/JGWf1G9YG0v6DZbhhX0A0mlXBJeyaaFzmTR7BHIHSWDD2GXkuqsKQ3mw/ptU0acyL6yorl2bjhXr2qdtTqSW6NZl2vfx0Yh+JiJYoysuzl2XAwT1AFwCyp4EE4TmwYMEG4kxQZxZ5Tn82U95uCBgChDjswvXOfxEKGp4IhbzE3G03ktovyWtyB5DsMqUWR0hmFIw5BXW1gfbWv5k2Xq9M40225C7QBZe83pQUeDhCmTz1vnEIzzAsF3jijWv5pp1RH6IdXdiZ5NOkev903TRtdjoO3IiMBnVd8zQH8X7Mb3grkxtrw8sKAP6elsGMfbc+13A6aUbeHXiuSqVDnV4DjC72BEBSCd8Drg9J8W+b9Mt2I3UtxpwM/D/cMp57iJZeRWAQYwlF0k8wJTGc4jxX83VBEp+hGA5fsepqE/8uMYDilZ6W70FyU/0Y3MXaDQgnHS8GEBif7kLFYxT4vGkndQTtZkhT5SgLXyJYt8pUwLGOEkIoxbC2IwlvkE1iQXGXgC12rMvUhRq9FfGIRyludM7e/stOjdMRuq8DIjfUafLwxgdfrBpQXKYyc0fqW2UFRXVjrePMIrhrOt322D2j0j+xumeIsNcm3Uuz3RPIHwGYZeccGDmbxVwUwYGF0uedphC/ToUJjyDhde4AOE11iXsAZD1aufVj7eIlkwQHdyV9JhNfjy3AAFjKU7Gaaxfj3C+NKNMkQtdP8nJe
 IT5J/45i
 QKfnizlS3+f/a45/dxtcW4fcIWPhLabi/11lTffiz/5hZcL151zLVB0Nx1tKmor9NxPDwNqkWp+Ui0wUwWlfp7ge24cZGmBvyub0Xv56alwXAkkCrkRa0/dV9f3x+FWNWniV0iPEAlXfFR21t31NihtZQoNnNyWUGUfbWs8RSp2zP4jFCBcjIKihKVFEpNHaELXkdKTpsZYPzD8WpyJmdCbb23Dt7yqTo2ldnOSzmhOagrkK8fR21oxjDTl3JPqkvTaPE9rP59K7qCnaOn8z2zf1gEvImplaau13H+p/MtRCT7kS5c4gCxWmb/Sydo0QLMHxfFvigxoXBc+X9xHpik4ESwWzJ41wLJybAFM3yChPLWM26Y+tPdmU/Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 05:21:06PM +0200, Stian Halseth wrote:
> When a read of /proc/pid/{maps,smaps,numa_maps} resumes, m_start()
> rewinds *ppos to priv->last_pos so that the vma which did not fit into
> the previous buffer is shown again. It only does so for last_addr > 0,
                                     ^
This could do with a newline between paragraphs.

> meaning to exclude the start of the file and SENTINEL_VMA_GATE, but
> last_addr is a signed loff_t holding a vm_end. sparc64 maps shared
                                                ^
                                          Here too.

> libraries, anonymous memory and the stack above 0x8000000000000000, so
> the rewind does not happen there and one entry is lost at every read()
> boundary.
>
> Reading the maps file of a process with read sizes from 64 to 8192
> bytes in steps of 64 loses lines at 126 of the 128 sizes, smaps at 123
> and numa_maps at 97, and the proc-maps-race selftest fails 4 of its 6
> tests. Python's sys.remote_exec() reads maps with fgets() and fails
> intermittently when it misses the libpython data mapping.

These numbers are hard to understand it's like playing numberwang a little
bit ;)

It'd be good to simplify this by saying something like 'testing revealed
that lines are not correctly read from /proc/$pid/[maps, smaps, numa_maps]
etc.' or at least something that's a little more readable.

>
> Skip the rewind only for 0 and the two sentinels instead, with an
> addr_is_sentinel() helper.
>
> Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
> Closes: https://github.com/sparclinux/issues/issues/111
> Cc: stable@vger.kernel.org
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Stian Halseth <stian@itx.no>

Please stop respinning so fast thanks :)

We generally want a ~week between respins for newer contributors. At least
a day.

5 minutes is a bit much...

This looks reasonable to me, but I want Suren to have a closer look.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 5c54aebe21182..24c2a5079f080 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c

> @@ -339,7 +344,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	 * Reset current position if last_addr was set before
>  	 * and it's not a sentinel.
>  	 */
> -	if (last_addr > 0)
> +	if (last_addr && !addr_is_sentinel(last_addr))

I think last_addr > 0 was fine, but it's not really a big deal.

--
Cheers, Lorenzo

