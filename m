Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D653AD29DC7
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FA86B0005; Mon, 12 Jan 2026 22:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D866B0088; Mon, 12 Jan 2026 22:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C566B008A; Mon, 12 Jan 2026 22:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EEF56B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:27:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6EE613CBF9
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:27:58 +0000 (UTC)
X-FDA: 84325506636.28.C3F4A22
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0C670140007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:27:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KbZFLqAc;
	spf=pass (imf09.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768274877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Ji4TaSWr8IkhQZkimpMfWwJazZdbadNYrKKqL15LiI=;
	b=t4YK/Vj1l9JePbRd9KdhqdEO9Fxd6aLIYg/9USU7d5/FOfBDJ1XEVqlk7K23YWZvz1ghaD
	yPA8WMvrCnBoSJYlyJsF9laHXhx/7XK015UCEoLrnqky0o7RcYg9XlFkZY9PTwhLY/ia5V
	qNamJyYJ9FHPgPY1pkg/idleX125+yE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KbZFLqAc;
	spf=pass (imf09.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768274877; a=rsa-sha256;
	cv=none;
	b=sYYFZVnfIj3qLjjOo5M7oH4w9EOScmu9GAapYN8cevxsW+UfqiFzgpRzXRex3nDfwSFO9c
	l2KmL3lpwMu+/xHgK/oJGui3LUuCv0lSCCL3z9nHr8AcUvX6gCmFckCblNzlztHEX/z8+B
	fzYJYkmWvxVxT5882RzopSVsR7UwEdw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=0J
	i4TaSWr8IkhQZkimpMfWwJazZdbadNYrKKqL15LiI=; b=KbZFLqAcrkJ2BPnWFy
	qr0HoAVw5PqdqjpihkE5fMmMGtKDPkLh4kPKP1/mXn4k9nPg/nEqQMX6kUhsxCvc
	KInCRUeyhsX0PVh/DICnJSrLcCWQ6eoMiwTAYiTIMQ54xr0ZebdpwHwyQWAJIqx1
	jD8fTOzLE7AH/YM6aHVqzhVKo=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCHsO+nu2Vpjun8LA--.33S2;
	Tue, 13 Jan 2026 11:27:38 +0800 (CST)
From: ranxiaokai627@163.com
To: kent.overstreet@linux.dev
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	david@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
Date: Tue, 13 Jan 2026 03:27:35 +0000
Message-ID: <20260113032735.161838-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aWMLQkvushKidjQQ@moria.home.lan>
References: <aWMLQkvushKidjQQ@moria.home.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCHsO+nu2Vpjun8LA--.33S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWfuFWDGr4rKry7trWrXwb_yoW8uF45pF
	WkGF18tr1kJ3s2kr17Aw1IgrySyr48Jr4aqw1DWrW0ywnrWF92vrWI9FWSyFnrWr93Ca18
	Xa1ava40vw4jv37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUo5lUUUUUU=
X-Originating-IP: [117.176.243.29]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxQrMGWllu6oN3QAA3X
X-Stat-Signature: h7i7cjysunmp71gyzweoyna5ore6q4zy
X-Rspamd-Queue-Id: 0C670140007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768274875-677756
X-HE-Meta: U2FsdGVkX1880Lmzlkg5Fb3h28bK79J8xfB+eWZdiVleJxCOJoAMgkWfGMUyhe6MZN4DD8MLQjhb9I1YLq3HRhjgNzhmCyT7yF5Iq1t1UtQrT1mtu1Sk7jHR69IZVRs+L7PyxnULE8TYPy7vl+93hYqTchn/XZbvbtdGOtxBLmDx0oM7Pw2q5+K1uLyXjVoxSthnGq2HRnEZx/Ubk4RlzbaDwKGxmN96hgPWBTDmZJJk6bgKqK/qgQ7rwPv00GwvtbHaeW7c7BSEu2pCFdE+5iu0caVE88uVzkl7zLnt3jtddrX9b/quc6ip44QOTfaTb4AmvCYimh5w6VY+KMnOb5oc94sLsdQO/p8Pwbyd/8a/aft63dI5WmKbGs5JVYiBV/tcHT7g4N801r4nyWnVimvlGspL7rjw8kgFKn0txKy5pqqONLkDY84nMzLTuCQeVvcRUwlX4ekNZXkbWYKZSxGT5j8NgdesXbQ1gF/T7IfBOXwZIxCvk1ttzPMb+EEVL5E4bjMxtXSVDEUHByD7nGyAgYmVprNcYo/PF8fqz6Qo1TZdFLcZNpoy7VcMXgag59mJ+26ZWIIq9x9YUxwtGavglqBe82hipat28Enm4ZXjFu1iIYNCIzS4fnibQ10tAWmKaYBDkZBqO2wUHvuRO7sahLdNbxqjzy08+zfbgbB4BPnkmL427LdsxyZ/qtZcP/SvhQbysUtqSeUnm2/a7q8zu8wOBub100uCUuMxharzQWh8vvw47IAWqxkUiwmT61fDZxGqq+PnREyXUcGV5ovE7ai9rjS/WCmeGph3vDotMgXpGqTnWg8hUMP7iQHNGVDrtFIshJdbbNf+SWzI8Gm1EYWeMwJPDzLmGamtxbO5yQ6IokVU66roXozjBdLk4ANPYVmebuKbNKQg+vfiyUZHxKGOvCLhJHjPF7oqBzRKPwhHmauhnLgn9B9uvsNLmyPEOVQMrbCi+36p7qc
 +Bo/KiGy
 P8uR3oCfMJMN+/PSC1tW8sm/m/N1ksjhybfb0xcu49KVSohU8PrcyQkLNirGJ/zJoogsrrZiu4vnSwZyt54uZFXKD1OPUbgEMHl3zpTBIYRtDPtVZvqbNOHAM+ht0xLrjn/PCtm74Q5WrFAdqEKlcKSVPCOjH28yCA1ps8JH8jGSPicLQgXP779cIdsZK7aA+8a5R/9Vb+vmcImRCBFS9iip20kQWn0BM+Zdo4bWAs6H3B5dRab0qXw5sg8F/d7plZrpxkL3tR7vrBxl7AAjiqqKBBmVHU5jzbfxh7Np445hpjv0Ltbpve7s0eNTIA+PgR9MBif1tPGZnKex7a2GVZYXpOUVp9ebieubT8b92O3/2Qo+InNZp7bvA7Bqbg85KSCC7M/VmC8dAXQByZlydILYvimXjyXth5jPnjrgNKN6+8/mObzubia+K6vvCaFaSPUEg3gSiAvyafZ10a6nF45mJ4inimob0UJ9rHWWnn3ibxJAe6+kGEOj5nQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> 
>> Boot parameters prefixed with "sysctl." are processed separately
>> during the final stage of system initialization via kernel_init()->
>> do_sysctl_args(). Since mem_profiling support should be parsed
>> in early boot stage, it is unsuitable for centralized handling
>> in do_sysctl_args().
>> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
>> the sysctl.vm.mem_profiling entry is not writable and will cause
>> a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
>> rename the boot parameter to "mem_profiling".
>> 
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
>How was this observed/detected?

Actually no kernel bug or funtional defect was observed through testing.
Via code reading, i found after commit [1],
boot parameters prefixed with sysctl is processed redundantly.

[1] https://lore.kernel.org/all/20200427180433.7029-3-vbabka@suse.cz/T/#u

>My reading of early_param() would seem to indicate that
>setup_early_mem_profiling() is getting called at the appropriate time -
>and then additionally a second time by do_sysctl_args(), which then
>becomes a noop.

In the handling of process_sysctl_arg(), it at least needs to call
kern_mount("proc"), file_open_root_mnt("/proc/sys/vm/xxx"), kernel_write(),
and filp_close() for processing.
I dont quite understand why it was optimized into a noop.

>So the only bug would seem to be that the sysctl is not writeable in
>debug mode? There's an easier fix for that one...

 - When debug mode is enabled, a warning is triggered because the file is not writable.
 - When debug mode is disabled, do_sysctl_args() cannot handle boot parameters
   like "1,compressed". It only accepts writes of 0 or 1.

As mem_profiling should be parsed in early boot, so this makes it
unsuitable for processing in do_sysctl_args(), which is why I have renamed the parameter.
But as Andrew mentioned, I did not consider the backward compatibility issues.


