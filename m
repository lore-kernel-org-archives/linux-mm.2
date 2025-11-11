Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 491C2CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 23:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EE68E000D; Tue, 11 Nov 2025 18:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56BE8E0002; Tue, 11 Nov 2025 18:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9941F8E000D; Tue, 11 Nov 2025 18:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 866478E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:50:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49D9B16025C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:50:46 +0000 (UTC)
X-FDA: 84099973692.10.4845CB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A14B240007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:50:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sbq0zAF8;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762905044; a=rsa-sha256;
	cv=none;
	b=wt/8gI9kJ9B/y5Oyo45XuDvlzF4S31mETHqCPE3df30C4PL7Lo4SP9Ky02JeR50B4wq7NN
	wtBMIV+ao5dJJQEqVDEFpLGgjwmIsfBiM0xSN7z/AVVrwRkBStudLex+tfCl3AWlFsOyhL
	UPNDUKK+ryvVOFRzZtL/YdjBKLVPgxI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sbq0zAF8;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762905044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+fG8djHPQZG555gpqRofF9PCdgJB4FAwLPcs+bKW/Q=;
	b=7jE7a+8W2qk3SY3YFUHPQNk22zGXtIFe65ZoHG822UxMr+AgaT9Yq5algSUo2gtCEiUKxc
	dIneJt88ebAVGekVWJ/r7x9ufnDO8lwhJW5LgX2uGg1khmZTtFn1IVi5BuWkTSME6GOa3V
	KQtMhZEWE7mXXiysqpbrPZSWoSOlsr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 230FE60204;
	Tue, 11 Nov 2025 23:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799FBC19422;
	Tue, 11 Nov 2025 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762905043;
	bh=zYEFGSpbh5QVtMNWkfebiNl3sYg5AT/6cdw0nIpNhjA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sbq0zAF8ZoyJ4/uRqYKb/iFdUnRXolH8+oI/TIRRzMqSZSt9zA5kQE0jsUEmJTEXj
	 mk8R3WEuV/HVLTPG6Pt+mb/jCfI5SJGy3dwwWR0pIiai1Hcby8nZsidkp0W6bhkLLR
	 /wjfCZT4mAuO4NKy/bmvJGeNQqJUqTCWAa2ZsDpc=
Date: Tue, 11 Nov 2025 15:50:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, David Hildenbrand <david@redhat.com>, Zi
 Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: Add tracepoints for debugging
Message-Id: <20251111155042.b07ecb045c978fe4c457b1d0@linux-foundation.org>
In-Reply-To: <20251110161954.47d88433@gandalf.local.home>
References: <20251016054619.3174997-1-balbirs@nvidia.com>
	<20251110161954.47d88433@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A14B240007
X-Stat-Signature: h59gbzwbe5iy48qmdjjqtrrunwdstnn9
X-HE-Tag: 1762905044-443944
X-HE-Meta: U2FsdGVkX1+F+MC4JSyFrrImMo8C1PwZA4Ah6QBLQpkahEoqXG3Q0jwCO7Y0nhLNKtanty3b0fTDjClS1PYuJw3R1Zgv/sA0e47nA+gp3Y3RUjxrU0o2f2/aIgyut+PaoUsVbOEkfnPWjF4PAbhz5gWDu8Z6g+M3USqPEswbQ168cUulhr5um35zN7X7rY6iZoujA1kdbVlUfKv3taAqY+I+ff9GFuK+KyITMNsUkAZ/YjErVkTUu996rXdYxyCuxcu8LAtLmjnfMm/seOGoI26h2pSy41qcrh0Bj6zCyy8d3v6uJwI8QEu7QT/EApSn4sfLpgvMxPwsQ72Cgam9COW0X0m+d8Ll8MjB3AfyttjTzcknn+xd8v4lJGgeYHztvD6lAR+mRwbiMojG87wWeX9OyGZ81ITM8jok7UCKUPfdm/BF7HNcRLwJDqJwRSQhsK2k5AlIM8XsuzUtVHfngaNnFMw8zAW4+ZAO//707xDta90Id/lYLo2Eluq4BCyLRcqCATq5J5MAwWdmr0TDWqlBYzU1aXuSfxgpr24uVYFfhjt9s483JgFsx3u22lhnah1gfxzhEreEWDltEDBnH/n2bQ766TK5rlh8aenyk2TkWP86gB7PBTXNKe2I4v0BptnqUyVAtKMpQVjh8E5GUBOv73r89WIAaDUb6lyDI1Hy5urZPsmWfYRM4B5G/QGDFuwK4hC9D4aanhIIRg45S7ZbarDM89eSfIpjt4M9PGeDxtCSNO56bbeWx9ro0YWNofpC9I+HmGTJWBa8m8Hk0y60y9hlxH18PcPGxndVd65BIM9LzqwnVflnFR/YsPIiMhgZ7YDWyJNZ/fxIx1vBKO0oEIw3Doxv24dymc2ImBWhRsSkWyt/nxXa4FB4s/mX6UQvyGHWrVWW7PVkcO46UgEliavnJfFDqPK88lCcpmhCc0/8VZ1J2Y6JUWj99TKFWntmP+yjPpfyoJbAzS3
 XwQOKR9g
 tqB9M5YziA83bUCGp8NcJTiWwyVK01YULL5maLtmmz5A93bLd9kRnpEhvOV39ribbT7rtPFdtOfpQ18AXAoWZWpxtwpIAwLq7Pxr4rlpXyBRvvsLE9kDqilC3C0sUrnuzzBWCfPDPHL/KbKiRpE5l/mrQkVTcurMTXsCzQAzS8wJlC9Jo9E9JJWnFldhMrDKBL5ZAKzbSJsDuuNMRNeZCN00OjudcZi2L9loLLnOv7hHot+nnsQS4u1RopnZ29DLpoT0YZ5CpVCUXiMrFtIYQS/yytdZU/kcmCzQPCJPGxb6UlIZyNtW5nBmQIlVMj1/eddUwknzmZADcqdJ17itoKZSP9CDtZXRJh0/iQ9tDao06U16jM5At5B7FDXA9DzH7G+WeIZ65HQNN83MK0cPIzCK3As7Eu6vVfy0G8f1JhVnwQf7o1twZF0iyThUkzCG2J2KT+P4U4kz1qA0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025 16:19:54 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 16 Oct 2025 16:46:19 +1100
> Balbir Singh <balbirs@nvidia.com> wrote:
> 
> > Add tracepoints for debugging device migration flow in migrate_device.c.
> > This is helpful in debugging how long migration took (time can be
> > tracked backwards from migrate_device_finalize to migrate_vma_setup).
> > 
> > A combination of these events along with existing thp:*, exceptions:*
> > and migrate:* is very useful for debugging issues related to
> > migration.
> > 
>
> ...
>
> >        hmm-tests-855   [002]    50.042800: set_migration_pmd:    addr=7f2908a00000, pmd=dfffffffd39ffe00
> >        hmm-tests-855   [002]    50.062345: remove_migration_pmd: addr=7f2908a00000, pmd=efffffe00403fe00
> 
> Each TRACE_EVENT() is equivalent to:
> 
> DECLARE_EVENT_CLASS(event, ...)
> DEFINE_EVENT(event, event, ...)
> 
> Where a class is around 4-5K in size, and the DEFINE_EVENT is between
> 500 and 1k in size.
> 
> By using a single DECLARE_EVENT_CLASS() for multiple events, you can save
> several thousands of bytes of memory.

Thanks for the detailed review.  I'll drop this version of the patch.

