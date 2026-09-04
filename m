Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0C5C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326506B0088; Fri,  4 Sep 2026 06:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D72B6B008A; Fri,  4 Sep 2026 06:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5BB6B008C; Fri,  4 Sep 2026 06:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA8526B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:09:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B1A11403F7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:09:22 +0000 (UTC)
X-FDA: 85175657364.14.8E5D1D6
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CC06100005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:09:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOyVEa6c;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkDl0Y4zNUnFCr0BpcsL/xKlNTA0whYo8hcoWC1r1Ck=;
	b=epDyl09Uf40cNEO4LUjand3r7q/TOqDHmOYm2KdEilDkvGGqpnnn7eSj/P+Vb0GrZGSmB4
	J3Qrz2OVk5SrS28P5/XCuj03yIK066dLi/cU+BL1ipOJ/v5wV+LHNQeWeFkjL0Wsv6bWRN
	4sanhZAtFqnF5iWzmno5JilKN7x3slc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516560;
	b=T/uXW/N90DHOjnegplhc+PfYd8PpkC24pauwDjkeJbfJr7U1GoWrZ+Jp+XSKC0v921t1JS
	9uDFVq8XQuOaJ874zv7cJh2Th8TQkKVFjz5DXxxfUGPfqFXPqUZWRPRNRrk4Vlk4V2S9rx
	iYCVRQjT0Ap3nsPdpKld238ORBm7dz8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOyVEa6c;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so1078699a91.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 03:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788516559; x=1789121359; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zkDl0Y4zNUnFCr0BpcsL/xKlNTA0whYo8hcoWC1r1Ck=;
        b=kOyVEa6cqrQ+GJn27Jyv0JMbyKeSVAfyBzz2xdsTEWos4BwQ3AaSs88U3SZ1gwOhNm
         P4x2SRtr7drRdfSToqBv/gHj/Ei3ZwBsSnvGw87v9R02CDzSD7UDFZcKGS/wvc2Qlf3O
         2oFApCwNj1CU+AlSoJ4yyNvoZslDNL6vrOO7BR6W6wC83pkGaKOuWdHv2L+Ta1dVDmk9
         zGy1r2VU5mhBHTcYtYw2/kEEUosCVHYyG2MP9q9r9NT4t1l6G92xWSE5Vhu4TRsD/F46
         emN0EH8HJXTDUfsX8h0X6ErpzxyyCtqSmhdZwgoq6y5pyzFPlB+3v7hW+TXVemDhzQcG
         kB9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788516559; x=1789121359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zkDl0Y4zNUnFCr0BpcsL/xKlNTA0whYo8hcoWC1r1Ck=;
        b=OZiZv0oILs3sJ1a4heXa8i2bbFlcADaDd5O/1fnG9/7lqO39PXxgCglO1FLoGomtKe
         6L6JNRGGTmGdwsG8AM0jQJT34tCx91Si39UlZxLNKlQfyTVZ8e5Qqhquwx3WY1jto/0H
         Irn5EPT8MtIw9e5nOsP6M/uk+Yzdiuvxy4MAo39QG1tQADaTYiQbZMxjcC9dDmSCUpGu
         1T9CUYkzQrS+jzHx2MOmGJRiHtm4J36zfyGts8iRpvAY0NoQKDtuQW3Guu75Ti/CdYM7
         nCcwEY2WW609xtNoKo+0q2nBuqfNbDwrQXD3X/W0GXuqRAjW7F0oIPpnQ60su7potArP
         uLNw==
X-Gm-Message-State: AFuF++kV9+pHAVfOgKVythIEpqYY8PMPiCs5htTAMJxatJPkGiBv2H9P
	GTnNASp/XT9K6mqwLTLua1EKWoTfu78xBZK2LJPhjc7o0L4mSCvFPPnv
X-Gm-Gg: AYBFou2cVF9hD2vJGlCPC6ry5Gw/YvMRfwjscIZHo2JvDNGJ5ZGT2j0D282biyr1uxA
	9PjcSO+zO6K2yXk6QItn7zumaTbF4azPiuXMhRwhfPhp2/KyLmfRcD918Sg+Aulc465bPGGqxWp
	9DSkICU0bOspPblf7/AAW5YOWbWpAds39orP1HJZ4sLR2Dp6jq/LuJVmrhmkFgqxehOaAE3uahZ
	dLe30ey8QHnsOMMcS/RfseslHJ0VRcBOkTnvCwjhFi09lwsV/llurPlpoFPXfwDSYrcgJ6/T7hA
	RWfSfDpa18lPKjyaCMXC13OU9jSY7SRKg4Lf58o8tXPPFecEKHYMThOHvBuXvTCMU2CIBBMEa6F
	4oMZzNi3HMYH2mpy7k25GJfgYG2jxX9EO61Yh2rsJmbO+E9O2nEsGNbdrQlo+bEUhz0e6LefYu+
	w4nSzlbMxDivGJJhDp0DfCqAVeYXG4NIxHvIVy0ETk9j8/5VfBO/MYH8BAd/uckUJrQsvF8cYf/
	XAT76hLycar+30X15xOg1bu2+cD
X-Received: by 2002:a17:90b:2b43:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-39b25ed34f3mr9006849a91.0.1788516559196;
        Fri, 04 Sep 2026 03:09:19 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2612d3f1sm3692904a91.13.2026.09.04.03.09.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 04 Sep 2026 03:09:18 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 00/13] mm/swap: introduce per-priority allocation queues
Date: Fri,  4 Sep 2026 18:08:49 +0800
Message-ID: <20260904100900.21517-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <appvhlPleahTRklV@yjaykim-PowerEdge-T330>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com> <appvhlPleahTRklV@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7CC06100005
X-Stat-Signature: q9ags6cjj8581jjqxnybqudi5i53xsay
X-HE-Tag: 1788516560-396433
X-HE-Meta: U2FsdGVkX1+Pk2tnlKHo1HRwhFOQF9PagkKF03B/4tLTBmhCz8/wsJiNUxJgAXAtJCVAyfaMBVKV9tdQ1Fk9xPKAuCQNkFem3DWP9fM20/gHpkOy/G3P13tNDe0ZG7/vZXZ920fZRv3QtRpb60tby2TLuercT6ABSIIUaviDNh8XHmhYzHiRW9UclfPDhRMJ6ZR03joa7Cqavx7fp9sfzqCc+imJ+ArbfnikXG0y9HZcmQM5S/scsmzOJsIPeTN2t4NCnpgcd7/FrdPOaV5samuN93OM60owoKeqFsu3PjnP/SUhma8sxpn819q94rmMY37MZCg4R0RWgwRnifjBMzF94D4Ji5BS8quNwZGALjkRTRbUS3aA7ewUyBz9cKlU2BFSi1m7zJaPU8ZINRsaNZjLSrj09hOw8bJ4nfAlYv5q0JOxYwhc4JI5QL115PivJYxL4ARKH8ii+K9e4cFAwGsQAz9L+MoZUuM4UqlQAn7M8KF37l3M9eddQjTSozXuF2bTnczBH0k84WK3JsUf/x+OgL2rSHQyT/s/WZ2OzN/798Aco4X1heiPLeEwG8I4583tBAASP7XADjaG2gGBevQGYhHbvSzE3DD4RzgZkLglIp9AR3Qc6q1BYrlyI4bFYMZjh5feHllBJQeCssmPCMNQNv3ugv1HxijtCgLELY/XAjVursGwB6ZEz0esfOJi+QpOTnftuaifpB02S2P7k3fldxwE/+df/A/d3z5VdVHCci0xJlJ4fNMaKk4U9u7RB/NVenCsZnxh4kkSW1xdfL1BQVB7f4emNE5KtT/q2VF5fGUySdaZ7q9+zk6YIbtzd67FvM33Vo+imUbOJ1eKf91KQcHSdddQBoqcfGRDMlTiNj1bi9v9QR3v0Cy6Lhe259BRwVF9JqehPXA3kFBNaeyec9DNVXpMgyG5NQVmUAoUpcoDCK9Z1ytm0dj8lP849SgblS+Zx7ja2S9Nkkc
 MabqMzlc
 JuqM1OLcV9u/YTZ4fxJ/DfX+497XCvFZ15Wd56na9rR9UM3v2Ngm8XXeVmRAQxkBtVanxBYvjx40aEBzWGuy7VxRZfgja71SnjTOKgoYwnv2L0O3ljAOgWqC4fO42eOdufWpaR4wGJD6lsjXG5Rk1Xxu7BN5ac3Q/Do9KegiiKz1rJiqTQsp8gUNBMOzflQHllvh1JWw1KibuVleoE2GkJwFBm5vCl6M3xziF3TN7uPPmu4tJ4XhLKlSk/Aez/Gg1Z/hdyYNxmQ9inpHzj/aevq6na2lHzOcdx+tZdVY81rZwlp5d0ZSzb0H6LYZpAQ86EuMQ2kAUHCpq3Qrhy3MJV6dHB2Sll8HBKUd8UAuTtlSC2KZEQCWxjGSAiy5A6FAgcyXmAhaHq+hyVQes1hboR2ygtfhbSciR4Y3YQnhXqVxvp2N+o/wj5Wc6UFOCK+omskjggcFHAMoi6uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 4 Sep 2026 16:13:10 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Since tiers come up further down, I'd like to raise a point about the
> patch subject line too. As Kairui mentioned in RFC v1 that we would
> stay aligned with tiers, would it make sense to frame this RFC as a
> per-tier allocation policy (or something along those lines)? Kairui,
> what's your opinion?

Thanks for the thoughtful feedback and for taking an initial pass over
the series.

I agree that this queue could naturally become an in-tier allocation
policy. For this RFC, I would prefer to keep it separate and scoped to
the existing priority semantics while the tier and virtual-swap
directions are still being settled. We can revisit the subject and
naming once that boundary is clearer.

I will also sync with Kairui when he has time. He has several things in
flight, but his view on the ownership and framing would be valuable.

> Devices assigned to the same tier already share the same priority, so
> I don't think the allocation policy needs more than one option for
> that case (I can't think of a use case that would need it).
>
> 1. For legacy swap with no tier configured, define it as a single
>    priority treated as one tier.
> 2. When priorities match, allocation naturally falls to a single
>    policy (not a queue). the concrete policy here is this
>    queue-based scheme.
> 3. When tiers are enabled, devices previously assigned under legacy
>    swap are reassigned to tiers at runtime.
>    (This means different swap device on same tier handled like same priority device)

These are useful design points. I would like to study the concrete v11
before deciding between runtime, boot-time, or compile-time tier
assignment. It seems safer not to bind this queue RFC to a permanent
tier interface while those semantics and the virtual-swap backend model
are still under discussion.

> I think this feature will also be needed on the virtualized swap side,
> which makes me wonder whether this patch should go back into the swap
> tier series instead. Kairui, Lian, what do you think? (Or separately?)
>
> I've also been thinking about how to move the tier series forward
> since v10. I'll prepare v11 shortly.

I agree that the mechanism should be useful on the virtualized-swap side
too. Once you post v11, I will study and review it, and I am happy to
work with you on whether the queue should be rebased onto the tier
infrastructure or remain a separate policy layer.

> This is the direction I was hoping for. (TBD)
>
> Within a tier. /sys/kernel/mm/swap/tiers/<tier name>/<policy name>
>
> - Across tiers: allocation follows priority based on speed
>   differences.
> - Within a tier: a selectable policy applies.
>   - The default policy is this series' scheme.
>   - Priority-based distribution should also be possible within a
>     tier.
>   - If xswap is introduced, its allocation should be selectable based
>     on memcg.
>   - Other custom allocation methods (round-robin, etc.).

The split between cross-tier selection and an in-tier allocation policy
makes sense to me. Keeping the current queue as an independent mechanism
for now should let us evaluate it as the possible default policy without
committing the tier ABI prematurely.

> No regression is great news. the plist refactor is valuable on its
> own merits.
>
> That said, could you also share data on other angles, such as lock-
> contention benefits, or advantages in other use-case scenarios? (I'll
> also think about what would be worth testing here.)

Yes. I will add direct lock-contention measurements, the one-device
case, and higher-priority rings containing full devices. Let's keep
sharing results and test ideas as the two series evolve.

> I've done an initial pass and given my review. I'll keep providing
> feedback as I go through the patch contents. :)

Thank you. The v2 code delta from v1 is intentionally focused. If you
find any problem in the individual patches, please let me know and I
will iterate on it with you. I also plan to spend time this weekend
studying your recent v3 swap work, and I look forward to reviewing v11.

Thanks,
Lian

