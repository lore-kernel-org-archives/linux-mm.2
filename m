Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4D1C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D95F6B008A; Fri, 31 Jul 2026 14:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A046B0093; Fri, 31 Jul 2026 14:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1DE6B009E; Fri, 31 Jul 2026 14:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4716D6B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:40:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C61D01404D3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:40:43 +0000 (UTC)
X-FDA: 85049937966.14.F705763
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1171240010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:40:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T18aDV3m;
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785523242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ3Rb60doRZjVM3Yr3BNrWYoEOvjpyjvXsCIWVvxrw4=;
	b=R1Xq6GxoDbT6yTAZMSY84U3CFZYXR0dMzpyowbfTniE9FtG+lR6adkXkkT9+T0vRCYkyKt
	/JtCU78HXzLNXijhzSMKSC5Stu4tRDSr6K8b/CVnvDwdeKxoL4yO6+x5TyfsZx87YfHdkP
	Lsf3Qj3xb8Z/Bba3F98CkGVQPNrGIeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785523242;
	b=3R/MaLsnxqBDyGJPA7xB8NQt5t+zEW5p+rb4iNkdj/zWgFRLW/GfFDwDTC2iY9JcoRISta
	IDvxl5CRMwwUztc5MFPXBrjVGpFfVUIL1zbdAJCI45o9/L7GeRg/3wDrY4WtxrU+SYOnsB
	XLpOb5fNV8m3NFG0EHz+gu3yE7I3kg4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T18aDV3m;
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cf52d15d88so11356125ad.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785523241; x=1786128041; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XZ3Rb60doRZjVM3Yr3BNrWYoEOvjpyjvXsCIWVvxrw4=;
        b=T18aDV3m/Ow40etV4uwoxD/bPa/xywmlAI6uYDVjp4wdEth/hUa3KSlxAKXyUfPpJD
         zrml5/A16ecC+MCvDQsNLUDEujCyc65oVpp+IQARk6vy9iFT3xvIUyFyNJdZCLuDNxXV
         6VL7lfk6kGVWhcg601CYU2waHqLuaJnjW+qVfeNDE2tQ5dwhebVSZU7haQOuFTASf17D
         /UVHhXtqfr+siQZQPyJD8XNSX4XL5dPg/wNvjCfTgza6tv6dHqCfRtiisbmpvkETeEBr
         oCGsiOEQWSRJstgnv7xsRjuxaWsYby2FKxEq34uh8ejYBzNkT71/tb7JJLI1AOa1yqsR
         IWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785523241; x=1786128041;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZ3Rb60doRZjVM3Yr3BNrWYoEOvjpyjvXsCIWVvxrw4=;
        b=KnlXxkSMA+7zuc+WZ4TtZFJD9PiD/n5481DG1Ue406mxYkmaOM+hPLfD0GVnDXax+8
         eioltHTu8kV/aW8gX3KEhvha45PLGMVe2XruhiMEYQum03y3vBDnGbLkDdDJFA7yrj26
         VWllWeHVclaj0/U2ZBS0+3e1VGLIeSx4Ka2RV873pMNyAYsn7S9ckSOe5R0n3RsFrcwR
         BqKqmJDqQsE9m3syxG+5Cfxb7iwm7BqXoHPzJwPf4ApcO3XWaCiBTOHD7JdShSbQt6g5
         wPjSnd22vFagCYmX6EK4Eo7HX1Uq4rRrYypkIe8APdQz8vt4AM3H700KlfXo05acwMNv
         kOxw==
X-Forwarded-Encrypted: i=1; AHgh+RqUUq+75PuUmWVQuUnax6jr3sz1ZoUKBJ6CI9abAOMUGTn3MOIZztxS8hrubZij8147A06DjIOFTQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2HRRpkFtAuXCzaM7HNoUDDw/Ki/6VzKlv6GdSqcyp1SIAJJqu
	pmogvg63/1QZvqVY5yGJobiS8mIZ0zxG0k8nPxmAK3kPCNJQCSqr/T/9
X-Gm-Gg: AR+sD12WgZNFF/EW5hoUxvFkZKzoKOFRCGOev6lEXUS04CW5NHyBT8R4XWvhgdfmHFq
	u54qdUf9pGmAiAKia7ZDYScguayQcr9hfIGmx+LYEvwxpLcEnYhCuwW0MkbbOkCn3tpJdC86l+j
	vEZ8epGJPOhAaMM3nM+PVrq3RzXKISr8VgeP4pK4p/WtCeMADhhSVcTd6py3Cs32G4wnV36hhWQ
	TblWSCBlv7DQ5ze7D1m2Ll6VhIohLr7PSr4SRDHNJ+9gbbqXoaalRnoflz0ltRHFvj3++UF0CJ8
	oDAd93fWeUXUhDgKve7itqbuFWzicKvyCO2z2fHatuMIRENuTrQaMfDRCsw/kVXNG6WdxOwyCye
	NFiUEfmgaIJ8G99addYXrLvsJ0ycQXvtb0prEKts5ukG1uVsZiXN7uWvTpRjQbJlYUsTosUg9M4
	Y8pM5Kse1Y/V0uZj5T1hofKZpXexhaepVVp7DDdbKkfGtZu3z6QgZtacEhiPm5Qebt05nOt0V4r
	MoeW2u8GTSWaRxCt+O7J82nIqu3t20=
X-Received: by 2002:a17:903:11c3:b0:2ca:b48f:3395 with SMTP id d9443c01a7336-2d0523bf980mr8796925ad.34.1785523240828;
        Fri, 31 Jul 2026 11:40:40 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04aea2514sm9211335ad.37.2026.07.31.11.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 11:40:40 -0700 (PDT)
Date: Fri, 31 Jul 2026 11:40:38 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb
Message-ID: <amzsJg00NzGIxOxw@skinsburskii>
References: <202607312212.u1pPx1f6-lkp@intel.com>
 <20260731100547.57414d6c37e65f08eb52ef04@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731100547.57414d6c37e65f08eb52ef04@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1171240010
X-Stat-Signature: sxphhmn6rokqeydhwqggbnpx98bj74rd
X-Rspam-User: 
X-HE-Tag: 1785523241-503418
X-HE-Meta: U2FsdGVkX18lvB8NOXpvLon2sZb2FCO+UxBe8dz96GjVliN0m+lOb0fc7D+19cR4B2KT8mdzDmX9xBIpR17fSRKXQ9Ipun+5HMETWfHaAKvfTHlzlaXnbAvj93WLwswWL5VAUNg7FhKDwwnKV0lxtUtYFOOZ2OylsguElqQxzFJbINUqCDo2K0srZyvVzxUELauy4Fk9nnw5bT5nJczDHhYvmxAtf5lkV0f4fyTw8xp3kHojFcO4Ec9p3wDJ9MP0taz1Z8q0XZwG4CWgu9FC7wMEdZlJ7+4TII/230ROmWXzL+yyljl2GOP5YJ3Z6TqdMCKbL495KX3AWeseXH17BQImAZV0E9igSSfWR8dw2ehXgKqrwg0GutNk0ycD+4pazTcpqfm8dRimHz9uugdfgil475Xq8dHeTUGJrQwtPn/nf1o7Va6LTUaG98yn+rER9slq9nWL63dNKyqex3ZezvwErWm8h1ubT1zE6ImoeYOy+AOBRSYdVoaAxmNZ7Y6n88JnoEE02UoTnaAAuWr43ElCXN9ZCmraqiNjI0P9mdkK3+pL6KHuGCotwBgNcbe28UdVXTEG9WwKsOmvpg0jY1KpbrctCBTdw1NGunMN3iZX0yY26rwR3WIr6Yfdoes27msoxzmyiCtMK9wtHU14SBXc8p60RCC27uh3ZoRPvtEmXyHKEotjl12jrhj7PTaU6Z0CSUGXZAMhXuQjPokcJ2+NBC/gml8pUqU7hJktkIpOcQQheCSgzScPp1eVerLoQRv4xn1I8ohcWZzxglilV8JZmRwE6PiwaKZRwxgSUqOcBo2Ai3V4VBO+9cZsaZm6HDOm1EbxNvpoIYP0IV9HNwW7+ZuKTMDy1viTtK5jm92heG3vgt9xVcH5uL7IesD9X/isulHvTM9hlTDNx2MCbmokJHyuMRb5JTydwWoN91CA/B8+tN+jHgblux2Mq10f6i2e4RZQ1lTyFH0fNKS
 7pVn90qQ
 O/DcqdoKUNUPWbEg7DZUsqJUPpshZutkrouRTP1BQQ77LrNBAk+A6UpaQAMiHpQ1bz4TliX5A9lIvR+Qaj67ocxoPoivqV7beL20njteHayTKE9PXqyShckP0qtDS4jeQ9m85e3feDlrpMIERIAbnxLo/1UIFqjlomdRR/Kinhv92C0jv42cvoc76oYqKBPTD/GbRwvgG+9CxkS3Dzttr/hGScIxkFOZUS/h6KeJrkjinFqHJfT/LdPyBCGAR45X5Z0dy1jYvtSk/zkHksqxdCmAiZwrbKhH3+nDSBXH3+6/vqB9HwXRPyLU+f9HHKXyVRzArzhkTqRYrfhA2bdHuujr/RyLRN3ShWnrX5dHUQxPULTuwg/7GZNJXB2cqkSS3IZx8mRQryjHYiS4pTT2OoWEP9p6s08SmJHUqqG9NNEgBBKoG8Yt200n8RZSzXWD4Qd5ri9Br0IaQ2Czj4x+2NSbpqRWlCYgiLPhUGFfR54qdRww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:05:47AM -0700, Andrew Morton wrote:
> On Fri, 31 Jul 2026 22:31:38 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> > 
> >     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> 
> Thanks, due to "mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap
> lock-drop support".  I think we've looked at this previously.
> 
> +	if (hmm_vma_walk->locked)
> +		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> 
> ...
> 
> +			*hmm_vma_walk->locked = false;
> 
> Stanislav, can you please take a look?

It's the same concern as before: this path can be triggered only by a buggy fault
handler.

The logic in hmm_range_fault_unlocked_timeout() mimics the same login in
GUP's fixup_user_fault().

A quote from one of my previous emails:

"Fault handlers are not supposed to return VM_FAULT_RETRY or
VM_FAULT_COMPLETED with the mmap lock dropped unless
FAULT_FLAG_ALLOW_RETRY allows that, so the NULL locked state is not
expected to be dereferenced"

Thanks,
Stanisav

