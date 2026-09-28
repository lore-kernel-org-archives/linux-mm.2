Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777A3CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5376B008A; Mon, 28 Sep 2026 13:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885A36B0092; Mon, 28 Sep 2026 13:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774F56B0096; Mon, 28 Sep 2026 13:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9D76B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:47:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D86E5C022D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:47:48 +0000 (UTC)
X-FDA: 85263903816.20.EF06725
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id EEC6A20004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:47:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pceFgQwd;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pX5ypE41nzCu788KA/U3/7sCCgsDbiY8nPFhVISf1I=;
	b=qFhey7yMIvtq9giibmwJNq8AYszvTWK+Zkwb4fyiY8yhhjNbskhK+lMYZMzByJbkkzo2fZ
	vmUxmtxq0VDz+UHkU45tzOubhZfGfAPv0tNhPkSnCL4nNHj9Tj3I/gKDmiW6jSdUg9W4iX
	1NCrLR8wumC7M8Q37hnPsGD/ePyHUko=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pceFgQwd;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617667;
	b=TFTo/WUPtpDOl+wn3j4tLrwgjoW9V8B74Wbl0K7bKhrSJiJqjraPm+rL+U1/ns+WluK3rw
	DD/ixgmoGKcUocPUc4/uJH2hg9zuYW4wv0cG0czvZ19L4sGocbCFDQ9TkEuO05dH8Pr182
	PFu4THx3f0ey5sKFzcZkCBQnY0eFJ7I=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ef15c1so456426266b.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790617665; x=1791222465; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6pX5ypE41nzCu788KA/U3/7sCCgsDbiY8nPFhVISf1I=;
        b=pceFgQwdfbDAXQiV2/uO3kbMCLY90vqCLtpQV6fLKTVr70qMmpa0vg52awkOjVXAZ7
         sotopD8XpLJdcL+NMaCAWI7UYe41GDwuIlh4oyx4ExNpwuwdgHFlru6q4OeETIkYbhFp
         qx9NacYsS/pcGYW68rSnrpVqUFVyAhf+AiTW/G6BlrqeviyPq3Z4DJScZ0W0pAgQkRXz
         KcH23QBMKVN9bdfHyFrn79OCIBF5iHU3IRxLbv3YTpqGQApo0UyVNe9XxB+maLfrzDqe
         bNNxLi78Rom0VR/Lp8A/RR5D6TypVYSPeO9QZG/e+KCqoCpxn+8TNjbTO/9Hx0ZiWtWs
         x0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617665; x=1791222465;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6pX5ypE41nzCu788KA/U3/7sCCgsDbiY8nPFhVISf1I=;
        b=R6Cef7nGgWdynQz81Bvy17WJa3ojJFgZReh9TGiroZ8TtnvksBvwr74Js6M2DOmqe4
         mbi014CG7+oFcaeiSzUAG2CZVVNpXd+gxxJRlBLtCQB2y/+ggSTsfMRmPeKROgXS2dfU
         xZHfLiAF8iUxY6bCEAuZG0+zmjcsJSJuxyGzH536dwf4CPMAcEelajByUAgGiBg4F0gJ
         ULrKSox9WM2S2fOrufUOyPaL6a9I+ruB9AdQJgTHIIlbPqoLkRURDEAbcFugRRNYuVYk
         I3rgfEQP4iNSTnWfPRwAgOfl8stiUTDtO8hml+9vMsFoBUyP0pXRRjquNFcuJiusp9v+
         EjWw==
X-Forwarded-Encrypted: i=1; AKwUvBy8m3xXph/EBib9TrfLWa6/4vpib6sIWG1XHsqNXHOWijID2YKKuD71GbrcLnCj2D+FcQqeRbMYFg==@kvack.org
X-Gm-Message-State: AFuF++lL9R2CfZcwoJxlqSVki1LDMXMnyG+i9dwDVeFb9ETauDrKeicE
	j7yzumsH8JnfNHTm3xSRl/bTlckCKjdwk2wUtcXYc595lsFs9Sg/I5XP
X-Gm-Gg: AYBFou2lEzdK034Q8YsHR6YaWmwNUPPvfEpfYhH9+a5rLOlOrxRk3tWOE3Dt4Tr8efT
	/nHPSPv7x9j9jbnRocO1RoBqGVliXWu26f+OW9D3b+Gd4y2zTFMpgnY05cwHyyqZfzPFrDJNlVH
	Myw8wfowBF1t59hHNfDD/ayil5I19qH7lUpdvQmAAz9TwBXFxvhn/t+4SshW65nidug35sD6dCo
	q6e92NWh+kLTCGkGfdYuDUfaRoVsbTmGZNDIAV3ecrp2/UKrLMPDrWQmy8t9PDnwht9VSbY7DjU
	WjEglF1Vs9zt++2yXXtMxc8JuvtS0ugtsoCJcEuYBcBmC6FhQWOoPweel2ZTWSIJUt2YBfcGvjJ
	RsGlGy2KVo2Cx3wUt1qov2GJeRg9H0XRE/WSOXOHOKMQVOEOZo1iRYLEnDNuukoaOjAfiRiHprX
	Zie3Ab2hKG8FnLZ/zOtPogYFqUcUpIEEWaSws=
X-Received: by 2002:a17:907:7215:b0:c2a:ad68:c70e with SMTP id a640c23a62f3a-c2ac2371dc4mr1060338666b.11.1790617665235;
        Mon, 28 Sep 2026 10:47:45 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2de21a6349sm149417066b.21.2026.09.28.10.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:47:44 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 28 Sep 2026 19:47:42 +0200
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Hao Ge <hao.ge@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Message-ID: <arqoPs4ZplfcGmLo@milan>
References: <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
 <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
 <arpK2bQrrUMvEvTP@milan>
 <arqDHnBFGKQZm7VU@milan>
 <CAJuCfpHuTzFBUm2uAbkFsKF85GxcqFATmKgT50AQgWkLjf7NMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHuTzFBUm2uAbkFsKF85GxcqFATmKgT50AQgWkLjf7NMw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEC6A20004
X-Stat-Signature: hw8iqx1jmttn8xrfpj3wdnocd8khyrgb
X-Rspam-User: 
X-HE-Tag: 1790617666-975059
X-HE-Meta: U2FsdGVkX19AAvQjiEg6gFxNKidjAyQ8zd2J7G4wkNc9C9XKQUUWn+e+ixcQT9GwLHzclk1efZvIdnSiTg35YVqIdtPJttnJROrnLJa0OaWvrj1JrrQTVdAly1ynaveBQMoe30pziWg9oMsbUZSl5NV/mi3TK8Ffisyypy/EzRojLKDIQf9nfgIBcQWXOkhe2UiufwvRzTB8j3c39Y2tFCSQHfQuADLHpRtzPcMluyYwUX6wri1t/t9a3qNqfnAMNIxx542KoM95wtnCZ8BSf43RJP+aUq2E90rO0yfFFJhLpSLMcoISM1H+XlI3W9Eb05TFwA3OUkX+s7jNqL3oJUjqdIi14mybYEyUBsJ2sDJCWRVUgHfWP/BJGbXwBqAxSq6j0dtIZNqVSZmHaaWwuU/7xV1N2V7/zJrZj2pPRJZHJANivzpez6/HEqGNx6fvpnXgfOVp8qrYZPO5zhI4leQv/n+Vs3O3o2SC6AMvUl8Gua4yGpM9M2kZEzNTCAFht30eO3NMMlGP1PAzQLAToN38sMI4Pf3pAwrjzoYxnKL9hLvmNaTAqXf55c4UG2UXI/CBMmsxEM5wrTyrlyL9NBdzyF5BaSXbWKz4sVXPWN2fBY8FSBcE+/Bvlpm8lZsE81Blbz30MqUjysh7ppY7mzOt2tlZLhKszRd8cW9J05JRaVNaaLfUhB7RxqDcGkBwCO7M7PuHRjbMas0RV6J9KTBoo21lz2wF28Wgcq31NLYQmlY8a06r3R0iePV1TdKpJFG51vw6rKrcxBKeBsVVZW01R1BrizdMAWxhzrDEz089wc10MFvpw83WESNoj5krlqY5Ukz+aBn2tbCVFQebf82kFemculeAZQvqaH+HwfrXKc1Tevs3UbaRYqQnTNRkfslOcizHBI7fhKEMlOcbjUmgdX6JYmqRZTdMnLZOav+nsoQzozMzIclUMFeSuZ2tnJ8NdzEuSMD4tb2RaFC
 0zNoTcJp
 gZwEf1hyD4f9Ba6UQuEtbJ4WiuD5BAXOedSVdPXmhwiTQdELjm5SwllRmctdnshgeGO7Id8QTOey7vAE2JapueSpn76oXCpYLouIlmZRsppRJJxAIrSqLU6OVZ9H710XCgLns+BCUd0bBXRUfI92sipk+Z3T9qaDjAcTUBE4ZzKPdv9cmKIUq0jrbvbfhM/wiuQXSLtv6uktabjr+vRpPtd1GkYxYh/wsixkVSrUETk7GSislqqFyiYUT4xEaDCe2JOWzs3qjopYzW+cYlaYW2ugm6nRiovU/fxIitmpXhrMb398brTE1RoJQxcmHa3rE/TxChBo0CANXFCGIOTvuwFjgdVwecMpehn2381yM4yuEMeynnEVTG119Iv+mB+pHcb2U/HdcjkpB9C6kyiAaUbIm3sk9fEeHb2YOTxTJkHegcSaxbQJieARTcfnF9Fhm/OC5yBeAhnmxEm3oPCukzTxEjg1LQHTRkidX/zL7QEDzgArtX1AH+lxZhbarMVn/5vSJKpZoFQREIfjNzu/Wu07OY8hzbqCGPUoS0vz+RrtPbT1TS2oDGlTMQXA9Oph69V3tcm+KutSh0OIGeFRf75SQuHzKw+65jn8FKQVg/HbexfI9uwBLv+yiB9rcmtbh9qr74AzDCCR18IA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 08:16:18AM -0700, Suren Baghdasaryan wrote:
> On Mon, Sep 28, 2026 at 8:09 AM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Mon, Sep 28, 2026 at 01:09:13PM +0200, Uladzislau Rezki wrote:
> > > On Thu, Sep 17, 2026 at 10:32:48AM +0800, Hao Ge wrote:
> > > > Hi Suren、David、Lorenzo
> > > >
> > > > On 2026/9/17 09:12, Hao Ge wrote:
> > > > > Hi Suren
> > > > >
> > > > > On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> > > > >> On Wed, Sep 16, 2026 at 9:31 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > > > >>>
> > > > >>> On Tue, Sep 15, 2026 at 11:00 PM Hao Ge <hao.ge@linux.dev> wrote:
> > > > >>>>
> > > > >>>> Hi Suren
> > > > >>>>
> > > > >>>> Thanks for you review.
> > > > >>>>
> > > > >>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> > > > >>>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
> > > > >>>>>>
> > > > >>>>>> The reservation is already stored in the maple tree when
> > > > >>>>>> vm_module_tags_populate() fails. A failed load never unloads the
> > > > >>>>>> module, so nothing releases the entry. Release it and roll
> > > > >>>>>> module_tags.size back. Without the rollback a concurrent load that
> > > > >>>>>> already passed needs_section_mem() can reuse the freed gap, skip
> > > > >>>>>> vm_module_tags_populate() and write to unmapped memory.
> > > > >>>>>>
> > > > >>>>>> vmap_pages_range() may have installed some PTEs before failing. A
> > > > >>>>>> retry to populate the same range would BUG on them, so undo them,
> > > > >>>>>> but only if vmap actually ran.
> > > > >>>>>>
> > > > >>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> > > > >>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> > > > >>>>>
> > > > >>>>> If a patch fixes two other patches, it likely needs to be split so
> > > > >>>>> that each part fixes one patch only. But read on please. I'm not sure
> > > > >>>>> if one of the fixes is correct.
> > > > >>>>>
> > > > >>>>
> > > > >>>> Kept them in one patch because they only make sense together.
> > > > >>>>
> > > > >>>> After a failed populate the reservation is released and the
> > > > >>>> size rolled back, so the next load takes the same gap and calls
> > > > >>>> vm_module_tags_populate() again, and that retry would trip over
> > > > >>>> the PTEs the failed vmap left behind.
> > > > >>>>
> > > > >>>> Without the rollback a load that already passed needs_section_mem()
> > > > >>>> just reuses the gap, skips populate and writes to unmapped memory.
> > > > >>>> So splitting them leaves each half broken.
> > > > >>>
> > > > >>> Yeah, that's why I think vmap_pages_range() cleanup should be a
> > > > >>> completely separate patch with vmap_pages_range() doing cleanup
> > > > >>> itself.
> > > > >>>
> > > > >
> > > > > I think I get where you're coming from now.
> > > > > Thanks for taking the time to explain.
> > > > >
> > > > >>>>
> > > > >>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > > >>>>>> Cc: stable@vger.kernel.org
> > > > >>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > > > >>>>>> ---
> > > > >>>>>>  mm/alloc_tag.c | 10 ++++++++++
> > > > >>>>>>  1 file changed, 10 insertions(+)
> > > > >>>>>>
> > > > >>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > >>>>>> index 2070e682fe10..95ddf5b743d0 100644
> > > > >>>>>> --- a/mm/alloc_tag.c
> > > > >>>>>> +++ b/mm/alloc_tag.c
> > > > >>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> > > > >>>>>>                                      next_page, PAGE_SHIFT) < 0) {
> > > > >>>>>>                         release_pages_arg arg = { .pages = next_page };
> > > > >>>>>>
> > > > >>>>>> +                       /*
> > > > >>>>>> +                        * vmap_pages_range() only runs once all pages were
> > > > >>>>>> +                        * allocated, and it may have installed some mappings
> > > > >>>>>> +                        * before failing. Undo them.
> > > > >>>>>
> > > > >>>>> If vmap_pages_range() failed to map the range, why should we need to
> > > > >>>>> undo it? If it indeed leaves some partial mapping when failing then I
> > > > >>>>> would argue that vmap_pages_range() should be undoing these partial
> > > > >>>>> mappings itself before returning the error.
> > > > >>>>>
> > > > >>>> Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
> > > > >>>
> > > > >>> Hmm. I wonder if this behavior is intentional or requires a fix. The
> > > > >>> only possible reason I can think of is performance but I can't imagine
> > > > >>> a failure to map is a performance-critical case.
> > > > >>>
> > > > >>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
> > > > >>
> > > > >> Huh, my gmail thinks you are still at your previous companies :)
> > > > >>
> > > > >
> > > > > I manually fixed it on the mailing list for this thread.
> > > > >
> > > > >>> guys think? Shouldn't vmap_pages_range() undo its possible partial
> > > > >>> mapping when it fails?
> > > > >>>
> > > > >>>
> > > > >>>> pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
> > > > >>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> > > > >>>> so I did the same here.
> > > > >>>>
> > > > >>>> If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
> > > > >>>> be a relatively large change, and we would need to consider many more cases. So I think we keep
> > > > >>>> the current behaviour for now.
> > > > >>>
> > > > >>> Yeah, I understand it would require a deeper cut but if that's the
> > > > >>> right way to handle this we might as well do that. Let's see what MM
> > > > >>> folks think.
> > > > >>>
> > > > >
> > > > > Sounds good to me. Let's wait and hear what the MM folks say.
> > > > >
> > > >
> > > > I just looked into the call sites for __vmap_pages_range.
> > > > And I found there's a bug in one vmalloc caller [1].
> > > > When gfp_mask has __GFP_NOFAIL, the code keeps retrying
> > > > __vmap_pages_range. If there are leftover PTE mappings,
> > > > this can trigger a BUG(); [2]
> > > > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L3946 [1]
> > > > https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L121  [2]
> > > >
> > > Indeed the below code is incomplete:
> > >
> > > <snip>
> > >       /*
> > >        * page tables allocations ignore external gfp mask, enforce it
> > >        * by the scope API
> > >        */
> > >       flags = memalloc_apply_gfp_scope(gfp_mask);
> > >       do {
> > >               ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
> > >                               page_shift, nested_gfp);
> > >               if (nofail && (ret < 0))
> > >                       schedule_timeout_uninterruptible(1);
> > >       } while (nofail && (ret < 0));
> > >       memalloc_restore_scope(flags);
> > > <snip>
> > >
> > > and it should be fixed. As the __vmap_pages_range() can actually fail
> > > and leave some installed mappings, we have to perform some cleanups
> > > on failure or on repeat(if nofail is true).
> > >
> > > Below code:
> > >
> > > +                     /*
> > > +                      * vmap_pages_range() only runs once all pages were
> > > +                      * allocated, and it may have installed some mappings
> > > +                      * before failing. Undo them.
> > > +                      */
> > > +                     if (nr == more_pages)
> > > +                             vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));
> > >
> > > we can use but we need to check if partially mapped space is not an
> > > issue for the vunmap_range(). And it looks like it is not.
> > >
> > > <snip>
> > > @@ -3953,8 +3990,15 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >         do {
> > >                 ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
> > >                                 page_shift, nested_gfp);
> > > -               if (nofail && (ret < 0))
> > > -                       schedule_timeout_uninterruptible(1);
> > > +               if (ret < 0) {
> > > +                       /*
> > > +                        * __vmap_pages_range() may have installed some mappings
> > > +                        * before failing. Undo them before returning or retrying.
> > > +                        */
> > > +                       vunmap_range(addr, addr + size);
> > > +                       if (nofail)
> > > +                               schedule_timeout_uninterruptible(1);
> > > +               }
> > >         } while (nofail && (ret < 0));
> > >         memalloc_restore_scope(flags);
> > > <snip>
> > >
> > And looking further. If the __vmap_pages_range()/__vmap_pages_range_noflush()
> > and friends fail, a proper cleanups should be done inside, IMO.
> 
> Sounds like we are in agreement.
> 
> >
> > But i am checking callers and see that some do some not:
> >
> > <snip hooks.c>
> >         __vunmap_range_noflush(
> >                 vmalloc_shadow(start),
> >                 vmalloc_shadow(start + clean * PAGE_SIZE));
> >         __vunmap_range_noflush(
> >                 vmalloc_origin(start),
> >                 vmalloc_origin(start + clean * PAGE_SIZE));
> > <snip hooks.c>
> >
> > kmsan_ioremap_page_range() it does clean ups;
> > kmsan_vmap_pages_range_noflush() looks like does not care in shadow.c;
> > __vmalloc_area_node() as noted, it is broken as there is a BUG() on next try if nofail;
> > pcpu_map_pages() it does cleanups.
> > ...
> >
> > and so on.
> 
> Yeah, the callers that do the cleanup should stop doing that once the
> vmap functions handle it themselves. I expect an overall reduction in
> code size.
> 
Agree. If mapping API is called and it fails the caller should expect
the state as it was before calling that API function, IMO.

--
Uladzislau Rezki

