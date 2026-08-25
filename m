Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42211C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7266B00CB; Tue, 25 Aug 2026 09:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E8F6B00CC; Tue, 25 Aug 2026 09:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4406B00CD; Tue, 25 Aug 2026 09:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22CBE6B00CB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:42:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1DECA2B20
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:42:48 +0000 (UTC)
X-FDA: 85139907216.12.6F26E32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8CF4140006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:42:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhBex4Nf;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665367;
	b=z/0qnLAZwOs/YA4tzcEEDmVZAygTuMPZKfw9FW/JFmqKj+3eQ/3SuJ1y8KjQmvCPOi0SMK
	ofb6DyAxwJ6eN56U9AqglazGRZq5BrPOPxCxiE+8I9mOxYYCfTR2XsSc9+/yVrHm3ex7yz
	36/v5NPnRS8ni8mPBOuBMG8/zgg0KMo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhBex4Nf;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAeO6nyzsto4THOPII8Lhn2KD/5f7sb4XDD8FP4is4I=;
	b=v3HvUSlI6Tr2KojYDVgExOsX94kly9hQTkX2QynNX/ayqPQ8wMnhgnR3sAlUfgzAdqIgih
	z/kKaWsUmuLErP0i9/pZj8AEwNc7XyOkgY29FdHbmjK2uYHIFTZuVbt+5qDRKyNotHbCZp
	hmlmAyJo57ukToGZvVV26wl2QR6L8lI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1771841A02;
	Tue, 25 Aug 2026 13:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D931F00A3D;
	Tue, 25 Aug 2026 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787665366;
	bh=RAeO6nyzsto4THOPII8Lhn2KD/5f7sb4XDD8FP4is4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GhBex4NfYPWHAIis5wTwo0tQjKG0lEFiWWqT4AQg20VnPw65oPAP/ZjSBF87ydOy2
	 Dj5OuprDFDH9S2asvTA9JHcSPvk0+8xggfaitkr3FK2GGKPGPl5xETSIR0dVpWvAfC
	 cXQWCNYrMYu/fgRgUR5Zwg91ussB2GAA8VT7l1VZgOatlF0HnMgp+XrUnGGSYJYzOO
	 Ckv9lrJOtp389yjaUjC80xmQDUkR/SqEJd1GkGSkqmgmPzC12z0nNoHBt6esAy6l9Z
	 CiXZuotZstCJD+E81JYGtDcC/6JESfGN+93090PCKU9OCWimw/uqBIYF+n9m7Re59L
	 RwiIpFdanGSRQ==
Date: Tue, 25 Aug 2026 14:42:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <ao2a33Xf3U0kQmM_@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
 <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin>
 <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
 <aox7tVIQBMuz-xFO@gremlin>
 <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
X-Rspamd-Queue-Id: E8CF4140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: an9myq7z4ikb575fto4w39tto6qeheoj
X-HE-Tag: 1787665366-528986
X-HE-Meta: U2FsdGVkX1/cBVBxP+/SZiVv566YU5kjgFDFXcv11FuYO4pHLS1+D/H4aaalwYIpFr3orM4zlw+6vyz3gv6Qog6IcOYFwMTgE3yAY1LbTwN3RJ4TycYeVMjm4Gd7hSE/+l4SowkWS/ArbTAluRok9GuS6R/3aUDGWBLLVbhDn2YRUngov/7tse+/bMV1zMxjKOYO0OSg0Utsj04wd0Qr4XA1QbGXPc0yhBGyQGaTOZHq27arfdN5UwNZta7q7uHhhDacdAEzJRnRSlHomFp0oQKRTvy0bi30O/J2C5f9jLHZdzGIXK8bBg2AyvJzYXgXQMw6+gOeWJpz5S8R+I3OaRRss1NIx3bzR2d+mJNB2WA5M4CyGdq1xiBXjapQ2TL2K+fyXVwB91TpRK/kGovMKC3s26eCUIf+TRYkJToSylnhziqiT8/dC6YK+exRmnk9IASTcOAc125e2GENebeMCNk0Jp7FswvUEWBcL0EjOoyujkybQAmOMjz5khA8Wdep13XZY7SV8jfGVijyn2MntMriAJfeq2Viq/YTHI7HO27Jebp44V/9Zo4BvLp8duftqhAtuRv3JADJQv8X0wq7ACXk9tbgut1pC6nU8HmCohrTPeujXlrj0OAv06sjCg5x/6wf/fmssEiWgy7hrgaQW399AIKRovC5Gt8HZ4cWKpH8MgnMC5eaO75bxsoRiiWYtYDpQObpJLKjdZCLtShG+1bxHGr9sM0n0a/+8tH8f028kuXrdxppc0xXm2x+VMRWNOEXgD4nNPs0UyXk9IIxxrH2ClWqGVg7YeFnU3Ty0t8JVbb/n5wzraMXSoTxkky+tYGRyoQAnRcqEzthQyXGsW/OFzHNMtr19uydbNttc4KZSB+oKJjUPZZUsBj6rTSFpGmDQht+fIwBGOaL/dBzUKmFWpkMfIWaYKxzVQ4XE/JHdxLj5F7oYNO8l0jN2/jJFrs1lMwXctcoSkI6S/V
 y8Wl5UCV
 75Ti9yL9sFx9em6siluynty4zF9Bs10eqG3uBvDbwN0N3/TyKJy65Ti9lXnKIiPBON5Cwnb8Un+E8pd5mAL3YKHHA07RVU9M1b5Ofo3Q8xUYjxilNFORuIzfs3NphGRPh6hJYvzV4+1LhVnzWGWD71Bh/a+uZbUvem4WXht/3J4PI5vFIe+Wfo/XbrhMpikQ2be7J9doqEzsdjmECUiUVumgqj+np1OMdtX+9GBn26ELtLGWEPNKFqp1RWfosk0WIw+ixdfox5Lcu2PX8AzABCB3Uu2U0neMmDEVFXJKlzsVCQnMZNYsW7/A4LQtR0cFn/nHnWivxDaAnCyBBclSNQbWpKG11eq+QtFiMqMa1Kd2EH3r/h9Vk+9Isp2aiWgJQpKd2qEv/dFbhNwpZAadDumRwf2a9VIU0IPYL447zX0/f1P8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 07:43:02PM +0200, Jann Horn wrote:
> On Mon, Aug 24, 2026 at 7:33 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> > > On Fri, Aug 21, 2026 at 8:52 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > > The sharing a /proc/mem fd seems like that's a pretty dumb thing to do in
> > > > general :) but I guess you have to protect against that.
> > >
> > > Yeah, it's a kinda weird thing to do...
> >
> > Yup :)) but I guess we have to account for people doing weird stuff...
> >
> > In this case (I do mention it in a reply elsewhere I think) it does seem
> > like perhaps you should separately check for current->mm != mm of (what was
> > originally /proc/self/mm)?
>
> I wouldn't want to do it for this access check, since that could lead
> to "confused deputy" problems.

I guess if it got the decision wrong somehow that'd be a problem? Or wrongly
OK'd it on one level but then that led to the fd being passed on assumption it
was OK to do it or something?

>
> > Or at least it seems like a crazy thing to be able to get full access to
> > another process's memory (that it... gave you though).
> >
> > Anyway perhaps overthinking it :)
>
> Hm, yes, though I guess that is kind of orthogonal.
>
> For what it's worth, SELinux can prevent such things happening across
> domain boundaries - it enforces that, in the SELinux ruleset, the
> process calling read()/write() on an FD is granted FILE__READ /
> FILE__WRITE permission to the file's inode.

Ah OK that's good that it's at least possible to check for this class of problem
so the rest is moot then :)


--
Cheers, Lorenzo

