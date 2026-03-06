Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EB1F01821
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27CC6B0005; Fri,  6 Mar 2026 05:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5FD6B008A; Fri,  6 Mar 2026 05:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE9F6B0092; Fri,  6 Mar 2026 05:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0206B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:33:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E15A1404DF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:33:19 +0000 (UTC)
X-FDA: 84515276118.14.B424A29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 69FC320014
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:33:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nUnODltq;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772793197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SX372gsHngThmrfckq7XKce4QK6G5m8ZuD4QCa4Jfas=;
	b=1eZeFTEoin6oZhFEh18WSK6QnCMAPzOAozXLsuj/ZQBzT6o3B7+haB4NXXDmdi03uyRNXJ
	SvgSJeQBcvH+WAF9mtAQWTWmjw3JSBE6Bq0DbrvV0QUag7WVteep1BrpI0WjIoVQe68Tex
	KzZBJRZ/gPuDOJ7D1beo0HlKypd/Sxg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nUnODltq;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772793197; a=rsa-sha256;
	cv=none;
	b=6K0oHJQgXzQAi0bi9jhmCVtIo941a3mHzbQKvYwKeTkYBGwkt14YpMD48eiZrV1Kx1zhhl
	Mc/SM9a1dM7LOuA/cBPC9NhnhvgcbxgUuCRdQpeUEtaTQuHBSRc3mQbbiuJq/mC/A2O/EK
	IZCoBEIA049aU20ixa2ulh5Cz3FafKw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D8A744024;
	Fri,  6 Mar 2026 10:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79A2C4CEF7;
	Fri,  6 Mar 2026 10:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772793196;
	bh=SHIko/MmFubMGiBXHMMBbPxNbS9V12LxaQpzaOqctRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nUnODltqfoLqHqMxgnCTP5Zlv86+in4QAeMF60Xg6MWJ3M1qEzUHqE82gOGpRiJOX
	 xwV7AVfcai17eWdMo2zUMFmyCFheOTCrkqCauQWW+8znWaJNdMt5VMkf3hCSkfv1+I
	 yj1zRWdwSDH/FPO5NayBXERQrPz2suZfkYUZu3HtwLWHnj3lY7icOPB067AzjGRrd+
	 lTEWVTnP9BA4tQ49BvPVwOXGAH8opdwqsTUduiFASs+Q443bxNTHc+Va9X0DTZHYfR
	 W58IDEtPvgkGuj5EB72FVXwaFKd2nykHwwCi8+tuIHMIlW5cxfQl0r9RZSjs0W0E5z
	 +ocDjp0HBi9RQ==
Date: Fri, 6 Mar 2026 10:33:12 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Huiwen He <hehuiwen@kylinos.cn>, 
	Jerome Marchand <jmarchan@redhat.com>, Qing Wang <wangqing7171@gmail.com>, 
	Shengming Hu <hu.shengming@zte.com.cn>, Linux-MM <linux-mm@kvack.org>, 
	linux-rdma <linux-rdma@vger.kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
Message-ID: <8f60e23e-dd52-45df-89e6-bcc256ad704d@lucifer.local>
References: <20260305103941.11f1b27d@gandalf.local.home>
 <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
 <a8907468-d7e9-4727-af28-66d905093230@kernel.org>
 <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
 <a21ea7c3-fbdb-4ac7-8be5-0173f54890c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a21ea7c3-fbdb-4ac7-8be5-0173f54890c7@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 69FC320014
X-Rspamd-Server: rspam08
X-Stat-Signature: d96sio15p8maq4qwa9f1xa1o9hgw9tbw
X-HE-Tag: 1772793197-487107
X-HE-Meta: U2FsdGVkX19za8GD209G8ykJEZiSIhur7AF04wReM/4Qzc2uojusU5z9y5I+1PoYkH25P+gf1pvgNO+5SVwThW0TB5kmMnj7LfjZC3Ks/uQf9/LYeuV3C2mOo6drUoXHplCypNG69N4y/3pv5+sg3pXmPF+G2rkpeCrji3TCt+CpZlVGboupWR3715CKm0MiLfajMwZZNPEWL5QdkW3UbA4FLBvLMj0bJShG48brDNhLnRlP0CY4rOZ4UdYiE0T4c5evxyNvJcdAEtnBDeCIl6g19UbAhgPXTMug5NqZYXWTkVaUya6s531g5HfWc52vmv3CsZtp9fteLyCPZCu38b1IxtuTxW3EGCUP0i8fWTOJcvwOST892KaC3FMnwBpSD0+RHvPhh+wrTA6rLYfKvQ+ZIULhh8AT8dPgKdj7HW3zYTWQgVamMOLkJcEUYxO4vr0V6YGfPJ3HLjzyRfcu3DOkZ+WFDPSPvkRWWvnz5ScjRXYawFXf2Rhm4L7FFxbro6FgEYbh/dUi89j7doTIuXpIjLRAA55C3T1Wu9eGwY6AL26OOdHNLIx9+03hLTdUCFjo45Jv1r9kzYmiWczvBqlk4PcKpMpugwNkWcvdWpKiNgn1PAJ/ZwR040+W5Wt3qipG6tXk6ltvq6mrGbW0yA9NOKYzywyx2pnj6hUD+Gocs5jXzbTPa8sOLL/lw+DSxsRuPcuIFB11dHEMrvYET4ZzUXbhHLRdzncWyAYqXmGXlSRWXQMm9YtD2/oJ+f3L3/948xhPmOjamLF8uprCjhJ+0dBTr0WS+nnj468wmFRmt1BXsO09VUUyrSyE979gE6rEDsHyaN0e/MDjSbWejaXXV9UJNqHc4aUo6u8+7xmg+ChXUphV1k20yBFASU2EhAuCAVJCksfK++mmdMoHdcWZfG1t5s4B36FhEI5q2uobjvYsHlhrEEp6Cn9t24UIfSsbDjmJlx36zofvH5V
 CimI89W9
 DCRbHT6bpGgyFB9nfO56vUnvQWgOUWZD3G08o/ES69BoaYxkdiyLQwMtF7uk65jo9MayYHl+7fUKqP23BgOVI/aVwaey0YMLji9pKVvL4ZK4CY5VzZbliKSglu32Jix+1zP30sm6JGh6dCuZSOgdeCBRKZA4yi3KGnLEzUdBcCUumiZP/o2q/CmGtLQIH3UedVJPxSj3uPd+Sb1h85/b+WBO1iCBqAOMGmAHYPVU3DR19VAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 07:59:14PM +0100, David Hildenbrand (Arm) wrote:
> On 3/5/26 18:17, Linus Torvalds wrote:
> > On Thu, 5 Mar 2026 at 09:00, David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>
> >> QEMU traditionally sets MADV_DONTFORK on guest RAM. One reason is to
> >> speed up fork(), because it doesn't need all the guest RAM in fork'ed
> >> child processes.
> >
> > Yes, I think the MADV_DONTFORK thing makes sense on its own - more so
> > than MADV_DOFORK does.
> >
> > Because it's a very valid thing for user space to do exactly for that
> > "speed up fork()" case.
> >
> > It's similar to how we also export a MADV_WIPEONFORK - for a different
> > use-case, where we don't want the copying behavior (typically because
> > we want the child to re-create its own set of data: I thin the main
> > reason tends to be for things like reseeding random number generation
> > after fork etc).
> >
> > So it's just MADV_DOFORK I don't particularly like, because it had
> > pre-existing kernel semantics (the VM_DONTCOPY bit predates the MADV_*
> > bits by many many years).
> >
> > Not copying on fork is always safe. But copying something that the
> > kernel has said "don't copy" just sounds *wrong*.
> >
> >>> But I get the feeling that maybe we should at least limit MADV_DOFORK
> >>> only to the case where the *source* of the DONTFORK was the user, not
> >>> some kernel mapping.
> >>
> >> ... that makes sense. Forbid toggling it on something that has
> >> VM_SPECIAL set, maybe.

Yes, I agree. It's odd that we explicitly gate on VM_IO there, it's unusual.

>
> CCing Lorenzo.
>
> >
> > Yeah, I think VM_SPECIAL would be a better match than just checking
> > VM_IO.  At least it would also catch things like that VM_DONTEXPAND,
> > and PFN mappings.

Some of the madvise() operations explicitly work with PFN mappings, but it
really makes no sense to fiddle with them in this case.

> >
> > So just changing the existing VM_IO test to cover all the VM_SPECIAL
> > bits would be a simple improvement.
>
> Ack.


Feel free to add:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

To a patch that simply does something like:

diff --git a/mm/madvise.c b/mm/madvise.c
index c0370d9b4e23..dbb69400786d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1389,7 +1389,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_IO)
+		if (new_flags & VM_SPECIAL)
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;
--
2.53.0

That makes me wonder about whether we want to permit VM_DONTFORK for
MADV_DONTFORK, it's kinda a weird usecase but anyway this is the safer
change for now as I think it's pretty obviously sane.

>
> >
> > Maybe I should just do that and see if anybody even notices (and
> > revert and re-think if somebody does)
>
> Agreed. We could think about letting it sit a bit in -next before moving
> it to mainline.

I would eat my hat, board a flying pig and note the sound of several trees
falling when there's nobody around if anybody complained :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

