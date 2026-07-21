Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260E8C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9231E6B008A; Tue, 21 Jul 2026 14:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAE76B0092; Tue, 21 Jul 2026 14:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB536B0093; Tue, 21 Jul 2026 14:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0376B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:16:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72D22C025F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:16:30 +0000 (UTC)
X-FDA: 85013588940.10.EFC613F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9497AC000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:16:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pb6u8avZ;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tK6CpaworNApxpcs4ZRJbHY7w08bgOkmP8ipHWd1tq8=;
	b=XYU6gyCw1hqfUvDWgPQllKTd6MKbxCfSITA1ACPAWcmzPbq/10vgl+9YqXKhVZUxSIuHM6
	s0tdFqE8Ty1HGeH/VC1ekIK97962aG2/DhH6XMtq9j3zoQaXFQdaXuFEBN5ZUGoEe5sJsl
	NNbBT5PMIg+bofKxS4ZrsiTOY1It6Qo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pb6u8avZ;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657788;
	b=pZYELkruMoTycrl0j2YjcwU3oy1cyP6XJfzbyBNG9wuGGzHXCdURPLqd0s3VouQ72Vi+AM
	YQUwFowbTxELBoDyiAXUbPOm+y5owWKKLtyGrDc/gaQ+a2TtAanmzFEKZZk/MGXqL9qm58
	gcv0C/oG9D1UTcrOc2mIL5VshCDDTKE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-526f963372aso7668411cf.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784657788; x=1785262588; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tK6CpaworNApxpcs4ZRJbHY7w08bgOkmP8ipHWd1tq8=;
        b=Pb6u8avZaZumMG0lP7+waOXU0LI6O7ZRXB8nHcRdVqL/3Le2FItO00kSc4WSD2bk0o
         ue05l2PXkHJOwIHLFoSgYQGJCvYQmbpgCoQaPqPrian7fIyerjCmCDL0d6kBeICIywBg
         qpXwFBHC6C2z94/pPfmaQkPH1u2Eik6mY3MOkgF2F0i1oA0ZUOReC5N2BiVvfjEjdEzK
         kA8BLqpMLM7l40nG0KXyY93xGIsR23ne+dM1mwsPLj9hFviVyiWhFwpK3GU/iO4QeMeE
         9MfZZ6RvoA/BbEk0PEbudKzhqbAJTCE3AhaIS1pw9h8x/o0c8eZbfG/gStn6T+Fpzr8N
         NIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657788; x=1785262588;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tK6CpaworNApxpcs4ZRJbHY7w08bgOkmP8ipHWd1tq8=;
        b=i6Wx0FX+BxnUqCobNKez6MreNMTn0Ine+PrvPFuzw6QDLVvzVEDEek2mlTPjWtVfID
         Gw+HeZUII7jKvJV4ECGIygLZuSsG69ofEnwqXrLh7DVVJZc8EXOnxIzySDtnUi/Xz860
         SUNXDOtu6PvAs80r0THtMtPRq0frz54B7nXhaMRC5fQjIVukLQ35ueVJmzqAuouf1Oqg
         C7y20qB42wFT2cMBduEKJc2lGdSYnjN9jk9mNvh4omJW/aktKd1cFfeFS8hlrAi2HDUI
         j8iQVendF+LAAOar1rHTeD4nQoosh6WdEBP/v3UBU3CdGDHcoGmGJt+e0HcPU5OkpBbw
         zzLw==
X-Gm-Message-State: AOJu0YwLKNSlSyFKnA9hNHZqY+RXpji9AvOXuj/VcP4KjuLnI0PdMzlj
	kwCvWEpK1PFyMNYuUr7mU7YbUaYU1IVTy82slJ85U5WwDgy+4JpS/JG0h7R58CYbYn8=
X-Gm-Gg: AfdE7clZyrjXuHUQVMIIxXnsVKoZyC0nrVhB5ueSB8f9r1BZ1q6iG01v+9HcNezdVyF
	88pLLrGtqVGd0ROrXvHYP8PxfUF7Ax07fDTSPNloP6oxp0VLErsf1VmdqJdfVolusKxMhpv23Wb
	osM+bxaWSkVEvDYVboItFFXya3bEi2LyyhfiGsNVUR9BDz1K8tUETY8p7ZLowISaz/ItueAdcJd
	zS+/AXie3ozR7SjnbIEe2Pk5SRFV/vf++PqSwgi/+nLycYaKp0eklaGK9Wr+2w9SL51Yf13n6yM
	UPnQIuUHeeXh/pmhhvxDzdJsPxsucsO63n1Xjrzjsuq6nQDjFMbKfVS0IV6G2gIyKn46m9v6Jq+
	xUjbY/3tshSu+r08dWWmDzri8/YMmtKpjFVF/RFtGutHaZ7p7WUJWPSbOe0npKaf7eTHLlIs9fX
	eaQs2sZ5PDEfjeubdoLoGCn3HoJ7aijDL6EmqHh4TaVOQ9SpUTSHOd1Y4dQQEU4j9eWUn7
X-Received: by 2002:ac8:5845:0:b0:51c:7b12:600a with SMTP id d75a77b69052e-5213e881e44mr171868611cf.86.1784657787636;
        Tue, 21 Jul 2026 11:16:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d066fa6asm463921cf.6.2026.07.21.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:16:27 -0700 (PDT)
Date: Tue, 21 Jul 2026 14:16:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <al-2D_7NcwMxqmsM@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <6a7aaac3-e70d-4063-9c84-e643db1488e0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7aaac3-e70d-4063-9c84-e643db1488e0@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9497AC000E
X-Stat-Signature: 8rbp9pjxco5jftrjr4qdktiaerb3u8py
X-HE-Tag: 1784657788-221200
X-HE-Meta: U2FsdGVkX1+8PK5k39VIz3UJnegShcvq6VbKGyrutLUEzkYHdel/1YLNfiH6r5IGh3WbcK+q6kn/+2N7T8qXtb3aRbbD4VzJAv8n2SV+l143K/0VsyNwM9dE6ioVoWvVSOq9XOL7yYTwIsvnOXhJea/9ihGwMV/5nslFHe9ZZz8+S/qUfys2N2a707U3KMYZrCn7FRwCb2ZHt2CyJy9MRlty03C+ogKZSC6CIENRXilaby4R0uVr3IzhwX7gVekSL8k8azl2FEPVebj7ErYCbEFN7qNwfZm+DiKIpqHL/RfzzNpDye6vxpSz6E857dZ8BIVqtIcnGdkMnPWKyosyyzxCScDsKb3D/4X+u7+1fRoCQc8rMDeM8YeFiTjbHmJnyN2dlWUYTbPyxknw5Aq+vzYh1RX/+iU0Vj2gsuJ22uF+EJmMc1KuBv8Hpk7JTw3cCWuRDu39dKhcblSsdakqIWDK+kpQRKEGvnRWVIoWcTIYYJdIfXiPL/dhmZfwnYb/ZgA6ntOc2vGgvZ+dXMJxxFdFouOGPxYhgqvdT0KuCEdp1zSP7OdhDvVfOv5EtlrdyHZXUShc9bqGUWxxr15WbYUcm4OiSSG2axfeQ2whSjiK2wKVeOK8X1m7MJ+fPU3jNDxbXFsYxnwk2toLHlv6N/U75/UWxp6rwuyGEi+CtuRoB80o4jwgJFIQ7L1i1ORjVJlywky5IoPtqdj27Y30CFtRkNiOxXLNmwkPLrOdam4fGCgnX2loeKKg8RFxx4kyjzfOTVWBiLd06XSDRrCssjN3wzm3VsMQlmosSKDsX6WOaBLV0a/0CQMiH3PRDM4cORp044q6Rzt5oKnx4Ggo33Z5WnUfJlhi8h+fFBlnQNQ3LIIvx7FF5LIXZ90aou5VQr49tq7VIwGliW0Flc+LQZiqxuns9pjUC7TAHsdN2Fp0dhBkKORh00KLZ7hBC3uI6xrZNndKUl+adF1Ywr+
 1IbMnFyL
 GXgErrUe+RhkniKMqxrxZAzxXxg23S4yW9YiDmUEIuDnoTg4kce5y5Yd7IDSu2yftans2wHxeTsHQKkOU0v37dXtV0l6NtyCle8DyVmgZIdr5WplYPZNpZCkPD/kokfVj4YkHz4mgRRbq5e1VNec6es9XqLzPdN5T1bB8HKhrQfRy2d2gtv6fHCBhf2pZcPhMWw7KJmgBibyQf517sF8e3VCwdPH4Xmj/PoF3mFp2bjg0q09gRueITIwwChviOVMiSI1ODUzOxJTNZpT77E0GTbbsSKZELD7fJjzqhWmiKtL2NU88jXXDT9RjMdkhQaQTzWDaWvKQUe1I0snusom+Cyol6wMZrTSWK18YLgXVdgbfYoT92fl5ZnJkYYw/IT/q5zCrQqy9zwv4NmPBkJJ9Hrd4VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:46:01PM +1000, Balbir Singh wrote:
> On 7/21/26 5:33 AM, Gregory Price wrote:
> > 
> > Patch Layout
> > ============
> > The series is broken into two sections:
> > 
> > 1) N_MEMORY_PRIVATE Introduction.
> >    Introduce the node state.
> >    Opt those nodes out of mm/ services.
> > 
> > 2) NODE_PRIVATE_CAP_* features
> >    A set of mm/ service opt-in flags that augment private
> >    nodes to make them more useful (i.e. reclaim = overcommit).
> > 
> >    NODE_PRIVATE_CAP_LTPIN for private node folio pinning
> >    NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
> >    NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
> >    NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
> >    NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
> >    NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
> > 
> 
> Looks reasonable, I wonder why USER_NUMA/HOTUNPUG is an opt-in?
> 

Ideologically: Private nodes default to fully isolated, why should any
given feature be special?

Concretely: 

User-numa

   Some devices don't want the user to have control over placement.
   I have been working on compressed memory, for example, which only
   ever wants to be used as a reclaim-demotion target.
   
   (The reasoning for this is another thread, i plan on publishing
    my research on this this year)

Hot-unplug:

   Some devices can't necessarily handle unexpected migration, and
   hot-unplug is fundamentally a migration.  So the HOTUNPLUG cap
   actually means "hot-unplug can execute migrations".

   If the entire device has pre-drained the memory (all memory is free)
   then unplug works - it's just not very hot (no migrations) :]

   Maybe a naming issue?

~Gregory


