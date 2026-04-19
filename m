Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8940EA719A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 12:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC5F6B0305; Sun, 19 Apr 2026 08:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CDE6B0306; Sun, 19 Apr 2026 08:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A930A6B0307; Sun, 19 Apr 2026 08:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 997466B0305
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:50:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 192951A06F1
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 12:50:54 +0000 (UTC)
X-FDA: 84675290028.15.5342BBC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8CD8100006
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 12:50:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776603052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=unEd1nmm9fnf+od1XiifMbfY6V4TfpR3et63vaJSQoI=;
	b=fUZtk0QlmLEeogot0cKJESRkleA90thaXSloLu2KpeemRdy6t5i8PE80AWo2z5p8Xkwups
	Fy4CIzZAcdp6mkdAJ16JHb5T1kPFzPS/V7yqTBEtepI/QN4cup3UsHSmzMnZppLbAgtNbd
	uJ4xh2COn3AXuCNEv9JdJSf3FqksQes=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776603052; a=rsa-sha256;
	cv=none;
	b=y0uC/aUP6Lm6Pw3plp8ErotE/vwsx8y3JI17jw7ox92hWByCp8JJ4QNlzIN8uh8nqQZtqn
	NC3qDTptdl6dcerbZbN9gReU7wp4uBogNlcgYNlBpLui8PCh2YTT3ySzQiHjraSpe6jlzA
	Ycu5M53f9+aeA51pIU7rGs6MJyfhwrs=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 19 Apr 2026 21:50:47 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 19 Apr 2026 21:50:47 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 11/11] mm, swap: merge zeromap into swap table
Message-ID: <aeTPpwblIa6LoLk0@yjaykim-PowerEdge-T330>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
 <20260417-swap-table-p4-v2-11-17f5d1015428@tencent.com>
 <aeN4qzqfyFpWJXYZ@yjaykim-PowerEdge-T330>
 <CAMgjq7CwaKWP_2yxorK88ZLZ-hRRpaLVm76jJE5mLNcX5eCg=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CwaKWP_2yxorK88ZLZ-hRRpaLVm76jJE5mLNcX5eCg=w@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8CD8100006
X-Stat-Signature: zuj1mw5gx5do5e5cdb8t7rqpjpkfz41a
X-Rspam-User: 
X-HE-Tag: 1776603050-794575
X-HE-Meta: U2FsdGVkX19tQvmlq34QLqmMBD8gRfwzC7wBEHHv11Ycpks+wi7wmTD/EKuETbzf5AveP9xxd8dsRy37eidDTMj3Qh1mEeGITYwqnB+YryqJtLUTPVXZeMpCBtZ8mvZzV0In9YYu9vWYydfC2FEEiaPaALmy6eVj/XvhqyKwPBrbFEy8O0DAi3uTQ0f3Cbp9AAL5g/fgWUSEUnoR7qwqqrbNQRtYYnF1h9+AAbg9rE5t/rAUGrPmVs8vfw2TQ5XbytygU3x1bJI69lIcTmHLzYNGQt8z4UXd9Ng9hmLa7zdrUUrEFdjM9/gZBP0xgpqaWcPV82f/GDyq2uI3CFDyr0kuTlGUb9/xrIpdsYN1Fogdbvx97JP+8U3VI+XtkfwDkyfjN2XkcP9j/iNmIA2y1iypYOru2mT11PQ6AiuaGl1NDmEUfbKZ0CZVWQJ3obi7yY4CUB85Sr+3FBb0t1n2/2NPk9SFQN11dE4CnBKrjhPeBLLCIHNsMVWtfHBN/uLCFiomjln+v1biJYDiH7pXvMmkhetajIJHQXKv11IHOueYKV3FMOlxBWsLBqFYg33Er+RN7c8z92trLqP+nk/Ve4ec8oZagusKToZqzajy2+25cwzJ474STb/FkdUcxwANONDZ9ulJEnHN0rDQS4o3iuetE3H/EZQZua8MMwsDN8l6msQJwgEXCSk6uxORCSUaeXjcQhVPiWzcS//gW1Q6SJggrC6zU6PXq6tz25FfrJUx2WbfM4mPWZ5XA5XgcjVb+oOrYcfLVRaPBAJOV753JpkVbGioLWsE8tg99Vd0IJ2XpZZQyp1tO6OIfK4WoPDKxgItf9FtGV/Q1u+QMXyo8Cy/lL5SZ7AbB5+WbGlBM83LC1O4mBf/Dc6xREXh67bs4dojdlhklfC0L1CHg4fKin0wbCToW4jYuU6hzOzCF2AsVrr8mt5LTConv8Mufr2QNWVj5BcCaFKccnE9w6S
 AIi86ly0
 paDVElembnumqaTJLY9zn8lEAeb9ARwKz5/LEqEOEJlNoOsk2Aj4vCgMGdfMhu0Xcj5gl3KOo+YSrHd1qyicOcbhzabaz3BpCv5X45iNJtwg7rIIVzQvBViLTTyq9NT+ilrj/aYBH72KUAFHcFfsOqVAtr2ADrZ5fRT6t/GnaoWOCxjbja7AVBR8T5pjrVx9FAvgrYDJ8FKIyIWR5eva/CKysxGWrD5ZMx67YQUdgHio/OF4pBuQRbI7HW8luI795iR6IuezyWcbCDNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 09:34:35PM +0800, Kairui Song wrote:
> On Sat, Apr 18, 2026 at 8:28 PM YoungJun Park <youngjun.park@lge.com> wrote:
> >
> > On Fri, Apr 17, 2026 at 02:34:41AM +0800, Kairui Song via B4 Relay wrote:
> >
> > >   *
> > >   * Usages:
> > >   *
> > > @@ -74,17 +76,22 @@ struct swap_memcg_table {
> > >  #define SWP_TB_PFN_MARK_BITS 2
> > >  #define SWP_TB_PFN_MARK_MASK (BIT(SWP_TB_PFN_MARK_BITS) - 1)
> > >
> > > -/* SWAP_COUNT part for PFN or shadow, the width can be shrunk or extended */
> > > -#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
> > > +/* SWAP_COUNT and flags for PFN or shadow, width can be shrunk or extended */
> > > +#define SWP_TB_FLAGS_BITS    min(5, BITS_PER_LONG - SWP_TB_PFN_BITS)
> > > +#define SWP_TB_COUNT_BITS    (SWP_TB_FLAGS_BITS - 1)
> >
> > Hi Kairui :)
> >
> > Would this break the build on 32-bit arches with 40-bit phys
> > addrs (MAX_POSSIBLE_PHYSMEM_BITS = 40)?
> >
> > Architectures I checked.
> >   - ARM LPAE   (CONFIG_ARM_LPAE=y)
> >   - ARC PAE40  (CONFIG_ARC_HAS_PAE40=y)
> >   - MIPS XPA   (CONFIG_XPA=y)
> >
> > Calculations.
> >
> >   SWP_TB_PFN_BITS   = 28 + 2 = 30
> >   SWP_TB_FLAGS_BITS = min(5, 32 - 30) = 2
> >   SWP_TB_COUNT_BITS = 2 - 1 = 1
> >
> > The BUILD_BUG_ON looks like the real problem. it needs at
> > least 3 count values (free/used/overflow).
> >
> >   BUILD_BUG_ON(SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2);
> >
> > Confirmed with a cross build (multi_v7_defconfig + lpae.config).
> >
> >   error: BUILD_BUG_ON failed: SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2
> >     at __count_to_swp_tb (mm/swap_table.h:227)
> 
> Hi YoungJun
> 
> Nice catch! Thanks a lot :)
> 
> > I think the right fix is widening swap_tb to 64 bits
> > unconditionally (atomic64_t).
> 
> I'm a bit concerned that memory usage on 32 bits will bloat up...
> 
> >
> > (Or, uglier, these arches could always route counts through the
> > extend table.)
> >
> 
> Seems not ugly with a ci->zero_bitmap, looks clean to me, the
> definition will be:
> 
> SWP_TABLE_USE_INLINE_ZEROMAP is true when BITS_PER_LONG is not enough
> for SWP_TB_FLAGS_BITS, then:
> 
> struct swap_cluster_info {
> ...
> #ifndef SWP_TABLE_USE_INLINE_ZEROMAP
>         unsigned long *zero_bitmap;
> #endif
>         ...
> };
> 
> And helpers will be:
> static inline void __swap_table_set_zero(struct swap_cluster_info *ci,
>           unsigned int ci_off)
> {
>         unsigned long swp_tb;
> 
> #ifdef SWP_TABLE_USE_INLINE_ZEROMAP
>         return bitmap_set(&ci->zeromap);
> #else
> 
>         swp_tb = __swap_table_get(ci, ci_off);
>         VM_WARN_ON(!swp_tb_is_countable(swp_tb));
>         swp_tb |= SWP_TB_ZERO_MARK;
>         __swap_table_set(ci, ci_off, swp_tb);
> }
> 
> There are only three helpers in total, looks fine. Allocation part is
> just like the memcg_table. Compared to this version only it seems
> onlys needs a few dozen lines change (A few #ifdef
> SWP_TABLE_USE_INLINE_ZEROMAP) and not hard to understand. How do you
> think?

Hi Kairui,

Sounds good. easy to understand and not many changes.

Another option could be using a 64-bit entry only on LPAE-like arches, 
(not including every 32-bit arch)
though that would mean adding a separate set of atomic64 ops. 

The direction you proposed seems cleaner, so I'm on board. 

Thanks,
YoungJun Park

