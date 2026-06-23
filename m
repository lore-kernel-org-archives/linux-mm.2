Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA17CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6996B0088; Tue, 23 Jun 2026 04:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A60B6B008A; Tue, 23 Jun 2026 04:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3506B0095; Tue, 23 Jun 2026 04:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 445C36B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:02:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B128440405
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:02:54 +0000 (UTC)
X-FDA: 84910436268.01.9F9192D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D6A6840006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:02:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FklgZfZv;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782201773;
	b=qwB536oxwIdbfx2gdtP8rzycbrr+9MNeZV5VNiXGn6n5I1H1krIyRi4ake8f7kTJRjfOjv
	vac39UbkznDYCtcWQ9IwNaEUhuQyZBWksoVtorv7jid2xLwKCme/RlfZKFaMfdCcyJ0pPf
	pxYZveWc0o+FfqnxTOfQLMYzn12Ygiw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782201773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGXAbbvDtMgdseoEBMP4tUzRSWv2MJSuTR3Me0ClWC8=;
	b=SlqPkl4I8Df0qkkZMyX7JfloloVAmIzSCZt68FWR+/e0X0GTnc+UuWUG8ef5gau9pKIrA8
	VCeM2YdOF7j9eRSe+quFPi/LlzyjB88p6UktZldbVGn3y+jdZAKY9JAU3COkCES/syg+VX
	H3qMXMREyOU2JopSazB/S/5jZSN51hI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FklgZfZv;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C6A2437DF;
	Tue, 23 Jun 2026 08:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986D81F000E9;
	Tue, 23 Jun 2026 08:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782201771;
	bh=uGXAbbvDtMgdseoEBMP4tUzRSWv2MJSuTR3Me0ClWC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FklgZfZvf9emq2gmny2eGq6EMuPFgTPg3jmwAxmLaYfdeYYOx9o/LUsxGSyhC90Aj
	 wyT19RvXdWlMCbyU9x5qRfWKwzHtDUwLyiTaRdHPzlhCnqASxByUiH+reBxZa6dm6/
	 2eUrKJ7Sl3Ard2QCWFs5RMYz0cEIAQCf+F3cTsedtE8mzwpzHancQo4aEImHF0L8cr
	 Fy0cEII7dznV9is/6QM/nYIXsQ76KUnc8J3lz0n9fEPXD9BgbtOHKKHco2unHFN5KT
	 hMyDhDgPqCuk0aLgK7toBqI2XUvKRYcOcAAOK274SYOnvXU30gUDeEG5XgOjyI10Dd
	 19K+31feZDQsg==
Message-ID: <d04f745d-eb3e-4d2c-8ea2-5fdcf2cf27b8@kernel.org>
Date: Tue, 23 Jun 2026 10:02:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com,
 chentao@kylinos.cn, chrisl@kernel.org, jack@suse.cz, kasong@tencent.com,
 kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 liyangouwen1@oppo.com, ljs@kernel.org, loongarch@lists.linux.dev,
 mhocko@suse.com, nphamcs@gmail.com, nzzhao@126.com, pfalcato@suse.de,
 rppt@kernel.org, shikemeng@huaweicloud.com, surenb@google.com,
 vbabka@kernel.org, wanglian@kylinos.cn, willy@infradead.org,
 youngjun.park@lge.com
References: <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
 <20260623075805.466317-1-zhanghongru@xiaomi.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623075805.466317-1-zhanghongru@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6A6840006
X-Stat-Signature: b8uim78zuwusixwmnubxfywfozigmcpn
X-HE-Tag: 1782201772-740556
X-HE-Meta: U2FsdGVkX19HkkVN27dLDB0BcKgshQ6AeS//WVK5sM/vbdjdI+NaM+LbA8VoxzaBTrFxx9cPs1y1tYzAyf4O/dGlOnz14wYSSZJSfJy+LtmYzB+e5EwCSazTfWimS1EL2FVtgJSzPoNp2dIouFSK2fcVDrpnx5y21+8UH0JBb+ReWOEKnfcK8WdrHu9D2YOpEa84ZSMYD+gVF/tY0gVn9Qhwkpr59oXPlETumw5ffTRCu8Jz9S6tKwM0q/+kvBmP9g2JSKbb80JGBiLdf1r/tZOv6Q2+UD4flAp91Lk9Gj0A383vJ8h3lqYExfifShhds76u8RzdqucOFovldXB8bm2g+/w2zDZGLKvYUepiFoQGftHcF2vU/x/yYyJEU1PY5cazsW82AMALGDXRPE/VBOFRFHDFFF+9WaH1BGuzMPDO1CLQBkMHQ3BB0FI9TmDRjbudoZctXVpRtwRuzWhUpHRsHsxnmETIh3fBU/cFsFpflLtg46HmUtYPlOMylsYaO/rmN9WVLWDNHWHTUsvZVIeLEZEGdricssfjHAuqJXrtcifiQWo2Lhujoa2fVGe6/x/D72dFxoOEObLC5lLUyip9sei5StmNJDxxeN4xmiIdpL+/baBAlgzKAN0A6s/4hW0micFz+U756bo0q5n0v1eL8dFsupolhJb5E+KfANHB7lGsubBBGaI1lrzgi/S9fbGmO0wEZHnLx5cZEX4VljUoMeFJ8qRl55kMAbJYoxo+9ztG9VrbwsAC1dclys5DX274E6HpFKMBUI3LEJgqNADh07keZdCa9ZyFc8IfSojinD52SFmhmLMHxDO5LLbmv9y8zT7oz+HRRTKZLNaXgJcZfWAa/h4m+UwT/aaVo5Xg7gAra5x6pi7HfsfJ10LpwxjJz9LuCoAoNCMJku5h6sMX5C4iYcX14xZiCo0KwYGQbNliKNxRmWXvLugz6WvrJVOSaH6x/QviCK36bR7
 z1nx8y7V
 RntAudqfg6+awSE0oa2p9JqQkYljcrHqdnnXqvgHX0+nuJJ4i0Vn/9mX+OCzoeKZJ6M2ITaEt9muAMBy8btZnVjW7ibgy3HXlegmd/u8xv8h6wcK0hbedk/qrEot2MBuQRrmOduoltNo9agBchq5mraedCoZ+TEB8tTjJqHiEx0pd18oWCxrKUWe/ZXLCojevUI0T6HtyKNjuWI0LcTPUe24tpo/JZ6BrXcSfjnvxnXDefjwJk64zCcA4EISB1KXcb9Xq4a2a6oAojQSp4Ehy7XCEvitgwyPQUVT/mycvGUWg2XZhSZczt57baUYP/mh+7Lvb/4MATOxJteRsLzJGmnzZq6jDp7OrnBoz59cR765MbC5h4QklYKAqTVIv32qZVjAEVoEOIGiO6rsJDI5eRX0I6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 09:58, Hongru Zhang wrote:
>> On 5/20/26 23:15, Matthew Wilcox wrote:
>>>
>>> all of the applications i run are either single threaded or don't fork.
>>> what multithreaded applications call fork?
>>
>> Traditionally the problem was random libraries using fork+execve to launch other
>> programs ... instead of using alternatives like posix_spwan (some use cases
>> require more work done before execve and cannot yet switch to that). I'd hope
>> that that is less of a problem on Android.
>>
>> I assume Android zygote might be multi threaded? Maybe sshd as well? Systemd?
>> But I'd be surprised if there are really performance implications.
>>
>> Not sure about webbroswers .... I think most of them switched to fork servers,
>> where I would assume fork servers would be single-threaded.
>>
>> So, yeah, getting a clear understanding how this ends up being a problem on
>> Android would be great.
> 
> Barry asked me to share observations on fork() usage across Android
> applications.
> 
> I wrote a BPF-based tracing tool (kprobe on copy_process, checking
> CLONE_VM to distinguish process creation from thread creation) and ran
> it against the top 200 Android applications in the China market during
> normal usage scenarios.
> 
> Results:
> - 82 out of 200 apps (41%) call fork() during normal operation

Crazy. Thanks for these numbers.

> - Among these, some call fork() from multiple threads
> 
> These are not zygote forks — they are fork() calls initiated by app
> threads at runtime. Examples by category:
> 
>   Browsers:     com.quark.browser, com.UCMobile, com.xunlei.browser
>   Shopping:     com.taobao.taobao, com.tmall.wireless, com.achievo.vipshop
>   Video:        com.youku.phone, com.qiyi.video, com.hunantv.imgo.activity
>   Social/IM:    com.alibaba.android.rimet, com.ss.android.lark
>   News:         com.ss.android.article.news, com.ss.android.article.lite
>   Navigation:   com.autonavi.minimap, com.sdu.didi.psnger
>   Finance:      com.eg.android.AlipayGphone, com.chinamworld.main

I know that especially browser usually use fork servers: a tiny
(single-threaded) process just to create new child processes. Any information
regarding the apps above that use fork() on small vs. large processes?

> 
> This confirms that fork() is widely used in real-world multi-threaded
> Android applications.

Above you write "some call fork() from multiple threads". Any further
information on that?

-- 
Cheers,

David

