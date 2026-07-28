Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B3FC531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE526B0095; Mon, 27 Jul 2026 23:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AFC96B0096; Mon, 27 Jul 2026 23:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DFF6B0098; Mon, 27 Jul 2026 23:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7E46B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:05:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CB3E4029F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:05:32 +0000 (UTC)
X-FDA: 85036694904.22.DE5B022
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3BB4A0009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:05:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=CmafMry4;
	spf=pass (imf15.hostedemail.com: domain of 1270243756@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=1270243756@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785207930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnRcQ7cU8pyEx4dSK7zQyOxb8Aouz8WcbrMEasQibXc=;
	b=zH2aUMKtNd68+zuYB1Kp8Uya+NM87McgDJkmcINywoeu+rLn5h4i2ZiOJd2Gj1akg4zYIf
	eCbqABVtMCbCdYqmrrQ4+KCeq0BW/pc9cZfypX6W5fgmKMbOT/kLM3ny8bMtwovbm6rlFj
	KslMCkhVpBIm7ZXSl/TCCpIY7VuDewo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785207930;
	b=Fb/IfZCcUrQTC6Uo3FodH9BaUtuknnLz5auPdANZJHK/t4n1Y50V+LkI38n5+QM0gsnxTm
	D4w8UMzjaoRE1uL8it4NsKkFMEvU7nCwb+ag+Oysr35r6xdbfXC5Qu8BrPJgSmwSeDsVxQ
	zcbJoiUbvdnc7T807jPQn+OBhgyHvuY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=CmafMry4;
	spf=pass (imf15.hostedemail.com: domain of 1270243756@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=1270243756@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1785207924; bh=YnRcQ7cU8pyEx4dSK7zQyOxb8Aouz8WcbrMEasQibXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmafMry4/quM8POgF1S8qbIgpjsStTg+sB3Ex+JNmf1Yj5ieK768LVB1ZU3OgzUUC
	 aNN7b2jc7DDrhCFT+Ii3IvRrO9HACst/w6cR8xcWFklg4XaD1PtaBJQvXwB9dSBrSz
	 DkeGMwUPeiyXhl9gYLKrVgwOxh3Xqr7/kEDdX5JM=
Received: from LAPTOP-ALARVMHL.localdomain ([139.159.170.90])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 153874BC; Tue, 28 Jul 2026 11:05:19 +0800
X-QQ-mid: xmsmtpt1785207919tqwwl33xx
Message-ID: <tencent_381E310D1F05DE327C2607824BFCDCFA1806@qq.com>
X-QQ-XMAILINFO: Mk/FYBttBrlYNA9keDMRg3/WnxvXyxOMjRyQYpTXHGGjQFaXQUM/qqXvz/eLQ4
	 lcATL5YY9qfmmiBa7vxq30P94tTsVbk7E5sw1yWdq63BeSE28tLss4GAV9I0o1Nb+MTLPN6qx7Ka
	 aRTDsl9cQQfp45SJm3R6u6wAZFWNDQqyYZVOoExaatSphL+AubeMCj819nVS1fq6UTvWB6pL0Oc8
	 q6BXygcby7jjUVGt31nclcwZxXxIj95dPrHetnnfOVQwOpkRpus4T5Bm9Ptr8IqMKThTZBbAvf/U
	 XQYn/uHfNe2+fEyvP/78R2w0xLX82lL+ELxAqxeVx0NCBR91+OljluwaYKNLzv3ycpN1u3iyw4xx
	 W57S/jVreNkKEiun5QXt7lfJm67e3hRJOUSCe5LHeoy9eqYZ/jJ7UcfJD+vbmH9mWcU418/LIJ17
	 zmLtiu3PxR0DgELlXjou52XVIB/w1tuBmRDOtd5Bw2ngA+y8aKrE618soR5yGQ/5muBDgz3HwlwH
	 KuKehJePBRYi+hZsvuf/asF2xhK6GV4w2Cb5lM4qvuaBZb4wwDZmRGFIQCA3U7cDCnkpuG4oUThC
	 xRnCI7KvZlyiwwT9WMfMwd1qt5IItZtnOgOgYtfUgzPsCIEsS0pNQDJGm3KedQsRosmGrTFLvcyK
	 gJISHK4l/Z5sT+Be1ChGAjlEuffulCZVWJUKjgz1d8GVyXKqziWzi3Z0zXBx23ete4mMoymGGw4x
	 YY86bAbwhNWQm6U9lTq2HSDwka/7hnogvALdKeP1gskr97j7RZAGEi5uTxjD2ZuyvD/0qnIJHVTq
	 OXn6qV+aaSpYqNsvdgYF7DAI9JlGVCi76awmutNROMZUNMuJo1Czc6FUn5KxrkIXZfeySDSy+THY
	 cW41l2jaauN9E9g2676O1v3Tzicc/3WELVCwVPmrW8msodR2BxC6Gp+g4tY+s0zEBd6DAj/lI6OV
	 nwXG6TvhE1sIvmbnM8xclQz+rUDbpfz06PJJWr9CEgfYTe/AbeAJbt4G9mEo4nzuW/D+/8IsJhot
	 Et+n2o1bfcHSHh5gj7pHoa9ic71AOfpM94PVvVsyq/CdM28F5C7+kYUaoEhDs+a1pv+31XDiIzHe
	 I+cX+1za+CsCrkzBc8iLe7azYs4A6v726CIh3SNmpfAanIcEQvrI8dWhvYDPZfYAnAGsIXuM+IZr
	 6uqDA=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: He Jixin <1270243756@qq.com>
To: kanchana.p.sridhar@intel.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	ardb@kernel.org,
	chengming.zhou@linux.dev,
	clabbe@baylibre.com,
	davem@davemloft.net,
	ebiggers@google.com,
	giovanni.cabiddu@intel.com,
	hannes@cmpxchg.org,
	herbert@gondor.apana.org.au,
	kasong@tencent.com,
	kristen.c.accardi@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	ryan.roberts@arm.com,
	senozhatsky@chromium.org,
	sj@kernel.org,
	surenb@google.com,
	usamaarif642@gmail.com,
	vinicius.gomes@intel.com,
	wajdi.k.feghali@intel.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for compress batching of large folios.
Date: Tue, 28 Jul 2026 11:05:19 +0800
X-OQ-MSGID: <20260728030519.269154-1-1270243756@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3BB4A0009
X-Stat-Signature: fzcmcrass4a3et4p7whqdcat9qo6bjuq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785207927-340801
X-HE-Meta: U2FsdGVkX19QhvL0m4ZlVojIn/TCOe/fIw/X8PhYmkX8BWZNZAxfb3bSLIgEC1GTKPxBVhICYF+WEv2nK85blUcYeN2QOkJvXgLTBBMda5Prl02x7KhTBekoCVqj7D1FcUOZ/eGfBniZc+5Chg0l9oG/BG7mX3hH+tuh+0EGVDPtHaeES8bsJaV8q9maxzeG4cgVWFoGXVefoQFaCuHjUio8DJYc5z1rMNBPcYoM0RccetdP3/Fg6tn7tITnahjrZ8rdp58kSx/0foYjWKs7yxhSX+FHHKJ0fVAm9O5DKmMxlilM9cvKNUlEvWgUht2aqO4jRJKU8tba2/djCoxD95y4CNneJoqYRYQCf3uuFueV+gWF64mauZENIW+F8GowKJ6Q1AXEHGwlIbOOJM4eAtee8MgCnN9IpCVjQyzc5zd4gAsP8MwcvNX0s1aQjaehP8gtlerdF2n1irLCGI32w2LlUFt21L9RJ68W9t2Hv3DHN60uEq9ceMaGHzfCxtoin5o6JbeCCOXkbghC+2nOFxJvTBaUBJZ+K/t4TwD8ApRe7SxsuwPBGUpCdmaSlNKa+sW8i46YMm97gjBg1BOY6MmAfARiAnjgTLkn27SSXGA1xZ066Eys0m9cYFWC8sU835/hMTfF3xR49r1OjTIyVE/LRT8BfLF+XqaBjT+dAodW0o4TQhHgpMNeBlfYwjCB4typk/HtQN4jVk7XfMigwK+SD/S4LgibYAPeRpvQIsSrIEjRoF5rT6tzfGqFUkHeURReDPAZV1JcyffyD3WhUxg5ggF+dh6D2r6KPAbl4Kb7MxMD6D3TgKG6yXGv8Q/02vBeIjILHVc26pshs6nM1apRQyxKUbjcCkzXMhmydWZCO+8GjmYdYztGmMai9Mg65ODgPmNPvhdr3JWcZMta+SYjuiRCszvlmGruzJnFW0Lu5LghekQ36ht4iTn1otKeP3DdULh1Nc+XtqFa7M9
 ZNPPS2t/
 diwaZ6s+HDA1u9KtepQZ856KEplBocfn3F7L2DC7WItO924CGI1WdNENRF66hcVjIURazFa20junXeoRo2s2oGn7sZK4KPWHolte7HsGoJ4hanBivhMiVXDhU6OjLxZPJxX0nN0DkBeo+FhPI8kgiO180cklvuy7YxJ2/tGHyhwIXwIvbgt7hKJjhppCMt+4Gw6gA8irROLXxwWmoI/cIQVP7GkGSXmJElbLf7dK83sIbDALXTeg+Q9NPovWRRthFJFMFhk/4wvpXpspPk+yLkzCrUFXVZlTkz+tM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 24 Jan 2026 19:35:37 -0800, Kanchana P Sridhar wrote:
> +                        if (dlen < 0) {
> +                                dlen = PAGE_SIZE;
> +                                dst = kmap_local_page(folio_page(folio,
> +                                                      folio_start + batch_iter));
> +                        }
> +
> +                        handle = zs_malloc(zs_pool, dlen, gfp, nid);
> +
> +                        if (unlikely(IS_ERR_VALUE(handle))) {
> +                                if (PTR_ERR((void *)handle) == -ENOSPC)
> +                                        zswap_reject_compress_poor++;
> +                                else
> +                                        zswap_reject_alloc_fail++;
> +
> +                                goto err_unlock;
> +                        }
> ...
> +err_unlock:
>          mutex_unlock(&acomp_ctx->mutex);
> -        return comp_ret == 0 && alloc_ret == 0;
> +        return false;

I think there might be a resource leak when both conditions below happen:

1. `dlen < 0` enters the first if block and does `kmap_local_page()` into `dst`
2. Then `zs_malloc()` fails, hitting the `IS_ERR_VALUE(handle)` path and jumping to `err_unlock`

In this path, `dst` points to a kmapped page that does not appear to get `kunmap_local()` before `err_unlock`.
The old code had a `mapped` flag and a common unlock path, so kunmap_local() was called on all exits after kmap_local_page().
After the batching rewrite, the successful path still unmaps `dst`, but the zs_malloc() failure path appears to bypass that cleanup.

If my understanding is correct, the fix could be either:

- Option A: Add `kunmap_local(dst)` right before `goto err_unlock` when `dlen < 0` was taken.
- Option B: Restructure so that `kmap_local_page()` happens after `zs_malloc()` succeeds, only for the compression-failed entries.

I'm new to the mm subsystem, so please let me know if I missed something that makes this safe.

Thanks,
He Jixin


