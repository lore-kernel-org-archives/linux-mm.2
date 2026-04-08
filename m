Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F183610F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 16:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F17A6B0088; Wed,  8 Apr 2026 12:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3566B0089; Wed,  8 Apr 2026 12:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390946B008A; Wed,  8 Apr 2026 12:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 254246B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:55:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C53FD1601D4
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:55:03 +0000 (UTC)
X-FDA: 84635988486.26.23F7075
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9ABB14000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:55:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y2v+RWzf;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775667301; a=rsa-sha256;
	cv=pass;
	b=wGw1piJh/72h0hSDO0MH1ITYk4beCBiGjOkr/Lxjhtf/GQ9Uq/Q7d3eMyP0bA4ii4IkuL1
	j6Hq/torOT8CQxpCF+4SH0pnZcr14CLfE50QeLQ1MNGzZJ9Wxw698GYsx0Oih4ragX0Rh2
	C3CB1DpbdqNDRWEbG2jxZCMfmA33Bco=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775667301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hc5WlcEO3VRIzjSYe/goBDsaf62/8tmgRtSvUVeybvM=;
	b=UlR6l0XAPBCUnmwQlGCk6BjeE4nqZ416zh1YsaYLEcHlHEBz9NbnOeWhsyjjXdFDeIkEV7
	2ORJkcnVWQsvMLPo0HN9SQn9DRAfsBA42+YPhVvUdD5CntK/BC6toCEwsjsa1NHxjEJDwz
	X1XGo/AC8ZV2YcYzC5VEFaQLjLucj7c=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y2v+RWzf;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-953a26a9abcso23395241.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 09:55:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775667300; cv=none;
        d=google.com; s=arc-20240605;
        b=eeXEB3L5EuEtvI69cbjdkTwjX0suLW7IGsimekOWK+Uajeodt84fwBgkJVgfx5hE+a
         zDYNtHIPVP+53cmfiI8XErP8NETGDJeBG1TM3Z8SUbAOdXMyNQ+Od0Mk7HN2FltF7GhG
         9Jj390nyU6BXEBAG1bZvKgXeYiHFZnpR27cHSHj3YlIcpxK6c54kwkO3PKW6xLCPZ5hl
         SesctvM72an52VxGWt8i7Ig9xKbKq9uws2PT1hCCVOCJmXg+Mc+tQN9bwjOwgI6Vd3af
         gkYNEjoHwzymPGSMwP1dFgPaZn4KEXn7PkeEDr9cXpI5bF0b3hqpMUFd+vz210vsYX/D
         w+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=Hc5WlcEO3VRIzjSYe/goBDsaf62/8tmgRtSvUVeybvM=;
        fh=64rLPAgvPMv5pMteeL8CTWYYO2xMEZmfaTxfVBsR0ok=;
        b=JjFeZFz1Yd4lIaivHk2J3ysyLgIJKVvsZMN5j6iI37VhQ1YtPhA+pa5XIK5HAWWnMA
         K/vVp7G/61v2iRb7SDCMIzoMCk2T0q/AdOrE56uC5G70tAluBTycic/xfa018y/sPnmt
         ZnV3hCZg6PqFO3yvlnXm3YyyDAV4YwNHBcASMk75ORFM8MXMvnHCARJDph5FoeG8DFVC
         BrLPzyFq5IIf6z0F2rRORbhP5kdvGt6Sjzs6aRzdFERv/35UznsviX6QrzH3yY7IB7Wc
         w2ZXreRiw1v+EQBr35dVlNdWcjZKowGlVMAlH74Tse0dwPzdcf2bXBmKPFOhjAqnn8dG
         wFxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775667300; x=1776272100; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hc5WlcEO3VRIzjSYe/goBDsaf62/8tmgRtSvUVeybvM=;
        b=Y2v+RWzf4LiwOj1agiUPxEMvEN65bJeik+oTVM4msteib+98vmYohuufboIzVv5wiQ
         fVp3iEnTp5lVV1Gzyl6KXR836XJqrQ7126+eVYu1koSqXCYqBt27WuFE7xFtsl/zaaGz
         YHBihljBJolXazwXf7WZB9QmwbuovR3Gq8xO+TYPaQGNAEqMMC7vhGJyoPkXyzZkTBga
         Ek0anFITNZwldTp1F+jbyQwB+UVNBpxw6zdYIEm8Da6Xam1Ob0PN8cYnXaW8r+VNtldO
         JnSI2TsuWSx9vEw1eFEbJ4oqCB4SQFYaaZK86e5f6v8Sp/r9XTJVurnvUr+IqPpaodJh
         OKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775667300; x=1776272100;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hc5WlcEO3VRIzjSYe/goBDsaf62/8tmgRtSvUVeybvM=;
        b=ecVZwgoqJEoV6Nn3XLLIj4+wCh8w73LbrHJVEktVUSHVlxQjNTdDucIrugj3AXp0hl
         +eer0WdIUbIt0c0tJk5UawKGLY73MF6Ahv9BjFPqM48bCVacPy4LxtB53HLM/MUairiA
         bHUNHGhMJ00Ka6SuRxa2IS32cM5LZezxvqN9W4BXEZOfHP+P1fBIDPpHecVICxw2mvol
         DdEPwr4MQnVU1lEwFR29b3DRtr5CjwmHpEQVlwgEdyeu6gdKDyRk2PMFxo01tpchiDnc
         Bg//UoNBK3vIEH2TblwRUnakiOSBpq/6hwZwWLdRGo8t9BNE+3IfQg9dq6d26WyFkOqh
         hPiA==
X-Forwarded-Encrypted: i=1; AJvYcCWKhSSU9S1a1QAHvdyPlOxqSS6URhZcXL8A2P23dxZoRxyV6YEEe7uJCMNoCzCA4NfFCIHZpMna/g==@kvack.org
X-Gm-Message-State: AOJu0YwQpl4IlumLW45OxOM6fOqvT5l0kQ4YOlEuJawZ0+mlPml5EvRL
	MoynN545XncE8OffJL9x89N8+Vnd8+Ccpfi3zB0YckmrEF2VyuXW4ub62x+1Gf0pd/9Rtfj9OBD
	3Vbmk3vPcfXJUU89WXyvELCZ887qDB+mqQ8abxP23
X-Gm-Gg: AeBDievlEvObu3/fwfWZ8AOXqGL8iFf5glXkOs6dOUjTQG4I2Kq55jE2nLT4IK0mL+v
	3frGOrQBQICbdOWyKC2KphG1BsRfrLZ7qVhgJ7sRD5iM72fWMj2r4J2Mbgcm6hYRQ581D+wNp9N
	NKuGfI948NV5CPhj3SevPI+x0VmaaZevTXOQH1V2YfPe/fzgrZ9RXx8IEH0gyyGmMzlnLfG1iI6
	Oi4tTpMdJCqzaW280TAjeGhJwgVU28TTyULrzP+YeovePp465AAOU58ZPWJt8FKZ0rss/Jwqk06
	aOv8V2NjRKYtzcxrY8yWZez6lq7RCyA911u7xESTrIyZVtmA57EGXAk8YkIlRTpRYmq7
X-Received: by 2002:a05:6102:84cd:20b0:608:7548:e83d with SMTP id
 ada2fe7eead31-608754946aemr69543137.4.1775667300069; Wed, 08 Apr 2026
 09:55:00 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Apr 2026 09:54:59 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Apr 2026 09:54:59 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <adWidf8UgZeYctr1@google.com>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
 <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
 <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
 <CAGtprH-kgRByFvvCYeWMXtsvpb6qpaWAo8k-3PEnioyPg-LEvA@mail.gmail.com>
 <nmy5polcxfnn3hoircsiqarxmzlulwwq7w34okanccntp32v56@h2eac44agovv> <adWidf8UgZeYctr1@google.com>
MIME-Version: 1.0
Date: Wed, 8 Apr 2026 09:54:59 -0700
X-Gm-Features: AQROBzDEn1_3NBAGLEmc8QVN_GaYAKpE-wwKaGsHEMeG9rJe3AOLJkD1JUoUTtE
Message-ID: <CAEvNRgEcKnHkgC2iK8hRMybruY5LrxWH+RK94M7MddUqgGChHQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9ABB14000E
X-Stat-Signature: ewye1e6hn6r7aoby148dm8r857q4kcb4
X-HE-Tag: 1775667301-466286
X-HE-Meta: U2FsdGVkX1/rNRBg9Fua0qOd/XWjocTxOrJpOTulSiw8s9LLnoumA0+bHCzk3uVUjlULu+gZraB3Ryx9J8WfuCXhNEFXoURFPEROjAOie++1M5/2xnhGjBC2i1N8BCy/sZNF3ybT4yb6stedXtznBh9LHc09T+Gwm3x9xdcMwuxjXJlAogc4d6rUm2iSbT0KCxHfoApUnM+mmVMdfzGQNE36RBoIcUJWaXbChenlE2KFN1JcdYUpYQR8lMPFlGw7aTsACt6HryrYwPlcrW+10ivW+W0RBqOh9UasWcAVMWXYXSge57L4GJ0JLoDOgZljTTP0EpRE+TwQ6n4gq5d3Uz3+ewtPV3VnuqSJc0j9MDmsxtQ11n11q9l+mfV9Wh96J21sjbhWR+TI/5LXz0Yy0PWV7bDYCd4AB6i87AjrQL8ezjH1dDelImZS/xqBVqUGV+uQmE+Jf92esAtHvNOPHgnuxUegKMo9M9geNwsSWHLUaUELqwdWr+cMUCa/x4cuk7XmngUUu2QRBVyT2viZbvVQpz3CJHRfbNk+AOpPMybLG6qWL+EkWNz1pxChe/LbB6VTsM8C7w+Tt8y4DNc5/7Cuopn1u3Kw78+U8rSr7oxbetc34q/25BUc/DuqlcoSGqoZwIOgg/6V98ce3nouqCP5wlWmpe23MMYiVAWR25r2DmhnJhnt0xTqgp2Iqi+kD9qhk1bbr3dHV7QF3KrWhtlONVrBx3jmCK8zz9jusxPYuN9JK46PItOu2NsQ7ChaUmLy0v8AsEpBm6WDCKwoAiLeBE2/aatYAekprFvi0jfm4tUZnilHkl/d3sWslpZAAuGD7IlLv6JoK+5qQY82/88Wq7J15W0u9GP4hBSqMNe/NafdSDB/3VwYm2ckv9y7/XxaxEA9311BEN6a0IbssH9V2zhzz/k4I8En9CetfOjAThAnMuqQd3Gs0khMMAQ5fEaNuGC3MFRRifoA5Tx
 uwr8n3xb
 oNqKn7Tmg46WhF8OhFft0kl7o73RMwdgJsLDXpwfVoFUhmmsmrHEOhRipCpf/CSmaLXD6GqJGZ+qgwU+qDvFaCA+LMTaldVm0V1WioVU71yMqkgalKesjxJ+Umde5camJy50E9f635m9KkJ2ek+XywD7aj+bhznYCCShzbf/04FWN9tulBoY4MhG20ddc1b38M3IWjys2FIUb2k491tBqphOxQNOP/MCXoXICkG5MFRIfup8kW+go2fuyINUnPHKpTjBTWkT4IUsGTw4yoH+ar2HWCfzo7qk+AKo3hqJwEwyH9pqSRqGRwG7sHyf84xyMG3kYlnXKf/pa8wefUVgMJHr/cpxPbfND6rCHFQ4JpdFKl9bPqxy9WL3xGy+j7MCW7fJHdm/58m2QqWt6SWPIlLeo/At18cUnbfH7aqdyzs+M/jfPK1tPTP6nQaTfspaUqoCJS932uduCSHfIddl5a9a+/AzQfiEY7H5d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Apr 07, 2026, Michael Roth wrote:
>> On Tue, Apr 07, 2026 at 02:50:58PM -0700, Vishal Annapurve wrote:
>> > On Tue, Apr 7, 2026 at 2:09=E2=80=AFPM Michael Roth <michael.roth@amd.=
com> wrote:
>> > >
>> > > > TLDR:
>> > > >
>> > > > + Think of populate ioctls not as KVM touching memory, but platfor=
m
>> > > >   handling population.
>> > > > + KVM code (kvm_gmem_populate) still doesn't touch memory contents
>> > > > + post_populate is platform-specific code that handles loading int=
o
>> > > >   private destination memory just to support legacy non-in-place
>> > > >   conversion.
>> > > > + Don't complicate populate ioctls by doing conversion just to sup=
port
>> > > >   legacy use-cases where platform-specific code has to do copying =
on
>> > > >   the host.
>> > >
>> > > That's a good point: these are only considerations in the context of
>> > > actually copying from src->dst, but with in-place conversion the
>> > > primary/more-performant approach will be for userspace to initial
>> > > directly. I.e. if we enforced that, then gmem could right ascertain =
that
>> > > it isn't even writing to private pages via these hooks and any
>> > > manipulation of that memory is purely on the part of the trusted ent=
ity
>> > > handling initial encryption/etc.
>> > >
>> > > I understand that we decided to keep the option of allowing separate
>> > > src/dst even with in-place conversion, but it doesn't seem worthwhil=
e if
>> > > that necessarily means we need to glue population+conversion togethe=
r in
>> > > 1 clumsy interface that needs to handle partial return/error respons=
es to
>> > > userspace (or potentially get stuck forever in the conversion path).
>> >
>> > I think ARM needs userspace to specify separate source and destination
>> > memory ranges for initial population as ARM doesn't support in-place
>> > memory encryption. [1]
>> >
>> > [1] https://lore.kernel.org/kvm/20260318155413.793430-25-steven.price@=
arm.com/
>> >
>> > >
>> > > So I agree with Ackerley's proposal (which I guess is the same as wh=
at's
>> > > in this series).
>> > >
>> > > However, 1 other alternative would be to do what was suggested on th=
e
>> > > call, but require userspace to subsequently handle the shared->priva=
te
>> > > conversion. I think that would be workable too.
>> >
>> > IIUC, Converting memory ranges to private after it essentially is
>> > treated as private by the KVM CC backend will expose the
>> > implementation to the same risk of userspace being able to access
>> > private memory and compromise host safety which guest_memfd was
>> > invented to address.
>>
>> Doh, fair point. Doing conversion as part of the populate call would all=
ow
>> us to use the filemap write-lock to avoid userspace being able to fault
>> in private (as tracked by trusted entity) pages before they are
>> transitioned to private (as tracked by KVM), so it's safer than having
>> userspace drive it.
>>
>> But obviously I still think Ackerley's original proposal has more
>> upsides than the alternatives mentioned so far.
>
> I'm a bit lost.  What exactly is/was Ackerley's original proposal?  If th=
e answer
> is "convert pages from shared=3D>private when populating via in-place con=
version",
> then I agree, because AFAICT, that's the only sane option.

Discussed this at PUCK today 2026-04-08.

The update is that the KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl will
now support the PRESERVE flag for TDX and SNP only if the setup for the
VM in question hasn't yet been completed (KVM_TDX_FINALIZE_VM or
KVM_SEV_SNP_LAUNCH_FINISH hasn't completed yet).

The populate flow will be

1a. Get contents to be loaded in guest_memfd (src_addr: NULL) as shared
OR
1b. Provide contents from some other userspace address (src_addr:
    userspace address)

2.  KVM_SET_MEMORY_ATTRIBUTES2(attribute: PRIVATE and flags: PRESERVE)
3.  KVM_SEV_SNP_LAUNCH_UPDATE() or KVM_TDX_INIT_MEM_REGION()
...
4.  KVM_SEV_SNP_LAUNCH_FINISH() or KVM_TDX_FINALIZE_VM()

This applies whether src_addr is some userspace address that is shared
or NULL, so the non-in-place loading flow is not considered legacy. ARM
CCA can still use that flow :)

Other than supporting PRESERVE only if the setup for the VM in question
hasn't yet been completed, KVM's fault path will also not permit faults
if the setup hasn't been completed. (Some exception setup will be used
for TDX to be able to perform the required fault.)

