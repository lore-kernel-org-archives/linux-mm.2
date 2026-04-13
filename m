Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58E6EBFD3F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002086B0089; Mon, 13 Apr 2026 07:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5666B008A; Mon, 13 Apr 2026 07:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B856B0092; Mon, 13 Apr 2026 07:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1BBA6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:22:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AD37C04EE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:22:35 +0000 (UTC)
X-FDA: 84653294670.10.BFE60FC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB999140002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:22:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EQzxAo9Q
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EQzxAo9Q;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776079353; a=rsa-sha256;
	cv=none;
	b=pwMW0b4EziR5CpnFAMwHpqYmecHz/JujmU/fwkNwT6T++gxKjU8zNGzIyFvlLzAAg2wjy/
	haejJt7r5VMU9FsS2T9RKlSgPZDBvaKqkDyiQKpSqsEq6pf9v0m8IjIxDdFkRz1c9vyzMu
	ZhGwdzJp1d/qNtDAhF/NiAA119XogH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776079353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epg3lloxstaR+U2vf+uUHLYMjLaIyOPP3DRHzedUqkg=;
	b=gNfwgtAmHNviomlmUw3sKj6ClPSalYDFRbcD61brSJeWbgl2Wz6p6zPlJKIKvjG5ct1Zik
	g/iSHizr7K9yQP62RJXOZwzmUh0LSG87zQuGDDNlRACuIgtrXMxUomwHXrRI4aBRAgQGVY
	gmNm0VltDqoXbINBWrC/fTaSscd6kn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=epg3lloxstaR+U2vf+uUHLYMjLaIyOPP3DRHzedUqkg=; b=EQzxAo9Q44B5SjzTyheEABdbL3
	ggxr/2N/jTNN+JQZThPbeI0p6MxqiEdEO2GdqY1MUk5G/PJRKybDDGU74KFLlYcX/A2mMcU0R1uhb
	I0UQzGNbvINHzfPAPRWuNHmNi0lWtSDamNvgJZ2W60u3ZcoNt9nHp4Z2FXI9joYC+KF9XJLvhD9GB
	tj+Hop85hnwTbrPgfhvazdA2gOuYktSqCGvK5/PlOC1LofEDdcwSxS6sQ2W/+nWK5WyjC5FVdqTVd
	nLFY3NIS8X1jdbxKXqJovZ6RYinwkpvFFM8Fqca81ZcJhNLB8xTi3k1ZC29UqGRuY56dDsgVWKfUQ
	/E4vJchA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCFN4-00CFrC-0y;
	Mon, 13 Apr 2026 11:22:26 +0000
Date: Mon, 13 Apr 2026 04:22:21 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2 2/3] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <adzQIS7jd_Ce_JrA@gmail.com>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-2-9e40d0f64f7a@debian.org>
 <59c133a7-74a7-4678-d907-add764bbd107@huawei.com>
 <adkFQF7QH8Jc3p3U@gmail.com>
 <15315535-3881-e2db-02d4-907235dd98b7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15315535-3881-e2db-02d4-907235dd98b7@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB999140002
X-Stat-Signature: i5c1x9os9n89i645mbxaxhy3kisamgq7
X-Rspam-User: 
X-HE-Tag: 1776079353-315607
X-HE-Meta: U2FsdGVkX18rtIhyRth1Y/7PhXn+tAOwyb9Jou1MzHwXZe7KsY1dc0tpL0Vjtg5hU2d3WfAnCtW3iIj4az7q0AInmDVDqsbfJIG19mCRGKF9WAXeHMmZEvnKsSPjtBchoTrrv82ojGEbk0ZTTObitQbxXeBwAd7LuZM0+3gUmlxJ90EkYUeDueyAFtn9+JaTASLKfo3QlleaUuIRUXMr0YZaKxyFJQvc+ReTI9cz8e/WDKsOn7bbJ982EC2D5HuaFr3LzgHQ+nADR6U7Xs/WULk6sS5SChqZR9qlyrZRg0QUlHT6Mh18N7XmvZ/UBZrYU0rbzG6lYbize6SEPkiROBfFF0v7+BZG9U59UVoxPVsSmnT/5hv1uhx8KyZQQ1kCJSQR0WLFdkwrR1CRkIs5nGH4M8OY5H0vAHuYEromcsmsd8Ehg7kTnlVP9c+Pxv+APtGWP3ap+Y+3DQIp0IMIADJr7S+b5d543xvCDr7tPnfSUcNxWPgdtMnUbwR21mymiB5R7kv1qf2Kjr550CrtKtYsKAvZ5XJO0aT0hXDZC1T8Nb2QNqqUwJY5CSXNZqIeXbmOX6doIUFm8zWarRDqubP9mrIZ/r/wBePENaiORwZ79z3Umi3ONHweJNez4s+MicSQp8dO7iFuGert4yqmS2zM8gB9tEh7hR8B97hTkhNaZ9WSjetDTkU3klKFN7Df2nwUVPEajfDHTZ8buVPGJjRhqcqHmWjDOf9j1XgH2kuLpczU/4oEdCxjfJBPseAek7BS9IiJ0v26i4AL1nKbLsE3ObZTmRFp2cjm+wBML823f/UMbKrTcqX17TTtcI0wHjy6cUTKKsluWUGt2pZf9RK7tJbhWoLsRS2fPIff1SH3dOni3jojUiQdIHNEr/LGgyngu0iuYcqkSZDeTLj4gttXd6+blD3lUorFhPpjY/aJo6EelfZivlcIWtpAOWh42f1R9GBdl5pm4L9200i
 k576yU2U
 eWCMERHzG7NnTNt6WqCaPbcB/k+MICKSYEX4ceEaMDfEwd3RrJugOuQLbBKULp3bBpgskCidT0tCpRu3HFYUj/aSmJMB936IrXcsTV8/hG5fKVWdT4c0aIfqYXEUYUJVDlbDnRDCPk1DIAstvuTXY2kaAEB/I8BP76K11ELpuPRa8Lsx6YZMCwJ/9zUQeIVVLEPODsMpPnD+SPSMSJM2HWC1RwHC8tfllcMwVWpsuveOLdH8HAbebkwuMmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:42:19AM +0800, Miaohe Lin wrote:
> On 2026/4/10 22:17, Breno Leitao wrote:
> > On Tue, Apr 07, 2026 at 10:57:36AM +0800, Miaohe Lin wrote:
> >> On 2026/3/31 19:00, Breno Leitao wrote:
> > +{
> > +	return sysctl_panic_on_unrecoverable_mf &&
> > +	       result == MF_IGNORED &&
> > +	       (type == MF_MSG_KERNEL ||
> > +		type == MF_MSG_KERNEL_HIGH_ORDER ||
> > +		type == MF_MSG_UNKNOWN);
> > +}
> > +
> >  /*
> >   * "Dirty/Clean" indication is not 100% accurate due to the possibility of
> >   * setting PG_dirty outside page lock. See also comment above set_page_dirty().
> > @@ -1298,6 +1319,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
> >  	pr_err("%#lx: recovery action for %s: %s\n",
> >  		pfn, action_page_types[type], action_name[result]);
> >
> > +	if (is_unrecoverable_memory_failure(type, result))
>
> Would it be better to name it as panic_on_unrecoverable_mf() or something like it?
> This function determines whether panic on the specified memory error.

Acknowledged. I'll rename the function to panic_on_unrecoverable_mf() in the
next version.

After extensive testing, I'm considering adding a boot-time configuration
parameter for this feature, similar to BOOTPARAM_WQ_STALL_PANIC,
BOOTPARAM_SOFTLOCKUP_PANIC, BOOTPARAM_HARDLOCKUP_PANIC, and
BOOTPARAM_HUNG_TASK_PANIC. This would make the panic behavior available
from early boot without requiring runtime sysctl configuration, ensuring
the system crashes on unrecoverable ECC errors rather than ignoring
them.

I'll prepare and send the updated version shortly.

Thanks for your feedback,
--breno

