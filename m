Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B80CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 05:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EB48E0002; Wed, 24 Sep 2025 01:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38BC8E0001; Wed, 24 Sep 2025 01:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75AB8E0002; Wed, 24 Sep 2025 01:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5D758E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:46:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 860981DFF96
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:46:21 +0000 (UTC)
X-FDA: 83923058562.27.803F9D1
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04843140003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:46:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=rVGfQL00;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="/mmLDvlU"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758692779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceNeCilvWmvDqFapyK6FLjZjj+QYbrWfVKvkUR9mCAg=;
	b=Afn7RQa+I6T/HGIoHpAmuajS9v9tmm0gYyO8+YQZdKI51kxiN7mt0xENVrH8GAEEbumayU
	y97mlQlM0YBrkCvpASf9udXN4ubYKBxHKPzLeJIGXNDqZhkUJpLBROV2dw7TE3bVLGn5OZ
	+k/dkXm/sqhARQhGwsTcbeuDGoGN2Ms=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=rVGfQL00;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="/mmLDvlU";
	spf=none (imf09.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758692779; a=rsa-sha256;
	cv=none;
	b=mOGNkJnvZ21OusUaXnslBnxWmfirjziSra9JPTZ+ISzkS0hqLj8iLa7jUrYRMDtzbqNzQK
	4a+CEUe1uYhmrr9UBSesPGgZPGasDHJMWD3NDvr8U1zWbo5mSCHAOIpB5JxITVd9dRs52K
	AzoSxmieraQPUWCYgQ6kyDbOhStgjnM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758692777; x=1759297577;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=ceNeCilvWmvDqFapyK6FLjZjj+QYbrWfVKvkUR9mCAg=;
	b=rVGfQL00k6mSUNSSGnPAcEgyLaqqLxakIkTBof7Q+ftRDBwFHkbG/9DvMSEtvd2QCb8SOYfOBPxCR
	 N5/c6JN5n/HnV+4qkGDX1ngTXGp/tF3TEUcxUg0vKm3iUEyc0XgbWvfEFAPwnmVu+yH5NxFGapMKDD
	 WP8LPoBLSH10+RttR/fQ9K8HeqCkcWr7BUN41EcqFWtw8hpj1gkQGryZuAeBqq+Yjmx9Zx8tLgJOK/
	 o4KujiS68eGAdlPKkVZj3ahR6OBh46vwT43ijVv4aiD7rUKPf8ubyBnA7P4JD7X+kivX0siJk0C+O/
	 xGhiwYI+m8gABjB3zavHgzN4JkLZD0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758692777; x=1759297577;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=ceNeCilvWmvDqFapyK6FLjZjj+QYbrWfVKvkUR9mCAg=;
	b=/mmLDvlUG9BCiHooLMXQhGuhyg6nbm5ZccML5W5+71RMPj83kQaXBl75QOy5lV5es2/cebmJCOEfN
	 KGadZpNAg==
X-HalOne-ID: c83fe29a-9909-11f0-85ca-fb5fec76084d
Received: from [192.168.10.245] (host-90-233-199-55.mobileonline.telia.com [90.233.199.55])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id c83fe29a-9909-11f0-85ca-fb5fec76084d;
	Wed, 24 Sep 2025 05:46:16 +0000 (UTC)
Message-ID: <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
Date: Wed, 24 Sep 2025 07:46:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
To: Johannes Weiner <hannes@cmpxchg.org>,
 syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>
Cc: a.hindborg@kernel.org, akpm@linux-foundation.org, alex.gaynor@gmail.com,
 aliceryhl@google.com, bjorn3_gh@protonmail.com, boqun.feng@gmail.com,
 chengming.zhou@linux.dev, dakr@kernel.org, david@redhat.com,
 gary@garyguo.net, gregkh@linuxfoundation.org, liam.howlett@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lossin@kernel.org, mhocko@suse.com,
 minchan@kernel.org, nphamcs@gmail.com, ojeda@kernel.org, rppt@kernel.org,
 rust-for-linux@vger.kernel.org, senozhatsky@chromium.org, surenb@google.com,
 tmgross@umich.edu, vbabka@suse.cz, yosry.ahmed@linux.dev,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>
 <20250923215929.GA1122379@cmpxchg.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250923215929.GA1122379@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04843140003
X-Rspamd-Server: rspam05
X-Stat-Signature: 9ehhhzq6juuyqc8uf8cpfwngyqce8tnd
X-Rspam-User: 
X-HE-Tag: 1758692778-855864
X-HE-Meta: U2FsdGVkX1+VLqzZlA1LD17ASFym70kliQFEK2B+9rwhMpmC+W1rkVF5wkfZBVGW2odT4EEkPZRhmNa8RO/71P+8wy1SL46oqbQAhzMC+48tNkCzFldEXt0hU4IKHRc3VM3BLRqpssLti2x52/gcmxs/sKykMhj3HHhfpkzAukhA1YkeTVKvcWpLyTc56Ji14w3MdI6rknRnCAgLRQeAoSsJc+TZu4PcDuRlD2u5x+9fvEoGB0AIs/yWt32XeGq3wGvO0mTQDKZMYUklEogDK700+o1XCQUCQP1XnA/mRvARpb5ax055WyI0NGUqZX8xGcfWThj/XX62+vkDbhjfDOhZvLu9in0HtoGjQlOg1Aq2SDitkZlTfr0rSRGIlIvLV/svyI6nUytWx5i20ipQz3RL6/IZLgS9qqMAJVx5Ahu+77SwUGpHfUNzA86trJuesoYbY+9PFE2p+Nz2cRPPO90KhgE21BX3XASVMki0RZgZ+5BW0L8Idn3r3ef1nb87Mkx+mw0EEhZYd541Q71ahoj2QzFU63QNLrYPYMlzcAutvWMrNIlRqlGFGCHs+dkMOGh4kFX/4EnYtP1rVjiyciNmMSgvA/MHUIjQQwNf1Z+MoEwRVvoROgfkRZlUr2KmuvqqbIWd7TcRsqi/0gAlhKXXoDJiMfJrt9FjAIFUJerSAPjdwoy3BvqyK78OOq4H0W7HaxDDCi9WpP/MjVnPML/P35mg6L1IXI1lARuONFvPHroDwdqppx/Poc7Q6H/o+yFYf+x8A6Fl4CrxzSl7GzL+OAityWEqIkK+beo1Cfs3lksPFlAQBjZFpZgTX1O7DqR8ofUDQyfddaDTnzATNhWLo3tv8wEO0YVRSsI3YklpkjPWvSJXNVzQVvUxxOrImnAcRXyCvvEC6PSLnWF8Zea9wZQ59uWDjFSLnZM3RZSGQ+/OR6P8lQXh9mVCUIXZGbTeESCle9e72JyZ+6j
 RQanHmsC
 8MwohnuyVUghlXSt7NWipsbQlxZJ0RioAyWoGAqqgS9Vd0OY3VCAb0pD9Ig68rQjOSOVs7rH82bsRdTho+HWFt0ygiDH5QDTyvL5D5pcLMzOvrrcINCKhaav235tQrambyMGJYavOJbs8dU8lyj4DBXmL8fW3nmTyBytZ1hypjTZBCWkj3tpofYfdza6DvmTJNWqTjFPrhamBzpCzztYeFU3eMX/FQwJnd+AP9ZT4WKDaQU4OJ5dMxXfS5+gjlV8MVe5Bpoa8zjz9X16X2QEhW29QeOCqQ8j8jPTpCGevZsGud+OAUC5+Nr2gaNf5SnanTOGkoANypj1zKMznCCW8rOD27e6FUaLDeh+54rTPBHIyTEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/23/25 23:59, Johannes Weiner wrote:
> On Tue, Sep 23, 2025 at 09:50:10AM -0700, syzbot ci wrote:
>> syzbot ci has tested the following series
>>
>> [v6] rust: zpool: add API for C and Rust
>> https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsulko.se
>> * [PATCH v6 1/2] mm: reinstate zpool as a thin API
>> * [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
>>
>> and found the following issues:
>> * BUG: unable to handle kernel NULL pointer dereference in zswap_store
>> * KASAN: slab-out-of-bounds Read in zpool_get_total_pages
>> * KASAN: slab-out-of-bounds Read in zswap_store
>> * KASAN: slab-use-after-free Read in zpool_get_total_pages
>> * KASAN: use-after-free Read in zpool_get_total_pages
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64
>>
>> ***
>>
>> BUG: unable to handle kernel NULL pointer dereference in zswap_store
> 
> struct zpool {
> 	void *pool;
> };
> 
> struct zpool *zpool_create_pool(const char *name) \
> { \
> 	return (struct zpool *) prefix ## _create_pool(name); \
> } \
> 
> u64 zpool_get_total_pages(struct zpool *zpool) \
> { \
> 	return prefix ## _get_total_pages(zpool->pool); \
> }
> 
> You create the zpool by simply casting the backend pool, but then you
> deref it twice as if it were an actual container for the backend pool.
> 
> I'm guessing you didn't test this even superficially?

LOL, no, forgot to run git commit --amend so came up with a wrong version.

The Rust version is correct though.

> This also still proposes an API with no in-kernel user.

That's not correct, zsmalloc is the user.

~Vitaly

