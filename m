Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8D8CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5381E6B0005; Mon, 18 May 2026 05:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F8C6B0088; Mon, 18 May 2026 05:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426996B008C; Mon, 18 May 2026 05:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 332B76B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:34:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1DE11C07D6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:34:17 +0000 (UTC)
X-FDA: 84780029754.06.83EF163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1043A160007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:34:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sZEb6K2Y;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779096856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r40ma1sXikUef8FT/NXmkL2xUoApvHSxJjeT7sWQJtM=;
	b=ydfwKqhiiEGgl24mhxDojEIS8R7DJLW//GsWSuZ+bxGFHzwOe2yJcdiILU/snIU+G7lTYF
	m+oeSPhaA+wuIjUrgihnHsolzlBi24QZrvjoBCK2Sx3DOG9D7wBSGnodIY6bNNDyp+bgHf
	WhWKSOjXmFGcav6hVmPWqFcG0xxp0bQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779096856; a=rsa-sha256;
	cv=none;
	b=L995jRZiCA+6F/ixO/BcAKh4/SnmvSeN8ScJq+qESt8LA7uVpz/+4GkoY5QtwxoUQMEbPL
	JXLe1VVM6cSCl2+RefQWETCOfa9OhlVuARkcQkm1PJjnu29wkBS1kdKZ0skjXDKvZSc19m
	Cs0DFX0laEp4aiS0MEPhU/r/ZTBEKXQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sZEb6K2Y;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F298E42B66;
	Mon, 18 May 2026 09:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00108C2BCB7;
	Mon, 18 May 2026 09:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779096854;
	bh=GzBzHDjnj4M3YTbCmBceQUc3zfWmzR4wFD9lrvfEGjY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sZEb6K2YedoHePpZc1igvCSBfZNBrGJBi8jQLbBUY2nThD+L/3S8D9jqg17V76XK6
	 FSM2oQQMeno2AKFYtifyrgLOfCZDthPUxHTWx8eZvyyDrqzkk2Hrec75AZN9qsVAwa
	 UMG9lre442aR/vAZD6Xuug6/4fzcx9l4wR+eOhpIKLjS9h1nzotoIZ5QDBClDpEmcm
	 LVGaHGK7CXXiOcgZKSicJhfNM2qk0bu+yhtViubdsNc8fyQu3Vsr3PFQPOiFZCJYIf
	 RDiUHxvHBV8BpypAMXbUQDMjWAZkjHe6asgWo9C7IPUOV2FMkDgmseugS+orIIQZow
	 AHur9V0RknTsA==
Message-ID: <65d11b12-5696-4403-8062-3ae65ca9113e@kernel.org>
Date: Mon, 18 May 2026 11:33:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
 <20260513121805.GA22430@system.software.com>
 <8348d867-f8a1-432c-be2d-699ad96b2e93@kernel.org>
 <20260513123920.GA51788@system.software.com>
 <627bb280-be44-4648-8771-5a479cda988f@kernel.org>
 <20260513132636.GA75142@system.software.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513132636.GA75142@system.software.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1043A160007
X-Stat-Signature: 4jw8n7mi9womxpofxx8qq9gb73ngdkgn
X-Rspam-User: 
X-HE-Tag: 1779096855-438100
X-HE-Meta: U2FsdGVkX1+Te42PfhQFSD8L8zzJvO/zHOsPMIoem+cK8dkT+SCU5CZ1v4y/6xsu80ld8rE9mAgw/lAKTTi+a2uMvQzarCLwVhnw1/lmw2dh6hlqk2Naq3iDRXSxlJBz2JCnYhB8w/8maOYzb06S4DT6kyUSvzQPRRwQ1cYKzwNlmrlXV3YYZPUkG7eqMud48RJKPLMMpdVeDMtL3P1io5h77UTUUaH+uk8K2+NgV7P1rj0WgO9rcc2MBEA86+A7GZLQsho4Cd+Ufo6329sjkVI2+ZurARSWyeOaY2wgIjh5HoVbr14Dv2D/gQeADoVGfXVi8WRbkUu4fCdmqd/i8q9+jaJq2jK6ZNfte0aKt5diroYX8T82QfrNNfXeZ5aZ2YPmSB4KdVZqsfJ9PMqWQiOka+ase5uLAElUZomp526iZl+DxWpjNiHTZ+oRA8Dk9tx2P4DEWJzfRcv58gKXILrpUyxdSj8dXB2OlRq6nOpvvRVHqZCCfd632ichKfTpbCbE/hOl39WWMAdlWExwEFkMiUjgNj3CatOQWvnjX5+BYa3WC0DzOT0/dDvp1R12coS6Hfe8vSMUWy7WGIBCt/4IdkcyxFAfbYIlDfQ6jE+N8MgZJ9hhYBExycRuLZCCdSj2mOGYp50N0QIL3Ikj7Zp+w/EN4PlHPFrz3+gRkSeMI11/eiYtA70YMU6RuOPMyY9zLUgienm8h2Z+WGRXiXgXEuCWy42Msh572ouq0eWe1/x7UojpHqo/2lhDwqXftSd1jt7N5Afo8nw5GCTsIO59WMrlL0ZE4LKq4U5ossidRmjKNMXIRPtpViFgwVYla0tSA6Lb3qKtiQoaQ0j9aZu5u485fbtBKgVVxSvFJguWcs1uLoPwkHQ0NjLh51UqY4zzBJNEXIX8HWvvwIBv8NFFpV1ciSq+BaqIDJR/jrrBMh+HXu2j3jTWTBbhiqeh6ueQiThjZJPOxxwijd0
 ZAywtIHw
 VHO54j5ZPeCJBQrSoofCrGD+4QDR3kNlxTTTA2hHXxhOSN3CSbRk5bKvzLRwqaiWAnxeje7qT3Sv4Gd3Ayuk3/ouLQsUtochOOMAd/dem2gY1QARAvRqkKSP2EsfXM2eCfk2ZJKPgNpXGPYxBu/dli99Rs6OPUvQx3P92KPTRxZ0PbOm09/Lqc2iXCEhDzkVTLRx5gNQiO7a1Wngd3uHCCDtm33snRPEJNTT60WTTOMZMW1wi17OS8ECl1KGZj5vuWkTQAlrXE9MRUzxVG19yWy3acf6BlptP0/oxPQF05MbLn2pbRHkrfIP6yKXqJAiZHY1/UHZ/VJ+DjR2lmVWy/I/UgpxTXuE/a26J+U77B5b/KpFB66RJVgw/vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 15:26, Byungchul Park wrote:
> On Wed, May 13, 2026 at 03:02:43PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/13/26 14:39, Byungchul Park wrote:
>>>  On 5/13/26 14:18, Byungchul Park wrote:
>>>
>>> This is not final patch, but for sharing the rough idea *with code* -
>>> maybe there are more points in code that should be adjusted by the
>>> change.  I just typed the draft patch quick just for sharing idea.
>>>
>>> If we should allow pp type pages to be used in mapping as well, then
>>> we should allow a page to keep both its type and mapcount at the same
>>> time.  Am I missing something?
>>
>> We don't want code to accidentally overflow mapcounts into these bits and have
>> them wrongly be detected as page types.
>>
>> This is just very fragile.
> 
> Okay.  Thanks for the explanation.  Plus, the adjustment I mentioned
> might not be as simple as I thought it'd be.
> 
> So sorry about the noise.  I'm a zombie now.  I'll think about it after
> some rest.

It's a shame we didn't get reports earlier that we do have some vm_insert_page()
users :(

-- 
Cheers,

David

