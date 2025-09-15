Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F7FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 22:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC158E0008; Mon, 15 Sep 2025 18:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C8B8E0001; Mon, 15 Sep 2025 18:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2138E0008; Mon, 15 Sep 2025 18:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9A18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:58:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1349013BB59
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:58:51 +0000 (UTC)
X-FDA: 83893001262.05.77A5318
Received: from smtp65.iad3a.emailsrvr.com (smtp65.iad3a.emailsrvr.com [173.203.187.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2423940002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:58:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.65 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0B0jIBUypcsMv7JFXGr3n8yU31n1yH4BiOlwjyoAWs=;
	b=mjkdIRrHWqcSvHTzn7gS0tNBKTnQYY8smBj+nU23enwd1LbPFZRx2sB1OBxcKXzv2CktWI
	LzLglm+pY8X+r+Odv3VjjVlkT9yNUwROjIEl/7i1elMUHnCK+Vnq4d/KCcfA/q/BkL2Y56
	P+zpDeckq7I1Dxr1hdcXepLqjdgPjy4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.65 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977129; a=rsa-sha256;
	cv=none;
	b=Pg185xJiXaCvxngwD2IwiOLwzvXOtWgU+MqT80fAa6xk6GJeukLpaEQ08+myGxHQuSnYU2
	ot2krtPvH69S9ncDlwonanETys9IkhkSYIZfbspWkHmcqExGhuKuSWzcieDz96YPsbyTj/
	Nkx2aR/FLWDssiqvDPYAeKirVbKCBc0=
Received: from app64.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp1.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 4368B44B1;
	Mon, 15 Sep 2025 18:58:48 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app64.wa-webapps.iad3a (Postfix) with ESMTP id 22B9061F2D;
	Mon, 15 Sep 2025 18:58:48 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Mon, 15 Sep 2025 18:58:48 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Mon, 15 Sep 2025 18:58:48 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "James Houghton" <jthoughton@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 "Peter Xu" <peterx@redhat.com>,
 "Axel Rasmussen" <axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1757977128.137610687@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: ef48825c-d622-4617-a698-452b002adea8-1-1
X-Rspamd-Queue-Id: 2423940002
X-Rspamd-Server: rspam05
X-Stat-Signature: k1d35yukejjqpjid714it1574twbgoxt
X-Rspam-User: 
X-HE-Tag: 1757977129-703712
X-HE-Meta: U2FsdGVkX19oGCNW0C80ob8Kj6GQCnarM7AoNh7tH9c4HQ5Fr5uh+U0bnP8ERfcuCdHSF9XbDrwtEeqxT27QKS4dZ5/qJaaZdPqV98wnxs2VToRrCE6/rhGSXvCl4RDI0X1s+u0fkYRSsdr/wRL1TjmLYqqPOQobYuvmnkIUAJZuXnU7+WjaXu600jscnLGeysCLcvpSuocODMseKqa/LrOZfg5v9iSG/dGBVzIj2EXKEOExzdS795ZeuyAybKyZpoyYsjpmUw2mN9SLG13PP4k1IQCLbeFp5MqyDSMTravWb8jqOmmK0nYyQ65ySED4Ru/azwq9kVaOmoR6wHYN2y8C334lJXFDAt1jrbDRoVbHxhKQ5/PscZGCoq35m1u3hPizxvqkOQmHh77giZLkhA20Tj6caTLdASIxiS81gIbPLcHN3SkR2KiutD+qdYi7qSPpI8QG7B+ngvehqoq07/r+pbF71XGgFfj/vs22E6vxKKP+dTXtvjPCyrv+zyBsuhlJwlwZmAUKT0K+qxInFOiclHBfhLffrXrybmYINnOS782Iz+IhuQmkvXBdzF0PyLO4QRb1d2sW/9t3Rw/LTPJkUHqfMRNZXCuSyz4NMY7zMmjs7pfYY99e65JTDruE93VTypphcDjjPRBmR0HBXxnvaaoB4ko8CbZdoxRE3u2Aree65rK6Mf1Yk7ENBKCxwB2pngBgXAbvotojw5JowZ9hZG5e/tdPfinoeTgrhq+u3e2ZlFrbiBMtNSB95UBGMasfuZnWXf89rJzv9n3QLboeAbwQzJmy81iQ/C09L9FqxnOEZw7JE5PGm/7wX55skdt0+yjZztOIy7wVdAnwvBpldniKKM83XjfLQH7nK8eJ7VEHs4EC0rkcKFnw/y/XVNjuUsaaGvEcncPyNYFNF4WmyBfXwbzpdjNz8tyoeUk4f/PjDmstKwW/1UEJy+eTJ+9XKFMk+hI3xyOi95H
 OMJLG7vM
 kntU7atnbpAx8Hjd5EgcrHHqdaz/FFBWK/UDrVIJ6TTl2tHm8krrExwLz1DOqL+JD/9L5GsYSdu5xj2A7o0LunAUrT7YySgsbSFJv0PnjbGKpxDw2Wvg4I4AQAP7r2plZFtqwhfQ02Jt3CXKjDyHW9a6RxtKEU3YZZ8/2mm14M/rjyU0QoFNXCbHBtTRQrC3aZkQtVd2ucXNbsBzkpY8Lk0a2ZSFsSiL39Bf0DDXmkzqBhN+sn1IE3jt2Bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=0AOn Monday, September 15, 2025 16:24, "James Houghton" <jthoughton@goo=
gle.com> said:=0A=0A> On Mon, Sep 15, 2025 at 1:13=E2=80=AFPM David P. Reed=
 <dpreed@deepplum.com> wrote:=0A>>=0A>>=0A>> [1.] One line summary of the p=
roblem: userfaultfd REGISTER minor mode on=0A>> MAP_PRIVATE fails=0A>> [2.]=
 Full description of the problem/report:=0A>> The userfaultfd man page and =
the kernel docs seem to indicate that an area=0A>> mapped=0A>> MAP_PRIVATE|=
MAP_ANONYMOUS can be registered to handle MINOR page faults on=0A>> regular=
 pages.=0A>> However, testing showed that not to work. MAP_SHARED does allo=
w registration for=0A>> MINOR=0A>> page fault events, though.=0A>> Either t=
he documentation or the code should be fixed, IMO. Now reading the code=0A>=
> that rejects=0A>> this case in the kernel source, the test in vma_can_use=
rfault() that rejects this=0A>> is this=0A>> line:=0A>>         if ((vm_fla=
gs & VM_UFFD_MINOR) &&=0A>>             (!is_vm_hugetlb_page(vma) && !vma_i=
s_shmem(vma)))=0A>>                 return false;=0A>> which probably shoul=
d include !vma_is_anonymous(vma).=0A>>=0A>> Or maybe the COW that might hap=
pen if the program were forked is something that=0A>> can't be handled, whi=
ch seems odd.=0A> =0A> UFFDIO_CONTINUE, the resolution ioctl for userfaultf=
d minor faults,=0A> doesn't have defined semantics for MAP_PRIVATE mappings=
. The=0A> documentation is unclear that MAP_PRIVATE + userfaultfd minor fau=
lts=0A> is invalid, but this is intentional behavior.=0A> =0A> What would y=
ou like UFFDIO_CONTINUE on MAP_PRIVATE to do? Should it=0A> populate a read=
-only PTE? Should it do CoW and populate a writable=0A> PTE? I'm curious to=
 hear more about your use case (and why UFFDIO_COPY=0A> doesn't do what you=
 want).=0A> =0A=0AWell, I was just expecting to UFFDIO_CONTINUE to do whate=
ver "normally" gets done. So, the normal case for MAP_PRIVATE|MAP_ANONYMOUS=
, if the page is in the swap cache and thus takes a minor fault, would depe=
nd on whether the access was a write or a read.=0A=0AFor a read, the page j=
ust gets installed in the page map from the swap cache.=0AFor a write, if t=
he page hasn't yet been copied, a copy is made of the swap cache contents o=
f that page at that point, and the new copy is installed into the page tabl=
e of the writing process.=0A=0AHowever, the problem I'm reporting is that I=
 can't even register such a page for minor page faults. =0A=0ANow there is =
a question of the meaning of UUFIO_COPY should be (not continue). If page i=
s MAP_PRIVATE, MAP_COPY is like writing to the page at the time of the mino=
r fault. So the version of the data in the swap cache for the page should b=
e ignored, replacing the  local version makes sense. Any other process that=
 still has the original version from the time of the fork() that shared the=
 page should not be affected, I would think.=0A=0AThere is a confusing poss=
ibility, however, with the file descriptor for uffd. In the case of a fork(=
), the file descriptor would be shared, and so either fork could end up lis=
tening via poll/select.=0A=0AIt's hard to decide what is right semantically=
, because the normal use of userfault is to monitor from another process, t=
hough you can use read() in the same process as the faulting one - this see=
ms to be because either fork or a unix-socket can be the path for sending t=
he file descriptor to another process. But this is just definitional, the a=
ctual user design would have to handle faults in one place or another.=0A=
=0ANow in this case, whichever process does the first read() on the file de=
scriptor would get the information about the minor fault. (I assume both wo=
uld NOT, but I'm early in my use of userfaultfd). So it could continue or c=
opy, as desired.=0A=0AGenerally, anyone using userfaultfd would understand =
the nuances of fork() and file handle duplication. So they would probably c=
lose the fd in one process or the other, as appropriate. (I admit I haven't=
 tested what happens if both forks try to use the file descriptor, but I ca=
n imagine it might be useful if they coordinate carefully).=0A=0ANow, if ma=
ny forks end up sharing the uffd file descriptor and also end up with copy-=
on-write shared pages in the MAP_PRIVATE region, the above definitions of t=
he continue and copy would continue to make sense - to me anyway.=0A=0AHope=
 this helps=0A=0A=0A


