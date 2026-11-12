Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F157606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHxjzh9f
Received: by kanga.kvack.org (Postfix)
	id 796256B05BA; Thu, 12 Nov 2026 04:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D5B6B05CE; Thu, 12 Nov 2026 04:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683FD6B05CF; Thu, 12 Nov 2026 04:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49D8C6B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:09:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBE65802CD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:09:50 +0000 (UTC)
X-FDA: 85425894540.20.901C472
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D1C61C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:09:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHxjzh9f;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/okRcwCmJah376/pTXlDGHeTd3yv114IA7qsrwTRhM=;
	b=CZMsI3nAmtWL2T9aiKYiujN2LriYUOfjo6LIRbP88oYnWGtiWsriz5PY2WgnneOqiTQiSa
	blOQbtGtX6Y3fZrbNuOfXGXyhhYEH/2r7ZR/6ZZr4jq4CsdZz2wCZwwG+Nqu4zeYEaj0Kb
	p04tEMfWn7M5PFgTCnucAoBBIWwJ0F0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474589;
	b=ex7HIqUXt47CeRJXbePKF4RWO1x5glJyF+HvxwAWxxqs2kcTP5akp8I/p9YMkzw0vuVOI5
	/X4Y7DUCaXElLDdiNSbAW+B6gbjw+s7uKGmZJrpb+ZrxCSyvyk6yMxJDtQ0eL1bbGOzaW6
	/ASMEE6HjmoizK8ATg62RsXs4EEh/TY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHxjzh9f;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D6BC65631;
	Thu, 12 Nov 2026 09:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307DE1F00A05;
	Thu, 12 Nov 2026 09:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474588;
	bh=j/okRcwCmJah376/pTXlDGHeTd3yv114IA7qsrwTRhM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eHxjzh9fX6/euYdOb/lVF0eGeyRB12MW7G+QY46JREN7vpgh9olDCgsYLX/pAzEQX
	 IGV5dxMZ7b0c/DriZU6Eme05voULqlWWyL3IXZnyQuLunihl0MdTtGN8aeINL0bNWG
	 Vm79nqp0mr4XhYQNoFSuzkSP/JNGzToHNTIe1C4Q8AqHz6YasMr9/u7NXCsOdcxrmr
	 qlsPUcih2RuGYOTdpHqFhif7yvJqhVUn10NeLQxRNQA1wgBo2pXA0iV8g9cNF8it3I
	 BAI5M6gxZVmyY0MT0oebPTr+QHkn1U6hPQGcF4Fxua1lNp6LLOh76Ogg8tgrazzQuo
	 l0nwe7VmuIDqw==
Message-ID: <32ad880e-5946-4703-9c6f-43ff59da39af@kernel.org>
Date: Thu, 12 Nov 2026 10:09:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
To: Arnd Bergmann <arnd@arndb.de>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Kirill A. Shutemov"
 <kas@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>,
 Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Bernd Schubert <bschubert@ddn.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>,
 Geert Uytterhoeven <geert+renesas@glider.be>, Nishanth Menon <nm@ti.com>,
 Frank Li <frank.li@nxp.com>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
 <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
 <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
 <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D1C61C0006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: f6t3ja6iip93zjctuud5tq3bdx3bnj3x
X-Rspam-User: 
X-HE-Tag: 1794474588-422098
X-HE-Meta: U2FsdGVkX18FU16fI2idxQ4GajEazcBS/O2aIDwcnyRuQ+NvmWHdJn6sOtV7HMpEwRXphSryev+yqbALpOxdj/T6hgwwmoeVV4a88XHu5gfbPyh8nqFtbVYNZ8pDiQLowiQGAMcP62uvKMRhRB2ks1+hEn+0zfgne/2Osb8/WSw3CqWjNDLuCLF0PkEdFNjfq61Ja4bjdsqS6xzmW9eYiOlmQRKphM+HYSjCmMqrVgx4jnNn6lGsCCr3+cXUSMXvQUzFxa5VDlzHTCxtMWP3IBIXJfih7eEp1MgXf0Xtj2gzHa9Qh6PAGV9ZVitcal0XV2m/cbX4wH4sBXG2Of7AaBr6YdonvUdh5FWrA7jhTDQhuHLlj2yBhDoOIfKhrVndCYted3QC454DjaoTL+3AaK8jsZM/jULcWPKTietLqQhjeRk+pK3gj1++kRQoMCiN5Iks54T4fXR3cXBaqPqotvMl3D3pebnT0ZxmZijW1dn0QK4QEw+ymDl/1NzNAPr/u6emyjcT6UBbTy4lC72fYeiAf2qJMTsMuheBy0cKFaT8UmR3MWGIdMp8QtX7f3w/n0HZ7+UzavZ96RP2xZhtsVCJWblFETvBftCPco9+zlDsgIfgR9iapWw96e1YY5OcFg9rH+GahM4Pdp64pJ5kl1GlQ8A19BoDbFKeJV1T+shDK5AAa94TK+M08pfJ/2/5EpUF+wwmECr/ucaPFQ5BcDBFzuQSxsjZMp+sdzdRQAHh1rnWa2RvL6hNMApIFMB6WibM/aPh2GYFJvxJsrIYTJLb1APs76nfe6c5OABXpgrVswxlUa9owCPOfWjAEA0eL2GavONjPBE7B8EKTfWLhjbQGkDQzZr5xtRzRewBDvS5NUBwsePK0bGjPvp+5v12mButsX8DJcT+D+V67sUOffrKLnoBeEqhPx4wjytbehLNveWJNRSkuUKegQV5NKsvB/flwtzEkIEbRRVSMMb
 qkkPuBPK
 xs8IAuUjCX3tWUjZuf0nllXW14LO8JeXQZVwNaleCyFbr0Bfq0iAa5enYHyv3ENo0y6zTU0ycxPwmYcJN8x2aGQ4BFrTDWVSmgonS/oUrnJHlir256tk9OtQAEl39IpcZKJbYqLb1L//TSgjLovuhm8i/0ebfjkYIZZtUlOnVaWd3zUKH68pRsBrgu4ChV2yR+7TSuCnOS7P8a9DYZY7RR4c0o2RaRdw9aVJlrC6KHr5AMTYnqukVb23cEtvfjD6FSiOYjBhN09eNuI7SAkXh8ihgq06Ea8qnXF/6ci3E0iMaOHrd7F666B0eszWiR9x7br8oQwMoU7LDIfOkYiKQ6TP/kiKhfwTM8/9yuCe4zNMDUwck3lq+oYvmK4j9bsvmoyTTkAOx0ADU1KrtqvVyXL7rF1okLv4gv4Et0k+NmKjb8cZsr8W5/M3tbkYXpPj1LdGyCDJNowJaF0hV4yIcRv76sH36cGY2an459nfRJU2ZHl745IQGZha2ZE02YPk3ssgw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 09:55, Arnd Bergmann wrote:
> On Wed, Nov 11, 2026, at 20:26, Linus Torvalds wrote:
>> On Wed, 11 Nov 2026 at 10:53, Christian Brauner <brauner@kernel.org> wrote:
>>>
>>> If that's the official new stance than I'm very happy.
>>
>> I definitely want to remove HIGHMEM entirely in the not too distant
>> future. And before we remove it, we can most definitely document the
>> fact that we will not be worried about insane users.
>>
>> And things like security issues count as "insane user": if you use
>> HIGHMEM outside of controlled embedded setups or museum pieces you get
>> to keep both pieces when it breaks.
>>
>> IOW, it's legacy. We should aim to not introduce *new* bugs to it, but
>> if there are pre-existing bugs they very much count as "don't care",
>> this will be removed soon.
> 
> Agreed. There is also the option of adding Kconfig dependencies to
> mark things that are known broken with highmem when we either know
> that it is buggy, or we have a good reason to break something that
> none of those remaining users should be using.
> 
>> I think the only reason it wasn't removed a couple of years ago
>> already is basically a few old 32-bit ARM platforms that still used
>> it.
>>
>> Those platforms still exist, and I predict that they'll still exist
>> next year, but if those users have to stay at the current LTS kernel,
>> that's fine.
> 
> I tried to push for what I thought was an aggressive timeline
> last year, but that would still keep the Arm bits for a couple more
> LTS releases and only gradually reduce the scope of highmem in the
> meantime, removing support from architectures, file systems, and
> drivers where possible. See https://lwn.net/Articles/1051010/
> for a summary of my talk in Tokyo, including the slides and
> a link to the video for anyone wanting more details.
> 
> I also prepared a number of patches towards this, but have so
> far not been great at following up to get them merged, sorry
> about that.

I think we can already start at removing CONFIG_HIGHPTE now, right?

-- 
Cheers,

David

