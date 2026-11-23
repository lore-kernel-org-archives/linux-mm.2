Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48893606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=enwqsQoT
Received: by kanga.kvack.org (Postfix)
	id 37DA76B05B3; Mon, 23 Nov 2026 06:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3555E6B05BA; Mon, 23 Nov 2026 06:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BCA6B05BB; Mon, 23 Nov 2026 06:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC97B6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:59:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75235140865
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:59:24 +0000 (UTC)
X-FDA: 85466238648.09.06C9456
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id AAC631C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:59:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=enwqsQoT;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435162;
	b=yuEE2qbXttIi9EGHE5f2vGFSgE/J0vyy08wmi/1aIu4aUu/rz3c4xZJh9IPLIXcN4FZ+mN
	PZfNxLjQ2uSmXL4u/+IhQoovkORabWGu15b7JADSqTWvaGVLdQSzBo1CUFvnXPIG+u1gte
	ruIj9hLcOKBpDucHCC5E+GegAdsNv34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx+aTjtrDDJsLFUH267nfONNl9k9BgtNCWFCXNtAr/U=;
	b=BLyGvZVlwDC3yN7XvQqBiY2ckYhMJY/9EIImkctCJ0L1ffNnsIcNBeJ/bJJZZgKQHDu7cH
	Q5S3nSwlFHCTdBdQ3N2LVKgjakQTvEPKPMqf3Z9YsoVzMcCZkpQu01KUhBAQivTAYSQo+E
	GkLfzc7fovhCqT5aAqixg0OC4f6yr9U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=enwqsQoT;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-38644aedba1so4654895eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435161; x=1796039961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dx+aTjtrDDJsLFUH267nfONNl9k9BgtNCWFCXNtAr/U=;
        b=enwqsQoToDsQU9dlvV5Ug6+Q5lrZzA/M6nuV3aPAgmBdcvs3uLdKAwTn0UYU5QmP0r
         4RS8q0+qms3oKGYsUKz7r0tMOQyVszZspxTY2XVgO7Cg0p8Yy99xVaTVR+1BSI/PRheH
         eF1VIJZstoI0c36u+iCI3lrlfniZwdRT6DF03+8Cdrf9jMJs/b5r5ri4pb5Dvq4kS5Zq
         Uojd0Mdbf4zbbHvyldNLLKJyOPtzEo4NQkWjbhYwvmEsTOjles/BQr37Z4pyLRkFuBf6
         FBDbGMMJ2vmsgLYgy1JtCkQ7Tgk4u85ZHQNgBZfZUBMqc/NoFLr4hw+QUhZtne3WtZ+x
         +0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435161; x=1796039961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dx+aTjtrDDJsLFUH267nfONNl9k9BgtNCWFCXNtAr/U=;
        b=xMvWxdsKOhL10TcDK1EgLfNuToW2JtxE/+64/dirKHRzjX6TC9qIgsabcWjnesU6Tu
         4TUvQ81VyaGTK9IaoMM+etNpfdpWOytK2tExTduqGcI4d/w6MAPn+2PHl6oliNfBbKjm
         WlehsVyTFUooE+b3wa7wfHiLq4Q76f2q9anxWmdTcSKKpx8+XcvG7VCFjSrNsg2c/YOH
         vjjj1gx+M8Ib+T5RJ/1436D6sS8lCm6tMgFsGqa+oleU6zshs2bbfYQ2dBPvP8Yv5jOj
         dmijI61YCq++cKs6YUszy8v9MZ391RxaPFWX7RKB2/DyllF8YH3br4dVL993ExkTEAX0
         sfFA==
X-Forwarded-Encrypted: i=1; AL+hErFh/QA6yFfymF7Ii6UYRInBHIaSxmcGEDul76c5ocPEHbAVxSsYvCXtUCnLKD45AIvQMJveu/cFHw==@kvack.org
X-Gm-Message-State: APuU4Z+y7jCyrZzQAC2I/QiWDJ6gJ2hLFgCG3gcQbi115OFz4RtZmnPA
	O9BwYf/MFRs99MARB6WjcnI3GnybeRP7z+pClQ/VUhxzyx+RnO9LTT3pBLLS58ukcOY=
X-Gm-Gg: AZFdTZeMz5Jz6d90rAPa3oYpMYZFytu6V7hruiRxRyRO0myKJzEjIE9+JoAx6fHNrCk
	tqQ0IFPtTFSRGrtYqTHWYsiZyXqr0TtRwiWC3TC/J34lEM+HrTYNEdnCOd+DS/ncn5IE32o2w76
	ODGAe5u/4YRVyZKy6nl04x2IU37ZhSv2D4+DBAbHv19/iAjjLZa999RDvu+rk0Knn+WFKum3Zn3
	5HbNjHadkSWv43xky9fj/NNoeqia9KhRXpKtH6JI/X4ryE0nkF/RVKUIrk/I8IVeXXAy3xQrqeW
	aX8kt4eg4ExzV9jT4W5SdUFvQtxodZCry0KV/F6qr49qzBohwcTCMjLIfHdEcDgAKRTNOaOuXpt
	FLHHVQHwHD9gu3FbhGN+jSlgioRF6YV0KURw/y8q+m5TBAd8NNK+FOkk0/4D78XuxviorefIuzg
	Mg5QPQBFa3z+kvq+9MNP1fZ8Vy7bAsVr7MNPz35A9BtLGiV7JgH5ViyOl/we0d5v27XF76OjbJR
	wMwxrM1JSxKlmpm22oeEnSL0BtYdWRjcS+32/QsbzgdcATMhHHlBT8CtjydYRllxzN4JK9ZUt40
	9UrV2cOpzAA474kNKj6wbr3l/eBlvqvDroXVH/JLb7fdgNm4Q6quztrY3nClsomDNDOEY5dqdnt
	b8pMZbyc4laaKIQ==
X-Received: by 2002:a05:7300:ce93:b0:36c:a44c:1763 with SMTP id 5a478bee46e88-386bbfa6402mr19509eec.32.1795435161414;
        Mon, 23 Nov 2026 03:59:21 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385c6830815sm31590023eec.20.2026.11.23.03.59.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:59:21 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 11/27] Docs/ABI/damon: update for report producer sysfs files
Date: Mon, 23 Nov 2026 19:59:07 +0800
Message-ID: <20261123115913.9026-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-12-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-12-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: AAC631C0005
X-Stat-Signature: s8opboj8o49kar9x5w4k53gkx7qofy6u
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795435162-510447
X-HE-Meta: U2FsdGVkX1+ebtw7EqXgZcc8Llv7tisJQCibm9Gtwxko1TbMxRMRPjfJ0naJDSD15CU7ba2cQ9lOhAIHqnouQ9vOPX8OB59pCsq2dHpRooyiawGtUc7VJBFtiW6wuFAkTHn/imXlDvXBnMGWVjORlUV0QF5u9CjBgm2t6vqJeBQABTckct+0RJBaMs1XFDIyWW/5RUNA9Vxiwl/CLbGUJ46Qr6ieGlM79zoedevabLPBruae/okf4RiCARXenPjffF+l/CYec1Z/53pvkz+3YOBL9m+ve5WqRv1yNABPrDRlRhfP4I3H+DI/+AU/Sk8zi5mpzhbppKeTtH+fPuyUtx4iYdWEYcd4qiVKZisT6E9AW3IdHVUptnEuQIL5Pk7lE2ul7rZcWPMa8MmqbeNRk52uu3kOcNBIXa04/bd5apBb7XFlJe4Qh9ZOTogkcjtDbnwJGnukRa7+hdmfQ2J+9cGRhFPrKbwSLLBIW3dPNBROfA1oeK+xAJtqRUPrfzVmlxqIoH0vPQH71eZVDP6mhPSWjHyB+j1ocJYDaZuEG6O3TZl/lTyuypj5aPRYWvv+xGMvPONkn8b7c5Bxlk+GBRTZ+j1ke2JRuHpbmI023Cufel9nIbV0wmBPLAAYFW9mxh/ZJmnMkDwozIokaUPHkrMoEb6eDQBX2QhIsMq/nrRx//b5JIgBqnoiEoliDH7t44oxssgXmxMkCqF6WS1UZdxHRIQES8d5HCjpS0KBxSzXaMuqVG7tp40MQEZTdIEUYFjbaJyKRtC2HI0PSv/CAf8zZtz8hFWOEQrYkrDPoUNIDgRkrHk00WXsHVkKSvQNSoC/bqPKljUHYmAx+QFP/qHia2WmBGnG8PQ3R5Rte9rzghT/8vuboNkvzYtC8zsal0yA8ynThTWVmYMiq+qNuqyoZUfSWXlX5QkMBQWHEWUM0sLLowl5CiX5F4fHIsADy+1vu/Qthc2hRyPp1+p
 SsAQFTyr
 dlu2YrmliXc5/OyD0U7uV4ZAyymj7NEzjP5yYETksubR++Qvlqj9tEIXqKUex602XC2K9b0C7rE4fKFmaktMpeXUoZ+aa3El92g1Up9Bs/aPz3x2lJM1tLBCUXv3oCHwvMfNMMDGSTL/mqlkSRyAdnPqghJ9KQTDjjs30+R1sc2l9MpaDQYjnjyyFsaMiewfGuK3Qg6Kr7w85wqNRDyS+uf6gW67YHYUU5GFvf21x8uHRE1iIIQp0wCX9EUG6hjdrx+2i+rO8M+jvTOcWwVPZ5OMCoO1sRK0cNJH/ibv2TlBT8qeQv1/G7vf/ziNLzP//jVhNCYHoEI+iuS5ciSbSQjTKSDVLo9WTIIrJKCaqubFntOKYu9qvbAZHzQI2J1yDtxaT1G6B6Bzrm/Y8jQ3oERubNg4B4m41rcY4EGS0R3Z3BGC2RqX0pKwSwGfWgCZCwN6mbeD32idHkpZWO2NEEtWgiQx+rjOuMbvnklzbczPk0tBquCDv/2EiAr21NPxboe3k3YB4wVCambSyJdzTy5bjvZfri8J0ZG2rYpDlNapyApyHfolnbxRqzEdHB2Vano/DVj2ZTobO+q8JO/X+ynJ+C0m29ZKuguIqG671hnn7dW+b0bj+o2UmfU+MoxVmJ6GBKl0Ld56Y0UOvj6ExetCywxG1Je+SjYDq8EyarVr3IdrBT1mMDeyMIJmIHjcwu3EBcyz9Ds+KayNjXxxoYKev9tSRDg64W2Y1Ju49fS7w7r7O3TUGtHAntw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:55 -0800 SJ Park <sj@kernel.org> wrote:

> Update DAMON ABI document for the newly added data attribute report
> producer control sysfs files.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

