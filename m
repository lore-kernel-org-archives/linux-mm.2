Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E314C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07BD96B00CD; Mon,  6 Jul 2026 12:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CD86B00CE; Mon,  6 Jul 2026 12:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84C36B00D2; Mon,  6 Jul 2026 12:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C07A06B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:01:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4098BA0175
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:01:28 +0000 (UTC)
X-FDA: 84958816656.12.9F1DD29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 510D140015
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:01:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okefVVjP;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783353686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIjsvZIGtDb45yOCtzuITMhCZIXsn/rA4+SmB8HdYiE=;
	b=V0DBnsf9wJbcyKnBj0kRdn/8UhDpvrUvcmcNV73h3qWd+QXA5V8XbwNvKUivEAtOW1RYKu
	v7A+8AyWBbguLJnLGyFzFVoLCmdQ7u/QHO1wZy4uYU3vnWg5RpAWuiAhJ+2uq2FPBAMPku
	0pYCMFJgpTBWyhu/muegW471VLbYBN0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783353686;
	b=OXBFsQSdPifixq2JM3NLk+zvzbkch9cpGSP68/c1N0HFpz1q9WdWGi0C1HMt4QbMP4UHXy
	LO6+Q1oQIlOdM6fsuoPfsotio071ZISBepvHBG2E6iLSsqaoMmRWnn0MffhcDTtJursrSO
	TfUo9ciq0ERWR4jP1X4XwP+3oNl2Ba8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okefVVjP;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A07BC60098;
	Mon,  6 Jul 2026 16:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E671F000E9;
	Mon,  6 Jul 2026 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783353685;
	bh=zIjsvZIGtDb45yOCtzuITMhCZIXsn/rA4+SmB8HdYiE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=okefVVjPOvMtHSgZqi2LcJfAfJkW74KQqZku3zSnBXSyjlCmqe9KJoEheA1JNDmWa
	 kQ0jbGkAdaakorgQF1UuIQyCN0/dt95BjlXgTJyQZk792sDw6TIAgBlITpL3P/aZc2
	 sSAy2ylA+7R80ZTW7k8GNzAtWFXjj22FDWktB/TgoYVOeXiScTv2Lg7/+NbDK+j3H/
	 QsZXlB569wdyYIOy7CXF+3jfqmqXhmtWlonHwz63z/DNFy2xO04JEkwkJ/fV2tPXjk
	 4E09L/U4YOhPiSOg+iETgj2CXxZyygHAgfn5VARj2dix+DJkKJhR7yskyg1yrh7U6v
	 muMvUHAqXU54A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: brauner@kernel.org, david.laight.linux@gmail.com, jack@suse.cz, 
 jannh@google.com, kees@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, mail@johnericson.me, shuah@kernel.org, 
 viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
Date: Mon, 06 Jul 2026 18:01:19 +0200
Message-Id: <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2085; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vCKa3tHYjrHa3FtjHkl8GSix2F/vIqRMdeiR5urB4iY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR5XwxStPp6qOYYR5k0Iytj7zmukvqTzkzVBhPVDDPXX
 7hl95Sxo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKfVjD84WuOE9jCfejZzJNC
 LZ7JfKdd23v/b1lxJVdS+52jyh5OPUaGe+yr2ft+SZgxavO2Nb3jbS3WTLe+nWA5q+rtbaNfdZG
 8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 510D140015
X-Stat-Signature: ox3711jk3w3khh458jhr3ccikbkwi5j4
X-HE-Tag: 1783353686-698239
X-HE-Meta: U2FsdGVkX18TxySR7T8XEfijs3bT9QF8XQNpyPPJsmooaUSBE37NhKh743X5zKoaY9jV+m9KNOG8xLSVRhmgX+mZ4WezRbxitEjyu/RX5LbAyVyqf1XrRKym72nseSQd+ghT98XjPGAWHdu7L2L9RAmzahDdCHfWP054h9Ru6vu3PdI2GMcIdiSGCkzQaq+God/2uI3gdnUo+GbG4da0Nudr7pZgT4by44gVSs52jqJn1C3iFGSp4eILooBLQshAaE6X9L9LIpF+zWwDFtexlA8B2NAsUHNJEhTR+5MbGA/mtOFxiVquuaDkfFA9nky8D3UX2egrNRRxfYjIBaBlC7uZ6GH+rLaS+Rrd/QJXBWwi8NS1D4Tr5dvFferaTZZH8NkCic2TmaNwWHvMCXYZ2cthYW5OYPi6XP+dmBSJWc6w/RQQdx3wv5n84amUGHsvcWVTubG4R9xjrpCmSaJrHtaVrwLG1ePbU+YkIXgQl+Kjqovg50+FJssGCuriXMaYmZOabaVGzI5WHo1nZ6LVVtA34Q042UaGaF30CDvSKFHHSjPuYpO0lHKd90x2UaP0sR2peJe86CnGMDP24WxlVlVN5nifH0FmBxyTbfmE4z8idPvmgk6QrBULUwch9UzQ0KzCJb9BzJANF8rB/plolvIIT0Mc0GzAKor7aPi4Mo4e7EDFsQxusmHcIHHGztFFw+7WUOYHcbHq8cQZvsWWYBc97MG7j1kj9x+qjxZ0Gu2a9T8RpdtsOE6nv/Qy2qt60vSGmSMeWiR8FU61DA6sJ8SQBv9DBtn6fg4Zs+A3z71SJ2LHlUz+mqLFGtMtd3dQGc3ESl5DikXwlXjTfardmv9mW3Ia9WaSMIp3tkOsHeKu3pKWqDtJGWxBVytZ2QiRJMM/7EnWSFtO9kQ66eeL3rZjFVFlPrP4Nn2CndWJrjnkaxaiVMFxlVWwhRYppRHi6p00PNAFxqcHvxRZQZI
 N4FJD6Xm
 t0kwuGApdAUzIavpvJtRkn3Eq6kSpaK3ndIq3Rm0nXUt5iGF5Hpx7nBAFxNGtpfycOhHASbUdHTQIwz/7+gC4Tbp2QUI7GPgnAJXgum2lCnNGVrC9HsqhDbXfr0aMGMxZiUHnO6xItHn/uQkmQlB+V3SdpuH2fRty2LLBl0K66q9k4WpXZQH0FjFAExWEOzbL6UWUgv7QlgdyuOjWCsrXQM1vu70KY9I16yh6mFwxbsM82kQi/inVSkebGt5UDUt5CgRr4adgCUEy9todv/LsiurD64L9jGI7617fGB27dSr685IVaq8j6PFxzfh3eF8wT4yKfONnYY3mBCr8xVQ1BRl9ETorHgMIWNIQiDVvD32colLdTQEezxf0U/c3mnqfFZ+s7M//uBfalqov4UrCGB1B2mh17WkZy6av+VmU1PMgjKfNB7I/jSg5IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Historically binfmt_misc has only matched binaries by magic bytes or file
> extension, and always redirects a match to a fixed interpreter recorded in
> the registration. This is insufficient when the match requires parsing the
> binary header (e.g. inspecting ELF program headers) or when the interpreter
> must be computed per-binary rather than hard-coded.
> 
> Introduce a new 'B' (BPF) handler type. A pinned SOCKET_FILTER program is
> registered in place of the magic/mask, and no interpreter is recorded:
> 
>   echo ':name:B:<bpf_pinned_path>::::<flags>' \
>       > /proc/sys/fs/binfmt_misc/register
> 
> When a binary is executed, binfmt_misc runs the program with the
> BINPRM_BUF_SIZE file-header buffer as context. Returning 1 selects the
> handler; returning 0 falls through to the remaining handlers.
> 
> Unlike magic/extension handlers, a 'B' handler carries no interpreter of its
> own: the program chooses it via a new helper, bpf_binprm_set_interp(). This
> lets the program compute the interpreter path however it sees fit (for example
> relative to the binary). A 'B' handler is therefore a strict superset of the
> existing magic handlers -- any of them can be expressed as a program that
> matches on the header and sets a fixed interpreter.
> 
> bpf_binprm_set_interp() is exposed to SOCKET_FILTER programs and stashes the
> chosen path on a per-CPU area that binfmt_misc reads back immediately after
> the run under migrate_disable(); only a match that set an interpreter
> allocates.
> 
> Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>

Ignoring the blatant bpf abuse here I think this is quite workable. So
this can be turned into an actual design and patch imho...

Note that binfmt_misc is namespaced and can be mounted inside of user
namespace + mount namespaces fwiw. So a container mounting binfmt_misc
(a fresh instance - few do) would escape that bpf program. On the other
hand it would allow to register a custom bpf program per container if
needed...

-- 
Christian Brauner <brauner@kernel.org>

