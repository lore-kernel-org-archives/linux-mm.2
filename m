Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1234BFE5214
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6783C6B0005; Fri, 24 Apr 2026 07:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628CC6B008A; Fri, 24 Apr 2026 07:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F9B6B008C; Fri, 24 Apr 2026 07:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44CED6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:53:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9D08C01B1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:53:37 +0000 (UTC)
X-FDA: 84693289674.11.61960A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 508FB40004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:53:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XGHeCumi;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777031616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgllW9MhwY2i7ExISGq4a4MBTjLWeZkGtwZpDRuz9iI=;
	b=AHbsWgaKZwJUSDfNrOsq+3Zcz7ZkGI5DSZXGzHmSjve4/4BC1GVU6y9qPBWcsRu/gKRCrm
	Gyi1TFzwHNoIO4ld6zoG1S/nYXy2rIXUP2xIFLYd1OeebEFVYb3rVV8d1q0KbnWCqJFRco
	K6wCFLQMwZCNxTFhnRWYULmAev+/Sx4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XGHeCumi;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777031616; a=rsa-sha256;
	cv=none;
	b=bEmVmacA2tFxNU2oHlOEBy5/NzCmiBgde8s7ChdGwQpZJz4pzWb4fm74qoSq2QJSofvKFW
	75PfaiHXx1SwnleAZamFxzajwNAEQ2WyqtfeF66jc6NJxMvYMmzU7Gv9NToQZFPcm8j3mw
	CChB7Qj8u7kvE6hkm966D87FoOf+/sE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 803F3600AE;
	Fri, 24 Apr 2026 11:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2554C2BCB5;
	Fri, 24 Apr 2026 11:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777031615;
	bh=ElAcgQXNRHYhayu5c+VNdA15FV3TAK774nNECHjKGFg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XGHeCumidfXtyQlwlHTFHq47UBB7t2V9ZZ1C1JtNFAG4K1i9dk4/jj2eukKjcckjf
	 eeHHvUji2rdbDymzp+D3Sd9ljHbmwegU7IJQ3tnjAcEWa3Q+iIGdcZtEyRxN1d+tUV
	 bYVz6MRaozMEEpt9keoFc7YISYEMa05veEKs9Eqw=
Date: Fri, 24 Apr 2026 04:53:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lance Yang
 <lance.yang@linux.dev>, Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui
 Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, Suren
 Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, Matthew
 Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon
 <will@kernel.org>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
Message-Id: <20260424045334.ce9801ecd7a077bf3d5e4ff1@linux-foundation.org>
In-Reply-To: <20260418120233.7162-1-baohua@kernel.org>
References: <20260418120233.7162-1-baohua@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 508FB40004
X-Stat-Signature: x9rpn61farfsf5s5byaoqttkkfbr1gh5
X-Rspam-User: 
X-HE-Tag: 1777031616-376610
X-HE-Meta: U2FsdGVkX18Xtp82PKg0WIRz+s6/rvIapaWrmpyW14kK8d7ClF67+ZU+w+JwtNeopr65CFo+93OEC35Tcxi2bh3yVJBQJkLd/30fDHCJ6EBAonf7L7oySxMKhmyFXcweHwFpd3n7VR6Ap8r4f39gWG8zD9x9/lTRL3jhw4uaLpNY4EXYaSj+7D7yxId6ugq8K3/efrvc0coI+2iT7SBVCaez9SGAxgPKIZW1/pqcHbo8Vfm0ac79V2xW5dHk6if9bIWF9OQCnp13AVB6svI/WudEHKBaGxhyE5iUhZGDDlN1S2C7a6c7t5BVrxI5fUCypy+Y8g1rXNdE7/OSYLocl2jX5dkUlPSc4unHU7FKjVOlVoOSrdZl0GrpAhhtg+54DprWiRLPXWoacUKe4MFqXUPxGdExpVsmb/H7lB0AmxMIXxVqSeYoJkMtNTOenP+x1/AlksUhbvaOI/55O1V9VUn313WYanWvNsx6bvQb++a3UUseSZyyAZ+4U2C0O9VAkiEoCBx7YUouQVzchR6NdfCabjC9XPFTp7KwqI2zOts3EaByhF4IGUmbDCPV4Zx/sjItF7MCi3trwQfI4HeZSazux9tJCqxlMHYBhJTwFTTXC7FNsVIrOD2bVrUNE4QYkw+VuO+qJB1+JVf4m9C790OtzK6f4SDQxR1i9XVUL0W67QkFBftXq7PulmZyAqxiFLP1FWm6BKllpQhUfyjoKLLc6Qwtte5RbJ21qqqzFUMNgpYCRijwDUvBJDEs0w9a7/rMjZqzOsz7BkUS8cdsgX2Zfj41/TMdq7DHcwKvszaOUQ7IYN9poQrxdggh6LPIrBW81U2M0mLaEPHa21bTYGoNLA3dSWUhgm86CODv2krxwiLVILAnAOd5zu0PCDh6eC/jVGx9tM3goOrXzgqEGFbBpJ4G36atHTyae7S2+oYSNpvrKCDrQElpTnRw6PQvWApr/7Mx/4inUFDM/YI
 nZlycD1A
 8i0I9AOcEa41UZmLnJTIxQVAAfD6K9OW8eTbTU8DW1UoSYGvno0GqXVPBTUD6VojQc0tJj5fXg3cYvCt8a3tkRNSfxk6Ac1auKbHz5D4OAm4UKXeVJ5mUyZTlWKZLTLaK1sNLRPH5jCfTw/J4QfWPAgdDVXD5WSJWfNQHCenCEXRXAOcSsLGnQtd+lebTOGCLj4h8tapJ5opNUdHcIc7lRbMf3DNczcpi2Ilooo7v8r7jTmzg4d6k2wAyt0/4PNa6IwVSyoe1FNds5/No+R/z/lTbxDhy+G7DC/0SHfSvovoAV8b+ULpaN+QrB2awVLcSfLbil98V4rnTjG/yaZ7EQRgO0cphYesp8cARqJuo1uD5hBVIG5GX0yvKLgXerZ8hGDrPkLp1T7QbIT3b0PRDJX5KwSJUHNZUn7Z3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Apr 2026 20:02:33 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> MGLRU gives high priority to folios mapped in page tables.
> As a result, folio_set_active() is invoked for all folios
> read during page faults. In practice, however, readahead
> can bring in many folios that are never accessed via page
> tables.
> 
> A previous attempt by Lei Liu proposed introducing a separate
> LRU for readahead[1] to make readahead pages easier to reclaim,
> but that approach is likely over-engineered.
> 
> Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> protection"), folios with PG_active were always placed in
> the youngest generation, leading to over-protection and
> increased refaults. After that commit, PG_active folios
> are placed in the second youngest generation, which is
> still too optimistic given the presence of readahead. In
> contrast, the classic active/inactive scheme is more
> conservative.
> 
> This patch switches to folio_mark_accessed(). If
> folio_check_references() later detects referenced PTEs,
> the folio will be promoted based on the reference flag
> set by folio_mark_accessed().
> 
> The following uses a simple model to demonstrate why the current
> code is not ideal. It runs fio-3.42 in a memcg, reading a file in a
> strided pattern—4KB every 64KB—to simulate prefaulted pages that may
> not be accessed.

Are you able to suggest any workloads which might regress?  And test
for those?

> Without the patch, we observed 12883855 file refaults and a very low
> bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy
> hot positions, continuously pushing out the real working set and
> causing incorrect reclaim. With the patch, we observed 0 refaults
> and bandwidth increased to 5078 MiB/s.

Wow.  And that isn't a crazy workload.

> For those who want to try the model on x86, you will need the
> following in arch/x86/include/asm/pgtable.h.
> 
>  #define arch_wants_old_prefaulted_pte arch_wants_old_prefaulted_pte
>  static inline bool arch_wants_old_prefaulted_pte(void)
>  {
>  	return true;
>  }

Can you propose a patch?  We can at least toss it in there for testing
while we think about it.

> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
>  	/* see the comment in lru_gen_folio_seq() */
>  	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
>  	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> -		folio_set_active(folio);
> +		folio_mark_accessed(folio);
>  
>  	folio_batch_add_and_move(folio, lru_add);
>  }

lol, I was expecting something larger ;)


