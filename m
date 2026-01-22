Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7304BD6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CCF6B0305; Thu, 22 Jan 2026 13:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23CF6B030C; Thu, 22 Jan 2026 13:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AAB6B030D; Thu, 22 Jan 2026 13:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B70EC6B0305
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:42:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76FD3D2E43
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:42:42 +0000 (UTC)
X-FDA: 84360470964.14.7846C36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id ABE52180005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:42:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0M0eJV+1;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769107360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qS7PEuz1O5bKxDv4aqYg3ChuDYozp1+WKDMD+2k4xd0=;
	b=jKQuQQTcygXOknGRU4/zP6S65RjmGlvvu5+G58Jye/YKcu1jzIOrwIOmZ4ebsxBWPgl4lk
	M9qAxxbRwPSpOlzRBmf3xSeDuByVgGSlp2NzADId6iGOfNapyjY5O+FSJQ/+TgBbSzk4JF
	eVaNzhG307j/umpxU+QSRyHof/B2Zrs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769107360; a=rsa-sha256;
	cv=none;
	b=hrmWGikGRPY5KmL9By7UWzXYiDPjNBaeF1VQX6IQa0tMhzpTUz5blwoSah1RuhoRN6QURp
	D/JEFKBMyw9tzZZ6zqdsY9ju4yo3yrl1X3HUCxgCXmk5NPCCK59S2zTxvNQgRJFCXVdDzy
	6J80GJRiKYjJswJgIVu2o6YXGrTdDRk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0M0eJV+1;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B7FC4431C;
	Thu, 22 Jan 2026 18:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D5EC116C6;
	Thu, 22 Jan 2026 18:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769107359;
	bh=b72qrfEiESRnID/ZSET/7KyALK/IAoOp3xRzxTn/cmg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0M0eJV+1auAuUJWu6GmAhcw05iE+ioaUWBCvpKqre4cv3wJ/ruPqT0U4bVOOS/tqc
	 bKLJV66CX20wozAGsPSeN/NLoynZYrQd/9vymmJ3GdTf1JW3PCuLdapix4xH3cjTBt
	 Tf9rth/6MEyCnbgdArSi5qjduVaMXCvCEVb+YzHc=
Date: Thu, 22 Jan 2026 10:42:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>, Jason Gunthorpe
 <jgg@nvidia.com>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Re: kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc()
 warn: missing error code 'err'
Message-Id: <20260122104238.54189a538153a0323453d61f@linux-foundation.org>
In-Reply-To: <CA+CK2bAyHHoUaT_4dTNK6AH2oyMMhs2sNhuW97hV4yRw7ie9Tg@mail.gmail.com>
References: <202601211636.IRaejjdw-lkp@intel.com>
	<20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
	<CA+CK2bAyHHoUaT_4dTNK6AH2oyMMhs2sNhuW97hV4yRw7ie9Tg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABE52180005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: f3xf9w9984n84r39n8j1rrbatcj9buij
X-HE-Tag: 1769107360-142134
X-HE-Meta: U2FsdGVkX1/TURtDH/ggWAw0P+xpG6+wPPlDjsndwRkhwtZATnJb2ELLuOUpc5LFo4Udl61asusGimWuzAwrUQvbqelQ5zfwEHE8g0FabGBXQzVJWc2CfKJz6Qx+Gd0U26l+E62x7VYubDGqLAt3eBTKENp5KYHL9VAaC9L9otWlrLRMNRpzWF6Zdn/c/zMkih5CIGkHJdVF/P5+iOKuWUgf074gtFGCSXZjoxPBBOkHHLL/45k1aalSHcn9LW9eMnF5CGE8VxobFOIPFYhQF4ZxOTk3M07z0waC8Zaf0l8OYSHl2vSrNxpaqIiDOLPyARW5u521frCsDCY9USbI662j/9cl1De9aeKM7P8Im690AgEKAFeYKc7zYo/jtcVzRbSIfatuR+hIoOSXr8lFfjjwT/FaDjoCKP3WxwzruNpDXeOBq5GwsYtMAAREYgHTQZaWwGSXkjQIJM4YKw4ca2nd5rztpn1Pu7bk6JnO31BL4rQYM/rCsaFhcB8qOEjk07N05gKIICt7848ps1+A1tVk5bL7eas1EX82KAY/JzjGAyHUne2pUR2lZlXoYeipwGyRw66tcs0qjYgisz6tTAVT5ClSS+IeYMPEUwNzGduYZ6z61T+OKMUQg4sbkCn9M5ptFdZ9Mk9fypaaaf4gqjGebqztPES5wJmcqqxVSalGEFhzCpVmprnhIkoBu97JgnX9gt84VF9hDmzgsPjQG6PZOZipwJYPTaWPLBWEkQXWPZDSTS5S2NvpNkeU/aE/uf8U/mqLvU722NoNSy3VkckSVpmXi+nVtXXZlWH2s6hBN1zqAZgGKPznci0guS7XE8P3dnRFoZrn93puqGVxf6Mp97FqJSXtvqmx64TgxDOYJFxpY9nRjq65fBms1wK64fRXIkrlR8ziMYGKNBu6gUbSu/5pqn9sFq/M4OQkFtURHxX9fZ4u83Dz7BX9tV+fkoli0xeGVHojKFBWP0n
 xvBSoIv6
 GXogRKjU7/5jasnV+/R7rxc8HOklYWlLgpITnKAQi5ekDlrX/W5wINMNK9oPoWv0kElD2yZnVrmLykzliiilnzEUF/4jDtTLkdRKy0Ca9PeRDZCBIiu64YhtJaCnwlAxNB7iTxpxQ35kMwN6Ex7TXltlL/xGQwcHXcq+KQqEh3e+D3g/lesdHMBzKq8UNXNt1K66ttKH79mKMmG2Wz1yXwHiA+1xNt9hOtPhvuHTyX+MM+8bnN5hHA1VveqkXRB0ig7eD4r9SAG8SONAfbWQzkrvCiCyYLIeCkDMBWN8vmoBpWqsu1tyuNFKY8SB72DVqEifl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 13:14:49 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > --- a/kernel/liveupdate/kexec_handover.c~a
> > +++ a/kernel/liveupdate/kexec_handover.c
> > @@ -1011,8 +1011,10 @@ int kho_preserve_vmalloc(void *ptr, stru
> >                 chunk->phys[idx++] = phys;
> >                 if (idx == ARRAY_SIZE(chunk->phys)) {
> >                         chunk = new_vmalloc_chunk(chunk);
> > -                       if (!chunk)
> > +                       if (!chunk) {
> > +                               err = -ENOMEM;
> >                                 goto err_free;
> > +                       }
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Cool.  I think I'll turn this into a 6.19 hotfix - it is a slight bug
and we don't want people to keep telling us about it.

