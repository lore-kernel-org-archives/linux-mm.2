Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE03C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1D76B0092; Thu, 10 Sep 2026 07:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479DF6B0093; Thu, 10 Sep 2026 07:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B1A6B0095; Thu, 10 Sep 2026 07:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD516B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:56:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE733A0512
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:56:53 +0000 (UTC)
X-FDA: 85197701106.26.223D81F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 259C580006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:56:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBYR7A+E;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041412;
	b=ZYt09fIrtaRdtWJMNDt9TXW/VmLm5lmSgjP+RqiGE2/fWXNhDKhrrE89viHEXHj8Fk9XpK
	v7ZtbeRzCXyJtFuRmM7mgUWxrQzOW0IsEsflTDlZhxfE6edDcQDt6MlvgSX2zLgp0Q0Jv0
	KDXtEN3Ony6YsHnAJZuZeXBhiMZAprU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBYR7A+E;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTv5gjnoUkgmckYg25Wd/ghR+9+1LKQRAbj4/Rz6hR0=;
	b=XVZkjEJjtS77IuU134Z/Tz8KWEXEbLmCGoi8m8LpDunjRUxOAHpp6F9dse2h4pdNrv8Oxg
	ixXvzSDxPgRFvRQ1JZT2MqeJPORE2h7uGspeh0JOoYRcO/J1J4CnaFI56GhHJ0QWtE8AVH
	Q4Xdz8fFQgrNmnRK+axAAf9ZJikPYXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A895A600D4;
	Thu, 10 Sep 2026 11:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FC21F000FF;
	Thu, 10 Sep 2026 11:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041411;
	bh=PTv5gjnoUkgmckYg25Wd/ghR+9+1LKQRAbj4/Rz6hR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mBYR7A+E5z+EvsOhBN7DfdtkE3x9n3oGaFrh40fXMQwQq6v/VuATJp93OAVBpcdsJ
	 /2x0vHU7OjE29cqp3dLj80QthvfsdFR7OzpWhX4Ex8X+ycWO/SwTQCs3TwpDz5SQip
	 wokGMjREagLm/mw3zpaMLnOLw6OeqvoHIrUGxnjBsEY7R8LlQTeSDDh7ZassM+vhgn
	 YkMlBWUBo25M/ndAiVZ/xur5sTx3NUSPGsI/iCT9jKj/49d4a4gjYNlb4RCxezsZNs
	 /OcUcxbHOYBUZDlVobiSbrDu40TTl7iIXt6qisrv4hk+Oupv53Uks6b0x1810wZFA4
	 1NxZid0h/Z6AA==
Message-ID: <63cda829-631c-4758-9aee-7c07ef6a16f9@kernel.org>
Date: Thu, 10 Sep 2026 13:56:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func() check
To: Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org,
 djwong@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 259C580006
X-Rspam-User: 
X-Stat-Signature: rhqqt8mqm6xum158se6pbj8dhnp3e9ay
X-HE-Tag: 1789041411-226297
X-HE-Meta: U2FsdGVkX19vWa6E9+QPOtFPbYlRDk2ISosqgVeFqe5L4o0zH2UMgEn1HJDv6K3SDYCPy4Zg/pvo9c7z3NfPS5eMTaqT0aFUw/PMyeToq1hHsc1QUClm6jjGvaQlRqbsAF4TsdHzKKH4I7qjYsKLAt8cEWuz3PIQDosUg/Tj6j1EW77GZH5Rv9zeLc9sbTxNPhPXtcJkDOvj0cB28oOe3s58HjzJbeyE0utCwD5N+feBzv3kaHP6ptVSwEX1hTKZ0AAmLgZBeyfzmS/uoYmPm4nc6KhhHrMzK1Kpg92xvLeO84qJHKfGVvOpXiKp3Cv/7FEAYuaxYPazSLSkxuPa/2/sbrzhHV+5qYRjC1JxLa3czGQzOANzeAmZACWxFO2tc+tf5mNTApBCy3Vo5IQvnpKmo9Nu/FV17or3mJmwcdAmNxH6EU7MaSwh6HNSNFC/sDv+ksOXLPOkqOVzb4O1DL0zta4bEtam+IsMbqdjQ0exlfhnH5HoOXvvVFRQDd0/F6s+n9ch8KuJFHuF1ZYGuyPSrKW0Ay6BucXNs1wFjPuuoDywCsNr8hVnrosQon/+GGknFuflFFSFM4JZLeSG6kGIg3lWm+OANEKDxdS7ioiN7/p99d0TMz10NTM/xyPi17kZX4G9h13TOb0nWiGKehPyCY8WGnnvlSLehQe+S0DdmfptP+c4P6c9cx8X7NXRf65aeMR8tpu3O9zuuX1xs3svYAq8SRWPQZZXWBS/7qGfTlO0a2PfzsMhAAuPUdJRO3EbwyEn1SRDPdHdLTDytz+uU5Gby7qp59ujOarNBB/4oiuUqGzWEoPPPJiOTStnYPRJyBi46SvqPfRRiug4H3SPQpbVnPmdaau1NMeJ6w+M6YjQy9ThGprNATEM4IE6osYhwxVz+QKxEicwUUAa/NCnKWaflI6pWh4oj3uk6zhcG9ehlvqreMX/rkUkdu3BenJkEqtNjDsnStZSmBt
 BSBkz9Lh
 g8bDnFKrcle6YkU/jZbbTbwtrO/K3BvPkfwMAQsci0UkEPVoFgj9ThZttplpcRSaJN+j2stsWNruiuXV3+OMi9x6jDSC10yeOdbKeSRbHmrI9ICACGIxEafnGC0BoXER57HxE4pOnipsE6U5Kl5c/e2a8AaTNS1aLRcAXiQqLh5wX5Qd3ZxD5rOg3o12fgjfocncNrZIUytnYvwb51+077qcmKQtl9IHTxiqAUTt0AWlO0iKyDFUsIKgrjy9KMtenrQwdz7JEeZ6e2LpIY4NJ91W9bpW5l+TB4zsyDyf5e7dhZ+FnrGQWa3/O3f22Kvy9Yo5UoE629QocG/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 15:16, Kefeng Wang wrote:
> The preceding commits removed the last consumer that propagated

We avoid talking about commits or patches.

"There are no more consumers that ..."

-- 
Cheers,

David

