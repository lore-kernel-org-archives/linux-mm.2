Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD83C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 00:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A686B00A9; Sat,  5 Sep 2026 20:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B906B00AA; Sat,  5 Sep 2026 20:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050E86B00BA; Sat,  5 Sep 2026 20:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFA966B00A9
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:31:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EC738042C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:31:53 +0000 (UTC)
X-FDA: 85181459706.10.8C53775
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D2E71C0003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:31:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AcJNDRPl;
	spf=pass (imf21.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788654711;
	b=PF86CI06XQZ3P49NbvotUK1+9WRvBf7Gd6TqRC+Ondd9TnQxIpnWp8eosh/SDFMpDhVuPt
	UJmad2ktqMQcIn9NVacHEY/vsEE8pWZZnOkELGH/QDJSeHAXHDSQYaY2p1IZrSJrmrzF/u
	UbvYCCOXtlpxhfG1U77WS0AsreEAnCI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AcJNDRPl;
	spf=pass (imf21.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788654711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CwkqFElh4pjGctDggceZpagl1zjwDqBMqU8Kvoo5mE=;
	b=FH7uOmRMkKNbJO0xJhUOZoUDn3Eo+9VeSJpe5kq37+j0RdkvkR+tn9HdPBfwJ5HEh/ZGw9
	/eLHOL3v5hKE/VlGjVgW0JFdv7Ugp/1t6f8xtkWcuqVuSQ7SgCo64QT23+Nyb8qaJkOug9
	wmeyus5DyWHAyDErEVMlVRvnVjmkAT8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=4CwkqFElh4pjGctDggceZpagl1zjwDqBMqU8Kvoo5mE=;
	b=AcJNDRPlkkjmT2yL8nlyy1lbUxXLVrTekW/BqaM/I/Anz8A1nX0LafSztPkBxi
	IhovyoGRLWYPcw91g8AZN5/iPybDG+eI01f17BdYwh+IKPx6eNEWLElCmdkDAbkf
	a0aWk4EguaOt2XMLmdDg6bfN4K/mq6w/q0OIRjIwiOHoc=
Message-ID: <b2a66985-ede1-433b-aff0-4d2acc5c027b@163.com>
Date: Sun, 6 Sep 2026 08:31:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/zswap: enable static key after runtime pool
 recovery
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260905125101.2970456-1-xialonglong2025@163.com>
 <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn3xZitJxqXko6Aw--.557S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KryDKryxtF1fGFW7Zw47Arb_yoW8Cry7pF
	W0ga93Kr48tF1Iyr4xAF4IqF1Yy393Gry8tF1rG3yIywn8Crn5trWxKF40gay5CFn5A39I
	vrZrA347Jr1Yk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UO2-5UUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9wUIAWqctGU0LAAA3E
X-Rspam-User: 
X-Stat-Signature: jduzwc3mif8jk388dksc1ia37fei5cdx
X-Rspamd-Queue-Id: 0D2E71C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788654709-453040
X-HE-Meta: U2FsdGVkX1/sJuEdjE9mHNvUjd7qCcyiAbLmT1/muhPOpNe5SzBx3sFXxBvxz06rtqF+QUgzuPuQkABLITdt87YYE1a2bns/80ZSx2/1aenhXQUueIEPqcFL702Tvv3YXbUlZTHNG+rOxMQbFfGbv7zdWMm0py5w5DdlYdHjgbNHWGFO4jbVxMGzKiQnubeVtjbVMWM//3zwrrqQBVHw2keS1WIYyNmn7TdC9vf2WCEGpnLZILjd51sUIsOV681xyHsqcWf5ZHbe6Xmq5K8KnJt+MoGKTskQj2P0sU0koSSXo5KMwLzI3amXBMwDcSS+LLSb4QdrXUtToex+2yEvvCO4BpmuRdzs5I0p0caVs//Wpi1nlwwWUGZ4LqKDgr6iw10OyvrXzwQpMJVgOJRBgAYcrFgmwIsQhm4n9btqPIaGAwa2+gyZHG/ZRt9B5Qe0DQHjmmgbWD9BU53EGuKFIxlPFsrEyBK62vnfnaCbW/uZiWiJcZCFkxQ2qgpLSXoAv7QkKdZHCAd4etVS6mkWr/bMppXotuoBqt3Lfks1/K8MkUNcwTr7hAK5ZLXS1q0x4nJ4/wH5/ltKCcVquadf/gXQSviDzgzw/AhHNz8YVLSZlzkROpLO6J+GdC7zr3bAkl6R+O63VWRMzWXWUodNPKYRrygMKbQqt9zBeu2jBz4+BfQq1yS9CAoQXbIr0HuY0wgcmJkw4UmHnP6g2qhL4x0vRExpA4RPdVgpueyEuvukcrrAFLWppnbELuETSCoUZfS/COdc4mHShyY4txOI5a8IrwdBzM6DpDgCRDZNnfkI2/Tk0f3J9n//+2JG0fuiiDsJXEhqJH0GlhDceYDEzEpxosnEGgQdX/RCsIkbRgLLk+1Ul1wRqeOBNYNSKgBpeoR7DJrBzNUnjNZvaELadHmINIYTZY8pZUUMDSbqZAUaKJZIIVudieVQ8Nx5oMldPaRg6GvbCc9S/o1tQQ0
 FJy2bpE4
 xutwUvrakAKad0FGiklwGp6fBEDCW1r/KApfz1i8EUC7WbhYTZ7da7arR5X1AOYWvjjPghdci7zPoEIWqHP9Es+0VgzJBHgWbOjolt7F4KIucGyCPuIj7kXrS9/Y2uODiisgDDpnShMhFzItwJgoiW3NK5fqEqbLmpGOIfycnOo1mmKB5FkMc8DKWO7auql8KTGxBp9TTIxTCr055dFQJNdhNtWm+gtoQGLmFXoVx7Tcik8GU6EmmagGhbn4M8aqF2PhBaENAut2yPv41hUHh0TqE6yCw6aJJH3FoL8Cz1iG0GT3Ps+SQORXTjwfEQNMurivNmcnoHbaFvNAdreb0XxWDYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for taking a look.

在 2026/9/6 7:09, Andrew Morton 写道:
> On Sat,  5 Sep 2026 20:50:28 +0800 Longlong Xia <xialonglong2025@163.com> wrote:
>
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
>> without a pool after a failed initial pool creation. A later compressor
>> parameter update can create and publish a pool, but does not enable
>> zswap_ever_enabled.
>>
>> If users then enable zswap, zswap_store() intercepts swapout while
>> zswap_load() still returns -ENOENT without consulting the xarray. The
>> swapin path therefore reads a stale backing swap slot because the store
>> skipped writing it.
> That sounds bad.  I'll leave it to reviewers to suggest whether this is
> a sufficient description of the runtime effects, and to decide whether
> a backport is appropriate.  Please.
>
>> Enable the static key after a successful compressor and pool update. Do
>> this outside zswap_pools_lock because static key updates may sleep.
>>
>> Verified with fault injection on a stock kernel (compressor builtin,
>> CONFIG_ZSWAP_DEFAULT_ON=n):
>>
>>    1. Boot with zswap.enabled=1; pool creation fails, init completes
>>       pool-less (static key off).
>>    2. Echo an available compressor name to zswap.compressor; a pool is
>>       recovered but the key stays off.
>>    3. Enable zswap.
>>    4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
>>       fault it back in and verify.
>>
>> Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
>> without this patch; all pages intact (zswpin=131072) with it.
> And thanks.  Sashiko might have found another issue in this zswap code:
> 	https://sashiko.dev/#/patchset/20260905125101.2970456-1-xialonglong2025@163.com

I'll send a separate fix patch.


Thanks,

Longlong



