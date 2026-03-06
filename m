Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14799FCB624
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A576B0005; Fri,  6 Mar 2026 11:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438806B00B0; Fri,  6 Mar 2026 11:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A0F6B00B1; Fri,  6 Mar 2026 11:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBD96B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:59:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE9C61B701D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:59:08 +0000 (UTC)
X-FDA: 84516248376.13.BE0DA37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 045A9C000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:59:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cNkIChOs;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772816347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUJ1zW1+7+CLqAx5+u6j41gfl9YtDPOi1lGGK8Hq9+0=;
	b=xLOaE6sWnS1/hHsgABrtanc/50jMp6Eje/YM61vIGMJeu6UHTgkEcKE/NWYLArSkaZc0rd
	LloVA7A4LpYr8Q+/Mxab0KOtdgUkMKbKfb1GJCkAohSklc7XpuGntLGfiAdYhIZ2nGLYhH
	CRLPE/ranegxGxz36c6FeWJqrHmuInE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cNkIChOs;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772816347; a=rsa-sha256;
	cv=none;
	b=NGRaeS+BQaStyf/0RxfaJgQHnMSI9EMYhp+sE+D4Jlla5yyzkDNu7BUUuARbYk78uv+lp/
	rVeMd0+rJ095Jexsyy2NM7N3PCRdR4PtwYDpUJaYX0UVOVNVJVIVKKL7WvyeBPWn5V/UhU
	IizA8WEXBSIvmoiSZSN+/7sIMvovlnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 762D560127;
	Fri,  6 Mar 2026 16:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A55EC4CEF7;
	Fri,  6 Mar 2026 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816346;
	bh=FAasDvbeeWqamChVKUg3/oZj45ivuaOcwqjtpPv393c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cNkIChOsBUMxKt5NTw/1MwJa0uKXPc+23GesU8RL8E85zmQLHhNSWXgxphuIKlGLQ
	 GWzhxv+02WUXA2U7hAACjTHn5PQj3cgXPqjIFLcntYL8gmuXAbs9AM/LvEK5IaGYQl
	 7KJOklZ0oG7rrxqT6RP/9Drvv3eO/qUFZCsOpAIXWOYHPVse8Qjs7ZeaZ/Vk+rUmQu
	 S9+0p5VmugZU8LbEdvPV/0OBqJfgyguekT3bAlQkxG3bb1AmL4Vhfhv4O2qnWdkw3u
	 PdLknczAb6W9gcGcTPE/7Md0iAzbnCO+e+t+b0OhL4tRKTqjWn9H2fBTFpfsh4hy3I
	 UBw2mZo8iw1XQ==
Message-ID: <a7586589-3ce7-4045-96c3-e74c3b03bb2d@kernel.org>
Date: Fri, 6 Mar 2026 17:58:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Huiwen He <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>,
 Qing Wang <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>,
 Linux-MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260305103941.11f1b27d@gandalf.local.home>
 <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
 <a8907468-d7e9-4727-af28-66d905093230@kernel.org>
 <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
 <a21ea7c3-fbdb-4ac7-8be5-0173f54890c7@kernel.org>
 <CAHk-=wi4CA=yPP-rQON_2_swS5Jd0SS4UwWbct4LdfGFyzHFRg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wi4CA=yPP-rQON_2_swS5Jd0SS4UwWbct4LdfGFyzHFRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6f7bts6k9rne4q9ktftnw5nwqa913wmc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 045A9C000B
X-HE-Tag: 1772816346-96079
X-HE-Meta: U2FsdGVkX1+X3wuq9cHT7thnGyg7SokcUvzaHVMk2sqTLwJUq5U0/Iu2KIBr6Sk3TS8ymBYajWt5ht/TdwFNK4jsu41aQ/0yUTJJ+gbRdtO8zQY/gq10XI1r13UvVCSKvBLphzHFqb49DqkUDQgPHdwqMYdD3h7PvGU9e8Lni4/huL5FUqh5EsqUoisCxTzoahcohDsBTHC3sqxQdK+/+7KN1J8NPq3nClOlBnY39juYg5+xRVPXBosQY4BRMkXJSX0lroQgYAXbhyOueStkeRSYolYA1labP/5ZbLvSfGHZPEelPHsjq2iX+tVv/fEtq3E71kKN010V0LWSQDctyXaGuy4VDM3KAawBgT3LH6ZJU9Vb3o37GtvOZpGX4ryT7Y10Ne3RVhCNyLGmwvNxpvylbe/t6INgJzDgtnhwhIYGjIncffFphj7xcMXP8iYVICnn15FX7Vn4plCgkdvoCamoDRE1KV2P0tFjnyjI9xd/ID2J7oWTSP4xJwSocPWjch+Gc1XI5vDqMcQMD3dM/KCxmpsFOQWTQXHlD8RLmkwAjayQQKmMpjGk7eKPUiDu6FtUeDBOv4JkSk28jLtgomu11x173qjPrmuRlfgKOglQspXyBLnijU7WCCmxJ4k537f2qjVEJRwcEHHhGKS5czC2eSKeckz5BcjkW+beEWpHbiwtnunz7lkiq3KgDubOXp6CFG4S9o+73Q/Dmmjuscj76QIYgs7mX8zkty1NoUXoRS5HlXYT3v+a/MM8ft+aw0+f+x29I6zjEPYMtfYbUhGsPa8e1Ni6WHTiHT41LubyaEaluiI75DCscVCB7b4gbIXhXJD4Gc+MYFPaeM/zqYB9/taGNt0/gn/3g7FG97NE1XsvkFntSNCSHXc911dU+oiOk8qN97/6jbcvUIecqbJu2O9nh5a0S3WxXlxma06zwIEDcAHiL71OjNRP2RbFMwRLejm/e05omE+AUhJ
 DmVcPtw7
 f3HPT/Vg0+tMtMZLXz+yz0nmisq4/v4p3basUjeD3IyxTSDh9J7IRTQ3Xg/mhWTRI95GdfNy3Gql49u6WkYklsB4Q85TANOzew+mp6YPYu0IsZ6B9nPlGk5c1pgZewKG0s0Rupa9CgCTNV1/N0YLj4di0KhasBQCRwzO5wO4+sNKrKp9k8YgtpgAAGAJysqZz+hPcopthfTxfrW3LI4oTCMdPSgSCl5N0M04R+AXozGqzBHFzXGtP33s3YfHyWxxjkzdtiW3Ti44Z+WrMH+FlxzWPPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 17:50, Linus Torvalds wrote:
> On Thu, 5 Mar 2026 at 10:59, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> Agreed. We could think about letting it sit a bit in -next before moving
>> it to mainline.
> 
> Honestly, I doubt it would get any testing in -next. Yes, -next gets
> some boot testing and maybe on a good day somebody runs LTP or some
> other test suite on it, but almost nobody actually *uses* it.

It does get some testing, but yes, it's not the go-to mechanism to get
some enterprise workload-level feedback :)

> 
> I think I'll just apply this now while it's early, and see if anybody
> notices. Lorenzo will apparently be shitting in the woods if they do.

:D :D :D

Works for me!

-- 
Cheers,

David

