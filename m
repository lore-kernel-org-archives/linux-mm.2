Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E30F531CB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643C76B00B9; Mon, 13 Apr 2026 15:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BB76B00BC; Mon, 13 Apr 2026 15:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5315D6B00BE; Mon, 13 Apr 2026 15:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF7A6B00B9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:54:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4CB31B7406
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:54:49 +0000 (UTC)
X-FDA: 84654585498.04.D3B34EF
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 063C68000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:54:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c6paX1bm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776110088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LBTdm0r6/3UpNGKJqwUrmmrep6dE2YfGJg+Y3TeQvI=;
	b=sxnF3XLOoN/cNL02prqc//bbEvd8fYGOCb58+9EbML0uETuCqR39TDasoemrLNd/GWt/uK
	MwPadHQPc+z+IFtCXouvAak/KzCgzslcKPQpcMTprIK8fWpyxmGcnZOEva37Hm7HIzNbze
	H1mQZ+/s5w5DYS+pvO7EtPW92sRiRB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776110088; a=rsa-sha256;
	cv=none;
	b=3bGQXrqjAd93yhK+hvyDHijGcMmC2SxXGsENy1YpEUmlQsnNTl5QiV9R8zpl8BDf0toegF
	qknq79qpM9m3DVK360O1IufZW11OUvn3bmH6aSx3dYAekr1G525KqvxrY+Pvz/gr5PsSmP
	43MQIFnV+QSHpWMTgE+wlTl4FoBNkBw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c6paX1bm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35e576110adso1129853a91.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776110087; x=1776714887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4LBTdm0r6/3UpNGKJqwUrmmrep6dE2YfGJg+Y3TeQvI=;
        b=c6paX1bm1kFhdyyGYGjZX3jPFAGQEuamDz066X8qR3ge0OciFzIrOKMtKsBswWAnsz
         ei/qaqXqXYMaBfkgTjtm0wXgxyj2JOtbDiRg8qPnSKGxXQwC1xla1Qx4AKtY/QD1VV43
         JHpqifyolID0si0XF9H4k+uNVsgVtODGnr+1YSgKO2+ZcxJOIrPPvbzl0BVUpv75p0cl
         OfyWJIpfkjWItvnV70c6NTnBzUMsNeOfbK/b+mQarhH0nzDYqCWzjQc7HyDH4Rs5WBsx
         zk2B+3Y14FZVRo/hKtRV9hXrAAF3xfZttTZws5SuB1DHUNnrPN7CJs7YoF9P9xUzNxqp
         +fFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776110087; x=1776714887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4LBTdm0r6/3UpNGKJqwUrmmrep6dE2YfGJg+Y3TeQvI=;
        b=XWCbYiSpsn+dhfEJCUQIOCIdP35pnpPUo3YTHVj59K2ocU+ltH2hXTB9yeh4rcKb0J
         xwzkB5KDnrAqv95b+7FhdX+4aXqHhgTmONjao5272Ygm5PQThoxWcIKdGY5v31HjQoic
         jAipjAamBNFvH2bgHZbfZX4LurvZYdiBCF9KlK/3GERslBifWN+qKfwsWFlByzQtEn2Y
         LJ7M5eOlDyTpw+KoUHnHBgMR3Stl5fj5dgHKMY44hRhl/rkhawkPI6uloA/Xu2R6zPC4
         Ott9xumVlTf6YSRwsj6qXWOL9OCiyGchRN3ICHTVxtMAY3QE5I6tRniqMhyRasXi8YN9
         pB/Q==
X-Forwarded-Encrypted: i=1; AFNElJ87IKXWLpOGJFNMMwc1wBeAkQiiUr0wq44o9BghxTMVQwIZbcRQnAl5QSE1t63yY5NiwWN8ByDYbA==@kvack.org
X-Gm-Message-State: AOJu0YwWl+vCmF8HfIgl6/8Ll4wTqa65T4rCgMMMKuPbkGYweEPzMnzu
	h6i4YXXn2sDHxtocz8NoCw3yOQagOXE7y59LghCzrSsoTfRfXbj1+Mjo
X-Gm-Gg: AeBDiesHyq9+ZNpIUBjY7q/xKkySnW0FrX9GfdlxtXXPcIeSRHkHQ8OrXf+Lw5RK/j5
	ppMUG+co99WzbPJOcOiTCuyr0UpTT6/cdxmZWFX9jjcnCcH/KW195Kgq5yaIpwMoTxIDaKI0h9v
	Wzexyf2t3gHiYQN+KYlu23Ne3NQZzN1hQRl1dxDd/8zenAMwJXLPL/GClOadybAFwPOrSrAVXq+
	W3TFDq6KCIXseVj73XGS2hgI8IMEXE9G3aC02v6iBTt/lI1nUw0A79ad5TUj3Vye8p4k8L0sZLf
	fEoRhWvfhROKJkIbkOwAUu0HEjlF9JxnKlXzxQD2AGaChFbredajLToI2aivws1dg4VC//FYi/Y
	s2pn3OokOHw26t/Y5i4TdNXbuN8fHCwH1OHtjDB0BgHPH3Q8ImYg6EUZnHAvjY8q0PZ8W3Isofu
	MSN8r306XWrcDbLlwjYQ0QbvnAeLL5+EYIRK2CEa/oUEAfZNDKmQY=
X-Received: by 2002:a17:90b:4cca:b0:35b:9e53:e2df with SMTP id 98e67ed59e1d1-35e35335015mr16924314a91.2.1776110086652;
        Mon, 13 Apr 2026 12:54:46 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e35155829sm16717956a91.13.2026.04.13.12.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:54:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH v2 1/2] mm/damon/lru_sort: reset thread status parameters upon kdamond termination
Date: Tue, 14 Apr 2026 03:54:51 +0800
Message-ID: <20260413195451.17184-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413185249.5921-2-aethernet65535@gmail.com>
References: <20260413185249.5921-2-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 063C68000B
X-Stat-Signature: ikjuqr4tosyeydexgkyazchds3hs6y86
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776110087-719400
X-HE-Meta: U2FsdGVkX18wLC9xIhkHWWKym08QiKVRgys1g5FG+xU39I1aNdeXyhHd6dUTLJuxX6aGZxJsNMXFrhqz7xbBdCkX3XzRUOXEzryGZTDQvxBcRNNT+P8rUQrdpkwoo9Rz1XYdTaMnlHIlS6scDT9fBBnBO3DcLZcvx1UNj2MnLIWkhKUYRnxtSgL9Ai3tM2UBP4FZIy+RHzD2hp0jy15h8phBJB37nv3CHDwxEeCd6suLEM5Iyo/xOI9TWj+aeuazi45dxIir3IDokaNFP93ZcGu4QUO6jvKkDMl0bckpmy/yPLZGKyFTzHkg9MindI6ylCrCM9lHijLACKtK/E9zUiXUw9biCJAbl+Q/vWvuqIzgr5KXhXZXjjp1yqRNjmCcjTKqZ0kPU4B8WV4lvrBsHaAqF8Ok6Yg/T4lylJZK9FqOi30m/K1M5oPi/fFlxdkOghTO4PDhbFCGvNcftKirHp+AN4yXBw0FpvRZemzoKski27nhjDq0G+E3SZn6ppDw519qmOeMwnX5OQJqRq6OxuBs6Z6cAb8fYnJDjV2pWznG9wUBZgT6ukE5rHc1mAEE1cLJysAj5aBK7J0R3wtn6FtAQYhYSGMj4RuClOW5gjJX90F9XrCA9q5kBdOZMLQ7qqWCpJaZ5KAIZC1s2ZonntqBslaJjgexITYpboySuGpn1Qhm5nz+XEXhB0SuYvm0JgQLAk6WnYnG+6DBXSAoHVgS7ge0qpDJnPLJrSAZ9VEwZOC7h3jXJEiys26AE8IxtEXszDHAomYI+vzv0PpYwvm9d8vfA6AoEyweUbN8UXcibOWuEPoYAEAMhap0kgUhSnHA6pVs7BuMve6OXFKPmZu22Jw7zh8Gf1FoFwVN3rEEd+TbyIV+YzoWJddO5ycFBPyVbFmDQDDjQufiFQLIJXyidu3VaDeTzY/rKC60Hp6QnP67JZUOSUtG0YvjloBEaY0/4/iXeU/POABHF8o
 NDPYpQG2
 PFuNYZxjIEMSQzEvYsaFpDD0ohCkxR5qdX/yiWhBTtGRertJl+NWgjEmahoPumVEbDgpBe1ROY4xKpOoCqujJCUzKpoW3vlOWzVCLx+3knVb5OtN68hla93fs486Xc8BMWWvlxCWAuxjAkN5J5+7DdutY2q4V8EmomsM4wSKit43cUT8DBlhb/L+Ivzs9HZ4P0kBKvCXX5+IsZz56bHsNBOw2423hg3MAywY+xsCLvoedcUm3XY5mmVE2VqCfpcsajS29SrCz5FCXbcgK0KQHJ5Nf5M0tThXrkOnrUTDkQtkV0P/S7v8gYikHqjBkZErnKfwObZbWepeQ/NEomnr5e8F4zMjKhZ9UqMDgWZObKD8e7FiuBiD8xVUSrbCeekXc6sC2OKxbFRghRWiSon/NzFi4fB7NOelae2sitszjgFgoEX9QO2mc8d0teor18Za4YZtZvA/wY5pDkxG5yDrdUPkZE0mtSzufSo0+LdpgErCJOcqlX8kduiB1buZieLgNCgSSHcx+3A5Jirq0hVheEJcX1rMWf6mRHUtAhMFJJ/4uwKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found some issues, so I will send my comment for it soon.

Forwarding sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260413185249.5921-2-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit a943fcfe60e73956b72cad5a625120222653bdda
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon/lru_sort: reset thread status parameters upon kdamond termination

This commit adds logic to reset thread status parameters when kdamond
terminates unexpectedly or when context commit fails. This ensures the
module does not get stuck in a state where it cannot be restarted via sysfs.

> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d729760..96c8d0dfcafd2 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -344,6 +344,10 @@ static int damon_lru_sort_apply_parameters(void)
>  	if (err)
>  		goto out;
>  	err = damon_commit_ctx(ctx, param_ctx);
> +	if (err) {
> +		enabled = false;
> +		kdamond_pid = -1;
> +	}

Does updating the module parameters here require holding kernel_param_lock?

Since damon_lru_sort_apply_parameters() can be executed asynchronously by the
kdamond thread when a user writes to the commit_inputs parameter, changing
these variables locklessly might introduce a race condition.

If enabled is set to false here while kdamond is still preparing to terminate,
could a concurrent sysfs write (echo Y > enabled) read the false state and
proceed to call damon_lru_sort_turn(true) because it incorrectly assumes the
worker has completely stopped?

If so, damon_lru_sort_turn(true) would call damon_commit_ctx(ctx, ...) and
modify the shared ctx structures while the exiting kdamond worker thread is
concurrently executing its cleanup block, such as damon_destroy_targets(ctx).

Can this concurrent modification of the context lists lead to use-after-free
issues or list corruption?

[ ... ]


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260413185249.5921-2-aethernet65535@gmail.com

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260413185249.5921-2-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

