Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F57C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206C36B0088; Wed,  8 Jul 2026 00:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC456B0092; Wed,  8 Jul 2026 00:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBAA6B0093; Wed,  8 Jul 2026 00:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF4326B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:15:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63DE6169141
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:15:06 +0000 (UTC)
X-FDA: 84964294212.10.40C9BC7
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 76B761C0008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:15:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Putq0zgF;
	spf=pass (imf20.hostedemail.com: domain of richardycc@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783484104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W84eONMzd21uI8n6Kup3L2Szl/lpUkxJvZigQN16lbk=;
	b=RxuxCy4AuHoWhseQjtYHVzEkw6mUCd+gbGKzaBbhcX/2sV4EHCb57MJN5Bq8vsOlZQSj2Y
	bBFMXOcaqohSliTWytX48Wzpn/Pa122mmRFsj9K7zpMVJSbzaBJ0v78oQgKDCnO058IiGO
	g31rXFTGjO4ih3NN7ZJrcXhc5+TibVQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783484104;
	b=yN08wiC/NwEP2RHYF0dzVJVD2UkQml2lEqIfmvrg+/wVLeyrFw48reS0RuhywtcMQZo/Zg
	QdT/vW8gOAxB0SUFxj+0upUWbc00rnoK7JFLYusqW/e1WizJDDtjRUpsGKRtD1NoPUPjo9
	dLV58ld+5HMK7xqg/DXmiLgjFGZlmJE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Putq0zgF;
	spf=pass (imf20.hostedemail.com: domain of richardycc@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so3966e87.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 21:15:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783484103; cv=none;
        d=google.com; s=arc-20260327;
        b=C4i/AAy6lW50Yycu3/uyfpbO4wVkyj9t0CQJzKX3CDzUXU4ZJeSKwVqOhtpxRyJdxs
         LObWpKUt9hcRIx0j0BKobnEfSqSbqFssQmcwnVB8+NGnp5lv92uc0rbimYffWpvBA9MH
         lTZKmZrg/kTADJqr/5G7rBZJiVyCQfozyCc0JwHqdMQ25epsPqs4ZCTgU1+iW33y4CQT
         e5EJAnPKMAGDzD7CPViDutSwoL5k8jo9kFxq3PPA4JmHQ+dK7cu9uiB5GTrrycaz9jHV
         QBEndToH0FsvPoeMj/1T5IjywMK4ha5HGuz9MdcLiyfmxEE1u0xkeSBFMzPECQvIcMZN
         HKWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W84eONMzd21uI8n6Kup3L2Szl/lpUkxJvZigQN16lbk=;
        fh=75UP3h03KrAYaS2iZybdo9WfazgwaYTS0A3XqtbIuxk=;
        b=YGB2beogfmRRCiyOTnPBFE5D/5KTD6tSE9UGCoUuNYRBy2rNoXGtbDq0CHtY+ekdAK
         K0EGpuzJSHOV+kuoXi9P8/hr6xdvAYn8us+uh42zJndVeTHgWz8BVD1ZTIVXS7ac7jYF
         jLE8iesfHuRKMcNmzqcPDWlY4i3m4SkhWOYE+I+itiIVM/+ibgQwHqW8Bvg1zSbxyMsK
         m5H1u1CCZJd3LpkExQmouw9NVAHyrp8imli5yqLO7B1w5h6EpZw+OgGZblxpxhtEJ/0K
         tzVnrQP6KxdD9198wweWmiTkbdsI2LJCBRQKKiBE0k3++EU+eji38rjTwmiHCKI0EviV
         IvAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783484103; x=1784088903; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W84eONMzd21uI8n6Kup3L2Szl/lpUkxJvZigQN16lbk=;
        b=Putq0zgFKPCRGSG0XD7ko0S5Er5JmugIizSwPwgGaPZtYdRNPYYM1puSIAS0Cw/ssx
         BcP75F7RbCLEAZb1dOc7mlGV7UhoQQoYOST20mQb3o2Zx1AAHQAroOMNMCJt3MBAI//u
         OByQwa+oSN21ZpBsggyY+o0AixijH3TJF4iaOebyomuu1nitwKGb41tZOTAjPSJ/Icks
         5f8dbc3sIDCmvl9zXm7tL7bBOFvrx7kgPYpyDalWziHCyn+4waF4e2pqVIqbsM+71tOg
         A7Zbm7CJu+NqjN22yH+yDWpnQpafFru7rOxv9ZaptqUpG3DIeG6jBrf9BHii3m3851Se
         6G5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783484103; x=1784088903;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W84eONMzd21uI8n6Kup3L2Szl/lpUkxJvZigQN16lbk=;
        b=gu733nx5PQPjHDLx/4n85Z6ymvUPCX7ypuaXHxQxpHa0frB7TvyXp9wfI8VTTYMB0p
         83YjfogHmzyIaB867RBiER5N+qpAaCm+8qCk9hiAX+PpEeMfkNi2BLlkgnb6aYlrwPxO
         fvWt6BgN0Kh7TuFwwqc85CM8VGLV35Kj+OwvUCoO1S13bJrQ9rOc6bAxrodiSxFGO2hl
         SYYDFnAuvLJk7p5Fy+gX5CmZl++1uXEa6YXsyUgLn+fyYdrPMIgynb/gwcl2YCIEHjMj
         LUXFvcUOpWKi6exnOx3x2RVIaUHOz593CfZMXHtJhX77Upq1qXcaA6oyOZ6clWD/e9n+
         s+tg==
X-Forwarded-Encrypted: i=1; AHgh+RpNVZS0SF9FPmr0/+nIwkKjBrTZl0myCBz7M5MGnid7RVT+sZMCOGAETz4n+qvPq5Gz4Urv6ivzxQ==@kvack.org
X-Gm-Message-State: AOJu0YweG4P1aDop8PoGV7oybRb3Y1hf4BYuEHO+tSdFT72RHoQPu7sY
	iE23wczIGxi1PLA/N7OR1M2UuOPQ/qm136WKzLvPdIawT0Zf7K6b14T3eiFpXnbSm72xh3BtZ/h
	3jtfK0PrAzuirMzPvV3G2RBwJ4Vglzk3kDh9kI9k=
X-Gm-Gg: AfdE7ckymWtG1akXAoI87ZkBT6U7yij9IXW1Ly7MnZOq1fo7B6Af5PAeXWFqKm9LonS
	LX8Hu7xSNzCg8CBREEycnJQ9InPPkmRu4CzkTzs3kaOmJybzTQjb5VJ83tWgJjStE9Y00TXsH6y
	+oPGDemGsGZ7V1o9b3YuynT05j3yUCoTkPWDX6800T+O1B9hOC2Y7arkwTO/DrvmazLByGitnno
	9oXhCP03OBWcTnlgEp+XNU03aKk0bTvEHipGV9tYImy02Ssunim8CEknIVtOLWmcq/90xJfoXaE
	CpViNQ==
X-Received: by 2002:a05:6512:3094:b0:5ae:b843:9470 with SMTP id
 2adb3069b0e04-5b00ed5d6b6mr94786e87.5.1783484102380; Tue, 07 Jul 2026
 21:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com> <ak1XzPxbwBF72d1m@linux.dev>
In-Reply-To: <ak1XzPxbwBF72d1m@linux.dev>
From: Richard Chang <richardycc@google.com>
Date: Wed, 8 Jul 2026 12:14:50 +0800
X-Gm-Features: AVVi8Cc2ABhJLrPwihS-mGIQPZ2X2cz8StYusJ-j5owR0_gxE57sft8H0gQkyOY
Message-ID: <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 76B761C0008
X-Stat-Signature: tzam9qhgn7xbpx4kiwfgrjymd91t3kfd
X-HE-Tag: 1783484104-267308
X-HE-Meta: U2FsdGVkX18fYxkW1ju0PD4Pe06u7IzBuIMEwsMq5pD5vE1auHsvgD93tJyAkR3x4UmNrO4YV2ofX8aN8kPCIGUKfF54A0/eDZzw2/d3tAiL54hxoYn3Rqzmdc8BiavC803BOOXgKO+rreFQWR9g4NDszZADTg8/nmGl7GGTatkorqgU8iozgdIFJMw5BhfxA0LZKr5Ye0oCDr1wA9KkST1aQcB+nxPkyRMjYUJLVUzGj4G8iEQEZwKLB1E16Nd+gjaeDqQxbmwLtz/jB4+3iWy+XngvbiRcvg15CjPr1TY1P0FqZw6pjHsf8bwnF1vLqD01tGjEdSoM2tBV1ih9FDusHKGly3r89wzspClPDjrsJyVippgQoMGQS7CU1ykHeBG9qab8dednJx+A0u2USpwqMBMQecALVv8px2Urfe649hbmmUp/W+a0KYwzirOp0sPIRhLh8wPx4EbrWdMvye2z7iZj4AeslEN80B5B3xHZosOxMMjeMBRSKkLsHfNLkFpFYCDukWlETbR8Bug8GZX/xQeVfID7sgY2RgYpV24Tyt2mf+/4ekJbZT1/XYLKZ8I11b8s+GXjKZ2Qj6axvTqiTdlbwFdg6PC9i20EpA7qUhvO2CSeYoP6KOWk7hLk4jNqYOyoxYugwr2sOTGyJEK0FuuRQXc+J+N+ZC+wd6piwK00QCrJl5SCzNIswCJH9gGV+Al3LJNcMSExqTyOkqdZz/XUHFyrgsijV9zlXVuvuk6kWzLnfZdFhHzubS6acy7LejlNtbqTOIQg2qZLIqnxdRrnkVeRUBO5qBpfccIGBnAPW0WJY1VI7fIrYYO/JzTkkPpmltr4VsB8jj9wFMl8LtFsnneX+1C3QDEtAOoGf0N/E8IheAKz9B3dlRZWSe+U7LVOC8MlMrNDUUClFbdMUiY0m5u+KNlEHY3LDKRTqn290vVEja6KmntFO4/vI5yygqfFD3gaaOV/Tmo
 46ZNokfq
 yLRYYhwP8Jyd7AjkP6BqF8mPKYEWpK1kRCxNfNmrZyFCkAkgoHtGa79VzynD87CrNpdwwbwHNCj++Pn3L0Nv3VDPwAyMUzENP3sBPXgK9HJ/8gkwYCqYJj2co8+fWcdnxIR+wUwn7FQjS741FuhBwmYUzFOl1AFofW5eJi2xopbckTpYGGtPDLzm0qYrBw1nx2CRmUJL0JtuH52EeVcM7ELUoQgEUTe8RB7q34AItcQpLTtM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 3:48=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> Can you please explain how freezing operation was delayed due to proactiv=
e
> reclaim?
>
Hi Shakeel,

When system suspend is initiated, the Power Management (PM) freezer
attempts to freeze all user-space processes by calling
freeze_processes(), signaling user space processes to enter the
refrigerator. When a user-space task writes to memory.reclaim to
trigger proactive reclaim, it executes in kernel context and enters
the reclaim loop. Currently the task does not check  signal_pending()
within the inner loops, it cannot abort the reclaim pass early. It
continues reclaiming memory, ignoring the freeze request. The PM
freezer waits for all tasks to freeze. If the proactive reclaim task
remains in the inner loops longer than the freeze timeout, the freezer
times out, and suspend fails.

