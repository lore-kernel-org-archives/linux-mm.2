Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90796C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 08:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3736B0005; Sun, 28 Jun 2026 04:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DD06B0088; Sun, 28 Jun 2026 04:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1277C6B008A; Sun, 28 Jun 2026 04:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE0C06B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:55:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 58C3B1A0354
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:55:42 +0000 (UTC)
X-FDA: 84928713324.25.7159563
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 858E8140004
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:55:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jkj6R9MH;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782636940;
	b=nlLks6Kjc5Ezp3OnoXIW1Es1OYwK77FExVA+R6v/yItYQZUJihcUrPHLdYNYl64hJqgaZT
	XcWxOA5nfPKCV0Epz4H5D+de8aQGkUkWHBhajRRKnkyEruj4HcI3TASp4mS8nwra4C3+A0
	dYINuTXjED6rZGAUWv4xIdfaMb4daX0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782636940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kj9dKjaq6O76EU+7+B1OfYt4Z5rjztB12sJ5obaAAZE=;
	b=ro9B4f36R1NDtieLnmcDLKqXod2X8zP1+lQBwVvwJ2SK+Oda4C4LLOGKOihWS5Do9Dq+Cy
	vNjhGoWj1/hv17+URyfKEllGRb25/qXgdud1W1nHwbmy6p9EXVA1QCHuy/77oWjNAkCiXA
	YMxBqWLfy5u/Hcyiq1ayoRt16YDJxHo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jkj6R9MH;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c9c9916f75so2531165ad.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 01:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782636939; x=1783241739; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kj9dKjaq6O76EU+7+B1OfYt4Z5rjztB12sJ5obaAAZE=;
        b=jkj6R9MHuos59tmz/5p66kAqKKAcWX5dBCxO/hT9OULQy2cgIYTUvqQj3744nc7EWq
         9pJ38bom386ouTqhtm3gErg8ZcKucCsznBNKbac/YJz6dF/ls9SyqpDN3tv4oZ8m9cfA
         /sDl1YfyAwJGccUuZrY4t1KUER1yvziJEkX4ROUNQSusIXZT5HuyWbAgZ0MXVwLIrPlw
         oG7HOXNSVq70Dygvqa5XLVpIYHsr2ie7KIGQhoYgDGsyA/b3K+1/yN5Yi/7CexLgIS4P
         AHGFApmMQPYODHo11BNPJE+U20DI2PB+kfFcLegJAfZu3aIlm22hI9tQrQM181cToYfw
         pe2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782636939; x=1783241739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kj9dKjaq6O76EU+7+B1OfYt4Z5rjztB12sJ5obaAAZE=;
        b=MGOKNT0aewK8NIM261Ux/NV5vptzLVr6TTH4zSZAgN1ftdhAjg1OsHYdmo53RvSRRm
         B1iHdoJyR/w+k7Gq1qDXAkzT5YA+8E+LlDlwiuwc/NOnPxa0TYabAilMJSGMRWqwKXnN
         539/IqEVhfcseA24xCJeB7JzF9Qi21M8zDUxoBxbO3dXJJquth0gWzWz1V/e15jBiirG
         SH7ENmmC7aSYc3MFqb8WbXTVkeLc0ZCw5beyOKG9tR/UKbaZnKzWD1CCqRIxYOwxr2Ri
         OaSDSFuE17Y1/ePPAu0X2OsmR04ZVogBGAEtT9ZB8QZytA7WFpInEl/VEV2pfBzihmu4
         FUJg==
X-Forwarded-Encrypted: i=1; AHgh+RqQKCbkLfmZJyqqbzihMlG7e7uvlsBk56IQukNmA3sG8fftEq8Rncs2JvDmyPozC0dl1eIzV7WoWQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1NjAq0p/bRAMeHPi7M30gLdmZSy3bxssH8FoAOWkM3mGvSZiG
	QvA7J0/kZh20j8LqkM6oaOMzEr7wW3ys14ug0B+J6FIEiXM78T45b7PA
X-Gm-Gg: AfdE7ckqEdC1Ynii+6qZhzT666oL5VkPGQFzJy6JqLT2ESOIqE30+lZ0LysveZWqAHo
	wjvUKOFvLQzpP0cX/OagEPcKFOX9AvUkKUUEMKZaVoE3pSrm9AEA5biCfj9DQtBUTLnBJdeLm6Y
	PzBKt/vNbnoJpeFgGOrhrR2GwqCg1I3VcAFz9o1+5ioV4I79LKCcNUw3+V6ZiE2yMSFNX22VSag
	81FA7bbpPL5lH/XAjQgzFi54AEoNLc4re3dsMJgRuqQjeNQrCPIUQPhKyR7lv6w62ubVzfJQPr2
	hj2Ux2XugLl8CfzUyjlUsLOiaSnl8CBkmYX3E7CaMnAiTHtAPNVfGtbSmAVFpN7TGu+ePbUYxy+
	aCeyh/OKtC86RpD+8j9PeXHeRusvvzVCUmFAZDlljJ2OYxUHWYvKM5R/IpOOzqOwoPfJgLMHhJ9
	VA6iSdY6lUkcBlwM1iVp7DRNxnVb/K6I0QmmlmXfmN
X-Received: by 2002:a17:902:ec90:b0:2c9:ceb9:8668 with SMTP id d9443c01a7336-2c9ceb98a66mr28705855ad.46.1782636939419;
        Sun, 28 Jun 2026 01:55:39 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9a5:e298:5467:317e:e807:794b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c9bd5a3acasm20072895ad.28.2026.06.28.01.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 01:55:38 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: add 'available' memory as an optional watermarks metric
Date: Sun, 28 Jun 2026 16:55:38 +0800
Message-ID: <20260628085547.21814-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260627222645.26834-1-sj@kernel.org>
References: <20260627222645.26834-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 858E8140004
X-Stat-Signature: eum6d1qqxfsehq39759a8hthan8nkngr
X-HE-Tag: 1782636940-462005
X-HE-Meta: U2FsdGVkX1/8K+bPBZMqXE0+bQlfiBCaPvcivQeF0WejCQ9DyyHffE83IWzE4WYjC2LlfLly0rMpjyOp2knl/b5Px1nBu5dgMk1Y59QNnU6BLMtHNzPsIJS2htRTeUjbe/Cl3jeAb6zootI3BSv3FnoDCseADXieBlbJpbCgt7PUOXlmbA76CeqpfQM+78d1RQhVdyY1za/FCEAF+dVokSTCPgmrw1q+36bP32IzJmVZW/Q8zNajUOb4Yvg89NimJ4Kk4kBjFVpgtoybjyF6fJbr7ZD6QRJ8duFb/uY0eMFebduMVscWsaEeNCSSQE27MLltYHstYfeP/9Nr762Hx/XRSjZLYCi5Jc+Plpjm/6lSV96Aa/ZXAUlbDOmbphMnLIs/hu/bjjw3g96TElMqJSvb4VKrSQvMVjM7dsOkfV0SzTr0M3brh21yiON3qRmNlzi+3Beiqn+7ovbzmSTVXPcoAdGFusy6GGvs9uS2K1CEHAvhqMzSeeXE5zt7qs88ZWYRt4d1Jk6hg4nkWutOADLb4NafCzy8zEOrv60eVuI9euFpsdJs8dRnYIJ6Tvh9XTAxzM7gLKRcelCG4953umo0qh8GQ679RtM99o6ZpifXgC6tfGbEGmpn+YMl3JcfRebKugSXjxG9qcY+YvQ3UYp9gX0j1ePjPbwMFYK8/JZ63RiGTdh+Dwe7cYljJCLj4PC83xyc5nGb9ZypMiM3if3MuSpmHL4BZsO+LY8TujkhOwJpY93jrJ/pQrSedIEATvfQik7TmJ52lLKRIyPPGXH7i+2rxZ4mfEQ1+esDW0b+EHu71h9BRz5lpfNphuYYEkbkkYsaiNP24I4Te11jgEZtw5kHVlYLGNsbjw2PnEH/nw5GlzIA6UxNxl9gtrTDHOUPYh043h/17jPzIQGleDKREedNNq79/aiHoBFT7S/fuAmutJA/ZQxB/B5VeWrbdOrG3Yey/Wk6znc07Vr
 UvRs2iwU
 xPKuO4nuPATQqlpE4QU7eOh0wWG6SbTUxI/MUgF3+xBV+4SgkZnnLaTEerYy5TN47b3AU++PmAg6zvzZZdhXNxmjYh37gShopJbdBId8OeC+I/uo5WpFCsdsS9T4zSoVRa/n6RYVFvNNuHJPV+G5b90QHad9kw6YFJOXv0ykAXJcPwUvmPkqCKQ6F5WYWJZ10EQlaOTkq6RILfWr2hUaRYUpHqff0NNneCwuLcHLHU0IP0fdMqpclROLgSCl0FCzqvgmZDB5S1lfYT/CHOxv2XZK7oKayt8vNihSX4YuU2z5BwfvccKqwe60f3avCtfrp74ny9njkwjvwySNJ4cJfKgUz6gjpgGS55sWkChKGxUZZidvs39qOH8DY89dsdkiXlMxzkt26Qa8OyGWA2KLqJakhKNqHYjzrGRgKYEevNzoXLKwAqR0QO28AKBtf1yqM07UyOsMqv5v9t1glrLREvAYN8npQctzn900U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Jun 2026 15:26:43 -0700 SJ Park <sj@kernel.org> wrote:

> > I will drop this patch. I think controlling DAMOS pause/rusume
> > separately might be better suited for execution in user space (such as
> > controlling‘quota_ms’ and ‘quota_sz’).
> 
> For explicit DAMOS-only pause/resume, you may also be interested in
> max_nr_snapshots [1] feature.

Thank you for the pointer to the 'max_nr_snapshots' feature!

> > 
> > By the way, I sent you an email about three weeks ago (Fri, 5 Jun 2026
> > 20:28:00 +0800) introducing a userspace auto-tuner program I wrote for
> > DAMON_RECLAIM's 'min_age', and asking for your thoughts. I am not sure
> > if it reached you, could you please check? I would really appreciate
> > your feedback on that as well.
> 
> I don't recall that mail.  Did you send that to damon@lists.linux.dev or other
> public mailing lists?  If so, could you share the message id or lore.kernel.org
> link of the mail?  If not, could you please resend?

I hadn't previously sent this to damon@lists.linux.dev or any public
mailing list.

Since I have completely rewritten it (the email) and it focuses on a
standalone userspace program/daemon, I have submitted it as a new
independent RFC thread [1] to avoid biasing this patch's topic.

> [1] https://lkml.kernel.org/r/20251216080128.42991-8-sj@kernel.org

[1] https://lore.kernel.org/damon/20260628085155.20828-1-aethernet65535@gmail.com

Best regards,
Rui Yan

