Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F81C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9F76B008C; Wed, 23 Sep 2026 05:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A916B0096; Wed, 23 Sep 2026 05:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F916B0098; Wed, 23 Sep 2026 05:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0C726B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:19:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EC8EA679E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:19:52 +0000 (UTC)
X-FDA: 85244479824.12.5038F61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66F824000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:19:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i935KHZ0;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790155190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szozd7BSlCRG6SBcZcvnaC59iOuE2gZVQMEdYxaAPfg=;
	b=L7KVhaOKu0cEWr+rR2vOU9vBEuZgjYOb6DvMw++N8EgNw17LyQ4q1ZSit1oZa3/bZKK9TX
	vHMvA+DxNjp5uEnEVisVTwsvFvyxknXfzXGjHcOgifmWVSX3YFTiTM6qFMNAFaaG47bvV7
	+iZdPjR3rtJuJ8C+2Um8hQMvHYldx+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790155190;
	b=Vk6AYeeUmF8+wJ8shfSVaiyl8vD8dTo0puTCWX3KeeuTqLb9th+KosONB8ffRUvNLyD5Xf
	ddEdTG8m9i/zSXTUujC2m55Mw67FB4JtsEMNAxAjs6r3dbcK3QDskfFlD44RjVZmLrqsow
	pc90MaxPQNeIyHyWxVBHlVP95mBYBdE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i935KHZ0;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A71EC41B34;
	Wed, 23 Sep 2026 09:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465CD1F000FF;
	Wed, 23 Sep 2026 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790155189;
	bh=szozd7BSlCRG6SBcZcvnaC59iOuE2gZVQMEdYxaAPfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i935KHZ03UQCOH4iIXqvpXzISRCnQkyg/7sekoDfNzFScbwNm9ckk0hABoKJ4MivO
	 4PVX5vSdjD8HGmskfgBtcNDkI8qvRU8v5/w3PkwoUvgmZ17uCo75xWaxQaK9Mleuhh
	 78BPW4fvbSD9Fzat6DcWvAb4K7OFR3z+TnYuIFxAI7BLwiiLTnLA+fvF/Xxogg9kWu
	 ojjUK6uDDp1zJyv/DcHgGv0bvoIqwp9lKyFkmCn8PCT4za8eUYdsIcaxYcgADguYMm
	 F6cIZ8f+dI4Uyue/PLV1oc1e2KAMFSYI+UoZCHFacoLvBgH9vLGXzpBDyqachCkMFz
	 wvxTQ0rPS6eag==
Date: Wed, 23 Sep 2026 12:19:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Marco Elver <elver@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Bill Wendling <morbo@google.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Justin Stitt <justinstitt@google.com>,
	KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
	Alexander Potapenko <glider@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, llvm@lists.linux.dev,
	Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: csky ICe (was: Re: [PATCH v4 2/3] slab: improve
 KMALLOC_PARTITION_RANDOM randomness)
Message-ID: <arOZpqat_rT6rExk@kernel.org>
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
 <6106aefa-47c7-4bda-a51f-8a2fba3bf715@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6106aefa-47c7-4bda-a51f-8a2fba3bf715@roeck-us.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66F824000C
X-Stat-Signature: n9hfwon18bzrmtdbx7db875z8nn1cjyd
X-Rspam-User: 
X-HE-Tag: 1790155190-375050
X-HE-Meta: U2FsdGVkX1/URk/Fv9bEHNxj9535EIq9catacAVO2ter5m41nnHjwgFCFfHN0EkzHl0YeqDsyKZpg5K8n7VXSUlm2ltKefQ1sBWLE97nEsrdsoQX38tqf5l90U+APOYahc+7cHMjzH9m3HfeznE0alujQ+GNuTbhRFEgNb/bJkwpoiDWorVL3uedSXkm8R+urtLfzT0EHl5FpLZcv4Q676ps7hvbW4kDLbgrPLZNrDsehIEEnEZmNh51zdBkuy1Q0nZEHMdig/c9cuyiaCIUctdjsD5ySwHd7b5eBBwCOOaqiBTW2IEgSn5lMgz8b5qAjC3ERN9zrhBDTrlJR5uQyVAoI9+j82iB9GuiN52/7xfRf/R1XQ0r1CXViiMvG+BinrgoFt1tezim1Dc+sMqJMQs4AkPTp0mj0LmbPA3WYAzD+4KimmisAjFh3SdHhI0lu6wMs3NhA9q9aLE44Cr4sEiEfwU2nD0um1bLRr+5dZ+L3nrVFeYS2LKsD3ko10vPYBFeZ1UwCiMEB/Kt5LnZeMqDN4/v92/w1+5hHIsURH7fKdX+eJS3oEZzjEdGSH7BxMG8Itk0bfTpMoQpt4WWrlj0Qg511h2Yy6qhfYCQbLyq+DTMato4HLNASHxTEvxTFdyI/Jp7XGnXXX/vfq4skBHzLtgzjJnIVFP7tn5wCWBmoW6ZTCZL6e/xQEV7TvIgYlDfnsMbLuTjdI9aJjLTgrQ7R9UWmsPxxJkBG+AvTdge3fwcVfHWaoK54rzRZfa79oTL2W8u/bb9sTNdaj6e4bk9i04GsSjKzhhjFi1a1UyG5mNT0R0PgtL5T7vSoaBHzjG6g1hQtkv5B94H6gqCuU+cgNn9LUlp9S4l7UfSj9KOEWAM6rdOtxrbmmAKgVE3a0/65H2m0E+9IOqcglydsGXUNHZ8fyQlzBL/Q08ujWrJlH2JO5HAtzJlTiSzS4mxlHnR4pRC2Exs5I0iR8J
 SCXq8+4y
 KSH4IncGXxK8dDX427NCgT1xITbCWzRsy08E3SKhKInZISXT4ceb/jIQdIIb8EisbtJdXUuDdDpjaE/WQ0v4qHoOxTuntt4xH2ixQ7zSoIFAOSUz56zV/Swuf9xz+yxLVa8YHzQEpQJCMOEHQo514ZyvKMpn94emCmP18eci3/mzErpCI8T4+QqDVrPxTu1ivfILn6xm2tEjkivMTD/xbbkFabE8/XAxjKGuLSTZJnCeFHz0nUbvI/j+PBTtOg+O95ORuDAwu7Glm2kIVT6JMtZqCn2IlhovXISgCuPnj7Mw+uq58MlfCQD0x1RtdASUyTUXSiSTf0E7HxrpYFaBewNaAawkiXjRvSqJOSa8+65xBx3552TI3GGzUKIpw7QpLq+AlydGl0z5JxAyNtcqkEaZteMKIxOLN010N6pJap4hiHW2ROvJy4mYxNohFD9IU8UiIWBdTOJkKvhlHcHLQgeq10AJCKBsxb3lH31eQpSF20oE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58:56AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Mon, May 11, 2026 at 10:00:49PM +0200, Marco Elver wrote:
> > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> > to identify the allocation site. _RET_IP_, however, evaluates to the
> > caller's parent's instruction pointer rather than the actual allocation
> > site; this would lead to collisions where a function performs multiple
> > allocations.
> > 
> > With the generalization to kmalloc_token_t, we now generate the token at
> > the outermost macro, and using _THIS_IP_ would fix this for all cases.
> > 
> > Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> > the address of a local label, which is considered broken by both GCC [1]
> > and Clang [2] because label addresses are only expected to be used with
> > computed gotos. While the generic version more or less works today, it
> > is known to be brittle. For example, Clang -O2 always returns 1 when
> > this function is inlined:
> > 
> >         static inline unsigned long get_ip(void)
> >         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> > 
> > To provide a reliable unique identifier without breaking architectures
> > relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> > to _THIS_IP_ where architectures provide a safe implementation, and
> > falls back to a zero-cost static marker where _THIS_IP_ is broken.
> > 
> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> > Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> > Signed-off-by: Marco Elver <elver@google.com>
> 
> With this patch in the tree, I get ICE erors when trying to build
> csky:allmodconfig.
> 
> Example:
> 
> Error log:
> sound/core/oss/mixer_oss.c: In function 'snd_mixer_oss_proc_write':
> sound/core/oss/mixer_oss.c:1202:1: error: could not split insn
>  1202 | }
>       | ^
> (insn 183 400 184 (set (reg:SI 0 a0 [orig:307 _55 ] [307])
>         (xor:SI (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
>             (const:SI (plus:SI (symbol_ref:SI ("*.LANCHOR0") [flags 0x182])
>                     (const_int 132 [0x84]))))) "include/linux/slab.h":759:52 288 {cskyv2_xorsi3}
>      (expr_list:REG_DEAD (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
>         (nil)))
> during RTL pass: final
> sound/core/oss/mixer_oss.c:1202:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
> 0x779b51e2a1c9 __libc_start_call_main
> 	../sysdeps/nptl/libc_start_call_main.h:58
> 0x779b51e2a28a __libc_start_main_impl
> 	../csu/libc-start.c:360
> 
> This happens with lots of files, not just this one. It is seen with all
> versions of gcc starting with at least v13.x. Reverting this patch fixes
> the problem. Bisect log is attached for reference.
> 
> Any idea what I could do to avoid the problem other than stopping to build
> csky:allmodconfig ?

Maybe it's time to say goodbye to csky? ;-)
 
> Thanks,
> Guenter

-- 
Sincerely yours,
Mike.

