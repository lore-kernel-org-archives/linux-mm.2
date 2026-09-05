Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EBD7C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 00:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788F56B008C; Fri,  4 Sep 2026 20:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7143D6B0092; Fri,  4 Sep 2026 20:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601706B0095; Fri,  4 Sep 2026 20:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAC746B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:42:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 542AF160253
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:42:11 +0000 (UTC)
X-FDA: 85177856862.11.C2258F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5115C0008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:42:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQcIHMD1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788568929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eF4S+ZPs/VCCxYBSVA4Wx58SRLtX8X6GyNUKQVmFVg=;
	b=pDK2NxsnBA7rNtc2WbfcWlocOGByfaF0KYZl2XBW7yXT/DHvOaiewPjc3eN7pOYpM1Lpy6
	vauFm6Zjv/iRtUJWzn+H4U7uKVFwfQCvSfij8TUbMu4Lams7fNlovI9BirwzvlzFro8BFD
	ZSx/bU/IAx7uJYUrCZ82/Ss4bsfm8zE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQcIHMD1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788568929;
	b=I5rdKL9o8m5XidbYEUhxqXoIW3gZoG84QuCj4A6PDfvl4QwD6+tNQTwi0i3erpt+OJxN5K
	uqL1G7awNRv3k0g/8XGxJz0gDcu/pEwqVxM9GVw676/WA3ep4xYNCmVxYlyVqnpIY6lDyd
	kiPvvz5F6p+wVBPE57EODIDqyoLiT5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49930600C8;
	Sat,  5 Sep 2026 00:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03941F00A3D;
	Sat,  5 Sep 2026 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788568929;
	bh=9eF4S+ZPs/VCCxYBSVA4Wx58SRLtX8X6GyNUKQVmFVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQcIHMD1aBp4ulFfQKdE+uF0T9mjaEzAlHsavMR2WMj3uWS+Cdb1RVFelsupiyXNQ
	 uijncxtMoNcsGpCzYuZg7GIDlD0NUKseJu1RBnRuRp9IBFpilaF6HfhBvnNQI6/F0x
	 qu5583RjkRxwFJ517D3Qgy5KUNPttqlgqKV0M/y8o22siCEiOsPSJs8Lhld50X+3E+
	 QhBHvdO46wx+iI8bngbrHScMu5lzV+g/SUL7dMl2me0u7Y6v5+SE8MLYFre2iLU4TW
	 YlI9sGuG9JHaVKMr5O5HmWCw94PW4Bq5JtyFIuxnyaOXrzIVWQ5xte7uBORJhlrlTx
	 Jy109tERoYWKg==
From: SJ Park <sj@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] memcg: fix typo "memroy" in comment
Date: Fri,  4 Sep 2026 17:42:01 -0700
Message-ID: <20260905004202.68515-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904104254.16103-1-hemanth.selam@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 96x8bak1t64dpkgkh8y7a7tcfpod8gd1
X-Rspamd-Queue-Id: C5115C0008
X-HE-Tag: 1788568929-25839
X-HE-Meta: U2FsdGVkX1/UbvhBO4g07S2fp6P9UBjLKxUEhKAOEeRYNhPMv4b3SnS/+VIrJJPnKeK0wolvGiy+u6K/3Z+kLpNSTU3gUN1OeGTTN8VE2Xqq304Q1XLilBc3uVOq8pYd4D2LS0Z49fhbD3gr2t5GNUNUFJatXU5qj5f0iriMSS4nKEJA84ARfBiwDcBeC/BI2to9S4zTzoYXUjTerN1fgA5bLiSCkgqJ4qbnhBLGxrOhsf6y/eRcsvzfbN4bh8OSgP9romgPGVdzroWRkiNgRrBoq9B/qnSEqntNII2OLAnz1zYsns2hC9NnmzN8qSh+xYipmrY2YsmsvF0EpcKLIRxcIzIvNYtu337xim/7UKEV/7DUgqQbDaX2u5Ck34jdLlnWnUP4xvJ2J8Mf4idPkBK8mgoGkrCqZ8rRrGxC/60+C6EQElwrNdPKgXA6yEs4IbNzkcUVgBP9gzba5Dkox+oOYWWJ2PSBQnulst+DH92l3uLwqVzdq4tLd40ZdWyJdSSxuoNc0we7fJ3Use69OGYZ6dDT9BLtoucknFMqAAjYzCrxMmBbqBbsXQaFXo1Kt3TpawXO66QFjrVH51otVNUgpijW2B1pomce6GmND/9MfN55Dl1RaxwULFZN4ZqmP5aQssxfKJ1XwrA5y9kVaJRBSkhhwgKNSI9ki+EaNRV6r+y/Bbrk/ITaolp9vUIXczR9WUG6iBWJ9bjGqJOmKTayWgNBR+esoGoL3LgQmAsG75c40p6c7T7WJpIKq36qBzhMPxLkwpAs2CH4UJgU4U699KsDvrqKveUh6yndQGRXjg6NPcBIeS09/iehSZJXcsob33KbUgLZ2WsFWwOoqOJ23faKXeFVuvfQs89Toq7Spl6iQcG1Yx6GSFAqcInHw14UcmcsYdyzJ0UcMgJ7a5BI4YwoW53uLo0EZHNkfJS/eticsYCMKHbHEGSkVP2rmM7hMs1Q1HRB6iuZMiP
 uHwpQwFT
 0BbwEUfZy/CE828fqxAWcBI0ZOpj4gIL84+ekXGTIo7rx6Qf3Xk6we7P4WFcCucj7lG8qBjoAqrdVbzsuxT7A6lfi8oNgIThmVwt7CutFulp62K8wW7nFKp+zi8uEmWd90mtgP+w0nuM+sKKRMgcHg99SNM49cCrt0inC6lJL5Qu9sQBD+RveGKzhORwFYHbVOMubTyObKbKsgkSJP9fng337pkU38FpL2yZUzkTH/P3pGiu7M8vie8wsUDZykci9KI0CHG0UwAaDrTzabqmLRgVqGwBznOK6Lkjz/2eLm8qaUEcYpmPtBjlLmN6+fEep6v7pKgnKf0Ra1V8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:12:53 +0530 Hemanth Selam <hemanth.selam@gmail.com> wrote:

> Correct "memroy" to "memory", reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.

Looks like a correct typo fix to me.  Mentioning of spelling.txt looks
unnecessary to me, but that's trivial.

> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

