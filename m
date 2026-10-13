Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8B6CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 14:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773916B0092; Tue, 13 Oct 2026 10:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723AA6B0096; Tue, 13 Oct 2026 10:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB6A6B0098; Tue, 13 Oct 2026 10:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDFE6B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:40:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD8D840D39
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:40:53 +0000 (UTC)
X-FDA: 85317864786.28.F588F5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D14401C0005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:40:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E3dxMwqL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791902451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMF/X4p2JMQOAWL5F8hcgnR0xRgqfvQmfw3SYOWs+Bc=;
	b=eIw0lxL8vL0vaiZsJUDb4/2wzy8P0YwWH9mWX5pEyWgwc1H/ShZe4FJ9IAPY95VM/V+CIt
	6TYAMrbeF2lHMC2NFiga4DNskrUAKLR4zuiX7PqkNnZGOWLgHFVER/CxE2uRHsypTcJC56
	198SY5kd6C2x9inMpH64Ls5wAHMgX5M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E3dxMwqL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791902452;
	b=7mmKFsI7qbUnxLtA6zSw9dpoRfgdodbAJSnQknTjIUISKLjDh0kxtStwHP1CFL9hLLMCIk
	HG8DxNu2HrZI9Gj+QtRlBnFDuX1ye+0+0zSZURwMsU9J1jsUjThkJ7Q7RcyChTGvYoUBxY
	KfzdNUITMEMGQY4MrbwneJcdnu70xQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75EF860A5F;
	Tue, 13 Oct 2026 14:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FB81F000FF;
	Tue, 13 Oct 2026 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902450;
	bh=JMF/X4p2JMQOAWL5F8hcgnR0xRgqfvQmfw3SYOWs+Bc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E3dxMwqLMttYe0HqZS0dZWPQZ5GG3zyuI0bjf3NPCgljWbcwXvEdkz5wNfUKIR9uO
	 zrID0Xq18gpwNsFxSeaTpXMu8IwYvTbAvA58g/QChfUKY8hGkNGiN4cQV5qWD6opX+
	 czt4bQbb2TFIbQ+a7fGK/AISz3uh4NW3NwTCV79PSHfDdS+t6BHS/IGf34Y/d5KAns
	 M3gTuKmkeJop2tA3nk1lKWpdnTe5rxUBYy9KSRVGqkiyJWnz1hBMENfuevLW/x8W+N
	 dnMl3rvQi04aFvYZ475GaDry7zGNs8sGWJ6xqhJ3Olx/m16Qsr2Sf2cBNTLEwlys6f
	 Ia9OFnVh7q93g==
Message-ID: <e300f046-dcae-4539-bf89-92eb8c575e25@kernel.org>
Date: Tue, 13 Oct 2026 16:40:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: fix lost maps entries above 2^63
To: Stian Halseth <stian@itx.no>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Andreas Larsson <andreas@gaisler.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261011162019.922436-1-stian@itx.no>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261011162019.922436-1-stian@itx.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D14401C0005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: i77b3pp7u1wo6euijcqjsbcpi44kyfx3
X-HE-Tag: 1791902451-332230
X-HE-Meta: U2FsdGVkX1/t2K6woxDrKiE8rzwa8yNKGtVMWnBE4kidrhMBE6U1OZ8dLkY4cgMRcrYC0QN1zw5CzkFC6vL18oLT5ygDOu46n3r8UfvT+6m80lR8WiiQiHZ24kAZnJoXQfl6+9wMshjbL5drzsFZkvzZJXDlvmFgqAheGR9vrJFq0F5c5dk4flUD+PHugyvvXx8CvSpPh7T0IuBxNLbKo69GtfLw1Inz55MKdTGKj+iaFgYj44fQ/5u2Ufbhu4osDKAwDqDMKODuiRQ98H2H0rq0s1W9Bz/Gh1gLaQE5AhAmYLqkVyVrrF3B91cC7yC9zn//TyW+b+dbPxDQxPKAcN0fSFGQgda1hMr47oOaMSZ0s4rUq0Ej3K2yaly+W658u85l9HQhO6oqffwYMpCCutNo4YqkaqDV7zxRs8cNS8qo/a0n5umqTqBibuGDWYzc/0pMTeXHM2sOhPruxWB9aQD9Url7jrF/AMFo+ERmZorALJpd0Nt9z5PUu3LA/V90evOX6GsVzYOgVvCXv+wAV8RLF45g+jg9hVJdGp9lCl2LsARlS9HA0wiDUZucd+q60bDu+sMxXPl1QDtRhh7PcZ+IQ9hEYG2z5AKlX6ShhWN9/yTw/b1U2lRoEiYdvsDqn1lEl5x3TqYMuKSTiBeoIiUnOFcSmSPXYy0/czHVATSXORIV1eKdwmr4/p3QLo/pXVptP6i61K4tHT35nLY+moU/EXHk2nw8m6xhU36sa0q/ccJKGW2B3zfke5Sgj8pMgl6qtJfFq25KtWw1mv/VEf7zDmNRCUNgCEK3Ykgf3Ox90dZ77lC1c7sXjuJIb1qZjlc7mvBt6RKVhxxDo9ofV6aS9Gwj6QgMJvzIU01LX8DEv6THPNDlExpOOiHTcK25nz0qudWt1bYhHkYBB1BhevmIpxwPD3V8+xj3cAXI0Uuqni+xDPpYJIHHRRDxX+Sv5K+stcR7NJf20alavGD
 vZO26fxG
 jg7jCk37zLRb2D9BYTOd5gfFZMhvJy6TMfmmzy6ekCKMaRoFfOF1ZSckD440t0CBTOCXSL0bLx9Fa/wep2s3Mw2Y7I65M7MLWjl7PVHhCvGLF824Ld+06JhB89y0YOrE/yDpF2WLVTBX8zPK15YGLWdKZvdZEwN3GD+47CmDUVXlnFG2EA3NCxLX0y1txq7eEFLBTgiKlwr44U8WqAMBE/PHLI+giTQNPY/o6APsaReqlTMwj5V33u2QCwKPswEMkPxG82jntB8EwaKRkFaW6aL0mkn6aWV3eWOEEJOETxMPE6n7rcokueB4dUcaAtqDQLXfEnyrGe2GYJUpM77CsOMeqDH38U5g/SxPdw7053ZxW5bzHxQyQa+ejUqQ/fWXiLKOo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/26 18:20, Stian Halseth wrote:
> When a read of /proc/pid/{maps,smaps,numa_maps} resumes, m_start()
> rewinds *ppos to priv->last_pos so that the vma which did not fit into
> the previous buffer is shown again. It only does so for last_addr > 0,
> meaning to exclude the start of the file and SENTINEL_VMA_GATE, but
> last_addr is a signed loff_t holding a vm_end. sparc64 maps shared
> libraries, anonymous memory and the stack above 0x8000000000000000, so
> the rewind does not happen there and one entry is lost at every read()
> boundary.
> 
> Reading the maps file of a process with read sizes from 64 to 8192
> bytes in steps of 64 loses lines at 126 of the 128 sizes, smaps at 123
> and numa_maps at 97, and the proc-maps-race selftest fails 4 of its 6
> tests. Python's sys.remote_exec() reads maps with fgets() and fails
> intermittently when it misses the libpython data mapping.
> 
> Test for the two values that are not a vma end instead.
> 
> Fixes: 5631da56c9a87 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
> Closes: https://github.com/sparclinux/issues/issues/111
> Cc: stable@vger.kernel.org
> Signed-off-by: Stian Halseth <stian@itx.no>
> ---
> 
> Notes:
>     Tested on a SPARC T7-1 (sun4v, 7.3-rc5), a T4-1 (7.2.9) and a Sun Fire
>     V240 (sun4u, 7.3-rc5): no lost lines at any read size afterwards, and
>     Python's sys.remote_exec() test passes 20/20. On an amd64 KVM guest maps,
>     smaps, numa_maps and the proc selftests are unchanged.
> 
>  fs/proc/task_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 5c54aebe21182..cdce513edcb1d 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -339,7 +339,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	 * Reset current position if last_addr was set before
>  	 * and it's not a sentinel.
>  	 */
> -	if (last_addr > 0)
> +	if (last_addr && last_addr != SENTINEL_VMA_GATE)
>  		*ppos = last_addr = priv->last_pos;
>  	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
>  	hold_task_mempolicy(priv);

I hope Suren can review as well.

Would it be cleaner to reject any special values, that is, SENTINEL_VMA_END and
SENTINEL_VMA_GATE?

That would match the comment and the previous code idea: exclude only 0 and
sentinels.

Could consider a simple addr_is_sentinel() helper.

-- 
Cheers,

David

