Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5C1F483E5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6FF06B0005; Mon, 23 Mar 2026 14:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47F36B008A; Mon, 23 Mar 2026 14:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E3A6B008C; Mon, 23 Mar 2026 14:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6FAE6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:38:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DE27BD73B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:38:37 +0000 (UTC)
X-FDA: 84578188674.13.4173459
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6EA8C20008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:38:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WL7Had+6;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774291115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EkuvjIWUVowxcCQSmc7Xfmxuwhp5n7SrwfXez0NJsU=;
	b=rRHV5bmP8JiDRZSr9frbmsMO0dZh5gfkPvw93N29RLpUA3TqAWYXmuLwuX4csEBswBEMFr
	G5ksay6ro8i5vM/8ZQ903ET0dkFQX+KWm6j+pWILd9u2Ye2QTg2qCO0qBKXYZSKNJ7BMDs
	jMvvJhGhMFn62+ob3Rue7PPH/xbKxhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774291115; a=rsa-sha256;
	cv=none;
	b=e8fpjFWNFfdMqGvWFJ2qZK0OeLSnPTALG5AlJW+0N84MRIs5QGtIk3Ufp1xDp0VvKBxKqa
	I2iPaSp18t2v7EiXDa9CSxk7pXAvkFuMTvC1p8zdhVDbzS6QQ2Nmex3+XjiFHmvMBM8Xnn
	UimjMUW8ih3B/LQ2FvxCV8Odu6xi03U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WL7Had+6;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2aae146b604so30136145ad.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774291114; x=1774895914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EkuvjIWUVowxcCQSmc7Xfmxuwhp5n7SrwfXez0NJsU=;
        b=WL7Had+6zF3ayMhMsf4gFt/kaYcoioy1p7z8zrCC8hV9+QJu9CtiSVXuXEUMjtrWG7
         O05k7F7aQN0hB/767lVGY2FTHqWnG4hLsaumuTeOlGa5CANWELZEIZkogECR80/J0iKk
         0fAJ8PokuIShU2oGYdgjps9Z0sSrmTNGBS7HYzbg7MW6iYhjuGP9Mke/W6LZANm8D9OG
         OJi07Fq2bPuvfIV+IJvPZPl9DocIeU/T5MHc5KV5SeOZz8sU+gsiTkikwbCG8p5ejF5P
         FklI3O+vMfCDbIZrydoAi1lMizislQGLa2017yOQMVrGypYH+WScGCxJGAj9xOh4R3rK
         6zww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291114; x=1774895914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1EkuvjIWUVowxcCQSmc7Xfmxuwhp5n7SrwfXez0NJsU=;
        b=CGfEhXzTNeMfWseFnmisWRLC53mJJE8INXij2MtVSnIypAPr/VlnS2W/hNCJwGqg1B
         Ee1/q0yK/V2tqJezqV832Wrs8tqKC9KrOnNNt8k26EtIgSmuCvpA0QyCDlQJNfRutI2y
         fGGM89OPmKh8bcPoibUK3V8N1kxdYKcfpIN/fCp7zOngFCqgnaC/CVr8RkHvDtPvVJkL
         J+v6+1dGEb/Js36rFj6XpSft8yQx7xSI1WXa3zcyvkQYFcFt6LVw47KB+4aQ+Ii4ufni
         SCQ8agw/2DlLGUsqSvbSw7A48VTydxNayQUTUyoUC2N40rpMvqoM5TI7CghosrRIQlEE
         6sCA==
X-Forwarded-Encrypted: i=1; AJvYcCUD5qTDAk4fRB3vD+fvie2WSNld+PcFd4PzoH2V2IO0245DnPiV/53sJ9ptYHrS0YwrzmaT8UQ3zg==@kvack.org
X-Gm-Message-State: AOJu0Yz73ag/Mb8QppsHEeBT8jvCAbOIV2jrREYyumwTQnDuaC4OvEVR
	JmTVjwGJBOIW2R4Tr6b+lYDukImXZ7evitQy9FfT+wwXukRTmbzhIzjG
X-Gm-Gg: ATEYQzwQT3pvNxtQMBiE9cKJwkgXtmc+vvdNXYWGdG/8K9a7OAXwi54KZZlJnQH/Whs
	YCQ6idcPJ2qrem5OJiM2z/YjAAt2obLhokFi5NzrMXny+ITRCExMUQh6JgNeYFzVqyquOsXSUMe
	ft6sJXxzp6xv3DGE9G2pM1ztJ3xpPj3apqG5/dHFWGFDHyitaaiOCq106OAZWdfgVapCDr04mSk
	DFPWBkAi2VQu6UNqQ1mtmUhQv0U3reAdv/UCY7FT4Ti0wQV+rYEYWM7PP6K3r/t+bvWKoUSxZSm
	A8L22lmyi4gGUpeSVC26ZGoeAGtiChjnFBJ9+U7V4M+U9K5BJBb0C79wCwlh4A1Q2kQbdQJzecl
	tWXsoetWZ85VORP/uo00ogVh5EVlka4u39DioL8BhK4wdFg6GKUKWrtKBYpKilzed3Ym+iPwtMx
	QGUDTuWOLZyPQHO/6ISGiVGBlz+LM=
X-Received: by 2002:a17:903:2fca:b0:2ae:ce8a:9dc5 with SMTP id d9443c01a7336-2b0826f50b4mr71458115ad.13.1774291114265;
        Mon, 23 Mar 2026 11:38:34 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836556f6sm156153205ad.49.2026.03.23.11.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 11:38:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Tue, 24 Mar 2026 02:38:30 +0800
Message-ID: <20260323183830.42248-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323151611.81358-1-sj@kernel.org>
References: <20260323151611.81358-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EA8C20008
X-Stat-Signature: bgrkm8kdepoojomiwgyjxw6mmd11u6uw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774291115-830847
X-HE-Meta: U2FsdGVkX1+uQPo1B0ZvL1vIlcsEsDU0uwD8ig+mISI82yt+BPcRZ38YVUSvOL3uYguNpTZXY95UghhPRyNZGye3My+vvswvpU8b1+PL1+LNHJ3/BBDrxalIl9fZXauCS0Wq2/eaxzzPVSZp/NhDZ7ghsHpjaR4ejkbj8i53c+QHp3aBZcGIc3eN7NGguhCXawGfrJC6JQjQI1+ZGXwsTrUlicDVQYoqNgjra1CcjINN9cZqi302//8Xc6KCGtKXmhSgISj4ZU/LcGk8KH5pvTVKPp5inWsm4baVcFpg0RYS/gacA0bTh63Op9YPfAZFafMzp+TpMowAxcJFNVWzKRgIGf/lqiGJIMN4T44PimNqBveX2b8uF1WdnHQ/bOYd1T1mDN57nMj51dsaNoX/8Hi5zX/zbAJx9ge7ADqXsNUzJz3QlXvJFa1K8NYqX5G67+zIZrjcGvUu0UVsRDsXa2MSH0RCRKGPwzVJB7/wI/Hlb5r4O49C0UGNS1n2kLcIppKRIsl/rZvn7Fi6nFAlr4cv2BmXhCIcp1LgfrQXMRJsL+LGy98z+kHelYIge2B9AMSEK/VxonOvu5JnTczzNzxVFuYBquEcipjx5DaVETf818Rlu3QBKDfwyJOSdmtSaT5KaiwFO4hZJJ8BKHsFiTFiG5f/kuFkbM3imMYD9TMMv/fPEy2QvUjLw4k0XegElZNAI7+pgE7WnI74fxgrIgLUy41FeNzOqRhbuugXJHkkCu6ayWVVDyyhJwtk4aUInY1zGYVNuxBxmgOFbG1/9PpZSYJmZ7Ypv/YLHsSv5Q+GU7bR14jAaGso6tTBqrAIJhfndn7udXjUm+C4dDUeXwktL3YP8DYQiMvvsExwSogRXVibf1+hhOeBxjKt29VxVbKKpgMcXfGVavpTbvtvIWEadoHs4BZxyqX+7QrvSd/rBIax6btUpq6BrgXqBxpuxBSTec9UAOnRUZB/Q7K
 hi2uQybF
 Od282AYhyaz6Tqih8eKQA1yaUcDp0Z+YdGb5ciPmeonl94PFH/NORSBWO5HqM+5/oA/L6lBHNLY0GSqs56xSIuS83JAHYmyg/U6njWjcRO9Jssqb4WYQ7sn1fgIT2OauMVbjCoQAU47QBtsMYN36njeTCEYznCI/Eh3K2Vfa7cu4gx6Z8QeVFt3FcSdecuvZvX22DYKtsV3AH9k7YwgpIOYnWWlHYCYqPi2+FWlzNIGWLro49OQ9L2/zjYnYsA+jUPD7D/oIccqlB8sqtGTXaFN0o6psBwHdSUyHmKkYbu7PgGN3Ho1TFYp3JbspCxZ/df8zczp2Ja7HD9GV6ZkPjPy/nW1kfeaQJzojaLFw4ezVDZSSDFKpmAZRFIuAlvTsGGJPafPMFm42mgPirCnHT0sULjPUqPt4z3qeR50MoxMt1lKG6QWe6Q4aLEHY1jmwjLLXXbYkev/nAztLXV3y2jlStwV43QDUzMoMf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Hi SeongJae,
> > 
> > Follow-up on my previous email regarding the locking concerns.
> > 
> > > I admit I don't have an elegant solution yet. Here are my current
> > > thought:
> > > 
> > > Add a timeout to wait_for_completion() (e.g.,
> > > wait_for_completion_timeout()), using 'damos_watermarks.interval' as the
> > > upper bound. This prevents indefinite blocking of 'param_lock', though
> > > it still holds the global lock for up to several seconds.
> > 
> > After further analysis, I realized that since both 'commit_inputs' and
> > 'enabled' module parameters are protected by the global 'param_lock',
> > stopping kdamond gracefully (via enabled=N) is serialized with
> > 'commit_inputs' writes. Therefore, a classic deadlock scenario should
> > not occur in normal operation.
> > 
> > However, I'm considering edge cases where kdamond might terminate
> > unexpectedly. In such cases, commit_inputs_store() could hold
> > 'param_lock' indefinitely, blocking other module parameter updates
> > system-wide.
> > 
> > To mitigate this risk defensively, would you accept adding a timeout to
> > wait_for_completion()? This ensures 'param_lock' is eventually released
> > even if kdamond fails unexpectedly.
> > 
> > Please let me know your preference. :>
> 
> As I mentioned on the reply to the original mail of this mail, I think such
> infinite wait will not happen because damon_call() is aware of the kdamond
> stop, and therefore the timeout is not needed.  Please double check and let me
> know if I'm missing something, though, as a reply to my reply.

Yes, you are absolutely right. My concern stemmed from a misconception
that kdamond could be forcibly terminated by userspace signals like
'kill -9'.

I just verified this experimentally in virtme-ng, even 'sudo kill -9
<kdamond_pid>' fails to terminate the kdamond thread. This confirms that
kdamond, asa kthread, must exit gracefully via kthread_stop(), ensuring
the completion will always be signaled.

Thank you for guiding me to verify this. I agree that no additional
timeout is needed.

Best regards,
Rui Yan

