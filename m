Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3649CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 15:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD396B0096; Thu, 25 Jun 2026 11:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5166B00B5; Thu, 25 Jun 2026 11:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795B56B00B6; Thu, 25 Jun 2026 11:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 545866B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:46:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4938C09DD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:46:55 +0000 (UTC)
X-FDA: 84918863190.01.7362689
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id 089DC8000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:46:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BJ+0i3vO;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782402414;
	b=ddw/N0TPhPKfkXM/smY7MIT2cX+krbej/vA//E7FVrixwJhXPm8fKA2i9d56PdVY3F/Qj7
	zMdlgBVtpXWx5ezaxHufh0I0wji1cTKAVLDx8NsMuibfom9lRjt9C3tSSKDzYtl5ct5cLm
	FgDngtFmMlv+yov6UiMCcair7t3GFqg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782402414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6Z+vqofs0Z6XLmf3qaOWgKbrty7AYM+MhIKhql/k/c=;
	b=SCTX2r52Nq1Fd4qHJt60dYM9pDJqgOrJ9LzgapT5eEyIKXxEcKX8yI1kDlBT086oIRg96X
	TyjXIX/YK30DlQlMnkc+Fn5cBfgmAnJ4AzwFJRKmMYnwrWErSLgCAAMskdxokJHNI1fB8d
	OI5GR7fxHpeR4y7lypVxfHnMcCdObiM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BJ+0i3vO;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=r6
	Z+vqofs0Z6XLmf3qaOWgKbrty7AYM+MhIKhql/k/c=; b=BJ+0i3vO8qcoWYiv2K
	GQGz965AfiIcdGiYYL3f7WBt7n6pM69GbCMne0DqSEAsC3fZtq8T0fx2zC8IGNdX
	SSQlL0Y0RAiOn3TS6cgwtZNxTjPv1NNq4s5e9SQp/YszK4M454pzZ8RTr1hVNP5M
	UZ7yvCElrWX6gwzlCkjklUvgQ=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDXgmsyTT1qofsSDg--.30639S2;
	Thu, 25 Jun 2026 23:45:56 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	brauner@kernel.org,
	chuck.lever@oracle.com,
	corbet@lwn.net,
	david@kernel.org,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	juri.lelli@redhat.com,
	keescook@chromium.org,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mcgrof@kernel.org,
	mingo@redhat.com,
	mjguzik@gmail.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for pre-exit before dumping
Date: Thu, 25 Jun 2026 23:45:54 +0800
Message-Id: <20260625154554.1226457-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aj0cUrwdXYKIicC-@lucifer>
References: <aj0cUrwdXYKIicC-@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDXgmsyTT1qofsSDg--.30639S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFykZry5Aw43Kw4ftry3CFg_yoW8ur4xpF
	WfKryakr1ktr4Ikr97uw47Za4Yv348Ka43WrnxW392krW5uF1xXrWI9F4Y9F1DWFW0kr1I
	qrsrZas8Aa45JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUn_-gUUUUU=
X-Originating-IP: [124.77.128.91]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC6BVKVGo9TTW94AAA3R
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 089DC8000A
X-Rspam-User: 
X-Stat-Signature: tqgh6ejrrggihmghh48eyqp7udn9skqs
X-HE-Tag: 1782402410-921328
X-HE-Meta: U2FsdGVkX1+NQuAHad49t5c6y7/ut9YxMBjYvbq3XAk+4gZdr+8SoI3KpDfxhaDPEnk0cW7gC7xLj1FMD9P2cKrwVoMDNHgDa7eYjAJtNYOVik63KZ3pGcOiGn7nkBNlnxs7ISQyVbEjIidRwRA9rl0ZZW8vr/SEL2EYci+obQQUtjuSoso6pZmjvjL42MxZzfzC34sNPfLy6fn2iliUQvuQf0lbVgEeL7pjLpgY+PJNkFef3BK81Hk5pf6zZaPchY307hRUroYoxrM8iBsJ2YVvNRtlX3bt6q+gJcTFH3/WF0jvtEvQIammUt7u7hRVcfK2Jl26welUK1c4moyKcVX57fJWFPrchEwq8LFtvcVRBMqC+rXpt2hn7JPike8OQ/N87A3OoPyTupOmv+IhxdH+oY9Mq+MPBTUehM1zfuZVlBXYGq0mO6bW3hpqv4rysL+1tkCpt0+UodxmmQ70ig/JizXW6wM+sFK3CaYCwksMHYsqNM85LUyJ92x2tkJfsyRwpVbz64o2gvUsUDMA3v5l/26n9eNglpjQcUWO1aoQ484YwD3KPywD10/t+W13vxr8f27+9M6ZbzD7HdB0VUxSWWZEOIU5jKslgdrwiKxt/Kwt6FF2VvjRxrl5GERp70H2IFv8rNNakz92b+1nAy1MOQ66d5+2r3HDhu2eM7futTWkcLcze37hxEzGB0XvxH9rWLs0X37FN8MFjg8eMO0kpMcWWgrU5DiyCakzzfAsqLipRdYO7hnToTRUm4xCK9c+/Yq7d0iiSlhbJ+qD0Sz8y2sYboO4sxKOwGnEk0DzBmBKLfmKBqxPXrj5EiQESLryUwEMDg5/wMyBno2q4Ec+18SZiESuvVMdfkUKE0LwS1aZVlUreboknmP6NFxJx50zLA8ilHVdkHoBXDjA6i6Mv7j9fB1cuVFHYVM7wpywHR3ZIM/poW/jL+aOi/oNq1QEMVeYXWGGz3m8BPw
 PWOz6GGw
 SuyZtKD8TBACRHJg8dSyj6jNYCXIWf4A1HRbO2cHtNa97oOqAFblQgW/U65HUO4AR7eppB07coay2KSDljLUGWVfu/AgGJCBA/V9byrCfZ0uK+WJKjp6oBoV9F91BdtqKl3rlnV2/gzqpUXtAMG1p2r+o1xz3EoOwEdW4gHSSfklzfFRZ2n3w6a/+bS6S8QPiS+vDz04coojx06piP/qVQq2TNhL2o5wwGbr1ytaqURTrJsWQZoG0rc3JpX6EdLzvIwDv5hyiwoWdtDA049kkrhCYy411jjs5un6rBhsT0z3gfF7ceukj7eNqGjj+d5pdV7qF3s0fKnlUTXXm49AMrxyPULoN9UWPyWqw50KmFJ2DM6yipkqTL1P/8pNwZfZUSAX/mq49xUFit1IzUaX5QKz/cRMf5CbJcpIcALjG5Ja4tz5RAG480g45wYIkXf7ezd0Usn/GyQp0DZy3yK3jnDKofdnL7qMPlwduMtmwYpf0Q4HBEq1SelffXC6FXwNlic1AtcDSnOBlFd+Gora2Jr1K5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 13:48:10 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> +cc missing maintainers, lists.
> 
> NAK.
> 
> This is un-upstreamable for numerous reasons.
> 
> The stuff you're doing in mm is broken, wrong and invasive and you've not
> even bothered to cc- mm people. I'm annoyed by this.
> 
> You're also doing incredibly silly mistakes at v4 of something that should have
> been an RFC.
> 
> You don't seem to understand the concept of patch _series_ (break it up into
> smaller patches!!!) and you haven't bothered cc'ing maintainers whose subsystems
> you're radically alterting.
> 
> I'm annoyed as you have a history where you were told not to add insane hacks
> before ([0], my reply at [1]).
> 
> [0]:https://lore.kernel.org/all/20260116042817.3790405-1-jackzxcui1989@163.com/
> [1]:https://lore.kernel.org/all/14110b70-19e7-474d-b0dd-ba80e8bed9b0@lucifer.local/
> 
> Was I wasting my time there? Am I wasting my time responding now?
> 
> And how hard is it to run a simple perl script?
> 
> Let me run it for you for _just_ the maintainers:

I probably shouldn't reply to this email to waste more of your time, but I
can't help but respond because your comments have been very beneficial to
me, and I enjoy the process.

The v4 version has changed too much compared to the v3 version. I should
have re-executed the "get maintainer" script, but I mistakenly copied the
previous email list and sent it out. I sincerely apologize for that.

There are quite a few issues now, and I haven't come up with a good
overall solution. I actually want to resolve the problems we encountered
in our project with minimal kernel modifications, but I can't think of a
good way to do it. It seems that the v4 version has turned out to be a
complete disaster of a patch, and I sincerely hope that my example won't
be used as a counterexample in the future. Thank you for that.

Suddenly, I have some thoughts about this issue, but I even question
whether I should have these ideas. Let me sit down and sort things out
properly. I hope the v5 version won't be a disaster.

Thanks
Xin Zhao


