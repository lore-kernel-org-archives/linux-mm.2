Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45838E668AE
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 11:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A496B0088; Sat, 20 Dec 2025 06:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DB16B0089; Sat, 20 Dec 2025 06:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBBE6B008A; Sat, 20 Dec 2025 06:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E04D96B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:14:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DBC16043D
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:14:31 +0000 (UTC)
X-FDA: 84239591142.08.C653B2B
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC3F220002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:14:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gJ7sBUw8;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766229269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SF3o1aalVLNFjBOXFJUdn1XZc+ZoVvEFJMYXgQhGBU8=;
	b=FqH6YwDPlrJ/FnZNVtZely9O/rSrBol/47XGCExK+4RYsttZCc77DSGbu+vf8d0SJnDk9Q
	pUSwpf5Z9vj5OOBRgPHjTYlvgnjO16C6gKyXmjewrAX+8xH3rxTv+ATiQ2UAjFrr3rpQ+Z
	hqKzdnfhRuxJYC0rsKMM2Vrz+PCkpDI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gJ7sBUw8;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766229269; a=rsa-sha256;
	cv=none;
	b=MClcZIKFjqIuvbPi3QCUWSr+qTPYU4mZ2qjKfJGHpvZs4u/0y4Hxflhr3yWjTYkn2HdYiY
	QcrKDbefbAIv51KBD570BOwkWxO9gdIcROslBYyiTNyZlyX69j9EjytPyplYO+biEovZNp
	yg0IIotRuyoh/FwZtBHrLOEcGfwNRJc=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a099233e8dso23476815ad.3
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1766229268; x=1766834068; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SF3o1aalVLNFjBOXFJUdn1XZc+ZoVvEFJMYXgQhGBU8=;
        b=gJ7sBUw88z0X+T2GwL9+8CAxsh7K/+UcfL0u2s9kPAjtfSm6RDmXKUiRFPatiIq5nB
         6AcLOMndQvUql2GD1UqsjOyQOmOHUKnw1QHGG5+VL44+U55Gj3yS6qfSfvH43w5Zjg9k
         AXLZbA/TNLVMx9HRhbtdfhWpZKyWAwKAxe+UE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766229268; x=1766834068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SF3o1aalVLNFjBOXFJUdn1XZc+ZoVvEFJMYXgQhGBU8=;
        b=sWysBA2NnARGYTfPQ/8oh2pA/yKYGEOMJ7s2SKPl9vCQT6YCIQ5MY2ToowG7r0V8UX
         /gLC7QJJ72HMarvxJ4sXAHUHvJpYeDQyHx5FFGP9jyFFW9ayXm31U18eDi9ZmNhu2EL/
         YzCuTyzp+3I3tWGkB3l0+IUxaKUxxSktt+kd7yAv1FcAjjv/DxD/KdgwE1ZICCOsiOBX
         gnRnNa6USCM847zWc36uGrdAsNmWjf1z3mJCXsS0vJ88DcbtfUtEqXmCBboednmPaiKb
         RIW+ddNqZ0vHJkQidVF8yg0gUD1Li+ssX9qTu4d29MPaqujlUqUDab6GsxGzUPiTpmtS
         23ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCjK7j0JTVVac2JtxrPQy6wR/Ucy0HbDS/OUFUbPbUq1O9FPN38O5NBGSjhqLKGbGs719Dnz4s6A==@kvack.org
X-Gm-Message-State: AOJu0YzQiCyYy5lYimVKrXnWUMJXfKZwe29/vUa/Hpxi8Dpt6QLy10zk
	SmLFBcPHjiQm/tfzDEGQESt/iQYXsYIWcAAZAd2n/v936JB/1xbm85AW0DQqDIQ1hw==
X-Gm-Gg: AY/fxX6AVVoTWr0su31I3DgFZEfTn6ay560RnQI6tzZmhgzpk9BROGv0t/NB5J4tsiJ
	egdCzeQ8gtxnufNjrMmQAnZUCj2VVJ5kUBgYcFnm2/XZbsBd07Dv/IgcAVBTJcEfMQ1r29XSBDS
	sqbZ5W0bIVKmHkmqhGLhD2YRDQ8BaqWhCjafosZN1q3pkJOXpM7FB2L7ZWBbDIH6adBkSaaCGvd
	P1PnmajtW3P2S8TWJDC2uRFQgNuMzH2TS0hIGcaoHi/u8IjGVVQBKzgvZSGSkH0NL2itwYgN2l2
	p5APf/bLFRMNbtfesAuJjoXWuuIa6AfH9GkZp0WiWsr/ZTRYWiFmL3hDPhD2NFgf3lozJMRxZx6
	En/vx9W7EjUv2zIyFls8U3eHsTIdpCBAsjT5rT2JWZ6T+tbLHld7WSigUBEEkQjpI9WbVl9FnLq
	f/R8h/UWvYlWJA0PV/BtR++CSfm106FyVhKEGvHT/BorK5qoETHfI=
X-Google-Smtp-Source: AGHT+IGiIb9ii7ebbHld1WjZPoc676UwrBtAENP5eu74kP0jFRqrVFrl6jLzBTD6h0o2zW69ICI+/A==
X-Received: by 2002:a17:903:2b0b:b0:297:dabf:9900 with SMTP id d9443c01a7336-2a2f1f72b44mr64415225ad.0.1766229268418;
        Sat, 20 Dec 2025 03:14:28 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:525f:ba4f:fd0b:71f6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82858sm47280545ad.29.2025.12.20.03.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 03:14:27 -0800 (PST)
Date: Sat, 20 Dec 2025 20:14:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <qn4kjdsbi4h4sw64epms3sne2xua4ucpx5p6wkwbuxt4ihhwfx@db6fy33jmwqt>
References: <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <tencent_D7ED79431EC0D75957539121B7CC7897EB06@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_D7ED79431EC0D75957539121B7CC7897EB06@qq.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC3F220002
X-Stat-Signature: mo4o8tudh97chp8qpai4izm3hf7f6dw7
X-HE-Tag: 1766229269-833789
X-HE-Meta: U2FsdGVkX19bnCTVzUpYqw4xvDbdWDSPlUxm2AumXtEHZtdaDyBGVTyZ2HKNPR4oOaJAGKM1QCNjGk3xJL/Q2I0iXVu3aW4PHS4u9FzaEr8IlFRNVWZpc5rp8VyAH+YOBT913PLqpm2DaXHqiq0zJJ2WzEaI7voaFLq78b6P7H9bFIuY9VuotCHTtOMM6g+SJjkxb3TrA7kr11Xrxal9+frhNmMGxWX2lAuNaV3OaGLddbzSKXK2Zh+sqw5xb5A0WIGfQZWV9ayr2Z8XjE/mgQL6mXMNdLSOG+PoqgjaPKIknMkNtDvzjGNxpX2N8k+GfqRimBAb/5oyS4onLhKP+8aSWbKDzvBzqu5wSG1yw90NGz9Ok+Iz+8o6F5YGqRxGcGscrRSaCaa24rYn6yHX4cRzobDX9FvWg5J+7Xflyx9D8zm7qlyVIYTiWh15YpoXWiwb9Yj4kQY0asK/ZRH2al2JvLo/G/+PonwwY7pfxnC/NkXbj+C0lcu0BX+v9YnbMOSV3PkJx1qkJJytmiqFDiKVFn8wJq76wAUMs8bWoPojrWtFvEjjdV9Fu3VYxzVm6+o+CJYC+aEr9bbSDPTWQcZP6nBndbMaWIPEu+/BRgsWLVtOhhjCciVt1PjySA1msGT00fRghwiiJzoLD8bGc8iBV4z3AMm9MMTghFM1wLp+MZI/OcwIcPpsrp/c3/hDl5TVquCghfHNftSc3qp+2pjfLCPlbh48ngI4ko0s5CZyjZnIoODCmv9x+y2id5Ilg8g8eJI/656DTUehRBc4eKrEKWAozpO04wIuNOn+axBGccDipNZQNLN0yEU2JtLgC3JHrKWdjz12kJSZaAY2O/+TXyF34yA9Gg6YCCETRzgieAc2ZCrlj3C5nrRMjy99oc7JGwDBCMh37apGpq580HnEWWYzW1WYArjO1mjCMZ14zTP00XzPCu7vIbUCXmJQ4l6WH2RvpDou3i7DSo+
 5/tsyHri
 1ouzsfG2I7UuIw8PZlxNkm22Jyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Fixed Subject line.


On (25/11/24 10:15), Yuwen Chen wrote:
> Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
> 
> On Fri, 21 Nov 2025 18:12:29 +0900, Sergey Senozhatsky wrote:
> > I had a version of the patch that had different main loop. It would
> > always first complete finished requests.  I think this one will give
> > accurate ->inflight number.
> 
> Using the following patch, the final measured result is 32. Using 32
> here might be a relatively reasonable value.
> 
>  /* XXX: should be a per-device sysfs attr */
> -#define ZRAM_WB_REQ_CNT 32
> +#define ZRAM_WB_REQ_CNT 64

Sorry, do you suggest to change default value to 64 or are you
happy with 32?

