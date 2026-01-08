Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E50D1488F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113E16B0092; Wed,  7 Jan 2026 21:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1E06B0093; Wed,  7 Jan 2026 21:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7CD6B0095; Wed,  7 Jan 2026 21:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBA986B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:05:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 947221A0556
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:05:08 +0000 (UTC)
X-FDA: 84307153896.08.8C2D0D0
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id B734B4000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:05:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NfTN3U/a";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767837906; a=rsa-sha256;
	cv=none;
	b=1Isjtq5bkrAg1iyAA3gaCABir+fQ5h6RpmAaa2rO0EZoLyrP2rZD3jjg+/BC5HP4JEL8qa
	w7XMLFp5Y3FfPPEydGvyjjV1X09/5StsLFjQmNTxlCmiX5iJFP2mlr0RBOoehhLbr27EeT
	ifUufLInGP/3NMHgh/F17H663TcG0ek=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NfTN3U/a";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767837906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EiI4bUC7k1aPYBeEZacAnlQaKBQ93VS31it66ACRm4=;
	b=r0VvvLkyI7LErc/rVvPFjL6WwOQvomkIOEjTYiK4xUIn06jGixBWYMELnk8bYSbPS84ZBt
	9/tShHM0iDRqBS7nY22SWUIM0v5xZknEA/Hebt/Md4xGR9mkD4jIdILgtIgzVfnwq84DVM
	NFxyzUF1XRYafPzsNgc3ovBjGak0uP0=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-11dd2370722so4583744c88.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 18:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767837905; x=1768442705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EiI4bUC7k1aPYBeEZacAnlQaKBQ93VS31it66ACRm4=;
        b=NfTN3U/aN3pJMf/uYiS+qlAo1VR5R2PQMjgBUEN15rkcgjbSRJ2Y1vsqqXQAfoV+1o
         VQ5XJYoayhA+GnQvTmB9JQ6+y7nLbrR2Gnud3pyW9B5K35/+BX2jtacet+tAo/oqz7m4
         HBTamTwc2bj6cj1Lqic27oW0DVFuQRqr5VjO1DfhGrllO4vJVnLQc9n03kC25mOjznxl
         XdCYJlgbMrGpjDcOoQ5Ado6yFHtnaTBDZpNr3wDk03vc/5y7CG+ciSuNWmtXe/VBu6Ih
         yw4Fh9cGePx+Ns4tQ86YlhQTiI82MeY1KfnyPzcU+Ji7gTVe0F4jWvzBosUw8nHpNTir
         FG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767837905; x=1768442705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6EiI4bUC7k1aPYBeEZacAnlQaKBQ93VS31it66ACRm4=;
        b=A73kfnxJyrWCgE+LAubzLodX5xIZYP2ubaBJ253uaEAj1xO2k2ENUJNghh1YIx570y
         5985c0zf6kNzENZ+OUDKxXJAUsdI348tpUcRoKAQcIDvOnS/pmaMeqCxRxPEhuzaLok4
         9/3EbkMMAVxmGG0ecjqLaB5TmEFzu4O03ZQ2xqnIKu/A4V4VITJT71bXK8HAlGSOm7Wm
         oTaH7KEXyXYL66ZOsov03vKjXsGcckRDG0FNGvSPc037LPq4UG5hFVz+B3ZpAvgXEJJc
         8pGhijr4W99iT7c/WU0PjF+88qJGo/2xOnk4Y38KyvqqklUHd1UNLXnGNoUn7Unc29Br
         l6mg==
X-Forwarded-Encrypted: i=1; AJvYcCWGwwHtgqsefMdSbt5dsIlecv24vQa0aH0+CUi7nBUI2WxbyMYrtOmyCy/n2t7QHpgo5dA/YDVqUA==@kvack.org
X-Gm-Message-State: AOJu0Yy9THnAijl4ifjBgKeW3dsYLNJO/iHchLHvFAJSVVoQHl8o3kKv
	7BIggmpq0KDSzLyfZt9VPBSN3y7Dz5SdHLeNamJ7hla0u7Lm2pcDIJq2
X-Gm-Gg: AY/fxX6qhyssKkzR3eui9yaVJb4kLQpvcjgVv9KYkPzfzkGeUr80Z9TvCc4pl3MClTT
	5Ab7cjyMg2Y7B0FhrmzI0HfDITrCAdhRS2Vx16aGI8OVQtokapxBrer/F7H2jI7CD3GmOGIyRyD
	dy3kpmaciuR0I/wTErJGAuVwDpU0g1Geh/7IWm7Xw+CBqhrokethoapyXvrIOx67lALxm3rbvgL
	8Bz+GaQMiQnW4QlN3kfLc/2WtAFyf5f5UTA5UsHu5fnlTOaRu2plXvHgJLyYQtoYb3DSx/iK3s5
	gPJQAQ3Q+siZ83VYWKSMrvQhp2ZUfxw8fKKIDK0fjujAM9IWInXIJySJvvkN+UekwyfG+afLTA/
	IvqoRM1O/3s2v93HFO3ZTLstaUow8EUN7HBGWegvzQKI/msOnBiPQheShk8UCPcjWM2lb9Zgr0r
	Sd
X-Google-Smtp-Source: AGHT+IFPhAbvKwIitO1U7vmQaIFqARcl+mHpOZz4NyI4VsagyZi5EQYcTiGLUETDH8hR/OBFlDAyLg==
X-Received: by 2002:a05:7300:c7c5:b0:2b0:4c6c:9ff4 with SMTP id 5a478bee46e88-2b17d2e3395mr2610609eec.41.1767837905340;
        Wed, 07 Jan 2026 18:05:05 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b1706a53fbsm7955574eec.12.2026.01.07.18.05.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 18:05:05 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: kevin.brodsky@arm.com
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH v2 4/8] selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Thu,  8 Jan 2026 10:04:50 +0800
Message-ID: <20260108020450.44953-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107164842.3289559-5-kevin.brodsky@arm.com>
References: <20260107164842.3289559-5-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B734B4000E
X-Stat-Signature: txoamdp4rd4w4xnb96rg6enoweikhhhr
X-Rspam-User: 
X-HE-Tag: 1767837906-107319
X-HE-Meta: U2FsdGVkX1+YWO6v7q1SZSL8t47h9sHKESyJ1r9nLLfkFb7uB7xUJGbRNrcv0DWE2PQ0tGU3sWHQIcEs5BCuy2//puvRDEpqdDVnafj9SnQILXmXoTYfoS3nhr+hXkXvVXhjLDCq/H59Oxw4wO1jmk1aOxvtQ+zVe5AyfO0KykDtr8EMZNA04/QpdtEcU7m7x7e8MugM4yLi3fiVK0Lyr5onO5pfiCKp8EcJ1OwRZtCF7ZaGRtv9Ppb0rOrGgbsU+nEXmlxlJTQR57UGPATENlaLzfJWqlgizQM4y/aD6/6YwTHjzz/g4ocjLnekhtRcRoAx1fNYq3UL7TlJBwFZJjocYKyV0m9eKFdIi0BdIA1z5+pOPe5TftPwY11hniHx9hAzcJ7K6N2S8/9XkfP95qAKucd38py6kxG+rA4/wreEb1JpQzHw2htpNNg6/JVJFgxDbMQcqSVg+7isZq4ZS8M9l4nmZap0+Jy87lE9RyR1sz2pOB8H0MZrg4jmYl10GerRFOmyl6/HhtklBIfe58xp6QAtwgZk41aQFkikk1uuouNwya3RpCL6o7cg46F6ORdG4DyN+ldVumc5gvMg53wRu4HtZ5Yo2TzblAI7GhrAwtyr5AXBLy9v7tezEsPy/BshrhXXXW43AGUCtaAluGO1XGp9y/qXksxF+Dl60dxqBxqinVKbLiMWEBlzaO3YYlwSjg2lWwmdUb5b3TX1+nvSTYKHfR2Y41I4OUYNkTyGmvhLwxkJwD4R7p+dYH7K4LB+2MpxSjIY7cEWsdfsykriybyBY4EWivYxjU2J9VZntclmuD2wANXZVd98d51UHglkxvUIlsU3QXF+/wbztfbMFK8oQIjjQbPlUgo/7peSwQBVMOXuOLTp8a2Jq5A4YuucaiXtvdYm1GY1yOxFA+xCBGKQNRds/9y8bKXy/k4tZJvQmEbjcTbh/0lmpTmEnxtJPc6slpHLrTawLWf
 ZJ3jBP24
 KCHIKK2CWnYDP1oJei9055lSB7gWzPHiipYDvqvvL6iX0aC7hFxqXJp1nzjWKLhUZmHCZtpoNxp2SN64kA3mLo6QpPVwjsXk85eLT94pI1cc4kC3Al/ZrCxjaZHHkZVY+tMmGkNu/rHmLAe2+7Co9CfIBkPwwSi3mxz1Buzeh3ovmL+o2Fx4x9qaMiuEXadKRaqo4QIbVktaTuJbM8PskTkYi0E4M9947RYattJKR7MLa787blfSZ4Gwb5RohRL5HVV3DueYMMzkMlgX3pfdkSbGc/J8IVrivc2mZEpSoh+WSe3FtbZ7D6BtmeyBNJYUFPvhANxijmsFWs6WNgjrTDQS/DWeajVAd2fAi03KwI6HFFyP74/t9eDy6V2fyLwckdJai9j0SyEcml6mUS1gl4Ggy5ZXvzYA8lo0PT/zo2eTTevt1d3hGIg992tJWpI4sg/FgAH8uWiFxP+1nnmjHr38nCxWL8aSB/pFxILH9I7vViiafrGWDkgyFf+LUN6Or6QVx3ZGEFWVZPagLgZ0AGS68IlEguNG5ep0yzQ5qyxlue/EbpYMoGXQq+o7qc2Ymc00Dkl9my+NcN8qdP06VMpnnun2wtb5gw5onRYW6mtmkUMlMX6zp+wnSgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
> value correctly") modified FORCE_READ() to take a value instead of a
> pointer. It also changed most of the call sites accordingly, but
> missed many of them in cow.c. In those cases, we ended up with the
> pointer itself being read, not the memory it points to.
> 
> No failure occurred as a result, so it looks like the tests work
> just fine without faulting in. However, the huge_zeropage tests
> explicitly check that pages are populated, so those became skipped.
> 
> Convert all the remaining FORCE_READ() to fault in the mapped page,
> as was originally intended. This allows the huge_zeropage tests to
> run again (3 tests in total).
> 
> Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Hi Kevin,

Thanks for the fix.

This was indeed an oversight on my part. When we previously discussed this
refactoring with Ziyan and Lorenzo (and the community) regarding commit
3f6bfd4789a0 ("selftests/mm: reuse FORCE_READ to replace "asm volatile
("" : "+r" (XXX));""), the intention was to switch FORCE_READ to take a
value. I clearly missed updating these specific call sites in cow.c
during that transition.

Sorry for the trouble and the skipped tests. The changes look correct to
me.

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

