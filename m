Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C47FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2376B008C; Tue, 31 Mar 2026 05:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92C86B0098; Tue, 31 Mar 2026 05:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9336B009E; Tue, 31 Mar 2026 05:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86F496B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:39:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 289F8E14BF
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:39:12 +0000 (UTC)
X-FDA: 84605859744.18.730225F
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21AA4160006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:39:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UdIWB881;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbHlAEStjw6Wu8mMsfT+Jv4/X4ttfYMb0i0VeuUMhas=;
	b=wmGzHF2jdp81E7o+S0kkE+/Me6lMqtyw4J1F5X5RV6HvTUl89MPTL04aOyjk4zjWCx4x/4
	HIiQTuqXCkOFksLR8KIAxQoS9Do8IpfWIOtuFF/Flso2XaVnQZ1QD5FwCxuin/JnxVR8et
	PM5E4ph7G8qL2C10ELo2RUhU7mZWLZ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UdIWB881;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949950; a=rsa-sha256;
	cv=none;
	b=3YkjlfONk0cKlGmlkjia/8FUU3NF6NjYbXle+i1WpejAXcmh/AbsByI+WNOJjtJtn/1XEH
	HDfdEUpMXvqgj7bgfLVtpcHtNUMw1VMW28uNcpeiZoIidHI6NGpagMzMeuyGFjtvugHTd9
	BnW/y8pF/EYX2b401tv5jXOnJCb/5SQ=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38c620f1699so51243221fa.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774949948; x=1775554748; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bbHlAEStjw6Wu8mMsfT+Jv4/X4ttfYMb0i0VeuUMhas=;
        b=UdIWB881F4gfV6e1mSYX9OgN9kh2yZZdgNAVw9MJrMQO/6WrBdLDbFHZufCSzNbn3Z
         xuvmJHojp32X064mAuORAvEEyuy4yiTyHeYPdjBwaMS+Nhc9+fRUiWeYB5Mw39Peevmx
         QpjE87hyRk3dhYOlTKq8WAjWD3MCgL2h5bHm1e1d5ZkfTo3nMsahM0ZY+pMSk4YFgkp0
         ybOXPXNcAmsXm5CFHZvBB/v3KpC1A7FQHRn0BTqDn7aeWIw7u9m0pC+T5HH06IwCfxIS
         oyB79KTjY5Cn7H4AbhmDuLC+xhuKNvHWzRd8gkXiW9G7QQYvjT1ICtHmAghN74a6B+1G
         N8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774949948; x=1775554748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bbHlAEStjw6Wu8mMsfT+Jv4/X4ttfYMb0i0VeuUMhas=;
        b=lmxQ6yIm7wqXQMo7IwOrnhip5dK6kkT4/vb3+PiAR4fdDcX1QwztCka7qp2XwcbmQk
         CnsbXGlOp3H/csBDjfAAtnXvvsEj26ERSi4UK9CYDQRGYSAGXamb8QmP/XJEL1h6m9Mj
         aDt4nVQoYZod0dkNkm1T5iBNUJtXlOcMSmHpjvQxsjKLSBskF90abFyXe3mHWxP1Cw4q
         elKfl7c7PmajwSuP6NF6MQW1w14x/3T6FQ88HzvPP1U8MZo7cFfqqtftutAAEyVhWiwU
         tOMMgbfp2PgQMmQRHpX6nqkbcwAh+xMdG4taetguS6zyjn6cUnM9pnkKGm9mFIalm1Dr
         M/3A==
X-Forwarded-Encrypted: i=1; AJvYcCXlW4leLJrLbNfQgRCbHntQN7qqmyeQhV6Ny5HjpV5360qo1VH+WlxVHF7VkldSwX1dmDFc6LJrDg==@kvack.org
X-Gm-Message-State: AOJu0YxUKmH8/x2i000zg3mdJ8PdDsCIlmIBbplExl3jpMvreYin2mgf
	MXo3CcF/FKG9CDE6bLXvXTOmqz3gtF6wwSVEsRqGNQEzNb1U8L+N+QLY
X-Gm-Gg: ATEYQzz7MhattcMVYxy1fH2tC26rXiujPjsbrS0liAJuUELwLRVtsTxnpLVz0+H6S/K
	vUEQg+iuiE5vnMGAEIxloLff6FKUVlCZekqx2paG5iTscakcchVowW+vXQUDiMugg9WDFKncKeP
	ZdETzHUXorpRtI8qfWyb1rOP0MZY243P104tO+hStyWUtyA2HfXe56Zz9JuF4Ma63j+Blj9mM0p
	Lo34rej06VukW5sS3Xr4kuDykH+0SNz0TctxzTeAUxWcIqMtn0L9AfJQL2N2hOZedva3VmfaweU
	DVXshgBR/UUX7w4ZmmKwGETb+mUj/RWSv9hfRncXrpi84fUd6V5RdkmiR6Rv0wttd2Nh00VOfl2
	cyvzRRpmcxFueNhELzZdoRxnL+PSL7wEJerIfYl0xqkboBnJnYZCcbg03uW1r0D49
X-Received: by 2002:a05:651c:1182:b0:383:282b:7ac5 with SMTP id 38308e7fff4ca-38c7400532fmr38265251fa.25.1774949948068;
        Tue, 31 Mar 2026 02:39:08 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c835b0946sm20380921fa.0.2026.03.31.02.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:39:07 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 11:39:06 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap
 purge/drain
Message-ID: <acuWOtKmPTzrYEEG@milan>
References: <20260330175824.2777270-1-urezki@gmail.com>
 <20260330121625.c69f46a63c86c9540b823398@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330121625.c69f46a63c86c9540b823398@linux-foundation.org>
X-Rspamd-Queue-Id: 21AA4160006
X-Stat-Signature: icdu4ce7fdxahpk4hxc9azu7xbcjrimp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774949949-889
X-HE-Meta: U2FsdGVkX19ZZLMKWw5eb4bfs4CG2/37Y2rl5uvmkNFNz3zl1Z/JKFsvXVYz5CIe/8Dxt+OruoWmOKQhocc46KhPEzxRTlfK/nD4EXVEqjAQaNiKjL/ItJixtZn+VxVZBh2X4DmlY0Kv8uRQC9E5p6miLE4r+sBvV9SMAcF/OtJCrlN4LArxob4cSiZ9LpUFJz+RRqBcWXMwUdOaSsR8fgPWBq8SlkRCjsblZKiIRPv1pHnQCnMmtrDUY+Syt+B4H649e9wNZgbd5wYvagQImJzwemyLKf9yVmxWnGpiH1Liq7QuPoa4Q//6sPUMK428rjX5X8yajWV8HXUVwZ4aZPjp/gFv7uTKum7a0Z2poQ0pqBuaU6kvPOsnGDokj0i+h4OHT8E0xY1qDjTsGP3gASM97LKn4HyKuK75yTdYHuogG6C1by/5l067N0XiSaaTu9yV7fHJKyFiw4BZRyM/8/6spstZL5Cl+Qdop8aVUM9/dXNXPPzCdd4o6XM4VTRj0Ar/O7oXpwTTR1gXT70qr5qQY4b8prArK0hUXkFG8XXtPwMQT9kxQzWgk/Ma4Yhe642DpRIPJttTETWDlAhdeXS6WalF3llYS9uhqfOv7OHGY50D3OofiN/NizNQtsqfhwXDZ8xMH35pwTbMoYb6FgNpUzzoIJbwULAaaUWjwkQX77uWb9jIHNBW2kQ+XI/hUMgLhIxE+GKCbPsWBztqrHvX5HlQMz4J4VyVoG6VhSQQLxydg9T1ah6r63cmzMbWjf1XI3zFd/VKfHJDPnt4fuiMunfh6Wb/tQ1DWKcEECNsAIMIfUndDhYYpibP33FUb54x7KT0w+eRl91CkhHyL85f27S6E+9YDRgVnIAlTBfv60XQDB1jrdvFIfX80m1TIWMQyEghBshCXLaM3bXxuXZipyXRzagkKne3eLktKrIQrmQ17E3C5w2R1tiPj+RowEEfbMeXAxng7RQuvxP
 Xh4kfAzT
 8AQxXf3uAyJ8vrfs6bL24dSABpUzxcQoF1qTeTsj+bdusmRoA3rrAnFcV2Wc/+TyefBnM2aSHKNPt0U8fenoJZ7sf3scnd5tb4IOmBwZFvkzQPbuQGvkBB2aGGrgQs42Ag75/vuW8X2//x6x1N8n12pghA2VcvYSt0SPbKn6voL0QxjPlGpiJdvsDy1Ua5ktmpf2c1uQyT7y7hf1Iip35LcZosmapYtWzn3ijr6vjaOxfwZij7qn/rOlSKMsPI9AfALSVcbYenHmdMB0Zi9BjQknRFpPWHB8qG7RxJFStOkZdEWeKv/Ai1TWbwRI2AXC2dhW+SFi7RR7yH3aO93BbzFQLn5mCnyDhlNwagmYjUJbCTRs/BqNR4vHEOTiFK9IrUr3smqiQhoxltrSQgpRwKQWi084sOvNRN4K7IueNgXQI68da6cT2z/GiLe3yDkAyWMlUNn6cf1XTleh3PVmSEOkF0Uev4o8+iToUp3XtXzB5pSK3PI7oNa6VLdO8sue/g8J8VyNvANmnrqIq2H8P1/plwmLPRhKeJNsCUW5okRc0u6A6s3Z+t0IdxkRoCWHBoh7N7C/Pw3QeLd1+0OPzpqJMQRc/4iEJwqPnH+3p6NJsKWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:16:25PM -0700, Andrew Morton wrote:
> On Mon, 30 Mar 2026 19:58:24 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > The drain_vmap_area_work() function can take >10ms to complete
> > when there are many accumulated vmap areas in a system with a
> > high CPU count, causing workqueue watchdog warnings when run
> > via schedule_work():
> > 
> > [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > 
> > Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> > run this background task on any available CPU, improving responsiveness.
> > Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> > 
> > If queuing work to the dedicated workqueue is not possible(during
> > early boot), fall back to processing locally to avoid losing progress.
> > 
> > Also simplify purge helper scheduling by removing cpumask-based
> > iteration in favour to iterating directly over vmap nodes with
> > pending work.
> 
> Thanks.  AI review flagged a couple of possible issues.  Do they look
> real to you?
> 	https://sashiko.dev/#/patchset/20260330175824.2777270-1-urezki@gmail.com
>
I think the problem about itself locking if running by rescue thread is
a valid concern. I will address this. I think the easiest is to use two
UNBOUND queues one for master/main thread and second for helpers which
reclaim if there are too many objects so the help is needed.

I will work on v3.

Thank you for review!

--
Uladzislau Rezki

