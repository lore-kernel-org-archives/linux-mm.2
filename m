Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E5CE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC476B0005; Fri, 19 Dec 2025 14:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6871E6B008A; Fri, 19 Dec 2025 14:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589A16B008C; Fri, 19 Dec 2025 14:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45C296B0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:44:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E67C516015A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:27 +0000 (UTC)
X-FDA: 84237247374.14.3550887
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93D2D140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766173465; a=rsa-sha256;
	cv=pass;
	b=bupYqHLjAhulUYG3qcsymaHRyHRhAWBq8ZqiJFx8/+FtX+5uPMXDhcml/2I4X/g9ySRKfe
	NfKej2ID/3FX1Ag34/gUUUzOUB7PuB0jxCAfZB6OYCyFo4KOH/+C0IiPt82RIWSJuF5IwB
	tdxFILHaIOglhAeV3MlpDYdgJf+1qqY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAf7fTFUp87eNqWjmH0abD/uFyuT//fsXVh8ggzpMg4=;
	b=pZmiVEea+RgrBDDuI8dU67+MmO2XHW7rpDwe4azsu1C3Uc0qQbICs7F96f0zMOecxio55o
	feKzmnz++7TdwUmmqCBJ2BbW+fc0nBQ1uoZV6eZvXeVfgMh+X8+4E9OEhal/Ll6uPB1OP+
	o4TxBYOeIoVBed1M/wYf7zEGyJQ/r64=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35AFD1A0395
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:25 +0000 (UTC)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FDABC0716
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:25 +0000 (UTC)
X-FDA: 84237247290.04.0C04496
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A5B9140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:44:22 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAf7fTFUp87eNqWjmH0abD/uFyuT//fsXVh8ggzpMg4=;
	b=UDRFWLsDkIcfBlxUX6sL7JAokcwVGUhpvHzwNuR7Ymfh1nth0U7VW1LwJG3CanJh8blraB
	xqfzzKoKxrUTkx8mEHQI7r42NAzjbG6Rc4eAve2tCxBnXJWuykVUtXLYIfog4gp0j9o0e3
	LUGDbpWzQ1NI9H8WJRd2LeGOqCzCu7k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PCalkJbI;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173463; a=rsa-sha256;
	cv=none;
	b=1U+H75Dz7YcMyS0u9ftB+fg4mEf/+uItu/GB/CPCSy55YeWOHZHqZD63OFm/3/SC9yhXzN
	4wNYW7QzzMMxFnm9REf22tPpOVfnbAWNN9csHk30ztTSFaTxcvqEJboTRlB3iTaBfwvGt9
	gIULrZJKFlikf2xn9hfUFXeaF2Cj1KY=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0d0788adaso19330025ad.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173462; x=1766778262; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAf7fTFUp87eNqWjmH0abD/uFyuT//fsXVh8ggzpMg4=;
        b=PCalkJbINjPmXTVCSEil+krRN4pQzQFgSzuU3kmzU46OjbH8UN1nAYoVK6UQrXc7Tq
         L/xbt+bRAAoQk4axuWU1jAA9qT7W5y1PqC8uEZm1OauGSa9IwWEwOj0jas7N1N7UeoBm
         SCzGqOGEWzGIdW3jn1Juxyg6DxiEJR0hHka4DpggDPhDE4JJWy2yfz4lrmui4Ke77BDQ
         /BlVQYlB8X1edsT9y0U3FpYUryOOspFlAg61g6J/e6D+qYFv3+UGUQvya9IswGLos3fd
         v2X2PSTqbx+s7lcV/F2NsqeAVXtQgl+Xvxpgtjjem7kueicfXoVhcHtpNDdFGyX16k9t
         3auA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173462; x=1766778262;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lAf7fTFUp87eNqWjmH0abD/uFyuT//fsXVh8ggzpMg4=;
        b=B6hzG9QEkiD2AqXl5bMAD4S4cYRKxkkw4QrGRGNhKf/Qgia8HvWUQrl5t04SFyPrQ6
         IPXmZ4QUl6LtG4S8ZMQGIQiQoK7/ZZ3uf69Glddl+8N6ju161zx/RWSstdrxdGR+1Aww
         ER7qdJYGggv1G10ArDrfghewtyZbrr0az9jFdxxuiDKkjH3xI9yKj4YYY1MgoQM64wXk
         Kui9ge6Ao/QH+RmhEqjnL4MmoJRXt/eT79ZZ3vwmSw6SL6sMBYuj4z2VC5rmseqsOb7i
         zGA+sHJ2MyralUVqgR2QidoTnJeUtlRgp9LKFM/xmXavh3t4pdAu3hV97BkQsjxDrd7e
         VlEg==
X-Gm-Message-State: AOJu0YwZwGSAZUN2VedPfaQm55ryQLpQdpseNzHYZt8ppE6X7gQ7eQ01
	XxgRmQdlTxsj22U/TDJzwrsnymXRXwKPiBIyitJ5m/U3GTrMTGdyzebA
X-Gm-Gg: AY/fxX6SF5TEAKjSZd2nLHfktGTy2WjtJI1D232+VtHFocYe7a8HfwfHhiYDul4UZvM
	Jj4VnWoFhC1pS/f2Q3IhiM+btMIDvMQ4Kp6rgv7AMmwyCA4rabxuIcjnQy0GJEciMV8RcQVUiRJ
	c+LrLt2XhjXY63FruftOFKQ/qyb/Itz2SzjDBP0LLBlhZbL2AkKMvEjdeCvrFBXhnFC5OQzGQZU
	u0eoXfL0G8GbG7VhXStLyDj7RnD7+Vhp/AO7NLB8F5XkUA+YHGLRpPOdvuZwn0eGPaLZVVbpPeM
	JGw3fAvV0szCUBGCqJ3JobbMlOlWd6WkoaAy87RUNDsLz1xp4eRf3q83ZS4KGTrDC6Nr20G9bG5
	RLTMwpRiWd3WqR8MHWV7gRHy9lDLsTMROa0zwIPjzAOvFJ59mwkmBJSqqu8DBryEoORgiq1C9gD
	yieuPmSQQWI3nU37fBk5I6uIQkDHrZ+9ND5Biibsp+FfEOHlChzEP5
X-Google-Smtp-Source: AGHT+IE19UvB+rb2MKbC0md7DDnxzaHyFF5mRTAudCyzP6UVbqIF6A/NpS4srCy1bzmhjToSvoscPg==
X-Received: by 2002:a17:903:2f82:b0:2a1:10f7:9717 with SMTP id d9443c01a7336-2a2f2c4cea2mr36645865ad.58.1766173461648;
        Fri, 19 Dec 2025 11:44:21 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:44:21 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:30 +0800
Subject: [PATCH v5 01/19] mm, swap: rename __read_swap_cache_async to
 swap_cache_alloc_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-1-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=8341;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xtF0rZ/4UZR3IAaMqBPWls8Ex5Nkvt0SwdqitL97Xlk=;
 b=KqoERz2XSwvzkqzShTEdiYozhp7xC07oPTrykYjgN8joxIeMU9W3Sydd2xtYzNFUAWidiBMQT
 t3NlsfMpnkyAjVxYghoi89TdeIbTQ7DqPOmnJf2TrjjLDqjNBsqAvGE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-HE-Meta: U2FsdGVkX18Np/r3MVyNjmVrpGuSmOfli0f3/mKAbIXCeDh/6J9J7YANoW4sSRCvyZLtb7cjDGx7ltniWQkLU659mIakT3A3HkVKiTMMEQjecVvCdxPigukgSb8u+4hrmTUjI9BepAbCNMIC0nimFaF64AUQE2JSWNYHxLdE+bry8s/u2L4fNXBjCA5o1D7qZIopo2qGp4smHorW3qp1PhIOZmjopzHHpFtGLx9Gm3o8xp4hdf/8D07O3e1862pAav42mZnLPC2wu0un9ic/81eGlHT2uL9rJEOKp74HKJ5oOuHS4hR0etVKl9vCR0y/McumNbxZjWUvVIyxr1DF6bMoHRW6aOVFPJi9kFu9sI7/6nqy0MijHjIiQQdqjUqJ3NSe611lWaoCGaKHSh6cffNJM9TdIJyACB+ORDSW7WK7zi25kEUW3XG951Euvk+VIxB6z7XA69DGgAUYHfFVmJMtS0mjooVHs5Bu9i09Tm+0J+kiMHsfEfFGN+twsmPqjurC53xMvAD07et3JEbB9jeTn35GeFHKA4IWh7J39sh4Jct0NKoxsyAo1XLxNvDt/wHmWI91meyUM8iN+IHxIMtXbUlfubZVqAFfTZERdwn8/Wb82gdgrx4EnTtiIW5T9ihryo8I1nrm8pu97/qhlNWMZtPNEA1HCRUAboVkc2nPRa11LC1KEJaHc8r5ZXR32qXDBP53sL+he+pMm/9E6c9Mgs0KzVbWsTsgzGcw9rH2jFu9yKeiq3BoZh8IO/x1afpCjQ2xpAcynolsBkYER826Yr4EIHBbs4mUvHXOotFhYjJ4TcNh3uqx5cQ7fVwNskcm4hzTkNC87MDg8dmfaWyiHLoeMQxbZkrabZ7RBMO5ajU4CY4zVVx+7U+PeucgqvfnIXwvr9xpy8zqUWF/0VylsNSgY5hkiEoA6bmyDHqHQpnn8sqOlC9FNWWmPiHdZlxExM2R9n7HsCMjgNL
 I+JRhsZe
 bPIp0FjPKq174M1IJQhuFROTpIfGu32R3vUswV+4SPlAL9jztYVnwZZ7x0pNHHEGX4uDVYPRjBvN0jxEzQKEXceIrrNETewJ1tDVYu7QY2+osTucti0HAnPXeXU1IbV8QC4Idy1BvkWiSREyRxDu+0jyXqilKd2dQwIdnbJ16LvQ/K6aVG2/0hVfTC++mGFZIb0zJbCFQ4JgpBjTM3Ci6TN6y09qIgB1kykfeHBLPC/TUEQHAcMDPuRlkuNPR/kVo+DaTtuBYb3Xns5hlrHJSqBW72opumChzKMtpxbNo6XQP7iKmyQH+APD6KANGtu3BPDx+fhzmfy+DqOI8ebzkg7biAdHicfGawEQi3vBVo15FFOxWTr9k6C4FSQ99jktA/Y5Qw5WCRY03Wk/AqdBcxqcEW9qQjN9uJTdO2ERmzYhM+/IT5ET8UCXxNV6HYbdrt6IXpXYiomznM49tf4GuFxhuJYj6vIwpMj32K0pn44VD4goD4rUofKQm76yuN9pel9Jg
X-HE-Tag-Orig: 1766173462-195021
X-Rspamd-Queue-Id: 93D2D140006
X-Rspamd-Server: rspam03
X-Stat-Signature: e7yf6u55zumdd919zbjzwr4q6e4z5j63
X-Rspam-User: 
X-HE-Tag: 1766173465-816432
X-HE-Meta: U2FsdGVkX19TquJwD+xYLr4Tj8FwovGIv3U0GHW+OIBstX7SorQnrL8WGCjwvMS8uUknmEMu8JmUnjJAUKnF9fM9e8NLwcLxpSHlWOyjdgZ1kOYSDFgubYxd4cX2nSKKwRTNpxfRIC4Mx1YVpkbC0ny75LVjk5pbqfSgYrkotm8TVZ4CFEd3wv+Rx9q5KBFSL29MlbBSEnoirBiQ53W7nDRhvYVMVmB8BGRs1ABpHxtbcjliauPTB8RAh6XiOs6sa6s5JZeBChdKXDZlQFrlRVSsQ4h8vWE2AKvO100VQD5zs+m7qcde5sakT5ZjaqN84MfKQVq72B7Tf4i7MPcYYs4aZChFSNFjwUS7hWuIkrsYQP5BvaszTk3G5ZaHMaU099Peu5lAaQ/OKJH2so5dhjl1mxZzvXQnENQKU4amNNf+lhc5hM6Bf+RsMOp9W/K00GnT4w69+Tscv1PKwzBg5svtODUheU8OK0lDWj7wGuqmM8fL1VdUQ4R2veuoob8zv2Ejuzma0i/nU6s3o9hZG1qbmXo1FYVQ4D6osFvmYxIw85Aka9t2+wG35xRs6Q3Ob8YsY97QoDSKv6hsf6zCKNIhE0EGRYk3gFygXkm4SCPu+c9mKE6rD4rYv35mvJ/WsAvGnlWpzeMM2NSzSCMTTq1ptpNTf1J2+upzuHkyRhupRPqBh08Zrfimh3seyo5lB3bCfyaXIW37krbdJMG3N3LiGCgoYdnRauwmLDwmVLx3wMMhjINi/wvLnRFeFYw1OELQufQeQwxSOUq1LYD4BuAuFM4gEcIHq507Q+Bwyb6cIQ1pdopAYKXepN/qvGIaVkjvJb9UUqTksDjFQcxF8FLo2uEmpLyIhpI8aCkTFsrnpFE833AgLBPCzmHg+W5ys3zy00vQqxI8YrQbTy3DzUvGTFnAbi0BEkklb2R3Xxx3niG+gTVaVgQlkubgg0BmbnJBwiwhZIgcH/77/zI
 G0qkwg9E
 JpBoMqqlKYluWQjTJTQYuUH7D5w/GvkqG2z+RccKFizIUrAZ0CZDYKTpmq1Xey4LGx3FEYqeuzalas6qu80LlLgBxMQXNMwh23wlImzuQbYaxFDSewQgWmWqjAm0BG7ADIEZNtZz/hAgvSwYjJ/7f4500cP6zomr2dmoX1wUwlcANLknwA7k4b55eWf3PbxbQyN+fqYKfLpSacEdJXELw01EaP7UHy1qebQPThG7VuK9AOw4ih6l7OeOxTlbIsL3psKiBJ4PjNMH4jNxsxpblV5fK+3LimI4fCOaR7ZZwQ8cu+JVK5PslD83AqFDT8QJ/BF/6MSnP+tGAyTGGNa32MtjTAkthjiT5zrNXf3ws3gLbHIBePbq7JhavhCyASUclVs7OUYKp7nsB3jw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

__read_swap_cache_async is widely used to allocate and ensure a folio is
in swapcache, or get the folio if a folio is already there.

It's not async, and it's not doing any read. Rename it to better present
its usage, and prepare to be reworked as part of new swap cache APIs.

Also, add some comments for the function. Worth noting that the
skip_if_exists argument is an long existing workaround that will be
dropped soon.

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 46 +++++++++++++++++++++++++++++++++-------------
 mm/swapfile.c   |  2 +-
 mm/zswap.c      |  4 ++--
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd2..0fff92e42cfe 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -249,6 +249,9 @@ struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
 void swap_cache_del_folio(struct folio *folio);
+struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool *alloced, bool skip_if_exists);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
@@ -261,9 +264,6 @@ void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
-struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags,
-		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
-		bool skip_if_exists);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5f97c6ae70a2..08252eaef32f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,9 +402,29 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
-struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
-		bool skip_if_exists)
+/**
+ * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * @entry: the swapped out swap entry to be binded to the folio.
+ * @gfp_mask: memory allocation flags
+ * @mpol: NUMA memory allocation policy to be applied
+ * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
+ * @new_page_allocated: sets true if allocation happened, false otherwise
+ * @skip_if_exists: if the slot is a partially cached state, return NULL.
+ *                  This is a workaround that would be removed shortly.
+ *
+ * Allocate a folio in the swap cache for one swap slot, typically before
+ * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
+ * @entry must have a non-zero swap count (swapped out).
+ * Currently only supports order 0.
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the existing folio if @entry is cached already. Returns
+ * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
+ */
+struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
+				     struct mempolicy *mpol, pgoff_t ilx,
+				     bool *new_page_allocated,
+				     bool skip_if_exists)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -452,12 +472,12 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			goto put_and_return;
 
 		/*
-		 * Protect against a recursive call to __read_swap_cache_async()
+		 * Protect against a recursive call to swap_cache_alloc_folio()
 		 * on the same entry waiting forever here because SWAP_HAS_CACHE
 		 * is set but the folio is not the swap cache yet. This can
 		 * happen today if mem_cgroup_swapin_charge_folio() below
 		 * triggers reclaim through zswap, which may call
-		 * __read_swap_cache_async() in the writeback path.
+		 * swap_cache_alloc_folio() in the writeback path.
 		 */
 		if (skip_if_exists)
 			goto put_and_return;
@@ -466,7 +486,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
-		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its folio to swap cache.
 		 */
 		schedule_timeout_uninterruptible(1);
@@ -525,7 +545,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	mpol_cond_put(mpol);
 
@@ -643,9 +663,9 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
-		folio = __read_swap_cache_async(
-				swp_entry(swp_type(entry), offset),
-				gfp_mask, mpol, ilx, &page_allocated, false);
+		folio = swap_cache_alloc_folio(
+			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
+			&page_allocated, false);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -662,7 +682,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
@@ -767,7 +787,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			if (!si)
 				continue;
 		}
-		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
+		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
 		if (si)
 			put_swap_device(si);
@@ -789,7 +809,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
-	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
+	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..e5284067a442 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1574,7 +1574,7 @@ static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
  *   CPU1				CPU2
  *   do_swap_page()
  *     ...				swapoff+swapon
- *     __read_swap_cache_async()
+ *     swap_cache_alloc_folio()
  *       swapcache_prepare()
  *         __swap_duplicate()
  *           // check swap_map
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..a7a2443912f4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1014,8 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;

-- 
2.52.0



