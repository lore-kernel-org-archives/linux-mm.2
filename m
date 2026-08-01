Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D65C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 14:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF846B0088; Sat,  1 Aug 2026 10:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B71A6B008A; Sat,  1 Aug 2026 10:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4DD6B0092; Sat,  1 Aug 2026 10:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA486B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:03:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF51B12030A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:03:37 +0000 (UTC)
X-FDA: 85052868474.27.7C55ADE
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id 53DF820009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:03:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cEDQsNuM;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785593015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqzEYyvsxUaoTo7q5N2srwBhq/x6rJ9uYS3yb+pyTCM=;
	b=RkAS0ivEb7rvvm7N66YGmTNH9SL0vW2KE3hhzGgSza5aFfSu9tQsKzXu3WZ+8Q90qzT7Dh
	4rghwJ6/WaLsMts+PkSa19LW9Jnk6k96I3VEPHL9ijpebw9625BLQrXFiOXNf58R5hPXy5
	54O/SW1VubEU62zvqYSGWAOnw/xj3A4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cEDQsNuM;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785593015;
	b=E4od9VtBZQyTmiXcdD8OLbXbK4QYURa53XOL9vKCkXIXk/pZlKnh5jiRQhWuNYlzH5U7ji
	dLKI2Qx0Z4bdc3v7SXEw2B9Yue8AQH3TxvjlXK/Gci4NcFPGv7P3zqLGKLlwZ4IJjDVbhl
	7MS5cd0eKnhHi7JdZgWRXbo0Ip3yq3E=
Date: Sat, 1 Aug 2026 22:03:22 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785593013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqzEYyvsxUaoTo7q5N2srwBhq/x6rJ9uYS3yb+pyTCM=;
	b=cEDQsNuMU8m/3kJa8BRPGCCaVqA8r7jf5GBr9BqwksvWQ/PAlqBsrBozlWfigSsa3nLSoD
	V5tD/fjnuc0ccF7kNC9WdzxKuuDZ3jOm2kTSbc1ZkPmRPmyg36zpt6RYRwuJiEw4c7aKdY
	A2CajIn/zJtbM1ar9ehSkRM6ioD3jLk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, keyrings@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
Message-ID: <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
References: <20260731154608.153258-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260731154608.153258-1-linux@jaseg.de>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53DF820009
X-Stat-Signature: texp9gxst9xa3m8xoy184ydipjgtsh5q
X-HE-Tag: 1785593015-406596
X-HE-Meta: U2FsdGVkX1/vNJJnh8wxEfqomGi69PUI4fPVTDWdU4phfu3i//HQm8aKynecwEAznAUQ2ZHEoCimhhpV0C/qHgnduYdnNhGj8QLAu417/bT+HARGrV/HSOPP0NLSLPSZFdzxJlFx57QN+niUfFHPnHRLXE0O9htx1HZyOLUSZa6/Mdrcf/CnrexprG63iEoAMwpdMv8rPdj2pAdIn7wjFmjUXkTO9J6MkdBoTMBGVZ1TstGDi7cAM4zRqK7eIgfHHMyiCg998RjD7+t7bC5POwPGGi3kVw01eeyeznd3zOmRWbUQiUkfMqZ1c9bGUVUOFlKUoZAecpe7kKSoysDFLc5+XuhFtivO3kMXiwaKV1kL3wkehXvAD6Kz6bHih/Jh4JgnKSycbwEOCq6sHKXUw8Js/fEDr9qRKN3iOVow/S/WSXsGlKRUK5rm7+wNuNiwHsE4fNVC56n8sPWNhvOm3GZHNlgDr6SRbsfhIWykrPn2fUi9/G2K/kJkKdAmMAbbTdhiYs9qfYQ4rW8xN/cNqk49Sw/27JIxQlwh/YHLSGOR6LAh6Tid10Wp70+UXfVDaTeKORo+kvyWg/oFqjPvruQNfd4KtG/KQnZtnSaz87HscNw9S52MmsSpniL6dNzg7NhjVYGCK5sfdNg5rIl074LurHjzHL65v90NSqazo0q9JbD9Qo+youyXmzP4hubGj3ISfEW2Kso+MZ8fiQhTWA+BR8GQ0jvNg+2huKJ1wacgRgP7CS9TFBw0uG2mWeWJ5e2owGNvxSyfpk7zDDgttM0mpGJZKsTwTDd+8PV1RuCH/BTDt4W4Wc41s5ymoEUO5sUfZ7o2QYUQ0G5DNjaZxXa8lkb1YWmiOKN5QBtqtCcMs03PvgWI2gmoz0CK9IwKEe4Sr9MFRxZUEMoge9AwXSHpJmerDxZP1H8CE+rpOdxuuAzEX0lQ07Bvzuf4ojpgQHli7XTvHpsRHkIEWo5
 4SuOFXuB
 st9bDv57V72TVWuDYBDQTPUpf0+L17NfCopoF7Qg+mq0xFZRfcp353HqG1TBqP02b0LXOmHsurb4TpBAGccorLlwrZjKnwJkCjkmAIK+2yCI7oqqPQtduXXMSeFI+uwUiLXQCPEtUDb9EZ67B3am62hHdIqLWVfMKwhqHsrmI8hqmD4tMyFkYAz4CKO+ZohTljm8DKMFEVR6TPWx9Mb6b2ndf6V3YHUy6q4DeIcGejKfYEsy5DJJqRAoVDo8od1F046xFLM+dWsgVsCk/xdd107AtmMGcrB4IB8j/lvpsVe3QgUZ8VBQQy+XNAoex6E3bI/OAMa99PtXfYgMv9R5xskHRfXidLBJIJ9ofuI2MD7JAMsk3Xb4csyhZl/EXYMqG3bPDqw+HxVTRJYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/31/26 at 05:46pm, Jan Sebastian Götte wrote:
> I'm using linux on an embedded target in a Hardware Security Module-like
> application. One requirement is that I want the system to be able to
> quickly erase its memory when it detects physical tampering. I'm
> approaching that by using kdump to load into a small payload that
> instead of dumping RAM, erases RAM from start to end. However, writing
> all of RAM, especially on an embedded target, is rather slow. For this
> reason, I propose the mechanism in this patch series:
> 
> Add CONFIG_CRASH_ZEROIZE (default off), which when enabled makes various
> subsystems handling secret data do a quick, targeted wipe of these
> secrets before kdump. This behavior might also be interesting in cases
> where you run a normal kdump kernel but you still want to keep things
> like fde crypto keys out of these dumps.

Please check below patchset, you both seem to have the similar
requirement. Please go there to discuss.

[RFC PATCH 0/4] panic: a pre kdump notifier list for hypervisor upcalls

Note that we usually dont' want to run a lot of work after panic and
before jumping into kdump kernel.

> 
> CONFIG_CRASH_ZEROIZE is a best effort, defense in depth solution. There
> are circumstances, such as when a panic is triggered after memory
> corruption, or when a panic interrupts some operation that mutates data
> structures under locks, when the kernel cannot safely wipe some memory
> areas. The handlers proposed in this series will just print a warning
> and skip the affected areas in this case.
> 
> This series introduces two handlers as a starting point: One for kernel
> keyrings, and one for secretmem. Future places where such handlers could
> be added would be for example drivers for crypto accelerators. 
> 
> The patch series applies on top of linux-next but should work on 7.0.0,
> too. I've tested the patches on a Arduino uno Q (Qualcomm QRB2210)
> embedded target.
> 
> Jan Sebastian Götte (4):
>   of/kexec: fix typo in comment (usable-memory-range)
>   kexec: add CRASH_ZEROIZE to wipe secrets before kdump
>   mm/secretmem: zeroize secret pages before kdump
>   security/keys: zeroize key payloads before kdump
> 
>  drivers/of/kexec.c                        |  2 +-
>  include/linux/crash_core.h                |  5 +++
>  include/linux/key-type.h                  |  9 ++++
>  kernel/Kconfig.kexec                      |  8 ++++
>  kernel/crash_core.c                       | 18 ++++++++
>  mm/secretmem.c                            | 50 +++++++++++++++++++++++
>  security/keys/big_key.c                   | 15 +++++++
>  security/keys/encrypted-keys/encrypted.c  | 12 ++++++
>  security/keys/key.c                       | 44 ++++++++++++++++++++
>  security/keys/trusted-keys/trusted_core.c | 14 +++++++
>  security/keys/user_defined.c              | 11 +++++
>  11 files changed, 187 insertions(+), 1 deletion(-)
> 
> -- 
> 2.53.0
> 

