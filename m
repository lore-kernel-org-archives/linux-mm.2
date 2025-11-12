Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C1B2CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A840F8E000B; Wed, 12 Nov 2025 06:44:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A345F8E0003; Wed, 12 Nov 2025 06:44:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A648E000B; Wed, 12 Nov 2025 06:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6A88E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:44:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F3E313B0F2
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:44:53 +0000 (UTC)
X-FDA: 84101773266.10.3765144
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 747551C000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:44:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FyXu+/73";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762947891; a=rsa-sha256;
	cv=none;
	b=R3uMyTz+nW5Hn90TbJjT52Pmb59SWeqGHzqX/IllinSDp01Sqd/FkTVCMgMxiDo/cLAbPj
	blxaKa0etRMMSRDR/YBX80dypBvrntNaeiWijNsF1Z89yjdHWWNKI8vQa6b8B/cU6fU3RX
	dwqF41UpEaEdzbkdjcnjmEOmKDfeibM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FyXu+/73";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762947891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVsLPNAHvuU0RO+oDmZDadvORmqdDV2Xo8kuiXQeoTU=;
	b=n3EoisJ1ChHQVvzys9TY6/AqMFD0bFxPd86mJ2/1VJcqmHwUZmRgThfqCd2p0WP45JBVGl
	fg1lOaAAF8lZjDSO3ctiuTgFcYt9VEw/yJLpQgAjr3F838crjNDYCCOeM+ITINmpfFBof9
	brEMmO9cByzIaOO8NaYqobadu7AQDfo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6575E41773;
	Wed, 12 Nov 2025 11:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69803C4CEF7;
	Wed, 12 Nov 2025 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762947890;
	bh=Wj/4q1C1ArnQ7Q4ixJ7EiiawvGxLIH7JDw3b8s+7UQk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FyXu+/73fldy/N9aF3u1xUDUGJiObxFLxZZGQhuJ7inI7zDlB+KnAcT4c2tZlz9sC
	 UKPZDozEAjr1L6hpJF+xTP8CKVu7qTZH2UHes9izH5opdFzdciysPSWizGXeeQ+mej
	 MEPSu1l20VwPcnP75gh82oftOZZvJfc42pUMu0ZOzsv2iqfiwdqkTsm06PShgbY+VX
	 MH23jxelP4g06YyGWqLJJQoeO0oNfOQnO6GELdouoJDl94E2Eq+0JbBM/M7YxoD/rg
	 dZ4K5lVyLs0s9vo04NQf5U250KVefbpOjIdtwl5L8IUVUWS8rq3ok9s3+UpREtyhJs
	 TcUGKdtezFBVA==
Message-ID: <9c4cac95-adbf-4236-a872-5213a2a797da@kernel.org>
Date: Wed, 12 Nov 2025 12:44:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] shmem: fix tmpfs reconfiguration (remount) when noswap is
 set
To: Mike Yuan <me@yhndnzj.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>,
 stable@vger.kernel.org
References: <20251108190930.440685-1-me@yhndnzj.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251108190930.440685-1-me@yhndnzj.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 747551C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: a317goyjfrcz8w3inapuh73ttpa7tnwd
X-Rspam-User: 
X-HE-Tag: 1762947891-437183
X-HE-Meta: U2FsdGVkX1/OoEPuWsH50aaHpJ1fNQ9rdQRiYEbqIv9fYfVZxae0O7qC7IO/VfBBAS6Mt2Y5PKt/T1BxPv7XDlhg3hVFtDczGdQl3dcUMunk00WImvuYR2VJ+h1oJKC9yznxj/SKe3P3svKwFG2vDFfzaV6m1OuVWJzEF9m8aNLwTI8iwTODzV3SmP0r51CYUR+B/I4CM6edvekVD5njiHtKFklMj/IQKn/uK3i7y3omA+27kkY3bNeaJPq0fWamiw5LJdBctoootbJ6Win02amIzFP5AEqw0Sl1Ijikneyi+0IiAwB0h4uxGyn8COtlQxzfRnZJyyFloOqBtNpJbqWSL7p0aM19ly6My/w3ijRvvoDHBeO11mjZhs1nnZ0IQo6dZHHPL8CGjmhE6S2CymfCp4TQ/BzeNGKtDcQIsm6OlH1gKw36WpVTjcEDao9YQWigIl9aAdcCycOQSOjvqxcYiSMuwbknrkbPeFs/qQcXhFvxTk1O1O8cBmj4icRZtkD5NXG4iVzT0EAF0GJqh2fh5h60Z2zHgUG9a8J7gYeAHpwugvoLxB5xoVVEEVLkNfCcGIGAdggBm5WvL5/h5F6OZ9CMyoutfo+K9dpFzhOGYfKzT9jT3Y+XbXm7zINxhD4ofJe0zePkHjZ7pu3MdthGmzMOn/knFrVl/OKuACnrn+3jCkC32hgDHcWX0WQNTT+trVepMynmBfsoFNkAS6NCJYdECq8JYAkbXs/4dZ7gtSkFdNdNJlmwVup0SZQtHxzJ/ZOSpqEEh8DNyOS5vk3EDYm8r+4jwRPH0eU276EGYanxGJRNMRYQ7mlWyyd7dknXg1y0AhJhdUYC9gvGwtSrBM5BudsuH9xReCsr49JOnWU7nQO+zQzf0JbnpJX5+vXgEiUXUgXHW0s6S2IR9dN6m2AET+gq3qssi1yL0CxfRvC+HqhWyibLQXRKhyvdkWnfP+xrrJzZHb4vPAl
 v0xrV6uH
 R16ROMME2VecLCwBTphnZKOZU7WyrT6MOKq4ufCgZqZuFTarI+ge0xpCPp8e4lgtYxoms9OHkGrmMo6zHTGEuoBQMmL1V6D9t/b+JquVFlc1PGLAFZd39ehs8yLBtdNpJBEsN8/zC7PmJP2N9ZgMa+3UOh7WCscSvg6z8KG0e126IAQ4OrpQekfoqDxLMgeYQEb4bzvp4NISyBAh+HJ8CWhmkFlUPbCXmtCIVcys2rrUG6TB8T6SLofUd9yMRZdxR7Ysxn+4zSPiK/MbwDGXxwc6BX1KisxO8reFeVXGDfHNamJPMIKmJQT4kJQ02ronKijMS1GpEoWpl4FtCELTMH3p7KpyHoBCdpwn30DB5Ltbu99MGtiE0bLqLpXW65H5LwMhc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.11.25 20:09, Mike Yuan wrote:
> In systemd we're trying to switch the internal credentials setup logic
> to new mount API [1], and I noticed fsconfig(FSCONFIG_CMD_RECONFIGURE)
> consistently fails on tmpfs with noswap option. This can be trivially
> reproduced with the following:
> 
> ```
> int fs_fd = fsopen("tmpfs", 0);
> fsconfig(fs_fd, FSCONFIG_SET_FLAG, "noswap", NULL, 0);
> fsconfig(fs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> fsmount(fs_fd, 0, 0);
> fsconfig(fs_fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);  <------ EINVAL
> ```
> 
> After some digging the culprit is shmem_reconfigure() rejecting
> !(ctx->seen & SHMEM_SEEN_NOSWAP) && sbinfo->noswap, which is bogus
> as ctx->seen serves as a mask for whether certain options are touched
> at all. On top of that, noswap option doesn't use fsparam_flag_no,
> hence it's not really possible to "reenable" swap to begin with.
> Drop the check and redundant SHMEM_SEEN_NOSWAP flag.
> 
> [1] https://github.com/systemd/systemd/pull/39637
> 
> Fixes: 2c6efe9cf2d7 ("shmem: add support to ignore swap")
> Signed-off-by: Mike Yuan <me@yhndnzj.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---

Makes sense to me

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

