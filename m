Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3EEC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 13:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431466B0088; Sun, 30 Aug 2026 09:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E14B6B008A; Sun, 30 Aug 2026 09:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3966B008C; Sun, 30 Aug 2026 09:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 079A36B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:19:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62C3D402D0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 13:19:44 +0000 (UTC)
X-FDA: 85157993088.17.1864873
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94D96A0007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 13:19:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D7qER2D2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788095982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uiqs0BCvjorNclyNFkKLNj8TJ4SrTKmwWchdlF5iZdw=;
	b=X01F8EeWuLElPjZp+mIqdwVeGHWGOY0cAJReOjY75pb55T+rVoDN2WnxWQhm0CGHUrHKHm
	F9rGRfxdGlC8E8HjG50NpVdeKNmb10hWLMN00fTDDeMHQz3f9wQvq8xEf88iIBlG+Pp2UE
	TzILI1rrGG3vQSlKy4Ni8qxl2w/ct4w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D7qER2D2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788095982;
	b=TNa730LD0531MhcmBtTERNCj9YcFV+9uinRj9uin+YB3juO5HwBpDF44bpuo+EPaeToo7j
	XQTJ53S46ucy6zZJ6Oj+dqQ/wLKXtVtvKmAOesgV5Go3HJlmSg236/47OS2M9L2Tm5jlHt
	e92fQODTHvLG76JR6SsEg/LMcQdLWzw=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc1c8d4a959so1870272a12.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788095981; x=1788700781; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uiqs0BCvjorNclyNFkKLNj8TJ4SrTKmwWchdlF5iZdw=;
        b=D7qER2D2vuLUM8OZB2GzE97SXQuak1UGy5cP+87DmNPXIS+i8zzNubp+4GH+YMZGL4
         m8eFcFcX/R8Y8/L3zTRiQcrNnuwQbOaIoaUsGgwiRYqzEL5a2XM8usB0LmWIBn/ENLgM
         GITZDpkgYREmQbvnWHjV9Xp9PvnFtPSZmBc7qyWTsd5PUVxzjdcl3Vrb8B399cSeulCF
         AART1otZhOqg5OwDUqpRIM4joybl/gsSeYs1sq+pAqKnRz7pjLld/w8CjasFzgYT4qhB
         sDb2oGgibBbLv3y7TgI3xAinvOelCBE6bjG+KiWUx9IeQIFWdKMZTY5ol+Z/bocAlEcB
         CspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788095981; x=1788700781;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Uiqs0BCvjorNclyNFkKLNj8TJ4SrTKmwWchdlF5iZdw=;
        b=P97gsL25rCPBPtCvUOfMnFD1ZGM2F6ruh7JFm4LbJAh3Gl9KY4z45zwfT0e2czU2K+
         yHrjmILklzEXJda1AVCdfYR8SJQDJQBnj8QChIID2Jj6Hxw6+7t5SM/wIzxw5IiPuSCk
         p4t0N1jYQ0LUzY82qT9/9qbdZdkVh8hrG0QIvYxxoMZGnzNyUWX8ggihjNhDlcgiXSiN
         RR5y62r2REJ9jpwKAX7miQnFKbSUz5lN277oX4VaO/enr0I28SWioj+UofqXhDN8sJ2+
         AKvL8lMOK/JdzEaMHvg7DW144cASrpC8hue9UUgghEmw/Ye4y2qNcTiuhXnl1K387ghW
         6FsA==
X-Gm-Message-State: AFuF++l2sja+X+9CDgG17fHl9ehBUpYC9zjmFeRPZhQ6GZptJqHIXAmJ
	qr2v4plYVLMxe4ydFlzpjiMKYh7cI2J7Nf9fHCvdxCGBlwixOzpaQatJ
X-Gm-Gg: AYBFou0O2Hyuo7EdLYU0tN3aKKkR6Trc0Q+b+FpfGkTPrOrRAPIFzihnscH7fjhGSyX
	7E5Q4FAfH9DKyDVslCHZjHVO04ABXnTQmvWaMLPcsT4RyY173A/4RjEGkmnZ2E2krPROhs7+Dlj
	zkGYSgOforpGdcJ2PzWo/NECo/JYPUfNfrtbfSrVgHqTVuAnQr/tvyRxDNEl1O/61GHlFi3lImJ
	LAmuyun/EpA4CbOXXXuk92rkGznmSYR9esRBnXkch/yb0ItBCsCyf47EZBm0LoS6OQWn3DwdLXB
	vzEi5uVVjgkpcjrOpRulHntRCD5orDgwkb0EXaaelRpKy08l+Koe1d7MPyttq//z1YOqqNwXIHz
	7k+KQR/CS1n8qgz4ADund7vxWwrkDv39XxzoDm9glBiqv/kS+IaF0S7GHDyuNMZXnHilEwO/399
	cndSwP+hsdqml/WRVJmhOpFv0KP1KeHZe2uNcumKU3lokdgVcquEsBqy577Jae92pmncs49SnI4
	lCw/rfHrcqlM/pzvgNrI3NU
X-Received: by 2002:a17:90b:588f:b0:398:bf7e:b267 with SMTP id 98e67ed59e1d1-398bf7eb378mr9877078a91.2.1788095981307;
        Sun, 30 Aug 2026 06:19:41 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a2f5187fsm3023979a91.1.2026.08.30.06.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 06:19:40 -0700 (PDT)
Date: Sun, 30 Aug 2026 21:19:32 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>
Subject: Re: [PATCH v3 15/18] mm/huge_memory: lift order-0 restriction for
 swapcache split
Message-ID: <apQs7U5eveKKtPxX@KASONG-MC4>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-15-9b43f5163238@tencent.com>
 <ba386e23-1b05-4897-98b0-ced78df6dc25@kernel.org>
 <CAMgjq7Dg5pf_MR=C_KqixYmyfXyD3UpKoR_6aO=aBpZsY4yJEA@mail.gmail.com>
 <79aaca61-4e4d-4f1c-9492-41b00bf6ff04@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79aaca61-4e4d-4f1c-9492-41b00bf6ff04@kernel.org>
X-Stat-Signature: cqam1rt3pm74txidmia9sf97ry6wpy9f
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94D96A0007
X-Rspam-User: 
X-HE-Tag: 1788095982-726231
X-HE-Meta: U2FsdGVkX19ii/XsikYZnftf1uGdAYdNQadw5CIfzD4hCw2PoWhGgNfZjxHhET/6iMe8ApTPm9Y3Smr+9YvWWfcDGpwqheg1uwNRA6TLBIuD9Bu73IbACImKU91V7Zz+deY8waEC+bbHCgHTSTd/D5RGrd6+ox5rv6Ya6e7nmT21cT6dO5+4CCqfVv59wPNdxoWhPBxhAjl4t08RuPJ52wPfcXwLjeXGs45o/2AkPekf/WeTWYp9KfvqFpjlWKULez9+hTjXr0BPo7H4V2ZWT6+uB9KqEw2fBleBb58kBJuxEWJrly0T1qy0P0p9WORa6Qnks5+QEQkRhkoJrFaNcOGzJ/d9n6kkHD2Vrawh4o/Ois2eMbtkV1N9xspsU2XwBy9ezJTxMG4mMeAPNIq5Ph8yvMAEg/LRVNqXc1Rqzq7dhJL1mscvpsohNKphtlxLmdL50SYWSkTnw6rmkP9DUCHXvFhNxxx9rFQzJNQRljeHEV3hS2PFihQYgyMdB+yRj1bjTEKH6ndWJYLfp+TOKDbnVirl/e96lZo9ftbowlulSV7axeh2L2HTg0zTW+G/qPuqm99A8qak3+jpWBQuzkPCrnf9w8vTjZ5ITlGj/o6B0U+4PxwL/z6SJzBgo42KYGcQJ45VC9yi7PMyT5OTGnGvBT0xs3msqKzbdi/Vmvy4w0IHBkEydBqeojitTmKsqrasbdZe9UA4PXYTl48/6JilROBW3mz5IZqbMuGCmkFq1yYuyeV/b91/bL1il6rwg+OWr+udmirMz5KYgUqKGl18PERCCeTfbWNlgNSWDugJVEiBZZBZQtFJkPg/su0JCN6PG7suZntYOtmn7l3kQcKG/2NUIu/ROHtMaxcjDJq+PymDEVO3nv7M+8IoZBbcKTKDvIPf94FpxWa10KANx//RanbqCgKX6qpuiLHvFZHjk0QWkF1E3FBjucG0CcCVRvuzwFa1r32FpD+vIJz
 Fm+7dv5a
 LU+sNgd607Tm7IV4rUVNWxJL3rvgNFxhcEMfDTM18aWtM4qfTSx5h1vaqljqtq8H1ECZ4r1CfHdUqXxPLe6N66c7a0A4q+o6RznBUWThekg9b0kK35gzy68p/SBvI0NQtXXuLpT85oAyUCtQk24vKfv1+aMbrYt5RHwCzqW+7wg7c0tRIT7msftgDKHEhOjXVEtOhzpk9gfKiuuafci0fXT7PjwjwHlbFXDLYRDVlw3ymefgkfCagMDdkfv/Qr8W0waL4iZKQ9wbTuydYmIQx3wrlofSnue0/Asa2u/tB+7+x0NnZQAOsXc9D0YyuOpDpDmFLcDxrL8Hhn660OwapoVIYcGJixYTikrQ+syjlCEuOatTa8AFj02ec+b8Vgk6W9wisvQbDliINsOLFBsXHl+AhBOtKSjExNtq32hIySYy6OqSmtv0d48/xTtJfWNvBv9/gCIyMhYd6IhRwGWkIrhmfopeops7J1B0VifXhtjSM90sA6tKzyItVkJPgq6Ka8fnH1fdMlzp4rYfWmwHuZGpHiov4Kn+4LnRtfNQ4Vua2//1bKBLJh6PH2NzOppUZ64m3az0OK68vQT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:22:56PM +0800, David Hildenbrand (Arm) wrote:
> On 8/27/26 19:48, Kairui Song wrote:
> > On Fri, Aug 28, 2026 at 12:51 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> The restriction that swapcache folios can only be uniformly split to
> >>> order 0 dates back to when the swap cache was managed via address_space
> >>> mapping (swap_address_space).  The old split loop only created order-0
> >>> sub-folios with a fixed stride, so non-uniform split and non-zero order
> >>> were rightfully blocked.
> >>>
> >>> After the swap cache switched to swap table under a cluster lock,
> >>> __swap_cache_replace_folio already gained the ability to replace any
> >>> number of entries for any sub-folio size in one cluster, and the old
> >>> swap_address_space locking and limit was removed. The restriction
> >>> became obsolete but persisted through multiple refactorings.
> >>>
> >>> Drop it now: swapcache folios can be split to any supported order with
> >>> either uniform or non-uniform split, except order-1 which is not
> >>> supported for anon folios. Mappingless swap cache folios could be either
> >>> anon or shmem, so for now we just simply forbid order-1 for all swapcache.
> >>>
> >>> Acked-by: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> ---
> >>
> >> In contrast to the other cleanup patches, this patch changes behavior.
> >>
> >> I would suggest to send all cleanups first, and send this out separately, such
> >> that it gets proper attention and doesn't get buried in a sequence of
> >> harmlessly-looking cleanups :)
> > 
> > No problem, send this later then :)
> 
> On second thought, the
> 
> "mm/huge_memory: allow splitting mappingless swap cache folios"
> 
> is already such a change. And I guess only having both these behavior-changing
> things separated from the cleanups might be harder, right?

It seems actually not hard to drop these two, and keep mostly of the cleanup,
will send a V4 as pure cleanup and tiny fixes. And without these two change
it actually looks cleaner, and shorter to review. Swap cache support can done
seperately later.

