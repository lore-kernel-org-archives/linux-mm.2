Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F5CF532CC
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 04:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8700F6B008A; Fri, 27 Mar 2026 00:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821596B0093; Fri, 27 Mar 2026 00:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737436B0092; Fri, 27 Mar 2026 00:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62E906B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:35:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C858E15E5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:35:18 +0000 (UTC)
X-FDA: 84590578716.22.0213684
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 296DF1C0014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:35:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uowUZcVa;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774586116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPND/ARcmlMUL8XYaMKBEVAJ/JxuIj72dXRRctLfbj4=;
	b=Z4lUBM+3RLL/Tvw4l65ZhoJ184SdZfuAt2t4IPzQDD9JftnsM7lc0iqjmSRDH1SSrDHO/k
	ffjQD1Pk1sh/6V1Tnvp3nCKVDM7qMc31RKKnnc5llmKZNdfWMcmjLRV6HanS5P5TU45hea
	ftMB3CxLOQcs5HMmdATv944LLzj0UWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774586116; a=rsa-sha256;
	cv=none;
	b=LvGpExbZQ2FIi9ZTs/+UdN5sQCDOJIn2TX6nMpkxlwj3+1LGY4MePpww79uAqUPvNKAIrF
	3ShMjmgexkB8cOJMsgr6yquvZ18+0FUoVvmDD6AYUvTES2v/2sZCEmBQ4E640jOtYf3dUi
	Ythl3w1mtrLVTFhRy1Hfkm7CZjDu0kA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uowUZcVa;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-89cab686a9bso12532256d6.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774586115; x=1775190915; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gPND/ARcmlMUL8XYaMKBEVAJ/JxuIj72dXRRctLfbj4=;
        b=uowUZcVaQtoSJzZUXtpm1xDjJKlUaHn1QrIAHsqLzqZpCSNlNHz4kKl6PjmspUTifl
         TENEzY7FIcx9r+pyl+XPU1/AicbFV7lLiQVDCeEnNfHuCABRWMUVGXQ2lp8CJaBkygjf
         y/oqQXVKIEm2Z8739x3EQ5GgwPv0g1DiTsmYUullFScEQd3drNogEkcrE+Wdruf92pUI
         wjtJY/oQJcQi2oCClgnnLh1m+t+tn81obdS7hsb3Qv9hPAIlMfMeyxCtTRIiXa4Vx2kV
         9x5RPTorswAMYiDeFuso/gN/6+CBBXNk4Km6nY26C7M/1dfYtmlZne/hI+JyIo6VRu8o
         Bb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774586115; x=1775190915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gPND/ARcmlMUL8XYaMKBEVAJ/JxuIj72dXRRctLfbj4=;
        b=ZSjHJuUnhpAL54U7YREjuhH9fc5JUl0umwmxKYsXRpYO6ZUf535fs2k8Cl1bRCWyiG
         4BqXqhLAzzNxDLEPSS/wrIffy39NXy587dWBhc8OsI1GXPtOYt/7uY1/dvHOA79AWCXG
         n/1R/r6aIbUzKxYtytpuJk2nh+8jzBREsQfnXgTwetA7tiPjFkUj/C5CTS+kxJpBwhl2
         HxTWik1pV91iS4Vo+qws9YEkpFtR+CMwhGXxXdiQCxzcbxXAf6tA5Oc4uuDMgIJctd4p
         INvy4RUC5BpfAuIYhDQzDACGU+aQHH55Ud7tm8fkhhE2aOSNjDYPvn3RvAbGTEb0dMaH
         iydQ==
X-Gm-Message-State: AOJu0Yw86LqhiFqVBETJbeywoqLEzzK8/JWS3hYH9UavPgsxU4WmbApY
	odTIyMsfFpCi9j7kHh+gyDgTXED6OE8sWkhArKVtfPbFs/itho3NUfzR3RKO4PwSh9w=
X-Gm-Gg: ATEYQzylWSYQo6a2xgqkMq97HC6uHnB4hBSPnn46+IiT3i1OZmBszpJubikdfwuIj5z
	VJQzW2mPTx6vcHhqyY3ytml3679lyyg5avvZc38vaUJl6wrcQ1BqERsvA0M/1fglQFHUvq2qWMA
	Q3CCNyYFyFMn4HFlfjOih41mteFjDSHaJfMp8I91X/2piPaOiwK/F1rzTL0QqY0RbZeqT1C+lGs
	81LiViOpfk5yzHlKIkNBfwSBvXvGwvjceptiEllqiYbFXWR1z2vZbaldM5Czgd2GFuwyOW0KcQK
	GpZbp3VrFp7ttQdaCt/uc83uyZn/cwLnZaMq1HwJRyvC9Ec8TQEBvIyflUZxt1Rr8yO2NwSHmUu
	hPjgMqxgk6rY0t07+qC1ubEgnTlkV5qrraa+STxASTTdRt9QIJnneOFLhQHTsK8xGjFdeKLbew9
	81Wo8dXJ2qfFKY1iTl7iALGcGvsuTfppWxxBQ=
X-Received: by 2002:a05:6214:6012:b0:89c:823a:c4bf with SMTP id 6a1803df08f44-89ce8d6bb84mr11384906d6.14.1774586115260;
        Thu, 26 Mar 2026 21:35:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([63.116.149.204])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a24fd9sm40782376d6.25.2026.03.26.21.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 21:35:14 -0700 (PDT)
Date: Fri, 27 Mar 2026 00:35:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <acYI-gqDOBbZ-bEn@gourry-fedora-PF4VCD3F>
References: <20260326162611.693539-1-gourry@gourry.net>
 <jm5rmcwiauy2fn6fvj6cjowiu2dudjndhhlcd2tm275ibmos5i@dwxwchbs24ko>
 <acV83cdc9ZfNk8Xh@gourry-fedora-PF4VCD3F>
 <bnukmnuxxuhdfeasjz33miemgr7w35c4aa6pqdmgupx7oxmeeb@gozgc3yxhcdd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bnukmnuxxuhdfeasjz33miemgr7w35c4aa6pqdmgupx7oxmeeb@gozgc3yxhcdd>
X-Rspamd-Queue-Id: 296DF1C0014
X-Stat-Signature: cnz86115tdns654xqhzpjqgzz91enjk7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774586116-825439
X-HE-Meta: U2FsdGVkX19+CrfDiK3iw7MTob9etxSw5UjeW5Z0vor+6i3k7JHju1DV51X7omgMHTDS6GL+UA89tx0BFuAcOMe7tSPuYvtKndPXs+EQ1pCJjNVtQ080bULVg4vFFi+3j3xFMxnJVF8/BfYUVxGnMzsfefyKfhC1eyKa2suW387Dj3thW4ZarML7XlZxrziO89mnXW0C4RzwIOpoyK+uONy4DRhXXjf30Y7hZ0pgn/9nki9VCzQG9lki3ZqNPiDX/i7BTlemxEhxzq7cX9x961Qr0FWKlv0Ir6YubkGncTObS4QGLK+WJvCoV4k/54You3TgQZJkzAxPuXMLyLVzBO7zS6Xze8LpCYQw+ZXjBnnuBkzYaB4pRpqGaoyqW3Dy/e3e72wGXQuuvemwEnSngM+2zJ77IAwRO7UjHtXosXgNW//6aldYYlgm4COP2ZQS8dw2cfmosyFwsczEGwbdn77g16VRmZqSv99ebUOn9/dTzCBtAjBW/jm6NghWMF+jvfysBfORo85MMEhFk1vR/Br8sIcxrEZTzZ2pOOI8kiPMujnz4rRQ6h9xEQK58Xs3ZvhRI5DXuIkbhDE4HLQot6Yid8iviU9sWvJU4aXvts8VnA18eIytv06Po4uZqCqP9THps9P+D8N07CC+/CKV8l1XejqNW+zcCtzlGUTUALoD6jGRWNwnUDfdbuhhKv9FGvjGRFF25ewMVA9s82JfFXxTzaoooinTwEIq2AjsbKyOZa6AbF2f7eHy/w5McCixBn1aSm4qSAzB3vTN/AB20GGSSrchIq2OtfF1QgnWeK6o4bWcJR8Vo9kXNFt0HATeVa0zdrc76aAx2H8JVWWESrxzy9HyJRhE2vVBCka+Igk0M3/Saed8uUR/2OscyxQcAjE7QuSycBRU7Z2SU74cjBlMoRsO5CZKuBDxHw8LqSMN46HD4p+gfQmOVUhSrRI3/4AJz2PrnFxooQEgzlT
 1YPooG6A
 x2qmr8yR4pUwGfLBtd6EGA/jf/wNoRtcka8h842jukUAub3fFckAhiBRpWcTaf+13jspuV8GlwKUJY7iPnutU4K3Z7k2l7xEdHHP281GvYs+7gPqtlaP8NQ4rtm86DsYLhkBvj1thG6SpI+y15e/R0+P1osoDb3FJhIqyIXPXqyvD1JnCo6iNaev8XRjHRJ3uV8olg/rz7wJrEY5C2Uyzsx/ZXZuMy/4F38JHNCuuZuoPjCl4kUVrGYUHdjEmuA02jjCmaJ3RHyPu+wUNvnrOi4Feia8IQFl9dmkC1hch6+EJWnAsFVEOA3iU11KpMLaiOy1j2Ls1WsmwnAUSXx49ZeQR1ZIPCXisOhEjBZlx2XfipUUK802hd1OKcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:16:05PM +0000, Pedro Falcato wrote:
> On Thu, Mar 26, 2026 at 01:37:17PM -0500, Gregory Price wrote:
> 
> _If_ there is indeed breakage here regarding tree rotations, I would suggest:
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5754d1c36462..7b4e39063d67 100644

fwiw this does not resolve the BUG() i'm observing.

I'm still trying to find a good reproducer that doesn't require
launching ~100s of VMs and ballooning them, but the condition here seems
extremely narrow.

~Gregory

