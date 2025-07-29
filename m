Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAB7C87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 19:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A6E6B007B; Tue, 29 Jul 2025 15:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB526B0089; Tue, 29 Jul 2025 15:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500F66B008A; Tue, 29 Jul 2025 15:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4446C6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:53:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFFC91D9371
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:53:52 +0000 (UTC)
X-FDA: 83718352704.06.B1E597A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA647C0007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:53:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=D8IHiYMq;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=84VB96h0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753818831; a=rsa-sha256;
	cv=none;
	b=2beUfOckIMBl4yyul2BTpf82rZQ+f45yf1SEYY+GWFNdNQXHvmxaNhJBfam7b00gKdSUXt
	rdq8SSw5r2Ms+9wppzYvy7xzAaP+UAPOV2h1W3B4q69wJvAogSwfts+qxnlYEyW52fNkK8
	u9flyuWe7jC1vpgWSNKYlcAT0RlVQUc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=D8IHiYMq;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=84VB96h0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753818831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=murAsIGdQ6vlzwol4uFiktJ1U9ZUZDAn3df7ASsCmD8=;
	b=E17c408ecm0HTBGYzdJT73aMaJChTz96ZxZfxUgwt44pdskT2a7OmzyJfQgf3uKXCQ/ibd
	KbRMNqZN86c57GXDEYAUE5Rjo+SrJMP7yWW9Jjp6gfIpogdIzqb7As/MjWeyRTrIG0OwYh
	fhcXNJgyJz7YXnSNXeg5Dzsyriufcx8=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753818828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=murAsIGdQ6vlzwol4uFiktJ1U9ZUZDAn3df7ASsCmD8=;
	b=D8IHiYMqln69olqi/6g6npXcLQVV9NhOPq9simOGPAORx1WCUp6Y9LvMbouMOkAxzIGru5
	fzYmP78u1FWNs+tGfnQ5hVdCKKPy0IPZZDgIaQmQOhclLThxjS/nD7K2CRHRKoVs4t3viY
	Q3hAdwKxD55M6PZgz8UY9xequNcgThPVkshUggBZwEq+omEWc/UjPuE3BOVgDhqoncku3A
	Swf2RktBL3Y1jCSYd3heJ8dSP3bMTCYP4ijlJ5wiRKsusEYa/Qb8NSnMnfIefKUhjY1GFT
	clXl/VuN7sODouU3zY35RaW02sJK3BMssK0iJMoHu4f272V8b8fzG5IflB/zNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753818828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=murAsIGdQ6vlzwol4uFiktJ1U9ZUZDAn3df7ASsCmD8=;
	b=84VB96h0nopNOInx6f3954BclIbhdj2VAKaaaPvyAxSCFL2P4Z8AoTongAesBct1K6fmYv
	UacHzAa4keOqZWBw==
To: Jason Gunthorpe <jgg@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
 changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
 rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
 ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org,
 aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org,
 tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com,
 roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk,
 mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org,
 hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com,
 joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com,
 song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, gregkh@linuxfoundation.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
 brauner@kernel.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, ajayachandra@nvidia.com,
 parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
In-Reply-To: <20250729161450.GM36037@nvidia.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-32-pasha.tatashin@soleen.com>
 <20250729161450.GM36037@nvidia.com>
Date: Tue, 29 Jul 2025 21:53:47 +0200
Message-ID: <877bzqkc38.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EA647C0007
X-Stat-Signature: q9oahmka91hd797z9orto3moz617h18j
X-Rspam-User: 
X-HE-Tag: 1753818830-273003
X-HE-Meta: U2FsdGVkX1/Q8xIlvWutXX2lsTwh0l9e3MHvpcZpeuWpXy/u8gjFKSkKg00LD9+TSkUFkDOVU672JWxl5sLtcSi69xD3rXXmROYBfKB6iI0a16Ci4mQ9qSu5QGohXmGeVbGyoWO1gFw6nmh79nksfoD6xEDWBJFWFad5lQgnXPrv1B5/dI8+RzH4oyUGc82K6nHKdGlZBx3Am1pDbWVff+7uH70CGEKBwL+Kji0b84MR2QPkTd4ERHCVmxa2wSytx0WhExxV6it390k7GIk6HuYNjSUDN9hn3tpdlE4ajlGISTcBgrYfwSb7kRMkRfG5MQ79E06q2IrxQSos4CyVJS5lMhmAEpnccYE0A2TCXl1lC4/9r8c9iML0TdS7Kz3w1zumbEsHZeL/9SoevJ0gDHwaGHAHJHgDE04iFcBCN1bdbH/Sskq2PMMteGrZ30GkpPWvxSHeJnlTuVLzjujKh2IDegtRIYobJAeQUa8aHBqhTMyg/WZlZG011S4JQWVeWHLUgJfWIhcBCcVlniR3eT/bmu+/ruvaaFkF4pQ2WYky4bZX7/oBQIdym/Q1Xe18TnPb2T3/x99GwAXVZRHfnDMGPAn1BCILaBZKBpkekaYuNmYTqpqvNhNzMPrjzrjPGBgX9D8hdXtCmwBFT+F2DBLM6OqEJ319bmiGvv6BI/L6GgEuGxpQRcYQ4+XJvcE6c3y9lCJ+HXeTrRfi76FDQeGZ9oHygfNuFCO7K5wkScsXOn/IFpBCRruiXkNyDirZCw01YPxVh6xXwymWDTzeN8w3IZvxIFbA898CvFManxkEhH37fs8U6RVByfxq3xuSoSB58EYMZTdqwsC8dkw4mHDivol21h07jwF3Uhh/rftYypqWOeKsDxhyG3wFlSZuqtYE8SpE+ZL5PL96+2uSFwwK6zuQhFLxbI/NsAVYC+ZpOmy9K0u2aDdSuxPw1mVKjIy9lCTO1ZNc+cAYz/b
 64HF5eZd
 K67kdIxfRJfCK5KHEG3d6b3luc9ExO/x9V2HeyOSyBwn4LiYnkv4JENEZ/UhFYe16D3aaMEOXQqsIwh44AIWqi3gZbCeSrVisXjd/64hNMxfYtttr++D6Xhq/X9eiClhDgeJvNx8yzztrBnuK6JT3Z3uAXgqyV1pijKl/vlRRet6ZhhEQpG6f25I2fed63qF6CSF8wxM97O3mASDtP9aKRgRb+6gCtZOREEy8NVa/RUAY3bukRh1yMB+SOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29 2025 at 13:14, Jason Gunthorpe wrote:
> On Wed, Jul 23, 2025 at 02:46:44PM +0000, Pasha Tatashin wrote:
>> From: Pratyush Yadav <ptyadav@amazon.de>
>>  tools/lib/luo/Makefile       |   6 +-
>>  tools/lib/luo/cli/.gitignore |   1 +
>>  tools/lib/luo/cli/Makefile   |  18 ++++
>>  tools/lib/luo/cli/luoctl.c   | 178 +++++++++++++++++++++++++++++++++++
>>  4 files changed, 202 insertions(+), 1 deletion(-)
>>  create mode 100644 tools/lib/luo/cli/.gitignore
>>  create mode 100644 tools/lib/luo/cli/Makefile
>>  create mode 100644 tools/lib/luo/cli/luoctl.c
>
> In the calls I thought the plan had changed to put libluo in its own
> repository?
>
> There is nothing tightly linked to the kernel here, I think it would
> be easier on everyone to not add ordinary libraries to the kernel
> tree.

As this is an evolving mechanism, having the corresponding library in
the kernel similar to what we do with perf and other things makes a lot
of sense.

Thanks,

        tglx

