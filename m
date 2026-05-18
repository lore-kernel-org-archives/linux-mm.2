Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA60CCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021ED6B0005; Mon, 18 May 2026 14:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14EB6B0088; Mon, 18 May 2026 14:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04C86B008C; Mon, 18 May 2026 14:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C922F6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:59:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 598B41C0958
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:59:56 +0000 (UTC)
X-FDA: 84781455192.11.89E7FCB
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4AC1F4000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:59:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ts96AFbM;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779130794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyypnGTPAbgYfVefP9g9uTGtAYGNrN6Dgbk9OMbK1Hs=;
	b=OtBINU07UIO32YFT4IzG/VHL5U8XvU8l0S2BvTTLGe9oEZwVJrYLx02yQBy572Isa/9QiF
	vs1IAu2sqjnn2vq2pZLab4mTU2lSL9DolW34ZqMTSP9jDdILIdiy9kt5mjLFsKA1SoYhV5
	Wr03jU6CMiosA/2rC6GJ+GPczE/H0NM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779130794; a=rsa-sha256;
	cv=pass;
	b=SMDX02jBcl2giuZ3SRLkoe3Ve27aAmCBA98LytafRZ+5tifFZkatx3+0KT231+lVtTHSpt
	wS8EVQLEzUe0rwm4rxKoq1u9PDZijAjSJ1K6hkdczzTXEBz1I9tZFuhjLU3Vk7PwTPgJ4q
	ZGQq9AN9Ex1LxopHIJFIJMa9xzuo9eA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ts96AFbM;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso28a12.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779130793; cv=none;
        d=google.com; s=arc-20240605;
        b=jXbpms77cQ/cBSr5aH3PjDPMmGsu6r1jk3V+U9z/nyTmkSAckU+nvpES8oUph9PjW1
         mq9xbG3IR1jUMdjWu4IPzZVk2yIYcxR1GsgewymxkcxVbecm5Z8/SnOH87ZrmDrxFr+J
         si7qoMdEqALMKpES2sIslzHQXNXb8HrGAvRVsgnJJqURVg3Im1YHvmEZmGl8Dv1kYdYH
         yFMs7fJsomtC53vMlnffa26t7icvRZjzhuDYnP/yZhvab33ZkyK5eH7KqdxftSk2AQxb
         u+R9nld3knEKoi93jDgJ/5WOdXC0vnhv6E6J/8yUu4r15yFoIRJGWe5TIb8wPR30TXMF
         +Z0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dyypnGTPAbgYfVefP9g9uTGtAYGNrN6Dgbk9OMbK1Hs=;
        fh=xK0GU+meoGh/Vb2nIlWRdbQdiWZcPfq/RPLocZk+9AU=;
        b=EOMe62Iq9VuEDcqyM1ai9lFYfogzg7D28UqeJnRwhybeajGf9SCj9/6lE7TN4hgH3R
         RCblJaJLixjhdI/1mI1aKcD5tcLHjNNBRpM/r5zNQlHLi7ikuNgYYFnN9RwpUx0mnlu2
         wqWZmkkdhDI4PEbvPDWVFOwQ236zvKYlXlaqS1ezoSvMokJ4JXZwBlQe3C/0YaxFjxoU
         0yombDdZ2XJRkyLGzSeiCefDkCHIAP4F6+ZGAsoqOExn3E6MCFNdyLpNfc+1eFrPoz4e
         o4HwMo7IQqiw/jY9iUTas/FHROflCsKDkvKXg+WDNwPPySpgM61pM0uLIPz2indYJneR
         FyiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779130793; x=1779735593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dyypnGTPAbgYfVefP9g9uTGtAYGNrN6Dgbk9OMbK1Hs=;
        b=ts96AFbMjX67+y2ln0QsW8FBTCK3g0xW9bodnctmCF6MmQWJosgAeerdXHjSL49sFu
         0n2dhWG5JSlAHRZx+hshWULhqUuUaNhyvQqQu3dhW7IM28lcOXTbk+ezl6D1e9wbz0mg
         oGnxoEQogZYLuyzeoOqGSRxHItHrxtaP3hq09Uc3FSVd4KUL9rSmWLULpS4CSqCifGnw
         ZDM7hoH8tFSafDO135Imh4uXR09pScEGAt+BbT4vRGg5tU8VdPBZLG7k4nfgK/sUYAib
         MKRKcDstEKRl6Nl9nl3qWXUmoWAld4AE0hpZcdjH0k4NrvPAJKmB9c62W2D5qmT18rMV
         OTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779130793; x=1779735593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dyypnGTPAbgYfVefP9g9uTGtAYGNrN6Dgbk9OMbK1Hs=;
        b=DK0ALONw5tIaPw1SfHxGfZSFDS0adhJ5/FsZUd1STe9wphspe8JYEgcsq2MC5D4Jel
         uxlLLGq2CcfloGnrHtqfw6YHa2u09T7cakAjK3bil65hkM8CwQWmVUq4N8PjbUEucyT/
         X6tGark2p7z47/51faxwWgLK/X3Vmm5uSyG2g56WvEWijLdoLi9N6B8lkYjEOPCioG0i
         5eimnExqc7MWh3cEF5R/pUiXOgRkkKzEzXsPsGZdEQFGSmA7Hsz9XIbo53Od6uKd90T0
         h4FJSSPhetsCbI+7j6i3OhjWyoLjr2vkZ0btPIDiMnucnJ7ekxjf1hM4ind2jw8BDB8G
         LxaQ==
X-Forwarded-Encrypted: i=1; AFNElJ94NtVvxKSbXwdcqssQfkUtDOWJFdniyRNzgF3PnZbtE991Tomz+BslaCODW2c6VfTfLELatevTkg==@kvack.org
X-Gm-Message-State: AOJu0YySsCjYO0Z6p2OOuqvuKxiT9JGTIuysyDqaIP4bCk+k6QNRiSb9
	q8ojOkoNoulJXQoz+g4Mww66N5hJiru177rFmGcOG2x0LbWWE1r1NNNo1kZ86KQS3jOsTsm/Q7y
	pNuJxUPDtawyJY/7N7YMySGlnHQFgr8OiOPF6dnAR
X-Gm-Gg: Acq92OHUqC5DyMBS4LBdDMGPPUagPP1IM4bHQP6xSAQ+3v08Bc0AmJE4x5gzywxKEJe
	B43HcbT1VzLEdJOql9Nx/zHWwu25i0YfnnBXiXBm36S7b57PJ9FGtBcHTCBGVt/YOKpBxklGomf
	wOY9XCmm0dWDBCXAF/nqIBo3HaEVvdOaWDINefGNkMG03bKFvXlX48aqQiuopVSYSUXeD//H6yg
	DdQmdT1g0Qa+UpoZl/UztA2FnT12vaH7PRla+xqx3k53bPYKIOkPmVwvHKdGJfgGBW9BYsKNWW8
	zC/W/Bk7kZTCJgr9EqVNYPKqJ+3nn8tI8QN8G0VCrCRBRVI=
X-Received: by 2002:a05:6402:a587:20b0:668:c2b6:9fa2 with SMTP id
 4fb4d7f45d1cf-684986efb13mr83277a12.7.1779130792215; Mon, 18 May 2026
 11:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260516182126.530498-1-pfalcato@suse.de> <20260518-starten-messdaten-3b8aa670ec85@brauner>
In-Reply-To: <20260518-starten-messdaten-3b8aa670ec85@brauner>
From: Jann Horn <jannh@google.com>
Date: Mon, 18 May 2026 20:59:13 +0200
X-Gm-Features: AVHnY4LvxvBtU7IvbOZw7RgET8Oa9vmPu-ETaJy_kmEvSdqRrpv4JPgUqfOI0wg
Message-ID: <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
To: Christian Brauner <brauner@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	Mateusz Guzik <mjguzik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4AC1F4000C
X-Stat-Signature: qijd1b7sof8y9ggirtgfqgf14j4obkbo
X-Rspam-User: 
X-HE-Tag: 1779130794-299869
X-HE-Meta: U2FsdGVkX1+PRVcy347sWJqu9bpQx7kn7tiF3Lvmouv/620+LbgtxwCkP4Fs5T/o0WV7nwj+BmHw2R2sk2MnvDeC5LHfUyHQ3YV1Q/TRfz7Dkd+Car4CnOsrqJWvnGCpnabBQYHFaGspjV0n+JKudINPfMa871rYuqX00ZSlftD2imm7WHcqxPqwAphbaTpVJxVUs13PbYqWmBWUl3U5n1PzMslKMEd51iNIWOgFOIf4upV7oCU0rfjGARvyzi0Q5EfoFZjPXdHRcrqLRbtgHUPEDjpB2PgfhASKSk92YQDiXRYOPjg634adD/WnrBgvB8X/SrSzcPa7cz0eMkFcRTPPVCw3FKgQlEr6iR/xdi1H+gRfCL/FCSHBzDnRLvgVJLdwIQh6gkZOxo07B3NHOgrDX6wx7lO+tn735n8U7dAHG4jZeOFnMuXSJ8tiHybMHQgPvhXrUDgiBqtlqjRWZIyMgEEzFhWttCdVeMdykDl49/yaM2OomHoMRcVWgobm4trCJ+IF+eHrQgnpEsh9NSQAIUtbPQfyI6se8zgRognnDM66qDUQ6T55u5Oo3nLqMBJVZKILL7rGvK5PJBSEBUid96XsBA/DRl5BpEb6PpIVET4ZX6YdhQwOmvyCuFuGe1J5TbO8P+fDGtcndzQR8aSdsyHVXxXAVJEGWZmj2XS5mPxzCvqrfPbZQpBMGd3WFO3KzdOzKvrfjP+853adU2b3S8O8x7Kt0OIESn58cRqHT1ZYrybz6IncR9B1nTLaf4xkYlETRKyczYuhJiWov9wtV1j0Y2hP8sCvj49FMAzzeXFjdzsNhLaC/Ss6ONydk3FO6bXdRM3tiR0rjEOQSMzWzVeD8HAFE9CWxUxrJ2IL/QT/mRVqoYlF5vNrpcgX9u1H5m0jnlnnbFTksi4QlpEAkJYdbt9beVuUkE+Cq46+gBlOTVlAt39VvVI8+NFzVV3Oc9amvMurXTetI2d
 MWyHTXRx
 LAO+K4UWZT6MfeAFi9tnCvKLyyNB10cbR8EB+Ih47ViTOXy0VhWyYq3tIpJtddvziyoAbAwKANfHI3mRLym3b1CwfRjmsYdvl7YoOTiexcEkJVcVEvQSagFRv7r7sXMjAafopHBDw3OfpV3fHbFB7WIYr/TlE9hquZ9KOfIjnx+1hKf5XHdnVFB1c+yblDGOWecSvFWE5+XvtQp8EYCXbirA3qBDzVXGODIWMSdFr/mrWraZjCgd8Rgx7yFaAc9942Z2qQBnygakUGJAPh/cXZq2ZgHFKV886Ou/RZg8eoNJYOC+ds2B3HIz+YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 2:30=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Sat, May 16, 2026 at 07:21:26PM +0100, Pedro Falcato wrote:
> > Since the advent of vulns like Dirty Pipe, Dirty Frag, Copy Fail
> > and Fragnasia, splicing a read-only file is fundamentally unsafe.
> >
> > As such, as a mitigation, add a way for users to block splice() for
> > files they cannot write to. This eliminates this whole class of exploit=
s
> > that use splice()+confusion in pipe/net/etc code to gain write-access t=
o
> > files they can only read.
> >
> > Users can simply toggle fs.splice_needs_write=3D1 and suddenly splice()=
 will
> > refuse perfectly legal splices() from files it can only read, but not w=
rite.
[...]
> At that point you can also just ENOSYS splice() and vmsplice() via
> seccomp and force a fallback on non-splice codepaths that userspace has
> to have anyway as splice() isn't supported unconditionally.
>
> It feels like a knee-jerk reaction to an exploit class originating in
> buggy modules that we have little control over and we would extend an
> API to users that is really difficult to use.
>
> What might make more sense is to add a splice specific security_*() hook
> into the code so that an LSM can deny usage of splice in whatever way it
> wants to - bpf lsm or in-tree lsm.

I feel like a sysctl for "disable all the splice-like interfaces and
zerocopy TX" would be reasonable to have? Either by blocking such
operations, or better, silently downgrading all such operations to
normal copies.

FWIW, vmsplice() and splice() are also weird in how much memory they
can implicitly pin - if you call vmsplice() on a single byte in a 2M
THP page, I believe you'll implicitly pin 2M of memory...

By the way, another bug a few years ago of a similar shape was this
one - also a bug in networking code that can lead to accidental writes
into spliced pages:
https://project-zero.issues.chromium.org/issues/42451650 ("ktls writes
into spliced readonly pages")
with fix: https://git.kernel.org/linus/c5a595000e26

