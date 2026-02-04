Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3AFEA7941
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D406B0089; Wed,  4 Feb 2026 13:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEABA6B0092; Wed,  4 Feb 2026 13:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20CE6B0093; Wed,  4 Feb 2026 13:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B28336B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:39:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6971F1B1C07
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:39:30 +0000 (UTC)
X-FDA: 84407637300.29.CEB3A78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FE2A1C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:39:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AzM9PswD;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770230368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sq10w9mp01JehBW+gYCL/vI825m5RbW2tTMtUbtlu+U=;
	b=7FKcf4YKCqtJhkdsK9pGbOSmOvreX4+gCvdfaBBdzFx3ggmKzKAmZJtMmMPwfhFjklSZFw
	o/dDRMS4XFWBYcJ/RvXx7AfePYorLJzpkmMAik4NAYoO1EgfQZ5ZGCKUuXg9OC9Zsz1mJu
	7F9YA8B+xSb1Vq1LvGLVahU5Zkid/Z0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AzM9PswD;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770230368; a=rsa-sha256;
	cv=none;
	b=1Ziyszaqven4IhO/5Z2AQVqc4yASlttssc2ZNgY4ik3YLmovB95G3wGe9UhjcnLllrDNck
	/LHrjMgM1cKADeFC7ZVytTMN57A1zIVctnF8akTb/bMCiBeuYT2SYLgITPCY2iXVRWrM7k
	1ZEpElTNB5/xQP8V/y9fkTWDzZpC4Fk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0068F443A8;
	Wed,  4 Feb 2026 18:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DD6C4CEF7;
	Wed,  4 Feb 2026 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770230366;
	bh=eFXYiDyxDYUB6JOD3ot86OdVYBZMkI+eBQk1Lhhu8j0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AzM9PswDjHjAkz6T3vFt6SICBKgk1v3X79cQxFG2JfNH7S3cJ0qF0dSeWeX4nivZ2
	 oCZLVVdapJSCo/6JBadydcJmh4dGPbDG2QBn3B+tm7M6ICdB5K0obuE8vav74gOtks
	 7Q696AonpWUAL13woaegLufSvCP6eUplcqQ8b414=
Date: Wed, 4 Feb 2026 10:39:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
 ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com,
 senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
 linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
 ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
 vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
 wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-Id: <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
In-Reply-To: <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
	<nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ijijduj1c79szp4ucwxepsjx6cyqdbtk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FE2A1C0004
X-HE-Tag: 1770230368-765118
X-HE-Meta: U2FsdGVkX18AchnQtJ9wRlsbvQElrV5KoZ8sRTsdzsbFq16TfeFS8sELJP0ld9OhUzcatw6frS6fLgQkQLhaj7XBOkRJT7sdXu4WRiDDwNqVrc/am/j2OumK5qzS5SKqdQcFaQKIPEpGmxER5SyjSd2KMNAf592m9BbCwzvDSwXms3BCFbqvXsfC5Xu951kA974zOBFG0I9RZ7hrVdW3YK5Hm6T3dkBzd21TM4Zf1kIdUxUgfrbbzNcVhk5HPr0Pq0dGoo1xtR00rSKmd+IxIaab0y+MELJq5CIgdNVzTFSJSmF1Sm9Xbx6me2ojMP5AdHmWctl9mAWYFvsj6bHIjhoAoCWPzFo7NsKlRQ9kmamB0qM3nabv7Tq/7Upm66unTTAof1Zj9lnXdrhOhnELEi7sofAsi/Hmrt+DkNif4P0UgXiDtzwRyoLbBs3heZk0J0PGw195fjug1b+EIOFFj56bmII6Z3RUwnwy5m548TcYO8hqoqovhkx9iWV7W/1ex3ULNYcG2LtRgyvQdC8oP2kzoQsSAyUGp1DsErpUM0ZresAhb3R3wUgWLJEGPI8i1Okre1+slqhIZ2IQq6kPPRK1dmzqy/gDCo/1ntXyzkN2RwCmnYrkJ+esHC1GVpwykgplv3wbbKXaZiY0nGEDPoM9/zVtzwok5oCjBiKcPL6pfhYS2xgaWMNFk0Djj5vMpAqaBzO6X9wMbVFynYmdv38TrenvyyroGQ0awt5CHLhsrm4oVtIRwNKM5BMYdj51VxYENhZOj5KyE/7Atqcm1h1NF31L6CnnPVSNVE9TCxc/Xs4A519DBSZODGBsIzgAVFYSs0qnjgrgXn/A870PADqCVI43f+rfLbwdKczYGn6OAG/6u7oXo8td6vWnQCLtCgcOZ/jQGoMuD9AUVsRCbFKXxxj2QvSieYhEBZxz2Dj9CWLan+4Iidr80qYAQ5ooIkzwOm5pR4SPvpDqXYK
 qzqtJUoI
 7f1Km6gNrdtyY5STN4/7DFA0hFX5ziD7tU03JCq47E+Yxjbq5ceQTg+zNumaWjzU3y3/bT3Oid7Rc/1gVNUU5mKAuHsiNgQNHWVmkEibB9JHgeX5nPFTSiTYX5u5O3dlKy5LqhuPsL9qp4RsEPFU2zlsVsw169ijX1qgItU7S7iznSKKPe2inANe45QHXf4pTRuZYz107/rhfpAXvbS0733/fxwcm8qKJzyS7fjgj6zCNG8Wm11L2ZDalIim3uZkaXdwvBX7LTQYD3jpO0OBEb+1hT8W5mqYPfkLcLBJOHjVXo/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 18:21:43 +0000 Yosry Ahmed <yosry.ahmed@linux.dev> wrote:

> On Sat, Jan 24, 2026 at 07:35:11PM -0800, Kanchana P Sridhar wrote:
> [..] 
> 
> I think this series is really hard to move and respin in its current
> form.
> 
> Herbert, could we take in the crypto patches separately (if they are
> ready)? Not sure if it's better to take them through the crypto tree
> (and provide a tag for Andrew?), or through the mm tree.

Keeping everything in the same tree is of course simpler.

> But either way,
> most review is on the later zswap patches and respinning all these
> crypto patch every time is a pain.

It's mainly a crypto patchset by linecount:

:  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
:  crypto/acompress.c                            |  110 +-
:  crypto/testmgr.c                              |   10 +
:  crypto/testmgr.h                              |   74 +
:  drivers/crypto/intel/iaa/Makefile             |    4 +-
:  drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
:  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
:  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
:  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
:  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
:  include/crypto/acompress.h                    |   68 +
:  include/crypto/algapi.h                       |    5 +
:  include/crypto/internal/acompress.h           |   15 +
:  include/linux/crypto.h                        |    3 +
:  mm/zswap.c                                    |  724 ++--
:  15 files changed, 3144 insertions(+), 1090 deletions(-)
:  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c

So I expect it'll work to take all this into the crypto tree.

> >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
> >   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
> >     resources.
> 
> Andrew, I think this two zswap patches are in good shape, and are
> standalone improvements. Do they apply to mm-unstable? Could we take
> them in separately to lighten the load of respinning this?

"mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool" throws a few
rejects.

"mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
resources" also throws rejects when applied standalone.



