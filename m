Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD8D2CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 22:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787E86B0088; Thu, 18 Jun 2026 18:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7601D6B008A; Thu, 18 Jun 2026 18:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651F26B008C; Thu, 18 Jun 2026 18:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 357076B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:45:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9212B8CF42
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:44:59 +0000 (UTC)
X-FDA: 84894515118.13.1B7E727
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5186B20004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:44:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026052701 header.b=dwwJelEx;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf03.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781822697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CQLyZa+kGZ1jKy62lWGqc1Yb5ykOIz4STFA7tIJWAI=;
	b=dh9wy993icFQnnuQHkvZSXUt+SvKFRJMjdXeH6NLEhLjul/1LGRGcGm1jEqT7RMYjbfiE2
	osURTai6tmnHLRbKBOm/UwJGPw7b7KAQEnZR2ePzwwNYoN+6PxHSpHKg5IfgvoFUv5rDte
	ZoQjT14I+MRhL/SjUgbVzJAN1yGW/n4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026052701 header.b=dwwJelEx;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf03.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781822697;
	b=yKfNPD5kJvYB3Ct0JkwNgFxycNw/zPni3j32OB0Q00+X1SbvY/82ykIL/N8IIK8r0jmIyD
	Np5NeodMGiGEtqy8UnJKR+H/FcJTzvVbswilJTCLwu16VyF0HJRkH7xkf3cb1ZuKsgV2Os
	FUoYN+CW7vPDf3iSGtoqBa9owPqJG98=
Received: from [IPV6:2601:646:8081:7da1:99a0:e0da:db53:8fc0] ([IPv6:2601:646:8081:7da1:99a0:e0da:db53:8fc0])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65IMSRJV3892479
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 18 Jun 2026 15:28:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65IMSRJV3892479
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1781821710;
	bh=+CQLyZa+kGZ1jKy62lWGqc1Yb5ykOIz4STFA7tIJWAI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dwwJelExN+knq2Ai6uFv1+GAdq+HmK4qrLg7r7KJ6SJrJcypiWAa/hgmBGZDaOZjD
	 YQFK58avMBPqFMKrpEVODbyrFoIjz+g4s2DNkyagCPxac3B/y64X5/q3ZC2uRko4Lo
	 akq7uXP7UplNAVV4ZnRImIOxRVn/I7JfK7bqzWNt/fyvm2clphErfHf2yB9+N3IS+d
	 MG3jflJEVXTWrk4rM/Y+uSOrdtExqEYUQx50JrGomOF+RnyNu8PRadl0bV87mYSKh7
	 qs05+Vgzib/LkiM0piiyC0sHKur9vRbDg9yh08eIe9ofnQj4+pUjWpw+C9G1BjUjHu
	 4460Atwn4/Rlw==
Message-ID: <c96b9621-16f8-41c2-869e-7310adfe75b6@zytor.com>
Date: Thu, 18 Jun 2026 15:28:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Dave Hansen <dave.hansen@intel.com>, "Zach O'Keefe" <zokeefe@google.com>
Cc: David Stevens <stevensd@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon
 <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5186B20004
X-Stat-Signature: aopbfqe144a6x1xdncpr61rrp5unea3a
X-Rspam-User: 
X-HE-Tag: 1781822697-624222
X-HE-Meta: U2FsdGVkX18M33ha7aw1bH9nBUrN//LxfX/Rk90cxXUgrJFhSpw9O4Ime7d3dKOoKb7bIyP94JUGZIVhR3DAbfUZvaN913USatMYW3FPbWJdTEQzC2/d5rCV0BI1KEDNp1mR3nBQDQp37EF0dHSKMaUXsS3MhZIWOzCxcfP4ZOOMkdy8nUU/zmEBXnD5uWlDEKi55etyR9hXTEedfDUdxsOmAfQuyyEKhZAym31rzDQ0dmeFQzspK9+OB2IRij6GpmyQZbBjvAQg9tD2TH6WzC1q5HBtP90aNKN3CDs3nbXtEe+c4LOFwrmHuefwjAKZEE5ierstAr2ckPjIDW9THgqtIdmkd4iaWKk+o5g4jGn2zUvKyMmfkBY3NiuhN+O0mQcUOP9Ao26HW2O7gOIXqLzUfF2hV3IWBSNF+vKvzBaY/WVs+zCFztvlMTzU1/zhiAsNIMhRg3SEDcHm4DM0GOa4JFfclkT5tBoIhO45CKznMgT70JUbkccBYCYNpW1tJl6ybI/rTRu2VkcePsY3UoOI47HEAvF5XDzoQG3271UYZEdW74Pf7xMF7AGAjEW22MXoZZyJv+FPJn4ryyz8+ZwktHB3MEwlcjAGanDammOPFCfMVwBWLwfxj8Q020qPr4Pi0IddhJgwJEOgO4B6qVfh7xXiO/Ui3U2O0rMpf3VTEzAWCDy7wDICAGwyj1LbWQ1mfeQfjayudpQwuf8R2yE4YZQ3jDDrW7dFQRGzTEFKGYqrHO+AoY+o4oK7tEScAWs47NzKvFmIy3YjktJTL7ibtK9uRTyFe7twIV2BfXqA034TxedWIhT7R6z8EByzJoAeb+xoPWlSo349WR1LkUlOHQyLiYo4GXTnKbuZYlveFdcXXUaH31tB5E4vs2BYywNkWMg8P1v2TvHJ+buIJsFu9uIaVEHBRhHlJQ5FsEiLuztpkvhUX+rtgNSh+yuf3rkBFrQ4Ne5rZb3twF0
 H207Q+sG
 ZgnzjZxm7o2TTucLd+EmILLeZe8HwO3C2NJ2yUw2zr0XiUgQI4dhxNTH7fXfTrpTPXBPgiZ4MomjsrTDWx4yUt/xQoPziyi02iCK9wCtE73+yJAIhkNLIyB5I3v6WCrF1cEsh/4JucHo7e9yTYMMYCC2W0tG/Hnf9N5idEh6YxoqogRlCSgEmmhpCiWxXu24ZgYnYfOu9JIOyhYiUiBTnhlPKdS0lIzHwHnsHy2w9UaO/W8ZClLskNLzHLrydSp2mRkVx5IeLWsJW4pjGWGHSbs+8G8j/TfGCA10l9CwWUn2a6w1ujj9SpN5KUC/oG09+XKBh3h44TyQxiGegaLsePdV3NBO1SOQMdYX4V+zVIMAdOzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-18 11:53, Dave Hansen wrote:
> On 6/18/26 07:50, Zach O'Keefe wrote:
>> Overall, are there any particular painpoints you'd like to see flushed
>> out, first? 
> 
> Handing exceptions in the kernel is hard. Period. That's the pain point.
> Just look at NMIs, #VC, #MC and the rest of that mess. Just look at how
> we've moved away from ever taking random page faults in the kernel. Or,
> heck, randomly taking faults at *all*. We've concentrated them in very
> specific places, not in general code.
> 
> Now you're arguing that the kernel can pretty much take a fault *AND*
> allocate memory reliably at any point*.
> 
> I just don't see the collateral in this series to justify that claim.
> 

That is most definitely the zeroth-order thing. Extraordinary claims require
extraordinary evidence, and this is certainly an extraordinary claim. In
addition to the *massive* maintainability issue, you also have to consider the
additional overheads you will now have to deal with in order to avoid deadlocks.

Almost every OS that have attempted to swap out kernel stacks have been known
to suffer from deadlocks under very high memory load.


> The NMI entry code is a disaster because NMIs can happen anywhere. The
> #VC code is a disaster because #VCs can happen anywhere. Once #PF can
> happen anywhere*, why won't #PF become a disaster?
> [...]
> * #PF on stack accesses isn't *quite* as bad as NMI or #VC, I'll give
>   you that. But it's still pretty darn bad.

In some ways, they are actually *worse*.

#PFs need to be able to sleep, because the common case for a #PF in the kernel
is that it touched user space. This means #PF needs to be using IST/SL 0.
However, this is obviously incompatible with handling #PFs on the kernel stack
itself, so now it needs a stack switch. In the common case, it will then need
to demote the #PF back onto the normal execution stack, which is complex in
its own right.

Now, if you are on a pre-FRED system, the IST entries don't nest, so you
absolutely have to make sure you can't get there again through any means
whatsoever. With FRED, it isn't quite so dire, but it will still give you lots
of fun if that interrupt is one which would like to be demoted off the IRQ stack.

> It would be a completely different story if there was a track record of
> finding and fixing bugs in the x86 entry code from the authors of this
> series. But I don't think I've ever seen a single email from your folks
> before this, much less a review tag or a patch. I'd be much happier if
> you got Andy L's blessing on this, for example.
> 
>> How would you like to proceed? Would explicitly marking this as an
>> experimental config, in the interim, be more attractive?
> No.
> 
> The enemy here is complexity. *Maintenance* complexity. Being able to
> compile out some of the complexity helps with debugging. But it doesn't
> help maintaining the code.
Indeed. Paravirtualization is a great example of how this works. The PV hooks
in the kernel are still a maintenance nightmare 20 years after they were
introduced, and mostly that cost is not borne by the people who introduced and
benefited from them.

	-hpa


