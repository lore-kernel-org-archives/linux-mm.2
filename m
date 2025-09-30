Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1F7CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474868E001D; Tue, 30 Sep 2025 06:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B668E0002; Tue, 30 Sep 2025 06:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A308E001D; Tue, 30 Sep 2025 06:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9468E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:18:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BABA213B72E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:18:25 +0000 (UTC)
X-FDA: 83945516970.06.159E337
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 711A820014
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:18:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T+wqcIEd;
	spf=pass (imf03.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759227503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4JncsrSUksxopSuhv4R2nt13jY1i1IQ+gZtPzGKiNQ=;
	b=wbpkU4FbK976jwpNJAMMvEfcXJLogzKI+qfRdlIluWnkVJeiwwP5ykh3PA1UDNFozaBa9G
	Ce3wnFWztYzTTtCSvYu73ww80T7H/VgSPUiwRDQXBUbaAaUwVN6x8TRvURVjAmKeVPVNeB
	/zVqtod1ZaThDjghQtEVwG3sbWGB7fQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759227503; a=rsa-sha256;
	cv=none;
	b=ko+xqL9QWEOO4BswB+5KtcqmHUYrkWEqCMZ3llS8DSJy0WhOXu9sPi74+vk1yy11ZG9gF7
	mKROIJFfwy1hKn3/MhJoIxGu0vz3KQ2dJMEx5Q9A1uEVRkcAq4PIPV9Z+YItK0bOpvWZTK
	o/bRohk/u0rdG6sBtUNEiWowdUSIcf8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T+wqcIEd;
	spf=pass (imf03.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759227502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T4JncsrSUksxopSuhv4R2nt13jY1i1IQ+gZtPzGKiNQ=;
	b=T+wqcIEdrQDdAzUrD1MfREA/OB1WIQ8awRaJ+dcM99JnQFNPyPY4IS9f9mCFr3gVsV8oPI
	yGrgqt3BWqJe8fkGZ5xKRvNK1noeBJWGbRzLW/SFA6d2wE+0+t60NNchffZ/tN497EoODz
	hM36qxGkkPoxu5cEzyytrGWTHpgJV8w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-r_Sl1jbOO9ikvJAVVsGcAw-1; Tue, 30 Sep 2025 06:18:21 -0400
X-MC-Unique: r_Sl1jbOO9ikvJAVVsGcAw-1
X-Mimecast-MFC-AGG-ID: r_Sl1jbOO9ikvJAVVsGcAw_1759227500
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-41066f050a4so2860940f8f.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759227500; x=1759832300;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4JncsrSUksxopSuhv4R2nt13jY1i1IQ+gZtPzGKiNQ=;
        b=YYmvvnJ5k5WdSjffSAWL0Iu1UkzggCvhX/pMVC7F9TeCNkr06dhEPFZ7ajDtOnMz9P
         MX6J7TVbsoWVpbGNURR6KOtTdmRsz2oqXccrlk9idmMU5wJFXbvsj8CCHbo8Shb2iSxj
         scFQwCCknTXGOPuGeE3UjqVf6VuILfuYW48McxJ/t5QRKpDa6spxbZNFqBPT28PTGGNI
         raKbwe4pw22/sqyoQnJzF2KOmrdnroP52+8x26QT+nc+lyv0gg429pjsiYW7IudaJ30P
         avsLqghAUSAm6K31AbHLQxjIzIgTpbIdbTLp3fPScMF/+AA40uFkAoqAcJ3v25jK74sL
         QpSg==
X-Forwarded-Encrypted: i=1; AJvYcCUhvBm8ELhMQc8vyhCDNyYtQnBU/Yow/FN57HOqtpC5lF3+vB/ehTrxzbOQpJ64fU3NXh6MdpeP4g==@kvack.org
X-Gm-Message-State: AOJu0Yy3mek5lgrJ18ivMdISZTCrgj2+7/Jp1p+QVGz0sJU15jvw9cEb
	LNKbPhGaAk85YzlfysrBYaR8MSb/9J5z4u7MYUUrrlCw2iAoiK1aAsxvzafUtcEt+HQytzALTOS
	OtFb70BPrk5PfrlPDhrjKW2vJ+xDvPmXYLpxqxXsGriIcL7QxCUhA
X-Gm-Gg: ASbGncvdjn5thRnfRD+l/c2jcEIj0UTrizKOx+1vXaQu5EmwbYCgXcTKImyeTwGZ6hb
	Iq+8tgL2qGbmfB9sLcG4j+7yMaku3xh6sibqyMLplftlv3x6hEh0YVvkzGk3pW6Ygc0GaIlYkdC
	zKjGxVTtCpJVfToioq/kjHug2iAb6oTKoylRnfzh9XjlS5K5Jp6BovkLsy7TVXUQxVQYphhxI+0
	7ikES+A+Lvrx5lyn13UKHlGPh2bbSG7oRZ87HukaJ3vB7PvOWxdgGaN0F7yNuRqcsCweGbbaWcH
	+c6JfISZWItjCvpJ28cWRGibKy3EROhxIGgCAb8xonSW/p+pk48omR1fHfWfUPsf0iBMQfo=
X-Received: by 2002:adf:8b47:0:b0:424:21ff:5151 with SMTP id ffacd0b85a97d-42421ff535fmr1705062f8f.5.1759227500485;
        Tue, 30 Sep 2025 03:18:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3ZyM9t5bViNq/9tSXepHz486aMuBktyiQyddVglqgRvUr8MS3voy5nEWgaNyrtI+mrjb6Ig==
X-Received: by 2002:adf:8b47:0:b0:424:21ff:5151 with SMTP id ffacd0b85a97d-42421ff535fmr1705043f8f.5.1759227500105;
        Tue, 30 Sep 2025 03:18:20 -0700 (PDT)
Received: from gmonaco-thinkpadt14gen3.rmtit.csb ([185.107.56.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb9e1b665sm22006951f8f.27.2025.09.30.03.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 03:18:19 -0700 (PDT)
Message-ID: <2bf22dc5213ada5339d85744c348da9558f25e3d.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] rseq: Run the mm_cid_compaction from
 rseq_handle_notify_resume()
From: Gabriele Monaco <gmonaco@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Mathieu Desnoyers
	 <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
  David Hildenbrand	 <david@redhat.com>, linux-mm@kvack.org, "Paul E.
 McKenney" <paulmck@kernel.org>
Date: Tue, 30 Sep 2025 12:18:18 +0200
In-Reply-To: <87tt0k3oks.ffs@tglx>
References: <87tt0k3oks.ffs@tglx>
Autocrypt: addr=gmonaco@redhat.com; prefer-encrypt=mutual;
 keydata=mDMEZuK5YxYJKwYBBAHaRw8BAQdAmJ3dM9Sz6/Hodu33Qrf8QH2bNeNbOikqYtxWFLVm0
 1a0JEdhYnJpZWxlIE1vbmFjbyA8Z21vbmFjb0BrZXJuZWwub3JnPoiZBBMWCgBBFiEEysoR+AuB3R
 Zwp6j270psSVh4TfIFAmjKX2MCGwMFCQWjmoAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 Q70psSVh4TfIQuAD+JulczTN6l7oJjyroySU55Fbjdvo52xiYYlMjPG7dCTsBAMFI7dSL5zg98I+8
 cXY1J7kyNsY6/dcipqBM4RMaxXsOtCRHYWJyaWVsZSBNb25hY28gPGdtb25hY29AcmVkaGF0LmNvb
 T6InAQTFgoARAIbAwUJBaOagAULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgBYhBMrKEfgLgd0WcK
 eo9u9KbElYeE3yBQJoymCyAhkBAAoJEO9KbElYeE3yjX4BAJ/ETNnlHn8OjZPT77xGmal9kbT1bC1
 7DfrYVISWV2Y1AP9HdAMhWNAvtCtN2S1beYjNybuK6IzWYcFfeOV+OBWRDQ==
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gex1nAoLMt6_FntrW3RYJZC_49F-G8S9Z4m4F8eXurI_1759227500
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 83xxm9oqy8htkrpwama98hkqpoakjc16
X-Rspam-User: 
X-Rspamd-Queue-Id: 711A820014
X-Rspamd-Server: rspam10
X-HE-Tag: 1759227503-120079
X-HE-Meta: U2FsdGVkX18ozdtfRJMwDMtbhQFBMn8jiczQQUZw2WG/GU2sZrLmLtUAatZh2Gz45TLd5jB+0A8qOBeRwoB8IFT2PWtNvQg2y/s+nc8hmW2eDsyvFiGV9ctR7y0isxPT7PE0NLMVA6ZGdubizk+mr5Mg/jXEpzWrQyPLJxTUjRbfeklYBXr6BoQT/hVrt0qo/6zdwMMy9dWnmkxDmxfG8YBwZ5b43pl2gIG9X7CBUDFImP2AzRLWbwbvcCbju3DTv5yygDblzYMKF81TgFaa/MIrAwtw1uDk9nUrib326JJ75b79BNZjy5jumnQlSfVhJk+0Jd+BZXH9EfIf8Ts0UxwyBTB+35w2kDBJ2TeqI91qLYi3b9dOl4Um+AMa89mR9ZDHH9e2nMzIRmsGYFu7e5nARFy65eNvCLNE6zvRgUZTJQW5zaqnEZ4dgzfvvSDA6CU4bB0oXYqc+9XF1GXx8t0mRnZ/5VTTLjMEnK1+oVMk/nUcZNgyMP6bVSVK0DdbUY+55tNhM3mnM7l7yTdy6YLoqIR4BkUKUnGr8ZPZD4gD+biWky8DM8SYRdAEvq2+w5PXaC0qFFYyIOYL/UCtB+ZlGKTfTV9FileKF/DMNe2ClsCQwZ1W6+TT98/kHee7rNyWb/zJAwrQyeMnUCE5h8MKmxCJghsXqeuEtjKsEcJMwiSssrU/WwlYycUL9MDY1eu1NFoGKUgDa2ODuNgcW67ygzcR97WVHvVsOftGP4xFAeLe9nI/K7n3xRYYy81uUpBvST9aVk0oNno4t1+xeASrZ1UmymOYTxB+rKbIVU1DTCG95DxnPDkXiSh0etPDYg9BY3m2DzKtCmW5lbQcSiI+6N74WPJsLMW7bXt+I9gJICxM+9Ta71x3LEk+az5GPPJaVi3OMi5x4DwNayNRTTdQ0MzPuYH1AjsFn/2yOaYqd/+Xq7iU1E/JFsUunzctizcKrjmLiLsBJ8eS+ZU
 jzEcGE3t
 vyy3pxiriAPRT5TMZhG6793nG2OFTefOpANSHF+EzdGuw2WygL42qoVK4MDOSauV4bSnRs2K3slaxI5tvrHwYtJV1FLdYgEQu+6c1DfyOfDNV0qNRV3LILMcLtLQLTKFmJ77YvIql7FwcLZ2X2JOPUbv5NniuQnnWgbyfBqGqG4hDKB6I0LkkS9xFyx66lpxpjeCY/BrhD3hRSkJ0Ed5RmpMo7E8pMAtkMyQhGOE9/G9wk44ThC924pzDSNPpGQJ4Jn72eQ3zh3DWqIgtZbdfIXe2BLc8C0gVCkDg6H2wF+LFoRFQzWOHW+N0ZVSGqBYVvhxUgnk1YTobxyGNcJJe+vvqi/38IwUlTvWSsU6ssNrqTSBPrtWVXZlbAfhSxteyCGGLiZwkjdbcO9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-09-30 at 00:01 +0200, Thomas Gleixner wrote:
>=20
> The current overhead of RSEQ is way too high. People have reported 3%
> regressions just because glibc uses RSEQ now. So that needs to be
> addressed. Moving the RSEQ fastpath to the last point before going back
> to user space is the correct thing to do.
>=20
> mm cid compaction is a related but orthogonal problem. I just skimmed
> your patches and I'm really not convinced that this is the right
> approach to solve the problem.
>=20
> The main issue with task_mm_cid_work() is that it iterates over all
> possible CPUs twice. Your batching just makes the impact smaller, but it
> does not really try to change the overall approach to this.

Thanks for the thorough explanation and sketch implementation.=C2=A0As I'm =
not really
confident with rseq I didn't dare changing the compaction logic too much, b=
ut
clearly your approach of getting compact cid by construction seems the way =
to
go.

I confirm your patch passes the selftest in 4/4 of this series and, obvious=
ly,
removes the latency I was observing.

Thanks,
Gabriele


