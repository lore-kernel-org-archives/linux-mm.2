Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDE6C61DC2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A906B00A9; Tue, 25 Aug 2026 09:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DCD6B00AA; Tue, 25 Aug 2026 09:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6986B00AB; Tue, 25 Aug 2026 09:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4610A6B00A9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:17:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA882A389F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:17:03 +0000 (UTC)
X-FDA: 85139842326.25.9B09BD1
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id EABD21C0002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:17:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d7XBJY2g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3zJWNagYKCIk5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3zJWNagYKCIk5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TY/LsmF/8fTytR1pzHURVENGerwNjh4wp6cPecJpZ4=;
	b=pU65oM0jDSL1PySR+Ay14DfbvZ9bSDkZ8oojhUiQZljq6354vOaO1MqGjHmQNz83G9PFhD
	8SPqSmZnzOwBwwMJ+s5bm6Af8Mj1JCJhJOxwD5fsjdl38jzJWuAfr1H5RqjBBx4QCFM21m
	ki6euygGG4ztTf3JC4SUCDCG+mBt3Lk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d7XBJY2g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3zJWNagYKCIk5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3zJWNagYKCIk5rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663821;
	b=u1UuHp5sZfAENUGuDHoG2p/pCN9eutGB9VNRl7oIQC20dFqsVlgpU2zWXT83rB/74fBfjd
	nPCyASKsg/Z81CS/eWIGz8r5NO7WK+KSlXkKt/chMrSEvH74sS4N+zoByH1wLUrO1TZTWK
	DH2HsEL6pBepgFlLEE981OKq5B/BPtI=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c89704da8c7so6899679a12.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787663821; x=1788268621; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1TY/LsmF/8fTytR1pzHURVENGerwNjh4wp6cPecJpZ4=;
        b=d7XBJY2g28HKGYXnzDfWeNpMVjI3GCK4i5vLVdOTTyy/jHe33vF6BLkBlGtFrQ55sE
         JiRHtAsdTuVDgHLoLm4IczFyzbODovohcdSk+UwQ1RLpU426B+cnk8XPcxy/i+4c7HiH
         5csB+5zLxuCuss1ZwEB+Liq818Yqfj9TTbguTo/zpsVGBUAzvvntqCJjNO1VnrfP8rA6
         Qux+o/OLwpZiw25Z3nKRgmLo6vuqsFsBAcm5/HAVAWflrkvOCs9PUAH1rYR/fMbcLwns
         QBOZg25IFtBSQ22lXuQp6v1mhmv9AX9qrUezpHBKphLFC5gF35MAx3hsEMcDzKLoUiDV
         J5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663821; x=1788268621;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1TY/LsmF/8fTytR1pzHURVENGerwNjh4wp6cPecJpZ4=;
        b=S6mH7aFqqI6WoN1bIa7vzQCLRWgYCrJ7FTLni0Hys/N+9u0eIkkUEeUiyLbZMOlp3A
         N5MZgLeteQG6aLwRDGQPNocK0TApi4A5lPUxz3i2jQPoV5BVXaQnU6Sgsh+9f//HGuzB
         lBndTVNEMdnkbGHcwI0mu2FtfTgy8hnDSMfIe8y+eTgCo0sld+aKr0kCV3LauJtnIvBA
         wSS1+1B2ezwg0wIyJw2nQKgNMnA8BpsyDLv/wZapZjgH9y+rl7lpbqqacpBlnX1helYy
         xr01vGRoESqYl81wCx1UPrpmC0e0jCAMZmPadHiULJlaH9/e7LZCkpGbJI2fHKseglEe
         CnxA==
X-Forwarded-Encrypted: i=1; AHgh+RpGn5+ogW9/Gl+CszqTEi5PhA2sxtL0JY+1eFtQvU9PqQ86e85fUTRzKaczb7I5QOqBHIeQ0OA8bA==@kvack.org
X-Gm-Message-State: AFuF++mmdhpg4cCQ1U7nUgUe39WQYC4t55onZy4b6z31ez6lmgzWHQrb
	o6CDmvg5fJU8JD0PbV3ojP1EdfQA7OTgoF8gSwuSmtInXgHIM/cg5iG/Kvjqwt70OlnU3o54XS4
	nxc0U/Q==
X-Received: from pglx3.prod.google.com ([2002:a63:1703:0:b0:cc1:517a:d25])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:600c:b0:3b4:61f:1fec
 with SMTP id adf61e73a8af0-3cd2fd8e339mr71904446637.2.1787663820348; Tue, 25
 Aug 2026 06:17:00 -0700 (PDT)
Date: Tue, 25 Aug 2026 06:16:58 -0700
In-Reply-To: <5f7b62a1-957b-4a43-9a16-d06b3f916e84@intel.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org> <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com> <5f7b62a1-957b-4a43-9a16-d06b3f916e84@intel.com>
Message-ID: <ao2Vyjzq9wdYzQPr@google.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: EABD21C0002
X-Stat-Signature: m7kitjq8t649pthc3sago4rn3ti7kf3z
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787663821-721819
X-HE-Meta: U2FsdGVkX1/9GALY2KTquWAylx0EvBurEk76LZR0eNB+600O1WNwB+h3WVLAbOfz/f/V5xjTDOeaYz8r4s/LXNkNbweBgIs2Yeu4V/XcIAt+TzM/J1elC3TJHex9oz6jAFdSmeKe62IVAosQVa1rug5Dkz5wWKZoxMcvCBAPuxjMf1zeO2lAfK5zGdtpMWm7VS1jgim3jJJgFkxsyuWdG0mfNPYLsQnbcxoLV+BYxgA2y3z0ziiaXOzea4KnghRAhqTWpG3NhCfFdN0RJKsOz8PiN/HikfheNhUAHxgIUwrUy/li8JzqTxtLwBeQ9ljTIp2XFBEFCJQfBAZ4m4I3+WYETkqn/axSg+Z5nidEI5xNgeTrUSCUcSnfSoCrs0nYMsd/3AvhSpzZeex0UjHYyG6lenlIvPwPtMtR1FtyFvzwjORkg7ivN3fFjkUvVm8mFdctglmS5ZLpOaNyUk8K8dquR081RGl+btVQtkNXbJTmLSRNv0KqvOmPowk+72JfsJTFR0V6CO4Sje1yV2WEWwiNxxh9+xvmeWDjWtPn8PXAQ9Degcj963OrX0hJcWyZw7QKYOn8Gi8aRquExkROBWd3iW4vt0DZ4d2n6qJ8liH2DR5HJMsp3kh/X0m4n//9mP2uaxxYKqx9rwFwh4haqhHj6PSorOfcRwm2x1OC5afOKxrRO6sANX96ZcWsFnpFcrtnscImdyx8EVbcliG0WVVyabdtTUYoqJvDU2y8Q/iav0ucJycqN2lq1KbdrlaHEgIZtotPtedSG18xraZ9PSNudgM20lS11yrl+hkLH1SbGb0E9C5CY0EN0UZD3wDNWugp28JTFGuN6vFV4/vR5Sleam3k0REMlWqPdzLezGI6u74/uKYCfDK1iCQgv70kTuAoeIAmNzrvmgqGeeHGQQuLJu8TDHvS/XxA1xfjzJVWXRDisaq5UoJHfXdkDBklvYH/yQvxsi9sUuVGJdq
 5mCvAF2Q
 bX0+XhSvKEDPPqxp8FZerfHlx5ADDdD2TmerJ1Pu2KjWdvCMvRtSwzAzKb0EbD/yYFjrdwUYWcSjsvW7+jxlmW4axwm4+s4MLEC+eqa41T6BnwnJ3TxpM4DcnuSMdEkakElQoFX0EYHdpuCN4mJGZajGNNzIxSm2lRalmQXuOQAe4YnFZ7iKcPU4GPRbos0tn2cwMbbHUim2aRCeRJd0wyj0PZPLaIOD1kbMa0BJCdaCLcNhLzc32GK/Z7o4f84Z0VaJUo0H7JbliO4EEYNNCCDybx+Tz3HMzl5aNLqfRMc/X5Pyztl6M/gQziRJ2JdYF49jyHpaTAEPf70AlOEowaFyKXjTM6X8Plmi+gVZ18NqBVypuROH/8+woSgWPX+TEzSZupV7B7dk9xV2x0nBNE3KgRuLxy7IGAMDJ5cfP61TmW11DrWbm2eQrFWCVdYRofFIY/dj4eZxzKlUKhDy4lvNz9iiJTFQlVjAGUalsP/P8Spqdho5bBs0y3CHzSOdfYNPQQWH6c1n7aM/UOs7JGDjSys7JV3sVIW/Fsq4BVR9vh/S3FuaqmE0adff/jhc2Qec2ufSXXk49Ksc/s0NwEFVcBYs65tTnyggdcSmpp6aQSTgOVq+oOaqzRwWuzHbArIGBSa7tSJ88oogQNnsayupbXJcv988+7bleFr9iWjuM1dY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026, Xiaoyao Li wrote:
> On 8/20/2026 9:32 AM, Sean Christopherson wrote:
> > On Mon, Aug 10, 2026, Ackerley Tng wrote:
> > > Sean, do you know if looking up attributes in gmem to feed the KVM MMU
> > > the smallest set of pages to zap will improve performance significantly?
> > > Or if there's any other reason to do this lookup (more complexity in
> > > gmem)?
> > 
> > While working through this with Ackerley, I realized this patch is buggy.  When
> > in-place conversion is NOT supported, then as evidenced by the current code,
> > invalidations are guaranteed to only affect one of SHARED vs. PRIVATE.  And if
> > we change that to zap both, we risk overzapping.  I.e. it's not just the cost of
> > the extra MMU walk, it could also be a functional bug.
> > 
> > Specifically, if KVM zaps both when SHARED vs. PRIVATE is tracked per-VM, then a
> > PUNCH_HOLE operation on a PRIVATE guest_memfd will incorrectly zap SHARED mappings
> > that have nothing to do with that gmem instance (because they're mapped via a VMA,
> > not a gmem fd).  And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
> > using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
> > PRIVATE mappings (of a different gmem instance).
> > 
> > That latter case in particular would be a functional bug, as spuriously zapping
> > PRIVATE SPTEs is fatal to TDX (destroys the memory contents).

...

> > Opportunistically rename the helper to capture that it returns the a filter
> > for all gfns in anticipation of zapping only the previous mapping types on
> > conversion.  

    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > -static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> > +static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
> >   {
> > +	if (gmem_in_place_conversion)
> > +		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
> 
> If I understand correctly, above diff is dead code and will change according
> to
> 
>   And then in the main in-place conversion patch, have the conversion
>   flow to only zap tap the "previous" types (with prep work as needed).

No, my thought is to keep the newly named kvm_gmem_get_all_gfns_filter() as-is,
continue using it flows where KVM needs to zap everything, e.g. PUNCH_HOLE, and
have the to-PRIVATE conversion flow open code KVM_FILTER_SHARED.

