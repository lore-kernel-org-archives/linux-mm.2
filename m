Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC14DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6776B0088; Fri, 10 Jul 2026 09:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587806B008A; Fri, 10 Jul 2026 09:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E8C6B008C; Fri, 10 Jul 2026 09:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC886B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:07:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90482120449
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:07:39 +0000 (UTC)
X-FDA: 84972893838.16.EB693BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB9D3180011
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:07:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G/lWcnQm";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783688857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+CDYcBcpkTmfk87RA0YnX47nuC6MQqcxomPpBBYSHQ=;
	b=zktcKzvhdwjHcMW+P8KiR+TFbAFKUlN+3MhMGB734BQrzLcEx9yc5J/1JkHa0+eZ9Vgu4o
	TMPcSyq6JCTBiQODwRlcJ2c3KgVzYhdCCZM3a4i2ho9gXUnGoF7GHrrLDOzmJwDLnL77IT
	hoT+cd56jcv2ez2jKRE/+LChfFulO0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G/lWcnQm";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783688857;
	b=vb+eO1xyvs1UPIiUIL2yc1zCxdWh716XTAsY127EnSdyoQw1tcu8+ISpQTXMbTE7PdiBH+
	yz9GXIkZnMNtfm/vcpE1eLh9JatXFZNeNUd7O08ZZeuHcxBg4KqOOi6lvonRtf7W8QTpp6
	BhAQZS7gZ3cAn9DFvfYiYPdpMSLgRxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5501860051;
	Fri, 10 Jul 2026 13:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1106B1F000E9;
	Fri, 10 Jul 2026 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783688857;
	bh=Z+CDYcBcpkTmfk87RA0YnX47nuC6MQqcxomPpBBYSHQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G/lWcnQmbsKHjMdeCniGU32sjwGqBjc17RTbBPq7kctEdtiIKBHba9AdXOhcCNRrr
	 RG2XZ43EWRs0lGYNZBNUc8M2LNk4sc56eY30S0ScGxJ8zMNMVq8o9I21aC8AnDGCnG
	 0Oi7YIncnPbmA/gbP2AuI9abNz0BQ67M4pH7XqCy5eXXXAwcwvwXH2uuqiu0zkOKmA
	 dvDkpE33K7vKkg9WE4WHG218Ckz2zm2u1qmExVNaJZXAwdPJwMdzhtc7VbYvfyOGPm
	 hvwA3+4MdsVvh1iXh09ccuD/U4gJtxC8fvif7wojpUJOPfIdFffv6+LXaWB4gaILS1
	 Ng/skXqJUlOpg==
Message-ID: <32a056e2-e641-4aaa-887e-586d997feefc@kernel.org>
Date: Fri, 10 Jul 2026 15:07:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v2 0/3] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: swukief6jt7b4yu15qhq45wpg7m48rq4
X-Rspamd-Queue-Id: DB9D3180011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783688857-289880
X-HE-Meta: U2FsdGVkX1/9vWa7PwrLLw444gEt9OQhjw12aMMstCHk/3/07ULQEpozfpSQvSPpbUNq3Ia6d4/Tie5IU5cx6TUrvxRr2Extg5rumtRCQTK/yRm52H8v/tXyY7gX3wrzgIn0aFh1ZBKmvRxxuVY+N3BDbqDF3YjiiqXt48tD1j1GeKeEnb8u2g4vdW4wxSLK1iu2FIZl4o/AUBEvRftI9lH4SB+MXclxsJNvMJkTZGrTbbexhB8GqKVP3Ijso6xt04ct+CWLbK+TQYdUBksNmsGcKX1uNMSGwiKlLosevTLgwR2xnyXXXmIfycVIUsXeQpvA2K1+USVfkHP8yCvs4wvFmCcSEm/vNOoYvG73kM9+SjSSy5yeZdcE6Uju1/n3yBnYOCj0Afs7oHsTIurp0g55Cz2DkSbS5+iy+8Zp/NvSVbv10/Wse9cgenuruMR3z7RHexmt+IkOH1I0Xw2hyRESw6akW3ha5+pmcjy62AK41gBrLc+w4fy9tRVhMsc9298ozqXE25SZrhBYb6g0zOipmSukrYRW8HoHFSHvCFLANXXCZGpV+jUpbO4b2wpz3+guAxrY58ZTNO8bDhdBI8utSt7hKnYxWW1EvR/aQxPaldzsStXGBVcaZUVS1mQ8BCoVfQ29adYJucmYFQo6MEd7wG/dgCp2MNNfyIn1ib9hsZrcre+/pcaBDOWSo29O8XArF9e43yzdIr1TE79zZGUZRD6vBRitSGtEHeJyMSNK4wNICT8pK+zcfWnWbPseH1wcSenIMj9LGMgr1KP7WBVbHCaWXzVGEp1+W4UVldwmEtr8K0tMHlwbLm2E6a7h9dBAXVtiWGNCYsbnz/IuWr6EDjOaprf86iNeT6HKWoC3ti9Ef1GNMxj7tfls9WQF9zWCQFq/8SjZDrZy8gG+OOw/RqR/ezxjo3wgrG1GaRgx8evEN435HlGbsbUMgNm964FYWOt0QQ9rnT6Ct1U
 WuGhCZH7
 U2dLl2WuzJHPPECrQUl1U2cbYNdDMSXabJPR9hI/46EolZ+55zVLQy6hufqZYz9v+e5OkMpfJx0zWOMBmtKaE2bXu4j1pbw7r7A9LTpnMVDuX9ZE5Btk6l+ujTEQOqgLSVwDQJ4Cy9mpaKICjPQyuXZAOeInP0NEYLiXcng12aF/ZAejaKJgTUztxLu3i3rG5C6WbiDYR0+2KCQHIEnJRbNZaRRDLOJ37imXQBLp4Yqir7aKs6+Id+yeAGAOHsARZDJ1B2U8nqVq8V19Yv3OAFWTHgquTW5Hjm3SUp68iFBWcSeedFhmLJTisWLOJnY/bzTStDvwsQlZ4CYYqg6jr+7iSHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 08:03, Harry Yoo (Oracle) wrote:
> This is a follow-up fix after the recent discussion [1].
> See patch 2 for the detailed description on the bug.
> 
> Based on slab/for-next-fixes (72bb229f916) and will be soon available
> at git.kernel.org [2].
> 
> Instead preventing cycles by bumping up the allocation size of obj_exts
> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
> disallow formation of cycles between kmalloc types when allocating
> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
> obj_exts arrays are served from normal kmalloc caches.

Since we agreed to investigate later whether it makes sense to start
allocating all obj_ext allocations from the new type, I wonder if for now we
should not create them at all if they won't be used - if anything to avoid
polluting slabinfo. AFAIU that means only create them with mem alloc
profiling is config-enabled and mem_profiling_support == true?
(Or probably also with SLUB_TINY && MEMCG, as nonsensical as it is...)

> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
> sheaves for those caches. So I introduced a new slab alloc flag
> SLAB_ALLOC_NO_OBJ_EXT.
> 
> To avoid huge confusion, I had to decouple "disallowing sheaves"
> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
> 
> While this cannot be directly backported to v6.18 and v6.12 due to lack
> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
> particularily challenging to backport it. Instead of a new slab alloc
> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
> kmalloc caches don't have sheaves in v6.18 anyway.
> 
> [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org
> 
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v2r2
> 
> [ "v2r2" because after exposing v2r1 I adjusted some of Vlastimil's
>   feedback and fixed a memory leak due to bootstrapping twice when
>   kmalloc caches are aliased ]
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> Changes in v2:
> - Fix a memory leak when kmalloc caches are aliased (patch 1).
>   This is included as part of this series as patch 3 makes it
>   easier to trigger the leak.
> 
> - Fix a warning in MEM_ALLOC_PROFILING_DEBUG by dropping
>   mark_obj_codetag_empty() for obj_exts. Sashiko raised this and
>   I reproduced it and confirmed that the warnings are gone.
>   https://sashiko.dev/#/patchset/20260702-kmalloc-no-objext-v1-0-167175008538%40kernel.org
> 
> - Added R-b from Vlastimil on patch 2, thanks!
> - Adjusted Vlastimil's feedback on RFC v1
> - Link to v1: https://lore.kernel.org/r/20260702-kmalloc-no-objext-v1-0-167175008538@kernel.org
> 
> ---
> Harry Yoo (Oracle) (3):
>       mm/slab: fix a memory leak due to bootstrapping sheaves twice
>       mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
>       mm/slab: prevent unbounded recursion in free path with new kmalloc type
> 
>  include/linux/slab.h |  16 +++++++-
>  mm/slab.h            |  15 +++++--
>  mm/slab_common.c     |  18 ++++++++-
>  mm/slub.c            | 109 +++++++++++++++++++++------------------------------
>  4 files changed, 88 insertions(+), 70 deletions(-)
> ---
> base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
> change-id: 20260702-kmalloc-no-objext-2619c1e06083
> 
> Best regards,


