Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD33CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC646B00AA; Fri,  9 Oct 2026 03:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CA06B00AB; Fri,  9 Oct 2026 03:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BE26B00AC; Fri,  9 Oct 2026 03:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27B1D6B00AA
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:16:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A561780296
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:16:14 +0000 (UTC)
X-FDA: 85302229068.26.641638B
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id D108AC0008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:16:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SpABZ9D6;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791530172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2Zp0tbPzypU+Xc8XKZGNu3Y99smdHR6a9gLWnL8e+E=;
	b=FVDfrCy+gwADkfYcVW9QEynct92Spg5ITWVNeWi2q1DNdfwZfovPJlg6crPCyQdlfv7zed
	ZnUR0bvJgvzp+gXc4ehfeGJ1ziqcUN7j3T+y86Siir6VKxU3xWjnMVKtVxyGbrqnNs97WM
	2DE8//yJyTBMENE9B4dp5GyM4pOvicI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SpABZ9D6;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791530172;
	b=Kkfj68OgV4TRGjg1JSBzGrUE9ZzSSBrPIlUOy/YJKCC0jxhqmkzL9hr8z32AK/Qp9Bc6Ef
	7873gm8jExYD4ystr1NeT77IEjN5qMKV70ZR75KdZnyc0NykUd2eqWYRrZGhydYkzKnp0R
	yI2u20XTaKZrfz95wK7CsG+CIKj/T9A=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3a4d455ace3so3820329a91.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791530172; x=1792134972; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z2Zp0tbPzypU+Xc8XKZGNu3Y99smdHR6a9gLWnL8e+E=;
        b=SpABZ9D6vNsuq31NCQGQ9lPFMya/XT/u6t0X5YvhOcQrYhliMsPOxFt6iiXLPsjjLF
         8DSx7zPaCSpMlfejK6ylPUMR/jf7rhdI6UDvqLyviVZszTP4dCWsy+ApY6O8n3OpLzPl
         2+mTe0CU4L7sdN0EOzOFh5wJ8vyzoGSoxikfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791530172; x=1792134972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z2Zp0tbPzypU+Xc8XKZGNu3Y99smdHR6a9gLWnL8e+E=;
        b=jym2nWWdceTm4muzaxD440kp41ab//QZGOUg6+XwIpdKof2hsZqiiXEElTXk4TMwaN
         h7eAXFGRFUZ2VOD2a8aG8a0qHq5Y6OpEIaHDaWGJ2yaDm5aTU9onnvko5ZjZpFldb3Oh
         As3Efz760Wj6aTNVjbrsxd50nRsww1QuvwKkT5X0zFVk+SKnmLGePbmQJ0vx0wKGxfiS
         nsWumpO/6mVC17ohE4iMzruRBQba4K0bADKGdaqEAqdj2PypUCtM96zJJT2rdfg5DYI6
         FdWtP51/Wxb9bd3/JiDF+LC6lbWyN8yRpBKYLzd7LXfeVHx9wCvUXuCaOi0Yd9z/7jQC
         pT8w==
X-Forwarded-Encrypted: i=1; AKwUvBz4brknRyxCsOl0knQuhf7GucUgz6UAib1PWZdT8O2oR1yGS094MWiI+mr321s5ivpI+O2MEDPtkg==@kvack.org
X-Gm-Message-State: AFq9FYIW2gGpYNwgtZX+tjYcjuDV83Is008CKLYCiMZbRYFIV+phRPhB
	E0eMnRvrurUXmGEZVVVVqZOWGebqm0yKlKZOKMt2LKHNuUlzzxGExShVhKv8qv0IhQ==
X-Gm-Gg: AYBFou0ve7pfU/YN9naOz3jLR8oeYdeQk+z/2yKA/fKpinwOgeVD3rjI2oUCdw9bkm2
	cfxJmss4JUOZqHnhvOPOYJz0qwXT2Z2LDJo25I7Z5djKGv+Hpgcp86gKb9xgNLAjkrkjLadspMC
	cylVUI/vJ/Cz6tvex1TsmsUxgXKJtwhvH2kuw9DZcDTUN+37r7/yxbKDALwm15/Cgr1ZXd0nRzK
	v/J7LZ50wDFfQZQekly+wkB0ATMDcipOhV/ActHwjRH0gTs71rRln4E617JbvVQ6W7dd2SKSWFQ
	+Wf1CRMYEmbeL+k/ZKKM6BWjN8eWZlnQaO2a5OSHmveLxToS6x53eCd6I7dGvhYMhLV+AykiOVR
	k2Fo0cUo5H3HwCHIgKq9xYn3k9ndTPit0iwsGbIBfJhoPdYU40urG6YoBU6xIzHjEJW2yc9WZKM
	3usZQ783xfeSdEnpW2IAvUT1veHMHQ5SfaX/a1j1JMVx0TQrYdgsbDSmG0GYSeFGRcIffKzo4v3
	z61uomVpgowuDjpJRAsnsr9Bc4Pa5UCg9d6UV15
X-Received: by 2002:a17:90b:4b92:b0:3ab:2d17:51c4 with SMTP id 98e67ed59e1d1-3ab3ac9bc91mr1089309a91.56.1791530171629;
        Fri, 09 Oct 2026 00:16:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e557b1sm471687a12.27.2026.10.09.00.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:16:10 -0700 (PDT)
Date: Fri, 9 Oct 2026 16:16:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, 
	dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and
 decompression requests
Message-ID: <asiUXpjrE61TLMxQ@google.com>
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006002307.2669023-2-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D108AC0008
X-Stat-Signature: x5k6sjqddqrja8g5sm6h9ruscqma1hxc
X-HE-Tag: 1791530172-625337
X-HE-Meta: U2FsdGVkX1/3vRAGjuvW7y1vk03BPvYJ3gbqQPQp4wLMVQzUcdzCyKZyGuH7zvZUm2CwUV+aFcBkEzLM1eyz6ywLFrW5MyxmMcfEvb7T70XPp6KclwdxEn/uSn3YXeMbHuM+0LC5zJ45mmsAmE+yfvkPOx+BM9IuzaLgJvGJeO7J2v67jKg75JUp6MSkr7fqWjs5i4neK8a7MbP0eG9wHkuCGMo1kmhja3a2s6rWaPqSN5xHRPU4P38TxULGc7cTFqAaD1sPVeRutGMCL0b+htboVXrsi8f5w+59V+tJzGAJuiM16hosY87wSisP0kpVGIqYuMHRXwpqvYSCfFMSFqKYe2QEFhk+3fpn7ZtvSPq1igocxRQzrJMmAVETO8/5ih9Z86YSbTb3COytjtMKJkXDcAOskC+uaxnBO5YRq/OSD2scrISE5R+lzmApnAar8rkJ8NmRSBYE8yrVqzzSYViaw6RrDc/+bfIZnjpHfpLNSiLHqt9PFSUGGIIC/y6skSVv6DzcOdzGi84yMbNxLQM5Snnv3g0D77yCE618jkknt+t7W2aEyWLpfwd/CLlCUK1t2BAmJrmyfDyisyekoPO1j01eqY0Bd7lDNKlfDoWSyESfX5R0A+CaycBKKaDvVygwVAf+GJOEgUl8PYpUVA2f/xLJWyud7w0C/xGqQUtOEIi6z3OIiJYHl8lqYL1sUmXoYvui8/mcR+Qu3y6fzloyZcy75nwAMnjQA7HnsWzQ72X/IpUjsfzXtYNDU/hSP3XB4uBcRsSn2HMlwvTmq5P/YtR52m2xhCOHRmznlkg6uWYseMyOEGSRFZIRXr2uB7H06pWPTxyhg1VSDwOXHm3nHQ+FZ8z7Wk0ZvTa5wnBgnkdtIMLc4JLcoZnDprQ2HWYuhGOEkF7ISA01BQXitkefs74j7zqrm75tffSIZG4gAw7CUd2bXO7CPVb+OZ3v0c1VIUpxsTCbIN4QG6P
 9nRwLmUt
 BDcZEQXsC4xMsadpVy0y/SwPZFhRV+xAiN9wZH2c/eGnSRV2Q8n0jdoM3UlZrG7i7kM3anBiON3y33cFVsHfKVYtUnmHFJv5V3YFZvObiXwiN3xB27QHgeHqnSkQUDF+dBy8lWK3gVmXssrO5bMZmeL1AM5a3atgARwJmTCmVhe+UC1sLC0hkg2kEWwPAcBnNfI8wOaDqhB5AhfoDLaGkPsjNDhSNAB6BAR0oUe8D+IB5sJHmtcnn2X9mGb1MZ3u/u2+SWtXk9s5d17xvxpSmYVij8bNcfdW53m33qkOKYNcwlmJ8KHnjRpLNyuDoeIjTHTFs+if6Sg2fx/BvdHaCR9+1npqKvvRQUCdHiMH97gE7+wCZPA6dmZN17g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/05 17:22), Usama Arif wrote:
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
> 
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression. The two requests can share the per-CPU transform: no
> in-tree implementation modifies transform state while (de)compressing,
> and shared codec state has its own locking. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
> 
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].

Greetings zswap peeps,
We pushed things a little further for even more gains [1]

Catch me if you can ;P

[1] https://lore.kernel.org/all/20261009071157.3730698-12-senozhatsky@chromium.org

