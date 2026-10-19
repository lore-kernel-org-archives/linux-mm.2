Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63930606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=MvZBt1s5
Received: by kanga.kvack.org (Postfix)
	id 7741C6B0370; Mon, 19 Oct 2026 16:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B896B0371; Mon, 19 Oct 2026 16:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661C86B0372; Mon, 19 Oct 2026 16:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486C76B0370
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:16:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C8E240802
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:16:51 +0000 (UTC)
X-FDA: 85340484222.30.9AA1056
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64F30A0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:16:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MvZBt1s5;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792441009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRFDv/zqlCdXHbrIMKFJTczyEyv3i5WFE2Tuk2/B3PI=;
	b=gt82MX/Yf+lLtvt5nIY0rLXuJZJRnJGUwD6kEp8sGtNrwYiX1egsu6Fy5M5nnmsyguWs/O
	JhRfNjysq2bsuOEThbO0lXE1/1LHZMhqS5LbibEF8OV39o9kKK/nPUh532aiftS8JoJph0
	5fhDV2/CWYMHC++FwbPsm/KxIAch8WM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MvZBt1s5;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792441009;
	b=oCagkW2CrGxAI7o/Ln5Dzb7PCYCaxsU9BPkjfNOYWMX+Y73SqvxjnAzOU5kflen9pCtKBl
	hAxADB7Pf/S7ybhTwG8p688n5fa93FtEqN2oF8yHgLDFLhGluvjm+ezIHGsnkAgjVnKgm1
	ubEWoN5wpVcMVwzvx2mQi7Lvk2UDt/s=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6740e7ae219so2104828d50.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792441008; x=1793045808; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cRFDv/zqlCdXHbrIMKFJTczyEyv3i5WFE2Tuk2/B3PI=;
        b=MvZBt1s5JL82vGihg+AKuPkUeBCaGpwUCml7BPMhjQlmROMgKHxXxG1cpNc8p4LZyX
         4A0woyoPv/kGRTyvv7hx15lM1K9h0j+efkUTeWmJhGqplryL8h6f4KDOtafx8qNJ2MlX
         8D+F5macm+fKE+KcrIv66MdIg45ri/fQUwEacL2n1g2g1AhvpJOvmBJowAa/ZDDRqJl4
         GDSrk1uYZf6NL4r4RFsozjmKLiJsvma5KBqKR/O7NusGbyPX7ub6HPgb3PMeiX/xJpnB
         KgvPvpblcFxkWv/VShdNd1g1/+/QE9HPtyGGTOEaxVwEpZd9VRl0pV3odBDJ2/qkktwJ
         Uj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792441008; x=1793045808;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cRFDv/zqlCdXHbrIMKFJTczyEyv3i5WFE2Tuk2/B3PI=;
        b=KLrkK4JYf1xYtspmjSchxt96ehfE5PwpYwjVGiTRGgVzf0V5Ty6NvqNDTVvZrCpwgP
         HKvhJiVxfLVBwjoB7K8yj/vcXzy845NtzuueXlIDnSg+6HheM4F9iBOuQPQFpmizUdKh
         cKSialmufFaVi/Ep74IqG53YeBkDh43wJ/4FfQzpnEYGZFm/bBEw4ocYgoNIwW5hOphW
         cIsrgcw4fo80pVrw52e834s/CagGzXoSH6ZZxsquJbGXVIYG96geuoCCJghJIyhJ/U0m
         wbguFPIhm5GiOP9fFEDg7pQtDpRhxh/ezzsmSNGIBsv/vn4YagW7dkswRswE9SyHTvte
         GrTA==
X-Gm-Message-State: AFq9FYL7blF7wCEHAV5O9sV9dmIULHVpXYxDvQPRId4hY9s4u1zV668L
	KgyH++naWC9zsb6sRcqU+rzP2Wfu3Jb+FFZcMbfb7ryLzIujuIW7Mtzr97nMlF5Kgjs=
X-Gm-Gg: AYBFou0JlnqmOBklM/fDZPy2I43c98c93yvYV4BGvfkj3NRPtg+AQDuhYsmE+OUqaoH
	7pWTQJVdDaZR3VogMHSb95XEZTvlHck5km3k6xp/xAcK3KLTOY+e1a42ghcfx5DAAA9o7WQFPzl
	IXgdxstWoJyhzAULLDbMijOwQCWkABgPZyS/8JNnXzAw7UN3CZmoUE89oftHIJOmMwrOHZUeY1b
	k+STQx7IajiBJ9itnMzYnxQPqEdmP6g6tcL5qhKjx8r6PTWfxuy/kKOtT45UGE5qC+1t3xBP9OR
	FNi+1vh14Leibuoj062Dk8wr/7o60OxzxogWBBrPICmOrLzoGc8bgB3vBF3nalkbAZB8fYWJner
	Xl/GZGiK3QzZDCqtPhA9vHHoHOMQ36lQn2AgcrtfUl3CYBX4MXqE3BSetxABHyOUlCqWkgS4M42
	b9djyWGOUcTtXFEex3Eh1Hhpcp+7PTB39M0cgnidDbHFD/bAZCRNYh4wQis8nwQtI2+CI9yQ==
X-Received: by 2002:a05:690e:1381:b0:679:9b34:a2d0 with SMTP id 956f58d0204a3-679ca54fef6mr2000528d50.18.1792441008370;
        Mon, 19 Oct 2026 13:16:48 -0700 (PDT)
Received: from localhost ([2605:8600:200:1d58:2ffc:79a5:7374:fa95])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-679b19c3933sm4507704d50.0.2026.10.19.13.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 13:16:47 -0700 (PDT)
Date: Mon, 19 Oct 2026 22:16:45 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, david@kernel.org, mhocko@kernel.org,
	ljs@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <20261019201645.GK371161@cmpxchg.org>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Queue-Id: 64F30A0007
X-Rspam-User: 
X-Stat-Signature: 1y6kyxiwph78b7usxm4zjimmhy9xi3wg
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792441009-53799
X-HE-Meta: U2FsdGVkX1/gNfWiXDyArZBpO0LRil4cG4UZzOQt1aZUzPoUS7QZ5swhc6w11mA4qaoiGsejp2FA5zcvFuWXgsI7spLBZKIO2/HTtjZqdSAAKju+dTiVNdXa14Y5Dwg0dc18l+NwSQQrkIULvWrDVpmQBI+nGVh1H7G8zgj2Q3rLzZfhwjHrppXAmrdqyDRSKNt8lVyMlu+dSWNl4WNJ/SsicMQmML4DKQik5vUXF9ILHn/wWXH4x0Q7QgcF5AhikSRGe7rpScYDp7Y311MiaGJpySeZslA0D7NA3l6uHMg4CfhpqCwCgdhTrUoOJT2Y2VQMajg7c2C6YjmebxBnpt60GeQCinsMmtU21LHtKmKgf04zy3pg82kB5IhxSIVya7CbXMouR+2hGqM5mok5hAdLTlruoSvIzzSWhcizLcd/uJ3BbXwi7fIM/Qjcy8W9s6NLgiKbyXUNomXint+G79hI20b++PJmk0WIws+BUyr0L7wbF6utrHdAFQNzvqmzFNR1E0U85DvbCxXBHthq8tvgbhTecdmO30XmZhX7WPsqerzjQIzbEDj7XZ2NHP7mwW9dbcm/BE7cnPMNbXOL2ofMB67JNy/BGOgyruTpAhWON1HwN8o7ajq8FMU47bf1uJWPWSMGDONpGXrGIYWZ+bmNY4MnjxMB+aegfV3moUAsqaybevm3Qh/Oyla5R0RdzY41pmmb5DfWj9OU33/GwvnpRwrOhAVDHn927GgOf02lY7hQ47F2PQMZn0r8nDazTXchcU9GqTuDuBWsFW2T4zmFr2UgRBrLKsGz4pccgM/3mya9RGZHcLN4Zn9cU/icsCBlvhc0jD0XJ+fGtWkg+CYZNlGA+u76keZ7Jgb46Q4fSiz4L64GawQpMYWLI32DfDwVORlVg1+P76smpgLVKylCPGPxkmo+R/8scAGPrx+S0RnHGG6ZgPT2rIFWgoiy4mv3on3PApnrqOdEQlu
 XdyfOoas
 EINschUsgT+xPbyfcLByr0/PA60tBoAiGqxU/s5X0JV774/s7XLG301ahuvuhgSdCHtC3RAnjo5aF4AhBWQEk9UVL2e8GbbQ8ZnERVNH+Qlx1ffDAdDN0QXD+3af3xhcgzSD5Osx1joP4KsfjFK1BOOebdtSzfNEx45qG+qG7c1izj7/F2uBbnaj3kcBU17gfBgAE63LXQGdC+PcydXm2HDlfR3zU6O9vIMt+4rw3KYLuwHO/3KrhjvIUGWE3TPiLcz0hvGJrWa0fsewM9aE56g143vCh4QU6eqP9Wd4tGRcH23f/sViqhUX1lyuwLl/EUJxJLoasvc+OfU6yhxctrePz1SFIOu7nZBfhx4aiHhHNAUhIBRF7gl2pzgTmuW+1vtV+AvvAh/KHUg53eYW8GuhMGFaT1UH6pdFO+WmXiZwBy9LZDh/vHbRBzd1lkFd+bKO7CFTbf2hHW8jZXELv9L+xeEXw/NTEmxwBR9fabIVQO0IIg/rh5bXwOVsHCI+1VVzh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

