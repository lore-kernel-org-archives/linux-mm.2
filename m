Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D8AD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2D06B002F; Mon,  1 Dec 2025 13:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2106B0062; Mon,  1 Dec 2025 13:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF076B00A8; Mon,  1 Dec 2025 13:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCB616B002F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:01:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6897B893DA
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:01:06 +0000 (UTC)
X-FDA: 84171668532.02.F82D975
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68E9C1C0032
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:01:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f0q3bYN0;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764612064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Cv5hDUAgknH/+rZStNh6n5unAovZ/kZYUXY/NK3DbU=;
	b=YrJvGX1PJaw6Ll5LluGjeftMpsRd0gmyvp0iiUak4IrmX5V3zmrhpliIVTQgujZIfBCeEq
	0/CuHuMudbquJUAcrTUV5jnQPQWcSdtlr9n2wIHoDJGp5O2s2K38iI88UgA6OZn9wRgT+U
	rzdmCtAGpF+a8qdzeqL+D+IegRZuYK4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764612064; a=rsa-sha256;
	cv=none;
	b=vRF7cWfs+S2fKISvCOlPk23Uxr2kambw2LjYKfgv63QyyVe7TWi+qy7uoAbTKoAGRKkFET
	FzzKhn+yWhisZArVmJzeOWYlVz5LPTnC6R51CKrNquhGxha5yPLxxVNHONhE+Nq5zxP6QE
	FVRTDCWZdDe7qbOtaiIeMC1xau7AGZA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f0q3bYN0;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-882360ca0e2so33249346d6.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 10:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764612063; x=1765216863; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Cv5hDUAgknH/+rZStNh6n5unAovZ/kZYUXY/NK3DbU=;
        b=f0q3bYN01Tg5GGVPbINU8uzz6EyRREt8qqnxQHPsN9/BXSnjFrf6ZhjdnxFMZV7NNK
         LZZakbbvqUUw/aFia2uxu65DIFWvd8cn5OW/khOzsw40A5/u47ty0pTAyaqHDeGVvLuA
         Zd/fVNZddDIpChhP8Lt7JMVBDte+0UosRPcxeGYcWa4QTpEPAsyUBSSYEYYvrJT7fLcE
         nAo9ZDopqdcMhAblh4Oj2wDnXOsf5iHCe2D/5d5zwk6jqzK4At8iXUeehm52kDPLJttu
         rpSHKp8g0gIkah2ZIL4p8iaoPWDfqzeWPaIPKaNtaiuh+2q1jK6Q90qLsnZ6OmdhhrnH
         HabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764612063; x=1765216863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Cv5hDUAgknH/+rZStNh6n5unAovZ/kZYUXY/NK3DbU=;
        b=iKPisshihhQ1Lkb06h727ap83R9+IyacPitCpJ3ydiGNCsz5vw7F7BrFyUXLoqkhpE
         +6hP3yXOfBg88Y9LdOnfXhmOlTIiwASdheGXk1s80JfO+CThSgQuz7IZbP78d77XMieX
         9n+E7ga1RO+EyygRXfw+E+NjV152ngYoHBtT1pGbJHwmNxFbro3tr2r6MgoscJmH4+Kf
         RjioWp8bclBW7uLgiGLFEhOuQTkiQV0Oq6MdygyKq628B5U0kHlpnKzJkd6cjBU7w/vi
         Zp7HzhkeS8wqA7dXxYSmfjvZLYDe3OfmBFSi5dKXPjkOimlVw/F4RBSxQ00E9AzPKS6I
         WnEw==
X-Forwarded-Encrypted: i=1; AJvYcCX/9tfw1IruvwLfVgWqY+5kr06dJepJHNUmdZjVHVR1/ui2L1lcMJHRXcwtUEILJEvgmHvEDwXEHw==@kvack.org
X-Gm-Message-State: AOJu0YwlJKYqvLll1q9jQdGOI8bs1hrdaJaJsbyxJT6U/1gpRX1tYzuB
	VYpySFDENtZFZvXR0Hqew3f2jn9chYUO7RMdLQw0TrLaUksvH5AwJPdzkPix+aFGB+V9Y4fIur7
	3MTpMNFDNm9yIjqhdWdoVpEsAiWi82uQ=
X-Gm-Gg: ASbGncsl8s+KK4NnlfXx4qbbyY57lL6XO2BaXJ8+4aOPNNQeKW4q+tHfwRqrfWFgFXf
	6gZA0hGNJJi+pUEGU60jeZsYWFRi6mOKsjx6xu4We68BoSs+2TpjWzH96WL60wTlcX7AZ3bZgCQ
	KjuTACVXvtsH27SasD9uDB91lb0FPOL4LBr4K8Rh31URufcaPxcZIchHimcNGBrBhCiWOWJD1Jn
	gkY4YCKG3S56QlSJ14c8bEdBVDW/efGwiRr0W0JAIfWrJ50TPzB04ilsOEpnXU/mIF5Pw==
X-Google-Smtp-Source: AGHT+IEnbOkdigYB1iQj98S7F9jaLUo3QrdAuXRWdOjI7a48x+UUey6Gq/+jQWJtLQkGjxtXLM65e/8D5hG4jxJawic=
X-Received: by 2002:a05:6214:21e3:b0:880:4bdd:eb99 with SMTP id
 6a1803df08f44-8847c535ee0mr555865046d6.50.1764612054032; Mon, 01 Dec 2025
 10:00:54 -0800 (PST)
MIME-Version: 1.0
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
 <20251128170442.2988502-2-senozhatsky@chromium.org> <CAGsJ_4yUAw_tzX7z8iizToMB8SDJPNOhFRZNXva_ae46q5vRwg@mail.gmail.com>
 <hgk3zp5hwlcxo6ufiqasvte3hoksy2wb2kta3fime5rprq4org@xaprrqdabvgh>
 <CAGsJ_4z6kSvA+Yzqx=JQ4n3jhQRWn4zYMr364-V2Wjyb2wXE0A@mail.gmail.com> <dt632m4jh2jt5fhnddcbgtdndxh6552hcbwpqeklfx6z7oaihz@lnhskip6whc6>
In-Reply-To: <dt632m4jh2jt5fhnddcbgtdndxh6552hcbwpqeklfx6z7oaihz@lnhskip6whc6>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Dec 2025 02:00:40 +0800
X-Gm-Features: AWmQ_blsT8-0VU02RXHfc5H-laUM9-z7RbHLEIjCAqeNoGAxk8cxOLe97lp3ias
Message-ID: <CAGsJ_4zeqWSZP_xujhbWvjK_jUsPrJDJJ4j4QSgjfUvYtqP+mw@mail.gmail.com>
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68E9C1C0032
X-Stat-Signature: o9sfc4yyesq9kmmqpcrfrcjj6siyrqmx
X-HE-Tag: 1764612064-536232
X-HE-Meta: U2FsdGVkX19Y+oQei3jI7+kW8lcJmoaxlVqaTFK7Rsjn43WHy7luwyAPg5aMfCTsxckwy3hlnl1QFM0N0d3DCSfGrRUgq85XnE1u/Uv4NUCvTbW1ZxlW4H5C05svBhBIaEN65H6WLLxWgv0WrIHAeLwzQUMBxaoSekYPzkxJU3lzfGMEWQgQTk/+KI9qQ7vGifz8we4GtEY5QXo/OID/09LkC3vhsFNCsXRqLCdXvBYZnq0bBhqWjC54T32umgh4ruUq43HFgI0MKQe4lfTmpp+aO2iXPlDYtSY/O8YgM28fbYIhvqOFgVLtp1T9XsceJDx2mtf/1uzLHUFm3VjuKic+n85XG3zxDoD9e9+jIdqR9A1RXYUwoIWop69lSb1oImUNABfvolHfNXWtVF7oRQOPnpJItnu6s8rH4MmdoaB8ruiFuL2rlvvPqB4DT4/V6ukJHzE2i3ehVFRtTJ0LtO1dae7E/YIOYA4094Rmm+kOp8+7rou2QJ4XiGjNS0wzM+uMqwHLz36DTSQcys+21OtPpm18bBsBL/Y9aILzVaQcWOP3DnSs3emdAoXRsvPrdVvxFgumxYQD8EnMqkRhG6PaNm5o2yqnlsP6tPrGAcqH7gyOdjqNsSEvMNhDoSpDqQrLI34kt3aLBAgsUTcz9bV6LTbJ84jNkmP1RK39e2JkFjmNCGLxnCmqZxjGYQbGxLjwNylMKcUtCsssBnTl0xKycvPbF6gL7gObhyJGNN5fGCt8UoZTAJWUnIk33riBIIIPu0yePSC5EBRUe4k+hob/TsaLfinFd8ijp4l+iES4wpR/Xvfty2Pt079zkq/sTGysw8xpUwM2s3UoKwbcdcr5Nq5GXdpFIvROWfj+uB8wuEWjqtXhKBubiy8W4HP9457ui0CLCVal9LKfCHXdQa3qlmI9oSfbmNMxxeDKE0nhr04E9PunPnmAcU+WRpwyqNCVdgimTrGspaQo2W+
 4HQn3mD1
 R46RlBsaVWpriv6LbV/rnFS2FmI7H+DUH612FkPM+6a35DlIU0AQ0WSFxMy2H2XuV8ihmBPMOkqLAD6hqX/EindP5KI5IG+SVA7IAMAmR9E9u9TYoDbZTTWSzKD6WE+6u+ErmkqijCpO4ql+8V/Q46srsrfTQBudo8tkOusZO7zzEqMTe3YoBDW67EjDpsKNzqsIULUWJuTIzKTsrj3rZvi19/HIwNhdQgDpbglqnX0Ke9oAV/pbXckSfPAseEyuKw9KFx4cAw5l/9z2s52VIFI5m1iZS8r2uBHRkb/R4MG+cKKgRGf9nhlYL6gKhehfmVcJzAou0cKVWnoKK/0oQSqmy5Gj0iu+Z+5g2T+0EASv+vj8m7cMiYuCUxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 5:09=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (25/12/01 16:59), Barry Song wrote:
> > On Mon, Dec 1, 2025 at 11:56=E2=80=AFAM Sergey Senozhatsky
> > <senozhatsky@chromium.org> wrote:
> > [...]
> > > > > zram stores all written back slots raw, which implies that
> > > > > during writeback zram first has to decompress slots (except
> > > > > for ZRAM_HUGE slots, which are raw already).  The problem
> > > > > with this approach is that not every written back page gets
> > > > > read back (either via read() or via page-fault), which means
> > > > > that zram basically wastes CPU cycles and battery decompressing
> > > > > such slots.  This changes with introduction of decompression
> > > >
> > > > If a page is swapped out and never read again, does that actually i=
ndicate
> > > > a memory leak in userspace?
> > >
> > > No, it just means that there is no page-fault on that page.  E.g. we
> > > swapped out an unused browser tab and never come back to it within th=
e
> > > session: e.g. user closed the tab/app, or logged out of session, or
> > > rebooted the device, or simply powered off (desktop/laptop).
> >
> > Thanks, Sergey. That makes sense to me. On Android, users don=E2=80=99t=
 have a
> > close button, yet apps can still be OOM-killed; those pages are never
> > swapped in.
>
> I see.  I suppose on android you still can swipe up and terminate
> un-needed apps, wouldn't this be the same?  Well, apart from that,

That=E2=80=99s true, although it=E2=80=99s not typical user behavior :-)

> zram is not android-specific, some distros use it on desktops/laptops
> as well.

Yes, absolutely.

