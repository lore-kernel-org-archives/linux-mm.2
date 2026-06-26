Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6670AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574F46B00F8; Fri, 26 Jun 2026 12:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526146B00FA; Fri, 26 Jun 2026 12:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416986B00FB; Fri, 26 Jun 2026 12:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17D1E6B00F8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:27:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71CBCC2512
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:27:46 +0000 (UTC)
X-FDA: 84922594932.15.D65B092
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A51A2C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:27:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PQqM6y8Z;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782491264;
	b=VlFPEL3tn9Pc6w14ALn+3X1Wy1JJ8gYaMY45jofGNbZl6rrHzVYubst9AVY4JsbCu2kH/8
	pGpcHO6pxgh9wUkvIk9zXLwAXSPF90KVilrP01rCFk/5cWUH2qJouEh50cfl0PVRJnTQ6v
	hmPM4epa31ZaSX6RobFGxHGwwoqfXXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782491264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xdhB1h20JevoCIK0FA3vdUPT1iU5NQ8QI9Cuj4CG3U=;
	b=umoxOrbJ9pBKQdsSIgioxo786u4oBZhvm3C5hThtbUaoNc+G+zpyRU0dZYdUri8wEl7cUv
	ox1ist4rzXsNPFcb0qYfo9k9O/sIyqsFCtv72fROMtk+c+lBCkTo9KBRbymRHomnsJ2miN
	lJbghO/vuy1KhEu1O8awm2wB5+s4eeE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PQqM6y8Z;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09BB9600C8;
	Fri, 26 Jun 2026 16:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129131F000E9;
	Fri, 26 Jun 2026 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782491263;
	bh=6xdhB1h20JevoCIK0FA3vdUPT1iU5NQ8QI9Cuj4CG3U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PQqM6y8Zwq77LOJE9kupv7UIeWj6h/06JBTFkhuilrKOfhlxaX3dctYkVnn8BXe7h
	 p4nJis+WgZhlJnu+H/F9D7juqnDnGg3pyP2kzyGY15N9xdJerS2x0e0oumg42fh6wU
	 On9cS26zBQWDtUbm0SoX4z0UCj+TB8vYPO5u5xAE=
Date: Fri, 26 Jun 2026 09:27:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 lance.yang@linux.dev, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v10 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Message-Id: <20260626092742.160c3c10196852f075b3f5e3@linux-foundation.org>
In-Reply-To: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hzi8a1hudxic9u4s5jgbtjrh84cxuzsg
X-Rspam-User: 
X-Rspamd-Queue-Id: A51A2C0009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782491264-600005
X-HE-Meta: U2FsdGVkX19iX887sQOb+UfQEDI7yRfp57BxgGYFrCmky4n/fz6neaXkgx2ayGoDJ28QVSsFgOSdi6CHQIisC0LuYa0CJF+3EkcEhFLZkf+LIzeHAQzYg6Yl0b95L4MTi4FgxxkOD4CFI/7K0V0ioNyectT4P1wniNpMn8JOmygl8FOFLIq0WmYfvHyZ65tUydXxsozGFhzx0ACdJEKcKRihhiq84XUuoCEIK+Xr7JrE8bNFh5xVNNuwXHKhH5O9FAnLO/7f5z1quTWuLZMvqIZHpn22lnEavg+xOh4QWUMtCTxPEfbGb7K9BOlc2MerOKRaV2sE3KJ5AGMVWxrkR/JTr8FYmIG42Y8ZdmVVEEtE4/cGAv5DFWhg8HiSgfPoc73PrPFDNC/0FBE6QhjusLaFfCIte8wIldFk5FzcTqrejT7S1idiINc5T2vsW4Q81E9Ry7xWSS9h8quNHxML8mGLNXVLYwqBBVoQDtyo7sTgS0Nzjwt4w5hAgSYIlsujY/P9SwhGY0Jqc+jdd2ycj3C2xWs1Ugsjbhbiv+0IbWyV5anqqw56KoIQS7++lIEHTaCzsxuUjexWJRO5dygfM/5m/Y1IWMWC6LsNLgwaZPjbLLw8SRwE3/hY2bVKHCbQuLsnCrd99+809DSZM+RVqUtU8+mwylWnyCt8NuR8qiPwIgPQ+8oxOoqoGCoRd+JmztXIbBAEoEa4cu6oGlwDvC5cAH3Rge4XVUzx12vWZjoVCMGL59DsR1E8LcofCct1m8QX3r5CmjB3LqJ91AiP9aC/9vap7bHmOqpjuj5PhXIHAw1EHC2Wt1B4qI2Lx6GPmA7NqhvTrtm5GUgPr+ibqR3FUWhnLTiAZcr9/5LOt3lzki3GSJa9GYyBkDsAqlwpEGG0Fd/I423VolYYsCap8CKmUn4a0J4lNMImm315KrUO9fSwqrBQBa3B5nrxcQlX+nUbemA+DR5dFbs9wtE
 RLB5LwiS
 CKvwM04NDd5BeU1Q8Ndl45yVh8uPj4ocKcnPzmb+MzNAD3Fa965puKogGElOfjA3JTZBqatpxzh3LMiAfgQVJj3kTi4HZ7t/DAwZmwc3lQizPKOvijHPqxUMapm7X6eNs/zXnGdON9K/LhtwGRroUOXXJG9pMW2dk/rexFznvUrkIeYswQ2swM3KccE4xMj/YPQM9w2eoobgaXzjOTi59bua4qUAcLcr6mI6bzpKr38y8IB3FfEYKtvdDWE3Um//yNaf754+oM8xuXidz6poLJybAFgLSuNjwtDsT6ATLrAwFWFYPhpGgF6MwpxHAuxZAgGk9cX7B6Im0t4bp7WIMky1jkSMSOE1f6YSfV7RFbd71M2OBEiQVgvtmNORcsibWMIfgKTgrlC3A+JLnuOQmEBKtMzyXRdgzUK/8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 08:33:14 -0700 Breno Leitao <leitao@debian.org> wrote:

> A multi-bit ECC error on a kernel-owned page that the memory failure
> handler cannot recover is currently swallowed: PG_hwpoison is set, the
> event is logged, and the kernel keeps running.  The corrupted memory
> remains accessible to the kernel and either drives silent data
> corruption or surfaces seconds-to-minutes later as an apparently
> unrelated crash.  In a large fleet that delayed, unattributable crash
> turns into significant engineering effort to root-cause; in a kdump
> configuration, by the time the crash happens the original error
> context (faulting PFN, MCE/GHES record, page state) is long gone.
> 
> This series adds an opt-in sysctl,
> vm.panic_on_unrecoverable_memory_failure, that converts an
> unrecoverable kernel-page hwpoison event into an immediate panic with
> a clean dmesg/vmcore that still contains the original failure
> context.  The default is disabled so existing workloads see no
> change.

Cool, thanks.  I added this to mm.git's mm-new branch.  Next week I'll
move it into the mm-unstable branch, where it will receive linux-next
exposure.

Sashiko identified a few possible things, some pre-existing:

	https://sashiko.dev/#/patchset/20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org

