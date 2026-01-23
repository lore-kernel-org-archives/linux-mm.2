Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2B0D7234B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF0E6B0450; Fri, 23 Jan 2026 03:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8968E6B0452; Fri, 23 Jan 2026 03:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFF66B0453; Fri, 23 Jan 2026 03:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADF46B0450
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:32:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B8821A0208
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:32:50 +0000 (UTC)
X-FDA: 84362562900.28.1E39EAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7449380004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:32:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PA7PbPpE;
	spf=pass (imf02.hostedemail.com: domain of mailhol@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mailhol@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769157168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lHEdB0GDc+U4hfN7ERlhy59AUwf8W+c4JgvLL/NHbk=;
	b=UspAZ/9koqYX1SrcKnCOqmetJFU+v7KzOb4MhdMgR+FXT1naZx//fwk+2NUlKTCH3FkVC5
	zUw3kuOyFUBqIG9ZOt7mtCs9CE00NOl3PxE7aDiWRREQdinKodScOewoEJf5tGDWUUKaMX
	lgeC1YzOeDGPvWe484W2GpCqGXCwMFw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PA7PbPpE;
	spf=pass (imf02.hostedemail.com: domain of mailhol@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mailhol@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769157168; a=rsa-sha256;
	cv=none;
	b=KxveWvLeEAwBaHN0zr1WUgU5DlCvBZINGbMz5EJSknkhPpDEmMYWqYxtHwJ2aaBtDpeY0H
	6h5zxQEgz/m+cUA2GQX7J9SRn/5vrcXYN5Qii4fqqJXxVvTqk+oD5574QVZjuhiM3iA7zA
	eM93IS4u+p6gD5ECTr/W4MkhMkTOsZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9070960131;
	Fri, 23 Jan 2026 08:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F7C4CEF1;
	Fri, 23 Jan 2026 08:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769157167;
	bh=RPXHsjJJodiBfwtnVTgxBFEggh4DJsOuIORgyKkLh64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PA7PbPpEa1KvnGFm3KBSXJd1gzslvA7DmJdy6klvyzNAO0JpcYbj+FcaC1vmAWUyF
	 eXK3jX00afgTm45yoCmEKnyZyglRywyWkJUrV/F+1KnoZmCC7MQwbdCtRz9zadPJN7
	 NaqOeTCoJc7Qi2bhldmBjL06T0y+pKQv/2OME1kEzjqyxM91CY955pVN1L249o1KZb
	 2IxcOO1jj/pavF6Mc9CqwQwbkXnyXs+4J5YGCUK5OHBGzLVpOe4AZtlGFB1v55lqtB
	 r6woavprdaP+2FXoMf+WYX+0vum7rQEH3MozNwL1lfn8q9nYik4hBKTCpfidQ5GZHL
	 CVRGdX/7D7fpQ==
Message-ID: <f9fcd1c6-373c-4345-b413-9bb6c1cd2d3a@kernel.org>
Date: Fri, 23 Jan 2026 09:32:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Chris Li <sparse@chrisli.org>
Cc: Vincent Mailhol <mailhol@kernel.org>, Philip Li <philip.li@intel.com>,
 David Laight <david.laight.linux@gmail.com>,
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
 Jani Nikula <jani.nikula@intel.com>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com> <20260122103337.26473d1c@pumpkin>
 <aXIzpC6wpdv47cSH@smile.fi.intel.com> <aXLOELiIG8MHKcIO@rli9-mobl>
 <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
 <aXMtJ_JurQjvN4tU@smile.fi.intel.com> <20260123082027.GJ3183987@ZenIV>
 <aXMwIcH7Zh-1yNq3@smile.fi.intel.com>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmdfB/kCGwMFCQp/CJcFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcC
 F4AACgkQq1/riG27mcKBHgEAygbvORJOfMHGlq5lQhZkDnaUXbpZhxirxkAHwTypHr4A/joI
 2wLjgTCm5I2Z3zB8hqJu+OeFPXZFWGTuk0e2wT4JzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmFiEE7Y9wBXTmfyDl
 dOjiq1/riG27mcIFAmceMvMCGwwFCQPCZwAACgkQq1/riG27mcJU7QEA+LmpFhfQ1aij/L8V
 zsZwr/S44HCzcz5+jkxnVVQ5LZ4BANOCpYEY+CYrld5XZvM8h2EntNnzxHHuhjfDOQ3MAkEK
In-Reply-To: <aXMwIcH7Zh-1yNq3@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8knginzed7otx86uwhr888e1ex4wc1nh
X-Rspamd-Queue-Id: 7449380004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769157168-577039
X-HE-Meta: U2FsdGVkX1972r7/rEm23H95JcqUNtpr5tyE9Th/tDhX3dcsrUQTn/ZpY22JtzYDDMPBuFxhwYeQ1L5GmyiiOew1+BzpdFaPyuVtoPBlcWG4JngSFCAZwfLdGWqLPsMbiAYo4QfFY7Ei/VZekgaNsWz14BnaqPF2uuQ/9pM2+4+xD65G2ORbCrYBuzoTtuGCMgF+eigGI/5kxV4y+EKAdNdnzrJt8vLJEuqIhI1gMnCO/FohALsnt7lo0xRwxT13sH7gL1j6HYF15Ke/a4CraymZNKFTKRdS1xq2hZ+dkuLGVcnh0MT8PRwd2EKCWLTm9XNXiIebOAgwMj/7VCQy20wSlhLkRRbA452SNN94wqrO6t1MB9mbGmvpyq1oKEVkdeW+4HjkTdyuN+8rZMe/MD4u0wJTU0Ca+O3fxOWIj+ic/lHe8fOfCNGTySu39PytizE6BbTHQiX9KwTmdJXNGtZfl+w5NcS0keKNnGvJSrr7gkxls3lYdEgAe3tOZ5TTexfEUYCJe5rDGKAAba6vH2feHJ1L2TEH3LUCICUIsAIabzEqPVrAlYe6/7rhyScRVUh0th0+nc7dvGzwPYE/zS5jCFC7Vp7BtahQ2OEnQOL9DduwtlTk3m3QrFym82pEjOcY93NejJc7jxJ2zUEpYxFrbV5AzLh+4Tr1DXWNPL0OcLxao350g+IQ/3sVQHAs2uUxKQXw1gXIIQpy+HxJndQQ3+8u0wVNIM8MBreVzW4IQxq0oSAJQOyxJB8J6gobO10PEoHtlhrm/tcjA83DedYD9ZJGJPT8XQSn+xOo22HQO6MoStRtaWb2G/uWmbObK6rTtu+qbvEm6kdE/zk7+wiQrUrRJYcW6BdXdDfnkVjtqx7SZRbctnkxICfa4fyxbRv35cxRxH9JvvakEfSyli+78LxL9BT2kiL623dai669m+pxfk/0faKNMzzXXP+lTYTsOguc2aWhE97Viz5
 YIJ2N1rp
 yOMOYrLknHDzkF5M+cV+Re8yQKZIDFJ8m8NP5lMOUpqqaqvCNs+8/pTEmytT/nSmz6AcBoz80TlAoftiQ+IM59BWKBfiHgCTCbT8U4vTLIOEDEYuOxL6wKkqcRfCSV2ALCvZKu/G+gQvM1bugKVriLblKUMOmxhCZvWBCeNgYMefRd1bKw5EOvSZvutJeVEzqw+i6jY9stms6KG9hVwGRdKRT18X5o7LfyRVsbU3mFXUvLaPLoeKINIEHsDjGDTFkFTD2pOVLhHLzylo+5pUtRhcVqd+QnAWIKJ1QlGzFxCj3D4VKhT0bFaOKPaZ5h+UQQY+S6awuWYscZKWR26LYorh00Jm6Ds3KFJCVlrEkfNKvC8Vt+gr7JFtHVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/01/2026 at 09:24, Andy Shevchenko wrote:
> On Fri, Jan 23, 2026 at 08:20:27AM +0000, Al Viro wrote:
>> On Fri, Jan 23, 2026 at 10:11:19AM +0200, Andy Shevchenko wrote:
>>
>>>> Al Viro's fork just adds 8 commit on top of the upstream sparse repo.
>>>> Wouldn't it be possible to just merge those?
>>>
>>> Ideally yes, but you also should kick the distro's asses to update it, and
>>> the sparse should bump its version...
>>>
>>>> That would be much less confusing.
>>>
>>> Seems Al become a sparse maintainer de facto :-)
>>
>> Huh?  What happened to Chris?

After the project hiatus, I can imagine that there is some confusion :)

But Chris is back in his role of maintainer since September 2025. See:

  - https://lore.kernel.org/linux-sparse/CACePvbXDO1ZybDu3RaFhED9D-9gC6LTMpWrxoh5xD+ZO5SLdzA@mail.gmail.com/
  - https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=67f0a03cee4637e495151c48a02be642a158cbbb

> I don't know, but upstream sparse haven't applied any solution for
> MODULE*("FOO") stuff, nor reaction on my ping in that discussion
> (I did it like week or so ago).

I am out of context here, but were the correct people CCed?


Yours sincerely,
Vincent Mailhol


