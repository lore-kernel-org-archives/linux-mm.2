Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88109CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41E86B00AA; Fri, 29 May 2026 16:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB226B00AC; Fri, 29 May 2026 16:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1BF6B00AD; Fri, 29 May 2026 16:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A25B46B00AA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:29:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DFAD401A4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:29:59 +0000 (UTC)
X-FDA: 84821598918.28.182D5DE
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A3F1140003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:29:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NoMAy0jx;
	spf=pass (imf26.hostedemail.com: domain of dbgh9129@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=dbgh9129@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBAL2YVoeAsOB80jhdCnQFZpr0bN7/PSE/KDx/NE2YA=;
	b=wFHsKPcRrVyCYpsdWHtwqhhji2KMuxJ+b3DU9F6IxDl2hThzPcyn3bfhGDed50qUeMrkcw
	zWDBBp44ACeA9T1ECxgnWEP5w43xUnX/OYSPdJ+GKcfGoCf+eBXoWxFHLLYV+d35U0pPlE
	gLDAERrhs1TJVyuJ34iakEEoAArSgZM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NoMAy0jx;
	spf=pass (imf26.hostedemail.com: domain of dbgh9129@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=dbgh9129@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780086597; a=rsa-sha256;
	cv=pass;
	b=0I6R0nDOcpCJKk7uZ3gNYUw/DFuzzgZCVifhBlbTwY8M2grZQrBBrOghj8q4rjgkBGCxuX
	KAcF5VzeNds96syEG4/1fpTIYR+rjAOphjrB5cjjvad4Pfw0Y6v2STkez3P6VfLWtFuWMf
	LFt+UKiWZKlIhXTUKKrk/iuQlzlnkPo=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-68be16c61d1so2288791a12.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:29:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780086596; cv=none;
        d=google.com; s=arc-20240605;
        b=IFjm9pZ9Xm6THJTsIcfNkwhgo0PjCRqI6WCm2vtfIIT5+TSHvl/p06cLV8LmqK/oE1
         Yb8lhC/AG0Exi4ge0dAyNXM42H4nbBfQMUVDCKOA0Q43tVp8U5gc9kil5JjxpyYUic8z
         K1rkim5+keuPA6DuLL38XwYOSiNrrQYUCd9h2oAeW+FeU6vkm3m4yx8ki9NMX2gvAq8u
         7l2gGyKHeu75E0ugw16FDzDqqIrJvwl/tw/SROv5eqEx7weTs5C8K9DDjQOUvtFbbY7t
         zIyLU/MgiQzd0N2w/pcEEwH+JoX2rKKhZMSSR1pJaZ35oYLkcSh/CT0qnLI5EOZJ5Fdn
         tZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KBAL2YVoeAsOB80jhdCnQFZpr0bN7/PSE/KDx/NE2YA=;
        fh=ZvciK3VLAJQH9OOwBvHl1UllZme+HBaQyrZk4wJXuXg=;
        b=fBnuLzWl5pUXwQl4I+E2NtrY5kParcUhyEwBiIKP2LfJZMVscqIbISTPYVGhdk9kUz
         4wI9SGZ5AwyNaNyu8MDiy8tptembmMwttChkuw4yqLdgHERcefkgCw+an7dE9t5p6iKN
         mNWW/opMkjEl3zRHnzCam3piENrA0U7+cyAb2PDmg3WhgCvM9eEEbKFjX94vjCOS+xBo
         VnK4l8Upm8Qxky2/e5AMP6yOZu0ycYH0EN8kitniwavTzadAqfILzmTwGapHjLBXxIwM
         kxPHDD+ejSxmJHrq4B0EetBvq0q1wVIcuoXdgZuw6qyDFUM2wYifllFRxJDmZSf/oTc6
         mKTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086596; x=1780691396; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KBAL2YVoeAsOB80jhdCnQFZpr0bN7/PSE/KDx/NE2YA=;
        b=NoMAy0jxzHkmsLPGFKH7p0XjW1/lDMrRUqMWfzLoYb5XF8V6TBWJnp2PxQD2tKYACq
         /NgcDzZF2wJ0Ts9P6Yox9UwPgQ5ZPi+BJH31V8nLlgIMGZ7tlAXkFivNGBpnVfjxFEwV
         wt+pcEAbvm3HFTKHqRxZHv+UXGile0SpEqGi/2Ubg9cmm37RgEXkWrastX/PXzh5Zbvo
         p+R9uesXT/cuvdFNRxbqjvQL81ZE5v5TEWyNGiVvpItdiCdO8Gp1dsUZgGis5VSxHe2U
         sOis5l+yb30oy0EpYvDmSPXGfwZtOHAbtbb49EhEhNv6+BAw0GJi7JJJd+Vf64WsQ1M+
         D9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086596; x=1780691396;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBAL2YVoeAsOB80jhdCnQFZpr0bN7/PSE/KDx/NE2YA=;
        b=sQtXra1Vb+NLlTHECcS53D59XFnNrhP+18Wq9Uk5cIo0SwpllbVTCANitOrz5QltiV
         DIt8Y+Yu1+rao8sxMfxa5i4+QEhRF05UpXznW8BuAjZMlx6lMt72tLmGZTojcK6RyNme
         CsmVIElLVNn5xtBZTuSSnKKIRHaHzyyCzxvsFpjwkCsA4sfWqnDPaPMj8k/U1w+0EcWL
         gU2+s7MtIBAVSM37UhRMjRXDpoza7o9QSk0Goe3Gm5BEt3zLwnMs0vY31IMPSdiRAszE
         OK4WOzk4J9CL4/GTuEBZoSgZj3LeTYuenXI9VixHBWxAxq+MBfxUTqtUQkfhtpUWM/dX
         8mtw==
X-Forwarded-Encrypted: i=1; AFNElJ+ExpEN68p1TPIBH9EFQLco6QKIy7cDNTE6OuQSQYKmgIkp51EHc4HBcGrK1gVjJp0K9d8u4Za8UA==@kvack.org
X-Gm-Message-State: AOJu0YxsWTndmL0pD14h9DOY+P4TVCJNzkiT3/vkEuCCw1EFSVKUE1V5
	f4XxfaQtcCCrn0uLkT8sP+852BQ/ux5xyY2fs/3LNd3Kg7iSk/6SdQ6uy2Hb6q5j2+SFDKUFWyA
	HuTsWaBkg5Sp+lw8Tw2iUiH6y4Lm8iAk=
X-Gm-Gg: Acq92OFBo/PQHuLfupHniFjKoIJGeT9oJ2UsR6BZ7kNcKgv5MvQEmXR2ZiVeI0D4dqi
	pW2DihQfFmFlM9gj7qAq25R6m2hPG7mdB2zNFo5tsxc332AbQrOAf74ghMJRIoYbn0nAldcexaE
	0EW+CsU3AkbLjAfOnQhssSQZ+eWutJfe42pOdrIq7hcehqwJu60cajOgQiMRkiO8cvOVErcAJbH
	afzWu3yvjDnThtTqAIRdf2fvJcCHxxeyQnR4bwnQ+FNbjn2q5gS3+XaW+fKOSAM+LYkkn5iMmEm
	rHSGLZ20PoQ2I991Uuo=
X-Received: by 2002:a17:906:ef02:b0:bdc:55dc:dd85 with SMTP id
 a640c23a62f3a-beab4f1fc2bmr62775066b.28.1780086595591; Fri, 29 May 2026
 13:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <CACrCO_XCxTDk7b8wo66CrxzfOXG50-uCxdE9tjJppH_ei5Wo+A@mail.gmail.com>
 <20260529160030.85303-1-sj@kernel.org>
In-Reply-To: <20260529160030.85303-1-sj@kernel.org>
From: =?UTF-8?B?7LWc7Jyg7Zi4?= <dbgh9129@gmail.com>
Date: Fri, 29 May 2026 16:29:44 -0400
X-Gm-Features: AVHnY4K69zftCKA-7FXWI8bWbXBL2Ryf49rMdHcUkPQJ7C34OBdd6g5bxd0ugg4
Message-ID: <CACrCO_Xend-ivqq6TZ3GDhfTm-JsyoYJQjgNa5pdeU+5sFwKrg@mail.gmail.com>
Subject: Re: [PATCH v1] mm/damon/stat: roll back context on damon_call() failure
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A3F1140003
X-Stat-Signature: 5uhgh6zcn91j4eyyqp3ieyn7chajer35
X-HE-Tag: 1780086597-748596
X-HE-Meta: U2FsdGVkX18pgfZZP6v1M1+Zj4bS2Jm1wc325SnNlbPyqOumlpG/P86dVrSFlrIsXtPe4+qAh6N98ew381tbLtnySZeD//lMMEue/68u01v/5wJhP0tknTxMiqToxA+szgNW1z1IRl8kUCHhqpFvdtvuJFApV4UVCa24PDDLkgqOXEUwK/Pg2dcKbqiRlllhLVX+SAuhEOUFD7mgtL+u/YlZq3f6iX2278TXEBjiVIZzYNAiQF93qBUBISM0YbN9+KRFe8zGZUoEnlAjdXJPY5miYunlBGpoP1qRpN0L/JDZpVonQN5U4Nmyko5aoUMW1+TvU7xiFOqcyk1Huv56WhMJVHzIAZRl2BWNc9c2R58GSjR1Wp1bxw/TB+PNcbP6ZDY8BnKUbV4h6GDA7fJ9HCaK0c/UgDcDp7SSaA2PkgORXXZ/ouXRyQLBx+FwrDA6goIacT+vmkbWFfOsoJa9aASafRjOWNbSryb9tekGObdguzBcF9ZCojxXTb7bND0h+B1ojNO3Xv5PPKC7odhlbbM+c7ut6j4AkjEdfMac6B011ImrWfelvEj9Sg8Tw8jkXhoPIsfKAIxK2U0EXVXC+ZKgfAqYRFMg/5EGRYgqP7bNhgrLVOqdgjK9cZIL9aXKa+oizfK0buqNx1BUdUpTFzsZWZXfKL+9Zq5hhLeNGLeGcvp1CuTYnhen4PXvNY8x1FxRJG4c/Fh+9dqNkioF5YjYU0zb+iVUs7zI6EnvN3ynur3rSP4N0qzpShJ3ZgoAY/V/0LQ+rHIcmpoX+pVn0QnS4OUQEC+r4l+6ScZcyXLbA8v/6etSSLeJC+AJLGYzUNW1rRlBzzbpAnzJfQPROROfVBW6nu7libhUM/OV0noTCFDUIu66E5eexn6psg+1M90fssTp1jTdrzrzi0j/7M8oNXVUPK4ltREY19lPWDg2ssi2owgxroQw4lvhm4rvjo/y7hfrKv1IVNTOdzI
 dk7iTkL5
 Q8Uhq0fkHEG0JAr2u63pa2wb+yilY2z8+m3Yj+xwpinGuqWNEYLEg3B8XkhdaEzr06oAqEYD+z8r5z6ciwLYFpaNor+WAGDBgtZJsQp0PaSygFcCuu+a6RE7oPCVvtKm+8SsB9XT+WtW80my+TeTpHRBpg1JSujKGdYmMBvSYb6NurqOLb0qpod0fPN3kKOCaTiQ1nQY69B7P3TIehffqTZobKxWuFbPd7IgEuTw+T48l05itUjtMzhvo4tUqLdMo9tScS/cDVtVlbz0nJ+3WMLFBGprNHGknxpBPYv4c1C++8j7C+FzRlKEZIe1yc1Ybkk+lsesd2w6Vf/rYc6u49i/eFvhmHRY7ye3GArgk9JWPbzhQlkZvKr5qdpmoJ3cYPG9dYEBQBzaAT4LujOFgopobIu3deWmkuVJU8c8XdRNxfEVak6CA0pFIvFT6XOxYKPJvYHej9hy17HMNZJ/sYrRXcZaSctW1j8BwIlD/mGWYavBAxEcv9GTgpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 at 12:00, SeongJae Park <sj@kernel.org> wrote:

> Thank you for clarifying, Yuho.  I think the current cleanup is ok, but I
> understand it is confusing to read.  Apparently that confused you at least, and
> that's not ok.  What about adding a comment explaining the context?

Thank you for the explanation.

That makes sense. Looking again, I noticed the same retry-time cleanup
pattern is also used in lru_sort.c and reclaim.c, so the behavior
seems intentional.

I'll send v2 patch adding a comment explaining deferred cleanup and
retry-time handling.

Best,
Yuho

