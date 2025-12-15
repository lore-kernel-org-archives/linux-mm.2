Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DF3D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1BB66B0006; Mon, 15 Dec 2025 05:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFC06B0007; Mon, 15 Dec 2025 05:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BBE76B0008; Mon, 15 Dec 2025 05:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 896726B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:51:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9FFB160111
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:51:48 +0000 (UTC)
X-FDA: 84221389896.03.BCE2BE5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id AAC81140005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:51:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N8GktVvJ;
	dkim=pass header.d=redhat.com header.s=google header.b=c43ZmmiG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765795906; a=rsa-sha256;
	cv=none;
	b=5x0qrCAv3SOUTlU1cbQKAH/lmTeVy5bbwXEI7XCix1dBaxg1QgI40yArAzs4V4D7m9KaKl
	D5Vv2Vc6jxqLV6H4pAotUPjThhe7v9aXtoDHtq1/LUFTlbRtamIC/m5HMY3vG2Hj+S65KA
	fSmsBq05f7Uxhg1WHk1s3jXPib4jmJY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N8GktVvJ;
	dkim=pass header.d=redhat.com header.s=google header.b=c43ZmmiG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765795906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkCUCfLiLGct9+NKSop/UGDcclTFONtKAWihXF5F0gs=;
	b=VspDO0oqKbMKzbQXLOSy6Tnac9zB8AFwRtko5pKkGl3E6nbrF5AahVCBe64iUoS8+eQj5L
	oihM29ghPBryOsY3yruGk75V0ZXyAPL2+IU6pHnYs43UbJiTUjyj0TA9y7Ryt3EOhEWawm
	RF+IL/ImKiQUgVT5yMM97d+hl0fNFvs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765795906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WkCUCfLiLGct9+NKSop/UGDcclTFONtKAWihXF5F0gs=;
	b=N8GktVvJD0dyutpOHypH/NS0GP+u2GTnGqpRva7vThRdkMczNk6PbAXQ9z5S+ghrgG1Eb+
	Yl5d21i3Q9sZPPmGtZj9ClrYLUw1Jm7BI7y2us+lV19G5YKVm9O8asGxOsngUkNCMZ5riC
	w6V34aVCIUIlA2jqMwbKeIOQbGH+wU4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-bA2eyJncPzSJkC_eWyWCCg-1; Mon, 15 Dec 2025 05:51:43 -0500
X-MC-Unique: bA2eyJncPzSJkC_eWyWCCg-1
X-Mimecast-MFC-AGG-ID: bA2eyJncPzSJkC_eWyWCCg_1765795902
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so17042065e9.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765795902; x=1766400702; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WkCUCfLiLGct9+NKSop/UGDcclTFONtKAWihXF5F0gs=;
        b=c43ZmmiGtYcoNxwOW9jHgVgBe8tcfzlNYUwDZmV1w7Mnlsun6MW0DA6KlGiodKUEn4
         Ayiw4tecpHbMiYIWuQ1y7j1WAbaagtYOXqsnD/cf3AfXeFpAieFx3uFc3DzvTpWla+EN
         bWC8gRQHA4jPdL6qt2RFmgrGEI/B8FqzcfkhbislMyKLlPxcRRRMSRB6YP/lOEk6hXa1
         nbsgERNt9lB4tEKh65C/+bFNPYYZ6GjoYzS0lGqts3vdtOPjt2sD3RIynH1zH7/6JUb9
         YRrErgNN4b4LHvCI56oiscdMjgWcs/c78Y++LK2yDTk8peIxUHDJvaimjfGH3WaREOEo
         19YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765795902; x=1766400702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkCUCfLiLGct9+NKSop/UGDcclTFONtKAWihXF5F0gs=;
        b=fT/Zuc3C2LlG7b9WD0yBLkV0Wj6j9woGLrxf92lWGLMgIgcEFuKrxuL7f3nBRCXDA/
         IBNiuQl9s7YyVEoGZjHZo9a4PeU+J1eg8XMFgf0pCqj05DaxshEi0j4jb7HnyuPHzsba
         QFBsiNErwEUjQEoVfCnimPipjUsUNOmWpVuV2X92SZFk/5d84Y1eTzjAfQYUs6K2pH7d
         U5WPHtw0UMXqvty3ssCV+/FdHwozW4BFAoPHBmByEkhfcNNCK3l99GQBKsjh0TKA9Dcm
         LeWC+APvHRGGGezIW9rJFjQlaY/kwOAv/di1ZthKFvXkYL5lZ/abEYFcHCvSvpPlsa1q
         xe3g==
X-Forwarded-Encrypted: i=1; AJvYcCXcvf1Kz4Ni2sKUz9J1YHmssecTkufEJYxbuqcpUqFnLKNDEkT1O9tEQt+OjJ5T+upGILGshTyYiA==@kvack.org
X-Gm-Message-State: AOJu0Yzq7AjLWZ+X5jfafw8rR2lqX/N7cVSQGvgcciVqKLbX0l+57mj+
	+n2I3joyxzbWvF8ZbTbFFJbff7gCffS2O96MwNJ7s/6w2ZxK/A6/Np76jR9YSZfg4de0Ju6i7G/
	1Smct9Qpz5xaHYgd9W8mwKVS+WCu37bhzKSn7WdiwDgkrH3i3YVIi
X-Gm-Gg: AY/fxX5blZ2N9hnhhiB6IqkI3chhHATTVIukYi2g5/HuP0BnJqIXpyAnUM719+DdD1A
	DkSFboxR1Qg77hYV57UPmyO7TfZpyJxHTg1lqaByEO6KpdTWFoa+DH7uC59YT1wM5vrLIYs9vEj
	rcQktECBhhHSkSXdq9FdbS+Cvat72dvyoe11oKpLdwYhKdirc9ov57lrfcIG+28d6FmskQc+Jah
	CrOWYbe+AIERbvWa/q4cxu7hptlM3xzhnf8Tq+FQ2itep5J0HKVcoOip2dj3WKwCuesKTtAe+bg
	yUKGrNgF0xCGNZ6DnjKaocCmBVVrPV6YP9grCmwWtF1uQsiOftE8kiGJeF61F5SneL2FVZ8Z8b8
	ylSlP
X-Received: by 2002:a05:600c:3151:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-47a8f8c0a52mr119367035e9.10.1765795901750;
        Mon, 15 Dec 2025 02:51:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsLOxvt6hxpjORw35OnVP+adHLtMmhH7jm5yhL+wJY2rwByI4ScjvlRVSyfAXmLS6E1u9MfQ==
X-Received: by 2002:a05:600c:3151:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-47a8f8c0a52mr119366655e9.10.1765795901232;
        Mon, 15 Dec 2025 02:51:41 -0800 (PST)
Received: from localhost ([82.66.159.240])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f6f3e78sm69652615e9.3.2025.12.15.02.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 02:51:40 -0800 (PST)
Date: Mon, 15 Dec 2025 11:51:38 +0100
From: Maxime Ripard <mripard@redhat.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Eric Chanudet <echanude@redhat.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Christian Koenig <christian.koenig@amd.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
Message-ID: <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
References: <20251211193106.755485-2-echanude@redhat.com>
 <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="u7gkqqtkk3esv3ha"
Content-Disposition: inline
In-Reply-To: <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AAC81140005
X-Rspamd-Server: rspam10
X-Stat-Signature: 834peu3rfewkzg1jyic7izrtr86h94dw
X-HE-Tag: 1765795906-365553
X-HE-Meta: U2FsdGVkX18VyxCOPvx58x0MPf5jWVY3oXrp7T5pmY+WXKOk8aHXHCGRJiMfmf6MXFEzmN8zagZNsvArhcsMqGqi23zV78wCApRSQhm5F0UlUskQLfW8FcckaiisVJGB9Wmgm9CZKoHrkgzU1joHGTK3Hw0BJSF/hccWaXfmcQrYYEzFdhB359E6O+5IVVZ0rGsJJZ/SwTjRUV1SpSGzzVBcgkwfuN5YUEddTP7b9gkbPSDcW5vxww9byT0aRpMinWNjSyemoKxpyqk5/GlJ6658Zsdcov8YdvOSKASKAjvY7728Q4BHf1pIWU/r69jifgw6zRF455fpyTt+VqL4NAbF855rTOzBe8YtO8P6Se7xhJLETt0q4uyjrD2ohv51zgjWIO+6DPB9NFAfpr4FAaq6NOXnFfkQFmqylyKFr1nHm89NXz+PGSIw2RSGPu9iMl+ZynxI6L5Sv4HF9ft/gfqwDkooAmpeEAm+CFaftHhCCPZlyMiscNYY2CsBfmuq071enZcEMOrHeecXnwC4DxoVFpeZFgUYrwQ7d31AGh+5EQxBSYteUguVYW7KeNxBltSJZyCz86eePqtHyAueaaRJ358777Xt3aPtqZgE711j61yZhpNutAzGg7yIz208gOR1bEeJgfXslrf7Gv4lwFidKabj76tQmkTRb/JBYoXcQkplQaXy0acyybIcXyFXfZWl9+vl8QDmAY0nQmBmU7viWPX+QgfSPHbXKj9YT3cuBZ/0tfH0Nj4DPbQE4P6sT7+EE3E5x1z4cprbX4izfnUhOt3Abx1bcDPjuKN0zet9/lhXcGQBwqtp3b63kyGpetptmS/jiFgQafEvs6CwL02AEULghkw8GnVkgC2bPTqRe0Hz+4PIU49buI06EwTRfmECjFqGob5gM5FKKPMBfCaQCITZ/7Lh0pmOz0yEoAj4v3vS2T2fz4azFfWIgYgX5WjQ6XuyRRfcN/XT2lw
 Z1dLJyQ0
 TvbA93ZG08JUgTxw8KYP6gSZYvGabSjozGtvNHhgfVI7HP2h4W0j9vHGhx+TzKRTmedQlePqSq7l5qaGDHkrKdEJK9ahztBFmQds6U3tWp7dbx4tZUHQWE8NN8aZYRkDPfyKvSkJm0WvqzYAjYwaFNFermxEAK1txrjfpFiYYpuKEFeKhzSEpEWDNGHLfo2hnzUo5RJ0Vga0/cxb8L6kyqye9nsWRzOwEeQzZ/iXl5PIJrwsBjE5vH0CAlCedEX5yWmXEFEPpf9JZhiK6JIWLZwRFJ3EKFpm075jdo/WHP63fC3tD5ib6nKASzSaNIDMsefgmGP3MVA3d9bkmOc+SW8m9TXb7jwCeeM2kvn5FbQt9VxGFDgbRWHBMNDO7Qide4G5Q5y57Q4nuYaOtqKOIQaLBq2zU0q9qRr6AUYdoxvac+1wwhromd43/DwBDlweekmdGROuOOK7ryHs/DGed6SYJXOJO4oBLUj5JgmnVcdrOY9NJxi+/xbBEmTt5nvY58Ua2RrQwuOKl2wsW+Vt+ZmqjzkHWokFuwfrQTKZjm7Uc75T9sJECJBlVcWB3epDTrGCcrcQ8YHIF7YU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--u7gkqqtkk3esv3ha
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
MIME-Version: 1.0

Hi TJ,

On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
> On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@redhat.co=
m> wrote:
> >
> > The system dma-buf heap lets userspace allocate buffers from the page
> > allocator. However, these allocations are not accounted for in memcg,
> > allowing processes to escape limits that may be configured.
> >
> > Pass the __GFP_ACCOUNT for our allocations to account them into memcg.
>=20
> We had a discussion just last night in the MM track at LPC about how
> shared memory accounted in memcg is pretty broken. Without a way to
> identify (and possibly transfer) ownership of a shared buffer, this
> makes the accounting of shared memory, and zombie memcg problems
> worse. :\

Are there notes or a report from that discussion anywhere?

The way I see it, the dma-buf heaps *trivial* case is non-existent at
the moment and that's definitely broken. Any application can bypass its
cgroups limits trivially, and that's a pretty big hole in the system.

The shared ownership is indeed broken, but it's not more or less broken
than, say, memfd + udmabuf, and I'm sure plenty of others.

So we really improve the common case, but only make the "advanced"
slightly more broken than it already is.

Would you disagree?

Maxime

--u7gkqqtkk3esv3ha
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaT/oOgAKCRAnX84Zoj2+
dkxfAX4ve8AMEp5rGVxqWdx7mP32EEUlTe7oGqgQsZGk3gdf9G5zzO3162M7qdiD
3jlaGbUBfRHozRNiBmCNTKcExXO6w9Ygjiy0DBe+Vt/PkW0DZjejxbuLLNtgH70W
djcO8jaBRA==
=lq40
-----END PGP SIGNATURE-----

--u7gkqqtkk3esv3ha--


