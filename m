Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EBD1C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529666B008A; Thu, 10 Sep 2026 15:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA696B008C; Thu, 10 Sep 2026 15:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2066B0092; Thu, 10 Sep 2026 15:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E40A66B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:27:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D58F1C2893
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:27:26 +0000 (UTC)
X-FDA: 85198836492.05.AFF1793
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 247594000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:27:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lCi0AoG7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789068444;
	b=P9rue4N+GzenLD30yrw0D7zom1lw3aqZoQu2WjF2hFrxXNqy7wKUnq3Yx6HudEanwmhmkP
	Ey4M2Qc790tSe/DX31lWT5WJ54LLTB1uKllUfaTfONb4gLT2N3hGjnh3v5tncgCVh4Y/O4
	B6fPdFWY7VrKIexO4DLd7jFOnnyfZEM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lCi0AoG7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789068444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGOocZLUE2vWRPCr/a4QhvNPEVhRyGqEJ5q1BI/ushQ=;
	b=yFpP10tzzLf/Oauxvg1TKbuvEf1PY2SKi8rMvUha4iQWS4GHdnDtUMkCXn0na6AvYCqela
	t2Hp9bJpapoQCQKKhVHmQFizQVetjwbca/MBPvW7GBMhwvaTKTM5uXuOVLx1CCdWgOm419
	k+6bbtkeavmLE0vdGm9fWLPg165pqkw=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9399d91ee7aso5204885a.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789068443; x=1789673243; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZGOocZLUE2vWRPCr/a4QhvNPEVhRyGqEJ5q1BI/ushQ=;
        b=lCi0AoG7HjG4FaN/da6/r4lAn47CUBpahrnkn1ldo7xxXSJbrUS2IkKGz1XOUur+1M
         r6TdrcMgtwvKGUXAOkAe/aazRAwCa0E2q/zlI/xTHHmukeBs5vzn9BRg1ERJY5WpHsOT
         MVdOhV+C7tKf+wn71lOgLCJODRQSvFA0uvhUKfPnDMiEKPmwPoHTcqw5Z1oOfBM3PJYe
         I5MP6WRQmjRQR0WipTDXcLTlhbrVuPCvd2FJkl6xpx55tkj3ahwyND9tYFvfCxoe+2Sl
         ibX3IIfrHpQujwmlpYmjdaOCMfNd+unr4twko+m1GsK4V2ZOx87qJvmwGn0GisfX22va
         5t9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789068443; x=1789673243;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGOocZLUE2vWRPCr/a4QhvNPEVhRyGqEJ5q1BI/ushQ=;
        b=H0rqxPCXcjv1cjALzxpLsnzz6pFAO1OmMTcoG4up3nzwvnvBhW7T6SSthp08UFa5S6
         uQWbL1EBUXumSqNSB9BCfx5k/5P4xmyRgFo23rhlJcOjZYTKkhCyh3Q/WKLJ2Vwz/jdb
         aAB62+7Ey0yrIFavwu0peRMicN40lYpJ5uWtQLJ+0IWj0FiV4HkvXPuL/NLGvcX5/jBn
         gJR133dqk/UfDAyc7LGlXWxI50AZZhJSaFnMGFYgmXPuOGoHm32sZgEA1Ws8Rc0Cs47D
         7RrbGAkSjOva2aeRoQr93n6g877K9sqr9Wc8GjkXgix+XbBuVWqwRhT73+ej/WsoTq7J
         yASg==
X-Forwarded-Encrypted: i=1; AKwUvByP4mXbRSFc6RW4mDaPA2T5e0/sfydxji45WQFBqhWm6C4j/tTF1+mIIdmGF2ymOnbINL1SITTpUA==@kvack.org
X-Gm-Message-State: AFuF++kW+fIg7a6tPIU6PQiOpm5Lp6yyNS6apxnz0lNEMn6kZGR2osbm
	+lvcFOYWGJd8+Jb1BF9DU20fd+j1awV8SpElnsMSelfb/WERUW97KzK77qbGIU/HScA=
X-Gm-Gg: AYBFou2mGhKFGp0w6mEM/2gP6gFpC7UhKwAgwyVLkAiakYu2BRIe8fAQEDnvPicZ/Bp
	4nSI++f+tGQBjzFWB8YSFSwFKk4l1sVI6K5zR+hvJdNLZ54LWYfaOOZXeBC5d4QWptePFH1bx9p
	Cw5BgwqNN/EigD0UvHtasXak+k/RS9vhQvQz5lUB6nZce53uDz9NnBpKkji5vPYhIWaOrJfIUyO
	4ZPuPS/3ZVgHHCxFWCr9bLbkGf/0XCeClDtGf+kF4mJUAj4sYb4PLdzPOzCwQDBUeS9IqWO7mXE
	WLvKnWXos8zItbH1GtZECejqpXMxXirHTE4Xe4L7zgSsCPR1CfAsTthyOts0x4NF1t+a48rHWEE
	/9Q1rmXGYg9GYWB+sI+yH6Pe3/z4W1wQzu0RlK1JJOm6prP/Jzu7tiY2OJvlTEGTzrrJXoE2TTH
	W21783/XzCyVepfKZFXD8MXrVrhA4JiIxTJGaPTLmIRf8eQ3qYUJIWUPPi4QeL2p3jb04CLA==
X-Received: by 2002:a05:620a:1711:b0:934:946d:599d with SMTP id af79cd13be357-939e9ef9939mr47430785a.33.1789068443004;
        Thu, 10 Sep 2026 12:27:23 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80f89c8sm55074285a.44.2026.09.10.12.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 12:27:22 -0700 (PDT)
Date: Thu, 10 Sep 2026 15:27:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 1/4] mm: zswap: pass type and offset to
 zswap_invalidate() directly
Message-ID: <aqMEmG_g6NTTMxIp@cmpxchg.org>
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
 <20260910095449.715183-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910095449.715183-2-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 247594000C
X-Stat-Signature: ry16r353imfrp3jsfni6jez5z434n737
X-HE-Tag: 1789068443-381291
X-HE-Meta: U2FsdGVkX19q8fVdxTbkhEnDGoRWD6pcdk/R9eHsPyw14C5a7fkDg0F00ltO4Ae11vkQKcVE1wrK9c+k/XT/iazN9FP2NBVg3wIrzFpyVSmhzKsutLPfP6bHwib7+keOOd/bscKoSM09e6bgqGe5+7Mpba4xR9QTDqFK2c4ax8oGXPNLuaJPXEPK6Lu1jNaBpBCJggmfBAul/wx5zx+qCLEWcjgZrC0PWt2OEKeiU4tnvbYToyhn5s/6DjFefWJ06ICXWQdg1Y5oecg18gzX8DNu0PXgxC4rV9PubA1AJWKhPwlej5VMGp1b63OL5A5kXt4c8Ab9lrAjU/FBLyHEM8VEW1rAgU64zG3h37HxckU6zQfCdMAJtPo/Dw1wwuJS6X8vubbOOp45ddddUl3xdijEp14z8896C+qxTNEupCcW/+5sAvDkBIQni/GcsduR+/zU0czpnBg/lyZRSilpPtSb04fIriqWKuc5BLMyu/DgqqcMZPdVM2dJGuZyFjE2gMLGhUkrCGIi1lO9reUybEcSd2Hw97BtxY0Gr5OeUYulWkGgU132WKBoy9LFiG6SHl75pXoct6HY7b+5hg0yA3X+wW9grbldQ26/mJNpec9UPIX1nJAwPCE9ge/2opvAx3dyWccXqQoE6AvmEIBAfXHKC0ahjiVBHP5F2Clu9gzb/kccvSPX/r45eacj8UEFzyY4XRDcs7wlAm8+hcbTyCfbQw6YEyxevTzXaLVZL6SCrPXJ0oJUYnspJAym+Q3VnolGqY9/vLq39rXULEy72nL/oRsvIMRaBNLg20+mb3xoCtWfJdCUWFX4qsDUxpVZAHUMIvSy977gnr5/Ht5IDpozdZVKskQoEmYOUv87qHDD/ZQOlKWYAh9bliLeT6ShazNJtNmjVw18MTP8m6seS2ICG7+OJav+Yc3XcMBHp/ThJqL7I6Kcl+koyrQOIqpZ7XNOccIa5e7zRtZaAmU
 +gyMFEcP
 yRsBNtpJ4PjsHjDb/6XXy8GxMjAQatUROHYxsV55NoQcJ69/Fnow4HS7JSmGNimOjSYVijm0DrJWRN46R7KqNNxAxZR+nzojXaov4wA+pnAnbvHSnD/achPqJz+bCgKLkw6dBmL5nDotk4xOkuKcpKRTbg+bD56GJYG/uOVDu9mD1tT+z98QZLyZfEOUDsHS4bY35w+wWNQ7o4zXifDOF+rDIyp2F2YeeZ0T44Pf9sCPSQ1mWkzhEpsFIyiCIVpWNd+uxjUG0GSDE2d2BvAiuZXoB8wT9sfGQbYbkRQ3zGDlu0UJXB+jS5WxnJ6AzULWyblJuvs9+1s1KIuK9LpCJDIW9cLfEHCJivNfSAdv8oP4jX4BVNMkjWEnBLnLz26Satg39MjlrNyUD4ky15QbaVw4mZgFAzArlJMh9G5gI/+wKsHXPhb56YffScado7y2d7NZKSYmikOiX5Q6oEyWkvsAANOOM0RvU6Sn2w5OruUo0NadVJV29ZmI81A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 05:54:46PM +0800, Kefeng Wang wrote:
> zswap_invalidate() takes a swp_entry_t only to unpack it right back
> into type and offset.  Both callers already have those values, so
> pass them directly and drop the swp_entry()/swp_type()/swp_offset()
> round-trip.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Noice.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

