Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E9B106ACC9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1DB6B0005; Thu, 12 Mar 2026 12:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954936B0089; Thu, 12 Mar 2026 12:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860B16B008A; Thu, 12 Mar 2026 12:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75CAA6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:12:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2711A1B7175
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:12:41 +0000 (UTC)
X-FDA: 84537904122.01.8DE246A
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4C1BB1C000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:12:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rrfspwmU;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773331959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9REPqpkPd4ZOpUT732fDGd7EIcOVaG5zQj2KdASHAk=;
	b=4w50oBLIqL2+hnngtqRSfRHr8RoEmOqCCQ0TtcRiRUqQYvx4ioCCglGxM2B/IpK/pb9PJK
	CDvXVQnSQVpsb6toIeP4D4QFg+JhJKYTuTnSWMA5hKfpLAtBGyIxWEYcEMv4OQV67+7tJi
	ex6nIwC6gO7n7r7KxGyTgueBgvKIrqw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rrfspwmU;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773331959; a=rsa-sha256;
	cv=none;
	b=wxk1SLdEXafF/EtCA5bDzLf9mHjdYdOh0pFe5RJVbDz5gWPQ2jPtenXIb+OFAm4aX8yXon
	2Zadatg/VNzfNqNEHQ+ROylIDpRqEtj4jhnAEMnt2Us4t7VH7gncTKtIVBt1h/7c5M9Epm
	gvpzMaRGHdADbBSNoS63MbTOLyYHJKc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50919fc3a14so13629121cf.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773331958; x=1773936758; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N9REPqpkPd4ZOpUT732fDGd7EIcOVaG5zQj2KdASHAk=;
        b=rrfspwmUf4h1I99R6DkV/I+stPMIxj/ALrW+2+/faEfZfEA9k/HoIAs8kka2R7+XBr
         V/Y4owXnDlZd3jDJDbWwc2g1uNvnNLZaqYQp+o7jiVFtrZ8J0jxB90z4ESRxfif5YIbF
         miU51x+Di3LvOc9GqZv9eOy92pgAKwuGTb7BSalrZRmnFHjBbFM0AAk1hzBM3lxi0BCk
         xLIeBKbSCRNSnYw6kBidtjBk0QoHHrzn3IxBmC1uA+LN0v/kUu5qFkwnsOObPCo1Xyyg
         mEwexDvVbsCAFzr8ZUCqtcTx4txtoibRfCQgoO3CwexCbUpBIl+j/PxuQ5lQpU6SxJY2
         RpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331958; x=1773936758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9REPqpkPd4ZOpUT732fDGd7EIcOVaG5zQj2KdASHAk=;
        b=GNvo+2lf9PQpqj+rQ/omcZExwlR45rnabBr/j6RDPvOOICHYJWmktIxG6NuPWLr3yB
         ciSmwZPNFiZLCMPvjnerAFlmNETVxzrPbFK/TpHicBIdNdXq9ZhBrHR8orAZ4QUBiZeu
         Gpk5qnM0r4bpH/usgtY6/1WA6SR3promtVXXFoBPeUJqZW68YX44vhbv7mCMOY3FlJqX
         AXbRLcuqpsinZiUJ/n0l3agPjmCVGTL6utLXHl8izHokZfoLe8VvQysfv8Gc9dWExsjP
         YoDo2go8xVRZqeGZh8WPufktJ6KFXJQJHgkuxNWpVis5fV0NBgz6V5MAR8Be+oguurBs
         icBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxp5jf2I88T7SwHBEacWI2Qh9nd43FMuJgWH0J/WxzXCPDGVMOoJWIi0hvL2O1gzby3qkfQO1+7g==@kvack.org
X-Gm-Message-State: AOJu0Yzs6rFNLFa94T5Jva5eE2rIApy9bbkHoq9xApMsswuWSCP3bWQk
	8yKXklXfpF+ZjnG7zXiFd+LyIdfgAQ452apbqKdjwlUPecC8H2IJel9sK0YSzbn5NGw=
X-Gm-Gg: ATEYQzwwynoewVybo+GXJn8EyKxuCnUk3luzTDUevztfgAel5fZBrZ9DPClu/2elQzv
	4VRyfuzgpl3TzxbZ9/VyIvyZk6nbbU6q4P1W5pPZ6ZHrWMgR7+22yI3yqS/RJ0XchGZJwB+no6P
	hU5GSOsSR42C+GwJB8DlfIc8hlT8m9MUajXHx0iTIl7sJtIX3eiW5MiLZaQM2it9+wI68WqWTZj
	L8NTLuo4qjn/aklDhSUuIa615pvRoJQxzVOGaLVW8eeGzjSRfsqXixWExs5+E0lUOQsFtKXgkXu
	7oX0RMDDGwTBwVB9mO4cRjxmkwSuR93Tk1puUGjV91nmmCjsY5Bf503KvudR2HG5igEplSJYf0r
	hV9ZcMTRyGY9nIArr1dLFTuHV/ZyAZVWSQ2OjmLfVdQ5DSRyvtwpbMnmYATFWoF2cPAyXkYNf+p
	eC2zh9b00ymCS8dqrkbJKK2s5Gf74rw0p+tAcmLffCZ5A3PgFq4P9V+C97x7xBlj28LjI9NlwtL
	+Ej+7VHMA==
X-Received: by 2002:ac8:5851:0:b0:509:5f4:4ea4 with SMTP id d75a77b69052e-50939f52461mr92570071cf.13.1773331958188;
        Thu, 12 Mar 2026 09:12:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50939e8e0ecsm35572931cf.5.2026.03.12.09.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:12:37 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:12:35 -0400
From: Gregory Price <gourry@gourry.net>
To: YeeLi <seven.yi.lee@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, dan.j.williams@intel.com,
	ying.huang@linux.alibaba.com, linux-mm@kvack.org,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	Jonathan.Cameron@huawei.com, linux-cxl@vger.kernel.org,
	dave.jiang@intel.com
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node
 bandwidth
Message-ID: <abLl84pc7tavuieW@gourry-fedora-PF4VCD3F>
References: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C1BB1C000D
X-Rspamd-Server: rspam08
X-Stat-Signature: 1fnzgimrfpj6jtq787o3y7xjfnsrqdey
X-HE-Tag: 1773331959-723183
X-HE-Meta: U2FsdGVkX18a9FNtOPls1+k403YYWcHSnDrgo6E/74GsWCt1sgGyVx7rw8uGUY2GXbr2CAf/TLyFuN3uuIw+qeSKhfQyEF1ANl647er4uuMLgj5TigsPhT3kmXo8jR7+9DChPbn7cV4q/twJhCdPFCK+lkmPNNGFYM95cY7jQv1ZhboqMq2sBJocFFroosLxqBxu0KCKWeX2D/plVYfUyWBsECx9V3KC21GzubLWAS5AU3hCwW8hN9FE1G1OcG1YIn11g4yp1SBsqOgO21IK1Wpy8RXk8GKx3QzDaigFty0bVxdt3fLNWNfNYY3JtBqS6O4srxhYILIrm8WA2xBjiwoyaIImRvpSjdpyl1t/eF/VcHg5DwtZH/DyY6BaE/c7a16Z+fe4e+wdmAT+eQRKD/1hOixlnTwpj3ORCaa64v2u/t8IaC/e3VTb6c7IsQgwSbV7G19drZp2ynCAxGCjzSf5ej86IGk8We2IgocW1tFNxPzNWT+cKzPw5WjU0msshvX8ICOQYDK2mb6/9e6GGEkjPgKHVF23DyxPbhf1VB7k1RGoSRAtVU0XpKHdhsSUg+IUr3+V5Qso60IsprOoOx6UAARUvmtgp9E7w82E3a3cw3RLMlVsADDR0KY2EKd9kdMxSRSNi89Xvdu1WNovyAFRTGj1blH5vM2tWkMpoAPOym7eONLo52HKpaaTC5vQs8152cEXY3qXirvc4/TUgiaYneW2ETirxY8A+v+zmUU+Q8jprKTrP8cQxEg1LU6Q64MjEfwMqHeFSdbYl7n+/dP40GfQOfY50GXov9qRJMzU6Aqxijeh2XUr/UKUBrnGQZsmFAnfJeVmAotwh29GC3zT5dQJBZ1gr0Ura56yaHI4xFBXjvKhb1voSPBaFtWO4Gk14XvrZDXScYL7vWK8xhUhUJNS9WubZSS5YGpAEyf/tyR+ODLN1Rh/p4IPbd41LKnAQZhitfyhG679GgB
 XiQO3bQb
 7p2hvCFfDLTyshKl+Po9+hAA7TVPixLpEvoBeW3/LRnO/6KOgQ79EmsjA53NjTK0RgqoDvtQEk5aS5V7PsxAxfHoODLbCKCqrjF577XsiGJXvqnBROR3d5ZHcTWYO3BNLSsYrgmvKVHCQB1pQ9wCfkn/WiEQ3Zl+UjXvZUDOESVgeUiFGVLU+d9mwpH+1KMie4ldI5IBSKmXOm5u+Sufl411WGXBYu5nNpal2EKPfwLCgUBMSaf2Y2DKJQU5um9w2hxERYlS1pXqY7fwPiTuKLd7/64xCSTPWo/3/Pbo9fHNG4piM1eWmaq6qpqpmAeZq4um/gLV2TDERvCUux//v+kdYYc/vLDacof+8ywQxOSMjb+XLTMbM9QnMdaA6YCxF3I2pIFDoNmltzx+/FxaJcEQVMeeSk1v5SaWdS2PTC2FieDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 05:12:07PM +0800, YeeLi wrote:
> From: yeeli <seven.yi.lee@gmail.com>
> 
> If the bandwidth reported by firmware or the device deviates from the
> actual measured bandwidth, administrators also lack a clear way to adjust
> the per-node weight values.
> 

If userland is setting the raw bandwidth stat, why can't they do a tiny
bit of math to figure out the preferred weighting and just write the
weights?

> 
> Userspace can write a single bandwidth value (in MB/s) to override both
> read_bandwidth and write_bandwidth for the corresponding NUMA node. The
> value is then propagated to the internal node_bw_table via
> mempolicy_set_node_perf().
> 
> This interface is intended for debugging and experimentation only.
> 

Should be posted as [RFC] then, I don't think we want this upstream.

~Gregory

