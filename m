Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2061DC88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E836B0088; Wed, 16 Sep 2026 15:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56796B008C; Wed, 16 Sep 2026 15:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17356B0092; Wed, 16 Sep 2026 15:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 941896B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:14:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D1F816071A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:14:57 +0000 (UTC)
X-FDA: 85220577834.09.1D16D7F
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2EA97140007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:14:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h196dRMo;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789586095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLpUo77KwulcnAoN8HxD+dNrDd0JmlxE9cVchuUaZ5k=;
	b=7nfRbg+q2xtv+WoXGsH8xXDwFUkN85lYbuwJhnbnp5s9vsyj8AgGjKlZFpXIgx3w3E8BqX
	44dVL9Xc3lICRYMCYzbPnjviCUnJ8XDbdj9r4sRK2fsTLdsjZUFSqBWHu/Fa6hb3u6rFMW
	H/4TCtNYXFVgf6Bsd0HvtfMrPNZsgzQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h196dRMo;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789586095;
	b=hMrjEgNmzYibL5bqqG7XijxT0ReTWrhdVSozyQJYm4/XrQc3DgbyhJgA713/X2FvYdZkZM
	bQaYqDFlVkcYfGb7BI3BgSN5Gpxx066CWCrN9OfQfoIekfnc4y2GZZiI7H0ho9dIjBeQf5
	6jUXs0uVIwO6/7HrloJJFVDRWkb/lJc=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so8771cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789586094; cv=none;
        d=google.com; s=arc-20260327;
        b=g5Xl+OEtlU/F4V3xID+Ep6Y/5Rf9oXH6GjYDHagH2oCmNAzoFdzNX5HLev8B67D3BL
         5s8nGRcQO6YamoCDK6GOYh4jxk7EYtOWC+Sled5HPCoizY6b9K3v2MQ13dXY8Ur+Q0/F
         9fxQgjDCm5VQFPRTr7pHnRqqMg7uIdfzBdfxUHGAH5uNRgCj2gimSb34d+5VMA3F2p2A
         O4yDksova7jFra8m36Mf9DZxUDDmEdI7exFFe1tdptjKwB73oi4kUwv/9VlT0s+rC1EF
         FSdi5RC34It8M4OwsU1seHw5AvecRFM7IIIO7MS+Hml9aHDDBdgj4rWtQc1gQAOTI79S
         wmTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VLpUo77KwulcnAoN8HxD+dNrDd0JmlxE9cVchuUaZ5k=;
        fh=q+IHJZv0zPqn9gLVxh3Nlljpu6rLlcqRarJI1foiMUo=;
        b=phHrk49Ownvg7RmnVE1ywgFeAYatD0gtPScqij9h1ysOqpKcXCXItkIKE1pvgjp7jB
         lIZ0wjz8Mo55BoLuwhMaEv8lEaymJttiUA8snL3XpdVfqaZAKxWBIeGHDVIXCH8hymmC
         mX7GZQhzGIS4PBtIg/JRjboYBHmQWh8vK6ZMpR/JvpSqioW2IQu8pIFPowu4W+0lBBvb
         Z8sSCA4yU3mdC2ux/t9Wue9U9tsPuXsHI5B3Vy2Gie2f3K4DP50MahKRo8cd7Uu7C+uJ
         yMgrX8poLYnIp1oNuJ7nZACWYE8jb1rBt7jC0h2LKi6Ek1G6FHIc1XVxeStqBThhEik9
         uKow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789586094; x=1790190894; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VLpUo77KwulcnAoN8HxD+dNrDd0JmlxE9cVchuUaZ5k=;
        b=h196dRMorbI7WRT4fIJDMCfVFGa39THacyrcvcAB2Ehovg6rKhuZgJsYqKPgQDFRzo
         JfJlljlt/WU5CcoxBJwLiCiAUR2/Y/IwC8PdoJ1d1txrHiK1OSviE0yaD8U03vFqHdRd
         1pS3tNRk+1sGJldWzSn6/O3q/R76ejQQhEaTQL5Z5WdCOo8h3PI2kDvG7RWXSPIgj3eI
         k8LTgl8uWQ/8P8rx0rz3vfwScPVIS6FhtNWMT0xPHHlkMddyfIinp03a5gx5vJrZPLJA
         vRE5m92PE3aTsxMYDtMCcPL6ZYFp48uLq7u68DH+mo3F+SvQszunim3BUh6BMWprkMB7
         oTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789586094; x=1790190894;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VLpUo77KwulcnAoN8HxD+dNrDd0JmlxE9cVchuUaZ5k=;
        b=nJZRm2blWHfEWDrbzqGSlUtpuLJFlfW5eOr/JJPgBLpBtoPZlil4Od5MrE+om9wGd4
         tpvSe1iF6g3OMsj5m7in1exKGHNhU6A6Dg7TAM1DbtOZkTYluonrZIG6RifoIQUgHQST
         AuEy0Dwn06CjsqzX9GnnZMqREA3rQ9FE8ktcVfMdZKc8OII4T2IhMtf6pemue0TO+mdi
         nIzmgiULP7tp4/vVsJ3P7JXJqv1pGVPJHen5FtE7slZQwUlWNAoXmCc4qZ51wWDCpo78
         5HTm27JtaBiUtS7l3xdzPXTQ7m2kcLFJebG0te1USVWbh9JVuNQP4eKi7Z7is8MVJ49Z
         nE9g==
X-Forwarded-Encrypted: i=1; AKwUvBxHAO4FCXU6c18mBEWq59FfIlZMFYcOPdlskEZBBXG5PCmOOOQMLfP+R5OlPo3PqJFR8rPNsAdN+A==@kvack.org
X-Gm-Message-State: AFuF++k2Vu3onyeI9YV8HTVU8GWSDwqtYuJ/R5btgqMJrk/LV72rknpY
	RCmrRp328AfWn73czuvC3dLKPibxwpzuMtfCFz0uCh1rYd6yJyhp/B6Nd2aocNC6I0UlVN7qIag
	PdnESHtj7j2yI61h+J5gu3Ev8Spaw/PpX1ViEfzlw1xOJky/oPNQ7NmgQixA=
X-Gm-Gg: AYBFou3vNAUpwzEomVWiesWLoEvi+LtCjslvjXnUTlTF4/pIIvT/1tK2HlAo8/rkNkE
	7nBOOxFMioDaIKaan+H/2y//lZe2rreeDrcGJJjt9f1NqLcWy2Zbx8ktqXSpZ+Ts06I6zjt8ETK
	IIT/9+4rnCguIh11AFaY7jmmGxMFyIsPdA5YuNw0y9EMP6yly3ef7xlhdkr1oKt4O56uDVUzX7L
	6ou0lhS6wGVDtEGOlNp8QBk8dio3N8v6xU4VAWd6sKl1JOP7NBV1+EFq3waDW5lupZNNi15dBna
	o6mxbJ39nVvRLoe0S2F5aZ6O85DOn+iIo7OhxmQ2CxRb5cmA2IwzGdKCqqT402L+YUajZ0QfNoM
	GW8zKGq68QtnKNhskHkO8
X-Received: by 2002:a05:622a:22a8:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-5328dc6246cmr2795101cf.12.1789586093491; Wed, 16 Sep 2026
 12:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260916065830.1619425-1-arnd@kernel.org>
In-Reply-To: <20260916065830.1619425-1-arnd@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 16 Sep 2026 12:14:41 -0700
X-Gm-Features: AcwNN1UjGdAjkF61zjU98Q6IjH7rvmM2aSLXdz3MUZJlHR2CYIuteVnbwcOHyfA
Message-ID: <CAJuCfpH0wrvnZin9RN18y=AfRFXQQmCKqDiPkhe--iFr+D2FdQ@mail.gmail.com>
Subject: Re: [PATCH] [v2] alloc_tag: avoid implicit padding in uapi
To: Arnd Bergmann <arnd@kernel.org>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>, Arnd Bergmann <arnd@arndb.de>, SJ Park <sj@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2EA97140007
X-Stat-Signature: o5ibdktpykg7s95wqdbywwjokaf16mzm
X-Rspam-User: 
X-HE-Tag: 1789586095-270310
X-HE-Meta: U2FsdGVkX1/kj29weRNjG/w+92TG7IECJ/DJmyfbGIz2N3L0scUFXz1K1PeW9jwF9nv+6o4uB0ll5susimAEvWGGI8SoP3xMz0tixmy3azFCs2gvFsFfEhpqQkUEp2Fq4PGHu13oOCrCn/g98A/XQ58SWUK2erejXJXozgADk0/8N5ora/2rnfCXiTSJrjfuy1tnBEmZ6+inaVl2Z8LUYUq+FpMyEz/a0g2nvpDn6JLTCQ0429ifmvFNPPpdjU6X+UsTm2y984SRGIH6NVTP3I0RcOAWV2Lbhe9VP2FO0EmilkTbq7jgYEd75sG71dp+7vr+f79qWSYnoqnF247wGyOoMu8LgHK02pdAs6MWjm9is0YXzlSeVsBQSLEKsL1iBwl8ELRBbzLBHyk18pE/jHBrUQdhevF0Wje6p3NBJREDCg+yKbv4s255ZMMu+2G9ITfQA/8tJUuyLMj9LbXQ1ZE4wwvb5nn4BVaSk66EJw33LZK15DwG1bvwZv4yTdYWolu4zxySwLYhZG06S7B63jhIEstt8vHWuLDJqxxgiRQVPHVDVRyoyrtBkj+jyup9qRWnYmlD4Pd+sVEDS0ZT8XYZGJOtQaNd6elsI1rCUEuJyq5Cu7+0NKXPmZqfj8Z4mRNVX19X1/ia3Xg4ZMkX3XASPbRDdJ0BHq5khTppzRCGubLFb7h39/PnhR9AsRFOTkVe4/GAkqs/xrRUbM4soBUGARWtgVq6cuf/F2Q1OkHGIIjlm9Ti1gONxGEoYBDZ5JOe5UCc3+TAcrdSHlgGgGsjgrjEtX6xC9LEnJ9qoeAsOR3itXoMw6ntAfU9ktmAXaALiy/yffinThMby6eIqB4YfTLBcbpPSGdMkKzg4VzfL1p26TxiE5XHPKzgZcNNqsN+iybM4AccPgvQyaEB7pvHEuwltueHZA7Yr8uaPPVggY7YhzXNX9hO1jDG1Mkcw4Pms0VhDLbvHViqeBf
 kzBiZF9Q
 2k8XJ61m7sphzth8k/yX0wgxZoF+MWQHuKtgldvW8vUPFYYT8OutBAcOsMu0wNWZN6kX1faX//3h5Q1cssqvQGf45BhVEufRZXQZEg8qlO9EvYUrW4JRjG/gUDKI+TrqA7zrsm7HMqhn326xvRhkGffwNkdi2FmyGWzd2JCA8xUcZQkEcIHHx89de09BQEOk5cd6Vdm7xkY+COxc+dni2+HtR82+gRKLgVt2WRP0Z50GpzZ4+Bi4zOpwV9sxKP6K0fNHnLbVIk0cWOIF/qRdw40oOG9nOJ5vcRYpYFDDVgjdCQZa1/X9yEHrIgKpygvdEb9BviUc4cgrbJAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 11:58=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wr=
ote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The implied padding causes a harmless warning when testing the uapi
> headers with -Wpadded that could in theory indicate incompatibilities
> or data leaks:
>
> ./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to align=
ment boundary with 7 bytes [-Werror=3Dpadded]
>
> The code here is fine, but it's better to make the padding explicit
> and avoid the warning here.
>
> Acked-by: SJ Park <sj@kernel.org>
> Acked-by: Hao Ge <hao.ge@linux.dev>
> Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
> v2; fix changelog typos
> ---
>  include/uapi/linux/alloc_tag.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index e3ad94444864..7d4618bea043 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,6 +38,7 @@ struct allocinfo_counter {
>         __u64 bytes;
>         __u64 calls;
>         __u8 accurate;
> +       __u8 pad[7];
>  } __attribute__((aligned(8)));
>
>  struct allocinfo_tag_data {
> --
> 2.53.0
>

