Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E589CCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0406B0008; Fri, 12 Sep 2025 13:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C09D6B000D; Fri, 12 Sep 2025 13:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D69F6B0011; Fri, 12 Sep 2025 13:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E99F6B0008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:47:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8C451A0906
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:47:34 +0000 (UTC)
X-FDA: 83881330428.29.47628CC
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0804380008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:47:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=szwTwO06;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757699253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUI9puXoXEZZrLl1P89JxrjIx1+qg9LD/VjY/AoyGf8=;
	b=ohI3lO1VBkRGwOeeg4zY9BoqgI7sImqf7aSv4xC55HOXyTJOANYLuXN2NeFiWw594ZfEhv
	pVXeXFU8F2KivLic7XIFVeLneJ71hC3nhv0xa78YCI60uYi5dY2yTGGq52J+55osWbv7U0
	4Jn477tb5qNe6qQqoQtBkwe+AOpC7w8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=szwTwO06;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757699253; a=rsa-sha256;
	cv=none;
	b=VBpZrHci+ovHpgpDAk56ISevmEsQCv2lq4VVIhqkZJ4+2wsq0VM+9FWwKjS0X9eE3nqYJ4
	oKE6pIp0CWdxTpm2pa70V+JIN6OWM02/yvjIrfEpuKubjj+7eQKJtNi4t9Pgavz4++lNL2
	qh592ScA1OnhdyFwSayzcMUN6NJw8ho=
Date: Fri, 12 Sep 2025 10:47:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757699251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wUI9puXoXEZZrLl1P89JxrjIx1+qg9LD/VjY/AoyGf8=;
	b=szwTwO06r2E5qVvdExD2md6215HmJd6XdwvLUmDx+MavynFdUduMvmdOgcuEJkzBHMhR3L
	i1tPw4L7zqTd7wb90PyaUiVP9inl42N983nf2Y9VHbMRUyPyUKMLuEI0T4hUFWuN16/Ouf
	ctElUUUl/eWQp3YwxQ9EGLGRSTV7/kk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org, 
	memxor@gmail.com, akpm@linux-foundation.org, peterz@infradead.org, 
	rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in
 alloc_pages_nolock().
Message-ID: <fbzqv6b4lvfqjyvpszqa7fzpbytywbjamehjez7yshc26ugdiv@e3edtofa4pwu>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909010007.1660-3-alexei.starovoitov@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0804380008
X-Stat-Signature: s1aqa8j1dcd9bop9qfaim9z7ep1q1b8i
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757699252-977485
X-HE-Meta: U2FsdGVkX1+hLW/78JHo2MqmV66zGb+On2cIM/PsfjkvCirpX3HoHVa6uClQ9AzxSd8qKXQvc2Ncq4juiGGBIs9Llg8DidW61DXsYvdeDbDlqkguNxzmvyxR34GOOJ6zIGLQ0CxPi0YFDDK+Of+CxpmUANLAtDYdE4I/WYfhE9/HaVRcm//jrUVM8AtiZLSQQp6Bo0XhO/mWSyMciMq/aHmbN7yRFa76jJyVSLuefRxohF8v0+s0exP1+bX3eriGxvMMWn8O8XVzOB58Y1FoZoHvH8M/B39emo0jaPdFPvTvawAe6TC0lFW+/9RzVIvvpphafAp4Uv6fDSlbrzXhfeN6Hd3R0RNybdgzu7QjjCBfHsqWjReA68DEjLPN61nvOGLsUh2eCYq4mpmMsQMCqECsM5RdniUMjfi9BWu2elv30Q3FRY6TKxE7xL3L68swt7dBtpYu5TTBxSyT/thkAluRh0wyS6jQN4uW16AoMnwqLmRuNkXLEh50Wv+3GZfb5l57tQNmxNaR79fGXx7aJXXbKHx7CEZyIPdoqGXPYh6dGdGPnL7WxCyB3myJiGVSwFkDYJNG3/omSpSlVwtOGmLtn8odMNFlCG5UL8I/AoU7H5vwGf0o7pFLeB+73ghNV9PECP77j/+kfCVV4PXhqTiY7W0UmVZDMkDxfXtk0eCWJk6TwiUCAkl2xKI/ZPGxFjcj89JUtJ/i0KKHXKxAITa2kS+e3r+CF0RrtZdpZYPchE4juIMVAkMmHL5CPYL6X2Mb9lggcTrGDT8D8VpcnHr5axtoJysHf9WhNsLeKv9P/qOVOTHl7120bzNn0ICMfQc/PyLnZniHWS+buI7Iy3WWUfeJ4jWFPovDHEgpR+KwH/OqxPnfr9OHP2Ud2qHeDByQnhphZ5noGvtE+gWAbJO+rdJOOs2H9tVdwzwStN3YUGN7rsjRBU8jo/81yjDhGoEXv91AzgyZ4bH7HTS
 EL2M7078
 UUoxWjzSnf5pLCF5S881WP4tUt34X2JFr5ssVVc4hfGA3Wm4dZxAtbTQvxC48nTdS0VFkJf8wLB6aOzKaV2jyBHcNDNQqSg3/ioPfl6C+V2bI8OGCTS0A7cM3b/6TuOW91VSBPz2h+yBkfcRUhKVP0y/X02qTzh0hDITU8Tde0JUe1mda5maJPBVtHWdENX+ckzmL/whQ7ynPpttjCw9ZELfvVcJ1oaYRokv6SbGF/0hcMNGzA3LdC9BuulNYJs/FB9LrlKtESS2oM9gmWyVDrmMWjWZT4Xy8LOiniAixWcS109CsCL3UXc4IT/Esa7ViOES9NASMJIXl4CdMeYakNJI8yFwiE7oUJhCa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 06:00:03PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Change alloc_pages_nolock() to default to __GFP_COMP when allocating
> pages, since upcoming reentrant alloc_slab_page() needs __GFP_COMP.
> Also allow __GFP_ACCOUNT flag to be specified,
> since most of BPF infra needs __GFP_ACCOUNT except BPF streams.
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>


