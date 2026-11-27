Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB83606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FbTcjs8L;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZzPHVtN3;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FbTcjs8L;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZzPHVtN3
Received: by kanga.kvack.org (Postfix)
	id 4A6BE6B05B6; Fri, 27 Nov 2026 17:05:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E2C6B05B7; Fri, 27 Nov 2026 17:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394B96B05B8; Fri, 27 Nov 2026 17:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 132A76B05B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:05:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 857C1C053F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:05:27 +0000 (UTC)
X-FDA: 85482281094.06.6C6EE0A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50778C000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:05:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FbTcjs8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZzPHVtN3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FbTcjs8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZzPHVtN3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795817125;
	b=UxnFGrrRqiR5q4VzUyUu7nwAiID7HfmK4ASYyHtOmPJUsi+0ypsE8Ux0cmxfdS+Vl3Ybfe
	LkxXodcfzVTbQP1Y0/ccBybUvP2pSWixpK1DdT0AdGwkeAEa4YvLwRRPADcIAlisvWSWpz
	L+Zqrl5Yu1I7U8IsmMi1w5NgbdgisUo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795817125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cS1qBES1VuLe2M/hg/1JmxoAVCdTAa567ydVE58sAFc=;
	b=uMoS2by9jM8Sw95a3GCV2yC/ub2MsVJEg6o4ThVP5X/CWPOnSNlqk3gDpDocD2679eDhBo
	/REmjgd5GT7Ab+s9oAo7sj2Wd12UszSYwDi5IV+31TAlz2oEpLez+0FpK8/KmlKQfPymB4
	Mb/K5k5UMx/WiaYMJBbzPZPlPY6nvts=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FbTcjs8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZzPHVtN3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FbTcjs8L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZzPHVtN3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 874DE22A2C;
	Fri, 27 Nov 2026 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795817123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cS1qBES1VuLe2M/hg/1JmxoAVCdTAa567ydVE58sAFc=;
	b=FbTcjs8LvvXAB9Ongw+Qi71nreN/kKlpgxFckFaDvMRrl/OI/DU5AOoGOPVO66uEPe0hp8
	bZpdpNWlffmfCNUUC4NCa/1zwSXjdkXmke61tw70dToD/tkD4SqwpPBd3MqWsistyTh2Pe
	Up2ZmS484gQ/GTcNpv155H3u3Lqi5+o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795817123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cS1qBES1VuLe2M/hg/1JmxoAVCdTAa567ydVE58sAFc=;
	b=ZzPHVtN3zcptr6CJ2gr/McwDyEAZP73QxOp9iWITyPWJ6/PJ5zYUcbgcLr0AAZ85uIxnMs
	8nuElFGm/PiJKzBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795817123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cS1qBES1VuLe2M/hg/1JmxoAVCdTAa567ydVE58sAFc=;
	b=FbTcjs8LvvXAB9Ongw+Qi71nreN/kKlpgxFckFaDvMRrl/OI/DU5AOoGOPVO66uEPe0hp8
	bZpdpNWlffmfCNUUC4NCa/1zwSXjdkXmke61tw70dToD/tkD4SqwpPBd3MqWsistyTh2Pe
	Up2ZmS484gQ/GTcNpv155H3u3Lqi5+o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795817123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cS1qBES1VuLe2M/hg/1JmxoAVCdTAa567ydVE58sAFc=;
	b=ZzPHVtN3zcptr6CJ2gr/McwDyEAZP73QxOp9iWITyPWJ6/PJ5zYUcbgcLr0AAZ85uIxnMs
	8nuElFGm/PiJKzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D93D134E8;
	Fri, 27 Nov 2026 22:05:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yNJJE6H+CWvTIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 22:05:21 +0000
Date: Fri, 27 Nov 2026 22:05:19 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, David Rheinsberg <david@readahead.eu>, 
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
Message-ID: <awn9xtkK5k_dB2r_@pedro-suse.tail5790ac.ts.net>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
 <20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
 <20261127124428.f1f66c6244d3e5c2811f56de@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127124428.f1f66c6244d3e5c2811f56de@linux-foundation.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50778C000A
X-Stat-Signature: qyokdhm8d5fj59kr4mk1axtbhrf17m1n
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795817125-83895
X-HE-Meta: U2FsdGVkX1/KVIAewE6DRVw8qfSsSTRGzzZGyC3SolDVqYdPaQ8mFe3zSWSA/qnANEU4Rce0CsUTtIVMHHEPtNN698TnAQYSY9W0hBEknq96J5ipmI+ltP1viAnrWNXWEtymwhbkALbbuNLijSc2Q80XRvU4yI8+QPj0Z8+8Hz/GdL4MECdGO55Uk5zQUOiqiIB2b/GDztyZk6SQW+LkY5luCQpBMMBi6v5ZjnrqQhMxN3QMx7XUBtXViAUn/h/kS1LkJyJpEkibtO7DE/kp7fSCGXC+LsEoVxdAFOAYXO9MKVq0Od7GCw/c6gOnVrTGAmF0m8LfG1f9RVpwtKjXWXJVMTpahS59yLCKfZQXrz7VEr0+vDozZXeXxuP9V3nH0fICiJUXU0MiBSsUBQoaFROpIDFvOEhR7bqsaD5iYbeXpsbzg464LU9Df5PS67XvJPBrpMlTW4F2JF2Va4BF6nxyi4XnQ2uZ5FPEjRbCaCuAQfy0d+oUa9130bnWohSRHsTYCZqJc4KLvEN8t1tiw5xiqyGi3j08pHwTQcbR5NfNEvHaNKXkEcIp7whpVcCB/+/RtbBaBGaIUZV+nUoAlOPi0NqGKRG7UhVwokJt/t6IsTyTKKF07A+DT1GvQKa0Iyvrj/yltjsW/zuPY3rqSBk2i3A7nBXGkhonEArPE0Nd1RI9hZOt6Wn5OFiS+/O+o+F4tybu1HwJxSyzP9AEHmIqv2mA54YGuMnMF6Wcz8xmJRrYM0gwLex4IuRIUFqTS0gVeWrgFrOLkmdmt/H73wrQA9e0mw/lUihymsQa15zLxKRnR0nMvlg+5IzaanVvYe8w1U09D4z4CXhcuSUqhObfDd5EfCBzLY4Uz2F8yBl/RV0zWGOet0JNGExD6M+BBZGf6l89afZcEiRo4Qzxzw0lxtPHf02nCCBunRlzt9bpfuwnz8iDYTPoZkfPxCv6Tb3WvgEjyBK10ipCeJt
 m9fdaK+c
 Uv50p76/FelNirTUgb7MGp66ztY71MGMZTMAsdc+e94STWnNaROh0OXxIjCeGJtwy4X9d3ZMSBUVZG2Y52fvHxVvv+dzc13wihcOscMCU2Df1kErPHOjkHut9QtaJoXYbuLDqDb2Cwn5BYW+GqxMXuueTb/WMs8YYHPRqx4FnH4+8DwjM4KB9SzlkisKfj0NoQFoak+3dChckQLnlVlDiIC3vK74AONM4w/kDQ2FpZjIKdE0Roht3LRoaXEuq93C6GXOEEl0mrYzmieNUO2y5bPP2u7YwkYPhQdK16XYuNbgwA75YlBg4pWKmO2az/PMkfG4fVadOr80Xd78n29Zp2sEafIZrQyamfwgur33ayNIl9J6RDJqnSrTXEUm/VUbxHzjh/0QvqLwlOldFGhg8u/mVrl1rXfeKrXntdYtjIIqevaO7LTMwrNQiRvlr4QTT01b4nUL8Gl43EddL5bk1MQtsLOlvxi1pIl7ys4wBjVi86TxtL2RQouZ+zb6vB41dIQ6atHzORXsFOerRBGzszwl2W3ZGzx9iNsXhDh1NXM6jrZNUEzHr4V5WheoC8lMiyg1Jv3Z7fu5ASzlPF5MRK5duCAiMjVJB+Pxq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 12:44:28PM -0800, Andrew Morton wrote:
> On Fri, 27 Nov 2026 19:45:40 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
> > Coda file systems stack differently from other stacked file systems.
> > 
> > On mmap(), coda_file_mmap() switches both the Coda inode's i_mapping and
> > the Coda file's f_mapping for the mapping of the container file. This
> > causes two problems.
> > 
> > Firstly, the container file may not remain pinned, at which point this may
> > result in a dangling reference in coda_file->f_mapping, and so a
> > use-after-free in mmap() or lseek().
> > 
> > This can happen when you open the same inode across two files, mmap()'ing
> > in one, which assigns the i_mapping, and open()'ing another, which assigns
> > that i_mapping to the file's f_mapping, if the cache manager gave the two
> > files different containers. Each file pins only its own container.
> 
> Yeah, I hit this while getting
> tools/testing/selftests/mm/memory-failure.c to work on all Linux
> filesystems.
> 
> > --- a/fs/coda/file.c
> > +++ b/fs/coda/file.c
> > @@ -182,7 +182,6 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
> >  
> >  	cii = ITOC(coda_inode);
> >  	spin_lock(&cii->c_lock);
> > -	coda_file->f_mapping = host_file->f_mapping;
> >  	if (coda_inode->i_mapping == &coda_inode->i_data)
> >  		coda_inode->i_mapping = host_inode->i_mapping;
> >  
> 
> I had this change.
> 
> > @@ -248,6 +247,19 @@ int coda_open(struct inode *coda_inode, struct file *coda_file)
> >  
> >  	host_file->f_flags |= coda_file->f_flags & (O_APPEND | O_SYNC);
> >  
> > +	/*
> > +	 * On mmap coda_inode->i_mapping is updated to point at the mapping of
> > +	 * the mmap()'d file's container, and do_dentry_open() propagates that
> > +	 * to coda_file->f_mapping.
> > +	 *
> > +	 * However coda_file's container may differ, in which case the lifetime
> > +	 * of that mapping may not match that of coda_file.
> > +	 *
> > +	 * To avoid a dangling pointer, reassign the mapping to the canonical
> > +	 * one.
> > +	 */
> > +	coda_file->f_mapping = &coda_inode->i_data;
> > +
> >  	cfi->cfi_magic = CODA_MAGIC;
> >  	cfi->cfi_mapcount = 0;
> >  	cfi->cfi_container = host_file;
> 
> But not this one.
> 
> Is it truly needed, or is it a future-safe defensive thing?
> 
> If the latter, Tested-by-me:.  If the former, Mostly-tested-by:me. 
> Either way, Acked-by:me.
> 
> 
> It's always seemed a big wart that file->f_mapping even exists.  We
> should get that via file->f_inode->i_mapping!  But you-know-what tells
> me that "/dev/mem sets the opened file's f_mapping to the shared
> I/O-memory mapping; /proc/bus/pci does the same.  Their f_inode still
> identifies the device or proc entry" so sigh.

FWIW, I think it's a rather nice part of the Linux VFS design: "file" and
"inode" are separated well enough to allow for these kinds of shenanigans
without awful hacks (and, yes, this is also present for something standard
like a block device on /dev; /dev is a tmpfs mount, so the inode is tmpfs, but
the mapping and fops cleanly point to block).

But stacked filesystems, admittedly, do give me motion sickness.

-- 
Pedro

