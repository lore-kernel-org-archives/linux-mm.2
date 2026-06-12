Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42569CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6701C6B00A3; Fri, 12 Jun 2026 00:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA126B00A5; Fri, 12 Jun 2026 00:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1AC6B00A9; Fri, 12 Jun 2026 00:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36DAC6B00A3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:59:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA1F8140387
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:59:56 +0000 (UTC)
X-FDA: 84870058392.28.A1230A7
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8D0840004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:59:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MNqvL1X5;
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781240394;
	b=Aqbwe90kA8pCvmKYu+Lr97s8scH+vUkjWgNnMfGfcoueHSMKbYlf+9IZYOsWre3D6Reb07
	KsR6S3/pEGFG+LZ1AUtUo1NdJC0EBLGm81LsSh5xP8VN+wIIQi4CmiTznMk2ux+3F0iARV
	EUGYkvaZ6q5wpZ3OGYKZ4DcqQRe2gsQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MNqvL1X5;
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781240394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4czMFC+KmsZLRBQDjccqZEzLVp9EeMpLK/OkFJOtYOo=;
	b=mGSR7asq2z7nJdU9hAJ8u2dnL9rjTCT/IHdp+H+aC/bdXwFtW+8MLM7VWH3bhMqC1lAmDf
	XMPiUmM9AP6yx2+1dCZoedz/X0UrHK3z/ROdg2q1f6jkniPW/PmgMoQtOhysW9HOV9oSoi
	qMRm7j7GPqbLgzH1kt279QgSFigAbVw=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-69e9b037d82so460386eaf.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:59:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781240394; cv=none;
        d=google.com; s=arc-20240605;
        b=OYv13arG/Y1rxydjtTDCb320LHuH6NCaQ+BajOM6LYmldsTRc6s3wlKFufEyphYSy7
         4fNWtYCnOa0P3PDcK4OkjZJCBypQuhEXwJ7HXAh8xgQclVUGt4ornBkia4PrgkrzjbGr
         L1NF2p1zcVLAFBKvQTOWjK4i1D5wKtxn/Tj2HemzcKZCLz5fHrzOTz4ehWIPwG8bZrCL
         Tq7LurrqFQTzsVCqEu3fAgtACWy4pi+2+NcQuQLZ6V5/MiD5uWpQejYsKDZipqVAdnTV
         8VeCGBeUNEJSM2byo1ggLvXFuLtFivqZHOK1JEg2TxKDyHydNVLlXOqLWspGEP0TbDKq
         86sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4czMFC+KmsZLRBQDjccqZEzLVp9EeMpLK/OkFJOtYOo=;
        fh=KJx/0ASs1TE20ltxvEW6nmQe+VmI7tRNrcADeZtyflE=;
        b=LVapPjR5JK6bZnJMvy8nhpFcjKxiom28qeCx5spNQjo/6WkWovjzjixUxSkqBC6iUF
         0hUvaRQJsH85WzS7lM6pibfdczXM6ZV+xAgPdtluAHHcK0RR4cBXRE81UU8f3fgV000Z
         erWmB9A/MWKY5eA6mIkIWjHqf0HV39a9LcLzTVSjtVvZw0HsCMne91hGfPGmt/tC1oZH
         7f5laf/37SfNBcWWCl4r8lbe4dTcY98yU8eE9YOb4BoDELIWgTlMSMoLW3gN07LozqVm
         R7MmL8uaiMX0NjpLnkXpY8eHy80WDlfFfb5WDK6ibl7hMscUACUlW4Zfi3bySOvRM7ex
         LbiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781240394; x=1781845194; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4czMFC+KmsZLRBQDjccqZEzLVp9EeMpLK/OkFJOtYOo=;
        b=MNqvL1X5/7sGF6y73K9WXPEyLIK+CQEeqYgTb3s/RybCRBV5kEK+Jjqy6fVeVOLCcb
         9w4aSf9bvepdSYHtuiIATr8NvhSk4JMzPYd4TfmN/SJWHAKxJ4q5oog5KbYbHU8t10Pc
         09nevw0irHKtBOUaHBr5aKV3M5T45vCnXlW32RRQiDi3sjGDJNqCASqBYUP9nVgrKN2M
         +O9wYn6Je8lv/P1+nNQQFpfdhoOgre6Kz77JK72f4tknZlcPWP1u4Qw6UkOxMGewfyCs
         ax3F1f2bJXYxDUx1DZtAF38m19YdPMQrvEZTCxUFKpgIsod184L8Jc0BFvBhfgQ6gPdi
         EFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781240394; x=1781845194;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4czMFC+KmsZLRBQDjccqZEzLVp9EeMpLK/OkFJOtYOo=;
        b=ssdrUCmdDXA45Pm7q6IFbf1UHLkvrpQoJpdOnrZ8Enbvw5xjGyuIe/UT3/HMZ/DwFZ
         uAYoJ8Wg+pe4LTtq6pU4ZRBIVcrL3CaG8Vj6yMSPlp5mhGOpTkusWXSKc0NgpqSXgvyk
         KuTDWhix4ZrcAMgxMvjIlyVuM6A/EzajCYRBYT75LKIrmEZzP4Z8Yo4Q7lvoKW+SxweJ
         iibvgvsdVZGmcm8eyAGgho6omUCkdDTNuivKYHXRdDzVpUFyhfcXiJsfZzjyk61I5aDT
         vrdegexdukYSXpNh3A2OvNLCo+eCKgh3dEU8vjdRQ/t8bHjkTpKCF5tfqU6pm1Y/xajY
         lAEQ==
X-Forwarded-Encrypted: i=1; AFNElJ84eO189COtY+bv4nW/tt8RPS/Srf+kokR3epUnvRdsCY/D3Rh6dT88tcD21v3WzkJGwrdJtqBHDg==@kvack.org
X-Gm-Message-State: AOJu0YwYPJ56OJF5dOu1FLK7feEMwoeB4ZZTx5It0vdS2D/CKOW174Vj
	qNHoRiAZ6JuKEdPbDMsEbF4hjrRfRnJIYCi0ImSjo+NUzs3ZZV9aIqH+dNLm0Z47TdRowKmpZ/e
	DB/N9mdZGB4jzm5de/xHezLRBT6l3ADM=
X-Gm-Gg: Acq92OHP8gsgilpLBeO/doPntkb1EZAF4e/UtPcoIqIRnOAR70wgiAm3Af2qrEjdnv+
	BUUg0tanHLD6qyRkyML9q2QFBQ+j/ILSVDjS779Q4IL2PD0yv9AWk32jJwbbozZoSSBFI3TpLW9
	EOayBRjNgD3pX3H2UwVQR6GEhxyX5miZxsmP87DvZ9zmVa555X7fSa8F6mupVPlwq+ZEglObmg3
	P7/r1DUtE4F2bADUJm7bzD5iI3BZBf4kP/L6NbZtVCwyOKB9UAh9QxK3No4XYLqy1Aczhu/KiD3
	YtNDOA0zwjPmKYtVkQ8P89tVuiR35GePlqFgRQ==
X-Received: by 2002:a05:6820:2108:b0:69e:43a2:347 with SMTP id
 006d021491bc7-69edc6331e9mr891312eaf.14.1781240393660; Thu, 11 Jun 2026
 21:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260612043828.23558-1-devnexen@gmail.com> <aiuQf99mqhQRVzC8@casper.infradead.org>
In-Reply-To: <aiuQf99mqhQRVzC8@casper.infradead.org>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 12 Jun 2026 05:59:42 +0100
X-Gm-Features: AVVi8CcXbu0uZixFdSf-jZf1lbJ83iP6mwgePuLO0_cMi8XK2r8kHcoHRdAJH9Q
Message-ID: <CA+XhMqzfNxpMq3APz_LH_ta9pHKHs2Bj6p3VWBMeLnn22w15FQ@mail.gmail.com>
Subject: Re: [PATCH] mm: pgtable: protect lockless kernel page table walks
 with RCU
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8D0840004
X-Rspam-User: 
X-Stat-Signature: dzuudm356cppg55no1db6qxkzz73azic
X-HE-Tag: 1781240394-579052
X-HE-Meta: U2FsdGVkX1/jKnyZpoq+OHtJ5wgFzW1DjWGqVoG7Ms3ozocyh53/w1Fj9Y5YECTZjBZsS99z0cqxckUdkxHiSq+pqcUcydLnXf7jHNpG+VlAtj3uRo5grTIe89mGjqiskBxU4PNOk9TBz7nnmYib/pl9tDJyoR1HzcHKSzSEvbheJ+vORLiu0NyyjPpL/1iQuA0uQOEqWRqCi9+27iWxVZFJMfzsEviLoKNktwPTphnlBSz7t2rWWLqPQNBmhk+/t3+YVkZsFAwMEBQjbTRWYtRM3m0l/TTVT5BPT7KY1zerJro/04FVAY2Wp53EhlufPSJXZwbybRZ7eNuo1XSKhZaUHHYi0LJ7mmSEiYIiWsYUPROMkSM1dt/eeSgoorm78Lc7nhigd0RfcRX/22nxU7GAp7MR6he6emO00QVRDGSsTTlS8YYTgi7SxEmuEldPAuJNbKDsW/8REUFuR2MCfaY803Rwybth/YZ0SZ3llh4MJYuQdML3+2XqEoRgU+yw2GQ5/mHjeS8ebswiGc/NT8+Cj/GhagMcSg47nmd0E3lSZhGZYRYvVJBrQdv4nfIwma3U0JNGtv0Zo5WZAfqsyd018ypSgBzDxveaNG88ceNLWs3Dy5zfLGsdWW4h3DZmfvS4+wAtkeGVcQIaAnqgo+l6Ab8dCHn42USexRAoLrwcK4IxuMOB3bsN2JjsvGFd6B+JalpsKZ2BToHzPzKqvvb6628B1L4PMdPqN7Ots9Yh/USlNC85jqqfIVTPmn98c2dNbzDnTHEH0yD+DhKJ62Elut1BMn3+RCIM1qQ9azP0wDUhQiXXNKBv/OLgUAmaGYhNlW8bc9Dx0GRS9Hw7qwQDALvWHQESFSIjvm3/hLo3sH2EGycNodthfZImQBGL5z5X238M5Zv4han71ruU63RVSPHBc+cnBQ5brYRkde0WQPuGAEUC/0D37ILF1n3JvVv1a9i3KBS1elfgYl7
 Z6Abvt1K
 9+bJvLp2d2+niViAyYV/3roU7w6DR7fnurQWO1aSZPRvNR+DC5IyWtimCUhNtOUOPld9rvCJYxDF87bRR0n+5Nbl8h4GZ4hdRgHNQqSMgyw26fLLI6KRD6sbAJw9Z+vQbY29vxlBanCJFqM00iIOTciUPwydUHW7j0cWVwd50FhvJZbHUFsLDhEpiThyaN3TJC4Nd83UzLGEL6PpejuGAsvgY0xkf9f59xOb2S6O8T+6MOrvKxZ/DVPP7RWZxHhpAiS833zoCaJXfbwTBQspq+3Mvn31scel7XzHzOt53ZB4/GmkUd/dPBzAEL0L6hCGyc6Lgkp8DpX6XqoPAF+PPz95baEDckbvw6VmDJdrzmTermkXybfPZBsauGz2x6S6mFT5jrt6FgTo3CNMgOInjEiHFyMnXkWmwi5LXRkvYikQK49mPfUHcVGU8u+v+Ivwk0qz4ZGNiTXo7KAHVcfsNz9tnL+hhrRQixOsuB6m42eAwtMLbjsxaQQvl1GAn+Yx9fzPVUyvjun0PyfNv4ysFidtUzUVbQEcoTB0bRaWvVXYc5qdR8fFflUz9ioiu3YfInaiIxoi0Kd/LYfxBCE9Q+WBvHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sure thing. Thanks !

On Fri, 12 Jun 2026 at 05:52, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jun 12, 2026 at 05:38:27AM +0100, David Carlier wrote:
> > @@ -434,6 +434,14 @@ static void kernel_pgtable_work_func(struct work_struct *work)
> >       spin_unlock(&kernel_pgtable_work.lock);
> >
> >       iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
> > +
> > +     /*
> > +      * Lockless kernel page table walkers (ptdump, and any other user of
> > +      * walk_kernel_page_table_range_lockless()) dereference these pages
> > +      * under rcu_read_lock(). Wait for a grace period so no walker can
> > +      * still be reading a page we are about to free.
> > +      */
> > +     synchronize_rcu();
> >       list_for_each_entry_safe(pt, next, &page_list, pt_list)
> >               __pagetable_free(pt);
>
> synchronize_rcu() is rather expensive.  Can't you rcu-free the page
> tables instead?  There's an rcu head in struct page.

