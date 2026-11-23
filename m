Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A6E606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EthyMZQv
Received: by kanga.kvack.org (Postfix)
	id 534FC6B05B4; Mon, 23 Nov 2026 11:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5486B05B5; Mon, 23 Nov 2026 11:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB756B05B6; Mon, 23 Nov 2026 11:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1633D6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:20:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94FD91A093D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:10 +0000 (UTC)
X-FDA: 85466895780.16.8C2B0FF
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 909C7160005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EthyMZQv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795450808;
	b=PtqRZmX9+8UFaMuIEK7MMLQHHP2qjvodYKRUCKT3hBALRcVQwEPA9alZDP+h7f4laSnomm
	kjL+9Exq40iGYcnA1BDMjVjgDHrQPaaFGk+OkB0l/nmx/obBv3DwzglW2JYsXo5iWX4Gdv
	ZZxz8nJcp5meXe0mAKwRLLX5Oo44qvo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795450808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mldqwpxZeD1p8uw821ZK1a2yAWOs86dOj1gRQG3CmFQ=;
	b=vlqm44FQfGuQRHmf/zMOCotUlHCU7T/mZUIuj1mEphjzCeuHFNYzKDXazK9UfFSrLUJ/VT
	JfUUsGeIypiIRT6Pe1xuINHaE9qDLRli9uBpzeM+yD7nPnnxr6EX2Y2aae45OYHgBhM5ZS
	Bobk1CoSs2SJmyYR8RC9pX4zCsVug7A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EthyMZQv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-55be673e029so440121cf.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795450808; cv=none;
        d=google.com; s=arc-20260327;
        b=jC1/ybOKnE95YzCXrvRJeNGrjHje5d0KxYCd5CNmdqh+IlNNJdYhx524qA9t96E5yY
         kDoxJ4uTO9N1e9Fjrg7/IsVFY4iRhcDXNjlSxKHL/hBMx5st2TAZxXjZvIzlIG7Q8Y+p
         y4ZYzoHhqFmgTp3f9aYDmJiWXXxGjVlpA+k0htQZN+2+2tvf/Tj6+oJHe8YhYjKhC8KQ
         PDflSRU2Hvd+cVt4jqUBGi8mKVvrvlpsvBILWOOLGhTS/34my8A4XnmhKfCmTpncmP2u
         m0hg/7iJB3UjNz9cPEDm8Hx2XbnP0rz6AVuu74/UqaSyPlUXgaa3zLOmlrw6FaZ7KO8I
         f5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mldqwpxZeD1p8uw821ZK1a2yAWOs86dOj1gRQG3CmFQ=;
        fh=8hrcPbPa0EO92XITU/trZ4iVRf38xCp44utA6ofDRcM=;
        b=RxSzI1apYuMAG/HcRmbmfftgiaiaRxBj0Pxia1UriteVUyOTQwisQvWNoTmxzYQNNl
         UZQVI8BVWYtPkHShIzoDO+Us98M89NfzHkOqouao55Ht89qAPOKkWkPa8lQ9N+iBY320
         nBAsAg27a4TWcGmqTuqKgp+gCWxKOv1Nwhr2azXLTqPX5Q79OR510w6wFgqYeU3Nv0Ta
         dint28TH52oKYSEOReJVd0khwfoQ/6/GNZTslCTYFig8Q915BtSpotk7caWfcXlp8TYw
         6fQMxch2RL+/YYRvFgcf7NcQBLE8i/j8mmL/OwomwtZgtYto1powY2LVsrDXOMMmbq+y
         rd1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795450808; x=1796055608; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mldqwpxZeD1p8uw821ZK1a2yAWOs86dOj1gRQG3CmFQ=;
        b=EthyMZQv3GniSJv0BwTtf8UFlGSC0F+i5+6/jcesxGbAmVoVZ4NhWmSSU+3Fv/U1q3
         13e9+y5EiRohUrZ2vK8KXikFH2+DjfEdOn6gIf6uHOrpT507MGUxyBQ0YZrby6EVjZ0+
         q/DEc1I50J76A+nccEp6ey9NO9b7pClDEbeg/TFRbBcG2+Zt1tTPpPpMfw3d66AWLPiS
         jexG3HWI9NlhENDh1wTDvdOw+36roBc9aWxOnq7/HbztberAqmMYoRhDDz5LJLS/vWnt
         Q+D90kVm1LmJlEs2hNqe2kRCOAMniQbUvhDeu6OGGRS4oZy9Uw892psF+RxeyWOTdd/O
         hDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795450808; x=1796055608;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mldqwpxZeD1p8uw821ZK1a2yAWOs86dOj1gRQG3CmFQ=;
        b=1vbKqdLypoHBlRaV4Xo5VsJ5iXL+8W1ulSTuDQoRJ38j+hVY6xGNPpjdzxA3ebTNeZ
         ecFMsrIkoK1O4bIpsu5O2DCFGWrrBsI4Viy++0UaDLj2OPadMQX9uxh7zLiANI+bf5Im
         GySV6YHB/yC6FG5pKtZDyVbdrtE79Rq/kf9fUbusCsueNNw5UbqeyngNM5LdoUIE4v7x
         2FcPpm+OUdaI30XJP0B4sumlLadg8oz0efpZHvaXddrVvqZAMhPTH/kpjtSsMXHvha32
         Xi4tULFi/DEAEdMX0pPpYE7fIVD3m3PmjNfThRl+6ckYYVGQrABtSIbGGInGvMHZxKGV
         TY1Q==
X-Forwarded-Encrypted: i=1; AL+hErGS4KNPnhHbdUETlL8vzUHk8XHXhjez3bEgOscjELfSY6QrUHO8Mm6JRw1wCMozzNRpfUmiHwRbPA==@kvack.org
X-Gm-Message-State: APuU4Z9ryBfM6ioPLG0BbnP+uFs26+QTS1lXIs9W4P/R3s7jSXewgWZ+
	iI+A0MenXbRZBIJ3jnskTztJpNPDKxi/bdOIWr3aEwKqVnnjqOR2rTl6MJb9OyDQsHLlr2dXxoA
	dGp3IFzNqVM6Ch6hiAazApsC2Af5GPVOK1+WuJbcG
X-Gm-Gg: AZFdTZdbvnG3WY4f143KqlaoGnrRz+ZLDPtR1Y5C1h4iW/rQugzwIij4bkooLGSTne2
	RbbxjsNhg+a1sZHy9UAL98D0lrTGOLoPAHtjr3XRiY+O4G0x5pvWre8KCRHgJIX51G8+uGZ07P/
	62TEqRess2EmTErtIVs3/8LphAJIF+P8PD26CECBLKXrxwWUB9QHk70auUprwsB8YEOQwkfYW9o
	Uyy+B670j4uzmsR2+LyNPQtohlZKqFB5QG3jSoGhnKWzuonAumq0velHGr4gad7kDxKkmilEH7E
	vMP23F8sT30qbR+imuI0FR7dXTNNt6KLRLoUng5qjQJzJQyo3pQ3HhtT0aBsccFlZqA0MiyD7U2
	ooWzGbLHSiwmAgHAWkQq+VYrDnT88ZpqHHd9JBY/0NT0Bz8uULv0kEThWblAPwrhkzzrFU1Q=
X-Received: by 2002:a05:622a:5a12:b0:536:6ea4:e6a0 with SMTP id
 d75a77b69052e-55d89047301mr36389711cf.11.1795450806808; Mon, 23 Nov 2026
 08:20:06 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-2-hao.ge@linux.dev>
 <1020e36e-83bb-407b-8a6b-7669f04c26c3@arm.com> <CAJuCfpHtWJvs4F2L+QCMe9gMJ-qmcj4Q1G4hqVqFe6Z6gPoQ1Q@mail.gmail.com>
 <cb8d8dc5-4ccc-408f-acaf-2f1faa0a1983@linux.dev>
In-Reply-To: <cb8d8dc5-4ccc-408f-acaf-2f1faa0a1983@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Nov 2026 08:19:54 -0800
X-Gm-Features: Aa3M54qAZLYw0m2OwS5IQ2Il_ZIKZH-wm8JIT48ds8WuRflK3snOxTbasMdxo14
Message-ID: <CAJuCfpHfz-nNhhN2kDgi07eTMNjMEh+ZK2Ejuxb=-q8wbanJDg@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm/vmalloc: skip cond_resched() in the vmap
 unmap paths when atomic
To: Hao Ge <hao.ge@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 909C7160005
X-Stat-Signature: ugqyinsscei9hwdrfgoqgaiyzdrqet8c
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795450808-142578
X-HE-Meta: U2FsdGVkX18mkK9dl1mlirXNKBAFUUTuvaWEw/s1MiiR9C4VamNs3161iLKOTfExtI387TR74hgNNUGkNoozJTs24JtPHUEizR7gm+xpOjApFWcozlg98SoTe6p0tuT83Bs1Lud9hm4p8poZKHCQe/ezTLL8mIUM3AMTGtbWFwheMpDUG218/0FHQwCUBY1YbvJIGcM6h+m8ZKcagfFPs4fSMpASa6M7H/drQBxYh8WT5okflzqLAZtEyJyWynfL3aQRFHpjqgsYMCor4SCEkHeFDAmTxnkRr3bPWWzCAvy8H4tOMr7igEFIFQ+G33iApYP3lbQ9fepSmleT456rjWQaxWa8vN0alXw/2EAmpmaE2pPw1j9oOSWD4Ruhj73OArASOUbbyupiicFOFBRxa9FylmIvMVrpGKi0jW5TBZeqSpl5eLHCCwax2UKhm3OTS+w5zJ17a5Eo54A1YxSUEbNlrFoWd8YSxie0YZezzv3l0ItkuhNOYIa7NS3Ab5+jWe7FCvpKW7ISs2WozG2QmOYEI8NA4JqWtWuGgsSrZsOLrzTkl+P7wezROoZkAJOpKt3CorZvDJu2i1KF1BRg0TYhTCOInPedTThJ2QZlTZ9U6Rde817iKVy5mr/kNH6D++WDyNC5pBjVggFBvEp6pXKhvIQaddCj2GHdrkB9SpWM7kItMQ2kkD1IzSp2g9oBGmNm7BI6VkNp0kBObOxSkeINViW4tn+fjOciX8Bdx8zLZq+sqlOPkdxvwLGE707rLrCyVCz9tn2imG04wMDSP64n8fNt+E5B61DFxlO+1OsczknbJ2nSgj2UyteMeWVgZGJkMNpP+GVRFvkemVaCQOcigVKLTp5oLxYkhxaQ4hMwrxu7AnbcPH6YkKD3CY/Q+ffOIyEUNk2RghKecR7sqWvBrRTbCEdWZ6rEvGdbRfqGS1m+eKxkjRTQOdbef87QSF+MDoIR0R7G1COqXQa
 w2Q6riw9
 Nc4FZ2vrNzKfCs142ipXUbxgsXCB1Zfv0JyZdzfgSAe66vt44Uz3uXWWXve8cxX2iqHokSTmY/9724eCq3XKz49nOpiocDIoYzUPXcDFmmKzufZzVJP4933Px3zJvlQyutaSee/y2UU6ILQ9RzY92NMLhslXoXhuaEmdpO2BY+/1Rtvgw+Y5TFN12dhgzx5Om5a5qo6S5YvxAjeLuYsVtzxfgLS23x6nfMAsG1f6YUy+xPbHfH95aQ4lHQXUKaH43BQgd3G/W5fsSBP43C0qkyCmrUUsFM7oE8EltUKIqiFODWlM902mED/HuLXb+KU/muJnmgHw3eYdBCFtmvlgs+xh6o1xRI4ZosByRsaPTcAC67fuk1wv3XjvYwjB/15bchSWv5jBcu4SosPCIxp/G+V4zhZJUWNCAfyabUOgHs05A+MzsmmR1mEeiU6yHrz9RloCNZDZQzPqFLa6e71vTGMuTp4VmHCEgNTIzdFg/Gq96C0rZz7jZ1MYfBdyy6poRNfVnCV8bgv845PIs73Q52rimenBiCSodduPWQqt/I80rJVbFlS6qQKJv/dJVmMrBvrDLBEPX76SPAiZ72Q2BkBl4tfC1rTmRRZU0J7CvgMO2LHR+RMTCBQDmPbdlYrBuhRrJDv7Cfe0cljOkZQo1CpVj2d8eree+3soq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 10:17=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren and Dev
>
> Thanks for the review.
>
> On 2026/11/21 05:07, Suren Baghdasaryan wrote:
> > On Thu, Nov 19, 2026 at 5:02=E2=80=AFAM Dev Jain <dev.jain@arm.com> wro=
te:
> >>
> >>
> >>
> >> On 16/11/26 12:43 pm, Hao Ge wrote:
> >>> The vmap failure paths can be reached with GFP_ATOMIC or GFP_NOWAIT
> >>> since commit b186a94227b7 ("kmsan: remove hard-coded GFP_KERNEL
> >>> flags") and commit 8da89ba18ed4 ("mm/vmalloc: handle non-blocking
> >>> GFP in __vmalloc_area_node()"), so an undo of a partially installed
> >>
> >> You mention this commit too, implying that vunmap_range_noflush() can
> >> be called in atomic context right now, but in this patch in
> >> vunmap_range_noflush() you pass 'true' unconditionally to
> >> __vunmap_range_noflush()?
> >>
> >> Can you give me the call chain existing in current kernel which makes
> >> this bug trigger? In case it does not exist but is only triggered when
> >> you add the rollback code later, then this patch is not fixing a bug.
> >
> > Yeah, IIUC this is a prep patch for later changes and does not fix any
> > existing issues, therefore should not have any Fixes tags and should
> > not be CC'ed to stable.
> >
> > Other than that LGTM.
>
> Right, this is a prep patch for later changes. I will drop the
> Fixes tag, this patch fixes nothing by itself.
>
> I would keep the stable Cc though. The next patch, "mm/kmsan: undo
> the shadow mapping when the origin mapping fails", is the real fix
> and it depends on this one. Per stable-kernel-rules.rst, patch1 in
> a series should be marked for stable inclusion when patch2 depends
> on it, otherwise the fix lands in stable without its prerequisite.

It might be worth spelling this out in the changelog to avoid
confusing Greg and Sasha.

>
> Or did I misread the rules?
>
> Thanks
> Best Regards
> Hao
>
> >
> >>
> >>
> >>> mapping may have to run in atomic context, where the cond_resched()
> >>> in vunmap_pmd_range() cannot schedule.
> >>>
> >>> Give __vunmap_range_noflush() and kmsan_vunmap_range_noflush() a
> >>> can_resched argument and skip the cond_resched() when it is false.
> >>> The existing callers are on sleepable paths and pass true, so nothing
> >>> changes for them.
> >>>
> >>> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_=
pages_range_noflush()")
> >>> Cc: stable@vger.kernel.org
> >>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >>> Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> >>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >>> ---
> >>>  include/linux/kmsan.h |  8 ++++++--
> >>>  mm/kmsan/hooks.c      | 14 +++++++++-----
> >>>  mm/vmalloc.c          | 24 ++++++++++++++----------
> >>>  mm/vmalloc.h          |  3 ++-
> >>>  4 files changed, 31 insertions(+), 18 deletions(-)
> >>>
> >>> diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
> >>> index 7da9fd506b39..0016c032d1e7 100644
> >>> --- a/include/linux/kmsan.h
> >>> +++ b/include/linux/kmsan.h
> >>> @@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush=
(unsigned long start,
> >>>   * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap=
.
> >>>   * @start: start of vunmapped range.
> >>>   * @end:   end of vunmapped range.
> >>> + * @can_resched: whether the unmap walk may call cond_resched(); pas=
s
> >>> + * false from atomic context.
> >>>   *
> >>>   * KMSAN unmaps the contiguous metadata ranges created by
> >>>   * kmsan_map_kernel_range_noflush().
> >>>   */
> >>> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long e=
nd);
> >>> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long e=
nd,
> >>> +                             bool can_resched);
> >>>
> >>>  /**
> >>>   * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_ra=
nge() call.
> >>> @@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_r=
ange_noflush(
> >>>  }
> >>>
> >>>  static inline void kmsan_vunmap_range_noflush(unsigned long start,
> >>> -                                           unsigned long end)
> >>> +                                           unsigned long end,
> >>> +                                           bool can_resched)
> >>>  {
> >>>  }
> >>>
> >>> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> >>> index a706666db097..69008b085658 100644
> >>> --- a/mm/kmsan/hooks.c
> >>> +++ b/mm/kmsan/hooks.c
> >>> @@ -136,10 +136,13 @@ static unsigned long vmalloc_origin(unsigned lo=
ng addr)
> >>>                                                KMSAN_META_ORIGIN);
> >>>  }
> >>>
> >>> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long e=
nd)
> >>> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long e=
nd,
> >>> +                             bool can_resched)
> >>>  {
> >>> -     __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(en=
d));
> >>> -     __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(en=
d));
> >>> +     __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(en=
d),
> >>> +                            can_resched);
> >>> +     __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(en=
d),
> >>> +                            can_resched);
> >>>       flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
> >>>       flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
> >>>  }
> >>> @@ -168,8 +171,9 @@ static void kmsan_iounmap_pages(unsigned long sta=
rt, unsigned long end)
> >>>               if (origin)
> >>>                       __free_pages(origin, KMSAN_IOREMAP_META_ORDER);
> >>>       }
> >>> -     __vunmap_range_noflush(shadow_start, shadow_end);
> >>> -     __vunmap_range_noflush(origin_start, origin_end);
> >>> +     /* ioremap metadata mappings are always GFP_KERNEL, so resched =
is safe. */
> >>> +     __vunmap_range_noflush(shadow_start, shadow_end, true);
> >>> +     __vunmap_range_noflush(origin_start, origin_end, true);
> >>>       flush_tlb_kernel_range(shadow_start, shadow_end);
> >>>       flush_tlb_kernel_range(origin_start, origin_end);
> >>>  }
> >>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>> index ccaf158c5b7f..3c0d9e69b886 100644
> >>> --- a/mm/vmalloc.c
> >>> +++ b/mm/vmalloc.c
> >>> @@ -429,7 +429,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned=
 long addr, unsigned long end,
> >>>  }
> >>>
> >>>  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigne=
d long end,
> >>> -                          pgtbl_mod_mask *mask)
> >>> +                          pgtbl_mod_mask *mask, bool can_resched)
> >>>  {
> >>>       pmd_t *pmd;
> >>>       unsigned long next;
> >>> @@ -451,12 +451,14 @@ static void vunmap_pmd_range(pud_t *pud, unsign=
ed long addr, unsigned long end,
> >>>                       continue;
> >>>               vunmap_pte_range(pmd, addr, next, mask);
> >>>
> >>> -             cond_resched();
> >>> +             /* The undo path may run in atomic context. */
> >>> +             if (can_resched)
> >>> +                     cond_resched();
> >>>       } while (pmd++, addr =3D next, addr !=3D end);
> >>>  }
> >>>
> >>>  static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigne=
d long end,
> >>> -                          pgtbl_mod_mask *mask)
> >>> +                          pgtbl_mod_mask *mask, bool can_resched)
> >>>  {
> >>>       pud_t *pud;
> >>>       unsigned long next;
> >>> @@ -476,12 +478,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsign=
ed long addr, unsigned long end,
> >>>               }
> >>>               if (pud_none_or_clear_bad(pud))
> >>>                       continue;
> >>> -             vunmap_pmd_range(pud, addr, next, mask);
> >>> +             vunmap_pmd_range(pud, addr, next, mask, can_resched);
> >>>       } while (pud++, addr =3D next, addr !=3D end);
> >>>  }
> >>>
> >>>  static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigne=
d long end,
> >>> -                          pgtbl_mod_mask *mask)
> >>> +                          pgtbl_mod_mask *mask, bool can_resched)
> >>>  {
> >>>       p4d_t *p4d;
> >>>       unsigned long next;
> >>> @@ -496,7 +498,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned=
 long addr, unsigned long end,
> >>>
> >>>               if (p4d_none_or_clear_bad(p4d))
> >>>                       continue;
> >>> -             vunmap_pud_range(p4d, addr, next, mask);
> >>> +             vunmap_pud_range(p4d, addr, next, mask, can_resched);
> >>>       } while (p4d++, addr =3D next, addr !=3D end);
> >>>  }
> >>>
> >>> @@ -512,7 +514,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned=
 long addr, unsigned long end,
> >>>   *
> >>>   * This is an internal function only. Do not use outside mm/.
> >>>   */
> >>> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
> >>> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> >>> +                         bool can_resched)
> >>>  {
> >>>       unsigned long next;
> >>>       pgd_t *pgd;
> >>> @@ -527,7 +530,7 @@ void __vunmap_range_noflush(unsigned long start, =
unsigned long end)
> >>>                       mask |=3D PGTBL_PGD_MODIFIED;
> >>>               if (pgd_none_or_clear_bad(pgd))
> >>>                       continue;
> >>> -             vunmap_p4d_range(pgd, addr, next, &mask);
> >>> +             vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
> >>>       } while (pgd++, addr =3D next, addr !=3D end);
> >>>
> >>>       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> >>> @@ -536,8 +539,9 @@ void __vunmap_range_noflush(unsigned long start, =
unsigned long end)
> >>>
> >>>  void vunmap_range_noflush(unsigned long start, unsigned long end)
> >>>  {
> >>> -     kmsan_vunmap_range_noflush(start, end);
> >>> -     __vunmap_range_noflush(start, end);
> >>> +     /* The unmap paths are sleepable, keep the resched point. */
> >>> +     kmsan_vunmap_range_noflush(start, end, true);
> >>> +     __vunmap_range_noflush(start, end, true);
> >>>  }
> >>>
> >>>  /**
> >>> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> >>> index d8372a4f65c4..4ec114a75f04 100644
> >>> --- a/mm/vmalloc.h
> >>> +++ b/mm/vmalloc.h
> >>> @@ -44,6 +44,7 @@ int __must_check __vmap_pages_range_noflush(unsigne=
d long addr,
> >>>
> >>>  void vunmap_range_noflush(unsigned long start, unsigned long end);
> >>>
> >>> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
> >>> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> >>> +                         bool can_resched);
> >>>
> >>>  #endif /* __MM_VMALLOC_H */
> >>

