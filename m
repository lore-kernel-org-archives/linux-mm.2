Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9FB606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W34Ribl0
Received: by kanga.kvack.org (Postfix)
	id AA6536B05B1; Sat, 21 Nov 2026 14:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A584C6B05B2; Sat, 21 Nov 2026 14:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949106B05B3; Sat, 21 Nov 2026 14:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 710DD6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:12:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8DFA1405C2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:12:46 +0000 (UTC)
X-FDA: 85460073132.23.FDD25A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 33FA740008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:12:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W34Ribl0;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795288365;
	b=FmqI3b9rU6CUJRmySgx+FVQ8wMEWMkvFkDFMTCJAn0ZehfZ+8egYsRv2K1Qb8jIXlfQMrp
	TH/cA9m3LM52zFqH0pN6YYRacOk1bsWCra0baNwARzuBWCnvrzjQ0h4Laz3YZ4r/EgdT2u
	A0+gOh2EF/k6qBkv9kfKjTAq1A6zy+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795288365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75J+TPV4gUTQlMal80OEqhZTuIvyo01lM/tzLCah7ac=;
	b=siO5NhCc+Ufl+C6B6BtHa+E84NDJUmHVS3fWmbPLy1q9vLPnlduN1F0EXKqOAbGyL4Y/UA
	aSCyMv9wwfx05xzApWW1/uqaH08JKFY9aKavrN0g/BIe+M9ggOvnRkrfr2UkIk3JDh8PWT
	ZFi3c2cqfcXt4t8biH//OJ6m7Rcilns=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W34Ribl0;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 3D962440C4;
	Sat, 21 Nov 2026 19:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8E93B1F000C6;
	Sat, 21 Nov 2026 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795288364;
	bh=75J+TPV4gUTQlMal80OEqhZTuIvyo01lM/tzLCah7ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W34Ribl0z+7v1iFlGB13v8z4TgYNiMd+GVWrEW8Fx8AMnkQrg6P+VOBP5vlnJfkLE
	 kbLJA7xiGiPh0mPVcF3J1GBshtd3l1vOB1EjXO29Emfao1V88o+EPc3WQyIehYbx+/
	 6o7/jZGDLhwU6pt5IDamQKA0wSaik0am9reT73p1DVRQ1dVLJtXuHQ3IsDiUxayJrq
	 gcFJQiaaji47qcsJEDM4kAf4Z8UkS1t8Y1/T8eQrQhxHgYW5Vk8HRAhuDta0+xrglu
	 yXH4pJmYQKPHvutd2n4tEWoMapfHzpSlnd7OKjYNHnSbOOPkpchfCLpZZIf0f8Rj84
	 X6Yt3/s2KQ2Og==
Date: Sat, 21 Nov 2026 21:12:40 +0200
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
Message-ID: <awHtKMkyGEPTB17G@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
 <awHsvz1vdlwsink0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awHsvz1vdlwsink0@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 33FA740008
X-Stat-Signature: h6gn9kz7783tf71jo6q8w8esysyx6m64
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795288365-263520
X-HE-Meta: U2FsdGVkX1+9NiizitnoTYjLbIYS52ObcdNCjiYs6y2o8HnwSrkiQ+rAvy8nZqlRROK2fhbyE3cQv5825PsyDOpORy24NrpUaxGcbP8SzyyrYKCTpIs0DGHv/0vV2i3HvYDJoIW/JvOTgmUGczhfD8cMNunj/9dgecI93Qg4+apmpV2SW4UciHbWn6qXBoN9qmQ/2Okd5FAz9a1RM1K/wWpwppS9GFFh2vJpUKtlfgHKKNahPm7MjkyGk/jqTF+8M7A1lR/sv3+UBeDM+MKa0anwXn36lmBDkvCezl4lIHDbAPCh24YlQkHYjmZKV/o7m+8+nnQFeV2hpc+zIPC2MClvNHbZvYbdj1fSc+IxP1yo1okP3ALji3bCOTr0kplKlXeddi0bXzAXWNZbbjqAHT7PX3RCkbnt+XZ5qUj3rzQz1FecEVaykRUb7gEKGvieClU7EBSQcoNi//sBkLcsriZ/iSuxq3purA1/ewUzKs/Me/QVoTzgCnNeBl2GGApZ2xZb3oeCf1vCHNM5OPZFu7t3hlMAJONwrfGn7W6cmNt6GZEV345eYOBOMFYfJSUg8nfFzqnUpn28mud9q9xeVXtOgQ2A9CxprsVglKeWhdI1zutB2IQGPaSr8Or9crLmozvdF6qOxarRZTA3Jn0MGGwNMkcx1+StcDBzs65zmwTLdrhgI6EIkEsl+Q+HsFkLmlmw0umBKszerOPoNF8f3knrqArJz8FpRlP4IArf09Uc/OVeag54LUdIf3LkNCbfFwSo+HLw8EQ7mazT5h/RBnr3v9jSt1Dw2mh3arQUgiYbe1erJa6G9V+RqiwSi8eElhEGtaSHL6m3YoKUmhtqYWGPxahrxNSsQa4FLeBR8BsEyPKpSj9s7gOfGm7bqjx7ST5DuanSfThhBqKVb92itajwOlX7w/2sjgn5ADNAaXEu/yuZUdu3YnG44cxRPUSSx1dCUrkfvlXilnmzWPU
 Ljonep8Y
 EeJx33bT+FEVCRmiDWXpXT3+msrm6d4mj2fNTD9AddXIdQ0k8++uO/HpCQuV88fWlcPdYgAV9CykZCGYtNtdxSXLQUM1S0iOqiN3kaZQxGtigGcQfwlEUO7fUqFGYhVE9ODbcTeYPj10qYiknNEDu/AIHxd0VkOBKduCXugEoFOwzQ1o7nHGuIyg7CjY2uDlBdpS+ObsKzgw/sh3FIdvKS8OKFu//n/66heDSUY9vCnuAcZRAygAvi/hll3Iy3LJAymA7BcCl+//tCmna7HV3wX0yUqzlVEAkhLr2ksZT74t3zdBfJ/8kCKkWZs1rzYRqzuuJqpGpA6FHuHZlPZKBKeZMLmhQiU7zsjb+qEH07VaOerV6ydFiZnKqHLjL9Ee/YuHjow37ZcXZMvo35jt0EtaQtLUlyLHmj1vY1pb0hGeBqmGZ0u421Yh1b+ZTeHMQAYiwbQ56l1PTtkcwsm3t4W/NPNDkWa0yLa4n/GAlf9H4SOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 09:10:59PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> > Setting up an isolated namespace environment from a multithreaded
> > manager process currently requires helper processes to call unshare()
> > and pass file descriptors back over sockets.
> > 
> > Add the rootns() system call to allocate a detached rootns instance
> > owning a fresh user namespace alongside dedicated empty mount
> > (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> > namespaces, and return its control file descriptor. Finalize the nsproxy
> > time namespace and pin active references for the lifetime of the rootns.
> > 
> > Co-developed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Syscall name is outdated. I'll rename it as container_create(). Does
> not have to be final name, but is a better wip name.

Something more non-generic as it inevitably would collide to something
(did not check). I'll figure something out.

Br, Jarkko

