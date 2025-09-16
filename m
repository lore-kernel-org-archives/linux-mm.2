Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E90CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924988E0015; Tue, 16 Sep 2025 05:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4378E0001; Tue, 16 Sep 2025 05:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6AA8E0015; Tue, 16 Sep 2025 05:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 658AB8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:45:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1648E11B0B7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:45:53 +0000 (UTC)
X-FDA: 83894631786.11.E6F0BC2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7AA3160004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:45:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K65Bx6sn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="s+q/lPMQ";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K65Bx6sn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="s+q/lPMQ";
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758015951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oCU9M02aU9Dmr9fi7iWYb6ulEbsfk24rHf2PZ4f6ns=;
	b=uWvLdtqEb/dpDxgcpzyavVHsaxxHaxyLiTL22/mZBOBA8WUkb+BLtka9KnyHzS5NJ4SJVn
	IGgaE62A8ICr5c0M3l55ghH9ULqRqujzooAgU95Hr7hxg4kx1hDagJBXIGEODiY9+4RgRI
	yd50Ql50WaPTevR8dzY0Mo79GH6m0Ns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758015951; a=rsa-sha256;
	cv=none;
	b=Hon7Q9pyd942Rs/7RdSnyNt+8aWCtng72IlVnFqDRqVyijw5zERRl6SXwzF+v0yBBDAiOp
	7WbjcPglMOmAqRavcPAVoIZNh4dh0M9VJpxAH9aQpbUDzdQ1XinZajokCqQXI4dLcpde0l
	VPgJq/6qsbd3uUkK6k99VQOfT/FSRyg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K65Bx6sn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="s+q/lPMQ";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=K65Bx6sn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="s+q/lPMQ";
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0F0EB229B4;
	Tue, 16 Sep 2025 09:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758015949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5oCU9M02aU9Dmr9fi7iWYb6ulEbsfk24rHf2PZ4f6ns=;
	b=K65Bx6snDj8aGtx3uk0hpU3UuFWQxNh+kSu5kW/d2PmF+YMm4doF3EzSukzv8G9tmKlzZp
	kS5nzKgodqpGpgFJSnAWtM0G+vKj5jkmuZ7Ie9X27H4PQMZajeY8Hr6dxA+h64/0+rDYZf
	9dTXxaLMPUEikbSt/5CA1b4wThkhBS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758015949;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5oCU9M02aU9Dmr9fi7iWYb6ulEbsfk24rHf2PZ4f6ns=;
	b=s+q/lPMQNDvYqbcNUv9cxVllj/4LZhw7lsUjq9p3o5Wdr3t8BlyJ2hTD5O0Nj+LW6Loki3
	doMwA+VJdxT/bvBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758015949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5oCU9M02aU9Dmr9fi7iWYb6ulEbsfk24rHf2PZ4f6ns=;
	b=K65Bx6snDj8aGtx3uk0hpU3UuFWQxNh+kSu5kW/d2PmF+YMm4doF3EzSukzv8G9tmKlzZp
	kS5nzKgodqpGpgFJSnAWtM0G+vKj5jkmuZ7Ie9X27H4PQMZajeY8Hr6dxA+h64/0+rDYZf
	9dTXxaLMPUEikbSt/5CA1b4wThkhBS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758015949;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5oCU9M02aU9Dmr9fi7iWYb6ulEbsfk24rHf2PZ4f6ns=;
	b=s+q/lPMQNDvYqbcNUv9cxVllj/4LZhw7lsUjq9p3o5Wdr3t8BlyJ2hTD5O0Nj+LW6Loki3
	doMwA+VJdxT/bvBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7BEC139CB;
	Tue, 16 Sep 2025 09:45:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HvRYMcoxyWgWPwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 16 Sep 2025 09:45:46 +0000
Date: Tue, 16 Sep 2025 10:45:45 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, 
	lorenzo.stoakes@oracle.com, david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit checks
Message-ID: <ekawpt644ur6grvw5a6mqxzssyxxjo5mcfzxxe7vkjevge4yze@36zxeivutuk5>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-2-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915163838.631445-2-kaleshsingh@google.com>
X-Rspamd-Action: no action
X-Stat-Signature: i949uu4zjg6an7ri3egxojy6njxiz9p8
X-Rspam-User: 
X-Rspamd-Queue-Id: B7AA3160004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758015950-201888
X-HE-Meta: U2FsdGVkX18BTxTBqYMj94VdQlugHDivNxE+BNz3JUx/JGEKEYzYDREn8skpIRHPuWqiZ3sCCB1UFBAqU6KaoDB8uXoHg+LndnuA3Tu7dDi3A98cfL+3aWMmIU8LekI8PaMhixwJJQxLtAGMXKNOfJRVMkXuPtlcVJ+ydOmu8bat6g09g4gVemanKXtONFBfH4x9WM9/y6k6LebLcOCz/pnByeKGDoKBy2yArz1FC2ooUhKxsxyIqEzGVOSJEufLAp2cGyqjoGoc/1VS+y1bB+EEgIw4clSRnr8IGHN4ejTxmsQjUCwAnFDH5h26yKubpU/QIvs16a7v6Ozk6xB3IakGY0h68wUnUuZ6kk4qllsr8F7fVeUJbFfYSW4dFflc7lebVGiu8ViFXeM3R3hdhp8pc1ah0csu/wccuwOiS5aZBp8MahEUB/onqvyrZq9UnZ0pN1rmfr8kPoh+9U1v1Rm+ladS+r/9EATgDMDQm/Sw0ZvoKrBMV24/rIX5tVTCZM5Ttlf2NsuAuHQ9eqbEU19PB0m9xuzvLueFKiPYGEcEs2VH7QuRv2cRdBKynYI9QvYtgM19QcYUu+4fG9i5WyxJP03+3Inq+RYuxn+DidGIesSovgm6slLQjBD+i79B5fVQsCKk/ufdvzIWVFMdXETXwfNpWp4SN9dbmaR0+AX6DbYGJoGyrJUqJ5RMMTV8q4Zsa/yQDqDxe2W36FZAI8VdwSP137ZAuxOWf9Y5PjTxaE5xpwGlmvbuf3E5Vxts9iewBB2S79UjFonG3bTtt9eI2X5tC07tpZv4dhOdCMlCN9/AHe9Vpd/ancwx04NMuXtU3W89TQuT1+QcIkC1SXGmBWDNQYG6A/MvqJ92XladUDZivzOkOC1dMf+GpNv5sj4NmhOQ5Ncj6E+wBIoYKk9UL88/rPon9dS+wiAdpsusQf3e8RxtEztsDa7MDtUVbYyuLjQErY5KDL6saZE
 FchDN7Pf
 QafQcJF8jgPcYUtP9JGzmRJurenEOYxT+/JWuGYo6Lo2HW1pk6TmWMzm6jAVrumliMVhZ9uYGgFanhO2rciBaODOA6pOYFRyVw6HMJ2qNfX+Pi/Qq4uCc/uyiwiXCW30rgrSTAA8HB44dBUWcQlXgyFZNujklmMH7zAvt1Ij0ukd59sdq3xlEUFs/y+kT9hIrrapHpal7k/oHA4ZjJuc2BNH9VOgIRFol0WD/fpCQw6RXaNwHksVoPs/nqA8qtlQqH3miNgZbFehUT/FUW1gOtsptUHbl/OOqkvbWblv8nErAFCrgp0IKX1D/PhXhguZ31/FCbALCIqHcI01EzVE8bZiKa3ASBI3WNXlUfmsV5FBKdhvKZhO32SNYpxnI8xdt04sBdvhNQpKItlDfEM1jAoxplhrT1SHOptScFabAZcSQGaQj408WaHtZrWeRLl8A6IlrwyrM5RK0zgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:36:32AM -0700, Kalesh Singh wrote:
> The VMA count limit check in do_mmap() and do_brk_flags() uses a
> strict inequality (>), which allows a process's VMA count to exceed
> the configured sysctl_max_map_count limit by one.
> 
> A process with mm->map_count == sysctl_max_map_count will incorrectly
> pass this check and then exceed the limit upon allocation of a new VMA
> when its map_count is incremented.
> 
> Other VMA allocation paths, such as split_vma(), already use the
> correct, inclusive (>=) comparison.
> 
> Fix this bug by changing the comparison to be inclusive in do_mmap()
> and do_brk_flags(), bringing them in line with the correct behavior
> of other allocation paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Looks good, thanks!

-- 
Pedro

