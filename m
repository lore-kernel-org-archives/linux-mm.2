Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1702C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F466B009D; Tue, 11 Aug 2026 11:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530386B009E; Tue, 11 Aug 2026 11:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EDD6B009F; Tue, 11 Aug 2026 11:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1695A6B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:24:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1B7E1A04A5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:24:40 +0000 (UTC)
X-FDA: 85089360720.03.BB9F566
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id BB95B1C0013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:24:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hcicPVVs;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJpznJoS0l7uzYWTFF1MoJR9UykE3LUYDEr5DpChX2M=;
	b=SxGCzYZZO1BIwN0D30dTH1LEabiEjyPEvL4HZVONnjGvPku7llg3U1x7KPzQX2yEtxouUH
	myYwk981wpFA/A487fgurU/aot6xgERXQH0MqxZ8bPytNdBTFC6MmIUXpLXnww3yKrFisT
	PPL4K7fCtvlFbq9E8HtI5WDji4clhKI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hcicPVVs;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461878;
	b=EXR+bRoPVqyefiA5WMm6NHDx7FEKUNpYIYRW3SSFBoY8U2OjexUHOJyAbH3zty48PcO8Ov
	boAJxQV9kI4Iff3GZ0szb+7gUEbSSR1OceQhPgTY0BgyKRiWBTQm9r2yVTrE0VFCqQnu22
	HZ7JXJpr6kH5RZJ3nltA3mrASOerUEM=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9349ad9c857so5089885a.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786461878; x=1787066678; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GJpznJoS0l7uzYWTFF1MoJR9UykE3LUYDEr5DpChX2M=;
        b=hcicPVVslB8FzCCFJgatr70g8xp0gYEMsmJV3QOzqW9rhTmj1oXCgUYF18pjY9IftT
         v52MA4eUQUmoxsULfgF6OUPdL8gCOV5dRWrK5utoSVzTFYWxbqyqa2NtshcGbAXybFly
         6xH1QKBBLC9ylAK+suDQCFHjmt0pJHbi/8ASa/4V77ZkbbtK8/pGqk1JIVQQKN1yoxRx
         pfi7x6aoQj91FB0sWhJZyo5MMiEInzj3KlxgEIOO4rUQXdYh/yUSW4ihza+HtAyyiecT
         U55G3Kc2SC8MnCgUGTZhtIPT+/IsqT3T8GdWyBBfB/RoD4GwTSPN/jLWbWuEZQ2/Ee0X
         bU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786461878; x=1787066678;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GJpznJoS0l7uzYWTFF1MoJR9UykE3LUYDEr5DpChX2M=;
        b=oHuQTHoOu0y7uyBGS3UrbBbkPf1G1HpyyH1toj6BfWgUNmxOE/KPpgsl7mME40t2It
         4sLfqbqBiKif3XnHxhUh1zlll15uF2G00+DmmeCJ7nuDNj4i4g44ruFUkr/yeJJ1qeG0
         C1AA8r5tduc6M7VOk4UqPc6gQxJ6T8mY5bApWeFszk8WEH5+4L2+Tn02RvzYM7j4DNsg
         GKfcfzZZT6T3zTicgj4MCgevq0v/EYbf3On9O2bjRZq1irb99qm4EjhWb98lJwa4bcKW
         w4Ys0xDtqkldOyXPYs5CQ7puilPioqF3AI0rmcSynk2AN2xBq+zAJH+At61cpk7AlFcp
         IRvg==
X-Forwarded-Encrypted: i=1; AHgh+RrZj7U82POEm5CL0M3KWIcEpBEkUFJ5iqEuGH3soHRD+KjCyWznipQMu8HHdohJgW7B9acw73PZ3w==@kvack.org
X-Gm-Message-State: AOJu0Yz1KwY30Dhk/kMx2PxpYkGMWuz7zX20TFk+PqeyGzD0mUEhZqu8
	ynQlsnjzDUYfqmghDfmSVUM/8H/46uNxSDOzmOcci6Cny9CQkN9LlLdhD3ZkzRPIXxU=
X-Gm-Gg: AR+sD12Wbm9rMBmYEaZdkwQek5105dGq8kYg/HvttviVQWkGHG1iIg4/yAW9GdE32+O
	RvTnkYREDu66jsi1LgMNwrN8VImogZNoSu6fuyqmHAghm85IZdSHTHBiNkK1pkJe0+TLmV+HZNG
	8Xx5tbP5TpR7suAgnV1BlL+poi2p7HinPTWfnQjxTaWPCuv178R6pUsdXqAqwowFh9iJou4rbI5
	HEhcZK0n67qtadCy7N7zQnitBHSp5nMuvHsZYuvrE3+F6Ol17q961FKyNJrFK/uj9Z7kCzLA7zD
	rt5trHPq3lVDIqBG9e+82gRa8p87S5tREsaNGOi1XpCYrMi50WBk6uJp+dflsBBaFuWVSgPuYga
	0eew4V/b7sZv00FXEmDo/Ufhw028x8zRkclgTzc0MebS4ZuTo1a6USNILEi38FezFFHxdg+hK66
	QXyKRXKJX6GPeTsRnlagqJTaQtHHQXF9LlJYBGmA==
X-Received: by 2002:a05:620a:c50:b0:936:48f2:b04f with SMTP id af79cd13be357-936a8e5f5ecmr330842085a.6.1786461877528;
        Tue, 11 Aug 2026 08:24:37 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936a8472ed4sm132935485a.9.2026.08.11.08.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:24:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtoLD-00000002WyE-1V0l;
	Tue, 11 Aug 2026 12:24:35 -0300
Date: Tue, 11 Aug 2026 12:24:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811152435.GH544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <15a7bd252a9aaeefe393f5609ec383ce2c61694a.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15a7bd252a9aaeefe393f5609ec383ce2c61694a.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB95B1C0013
X-Stat-Signature: sj57ph19e1gwnso8gaxmihfcy5fwjys8
X-HE-Tag: 1786461878-423129
X-HE-Meta: U2FsdGVkX1+I/UeBuz/0VQXYuRm5eyYv+etYYNBHvcUzotT2Lh7bHOPVCLdL+QR9WB6L79KMsqlexPkAv1NWKdlJgV8b9UdeknxdFsqF42TMxrF5Mko8qjFAGLKzZrkHghxlE4oqxOy4LodG5JKxBWhPwoHa8ysB6xtZ7fis/Cp5FUH7bbcjw5jxG3IDltYy7H7lY3TE3KH83lTeaXJgRfm78NpaV+CbwDAk+DcfnxS67iDMRrKHDzSZuMkRVKX1UK+LPgUrhoW+pXWNRuDcFZ0fC+ZZLVT+xBhLQPp7SaRLMR1yjjxeZZva22eEzTgZqYIY4ikLZezX+YgBiu4dAJTuqvHR3Ms+s+Z1SrSUTyfBbBfpBh3ZQh7m3wIq0Zjqc8YTlPGffgayyNKwXpPS3zA1j2JHPBSL8GJFMRSX1b0BkEJdUK8EOUP8QdO9C7rUhbJLdBePt7rdMQ+YwXdSL9RDNkwSlQZFdEYNgM5+aPPHA6JdG8rPq0gOMlsnQMOlHorr1CcPswLkhmlrPnSPYWB34q4jExVForaD93wMs1gXRe5hq+7ehnsB5fK1ieLwoIsFwstqWKbF2AQXvjooIubZNcKvscsVJqrdyBG4oqNiv0Aby33SArLic//ZruSG/h+sHLuUOWYgh0Fh8psJzo+8kCKcF85sx3F+97WsLeOC3Egq7JrL5nyVdSFvfTgt6+zrSvcRzaYz6QKc6+jwEmn3SoxXnosPte2pkQZX8svxAME4wfZJ1ExLD8578IbiCUO2G0gph05RR7xYoRkIAwWu/9ckqiMbQmtbYlcWYYPoIZvwoCw9U40Lxpmk5EPMXy7DFBYWuKYeJjcBzkp92s+wvOatrWhweSrKGhxu/hcitViJkLzt9gib2YsaHJoiKOL8R4EAk9vb2FSKFVQCEtZ6ixFwbfEq7rn1TpbjtenTL1dDyxHLevHRGQCiTRsHXccwvWlny/4sv40Aeuv
 4k1PdJEE
 2+XPzXlu5jl04zqqgzXVbAHbmh0mvTNWrMZolkwSW/TxI7NPQurzRs7MP831abS2nGoM9WwE5HuXqw+7sgR8ua95uAtNromkJvEZRDqAg62aFwMDyf6HS3nqlPCwnKEEI0sf0TySf2e+sItwd7S4PNqeP0ECv+sfK1aU1SQ4AwnLuy2sjFZooisV06+KUWLS2eqQt+VBrWXNXNvwyzgPr1TePCuXfN4/Y9bfDX3hfx1ksRjseeFygKRQPWNeimwByPf2XSHYDW/k3ZrigWhPLkF1uallMd/Is0IQPo60IG8z75sBJufyxiVQ80Fws3P24cnSQ4zSy4IoIPSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 04:15:36PM +0100, David Woodhouse wrote:
> On Tue, 2026-08-11 at 11:27 -0300, Jason Gunthorpe wrote:
> > 
> > The unstated secondary purprose of the atomic context is to force the
> > driver implementors to make sane choices that don't degrade the MM
> > spectacularly.
> 
> You realise it only does this is in the OOM handler context when the
> normal death of the process takes too long, and I literally had to hack
> the kernel to even get the splat to trigger in the first place, right?
> 
> I don't think it's keeping your driver authors honest... :)

It is documented to be like this, even if it is hard to test..

Even for normal blocking notifiers you should not be using
synchronize_rcu().

Jason

