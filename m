Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FADDF46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BD56B0096; Mon, 23 Mar 2026 11:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CEC6B0098; Mon, 23 Mar 2026 11:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562F16B009B; Mon, 23 Mar 2026 11:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4523D6B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:30:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEBD78CEBF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:30:28 +0000 (UTC)
X-FDA: 84577714536.03.66C10D6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6BB818000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:30:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pQbZd86d
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vA9Ij+/Q609Elrit4GKVMFUpunbjkkcelYfBBicOZm8=;
	b=3yS+XdJv0fYhb0s6k/V57vZrxc94DCx8Rg5HhydWt0xY5Wo8ywofIVgdooULxqa0G1SbjR
	AIT/eexLA9SbVKQdrTbzBx9N0uRKWsDtY4mFRkmLSAad4V0PB5NkTWNcMCNsTjZZuTh4AT
	0gXvmpGhVotrlkBA2jRRpV0kIwE/F1w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pQbZd86d;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279827; a=rsa-sha256;
	cv=none;
	b=JVgqgAUxkSlQ5xbQiyFoPe0Q0jY0r8OjWx1KBqtxjceKk6n/vzAqg9IsBqIiI+gpEnhdKf
	j5wowJ8cGa6kX48xJkgAtJiTLrh1nn7f94Zw10yoxwrkDoStH2PIEdqs32Pbipja1LncDg
	pPjCvHQ7i9VckNV3yiaDlAYe0jkg+zE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=vA9Ij+/Q609Elrit4GKVMFUpunbjkkcelYfBBicOZm8=; b=pQbZd86dJkBY+IABU8IfWALc7/
	eX0tTVb//7xiwJjPIeAy2agEmkVEzeVBVRk5h0znczLx0j+zkfAoK0dpHa7wwfYdjkpQZnolPrKlg
	txCUumPNhV8eRkdDHWEhTuxyucqmKBEawdCxodRSWuLlpJ+vRFmjBUqx2E6yd2ZNtUbqzAbVQhpz0
	CmvBS6GznTaOS9KupgUzn+kN9qdSN960MEnt52OXxPZs8kxCIlC4JP9QXwmGYoa1wDLs+ygTQZBPf
	2Ey6PmZLCIGbVZPzj9xCdgxL2/+FAt4KHIl4TTzWzbh5MaAuf+WVcFmeH4y94a0HizrTfy7dCI9Lx
	uZGP3tGw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4hEI-007cwM-61; Mon, 23 Mar 2026 15:30:09 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] mm/memory-failure: add panic option for unrecoverable
 pages
Date: Mon, 23 Mar 2026 08:29:40 -0700
Message-Id: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGVcwWkC/yXMQQqDMBAF0KsMf20gJqKSq4gUHaftdBElsaUg3
 l3U5du8DVmSSkagDUl+mnWOCFQWBH4P8SVGJwSCs6623nkjzI9liMqmkqrxY+tt2zAKwpLkqf/
 r6vrb+Tt+hNczwL4fFUvRvG0AAAA=
X-Change-ID: 20260323-ecc_panic-4e473b83087c
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2276; i=leitao@debian.org;
 h=from:subject:message-id; bh=ekE5Tny1Xx+V82RXRpsHJQrWTjL4oleJkv6o/XxPjgU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpwVx9HaGZYv84Braytk/T3MaYFLeRjmkFLt3nd
 lL6I4QA6LyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacFcfQAKCRA1o5Of/Hh3
 bZnpD/9bXyyF3qL66jdVZN13ptQ6egI7kVu5i9rWvbW4W0vl+KI39mdkrjpljDbJNw2aiD4KzmG
 2JCreez4/a/FpHde6JqLnHb+UUH/kZvtqUZP8lBRxrca5mvrVyRyaKl743xws+IxcmWp8gOfvsU
 i/3mSQBWVsOgMuzTKvcFmZ97UmvvnFc6h3LkZB9JGWwnE+2rNeV54OaceEnHSCN7EKdpWS8FDIE
 G7ZHohkh9jn4EaJVs8gM0YSnC3tZkYNiS0WOE6ndi+GP5oarvTWgpAVRRxzxQySqYw7/iI9YhkS
 N9efZWxB0MMftEerilG5ccle3A7GSWB+9aQ5QEywSTOW5XIa0QLwZoP6WpCOQijw1MhDuiPMq+g
 FsovOV3ziI1tTRV1UWQ25yiUGVNpPUgzIz+oD3Y2Uzlx8FHDEHkqSvYP3eq2fksFYxE8+kPf9n9
 vktFMGCOiB4mw5VBp66Y7B0Qu9UUmJM6EaTJeXOmCrk0RUtP6RerXbUZVwNHljMyfJ+j5NLn42R
 dL8gK1tFKszjVN32dWwiX3N0at4cSKUjymOQo1YbGM7WHIQAs3aFA0ImqIKgy8x47eEH60zYWHH
 s4nLOPbQbdAZpdO113sR1ibe5F2sFrXDA7Mk21CnxonY/hqaJRkmyHn946cwF58rINxlKZcq46U
 fUKvxUnOz6Y573g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: wdjkn55hjozotdqfmyixjzjor3qqzppw
X-Rspamd-Queue-Id: D6BB818000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1774279826-61290
X-HE-Meta: U2FsdGVkX1+a3mSeocicI2I+g0T842n2aVqcBhxp1OVCoUv9HNLr1aKITnd0Z6/0bNJG9htfEI5OJct3qKu1DXozL7pxoq9ouKJw8UmXtjygY0+SUr4nkW2Z05O1Uxs7xyDcmnWXIsFUf6/FnlTrD+89OfCeURk2T1r+gePAuVfXX4+P/2bZ/X5dWJW7hiBXmZ2uFc4XV9nNR0PxSBLsc2S3/gOvELZBeeGD10eWigdeR3xREqmOTUYnFGOTuj6i2Z5QiQdZ4JGyOdXtsB+6oCLbc4AyPwnnoBm/53iNZS8aOKDFasLu2LpNdDYi42sCR/SxWMA4g6d53SHA2zYpDXNDxAI32g0WHS9i0XgPCURAFqopai3VvoGuzPwWtxb3at/aTeijMcQFZjlsJhK+f4f3TduzqZX4I2Yp4BtHgPcYpK9Gbv9MsdmRphk23KWhezDu3JbUU9Uz56Kcofe/bUmroQRMexZ4UW5ac+HbqCb/byla/ikx2UWpsOU6ZqykL69nppkLdCDBwS6zP7QumTo+tBy8kUnBfsg/9KANG93pRsfl1efc1EeZ4uuCDkJCut4DsT+3M7vjvUc6jojjQ5JouXtE6NaRUftkdQUVPn6xwYyVOn/UfkzFcpr1acL5Y9NUyr3s+EnHQR7a8y/nIFknCpuQdTa1n2ZB5ZGZoa8WqKr7/Dt3B1/gnZqvyVfr8r+IZxW3HjMRo3kmPl2UQDBJ3oP1wHQEQKI4f2DGor2C0F7VuO7cbiPT7KBWY2hvGJTInMM77NHD7QqbZurCfbzzMWww4deYd2eGkw5Q1f5+FYR1O4HwQkEuL4/AldmIeiQ1t3gM1c/+/3bDmbhXVyegG98r6H2eE39Ml0eyXwf+uMT5amldxCW+SQcZvuGF/BZlR+1mnxOLmxarrH2IwuJ86qM6Hx1vq8t+IlNo78lOpaIfga4a4B1xdAQ/MSEXr8oKxAd7OR5nUONaybK
 rN60R+5j
 mBcU/hTHB28m0CGSrBLAJOWejfhgV1wbn6ElxLJTsHhkUDGzT+dHAqwccBjaS5l6AFKOzfglqK8VBNkhPLdOW1EVWoRX7Ju8SwO4oUb91Gvrzd6oBZeGHFjbcIkPptnqEh9ZGiylxOt0GeWLuYXEks4q4mRg18cFmTZtBhnHWk16mk+fU++mW4cZb0+dciJgXtbKDBHJ+vuqcJVW111Ev+BuxIYQPQ5Hxe+w6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the memory failure handler encounters an in-use kernel page that it
cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
currently logs the error as "Ignored" and continues operation.

This leaves corrupted data accessible to the kernel, which will inevitably
cause either silent data corruption or a delayed crash when the poisoned memory
is next accessed.

This is a common problem on large fleets. We frequently observe multi-bit ECC
errors hitting kernel slab pages, where memory_failure() fails to recover them
and the system crashes later at an unrelated code path, making root cause
analysis unnecessarily difficult.

Here is one specific example from production on an arm64 server: a multi-bit
ECC error hit a dentry cache slab page, memory_failure() failed to recover it
(slab pages are not supported by the hwpoison recovery mechanism), and 67
seconds later d_lookup() accessed the poisoned cache line causing a synchronous
external abort:

    [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
    [88690.498473] Memory failure: 0x40272d: unhandlable page.
    [88690.498619] Memory failure: 0x40272d: recovery action for
                   get hwpoison page: Ignored
    ...
    [88757.847126] Internal error: synchronous external abort:
                   0000000096000410 [#1] SMP
    [88758.061075] pc : d_lookup+0x5c/0x220

This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
(default 0) that, when enabled, panics immediately on unrecoverable
memory failures. This provides a clean crash dump at the time of the
error, which is far more useful for diagnosis than a random crash later
at an unrelated code path.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      mm/memory-failure: add panic_on_unrecoverable_memory_failure sysctl
      Documentation: document panic_on_unrecoverable_memory_failure sysctl

 Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
 mm/memory-failure.c                     | 15 +++++++++++++++
 2 files changed, 42 insertions(+)
---
base-commit: 63f5f5ffdf63d9c75a438c92be58177744b4c69c
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
--  
Breno Leitao <leitao@debian.org>


