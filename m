Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3FDFD4600
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AB06B0005; Fri, 27 Feb 2026 01:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357BB6B0089; Fri, 27 Feb 2026 01:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A0D6B008A; Fri, 27 Feb 2026 01:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0108D6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:35:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1AEC59112
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:35:12 +0000 (UTC)
X-FDA: 84489274464.08.B91A0B6
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id B2F2C100009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:35:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Vx+vbNy+;
	spf=pass (imf14.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772174110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vaa8akeEgfUaZjeRn+BA3sQx4L7fWbq7ZmVurp4ODs=;
	b=62fdpT5FchTp9tAv+JISBvB0xtCn8mBvP9JUr9TjtYIAq1aW88PAylhtC9pa/BbnNyNwpu
	dJ5wi/rS7iymNtQEQOwdPypFiTwU0E2jmB7KDsUaiWGQdkVEDS6jIigQYmqLyRatvUxNst
	jKqFeyc24O5IlZeSjRHbxfwur4FNwo8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Vx+vbNy+;
	spf=pass (imf14.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772174110; a=rsa-sha256;
	cv=pass;
	b=vCqYUwam999Gf9myYSilMJZK3IP2MQX6AVq4ksswz+x8AQ3FsBKh/XNmWn/idR0JPwivDb
	xjJAL1bdp/kNQXLFcRAvZ/0cL9tdGECNVy7kK0zzGmCPRnRvIjm6SY9SPiylXOFKVXWh53
	k3I25n+gpPa4GaMX/Lr3FZ6Y0mzXxTc=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2adb1c1f9d4so56975ad.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:35:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772174109; cv=none;
        d=google.com; s=arc-20240605;
        b=TqVyOF1FkkpMnpbe2x6q5wydDqPtoxuNlTWZAnoJEzSIhh1RuQMNlkueSZ0xChCaUb
         MHnC8ueKp3q0dItTBrGLN7JSPL7q3BnVVLnjpol2gEPi7oqXpSmyRWzk9xd9wfon+e2y
         vb1x5sKQ5evbE3KRWoglffBEd0sTBmiVPOjtHxnm0bvu02ouj5ofhfxAIuQ+V2jh6st6
         ROiBzbAjYNhS6DZZEpr0D6YelKG9ytZuveIR/5nnIuVAYewcf3vx5E0GPbSLXStxaNyf
         91IEzLJwsZEgid5kChGEu/jnH4T1H+2B9iBHBU0texWNcayjB3EfpKmdSXye93RYdZ2a
         EyXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5vaa8akeEgfUaZjeRn+BA3sQx4L7fWbq7ZmVurp4ODs=;
        fh=kfZ5ttIDFDaU84ilDDi0gsNDWwfDyjKW85ldGVJqWzI=;
        b=P6NiaDxAg++YsuF0LHZcX7zR8DcLzQSj9mcayORcpT8LAPHHiti8dHfO0Zdp8qTDS5
         BMj47FtZG9OZuHaO1AeM8jeDq+WdGY8csUc6UKUFWlLA30OEcfabtRX3xRELiUZiPhnZ
         AOuLhsm3hqDlu0TxFBQhIjrBgFDdOdHORm7OVhpoVXkZHIOqsDPacRBWLshI51ecvukd
         OfsEM2YgJfGDBJiyp5zS2Ra17wEyB1Ehc3u3gUOBuPusYQyqW1H0vsybOqKztfjH1sYB
         IBHSdoN0BCr7+a9A94zmlLJoYi99Aj3u1oNdSwRm1nUm3/Kp9J5mS9TtT6k3WWGbH260
         dj1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772174109; x=1772778909; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vaa8akeEgfUaZjeRn+BA3sQx4L7fWbq7ZmVurp4ODs=;
        b=Vx+vbNy+mbWg6dKBP9+6/vCFR8YHkD1lazxh7ouegKcgHb2KD3ZVJCprTEy5Hz200h
         PzoE25pF+1JJxFJyru8XhQuU/I1M6+6EACb2AQt5IvG+Io7boyONpIVk5And4OJWCbxX
         vbqktauAdFhQlTzCXc9gVCM1nj5h4L5dSQVai/4/hWZ/JmXr5IA8ExIrbKEg9hkYVCZ0
         sj42kXNHJitGUlOqnHISUa87Che0+WnmJcmlaNYPNpizjTJ+ftaEhKtumrDrC6gWVVRJ
         YSzwHehzoRSrzW9xblHB4hvXeE5z4LDBpjBPMWK1cmFOjMo4/++qjgNiKzUW2PWBqLTb
         9jQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772174109; x=1772778909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5vaa8akeEgfUaZjeRn+BA3sQx4L7fWbq7ZmVurp4ODs=;
        b=vcK5Ui79rZBy2BOEPD3iiy60KUqwcWkRWqN4bl64gKtkZx1oEgWG9o4qZk0WEFW+NN
         eFLYw1jnsV/m7hGl4CXtHyB2fyLm9Gjw97bUyIX9TFDVsDRQxlwVLN6qvtMMbLTuGSiF
         tBxu3NhE1AWErORuURz1nP2aMiotY0VbmDEslBfLl8/SLST5qUBP1wUn1d1ZaM/wsXhT
         Y3RPZQJxFrnoQFoiZQ2Ey1+eVvVfqoGyZubhtHszKeKrzqvCv5pZk+lZEI1StmkK3p84
         vNRWe6GsnjSSBSmgnuAAMAymvloyaDyuwPXjsgB+izLq1Zeod2bUvPJ8ueIgymkS9iGi
         7Tkg==
X-Forwarded-Encrypted: i=1; AJvYcCWRngI2oim9YHXEtUZsexMtK7+4GX5dZ2mYv41/mKGJVtPCisYU4qbWtCwYw0IioTJIBB+OL61Q3Q==@kvack.org
X-Gm-Message-State: AOJu0Ywn9Qxu+zkWeiNwPG8KXgoUbF3mlrxgD/w5wapxdQbdQDzOyKRQ
	rO4OEBt7wWCkk6zeqm+RkozCVnfx2pOC7I1ZF9o/bhNK9yTk0h8nOBD9VuYhyGVLLxeVtt02ANd
	MxWNBTYq1ZxouuVnrURVFnDHWmKYd5e/IwDW6cTKf
X-Gm-Gg: ATEYQzxH4wB1LDrKDYCek/5eZRJZkX19RN+1rPTlXKRsBvA+Xd8KtKB2RV/aGTmuf4s
	W+sY9ouq5vwPrd0zkQe4NBkjB8zQ1SM5L8nxA+caewDXBU3b6yDuWFYq3OdfKne2wKPqJpee40B
	XCzaeJSphjLc2PisnUf4/mGgRA5IeK4GcUOp9y8pAYKxPCwikzdLXNG8k1VJxWQxnkO6gab5vrk
	fezrdbMzVGbhn2p8cWyQEHw4o39SzPkPjxruVzrGmtL3Doaz4thbtngaqlC6A0ZUaaqJB1a0UCP
	21IbNXKml1mYrWV28NdfghIiVGR9WRReAULsKZdF
X-Received: by 2002:a17:903:2a86:b0:29e:27f4:bac0 with SMTP id
 d9443c01a7336-2adf77c692amr4716545ad.16.1772174108996; Thu, 26 Feb 2026
 22:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
 <b82a5ac3-33e9-4cbf-892a-f0c7f6fe0c20@kernel.org> <CAC_TJvdgvyjyJsU4v6W+3tHKx_2e8UMJU3RT2HKLSngcC+yH3Q@mail.gmail.com>
 <5tdailzxoywzzunbwhtlk4yjfmzunntniqtudkb52q6hib74ql@oq4mi226dedv>
In-Reply-To: <5tdailzxoywzzunbwhtlk4yjfmzunntniqtudkb52q6hib74ql@oq4mi226dedv>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 26 Feb 2026 22:34:56 -0800
X-Gm-Features: AaiRm50sVIIQTfT7ctHM4g1t99KQJhS99wa_T7m6oioVRZFMpAuvQzucC4RWMJU
Message-ID: <CAC_TJvdC+CSqvx+BvOv4gO2mJbwiBhb6OZO0sx=GXQ0CmA853g@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de, bp@alien8.de, 
	brauner@kernel.org, bsegall@google.com, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dietmar.eggemann@arm.com, ebiederm@xmission.com, 
	hpa@zytor.com, jakub.wartak@mailbox.org, jannh@google.com, 
	juri.lelli@redhat.com, khalid@kernel.org, liam.howlett@oracle.com, 
	linyongting@bytedance.com, lorenzo.stoakes@oracle.com, luto@kernel.org, 
	markhemm@googlemail.com, maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, 
	mhocko@suse.com, mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, 
	osalvador@suse.de, pcc@google.com, peterz@infradead.org, rostedt@goodmis.org, 
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, Isaac Manjarres <isaacmanjarres@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, android-mm <android-mm@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: iw7576xzp1dki939cay99bhfbxmdd8pk
X-Rspamd-Queue-Id: B2F2C100009
X-Rspamd-Server: rspam10
X-HE-Tag: 1772174110-719133
X-HE-Meta: U2FsdGVkX18GAgjyqUqIUzi52w7eq0XMFynC1PMnrrLtnwN7UWF286wZkIt3NbZC2m0f9vngLWTrsZAt6rHW7DYtBkVGAt6+N9TVugyViorIkqNzYCW9/50RRav1eiwzJQDSu0feaLAXVc2NlhlLZEo4pKtmSowA+mr9s1nvmwZwLGxyehZrjwaxMtP6S2uhzxwnSMuzEcCScUNLUY4H9DxwVQWdM3c++qbGlf1NW2TwoXvxqO/nF3/0Iy8gB3NPDbLxAVb+/hyRvJORZWmAcpmsCCSKv4A+u8eAOKyQvOio0qGYlNt2kwfLkd7J5ecJSxiPCMJlv6lfQiHlxzm0i/LWiMUmwEV1B1I1CGmNozCJfr+l8DjahcHQUjth3OqhneeS45P7zib3rwwcm+xntu8tQE1VN+oBSLxtO48GdU6oIwP9CErCbHSo4gcG8pM7u7FnQNbqjCbc5/ww/E+rDKbLmheNtBRtEjgfKyhgkDajV8ufYjT8R7FVVypqVq+LX2tpPXtoQ8m+Icce1yGldjbYG0nPg36dwus7yaaTuS81Bgh85SOarjI1Xe1Xwcrm4BX0lHnVrYNxebJP1TzG8zJ2nqRGNyl3bBORsj7UFZROOreB8WO0lkJ0DpjJvcCG1Onqk2ZUP4agUkMKnpio9DK67QOBbEDYBCLw3K4KSVgSfSNSj7vDf9oZWZnRyObR38S/xzv1/26Yn2631N8IE9qJIYzgafxXDUo2gC0ft2liwc/1wKhxTeNuklFgjrE7j/AVGxSLO/+hiHgLAWsGU1S5D8FY5VaxQoe+r+Vb36JpJMq+EEWaChfPr/eD/nN39pPLNPntuoF1hLa5+mepI+CIq8cR8qJazvV864U9A1y3ti3Wa/xcCLBAw8I8VjEwGcEL1reNgKpt45aBy9v2cjRSI28cE+sRoCZlzwmBzsTuEvBEKa6tfOK3wUoMSWOEp5Ywdqo1o27QsWp2eMh
 SYcvQ4oO
 PyQOSoELDiVHrElx49njGaRwC6WnzHsYQLedZpt2RgF4DABD2AVjuYQI6snDEtnXC40r6DnPMJJmlsyclJxxpQxbvHkKwq7v1shJr5Wf6eGpQdu0JYCWLLhaJCylEET0/wzvlU8FA6raw9xX58PTtzmHAw6GOooK519+JmKvElFGUwdFLYxZkKvVjLnbzb+l2UjQ0e1gcNG0Jg9zUU0FiZxlRJiIHRgLgvh8pcQRUc5xhBUhGYM3rzwLCgp9pUxYtff3O0e6yF1Md8LOwcXnY+QGWu1iCtdpjNqNhX/mE5eNukV1rwg1hzyucU6/VtDbaN8u0ZTlpBr0YIvWB0TZ6xwrmrSYjVQERBo7uwDJN0n1RAbf/LzfoiImckeNDdObBnmPr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 1:22=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Wed, Feb 25, 2026 at 03:06:10PM -0800, Kalesh Singh wrote:
> > On Tue, Feb 24, 2026 at 1:40=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > > I believe that managing a pseudo-filesystem (msharefs) and mapping =
via
> > > > ioctl during process creation could introduce overhead that impacts
> > > > app startup latency. Ideally, child apps shouldn't be aware of this
> > > > sharing or need to manage the pseudo-filesystem on their end.
> > > All process must be aware of these special semantics.
> > >
> > > I'd assume that fork() would simply replicate mshare region into the
> > > fork'ed child process. So from that point of view, it's "transparent"=
 as
> > > in "no special mshare() handling required after fork".
> >
> > Hi David,
> >
> > That's agood  point. If fork() simply replicates the mshare region, it
> > does achieve transparency in terms of setup.
> >
> > I am still concerned about transparency in terms of observability.
> > Applications and sometimes inspect their own mappings (from
> > /proc/self/maps) to locate specific code or data regions for various
> > anti-tamper and obfuscation techniques. [2] If those mappings suddenly
> > point to an msharefs pseudo-file instead of the expected shared
> > library backing, it may break user-space assumptions and cause
> > compatibility issues.
>
> I'm not worried about transparency because this is not supposed to be
> transparent. This is not supposed to be used by most core system software=
.
> This is supposed to help replace hugetlb page table sharing.
>

Hi Pedro,

Thanks for the detailed breakdown.

Firstly let me state that my goal definitely isn't to derail or block
the current mshare efforts.  I'm mostly just trying to gather feedback
on what a "transparent", approach might actually look like.

> Transparent page table sharing has other constraints. I like the idea, in
> theory, but there are a number of constraints that make the idea unfeasib=
le
> for now. There are a couple of problems we need to solve first:
>
> 1) Every spot where we modify PTEs needs to be assessed and use different
> helpers (that can un-cow page tables). Every pte_offset_map_lock() can no=
w
> feasibly fail for OOM reasons (and that also needs to be assessed).
>

What if we strictly limit the scope to just read-only mappings being
shared? Would un-COWing still be necessary?

> 2) Various bits of PTE modification/unmapping now needs special care wrt =
TLB
> invalidation. The kernel needs to be aware of how the page tables are sha=
red.
> I don't think the current rmap data structures are well suited to this ki=
nd
> of stuff (perhaps with Lorenzo's WIP anon rmap rework we'll get something
> better). Basically every spot that goes "modify PTE, flush TLB for mm" no=
w
> needs to go "modify PTE, for every mm that maps this page table, flush $m=
m"
> (if you're thinking that COW will save us, it technically won't, or shoul=
dn't,
> because of stuff like try_to_unmap_one() that is used in reclaim).

I think this bit might need to be architecture dependent. With shared
TLB partitioning on certain hardware, this becomes much less of an
issue. We could potentially gate this behind something like
CONFIG_ARCH_HAVE_SHARED_TLB_SUPPORT (or a similarly fitting name) so
only architectures that can handle the invalidation efficiently opt
in.

>
> 3) Reclaim loses even more information as now N processes share the same =
A
> bits. I don't know what effects this can cause. It would require
> experimentation. Perhaps something like "if page table is shared, value
> pte_young more". I don't know if this can work as a bandaid, but it's not
> ideal.

I agree this will require some experimentation. Intuitively, I like to
think these shared pages might naturally stay "hotter" since multiple
processes are accessing them concurrently, but we will definitely need
to experiment with the reclaim logic to see hwo ti does in practice.

>
> 4) It's not known whether page table COW fork() is a real win in most cas=
es,
> or all cases. Would want measurement.

Our preliminary data on Android shows this can save ~200MB or more on
mobile devices right after boot. On memory-constrained client devices,
that is a significant win.

>
> 5) It becomes even harder to estimate RSS and PSS for each process.

For PSS (PAGE_SIZE / mapcount), I can see that a single mapcount from
all the processes mapping the page through the shared page table would
skew the result. Though, I find PSS not perfect already; I think
processes can artificially lower their PSS by mapping the same file
multiple times.

For RSS, I'm not sure I see the blockers to aggregating across the
private and shared mm_structs?

>
> For these reasons (and more, certainly), I don't think working mshare() i=
nto
> a transparent, all-great thing that fits the zygote model can work. It ha=
s been
> discussed at length how to pull off certain hard bits like TLB invalidati=
on and
> locking for mshare, and with mshare we have the advantage of not needing =
to
> support every feature ever (tailoring it more to the big database users o=
f
> hugetlb). And we'll still need to adapt certain bits of arch code just to=
 get
> it to work efficiently.
>
> This said, if you want to discuss pulling this off, I'm all ears and it c=
ould
> be perhaps a fun discussion (too late for LSF, I guess), but I don't thin=
k
> it's workeable into the current mshare efforts. And, believe me, I would =
love
> a unified feature here :)

I saw Anthony proposed an mshare topic for LSF/MM; I hope to be there
as well, it would be great to chat about this in person.

Thanks,
Kalesh

>
> --
> Pedro

