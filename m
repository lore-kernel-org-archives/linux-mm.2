Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5814EC1EB8
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23306B0092; Thu,  5 Feb 2026 08:44:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB616B0093; Thu,  5 Feb 2026 08:44:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07776B0096; Thu,  5 Feb 2026 08:44:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF9C06B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:44:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 652BF1B284C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:44:45 +0000 (UTC)
X-FDA: 84410523330.01.95EFCAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 764C340014
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:44:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLxb9xi7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299083; a=rsa-sha256;
	cv=none;
	b=cvQstkpgfJrbQ2LF+VV30tYxNeZmW11qh3/SlVqfirgXe7k32eIgHfZwDq9X9YdhV4kKhF
	Qw9GnNKBefK3QgbV7tRQHYEAqoHb9NCUSIC3xPDMoLdxwN8EfuwTOjaEgWsfnFo1zUF0tL
	Wzp5R4Q7gkEe8XoUAHSThah/B//JyHg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLxb9xi7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvavgnhksTGd3tqhlRUGr1n0VgKkunvVmA98Z7pF/Dw=;
	b=twBrrifThdYBJtC9kqh41TLV788FtCDtetkg6opVdfI24GGDbTR3JQNyT/OxZXUor2iahJ
	2nXBpZDM0o4S0ywfDD173Cn29vaIPnsFiFPXHWKeCJl36YxHVpuCapd2jjkKdOSmtyUeIZ
	Af8mmPMW7NPJKMWvpa9Xx+gqp4QPG3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D04240BC2;
	Thu,  5 Feb 2026 13:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A732BC4CEF7;
	Thu,  5 Feb 2026 13:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299082;
	bh=oN2mtMuaL0wRg06xOfWVYtvkom3Wrc7dRFRV+da+k1M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FLxb9xi7xpxwGHRcQ49oia7/YSMbfNHdByXtrqveYFtcJcf18iTZABv4yGzVX5fZD
	 e6hW7jchgeJzSVFqF1/b43yLZhF/bdXuRezcsdIvlyn13/SBa0XHpkzQswqXMDpX+i
	 YDdqIn6C/yYkOufYz4BJEBJqnWVNLLdZrBoO/XgvShsxNnKcau27tDSQ1n/m/tk4l6
	 jMFzNGHIN1sc9PmcHB+fsKDHm7ZSVOZx7DX0BHp9dBerqyvX6f2E9G9YCNmyijSNi8
	 vrKEKmV80Em0+uXpwoTwD9kOU/0Wg4JG7wqhsBxfYO9CzxyBRUdUibDUBpdQIuJIy6
	 oo7fYTYi+PVAA==
Message-ID: <90226c5d-4f0a-4a29-8c5f-1b891e724c2b@kernel.org>
Date: Thu, 5 Feb 2026 14:44:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] rcu detected stall in shmem_file_write_iter
To: Zw Tang <shicenci@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 rcu@vger.kernel.org
Cc: "hughd@google.com" <hughd@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, paulmck@kernel.org, frederic@kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAPHJ_V+75SmoRQmoQmAT0GfdP-JotzwW801uPHZtHyynwdSOgw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPHJ_V+75SmoRQmoQmAT0GfdP-JotzwW801uPHZtHyynwdSOgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 764C340014
X-Stat-Signature: misdi886f1by3ar9abu5ujwzh7z7q44r
X-HE-Tag: 1770299083-941735
X-HE-Meta: U2FsdGVkX18N3pOpkxKBkSHS35Gi3jvRO8gytSffDUlTM0IEI4PUn/c0MRpRKfoiqCDg3tUn1YIK4VQiTmrFHsQTAmmmL0aw6wgxdqJSI1rU5Z5QVoCNgo6Wga2gQQHDk9/d1B2icf5a1t8Fl1ff+VTLqcdMa/nxxFQtnFJwXlZdKU9BSaOH23Dnfp1fH/W/oBxBaibWvELg3+DKpFO4Qa57M/e5SjxyH9NSbuwLW5bQo0dIWWcjRbDUQJStdXyyAVTh7RhCFVPWePEng7NQRLb9MprCJVcUAwjkYg72Mr+XTa2S3hHwi+S9EV9bL+eTdZAeLpfGAhjvEpv9FImJSBdDjY8C3xL95F31ppGJ2hMHF8InNm9ZHEBlodslDItvBMBvoloJcmyNQafCe6ewlbiaVDDEHcMiljDypDYcPkdQGxWgM+1wdZooVX7PXrkUJWhNaHxaiDXGu7KasVBDCBei9U/5SDwYro5P5PgJIXpy9feOPcWRCju27EifY4h1snTru/nFBOCXBtD1z2nBz/Z1NnXr98ip94t8oag3ICc9H58FS1suCL5a/XWOuuBcccDQ47Ii655pXdAcXl3t0lKZUNJna6A7MM8wbm/hLPD6pAAo3PIy2GsqrmCzG5nckZyJv4iIUPt4Xw8+AOFzJ5xy2/F4K9b9ldHzJzBXweb6evx56TpYKy9XAwUbGZG9gKddT6YUGdIhALHsRY6TgYL3HTCPYM4IaV9zSVAcPgxf0zbyFCPS5BkKs7E1WcuhMtv3MmLU70ZKrS8r+A691ziwgMwnvzE6WGxmapBBTOOEQC61JzKKjc54/PgT6eKBmAOyA1Ql16wH8hhrNkj/yeODaiGRVq+onJbDnrQ3zXHmy8QXJQHisPWkIM2cm8LBA8zby4kuxB64sSan05Gogu9sEWzgxUpgLyeHXuYANOL3IhNb1e81KEKQPSzWzzWYwf6MfZJiZnIocc2tpyC
 CWWIZWGX
 u+AxaFcYk1vIAKhTK2QOqSBzs+cPhLOYm6JLvtI1BUVh8Ji5YjfmKnyrXAlCdq9AUvtxwWKukHMjR1XQ6zWofIg9KRWa7MJpEfAu/m+uXAXejbCE4qJ9BS5dILqW7X1ZezFHTweRx8ngtaF5Hanl1BroMgGCqyttalbtvpaUmc46OB7MWRLGJLE6FjXWPE/kRRxBT3XOHQVbnKEykM16nSpakBy948BToiUshWG31MhN1hCPJjr8FgHtqlmPa19106iV4GbYeIdZm6RFerV7E3OJvQMke9RZGAPveoMn+1bkP428DUerHvPl42ZExF4mVfPTZu5TSSPdC7bh2871+jlayiq4Xi8X7xfBO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 13:57, Zw Tang wrote:
> Hi,
> 
> I am reporting a reproducible RCU stall observed on Linux 6.19.0-rc7,
> triggered by a syzkaller C reproducer.
> 
> The stall is reported while a userspace task is executing the tmpfs
> (shmem) write path. The blocked task is a syz-executor process, and the
> RCU report consistently shows it running in the shmem write / folio
> allocation path for an extended period of time.
> 
> The relevant call trace of the stalled task is:
> 
>    shmem_file_write_iter
>      shmem_write_begin
>        shmem_get_folio_gfp
>          __folio_batch_add_and_move
>            folio_batch_move_lru
>              lru_add
>                __mod_zone_page_state
> 

lru_add()->lruvec_add_folio() calls 
update_lru_size()->__update_lru_size()->__mod_zone_page_state().

On SMP systems we end up in mm/vmstat.c:__mod_zone_page_state().

I don't see anything that could block in there.

Livelocking? Or we're actually stuck somewhere else and the 
__mod_zone_page_state is misleading.

Can you try running with lockdep to see if anything pops up?

-- 
Cheers,

David

