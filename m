Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A1EC982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 13:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6998B6B0088; Sun, 20 Sep 2026 09:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A446B008A; Sun, 20 Sep 2026 09:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538C56B008C; Sun, 20 Sep 2026 09:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2D86B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:13:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3FD8A5E38
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:13:06 +0000 (UTC)
X-FDA: 85234181172.21.E4ADF9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 254ED40007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:13:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrzDEdbi;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789909985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5ELjAIpHRlkJUa+hT8eIBelfH7GALLeX3V3acfUJV8=;
	b=FIRLjbM8HYhWEMqnSfQvKp4i/tFOQ98tFtIsz74UqP4ZSnMVKnxkbnbaziXrZNIzEzQBUN
	cBEndlQczVGtVxoyJj9C9bMgmYU8J303Uuh1yxlYDQPPEsajtmK/ZWc3s/Ozs8wkCGkyM5
	MAWtAb+4enFYvqDEYIlttAmGQo/9MH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789909985;
	b=xkPufw7n3gaQejZyTOTT2+IvtAMy8WPlxAF6hTUd2dXj6GH9Fa2XB9Caucltlu7zBIWdgH
	rufeEGlJUfyIYdWC2470TFeYI8IE2ETotx+zShkYie732OD53y4qGzVZsPkiOJDBJCGvRU
	QMoiiwlYK0BNfHzeRPpftfcRtJTlG+o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrzDEdbi;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62AAD601FD;
	Sun, 20 Sep 2026 13:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8301F000FF;
	Sun, 20 Sep 2026 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789909984;
	bh=r5ELjAIpHRlkJUa+hT8eIBelfH7GALLeX3V3acfUJV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrzDEdbiJrUZQu4+qtloEJwle/dju3mnN+1+3mgPOxiGZGJlvJtg99A5W5ZFI8iTc
	 4+opUMM/1qODOwkO1h6WOh016hXxSC4u1q7B7CJeq5ImGW7Utc3riH/cno7TgS1Tup
	 3ds8NZqrrU6QT5RQM5evslOcki8VeDW+zBf791Xh1DjNhFjt9wsrfAw9ou8QY6N2ud
	 xrLv9Wuj8DSWslkGGuTdAOLAyMUPJji4Zvz4HMthGNQZK81iPV/3lAEgwmG/BpA5YN
	 9+6S4523eJKMYQ+7XUw9WQjzg7vfbzZuPCf0FEW28aoHAlliZGbbuZ5DGVBGMbhukL
	 BfMotXd26bfsg==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon/api: remove unused NR_DAMOS_* enumerators
Date: Sun, 20 Sep 2026 06:12:59 -0700
Message-ID: <20260920131300.48929-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e0c63f91-4d33-469e-a584-f97fdf8c3cc5@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 254ED40007
X-Stat-Signature: zpxmseu6dyij5hd7n1fxmgrmeto6bouz
X-Rspam-User: 
X-HE-Tag: 1789909985-379780
X-HE-Meta: U2FsdGVkX18mYMSOptewS9YDyDbLp7XG7DkXnkX8RUDAZeBd55a+mm5cKwc1vFy0C1GTMvZKxtwlIKu0NA5dIH0plvPCL26njvs44Xv/Kxo6VPmZGFrDc7E2oP/b1RlTHYDLU0l+/4zmESWSi30H+n9bco82wTHaaQ5WALy/vNiwMglN6YgFUCkfy0k3PRtaTmjEKLO7zL1AmMwqmmlycDHcWfW/md7U5gelhk7bbNO56PPvxu2XqD8MZAiNqotNOGfhaBud9l371+SAgY+u76l0NtS0RvZOaZfNLapB9CnqlGTumEzR8muZhoXhhau69nfegyFk2J7GQWkPrTrTWSYw5SZR+uQOqMSfpPGbqCktodK+Ma2OHYNzTc5+AconOWpi47JuA5fLVzyHFFa2HsOeP+xZJGY0I875eT5rgURrQ3WobBkQvk8/ojslmpI0CYW3a1N53AKqiKcpoIs5QEu3NfbP/xxUmRrit5C6GUYTlX1XQEbCr9Gb8F1yc8h15zIauG/pX3t6GBu0F7f73D85qU+P0mqvoplHXMoPjBbD/GkMnge+h9FGM1KAcesHf4c5TihTrtUFs73kAyGgrUff1ls8VowbcU8xNQwp85pBlk0nG11nbuaEtSfbCleLWIimupLqk+vRb3Y9EHY2q3CTaxJaqHg8xNfO9SfZsvtCBfBQGKkfg6WmVPmI+0tC+c3dqYenrE9a95HZgnSQv8zJE0GJRkibOPL4oVjzQ4j8SYx+Bgse3UViJyZx/NJuDJZLtiLLEeeqD01sM9Nv0p8OzYKyTapGJ06L8fu7nwcND98tS43dp9coBN2gp2FJ0OUteT2VYiiXDgEjZv/2f2wwzEvRB/ttgD928j09zBnKaLl/MzAsYfuMP+B0F4i/evftP8ULks9Z8X+PpS+LkVA5Y8RxqGaAoFuynnAu+OXh8woij9bqfRXBqudRtyakbHJM8B/pdDsRCM1ysEH
 wem7llep
 91yKSpMRVwl6e+OjH4nAn9Ty9tKWlC5JUn/R5pJY50cpAxBHF3Egr6INEjE8tEp1AUMZen3gqB7/lDnpu0X1ifkRE4NJ6X/TIGT1SMz8iuuNfe/vfHsqpDVGLs5riCycMttFtYPz315uSJDlJwurNQS5UrSp6/EmTC6uWE9vBZcE8OmpBc6vELZf5cYZ5kjCeqx5y4K64ZDGe+iRxksetrv4kiV96pbTm1GaEc+J5CSXen2E/+IbdYtGtiZaTLFIsrjlO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 20:34:48 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> On 9/20/26 6:00 PM, SJ Park wrote:
> > On Sun, 20 Sep 2026 09:20:28 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:
> > 
> > > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> > >
> > > NR_DAMOS_ACTIONS, NR_DAMOS_QUOTA_GOAL_METRICS, and NR_DAMOS_WMARK_METRICS
> > 
> > More than 72 columns.
> 
> I learnt from submitting-patches.rst that
> 
>   - The body of the explanation, line wrapped at 75 columns, which will
>     be copied to the permanent changelog to describe this patch.
> 
> But I'm also fine with the 72 columns rule for damon patches (or for mm
> patches?).

Ah, thank you for pointing that.  Let's use 75 columns.


Thanks,
SJ

[...]

