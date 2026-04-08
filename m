Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE2D105D98A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 00:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41106B0088; Tue,  7 Apr 2026 20:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B196E6B0089; Tue,  7 Apr 2026 20:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F066B008A; Tue,  7 Apr 2026 20:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 938D46B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:09:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C6F68C901
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:09:08 +0000 (UTC)
X-FDA: 84633453576.06.05C0EA8
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F4ED4000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:09:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gaM7yKPY;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775606946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXWPRutFUvP5+kWF/q7BaLPPyBphyv3qf5bUsWG0GcA=;
	b=1yYBW5KppfWCroYSww5srxuv1Ys8yVZgtoHFZ7zFUp3tFm081Wbk08FmsZ+KITJ46Xn9OQ
	u3tpGm2eRqzziz415uj+u7YfQHamR6RyqnGPbt/r1gDu7Et69135ZFTuuzDLqUrOWLjyzH
	QQlVDp9xm5zMXpEQt+H5VUhNVohDi4g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gaM7yKPY;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775606946; a=rsa-sha256;
	cv=none;
	b=JyiI7rcS0da49CyZ1oITgAHsby9gmjrXveKzDoXBUwW5Isk6Pl8Xc3qhazQesoQ71KJEqk
	ene1y0fLp8TPxj46U0Em24rbnN8T8cPWMXAATHFx989sv8PHqEmO/99Kmgmc1lZUa6NT3o
	bstUug1VcIQDKaGTP3CcopqwWDKIHe0=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6501d242e3fso5517716d50.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 17:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775606945; x=1776211745; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OXWPRutFUvP5+kWF/q7BaLPPyBphyv3qf5bUsWG0GcA=;
        b=gaM7yKPYZPb5Wgf8VTyEBREeoMExfpsiSMnQ5TRW5BArSmQnhcHPsUZDUajBXYx+vy
         N1u2/lH93U3JpohLgBzNR8LPERBCIFpEd/mSA7/+VdS6PE6CK9lAzVokUJVoIG4po0o+
         0x7Oqyyw3iAnjgdt1Ut0o1cADz73EKLPmLgiN+PtDJklyqKWrSymCvZYy1BdI1u3/gpk
         gYTr4TMxxPtggCbRNksRuj38LezuaKn4MJ8PSy+Jop5c+lHbQdRx8veXYHu+Ajxyl6Jl
         2WYei/fhFUMZtiykeavkdhHBN4AIkcbE9zB0gBvZHmiuoEaf9UFLJEwIfGx/P+h9YzPn
         eobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775606945; x=1776211745;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OXWPRutFUvP5+kWF/q7BaLPPyBphyv3qf5bUsWG0GcA=;
        b=a73GmS5c/2hDr2uvuko92butlqDfsr/Ku7MpsBi/Qla+YjodLCyZwI/iNCNpxQWTrg
         nkdB6VjXNHPEsC8n6RU7Cp6KWb48SeJkjDPDHQ4hRh0Zyi50ajIT00z590WbQYCW2nEV
         FYmT9EvRVrDQR7hLDH9K5JWUp95nnzTSIySuY4JjtH6QtC4Boqd7HSoCKS/lIfl/9Bmt
         c8zzCPDLskGVfS5TBJEOnYJ3BgrCCd/Kn8Itlb/+DEr81AGx9FIYp414EVDTBECfAL4l
         b9peiA1BmSnjmyb2Um415Z8KzCD46VhPPus6RUa8MjGyBTgxf3D/D9liLU8V3Eg1Ga+V
         udnA==
X-Forwarded-Encrypted: i=1; AJvYcCW0j530azM+AxsQuiXvQVZw0K4ZcmWvZUb8+zZ9mtoy9w6NdW4wS9b+F8fJK5Y4Np7cY5sMzD813A==@kvack.org
X-Gm-Message-State: AOJu0YxNoWAymHhPJD8pIiBNgelMf+O2fauFI1kpgOAppibaR/lQlV1v
	vTeUG19hSUKWK4gnZZ11G6Ut4hFqo5zG7dNQ0bSFKYdOwN4XizngLcRGYgSfokx6Hw==
X-Gm-Gg: AeBDieuEEMYyRQvD4XUc/P4fJqAnB9gAuvbEaYB+4eU/UFwtrJOIOR6hfoexuppjc67
	ASIL9PcNrR/do4UhpwCrN+ZEo6UCBmLr7gSCyKiedPdhXlYJjud9qgXKjpE6IkQg7TXFhpuIWGC
	BeHHC+u92lKQkea+rknpWZlI/O/45kXUBCVE6R5bTgYPiJPXi9yORKEW9cTWfOhckCzk+pgfN1K
	mqjTd2qsa8wqh5zpVdhlM4qVRVRr6XQmMxybWYQGYcRunRnTULunRUya5sukxrbUepeYuMXrhpy
	PrLQ+P0S2f/MFh8trjwoMHL7xLWDuDpyVeprOzNrjAvm7SU86sWY5/mEQg/KGTAB5nPze/gVTgR
	f/89I9FRjIUiVk36gut+D74SIo7aMIAJ7KxFwLxWwEU9w1V6D/lyn2UwMrcnCnq1u+I0dJl0WjV
	+xREnxzU2iwlDha83yBtJ8zbO6xTPfOXwnrvNn1LZXTv/6PeIU2QTFNQRUa2zTwW4N80Bmf00lQ
	sKspfH4Sl8=
X-Received: by 2002:a05:690c:38a:b0:79a:d32f:e4e5 with SMTP id 00721157ae682-7a4d5d5c544mr201447147b3.45.1775606944740;
        Tue, 07 Apr 2026 17:09:04 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7a3712f53f1sm77239007b3.49.2026.04.07.17.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 17:09:04 -0700 (PDT)
Date: Tue, 7 Apr 2026 17:08:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org, 
    michel@lespinasse.org, ljs@kernel.org, chengming.zhou@linux.dev, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: ksm: add mremap selftests for ksm_rmap_walk
In-Reply-To: <a14a89ba-e870-47d2-a903-564332da9877@kernel.org>
Message-ID: <2513cca9-0f5f-3b5b-e758-b9cc304c8699@google.com>
References: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn> <a14a89ba-e870-47d2-a903-564332da9877@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F4ED4000F
X-Stat-Signature: x6igtyjw1331doprwkxdxdtzc9wkcp9p
X-Rspamd-Server: rspam06
X-HE-Tag: 1775606946-81549
X-HE-Meta: U2FsdGVkX19+XrvPSraqrv+vlAiOskMMz7Eax0Ph8fSi64UjDHZXGFeaWqxfl/lKmrUxF/7px/zQoUDiLETpTiymeDR/vX2ruthyoGJkisnEbxl1TuEODtKfi+6iKUJ/+sKGrasS08ueW+MSEhRtIFDv0mRDhOKzaakxt6Lj7G2irGh7enx8DVjN/mrVy/uvIKzYdhqzoKM5apH5FTOVu4XW2tHqb870t+88ZOnLzi7xMo6IHcVwxKy6kl5koX+KuzIiDE9Wxxu6DiHLa9JpMVYr6mP8lXbNw6z5JdeWrw2GEFkG0Kl0KZVA/xFs9p8o2cpOqCjAhHvl+DuDQRlZ67s+Hx7jBZ2MNEBfQRsDZWhUElr/i6LQRZdaMz1nptxbeIJ0pURzSK6TpLDySWQ6Y7gl59CcB8MIhh+L3jUBV7UjXU52jWRKBfEfB+pp0ve6p1EdX+iaZ5cLRkmgVUnKhl0jpMpL3/XcmntqDhZoG5JguodXr8dSfKj6SSuPX8uUDwDecVaYHmlj8qfwYELxsMz0qWDLrxpWBDE2TPg42sheUEVSiln0kKfdVmS8IvDY3abSKZDRqljo5QiT9zgZBUlt/hpvj9/si76kPVcLydgs3qPbxWzP9xPWrxei9w/loxccJk5taYCb2WYGMYf4X2k1dPrP2zbQAOfCbE6BveCz9t4Q/ptKVlh7AsC+BhYsV/pOBBF70ANbUEQFnGvKnOIYHLcYLMWftejoeWbuf3Ra4uLBMXwrahMbqiAi0kjrVe6E+sr4LJSHfT7+eIggdfYRI0grww6IAxAbp+2/2QI9VR6ZXmw1AYfsi0t+2DBJXD2FgEAExj8gTpgYfTyFzlVu4iRBl0eF0pdQvVP7Ru23PNUTcr1PerL4gNm2DEz3Sd5R3MGYbVUV6V363FQsmg/ZeBBtemZUcZvQBRJdpWj5qjJgpN/MUj4FUZddNZr4g84614AYK9elPpWTEKA
 UnEoyd46
 X4XxDN5i/oCLiEh0vcbck1XPsxb+Npp2zZqGYdIygGjr+JMdL7Uw2N9mDxT/YfBcne2evSY3mYAgN17itg4YfeePMi9lmztl33Lxwx4z2nCiGGjjKOkN8xDTOYi/m37h6PHE1767l/elPtH979vFuznV19z5oKJNzShbiVsN4zpeys8+cwy8dcYk4Ad5pH47IQyFZMdbPHWUz3tgJJA5ElFJW3/BAJ6EHnm6XqFC+EpmwS+3UZjLh1Q9TaRJy4jvUZMl7fHp/cIRIgrcOfzzQwv4OZ3NiBXUMKC+plADhD0f0WfO6IbDEGdrLt2o32541+C+8ETnpBFSQMJdUzUvl6c4c0Ko4LQ61/C+HraWim1/dNnD2JAKjpijlemJe6VYycQhdco/ajcnzVEpxOMxf4RRgASUmE2cxvj9RPaE2DQyXrOuaLba0CzZWfSVLLB82mE8VvtF94ZvsMGIG27b50SBeNLekL0FKhu8c4KRcle2xvys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026, David Hildenbrand (Arm) wrote:
> On 4/7/26 08:08, xu.xin16@zte.com.cn wrote:
> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > The existing tools/testing/selftests/mm/rmap.c has already one testcase
> > for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
> > of page from one NUMA node to another NUMA node. However, it just lacks
> > the senario of mremapped VMAs.
> > 
> > Before migrating, we add the calling of mremap() to address mapped with KSM
> > pages, which is specailly to test a optimization which is introduced by this
> > patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address range")
> > https://lore.kernel.org/all/20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn/
> > 
> > Result:
> > TAP version 13
> > 1..5
> > ok 1 migrate.anon
> > ok 2 migrate.shm
> > ok 3 migrate.file # SKIP Failed in worker
> > ok 4 migrate.ksm
> > ok 5 migrate.ksm_and_mremap
> > 
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> > ---
> >  tools/testing/selftests/mm/rmap.c    | 69 ++++++++++++++++++++++++++++
> >  tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++++
> >  tools/testing/selftests/mm/vm_util.h |  2 +
> >  3 files changed, 109 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> > index 53f2058b0ef2..65470def2bf1 100644
> > --- a/tools/testing/selftests/mm/rmap.c
> > +++ b/tools/testing/selftests/mm/rmap.c
> > @@ -430,4 +430,73 @@ TEST_F(migrate, ksm)
> >  	propagate_children(_metadata, data);
> >  }
> > 
> > +/* To test if ksm page can be migrated when it's mremapped */
> > +int merge_mremap_and_migrate(struct global_data *data)
> > +{
> > +	int ret = 0;
> > +	/* Allocate range and set the same data */
> > +	data->mapsize = 3*getpagesize();
> > +	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
> > +			   MAP_PRIVATE|MAP_ANON, -1, 0);
> > +	if (data->region == MAP_FAILED)
> > +		ksft_exit_fail_perror("mmap failed");
> > +
> > +	memset(data->region, 0x77, data->mapsize);

(Not crucial at all, but to avoid confusion between our results, I'll
point out that my testcase only memset 2*getpagesize() there, leaving
the last page unpopulated - just one less complication.)

> 
> What happens if you mremap() after faulting, but before merging?
> 
> rmap_item->address always holds the user space address of the entry in
> the parent process. It must match the one in the child process, because
> mremap() will unmerge/unshare in the child.
> 
> And it must match the one in the parent, as mremap() would similarly
> unmerge/unshare.
> 
> Maybe doing the mremap() before merging (but after faulting) would
> trigger what Hugh described.
> 
> break_cow() and friends don't care about the rmap, as they simply jump
> directly to the user space address in the process.
> 
> In rmap_walk_ksm(), I think the concern Hugh raised is that we are using
> 
> 	const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
> 
> but we'd actually need a pgoff into the anon_vma. Without mremap, it
> does not matter, they are the same (tests keep passing). But with mremap
> it's not longer the same.
> 
> I think one could store it in the ksm_rmap_item, but that would increase
> it's size. It's essentially the folio->index of the original page we are
> replacing.
> 
> Or we could just remember "pgoff is not that simple because mremap was
> involved, so walk the whole damn thing".
> 
> We could also just try walking all involved processes, looking only at
> that user space address (but that gets more tricky with rmap locking etc
> ...).
> 
> Anyhow, I think that's the concern Hugh raised, IIUC.

Yes, you and Lorenzo are seeing the same seed for doubt as I saw:
as you say, "pgoff is not that simple because mremap involved";
but it is confusing, so hard for us to be sure about it.

> 
> > +
> > +	if (ksm_start() < 0)
> > +		return FAIL_ON_CHECK;
> > +
> > +	/* 1  2 expected */
> > +	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (2 expected)\n",
> > +		ksm_get_pages_shared(), ksm_get_pages_sharing());
> > +
> > +	/*
> > +	 * Mremap the second pagesize address range into the third pagesize
> > +	 * address.
> > +	 */
> > +	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
> > +			 MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());
> 
> There would not be a KSM page after this mremap(), no?

Oh, good thinking: yes, a side-effect of mremap's non-persistent
MADV_UNMERGEABLE would be that there's no KSM page in the mremapped
"subregion" at this instant, so the try_to_move_page() which follows
is likely to have no trouble succeeding; so, as it stands, this test
is not testing what's required.

Sorry, I won't be able to give this more attention for a week: I
wanted to advertise my doubt before 7.1 merge window, while awkwardly
knowing I'd have to back out of ensuing discussion and testing for a
few days.  It seems agreed that we won't endanger 7.1 until this is
resolved: I just hope I'm not guilty of raising a false alarm.

Hugh

