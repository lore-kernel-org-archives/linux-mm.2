Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 099A0CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 18:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52AE88E0154; Thu, 30 Oct 2025 14:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF3C8E0153; Thu, 30 Oct 2025 14:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE6D8E0154; Thu, 30 Oct 2025 14:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6F08E0153
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:47:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B982256A47
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:47:38 +0000 (UTC)
X-FDA: 84055664196.18.5A24BB2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 44B801C000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:47:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ql+Zolia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JBkvUAc9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ql+Zolia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JBkvUAc9;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761850056; a=rsa-sha256;
	cv=none;
	b=pZeYqy2xSFW/GpOMxWGE6goO6ZNYMs3KmUKif9p1omijOmrts0nIf1VqL4B0uBFXdlaKVT
	MG4PUSDKuyYPqPIFNK89YSX4ltTeK1zNpKeEY5UpRRzsDQgWjPbJS6Tl+xQBKIaeW3XBB9
	y34v24utsO3W8wpExTk1SZ964vk2iaA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ql+Zolia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JBkvUAc9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ql+Zolia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JBkvUAc9;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761850056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwKcvH7H5RjQ5NOkIESnmuW0yiV4zx44hpfwDwJ0RnU=;
	b=KfwNCzqMRd9q1oE4sLg3jcAJ2CZ7slEV9dyStQCW/aFlFLgJ7D+q6IUDcFd1bi3QDfvg/Z
	yTX7j7CQ9CF/cPxBYtpeP8U3n7xCUDFOAqDDxP2xm/jnNDce39Go4A45UYfCCN7ZNgGU4J
	ZZovz9AT5j7gohs8ErJD7q8dm8hhlvg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2BBD3377A;
	Thu, 30 Oct 2025 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761850054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XwKcvH7H5RjQ5NOkIESnmuW0yiV4zx44hpfwDwJ0RnU=;
	b=Ql+Zolia4G8HK4Bop0o2jNKk73XtHsb3KNFZVfTQHgJv+rRoEiaW+5M9OkI7LVy2ZTBrMz
	f9SOv9IAItf8kpBT+S5w5POb+A2VFMK5Fe2ZvrOPvPXKXTlmBIc+UE09irhdhMc9zGZbWQ
	MCPMoSw4xLG9WGSNutfUasuH4UU6fR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761850054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XwKcvH7H5RjQ5NOkIESnmuW0yiV4zx44hpfwDwJ0RnU=;
	b=JBkvUAc96P9Nuspqriu6psbMpOpsFBClWJBfD0wmNpZNthlMoWIGmV2spYikjFJ37v1I5Y
	/kly+jzE6ku88eDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761850054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XwKcvH7H5RjQ5NOkIESnmuW0yiV4zx44hpfwDwJ0RnU=;
	b=Ql+Zolia4G8HK4Bop0o2jNKk73XtHsb3KNFZVfTQHgJv+rRoEiaW+5M9OkI7LVy2ZTBrMz
	f9SOv9IAItf8kpBT+S5w5POb+A2VFMK5Fe2ZvrOPvPXKXTlmBIc+UE09irhdhMc9zGZbWQ
	MCPMoSw4xLG9WGSNutfUasuH4UU6fR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761850054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XwKcvH7H5RjQ5NOkIESnmuW0yiV4zx44hpfwDwJ0RnU=;
	b=JBkvUAc96P9Nuspqriu6psbMpOpsFBClWJBfD0wmNpZNthlMoWIGmV2spYikjFJ37v1I5Y
	/kly+jzE6ku88eDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8791F13393;
	Thu, 30 Oct 2025 18:47:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9AZwIMayA2keHwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 18:47:34 +0000
Message-ID: <3ae457cd-6c18-4870-a617-7f937b107cb4@suse.cz>
Date: Thu, 30 Oct 2025 19:47:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
 Barry Song <21cnbao@gmail.com>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
 <xnsn5rfqigbm5ryjtbf2rtfotneiwygzesvyfdxiqrzlyzljdr@tmbht4ggnjcv>
 <61ae955e-310d-488e-b350-59bb809f06e1@lucifer.local>
 <c736tssdw3z57kamh6eqc23gr575q375n2o2nnszih64afnaf7@zwbqremsbhwf>
 <053f3a04-9195-4f8d-8959-42e0c3ba077b@lucifer.local>
 <72ee2324-d599-44b6-92ce-ed0afafed78f@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <72ee2324-d599-44b6-92ce-ed0afafed78f@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ypn1wb918ntwd5tkqed3wki9fancmwys
X-Rspamd-Queue-Id: 44B801C000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761850056-886375
X-HE-Meta: U2FsdGVkX1+Qd7Oc9QyptSPY0ND/mB9g3RI5JVorNe5jDc/Nzfl1C6hSe6i7GkTkiEpd4gpbVGVIKP3CcoMajXABpswW6vIeeRh2abdjTn3TOerg9xVpBXNienMmZC2wjSoDdzxPwGY5CjG/jH1wNrt/Py8/Fgz41/DpfzqyCj5SZgZFsqdLJDlIxpFT2OAS5jAidW6r7j4elENpUJOTL2y7iUu82x3FDyr6bk8IvOlQOm/wkOGrnXhKVmM70Ybrx/dUo87N0Z395+PqH98sItXvmWJhgSv9eH6Oyi76GTjr+rZ+WxNA8IzET/lZwLrCyCZ13WE5Ui+m+QXvCF7RjxMBPHNFRKSVzCJP64stxuCl3+JMPldh38oHf6HiRSjOTcecbJC/rmPHL1Ckqcgx+yGTBAkqy87h8dBGq/WskgYanm3Vfqtes0b9Ds74A3+65ITx7hnX+maAn8dvBkG4MLfIMZ1btJP/ZKp4BllaR+gPypt/1xmNqmM8JmDmS7witw9Jaxzr6QobfaD3Q5b8C1sq3j0oPOhsmgJAJok4ZGU+uhr87v9axcYRP8I7n44/6vKq0n8jWADr3Vi3fUkAJONHc4Iv8AH1RClWtAlp5V7h7teWJr0CZL37+Rcy2wfVjF3zonvn1dWWKm/wL4MjqrGJBEz9xgF/XN8CXufV27tWmaKcMkGgTGvEdiogihzYRR4js/YXH+uGVuW9S5pNjaShgZL4WdfrECDMSzOp7f55KWFBeJYTcAKPAQVUr6CLgAAb3kJkI2n4X4irZK5a2ysDLh+ZEbj+avhAbyAOpDflNbaY7nOGe6rBxCz2/6jMtVOyhzebTB3KCXt5aiZk4MOhSFiUcpUgRacQMbGCW5vMVhEK28XfxcvACfwoJbqECXCg6mRlwdzZ/Sy17ihU85536wV1+9GrtEevq5n6w2DtPxIwLKuKaPbXxH6vc/CE6jUPGlDEiawtUXbM4Cg
 1ym6sm0j
 GmLHEV4Dt9FcfWIWbpZFS3SYodCGKISNzDzLAUS9MU2q+a6GgUGAPYleRPq6n2ySBFTmrGyhRSqOyOBOgRDvfl2szvIXwdK2kjqdkbcEKB81UfmlQhaJCtlOnFK0i5/Lv3bbzO1WrFKWFSFh0ARc83s3g6zeIlkPHjZL0w8CMz4eHenOkk+TcvEnC9JTDAD9CchQgM8Co/skyvoLyXwgxwa8zdtKOcjRaDPbxc+SW1FxNY4WUmJAAwNpJrPTLGVWusBXgqfzCR65cLa/2GMh91mveohmSbz+xfarKoCD3q5RW28q0JeuIcq0789dvZoym20VVmBouPGwsWgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/30/25 19:31, Vlastimil Babka wrote:
> On 10/30/25 17:43, Lorenzo Stoakes wrote:
>> On Thu, Oct 30, 2025 at 04:31:56PM +0000, Pedro Falcato wrote:
>>> On Thu, Oct 30, 2025 at 04:23:58PM +0000, Lorenzo Stoakes wrote:
>>> > On Thu, Oct 30, 2025 at 04:16:20PM +0000, Pedro Falcato wrote:
>>> > > On Wed, Oct 29, 2025 at 04:50:31PM +0000, Lorenzo Stoakes wrote:
>>> > > > Currently, if a user needs to determine if guard regions are present in a
>>> > > > range, they have to scan all VMAs (or have knowledge of which ones might
>>> > > > have guard regions).
>>> > > >
>>> > > > Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
>>> > > > pagemap") and the related commit a516403787e0 ("fs/proc: extend the
>>> > > > PAGEMAP_SCAN ioctl to report guard regions"), users can use either
>>> > > > /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
>>> > > > operation at a virtual address level.
>>> > > >
>>> > > > This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
>>> > > > that guard regions exist in ranges.
>>> > > >
>>> > > > This patch remedies the situation by establishing a new VMA flag,
>>> > > > VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
>>> > > > uncertain because we cannot reasonably determine whether a
>>> > > > MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
>>> > > > additionally VMAs may change across merge/split).
>>> > > >
>>> > > > We utilise 0x800 for this flag which makes it available to 32-bit
>>> > > > architectures also, a flag that was previously used by VM_DENYWRITE, which
>>> > > > was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
>>> > > > bee reused yet.
>>> > > >
>>> > > > The MADV_GUARD_INSTALL madvise() operation now must take an mmap write
>>> > > > lock (and also VMA write lock) whereas previously it did not, but this
>>> > > > seems a reasonable overhead.
>>> > >
>>> > > Do you though? Could it be possible to simply atomically set the flag with
>>> > > the read lock held? This would make it so we can't split the VMA (and tightly
>>> >
>>> > VMA flags are not accessed atomically so no I don't think we can do that in any
>>> > workable way.
>>> >
>>>
>>> FWIW I think you could work it as an atomic flag and treat those races as benign
>>> (this one, at least).
>> 
>> It's not benign as we need to ensure that page tables are correctly propagated
>> on fork.
> 
> Could we use MADVISE_VMA_READ_LOCK mode (would be actually an improvement
> over the current MADVISE_MMAP_READ_LOCK), together with the atomic flag
> setting? I think the places that could race with us to cause RMW use vma
> write lock so that would be excluded. Fork AFAICS unfortunately doesn't (for
> the oldmm) and it probably would't make sense to start doing it. Maybe we
> could think of something to deal with this special case...

During discussion with Pedro off-list I realized fork takes mmap lock for
write on the old mm, so if we kept taking mmap sem for read, then vma lock
for read in addition (which should be cheap enough, also we'd only need it
in case VM_MAYBE_GUARD is not yet set), and set the flag atomicaly, perhaps
that would cover all non-bening races?



