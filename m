Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3900CD4842
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130146B00B7; Mon, 11 May 2026 07:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1070B6B00C4; Mon, 11 May 2026 07:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0433B6B00C7; Mon, 11 May 2026 07:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5F746B00B7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:05:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F1181206D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:05:27 +0000 (UTC)
X-FDA: 84754857894.01.3B564A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1135F4000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:05:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AFb7kFFr;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778497526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlgXK9fh/c6tJ8MpzfSz/1fsc65vT6RTYi2FsbqUuhk=;
	b=Lm18Z+DSwDs5takYCkcAVmk8fmOgAQEoRoDcT7rUzl7Vsjse/ZPklA5CBYApEHQNgU6uWh
	HbD55Voj4ahib3iiygDDwnYTECv3P1nUIuRubKTMbW5ty1RPpon4ErehmQrdcBrq/CwuDt
	6fASLhVQWkG1NJbmZ4LVIpvTJvLDF90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AFb7kFFr;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778497526; a=rsa-sha256;
	cv=none;
	b=JvXUc3wDFXnv8zwrbuoLw47i9zNPHUhd2YGj4s6BlB3scODXF8tt/5qrHActFqb7xxhpNy
	cSq6As0gKWVdjPIpHtUN6hP7FyvndycI15xs14R0u2UCuva8W/lu9htoff8RQvuB15UxOB
	b1hoByv3JcpCoi5jnkbcKK/AHcv/zPc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7257B600CB;
	Mon, 11 May 2026 11:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15789C2BCB0;
	Mon, 11 May 2026 11:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778497525;
	bh=BztAq8w5VK1b2+D1NkvixBxhvrkj9m6ZLycQeOZt3oo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=AFb7kFFrakJ+O+jIq9DJ95cMQOTl61XQ/4sHtzYYZqyQCviZDiQzLDqgQt7e27XuY
	 iC+uHAtm/SC2kbJmzJYRtHLEjiTxtZgqKN7wf7rNoS8P6cRmII+qOOe6ZsM+XQ9uTg
	 A//Z5SCKYxT6VT8GnUl/0o5bKJOax0kxZEKZjVHn8W6q672EhOPi/KOCHWElpDSXHs
	 Cg3LvoQ7KrKXB4aJKttls3nJL7CcRSWeo4qhPcQU9hC75d12Ph3VvqG+D3QwcEujum
	 cCTvbypIMDtzDOO/tsg8TjldwDHZOF1M89vfkGRvYtL/RRZD+nqbraI2wrD889SpVK
	 4+AfaswtV6ZqQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jork Loeser <jloeser@linux.microsoft.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kho: add kho_radix_init_tree()
In-Reply-To: <e5e9c15f-a030-423e-de79-757c20d084e1@linux.microsoft.com> (Jork
	Loeser's message of "Wed, 6 May 2026 03:51:07 -0700 (PDT)")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-9-pratyush@kernel.org>
	<e5e9c15f-a030-423e-de79-757c20d084e1@linux.microsoft.com>
Date: Mon, 11 May 2026 13:05:21 +0200
Message-ID: <2vxzqzniciku.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 4tiwaygreguni3urk731qf61g4n6kwbg
X-Rspamd-Queue-Id: 1135F4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778497525-973197
X-HE-Meta: U2FsdGVkX18MF2tmIYkp0nx3u6CSdpjS9JP67Bo7vn8Q9Xly1fUpM8SWBaYHEW3ajRTbgE+/xk7N5kdXPfy2ebW810pucscUhq87GG0DUa7XXEws70ffSV8PTasARlq/9Bz2bsZceLV5J3w8W2TNbrc+UYlVLK53LuyN2Qhpg6gnh6ZR4skkw7ri/flPxf+glAWqaS0vfoEGXBh4lUTLfA/qlEojkztCznMM4v4GkXrwBfO0YPmTLc4YeVABBMa31H1bL9UgPwmLcdPRRD2UCSC+gQT4g+du+MLIsKVCLTO/F+gGnMXkwhutiafNCZ/gcA0V47bUhLrCHKbTuglXMbz14zz0JLKEqZYhXF9GHpK5LfSC9xBRxSnrelPQPiw9VuPHvOVMHlln1QZvKnkEfUp4RQuYeI/fzcMegssc7q+msz7Ah3MATUAa87NBynVQzx36o0oZ5wfkeBt+RoiT/tg9pr38VB0ur04oagVAfB5dF1it6mHRAiE6LV8I4rRQTjaLa8UZAB0kkn9trGQ5RSphn66fFKFM8G+KhJHRj8pf3LzMGg39TL6eoirP+qrP9YowwiCzEixgOcHswk1KGinfQVaNN6NU8oZRaLgaRh72SbGn3QeDilz8wQJO5Mk5k1KoMeR1WJz6ewxT3YCGf7JAxsOJwkZQthD7SdN4nUyWJ1mdbBcUUys4hj3K9IXRMQ10lOEPE8sFwpOKlCR7CDvHBgh14hGkYPSsHScmPl+fEQjVapDMnSuJRA77EnHSEX6x0AkYTIMBUks79b68NznzgOAX8coPbLx0t16JBq3X4/dDNwvy+RomZnyjghnnC6nJt8rokKQ865t9WFlsZzGUYQE4oLqhY03FEQvEeo2CYaWfK1qal5L4hFolSwBK905dXZBVf7MOp2auDnokiwEGByr4b6T/4i9TOV+N/w79IEO+HBn9QWEPQgHiqW21shiXMezPcMyYFNDz3t8
 ha8CnAtJ
 bQi6OnfllObMXXEyla8pRZImMdualutVFAZ9xgmYDg9ABm71KiZw+TFJWul3YplUEadmscu95vM7R92PLKjhduqlWI1/WCSSgux5R5mWYjIoO9BlTjR7jxWZMEhraqoNtan8TL5a5gBIfaNp/mQSbsreG4NaI7v7lcFLlLjcNvgmsEjin6VsHPTr5dZ0ZVzj9s9qRejsTiWuet5cxurxwp7V5lnmoD984E0nOOQe0sG4Sx6f3tMn9FEB3rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06 2026, Jork Loeser wrote:

> On Wed, 29 Apr 2026, Pratyush Yadav wrote:
>
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>
>> Move the initialization logic of the radix tree into
>> kho_radix_init_tree() instead of having users open-code it. Makes the
>> boundaries cleaner and reduces code duplication when a new user of the
>> radix tree will be added in a future commit.
>
> Consider using kho_radix_init_tree() in kho_init() as well. This will also
> remove the kzalloc() one-off use. Similar for kho_radix_destroy_tree().

Good point. Will do.

-- 
Regards,
Pratyush Yadav

