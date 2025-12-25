Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B06E7AD44
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 15:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AA56B0088; Thu, 25 Dec 2025 10:12:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B766B0089; Thu, 25 Dec 2025 10:12:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A496B008A; Thu, 25 Dec 2025 10:12:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 877E36B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 10:12:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3329514078D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 15:12:33 +0000 (UTC)
X-FDA: 84258334986.12.3DE0477
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4389D1A000B
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 15:12:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RLHahGpB;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766675551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlsBA+r0UDWqlBb8SdU5iMkX6C1yfhf/TMrFhFO1YhE=;
	b=kuTjNCd7mFbL0JWm1FND5qozVWk/MGZe3mrLP05/9Jv16vDrCyBX2QlyLZnxpuasxwiNBu
	p9XtgsjxVeLJQTfA9scbA7Gsu+GT/NS08EzgEDcpZmWDJ2pMJ6l1oOtadqDRrobPR/Zi15
	Wr6+09JwCN2PTsRoekTL+ggcGfB6d9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766675551; a=rsa-sha256;
	cv=none;
	b=gi/jL4VdlEzskXJ/k31cD4LVsCg/OK2hrZvCMKhpkZCAFVasHctFKoaLXq/3poA9ePrVUP
	cQrcmjEg/ITWafRFoC9xyztX1RMtdv3M9Wph/eZHJkRGN4IwnRfu18ZyUiUkyRDn6pOjr2
	9RcEoWNQBsZ3jMdzwPguM5gSVyAy4UQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RLHahGpB;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d5c365ceso85458575ad.3
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 07:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766675550; x=1767280350; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JlsBA+r0UDWqlBb8SdU5iMkX6C1yfhf/TMrFhFO1YhE=;
        b=RLHahGpBDrestU6KzcFeLehzLktVhx9+xqU9kS6GSqcRLDfkQqccHK8lT4YSj//iXC
         X0k5HVONY881KUgD8DssV1Cq+JKi71bbgiIxvgTgNMIfQk6ghqupGXi7zvXy5ozbYGIe
         YGt8h25p9ThULyXiWG7s/KW/Cd5m9u8mqTd3P6V9/goHlGFabRWn7uko6v8qJf4UEii5
         yn3dmQ7nEoVF8IfXCAAUTqfMlvHJjLfALSFKYvKNHt0ViysxLfDr+Ui1zrly2iO203bu
         LKP5ID/9iBBgG1Vqj8cxHEYvxZteiydh2KFjmk/Wk6RQ2Lid/b7lqttXb0ogQJ9ZcrpR
         s6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766675550; x=1767280350;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JlsBA+r0UDWqlBb8SdU5iMkX6C1yfhf/TMrFhFO1YhE=;
        b=Ayw5PINGGul1S3mdl+9ZbdofEvt0DylfveT3R9PN+ikxldI54cRGbQnerbGiH6jjyA
         RaE4CFSbrxLArGVZ54YLSp0nxWawuh8nxjlPWZGyF3glvkLwiWD3f39s2MkNKOBw1sWP
         bq2HpkGzU/nIVgsnP+VbU76s70A5GfySgRphJTVfKSnP4gdZB8aTAqSZNBktjE7QlsDd
         DX0boI6yk7CWdTlq2PDgLaNnJmGZzGGF5YcZZDRUv0JXO6pisXvddlwJN4oAiVG6lq19
         PuN4QPpnfZn4Xsc9v7nHOD6MLVJPTpRrhuluTWTT+OMnyhyVhdQY74YePdDpvOBAkSV1
         ysBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeyfiJTISkjFnm6Ibt/mTrjzVTDx/G7QBV51mEleHtjfpim7v6NFHOteIiuHCu6j8H0eVA6CnGXQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+Om9PmRanWe6Ms5umh+JEg2c0zQXWxVcHi1fVvyuLLAhqnyxJ
	N45IZ4dQPa9hKfqF5F4dqCiFk0f7NlF3UsKeIOqqu9TMHipbx5HEcWCK8Hw2OJRN
X-Gm-Gg: AY/fxX6jc3PzG/i0nUSG6gNUeee9R7t2xq2MPKTF5yxU/n1fyE5YJ2Z0UamNR93juEL
	oV6+W3u9Z/rLYlEes3SLpWoNFl7JPWVosgo51TGDoNlJjdJnnAKnqCSRdEVds0yVDPsOo39kNnr
	2j7HkFL0Pms3izUJWbsOrTpPTzW3kbUicYhcoH9HcmdJ1HHJX83APyIS95V41wMlbsEnQxmc1Dm
	FFvLsI4LwdZsYAcmzCmMfGXpP6oqcEGcCj4NiTUoGNA3M9ogVNKJ3oTl8xOs3Ft4JTZAyReI4UB
	oFjlh4APj3/RjNMFGhvWbye8AjeAkKPOvuEtW0e2yNvO8VoOhBqQkRE7Q57kIw9lEKrnWq4/GoI
	0xQSj/8anDudIZVErqy2SQN4LdxebIL4UvxEvfj6Uk3sfip0Rl0ptIbn2OaCpKUJGmZKS6FHYwP
	oerBiSku29jFLB4f5QJS5iu5m53GzsNGqwtQ==
X-Google-Smtp-Source: AGHT+IED3BkMJ4gM5OrE+WfCVcLgsi6XbRfk4W/0ALJH+XfkQF6ENvsE77YFXShpZRZ0cruAB6REmg==
X-Received: by 2002:a17:903:8d0:b0:269:8d1b:40c3 with SMTP id d9443c01a7336-2a2f21fb43amr206274075ad.12.1766675549712;
        Thu, 25 Dec 2025 07:12:29 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d776c1sm181472835ad.102.2025.12.25.07.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 07:12:29 -0800 (PST)
Date: Thu, 25 Dec 2025 23:12:18 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <6sciluv3ylow6frheij6imhhsglaez6d6vsbtyndwlfuetzwmf@tbs6ivsitehm>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
 <20251221021044.2r5fhepiyyhvuo7h@master>
 <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
 <5af0e0ae-0472-45b8-a249-44b4e5239d33@kernel.org>
 <ck5nkriyqdvy7ftu3xeu6cn4aj3s3cpefbga55vkzblnoywrpi@2sw5oh3saixt>
 <ad2c1355-be13-45d9-8474-a32a4b710aa5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad2c1355-be13-45d9-8474-a32a4b710aa5@kernel.org>
X-Stat-Signature: 99zcfxmtxqegfgb3yaxco14us35fry97
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4389D1A000B
X-Rspam-User: 
X-HE-Tag: 1766675551-391783
X-HE-Meta: U2FsdGVkX18/sV570GE+anO321goCPRCMOtHMyNsFOveW0pSUHAcc8F5hxKlyH47NpiG6QA2pQuq2TYBVltF22zkbVC9vKLtZ6n1BzryF6MRLAdxH3RtJ8EUEenJze/7owS6gr7mIxLKWfCUaxrfG93sWn5zjUsegq9OQgzund+UKGMjwSW/6/GXv9KeG8LwOlugYLItCJXppTuqDl5wAnXYZha6UKZ1XsMKwtqi5UXPkxEROV+4yBy/EVZe6qBPVCgFB2G5NesCI0qaexdZU/nC5Donkyvnf2Tt41q3w1D9BImUH++a8TFaXLV6+GucSnasNuPRGkQpqTD1k/W6a5uT4ARva0K4NZJ8i8q5kgbwNqJQ1qeU+4fAJa2Of3Pe6rgr/HoYQXIGIv/GUgpmO5zKa59z7yLU+35WChs4s0Y/zyIQmJVpkKbZoDf44+TEzubQEPN0pOAU9SpVf6Y73HfQ3acP0Qux8MCUVoppOx/SkBN+50dVA64x6Y8AP7sJSuo+pQ6504utnQ+gfQlUq+3Pi6eCCMRbtFH26qhvbkcGF9ndQ0oVme6B9XeZvE0OHWK2F0JPDPug7TTD+QBMcZnBirD1RwiqJy2Jd6pVIv9Mn0ESPzsdrBda06kw7M9oyCwSWCyZcefrev7gN/zXc98RZFgnBsCh9BJXEBFg08cvD7CfRxBNg5TkwSGgsZp0cHuKmr6qSGdl1a8NmVJXhzF+WRpcx1/yxivnz3zaesh8Uncjmi99943glyFFCPetJLYR+EyiV0Sg9yoHjLNfcBX8ybiO0ZpFVLIfC8ASw4HAiQVWHkJXmFsIagpNIqsMqV4xyRgs0CnPat6gUeCR5JiIKbtoOMp6jZwMVv1FRTrLIPoBJst3d9OPdyuLwZGdSa48InpX7LjvaisXaUL0XTvgP2aDLYySXViibJwwDQb3lxX5l97pP4W/Aipl35jxK6LBNDUxzaneH3Q2dx6
 znKYY3ov
 Lf3XkSQ05y1SENoYh6r6/hRIbrvp5o9eJr0sS9c2LhiqZQe7mkO3Gdj2uFfOg36W+MaUoPkzCCfB9XQJNsqInQLziSCXaWduZP7Kw2cizmxxfQOGYSKdq/vPeLQ50gQdC4DodRUeO/pHvLUfb2Fj1w1G90QVsC9B1Zhkmz7VH3magkbnBE52Q1jeojFsE+pWFhn2LWIUNxAm88JGlmgOUqVJN2XzBubVK8obI3+DL5fkTc90lN386Hfp2jnhZh+GsJZlrv4//kfTs7zdCWxk1VGV17dqKMIgx1OvZHWDTDvchAvlpZp3NzI3VEzT2S9b6W2HPRJJfU6aWJzegAI5rumFv2OvuUvUNbZX0Fi1fRLaQyDnN2n4wwzNUT7DsIdhUOwNamXp/7jiQ3IV51x94IIZKYq9hycQOLZLJP1852oMh3yxTmdn05aoVia+wvHd/HUXu5+hKRSOpJlZ4y2qFshdytZVuY3498DimQEjkzXI9fKo7J4yMDzjmrdn5pJYuIG9MoEi4FK2gsSAzXP0JG0QDtsPiocdWHL+ct6vncy0kWqgbxXfhIKdq9h63YBrWNaWzof074iNe6MO7+v3TaKK6XQ9e0eLCICP9+VAtpjGbuPjFp3n2rp/pyIQRqgm22l3c1Kc25lrYf+NvRcAc/KGZdGyynkUvOSJ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 10:59:29AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/21/25 13:34, Vernon Yang wrote:
> > On Sun, Dec 21, 2025 at 10:24:11AM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/21/25 05:25, Vernon Yang wrote:
> > > > On Sun, Dec 21, 2025 at 02:10:44AM +0000, Wei Yang wrote:
> > > > > On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > > On 12/19/25 06:29, Vernon Yang wrote:
> > > > > > > On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > > > > On 12/15/25 10:04, Vernon Yang wrote:
> > > > > > > > > For example, create three task: hot1 -> cold -> hot2. After all three
> > > > > > > > > task are created, each allocate memory 128MB. the hot1/hot2 task
> > > > > > > > > continuously access 128 MB memory, while the cold task only accesses
> > > > > > > > > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> > > > > > > > > still prioritizes scanning the cold task and only scans the hot2 task
> > > > > > > > > after completing the scan of the cold task.
> > > > > > > > >
> > > > > > > > > So if the user has explicitly informed us via MADV_COLD/FREE that this
> > > > > > > > > memory is cold or will be freed, it is appropriate for khugepaged to
> > > > > > > > > scan it only at the latest possible moment, thereby avoiding unnecessary
> > > > > > > > > scan and collapse operations to reducing CPU wastage.
> > > > > > > > >
> > > > > > > > > Here are the performance test results:
> > > > > > > > > (Throughput bigger is better, other smaller is better)
> > > > > > > > >
> > > > > > > > > Testing on x86_64 machine:
> > > > > > > > >
> > > > > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > > > > |---------------------|---------------|---------------|---------|
> > > > > > > > > | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
> > > > > > > > > | cycles per access   |  4.91         |  2.07         | -57.84% |
> > > > > > > > > | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
> > > > > > > > > | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
> > > > > > > > >
> > > > > > > > > Testing on qemu-system-x86_64 -enable-kvm:
> > > > > > > > >
> > > > > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > > > > |---------------------|---------------|---------------|---------|
> > > > > > > > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > > > > > > > > | cycles per access   |  7.23         |  2.12         | -70.68% |
> > > > > > > > > | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
> > > > > > > > > | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
> > > > > > > >
> > > > > > > > Again, I also don't like that because you make assumptions on a full process
> > > > > > > > based on some part of it's address space.
> > > > > > > >
> > > > > > > > E.g., if a library issues a MADV_COLD on some part of the memory the library
> > > > > > > > manages, why should the remaining part of the process suffer as well?
> > > > > > >
> > > > > > > Yes, you make a good point, thanks!
> > > > > > >
> > > > > > > > This seems to be an heuristic focused on some specific workloads, no?
> > > > > > >
> > > > > > > Right.
> > > > > > >
> > > > > > > Could we use the VM_NOHUGEPAGE flag to indicate that this region should
> > > > > > > not be collapsed, so that khugepaged can simply skip this VMA during
> > > > > > > scanning? This way, it won't affect the remaining part of the task's
> > > > > > > memory regions.
> > > > > >
> > > > > > I thought we would skip these regions already properly in khugeapged, or
> > > > > > maybe I misunderstood your question.
> > > > > >
> > > > >
> > > > > I think we should, but seems we didn't do this for anonymous memory during
> > > > > khugepaged.
> > > > >
> > > > > We check the vma with thp_vma_allowable_order() during scan.
> > > > >
> > > > >     * For anonymous memory during khugepaged, if we always enable 2M collapse,
> > > > >       we will scan this vma. Even VM_NOHUGEPAGE is set.
> > > > >
> > > > >     * For other cases, it looks good since __thp_vma_allowable_order() will skip
> > > > >       this vma with vma_thp_disabled().
> > > >
> > > > Hi David, Wei,
> > > >
> > > > The khugepaged has already checked the VM_NOHUGEPAGE flag for anonymous
> > > > memory during scan, as below:
> > > >
> > > > khugepaged_scan_mm_slot()
> > > >       thp_vma_allowable_order()
> > > >           thp_vma_allowable_orders()
> > > >               __thp_vma_allowable_orders()
> > > >                   vma_thp_disabled() {
> > > >                        if (vm_flags & VM_NOHUGEPAGE)
> > > >                            return true;
> > > >                   }
> > > >
> > > > REAL ISSUE: when madvise(MADV_COLD)，not set VM_NOHUGEPAGE flag to vma,
> > > > so the khugepaged will continue scan this vma.
> > > >
> > > > I set VM_NOHUGEPAGE flag to vma when madvise(MADV_COLD), the test has
> > > > been successful. I will send it in the next version.
> > >
> > > No we must not do that. That's a user-space visible change. :/
> >
> > David, what good ideas do you have to achieve this goal? let me know
> > please, thank!
>
> Your idea would be to skip a VMA when we issues madvise(MADV_COLD).
>
> That sounds like yet another heuristic that can easily be wrong? :/
>
> In particular, imagine if the VMA is much larger than the madvise'd region
> (other parts used for something else) or if the previously cold memory area
> is used for something that is now hot.
>
> With memory allocators that manage most of the memory in a single large VMA,
> it's rather easy to see how such a heuristic would be bad, no?

Thanks for your explain, but I current approach is as follows, the large
VMA will split at this case.

madvise_vma_behavior
    madvise_cold
    madvise_update_vma

Maybe I'll send v2 first, and we'll discuss it more clearly :)

--
Merry Christmas,
Vernon

