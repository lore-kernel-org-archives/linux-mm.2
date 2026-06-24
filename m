Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56ABFCDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C476B008C; Wed, 24 Jun 2026 18:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C3A6B0092; Wed, 24 Jun 2026 18:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCE76B0093; Wed, 24 Jun 2026 18:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41306B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:31:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49EB71204D5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:31:16 +0000 (UTC)
X-FDA: 84916253352.22.454DC37
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D3251C0007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:31:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AMUxC2d+;
	spf=pass (imf18.hostedemail.com: domain of 3sFo8agYKCK8hTPcYRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3sFo8agYKCK8hTPcYRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782340274;
	b=agZhAe/9Wb2VRB32eTpxsoCQBfaZDSL/70Zzp3NRIbwWXR7QtocDMoNMlp1V68/+4/ZVzP
	5qeu3s44lXi4Z/mKY71kj7NKLPrFZi3lAlzeMLI9X0H11x1nZVKHGe4OBv61UW03I2Sz95
	y+eCLs2bxUUKuP2Np8KGCFl/BfkYlh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782340274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UD0cYPMpLMjUxZJI9vflj/wONeUt3vfrqS2YoALbAM=;
	b=tVds9IUcpevqtbbzY8qH3s6LOSsDNJPlEbaK60aWG6V0eD2wOn231Mm6nVA7Z421roT+f0
	upFPBx6SGJVa1pAmMzmcy+wkszbS8/Siny/Ho/O9VS9pirohRjE3gfQOVqbuOZ27BCXB/g
	2mOYas3q6zmu9ZNTg/TqiVydh/2v3SM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AMUxC2d+;
	spf=pass (imf18.hostedemail.com: domain of 3sFo8agYKCK8hTPcYRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3sFo8agYKCK8hTPcYRVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36d98b76d12so1078260a91.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782340273; x=1782945073; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9UD0cYPMpLMjUxZJI9vflj/wONeUt3vfrqS2YoALbAM=;
        b=AMUxC2d+GWbrigrbYVoJ3PKlWPxVZ91/RrqxEBDbi58TWKTPctGo2p5AyneoWwHExX
         AnZg8FObb/l2jmBdnxWRb/WOEEFXLAThQtdGfcxnHzoeRngXv4h/8GZStQxXA54mWPMe
         LzIs+jE39Kq4ttLJka9i5ZiZ2EbOuD1SBpkm3C0xzBY8qOFGJ3JOelMQDUd6rXWkcV0c
         bQl+0YpPTxhtlOHG6dcDeSmEN/cHDZ8kJ+DhUXzy2qHywpBZclMEcSh/NKLVNStgTCjI
         jvnTUftHKc8o/dQHctKxbM6NRK0cl6gAGP8/L7p5Gjx0LtnPsvlxWjWZ2Sb647t1dXap
         T2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782340273; x=1782945073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UD0cYPMpLMjUxZJI9vflj/wONeUt3vfrqS2YoALbAM=;
        b=Xbx9iqgkQ3CoCGEAUV+Csu0X417m8thlkUSbB+/e3kjzSlzbWCQHAf5AJqRmd6YrB5
         7QJ6cIg/UVR/HJVAL0rjJHUOW36sQ9WNBRvY/QrZ6Q4zRZKI66kc2+3rXl6pp8QUy/uI
         +/uKJ6Dz0tANEy7tkplna2VQFQxgr0Wx8OLwbjxwgkJ/qeb6yeVII3dKqqtRpvpHk05H
         FrMy8L5+208eEp6DlCQAIvB1r5W/eyWRIA1Vw0P7Ux+BnuP7tj9tB7XyjX1Vy7pbOhcY
         UiD7Zq/Hs6ZdRVwo3wSVN/4fwCTCu9Z90BrtAOuLTFBZROPkmke9XmsZ+/masD5eq9DA
         lo7A==
X-Forwarded-Encrypted: i=1; AHgh+Rp1tAiHCLjSio/u9RiwWLyW4KD1sKG52qu0/hvDagzLqLP67pdv0Rv4yNiE7vtbuDJ1E4Dv9mTtUQ==@kvack.org
X-Gm-Message-State: AOJu0YxiSP637LJz8Zk65cNRPb9YaLnrMXcemZI90313a3gL0rnQrmqt
	6STlCfNqh7ALjYhR4TJGS3xNCwAJCET79LCwbwIbiUKf0APBxWCJarAcod/979/4MdXvl4kpMEN
	X6lUdRQ==
X-Received: from pjca15.prod.google.com ([2002:a17:90b:5b8f:b0:37c:64eb:faf7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b50:b0:36d:9e0b:3801
 with SMTP id 98e67ed59e1d1-37dd0d314c8mr11081058a91.8.1782340272872; Wed, 24
 Jun 2026 15:31:12 -0700 (PDT)
Date: Wed, 24 Jun 2026 15:31:12 -0700
In-Reply-To: <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com> <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com> <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
Message-ID: <ajxasFBzp_9KnQLq@google.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: ad338ha68fsb5reyunpxp86xppa75h5c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D3251C0007
X-HE-Tag: 1782340274-952328
X-HE-Meta: U2FsdGVkX18EZJT3xZfibnxydZolWJWf72vwT/L0yKM1gHFaQ157soGXa8Xl7J4GR7NLeVXSHDxvHJgBEFGiFrTnqnc0ypUsC64IwuBV20vF6HD+MoB2yAP2DX/eGSzrFaF6LZ4+9wvaWRw5qLOpD2xrrilAvyb6Hc0xdinpBWKqi8fE65pZD3/Menj/Z3MZZmY0Fky3AGUAwZV0dsTB4nlZEyuxH/Ed5iDvoiDu5TwtidjMg9734QoQML/xzpUKrkC8nF2JX5PKsrtlbA0dHjImJqAlMZvePGYEanWTI3ZNIAuPAvCAk++WHdb7Eo+SP+B6kRcQuQBf0oPI6W6Bl6SP2J+zz6inPLJ+vMa6D+pmCBdn8Zcq4f6Xdav9nVASyJ+fU/jdBMuITRB4nIkuHTTC8YkTXK/fOzbwWUhI/EJ4W/dY8D8HjxkYAvMkkWVMjM6UmJp7IC8G23dQFawiRzQhOeR2Z7Aof7BRJHCavvyH9ycnTU0vMWyHUkcZb1T62u4KmNUUKurFpmnaA8+398O+coPHe7LM/unKmkynOxU6NZboLLq9htgeQ2XmDGHVx+ZSuhBC7162usqtd/stwPkuWN8z2DZKZXulriULHkeL9OYD+8lHMBNHh6U69Q6/CoEVyZjIaxiIDh0N520pgPrnVJMjSKKf7YT7JMjbLXyRpZV4Ya4Tvqenf5ozcghL49CwQNTNajpE9YQPHwUWixaO+YwawUftUxIX8I9MXa6EDMaAW//nWpoDPgrO5oEYZXaRukg+CF1swQA75GTGfqr4C94SSRLbUbLLClwWTBWu7oMQK+F6gB6r/DYuZkqvHvYoYsrK53QiQHt5/LgdP8fZ2N1k2uKd3OnuBfD9/azOQDY5+PNZA7ftk43QSdwGiiMV2OhtHAYqfc0rvOMUwvkUNk3b7/GDIyzkHFA7qmMKOgQ7hY0f4XfLm5dbrnCb7HsBcQJ/tqQ7VHjRhDf
 vKC6daIB
 pzSq3Q9/bFSrt5/gqjbBf5nn3/AQpf/5uOHwrKXx40FwuZDBVLt/JapUFPepkXGRzapJcZ4CVK4Qqcp6892XMjkpef9kFANeTh2NJEI9cME+XKrSgrsQavaN5m8lYPcZ79N+bdTS+5Gf62UBIFC9lc7+Wkhxx+xvVZVVPvCbs0LnKldL1INjBKhxf0PwjyOARaWjpgyzYnec2e3AymIbEj7m4FjKezWCQ4bY19pqml9SAGbLDDE84VlyjQjqs0ckYFsLXMRNAHUO0KTrXVZ5HQRKak0GFLUESKvtyb+DV6dYdKbXOgTVPyIbfghlQHcQtOYcdDrZoJMVvJ4eyyJyq5N4wm3f3mTDLTlfJGUCsn9bkniQgOgeqwsOkEg1Xfqr8saBtcyTsCp4iNFikwGWyeau67ORVSUtCkeObuvIfxtFrIHTS1NFU50hrtnOt8qQxRPfS0Xr3qg/f2KLFjDalogMrFlLhLgEC+vICMcFyIFiW4ajGI4JsDFU56PK5C2Jke4Rau/An6/lAj/g0kYrJMuWjx5vW6SdZHi9NqUt0fg6MJiJqcgB4ez3hDmmG73/65xhK9OVCc2WYkd3EaH39VfltplNPdDg9dZ1XLFGucSWTLb+GAI3roGyYXSSIwHa/4t1xRkrDrfByCTTGbQNKJ4qSnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026, Yan Zhao wrote:
> On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
> > On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
> > > On Mon, Jun 22, 2026, Yan Zhao wrote:
> > > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > > index ffe9d0db58c59..56d10333c61a7 100644
> > > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > > > >  		return -EIO;
> > > > >  
> > > > > -	if (!src_page)
> > > > > -		return -EOPNOTSUPP;
> > > > > +	if (!src_page) {
> > > > > +		if (!gmem_in_place_conversion)
> > > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
> > > > without the MMAP flag, the absence of src_page should still be treated as an
> > > > error.
> > > 
> > > Why MMAP?
> > Hmm, I was showing a scenario that in-place conversion couldn't occur.
> > I didn't mean that with the MMAP flag, mmap() and user write must occur.
> > 
> > > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
> > > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
> > > and written memory.  And when write() lands, MMAP wouldn't be necessary to
> > > initialize the memory.
> > Do you mean using up-to-date flag as below?

Yes?  I didn't actually look at the implementation details.

> > if (!src_page) {
> > 	src_page = pfn_to_page(pfn);
> > 	if (!folio_test_uptodate(page_folio(src_page)))
> > 		return -EOPNOTSUPP;
> > }
> 
> Another concern with this fix is that:
> commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
> folio uptodate before reaching post_populate().
> 
> [1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/
> 
> > One concern is that TDX now does not much care about the up-to-date flag since
> > TDX doesn't rely on the flag to clear pages on conversions.
> > I'm not sure if the flag can be reliably checked in this case. e.g.,
> > now the whole folio is marked up-to-date even if only part of it is faulted by
> > user access.
> > Ensuring that the up-to-date flag works correctly with huge page support seems
> > to have more effort than introducing a dedicated flag for TDX.
> > 
> > > > Additionally, to properly enable in-place copying for the TDX initial memory
> > > > region, userspace must not only specify source_addr to NULL, but also follow
> > > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
> > > > 1. create guest_memfd with MMAP flag
> > > > 2. mmap the guest_memfd.
> > > > 3. convert the initial memory range to shared.
> > > > 4. copy initial content to the source page.
> > > > 5. convert the initial memory range to private
> > > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
> > > > 7. do not unmap the source backend.
> > > > 
> > > > So, would it be reasonable to introduce a dedicated flag that allows userspace
> > > > to explicitly opt into the in-place copy functionality? e.g.,
> > > 
> > > Why?  It's userspace's responsibility to get the above right.  If userspace fails
> > > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
> > I mean if userspace specifies a NULL source_addr by mistake, it's better for
> > kernel to detect this mistake, similar to how it validates whether source_addr
> > is PAGE_ALIGNED.

The alignment case is different.  If userspace provides an unaligned value, KVM
*can't* do what userspace is asking because hardware and thus KVM only supports
converting on page boundaries.

For a NULL source, KVM can still do what userspace is asking.  Rejecting userspace's
request would then be making assumptions about what userspace wants.

> > Since userspace already needs to perform additional steps to enable in-place
> > copy, specifying a dedicated flag to indicate that the NULL source_addr is
> > intentional seems like a reasonable burden.

I don't see how it adds any value.  I wouldn't be at all surprised if most VMMs
just wen up with code that does:

	if (in-place) {
		src = NULL;
		flags |= KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
	}

