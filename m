Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BCFCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714C16B00A7; Thu, 28 Aug 2025 12:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C53C6B00A8; Thu, 28 Aug 2025 12:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4436B00A9; Thu, 28 Aug 2025 12:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4794E6B00A7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:10:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DC4D139122
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:10:22 +0000 (UTC)
X-FDA: 83826653484.12.257AEC7
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1DAA4180010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:10:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QMZP2H7t;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756397420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRTOW2045DXQQ+GW8Xk5izAs9xkstSciGXpe/X4tnN4=;
	b=ovjtUkBzIt3kN48tO+IGwmPxrxY3ixVUAieuj7LUGwdyXeqqUXKwxutkCwcVuPAu9fxBjB
	WOcQZVw+v3GswGxz+QT90M3HvcPHwZ8Ms5BbZHJo3ozzxqzo37lCs/XNNG/bC5LzVmwab5
	YCQ51VRapVY1+6ysrJ0xWBvHOmhihFM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QMZP2H7t;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756397420; a=rsa-sha256;
	cv=none;
	b=2TdQtYp1RtdIi7C5qjJzrXCTFygUAaJevEQC05dlfzrP5GHDhWuwoECEHaVO7fxNRMU0El
	LdHBUmklYewCixttZMyguX3cLEdCEdwh7t43y/4O6RJ/yro48H12ERPbmaLY3qYtUSY43D
	Wfr/JTj22fJ4gZv1lhlqNewNt7+pzrs=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77053017462so919621b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756397419; x=1757002219; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRTOW2045DXQQ+GW8Xk5izAs9xkstSciGXpe/X4tnN4=;
        b=QMZP2H7ticRukdE5jOYS+R0U6G/97ohFash0gzufAaoA5sy6gVhc3n38FV6e5ubtrv
         8VG3442i8WFGzEj8xUJhDEdQwgnUix6JbCiqM1KW82nqMv1NY5+92ecKDS1WtHu8y0sl
         qSgbyfMhG1wMA5z7ante5ozsLAkzfCVO9hb+Gn0FKX2e1v2zbTqQJhKuFwmi6kdnAhSB
         q8YGiUzMiqFkTwOzdI88cdMLkMgoymYyzugv/rVF4xO4r+j7Xc3RxBiyE0y1HBknLmP1
         rDNGO3BPNGMlbREhE4xLU02Q3pv9/HtxMzO+GE1OscuKVfW1t3omnqdZWpq1Ws9WokVY
         6UYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756397419; x=1757002219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRTOW2045DXQQ+GW8Xk5izAs9xkstSciGXpe/X4tnN4=;
        b=W3HiO/wOjJ6W5yNVZ/obKiCYmwP+mQbYRzF80tkVpUTtx6d6CUkB3fOqlEzpZB0VT3
         Thn4W2wnGYuohUBvs9YI4WS2vFCB81TsfcmQr7rYdkZC9R5uJmiW8duxsDc7N8bY18fM
         9ysW5Tjzq7c00BlEh/5TOXOs9d+ckoDq0uuxU8vG72i9EirijMvOGN5PphAP9V3A2jig
         4eUn8X0jFfOv1KCEwRaz9KU0mt6wOmSjKoIRO4hLQCngmO2XAwLDLPou9N3/E65lm75u
         DqovjPirATuXR8VQ8PsULwub5YJqIDGGs77iD9/8T1W/NGqigTWPBl8iH5DT7Tni7Aha
         qZSw==
X-Forwarded-Encrypted: i=1; AJvYcCXr/p3Uc4etDbAn2HH0W2+0mVg6IoxWEZWuvIgrHQuQwUjtMulfsDE9xxumSt4kWW0Fr9NQdtHW5g==@kvack.org
X-Gm-Message-State: AOJu0YxqaH2WI8zjl3QmANJ9Gel8mGUyGo7mh7bM24Kt2pyAzJ6inPkI
	z+fuga1v1BR3q1oawhC7hK+AMkB4eF80hPuR1Gl1uX+Czs2GX2mySp1q
X-Gm-Gg: ASbGncs+NFgi20daOs7KtzR0cekSdwVNbIkmLMpNkRTJ91Avz9Y5Amw4JEXGHXMidAC
	BPJxIR2qsgCUeauYOg/kzQ9INgYG4yPHJOJLpT6ytGJOmhBc7mC3Ly4L47cYI4dn9GyV97lskUR
	5kB1Jrq1DzAgR/p+zYRWuNhmlz0xYzHLOmJJe1oNLL7vmZAM4NcMpkijdlnvKVgrPePw9mQ5JjW
	hsvfIsCF7avYyK7+ihkBaKml0kFxWDN26CbsvnlhnbesXk/hxPJ72n8Am/BJVlGQ15JRTAwgel4
	VycSd+KxP82jjj2X2GwFEk7joTWldPd59D7z20H1XTWin2T8VfiwxWItapWS7DeBLb7VEenMlay
	k4ImMrwyY+ay3VC0uoFUMW9OuHvD+T1ayGwuCSVLAoYMH0bb2LUQHuA==
X-Google-Smtp-Source: AGHT+IGQ8xaVEq/0IKPq/hc5a9wL5srxZCFhCWzt7RsSEaXP9yO+1p1Sd5ZE9XcNBfx7e810X1mGrw==
X-Received: by 2002:a05:6300:8b0f:b0:243:78a:8299 with SMTP id adf61e73a8af0-24340e068d0mr32039211637.50.1756397418589;
        Thu, 28 Aug 2025 09:10:18 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbbbd1absm14421652a12.52.2025.08.28.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:10:17 -0700 (PDT)
Date: Thu, 28 Aug 2025 09:10:15 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pagevec.h: add `const` to pointer parameters of
 getter functions
Message-ID: <aLB_Z3dv8dBYt-7V@fedora>
References: <20250828130311.772993-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828130311.772993-1-max.kellermann@ionos.com>
X-Rspamd-Queue-Id: 1DAA4180010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bssoaemxnnusyweibr5girxxxxa7ajmg
X-HE-Tag: 1756397419-681195
X-HE-Meta: U2FsdGVkX1/tz+OE4lijAkUeoMxvAgHGQcA6BYbiJgo0v36FAG36E5udT9XbjuW3qtK3rxUUnL02qU6OTu3NV51XJk/D6fr/qQtLLSto7sHuThKqrLUuQ7wPqAv+geR+G3MeZL60XTW9LNpR+a+c3g0C9p0qIOU3ZiTLTlny7iF4oN4I1EXa2eYcRHCLCJDOCN/8WYBq4hElVYvQuRanfJ5BVQFm9mxQBNmUAARQsR3NqGyEgF+91ElYlpwKsDZtwk1OyrlARBIj8zinaYaDXLCpMNnRsyZarZZ//PTu15gAsDA1GGEHw7bbc5iC34FPgwpARwGwVB1oOm98ax29u1srJq2f+Y79iyNbhI0yUBg8ErcsaXD8ZfiOU0wXJnQ1acsxM9zK1uOUn/hc3WAza3xBbNJQvCFinEJQ5BluoJVvY00Cn7pXTMjzJfLOFg35gKbpo7ANqQ9U7noPLRgtdh+Gp8E4aRtxqs2DHtXdrp16ps13Jw5eE+FnOBJXixnM/gaqDAC8jFn7N5emlzLyOAoAzAbgbgw8L6RNsmvD4uPIMpNN4D3IkGB2uy/7uKUZ5UOngww3bh8q/iX0/E6cO7EDWJiaXuhds729q+DhjBK2pgmAlYmxoBBw4QSr8MJtcaG+tHq8fjBsBU+S6FZL9/bQ2VcS1g/vFWseRDPNeOwKz+TIq1p5R1wVXNa1b5nv05WHkpysA7FSskt9kmh2EuYMgF9EufnXx60Ez0RO6Qs+R/OeuhDaX1oZg5ocFYmip0GWvnDXdWYRc4ZIPQl5OMbdUowD1vhGZr1eGJZzsfrVDp5s3CAvJJzkRYIBr/5R/Mxnlr7nDpIeWD1rXAE+tsy0WSCLUQkGYiRtl6mB4v4hu5z5PlOxuyKUif5TbHuSLLWRJbD1Sb5JXZOu3Q4HUM+qnDfMYhcVwisUF7O9SkMTAWUNH3i0gKu9YFoFy8eCl3kGXxSdK644GQRFxVO
 jO+bVxmY
 70Tjbzy86SSLRmnou/ELMC70RJTf9rm7PtoUU5VsPHTcvGSJ9lZeCAuCsfl9kT5/z2lxZI30U+qf4zsBEQN328TS4kfI3Cmq4LgUijv5/yq/LSP90LfHLwcMVOJCsXV/SCIAkxOAEFeOuR8ZKQhwcUkB032fIuGmgYhtUqhjCIQPccqHr2OokRTTLYMBRgd1mE1sPLYbTGEn+mXJ1MfQ2sCAW2d+lFfnAp3gdpkNHnXL+EHWFLurxII0XrzY/jElXT0ha2RMIJrGlsBn2N+PuwGzqCJx3EiTltvfNCrnUZf3ymIwmeWzVI8NEfb0ftO5fo8tDFyCVl+9D5GnLZht8J+GIy0YbuOt9L5irP4Mj9+k+VahCLsvA4CanrKO2NCa5k9q0bjPpLW7yDnI7boRTHClSAwIui4+c6edYkvVK2o3ddOPUiSwfB452bE9X88xdi5sz/ZU6m0u/k3qRZXf9NVfyupsED6PYe3yd1Lkwg/3OEgqPwervimBbnvxtoHOqI4c6WleVtlrsQehm/CHWp3AhRr7Zs+nEmuyy9wj5S5QG7vlb/hAKnG+lrXetGkl7t/lM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:03:11PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

