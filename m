Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4A5C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B606B008A; Thu,  3 Sep 2026 10:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713496B008C; Thu,  3 Sep 2026 10:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628FB6B0092; Thu,  3 Sep 2026 10:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B2C6B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:03:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4894DA46CC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:03:49 +0000 (UTC)
X-FDA: 85172619378.22.22847BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 622EB10000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:03:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKcvgfMp;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIkCVMXueZug7Awhe2bDRHsi+uaKaNMKk8EAPzdMILM=;
	b=r1ztqNXLonCYqoe+FFUxUpnCSFcVtG8v/YVuA1ucEGPd9t0DKuNxpdJPnH/QZV9igb63yw
	0znB3u8XfRov2hsFd832jbQW0qmMCAVX6n2qTHDyL/9pGqi7mDkIyJDPgcNogSFbSJ/G1A
	B8FXrHq9h+8+LRot+bWQdnUlcIqybK0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKcvgfMp;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444227;
	b=2yaCiHE12FXRiVrRdhpYw9MiXH3RlSGtkkZ9JHrJjSaPHRF0BbrcAs2UtOHnhZvJxJUo+Z
	AmYRzGh9tdQDZmNTpmQrCbSg8DMab37PxFJXjc4cAnr4W0ovJsZaS7AI/1oUjkMp8OHaYc
	UQ6HgnJUoYhR7cTIaSF6T6FDJjqIvo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D30B060A52
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894471F00A3F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788444226;
	bh=SIkCVMXueZug7Awhe2bDRHsi+uaKaNMKk8EAPzdMILM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MKcvgfMpi72qQpfUBJdR6W1lHzc/2rNRHq0b0XCtBRAHeStSFPGp9K4F6s6o711he
	 Hl29qtTtA6faFKUb4JZtyrBdX8Ht1RrFF3+j8O8Dd8zRycPEb3pgPCumQ0HQwaiUGm
	 2nuz3JfDsa9vbXSb0BRKfeov+LvsmIlmRsMiKejnjW5C3nlICchVu9SZ+XGb+8SJZh
	 KEU/Y+JQX9DKwpiVZm0b8VdU8BJ567YPPauQzwUiA06AKyPQqIcldyKKHzfFCbSy6j
	 1l1gIG70zoXuS0jtcNW//96UEnEcFVe7mfHa03SwITbF+EJbu1DJfeg+2eI+lFbNnc
	 meHyLfNnc2SZw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20ce3c118aso225128766b.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:03:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByImpB7DMKzYRXmGPFiIdnuhvUv5pOJ/qrEVOECWZgnCuVSttLmMUSgsxSYC49JTIwHgtxbNAlpnQ==@kvack.org
X-Gm-Message-State: AFuF++lTyoZ6E6by7KDs70eyKJ2KEy3vSUN3pWnTst/L9WgdVgcqz8SQ
	5lm33pYX76uAb/VOWWa1euAgMRKTdH/NlJC/k79Djj9bmcmUvzBFWEoxHLxpOrnf/fu9lzys3Zy
	LyHoGeMgeUzMMKvOSgjVM3/SwyU9/vrE=
X-Received: by 2002:a17:907:8323:b0:c25:f7dc:2e0 with SMTP id
 a640c23a62f3a-c25f7dc0985mr100970266b.33.1788444225414; Thu, 03 Sep 2026
 07:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com> <apkhSHr3by5Bf8jW@tiehlicka>
In-Reply-To: <apkhSHr3by5Bf8jW@tiehlicka>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 3 Sep 2026 07:03:33 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
X-Gm-Features: AcwNN1Vh9NEyJMK2-RqtsSvN7Ew3MbvuJfwRRlZGGsd6gh2ct7StqfMzBcy6rzk
Message-ID: <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
To: Michal Hocko <mhocko@suse.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org, 
	mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz, 
	hannes@cmpxchg.org, quic_pkondeti@quicinc.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sb9k7tx5wzrhnuxqjgsufu31yfiea5g1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 622EB10000B
X-Rspam-User: 
X-HE-Tag: 1788444227-437591
X-HE-Meta: U2FsdGVkX18aZ3myC6Wy5Kj4skhJcUo2xSMlxNt5B5gCWCaN2V/9ifkQGf/NDMr1OVX4joiO6eUZBaz9g3k7mHbVQqZkyX1cdgVMI/y61VDogE+Q2RQRm7wxsNTVGuwOvPGEFs/JUxVX0gWn+evuS8a99NmPSI0QkP8v4LDcBuRR0paVGa/X47rfy7VdTAl7n+qDACb9g581cO6zTTapH5NlgYFZ/7E93y40gxHoimxjmv5S407Am7YPiCIg10YhMn0j0zDqakTcB0Bbm2uMVRyJJllm28drZ3VT9H+L2M0aoAzMzV7U0mXNQC7ntcqh1CtkMrkXheUKMyngsaMm26LqL+rVuUnDGqlJwyCothUuEwU2SOn1jp+MiNeRQOlezHhJg7etPV2ex7mF1JeI8ISLO/sVNFXtiO9K5ulGcimCTvcvHyaNWGn9IPOIbbbhqMSgVlL0bxMDdm0kJiVUBnlFxO0c6y1SMRE0SHQ7Ucp6unbseryKHAz0nlnH+2RO6jjCL453mOImhFOuCQ7XOXW5LGO8QmEvmANAKghidVvmVbDGYUdDKJ2vQ4/ao4nPgLhUpYPbHOT7ldXyhN5Hcf9sKmXCm6yfAkfKUmou+4sH309cjlV7A4L7JethjFtkIC6kqN+LgUCzdnPaAZMQNXW+mcEs2c3vH7y2W45Xc+0Zvq5PhM1tu51PtrL6b/i1aqOe0jmxb4uOeIQgh2p6tm3jUc+UXggghciF5xyzEFfGep9JJwtPNdRyiA5PeQ3S8dSxl5YOR9oWUa2nCnCXidfilVbzwaGleyFdHRaLI+JUmpiiTbOHcs+Rlvg4Gs3Y1AM70ex02d2ZOxkL4Hnlnd3lEqxTWKF16Gr8FVe9hccoKfUFI8rxtp5m/0v/Qy3yLhWI0LwthWx2SDD5STSlU2ybkhP1acD/dafRykboJ9hD1dj7CZx2TBybO2YOY1CYtHdCrZGQpO1Vwsue4IN
 x+LCwjFZ
 CZwS32V4DmoXvyVvIWSCaaGUTzmPdkxKO3o0TrXsvgGdMcuIDPa8GaA1OEAd/8lSVaikKFWYUEPXdo9w9u5xXeXa6X2b8PKddUEhL+6RAwFINNngfb+xLA2ME9XVGq6+VPA1X/DtnHLirySz6jOtJkCKykX8GrXW2PsJh6u4wcxxAPu/WbS8Fgs+zQ4+fbBjnq8TYPAe6mGvsbuT6DoFj615eqGcyYoARjbU1N70ncg64S0Z2/ztlC/yUCegan+JeZnDrkzzVZ3TyZk2DPDUFvqrebr36Pk3tf5gKflVIqUlTegsJP5R0TP0fd8Mz2ccDMOrnmqTn0unj/Hq9VneNhnHq4WuMya4W6bWMd3O9dz3b2Pml+N2DGo8OAGM9Ph5sUeieC8L96e1ClWGrkukclKf1ZdDdkYEPsuLE9kR/YJ5iEFYlYYSPhmHds82T2NVig0rb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 12:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Wed 02-09-26 16:49:48, Yosry Ahmed wrote:
> > On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> > > pcp lists are drained from __alloc_pages_direct_reclaim(), only if so=
me
> > > progress is made in the attempt.
> > >
> > > struct page *__alloc_pages_direct_reclaim() {
> > >     .....
> > >    *did_some_progress =3D __perform_reclaim(gfp_mask, order, ac);
> > >    if (unlikely(!(*did_some_progress)))
> > >       goto out;
> > > retry:
> > >     page =3D get_page_from_freelist();
> > >     if (!page && !drained) {
> > >         drain_all_pages(NULL);
> > >         drained =3D true;
> > >         goto retry;
> > >     }
> > > out:
> > > }
> > >
> > > After the above, allocation attempt can fallback to
> > > should_reclaim_retry() to decide reclaim retries. If it too return
> > > false, allocation request will simply fallback to oom kill path witho=
ut
> > > even attempting the draining of the pcp pages that might help the
> > > allocation attempt to succeed.
> > >
> > > VM system running with ~50MB of memory shown the below stats during O=
OM
> > > kill:
> > > Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> > > reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> > >
> > > Though in such system state OOM kill is imminent, but the current kil=
l
> > > could have been delayed if the pcp is drained as pcp + free is even
> > > above the high watermark.
> > >
> > > Fix this missing drain of pcp list in should_reclaim_retry() along wi=
th
> > > unreserving the high atomic page blocks, like it is done in
> > > __alloc_pages_direct_reclaim().
> > >
> > > Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
> >
> > [Sorry for thread necromancy]
> >
> > Hi Charan,
> >
> > Are you planning to respin this patch?
> >
> > I know that Michal was questioning the need for it. While doing some
> > stress testing I came across a couple of OOM kills that had significant
> > amount of memory in pcplists. Something that would have been prevented
> > by this patch.
>
> Could you share some numbers to see the scale of the problem?

Sure, here's a sample from an OOM log (ignore mapped/free_mapped, it's
from the ALLOC_UNMAPPED series):

[   40.336188] Mem-Info:
[   40.336195] active_anon:96 inactive_anon:1540181 isolated_anon:0
                active_file:51 inactive_file:0 isolated_file:0
                unevictable:382720 dirty:43 writeback:0
                slab_reclaimable:20339 slab_unreclaimable:26597
                mapped:382858 shmem:153 pagetables:8291
                sec_pagetables:0 bounce:0
                kernel_misc_reclaimable:0
                free:17264 free_pcp:16890 free_cma:0
[   40.336199] Node 0 active_anon:384kB inactive_anon:6160724kB
active_file:204kB inactive_file:0kB unevictable:1530880kB
isolated(anon):0kB isolated(file):0kB mapped:1531432kB dirty:172kB
writeback:0kB shmem:612kB shmem_thp:0kB shmem_pmdmapped:0kB
anon_thp:10240kB kernel_stack:2576kB pagetables:33164kB
sec_pagetables:0kB all_unreclaimable? yes Balloon:0kB gpu_active:0kB
gpu_reclaim:0kB
[   40.336202] DMA32 free:34808kB boost:0kB min:11028kB low:13784kB
high:16540kB reserved_highatomic:0KB free_highatomic:0KB
free_mapped:11032KB active_anon:0kB inactive_anon:1487720kB
active_file:52kB inactive_file:20kB unevictable:393252kB
writepending:4kB zspages:0kB present:2096760kB managed:1991156kB
mlocked:393252kB bounce:0kB free_pcp:42404kB local_pcp:2460kB
free_cma:0kB
[   40.336205] lowmem_reserve[]: 0 5976 5976
[   40.336210] Normal free:34248kB boost:0kB min:34024kB low:42528kB
high:51032kB reserved_highatomic:0KB free_highatomic:0KB
free_mapped:34028KB active_anon:384kB inactive_anon:4672764kB
active_file:180kB inactive_file:0kB unevictable:1137628kB
writepending:168kB zspages:0kB present:6291456kB managed:6120144kB
mlocked:1137628kB bounce:0kB free_pcp:25156kB local_pcp:764kB
free_cma:0kB
[   40.336213] lowmem_reserve[]: 0 0 0

As far as I can tell there's about ~65M of free memory stranded on
pcplists (in an 8G VM), which would have kept the amount of free
memory above the watermarks and prevented that specific OOM kill.
Although, as I mentioned before, this is a synthetic stress test.
Perhaps in practice it doesn't matter all that much in practice, but
it seems like the logical thing to do.

