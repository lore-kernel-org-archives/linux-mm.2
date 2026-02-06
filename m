Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA93DEE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0246B0093; Fri,  6 Feb 2026 13:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E356B0096; Fri,  6 Feb 2026 13:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C805D6B0098; Fri,  6 Feb 2026 13:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3A786B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:10:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EEEB160229
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:10:04 +0000 (UTC)
X-FDA: 84414820728.12.A1B3B0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9BC341C0010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:10:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZMOmRJmj;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770401402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wu0PT65X/LluVgNE/PgzxiEHiUtsIeqcDmD7WGfgTOI=;
	b=UnFBKQUtP0T82TUB3aOiDRGqD2Oe0f+wmknXMMFNzxSGhcYvhph0RuhJsAino/K+lchckp
	cFrdN7gf5DO5Bz3klVadOcj4K+9rAUBuQJ9Ipi0Cf8jV3uwNotlUeNBlEqr9Psva4CyFqj
	Sn3vPrtlV+m6UJ7TgpDvrp7HlYs2l34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770401402; a=rsa-sha256;
	cv=none;
	b=JKuAMF5+JRyMFIKPi0v5nuEJP9uKM3zGgWEUskamODIkU4D/PRdAuvFy6qgFr8FC9iC/Ig
	q9NIeburXh5hPYfHQTNQ/8y8xlCoUgBwADBntRKVQ6IwDBWG0wthKkivvGVVfkYGVTUrKr
	8aqVxkeWruXb8QOV1PpEFcjSHoWna3o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZMOmRJmj;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E4B6560010;
	Fri,  6 Feb 2026 18:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811ADC116C6;
	Fri,  6 Feb 2026 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770401401;
	bh=HquMto5qBTxtBWStWPqnL6gLHKhrz+PlP40XRRbLNrk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ZMOmRJmj9cyIvK+9/Z6Utxfj3hYMxhgiKW5lnB/Rdh4KtUiA3CE+K+wGkmWs5DQdt
	 4NLrCuli2efs6PS4Z0oCoKWNjitS1zAGNCZgSYv4cboPA9pClWp9qWcbHHL3/s53vN
	 CWVD0N8ojscvM9iXUbVpaFyL+gWZt+xXxZkD6of7jBRqDbIZNeYHbsk7Yo/BjlfUYL
	 MFLL1KsQ1XPaQajU0jgv6HBqcWsmpCYkV3wc6JTgsmCx3yfycOSS4HynN/n/dTdwtM
	 fAF5ACkJYtWCxQrZLPD6hlYp0+0i9OXkn36KCbajewnQupKzwEfLYXjzQ6iRAQTt1S
	 pIM7+EaBAoUrg==
Message-ID: <3192eca4-1c90-44ed-8386-bf635db357c4@kernel.org>
Date: Fri, 6 Feb 2026 19:09:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: initialize rmap values directly and make them const
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, hughd@google.com,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
 <aYYIw3h35HOqodAb@casper.infradead.org>
 <5a1cf097-5ab4-41d1-a707-a709de6210cf@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5a1cf097-5ab4-41d1-a707-a709de6210cf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BC341C0010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3u7t5jdieh4d18m9qb88w3ckbq44aqdn
X-HE-Tag: 1770401402-269394
X-HE-Meta: U2FsdGVkX1+XK9NKXevE71cMSkijJzMaWRo8HfjOrA4J4ib0t5hZYd+k8/GddUdDEZB8009QsUU/QYwuGaKigRTcAzYouhsR/+dSsowj6X3rSLYSL/HL5qssWGKO/bMRpqBSsl/1kOOwUMZUQImWY8R+ZX8Urqc962jTfUpRXkfRjmq6MelKA/n9SHpslfPUzhudi8mB9q7idxKAeYpqxebkYgqz2d8dCOuhXIkwnqh11zwMP9InE97x5CzQz3wDaTkIxxRwkcq+HlFpQgADvDxbFvkl2S/s1mQUzWHGRhlqDEtcH6njnkItqzjzIKFz3bOFYT6dT20tG83F2mKh7OtC+oTxNyTJCfugUH7Da0lZDo/OeZfQqI/Peg7PYVz9Z33W7sf03G/DZES4D5FY37s5Viavhbpc9dPBwcqwGgKYjx8QF5yjb49tz8i3WcyEUoPLtn+9jwPFP+WPcT5VKbJi2jBgtXVd/n4ZY+Y9+ZeZxN1/YyYzL5eZZo1nefWwNwmkp81aLTD31yZykriNANmxpvdxwjor//LeQmD+UpDc/m1kOi2Sc6iz6U21ND5JaSoBVb7PdWcWnKbbNJBDl2bS2VupzlIXSzlJBWIbHPPxnuzv/0SeB/qdJNGRdlHVCUT2rX5bOqcBAK0axrAi14DYGgjwoVxT/lwI1Gbn3CtXImdFPZk5xzEQoqQGq4e74RXMhAv7ZwJ+leoBvBbxoASLcxQmb4ZNvJBrWZKXmeYClqneATPalB9ZCEs+mX8i5ayNEl5U4RubuK0D/ZV+orJB4quScN07NSHCxaWrgRonkXlQCgeczAoQX7mWqE08m1u51LosK4Ld7pwG6LMgOWK29Fa4PnVQbAhaw8qFT7qIdbob/uw5NWjggJAnoXQgoNX/WbMIvwKHClbvwCTKj08OQOOZcwNSwf9zCSaMoU+JYxZ81gAeSN22NNwk8SdOD6LohWFpMyDzIoA+MfF
 LcMvW2n0
 29FPhiYDihWYm+MszoIWL7h+xEATpqonKMZA9ifkp1vvss+Om273iuPZYYPMFopQ2IxhBP0VXLJro1F3OKy8ng1AoU2/a6b9F5ybPTmLmQajcTjNZpoqjTT4lJb0KOigZczy7Pn0nFJufIkX0yQ9Ngro8JbMuREuRi/bt0YlK+aS3mej18JblfKzkKxSry33LL/UoMWx54upyvwUwdSK4LmrgEEwW1e2DtDVPBC40TYODp9810VSvADuUGbqBlJMkOh3obzGapd/m/AB+hvsGFtziPKNoRMatxl9V1G81jgtSTJijfjUZlF3u5mNHyjOGN9pulCvLpLNUbIQQRpLKhFbP5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 18:34, David Hildenbrand (Arm) wrote:
> On 2/6/26 16:29, Matthew Wilcox wrote:
>> On Fri, Feb 06, 2026 at 03:22:54PM +0800, xu.xin16@zte.com.cn wrote:
>>> make them const to make code more robust. Besides, since KSM folios 
>>> are always
>>> order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
>>>
>>>     "pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
>>>
>>> becomes directly:
>>>
>>>     "pgoff_end = pgoff_start;"
>>
>> How do you know KSM folios will always be order 0?  I don't.  NAK this
>> change.
> 
> Once that changes we can revisit. ACK from me stands.

And just to elaborate a bit: I don't see support for > 0 happening any 
time soon, and it will require significant changes that I am not even 
sure we would want to maintain upstream :)

-- 
Cheers,

David

