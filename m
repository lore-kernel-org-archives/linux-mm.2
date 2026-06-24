Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFAECDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 12:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C6C6B0088; Wed, 24 Jun 2026 08:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D506B008A; Wed, 24 Jun 2026 08:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116436B008C; Wed, 24 Jun 2026 08:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E10916B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:43:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 559041C5A02
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:43:28 +0000 (UTC)
X-FDA: 84914772096.08.026A7A9
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id E52BE120007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:43:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uI9xqQqj;
	spf=pass (imf29.hostedemail.com: domain of axboe@kernel.dk designates 209.85.161.54 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782305006;
	b=IY/b313euzDnisrx1+tYLZ68sgYPjDcrEM55sFDm4tKm+Z8O2NrkNpC96UK7sXrgp3kC7W
	5odhOk1MiS8AH4UQ8UndclXXVG2Q7GzkUc1pbjAPjla0LLkThrSD4ebv0kRFlvd10GyR5Z
	6A8OJmqHdbTANmGjxWK+0yYRTF5edm4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782305006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vBqNWysPNQvqkzsE4GQXCpY5+Q5GT/QhxmkZJrUXw8=;
	b=tj2ZYzlxNfGtMYo1O12ZJaGhU4diPeXbVZgryZTHQJJF+/pDWgTheJELLWeuhphO7WccLp
	wWwWrQ5yofesvYnSN+zuaYftRNQ5NlcVfo6TTGlCMpyzYBUuq314668A4Fnt30TM+iEwcd
	OM79KZNwZ+cTghHdnT8p2ItGqCdoZNg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uI9xqQqj;
	spf=pass (imf29.hostedemail.com: domain of axboe@kernel.dk designates 209.85.161.54 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6a0edfe29ecso596812eaf.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782305005; x=1782909805; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vBqNWysPNQvqkzsE4GQXCpY5+Q5GT/QhxmkZJrUXw8=;
        b=uI9xqQqjpONXbYyReMUWHaxKDGjqn+qQrt4/Rh9b0BobtMlaF0D6FSDBabI9T7fPZY
         MD0h4Fgne9E2B2QKgGDjt+rTEDDxcuFT2Cs4GoRyXhWcns1Pg+5Y/rbOo9whDyWXCz4N
         xkaKg06mrZFLhhZdPRq+1fW7lE7CVm/dblPdTcwJQn7LcqE8Ps3YYWNmyJ2siC1Q/E+x
         YZ8QyYJNPNUXVpM42SAfy1p/boh6wCLnai3EFHcM6hHXPohpxufZjZ4dAErRdb/uLbB+
         XKPqGpzAp3y+JmRAKXvgNzKyhqZ5lLy3mfsLBnc+J9v5fqq8/FWy5OQg9kuz4l5Jq5MK
         r3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782305005; x=1782909805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3vBqNWysPNQvqkzsE4GQXCpY5+Q5GT/QhxmkZJrUXw8=;
        b=EtPclJhNIpGJwUjjWSfw7ND99cJ3AaHRL9/0TBUxZLSLslht2us+0KAaMd95Pm2ss/
         OkT0WOVNzawwKao08UXVegGZQf/pMc23rCCqpgdJwZlw99JaS3GC83iQDrAosSDIw6K2
         WfZn8AJV5bOEVhalTz9AbDSa0OwxLpE80iwaAGX2Gw14ZeFZnA83+O/sxaFvWTlf1ITc
         MaJn3Zez7FlDryc+2UxjkNRq2fkryr9/YwFMyn6dEHCYHi6sh9j/th2CSaTHppbTCg+H
         caTpMt6VTCEJOR1c6duIGHDlLBqHPsmUPaMAbVUNiPnnYxwo7j91kbwhgwsm+Z524oeD
         uEXg==
X-Forwarded-Encrypted: i=1; AFNElJ9EtT7ohSy7F7YlTgHSvNSTIVPU4GpiPgXNMAw08N3uPlKa/Es+3EbIGo9sBxP7J46zoK7ONowPwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6ENoz/Ve4xZDYime6z+MJMlwClr4a5O/hWZfpRA7Sf3hxrcBr
	rg8UpLCim3YjxijgC22zyCAbrL5Y/gnOS+whKLNBpXv9NqKgoDuXkL7xNGP+wjUpaT4=
X-Gm-Gg: AfdE7cnLLD+ju3ajJNjVwEBfY4osizQ+8vgAK2IJ3aJTyPFbc2WsNSOBJkgDYf2vE/7
	nbxNKN5lsBaMtANq73Raiqk8LK//SPvo1Ali1n3hhNIknhLLnueiJzYMmqVrHLta6ZhXXijsaHx
	+MO1yJ/1BlmsMv4pn6eVWtZKjCkp6XgtU7imJ3ewb2rXr/nD6KKMsMLoq6LcyaFmzvnyD4WgI8c
	w+VUJu3+uX/uaXb8TuEt0sLNAQ3/+BzEFNDI7QT/5eq5kRW4zVK7uh6+1J5Y4nqNwGwGSKIEW91
	XlhSgpfcLgKOA9slLOhyjRC4MikXRqCFCtODWrUmEPlf2N4aQdbGd2mUkD+1VXClpVlRc21gBo+
	is+Pv8+p+CEESiPWZkvEnogw7pE+knjmbHnLywqhNVT4KGHiC4tou4Xw5vlImt7Vpmv2sHj4d4d
	jmq6G9U3pFaihwUj1AEjvF9M9MJo/y7U57dqxlYoMX9ahDBsEgsjnOVIgDHDrL1vjHYHepjx0=
X-Received: by 2002:a05:6820:2110:b0:6a1:20d6:ccd9 with SMTP id 006d021491bc7-6a123020da0mr1995384eaf.49.1782305004833;
        Wed, 24 Jun 2026 05:43:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472f0464a6sm10164438fac.15.2026.06.24.05.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 05:43:24 -0700 (PDT)
Message-ID: <34d48fb5-4952-4a48-b92a-f189bc3edd0b@kernel.dk>
Date: Wed, 24 Jun 2026 06:43:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg
 paths
To: yukuai@fygo.io, Yu Kuai <yukuai@kernel.org>, nilay@linux.ibm.com,
 tom.leiming@gmail.com, bvanassche@acm.org, tj@kernel.org,
 josef@toxicpanda.com
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1780621988.git.yukuai@fygo.io>
 <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4nz6mrs78xh9mjx1dn9cnyuybpfn4rcn
X-Rspamd-Queue-Id: E52BE120007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782305005-384564
X-HE-Meta: U2FsdGVkX19r3Ow/4mjUnbTgUrTrol2yHFXJAwK+UWshVJPyRIZunglkUhFDXeyW4vk32ZsJMQE76ObAe/mTtFyIAMEZZ/iDM4Rvxlntr7i6Wdg4GC1SNYoXZTIefbNo0QUJejMcBU5SowWa45ayJcJmc1oI2cwi0hZcKSNrqcNbSjosbgQbHAb/SjDD7yh6qC+3O0rHe/YsfvoGsY9C2GYodKXi6HHLpadjWBYjOqZUkLJo+3jdLPn3+g4wF7GqwCWewGmgDtuuybXZsnXEGG+MfGyJDDlGWXD4OnjVbONaijxOrh1iw2UFVq1B3+Or5fljHK8/uMfQB0IjO3h+3RMCD5sv9y10aeU4UMww8m3Lkx0spPxQIipIdUHJvlbbvC1NiPZ8bwl+xeb0c29EW9r8y+GnWVT2/ZMAG9X+8p29TQKjHPTkCWohTc6QiqNXZeKNQBH5IAep89DF8exjE+t/TftEmr1OHEf4WESRt81LHuErd4Fd1gzMBGO9MpRGzYS0/Tsi6nFST+/UNhslnTMKlaSdtTOh2xxcVagjb3j0g3rMHwmgkVAO5x4qCHk2cBXRpnEi7YtqWCQV8+RjOtIVHUI2RLkJ8fVtwV7BY4BbKC/YXcvDzsH80TZ98nTDjhcgGsaWgeCaQgoCuq1XWTGz1sBTyfjqg7WdO/1VHbGrtj0Wb7k+X6XRogRm1VA7ZyWoAv3XuXUpqZqhHCw+V2r9tr0ku5oW3tKJ2ApMXkEw08B/xkFIXTlVL+IrZLWeSy0j/st5Z2qTNF4pfHyTmS+Nhi1NPItzlKG/ZiDaEPuFP6aFfXVB4rtCCE4rYYuNl/FnnyvmGRwPXSOP31s7EfG2JYfpVsXgOscuPrYHpn/WP2u20vLb6pu8m55yf9tM6bnR3tWIadRF3SfVZVD/EY/+IOfpKlPUEcUua/U7hlPSlj7ChYr9fRC9OWEzKjM2JYqdxxqG+uKlkZUFPjo
 rOaXTD1C
 xrXrE4veHssd+5+8eQrzTkJGs/GMFLkSGemad29Uh8bvY3WXkE3l5TU8SoRYg8iM7G7chDjUn0Jn0A2XhyVhcxnOiXejWvuWIgSUyV8GWx+ZqaWr4LkFB4CAMmNBZlB/ZkmtJIUU9lYIB+Wfe36WG0vFyaOYZp7TWCqvpvnPXNc9/a+oFkDhxcDLaWv5mpcm3dgfQdUL+G0sDaPyv8Cww1MRL/KEP3w3F/smBB1ttv/Y0mKKBTznhWJQsQsQBESUOGqVz6aOhpQLmYcWR5L+r94/lgzfL7y2wv2HqCRLFjI8cbXne66acNQSyDY3Z4QMl2/s+FzsK3W08/ETIUpbdhZ/6flrQkmK7q/FiwBKNyf9/z4yUgtSm0HL1llEyggI5P+kLKgarau+8AYHMr5S2CHuhZx6f37VQrPJsTglinXfm4arVcveC9bOWj4Oxm6EAi/Frrm3lAgUZr9A1lcl6CqrMbw0Pj0YDs8V1jAqwRuKrAmffhZ1J1D7/0ChtEqb3ynmf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 12:57 AM, yu kuai wrote:
> Friendly ping ...
> 
> This set can still be applied cleanly for block-7.2 branch.

Not sure how you checked that, because patch 3 very much needs some
manual attention to get applied. I have applied it now.

-- 
Jens Axboe


