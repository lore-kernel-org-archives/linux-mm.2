Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C89CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 17:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5328D6B009D; Sat, 30 May 2026 13:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC366B009E; Sat, 30 May 2026 13:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D906B009F; Sat, 30 May 2026 13:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 172966B009D
	for <linux-mm@kvack.org>; Sat, 30 May 2026 13:51:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A608A403C8
	for <linux-mm@kvack.org>; Sat, 30 May 2026 17:51:24 +0000 (UTC)
X-FDA: 84824828088.26.9A8E64D
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 980974000C
	for <linux-mm@kvack.org>; Sat, 30 May 2026 17:51:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B22oubhX;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780163482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
	b=dpMUzzDvPkE/+eskgxjgXOxHnM/gpgCg2ows7JPDdhiEpWPKB8kz5If5bthY3hyHN6/IAv
	adXXPjIAZJkTbQEo6BtHXf8TuVLXnudcyyD3wEreAbAJ/eAXMxKT0oX6zYD/87c4h/Z8Pa
	UYha7Q13OV93WJo7hAC3lvUZEKG554s=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B22oubhX;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780163482; a=rsa-sha256;
	cv=pass;
	b=VNC/DTz9B+QJDXWM0dxsvf15OtwAAp8ju/iR3nUZUtvCQfiRHm1Nvrxn+A1xf+t5TE7p4O
	05fdin6R9N8M44eCaQMepxntQK2tgKvLpYAJI5k9SIwGJ7FkxL4oEpx1OFKzlqnnT9V2cK
	A+3iaHMpejS63t90abfOO3ZFeN8B9Xc=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45eecb8bf67so1970615f8f.2
        for <linux-mm@kvack.org>; Sat, 30 May 2026 10:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780163481; cv=none;
        d=google.com; s=arc-20240605;
        b=Ach0rr2pZqqzh//5HjG6sGOURq/YW1B8nQ4pV4ccuZDxFBkNSUqVuIy2R5330d2cre
         MStJHDsT6Z7vyfzHY+5U/ab25x3hV7etstc+7FrGOKICTv1SKTjAA5kGmyDPd4oETNJg
         36ATOsPnSN6gVneKr4+BeY5q01Fqz4gi+SunUnxMEV+lUh58bE6EbaFsdcDDnlKcP54I
         v2Yxc2kZkCDLxnh38FEc7yfKoW6usxWF/qISNhBLrzVgyLQx3RvZZhLepyl9HTEvs3K9
         33GvBO1LRs8jzUbC3UpMw817nRo7fsdo/YS5XEfwUycxWNOqE/ZdtP56ev9F+feQQVEG
         4ejA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
        fh=gOz+F44QAmuqtjcwrnfpbPmmHsd3IsMUULdDDdsY52Y=;
        b=ACW9doVgrbKe/juerzg0x43TTaTo9tE7pZ+xbroNj6QVsPhZNvKS1SSc7MD7ZRzLCY
         6/Uf/AjKXcSsUSnUY7y3rYS7mbrRGEJDevIwTOLvJNiuKQfRT282Gj9aEuSfhPsy5EVD
         87R9k7zS2NEYaRPNiQr7WW8dMPe4cVpP5xzgA2dXGKqr1UTO6fwqZvCYkHITiiLkR1wM
         cSYS2k2hGdvATSWFmpXLQBDGsTl+KNiHhlq/6BNr2DsMBjcV0Yr1p1QiuLnUFMCHtQbM
         nwm9zj8Bz/5TAxsUkxwSn2s9zYDLCWpMzXLzVwAGb8nQEqohPgiSUyMslCaTv39R9n5Q
         GQxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780163481; x=1780768281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
        b=B22oubhXvdUFVzShJzfLAKvD5hKdJfJAsRVivvSGMiR846yQciUaUiKHsth331phBz
         JI/y/5mmCvrn3E9wJJQmlbieTfxrajbpTzfRXxbtuTXSsJAbweyN2jhy54hF20kft34w
         JLuw5he9pxcIcOMtRNhFCf56PpNk+ibJqYI7Y9S4CpUUEbrqGZuYy0654DUe+RMcZtPK
         z3h8/4K+Liqw8XpQtPWe8mCAECkG2RqpvFldtLuwdZIlD/86gYs/OcRAx/okLX+m2DS/
         Dtlc9B2j/G+lc2IeRqdQwr0eBqJFT8DyKEvvbiM/KZepj1Ln/A8/SSzmy+oLI/RGLNbQ
         BIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780163481; x=1780768281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
        b=SyXrA1pDTbL8NM1mVQ221zndaYFOmG0Tq/+lbyUyade+/8SgvQa0llBj9x7i944TY/
         k93d6opg5KOLDj4AkleDJguCayOj34KVpciXzJXAVw2tlorb3weupPTJpKRqn7xXst7/
         6D7bhJ+Z/WxU2PqdDiuHeKXgIaex8F5AnRQxA+l+WuC0P/1gxR06f0yF0qUSw1srSnE6
         lhlgdEdd7UWOcWqEh/B+nv4CSxgPH1cQ5U9ZET1owrrHTUYsTfy9ymR62SwuBQO79D4V
         KSJhcdrh0GRPnF130OX+y/NIi2eFTS8LhZvnQ1Zz+DLjDF3I/6KVzsdOrS9uB4i05tgV
         UI7A==
X-Forwarded-Encrypted: i=1; AFNElJ9vLvSvoxNZt9wKXAK9yTimPpUZ5wvB+Kh7wkZhZwCMB0TrNY3C6ukFrQKv6Cp2ZjPYdYscqgSElA==@kvack.org
X-Gm-Message-State: AOJu0YwAJY0qlBiskryQaNsvVRk6n/kYV0Ymq7g8RxOyaaE2a8kNqd3t
	iwBNIOqUJp+GqiySe68GuZjGenYPCMY1BG/ml09ViS8tEBnex1qGJwL3aXP4oIQk+bryEBnQQHu
	dSAaY69Ej35SMzKxrD7BRYXh0B0oF0NQ=
X-Gm-Gg: Acq92OHNl8/ww3ZVbPoLUzgnDVmQFg+Je90vxwgZ6kmycaLsfP28OYKTj8HpOObpLrQ
	PrMA60bAKBX7cJGALqyBtqeJVOySNjrkG3lJ3Yr6DQzdIzE6pBrdruLE5W+tl0OqcfBJbln07xe
	8djUjTDhFk7NiQn25I6TH3+Jfsg9QeEow7N62GW2hip187vd3eL38e88tmcD0/ZsRNQWRhPodkF
	scd2ZnlquBEpJSZf4p3A6t0wa5IiPrNMq1WnjTRSz1oAVVwMUCFZsd3SUB1VLMa2dnSLnGvW//K
	3PrRe18YwuONijB125E3ekTmtibiSEvdiT2eOuDKzeIWd/Sr/g==
X-Received: by 2002:a05:6000:41f9:b0:43d:d037:d59c with SMTP id
 ffacd0b85a97d-45ef6b21a0emr7571210f8f.16.1780163480771; Sat, 30 May 2026
 10:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260527062247.3440692-1-youngjun.park@lge.com> <20260527062247.3440692-5-youngjun.park@lge.com>
In-Reply-To: <20260527062247.3440692-5-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 30 May 2026 10:51:09 -0700
X-Gm-Features: AVHnY4K_JUreZofOuMIpcH2pYrhoIRKIoA8T3KmoVj7Y7nP_Lo7fr1UunDUAmsg
Message-ID: <CAKEwX=O-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68uy1LHRq=JC0w@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier mask
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 980974000C
X-Stat-Signature: h6pskbc6amcnc4ebr73i6rri97s1az3s
X-HE-Tag: 1780163482-943319
X-HE-Meta: U2FsdGVkX18mJwCSxfcltFeAsckztHmyGvSFholDSTl4APl+ANGRR8NWKqqJsTT+i0XlafeEC0wJIMR3kRIiD3nLokuL5Yee+eXir/ynG4CseB2OF4C+SN22Bbg7ajUXvrKvfPCjm20+h6BlgD7TNJr4mAL05Ef/omkJAbmt3RSRDBq/c6qVV7rETO7eQ9mVFeeRgBvRFA5n3VU+NJZ4Gt5e6PBwvBQSfEQkJFX8UrNs38Lxb5vM6GVS00MT0c2OIwkQwUozNTw2ZbHCfgD/Ztmc/qqHy91NVULK1pRgCOZ/kyMxK7x3U2k8VEzFqaL0lvs4UdcOuKrm+TLEe305MC5U85sLsPfhIe4LMvE49pi4Mt82KfrzWr+MSWUzQvhQbXLxsLapKJnHmhaMCGsnat0xSt1xZ61Im8WWR7N5DZthVLgeYll8JEIPxgjd3vpSJCNyLmEAittbgb4Q30IIDG7F7Vx2+VqjW6+Foen3rYmJ72vGKQm4FMK7j0D3mfzUXq/FWjEYXcVGDMUVpBD5dhNyABS8FHQhT3rWC5PG4iT4mpTUw9oJd5ekxukyIjMXT56qHOCBgqJmGHM0hRsnUpGm6xyCs47q+9AGhezjhFr4bSoX9mhCl1cKp42UR26xq9HUlw7dEJM+9+cfZDg06//1StB96+Ow5/QQ7IZ3PsHgP1TGTnKwM5vJSKq1oTSmmHaF/+IcgsaMjufxzn7ZQjbApr1odVK4FbAZnqR2mySqm0zE65e7NZwcPsnOEQln2lrQAWt4GeNQHqfHpMsHNIYrNAubwuMACP5iwf/aI3iVkOrj5Lvg6Qmz4KZ1qkcjP/QaR3rEqRvWOf6HXg7QcxO1r1XXzejYYEaktH6JmxOb2hkYdVSFUnCh16JBrSXl2nRM4VrdnMV+xYt1XZRCtQqsnokcNWLPp+wwGyoIUXnZVMYysupnFNhA26H4iFqBazpbuHTkFv79+p/Zk0D
 VwiRFDq8
 hf4zNM9TEBT/gI8vGESYkQC7YcOjwiiSfM7eZFv6QDa7WL+IrV+azSwgPd04+kqEIXt6u350hfoNJQgduaQVq/kL2oy7TcWnGHjYdtFgiqF1b73qhjgKYAYQiyMuubHrHaywF3/Me5xM2BSQXNBfc3xUr8e3CTdUg06Z+T4F6Gf3q+Gy9cHoAY+Tfdcg8atunP74XwDr+fPPza/RziTmeRxpL+9+IaJTqtVD1VHH9VOa3Ha72KycRJcMoNiA93VWmPe8weGOQ4JWkfde+zOkrFiyO76nUPawUH8m3i6ETtYaTCElPAw8sz6ViR6LCtzNsGUyUcX8eP9b51pm6AIrl8THRvJCWbFxe6P0ku81vOhOmmeHAy8ZbcJtlJ8cqdqlPvmOlyfR0xOp7mEky68Fc00IIQkpLipD1VvG31dqJp/bfVRiH1mFW4RxjkpaNp1QZ3UvK1wdGRJjXXnf/TKkSltcMp/v5upNjc2Li
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:23=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> Apply memcg tier effective mask during swap slot allocation to
> enforce per-cgroup swap tier restrictions.
>
> In the fast path, check the percpu cached swap_info's tier_mask
> against the folio's effective mask. If it does not match, fall
> through to the slow path. In the slow path, skip swap devices
> whose tier_mask is not covered by the folio's effective mask.
>
> This works correctly when there is only one non-rotational
> device in the system and no devices share the same priority.
> However, there are known limitations:
>
>  - When non-rotational devices are distributed across multiple
>    tiers, and different memcgs are configured to use those
>    distinct tiers, they may constantly overwrite the shared
>    percpu swap cache. This cache thrashing leads to frequent
>    fast path misses.
>
>  - Combined with the above issue, if same-priority devices exist
>    among them, a percpu cache miss (overwritten by another memcg)
>    forces the allocator to round-robin to the next device
>    prematurely, even if the current cluster is not fully
>    exhausted.

I had very similar issues when I tried hacking vswap on top of swap
table too... It's even worse over there because it's not just
performance - vswap needs special handling in certain cases, and in
some places cannot be used at all (for e.g in zswap writeback). I
ended up having to add separate caching for vswap device:

https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/

How expensive is it to add per-cpu caching for each device :(

Anyway, as a first step, this LGTM. Reviewing from swap's mechanism
perspective, and leaving the cgroup side to memcg folks:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

