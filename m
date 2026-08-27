Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF76C5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B806B0088; Wed, 26 Aug 2026 20:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCB96B008A; Wed, 26 Aug 2026 20:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6E16B008C; Wed, 26 Aug 2026 20:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE636B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:11:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC18640265
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:11:15 +0000 (UTC)
X-FDA: 85145119710.16.8666EA4
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCE4CC0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:11:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xh9wtB7d;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787789473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnLRTMnfrf4Gj+REZ5Itvxt0IiZsf+yGH35mZtX0wjs=;
	b=Bp5hywraLzfTIldhxsXTfmV11qF1QTyauoysz75g+Il7umUMvXWD+o2rILRTSOc4syUklM
	NuRcrfC7RzDsv6uGJtlMTwE0rjRFzdpBbEF/MZ3LIMAl4u77DPpJufqq5DiXD/2IOIr7al
	tDsJSvcQ4yABg/CNo8+xDDJe2FCyvRE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xh9wtB7d;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787789473;
	b=0g4lsPm/KC0dTz2lYhO6BxI0TdKjA67NdmPtrJbKmRdySpeHHRk8RJiW2KAN+PSGZNkhMP
	q5/wTUX6Zyb3joOFB9vLwH6Nr23N3S4g4tHjtHj/OHiE2gtHaQt7+0qxRmM71I0i0Vlppz
	TYk53WGcaDAYvlsdx5MRJLKtxubIfkI=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90cd43bd740so4378986d6.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:11:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787789473; cv=none;
        d=google.com; s=arc-20260327;
        b=LvBXFTDjEIwIV8pq+Zol18I5JEYz/SXbLIXPW7Fkori2E6Fkbe5fuD0AH36r/MZbe0
         y/YnGWWrMCB9+HjIJerDkmhmkKULeScKU1Woo4iA97BDv+7T3E+NDtF4Gn5Rd6yzyFAr
         T/07y2lv7YNLLHa2XIbEV50u1k0fqSbMEQkoxntrzOXcBJhcHsEy82d8sU1UmFEIhemi
         jBtUYHF90SFh52qC19uSPRlQNgqqA6xdXtyGeku1ZspJ1Rh4lhwohuj9Vok16gTgJt/5
         d+Qd7t8BH6KzD5/KmDLe6OXAb6M8OgzvBDIP0hataIpKSG6xJBsp5IQjzTmDZP4ZAbBC
         mTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=AnLRTMnfrf4Gj+REZ5Itvxt0IiZsf+yGH35mZtX0wjs=;
        fh=Fnb48MIz3BnoYijiTw8+JNnKFRN3lW0vC71J6Rxhgj8=;
        b=MFJ1o/PwXlLCBbECmCHDnraafG/dbQ36/9YIpdSJJ692IjGr3mZInbLf6Fe6FuOFEw
         fFVx8B7UewvXH9TQ1mydQZcrKTkKfVGawZ9uAiizgzPfWxAq8Q7qgtaCYEq43CckK6h1
         m90oCG6yw1A/jbuvU2P0GnXDxZNUf0s5GoETCN0sC0KhVC/L1FK66Nyn++UyPt2/Q9Wv
         Ti9WK2bhJPqL1ADGk/JbRAaOcda7ni3cmKfq63T25ttlZIS102tzAKHwAThyvxX6Xgda
         +ze2txboz4m3yG0zLRRU2rZjBbqsMFEpcsAKSA/Hi5eUaRjtdmC2fVPV+ztvy6jmHcqI
         SQnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787789473; x=1788394273; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AnLRTMnfrf4Gj+REZ5Itvxt0IiZsf+yGH35mZtX0wjs=;
        b=Xh9wtB7dGqCR9VIW28xMFW+C8Mf81/kDyHlgKGxRzgH/mBVjdLSwRV3IJuCG7LbbWo
         xNh+z8P0YBCk+0+mHuwzsdD5iGF/OH72QU00w/vbC0hmKTtDsFJHRj7Src936bnQEsyI
         kIw+vaHcdLU/08mw60iQEEgB4X8kWpmlpsyFfh3o3aDl4OSgLjj83qNi3DQzF78b9sJX
         UV6NrrJ+zbjjFVUyON2eYTaWvYGN3bxrVny80cWyq4Kb76d90nP9Y+s0Hd5NKO+RQdxD
         ytkZ4dhVFKKUNesHYZlJ+jPXhwgDEPn9mlettFuzyTJEchEwOesP6N3/NuGOL/WiDjcM
         HTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787789473; x=1788394273;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AnLRTMnfrf4Gj+REZ5Itvxt0IiZsf+yGH35mZtX0wjs=;
        b=iO7YgdYszz6lI+oSz+7kcdWCJu3w9VdekapJq/Jftsc4t43aCkaQUJSsgG86DtuAXA
         PWQyUU8tn+5S3za9aV26yibo4M73dpqM5mOwfA2tCOaZJnGNLu2nQKC4T4ryxU8B3LHA
         5lAvrXCvYgPbUIi6u8Q3GDuSzS3GCD5jMLJOFmRSSnViv6V26oruOxA4Mu82HSTj+t+A
         9hm1aoPkOHMPsi4We5mtkcfsurv2n1ugixSaosLHjeKpJoIYHhQN7MXwFQb+qtqkTFFF
         SgsACcO8nFPf2Ofnlkc4cg9oQpnOsjKXmztA/ORAFMTr1CmiuiLTG8p2y4l5FwtyQdLM
         teJQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBVq7LxgJMjx2d4Hh56GwGjStsOr1iZtakr2uKGFvxY3467k4MzgeadxovMJTaMVpeFWsoJC93Uw==@kvack.org
X-Gm-Message-State: AFuF++kZgkbeCFqaSRFuRbG3PGdLMMB8g2DwjCSUr5hty7C1vsDIS4RP
	Qkq+dPNYKS++yV1nPW82UEIH7MQL9sc6WFiuN6UruJHCaPXAhfKYOAKt/hyI7q7qEn2UJesRF8v
	Qgfu31IIf8zpjKXO7tb3YZCaq0ee5iKxoyh3LM8iW
X-Gm-Gg: AR+sD10Ari2+oemuX18lTaF1lFHwl8O4GzfbGyGhC4nTnoiOqceSsmDzL2Ul/5WvukZ
	BFR81nCcVZmegM9nTFtgxKBc1DbwXiTbFtQfrGqj9lr84IykJIj/g2tt6K9itPP1usuaH0WXBT6
	U/I4S25mVpYEzwOTxMNVUVgwbMtjS6iryiWy9sS/Mx67GAJOEKMwIwzLb8tvT3LDEuZK4NsBAhM
	+9ifoaaQDKrx2+zfqBlwqqavwBuci+YC0t6bNBj2aFYCHrtvzGv9f0jY21ASFwM5xhk4QOsY5tp
	DSGLyAX2Hwgu/2o2O5PRrplUo/nL29IOJFVRzoAtVQyKC7me2awaP12aMbtyJEj1j8XyHF5tffp
	CzIM=
X-Received: by 2002:a05:6214:4602:b0:908:98fa:f374 with SMTP id
 6a1803df08f44-90cc7858733mr168107566d6.6.1787789472172; Wed, 26 Aug 2026
 17:11:12 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 26 Aug 2026 17:11:11 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 26 Aug 2026 17:11:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ao8pCI3AaUssIO8S@google.com>
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
 <20260823-memory-failure-mf-delayed-fix-v5-5-d97a5703e45a@google.com>
 <8a99f753-0713-4194-8eb5-90da0724e647@kernel.org> <ao8pCI3AaUssIO8S@google.com>
MIME-Version: 1.0
Date: Wed, 26 Aug 2026 17:11:11 -0700
X-Gm-Features: AcwNN1XfQOKyfEIZtdcwN4-zBTAXGB_PV6TdJFFinygb6qNke6evcDePz3wbfQE
Message-ID: <CAEvNRgHAwAJee6_ra9-zioDh_BqHM9Lbu+TGXxWHbG7za=g5Aw@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: selftests: Add shmem into memory failure test
To: Lisa Wang <wyihan@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, rientjes@google.com, seanjc@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f8j9fkq3jhrrenqbbpsys8ts7be9qicn
X-Rspamd-Queue-Id: BCE4CC0004
X-HE-Tag: 1787789473-154016
X-HE-Meta: U2FsdGVkX19ix88HtTGO6cT8QY/O2RayHPbaZ/ij7ByrTOii4OGB9TOFpbgyZc5VP9O8ViiW5+j7dBP46SMagW2Evv1NGRqgoEltd59fdK2ZfELAVlmeyK9GL3yySdFKXeCNJRmhOXrTw7U/AwrmsjtIJXxzLUCxC+HzFe0lTkG82+f2rvMtREGGQH5upc0ogiq8nuqQVicPVS9dZ7g38OIe+IyJzK7csdbosErvULZzt/b4Ffo8b7436BtRkv1kIH2YqqUfQcUltp8bYVLPkSy6FHNQzPgsIXATrD8ss0vRbaMZMMurqeyH/OxSe/Qb1asvLrh6tTyK6+pDerxw0pYnuPGkC8LoNwu4pBA9l/yujqSulzieRzqqHps8pgFEw1JHPVBo0bjfU0j1fe6ZuebvFpre2+z1vkIuoqoQ15OZFqxQfr1tUlnMCWIVGa3ZRVsaDHxu9JfaOihoNHFzJvCN5Xxz+24579vPrnV2JYkDsfTtgP608vPyZyr1RVSL8Tu0wSdeHOkPVwJ/VQ/yNsbbBh7/qO8M3m013rzBEVU2Z+iZEquLz9rxWuwa3ip0goMB/flCBZNcEKpbUHZL7ExkL2qrb0OVSV+8Zbu1y0nELXP8vXDxPFh+7ol95hB8wLW6az9iW+P8+eXXGcK6l1+54GRcjiZQYzetKxKvIO/5tikmEnBOVP8aDQZcUX2VR2I91GpDd9HNx3C4FujiQcV0JE6rkqoAs5b7D41BoFU2mNshYKzkdwTLGuAQXq1Qu3Sic58m1EIA1HR0UD5gqOQtaJ0/Piljc2eNCCFUd/kftCyvZktP8FNnJnH1fLEM7+pAMx8740mdVVG66BZltDqZtc3rg1q/iLTl0CW4dmhzPb/VmJhVA+owM0ovq9GnMM7j0BVOhKI68iaR2ua7RY3sP1UTRehPYW9E+HAw3KAGA4rLTPEDMENn+cAJhAQH1zv3zR4ZXD7gmeCrfka
 zZpgxLdt
 dIbtzUUDaE3PNOJs5EQRv5Yo92nXT7HAbpB0yOhceRNLX0J0HT3aw/g719CbAPfd5Fd6pwaCGw5l0elJKERPirosyFAnpsk1lkCNEq46UkXcY/TnuqyyHNjIrlcowMb7zrTT13kYK+VBmmhMQGpF+uYYmT0DZKzv9jcrrM+zQaf7FFebcqT+Gz0ySrj5weO84OuomYJilj5gvU+dPhNdXZqUU6Jp/UxyClYchZ3dA1OCHAW91iLV3dxXXK+9SAPte/k6RV5xuuhGjINn3R4O/Uh0xlBuydLd5QzNQShxck1klveVbefH4BOgpEYM4QffGAXbMJEj3EoyMEzZ9+l1aeoqlbyAd9MUvKaN2Qv/tzJf0o4MkbVygZAawCa9BiYFdNsh5YiLm8t0RM9howXT7g9XPdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lisa Wang <wyihan@google.com> writes:

> On Mon, Aug 24, 2026 at 03:00:47PM +0200, David Hildenbrand (Arm) wrote:
>> > +++ b/tools/testing/selftests/mm/memory-failure.c
>> > @@ -20,6 +20,10 @@
>> >
>> >  #include "vm_util.h"
>> >
>> > +#ifndef fallthrough
>> > +# define fallthrough __attribute__((__fallthrough__))
>> > +#endif
>>
>> This doesn't belong into this test.
>>
>> rseq/rseq.c selftest already uses it.
>>
>> I think tools/testing/include/ already provides it.
>>
>> Maybe
>>
>> 	#include <linux/compiler.h>
>>
>> does the trick?
>
> Hi David,
> Thank you for replying.
> Would it be better to change it to /* FALLTHROUGH */
> like the rest of the mm selftests?
>
> If we prefer to include <linux/compiler.h>, we can
> certainly do that, but we would also need to update
> the Makefile and fix a redefinition in pkey-helpers.h.
>
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -37,7 +37,7 @@ endif
>  # LDLIBS.
>  MAKEFLAGS += --no-builtin-rules
>
> -CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
> +CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES) -I$(top_srcdir)/tools/include
>  CFLAGS += -Wunreachable-code
>  LDLIBS = -lrt -lpthread -lm
>
> --- a/tools/testing/selftests/mm/pkey-helpers.h
> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> @@ -22,7 +22,7 @@
>  typedef __u8   u8;
>  typedef __u16  u16;
>  typedef __u32  u32;
> -typedef __u64  u64;
> +// typedef __u64       u64;

Removing this u64 typedef seems to be unrelated, the layers of includes
probably has some weirdness that needs to be ironed out.

If the weirdness is not too complex to iron out to be in time for 7.4, I
think we can iron that out, if not perhaps using /* FALLTHROUGH */ is
fine, to be aligned with the other mm selftests.

>
>
> Lisa

