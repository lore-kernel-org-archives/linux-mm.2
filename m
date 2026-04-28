Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78937FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15126B0088; Tue, 28 Apr 2026 07:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4DA6B0092; Tue, 28 Apr 2026 07:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB276B0093; Tue, 28 Apr 2026 07:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E28E6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:26:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 257A6C1B4C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:26:24 +0000 (UTC)
X-FDA: 84707736288.08.86947DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3E7980004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:26:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tZBmxfD0;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777375582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aAEmAYGVm6qu/7d46OeNFfCwyFQAhfHUaDOvfneEEE=;
	b=PPpJL540kWRCcPUZw/vF/+1IhDtkca+bSVfo6xtr6aLlhE3ltwdE7Rg4II4tAJIXz8Qacy
	lJWUny/CDvzI/AK4cch4T20p6FWgAIfCJhbEhPEpoSKFOJQFbqyRPnaw+au4BtCDqgTOjp
	blqRwIGnPYnYf19Ljw6W4VzVUidUF3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777375582; a=rsa-sha256;
	cv=none;
	b=b5DOwbx3RqZdBcsYWakWSxarG26s+9TP5dlPWOPyl2PGKk5uUQU3lrg3Q41IHp45kk8nEZ
	5quND/ql68micbgZ6LK4h1oQtpod5IGRBj/wd8AYntfbJXb9JJiMlH5ri4BY4GusOhWHaP
	k9j0ITxnEXPMgFukEQQkfPJSKYzkQTI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tZBmxfD0;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41C7E1684;
	Tue, 28 Apr 2026 04:26:15 -0700 (PDT)
Received: from [10.1.33.221] (unknown [10.1.33.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC50D3F62B;
	Tue, 28 Apr 2026 04:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777375580; bh=Jg93q/OILsGCyemJ6EUpGADAgwhJfIgsmDbSFNtYPFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tZBmxfD0P7Gkv4Irx1FLB0AWkwA05WBde47o71oXtsqQXEoJVvdmxNNByPJ9kOs0C
	 uzZCV9cUyXKtSDHoDoihBjrAEJ9fFR36qU2SqRN/BX3xITbT2mfcIK4bSWHOkVm3Ac
	 7x1YebqygbDrQCn/IfSsLQ7Mv920pKVwKbOaD89I=
Message-ID: <ac79ea57-ce9c-4e1a-a2be-0ab3a3517a8d@arm.com>
Date: Tue, 28 Apr 2026 12:26:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Lsf-pc] Large memory allocations at LSF/MM
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.com>
Cc: Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
 <ae9AHWvXUTuoqlfA@thinkstation>
 <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
 <616cb4c1-ca1d-4e37-a92e-b8f6f675bd3c@suse.com>
 <ae9heafyGwN3ctUe@casper.infradead.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ae9heafyGwN3ctUe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3E7980004
X-Stat-Signature: priqczdkoaug3fn8p51dbnzchj8mds45
X-Rspam-User: 
X-HE-Tag: 1777375581-565142
X-HE-Meta: U2FsdGVkX18GXddEYtVCU0Nkbv4wkStFk38xnwy9lT+Zz0RYjNdcYk69S5OVZON8iyMuZWWpD/T/uC0teUm12xhxA/yMkPOjf6kbWIpRZxQrLTwvtUhThGsJslE+7sRPSI+PrAJ/9LYeDVgunWFBB9jIDXvafo/ws4PzJkgcWvG7gWSwjlZqQuCXxxlOGTZsY65RuyveV+pQMo9ZT24h3rE1D8kV+YO8oW8BeUmo3P6jSo8bla3YRNkywy724PyOgNliYLl1cQ5soAPmrvXZCPz3zCyFkBxjpVHd04bk8t6PMcIk4EzCtti+jYRbareeElm6qhPvQIzE2Aq9NcpgdICgQneJUIYwCsj4ykmjOuK1K+z0xzGhx+KWlUuOjDGJPRrh7KZ0wLYntnVu1MQ/hKReRhl2EO72YBimM9h9cr7ITJSwAhvZ9qzNQ+QkcvIrprJ8KOKH05jprSwakHp3QMpDZFJWZvunVmqXkFuoqpSKis+yUXcgNY/jxzrl/kFgwVgXNWarlZsykdeNBo5420weinBbcVr/lVY5ZBS+JPW1V9Y4zCFYUdRGi+7Grnjbw+jJR7DxGRNpmVG6BzJFw1rhYJNBigB8hZKI7CCPOnMNsP8xd2YFT8yWw82Bpnf3xrdrgaaXNZBq7oQJ4/zIfSchoYqHrWE5y7T8wLGvCtyLF1GUEF/HhMtMWFKPJFu5yg3Eb//9Sc9EOA8PYZuBVjPy42kJnASS08b2HgQ8F395nFGzp2rT1W7rMXjuxeNhDCRnQFAZONdmkSU2SvdbojEO3Z6JI4w68hfk6HB858qNiLYAP+AZOclKtMiK2YnZWvWdzh4vazdIQPgCyt23wS3kid+7LE9vN8aAXvLTRBIAPHSuwgype+PAi+ZU5ft5VBaJSMBlajJZ6DMl5r96+CFS7uS5JF8ftiAHzOlL4HUg59KeziMuu3lfnbO9izoTkwRgAU3yYQJRYewH37f
 MdY67/Yx
 2+o6Am8sWyQ9QLS9/M5Oy9I4bqxvkKp1zqn2YtJ56luNCBqD1lT9Oxwr0dW33OvcQgn1HHOxL038kzGZdDM6RO/SIhjzyLuQxFG7wXzQbcIMXMIje3m4ijbFvWlCpkc6maX2PkD8tgV01Aik43KL+xipYrAPO3Tkk9JGdM98oWuYrQC2MDLYKh7qbnFj523kVqDri2eaTBCy8cnplDKI/P0femDw9sRyXZmjQlrS4yliDsKkh8FtUKO09qEH1cw0as4aG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 14:15, Matthew Wilcox wrote:
> On Mon, Apr 27, 2026 at 02:35:45PM +0200, Vlastimil Babka wrote:
>> Well meanwhile we managed to extend the session to 1:30 :)
>>
>> ICYMI:
>> https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?usp=sharing
> 
> Sorry, I meant to follow up with the good news that we found some more
> time.  If you guys want, I can split you apart into three separate
> topics, or just leave it as a Hydra session.  It all feels pretty
> connected to me, so maybe keep it all the way it is?

I'm easy; I'll have a few slides to present that are specific to my topic, but
happy do it as a combined session...

> 
> Looking forward to seeing you all next week!

Absolutely, looking forward to it!

