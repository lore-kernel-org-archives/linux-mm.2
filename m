Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C4310F9311
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4786B0088; Tue, 31 Mar 2026 20:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95776B0092; Tue, 31 Mar 2026 20:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB2E6B0095; Tue, 31 Mar 2026 20:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD59D6B0088
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:44:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53B61160542
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:44:05 +0000 (UTC)
X-FDA: 84608140050.07.B162E2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AC43240003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:44:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ah4YX0Hl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775004243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTu9pTeN9tgCk34dQ5SqKtihZud5BtL3bQyUkBB73G8=;
	b=RDNmezwIvqReLqxhaXyuow/7RGIpBcAqT1ccdLG02hAiFilAJgjzTe2mQ25a7Z561eNOvZ
	sTOYjnWweWytco7sG5SlR1TFJt8rYpsCmEAl08YfDrekDrygh5KywSuUTnB7Pte7vU5iR1
	PlvWnQuBoKebm9Pr3iCKbvDs4/GlZ0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775004243; a=rsa-sha256;
	cv=none;
	b=xc5qpPPfujJjUOg0gnBXP4w1c/lOSeruVZ6BOAH5zKG2Kcuh+CnJAbJ1nfweFOZrpRUGpR
	Qp/gbh0l7yAtQa/Aj7sjsAGq6QUlPHIXYlE8795FGBbWxMA3X4ljIdbiBRgTfUm1A8Wgd1
	Ulj51SCmXYSSlyx+xQqId4IS0DjRdMg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ah4YX0Hl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B748600AD;
	Wed,  1 Apr 2026 00:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AF0C19423;
	Wed,  1 Apr 2026 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775004242;
	bh=6HLg+daKemhcsyvc2Z8QkE7LSs10O0Nc3zdCGX7p03I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ah4YX0Hlwz87zByh7BTWO+SP42Q0S2SoarNUck4KRKIOVwokqWCiHjq+ZyiGSIXlS
	 8RFZaJcNlKmfjr+ESK3cP/8oGPB7CQ9zplKeCy6WiXQlP70AlqkdIY1r1ODyJQkJKU
	 /cRS72GB7WbIiHQguuGG/YRq5STNYIVALEzY3BSjrzaHYBe2Idle/ZW3mNnXWtm4Qq
	 QFxdjwCP/Hx0ZjQp12BSN9mYBQz1am1bxwbTXZbe22wbL+x99NDYA6Y2UGpp4XRalh
	 0XybcSOdSz/mGk9oBsXSZNTf1l+Q3JpIyS3B/8kX5TnAdLvlgS73zzbEs6/hnuxd6/
	 CPg6vuyAq8dYg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 17:44:00 -0700
Message-ID: <20260401004400.85613-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331160956.16312-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC43240003
X-Stat-Signature: arnjnxebeokdbaroyewkwqo1k4yajue7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775004243-788667
X-HE-Meta: U2FsdGVkX1+ZztS5Xc7lCNikx98kpf9Al5t71vOCSfcpUPg0tNlPQE5MNEjT8kk2w6N5vAgpUa+EVU2MJXaEeRaFogqql/ZIfdEJHpAQfocK3pICxmaXJnErOyzFTgjlNcpvSaz1dok01pNQO254e5txflskCVmNfOTEMX7HbrcPRjxQRin5SOeef4myeUmB+Eohf/oRvZAyYUeW9f8LDp/KtuCMjVT1W0x0koJSXeWIoqmgo+BzrpZPJKznPNbzYteSduvrLQyOTUg7AwkBKIy3+LzLc+Dmn0rzkOO9VgSevyzVXf9/4Ewfbfm/nqi5L3B8XU1iqJXHitosV0dEl9aeI/X0LGnG2wuGVGN6HawkNC6sqKG9m7uXzEYZwXxun/wae3qpt+ZOtxcH1tHqlXgL/FbmL/ai74echd+tuevsntCvE6m/Ugd1j+Fzvag91jToPjeEmbs3WgsCqR3lRi/j3v3CR9BaYjbfMAVjtar4K7toIvFZZS3VmMcp2WZUpPmX6a5I9ugBeKkip7JTm+FWExOl1EYoGQEY8wkh4B/I2MN3yJryL2vxDXv+76QDHlKkSRy3WiUtEo1nD/5cEeCtE8ZWWr8JGwcHFDrXBEvzRiBkMVC6J41xgiQxDbgwzqQw4iNsUyKijHij/ZwEpcWi76Dpm5nrBuuLtGSr/t56krMa37h+m1U1LmZDCkBqJJ/+3fsiA44ot1SiqQXM84a43KGQJwTVEhfIx2KL3FnajuRS3O3qtItlF8EYqZR7KgscUXmgMzAhqj7L4ai/1x8ZioUDErmdC8R7eWbobzcJVTFBPIsE7EHnjd+hQ7A89E6N4EkOZKDDMBIwE7yForOSUjvy7Mi09omYUEj/5g5+bOt8uyFAhGYkO9EErJEEKJF222ntuUU2VoTyVgMIpYZaeTkvMJa6zpEKsediV001YAaB/TMPlz0Vt6hYxwd/frQi0i6I39kQEnjkOY8
 5H9tUK16
 j4NPvIULnLgh5RzHKkPs1cIZllfFnb8908KwTtJAJWcBFuKPhEcU5Glx7rPeORGXN+7SbTjrXj2Wmwk7J289I233hJoNeSq7SrhW6j49EFNZdxQtx0U7ryaW5ADNcSHxH1CdETrPeGEk27CahzE0j/T/zKYY2BmGzlJBcLdFzOj7GmG+CTlSPzRJxEtTcEMLd9vdi8mJhDhgN1ep+A0IyWkJgktlVoZq/fPf76f3PRmEsxmqSzl7SiUnsL8mQt/Pw6XjWETSkrruC+Lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 00:09:56 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Tue, 31 Mar 2026 14:58:36 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > [...]
> > Option 1: Introduce a generic termination callback
> > ==================================================
> > Add 'void *after_terminate_fn(void*)' and 'void *after_terminate_data'
> > to 'struct damon_ctx' or 'struct damon_operations'. While this extends
> > the Core API, it provides a clean notification mechanism. When kdamond
> > exits for any reason, the module can perform its own cleanup (e.g.,
> > resetting 'enabled' and 'kdamond_pid') within its own callback. This
> > keeps the core logic decoupled from module parameters.

Maybe this is the right long term direction.  But to my understanding the fix
should be backported to stable kernels.  Is that correct?  If so, I'd prefer
simple quick fix that can easily backported.

> > 
> > Option 2: On-demand state correction in the module
> > ==================================================
> > In damon_{lru_sort, reclaim}_enabled_store(), if damon_stop() fails, we
> > check is_kdamond_running(). If the kdamond is found to be terminated, we
> > forcibly reset 'enabled' and 'kdamond_pid'.

I think this can work, and simple.

> > 
> > My perspective
> > --------------
> > I personally prefer OPTION-1 because it ensures the sysfs state in
> > synchronized actively.
> > 
> > OPTION-2 is simpler and avoids API changes, but it's a "passive" fix
> > that only triggers when user atttempts a write operation. User might
> > still see inconsistent value until they try to interact with the module.

I agree your concern.

> > [...]
> 
> To avoid over-complicating the Core API (Option 1 or current approach),
> I've implemented a lightweight, on-demand synchronization mechanism in
> the module layer.
> 
> By overriding the '.get' operator of the 'enabled' parameter, we can
> detect if kdamond has terminated and reset the module-level state right
> before the user reads them.
> 
> Since sysfs parameter access is protected by 'kernel_param_lock', this
> approach is race-free and keeps the DAMON core decoupling intact.
> 
> Core Implementation:
> 
> 	if (enabled && !damon_is_running(ctx)) {
> 		enabled = false;
> 		kdamond_pid = -1;
> 	}
> 
> 	return param_get_bool(buffer, kp);
> 
> Test Log:
> 
>     # cd /sys/module/damon_lru_sort/parameters/
>     # echo Y > enabled 
>     # echo 3 > addr_unit 
>     # echo Y > commit_inputs 
>     # cat enabled 
>     N
>     # cat kdamond_pid 
>     -1
> 
> I think this approach is better than my previous OPTION-1 and OPTION-2.
> Does this looks good to you?

Looks not bad.  But, what if we read kdamond_pid before reading enabled?
Also, what if the user simply try writing N to enabled?  Wouldn't user still
see the partial-broken status?  So this doesn't seem gretly superior to the
option 2.

Based on your above reproducer, I understand this issue happens by the
damon_commit_ctx() failure.  If it is not wrong, can't we catch the
damon_commit_ctx() failure from the calling place and make appropriate updates?


Thanks,
SJ

[...]

