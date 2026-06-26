Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8544FCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717086B00D1; Fri, 26 Jun 2026 05:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE586B00D2; Fri, 26 Jun 2026 05:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E04A6B00D3; Fri, 26 Jun 2026 05:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBEB6B00D1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:27:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA5208D972
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:27:32 +0000 (UTC)
X-FDA: 84921535944.04.0C81622
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 812A7A0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:27:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uNbnnCSG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yi8gbCIK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uNbnnCSG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yi8gbCIK;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782466050;
	b=Zv0p4lKjhuSGn6iLFolIhp9gFi7HM/3Le4zZiCXZXewx7Q74WScBOSJD1s/cgte6PPtACS
	+m9ZItX/Uy8ts0IDmot/1hnSEWeWXV6a5JN8uJcjBlnmUdsbzeofdkGwg+aPhOs+yDuxR2
	wG/zkDYcbJXLj/jUZgJTrJ+o7PyGjG8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nm9GkPZgMILFXO0HgO0WZxcUbxtpw+aIH3Dw3qsNCSQ=;
	b=gSZt+1DaRtggobajZ1NeQxSHNcf3urhWfV7IYMfL452VqXdvvc0HB8ShKoSsJxbWEhfEGQ
	7DJDVX+nqdGWKsMsxFvqPmTA0j/HBca5ypzugSQQL/JDhLL8Lx2obK70vrf+uXrn+hrWPP
	jnSnkCR0x2k2IkrEDCXpjRcpLrpE2to=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uNbnnCSG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yi8gbCIK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uNbnnCSG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Yi8gbCIK;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 248C47202A;
	Fri, 26 Jun 2026 09:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782466049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nm9GkPZgMILFXO0HgO0WZxcUbxtpw+aIH3Dw3qsNCSQ=;
	b=uNbnnCSGjX5hpmGMhLswAOlc4+yp2tZrpYPqhVNeKyF3gfeW4dH6VVmW0mVKZGuunzbiDw
	8/wlOJMTIKySeaWvBpGP2Sng7T71rCPsrppRMdKPuXQdCArXqr1qAHwT64xaVit25+3N2B
	R2y0zXHEEVoQoFCD6FfZE40uVdZCtww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782466049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nm9GkPZgMILFXO0HgO0WZxcUbxtpw+aIH3Dw3qsNCSQ=;
	b=Yi8gbCIKKgb84pwirQuv5siBaoS1ofZvh9okdEffpJwnKObaQM224qMcZD8LIkrOu/N2++
	NTsoHslAH4S0r+BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782466049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nm9GkPZgMILFXO0HgO0WZxcUbxtpw+aIH3Dw3qsNCSQ=;
	b=uNbnnCSGjX5hpmGMhLswAOlc4+yp2tZrpYPqhVNeKyF3gfeW4dH6VVmW0mVKZGuunzbiDw
	8/wlOJMTIKySeaWvBpGP2Sng7T71rCPsrppRMdKPuXQdCArXqr1qAHwT64xaVit25+3N2B
	R2y0zXHEEVoQoFCD6FfZE40uVdZCtww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782466049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nm9GkPZgMILFXO0HgO0WZxcUbxtpw+aIH3Dw3qsNCSQ=;
	b=Yi8gbCIKKgb84pwirQuv5siBaoS1ofZvh9okdEffpJwnKObaQM224qMcZD8LIkrOu/N2++
	NTsoHslAH4S0r+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38E2B779A8;
	Fri, 26 Jun 2026 09:27:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Uvl/CgBGPmqDQAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 26 Jun 2026 09:27:28 +0000
Date: Fri, 26 Jun 2026 10:27:26 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount idmap
Message-ID: <aj45h0NkbToPN_i_@pedro-suse.lan>
References: <20260625153853.913949-1-pfalcato@suse.de>
 <20260625112903.f961fc41a0b0f8dd1f1a9fdd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625112903.f961fc41a0b0f8dd1f1a9fdd@linux-foundation.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 812A7A0003
X-Stat-Signature: i1wryed791zdbr3izmgg9nip5futaes8
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782466050-626265
X-HE-Meta: U2FsdGVkX1+cRsgnqAMYXxkz2toIDgSjAqyDHSbKctQLVLKpWxZsTk4MJc9E9mCZ9xAqraKdvHEYlu12Bef2oQ5bymtdhU+oLL6S7qiqb/YFCoWE0STutGfAVDl1T6W7a9SUv6ukbpDMhFuw4mntCTPYhBWkCmt1XeO2DEuCJjjwenDq2VSEJDK8oxFC6EB5mOBBa3+aepElOiNEYHH6CzwIoDrSxbeg+6NE0aDHDjfqpTuymsaWyjQoj1nhRbCP7JdKA4tU378iOc1BwEPZLow4DseuhB29+uLMp99mHN45BvNUe47zd6Ngl9qWXYq3rxIUlY+0D35M6aufKOqj4s1TnHrw7RpqV0h+4sy2YYrGwTELFGCvAQSws49rV1NH3wakzLvL/HoreB2+lqB8CxT+8jNFKPPV5reVmdnLLPaoI3rsxSWCcYldRkgbJ+yMcsOMmhOORKyk1el0S8thjvwIbANDaR2JYVVq3cV4OZEjA7sIgk7njn0/QRRLyvXcT9wpzBna19hLuC6mb22UGLjl2Usfy8GmJbT02Ky5uJ5wDoQrvVliWuEyajKv/9kNY/T/u53O5GphWi+lYq0jLMAy3vRZjSLBG/I5knEUXdkCqvDA5AZLJReXod9PrkMAR+NGGTXFs3e1qefWERKKA1bG0AO5W0p5zS4v124vYaY+mbpjVe7Ng4oY50GjE9sX6Rptl6St5wf6/ExeTZW15z/W1/Uh1mZeri8mR02fxk2KTGQ33w0D9koNd1A/SQuXohjntWBdG68TMvRpg3zGYUG2oozcAYDJakX8ShQQGe9DcCni3gNKSSQaWvaCNWz0pw8i9UvIqcrAcHwL2pce7ZoOCOZBCBsyxL+btfMv9CDZJz5yhDArRbcj1kwXbFNQdd9rzNXoDy6JcKtraa+GUqDdbwjtKJ1VoteIY0RbCaxrJ+HwyXD28fz4UBi6JdwO5pboMYA/CikrK7Ytb+V
 2yfagf9x
 /I6pTymNLHOn6o98kOmXaNqArZd7wy6QA8ePheFfU1KuVYxGYVfTFyhDGnOskKEDd9iSWfyEvT36GE8W4rnbm5Tkcdi+uA7C+wPsUQLyOuDrvT5kCzTM9wfA8GasPDca4oMqQLmhOgnCycz7iCYOX/BD4eiZRZaCI7UGoX+rhjfcSxDjnIxDk8MvOG3d5Bv2Tb5GzBYIsILtUBx5HtIF8M9y5NihXWdtD5FSHsrXCBukNvwxnB7Xd/JAIam0pMHXi7gvszkDyFsqZnTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:29:03AM -0700, Andrew Morton wrote:
> On Thu, 25 Jun 2026 16:38:53 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> 
> > Ever since idmapped mounts were introduced, inode ownership checks
> > (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> > done against the nop_mnt_idmap, which completely ignores the file's mount's
> > idmap. This results in odd edgecases like:
> > 
> > 1) mount/bind-mount with an idmap userA:userB:1
> > 2) userB runs an owner_or_capable() check on file that is owned by userA
> > on-disk/in-memory, but owned by userB after idmap translation
> > 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> > 
> > In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> > file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> > idmap internally, but it does not need to be the case on e.g a 0444 file
> > where even the owner itself doesn't have permissions to write to it.
> > 
> > Since this is clearly not trivial to get right, introduce a
> > file_owner_or_capable() that can carry the correct semantics, and switch
> > the various users in mm to it.
> > 
> > The issue was found by manual code inspection & an off-list discussion with
> > Jan Kara.
> 
> Do our idmap selftests tickle these issues?  If not, is it hard to add?

In theory we could add this to tools/testing/selftests/mount_setattr/mount_setattr_test.c, but
that seems like the wrong place for an mm regression test. And if we add it
somewhere else, we'll have to deal with the bureaucracy of setting up an idmapped
mount (including setting up a filesystem image!). I'm taking suggestions :)

> 
> > I noticed there are a couple of call sites in fs/ that could perhaps be
> > cleaned up with the added helper, but I'm skipping that for now for brevity's
> > sake.
> 
> You could do this as a 2-patch series, because:
> 
> >  include/linux/fs.h | 5 +++++
> >  mm/filemap.c       | 2 +-
> >  mm/madvise.c       | 3 +--
> >  mm/mincore.c       | 3 +--
> >  4 files changed, 8 insertions(+), 5 deletions(-)
> 
> it touches mm/ but ->Christian, please.
> 
> (or I can queue it with Christian's ack, of course)

Understood.


-- 
Pedro

