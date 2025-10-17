Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94C9CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9B78E0008; Fri, 17 Oct 2025 17:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F6A8E0006; Fri, 17 Oct 2025 17:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9951B8E0008; Fri, 17 Oct 2025 17:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 848FB8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:08:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25E3C57D35
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:08:00 +0000 (UTC)
X-FDA: 84008843520.03.BF58D96
Received: from smtp85.iad3a.emailsrvr.com (smtp85.iad3a.emailsrvr.com [173.203.187.85])
	by imf12.hostedemail.com (Postfix) with ESMTP id 33BBF40008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:07:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.85 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760735278; a=rsa-sha256;
	cv=none;
	b=snNJ2heqVlEic/0TqJOoh10yVLc/19AIXnUUvNqbxw/yCBCO9sRsS2gnrVv081V15PQFfh
	x0bRXSPpL081K1IArwxBEJNJ58i03ZHTHwFSXeeHfS+PyhlynMC5NhgA64v1qyP2KReXK/
	hL2Ku9U44UGn0zIgEhAxewMiHCvH7Tc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.85 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760735278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmzrxdWGr3Yum5PMaBwb76HUqwH6RzrG37YIpzZZZys=;
	b=KQ69JW13gjWGW4c5TrYrzdXatychMVnc34QEttnOnRVbv/7Pm3MjmNeZndwl799E+QeGkv
	3cfaYWkmLurhJ4kzCBjapoVhA2KxbkDJSEt4uMPswu/hQvkdv2gAZxSSHtRvxvSneq3twr
	qI9ILDvlU8DkuF5mEh7o5s60h1J6VYI=
Received: from app11.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp35.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 650D4658B;
	Fri, 17 Oct 2025 17:07:57 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app11.wa-webapps.iad3a (Postfix) with ESMTP id 4A5B5A254F;
	Fri, 17 Oct 2025 17:07:57 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Fri, 17 Oct 2025 17:07:57 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Fri, 17 Oct 2025 17:07:57 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Axel Rasmussen" <axelrasmussen@google.com>
Cc: "Peter Xu" <peterx@redhat.com>,
 "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <CAJHvVciLe9--JnNn1=q=ycrgQSTVt7Zq0e01KhaRmOeSLO86dQ@mail.gmail.com>
References: <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com> 
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com> 
 <1758052343.971831541@apps.rackspace.com> 
 <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com> 
 <1758306560.96630670@apps.rackspace.com> 
 <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com> 
 <1758998720.44976697@apps.rackspace.com> 
 <CADrL8HW0eNsHnEsEdKYRNvFRBMvrDMrHawa55Kik9QFeVNEwgA@mail.gmail.com> 
 <1759175092.67312651@apps.rackspace.com> <aNrsXJsKaw24ADAp@x1.local> 
 <CAJHvVciLe9--JnNn1=q=ycrgQSTVt7Zq0e01KhaRmOeSLO86dQ@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1760735277.29994480@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 6b9bf787-4465-44b0-9c48-cb8cdd93f1f7-1-1
X-Rspam-User: 
X-Stat-Signature: rqttad1g6jqij8r7ugpu4sndwrr5cd7o
X-Rspamd-Queue-Id: 33BBF40008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760735278-172883
X-HE-Meta: U2FsdGVkX18mCQqLT/qVDu3Cm7hoqxsh8DPq27uSGJYY0dUj47X5V5Swb+kuizVfw80Vg9Q5puBCpQ6tRRERv7yuwoUjCn1RKVnCT5jEyVb8VROxBUpe9sM+QmCSunCVCmzBVHgUeuJ/XtuMEezCP3SbS57InvkjBcz1Ag2DZBqmRvWanEvaI24ElyeG1m0+6M2oCfkEeRHHHHV0/llH1oiT/iWNc1eBZBH1fh+3jbJUg3OW49oL2NrBkeO9nRam3c0lgQTPHDEtidpKu3ErCTNiyP7Vd6rg+w++xmOt+Ixy03fuCgNkNAGj/i+m0w+rqNZOfN9bvA094HcXO5hxhifFEJ7P48XmIQZtekTXEUPBsujPmv//XAYYwwdTf9vdh2lG8Sfrp36BdX/htHknxl+tmkqDzkXszasK8H5NNDkvjur7I88395gpOyfzBdpC/rYZX9MFllg7weGUWzajByYRMXj43Fr/YgJiQQgXJppEoLre54S57WIiakzkcnYSdwEhTmIMZ+SNoPwcx8Sc7Fq/9zsUxJ7h6FqlcKwBWWiDk7ZMoiAYkQ+ne5Il+HToWH4ramTpSk6JiRttF35s0a8IdreXG42eHkVhYv7WH6I1ZtmFwVdln0Op6rKWhpCbtXp1FMzHF27pUSNS5TjUqZg0QcWcKcmm/AJ00Q8mru3T5C8q9stX7LcWjkzPz7MjbVk5f/fsezmZyYO0emef3u/BxZCY3mfAHMux6ufxY3qwJ/Ro8S/GkTq+VDn7qTh2L7Ls6CqMlB8N9ekbaKEqOrr8fzSNOMjTBBDs2R+RwQgrVfnrpAHDk0tdZAsB7jqnBrpW9IAwCuytSp4r253HXd5/5m1c7y9RA077r6tp9CglK4DPWrRMhLevzMJ9Js5Y+jxJxvWYUw+vwL+M56LiBMogBT79LK6eDoYz/sa0f91SuutL11g4G6jp/nAsLOXqeFW/HrLXakvhrLWPhOs
 80I1hkGj
 VBW9DfvXfsphzu69Wj5TBeyH/NyJ70u7BS1b6c5FnJAITmfr6oTAW9jsFtB29JTduZn1WU+3aRbRKLCwPGmTm7HTDBolLWIo9ICQCZP4WFPtpBcRpWbIHEQDZmLk/xf+Oi/NhOfLEr4V0pnFNHzzGkk18chRrgX2vqwXfY75j68obF6XLN3GGsrfmPCT++2GhYJL7FXGT3h8ZKSLQUhPB7PF+Tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Axel -=0A=0AThanks for the long reply. I've been focused elsewhere for a=
 couple weeks, but I'm getting back to this.=0A=0AComments below:=0A=0AOn W=
ednesday, October 1, 2025 18:16, "Axel Rasmussen" <axelrasmussen@google.com=
> said:=0A=0A> Thanks for linking the ExtMem paper David, that makes it a l=
ot more=0A> clear to me what your expectations are.=0A=0ANote that personal=
ly, I'm not trying to do what the ExtMem people tried to do - implement ful=
l memory management in userspace. I'm simply trying to monitor all the pagi=
ng activity in a set of processes. So in many ways my goal is less ambitiou=
s than theirs. And userfaultfd almost does everything I want, with the exce=
ption of the case of anonymous+private paging.=0A =0A> =0A> I think basical=
ly, userfaultfd has evolved incrementally, and it only=0A> has a handful of=
 features needed to address pretty specific use cases,=0A> it doesn't have =
the full flexibility / generality you would need to do=0A> "full memory man=
agement in userspace". Not to say I think it shouldn't=0A> be able to do th=
at from a philosophical point of view, I just mean to=0A> say it would take=
 quite a lot of work to get there.=0A> =0A> Performance is also a big conce=
rn. Userfaultfd performance is not=0A> great, in fact scalability issues ar=
e one of the reasons we have been=0A> pursuing guest_memfd based approaches=
 to VM demand paging, instead of=0A> userfaultfd.=0A=0AI don't really want =
to do VM demand paging. I've done that before, at a previous startup I co-f=
ounded, called TidalScale. (well, you could call it demand-paging, but in f=
act it was more complex. However, HPE now owns TidalScale, and it would be =
silly for me to focus on that stuff (distributing virtual memory, virtual p=
rocessors, and virtual I/O devices throughout a set of big servers, migrati=
ng them among the different servers). We did some amazing things with that,=
 but I also learned that there's a limit to what virtualization+migration c=
an do, performance-wise.=0A=0A> =0A> I don't disagree that in principle it =
makes sense for anon private=0A> swap faults to generate userfaultfd minor =
fault events, it's just=0A> until now nobody had ever wanted to do that, so=
 it hasn't been=0A> implemented yet. :) For what it's worth, I don't think =
this would get=0A> you where you want to go by itself though, because the o=
nly action you=0A> could take in response to such an event today is UFFDIO_=
CONTINUE,=0A> which would simply swap in + map the page, you would have no=
=0A> opportunity to e.g. populate the page contents from elsewhere, you'd=
=0A> be delegating all of that to the existing in-kernel swap=0A> implement=
ation. So it doesn't really get you all the way to "full=0A> userspace memo=
ry management".=0A=0AYet, that's exactly the additional capability I want -=
 just to get the event and continue, after doing some stuff with the inform=
ation at the time of the event.=0A=0ASo if I could have just that, it would=
 be great. I thought that it was there already, since the restriction isn't=
 mentioned in the documentation.=0A=0AThe alternative for me is to write a =
lot of "out-of-tree" kernel code that hooks (using k[ret]probes?) into all =
the paging mechanisms in the kernel, and then maintain it across releases. =
I don't really want to do that. And to create a hypervisor extension just t=
o do this from deep below the applications seems silly.=0A=0AI realize that=
 there a performance drag to using userfaultfd, but for my purposes that is=
 pretty irrelevant.=0A=0AAnd I'm kind of surprised that this case doesn't "=
just work", since supposedly one can register for minor page faults on othe=
r non-file-backed pages, just not "MAP_PRIVATE" ones, which get rejected at=
 the "register" ioctl.=0A=0ARegards,=0ADavid=0A=0A> =0A> =0A> On Mon, Sep 2=
9, 2025 at 1:30=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:=0A>>=0A>> On=
 Mon, Sep 29, 2025 at 03:44:52PM -0400, David P. Reed wrote:=0A>> > I thoug=
ht it was a general purpose interface. My mistake. But I think it=0A>> > ca=
n be more general, at least encompassing my goal of having a userspace=0A>>=
 > "interface" that monitors processes' page faults.=0A>>=0A>> To James: th=
anks for the great writeup.  Somehow, I just feel like userfaultfd=0A>> (as=
 a linux submodule) got some sheer luck to have you around. :)=0A>>=0A>> To=
 David: just to say, I still think it's a general purpose interface, at=0A>=
> least that's the hope..=0A>>=0A>> I agree with you at least on one point =
you mentioned, that shmem also can=0A>> swap, and that was accounted as min=
or faults when swapin happens at a=0A>> specific virtual address.  It doesn=
't sound fair if anon isn't doing the=0A>> same. Indeed.=0A>>=0A>> It was j=
ust not in the radar when minor fault was introduced by Axel, even=0A>> it =
was for a solo purpose for live migration at that time.. but the hope is=0A=
>> the interface designed should service a generic purpose.=0A>>=0A>> Now t=
he problem is, userfaultfd wasn't initially used for monitoring system=0A>>=
 activities.  As its name implies, it provides the userspace a way to=0A>> =
resolve a fault, but only if a fault happens first..=0A>>=0A>> Meanwhile, s=
ystem activities should definitely at least involve swapouts,=0A>> which un=
fortunately doesn't involve page faults, but only happen the other=0A>> way=
 round when the system wants to secretly move things out.. that is what=0A>=
> userfaultfd is out of control.=0A>>=0A>> It just sounds like it won't suf=
fice your need even if we could add minor=0A>> fault support for anon priva=
te memories on swap cache. However, if=0A>> userfaultfd is used to do every=
thing (including swap in/outs), then it's by=0A>> nature all trappable + ac=
countable, on both swap in/outs to/from any media.=0A>> Then swapout will b=
e driven by the userspace too, then everything will be=0A>> in solid contro=
l, including monitoring of the activities.=0A>>=0A>> Thanks,=0A>>=0A>> --=
=0A>> Peter Xu=0A>>=0A> =0A


