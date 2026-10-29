Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E1560A3803
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M3HmIYHz
Received: by kanga.kvack.org (Postfix)
	id F0B1C6B05B4; Thu, 29 Oct 2026 09:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB3D6B05B5; Thu, 29 Oct 2026 09:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1666B05B6; Thu, 29 Oct 2026 09:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB1616B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:53:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C137A7DE0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:53:48 +0000 (UTC)
X-FDA: 85375806936.27.789510C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A99040004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:53:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3HmIYHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793282026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gdoc5Am/YBseDTfgXtnisv+FjHXqKxuoLVpJqBPFPlY=;
	b=KmEeZJVfyOC6P45E1b6G5hK2C17EgUxcK7OB1O3IHCt6GTAmrT7wyp7UnJ/S8s/DNjILF8
	ao/BlBEO4cDURW1wpT+dOJz8iIz3Go0RVlHNXjhD1ysbeYuxttuwJ0Xt7S67J8bJyyBlzP
	ViSDABWOdrnU6pON2/XvRIhCk6lnDRE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3HmIYHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793282026;
	b=e9LuCeTMREuPPVcLKNu1R8++TklCG6Is993vLm6qQtF3ieIWPwaiWDQBRln6m4g9kdVvrF
	pHHABUqTlvL1Rt+/hqfBhM3ddBiGAdpqtUaZhT4MZtXWlz2xELHnYfe5BwyRMGRv54Kktr
	LAivXJYr8paKpRvrls+f+uDfB6Lc9zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA53419EF;
	Thu, 29 Oct 2026 13:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C0F1F01289;
	Thu, 29 Oct 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282024;
	bh=Gdoc5Am/YBseDTfgXtnisv+FjHXqKxuoLVpJqBPFPlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M3HmIYHzgzrq+TvNMzkOQTAXJE8pF0/vOG4TWaWU6vznIeQRSriDYGhVgG0Ld/gzs
	 72Tp0PQptXez1UqZd9OIbFk3upGQQiu0keBCw1F97l/Ip11nlzeBfnTZgqZ9iMupr4
	 XAqQ8Xa13nDepTBqVlIppdsYVL7zMuf1sPVSBX9hyAQzLaU0IVLAyYmSBafKAqYoEj
	 myQdEZEuQs0hoF/5y3r7l/NnPw4hYji9CZdtnmfpMDPJhH2TrKGV6NZgQqjN9ZMK/K
	 scCfEkkWjPDgjMFczUajKWefVIrs1Rcb6S9ZCsDA4Qy1r/gtx6iBfDsBsEKT3MrLzr
	 oFswdeO4Mpviw==
Date: Thu, 29 Oct 2026 13:53:42 +0000
From: Harry Yoo <harry@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] mm/kasan/kunit: Add double-free tests involving
 kfree_rcu_sheaf().
Message-ID: <auNNesYcV9gIdfBG@thinkstation>
References: <20261028194014.3671161-1-kuniyu@google.com>
 <20261028194014.3671161-3-kuniyu@google.com>
 <20261028214628.aaaa47c78c5b1257d399257c@linux-foundation.org>
 <CAAVpQUCphsL1zUaFL8ryHETRZsRg6iLUUc2onrMd4nK5uP9XjA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUCphsL1zUaFL8ryHETRZsRg6iLUUc2onrMd4nK5uP9XjA@mail.gmail.com>
X-Rspamd-Queue-Id: 9A99040004
X-Stat-Signature: e8d85o8u9gfpyhj3admg6yyt5duf6y3m
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793282026-804286
X-HE-Meta: U2FsdGVkX19gMMHsEUdej9poKLbXrXXAN6snSSOTLl7q00ZTnoNk9rmIAvIfkLO8DbW5vg1A8t/r/gbdKtdhd+RY17AsPxSWA/DD6O9HUJxE+RUVRZvQt6QMFvXdEMfUtnWBKCQyY5Zu1FxlVTHS7ftkk6uzeKkm+KWsXZQp+gdLUVrfy6VTiib8FvtfEiKB+9gxxe7+DdS93m3rAzbiIFaYBA4adR+ZEO20dp+OfErSQg1vGr7AV8jYb2ird4DxSc00ONGGaVd6eX+/H3bfIhz73aqempiV5jFwrvCdXGT9ZSmCEvOXZZ/PYh/PgQviISKHaRGM9w/LdKqakTPuoWgKwZMZfHBrP++T8Dv9o8gzGVBAiRgwTMGFze9Io3k8cLsJhcr9TZFzo9qxnYoBOOdFsayHLufDPI97D+ezOh1BIOp/HYOuBX7fcoy4EaumZBOOLRWa5yXHDRA5FEEQLOS9/mpihds/jpfMpZHKbOucWWAKly7nyWnogSbYmN0qifv23/x+lyNbFLxjir3qHb0nq4o0ElYJ2vtRm8hEfjt2spzXWcpUBkRrT7H+IkguCSOjlw0v2fmusorF7LpFzO7j8HX3sgwAeQdBVhCmmZ1d1CPTVx0ghHemd///M5pk1aesrBkdDAOCqNld3aR0s+91lMMZs38h7dqYZCV73kieenDY5gPQAjI+YCZhHs2QPvHskF5rvSazSlWyhLP+Q1pOFuys+1nBBfStn3jrRfyOpn2+kbcUyTeuEzuUQ5nP2GrPp1CTQyaoxXBQXtVTJ+xWr9cdTlpZ7zfh1qbPZ+8c12+wscSXBApFUdDMnJoNgxujD0lkJLJej2gkj8dK6cfRYjy0CRfXWelLRRZSxzuf5l3prI2SE+o5hUu9XJFHAKOKtwlysNp2LAb/b2yfEcL0Smvyo7Pfw+FonMBCo354qwa58oQtNUCE/bbRdySRW7qgfNNsdzJJt/gQNYI
 1AZ9h1mI
 94NGTftAdf/QTSg9VtbiIlm/mGPrU+3fqzjKpPX1R4d226W9ZZs++jtfT68nReukqMx66pUAU01pXEVEntqDb2l6A7oc5UAQQnFsQpgfkYKn3mCaYXrLjJ2Ya4Wy/YokyKG0Lw5ltNaPjFhk/8tlEjIikyQ6FnXMporMTdEsc7fTInyY8eesYxeT4BlgknAEXCzI5yf9aKUuhp06g94UYvirb2VC8S3Fg94VllU9VluxGNhCLzkaeTEWjPKJR3OOIuY9s6454PURnSBymBsf7U5SwO9/P+MZHQ+u8+i5I67gk7I4qxHZ8Pd4+awuQuJgL5uxyZvm5FQgJ8h+x7XytEs/ppLUyL+pJb25Z/dwnPrHRbxUN6uZsbsJBGfod0P/yZ4yOIXoom2/TXijXaO98VGSFWJI35DNL53u89LEPW+/CfT/PNuGFphbvERGy1Lv2kaPeFi8p3WCER/gb6+V6+X5YRVo2B3bt9atFo6frj5Tww0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 09:51:59PM -0700, Kuniyuki Iwashima wrote:
> On Wed, Oct 28, 2026 at 9:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 28 Oct 2026 19:39:20 +0000 Kuniyuki Iwashima <kuniyu@google.com> wrote:
> >
> > > The new test cases verify that KASAN immediately detects all
> > > three combinations of double-free involving kfree_rcu_sheaf():
> > >
> > >   1. kmem_cache_free() -> kfree_rcu()
> > >   2. kfree_rcu()       -> kmem_cache_free()
> > >   3. kfree_rcu()       -> kfree_rcu()
> > >
> > > Each test also evicts the object from the KASAN quarantine and
> > > reallocates it as a victim object before flushing the RCU sheaf
> > > to ensure the live victim object is not poisoned by the rejected
> > > double-free.
> > >
> > > Without the patch, all tests fail to detect the 2nd free, and
> > > the victim is poisoned:
> > >
> > > ...
> > >
> > > With the patch, all tests can detect the 2nd free immediately and
> > > prevent the victim from being poisoned:
> > >
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > > Reviewed-by: Alexander Potapenko <glider@google.com>
> >
> > Thanks.  I believe this should have
> >
> > Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")

Looks correct to me.

> > and that both patches deserve a cc:stable.  Please comfirm.

At least KASAN parts deserve it assuming people use KASAN for testing
and fuzzing.

> I was not sure if a new KUnit test deserved it, but I have no
> strong opinion, and I'm fine with that.

-- 
Cheers,
Harry / Hyeonggon

