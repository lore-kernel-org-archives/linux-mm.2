Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9375BD2D103
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95D16B0089; Tue, 13 Jan 2026 08:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56316B008A; Tue, 13 Jan 2026 08:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42696B008C; Tue, 13 Jan 2026 08:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4FBB6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:41:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7056F559C0
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:41:01 +0000 (UTC)
X-FDA: 84327051522.18.BC71B69
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 42B39C0011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:40:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XyLN4rcM;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768311659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOqKXa6v4TuBaNjoDA47lyBnXhGd9ZScrVY1o+qPEe8=;
	b=iBQbREH9Fpe0bA/U8C4eBWHD2qBbgt4aZ7ggO1YEg6PF0KDor1R4hPDmwk+fqeVryl1Kt4
	an5MIEn9tC8HkO0LD9REFzbBIdRwbVREb4IH8HdI3B9QF7I7yMSNvSeGeAbtf8Dvjjnmf6
	y1HuZOnDChqP3LGLelHiUCSqoF2s5nU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XyLN4rcM;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768311659; a=rsa-sha256;
	cv=none;
	b=SQtTrXGCrm6tNUFh+LtGZZYejufX+8GBHgogPM3+aPqCrfveYL7X0LUZ9czFtIpTFMZPEJ
	Q7YW43QuoldDD0I8iQ/ZgxQd4bCiQUmDGTHL6fiqA1VG7y04FV76rHKanG+GXUT0u3fLdJ
	Z7iv7Ykzgcu0KKY2ptyCFzh63HwSwEg=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso69384975e9.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768311657; x=1768916457; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hOqKXa6v4TuBaNjoDA47lyBnXhGd9ZScrVY1o+qPEe8=;
        b=XyLN4rcMAtu9SoY05pN7SfcWJ9UBiZcCRp1HUFwCdYeHGZANmTXnRPLNATCf55K419
         ny2OXGrjMXAWCrcGzDCY1RP2tT58RAsB2lB+eSAuFaN+QywS9dnvZebVJHff8PFK+NJw
         JyRumsrHCiWidCmD/bxcgmw3bUgy+OMmosOdLTOUtQfOnGzH+DUnSXZJmAFUT9GZ/y29
         5oKlOxTC8rQ+CxHdHv86tyrXDu3Rjq+Myk4swDSF4/2BdM2qA9Kjf0HupB/CHPYGxLMM
         LYnBsW/98f3mdfk/AQUt+I5ZanbyHO7DGfJTjSwxzZ/2P/PQftd/6vaW7EGLMRTcdZ2K
         lYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768311657; x=1768916457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOqKXa6v4TuBaNjoDA47lyBnXhGd9ZScrVY1o+qPEe8=;
        b=QodELMW3k/sfqXuZBZDIbdHwGh625p7VJbzhOfpMhAKgNDBLm2y0TwCpwlQKgYmjpy
         v0yPn5lYVeN2h5XA6tbGuQw3kphyM4vaLUhtckkCmonzmaCESlRnoc5PDFGHzro+DJye
         6ZEcQIJlHrdlzoTx2Rorw74Kn3TFjMHgxNK+Edgh2BS0Zb2S0jdArlfxQ4o1MiVDiTpu
         j6JzN5URcdjaCjv73oN0WGfCTR7HsVVdwXA+EVR/VGtW+noPK6vDYILMK2jdkhxNx6ah
         pgfypU1fiXFNmVdxSdjVRdh7L+hwrWke+2+zWrwbDYsEJluRfYkgtqA+wThUyUTmwK6R
         DfCg==
X-Forwarded-Encrypted: i=1; AJvYcCVJBm9pC2t46TnPnGZzb6cs5F3AmIt9FQsD589wS2zFCDMygInSQuOvLSOHzbjw1K41jKPpXYvjjg==@kvack.org
X-Gm-Message-State: AOJu0YwfLGRVeZX1fdmlOujuZr0BmKlbVAzFVCnk8J7NHLW0Y6HNpLuM
	Cl+HejI4ooy90y+bDMLErmPRARglyImp2lLpkX46WWT4Pg1qrSIDeNINDeQuvOhYrwI=
X-Gm-Gg: AY/fxX4IiLMHN2e2+CQkAuPxihpy+t1QGoH2gbtp1AbomJNu+iyDncYQypvn9z/Nc3x
	KVfWXcJB3iLRUm13mTi9JqdKxCblPTulqtPRb6Tc+37oVqspLhWm89NCqJCpSh7jhfrayiyX4pa
	ORT8JKn5Eh0ktIGnospzC2Y9L+jkNYikyATbTgpm70uTj/cyyk9yL1r3RDe6TGwSWm8y7Yi4V0V
	QLi17v6WU2S1FuF36hExo+P1LSwc5TG+ETtvPa2T9eqSuEIp1g+Uiss67bIjdogStA4cgB2UZku
	/UnRLbP8jTrA60eczUkOepVsATfAMNDQjhfJ3TZpjTnW51Z1vDGzjCvFSgTa1Z8/6YPAK7xBViK
	XraF+miYIcDkmKi77KRYsQtSvmnC8WE+VLU4E0h2ZYRKXpxQ/gQsUQUZyTeNKpkTlD3UtRuV+QC
	a7yWeFB4r12S7YNNvAR3rX95fs
X-Google-Smtp-Source: AGHT+IF8cxzSR2U/aI/gpis3jn6E94G2h+DlhGUvJnL7EqPj7dinresMd7rQXy64ZZLM/dvYDYNI2g==
X-Received: by 2002:a05:600c:19cc:b0:47d:264e:b35a with SMTP id 5b1f17b1804b1-47d84b19f69mr245181875e9.13.1768311657513;
        Tue, 13 Jan 2026 05:40:57 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0daa78sm45085370f8f.6.2026.01.13.05.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 05:40:57 -0800 (PST)
Date: Tue, 13 Jan 2026 14:40:55 +0100
From: Michal Hocko <mhocko@suse.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aWZLZzo5Hb1aFZ0j@tiehlicka>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
 <20260113081453.8293-4-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113081453.8293-4-akinobu.mita@gmail.com>
X-Stat-Signature: e8bk6yu47o3y4hqqc3iqfukjg69cykdj
X-Rspam-User: 
X-Rspamd-Queue-Id: 42B39C0011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768311659-975187
X-HE-Meta: U2FsdGVkX1/xEi26zpatxC4CuIqKpRM5U5DBbzWrc0IjtnU78OJ3DKQQQz/LR/NJ9knmPgNG60HN2hC7UkZ/vw6OEQ2pXlqYkQqtQmbsbWps38wsJAVd8GisP3Azsn3F6Xwzzxu6UvELtuc4VT4vqlsxaUwPCzPqyL5NpsyynIv3p6gTu0kb/+y4k770/zjf+8/LK/8pPqQHiu6hfb81cb7xpdEYXpNolxQn03Aj4+x+S8TZAtY0Kw+cOx59vCw9futLaNYtOjQMrvKB5QOH6tZxwAFki0NYOBJLagY082iN+E9wUhXFPiTUXBafBhbZpq4qdqOD2Dd5MDIdnFLSAhb6As0HLa5Mn8dtHRq9tY5gxHKsqoyBWtyTLjRScLIQ4Xd8ekSi0Mmc8c3zLssznIFnDmECXs1Oz/gui8d9b6JpPqxC/jFKcKJv4e99C+vkXRwXuH5Ujbx8FqrtsTBIAB1zLGYrw+ShzjVLY0Rk1kVEMCn+Fieh5wwYjbA6Kd+0U/2/Tj/RIRGGUhqowVnEmZ4iKAn4TTnc3P/Lw8zNALFpbksYLPVxRvmJGnnq6LBVrq5uueuA7dFVSZcvD/W20Q/lGNRqPNDr4MZUsNmIPs2cgHuzMZgxNeeCU493PBtTfK8XtB9xfoc9FWO0y5iVqIpejM0nZmYf0bewDE1ojKY0xbTotqFaM6ftLTZxkDpRVkGuMsGHQubPQnBEPXOgMwt/DpOp1+PjwscahqI4VkSJQkAgr1NZzwc4QQE33YFMslJoMZKWwjbuQr0gy0aYwnRVJ31vDT2lmBELtMQQdComH92qAFrEFmDevY1+W5IA87J1BL6x81kK60OocH4adUlWsaajp6RbzwC8uajfkhdgkF3bh+Fwp6KvhLKPI5/zSolxRRYLplLQgUhhzUv4+kBmIQfcNPTcgQ01nBqiHmdWfkIBfSneeaz2S+6ESKgxLN7Lj2ZO1zMFTiRaiTJ
 77PePLKL
 Ef5TG+sgYyT/XOO4xdmUNceE2GSv4jmnEyL62426UCuLfqvYxut97n3yCr16L9d+rGY3jBtL1y0Vpy1CHp6RIcH3BGnGYTyZxPCJEpARG+WC9jE3OghjujN3vE8bGnL/5HvSrzOOTLwTKCTgaTDVIuxxACl852D/0IHxTyauYvwXKqD2iKZFq199BwzIFcrDYS9HOIGaXC4KdbKmXKFqQ3+iMDQntXFj0Uw4nkc/UX0+n3l5IGEWEGg55eD3Sl5iisOlfRWV811XgmaB571711Dm39rxcj+18U9igwcAxjQ6krNVRFwre9Pj9w2T3eVJoFqzwmz4IFa56zxZmwJmNR8z0gRVMRNQfdmJZ1fMid2xZs1HNs1+adIDYNNRT06hnwqT2KNVLDdTsemkKQi8qAJFUz7AXFM2VDKt91R2TRmjlipj3ZJv3E3TTmcvt4b6STGsV1xt0Ey78L38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-01-26 17:14:53, Akinobu Mita wrote:
> On systems with multiple memory-tiers consisting of DRAM and CXL memory,
> the OOM killer is not invoked properly.
> 
> Here's the command to reproduce:
> 
> $ sudo swapoff -a
> $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
>     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> 
> The memory usage is the number of workers specified with the --memrate
> option multiplied by the buffer size specified with the --memrate-bytes
> option, so please adjust it so that it exceeds the total size of the
> installed DRAM and CXL memory.
> 
> If swap is disabled, you can usually expect the OOM killer to terminate
> the stress-ng process when memory usage approaches the installed memory
> size.
> 
> However, if multiple memory-tiers exist (multiple
> /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
> /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
> invoked and the system will become inoperable, regardless of whether MGLRU
> is enabled or not.
> 
> This issue can be reproduced using NUMA emulation even on systems with
> only DRAM.  You can create two-fake memory-tiers by booting a single-node
> system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
> parameters.
> 
> The reason for this issue is that memory allocations do not directly
> trigger the oom-killer, assuming that if the target node has an underlying
> memory tier, it can always be reclaimed by demotion.

Why don't we fall back to no demotion mode in this case? I mean we have 
shrink_folio_list:
        if (!list_empty(&demote_folios)) {
                /* Folios which weren't demoted go back on @folio_list */
                list_splice_init(&demote_folios, folio_list);

                /*
                 * goto retry to reclaim the undemoted folios in folio_list if
                 * desired.
                 *
                 * Reclaiming directly from top tier nodes is not often desired
                 * due to it breaking the LRU ordering: in general memory
                 * should be reclaimed from lower tier nodes and demoted from
                 * top tier nodes.
                 *
                 * However, disabling reclaim from top tier nodes entirely
                 * would cause ooms in edge scenarios where lower tier memory
                 * is unreclaimable for whatever reason, eg memory being
                 * mlocked or too hot to reclaim. We can disable reclaim
                 * from top tier nodes in proactive reclaim though as that is
                 * not real memory pressure.
                 */
                if (!sc->proactive) {
                        do_demote_pass = false;
                        goto retry;
                }
        }

to handle this situation no?

-- 
Michal Hocko
SUSE Labs

