Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327D6CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D836B009F; Tue, 12 May 2026 12:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFF56B00A0; Tue, 12 May 2026 12:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD0E6B00A1; Tue, 12 May 2026 12:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4BA6B009F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:02:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD1E912053B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:02:57 +0000 (UTC)
X-FDA: 84759236394.23.062E925
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id B6E5D1C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:02:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KkaDGiut;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778601775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjqoH2MST/ARSrDQXxT/BJrG9vMB0FapDofsPh6TaDo=;
	b=ozG9ATdaUoDHEk5fedrQsyxdA+HscUG5oQxfnbX7Ug4IiBIaxPkYdhqAYPzCEYZQ0Fn3TT
	1FkQi4jjYpZHvcQlqRQ9uGCi5GFDzyBqp9XX42sIvc/1xJYQdZ3frS6+EzV13TBmcQf1pF
	t4ovsVqtC8akJsGo8xkFGwX/YohBAPQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KkaDGiut;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778601775; a=rsa-sha256;
	cv=none;
	b=ExCaCNn0pb0SltMBiTYdUvm9SKy34XhK1fH9D+0TWiqkdkMXxZK4SBHMeA5MBQjRg5b/Sz
	KPu5+cRLVxhNxxa1matP0LV8UXaio7T3xi604SMWoUhk58xHjjU6mKjqt9MFS7FZ05mwWd
	mAhBlyg7SYIp1fOR/FSLYCkWpQF5rng=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-956849ae1efso1736429241.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 09:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778601774; x=1779206574; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AjqoH2MST/ARSrDQXxT/BJrG9vMB0FapDofsPh6TaDo=;
        b=KkaDGiutawyOlxJCv+f/uU+Lpahg31MUQ1mt/lfA8HcJafbMn5memoW9yy+v6MO8Yf
         //xusWzfB6clCP6Ygeq40kzanStGUunGcGUWMaLqfiijv95nhWxDHArEnNaoP5N+p9iM
         RuFV6VNVyuYPpzySWnyJBR3TQgGnPSEVNHZs3Xb3nl3C2iWB6Qd436dNVuCNZ9GpsV2Q
         xtIUmEGiHM/M0rio5kkz7+5BL42/Dyx/pEQY+xLAYyhtqI/yLFPqrzuLdEIj0JhTIcqM
         F56qjIDKTpekezDuL5xz8dXrRa5G+lbAQQeTUXfdCapuR5cn4pKYGgm4ylj3weMlLb7e
         R/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778601774; x=1779206574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AjqoH2MST/ARSrDQXxT/BJrG9vMB0FapDofsPh6TaDo=;
        b=cp2J4fK9NSFVn6J2Wa8/5vXUfncoPAKcQkM/FoN6R0qxNjY8Ey84qc+l21xq+0lbnN
         /Fz1hRj1c/YZ8o/oEk/otcHnIY/kG4BEfIC4SS6jSfGvOPYOTba+1hIUAGju6A/nHd3j
         n9QE0sjjGlQPbHmJuPIYufiWOzku/TVCF+EzdwrPDH959mMCRE6umn18ze3BHpkklUVf
         7zWGFdyx8VCfvLMhTKaQmA6xPJsbCVCskF8OdD2kNtuSTetTDm2vwbTroGlqjkqDZ57V
         6kI+JD/YKPRRvLceetl0MnNbgvlSghN3CSDY5WdhSedjpLfPNsfh/mE+2cMyHD64qxBk
         4wrQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Ko2cM2ZvChOuRCQu+zSy0cpGhPztnxzdt3BMzYND8GVX837h/uAdJCx/JmTcSfKbhrvCbreaJfQ==@kvack.org
X-Gm-Message-State: AOJu0YzGmBNKoKoAZs8r9M+NJ0mLDH+3D8MSS+hZeib+dLWvcSUB32TB
	baI0VxvAYMcTrrhyEHMLD5ubs+xDXoHJBrNnY61d/5i/qsIRuPPn9gv16s2vfCYn/x/GvrPpl7z
	h9nmTP9I=
X-Gm-Gg: Acq92OEL6G4nqvgDqBKnOMqMTxNbPvlp/P4cgdjsBpWIT8xmCwIAq2FV6tTpfg3JAw1
	fLNrERO161tGyn/qWVu1JHdHBMJrdqItGweR1o12VVNo/JW9Si7XLoMNwWV01sfDcHfPTnqmXuC
	pdSnMez5dpAIx7MW9fLUxazwfXvo6Hht/6qiW0oOLjNy0h1k/nPtSKQXwW1FEnbpUdT71UcDHn0
	w+z7cEbVdVc4kEvnJZJlKobjz37GkZOz0kiyjMdT5Mdm/Uyg0dUDkht2B/DZbSDCmDc1kyhy920
	o3IdqL+ssZ2JvhhzRBRyeiybww2Z7HboRLRJq6TC5Rd8dhwXutlVkfoM4roJlo9kd70a+7DwPIS
	RYUC/WeVR6ojzmgQuGv/8OFFVToJVJdvG5e66KmOL+10eSOtc1AIpC+PIjdnVEUmW5JARX3g/yi
	bXtjkAZyIOBCJXokj3XWSaiRx33dbYPQ8pne4vvJ2P/mAyBAh21Yo=
X-Received: by 2002:a05:620a:4506:b0:909:b1d5:7f63 with SMTP id af79cd13be357-90cfafbe0c8mr498728885a.3.1778601320648;
        Tue, 12 May 2026 08:55:20 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd057acsm3752666485a.47.2026.05.12.08.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:55:20 -0700 (PDT)
Date: Tue, 12 May 2026 15:55:18 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dmatlack@google.com, 
	kexec@lists.infradead.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
Message-ID: <agMtfe19n4OlxXmS@plex>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-2-pasha.tatashin@soleen.com>
 <2vxz1pfgbvic.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz1pfgbvic.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B6E5D1C0007
X-Stat-Signature: z6d9zduewpdy3zapfekpg7g5bsy8i6sb
X-HE-Tag: 1778601775-430602
X-HE-Meta: U2FsdGVkX1/72tYBP6Fz+04AfPquE7uMIusPgK0PInnIMAPQWLGoto4miO2FhDCEIaWkw6jWaYAWde7UY9eYIiR9hq+rocmVZucFgxZlL2P17QHwR4yuPwTYP46+BfMZiupJAm7GwFqzLsP9S89nvJm3Ml7szQVk2VTreULWXC2ClUBdf+3NpNi7FSHE/k1bAZMov5tompnBI7Cr93DOwX1NAf9As+5q8FZZ16/gVNOjd1sgTTsiMuzot12iJlEyRbywveC7UZxMb5fqzJm8S8ZTEfXhZhe1ZMEaUTYQZzBgadu3Ht2uLAsBrqKwf3umozsoAKHjQ3xr859b5Zolf/uXz6QtqYRD01Y2kiqQnbY8DA3E1AiA+U44+0xV3zKYzklFmUd0xY81rXbNqaz/1M4ssp/ryIrXXTF5M0pMaZFdrkEHQ2F/XxoAEniN/hjtTpP4Ex5Ify6m6AtZwXffRW0cCAU/FoEFj0mZ2uOn1kEUbOAZtgmkEKFYpzl9XfQuzEbToOB5P5Hyn2P9KjsfFIVoFn+LwjCr9xgt2yFV5zxFt3d3GC5QJqx1n9Iv78d1mP2im8Ma3b2aiHKZ7CkEZY6RV0YuJoMnUgLTveLIIbdH1oPITE3P94axurpJtB90nePgsc/sCOg4k6sVNxlAcflGg8ILJ7svNT1xq7EcuGEX/fmzHxBZO0zmpZQTQtOgOIl56pJtk8aPjQKf4DcbejmMzffHAX0w7r8I+FxhDRD4SogejNUtT6Z4QT3bfMz3v7gfFH3SKoUoMQShRbxL91K00DfINQf0hXX23y9fdPWtgd/lms325hBOF96Uj+45yyMBSURb8LugU7PcJzTWu3oT6xKSiTF9y13J60TJeM42btQnUgO1jKpjryu6sD/JlM8HP1762YWPUJt3zh9Mn3jTuC101hBIcPFSzA2P1n3B6tYY/5W7kMpzaiFRKfSzGkf1puC5Ar2dfsdVauw
 zpbRd9kN
 FIZpD2UHzEreVp0HKnRNvR1zL8LWNQ92m2ChZSi7QQWYRQjckHZBp2kdRgz7/G09wgKIoJNga8/g31zQNq9RxZ/66KjG5yUhQ88wZ78cfGxFIv/riGU/YFVcekjeWcS97qvCzw+QQ5v8KrEGSemd7fmOMEVYqnmtTbpfieMLVMB0hOT+3+1vEhiYRBOIJMjWFeMiqnwtOcC8s2ZlV2d1XVg/Oe6V6CrGTLMrTUBedcwuJ1A4rF0gH0C5IC72px0+fJueQLKQaysMQg2ppdK1SPu9jXW1XAiI3maajbrgfMgQUcEAdqnzMFXPzXPOiLcWHfJDfLBr8to9iI0bgfehWax7YZ3hAF7qVDc9MZAyMCK3E8nkikNx6C0+nifrRRDWAOhtsR0z7lwHkD7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-12 15:35, Pratyush Yadav wrote:
> On Tue, Apr 14 2026, Pasha Tatashin wrote:
> 
> > Currently, the number of LUO sessions is limited by a fixed number of
> > pre-allocated pages for serialization (16 pages, allowing for ~819
> > sessions).
> >
> > This limitation is problematic if LUO is used to support things such as
> > systemd file descriptor store, and would be used not just as VM memory
> > but to save other states on the machine.
> >
> > Remove this limit by transitioning to a linked-block approach for
> > session metadata serialization. Instead of a single contiguous block,
> > session metadata is now stored in a chain of 16-page blocks. Each block
> > starts with a header containing the physical address of the next block
> > and the number of session entries in the current block.
> 
> We now have 3 variants of this linked block data structure: LUO
> sessions, LUO files, and KHO vmalloc. Is it time now to unify them into
> a reusable data structure? I proposed "KHO Array" some time ago. That
> was a collection of pointers, but perhaps we can generalize that to a
> collection of elements of arbitrary size?

I agree, especially since there are a couple more users incoming. I know 
Sami is proposing this for IOMMU as well. He and I have talked about 
creating a library that others could use. My suggestion is to get this 
in now and unify it later into something that works for all use cases, 
rather than changing it for every new one. The KHO ABI is not stable, so 
we can change it at any time, but I would still like to minimize the 
number of times we do so.

> [0] https://lore.kernel.org/linux-mm/20250909144426.33274-1-pratyush@kernel.org/T/#u
> 
> >
> > - Bump session ABI version to v3.
> > - Update struct luo_session_header_ser to include a 'next' pointer.
> > - Implement dynamic block allocation in luo_session_insert().
> > - Update setup, serialization, and deserialization logic to traverse
> >   the block chain.
> > - Remove LUO_SESSION_MAX limit.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      |  19 +--
> >  kernel/liveupdate/luo_internal.h |  12 +-
> >  kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++--------
> >  3 files changed, 197 insertions(+), 71 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > index 46750a0ddf88..f5732958545e 100644
> > --- a/include/linux/kho/abi/luo.h
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -57,9 +57,10 @@
> >   *   - compatible: "luo-session-v1"
> >   *     Identifies the session ABI version.
> >   *   - luo-session-header: u64
> > - *     The physical address of a `struct luo_session_header_ser`. This structure
> > - *     is the header for a contiguous block of memory containing an array of
> > - *     `struct luo_session_ser`, one for each preserved session.
> > + *     The physical address of the first `struct luo_session_header_ser`.
> > + *     This structure is the header for a block of memory containing an array
> > + *     of `struct luo_session_ser` entries. Multiple blocks are linked via
> > + *     the `next` field in the header.
> >   *
> >   * File-Lifecycle-Bound Node (luo-flb):
> >   *   This node describes all preserved global objects whose lifecycle is bound
> > @@ -77,9 +78,9 @@
> >   *   `__packed` structures. These structures contain the actual preserved state.
> >   *
> >   *   - struct luo_session_header_ser:
> > - *     Header for the session array. Contains the total page count of the
> > - *     preserved memory block and the number of `struct luo_session_ser`
> > - *     entries that follow.
> > + *     Header for the session data block. Contains the physical address of the
> > + *     next session data block and the number of `struct luo_session_ser`
> > + *     entries that follow this header in the current block.
> >   *
> >   *   - struct luo_session_ser:
> >   *     Metadata for a single session, including its name and a physical pointer
> > @@ -153,21 +154,23 @@ struct luo_file_set_ser {
> >   *                          luo_session_header_ser
> >   */
> >  #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
> > -#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v2"
> > +#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v3"
> >  #define LUO_FDT_SESSION_HEADER		"luo-session-header"
> >  
> >  /**
> >   * struct luo_session_header_ser - Header for the serialized session data block.
> > + * @next:  Physical address of the next struct luo_session_header_ser.
> >   * @count: The number of `struct luo_session_ser` entries that immediately
> >   *         follow this header in the memory block.
> >   *
> > - * This structure is located at the beginning of a contiguous block of
> > + * This structure is located at the beginning of a block of
> >   * physical memory preserved across the kexec. It provides the necessary
> >   * metadata to interpret the array of session entries that follow.
> >   *
> >   * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
> >   */
> >  struct luo_session_header_ser {
> > +	u64 next;
> >  	u64 count;
> >  } __packed;
> >  
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > index 875844d7a41d..a73f42069301 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -11,6 +11,16 @@
> >  #include <linux/liveupdate.h>
> >  #include <linux/uaccess.h>
> >  
> > +/*
> > + * Safeguard limit for the number of serialization blocks. This is used to
> > + * prevent infinite loops and excessive memory allocation in case of memory
> > + * corruption in the preserved state.
> > + *
> > + * This limit allows for ~8.1 million sessions and ~1.2 million files per
> > + * session, which is more than enough for all realistic use cases.
> > + */
> > +#define LUO_MAX_BLOCKS 10000
> > +
> >  struct luo_ucmd {
> >  	void __user *ubuffer;
> >  	u32 user_size;
> > @@ -59,7 +69,6 @@ struct luo_file_set {
> >   * struct luo_session - Represents an active or incoming Live Update session.
> >   * @name:       A unique name for this session, used for identification and
> >   *              retrieval.
> > - * @ser:        Pointer to the serialized data for this session.
> >   * @list:       A list_head member used to link this session into a global list
> >   *              of either outgoing (to be preserved) or incoming (restored from
> >   *              previous kernel) sessions.
> > @@ -70,7 +79,6 @@ struct luo_file_set {
> >   */
> >  struct luo_session {
> >  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> > -	struct luo_session_ser *ser;
> 
> I was confused by this removal. Seeing this makes one think this got
> moved to some other place. But it seems like this was never used. I
> think it would be good to mention that in the commit message.

Let me move this to a separate commit, may be together with the comment 
fix below.

> 
> >  	struct list_head list;
> >  	bool retrieved;
> >  	struct luo_file_set file_set;
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > index 92b1af791889..007ca34eba79 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -69,30 +69,39 @@
> >  #include <uapi/linux/liveupdate.h>
> >  #include "luo_internal.h"
> >  
> > -/* 16 4K pages, give space for 744 sessions */
> > +/* 16 4K pages, give space for 819 sessions per block */
> 
> It seems odd to read that we added 8 bytes to the header and the number
> of sessions per block grew. But then I did the math and I think the
> number was always 819 sessions per block and adding the extra 8 bytes
> didn't make a difference.

Yeah, I updated the comment while at it, 744 was true in some earlier 
LUO versions, but was never updated.

> 
> >  #define LUO_SESSION_PGCNT	16ul
> > -#define LUO_SESSION_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
> > +#define LUO_SESSION_BLOCK_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
> >  		sizeof(struct luo_session_header_ser)) /		\
> >  		sizeof(struct luo_session_ser))
> >  
> > +/**
> > + * struct luo_session_block - Internal representation of a session serialization block.
> > + * @list: List head for linking blocks in memory.
> > + * @ser:  Pointer to the serialized header in preserved memory.
> > + */
> > +struct luo_session_block {
> > +	struct list_head list;
> > +	struct luo_session_header_ser *ser;
> 
> Nit: luo_session_header_ser reads like it is the header for the entire
> list not for each block. Perhaps rename it to luo_block_header_ser?

Sounds good I will rename this to:
luo_session_block_header_ser and, in the next patch 
luo_file_block_header_ser accordingly.

> 
> > +};
> > +
> >  /**
> >   * struct luo_session_header - Header struct for managing LUO sessions.
> >   * @count:      The number of sessions currently tracked in the @list.
> > + * @nblocks:    The number of allocated serialization blocks.
> >   * @list:       The head of the linked list of `struct luo_session` instances.
> >   * @rwsem:      A read-write semaphore providing synchronized access to the
> >   *              session list and other fields in this structure.
> > - * @header_ser: The header data of serialization array.
> > - * @ser:        The serialized session data (an array of
> > - *              `struct luo_session_ser`).
> > + * @blocks:     The list of serialization blocks (struct luo_session_block).
> >   * @active:     Set to true when first initialized. If previous kernel did not
> >   *              send session data, active stays false for incoming.
> >   */
> >  struct luo_session_header {
> >  	long count;
> > +	long nblocks;
> >  	struct list_head list;
> >  	struct rw_semaphore rwsem;
> > -	struct luo_session_header_ser *header_ser;
> > -	struct luo_session_ser *ser;
> > +	struct list_head blocks;
> >  	bool active;
> >  };
> >  
> > @@ -110,10 +119,12 @@ static struct luo_session_global luo_session_global = {
> >  	.incoming = {
> >  		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
> >  		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
> > +		.blocks = LIST_HEAD_INIT(luo_session_global.incoming.blocks),
> >  	},
> >  	.outgoing = {
> >  		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
> >  		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
> > +		.blocks = LIST_HEAD_INIT(luo_session_global.outgoing.blocks),
> >  	},
> >  };
> >  
> > @@ -140,6 +151,70 @@ static void luo_session_free(struct luo_session *session)
> >  	kfree(session);
> >  }
> >  
> > +static int luo_session_add_block(struct luo_session_header *sh,
> > +				 struct luo_session_header_ser *ser)
> > +{
> > +	struct luo_session_block *block;
> > +
> > +	if (sh->nblocks >= LUO_MAX_BLOCKS)
> > +		return -ENOSPC;
> > +
> > +	block = kzalloc_obj(*block);
> > +	if (!block)
> > +		return -ENOMEM;
> > +
> > +	block->ser = ser;
> > +	list_add_tail(&block->list, &sh->blocks);
> > +	sh->nblocks++;
> > +
> > +	return 0;
> > +}
> > +
> > +static int luo_session_create_ser_block(struct luo_session_header *sh)
> > +{
> > +	struct luo_session_block *last = NULL;
> > +	struct luo_session_header_ser *ser;
> > +	int err;
> > +
> > +	ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> > +	if (IS_ERR(ser))
> > +		return PTR_ERR(ser);
> > +
> > +	if (!list_empty(&sh->blocks))
> > +		last = list_last_entry(&sh->blocks, struct luo_session_block, list);
> 
> Nit: using list_last_entry_or_null() is a tiny bit cleaner.

Done.

> 
> > +
> > +	err = luo_session_add_block(sh, ser);
> > +	if (err)
> > +		goto err_unpreserve;
> > +
> > +	if (last)
> > +		last->ser->next = virt_to_phys(ser);
> 
> Nit: can you please move this to luo_session_add_block(). Logically this
> operation is a part of adding a block. You add a block to the list and
> then update the serialized state. So would be nice to have it done in
> one place.

Done.

> 
> > +
> > +	return 0;
> > +
> > +err_unpreserve:
> > +	kho_unpreserve_free(ser);
> > +	return err;
> > +}
> > +
> > +static void luo_session_destroy_ser_blocks(struct luo_session_header *sh,
> > +					   bool unpreserve)
> > +{
> > +	struct luo_session_block *block, *tmp;
> > +
> > +	list_for_each_entry_safe(block, tmp, &sh->blocks, list) {
> > +		if (block->ser) {
> 
> Block always has ser. Why this check?

Removed, thanks!

> 
> > +			if (unpreserve)
> > +				kho_unpreserve_free(block->ser);
> > +			else
> > +				kho_restore_free(block->ser);
> 
> Ugh, this is ugly. But I don't see anything obviously better. Perhaps we
> can check for sh == luo_session_global.outgoing but that is probably
> worse.
> 
> > +		}
> > +		list_del(&block->list);
> > +		kfree(block);
> > +		sh->nblocks--;
> > +	}
> > +}
> > +
> >  static int luo_session_insert(struct luo_session_header *sh,
> >  			      struct luo_session *session)
> >  {
> > @@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_header *sh,
> >  
> >  	guard(rwsem_write)(&sh->rwsem);
> >  
> > -	/*
> > -	 * For outgoing we should make sure there is room in serialization array
> > -	 * for new session.
> > -	 */
> > -	if (sh == &luo_session_global.outgoing) {
> > -		if (sh->count == LUO_SESSION_MAX)
> > -			return -ENOMEM;
> > -	}
> > -
> >  	/*
> >  	 * For small number of sessions this loop won't hurt performance
> >  	 * but if we ever start using a lot of sessions, this might
> > @@ -166,6 +232,20 @@ static int luo_session_insert(struct luo_session_header *sh,
> >  		if (!strncmp(it->name, session->name, sizeof(it->name)))
> >  			return -EEXIST;
> >  	}
> > +
> > +	/*
> > +	 * For outgoing we should make sure there is room in serialization array
> > +	 * for new session. If not, allocate a new block.
> > +	 */
> > +	if (sh == &luo_session_global.outgoing) {
> > +		if (sh->count == sh->nblocks * LUO_SESSION_BLOCK_MAX) {
> > +			int err = luo_session_create_ser_block(sh);
> > +
> > +			if (err)
> > +				return err;
> > +		}
> > +	}
> > +
> 
> Since we just allocate space here and not actually fill it yet, I think
> we can do the same check in luo_session_remove() to free blocks once
> session count falls below (sh->nblocks - 1) * LUO_SESSION_BLOCK_MAX.
> This prevents memory leak if the number of sessions goes too high at
> some point and then falls back down.
> 
> Not that I think it is something likely to happen, but I don't see why
> not.

Done. I did not want to add this functionality just to keep the patch 
simpler, but since you brought it up, I am adding it here.

> 
> Perhaps also abstract this out to a helper function for readability?

Done

> 
> >  	list_add_tail(&session->list, &sh->list);
> >  	sh->count++;
> >  
> > @@ -444,9 +524,12 @@ int __init luo_session_setup_outgoing(void *fdt_out)
> >  	u64 header_ser_pa;
> >  	int err;
> >  
> > -	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> > -	if (IS_ERR(header_ser))
> > -		return PTR_ERR(header_ser);
> > +	err = luo_session_create_ser_block(&luo_session_global.outgoing);
> > +	if (err)
> > +		return err;
> > +
> > +	header_ser = list_first_entry(&luo_session_global.outgoing.blocks,
> > +				      struct luo_session_block, list)->ser;
> 
> I suppose it would be a tiny bit better to create a placeholder entry
> here and then fill it up later in luo_session_serialize(). This would
> result in the first block not being a special case and it can be
> allocated and freed on demand list the rest of the blocks.
> 
> I won't insist on it but would be nice to have IMO if you're willing to
> do the refactor.

Let's keep it as is for now. Perhaps, we can return to this once we have 
a unifying library for KHO arrays.

> 
> >  	header_ser_pa = virt_to_phys(header_ser);
> >  
> >  	err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
> > @@ -459,19 +542,18 @@ int __init luo_session_setup_outgoing(void *fdt_out)
> >  	if (err)
> >  		goto err_unpreserve;
> >  
> > -	luo_session_global.outgoing.header_ser = header_ser;
> > -	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
> >  	luo_session_global.outgoing.active = true;
> >  
> >  	return 0;
> >  
> >  err_unpreserve:
> > -	kho_unpreserve_free(header_ser);
> > +	luo_session_destroy_ser_blocks(&luo_session_global.outgoing, true);
> >  	return err;
> >  }
> >  
> >  int __init luo_session_setup_incoming(void *fdt_in)
> >  {
> > +	struct luo_session_header *sh = &luo_session_global.incoming;
> >  	struct luo_session_header_ser *header_ser;
> >  	int err, header_size, offset;
> >  	u64 header_ser_pa;
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

