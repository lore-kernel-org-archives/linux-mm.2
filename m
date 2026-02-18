Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14CF5E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E506B0088; Wed, 18 Feb 2026 03:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DF16B0089; Wed, 18 Feb 2026 03:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3AC36B008A; Wed, 18 Feb 2026 03:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC1806B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:53:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51D771A0433
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:53:36 +0000 (UTC)
X-FDA: 84456964032.18.3D82064
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id 66D681C0005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:53:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="p/c6MtAi";
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771404814; a=rsa-sha256;
	cv=none;
	b=Vm69C4BqeZYu0nrOMbbs0dDasXMkFmQ35S/L3ujI1SvdeqXhvptt/asfh+y1ZEhm/ntTFp
	ujByInE/dRtWY5DOIBV8dsz/NsmzfAdShy1KQLc/lYvJyE8pzqzQjns+cOeFruId9hkunn
	DRucve2Zk5880w2xADF08awtvvEy1+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="p/c6MtAi";
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771404814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAlZyMlEkwV4M1809AS+1dB0r82ddfEQ5DHlS5PW2RQ=;
	b=gZJBgCPNDt4dgoiZZ17g9pmFvixZPoxingfqFp7x69+Ag2MK+r16LOlnM4KEUbTYnt4xsy
	09I3HZ+pzZIYv+dK26zrRAyRyZVOT8mMJXlvCdChU5DaGsPOAlQKiLXtwjdTuPRzuC4uaF
	1sL6fKjzXOz6ytw5LUfxcOskENkINk8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rAlZyMlEkwV4M1809AS+1dB0r82ddfEQ5DHlS5PW2RQ=; b=p/c6MtAiG/lOf0ICRFINSX12Ky
	KuW2LImUZx28lDB5aVM5gVMN3ugNTPOdisLtuzNUrNqmFreDEk0splkkfaVdUhQ8o6PWVq0rot5YM
	awSIfMcj4suNpbxZ6SLa/1WCeGA1bQrA5EcgU8gSZzMXyaqQgJJk8pgF2jo7ob7EKgBNy83h4VRUk
	hR7+o3S0z6qtnVU2Ikt76dvld60lx0ArsTEZ8GWimHmMivTGyKRHD/Nhmbtq4BzX1Y+hCc104hzNl
	RxDtCNiGE5InWDgrpuAzfJbTNi7AxG4xcuCDEivt5RukrAVuEm7bnutd/XJzQxxZ83E8Wp+FG5AeF
	jF9DuL0A==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsdJI-0000000H6cT-47oi;
	Wed, 18 Feb 2026 08:53:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 79DBE300B40; Wed, 18 Feb 2026 09:53:27 +0100 (CET)
Date: Wed, 18 Feb 2026 09:53:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Will Deacon <will@kernel.org>, Gary Guo <gary@garyguo.net>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260218085327.GC2995752@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aY9i8rbvnxdOA9DV@tardis.local>
 <20260217085541.GS1395266@noisy.programming.kicks-ass.net>
 <102c86dd6fb1a907b7138a437dee00dc@garyguo.net>
 <aZRHJ22UtG1YeBMj@willie-the-truck>
 <aZShEW2b9-71r18I@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZShEW2b9-71r18I@tardis.local>
X-Rspamd-Queue-Id: 66D681C0005
X-Stat-Signature: dp8g7sogx4s8rfb6kkdfwryub66aigkc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771404814-779059
X-HE-Meta: U2FsdGVkX18pKuBFU2AX/HgD9Y+oyXDyIe7km4jCxuJbOA5NvaR6Afns51ucL/u6Ljl+YvyZF+xn2E79TTpQfNGOrAdT1uX5qi7cKOOjEHc/vtjZpzmqzygancBevkngJajREWHtx00FBbva7UH7X1kfOdthB/t90/qLQK4rl9pB7T5XVPBFomdRPgYOFuzgr3p2vbg3tWZHvM68URY0Vho0cZp4m5RGUUnIPSplg4jUrDHtnyWVL8zlEw1ENuLPvqu3UWpqJTHY4ycMhsREAQDSVcTdSfV0ro0mtqOAqGFSnAElrn3s5qwQu6CAJGWSbq0uEmFa4eNPGhBkzgAhvzmM+jzu6+b7uRmBZfUQ1VrdpbGO2pjbF1Ni1I2nBL/wCbM9UrzNoW+1efG/o1oeaaxCT5zlkUctBa9LelUVSRxCvFNhZzyR3MhHDAJKpvN1dDl+/aBj2295/KKh6c6iTIew9BT+YiGNDTHlHyW0SfxDj/9AzXS0iucHEPFfVXnlTCQE9d8K6TeT38mbunxB0SnW10KcdyDvmt6LnMRZ6GmGxJDCWcUdhN3gpSXUDw0A4gsiMCLcNt79rZl0rUG2jJ1NGBZQt+Y0BxNzps+Z9EdaD06r9KDYotn9f6NUtS9lneDO8LeYfZRCugcXHR3rH7KB5YzpCUoYOwEfjtYFrxag4NK7CBfKjTYXBavCUwyuTa8lmYv2uhp5CQATTOzXkVXb/YXIrd3n+cfacVUTFMcY9MCS9QdxUwAS3HkyW8FDSMuZdGPoAMcACG7xj6LetcWodx/kVSUBGSkLHk4PP3WJveKXXBRQRI3Zkyoz0ZMGutSh99zDLl83J3L+XCweA8quOWACPdCzD2agS7L2Ir7IR1EFOxfxZibkpIoDErn4++1LT15n1vsvrUqm431CR412hPdKR76XM9+90u64EKqV00myMpaJLXALA3AwZZWUmpAa/EfXCz6rvzQBc4t
 xoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:10:42AM -0800, Boqun Feng wrote:

> We are worried about two racing memcpy()s end up being data race and
> that's undefined behavior. And "atomic" is the key word in C (and Rust)
> to "lift" normal accesses to non-data-race, for example:

I hate people for calling that atomic. It has nothing to do with
atomics.

> 
> 	thread 1		thread 2
> 	--------		--------
>     	*a = 1;			r1 = *a;
> 
> is data race, and 
> 
> 	thread 1		thread 2
> 	--------		--------
>     	atomic_store(a,1);	r1 = atomic_load(a);
> 
> is not.

At the end of the day, they're both the bloody same thing, no matter
what you call them :-( All this UB nonsense is just compiler people
being silly.

> In memcpy() case, since we don't need the whole copy to be a single
> atomic operation, so as long as the atomicity is guaranteed at byte
> level (larger is fine because 2byte atomic is still byte atomic), it
> should be sufficient as a concurrent-safe memcpy().

But this is every memcpy(), ever :/

> So either we want to live in a world where
> 
> "concurrent normal accesses with at least one being write are data race
> therefore UBs, use the corresponding atomic API in this case and handle
> the data carefully with concurrent accesses in mind".
> 
> or we want to live in a world where
> 
> "concurrent normal accesses with at least one being write are data race
> therefore UBs, but there are 17 and more API which are technically UBs,
> but they are not considered as UBs in kernel, use them"
> 
> To me, having a atomic_bytewise_memcpy() at least clear things out about
> what is actually needed (at the very minimal) to have a concurrent-safe
> memcpy().

I'm still not seeing what it does over any other memcpy(), except you
created one more API, so now we have 18 :-(

> Moving forward, since the concept has been already somehow
> proposed to C/C++, it's likely to be standardized (we can push it from
> the kernel end as well) so we don't need to implement a concurrent-safe
> memcpy() for all architectures on our own.
> 
> Hope this makes some sense ;-)

I'm still not seeing it. All memcpy() implementations are already
meeting the criteria you want. There is nothing to implement. And I
really don't see the point in creating: magical_memcpy() that is
*identical* to every other memcpy() we already have.

AFAICT the only problem here is that from:

  https://lkml.kernel.org/r/20260218083754.GB2995752@noisy.programming.kicks-ass.net



