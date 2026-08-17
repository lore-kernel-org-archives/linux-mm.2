Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0ED7C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0B46B0922; Mon, 17 Aug 2026 03:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7A86B0925; Mon, 17 Aug 2026 03:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE7E6B0926; Mon, 17 Aug 2026 03:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 635746B0922
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:16:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F26831406C9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:16:23 +0000 (UTC)
X-FDA: 85109903046.29.51135D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 491C540005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:16:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dl9i9l+0;
	spf=pass (imf27.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786950981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3z4PfSM6JghqMlh7wiK/S7MvWZveC5X5xWc2flFhdY=;
	b=SQDeDC85amRi728Jjv7DgIalIVfORWY+qEHn+8zANaEd1xn/qCG0KNau45I0HTENaI8Fl1
	NuEgw/lSfCfRuknI5NMXHZ05iZMsIeptmqi7vtJ6L0iX+UYF02b/5Q/FcWouOPNjuCjbDA
	x8aAJt/p0hU/Goe/+UGFDnOhbmXF7pk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dl9i9l+0;
	spf=pass (imf27.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786950981;
	b=mSfYwsZQjOVGm18UZnndr7SJkbWwezaEBN1e2ti4UwimAUKepS7L95U4uky9pLoB/ySRTB
	qk5xOFUue2uNT9MsmaisoRs2Ysj4ZXRzf7CCRpNt6IbjRiWnBYt/F1nsVqsfG1OBxBXuY4
	LdZyw+Y/KIlfsG23T8Iq5rxDoUx96lk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786950980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v3z4PfSM6JghqMlh7wiK/S7MvWZveC5X5xWc2flFhdY=;
	b=Dl9i9l+0MwqbjKWGwYc7h5CMNxvc+GRt65gwQw4thdycUPd6PvqShpHxaKEZg16jvsWiVl
	NfwMnFEm69mVsWu5+ytpmtTtwut3Vnthpy2OaUZo4MTm9Ti3sU+E8oCGw16vHPGlS/LlKj
	evvFcaoNxzK/7nCcZjrshnmTGVwshkk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-2Pkk6KaEMT2xqTJrH969RA-1; Mon, 17 Aug 2026 03:15:58 -0400
X-MC-Unique: 2Pkk6KaEMT2xqTJrH969RA-1
X-Mimecast-MFC-AGG-ID: 2Pkk6KaEMT2xqTJrH969RA_1786950957
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49808ea1b64so32815895e9.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786950957; x=1787555757;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=v3z4PfSM6JghqMlh7wiK/S7MvWZveC5X5xWc2flFhdY=;
        b=mR6HVFC1IxcWj02cHj3OzlVk/qkw2zY+A/v3wO3kyPvvvTE+aAhVATwrUP11e7+m3P
         X0wHvad+qBsp5juRCBjOzIl5kLtDcZvVkEVcvSi7jMNIF77Z+mALvFPscg/WXzW+qvMe
         /A3efy3nJG63UQPnk8XdEGoS+IY9gQ3PhCt/ayFER7vqDLjKMqEV2t40XZPTNTNhbJwr
         EcLyI8iqrbeL/uEr2C28BOqSNWegjAvCnjSAZit/OVSvq0h+Kx1Da+SKkoem+jKuUxVg
         gzzucbOaQiXycpGxfUl4CJMoESxkBBuTkKb6NvLAcYHCvdkJzdgsysqWCrP056D4Indw
         NEhQ==
X-Forwarded-Encrypted: i=1; AHgh+RpcZoGoMQPEOhEaW54vSTY8XWjEKttCETKPvezQJGbyAd85yP9/KFxeAy0unTYKcSyiWAOG2cFwlw==@kvack.org
X-Gm-Message-State: AOJu0Yy9PeNzqSd8WPDpJqgscEYUMi5dj9KW7g4ydd0kqifdUjb/DNyE
	4Drb2Kd9fFXN8kxe6f4KlSn2Dk5PANPARe2W1BaTdGSDQ6kO98c/Cpn2vZYk3jJAY+LR2F5DAtV
	Hr/KwAZQtlWDKQh69hHMSgihqCJ6iplbKwX7htJlyvE7UWW6xYf8P
X-Gm-Gg: AR+sD12IehDmlbMHBgvdVt6mk0R1O6L3weiRhXxoNuGOHWMtb46BpvVW/1/WxNwEAKu
	RUPf+2tvKKJjJihuCIan/JObeJt+nIJYJ+YT9y+5sZz1ytq9EtTDStknX+aZfzxmUJEvmA5g59k
	GdKTeNWv985XRTa5IuJFJgER3a8LhaSqsEBCKHaEIyvAkWyAPTuM1dGa/4hcCIUuTfaUHyq88Ga
	IBN/ONficgeO/friE6tusEtJm6uSIlrq2qbHDgRVxMz8jCRtyFrbdMAaZ6wahbaPMnFnSmkKRNV
	KVRYMEgWeTksG9zS8pp0Lq7YCDdyJpaViu2uwwIWgsy4UoWdHRoVYPB6drmQiTnSuZADD1qM6r3
	jIMhQM8ygbfOmna+aOKC0ZH6dyJDzfMWlO9tOFMfoZv0z6OkxWkqNQ91p+nfRxQkmZd2OnQ==
X-Received: by 2002:a05:600c:3b90:b0:499:59fd:dbfc with SMTP id 5b1f17b1804b1-49987a4f131mr302421315e9.1.1786950957117;
        Mon, 17 Aug 2026 00:15:57 -0700 (PDT)
X-Received: by 2002:a05:600c:3b90:b0:499:59fd:dbfc with SMTP id 5b1f17b1804b1-49987a4f131mr302420595e9.1.1786950956598;
        Mon, 17 Aug 2026 00:15:56 -0700 (PDT)
Received: from gmonaco-thinkpadt14gen3.rmtit.csb (212-8-243-115.hosted-by-worldstream.net. [212.8.243.115])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999610ed6dsm158565235e9.8.2026.08.17.00.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 00:15:56 -0700 (PDT)
Message-ID: <8e9c771e8962eb9ebcc1f433571e9c45838a565f.camel@redhat.com>
Subject: Re: [PATCH] percpu: Drop CONFIG_DEBUG_FORCE_WEAK_PER_CPU
From: Gabriele Monaco <gmonaco@redhat.com>
To: Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>,  Suren Baghdasaryan	 <surenb@google.com>, Kent
 Overstreet <kent.overstreet@linux.dev>, Steven Rostedt
 <rostedt@goodmis.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Mon, 17 Aug 2026 09:15:54 +0200
In-Reply-To: <178656406317.2437052.7257990869957704195@slm.duckdns.org>
References: <178656406317.2437052.7257990869957704195@slm.duckdns.org>
Autocrypt: addr=gmonaco@redhat.com; prefer-encrypt=mutual;
 keydata=mDMEZuK5YxYJKwYBBAHaRw8BAQdAmJ3dM9Sz6/Hodu33Qrf8QH2bNeNbOikqYtxWFLVm0
 1a0JEdhYnJpZWxlIE1vbmFjbyA8Z21vbmFjb0BrZXJuZWwub3JnPoiZBBMWCgBBFiEEysoR+AuB3R
 Zwp6j270psSVh4TfIFAmjKX2MCGwMFCQWjmoAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 Q70psSVh4TfIQuAD+JulczTN6l7oJjyroySU55Fbjdvo52xiYYlMjPG7dCTsBAMFI7dSL5zg98I+8
 cXY1J7kyNsY6/dcipqBM4RMaxXsOtCRHYWJyaWVsZSBNb25hY28gPGdtb25hY29AcmVkaGF0LmNvb
 T6InAQTFgoARAIbAwUJBaOagAULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgBYhBMrKEfgLgd0WcK
 eo9u9KbElYeE3yBQJoymCyAhkBAAoJEO9KbElYeE3yjX4BAJ/ETNnlHn8OjZPT77xGmal9kbT1bC1
 7DfrYVISWV2Y1AP9HdAMhWNAvtCtN2S1beYjNybuK6IzWYcFfeOV+OBWRDQ==
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t0aoxfqwitrC-Iz4jtRzJaFEfP-p85I5KSn8LHTP3iY_1786950957
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 64k7noghyswr98ptxjye3zikeq5d15hm
X-Rspamd-Queue-Id: 491C540005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786950981-244687
X-HE-Meta: U2FsdGVkX1/eZRZTycbuPFK14aplRv1ji+57p+zi8juOLX0YnwW/qRiG//gzuZVNaKZmFbPJWvUdUSJzKnhDQbdI2hX+74YfgrPzxz/A0NVdJ52os6njOd6wIMzG3EBqvR5LvmwZyIbO061ojCaPqWsbac9hJJr3nQ0FU5KuajFXBM7AZigk0u+EMYhnEV3ORQVygwIjzKw1zYX3RU42mDBcquXVHddPZEhPNimYgLUzDeQGMuHNQOhzvRFg+Dcl7jWla4WfK3sQPJN2XBHwOAweldNSQS4l5JsSKxe2JgxQFeMoMmoWgfyEvjdt0iWqjrriT7GvHdG3HmTVZQ990rMbgkTfPtVyBWPv/aeKnjLz/3zXifxTm1bwihIPBHXmw8W/rrHZuLgrxTXSFvj/b5N6ur93H4+wNetChvIOQTPIXh++Gn80TBQEMI/5UWPrX6iiK70sDPHC1I0zg1NkaZDS9fB4s1yLMmVc71B4f4nmdvG9gJ8f9JXMWJKG9tfwfDDzGNxpRX8danmRAWPB3FFq0932jr3qEdTcQwIRQhp6KBa+SizCJ1od77d98JwXfQb3T98P+q2wVP++kzaCa1SyuLxiiGuQPqQ3cly+mcOpa9UoLJ2TU4Em1vkqKmPRG2T1KXVfY3RQEOiN5Ncr4SICoBTmsZOPEV0xYoTULg8DnkI8AbJNFisuEudk8i1IQM1gsgyhpz0VSfEaK7wQEnTyC9XNXBaCvs1Gjvn0OFAV2Pwuz/KtY6gQ3LflIizL3d3LyvEJbAO4V+Pv7QjO1ZkHixJl5uTu0c+CrbO5K52hcdcSf4R3eT5dP4NbnkRC30tj5mkD7kjW56VJp+pzRCuka5iaJt5fUaYAKzcktYOMuu8JyZSW5wLy/r4auxaLpGRRWY8aEpG5JBD+c8JrrJlC9enbytK/jMm6o1rJw1hTR1qFFZbAhEni/eWNBN1TfsA09zJDX2h07E0xZhv
 rWmkzGb7
 zeLI50JdjWgFu3RJw0uONBGHeIw8Cpmn438sC3cyvkdCHoqEdOqlrpZg4GC+B4qj/QhnB59SuyFHKuSeC/cOOvZeEQ1t8inS+0HOZyBmBEFq68oL88XXrlULpGXIHozY8p/KXNfqUkaDnJC5C9IO8M0uOTvxkpz8ywJkvel/N0100QWXOzxtptx8uyRPeBMVjbDrcW0o7d4tmk5DwWIFqke2J30BzrdZk3tr4CMAgsX9UCsZblr3IiCDxCF6hzVnXsJik1+T4h2YePviLu7MaBoblSsu6godE/OcBNtbbfx98vkzyowKLWvzAo45WK8xLehuPaYkQzy0NF9+gfGryUxLZTn4nO1lK44RxE06J5ODyym8G7TsVkq6huYYZPDB4Klay8u1uIT63aP46rJsI6iHA3ar7TTHpFBRYxXAv/xdTZYPekP2YgVxhCnSfoSVG6QNPijY/6gj/XsUpfXQmNx85UQz4YZIieZtp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-08-12 at 09:47 -1000, Tejun Heo wrote:
> alpha requires percpu variables in modules to be defined as weak so that =
the
> compiler generates GOT based external references for them. This puts two
> extra restrictions on percpu variable definitions. The symbol must be
> globally unique even when static and a static percpu variable can't be
> defined inside a function. DEBUG_FORCE_WEAK_PER_CPU exists to give generi=
c
> code build coverage for these restrictions without building for alpha.
>=20
> MEM_ALLOC_PROFILING defines a static percpu counter at each allocation ca=
ll
> site and thus can't be built with weak percpu definitions, so it depends =
on
> !DEBUG_FORCE_WEAK_PER_CPU. As allmodconfig enables DEBUG_FORCE_WEAK_PER_C=
PU,
> this knocks MEM_ALLOC_PROFILING out of allmodconfig build coverage.
>=20
> allmodconfig coverage for MEM_ALLOC_PROFILING is worth more than build
> coverage for restrictions which only matter to alpha module builds. Drop
> DEBUG_FORCE_WEAK_PER_CPU. Restriction violations will now show up only on
> alpha builds.
>=20
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>

> --- a/include/rv/da_monitor.h
> +++ b/include/rv/da_monitor.h
> @@ -24,7 +24,7 @@
> =C2=A0
> =C2=A0/*
> =C2=A0 * Per-cpu variables require a unique name although static in some
> - * configurations (e.g. CONFIG_DEBUG_FORCE_WEAK_PER_CPU or alpha modules=
).
> + * configurations (e.g. alpha modules).
> =C2=A0 */
> =C2=A0#define DA_MON_NAME CONCATENATE(da_mon_, MONITOR_NAME)

For the tiny change in the RV header:

Acked-by: Gabriele Monaco <gmonaco@redhat.com>


