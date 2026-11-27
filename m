Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23992606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FdFtfkSb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+bjHVmkS;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=pwz7GrgD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hPl4tkYc
Received: by kanga.kvack.org (Postfix)
	id 0D9666B05B1; Fri, 27 Nov 2026 17:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1636B05B3; Fri, 27 Nov 2026 17:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94CE6B05B4; Fri, 27 Nov 2026 17:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B23C16B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:24:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08A7D1C3D00
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:24:53 +0000 (UTC)
X-FDA: 85482330066.17.7251533
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id BAA4A140006
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:24:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FdFtfkSb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+bjHVmkS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pwz7GrgD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hPl4tkYc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818291;
	b=IO9Fhglc7MjKa8HYiPl+QOzZjvY5gBW840hG8m52HcZRX/aOtXN1TJYdPXFl76s/z5Y4B8
	xvuTxspbMi16INx2ipMqgcWhss+bTZz1Ks4m5eVu0g9A/QFnLv23GxUgkGaZOq1vrxqgt0
	XENe2XMigOcFE4gwCcBqWAOZSAft+VE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LM70W0+E00PJvFbuomtZnd06N8Z64xKhm/h17DW5xM=;
	b=8jtlxcIVZ16fAqNrfH9PsEC+jN5HfGpiY/PEWOuseftA+EME+QSPKxYbaHJsQ8fxQAdntP
	yF3crMh7t5MPgW91+3nl5pad/tbvhdU7e9V6K5IHpQL2urS7DOVWnlpmYeMYmd5cDaRNGI
	27PYr4jEWKotSCBmhbhrF9OoBOj/FDw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FdFtfkSb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+bjHVmkS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pwz7GrgD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hPl4tkYc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23DF122A3E;
	Fri, 27 Nov 2026 22:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795818289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LM70W0+E00PJvFbuomtZnd06N8Z64xKhm/h17DW5xM=;
	b=FdFtfkSbtBosM74bFNgxrkmsApewsLnO8XVPKHI1/HAYFEgKgCweUKsN0r8xrT7MMIgWLU
	/djTEv95ekACF/0Y1oHOdB6pEUWVp/LtT7YIeb8+WW1cwzXPSzT5udmmawAi9nzliRe0iG
	e5Xy/gCJ6otEsVlgPoeBxX8ramJjmyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795818289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LM70W0+E00PJvFbuomtZnd06N8Z64xKhm/h17DW5xM=;
	b=+bjHVmkStyVnkOMIhm/BT2fRcer2YSDsh47F4My/gtsZWtbMytzruRf02/SCRIyaSuEHlH
	PYWtm8O2LW3OJiDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795818288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LM70W0+E00PJvFbuomtZnd06N8Z64xKhm/h17DW5xM=;
	b=pwz7GrgDo6MpCMUFsOzOvHxqFoJ4Ri0bhf4ifa2AVOu58CcCIieGl+Z749jlSKQUunU4hy
	W3Dv2urGVToG++U5+6M4dj2Hk7Zkt5J4tE3TZmcGISBZh8E+W6Cd1x2m+fS54FMHXKkPqF
	k3rYYiiqFDtyD1zH8HG7VEb6GuyR4GA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795818288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LM70W0+E00PJvFbuomtZnd06N8Z64xKhm/h17DW5xM=;
	b=hPl4tkYcdjq7eMml5h8L+E3NChYlNSCQNMhlSwaYTJvoQB4ZHlJDQQv6MBWItqZJdUNoym
	4TISQT+utv5fklBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D5D3134E8;
	Fri, 27 Nov 2026 22:24:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dLGLMi0DCmtNNAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 22:24:45 +0000
Date: Fri, 27 Nov 2026 22:24:44 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Andrew Morton <akpm@linux-foundation.org>, David Rheinsberg <david@readahead.eu>, 
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Alex Shi <alexs@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Arnd Bergmann <arnd@arndb.de>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, Andrei Vagin <avagin@gmail.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 4/4] fs/proc/task_mmu: write-protect only with ptrace
 attach
Message-ID: <awoC1CV9gBKm6wSi@pedro-suse.tail5790ac.ts.net>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
 <20261127-mlock-madvise-mprotect-ai-fixes-v1-4-e46b2b1eb435@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-4-e46b2b1eb435@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BAA4A140006
X-Rspam-User:
X-Stat-Signature: eizm5owp36ocjubwo1jf9i3t7er9i5p4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818290-796808
X-HE-Meta: U2FsdGVkX1/Xc22i0vM3bmt5JMM97vQ94E4ZFKehw/cqfIHWgz9iWW9xmR911HtVFJIfm1a0cdaiCCMlPWiniWawu4iwWkJ5ymov9EAsyB0HSzYaNOn3QFoNeuPiuvO7QHA+WBk7Ddab5YQ3evB1ozMiF/a4yLJ0AoRJBASFtTU7y0UeaG3SJALoXYRylG3sv2XS3GQsEN8Hl9DsLLeEUutZbr0V5pZYnKiQoXzqth3YcpuFJXQqzWoIp/pfaXfSiUFzvNh6wmGlxSaDHM5kCBcsnun94VMIvyE+tbHNSDQd0+CnZE8sKYk2+7c8Ltw0a2u/oe43S7z1BGfYc3rEdYSMzkoYb/C/fQmtuFARbIikbc8PkQO3NnrlYHcYiXGFQBUF2XVj9wJp1tchoUTkrXgxhrtcO+lNNfzJkyi3cMczMDSYA9D1tylVzsfuMn/04vbpfOyRPB/9OF1bzkhyH4OuVhqYqNuCQuZSDtuoK/0MFpgGIg8/bHHer7OMCZGr5EZVuHyxpVjSH4crZxgqogXBtVM1TV/ZhaHmMi9Yy5f6ox5TYBduD01hwBYfRCWIYW88sumZrVVfRAsrgIWgaxr98Mfcwr/VPWufB2nxKmwAnxIQWw/HVdzqnqru7cfQPGccQlc1Qf8fDJX6dFPlAwYRNe6xc7of/99NqX2tH30aK+7cfNsMulF1Qr37vlg/It7lEgPdKw8s32cSIEG0dyM5lAfuXhZamLnl4m8lxAc8jW2DJGXb1CCSR3wL4HwECeFPBf8lZB3Xe9Zd37LytaDpNx0KWLwKWIcAfqOYJQiuXWKPAHQdPspRhrIvHJok++SsRcPKV5Z0+Juc5CbhJfB4aiqgQqLie7GkN9f0aRnCrqMrdXmllKag8ScwDLBZnd/BoL5DFFMVWqcZvLIS8aRAUOhAuv7enne0jwCGGOGDFXz63ZBriQ3sbZnSsejJWW1sR5ilxf6tnxEp4mz
 yFDlt8PT
 7YTdW/6t+Z5rU1V32HZwp/v0wzaI719Pc67Gge5Uxz/rFFNB5LeI/mvKj+xz8D8xgLJ1W7Wp+KJvtmiOuWLZ122pEUvc7Gq6xkotmGYDnQOgY3ClsGEF8/Z1dvS43VNpWXPIZ2AWFcoPa8JLCez823kgA5NnyR0Sf6liaojqPNcPzZQ0dKqHmfoHxMg4CE97Wk4LyDRyXBR5Wwmj+ojNohlZ3sE+nTN6He181yWFOUqAaMsa0jcKPRTj01oS8YCN5NXLHSWyn2NGVBw7UToCR60tkquLzU/gLn4lc4U5g12g/Ki9CyM9dSF8tAr/EIKL9mZLGpZ9uIIrCOllE0ZUvMeXT+jlEoRdkAAqtBOrbkr9FSuhxZbnlM4CCWvz0LeaB5fROAeXru+tzatTzfUVfZGx8QDFsHHS1FmI9/5SQ2FG+PPJqens4GJN/S8+240o0d6Dgv6zTkjNXSnp2f6jYouxVtO148T7uMThqDjTqW0q1Ps5TqwBLIRw5C8R0V409Y12P6vARefDbx+Hj+shqzf38vbFGei7kJEMyC7McAW8eB96gYVdpye0lNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 07:45:43PM +0000, Lorenzo Stoakes (ARM) wrote:
> The abomination known as PM_SCAN_WP_MATCHING, which makes PAGEMAP_SCAN not
> scan but mutate for eldritch uffd-wp purposes, also lacks a permission
> check when scanning the mm of another process.
> 
> It defaults to PTRACE_MODE_READ, which is insufficient for this accursed
> operation.
> 
> Therefore actually check for permissions correctly, and also make sure the
> mm is as expected when doing so.
> 
> As it stands, a task may currently manipulate page tables of the remote
> process, write-protecting uffd-wp marked pages, allocating page tables and
> splitting THP, and invoking MMU notifiers as needed.
> 
> The check is made at the time of the ioctl against its caller, as
> lock_trace() does for other /proc files, rather than at open.
> 
> A tracker which passes READ but not ATTACH on another process now gets
> EACCES for PM_SCAN_WP_MATCHING, whether it opened the pagemap file itself
> or was handed the descriptor.
> 
> Also update the pagemap documentation to reflect the change.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

