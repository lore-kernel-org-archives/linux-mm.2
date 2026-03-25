Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F141B109C044
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604C26B0093; Wed, 25 Mar 2026 13:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5AA6B0095; Wed, 25 Mar 2026 13:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A41A6B0096; Wed, 25 Mar 2026 13:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8606B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:00:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A86AF140A5E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:00:41 +0000 (UTC)
X-FDA: 84585199482.01.6ED1E4F
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AE04100016
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:00:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cWac0d/V";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774458038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaBYe1JFh1ihg+ovqg+6G8vG3tLswtCr8fYJ4AXiZSI=;
	b=ZL63JBr9JG5bvnswpUMTN0tprmi+aVC23Bf8H6QBGPlUOm0LW20yhx0cL0RdsmjV1JZ0UO
	I0uD6ieSWuP77aXsffWIJzxF1qjsHiIZs9yRCvE4rDLThipDeIrEORN2aee/m6oc520o0U
	IQaj1NCRs/VBuM8sO40YSHraLr1orL4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774458038; a=rsa-sha256;
	cv=pass;
	b=4R/E51bx018sXchWi/ta29ECagKTZNlhiFNkx/rd4BZ839XjaNHJsSBnroPAoNWeRFJL54
	Q7ezoKzCyF6uGjSQ+ev/C6K/NgyT0OShxk7hVEBNT8f3x3EtHXLd9Xo4DHojaLBEjMMW8S
	L1nDgmaaQFonmv9GP48An9xvDIQcGL8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cWac0d/V";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38bf1561215so314391fa.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:00:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774458036; cv=none;
        d=google.com; s=arc-20240605;
        b=O0rcE/Wqomm7bm4ywqIYuDWQrmONIu04anqHW9yhOLE9dK+6DETD3vwI12oza6n3ju
         yjP/JXOdq4IVyp0spmdBkiMZikfMADDtwjjCoAcllHKq6wd+sIyQQtqQm3cY3A7a8q/3
         xBNRIXJ07CiXEbvUrbyKvGfOkMCRFW6CyvidleWBq66KwmEJpnAOPYzNI6xvrUN7QbXx
         JkSEpIG3bvCcVJzkjNSfUP8l7c9okaBQ+/dBZEQn0FgbJPNEpnPu1yMyOHjhkNiz//La
         QHHkUOLBRaysIcUTQ/xQSEK/Tg510C64NfzFYSvzxWMrozcYWRwufp5ZIVFRWqrXOSfS
         cqRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AaBYe1JFh1ihg+ovqg+6G8vG3tLswtCr8fYJ4AXiZSI=;
        fh=wTbTbvfoSXFw90VoaUvirYl8NZORGSL6lKifMRTiOC4=;
        b=JxnsxyJY/AgR7ORMzWWZ7ldI96QQh/ipkeQ4lUTzIaPAc49/tC4pVVk3EhvK8avGZa
         lvG+e+D/psTtTrSvarQ16VsQc+6mwjTZLg7ve8+Qexym/a92Th3EU0KceD2ED/pprTR3
         RctlQQvVy6eTWPiWef6DhIXFsKawFq6iSRo4xg289uA8cb7BQGWUd73L55j9me3rKUos
         YqXo38cXiB1wThzQyWF3rr8NdVrDsgeKC5BNdOM1uXHZYNfhQJ45DlpwrIomoNluGOod
         nLVRaSX00deN4JW73KxFVOL6htqRvhubni+VMq3bJVeD79uwTg5xe2RurF0A6ludG8Bw
         paAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774458036; x=1775062836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AaBYe1JFh1ihg+ovqg+6G8vG3tLswtCr8fYJ4AXiZSI=;
        b=cWac0d/VZIBxcBX968yZeYywbz0KN7F9qSbdqSFRg+4Bh9FkvtbOdkwldwFLGd+bbJ
         HOR+OubMhjKXO1fpe3DUPBfnuP1tOPs9Dx10HWCW7cKPzmHtspC74N/c/vD3ne1wproV
         Epi8FetoKdK4Rp8d4IFGWY709PhtpzHcAOxlZUGgRndnZSec89m4gglKYFlZY835AWQ4
         OqfyXjTHpmvrd1riB/Nhd1EFtw24S+AJDPROqOw578C2bMV5zYyCQ7GGa2XSvZHKCRq0
         A7iGP6YJv1ifn6ljaejG+3Xp53xZLEf8TlQqdH99gueND5w9lFT5oisR8RZlgDhBKhPv
         rctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774458036; x=1775062836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AaBYe1JFh1ihg+ovqg+6G8vG3tLswtCr8fYJ4AXiZSI=;
        b=NoHXnG2i7ne0YI6cUvYV1EYHvqkr5Jqm1Zfc3BeqJCnUd31vESiFKr85EodxPeF1Gl
         A6VJqJ66gXZ5qnWts9jqk2afjRf2KCmqsWYZZmXiHQb0G0V1qEda6eO5P1u4UYVcKcI0
         wudIc8txqB/UNvPR/uBiZNdLBFOBoZkGOz72cI4a7OxRWr2ODWsTfvoHXQvdMsUvG1Re
         kfww++sxdAiaIGM6GE7MrBdMbFrZbiXRKn8K2/iPY3EzPfV5UDOBny/D/RRNJ51BdrFi
         POTYnn1OySsZyAkwx1VT7AjEjpSoQWA3pwWulRQv0eQPj+7nOEQbdnnd2elQkB9P0Gfe
         W+dA==
X-Forwarded-Encrypted: i=1; AJvYcCWIuj5ZWOFF0aQEm9cnlbYgyyxPbSfGOPWYLd14LOmsJ6GiucA8twk+USmFlv82NCowXHV8cFXglA==@kvack.org
X-Gm-Message-State: AOJu0YyTWuUj+8u4yAuuAEoWlK7mHjAxdMXtjwS4JZ5bQ34gkQxcNkL2
	RDmRYm5lN/iLlJd4Jn5NUPav8oe+tsgePUSG5KB0SY2swo2blZ1w0KNomSZVyJ27W/nsT7di7hf
	AjFW2m+Y2pGYOofyEWGi0E9+8kAOeW+E=
X-Gm-Gg: ATEYQzxm+AT2D9DmUueyfdoaanA0hC2qZXlUFrcTmvU2D0ptHFgdms5TXYpUZkVB9dy
	2UtD/ENJPhzeGvWwgIUL34uEnTHW23ntkNvUNad/X0M2UMJqBt6B7slJhLeuoZyLkZsSXNqQxSd
	h1FeGqJzDqoTBgPobTlwWagkrva4vz5kYDq+XUSKeaRgIwjLWu0shRozR5xGJQwJo/UQyOlqsIk
	iz1wfOi4JPKUCqlJ7pCEiEYbXqEB1yil5O/dtwoVz3/BADHKwyJS+3ZezXpb2/B6OsPlC6vU+Ud
	NhZTPOU2
X-Received: by 2002:a05:651c:b14:b0:38c:45f1:1eb7 with SMTP id
 38308e7fff4ca-38c45f120b2mr12590671fa.8.1774458035732; Wed, 25 Mar 2026
 10:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260221093918.1456187-3-vernon2gm@gmail.com> <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org> <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org> <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local> <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org> <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
In-Reply-To: <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 26 Mar 2026 01:00:23 +0800
X-Gm-Features: AQROBzBD1fC_QgA-cvCOhQltzsLhM-GHcoeWiq7K2con3_o5A1_WbykGRWHHPPA
Message-ID: <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: kr3ya96j9uwk7hmrhgdwokogojc4es4f
X-Rspamd-Queue-Id: 2AE04100016
X-Rspam-User: 
X-HE-Tag: 1774458037-903617
X-HE-Meta: U2FsdGVkX19vxIhwph/0Ovv4uGYSNpGcPAykGmFYw7i66X/wXaVI5ILJiwGYwUWZpftnsMGsw1z2O8htLJCR7gldhnjQWFVpYl4f5XQGwPqCXLvza9LHEe7ixPf0k0yk8zbdMjCL7GUIK3iwFanQBG/Kdz92Tn27k6P0OyQpSQHUjR3u7jmP0iy7EMmOm3ubr63orYe5KhSu4usj8DE2v2rz3L77XWBcobVLnjaoPm+X25yxkpQ0tReuyiGvtR260VICQmfe39zxZ9Iwl2lO7EJogytP1B0tx6UywyWyvOPRPfYjqOho6C6dhQQdd1WLD7UjBJqP5nsqUF26FJOrLm39nahdcacOSNJic+WOxPi6sQiDtXQAWMi7TPsplrA5I0v19xYOZoAzqM0vdZavhQQaEwghtBVmVmDlmcAFz9lHQlg73NiIu07ZJsY10H3H2XpbUds5+mZreWLMFOxK0DcExesobwwuLc7fsR4OIRmqWl8Sw9wTBhzUMaHXtIvGxr9gX0Poq9MEi4bQrt34Rf1BcpOYEY8LT4AIaKX3y8VNb8DuSJvFgaA23gExCVeY/dlDrvazqM/rnigISQO1RLdggMgcIXU77ZZKePs3X3ZDXOd8GfvCA88SqBLf27VZTVhcGLVkyhPm2qixG+NBc8++9GgQxSQViCKWJYgrmBLELfrzSeck5CFoWBsRw7DAOb6Akt1uXbNUN9wGGfAu+IjAcJQNc7KoNYDjwW++hwjHnDojCLmo+HBU+s2hqNrk6g5b3sDGhIXZnlv4INUIwarCGIuf0/5e1eqiLWRjWoSRW+xPuTGIWv3VyeDKgCwlsckmtussMEhqKt8k7MKGrechUpe6NXWec0cch1RoXw1RSstxHtKK7hjAtDxLhrX7fvuGL0N9ypvRJwCdDt4+j5pbHnSNwKls3ey0KDyGptRT1Das8GVVfQp5B4FP9z5kJ1cw4bpiHyig9KCId/g
 dn4YCRep
 I70cVnUREnr3sFq93BE/i3A2cMXJie5LptFm7Ez3zO0zb54+gCHY+3PaOisQNHvRAB3t9qz9iuzUKxIoO6bKCB6PDQnIZxltsjFji8btqjJWIFXKqEBuQBLkjr9AWAvknDdsR7cAJtkQ9ulFwTF+nJzKG+DhXuhVEGuz80v/T1ajHHfF1aPItcGJI/R3t8DJZ1Nk2dMvV+g772LGpD1+WA6eSPMiqJz5VuxyxNbQCYFAZYbO8vAiQZxP5vjP6qEXtvNllDeBcEGNCcqhCyfFxnbD00twTaiM7WyMrC2P/2R6ekdAa4ZL6Q2Rt/tQBtdAI68zZX2fIktdYCV35E37VTjIVZZ7HoQPuOlU+hkl+TO5t555sFCSJYUjindxpB5dyLICPDrITxH5c5EIRicFCGqwi2VKzHz0id0E32lzerGQKl2QFaYk6yuEhlI0CRv8dtz3pU+GRT2sTeExE7S4Z103UYhiPyBpaOOvwOuMhsroz0WIgMZiBV+9euA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:23=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 3/25/26 16:20, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 04:17:21PM +0100, David Hildenbrand (Arm) wrote=
:
> >> On 3/25/26 16:09, Andrew Morton wrote:
> >>>
> >>
> >> +1, I could have sworn we brought that up before. :)
> >>
> >>>
> >>> Oh.  I've never really received that message, at least not at all
> >>> clearly.
> >>>
> >>> I've been hoping that the -fix patches are actually pro-reviewer, for
> >>> those reviewers who have looked at the previous version.  A full rese=
nd
> >>> of something you've already looked at is quite annoying!
> >>>
> >>> I try to mitigate that by sending the
> >>> heres-what-you-changed-since-last-time replies.  It's a little more
> >>> work at this end, but that's not at all a problem.
> >>>
> >>> I see a couple of options here
> >>>
> >>> a) I can fold the -fix into the base patch then send out the
> >>>    resulting diff as a reply-to-all.
> >>>
> >>> b) We can just deprecate the -fix things and ask people for full
> >>>    resends.
> >>>
> >>> It depends on what people prefer.  How do we determine that?
> >>
> >> I like "fix" for smaller "obvious" stuff where a resend is really just
> >> noise.
> >>
> >> But for bigger stuff I prefer a full resend (we can still have these
> >> temporary fixups, but for reviewers a follow-up resend is better).

Yeah, I completely agree with this policy.

Initially, I thought it was just cleanup without functional changes, but
I didn't consider the new reviewers (haven't seen the previous version).
Sorry.

Although this patchset is already in the mm-stable branch, if we want to
resend V9 version, I'd be happy to do so. Please let me know. Thanks!

> > Yeah, it's really about being able to come to a series later and be abl=
e to
> > comment line-by-line.
> >
> > Really larger stuff should be resent I think, esp. if there's multiple
> > fixes in the series.
> >
> > A reply with the same-patch-but-with-fix-applied would definitely be
> > useful!
>
> Right, for completeness, this is what we had in an off-list thread:
>
> "
> Not sure if that's a problem for others, but I got the feeling that this
> escalated a bit lately.
>
> I know, that we prefer fixups to sort out smaller stuff. So far so good.
> In the last time there were some series where I was seriously completely
> lost which state of the patches would go upstream, or what I should even
> review, because there were just fixups over fixups.
>
> Fixups are nice, but for someone reviewing a series, too many fixups
> (either as inline patch or even worse, as independent patches) just
> causes a mess.
>
> It also gives the impression of "this is mostly done, so don't waste
> your time reviewing it anymore." --- "just the finishing touches" ---
> "don't jump in late and cause trouble".
> "

--
Cheers,
Vernon

