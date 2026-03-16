Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD3EF53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213736B02EF; Mon, 16 Mar 2026 12:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA636B02F0; Mon, 16 Mar 2026 12:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C00C6B02F1; Mon, 16 Mar 2026 12:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF8DE6B02EF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:01:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C252B58336
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:01:33 +0000 (UTC)
X-FDA: 84552391266.17.C66A3F9
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id B867BC000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:01:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rRUg/qax";
	spf=pass (imf10.hostedemail.com: domain of 3WSm4aQgKCOALCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3WSm4aQgKCOALCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773676891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cy139sVJqEhb40Dyk/x+cPr9bRVnmTHD3vwfuMx6Iog=;
	b=HKcp/KgEB2YzQBZx37RZ8LQrrptrPrqImLnWu1iUhKvVbVMhdUuzO3XSnQprNSomB4rd8I
	YTLwj7vjdlfN0yvoxvj6WlqMnyzNtETtoYwleybHf/ECWQYQnfDnWNGJzA6/Oty/ISxfhK
	Gx+12fAIO8JSO3pYjKTpIn8S16rti5c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rRUg/qax";
	spf=pass (imf10.hostedemail.com: domain of 3WSm4aQgKCOALCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3WSm4aQgKCOALCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773676891; a=rsa-sha256;
	cv=none;
	b=DDFdzK3XuHiWEDzI1dYiV49kwltUr0E3G4Giw0dBz+uOSsHrwDqA7sdLZhPPIwIDPmVe7E
	gmLq/r89iXhki0qEkaxS6xAKK1Wmvdd61KMTP+YaZ6Y9vWmBRutuytCVd3wspLJCY0K+IP
	ozhU2F0SioRHSC/SgkL6y79rLxcRGQY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836abfc742so32871515e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773676890; x=1774281690; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cy139sVJqEhb40Dyk/x+cPr9bRVnmTHD3vwfuMx6Iog=;
        b=rRUg/qaxmzmHl3OEDus+pDUsSOz/EB7qAY1jQnazl9FZjTTu7QVa8TnDy/FNLLNU4G
         tjttPG1ALnOyYAiDh9FmCFxHLbW9Fq/cObZI2G7rsXp6vFNDXsDXoXr1Txosbuoszv2V
         hVg6PqRHtfXkPE3JO5Wy7t7cGWumIkcvzYHmaU6Xq9TO2VBdywQ6QoCHurgEx4iM+XGy
         xI9mkO73zA/69mKY87/BG+JrFuJ31z7uMSbVBdUSUTUYOAzM903iwVdvTv2PGHS4pfc0
         i1dNYjZTdOGFMoVxzfIJjIpdDcPEJQ8FSfYu02HgTGK3zqv2znFUA0W/EYrltLXwDmm7
         Tfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773676890; x=1774281690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cy139sVJqEhb40Dyk/x+cPr9bRVnmTHD3vwfuMx6Iog=;
        b=M4PZa0TTD63s+ljhsPwHCz9/2n+doqoBdIhvJsXl3r33wY36m7wsxU33K5eKYPglai
         LbzUpzBI8oSIDDNMSnfImtqzTwGdjMgvJ1JEP4maTBf9xsPcHtgUzZ00B5GELVLLpynH
         t0HdKNvmaqcnRbeVG32d8Eq4IrDTjgmKLN82firUpTkhfEm5lIF3V2FfLE7LwT/1WTeY
         7Qrh5T4kNrfV8WPeQNyvAMQsjxu7PsRLHLNnhlvyjSTc9BF5yxerp22lEdHIgnvUgfVV
         /Fwf7I/2GA27QN2WR3Kia5QWi4XZqPksLH1NhZZ9rRXx7idIhquqvDvJ69CRzzAr6dsV
         dDyw==
X-Forwarded-Encrypted: i=1; AJvYcCXKej78JXPPJ47sDv+VeAAFxfhgvMsj+0Zpmpx8vZtwBTrk2EaQsAIFVuOi2qa+/fZ0VFNoNGA6wA==@kvack.org
X-Gm-Message-State: AOJu0YyRDitkWsu8dADzBOnlZZtDbZijytX+KLGHmjgQleqbeXHDhLhJ
	6ux75ArjVhPUFiTTxkGRUmsMYkdXUSNLB2JiszwXICdrjmC8iRXMXf32IPa+00ACPftf3kjI9ir
	fM+Oa4zdVFULV7A==
X-Received: from wmpl26.prod.google.com ([2002:a05:600c:89a:b0:47e:ddf0:fd00])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e16:b0:483:6d4a:7e6d with SMTP id 5b1f17b1804b1-4855670cd92mr222236695e9.30.1773676889811;
 Mon, 16 Mar 2026 09:01:29 -0700 (PDT)
Date: Mon, 16 Mar 2026 16:01:28 +0000
In-Reply-To: <5d22bf8810fc18c326e1b12c90994a72f74916a7.camel@intel.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com> <5d22bf8810fc18c326e1b12c90994a72f74916a7.camel@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DH4BZE3Q167G.3N870D63IIUSP@google.com>
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"david@kernel.org" <david@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"weixugc@google.com" <weixugc@google.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ziy@nvidia.com" <ziy@nvidia.com>
Cc: "kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>, 
	"luto@kernel.org" <luto@kernel.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "reijiw@google.com" <reijiw@google.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"sumit.garg@oss.qualcomm.com" <sumit.garg@oss.qualcomm.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"will@kernel.org" <will@kernel.org>, "rientjes@google.com" <rientjes@google.com>, 
	"derkling@google.com" <derkling@google.com>, "david.kaplan@amd.com" <david.kaplan@amd.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: B867BC000E
X-Rspamd-Server: rspam08
X-Stat-Signature: 8oe1nr1s51i8x1qt7hf8zjkn4s99guhz
X-HE-Tag: 1773676891-401342
X-HE-Meta: U2FsdGVkX1/c0t3/4DI5YUcZE0f/gWvI+OhBUXEey8X8CHv8AA8N5XAcBVIofFkqRatsMB2OvGqbqRcMz7qa1ypRi9XSzKCm6D0NS6qzYOU8BOETTrvUMXerenY1TjMKEsiVKUAkHJh9qNx/X9Gc42rCh+NUGTv/xczS02Au586bmm5xVL04WkXA1Fn98HftdJwPhShZqt1Fu2++mLy7DqrG9f6coFrh0HBG4iDEDhnyk7oNjTEj8fYTdS7uYoIoa/dvPyzGUcHtm5TTkDDBYwUOQgAubBcnLRtgOKURwEWU8FdSlQ2Bn1iq8eDbe8+g5zaDVZqxY8XGmhE0kaIG0lhpKqyr1k7uKEQXRLQmO5xOaYtqwN2CFJFSE8h/OvUDB6g4kd2fePvI9xzdkYdSFRdn+xVJYA58XlxIHRo1AaXi/JTDG3JCLKtQRUEYlzVUoEtqSu6LRlpTG5bDl28RFa0fw5vJNtS0FZgKUs3RmYD5Ltp91r9PSDI5WHHPdbXS0u/3DmuDWwasgVQ4emaazXB1TI2Yb68m6z/p0NLypbdb5db3FQMzhaJ0tC5/nfIhLBIq+uMOQuZJcgv0B+Zu1W+oaf845PN+O4gzZeaAsyEqWFfEPyCE9s4vxmKpWbs3w+Nvvl5kqmvCMS+kds8PLGxv4hvtjp9C9vwfQ5IEvkp/8IDxqaqyOJmK/7OjKSUKw15AGJF1dSRBbyWqCpNMFtUxdb7f2RV0R5K7Eb/Cl2xsy9141NDjnrx+zWYr7J9d1LrJw1PM4a950bKaDZsvWc6uj3qvmJwpqqWHiVZ0cr7KdywmJ+vciKss7IxseNO8hLcaeEphLNrdIcC0D1YIFToHCE8RYr64IlzkOJ7dk+605Rxv3HHUf59HhwxdB3KEBmy4fIhN18PGEcr0/oUSqECCHPo/r0cF05YbWmt7Fv7+pI+yZ9bzSpvpAFCtXjbvGdqzIUQTsJEW8qVOZwV
 Gn/nZbJS
 X3LeFV8ifEwhKVSFq7Wo+KQM4E/mCFPVqAeG7IAVusR6P24DPDF/cFYlilcZ+6mhulQP7Carw9JRgW0EWotmVn3BY86GCJOU1yfnxt1Y0vNNLx3NAhc5OB6CESTzuCS+E81ikddVGmwv1VbuNIu+QUoOdWMVB8soD1CVRtbPp1syUMAFhy2IzP5Rp9cRhVqa7+Sxc0icysv3NC/IrBQOQ7OaWbTYJplUutZeF03I5RTCPXFdpoVvFDQT2xM6xRmu9n6Fx3MnQxWd5KOjQkzjEGNQiKXnNYyLaiVV/mmgtd6NoInPSsVsCN8PuP+Ov2cG8rTRQPn4Co6rKDyMfavBurNIOWRKWttAmS1BxFiXCYfb0WjrAhQjDuVotrH+7K5cnebjTH8/5q1DZs4mAurrh8fwbhx4K20jdRdqMe1S85M+o9MLHBCzR73xGoM5qrI0dGuK/JpVh6n2twdYREhc+qwxFXd++BxI2FqAqB3jM0q9jU2Mh4afSpLNwLJ7fEZ1syKDWt4Uqtz+asmZwKQsK1IALBHPICdxneuhi2+kB/1krIe0YNBJ8IEr+KN4CyN3uSE1dafeWHJ3i2m6ezDidHSseWypAQwo0f1/ld+18YkISHlu0cJIN3I4j6B36INP8kgrDq28tOXwXD0/xmqL345jxwxCyAQxLZ+ApiK8XwpQPHe24bX27GhATq4C4leyeGmdLEIk33IYZ2jqSC8csS3AuT+GY2OCivJsSoHHh5A8fwS41c0JXqEOnA5q8ovBvExT+IwAARf+jlxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rick, sorry I was just scanning over this thread again while prepping
the next version and noticed I never replied to this.

On Fri Mar 6, 2026 at 5:38 PM UTC, Rick P Edgecombe wrote:
> On Wed, 2026-02-25 at 16:34 +0000, Brendan Jackman wrote:
>> __GFP_UNMAPPED
>
> Haven't looked at this in detail, but there was some previous work that even
> used the same flag name. In the end, the discussion leaned towards a dedicated
> API instead of a flag. Not saying the flag approach is dead, but might useful to
> explain how it fits in with that discussion.
>
> https://lore.kernel.org/lkml/20230308094106.227365-1-rppt@kernel.org/

I am not at all wed to using a GFP flag for this, but a key difference
between this and Mike's original __GFP_UNMAPPED is that this is
integrated directly into the page allocator itself, and that's a
load bearing element. 

Technically speaking, in this series __GFP_UNMAPPED is only supported
for unmovable allocations, but that's just to avoid bloating the data
structures (there isn't a user for that type of allocation yet, so
there's no point in creating freelists for it). But, in principle, the
goal here is to support all the fancy stuff that the mm does for this
memory. That's important because for the real usecases I have in mind
here, the vast majority of memory in the system should eventually be
relying on the page allocator to unmap it (either completely as in
__GFP_UNMAPPED, or just from the special ASI pagetables as in
__GFP_SENSITIVE, which will be added later).

So, yeah we can always have a special API but that would be a bit of a
roundabout way to just save a bit in a an enum, it wouldn't actually
represent any simplification of the page allocator's API.

Anyway thanks for pointing this out, I will neded to explain this in the
next version's cover letter, but in the meantime there's a quick
braindump of my thinking.

