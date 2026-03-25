Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A645BFEA80D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 06:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1466B0089; Wed, 25 Mar 2026 02:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C997D6B008A; Wed, 25 Mar 2026 02:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B881B6B008C; Wed, 25 Mar 2026 02:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A95E46B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:12:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62D465A9FD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:12:14 +0000 (UTC)
X-FDA: 84583565388.09.7167315
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 090EC14000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:12:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoTECeiD;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774419132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvC9vhXMy61hfhFlVL91GaPXvIVhH/OQT1gyqQkgzEQ=;
	b=jRD52oLdbYoRbE3ynWJI71hG2yAr0rIPtnjaH+s5P8FD50ICi9fhrbbiCWH1VjF3MJlhwz
	q/3oZmybG68MacygBD4Jy7On1zg1cL/+Q+VHymOT87sRHBeDEebLjTbx3AZvK4j0oG9hQR
	wP3EHPZKTGFjo/y2plk6vlRt8q9HAgU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoTECeiD;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774419132; a=rsa-sha256;
	cv=none;
	b=HvL41n82AZUCuuuKCMKqir8odfNGiFSNaFaLRvO1hTyJcVQ8YG7lT3nETSujo01uMPQU29
	znr0HlQ/fUm4j6RUC06Cg23ER42qeYWTMu827T4+UnUFIWUoPcMrdwaRqi2h7TNW9jJQA+
	T1y8leY7jY1AZ8qXY30T5aBPdgv8O6Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774419131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvC9vhXMy61hfhFlVL91GaPXvIVhH/OQT1gyqQkgzEQ=;
	b=XoTECeiDhdhIU+3zN8rLRWy0SJajjrkMJ8Gzlq/kR4bO8DgFeOo5eZMMWBBd8yiZjuvKj1
	J+QuYuDQalAW19PXKE3WEhszQ1nc9n4rE1HfJPJWlkoW5rwDgIciG5ZkI5z1kUDZoZWzzq
	cnZQXpVliWbz2ND9LGIrlieEcyyTN6s=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-_ZRJKAesNF-iVOq_TZ9bZw-1; Wed, 25 Mar 2026 02:12:10 -0400
X-MC-Unique: _ZRJKAesNF-iVOq_TZ9bZw-1
X-Mimecast-MFC-AGG-ID: _ZRJKAesNF-iVOq_TZ9bZw_1774419129
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b0b339b8dbso5586675ad.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774419129; x=1775023929;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pvC9vhXMy61hfhFlVL91GaPXvIVhH/OQT1gyqQkgzEQ=;
        b=hDRGnZ3QxchDj8KZfWHcQlbluyC+dEwmaVqekhYQMFRbSJ7ymFyTJldGHn3eiiwopQ
         aKzpAvnQTQdX7xAuPIJjTZ2YWq1n2fhkf/36muCWT3IvB/HVnc59l/rsT4K8fKkUJZBc
         XUkJzJNVu3YdCk5UvHKKbkZEiBY1jKDsjvxZqzDu0njJMhEqIVr3qOr8CRpTJO4gqmae
         nBjNoxWhXy94YHRJhhb1SpcqpOzupVo99M7QvHqCwTZwcu9j787F7ISBcb1Dke2rtfnP
         eCRdpv/tgDr+DzqzNKke4QUF0csLoK4HTfHLh/wKfk1/z3c0BKB4G2RiseNLv4sgQ/AB
         UtbA==
X-Forwarded-Encrypted: i=1; AJvYcCUkT0MwTCk7ZdjZ2T+kV++9NSCQT8YyN7OE5KjV4BocpIAa4dfEsSvgUaB92FmamTb/+jnV9DSjIQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5iFV/V/tq9FyiNnLMOgp5bSyNuSX6qj+r0Lx0zV2ERA4cgLdO
	O/6ChIoN9/nT94hOBFX+vEbAhy/NkxJTvGcYbAb40b4cRxBCaZpp8M/ZPXtIGBC+S3Aj7FBL0P9
	Pd2pFYO0O6+1KZzhqfaUsAHeVaYoA2jvEzpPgmIrsj2GVQyQFnk89
X-Gm-Gg: ATEYQzx/SzVBa2wvMxCQpNd9SN79qbW63mOT07kmdNHDMGipVKeY0C2aAvlJDI07avD
	q5luVbFjYTdixaHQnTj1CMqKTFBK7nVxX61Wpkn3T0Dbg+fvxbIGyw8iuUXBnZFWtXl5FbaHPQn
	KnuLeS2uwvFOXj3ANSIFdsve7bqqBSaNqAZ/J52uAOI+8ay8SJDXM5dhl91ggtSoy2dZw82Csqw
	+1HMZPsGmrd/p+A4phlsR5xrrKb09y9AV1BQzA/EaiX2wvUqHs6N3stEOK1d+24ASKmw92ISz6b
	yOmePT4nXO9D234/ik3aFlliGRg3/MGiM08v0AOnbkwsfZithsZm+2968sTUFCo3/nd1sHxHRft
	OHCeqJ3EAR/e72ghd6g==
X-Received: by 2002:a17:903:38cd:b0:2b0:7a50:886f with SMTP id d9443c01a7336-2b0b0b1dc00mr26591165ad.51.1774419128522;
        Tue, 24 Mar 2026 23:12:08 -0700 (PDT)
X-Received: by 2002:a17:903:38cd:b0:2b0:7a50:886f with SMTP id d9443c01a7336-2b0b0b1dc00mr26590895ad.51.1774419128038;
        Tue, 24 Mar 2026 23:12:08 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083527f90sm164354805ad.19.2026.03.24.23.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 23:12:07 -0700 (PDT)
Date: Wed, 25 Mar 2026 14:12:04 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com,
	yosryahmed@google.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
	tj@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acN8tN4FhuoxCxzs@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com>
 <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
 <acKAr0TYzuYPxH4A@redhat.com>
 <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
 <acNH6C6Ay7As4y60@redhat.com>
 <CAO9r8zO2Nq=8dGBuJ0xpQTEr4EM2iJ=WNULtCU5FLLj4a23dYA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zO2Nq=8dGBuJ0xpQTEr4EM2iJ=WNULtCU5FLLj4a23dYA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fLNkoDaWX9p8ll3y7JwLPi-Z5Msn5FIwCYZmZziMDxo_1774419129
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zhwrz5hdgt9a7czn3fyiispikf8asstb
X-Rspamd-Queue-Id: 090EC14000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774419131-526468
X-HE-Meta: U2FsdGVkX1/xk3VMmg3wI+3TtA3dscocMZE1bt3a47sRwaDJ0WPrrU72jW5/Aiq1Sd0UUqbii/Pfe5HacA8xsK9fTopaX9mSKgAppCBB4KUnbD3mciN+wnsCL9nZXmMjU7dWjHPjTx05o9h8ayREX7NxcqNIKKhRdPFJF7nd96nyRLsKTVsf9vja+9xFVpuvwXVM4f9+1+55Y0FCiBUsiGeMC/e4DoQjyYj4ekAv15+MP8ZoKm+iDpUuJXGFpxfOe9GoeD9NqcRBxIoxS53YA21/+IdmFxQGai62519FPTqmxHADbpZUBU/b1U4JSLs34gpq/sc8VftpU97Gi0w1vXOR3mCQaV8UydJkO5hBsOzweb6dU/NYeOTTXA3HYMxFkd0jDcr1mO8YakYFwpXpIP8lUD1I66XY+Esw7y4GNTAkait1arBURyRXWrUca7g+jRz5ab2Et+rNuXm53bJROM/cZMj9A2D59IOTEq0k8BmsrFox2LDKX3Nl+KfVJn2JGo2TQqXs17TKiNduzze8wQsmcLoa2sFERuNuf/AoWb6ET5ViEMCJ2P7Ki2l0S+QpDbg4+VUhiUPjirBee7OVvtLSBKnh4KPgW0b85fUbiA8jAbEIMiAUd8TWfHFcqdhnqxx9V/LzDjpCNwa75lQwxvBuWTu2KpLLbEk79axPRmS6aD/YJZnztAgOmD9txk8uUGr+CC1fpjRM669Om4ximwWBU0XNNuWOHughqUVTdgRLZAlxXxX5Ei8lNSoPAdFF134jFQNti+rnB6Eno5Alr0JPStfJ3K2qAmr811cO7MaeC8zwXRsfp8CHLvETRTwe4bB3rLDYdrURrAjvXda5v6BqFuBP/WX7uQkYNNjwv9c51sam7SVfpBvzxtP6Frk3eeb+KobYaNb7qtdZqChlgPyvbR2DHZ7BtcU1jbkCvjPAzE7FXq/+JGvhom9L7IQHdqe/5VEGPcVffy3/YZ/
 vapo5bYa
 1qs2IOcscd4IMUzMTrQhQdm4x5fUAD4H64tVoJFnXMEeqykAC3+2lpd1VX1PPDe8nWjlMom/n76Yzd1mS2lh2/X/ZKaWBL7Zf5ZRpOpK/+nQ4lki1zaqJ9MJU80eYZyJ1qA7eHrp8a2DV6krl10u1gRSYmRja8TKjmo4m5lqNGEzO5zYLB23WmtCYahWlz+anS6HfuYgLjNmH6xwFfDX5rpNL1CI9CX0fB64VMsH6onf34Y/k/QyHDZ48Ovl3AEdjANjvG+dd8gRj4oTkJfG2GyhsP2Untyujnbq3m7r6a7RcVyzWq83kP9NIYlFyMbdaWJpis/FyAxMzy7zHjAbIfm8EcYukl1mqLtpZg/SBiJfaaO5vF0I5NPvaU++uwvVKZK+9KeNN5jRKWt7mWl+usdNyUl4AV5SW1F2D1X9heGRzMy+QSJjpm8ZcUTzN2IrCcdClMI02OnhHQJhsUirKYiSC6AISD0AT+5bvFhwpcR0KSiuQTvhiOiBP9YpdPpPEWTks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 07:49:17PM -0700, Yosry Ahmed wrote:
> On Tue, Mar 24, 2026 at 7:26 PM Li Wang <liwang@redhat.com> wrote:
> >
> > On Tue, Mar 24, 2026 at 01:28:12PM -0700, Yosry Ahmed wrote:
> > > > > Sashiko claims that 512 pages will end up consuming 11K to 15K in
> > > > > zswap with this setup, do you know what the actual number is?
> > > >
> > > > Not very sure, I guess each 64K page contains 1 byte of 'a' and 65535 bytes
> > > > of zero. A single page like that compresses down to roughly 20–30 bytes
> > > > (a short literal plus a very long zero run, plus frame/header overhead).
> > > > So the estimate is roughly 512 × 25 bytes ≈ 12.8 KB, which is where the
> > > > "11 to 15 kilobytes" ballpark comes from.
> > > >
> > > > > Especially with different compressors? If it's close to 64K, this
> > > > > might be a problem.
> > > >
> > > > Yes, good point, when I swith to use 'zstd' compressor, it doesn't work.
> > > >
> > > > > Maybe we can fill half of each page with increasing values? It should
> > > > > still be compressible but not too compressible.
> > > >
> > > > I tried, this method works on Lzo algorithm but not Zstd.
> > > > Anyway, I am still investigating.
> > >
> > > Do you mean the compressibility is still very high on zstd? I vaguely
> > > remember filling a page with repeating patterns (e.g. alphabet
> > > letters) seemed to produce a decent compression ratio, but I don't
> > > remember the specifics.
> > >
> > > I am pretty sure an LLM could figure out what values will work for
> > > different compression algorithms :)
> >
> > Well, I have tried many ways for ditry each page of the total, but none
> > works on zstd compreseor.
> >
> > e.g,.
> >
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -9,6 +9,7 @@
> >  #include <string.h>
> >  #include <sys/wait.h>
> >  #include <sys/mman.h>
> > +#include <sys/random.h>
> >
> >  #include "kselftest.h"
> >  #include "cgroup_util.h"
> > @@ -473,8 +474,12 @@ static int test_no_invasive_cgroup_shrink(const char *root)
> >         if (cg_enter_current(control_group))
> >                 goto out;
> >         control_allocation = malloc(control_allocation_size);
> > -       for (int i = 0; i < control_allocation_size; i += page_size)
> > -               control_allocation[i] = (char)((i / page_size) + 1);
> > +       unsigned int nr_pages = control_allocation_size/page_size;
> > +       for (int i = 0; i < nr_pages; i++) {
> > +               unsigned long off = (unsigned long)i * page_size;
> > +               memset(&control_allocation[off], 0, page_size);
> > +               getrandom(&control_allocation[off], nr_pages/2, 0);
> 
> This should be page_size/2, right?

Ah, that's right.

> nr_pages is 1024 IIUC, so that's 512 bytes only. If the page size is
> 64K, we're leaving 63.5K (99% of the page) as zeroes.

nr_pages is 512, but you're right on the analysis.

> > +       }
> >         if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
> >                 goto out;
> >
> > Even I tried to set random data for all of the pages, they still not
> > works (zstd). But it can be worked on lzo compressor, I don't know if
> > the zstd have any addtional configures or I missed anything there.
> >
> > My current thought is just to satisfy the lzo (default) compressor in
> > this patch series, and leave the zstd for additional work.
> >
> > What do you think? any better idea?
> 
> Let's check if using page_size/2 fixes it first. If a page is 100%
> filled with random data it should be incompressible, so I would be
> surprised if 50% random data yields a very high compression ratio.
> 
> It would also help if you check what the compression ratio actually is
> (i.e. compressed_size / uncompressed_size).

Randomly dirty the page_size/2 always led to OOM, so I swith to page_size/4,
it looks like both algorithms compress pages successfully, but zstd doesn't
update 'zswpwb' stat so that test result fails.

Considering that zswap writeback is asynchronous, I additianlly introduced
a polling method for checking 500 times, but 'zswpwb' still returned zero.

==== Test results ====

lzo: 
  # uncompressed: 51511296, compressed: 13353876, ratio: 0.26
  # get_cg_wb_count(wb_group) is 206, get_cg_wb_count(control_group) is 0
  ok 7 test_no_invasive_cgroup_shrink

zstd:
  # uncompressed: 48037888, compressed: 12019013, ratio: 0.25
  # get_cg_wb_count(wb_group) is 0, get_cg_wb_count(control_group) is 0
  not ok 7 test_no_invasive_cgroup_shrink

==== debug code for the above output ====

  long zswapped = cg_read_key_long(control_group, "memory.stat", "zswapped");
  long zswap_compressed = cg_read_key_long(control_group, "memory.stat", "zswap");
  ksft_print_msg("uncompressed: %ld, compressed: %ld, ratio: %.2f\n",
		zswapped, zswap_compressed,
		(double)zswap_compressed / zswapped);
  ksft_print_msg("get_cg_wb_count(wb_group) is %zu, get_cg_wb_count(control_group) is %zu\n",
		get_cg_wb_count(wb_group),
		get_cg_wb_count(control_group));

In summary, the problem is that 'zswpwb' does not update when zswap is executed
under the zstd algorithm. I'd debugging this issue separately from the kernel side.

-- 
Regards,
Li Wang


