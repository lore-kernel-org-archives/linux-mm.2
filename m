Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B940CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7DD6B008C; Wed, 17 Jun 2026 20:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488B56B0092; Wed, 17 Jun 2026 20:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7986B0093; Wed, 17 Jun 2026 20:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB9B6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:18:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FB951A05D0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:18:52 +0000 (UTC)
X-FDA: 84891122904.30.6B38E31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C53D180003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:18:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcccTQhJ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781741931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tq5Dd79ingLOtWDO9qXa2YQGMrnxMPixhR12ifZ1um4=;
	b=idEf5/5ReCh0TQw3VMNONbqCqchLF3fVOZWaBAYflSl1vr8KB2Rc/6MKzrQlQlaeY9kvFN
	uehyLV1eDen6vWj6v3zzryFzgxAeho8w53jCDnWlCeIfR6fCdRTZYgbIBclNr+7rsbzfpj
	JUYySk3exJsXkiPmxhMnD4TSGewR7I0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781741931;
	b=NaJ0NpO51s+hSxi3aZz7o0e8Ny9eKeN9T20yh/Rlb/u0yKUjiXrBpgzY79ST1xOUQQ7FpA
	hPkVfVYmp697I0uTjYjFW/GJ6GuStg+o6cuZMev2a7cGtNCOlaGBvKbbQIywL/n0f0hKUp
	Y/nMfRUzQhbwYIQyoRqDxGbcAppMjxE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcccTQhJ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F0760052;
	Thu, 18 Jun 2026 00:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729621F000E9;
	Thu, 18 Jun 2026 00:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781741930;
	bh=Tq5Dd79ingLOtWDO9qXa2YQGMrnxMPixhR12ifZ1um4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcccTQhJVBeAAD+7CELP/GBd9OnSVPTJIyF94/gJgSbsXfLLDEkMQCct0S/zdGYrn
	 DgoOvlKWcQKSTwcDx1VHp0b7TCgxJUoO1dUOhVpc2x0iVuFpzTeBZKlUUOFjmAmYVp
	 pltGjON3/AWa09bqVy8u+cI5sA8+wGvVeqefrCQckaXiHq/nSWGe9qwkqU1vhiJaqR
	 fzR63vcfz8IoJ7MOI1miBQKzmuXWcb807tBOaQPJoxaD0Kt27CeYC9ji5yX4RkDtQb
	 Y+zAIr5vuLMDRmpOtDFjLQVrXAu+AHRWTh5VjbWRT4ZntFx7skj5WOFww+MFMFaLJy
	 v89ZwAZA6FBbA==
From: SeongJae Park <sj@kernel.org>
To: Julian Braha <julianbraha@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Wed, 17 Jun 2026 17:18:41 -0700
Message-ID: <20260618001842.84103-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <39bf837e-d3c3-4b9b-b118-063caadcb700@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C53D180003
X-Stat-Signature: 45xpnp3y9yud3optg4gf3sd7sq9xno4x
X-HE-Tag: 1781741930-82442
X-HE-Meta: U2FsdGVkX1+E7vAOOGp1F73z7J15xo8226oC/kEVIy0rZd9PKf8fynKcr8gwzT6V3SdzJxkWO8PnVO7e3FqnF61b+umLWTd3lPrBfZZg1zB474HCWbr1PXArCcKth2a+4wtW2oK0tASg6x751yVQ6FUAX3BcCVANGY7b5lA41rCyHAcef424EuQ3zbTYsB6e4Lg0iJBX6SmkPcb3QzBhT8cgbPtkIWOQqZ8qZ+tfJuNRePfzbsi+5rJY3r63h0vTVKS8f9i8jNzJHztr9Cm+Om0OUGlihlmbnPRJcwWjWDOkRV0IebkB1n3a7HlT3Z1S7vp76AOXkHkpXRdTRmpjVQ3o3ttmf7nP08xVEy99xzIORpXy3u6UjVCACLn9DqyhdaDkhB/B7JTSWjO6L305AdfSzB/dG1dBdvbLqlkmXmd9UVTcbB5yDHV+hUYmysk/rogvodl0zT8aTMFMwHSJQVAwWuJVWTzBRbeEZZSGUzoK881MrnOkC6PeHhjgrgJOAoiJoNHDH0b4Lcut55TwmQbIC+9qPN18m2anZNYsLwvXuVotTAkZ+SSGTVobGQqAyOSMzY3IV5EL4MqAkJslbXeqvLpx8XVjGe+jbb3440/gPQ6/NajTADNdMbz9SGhPsfiN0gXEkt2NGRF19moC3mSdRYbO+RRRlOvu/RpYQvyrOHB/7T5AzAcsF99uYXKKrtF7gNDBsZ1/7wFQFYsmzR8wjP9nVSa8PvRnRFIoqaKQC4Na1pvaMzuq4IHQpixAlA3ushKao8fG/cLe1VZu3jyGUfKvcXe0z2XMf52Dob+0WiNuqGiVlnn6/Yh3Cp8J86gigw8zmg3LvVaeIXZocUEH8jk98H49pkZq8Bw7y9x9lpf5KkE3EeWnOH3WioyJcmtzCeiwA/MMi+IPtIOfoTJecXgs3qIeX9YRUg49Cb7yI2bSGeP19Y2vQ7B3gHw7lt8zK1HgtygtT8HsxTY
 gRx/q0GT
 rD6JuPOzvZlfvdIzt+RlTq/Cc9DTQuzoUGv7pZvklh6Gdj+6YwI3x53GoaX4THfLIFbCPcBEU65xYfGfzJaeavfMePGJMWnvmO2Fbbk4ngsO2jZPPU4UY+XdUd5+PcFwd9ppDp7oDT59/9rSlQjqTwhpaLlMRXnKqZNOIHk2FBiVMqJT30vGZOsaE4oU0ke+yQRCGVqtWut6v0RvzIA9ylygUdX4g/ZZ5Za255G9hwqrGzAvbAuIo2AMmT7cy8pfcUKCPhWkDXTaVUkfy8txRb62r5kV7EcGbJ1mOgKS3cCJfSD8pC2eXPpmLZqxBe5rrZJfSFibZuRJjZ49PoApDb/KVZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Jun 2026 17:12:45 +0100 Julian Braha <julianbraha@gmail.com> wrote:

> Hi Asier,
> 
> On 6/16/26 16:03, gutierrez.asier@huawei-partners.com wrote:
> 
> > +config SAMPLE_DAMON_HPAGE
> > +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HPAGE)"
> > +	depends on DAMON && DAMON_VADDR && TRANSPARENT_HUGEPAGE
> The dependency on DAMON is unnecessary because you already depend on
> DAMON_VADDR.

Nice findiing!  There are similar duplicated conditions for other sample
modules, too.  If anyone willing to, please feel free to post patches for
cleaning those out.


Thanks,
SJ

[...]

