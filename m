Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF4EFCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436468E000C; Thu,  4 Sep 2025 10:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6518E0001; Thu,  4 Sep 2025 10:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D54B8E000C; Thu,  4 Sep 2025 10:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 177D38E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:36:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6963119703
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:36:33 +0000 (UTC)
X-FDA: 83851818666.19.979F160
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id C9C3B40014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:36:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GwNtuhBG;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756996591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIQwRZk2VPfvd/iUcuinyxmucS62sRPlVA1dcpF/8G8=;
	b=3MLuC6JSEd2m8F2TUooCZ3efucrosTwzRGoxNAxGbLlaYz7SpaG/BO5Cefinc2M1QeoerI
	P7iMCiccUzmud6Uj5csk9Gg0U6nBgc7v074VkhHlP//UwkbObRq6eDHpr4ffrTGmmkrhHE
	Fm7p1GxPMaZWTxktBdPaK3Z0U1e0OJQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GwNtuhBG;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756996591; a=rsa-sha256;
	cv=none;
	b=ByffftYl75dkP3FxYN3vw/JosERU2017a2SpcLDZEqf4N0FJH7TeiqvdNyGOcGu3SKfkwV
	Nr5jI349tMYDBKaWYjQcRfEnaJ3IesbhjOQktvo/WjEurqN0e3UkRZOsfEVDV0C0MTN9MF
	t+eoIX2rboBV7JA5bc0xfUT8jyoyY7c=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b83ae1734so7419985e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 07:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756996590; x=1757601390; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIQwRZk2VPfvd/iUcuinyxmucS62sRPlVA1dcpF/8G8=;
        b=GwNtuhBGx7+rDcGUm8Kmr4Hg8MuStupbHHre+repFgZV4FuAzrFNrpgq0Wx6ve7zYo
         by0R6l3Vug4C/ic1zG9Ni98RG3mhEhovzXHglr/dAaOKcQ5KKZWmeyuvAzBU/Y66HLaZ
         9NOUxS9kvVBSnBX/zCPOZpTrLuhcoVxr7fqDTBD3LvV2KavKN8HFW8aXtbSWyOXdESDh
         iBAh1Z5AB8aEPabHQW5ihsLppa1W1yob8iBP1qlE1HvBpV8umefWvJ6dvBvFb1rvyjCS
         QayN0A3vyyive7TVoRjbxrUOmJGiv1n+peywPyczrg+EqPUKL+LUDjKOonxUti9+SD+m
         Jjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756996590; x=1757601390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIQwRZk2VPfvd/iUcuinyxmucS62sRPlVA1dcpF/8G8=;
        b=pAT+pKfCILQaGsg0dxwnStMCAt6KcP+Nwo2yYPGW3aI4SoqYmCTWwfucPUydZxdGzu
         AdzRous7hvRKXCqGLPmUXnez03Y4Mu9OjCksEjlBdmOuX0h88AOTnR1mrZ3S412yIQE2
         DbFFT+F5FI03aJCWSd5FJtPt3Vst6KdTdgFhnDf8zWOd4A4SbTuOuxs+0qoUxTkDYbcQ
         kuZGnmD3mplUvkqAL5g7peafZthW3tBPepT+omOq4raNbLQd6Al/1MD9QwdnisTvygKZ
         9L+5/4vUeO4CrmJejGxndB0cblpgc0d2Ia/L4+Ov4VZ7pCHlNSMMv7P4AI8FM/6CTPlj
         ANrw==
X-Forwarded-Encrypted: i=1; AJvYcCXzM9/inMhjdIenWtEIgVR0dY6koJ/boWzE+MYLy0R9v4jiivKd85l7UcZWijQitn6AZGXm4LoTDw==@kvack.org
X-Gm-Message-State: AOJu0YwOtHPRMLvlLJUT5aw6cF9/orwteloVxPHGZdXkw+8gM83YZMXH
	5MYc+mWeZW2llvHSfCrkusWG3nkrQoEm5Vr3LM1a1tFJdzjszkGiBc0TmrS1Ka2VRJo=
X-Gm-Gg: ASbGncvlWmhNlH2Bmx0cMlcNZoklGol3GertGUNEadYQ8BxiTbGsc9IJ+Krq1VYFGWO
	QPQwaerqOPoOP6SIncGB4A/OB+ZAzwzj/ypOw3qSmzndnloxsvZkNd1xabhNQ6WGcjr2nRfDIHl
	MKgDcRMtke3/9tPTHHHVVUR2c242f7F2MPZaZwe05RuGkOXHxBAIlCMx3zEGl/Gv1uw2Laj4tf4
	hm+PqT0VWhxhO5Wr0Sd274+tPLJYv1J0eiCoNTKJ/sVIsvUcEkooSasjB8f4CWS7Jho6dhLEC2y
	q9uyVwJUUDTZz60Vqs/JHZlHqkoMKkzRZ+83jX6O6gFlX/cGN0OB/HW9eC3x0n+KQHq5TWy85z6
	nzYR+r5zI9O+ldkVwy6DKjldy3aTqaz/S
X-Google-Smtp-Source: AGHT+IFd+8904jJeQZ7ZT+1TdVsjHJHJ+UQbGYs2kdTBvSBP1B3zBpb43MzHBujWYaQRyPy2SI1UeQ==
X-Received: by 2002:a05:600c:a46:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-45b8558a78cmr188280785e9.17.1756996590062;
        Thu, 04 Sep 2025 07:36:30 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45dd296ed51sm25588385e9.3.2025.09.04.07.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 07:36:29 -0700 (PDT)
Date: Thu, 4 Sep 2025 16:36:28 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, rientjes@google.com,
	shakeel.butt@linux.dev, akpm@linux-foundation.org, david@redhat.com,
	ziy@nvidia.com, matthew.brost@intel.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aLmj7ObmiNQt_6RB@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <20250904142626.1146459-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904142626.1146459-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: 58k9kidku7kfst6dgbkxxyp71h33fjat
X-Rspam-User: 
X-Rspamd-Queue-Id: C9C3B40014
X-Rspamd-Server: rspam01
X-HE-Tag: 1756996591-876577
X-HE-Meta: U2FsdGVkX185HCiMWRHXbHN9Xj0u2brFzxGy/rmra6jC55LFBabnWkjG9Wp0OEW01BX2W6M8SQetoEP2ejBJBAo80xglTHJkrSZgPL0OZWtvkFHkiHHZvwZxSM+S5cQ2i293wgVoBMpQ+foiVEL/cbLEdurn0qBUsi//thdiO5qvh59GWREE8Q6qThdBKyOlt8TzGeccIqx14lpIveUhj2Y212bN5ca68cFXT/J/Nl7Y6xR2N9oG4YeZ1DCeSqT0X02GtgFrv9zTs8WgzEflLH2oq1SRC6YgOFJ4M4eiKvtAu9D3WYsRz8DffRuG9stpcV43nlOaIVLlg6tfgTGdyRQ6aMdCqGvhyztRpLrdfpTDfqofmOo4vec44dAShyEsqosZlbLVsAeYwwgEENSTvV8hosBZaFCQXv6G8ath9QePXtD53i1QTFaA1di3sP9yjWaBm/1Zd6GNeLT/IXul+1JrZWH3r/LHRCgjmLDgiVRSuaWVg+DBkcse2B0gaC4O28pRG29VNwIhwsJBvOAD1Bm5HwR1keBUtEaqBk0w0hdy2KCarl0uK08XMLklMQTkaAQjwW3hbeD0FQhenPBczFRpGSIayJDZyEWpzeOgs8O199UXt+yvEj4Dh0omd1+9Hi1V6L0RYMBJ3nEE2duQRx+ErvHagwDxo1Ls9vz6+OAeYbFupf/vvSkmaLA5pnyaRmGT41kdwbhxCrktvXtTC+8mb88zraiTrB+9cfFX7OuOeYalClZ0CW+DnfnSpRpmF7nC+D8KjoSSGrcz/KMzUGuGJ9kHxV0tZIXQjyqicQ0n045iGyqlg7nD30nw58yru+oBkAwrtvvAwrVVI8DU31TCtWziQD3/A42exbbkMBeN7800sDSeng9TALQqnE1NdmuEan989T2R9ox+BFCHHOBhG2mxu8oLpTFR1OM17NEt8ZXVAds0GJ+MedK/UPXg8nVySAaREuuUvS7xQi/
 QaT0x+MN
 ZumPpod0cridHqxgBzTYlP3ruw+gbwgtF2WMCUnls57JXq5D9UAMG+jH9E1coauqkFBfmk/d476k62I/ctNwT1fHZSmycFdx3WrmaQL40oW70LWKMQxxvr26wL1le3G+mpplhGAyKedMRqQErAuUeiV5ead3DkkrKRnjRFxI/uP6RQKcFV3ndgrH4p0Ll6Pktr0df+G5S9rQ4g100go9HnySSyiL2fKhf5B1tGAPK6IzYj0cNjWjQdORbXRr1Pai7NTO5ZTC1e7Sg+lmqMb/xJermyfwCVS3Jw6GxWrspm5V0tgIUakf6cWd/fzKuhlJPFEB18z9dPwqMNjFaDQnuN/FEPf072qcHC3WtZSyie3d8b99lwyFhRQ3XwAg7s5NZi2ftZHTiBpv3UbQ18s3jm1BYWYQwaNj1TFga
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-09-25 07:26:25, Joshua Hahn wrote:
> On Thu, 4 Sep 2025 21:44:31 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
> 
> Hello Jinjiang,
> 
> I hope you are doing well, thank you for this patchset!
> 
> > out_of_memory() selects tasks without considering mempolicy. Assuming a
> > cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> > allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> > low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> > tasks may be killed wrongly that don't occupy memory from this Node.
> 
> I am wondeirng whether you have seen this happen in practice, or if this is
> just based on inspecting the code. I have a feeling that the case you are
> concerned about may already be covered in select_bad_process.
> 
> out_of_memory(oc)
>     select_bad_process(oc)
>         oom_evaluate_task(p, oc)
> 	    oom_cpuset_eligible(task, oc)
> 	    
> 	        [...snip...]
> 
> 		for_each_thread(start, tsk) {
> 		    if (mask) {
> 		        ret = mempolicy_in_oom_domain(tsk, mask);
> 		    } else {
> 		        ret = cpuset_mems_allowed_intersects(current, tsk)
> 		    }
> 		}
> 
> While iterating through the list of candidate processes, we check whether
> oc->nodemask exists, and if not, we check if the nodemasks intersects. It seems
> like these are the two checks that you add in the helper function.
> 
> With that said, I might be missing something obvious -- please feel to
> correct me if I am misunderstanding your patch or if I'm missing something
> in the existing oom target selection : -)

The thing with mempolicy_in_oom_domain is that it doesn't really do what
you might be thinking it is doing ;) as it will true also for tasks
without any NUMA affinity because those intersect with the given mask by
definition as they can allocate from any node. So they are eligible and
that is what Jinjiang Tu is considered about I believe.

-- 
Michal Hocko
SUSE Labs

