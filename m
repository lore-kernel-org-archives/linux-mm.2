Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96BBDC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39256B009B; Sun,  6 Sep 2026 22:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9996B009D; Sun,  6 Sep 2026 22:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9AA6B009E; Sun,  6 Sep 2026 22:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B53E6B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:27:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D31C180640
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:27:28 +0000 (UTC)
X-FDA: 85185379776.29.324A688
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA4AFA0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:27:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EWdN5Iqg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of seakeel@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=seakeel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788748046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hK6rznH6sZmMYoIVp7jSpppx7B+6EUkEUbPHQbE9BCY=;
	b=GUlBw2DxBcXzXWQOIdBnEPry/3sxmxJ71agFey/nIYRzcxbBxWVSxOGtnRas4KheADwmvO
	1chDbMjhamrWxCMKeZXI2MPIqwsQFKl4xb9w6w5ZS7qPI/clCFkCq5sXIL1Ett3TEK9b1a
	2m5BHnpkrWQ2AKoY0Uq0st3qWLfjjPk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EWdN5Iqg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of seakeel@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=seakeel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788748046;
	b=xiLo6CUSEFuzC7JExY6KyKVHMj8xLeB5tGXsCTUOXFBQHDIHSc/Trkn8q3hD8FOQxX4s3o
	9TSg8l2JAQ7Dbi3ZnSESjOn/0qr0drbbKTt53m5peChWQ2p3toj4zb717Wn0Aoz4lcT7zy
	4BSFv04uGSinLOAKUkqwvZIgGRnpWXQ=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso3822998a91.1
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 19:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788748046; x=1789352846; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hK6rznH6sZmMYoIVp7jSpppx7B+6EUkEUbPHQbE9BCY=;
        b=EWdN5Iqg0ndO2fL3Eeaj+V2N3ETOseDkUKmlxaO2o5D6Aio2FH1oVWAx4aYQbOxkNO
         LG2lh+o/IYx5JhswKxeqXlK7qNkeadDMCAnPsLk2PC46vALj9U+Q+IiLEk9avzWBiAZa
         ZQvSoWy9lrccIv1woe6+0MSXzuutlxmJ2R5s71I6OWFxD8Mo+xPaRn9QVE1VIyIhnSfb
         kW+1OchOvKNW/vcJEpS40gNzk/K4lF5aewIdyPt7vmJ/1UtwSCk5ZHfehmyVgzNTB4Om
         //jFvMWReF17CuTHTeW4HigAmbGvmjkNC7GN4o8vNmaVU2AnN59B1S1zsKbZlQ/yUYAd
         Ussw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788748046; x=1789352846;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hK6rznH6sZmMYoIVp7jSpppx7B+6EUkEUbPHQbE9BCY=;
        b=bA0xEAaRhJFIEO8+YfXYp2dHUaz0y/fmMWIWupBrC5vZs6274cziH3z6puBXYOF+Cl
         +/sPrUE34FxYMHBYQc22tlYxdTCBP4+ONCKstzAuUo/Ir/Vq+n13oM0tVBw8+xz7j/zJ
         YUnORz+y+20E5XgZ307YPG9Rw1E8EQJwa02HfajkPpUYDh38uw/ZnMRSY+LyFXZAN74k
         mB5Z+bhf/O8ZBVjzQkr4HIRpIwNs8bp5dxu6Z0Nb4waqI/4ipJX1nPBaUTETbrPrCw7u
         lcmZVkxmDfpcJh2OF5uqFnekB7bVtKa4oqVGlWcPxvKmq+5fqhX5W05Mq6wNyv2m8VeN
         R+xw==
X-Forwarded-Encrypted: i=1; AKwUvBzEWXCoSVwqocTO2887UCajFT7Xrr7qSMh8uGuWtEJMOtKKlcyKStvyLaKnqpf2utLcHcZMq3B1ww==@kvack.org
X-Gm-Message-State: AFuF++kdTnos1d37OS3CWfPQBFXfhZd5yNPV5mKb0sLmlojhrxcwvOt/
	ilKGtebKvXXAaTyc0osrkUsUMVhFWUOWXJyhU/+fzhte7FAZtSKGBdu5
X-Gm-Gg: AYBFou2kegaz0hgPwEO3IDLOhLRpzMuM/9mR2IOT1sUiUH3JSHWlccetOdz10UGmSQK
	+E6vyN855cWuigIbpGR8KlAimUSkMjDALSpji2X10CzeE6RLvmyiOkcbe0w7Qhuh/8H7lc2yJds
	w+qRxJC7WkuKnqTwUy3nAj3K/CFnrL60NBQQSXQKZZOseCCudW1qaHmSN3mJyiDSKv4FFB4Rs7u
	Lp4tv1COcdxRO4P8BUdMSmP8qsvIAk30YoQVk7d1xvQpzfOfsLyC3oZOlXqMhlYv29Sj5gH9rW8
	sYyIkO/vlzKYNp/CKp4FEBZGJbFZcyTePPElgrHjVRsb7iIfD0gEs85UDSyDdn0ZWbaVZi5iS14
	IZVjruDdkp987HrKFQrsEitlM/XOA7zZpApUD8sMVGdEfa4pQDz7bLVJeI4RA/bXCFb2OOA17Mp
	SfNXdyO80duwcuvDVwcrd6K9g0ZkZmRQUpi5rFLnPazk+96z44z5IKaCNvf/SV0bowLUKciOe9+
	FMvLD+3Dd3irxY=
X-Received: by 2002:a17:90b:5844:b0:398:e436:370 with SMTP id 98e67ed59e1d1-39b260ff0e9mr32411991a91.2.1788748045768;
        Sun, 06 Sep 2026 19:27:25 -0700 (PDT)
Received: from [192.168.2.166] (104.194.78.75.16clouds.com. [104.194.78.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b07b197a9sm23626169a91.0.2026.09.06.19.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2026 19:27:25 -0700 (PDT)
Message-ID: <33037304-19c4-4d28-a550-b0b45a560f55@gmail.com>
Date: Mon, 7 Sep 2026 10:27:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/7] docs/zh_CN: update DAMON documentation translation
To: Doehyun Baek <doehyunbaek@gmail.com>, Alex Shi <alexs@kernel.org>,
 Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>, SJ Park <sj@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260818070358.455768-1-doehyunbaek@gmail.com>
From: Alex Shi <seakeel@gmail.com>
Content-Language: en-US
In-Reply-To: <20260818070358.455768-1-doehyunbaek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 96a7jdd65eneys11shug6opj9x79a7b3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EA4AFA0003
X-Rspam-User: 
X-HE-Tag: 1788748046-515607
X-HE-Meta: U2FsdGVkX1/GlqiRSoi+bHMmvyzahymmMItnfzZHzwWraBK3yqchdqSc1XYxKNICmeoaDz5fGnfyTlCz1DsnpICvahhWxY2tL0n2iGwVPPdRxPsg5eaEhqlDkxcrHquHH/k5J4FmpAq4bi/NsulJf16GoNnhR2W9X1h64CDGHeQjB2pvU7O8nTFtcfYiFAFFFhzx2DYX9BEgoResLytuDKlgQmNvYe5Gl4NObuFuSWgfjudvOud1FygSS0pSX/sQaT5uH4tDLD0df0JOdNBoYuyrw25+6ZfDP+rRU1d4mfOFk6yJkW7SEgpRrCKGG9++/RBodIGgwq4VIQyU5rxuCnXLNHDoPfss5bHTTQRfp+nk5ScEy5GWddQYuI8n1Ke1AW/8r3dr5psfTYJfP31tBvOklHvjg2K6s3JSsV60clr9BEtd+tdENgbzMgaGYUhvEtfdvFmRy254+CYJk7m1joinrQHZ5xXin9MPm3qXGrG/xua6Rd83CrJYwfMpVlxIxkpfs5o3ioaYj85r+/QDX6vOu9+xcHz7R/pQ0KSuuFxMm/kIzzscAnHKnhL57jIbWdrS8Esp5HRfHmG11qYvWJbfYJaozJtCGMrmH5UZkqwOW/BlL+TyhGXZaPj1edA1OfM+QISU6K6MyYCFjpewak18usCwBhvDDjLwhwdT1PhIAC3sQ3doJzj5SDBt9/UW+71/6Mp8MKtu0Dd44eU5THDuTjGLBZPjnsyVhz6/mujlQu2yI76RPkYDlrOGNATLlaSfjBXqo5qZ2+Ltcvbxx23WUe4NsdakGuRO2wdwOEaLVOVZ/rPtYwDWJnd7YtMRw43BgLVgJxk7Zn5Y7YmVJ5yRBHBNjEo9teBf29psoe9jpqnw7dUnqaCfjkJ0iOYm6AInWqCUZCVWlrK+iQxpBBrBVWYUOVa64Bmv930cq7NHsn9AierLmr5e8usDlwrJMUobEKKsb/sTYJGr1GS
 eV2WEJfH
 VUndOI93/G08UhJpU9pdg423VnUUhel6FY1fkBFyoRX0KS63Tw5pWXJuqh9HlrViim42eKrcC8+3GrQk+u4Uwa9DQO75hvnqfOOew/gfuXIgi7xPUh0ka/YYMiN2DPq3BddGLAdu08pYscQckHJFaO5V7cSEKkAzvn7E6DGf7VLjL4FBvWohDiJqXf015KX5gPJtWkIsifvQi8mRIjQB2lZaGmBfuG5cFpsSLLGD9GT+c1gDoKb4QIwZDEjb1OjSRHENIgwxTW8+bzcJNOJSLcrMQcckxSVEWEeS0JQv8jDehFHnddkAX6g9TauwFClo/k48jifll/d/gK+N/ruKvPzWDuOtjdwrIt39U9EuyypNmsOe4Fp6J+BnTdUq+Bl3klKjK9w0tdyoKIuyOx8KBlM8OQkNPWH0dlS980P5MLzjvyyFOqeHEyP2/eL5N1qY7RJIG7Azrtr17pWX+Euc7TfG0Yx7+HOJ9Xxr3DC7Osh03iBAw+naKExhFwKuoOwAXpYC/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied, thanks!

On 2026/8/18 15:03, Doehyun Baek wrote:
> Bring the Chinese DAMON documentation translations up to date.  Update the
> DAMON design and administration-guide translations, and add the DAMON_STAT
> usage translation.
> 
> Changes from v7:
> - Use the suggested translations for the DAMOS quota goal ``nid`` and
>    ``path`` descriptions.
> - Replace the remaining "聚合间隔" with the consistent term
>    "聚集间隔".
> 
> Changes from v6:
> - Clarify the DAMOS quota goal ``nid`` and ``path`` parameter descriptions.
> - Improve the translation of "offload" and fix the duplicated character in
>    the non-access-pattern filter description.
> - Consistently translate "tracepoint" as "跟踪点" throughout the series.
> - Consistently use "监测上下文" and "聚集间隔" for DAMON terms.
> 
> The changes were suggested and clarified by Dongliang Mu.
> 
> Doehyun Baek (7):
>    docs/zh_CN: update DAMON design translation
>    docs/zh_CN: add DAMON_STAT usage translation
>    docs/zh_CN: update DAMON index translation
>    docs/zh_CN: update DAMON start translation
>    docs/zh_CN: update DAMON usage translation
>    docs/zh_CN: update DAMON reclaim translation
>    docs/zh_CN: update DAMON LRU sort translation
> 
>   .../zh_CN/admin-guide/mm/damon/index.rst      |  15 +-
>   .../zh_CN/admin-guide/mm/damon/lru_sort.rst   |  68 +-
>   .../zh_CN/admin-guide/mm/damon/reclaim.rst    |  82 ++-
>   .../zh_CN/admin-guide/mm/damon/start.rst      |  63 +-
>   .../zh_CN/admin-guide/mm/damon/stat.rst       |  94 +++
>   .../zh_CN/admin-guide/mm/damon/usage.rst      | 523 +++++++++++---
>   .../translations/zh_CN/mm/damon/design.rst    | 667 +++++++++++++++++-
>   7 files changed, 1345 insertions(+), 167 deletions(-)
>   create mode 100644 Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst
> 
> 
> base-commit: db6ed2a3d31068ca5577466591b2521dee0508ca
> -- 2.43.0
> 


