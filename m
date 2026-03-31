Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5988FF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B24F6B0095; Tue, 31 Mar 2026 03:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4898D6B0096; Tue, 31 Mar 2026 03:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EF56B0098; Tue, 31 Mar 2026 03:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2589F6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:40:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBA8EC36ED
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:40:29 +0000 (UTC)
X-FDA: 84605560578.21.B08929F
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 17C4440002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:40:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FWgEptNS;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942828; a=rsa-sha256;
	cv=none;
	b=IUMSHT2sSm8OBTtwMCINcv+x2pFnihxlzQ+hYKecSMdhdnKlmftw/iT5VBwr8ydnMQSKmu
	zsePIW7FheVWdJa4TAULAA5d6O1PYUqqaMxoxtBiLYX7bWpllX2lbSEBNl9WvwI5OdAhrY
	7d+8C1xgW2UZk8ud3c5wjkgdwWOELWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuH7iIH355fRKQUbODvwVt65TnT7rv82+xQMO+HW4Zc=;
	b=BooGveHTZILkpmxvfxX0/edKi6gR/B7LtrjYBrzCZeMaehvk3Gm5B3JrtXY2Dua2wfoJH3
	3fA7+LXp+93+xl4dcTpRgoWyhqFq3FoN026ImW6hvacBO3J8omMSepqtD/Hra7QbGzQxfu
	Qq8xGG+a4icjxOEoZNsf4TLaivM4vGk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FWgEptNS;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35c1d101355so2256607a91.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774942827; x=1775547627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GuH7iIH355fRKQUbODvwVt65TnT7rv82+xQMO+HW4Zc=;
        b=FWgEptNSrOR+TeQPwtikfXf4FAROJJibVDL/5rOt2uBm9GQNW+eOawR4yZEsRoSxHb
         OeJ1HlsuFmq9AJkGCJdRVsLRzVnZI4qgbG/4kwl1LMSx3poc253GuXHIbCIuLx/w4CuO
         p4vAuldiVvsDwSbfkTm/h0j6AGJYYY6FZtxwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942827; x=1775547627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuH7iIH355fRKQUbODvwVt65TnT7rv82+xQMO+HW4Zc=;
        b=ZNQfBVf90mBZy+iKH/QgTyjr53p2pSgxaAuCy09VHXkYFnmqrEcYpmGGy4sLawaoTk
         fR1M5d+MeF4zq6zuKhPgNufSGON+KClhkY7EY/hll72PVTLbyZxAoUbuUPr6gudY4MtX
         G95UkN0jXGNnnmoQ5R1WzoqU/Xe1gw6lO3JdjFRBTWSBFvRKKl1HhBGOAhitvQj3PCZE
         ymdhDyf6k9L0e1GVk2XNLa7Gjs38b3MoifiKzNMkqr6qZLz1uXY4ObICOmorCv4peUCY
         oIjom+Ds1PizQN3Ad1i0e349kCtyIcyF7DOljKLyJQWlA5LLHR8qAaRo+4DENZhu1xe+
         +1sA==
X-Forwarded-Encrypted: i=1; AJvYcCV8oNKqFDxbOiGvdvNOOlZV8wCLnDFk30yNpXPEc8TPzt2vXCb2mfxGzHKfEFyaC96X5IWpAEHmWg==@kvack.org
X-Gm-Message-State: AOJu0YxaXFTQ1EIsnWp5Lv+wmg7MKlLzQ6IddSUy0NMrvbWXHKxX4cET
	SSm+isUuYfYQTB53cgTsiHvIqyrd3e4nlIWvizxawPIjpVloaT6yEEkWF1raIIDea2rviqwsXvx
	uE8w=
X-Gm-Gg: ATEYQzx7TM/baZ9SYTRVIVC5l4ZbHc96nx02rlS3kCIqO5/VYD4dVR1d7SFlQ1t1sZg
	/v9aTacRtUtlbUKZCLOUh9EOiMcJdv3xlFqDo6FiN+L/Eu+snTNBCpYlEhBMlpFF7B7QSKBpLs0
	Sh2dSbl/1UGbTNGgRTzuQEEckIHUGlKPw0l4EsacGuVxJ8ydmQhSlvXmuy+XF8+zXVDNrccVFOZ
	T7CBkILuabYFXnq3q56VihCzD2qxSJzPG15u7Yg3jRtJkBmm+x3d4ILVuSWEXgG07pQ77P1STGG
	XrHAYFBzbPvChTwZvMgS5qCtswxMetvbdnIoeIdA+iaXRfO28qQ702rjG8MHExHmg8T92T7rMGb
	ZX6p2zl8PSiU/IEqSHMwxnxP9ENrnivADXERVbOLn1IQSoxbeg22X3U+Gh+psVItlnl7hiO7pop
	aPSDs+0i0Bmnc4TH1pkDmQtykcrqWdwU5tejBKQyXBfoaeecETRDsVw2ZVb8NjdBQ=
X-Received: by 2002:a17:90b:2d81:b0:35d:a9bb:1e41 with SMTP id 98e67ed59e1d1-35da9bb2001mr5840966a91.10.1774942827011;
        Tue, 31 Mar 2026 00:40:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe9377b7sm1049975a91.10.2026.03.31.00.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:40:26 -0700 (PDT)
Date: Tue, 31 Mar 2026 16:40:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] zram: do not forget to endio for partial discard
 requests
Message-ID: <act6COjXXZecVwQM@google.com>
References: <20260331073737.774503-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331073737.774503-1-senozhatsky@chromium.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17C4440002
X-Stat-Signature: ktui1a3gtchrod49saebh7uyyknjr1c1
X-HE-Tag: 1774942827-165562
X-HE-Meta: U2FsdGVkX18Ij948xREg2WXge56aO/SHMO/z11vh51Kb7qjST+PYzWwyEjWKCT7L3aPMGdSHt1Jbvs6qGKFcYwULEdVdTx8mR6V8Kx5g1hbjHRXW1zrA2fK09bjgbalpOlMZyVXo++FjhEOQYnr9BRIkKbAuyXr4VJ9KMlHyq1yjX2igjvAtvk3Po3pBbzsghrNy8mDT4BhPS4XgbdklG5tYnmKbJxgRy/e+0YrAXRxCSvdYdAaOA6pbTTaalr2HP0W6murewQeQYMRviLXzfbhkbiXdhRWalAjaMP1e/zWsa8SKsJynnpTMSCbIonwQYNUKhsnGLb7E801+2cCa/CNtad5vaxvzb+Kx6ZjdJWaiESwdV/28pRFg3KC4/Mp2qEMVgXJIpuGOLuDIUqmaHYERF/9c7/h+DDiKwK7s4IIEyjKHsRhnefUJRy7BT/0m0WyiF0tW+XRpwnd9DBjfp7cd87zbx3REQ67zvK17czj+1xTZ6t5/af2KpIF4oDXoeZdJorBBf9FPAM1bvbUwbq5CLM4sVemXEC4K8tu2PNBbXXDTzvVv565RgUATFxAsSiZDC7Cb9W87xTDia4IrhOPpbuvTSXj1j5OuecNvjAZvDAIS3E9hdCsuuT31eKeBNnA50z1MG+3h5hOgYzZtB+xhR5lqUR17RX0AH1h2jIP48D1yXI97UbtFm00QF6NAtAhbuxUnr6/JRDc4kAAhosXtf5NPauT0WCisI2zjPh0AFXxJCLDYD4CLqhhhDJvxJdDTDIG5jePL5AnUJE1G13DcO9vX8KJHKrpssdZyZs6dFjpRfLTTjDz7PDAMXgtCCKwZ6wCp9Gq/APE0duiFfMt99iX/ZO4iqgzv3PpaLFu44bFY4sajNoyw7Hu9ZtCh5U1T2SgZggn7zQsV0KCBw1CGQG41xRrBvGoSmzVV9jzUi6CXVEiiQLwSx2w5ef6k+emZWOedQv7xz7FHVs8
 hp+TSsij
 36cKLBalKy8vYHLyat3Ht2jREbmBknRis6gaXntaQWyw6J75I4PZAfbUflWQQV2R0k2H5zq+RiqXlN7o2JILzEHln7UupHRrDzuHl2hgUBzLjeOUwx7UNXcwoBVphBsHzNHMcTejre0IPKlCXEntpqKpLyuM40ep36eLED+4N4p9klvXYEtfTF/jI6pHKc9UhVElI3iOwbIPn8LLqPzdgtDtbmEjfgcCBT4FlzJ7nliJwq3X+5eow/hnqgJA9Xtn209CS1UYDVsOJBFyYDLEsKoT7YOCkba/pXUL1+KZPNETWu9lFs0Uz56h8Apsxi7harDdFB4SWrLPDfqWgKJ3NWdutoLXSWYY+29Tlj+TRZsjD5Cw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/31 16:35), Sergey Senozhatsky wrote:
> As reported by Qu Wenruo, the following
> 
>  getconf PAGESIZE
>  65536
>  blkdiscard -p 4k /dev/zram0
> 
> takes literally forever to complete.  zram doesn't support
> partial discards and just returns immediately w/o doing any
> discard work in such cases.  The problem is that we forget
> to endio on our way out, so blkdiscard sleeps forever in
> submit_bio_wait().  Fix this by adding a missing bio_endio()
> call.

The last sentence should be something like "Fix this by jumping to endio
label which calls bio_endio()"

