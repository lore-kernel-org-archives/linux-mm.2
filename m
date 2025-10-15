Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED44CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEAA8E000B; Wed, 15 Oct 2025 03:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995EE8E0002; Wed, 15 Oct 2025 03:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCAB8E000B; Wed, 15 Oct 2025 03:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8A88E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:11:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28F9D11B303
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:11:40 +0000 (UTC)
X-FDA: 83999478360.17.00F0436
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F3F7140004
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:11:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nNBm8zcx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760512298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Do3F1qbT5+63ceqLapAJ1UbUieDzUu7GvT7gY6AUkJM=;
	b=gms3jQOl/tK9REFy3z0gUJPnqNggG164WKnIH2HsqehcOnmNMhQiffwbDEW4zS68xf+tDW
	ts+QWsWipp1OQi0rDz3OinXCqTSeticBldpwTVOP8el26deKhjldFoGpfdDmDqJuYZDpX7
	aLHn16AlGrJjN3jg6Nzwfd4XbJLBQYA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nNBm8zcx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760512298; a=rsa-sha256;
	cv=none;
	b=O3lYRE1sZchn1XoDCpNHQjRR0vFNW6NpX9SmKjV40L01CBZskkajjChsAZf31f1WMgGzLT
	YB1ttzO32lYa/PG9WT19Ko4gmUenqc9sx+bYSXtaCqx3AXlUFmT6aRQrn11AFd3nMBwvDu
	DANecw33hF2vmrKVUkWnD5lb04o7olo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0AE960298;
	Wed, 15 Oct 2025 07:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676B2C4CEF8;
	Wed, 15 Oct 2025 07:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760512297;
	bh=+YN9iv/JKaRpqQa6Ykr9VD5uGu2CRTjueccIgjbhdmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nNBm8zcxxXY1bW1Jx06JgkcDaCYB11moLnPLADeWeaWCvoe+GRIL0gbf+sLlgCe8H
	 +4D2ONNcUJrEZhesbBBxoePGgm7yTsePEWpUYmgXc+OlpJWn31es/QnYEIacJlczjV
	 AGqlxBiCtfiAaIOFXEEPOdbNvfxpdv4ToC6RwzhjswvOyRpFJWrDMkK2mmere5UNUK
	 n95C4lY8blVz38eHiYgRsWE9qLEnTySygu9US6T8CCeOceZyPTwE+d8dQdcy+MhGcm
	 lNdY8F4mJ0ycz6JQ22eUXpGtijKX9rOy2ctsVK4riTq5HqsMbQ26s4Gni4Nl9NZZA6
	 WYJXlAJsLTW8A==
Message-ID: <f7c41a0a-94d0-4189-b05c-bea31429b1be@kernel.org>
Date: Wed, 15 Oct 2025 16:11:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: allow file systems to increase the minimum writeback chunk size
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 hans.holmberg@wdc.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251015062728.60104-1-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251015062728.60104-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F3F7140004
X-Rspamd-Server: rspam03
X-Stat-Signature: o79cwyaitenbndfgsiz3oibopuzbwi7a
X-HE-Tag: 1760512298-613781
X-HE-Meta: U2FsdGVkX1+F/k3KTQYIuuBkd+AvhjR8sXHAuRcmfgFHsU6Aru5gGwdl1EIvgU9F3PcOcfinNLKC5JA8a0FBBlJ2RlPZvA541AzdiWzGBuOdTHGGB7V7vifOwqMeZuwPS83TDRjGfiyXXFt+qKtFGZ4CdyUIkwEHAZaLpDNo9mbwx1RUlL1OFNYFvd0lvbI7fROSRzA5kthAWu3hRsw4h1PFzIZqQspww/bo+tOMk0hctFnNNUznxjDyUQQ5raVE5peHDLpD26NbSzGThoukdQv+NrpeNwslNZ0ZrkZUUfkJQV/TcOaXeKVxu6JRIUNWSNvXnQ4OHGPXM41FPq+XD+rugulEUFKYbGmypgRTdpHvjhussHvcbOuZK0RVBDjetkKy+BPqhJrzKnTT+zeymbHK/Vcip8UFoetPtqbyflExXCq2laM1LVJhktCd3f6idxIFetL96w1/8/c1zlvFr53y9Oo0heG+rR0zqXsMo/6vTjdMz6cgdGTRLijMFVXjACCMQ0SCdm+m2LqtWAnUOBJ+SMsHeF9JdUYaGbWrR7jYUJrFN8BMqnyl5kkN1BNgQB97pv4MtLzJnwBUPdPybnAl0O+EZTFNtuRpp/gWycShXruCVoxXlKh1KfRF482wjHxhnn0Vb16FmTErttGbAS4vGi8tAlPOselpTFuidbVrHGDALP0OTWuZqcEfsTAe5cvCEnAzC8LxFHOiSBlUPXRP3MMu3i64OBGV7AT9x6jmnFnZFhDbJmkC5n55H8XLYfY9kX9oUZd7iIiMwC+VrvKfdGbt6y5N/kfkHx95moRx3N1GYTzhvEnYpu1RghqBkxhAPkogCakpbAFXhd8duuqNac+MaCOtm5W06UlWNmOJxCTTeg7Y3kMe7k+7C5fCzbH+XROi8T8ojYH1u6h/6N8YzobuCcuBuymkxyXWzWETozeBKiMbihLOKSxQMKQc8kxQ6fqgVtBx6A7P1X6
 zBt/hjAj
 mHCJG6OlslR/63SDGIxJ81SycnUrBqrE2nPGIG+UBwq30CnN+JMRsfKnMkBZLUulGkCaXC7A4L+w8uuJaHAX1TY+sJUO/wVwtoPfsmT+xeQss+zPz+PkRtJmSCD7JGyBCg11nFHvOrNkYCq5Wn4oBUlKTltGJ6YXve+dxBasM0SSvqF9AkpTQP5W8/UtNfQWuYDvQIpc/a+ZNYsgu92QR2TZ8d7wrIzCMDdN8jyhfaPYWneID6lnoqEbOxJ8H3ND9AqONI5RIIudCaQAjWJ55Qcj/hnEFO/JyQAEv6z8/+hLLfqTFUkZ2KxuiW98W+sQudpEq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/15 15:27, Christoph Hellwig wrote:
> Hi all,
> 
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 							         
> Add a superblock field that allows the file system to override the
> default size, and set it to the zone size for zoned XFS.

For the series:

Tested-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

