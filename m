Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DCAEC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481BB6B0096; Mon,  7 Sep 2026 10:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459B76B0098; Mon,  7 Sep 2026 10:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396E46B009B; Mon,  7 Sep 2026 10:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 191A16B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:53:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1E1D801AC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:53:24 +0000 (UTC)
X-FDA: 85187259528.01.615F1D6
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id D2A1E20002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:53:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NR9aUMcs;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788792802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ2fjOmOWADKjy9JVfCK9DXQhlrOJjV6jnCnErtXuu0=;
	b=KvQdOqcB9Qq8Zzq6zJSym+YORITBMPQVLzbhZH4G6rI2s8Rp/Vx078lg1T4+J43Ko9o6yQ
	aG7Dh3lZcVbZ63LsMkg2yXS8Ik89Bds1pKbxc3DMFAsPZBFFAHVt2VfA+65XXeLgfEEzfF
	EbpEBOLbrtLN92KQE9ki7q8Ey9kE2Yc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788792802;
	b=XW4/qFgAKnpEOts4YgSHogkZII6Rcz+vKLbkEDToZvb9WCcJ7+QtR9lTR2eiPSmc4nB2mp
	PAnRKNrrBkOM4zgyK9/rnY+hN3FDbP32ibyA8BU1zzRfornGy4PPOeXUYYtLaNu7MWoXYB
	ZWfjTI57Pjyke2erGGlDjfdx6UpoleQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NR9aUMcs;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfe528e9so900626d6.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 07:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788792802; x=1789397602; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UQ2fjOmOWADKjy9JVfCK9DXQhlrOJjV6jnCnErtXuu0=;
        b=NR9aUMcsgA8/NwQv6RAPOZ7GZItS3/oLdW4Kbr1+2bPvv2mgxwFmkTAfX98yx83fr7
         qrOTSFZ1lFve1MFTLu4FLiq261/Jq7MLw7w8YcN50AiBxzikGPN9gBT7dFVP/NJT8FiB
         paSUjg5Yk5OwuIgCtEpSfzNX4KigFHuyNYKNoJHbJ0mn202zYSCiKnW4m95o5tBuf814
         uga7fKTcVDjVvbrRgAkkHQGTe+Icx79axjFU4hQKJl8Qgu2E9Mt0R+qHZCt04W1133tg
         2Jc4Cx7PZwMI92ED+85Cvvd+wLMlWB/E+9NeZNHYUmWEzmpx+jaTHSLBxR9JrdfJSF0z
         lMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788792802; x=1789397602;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UQ2fjOmOWADKjy9JVfCK9DXQhlrOJjV6jnCnErtXuu0=;
        b=oGotzb6iYrZ94vls5oc189xZa9BmJ/cpu+E5jBbPV1zNytgnd1MgGBGbwVhhaZqvzE
         Qgl19Kgm741mjgZjnEncS9u6AJuWYC3StJgRiAuDGM9+FNZegTKYvuCfxML9zyQOP00F
         r5gTOOl73AubsqvKvceB4O55WDR2NiFk2rZ4oOoCGWujj0m6TaotOudobFPBJRk5iHKl
         wqZ+GtT5g2JbIzCJlMrNFBFAOsGVk2rp6CwLdvPQD2M3R3Y2b472ioHUdoTCCmwqLPh7
         g2RVeW8pVsYU9PAUpreUO2ODNEAdGD6MzEpXoxIH0yHFFTjZLtFQ3JtQZu0bkZWoV+0f
         pdEQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3oIBg/HWtC6k5Z/VmC+9Cl40xW+GBa9F45R1VQrrU5gzhRkquvV2he5y0lJHZBi5zaxdPThKvvA==@kvack.org
X-Gm-Message-State: AFuF++npCd0uYvZplkjZRe5T2IUMnEGR1LKTbEZ7C054Cirk79Fz9r05
	QGP72cb3d9pEcQUHUvX7edFZm6nne7S2VY+/XTxdEhJqe2xhfdoHz0pK8f0gvy3jQ8w=
X-Gm-Gg: AYBFou0KNvVvVpvjclyHuBniBXGFDA4A1uUIMKU0rL3V/r+YssQgdjgcrJ414yWa8PO
	xAEmIhJVLGiErqIA/5PaC9sOv30pyJfpYVdW/TiucWJ8qp8zgphNcetsMaCDfiscB5A9gqkCdMF
	+trqaYja/9CA+PRQxFpdjzQyhWgIEl40a/alwcOCeeqteWGWbYuDpD2QpBNh6d+9W6qyPbH6+9I
	BkFkyygNaFrrvvsKHg767jR2MTCgPiO6n+7cjZHB0XNcK3W/7J2hIdHt+FS6FVdB+u2EUgEHpys
	Wu4bZp1bArG+wtcxysG0E7bPzHUeG/woGg7wxaTTzGG62nlcs+Cr03gvNFDZRENt3k3Guxx2N02
	SUqE+daGiufgg3d0nLIE6Ue192n1OgrSVdd+jKX9sZbVfN/qiGODAv1715FSUzMvZPtB29RItBD
	tutFFCYnjdkxLcyJzIqBnrZk/M3I0pCej/2/Q/rBjEni967o9g+Mfdq74ybFgNFkFAi1XzE6f1B
	yteYiYyUc++HbjqNgLTPd7j2BPfJtUEilbyZunNO3LdxpI8VQttPQdh
X-Received: by 2002:a05:6214:4001:b0:90e:940d:afe6 with SMTP id 6a1803df08f44-9106202083dmr14557396d6.15.1788792801917;
        Mon, 07 Sep 2026 07:53:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406afe48sm93131566d6.43.2026.09.07.07.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:53:21 -0700 (PDT)
Date: Mon, 7 Sep 2026 10:53:19 -0400
From: Gregory Price <gourry@gourry.net>
To: liuqiqi@kylinos.cn
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: add trace_mm_page_alloc to bulk
 allocation path
Message-ID: <ap7Pbm70m0pw_NqM@gourry-fedora-PF4VCD3F>
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907120949.418450-1-liuqiqi@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D2A1E20002
X-Stat-Signature: 6bet4rg3g9fi6rgaxuop8baxyqbsdran
X-HE-Tag: 1788792802-831439
X-HE-Meta: U2FsdGVkX18Dbnr9pZYOOhX9xLQkak3lFq7QlKANm/UM+DUYZ81ch1MgkNOt2CyM7cDrs0wTMFdiaGXO613f7fVxkvWPPYeqLWUG1LrAvqYbtsbpLr3krk469rB8sOtvoySyDhIEmkd1UD456c44TiqFXjd7+ICRGOQK6LO3EoPIZo8mbZOim2hEhVi23WDLsE1uJFHyEqS8OBysrqJHreFbyEMeaRAjMxQhuxHKhtNqEI+hzG27VMRovH+yGS7Bp1kISyv+I9WVQnNMcJe1bE7I9oVUuY4kwWUIREPG5sqZn7AAlXPfPtPH0ekddSm5rd9eEtPSSw4xr+xMNtHeLSU/W1ZbAjs00cFtD8YdQ6k6BmxSi5XsGCVyn4X8EmUxObVmprTMgylpGAOAX8h+zI63RQ1p3errLltjoxERYthuNehv/T4hYOlZGYV6cGd9nh2mllrIOgCShyQivbfzr/g5xQinT+H9Tby+I3tKfmG3Gnz6ZoZkx5Ynw66ShnkUWTVYllrl5DJuCoRqst3uSWYqwq45F4CvSsI2Vnv85jrrYEtOvfpH2+6G26mixjLjn5YwezN/sXY4EgybBk15gieWtbOTbXCTJMe+ge+prLx/YAyEEOCwdFlRnE2LvTj0OsEQ6b9zEzFYvJzngF5jv6INHVIwZ4XRyRvLoCmwhugE5SdYiWv4yb+g32UOwTokNfOw6tbFJT3ND/jAQsK5kdFNY89r6Os7Wes3oo8zXyZKo+F6Y+xIDJNZsZMW0jPYPV2LT37qkvUjySPI0Cf6D1SyvRxeY1l8gQjLZpXeIzWZjcHaqZOslKbrofQ9/c9PuDzTzTXjVyPirWkiRZbfY3erife14QUp2ztYIj3tijrzGhAuJX1M9bcRqmBQ3KTpVYK1F8hjU6MulNCL+sgiGg4hTIzIigW5XCuEHlE66/RnHEp8S15hH2D2lFNL7a1J0DyG/rrAWSfQRgKFM3R
 ZD/ckEmo
 xATxg20/aurEpxKuBMzbg9ozNF1WabQ6yrkpyjI7Xo9KBEAETta6K8vAlz06JR8pnR4kbnn39kmo3VGZvEkAvh2qv0x9jkPOGMXHhGd86IFW4bds1GC3/Q62+FLvETkDl4C3kDe7t8MsBQm+w87eVkXnC/wXxYCKdrOncG3PjSMEz4t29FVELoONTdcuYA/ViGp+C6Bk+iryhum0D7MoK/kCLo04b7nTLq7tC/zES/MAKwCk3HrEObKoXRFHna/Zwm3K+/vKftUXPz5Yk6FpbZDRLoQbWOfafIpSDS1RvMB+hicdEpJhTtXSY6aw1DmfXqkWAL+SxXlBWv2BSdMllUzgI4oj6ge5vzg1HnF9Dj+NC0dk4dzVcheWPHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 08:09:49PM +0800, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> The bulk allocation path in alloc_pages_bulk_noprof() does not fire
> trace_mm_page_alloc for each allocated page, leaving bulk-allocated
> pages invisible to ftrace, BPF, and perf. Only the fallback path via
> __alloc_frozen_pages_noprof() is traced.
> 
> Add trace_mm_page_alloc() after set_page_refcounted() in the bulk loop
> to match the standard allocation path. The tracepoint is gated by
> static key, so there is no overhead when tracing is disabled.
> 
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> ---
>  mm/page_alloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..d17c21775cb2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5280,6 +5280,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
>  		set_page_refcounted(page);
> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);

Sashiko asked whether we're also missing kmsan hook here as well:

	kmsan_alloc_page(page, 0, gfp);

Might be worth a quick look and just adding both in one go.

~Gregory


