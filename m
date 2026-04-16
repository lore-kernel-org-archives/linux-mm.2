Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527E7F8D761
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 16:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7927D6B0089; Thu, 16 Apr 2026 12:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B416B008A; Thu, 16 Apr 2026 12:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659D36B008C; Thu, 16 Apr 2026 12:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 534C76B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:26:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC09F1A08EB
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:26:25 +0000 (UTC)
X-FDA: 84664946730.24.EDDA2E8
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0DFA140010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:26:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mlTaS5N8;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776356783; a=rsa-sha256;
	cv=pass;
	b=jm21Zt/z14yDWAJSOeicMV9r4CcKjTaUj4B3JBoWOxWPZVKaJLFMEuiWOa9CEl26bc75a1
	I/N8qcq5zTNUw+ZQaNdJjOUhea/sKyUi1nQZmkySD+cp7p9v8eHj3xVIfJ33OmGWx5o5FW
	Az3mtMC6LSrRIusRMl3BvrbBsVmaCoo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mlTaS5N8;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776356783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiIXqIQ1insAYDWmIOBggv552UAc9lAw2EwSt5zxlQ0=;
	b=itYdJZrAAd5JBA1SbHSvqCMJbixQBdPeaND3Pn3DEoAvpMLEmG4PN8DRFmDb7gEf/oMAYt
	2hu+hJK5EMp4eGJTq1Utw1ZbqePIXFSrDBs5Ft6lLdZZbprdgOS4WMbWKr+QIEAtWk7n6S
	upS1htbVgiBeoyCIP668U6eG5z6WJmY=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488a62b7372so97565e9.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776356782; cv=none;
        d=google.com; s=arc-20240605;
        b=l3VmG+Ol2/2ixczNCVoluklzbQV2aHMrsIfy/kDpj/n3FH5YsSKX5e//RfM+G44qEe
         qH6u75eCidopQZqAkq7Z5TWYOrVH+d9NXqPk3BeuzL4rkLKWJjvZf0XSRO2ln7P0Jk3u
         HGehcSdR/h3bKHjHC+yWPPl+AJyczx7H/qW5RA4VOKl4AmqvIMcHPErJtK+jWL/qNzpa
         NSC8Vma66YJhGwCzdW3cVdg8vRvMonOz++WSqihpKaoINeUsZT+whVqyFRDDYezpDkR/
         47pPq8YpOUxJ7ct41cbSxsony94youYUaf0S8SjrreiBczNipojvUVQ5vTl2m8OFfOpx
         inWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SiIXqIQ1insAYDWmIOBggv552UAc9lAw2EwSt5zxlQ0=;
        fh=ulNvZi1vSngjG0A61yuQAqI50wQGH/zq9ViBp3fVbCk=;
        b=W1Ci4p0R+PTcojnO8mhEKCKDwcxXS73x38m1jTtcccXdxbHtdA+rhTb8MVWL6dx7up
         84Ul4NY0KQsdXwFFWrovaX/SFKtsAj4rvB+8RxDhu3TNkvci+jt07dWA6Ss6NHwcpc5b
         i4dgKvMjQgIOLDPoP6mK7AqojMBWzXA8zrATD8gf6cTZqJZGGlVfBV+SQr0rnNeTqZsy
         GDz7XsqbQEF+8Zz1lRCbQCSQqGfpm6Qr2DvxCOFfQd0ckkJFZ28zdC4x+goudwHO0rzR
         cA2oMw1R4y2N/KXzuBLJREehI/dbDNYYeXdylyBvNM24bgfIafERpHQJTFG7y1YcnV+h
         ivtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776356782; x=1776961582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiIXqIQ1insAYDWmIOBggv552UAc9lAw2EwSt5zxlQ0=;
        b=mlTaS5N8rrr5MbEX2CZPJf6Pg31A9KqPgXroa4Kz075WFoFEWZcyeuq9hpsKP9RQE2
         ddUeaznIPJ+UTMYfutLW+NZ0OJ/HHubkGJPCf4xbz0t6gQVlfKAzromLhaVnj7wVHbQW
         ZbHOC9CgjfUXCr36rm57us90+z+/y3k926uOaR6DcdaWOOUOPwWgt10grtDtajZh1R9u
         WVSj0rLfGjEztVikGs7QjvPS3Bn7pHWxPilQ2VoC7L+4tva5ITDrqeLloGVU81fYyFqH
         ihuZYkp8j6S3kTaIe/Hxei5/3CtKbX96qy8hnri33I30/V69pEUTamAcJk7IMzN2gxZa
         R9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776356782; x=1776961582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SiIXqIQ1insAYDWmIOBggv552UAc9lAw2EwSt5zxlQ0=;
        b=EZ1mJlM46u/3E03YHy0mKyKzAK7ipHmle201u0mLe4l9ibjO61Z8b1M/HXFo8tGyBd
         +wZ0Xn0/QCgt0r9Gi6wiHQ8fhqhR5RTKJv8mlqX2lFelexWWke3X0rMqtgs+y69VVV1o
         ebd8b+Guzo1sCCQc4/m/se67msnRIWhWKNJ9/Qew2yTnUEoG1qn0iK1Xj8Y/in94KA7i
         R7iqOjwUpsWaRCi/GKgvZpmm/riLZZLEacCFOX7TWhI6GG/1SPhdHWm9y7MGKVCA9eks
         8wfMF67gQXX6idedrikYehcS65VI6OMb7OHZNySJ2+MTuq9ZKymskriCk1xA8Duvd5WD
         AdyA==
X-Forwarded-Encrypted: i=1; AFNElJ/xduw+7JQzOgH4j57WqY6sB68NXgIhV89VbWKKQUirNkYzGZpR1V0W/rpknFApoHaYBwAQ3R3nxA==@kvack.org
X-Gm-Message-State: AOJu0Yx3q27Sab6bh/Frdazcy71ZuaMqAanPcKfuk31ziwgc4t7l8Zkv
	7UHvVftw5FmoyrY7QcjeNZ0/5eEyeMlFoLsPw5cJcX70wCA8vpnEofhWccuLZtaHHKN0QqN3D67
	qGRZ4+TblsxopTxaxCzx1GcblnZgvwaCJeHI+Jhl0
X-Gm-Gg: AeBDietBY/0Q5rNJDORPSE8/DWRo7PBHzP5BVscAyNH1AYjFWszcoQNUo5ys7PeakZN
	K73gs12e6Xilk2rIbcvhXv/sb1u3TwXHBRX5Yft2ZcryUA0eX3adoq28SajXwjMvxJB3vUQvHg4
	1xaYpKKsPgXqNTEWqxL6x7I8ItqHJuWJFx1FpHZQNusu1oAljsDheZJifVprTKHE/gui1UreEj2
	vb+EF4Lq8VFgHUzzU2nzdeC6l8OXyYvszLZEc+fnjTDOaV7W4nViQOngxXLKTme6ngBPKOrJuuv
	OfUS4gJLO57QkB+6YMvbj1gmS0mFrac7d0hKYUUlLh9wB2Oa/ffvlo8XcKF1tg==
X-Received: by 2002:a05:600c:c3ce:10b0:485:5918:d1cb with SMTP id
 5b1f17b1804b1-488fa6727f3mr23185e9.13.1776356781442; Thu, 16 Apr 2026
 09:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <CACw3F51PC0iB6mfbiceQ_Kh242FN8zdXOfTyE5Pa_5+gjTPPGg@mail.gmail.com> <aeD6hpM3t0RZm5mW@gmail.com>
In-Reply-To: <aeD6hpM3t0RZm5mW@gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 16 Apr 2026 09:26:08 -0700
X-Gm-Features: AQROBzD5JUgdRLTgyYC9r4BJ93B9PUQ3FepxUaMlQT4MyQG2ukmY-pbNiFMMAyQ
Message-ID: <CACw3F50WYH8Vmd9EXx9+3yM=FU5-1WBkNffkGucC+wSjL+=wFQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B0DFA140010
X-Rspamd-Server: rspam12
X-Stat-Signature: ga88xixn1mbokenkz6w1rbuaub5uf81q
X-Rspam-User: 
X-HE-Tag: 1776356783-835554
X-HE-Meta: U2FsdGVkX1/9gxHhevpvn4JkGnI1rHDP7tNKIyBzyA1PxnyMK8gjNeg0Jhn96VQimZuJ2RNaSc1ynQ1I/ZZJLLnBArU9yPEzpSpJsueCsvbkNebTI53EuDNairy5d3o9kCjU7+fP/6SKeo49E1Nm0IggCp3dwJC9oLpZmR1tSB4Hfk7k0T0qDg5P5Oyd7qShpMNAWC4JG3lUcp9SWBSyQPsPc0rzL37JlyrLL6uLZiePByKOYbA8UiMwyHU46BSn316sTWI/BbQnhxR6//et94wf6uzrxUhybQwCpQgPoX+t49AOeia2sUTRPxx1PCLF75GgccKDFHV0C2rLorI1eEMeWTvUomhh+JVCR+O7rgOxAAV/pCIcRrR/Yet26Hcvm4aFrox+y4tOeuy+bTFHQcNSUaks6eqmn+cdKmgn03UCSb4yT6XbObHCXQe2FJqE8qN5BmKdzev2+Iylc4MweGQcaAET8Ih7l8tMIGhmMcxPybEzGPV1u/CK+gBqZYoU/eoGV6/jDy0LOpMfwQ3tv051AL2wpxld4AXIh+/m2hJi+1BArtrzgDNl63vop6SZ+xrzJ0PRdoaasj0hoCio5qrJ5b1vUUoZOG3cdq8IPW1zvzNemUhBTX8m64B2lqW633DEJl1LKFgheAIVh9jeAmZ+k3IZa1OH3gFB8JwNq2ipJUibeVoOwAzKxD+/WJ/qSC1EBTAZMMi8rw36kpqkM9Y0Qg0Emu8MmMe8Ki7mQa00HKPKVmW2VxSkRp401bXvyGSNWjYfYktWGQaZ0nbKVNYTQAYSVcIyvkenlVF8Xf499tub0nb+sCOA090V2sXZvTlJE+0JsWfEaV5sMxTpdbz0Ea+a5wMbHqZnDV+UNa16BOnBgN9N8744He+Me3DbneyecjIEVSRUGmzNwjU8ifmWbbQ1CohVxPLEwHH/X76sGDczQrZDYCrN/A5Dc6k6zKFcNMUGRxSDX2tpB3b
 dLB0PuBN
 3TuVr2W+v5WiSJ2NQe/4aze2fufUBx8dw/hTmUtcIzoHMVwhZwNhmXY6gRBWZavbT7g6+gaLpd1/hWrChAIiiRNxRRPLLgzR8DE5O5l6B+Pygk8rRhN9RHN7E9fXjV47fCBZpX2UIYFWAcsaHmtKS7P4dwzRJn9XBwLacDMIxkikJYtUnuKaw19KIxtqNJSGR31Xvn5mYBFmBlOs2he543QsVjW2cZScM0tH9uWff/neBmpGT37eS5j9WCE4wqL2hBID3KsckSOhNezOKnQPTpHORghe6dhf0fxhKf6bth5JZTuStNeL/VYrxe9n56+Ccqq2PDzIAlVdaQyuSbE6KMs2xumzVlP6xspbo0saLgGmzNGCHA7abL8qPViEWgGvR1U0/htbRdBcx3J2GDcOxtP95z4/bv33CANmR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 8:32=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Hi Jiaqi,
>
> On Wed, Apr 15, 2026 at 01:56:35PM -0700, Jiaqi Yan wrote:
> > On Wed, Apr 15, 2026 at 5:55 AM Breno Leitao <leitao@debian.org> wrote:
> > >
> > > When the memory failure handler encounters an in-use kernel page that=
 it
> > > cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
> > > currently logs the error as "Ignored" and continues operation.
> > >
> > > This leaves corrupted data accessible to the kernel, which will inevi=
tably
> > > cause either silent data corruption or a delayed crash when the poiso=
ned memory
> > > is next accessed.
> > >
> > > This is a common problem on large fleets. We frequently observe multi=
-bit ECC
> > > errors hitting kernel slab pages, where memory_failure() fails to rec=
over them
> > > and the system crashes later at an unrelated code path, making root c=
ause
> > > analysis unnecessarily difficult.
> > >
> > > Here is one specific example from production on an arm64 server: a mu=
lti-bit
> > > ECC error hit a dentry cache slab page, memory_failure() failed to re=
cover it
> > > (slab pages are not supported by the hwpoison recovery mechanism), an=
d 67
> > > seconds later d_lookup() accessed the poisoned cache line causing
> > > a synchronous external abort:
> > >
> > >     [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
> > >     [88690.498473] Memory failure: 0x40272d: unhandlable page.
> > >     [88690.498619] Memory failure: 0x40272d: recovery action for
> > >                    get hwpoison page: Ignored
> > >     ...
> > >     [88757.847126] Internal error: synchronous external abort:
> > >                    0000000096000410 [#1] SMP
> > >     [88758.061075] pc : d_lookup+0x5c/0x220
> > >
> > > This series adds a new sysctl vm.panic_on_unrecoverable_memory_failur=
e
> > > (default 0) that, when enabled, panics immediately on unrecoverable
> > > memory failures. This provides a clean crash dump at the time of the
> >
> > I get the fail-fast part, but wonder will kernel really be able to
> > provide clean crash dump useful for diagnosis?
>
> Yes, the kernel does provide a useful crash dump. With the sysctl enabled=
,
> here's what I observe:
>
>         Kernel panic - not syncing: Memory failure: 0x1: unrecoverable pa=
ge
>         CPU: 40 UID: 0 PID: 682 Comm: bash Tainted: G B  7.0.0-next-20260=
414-upstream-00004-gcbb3af7bfd3b #93
>         Tainted: [B]=3DBAD_PAGE
>
>         Call Trace:
>          <TASK>
>          vpanic+0x399/0x700
>          panic+0xb4/0xc0
>          action_result+0x278/0x340          =E2=86=90 your new panic call=
 site
>          memory_failure+0x152b/0x1c80
>
>
> Without the patch (or with the sysctl disabled), you only get:
>
>         Memory failure: 0x1: unhandlable page.
>         Memory failure: 0x1: recovery action for reserved kernel page: Ig=
nored
>
> Then the host continues running until it eventually accesses that poisone=
d
> memory, triggering a generic error similar to the d_lookup() case mention=
ed
> above.
>
> > In your example at 88757.847126, kernel was handling SEA and because
> > we are under kernel context, eventually has to die(). Apparently not
> > only your patch, but also memory-failure has no role to play there.
> > But at least SEA handling tried its best to show the kernel code that
> > consumed the memory error.
> >
> > So your code should apply to the memory failure handling at
> > 88690.498473, which is likely triggered from APEI GHES for poison
> > detection (I guess the example is from ARM64). Anything except SEA is
> > considered not synchronous (by APEI is_hest_sync_notify()). If kernel
> > panics there, I guess it will be in a random process context or a
> > kworker thread? How useful is it for diagnosis? Just the exact time an
> > error detected (which is already logged by kernel)?
>
> The kernel panics with a clear stack trace and explicit reason, making it
> straightforward to correlate and analyze the failure.

So we will always get the same stack trace below, right?

          panic+0xb4/0xc0
          action_result+0x278/0x340
          memory_failure+0x152b/0x1c80

IIUC, this stack trace itself doesn't provide any useful information
about the memory error, right? What exactly can we use from the stack
trace? It is just a side-effect that we failed immediately.

You can still correlate failure with "Memory failure: 0x1: unhandlable
page" and keep running until the actual fatal poison consumption takes
down the system. Drawback is that these will be cascading events that
can be "noisy". What I see is the choice between failing fast versus
failing safe.

>
> My objective is to have a clean, immediate crash rather than allowing the
> system to continue running and potentially crash later (if at all).
>
> Working at a hyperscaler, I regularly see thousands of these "unhandlable
> page" messages, followed by later kernel crashes when the corrupted memor=
y
> is eventually accessed.
>
> > On X86, for UCNA or SRAO type machine check exceptions, I think with
> > your patch the panic would also happen in random process context or
> > kworker thread,
> >
> > Can you share some clean crash dumps from your testing that show they
> > are more useful than the crash at SEA? Thanks!
>
> Certainly, here is the complete crash dump from the example above. This
> happened on a real production hardware:
>
>         [88690.478913] [ T593001] {1}[Hardware Error]: Hardware error fro=
m APEI Generic Hardware Error Source: 784
>         [88690.479097] [ T593001] {1}[Hardware Error]: event severity: re=
coverable
>         [88690.479184] [ T593001] {1}[Hardware Error]:  imprecise tstamp:=
 2026-03-20 13:13:08
>         [88690.479282] [ T593001] {1}[Hardware Error]:  Error 0, type: re=
coverable
>         [88690.479359] [ T593001] {1}[Hardware Error]:   section_type: me=
mory error
>         [88690.479424] [ T593001] {1}[Hardware Error]:   physical_address=
: 0x00000040272d5080
>         [88690.479503] [ T593001] {1}[Hardware Error]:   physical_address=
_mask: 0xfffffffffffff000
>         [88690.479606] [ T593001] {1}[Hardware Error]:   node:0 card:0 mo=
dule:1 rank:1 bank:13 device:6 row:64114 column:832 requestor_id:0x00000000=
00000027
>         [88690.479680] [ T593001] {1}[Hardware Error]:   error_type: 3, m=
ulti-bit ECC
>         [88690.479754] [ T593001] {1}[Hardware Error]:   DIMM location: n=
ot present. DMI handle: 0x000e
>         [88690.479882] [ T593001] EDAC MC0: 1 UE multi-bit ECC on unknown=
 memory (node:0 card:0 module:1 rank:1 bank:13 device:6 row:64114 column:83=
2 requestor_id:0x0000000000000027 DIMM location: not present. DMI handle: 0=
x000e page:0x40272d offset:0x5080 grain:4096 - APEI location: node:0 card:0=
 module:1 rank:1 bank:13 device:6 row:64114 column:832 requestor_id:0x00000=
00000000027 DIMM location: not present. DMI handle: 0x000e)
>         [88690.498473] [ T593001] Memory failure: 0x40272d: unhandlable p=
age.
>         [88690.498619] [ T593001] Memory failure: 0x40272d: recovery acti=
on for get hwpoison page: Ignored
>         [88757.847126] [ T640437] Internal error: synchronous external ab=
ort: 0000000096000410 [#1]  SMP
>         [88757.867131] [ T640437] Modules linked in: ghes_edac(E) act_gac=
t(E) sch_fq(E) tcp_diag(E) inet_diag(E) cls_bpf(E) mlx5_ib(E) sm3_ce(E) sha=
3_ce(E) sha512_ce(E) ipmi_ssif(E) ipmi_devintf(E) nvidia_cspmu(E) ib_uverbs=
(E) cppc_cpufreq(E) coresight_etm4x(E) coresight_stm(E) ipmi_msghandler(E) =
coresight_trbe(E) arm_cspmu_module(E) arm_smmuv3_pmu(E) arm_spe_pmu(E) stm_=
core(E) coresight_tmc(E) coresight_funnel(E) coresight(E) bpf_preload(E) sc=
h_fq_codel(E) ip_tables(E) ip6_tables(E) vhost_net(E) tun(E) vhost(E) vhost=
_iotlb(E) tap(E) tls(E) mpls_gso(E) mpls_iptunnel(E) mpls_router(E) fou(E) =
acpi_power_meter(E) loop(E) drm(E) backlight(E) drm_panel_orientation_quirk=
s(E) autofs4(E) raid0(E) efivarfs(E) dm_crypt(E)
>         [88757.991191] [ T640437] CPU: 70 UID: 34133 PID: 640437 Comm: Co=
llection-20 Kdump: loaded Tainted: G   M        E       6.16.1-0_fbk2_0_gf4=
0efc324cc8 #1 NONE
>         [88758.017569] [ T640437] Tainted: [M]=3DMACHINE_CHECK, [E]=3DUNS=
IGNED_MODULE
>         [88758.028860] [ T640437] Hardware name: ....
>         [88758.046969] [ T640437] pstate: 23401009 (nzCv daif +PAN -UAO +=
TCO +DIT +SSBS BTYPE=3D--)
>         [88758.061075] [ T640437] pc : d_lookup+0x5c/0x220
>         [88758.068392] [ T640437] lr : try_lookup_noperm+0x30/0x50
>         [88758.077088] [ T640437] sp : ffff800138cafc30
>         [88758.083827] [ T640437] x29: ffff800138cafc40 x28: ffff0001dcfe=
8bc0 x27: 00000000bc0a11f7
>         [88758.098321] [ T640437] x26: 00000000000ee00c x25: ffffffffffff=
ffff x24: 0000000000000001
>         [88758.112807] [ T640437] x23: ffff003fa14d0000 x22: ffff8000828d=
3740 x21: ffff800138cafde8
>         [88758.127281] [ T640437] x20: ffff0000d0316fc0 x19: ffff800138ca=
fce0 x18: 0001000000000000
>         [88758.141753] [ T640437] x17: 0000000000000001 x16: 0000000001ff=
ffff x15: dfc038a300003936
>         [88758.156226] [ T640437] x14: 00000000fffffffa x13: ffffffffffff=
ffff x12: ffff0000d0316fc0
>         [88758.170695] [ T640437] x11: 61c8864680b583eb x10: 000000000000=
0039 x9 : ffff800080fcfd68
>         [88758.185170] [ T640437] x8 : ffff003fa72d5088 x7 : 000000000000=
0000 x6 : ffff800138cafd58
>         [88758.199645] [ T640437] x5 : ffff0001dcfe8bc0 x4 : ffff80008104=
a330 x3 : 0000000000000002
>         [88758.214111] [ T640437] x2 : ffff800138cafd4d x1 : ffff800138ca=
fce0 x0 : ffff0000d0316fc0
>         [88758.228579] [ T640437] Call trace:
>         [88758.233565] [ T640437]  d_lookup+0x5c/0x220 (P)
>         [88758.240864] [ T640437]  try_lookup_noperm+0x30/0x50
>         [88758.248868] [ T640437]  proc_fill_cache+0x54/0x140
>         [88758.256696] [ T640437]  proc_readfd_common+0x138/0x1e8
>         [88758.265222] [ T640437]  proc_fd_iterate.llvm.72608576508414357=
59+0x1c/0x30
>         [88758.277248] [ T640437]  iterate_dir+0x84/0x228
>         [88758.284354] [ T640437]  __arm64_sys_getdents64+0x5c/0x110
>         [88758.293383] [ T640437]  invoke_syscall+0x4c/0xd0
>         [88758.300843] [ T640437]  do_el0_svc+0x80/0xb8
>         [88758.307599] [ T640437]  el0_svc+0x30/0xf0
>         [88758.313820] [ T640437]  el0t_64_sync_handler+0x70/0x100
>         [88758.322497] [ T640437]  el0t_64_sync+0x17c/0x180
>         ...
>
> And my clear crash would look like the following:
>
>         [ 1096.480523] Memory failure: 0x2: recovery action for reserved =
kernel page: Ignored
>         [ 1096.480751] Kernel panic - not syncing: Memory failure: 0x2: u=
nrecoverable page
>         [ 1096.480760] CPU: 5 UID: 0 PID: 683 Comm: bash Tainted: G    B =
              7.0.0-next-20260414-upstream-00004-gcbb3af7bfd3b #93 PREEMPTL=
AZY
>         [ 1096.480768] Tainted: [B]=3DBAD_PAGE
>         [ 1096.480774] Call Trace:
>         [ 1096.480778]  <TASK>
>         [ 1096.480782]  vpanic+0x399/0x700
>         [ 1096.480821]  panic+0xb4/0xc0
>         [ 1096.480849]  action_result+0x278/0x340
>         [ 1096.480857]  memory_failure+0x152b/0x1c80
>         [ 1096.480925]  hwpoison_inject+0x3a6/0x3f0 [hwpoison_inject]
>         ....
>
>
> Isn't the clean approach way better than the random one?

I don't fully agree. In the past upstream has enhanced many kernel mm
services (e.g. khugepaged, page migration, dump_user_range()) to
recover from memory error in order to improve system availability,
given these service or tools can fail safe. Seeing many crashes
pointing to a certain in-kernel service at consumption time helped us
decide what services we should enhance, and which service we should
prioritize. Of course not all kernel code can be recovered from memory
error, but that doesn't mean knowing what kernel code often caused
crash isn't useful.

>
> For testing, I use this simple procedure, in case you want to play with
> it:
>         # modprobe hwpoison-inject
>         # sysctl -w vm.panic_on_unrecoverable_memory_failure=3D0
>         # echo 1 > /sys/kernel/debug/hwpoison/corrupt-pfn
>
>
> Thanks for the review and good discussion,

Anyway, I only have a second opinion on the usefulness of a static
stack trace. This fail-fast option is good to have. Thanks!

> --breno
>

