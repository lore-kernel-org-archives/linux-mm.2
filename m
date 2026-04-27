Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C43FFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6426B008A; Mon, 27 Apr 2026 12:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE646B008C; Mon, 27 Apr 2026 12:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0AFA6B0093; Mon, 27 Apr 2026 12:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1FA56B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:14:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FD421BA7B4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:12:55 +0000 (UTC)
X-FDA: 84704829510.26.DF6BAC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4AD521C000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:12:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0ap8FJvk;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uc7CJrH9Gk5+1T2IWFstkscINwvQHvIUffmtNES/Id0=;
	b=mEF2cGpmXHf/SJJLIvtusyuKX79GIOCQm8JKJvw7R+9GSiYSKvWdxpDSix22+GpyBPe7i+
	h0cpAAvO18Sm8pnQvVGMAhbNGNPR6kdWc9zs+J25lijMB1HoLYJV+V9/J5/IqAxJkCCY0y
	f8iQoEABWAfDE4fsNeifm6/nKDgeqdw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0ap8FJvk;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777306373; a=rsa-sha256;
	cv=none;
	b=xRaM7nhvpYSw8Ja3+iHGa1SFCNDyZAcF0/Mt42JBrgT2dkAclHQSM6sslox9XsMIVLfNaF
	s8MSVGpJTBltPjdbwyxCrMJcBIAYManCCAVhtHfraugzMqrExbwSf/OFD+g6swWudtlKi2
	UNDkCMuO8eSbkQ5OpHvQkcGvGUXgyU4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C256941569;
	Mon, 27 Apr 2026 16:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481C3C2BCB5;
	Mon, 27 Apr 2026 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777306371;
	bh=qEsDFDfusdHG0mACmWHWon8MxNYBaBJkB3Crw97mjaw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0ap8FJvkHAVJmehqs2aymcc67N4HrgEJ6QnmNug+rjwvx/lPgO7UmxzpaZHeitALE
	 +4oCGOivun09JtdK1STyj5JX9hj2Y3P3EoCVCQfBJXhVK9S3z1P+q02IXU5sors6eY
	 3zYAPrjVO3k4/VeZj+r2+aSY0tYdWBIFqFXIXjd0=
Date: Mon, 27 Apr 2026 09:12:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Mike Rapoport
 <rppt@kernel.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, LKML
 <linux-kernel@vger.kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix destructive tests
 invocation
Message-Id: <20260427091250.61316471db20dfb0852141c1@linux-foundation.org>
In-Reply-To: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
References: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AD521C000E
X-Rspam-User: 
X-Stat-Signature: jn8wnioacpnhe7xe3jm5prwn18t1hddx
X-HE-Tag: 1777306372-370301
X-HE-Meta: U2FsdGVkX19uyk4nD3C2+56/3OS6Wr01soe4HcGUFRgAvI8lBCwF5WdB0LA7CwPygiMeYk/VnDFdU/NmnfaXD1Y9vE3sBJiWy9msn26t4qk6OFfqZMG32khRwK6HxDB/SNrMq2IU/xAqqJp7eBJ30x9rQqL4nBQJzTVLxcu5kPlbuRbCX66TP9nisYvsyH6HiaAM9g4OhV81WqPZ58RCPBpZsMAWZwgBj88/TX3/Gib2KXjVK9GUJIrsKnxD/hAHeucp76hKW2W875AtvphYWqBXH+9cPOEnzeUU1NfwVAQ1gOdXCsbdVY0lb5fXA41e/VlWASXY0SGCjhY9dhcgL1Z8DqYNBMuVxOHKAQpdjCwMH84s2Eb1oXfd5budXoEnimWpo/9plnRNKnTG1ptCQroD7pMy09gRCs5goj6xaSGFX+rH4Fj6ZP5iyjxGCZqvL/QTvwdz6FrigYICW4182nrGZkT0tFTssjwJmpZIooYNUdNsf2ze7Y+3OX63IWPhF9aypydE8Kmwog/XGq4eSidW9in2qRvGxObSYPEO7dfUjvRcrfvQ6Srp7yIgADHLvTzm8JyuwBVfGVcYCbeg7oeEYYVgQ4ws+c+py8dWnyAcTd9B4AHd3aHwQ+TEquQK2YIxUrhsEv6nlxCH/4eMMcmQGatrRG0XmUrUZw/x4sHPVlmfTAgnDsZkvPxjzKaiPjRNSFd9QNNWQThlDq+JzQXlOOaNnXlrBv2NufpEdnBRfdUCaTn6OV0Fgr3h/w78QT8z2a8g2UmzVLY+q1xHSPngNQviY9rSOgOL+U77eU+udnidjrA6/NV09aWCATmTxYBl1RCOeka9RnvBbsL5MF/Sb+6Wfzmqhdo1An+9UnrMUOsLvqjjW/baARn48FxoV7JeNMngrXmVzZ1VKdX0AAX/brWCTwKe+eznx/XKdZ/ZZVN1V9QidRm8jJaIDtvxVZlELu1r2bXzLD3T3zZ
 /QVq955c
 xYpwisrvODU+vESF6AgP3Jg9zrh/4ZeT2tWcXLm7ynkPjJAFswBHRNgdLMoggxo97ZkPAd6DDxI4lR82q8mNebcVLHT0mgOgP8UdcbRRFyPoCZtf/Bh7NAyQ2JiQqx0BRqqPedQp6B2HFvl0Wqn7UvggD2KG4Iyn0yVkv3ErEYv7QRddtlrcTV40zKp3jZu/M+w2FlbwPn7RQfUInjVSYKpx1rMKft7G3gnpZoQdr/c8iXGD/WhaIL2kes6gHVu17YveWRi/Coc+VOFuMQqcmmjPHaIij9+Zj52/jRns7a84WxBt0WgtJYAtu5jjabSyR0G9B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 12:03:51 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> Destructive tests should be invocated with -d command-line option, but
> this won't work today since 'd' is missing in getopts command-line. This
> commit fixes it.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
> Mike,
> 
> Maybe it's a good idea to add this patch to your series since the
> hugetlb-read-hwpoison selftest won't work without your fix.

Or I can scoot it into mainline as a hotfix and Mike will pick it up
via Linus, soon?

It'd be good to have a Fixes:.  It looks like a3c5cc5129ef5 or
2bc4813622459?

>   tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d8468451b3a3..c17b133a81d2 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -103,7 +103,7 @@ RUN_ALL=false
>   RUN_DESTRUCTIVE=false
>   TAP_PREFIX="# "
>   
> -while getopts "aht:n" OPT; do
> +while getopts "aht:nd" OPT; do
>   	case ${OPT} in
>   		"a") RUN_ALL=true ;;
>   		"h") usage ;;
> -- 
> 2.53.0

