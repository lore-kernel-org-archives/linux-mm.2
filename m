Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B921F3C9AF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590D06B0088; Tue, 24 Feb 2026 11:47:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568586B0089; Tue, 24 Feb 2026 11:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EEE6B008A; Tue, 24 Feb 2026 11:47:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 381796B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:47:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2E0057559
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:47:03 +0000 (UTC)
X-FDA: 84479929926.01.C652F2E
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id DC52120003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:47:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=BQ6wWemq;
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7WVba4+lIeo13rFiJguJqyAB880ydlixO9cMvuQZks=;
	b=J45Y5/O2WoAcB+okS3iTwANz4rmWJ7KnxduJ6fQGKrJCojdifcABgoj3SDsaSUdaGxEAJw
	O+0CjFQPikO7GdnXuSQCGRxFD5QiGdmmYguOsAizfmUlVuJZVnMJ9voAQfgnVk+ez+atFg
	MhUWgMXBk49G1XbXe9VBRJhSbSZxArY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=BQ6wWemq;
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771951622; a=rsa-sha256;
	cv=none;
	b=1NVqksNom2KWwnaWhRUCAScmpg5ljJMJEXn91rMdIJUHGqDqr02RT4hdspdEdt9bJjRPwt
	Qt+xQeXXTOpMqHeIujyvcVtdiUqhIjm8DMww0kWp5ksG9kYXDaoNlmyGO49N8+yFjXBITY
	JsUOfZTvku4pOTTV7YbobIM+KPx1nKQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1771951620;
	bh=w7WVba4+lIeo13rFiJguJqyAB880ydlixO9cMvuQZks=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=BQ6wWemqFwD0Fm7DEZEcCkNZNkMV6hVorBjQ72nQpjbfuj56P9uVADRRzsJ77pgdX
	 i8lFbn/cGhklmpn8D13Ay1ajaTedM1p5REn+n28WnJ7PqJ0l+M8FzlufmEoBO3w9RH
	 BQ8hGYsrfObx65G2u9hd8WWlklPwOG2rUgPcYWzE=
Received: by gentwo.org (Postfix, from userid 1003)
	id A9F68402BE; Tue, 24 Feb 2026 08:47:00 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id A787040286;
	Tue, 24 Feb 2026 08:47:00 -0800 (PST)
Date: Tue, 24 Feb 2026 08:47:00 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ryan Roberts <ryan.roberts@arm.com>
cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org, 
    Linux MM <linux-mm@kvack.org>, dennis@kernel.org, 
    Tejun Heo <tj@kernel.org>, urezki@gmail.com, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
In-Reply-To: <de5d90b7-0c64-4a38-8abd-66a43800432c@arm.com>
Message-ID: <51b8e946-a0f5-7948-c695-98671da4a56a@gentwo.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com> <5a648f49-97b1-4195-a825-47f3261225eb@arm.com> <32969518-9106-363f-8a89-479b8246e4b1@gentwo.org> <de5d90b7-0c64-4a38-8abd-66a43800432c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: mfe3j5bwtsj9eqjyh5rsp4nodu6f6fpk
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: DC52120003
X-HE-Tag: 1771951621-693433
X-HE-Meta: U2FsdGVkX18Gwted77LePJ1agh5wayRwRiK3M6Ydl/9RGcKntT5V8BgWUJTSYjwGeFsMo6odTNzCM0S1kjWbSIeNZh8K0FeiK1+1fHz9ICqaaFjoT5EKw/sshVzrX5idahp2mz8yqShRjeu7twFXtczSJC6GwsMeRCO0amODyBDTxu772Na80EnpkNAbHEGIHJrt2q4cQvqOs5E2ksqnmK9yRvNv8rLfd7HSxvetbcl15PNCHSo3sBokJ8Fm0X3ci16SWzKP+k8BFI4OAVzXUtkokdqhGvDWprgDMfu5v5uPLNh8SzHh7p4yb3kQ35CYljszF0F++aEjB8Ijno0msYB3fucvxC+d+HBeGb8PMN8vppyUGmSeuxg/rcAhDH/yF8yWf6EBPPZ45ALVxYb3W+aBnq2bNbBsjCPZBOPOtaAer4IhKLBit74MVHML6V/JjagBbc5AcfJma1gR6E/FCE+v7aVJgjKyi5je8fKFyLFx8xtHgNEp4qnsmoLQcD0VzEFwKl5eQ88B8xm7cEBwCv9m0zYlqnFREqll+tY92oi6s9UwV6Ioi00UYM8CE6fSIqGvulWjNw546PIx11OUk+C/WE1TaKylExk7XqTLHB5RUhDA+uD+qlBVv7zDBo6oOsonx/CkSiKWi8gCMOhKCk8OMSWuO7we+hQylhiye/hG3mrM5HA7dhbE/2iPIxcAvE84+1Fo3S8qd6YMcK0txHyLiYneZeYbGKrzbt2lBZQliOmGMkZGRKjWDur0FP/Bv6SkrD/wHuvnz3DLSCRS2hpOr0SXcFCuzWINsuQe1FqOlJW+UqOtz/lQCQISzyvZ47OJkdftLbYlyzz/yDv9O560xDauV9R5omZKtVWO+cPnp+8T3Gx0NrKhTpW3zHyqbq2KmbWvVbNxh2ZK1oMHtjCn9C9Vp3w1st1qwdzZfivwEtijjeLZFBFA7AyQvOINiYExomM7jIyoFO1pSs6
 uf+1Ivkm
 eWMtbhUMLOVNnpUJPgiGzBtqFH5OUlvtXCc91+JkL8Wfzj/CRejXhGvWoRUGcwDdxQW9x6fp6bH4WI+Ru6nsic+m07Za/BTseISjDMFU8Mfsw4Z59cNj1GGUldfLliS2BcOwfPyzXrrVtbXk8wS7qQ84+qF3WrpQHZd9kM9yrgzVBQpd8b9ZVvu+SPDubWux4G8CfX0fJ65sYXhoB4nuhtr0BvchBVt+yE7H58CHMNMR+a8cLMqRJN8hUAnIdL+p1B3wMvNCa1SfGVBxCuIVIvBocVIYKwyz2S17aqn6+8yO409fOkjSZAAPd7NGOEZud1W0u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026, Ryan Roberts wrote:

> > - Kernel text / readonly / readmostly replication for NUMA configurations
> > to limit the volume of cacheline transfers across an interconnect.
>
> I'm aware of Russell King's series to map kernel text locally for each node. I
> guess that's the shape of what you're describing here?

That is one issue that could be addressed yes. I think it depends on the
NUMA architecture and the inter node access cost if this makes sense.

The reason that Russell's patch was rejected was because we did not have
per cpu page tables. The infrastructure for that will allow a cleaner
implementation of Russell's approach and also the other things that I
mentioned.


