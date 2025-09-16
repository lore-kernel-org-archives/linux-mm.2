Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00536CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBE98E001B; Tue, 16 Sep 2025 11:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CBF8E0002; Tue, 16 Sep 2025 11:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9DD8E001B; Tue, 16 Sep 2025 11:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2618E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:37:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07C5F81FE6
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:37:22 +0000 (UTC)
X-FDA: 83895517524.12.2876A3A
Received: from smtp86.iad3a.emailsrvr.com (smtp86.iad3a.emailsrvr.com [173.203.187.86])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09FD040010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:37:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.86 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758037040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVIBonDL1i8S2GZxAxbIaWwsaa+4l98pdsotRH06Oc8=;
	b=Bba87RNmMUKQBetx13uTFwSt/RJk+Wybg9n1jM8+SrF3Ew5nCu/H7XPgE+tJc7YGe+2Ftu
	oYWTWqIRYf/2/GAnEgR2nQTx6ZmkfjmF3ty7mLkCPZhYj9LbUYo5GZrsUWfLyMpU60n2Xk
	qE5zflbotmAAMZNaQst+EkBXI5jjF98=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.86 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758037040; a=rsa-sha256;
	cv=none;
	b=TNn4eYsDHbMyhQNdGpuN4p0aWX+J7nqRJSpJ2mbj+bz6lKZsRdXn9t/P9DxPipuz4yBAt+
	1pX9HzW+MZ9dQOU14kGyPiOSndgt8zlp/Kl7UQ0I26lg1SBATBVutLc3lGChBfZroH/9ei
	fPQfLD+faCxEFTPwl9Tw8yhzS87tz3w=
Received: from app32.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp35.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 327D5618F;
	Tue, 16 Sep 2025 11:37:19 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app32.wa-webapps.iad3a (Postfix) with ESMTP id 16046E10B4;
	Tue, 16 Sep 2025 11:37:19 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Tue, 16 Sep 2025 11:37:19 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Tue, 16 Sep 2025 11:37:19 -0400 (EDT)
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
In-Reply-To: <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1758037039.08578612@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: e71446f4-8c90-4900-a2e9-9746bf0e7bd4-1-1
X-Rspamd-Queue-Id: 09FD040010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dipc8h5fj6cmtiqzj4uqwg5g3gjfgysr
X-HE-Tag: 1758037039-949563
X-HE-Meta: U2FsdGVkX19ySKaZYiXaeV0MHnwjVyKRmGvD4douhshEkU5oIbxPAtwE2w29xjqYIJeG1RtTobYv2O0UsZRuU80cz2TTlA6l5nHwkur67pEnlMpzuma2EB5hnTVIhfxIjynUhZ7LVU+4c6U6aiet3pEkjWh/jS4qMbgev0eMO/HGlsodrMK5DGJLYMOpzp0CqX6+QDYEyrK7AAssjgOaB/c6SKgsE6ZdCcQYIY1P7yybjEs22T3CB6wj9tHDyaRGf7LiwTRc6Uwx73w8reXVnGX1aSF8T7ioNsJMoN8DJA2feKku3rUUU9w3w9m50k39L9TMX13rGJ3DIwBdL+adFlYgRsPt46rode50eFiXhYMYuw2BAhzZNiSRPxQl59SdZ2JMhuQqnrehbpcMxgZ9nfT+gk6Xn/Mt8TzS7he/gUYhaVemF7YDxq3myJaOESEad+JWZ6DLny/JqKSLwwJUsBQzoeG/j70AbUUcMJBnRg7eDF1Mb3T+ym1nnjA77I52TWA0giiBpPXYgsmVzsxr2+O8qaxVdocWtctfxakMU3UJ//Gd8IvNgVXpSjpRHxyv90c9dSc05wN/B2JF+IgJLEm2z9Yq0wD0vEHgiqxXSJv0gzS9bL7JmewZytSVdlrqc3NDi6zyUivlrfQB80CfC1tuKj9YiEUc7VbtudlDVeANuslj6hNssPblii+ekSfeMW0cJ1eYoPyxkE2cU7WG31uHqRrmRry+kULjIXa3RvPilmu7eu+UJy3M+HktExoDXwWazpnnA5ZmG6+TObxkklmH/EkM9rzSkDfkLz4pvnrjqOPIEV7Fffithu9URHT0E714AxZEAi63dir+psCbExIlV4nnU8wppxolcDQ1Rxu+m/1xoSdC6a57TsbI7e2t5FGqeuFliOUtg1OtoC0bflxTvuin60Lg/P9o/JMjFrTzYF0hHC2PU18q+ww5gyd8s2djre/cyiClpg2FGve
 oNZ/Ee5g
 xH2/omJIbTbPkJoneVncfbmQrPPXSX49YSIwzC6nfSIkxxZkJdEI4iV+I8rW3LRIGGdupak8mJFLMVaBMcbnh6ynwnif3Cyg5tFHZv9X53hbc8KhH6oOxhq1VBan3tVBprZ26PegTWUZMUfA+Tw7YIDtuenGuRli0jGqB1LvzSu2hA8/STuzrFkYvenuH1lM82bZp2FCRAbc8CiQghD4MFaeDpu8PWMOIKye9PMYKlK0lvZ+7Dv5if5o7OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=0AOn Monday, September 15, 2025 20:31, "James Houghton" <jthoughton@goo=
gle.com> said:=0A=0A> On Mon, Sep 15, 2025 at 3:58=E2=80=AFPM David P. Reed=
 <dpreed@deepplum.com> wrote:=0A>>=0A>>=0A>>=0A>> On Monday, September 15, =
2025 16:24, "James Houghton" <jthoughton@google.com>=0A>> said:=0A>>=0A>> >=
 On Mon, Sep 15, 2025 at 1:13=E2=80=AFPM David P. Reed <dpreed@deepplum.com=
>=0A>> wrote:=0A>> >>=0A>> >>=0A>> >> [1.] One line summary of the problem:=
 userfaultfd REGISTER minor mode on=0A>> >> MAP_PRIVATE fails=0A>> >> [2.] =
Full description of the problem/report:=0A>> >> The userfaultfd man page an=
d the kernel docs seem to indicate that an area=0A>> >> mapped=0A>> >> MAP_=
PRIVATE|MAP_ANONYMOUS can be registered to handle MINOR page faults on=0A>>=
 >> regular pages.=0A>> >> However, testing showed that not to work. MAP_SH=
ARED does allow registration=0A>> for=0A>> >> MINOR=0A>> >> page fault even=
ts, though.=0A>> >> Either the documentation or the code should be fixed, I=
MO. Now reading the=0A>> code=0A>> >> that rejects=0A>> >> this case in the=
 kernel source, the test in vma_can_userfault() that rejects=0A>> this=0A>>=
 >> is this=0A>> >> line:=0A>> >>         if ((vm_flags & VM_UFFD_MINOR) &&=
=0A>> >>             (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))=0A>>=
 >>                 return false;=0A>> >> which probably should include !vm=
a_is_anonymous(vma).=0A>> >>=0A>> >> Or maybe the COW that might happen if =
the program were forked is something=0A>> that=0A>> >> can't be handled, wh=
ich seems odd.=0A>> >=0A>> > UFFDIO_CONTINUE, the resolution ioctl for user=
faultfd minor faults,=0A>> > doesn't have defined semantics for MAP_PRIVATE=
 mappings. The=0A>> > documentation is unclear that MAP_PRIVATE + userfault=
fd minor faults=0A>> > is invalid, but this is intentional behavior.=0A>> >=
=0A>> > What would you like UFFDIO_CONTINUE on MAP_PRIVATE to do? Should it=
=0A>> > populate a read-only PTE? Should it do CoW and populate a writable=
=0A>> > PTE? I'm curious to hear more about your use case (and why UFFDIO_C=
OPY=0A>> > doesn't do what you want).=0A>> >=0A>>=0A>> Well, I was just exp=
ecting to UFFDIO_CONTINUE to do whatever "normally" gets=0A>> done. So, the=
 normal case for MAP_PRIVATE|MAP_ANONYMOUS, if the page is in the=0A>> swap=
 cache and thus takes a minor fault, would depend on whether the access was=
 a=0A>> write or a read.=0A> =0A> This minor fault is not a *userfaultfd* m=
inor fault, and even if=0A> registering UFFD_REGISTER_MODE_MINOR on this VM=
A were allowed, you=0A> wouldn't get userfaults. This is because swap-outs =
for MAP_ANONYMOUS=0A> VMAs leave behind a swap entry (!pte_present() && !pt=
e_none()).=0A> UFFDIO_CONTINUE cannot resolve this condition, so no minor f=
ault is=0A> generated in the first place.=0A> =0A> Why can't UFFDIO_CONTINU=
E resolve this condition? Well UFFDIO_CONTINUE=0A> only populates pte_none(=
) PTEs; it will not and should not obliterate=0A> a swap entry. And no one =
has a use-case for making it trigger a=0A> swap-in.=0A=0AWell, it's not a p=
age-missing fault, because the page may be in the swap cache and not yet on=
 disk, which the documentation says is not a major (page missing) fault. Ma=
ybe it's a documentation problem, if "userfault minor" and "minor fault" ar=
en't the same?=0AAs I note in the report, the documentation is pretty uncle=
ar on this point (and also on why MAP_PRIVATE doesn't work).=0A=0A> =0A> Th=
e same logic applies to CoW; CoW faults are not (minor) userfaults=0A> beca=
use UFFDIO_CONTINUE cannot resolve them.=0A> =0A>> For a read, the page jus=
t gets installed in the page map from the swap cache.=0A>> For a write, if =
the page hasn't yet been copied, a copy is made of the swap cache=0A>> cont=
ents of that page at that point, and the new copy is installed into the pag=
e=0A>> table of the writing process.=0A> =0A> Sure, but if this is the beha=
vior you want, why do you want/need userfaultfd?=0A=0ABecause I am tracking=
 page creation events. The COW case creates a new page, and UFFDIO_COPY isn=
't able to express "just proceed". If the COW is silent, then I won't see p=
age creation by COW. Maybe we need another "mode" besides "missing" and "mi=
nor" that gets triggered by COW?  (note that write-protect isn't quite the =
same as that, because it gets triggered by writes that don't cause COW, als=
o - if it is even allowed for the case of MAP_ANONYMOUS|MAP_PRIVATE.=0A=0A>=
 =0A>> However, the problem I'm reporting is that I can't even register suc=
h a page for=0A>> minor page faults.=0A> =0A> I understand; I find it easie=
r to speak in terms of the behavior of=0A> the resolution ioctl (it is equi=
valent).=0A>=0AHow is it equivalent to the REGISTER rejecting a mode?=0A =
=0A>> Now there is a question of the meaning of UUFIO_COPY should be (not c=
ontinue). If=0A>> page is MAP_PRIVATE, MAP_COPY is like writing to the page=
 at the time of the=0A>> minor fault. So the version of the data in the swa=
p cache for the page should be=0A>> ignored, replacing the  local version m=
akes sense. Any other process that still=0A>> has the original version from=
 the time of the fork() that shared the page should=0A>> not be affected, I=
 would think.=0A>>=0A>> There is a confusing possibility, however, with the=
 file descriptor for uffd. In=0A>> the case of a fork(), the file descripto=
r would be shared, and so either fork=0A>> could end up listening via poll/=
select.=0A>>=0A>> It's hard to decide what is right semantically, because t=
he normal use of=0A>> userfault is to monitor from another process, though =
you can use read() in the=0A>> same process as the faulting one - this seem=
s to be because either fork or a=0A>> unix-socket can be the path for sendi=
ng the file descriptor to another process.=0A>> But this is just definition=
al, the actual user design would have to handle faults=0A>> in one place or=
 another.=0A>>=0A>> Now in this case, whichever process does the first read=
() on the file descriptor=0A>> would get the information about the minor fa=
ult. (I assume both would NOT, but=0A>> I'm early in my use of userfaultfd)=
. So it could continue or copy, as desired.=0A>>=0A>> Generally, anyone usi=
ng userfaultfd would understand the nuances of fork() and=0A>> file handle =
duplication. So they would probably close the fd in one process or=0A>> the=
 other, as appropriate. (I admit I haven't tested what happens if both fork=
s=0A>> try to use the file descriptor, but I can imagine it might be useful=
 if they=0A>> coordinate carefully).=0A> =0A> I am not really following how=
 the above connects to not being able to=0A> use userfaultfd minor faults f=
or MAP_PRIVATE.=0A> =0A>>=0A>> Now, if many forks end up sharing the uffd f=
ile descriptor and also end up with=0A>> copy-on-write shared pages in the =
MAP_PRIVATE region, the above definitions of=0A>> the continue and copy wou=
ld continue to make sense - to me anyway.=0A>>=0A>> Hope this helps=0A> =0A=
> I still don't have a solid grasp of what your use case is.=0A> =0A=0AMy u=
se case is simple, and has been described elsewhere by others. Creating a u=
serspace paging monitor process that can catch page faults in userspace, ei=
ther tracking them or modifying their behavior.  Not being able to handle a=
nonymous, private pages at all seems to make it useless for that purpose. (=
doing research on using that fault info to drive madvise LRU management for=
 certain cases). (I can do this with kretprobes thru a kernel driver, but s=
ince the mm code is rapidly evolving, it's not anything like an ABI that wo=
rks across versions).=0A=0AIt's interesting that anonymous private huge pag=
e minor fault mode is not rejected, just regular page. (The code snippet ab=
ove is what rejects regular pages but not huge pages mapped privately).=0A=
=0AJust curious - are you a designer or maintainer of userfaultfd? You aren=
't listed as a maintainer. I would be able to provide a patch set that "fix=
es" the behavior to be the way I believe would be the most useful, but the =
point of reporting this as a problem is to avoid rejection by the maintaine=
r, Andrew Morton, if somehow I've missed a subtle concern that isn't explai=
ned in the documentation. =0AI could also provide a documentation patch to =
clarify the MAP_PRIVATE|MAP_ANONYMOUS rejection of minor fault handling doe=
sn't work.


