Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CCAC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 23:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2F36B009B; Thu, 20 Aug 2026 19:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAE66B009D; Thu, 20 Aug 2026 19:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFC86B009F; Thu, 20 Aug 2026 19:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46BFB6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:39:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D09BB1402DC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:39:33 +0000 (UTC)
X-FDA: 85123267026.05.F18588C
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC671C0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:39:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B0ulzPc1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787269171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
	b=wn3APn7t7enYsgwVhwy08L0z/pjJkCTn68HX8gHla4w3TwzLsv2YLbk4DdYb0E7UXSI3Nt
	tdX45DcXj8+BQXIpmh1SYh6m/FU9bqIf6yXkjvSgV7UNs6aaLqpAf1jJLZ0f1b7qcZj7Cj
	RwPwHZL4mriPVNhpxQ43XDvnEKQT5J0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B0ulzPc1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787269171;
	b=KdLeF/yyFJKRg1IhxjdK2ecYuQgfMuf21oHUrNJe/OcCfRJ4BI+6rMaspvMvQUpis1bOQW
	n9vCULa9Sx1+eHLZC/EmflX1UTFGFKT0u4wi3NPZKEPRFTJ1dOTm4gU0iPUsqB9C/2s41M
	m3D7xpnE2r4oLui5LDIEJ1TLBwFWP0o=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so4123335e9.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787269170; cv=none;
        d=google.com; s=arc-20260327;
        b=sQgUZFJBQbaYk9IWxM93PpjoGLqstcXZza+6/32VMhhQ5N9t7PXUUq1xP+IR7hW06M
         0xmPPy7XCqapJcbMBVtgtZCS7pmxHBRebwiBOPkBO0p5EXmmR9M/HNiUFRWRin45l0kT
         6jHhddJp7zrltrfWgyago+dTvLlwJCIbW9kjvYDg2++lFgHFbVKtuuEe5WGrhKSVW0ix
         1FYfWtL8UvBEE361PtNkLhst+uiBH2m1ZrwLKGt8U67KQuVSApOa7LxM4309pAFEsMP/
         TbAsuk+Y4PuGhbJwoUQGv/WT4RKrvA2g5tl/gkcq8wzKR0lqNuGjSnKIBbTjOwsHJJjA
         80Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
        fh=A5Yg/7ThQMwwMvmn+3B7fuq0Xh3bhSmA/RkfEklIz9w=;
        b=mFpV21MlyYWuaCSMD4y6xYo3yMFaDE1bD5eZznb5r9eCRQDn0nvXdJuXRjNtKsFpxl
         yu07bk+GJllWqg/3qthPbUdRF3AOYwqnU10pzp9OcGVMn/pNXYt56W73fBjTDO74wJJM
         zplUZE7O+kC7s60dnBalGPMfN/c5ii5Rkb8T+Nl7vpMQKz8D8cxCpBfSy/ahMfkc5Fyi
         HNwrY7RoW0L54cBRbEFweFFUGYzRhxJ5lsOs9t/U6RhQupoc6J8w/q1NqVzUhJeHSo2+
         cttZROrtG35BDJ9XbNyqqJHuh7AX/DaCWaOowZTkSDzTi17usIILvrtnDpCemG+wnlCO
         DodA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787269170; x=1787873970; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
        b=B0ulzPc16Vu7/5eBhQiZsW8EbbhVYt/+bjNMnEcQHvusdhTxmRrnW1gqeTWxGiTY1x
         pBpkoNtT386R3G3pwBYFTIg+ffFHLkaCxZSkBoD4YJVIG0ATwKpsVahKSd5KrmxxyDm1
         Pn/gJSL+ZNfhhsh+1+pz2AM8AZ8MnVp+9t2FmqGCItYoeGDS5mSWoJ7t6IHiyXQRf7mR
         PoRDeNtTp32SwbHKk3zUZ6L35dmPXc5iQBmEBUeBdU4WZETobnbcktDnmGC3yWwplI4n
         VsPeV67f9YxHPHjckn7ac/iXLYhl4Bg/0c/R9hL68ZlEgBesOMPDxJe0YAf9kYOIspfB
         qH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787269170; x=1787873970;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FWGDnWimdEuyVbIhKTlp9NOezQCpG6klu9pcGU95pc=;
        b=IYaz0ozdNjX5rtXvc2XDnx7HvsVcTCiPmLaE26+YqWrUo4nUkXm3oC/ipyAKALovGi
         bzba504edYgyMDJgrQmsaGPfNbHdnVxx1CwgWUTnzNM+Ek/J7ETFKJCemWQi7xstof/6
         /OoLabKTxjMKXj05KJxVXkf8FwxcB6UK4rKSDrqQaaBRfPOtZdiGZeTIiEyeyKYjh04J
         TQgQ5QYLQkrZIhe57ghdltVmyHt6hoRSKWdb6zh+e/jfm1IcmOInPL+/lKZ0p9gpU9X2
         I+z1RmNwx3+pa5pFXUjLY0Qvj1oZDuoA+M4vbNb/0d/Vk8ZQdp7N/8XZmlDWFffdJKMs
         82tw==
X-Forwarded-Encrypted: i=1; AHgh+Rr+5ISQ9SjwgXAr7HW+NcBndEMD/DkjICW7ZKv4aL4W0sei5I6f1XcETRP/v9J5kvWSC9UMsP6qwQ==@kvack.org
X-Gm-Message-State: AOJu0YwvNXFpjxWoAedI9CB4cgGFE4Jmkqn1QzQr+NCf+/8Ytqwabhqe
	SNq/LJif2FfroCBENH7TXwO8sUEPq0gH84zutI/PCDIsQWKl8epLvxvdxdrl+tJ0XdkIid3OvPh
	3tv6j7rGXBdaJclBIhgSkkAzgcOE3CQM=
X-Gm-Gg: AR+sD12U3VmHlvsVbJhse+tAxKtl3AchuREaNgVl6IvdPBrAdyD8iQR2ojxWCUylSEY
	/BUa8qFBmfCZZuwkfZRSWTyaoXod4BNuxvtEJbPX3NdZ8NdTFQI2RCX+QEvQg7QF2lTUZ1FmnBg
	O+UtNaLaw3uFdhChv845fWohcvR1F+cddwHU29p7aCvIEGMMm6LlGOjYIRKOA9ztQ3Y8qYVbfj+
	k+WRSnhtDDq+9Dz37ib99WqPWNnvdHqz92lrp8ZxmIppHIwt86dc2Vv/WaWO5DSdYIin8ruX4ac
	HzfCPIS+AGT4YPuGjHQZewtkJ9yrvskTJFIK0uNd/kqBPlEXbgPNW/6MZlhYm3C3VokaXALfj5e
	k4XWg3ROQ82HHuy8zqrxiBTfU
X-Received: by 2002:a05:600c:3588:b0:496:c18c:f9a3 with SMTP id
 5b1f17b1804b1-499b83184eamr33065975e9.5.1787269170200; Thu, 20 Aug 2026
 16:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
In-Reply-To: <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 20 Aug 2026 16:39:17 -0700
X-Gm-Features: AcwNN1W2WwOZ6oRwPRAG9dZBaGHXMlGuhp9w5dO0dP8YLHD19Z4QrM5cxrAENkE
Message-ID: <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EC671C0004
X-Stat-Signature: 1jffo1yif4pxonn1fs44c4jm74g33x85
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787269171-344055
X-HE-Meta: U2FsdGVkX18EXkr7gYJIvwgI1ocs571PTQUAPVdCzBlknUzKzpAAlyI+4UWEm0tayT8jYqAizQVQqesu4B9zS2q7M4dvSBg7KpWaxhy875b9XeoOKPrQQRjxNrHkBFKP7+txtsDVhAB9NCOPLM8DQXJNJZG9lAqWnk+DDfxUuTrJj054toAvzjYAapNPZyQPhZjMFdblV5t2/1DSIA4MtzcnmSW8K6yyRCmbvxgDKPht3EJ81PQkbLbW+caPni8FYuvAsROts4KPFABxP0Y8d5EGw2JesjfpatBISOjD3TKOgBomrKih6TNif0D6tz8kT4LR+VFl1ZfYoX2QTSo28cvKoe4OmsyNuV3VDnoTo3QrzpDDJgWcNfAJJ+uc38qyT2FWJigV79CYaj40P1yoynl7Q2TYgqcBW0PmsddxyktH70VkpXi8eA8Fzo0eVJbvKIpfL372MPVc8WQ7JjHY4fV5YUMUhKxQgGEvdddVCw5s3BqWJnW7TVejTl7350XeNx8cWXg/3yzLiqfE3zoRrf6krGN6za9c4wQ6Q4msJ0qUuFhNa3RmHlEfd4633GNHFs6QXpQN9AtLI2UABe8P1V5C7SSE4+rRQ1tGX10j8hS+Cliw+ezri2rQp4MZjj6ZTATYUnUG4eOFxuT7CYGlbic37JEEaVqNLALCao2oFon0Lr0Lq2OgjebASuNY77tQ1PIftbjrSFZgIdB/alWMaw58BVBQxQvQwqV7Tsq3IZpl3/crEfHbLhV18Xuq9aRz7c2EVjzshZsNsNVQ1lIdBhtnIbeXI4tTRhxvh+Cc6UTZrqw++MDtlDbbwZymM6MCYmxRcfZUYUpSuNgV8BCZHec+3XIixOFRMzEK4UXJzbQ6hqLu47Mtey5l64r7CMJJAbLsiVsZXOLeH3nhVDsfq5v87uDpp4zI4Z3+cZ/zAGl6Amv1VouHAzOOlp9oIRCR48TVMRw9gtf1waPVNsE
 v9wffcqk
 cz3Xgebt54Oda8tsU+wdkZj+eOiaKmRcFHo0uc6SlFuLFr+9vmE/SGx2FJYvx1ojGVZqGe8pkZUgQowdevwjR+A7cfui1bUG0uNji07mmOiA5Wp17g4gThuA/9OatWAhfRYEyuoojxwV20MZR/kXxfL77JOhShGIKkyxqCvZmIlkselCuNa2HQUAPkzFtfizsbsnjP7g+l/EtVxVoKus+8UiV2Frcc/vZ/gdqwHZUzWty6lgoni4h6LNJwUrREiL0Vg37L5wLG47BvXNStwIIfEW4ZkLsmG7WpowuOsfNtX2qABJxGryWcJBcS3HSrqlqynU+acpeNkAI+P5wOw0SGOpvJM/+GkPbxCqU488bPun+/cnoOp45HNOcH9GXHjXelFw0ZYhcqQ7Of+ZmK5mSoXeZLm4yhBvTdakT8lF2m7VhvcY/CjvjtBd2witb4nWU4DOd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:40=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Wed, Aug 12, 2026 at 1:59=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > d) vmscan (prepare_scan_control()): for determining whether reclaim
> > can deactivate, there's this logic
> >
> >                 /*
> >                  * When refaults are being observed, it means a new
> >                  * workingset is being established. Deactivate to get
> >                  * rid of any stale active pages quickly.
> >                  */
> >                 refaults =3D lruvec_page_state(target_lruvec,
> >                                 WORKINGSET_ACTIVATE_ANON);
> >                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_AN=
ON] ||
> >                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANO=
N))
> >                         sc->may_deactivate |=3D DEACTIVATE_ANON;
> >                 else
> >                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
> >
> > (and same for DEACTIVATE_FILE for file-backed folios)
> >
> > target_lruvec->refaults[] gets set at the end of the reclaim pass. It
> > stores the same lruvec_page_state() value that prepare_scan_control()
> > will read at the start of the next reclaim pass, which means if
> > reclaim passes happen more frequently than the 2s flushes (eg under
> > sustained/heavy memory pressure), this logic will incorrectly assume
> > no refaults occurred and deactivation is disabled, which afaict means
> > folios won't be moved from the active -> inactive list, and reclaim
> > will start evicting pages from the inactive list that are hot (eg more
> > refaults).
> >
> > This is from reading the code rather than a reproducer though, so I
> > don't know how much this matters in practice. Unlike for the writeback
> > case, I don't think flushign more frequently solves the problem. It
> > would shrink the staleness window but not eliminate it. Maybe one
> > solution is to keep the deactivation state for a period of time if
> > refaults were observed.
>
> We do have an internal test that runs a VM under memory pressure and
> we started observing OOM kills after the ratelimited flush was added
> in vmscan, so I think it's more problematic than just reclaiming hot
> memory, but I didn't look too closely.
>

Would you be able to share the test you're using? I've been trying to
repro it locally without much luck.

Thanks,
Joanne

