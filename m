Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD4CC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD466B0099; Tue, 14 Jul 2026 14:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3945A6B009B; Tue, 14 Jul 2026 14:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284926B009D; Tue, 14 Jul 2026 14:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF1F96B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EB0B1C048E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:05:29 +0000 (UTC)
X-FDA: 84988159578.29.CF6CE57
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id A82671C000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:05:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A8iFdVFQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of linkl@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=linkl@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784052327;
	b=kdevZHyNmOvkwJpN1zZiw1eI/vHlBo18Hn0Vn7j7azDrsN4z+0dL/Gt+kwi8SB80tp6fPA
	1NJd2FsxyQQgTUC6iFbirTtLzl+UAzEinue13egknDA7HHWhDJgn/uO+nh0F3IYj7LnaVe
	bD0bvPbEbutvgS//bgQiuJvYCV31eNE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A8iFdVFQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of linkl@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=linkl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqRkl63C710v7jj++AXCujyuoY1ta/1fvK0KnGvJPsM=;
	b=z6QBgRABik7JIEMMv+1WUnRhQzjXh0EEbWsbkduzF6u198Ft6hVlVSc87EgG6IVXEdyMni
	Wj9j3k4fjcFfN7Lguhgq7TMJ7slYqxTN5GxRYgd85QavSgcvJplAVYTL5lA2g8TkjbbuF2
	GXWxHrcWMR1Em5CvPctcgCw8bEhNHnM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ccdf36f63dso177495ad.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:05:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784052326; cv=none;
        d=google.com; s=arc-20260327;
        b=EHToMTjkFEEgDXhoPoO1wSIv3ssZsqy6eHpAPkUstHQPS/XrODlKay7joNYG3+gTZv
         Zhv0KGNrcI60KNcc2lH3ZNl8yi0Y8eYl0jyoGrwWaiVhbrARIpmMkGENaJJoWEgws1T0
         sB6DAM9rBd8tRy6BHt/7QErEXNiOi1/jtCXGmKx6KQpZoJIsHa6BHZgY4LLRySDu3h8z
         2bw6FgbL2DM/F/6/TXNDrHL8Gl/hlRY6eb+nXG6eRQ6lbAxgyoTwqV0v+4XAcvMiaxl7
         JJfpm5THSnEbJD4aYKKeOhztNp0B0KwUcNP48OVRJjtXnvHEnVUsk4sOijRP//dRSiMh
         RBtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uqRkl63C710v7jj++AXCujyuoY1ta/1fvK0KnGvJPsM=;
        fh=qSk45aSg3YmGk16uw2AfZAL+ZWJoFwhoR3IsG0+6oeI=;
        b=iN8CceU5SJV3DqVJHS8UdTcXFn0kwa8+L76QmW9MfRbiU4fuOZhQ+s6bcyQvLB8FFY
         cAeyewrNYo8BkUsTULFxK+5hFmFolNHCLOAk+pzdESwL5NZx9FFi3303V/Cy4HpayerM
         0Hm7arVJXwtC4t61+pAkw0XZ0/jWzai81fj5u4ZT8m1JV2QGZUjxgP6Wmd03W8i6uYcQ
         i1MKyg+xO5Ox2zqM23g+y9cpsTzo7dcp9O0c5cn43JNDjnf/Qg15wbI4Gx4RVZsPo2xl
         VV7/Dsyd75rQhrJMYvIM48zrvYFyUIcSWSKIwzXjv14beK9h7HQdf0r70G0Rv2UO3PRY
         oicg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784052326; x=1784657126; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uqRkl63C710v7jj++AXCujyuoY1ta/1fvK0KnGvJPsM=;
        b=A8iFdVFQBTQtFs/AVxyAWTXyhQnqfvSI08loc7o4+iiqz9eiAb0k5ir3KCTYxRLYMu
         N/Rms3qqRPqwBoGf+ptagYwsfbUqnxvaRrdqQK3Cww49jGxDRvE1CeK0whRYFbcPqgis
         p8qajb/wUS/jjJg6dA6jIzTMDLSUYPk/CGUXmlPqHK8GbVyDRCcm7qkjwYkAr6AoK31i
         5xAog2UILqxU5/PnZEJi4hiT+KPMAUH45RkSVhCZhDx7pjRwWyWHnvdVMsqa6rWil9hE
         l6HQSPF0QjS/SrSs2cJCvLG4Yxa1Cjie4cOKh9shBRldPC1UsN5CHEgvJI9gALtJoEHS
         iObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784052326; x=1784657126;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uqRkl63C710v7jj++AXCujyuoY1ta/1fvK0KnGvJPsM=;
        b=ZT5sEA26fQyVxkRxsT3TzDt+4xWIMyAYI4quPyLD5W/+390p91ugxEB3IrM49cwkMB
         TXt4DCi4ay6WVMQ8KuQKn1Vqo5g/JPcLgNocZbM4cesZoaFsrpABC+PzfWEiBmHyJDRZ
         Dcv2J90YD0GVUQT5Nqek2XWFcMaf8nHtL4Dvn5oGrS5rOxZe/D9CuaczySG7KzewlV0L
         ffaxSTMjIidru6+OxgN3d7GVCVuHH9pfQAV7x6Smqj3y7KD0MO+9H1jcI93Yg7lWhKgV
         viJClJc/mLplDhN/U8C3OjTW0PSgK/kqPjeX+BEzxomsF107qLKwm8RKfu1vD2D1x9Bv
         Piqg==
X-Forwarded-Encrypted: i=1; AHgh+RpHwJPeOeS9F3YjYjU7SzEeGtMBsQNTMuGd17NXQrgNkYmDARWBz5uu/Ibp91nyJ4c8JUDdQYISSQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3v9drb/D6HxebS+JYop7LrIPrGP9xS1gpKfGZGTvDfLOwgScD
	dOmsi13WLSQ3uXNHXeLR23wgcvRlZ+Z0LpFh9uS4on1xTgX2ImI+UXxA1r1vLS077wp71aXYLSm
	e7PjcnmgAfpPwCTu4/EWyczlaaIktFJdlZs9vKA9U
X-Gm-Gg: AfdE7ckAul3gORvZcQOBoO5GDNEi0Qsi7DA3FxRqrhnGzVJs+BOjtKCh3MqZFDxBn0c
	glR1bXZv+B/eas0hOv3syEPKy1Upj2JRcxetvjRThLVsEdUVzFYef6GuK5rpvx9aSSwavkCN2X1
	RAw7UjLmEh2ThJ1gF4np7ppkXz3J6YmHn01o0Xff8YgJYijH6eYYJxYOETT1IK0g7rqwzkckNaH
	2JoSpftIneErDyQPvmudf/vW8oXwMUuiCG6B99xl3iHYIqCanLbNjr7gs7kuo+YZwnwY2kXrUfM
	lo4/4QnAzxpZ9JsrYRV1P8bsAw==
X-Received: by 2002:a17:902:c40a:b0:2c9:b404:b55 with SMTP id
 d9443c01a7336-2cee166107dmr5050295ad.6.1784052325956; Tue, 14 Jul 2026
 11:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260709224330.946683-1-linkl@google.com> <8d316b6c-41fb-4ae3-8923-3b649b92b33d@kernel.org>
 <20260714092146-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260714092146-mutt-send-email-mst@kernel.org>
From: Link Lin <linkl@google.com>
Date: Tue, 14 Jul 2026 11:05:13 -0700
X-Gm-Features: AUfX_mx5k9DBPXvby8jHd85RScNqoUx2Mk5ySUSPxdCd7MSrVwbUj5pXe7nTaQQ
Message-ID: <CALUx4KSxjpHhgkHZ5p1khLSe7+-cDHd+ZtBEJS1HytWSo5WbHQ@mail.gmail.com>
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting during
 PM freeze
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A82671C000E
X-Rspam-User: 
X-Stat-Signature: xb9t9nfqq6quxn3xo7r4t1h35g9bba85
X-Rspamd-Server: rspam03
X-HE-Tag: 1784052327-367513
X-HE-Meta: U2FsdGVkX1/ZmlLatGq0kKNAkkzyQ4DAJOzwlUGIL7KBPJ2p0sk2KfsVRxqFHsjyWpJNmsTrOh6phCY4w1d/bQVKDE/8rTrxG5KD+90VF7e8a8W4dkMZmD0/+Q3voTBiB4O15zx5kVF3hBIPdg0MUfcaqTYL+ZLyBGZ6w3KrAnCT3er4hG9HAIrnVymIetCTHWjFno41SvYD+wio0uknBAmzDUXRYc+f/zk7jRvgofbmOBNVzIAcp1ZYgvw72XvsIKjmm0U3/Sc1eKiXLfNoIpu2yL9UOh0D+SviJY8qMRMuOWxFJsMIN8o+bRPqo/PeN/xNVHp9NGpAYnyP5G9KHqla9Rhf1zK3K4mgPr0Hq6wxIFSfbtlXQwKdFu4t+c3lc0IqhSd5C72DTR7oNW8bomnA07MDYNiUH8S0vv9JYWbra/Msxs+Y8IlFqaLjhs4+Soo36g7YavPgxDeZXictnPvsxYo35DRlZw/OEJqQ2IsX9xdCCW8GQMvhUyVrX3j+0zT7lzjv43S542M+I0K5ywrSAM0vIlSuXZs9voZJRncoPygkOqw6rKt1MQQWNGjImZtKIfh34e7gOx52Aa+eK1bfCJnTdJVpFhRcpzBg1w8evofaJtWohqD8tHJJt+jpSqNcv89nvujjWXhl+R8HxMst+2oMmK/PYKghJ+4l4puNOLEA7J5fv8USPypTy0ey+IlDruBbpbbt64RWfHolEMV86P8zkgbzfRAs7F+SRkIPjl+ePswf+qTURlezxGQAlHIrd4tEdhB05BpxV+u/10cXR+QgP8fRXPzoUZjtdqxPMR0hllC6U6OHfJuJcoB/X4BviTY8eqQi4NEU4L0H2VMbsl3QTmjiu9thCekdUNZ1uT0aY3ixfQAgbkZgblB5UMGHLc8Qkb/5IBZ9fUOR/z+vRhvoW0Sm/TNV3LJoq/67np5+CrT4c3O/gPqmluKqbMBHWJr/7rt1CK8fMLy
 fYOqsDf9
 9KNo36qUEVuNq02LUH8IkKZMTOWnmF8ra82cn0hkB7ln1wRyV9xeTXnqWKe61oIGLsG0JxLQsX6LY74oK3lICxJGN3awyuvoARiZ+lxaU1x3L6kLdn1m3jH3RaSrObK44fgSnV1mQc17sQ7eX9nVA2mlWhM9tFKfP9g9wR5Zcm/JDIEjTqrGpst44XDPZiiMXR4kmuuxezupGMIkleW5ZYy9Ci5sLxxqxr5o9na21dSNEGi+bdA4jBFywl73qCBW3BrTqlT6NLVNF2KuN53D5W0B+kldmREpmmPkmt+L/u+hpafJE8mWpQ1whDP0Q3nTVOgWqFXmd9FWtf9DcAakKud6qH/eN7/FXcgLSABY1kqmLKFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 6:17 AM David Hildenbrand wrote:
> I assume that workqueue is not frozen yet because ... it's not freezable :)
> So could we queue to system_freezable_wq instead, or define our own freezable
> workqueue there? Then a driver doesn't have to worry about that.

Exactly. As noted in the RFC, the root cause is indeed that system_wq
lacks the WQ_FREEZABLE flag, leaving it active during suspend.

Switching the worker over to system_freezable_wq is a brilliant idea.
It's a much cleaner abstraction that solves the problem at the core,
saving individual drivers from having to micromanage this lifecycle
and handle failure unwinding during freeze/restore.

On Mon, Jul 13, 2026 at 6:26 AM Michael S. Tsirkin wrote:
> +1.  Just system_freezable_wq will do the trick.

Thanks, David and Michael. I will drop the virtio-balloon specific
unregister logic and adopt this approach.

Per the earlier feedback to keep these fixes independent, I'll format
v2 as a 3-part patch series:
  [PATCH v2 1/3] mm/page_reporting: use system_freezable_wq
  [PATCH v2 2/3] virtio_balloon: fix shrinker UAF during PM freeze
  [PATCH v2 3/3] virtio_balloon: fix OOM notifier UAF during PM freeze

I'll send that out shortly.

Thanks,
Link

