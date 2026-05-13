Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B67CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3DB6B0005; Wed, 13 May 2026 02:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3D06B008A; Wed, 13 May 2026 02:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAC76B008C; Wed, 13 May 2026 02:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0953F6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:45:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77415120759
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:45:25 +0000 (UTC)
X-FDA: 84761460210.16.602B96D
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 60583120004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:45:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KnjffJ4E;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778654723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k93jNbFsgBY3MlSTxImzToR0APgHl6uw97YoSg32KR0=;
	b=bh1VC2CYch5kQM3i+yHsQnHb9fdPTVkTTtWnMjG13ora4CrcbDcjgS+GCYacuupMuRCmYS
	WxCCnhQbM3Z/fa8bSqnvf3N7Mt6QkhAzctYY3DFeeYh9pX4tOXA0Sg21+Ij8Z/9F55hQZP
	AClzW8QhFzgbDhgsWLWs7F7HpbuA1OQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778654723; a=rsa-sha256;
	cv=none;
	b=WRZn0GXBU+3iczb+fEvBzXLNJpUhER/ELgzClSDFbaGKkcyDs3KE+mY4QBsz6ukUMg09fp
	9a2vbRcwAG3kI/7qR7x09p2L2On2UwiQRsBy356ECaR8iNubeGAuZJrOtqCJgDUBroyFO6
	3rI5ItKVEGiko0yrYUmtZRM/V0VD5RI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KnjffJ4E;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so56609755e9.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 23:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778654722; x=1779259522; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k93jNbFsgBY3MlSTxImzToR0APgHl6uw97YoSg32KR0=;
        b=KnjffJ4EkFgiUJytupEVxA9XjWpDU+B7L48il6meTZwvKhCKtgbVuzUdUh4BI1HTLk
         25/NGCIwM5SK6NkFSHx90SYiLDLf8qIbibpkwI3Lb+75DevQZEtpzMuCGU9yeKSd5ZOw
         FyQvhE+8h3Bo+KYKNgMlw0d/9NJEEVq3+SBFgKoTR4MhLF3gAzIjBCeFjyPHJ0ECKZJd
         cyKJEvP5mVbxRQj6WKMMCylB8fZ1wVCaVaHpPR1vCoSHUAkAKtdKyud7LFxlUZuJCLOy
         IlE4klov3v1tUxyJRJHLm8VJ0myk3+Sgm2dR37Ih2tkKPJblPnYukzPJR3fPTFCAOdR2
         CFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778654722; x=1779259522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k93jNbFsgBY3MlSTxImzToR0APgHl6uw97YoSg32KR0=;
        b=fsY3wT9Ho//D3qkCYpwvgfOjmPFc1ZNGU+Bh3DXEvka7xspz3JjvuxU7Twhqf/SmpO
         Ys9ZPhKSybAP1XD3+gLHIlCUXSoQvMNmCOqYunVPDtPPdLBzGKDvmIzUqMiTC9Uf/SZT
         nnQziWnIRQiHzTcwKqPUjBfXKilh2jGpPQMBsFegL2wKElmZy4IeA2Jd8w9a7IzK15R5
         CwOZjoo01fMCiZm93R+SaFXKuyCa96f+PzacQgVExUbSdirDNO4J7atTTHn3n96ec8CV
         sWHVm7CvqN1Y/kusljkDHYTg2Rtz7FUQcWEbfXAivkuAvebakIKTj0ww88pC6D89l2HG
         i1Og==
X-Forwarded-Encrypted: i=1; AFNElJ9sc0b8GHcieMuT2SrMfBRPfPTx22o3Bk2rd6JFCDrd6iuh+JwrzDf5AXsvz6p2Mnw8MN2NtbtA2w==@kvack.org
X-Gm-Message-State: AOJu0Yyz19sWGEWfWXSdGmROrzYVvMBXXIizzjZPxLcnrPl3QcEHyyDb
	p86QbCqBbbUzZ5trG4yRSrtH9u/5RVpZ/BMICQk6vKr/mfpmxWCamfHvW3jspfN/lmE=
X-Gm-Gg: Acq92OEMPcbjWe2WuenX/Ih15WPvB77qH5dgglRuOh5SjeU1Dj1bqKpBaW0shMTmozo
	8IkBOrgKs+Tc2t0kIZ5THVB0meYyM7j/LhXu4nr66s79KylDGmgxigO0+g1HN2yvURIsqD/ACU+
	Tr/yjlpmJLxTfWg8WmE0Xk8UdZrX9+Vqmu2gHWvCT4UAEIfeMBhOG+xbIdikFTy+vOHI4ZpPr6m
	ijt4TG23x13KB/Rukkf7CVHKPxJkafuSkRBh0B70Xatsk5Yj8GHl3U0QB5O21GoykDKw9fGts+w
	KW60c2daYMG9gk8U0nnjowFknvgoOEJifV13ruyC4Vtvrsv/QLTCAWsVkRg6kBsjX9cVP5J1Qk8
	dnHpzFHMSdc8qH+cmCO7XEtAmb7V2aA6tHmpiRUk2Xmh0VZimR4hGgDkcMYCwBth3TWQ+/DYHk2
	Vnm0BU2uA9Eg+wC9m+m7/q0XCQ7IjEz46DWMga
X-Received: by 2002:a05:600c:4ed1:b0:48d:361:4df6 with SMTP id 5b1f17b1804b1-48fce9bfdecmr17101375e9.9.1778654721650;
        Tue, 12 May 2026 23:45:21 -0700 (PDT)
Received: from localhost (109-81-93-105.rct.o2.cz. [109.81.93.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f3e174fsm53304665e9.3.2026.05.12.23.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 23:45:21 -0700 (PDT)
Date: Wed, 13 May 2026 08:45:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agQeABD0W7wn4pCt@tiehlicka>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
 <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
 <afoUt3te1k2TNao-@tiehlicka>
 <afowD31YsGVdVUBP@google.com>
 <agJN2esiIGIhUlMG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agJN2esiIGIhUlMG@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60583120004
X-Stat-Signature: pdh4cfz1work5zhoafa89zkx3yxo6d93
X-Rspam-User: 
X-HE-Tag: 1778654723-944955
X-HE-Meta: U2FsdGVkX18NpEaFPnEi8Nyn4tgcv92TJ4TcifFEETXc1mRBd5DJelZhHK5gF30IQouWIMI6LdpVPXtyPkeQkidF4eS9ZiRqRwoiA1Jbg4VrMr8V0fNnMIeBKgZnw2ZNoJqPUozqee/uvoLOESN+SSZSmjhd1eJh/axlU1CttHqMJONc5h1Ta5jvIV24AGmc5NLAdHRsuskGsiwZ3PPaQVLpNET8sJiAWMoE0fL6QFIrmMUyumLJAs18gOb0e5I9JgD3Npva0GP9LVR5gdU/q3ZBd3nIQT4a8+LiUIcPxc2wttSxFYgDqsP2/i9z+sNcLE7x+QTBlF7h+BKpWqyeoK708hThcgaQFiWBCifoAsW45mfwQLlYPj1RVGMR4/hAHFNEJh7dHB4SxISdOM8ubR5rpYXS/RgY2e4yg59aRQg01T4ZfZmms43qHHmeN8I3IP6I7tED4EoXnwekD2RxwkaVPDc1ulPY9qs1Yomkxi6RZ/CVJ7ZhbQ1VL88Ksri3Y1Ys+2oHqUX2md1zVdRoI3mnRRnf76tCkmK1HUjB+mIWrmMRTFDgknWIGpZrmAz2XlLNFMaOiehkftketQhiR0TKyjKZFwsK5qx/dP9DFZHpLXFmFWwAfBWoINlb1+CikXuI3IGB+Fn3yw9QG+pKWZRMR6EC3jTPblMdO4fHip+2Fme5cA//j6bCgqv8iop/izPt0k2YCtwDruxtbFKgYytSPTZlWhRl6Rf9pVN7LVDyjxzkNnASd+ZHPqXxkb+A1dDKWIBRCgoK8n9QMMVYLsug82+IKuHCWEoORGfC/QHU6PWwfGFZsPcsCNepQlNv9txoAWLsaQbroHmii6OJ7WCIEu1txS8bMyQdtFPZhelCiJclRrX4jaZ+GRm8Kir56hFSevKBVkO55D8fNwNTFAsDs9idxY2ezIRYlaa5Q/x9OLa7dH6SbgS9QA0WOIenO+/iIHOeSxnkqc9btua
 3h97FPxr
 G887w2W1wjJH68WQx4YBrHUzn9iPyAGtRo9CwStXYEO2jWFGqniCQx5OMuwmTce1/9duHawqv4sj3K6Bw+AGI9j4K73DMsEcL2P/WrCRKGN0FyDPd2vz5YYeVzxKk16Hw4DUKE79CycEx1yt0/i9gXc97MwujtCJCpBSNp/IGz284pDZT+42amgh8Zzv87SL/aXhszcShetSz6ty3fD0ohL6XATaC2GI9hLfD5sBYwQhvVxaQT17zuKVXeYXXeJqUfELhc4EcwmpYc7mcJi7Kc/Pj+32yvMb/mY695RykTbgY694nXl5ZEHsOe4/H2mUJMcj2504HViHDWuXXyw25pjE5dSJCrpjwuhLid5V9pRIBL6oOVIj1yBNeRiVEivFZ3FypRkQLdWYJGxEbZqbwxAxjcBpmumRlQ2qp7mBM1gHeWM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 14:44:57, Minchan Kim wrote:
> Posted v3 - https://lore.kernel.org/linux-mm/20260511214226.937793-1-minchan@kernel.org/

Is there any reason to fragment the discussion into yet another email
threat? I believe Christian is still catching up after LSFMMBPF last
week so give him some time to have a look at this proposal before
sending yet another version please.

-- 
Michal Hocko
SUSE Labs

