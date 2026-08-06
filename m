Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41890C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534B86B007B; Thu,  6 Aug 2026 03:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BF16B0088; Thu,  6 Aug 2026 03:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448A96B0092; Thu,  6 Aug 2026 03:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 257126B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:32:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07F1E8067C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:32:42 +0000 (UTC)
X-FDA: 85070027364.02.7D9E97A
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15E8E1C0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:32:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="z6OiX/70";
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf21.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786001560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2khMiJO3zHYteSsGwdKy57D9iUTZKywv66qzuT92lpw=;
	b=b1CZWypmJIOic8CxCbx12YSSDHoPDRc9DenGZY+JS+OKeOYh8YycknB4/z0nduiCzyLlxC
	r4yEJahGRu3ndZiuWxiFyQpdTK2anKKiX41R/80Wx5RUva20MOQhVFTXpuN08SO+MXomdC
	QriT4RpLjIRPRZs4tkTMnKV1eqiduXY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="z6OiX/70";
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf21.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786001560;
	b=BiDWQwIFr2mUXCcFm/zwA+Bd80mzuL7jpjgD10qEMJ+SaoMubCC8drJTk+GWrCZiATVsDV
	H68QZAXarSqA53jnpOhLeIvn9Dyx5G31o+9dqUJYPTBRdAkPGgBACCh9x//r0LjbSx1mCk
	poB31Xhr2Hszkd5B363qAumWdxLi9v8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1786001554;
	bh=2khMiJO3zHYteSsGwdKy57D9iUTZKywv66qzuT92lpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6OiX/70b7FIstpALrkdGIoczZlUsusF3bjHnTJ9xN7x9ZUX4mjBovsy6pRboXxa6
	 0+MLG+CaXt6CW4Km7xQ0L7ITM8I2qbdWSebE3o50Zjv3mjINFMndZTa4bBjzPFSjR7
	 tK0m31n+o6roaD795gKQakS2tbnU9r7DclwF6viI=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 81F81CF6; Thu, 06 Aug 2026 15:32:31 +0800
X-QQ-mid: xmsmtpt1786001551t13d4u295
Message-ID: <tencent_4DAA4F0D677A7C544D9448170639A4524905@qq.com>
X-QQ-XMAILINFO: NwU6Bou9okj/XektyZBe79R/S3EaKXnh95MSfFXour1bWJ+cPySnBK+GL9ygNi
	 jJGJgCD6J2dxfmnCjeJ65A7AxT8RvlGNTtoQHcxfHwd7ZeP91yjpHNOpyox2WypVu+pf6GSLShP2
	 S62p21iQ+gHHXFioMlaXNJrgbfwo44KTqMrvTI4O08I7bq7miFtXnVumd5cxDiKO3Ix6PHWQHkX0
	 3jIYF3u+lIkI9ofmtcyIWH/UMKs4chPWZYyk1Ou7Y0Z8JQwqaTyCxU2ttbsrTIWkfk+J1EVAbDpk
	 rarvFCE/7YMbXzZxTZMgyU5Os/leE5WnKAwC+GuHgWhYU5+oKs9Hpjho/7NjT6xiVLIDoNEL2wTw
	 gZ1KOEdGDEtgT1ZX20gIsHkPiS9W2pPXnpbHcDf+4ymX1U7Lkq6li5uyiXt7F66uryJ6O3Tl5+wX
	 1M94KpldXF9klGy5oJMM2H/OJHCC1yFMDtjpUZDb4oEO/jKbrygyy18l0bxhuskuVrw5PiHAtf01
	 k3WwCKuneFnkFCpWxJPJCnwltEzj0+e5HlGJ0VG/XoOQsx+TBSnOb7BrffqnivTowP2DGnlGM8Zz
	 KEb9wdcu2ehfuriCrpRKDl2gfhDSRK7jEY0XNjM++JeeMT9PfhYpI0uk9KXG5m+dkhC77m1XeYua
	 Axr+idvDeH9sNxstH6drGwcH0qUVMyCA2x9tWd/5QJ/jfjsO6Abt9hMBLub6LzyhrGCyxjbT5MLj
	 5pNF2bHah5uetb0Jsb4Yau76DEuLbh50slzN0ER9nKuKcUZzFf3/bximrtrT3B7tzghTSRQcOrZ4
	 w5SBWhQmJMGx15hPzBclLqNQQRRNdjo8bFOmVw01uBMBKqsvCzJCr3oziEVL+yVpFeAE9Rq31Vz3
	 fT/gP9WVuFSzQCYLgBdiC2bSkmhi5NQitw1UE7eC2ediN1k8X1096nxUVQfHo0Pd/9l6dynAqKsY
	 LcKcdBsQ8ETylV9f1OGcyX5kqHpFlHwqv0ljITERjBwBQdYScAvVPSychlPdbgi1rbldecH6uUo5
	 hyNMctrV1X0IulpcK1
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	vbabka@kernel.org,
	hannes@cmpxchg.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Thu,  6 Aug 2026 15:32:19 +0800
X-OQ-MSGID: <20260806073219.440594-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803174817.faeebcc4fc67a053a47548b4@linux-foundation.org>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com> <tencent_B9556590D4B65ACF74C06897689A6E39F206@qq.com> <20260803174817.faeebcc4fc67a053a47548b4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: wi45ct5o7iuwazse3absdrcsw6ojx96s
X-Rspamd-Queue-Id: 15E8E1C0007
X-HE-Tag: 1786001558-431891
X-HE-Meta: U2FsdGVkX18NQT2SLCca+zDEIW8MoID/59aUamh+oCjyo9IxEYht1J+Qzli/gCWOC1pl9viFv69XYN+z9sfTMDn4LLSkg/+nZrKQaEvocjzmNM5hVlSj2yuat1oqR6aBPRnGmxc+YCghamoi4s4pywWfSnmNCCNqNm8xpq2Tt18szO7zab/ErsxgfsWuFpvUEUbjd4MK56udnOvyYrdLU5aB17Qdg5MfOxKVWRzeQLR9AzHElGy4qqzYCr+QEGOKepCVoVQv5+U9AdbFlEvptMXJviU0eCbHfSd/OGSsvES8GwHQHFdU3gPkeU6BiYcC+W9Xq2MQqOgYE7ziUAvw4J+BgN63n0u4mZ5mkOb8MQVhpc+NDbVkc0Mrx6DaG5bCkc4B8Tiv96kLFRqpgRPzhmmMT7Uzd5zSBLxFdJUk8DC7N48cSBsYxK5i9ANSk+75qsGHLMu2/Vv8BP0RiO79iYc828O4zuUrxd634cedOMRc+0qmITpvGyBx5SJiUyzX8of8vdHNQncP9aRzAPyxCvQvGnbcKcrg0ekBVdY7PNS7OJiKsffJavbQmKdXDw2NUAbkqObrUz9DBtuizFGgNfNjVY5a13F0dPKnUXPv+HoczTOH9L4qna8zrzQscw9EKsQRL/TVqFeslY/QM8hyrvVffksNccAIZM2jNwKl9qwrQS74Tnbyunc4OtyvVrTuOuaG3dY28hCkWUGmM2PCrqVappxUc3VI4yl1wuLFzE7SroIJ3YjYrYWYKv/d3MgtyhJijr1kV8eKTUCtt4X4mhz/Q9UEqNuMDPQ+2BIH0HIkDXAZxdoZ+1FdUHAhyur6jBdp5wwCbnJ3QwADL2DdQ9S/HnhWBrxu0Lr2eJV1uCklaCS8py53B3BNhZo/5t4ZXoon1lEWXMp4FeLv1cjLHHrLIK0wUBU5qj/+pqz2ESseYj/Pllxmxie7TbeA7KN6rIUjSlBfWAIUfHR4Ozh
 yNUfFOoq
 GylBmMYzxBpTgwpFQ+NJ0LntFobfVUEbmIsoIdIi8iGy0owHsw7qySmqBy8zyIo4T8p42cUxxsk+JGXVGNjd9FLaP4P10C6FmmBU1TbRrg5rpO8vwRUguyQlk3KBbkXqaz8aa+r9UniPnNWccOVf+NpdofEo+FN8Y9wpmHZlrQ+LlCyH0UYtwUxjDyEqpm90lLzFBIGLI+qbfrmaXin750oOPGePJ5HM1kZeQlst19EOfkIOVHBo9Tvrz5nunDtzQequTvywr/8rVcp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Aug 2026 17:48:17 -0700 Andrew Morton wrote:
> I find this a little tidier:
>
> --- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
> +++ a/mm/page_alloc.c
> @@ -6926,7 +6926,7 @@ static int lowmem_reserve_ratio_sysctl_h
>  		int write, void *buffer, size_t *length, loff_t *ppos)
>  {
>  	struct ctl_table tmp = *table;
> -	int ratio[MAX_NR_ZONES];
> +	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
>  	int rc;
>
>  	if (!write)
>
> A bit more self-documenting and future-proof.  What do you think?

Agreed, that is nicer.  The temporary buffer is meant to mirror
sysctl_lowmem_reserve_ratio[], so sizing it with ARRAY_SIZE() makes
that relationship clearer than MAX_NR_ZONES.

I'll fold it into v5 and send shortly.

Thanks,
Jianlin


