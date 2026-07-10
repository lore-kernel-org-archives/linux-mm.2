Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14108C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6EA6B0093; Fri, 10 Jul 2026 12:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E583B6B0095; Fri, 10 Jul 2026 12:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1ED66B0096; Fri, 10 Jul 2026 12:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC71F6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:31:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35E4F1C3C79
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:31:42 +0000 (UTC)
X-FDA: 84973408044.23.A574E24
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5028D120006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:31:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=PLEVtV+i;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.49 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihr9TBqVvOWsgDH+NpkUYsK2K2fCkLkiaNuX2IHUYwY=;
	b=ew39mrOYb1Nyxm8Jm63/1tSOYiQFPdlvX5Av/WyNZzVGEjrDCTGMhS/qIia7FtGSzjSUx3
	k0wA5jCACS970R+sIamAfGQzevgtOQ+V9sYSbtFkv/eh4d1qw5TizG2h9i+d4H2Sphh3Om
	+cxgiDIbm5oyDyPknQEAg5lvFAUDx7I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=PLEVtV+i;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.49 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701100;
	b=e/Ntnu0SeH3jtLMIpwNsGEFkrVMaBUwCs9HX+o8gG0bUZkWy4JxoZGOmuJdXy62Gb/M6Ni
	S+gYZF+3XyCDS2LJsqsPo0Osq6cXFYgsXGaewWdwZl5nngPhGosd86Zu8fHwEpFWV23XSr
	BiV59kZBGkofnVf33ra9uhSdD4qqzak=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ff88549786so10886886d6.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701099; x=1784305899; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ihr9TBqVvOWsgDH+NpkUYsK2K2fCkLkiaNuX2IHUYwY=;
        b=PLEVtV+iuCvzs6agM2kefH32SAb4rgVjVPfcYWHt53rdA0rEsP45Dwc1SxVw0q1+Pj
         T18UkBrq8MuzMQjE1uAJFKsVj9cucUyyIMXzc/tG6DsOMjfl939/gFdHW2+pL0yShHo4
         3L2fnZBbDF+WCL5gmIBRQNpJcHQCMkN/J0dDZ9t4HaPmPnxJfjUE46dgnGPUSorg9yky
         SvS85Xag2Zx+NTI2KHG4hkz47GjQKB71YMYMQAROhfUmgz3JoVW23XwF6iBqPeDhXXXc
         3resqI9NAqiQ8DJ+00L7kMq/l2yWdmM1hK3fuKBcowuam4PWYeM0mVED/sshyHXMqC6A
         jD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701099; x=1784305899;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ihr9TBqVvOWsgDH+NpkUYsK2K2fCkLkiaNuX2IHUYwY=;
        b=NOACA0+3/BesvNUl9KR//jyFe6fT0mCuRSArOS+UCfjwCGJBD8696WsQdJ+umX/Tjy
         iY7HmpaSVQudsmDotlTbgz2EBejsiaSJ0247bNsF0eQqU8FlvkicLfMeQniHInIo/ViC
         AbLMJnR7ftpmLU/YqomqaXGdzmBdjT6i2qMADXyepHR68lD5BLP7NJXZQ9mIihdxb8Ca
         FXtu4UKZkX48b1zpyKLyQs8FE9xmI8jPOrwHpZDOMe/s0hyqGYDBG+HkmiXuRQChclJ+
         JkKQfX8Q40sQgPtl6lrrsqXiH21GoAKcrPlR0JHdz8hmqbxY6XBTk7mHkocOGrGvqJSN
         lE5w==
X-Forwarded-Encrypted: i=1; AHgh+RqRNyu+i+N671bgfushWIgfGS7VfWUNbo/JrXkyzYizARwpGZDm19RcN7TxIt/HIljn7/x3J4wf+A==@kvack.org
X-Gm-Message-State: AOJu0YxhIev5ClGG73nwCKZ2lxu2ArAk+2p9vb3aX9h+WzXxkRAnBvOu
	dqhkOamCeimb2+aZD7LuLwtMrAxJqeCUc6uj0/MoTFpqC0NFfRlBgHEhVhyhUkCcWqI=
X-Gm-Gg: AfdE7ckrsKXCWFiMHBPi8xK01gaxMMqIbk8wWKKI3FgS1XZmu+HxCvttrGQ0YjRm0QH
	QnMK/3GrikgWrszMeYvi7iRZYn6WuABrD9FitAsTM1zMosQNleb1zqAHFFg4pDwShiyJHRLX7TG
	jMuzjHWSz/OIcZrH3Mqto3kPM6+JnZ/sB1CHTmeeKQ7Fw6+2PDL6yjNbXZ2+Fz368UX1FHP/7j1
	C4HFpuz/dsX7htgVTmrbiL/6s6PqJQuEzAuobdmU9MI9DiWtyMJKhKWYldXGmIMKx/htq2i9Nop
	c+r1bHEbqGAKGTWnOYu+dDzYIowi4imNjZsuxm805pc/W9eEzd54ILCD+H0dTAoEQb+Uq7rDJwS
	YpcAFOggSFGqWiD8k2nfu26QAptJOZuVypBojGM/qfw7FUghGbMnkP7xiRIyrVaebjRhTACM=
X-Received: by 2002:a05:6214:4710:b0:903:12c9:cba6 with SMTP id 6a1803df08f44-90312c9dcb8mr32500716d6.47.1783701099176;
        Fri, 10 Jul 2026 09:31:39 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56c4cd1sm44753226d6.16.2026.07.10.09.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:31:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiE8X-00000007Xks-3Vyo;
	Fri, 10 Jul 2026 13:31:37 -0300
Date: Fri, 10 Jul 2026 13:31:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 1/8] mm/hmm: move page fault handling out of walk
 callbacks
Message-ID: <20260710163137.GQ118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345361483.660027.16455119612963295072.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345361483.660027.16455119612963295072.stgit@skinsburskii>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5028D120006
X-Stat-Signature: dk6d4nnhtgqhe7cm51fpgh7i5kwo8y19
X-Rspam-User: 
X-HE-Tag: 1783701100-517167
X-HE-Meta: U2FsdGVkX1+nGpWyTlNx0l1uHQbvqt7kFPpkLkQfjgax56t2K5womnrv+DAahQbZ9BIWNYUa4SsbEZj/l6sBD903EG5ZMgOiUFpLHJ1O9buv7rEDEL6o54DGq88xEL31GLMNpkh2tuWggUMfsHi6ZjfTybAC2oEWtKTzKfwNPrnoXsjnNLQCv83DAqrSMYEE6t4h4z6fFOIsqOQj5PAErV3KI7qptJqV13CbkolQlZG7FHnBXmnfxLouJSaZE1bTjItQqUZkhkL7DqxDAOdnT4mowWg1U19KQUObfLFVfEER4adQClw2Xyw5oiD9ae+mJRwwAju0mqk5zWiw11L5ZMC2qdOEuT04tlnzHy15kt2hEtNRmBh57sktFHl/ijExgF0wLgGFjD41AyMPtGP5CHl36ugFVte4CqWMHT2pKzZqlv4GC+Cu3hQ1HGw9jLI1Kfg5N5V/k62UdviToqq/n1kOrGArVR/mHsu8ErkH5W3ZOvaDOqYmm/g2LXmbEAgEoCa9OxurIhe3T9LzwfYbsuBSnTWoyh822FYGvX3AWZbC3gCBvAX+nioMKb9FPWVPt6Q1Q68tanncWJt5F6LsEzXfHQ0ZJUt1IZzjmFYdGWML1GKcwwVCSBkbP5+eD+s9vtHdg0UakT58lVGMAnx9ANfQo9QFBRxpqpOkvf1QqWFbvTRonYi2sN8obiKXGGD58xg9YYsgxe3AoksZKB/wQVSoCONjesLVZQFFvmhHjUPN+NwcIyRkezytyIwVAY/mCfw7EJoNszchICJ21ExoSRXnJuvrVut/WfSgtXW2XmgMBuc1FTvgqKORc44Kh8TEQEOOPq/zkJuIQlD24x5EkC2VAZwX3BvvJgRzlFCJJs10iYe1C1wRGHxwq8yV8vjl/1Zwc+53pjmDWOZ1rm3D3IctRvRJ6K6Uagv9aC/ntMYUQjQU81IN0WG25zDum8DqaHdnVtdoqf1z2728sjl
 0kBcR7IM
 oE/u0V4ApkG9JschzmXTMxLk+Q8MtdaweOUZty6671Q4noudeHviW5/VM+jhe36ouheAisF/5VEPAhKzoY9ap8/QBQubxmSLFZpWVuKnHVfbF7aPDhlRkATQCO3L00tytZn11Z3CgIFubE5PVP2Gxwr7sK9dT3dge6tsy3kEBxGnVhWQ3rC/BoVomDDsLT/Ek6mvOus87Ipd/PUsOoSBP9kVev4/47PmEtOe3Op9R91axfCbMHiJ18CqXNcyqFmL9vQggdw6aAwOsT1Xxen5IZS5HKDnIoMqIIqyJdbrHE6bQgg2Gqijz3WbzTNdrE383pqMZkGwxNwCLjQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:46:54PM -0700, Stanislav Kinsburskii wrote:
> hmm_range_fault() currently triggers page faults from inside the page-table
> walk callbacks: hmm_vma_walk_pmd(), hmm_vma_walk_pud(),
> hmm_vma_walk_hugetlb_entry() and the pte-level helper all call
> hmm_vma_fault(), which in turn calls handle_mm_fault() while the walker
> still holds nested locks.  The pte spinlock is dropped explicitly by each
> caller, and the hugetlb path manually drops and retakes
> hugetlb_vma_lock_read around the fault to dodge a deadlock against the walk
> framework's unconditional unlock.
> 
> This layering does not extend cleanly to fault handlers that may release
> mmap_lock (VM_FAULT_RETRY, VM_FAULT_COMPLETED). If the lock is dropped
> while walk_page_range() is mid-traversal, the VMA can be freed before the
> walk framework's matching hugetlb_vma_unlock_read(), turning that unlock
> into a use-after-free.
> 
> Split the responsibilities the way get_user_pages() does. Walk callbacks
> become inspect-only: when they detect a range that needs to be faulted in,
> they record it in struct hmm_vma_walk and return a private sentinel
> (HMM_FAULT_PENDING). The outer loop in hmm_range_fault() then drops out of
> walk_page_range(), invokes a new helper hmm_do_fault() that calls
> handle_mm_fault() with only mmap_lock held, and restarts the walk so the
> now-present entries are collected into hmm_pfns.
> 
> No functional change for existing callers. As a side effect the hugetlb
> callback no longer needs the hugetlb_vma_{un}lock_read dance, and every
> fault-path exit from the callbacks now releases the pte spinlock on a
> single, common path. This refactor is also a precursor for adding an
> unlockable variant of hmm_range_fault() in a follow-up patch.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  mm/hmm.c |  118 +++++++++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 75 insertions(+), 43 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

