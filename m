Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88264FC72CE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 17:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1C76B008A; Sun, 22 Mar 2026 13:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88D56B0093; Sun, 22 Mar 2026 13:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5746B0099; Sun, 22 Mar 2026 13:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB90D6B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:15:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5872913BC85
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:15:45 +0000 (UTC)
X-FDA: 84574351050.30.059A26D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8231180006
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:15:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rBIfKVkc;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774199743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Plef1jDOwlDaqgMdfK76wojGU2M+VBHqD8CAnF3TQxM=;
	b=YrLIkvcbwgQ2jv6KZSC6vnEuzc2cg9Z1TpI66lQlS8d2j1nOPjwGHGO7YfOMrOKMs7KZvc
	G5ElXrBOXGpb5JwHVeM91WwsvOvmTbIOhoImELTz2r3DxpdRRLg7CFQ1vY8rHTfoEfS5qb
	u89lmOcwsvSoTiiP0UhhVwXAa6buWp8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rBIfKVkc;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774199743; a=rsa-sha256;
	cv=none;
	b=WBYc16AkbM++C+JrqzIKxO96BaPR2JU8ydgDp59+ZIhz2L2h5ofpvxum1ZDMgIpP8YFHGA
	f2uV22pSDLjAkO3qQbgXZjwTGzPo1HPoXhIFz9u+Xd7g6zLRzcSyodlp/DHlmApYNnrOOq
	uhj/kwjCO50KilNK43n49NCe116an3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2418A600C4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1641C19424;
	Sun, 22 Mar 2026 17:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774199742;
	bh=sNsCiQ9Si+6TpKQyQrImtsi34DirRqh8jDGiNngIzjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBIfKVkcjzshlqgH6YEi3+7i8bpiUNzvGkm4k/e1UoS0MViRx7tGYNVoBG+t/qA6N
	 CcKkZ6eQI/x6pnr/L7jD7ngDLybhxGGzTBZ3G88q6+RP47dMmhRMKBy/DprzQSaW18
	 EmbSyVNv5QopXVFvEwO4bLLlTjG3EKdIVRkfzMNjKua9peJx4TR/gyATTmOSogSiw/
	 Hi16uIailVrr38I24AIZ3HPCSEAZwO3RTlJGrfXBsVODqI6laMDzpEcS5AS/l6BBof
	 Y2Ch4i/pFgc+VndAlx41YXtipy7O2i9MykpwnSjRZXhX8c8ZRXpdC5YAR1YOQi4X+n
	 emVCv3N7p3Prw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sun, 22 Mar 2026 10:15:33 -0700
Message-ID: <20260322171534.83470-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-11-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8231180006
X-Stat-Signature: xore77gjowc3sucgmoqhq4yimcqjxshq
X-Rspam-User: 
X-HE-Tag: 1774199743-164478
X-HE-Meta: U2FsdGVkX192DWOX6d86qVCDP0sOKAMXoeJ0ae77J4wmjTdxWi4PyssA439Gp/OR9plRwsZ1noUJNE7PD5cYHBHKu5ZCzrYcqhuFxVOZuOWAvrt7gKvdS5till5lbnxVbT36qvVr/78EBCSW2tyx3u4rH9YZuSdcjugV1azc7YUv1XazH/lxhS9DCkiU8YElRYcS6Fvcpe56CoBbTOynNC7Gk9WH1qZEWMpZSg8bQenjKfTV7G/NoesyXHk4+QKdT5cBu4qN6XKdaTHSvUMIA7etgCp/2idiecNJqyoldJQq3IkKhs7/TcLHHKnPbuySbiI1QqFqdoAJf3sN/lbxZmHCCz5y5r7rSWp11N4NBXw7FYNM9Yg0FeNAqhQbjbbgEv2PsasOh//61FRspYA+yZrGrTsRhgZjHfAYOy7fLGhd1WOIo2j1zI5PELL6+iheavT9+ebAXffkrXvlUe59m0k1jql99MDpED6qGdd3mjPghpjNXQ+Bu1kQtiHsaEuVgFoZxkUoX580FDAs1gNYrRxSSbOODbdzBcCOVDh9zwiVNVGOvkDlZ/37pbcKg//lhVwPrYvOSZAWsFBHDts/MXzsmqvnrdbVvdiF/6Q6Soy3Cqwtn5yYV4U3CK5jnePA/6FueT1bCb6jIXOy4+PGE5TQTpVmWU8GL9xlQtQsn9LlB9Wk3HezxdBg9m/xBjzV5QwiVX66SnOdccbcbPO3FrM88YQmCj1EMKegdHiO/RObI8nSRm1mKO4D3nmuU9g/1/OJFeYWhF5P63DJF3aiqJaPC1SH0r+uJ0P9rHsOojd1JNAkoySE3WaiswoPrqDxlGJtd2AA9QOjLNr5tYPAJyWAYOhdiIe4s1GdOnRuVpD/TG6ZPlZHUlb9d+QwhjruU1eo2nmADNNP+VcSAXuV/JOPJOpdRpAySqmD5reonRbQMK5WDw6T0Z08QuLvDW3KUq1+8Osl5zC23Wt3SMy
 d5kWhFWe
 LNu8OSCVbn0Xm1iD0hwwmw/fu3ZwjEDYx5ga2zD6pr32VAsXnqi8as1pIZ7VTa6qpm/CIdp3rYfcP/dtUlrY9NJdGztx0dC3JeP+uBQ0ry8/S68K+26ONU7J1sptsWh3I+DFNNSVH9RJ7sVIHt3U2msamqH2d3QFUvhj6+LPbLdI9lkEep1BAuv4xEcTMqvQMc7CxjpDSFHCPcCosGQxzflqsz8y/zwzbL+1+GLorY9ER0BngX009RlPbrccEcnj7xjwTb606nzx8THBQ3XbRX//JWM9BbxAbkhIdPeLi7fSTA0umI3+COw6DiQyo224Ob3ajYF3RM5hfGosXKWVfnh9CKoxxtBjPoznVIxKYa6NUsrpIFxW9O5fMnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260322155728.81434-11-sj@kernel.org
# start of sashiko.dev inline review
commit 67adf8e7b8416252faf583e176f0e8424fd4fb95
Author: SeongJae Park <sj@kernel.org>

selftets/damon/sysfs.py: pause DAMON before dumping status

The sysfs.py test commits DAMON parameters, dumps the internal DAMON
state, and verifies the parameters. This commit pauses DAMON execution
during the state dumping to avoid races that can result in false test
results.

> selftets/damon/sysfs.py: pause DAMON before dumping status

This isn't a bug, but there's a typo (selftets) in the subject line.

> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
[ ... ]
> @@ -193,18 +193,55 @@ def assert_ctx_committed(ctx, dump):
>  def assert_ctxs_committed(kdamonds):
> +    ctxs_paused_for_dump = []
> +    kdamonds_paused_for_dump = []
> +    # pause for safe state dumping
> +    for kd in kdamonds.kdamonds:
[ ... ]
> +    # resume contexts paused for safe state dumping
> +    for ctx in ctxs_paused_for_dump:
> +        ctx.pause = False
> +    if kd in kdamonds_paused_for_dump:
> +        err = kd.commit()

Is this if statement intended to be a for loop?

Since kd is just retaining the value from the last iteration of the earlier
loop, using an if statement here means that if there are multiple kdamonds,
only the last one might have its state committed. 

Could this leave other kdamonds un-resumed in the kernel?

> +        if err is not None:
> +            print('resume fail (%s)' % err)
> +            kdamonds.stop()
> +            exit(1)
[ ... ]


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260322155728.81434-11-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260322155728.81434-11-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

