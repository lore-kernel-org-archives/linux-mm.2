Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E534108E1DC
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9D96B0462; Thu, 19 Mar 2026 06:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA836B0464; Thu, 19 Mar 2026 06:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1724F6B0465; Thu, 19 Mar 2026 06:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F32BA6B0462
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:27:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98B768BA88
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:27:39 +0000 (UTC)
X-FDA: 84562436238.27.82F8FE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14727120003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:27:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q9unHTTO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773916058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZ2lKabVqASoGtP4BpjW65fcad/ukajUr/T5RjJHFf8=;
	b=UCIQxyqU+EUxu5qHWYpOPGbajpDtnHeKGOqSiMS68Onk/15WbADpBmbgm7IzbUaMxpg0HI
	4HL/9Irx9a4MG8sF3JjdlH2Rv3wQ0G5G29GyqYKsrJXqjWEYqFiATPSYSesvw+qDJCTnjj
	+JWski3DHmuuL2mEOxMWW5iSiKhFHfQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q9unHTTO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773916058; a=rsa-sha256;
	cv=none;
	b=SC/ku/i/O7Rgc97i1sfm0eoC+tzqOHsVVpydfU/jxtvwCPzdekONTzb+1nOaXRlnp/KyY4
	sEgH0QtV6M5+7Ef81XSIwH/ZpomQVbIo6iNuzuomtxBxEn1VLUWxogEBCAyW7ai1tmHZt5
	fWmGhYHFPvI03Z1/wYzMuaT0WhkVhvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79341600AD;
	Thu, 19 Mar 2026 10:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBB3C19424;
	Thu, 19 Mar 2026 10:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773916057;
	bh=xZ2lKabVqASoGtP4BpjW65fcad/ukajUr/T5RjJHFf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q9unHTTOwwuOpR64TcO82yRYzZSNM/mn/heTsgU25jM7a5rBiGahBXXh7cGoas5wl
	 jwSzSh+YwuM7KM5scaWAqQp8vTMhysJgqrcsCIJXJIP5+yPbgVgqUzclUBTBlvhBsT
	 jZR46ekNGjB7VQm9t+R3OA3epVp1I6fz78yjdZRGot71tQ2ChVly9Qv+CpHUnz8W0o
	 t7NP8vlRnL+7YjcWckBWl597QwN0fIneA6XYZ0rbRhfGcO6MyWNQxnlGJV5LN5KIAe
	 hQR4+oT0CQ2Oc9S33dunguOpLYD5HPcRWD7R1fiwOAu7lTLPCAoSEkXCMEfVyhAwxv
	 SlYZbHq4OqNcQ==
Date: Thu, 19 Mar 2026 10:27:31 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, 
	syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>, willy@infradead.org, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <ecedbb39-2df6-4300-99de-a56c7490c3d9@lucifer.local>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
 <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
 <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14727120003
X-Stat-Signature: tjcgr1rwnbr8z1r4dmpf5jmz7ey48itq
X-Rspam-User: 
X-HE-Tag: 1773916057-387750
X-HE-Meta: U2FsdGVkX1+trUf3BTuNF0nyV+MIuC1VS29VpaCHT+LnHZtsSdekATwZ47XnKbkzgYWY33v6bzvJ+5YuobxWJR4ojGifvcVTSRmupKlCHqF1unOL/CUhJ3fSE1kuwoQtFlVh8VBTQTuM+7rRgEvTW2Y3Vi3vxntO/ZIvPo2EOHKvFpNojiS7Kw7mbYNxlIpB2gP47KYc1d7wsCbxk3ji49xNhfjMASJigzvOBRLRDJkZi1X+tvFmDa3CtRBQxwrbYKfQ6+vMdFyF4AihA/ikyzxaZ4ahIREgaZokbw/Ril5hGIDXWfeH4nLgdRcw/uAnUjen7LeQb/H1uJDixLn9qi8cJr1GZXMgcwYIj6wAKiZ1+gDQBFAVwKQwfjSuuqikHBXPA/dcyOoxcVaadZq5prHxzFPcf+0x1/6zKjF83bgIWR3fdRjAG7iyS8cLq34gOes5wsZbzSuFhbK1AbrS8pUVfuSYzfF62HlK7/FkgmIFUkb8BVDZ1GliUoAE0s1zv19VIYyiMHCEc4zGRdfo+C9vF/IDg/CqJxl6VlyzsFgExFSfiHu22ODrXFj8y8gzvoIjTVoT0Pj0xqidlqMxwXPOkn95VbPF+qKR2QevUr+3qXO3nOImJqDXgwU2HF1qoVQZgy0LbIgsIOvn6ZyCEQ9keRU7L4oEfSV45y0YUVPyqn4pHpimQwX4lv7YKgGQIWSbx2vW12VIKZnA+3E79d523dxwwDbHmA5bhPud2Sv9Z457oUjIMH7mhDXl9Qf6EkR9dk3Z3DbabHmwv8I8r4hVpO6SX2PFgLvQ+p+JNuK/zJzAVLJVgaI3P9ociEnlNvmI9dzcGXv41P86eyQqyTn9Xf/zrA0F0nSgvIqRA0BPCgscbrwbZeCUdxI+B+vwsIQRsOWw6i9C+8FhVp9Loa4F8G5Zzy+UmqriAdW5WEzpH+Z3mgVHlEIAEXp7NfNA329tgc3xevvdQT3PKrf
 dEsSyqml
 qrqcykm6+08bmj38mBkKrvxsoz/Un/f3IQUqPVkAhfGeupkvmeaeJPHQU5pBCVEiaCkveEVnJbYbkd5WhZENwPbxLgHjuPusX2yoclVvpZOo6Hmb5NS9NbE1roknJVuPlb9unVAr8X/FHLufIbGhgYjgymTq/AeST/V9deIuWNH/Czjk5YXOYhSGL5x1heG8X0J1nyF5d3Y6IQuvsi4XRJqGCBG1zGb8obe2ssR2Lz4R81KvPfwuMFXDg4yV/xrxdlUBAYKut1gsHqD+okVplRg2yiLaP0lAgz2OPL0y0kRYRwylh1YjtZpdDg3wwOmUOaS3wCWEtObInYKVtYe2uLW35cLgoZEbWAYmorXiov9AkfXDhpj0aoG4mV5Q6avFeNYHRyhBW6FYPxFmlFnUdW6kbAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:21:40AM +0100, David Hildenbrand (Arm) wrote:
> On 3/19/26 10:14, Lance Yang wrote:
> >
> >
> > On 2026/3/19 17:00, David Hildenbrand (Arm) wrote:
> >> On 3/19/26 09:53, Lorenzo Stoakes (Oracle) wrote:
> >>>
> >>> Hmm we shouldn't leave this bug in place while working for a fancier
> >>> fix??
> >>>
> >>> Can we get _something_ going as an upstream fix? We can improve
> >>> whatever we do
> >>> later right?
> >>>
> >>> David, thoughts?
> >>
> >> I recall Willy mentioning that the issue is likely a false positive.
> >>
> >> IIUC, that commit is not upstream? So it only triggers in linux-next.
> >
> > Right. That does not appear to be in upstream, I only see it in linux-
> > next :)
> >
> >> Which means:
> >>
> >> 1) If it's a false positive, upstream is not effected (no XA_NODE_BUG_ON)
> >>
> >> 2) If it's not a false positive, upstream is effected but does not
> >> trigger the XA_NODE_BUG_ON
> >
> > Yep. So this particular BUG_ON is not affecting upstream directly.
> >
> > That said, syzbot will likely keep hitting it in linux-next and
> > generating noise for us until it is addressed there ...
>
> Right, I assume this comes through Willy's tree, so Willy should
> consider removing it for the time being.
>
> --
> Cheers,
>
> David

OK guys you had your fun, yes I misspoke by saying upstream, I apologise. No
need to go over that repeatedly.

However, linux-next ends up in upstream unless action is taken to fix patches
heading there.

We shouldn't, really, be just ignoring splatting kernels like that. At least
that's my personal point of view on it.

But anyway I really don't have the time or energy to try to track this down or
push on this further.

Thanks, Lorenzo

