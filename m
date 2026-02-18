Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28396E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 22:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3FD16B0088; Wed, 18 Feb 2026 17:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDB46B0089; Wed, 18 Feb 2026 17:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9F56B008A; Wed, 18 Feb 2026 17:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB56E6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:08:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67B8F1A0336
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:08:14 +0000 (UTC)
X-FDA: 84458966508.27.B92BA5E
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0BD7520005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:08:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TDCGGAmU;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771452492; a=rsa-sha256;
	cv=none;
	b=T+D7agggV3ZD+n84hDQabc1rAPmCQNAOhCwoNv4fAI5Rz4A/qragneyrMkRWKRUY+Y7y/E
	H9W+cF6rgj2gg1eX4Ge6KCsFlrFac6Nlf1G033zdrVmADR3k9ccZ+Qcjz/pYzhOQGW/Bzi
	9XvBT3nnjhpzx3hg7EQ9uDkqoU5ld50=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TDCGGAmU;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771452492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkQZRG8kkv/0JZ4QGiciA4Q1sGZEe0QvxA9mlMq1dYQ=;
	b=hxXWgJxthuV1F/RC5q+4gowjVLi1iayKDSu1uRvFYX2LH0+S5FFugoJVaRCE2XKwa0geP2
	T3PYqQnBZKqP/ZelQ0B4iDtuMvpUmRJ+XejON5ynpLYExBhqbE+pIBuFbm2ASyvodnsEyc
	szPeoZDmu9SEPwAC3zaegANEdLMGg+E=
Date: Wed, 18 Feb 2026 14:07:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771452485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkQZRG8kkv/0JZ4QGiciA4Q1sGZEe0QvxA9mlMq1dYQ=;
	b=TDCGGAmUvkAuX/mo0nag675svbXFq3hMs4EG1iduTdhKTQitfUntudSYxKpkvpLYMdrxE4
	I3BOIw7EFJqvAV16juvmCflQXUz5SOO8BYCfSSLKDwgQ6u+0dwRbWEsd5DXWxFxsfoDJiK
	UovwLqkE9q/FmQSixb8/OVlkrgEtedI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jisheng Zhang <jszhang@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZY30X9bpsV-nPsm@linux.dev>
References: <20260215033944.16374-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260215033944.16374-1-jszhang@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0BD7520005
X-Stat-Signature: jsacfezq4y1iwxa3usdt1b1bj18cids7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771452490-735495
X-HE-Meta: U2FsdGVkX1+8Jo/csD7V3VGuyKuE9uxyVtdnSZIpoIVpoZbToILti3E8O/Y5X9xP4F60xGhYMifs4lroWsoXjOtzIhTSADSYA2c31gIXEyHv75D4c8BWyYsfVABTYgNdhiADGkXC++VOdPg9qZMy4Zbn/i+0/KbJSsjchzUfKSJ4wsm9l6Y8NE60ER7OMjyW98clvm0Lugklx+g3ewRf33L960WOrzfkBmkDNYUPdpxbQPSJBxPZoUhsGpGm236wakevceHmCOWeaZ+4JQmiMxH5Lh/h3XlehhRAaiSRGyYl5p7MVZp0QSO2mmuLwmSipl5SN5IDdJKzDXYzr2cE/RHfwJFa084jQn0gCSaW+hD+dUtwQb3/wiZ9aEs+zVvgMkdMfO8CxXpPSEFsZ3c6sy35maSDZxQpzBig4nJ0EfUzpw7ho0vFUBpwZIr418lM+uSIENiVEAo+gn4uKJbRzTYVZ6isACfXp+lf43Gb8jwK5o2TNyWPcGlvvubKrEqq2Htmg6wOiDS7nMTiuU9ez5I5jyZle7QodzaAfGhus6HYAiwSkh7649YwRL6Gz2WvDliRGVlUL35Rii/BIs3DGLdBO5VD4sK0YdKGnOnOs6Y8EXz6bpaJfXS2ZdkU/ziB5sIg0mWSpoOyhedCAm70qTZdP+yK4DnQ4+kUSpxR/8hDsNIzYTKDVHCKGoULV+VL21eeNVczHyfp2jwdujphA2u2WKW2I89ykltjUlQHoElVP0tF612gelw1/MnC88i5/Fru33zq8D6XelyyoD6sDgnpKOEsjTpmBkmbK2OLowhHYGbbsmaQohD2XLF0xjQJi9dhhrn5ccEgzSljPoXnr86RI9eQF4nCf9OFX029K3n9YeGdWiv7VGJcetcX3YK+aAmwWxSTI6m0OYj9d/YQfBI9ydAyg6cgAqE5RyaqXdOrYCoWVhlL+6IYOU5YhlQ3KowGBFmmKauoHvocNPE
 nkZOENvI
 EL9+Hx+I3Yzx8zkCoXY3Ad1H1kk6BppDCwWDUZofK5yAJtS4j0+TV3y59x8YACKflRnhmDJ7AC4Fi/WUIWx1X+lcIBlnfNB7AADzDB8b4rVflenYDsjn9a5U1TVNCMCW3W8vuhMNEak+WD0G8Cptuwc0Ec2e43ULurNYTueprZPIWSR7Sjc/zeDJXyxH1lIa8kMuo/wrJC2PgCs9D4HvBvl3zQq8bUvu16a3qMvKHNlA1sDCBksnzyMjrz203b+uVQYdgHXSTMcBfVDBRN85n28JXBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> It turns out the generic disable/enable irq this_cpu_cmpxchg
> implementation is faster than LL/SC or lse implementation. Remove
> HAVE_CMPXCHG_LOCAL for better performance on arm64.
> 
> Tested on Quad 1.9GHZ CA55 platform:
> average mod_node_page_state() cost decreases from 167ns to 103ns
> the spawn (30 duration) benchmark in unixbench is improved
> from 147494 lps to 150561 lps, improved by 2.1%
> 
> Tested on Quad 2.1GHZ CA73 platform:
> average mod_node_page_state() cost decreases from 113ns to 85ns
> the spawn (30 duration) benchmark in unixbench is improved
> from 209844 lps to 212581 lps, improved by 1.3%
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Please note that mod_node_page_state() can be called in NMI context and
generic disable/enable irq are not safe against NMIs (newer arm arch supports
NMI).


