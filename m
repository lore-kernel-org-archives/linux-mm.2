Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A25606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IXVuogm5
Received: by kanga.kvack.org (Postfix)
	id 28C726B00EF; Sat, 21 Nov 2026 14:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DB46B05B0; Sat, 21 Nov 2026 14:11:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153AF6B05B1; Sat, 21 Nov 2026 14:11:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E69C56B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:11:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 790B31601A9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:11:01 +0000 (UTC)
X-FDA: 85460068722.22.EA18733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7BC8C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:10:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXVuogm5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795288260;
	b=2bEwV4ZyD6Mzhc+o/OVggAO5ePbvykU2fMJpcUThiEVkkgdVVtpbBj+13OU98kVisKLA69
	xovnKntREfws9dMW+M8gUvXkMjJzRNwTN3rgeUgV6/GRWm+39Coswq+JmqPvfJnapRtQGU
	QYW1j02b/3JSqYY7meC4fQDKapYVlZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795288260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ow9Xw7m3YEqTR1MIKUD5mHez4EOB5YhbjcdeDZUw2w=;
	b=CykWIVruF1GH4V9eLln1sa3dYsa3WkcWNHzTIcK6FiFWd2RY3VAziXWGd76gyRGhnCPpiK
	b1zKU2IJHitb/Hbhj64TJLLzJC/FVuIJkKxnM96tgwhq1f+k9TOYzjJVkGx0XJPvBr6o5v
	U9kF2rCy0vwRpg/bb32gfAcTxmebHQA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXVuogm5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 48C7061188;
	Sat, 21 Nov 2026 19:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7792F1F000C4;
	Sat, 21 Nov 2026 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795288259;
	bh=6ow9Xw7m3YEqTR1MIKUD5mHez4EOB5YhbjcdeDZUw2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IXVuogm5AmzeqYVSeKK45LIqxXSnmNzlRQhLbnpp/DOl3f1zkSIUhFKlzo1BKxucA
	 1n4pOf7fvG2ysLhBqbKKPKQ40fjvD/+RCc89Pn3FC34GLo1meaV7US384hKGg720GL
	 zTN39Od3nvrftfuqzmttAjhxmZ8OAHYMsFoJsuxQIOYi+5AtHmZDitJISN83yhuvZ7
	 C5cz36I0m/G+CslC7vHQZc2gDqh5XBIkcVNmnq7grN+CrSxpLQ3EZuD0Seh60RmCEn
	 xhylOpnoDC/9goxsijv5gq2jv7QI+VO5gaOc0nG2/c6yzMltjLvYmG27yBJusJvW2h
	 7KyizQv3JeDTw==
Date: Sat, 21 Nov 2026 21:10:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 13/25] rootns: Add rootns() system call
Message-ID: <awHsvz1vdlwsink0@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-14-jarkko@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7BC8C0005
X-Stat-Signature: djbop64qscpcmbniednccyyid4j8kex1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795288259-195488
X-HE-Meta: U2FsdGVkX19C4ZpxI6AHr1DM8EYVNHfI03I3WRbwmNvtATGKi1NEU/K8IeGDRJtdJxGoE4uuvzobbu/iMs9r9Oqq/KTo/O87InYRmXGqGnenNLfhpkgkpWrmsKIhPFBP9vRzVBnR3RenDmbkaqqI8+eK0sHZfmkT03M+RUYMfnYZ9D30Bf1TvEY+HSO+VtoyU1Bt+0bzULTVL/jp/dBPKO0enK753P4Bu1j/bTyMhFqpX/+gJAeHqRufQUn4D/rBECexIMTn+en/4rfpgxTLoQ/+aQUuk/pJ9nyup9ds15h1dUyCqmY9LAbQRiblGviyuGK3itBRQk8WEwbewFQ7RrjQ1ZeHIavMB3MEDl9doAcW5KObq9Z6fnv6WP7d+yplTVY5hCwRkjY56v5CzQd3VqkVWTt72vgQXjdYA6GbU/FDw88jIXP2+QQb0b0ZF9p4S5McyTVqMGZLk2c7vyVmAIbqMla939Cr1+nnqpp+dZmcJXshs4VvwOjrH/IPcP+aunSSgiRxIQq8PfYNmQ3pckf65XactUOUn9VeBN3cVpujsUpI6pMBu357ma0pgpMeTh1VQtKYlK1uhtI0xfBe3LPQ56EgcwK/Vq86hXllU0QhTIEDOgK/ICpoGQ+SUHQ3KvZl/5rCQxdFehJWmak4rI48urI/kXh2rKU0Se/QvgotNH2vc51pwZ6GGfVXocWV5keyyMUfVDz22E+kxGm0QQSSWts9ou/DU+sH0nm3eL4B7vPczOj+MK8URMwB4LubNZkW9pIpRfYc3wSsNG4HVExWykhyv+O/MHV7bzvPssTlGUP3m4LiHNfgRFSSe0CSoZKYIU1G9FtgJh8yCL/pPWvi4pk1kGBTvp7D5j3Z0/bO3yigyGCHZqMZ0oJmPPKlhrFsRwmBLB6aM9OpsEUHGVW0ZyGs0ZfhgVsCMBVO65k8BoAAj5ue2qD7x3CbW3N5pgp+00KmZFhnDsBtOtk
 y1HdKXGV
 I4PmAkwV/pCD5Ah4QCgVnR2iwivyvp6lb8KFNTp9zQQZ3JlJowSFEj5Xps1ZMYJ8w5lVyptg+0joL4wLajVwdiM7rC3IrC79/UKkxJ3fPELPLAN1hBaatr14NlM55CJK19+Q3y80bekrrsgZ+B7ZMPMaE+Lq9QFndg0bqkK3FdVljeQ3M4xVeIdnrh+/mqyJMo5Gs5cG8TLzvQ9w90ZtorZJizHppqdehharoEcjcuH7Q/xLs4ftrr7286VFbZDqQ+eyrX6BhKb1JsFDQJQedeZY+hHQg7Lql4x0kPWsU2o4L7o6ndwUiyEQ7jPg+praJ2sWH7lLKgzapfXQDflPLP2XqI4VkfCTT6jizGZmAPPRyna389M/ip/S2fLLBUxLr0v86mK3EuC4YLLjVwNDE80Mm2H2gA6V3crBfyUA/uW5diDUfMWnT1NirB8Ht7aevS6z+reWyG8tvw/e4IL1Nn0YFBl/bkEVmW34kpDBMJgvVaYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> Setting up an isolated namespace environment from a multithreaded
> manager process currently requires helper processes to call unshare()
> and pass file descriptors back over sockets.
> 
> Add the rootns() system call to allocate a detached rootns instance
> owning a fresh user namespace alongside dedicated empty mount
> (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> namespaces, and return its control file descriptor. Finalize the nsproxy
> time namespace and pin active references for the lifetime of the rootns.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Syscall name is outdated. I'll rename it as container_create(). Does
not have to be final name, but is a better wip name.

Br, Jarkko

