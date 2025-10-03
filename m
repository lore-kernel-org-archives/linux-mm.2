Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D01CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437D98E000D; Fri,  3 Oct 2025 13:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E80E8E0005; Fri,  3 Oct 2025 13:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325628E000D; Fri,  3 Oct 2025 13:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6F88E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5AFC13BD66
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:05:25 +0000 (UTC)
X-FDA: 83957429010.07.7605F58
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id B5AD540016
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:05:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759511124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NtKAdZxWTM6bJ8TjtXZ5DwF8jwlXBqxKmy+B0tP2404=;
	b=OP8a4LZAEpLf5e7l2X5W044o4CpS+b4E1K/SW2Y52zS/936AyeIU/WzNfghT2Nyisw98St
	DkDtQjQcnUK+BoMIinSWyvug1SwpC2wXZNgKLuK0rao6j1qmy8WN/F9LwVYGL/ps06C4gA
	KDPLHUjzfcu8uy8DNSdqnXd2fBblIkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759511124; a=rsa-sha256;
	cv=none;
	b=IClUi5PRLV/StG+ZGqUrtfRKrOYYTFvAKTLE6OsCKVIVX6J/1qaEYD2nGkEcOvrff4MaOO
	H2iuwzpyIHqd4vtWa7shfJ9pAyaPzQLhEEsSchTtDse0GProLLqpn97rHKZ1ASsNaqQ5vz
	TAdHm+dUMoMYBvCxkikSzI7o968838Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 967C21655;
	Fri,  3 Oct 2025 10:05:14 -0700 (PDT)
Received: from [10.163.65.114] (unknown [10.163.65.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DECF73F66E;
	Fri,  3 Oct 2025 10:05:16 -0700 (PDT)
Message-ID: <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
Date: Fri, 3 Oct 2025 22:35:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251002073255.14867-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sqtdu96kaziutyrmo3zzsa6opytbco56
X-Rspamd-Queue-Id: B5AD540016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759511123-778438
X-HE-Meta: U2FsdGVkX1/2qa+Fdjy7RkknZYjrc5WpGzRlDY3WSE4no3tzWSqjQEXAk6IB6ENJz1geZp4abdkqLorAhK4gZkMhI3fstJrtXJlH91o+TeJUkxZ74QitJ3XdQ4hQy+WZnB1Vj3fZK3+MBPVn6aLzNtjEnt4JrWLCDlpquPIG7Y63tlqNnTnAVoNL9h6uFk/pgkLnaI3f9cBgeMuVnhzXFq5Qnn4CxIT23iiBGH03StEjflTu9PoUzvdMj77eToJlzrafiWzIm11zaEeEHTpfZ2W2wyOqQQz26/c0uZTPyTgsa51IyPEGNFhqvjj+YgB5D3daDQ+411IyE5Hv7zxZ7d3yynlHHuQd9NtYIL5hknHVD0xHfPFwqHIiP3ob/HIgyGVGseJAARUgrsvMwgfTPw0X2WgkbyqiaENIpx1FRk3jSvEnGiiJ9zHddIC9SZovOPdFo5FxKKV2vPpz5s3kuvBG46Kz/W5AqY401f3OuS7J1az2JKodIndB/NCX6+VHJzMUmdEQUPITVvDVXsUIk+AIxpju1NLBFcG2k0z8Xq0tN+oXgVnEcIVpSvIQVc0MKcf395napx7n5DJwnEHk7LuXgZImYiFdQCscRdD1cR8MTDDACc/bpbkiBX1dTGhJdExKicINXDX3qdxMkXY5SfVqLx6JYAYy0fM6HKtVDSryhlHjFUMkVDI2X8Sjfi9E8JYrEMoDgrs71HfDiz+lwMpbGssP7sRzxcPQf2bxpEY6JmWvgSQdUJsdDF4dE3sKQFIgXV2cKAaf4hJpBuEs1vQLxI9s5UBYZcdWCP29G9sCNTfeZkAaDx2Zu6Fz13Fdj6+g4zBImF1jtFzwRV0ZrnQatKpyOYCGiEetZ49m1qiwWY+y+VNv9t0vrDIekkhan9xlBlY/avRiu2crXDDX4KO7VbGnoTJPJ7pMN6yzcqYS5EJZPqLhTRH7Is7JqVcsnIdEDunVVZpvF7gkr8E
 LerrZkeV
 HI29CEoEaufRuF3Wd+6bwMWosHMN7Scu53K1a8O8/mNmslYs9qYvSmEDk6XoS2i+4DNENFilQhspwnadTSz4jSPLPOLcAeu8FcbyvzeuL9+4zGLk+8/BNF86YgB651FkVhqMqh0CKPAfuRfc0qM3yB5XtL5Muu1EVHbqxT9em6aWHLs9aMtwIS25wtqEfuiqYNrxbOFU+1YmVsQ2CnNYNQdZ4MsskhiMSxvSi1448XV2s50B03GCdFmMVKqKsCj27YX84Ct4WonJSdxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 02/10/25 1:02 pm, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
> and __collapse_huge_page_isolate() was almost duplicated.
>
> This patch cleans things up by moving all the common PTE checking logic
> into a new shared helper, thp_collapse_check_pte().
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   

In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
an anonymous vma, is it even possible to hit if (!folio_test_anon(folio))?
In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
till the folio_maybe_mapped_shared() block?


