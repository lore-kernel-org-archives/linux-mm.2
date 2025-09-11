Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C628CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 13:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F478E000B; Thu, 11 Sep 2025 09:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E267D8E0001; Thu, 11 Sep 2025 09:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63B08E000B; Thu, 11 Sep 2025 09:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C53998E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:05:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78D7A1DEDEE
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:05:22 +0000 (UTC)
X-FDA: 83876990484.28.6776D34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B19424000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:05:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IpLaEWgh;
	spf=pass (imf07.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757595920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7PGj9rzcuZwLMbV1E3yxmQSH4iS25NGH8GVTnXJIcY=;
	b=XPQGstKJqLljJFoP+qAzc2/wOTj+lWxJX6PwBXq9zGHv5oco+Zyezvqdb2uQuhlS/QG8nM
	p2/2ReIBerLQI6vaX+2a0KmbsMcoHoX6w08MJbPRLw1Ko/YjMwCHDXFsujq9SmYFNlUjJs
	sAoHawpperPVQs0YIl/4fL2Y+1OBdn4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IpLaEWgh;
	spf=pass (imf07.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757595920; a=rsa-sha256;
	cv=none;
	b=phSL2+u2omlL/SdkOFacI4l80h7OvPoEzPLFKXyC7Qiztej6neagyvmamLfAuKb/6UeAX9
	Njd74rhWufWtR79c3mVt5Z1516s2mM/tKofji35P8WK+/lAJKS400Ifyk1QZyohtxdvWk7
	FVCIC7/QRDgMRd7YhoLGdNP7kc1TRHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA27860234;
	Thu, 11 Sep 2025 13:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E26CC4CEF7;
	Thu, 11 Sep 2025 13:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757595919;
	bh=3cTu3t1kABFgYDURDBVW7RvACYUtHwzvTu1HQFQwBrE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IpLaEWghBa5tYMxCDG0sjjg4V/u3gIB5GXvKS0QT+rYChZqB/iW30acZpzJ16tDhN
	 6bPsToGoA15Qk39Wj4KtZBN1J7438fQNLDVueFH7TQ78kwKlLjdyQDXqlYWt6aeCfv
	 YecrLMEM4j062LMtihWQ7MCSdN/CzonOyBg0j2RG3CZUvgFhLgJhHYE7J1vlbAD4on
	 zk2x3sS6JLkz+nWyyHyGgp4Ho+O8r/u21CwaUqTYTQf7rhkSLmlhjF9dQ8FfVsBziN
	 NHrGjOKn6AJb7wQeLgrp7623OIDdui++gANvZqO26Lt8gO2J7/Q0MOuTzTKPyx7UKz
	 ZXnlDSBzMOCUg==
Message-ID: <7ea8e560-89f6-4f3a-97a6-cf70c1d3d0d0@kernel.org>
Date: Thu, 11 Sep 2025 15:05:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] page_pool: always add GFP_NOWARN for ATOMIC
 allocations
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, ilias.apalodimas@linaro.org,
 nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
 justinstitt@google.com, llvm@lists.linux.dev, Linux-MM <linux-mm@kvack.org>
References: <20250908152123.97829-1-kuba@kernel.org>
 <20250910175240.72c56e86@kernel.org>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20250910175240.72c56e86@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B19424000B
X-Rspamd-Server: rspam05
X-Stat-Signature: g3btn7f3um9xpkrhqiib6webos16jnfq
X-Rspam-User: 
X-HE-Tag: 1757595920-280477
X-HE-Meta: U2FsdGVkX18xLVN7l8H3C7s2uUGq1INWn4ebP/S873Ug/KlLfvWGaqjiN44wcqGjRAKZMX0ABQT2hbnec9a8ohZqvZW+T34Owzmf/Mo5djDv5CmTVNt7tyOtEMdwcFv77llMLumN2oiTk1cUUzSmtL6EH2ur3iCxGZtc7ypFItbL9ZgkzZxks58rJjxNHyS2WelkPZMdITVn15bZ1kfYIHgqFhuKNt9FcvDC72A3TeS/SKjlhn0OEiRGzl9blY6gJ/Hn7MJycmNbC77YPF2W4z5AT8DOO+D8riyMUCBuDiL5AZGYZGtevcEYy+KccmaWJTDmGeehlPX63w9VK1R84FiQlWI0FNmL0EUw7HK9r5+1RnaG7O4s5ANYbeKDphrgTo2LtWkH9oeVx9rAXptM9/P3xeWxfUXqkLOkrkvabin94cPAvviTogpXwSwpsvM1MiqWIwJQtcVh7Vle2Uyeq4Wy6y2bbzjdiu0FsgPJl3oJy0hHkN34nD8Br+WzOVW24jJlV0pSw6w37TxgABPeo7lM+DexG0ICty+Tt/Md7pim47ayw+d6jnIeQ2zaY6/+5ziegJSxR2YQJBbA7E9AWmEspBdsxYfOyXauQNaY0pQ5oicidPdWm1/dbyK0CwvTXRmS7Yt/k86bK4RmOG63QJA0btJnJrwKkvuoLEwtC6fvRvqreH1iWHBP2FhkP78KuVp6IZWvrv4+AjUp6vhcs7dw44kiFWcHJn+JrTEw5XAkbPzL5lZrguGG2fOIdSstI5jqm2D/i/4EBZwS1j6yKda+glzC7MqUktjtB/OUIaELSO835fLnOd7m+lklJVOGS6R1YS5LFWbniaBfcXNb2Em8s0bL4mwCCMwSMQDHziEgIaHemfjihL/JaHISqr7p57JA+FiRj4/WzsPQAp15DcOtwl+S9uwnPn8/gi7BTA7FcJ8C8ykQ97W9xWKZ62sUIJEMnnlbnJmZ7QFoT0G
 kYW/CIGV
 gyM5f3EO9qMpB6U6+2Ieryx2dDIWDSBqdOml/728wqDb/QylALLj4mqOsZi7ZAhv/Mrv0IwSPCorl7ixv5bVtqokitno1q/0zZ8sx4g5Qr82Kl/bmgnYpf9jvMhSZeOV+BKFCOPfllUluS4MdqK/v8zH3IWK3GxXzQp1pNa7A2DWotsrUVjdPmVju2Pc33lzjOhH/D0H4Flt3ruNo5BMQwR3XatIZFCYRaDUnSfHMN9NxNMEXlfBNSf7el9mV+ScaHK+wr5VGucdNEX32Qeq9T0AVEkULxoGyo+iDxsjRx9teuHQ5xS3MKZ+U8tDyXzFsMIHmhO4GuP4BF3U9crV9qCSA9rqpOjhcwFF5yWAYHRDd/DHC8w8OPbo3qH+DS+h0JqRh0/7pIrRjFmyfYxddvRD6Nshop8Ha4HwmUPGyswcwUF3gUw9P9cHQ2U1CshYSec5+4xy32OSQd7ZSAQ+AppFutRb/nHQLeuZW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/09/2025 02.52, Jakub Kicinski wrote:
> On Mon,  8 Sep 2025 08:21:23 -0700 Jakub Kicinski wrote:
>> Driver authors often forget to add GFP_NOWARN for page allocation
>> from the datapath. This is annoying to operators as OOMs are a fact
>> of life, and we pretty much expect network Rx to hit page allocation
>> failures during OOM. Make page pool add GFP_NOWARN for ATOMIC allocations
>> by default.
> 
> Hi Jesper! Are you okay with this? [2] It's not a lot of instructions and
> it's in the _slow() function, anyway. 

For this "_slow()" function I don't worry about the performance.
The optimization you did seems a bit premature... did you run the
page_pool benchmark to see if it is worth it?

> TBH I wrote the patch to fix the
> driver (again) first but when writing the commit message I realized my
> explanation why we can't fix this in the core was sounding like BS :$

It feels slightly strange to fix drivers misuse of the API in the core,
but again I'm not going to nack it, as it might be easier for us as
maintainers as it is hard to catch all cases during driver review.

All driver are suppose to use page_pool_dev_alloc[1] as it sets
(GFP_ATOMIC | __GFP_NOWARN).  Or page_pool_dev_alloc_netmems().

  [1] https://elixir.bootlin.com/linux/v6.16.6/source/include/net/
page_pool/helpers.h#L175-L179

The reason I added page_pool_dev_alloc() is because all driver used to
call a function named dev_alloc_page(), that also sets the appropriate
GFP flags.  So, I simple piggybacked on that design decision (which I
don't know whom came up with). Thus, I'm open to change.  Maybe DaveM
can remember/explain why "dev_alloc" was a requirement.

I'll let it be up to you,
--Jesper

[2] https://lore.kernel.org/all/20250908152123.97829-1-kuba@kernel.org/

