Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13D4CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9366B01F2; Mon, 19 Oct 2026 08:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0D66B01F3; Mon, 19 Oct 2026 08:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F416B01F4; Mon, 19 Oct 2026 08:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31F816B01F2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:09:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F223714064C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:09:10 +0000 (UTC)
X-FDA: 85339255260.11.20400C8
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id E255314000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:09:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TsAvED38;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792411748;
	b=L3LaoS5e/lQMacXKcOYCGrsGfx/g+rgHMlfAl/EmZJwmxPQAZbh0npxh488W8oBPZDaLVb
	Qx7nhhYHqnzaX1VRuFJ2IU+wMCyn8iCQBSX5MGdfZoqPGH53WKaLgjRVyoalErkXe5gMba
	ewz/A5ByPpYWxpQoWTys7ePv8aJwiAM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TsAvED38;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792411748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7Ud9f3El/BHwF00Nrwj1rk03TUfZ28/hoWdqTPVNfI=;
	b=xxxNpkn3hp1tih7PNyI/rrfCjMw3SZsutu8qmrgeVumwlWkzv94QIeytO7mc8f/cXvRwge
	yly3JktCfrt+YYydAnL2cIGjIB1GiD8qconYjI7rm7gKmSoLFJwwNjh9cGwnjySlBO1D0n
	PBnlpAa6i1uN+ZvoIls2Iul4yaqVzxk=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a06ca6e8f4so496228b3a.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792411748; cv=none;
        d=google.com; s=arc-20260327;
        b=YcawuhGqE58YF6KfwKjxgoRH4cwT3452uYTfSQ8D2l+5xUiI8sTCQiLvkwQTEt3xEa
         wXosIFcpqfsFMDC3ru243Q8QpIGqLc8FoEidlYtQSwOeFI2G5czY9BvWIRon8/lV/uiu
         BEpsJIxnRSFfNxAnGPjd8+ty5O16+kIj5A9opzdUNMe6Gwdc0PSu8gd5r/a5e0sa1i2/
         rA9ii1oxmuShLdQT3F0vS/Y1H9O2k6oqtcW5su/YlP5sMuiCrMvdG9YKfcxGDjQp9/oG
         bRCPlaY2hrcASsqwEiMwMel03qOZNiudVSKsfdb7j8TdXnnMKT/BD3yMooeFg4qQ8KbC
         95lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e7Ud9f3El/BHwF00Nrwj1rk03TUfZ28/hoWdqTPVNfI=;
        fh=BRswjrorPDJe59NAr7GLmCZa8wmOFuh7SgJhqrtZ+lE=;
        b=kmWWO16F7C0qfrzA/ZUdz0XRI3cILkz8Tipc6wAGqFxl7TDX14GHb5pZFFRsWTD44E
         XXCzCF5M26NzoasjIAGlMuqp0GZx+jqtSPOHYblE3I0gkfEos2Seki8y3WC5SWsnF5rB
         K1yVbuo83/euW1+OiMKb11EyCvJftdAyKpKxBCCyISr+PheZRP5QAT38Dj+RuC0R7KbH
         8w16HqLr1mEykXBwf1QOLCENpMb/ex4VAT7BLrYFZBpQT8PWEKX/whHlJ81BazLBIZpU
         QaW+LyyGO6L7ZcdMukJsUVGlTvehynKH777tDH3JThPOqvbC+alpZSNI0tAVCn+QhSUs
         G91w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792411748; x=1793016548; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e7Ud9f3El/BHwF00Nrwj1rk03TUfZ28/hoWdqTPVNfI=;
        b=TsAvED38PNnZAkNXRX83t7q+O8CdjvE0K54vDajDGtTTCU2yZpzV3LK+a3svW2MBTK
         8b0S6kreCOlhmx/SQxjFaxQjhJmcMIdRjUh26srC/vyPhlJrNTsNWEA/kvRVkGkAS9P/
         BdtHsOpsCoKIqkngptdYCxb8BP1ApSqmtJvKJ+Ah7om2SCkE6taCyQPo+Shr6kNXCPek
         zIeLWdCk+eGxBvFoQSV7tPLleyGEbSaqxG+9Z50V5DgbwWstdWjTXHH9fLuGEBy/pGEb
         KLxVj9caFwukiNZrGPwrXdFeoxkbFzLvemO/9eVetanosTn1bzqi7j37KaOG/m9OFsDe
         UufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792411748; x=1793016548;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e7Ud9f3El/BHwF00Nrwj1rk03TUfZ28/hoWdqTPVNfI=;
        b=HkHZzMc0K7BMFAL1Mk/htD+ZIc7MQiNViaOtz9b3Xwr+FtmkF4rTRpf8trR6lHM4KK
         vqU+P42Btyz6cApn4/ygeOzXrrfY5YTVWH8qTnWbOImQvx00asWbHLHtL2sunOcvkXf3
         AyIhepzZEqxCdmByYomSabCAzgnhZ5EQsthQCIom1CspzALw5bzL3rG9aiUiX0pt5SuO
         Jc8wnjvIr1mWZLRGWvSkoNilISx2Z29t4KQDcciYz0VF+Ee/3n5kqusApg8A2vWd9BLC
         3YDlBmCFs4YosWaXjZ80SAyhyLE0q15p2E8N6xR8M7hGAR7aMoDhKTWzMIWkYuRGIpV2
         UPiw==
X-Gm-Message-State: AFq9FYI0dfqscYS2MswUPMPHKmf+bQzvPDq3u95AzvDgJoiWDacTMpJI
	t81BfEpcIwGFB4wjs/783viOVptCiVdnszHNu/w6/CI/8aauIu89V6ZLFqhvuhiB6CaILv1ccbo
	T4HpuDPnmLmv4p9J6ZCM/N3hsuTTnMOk=
X-Gm-Gg: AYBFou0WmYcZS37FCDLQKi0nhQRhPX1PS70//W89HRti+ifOi5+QSQ/8IGTiYJZ+y69
	Zzy/8VE5jxqZlLB1A/SltiLK9IpIjdOOvTTXT1NPAwzHZ20PR1j721ZKMyOPWWTF6ErScYVY9jE
	QYCgBgbZDG/M32q9H4ghGVhgExU10CEzZyXKrRygMFO0u5JIylK7k6ZwsgAc8MJ5NiLFsVfhSa+
	7FEqYd2Nl1vdvxCOds/zgpce9hyXm+r47cLlxhNskRtKNEnJX8LEh4tlV5+ZWELMXWiW+J0cfl6
	2MjxJQ40me6Cp8LxYDQbq+czzsS2mD15VvqkZEyXvbAR5BHGSWgibjQSUlSzyc7LAEKNe/ZqnZJ
	Pl8tEqEwB1PBH
X-Received: by 2002:a05:6a00:4f91:b0:878:3783:8a88 with SMTP id
 d2e1a72fcca58-8a04ce5913cmr6191420b3a.52.1792411747433; Mon, 19 Oct 2026
 05:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-4-2106750c0bfa@tencent.com> <CAGsJ_4z3q_q-qyWdj85ZkMZvKOsXu7eO6qkiuQcppnd2oE3dTQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4z3q_q-qyWdj85ZkMZvKOsXu7eO6qkiuQcppnd2oE3dTQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 19 Oct 2026 20:08:27 +0800
X-Gm-Features: AclHuK8_w4Y468-vdC7he0TKQWZxngtWQrKxvrqOWxFYmIpExFbV_IhfkTCRLk4
Message-ID: <CAMgjq7Dqa5Thm+tXUMrg5D1oSJxwyuJR5UOU+w33OgiebGvcJw@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E255314000C
X-Rspam-User: 
X-Stat-Signature: jwn8gwxp6eex8ktx696gtpzdi93g6q9a
X-HE-Tag: 1792411748-174975
X-HE-Meta: U2FsdGVkX1/WnHTGa4zjJIy5xAF/BCgWk1614UVPm5dGR3s4MLEpOZ0slvQQfEMvvk4kyOUoUXEL+Bh/b9UErl30cgf0V+S3sIDYTiokFqoYMDPvsY+E4fF7XIaLn0SMRC/W/NtUwpfjp4hX1aW957Rx4lmENDTPtm7uP3WmQi5BLnMrueaCMdS4jF4mI5NYkMJ3BONpbv77AilDGfpuKbEXoXds147P7RMgFJjJLe/g8wGzZ4x35SM/mjUKi8vRKAYTnCyb7l23YOxCwpVwYn8TE8XQ0KqnYxgGmj6bJ+KB8IJpurzW8sVZyZ3V5BcjmmbqaG4ve9+KadT8q12HfJXwPbYYi0ffWGwdpH+X46r201wxagnflrxWjVnknM5As3dAGmiISVa9CaSagM500EhC0M0Q7p3fTg56NkSvgha3uuiiOlRU9otKwl86iW845ExCxM/vA9DoovvoxqIAORWR/0XM7gSz4BCjEcIRUOXRbjrlENHI0MYjQmvA12j0gQEtnuv8uVNx4j4giMycXs1hmAOXCuQcfYMxMkBQdcFboHALKaL8js2zFpSAMtGg+8H5rRY1Kxu167TpiG3u8FF6RqrJN33nmzZaTNR58HEmxMWoaIolOIWgIKzQbjdEhX1LLg/Q8a/hITr5gHA9RIctsIBkjg7cF2g9qZIi4qUMu6ItY6OzIRIyFix3qtbuh1pqsw7cBB48776vZR6C3aCK6RvL5EzhbP+FkCGYMgYH7sG1PH6eYcW208OjbK8Lss+OPIBcSovNmj/WLlZJmP/mVeuwz/GOWwfUBEg60KEJb2IscxbX8hqo3ftwH/hp3779LyFx7hUTp6dnCOixVpXdI47rJDaOuVnwdU/C84nIdmLFOBwFBqb0JdeV6LmCMFjXEh7qrg7eBAE8FIkzyOVJKOgoaHjjUU11IXLy6cy1qS9w2XY2UuHTp4ePI3Rriz1KX+L9ds4P1F9ctf1
 GITNSlY3
 GqaxrpZT3B0F/M4uaVewQC4f3MSRYu0n5UoJR89w5Lmu0PmzaaHCmOuJ/PHDP5VoiiliiKsrBf056VH5epS/qqoydeI9ANdD7cPHVv8JuOgTpx/89T/QuSlRGKywyfjpTIyPiK4UGm0NvG9VhhfKWuwUFJs+umuCipfS7VS7AasxrCLIVqWBNWz9DUBzJup9xSSWLyu7JhF6TuX8+oeMrYMbBSdF1W3+UxIyX+vUB2zMFoKNpa76BFSg7xpiHARZjZ/1zNDZ5irc1776sh0xZ/bCAnCI6vJRCu8m9q1lzPKmPw04fIfwIwmvge6o1PDxt8Tf5to1QAfll7OTMVKCn6yAF8+43GbwpPq3apBT9/ZDoaW3pil46pUty6y0JxVYpmY76QcqzR+5k4LZ1IuQufcASOnDLVFl29Wr872hYxYWZVee/eC13X6pucPNAM29TwtE1DcTkbfk2g6KU3GIxq9iWoUJuyGTD/yMXNf7YDhVRfa7Vl/KKoZHBNUbgNytPOEL277TQIC6mfpw464cpaEPZA2/10gre7vIOX+2A+X1LBJz2lAu/oez3JB7HRQ+8rVaqsTcVRGuYQvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 6:10=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Complement MGLRU's eviction-time tier-PID protection with access-time
> > frequency-guided promotion.  Introduce a unified set of helpers built b=
ased
> > on referenced (access) count of a folio.
> >
> > Each access increments a folio's referenced count stored in folio flags
> > (refs), refs still maps to a logarithmic tier just like before, but wit=
h
> > more formal bit definitions, a few special thresholds are introduced:
> > LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3=
),
> > and LRU_REFS_MAX (7). When refs reaches a certain threshold, the folio =
is
> > promoted proactively instead of waiting for the PID controller to kick =
in.
> >
> > Also simplify MGLRU's usage of PG_workingset and PG_referenced: they
> > become the low two bits of the refs count, with the higher bits
> > provided by LRU_REFS_MASK.  This reduces MGLRU's original refs count
> > bit usage by one, since only one extra bit is now needed to record a
> > max referenced count of 7, and makes MGLRU's refs accounting more
> > accurate.
> >
> > This doesn't affect classical LRU in any way, and it addresses several
> > shortcomings of MGLRU's old tier-only cache protection model:
> >
> > - Long feedback loop: protection only activated after enough re-faults,
> >   by which time the hot folios are already evicted, or no longer hot.
> >
> > - Limited tier resolution: once referenced count exceeded the bits
> >   limit (8 previously), MGLRU could no longer distinguish hotter folios=
 as
> >   they are capped by the tier.  And what's worse, PG_workingset forces
> >   a folio to stay on tier 3.
> >
> > - Eviction hotness reversion: because PID protection activates upon
> >   eviction and always targets the LRU tail, it tends to protect cold ta=
il
> >   folios at the expense of hotter head folios.  Once the tail folios
> >   consume the PID protection budget, head folios lose their protection.
> >
> > - Additionally, the PID cannot distinguish the access time of folios
> >   that share the same reference count, and there are only 4 tiers.
> >
> > To achieve a frequency-guided framework, this commit introduces and rew=
orks
> > the LRU_REFS related helpers and definitions; most of the work is done =
by
> > the helpers below, and their inline comments describe the details.
> >
> > - folio_inc_lru_refs(): Called on any cache access (folio_mark_accessed=
)
> >   or page table access.  This is the main helper: it promotes folios
> >   according to their access frequency.
> >
> >   A first access only defers eviction for a folio at the tail of its
> >   LRU, i.e., in one of the MIN_NR_GENS oldest generations of its own
> >   type (see lru_gen_at_tail()), and a workingset folio accessed through
> >   a file descriptor is deferred from the same tail.  Those are the
> >   generations the eviction scans next, so the deferral moves the folio
> >   out of its way for one generation.
> >
> >   Promotion is lazy: the gen bits and size counters are updated eagerly=
,
> >   while the list move is deferred to the next isolation.  NOTE: For now=
,
> >   the lruvec lock is unconditionally taken on every on-list access to
> >   block concurrent aging; a lockless fast path will be implemented very
> >   soon in a following commit.
> >
> > - folio_inc_lru_refs_walk(): Used by the PTE walk path during aging and
> >   by the batched look-around, both without the LRU lock, so max_seq may
> >   be stale.  A first page table access only advances a folio at the tai=
l
> >   of its LRU, i.e., in one of the MIN_NR_GENS oldest generations of its
> >   own type (second chance), a second access promotes it to the newest
> >   generation; this also performs lazy promotion.
> >
> > - folio_inc_lru_refs_isolated(): Used by the rmap check before
> >   eviction.  The folio is isolated and hence this doesn't perform
> >   promotion by itself; the folio will be added back to the right gen
> >   upon return according to the access frequency.  This path also has a
> >   higher promotion bias.
> >
> > The eviction-time folio_inc_gen() still handles PID protection, but the
> > protection ratio is softer than before since proactive promotion is
> > mostly good enough already.  The PID gain factors are relaxed from
> > (2:3) to (1:2) and the setpoint now spans the cumulative mass of the
> > tiers below the candidate instead of tier 0 alone.  folio_inc_gen()
> > caps refs at WORKINGSET so the folio retains enough history to stay
> > above the cold tier.  Tier 1 is the fallback tier for PID, and tier 2
> > is the fallback tier for frequency-guided promotion.  The forced
> > protection for full-refs folios is removed, obsoleted by the proactive
> > promotion.
> >
> > Refaults are now activated purely according to access frequency:
> > the old fault bias applied in folio_add_lru() is simplified, since a
> > folio's access history is a more consistent signal than the context of
> > the faulting task.  Page table access is still considered a slightly
> > stronger signal.
> >
> > Consequently the placement hint for newly added file folios also uses
> > LRU_REFS_WORKINGSET instead of PG_referenced, so a folio accessed only
> > once now starts in the oldest generation rather than the second oldest.
> > The previous one-generation grace was an artifact of the fault bias whi=
ch
> > is well described in the cover letter of this series, and it depended
> > on LRU drain timing.
> >
> > This also redefines PG_workingset and PG_referenced as the low two
> > bits of the refs count, eliminating the old restriction where
> > LRU_REFS_MASK was only valid when PG_referenced was set, and allows
> > all paths to use the same encoding consistently.  Following this idea,
> > a workingset folio is now defined as refs >=3D LRU_REFS_WORKINGSET (2),
> > matching the active/inactive LRU's definition and giving in-kernel
> > consumers (PSI, readahead) consistent behavior on MGLRU, fixing the
> > longstanding issue that these users don't work well with MGLRU.
> >
> > PG_workingset and PG_referenced are no longer independent flags under
> > MGLRU.  Adjusting existing raw folio_test_*() callers to the new
> > semantics is left as follow-ups.
>
> So this is the main course, with the earlier ones as appetizers and
> the later ones as desserts?
> Overall, this dish looks very delicious to me.
>
> I ran kernel build on my machine, the result is quite similar with[1].
>
> W/o patch:
>
> eal    1m49.094s
> user    25m31.484s
> sys     3m40.959s
> pswpin: 662112
> pswpout: 2504415
> pgpgin: 4424336
> pgpgout: 10355273
> refault_file: 359626
> refault_anon: 670724
>
> W/ patch:
>
> real 1m48.944s
> user 25m30.987s
> sys 3m34.605s
> pswpin: 467952
> pswpout: 2319080
> pgpgin: 3481187
> pgpgout: 9603332
> swpout_zero: 602042
> swpin_zero: 6250
> refault_file: 310538
> refault_anon: 474154
>
> But it behaves in a much more sensible way.

Hi Barry,

Thanks for the review and testing. Glad to see it worked for you.

>
> I've had a preliminary look, but haven't reviewed it in detail yet.
> I have a few comments.
>
> [1] https://lore.kernel.org/linux-mm/20261016213115.70515-1-baohua@kernel=
.org/

Right there could be some similarities, and some differences, e.g. no
more lru_gen_in_fault hanlding here, or difference between anon /
file. BTW did you test the whole series or just this patch? This patch
have a few workaround as intermeidate step (e.g. the forced LRU lock
in folio_mark_access, which is a pure burden but have to stay until
very end of the series).

> >  /**
> > @@ -212,13 +216,13 @@ static inline void lru_set_refs_flags(unsigned lo=
ng *flags, unsigned int refs)
> >   */
> >  static inline int lru_get_refs_flags(unsigned long flags)
> >  {
> > -       if (!(flags & BIT(PG_referenced)))
> > -               return 0;
> > -       /*
> > -        * Return the total number of accesses including PG_referenced.=
 Also see
> > -        * the comment on LRU_REFS_FLAGS.
> > -        */
> > -       return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
> > +       int refs;
> > +
> > +       /* Return the total number of accesses. See the comment above M=
AX_NR_TIERS. */
> > +       refs =3D (flags & BIT(PG_referenced)) ? BIT(0) : 0;
> > +       refs +=3D (flags & BIT(PG_workingset)) ? BIT(1) : 0;
> > +       refs +=3D ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
> > +       return refs;
> >  }
>
> Could we use the following instead? Coming from a hardware register backg=
round,
> this looks more like register encoding to me:
>
> static inline int lru_get_refs_flags(unsigned long flags)
> {
>     int refs;
>
>     refs  =3D !!(flags & BIT(PG_referenced));
>     refs |=3D !!(flags & BIT(PG_workingset)) << 1;
>     refs |=3D ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) << 2;
>     return refs;
> }

No problem; it means the same thing and looks better indeed. I think I
better change the return type to unsigned too, refs can never be
negative (gen could be though, as a reserved value).

>
> >
> >  static inline int folio_lru_refs(const struct folio *folio)
> > @@ -236,14 +240,29 @@ static inline void folio_set_lru_refs(struct foli=
o *folio, unsigned int refs)
> >         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_fl=
ags));
> >  }
> >
> > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> > +
> >  static inline int folio_lru_gen(const struct folio *folio)
> >  {
> >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)=
));
> >  }
> >
> > +static inline bool lru_gen_at_tail(struct lruvec *lruvec, int type, in=
t gen)
> > +{
> > +       unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[type=
]);
> > +
> > +       /*
> > +        * Consider a folio is at the tail of its LRU when it is within
> > +        * MIN_NR_GENS of the oldest generation of its own type
> > +        */
> > +       BUILD_BUG_ON(MIN_NR_GENS !=3D 2);
> > +       return gen =3D=3D lru_gen_from_seq(min_seq) ||
> > +              gen =3D=3D lru_gen_from_seq(min_seq + 1);
> > +}
>
> If only two generations remain, should both be considered hot?
> If three generations remain, is only the oldest generation old?
>
> Also, the name is a bit confusing, as "tail" usually refers
> to a list. Could we rename it to one of the following?
>
> lru_gen_is_old()
> or
> lru_gen_is_near_oldest()

Right, I wanted to introduce an idea of something called tailing gens
(e.g. 8 tailing gens when there are 64 gens in total, folios in
tailing gens are promoted on each access instead of multiple access,
this works really well for fine grained hotness detection, and avoids
over protection too). But for now this helper is just meant to tell
the caller if the folio is close to be evicted or not, checking
min_seq only could easily fall into a pitfall where the oldest gen is
very short.

Maybe lru_gen_at_expiry? Or lru_gen_at_salvage?

BTW the whole picture involves three kinds of gens:
{tailing/expiry/salvage} gens (promote by one gen on each one FD
access), frequency gens (promote by one gen on multiple FD access),
times gens (promote to latest gen on PTE access); We now only have
expiry gens and frequency gens, timed gens are extensions for the
workingset report or pghot design. e.g we have 64 gens, then 8 tailing
gens are expiry gens, 16 frequency gens, and 48 newest gens are timed
gens.
https://lwn.net/Articles/976985/

I mentioned this in the cover letter that the "climbing of the file
cache" will stop at 8 gens or 16 gens, this is the whole story, there
is a lot of context and plan so I trimed them off to focus on the FG
improvement first..

>
> > +
> >  static inline bool lru_gen_is_active(const struct lruvec *lruvec, int =
gen)
> >  {
> > -       unsigned long max_seq =3D lruvec->lrugen.max_seq;
> > +       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> >
> >         VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> >
> > @@ -300,23 +319,24 @@ static inline unsigned long lru_gen_folio_seq(con=
st struct lruvec *lruvec,
> >                                               bool reclaiming)
> >  {
> >         int gen;
> > +       int refs =3D folio_lru_refs(folio);
> >         int type =3D folio_is_file_lru(folio);
> >         const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >
> >         /*
> > -        * +-----------------------------------+-----------------------=
------------+
> > -        * | Accessed through page tables and  | Accessed through file =
descriptors |
> > -        * | promoted by folio_update_gen()    | and protected by folio=
_inc_gen()  |
> > -        * +-----------------------------------+-----------------------=
------------+
> > -        * | PG_active (set while isolated)    |                       =
            |
> > -        * +-----------------+-----------------+-----------------+-----=
------------+
> > -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU=
_REFS_FLAGS |
> > -        * +-----------------------------------+-----------------------=
------------+
> > -        * |<---------- MIN_NR_GENS ---------->|                       =
            |
> > -        * |<---------------------------- MAX_NR_GENS -----------------=
----------->|
> > +        * +------------------------------------------+----------------=
--------------------------+
> > +        * |     Accessed through page tables and     |     Accessed th=
rough file descriptors    |
> > +        * | promoted by folio_inc_lru_refs_walk()    | protected by fo=
lio_inc_lru_refs/inc_gen  |
> > +        * +------------------------------------------+----------------=
--------------------------+
> > +        * | PG_active (set at isolation or refault)  |                =
                          |
> > +        * +--------------------+---------------------+----------------=
----+---------------------+
> > +        * |     LRU_REFS_MAX   | LRU_REFS_WORKINGSET |    LRU_REFS_MAX=
    | LRU_REFS_WORKINGSET |
> > +        * +------------------------------------------+----------------=
--------------------------+
> > +        * |<-------------- MIN_NR_GENS ------------->|                =
                          |
> > +        * |<----------------------------------- MAX_NR_GENS ----------=
------------------------->|
> >          */
> >         if (folio_test_active(folio))
> > -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> > +               gen =3D MIN_NR_GENS - (refs >=3D LRU_REFS_WORKINGSET);
>
> Could we define the "workingset" variant earlier so we can reuse it here?
>
> workingset =3D refs >=3D LRU_REFS_WORKINGSET;

Looks good, will do.

> > +/*
> > + * Update the folio's lru refs indicator. The caller doesn't need to h=
old
> > + * the folio lock, isolate the folio, or hold the lruvec lock. Used by=
 both
> > + * cache access (flags =3D=3D 0) and page table access (LRU_REF_MAPPED=
,
> > + * optionally with LRU_REF_EXEC).
> > + */
> > +void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
> > +{
> > +       int max_gen;
> > +       int type, refs, old_gen, gen;
> > +       unsigned long new_flags, old_flags, max_seq;
> > +       struct lru_gen_folio *lrugen;
> > +       struct lruvec *lruvec =3D NULL;
> > +
> > +       type =3D folio_is_file_lru(folio);
> > +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > +       do {
> > +               new_flags =3D old_flags;
> > +               old_gen =3D lru_get_gen_flags(old_flags);
> > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > +               gen =3D old_gen;
> > +               if (old_gen < 0)
> > +                       goto out;
> > +               /*
> > +                * Lock the lruvec if the folio is on-list. We are alre=
ady
> > +                * doing lazy promotion so in theory we don't need this=
,
> > +                * but for now, concurrent aging would still corrupt th=
e
> > +                * size counters.  This is a temporary limitation and
> > +                * will be lifted very soon, so the lock here is not a
> > +                * performance concern.
> > +                */
> > +               if (!lruvec) {
> > +                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(fo=
lio));
> > +                       lrugen =3D &lruvec->lrugen;
> >                 }
> > +               max_seq =3D READ_ONCE(lrugen->max_seq);
> > +               max_gen =3D lru_gen_from_seq(max_seq);
> > +               if (old_gen =3D=3D max_gen)
> > +                       goto out;
> >
> > -               folio_set_lru_refs(folio, 1);
> > -               return false;
> > -       }
> > +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> > +                       /* Promote second page table access or executab=
le */
> > +                       if (refs > LRU_REFS_REFERENCED || flags & LRU_R=
EF_EXEC)
> > +                               gen =3D max_gen;
>
> This looks a bit odd to me. Could we handle LRU_REF_EXEC in a
> separate branch instead of mixing it with refs > LRU_REFS_REFERENCED?

Not sure how? They seem to want the same thing: promote the folio.

> > +                       /* First access only defers eviction of a tail =
gen */
> > +                       else if (lru_gen_at_tail(lruvec, type, old_gen)=
)
> > +                               gen =3D (old_gen + 1) % MAX_NR_GENS;
>
> The logic makes a lot of sense to me. It should be able to
> differentiate readahead folios from those that are actually mapped
> and likely to be accessed more than once.
>
> If we allow two generations to remain, this could be a problem
> because old_gen + 1 would overflow. Maybe add a
> VM_WARN_ON() to guard against this case?

We just checked if (old_gen =3D=3D max_gen), so this should be fine? I
mean overflow and the mod MAX_NR_GENS is also part of the sliding
window logic.

> > +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> > +               } else if (refs > LRU_REFS_MAX) {
> > +                       /* LRU refs counting overflow, bump the gen */
> > +                       gen =3D (old_gen + 1) % MAX_NR_GENS;
> > +                       refs =3D LRU_REFS_PROTECTED;
> > +               } else if (lru_gen_at_tail(lruvec, type, old_gen) && re=
fs >=3D LRU_REFS_WORKINGSET) {
>
> Sometimes you use >=3D LRU_REFS_WORKINGSET, while elsewhere
> you use refs > LRU_REFS_REFERENCED. Can we unify these
> checks or define a workingset variant?

No problem; I can use a macro for that, as they mean the same thing.

> > +/*
> > + * Update the lru refs indicator of an isolated folio, only used on
> > + * mapped folios upon the final eviction.
> > + *
> > + * Increments the refs count (capped at LRU_REFS_PROTECTED, evict_foli=
os()
> > + * then caps it at LRU_REFS_WORKINGSET).  Returns true if the caller s=
hould
> > + * activate the folio (second access or executable), false to put it b=
ack
> > + * for a second chance.
> > + */
> > +static bool folio_inc_lru_refs_isolated(struct folio *folio, const vma=
_flags_t *vma_flags)
> > +{
> > +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(f=
olio, 0));
> > +       int refs;
> > +
> > +       do {
> > +               new_flags =3D old_flags;
> > +               refs =3D lru_get_refs_flags(old_flags) + 1;
> > +               lru_set_refs_flags(&new_flags, min(refs, LRU_REFS_PROTE=
CTED));
>
> I'm having a hard time understanding why an activated folio
> still keeps LRU_REFS_PROTECTED, since it will be promoted
> to the active list anyway :-)

Right the FG idea is to always retain the frequency counts, instead of
resetting them to 0, so folio_inc_lru_refs can promote FD accessed
folios much more proactively, when a folio reaches LRU_REFS_MAX it
will be promoted by one gen.

I did a in depth analyze of runtime distribution, with this, we can
see very hot folio being promoted from max_seq - 1 to max_seq, and
after aging, the hotness info is still kept and workingset stay stable
and accurate (it's like the global aging of traditional LFU, which is
obsoluted in upstream due to overhead despite having better accuracy,
but now it comes with almost zero cost).

>
> Later, I see that you set it to LRU_REFS_WORKINGSET in
> evict_folios():
>
> folio_set_lru_refs(folio, min(folio_lru_refs(folio), LRU_REFS_WORKINGSET)=
);

Right that part is meant for aging the older folios and PID controller
though. LRU_REFS_WORKINGSET could means historical workingset, and
LRU_REFS_PROTECTED means folios being currently actively protected.

Also we are now giving the PID tiers a proper defination, tier 0 is
readahead / cold cache, tier 1 is folios used at least once, and
LRU_REFS_WORKINGSET is just the tier 1 fallback line, tier 2 is
LRU_REFS_PROTECTED which is the proactive promotion wokringset
/candidates, consistent with each other.

> So, is the purpose to distinguish between max_seq and
> max_seq - 1 even when we know the folio will be placed
> on the active list?
>
> My concern is that after the folio is moved to the
> appropriate generation, LRU_REFS_PROTECTED or
> LRU_REFS_WORKINGSET may still remain set. Are these
> flags cleared somewhere?

They are never cleared, only PID protection / eviction protection can
reset it to LRU_REFS_WORKINGSET, which is the idea of FG. And it
worked really well checking the zipf read data and especially for
multi tier DB benchmarks. Folios in

And actually for the current mainline MGLRU impelmentation,
PG_workinset is also never cleared and it will pin a folio at tier 3
causing over protection very easily, we will reset it to tier 1 here
and with a softer PID protection factor, it seems much better in real
workloads.

