Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEBBCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA866B008C; Tue, 12 May 2026 23:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D11E6B0092; Tue, 12 May 2026 23:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E7A6B0093; Tue, 12 May 2026 23:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0BD56B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:59:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B7D61406FC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:59:12 +0000 (UTC)
X-FDA: 84761041344.14.88BDC05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B2753140005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:59:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iajF+ki5;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778644750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjXPZ8qtsDmpbPx2sSKLGRU0esgAjLG1AuEPDbp7S0I=;
	b=rP7NMfpjvL8bsfja8qu5MT7VbBi9+CLmR1Cyh+TXiWhNYaRLAaKZb5UXVGEfAko2c5ZdSU
	bjlOpaci8pWjpFv9h6oNpeFWSa/0WBMX3qEmyXnLMYFTGzxR0d+smnTuN3gtM5VPwTI05l
	MozXbQPlqSgC2bg3OpScjp1VwwcuEDI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iajF+ki5;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778644750; a=rsa-sha256;
	cv=none;
	b=s6tyzGU4Z1EKRFnez1SSrHRbRQxwCH3risXWytlf1Dwz8+Db08PLWVsR/qLcEel0eYQ7B9
	vwpKOb2gkb247uLOzsomtGvIBTH38Zt5e3Gv2w9cSOBt0mzE3pAC1jlILfyCP+5vZb8YlE
	EKxSzj+k8QpydiG549H9yaC7tPsFMzA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80D7C43E7B;
	Wed, 13 May 2026 03:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA5DC2BCC7;
	Wed, 13 May 2026 03:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778644749;
	bh=B0Isy85fo4rpJ08jiR3Hm8oL5wMKJbRNGuB8SzSk0Dk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iajF+ki5+TrO9jt/ILz7oxOKiqbAtrZ3PtFQB8UEp5N6jyf0rVshJmLuHQdsbsFwr
	 BDwU6vs6QAxLRbj8skdVmkiUWQzgi5h0lOPJIBqmu+l7oSJaLtqkFtpNAiRq3prd/v
	 if3i9ySaQbSHYBWpKVm7zJIuaG0sBwRYq1nyZ390=
Date: Tue, 12 May 2026 20:59:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>, Andy Shevchenko
 <andriy.shevchenko@intel.com>
Subject: Re: [linux-next:master 14086/14440] lib/cmdline.c:188: undefined
 reference to `__efistub___lshrdi3'
Message-Id: <20260512205908.7817ac71eb93427b17518ca7@linux-foundation.org>
In-Reply-To: <202605041353.nsZSMiIC-lkp@intel.com>
References: <202605041353.nsZSMiIC-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B2753140005
X-Rspamd-Server: rspam06
X-Stat-Signature: m9qqyb98y8pa88zj3uzj53denugtq8g3
X-HE-Tag: 1778644750-495967
X-HE-Meta: U2FsdGVkX1/FoW+zbrbJFm7pYzG+aXfpg8NUFqTO8w/IJSFYmwiJ6OJRxlxgHxI61sfFoRvYHNV1JttpTnG1n71o6g0HuqQ26SBmuSJUfy3X+nkau9ek6TDZB+hMrWZBerLDXd55/Ms2HMEd3T1xVHSUrNncOGWJqTpQMDSjnwzeTypGKB4dbF8rBSn7Z8++oeEveNpPjg4KJaE4JKpZMCJcizM1nsJyCt4vxi9WjrxWI4hc42x7yB3ZKjgKz+EeMfdU8MbIRxWrhVimVNY1fBGB1MOxwr/MmhZPtIdBS2XE3yystpEsiK/+byrR8rBDAIbNJcyl3obgMXAI6OgOJu0lyjXNiq15JlHXhs9yERGCr+5Ws8GbIJ3kPHOuUscc9wqzKJXP5+ycMWtq7hxyVHVF9n6Ln6sKz3WlzjBWImQdpQ4oxasaNZDI/4aRg/OjTJ1a9ATU1yIQ5b1No1aMs0BqkIcnSH7BW+38o6JqxtK+8Uoa9vm3LxNjwGmgs8OL0KkvQJ/iWfgYDJhg8obhlgPLTR22wl2eV30jM/aBkuweR7D6/Mrf1xAWBgKqEBKThCGIa53vyrZVvwF2siwV3hHco9mLvlcH77H3hUtf1HiO9AD+OvLE/VcLhd64NyJGCkjdlCLuFxG8nzuR1RKx4Sr5krBGyARrhuVyaFZnX9iWQuQIW/t04Z7WaSqFSnYWjqHL1a/nVKvzNbsHB7SYRsmaK9TthmYmgHHb3TqI7jnd3GEnLl9BEpuoynb3e4V01elhAtxakHDVE9CXhTef7zZAiwjHDdf8H0r9H97DvWXiOTfKoe8ASk5+5xyqHpFmykzeq5BhHgZWMRAD8LsMKrxaupr4EKID35TqgUhqFpDRrGeVLrfBzCPlx7C0MZi6Ea/we8wj5lU+ge7MKSYFZvj6V5+KC2DrFPMsiWu3gAhMjzKwXyer5T40mdAaFCQmV2q9zQCSijQhE7CqGth
 g9ArXP6U
 lwdFMqb8QwN+fD+cfjAT6oRQTlV1dEhetQOblQpQJnY0iGUxBlDUvJsD0eSWiOhR4rWlprPWr739AMcuJj76W03uqSsQvQIgIANaJOKwMmuCvGnuVAjvPieTbNWxzcuXlwU3fPF1Bxb8NO1Ts7vEexewEXIyE4hDa2VclYvGbZ1JkQiTNw6NdZWXwBnBzqLJooP2qW640M9V3EA/FsMKgSTFi8iwMei4a9WqJM9+YcZHDAPcPgKL6wqfFE5X73eW+cRuHJe2VWL8G9zc+yo6OmiJnHFQFRdKVsBlIoHWsHMQihXO5LZEJc4La3wTUtyfkknfYViqCa/QdJ519ZW67gNtPe6guIlxgFucQo11Qm4DAUgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 04 May 2026 13:22:00 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   b9303e6bff706758c167af686b5315ad00233bf8
> commit: 7f448f913d6f048e448df40a877be6f5afb5249d [14086/14440] lib: fix memparse() to handle overflow
> config: riscv-randconfig-001-20260504 (https://download.01.org/0day-ci/archive/20260504/202605041353.nsZSMiIC-lkp@intel.com/config)
> compiler: riscv32-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260504/202605041353.nsZSMiIC-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605041353.nsZSMiIC-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    riscv32-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `memparse':
> >> lib/cmdline.c:188: undefined reference to `__efistub___lshrdi3'

Still there.  

Thanks.  I've forgotten what's happening here, and I'm probably not the
only one!  I'll remove the "lib and lib/cmdline enhancements, v9"
series from mm.git - Dmitry, please let's start again?

