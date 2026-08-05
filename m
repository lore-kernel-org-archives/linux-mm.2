Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E4F8C55184
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370666B0093; Tue,  4 Aug 2026 22:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321536B0095; Tue,  4 Aug 2026 22:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9C76B0096; Tue,  4 Aug 2026 22:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7BA86B0093
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:20:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEA8D40374
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:19:58 +0000 (UTC)
X-FDA: 85065610476.29.1C555A9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0380E1C0002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:19:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EiYHXD48;
	spf=pass (imf18.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785896397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvpaW75bfRjFkTSUVq3ChkXPyDkLZg3HVOtO3k7VNc0=;
	b=H3sF48Aq23XUYnFHOdj6wYmVnjO1L2D2bZ+mhk8P5HpLknV7uHvBGtcwVz9iZC95ottSqN
	skLMuePf4Kj9LGmEhdj8ZKXgKbjFtoFQAKjMNmUIMcIgPQggiqm26RFwuraaSKbsIYta7+
	iLVP4g2fACKHArDKEWyoGcq/jaXjJ98=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EiYHXD48;
	spf=pass (imf18.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785896397;
	b=3UA2YDXpVli4VyzgqcSi7JRJwH/LkeIefqqkTNenl4wDZTmgu0NONCRYunscv46rz+eQeu
	zDEQq14bJbWoU3dosX5gmyCwLH9XE8rnVD8IUH0AmZNOWj+/nAZ0vcFI+zR/3pirZacwrF
	4ghELkG9cixgtFqHXGv0ky04I0e27sg=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d02b4c3601so5793575ad.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 19:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785896396; x=1786501196; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JvpaW75bfRjFkTSUVq3ChkXPyDkLZg3HVOtO3k7VNc0=;
        b=EiYHXD48d7axxHPn8xmwWeaKd0L2DRnM9/jhRpoipuQ9qYMJe0SVf4YkiZc9iNxkVR
         zdjhPFGTfdJaGwpc6EpEGErWZsEgyw46xIvNUeKdhvb3Xdm/VWa1zAQuTON4Jwip8Q2n
         GSKmw8ZRgnQWkuPCYx+f1RqmjWCLi+3eOZ0Brd6tgaD34jFAOYqaMmGNu6DeYzShvH4O
         Qs4BBc2bQrD0B34BOg2gCl0m3mZ7OyVc8MK955YAuByBn8rh3PvcE9ICB/qbn+4m1cNL
         KcZlRszEqTz6DemuZtnaEGVaNtZ9QgtcjdFnqHSocohWdw3Uao6ugj8y0eo3Bv09Ee9D
         qM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785896396; x=1786501196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JvpaW75bfRjFkTSUVq3ChkXPyDkLZg3HVOtO3k7VNc0=;
        b=E2+w4I4Ep7F1N/+NpHrFFHpy8NLQw9oGb/l/2COmLg0mdRmAGKsVxpHuu/KKvwV5TZ
         4c31i3i4+wWBuvZZH8rcVO79wc/NOZ7mUnJgxUWUfFGBDki1HDWbHdLptXcFDcuq4i9S
         ueMFf8W/mJMuiJQ6Klw2y1gLgDujH/aRq9m4L/CigxR/4W0Od/r+Y3M8B9/9+HsuDcDC
         6noWU3FDiwrjQ5pycWyuxNUn64ShXyDWVV8JjjFQfETVQwgRICrszWcm4BlvOQm0NkHx
         NS4WpKfiRrg0fI2Z0sECmIRb2DDawcbyIiDV2G2u2ih846/D/2pFT7YTvkZdv9UlrGII
         W2Pw==
X-Forwarded-Encrypted: i=1; AHgh+RqXsFIvH+LpZ9CXUC4N5QFrhtd8zBbTxJzGuAhE3h0rfcDzJGhqvQ1HD+voJgZBG/wmJ13bjL/kWg==@kvack.org
X-Gm-Message-State: AOJu0Yy2cZ7v5GmeggU/rzXi43pKN2wuPXEYjCUU1K4Vp2gj8JKn1R/G
	DkzosY/BYAHBv7L3BBbdHCT/C5yJLfcUmGHuUgHZaxsDr4O8OdMzMB8I
X-Gm-Gg: AR+sD13QhUUg2DkLowFdIxipl5G9QUg5urQlQVGl17xe2jeXNU/9G8SCfiluOmX2mpq
	mII1IX0HUnz212EZnbD07aYHqoYfZQ+TKVnn2rOhSCtbgincC043z4eHxjmBBCRGIkZgpAA2fI5
	T0paxb5r+3Ok8wdFY+NDCG9eGgLtnLgWGTk+0Axq6i6wZskM8baZgY+vL643Tz52BEqqwzL6rac
	uIYcOfyrUfAQhR6BUGAeyzKM8Ylpk2cJ/VG/czJxaDqD9fv0wLD54n0ujs6smhuji4uA8utCRbr
	aUNmERLZWVeTB87v6rMBP4FVGdWTCV8LxbxGa6/Pz152xy8rd2iipBoS79fM48KpO1NHFCBPqla
	7hz+NbCYrJaokTpA1O9p/5bKZPsYE8suI/LsFhXWsWKkcY92VpinylHKuPAX/mvmLO2E+ZQVyb5
	ZQbXNifI1xp2PpotWpdwfjG0RyJbgszsWASxHBYAJDmwakrXsr8U1vtJgeh0+pDMcc5CJYnkVmp
	3z5Lg==
X-Received: by 2002:a17:903:2a86:b0:2c8:1f58:55dd with SMTP id d9443c01a7336-2d0ca7586cemr42871065ad.9.1785896395678;
        Tue, 04 Aug 2026 19:19:55 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9f936e2sm14316465ad.2.2026.08.04.19.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 19:19:55 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: baohua@kernel.org
Cc: senozhatsky@chromium.org,
	akpm@linux-foundation.org,
	minchan@kernel.org,
	yosry.ahmed@linux.dev,
	surenb@google.com,
	zhangdongdong5@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
Date: Wed,  5 Aug 2026 10:19:44 +0800
Message-Id: <20260805021944.1753869-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805005545.66112-1-baohua@kernel.org>
References: <20260805005545.66112-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tnbw7jxye7oae5wfg9ys4n41nmns4izy
X-Rspamd-Queue-Id: 0380E1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785896396-517771
X-HE-Meta: U2FsdGVkX18CwioribQuwIAJ8f41krtBNOzVRbRYbRpjP91dCqC2xBBZgO+9fWg1ZukHCXcF+kOpvKhWc0cRncLv9gJjw28MZW9/bjrNGVEIPfBR76q3AP66GG5C40rciP/ZI/iSIxbK4JtFGEGQrQDka1JUFGsFuqBdgq5P0oAnAKpc2E54IfteuZ9kFyMGH1ajuAvE4+xsOgCa25cliJPmK556FWcahDANAQbY19q+NhbdtifARXhwVHxRQfMgOKg+yXcOVSvTQZx+NdWidyjNVPxUSJkCttfUZD5n5e25XYgWEutX+jY9YfmRTybrPh692MHQ/IlQWm0pWcZv+PnaU317kYUHF/ThHT1jU2kCxf3lunXvq/mbKL+5ch6buNIV8w3kmu6ObIXlNwvQ42isE1rvAy2iOgOnS2llY8r7dri+CX+TUNRViyzuAVUBCIR9Q/DLZ83ah16GDAmzESmSYw0YUa6zx13fIcfVrTetNnWrtDYOFCvuz4yg5Lf7XqFq2sD/70hIFWfNNA0jz8PmcApbfsx4CWQ7D7VOjzcyff8wKrRPDRv/6JfYXDDT69qPTEQNXxiflbaEsxD4JLAME0CoSO1bq/nuga2bsyoTqNPJG023wQcei3Py0rG+AC2X0q7Rp7suw3z+sTmQN9X/mJw3xkuAHfKO7vXSg2sXOpDccgOgP6cZs/WXmsXGnSUnnMEphmDZBix6JS3hA/geq80OUPSJ6PY0YR8MPOaAWKkJkEN/wIkdsfOe2087XOL/RHd9jWxF8tECjAI6wNI1lGHquyM5Zf5TW7GvUQuHprCobZp3Z6Jl2hMAeuewTIhgjTTwp+3wJsQ1T3kd4WAoen4mevBP3GV8TUwl64FmQdlOE2QUdbclz/I3YIEdMrbu/0BDN99kgXqVOt3qvsQjr/PbBVuglenwF9KjPozsjNU1IHcSdPGfAVinNcDYw+KKVukNd2OczDWgqQK
 0K7Y4YQq
 EmyGR0/I9Kq/q8CjaERy5nrhKF8dB78pUZpVlAvWSIINMu16TgEfAgNoTmWgyaWvEGwhhGSp6wC4TOa8puGr1cfNRhG4lxSOPH9Avz+0dD7cD8fRS3nGbVshbHgQvzPWa9lQjy5uGAF58Upy1rm30m2y+hrqeM5LcRq4IMvq7/WJMT63oPovf6bNMTyRUfKKT9ZouXuepofln/1uKE0XHqYpJLlFacZJNSw/opUDWei7tVz65CS3Pi1sfpLIemmEqEpQd6w94HKikJbgZ1hsiJiLqL7ZkAC02wI5i1NogXbkjvuJyJe2thH5agErI7jIWUyozTbqEeIRf4OozgoC/nwG5R7StxPlCUqVj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 08:55:45AM +0800, Barry Song (Xiaomi) wrote:
> Since commit 2efa9e9eb4db ("zram: permit preemption with active
> compression stream"), a major Android regression has been reported.
>
> We add an async flag (currently false for almost all backends) to
> indicate whether a backend is asynchronous. For synchronous
> backends, we use preempt_disable() in the !PREEMPT_RT case. A
> zram_zs_malloc() wrapper is provided to support a two-stage
> zs_malloc() path, allowing allocation to transition from a
> non-sleepable context to a sleepable context.

Hi Barry,

Thanks for working on this. The priority inversion issue on Android is
real and we've hit it too.

However, I think there's a bug in the zcomp_stream_put() change.

The new zcomp_stream_put() uses raw_cpu_ptr() to find the stream:

  void zcomp_stream_put(struct zcomp *comp)
  {
      struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream);
      if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
          preempt_enable();
      mutex_unlock(&zstrm->lock);
  }

It relies on the thread still being on the same CPU where
zcomp_stream_get() locked the stream. In the normal path it works
fine, because preempt is disabled the entire time.

But zram_zs_malloc() breaks this assumption in the fallback path:

  static unsigned long zram_zs_malloc(...)
  {
      if (!async && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
          handle = zs_malloc(..., __GFP_KSWAPD_RECLAIM | ...);
          if (!IS_ERR_VALUE(handle))
              return handle;
          preempt_enable();        // preempt is now enabled
      }

      handle = zs_malloc(..., GFP_NOIO | ...);  // may sleep, may migrate
      if (!async && !IS_ENABLED(CONFIG_PREEMPT_RT))
          preempt_disable(); // Preempt disabled, but it may work on another CPU
      return handle;
  }

If the first zs_malloc() fails, preempt is enabled and the second
zs_malloc(GFP_NOIO) can sleep. During this window the task can migrate
to another CPU. After preempt_disable(), we continue on the new CPU.

When zcomp_stream_put() is later called, raw_cpu_ptr() returns the new
CPU's stream, which is not the one that was originally locked. Which may
cause a mutex_unlock() on the wrong CPU.

The original code didn't have this problem because zcomp_stream_put()
took the zstrm pointer directly:

  void zcomp_stream_put(struct zcomp_strm *zstrm)
  {
      mutex_unlock(&zstrm->lock);
  }

The caller always passed the saved pointer from zcomp_stream_get(),
so regardless of CPU migration, the correct mutex was always unlocked.

I think the fix is to keep passing the zstrm pointer:

  void zcomp_stream_put(struct zcomp *comp, struct zcomp_strm *zstrm)
  {
      if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
          preempt_enable();
      mutex_unlock(&zstrm->lock);
  }

All callers already have zstrm available. Then It works as expected.

Bo

