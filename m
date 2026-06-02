Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CF4CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E636B008C; Tue,  2 Jun 2026 13:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DF76B0092; Tue,  2 Jun 2026 13:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B056B0093; Tue,  2 Jun 2026 13:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12CDF6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:03:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4552162930
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:03:11 +0000 (UTC)
X-FDA: 84835592982.02.45B0052
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 12603180014
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:03:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uyho2EqF;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780419790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Y205+jwxZNt5BZBpRmlKr0YkMQUprP/O1WFroqRwtM=;
	b=iQisGNtlU8MM/8ouIEbKAHCq39rGvqWWI8EvlikTU2MaQMoVS/7dG4zMDZE5M16OUwHkNg
	63P8k11ZreVx/vHaTumRY3VBEpYthy0RTZmVBgWsw5l8mH0K5JcfQY+YK89JA1eu2B2Mm9
	KhelIhRpxP/zGd5ON0gaBLmcw61TPpI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uyho2EqF;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780419790;
	b=ZPe8lH5YpPO/yFA9V8MpdWiZ6I+sFEJXOCNr2VU11UwkAbDfJkdCpRCiqLevJ1MgfMjATn
	WYuEpWYsZmUz/RH7K81QOKAgl8LGrbk8+olD0tPqYgqPdAKrx1eKSm8h1oanZv2lp/rxp3
	nVKgarPHIl4kNB2p8vzhv7ATkZX+f5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AC0B60120;
	Tue,  2 Jun 2026 17:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEAE1F00893;
	Tue,  2 Jun 2026 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780419789;
	bh=+Y205+jwxZNt5BZBpRmlKr0YkMQUprP/O1WFroqRwtM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Uyho2EqFf0mnl8glIIaUveTd/kfrqN5xaW+0tW/b/CAYpUeKehQO5szzT68HA52Ux
	 clfQ1lEAM0GAO9O6huQzWizK0uVW19Pbc/1bimYb9dBHtlKEHgvkbotOXLRN1DTRhB
	 BkJMdg2oWyZ/6xj/tYaZecppjUyFXQLlISFKPrcY=
Date: Tue, 2 Jun 2026 10:03:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Ruslan Valiyev <linuxoid@gmail.com>, Shuah Khan <shuah@kernel.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] selftests/damon: test kdamond refresh_ms
Message-Id: <20260602100308.749f8ae894efc3bb73fa02e8@linux-foundation.org>
In-Reply-To: <20260602142804.102210-1-sj@kernel.org>
References: <20260602131217.2210912-1-linuxoid@gmail.com>
	<20260602142804.102210-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 12603180014
X-Rspam-User: 
X-Stat-Signature: 74gyq3ktqa686mwdz3hnzgfk41gqwohp
X-Rspamd-Server: rspam09
X-HE-Tag: 1780419789-773392
X-HE-Meta: U2FsdGVkX19e3U5QU2iY/6Oiumu5DnJMU8a+Z1fdUFe+tSjtDP7c+9jL2/Sv/mWO5uqokqsTYnJdJzmBnDywSon8U0cnofFZWsF1xsIgsPJFJ+L1b61ER+08zVcU6yDyQP9W0lnVh41v9Pm0Sfq1HzyLimxwvKkQcZJRgid36lvKoQpUfFgzFFc4kdXt4IjSWrDjqooGzAkBfErKk23zAWKRAooavENvgyplLJxlens/EvSUZS6q0tbSQP/hJgc/hNN8L5pw4na0UEYnCN+mmcW8UptjhxHxU4E+3QkgincU9pGRenFU+XD9zgG3JfyXGKtrj+lZAOSsegXiHidiCEwiOO4ozWhkqVUCNsc3Y8CMG79b+HneJUXr+z9QmENXUtmcEVfPaECDHLj/1dm0aHy5r7uMDfsRa0QNb/AN9g7xmIb86wO1HRg7pltxWmpMROJUQkTsCcTR+k3HPJ1OzIPU9LDLxZrtq8Dl/t05RdSHplRpXauAlZ6SHobd/MQVRlNkW42S9CDVV5oIqzIwrJWnn01oXfdZGO7fr/Hz/F2sathuUSXUy9RitR4ky+ggpx4ry8JFxpll9ZfuXMNOwiQdEMnaCyZEJwVbmko6AZp9zrxt1QazzfDCO8L8teqFVup3z6qHFHSoYQG8X2KkaqEQRHb8O9Q1b17aIUqRJTUc1SwAQFf5Xk/5kkPhkqBcS6PgYNlSgUXhKyPeABp/tk9ufi4ZfmUPrqXAQ6Thoqgc44OUwfEk5YjM249IDYkaxVWoxKLdq364KqJJA9E6fBGyrdtBZ5hSC9KDybdhthyuQELSN9O4GaWHYuBnP2BhPDhXOK/gBuo4nhzsgXe0K26vJaYCdlNYGlKPsxazK8L3/+HmWAujPrFHzZguQ7+E2Z5BbGw7nm6CJ61RLcMFxeFrZtMGY9ZPAbqvfefj4S3Oxj3GoqMf/KqadBqLNtArc4MXyp4xe9RbgO7jmuz
 bSUrkA0r
 TmUWKyTtsu93u3VS2C25kVoVcK5U60ngCPMR3LCfZSJByinom9jZ+jggwqRRN/vvnVF799zbxgp6E4ec87fl3zox8tQgdwTsT0RjOWJUtWM3vNREbSQu4Iw0O4LoU7091dKNpUlvFApyZXh1xopLPR3GXnvTMdHE4AYHNb2mepDaKwwZFVnBV8DW4LQ9vvTti7EtMwS9Xr6iIE60wGNY6QEiZQzOdzf5+6UV23nqmp71PuGMpafPRo36KY/EelKPLLYJku5KBaznKzG74PTheOz2fzTiKmSX68WzQZY4sEsoCRphMilS7rU7OHxxsOBM76lWf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 07:28:03 -0700 SeongJae Park <sj@kernel.org> wrote:

> Andrew might want us to wait until next rc1 release, though, as
> apparently now we want to keep more time on stabilizing mm.git for the next
> merge window.  Andrew, please let me know if so.

Yes, awaiting -rc1 would be preferred please.

