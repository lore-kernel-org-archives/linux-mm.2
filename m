Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471FFC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0136B0088; Thu, 27 Aug 2026 04:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8AB6B008A; Thu, 27 Aug 2026 04:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10386B008C; Thu, 27 Aug 2026 04:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5CE16B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:03:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 556F9120389
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:03:32 +0000 (UTC)
X-FDA: 85146309864.28.C30A8E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C2F852000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:03:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y59X1WvD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787817810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXL2oS6rqznvftTLrf8LZgLPX4TTr2sqHZu9rHP27d0=;
	b=iQyI40RZFmujqMcGsGsm/jybDE6sGPptKM75Ykky9LrvvTA0VTkf/dx8nE4Lt45uZ7ELSY
	XYOk36NnwaXQiiaH9cB3ZtIy+Bbsw+DQnSlGJNTa/5GogXEarDbopSQc6ppdR5FQmLo5qr
	NrK/xdAKGhnZKdX8wQSimsZ4eZf2F+8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y59X1WvD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787817810;
	b=vFGtr7/DyUItu5wFmZWHVSYC71xmZULalxb0WYxNoW8gSOfXrAmhuB/xENuNRqgankMzgl
	TdzfNT2SBPqrCWD4ySjVBXsvx/b9bYdP70RiqKVizrjH7vHo5xjrVeALMA/9t7c5p0a5mM
	+aqOs1SxntMy5ZZ3vGk5/KSy3aIK1q4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74BB6600D0;
	Thu, 27 Aug 2026 08:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E00A1F000E9;
	Thu, 27 Aug 2026 08:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787817809;
	bh=qXL2oS6rqznvftTLrf8LZgLPX4TTr2sqHZu9rHP27d0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y59X1WvDiWVncqZBMXRihTdnQutjHIyDcTlQlCc4zknTmgdM6vTOl25vP36YLvKL6
	 YUBjX5anvmKQ7eJpIDQ14FxKSytIFMGy2w9mhR8fTUlkS+FtY0m7xKMA8HZW3CnJpV
	 hoOHxOBxY2OBO5H1q7Ze17kvx7eHIwORLcqvkrQ6X3YBStdrAKOKK+1yDiD2O3DdsR
	 S+f1RwI85rYYh7iyIerlzLMIn5UlEHAkHsCplAdn5GPKT1TndiL+0UMB2sw9Odk1xh
	 08/tBci7eh73lRSVGlra5NkC8LbfBjzShg9qo+DNPBuQN2aTKbwNgnHt/MMSUZqWrF
	 XDGwJ0FqV7FFQ==
Date: Thu, 27 Aug 2026 10:03:23 +0200
From: Christian Brauner <brauner@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Christophe Leroy <chleroy@kernel.org>, Kees Cook <kees@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH 0/2] powerpc: remove spufs coredump support
Message-ID: <20260827-teilen-flaggen-extensiv-61ce38f22855@brauner>
References: <20260826-work-spufs-coredump-v1-0-579e72a7ab66@kernel.org>
 <8ddf7d95-05b1-4758-9b5b-9360db77f904@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ddf7d95-05b1-4758-9b5b-9360db77f904@app.fastmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2F852000F
X-Stat-Signature: jwymzibg37y5wd8ycewj5396dn77r8eb
X-Rspam-User: 
X-HE-Tag: 1787817810-274431
X-HE-Meta: U2FsdGVkX1+1ukfUShmP6kio+X1ZUaLrUSDs2msnM8Ye9N/uwk76sbKVwekLE+VgpyF5yubaMH32OiXNTFSbKAk2VCqh/ppHhdZuFQx+XQ2+4wIkfW9vzoEAv4J8lmHaYWOtN7w0oPiiUV8Bw1b6qjrzZjw/KFyIDysTA88RvwOU7XVJuyK/rhWiCStQA6eN8Z/7wF2sgx6ASHwu/KS4zA22Va7vIWzgBd5L4Qe+/ha8Lb89PvYowqKK70LJlzXra0v0Rj+Z1ELNOYVJIGGlkQ2vOjHNh1WJ/X+KVQwxv/wLrdcgj9xU9U6zE4uZKWRaTpdxk/85QNTZAojM8GUtQwwITeyJ/nRhPlONoEqdNmIOQjpteeTAttyhYJx7/HTedEw003egD5B1ZH53kL2REGOYQeEMlXrtAvUypfDDNh3aAwIV/Kt3mIEvAbA1FqOC4xjOa+7YrSybaLZKdX7RZhwSIVAnOMt70NiEOhC6E7nfhknbXSLJCXAFN57WJ0BRItL1oIYa4RPUHthvxS6V827cxrC4mL1w8AXEG/HvYdnwdS3uPiaDMN2nJr+RXa5KFFYYdiCMrIxvjX7K4l0h+pyJxsed4GaZ9RLrgqXc4r7Hluntl+2XDFqeoarZPjSiJwA+t8FjWorjgZq/57+KsI0HRg+kpbXV4QFT+NxAq1HASknH5wMMm8Qkk2Bd1VShqg6e0BKUFXalY1D1OFjAGmQhUwnF1wZ9q4oyoiylhlMItTsJKrHZNGc5I6UypTWNVw9Ih7cq41/xyA//rWWcwPRI7knKQRf9whq150LmwcngWcOWjjelBWpOV600KSEQnzVtJKnG+GnAj1FDuqcUlZB+t1yK2OryOmXDfSJYYbJ65X7cRdoJN4i0UjEgcdnihFzwEti9MQPmdMe8TjnETr2Mkn25i06SpaN9WqzXJEsgkeLjTj51y+H+U7GitUDnbJbgmnrjjwgopgyNSo7
 usqRxQzo
 lmvDQH7Hnl47XC41WnXBN3xlTqDjdL+/cuHOC2zzCs5Ov97pbL5R6uN+mbu0xflQNs6g7uUfbV9WMxAF4+LRxUjYKa82bbo3J9JZg1/gFqZbqqdSTUt0GmCPSQayx3NLbKxRRgDwj6JpnK08o4WHq9/vuk9zh9xc1rElfZatZVtVd8laoU5woeYlw6jedY00BJ6G77Rp4UblzXVUjoEBNIhOT2w/iY/E+TJNv4CGOeuhdPBbGTmOrVtQKRPaSTHyLZ8YOKkYJETjaP5MJT3+jR7Ef9lYJ61P3gN5vmEwzHv7R5QoXS/GIj5eMj5DL+STvKU70Z3n28AAjKLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 08:47:42PM +0200, Arnd Bergmann wrote:
> On Wed, Aug 26, 2026, at 18:06, Christian Brauner wrote:
> > Note that the IBM Cell blades that shipped the Cell processor were
> > removed in commit 05bf59fbeef3 ("powerpc/cell: Remove support for IBM
> > Cell Blades"). The PlayStation 3 is the only platform left and nothing
> > there produces or reads these notes.
> 
> I don't see how you concluded the PS3 does not produce these
> notes: as far as I can tell, spufs on PS3 should still be able to do
> this if a process using an SPU crashes, and old gdb binaries should
> still be able to read them.
> 
> Whether anyone is still developing SPU programs on new kernels and
> would benefit from the information in the dump I don't know.

Sure, _old_ debuggers can do that. But new debuggers can't and have
dropped any support for this 6 years as I pointed out in the cut off
part. Similarly, gcc killed the SPU target 6 years ago in 10.1. So no
modern toolchain can build this. And the last supported kernel I found
is v6.12.

I deliberately left spufs itself in but I would really like to get rid
of the coredump special-sauce we need to have for this.

> > So remove it.
> >
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> 
> With clarifications in the changelog:

Ok, I'll point out that old tools can still do this.

> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks.

