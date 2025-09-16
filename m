Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6E9CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FAC8E0005; Tue, 16 Sep 2025 11:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8938E0001; Tue, 16 Sep 2025 11:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEA08E0005; Tue, 16 Sep 2025 11:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26A858E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:52:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC30FC012C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:21 +0000 (UTC)
X-FDA: 83895555282.23.B3905E5
Received: from smtp82.iad3a.emailsrvr.com (smtp82.iad3a.emailsrvr.com [173.203.187.82])
	by imf01.hostedemail.com (Postfix) with ESMTP id 055BC40019
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.82 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758037940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ybo58B6N9pTN/f2Wt47SBQlMRM3JpIFrAARk5vW6aFg=;
	b=kRhhYPZ84Qox2KoJXizmLlL95xEShUoFVBW8X4/GMiISfvmbWk+tnqfPZG3EUZxMaVaK67
	OPbqAS97zULVZnUpIRZda61mUuRkcRPBlV6Co3moYR8M0pXhIMxN5q085D6Y6SIug5FBlE
	l5Hc+HQHxI0R8s3EDQpb9CmM1XpNMSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758037940; a=rsa-sha256;
	cv=none;
	b=lGlM+dSFtAAstev3AtLzfmrAB2BUnSxZIXrF/rO/gy6kGJ2tl8+Yl04ap+VSY76d/Fen4k
	h2q+wUW2NdrHO5jnm9rf9oDRlXq06nVK+4K2IheqOUFn7CbeqbpRniAs9QnaDvqe7ZZjWM
	ZEQPy0ASMu5qxVNm4v7/eEe0gsU0XOA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.82 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
Received: from app2.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp19.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 167F559DF;
	Tue, 16 Sep 2025 11:52:19 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app2.wa-webapps.iad3a (Postfix) with ESMTP id EB83DA269D;
	Tue, 16 Sep 2025 11:52:18 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Tue, 16 Sep 2025 11:52:18 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Tue, 16 Sep 2025 11:52:18 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Peter Xu" <peterx@redhat.com>
Cc: "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 "Axel Rasmussen" <axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <aMl4qLyNovWHhty9@x1.local>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local>
X-Client-IP: 209.6.168.128
Message-ID: <1758037938.96199037@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: fd8252ce-6be4-4aa8-a81e-a8e0b66509e6-1-1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 055BC40019
X-Stat-Signature: acnbymtzm4ggqfgpag9t9c98g5wwt1mr
X-Rspam-User: 
X-HE-Tag: 1758037939-91300
X-HE-Meta: U2FsdGVkX18774rgOLI9r12XhhT39BOsdh58WEKV+GxLrQf8IUux3DxjQDrVLP5IWPGkTfKYd7mneZfYAWrZRmiCcQ1HK4dtV0zVoFFLhic8Mw8E0WeckABviJ6PasVrPm7MFKNSYtA8/74g/J+N246gRJtk57KOoDSOvEZEGJFx6i/O/iy2YIx1B7lthmTWjW6t1d0DQhjJNnBaCvwaSh5hzNzdfAPKULbt5ISVIcoNzbInzguC7tLNJiN+gCpBC5f/XDxA4dRJhUu4naL7WvWi+556PD6e9aaY8HjqCBh3sE1u99qIgrt4STCJTRzgl5QKVkkTB5xyKpvGgcMC1YVoChEB1VuqAGLBVvgfE8OqRSfv5m9mbQ+sWsq8yoW4sNT142zJOePHq+1K3w3h/VsLRdXpRWdi4G2DN3JdseOUuVJZB9NxVhpSpbr7wig4Knox1XacCGdd50vSzRc1u7yeVzo4n05P4mt3TtI+P7lqrjJt+CcGPTnhO0Cu9ObXjD+r9CmU9qD085jbsDtGpbymr3Sy8UMwg329nK6PQk2ew1LNKO+r5QwcsC0yrVhozg6OncXHmyQRsv/35F9ZEyv7sZPHO0QR75E0X0Zoq0Ti2qHySLUHp83P0C1Rd4A9uvIv5sf+xf7cvmkh5oysIO24DSoF2jJicm9Iy2fLB/HnX8pTFpuuZMS5FpEr0Zj/r9ljQkehCqv72L4VrBcfAsyytvmCpnJxTi+p8vVPfYN4spSu8ERtz0SqEH/mXRS2RQmNr7laxzOsNOqiPaiSATMJAo+eJ+lh1sLAZigqri74G3KWAZlWm/AUiUjcs7Kk8nBNJAw8LswloPwJO0mMA+S+IRB1wX3iTc9V+JCI7RxvTMhuuqOycGAZXUL1rWmBAxG6g4UXxjf7aAcBE+Ox4b7nW7CUxWoOpjE13lB/KP0Tv3Jfz7qFfb1mY+FVcp+45wOTh/Ch/G4rOUtGt5n
 qkkiCQcZ
 MGCS5HKtqyfE3ZVZPyizp7F6IAe+57qqtd2KFkFpNhnXgms0d9lKKJzH2T9RJnlTbGrSBNbb+n/E042jpA/AfzdpWt3n34+mEGixLIcyXJDHbn61xM/4xxcNQ0TrOp/8E91ziLXCSiktj+1vbEJiTpM5TUtA/DZD+EK/xYfmQpA+07C/VApLrkbjm+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=0AOn Tuesday, September 16, 2025 10:48, "Peter Xu" <peterx@redhat.com> =
said:=0A=0A> On Mon, Sep 15, 2025 at 05:31:51PM -0700, James Houghton wrote=
:=0A>> I still don't have a solid grasp of what your use case is.=0A> =0A> =
David, are you trying to provide a synchronous trap for an anon swapin=0A> =
event?  Say, you want to be able to stop a thread from swapping in anything=
=0A> from disk (or swap cache), do something, and UFFDIO_CONTINUE to kick i=
t off=0A> again?=0A=0Asynchronous would be better. But what I want to do is=
 at least get notifications of swapin events (including the case when the p=
age is in swap cache). Also, using UFFDIO_COPY can be useful for the swap i=
n case might make sense (but rarely, because there's no way to access the d=
ata that was swapped out).=0A=0A> =0A> That might make some sense when tryi=
ng to match what MINOR mode means=0A> v.s. the mm's minor faults, but some =
explanation of why you wanted to do=0A> that would be helpful.  I agree wit=
h James that it was at least not the=0A> intention when userfaultfd MINOR t=
rap was introduced.=0A=0AI suspected that - however, notice that the reject=
ion of registering minor mode is what I was reporting. It's oddly coded as =
if ordinary (4K) pages that are MAP_PRIVATE are the problem - no comment in=
 the line of code I quoted explains why.=0A=0A> =0A> The other thing to men=
tion is, AFAIU userfaultfd's major use case is not=0A> through a fork(), ev=
en though it should work..  In many cases, userfaultfd=0A> is used within a=
 process, with a dedicated thread resolving faults. When=0A> it's used acro=
ss processes, fork() should work but UFFD_FEATURE_EVENT_FORK=0A> is require=
d, or otherwise via SCM_RIGHTS.  For the latter, the tracee needs=0A> to no=
t only share the uffd object, but tell the tracer explicitly about the=0A> =
memory layout, because those addresses in the events will be reported in=0A=
> tracee's mm address space.=0A=0AYeah, the documentation tends to suggest =
that the file descriptor should be shared via a Linux Socket. But the case =
of a fork() should work. (the examples use O_CLOEXEC, but of course that is=
n't "close on fork").=0A=0A=0A=0A> =0A> Thanks,=0A> =0A> --=0A> Peter Xu=0A=
> =0A> =0A


