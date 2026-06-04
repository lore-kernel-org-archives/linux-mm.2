Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E004CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34B26B0005; Thu,  4 Jun 2026 11:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0CD56B0088; Thu,  4 Jun 2026 11:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22456B008C; Thu,  4 Jun 2026 11:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A18F16B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:53:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03A37120127
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:53:31 +0000 (UTC)
X-FDA: 84842675064.29.181B0F6
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id CAD4D20004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:53:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=jpkivYJ8;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.44 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780588410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
	b=OxLdcSnlj/rtv/fxBWJZ3cN7Ahv4IpQHu4+JBpKK4rWcmp4jNbtY9u0yxma6l+6AopXxC+
	/3gEGWnvZ9H5in7y5OYLVhRy6h+lXPpwGO5rDvxNz0uSkNVY4pq3utOBGKycUFfh1wXhhF
	47/FZUb8uUfvBU8WqyAa0P2yqwpne2k=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=jpkivYJ8;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.44 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780588410;
	b=J5vWbI9PETATVb4XNBptP3ZjB3wlXEfurJj4sYsNWYdqxyjb3caSq3oO3mkA3S/eFrpEf1
	k2Kvq+BmQpyD80k6Gs0VjzUbRyuFPX4gsrsrvGr+e7Xo+AEDwQI02M2CNJf9YA70fi5BjF
	qQpA+rKlxkCcGaCKXbYMA93ih+2KIEA=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aa68d9dc18so948621e87.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 08:53:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780588408; cv=none;
        d=google.com; s=arc-20240605;
        b=fgauO9JdfpDCQYuvXKiqOa6KB2jzDKgF46b3W46rv9BAFWIqQzbhubWU5WvxmPTpHg
         gI4z6ZCXrs+7GnfPTM17XvovpSwmk4nEq+qw1389icc4qbtQHLs8kpP7yMFniscPxinW
         Hy3+SInqGYjkAe8lqjyCYMaMYtV4dXNfJFMznggQrvTUklrC2iNrq3LTAZjOnWqCR6Ro
         RbAylRo0uy+hFx1iv7t4KuJoNIKRRn6otvbiqdhwIvyDSCR5zeTAwm6XKQukMO4NFYnt
         7DBDk/54iajWn2MEiTO+CUQSOUsY7u/NSK/gkVD1qzlbPyqc/b07jAAdOBSBReHoOSqs
         gYnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
        fh=jcLWk965ExfZZGnAJQpD8fl2x5/zPS1O2dyebHShiWo=;
        b=NfB0IlM02RAySaOwex1nw0P9gviZZpm8QmKs5wwhIHjd5IoG4tx2tKq78kFrgCRq7G
         Ohnc3QCxg5+EyIOwTw0rUWmLcWI9CBccTBzEA/C4Kn9ciFSH15ynIMBA3YaWHwJPfJrW
         9EIvQCSCQFK0g93JsQ8VbEK4nI5vZI1nDnSgNuBTjUiHsvE0LX6xw+f/mZ/3b+BHbIDJ
         wPHudII30+nnYcejFhJJorT1YdG4nVNKooHQbAYWr8a1szArqm8lycZ0mZ9VJyYNQcl7
         u8HxXJegHJseB9m38tgs2xEmOVmp8tx8Tdqmb3ivrkpAFGhg3Jz1nLCsqmgYOwAugEWH
         vjjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780588408; x=1781193208; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
        b=jpkivYJ8BPXSQs0nFbazAyeo7qSiesjvViaosm/G/J7lnUMgqcP15DZCG+PkVXSz3a
         BYpLShSL1kQXEEFSDwA/DBF0+esS12Zxes4D1P6k69suD+fFnnIgrYFoVtqZkhSowQ61
         a5tekAfSJtInC29gU3Rv8L4VZlACwh3k87LT3QKdln8Zbx6JUdrGBQ7EJYHEkGWj/Eld
         534NpPtfZZ+3jXuf3Yl8OF4zclfyX1eq5J0h4xsFQGwbW8jnWeIuvK5eaSYwaHT8EbpJ
         q8iumcXrdkySNuud/MThRUDjxEDbK73Py/rM2FsAD29qVY2/OU4j7SyLJ5xIAPPt8Q7K
         uGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780588408; x=1781193208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
        b=hGi/8LLuN1i3YPzgJ5irjKjbQNrtDapRVoj1raSfYtFLajnflFlpdJzBx76Pgl7ZVi
         Xv70MMJYcVMfaeL6d00i9yGgoDklVEZ43BUb7W0NfwOz11mgc7Z5L31585NOygdqc9I6
         Q0YjUIwQ6YwBM+k26iMooDzI22yQ7BzFy+Wabp+nAPjRPSgq/HBj1WRh25n1iX+Xb/MP
         gmixQWO3teDxmurnb3UtrsL/v3dPrVTwi9elKALeLLWULQvNBeAlTseausyL8sRxl7p+
         7PEeXQd+b1X7HlRNx2atAtj2/FO5JMYivKWGBd72sVQ1ERcMCUSeyXeYA09r2xyDPBHN
         OX0g==
X-Forwarded-Encrypted: i=1; AFNElJ/rs4R7OkC4Vi9gbL92XDOsAwnJiEr/6IRY2NaiX4fqnTjk23xjkxzE3bjQBvgzASijxSpj79xKbw==@kvack.org
X-Gm-Message-State: AOJu0YyzVLHRZ817fJ52O7bA3o9V8Qa0nLEnvdYaAHLYleewKaLNiE8C
	aT491TRZkkk1yrHQDWTvTAD+9Rq78faN0wAWI3uu0L6/Xa0ulUSpIDuyXIi8ZFtmxM/gsomqUQu
	Cf/9gUKTaRWPpKrgSVKaG+J8kAIb/w608csn/C1l1
X-Gm-Gg: Acq92OGj7/RmpPBALPVbL1OnNb86M7gaXQJ/WupjD/NCF8FdiahN1ggFAgty9B0kU8W
	w4StardZpBqBZCAFZViQXlwkcU5uLgwakgRFYlTuKPvyT56U6DLemDNVCujgY4FaGSGQUpiEPC/
	HXZc4Os2yOn9oAZkezJodQHF0VVhDZc2UjSD0vQgXNUWksJGKUcA1QEwgSwZb5sjOxJFTgX7vvY
	7qike+vUVikwoMpkdSlbChjcyLt1kgGvB6zlG4sdFWFqR0UyQmBZYo4+9IoSGqE3kci11/ZWF+5
	b73ZFcILWmbrICmLXMbu0tUfog==
X-Received: by 2002:a05:6512:3186:b0:5aa:7126:c63c with SMTP id
 2adb3069b0e04-5aa7c0888ccmr2415181e87.5.1780588407521; Thu, 04 Jun 2026
 08:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org> <aiEb8CTM-ovMIq7-@1wt.eu>
In-Reply-To: <aiEb8CTM-ovMIq7-@1wt.eu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Jun 2026 08:53:15 -0700
X-Gm-Features: AVVi8CcFmOEXliFqkwckAyyy2jg3Zlvf93FEoWWD2xBje7cN4CAoI605l5f9FiY
Message-ID: <CALCETrULMixRGJyGqAAujW7RN6PP2f_Orn2Y_0hpPMjRqQnY7Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xsbkw6k3pr3nzjx5mhj1acqo65h7kcch
X-Rspamd-Queue-Id: CAD4D20004
X-HE-Tag: 1780588409-638269
X-HE-Meta: U2FsdGVkX1/Ty0VeU+akJtTVnirliIfC8U13cv9VfPCHmFdliseEKPsQuf6v4159R0AknXPFRdY6gUxw2jpGElv6W/vseTEU7NeoP57Xcb3MuQzdocubmqjZaYbtpD/At4fvf6C078YewF51chvT/Vu1TdeTFfm/OBMVlU9r1PSIONFtdpoA5p44HDLUjHPS7k9xualSeXDrt7iU3CUEfMEP2AcQZyq0i1YRiDRqyxhYUg6toNhC69v3CSUQgme3+IVMZ9/RY3g+6hfMksAdJ8MFfZeqMgVji/vq9zsWxWUpGGQrflxkX1Y2EJCq8DEbzqIoGavxwUhqXydR3odJSfV+4Df1LqMJxvYOnzIbEUPE5DeMlYkxTiyvavl0zwnKlDVcYsoqd2t28kNYlsLNWjNqjiLBVEqlo8Zs0S4d8N8a9+w4STuhvu35YcED4O0f8nGhRFyi6BdkUaP2zFs0uYNtS7mtxkWDVxMPdSV15tBxrrPuuqgOAuVxuvFoWdIUfZkxTxXxmsWi55MPYUgxtJL5rhM4CLC58C8mpExe6QPF2PgH63oCuJLe3LT0YVOyHI2EdxkN6OpZX2k+ooFg01Vbkr0bQCQWkj+r0blCTD64IKYKcagtcbv90RM4RWqqu/kW0royhyTy/E/SsXCvJb4AItgkzps//1ilkRx6sGoTzbecyXZr4k24OcxKGLTG1p3fcsoUxJ+Da6ASXtBiXfF6n3iNRusqN0gSuZJBtsn/+C7PXFpDZHTaJOAC79IOy3oRgcf+e8y1xBkSmxfD6nfbldo87JySG6dRasQnDPkyVwr3Gk7rgeQgtHEZTd5IS1VB+kic1VMf5pDaCwNErXfLK6zeyvNhlFL6h2KtpREvmctibcsj57K0xIW48/ZKeWPgV3xMo2k39AVn6EYeLBP79iMhvctZo0I9fUG0wmg8KbrIM/svk3vw2TkZy8x86+AD/fA6iC8kzMaOd68
 rbb4HZuf
 r8eIlUwKuzmZGzD3OHMGuV1a2yzu0Bu72+gm+skmeKV5dv9aYGRnVDCihzprRvsrGgPQVygZ8iVkg6EUhbO/0DsfnrMKitYXQfZ9QBxvgM30gnW+avnLpzWtqqhzIwS1Evh3YXpjp8GKSxEs+7esONWuY2ev7x6DpBpyU9SFVH+LZPn+a1wHl/TfUa6hU6rXI7eWJ4CPGvYQEBKafcnvfe4n7aCmu8Z+/ehp9EIHzcOWulCBjbkT/mB6N+vzLTvIT8QYEv9DIi+jLMk06tn8ORiEvHggJ/1Pf8lB3YgjKXx8QS4ozNUwRcTz9C+7WzNLXKTJyjFvskDysUeH8kzup5JtHQI2BO7xscty828wEFz3kp0LA36cBIbtr0Wj2980/ANQzmhef72kpVvfB67ZxlWrCkeSCRNXw06m3w/GXFrtJIu18Jsv07G/vc81Payq54H2oH6h0Sj0OfMIKQu20nL3JBwvPttdIrEd7PC6Ai4FFUO0lhi66rdHO6mLUFeAMAZwuGnltFbAhmWtqVAW74FyUznjIBN237RNXx3O9SwBZo/DxvKmzFFe+SMYHiHN57IN+5c/jUb6r9WRqB2rSpyd1863KznZ43VMKrtEKi7S9HIjsXKdfRVpdmXsRyx7AdGfME67/HU7Y/LxD7s+b5qI+O80whlHiSpp4zl12meJkA3r0b2AMsuW4+VV+G+A5NEbYIZfhjukFUEpkjJ61BcSmiY7W3Y3uHYiibBeHIksBlyFEoukdODxxHcjhNn+YkIg6L7UNP2cbNAHAJ8CxJGl98xPvab799WWc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:32=E2=80=AFPM Willy Tarreau <w@1wt.eu> wrote:
>
> On Mon, Jun 01, 2026 at 05:28:25PM -0700, Andrew Morton wrote:
> > On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> =
wrote:
> >
> > > On Mon, 1 Jun 2026 18:33:25 +0100
> > > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > > >
> > > > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* woul=
d be
> > > > > a big simplification.
> > > >
> > > > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > > > Communications between the kernel and fuse server at least used to
> > > > seriously want that, so that would be one place to look for unhappy
> > > > userland...
> > > >
> > > > splice-related logics in fs/fuse/dev.c is interesting; another plac=
e
> > > > like this is kernel/trace/, but I'm less familiar with that one.
> > > >
> > > > rostedt Cc'd (miklos already had been)
> > >
> > > Thanks for the Cc. The tracing ring buffer was specifically made to b=
e used
> > > by splice and the libtracefs has a lot of code to use it as well. As
> > > reading the ring buffer literally swaps out the write portion with a =
blank
> > > read portion, that portion (sub-buffer) is used to be directly fed in=
to
> > > splice, providing a zero-copy of the trace data from the write of the=
 event
> > > to going into a file.
> > >
> > > trace-cmd defaults to using splice to copy the tracing ring buffer di=
rectly
> > > into files to avoid as much copying during live recordings as possibl=
e.
> > >
> > > Whatever changes we make, I would like to make sure there's no regres=
sions
> > > in performance of trace-cmd record.
> >
> > Well yes, The patchset seems sensible from a quality POV.  But to make
> > a decision we should first have a decent understanding of its downside
> > impact.
> >
> > I haven't seen a description of that impact in the discussion thus far.
> > And that description is owed, please.
> >
> > I assume a small number of specialized applications are using
> > vmsplice() to great effect?  What are those applications?  What is the
> > impact of this change?
>
> > Once we are armed with that information, is there some middle ground in
> > which we de-feature vmsplice()?  Fall back to pread/pwrite in the
> > tricky cases and still permit vmsplicing if the application is
> > appropriately restrictive in it usage?
>
> I'm using vmsplice() + tee() + splice() in high-performance applications,
> load generators to be precise, and soon a cache. This is super convenient
> and extremely efficient:
>
>   - vmsplice() is used to prepare a "master" pipe with data to be sent
>     over TCP or kTLS
>   - then for each request, we do tee() from this master pipe to per-reque=
st
>     pipes.
>   - the per-request pipes are those that are used to deliver the data to
>     the socket via splice().
>
> So we effectively use vmsplice(), tee() and splice() here, and for exactl=
y
> the reasons they were designed: only play with page refcount and not copy
> data. The code is here for the curious:
>
>    https://git.haproxy.org/?p=3Dhaproxy.git;a=3Dblob;f=3Dsrc/haterm.c
>
> and its ancestor is here:
>
>    https://github.com/wtarreau/httpterm/blob/master/httpterm.c
>
> It simply doubles the network bandwidth compared to not using that.
> (62 Gbps per core vs 31). I would seriously miss it if I couldn't use
> this anymore.
>

Wait a moment.  This is neat, but it's literally just a benchmark,
right?  I skimmed the code, and it doesn't look like a production
workload, either.  And you manage to get around the awfulness of the
vmsplice API's complete failure to tell you when it's done with a
buffer by ... never actually changing the contents of the buffer.  Do
you have any idea how you would write correct code that uses vmsplice
for sends and then *ever* mutates the data without literally
munmapping (or madvise or something) the data do you can safely mutate
it?

> I also have mid-term plans for using vmsplice() to deliver contents from
> a cache to sockets as well via splice(). Right now our cache is split int=
o
> too small chunks (1kB) to make that useful, but as soon as we can move to
> 4kB pages, it will make sense. There the same gains are expected, and I
> would particularly dislike the idea of no longer being able to implement
> zero-copy!

If I'm understanding you correctly, you see (and measured!) a
performance improvement, and you would like to use it in production.

It seems to me that this is an excellent opportunity to remember that
vmsplice gets a performance boost in a highly synthetic situation that
sort of resembles a cache scenario and then to deprecate vmsplice and
build something better!  Or discover that we already have something
better, perhaps :)

https://man7.org/linux/man-pages/man3/io_uring_prep_send_zc.3.html

I see that this can submit a buffer without a syscall (tee + splice is
*two* syscalls!) and that it has directly addressed what I see as the
really big deficiency in vmsplice: "This second notification tells the
application that the memory associated with the send is safe to get
reused."  If I were writing the user code, I would very much want that
notification to be an explicit part of the API instead of making a
wild guess as I think I would need to do with vmsplice.

--Andy

