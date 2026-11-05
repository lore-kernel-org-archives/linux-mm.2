Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF71606D804
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=w8z6FbOY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iqs4PIZq;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=w8z6FbOY;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iqs4PIZq
Received: by kanga.kvack.org (Postfix)
	id 9D6B96B05B1; Thu,  5 Nov 2026 07:33:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADD66B05B9; Thu,  5 Nov 2026 07:33:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2A86B05BA; Thu,  5 Nov 2026 07:33:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 668176B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:33:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02AEF120983
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:33:21 +0000 (UTC)
X-FDA: 85401005844.07.FE2AF26
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0DAA840008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:33:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w8z6FbOY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iqs4PIZq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w8z6FbOY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iqs4PIZq;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793882000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=399TihSEoNYgth+6wVnQYzG17uXV0lxIYTXFWph8MJw=;
	b=qSw0wYtAGjjEodMLnqtD+k7x0kKV4RPTqkTEpX+fwWFv3B2TdJ9XvDx3/jnaNkyRvUzdI5
	tCMPXOavr3OPvF7VTEUf+qu15QIXY0BM9c4hsg+wOVZ1O/6n9Dp7RsgLkPv2UfTdLnBiOK
	E/PjPnGJ+nvx50oZ+AG2suxTeP+aIf8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w8z6FbOY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iqs4PIZq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w8z6FbOY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iqs4PIZq;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793882000;
	b=Axwhrc7zws9qh4xiQEBwdR2rET5nhDwg2n+rDbF7TzdCMAxkHgcQ+CGhIpGQROfCcI8KWk
	OnhBWOvqPJwZbQX1Ix+qFSLW/4uTiH1NNTaMeGxKd2k66Pu/2s199sDeoDYmQtzLQZbTsX
	ynEJkhdf0IEdqGCsdChfN74Vo13TBKE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E405821FB0;
	Thu,  5 Nov 2026 12:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793881998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=399TihSEoNYgth+6wVnQYzG17uXV0lxIYTXFWph8MJw=;
	b=w8z6FbOYfxPCfpPyRo8fo9S5VcCI0qVhqe7YT1pPtFEMGd/3szBKK9zHo82Hn6L/F42ckJ
	gNNPNtgkV6sVnZuRl2rz4eVWBLAOLJNSoEigFrny7UedOyJgyWWwvJx41LMC4StVX+WeRd
	4PIxkUGlpjplbwMmoZTw66+rsgYv/Kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793881998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=399TihSEoNYgth+6wVnQYzG17uXV0lxIYTXFWph8MJw=;
	b=iqs4PIZqE+DvP5T/3xiMqirTuMFp6TH5Tw6JOoxhYlLK7Zv4G3KnSDAWifAMVXG5pxJciH
	aHo5g6F361m4otBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793881998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=399TihSEoNYgth+6wVnQYzG17uXV0lxIYTXFWph8MJw=;
	b=w8z6FbOYfxPCfpPyRo8fo9S5VcCI0qVhqe7YT1pPtFEMGd/3szBKK9zHo82Hn6L/F42ckJ
	gNNPNtgkV6sVnZuRl2rz4eVWBLAOLJNSoEigFrny7UedOyJgyWWwvJx41LMC4StVX+WeRd
	4PIxkUGlpjplbwMmoZTw66+rsgYv/Kk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793881998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=399TihSEoNYgth+6wVnQYzG17uXV0lxIYTXFWph8MJw=;
	b=iqs4PIZqE+DvP5T/3xiMqirTuMFp6TH5Tw6JOoxhYlLK7Zv4G3KnSDAWifAMVXG5pxJciH
	aHo5g6F361m4otBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23355133F6;
	Thu,  5 Nov 2026 12:33:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9DzeOo137GoDLQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 05 Nov 2026 12:33:18 +0000
Date: Thu, 5 Nov 2026 12:33:16 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	kas@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] filemap: prefault writes starting beyond EOF
Message-ID: <aux0ruR5HpMBMPI2@pedro-suse.tail5790ac.ts.net>
References: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Stat-Signature: xjgfenow1z3s45rnowe6htzyyy1spcw5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0DAA840008
X-HE-Tag: 1793881999-397476
X-HE-Meta: U2FsdGVkX1+xbq2M3dOvtnd0fsHcADOGEUvVN0fr6DtDnOJRcfZqi/HbCD4Mg8MyA5+AS/1R81g2OvAhlRbILbrrzZIlcWCzlL1UMcs05fUYBXrTpM52D1hX0ObuzAsmV5yW8d3uBtjK1PvXtDfxnEHz9+iwibMAIvB75Xyb06z7GFTh6o/tUGSwC2/zp+eFbZ6KWNJdyQsUt2DlJv7SDOQbmNuX6ntzxyBR3X3HIOruhQ9fq2khZkidvQR69H1YS0TKGycmWeO1CkcJ1t4hl1PZwJSVZwojGNS5UzhyzYKgkDXua7XgWOSJKZDqU7smMkBzrtgW9J0lRtssZSabImTTVapPLDzDuOQe+WOr/pt8+SY6fjL44/N6RJLe7p/1Tdf6fA76mU6cM2NbgeVpc0Z84kb2sQcYB/Bjh/7gCpML12ck1YzlwJ0dDoVIvMhSn0FAgKotaPAlx52AR+XANZmCJxOoSC93EaD/qH2VtP95JqcbZcTG/4FJXxFwi91+T3B3XlnJVvzLyHCRiQ+G8nY9YB0jqZvqIgCjCvPPrLe3912pxL5iPC+M4BP9kY+cbZjbSDM116fH0byTwPNbwBko0GAkevbtXJuEoxI93ca9NTZsHuJQZ8S+bJdiZu6A5tbYC3vPdFkEDMRkzAVhMidj0UbMO+hsCdXdHnAzkZ9IzmdVnK2TBpR+MkD4sKsdgSTE+jt+KaypTpV5GVMUqC+9v9M1LE4/2zvkjoRCHNxiVUjJw4N/RqaGKwnOWsFOsNFb2jMkgRh6ATjL4l4OB+RLYGdnxRAcdKO71PYDH8WtP6ROMVk4htBtAAJX0om7WP1ODpos3Tku+5rGN+clCWgvcVsVYN23G5IhznTFMn5TwRAnfyJD/tkS34IqTBLJPDhQr0Fer4Dvv/2dATfxH3v9EQsgKJw78z4mwgl/sZhl25G58Ay7tzsKFl/7+SV3SWj6H5IeFh77yieGObq
 Jj1oQlGs
 RHFiwtncBa4PjqmzvWOk3YhJKACi9aNalJd4o6TuC+3c2HTWqBExx1OwJo4xKE3p+GuIcYwFbs3bhNnIRZrwiv6ew0W2JF7E5KHuey7MrHhjVSoGK/iDENC9onmLwKKQUYW9aTwbnzBefQ7tFQA7m2VBH0HVfyduNBrtRC51HAXSarxq/u3sgep+3NT32nj0+CmmaD0/BzJ/O845ESCima4umhBPl9+DO598BYRW3b3HzzPcqCnMjme+d8YotiHmUWq0wLHja/H/1XCCZ515iWuk6y0xScsGU6OIskFyd8qgtkbPbKScUwxPrXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 07:10:02AM +0000, Hungyu Lin wrote:
> Since prefaulting moved to the slow write path, a buffered write can reach
> ->write_begin() and ->write_end() before discovering that its source buffer
> is unreadable. Several filesystems can extend i_size in these callbacks
> even when no data was copied. For example, a one-byte pwrite() at offset
> 4096 into an empty file can fail with EFAULT but leave a 4096-byte file.

I've been following this discussion rather passively on the other thread, so
I'll ask my stupid question: Why is this a problem? Yes, it's a bit of
weird behavior, but system calls are generally not expected to behave
super sanely in the case of bad input/weird errors.

> 
> Prefault the source before ->write_begin() when the write position is
> beyond EOF, and return EFAULT if no source bytes can be made readable.
> Overwrites and appends continue to skip this prefault. Keep the existing
> slow-path faulting for forward progress after a failed atomic copy.
> 
> This also leaves intentional zero-length ->write_end() calls used by
> generic_cont_expand_simple() unchanged. As with the previous prefaulting
> behavior, a concurrent userspace unmap can still race with the later copy.

Ok, so it's still racy? What do you do if you can't fault it in at all?
You still get a hole?

> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Reported-by: Kiryl Shutsemau <kas@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/at9xXRhD2xZhszEj@thinkstation/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
> 
>  mm/filemap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c6f318333427f223b9f42061a6213..30414d55412b84f11ebe98b8eea607ee8c04eef5 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4389,6 +4389,16 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
>  			break;
>  		}
>  
> +		/*
> +		 * Some filesystems can extend i_size even when nothing was copied.
> +		 * Prefault writes beyond EOF to catch unreadable source buffers.
> +		 */
> +		if (unlikely(pos > i_size_read(mapping->host)) &&
> +		    fault_in_iov_iter_readable(i, bytes) == bytes) {

I say this doesn't matter, and if you pass insane inputs you get
insane outputs. Even more so considering this is racy, e.g races
against munmap(), mremap(), mprotect(), memory poisoning, and other things
like truncated memory mapped files sending out a SIGBUS (or uffd) :)

I don't think it makes to add random prefault loops in hopes this makes
for saner semantics.

-- 
Pedro

