Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14796CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5CC6B008C; Mon, 24 Nov 2025 20:10:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E6C6B0092; Mon, 24 Nov 2025 20:10:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CADA6B0093; Mon, 24 Nov 2025 20:10:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB3C6B008C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:10:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E90104F678
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:10:55 +0000 (UTC)
X-FDA: 84147350070.27.9931C66
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0658210000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:10:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fW1t6afC;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764033054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsgChq6O0wKjJChpqYW4kr3HbE1+hmbVANep3Kkz0K8=;
	b=ZI7tQk6X0WkEK+Y3ldwUiyjrqpMBJKFJaXbjnXRWEPIuBH3WYPdLCFb8oFaHJ8rb8kiNVh
	S6ANNtqZxyBtT0vu/oVmeETQ/+39qqAEBHbrUOYxA6a+3Dym7XATso8S+p3hTBPu4GdD/I
	D5RaZAnul2I87EHfd41U+k6m7TpeWEY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fW1t6afC;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764033054; a=rsa-sha256;
	cv=none;
	b=ofy3Hwl/t+gFQPXzTVzZTeoV7Ea+Hd/GF7Da9AVdZl6a2x9BHlJHOpoZgx88UrALCC5bVq
	H7DaSedvfxANrqVG1Kepl7tSIpM8lyOHXcjQIBxKfvHM58dIdxCnnjV4WXM8/t0YdJ/6kL
	LD2mPo+QFAFhA4gVx0TQtRUggwKhsgc=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee1939e70bso47534231cf.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764033053; x=1764637853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NsgChq6O0wKjJChpqYW4kr3HbE1+hmbVANep3Kkz0K8=;
        b=fW1t6afCd/mRCK9Q3X8Q4ETJ9durrPG69WDl9ah1/43t/jDIUOW9bAx5ZLKJWIv455
         11GyWfLc3AJAMeHEZvatZ5v5ekfh2waZ0n2F5vo/E/9eYqsCpK1iQkzfft4/YeLLtr0o
         Ac/saQ5mOQHy7/7GC4Mw3lrlpgV1C+1tkloFTrUvvKyEBaf3yY89t1lbNQAITNO7h9IO
         5wp1tTcE+dqIb6BsjzTWYD6LmXOWU2a9/04CH/PlJ7+1T7a0iGYEVcfyfLCBoZsjqrIh
         GiEpa3oRPH6QNv++WI3o2ktY9+DjkRkd5N7NNX4InuocaEJXw+cdM9y+4esCSLtQtw2r
         bEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764033053; x=1764637853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NsgChq6O0wKjJChpqYW4kr3HbE1+hmbVANep3Kkz0K8=;
        b=CYficwmw0ap37rEMyEBPl3VhUqWkr4EX43ESvzJBiiWvAh7fLpuiPJQbvWOUz6oQ+n
         aAsH4KsJizWqGq8SrFrB3qpjAsplEGI0/CF2+d7zvkVEpqbcWozYgwkh+xaOCTP+fTut
         VERN5D7OMcAdTPmblmj0rj/7CfzPcYmYStDnGaxMqYVQ4F8YTGvLIzhAJVDKNW95wHEr
         Z1QMNXRGAVhIWKFe6QzKb/YuiSvEL5EsrCG7JPthdwEoPa3FSJ5PjMBPNNiO+/C2XJwD
         o6zpc0EDck8XU8MYnvNRciqwkkixbTNk+nBkMmGMXWArZxKBdhL/J6WBWEtkMJJWO+HV
         c/CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcOt33USpAYFT1GCyRnuKrvNek6/sN4gRxWsi/omdmL9XPR3e29ZagecvKY/QmG4oEtQekh+rEQQ==@kvack.org
X-Gm-Message-State: AOJu0YwQXzKYcN0n2HcVTIyOFeTr3SZBmgeq0rqOlR5HJVXleutSiDqD
	+4/4daxO1sEeWuw0tGYVIEOICEzu4zmEbTfQAs3K4EwoHCgnXQJ3+2ZMaWqAWcEsp3bfusYf+bE
	YF+BRxKb055xUGM1aD8mFgDFy9gPplFc=
X-Gm-Gg: ASbGncvc2Af+pLHPEMvAxtqHJts5FsdS2J/biboLamUkZ3DCTENIgV/Y2X9Y0tt05q2
	+WuNyu6Fnh89thVxT0Ehp0c+vjfVJjgEtRATbTskyOGwFEf0b/ZRvja2Z9fQ2ohQfzbJT6MC76J
	TDsvn/xbhSi1j7MUGDok5iAAdIyiT4co3z0LzfKwFy0+116EX6REhqPeVoLSesk/k02AGGxlwLZ
	86Da+GdhbbQSpcGv4QAEmbX8ShEf/HNN11PeeJrHGCsL8M6tNh2+KdfGIKAiEgPiZQexw==
X-Google-Smtp-Source: AGHT+IGZVKMiOfKr+qR5oAOuuoGjPw3a99Gd8R5iy/goYmjUN3mlBPM3amn8zp6bIqVzLx2vLsce3VFkRzsep0Dwiqs=
X-Received: by 2002:ac8:5790:0:b0:4e8:92ff:753 with SMTP id
 d75a77b69052e-4ee58821e17mr176484991cf.24.1764033053038; Mon, 24 Nov 2025
 17:10:53 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com> <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
 <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com> <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org>
In-Reply-To: <f8da9ee0-f136-4366-b63a-1812fda11304@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Nov 2025 17:10:42 -0800
X-Gm-Features: AWmQ_bmmIvZ3_5WG3LWnwaKKEddKemGd4go_OocJaMHW8jVM0bwo8vf-i-aMZng
Message-ID: <CAJnrk1aJeNmQLd99PuzWVp8EycBBNBf1NZEE+sM6BY_gS64DCw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev, 
	athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0658210000C
X-Stat-Signature: w7hcysprxqwgp5imfg4g8eguorxgyha1
X-Rspam-User: 
X-HE-Tag: 1764033053-603087
X-HE-Meta: U2FsdGVkX187hTV6gB14URCMAf2vxSCy1Vk0whbURCSYvz7aX/z64I/u9mvAXxnja+AgGfEVRzJ3I3/rgHCKF8z+KNc7fgknHACm2d1a+9b3Isjts8bddtD2/M4sOvUl2a8qBal9S9L3MyV7NnKFVSIapZYDXSxWVSmaboEziGdelZMRJtpVyC9XAPApbvoEGBzhkuaTnpFm/mfVld8xav6FM1UVTv9y+lyfvojYVJiTpG7TdsFU44k1wC+pUyL9cL8FZ49o41fTWQlUqxviQjo4+95Sy3N7WVFgu23pPcP93h/U89vcoCujIoCTodpqj2oQlGHBUoE9zS92//sKiLgGYsUvLOM/CT25kj8ImMAp643mE5B0qzpoJqnJLQ2wy84lH9abuOKzNyVIvRt73Oh9OsNquqOKwjaPb8WPd6rFakDPaLRpM0fGxXJa2s413b8ns7SJnYaKqFXwoz3NCgbGEZqoai+BctkV/t4cuzxvkKAPFLijL5VDyYR8TfE/ohGGIpafbAEjLnLA4AVSETT9PloEoSeMMyL4RWyXNvRoZUNFPf70HvnJDJVzLjPqQD/Q2wt8CIr9ho4TnGyWk9+xqzWDCbAXA6B7jXSPDap6s9sUcx0OrNUwceSLISCpW9qPcLatlGafbqqnaGBHvCl3Uavj2VDpXWkfNlR7iwGL9jS9PSPuxeUQNYQLiRlUHsokuf4KZzCoMPS1lSUhISoUBtFxr07ufOaMgH+rqatjdhYHSOKaSS9zNJVstaPpp/nsoIJbSr+Z3ZdfPUqMFUb1tLuuDihNPwR0wNnp++VlQZX0CeXlk+TD96kNc1XsbOSRHw7DyWgPOG7J0nWKrfQ/UUXi2db1W/MD8roXsAghsAE4p7fe1pJ1rlMUvVwvuXjnP43HpqFdakzMlrsspZpbYqgDvGvbSlSkWEh1ds120QqUthr0JxICmNJELSTO7Dpc+r4yrvgYq6ilzxp
 9uBhkAAP
 Ilyroqv8/iL9oLSyw39k07BhJTSxjabR7NCaQQNg+NlxAvOOFQFBPqKQPc2RlUgholSAz7Bcdme/sl26GGinEDDwdE7i4M2K17RQ0xE6grQSdmwhwpF28b3IUskwq2d0jre6WLuJh4pZqLP1XDW3+YRFMIEX56YiH4JexuZ4zzs0mTMeJjKnPVdeBBMOAtS3G0fTMpkMs/F4XBD5ae36kZ44x6yJrvvxUjaM2umnX5abIsHCN8WVlIJnmtgV6bik/LN9r+jPzZZlRNtOi0nALBNl9ikWQ6jYmDWR4N5xb3wdVJs8EjAHVy4azfEjS9z63IYTIqDR4EiyIa8C80z+nHorhFZzfPMf+hm3Dvg6SdK8Rz4moawT8ADfnB04jUN1UaSmx7qtb/QCRLnxiSK3rgUMFMmGT00BJWlpfq+ppems4GuIXUIV2YWxL0Kt08H3Kg9YEv66Coua4qk8gUDTR9LeP4ujTFhjLevrW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 5:58=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 11/20/25 22:20, Joanne Koong wrote:
> > On Thu, Nov 20, 2025 at 12:23=E2=80=AFPM David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
> >>
> >> On 11/20/25 19:42, Joanne Koong wrote:
> >>> During superblock writeback waiting, skip inodes where writeback may
> >>> take an indefinite amount of time or hang, as denoted by the
> >>> AS_WRITEBACK_MAY_HANG mapping flag.
> >>>
> >>> Currently, fuse is the only filesystem with this flag set. For a
> >>> properly functioning fuse server, writeback requests are completed an=
d
> >>> there is no issue. However, if there is a bug in the fuse server and =
it
> >>> hangs on writeback, then without this change, wait_sb_inodes() will w=
ait
> >>> forever.
> >>>
> >>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and inter=
nal rb tree")
> >>> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> >>> ---
> >>>    fs/fs-writeback.c | 3 +++
> >>>    1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >>> index 2b35e80037fe..eb246e9fbf3d 100644
> >>> --- a/fs/fs-writeback.c
> >>> +++ b/fs/fs-writeback.c
> >>> @@ -2733,6 +2733,9 @@ static void wait_sb_inodes(struct super_block *=
sb)
> >>>                if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> >>>                        continue;
> >>>
> >>> +             if (mapping_writeback_may_hang(mapping))
> >>> +                     continue;
> >>
> >> I think I raised it in the past, but simply because it could happen, w=
hy
> >> would we unconditionally want to do that for all fuse mounts? That jus=
t
> >> seems wrong :(
> >
> > I think it's considered a userspace regression if we don't revert the
> > program behavior back to its previous version, even if it is from the
> > program being incorrectly written, as per the conversation in [1].
> >
> > [1] https://lore.kernel.org/regressions/CAJnrk1Yh4GtF-wxWo_2ffbr90R44u0=
WDmMAEn9vr9pFgU0Nc6w@mail.gmail.com/T/#m73cf4b4828d51553caad3209a5ac92bca78=
e15d2
> >
> >>
> >> To phrase it in a different way, if any writeback could theoretically
> >> hang, why are we even waiting on writeback in the first place?
> >>
> >
> > I think it's because on other filesystems, something has to go
> > seriously wrong for writeback to hang, but on fuse a server can easily
> > make writeback hang and as it turns out, there are already existing
> > userspace programs that do this accidentally.
>
> Sorry, I only found the time to reply now. I wanted to reply in more
> detail why what you propose here does not make sense to me.

No worries at all, thank you for taking the time to write out your thoughts=
.

>
> I understand that it might make one of the weird fuse scenarios (buggy
> fuse server) work again, but it sounds like we are adding more hacks on
> top of broken semantics. If we want to tackle the writeback problem, we
> should find a proper way to deal with that for good.

I agree that this doesn't solve the underlying problem that folios
belonging to a malfunctioning fuse server may be stuck in writeback
state forever. To properly and comprehensively address that and the
other issues (which you alluded to a bit in section 3 below) would I
think be a much larger effort, but as I understand it, a userspace
regression needs to be resolved more immediately. I wasn't aware that
if the regression is caused by a faulty userspace program, that rule
still holds, but I was made aware of that. Even though there are other
ways that sync could be held up by a faulty/malicious userspace
program prior to the changes that were added in commit 0c58a97f919c
("fuse: remove tmp folio for writebacks and internal rb tree"), I
think the issue is that that commit gives malfunctioning servers
another way, which may be a way that some well-intended but buggy
servers could trigger, which is considered a regression. If it's
acceptable to delay addressing this until the actual solution that
addresses the entire problem, then I agree that this patchset is
unnecessary and we should just wait for the more comprehensive
solution.

>
>
> (1) AS_WRITEBACK_MAY_HANG semantics
>
> As discussed in the past, writeeback of pretty much any filesystem might
> hang forever on I/O errors.
>
> On network filesystems apparently as well fairly easily.
>
> It's completely unclear when to set AS_WRITEBACK_MAY_HANG.
>
> So as writeback on any filesystem may hang, AS_WRITEBACK_MAY_HANG would
> theoretically have to be set on any mapping out there.
>
> The semantics don't make sense to me, unfortuantely.

I'm not sure what a better name here would be unfortunately. I
considered AS_WRITEBACK_UNRELIABLE and AS_WRITEBACK_UNSTABLE but I
think those run into the same issue where that could technically be
true of any filesystem (eg the block layer may fail the writeback, so
it's not completely reliable/stable).

>
>
> (2) AS_WRITEBACK_MAY_HANG usage
>
> It's unclear in which scenarios we would not want to wait for writeback,
> and what the effects of that are.
>
> For example, wait_sb_inodes() documents "Data integrity sync. Must wait
> for all pages under writeback, because there may have been pages dirtied
> before our sync call ...".
>
> It's completely unclear why it might be okay to skip that simply because
> a mapping indicated that waiting for writeback is maybe more sketchy
> than on other filesystems.
>
> But what concerns me more is what we do about other
> folio_wait_writeback() callers. Throwing in AS_WRITEBACK_MAY_HANG
> wherever somebody reproduced a hang is not a good approach.

If I'm recalling this correctly (I'm looking back at this patchset [1]
to trigger my memory), there were 3 cases where folio_wait_writeback()
callers run into issues: reclaim, sync, and migration. The reclaim
issue is addressed. For the migration case, I don't think this results
in any user-visible regressions. Not that the migration case is not a
big issue, I think we should find a proper fix for it, but the
migration stall is already easily caused by a server indefinitely
holding a folio lock, so the writeback case didn't add this stall as a
new side effect.

[1] https://lore.kernel.org/linux-fsdevel/20241122232359.429647-1-joannelko=
ong@gmail.com/
>
> We need something more robust where we can just not break the kernel in
> weird ways because user space is buggy or malicious.
>
>
> (3) Other operations
>
> If my memory serves me right, there are similar issues on readahead. It
> wouldn't surprise me if there are yet other operations where fuse Et al
> can trick the kernel into hanging forever.
>
> So I'm wondering if there is more to this than just "writeback may hang".
>
>
>
> Obviously, getting the kernel to hang, controlled by user space that
> easily, is extremely unpleasant and probably the thing that I really
> dislike about fuse. Amir mentioned that maybe the iomap changes from
> Darrick might improve the situation in the long run, I would hope it
> would allow for de-nastifying fuse in that sense, at least in some
> scenarios.
>
>
> I cannot really say what would be better here (maybe aborting writeback
> after a short timeout), but AS_WRITEBACK_MAY_HANG to then just skip
> selected waits for writeback is certainly something that does not make
> sense to me.
>
>
> Regarding the patch here, is there a good reason why fuse does not have
> to wait for the "Data integrity sync. Must wait for all pages under
> writeback ..."?
>
> IOW, is the documented "must" not a "must" for fuse? In that case,

Prior to the changes added in commit 0c58a97f919c ("fuse: remove tmp
folio for writebacks and internal rb tree"), fuse didn't ensure that
data was written back for sync. The folio was marked as not under
writeback anymore, even if it was still under writeback.

> having a flag that states something like that that
> "AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC" would probable be what we would want
> to add to avoid waiting for writeback with clear semantics why it is ok
> in that specific scenario.

Having a separate AS_NO_WRITEBACK_WAIT_ON_DATA_SYNC mapping flag
sounds reasonable to me and I agree is more clearer semantically.

>
> Hope that helps, and happy to be convinced why AS_WRITEBACK_MAY_HANG is
> the right thing to do in this way proposed here.

This was helpful, thanks for your thoughts!

>
> --
> Cheers
>
> David

