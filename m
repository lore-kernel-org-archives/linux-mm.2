Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244EACD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2AD6B0005; Mon, 18 May 2026 07:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393E06B0088; Mon, 18 May 2026 07:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282726B008C; Mon, 18 May 2026 07:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17C536B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:52:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A79161208DD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:52:39 +0000 (UTC)
X-FDA: 84780378438.04.F7570DC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4CE5D18000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:52:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ce7RpLEr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZjGzMN3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ce7RpLEr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZjGzMN3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779105157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04M/+O0JITx85kpF3ZIDQqZ/0fzW3SP3af9yns+yu7M=;
	b=lFLnR9MoTGMduwwo3+GKTgJoRsYVMTQPL4I0EjEvs7kMY1D7GXRGVvAy2on3zHbaK8+jk/
	QIamwQqzqwrvsN2El245uhakuFKgC+zkwWnvs0dPQUZrrZL1n2feItVckMrqcO0vCTbYjt
	htkOREgp/W4bhpm/t5i2roGaIm4U1IU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779105157; a=rsa-sha256;
	cv=none;
	b=8jBfgccj0O+qgrDd6/DxG59cVhiQSbwuQg6VymgGdZ8l8u8pvKK4Gb9ML+taTxL39aWT/F
	J1w21VA/Qe/GdLFMyR9+i59k5gMjTC1wReNb0iWFD/rirO6IESRhpg7qXu0M/HC1OVaD3p
	wF5LYpkbAoh+n8XIdvAM4JpOrJ4Nrsw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ce7RpLEr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZjGzMN3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ce7RpLEr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZjGzMN3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3DAD5C8EE;
	Mon, 18 May 2026 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779105155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=04M/+O0JITx85kpF3ZIDQqZ/0fzW3SP3af9yns+yu7M=;
	b=Ce7RpLEr+K4Ce0efs1BZPONzJ2Vx6Uh6jxgbtlw4H2ESFQCLoF6IGCpW3fP4FEn9F5mWaV
	YoFzcqEMCG+lPT0mOosCPoHRR8dHTaAGrjwjWL2/Ef4ECEPkqfEAVhHj60BUXDdrTwjLjX
	NEinJ15kAUs441BoKyukU6RPex1cLiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779105155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=04M/+O0JITx85kpF3ZIDQqZ/0fzW3SP3af9yns+yu7M=;
	b=XZjGzMN3NZn5eWCwJ727QlHeuapnpjdU6juC5fRoAZdozpxIUEQPYl5ePHxFk40yjxlPd9
	n0rvqUUJJBxtPvAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779105155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=04M/+O0JITx85kpF3ZIDQqZ/0fzW3SP3af9yns+yu7M=;
	b=Ce7RpLEr+K4Ce0efs1BZPONzJ2Vx6Uh6jxgbtlw4H2ESFQCLoF6IGCpW3fP4FEn9F5mWaV
	YoFzcqEMCG+lPT0mOosCPoHRR8dHTaAGrjwjWL2/Ef4ECEPkqfEAVhHj60BUXDdrTwjLjX
	NEinJ15kAUs441BoKyukU6RPex1cLiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779105155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=04M/+O0JITx85kpF3ZIDQqZ/0fzW3SP3af9yns+yu7M=;
	b=XZjGzMN3NZn5eWCwJ727QlHeuapnpjdU6juC5fRoAZdozpxIUEQPYl5ePHxFk40yjxlPd9
	n0rvqUUJJBxtPvAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D775593A8;
	Mon, 18 May 2026 11:52:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pt/kIYP9CmrsbgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 18 May 2026 11:52:35 +0000
Date: Mon, 18 May 2026 13:52:34 +0200
From: Pedro Falcato <pfalcato@suse.de>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH RFC 0/8] mm/slab: enable runtime sheaves tuning
Message-ID: <agr8Nzr8rnDBTuVX@pedro-suse>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4CE5D18000A
X-Stat-Signature: 6g6gx8p86zkuh1ioux9ti7bb95xt9rrj
X-Rspam-User: 
X-HE-Tag: 1779105157-503566
X-HE-Meta: U2FsdGVkX1+K7n/iLKbOWjRJNhng8OMBZGv+rBtBsNHDJUs/qV3PZEX9tuAScrx/ihM/s/YkcGURnY4yuQ+xK3tiKMViGBV8Pc3T1H9qW2FgXoXdqnLkC4JG6nWgKT1OemGwmzKsT+OB7R3lA8RsVBYEj0hTF/X8L/0t/ssl4kPDJX10VN4H3nG+yE777byPtOCB5MLSK32iqjNcfCPBepJfG+1MmZzR8Fa1oUTRS2mkOCAuHZ5fRpvVemCl6jBqxKd0hFLLLX3CMdassG5OMuCBK6tFYJnQEU8lJU1MQMgKZ9+2/x3AwKwyL7Yh0pyfU/5Qjek4ZnayXGASKpEGcBPHVj5rBj1AznMOl4xVFBecO9f8jQnsj6LA5HLBY6AcpvQdXm0JofB1BPRBQupcsNRfRMT+Rf82pm9MgenaX4RRE9tZnK2W1uve6HFL6WC3ZNf2lpGRks3BKPCxcQ3HVyeCgLu4oIoeTfwIbI5uBYZfiySDFP/FJQ8j421hUC7TFGyL+lJVJ/JY8StbN8cbwhf3mX5VhNrYKrCrKBuzAAtONDRAoChUCaVR9mgxX+A+MS3DnDuKDAPNE+as6rqDiEKbqN9bFmp0D0oaGqq3SqMd2uROoAMqRQjiqlmcoFblLnl1LEddxQTqUVJjYv/uw+WC6szl8dda+xxri31HMyl5nV4hq1ctE4XHZKklqTKAdDzWQF2AaWPMW03S9adEwD47yh+wU4iMIuxfZ8OeR/ReTp25T6KvLiVRhFvowiQihHxqzir6Ixd8v/rB6LbjYN7DCuOUDPbepGChTTfuExbGJe1FToL75SKJVA0EKIkqIWENP8LLbxoCbVh2haZ/tMyAZZjalOsbeHEBi8rGGsGt6DNqr4ATlK/T4eZsyrQfBbBsm08E04PBMaNSQcuH6iCd4L9CSgtwH/65rlWLznYh3ncowtJXoLewCUI/wqN8pH7ffjXDrzMRvTo4Jtn
 6XYntHYW
 Ug9mqgBSrlCOHLsvqUi/1xKcGqb1rf0BJ8sar3yUV+aoQT7HLyhMRuvi2ioLY/oLRr7OIRRdK2DM0Jew9oWvU5O/xxB/XRXzVBfVixKNk0yopgDExrWzbOsX8roUzPnle2H4VY6KwPdS80gZeHR5wKBv7SDWoo2z/ppT5+mliVMiTrF4qC3QV48eNdMoln+E/apOeevElK5mM7Zb37UaJgJU6MsU3jM4paBvPzbzgIVIBeBQACxunD61bE3+wV2zcopZYJmPiPdQj6qaYKiUel+WVrjZspRs8wnuofbvHS/oLi50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 01:24:24AM +0900, Harry Yoo (Oracle) wrote:
> Background
> ==========
> 
> Sheaves were introduced in v6.18, and starting from v7.0, they are
> enabled for all slab caches (except for kmem_cache{,_node}). In the
> pre-sheaves era, there was a cpu_partial parameter to tune the number
> of objects cached per CPU. However, sheaves don't have an equivalent
> and the sheaf capacity is determined in the kernel code.

What semantic do you need from this?

> 
> The goal is to allow tuning sheaves at runtime by the next LTS.
> 
> Overview
> ========
> 
> This patchset does two main things:
> 
>   1. Make the sheaf_capacity sysfs attribute writable so that the number
>      of objects cached per CPU can be changed at runtime, and
> 
>   2. Expose MAX_FULL_SHEAVES and MAX_EMPTY_SHEAVES as sysfs attributes
>      rather than constants, so that users can tune them.
> 
> Measuring the performance impact of these tunables is TBD.
> 
> Roughly, the sequence to change sheaf_capacity is as follows:
> 
>   1. Disable sheaves. Make all online CPUs replace their main sheaves
>      with the bootstrap sheaf under local_lock and wait for completion.

This is extremely destabilizing performance-wise, were I to guess.

> 
>   2. Wait for all in-flight RCU callbacks to be processed.

and this too.

>   
>   3. Flush and free all existing sheaves.
> 
>   4. Re-enable sheaves with a new capacity.
> 
> Challenges
> ==========
> 
> 1. Allocations and frees can happen concurrently at any point between
>    these steps, and we cannot introduce heavyweight synchronization
>    mechanisms on the fastpath.
> 
> 2. Currently, cache_has_sheaves() checks whether a cache has sheaves.
>    This works now because sheaves cannot be enabled or disabled once
>    the cache is created.
> 
>    The question "Does this cache has sheaves?" should be split into
>    "Does this cache support sheaves?" and "Does this CPU actually has
>     sheaves enabled right now?".
> 
> 3. Once the sheaf capacity update is complete, no sheaf with stale
>    capacity must remain.

Why? I don't see a huge problem with having multiple sheaves with different
capacities, as long as you adequately, opportunistically kill the sheaves
if they don't have the desired size (say, once a sheaf is fully empty).

-- 
Pedro

