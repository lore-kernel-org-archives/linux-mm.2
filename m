Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9ACEA854C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8F76B0088; Sun,  8 Mar 2026 22:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496F86B0089; Sun,  8 Mar 2026 22:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378A46B008A; Sun,  8 Mar 2026 22:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25BE26B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:34:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6AF91C89E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:34:49 +0000 (UTC)
X-FDA: 84524956698.28.AEDB933
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB24810000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:34:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUubOeJ5;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773023688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rEBd1cs2oe7i2LMTBttxBgMKfH6i4xUsDVFq4wSxJlE=;
	b=brWP9j/b+wZgcVEVNSqrhpLdQOwCugraoVA7JpH0x8Ve3BLBpnX+S1GsgSgAI36e/EUztH
	B89t+KUB670N6xSPNB1l0xLzWVrj8lV8EG+t/+YA8JptYMXQ3sZicbv2TVggj+ZuULU1ur
	qpgsDjRsBsq1RiwqOw6J5pIGujSlmPc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUubOeJ5;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773023688; a=rsa-sha256;
	cv=none;
	b=3oP17amWVl8HXPwYl/djmkIh0w8WCVFVOYRR/ED3Qdn+IP6d/u8jaLVcUN/lBFCdpRXCOB
	dtVfGmdGCWiYWseVPLh7znKAmEXtnrb/4VP3cDCyO9KRHAPiKPSkB7pVv98Bj5vEwSqPqH
	gLWETGoFEGZlIa14Hx6Oj0yzZiTniuo=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so6636604eec.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 19:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773023687; x=1773628487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rEBd1cs2oe7i2LMTBttxBgMKfH6i4xUsDVFq4wSxJlE=;
        b=nUubOeJ53tVNdL6Y+kfmh56kBV7Tonlp/c/9iFV7965k9VV/q9y2cVaRAA9h5mUth7
         eenK2COGaffjH/i38nPFRLCp8NcnTSTnZqaDTLSOVNKQhZILaWFze9gKI58JDe0SQiNd
         QMXV/jkzpfgQ2Ewr5LZ550XJ7T4GJO4TOkBMoEaLG2H6hz44h3gX76CMJnZYQoB+ZDuO
         n/zCXnYQ5AQqG4tY0kIgCVwKg6KfRk3/82AY5sQEiCIdLvcbI9SzEMGoFyUEPV2SYIVA
         yKKczISkM7jWWfLP65fwjt5picZFBv/iSY+LOqDqkk9HysXEG4lTwtRRonNRmieNWO+h
         cpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773023687; x=1773628487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rEBd1cs2oe7i2LMTBttxBgMKfH6i4xUsDVFq4wSxJlE=;
        b=Wj2lZ9Bqvc5iOPeFnvWqY3E+LfHyBRksDQ64Bl/HllSEL3M65T0n1kqAIea3AYodei
         dZT91hFEie6X5fq6WymkLOpHZm2j1I9z0Su57sWoC2IpU+Xo2jB7myiDACrlsFHn8A8l
         WyhFYBw5tHKK0/RuZTHD1W85kbSwpbJxgpXZiIQwT4Di54JRCLZ7zD0dtOBSOtQHgPRq
         rljSEFCf9V8sZRQPJquFzGrJGQ/UwQJzPekUD8FrIFRSzgPCiGU6ZsKcm1RSptjf9q42
         qlGWHVTlHxFHahtNUFJMe0C2GWHw/dW0hkUcKs1ovm7sLhYnVZiSkhIAYJtANpgrIXXU
         QP/A==
X-Forwarded-Encrypted: i=1; AJvYcCW7+KjhuC+FQNPk+hM83EUuS6IkdzrQr7YA9pJ6XQa1U20Zs3wecLO6OdEW0Hq/pjGGcS49Iwj59g==@kvack.org
X-Gm-Message-State: AOJu0YwoMD2EZYqQ0xK5OaO5GXyRMUzz4GrZ8apcJKHcHN7lFTj/eV8T
	IbwPkVrhWbT0ahyGEXCpsYiHwgVzT8ORebHXmDhhz912O+sllf0E653x
X-Gm-Gg: ATEYQzxD6DhqEWN2FuWArPF2HS6Kfl101CaQWckqq58WOLjZ5DXBcK7dYq3TyONv7Es
	FkEgCDwxxQ9wiA43FPXQiax84WqvCOG3vZct8u0JwqnhnfcYg4RAeRcrH0TYWwycZcLlw2nRv8G
	HqhnVw8WN3Wuv0AbDXH+xEQqJdSZ0d/e3uQIwn5SySh1zfVI5e2mh9bVLcEGrjytErcf7TooNIS
	QI1qnOiMZF5zXODLxrNdk86PLFLX0er2u2atfWbRXCQBb9MYgeovXSHY0ZOb3pNaMj44zFvKbHD
	ydhHXyiMbk0F7cGG/RbtT8zsmyqMh3zO66cxJ/TluGotbdeYQPtfoqnD+IB59rPvE7dN79lzNWH
	DA+3Ws15oz0kmuPp/EYuuw0XBpCDih1uPg3iWHaqOKhdN8Kzevup1Dq+pmh5zjIF6dmIILEo+wp
	uCqDOHw2/aO5poGsi5j27AJsezaZfW+3JnZrs=
X-Received: by 2002:a05:7301:3d1a:b0:2be:fe8:8aff with SMTP id 5a478bee46e88-2be4e03b3ebmr4076299eec.18.1773023686622;
        Sun, 08 Mar 2026 19:34:46 -0700 (PDT)
Received: from localhost.localdomain ([104.28.165.128])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f80cc1dsm7076193eec.3.2026.03.08.19.34.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 08 Mar 2026 19:34:46 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	brendan.higgins@linux.dev,
	damon@lists.linux.dev,
	davidgow@google.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 2/7] mm/damon/tests/core-kunit: add a test for damon_is_last_region()
Date: Mon,  9 Mar 2026 10:34:06 +0800
Message-ID: <20260309023406.9784-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260307195356.203753-3-sj@kernel.org>
References: <20260307195356.203753-3-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB24810000E
X-Rspamd-Server: rspam07
X-Stat-Signature: hfcyue1mmemgygx4jbjm81y3rxkwpc1o
X-Rspam-User: 
X-HE-Tag: 1773023687-900019
X-HE-Meta: U2FsdGVkX1+gMcTgl2H49XRGMI4kp5U9vQhBsHRgaHQGYR2IDbZAC3i5zLmHUMZBP1+bixOEZuBgyfITZFB60aQGuv0T1NEntRyXQzNsIwJljcKiazvmPm18g2A9zgkda9gDklK4HFZsi1bODjdNG/zJni84UcIcwToWuNsYCQAOeTQnt1c+6hNfa8eq4aKDu/d5W5eCb1wjYgYONa70cPhbfcM/wEUYUM+Tv1DD8it6ghjotXHJSF8ILkxuGbffmhmGno8BbhWy4AtdTEuAHAX/2w6duJrPXnsZmlZkT0IqhVTsdh39fxJlxiMRZnImO7PufvPC5Dg2rJk9YRn7lc5PcIRz0R204RV4ZnsplUM3JJM/Wdo9AJmipLWoxZHnZO9GhDJo8OdlbfAM2mZ9fs52qoUUt7KAGOq+BBNsl9uTkrgvBfvixvPVHGzuHl5S8pPZ8cCFokNiU0XMuNMPOvYgtA6aN26z1BvlwqwJHqI4W1bgtkbAGll6QJqkYaGy/RVWpONCAFtMSuGsevEdW1kgYu18sKax1a/HD22dNDWl8zX6g9W/9WyJAdGBRjh9qdGUeOKg8ShTzR8xOxindPym7NYqEUoGE2YG2jhCPilxb6m9EseE82S8acB6TEt6n09hrGCIunubk79tezwPFRd8cFkTc/lbl1IwJxqeeqZbLlegKxilUXQYVscNtNHqVJfbz0F26A06DCcmf7+psUXkaVbuw6G+jv2jmMxOPh0mS5BZRga2LHCskVy6LfYH5d6oFQswS37+SDmjbG+Z/pwHWLu7t2fwyTvstN6fZ6ZiQtq943JP1jmNvJZI/2WmMEP6zblQ+7SXaDwbU00FMhjsPnBqmhRnyzziKOD9RA1eIcZBPzXw3N9RqhPpO45JVuYCauDSIV7Mg567ZE2Viy6qs0L2EmXwgQvpQvgMiPSTLDuU1gCeazawCjGl9TaA/MuiCXXZL5dOK0sw7qK
 uXwj+D3i
 W2qenljLKClAGqpcymYQwIgBl0GIRA1uGt6P7X0swWljIoR5X+kvIxZpYm4h7fnL/7Ly1Bno/y0ELofJutgqy7q3fYNeYaGk391E5FCpbd0C4ePi383hkK98lzZcXtVc72npa8BxyVK0RsY++PWTwgYOpOsKfbc58Rn6EMNozx5mvUWY3E2mj2mVaHT3GQ9037Ac+7FRzTLrhtEoPelG+2Xl7XvJzP1T2DIXUzi3s6/W8oasH2SgY5ZUKL6msCmFxbHavnMX1aaxP0hu663c5ivSxdsqC6oA90MLJZ9jFMvJLqyUUQCAClAvOokEIjIY7jDpKwByPTiwd6kHoltWuSKQTdjfWN8JH8ILOQpbjYbEfbNNcHQi5tqbQdWgN+hg0HTOw6uF839EPCWfjRsH2E5ek2xGGwBQz7FVMOomdtFLU4qgrUHqy3hUWWOKg2JQNeRgbXkZLECOBTS80pxbuhAjBI9LIOnMle475yPYrltq6WhX+uBGbF9MMclY6FANKg2cTL71ABZcovRD/lBfqAD94cXznkSDISi+ZChLMeBteu3cKXNb/87FHTfBwUl89GIw5wP1LopR6DgQLMpMOIhHotfItC9OkXSKHRvi+HJAKlReykU4u8Ks0Z3F8sm6ROtMUuQF6Q4JYbLeh73FgYz5A6oola9M6EYK4DAhHZ47Tzg5hPoyLQ8FZskE16XL0UHisfrLx7UE5k5pcvYLNc/2JWchST5Emdd/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> There was a bug [1] in damon_is_last_region().  Add a kunit test to not
> reintroduce the bug.

> [1] https://lore.kernel.org/20260114152049.99727-1-sj@kernel.org/

> Signed-off-by: SeongJae Park <sj@kernel.org>

Hi SeongJae,

I've been following the previous discussion regarding the bug in
damon_is_last_region() where the arguments of list_is_last() were
accidentally swapped.

I have verified this patch by running the KUnit tests on my arm64 native
environment. The damon_test_is_last_region test case passed as expected,
confirming that the fix is robust and the regression is effectively
prevented.

Tested-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
--
Best Regards,
wang lian

