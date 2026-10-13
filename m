Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA745CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1C586B008C; Tue, 13 Oct 2026 11:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4706B0092; Tue, 13 Oct 2026 11:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31496B0095; Tue, 13 Oct 2026 11:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0606B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:03:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CB82160CEB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:03:56 +0000 (UTC)
X-FDA: 85317922872.06.C053F42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 671D7180017
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:03:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3tbE05i;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791903834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O462JKoBsK5kLKH34dERrDJEsMO/yC3R2yXeyHeFOP8=;
	b=7TuLQ0GLSenUd92zpBFJTIXCiPQzvJf+L/tSXZd51VsHccU0H74GowdSTELBsvLQ3uQ9mP
	0dQHsB8sjYUXO1YzcW8QAimX7aMZgLqZFlkiPzIBBvUsDGQDBy0gkPnG1OhtUSA7SsXLsU
	Zc/wvB4yyg4iDflX7CztRSl0a1e2c3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791903834;
	b=KGP2/0FTDMTg5ZYg90ci+UM8IKFcpFqBFsiHk/XpGLRXijm0D0EHy5bkOBLoTLatcTdvUL
	jziT8XZVrIRIiw4TE533MCUpk/YWG1p5WF2QUiZEiRymQ54x5uCCCxBTDr6jihQF1saIk/
	LgxOdEeM1BPbYfDDK8khgUiKA17M8uI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3tbE05i;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99AD0602C3;
	Tue, 13 Oct 2026 15:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5E11F000FF;
	Tue, 13 Oct 2026 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791903833;
	bh=O462JKoBsK5kLKH34dERrDJEsMO/yC3R2yXeyHeFOP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c3tbE05iKYpFIjUv3vFpzuL9h4/yEgBGEM5i1reN/FbqxAeXsuVwpeIOq4txsfuuK
	 L/2Y/bu3EIyLMAxykkKLBWoKNiT8Bartce+GFzHMpAXu7G3/4KUrt9zQYPLH8oI1WD
	 8D5gOuyyvRqhYouGpUemUyCzI7j1Owy1BHYPKwu+Lqygcime9usdgp5cWkdpLKQKSf
	 kfEgUL6/Mp4KhvPeaY4KjgHuOEMmFT/KVTdqESyqF/hHQXkrCQIeeNiRNq/vnaD5tL
	 5knxNXJcoIPv7KVhNVog/fqjxrmHuIyJ+6oYRwkOGz4ooeWxRUUr5fl2cJf2vEUfaK
	 9pTunqG3q7whg==
Date: Tue, 13 Oct 2026 16:03:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Stian Halseth <stian@itx.no>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Andreas Larsson <andreas@gaisler.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix lost maps entries above 2^63
Message-ID: <as5E25F4xjHwYSGQ@gremlin>
References: <20261011162019.922436-1-stian@itx.no>
 <e300f046-dcae-4539-bf89-92eb8c575e25@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e300f046-dcae-4539-bf89-92eb8c575e25@kernel.org>
X-Rspamd-Queue-Id: 671D7180017
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k9zes9515ypmjkmi717h4e5bc156u345
X-HE-Tag: 1791903834-844401
X-HE-Meta: U2FsdGVkX1/8pnq1UmWwtoYQfVAUT1K1wW8S/rwxJCvZpIC8v8aP2VVt6TPdCLyohzr9qRfNq6BGvG4LrvqwrjxcEGgxSKNHsW8YvAhO7nMBHo5TC7F5kdJLcVlZ1ieDpPImxi5BlGil0dafeoY/bv6OtTFL2a62Tk86bpdlwZvecn7SGsgd8B0vKCWx+tI8ZO4VfmOPvdupoOh2sD7W8Hs+DymrfqLlQRCMZ+bucqXPFflYicHhx6xzo6iyt1O77K/qcVB3jj1FwZg1ZgHUbxEVDj6J4Sw7Tp+fIZ+RmAy83PlP8Nxs10kWF4Vnzh5xcTyXpz52YaHf+tqV2zfGPIHd9/RQIzzK26z9xqFdrlPU6wDPmoYmDkble4h1ggxuicyODg3lu2XRY5/OovKT5LgDTU8yu71NHGGmxSLYwFXQlJlBVkCGKinWOTUphr9idTdfOIW2Tcp4AmZS4mWAth/2Vbizu6S44tMxi28VbV7SnZmS1XXRdgmwZZDwminprE+2nE/EwuSp+wpM07BSJdIeylhwEdJiYz2EXxlxwL1CZlxx9wYO/hwjXitNHeougHz8B0nJnkj/+14Lr45tYteyigB/c41YnTNTDBY893CtnGbNcJxS8Cqo8cTy7BAYEi2eG+td0AleOcZgoLD/tedSborey75X8uqnGKXYWrUTJlT6O8dgrwaafSLzXGqjL2QHO2AOaFzbljx3c92oFAWpEp8807OZSTd4/mUupb36jZ/Yv/bRWQdGJ9jMwYdvHtaTNFNT+eTRYFk6u9bSLpgJphOhgWEUHlwfv0RbI8aaauEvzP5eMzhZmMUlWXahr9NxAx6uHoRPpjncX0X3mQBYz6zeiVB7nu/Hq0ZdFpAHO/LhdLBv+T1oWV50qKmKSWPThDnowIBWX0PGUiKNpxTp40O3fIT6o9WjXqc+Fiuq4Nt5oGuvfZZZ/nzwDL6xwL7H5id0Ts+mPyxSPSL
 3ScUb7So
 ycjPMtm3X8P7QpPOZAE6W88oJUXZxYvgviaR6usGPRR19f57weidUhKwAxSo9tMPYFgYbpgNV4x/ZTWVA/c85/D5PS6bgDA2KeVIBOafPKbXE6y1m4/y7piTx6jkLLTRIn44it/++558sjNEi7zRDGrW5wErA6+ekertknY9CBSpO2JvR+0wv/NXVJdy9xybkwLq5ISSssBd6vf5MIRMoGbOIA4IRGf3pw0UHF0PJIAu8bit4TQbkLQmW/jYb9jew5nn/Am5r4rKZfOG5CR6wr9LqYNL+r98zsL/ugiGBqbakB+c/VIbpj0/VG6UX+DAuOvDwHN25v2MhE3qkBWwlXyczYt3FyNbsH9Xg60kPV0tw1w5T3IuZHCR9bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 04:40:43PM +0200, David Hildenbrand (Arm) wrote:
> On 10/11/26 18:20, Stian Halseth wrote:
> > When a read of /proc/pid/{maps,smaps,numa_maps} resumes, m_start()
> > rewinds *ppos to priv->last_pos so that the vma which did not fit into
> > the previous buffer is shown again. It only does so for last_addr > 0,
> > meaning to exclude the start of the file and SENTINEL_VMA_GATE, but
> > last_addr is a signed loff_t holding a vm_end. sparc64 maps shared
> > libraries, anonymous memory and the stack above 0x8000000000000000, so
> > the rewind does not happen there and one entry is lost at every read()
> > boundary.
> >
> > Reading the maps file of a process with read sizes from 64 to 8192
> > bytes in steps of 64 loses lines at 126 of the 128 sizes, smaps at 123
> > and numa_maps at 97, and the proc-maps-race selftest fails 4 of its 6
> > tests. Python's sys.remote_exec() reads maps with fgets() and fails
> > intermittently when it misses the libpython data mapping.
> >
> > Test for the two values that are not a vma end instead.
> >
> > Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
> > Closes: https://github.com/sparclinux/issues/issues/111
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Stian Halseth <stian@itx.no>
> > ---
> >
> > Notes:
> >     Tested on a SPARC T7-1 (sun4v, 7.3-rc5), a T4-1 (7.2.9) and a Sun Fire
> >     V240 (sun4u, 7.3-rc5): no lost lines at any read size afterwards, and
> >     Python's sys.remote_exec() test passes 20/20. On an amd64 KVM guest maps,
> >     smaps, numa_maps and the proc selftests are unchanged.
> >
> >  fs/proc/task_mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 5c54aebe21182..cdce513edcb1d 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -339,7 +339,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> >  	 * Reset current position if last_addr was set before
> >  	 * and it's not a sentinel.

It's interesting that this comment differs from the actual code :)

> >  	 */
> > -	if (last_addr > 0)
> > +	if (last_addr && last_addr != SENTINEL_VMA_GATE)
> >  		*ppos = last_addr = priv->last_pos;
> >  	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
> >  	hold_task_mempolicy(priv);
>
> I hope Suren can review as well.

Yes Suren should take a look.

>
> Would it be cleaner to reject any special values, that is, SENTINEL_VMA_END and
> SENTINEL_VMA_GATE?
>
> That would match the comment and the previous code idea: exclude only 0 and
> sentinels.
>
> Could consider a simple addr_is_sentinel() helper.

Yeah that seems sensible.

I guess Stian should respin with something like that?

--
Cheers, Lorenzo

