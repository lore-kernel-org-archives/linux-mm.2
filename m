Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91075CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C7C6B0005; Fri, 15 May 2026 10:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4226B0088; Fri, 15 May 2026 10:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B316C6B008C; Fri, 15 May 2026 10:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A49526B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:19:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FBA340144
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:19:15 +0000 (UTC)
X-FDA: 84769861470.23.DCF3D89
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4641420009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:19:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Z5jTmHGk;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778854753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRDBDq+fY1oMHQKVFr7tarGavnnf2HzpsD2dAXXMIQM=;
	b=F04hfvgJAaYROeyRedRN3hC9dGf3I2ouwYGMYTTdpG2G9/pnPOK/42J+QZQ8CIA2XkG2GO
	DEJqgpIwypq8SheTO/0MeqoQEG1b/orul0ryFe/tlrG88MWYUYKEv8XNAvFsjuBCIuiqWh
	6j67cCtjrhimCuTlfFjcokbFSKM2O0w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778854753; a=rsa-sha256;
	cv=none;
	b=rwnAgqawaCdiTexJHb1pmvWNwIJSGUFRhbAk1gLkWjmrU9q7g58reESTS7Wfh5yJc9NwT/
	AWOINv3n7GWA3gLkANYgxG3nZlVgOq9kkMgaFoZJHL/yUW/knocLyw3vAOx2rtWswl1Fz7
	tR3ygggyKzgQ2SVBq60Aome4lDGnINw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Z5jTmHGk;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-65c5361142fso12335010d50.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 07:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778854752; x=1779459552; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRDBDq+fY1oMHQKVFr7tarGavnnf2HzpsD2dAXXMIQM=;
        b=Z5jTmHGk/0KY2gTLN5+fFfCEY3v0AGwoTUtLpCfNIZgLHsXV2spMyLJblH27rvVJdp
         12Lm8i87OY/4Bo+niJ8OAhKyq8my4RnsQmkrtRcZAdRptIeiJsbVmhVfjn64Gzq/9sYl
         43ECS4BYWVajXuKwhC+s/kgLIn8ITytmEy37Iqa8LPjOpjxrovmkm64YY9vbFi8MA4Vt
         dpjvHfyH2HO34989aEk3TvB1thx171IG0BwkVbbDXibLG0ksehEBcCTpPaWEcRqKJ0oo
         vcK7FG9VjYnKMFXtvvxKXI6evsgSv70ea7dwBcmcyI4BxJ7L8OHxLzeQtMghvZO7Ya2T
         nLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778854752; x=1779459552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRDBDq+fY1oMHQKVFr7tarGavnnf2HzpsD2dAXXMIQM=;
        b=cHW29aegePhbeOVQpYDPXPbukXKDacPLaI+6vE8RUtolfgDYO5FBebo5SYsDwVT7Vh
         aUxhGVhFBYyEUn0fq+TlW+Ht+sCMAo3F1zSwTQE6+4Ygk9+J5PZOZGD5Io+KECcf2yhG
         DH+ItvDF6acVY7xoIXkrBj2KLCJS+GxpejJ5Uur4BPdr2aYeEbBGSv39jLhqZjaC8e4N
         VyTfx1ejdEZpk+6aa+21KaIZNFOPDppEX+HtD4IhnEXUHLRvLK/yjMEw1ie2RxWu6Yu/
         up3tksG/6zqhGFZ23qb6+cz+gGDypWdXHw1n+3AncPm7yDjpbD4UOCzNutJq6hdJ4c2k
         ic4g==
X-Forwarded-Encrypted: i=1; AFNElJ9J51xMEiwBiV7RB9hsXqXSQy2MAth8q7bT9FUaXRy21Rzfvm7Aq62qHf2Xz9k+5GcCB/PRZJgVpw==@kvack.org
X-Gm-Message-State: AOJu0YyX0CQp18S3HHErOzZtYTM6I20ARxj/AKYaFkDFuonadUcTGrKw
	qr6PJsrhzUKSpIXCx9p5fBa8O1FowDZN0HmTS2gYe4agfX3uwruXbE6XF2XlVIg0M3g=
X-Gm-Gg: Acq92OF01+tQtUaSy205HLq1yEUq4usmfBa1tVMQGzHW6E4ra+1MlgJIqK8nJjgi3eX
	Q3vsnrf3epBrJxaLTjS7hOwToxplK7gLOO8qDT1uVe8bORObz8ufRkMUu+nuitVVuQ7NGEXi7rk
	EVJVfPIMLrPJNM3Jun6VPph92aKWYKyq+K9OXjz4KP5nPILgSIH2GOqPo584aS9e0V9RRiP2cmA
	TKxEtBczmRx/C5IOZb5pV6cebDD0/kEPb6YWClgNHAbzpAlTz+Q8Ei3QBCCygOMOJ4AOo9ZRrA5
	GJNv19Vhv3LAXzsOfeJWpHSOBBY2qAtWr8TItqsacfyjkyE6t56vPwgFdTHmHWPqbGQoO0lEhl3
	/WuninsIviiotYZGyZWMSE1tTs4ZSofn2m5acz1AVgKS2wOff6sSjkqBhv/0ofp+BsNMW63LooK
	I/oCsjwgp4tUXxMszM2iFwTZ+IH9tnI+jrpJt1Ghcc4HnL/VkNDwQ=
X-Received: by 2002:a05:690e:1544:20b0:651:bd70:1622 with SMTP id 956f58d0204a3-65e2261db18mr3576259d50.10.1778854752017;
        Fri, 15 May 2026 07:19:12 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c359c74sm52887436d6.45.2026.05.15.07.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 07:19:11 -0700 (PDT)
Date: Fri, 15 May 2026 14:19:10 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, jasonmiu@google.com, ran.xiaokai@zte.com.cn, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, George Guo <guodongtai@kylinos.cn>, 
	Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
Message-ID: <agcrLMYHwcEi8_G1@plex>
References: <20260509024415.33190-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260509024415.33190-1-dongtai.guo@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4641420009
X-Stat-Signature: 3h54udgoui35zdkjakomxzj1jp6fci9u
X-Rspam-User: 
X-HE-Tag: 1778854753-586102
X-HE-Meta: U2FsdGVkX1+8fwLCTVDb1Y5ADzY2PcPl97sY5y5fKnv9hYn1YgCRqVkfsm/0XKigQi+HnGP5D0mVrz7K9tHmyrSaqZZLwvVVXW2Jyish6JLD3KHaRmK2+YubHf5Tmb3cmKgpk5L3CEElqHQQEVwhtZ+EAXIOga75zWTHcTUZ7Fz9dkUYk6gxvnt36EqJ+LWnJsaDkrjgwwJW50pVsxFXsa9aDlK+k8PNk2BpgN73OJJQLdjb8C05rKo1/pzS8jz8HZ9aPAih+V+sH/nd2wP0FLfuz/Bx8Bm7cE/ED+UbbLiZ7AJT8/xOFklgwmYbfiH6OedFrRJxB+m+Ep3aR2q8cjwrH4xWjbhQNgv9B8ADvkcxK1qwA3D6bwhwLdy6iT+UHvSP/r1VjAcT14eVRcpAjgMdS71gwW1ngLaBvxYOK/uB1YBWcwAB3VZiMRGgz6fXvxZSkS8T5CVQzsgjhGIAKaEwm7BsCy2dYMzowqJu3I/Uv//KfbEtVL156WGQHv5aOOTEWu9e0byPAMvGyWZUZMt0bcCppoKfX0GqL8b+yvYQODZ86P52CLYyNwz2HwSCOD0UKzDPsrkDttw4UXTSJptKvgSFdbkspp1Pov2Kp/Uf9Ky0qTDYN0v0EWRjduh/54Mb8b+6qGESImOtrj5Fjddx16dAW/s92nMwFy1FErO7c43WiE2omhJH5IsxKxwhSoY2jZ8O/bN4otJI0RDhXQ9vfQZb2GT34IZ0Omg2a9Sw4T4AvYpueBbNOpltMFM8UL9OIvG2XzcCyOB2NiGr8ZpcZv4Xs2BPSJGc5s3L50BHIB8z29CoxpF2dm8Tf7puhPTFJPnSFxw55aSFOrZMjTq2lyoADVcEhBLD63YhhaOAtCK0R1vH59iJOJBK60f36czY+aS40YOVBjvOBaKtsuCBeSNF9bWsE+qlMTI1Lquz9RbhWaEHp4JCHD+er+M1QUir4gZAxjR7aV9TQrF
 MSA7DCj9
 Lbv8vO5SqVufUL0w/pqfGo5mxiFsLNW0mtwe8l1+OEN7Nx1OY87mFfNbB6u2kDHiY2/0GlUEE+n7YPrUvy3zBHURJSfzZa7kHnAz3WJchOndeOlxh16GK1gaDpQ8F0HHRbXWvwD0UdHM8SPTiMRcu2vrxOFi1+x94+80S+vGXhUoJLqsBdNUzif4mDngjLU0uNj7PYUq4Wf50k+mWRXrqK17YuPyTYKklKBn04MNdK9Z2J3W8FrgLjcIYKmpR5Y6n+mVjpXbGueCAUadRZOETcyl2jIpujCEPDQIP9Bx+ZpXIiAYo/Z/Akct1VtiDHFv/vqGOaATMbzZFkAQzUSfHFPsn+8iRnBushabK7w8w2ORz1sHWr+rC4wnymqkKJnsPFSO84bHVVx/EV+8Gmu1oeaOwY/Bv/i24Ieov
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-09 10:44, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> KHO_TREE_MAX_DEPTH is calculated as:
> 
>   DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
>                KHO_TABLE_SIZE_LOG2) + 1
> 
> For systems with 16KB pages (e.g. LoongArch), this gives a depth of 4,
> with the top-level shift at bit 39.  The order-0 bit sits at bit 50
> (KHO_ORDER_0_LOG2 = 64 - PAGE_SHIFT = 50).  When inserting or reading
> a key, the index extracted at the top level is:
> 
>   (1 << 50) >> 39 = 2048
> 
> 2048 is exactly the table size (PAGE_SIZE / sizeof(phys_addr_t) = 2048
> for 16KB pages), so it wraps to 0, aliasing the order bit to index 0
> and losing it silently.
> 
> On the second kernel, kho_radix_decode_key() sees a key without the
> order bit, calls fls64() on the wrong bit, computes a wrong order and
> thus a garbage physical address. phys_to_page() of that address faults
> in kho_preserved_memory_reserve(), causing a kernel panic early in boot.
> 
> Fix by adding +1 to the DIV_ROUND_UP numerator so the formula accounts
> for the order bit itself, giving depth 5 for 16KB pages. The top-level
> shift becomes 50, and (1 << 50) >> 50 = 1, which is nonzero and
> unambiguous. For 4KB and 64KB page sizes the depth is unchanged.
> 
> Fixes: 3f2ad90060f6 ("kho: adopt radix tree for preserved memory tracking")
> 
> Tested-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

The patch fixes 16K support on ARM64.

Pasha

