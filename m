Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 674AECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0FE8E0024; Wed,  8 Oct 2025 12:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7EB8E0002; Wed,  8 Oct 2025 12:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4938E0024; Wed,  8 Oct 2025 12:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9EB8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:13:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4251EBA908
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:13:18 +0000 (UTC)
X-FDA: 83975441676.05.57B8E13
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6762E14000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:13:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LtQzG6vE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759939996; a=rsa-sha256;
	cv=none;
	b=NxlP3MLMs070Y4YHiq1YBGXKxbWtJrTQrBypq+OYZk60q2p3twiztWBxMh3t7BRu/fomF/
	aEETQfevxpi4E+DGLE/DRU3/b8CJwqLtKZqWyBDbleYAxsmnJfIvcc0buZte0vPP0eaOSn
	+L5sCCZkoujT8YjpMQCq+hnID+MEgc8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LtQzG6vE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759939996;
	h=from:from:sender:reply-to:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=GhaQIw0YWCJevxGPseQUuOnhPulu+oVpbQ4S6ejkTkQ=;
	b=BVtZluOV6l6bLkesLc676u1rMk29Y5Kd0HRx5a7dcdDv4QWDyCVd1xROn1VdH9K0vCQ1YE
	OUA74hc9cQNvA7UtQfyulAe/P09BeVGbbVS8BrcrdC6iEHr9o0yq+L4qMYYgH4RbBPuJfB
	b/0xo1Tqt1JPLNrMjD2GuaYwGyC7DOU=
Date: Wed, 8 Oct 2025 09:13:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759939994; h=from:from:reply-to:subject:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GhaQIw0YWCJevxGPseQUuOnhPulu+oVpbQ4S6ejkTkQ=;
	b=LtQzG6vEX+0mnRrrNSWhbb5wvkg3DmJEFE2Wvv+t7ECRR85RzgFqBrNFA4zE4ODmBbPEsg
	a5AHrVJfQ/nA6c2PyyDBXF4CWLps8lwGHsZc2Hn3FI8+1TRyPc9JfUiVksdr9rXjdAsZrE
	TyRTZ59obYWiWIJDANvMbM9YkdA4hsU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, yangge1116@126.com, david@redhat.com, 
	hughd@google.com
Message-ID: <ub7i6tidjmezzgjqxk5wk3ckf2ce25fv3yxuyfgqe7f2f3llfk@eutbtrb5kpyd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6762E14000D
X-Stat-Signature: m9oxqco6our65izzmrkmq5o44zz1knjj
X-HE-Tag: 1759939996-738183
X-HE-Meta: U2FsdGVkX18V4TewTUdsmO26ozbf1K+n61Hefc6Y5MaIAniZ4FeL+qXgz0obFhxgInHfrJgQOLkVUoS0SiW9NwjLq4X9PbDYS/EkAm82g8nhx9VOOUWEQ41RLPP8cghfZb3Vccnq/VIvUQ5GqDhaFLaptVF6UeICHLwC79VBorvvESyC+b7EJ9eXvyhC+x+TO9y+wxCX6nGISqyeGsQx87GBRRme9ZAkdBa/64cC75cVvkg40mCkQa9tR93OzDawlYu/t8fKEZiaIU9lBAQ332R8W8lBYA41gWxS1rmL1xOPGJqt+K/w41lMUtAPSsW3glw3LXBB2Gr8e1zgkCNTIWuP8IN4qaxsBcjli/Uz/HJJ4QlH5EL7ktbXE+58fSC5Sn75BV/NlszVaajHjFzHAfMwx+Djytbe3VmUVIpLiRLEJHi5Xliva5VXNebS0Ga3fcAZuRtwwQHEhrkP+xE0xSqobWekq7DhLjo4CU7/mOmp5b67MCcfmTzDCyKkS0Y+5jIpviHKbmJgG206SDhwO0fUIWd6qBU0tItEV5DW8E/5+wJd/fyL2eCbo6lf7gnuNWL6HEcRYr0ZgsM8ErreRf/g+W+ECIz5x7qkqFcE2UZeerDYzLCxTMgQpFu5CfrrAjzvZA7IzF32jmbi9K6V3GdSHmNB+A/aEPJaKWTM9PKQejnAxFMx38JEbMbIcwbh5Fs5lNzdektk8AY3EaH+GOM4K4SregO/pVC3nUJtZv1HDsD8IXmcvU4gQJ1PlIQIO1kd6pqhEs0Tlf36sKbeg2qjmrY4Ym/LNoTIinzFu+dDs03fFOKOCfMyltpkObOiaMpMlgvVVJUxGThfXnkVuo3JCXMsS0jdNa+p9x8d8HYfDAj+nhtggPMGqD0ke3kw4rmAcriD4t4GL7eGnDPOXUo2ZGcllLfZ0uLO8CchsanU/JcgCraE8I3Eo0who1FKhEE4p87JYHEZD0Yj3wz
 NcThLAOM
 bN4ycTKt9AoFsV7YLAYCO1ZxgV1F6k7tkVlJdj8qqFoe1aKcezidcESozBnswVum7hG0bFMLKmAcGzBe0QA8y9oXxjAD2247u2ptzjwYmK/VHZUvBWN55QrVE+OdI+ICn29kzeSP2oimKqw5o2vMlH5OUUSKiCRTop41DTFBqsHIVAQSd8qJLANX+5MiISEgdfAtUs6AG555giB1xOOVDYPcWh958V5HxMfiQ7IqimjXDHUMQJOzTXXalE8xVJcjktnfEuRddU3IiEvjj8L/D1EInL2QGxpB10V8IF7qtDrENj4J7W5kAyEgpcllClbfDqBPxJuBCc1JxE0AqaVN++4KAYJPob1RR+kyAQDqNt+JnVbRgD0HKrQx2xaZ9kuYf9RM3ohfsnXbronNmXrvurPGM8VE/fu2/WxvF/OiKzJhoewE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bcc:
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-ID: <mkfwoqg3k66632ltgg2t6rp3l2pmkrhu2jfgip2nsn7qp7aveo@l3ajbhzvzuns>
Reply-To:
In-Reply-To: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>

CC Huge, yangge, David

On Mon, Oct 06, 2025 at 01:25:26PM +0000, Dmitry Ilvokhin wrote:
> __mlock_folio() does not move folio to unevicable LRU, when
> folio_activate() removes folio from LRU.
> 
> To prevent this case also check for folio_test_mlocked() in
> folio_mark_accessed(). If folio is not yet marked as unevictable, but
> already marked as mlocked, then skip folio_activate() call to allow
> __mlock_folio() to make all necessary updates. It should be safe to skip
> folio_activate() here, because mlocked folio should end up in
> unevictable LRU eventually anyway.
> 
> To observe the problem mmap() and mlock() big file and check Unevictable
> and Mlocked values from /proc/meminfo. On freshly booted system without
> any other mlocked memory we expect them to match or be quite close.
> 
> See below for more detailed reproduction steps. Source code of stat.c is
> available at [1].
> 
>   $ head -c 8G < /dev/urandom > /tmp/random.bin
> 
>   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
>   $ /tmp/stat
>   Unevictable:     8389668 kB
>   Mlocked:         8389700 kB
> 
>   Need to run binary twice. Problem does not reproduce on the first run,
>   but always reproduces on the second run.
> 
>   $ /tmp/stat
>   Unevictable:     5374676 kB
>   Mlocked:         8389332 kB
> 
> [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> 
> Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> ---
> Changes in v2:
>   - Rephrase commit message: frame it in terms of unevicable LRU, not stat
>     accounting.
> 
>  mm/swap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 2260dcd2775e..f682f070160b 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
>  		 * this list is never rotated or maintained, so marking an
>  		 * unevictable page accessed has no effect.
>  		 */
> +	} else if (folio_test_mlocked(folio)) {
> +		/*
> +		 * Pages that are mlocked, but not yet on unevictable LRU.
> +		 * They might be still in mlock_fbatch waiting to be processed
> +		 * and activating it here might interfere with
> +		 * mlock_folio_batch(). __mlock_folio() will fail
> +		 * folio_test_clear_lru() check and give up. It happens because
> +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> +		 * folio to activate batch.
> +		 */

This makes sense as activating an mlocked folio should be a noop but I
am wondering why we are seeing this now. By this, I mean mlock()ed
memory being delayed to get to unevictable LRU. Also I remember Hugh
recently [1] removed the difference betwen mlock percpu cache and other
percpu caches of clearing LRU bit on entry. Does you repro work even
with Hugh's changes or without it?

[1] https://lore.kernel.org/all/05905d7b-ed14-68b1-79d8-bdec30367eba@google.com/

