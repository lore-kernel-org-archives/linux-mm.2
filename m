Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872DCC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 00:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0CF6B0088; Mon, 14 Sep 2026 20:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6909F6B008C; Mon, 14 Sep 2026 20:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57EB46B0092; Mon, 14 Sep 2026 20:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9A16B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:28:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42DDA1402CA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:28:46 +0000 (UTC)
X-FDA: 85214111052.26.B89304B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A077FC0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:28:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hK3X0I0L;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789432124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqLvGi9RD7qINvX2Zb3ISJuj6Gh5D9tq38HZDv24EM4=;
	b=klwq9A2C+5B7IQhH1LfzW/ZDCg93fY3Dakpge/tXj+aDuXI+ayeklIB0xuBOCQNdM6nVNB
	2ZxHssHtJ+6q+WtdOmzys2JiqXaSfetCa9Ybdlr9lr9VuPa/z9Vb9cOHLJX2uPlcX9hKJc
	Ra6uIrFRsllG/jBz/LVYVL+gNnHTHXU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hK3X0I0L;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789432124;
	b=wqXz96B1C4ngYi5xzzDFDKLABEQ2WPgvke4xD+tWe1YrMZJPtNjKG0IjpKpTEj/jWwmuL1
	BWVnVj2/kTJAJo1k9ZHv5buC62vpdksJi4pP0DGViK3GUtEh2ZyjoBZj803vyr32PKR9bH
	IRa3jsylXIXSvJACgLi7xsetVAYY/J4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8CCA6025F;
	Tue, 15 Sep 2026 00:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D94D1F000FF;
	Tue, 15 Sep 2026 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789432123;
	bh=UqLvGi9RD7qINvX2Zb3ISJuj6Gh5D9tq38HZDv24EM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hK3X0I0Lmube4dVvbjOzqRQOzBfAEW9WHlkZLcjYRD2dhvBbrYtZduvYQ8nfZx2Hg
	 X8grAnmwfrylot6YmXa/uWBvGfeYuiQM2RHKRHxAR/jVTX5UgUsJnRsfymc0jLyW39
	 Z/SILDyUmSiGmFuz6D6qmU/rlNfEUq9HQO82r1KAGAGKThPh5pZtF2WFhpJHpjOENZ
	 oPcCDWIm4PV/fokbtnO2SCvkTqwnMJ5SnGm3fxJHy5hnKC7ySznb2sobwO9eqf2I3f
	 EbGc/08iMXnzZxFwzuTXLaW4thauo3Gzwh3fqS3Ido0zaGaozJ8EEoO2tbJw8+iSH9
	 NpfG15+ULe4wg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Implementation for paused kdamond
Date: Mon, 14 Sep 2026 17:28:35 -0700
Message-ID: <20260915002836.101895-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914153640.8481-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a15qxhqe5iux7ptupcqcjt5jmoig3xts
X-Rspamd-Queue-Id: A077FC0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789432124-742378
X-HE-Meta: U2FsdGVkX18TMTc9LLVdxH3z7IbB3Ut7ca/AKAT2hBzR8lr7+V+cOmX5G13YEdCbIrbsMccfXEcO9JlOItTQmabqyOpi2xjMJwxSCONOFAUFLZ1nSJuOVWW7JZG2GwzYUHD9NUc4Hjg1g27e+Po+opD9EtwzGyv9Tm1xyOjp+g2QfvYgoKuMgfZK+VAp8ZZb/2tfBXmExqITuH9jQxqC3vTZ1USFrlN4a4iWMR6yIbOL31wyR5DWq2X5agqJCkdBIxTuq9u5XsmdFgL7CUelGkhNJLIVMrfD9BqiV8Y3ljU9jtBFEOBhcay9qmp232BTQxrgqRccuGK8BUoTl7W1xePr9mJjTCEWr7bCv9bxvAvydbai/JHsrl6buVhV2L7hwmE2jSrpSpI4MnY3Go70TWYva2476W/CaPVrDseI8YBK2g+844WZys5fb1Hqu7q854F2OIouG/8oeNyL5gtnHeswQNLjJhw3CSmZT3Un8/WsCOFDB1ZY7hVi+N6p6wDYtu0oSzPgfneRfMezWwR4cUiP98LiSW6sqk0P0baoSuTyfG1G1/ngSDjKml+0snyiL1e+rl722WVv8gGfW5CQSnW3saVu1RtNw312+mnixOEw84jLnGqp3exiAQk7Y7nkxS4bJdrFKkteDTtgh8H3+qMd6n4QJSlPP92CJl9TnrlzaIV8vby2xl3LMRJGt0PIZ2a/u6P4h78F8blCAngfFsgOnIitZAoG8KQ33b4taGj9OopOAtsOZYInTAoEGyvWd20UnrFQ90OgcZB/fctkJcQ4sTPnLJo0+qbBKUZMFe0rZiMgJq55XPNOh+jHs9LCy5eLoSpH2e9ZrtneZqiMqNJeP6IrlRYXjPjtF5alA5PTC3pTUzzH+XwmyWvR+Q00YZVQbNDvyAoIfRvg6UPEbhH/sIRMzl9BBtupxfuDq8NYl3LQh0oEvGtdjLHd0KlQbsNFoilcksy3JeCkLjk
 ZSesXBAF
 AYoURuzKdEC5lgzjjRKlIX9yQnl0VZUTgH3XKuRHYjnt2VFBwQCBJdKzfGUVvLLmi5QkorLjW6I4DBXp1f4wKTde1kRjYD9A1dG+9p41i7byY6zExYbWWXm0vqLtx6rQtvUYnJDBY8dxWjy1lg9xYf/PWgtmZ+A6TWZMx3YuTadCTlp/6pnCj9UF7RjBk37jKQuuMxLX5xOFWlC7dXCoau65vQatFPhhFiSYDScaZZbmle8r/gfGl7sdW6ASWDVcIJb/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 23:35:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> I noticed that the current implementation for paused kdamond is
> periodically applies online parameter updates by kdamond_usleep().
> 
> I'd like to know if we should change it to waitqueue to achieve a lower
> power consumption?

I'd like to make a data driven decision :)

> 
> Previous Discussion
> ===================
> 
> I noticed that when you introduced ctx->pause [1], Sashiko asked the
> same question, and your response at the time was:
> 
>     "sample internval is 5ms by default and recommended auto-tuning
>     setup makes it hundreds of milliseconds.  So I don't think such
>     change is required."
> 
> I'm curious that, did you think it wasn't neccessary to change it to
> waitqueue when it was introduced, or it wasn't neccessary to do so even
> after it had been introduced?

I guess I thought so when the quiestion is raised.

> 
> Asussmption
> ===========
> 
> This is just my assumption, not a real use case I knew:  When 'pause' is
> set on an Android device, user might want DAMON to stop running
> completely when the screen is off, thereby reducing the load on the CPU
> without losing important information such as regions and age.
> 
> The current polling may make it harder for the phone to enter idle mode,
> resulting in some unnecessary power consumption.
> 
> However, pause feature is only present in the stable version v7.2 or
> higher, and since the latest Android kernel is 6.18, this highly
> unlikely will affect any Android users.

If whoever comes with a data that require changes, we can discuss.

> 
> [1] https://lore.kernel.org/damon/20260321202858.98091-1-sj@kernel.org


Thanks,
SJ

[...]

