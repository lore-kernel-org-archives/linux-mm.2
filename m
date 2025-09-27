Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9BDCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 18:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE448E0002; Sat, 27 Sep 2025 14:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE8E8E0001; Sat, 27 Sep 2025 14:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CD58E0002; Sat, 27 Sep 2025 14:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 190568E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 14:45:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FDFB8792F
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 18:45:23 +0000 (UTC)
X-FDA: 83935908126.29.62E8622
Received: from smtp108.iad3a.emailsrvr.com (smtp108.iad3a.emailsrvr.com [173.203.187.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AF0580009
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 18:45:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.108 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758998721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eJXlARsuK6KCD2HumQhlRAEaU0gJOyXnSBfkb+Oj18=;
	b=oiEc1KzFq2O1IcNWHeY4Z9HbdK6QTjQDVpmNM/XIRFTtT7xCfqgVEP+klhMW3SY9k+DOtx
	BZKlOlVsQC63JaT4ym+q48HzpTReqC3X455CjH7zru+HhAJLyxk8fQMzE0VmxfyfgOmUoR
	dL+ziINQA0NkSs6pQv5dXNC1vsXF3tU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758998721; a=rsa-sha256;
	cv=none;
	b=2/FKlEYmlV6ZPCQtLhhsKHzXXUXY4FMrombKC6WZtE4rDPruRX5ntzBO3wfDRHbCSN/4rM
	OrRoZ5QkZlCRtTTIMUbGhSvqNuwjvNWRXcJ7/GOVnUPmuPKtqy8h5lW0QHMiyuEOrPNmpG
	L2aLDiJpMUPzrPrdncbJnX+qMG+KHEo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.108 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
Received: from app32.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp14.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 9287E2508B;
	Sat, 27 Sep 2025 14:45:20 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app32.wa-webapps.iad3a (Postfix) with ESMTP id 6F08CE10B5;
	Sat, 27 Sep 2025 14:45:20 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Sat, 27 Sep 2025 14:45:20 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Sat, 27 Sep 2025 14:45:20 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Axel Rasmussen" <axelrasmussen@google.com>
Cc: "Peter Xu" <peterx@redhat.com>,
 "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: multipart/alternative;boundary="----=_20250927144520000000_15385"
Importance: Normal
X-Priority: 3 (Normal)
X-Type: html
In-Reply-To: <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com> 
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com> 
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com> 
 <1758052343.971831541@apps.rackspace.com> 
 <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com> 
 <1758306560.96630670@apps.rackspace.com> 
 <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1758998720.44976697@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: a9282cd1-fbe4-4ca3-b607-ec94cfe38678-1-1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8AF0580009
X-Stat-Signature: arwdbnouwhtcuq4b4q5rgqgdidad6bj4
X-Rspam-User: 
X-HE-Tag: 1758998721-811996
X-HE-Meta: U2FsdGVkX18+sK79kGjLofCUn0AvnDZg+JDxKQRoFmyfbMt1XUNvuaDNETNEhNY3RYOcXFNNs0OcsH8knmJS8sP6gWLaICvfvkH/v19bF+AQJY2ZRxgpOKLYAF9G2j2IV9eLp+r1HlPVuBHbxx4eaHGRNS7bqcjQcfwNYuk3CRTNA3EuH18s5oV5qQ2Ns/y2d5G/jXnX6NRVMlpwp8Qs6XVAnDaKlnf5XJY1YmMnWxWVHZkEvoYcut6ihzRYk7trNA2VfVbp7zLeb1mIgnJwpes78AbpZQBPqzrrgLQpZA+NAUz1AuURMJ6eOwNbIlQeV3zU+kx17bX9jmpxA1RJvn568kGEF290DSQ3BhPo3VhdKQz2br73O5KXEgtGpyDp+lhcxZ02bnN1t9r6COxA/Eorz50iH+PAmhE6ayXEH6JprYe6Rr9PyT4Y88iipvKNZnaAzdir2IBQqEsHtYyUpO5HoGHcI3WzICsEODRw5nFMH0D5254iMRbf6IFnMb+hssNJjRE8VbhE2AVNiWmi6m0n2/3Mujea+a+d1+m3OLYQa4yYOj1cIPEH1LjGJJfEgCfTMaIyuccCAnnvo2eXaMaovpNcPcT2/SXnNYACXunlyOJXM0RxR+T6kI+xIsR03+7CNlGFqlXS2kg/QRTGsrfs1gFs6o/g7353dNVUC5MwWUwms6RDHCRUfqbnVtWDkeYUb0QIq8KZ47zVz9x5+S7m0vZ5mYmnzylIndheGmGLJLlgCImq1BB3d+16Hmfsk/Hl8UDJo2i4P/bsUEytt8LKR97cX2hpUxnrXr4SPpM9iIE4rQV6Utlce4CaL0fw4OaxzrIIAc6nHukso/RwmUw5SfzM6aNk/olDqQQEa4ORGcRsHb8tlfO3I/ueLzT/wnzaK7y5OxTBLuiaGtbI35UhvgOOFlPqzZB2EjlXaN/t+aoUlLblGcqvNAH8jAcssHN7DjB6j5VLMQ63svW
 0CItdi8e
 IejOSHQkoVSSqbxGUHvKlrlqDhevlGH8mE/xQ4vt4qmSlbuSzvzqn2SWSaXG3kNHhT0COFTeOG1MOWrZ3T1bJYCWQrgYGirQF5eJBH9E2K0t2DQnlTLNsaf6CRn8WgSMzU0/eBGuc/R3sIrfpqaAOxQjKCTIelScSymIehlybUnhXZ/iU6xPKdauwgQEm4PXAYGOZNQfy8wyR6gNIMcSSIzYjHDOY1ZxwpzXZG3dLvhxpOtoNooq6B2UoumL7/mvSU1tz6WyVvTN2iagsdyUPLHxrizXuJWxWIwwMl07C8HPdRmww7H/C1AVVoTQ10ZDAATqt+bhmFsNi+ag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_20250927144520000000_15385
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=0AOK - responses below.=0AI'm still unclear what my role is vs. the others=
 cc'ed on this problem report is.=0A=0AIs anyone here (other than Andrew) a=
 decision maker on what userfaultfd is supposed to do? I can see what the c=
urrent code DOES - and honestly, it's seriously whacked semantically. (see =
the ExtMem paper for a reasonable use case that it cannot serve, my use cas=
e is quite similar). So is anyone here wanting to improve the functionality=
? I'm sure its current functions are used by some folks here - Google emplo=
yees presumably focused on ChromeOS or Android, I suppose, suggest that the=
re's a use case there.=0A =0AMy role started out by reporting that the docu=
mentation is both incomplete and confusing, both in the man pages and the "=
kernel documentation". And the rationale presented in the documentation doe=
sn't make sense. Some of you guys admit that you really don't understand ho=
w "swap" is different from "file-backed paging" (except for the corner case=
s of hugetlbfs [sort of "file backed"], "file-backed by /dev/zero" [which e=
nds up using "swap"], and tmpfs [also "file backed" but using "swap"]. And =
yet "anonymous, private" uses "swap" and the "swap cache", not the "page ca=
che".=0A=0ANow, after digging into the question, I feel like there was neve=
r, ever a coherent architectural design for userfaultfd as a function. It's=
 apparently just a "hack", not a "feature".=0A =0AI'd be happy to propose a=
 much more coherent design (in my opinion as an operating systems designer =
for the past more than 20 years, starting with Multics in 1970 - you guys m=
ay not be interested in my input, which is fair. Is Linus interested? That =
would be a bunch of work for me, because I would do a thorough job, not jus=
t a bunch of random patches. But I'm not proposing to join the maintainer-c=
lub - I'm retired from that space, and I find the Linux kernel contributors=
 poorly organized and chaotic.=0A =0AOr, I can just drop this interaction -=
 concluding that userfaultfd is kind of useless as is, and really badly doc=
umented to boot.=0A=0A=0AOn Thursday, September 25, 2025 15:20, "Axel Rasmu=
ssen" <axelrasmussen@google.com> said:=0A=0A=0A=0A> On Fri, Sep 19, 2025 at=
 11:29=E2=80=AFAM David P. Reed <dpreed@deepplum.com>=0A> wrote:=0A> >=0A> =
>=0A> >=0A> > On Wednesday, September 17, 2025 12:13, "Axel Rasmussen"=0A> =
<axelrasmussen@google.com> said:=0A> >=0A> > > On Tue, Sep 16, 2025 at 12:5=
2=E2=80=AFPM David P. Reed=0A> <dpreed@deepplum.com> wrote:=0A> > >>=0A> > =
>>=0A> > >>=0A> > >> On Tuesday, September 16, 2025 14:35, "Axel Rasmussen"=
=0A> <axelrasmussen@google.com>=0A> > >> said:=0A> > >>=0A> > >> > On Tue, =
Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed=0A> <dpreed@deepplum.com>=0A=
> > >> wrote:=0A> > >> >=0A> > >> >> Than -=0A> > >> >>=0A> > >> >> Just to=
 clarify -=0A> > >> >> Looking at the man page for UFFDIO_API, there are tw=
o=0A> "feature bits" that=0A> > >> >> indicate cases where "minor" handling=
 is now supported, and=0A> can be enabled.=0A> > >> >> UFFD_FEATURE_MINOR_H=
UGETLBFS and UFFD_FEATURE_MINOR_SHMEM=0A> > >> >> In my reading of the docu=
ments, these seem to imply that=0A> before they were=0A> > >> >> added as n=
ew features, that MAP_PRIVATE|MAP_ANONYMOUS=0A> mappings were=0A> > >> >> s=
upported, and that the "new" additions to the MINOR mode=0A> were just for=
=0A> > >> >> HUGETLBFS and MAP_SHARED cases.=0A> > >> >>=0A> > >> >=0A> > >=
> > Actually minor fault support didn't exist at all before those=0A> two f=
eatures=0A> > >> > were added. :)=0A> > >>=0A> > >> Thanks for commenting. =
I'm not sure that's exactly true. Why is=0A> SNMEM=0A> > >> (MAP_SHARED) su=
pported, but not ordinary pages? I wasn't party to=0A> the evolution=0A> > =
>> here, but so far no one has explained why there's a special=0A> differen=
ce between=0A> > >> SHMEM and ordinary VMAs.=0A> > >=0A> > > I promise it's=
 true, I wrote the UFFD minor fault handling feature. :)=0A> > OK, but I am=
 still confused as to SHMEM VMAs are supported and non-SHMEM are=0A> not, i=
n the case of an anonymous mapped range.=0A> >=0A> > >=0A> > > As for why..=
. Like I said above, UFFD calls it a "minor" fault if the=0A> > > PTE doesn=
't exist, but the page already exists in the page cache. If=0A> > > the PTE=
 does exist, you won't get either a minor *or* a missing fault.=0A> > > If =
the page does not already existing the page cache, you'll get a=0A> > > mis=
sing fault, not a minor fault.=0A> > I'm assuming that you understand there=
 is a profound difference between the=0A> "page cache" and the "swap cache"=
 in Linux. I am referring to what happens when a=0A> page is in the swap ca=
che, (which is primarily about anaonymous pages, but a weird=0A> corner cas=
e is that "tmpfs" is backed by the swap cache and the swap system, not=0A> =
by the page cache).=0A> >=0A> > The "historical reasons" for the swap cache=
 not being the page cache weirdly=0A> difficult to decode - I've spent a ch=
unk of months trying to do historical=0A> reasearch on how this came about,=
 but more importantly, why. No luck on the why.=0A> (And the main reason se=
ems to be that, if I were to guess, that the folks who=0A> built it wanted =
to avoid using "inodes", which are required by the whole page=0A> cache mee=
chanism, perhaps because they thought inodes were "expensive").=0A> >=0A> >=
 Anyway, I'm now understanding that UFFD's chosen a variant meaning of "min=
or=0A> page fault" that seems tied to pages that are file backed or SHMEM.=
=0A> >=0A> > A "swapped" page is anonymous by definition of what "swap" mea=
ns in Linux. In=0A> Unix and other systems, swapping was a generic term tha=
t included file-backed=0A> paging as well as non-file-backed pages.=0A> >=
=0A> > Anyway, I'm quite puzzled why I can't seem to monitor=0A> MAP_PRIVAT=
E|MAP_ANONYMOUS page faults with userfaultfd. The reason I focus on CoW=0A>=
 is that CoW and fork() behavior is basically the only user visible differe=
nce=0A> between MAP_PRIVATE and MAP_SHARED. And if you read random examples=
 of how to use=0A> mmap(), quite often MAP_PRIVATE is suggested as if it we=
re the "normal" usage=0A> (despite what happens on fork()).=0A> =0A> You ca=
n monitor MAP_PRIVATE|MAP_ANONYMOUS faults with userfaultfd,=0A> it's just =
that they're missing faults, not minor in userfaultfd=0A> terminology, beca=
use resolving them requires a new page to be=0A> allocated (UFFDIO_COPY, no=
t UFFDIO_CONTINUE).=0A =0AThere is no sensible way to respond to a "missing=
 event" when "missing" means the page is swapped out (to SWAP) by UFFDIO_CO=
PY or UFFDIO_ZEROPAGE. That's just weird, and you continue to insist on it.=
 Where is the page that was swapped out? Well, one could look at the PTE in=
 /proc/pid/maps, and you find that its "swap entry" is there as an index in=
to a block device. (so, maybe you can open the swap device using some file =
descriptor and mmap() it into the manager process, then UFFDIO_COPY, but wh=
at if the swap page is actually in the "swap cache", you can't mmap any swa=
p cache page via any userspace API - do you know a way to do that?)=0A=0ANo=
w I reported a bug in UFFIO_REGISTER, which you keep saying is the same as =
UFFDIO_CONTINUE. Well, it isn't! I can register a minor handler (which allo=
ws continue) if I use MAP_ANONYMOUS|MAP_SHARED. The same "swap cache" mecha=
nics exactly apply. The only "sharing" is potential future sharing after th=
at process forks, in which case, the same "swap page" is shared until a Cop=
y on Write forces the page to be unshared - it is a writeable page, just sh=
aring the same physical block. It can be swapped out to the swap cache and =
the swap device, which sets the PTE to be a "swap entry" that causes a page=
 fault.=0AThe swap device doesn't know where the pages are mapped. You need=
 to look at the PTEs of all the processes to find the translation to swap c=
ache entry, and if you want to go backward from swap entry to pages, you ne=
ed to use a special XArray that finds VMAs given swap entry.=0A=0ABut the p=
oint here I keep making is that UFFDIO_REGISTER rejects only MAP_ANONYMOUS =
that are MAP_PRIVATE and also not huge pages. To me that's weird.=0A=0AIf i=
t is the CoW case that doesn't work (I doubt it), well, you have to read th=
e swapped out page into memory before copying it anyway. Then you copy on w=
rite, from the page read or found in the swap cache.=0A=0ANow, as you say, =
that may require allocating a new page, also in the swap cache. Is that a "=
missing" page in the weird userfaultfd terminology? If so, to handle it can=
't be done with UFFIO_COPY, because you can't access the contents from user=
space. And it's not "write protected" from the perspective of WP.=0A =0A> T=
he only exception I can=0A> think of is swap faults, I could see anon swap =
faults (perhaps=0A> specifically when the page is in the swap cache?) being=
 considered=0A> UFFD minor faults, but I would be curious to know what the =
use case is=0A> for that / why you would want to do that. The original use =
case for=0A> UFFD minor fault support was demand paging for VMs, where you =
have=0A> some kind of shared memory (shmem or hugetlb) where one side of th=
e=0A> mapping is given to the VM, and the other side of the shared mapping=
=0A> is used by the hypervisor to populate guest memory on-demand in=0A> re=
sponse to userfaultfd events.=0A =0AI think I've just answered this. userfa=
ultfd doesn't support the "swap out" part of anonymous swapping at all. So,=
 how could a manager get the page contents as of the instant it is put in t=
he swap cache for writing out to the swap device? There's no "swap out" eve=
nt mechanism, and no way to treat the swap device cached into the swap cach=
e as a page source. (not to mention the zswap mechanism, which compresses s=
ome of the pages into an invisible piece of memory).=0A=0A> =0A> To me it's=
 not intended userfaultfd minor events are generated for=0A> writeprotect f=
aults, to me that's the domain of userfaultfd-wp, not=0A> minor faults. Jam=
es might be right that these unintentionally trigger=0A> minor faults today=
, I would need to do some more reading of the code=0A> to be certain though=
.=0A=0AI don't particulary care about writeprotect faults, but CoW probably=
 shouldn't be considered the same as a writeprotect fault, because CoW is t=
riggered by a write into a writeable area, ONLY in one of the mappings, whi=
chever is written first. The process doesn't think of it as a "write" - it =
just is a kernel optimization of a common case where fork is followed by no=
n-use, so the actual copy could have been done at fork time, semantically. =
It's a deferred read and allocation. =0A =0AI hope this helps clarify my co=
ncerns.=0A=0AThere are several reasonable outcomes -=0A=0A1. Much better do=
cumentation of what the code actually does (and why).=0A2. Fix the "bug" th=
at prevents REGISTER of "minor" handler on private, anonymous mappings (obv=
iously, you can REGISTER missing handlers as well), then document actually =
what happens during the life cycle of swapping of pages in detail, includin=
g MAP_PRIVATE|MAP_ANONYMOUS VMAs.=0A3. Do a thorough analysis of what userf=
aultfd really should do, if the goal is to provide the ability of a "manage=
r process" to get to handle all cases of page fault behavior on a case-by-c=
ase basis for regions of user addressable pages.=0A=0AI'd be happy to contr=
ibute to (but not manage) whichever outcome - and I have what I think is a =
reasonable use case. (and I'm aware that this API accidentally created a se=
rious hacker exploit earlier in its life, by creating a way to hang one pro=
cess from another. I think that's no longer so easy.)=0A 
------=_20250927144520000000_15385
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<font face=3D"arial" size=3D"2"><p style=3D"margin:0;padding:0;font-family:=
 arial; font-size: 10pt; overflow-wrap: break-word;">OK - responses below.<=
/p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; o=
verflow-wrap: break-word;">I'm still unclear what my role is vs. the others=
 cc'ed on this problem report is.<br /><br />Is anyone here (other than And=
rew) a decision maker on what userfaultfd is supposed to do? I can see what=
 the current code DOES - and honestly, it's seriously whacked semantically.=
 (see the ExtMem paper for a reasonable use case that it cannot serve, my u=
se case is quite similar). So is anyone here wanting to improve the functio=
nality? I'm sure its current functions are used by some folks here - Google=
 employees presumably focused on ChromeOS or Android, I suppose, suggest th=
at there's a use case there.</p>=0A<p style=3D"margin:0;padding:0;font-fami=
ly: arial; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p sty=
le=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap=
: break-word;">My role started out by reporting that the documentation is b=
oth incomplete and confusing, both in the man pages and the "kernel documen=
tation". And the rationale presented in the documentation doesn't make sens=
e. Some of you guys admit that you really don't understand how "swap" is di=
fferent from "file-backed paging" (except for the corner cases of hugetlbfs=
 [sort of "file backed"], "file-backed by /dev/zero" [which ends up using "=
swap"], and tmpfs [also "file backed" but using "swap"]. And yet "anonymous=
, private" uses "swap" and the "swap cache", not the "page cache".<br /><br=
 />Now, after digging into the question, I feel like there was never, ever =
a coherent architectural design for userfaultfd as a function. It's apparen=
tly just a "hack", not a "feature".</p>=0A<p style=3D"margin:0;padding:0;fo=
nt-family: arial; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</p>=
=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; over=
flow-wrap: break-word;">I'd be happy to propose a much more coherent design=
 (in my opinion as an operating systems designer for the past more than 20 =
years, starting with Multics in 1970 - you guys may not be interested in my=
 input, which is fair. Is Linus interested? That would be a bunch of work f=
or me, because I would do a thorough job, not just a bunch of random patche=
s. But I'm not proposing to join the maintainer-club - I'm retired from tha=
t space, and I find the Linux kernel contributors poorly organized and chao=
tic.</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10=
pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p style=3D"margin:0;padding:0=
;font-family: arial; font-size: 10pt; overflow-wrap: break-word;">Or, I can=
 just drop this interaction - concluding that userfaultfd is kind of useles=
s as is, and really badly documented to boot.<br /><br /></p>=0A<p style=3D=
"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap: bre=
ak-word;">On Thursday, September 25, 2025 15:20, "Axel Rasmussen" &lt;axelr=
asmussen@google.com&gt; said:<br /><br /></p>=0A<div id=3D"SafeStyles175899=
5031">=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10pt=
; overflow-wrap: break-word;">&gt; On Fri, Sep 19, 2025 at 11:29=E2=80=AFAM=
 David P. Reed &lt;dpreed@deepplum.com&gt;<br />&gt; wrote:<br />&gt; &gt;<=
br />&gt; &gt;<br />&gt; &gt;<br />&gt; &gt; On Wednesday, September 17, 20=
25 12:13, "Axel Rasmussen"<br />&gt; &lt;axelrasmussen@google.com&gt; said:=
<br />&gt; &gt;<br />&gt; &gt; &gt; On Tue, Sep 16, 2025 at 12:52=E2=80=AFP=
M David P. Reed<br />&gt; &lt;dpreed@deepplum.com&gt; wrote:<br />&gt; &gt;=
 &gt;&gt;<br />&gt; &gt; &gt;&gt;<br />&gt; &gt; &gt;&gt;<br />&gt; &gt; &g=
t;&gt; On Tuesday, September 16, 2025 14:35, "Axel Rasmussen"<br />&gt; &lt=
;axelrasmussen@google.com&gt;<br />&gt; &gt; &gt;&gt; said:<br />&gt; &gt; =
&gt;&gt;<br />&gt; &gt; &gt;&gt; &gt; On Tue, Sep 16, 2025 at 10:27=E2=80=
=AFAM David P. Reed<br />&gt; &lt;dpreed@deepplum.com&gt;<br />&gt; &gt; &g=
t;&gt; wrote:<br />&gt; &gt; &gt;&gt; &gt;<br />&gt; &gt; &gt;&gt; &gt;&gt;=
 Than -<br />&gt; &gt; &gt;&gt; &gt;&gt;<br />&gt; &gt; &gt;&gt; &gt;&gt; J=
ust to clarify -<br />&gt; &gt; &gt;&gt; &gt;&gt; Looking at the man page f=
or UFFDIO_API, there are two<br />&gt; "feature bits" that<br />&gt; &gt; &=
gt;&gt; &gt;&gt; indicate cases where "minor" handling is now supported, an=
d<br />&gt; can be enabled.<br />&gt; &gt; &gt;&gt; &gt;&gt; UFFD_FEATURE_M=
INOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM<br />&gt; &gt; &gt;&gt; &gt;&gt=
; In my reading of the documents, these seem to imply that<br />&gt; before=
 they were<br />&gt; &gt; &gt;&gt; &gt;&gt; added as new features, that MAP=
_PRIVATE|MAP_ANONYMOUS<br />&gt; mappings were<br />&gt; &gt; &gt;&gt; &gt;=
&gt; supported, and that the "new" additions to the MINOR mode<br />&gt; we=
re just for<br />&gt; &gt; &gt;&gt; &gt;&gt; HUGETLBFS and MAP_SHARED cases=
.<br />&gt; &gt; &gt;&gt; &gt;&gt;<br />&gt; &gt; &gt;&gt; &gt;<br />&gt; &=
gt; &gt;&gt; &gt; Actually minor fault support didn't exist at all before t=
hose<br />&gt; two features<br />&gt; &gt; &gt;&gt; &gt; were added. :)<br =
/>&gt; &gt; &gt;&gt;<br />&gt; &gt; &gt;&gt; Thanks for commenting. I'm not=
 sure that's exactly true. Why is<br />&gt; SNMEM<br />&gt; &gt; &gt;&gt; (=
MAP_SHARED) supported, but not ordinary pages? I wasn't party to<br />&gt; =
the evolution<br />&gt; &gt; &gt;&gt; here, but so far no one has explained=
 why there's a special<br />&gt; difference between<br />&gt; &gt; &gt;&gt;=
 SHMEM and ordinary VMAs.<br />&gt; &gt; &gt;<br />&gt; &gt; &gt; I promise=
 it's true, I wrote the UFFD minor fault handling feature. :)<br />&gt; &gt=
; OK, but I am still confused as to SHMEM VMAs are supported and non-SHMEM =
are<br />&gt; not, in the case of an anonymous mapped range.<br />&gt; &gt;=
<br />&gt; &gt; &gt;<br />&gt; &gt; &gt; As for why... Like I said above, U=
FFD calls it a "minor" fault if the<br />&gt; &gt; &gt; PTE doesn't exist, =
but the page already exists in the page cache. If<br />&gt; &gt; &gt; the P=
TE does exist, you won't get either a minor *or* a missing fault.<br />&gt;=
 &gt; &gt; If the page does not already existing the page cache, you'll get=
 a<br />&gt; &gt; &gt; missing fault, not a minor fault.<br />&gt; &gt; I'm=
 assuming that you understand there is a profound difference between the<br=
 />&gt; "page cache" and the "swap cache" in Linux. I am referring to what =
happens when a<br />&gt; page is in the swap cache, (which is primarily abo=
ut anaonymous pages, but a weird<br />&gt; corner case is that "tmpfs" is b=
acked by the swap cache and the swap system, not<br />&gt; by the page cach=
e).<br />&gt; &gt;<br />&gt; &gt; The "historical reasons" for the swap cac=
he not being the page cache weirdly<br />&gt; difficult to decode - I've sp=
ent a chunk of months trying to do historical<br />&gt; reasearch on how th=
is came about, but more importantly, why. No luck on the why.<br />&gt; (An=
d the main reason seems to be that, if I were to guess, that the folks who<=
br />&gt; built it wanted to avoid using "inodes", which are required by th=
e whole page<br />&gt; cache meechanism, perhaps because they thought inode=
s were "expensive").<br />&gt; &gt;<br />&gt; &gt; Anyway, I'm now understa=
nding that UFFD's chosen a variant meaning of "minor<br />&gt; page fault" =
that seems tied to pages that are file backed or SHMEM.<br />&gt; &gt;<br /=
>&gt; &gt; A "swapped" page is anonymous by definition of what "swap" means=
 in Linux. In<br />&gt; Unix and other systems, swapping was a generic term=
 that included file-backed<br />&gt; paging as well as non-file-backed page=
s.<br />&gt; &gt;<br />&gt; &gt; Anyway, I'm quite puzzled why I can't seem=
 to monitor<br />&gt; MAP_PRIVATE|MAP_ANONYMOUS page faults with userfaultf=
d. The reason I focus on CoW<br />&gt; is that CoW and fork() behavior is b=
asically the only user visible difference<br />&gt; between MAP_PRIVATE and=
 MAP_SHARED. And if you read random examples of how to use<br />&gt; mmap()=
, quite often MAP_PRIVATE is suggested as if it were the "normal" usage<br =
/>&gt; (despite what happens on fork()).<br />&gt; <br />&gt; You can monit=
or MAP_PRIVATE|MAP_ANONYMOUS faults with userfaultfd,<br />&gt; it's just t=
hat they're missing faults, not minor in userfaultfd<br />&gt; terminology,=
 because resolving them requires a new page to be<br />&gt; allocated (UFFD=
IO_COPY, not UFFDIO_CONTINUE).</p>=0A<p style=3D"margin:0;padding:0;font-fa=
mily: arial; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p s=
tyle=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wr=
ap: break-word;">There is no sensible way to respond to a "missing event" w=
hen "missing" means the page is swapped out (to SWAP) by UFFDIO_COPY or UFF=
DIO_ZEROPAGE. That's just weird, and you continue to insist on it. Where is=
 the page that was swapped out? Well, one could look at the PTE in /proc/pi=
d/maps, and you find that its "swap entry" is there as an index into a bloc=
k device. (so, maybe you can open the swap device using some file descripto=
r and mmap() it into the manager process, then UFFDIO_COPY, but what if the=
 swap page is actually in the "swap cache", you can't mmap any swap cache p=
age via any userspace API - do you know a way to do that?)<br /><br />Now I=
 reported a bug in UFFIO_REGISTER, which you keep saying is the same as UFF=
DIO_CONTINUE. Well, it isn't! I can register a minor handler (which allows =
continue) if I use MAP_ANONYMOUS|MAP_SHARED. The same "swap cache" mechanic=
s exactly apply. The only "sharing" is potential future sharing after that =
process forks, in which case, the same "swap page" is shared until a Copy o=
n Write forces the page to be unshared - it is a writeable page, just shari=
ng the same physical block. It can be swapped out to the swap cache and the=
 swap device, which sets the PTE to be a "swap entry" that causes a page fa=
ult.<br />The swap device doesn't know where the pages are mapped. You need=
 to look at the PTEs of all the processes to find the translation to swap c=
ache entry, and if you want to go backward from swap entry to pages, you ne=
ed to use a special XArray that finds VMAs given swap entry.<br /><br />But=
 the point here I keep making is that UFFDIO_REGISTER rejects only MAP_ANON=
YMOUS that are MAP_PRIVATE and also not huge pages. To me that's weird.<br =
/><br />If it is the CoW case that doesn't work (I doubt it), well, you hav=
e to read the swapped out page into memory before copying it anyway. Then y=
ou copy on write, from the page read or found in the swap cache.<br /><br /=
>Now, as you say, that may require allocating a new page, also in the swap =
cache. Is that a "missing" page in the weird userfaultfd terminology? If so=
, to handle it can't be done with UFFIO_COPY, because you can't access the =
contents from userspace. And it's not "write protected" from the perspectiv=
e of WP.</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size=
: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p style=3D"margin:0;paddi=
ng:0;font-family: arial; font-size: 10pt; overflow-wrap: break-word;">&gt; =
The only exception I can<br />&gt; think of is swap faults, I could see ano=
n swap faults (perhaps<br />&gt; specifically when the page is in the swap =
cache?) being considered<br />&gt; UFFD minor faults, but I would be curiou=
s to know what the use case is<br />&gt; for that / why you would want to d=
o that. The original use case for<br />&gt; UFFD minor fault support was de=
mand paging for VMs, where you have<br />&gt; some kind of shared memory (s=
hmem or hugetlb) where one side of the<br />&gt; mapping is given to the VM=
, and the other side of the shared mapping<br />&gt; is used by the hypervi=
sor to populate guest memory on-demand in<br />&gt; response to userfaultfd=
 events.</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size=
: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p style=3D"margin:0;paddi=
ng:0;font-family: arial; font-size: 10pt; overflow-wrap: break-word;">I thi=
nk I've just answered this. userfaultfd doesn't support the "swap out" part=
 of anonymous swapping at all. So, how could a manager get the page content=
s as of the instant it is put in the swap cache for writing out to the swap=
 device? There's no "swap out" event mechanism, and no way to treat the swa=
p device cached into the swap cache as a page source. (not to mention the z=
swap mechanism, which compresses some of the pages into an invisible piece =
of memory).</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-s=
ize: 10pt; overflow-wrap: break-word;"><br />&gt; <br />&gt; To me it's not=
 intended userfaultfd minor events are generated for<br />&gt; writeprotect=
 faults, to me that's the domain of userfaultfd-wp, not<br />&gt; minor fau=
lts. James might be right that these unintentionally trigger<br />&gt; mino=
r faults today, I would need to do some more reading of the code<br />&gt; =
to be certain though.<br /><br />I don't particulary care about writeprotec=
t faults, but CoW probably shouldn't be considered the same as a writeprote=
ct fault, because CoW is triggered by a write into a writeable area, ONLY i=
n one of the mappings, whichever is written first. The process doesn't thin=
k of it as a "write" - it just is a kernel optimization of a common case wh=
ere fork is followed by non-use, so the actual copy could have been done at=
 fork time, semantically. It's a deferred read and allocation. </p>=0A<p st=
yle=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wra=
p: break-word;">&nbsp;</p>=0A<p style=3D"margin:0;padding:0;font-family: ar=
ial; font-size: 10pt; overflow-wrap: break-word;">I hope this helps clarify=
 my concerns.<br /><br />There are several reasonable outcomes -<br /><br /=
>1. Much better documentation of what the code actually does (and why).<br =
/>2. Fix the "bug" that prevents REGISTER of "minor" handler on private, an=
onymous mappings (obviously, you can REGISTER missing handlers as well), th=
en document actually what happens during the life cycle of swapping of page=
s in detail, including MAP_PRIVATE|MAP_ANONYMOUS VMAs.<br />3. Do a thoroug=
h analysis of what userfaultfd really should do, if the goal is to provide =
the ability of a "manager process" to get to handle all cases of page fault=
 behavior on a case-by-case basis for regions of user addressable pages.<br=
 /><br />I'd be happy to contribute to (but not manage) whichever outcome -=
 and I have what I think is a reasonable use case. (and I'm aware that this=
 API accidentally created a serious hacker exploit earlier in its life, by =
creating a way to hang one process from another. I think that's no longer s=
o easy.)</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size=
: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A</div></font>
------=_20250927144520000000_15385--


