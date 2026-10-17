Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31B1CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 20:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484196B0088; Sat, 17 Oct 2026 16:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45ADF6B008A; Sat, 17 Oct 2026 16:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371A56B0092; Sat, 17 Oct 2026 16:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDD216B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:50:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4E801A0338
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:50:13 +0000 (UTC)
X-FDA: 85333310706.08.D9B0D83
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0849B40004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:50:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BCg9PmmB;
	spf=pass (imf04.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792270212;
	b=YtUr0Zk7SVg/Mtf2MT9ZLaDsQobIg5pHZkLnePFt29TiiSd9ERfFciMjNOIaEZuBgULjsT
	UzWvOmT2oaYtGuA5skyDD774StDzHYWVHtvzcGSqSDpoewmCdFnSdbzeAag+0G6naIHCVu
	0/lRcjtKekGOZ1zqi8mCjJOSME/Hrow=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BCg9PmmB;
	spf=pass (imf04.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792270212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qZHrdlpg2c7fRF8cwibB2f/gGdtuHYzLPC3S9g2jxJM=;
	b=mk0KpSS3XrNAWi/ck+r4/JND60KYv4fmUbPxzfaoRJwR+PiGRmiqE+4g05sVVWmPRu4UEl
	/qDgJfN3QiSzKyNllQCOOScZyhLg0ELkcSjLnQsbpz/4O4VgAOqVK67EGmRdvWWe7S5Q7G
	zXh0NQTlbplNT0sBtUyVeXE7sJ6qmko=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6af8620a7d2so1057051a12.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 13:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792270210; cv=none;
        d=google.com; s=arc-20260327;
        b=oaw7qO3X9fPg6tC0kfharfgY6mT0Sh80Z5u6hpvMiPRWRPr9S6fWqhRTyh04ILnSdw
         B44iDrDr3gM+ye5Cwrec0LqyOqlD0MLv83C1NqmFXE7UUSdG9jMUbeMZNOzZRBL86NLm
         oroQjg8mC2kzEwu47j4jX6aSa9yC8n+wb5zccX2wvbh4XWVfmKrHfo8jn/WOi3vvTmVf
         nK87GjTr8smDfWI1lH6mOHh+YN+BeVH/a8Yoc1oTIuiCWDvD4q37A5pNt2kncQKZTQgG
         WObA2ZmuTR+GubHA+m0SQHo7E32CoKBnSGo6ybVo3OvIyYPmBP3OwcIaF/bt6zoySPKj
         7qxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=qZHrdlpg2c7fRF8cwibB2f/gGdtuHYzLPC3S9g2jxJM=;
        fh=Ngtz05y1ntfRkVyixgiR6tu17NmtKu0TybINZ8ivWI4=;
        b=dMxHQiP6XPqZSnXzNhvQJZmPYLzf/waa4yN7TLavNU0huEnmoOJYrNBYJKGMX/QJt7
         735oATmFc0SMlndYNl04J3/8Wjrg3XBaluH0hL87/Sn9FPcMJ8mK/eFTC1oqCYNfr05u
         MTn0oeYsTQi4mmG37V/dy+1Qxi1qVg6qOyIbQ4qx/PdYwFqpN47D+mwtvqP8ysJIrfGb
         Ej8qTLvDxuailzBECN+tytlF+w1eUtib/QzrRxZgk8ziVA4rPO3f4AstXFZDFX5UdXda
         vMlVKm1SYmav5HmuC7zPumSfElfdzGYmXxRTyBJ3A0H1gdlVIqMErqG6JYSfv0AgEp90
         XEsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792270210; x=1792875010; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qZHrdlpg2c7fRF8cwibB2f/gGdtuHYzLPC3S9g2jxJM=;
        b=BCg9PmmBhiYtb3Ni3VgY8sdDGfGuxwQzx1oRNflegtPTS+vYXoqjjIC6U0OLQHy6ld
         i6i+EXKKofJCjG07M30RlD3Xw9UJhRLLlrTnIQzGKe13qusHpu5+8tXBwMHmdxoX8W5/
         RpZOANxO9dsKTv2irZJimac0Lcmb7wCzmlqQH9QzSEGyd/QbTtCVFCrRmzXLLPkAUlJ0
         +TCn3Bexjd8kX5dExptvEu15Qdk5wEmFizVowpiTyPAoppJhPCbvNRP48/gvh0C+k2UK
         6lEoD6bCChkCbi5VEcYdEL3WfjHpXBeFczGfIDyeu7Yx+vASGqn+1yj//T9MGBniri3b
         +y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792270210; x=1792875010;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qZHrdlpg2c7fRF8cwibB2f/gGdtuHYzLPC3S9g2jxJM=;
        b=X/Lhc9f8Jm7dyFKkF5q3ceDBWLKhCNQPGujKoaK+qfHK0kbBAoacAkap6yzus4vrfE
         FTcPRkIO0A3fZpXeHZ/ZDrU1eu763Ev5eZy7lqhzNAGb4Sz3yEvTM7hvWMlMzZRh7cSS
         8ZrfnT0ujafWw7tk8sgDoP+Y12UHuiFv3owEx+4vb7oFh9L/zYkkwUbhJ2tpG5GF06UC
         V4cQJmkgdDVEf8Quzx/rArdCyyY/2JnG5JPpQhHOh1wuDLCItZgTaWTwLiTQeAfK97T2
         7asEbaEB4PE4DGH2yHbEfTV55bOFsFQ25YtvTyl9PTfbzspIdFhOtLunY027z634xJkf
         wajg==
X-Forwarded-Encrypted: i=1; AKwUvBzIwh9ohg5og/j7HGEmIuLPttvZ4blpxHAAoTrQ/KprsVPXE5Or10lCBQ3pP/hAelt1K4k5Cr5kew==@kvack.org
X-Gm-Message-State: AFq9FYJ6ZuJqHK0dNy1Z0TunBc/HttlTwhQyawAsK8uk+pZJ3q+ghz2/
	vhF5AbK3p90rK/dKS03gLufyE9/UDn9FBv1WVfIZv/Dk2EN1OiqjnkEs5CfRf+4p8bfQ9bueGes
	ld2DeLkkfdjvpjzgLp/ZQjByGB7fT2Q==
X-Gm-Gg: AYBFou2oZP8bvUdrC3sFneOJ7n3IdfLsFqlWIad1ht0D4GGeXY7I64tw8cklq6E0IFX
	Six19Tc6kKSfQXXM+Lhkqb89pi3cm2Q3CSSfzGJq7yjD/jsM5yhWmsj5x6XXAfc5ttrfJyffYcN
	mAPcsDTfpvmf6Wvdcil1kXhbxuT7xVXphcV4s1c4HlY+9h8EkIh/xmmukvNgWAAW+rTQpAvbhoY
	/w8QsEcOVO6mOuDY82GU0JmiEcUt7cA2or0abGZwseKcWtcjmIlLcebKx0V3HlERyYnrAxKfO+z
	RAIze/djvbOiCmYEXaik90XMRVgLy2Pooii/xA7aM0w0OXw+2G/6aW4b8614woVCpDSEefeY2LH
	jRz0Rpalfp4LHis8lYNB3PXWSyMQsiBC16PySdg==
X-Received: by 2002:a05:6402:4493:b0:6b1:c355:c7c0 with SMTP id
 4fb4d7f45d1cf-6b3a818625emr2086508a12.26.1792270210310; Sat, 17 Oct 2026
 13:50:10 -0700 (PDT)
Received: from 101988054943 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Oct 2026 15:50:08 -0500
Received: from 101988054943 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Oct 2026 15:50:08 -0500
MIME-Version: 1.0
From: =?UTF-8?B?6rmA7KKF7ZiB?= <malhyuk97@gmail.com>
Date: Sat, 17 Oct 2026 15:50:08 -0500
X-Gm-Features: AclHuK98htDsGLyhHxZeCUn6CoXjrtTYl7DXMFj1SumaMt5tih8Ob5tGwdm0MXI
Message-ID: <CADQRuqvXQ=YE=7T3oR66vTxE33pi=ygEeZKPTOU=cALZL0Figw@mail.gmail.com>
Subject: Re: [BUG] mm/huge_memory: lazyfree THP PMD restore races zap_pmd_range
To: xueyuan.chen21@gmail.com
Cc: akpm@linux-foundation.org, david@kernel.org, lance.yang@linux.dev, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000003a27ba065e0f6df9"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0849B40004
X-Rspam-User: 
X-Stat-Signature: fwnmgpq5ikoma9p1tcoed47b3kfog68i
X-HE-Tag: 1792270211-194753
X-HE-Meta: U2FsdGVkX18+QgShXbmsV64BdTRnzrz3kNJxis+3tRlymVy8L0tTRiq4DZnW9JhbIAYWDN9hrs/KAp9iY2WnGArqgrZV7/wxZ2AWf/k5ELtljZijDPWiQjkwPiRxDWeR7j1Qym+oQ23BIFHq2LEMKRudba5/Y0WGQyl3HcyiSrGeQnGv5RAq5WefjnNN+SZQSGyDTFuB2rNkA2BadfJvYxtDygQdq7fdw0TmDgrphdcV8ozpDfqH8Nuub/xeagrwXY+DVOWlUYkvNxceu83Ekr1Bd/KfHtvnfi4UTREA46Qv6j72aOkO1oEwefKekhunBSNvu3OMeoKnPHOkn8yPwERzBsY+xhE4eWAT8dbCAVw6M/gtSN0PqquyxdxwVvcLFx2WcjbAtA97SZUGi7cO8RJlvUkkrMZoE5sHpB/M3LvWVUhvKgTrGBthnaohLtnABcEzp8HDeFADpqVyimUxuh7tslfTANjtz0NK9s6nHEtAWqHLO6aTcoUU7TE5PNmYhtqf3331QJTnBT3Fxs3f5PHXe3+9d8Gpr1oFdI9L6syb+pgHeXgjLkCFxFatamGjwMAuUbnOVNtBn1DDmGsxTKL+1qOe1sgVx7BZY94n725NFgUoNumFnKFjwFJePRQ5YXKKgqNY4Z2pjInnC+RzI9PA+fn4lDMtZaqnUwdbEnrfNSm6D0VKzhCaqKl6GP1i2L1ziu0kKhPJgxb2K7cxcI296osqL4tE2WwWiNR7ZByZRW9YHG3tKGnjCpPfOXq7cf9mqXBMmznrSc9ADHH6VYeh97GcRNUqZWUwBiZWhvr+w0j7MlwbPanlHcXf/L67CyB3J0UIOFggj7k5Es7Sr83WTouEehrr8T2TsqvAZiFgOiDz/8P/Iu2YM2lYVlJqDAvJ4RVfQW+Xy+ypk7HJeN/t9SQx7pAz7ug3XPZEhGz0+k+GxQY4QvWYL5AcUxhvdrD81iQclt8CGimH2QZ
 txf3kpqR
 I6cBv+p+GOTG3RBgdITWhBVk0ej9x4w+w80e7vCQ0PgGsTZKAiquPQdTha9FStQR+z8PKcNRPxCklIgLB9CCWPC/4EId8f3SRv3Arc6+XwGB6zqMJby5A/OTV6HyTRNX3U3QBh4Pc22PmrnSJ4gd5WWVHZsodczjF26PkIADTmLrQX/e5A/EVeHyI7t2GDM6SG4JfZzTXJ08vUjHG/SEja8DolS3vCtkCoZC3lmfetiqI3DwR2yfD1kfgTLqZVPKISgxmnQfpiJqwgKTlX2VdhHCOg2ssbkuThktRdRPRlIebUc1cohKJJwBrR3wpufdF5w62+vRA+LBkv2bXh9ntmRV/y0RGzB49lB98AIz96N5VDZgyXI9K+FSXInI1xnvK+b+C6dhHzEt5eiIVlzxvCyJi3LyVCBQLLFHZ/FTH3CUseta2znYdwMo7J1kiJ7pHfDfW4wUFTjqF7mDh4p2+s4KvljFnlv1tih28phLLVbhGp6aqOmHNGt3EYBf/z+nEfidRt/n9wXTQllBYZVMLGUATUDKPJ9/9ccJfWo+LLtCN3x+QatY85gyebOPcBdCtjrZjosUrYSp+BwNN+ej0+0LTYrQbhEIimfZ2mxd8Varb7zVtOcL8FzRQneHw6LyIwQ2NspkXYbrUqE4WBjqJafdkT4jflaViA1verbroB50AbL1Lfv3mY3sCt7iol9jVVrjsAJGJHIWfCszkX8xxNmePTeCekjnnar8HT5+mwu6bqg6fo4ExAf+JPxRc2pMygZlOVHapzOXNPDEf8MbZ8cLmV6743xRpCrN+RvcWnPrOwq3neHXSk1qMoODZkx79dsNmaig3WCsGkzTQ/Udn/dqeDO36cFbZKpnIB2rIR0is26NwSmPc5yDNl0wLfZLTNEnh0vIsxQ+pWwhAoacBLNmoO18KoPPd/3YDuQGDcdwmzx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003a27ba065e0f6df9
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 17, 2026, Xueyuan wrote:
> This bug should be fixed by:
>
>
https://www.google.com/url?q=https://lore.kernel.org/linux-mm/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/&source=gmail&ust=1792356608487000&sa=E
>
> It is already in mm-unstable. Your reproducer would be a good test for it.

I tested it. Short version: it holds.

The hunk does not apply to 6.12, so I derived the equivalent deletion
rather than forcing it. 6.12 has no folio_test_lazyfree(), which
upstream defines as folio_test_anon() && !folio_test_swapbacked() -- the
same predicate already sitting inside 6.12's unmap_huge_pmd_locked() --
and 6.12 has no "goto walk_abort" after a failed discard, it already
falls through and splits. So the port is deleting the
unmap_huge_pmd_locked() call and its goto walk_done at mm/rmap.c:1701-1704.
Both trees end with the function defined and zero callers, which is the
state the commit message describes.

Two kernels built from a byte-identical config, the official kernelCTF
KASAN release config, with only mm/rmap.o differing. The host was busy
with unrelated work throughout, so I interleaved the arms one for one
rather than chasing a quiet machine; the two highest-load boots in the
set were both patched ones, so the patched arm did not get the quiet
slots.

before: 6 of 6 boots reproduced, median 9.6 s, 2768 s total
after: 0 of 8 boots, 7214 s total. No KASAN, no Bad rss-counter,
no WARNING, no list corruption, nothing.

Three of the six control boots went on from the KASAN report to a panic:
general protection fault in down_read_trylock() reached from
folio_lock_anon_vma_read(), which is the stale anon_vma->root being read
after the slab page had been recycled.

Coverage, since a clean run proves nothing by itself. Both arms carried
identical kprobes and the control still reproduced in 4.2 s with them
armed. On a dedicated pair I added a __split_huge_pmd probe to subtract
the non-rmap caller and count the fix's own branch:

unmap_huge_pmd_locked 11960 (before, 150 s) -> 0 (after, 300 s)
entries to the !pvmw.pte arm 11960 -> 27441 (300 s)

The patched kernel enters that arm more often than the control and splits
every time, so the quiet runs are not reclaim failing to reach these
folios. folio_lock_anon_vma_read is 3 to 5 times lower on the patched
arm, which is the bug's own traffic disappearing: on the control the
leaked folios get walked again on every later pass.

On how much weight the negative carries: rule of three over 7214 s bounds
the patched rate at a 117x reduction, and a hypothetical 1000x slowdown
would still give eight clean boots about 70% of the time. What argues
for closure rather than narrowing is the zero on unmap_huge_pmd_locked,
not the statistics.

One detail from the runs that may be useful if anyone wants to reproduce:
the vmsplice pin makes 97% of discards fail into the restore path, 375
succeeded out of 11960 over 150 s, so nearly every pass through that code
is a window.

Tested-by: JongHyuk Kim(MalHyuk) <malhyuk97@gmail.com>

Thanks,
JongHyuk

--0000000000003a27ba065e0f6df9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><body><div dir=3D"auto">On Sat, Oct 17, 2026, Xueyuan wrote:<br>&gt; =
This bug should be fixed by:<br>&gt;<br>&gt; <a href=3D"https://www.google.=
com/url?q=3Dhttps://lore.kernel.org/linux-mm/20261012-lazyfree-stable-fix-v=
2-1-6387d6e30063@nvidia.com/&amp;source=3Dgmail&amp;ust=3D1792356608487000&=
amp;sa=3DE">https://www.google.com/url?q=3Dhttps://lore.kernel.org/linux-mm=
/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/&amp;source=3Dgm=
ail&amp;ust=3D1792356608487000&amp;sa=3DE</a><br>&gt;<br>&gt; It is already=
 in mm-unstable. Your reproducer would be a good test for it.<br><br>I test=
ed it.  Short version: it holds.<br><br>The hunk does not apply to 6.12, so=
 I derived the equivalent deletion<br>rather than forcing it.  6.12 has no =
folio_test_lazyfree(), which<br>upstream defines as folio_test_anon() &amp;=
&amp; !folio_test_swapbacked() -- the<br>same predicate already sitting ins=
ide 6.12&#39;s unmap_huge_pmd_locked() --<br>and 6.12 has no &quot;goto wal=
k_abort&quot; after a failed discard, it already<br>falls through and split=
s.  So the port is deleting the<br>unmap_huge_pmd_locked() call and its got=
o walk_done at mm/rmap.c:1701-1704.<br>Both trees end with the function def=
ined and zero callers, which is the<br>state the commit message describes.<=
br><br>Two kernels built from a byte-identical config, the official kernelC=
TF<br>KASAN release config, with only mm/rmap.o differing.  The host was bu=
sy<br>with unrelated work throughout, so I interleaved the arms one for one=
<br>rather than chasing a quiet machine; the two highest-load boots in the<=
br>set were both patched ones, so the patched arm did not get the quiet<br>=
slots.<br><br>  before: 6 of 6 boots reproduced, median 9.6 s, 2768 s total=
<br>  after:  0 of 8 boots, 7214 s total.  No KASAN, no Bad rss-counter,<br=
>          no WARNING, no list corruption, nothing.<br><br>Three of the six=
 control boots went on from the KASAN report to a panic:<br>general protect=
ion fault in down_read_trylock() reached from<br>folio_lock_anon_vma_read()=
, which is the stale anon_vma-&gt;root being read<br>after the slab page ha=
d been recycled.<br><br>Coverage, since a clean run proves nothing by itsel=
f.  Both arms carried<br>identical kprobes and the control still reproduced=
 in 4.2 s with them<br>armed.  On a dedicated pair I added a __split_huge_p=
md probe to subtract<br>the non-rmap caller and count the fix&#39;s own bra=
nch:<br><br>  unmap_huge_pmd_locked         11960 (before, 150 s)  -&gt;   =
   0 (after, 300 s)<br>  entries to the !pvmw.pte arm  11960               =
   -&gt;  27441 (300 s)<br><br>The patched kernel enters that arm more ofte=
n than the control and splits<br>every time, so the quiet runs are not recl=
aim failing to reach these<br>folios.  folio_lock_anon_vma_read is 3 to 5 t=
imes lower on the patched<br>arm, which is the bug&#39;s own traffic disapp=
earing: on the control the<br>leaked folios get walked again on every later=
 pass.<br><br>On how much weight the negative carries: rule of three over 7=
214 s bounds<br>the patched rate at a 117x reduction, and a hypothetical 10=
00x slowdown<br>would still give eight clean boots about 70% of the time.  =
What argues<br>for closure rather than narrowing is the zero on unmap_huge_=
pmd_locked,<br>not the statistics.<br><br>One detail from the runs that may=
 be useful if anyone wants to reproduce:<br>the vmsplice pin makes 97% of d=
iscards fail into the restore path, 375<br>succeeded out of 11960 over 150 =
s, so nearly every pass through that code<br>is a window.<br><br>Tested-by:=
 JongHyuk Kim(MalHyuk) &lt;<a href=3D"mailto:malhyuk97@gmail.com">malhyuk97=
@gmail.com</a>&gt;<br><br>Thanks,<br>JongHyuk<br></div></body></html>

--0000000000003a27ba065e0f6df9--

