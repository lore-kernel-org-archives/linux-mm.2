Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005FA60A261B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ef6HJQ1F
Received: by kanga.kvack.org (Postfix)
	id 1CE366B05B5; Thu, 12 Nov 2026 03:09:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E936B05B6; Thu, 12 Nov 2026 03:09:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E816B05B7; Thu, 12 Nov 2026 03:09:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D60F36B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:09:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C83E3140509
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:09:10 +0000 (UTC)
X-FDA: 85425741660.30.8FE9F24
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id B03A41C0009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:09:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ef6HJQ1F;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470949;
	b=XiZeOt617LHD56eu1Ur9H2DdaP7O0INRuJOzEYVnua1SWmVACpLtQwfRUrxt/y8eIs4I2M
	5pz/EjAp7Rrus23tBZXbCZkFd0LObfkdwkalWCaPbEBrgK67ICopAqS3uxeyK6gnNTgMd6
	b7RiDKjMNova2cPOMnB7kQWaQObouCk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ef6HJQ1F;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47XZdRfBE/Mu+f4vGfvNQyMttNaXDnZejEnBAd4jy8c=;
	b=GwtvdbiwDKrwn/V02+C9ans6a8Ail/p7WKTDbxKLCLGSe6WePIbL0rW79Z4oFMkVBlkidP
	N6w/Tym01hNPTquy60n32KmkxXwIeUqt1iPZPRaWDXL5yJxVtKBA/vVAkA8vnOnez4eJPL
	5OtB5TgNSIdVt4FBEYtc2kMXLSOHJdM=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-490f38e9688so480912f8f.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794470947; x=1795075747; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=47XZdRfBE/Mu+f4vGfvNQyMttNaXDnZejEnBAd4jy8c=;
        b=ef6HJQ1F6L3LqF33TUb3n0y2+vU/d0qShiI2ksly+pLYXdrkqiAAwKxfAXCMtCYGzE
         LnG99lnDXRa9NCvjxDd8+dZBiYlFx5z4XNSOvpae8/FQZVWQs5tW8/L1/58WGHKmJJc4
         SsBZTzG4z7WUSbRTf6rgQzyEAP6s+IhByDpK3YglH9OjFHAiVZV2d8zYLtXSUtvPz4ik
         ZoiDzA6mm9plLVMJh2PwppP5WyWJ0avRCPYyFy14SWxhTar9rgIoRtCUZGdi71psqIMD
         pjAEEux2bFOanSWjKgbaLqcKrRg/KXSe8LxN4jVaiiAzY2WzyibaX5blBWSppi8l4Fdm
         S1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794470947; x=1795075747;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=47XZdRfBE/Mu+f4vGfvNQyMttNaXDnZejEnBAd4jy8c=;
        b=CcTo4h6NuFXuZHq94W/+JhkJAckGpOK6CCm7zrJseiufH9vF6hsax83pkuuYHgY73B
         F66W0XDuj3SeRvYJsRuGvcgKjBtb0djaAhAaJC+oQimg3FYoFlWuklNCELqwLLhgoTIk
         ZK+k32N9lakVKBgE7ol9KkqOa7zwl56oHFJBZ5U/ncNI7bgErL3V1s8Bgx3rIXL07CJS
         0RJ3A3VZUNksSfpAL+fmyl++FXTkFMt9YH/XV+YY0okUkpr1t20hlSjGM6gW5ZOaxeEl
         zw3EWYqsRVnNju9YVoG6E9dZskw1CieBfxAPV7OtIX5BXtcNlc9CEKvLhaqR3hQmiuRG
         hxzg==
X-Forwarded-Encrypted: i=1; AL+hErHRA6Z/vrbp3s55V6TmrMyYGa9Y5s3JGLmXATWI+B80ktZ4twvWwiuEDmFkTMzPIi0Js7ZzrQIQ9A==@kvack.org
X-Gm-Message-State: APuU4Z+ERabMpz4ouT4I77Ug1NSnzbnbfEI6zQrc+DqPCGEtUzgkMBOE
	hHowWOqAQdpHY/LgzPyUxC0I+6dxJvs+lE3d5t5dikx5n+1+YGv4DDA8WHJVL1paThU=
X-Gm-Gg: AYBFou03YQgL7HWwbgP2djyvnbVZ9Wm/LxM4TEqDH+VjH7EYxaaSJoywMavhq9U1zH1
	RQ2n9F78e3t0fnPh9ujiG3Gh2j40wilKVL3bbhm9RwgyvayziywHi68cjhl/aALYl+UAbQkKKkh
	7UxBLJRQzFAoanOCHTx2TEaT4MU54HrzBU/uKTJ/DByxc6NBOxMOxTFVat5EJJO08h+VR5hbt/9
	njLeDMj+91IPtUkM68xiqhOV6nCgF/GjpbQwQPm3czl8diH7fPYcJpu9h7ByRqfsLTTE6HKG020
	kOAzJ+Ucjjw4LbfC+WSmPaoIiyVsh33SIAKeWBaHMUc0E4JERW3SxOyVU/i/+Sv8hSNvY0693H7
	4j7xYp0yyQZPaXzQ8Qtkb8vgtWabiQ4S6aJ75Yij4jtpMEb0ONptSvid/NxcrFiOozqefAz4O6Y
	FiQ1n4GLjBNqKR8TGcSYJc6jzbZTu9VT7s9E8h3qeG1uy9/Z7NJCMDYZ4sVXJeAjtR6oV60DRoJ
	9rmJ7JbuxGscdVwRYKHT5rNy3p4RAnisRluX+8wBP5KMMdHHO6B4tiggg8+WTdb9gfLlB3dfccS
	7d8Qvtq8lde76f03agHZP07ZLlxO3fzGJcphbywCbas=
X-Received: by 2002:a05:6000:3cd:b0:492:aff5:da4d with SMTP id ffacd0b85a97d-49b01734c32mr3651482f8f.7.1794470947068;
        Thu, 12 Nov 2026 00:09:07 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498363df7a5sm15550414f8f.37.2026.11.12.00.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 00:09:06 -0800 (PST)
Date: Thu, 12 Nov 2026 09:09:05 +0100
From: Michal Hocko <mhocko@suse.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
Message-ID: <avV0IbvSx4iuv0tF@tiehlicka>
References: <20261112075827.255602-1-hui.zhu@linux.dev>
 <avVx_1BEP7fIzGDK@KASONG-MC4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avVx_1BEP7fIzGDK@KASONG-MC4>
X-Stat-Signature: 53kr6p8fnuj4hofkemrwacj8uof366zt
X-Rspamd-Queue-Id: B03A41C0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794470948-706206
X-HE-Meta: U2FsdGVkX1+fqixRg8E/Ksxp4qJvISZ7mYE8jlkd8VVOr1YhPgsLV4VvY9lDBCLxDRbT/qP6vJxKZekejQ8Re9mnxtX21rO4Q+KEp9ZM779VVAhlBtdiQ7dPOJSclNF1kPqoQylK7L5C6o2O79tLH8gXGzr4/y7NSNljqEhFdROJXDCsmOO6NQ+jNyGZqy/Y+kY1Rohf0s4D2G920V1Fhs0ZE9KB5jrTo/VXsnQ3O4wE5RgsZsILCf0cU6uoYHX+p3qQh9IUIpQoJxeLgcZdl39SkkwjeuLRzeRRR9VgLt0qg7gHL8ihL+rbP1CEG3LGWfTDS8n5JUKKDFaSDVp9e8uiKUZ81obUKKh894od8sYD2S8ZZJDqhcRTZPlJ31hEKjpB9z7GTwsSJPvs53tBLmFSq2Gu+R+2DbPHXDibrfgNwwddJl1OA0MfL9yqvxVpqkXxdEPLAG3Jf1ASlL3QZSSYAkPKOKa/zP3rTXZFug4vxObRKyNZBDBs+/CdfcECv6kc+5HNn1xpLFC4YqHBc/CZSpp2DRzA4tB3ieYYDiJBhsjVtsIEv3kgzDYEDtmhF5pO5Eqch1I+oqGLkn0/s5jXoTy01xbWzD8SkP/XJUOePnHy52WpexFHi9mCj0KwP0CBQhiuD1lsE3b21fS4lSiNsXk0uMi8/uq6gcSksw2xIkxJWWW6HO4zBuLAtJJQ1maGZmS8xaKOfa5SoqWhULlNdHuJZF6fHieNbHcy4NU9fDThqnVAtK46+t1i/wtc6H68D/56EOfPG5rhOkInLSsWG6leTAL7EkfREd5R0qC0I+5/KyxKlVK4UiTN77wGAzN+VWpCRvtSd4Y0ntKfGV67dKNIjITZlOnA8/5dTHQE910QW+jMgd/Zz4PNywXAGyYVV+7+4GTpBxNym9mFsql4X+iI0kfXoyiJIjN+EGdfmSt9ENGRgPF2UQpokz4nDdNalclJhc5QdUmNfnm
 xi1dt3fT
 mc89f/qutzYLoVgr0IakmPCrrJo0TYs/8DmVZdFIzvl2bXXEtbKGpGOpZZGikvCW3uPTWN1zeo7ESSvjFiMFwViGScTfoS2IMCOZxQ/g6n6j0BHv3dq2XyX7ji+DjBsUAG52WQOzhupeh/89DPAMvZjvPk6lKNnNfPbmEiQ/31getJOTnJgViFRVElPUxkOoXPUFmg9JXY5o+vIwTzyP65S6DhLN62Z9uuAhbu6QOsUM6g46W9rDG8HGQccKPQlHundgr446Lylm4OLwFO++wQtg4ZF9clDKipPY7gSOvmDxiRUozx7wziU3uCqMEJILJo/BiPKIBWSOz01vDVy5cvm9OdD7woVfTJpIJzLzJ7yUFxdj/P5Ebv6y181uu5jg0vsvRqV3JU2yUep+synxpdy0Gog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 16:03:54, Kairui Song wrote:
> On Thu, Nov 12, 2026 at 03:58:27PM +0800, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> > 
> > lru_gen_change_state() migrates folios in batches of up to
> > MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> > keeps local interrupts off for up to about a millisecond, and CPUs
> > contending for the same lru_lock spin with interrupts disabled for
> > that long.
> > 
> > The caller already reschedules between batches, but a batch itself
> > only ends after 4096 folios.  Stop it early when a resched is
> > pending; the caller restarts the migration where it left off.  A
> > remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
> > thread_info, so the flag can still be set with interrupts off.
> > 
> > This follows walk_pud_range(), which already pairs need_resched()
> > with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
> > smaller batch for reclaim").
> > 
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
> >  mm/vmscan.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 6a1af9b92349..47f2cb25eb46 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruvec)
> >  			success = lru_gen_add_folio(lruvec, folio, !active);
> >  			VM_WARN_ON_ONCE(!success);
> >  
> > -			if (!--remaining)
> > +			/* stop early to shorten the irq-off section */
> > +			if (!--remaining || need_resched())
> 
> Hi Hui,
> 
> I've been thinking about a different design, what if we just
> delete the `--remaining` check completely, and check
> spin_is_contended on the lruvec and need_resched()?
> 
> In the optimal case we don't need to keep lock/unlock the lruvec
> at all so this is faster. And it still avoids lock contention or
> blocked schedule, and it might be even more responsive as we are
> release the lock earlier on contention.

Wouldn't this result in too much lock bouncing in the end? Would it make
sense to reduce the batch instead?

-- 
Michal Hocko
SUSE Labs

