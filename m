Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEC5CAC5A7
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3A48E0008; Wed, 24 Sep 2025 05:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B7C8E0001; Wed, 24 Sep 2025 05:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8E18E0008; Wed, 24 Sep 2025 05:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 752278E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:13:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 377D413BA9A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:13:41 +0000 (UTC)
X-FDA: 83923581042.22.A816673
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3FE1940005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:13:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b7Y+89GE;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758705219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Af4Ct/KfBWF7p2rMZKnvJgS35hmQrVUjUNoUpz5WfU8=;
	b=xfLGqkW7rH4YMB6YzCIN4z90RC+bPr0tyZ3jEpWHgSKeltPDqtThVO2xisAx77ciWRBxX5
	u9cVoiwpJXk0Y6Ugi4oFfNMEJ4/uwVAUpwc3d+CLr41UVIoZm/QUFwItMwWzVbZiEjI3AX
	+yIfn2AAgjPU+nuNgGNJYEfU2GL3hCY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b7Y+89GE;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758705219; a=rsa-sha256;
	cv=none;
	b=qQnCZk58jn0g3Z7/zS9422zuyhcUxbz7jwor4edAWDSTqHW5dywlYAK4gnmmJ2vNK3Jjtw
	5ICGCp41V2hFFzJYQXwkbGPMdD2Kol+LQ7Rggwolw07GITpWVHLA2RpO/7tFWFeWLCAcjq
	en9eiw/dvOJYahZBkEb/U3kfxdd6Gjs=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-58120c35d47so269474e87.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758705217; x=1759310017; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Af4Ct/KfBWF7p2rMZKnvJgS35hmQrVUjUNoUpz5WfU8=;
        b=b7Y+89GE2MVRk+xFrpDE8zjOFTkvo4Nh35nJrM40m3Q6JGycPXHYEEWHCl302F5+Mk
         H18uURG05mczejW2tiR6vReGmeiKe47zq/APaKFwo/PhEx8cem7Mn5k1Z7RhrtRvv57l
         yKjNvQp1OXhgT61FDaLYHINv8P8akpOAuIqQhmAQnnejDOdQvrFedh9srZNJcJjzSkAW
         dxOj3UgzkqRhJn9YLpkhbcjP7WZSr4X8Nq9ErNfxNIyme8qgLq80Pu8dB84lZbG6giED
         QohlKeBJ0MEwPGlah7iG4Ld9+m5eSgK9dfWdjrqPhym3W21YIs/GYN1bvup5pTBHvyvt
         qxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758705217; x=1759310017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Af4Ct/KfBWF7p2rMZKnvJgS35hmQrVUjUNoUpz5WfU8=;
        b=qcFMa+ykn8JIkaTSH9QtthbmWUhUG6EE9IEPbD+J8tE+QVhEHbRMHXgT4olPIAANiJ
         IBAAXld6saJoNE3AYC2AGY9ovrjSR9mm3XWc955p9u8BHE59oYLGtsRuWG7EWI0mwkaw
         fK5xPuaGw+jgFfjbungzZ2q6qLM1WV69p/W0ReITGNkL9b4agM30J11E3ZjK+rza1ifK
         EzTiJFA9Na/UuYUd/dAsOKFfFctaTsQSi0Bx5plTnjE43olNw7NE1sNVkWbCIXQ+KowS
         1DJq6dH1ArOHaisACaxTM+gkcsY2SvA8DMdxXOkeJ7aDKwfEL/Ct0VN/Bk/Qtjo3e2LF
         5lhg==
X-Forwarded-Encrypted: i=1; AJvYcCVNQU3PHZeNVLFwiOT14ZR+sE5nNR56bDZPMqyrXfPTb9detND8+7fWhIXfYdfxc9U/VEd5tXWBbg==@kvack.org
X-Gm-Message-State: AOJu0Yz6EPO+cgZaWRqZ6eNzDMyJ/Bybq3ZaWjfNe6LeovE+IzAhMo01
	ZnOhgzrkkMGtev6qelfuyIBOms47AlBGgtvcLPs/H0XnZYx6DQrh+yMylB2ZkuLGuh8n99aNIGr
	71E3Csr/9fQf/aEB+eSKYjXqVu1TG0ys=
X-Gm-Gg: ASbGncsOmzhBEgTdvOUJyg9vUg2a1vB3TbHQeV8z1Eoi0hzx+jhEHfwWPZhFfNrEmek
	LyipJm3kTrKg/ygxJbyBJAiy+s7SXoNTQKqclbsNoG7yFeQdbbxFGS8Lz4/bNUyzNqASSZBvVOy
	AGT1OLslRQRQzz1Uzh26WCEk1yjKndozld0OoWapWHKkzpMG6FnYKXxrAlUuAPxy7bmYaRiqF6q
	7J0DPTs
X-Google-Smtp-Source: AGHT+IGs8N2Za5uD7V8CJlL7/UBfxVMm9tPDgKV7PBembRGnfUF9U37ImFXt0pqlo73lGmzPgv3o+6kGEtm+zgslSZg=
X-Received: by 2002:a05:651c:2205:b0:361:774b:8b2e with SMTP id
 38308e7fff4ca-36d121ba628mr9245421fa.0.1758705217099; Wed, 24 Sep 2025
 02:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
 <aNGQ66CD9F82BFP-@infradead.org> <CAGWkznGf1eN-iszG21jGNq13C9yz8S0PW03hLc40Gjhn6LRp0Q@mail.gmail.com>
 <31091c95-1d0c-4e5a-a53b-929529bf0996@acm.org>
In-Reply-To: <31091c95-1d0c-4e5a-a53b-929529bf0996@acm.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Wed, 24 Sep 2025 17:13:24 +0800
X-Gm-Features: AS18NWDh4YoKVvwiPJPTuArIa4_L6TIXxcKByByVO2my4d-ujrstbeY6JtaK-p0
Message-ID: <CAGWkznGv3jwTLW2nkBds9NrUeNQ1GHK=2kijDotH=DN762PyEQ@mail.gmail.com>
Subject: Re: [RFC PATCH] driver: loop: introduce synchronized read for loop driver
To: Bart Van Assche <bvanassche@acm.org>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>
Cc: Christoph Hellwig <hch@infradead.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com, Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FE1940005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: npw4f4sxxhzuh9cafs4ogxq3xw9r74nb
X-HE-Tag: 1758705219-818424
X-HE-Meta: U2FsdGVkX1/Di23u20PS8x0r+CinNg/qu9aiO8t4Yyq/8oB4HaOwh8eX7pSkHBhCjFEko6XEMEIZw8j4j8iyKQvjY1gMbQcFE/W0XmBlGSZG2ouzmHV2usV3CpPBqrAq4EInwEkEGvW7iH3tDJWvD/1kCnrdAsfUO3FSP3A0ynV0Up31M+NTliHXWMLF5VSdPraW4qJoz+ysg7JHMeE0V8CREXYlZGnJrSNJQNE4Jz3T5WAU5AE8MGlOQDLIKASDSI5B1MKoTpNEQwv6Hk2Cn0CWPJjELTn3uENchn1mq4MJx6XaO+6jryjadFM9csFDQ5gvMwTN9sVKAHU2bLyvfFa2RWEU91nStZkJ2MyJwW4UUiWDDCZpvfGSjuyaiMORQoGQDEQFtcIBo6af7fEdQx0AiLAniG3BZr8K430r5HUzPZRwMccGIILwgPyz0DCGRn9O0x0oXZAR+ZN2BEi5ZmF82a/S1VyJejksS9VIqsn+qPzPKTTUXu0Aj9WrodjmrICLjtkALn5bLgFIUvDyDYQIqK7F8jy5+QTUUoUFYjyASy7JlqV6BfWN0+INR5+OKU24AIvyHNR5VAmFvJjqhNjThQSbJmKsarpa9W53wM3PBUYT6Vchm95bidMLviNrjkA4ThZIS0XbzJMF92AvCr2HLDsfpxJGUdLVlEcU5LijtTKDj6TZOYC9YvKb3420Yxoe0AXiyEf1Lz4eqe33auOi9TxxSQKzW2PTNeORivH7daTzbTWNN89p8MTRehbHHgcI894za6iLYDFfHf6dQPBU+3PPLA193+dbm8w4vnliYK0qsqjV3eA//NqMk3rNTQm9K1z1P2UvmLVd9gFCuru8pOuce4zs9MEcN41HNfOiYOiwIapNaII+nawQSCA9nCOQTtcMQmNikLGi7bulh8eQ6H0ANgyw7YUi9xuqRFL5++GWRCeJp92pgZIKcNiveE3UNDyB3GXV5Ox7WAC
 vzwqiCyL
 aoa/6VLS1NmLaKUKjpp1yd4Wad1sgF56/yYl3VNCFcOT8QgCUyGDCcmpScmu4zuCs5rFX6l8ZO1rmtO0UoEK26VaA7Dyn0XrFhzg8Mdne3s+9pIKbjXYGAERa1k9baBo99ecAHUIjhn+JLNPq6aBZExvcGPX02h+xLtW6gtD19fFUURv2FXdU9U1yVGenyUC1/KJiNOuNz/7ADfN5lFYQprv11sMJzX41xnrT5mKEzsAUxJoHMmvZld4ruXptn+sDOhBi60idsHgNOJdlE/BQ/ypz/OGr976kUOQ3WmCDJFnoZdoWYQhj2lLplpirI0ztTdT4kAYNXr+jFFxRnvpUHQy+nSBC4upKQRnujyWyqqU5iK/sYzIRyqt7EK8hdeeG4Mo5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

loop google kernel team. When active_depth of the cgroupv2 is set to
3, the loop device's request I2C will be affected by schedule latency
which is introduced by huge numbers of kworker thread corresponding to
blkcg for each. What's your opinion on this RFC patch?

On Wed, Sep 24, 2025 at 12:30=E2=80=AFAM Bart Van Assche <bvanassche@acm.or=
g> wrote:
>
> On 9/22/25 8:50 PM, Zhaoyang Huang wrote:
> > Yes, we have tried to solve this case from the above perspective. As
> > to the scheduler, packing small tasks to one core(Big core in ARM)
> > instead of spreading them is desired for power-saving reasons. To the
> > number of kworker threads, it is upon current design which will create
> > new work for each blkcg. According to ANDROID's current approach, each
> > PID takes one cgroup and correspondingly a kworker thread which
> > actually induces this scenario.
>
> More cgroups means more overhead from cgroup-internal tasks, e.g.
> accumulating statistics. How about requesting to the Android core team
> to review the approach of associating one cgroup with each PID? I'm
> wondering whether the approach of one cgroup per aggregate profile
> (SCHED_SP_BACKGROUND, SCHED_SP_FOREGROUND, ...) would work.
>
> Thanks,
>
> Bart.

