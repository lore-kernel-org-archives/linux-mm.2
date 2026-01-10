Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D93ED277D1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 06:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098DD6B0088; Sat, 10 Jan 2026 01:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0434F6B0089; Sat, 10 Jan 2026 01:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FF26B008A; Sat, 10 Jan 2026 01:03:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D47536B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:03:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86B10B619B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:03:01 +0000 (UTC)
X-FDA: 84315010962.11.7B18B23
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8145F1C0008
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:02:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BEmH0eUc;
	spf=pass (imf20.hostedemail.com: domain of wqu@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768024979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxHown53krzjOwZe3U6q2Q9luXHEQPHiDEX+U4zC7CE=;
	b=i9g2Sv/1zlQIcWaSQwupENwHV+G7YWT0b+j0sRxEZEfdK6Pug1MaHmy3t+ygs36VollHe/
	ridnrLi6riEmVkduBbRzuTXE+XsbOMl6F3lo/N9NBp8GTtBd2V7n889cgGBW6GH3skLdM6
	EBnnIO6iJZhR1Mx682bSE6a8At/GfIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BEmH0eUc;
	spf=pass (imf20.hostedemail.com: domain of wqu@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768024979; a=rsa-sha256;
	cv=none;
	b=1S3Gc+8paXXEOE+dR9UbaAtOrzDFeOLiPpBt8TLqOlE70ebbpMsjMVNX8CXLz9QvRZwHkT
	9gWCD49+AgH+QwIXTnBiBMcajv+royHXRByYK4dWe8GYqzwcynGp63CONyAfCbAflSqfJo
	6WIKi4SSqGboKEt/POrcdlNJhlWbO6U=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4775ae77516so54045635e9.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 22:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768024978; x=1768629778; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VxHown53krzjOwZe3U6q2Q9luXHEQPHiDEX+U4zC7CE=;
        b=BEmH0eUcsFHjy9VtXl7xvwper5kERJaASG25o337XlH2W3JGihYCm3crmHreGm4/xn
         pu8BLMH9b9Gsww+ARLvu4c+hQWJM+ZYvO62sfQ++tuyx+9zqWItYRM/zn0K3R/0oGuv4
         b0PPc7dYzeDf9IPbCuuRlGfClznKozb7wywtaAaOHdP0rc1dKf6MXpJGpsMHiqzGxCOW
         bcIybaKNvdV+Q4tX/TgaivJwdLYusgz3k6QvSOjMRn8lguIKH2mBIsQypK9TZ6t7GJ0F
         LpWaRaGS0INIcc/z0UJ4BrInFr7dmgnM2UHmcf5hHejb1R5ZSOFKMQ4pwEH1YrFx4CLn
         Wn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768024978; x=1768629778;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VxHown53krzjOwZe3U6q2Q9luXHEQPHiDEX+U4zC7CE=;
        b=IAs6nyTooIjkuh/ZpALelFzoPFKQk4hylIZ4zasHM2rThGhD56BJSEq7ZQXqfiRHlP
         AVbjckNOx/rQV8bCI5lK/xKwvUZXmP1rkcqpKGXMSNrQhHzKRq0yeHsVQhnc57dX2CcV
         GLcRKk2G+b9mEFy5GOEszkDvV+rfNH3zLa6K7wpDV1uJNoizIGaHhtApzEzFzJQAKGK7
         Wx4Pb6PSG8/tcJnq1QmyWO0SI03Gtx280/5NK6JlW3d3Tc29ZQaUGwe2hnKpBoIfrPAI
         RrHgtBIVoOGr97dhovQVvHN2iYOPUCIvY3hzB8i6Kzonf4B5ESEm4ayuj/sYgFUu+X8A
         wYsg==
X-Forwarded-Encrypted: i=1; AJvYcCUwwAItCjKg2FQ9Xmz92zLU9PlhVH5CG5/AaQPE3pU0vH6Oq8pIsDHs1B/JE2ZN8g8BbY/U1MMb3w==@kvack.org
X-Gm-Message-State: AOJu0Yz4fov6Wj1sJJ7oKKlf/m96Ga/32kVo5iy4gr58hT09YY7aHCIy
	pRjFRbUO7fgTEK7loFeJE8THPlFmW46JFMIjf9gi+GnbGt3NVHIiurQOhXZ3rgv5BaE=
X-Gm-Gg: AY/fxX5aDyVcL40u40d8J73nmaS6zmj+mEaqJIoyN1QAWLvxEHcl4uw7pgu+zjLrFt9
	kxiBtXbQlPpgCl0UETylNUfSrK1zEv+uwUGv9EZLg9Dcxx0xSqFQq0BTXzpRv79Q7GmOHXWWyZK
	vzE5OP4xTiOsw7KBVAJLK/s+ndFOQLDV6feBp97RmLD2mCKbMU+LZgAhFrFfiOSVqZQ65Jx5Jzc
	IQ3PLhV60QjnhOh6aYkwVh4wvkZq6QXadOqYCyJPbYgjjwc/8JYW5BUk4qAmpMIzDP49jbt+MtD
	FGbUpF8Fo4ryea/A4wJ1mXMyT0zrRDqBwqFmfJkhF1Ebhfbky7DZUCYZLXkgnoKDx/DbK8FW5YE
	CnEYDkn0pykDPJ0cn498cThiyoBUGzVIrskKYE6eAlY3/C6eglpjD0UgiQSGWH5D4Qk0Wn0JY4o
	X8B1BYxmFVlH1LjYh0U9Stgjc+hHaNfheHLlDyps8=
X-Google-Smtp-Source: AGHT+IG8jynb28B5RBnK/iq2PKqzT29mdzDBcrn1Ajaub9mVTEsrGxx9hQOrO5M/hLH9/kxs2BArzg==
X-Received: by 2002:a05:600c:3110:b0:479:3a86:dc1a with SMTP id 5b1f17b1804b1-47d84b41176mr135338145e9.36.1768024977815;
        Fri, 09 Jan 2026 22:02:57 -0800 (PST)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c59e8010sm12164251b3a.52.2026.01.09.22.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 22:02:57 -0800 (PST)
Message-ID: <38777db8-f90b-4437-988d-558231747750@suse.com>
Date: Sat, 10 Jan 2026 16:32:52 +1030
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] btrfs: use bdev_rw_virt() to read and scratch the
 disk super block
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <cover.1768017091.git.wqu@suse.com>
 <829db7e054cd290b5aed0b337cd219da128ac0e7.1768017091.git.wqu@suse.com>
 <aWHqFJfzD9QeaKkS@casper.infradead.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <aWHqFJfzD9QeaKkS@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8145F1C0008
X-Stat-Signature: dcpg9ut1fjdfkeatn6ow516fu9njda65
X-HE-Tag: 1768024979-362765
X-HE-Meta: U2FsdGVkX18wmfjyzIIAdmDQ7hyZ3bYJTAETXCJQ+5ko6x2Yf6LYqUwOkon4KikYfZto3pS4LhF7DbiQqMXmA0XwfYRgL34icSK4xPuyvvtSkV7Ls/rYB66/UWeS+fzHHtMd9caRdK2maHjEGSX801GfKpplVxrgCCLX4+1ozmE0whqeN6QlK7ThGVwpSXG3tLvJh71BEIkwhc+yWu60F94d2qg7Z6a8LFKXtZY9O6RAHrR4VaLoJngs2GjqjYwvOQRspsb8rVc3XJTFfWJrc85M9XjEiHETEMDxPdWTC1SOLaV/sdA4P7pT86cYJHdcRa1E3p6ZfUOk/wygMXD/PDHBxy1GvG8H8fqdqHq0rDZJIWn8jYFPaUZ7D7+O/sO3HYawGCpDSbiBPmnsZAgGqZGcJD8fdeLXdoxX95fB5nQSffx/ujEE6uw5jJPWIi6043YZN5iuYqEPZizE5QenquTEGL6UBRa8mqnthG3/oGvRAtWrT9MMHZbcpNA2BkDQGzC8Q8ozxfa4gQR+VI2mPeS0xR32XjnmmG9+sbBBHDJogKUssJ+ciq79U4Wk/MGrgs3GjuqXzQK1WeqEyqyXhs10o7j+dv4RN9xmQlZfiMWK8sLOFBfA0Ix3OaMca39U1GTr9TiBSxemTY+SVObIMfvu7Cg1UYQynFjG3WFVKdNmfspxHhGAogANncPRkJgiN9JHWNyyl5WnNT7otroi2DcuHUm6wfNgvgV+LEU6VJL68lQtVkZ9mKI86HNZjgv5R8vV7QYjvDOvCoPjYFNb3r73pwe+xx/W8QtZMQYJ0rzQuHFDCg+4n+wnw3qgxBpvoLv8A4ZpwfONUUm0P44xqT7cYYmhIx2Cy0wIHB4IwXeUE/K4JHY1gQMFltCIUAAkgYewe5790y5N0hJgOqW2q8vFnwudWwILhav3ZItRdwF3mYTvWCk4Vw6jp4jF9QxQTWjtG/5z78tdyel5ZEX
 mTRYVOMF
 WMSzraTeohYOW+y6WkdwHM1TGa/I/KVdk4w4fjcvg9zjY+EfV1g0MgFSeT2y16F/9N1ul
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/1/10 16:26, Matthew Wilcox 写道:
> On Sat, Jan 10, 2026 at 02:26:19PM +1030, Qu Wenruo wrote:
>> Furthermore read_cache_page*() can race with device block size setting,
>> thus requires extra locking.
> 
> What?  There's supposed to be sufficient locking to prevent this.
> Is there a bug report I can look at?

The comment of read_cache_page_gfp() already mentions that invalidate 
lock is required, but we didn't hold inside btrfs, and it's already 
fixed now, nothing to be worried from mm side:

https://lore.kernel.org/linux-btrfs/tencent_A63C4B6C74A576F566AA3C0B37CE96AC3609@qq.com/

This report and fix just reminds me to finally push the series to get 
rid of read_cache_page_gfp() completely.

Thanks,
Qu

