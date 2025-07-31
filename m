Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB2EC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 09:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC21C6B008A; Thu, 31 Jul 2025 05:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71016B008C; Thu, 31 Jul 2025 05:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86E86B0092; Thu, 31 Jul 2025 05:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9986B6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:09:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51BC38098D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:09:18 +0000 (UTC)
X-FDA: 83723985996.11.9B0687B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9312820008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:09:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rvtxKfq+;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ada4j9gb;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753952956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+e/K9Hj4Zr7iR3DYQKSK1puSA9rY8qyq7/7F17Bvos=;
	b=WcX1psXPTUsjH1AMPkYXIQ+gvsFY7Y6uAZgmraeXda/QOE/WXmVSwqXt02Dz5c/xmrmFXK
	BVbDW93Bc8t9vPq85qfV8tisl/b4wxtlYyEx5y5Gk8ZZyiVoK526Hgu35LJw7dWE0EGxb8
	9Fws4WiCbMYYWqokSH2LUOSxg4mXofY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753952956; a=rsa-sha256;
	cv=none;
	b=j7fnwgkCUGYCEix3PbMvSwhTgjRCxCZ58dyH/LPIUsNex6OCAIW+m9oAfDXClj/wqb0Rg8
	UrxfG6r6lkddPMCDEuBC3oIgfgcSd0Sdhod+CMtcdEYrTGrE8EDbh/MaFJvYWLnWCrQFtp
	aLnwt/KdG05lVqbTvvsUAsuYe6sGxO4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rvtxKfq+;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Ada4j9gb;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Thu, 31 Jul 2025 11:09:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753952954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c+e/K9Hj4Zr7iR3DYQKSK1puSA9rY8qyq7/7F17Bvos=;
	b=rvtxKfq+9x9ZjzbGUiq7v2M+oZ57jlrg0r1UyBlj8E10BrX4166grAprwDFU96LS6v7P29
	dWLT+tAz4qkfO8Md0O4mKWUgYjvExg3uSlq9Jm2Pcidd/FVd1q55s+wfaQHBlwYqNfGhTh
	Wv1B/VESD1v1qtRcNxY/XsXKsKJXQ9MhCrRo6RtbTXQmjMdh/YnpWm7r7rsWe1Ly3OnfV4
	D1HfI+CFgTE2lMVaCDzjjT0lBakJvU9ItT7AkDgKOES1HKuyTjPWWJF1mCuFohJjXbzF3k
	KoPs8UuoVLF6l3RMNex2kxI9J8cXYa8YALIvaQ/Ys7eWF3a+F0Y/5YLFTwM9ZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753952954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c+e/K9Hj4Zr7iR3DYQKSK1puSA9rY8qyq7/7F17Bvos=;
	b=Ada4j9gb6ohJLc9CCkEN81Ot5r821xetqBjev0YdIeSRsmsSSBB88XBLRq0KclMt/UhhCj
	ZAUrbwJC712IHjBQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kasan: disable kasan_strings() kunit test when
 CONFIG_FORTIFY_SOURCE enabled
Message-ID: <20250731110823-9224fbee-6d66-4029-9e92-19447cbcda64@linutronix.de>
References: <20250731090246.887442-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731090246.887442-1-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9312820008
X-Stat-Signature: hpado58k5wtdmhwkdckagbr6xea73qzd
X-Rspam-User: 
X-HE-Tag: 1753952956-721110
X-HE-Meta: U2FsdGVkX1+qVXMwaGFaBTHU8XA77bcDdbn9NMmzQ8AvbRnHeXauBv1oIFGCHlWiWha3sUIrKxa6/foYc1KcH71i/tFIiTsP67jyZUpuzRMzeRNU2mB9T0OteKIHnXOLZFaw3ugEZyg/nMJxu2WojsSasWdXs9N7QhnGrasMf3WFS/XyRvn1GUZTEKzULtYGfzta4VpjXD4DLLaKbD5ZCehMOj2H/PD1c/EAZ44vQGYKHK0cNORxOVkn+wcAbXMqrFbnpKyXMS5y0dy8BdtcQ/TBUFU4b6JjRLjKHS1GuNFLZ8O9rWMElV+TE7WofmgDBdswu+I2KAmqtmVFUuA9MOEmnlR5EFQiPp4LzBcVQ2s34jNW4U2WQC2AFKaOJa5XTIU+Nx+xph8HsDA4lKaVu2httgbFkVkx+j317tPLssVuJ72c9q4vdW+tI5p00ofz3gIeUYt9qsYrkaEtQrzaAt7ztjwQtUP7rOFGqYiujNDhDWqLEidIMHPPZeLCKJKYGc4L2jWokoW1y9w1AjvlGJY42UrHOaecFTDYaraLC6fb0OTyExdztHCEmKt3KVYvnUUMvkQAAKQZFdD0a7ln7r6puvLAEl7UjALrmRZdxSqVpKUz1THfkf6PWjD2mEyG15UMNzlzNAnSCSQRaqRhgzB+6xzE2yWeOxdRNjlWgOtXTQ+re6lQkBmWIlQWcvLyESxxvbXQQXg1tfeOciye5puLgOkF58rVV4Tk911/HpOtCLp0IdfDjDqQY6u+GspIH5cyUDu1qLJxVha3ATAL3KJ++KD8nrNr1/RKtd0W4UNhYgGsD0nxF8uWhB+7gjeZZnE7QOyED2issqim4gS+5aFB0BOcgiKjlRU/NhZMVoSg8f+EOUVBSdlbXMcDNwRWHriUpBDiyjYcjtmb+CPO2hOwl2mKzN4LIfHPJS+S5UcTOiONrFCtTzE3296/ZvyRVMMsRBPaXtLnKmG2W/5
 nX0+0uqE
 FIfg580f8UcI+Y00aVUw8oBp7mpMsSCF4rYKA2tweKs+uYUraU7BkAfXpMVExbBxQBVv100dC3iEZEfKfvlIEt8xQ2JGDbTbbbmm4DREGji1+AOd5DxJWQhAVMAXtvCd3yZG62Y3MTxoAY/580/tYKtr9kbcdeI/Rs1vGtaFtn/iVHGYOwc9+FCokaWr0hOExsulCb1L3aEiK2xZCrgW+YMg8ZKqLxHLPrzcoFb/TZGTWkli8QYoyg8HsgnOuRVL3IzUJFGnhNspI88F3nbtJrHScyHn6v+hMgNcuaARA9a4hmgO46c4Glfeb7aM7nqmyY7vajhxNBxgfk/JT+LYJ2cp25zdo2DTLU5EZNBt6/l4IlT2qCKX5Jr/gIq11TSNSQNi9WULADQ+ccx6KeMQ568+OG6w2ovD46TYB+I9zerMo9CK243EZRtRnoZu3R21XIK8+GHyMtVkHICrebPDa78UGhxNWEVCxVk+/APIjJm1CD5HcYDvIlYsKVSzc4qVEANVzSqfbO+YFak9aYpwa+JGS1gfDPlYGEHmtc4EdCBZz8mNAHK1F9odAQz0m4o1In5o1J1lUZcAkNLt/hRxe33jjMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 10:02:46AM +0100, Yeoreum Yun wrote:
> When CONFIG_FORTIFY_SOURCE is enabled, invalid access from source
> triggers __fortify_panic() which kills running task.
> 
> This makes failured of kasan_strings() kunit testcase since the
> kunit-try-cacth kthread running kasan_string() dies before checking the
> fault.
> 
> To address this, skip kasan_strings() kunit test when
> CONFIG_FORTIFY_SOURCE is enabled.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/kasan/kasan_test_c.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 5f922dd38ffa..1577d3edabb4 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1576,6 +1576,12 @@ static void kasan_strings(struct kunit *test)
>  	 */
>  	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_AMD_MEM_ENCRYPT);
> 
> +	/*
> +	 * Harden common str/mem functions kills the kunit-try-catch thread
> +	 * before checking the fault.
> +	 */
> +	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_FORTIFY_SOURCE);

Would it be enough to enable -D__NO_FORTIFY for the whole of kasan_test_c.c?

> +
>  	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> 
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 

