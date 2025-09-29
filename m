Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D96CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 19:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921EB8E0012; Mon, 29 Sep 2025 15:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D20E8E0002; Mon, 29 Sep 2025 15:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7996C8E0012; Mon, 29 Sep 2025 15:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59E808E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:44:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4D72160503
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:55 +0000 (UTC)
X-FDA: 83943315750.21.5F64B3B
Received: from smtp100.iad3a.emailsrvr.com (smtp100.iad3a.emailsrvr.com [173.203.187.100])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1872140007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.100 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759175093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKBTqk859eXhthbOS4afhsC5zBcu42ahUio/DAmNJgo=;
	b=K3fegyxOZ7MugV7OjVzV0et142sLQdEYihRMkLE5E7G/D4NBIAFdcY8vnB+0owwbAFWO8J
	2EF/qz75Et9SHGL8/5lR3e5wAIVhqJ+sGyUZ+8Hgq0ePbzzoRX+A8keoYRBcDTCzQK188+
	s9kT+c26s/UdjGECbAgZlzJ4Fzj8VTA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.100 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759175093; a=rsa-sha256;
	cv=none;
	b=vJTZc47S/7NyC3piM3TwDHOiBp8Rqck+vefqiApPZuHVEnhu0wCBWPdUbgXMuWiWTJUzKl
	8mk4jqudi/Zf2y0cZaSYdYawLZNLyr9w6kpzvjqQR8QwwtbqZPZx770FE4wPePhQ9uHD6i
	/ddnlFwZD7CCiLrH/OwdgW9v2D3vu/Y=
Received: from app1.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp21.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id C604625B56;
	Mon, 29 Sep 2025 15:44:52 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app1.wa-webapps.iad3a (Postfix) with ESMTP id A506FE143F;
	Mon, 29 Sep 2025 15:44:52 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Mon, 29 Sep 2025 15:44:52 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Mon, 29 Sep 2025 15:44:52 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "James Houghton" <jthoughton@google.com>
Cc: "Axel Rasmussen" <axelrasmussen@google.com>,
 "Peter Xu" <peterx@redhat.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: multipart/alternative;boundary="----=_20250929154452000000_77253"
Importance: Normal
X-Priority: 3 (Normal)
X-Type: html
In-Reply-To: <CADrL8HW0eNsHnEsEdKYRNvFRBMvrDMrHawa55Kik9QFeVNEwgA@mail.gmail.com>
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
 <1758998720.44976697@apps.rackspace.com> 
 <CADrL8HW0eNsHnEsEdKYRNvFRBMvrDMrHawa55Kik9QFeVNEwgA@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1759175092.67312651@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 87a082cb-e1cb-4340-bbdc-990d3133e91c-1-1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1872140007
X-Stat-Signature: jg1oj9dap93aki4ycyt7wjd8r7sm3ez7
X-HE-Tag: 1759175093-504988
X-HE-Meta: U2FsdGVkX1/hE8onWi6UnKclPdyoEHq/4Bun1uGb2fJdZjhgWl6Xzh35fwiU3BaBHVzp+vOqPVqniCw2SR+AqEQbEdpeycIfxeGruMQXWfciBihuKekTqkab13JTwkjONB19Gc/1hrmGnsXnf9dIMZqOirx3zeGnFjy+MZeNlcmgCpabh8v7qfDJnuYToAZnN70Ovn899OBe5d6KOMLPTbF08U19nQ515brMDVoggKuv8+AnqamTvb77h6UL99ThqgkEWRf+kab7yCNbWWSve81AFnLgRPpnJW7FaFNx38XyspmuswBsnX+EepdF+/EHeu/fxzgSTSTvvHfClD1SPyAER+GjO4R3bbYDotCZfbKFhmvVG1RQ0StBjpm7al/WtdlasFZh5NjGkmuMDeKqJsYIwjjPcDenF6NZVPtCzE4H21BCLyd88hGHsSp4ZADju4C/McQ60Ifcd9ZoI3ModElBrnV75c6HrIlar+prMs7umCwrQY7o951O5cr/R00Whe3GCz/e4stNg+uzDvnS8GTV2/Y1wfNn0wOt/gVLkg/S8DEJSGx9Yd6CsJ6I4SbRRv1iCKBod/yQe5q8/t1v8nccZzGNLb9rsIG4iCfilj3kkye0e4jTQfvj0dTA5tSKeqHEaksK4gwocQUJ1xxKZpgmJ1ky8qqfvfAA7CLu05eKlgTFyHVnUlrP4soNnbki1l70SrbVVZc4nKz+ihAN4O94xWX1nEjQ4yckq03a3ZKTpcZFGg9qJvON4yV8U8cqpaCAkMoO6OTAtFTsBbveHXyjSu631aCbmPROYVSQ4FpYuDpE8gpY83HWDro9R2sMkkJt1rf0Ol4wfW7sVlPJEOHT3fFZna4KPK7ff24+PiaNUpYcd2SNqMSUm8fk+zYaTx1Q9n046O0Enh6q42GcKWUsNsjxtbTx5Jkdh/tizl+O9HuDc56RaHoTxKwRGBjYQlzFYBzTgNyQxxrNKN2
 F/ElIPPN
 LYGn41IFJA2FZ1jgxGNMbTp1mlhuqANx4UFNhOTvpLyh2FPezhhnly9WTeWNMfBxfaArSuMs+/dLBMDXNCmI108L8llDRq18n4rRWIBo5PnPd9vY5vJvXAhdWjw3LDPORutNVYPZh1ya2/DIUdXWdD0xJl4HQjqt1ynAGWhgFpqfhWjEcl18+tPEo/c1gRN+v+KrfFssNPJenPHVVQ5+h/vAOVkDqE9As0iP8xhHOB26hXCULDStQFGgajs0lmGSLS33bF5y2iLdShCP5qdxFBtDTDiYguZh+gvSecCxls1Ni3AGoda+4DRhwDbCI+5zY9IxSnZHVcX0NYVhgwT9uRH+ukMDkm015uVLTZvM1qhvtBrdMUXxdR8E6SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_20250929154452000000_77253
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=0AJames -=0A =0AThis was greatly helpful, as now I can decode a bit better=
.=0A=0AThe "big picture" insight you provided is that it is primarily (excl=
usively?) focused on post-copy Live Migration as its motivating use case ne=
ver was clear to me before you clarified that in this message. Aha!=0A =0AT=
hat's certainly different from what I'm hoping to use it for. (Just as an a=
side, starting in 2012 or so, I did a lot of design and implementation work=
 on VM-based virtual memory, both at SAP Labs Research and at a startup I c=
o-founded called TidalScale that created an "inverse virtualization" platfo=
rm that moved memory among nodes of a tightly coupled "distributed x86 virt=
ual machine". Essentially, that was a system that was constantly executing =
as if it was in post-copy live migration - the pages flowed between nodes, =
as did the virtual cpus. HPE acquired the product, which worked very well.)=
=0A =0AI'm not focused on live migration at all, so you can see why I might=
 be confused. What really interests me here is moving "kernel functions" ou=
t of the kernel - there's been a lot of work, for example, in I/O from user=
space, which I follow closely. I grew up doing OS research in the early 197=
0's where for lots of reasons the "monolithic kernel" design was resisted (=
e.g. in the Unix sphere, Mach at CMU).  I worked during my M.S. on the Mult=
ics operating system, in particular with paging, and even in my Bachelor's =
thesis, on dealing with multiprocessor and multiprocess paging behavior. Si=
nce Multics was what we now call a "multiprocessor- centric" operating syst=
em with many CPUs sharing memory.=0A=0ASo what I have spent a lot of time o=
ver the years thinking about is how a system with many processes on many cp=
us can effectively share memory when competing for RAM and cache and "disk"=
.=0AMy 1973 bachelor's thesis was "Estimating Working Sets on Multics" (whi=
ch was a time sharing system that supported ~100 concurrent users if provis=
ioned with 3 processors, more if provisioned with 8-10 processors). The B.S=
. thesis recognized that by abandoning common shared LRU list reclaim, the =
OS could make more efficient use of RAM while swapping out to a "paging dru=
m" that was super low latency at the time. So my brain is wired to know tha=
t the current Linux paging (reclaim and fault handling) isn't great. [well,=
 it was born as a uniprocessor OS, and still is architected to privilege wo=
rking well on a uniprocessor - rather than starting as Multics did, with th=
e idea that there are lots of cores. You can see the mess in Linux with all=
 the global locks in the mm kernel code, slowly being addressed.]=0A =0ATha=
t's more context.=0A=0ASo userfaultfd is a tool I think can be used to move=
 monitoring (which may include supervising reclaim) into userspace. It's no=
t complete. process_madvise() may allow moving more into ring 3, but unfort=
unately it doesn't support MADV_PAGEOUT from MADVISE.=0A=0AThat may give yo=
u more context.  (I am not a believer in the idea that the Linux kernel is =
where you protect the system from hackers. The argument for moving function=
 out of the kernel is that you untangle the spaghetti mess of the Linux ker=
nel. Userspace processes can be inside the security perimeter of the system=
, if they are well designed and the kernel supports the right abstractions =
and the right protection mechanisms between processes. I am not sure that T=
orvalds agrees, but I am a LOT more experienced than he. It's his system, t=
hough.)=0A =0AComments intercalated below.=0A =0AOn Monday, September 29, 2=
025 01:30, "James Houghton" <jthoughton@google.com> said:=0A=0A=0A=0A> On S=
at, Sep 27, 2025 at 11:45=E2=80=AFAM David P. Reed <dpreed@deepplum.com>=0A=
> wrote:=0A> >=0A> > OK - responses below.=0A> =0A> I think Peter will be a=
ble to help you the most, but I want to give my=0A> two cents anyway.=0A> =
=0A> >=0A> > I'm still unclear what my role is vs. the others cc'ed on this=
 problem report=0A> is.=0A> >=0A> > Is anyone here (other than Andrew) a de=
cision maker on what userfaultfd is=0A> supposed to do? I can see what the =
current code DOES - and honestly, it's=0A> seriously whacked semantically. =
(see the ExtMem paper for a reasonable use case=0A> that it cannot serve, m=
y use case is quite similar). So is anyone here wanting to=0A> improve the =
functionality? I'm sure its current functions are used by some folks=0A> he=
re - Google employees presumably focused on ChromeOS or Android, I suppose,=
=0A> suggest that there's a use case there.=0A> =0A> I think all of us want=
 userfaultfd to be as useful as possible. :)=0A> Peter, Axel, and I are qui=
te familiar with userfaultfd's use as a tool=0A> for enabling post-copy liv=
e migration for virtual machines.=0A> Userfaultfd minor faults were created=
 expressly for this purpose. Axel=0A> wrote the userfaultfd minor fault sup=
port; I wrote the corresponding=0A> userspace code to use it in Google Clou=
d.=0A =0AExcellent clarification. And congratulations on making that work.=
=0A=0A> =0A> Peter is quite a bit more familiar with userfaultfd than me (a=
nd I=0A> think Axel, but I don't want to speak for him), so please excuse o=
ur=0A> mistakes. (mm is complicated!)=0A> =0A> There are a few others who c=
are about userfaultfd who might jump in as=0A> soon as patches get sent. I =
think these folks (so on top of Peter and=0A> Andrew, people like Suren, Lo=
renzo, David Hildenbrand) will be the=0A> folks who Ack or Nak the patches.=
=0A =0AThat's good to know.=0A =0A> =0A> >=0A> >=0A> >=0A> > My role starte=
d out by reporting that the documentation is both incomplete=0A> and confus=
ing, both in the man pages and the "kernel documentation". And the=0A> rati=
onale presented in the documentation doesn't make sense. Some of you guys=
=0A> admit that you really don't understand how "swap" is different from "f=
ile-backed=0A> paging" (except for the corner cases of hugetlbfs [sort of "=
file backed"],=0A> "file-backed by /dev/zero" [which ends up using "swap"],=
 and tmpfs [also "file=0A> backed" but using "swap"]. And yet "anonymous, p=
rivate" uses "swap" and the "swap=0A> cache", not the "page cache".=0A> =0A=
> The documentation is confusing; I agreed with you originally that it=0A> =
should be updated. (Do you want to send a patch? Perhaps I could give=0A> i=
t a go when I find the time.)=0A> =0A> I spent some time writing out how I =
define the various terms being=0A> used here, I'll leave it at the end of t=
his email in case it is=0A> helpful, but otherwise please just ignore it. I=
 wouldn't say that the=0A> rationale in the documentation doesn't make sens=
e. Userfaultfd exists=0A> to solve specific problems.=0A=0AI thought it was=
 a general purpose interface. My mistake. But I think it can be more genera=
l, at least encompassing my goal of having a userspace "interface" that mon=
itors processes' page faults.=0A=0A> =0A> >=0A> > Now, after digging into t=
he question, I feel like there was never, ever a=0A> coherent architectural=
 design for userfaultfd as a function. It's apparently just=0A> a "hack", n=
ot a "feature".=0A> =0A> Userfaultfd certainly isn't perfect, but it is cri=
tical for things=0A> like VM live migration, Android GC, CRIU, etc..=0A> =
=0A> >=0A> > I'd be happy to propose a much more coherent design (in my opi=
nion as an=0A> operating systems designer for the past more than 20 years, =
starting with Multics=0A> in 1970 - you guys may not be interested in my in=
put, which is fair. Is Linus=0A> interested? That would be a bunch of work =
for me, because I would do a thorough=0A> job, not just a bunch of random p=
atches. But I'm not proposing to join the=0A> maintainer-club - I'm retired=
 from that space, and I find the Linux kernel=0A> contributors poorly organ=
ized and chaotic.=0A> >=0A> > Or, I can just drop this interaction - conclu=
ding that userfaultfd is kind of=0A> useless as is, and really badly docume=
nted to boot.=0A> =0A> I am interested to hear your ideas for how you think=
 userfaultfd=0A> should work and how it solves your problem. :) At the end =
of the day,=0A> I'm just trying (though clearly failing miserably) to help =
you solve=0A> your problem.=0A> =0A> Your characterization of userfaultfd a=
s a "useless" "bunch of random=0A> patches" that is just a "hack" is wrong.=
 I understand; it doesn't=0A> support your needs. I think what Peter, Axel,=
 and I have been trying=0A> to understand is what exactly you're trying to =
do and how userfaultfd=0A> could (or may not) help you get there. You've sh=
ared some[1]=0A> details[2] about what you're looking for, so thank you for=
 that, but I=0A> am still struggling to understand how the flexibility that=
 you're=0A> asking for is actually the right tool for the problem(s) you're=
 trying=0A> to solve.=0A> =0A> [1]: https://lore.kernel.org/linux-mm/175803=
7039.08578612@apps.rackspace.com/=0A> [2]: https://lore.kernel.org/linux-mm=
/1758042583.108320755@apps.rackspace.com/=0A> =0A> > There is no sensible w=
ay to respond to a "missing event" when "missing" means=0A> the page is swa=
pped out (to SWAP) by UFFDIO_COPY or UFFDIO_ZEROPAGE. That's just=0A> weird=
, and you continue to insist on it. Where is the page that was swapped out?=
=0A> Well, one could look at the PTE in /proc/pid/maps, and you find that i=
ts "swap=0A> entry" is there as an index into a block device. (so, maybe yo=
u can open the swap=0A> device using some file descriptor and mmap() it int=
o the manager process, then=0A> UFFDIO_COPY, but what if the swap page is a=
ctually in the "swap cache", you can't=0A> mmap any swap cache page via any=
 userspace API - do you know a way to do that?)=0A> =0A> (Please see the te=
rms that I use at the bottom of this email; let me=0A> reply using those te=
rms.)=0A> =0A> UFFDIO_COPY has quite well-defined semantics (albeit, perhap=
s not=0A> *documented* well):=0A> =0A> * For anonymous VMAs: UFFDIO_COPY wi=
ll allocate page(s), copy some=0A> user memory into the page(s) and map tho=
se pages at the specified VAs.=0A> * For hugetlbfs and shmem/tmpfs VMAs, UF=
FDIO_COPY will fill holes in=0A> the file's page cache with new pages, copy=
 the user memory in, and map=0A> those pages. UFFDIO_CONTINUE is additional=
ly supported; it skips the=0A> hole-filling step and requires the page cach=
e to be populated.=0A> =0A> For UFFDIO_COPY, if a page at a to-be-populated=
 VA has already been=0A> allocated (including if it has been reclaimed), th=
e call will be=0A> rejected. It would effectively be overwriting the conten=
ts of the=0A> page; this is not supported today.=0A> =0A> If "missing" incl=
udes swapped out pages, UFFDIO_COPY and=0A> UFFDIO_ZEROPAGE would need to b=
e allowed to overwrite the existing=0A> contents. "Sensible" or not, there =
has been no need for this yet.=0A> =0A> > Now I reported a bug in UFFIO_REG=
ISTER [...]=0A> =0A> The bug you reported is in the documentation only.=0A>=
 =0A> > [...] which you keep saying is the same as UFFDIO_CONTINUE. Well, i=
t isn't! I=0A> can register a minor handler (which allows continue) if I us=
e=0A> MAP_ANONYMOUS|MAP_SHARED. The same "swap cache" mechanics exactly app=
ly. The only=0A> "sharing" is potential future sharing after that process f=
orks, in which case, the=0A> same "swap page" is shared until a Copy on Wri=
te forces the page to be unshared -=0A> it is a writeable page, just sharin=
g the same physical block. It can be swapped=0A> out to the swap cache and =
the swap device, which sets the PTE to be a "swap entry"=0A> that causes a =
page fault.=0A> =0A> (Using the terms at the bottom of this email.)=0A> =0A=
> For UFFDIO_CONTINUE, the swap cache mechanics are like:=0A> =0A> 1. For a=
nonymous pages in the VMA: swap-outs will not clear the PTEs,=0A> touching =
the page will swap it back in again, UFFDIO_CONTINUE on it is=0A> disallowe=
d.=0A> 2. For page cache pages in the VMA (i.e., not-yet-written-to pages f=
or=0A> MAP_PRIVATE, any page for MAP_SHARED): swap-outs will clear the PTEs=
,=0A> and touching the page will trigger a minor fault, and UFFDIO_CONTINUE=
=0A> will swap it back in.=0A> =0A> For MAP_ANONYMOUS|MAP_PRIVATE, all page=
s in the VMA will be anonymous=0A> pages, so UFFDIO_CONTINUE will never be =
allowed, therefore=0A> registration in the first place is disallowed.=0A> =
=0A> (IMHO, it was dubious to have even allowed registering userfaultfd=0A>=
 minor faults with *any* MAP_PRIVATE VMA.)=0A> =0A> > The swap device doesn=
't know where the pages are mapped. You need to look at=0A> the PTEs of all=
 the processes to find the translation to swap cache entry, and if=0A> you =
want to go backward from swap entry to pages, you need to use a special XAr=
ray=0A> that finds VMAs given swap entry.=0A> >=0A> > But the point here I =
keep making is that UFFDIO_REGISTER rejects only=0A> MAP_ANONYMOUS that are=
 MAP_PRIVATE and also not huge pages. To me that's weird.=0A> =0A> I hope m=
y above explanation (of sorts) makes it a little less weird.=0A> =0A> > If =
it is the CoW case that doesn't work (I doubt it), well, you have to read=
=0A> the swapped out page into memory before copying it anyway. Then you co=
py on write,=0A> from the page read or found in the swap cache.=0A> >=0A> >=
 Now, as you say, that may require allocating a new page, also in the swap=
=0A> cache. Is that a "missing" page in the weird userfaultfd terminology? =
If so, to=0A> handle it can't be done with UFFIO_COPY, because you can't ac=
cess the contents=0A> from userspace. And it's not "write protected" from t=
he perspective of WP.=0A> =0A> No it isn't a missing userfault. Data exists=
 at the VA for which a=0A> userfault would be generated, therefore it canno=
t be "missing".=0A> =0A> >=0A> >=0A> >=0A> > > The only exception I can=0A>=
 > > think of is swap faults, I could see anon swap faults (perhaps=0A> > >=
 specifically when the page is in the swap cache?) being considered=0A> > >=
 UFFD minor faults, but I would be curious to know what the use case is=0A>=
 > > for that / why you would want to do that. The original use case for=0A=
> > > UFFD minor fault support was demand paging for VMs, where you have=0A=
> > > some kind of shared memory (shmem or hugetlb) where one side of the=
=0A> > > mapping is given to the VM, and the other side of the shared mappi=
ng=0A> > > is used by the hypervisor to populate guest memory on-demand in=
=0A> > > response to userfaultfd events.=0A> >=0A> >=0A> >=0A> > I think I'=
ve just answered this. userfaultfd doesn't support the "swap out"=0A> part =
of anonymous swapping at all. So, how could a manager get the page contents=
=0A> as of the instant it is put in the swap cache for writing out to the s=
wap device?=0A> There's no "swap out" event mechanism, and no way to treat =
the swap device cached=0A> into the swap cache as a page source. (not to me=
ntion the zswap mechanism, which=0A> compresses some of the pages into an i=
nvisible piece of memory).=0A> >=0A> >=0A> > >=0A> > > To me it's not inten=
ded userfaultfd minor events are generated for=0A> > > writeprotect faults,=
 to me that's the domain of userfaultfd-wp, not=0A> > > minor faults. James=
 might be right that these unintentionally trigger=0A> > > minor faults tod=
ay, I would need to do some more reading of the code=0A> > > to be certain =
though.=0A> >=0A> > I don't particulary care about writeprotect faults, but=
 CoW probably=0A> shouldn't be considered the same as a writeprotect fault,=
 because CoW is triggered=0A> by a write into a writeable area, ONLY in one=
 of the mappings, whichever is=0A> written first. The process doesn't think=
 of it as a "write" - it just is a kernel=0A> optimization of a common case=
 where fork is followed by non-use, so the actual=0A> copy could have been =
done at fork time, semantically. It's a deferred read and=0A> allocation.=
=0A> >=0A> >=0A> >=0A> > I hope this helps clarify my concerns.=0A> >=0A> >=
 There are several reasonable outcomes -=0A> >=0A> > 1. Much better documen=
tation of what the code actually does (and why).=0A> =0A> Agreed.=0A> =0A> =
> 2. Fix the "bug" that prevents REGISTER of "minor" handler on private,=0A=
> anonymous mappings (obviously, you can REGISTER missing handlers as well)=
, then=0A> document actually what happens during the life cycle of swapping=
 of pages in=0A> detail, including MAP_PRIVATE|MAP_ANONYMOUS VMAs.=0A> =0A>=
 Not a bug.=0A> =0A> > 3. Do a thorough analysis of what userfaultfd really=
 should do, if the goal=0A> is to provide the ability of a "manager process=
" to get to handle all cases of=0A> page fault behavior on a case-by-case b=
asis for regions of user addressable=0A> pages.=0A> =0A> What userfaultfd "=
should do" is up to the problems we need it to solve.=0A> =0A> > I'd be hap=
py to contribute to (but not manage) whichever outcome - and I have=0A> wha=
t I think is a reasonable use case. (and I'm aware that this API accidental=
ly=0A> created a serious hacker exploit earlier in its life, by creating a =
way to hang=0A> one process from another. I think that's no longer so easy.=
)=0A> =0A> I would be glad to hear what changes you think should be made to=
=0A> userfaultfd to better suit your needs.=0A> =0A> Sorry if this reply is=
 somewhat incoherent; I've gone back and forth a=0A> few times on how to re=
spond to your points in the most helpful way I=0A> can. I've tried to be as=
 clear as possible without being too verbose.=0A> =0A> - James=0A> =0A> --=
=0A> =0A> Alrighty here are the terms/definitions I use, as I mentioned abo=
ve.=0A> Again feel, free to ignore them if they are unhelpful:=0A> =0A> A "=
file-backed VMA" will load pages into the page cache. For most=0A> filesyst=
ems, the page is loaded from a disk (or a proper device), but=0A> for speci=
al filesystems like tmpfs, hugetlbfs, and ramfs, the page=0A> cache is popu=
lated with zeroed pages initially.=0A> =0A> tmpfs is kind of like a filesys=
tem API for shmem, but they are so=0A> interconnected that many people use =
the terms interchangeably. (To=0A> clarify, I don't think of "shmem" as sho=
rthand for "shared memory"; to=0A> me, it is the name of an mm subsystem.) =
Every MAP_ANONYMOUS|MAP_SHARED=0A> VMA is a shmem VMA; it is as if there is=
 a tmpfs file backing VMAs=0A> like these, so they are in some contexts con=
sidered "file-backed". See=0A> shmem_zero_setup(). As far as I'm concerned,=
 vma->vm_file is set, so=0A> the VMA is file-backed (even though the mmap f=
lags included=0A> MAP_ANONYMOUS). I assume this is what you are referring t=
o when you=0A> say "file-backed by /dev/zero".=0A> =0A> For any MAP_PRIVATE=
 VMA, some pages may be "anonymous", in that no=0A> page cache is holding a=
 reference to it (i.e., generally speaking, the=0A> only references on the =
page are the ones taken by the PTEs mapping the=0A> page). Reclaim of pages=
 like these will put them in a swap cache.=0A> =0A> For pages where a refer=
ence is held in a page cache, if the page is=0A> dirty, it can be written o=
ut to disk. shmem implements "writeout" by=0A> swapping just like anonymous=
 pages, but other filesystems implement it=0A> how you would expect.=0A> 
------=_20250929154452000000_77253
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<font face=3D"arial" size=3D"2"><p style=3D"margin:0;padding:0;font-family:=
 arial; font-size: 10pt; overflow-wrap: break-word;">James -</p>=0A<p style=
=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap: =
break-word;">&nbsp;</p>=0A<p style=3D"margin:0;padding:0;font-family: arial=
; font-size: 10pt; overflow-wrap: break-word;">This was greatly helpful, as=
 now I can decode a bit better.</p>=0A<p style=3D"margin:0;padding:0;font-f=
amily: arial; font-size: 10pt; overflow-wrap: break-word;"><br />The "big p=
icture" insight you provided is that it is primarily (exclusively?) focused=
 on post-copy Live Migration as its motivating use case never was clear to =
me before you clarified that in this message. Aha!</p>=0A<p style=3D"margin=
:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap: break-word=
;">&nbsp;</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-siz=
e: 10pt; overflow-wrap: break-word;">That's certainly different from what I=
'm hoping to use it for. (Just as an aside, starting in 2012 or so, I did a=
 lot of design and implementation work on VM-based virtual memory, both at =
SAP Labs Research and at a startup I co-founded called TidalScale that crea=
ted an "inverse virtualization" platform that moved memory among nodes of a=
 tightly coupled "distributed x86 virtual machine". Essentially, that was a=
 system that was constantly executing as if it was in post-copy live migrat=
ion - the pages flowed between nodes, as did the virtual cpus. HPE acquired=
 the product, which worked very well.)</p>=0A<p style=3D"margin:0;padding:0=
;font-family: arial; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</p=
>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; ove=
rflow-wrap: break-word;">I'm not focused on live migration at all, so you c=
an see why I might be confused. What really interests me here is moving "ke=
rnel functions" out of the kernel - there's been a lot of work, for example=
, in I/O from userspace, which I follow closely. I grew up&nbsp;doing OS re=
search in the early 1970's where for lots of reasons the "monolithic kernel=
" design was resisted (e.g. in the Unix sphere, Mach at CMU).&nbsp; I worke=
d during my M.S. on the Multics operating system, in particular with paging=
, and even in my Bachelor's thesis, on dealing with multiprocessor and mult=
iprocess paging behavior. Since Multics was what we now call a "multiproces=
sor- centric" operating system with many CPUs sharing memory.<br /><br />So=
 what I have spent a lot of time over the years thinking about is how a sys=
tem with many processes on many cpus can effectively share memory when comp=
eting for RAM and cache and "disk".</p>=0A<p style=3D"margin:0;padding:0;fo=
nt-family: arial; font-size: 10pt; overflow-wrap: break-word;">My 1973 bach=
elor's thesis was "Estimating Working Sets on Multics" (which was a time sh=
aring system that supported ~100 concurrent users if provisioned with 3 pro=
cessors, more if provisioned with 8-10 processors). The B.S. thesis recogni=
zed that by abandoning common shared LRU list reclaim, the OS could make mo=
re efficient use of RAM while swapping out to a "paging drum" that was supe=
r low latency at the time. So my brain is wired to know that the current Li=
nux paging (reclaim and fault handling) isn't great. [well, it was born as =
a uniprocessor OS, and still is architected to privilege working well on a =
uniprocessor - rather than starting as Multics did, with the idea that ther=
e are lots of cores. You can see the mess in Linux with all the global lock=
s in the mm kernel code, slowly being addressed.]</p>=0A<p style=3D"margin:=
0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap: break-word;=
">&nbsp;</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size=
: 10pt; overflow-wrap: break-word;">That's more context.<br /><br />So user=
faultfd is a tool I think can be used to move monitoring (which may include=
 supervising reclaim) into userspace. It's not complete. process_madvise() =
may allow moving more into ring 3, but unfortunately it doesn't support MAD=
V_PAGEOUT from MADVISE.<br /><br />That may give you more context.&nbsp; (I=
 am not a believer in the idea that the Linux kernel is where you protect t=
he system from hackers. The argument for moving function out of the kernel =
is that you untangle the spaghetti mess of the Linux kernel. Userspace proc=
esses can be inside the security perimeter of the system, if they are well =
designed and the kernel supports the right abstractions and the right prote=
ction mechanisms between processes. I am not sure that Torvalds agrees, but=
 I am a LOT more experienced than he. It's his system, though.)</p>=0A<p st=
yle=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wra=
p: break-word;">&nbsp;</p>=0A<p style=3D"margin:0;padding:0;font-family: ar=
ial; font-size: 10pt; overflow-wrap: break-word;">Comments intercalated bel=
ow.</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10p=
t; overflow-wrap: break-word;">&nbsp;</p>=0A<p style=3D"margin:0;padding:0;=
font-family: arial; font-size: 10pt; overflow-wrap: break-word;">On Monday,=
 September 29, 2025 01:30, "James Houghton" &lt;jthoughton@google.com&gt; s=
aid:<br /><br /></p>=0A<div id=3D"SafeStyles1759169065">=0A<p style=3D"marg=
in:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap: break-wo=
rd;">&gt; On Sat, Sep 27, 2025 at 11:45=E2=80=AFAM David P. Reed &lt;dpreed=
@deepplum.com&gt;<br />&gt; wrote:<br />&gt; &gt;<br />&gt; &gt; OK - respo=
nses below.<br />&gt; <br />&gt; I think Peter will be able to help you the=
 most, but I want to give my<br />&gt; two cents anyway.<br />&gt; <br />&g=
t; &gt;<br />&gt; &gt; I'm still unclear what my role is vs. the others cc'=
ed on this problem report<br />&gt; is.<br />&gt; &gt;<br />&gt; &gt; Is an=
yone here (other than Andrew) a decision maker on what userfaultfd is<br />=
&gt; supposed to do? I can see what the current code DOES - and honestly, i=
t's<br />&gt; seriously whacked semantically. (see the ExtMem paper for a r=
easonable use case<br />&gt; that it cannot serve, my use case is quite sim=
ilar). So is anyone here wanting to<br />&gt; improve the functionality? I'=
m sure its current functions are used by some folks<br />&gt; here - Google=
 employees presumably focused on ChromeOS or Android, I suppose,<br />&gt; =
suggest that there's a use case there.<br />&gt; <br />&gt; I think all of =
us want userfaultfd to be as useful as possible. :)<br />&gt; Peter, Axel, =
and I are quite familiar with userfaultfd's use as a tool<br />&gt; for ena=
bling post-copy live migration for virtual machines.<br />&gt; Userfaultfd =
minor faults were created expressly for this purpose. Axel<br />&gt; wrote =
the userfaultfd minor fault support; I wrote the corresponding<br />&gt; us=
erspace code to use it in Google Cloud.</p>=0A<p style=3D"margin:0;padding:=
0;font-family: arial; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</=
p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; ov=
erflow-wrap: break-word;">Excellent clarification. And congratulations on m=
aking that work.</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; f=
ont-size: 10pt; overflow-wrap: break-word;"><br />&gt; <br />&gt; Peter is =
quite a bit more familiar with userfaultfd than me (and I<br />&gt; think A=
xel, but I don't want to speak for him), so please excuse our<br />&gt; mis=
takes. (mm is complicated!)<br />&gt; <br />&gt; There are a few others who=
 care about userfaultfd who might jump in as<br />&gt; soon as patches get =
sent. I think these folks (so on top of Peter and<br />&gt; Andrew, people =
like Suren, Lorenzo, David Hildenbrand) will be the<br />&gt; folks who Ack=
 or Nak the patches.</p>=0A<p style=3D"margin:0;padding:0;font-family: aria=
l; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p style=3D"ma=
rgin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap: break-=
word;">That's good to know.</p>=0A<p style=3D"margin:0;padding:0;font-famil=
y: arial; font-size: 10pt; overflow-wrap: break-word;">&nbsp;</p>=0A<p styl=
e=3D"margin:0;padding:0;font-family: arial; font-size: 10pt; overflow-wrap:=
 break-word;">&gt; <br />&gt; &gt;<br />&gt; &gt;<br />&gt; &gt;<br />&gt; =
&gt; My role started out by reporting that the documentation is both incomp=
lete<br />&gt; and confusing, both in the man pages and the "kernel documen=
tation". And the<br />&gt; rationale presented in the documentation doesn't=
 make sense. Some of you guys<br />&gt; admit that you really don't underst=
and how "swap" is different from "file-backed<br />&gt; paging" (except for=
 the corner cases of hugetlbfs [sort of "file backed"],<br />&gt; "file-bac=
ked by /dev/zero" [which ends up using "swap"], and tmpfs [also "file<br />=
&gt; backed" but using "swap"]. And yet "anonymous, private" uses "swap" an=
d the "swap<br />&gt; cache", not the "page cache".<br />&gt; <br />&gt; Th=
e documentation is confusing; I agreed with you originally that it<br />&gt=
; should be updated. (Do you want to send a patch? Perhaps I could give<br =
/>&gt; it a go when I find the time.)<br />&gt; <br />&gt; I spent some tim=
e writing out how I define the various terms being<br />&gt; used here, I'l=
l leave it at the end of this email in case it is<br />&gt; helpful, but ot=
herwise please just ignore it. I wouldn't say that the<br />&gt; rationale =
in the documentation doesn't make sense. Userfaultfd exists<br />&gt; to so=
lve specific problems.<br /><br />I thought it was a general purpose interf=
ace. My mistake. But I think it can be more general, at least encompassing =
my goal of having a userspace "interface" that monitors processes' page fau=
lts.</p>=0A<p style=3D"margin:0;padding:0;font-family: arial; font-size: 10=
pt; overflow-wrap: break-word;"><br />&gt; <br />&gt; &gt;<br />&gt; &gt; N=
ow, after digging into the question, I feel like there was never, ever a<br=
 />&gt; coherent architectural design for userfaultfd as a function. It's a=
pparently just<br />&gt; a "hack", not a "feature".<br />&gt; <br />&gt; Us=
erfaultfd certainly isn't perfect, but it is critical for things<br />&gt; =
like VM live migration, Android GC, CRIU, etc..<br />&gt; <br />&gt; &gt;<b=
r />&gt; &gt; I'd be happy to propose a much more coherent design (in my op=
inion as an<br />&gt; operating systems designer for the past more than 20 =
years, starting with Multics<br />&gt; in 1970 - you guys may not be intere=
sted in my input, which is fair. Is Linus<br />&gt; interested? That would =
be a bunch of work for me, because I would do a thorough<br />&gt; job, not=
 just a bunch of random patches. But I'm not proposing to join the<br />&gt=
; maintainer-club - I'm retired from that space, and I find the Linux kerne=
l<br />&gt; contributors poorly organized and chaotic.<br />&gt; &gt;<br />=
&gt; &gt; Or, I can just drop this interaction - concluding that userfaultf=
d is kind of<br />&gt; useless as is, and really badly documented to boot.<=
br />&gt; <br />&gt; I am interested to hear your ideas for how you think u=
serfaultfd<br />&gt; should work and how it solves your problem. :) At the =
end of the day,<br />&gt; I'm just trying (though clearly failing miserably=
) to help you solve<br />&gt; your problem.<br />&gt; <br />&gt; Your chara=
cterization of userfaultfd as a "useless" "bunch of random<br />&gt; patche=
s" that is just a "hack" is wrong. I understand; it doesn't<br />&gt; suppo=
rt your needs. I think what Peter, Axel, and I have been trying<br />&gt; t=
o understand is what exactly you're trying to do and how userfaultfd<br />&=
gt; could (or may not) help you get there. You've shared some[1]<br />&gt; =
details[2] about what you're looking for, so thank you for that, but I<br /=
>&gt; am still struggling to understand how the flexibility that you're<br =
/>&gt; asking for is actually the right tool for the problem(s) you're tryi=
ng<br />&gt; to solve.<br />&gt; <br />&gt; [1]: https://lore.kernel.org/li=
nux-mm/1758037039.08578612@apps.rackspace.com/<br />&gt; [2]: https://lore.=
kernel.org/linux-mm/1758042583.108320755@apps.rackspace.com/<br />&gt; <br =
/>&gt; &gt; There is no sensible way to respond to a "missing event" when "=
missing" means<br />&gt; the page is swapped out (to SWAP) by UFFDIO_COPY o=
r UFFDIO_ZEROPAGE. That's just<br />&gt; weird, and you continue to insist =
on it. Where is the page that was swapped out?<br />&gt; Well, one could lo=
ok at the PTE in /proc/pid/maps, and you find that its "swap<br />&gt; entr=
y" is there as an index into a block device. (so, maybe you can open the sw=
ap<br />&gt; device using some file descriptor and mmap() it into the manag=
er process, then<br />&gt; UFFDIO_COPY, but what if the swap page is actual=
ly in the "swap cache", you can't<br />&gt; mmap any swap cache page via an=
y userspace API - do you know a way to do that?)<br />&gt; <br />&gt; (Plea=
se see the terms that I use at the bottom of this email; let me<br />&gt; r=
eply using those terms.)<br />&gt; <br />&gt; UFFDIO_COPY has quite well-de=
fined semantics (albeit, perhaps not<br />&gt; *documented* well):<br />&gt=
; <br />&gt; * For anonymous VMAs: UFFDIO_COPY will allocate page(s), copy =
some<br />&gt; user memory into the page(s) and map those pages at the spec=
ified VAs.<br />&gt; * For hugetlbfs and shmem/tmpfs VMAs, UFFDIO_COPY will=
 fill holes in<br />&gt; the file's page cache with new pages, copy the use=
r memory in, and map<br />&gt; those pages. UFFDIO_CONTINUE is additionally=
 supported; it skips the<br />&gt; hole-filling step and requires the page =
cache to be populated.<br />&gt; <br />&gt; For UFFDIO_COPY, if a page at a=
 to-be-populated VA has already been<br />&gt; allocated (including if it h=
as been reclaimed), the call will be<br />&gt; rejected. It would effective=
ly be overwriting the contents of the<br />&gt; page; this is not supported=
 today.<br />&gt; <br />&gt; If "missing" includes swapped out pages, UFFDI=
O_COPY and<br />&gt; UFFDIO_ZEROPAGE would need to be allowed to overwrite =
the existing<br />&gt; contents. "Sensible" or not, there has been no need =
for this yet.<br />&gt; <br />&gt; &gt; Now I reported a bug in UFFIO_REGIS=
TER [...]<br />&gt; <br />&gt; The bug you reported is in the documentation=
 only.<br />&gt; <br />&gt; &gt; [...] which you keep saying is the same as=
 UFFDIO_CONTINUE. Well, it isn't! I<br />&gt; can register a minor handler =
(which allows continue) if I use<br />&gt; MAP_ANONYMOUS|MAP_SHARED. The sa=
me "swap cache" mechanics exactly apply. The only<br />&gt; "sharing" is po=
tential future sharing after that process forks, in which case, the<br />&g=
t; same "swap page" is shared until a Copy on Write forces the page to be u=
nshared -<br />&gt; it is a writeable page, just sharing the same physical =
block. It can be swapped<br />&gt; out to the swap cache and the swap devic=
e, which sets the PTE to be a "swap entry"<br />&gt; that causes a page fau=
lt.<br />&gt; <br />&gt; (Using the terms at the bottom of this email.)<br =
/>&gt; <br />&gt; For UFFDIO_CONTINUE, the swap cache mechanics are like:<b=
r />&gt; <br />&gt; 1. For anonymous pages in the VMA: swap-outs will not c=
lear the PTEs,<br />&gt; touching the page will swap it back in again, UFFD=
IO_CONTINUE on it is<br />&gt; disallowed.<br />&gt; 2. For page cache page=
s in the VMA (i.e., not-yet-written-to pages for<br />&gt; MAP_PRIVATE, any=
 page for MAP_SHARED): swap-outs will clear the PTEs,<br />&gt; and touchin=
g the page will trigger a minor fault, and UFFDIO_CONTINUE<br />&gt; will s=
wap it back in.<br />&gt; <br />&gt; For MAP_ANONYMOUS|MAP_PRIVATE, all pag=
es in the VMA will be anonymous<br />&gt; pages, so UFFDIO_CONTINUE will ne=
ver be allowed, therefore<br />&gt; registration in the first place is disa=
llowed.<br />&gt; <br />&gt; (IMHO, it was dubious to have even allowed reg=
istering userfaultfd<br />&gt; minor faults with *any* MAP_PRIVATE VMA.)<br=
 />&gt; <br />&gt; &gt; The swap device doesn't know where the pages are ma=
pped. You need to look at<br />&gt; the PTEs of all the processes to find t=
he translation to swap cache entry, and if<br />&gt; you want to go backwar=
d from swap entry to pages, you need to use a special XArray<br />&gt; that=
 finds VMAs given swap entry.<br />&gt; &gt;<br />&gt; &gt; But the point h=
ere I keep making is that UFFDIO_REGISTER rejects only<br />&gt; MAP_ANONYM=
OUS that are MAP_PRIVATE and also not huge pages. To me that's weird.<br />=
&gt; <br />&gt; I hope my above explanation (of sorts) makes it a little le=
ss weird.<br />&gt; <br />&gt; &gt; If it is the CoW case that doesn't work=
 (I doubt it), well, you have to read<br />&gt; the swapped out page into m=
emory before copying it anyway. Then you copy on write,<br />&gt; from the =
page read or found in the swap cache.<br />&gt; &gt;<br />&gt; &gt; Now, as=
 you say, that may require allocating a new page, also in the swap<br />&gt=
; cache. Is that a "missing" page in the weird userfaultfd terminology? If =
so, to<br />&gt; handle it can't be done with UFFIO_COPY, because you can't=
 access the contents<br />&gt; from userspace. And it's not "write protecte=
d" from the perspective of WP.<br />&gt; <br />&gt; No it isn't a missing u=
serfault. Data exists at the VA for which a<br />&gt; userfault would be ge=
nerated, therefore it cannot be "missing".<br />&gt; <br />&gt; &gt;<br />&=
gt; &gt;<br />&gt; &gt;<br />&gt; &gt; &gt; The only exception I can<br />&=
gt; &gt; &gt; think of is swap faults, I could see anon swap faults (perhap=
s<br />&gt; &gt; &gt; specifically when the page is in the swap cache?) bei=
ng considered<br />&gt; &gt; &gt; UFFD minor faults, but I would be curious=
 to know what the use case is<br />&gt; &gt; &gt; for that / why you would =
want to do that. The original use case for<br />&gt; &gt; &gt; UFFD minor f=
ault support was demand paging for VMs, where you have<br />&gt; &gt; &gt; =
some kind of shared memory (shmem or hugetlb) where one side of the<br />&g=
t; &gt; &gt; mapping is given to the VM, and the other side of the shared m=
apping<br />&gt; &gt; &gt; is used by the hypervisor to populate guest memo=
ry on-demand in<br />&gt; &gt; &gt; response to userfaultfd events.<br />&g=
t; &gt;<br />&gt; &gt;<br />&gt; &gt;<br />&gt; &gt; I think I've just answ=
ered this. userfaultfd doesn't support the "swap out"<br />&gt; part of ano=
nymous swapping at all. So, how could a manager get the page contents<br />=
&gt; as of the instant it is put in the swap cache for writing out to the s=
wap device?<br />&gt; There's no "swap out" event mechanism, and no way to =
treat the swap device cached<br />&gt; into the swap cache as a page source=
. (not to mention the zswap mechanism, which<br />&gt; compresses some of t=
he pages into an invisible piece of memory).<br />&gt; &gt;<br />&gt; &gt;<=
br />&gt; &gt; &gt;<br />&gt; &gt; &gt; To me it's not intended userfaultfd=
 minor events are generated for<br />&gt; &gt; &gt; writeprotect faults, to=
 me that's the domain of userfaultfd-wp, not<br />&gt; &gt; &gt; minor faul=
ts. James might be right that these unintentionally trigger<br />&gt; &gt; =
&gt; minor faults today, I would need to do some more reading of the code<b=
r />&gt; &gt; &gt; to be certain though.<br />&gt; &gt;<br />&gt; &gt; I do=
n't particulary care about writeprotect faults, but CoW probably<br />&gt; =
shouldn't be considered the same as a writeprotect fault, because CoW is tr=
iggered<br />&gt; by a write into a writeable area, ONLY in one of the mapp=
ings, whichever is<br />&gt; written first. The process doesn't think of it=
 as a "write" - it just is a kernel<br />&gt; optimization of a common case=
 where fork is followed by non-use, so the actual<br />&gt; copy could have=
 been done at fork time, semantically. It's a deferred read and<br />&gt; a=
llocation.<br />&gt; &gt;<br />&gt; &gt;<br />&gt; &gt;<br />&gt; &gt; I ho=
pe this helps clarify my concerns.<br />&gt; &gt;<br />&gt; &gt; There are =
several reasonable outcomes -<br />&gt; &gt;<br />&gt; &gt; 1. Much better =
documentation of what the code actually does (and why).<br />&gt; <br />&gt=
; Agreed.<br />&gt; <br />&gt; &gt; 2. Fix the "bug" that prevents REGISTER=
 of "minor" handler on private,<br />&gt; anonymous mappings (obviously, yo=
u can REGISTER missing handlers as well), then<br />&gt; document actually =
what happens during the life cycle of swapping of pages in<br />&gt; detail=
, including MAP_PRIVATE|MAP_ANONYMOUS VMAs.<br />&gt; <br />&gt; Not a bug.=
<br />&gt; <br />&gt; &gt; 3. Do a thorough analysis of what userfaultfd re=
ally should do, if the goal<br />&gt; is to provide the ability of a "manag=
er process" to get to handle all cases of<br />&gt; page fault behavior on =
a case-by-case basis for regions of user addressable<br />&gt; pages.<br />=
&gt; <br />&gt; What userfaultfd "should do" is up to the problems we need =
it to solve.<br />&gt; <br />&gt; &gt; I'd be happy to contribute to (but n=
ot manage) whichever outcome - and I have<br />&gt; what I think is a reaso=
nable use case. (and I'm aware that this API accidentally<br />&gt; created=
 a serious hacker exploit earlier in its life, by creating a way to hang<br=
 />&gt; one process from another. I think that's no longer so easy.)<br />&=
gt; <br />&gt; I would be glad to hear what changes you think should be mad=
e to<br />&gt; userfaultfd to better suit your needs.<br />&gt; <br />&gt; =
Sorry if this reply is somewhat incoherent; I've gone back and forth a<br /=
>&gt; few times on how to respond to your points in the most helpful way I<=
br />&gt; can. I've tried to be as clear as possible without being too verb=
ose.<br />&gt; <br />&gt; - James<br />&gt; <br />&gt; --<br />&gt; <br />&=
gt; Alrighty here are the terms/definitions I use, as I mentioned above.<br=
 />&gt; Again feel, free to ignore them if they are unhelpful:<br />&gt; <b=
r />&gt; A "file-backed VMA" will load pages into the page cache. For most<=
br />&gt; filesystems, the page is loaded from a disk (or a proper device),=
 but<br />&gt; for special filesystems like tmpfs, hugetlbfs, and ramfs, th=
e page<br />&gt; cache is populated with zeroed pages initially.<br />&gt; =
<br />&gt; tmpfs is kind of like a filesystem API for shmem, but they are s=
o<br />&gt; interconnected that many people use the terms interchangeably. =
(To<br />&gt; clarify, I don't think of "shmem" as shorthand for "shared me=
mory"; to<br />&gt; me, it is the name of an mm subsystem.) Every MAP_ANONY=
MOUS|MAP_SHARED<br />&gt; VMA is a shmem VMA; it is as if there is a tmpfs =
file backing VMAs<br />&gt; like these, so they are in some contexts consid=
ered "file-backed". See<br />&gt; shmem_zero_setup(). As far as I'm concern=
ed, vma-&gt;vm_file is set, so<br />&gt; the VMA is file-backed (even thoug=
h the mmap flags included<br />&gt; MAP_ANONYMOUS). I assume this is what y=
ou are referring to when you<br />&gt; say "file-backed by /dev/zero".<br /=
>&gt; <br />&gt; For any MAP_PRIVATE VMA, some pages may be "anonymous", in=
 that no<br />&gt; page cache is holding a reference to it (i.e., generally=
 speaking, the<br />&gt; only references on the page are the ones taken by =
the PTEs mapping the<br />&gt; page). Reclaim of pages like these will put =
them in a swap cache.<br />&gt; <br />&gt; For pages where a reference is h=
eld in a page cache, if the page is<br />&gt; dirty, it can be written out =
to disk. shmem implements "writeout" by<br />&gt; swapping just like anonym=
ous pages, but other filesystems implement it<br />&gt; how you would expec=
t.<br />&gt; </p>=0A</div></font>
------=_20250929154452000000_77253--


