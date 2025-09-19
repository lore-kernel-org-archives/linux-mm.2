Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8658ACAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 18:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729698E0002; Fri, 19 Sep 2025 14:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA438E0001; Fri, 19 Sep 2025 14:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFE28E0002; Fri, 19 Sep 2025 14:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6288E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:29:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE49116077B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:29:23 +0000 (UTC)
X-FDA: 83906837406.23.17DF36B
Received: from smtp110.iad3a.emailsrvr.com (smtp110.iad3a.emailsrvr.com [173.203.187.110])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9C8AA0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:29:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=deepplum.com;
	spf=pass (imf15.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.110 as permitted sender) smtp.mailfrom=dpreed@deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758306562; a=rsa-sha256;
	cv=none;
	b=nkzFPWTbnp1Tj99h2q7Z7hLO0nDOwVVn3f/CDY/WTRr+cSnnCcthTWtCBqJSkr9mp5qFUu
	spQBXb7H82BBb/K7aJlGOZcjd/DxVgdO0cs4cvZHB1j/LJgpTmI2ptIDe/a9fjG/FvnoMk
	4ztuhP4KaLXcbXraYScTCFUBti6SBjY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=deepplum.com;
	spf=pass (imf15.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.110 as permitted sender) smtp.mailfrom=dpreed@deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758306562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fQDkxoMn7cyCD+zg76aoQLFgIj2qe2OocLFn3Emlf3Y=;
	b=W3LWdiXVkaISua1+G38TBj6gnO6gyoRH71k5mG7EwnbCNAho0GEpo3M9ZgvehmbJv2adCF
	I6JWjCTRdpfcf5KUswkhNzsD3QdV2rYKZ6HfiF2cEpYdr7+yMvjbqzBNUGLntnjPqkxKhq
	s1iT6EoWEvhqCpRyMldZQPTe9tJiGGI=
Received: from app38.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 10C155A59;
	Fri, 19 Sep 2025 14:29:21 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app38.wa-webapps.iad3a (Postfix) with ESMTP id EC4CCE1C4E;
	Fri, 19 Sep 2025 14:29:20 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Fri, 19 Sep 2025 14:29:20 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Fri, 19 Sep 2025 14:29:20 -0400 (EDT)
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
In-Reply-To: <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com> 
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com> 
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com> 
 <1758052343.971831541@apps.rackspace.com> 
 <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1758306560.96630670@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 118587ba-484c-4b63-97bc-182a01fe2f1c-1-1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9C8AA0006
X-Stat-Signature: nanipobnud96uwfuq4uuoxg7gedf9g7k
X-Rspam-User: 
X-HE-Tag: 1758306561-300212
X-HE-Meta: U2FsdGVkX18dE6P1VFm8sxTQ/7uBFiIMT7W047/tAeli6g74nrlPvM2RQNP/OjcPtKVG6a9rXtAPhyQoR6R6Dg9k0vjVs74BvGO57HzCUonE1714mcNun/5Ot0NaSZaFVajjfU/yaZw/0oTasMxCzgA8KiN+l8Rp3aFGVhojCrCNG10kR+8PNDOKJPhdbf1neKSua46j7Y4FIqFp+uicwp4LLxv6lYvHOEOrSd7AJZtazbP2BWYZMDcjEUjm0jfacfxFvkJaneOqiJNYOxstzoejqXJ1e2YQnes4leqNEBDMKA5UUWPzQ8UYVGqvfQRWONRco1KNBqOu8PopqcXYUoGJKmZ61GoWQsuVvqaWyggoopVcErpJjBFUuhSBQ8cZkxKrljScXvpCYWEmg1ipngjvkVph6vvXZ8Dd57+S/zfV8HIl9bnehjjm0Y4o4mwzwgGOBNnSO4m2ZjCeO2Vy9OvykutkCpLq/YsPJ0E3axCJYDOBrkICfYvFXZ4/JQEkZndVCFN3wRxXoa/5R1M6VtJKHkQo1nfFCcfey+Ya7cbSg/UtQjQuXkzTfaFSuhtbk3Xpbq/UrQqBRNjJEOTB6Csk/HB2QMVv0YWBZNY3lKllcQddED5++9cDezqLy8oKqK1+mORWE5wyqri9Ra/cH1sUB5jHFXjUIbx7E4eBL6rkuXLjnXk1M6gLdWBXlh0knGT7xjikFZNjwe3G7IWTyOtjULjV5bFntJf+vv8MN8gv/fAWkqPeboFW5S5DfONxdLr+7BWhpBsJ3/7TKU47u3ihKdT6xKL/3O2z7XkAXqU0uGsxA2XkQh7b/SFCD+8eQ9qlSqOFjbM3XRPK3zsACUoyFLvr1vHevFaBgn2I55D9aN/Ecy8vSeP+IZ9WodZgxkQdni6JZl6MbElgVNvHTEum/ZvSsHfVsC4xsdVUiohP9dYVAgaNOVoaSZTpDtTQqMsNJoH+bFEq+p6ab91
 78grGjDv
 nkNtF+eN7tNhGHFObjCPtpRf8rSr+sePtQgy9hFP1tCdsHL+wKFK/Pm/TRJsVCHdcT1JyCUS0D7eAo7cukMKAPMKwu94B+qls63bgWuF+n0KPC69LKzvZwjfp+WljhA5FSuLvXhB7aRaDDQ2BdJ91tBE2nbw16s6nnwHvAYEThy/iTLfAmNBlEKsNiJqaNtl7W4KHLHwzeWgf4+CEmNT2ZKHzHQBs+8nSl7hUQCLNzzZPwUkF8ABxBFQdMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=0AOn Wednesday, September 17, 2025 12:13, "Axel Rasmussen" <axelrasmuss=
en@google.com> said:=0A=0A> On Tue, Sep 16, 2025 at 12:52=E2=80=AFPM David =
P. Reed <dpreed@deepplum.com> wrote:=0A>>=0A>>=0A>>=0A>> On Tuesday, Septem=
ber 16, 2025 14:35, "Axel Rasmussen" <axelrasmussen@google.com>=0A>> said:=
=0A>>=0A>> > On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed=
@deepplum.com>=0A>> wrote:=0A>> >=0A>> >> Than -=0A>> >>=0A>> >> Just to cl=
arify -=0A>> >> Looking at the man page for UFFDIO_API, there are two "feat=
ure bits" that=0A>> >> indicate cases where "minor" handling is now support=
ed, and can be enabled.=0A>> >> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATU=
RE_MINOR_SHMEM=0A>> >> In my reading of the documents, these seem to imply =
that before they were=0A>> >> added as new features, that MAP_PRIVATE|MAP_A=
NONYMOUS mappings were=0A>> >> supported, and that the "new" additions to t=
he MINOR mode were just for=0A>> >> HUGETLBFS and MAP_SHARED cases.=0A>> >>=
=0A>> >=0A>> > Actually minor fault support didn't exist at all before thos=
e two features=0A>> > were added. :)=0A>>=0A>> Thanks for commenting. I'm n=
ot sure that's exactly true. Why is SNMEM=0A>> (MAP_SHARED) supported, but =
not ordinary pages? I wasn't party to the evolution=0A>> here, but so far n=
o one has explained why there's a special difference between=0A>> SHMEM and=
 ordinary VMAs.=0A> =0A> I promise it's true, I wrote the UFFD minor fault =
handling feature. :)=0AOK, but I am still confused as to SHMEM VMAs are sup=
ported and non-SHMEM are not, in the case of an anonymous mapped range.=0A=
=0A> =0A> As for why... Like I said above, UFFD calls it a "minor" fault if=
 the=0A> PTE doesn't exist, but the page already exists in the page cache. =
If=0A> the PTE does exist, you won't get either a minor *or* a missing faul=
t.=0A> If the page does not already existing the page cache, you'll get a=
=0A> missing fault, not a minor fault.=0AI'm assuming that you understand t=
here is a profound difference between the "page cache" and the "swap cache"=
 in Linux. I am referring to what happens when a page is in the swap cache,=
 (which is primarily about anaonymous pages, but a weird corner case is tha=
t "tmpfs" is backed by the swap cache and the swap system, not by the page =
cache).=0A=0AThe "historical reasons" for the swap cache not being the page=
 cache weirdly difficult to decode - I've spent a chunk of months trying to=
 do historical reasearch on how this came about, but more importantly, why.=
 No luck on the why. (And the main reason seems to be that, if I were to gu=
ess, that the folks who built it wanted to avoid using "inodes", which are =
required by the whole page cache meechanism, perhaps because they thought i=
nodes were "expensive").=0A=0AAnyway, I'm now understanding that UFFD's cho=
sen a variant meaning of "minor page fault" that seems tied to pages that a=
re file backed or SHMEM.=0A=0AA "swapped" page is anonymous by definition o=
f what "swap" means in Linux. In Unix and other systems, swapping was a gen=
eric term that included file-backed paging as well as non-file-backed pages=
.=0A=0AAnyway, I'm quite puzzled why I can't seem to monitor MAP_PRIVATE|MA=
P_ANONYMOUS page faults with userfaultfd.  The reason I focus on CoW is tha=
t CoW and fork() behavior is basically the only user visible difference bet=
ween MAP_PRIVATE and MAP_SHARED. And if you read random examples of how to =
use mmap(), quite often MAP_PRIVATE is suggested as if it were the "normal"=
 usage (despite what happens on fork()).=0A=0A> =0A> So "ordinary" VMAs are=
 not supported because I don't think there is=0A> any way to create that co=
ndition with them? If you just=0A> mmap(MAP_ANON|MAP_PRIVATE), those pages =
will never be in the page=0A> cache, right? How would you go about doing so=
? You don't have an fd,=0A> you can't fallocate it. If you specified MAP_PO=
PULATE, the PTEs would=0A> also be installed, so you just wouldn't get user=
faults at all. If you=0A> create the mapping, then fork, then write to it i=
n the child, I think=0A> the pages just get CoWed, I don't think userfaults=
 are generated for=0A> that, because the PTE was already there (albeit, wit=
h RO permissions).=0A> =0A> I guess maybe a way to make progress here is, c=
an you list out what=0A> sequence of steps you believe should result in a U=
FFD minor fault?=0A> Like (for example):=0A> =0A> fd =3D memfd_create()=0A>=
 fallocate(fd, 0, 0, size)=0A> mmap(fd, MAP_PRIVATE)=0A> /* register mappin=
g for UFFD minor faults */=0A> /* read or write to mapping */=0A> =0A> Now =
we get a minor fault.=0A> =0A> =0A> =0A>>=0A>> >=0A>> > You are right that =
userfaultfd's use of "minor fault" is (unfortunately)=0A>> > slightly diffe=
rent from the meaning in other contexts. I think the more=0A>> > normal mea=
ning is, faults which do not incur I/O (i.e., swap faults and=0A>> > file f=
aults [i.e., faults on non-swap-backed pages] are major, other faults=0A>> =
> are minor).=0A>> >=0A>> > For userfaultfd, a minor fault is a fault where=
 the page already exists in=0A>> > the page cache, but the page table entry=
 wasn't setup. I don't think that=0A>> > scenario can ever happen for anony=
mous, private mappings, so it doesn't=0A>> > really make sense to be able t=
o register such mappings in this mode. If you=0A>> > create a mapping with =
mmap(MAP_ANON|MAP_PRIVATE) and then access it (read=0A>> > or write), that =
fault requires allocation of a new page, so userfaultfd=0A>> > does not con=
sider that a "minor fault". My recollection though is if you=0A>> > make a =
file on tmpfs or hugetlbfs, fallocate() it or whatever, and you=0A>> > MAP_=
PRIVATE that file, *that* registration will work.=0A>> >=0A>> >=0A>> >>=0A>=
> >> It seems odd that anonymous page faults and COW would not be handled,=
=0A>> >> given that context.=0A>> >>=0A>> >> Anyway, that's unclear in any =
of the documentation. This just adds to my=0A>> >> last response where I ex=
plain my use case.=0A>> >>=0A>> >>=0A>> >>=0A>> >=0A>>=0A>>=0A> =0A


