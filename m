Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83516C61DCD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851E26B0092; Thu, 27 Aug 2026 05:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803516B0095; Thu, 27 Aug 2026 05:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3DE6B0096; Thu, 27 Aug 2026 05:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4906A6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:43:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8DF3160129
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:43:32 +0000 (UTC)
X-FDA: 85146561864.07.FEA1F2A
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id E86B420003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:43:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JgDEw57n;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823810;
	b=l/kPtfrPhZCLupw/HtB8zlNEctJRLh/+e9P+/+z1nD9xZT+m4I2aJbMU8LkBpgA53NuSit
	kmTfR4L3gzGXJyfklKfAvVwvXp8XNiZA15cqfsKm8dabfB9z+eR4HElOfspFnGhfAxR2sF
	ImYiaGIGb64bHUQnPBydECqkA/W43Kw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HKJ3tAW7wa6wdeNZbsdvg5DDct+7sFZSSnnEf99jqQ=;
	b=tTSwZTW3NhPJ+JmYUInqL5N+Y/cLnblLUD8CkqBg/tDbC2WTp2s53/ghiV25glwyseBfH+
	NH2d/6HhbtFAkx5M2nCw60gdQHXfza753bG9Xful55xrU9bUlvif5cIhqUNFCxUCn88hp5
	vL1b/hm/gujam3R8A/mlAt8aQjc8+DU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JgDEw57n;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-853c401326eso282593b3a.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787823810; x=1788428610; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+HKJ3tAW7wa6wdeNZbsdvg5DDct+7sFZSSnnEf99jqQ=;
        b=JgDEw57nLLeoKi78uIzC3u+ULuSwnCnKimwI4ycCqZmMELZwpOT7Zze53N4l/GYczS
         CSM+HMuIuzyu8DWbBftsUze7MXXuBx8Kxaf0qt220z0M+64Xpsmw93XL7rnv8VXBp2Kw
         NIWVG+ItLQu44/g2dwP4m6MYNHPXSQmwV+GQzgeKqRUKgv3wanrw1g5GWcRmqu+qkA0C
         +979GLH2oCeeFBph0wwoTwD8GGPqORd5woY4YYQRCPYpUSjlo2FfGzRBhtx/NGhapZv6
         3wZhAAtIBmECP5A1v4SuJo5bpppXWTXoyhiXJwBXHFusuhrY/n9Zmu0RQan8Fx/TT3DM
         5R6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787823810; x=1788428610;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+HKJ3tAW7wa6wdeNZbsdvg5DDct+7sFZSSnnEf99jqQ=;
        b=COCWOI2svw7MeS+J2JO7ZQ6u1ZCzClwuWswjVBm9kVLjSbcaBby2htKRwhmbC+tVwu
         9aFbZMuZslZDcXX0yu0tQUQdC98Y2FdTT9kcuyhWKaI/Bn0PTPP1gCpzVnhr+rki6o6c
         brAArqhFqvQ+EIm+X1qfzSCqoKAkuJt2gNtyGtETHUjc0OL1+ARsREfQzs1JDwPZnVpU
         a66Bybg4XbnOfSAahIGn1z6iMIoRNnwSyzrXiN02Xz/7ITH1dSQiQzhTk3OQGg27acYk
         zt8CRHGNF5GnxJTw/d+q97ygQxPFszaHvNl618eEUX4l451LR/76D1lvGDvfHHsbnciX
         oVTQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr9SXQV7ey5fzmbKYsufxzAZ7YH/WI0DpqDABz9T0YnBbIcaoJkNiZuvZoxjB+CThMbYeA17uUQMw==@kvack.org
X-Gm-Message-State: AFuF++mZ4YJ+Jt/jUwRPzPA/WBKW1G4TqTqwPsDrH0Gqzogd38/5VSAI
	EeRsvygIt76UrEanmiU2Dh1xfzDyXMugDvgfUlWVFH3brFglZvTAN4+I
X-Gm-Gg: AR+sD12eyWpzhprsAXlS7dvY13zw0MICHK0y3GGJhiywTSd3xBqAbGwf+RQDC27t1Bl
	Tv9U7xz9isaIzr/mTK1YiUd6bVjUiHQ2Uk2V0Yggj6kKO0e4YfBkJtTsK0a/J1id7sJD4bn4e6H
	HHpugULKoIYyx7g3U0ub9kV8MZbT5qKucZyEqD4/XwOF8fECscUkn8NvOFU5w2Q5M9lDcSJ+4J7
	WoZNAZgbusALjG3mZZ2KbjWEHpoNkJ3TaoumgJ6RqgNdyIwITnTNKdPjI/04rkz3GXYiih0qpA5
	pE7NFSAdKGF0sF7xpMx9VmCDCoKIrYn+1G4tlws+hy1og/w74dWeTImoU+ylwO5aT8m9NhSVifl
	gvjjggKGM3HhM444p7Z1HLgpZ1jXVjBspt4+FsQrvJwOK0uFMKwhv4dPXQhQhKlKPCjqNbpa/4p
	BpdFFchuGOWeSjTJZMWcU9445J4lr4KhVLHvFtBPcIRPiS0IHJKV9C87Id4+tIEkYhWZg75QX8J
	6DsA6l1ZCDVnLm/4+i0ZuKLkgkWvIpg0qEI4XcIF6Ds9Q==
X-Received: by 2002:a05:6a00:349a:b0:848:42d0:bc91 with SMTP id d2e1a72fcca58-853750ce0a3mr26520732b3a.12.1787823809790;
        Thu, 27 Aug 2026 02:43:29 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85359cdfeebsm1819566b3a.4.2026.08.27.02.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 02:43:29 -0700 (PDT)
Date: Thu, 27 Aug 2026 17:43:24 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v2 2/4] mm, swap: Move setup_swap_clusters_info() after
 SWP_SOLIDSTATE initialization
Message-ID: <apAGe5g99mHeIzlI@KASONG-MC4>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
 <20260820115505.20027-3-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820115505.20027-3-shikemeng@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E86B420003
X-Stat-Signature: t9yipjhzgotuw78xirhweqdhxy5sjtu5
X-HE-Tag: 1787823810-571428
X-HE-Meta: U2FsdGVkX1/XInqaA7LJFX4b5H4iE15h1O4+x4eGpAdlyXOkOOB224+ZT3TSVLsO4TTZrBUnDj9FwCkgh3Bv9Fs+lP/iOu6kN/JlOA9+UJi9n7YlfDKj7z9fqLQPFrVzFAVGZFl5/nyPkWBsA+vgadg8aCMPW/UEuZAEqJ49nIUj4V7krQc43L/lKlwKG7bix6ZxoEjl6f9FgtgZ/6LWpA/TAUTrXeWfUWXnN3E/3rnfD3WNROJMN/dH4ee5n3wTs+jnjlmVGUr6NsGci+3Coga5XmW7WBU83mxwfr2ljoyNVAidLyKOG6wCnSbhQ+wDYKWB7I8Zu7aIrFz5pAC+OfNDknhahOVfAo1/COOzHTM2b4TA/ugZ3g/pZmkaUHkSuAFTJ2c52zkM+CzaIRzAXck4PucCZCnseifDRNSesk/KwleNvOoPPLdpszDkNALh6hvKsUklCeiH9tueYFvItFAzL5ciug7ygoET1l6AtpXJcnjJcEWFeL+WMopyRkEdgMJfht2Ht2MMGJcvloistcvP+L/omeU6w1/SRzN06E2hXGfgcFLJGmOchDyIimY0/YoMK4K+rShltrwB/RhF/PkXvbNSgGf7NIiQyIL2v/3wToSlad442SFeCl+S9zHqNZ6YUgS9HsuMX8+PRDflqXjh2JFigGQVhHnppMd3p9iFD88tZHDud4158rp2Xxi72p0R0r+gbYau/Q9WifnTMZ5QyHBm7g70NgxtpopTnRjYPhbe8aZs7OMca31802E2NNZN+c9WgwdMcxg/fNpKnbehEfFgZp7vzt1yHXwao0DtZGCzCT066XnqQtDi24gNuocH0cLMwEQBSt8Nq91Uve4ZR6c8KIbrbiWHdW/fqNZHLkbC5r0WtYsXnCpCBcHdoYlPKTX8twXb0Ag6ARS9jyaDuiYiMwpT1dHWL2pd5GHtav/zYxzXTqpVhVhBpiMBoxxsZ/ftxzdTth6EbEv
 hxv0hs6w
 LPah2Tgm9t0SAXgpsrDwoXhygt8n3A0c6h4oIkV7EuAZ1lVgr23+Co4ykMJX+CoJEhkrUmwg0a7qdedsQ0pJSmWUCJmw6Mwn5rQWe9AcNFLrZ2/lRaP8zyco0uPoliYBUcvmD+3P/aVDWvBn90dmkSV97BX+1tdCWSVTHJchMJvG/kBBOUDmL+G7gfwO1VIRpqohbe5ETgcfi3CzcrSxseK+n2SfcPuB+VzR7UUPmrEzKe7WflXQxjb+6VnFAgS38EeTRM5ikZppPBKjpE1dCqAqp+ojtfLut79di1yg5o1uo7EfSVv3TzS5Raq1lQrD6ULtoyfTiPv3PNwOj4tweohMpI8WfWGcqObMaBZBBxA5pmlChn5gGR/kAhL+jrB9VCYz46KCTbF70n7I6Pnh45PwizXQ35sARoUAkS651h4zb6SfTZUubBocF9gOVYmmFZWQ1OVFex9o2/nCPT3FmX36EG0Vt0ddcchzeZzGkVvwVpaWjSE2F0s9u06PXp8eni796o3Us/KtLzO3uCbW6If6naC+1P44Nq8s4phw0h8+43t7xmmJpn8XgA8cAvqiirVaHWW1rjHcPp1HajQuxqXKevcP+vQUS4/XTsGLUGZO20hsNRLl1uLODj7OMv8jc2VYRH+XNxHH4/kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 07:55:03PM +0800, Kemeng Shi wrote:
> In setup_swap_clusters_info(), SWP_SOLIDSTATE is used to decide
> global_cluster allocation. Move setup_swap_clusters_info() after
> SWP_SOLIDSTATE initialization to avoid unneeded global_cluster
> allocation.
> 
> Fixes: 451c6326105b2 ("mm, swap: clean up swapon process and locking")
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>

Thanks!

Acked-by: Kairui Song <kasong@tencent.com>

