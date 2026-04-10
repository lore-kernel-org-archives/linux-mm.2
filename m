Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED84F364DC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25CE6B0005; Fri, 10 Apr 2026 07:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6076B0089; Fri, 10 Apr 2026 07:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33046B008A; Fri, 10 Apr 2026 07:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C575A6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:03:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9037259007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:03:21 +0000 (UTC)
X-FDA: 84642359802.06.43446F8
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B27E160014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:03:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iJoGufjQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775818999; a=rsa-sha256;
	cv=none;
	b=xkBi1JiWLhG+MLZJsO5aG2yQwpqdG6tvyC8z8gA+hlBhYNc9V41ULaD4XoskmKFKXvDRFZ
	KBpglMS3kBMmdRYkjdTBHGgE13AaQxPIlGDiGdgDC5+fQAhpt28nSH53GcGwC6u3cgF46+
	rVVjk4GJ/KpgfGAT0CLr69nRr9rLu3k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iJoGufjQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775818999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bka1cw1Qi/26a2+Jc2kZb2RQ89wlOuzga7814xjpSI=;
	b=rOf0MHvp3O0eYbaFYnySWyrDdrwt456b4ChBBF62mtxejtqKyys2XA/38RqZi/wMkpVd1U
	+oPHBGbFlScdJMK1LeeZUEbAJ/tRqQ2jD56wkMt9QCuv3vsJU/BnvCzQDAvjUy55t0zeGO
	BFiYrt80zQovVDPV7Ib+HXsjV3FPRmg=
Message-ID: <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775818995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8bka1cw1Qi/26a2+Jc2kZb2RQ89wlOuzga7814xjpSI=;
	b=iJoGufjQVaQA6OgKeg5PcAsyZ8KZg1ybHyCC/iI7k/7xV/aIhUEg2lF1iVeMxXrG9M077+
	EoC6fgrcjKXP0ZjKnjkT1Yvi28Vfmm6jVAR3ASkUYQ/Z0Ldz7JnJE9po7D5M3BnsWEuBwm
	p8XAjefEGV13yARmt8akLWTc9caFn4g=
Date: Fri, 10 Apr 2026 12:03:03 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
 rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com,
 hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 leitao@debian.org, kernel-team@meta.com
References: <20260402181326.3107102-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260402181326.3107102-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fw3aninmw5mdpqn3ru9sbh519yoxeng5
X-Rspamd-Queue-Id: 7B27E160014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775818999-560203
X-HE-Meta: U2FsdGVkX1+HwWgvfd+EXIHEURiABTX6zQOoy0ZLH31BU0hVWXh0tQikQX/F1m2+Q3RxkH2LwpUciqCNEMGJZXyY5TJspxhZSIQF7dYVI5VRmvYnGOt0VZVJCTw1ombAyZP09XGdEhXJkDWm/p33Jr5mWQvbKbMhyTTYATe2VYOfy5TK/C1FGK+7DGwoW8Hpa8sBli3jzrtJ1dzVtb+tV6nwxAiW0G1bCt7U3ANUBZFkInGWiUZbhS8MDg7c6CoViK9R4/8pOzQI9YQ2sv4C+b0KurXHSvap3YUf+TGlRgRC30ScDyChkM5I8Xp/7AC/ahpa3qlqxZKcVrTugH35uoxgie2b59AtwUxNPnTcCJzHsa3kxeDvza3Poa/W8KM4UIjnMuIApF73fiRDwwA8HZjwCw4UMFXqLu8m+FDYJFByHoJeEPf6dC6mTnLkSIFLnnqPdGOYDhkbICmGe4M7llsEbDoyaBrL72q0UE22jP3q+mEVL3J4T6M411HGF2xFTtZTur5Tp+WCVWDZxgqU2SAEdf4wvxmRKXxKvDm0FJdo0VxIegdNR4z7iIndb0ph9osvFlKok+hqf8+cFDZiefiWRKNXFMEo4x+f8MNuT3gvfrElhuNHcAv829dVkp8UoFLTBucvlndFHz2gTdqdHrM7BIX5D7GBg/v29IYQ5a/SKW8CYKm4TAUKeCE7rR4gHUdrygWbi9sQlUYlhauJ+3/Cf8VLU+PcQlYe8RuCav6Kz60CcFb0RDp7sKO49Z0y5BZ5wnqU60KIrLwzN+sPp/knFGwRbUR1Z0euV93GChcW6UFgiE72++SAix/io//JXWWpDUVUAWGkQHzn/kwyLIonWM3ZeBN3ajDlUMlhntJmz8jYQ7PmZ9S23ob0UJ0Yt2YTFWy1g4W2rVlYjZAw3zgbt12ibZQd7perQgRqSe1NzkBrxuPaoS7AqYy/HAzCfGrbmJi1/EfdpbC9RyK
 hhpTzj3V
 GYgxnlcDE8fhh+jaN6R07+EU4SVGV4mOXIj6znIIixgKh5fATcarWxLpr2l//57IwguxJmGKLvHFPH8zVTaWs7QE2Px5P5KjsflOgHK6WUqXZzLWdla/ZkYef5aVTq37Am5H+udQ7OXT9IKUVkxtDKpIiUCK2MjgeEcCGim+1V0YyB0RwjUgz3w1nImAhS3dHjTcwWI0cHf/smo5mUt8Iy7o6ETI0pP5hoVjOr5pib6Hro03IiGZr13oOh+WjQFVDEbhC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/04/2026 19:08, Usama Arif wrote:
> v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
> - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
>   to HPAGE_PMD_SIZE limited to 2M (Rui)
> - Reviewed-by tags for patch 1 from Kiryl and Jan
> - Remove preferred_exec_order() (Jan)
> - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
>   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
>   do_sync_mmap_readahead().
> - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
>   page size for arm64.
> - remove bprm->file NULL check (Matthew)
> - Change filp to file (Matthew)
> - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
> 

Hello!

Just wanted to check if there was any feedback/review on the latest
revision? 

Thanks!


