Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0406CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697F58E0050; Thu, 21 Aug 2025 08:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6751B8E003D; Thu, 21 Aug 2025 08:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585DC8E0050; Thu, 21 Aug 2025 08:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 412BE8E003D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:15:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACA491603AC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:15:08 +0000 (UTC)
X-FDA: 83800659096.30.9D4A1CE
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id A23FA80008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:15:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XSJsYvNA;
	spf=pass (imf02.hostedemail.com: domain of 3yA2naAgKCMs0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yA2naAgKCMs0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755778506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igGD2SRqvbl6NKcwwFrW6mZ2nrTeSMfrqJN+WQf8wf8=;
	b=mti9+pm0aj7EXE6qDqdAsLgTv+buUqDfyBJYFk6W51CGqa561p7f+E1HWeVCD0c//g//0U
	/QpgqtufbrcDEaCUURGkqaVEnPEDRkapbDr14I5+dElItEF4oQGou35kngh58dcPSgr/Bi
	WdGeM/4Mxi5T1XJG9nH7UCGMbIllnDg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XSJsYvNA;
	spf=pass (imf02.hostedemail.com: domain of 3yA2naAgKCMs0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yA2naAgKCMs0rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755778506; a=rsa-sha256;
	cv=none;
	b=GD3QzLOCnazN8O5WD6oIctbLqUATAgLCOY4m57sOiMJMJv6NlWVpSXCppV1P6uHTaINkua
	GgL38UKIFHVYDJ8FD4upXoIfddVtAGibzl5+oO7mVyDe5ZEEspXNJBuRp/3Nbvb4KQMRUP
	x/E8h1sno0BqCEJVunYkvVmZFIwqliw=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0c5377so4754735e9.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755778505; x=1756383305; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igGD2SRqvbl6NKcwwFrW6mZ2nrTeSMfrqJN+WQf8wf8=;
        b=XSJsYvNA62SYVRI0GsszQ5+OEVNV+2iTNOEmeoCdok6/XBmJbanApnBciEXj7glXJc
         owrZYaJLCxpuo3ysyeIPP2XRX/me/MO9JOrXzk+bKHoSyemWfS6Ars5I1ZWsrtJK1wT4
         G4f0IuX2Rg9LG6clOQJkqu9i4u5H3uD263YiQK49MkWnJAggCjI6NuJDvPE8fsHeoKoX
         pG8YYnSkIeqeqznw//IOKlmOF8C7I/Vhjb1BH2mTOuoCMZDNv8rqrOgZMOKmnzLdLyfm
         yrTgeldtQVS0E30orodyBSXvotWDVRgDJ78+cnmaIgHuPKn4XzjSgjSOYSFoAUcOfI1K
         oIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755778505; x=1756383305;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=igGD2SRqvbl6NKcwwFrW6mZ2nrTeSMfrqJN+WQf8wf8=;
        b=FQ18qFm5MWsZCSGdVDeD2/BO3sIjdSndvqcL9xraysjz3eUYJyBqAm1epY8He8ihbR
         aAPa2eK6xSQpV+X5uLDXHlRnonyzn2WYBmy6wSDMMKkygL7HRUh9cv10f/SrviQFQECg
         8Oc3osMwvYBrz/nROS82V3JazDpAAyhEqkpDFVd2K7AhFC6it4UcJN4eVazgK6zJI56I
         XKQQiDJRwx32/OLf1bEyumP8qaE43aKwihkqtw2WSRjQ2u7RMs/su7O+AUNY3TWX0dwU
         JIQ9oldhNL1MRinIBabgE+7jpR3Sbl03NR5DRo8lvCRzZSkozqzijAPj3EsO7Xwr5kA3
         pJdw==
X-Forwarded-Encrypted: i=1; AJvYcCVhErGtYCaU0EaheD38FX0/PIgca+C/wrnF5pJBvpzkXFFKnw3ivmjq+ejcnPJMra+MAfddkHSMtA==@kvack.org
X-Gm-Message-State: AOJu0YyoEUFMbsi2FtT82qqnRF+OY/3RnqVxAevdN4AtX23RTjq6BHT0
	xMK4Qc+9T2w1bDVZbbHwT4K3WP5tGWYckcui9B6o7Zu0Joff/S5JT7AfDFuCB6wLIlh9i57l34x
	JyZxq5aW3AAfAjA==
X-Google-Smtp-Source: AGHT+IE4l5fOXizJgcLdQXp5PpoE+yrfzIr6P0oIHw56mmXq1KE5PErHW4FPmgRshbk/sdE2ZGHB43wQ96mM1Q==
X-Received: from wmbdw4.prod.google.com ([2002:a05:600c:6384:b0:459:dcf5:1b54])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c8c:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45b4d7e34dfmr21875165e9.12.1755778504936;
 Thu, 21 Aug 2025 05:15:04 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:15:04 +0000
In-Reply-To: <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
Mime-Version: 1.0
References: <20250812173109.295750-1-jackmanb@google.com> <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
X-Mailer: aerc 0.20.1
Message-ID: <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
From: Brendan Jackman <jackmanb@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	<yosry.ahmed@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Liam Howlett <liam.howlett@oracle.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A23FA80008
X-Stat-Signature: jyax1yr4p3sksw1eqjmp934yhe31geii
X-Rspam-User: 
X-HE-Tag: 1755778506-735664
X-HE-Meta: U2FsdGVkX18Bd61qBLstZ19eyd0PMJBiHU0M+j4XR33wp3MxBeTmQPx4F0fwdhGxKkhy2pmWDcXVhoieV0aSI8JV0g4xt2D4Q611owcpJXsF18ZrsViJrUpABPxbUDh1XOESmFZAwbygPDSprS3ROrrb14kElPowz2/CSvOI9N7mDLvOUsrZEewZOs+RiLPv57n0hkbWKGz6VD/7Mu/8ejM18q+NghERD1BOFSIK9h7zjKwPrsauVUhbNtP37TPv1yKeqE2tPwSg2VPSJV6Q6hZJJIo4HuoF9znC5Vf9WCg+9LXx/JVrNypcAzSflw7ETEZKbR4ASiHpQFPajBapEahlV+C+j6CXHNloDobeaXeHjOuqn6wrtwwP9BTkJh4Euy0GVY6w1VQon1fYQE7UGtvfjuhr78c9igdUQvCxmY8C/ZZJgPb9GV9kR/MmvQuQHcjI/ipLa2TLNFqkjV+2+PsiBNTAocTEHBZAkYofUPUQ43dhLBN3sDTJavE7COPMO22k8nZ6/ifvRqDG8pG1d722vskVxk72q0LlVShdGi3P4xVKQGkwFYhCgfsQByqsGIfFT2TGN++k+q0M528XWRCe9PPgBF9tHzukpjU01PB2gnwY/aSSpahnBAoQrOdhrB0fyODQ78bLk4oeRUiMh4xs7YThCXm7+nG90sf0tCpKvxfsWXkt9lFLdRVhpq1GRHC08DUqT8qTQM1BpKqYp5Q4J4UHZ2Q4A1RDMKajf+96MNI7Gkcrt/Yn9EfeWcAlG/Xwt2FcSchdyRzwirpX3z/+5lQrCUw79dACMIWAumBd7vOw9NLyYeiRqrXGB1J1zeJwFjNrEeLzSNb+GZO7pcaKvvAObJlJURKe9fzR71F/EsUPoLCo4aERSyopoKMGzh4bwFpetO0dlAhJ1WF/D4iOQy+EL/RHRpFyYxYbDL+5VadIuWpq9ysbAA+/h4QpEKCZ96x3W2oVc2/GOyg
 cIzCrDXH
 T51q9nZ9gkLqI09jdZ44ItRf4Zct6q7UirDerWGLCZM/eci/y3+VZGEd3QgVDg9uIIEX16H7N7vnVRAqG2cDFOmLEiVV860oamPLJPG+qKAnpFziPnmGbXG6S54y3bxEEpaSUfUKWFIO8qL4pMUjTxgK4TXyMpFJcvYmJATtE5yfSRPizUnhPiqanvkYuhF1QaQvXbgdhZoW2IQ78DuxhofGUWj2EsS/xBqmjKI/wc6LWXg5fasCFCj8dhUXkpeu4zIT43Of/IHTfcbIfWuX/LLY2YK8uRnco+c2+LXsnA1IIhlNySn3hzf5v4WCTAo00+brYxrfDF2CioH9MoUFDw61CtPOs3qWPwvgonha2c0MN0n6KIi8DydNlBTUj/dEixR8Nrv4gsILnW6ohYNGwaHyByrt029v6USduyaCyI8Z7tbJVGW/2AK1ebqlzw9q+bqN9UiLYSayboKV8G6SblxaOg+zVZQ5IwHEzAYzMRbEpkI+a39B2qacNdDpuOD5LPuNUsBfU0mfcKxsHgDYLdajRuBD/76hKLwNuFXSEoczBFvGjv5KLCYmvMZeVG6b65eb33hsAx3Khf5661Mc6xQ0E0NrTeBSltJJAG6uS40rEwcpmAmfWP5ISVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 21, 2025 at 8:55 AM UTC, Lorenzo Stoakes wrote:
> +cc Matthew for page cache side
> +cc Other memory mapping folks for mapping side
> +cc various x86 folks for x86 side
> +cc Kees for security side of things
>
> On Tue, Aug 12, 2025 at 05:31:09PM +0000, Brendan Jackman wrote:
>> .:: Intro
>>
>> Following up to the plan I posted at [0], I've now prepared an up-to-dat=
e ASI
>> branch that demonstrates a technique for solving the page cache performa=
nce
>> devastation I described in [1]. The branch is at [5].
>
> Have looked through your branch at [5], note that the exit_mmap() code is
> changing very soon see [ljs0]. Also with regard to PGD syncing, Harry int=
roduced
> a hotfix series recently to address issues around this generalising this =
PGD
> sync code which may be usefully relevant to your series.
>
> [ljs0]:https://lore.kernel.org/linux-mm/20250815191031.3769540-1-Liam.How=
lett@oracle.com/
> [ljs1]:https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@o=
racle.com/

Thanks, this is useful info.

>>
>> The goal of this prototype is to increase confidence that ASI is viable =
as a
>> broad solution for CPU vulnerabilities. (If the community still has to d=
evelop
>> and maintain new mitigations for every individual vuln, because ASI only=
 works
>> for certain use-cases, then ASI isn't super attractive given its complex=
ity
>> burden).
>>
>> The biggest gap for establishing that confidence was that Google's deplo=
yment
>> still only uses ASI for KVM workloads, not bare-metal processes. And ind=
eed the
>> page cache turned out to be a massive issue that Google just hasn't run =
up
>> against yet internally.
>>
>> .:: The "ephmap"
>>
>> I won't re-hash the details of the problem here (see [1]) but in short: =
file
>> pages aren't mapped into the physmap as seen from ASI's restricted addre=
ss space.
>> This causes a major overhead when e.g. read()ing files. The solution we'=
ve
>> always envisaged (and which I very hastily tried to describe at LSF/MM/B=
PF this
>> year) was to simply stop read() etc from touching the physmap.
>>
>> This is achieved in this prototype by a mechanism that I've called the "=
ephmap".
>> The ephmap is a special region of the kernel address space that is local=
 to the
>> mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap A=
PI can
>> allocate a subregion of this, and provide pages that get mapped into the=
ir
>> subregion. These subregions are CPU-local. This means that it's cheap to=
 tear
>> these mappings down, so they can be removed immediately after use (eph =
=3D
>> "ephemeral"), eliminating the need for complex/costly tracking data stru=
ctures.
>
> OK I had a bunch of questions here but looked at the code :)
>
> So the idea is we have a per-CPU buffer that is equal to the size of the =
largest
> possible folio, for each process.
>
> I wonder by the way if we can cache page tables rather than alloc on brin=
g
> up/tear down? Or just zap? That could help things.

Yeah if I'm catching your gist correctly, we have done a bit of this in
the Google-internal version. In cases where it's fine to fail to map
stuff (as is the case for ephmap users in this branch) you can just have
a little pool of pre-allocated pagetables that you can allocate from in
arbitrary contexts. Maybe the ALLOC_TRYLOCK stuff could also be useful
here, I haven't explored that.

>>
>> (You might notice the ephmap is extremely similar to kmap_local_page() -=
 see the
>> commit that introduces it ("x86: mm: Introduce the ephmap") for discussi=
on).
>
> I do wonder if we need to have a separate kmap thing or whether we can ju=
st
> adjust what already exists?

Yeah, I also wondered this. I think we could potentially just change the
semantics of kmap_local_page() to suit ASI's needs, but I'm not really
clear if that's consistent with the design or if there are perf
concerns regarding its existing usecase. I am hoping once we start to
get the more basic ASI stuff in, this will be a topic that will interest
the right people, and I'll be able to get some useful input...

> Presumably we will restrict ASI support to 64-bit kernels only (starting =
with
> and perhaps only for x86-64), so we can avoid the highmem bs.

Yep.

>>
>> The ephmap can then be used for accessing file pages. It's also a generi=
c
>> mechanism for accessing sensitive data, for example it could be used for
>> zeroing sensitive pages, or if necessary for copy-on-write of user pages=
.
>>
>> .:: State of the branch
>>
>> The branch contains:
>>
>> - A rebased version of my "ASI integration for the page allocator" RFC [=
3]. (Up
>>   to "mm/page_alloc: Add support for ASI-unmapping pages")
>> - The rest of ASI's basic functionality (up to "mm: asi: Stop ignoring a=
si=3Don
>>   cmdline flag")
>> - Some test and observability conveniences (up to "mm: asi: Add a tracep=
oint for
>>   ASI page faults")
>> - A prototype of the new performance improvements (the remainder of the
>>   branch).
>>
>> There's a gradient of quality where the earlier patches are closer to "c=
omplete"
>> and the later ones are increasingly messy and hacky. Comments and commit=
 message
>> describe lots of the hacky elements but the most important things are:
>>
>> 1. The logic to take advantage of the ephmap is stuck directly into mm/s=
hmem.c.
>>    This is just a shortcut to make its behaviour obvious. Since tmpfs is=
 the
>>    most extreme case of the read/write slowdown this should give us some=
 idea of
>>    the performance improvements but it obviously hides a lot of importan=
t
>>    complexity wrt how this would be integrated "for real".
>
> Right, at what level do you plan to put the 'real' stuff?
>
> generic_file_read_iter() + equivalent or something like this? But then yo=
u'd
> miss some fs obv., so I guess filemap_read()?

Yeah, just putting it into these generic stuff seemed like the most
obvious way, but I was also hoping there could be some more general way
to integrate it into the page cache or even something like the iov
system. I did not see anything like this yet, but I don't think I've
done the full quota of code-gazing that I'd need to come up with the
best idea here. (Also maybe the solution becomes obvious if I can find
the right pair of eyes).

Anyway, my hope is that the number of filesystems that are both a) very
special implementation-wise and b) dear to the hearts of
performance-sensitive users is quite small, so maybe just injecting into
the right pre-existing filemap.c helpers, plus one or two
filesystem-specific additions, already gets us almost all the way there.

>>
>> 2. The ephmap implementation is extremely stupid. It only works for the =
simple
>>    shmem usecase. I don't think this is really important though, whateve=
r we end
>>    up with needs to be very simple, and it's not even clear that we actu=
ally
>>    want a whole new subsystem anyway. (e.g. maybe it's better to just ad=
apt
>>    kmap_local_page() itself).
>
> Right just testing stuff out, fair enough. Obviously not an upstremable t=
hing
> but sort of test case right?

Yeah exactly.=20

Maybe worth adding here that I explored just using vmalloc's allocator
for this. My experience was that despite looking quite nicely optimised
re avoiding synchronisation, just the simple fact of traversing its data
structures is too slow for this usecase (at least, it did poorly on my
super-sensitive FIO benchmark setup).

>> 3. For software correctness, the ephmap only needs to be TLB-flushed on =
the
>>    local CPU. But for CPU vulnerability mitigation, flushes are needed o=
n other
>>    CPUs too. I believe these flushes should only be needed very infreque=
ntly.
>>    "Add ephmap TLB flushes for mitigating CPU vulns" is an illustrative =
idea of
>>    how these flushes could be implemented, but it's a bit of a simplisti=
c
>>    implementation. The commit message has some more details.
>
> Yeah, I am no security/x86 expert so you'll need insight from those with =
a
> better understanding of both, but I think it's worth taking the time to h=
ave
> this do the minimum possible that we can prove is necessary in any real-w=
orld
> scenario.

I can also add a bit of colour here in case it piques any interest.

What I think we can do is an mm-global flush whenever there's a
possibility that the process is losing logical access to a physical
page. So basically I think that's whenever we evict from the page cache,
or the user closes a file.

("Logical access" =3D we would let them do a read() that gives them the
contents of the page).

The key insight is that a) those events are reeelatively rare and b)
already often involve big TLB flushes. So doing global flushes there is
not that bad, and this allows us to forget about all the particular
details of which pages might have TLB entries on which CPUs and just say
"_some_ CPU in this MM might have _some_ stale TLB entry", which is
simple and efficient to track.

So yeah actually this doesn't really require too much security
understanding, it's mostly just a job of making sure we don't forget a
place where the flush would be needed, and then tying it nicely with the
existing TLB infrastructure so that we can aggregate the flushes and
avoid redundant IPIs. It's fiddly, but in a fun way. So I think this is
"the easy bit".

> It's good to start super conservative though.
>
>>
>> .:: Performance
>>
>> This data was gathered using the scripts at [4]. This is running on a Sa=
pphire
>> Rapids machine, but with setcpuid=3Dretbleed. This introduces an IBPB in
>> asi_exit(), which dramatically amplifies the performance impact of ASI. =
We don't
>> know of any vulns that would necessitate this IBPB, so this is basically=
 a weird
>> selectively-paranoid configuration of ASI. It doesn't really make sense =
from a
>> security perspective. A few years from now (once the security researcher=
s have
>> had their fun) we'll know what's _really_ needed on this CPU, it's very =
unlikely
>> that it turns out to be exactly an IBPB like this, but it's reasonably l=
ikely to
>> be something with a vaguely similar performance overhead.
>
> I mean, this all sounds like you should drop this :)
>
> What do the numbers look like without it?

Sure, let's see...

(Minor note: I said above that setcpuid=3Dretbleed triggered this IBPB but
I just noticed that's wrong, in the code I've posted the IBPB is
hard-coded. So to disable it I'm setting clearcpuid=3Dibpb).

metric: compile-kernel_elapsed (ns)   |  test: compile-kernel_host
+---------+---------+--------+--------+--------+------+
| variant | samples |   mean |    min |    max | =CE=94=CE=BC   |
+---------+---------+--------+--------+--------+------+
| asi-off |       0 | 35.10s | 35.00s | 35.16s |      |
| asi-on  |       0 | 36.85s | 36.77s | 37.00s | 5.0% |
+---------+---------+--------+--------+--------+------+

My first guess at the main source of that 5% would be the address space
switches themselves. At the moment you'll see that __asi_enter() and
asi_exit() always clear the noflush bit in CR3 meaning they trash the
TLB. This is not particularly difficult to address, it just means
extending all the existing stuff in tlb.c etc to deal with an additional
address space (this is done in Google's internal version).

(But getting rid of the asi_exits() completely is the higher-priority
optimisation. On most CPUs that TLB trashing is gonna be less
significant than the actual security flushes, which can't be avoided if
we do transition. This is why I introduced the IBPB, since otherwise
Sapphire Rapids makes things look a bit too easy. See the bullet points
below for what I think is needed to eliminate most of the transitions).

>> Native FIO randread IOPS on tmpfs (this is where the 70% perf degradatio=
n was):
>> +---------+---------+-----------+---------+-----------+---------------+
>> | variant | samples |      mean |     min |       max | delta mean    |
>> +---------+---------+-----------+---------+-----------+---------------+
>> | asi-off |      10 | 1,003,102 | 981,813 | 1,036,142 |               |
>> | asi-on  |      10 |   871,928 | 848,362 |   885,622 | -13.1%        |
>> +---------+---------+-----------+---------+-----------+---------------+
>>
>> Native kernel compilation time:
>> +---------+---------+--------+--------+--------+-------------+
>> | variant | samples |   mean |    min |    max | delta mean  |
>> +---------+---------+--------+--------+--------+-------------+
>> | asi-off |       3 | 34.84s | 34.42s | 35.31s |             |
>> | asi-on  |       3 | 37.50s | 37.39s | 37.58s | 7.6%        |
>> +---------+---------+--------+--------+--------+-------------+
>>
>> Kernel compilation in a guest VM:
>> +---------+---------+--------+--------+--------+-------------+
>> | variant | samples |   mean |    min |    max | delta mean  |
>> +---------+---------+--------+--------+--------+-------------+
>> | asi-off |       3 | 52.73s | 52.41s | 53.15s |             |
>> | asi-on  |       3 | 55.80s | 55.51s | 56.06s | 5.8%        |
>> +---------+---------+--------+--------+--------+-------------+
>
> (tiny nit but I think the bottom two are meant to be negative or the firs=
t
> postiive :P)

The polarities are correct - more FIO IOPS is better, more kernel
compilation duration is worse. (Maybe I should make my scripts aware of
which direction is better for each metric!)

>> Despite my title these numbers are kinda disappointing to be honest, it'=
s not
>> where I wanted to be by now, but it's still an order-of-magnitude better=
 than
>> where we were for native FIO a few months ago. I believe almost all of t=
his
>> remaining slowdown is due to unnecessary ASI exits, the key areas being:
>
> Nice, this broad approach does seem simple.
>
> Obviously we really do need to see these numbers come down significantly =
for
> this to be reasonably workable, as this kind of perf impact could really =
add up
> at scale.
>
> But from all you say it seems very plausible that we can in fact signific=
ant
> reduce this.
>
> Am guessing the below are general issues that are holding back ASI as a w=
hole
> perf-wise?
>
>>
>> - On every context_switch(). Google's internal implementation has fixed =
this (we
>>   only really need it when switching mms).
>
> How did you guys fix this?

The only issue here is that it makes CR3 unstable in places where it was
formerly stable: if you're in the restricted address space, an interrupt
might show up and cause an asi_exit() at any time. (CR3 is already
unstable when preemption is on because the PCID can get recycled). So we
just had to updated the CR3 accessor API and then hunt for places that
access CR3 directly.

Other than that, we had to fiddle around with the lifetime of struct asi
a bit (this doesn't really add complexity TBH, we just made it live as
long as the mm_struct). Then we can stay in the restricted address space
across context_switch() within the same mm, including to a kthread and
back.

>> - Whenever zeroing sensitive pages from the allocator. This could potent=
ially be
>>   solved with the ephmap but requires a bit of care to avoid opening CPU=
 attack
>>   windows.
>
> Right, seems that having a per-CPU mapping is a generally useful thing. I=
 wonder
> if we can actually generalise this past ASI...
>
> By the way a random thought, but we really do need some generic page tabl=
e code,
> there's mm/pagewalk.c which has install_pte(), but David and I have spoke=
n quite
> few times about generalising past this (watch this space).

OK good to know, Yosry and I both did some fiddling around trying to
come up with cute ways to write this kinda code but in the end I think
the best way is quite dependent on maintainer preference.

> I do intend to add install_pmd() and install_pud() also for the purposes =
of one
> of my currently many pending series :P
>
>>
>> - In copy-on-write for user pages. The ephmap could also help here but t=
he
>>   current implementation doesn't support it (it only allows one allocati=
on at a
>>   time per context).
>
> Hmm, CoW generally a pain. Could you go into more detail as to what's the=
 issue
> here?

It's just that you have two user pages that you wanna touch at once
(src, dst). This crappy ephmap implementation doesn't suppport two
mappings at once in the same context, so the second allocation fails, so
you always get an asi_exit().

>>
>> .:: Next steps
>>
>> Here's where I'd like to go next:
>>
>> 1. Discuss here and get feedback from x86 folks. Dave H said we need "li=
ne of
>>    sight" to a version of ASI that's viable for sandboxing native worklo=
ads. I
>>    don't consider a 13% slowdown "viable" as-is, but I do think this sho=
ws we're
>>    out of the "but what about the page cache" black hole. It seems prova=
bly
>>    solvable now.
>
> Yes I agree.
>
> Obviously it'd be great to get some insight from x86 guys, but strikes me=
 we're
> still broadly in mm territory here.

Implementation wise, certainly. It's just that I'd prefer not to take
up loads of everyone's time hashing out implementation details if
there's a risk that the x86 guys NAK it when we get to their part.

> I do think the next step is to take the original ASI series, make it full=
y
> upstremable, and simply introduce the CONFIG_MITIGATION_ADDRESS_SPACE_ISO=
LATION
> flag, default to N of course, without the ephmap work yet in place, rathe=
r a
> minimal implementation.

I think even this would actually be too big, reviewing all that at once
would be quite unpleasant even in the absolutely minimal case. But yes I
think we can get a series-of-series that does this :)

> And in the config/docs/commit msgs etc. you can indicate its limitations =
and
> perf overhead.
>
> I think with numerous RFC's and talks we're good for you to just send tha=
t as a
> normal series and get some proper review going and ideally some bots runn=
ing
> with ASI switched on also (all* + random configs should do that for free)=
 + some
> syzbot action.
>
> That way we have the roots in place and can build further upon that, but =
nobody
> is impacted unless they decide to consciously opt in despite the document=
ed
> overhead + limitations.
>
>>
>> 2. Once we have some x86 maintainers saying "yep, it looks like this can=
 work
>>    and it's something we want", I can start turning my page_alloc RFC [3=
] into a
>>    proper patchset (or maybe multiple if I can find a way to break thing=
s down
>>    further).
>>
>> Note what I'm NOT proposing is to carry on working on this branch until =
ASI is
>> as fast as I am claiming it eventually will be. I would like to avoid do=
ing that
>> since I believe the biggest unknowns on that path are now solved, and it=
 would
>> be more useful to start getting down to nuts and bolts, i.e. reviewing r=
eal,
>> PATCH-quality code and merging precursor stuff. I think this will lead t=
o more
>> useful discussions about the overall design, since so far all my posting=
s have
>> been so long and rarefied that it's been hard to really get a good conve=
rsation
>> going.
>
> Yes absolutely agreed.
>
> Send the ASI core series as normal series and let's get the base stuff in=
 tree
> and some serious review going.
>
>>
>> .:: Conclusion
>>
>> So, x86 folks: Does this feel like "line of sight" to you? If not, what =
would
>> that look like, what experiments should I run?
>
> From an mm point of view, I think obviously the ephmap stuff you have now=
 is
> hacky (as you point out clearly in [5] yourself :) but the general approa=
ch
> seems sensible.

Great, thanks so much for taking a look!

