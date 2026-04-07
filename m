Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E50DFEEF25
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 11:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562276B008A; Tue,  7 Apr 2026 07:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512546B008C; Tue,  7 Apr 2026 07:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428356B0092; Tue,  7 Apr 2026 07:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 314526B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:21:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD92AB8DA1
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:21:03 +0000 (UTC)
X-FDA: 84631518006.28.C1AD538
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 117C340015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:21:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HRomY+cu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775560862; a=rsa-sha256;
	cv=none;
	b=TXIF3o97gVE1PufSiNi1JdfJr2xTAINBr53byU7wf9iFDswP6qmNY3ULmkHg0PgDdj3ELE
	BSxmnXhJljfV5faqMHUmLp2sWWJG+WaEMVUanITMl88+QfVZ2Yf6JhbJbEjBnT8mPFdakh
	3BQ0qlhzHGXmxmyNgCvhxn2vQT9KHw8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HRomY+cu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775560862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ak6Ow6/QaSx3d2ftagO0ADIntVVPX4rdI7D8NXhmkrw=;
	b=NymdnGDu4BmBzzNN4wyuUtZ1VMpkAXqa10bNWnntN7OXtg7PQo/57uXVxuJ5LJikHqhQgJ
	WSjTjJTe92bIC3V6MnfB805JkSoBYLu2Hu1RViZV4Ylx1ms1u8HOaBJ6ghv98SxnguGvmb
	NZHDMZpxZJ9BgDDzj7vqaXUDceywOpM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfce3a195so2993694f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 04:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775560860; x=1776165660; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ak6Ow6/QaSx3d2ftagO0ADIntVVPX4rdI7D8NXhmkrw=;
        b=HRomY+cu0hZjxzD7/Kt6qdjTi3LMlTPGOkgHrbrgKkvA4reefPqRXTUQWke226UA8R
         BCJsTcw6YFGsp9lGPY+jJDmTWD9h6UMAKRKx5TsPq/rbKxxkjiJhF09wq5WUkwfKw8bt
         TySKpTjLMv46YI5M/jH/4nQ4cDl1UlC6zJ8H5r5TjCqQaTsGRPsnjCL5xsEf32RAxQs7
         Ag2BVJkmI7wDpNWHQcGQcg6r+XbBPMfXSFzrn8rMzEewekCc8tTNRyKM8qtr6jnawD1h
         MSTaYS5YKDlG1gZhNZl9cKFGnOQR08vGG2pFNlYmaosvEu2fnh5OMnHXKAei/FYv3idW
         tg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775560860; x=1776165660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ak6Ow6/QaSx3d2ftagO0ADIntVVPX4rdI7D8NXhmkrw=;
        b=eZMXWfiQ2NWTwQnHt3TcVSPH2lG/ysMLDBP2dPPJKJ4o6Khpl4ahl+M/0opESpWGEv
         mqWQeZ2eaMEcs7UyzUu8AHPFzArWFB6OSy+PDxMPq1gh6KhNFjBND6/IslE5OwU3H2fZ
         u62voy/71IKwtzVloR5w5KWRX1AjYca/C0cMQdefiB+ETvn4E1VIbXQrFqtXMk8l3x7A
         9j28N3IsYS+MvTwBAGDb0vEBnZXBENZBJBYyPDrOES9Ly5iAbYSkSI+N82BUVV6f6JeY
         /bH+by6mw3wV2k3z1phXPTptmzo+T/GkN+XR/721vZqoX56FUlrjzsq7JIxx46OxpL54
         BAMA==
X-Gm-Message-State: AOJu0YxyKO4dtia5qurOJFgRXqTpczK3fxCcliQ6gTJD84Bbv8B9i6rE
	J+ZL9BrWG1gLzsD9rGC7ONT5pRYga222m41T/o25HcMgRqE8BGltpURaHvJw1M4ivvc=
X-Gm-Gg: AeBDievg2L9fJlhT1UnQ+6TeOMH7w37HqSuXUG8VVOh5ic6Ce1eKgdf0nnpzM1oxbzc
	84z7DmeIyVwGCL1HcO983+q2G2p76rd7IVndhRahNHvG9seIacMR73fLKKftn2dn1cqrxm7Nc7z
	fzinEbYswEn2oWBcbpKBLqosmSvwHVd0RRN+FcxweT/myBbZLD4oFh6Y09LBzoASbwSpF6HZJDE
	R7+isHieQ4QpHfwoqbu8Eh6cIrPE9l9laXOY8OpBO+8R/Ft7p0H+MI7vLcdkk6JqCJ5kiSbaFY8
	6aHn+taaZQOXJx0PHsgy9mZQwPXYABB7ZoewjNOzL4IS3P1hxoBTthN4mvWf/whRb5Y8qPioBMW
	6X/8uoWS+SQoOErcRYtgvDfdR3rL2oPDENtgX921EanGv8cS9ICYbCfbnxl9EVkYk+8qB0IwZlM
	yjoQ1JJO/nkqPDhewqtlA1CZ8hjb6ObfxlrNB8ze2Yl62v+S8=
X-Received: by 2002:a05:6000:1842:b0:43c:ef4f:79e4 with SMTP id ffacd0b85a97d-43d292ff4dbmr22067547f8f.37.1775560860126;
        Tue, 07 Apr 2026 04:21:00 -0700 (PDT)
Received: from localhost (109-81-88-253.rct.o2.cz. [109.81.88.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e1c27sm47135247f8f.26.2026.04.07.04.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 04:20:59 -0700 (PDT)
Date: Tue, 7 Apr 2026 13:20:58 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, baohua@kernel.org, bhe@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
Message-ID: <adTomi7uPYJebAMD@tiehlicka>
References: <20260407110002.204755-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407110002.204755-1-wujianyue000@gmail.com>
X-Stat-Signature: h6ezq5amjmkha3mf9tpfkgq8mt64j4hq
X-Rspamd-Queue-Id: 117C340015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775560861-287665
X-HE-Meta: U2FsdGVkX1+3NZimXNNCtAvJFmX0gy3A860KIwOrxFZGv9TK75YJjrGr0l7JiZP6dAwfHYbuWMdfjnlFm9czhmHjNQZoCSr7oWdiT65woF0nziZY9vgbwUlp1dsPY4WC8iGTOb2PMVF09+lRzGYuZV2TKBcPg+JbsYcLeLMrv+O3R0RB7N40QDJ5757zn2KxLdnnz/KvDUoa7bqsMCNSoXPNQCFfvi+1omGgMRZxIxjAcFTsMAhJ/Y3kCBEIp5Is/uySNYROXdg9krF68wUYyR4PnvqKVmEj1dSnbkvFVAr9DgvD7W24rhRTQWfxRPI2CKAXIC+/EBY0IUXCrbCU7NazWJqlMuJVHyWhrkCHBfsZ+uFMZS7thnSDUFjzD9QHTay5HWbH0rDMSq6QMuoloRwJ1UVfuOJiIldJXsMGxB3yeO1VVhhIDsfdEBbKakMoFUeo/NWtKZd9e55PjpaSucmR14esfElb7Ue7qWSVWSAfnPdQGn5ThGl8vtq2Jia7FgMWxxA3fk8YpkSFAsZP3gz6Wza9Hw8MZqhwQg6CyztjCgFuIfAbEAXd5chmRz6Mbdu3qWnOMXvT7zt6PihdTmQcrQug5W5ShT9CXzuiauTDBd7Y4cgrzoZzXMKevjZS1Z06OPDyhitocHA1+uowx1ZrL167NaW+7BVCHIu+Bja35Q7Wdl+odxqJ1d0Xm0KUdliAUuYWMKt1bbkfgYB3aQbk3ZmoR8MZCjVj3NsulyFUMOlQkCqkIuM7Mbtdb0WWWsZYc/qU/AdTkooOzpmviKGvrtGMbZZH4Q6gTCadDfxWOitUe/BFEV0kNv6fcgWNFf63mp/wkwGBNwihbq4bgPnvLG0xmgpaPWd8Bkm6MaApzBsZ9lo7qPFLwOAB9gglVhT3yOImZG99tFYaeV6sDPFnC3fLGNxpwvPErr+ugmkiT4k32l0XxGhl/zrCvzak8XiNoSKMnw9wkLuuKRv
 usDcM3aP
 H1vKZEcFVsnuj6T9507vxfbLDQZPFuyu2FjiB091IEokkcm9nCZnyC4uOQPSlTrEVqInNSgliQ+kdU6xMr7PmBW9XaIoEH2S5Nu75We44VYllTwwmQ3gicBsgyP3IXd3bRmkm9UtiiVTcI9yWKGkn7RcKbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 07-04-26 19:00:02, Jianyue Wu wrote:
> All allocated folios are added into lru lists for later reclaim whether
> they are file or anonymous folios. However those folio lru operation codes
> are put in mm/swap.c which is not so appropriate. Because swap code is
> only for anonymous folios.
> 
> Here move folio lru helpers out of mm/swap.c and put them into file for
> their own.
> 
> This is cleanup, no functional change involved.
> 
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  MAINTAINERS          |    2 +
>  include/linux/mm.h   |    2 +
>  include/linux/swap.h |   38 --
>  mm/Makefile          |    2 +-
>  mm/folio_lru.c       | 1074 ++++++++++++++++++++++++++++++++++++++++++
>  mm/folio_lru.h       |   53 +++
>  mm/swap.c            | 1064 +----------------------------------------

All that big churn is really worth it? Are there any other reasons than
"not so appropriate"?

Really if this is not a part of a much bigger plan then NAK.
-- 
Michal Hocko
SUSE Labs

