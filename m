Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37ACDC2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 08:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40936B0092; Sun,  4 Jan 2026 03:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0AAD6B0093; Sun,  4 Jan 2026 03:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C373D6B0095; Sun,  4 Jan 2026 03:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5D276B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 03:41:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A63513B117
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 08:41:31 +0000 (UTC)
X-FDA: 84293637582.12.BDE7F37
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5047AC0005
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 08:41:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OMRXYnvK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767516089; a=rsa-sha256;
	cv=none;
	b=JWZC6bmlLuJ3a2BW2Bb45oDLpoAjm4eDFRPq9SJned3EONip083pd8cIuqMdUv1aMUMAIj
	ykmAF5fQvFfZ16i1lY2nlCEOUcUd+pSsHOZ2lerkSRNN4k+r97YlukIzse+8ny5H7XWjDs
	DzAX/CBHq2kbZClMoeb8iXAOncbU5xs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OMRXYnvK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767516089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZL3QagTQ9jAE3jZf2UYj5e9nSx7Hnf/m9dZ54tQmU6Y=;
	b=Ojppf3ewrqs28M7FIZUshn88UjGIZWeBzMLi/kq9RU2G58/Z1M7X5MdCyTft4Hfln/8yl/
	KcHvgVANHSg3es2GxFl0OmqxO/s+WnIQ7KOC1nUu84eLX+pscYq67nIazIIoOW2t6oG5Wr
	Ij1V6cId6mCN7O4qfoEkqys1z2wk6qo=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42fed090e5fso6010780f8f.1
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 00:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767516088; x=1768120888; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZL3QagTQ9jAE3jZf2UYj5e9nSx7Hnf/m9dZ54tQmU6Y=;
        b=OMRXYnvKBi7Ju0Y2cRVwLiYxZt4Xf/XU5LJGBTwxp2gV9iIMW11eLH43z8c2Tj1uRj
         Ga7QH32J4MoLhSmE1GpO35OXuZ9PN9y2xczsrgGI19Qq58zu+0tWQfvF/b7aQYkq6v6M
         5J+SzGpL6Kdh1xewUYoQmo6qj3NfJOeKJ1IyY3xiL8bcAXCv+oxo8NNpewpoaBhzw/tN
         hRAd0LFpAbmifQU6bdTTM3yY+x0Fo3OkdfcfGdcufCGkqWmUOihbWHAjaARw3pPW2jU+
         77ni4qp3gUvV5pMq9UHE8DnYGozWgBRIXC50bh8FBz7ePb6fl/s2HS1YoGYFtLJR3EKc
         LeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767516088; x=1768120888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZL3QagTQ9jAE3jZf2UYj5e9nSx7Hnf/m9dZ54tQmU6Y=;
        b=jwKofmnIkNT2YIhGlobFcdogHjtDgvCSFv0fpt0AsyljnFVgcwrRAPrGkXmAQwbcK+
         tHD1pAHu8bIFsPyDApPaoRoeFiztLSGB061F94bq6XkwjuaWcBmmO56ciilmOlU+1qLG
         AuaPC8ZWllNkClxf8FtrOe+xoDFsGtgHoCBhsameD0vRyR5McaGSeFSBAd+9cbckkL1O
         hu0OUAd+hcZmYhLiDcc01NIQcMyQwWMvhdIuRKz4aD7ZjiPw0zu5pZH0NqPCgg2GPn7e
         6XU3wVtRg569G70GYgXxxC9natQOsw37wf89GxHUsgnrW7UC4je2ZonyRKyNJoOFfLsM
         SUxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU76z2qDNr/7hM/7GpTG2PiHFc2TXB/00XQ49g2ybY7ykZQxUumXFXGSh3iUwUwxcebBkMPKv8GsA==@kvack.org
X-Gm-Message-State: AOJu0Yxyj1N4VE+7Cd3rmr80VElvb2YXnUqZaaJzxrM6NLJz6/JtzQuV
	slxPCqKyzqyX/7t2WcyozD11F06OgoPVHNubtigYQPPOa+RU5+hfaEt43JrlYqwCZwwtIl4LjWD
	tI2r8GqbEFfDfUSNUyU7S8HUFjxJVnbo=
X-Gm-Gg: AY/fxX7bOuiBZZCkufoBMWUqTfOteX3xhelvk4uhNjIOzvC8ErEr7bX3VxKC/32Bpsw
	LrOJrPtvl6iEPyL1HmtiLruondm+/LeSqtPaBAZwnnJTgj9gdxlM3NL73qQbx4wN52GQ1HLGsJw
	ZFI//N4yskqzyTAKT/plEglU3859eEu8jLwesXMqPj1nhPz+y/XNVemJFgsXg7qPxMaAEnn0FHY
	2zajJ8aO+pIU8y2dYsutYLxGcu2EVedecegfGuyjPDdeZ5jcqFTVtx21MHG0sDZ8d/kQ2nB28zN
	p+PcR/INbn9I3dh0qdKK2G0tK5/XQAhQxQdeLLA=
X-Google-Smtp-Source: AGHT+IHQzFq+i/woR5r1u+aL5iID+9t9gIdl6JNWh5ubS4UyoIIR7NC4C6gkz8cAVcHEVBoMLfdk3Nox4f1w+MwWpLY=
X-Received: by 2002:a05:6000:220b:b0:430:fbce:f382 with SMTP id
 ffacd0b85a97d-4324e4d04d4mr55366470f8f.25.1767516087495; Sun, 04 Jan 2026
 00:41:27 -0800 (PST)
MIME-Version: 1.0
References: <20251231074638.2564302-1-pbutsykin@cloudlinux.com>
In-Reply-To: <20251231074638.2564302-1-pbutsykin@cloudlinux.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 4 Jan 2026 00:41:15 -0800
X-Gm-Features: AQt7F2ppXwyMl6fyQEBfhw1UkIR0oohdH_p0Oyp-hkq6e8XFwU446CRH76b3fXk
Message-ID: <CAKEwX=PVZJZHJ9JyubqH4C63RLRiHvMaVYGc-TtY2jt9vGWzbQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
To: Pavel Butsykin <pbutsykin@cloudlinux.com>
Cc: hannes@cmpxchg.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5047AC0005
X-Stat-Signature: wdqf91n7yms747c8x45s47i1cuw9q9as
X-HE-Tag: 1767516089-790947
X-HE-Meta: U2FsdGVkX18X3LgRq0OZktlKYZIRb8FJLYAFK6mf/cNl1S22skvg1Z5DowcLJheZ68hV0kt+rKTbjTPqI4puM9oWh38wVYtoUZ9SEfDKj5tdcz2VNDq5KnVzB4L5bb72SVX6mnvFMemGKMO5Uy0EtQaHc0n33/0zF2d1sGOiiV0z5Seh7WMVACLxAoncoYbyGrThMkuj33wtfmPPNeoTzXNDLEEsVw86OmOSzHknkFVT60XVwZrHXvcB6Y9BYVGbDHsmkdHw9TW4TBsjVVqbsJ2usKxwlLoAEfozyvER9ETmE24gpSMf73isge3E4ZTjqzLm6HmZA3b7oqvTDCFkaba37f8Z8ELQCYnYNd/npA9/TfQm2DL7pP/LjkGQDTe/bA78t4Hk4uwrt8KriIzt/2RE4L64QGDB1/BPMe9wjNBPCVvhMFN1ozuncLSK+mO0b+XlV041yHRLAo6A/5V/Rse1J9pFSjpya7UMGbetnIaC+8u29lrSH7GxK4HSuiZu/Nb74E1yKKoSIL/mhVfg9c0ktuT9kQiF06/s9+AUlL9EYchRvEabV006RA18ACpKjkdWWEDotwDj5ND6zgttI5McDDFcU7AZQfes0+94ayYaKsBcZ7XcAa9s135Z1lg9+PxDOIsutbYpcQ0bsGrcLv+qmvVFHXLjEGGvM+P9ztS6b//7A5PUF+vYnKJpfD/8b09kxO4BPM9jgn49mkD4hy64Wfk4xjicHfVrWl9fHR0/QxNHLH3QRqfZxlcY8dIgoJI8AmgRs78wj8X+uj56JNLRqSRDF/KCNErRy5z/wCOqiUVy2LSz3uaMbdLQ8IZpeY0EQIRArjmI2teM7etfpyZYk8aHYXbvWaFREyxOA5UEeHs7NZPqgJnXGny29aX3cGnUtspT+Sm5xCou5/3gLtJLzd0Dvwjgsp9oZHcIK/W/ag5LxSXqy1KJ8hmKqFcMNAa8ykvVEbvjKQQQziW
 oCdmpsCx
 aussqOIZ9dxEUrUUhJ8ccDChgj0OTgli0/BgG5cUM26Q65y8y7BPHUtVYPVqVRsCuzJxJ+Yil2gmXKWIXElRwNNAoq9ohQeuXlDL19N+X5HJ1RnE6YIbI+nj8QaX+XJdMkEDpMGvWdw7aqpmcdaGmnK+kToTm3dQQBOPMSQS+BK6ELNP9MFu9tkf9K1R1GlJAVAVJabKHb01EdFRSwxpbpQ5zuUh1YkrI1QwQH+02uwQnomB9WrbWFfhU9IQoBDMPzEgM2p2R4k4V+IwbYtjS5h7dEhL8vURYvz+MvaMTr1wyHV3bWoLp6oQVOacbmcJNYZhsiApF8B7X7ivKN4OgPNJoQsphVNb774E4WZ5GyW9EF5v0DMY4qFu4wa/NmSchExYGgezf/bqr7YmzCQDOysuI43HG4pZHz4svH9IXn9N/ya6zq5irkA1t52gub61w7bT/VQv4pULPszA3bpn75P7zmQVN6RoVhzFahfP9HmSAdcjSpq0YVlg9kn3b4BWe+LhE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:46=E2=80=AFPM Pavel Butsykin
<pbutsykin@cloudlinux.com> wrote:
>
> crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
> only for NULL and can pass an error pointer to crypto_free_acomp().
> Use IS_ERR_OR_NULL() to only free valid acomp instances.
>
> Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside=
 the lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

