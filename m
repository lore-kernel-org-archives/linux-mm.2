Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E20C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427436B0096; Thu, 10 Sep 2026 09:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D63B6B0098; Thu, 10 Sep 2026 09:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E6B6B0099; Thu, 10 Sep 2026 09:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0580C6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:39:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F147E804EF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:39:29 +0000 (UTC)
X-FDA: 85197959658.30.86BE056
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 236DC14000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:39:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=twJDR9f5;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=twJDR9f5;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047568;
	b=q+qhl44iAxAM+f2mWJuPcHEqpjgNXQForH5xqrP0tJZUHrXZ9rChHovL5b8hehWSoC51Fy
	JVwbr6siZwzhKHNgFnqYnT52P6UkDpQorqr6pG4xcVjrxzBYJmvGSKmxZ3ERfmYTtmiH5n
	0YwsSzAIy5N7zldmiATunVYgJZ9bpKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caoLgz2fIW5G5su0j630YA7b4AyUWzilscsWWfTlsu8=;
	b=YtP+bc3H3jE+hyYgNi8OO+UEI2TdwmfrdrN9luR23AlD3cSyQdsSFvKZ2HzqOTuTlpkrNV
	MDXoXWE9ybzq4yKEIY5CShlqClqJ2ohMqFU/cBGfUH/b/Yhh5LFJOo3Ccmi618LH/029eE
	wleNFlnIt3M35JGWb9VDBCftfEZyMbo=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92edb12cdf2so516727085a.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789047567; x=1789652367; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=caoLgz2fIW5G5su0j630YA7b4AyUWzilscsWWfTlsu8=;
        b=twJDR9f53OiqF4i+L3CpJC8BaWC+vUWiT6Wdy856pIq7OUmiCBbTonpOJlFzMg2OWD
         mWMB+K5qvSo9ws1tGU09spJWoE2BRBuhk4TLjuolJZV97dTLhT5HPLUjLmAj7E521wTm
         rJbAS/iP/Mt68iut3/mQwTvB3oqoLeoIaSdaNzv+6jSVXtx3TAcoNv+MPHS1mrKteEyq
         RhZ3CN6J97GllGhNNiGjzpIuh82ZR/YH4EBFhVx+b6u8X4X/iG8SXd25R1t+52x/xXXM
         nU7/gEmAlgLBxAz6SKpjt63nCtYbTOSPWEDCInHSL3T14JhfrBPVPJREf1CDy1Ph6s7m
         eAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789047567; x=1789652367;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=caoLgz2fIW5G5su0j630YA7b4AyUWzilscsWWfTlsu8=;
        b=LBimXNWywSnHajHepd+71yy/YcJB0C3ejXx2Y4dl0xV6mvH4jU43je5Bqqm2LhJA5m
         HqqGoIjcFO8Db9z7ePwpOCZLHiyadrpXkgOlF5o8fEf/dja3H5FJE4MwNzc/p0uU8feM
         cpgtEaCBzESMPYaTmxU9gjeUC9nTWzQG6wwUJCABq0MgDghMVnoiYTkeYw0PlRPFQt5s
         FJhIipDk3TS2HjyhNoY9mvSB2eUqKX6zAUaI8kmrNCcDkb1qJB2jRRQ5sR6VTk+fe3E8
         tply4p2Hjt9nAeEMMvS5k3VnCl4H4M9AcRJf5hepwToORvinVdmyy0Az2T3ZgsFUFQnE
         sUyA==
X-Forwarded-Encrypted: i=1; AKwUvBzQaHaxGTpyw4UMHSsxtnwgVcFaqu80hRocdQ0UUSS7qfWfv+UCvGqzOeWhWPsJyPDq7ZHY896xTA==@kvack.org
X-Gm-Message-State: AFuF++nrPff6il/9wwiJqNOVWczXgvpSGB4fW2fLpl5aCW0zi2Hg6X/L
	5bZwGhtHrmQOQVnEyrd4QUlK/scHLdScgoF7DXhGiy9DSBhowgd+rc24NVakrPE2EmGvuvLTd/7
	AfCq2
X-Gm-Gg: AYBFou2XnaBT8clKPiZO+A6Z+jqtBBKZ+zCDdQB4aLyqJkkFC/qM1xQlEPiZMdz1FuX
	yFDQNPCS2dnUPi/Vw6eHpGqYz1oBpfLz1gI6xNBE1PFaatiLL9FcjIvthIFNRhRPSlzJ1E21tim
	M6SK+cD1xL2A9nYbXJj2BYZuQrPakcRQGp1Xsu8dYtib0QA6ws6EfchJpW9a6GmeJRwZNi5ibA4
	2XS5Vp0o58bq9TX4SUXL6nWF9c9zMCHd/Ad8378WbqJw9AC8NN9evoxcBBdSy4el4TzL69A0AT9
	/zHb0TBy6s2837lYASCz6WAht9Wi+Aq0awk6YekFjgjMDle8RgaNXjp8rPR4/LbhNhhsdtJYSv1
	O79Etcnti5YJQ2A+e7/IiJYJnJPEhbK1ga+QvA93bjURDVKDyhsG/9CoOFCNW/uVccBicNu/v0e
	m1C4kDpLZEOqHad3BRlZhOVkiIyXGRimgKJdL46I+xRNisxpJNJ5gGCpbi5AWIBI+iiRgQQIyli
	aSibRU09nyp8YUDk3YaxSZ55eUTMJfARc6h9oM34qOrjZWXaEOCw/ESxfRwqQEQDQ==
X-Received: by 2002:a05:620a:2988:b0:939:85e4:44dd with SMTP id af79cd13be357-93985e447b5mr4423830385a.36.1789047566997;
        Thu, 10 Sep 2026 06:39:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e190f8c3sm78248785a.17.2026.09.10.06.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:39:26 -0700 (PDT)
Date: Thu, 10 Sep 2026 09:39:24 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, pbonzini@redhat.com, seanjc@google.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, shuah@kernel.org
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
Message-ID: <aqKxk2Marnz1HU4G@gourry-fedora-PF4VCD3F>
References: <20260902194657.79075-1-gourry@gourry.net>
 <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
 <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
 <0386eb30-0e0c-4d8c-abfe-86161b9e3d1f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0386eb30-0e0c-4d8c-abfe-86161b9e3d1f@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 236DC14000B
X-Stat-Signature: 6kr6d1gs5qhn8eu6jos5tc7q871kw5kk
X-Rspamd-Server: rspam01
X-HE-Tag: 1789047567-562916
X-HE-Meta: U2FsdGVkX18SRJJeP+90WQrCE3deP8XDfWCLYSJ/Cw5dbuSVSxt/N+adx39APj7n9Y8QWbTgvH3utQt0yGcxgQtpbkro1splxR4fitatSI9lgvwjr0XfP4sl3ieeaA24WgVrp+h2APvjMTg4fCQ/cQ7WWydwF0ZbotmiWDFNxDFuk5vAwNNMvlR/XjCa5aha/abNaZeQqfnHpgY8c+toWY6MS7rSypINFOmeHbqAE0WOyYjyzkW0cqXb1LyV9ya9Vp4KeqoskOHsA32m6DVkIJvmduXG6V1mm4UoDUWentn4aK5w+/NLcKC+e2ImJGCVR7At9D2H1nfmf1Xs7Mc3J27cC3HsjSg7y1O79+p1uiam1WH8gdNimEptzrJ3n86NoIMigzyN1JVINPy/QYmqLGu2AbZWval4gtZP5IL5dIshFWWPgvlqudOE9TlgNa0qSSptswV79PETvSYLEYVXcv/VfQ6Y4Gyw5FDWKiOQXIoDJNpt7PHUbNL1VgoMukK5Jw88L7ZcUHAFl4fX2OnKEeTBveyV1YZxmiHOhGsO6C/D8ELUh0omuoGmt4LAlYl8L/AdAvlnbKc7XbnOB90v8yUa3C6i7+rTeBolXe289Za+G73o42PoTm+8zYNFJCLAF0Wp0hzoWkhNEZqDYcyvD6Y01vv3wEmkqRkDFfhKkSsEwLZ/4GXZEGJHiBWW2s5VZq/ztRkoIXTa5ckhvgCttmWsaEiqQuunRw8plKWe/iA+0/byA9Q9SNVINxy+TCbFH/X1t77qCDhMikwzjmtGdQmhDpI5aDflXu6Lgq0CUn36EXaQjRq9WAD+yLVjUBpOA4AW4+j2PjOAd4iJnY5es5PV4PMjN5iTmrNq+warBBFmM9Kem5ephvV9v4IAK+ZcRgKFGpjIUC9lZohE2ivsW7gzjrP5/41ZZan4qBKXrAEsG+c43uGKlg/bOjzMripWko8GdmI1NyA1bVVtWiT
 K6mhQcMQ
 VTw/bFrs74h4XjavfGV3fz+XRXy2Fnf6ZNFGbMo6ueIlynzr34vCYRDc7QqBSZA/mXDwbKqAa3tuiL1C1esR7bUF557z6RQbTyHUefDiJeWmn1/0qeRnEnEV1op3psYl6Sj0G7PHqvjRx1eSfQeCR8wO2nqi5mhUOqMMluptzLyokS62wlKyJEa08GzPVkyUJvQKXdRBIyriSVb6BNxpWUjQcgrhXeqQIHfS7KKPIlTnLYtSYswkzby92F7tone2Ph6bvLFn8qU7R44HVZAs8wug2aYkjIh8MfPxUeQ/vqF3lH0NMji4kKtbXyp/GRePu2AuQO0jpnejrThG10rgeVd0wHWGmtWqdeI31NlH7ha8jbJxho7LjaU4l/x/FMu7uUWbk2fzuNVImz1PDKBOxKCE51uSIw01cbVcmaAshGuiWHpUZD995aIVsiIkUVaiJw4uKFEALt7xVAyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 01:32:08PM +0200, David Hildenbrand (Arm) wrote:
> >> 3. Why not request the guest_memfd to be mmap-able just to be able to
> >>    set a memory policy?
> > 
> > the eventual intent is to enable this for fully confidential,
> > host-unmapped guest, isolated to a particular memory device.
> > 
> > Requiring a mapping to get node-placement is quite defeating the point.
> 
> You only need a VMA, not actually mapped/faulted pages. So I don't immediately
> see the problem?
> 

There is no VMA here - only an inode (GMEM_I), which is where the
shared policy hangs off of.

So yeah, if there was a vma, that's i suppose the missing component
needed to hook up userland mempolicy to all of this - but I would have
thought creating a VMA for guest_memfd is hacky and confusing (since its
intent is to basically not have a VMA).

Is there a series I missed that was proposing this?

~Gregory

