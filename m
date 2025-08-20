Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71615CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1402C8E0010; Tue, 19 Aug 2025 21:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0EF8E0001; Tue, 19 Aug 2025 21:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F219B8E0010; Tue, 19 Aug 2025 21:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBCCA8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:13:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F70858428
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:13:28 +0000 (UTC)
X-FDA: 83795362896.05.D7CAEA6
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id A317C140015
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:13:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eqZEO0nm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755652406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx/MGHA3TM9XUf5kAbpDdc/0VhHbk/XNx8hA2fjDbco=;
	b=QnQ139gNs2Bta8UkIVTsGqhjtUA+sxVUlLy3a9TeApO7UAkNUjFCHhtoJHzNNNwJ+bGRn9
	u4unPmRcD8s12JYdBO15qbFYLaREW71gGxz7TQb3saVS75m8Xqx7aCa5vI3HBh3if/5ruR
	zlGcPtlKZ5iMhWV72b3PHOORlg4T3Mc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eqZEO0nm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755652406; a=rsa-sha256;
	cv=none;
	b=vi7FYqeT26W/oV142/Cf1db4tUH14+K8CN+JMcjQlN3qiNvKylR1OVECQgqW55O8rMyyP6
	GrBHSGs177fNWlQLPH/O6vxizS1yZJoU//I8SK4B1cvx1JHX/DlQPjFNa+CRm3SgLlgYeu
	PlFOrGGctWx76qhZANRJ8ruhqBAK7M8=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-53b09878addso378555e0c.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755652406; x=1756257206; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yx/MGHA3TM9XUf5kAbpDdc/0VhHbk/XNx8hA2fjDbco=;
        b=eqZEO0nm64+Dpm4RZai+/0+XTrgoR52shMqBu5bFFaHEyrxcVP84tHwiBX9IhVZ1+I
         aONt8Luo0W4c83uLA2yrQRFJiz+i/0HfLN8fDis518721Uwhy/S8mQweJQISCb7ycAm1
         yqdF83/VOQOUBcv3E+TBGMeaGiaPoT//emFDFANyNsLd6GDeemriJk49ciGTQ9YvBl3m
         fuBlVLJlh9wOmNGw2Th3FgcstilFA6eBWQMQuCxLTjNp89TqbBQHhvJS7IZhtcUgodCL
         Q+U5CUOfTFccudjgmFrd2TOfFsQVj6PHjCyDduAawt9SWdNv6Df0KrSR2LgaeiiqBSCM
         0mpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755652406; x=1756257206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yx/MGHA3TM9XUf5kAbpDdc/0VhHbk/XNx8hA2fjDbco=;
        b=Hi+nXuopH82wD/pMmCfJA5MqX/4bhySvAaxOJZJ+Ykl0haIzu+VunxUDYSBciYsJFL
         CChKJwT93nKZs5UpIeREyovUBt/0tcIeFv9Ti+1BNtvLVDeIF2XJkZcIBSCMKp0RzRYM
         4Zxo91KuGQRqwbx67oN4XSikADHdq/n3gZHYslfcTD/McjPBrEwge/MVt7Jsc1JaLL9T
         /bNfqxEoDQl5XDJZGOFt8KuMHuAXbNT9FbmRyPtx6dyBF/iMCFKdbQn4LtwpM39MHYJP
         vPLu3zS9evca1YZIqAXMB57HGiJOzRb/C436eo1LvIOF4rqK0jvH25TjqnJbmXqo7Y2Y
         Yj+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXj3bXWNkSuFWlKAJTy/w4DTJfnqGLmzP5yLJ7ct+BY4bt+gH4agZT+fft27eGl8PFkNA2C2d5trw==@kvack.org
X-Gm-Message-State: AOJu0Ywnci2i+NGHjdJaZDo/bENCqmV9kTosaw7w25+eeq4yVmbD9e/w
	H3rDDjVe9APPXDezWob5zKYBIDvpDqLnyvDq/BERcZwLkyZULKK8KpbIFyxBcGZYNd6HqFG99AI
	m7KrCYhvuNjS0zI40DwLGnm3RgDNK5PQ=
X-Gm-Gg: ASbGncuTC06EdygXugZS2QiSvXn66r9+ap4VOzjZsc58CT0cvI68Qj1bKPFsR8J2ToB
	UGgorOO1JEG01SXxf9j71IklgyETzA24bGYCXlwsB1qIJcvh8dmeBmnTp4EJNa16nIX17j0nJo3
	P8/kmYqUwgOKEtz5fGA+LgIWJGGzSqoL6jAXeURfko9kcNLzt53vdJqO365i4lxckR4WWWY+3RA
	YBvrfCmwMdm8P+OqQ==
X-Google-Smtp-Source: AGHT+IGHOupGRo+nK+1VwSYji170Obnj7FaCmyudWwnOp7XFjqQSEq3YhXAtZjXFf4Eiw+cf1rUoYqb3nzNrYv5tO5M=
X-Received: by 2002:a05:6122:468d:b0:530:7e05:2029 with SMTP id
 71dfb90a1353d-53c6d6569a3mr499389e0c.6.1755652405568; Tue, 19 Aug 2025
 18:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org>
In-Reply-To: <20250819193404.46680-1-sj@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 20 Aug 2025 13:13:13 +1200
X-Gm-Features: Ac12FXwrLRpJ2ga3pwvuv6cGSCA-Czm3wS4TCkbPm2Umb0bGpsO20qp0BKxK9T0
Message-ID: <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A317C140015
X-Stat-Signature: h4ujxj9dd7axcm67w81pgmrb1of1g1qs
X-Rspam-User: 
X-HE-Tag: 1755652406-315262
X-HE-Meta: U2FsdGVkX1+mVuC+hwL0MyzL38rPkT9OO+vLxcV6Lhap4XvZI0tBtn4S/KoCtENraF+iSGoT05zdevIsuVksiOKQFwx2orRX9dBXjWDFILugqtilc/ZYlxgUkDlZhJYpVxyWywbnivfm1i80VFmqW0h6qsrfsCqnnxYI/Z/zPgmHvurzzQFVfKdp4rP19pS3/QcyF61rfJE6rpRUcSxp68ygNfwc5V5J0GJIIfktnCJHtGyWiVTtjlCsNrX4QhqIjA2HCOf1Mg8CVlWa0xDHcLGCDdMgUgsTnHo1tK3ixUtSo4FyJsy5z087j9VxGTKTX5+zEgy8Ca5pewP8whsrx1l53GTVvEur7J4WTc31PDjt/0P6uxxmqCU5ej7LQudJgYq8YxNmRmKHdqsS5C8EEpbJOgJmRcLNEFyDmndr5/2oEU8sdB/ehIg191n73Y5E/tmAyQfUipj32O1qn46XSn5G9A42O/QHScjdJSepU8xOZRet89xkVyZtw0dOHQeeYx2738LOYpD6LkXFJaESv0eKK0A3m5mFfrjthJpK7pmphb1Ivu+GXh4rjIuy/LrlZXm3pjS0yQY6NKfpxW5hopes9cKNH+gs7uMAzpkB2DjQCqR/s6/TrlV++RNwSvifW84zY3p4QY575btBU5DIMiHoTLvdnbtkMEdQIr0qCv1DoDclHW+Yc5tgi+M07Z9F+Dndzg+63VxJ5ITFMhmsWpQ+gqCpOHsnLxUnVWSO0m3a/b0uzXHNaOf3OkUI4t3by2tQ+jBCXVNO8S2+zXaNeMch3f0lDioyaYP5/hTzp3Uj4KgflhZaysbANS2HkbvJKUlGERxFbpLVab9PybwV81JMFAneXAMkUAKPFDN1odSkK8bS+ALaY4/lrWjS2hvVsz7cn1NrtJdD5acgC2DKvwNf3nkTVZO3MPfcBVBBzO7Wq/ji7OexxJ0j1x0EXoUN045STFbtOVxncwNo1r/
 tOKsiJMy
 pKLs4Q4DX4FzE7jf4mrcVdRUjbYuBF6BPfPy2MzkM9mIWwGlYsbKze0hAOaHKeQh3AXXl961+u9pelOfaKyoy/vJ+FdblNbcFHTSK/cN+aa86yLs9i6ba3RNoFHAT3CiD9hKf6zfCheAKJLWDVHaEP+uVgL6D44nUUAZUaBAxlvWOH0HZkZz3xUO3xGlhfxO1t4cdRcsmtu9JVMNDZPSOnqG5iESkkNkYxsK570g9KVIAzzp0BC/q12K+Gjm3LqSlOgXGPny+WnaQowM+gW7ZuS5AKQ3kgHZ7sxfjlSUxGOukwvsGP8Pi2bhvzOAQUko8gNJ81ns9lsXocmNfskqgUR/SsOyvdxUiWVRXqczR21ZixAbb6hUygdW5wc1mON5Fghz9+3Xsl4nokUs76Bi1ZGRN6yln+kChe3kyypFEItGE92G6O19OerIV4dmdlxWv0l/nw/7Yn6+sMJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
> +
> +       /*
> +        * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> +        * save the content as is without a compression, to keep the LRU =
order
> +        * of writebacks.  If writeback is disabled, reject the page sinc=
e it
> +        * only adds metadata overhead.  swap_writeout() will put the pag=
e back
> +        * to the active LRU list in the case.
> +        */
> +       if (comp_ret || !dlen) {
> +               zswap_crypto_compress_fail++;
> +               dlen =3D PAGE_SIZE;
> +       }

I=E2=80=99m not entirely sure about this. As long as we pass 2*PAGE_SIZE as
dst_buf, any error returned by crypto drivers should indicate a bug in
the driver that needs to be fixed.

There have also been attempts to unify crypto drivers so they consistently
return -ENOSPC when the destination buffer would overflow. If that has
been achieved, we might be able to reduce the buffer from 2*PAGE_SIZE to
just PAGE_SIZE in zswap. There was a long discussion on this here:
https://lore.kernel.org/linux-mm/Z7dnPh4tPxLO1UEo@google.com/

I=E2=80=99m not sure of the current status =E2=80=94 do all crypto drivers =
now return a
consistent -ENOSPC when the compressed size exceeds PAGE_SIZE? From
what I recall during that discussion, most drivers already behaved this
way, but Sergey Senozhatsky pointed out one or two exceptions.

Let=E2=80=99s sync with Herbert: have we reached the stage where all driver=
s
reliably return -ENOSPC when dst_buf is PAGE_SIZE but the compressed
size would exceed it?

Thanks
Barry

