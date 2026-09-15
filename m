Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912BDC88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B55A6B0088; Tue, 15 Sep 2026 13:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DD06B008C; Tue, 15 Sep 2026 13:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9F06B0093; Tue, 15 Sep 2026 13:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 577CC6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:53:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA242804F1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:53:58 +0000 (UTC)
X-FDA: 85216744956.15.62912F4
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 00E4D20002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:53:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=dscaF1NX;
	spf=pass (imf03.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com;
	dmarc=pass (policy=reject) header.from=hallyn.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789494837;
	b=SjYPC3w4Ved9snJInWJezeQ9lBQRp9o0wJaFY2vunwOpMe8rGQiqat9dQyoyVb5gz01LkM
	McK/6wm5MZWt8HGk65KjQMc7DcHVBnMBA/l6+42xT/jULN7M7ZZQhK8UcPIG5zurX7lxjy
	bLB5seiXug7OG0CtutwMGURaqY4Klts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=dscaF1NX;
	spf=pass (imf03.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com;
	dmarc=pass (policy=reject) header.from=hallyn.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789494837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fbPS6aU5dW+V76D6k+gZ93b0IuWYVZduGauROA1oJI=;
	b=PHAywM8WKc06yVbAa+iT7MA6cGeki9Ue4dAil2+3UoDJqcm9MHZ5A/pcReBe5rXZkV6mQ7
	BLpNErETfI3jgv89B6ExfUbpKTMakBl714qPcyP7zcxpcI/Twcv0thACtGiUL+a+2O5T2s
	xXyrOY36i9Vfqsgm844f9v012xO5nz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1789494834; bh=iIZLoDqXxMktAMEBaIDCQ5iIRG2C1WV6/eMK4NZLDg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dscaF1NX2NbXq+YtHK3AUKzHpTOJgr3cDN1KoC28VPzOGgJnIOEkdSWsE/FZj9Tip
	 TC6/m4mLqKLIzClBUmNnCvhwU9U3DbOUHJCXmPVjHCazP80EFfz3WnOlHZYpR0EwLn
	 Xsd63CX8GVUcnxt31CLdzzQ3tbY3lL4HzSRSQLgXG0uxaPX5VrTHZgLeVFp63+gNFV
	 nSJGT/TbBZr+nHBcCjmGy6DQDDAHtN6hpDlHfozn9VzePQP6hPzqbvclSK1pqTFiBg
	 By2ADcD6C5yaFnZhO7u7lGM99HoZ2RO3vgIAGG7+CU30ZDPGOOkGOCNWcK632EynYY
	 5paIVEPOdY0fg==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id B602B5FC; Tue, 15 Sep 2026 12:53:54 -0500 (CDT)
Date: Tue, 15 Sep 2026 12:53:54 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jann Horn <jannh@google.com>
Cc: "Serge Hallyn (AMD)" <sergeh@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jeff Xu <jeffxu@google.com>,
	=?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <aqmGMv8CtkCVmyNu@hallyn.com>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com>
 <aql6gyQJoxEjx0xY@shallyn-amd>
 <CAG48ez3THXFA=jF_R-wRNsEA=BfD8X1=pHm7dtVnbOto+rXW3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3THXFA=jF_R-wRNsEA=BfD8X1=pHm7dtVnbOto+rXW3w@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00E4D20002
X-Stat-Signature: 9rpmdnycg4356ngffgps5a6uyd9wugrk
X-Rspam-User: 
X-HE-Tag: 1789494836-706445
X-HE-Meta: U2FsdGVkX18I7G297iyZEL/7YO3l75ITGO3Y5ColYOBHa5SRfNJCAJd9hH28ps3GgvJvBGkovNBXuL1GfZbpb01JhsycbKgkYtYyH66IwGM0gC2JzVnwAxJgPMCLQZBMKxjmNGRZ15O13pabPwkcPQxd1mC4+CNrySf6fJ8U5KmERZb1gcSHEOAuF3Vo8cuJxfTSIJFDgQgo5yP/Pg/+EgupVrc+xlxG71dduSWSTT7GDSEWFFS0WWN1CWEqBFBSpWWcxDu/oBm7N3W/48Y8D6ikuoj/AW+koykiWoIccwd1vWXghFrToIwlBVQ/LpGypwCfRcHFDL2Hq/h1uIs1YgXxuwjX65I/AVh1/gwla+VCMaufuYJSD5UbArm9SH+ae0HHJ9n0wDxMYXatEsPiE6mgWE3zUCv1PnzImqLrX/X52USyAZRGw/czGfi0wrii7tp6ys2yJO6xi4FdmtXzQReJhqCMbotpG8PivHgXkoIt9+N2EBgt+BhdyIC5NKpfT8XRTRp4HqRTLoccBP/GX4qFxEtmt6Z4S99CUjulikJF7oEQfxMnUWUlSjgTFf2ZMA2RYMkA5SkyrSFTzYz4aq0C7SDJ4RQwQ3D4Xz+tPUAVcRph+XNvQUroO/A5kMSxrtrYVu1vX8YSYYUfk3F/WT/DiPSUlM8JI5Fj+hOtzY0nQVxVR7RISfR8dxAwy79LqitUkpLjMdig5q6WiaMtceoBEECmAy5gjADgwQJ+UWxrOALGVjgOphYW+xoRkZTO924XY+960JbASJ4bflG92nIru+reJGM+fdGvd5J7MM07yFHJZNCpOxft8e4BMjWPAn7HKsfxhrVlBh3cN/yMZ+fiiyDVX7uMVExD6l0CTA/XZ3ESzjxYLvpayABlZkVY+e8qK8hII6YoJ6qSt21iZgxcw3lfRfN2Ox+91FblPLfRmoAMghF2JGG3/z7aKh5x7w/eZkQg/TM4MI4NMgU
 3hMIsbN3
 8dTZnnyUdWHB9jPVpmqIOZ2S6fgWwYYTVzELpI1/ihd8CzvAvhuZDPPwpQOfnjUduNZ+9DkuP3hhydr6465g+jS+buiBAESVsXdAlhMNfDAYRcmjtGDtHRypa2T57xucSZDWT+tA3FOqL0E+4PEuRaAHm2ZraOLNAUdYYFzC33krzBNt/NUshQ8HJDivj/1ukA+g2xXuQir3joAIERJKgeHkHVifk4/CwA9mqCXZ+nb1kGDuKJD5pUKxOkal9N+i8p+TTULhthyuqhlBbPuGmckHr9mhFiWO0nWyKzSjji5WzR/25PIy5CZQGtAu5tLs9b6iCJtrC3omCCAx4yQlugDQDsWeN4W5xleOMqDSOBDnbGUKxzS4eYz1YwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:44:23PM +0200, Jann Horn wrote:
> On Tue, Sep 15, 2026 at 7:04 PM Serge Hallyn (AMD) <sergeh@kernel.org> wrote:
> > On Mon, Sep 07, 2026 at 11:00:17PM +0200, Jann Horn wrote:
> > > +/**
> > > + * security_mem_foll_force() - Check if FOLL_FORCE is allowed
> > > + * @subject: credentials using which /proc/$pid/mem was opened
> > > + * @opened_by_owner: whether checks on open() were bypassed because the opener
> > > + *                   has the same MM as the target
> > > + *
> > > + * Check if FOLL_FORCE is allowed for accessing process memory through
> > > + * /proc/$pid/mem. opened_by_owner signals whether the opener's MM was the same
> > > + * as the target MM, meaning the security_ptrace_access_check() hook was
> > > + * bypassed on open().
> > > + * (Current current->mm does not matter for this; for example, if write() is
> > > + * called on an FD that was received from another process which obtained it with
> > > + * open("/proc/self/mem"), @opened_by_owner is still true.)
> > > + *
> > > + * Note that this hook is only designed to be useful in the opened_by_owner
> > > + * case, where the subject credentials effectively also describe the object.
> >
> > Given this, would it make more sense to call the hook something
> > like `security_mem_foll_force_self()` and only call it in the
> > opened_by_owner==true case?
> >
> > I only suggest it because it seems to lower the cognitive load
> > when looking at this code, so it might make it easier to maintain.
> 
> I agree with you, and that is what I did in the previous versions. :P
> 
> But given that two relevant maintainers disagreed with me, I changed
> it in this version.

Ah, I'm sorry.  Didn't mean to dispute a prior decision.

Sounds good.

IIUC it's already in a tree, but for the record

Reviewed-by: Serge Hallyn <sergeh@kernel.org>

thanks,
-serge

