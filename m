Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006EC606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=zinPx+gC
Received: by kanga.kvack.org (Postfix)
	id 1DAAA6B05CE; Mon, 16 Nov 2026 08:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2886B05CF; Mon, 16 Nov 2026 08:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8D76B05D1; Mon, 16 Nov 2026 08:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D12836B05CE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:00:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE0091403C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:00:32 +0000 (UTC)
X-FDA: 85440991104.15.97E6689
Received: from outbound.mr.icloud.com (mr-2006g-snip4-3.eps.apple.com [57.103.70.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03EABC0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:00:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=zinPx+gC;
	spf=pass (imf10.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.70.46 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794834030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2VrZwSXFQpePhWr6QR5jf0LaY6vYKdX0ikOoiKW4E4=;
	b=YNn6TlzDfigG+LWZQL/6sZ48CeYi7UAwiQmw4UPrw+Q15mxH3YjZ0W6dk5U0s6Wr0dKZUi
	VvfyyPHZ3XDnm5TnVwmPoZAjVvx0bn9Iyoa64FLzE6hduSf2bnjLahge9an1kV3n6Yx7DB
	Lt2pLR80rs36I2NgvuPc/5awOgabv5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794834030;
	b=vJCt+mxszBrRMY2p7GlUKalwHUTyekYL25X4evlT6hs3RCFGvnxqpErpIjfQnd4YDFVxKk
	J+8+g1eTZYleGvbkzbaS2YAdPrGZ0Bkkt+zrg4Jd0myFrdmTNrSjdMi65Lr5jS48vk7zDA
	CUF9VmJhNFssaP54RoQL/hUrS6XPsj0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=zinPx+gC;
	spf=pass (imf10.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.70.46 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-1 (Postfix) with ESMTPS id F3DA81801B22;
	Mon, 16 Nov 2026 13:00:24 +0000 (UTC)
X-ICL-RepId: 01a1e471-c9d5-7b88-80ae-0d52a32e5e96
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794834028; x=1826370028; bh=N2VrZwSXFQpePhWr6QR5jf0LaY6vYKdX0ikOoiKW4E4=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=zinPx+gC8U4DU363yssCEHGI1pb41ifQK1L+0LqSHG5RzKgO7aB3YrlK5kQfgdRCbutdgH42F0rBxbFc3bQV6gc0ut2coKmW/tEPBtvebBUMZxE9WW2JgAUtUPmVVxrxxO0NpQGzyU3PFXmpaISHT0SCpmGqPoNFhejJB5o35gBCPRXgUJpGm/1gxqM+cgtaq6GOdAhr9pKaYbsMVsUGkHEONg77r/NIzSUb//5DOQ0ujOhBGR44ousbKWRkM7I9OQvqwrIb/sgd/7pef7oTYVG4dwlDaQHqgvJ9wsvim7mSnC2nAgqvOVjxzK1Jx3tXjTJ9y5f7dNp3tjkM/dJ3cg==
Received: from lima-kernel-dev (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-1 (Postfix) with ESMTPSA id B36D01801540;
	Mon, 16 Nov 2026 13:00:20 +0000 (UTC)
Date: Mon, 16 Nov 2026 21:00:15 +0800
From: Zhang Peng <zippermonkey@icloud.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, bruzzhang@tencent.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH v6 0/5] mm: batch TLB flushing for dirty folios in vmscan
Message-ID: <avr8QDO3CPyCoipF@lima-kernel-dev>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
 <20261115230231.21194-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261115230231.21194-1-baohua@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfXwpZDbepw2hpM
 HU1CTTwM0zxmzB11fhPuB1UzVZHlDsxfBOU/Etbi9k82hfPYmJ0+G1dDmLWXTE7wke4UZBPmA4X
 8MRKZd0Bob0h1iJE/l4EcPpfTKfFefUJD7x7dyw9vE1rkqAOxhHJ3QAUP5pEj2O7PVaobV2U56H
 zlucrlT0Kw8k1SG6tJJtRWZ2jDCI+I3UMJ6lXSqrBeqo9D2YRPpatPN8Z8U1AkvpxCjW6tjZQ43
 vr78xUO4/HfSKEP8Z0kywGDDX5lYaZ2xzY3UvZ6NB+dNfr8gbLA5VNKPcILQVDtyljMcen6Ymlf
 /yWSyDhmMtTrRT/evrX6kssOiZuzMJzPy9BEd8oj6dQEqgqirhUHJ24U3FXkm8=
X-Proofpoint-ORIG-GUID: S_Ha7s4P6gEu9WtiweQ_SwFQBvt736_9
X-Authority-Info-Out: v=2.4 cv=ZMXaWH7b c=1 sm=1 tr=0 ts=6afafe6a
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=v3ZZPjhaAAAA:8 a=GvQkQWPkAAAA:8 a=AChBciNimkdjFoktPmgA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: S_Ha7s4P6gEu9WtiweQ_SwFQBvt736_9
X-JNJ: AAAAAAABRpGbp1BOfZ5WH3DNxle6wVttZwlzG4XYJVr8c/t0p4jLXXfHcCiNXmyR7p4KDo
 GLI3jKc8yLvfcnXMbkAeM/iYQ7SUS6WGKnji58FC3WW5DSgYJA7QWJbzlYcmzAsHXg22Xv
 4wpVFLsO4xXd1Beqy7AUxEYCrNl6AmkQ4WxX5ul2I2CTRctSOFDoccxO2RKSPpYYTlymZs
 OXe0DewGhtHz8ToyTNPJbdM+3BC+ZwCaUHhjrPC46bSo6zxAHoKqsoUQJ+IVGWEZavxzJD
 KGpg+xPXoD/5IxtIio6xX36caeXft+PmC20SiuZDwGNFX4KJ9Ura5euqItGTxT/hIOkyoy
 L93vF7i7f5UJ7+S8wcQrUaM6F+XhOsc1+uEujYwGZi7exKLgafkfhxJ47lFRJ+eVsM1Jei
 iNPJY06FVU5YTcLmgkXBnD482mZ5V620AzWcjQ42uIDWI3VftQCDnj5izxEx5YDpR0nOTm
 pYTZ8zILHK4TOKfF29BaU1gHl7pd6AO8Bkw4enn/Q9kLElQdzbq5BDFYeQ5FSz1KJUwjlB
 ah54tv2wapTw8f1hottnL/e3R2Y+GLp2TuxSpP2OPQac3faOzHd0Q0P77eL6Y1r+Gi8bra
 JBvM3z3B+/mqSAyuczG+nJ6TwwzoDT4UAPBx1SecxAwXnZM/EkA+GV79M+Fpx+A1fISl2p
 21QFr528FiFJH0eKkWoVutPaw/TbgR5HtFuEu0gZQKwAloRfPINuNOltAeESUBPqMZM+3F
 AloB+WKqws63aaU8hvr2vEvBXCx8Mj4RX29kFX7QYbAjgm4AmDS15MCb3JdRhWi3lYjIq+
 rlmnsbRD8bq0+P8EDdA9X1Sw9fN9DpWqltPWBBihPPfzPRz5LR6FDnghAbE7OTjfYEnDLP
 SgaFfExrhFM9CMAdg88j8HoThosZTGViQXXm7yyf7xkLq0drfZl5oGhkUZkfOrtaAo1dcP
 XVdksnBaccvG2QI9diMja/CqR4ZTQw7Z3PFae82sKJYyVpQXJyYkqMlYbH9QOo90iivoLL
 Ss3xMH3RTqP8yB0fl4rczgIAaXDBGgnnfsW0vcR809rc9lzqhSaIAKHXEEWkoVO55IZmcl
 qQJwV6PX5Hiuyx+MENWtCe9Nd5Pj4QA6gR2haB0xp0B1Y8rO6B0Vffq/13Degj95HzMcCd
 mb2UNYXnrYbeQp0o5bXnqTMp2kQ/HDsUF0IC600tNbX3qHScqx4sFITWxgk064R0JNx15F
 TexiLzBesEFrx15HF8kmEdIr3VppnPLhuU8mQLRc9dy38HiCZBdJKTXCH7FbxsPidMWBsg
 X3DBBe8ebxjUfhrc8deL7JufvpSWrVEwJDWJ07ai0Sck5FIvHhjmLsolFTjCoSn+GNmGth
 jZCv7psRGcKw3Yxac1a3AJMV+LH4RwDw9G2XE3eFbK8XXpP4LBSWKJP7U98ZlO8uRY0JFE
 k4ohrYjwHi5xdFztyjAQFa64L73YquGEJnVJxvthpWmhXOXGYdXuNcVcGAOptk5Q==
X-Rspamd-Server: rspam06
X-Stat-Signature: rfapdzfxbx3au37p99t9min8putb4q67
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 03EABC0006
X-Rspam-User: 
X-HE-Tag: 1794834029-469879
X-HE-Meta: U2FsdGVkX1+NNso5jNUqbdT16Jreb8O78FKgHDn28OpayHEY5PvkACGE0LR4ERVkdAPhp8mwckOj0A2wDitlst23XERUUkkYTYXbDKgYJpncUec5WOrrhuyD2YHxqmhaxadn9d1zxIYMckS57llaYq9jPQzBWkBpQHdWZs0AaIVQKCpyQ1QUrP+0t55XCAczKgiznyb9HdtAFdazNL3TgiBgCCJabI4Y6z+A6wZ2EQYV5XniU9/TkVxnPrtqwWi0NpR/BmifcFZNmnh8da3/wQOVSAuJeO3iUAovWAv6kNEYcczvv8TL1jf8iOqw9Xp6t0ASMvIGvFbIz0XPcQBv6x7VyqCBDeY7IKILE7KjfG7mfsvbohlU0NzygupgJAIBX50/Jm0/pnFk4fty82IxRUauy7bSo+eZUbVAaMEN4tCw/ap770rqcUbvfOhlmqhT6jz5W03H+yNrX8+EQeExhUq0i8ypH0oy/VGYXwb5tdkqUQBD1la2+yz2Rnl5EdsP+OIN8zVi6ziBSIwMGs0KeY6z85bPihcfjLo7fBPVhaGdSc92H6nwzOPbS7ILVckiz8ZQPs2nlGTiffvLVYcR3uAk+BYEPv08DP1QRCG4MIHQBnDnA+1jwu/xDVQmQP87hdD1b+B9RvLI8Js9mY8Sos553TVVLEv9mZFHe2Z7kDDvgfu/D4r9Q2IPitDIvNXtEKtEUcsTmInojqM6stO6gLfHP7yVk9oIiPcJtWcYqiw7OQO30bzZge2ZuMKUmupeFjxnM0sSLL6NiRs97Hwbk1xv4yduZcPaJIZ1PE3j6v5bc48e+HRa5lc2h0iQg4+EmsG3oeOdzrx7/B+8strcnb+gBo5dw3Q321aiAZEHWaB+9A3EXfk6j8kUFc41CBW/wETeKFbQmEgAdMgHbniwmlVkhkVXKTcBaqvQaga1nBxj5vPJQEm/V3AmWHEKoJ6VWuzCx3lTdnDftpP2gEA
 w4pcp6ex
 N/GO05SdpdewyMtR7Y/2wPlLo5yR2AAUl0XAbdhsSGieCveYG5gtTnKf0yKhazRZlQjBeDHexGGpDK8IHuPm+9eR2vuuoljO6lpAGfMfSePKONCDDWsUaPZtFxx82HXx/RIu9wJUwPFtTpnzh4fp68r/ZUVhFMaZuzKHmi5z686f+KRYFk0YJOsnsjTQzyddYFSdh6DRQOjQs91u0m1/c2OyerSnqyZfCVVbwdjHEUI2QOGSopLFcvxrXnhuOe3O4t+1aiQPCbcHEdvJG3GLMNMstmRUpxnnguNQvTyu22kQ1JupFK++OXHViApXLsu/1jISU244rZA0322cBLUbi+1qpCJUJ/1DzDcUrBS5LjO/gTGdVhoJc4byqjHDjxen0vCCx6YfJdDVpXEydwvc8Q2gkNG1HhdS/BDnY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:02:31AM +0800, Barry Song (Xiaomi) wrote:
> On Sat, Oct 31, 2026 at 6:35 PM Zhang Peng <zippermonkey@icloud.com> wrote:
> >
> > This series introduces batch TLB flushing optimization for dirty folios
> > during memory reclaim, aiming to reduce IPI overhead on multi-core systems.
> >
> > Background
> > ----------
> > Reclaim calls try_to_unmap_flush_dirty() before writing out each dirty
> > folio. When writable TLB entries are pending, this triggers a flush.
> > On systems that use IPIs for TLB shootdowns, frequent flushes can add
> > significant overhead.
> >
> > Approach
> > --------
> > Collect dirty folios into a folio_batch, releasing their locks while
> > collecting the batch so swap faults can progress. Before writeout, try
> > locking each folio again and recheck writeback, mappings and DMA pins.
> > Keep eligible folios locked, flush pending writable TLB entries once,
> > then page them out. Process a final partial batch at the end of the scan.
> >
> > Changes
> > -------
> > Patch 1: Extract the folio activation block at activate_locked into
> >          folio_activate_locked().
> > Patch 2: Extract the folio-freeing path (buffer release, lazyfree,
> >          __remove_mapping, folio_batch drain) into folio_try_reclaim_free().
> >          Group retained folios, deferred frees and the reclaimed count
> >          in reclaim_folio_state, local to each shrink_folio_list() call.
> > Patch 3: Extract the pageout() dispatch state machine into folio_try_pageout().
> > Patch 4: Extract the TTU setup and try_to_unmap() block into folio_try_unmap().
> > Patch 5: Implement batch TLB flushing logic. Dirty folios are accumulated in
> >          batches and a single TLB flush is performed for each batch before
> >          calling pageout.
> >
> > Testing
> > -------
> > The benchmark script uses stress-ng to compare TLB shootdown behavior before and
> > after this patch. It constrains a stress-ng workload via memcg to force reclaim
> > through shrink_folio_list(), reporting TLB shootdowns and IPIs.
> >
> > Core benchmark command: stress-ng --vm 16 --vm-bytes 2G --vm-keep --timeout 60
> >
> > ==========================================================================
> >                  batch_dirty_tlb_flush Benchmark Results
> > ==========================================================================
> >   Kernel: 7.0.0-rc1+   CPUs: 16
> >   MemTotal: 31834M   SwapTotal: 8191M
> >   memcg limit: 512M   alloc: 2G   workers: 16   duration: 60s
> > --------------------------------------------------------------------------
> > Metric                 Before        After             Delta (abs / %)
> > --------------------------------------------------------------------------
> > bogo ops/s             28238.63      35833.97          +7595.34 (+26.9%)
> > TLB shootdowns         55428953      17621697          -37807256 (-68.2%)
> > Function call IPIs     34073695      14498768          -19574927 (-57.4%)
> > pgscan_anon (pages)    52856224      60252894          7396670 (+14.0%)
> > pgsteal_anon (pages)   29004962      34054753          5049791 (+17.4%)
> > --------------------------------------------------------------------------
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> > ---
> 
> Hi Peng,
> 
> Just a quick update: this patch is still on my radar. I ran a
> quick perf test while building the kernel. Without your patch,
> try_to_unmap_flush_dirty() accounted for 1.75% of CPU cycles.
> 
> I guess there could be workloads where try_to_unmap_flush_dirty()
> accounts for an even larger share of CPU cycles.
> 
> # Children      Self  Command  Shared Object      Symbol                      
> # ........  ........  .......  .................  ............................
> #
> 
>      1.75%     0.01%  cc1              [kernel.kallsyms]  [.] try_to_unmap_flush_dirty
>             |          
>              --1.74%--try_to_unmap_flush_dirty
>                        try_to_unmap_flush (inlined)
>                        |          
>                         --1.73%--arch_tlbbatch_flush
>                                   |          
>                                    --1.70%--flush_tlb_multi (inlined)
>                                              __flush_tlb_multi (inlined)
>                                              |          
>                                               --1.69%--native_flush_tlb_multi
>                                                         |          
>                                                          --1.68%--on_each_cpu_cond_mask
>                                                                    |          
>                                                                     --1.62%--smp_call_function_many_cond
>                                                                               |          
>                                                                                --1.23%--csd_lock_wait (inlined)
> 
> 
> With your patch, the CPU overhead drops by roughly 7x:
> 
> 
> # Children      Self  Command  Shared Object      Symbol                      
> # ........  ........  .......  .................  ............................
> #
>      0.25%     0.00%  cc1      [kernel.kallsyms]  [.] try_to_unmap_flush_dirty
>             |          
>              --0.24%--try_to_unmap_flush_dirty
>                        try_to_unmap_flush (inlined)
>                        |          
>                         --0.24%--arch_tlbbatch_flush
>                                   |          
>                                    --0.24%--flush_tlb_multi (inlined)
>                                              __flush_tlb_multi (inlined)
>                                              |          
>                                               --0.24%--native_flush_tlb_multi
>                                                         |          
>                                                          --0.23%--on_each_cpu_cond_mask
>                                                                    |          
>                                                                     --0.21%--smp_call_function_many_cond
>                                                                               |          
>                                                                                --0.14%--csd_lock_wait (inlined)
> 
>      0.00%     0.00%  fixdep   [kernel.kallsyms]  [.] try_to_unmap_flush_dirty
> 
> 
> Overall, I think this is a good approach. I'll be traveling soon
> and will return to this patchset for more testing and a thorough
> review in about two and a half weeks.
> 
> Thanks
> Barry
> 
Hi Barry,

Thanks for the update and for taking the time to run the perf test.
The breakdown is helpful, and it's encouraging to see that
try_to_unmap_flush_dirty() accounts for a significant share of the
cycles in shrink_folio_list().

Safe travels!

Thanks,
Peng


