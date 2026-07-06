Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C9AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E45A6B0005; Mon,  6 Jul 2026 05:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCE36B00A4; Mon,  6 Jul 2026 05:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15156B00A5; Mon,  6 Jul 2026 05:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C365D6B0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:24:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48BEEC1BE9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:24:04 +0000 (UTC)
X-FDA: 84957815208.07.1547F24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7081240002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:24:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEdF47yN;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783329842;
	b=6hzUiZFweQGePJZaaKXcDf/67dTd5CgLvc8SLPQr/xTla+0QFdY1Rjm2PEIFWVBYuZVOst
	rFnSYxbAW/1dWNLlRhvLp4FdNh5B01K9ttTvXObpa46MV5mtongM+VDjp9kZI2DzwKuRAq
	Ksn5a56iT+Ww0KFTOHTYB/k5Pg7CSTk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEdF47yN;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783329842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VCy9f/b2HN1cgotXKRxZEmm6KvtxurBOUMOHFRmRcE=;
	b=vY7Al6o76IrHwvu7KH37LZUvhPhnmb6zNHH5bueanyP9y1IUp/BGIB42anXsC5rm/Ilh4q
	vlnOL3TlMYUAHJIwJOeYNT8Zh1jbHuNzfwqrTWiA/3G68iyqTal3XG0hUsw2ddHZ15ZwXz
	yOqGL17wVoqi+MlPcs05Odi66l7IHAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E885161383
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3CA1F000E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783329841;
	bh=/VCy9f/b2HN1cgotXKRxZEmm6KvtxurBOUMOHFRmRcE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cEdF47yNLO3pphWl9Z9UJ5UIwwKD3iEFYoNj9r5BrRVXUcTQ8Xm/St37A5LqW3NPJ
	 PkpBs86OuUE2EpH7wIYgGeAmHYD3wiU/DnFPevt6zgUdFR0Oy9ZpFrS4leuHN8YLzn
	 lhb03HgalTTTif4ZcViuy7HB0X9by2Dg9wNZzbwL3wzBeEgafq04CM10AsDfoFWVzM
	 kwkt16dz+p1x0WPTLGotXgJCv9+aGukScaICd/zEacaDm+9seWO/H76rnWBRtxzYNA
	 9HF1ECi8DKQ+PWLoW272+EVWuUFC4vROVTkR7bwepZyFt7sMDycP7F5s+WePBDUF+C
	 3d2o37MlD21NA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e99ef0902so99173785a.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 02:24:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrukJV9Pw5YVoUJpL36NYnJele2g68y2/RVZI97rVCOd4bG2PQp96aftINgE2NQIl2ZSB1XltNbSg==@kvack.org
X-Gm-Message-State: AOJu0YwSMA+H0ExMR8f6XWXZeJp3E5NJ8bSmcUelQigX3fSx8e3VCkL3
	4EeYtf9z0Tf0SouPNtkry8fPOfdc/Y7eJ6dhyThxNQtAWBYw5DBAH3B94nezTZEijLl+Ys5FY8M
	f1l+lsqKsHDuffqGvrWRb8r3UhI6jOy4=
X-Received: by 2002:a05:620a:2620:b0:92e:61f1:6b72 with SMTP id
 af79cd13be357-92e9a3467f8mr1291272185a.13.1783329841061; Mon, 06 Jul 2026
 02:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 17:23:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xpy5n_Hnb4z1CC-pYqk55NMmq8XL0p7u+WYjUSYvOnQw@mail.gmail.com>
X-Gm-Features: AVVi8Ce5HO3aW-MIRduy27P7j1S6xo0Yi8WmdeV9cmeasUBES2Y1Oo867QtgRwc
Message-ID: <CAGsJ_4xpy5n_Hnb4z1CC-pYqk55NMmq8XL0p7u+WYjUSYvOnQw@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, 
	shanghaoqiang@xiaomi.com, Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7081240002
X-Stat-Signature: i79y1xdaxndtp9ugnqaep5q7nafcqpf8
X-HE-Tag: 1783329842-534006
X-HE-Meta: U2FsdGVkX19wKyDiYg6dphqx/XEVV+teTA5txWtElqZWGhCpDOdAJ0/JTDGc3jgAy0wD5BkJ5u/eHMab6p7qr1+iFJFap9+bOFRQzABxOIeR9uwnLEmSuGYJ9RfOAOg/umOf5hIcfDPzOQzFGYujd09zNmnPkfzbbcKImaZtQNy4szVehlJF6oE6h6fBA/UEM2wbNQTQYjGh4TPCJjz3QZ4gV//wzC5OmIN2VYhoIk9TK+DcY46RGuXd2DzY++NBUxwl/ZqlU73qxWICG1v7Js5Rcjbh+gpU32gZ5NTAxzP40S6Zh62tJpkXc9XZvjiGZ4YhcoN4tsq/+H+ZbxwN9g1/UjyvRQDv1vFyJzknm6kdkSMMnVbh5/MoY6si4rB0jtKUzK9GJB1Uod0rcvGbQTdVn/GD5Oyc6roMCEM9y9qOEZ2Kd3uoa94kQi5RsSu7VFvb/wwSjPiow1mX35k4SkftivG5IC+TcwMosP0b7lCgBVulCllimawVsdxtwPq6p6dYDsA2h/ka2HjAZzLHnp+UfrbvUBfqQ4gAs3fbFUpI1Wa1pzVmms9Vo5l73QMhpkmUqIudlCVdCYXq2XVBXHJmOAfaw6ngULYqm0Htj16uTz8JhW2EgZb+EnZA6j8BjJUXRgtckGxKIRw3aY6tVo+O8oBG9TMRYf+0VfB96NwPRbV148qWsgkS4VLrse5j+8HD8vB0O9LA3w+6lp1begd+2WeFaUG6wtkWbP3rKQJYJVrtFd7CjEDurRyOZq6VEVtyezUv2MymQ6K8Ca4ENzx9sId/ulgclo5UmHN0i7SR6eUZoaNhlHZQ0hhUHdEm6i36F9D1O3671onDiH6sbUe2JeLhsK/hFrTd62RWLEu/za/QqSdJhZF6cc5rFe/8lIAK/tHpfCZQ2Fc2ZEc/wLjf6xNoOBIm2dMNQjc2EEdoXfWYdMUxVSAU05gY5eLTm3lLfLDeU2dfCv4puuy
 OzSrID1z
 7zXGxXu2hiB0GMwggL0aNRdr38SKX5LWeZLudARubsspeCmTqekac8v3Etqq/Evjm//jxA9Lk0W7vNVKkSbDsAK2bRhmyGXD+zVSDFCk+nH0sk0JboN9p5E0GvCnwxG/vmzIPSn/EcK9s94vF7+w6eKr3O/ic/9cAE47Qp850trE4EChYARRn2wssEZseqFNQKW6+NdYGGbB1pJhsIa+/bjHgdMUxlTBujD76BIjh89uFP/h/lpeNyvY7iQkY7UxD090oqN6xrdW6OM1/AOs3atE3/2NzSrAVnRK1eU8/ILxYAuc/GWwDm4ipMLz3Q+C8GuAog0C8kmlUBDKrtVchmu3bpi/XTICTxeOqojSxRONRDh8V0CXCgGfffcW8sn+6azmfa+P/02o2i4S6YvFY1Qs45JHISsFhnxW3MvQ8JGmxS//wlVi86AsU9LVTpJY8u2ZTadGe+K+VZL8Qub5PznC+bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 4:43=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com>=
 wrote:
>
> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous. Two techniques are used:
>
> 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
>    segments
> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>    layers
>
> Besides accelerating the mapping path, this also enables large
> mappings (PMD and cont-PTE) for vmap, which are currently not
> supported.
>
> Patches 1-2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
> CONT-PTE regions instead of just one.
>
> Patch 3 extracts a common helper vmap_set_ptes() that consolidates PTE
> mapping logic between the ioremap and vmalloc/vmap paths, handling both
> CONT_PTE and regular PTE mappings. This prepares for the next patch.
>
> Patch 4 extends the page table walk path to support page shifts other
> than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
> mappings. The function is renamed from vmap_small_pages_range_noflush()
> to vmap_pages_range_noflush_walk().
>
> Patches 5-6 add huge vmap support for contiguous pages, including
> support for non-compound pages with pfn alignment verification.
>
> On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> the performance CPUfreq policy enabled, benchmark results:
>
> * ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
> * vmalloc(1 MB) mapping time (excluding allocation) with
>   VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53us)
> * vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)
>
> Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Please also put Leo's data here[1] and also please collect Leo's tags in al=
l
patches.

Tested-by: Leo Yan <leo.yan@arm.com>

[1] https://lore.kernel.org/linux-mm/20260626151214.GA1794676@e132581.arm.c=
om/

