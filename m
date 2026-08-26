Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACA9C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC9D6B0088; Wed, 26 Aug 2026 12:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E896B008A; Wed, 26 Aug 2026 12:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6286B008C; Wed, 26 Aug 2026 12:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9CCB6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:56:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 618AEA2961
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:56:06 +0000 (UTC)
X-FDA: 85144023132.18.95CB578
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8161518000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:56:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bF8joQd2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787763364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih6zd9IyJdsKNzc7ge7Wk0lTujacAiQcltRsjQh0Wyw=;
	b=s0iGe7l4TEtAQC0+IwVc3Un8qeiCZTEzt/8yumVeSd0SqCBTCIE8B1nwjGW04zi9Dr4M+x
	u9rZgCtAIeoA6+mcbuoBLf+8A6G3FQMI7eQgLH5K4sUct2fqhHd1XhVqSg/RSf2H4mgknl
	KluoZ4tQ3HJhO/ftp9k3NDWr0NKJe90=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bF8joQd2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787763364;
	b=FGbdBrAw0IyBzIBL3UHtlqnc5OlIDbot3k3VCxA8pa9b4jpUNnsauhFGzCP6SwbMPB6voi
	0ReiuZ5SUjNWlx4mGyAt2Sbl2L3tFGK97S65XtNyPcLaycUkZJcuK4+IOduXwCzQm5fHke
	itc5Uoa4Tjj+CzxYOsRrcGatQH2lpTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9C6760AAA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816821F00A3E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787763363;
	bh=ih6zd9IyJdsKNzc7ge7Wk0lTujacAiQcltRsjQh0Wyw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bF8joQd2AJJZatp5d+zQomHPdjojOKjNrJqAj/2efS+Obbro8cmhb50WK76lPgOo0
	 ZcsiJnYOfjsgWMThvTjO00ia7oQi9tQE+WwLH/T+ybTky78qz7CTFM1sorsbUmKWkk
	 zfCpywolVYDFfmnQkuq0Pg6Rh+2wwr0JjCTQbfNSB8NWbzrWYbAwMJKkknz8EOzzK1
	 pU2X4yiRBiXioQmcSGo08c8llUvijYzCiITWPvanMXTYE8RwcMdYlIzO9git3TBvid
	 sQLeTCQgOVfNc59wPfC6ZKLyuZcbV/G3XMMXEqtuIXb4sjgHANdY/nLdedAMN5X4MF
	 w5kmvR8T3Y7ZA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c252e703fa3so94141166b.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:56:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpLeGrcBhB11ISWALPxloxsiGAI/wjqBS375mE3BQnLmHuGQldbBPDcJC6kzom7IkENDPiDefhLDw==@kvack.org
X-Gm-Message-State: AFuF++nEdllYNcVINUg6tgF1ii2AW1V3+3VdpxGygiUNW/wHiInyS0ds
	IqcEjjyPv1QtCbc8axKukbUoo7eX8c2kfV2dkp+1ZvholKqoRn9nwr/LJo411jEyS58aGVxteKn
	0U5mwAblH5QD5iZCjFSIciTMCSf7/HgI=
X-Received: by 2002:a17:907:3d0f:b0:c1f:983f:d8a with SMTP id
 a640c23a62f3a-c250c36b68emr1099051566b.24.1787763362320; Wed, 26 Aug 2026
 09:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
 <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com> <CAJxJ_jgihBLy2mbPAN-uqup2mGq+hurKkH=W4RGo4Ad0Eki5sQ@mail.gmail.com>
In-Reply-To: <CAJxJ_jgihBLy2mbPAN-uqup2mGq+hurKkH=W4RGo4Ad0Eki5sQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 26 Aug 2026 09:55:48 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP6+6jZ7qOxOy1fyd=UgR3yYP20Db9KghW1zJ3bNqoREg@mail.gmail.com>
X-Gm-Features: AcwNN1UNzh0Vl9JsLhx4eDQZm21D0NSeeRSHB0oeT-ciJDNy9lX0jJxCgAbA73g
Message-ID: <CAO9r8zP6+6jZ7qOxOy1fyd=UgR3yYP20Db9KghW1zJ3bNqoREg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jhgbbamaq8bzx54zb8rab9pywoxynh78
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8161518000A
X-Rspam-User: 
X-HE-Tag: 1787763364-985357
X-HE-Meta: U2FsdGVkX18Nj5pVgdqqA4dg2myvUsK+tYC2fSceWW+H50DzIsftjIm2gREdkfhwvfyTXgEL1ym8VwFN2YlMTTr36Ee62G7wPM4OgiPOC7qpRDq5puiEpr6XTcVba+MdYAhcZKgtJviutZAoiX63UzTCx622lYd2IwUD7kmVHEzEfYXV2ghdOah+OBGomFFUIfBd56JWGce8DDJgXkFUSlKV8RXPDsJfFocbFzGoIrXo5Z21U1kitQtT6oghUQtWvyyzi2T9dbGQgnHeQ8iF2a7P6VSXNi6RQ+oxOsUlw4yujyABCN9O1EqmNwWPWcgNLZv0ChMqh79yR88jxUqebbbqppN/V7O8H55Bs6xwR2NvAhzahhJkbUiA1sduf0h5RInMaaP7TC2y+GRhFlFsjbTA0dM2LRW3lGifQeS27LLsJk4AeGvpHXMiWFt4uUAsH6EFAkGx93XfRR/9PI1nkKkTidgBOS2j/PfiVCoFIeUR2tgTgG+EawIg4PeYru8Z2yUCSPzyF8txeZJoljRWzwnmjVQx94OgUCleTwGZVg5/nH0G0gBGQjuFEcjMIltWUCUiNYPXdWl5gB6/vY6xZACqQMVAp+8eUZMcnLEbs6wuELPFGa1fpAfzeymKW1PuEHVFpU8GlGllCRr1pD9UT9/EO62XgtSBQckEZIAoUuridGz9NMVFtbNvNwf3zjYimH93ekXBcMC2E/rZ8ktYP50RC2Cry2yxQOyQ9EDXMBG/A05EtYTUtgg4U/gkAqp0McixYv2s5h24p6dhK1v1gp/Qi+lwVx5x90QV8fDfdfk4rPVVgrDdOPd+NoAfzg1SvKTzimd7kB2C2KBT5J/Qs7fjUoBFPIsddwRzG8EJQN8sMJ4N+Ukf0cstRvwbl/6LZS5Ku3ZbaMGibWyW15vaaoZrsPMPCJlRtKVQz6EiCIN7LxeGn5UJaO2Mfaqx3b2AG2mt/mX74yvsK2ik4Lm
 vQltd0Qv
 Z08hTq5DeGl1A4h72Ev99txYkyn3PhhW4HyvfX6ZmysAMbDODw736go04C8LUdXVFybEQLMWg82WLpiOXltPXPLVgxjk29Bx90mgsIXnRlKyQsf/mAmXEkcA+gZaSz8pU3zZzfT2ejXBgOWfAzb++/u4nvcdqY6pTBUZCvJX4YeMGPuaHDCudr4QOoaYfjx3uuFl9EI2K/9IQ0O0FcSt5u4IilFq3EE7TjmpLwzjV3btbQHEUhRgGFdNzRxg94tiyRpkReBMw3mw8sbPevJjo0yKB4GvfYs+5oo14SeycSTY9UTf1qySSOga03qjtRy5dM02NxJzfV8MYYoPI1lZUCMbkioE8chPFzNuS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 9:08=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> Thanks for the detailed review.
>
> > I think the reservation logic is self-explaining, the comment here is
> > not warranted. Especially the idx part, I believe we only set
> > pool->idx here to keep track of the reserved index, not really to do
> > it before publishing as publishing happens later. If anything, maybe
> > replace this with a smaller comment to the reader that we reserve the
> > slot at pool creation but only assign it when we make it the current
> > pool, with a small explanation of why that is needed (the actually
> > issue Sashiko pointed out)?
>
> Agreed.  The important part is the race from the v2 review, where
> zswap_pool_find_get() could observe a pool before it was committed as
> current.  I will shorten the comment to only explain the placeholder:
> claim the slot at creation time, publish the real pool only when it becom=
es
> current.
>
> > I think we can drop the assertion since we already have the lockdep
> > check below, especially because it uses BUG_ON().
>
> Agreed, I will drop it.
>
> > Hmm let's read this into a variable first then compare it to
> > ZSWAP_SLOT_RESERVED instead? It's not very readable.
>
> Agreed, I will read the slot into a local variable first.
>
> > I think this comment is unnecessary.
>
> Agreed, I will drop it.
>
> > Let's drop the assertion here as well since we're adding a lockdep chec=
k below.
>
> Agreed, I will drop this one too.
>
> > I would align the second parameter with the first one if it stays
> > below 100 characters.
>
> Sure, I will fix the alignment.
>
> > This doesn't really explain why. Also, does ordering really matter
> > with the lock held?
>
> Yes, the ordering matters because zswap_pools_lock only serializes the
> writers.  zswap_current_pool can be observed by RCU readers without that
> lock.  Publishing the current pointer first would let a reader observe th=
e
> new current pool while its array slot is still ZSWAP_SLOT_RESERVED.

Makes sense.

Actually, this led me to rethink the slots reservation mechanism we
came up with and the issue that Sashiko brought up initially. I
initially thought it still existed, as two racing threads setting the
compressor could try to resurrect a newly created pool. However, I
realized that's not possible because a module-wide mutex is held while
any module param is set. This also covers zswap_enabled_param_set().

So IIUC, we cannot really have any concurrency here. Pool creation
either happens through params setting (protected by a module-wide
mutex) or during initialization. Does this mean that Sashiko's review
was a false positive and we can go back to directly assigning array
slots at pool creation? If that's the case I am happy we can avoid the
complexity (but sorry I led you astray).

It also makes me wonder if we can just drop zswap_init_lock, but
that's a separate project. Most of the zswap init code needs to be
reworked imo.

