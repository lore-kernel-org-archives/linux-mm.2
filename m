Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD88ED5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132EB6B0005; Tue, 16 Dec 2025 02:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7D06B008A; Tue, 16 Dec 2025 02:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029ED6B0092; Tue, 16 Dec 2025 02:02:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E70B56B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:02:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BFBC160508
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:02:08 +0000 (UTC)
X-FDA: 84224439936.14.7134192
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B851100005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:02:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=A5zmmUWH;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765868526; a=rsa-sha256;
	cv=none;
	b=B1CDcdvFEBlhBnZVCsuoUzdBCf1Ly18tDUl9+KnI+l7DHxcdEESFLL9iOuD9VV7BWYbRrR
	4qAzy48feFPz88O0nDabmu76PnuAKew+Cb7oEPGJSuvdwe0xPYnSadowZQXJjtKxHVZ047
	EHOO2XxSKyItxaopypery1zMguKjim0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=A5zmmUWH;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765868526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNPH/jZ/SOwdUZzWI+K9uxXgO1pBllDjcg4a+m2CAM4=;
	b=DtvVjGTd14FZXjJOpX7XkOeOyg/dxdBgImiFf3bJXZaI3t98vv0XRgmYjm1NzmPq7dsGZg
	MpaNaPa0kbo/rUZkmLupBi21tCUFWMJKctWPHpUWlEP1hf6zAiUtCfzPmaM649jTg21P4Y
	SmDVAIxQZHGZgurRHVKmW0MmmucdO8o=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c27d14559so2410194a91.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765868525; x=1766473325; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tNPH/jZ/SOwdUZzWI+K9uxXgO1pBllDjcg4a+m2CAM4=;
        b=A5zmmUWHRVztQ7XwsqubP4YGGnkB3OBdPzmWVKUvWdMI49sx25mWjvVNO0h7kDwQnP
         mRP3qLr05xsioDaqriVpowDqTNmB5dF+1lTp8lFXPCFXapQ0yB87b7YLbt6gesjSR4bw
         BLjudNSyehQxZT2s4E5ioRcAXokqM6WstzV0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765868525; x=1766473325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tNPH/jZ/SOwdUZzWI+K9uxXgO1pBllDjcg4a+m2CAM4=;
        b=YrnakIK6UFovmYQphTQnvmag/vKy8TM+cNN4TOs7gc4hLrN3Za7aCJFKoH8RThRPr0
         Fl08AXvaK0UmSRjCV36ztRbM3RaJJH6ZNRc5aNSTOtUV7hTac18E0+T+ipUssVhD+B5w
         5/+slDp2m9uZlBiGUjD/XePwvuTR7WJGGBFljZ1b5iOiKgoHvZzhfcJMJGAGZwFPq7t6
         zEVri1tvYsPttmfDcrgQB//BQfE3NfE8xUZTTPbENDAiBladCXQe/8l3/51Ki5X8fJwp
         ym9RYGid7EIqRbWRmyd24rXy9wWVXMXBYqYU5CRtz8yVVORkuKzrLTiy2z8cyENHNbM2
         XBWA==
X-Forwarded-Encrypted: i=1; AJvYcCU0SkxQlz8U0VJ1OgYphV4SME/GyvKjMlhVvfaKqMS4pomcycsp6xEAtkTL3OZxIB/L8QSamlFD5g==@kvack.org
X-Gm-Message-State: AOJu0Yw6HEKV9ZCHdb+gIqynxRoUeGV5QdkxVuYWglkEUHs2CTsVeS0K
	vqiO30GkJQmFILe73Xx3wPXix5YnKechkNbFx4sTqdEdQ7hd38OvOEtZBSmyL8ul1A==
X-Gm-Gg: AY/fxX7mTliZlHJKKyxP9SGwf0j+LmGmcla2odBRRmq1kQkTpbdV4FgJQZBbrVRb10k
	FM6gaJdxO4xaKUxd3GqBipcuTUFO0DIM80o1ef3jOZmEyM2Z/DA5isB4ns1wimz5ah6ZXfjDWwM
	20kyJgYFnkaeOWVjHkwC+9/7L7ushS1zB6e9R7OELHpUWF8WOKXLAmjABA7NsdGjluk8bOdqJvT
	kZwqtve2JGhA3nynjxHe6dwMmS2H+PBJ0DSn1/PZnoFTeD55eDQDTAPU/e5ht+KnRz2JKlmIpdA
	DVBVUUI8j8du1zM5X/xIFWUrTvuqPgoNpLY8m6eajZh/Jq+Mo4ifV7vRc+29HN7CxXsS6JTmjEK
	nfbGXRP0/f8CVI325BL91+ckA7IyjR3hcwzFmbq9qck/Vz57sKMlAwwKSMx2IGi5DITMFbVtyoE
	0pTx6QIpmEylznvyx8ciuBJow6+N0V3xOP/Jzw0bDQTKAVh+9jd6DCgRovpl669Q==
X-Google-Smtp-Source: AGHT+IEuT3/plOsYLD8BRfCul71EgZXqqD0VVIL0HHIfNo/gK2/0xTdny+oIdgWzIdgWBZHLY3E6gw==
X-Received: by 2002:a17:90b:3912:b0:343:d70e:bef0 with SMTP id 98e67ed59e1d1-34abd8488c6mr12346405a91.21.1765868525248;
        Mon, 15 Dec 2025 23:02:05 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a48f:6b66:399d:86cc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34cd9a40c83sm177596a91.3.2025.12.15.23.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 23:02:04 -0800 (PST)
Date: Tue, 16 Dec 2025 16:02:00 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] zram: drop pp_in_progress
Message-ID: <e7ur36nfcppqqwqe4lgebb3prjk3lr7hlh5fks22ahsqz3bfyk@si6lxz5mqsqe>
References: <20251216062223.647520-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216062223.647520-1-senozhatsky@chromium.org>
X-Rspamd-Queue-Id: 8B851100005
X-Stat-Signature: rbwdra1q4d6ngy9cb7x9fngpk7dt5n8g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765868526-117371
X-HE-Meta: U2FsdGVkX1+PLjrWNwWEAdXPbgy5Upl47qQ0jY9hpHPmCLf10PyPBvVnS8sw7GxHkP22YN5wSoIPfBJBgqSg2d7R/YbpyZmo/PiHaC2MILwiTYYrkUX3OUwOf/3bbUyJ1fYtpekJ3w27dxF6SPO67jGRI7mKV5Nf61i7WUPodUjl7lI+82O1lC8zGHH3otKVgKw8PLUu0m6Itk+XlGGqz+2DLu3AJtbku9vhnFZpVxKLSoFMGXJde2LqD/1NHwnEu3BKOZC1YObzJW7MzgObDclBS4puQIQeE9FJcvvFwpnielZXab6Bg1XUjOY5Iqq9UYNJdke5TpzE+E1c8kRrZkCUTF5tvGpSZKhML+kCsLg3WQQw9XIk8uzvBMN15Vh0IWz8gtYrQI6X5ox7EsiLeSvCg82vkuQk4up7/PAJvqglftcX/+bRSF9+y54lEHAzsF/84lgpE8WqGrtxG5wYufTh3XUhmKHtPTCp32SkLM6l1dp1GFvPVW1IRNw3Wuk8QbuvpozMuHordyDMhhYNUIzkwaO/IU64u05SvhqtpKcdeRVtrwKljoakKjKeZJ5+o65RZ1BK3cUTjBaAsP+GuHPuTWXkxPGMKF8x+92cElsWJcYnRi6TendsBzlS651ysdRXgeLp4IdIBuVRRsDQuT9vb2kcuXgfAVXPZgeNgoTX8P0ns288RPcukCZM0FWvnhP1OHQPvELPT/Rwj5C/+szBCsvZMm684Ne6DFjxO9DRZRAvm1xKAHQ9oW/ULvA0f7YTD42xYugQnFhIzM91k/swlb+AIjPgrwtDKyY+NUI/MT2ch17QI6C4DI8DziN3x5x04kCCrC8BD5ok0PGg68hV9DnTAoM+hSVax8WFJLT4gxptucqRTN7Nk942W0gBmCDJUonhlTkbphHNBXoFxH5T4bVG99cdnSIA7CgBP6h3X6F4Yi2DheynczHM0gRklrn1VCBRjoHeC3WowJO
 PT1Sf3fJ
 tDxIS7PJu7doYckY7ywqsQppyRwS6VObJ7zcBuWDcBj+AbrdebYdsJDUlqRTYvqfvLPmHCf34gXgvgweZNq9gFdzgg58XyaYvzlEOz+1JpPFb2tb56RVXe7vywWmLOt95fvdekPqqYiR+fselB1iNps2lK8/n5Mc+C+pZuFu4IgelD1qbTjbDs4Ws7Nuju87uBTPDIA9DrrmDdYKyHlRCFBGJov/yT6pvPs7fCsMi3QSJXga0g/Nv8XmPboGXEs65VB2ExCPQgbjoZI4Cu/4ik7bUzqj9NwTiNrUfScQM+Dcqaxm+h37RUmr1fuwXc8w8c1Jyk1O8RLeFryvav9SFFzIL7Eb1MNqBS3QPT1VHwHV4foj2ohf2A/dXrQi+gr894CyPiTk5ZNjIUpFLPu1LxIo5bsY8huPHXAuiloruFrF/CxgJoEISoX35hZrwRQqf4TI7jBPi36sDab8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/12/16 15:22), Sergey Senozhatsky wrote:
> pp_in_progress makes sure that only one post-processing
> (writeback or recomrpession) is active at any given time.
> Functionality wise it, basically, shadows zram init_lock,
> when init_lock is acquired in writer mode.
> 
> Switch recompress_store() and writeback_store() to take
> zram init_lock in writer mode, like all store() sysfs
> handlers should do, so that we can drop pp_in_progress.
> Recompression and writeback can be somewhat slow, so
> holding init_lock in writer mode can block zram attrs
> reads, but in reality the only zram attrs reads that
> take place are mm_stat reads, and usually it's the same
> process that reads mm_stat and does recompression or
> writeback.
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Please disregard this one, there will be a follow-up patch.

