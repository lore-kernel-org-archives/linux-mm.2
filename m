Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89766CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760F56B0098; Mon, 12 Oct 2026 10:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739626B0099; Mon, 12 Oct 2026 10:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EB26B009B; Mon, 12 Oct 2026 10:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 486886B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:09:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4F68160EE5
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:09:39 +0000 (UTC)
X-FDA: 85314157278.17.93238B5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id EE15A2000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:09:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D9fb4B3w;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of tjmercier@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
	b=gM02jmBS3k2COlNCKPpmpL8fa9AWraOwlcLg9NJCBe3CrwxQUnmPY63xUjfDILgefbd/Sr
	4OhTX1prWWTHXO2ksbiKa9xcodzKz67qu2YwYnInZWKz3z4/Doy0nvnF9tCC1rmzjf9Deh
	ZfSaH/TaZLglbSwKxTpexnPiy6Wp+kM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D9fb4B3w;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of tjmercier@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791814178;
	b=gdJN5A7rDXz0P5EM9/81/mCV3lSW2o20VNxEyruqw5OhOnZScVOKRseOBZcFHEBRBVUO6y
	rEpBA6TNWY2h2b3whZud9rlfKumYIX7rcWVjmEsBbZCxH5Nl9+gylxH+wTu5rVjyAhhE5b
	dNIDUnB7LfEbTWOVpOMNq5zO1uxlKvY=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5337c7b9937so385581cf.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:09:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814177; cv=none;
        d=google.com; s=arc-20260327;
        b=jsHC3Rb82nijsAzTNYw72cxt66+zXdO5UVFo70NjLFoyCdGvwNGZayLkxc0OH/O+93
         IK916HnorhwuXF89Ld0/uBc/TIMIEM+pdXu9i7Kv0x9ClufS0J2hQuVOLLxC5Vfw4t02
         a8f1OaGNUggbZFnHhXu2NGSgg8cVjKLrOChHh3HGjdC79DDYg24XQuhkiCsyquGTZIYC
         qQY46DCS0/JxcZp51mfzkks2mpZMlFU3QE/ZffIu53Uhud8AnsB3gIeINAlc7CZD7kjq
         STHEYt+MTyC4d+0LieYPWu44i84EsKp6ioRv84wjwS+v4d/9wsg6L9ZB/QkRZgRPSrNH
         DrDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
        fh=5Q6veCILYbxEoTvQotjHDZZk6Wq86SWNA3z7gBfKMYQ=;
        b=dC6Kge63W+qcIawSt06BBKC929Uii9O/UNtSej68y35TtSA7Evod0KieBBJPlJBorF
         bss7G+pE9dg5ojhLuJcDL990sASVV8NKK+5McLAwUbek3C+b9pbeo7PzWlzGo+GpTv9k
         0IeGcW7WXwPm1bKyk9A8c4xqgTlDfHwa5wah3B11nGdGZq6N4aqbkApVTNRJv8T5teMo
         b2liEq+MbgzP0UPgOUPluEZC+0CDtQ2FcGVWRd1uyviVF92E0nVkQWbab/nDkk6o5vid
         GwpODEpAX/1g7q4SGfnVhuM0fjuXgKFYYDcmhg8xc0TLl8wPOue50M71UsQs5JFXWFTY
         Ew7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791814177; x=1792418977; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
        b=D9fb4B3wZlIG5QSfJilvrEiRmIhqSZi/ux/5sfNaKfH1RhdBE0k8QH2PP5f43RPwWU
         F5CQ7Iefk5kBjHuDsoMky/34YyJ/uQ+Dy5XYSRB75S/4Bl58dqtIxTuNQatcW2cheuX8
         eX7AOyyVIHEUgMGO8nZVSoPNTEdfs26htIeD5iLd9N2r1CHl4srhWbTqdo0L/xb4oceL
         TLMkaKji0F5b3fHo2/0GY19fj1LZzfkVWyLc6jszkMs+FqkReZo1xgiWoMQGhhEH/YG9
         ZSC9cxn5ToutSKIGAZkqNW2XQLsPbalPzGKjfMJHyOypPmmlpNC2J1S/fBW470qcGixI
         FZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814177; x=1792418977;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=234EAT9IzNiTaPSt/Xe9A57JM4OoTLyfezE2eXJPMhQ=;
        b=F9vvIOujM6C8hwGvZ42LD5zrJ8xix194akdzGe7IFrxV0UXBC0WiAAf7y1Psce1E+h
         833H4zLKDRFGbhcP2HqodcQk3x/UB2ETcJPFPZHkd7BAY2D5Ay5kZDChWkCL0ek+mwY/
         4Iu3fH4b2OCkGMpcTBYNivkYFCNhJIl6jNOM37cjhpIoNpSyGx6UgS/f0cYArNUyA+6R
         dTcAl/RWjzRoYsn+fzQ3o6w4aoy1oWg/Q8Dw9pQ8mvJb+h3FOHgGls+ktg+dU5TeWXRA
         fjEE2p6bueKeskU6NyYqpJgYIg/ROiRtzkk7ZMBoqyBQdxw5gB6xx1S9FGog31LnQlf+
         u8qA==
X-Forwarded-Encrypted: i=1; AKwUvBwCYSFuh6adQFedoi6Nv7LhCtwcpd/LZoS2IyK0tuJSKJf3FyZFD2ghycL3zKpm45mQkhXYzPl0OA==@kvack.org
X-Gm-Message-State: AFq9FYKkBGyNblFxdLQ04tI6UauIZAA0A0Afup3+8uqGJrEL82eRWREK
	RxX56ZZGGEGpdp/HbUkXjdu9BbnbKJ0AZ64YGCRTAkLiUdsvtMGKpuQtddVJiFkxIfVGfmq6d+z
	O2Zce2etXCB7Q/T8qMxgCxBz9ZaLC3Y9NLQCzK956
X-Gm-Gg: AYBFou1YNnkQwbwg1ubHQmoORRjqgbaRYuhP34ZZuwRY0rWhGF3zFsEdVis1Q8wK8T5
	eWdA78Q4ALOdTHcNGs8HkDIx6sxGcHCnJKaOfqIbtCoA4dkEZCnpaGjW4VGZcfptXQLlqnwW4jO
	Zu7VrdjR/WX9BwZcTlMW1RWDvdixRWxH+tCE6inUWeMfPuGcpCGpbfXExOGpf/TjkyXvbHV1h4C
	QciMG1F46s37jxjJRHPS3V5G5OyzexqGxGJ+9d5+glq+0B7tzH8HovOpM+k8G99X2UH38u7RbO+
	LVv/1cAe3hoSkPSkwj3Tk18KGd4VQkhheZDClSGSIoQCU08wq9DNEjfH/rzAQ3gb/MCTQ0IZGW6
	9KXKNNNONito=
X-Received: by 2002:a05:622a:580c:b0:531:282:6560 with SMTP id
 d75a77b69052e-535b4fbbfa8mr31251691cf.15.1791814176455; Mon, 12 Oct 2026
 07:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20261011223358.2327625-9-sashal@kernel.org>
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 12 Oct 2026 07:09:21 -0700
X-Gm-Features: AclHuK_P4xsv10L2lCkSOtMkvWLnLa5t9EHv_n5RaY8Tn_1YY4noJVhURld5zAc
Message-ID: <CABdmKX3+V+kqgC8H3MHHsawkTYFb7ebJe8pO7uRS6-i4rijwNA@mail.gmail.com>
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE15A2000A
X-Rspam-User: 
X-Stat-Signature: f855x4q71ooemppswzgwytszmjxhdgse
X-HE-Tag: 1791814177-637993
X-HE-Meta: U2FsdGVkX18J4QmeL1rWvj/7GzeadePWmId/R1qr0aX6Cijy74BVwQ7vve1CXalSqPr5qzKBTjpO8IIbQXvJwmUnbQrpKIBs/fd51dAGcLEwG43l460T8HVUkcKIXUMyVF/p67tuQyqtlXLXSjGMii9U1TFX8geVfINhn8CEOPTpkxH1K7gTcxHcEwSIyBzuhdvIlhgBmQtN6gHn2ORcb+RvU7Mr5WLu6dVLXFrrj6zt6lDhgO7McbqBBUZpQr4Ky1XAo+oV9bzsWARNgP7BN2L6A+e8iJ98Q2CUXi+By+uvMjv1u8afN4IqoHTRyID5viVVgZ+zXMxH/EocsmzMvy5hFniiSq6VH0eIlq1Pgb2MmSY+jJobpkdmLxvDCENRO896KfEevlQBQAZTJe0hJB/0Z6IJjGotx4nCGKf/x5hzuUTYQbGRo7yde7HZFIpNMe+SQK9b0qu8GJwOabX3XYNsNYoOqj0whg7EtlOcr/gQAh9XE6YvhxBeqZYhNxxBqscE7PK0h01++SpiGejauxTtcCO9WcK5JC0AtCXQ+TK3GiaebwuxOGWVUWdHMr/9mCbAKp8QkgQs35oryPftHgV9jGCGAXx9uY92YRRTeq5f2Opx11/TeHuhiiGx9UVRolSXdkj+7Mw1Zkzd2ZoX8Xx35UZ8ptX3TeZiO/Oz+l2BaXGbuNAb6PWv5597N/pYA8lDXunVZlMqJ6KaM9S74XaMUbg+tWuGR1299hrwXI9HPUzDtD1ipmUvOREn6/Eeb/dTD/kbS2vNiBjqW11afkH/FJKnlXr/TtEikw8q8Pya6sQROiRw5YRepX2s57HXaIw3oK1t9yhPxcBK6E1/VA6S9lNkzNjZlBvHYl/9aUAVYtuYR4uTy9WfM6tgzzgjZhBg8XklLXcWkzj5d+4kVsWIWoqPerxB1jbUastJ0i2bzV+5nVW0QMU1nBWPFF5KMRl+7k7Y6OokUYEAq4E
 h+Xi6ryo
 zPsp9JtTN+0mL1ymBG0WQ5YZ4b+0FuKw/Ix6om1Tcowfwp4YzpuRN+QtuSvIQA94GEBPShepbP7tEqJrRw8v6A+G5P0uf/ImLClBPVqGunmLiuKbW/nWQY8QNousyXKiZ0WU4GChV6LdsLWN+52KMWagP7vRyRIz/wZCvGDuCLHy6J472h25ARluR2vQvi4pwtqh3pWoOOt2fi8PvBp09O0jUcWwftMIGaKYmhPpMdF541FytC1hpnV8WjcO/82xwXozfcC0T8022gMk0ferseEwEXv0H9+Ushj0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 11, 2026 at 3:34=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> jump to cleanup before the inotify fd is created when cg_name() or
> cg_create() fails, and cleanup then closes whatever fd holds:
>
>   test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized =
whenever 'if' condition is true [-Wsometimes-uninitialized]
>
> Initialize fd to -1.
>
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

