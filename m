Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEEACD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F166B024D; Fri,  8 May 2026 13:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667116B024F; Fri,  8 May 2026 13:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DE76B0250; Fri,  8 May 2026 13:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC326B024D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:41:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E801E12021F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:40:59 +0000 (UTC)
X-FDA: 84744968238.24.9665D05
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 357F6A0009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:40:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rmt7kk8x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3KCD-aQYKCLcpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3KCD-aQYKCLcpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778262058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhr4BNU/ilo4uYM728zx4k0/Id92bF2OOCtFb+maHuk=;
	b=XKqr33IiCiPLviEAL00jfpl9TxQ+u6WDj+3QWgjYNNbLOKALrctg9gueS9MB1yRJGeyubF
	x/wkQT9yj21e5oNrJGUfkPJYmv/UfIptPO3WOECf5DNY3RXJDS25BGArM2nQD8WRsUhOWT
	yx1xlc+HIJF+/VHCPjGSxn0XZVNj+H0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778262058; a=rsa-sha256;
	cv=none;
	b=0TL3xXe7gGSyhkGzw5Y/5uUJ1ZtlJHK070l5/RKfrlAippr1Nq3Hh1S2hjyomeLTztqif4
	xZkB+V1BEpe2iYdanrT61A58Rn38N0nFz5lvYkOhvfVN5ArImTEh9pXwiX2eqKXXaVwPol
	7IFWzj/r5PkHAdE8A6q/FLr7MpOqpDQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rmt7kk8x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3KCD-aQYKCLcpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3KCD-aQYKCLcpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-835444b6ce1so1713845b3a.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778262057; x=1778866857; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uhr4BNU/ilo4uYM728zx4k0/Id92bF2OOCtFb+maHuk=;
        b=rmt7kk8xvM33TeyZmp/jWJeV1/OcXdlgsETNIN+Aro4V2/rDoboWyibh6FG2AqZHkE
         05fw8Klo8eUF6xwRC3XqnVajhQG+/yuRMC1KDg3Jrvm34qS3I7Ta1/LP55xjp492Ipm1
         laOMI1gDs6jiCiRivpBxVvrKZJAjXYm+Gte6yeEihZM/HWuTXBlDF480Ev6i1H7vDU+C
         st4hZj/WHdYgdY9e5arNhPyI3ZeKKKvpOjdhKgYyrtFjNHNOF4SekStcACuj6z29KCrD
         bFqRypOgKi+yX+O/3vssnfmSM6siNQCFTy6Se2PDEnU8/y2eMezrBSuh3VO50mI/8jnQ
         I1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778262057; x=1778866857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uhr4BNU/ilo4uYM728zx4k0/Id92bF2OOCtFb+maHuk=;
        b=PgE1VE5skKxH8HbCtOhEWkuVSFdXWPnygssbxVcX5Y0RBLYNY6PY+6rrwpJ3xqHIOM
         6YADRK1CX2A6357ytqWiWP18YuoFoiD6Xr+VAaoDuFp0f+iCK59T19+tFcdfH7Tak7Mg
         7R0KSJ5zhQZ9MiR8AwvzyLTk5kekXOjflHNnIsF7/g9L47FJsrbe9DKlhEjyecm5SW6I
         61iG5vp0QiL6mp7Yyln2kj0BDGfPAEuPQ1UAjMjykr7bZDEZrizqoig0Ye0jWII1fQiw
         rrmCLTh6PK6Tu/Z+ie4IGwQrwecOQUPGNTsIivCtj/q+H+D2FvG5oE6//mX1giXuwCNH
         igYw==
X-Forwarded-Encrypted: i=1; AFNElJ9sRL6LbvZdM38+ISu8DiozJXfs4MI6WjNautE1eEBKuuk3sxTfDGV2ev0Ni+5KhMYffWYCSb7lPQ==@kvack.org
X-Gm-Message-State: AOJu0YwYJTXyGXjd1XWCgLhPI3/PmuNIY49bxTuyDQfk4j7rBvL9d/52
	rSdMlpRpG4tS4H6CWBSC8Ee+s/O2jd2rFwwJ5Gw8502/U+w5YBSLxrfy/JG3RXh1fzT0AnSvV7s
	jg6lyKw==
X-Received: from pfjg10.prod.google.com ([2002:a05:6a00:b8a:b0:835:62a8:bbc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2998:b0:839:46b8:86be
 with SMTP id d2e1a72fcca58-83a5d686f07mr13095922b3a.33.1778262056375; Fri, 08
 May 2026 10:40:56 -0700 (PDT)
Date: Fri, 8 May 2026 10:40:55 -0700
In-Reply-To: <foi2zvv5qrfdcspnx4fstrvzl74m6xp6zrsw5omlbprxh4jrhx@vxnwk7fr46gu>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
 <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
 <CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com> <foi2zvv5qrfdcspnx4fstrvzl74m6xp6zrsw5omlbprxh4jrhx@vxnwk7fr46gu>
Message-ID: <af4gJ6xZ3e7UXOuO@google.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
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
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 357F6A0009
X-Stat-Signature: dpnmuoa6m9m3jtdheeb161kfqdd7jhux
X-Rspam-User: 
X-HE-Tag: 1778262058-382404
X-HE-Meta: U2FsdGVkX19BO8ANzQoztbaDfRjvpbLK4H9WUrOaVssqK+i2MHB5J8gdd4+qqTrNOLQBO+Y+8etguSxQeFdlcpH76cPcaTkskKcxRKoWxkUrYOyQlkZKsgfMaDBbn33BdjGOrdv5zjWEh/ePpU7jb6C/E/Pb4xXAyJV+otfRsI3RLL7H0YLCG0xoKJyivY5BmI84amJ5CTLSTkv/qyljeDZNS6Qhoy/abRv+pSbt8pBZaR2AMCkFVe6PqCrrX/zZeoVB2W6Q2eji/I8S/vdLw7M6D4G5Aqe0X7HclP8B2z3RJAZFli6UcuLb9tpbf2I68gTi5HmULfl1Odlz7S0JDif2kWj+uqBgUPwu3bTqB5xIRD2fbwOMM+pt61Mp0uW38FZhj9TGCHf8NYYo1c+uygR6/kKTOpyI0BEbT35dAOJQ59NHPNS85xMcA95n/KGrxQq4if8736kzZPIcoGLKpPnq9SWwdRROawduSdelswV9Hh/MrqkNwR/d0ELWH8YKIOdY2I9SH0M0f3onMUUE19oU0iNQwPTQXztB+r6S5jEiVTX4t2QPYI9bDl0CP/sxIUh4TX5zVL4MxqOCnM4p8Pycp8KsrX1ME+7fXi/VGqUQQDcm1s0yk9NPvKGlD1zJQQrf6g/2udpupDjr70YJnDB2opnlVJZ1mkYdsIjZt+1ievRY7gCKOyckbttXLxn5xm6F14vHUQoGqi3c7t6i7tPUfZhy+sEdZCUu5uwowSGkNqUd2TZOwtVabAfwKXBaOkZ+X89YxmMRXHEpKqFkRh75irNMZg0FsRqVNsGW25GY87DQ5r+9LgaOcqPIJ+WYimt8x/b28G5ZTJVBQfELmiHT2cPFmnur3bnvoPLIeApFQ3Mdxj/92KwvpIsJoBDSsjyytOnEJyRzSw2KzkPT36Y9j2PcEGX9xUWQFOPCBQGE4sWAwvucnNjoXpQojw9r+js/r6GD/ydZWm/bvGH
 kiCXqeiI
 OzBhfFd31fp8fZWb1bE8yTQdbIwXm83T5VIyiYNjawISlk+j0pPcQ/W48N3Ep2g+MluOUfbjmKqZlB+kKY5cGKW/nhsd54imsOk5mxyjBQC3sa2Qsi7JAJES6X0V59haWe6CcPXxblWY8jP4+KVccnBZ4F8C+Gc3Vg0/DwuheKxNyhZQg4V1QssXO9ugKOk79utr2kpnnH8qR4FRVndWJZTZDhXs1UVWGemiOtEbG26tve9pwKLoOLf+uG4cxXGTfNNW6HqCCz5iE4uxQMXcIQX4xisUunRlkDIHRKHq0ii97fRIHaIOEd75L0jm5r2kv4oIb7/sQPyvPR3d0sv2701BFdsJEFy5pXtwdVHGH2CCz/QBq9vF+BUonBRN6gFUAUFdVvPumwzIdtJnFakfcfRjgbwzPCKCIcziwBDhwNqXKoTc2LuDVddO9j89de5ICtnx95l9JaEumZX0HjGXl/UPLmTJB52PfwHjSXkiwTZj/oi+TKqimuOP+arQw+epIeDiBzamGIyqQWQR1hekcb0RxpqWCilK1d6yV9SoxOrioBIQ9iPokRQe4g530QLYVw+vhzAapcfcenhfwd9DyIsjjNpiNWnatrlcG8/qiNm3B2IfrHKBQF2/F+Aje/uN5QkbFhJe2g0gEkjZE7L3WYf/F0WdXHqo8i+kXc5X3+EChNg/fWKMum+TpGnNm29XxFuOYp4kBwfzV70Ov/kBossxSQQKWxV7knzQoViknOivfQQtaM/dYNQpNk4Uze83XVKZKZbpryBZKg3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026, Michael Roth wrote:
> On Fri, Apr 24, 2026 at 12:08:45PM -0700, Ackerley Tng wrote:
> > Michael Roth <michael.roth@amd.com> writes:
> > 
> > Thank you for your patches!
> > 
> > >
> > > [...snip...]
> > >
> > >>
> > >> I also did some minor updates (prefixed with a "[squash]" tag) to advertise
> > >> the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVED flag so it can be used by
> > >
> > > Though I'm not sure how we deal with it if SNP/TDX at some point become
> > > capable of using the PRESERVED flag *after* populate... but maybe that's
> > > too unlikely to worry about? If we wanted to address it though, we could
> > > have both PRESERVED and PRESERVED_BEFORE_LAUNCH so they can be
> > > enumerated separately from the start.
> > >
> > 
> > Not sure how likely it is, but if SNP and TDX can honor PRESERVE
> > semantics after populate, I think we could implement support under a new
> > flag like CIPHER.
> 
> That works, but it still makes things *slightly* awkward due to special-casing
> the PRESERVE semantics for 1 guest type vs. another.

Summarizing this week's PUCK call[*]:

Scrap PRESERVE and ZERO, and simply rely on vendor specific semantics.

My desire to enforce PRESERVE and ZERO semantics and avoid relying on vendor specific
behavior (i.e. on trusted firmware semantics) is a pipe dream.  Unless KVM does
a truly insane amount of per-gfn tracking, KVM can't know the state of memory for
a given page, and so can't guarantee PRESERVE or ZERO will be honored.

If userspace requests PRESERVE, just because it's _possible_ to preserve contents
(e.g. during the pre-boot phase on TDX), doesn't mean the contents are _guaranteed_
to be preserved.  If userspace doesn't actually ADD the memory to the guest's
initial image, then the contents won't be preserved.  Ditto for SNP.

To guarantee PRESERVE, KVM would need to track per-gfn information to know if the
memory was actually preserved.  And enforcing PRESERVE would be all kinds of crazy;
KVM would have to kill the VM or something?  And that would still require userspace
to be aware of vendor specific details.

The same holds true for ZERO.  On a private=>shared conversion, KVM can't guarantee
the memory is zeroed by trusted firmware unless KVM tracks, per-gfn, whether or
not the memory was actually fully assigned to the guest.  E.g. if userspace does
shared=>private and then private=>shared(ZERO), without the memory being faulted
into the guest, then the TDX-Module won't have "seen" the page and so wont' have
zeroed it on the private=>shared conversion.

And trying to special case SNP's "validated CPUID" behavior, where memory can be
preserved on private=>shared after a failed shared=>private, would also require
tracking that the page was never actually converted to private.

Note, regarding ZERO, someone (Mike? Ackerley?) pointed out that userspace typically
doesn't rely on the kernel to zero memory, and so supporting ZERO for private=>shared
isn't really all that valuable in the first place.

[*] https://drive.google.com/file/d/1w0ifzh5PmNViJ1SKru9jK9x52MybXSNa/view?usp=drive_link

