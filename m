Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3EFC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5486B00F0; Tue, 14 Jul 2026 16:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CB56B00F2; Tue, 14 Jul 2026 16:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4656B00F3; Tue, 14 Jul 2026 16:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 001FC6B00F0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:01:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CC2380472
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:01:59 +0000 (UTC)
X-FDA: 84988453158.07.D763C8F
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7398140017
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:01:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDmk6w9d;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iQTYalcOPdzmrOdtskVxlMVi64c8hoKREEpckzvENQ=;
	b=llIyD80Mb+G0yyWS+pG//q4PVmYkYpdszptgqhRiAW/wwbWSXJ8bRKSpHBC7niuVUX6j5r
	Y1M+Grb9gr93X0oYkmrF+pOr2kWcRfz5XLhoPSZfvAAMq0jHLx0/NkohdNavNUq5WgQcKi
	Ie6bOuMyTk8ErFxypaL3KgQz4DG1amc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iDmk6w9d;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059318;
	b=Z9y+u4YBsT7DPB3Ueqqts3X+vkfoSC8tuiJ7UwAP98UHOkD9LuYyjj2l8GO5Q80Pg036+l
	VqncmNXufn8oWKV/F2xiUWcbPd/eDZjNu/qJVbtNHnfhEF9dT5EPLokfoIggo6RZukLlq0
	4S+4xTvO3mUwem/B89SmvJH5/NePEdc=
Date: Tue, 14 Jul 2026 13:01:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5iQTYalcOPdzmrOdtskVxlMVi64c8hoKREEpckzvENQ=;
	b=iDmk6w9d3cXbR8IsPomQZgWuP8mSwsa2F2OpOGKY94SNiRJ2qNqcSgcef7bv7LAc2sUJA3
	eLwr/L1+atgHnoxg0VvDjpgI4T1PxQRU1LxfS7zV5oIjghoKtYe8AHHqjGcZHbAqFY/Vyd
	pnrY8DMXXhnj5sc3lmJxJ0AlNuFHrWk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
Message-ID: <alaVjJphyxveFEbI@linux.dev>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7398140017
X-Stat-Signature: wtaqe9ugrho9sbj3m5yxa6ixhwcyozrp
X-HE-Tag: 1784059317-260486
X-HE-Meta: U2FsdGVkX1+qFLvW6/YSh/aCKxRljHm1tiTwxahyvC/xkvy99gTxzfN9X+S3jVpJu3PceunNd2pehZvua4bdo1YC2Q0XlLTyx6lbJXydsLl9RUlglTZcCD67/1F5EK2Nyx0uJb1JQmAWqcY8L153n/EXji4UPcJ9uV/M3qVJSWDVm7Sxuxk06LVwDdSa2yzdjhE85dzvrGmAEpo9cKHllxNq8bFmQjlijmc30xRg/AF6xsiSFJRBXLYPwpR3vZVQmNFWnseRkO3tWfCdVma2Ex7j1bf0HCpYqdehlMmaY8BFCdpIwut5D+El7gLX36gDUlr8+yaqnesdRZrZ+Svks0rHeNuR3CGlt5ZXziYU0mAzp30NrH7sInQ6z7hXNNSUEnKOv80c5x0AKRnRraZ0S2Mv39EvmJrRo6RJzA3Cvq2M3+D+HMsyJKIun0fpXjk2vLQvNRqvgtihVGQ7HikLOU5XcZUwEAxUR4tmwwvwpztH7Gy261HhyOITgm8pC8DgJBMLlYhWGEFsuQLibINZUy/8Y9kn58Y5X+tRDEloMjMYONqK96hbvbURths6zKK4a7+Ll79fGu+KRsNMyFCg2SzT7S1HMySbGL0WXdw8p5dP7uR9U7XklB7/mwnZRBxk4QsKHlUAHNc/nr7g3MeeLf1Iw7jybTuO8CiRJo9sgurFkx2jMM2CIb4JjvCxSTGtn/KtEdwZutUxYWBQ7i4sRDwVlXCFqXljmPzTKYgkd1pbEaPa+ObgZ42YzzZDVuScv0l4mCFZGXBrLIbNMfkulVBciqc5vbuj/ki9Fw8mpStTBZaO99Z6uxjS/OUSyYp1EAyATWaAfn+VvmfSKO9fP2SRPcTGzoWFAbeGTTKhLUYnoVL68f2ohX7Pp3Uxs3yLd65X7Hj93wcjwqxxFaoL408J+ERX9I8UxfAzfOdFbv3RncnHJY6c8HUo+rE0JrsrVQbJGVeXpBQx/L1PN2N
 QiRXRjSY
 ebAqBwGDklJKOTbLcQTwRLclJiclUWU5KOeDHCRJ5ipu2+xVWg5yuHHcSic4UoocHxDqu5imME8bkmyDeu+MAuWuZK32UBZSSwBGcsQ/CacnxxoVfHqDMz30WfUhX//N5b9VeLO4u5IMWI02F6hH+llepJwdaZp4CbJcpoo1vm2n/fKUNf7nQcZWhkIKNbfRoAVPMrDkw4jIzGJTbkE/Gdh1B1skDXOMFPsU75OZPfPHEsPnYetTtoeA1QFd17Hbr8/Fz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:00:10PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

