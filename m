Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C1DC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914CD6B08F2; Tue, 18 Aug 2026 03:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5276B08F4; Tue, 18 Aug 2026 03:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3D06B08F5; Tue, 18 Aug 2026 03:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53B526B08F2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:42:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFF5C1C1D3E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:42:18 +0000 (UTC)
X-FDA: 85113597156.18.2E2A5DC
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id EA42240002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:42:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SlckDBzN;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787038937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kxhoXQ3JMlTJinzz2e3MZXls2upTKaBok9FISR0LnA=;
	b=2pRX9vHV5JKZpy+/pMyD6g+CwpWCSNBztAdi6hwkZxoI6TTDNDCg9KBAqRDQevPu0jWN8c
	LUEhJQyKkCwdxMd+wt+QrUR7Uc7057XsjYPFYkuDT1HFiONO9nZEifbFJkxF15GU6/UsIx
	LzhOTmXWLCiGLBcdCSyBIFBziUD+D5Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SlckDBzN;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787038937;
	b=cKnq+WMvg+F5vZtEg75Q0W7M6ROMHd50heGnoReaWd+B25SETm1zNGeYIjZujieY4bpSae
	lf1Lo151/w2AVXjnkMfxsIocUysCX91d64vPI2VXZScA3Y54Z6AWULiT7fAtk+LT2cT5O+
	uYxlIVZliSn5BdzH55E3EoV4ef87bCI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso2351697f8f.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787038936; x=1787643736; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8kxhoXQ3JMlTJinzz2e3MZXls2upTKaBok9FISR0LnA=;
        b=SlckDBzNpLRbxx4by32vP5+CeLExsSfNURy/bOQFH9fQdLxz55kxLJY+nXJKndwrvM
         SFdqyPYcChPsp2SHwCL9sVeX5UaikKF6guB/nRvkKxVjjCHGwiU2WcGG4JeSCjTNDd4J
         uDti+zrxCwCqyyoVbkrcC2x9K7CrgVMCe/isps4URR53M/wJTk4RH1p8K23GJc6Y8pgn
         v2JkslFaGzElfMyPiPihynVJgQ50fXsxwotEMez5NhhSwroyvmDLZWFDqK408mOliopf
         Me9ISAGhge3j97zX4gmaj5xqnpFXMC+dXZTzLH8eoITa//D++UpkGFce/l+f0B+Rxgt2
         UdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787038936; x=1787643736;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8kxhoXQ3JMlTJinzz2e3MZXls2upTKaBok9FISR0LnA=;
        b=efAe+jnXmhFYMgFar0cNH0H7Vk9IrXQEIZiLIPLgut63sUj19Jo1BuggNwO3xvw6Ru
         kHGjAlCbT5ZFkSMs/zVhhYMprBcVs/2z+0wtWZUFZpIcGRhcvyvyMHLB85kZtEv8DB0m
         X8Zy4WMontuVdM5JSXOLRmQ/i70VcAHB3lb4h5OzBgPIXGhzSIVi9HHDlYO0RQMl7Dfa
         apoRCGjGnToguBfA5PGK+jGTPlwt7myJmA6ARFk+NMtdnOh6C1SgnHNOn7z6iHeetzRw
         YgqLHqgwH0TxvLAqvYAAnPXLer2mv+ItbpfpnHUR0aOkh9VqWoDev10So0vcPXyow5j6
         hlPA==
X-Forwarded-Encrypted: i=1; AHgh+RoZnFCBJhLtIcpusMjR53rPX34v7yhQIXPBKRWbpP8kCPnZc4sWwDt9no5+K31D0AaXI4SD7YM1mA==@kvack.org
X-Gm-Message-State: AOJu0YxHbmmtBXQIzgL3Jm5e7uzgvmUrWNEnmGGP5xQFgO5tnyn9SOXl
	sBUdvBZbcQXAJGabNvyJWAttY0bGkSGB8+Lu7EIlcuN7HtBoXBIZV8VOMxYkEu+OxZ8=
X-Gm-Gg: AR+sD10LlLScM2bdpehZg8G7ifhQUsE/3l/7xYETblKDcW0Jg1tDiAQpykvRGZIzryF
	6EabPWzumIeBBojVkGKxOmM5Nwb9Ot5qBAf7UFVFGLOOc94EKqabICTwTGnKCrHFlFtHERlCig/
	8RiXI4JnSPpNvCQvm6avro6baWlVi2LgLnr+77XeuA1929AiP9jtUpxb9FS7HBGG6lhZGD+Slcr
	cTywgevIrS+kBr0nkP6o0qP+U0pyCP9kd/pV+0RSKFj5s/wuJiI0hcs0j7KXZhVULqGFDeduAwd
	vKoHlhc/BBpssQ+rT6Sb6soRsrurqdN6hAofL6540zNWmxrj9FvecXxVBr0MdfSDqXqPaUmp2Vc
	5nG1T1o7uEy28ECH9QZ78kyxJVq4fpnM54KRiDGz2LZaJKiH1dNDKt//trpdaUXOrFNZ3p3dtYw
	6tYd5yfkKa60vnvaV3Igl5dZChpO2H5W5rqeM6WMUvv+h4izs9UBK02MPv3ZMbngsoErYd6KI=
X-Received: by 2002:a05:6000:40de:b0:47f:83ee:e56f with SMTP id ffacd0b85a97d-48160748fb9mr49670647f8f.18.1787038935656;
        Tue, 18 Aug 2026 00:42:15 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b81748sm9986909f8f.37.2026.08.18.00.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:42:15 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:42:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: shakeel.butt@linux.dev, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	muchun.song@linux.dev, roman.gushchin@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	kernel-team@meta.com, kernel test robot <yi1.lai@intel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid false sharing between vmstats and
 events
Message-ID: <aoQM1i39pGKh_0Fk@tiehlicka>
References: <20260817103835.2937733-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817103835.2937733-1-usama.arif@linux.dev>
X-Stat-Signature: mn14uymeahc3cya1gj7bns1zmhoq83do
X-Rspamd-Queue-Id: EA42240002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787038936-212425
X-HE-Meta: U2FsdGVkX18DTA+eGtLF6UAYR0qJlr7W0QLNeE2NfneF53RGusIERv1DJnH4baMERvE0ihdx1cghz3iP5pHckeTsZk1QuKB2qF12BN9vsEUmtMzk3T17wr882pwKuG6yZB7CKelgAZhLiOUfzKO/pmGr2LaLwIsczGi3nbQeykuWYUViVkksoTao62XMhmniO91O4Mftlt9//QJBRJeT4qj8IMirt/7eiSI+RAKqkT7rtXKzbsdrXi3qnKIbIwaI85/n8jvdmWbX+bkED3+6po5b2Ap0c9g1lMAS00nCHNIv7LZf5jDS2/nmf6r7iN6/jjZw7J5rxHmIzUFAE5DSyFdNSu4HgMROyr+uayZyQQr0ptHbjVcguS9Fa0vjrbbI8DL39MybcVGXqG09tr96EePZGuuxVjG1lh5U7SvSLt8dEZkEhI9yBN0v5Sosztq3q5L5A2sNaaK7EpDnB2xTgji7+/1yJYaRiJ1fI39MPIhFIISe94srOoVQNjazMYeOZB83R+6bK6qmX+D7MqeG/lGWcrwbARxt7eC+XKOAhRXI35Nx121RvdfPNGgpyQH5FMuH3epgyCJEUY/zXQSUjAiBDgSvof7eXlpwRq+wBDPyFdDo8fDMuSFJp0B0LtUQ+VD7ku1IQCEXa8oU5ImBlaBh1Y+p6HuhDMmFZIUyaSWQUv0j73yxxi2GXp57rxFyiWd5pEdKpvZWVH6/7wKhj8hq+UZETHWEVJKNb4xcbeY+fjXUbid97Q4HKycph0b/CDIUjTq3Lzdube7FiUmFHlXlWI0mrY0AEpk5vd3H68mfyADpT/3ZAK5UpVPzsQK9h5a+qLgsR4UBDc22FmQAjffaidkPNcZ+QBTX+wFXA+S7LC0eo103xoQBziE5ORwoMRNZlZ6VHoIVGBz1bHq+3FkOc2PfBB8FP8XPAMpOpKRqKMqYpl1OnINaCTkiu0Hzr6HX+ktQo6coCvaHhzJ
 VEAfYyiP
 WI+S25Jw8/NonTljYDXSbcy6uOx0oTRSgHrbK9gZVut8VGaE0YFw/j1f5QcWvFOuSwX9EYqv5t3OVlXErQxDm7wOtyZiAJXFSbAZsR8CgzqixeLsANI3A2Kbo16ggEmcvN4LEzXH6Lz9D85/RFQ5noTMQnrS+sl9CVHc2wRX4Zi1P6uJHN5ybXBBcCslotzV8/S3ekyxHA4xQsLBlqq7f61G38L70KoJ6jFe4P7nVGql66qurZkawiCIGDPR/N31M6SMODxW6VRaDFTdU8V2mF8tsRgf7EHgTz2m7Ms2iKZG30N+9yBrifHDS/xPuu7QuOLQNiiEDfPu0S3BI4etnuDf4CjUXPoVhugNM1iSvNbJAa5+TgYTpD3iSrAihotz9vEnO8V9/3825NPr4ds8pFzXgQ0njZGCIMBjWh6pGQ1L7OVe1nr0xAZmvlFwTy5AIDXhYS+WInPf6H7T+chgutC5KJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 03:38:35, Usama Arif wrote:
> Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> vmstats_percpu pointer onto the same cacheline.
> 
> The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> 60-second run on a 176-CPU test system.  Those writes bounce the line
> while memcg statistics paths load vmstats_percpu.
> 
> Move cgwb_list into the existing alignment gap and cacheline-align
> vmstats_percpu.  This separates the pointer from the event counters
> without increasing the size of struct mem_cgroup in the tested
> configuration.
> 
> The blamed commit reduced median mremap throughput by 4.38% on the
> test system with one socket. The patched kernel brings the performance
> to within 0.5% of the parent which is within the observed boot-to-boot
> spread (up to 1.2%).
> 
> Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> Reported-by: kernel test robot <yi1.lai@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229b..215e2e87f42b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -268,10 +268,15 @@ struct mem_cgroup {
>  #endif
>  	int kmemcg_id;
>  
> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;
> +#endif
> +
> +	/* Keep the hot per-CPU stats pointer away from memory event counters. */
> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu
> +		____cacheline_aligned_in_smp;
> +
> +#ifdef CONFIG_CGROUP_WRITEBACK
>  	struct wb_domain cgwb_domain;
>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

