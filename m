Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE0D9C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6B26B010B; Wed, 12 Aug 2026 08:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE6D6B01F8; Wed, 12 Aug 2026 08:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5286B01FA; Wed, 12 Aug 2026 08:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86DBC6B010B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:28:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DB3E1C07B3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:28:04 +0000 (UTC)
X-FDA: 85092544488.01.4689E96
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40FCE40007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:28:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=eObmBaGL;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO3QhHY842VdcusB6Ch/Vqg2F2nPYU3R/4exE5xwEVo=;
	b=ONgyGfVGl1H+Ch1iVK6Z4X0dti65J8BKKjCQuuiTHVNg5kv+NNJHhYzTSPN+ExiTw3FVZu
	uOV0iLBiPJVNMVFmAkldz9p6Tgpz23ySl+x8+o7B0nnvZX8FxEQitg+SiJmSclQc9lUQia
	vC6guVl4Yk2Io+BdQ2g2UngUo7CRQr0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=eObmBaGL;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537682;
	b=7uGP0ynDRTUp/VVmWFR8Qgqfqq4F2hwBGyZNMPLyRtCkk9wE9o2fY3cfiQvjydLSP8SJdr
	G18DEIJugqbHcz17jnAoX0eYv3Mlxfx5YG3YCFGCTXwY3dZGTUZDtrl9krObYYxvMrJ9qv
	47qlXjU7Lzjf4K2SwOzQ55MNPQQDYIw=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5218927884fso9093041cf.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786537681; x=1787142481; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nO3QhHY842VdcusB6Ch/Vqg2F2nPYU3R/4exE5xwEVo=;
        b=eObmBaGLdrZxk8UIWjQkezHBihEq36rYx2WLMf4ZEnr2kyMSMYD41jnofAmAAg5YIV
         pwzQitUMnfvMyb5BRcjVuAD/19LGEFlS2+/ZcMJE/omos75ffBi8i3DV0rA3z9b3JgQi
         cXAGvTTqUDkIxsgYjXQdIBqNp7HuHQDrkmYwunoOR7RExrRvQe0of0Rtj4Wjc2s59JYK
         GA5nP7POxQWTEL2CMW7Fs7DXDTt9mesRugJJ+KGHhVb5XZmvlPHUtE9ngqmB8/UD48fl
         vzg5+ZzbWAPKgms0hkPpolBBNJZT1U4+XQ6xkrymRSXRbeM1g4rvoP8p5U6YuKFYqogx
         ivwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786537681; x=1787142481;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nO3QhHY842VdcusB6Ch/Vqg2F2nPYU3R/4exE5xwEVo=;
        b=E2C5OUMwHl5sUEQsgRhqEfc3BCDNkcIek+HZrpQPu892dxu6a7/wR2pXaHKPIPJJi0
         mpMrHtwyYrEsP1PdDIPPjSFsa5CsFo5c4+ZwAO4x9n6ui9D/fYvYjejeCjy0MEz1nhB7
         NUbXd984n1K19moAVzzyY+8y74HVF1O01Ay/j6lAUdKPWgwLBMG6NUSAZmnWecqgpqJG
         XipMyib7ah+whz66DGY4zFPkxVwNZcz012O7ZvjJs4Kg1OnbOHk1NEx4rNj8ve2hvpnt
         5WaatmABgU0STRe71MXP4FVpQYoDkprQxIBBR2gny48VD2HIlSNoy9e7WGheXQaIi9Vf
         HzPA==
X-Forwarded-Encrypted: i=1; AHgh+Rp1a43ek2Ny3K+dwZ8idIchNahSKFdb96P8T6GLPXntFOrXkMp6v4NgiR2ROU1jKapdEOsNSNUCpQ==@kvack.org
X-Gm-Message-State: AOJu0YwjXrLo4iOyeCWR8M4W6QTBp/a4PbKO0RsKf7YXLPZaPk32KLOB
	Q1vIIGrE/eWnGHCBavj0npk6Ypd+Kae3CIfeWnNKAep1uIxzDT2+w5B5j05xd2ZmCeA=
X-Gm-Gg: AR+sD13ElgroIYbrdHkInnRBn++5GWco4SrKLx1W3C83AhIdr+fr5Np88kbKTiRpbaM
	aHnaicCxwYsr38C/jQn/SNp2RJd2g02o+Naz9jSWfNjOEyakfiZQwTSInxHK5TG2D7SuE6v2r6D
	9Hf46vxBal7NCbxwX+U+JOOipE30DFTveuCye7ASpDzrrfxxBFzQ/4MDHJ9qNiwGEttOtIH/j2v
	cP3NMsghgMnP0WRdr3f6uR0vvBEZ3b3gaXW7VNlnMsgxOiOwqFirmTXBmZDzFCG//pwQzXJ+WzC
	WIcjVIt17wUg+jB7MXlmwmSJsleKSNh05EWGzAMd5jEEI+jzc8b56Ly1z+QqPPDGcoz9a5Unq+J
	n2v2E7kf4G5pFLvaabddce5ov4Dstn6TkEeynqW06DSe3nG92oOENQ934OEOBkF2qNfa0Holsgi
	qM3FUPU2PMaERrPg3+sgrPMcGJ5aWdEWZMMdltB8h50WGIOLFh
X-Received: by 2002:a05:622a:2596:b0:517:7188:c47a with SMTP id d75a77b69052e-52d646b8da0mr38269131cf.2.1786537681291;
        Wed, 12 Aug 2026 05:28:01 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c29e942sm20435386d6.12.2026.08.12.05.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:28:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wu83r-000000030Kg-2xlk;
	Wed, 12 Aug 2026 09:27:59 -0300
Date: Wed, 12 Aug 2026 09:27:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260812122759.GA662699@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home>
 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka>
 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 40FCE40007
X-Rspamd-Server: rspam07
X-Stat-Signature: wyixgcgo9hahmboq95gq74nmtp9bozoa
X-HE-Tag: 1786537682-995608
X-HE-Meta: U2FsdGVkX197/uDFpU5DmIRPITT7V4Ph+tM/9FsFQmRMBz2LWIL8FvBOWFN0n8E2Pj5o+pUnNZKJGmIZoATcPra8eEcI/eBwGZDx3HZ8SgrZR6Xe+TiwfkJ6RMkpsc74XUisOORoIirDVyBXFQ6/+wpFgu+zG4UQ3nfPafv2mnb5Fetwu3bb85nZWJcmilz1aZhWa/vMNFJkS1ISuLMYtGngO0vzxjhswBVedDk/Gl7ejjzFMs/wCvguvjU6GFPROz3QQxhXEwdKFnhBgktXfVlOzxdMEBkKxa8NTtw53EOOUPFXi/dpUI9p5yTOZhVy42GgFHa9no+cUjn6VwmxVyYlK6U7QRGYaP8QzCFuc2SfctYwKRZmIc6Fdy6XslkMEN5GsODHnrBL+ySve0RmiEDEQkSu2sLLcPpz3SY8EPo5DVDFd5QRVl/gg1pQIYyKaTaAwZEv+EaNCtiYQVpWxYbBsKdbr6gadkVHMcA9VxLfW24OwnVKD2tGqW+7IcOTrsf6KUi5EYakmWGqwl6zONJaL22XoBs2bnT8rmmp3x9CeXUpNQ5UTiByodi1fsT4uv05/ZOmBFGyAHh5TNQIZg0E1EAwr0DYTJgqi7NV/1F8Wb/lnntLdOb6C/VGbDCvL1/UePZeGq7r0V+UyesLqy6CJA3+ejdQRg1GKh8sCK9y//cdndQ4TNmcOIR4fPRssix79GWwScLogHxZC80qHkALfKtrXCQTvfyRP/Y9Iq7njiJn8+oLSzt9fqmRcnTeWJbYKoTwLsVRW888TnGtY8xVbnaR3vJIZPSurNgLAVuDdHGEQlq/dZk+A8TPAnd52kah4yfd6uk1SXLL4L5+UK/omGocjywuCnXk5hjlcIDztj/nnI63txVfUQZ4LJPNPUjjuoXKhrS43hpUmfzqrjJwwuynZgYOA9TyZVT5CgyiX2dJYEt+QB46kw70+Zzvr5mCVK+e1TG7MIQ7uc9
 VEkd53ZN
 wfWib6nRDjSM0e0Kf2flS4ZyO+DUTkEIK2PRfN0rYJvDBxHPIy16Cx+aftZFBC9i8D5km0VzJXuuDh27srfU+l95YPC8DZXXCn9lb75bx7793Ld1DLe6PYysSQCpDcFTaSgfM+R1qQzJyM0S5tN8B5sQYYfPaLHIWRCQOpsvfOh185E+r8cKKw8/XNDDY9NoXehzuXLCadGiFnagdIOg6Vmg6W60poy16NQUW7UFG+X42Bwf7MVhYnuDHDllQEKa0+BPj5dSWwbQxASx9wRhDkaAPfkclHgrk2D4FhCNo1m2BcIkELt+gVVYx7oJ/ak7O+hXNv4F137MbaB/qLCM0I6cltlY76k7Yt/tMftRzYG4DS8yoSKpQf6939BZLVlDYM+KsLw69QiPg38D2QfFfQd/6AicCuFiQkD+2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 09:21:31AM +0100, David Woodhouse wrote:
> On Wed, 2026-08-12 at 10:14 +0200, Michal Hocko wrote:
> > On Tue 11-08-26 16:24:48, David Woodhouse wrote:
> > [...]
> > > I had a second reason for disabling the overzealous check too: to allow
> > > SRCU grace periods within the notifier callbacks.
> > 
> > Is there a way that srcu barrier could cause an indirect dependency on
> > memory allocation? In other words what might block the scru to complete?
> 
> Not after https://lore.kernel.org/all/6eed3fe3461e9690b486ca98fa7563f60d3940ff.camel@infradead.org/

The user of the SRCU might have a read side that wraps an allocate. In
general it is not safe.

I'm skeptical that without special API and documentation the KVM
special use of SRCU you've outlined will not remain working long term
too..

Jason

