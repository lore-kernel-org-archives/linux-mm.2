Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4ADC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A5E6B0095; Fri, 26 Jun 2026 21:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBF46B0096; Fri, 26 Jun 2026 21:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAE36B0098; Fri, 26 Jun 2026 21:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17B036B0095
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:15:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66B3BA0634
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:15:26 +0000 (UTC)
X-FDA: 84923924652.12.8FC4AC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1A346180006
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:15:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eRijChH7;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782522924;
	b=WwBSzXwLY1kCzL9TUK/JSYZrjNW0EXCT1DygHAf+uE2wnloBk7Uk0+DiJfCobHei9hh5l4
	UOMQjJxl4qmIp5M0vdljVF2MGkkDSlfp644NnebjNPcJCE9mBN0zvmhjwq4reNYGc6q1yr
	C98gLS8HH2RlV4tpQKiV23v2V3HSXUw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782522924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLJ5TOEA9rVIC++44a9X+rZiss+A8afXAIT0au8ZBwY=;
	b=GVVV7IZY377e4fDPbHbZZIUSk9MmvUjzLLN3XmV56xRGY6BxgnA1roN+lHRLNq6iR6Kt0A
	B69jGI/adcM4myP9zwgtDlWYMObG3BLFK4yJVu5yS2uNZfGjT95Tx2EniRNDAIYgx6QYMh
	HIDzg16xsCDXhrp/H/op+9YjP/teatM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eRijChH7;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23FFD407CC;
	Sat, 27 Jun 2026 01:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6739E1F000E9;
	Sat, 27 Jun 2026 01:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782522923;
	bh=fLJ5TOEA9rVIC++44a9X+rZiss+A8afXAIT0au8ZBwY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eRijChH7hPI8FQrvyxOA6XwB3oZd+U8yhx7GmPkBzMciwI343yHaKiar3FSyWnnpD
	 2GDfRG0alkoxC4Ht/XLyIRq0lLNrGZMqLaT1wkH96LBy/JQH+YZeOSzHLHCCkgUe+p
	 UJZAyPsG59qysX0Fe6voMRQ9XjFlG7Suo5v4+qJs=
Date: Fri, 26 Jun 2026 18:15:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Cc: "Linus Torvalds" <torvalds@linuxfoundation.org>, ivgorbunov@me.com,
 Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, foxido@foxido.dev, harry.yoo@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
Subject: Re: [PATCH v5 0/2] mm: improve folio refcount scalability
Message-Id: <20260626181521.9f5782ba31b0e8321c1d74b9@linux-foundation.org>
In-Reply-To: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
References: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: q85441y3pj4zgtcyko1h4eny7a8kpg48
X-Rspamd-Queue-Id: 1A346180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782522923-581453
X-HE-Meta: U2FsdGVkX1/ig9ZzMV+DeuHJyyTRIjfp6rwPZKkW/2XK84tFznSbeQy5hmszvBF6raNoaGApRiy6wAu6cz6yUMT/+QNUEtC4/kKf1AvmhIVfStjkLuvIaOHaIgdCixDTxWlQGmdM8ipGcto0gBg0x/2L6pqvtwFwZSzFxLOyv2J5KshY1QqONH1xPxZ5oj61Epn2z1VDIqDt1W4CZ8Fjr0fiHkLNS/B79+GTwutK9fbqCjBdqZBf9JmwQ0YtaVzVTjHuHTpsk0e/FX6lUWQaYk/NPZoz6QR47dA/etxF4BLYQ33kpqzUzV8ADGMxAAJVfKsLhNr+oSC/srVFwVTnqh/A1WOHCMEkWrgs/GWSAAOkGhhmMEHjzY85wzRiAK8JjstISoe1m/bpJpNlAsmW0rNrSMxgnghBYZz7Qf+hzRmX0rdKTXIPtckvlEgvP3LEmhmDUrZTupAhZ0PDEym9CZmGRbgEQ/n96424QfcQvWm6BnjYisptQanpLISBPa8IGwjulyQvp4ZPEBHS1ZZTWLWZe8YKlQoOemEg7ufPPLSitDh0CmXCzSG20h4df4D6hIyNFu5RajZjmcejXmSZQCaZjbkqM4t0YLEszwctEjzs0LOGPYnRwwhM6P5eq8+WHqScixJNwnSlHVGuLAVgg3UbhlqHujfV1zl6rCgzgPdlUMSgQyXozgJnlm7ImrDoK2Um3Bwjwp+ZJMY+c57u3e/vkruvtvfKjFtlLg2FHL5dHEAZqBuOx24MRo5Xp+0MehIVS0rZwvE44JM2ONn6l+6yuO/MGEc02cADrY9sR7ts49a+USbrObejDa34wlstfJ0fFEM8pNC5SqAWKSso72Rkw4s4yGdldZfEeXR9CqAgnnNPd6duPigiyybkMdyUPJvSV83buK9KnLxptfXWuUPWoW8fnX899ELJwyhHe3VkFfhtKw0m+x1wECPyPulbuRUAA7S7UGIbrOcX6S/
 srkJsoit
 RDHjcg+H69k4jiwfRDnkHFCVEeKic5CMlTC23J4IUemkJjh/Wb9WJHGy8i0Q6Su4FP1L6rmMROkKSC13CscP3aDTZjw7balcmP+lzTdrWJ8h5Rd/vhgNYnfGJWy7WCkqX0gAMLDWMEo0QeRtDdsrVfyk0kO6gScbLqK8l75YlE4CUSIF4sW58z/VW7GJtJZSOCxTyPe3mmqilHp/j1KALAxZ5su2zDLynWldVHlAxXg3b3boPVynLm7SkOkwMdhnr4x5OwpD8TN0Nt0h0Y9xPmuuE1YnBJw8QAWKV+4ycrPt4oMRF4K3J6tZ1jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 18:44:58 +0000 "Gladyshev Ilya" <ilya.gladyshev@linux.dev> wrote:

> This patch optimizes small file read performance and overall folio refcount
> scalability by refactoring page_ref_add_unless [core of folio_try_get].
> This is alternative approach to previous attempts to fix small read
> performance by avoiding refcount bumps [1][2].

Thanks.  AI review had some things to say:
	https://sashiko.dev/#/patchset/bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev

