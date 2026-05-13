Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B876CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0238A6B0092; Tue, 12 May 2026 23:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F155F6B0093; Tue, 12 May 2026 23:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E533C6B0095; Tue, 12 May 2026 23:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3D9E6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:06:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C5591C0590
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:06:35 +0000 (UTC)
X-FDA: 84760908750.04.8222F19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABDA7C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:06:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ej+cBwUb;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGZhGUmnZx6HEJW+KudzviDeYmtI112FhSb3FVCSFZ0=;
	b=uur9MDnLVKsldd4s9vX7lZuLwmqYFswvRl/0sA/GbVD/hx6UmTAloOH6uM8NVx7xTIFkor
	F9slE4YGgwzHOMZV9Qh8CCK6pPXFfK8dH1WBIXGBsI/Lrpj52Rj58iKjdNP8c9CJVTagbI
	2Q4RLVyU359MziZqOiZ2Jtny/18gHgI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ej+cBwUb;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778641593; a=rsa-sha256;
	cv=none;
	b=xADeUx8v8ZcCMW6XMhN0doZfeRcZzx4SEAhbX6ojKahIHZcMdi9rRwLA/AhDCLb94JBqkZ
	/y80Eu7Vk69oJKrKHlaRMxtmKBSrwAnmjRVOSQdC/0WLN/9AjcAMXZNdUFGEGV3RZwVGNF
	fnihNjABwR1uX95S7I+LX6/LxsVTUq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F40B4600CB;
	Wed, 13 May 2026 03:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4EAC2BCB0;
	Wed, 13 May 2026 03:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778641592;
	bh=v42Q3fJGlh3sKqS7/VSV1G4hfJ35NzHyYQOEaT5rKHU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ej+cBwUbAXVsbiOMGcLXz75uvDj/ANS2LRzDcuaO/LFvYW66d/JVS3beplyN3fnaZ
	 JiLERm38ema69N8JJZrBLIYsrCopjXeEVlQYukw8NwxM879A7g7jEaxYIs9y4bLlkg
	 cs6wZqmBCrhOEqghLr5iGE1G1WmvGyaGMYby0zpg=
Date: Tue, 12 May 2026 20:06:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/mm: assorted fixes for hmm-tests
Message-Id: <20260512200631.b52b15dd47cdbfb887ab3e3b@linux-foundation.org>
In-Reply-To: <cover.1777870179.git.aboorvad@linux.ibm.com>
References: <cover.1777870179.git.aboorvad@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ABDA7C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: zfpuuqan3ya131grrrfs84dwryajjc7c
X-HE-Tag: 1778641593-33619
X-HE-Meta: U2FsdGVkX19N8ehkl+W/z3aoPFqpyWg2Uk99/JcrsV9Y+4wtmrfCj2s4vLt1BVZ8pXcGl7rxbJxLPVJZfP+LuyJtnNKrbBemZ9J5gWEq7wczOEsphstEdCbF7tM171G61hEnjm9jMdIu9K6dqVNo7amiP7gi6Ye2lsI1el+WFqM7WZYeHZmcvoCdefB9ocmrHDUfeDvq0qX7rsggxORXrvlICzu0KUoH1MGeP1dopk9Sm4qAoK4b+EdKAsGOcTESzR1/oGU8RezlgKVNlQtqbryYC5f1FETbE0ZiZLsCgLR2hEu72vjWhEixsa5wT/ytXJSWUDSz8QMQl2gn5cYnl/CUKD8r2qGvREoOZHTdSQBgNr0W1049m3OhLHHHWjFhkDkVFUcF/7gRWjh18v2RCo48hmW6/iDTVrqtdmsew96lHi26MfsCMUvh0oUrHqKohP0BI+52YCl54hXp2MbAJyeQO6AMYwctb4GoUjXP6CNwvhVQd6XjPH3L5XATZ56/ryEiREiUHYLKxE4gfinQ5K39ShoNCTF0i8R4iI3/QwlBR13PAxrWFFzMX3AhJ2UI75RddSJagWFwGjQpLA/ZC6BN/aydCCbsmTK96AcuugT4W7cD99XLWNSE5g3ADD2HeAhquLVeB293lQdTRYirS0gqohmjmQLOiHKjohqsoBIQrOxL7qv7smHBiTJbJqbQr4DtGSOCYfedfQ4xI24In+oZMtSqzb/KI90fptO1l983MoNcVpyR/rOkBoIqDmSwutEQiPr11DaMhdrZbUiwdRJDf5IIwK5UMdRfA/oRWm+AVjnt9CFmUeDM+hefiMfUgtsC4SGaL2wcRzTyNUyfmjs1zfacx3XQ4AsCbM3JMGJ5kS2z0btXHe1TI2UHqDsjUwcK44KscrSXoh5lBaEG7F1+gBrjZ1k34GJzohsC6ERS2xqqIM23Kzv0LrFMq0R08zszDLYALdWdZFs/q28
 NXa5OnDp
 9nCmBZaQt2NbmaTmgAvsz/ObmXVxPjQZN09ZL4HIjjFB/dhphnrnzRl8m4DfKCETO8vcgONqKP8+kPDB1b3oIY72TTd27DtIkTJj+T8ZnDRq+1s+AkWuZbSB5LHmYnBUN6Dw7qs83a8jnh/8z1Amwk8zfO6jYC0AFF4eI7PGkcpoFgFyn4aH7WkZapPgS83rhBpNJiRBgA7o3i/MY9i+0xKNHxMc0Yzj8PGsNGk5zEktKLJVHwicvQvCLM1KMhrc2PGnauK/iccjnPK3q6bcjArJgSUmbdOkWCRc6uHjsX3B4haDqA3BzbJ51K8CVFA2GfvaE9JAYv32aTzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 May 2026 14:41:05 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:

> This series fixes a few issues in hmm-tests that show up when
> page-size and huge-page configuration differ from the hardcoded
> assumptions the tests were written for (PMD/THP sizing, default
> hugepage size, and related cases).
> 
> It also includes a minor fix to exclusive_cow: the test ignored the
> return value of fork(), so both parent and child ran the same teardown
> path.

Thanks.  AI review asked a few reasonable-sounding questions:
	https://sashiko.dev/#/patchset/cover.1777870179.git.aboorvad@linux.ibm.com

