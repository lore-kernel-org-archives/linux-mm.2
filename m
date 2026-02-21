Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277B2C61DFB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 20:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F066B0088; Sat, 21 Feb 2026 15:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D4F6B0089; Sat, 21 Feb 2026 15:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E786B008A; Sat, 21 Feb 2026 15:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1033D6B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 15:15:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D1721A0541
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 20:15:53 +0000 (UTC)
X-FDA: 84469569786.15.B09F6A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C98EA80002
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 20:15:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCo9fZp7;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771704951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScbndZAlL5TLwTCorRi9fwmEwaCbVhAtPVNqLWFYN2c=;
	b=CWrdR1prfm9deFfa/5zkoLvMwHIHDCLgDi5WhRap+K2uhI4sM480vqd0mEOxUkfP1JcPrX
	Q6CG1B0M+n5zVDQ29B81G+vxB4mYCAt/+QXlZNTmNHA/3JxnOUZHwcDGtDgz603zMNzNFm
	SppfgV3usD8vaSqm2z07JbRglymgVuU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCo9fZp7;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771704951; a=rsa-sha256;
	cv=none;
	b=p5aowGpc9rJkX3esV+ME3hqrxnzarc0R/l8PvGXGf04pCWGdoUdTL4KXt3HghhJv4PrJDW
	V3rFlIr/BgKdiZH1G/tgRSpj25v6Yx/Ww7q72jSHd53ndzyNmvacQqaJn1NVL5/5ueqB82
	4MkpikaXE4SPQGOPGQ39XP59pRlU+UU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C20860053;
	Sat, 21 Feb 2026 20:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9048AC4CEF7;
	Sat, 21 Feb 2026 20:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771704950;
	bh=u2lzxOaYu+TQWqH/uMkeTj5YiPDYlTP3c0J6MrqedxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCo9fZp7C062sLKYnb7OW4C65uQt6vV7Su9amxqp2y7NcpX+SyTXVpfozk1KgWegU
	 vT5Fe75M1tJ1r/ok/yqcLxI03o6uWH646I8Y9U80iRIU54YLnzYDLIk0Bq70FwuUAE
	 P5laELfTfIeCqXu41bRPZcwZQ2Q0tVg0Vz1B4DfkOX8UA+rCuX5sT8ZhG96Y5klgRK
	 PHeXXaXQrinXAHLypUo64nJTtBLvJVTsw2JmnEmwBAqPkpyIbC3NTyFsJua6WLX2jz
	 s+d9W4ReAiCDFe4J/3p4GuU0eYLzEoankF9Uc4XkVkbwSqloEDPC5xh1Ao51A6mP8N
	 4SLvhdPfDO4Cg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 09/10] mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
Date: Sat, 21 Feb 2026 12:15:41 -0800
Message-ID: <20260221201543.99335-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-10-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: C98EA80002
X-Stat-Signature: 3wkguj5uqk9dkdrbuh3qund44d8mci95
X-HE-Tag: 1771704951-696279
X-HE-Meta: U2FsdGVkX1+8LWd/dVR8etl3Vv9wil8WMJMuCHKBlzv+PbFAGAlg2zQMDODWRu1y7rhv3YdGpteJl5QmXXFbtOyUoiqL3a/DEuiam+jrFooA+jvYGAvI4HWnLTJ6uaKVA53EQyKCC7QqGxj6agZebT5td0i68YTr36fwYEQ9U9Wua0BtE+s/WVZUptqjtiHJFqK6SxuiV9vQ4QXctiqlwILhzQ661sLAVmwxmThmGKo+mfFs6xnCeDW/dFqoPW1PxFFIqiLgimnHv6BtmZPR/qY/OlYiSycx40BRaWqTshNIx/2pR1NBfciNiIQoSStu+MTkxpEZMUPVig6DM3b9kigjJsf4C7A87Ba9yUcc8QyusXfMIswO0E5bQQErx1KSViXnD4DOLxxXGCPzmnEhNt5//Io41WTBD9yA2y6Cz06L6BHgYsgUcax1BaRQYkZqeCceRe9TZJPH1b/cEUYt/oifTuq0iVT8FO3H8xPksvNLf0vREYJhbIYbhq2C+qQe9LsR/IJlE70oXekjwKksagoQHId5cII0+8avOzfOnZFKkF6UlxcC2IWzbS0sTAyyITjtWeqi0Tb4ytOvbWckQcWmjTRS0OhxtZ6/QfSbyKE9YLgTwdGpTxsxdgCR8ItaTafKgaG0inV5+hiOt7xotDa6VqyhaCW6nMajPzceDdb1/3A5UqW/omJNjDZHdmItFNhr1pDPjGalZZM2IAT0aIqy9egxQmgxNAuQTU0ix7kkUoWfD3c9jqcnMtgTXXU3cQisHhVUeQdXt2SfmwyJjpxbFPt3rEU7obBu4yZgWO3JzmzRqV0vkfYmHQYAac35GpodOK5J6Nmfb5v7MURWnPPYRJZs8K6jrw0ym3EciFIIg+FVLLdC1biLiOFFs7G49+vwuoVHX0ynaJZmT6Akg9PzJd3GBdm4RLff8s/G1rOKMJAl+iru2BSVt2d6eiTtetPPQwAEgpkAehtxTto
 xpjpRhI7
 6gPk2AfLqa55VOFDvSIHEbHHQHyQ8AbK7LBd03ef0YXtn5TOMyIWinrskBeRobGnyHeQ0GrgGGvXtECjjuZq6sKrhfvfwRhjkYiWeRTFjFn+0WGR7v6TiDvW3CsL9yEIw9dSs3EMP75RJIhy8cCk/DzgctmNDE5u+JvP6XDDO5uUFAXCdp/JOUjxEOwQITNok2AF8EN4fCjHwlbP1sldVZt+CaWSOlZ/WkfOKQhecbSbGqnXbBq+HGzWtOCU7cB9zUWENyhzSbUHVMvAEvV32S9iXeOntg6AuAfjHIRY9ABq8PER+YQmsta9fZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Feb 2026 11:36:26 -0800 SeongJae Park <sj@kernel.org> wrote:

> CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
> setups.  Enable it on the default configurations for DAMON kunit test
> run.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/tests/.kunitconfig | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/damon/tests/.kunitconfig b/mm/damon/tests/.kunitconfig
> index 36a450f57b581..144d27e6ecc5c 100644
> --- a/mm/damon/tests/.kunitconfig
> +++ b/mm/damon/tests/.kunitconfig
> @@ -13,3 +13,6 @@ CONFIG_DAMON_VADDR_KUNIT_TEST=y
>  CONFIG_SYSFS=y
>  CONFIG_DAMON_SYSFS=y
>  CONFIG_DAMON_SYSFS_KUNIT_TEST=y
> +
> +# enable DAMON_DEBUG_SANITY to catch any bug
> +CONFIG_DAMON_DEBUG_SANITY=y

And this makes kunit for DAMON fails, like below.

'''
$ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/
[11:57:20] Configuring KUnit Kernel ...
Regenerating .config ...
Populating config with:
$ make ARCH=um O=.kunit olddefconfig
[11:57:24] Building KUnit Kernel ...
Populating config with:
$ make ARCH=um O=.kunit olddefconfig
Building with:
$ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=8
ERROR:root:In file included from ../include/asm-generic/bug.h:7,
                 from ./arch/um/include/generated/asm/bug.h:1,
                 from ../arch/x86/include/asm/alternative.h:9,
                 from ../arch/x86/um/asm/barrier.h:6,
                 from ../include/linux/list.h:11,
                 from ../arch/um/include/linux/time-internal.h:9,
                 from ../arch/x86/um/asm/processor.h:4,
                 from ../include/linux/sched.h:13,
                 from ../include/linux/cgroup.h:12,
                 from ../include/linux/memcontrol.h:13,
                 from ../include/linux/damon.h:11,
                 from ../mm/damon/core.c:10:
../mm/damon/core.c: In function ‘damon_verify_new_region’:
../include/linux/once_lite.h:28:50: error: expected expression before ‘)’ token
   28 |                 bool __ret_do_once = !!(condition);                     \
      |                                                  ^
../include/asm-generic/bug.h:185:9: note: in expansion of macro ‘DO_ONCE_LITE_IF’
  185 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
      |         ^~~~~~~~~~~~~~~
../mm/damon/core.c:127:9: note: in expansion of macro ‘WARN_ONCE’
  127 |         WARN_ONCE();
      |         ^~~~~~~~~
'''

I changed BUG() to WARN_ONCE() on the last moment of this patch posting, so I
missed this failure.  I will fix this on the next revision.


Thanks,
SJ

[...]

