Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B32A606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z3imFrBR
Received: by kanga.kvack.org (Postfix)
	id A199B6B05B1; Thu,  5 Nov 2026 08:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA296B05B2; Thu,  5 Nov 2026 08:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907146B05B3; Thu,  5 Nov 2026 08:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 787C66B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:08:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85382120995
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:08:43 +0000 (UTC)
X-FDA: 85401094926.21.18B1416
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9C5F140008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:08:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3imFrBR;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUFbDY3pG95AdUR3ZaQpG0DNzZe45Lp61GslC9VgxTQ=;
	b=4yJF5ciaYAcaDnBwInueN6lGamGttw3tVaw1pIXcOY+uWvaiw3S3NLHYvxuXGvFtV8G1x3
	h1MmEmApuWPHz9ZGStluKIIlS19T2akQOZ+4dgr8W/XdiGaHKn+dSYMZKIPM0x52aGiiAc
	PIwFPq0LhIeVAvnGTnKXKR1eC2LmSy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884122;
	b=m9POpEmaL57kfn3Z6E8bUnSWiMruSMd1E5vXJ1OnWIkAAAmewoxbk/UOhkM3Wn8v8JlEu5
	c6klrPgTGmG95gSCSJdQRrcWuuwTJDfYjJ9U7fUymypNY7Txgpg4ethhZUTpub1EmVv5Ga
	qDgq+p+95IWaw1Tg7LsMcor0h5ilnEo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3imFrBR;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30492404B5;
	Thu,  5 Nov 2026 13:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87E1F000C1;
	Thu,  5 Nov 2026 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884121;
	bh=IUFbDY3pG95AdUR3ZaQpG0DNzZe45Lp61GslC9VgxTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z3imFrBRIo9t9Yz/Ltm7Ff8+nHDcN7NYtOjGSxZGcWd897KE8A/Sq4V/CqIvLv871
	 H/suoek4i9utHo9fCiOZgX5jaG/9bkM/yZutRwIroOlp2K38ZKl+oGX6EH9lJE5rb2
	 qyaG6ck7YoNqmzqlqBJJ2EB3YtU1lXrPG6aLcUGtmaBTvTkgZuM4WZuNdNu7GNXoCq
	 lIsMQMLpqj7ajlDCYv9m00MsHmhetq3I0LQH4pQ/fE27QcvxpOU9zJ8JKezGyYKO9t
	 793Cmut5YeoKWxEEZNvI/v6a9jEhC/D5rTokAWBTazmFQuTVVjvv0idbbMPJXJwj1j
	 pUOqQiynQ7iIA==
Date: Thu, 5 Nov 2026 15:08:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr,
	pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	shuah@kernel.org, guoren@kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH v2 4/5] selftests: kho: Add riscv support
Message-ID: <aux_0Ye5Ny2GjPB5@kernel.org>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
 <20261103080926.2079-5-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103080926.2079-5-cp0613@linux.alibaba.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6de9f9jym7fbof4tjynf6q4pnj3kpx3y
X-Rspamd-Queue-Id: E9C5F140008
X-Rspam-User: 
X-HE-Tag: 1793884121-468717
X-HE-Meta: U2FsdGVkX1/CwX09cwdQVC8sqKryIe4Gg8hVjPcPg4hs0mnh9x6OFXiQAr4BdA0g1B8R+pRXaeAfl26GI4H1jCNpmDiK1QDkNKPGqDcgNlHnEmHdJ0ZyFQSunpGUxkn7wJF0W6xHeIEMW8kHbfOvmeDxt06+/3HAJ3SlRji3lDd1M9tdGPBLo5joD1ygT2ty9QGBaSDwhXfU+DqDmxcDDqbHfA7k+pLWQ8fBXe6OtEiOPVIzSmdc7auTE7BYYvidbeKdZyat7BTj5t+jnUNoh0xVuR4tl5vekfqkqT4E9hjGw2pX0fdfc6uQ1tXrxoR429rLkrmpkDOX4XJzE760kXbi08r4YTRgBnVySFTJr5f5HLsOpPX+6cfgc+oN2vzNiVPD50Duen6PofHHe7GBSD/WAuNMr2+3FwUx4CxSHjC2ZhQopf072ADB9WnmFK9lzxO0G62F87MkEyiV7atRvvQ0K2A9kuCq954CaBTVxQX0zVgt+EGpfy18ky4tWthtszT5inslaRG/zDlh8xcZHCrWzCBsDWidiuLb1992MNoMurUOr+UNlT0fcram2Ga1f+JgOjiQrwRXp9y6MNM59BURzl5nxSX9dW8aZu5HReRdPUH/8Ci5B8PaTx7qbEBCqH7zNIkwJUyikquAEST17lhe0UyNVk50RpYEC10Scd1+HYfl2TSgtOTGM8AhY6ElL7qNvo2+fBKCa8a0U8dWazKvrZ2MOmtYTjuOpajGi99L/ywk9HhUoBZmE25RkmyKsiO31oySt0qETexkzk+wIpWZZsnRI5MKg2V8BmppCggg5eWHfdpeHzPWlKK0ZRth7uvoQqXWQk0Pwpq1vjGMbE8+pWFXw2eMSFFP0qLPUWKjYQK/oQMf1TckrMUfNKK7QJFzMqchpiUJM+VPffL2JQyDl1Gaw7t3vsIp5OmftkDkL8r9zH2mmH37f6aKDJt5S9h+VpeTNSG4DqVwOd4
 67P1e8NU
 6bPoqq5N39DsBgFVL7mwvRiPBET4A64VScfBlKN8/j1l2BoGQf1lnH/v0LXFT2GiugmKgus97m9RosB9GCXurRfZ98rXCul7S7xot48uYwpARHdK0r4GSGN8duuCjZq9VG7RA7E6aA3Rmr/UCg9j7HnKYQUNZQF1yeQ4ZsYqmRa9xqijsdiZB/PjgTRjoy+bivzLcxA2zFIvTxdjDpTg2T7REg0JUJ0qmdT3f4EC6USfAU70w0wBRPD00jBqgPpWnwqp0cO3LTc39bEuHfrK0T9BbGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chen,

On Tue, Nov 03, 2026 at 04:09:25PM +0800, Chen Pei wrote:
> Teach the KHO vmtest runner about riscv64: map the target to ARCH
> riscv and describe the QEMU virt machine, the kernel image and its
> console -- a 16550A port probed from the device tree on virt, hence
> the SERIAL_8250{,_CONSOLE} and SERIAL_OF_PLATFORM symbols.  Also
> select CONFIG_SPARSEMEM_MANUAL: the runner requires
> CONFIG_DEFERRED_STRUCT_PAGE_INIT, which depends on SPARSEMEM, while
> riscv falls back to FLATMEM (no ARCH_SPARSEMEM_DEFAULT), so without
> it the test would just be skipped.

We can read the patch, no need to list everything here.
The changelog should focus on "why" rather than "how".
 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> ---
> 
> Test: qemu-system-riscv64 (virt, -cpu max, TCG), in-tree runner
> "tools/testing/selftests/kho/vmtest.sh -t riscv64" (boots the Image
> and kexec'es into the same Image).
> 
>   KHO: found kexec handover data.
>   KHO: exec from: 7.4.0-rc1-next-20261102-00005-gfca49e548231 (count 1)
>   test_kho: KHO restore succeeded
>   ok 1 KHO succeeded
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>  tools/testing/selftests/kho/riscv.conf | 9 +++++++++
>  tools/testing/selftests/kho/vmtest.sh  | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kho/riscv.conf

-- 
Sincerely yours,
Mike.

