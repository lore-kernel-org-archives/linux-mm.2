Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB406606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=MDBEVCRi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TTcGdVGc;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=MDBEVCRi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TTcGdVGc
Received: by kanga.kvack.org (Postfix)
	id 90ADC6B05B0; Fri, 27 Nov 2026 17:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894DB6B05B1; Fri, 27 Nov 2026 17:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B976B05B2; Fri, 27 Nov 2026 17:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34AA26B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:01:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BAA21604F0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:01:40 +0000 (UTC)
X-FDA: 85482271560.23.588E899
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB68F2000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:01:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MDBEVCRi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TTcGdVGc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MDBEVCRi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TTcGdVGc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795816898;
	b=y0jBK2NB7+2chxMKWwzIOmEdnFyvMyehUCB3I5OWoi/DSCzPVsbqar9hHfPA8CjYl8nplh
	HIuQnVl9uS1aQklx2FvjrxREGpVYVY34M2dUMPfi3tn3QWnC/x/BJVQFs2hQEEPTu4Qz0O
	dQ71cbC7DmeCtEATvyQxf2+xxA7UgRo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795816898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywO5RVgPZTKCg8MxNheY4qxRslQKFNNSPc5yDKjlZEc=;
	b=O5d1w6j6wJq63drDEIgdHL1hUKZ9MKhhp5LvOUvR3ryUg/QIdBP0W2XuEiBkXtYMLBKxK+
	Zak8Rhxgj9q87e1FvumjQ7aYLi8mGWdlhcl9odKmRU90EMBlr7pCJM7vYHX8wtSNhvrTSV
	1rz4+zaHoQp7dhBUTqrvfLP+guypiRU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MDBEVCRi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TTcGdVGc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MDBEVCRi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TTcGdVGc;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 519F91FDB7;
	Fri, 27 Nov 2026 22:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795816896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ywO5RVgPZTKCg8MxNheY4qxRslQKFNNSPc5yDKjlZEc=;
	b=MDBEVCRiaSp9fHhRM9woN31PQjdSz4IfTk3y5gnbL/9MOPuroXczvBHTYHWq/0USYGM6UC
	W9bLwbPhnxR1i+H9rP+0BBLXmrILGrQsZviUtmfOZsMuxRd2VDMPIfWAy3MaQkhh6lZSt+
	WfgYps87OSn5UVbTFhdyVnfN1moj3+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795816896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ywO5RVgPZTKCg8MxNheY4qxRslQKFNNSPc5yDKjlZEc=;
	b=TTcGdVGc0NMbDymzyNA9s368M9S2y/3YJUjrxNI501rHoUp+bKGNDCnfRrEAQt6h0SbcQy
	VUXM1+dHeNlYRyDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795816896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ywO5RVgPZTKCg8MxNheY4qxRslQKFNNSPc5yDKjlZEc=;
	b=MDBEVCRiaSp9fHhRM9woN31PQjdSz4IfTk3y5gnbL/9MOPuroXczvBHTYHWq/0USYGM6UC
	W9bLwbPhnxR1i+H9rP+0BBLXmrILGrQsZviUtmfOZsMuxRd2VDMPIfWAy3MaQkhh6lZSt+
	WfgYps87OSn5UVbTFhdyVnfN1moj3+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795816896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ywO5RVgPZTKCg8MxNheY4qxRslQKFNNSPc5yDKjlZEc=;
	b=TTcGdVGc0NMbDymzyNA9s368M9S2y/3YJUjrxNI501rHoUp+bKGNDCnfRrEAQt6h0SbcQy
	VUXM1+dHeNlYRyDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4836C134E8;
	Fri, 27 Nov 2026 22:01:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qN40Br79CWtAHQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 22:01:34 +0000
Date: Fri, 27 Nov 2026 22:01:32 +0000
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
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] coda: never point a file's f_mapping at a
 container's mapping
Message-ID: <awn9Qfo5LfDb5aN7@pedro-suse.tail5790ac.ts.net>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
 <20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB68F2000D
X-Stat-Signature: b7btundmrq4axbdrtd6xebzt9mmxqpts
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795816897-135699
X-HE-Meta: U2FsdGVkX18EfezGN0jPrA6tZEPMFfz/jhVwOo6Der5/jMQQSvIamKw5mDwCQt84x0N5d64YcuYubPqdKfn9OUwQTI3PhNEkiqZ3izouK1x2fnAmWmNAEgcoSduWinPiTPrPbBdKlDFaI5CX7+Piqax2OaipGg2AWf9dapznneaSrJ86MbFgpDCNtHjV+V7HEK9a9YPZzCZvPi4aursbuH2NrY6D78gL5pbN7RtToaf8TU9TbmjanyySBrMQxRyl2UrGlbHVg9GxJ9PEFh3sZgAQYwGKw7+oA4Gil8sCN2Na84ESpWzFoL5YOJg/49xPUMyBa3srvVzc45ewbPU0v00hq8Oqej+wo9nkl1ogW/nf0Dgm2uuuWLpu24q5eqSXb7wYYm6fnc/0U5wHvSIauaHe4c+0DPb1jkybdoov7jvXb1p5QnRe4lNfPQMJZCpJVlnvdDxSKsuLDt7co1j/ZBIyBhhxyJwJ1qR503cSAwf3nyy2TSw5m/JQ0UNxCLX1i85LEWG8ocWoei9I2loyPlnP9RpsTN4cycTDoxbcbnT+LQ7gq5TS3DY2Rc9vWPK/xFk9DwNmy0YSNeyi6JZ6Mt5Os4rX7FG289bPxsFykpZjd4bC4HfVeZSFifSDsgZwf1kArpJ2nsVa7V7IdkwAIUKozhQ1JBB41W7FxW1DQBaxks1Xb9CuRd6zkXsJ9vE6h2K2p/0cj8IIV/L8+y7gjcHxj60TQbk8ZrQSQvWY900D3yGklxi1Pwseu0FVrTgPz0m/UoB8FzJniK3FNX7dYOrNrgx/Isa02Wg1oJkVfS8P9Ni1i7c1SJfkyS8yXmGxyTlmUleNNhm4HiN1PIcAfdJizXsjFaY++iUan/sV9u3ppl/uwhd4+cfvtv12V52hRmS44heWQYw2d3xkoALBBhtNxye2uKYlQiNMqYnlIXCUMs+TJDSIyBzsy+tDFkjr6RFVNktN5O3nfRe/3MF
 7QgeKEsw
 txe2AYLwn+5KKeSEymSkI16rtG4mICZns53N9JzgvtYZWRhDBPyxsRep08+kd5lyvwf9+nJTKVqp76L/ARFxF4wrzRMyiqzvH+rEAKX6Ri5SUKTs3RYSLXYhToDTe8IxsZOS4fxfm+2KuFOof+yKWH3a5Bk4kp4nwuUPuVwcr+EoyyBC8YiAmNm/H3uPpv4he3cIIYhp1rCrhNQ6HKvvk+6qVOto2JXRttf9zL6kyPLXqjRh9dVtgSOYDStO+lN7vVQknu9Fya62eWKgrUauaGoKaMZ44bcShZb80SWSDQpINfErjFEvr4aj0yQzzojltsZf2AyM8KedwwkULOE1Rg5VaRn4TEaryScXsKknKaGLgIKgNDKEb1aL5b0Uz/9CvuTTuqMkjBC6rx3jfbu46Kos3G69HCpwaFZG849A8uwYMUELORmyw2wIjPif7uQpbTJ21mw30Ao7GqK2LaaYpqHmQNTEh1+8q6Ea5AuYucJuaXmBoX+GB1Alm2bim14zUFKkbip+EoAnYymM6tfVPVew9+UiPjjRYXbKE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 07:45:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> Coda file systems stack differently from other stacked file systems.
> 
> On mmap(), coda_file_mmap() switches both the Coda inode's i_mapping and
> the Coda file's f_mapping for the mapping of the container file. This
> causes two problems.
> 
> Firstly, the container file may not remain pinned, at which point this may
> result in a dangling reference in coda_file->f_mapping, and so a
> use-after-free in mmap() or lseek().
> 
> This can happen when you open the same inode across two files, mmap()'ing
> in one, which assigns the i_mapping, and open()'ing another, which assigns
> that i_mapping to the file's f_mapping, if the cache manager gave the two
> files different containers. Each file pins only its own container.
> 
> Consider (A, B = separate open files of the same inode):
> 
>     A, with container C1            B, with container C2
>     ====================            ====================
>     mmap()
>       coda_file_mmap()
>         i_mapping = C1's mapping
>                                     open()
>                                       do_dentry_open()
>                                         f_mapping = i_mapping
>                                         coda_open()
>                                           cfi_container = C2
>     munmap()
>     close()
>       coda_release()
>         i_mapping = &i_data
>         fput(C1), the last one
>                                     mmap()
>                                       mmap_region()
>                                         mapping_map_writable(f_mapping)
> 
> Secondly, mmap_region() takes a temporary i_mmap_writable count on
> file->f_mapping ahead of the mmap hook, and drops it on file->f_mapping
> afterwards. As the hook changes f_mapping in between, the count is dropped
> on the container's mapping rather than on the mapping it was taken on:
> 
>     i_mmap_writable of                          Coda  container
>     mmap_region()
>       mapping_map_writable(file->f_mapping)       1       0
>       __mmap_region()
>         coda_file_mmap()
>           coda_file->f_mapping = host_file->f_mapping
>           vma->vm_file = get_file(host_file)
>         vma_link_file()
>           mapping_allow_writable()                1       1
>       mapping_unmap_writable(file->f_mapping)     1       0
>     munmap()
>       mapping_unmap_writable()                    1      -1
> 
> The container's count is negative after munmap(), so the next shared
> mapping of that Coda file, if it is open for writing, fails with -EPERM.
> 
> Fix both issues by no longer updating coda_file->f_mapping in
> coda_file_mmap(), and by having coda_open() always assign the canonical
> mapping of the inode, as do_dentry_open() may have propagated an i_mapping
> which coda_file_mmap() redirected.

This might be the most confusing thing I've read this year?

Anyway, in the sense that filesystems definitely shouldn't be poking f_mapping
after open:

Acked-by: Pedro Falcato <pfalcato@suse.de>
 

-- 
Pedro

