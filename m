Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1B7D116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 07:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C176B0011; Mon,  1 Dec 2025 02:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECC66B0022; Mon,  1 Dec 2025 02:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB0B6B0023; Mon,  1 Dec 2025 02:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 369436B0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:39:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6FDA13BBFC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:39:28 +0000 (UTC)
X-FDA: 84170102016.22.0AD3269
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C27620005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:39:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PyNfFua7;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764574766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHmOAXqm4O99qnKcWZXHRu4eYRJbZDhm5nIu4Y+evcg=;
	b=asQu9MF7jGXqSMLLox8xuL7Ei7PtwsSOHjlsLBPb2J5pVUMZF7RUKoFNWjWNL6/eeFBrNs
	K2LdHNQD0JumNXyj2lN7f4iXkVIAyHIfPObWZe2mqwkPPuO9i2lpDxdcz++nWCMlzmkrrF
	QX9uryf7HWpWE5A+SONrG4CH/MCeJEw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PyNfFua7;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764574766; a=rsa-sha256;
	cv=none;
	b=wvR/ef90uF8nRnA2j1T2TMCyj8nh3EcSQRnnWesS2OYzrCbJCvabInZiIIgaxlWvkkTbOZ
	Us/LXZPvggPqqAi7o2FwMLQQMsI6HJ1G/RZbURdTkY4HNRLRiT/TMAoM1O2D4k4seZUMyE
	oi1q6UsPOnG8hETDNQwSm8mZaQTP7BQ=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso6158364b3a.1
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764574765; x=1765179565; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HHmOAXqm4O99qnKcWZXHRu4eYRJbZDhm5nIu4Y+evcg=;
        b=PyNfFua7iE6Ve4X30sYdiMnwLODgapEKzZSxkoaMnMK2h9/mhLGM+/NGHCBZMz60gK
         YTgj/CLctBnR9dBHGmvPoVk7dITl605Q4iM+n/qAu04OqCOgeTqKMrFDaTg0BBuHHp6u
         7b3dr6+lDdC0Q9XRt3+AT1lA+BVsdlTno6zbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764574765; x=1765179565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHmOAXqm4O99qnKcWZXHRu4eYRJbZDhm5nIu4Y+evcg=;
        b=ioJtczgNbVf19/lUml92tF93lRBgoN9FXCZNrVMxqSnXCPkGorRk4jVLqBI41A4y3W
         VeooW2ZpaVkl6GnTquO54tqSJ1Nxbs6ulB01xoHh+LY4dWugof8QlUhIGDGoFCj5VS/r
         yyUK7wN+ct+IdB2aqyavnndnyiXquZMc0ec8kIMAHyJzK13GTXPO6U7ZjuMZ5u9Sft+t
         xLfyKwfVyKHebJZv5lztCVSMWpOUFnR/k8eaQV7zl1jcNpdE9ekEXL9jR+yI6z//7YX4
         /vkWtM6kigDg/6Qb6qYB87ZGk1vN9L+bHnYeEnuoni31Jy3L4rMQSWR+VvkwJFC3jehh
         qc2g==
X-Forwarded-Encrypted: i=1; AJvYcCUX9trkJ9Kxqb/DMmDi++acsZlnYgNtpNg+kJuEitPZDi7t1qM3RhYK6IwJBIe5DG+yXDMKYGdp0Q==@kvack.org
X-Gm-Message-State: AOJu0YxQX1hIXdoPe1q+EMJavQqwVGIsoN/YedJDdrB7CgTlE7n35MN7
	4jnneJft+a9SygUfxvQ46I22wi+JY2SFLGHdcfO1+J1V9G4/ZNkoPfekl/e1M/uJeA==
X-Gm-Gg: ASbGncsH+YJPZnfF6ZHEUCaZjH6IdcRRs1TJHBR2Km0pd8J3LY91okrcz0H0ap2LMZO
	ODi8AF5bKN00G1e9bjbBRVVfc9mj3ATw+tygrIStD8z6CvIUBRirabRW00YmFiefgf/dolv87/8
	XG1pmKfSso/E+lKFjfwfr79uP6USKH3jZtYhOluxhHZOVV6YVKdSxZUWrYgGVh95+gWlCbti/Y5
	DGDszaAhj5FZqzKWAiuPbIIy9v9Y/CVhn3T/+YCfVq0z5C4KhH4ZH7BQb9jkXriFDMrZgNShisJ
	onHAPhF1J9wP9+Qi9oVEjy98IYtgGmtyCb+PRJupnJGTli3wwOcHvGmE5Hr+6OM3G2e5n79jGrt
	T4FcC+WOGU56AHTuDC7P8Ew7sgEZzwA+Bo/n5MaVYYjN75snrdYIBCB5HrojyC9dozl6JLfsz8o
	aMeYgqUNTYlfsvVkGBqoZ8yQrSTRs7sy/P+EuauF0AtXkPAfmZbpo=
X-Google-Smtp-Source: AGHT+IGZMdL5p2+g88p5Lpu0jaNJNlaS/+US8v+KrPcVsuzDzoJIztVYpsEnIj7NaKeJSLPgYGvS7Q==
X-Received: by 2002:a05:6a20:12c3:b0:350:ee00:3c9f with SMTP id adf61e73a8af0-3637e0b12e5mr28351389637.48.1764574765376;
        Sun, 30 Nov 2025 23:39:25 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e9c3f79sm12345012b3a.42.2025.11.30.23.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 23:39:24 -0800 (PST)
Date: Mon, 1 Dec 2025 16:39:20 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 0/2] zram: introduce compressed data writeback
Message-ID: <24o47a762kurbp33vgmsp5gclyijt47xl6ms3ynxjr3k5o3mbl@t2lsiq6swjj6>
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128170442.2988502-1-senozhatsky@chromium.org>
X-Rspamd-Queue-Id: 9C27620005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dkbn59kiqqjqg18mutzz7d96n1t1y45n
X-HE-Tag: 1764574766-851760
X-HE-Meta: U2FsdGVkX1/XM3M9cBrsePW0RVysAOiBmqN7ngANQTSjBnvlfGymtmSnBq9HIPFBr9Y2aIwR9GF7To4IudIRdf75GiD6G6KzxSHUtPgFhuknvEnOc1rSx0bBXwsMq4P+iEFsTtwXeWAqYB4wIr1oNXMQDZD38oTzFQeOIIAlOIsDGAsvj3nGLzI/U9qwMKTexaaPGbIRKNatLl0E1kT0OpsCTVJZ0pGjh4ZUpRMih/HUqlWDFrYN4Bvgv9c475bOBpPS2d1CFhkhD76Z8KsfoQV6+UNkueL1PTsb29UTQbWkz/432MWSY+4fPEsyumt6BH75PABzQvGuL0oNxVzxMx+stHZ16xWi/gES5eo3/Bk7z6BY6I6pO/miCRux9fZb/0/8+8cYuR2JPSgTHRCSaQyGKkyuXXM03mE72czpJh++5/1cNBkFZjJvv8SJFk3n8EGLSvyvi9IP7oIrLfaEv2oPF3nEaE5KUPaaYTUqw+sBEMeSQmZS+GK2tqUMiZz6GD0RddSJqfhC+sDzJpV8KU99udgL45bfAUhoLgXJ3axb0Ow+QKNn+CV9FFW1Hm+Z5cZJfeoVfsvZc9o9Fl3+IGDZjudoAw50QYwQpAi9qvRhwD4kf0Ts9pgKVbXSWFXEYijkYpUq6fQZkNGnADRtgbZ1Qo9EIcIAsZyBu9eWztpNgERh3mspL6NZnbHV0IbjxSm2nCLSZHKZRCmdrwkmlMVvsVyzhZoYV/+sJ7Q0wv2G2MYhsiMbs/51Utd/wmcv2sAQUIgDULelYjXv+PgqrCmyFeQ09UK4l4auiLVPXpU37UFzki1rHJ80b8VpczHWNMQAZclsR5UwBPCpm5pACwymUypubqQSi/EhZ/fZLEXYBierQm6zsZNBsXoQnp0VA/D2kQrQmsm1QcmdTWBBjTRL/Eg01iSEf4SvtuauM5aLn1JQ3P4bEKsWEt3uSXMK7UP7wXjYvMBR0AVX9Wc
 FLScsy0a
 8Nd2ODI02eX0dcbhphi/c5QVSN5mdGIFxZGf/Xcr6fkjxj13FkalZZDV+XfxI9G8rDQq1xfgX+YEJOp6qPpveHMwyAJg3aCAyF9YdMpwocGB2BmGCDbABOJhISejUmCTn5ggx2iMQp11JoDDNSD9HtygkkJIXEigq5mGHXvxqHdcHa5ZhWnjIrOq9eyaOFkkni8WEmvnYom0W3ecCCWs90HqA5ctqLKR1QS91zu+oYG7/vDIWdYMsnenIS8Dm8yJd+N6cffWVt7Cl34GgB2zDkPRIRZr3bZahl9aqVLR0hAoEJMjLgVDu2+DuvMcVOn+b8iLrgDevcKsRIjEkImpwLcHp7tcbc7iBpe4nWCDVWcTrvSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/29 02:04), Sergey Senozhatsky wrote:
> As writeback becomes more common there is another shortcoming
> that needs to be addressed - compressed data writeback.  Currently
> zram does uncompressed data writeback which is not optimal due to
> potential CPU and battery wastage.  This series changes suboptimal
> uncompressed writeback to a more optimal compressed data writeback.

JFI, v2 is coming.

