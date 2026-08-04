Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B373FC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABFB6B00F4; Tue,  4 Aug 2026 13:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E376B00F9; Tue,  4 Aug 2026 13:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF936B00FA; Tue,  4 Aug 2026 13:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46E446B00F4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:02:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92A13160213
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:02:07 +0000 (UTC)
X-FDA: 85064204694.12.AE56A46
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A04E20009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:02:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=I0M2r6N1;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785862925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmIiry7aZvfcYxK9grtKj+mdFQrBZ0Yxe0X8buy7AyY=;
	b=L11d56L9CYtEAahVMiwHXtGbqVNnmY5edx8/brmHQB9wb593Mbba1DDh9FyF5ipPfF1d/9
	/rmVQWVxGd4WMtROUgE2Emnhwi4pG5E1xKQcjeWYLYrSVBtuD9JHNcweZ57iSpEOzBE4UF
	lpnbAQb88268giJO8NWgVG668NY09fo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=I0M2r6N1;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785862925;
	b=we+3itINqVo3wkIGz3fg5mTvWJRUyJq/7MXBYqGql+x6kdK+sr0bqceHIPXHVELdVR6h/A
	pF/fkmV807hGmudejVYddFhbHDjAyAAJL/SgF4DALQMMXZzbDJEmnD5kWR05PX9zJTUnM2
	V0sto3SKm22BNP4ZG/A4QlLcg450PlQ=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a0ddef4e35so85a12.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 10:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785862924; x=1786467724; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PmIiry7aZvfcYxK9grtKj+mdFQrBZ0Yxe0X8buy7AyY=;
        b=I0M2r6N1vHwEyJ7FnaKhADHLlG5h8ubHDhL5Jw6bPjE5M0nZA5VL71lEhPXbInap1i
         WnpFw2OjbpH2KViVyh0df8V5UTIEXSL+DEqrCGIcIY+WQN8lzoZ8U3XG2NFIeoR5U+89
         gci3dX1PSPA+ZXi3VpTWU1wfBUUUreHndEkd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785862924; x=1786467724;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PmIiry7aZvfcYxK9grtKj+mdFQrBZ0Yxe0X8buy7AyY=;
        b=DAEzmc+wcPgUEe9NZuHOgD0UdfpGpuAasNH3Tc1ekYYhw6qPrT0iE6It91syI6Hqtt
         S9SnyVUaD+COQl5bw4+GNZMiymNX6w80c7B04qkOAgsPeqnXnyNtznApybY/WuwSazqM
         Vj/GrMzOdKZTU+igqWiCUOxu45OuaB9w3Wz+oh50OgnkX8c+bso1j7Xw/n8oOVes/cER
         ZTfRlvq1LEHgDQ1Q3nVSE8IH6kV9gg24uQMC3rIaed3MD895tSmnB+G/1qEdSE3tqFgo
         1LHbMukBxrlsS3fOQJpvh9AqyFLWan9k9YI0INi0ny+0opFH5nP0hkn0PHHSaUGI5pBi
         J78g==
X-Forwarded-Encrypted: i=1; AHgh+Rr/G4sRyGVhavCzIc7CkByOlKhQ9+vfiLjmo/4b4rFNH/DU6L/n86UNonhg3opddZRFI1ikAWsULA==@kvack.org
X-Gm-Message-State: AOJu0YyZ7lpxasLKQbmsphqFL4d4DwB06NZefvxG03SdRV4G4mEIWhh2
	1c14VTgKFj0O38yLvAgGlNIvS3YSypXWD/KKDgatpsoFI1Or7Qw1juNNOz3SELpyE8yH8esLXgh
	jXj3Fyapmeg==
X-Gm-Gg: AR+sD12bmg6THlYR4cpPwAwEpUU7eBcOZ2A58b3FlndKSSxtorhzb/OUxx5LSrjaQTP
	sF/0xpgn7YFSPCA4QTrReWVYZmP/tqiXdg230FeqONa0LKRRzNZp1VmvwlfLS0Nol/VOV0raMaB
	zhik5fIbafZRiX6Xm1e0DiQunwMhzNQ9uHr5bC1LwVaxqB9BnqQtWlzNLMSJJLxQzDtNEi7Qc90
	UXmluPgbkpuojA8uM+nqGN1BvNRcSa+QBDMsg5uxD6Am5Chp5mtAW89uCET00Q59DKfgodq/GOu
	7qWEgOKSTtovcFMpNpybbNuyHqok+TXIr9kR0JwGEu3LXzRpBLLZI/8RRk9tZ2vO1gM9MZyLkYd
	9Lvpj+2eJ9a2IO2XUSKEY4TBr/I/J13wYxOudSvTTYxOQtYa/IYxw4tlOH4G12Kje5QK/naR1vv
	PvGYbIrAIyRMf1QGz30ZAJgDqNGT00VjrIGhegc4ZA9evD/TJKasn1zVk9AqmuA8mkWbtZmfNoz
	ObYTuck9wVAuMrcdCEWbeUxKXG0QHdx3WcaYGKKqo0gji/ueDz6QFShr+VH
X-Received: by 2002:a17:907:980c:b0:c20:3679:a2e6 with SMTP id a640c23a62f3a-c2039b4bf40mr1194966b.10.1785862923629;
        Tue, 04 Aug 2026 10:02:03 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036428e13sm34925866b.45.2026.08.04.10.02.01
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:02:01 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15d111ca99so15228166b.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 10:02:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqaEpEo/bXjznmgNFw+aIKhLdKbahHgHZ7yEm+XiHGw0T+/pjrl4OQMrsiWQkBRuGpo1sIMJS1D8w==@kvack.org
X-Received: by 2002:a17:907:d644:b0:c20:34de:5050 with SMTP id
 a640c23a62f3a-c2039afb05amr1859566b.7.1785862921642; Tue, 04 Aug 2026
 10:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org> <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
In-Reply-To: <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Aug 2026 10:01:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
X-Gm-Features: AUfX_myV459rrh5aLothtZtKTDoxBGv6XJzHteSXTBWGF6tQ5Ts34uDH3FMsq0Y
Message-ID: <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A04E20009
X-Stat-Signature: jz7bf4mu4zz4ob1hnayuh6yhogo5qe5e
X-HE-Tag: 1785862925-518394
X-HE-Meta: U2FsdGVkX1/Wk/ZvhYMvdEXsR1A82M4aKC1Zoc+ezm52xXdZdHiTR1VtS+XnJ+EgUjopN7nSUk6uoCEGNuAbn196prndcY5JodBClnIDmNaF/ds6BhpAxuazqKNX3MBLozqRiITX8eOJsD6y6RkzvAkARrlgPKmwLHMf2eJK2s+JkNUjt0ZXarWaVFIHAuebGZY0palm+DqFhrzTrH2fA+rIZ/j0KMcNBxk4kIc1ykynxfh3/3HHpyRCayqW9a/AZuk35h5WFBFG6RtxE0In+5gjAFZah7sSRCRUVvaRA077K88EXGog4M5HvTCcstjSc7jhhc03c6yoy92CRn7oQKzZyjnOCNom0THHd27upfm9t8L07UP4x/kK3ib7uZHIlAlSTG+WQv1bC/3IgizELtGIAgoLBjJMvD2uGA3zZOSImTg9XC8n6jFLHgfLOnxQ/XCYREp585iC3fOssWtYyZGMql/y4E83Rat6cx44uA5v7eoaX6q4MZHfg8WH/Ycfms5XxmLJhCTwk3JxpW8SZbfR9EMdm2PctBZN09Nw1z6Izd0a3Q0ftHwPwMcJ/L+6dCQORWexOMthbN/amNddwoL1Eh1Iu0AT146t9hoze1v3ysGpu0YlcclJT6EUi4F1felUeIe5IVS8DGnJ12xGJdjVUNwIfLuUE5ER57AM0xawxrB5szgOzigPpCrd4PF6glNAyvUW3oMz1chB0q25cPPjhtIO0/vqrnWvyL91WETNfssTTw2YJHU9623cVD9LDuA38fZE6p/B3K0loFYuCjnJp6bpCgI8CUubs9I4Xqsk1I5GTeMVB2Im401U3Ppzse4/qAGJgtA5AaO6l7JOPwkiahpOKnGJSBoej5CbbSTPB2M4pPjKQjLkbfigJccfd2rYt0xgsm/IoK8cigjrHOI0MfbirmAYUV5/kvGOq9U8672Wb9UAlbwOPqUmWwbMiCLXOWOgJrSkuxtV+F0
 127XsTZu
 CiPBtOxvYKLLlCKgZgvPq36bR5luhw42pKjqoFbxXOMVkvUVJxUv9CsF4zGgeIE8tv4yCS2QhmlLXs27Y6vWCuFiCCeC4UtzVA5G+pj3KeG9lTMeojQEIOc3npWlDqQMl2XSxuABlOigREtMo0lBY3vGyZllTij4tmsdtaX5/LE3LKudNz2991NNAS4bMWJfHShQ6VLUdaIIlS4U0k/8kqtfEa7uNWUsRDIj/DU1AZhuzDjbJZ79ftMO5qRrVbmQv9UHZvhIq08YPyhnuS30+w/fBi4FutaTF1yOTZERFraJPAGs1ChrBFmU9bey9PKfUgmX3b/LhbLDh+6euAWXux3YFUJWQCJInQ5+vOIkkKRMUxNWZFSV1ZeW7NcCJQ9PNV48y7gKGK6wYYLBh+j1HqxR97q+UzTRJeW6ZwHGldWxrifwq/2OyfN2QG1+bY1vWyMg7x1h3fscgVgnPLDvv9QZZO/Iinn6R8ZeUd0GRy7Hj9PG7w+YnVk2s06tzr+kNIMdQon5Sl6VxxUI8JQDjWzXoAeNWisC8jWmA9qM8o6aRZX8ih+6bnUxW78/TfanUCOOYYu1kBhhHJ1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 at 09:30, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Because people really have wanted to make it a "this is how the VM
> works" thing. And that is very much what I object to.

Side note: it's not that I object to small helper functions for some
common case that a couple of architectures take (ie arm64 and s390).

But I do object to what looks like some kind of "this is how
architectures should do it". Because I don't think that's the proper
path at all. This is an area where there are lots of commonalities,
but there are also cases where an architecture simply doesn't need it
at all (x86 segments are an example, but so is any architected base
register) or might take a completely different approach simply because
of how the architecture does TLB fills (ie different areas may have
simply different TLB walking: the pattern of "top few bits of the
virtual address picks between different "segments" - different from
x86 segments - is not that unusual afaik).

And I think David is right that there are different forms of this all,
where that kernel text is another special case where some particular
architectural choice might mean that it's trivially cheap to do *that*
entirely differently (typically because you know there are no writes,
and no aliasing issues).

So I'm just trying to clarify my stance - I don't hate percpu TLB
contents per se. I hate the notion of codifying them.

For example, if you have a SW-filled TLB - which is admittedly a
horribly broken idea even though it feels so clean and nice and has
been done multiple times - that changes how everything like this looks
for that architecture.

             Linus

