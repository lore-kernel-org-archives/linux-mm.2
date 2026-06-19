Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BA4CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B83C6B0095; Fri, 19 Jun 2026 08:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069926B0096; Fri, 19 Jun 2026 08:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98F36B0098; Fri, 19 Jun 2026 08:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C07AC6B0095
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:00:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C0188DCFD
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:00:14 +0000 (UTC)
X-FDA: 84896519148.09.6316652
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4D42720019
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:00:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hp7XaZkz;
	spf=pass (imf03.hostedemail.com: domain of 3Si81agkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Si81agkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781870412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeNrhO16hrgTC34xhsR8fA1n0GfOwZN3MF4DADT7KD0=;
	b=1qB7bCZabBXSGb6ommj01mmIWS/Po1722fR+3VPU+seMmv7zUvcxiVk2UFuBy0jbeEuwrG
	JsQeZd2lIvCMpO17l8eZhSJQRNBPThj8zHMYdyq+HYLXxFGzFspIvm0zzEyihXsaUYoUUX
	GfL6kqFC8JRkaSY0AP2EGKeDv9NNDEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781870412;
	b=U81foWeF8yC/s3W2pchN3PmUI6P3T61n/4EoSl8eAlVnV4uXzbJyfHa+pWbofIV9P/MZGE
	u+n2vi00NWGa8kUQ4JYDqRT6NcjP1k3xOYa09Guqp0rCzcIGpIcxOpiSDBwnd4sWHG6NGD
	Gl635pjIS5+/mJ/oKO0a1tpr6KZIi8w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hp7XaZkz;
	spf=pass (imf03.hostedemail.com: domain of 3Si81agkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Si81agkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-696057a75d0so1522239a12.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781870411; x=1782475211; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GeNrhO16hrgTC34xhsR8fA1n0GfOwZN3MF4DADT7KD0=;
        b=hp7XaZkzK4fL08gzkrwJyIbsEkXKpghtQ+h3j+cOweyatTjhbfzHTUPolxCs9xhTi6
         MWMEsjMavIxooEmoeH82/xNE6xJpWbc/zfaDR3cOnTjo2/e6De6K/pn0g2JJfT1aV4wQ
         wVcuCeEs6MrAC6HML7qbs5x+6UFcGwoNAsFm5lcgjq9bEa0rvd0E9LDWhUL1ybCmw/8C
         /Wv7FQuRz5f0CA/a+j9SZx+4XXeKtiHFBoIZSL+KMamI+bXoo7huGuT5v0NRsQwPaqhC
         CnFwzX4iMxqVEwj1MqkTVgZyFBhKCbOTJxkIxG5ZsEm9ORv3R256rS9E0LhZQwHl2JqI
         4OYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781870411; x=1782475211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GeNrhO16hrgTC34xhsR8fA1n0GfOwZN3MF4DADT7KD0=;
        b=WQCqZtMv9wOolN4bAsw2UuJe3G+Dl4e43vmi1xYd/ho1E3YitCg+opUzkqPvLBaAgF
         z/z3Gr2iDjmz2NjclQYxuVUarYzZAzlZiwrlDcKCzCOZJKahbLMqqSNZIapprADKD6Iz
         9fI2lw4lVgauR+OgcJ8JuonrQGHUsXULE2QbFpbh6vDhfmZ3DDV0MrYt7ObUiNzuczmQ
         BTzDQHWzI8Row16VF/54VZnJ8HLtwF598YZ3MchVPnAX1jAZVjnlB2WVy1x9P7tNpeHb
         qZqE4LtnwzFKzakxCorFAjFDYMM38HoecaiSmeOcGbcResMK9r8je5YqEAkcwBP9dJQR
         FEHg==
X-Forwarded-Encrypted: i=1; AFNElJ9CR/mvkFW7p062E4fL7niBAskeJ2PHXHkueBVYqdHZ3d18W92qAcuBaEMoT2tsPVLJRUIyEFEARA==@kvack.org
X-Gm-Message-State: AOJu0YxV0e7QmFMoR2lyk/7HtBlcP8PKzMQuuSM9BNa0d7jCRlNkog/H
	TPLGiy79feEisJl1Wps9BIehw4SkLq0/s4Q9YmXtK7KDycD2nxSC2ndjmqa/Xxko/6H35i5px6c
	YyczUohxHOqaQAvX12A==
X-Received: from edy20-n2.prod.google.com ([2002:a05:6402:5354:20b0:697:647c:fe28])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13d0:b0:66f:2ea5:c269 with SMTP id 4fb4d7f45d1cf-696e520cebfmr1885043a12.15.1781870410243;
 Fri, 19 Jun 2026 05:00:10 -0700 (PDT)
Date: Fri, 19 Jun 2026 12:00:09 +0000
In-Reply-To: <cover.1781615759.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1781615759.git.tarunsahu@google.com>
Message-ID: <9huzv7beloza.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v2 0/2] luo: migrate serialized_data to type-safe KHO pointers
From: tarunsahu@google.com
To: Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4D42720019
X-Stat-Signature: k66hptjub8c9ytdk4ofgedughqe5ejrz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781870412-721834
X-HE-Meta: U2FsdGVkX18fnwgyY+5Mqj0WSkPf8ejIjRI1hdILXfhzhqY+Bo+7953NtAoNOchwxN4bV7AoDTZ6t9m+YtX5VDQCGr+zBwwmgaRO2qwlY3C68+DqgKL73F6cX8i/b+6AuKR4T9Ld5xE3nxKhp6kBhldngckqvPxHbmD9yB+2ZHOGOSWgQl0/89xneMTGfGJaZFw8lFgLM05y+STijZoFhTVzebgbOiwD0/LBIUrftDYbwmBktTA+wJnbtaL0QNN/irhdbVAM0RqHz1n4HFSFLFyAU/DgmWzaIQM5Sb89m9TYw9lXr8TUDmvMSm3iaKsSUL6Bdrt7v0ZeXDx2huoQ/fLDo93y3FTYf+gTaIBEPqVEcjTLtvhafoUM3CDQfR3C0AULBbtvlCDQoNkRALn2X0F/ixENOAeQzsGEWgmuLFPmzEaJD9f7r7hQ8EVlNsjYKHbOVB06I9VpbmLRnfKF3RX9N28IP9XQPTruA9ILht9sRTLu8yXqGax1QW5+uI2jPBUTZf+XF5FX/upxAV7Mp3oPL/FeiJ7ijzJBpt4kd3VHQzXDz3iq69BhK5x/YpYc8qe8M4Ui7ApkGue+yfbW1Uf5C4QElZAQkwXdXm0+PtPWaE9Qid4VV50O8NM5C1MhJsV3A7eayTQdcmhWEHLAl8ztI0XIgXz+2QWJXPsjLB4CN//U5xatp0mcmHf1mRw8nLIjtkvUGil8WzR7SeBC98satbe7ndrTQH9Pidctg4UVy32AxbNQlqTs1DpgoXc8k1mxTHqU1UQJRjI1w9IuD8qVMQqJXsRRMgqEASvbOoB2jNvNc6TAJjtvSRv7d9kfud3OgPlekq2r7cCkFbmPIRzsIixxL5Q/hBi9Zhprfrs9bhFiZGK7YmE53qBRyH1+fqnP6ZXWftE6xJ9uHcL0u4B5U/Uxzsqwz2cVmTMDJoZ5DqpekfdGy+oQw1X0jH6Kfc1JMqypANr7PEiTauk
 8Krm7X4f
 HS3hG0B40ZUrHVjxZwK75IjxourtWIukdBDemakA8F2O8IpcWmeOnVQFfQ815Uo6WWJkwK0xritboiBafAEDImok9KjNXokuP23nNqkebbvKP1MUVPSweaip/xayAeA+CofFQwzD0pwzbeLIHv0sytmadefFn8eP0RdKpZ+llrXWGqPAZqjV5xWzUGXdjSBlBfOH0r/ZTQaj96v8VOeIvltUcTGItys+qyRMySCffqxIfInk+K5TzB9nVEvZnHmE1iLpUS8bCL7TFT6jprT1VsR1uduN3SdUjOzAn6hkbwi2KKS5RRjKktFd8OIqv1aVNvuRivhP+hv7iK+2YP9E6577i/L8s86bpBrHXNyRVKQHpbljMSMLA4KA+0oiMiaMnpvyBBAGKmX+zrSQVoGVkCWrDBFhd5d0CTQh5Y5E7l7nf2upnGuWa24QQhqaRdfnKv52AjkPKgUQRxPT6YnJVBLH89Xh9cjMbjFI5+3a8qzGTFoSC4kF3AeVf6uWil5zjHNjE+ojIxjb25fusTal++jkMSr/+hkKZwiYIyID4bfcFrs6xZZLouyu88WFfKcR1XPNkKOhe+vIPjiedOx9/cuM1oezRK3OxjWMZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Mike, +Pasha

This is currently rebased on top of mailine, also can be applied to
liveupdate/fixes with no conflict. I would like to know which release
cycle we are targeting for this, so That I can rebase it accordingly?

As for liveupdate/next, it needs some conlfict resolution.

Tarun Sahu <tarunsahu@google.com> writes:

> Covvert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
> This series also takes care of resolving the bug with memfd of using
> phys_to_virt before checking the args->serialized_data value.
>
> Tarun Sahu (2):
>   kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
>   luo: Update serialized data to serializeable pointer
>
>  include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
>  include/linux/kho/abi/luo.h            |  6 ++++--
>  include/linux/liveupdate.h             |  4 ++--
>  kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
>  mm/memfd_luo.c                         | 18 +++++++++---------
>  5 files changed, 39 insertions(+), 25 deletions(-)
>
>
> base-commit: 0e0611827f3349d0a2ac121c023a6d3260dcecdb
> -- 
> 2.54.0.1136.gdb2ca164c4-goog

