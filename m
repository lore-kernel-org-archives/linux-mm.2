Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42025ECD6F5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840746B0005; Wed, 11 Feb 2026 19:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE906B0089; Wed, 11 Feb 2026 19:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA126B008A; Wed, 11 Feb 2026 19:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3CE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:05:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E84831605A5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:05:15 +0000 (UTC)
X-FDA: 84433859790.13.5A025A5
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F4852000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:05:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=NDmzMxRE;
	spf=pass (imf03.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770854714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siJFkShMeRO/dlNNvrwm/OZWcDbbLEPcPmXy4ufPf3w=;
	b=Db6dGiwOcTTBCxBRe7sjcYTh1fCSfAm4/NTI3KTcXXTeOX6LdK7dx3HWA9GILISxFM9ILp
	+7BggPeljkok2lZokFH2IXF14+0hS5DBtNZTLkBxCYH7HDgL0NV1eSIV8zrIAoa7sRonwh
	j3uMpLH3hk7Spbfh5UVwIptWYJa+9Bo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=NDmzMxRE;
	spf=pass (imf03.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770854714; a=rsa-sha256;
	cv=none;
	b=hE7I2SPwkFP8Mnh+7f3hUhhl9RGKN4SsJduckmPW37QBv2poMCh5SC6R4FtMekGex9kfrc
	0BcmS/DOUUVUIG/65/bcJO652vYk1VIavsiHkXAuE1z4LLnOSvOJxEHUd/OtaqrnyAGfDc
	0rbtVbOeZaH5Hddt/Tg5TArkBj7A+rA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1770854712;
	bh=siJFkShMeRO/dlNNvrwm/OZWcDbbLEPcPmXy4ufPf3w=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=NDmzMxRE0y9KRST6kSnmwV5LHm46dF2VAgRUfQT5n2lVeIYMi6Vd7lmvobmSnWw+/
	 N1pktWDdRwAy+Vn6iqOd/KnY1qXw2k/UgPGuLm7V8Zn2u9mAzR+M/Wt5oNrqLA+TrL
	 oJnEgzo0IS4EY/h4V8eJCodepBgNWVMEkAc3CYLQ=
Received: by gentwo.org (Postfix, from userid 1003)
	id D28534028B; Wed, 11 Feb 2026 16:05:12 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id D13CB40159;
	Wed, 11 Feb 2026 16:05:12 -0800 (PST)
Date: Wed, 11 Feb 2026 16:05:12 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org, 
    Linux MM <linux-mm@kvack.org>, dennis@kernel.org, urezki@gmail.com, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Ryan Roberts <ryan.roberts@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
In-Reply-To: <aY0TaIpLNUJYuJZT@slm.duckdns.org>
Message-ID: <2b14dab9-4a7f-ffc7-5837-b31ee936cc82@gentwo.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com> <aY0Q7QhGDKwKk2ie@slm.duckdns.org> <c6ef0444-9423-4026-5a3f-123183246ddb@gentwo.org> <aY0TaIpLNUJYuJZT@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Stat-Signature: ztqwddsi3um96im4smw8qx45ynyheiqk
X-Rspamd-Queue-Id: 4F4852000D
X-Rspam-User: 
X-HE-Tag: 1770854714-565760
X-HE-Meta: U2FsdGVkX19oJtDkrX9Uh6DJZBTKmgpnwuV0nwlL9vtwc1WbuPDl5eQRRtKzzEf1hnJ3snt880UYtOmSKfaYYV9i7VyV9qXljPyj2lKiA6Im40h9kF68MSM4kUhU5xM1n4DRw1ew0HjXujhXB4UZuoT9Fv7nxFs3bMOjrBmJ/vzxPG1cFY2lGQ6+M+/pl7F3pCqLdNsp3Y5PnSSUqNlfPnUray6o6g6pULNUht8o0b8kPa+ITosxu9Lg45euIRDTNlbm5uHmX+3KVILwjm5kuZ61fYFy0X+tqhhlokdg+o9gINCuNQHrQ+rTGsSZUG6Kt2aw/f/fMkgDW2GthruRW9fL+b9jpQxyS7NDpUDYK9pdDc46Pe2qjYYOWWMnQM6k9t2gvVfktFF3PzSywlZoJ0SvMfkMoqY4viIMQGX1rSO/7DIHIIc5w/S29cTzNrem8Cvc/TFfkuf4iDQNhQbsL0eI+oK4WuEQoVYmVbQL8vP3TNgdvvZiQMmQTR+35nPWY5TbBZ3+YhiubMN9QzOdU8CrvfqCwTrNxW6n4WpRNCu9hsYGzOY2UWuGnOTyQ3WDs5H6ibvlpq05jTkruR+x7sg2RTmDA910GA2BM4kNWRJ29dMy7gl33HhNJUyADSP62klSaV89PKCfLUF7M8WQyPAzVfJ/TUo0F0h3aPhlNfBXvP6ygsf88dsYWkNdNjm9XS/BucEAMdRLBf2HbfCeHZ/i01jRfOzDfcYzMZbbjOCavsbPJ+7TkOUU96rvX4zkMrQ+LuV9CXQtFEFKBjeizrscwOj5kbR2DIeO4Uo+z8BpVZChMimTsOVm6cS+ITU6E8iGXdXZM/1q7NtpXj+IM6UFjtIiXOCvT1h+r9fYeViIVt6Cy+W1gklD8Sr4iOoT7vqXOcvkzzQpqXdpgKLC0jgvYOoAnec0KBGd9mBVmHZ2pXl8X+D0VeZ+Iig8/OcS4ezpaIpasav2A5OpW7h
 7l0wEIWn
 Azxr9ikt3JYKNOpk2GtedDiQOmWkIwCqJ2KdVlvoTJnPn6hFGx3YOstJZEKo2o800fj2qxzIV0uTW9aqOUziLPAHfjHfO33VGkg9594JhKKdKlPWwU/p47Quv9tYx3U5/7A+qGuigS7BYZNhW7cKfsWMQ+NhMfKbSAmOsmS/KFb5u0aaxzyHX+mA9UhpUSrprYffCEE3MI3W9VReAX+j+TdTsE6VeWNHotOXr9DopIll+RvWFT+4xJUyeQAVlRF5nnXFvDIehFfbtJ0bkFsU2WsB5VCycPOd6qhBYbe0+LTmjx5monQsFxkOHFiQjW68O4VKR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026, Tejun Heo wrote:

> Yeah, that's the current behavior.

There is no change to the existing API. Sorry if we gave that impression.


