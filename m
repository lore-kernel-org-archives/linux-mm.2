Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF91CCFA06
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 23:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0158D8E0094; Mon,  3 Nov 2025 18:58:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0C48E0058; Mon,  3 Nov 2025 18:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9128E0094; Mon,  3 Nov 2025 18:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C33A88E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:58:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52492585C7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:58:44 +0000 (UTC)
X-FDA: 84070963368.26.1B347A0
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 85F0940009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:58:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="sBJu/HML";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762214322; a=rsa-sha256;
	cv=none;
	b=EOwuGRxisRHDHhMYC4yb8OZNzPXvg8/V1BtTFWw+lHt9TEVnhprjCt1j0y6PswpVJqEX6n
	JljBTK9UdKoLVk06Xscfw5cZ2PWrDO/CfW2pFbI9jSFIAPEj7FKOLCpw8lmsG/g7oqOODy
	hLuNsJ2DZXSJ5Sdxuu2+dluMEEkGDLc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="sBJu/HML";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762214322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiaumAf9uKaq/47KUh0x3Zq3WXVBAjDWrX0gtHKtIa0=;
	b=5XCPNuH4a4wmw4KX07IHUuz3eOwSHaxZzFPi11hXCiNyOWE3CRU4KCkJBxCFv4MxtC8mqL
	1xsUt1XGNms7yv5tpYPpk9J1kyzSBbTSaFU/UPKe8oVXzZsMMWIh13vZTbMfuOkN1KyR6H
	aFTUtE+jxz/SADmroj2SX2CBhCC3j5Y=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-294f3105435so41865ad.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 15:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762214321; x=1762819121; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiaumAf9uKaq/47KUh0x3Zq3WXVBAjDWrX0gtHKtIa0=;
        b=sBJu/HMLInPSHyACRruJ8jYzRWDObjEK0A0TOUozbLAOGz/1ysz7Y/0kRKDaUQNhRA
         g5K9yhvFaOv0K4zc/yTy0t3SpljUFupk83yF236JTg9xT7NTSvcJXpIbhs1qwWulLhqu
         xBoC1OT3l5z+mjM0/ktXfFWADpJg2mC18cQB7VJ3KGVhN+2ptvGCKKmejuZV7mYem2VK
         BRKIrrHtsOs0qa8UNIDOinn/R3kqo9+cLVEoWeV8WxgF7QRxbl3RCb4Sy7L64bCyCJCa
         L/S6WucpUqPaB5rIppzs9hp6uhCBOwh88iJhvxU0bvA0434kWKINQEKzS5zlsbsBR8vu
         cDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762214321; x=1762819121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiaumAf9uKaq/47KUh0x3Zq3WXVBAjDWrX0gtHKtIa0=;
        b=Nc1akm/YjFpHb85WcHjeL+eUQtwefFr0Cvygldw/4hr4pjT/mObz0gLl/KhnMNKjgy
         W3CBlwuWRveQmZCdStxnvs5iuvr59IuNdM9dK4C/Me+KO/8A+e7uJTXzto1WmIYyI5YE
         i4RWZkk8P9PN5qHN6KJvWavqx8RLnSqmYiHLIO5pIRF1RUlQa4PUZPOxlHJoVkMOFuiG
         4faK5zGEn0O/+F1xkEUGefdGX9RlpZ+fJi3mKBot283jPqmdZLM/H1dHcoxPRilOewWb
         +3nXG7EFlYCLKVrO/e+nqQWh9S4yUNMG0QWMHbQ8WMVMNrTs6T6V0hLxqn8Ilvl5t32j
         LhqQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8vSDafQfaaCE83pj84j4QQ/c6CCs9Gg7pv9s7qYyWvGJwgB0OxZdrCLYk9EsVFjIck2ECChZaRQ==@kvack.org
X-Gm-Message-State: AOJu0Yw10MVurCPfsHDtHUNtZpDu5j3L0nzR5vspKXOIL8SsA1DXqdcn
	/k6iNDow0Bfhy/ZX7pjmnxvO1ORBDE8LTJ/sLPvfR6wL+TQmAyPgeYt8L0ZzTHouORalesjhxME
	MNWH7fQN4+wzpKLNsw1BWrd8VX8+LruMOMPc6IiDo
X-Gm-Gg: ASbGncuKvrUcyJWPFhVROOqwP1vUHQorFMnIzRUcvisP7aHOEIKRwAJ5nukAVs1JwC2
	1iFocG3dEVcBlwHEQdoGfpOPwQspHcGxmB6kprb2xpMvBFo/zd1fQ7a0i6PPf67kzNfSvhQeYDF
	/UEDhsENmqrByBG3BhN91GKNKYoof7PioWqEyTEDKpnD9brDjq0XLc0UQ+Hh46oolCbZXAU2fMs
	W3KpnyL403rfAJPi2WEarGCbeF6hhBaARECUkOikhaawr1Xyi4/6HsBv7hhPGB2W5zjfAVs2xHn
	UkOEPEPMR1Bu8vePErk4NatLh/4=
X-Google-Smtp-Source: AGHT+IHt6j/O2+BVT8RrxCXQhlHMInI33IDskTKx+bVIyN+3SBdebf/1pf/skkswodcwqLLeaarZnJrY3sFQZRZnnO4=
X-Received: by 2002:a17:902:ec81:b0:290:d7fd:6297 with SMTP id
 d9443c01a7336-295fd265e91mr2024145ad.2.1762214320623; Mon, 03 Nov 2025
 15:58:40 -0800 (PST)
MIME-Version: 1.0
References: <20251028212528.681081-1-kaleshsingh@google.com>
 <20251028212528.681081-3-kaleshsingh@google.com> <6c34ce4e-1212-4dd0-8b7c-6af952dda3cb@kernel.org>
In-Reply-To: <6c34ce4e-1212-4dd0-8b7c-6af952dda3cb@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 3 Nov 2025 15:58:28 -0800
X-Gm-Features: AWmQ_blqxq78jLq4HTBbisYrdSqGuPCxohmpOKASM-NgBeXlVoTSRESehr_wOXs
Message-ID: <CAC_TJvf+KwdFF3BO1bO2Jje1igbbM4pdy3-V5rY+fdciwmUEfA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/selftests: add max_vma_count tests
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	rostedt@goodmis.org, hughd@google.com, kernel-team@android.com, 
	android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 85F0940009
X-Stat-Signature: sjuj3fifq6cdbjiimz4gqzut9scwenyq
X-Rspam-User: 
X-HE-Tag: 1762214322-39243
X-HE-Meta: U2FsdGVkX18RCG0oyuKIVs3wsdEj0zBrygYl0qlGldBFyJxf41046Z7FkSMwZUI4+Xe6RPIqmO8ntfMsSsnlAB+/P9uPB8HThN5utAP0pZbsOfUNaGTT1iZRH3bQWKulLomAK9ei/GGy24yRbZWw/pZgLqx8AL4nws/Pd5whP03PtfcCB/EiJj6JWZ9gx+X4jNzieCXYW3op67AQYEjMr5lpSKZByxaHF6dWg37fQMbrPZ0TVMRaIQo5upiQdnbIiFlq1w9BuSYZKAzkEU1PzQUanrW6Y+toZ/Cm7oAEs2m0Bzrd9Y1SXe7q2I1HYs7aY9fg/nhbJzaNnrZyVCN6m6jpOOwR0DehXpu1+DmhK7ActvDc/RdxZTv5u7fSWWKsVcpNzYfjCjkfz6e5yDcfYHWO9AqPf4BUdsn9ROh6jJZhVd1eaiuPGhXhkQTH3GFA4VTJ57Iwi58msSvWEZY+LkOM3p7KPsPLnN0F/tzQai0OtW/wQhfSefLpGpWPSps5givM6GnY9fOXLDE/BzdWgLHHtV99y+m0lZjiEWLh13ixYpWLxytP1ZCr9p5iG7KhwmVLjlCWCnOFvA9lH/AQ/BGnDgedkhXos9yd6LczVpZD3k2jEMkNBMrOQH1x6NPpAj0TROWnGcoD1Ff7568VBkRzv0z82ZMxn2OYYvGycQ42phaUJqFmOVfTDwxs27WPeFuTplF0MkCwHsgNB9eoba9NyDLVBHUEEQ6frKNNv8WaFTqtr+w5H7dq0W3gMGMCrNOaW0CMndE7AX5R5lVGizEsUyhUbMfWG6MyE0VgfqYz9VqBC27MlOQcUIT6XBfeIzJuXsdMCY5/1LC+HW1rCNSnWeDlvVXMPSX/m3iwGHfXejFbRBom+yUV2jBDteoihgf8fJQ/EfzBPrqNMvWYEROR/+wd2wsores3iMaFujy4UsDm3Kjlnb90hziJsziLBNFs0ax3UyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 9:13=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 28.10.25 22:24, Kalesh Singh wrote:
> > Add a new selftest to verify that the max VMA count limit is correctly
> > enforced.
> >
> > This test suite checks that various VMA operations (mmap, mprotect,
> > munmap, mremap) succeed or fail as expected when the number of VMAs is
> > close to the sysctl_max_map_count limit.
> >
> > The test works by first creating a large number of VMAs to bring the
> > process close to the limit, and then performing various operations that
> > may or may not create new VMAs. The test then verifies that the
> > operations that would exceed the limit fail, and that the operations
> > that do not exceed the limit succeed.
> >
> > NOTE: munmap is special as it's allowed to temporarily exceed the limit
> > by one for splits as this will decrease back to the limit once the unma=
p
> > succeeds.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
>
> [...]
>
> No capacity to review the tests in detail :(

Appreciate you taking a look :)

>
> > +
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/=
selftests/mm/run_vmtests.sh
> > index d9173f2312b7..a85db61e6a92 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -49,6 +49,8 @@ separated by spaces:
> >       test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
> >   - madv_populate
> >       test memadvise(2) MADV_POPULATE_{READ,WRITE} options
> > +- max_vma_count
> > +     tests for max vma_count
> >   - memfd_secret
> >       test memfd_secret(2)
> >   - process_mrelease
> > @@ -426,6 +428,9 @@ fi # VADDR64
> >   # vmalloc stability smoke test
> >   CATEGORY=3D"vmalloc" run_test bash ./test_vmalloc.sh smoke
> >
> > +# test operations against max vma count limit
> > +CATEGORY=3D"max_vma_count" run_test ./max_vma_count_tests
>
> I'd just call it CATEGORY=3D"vma" or "vma_handling".
>
> Which makes me wodnering whether "vma_merge" falls into the same category=
.
>
> Smalls like mremap test is similar.
>
> Point is that "CATEGORY" stops being really useful if we end up having a
> separate category for each test, right? :)

I agree making both use a "vma" category seem more helpful. I'll wait
for others' feedback before resending.

Thanks,
Kalesh
>
> --
> Cheers
>
> David

