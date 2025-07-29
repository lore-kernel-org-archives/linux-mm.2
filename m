Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85456C87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 22:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068776B007B; Tue, 29 Jul 2025 18:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017936B0089; Tue, 29 Jul 2025 18:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EFE6B008A; Tue, 29 Jul 2025 18:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5E7C6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:36:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8463E14026F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:36:06 +0000 (UTC)
X-FDA: 83718761532.17.2128F55
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9DB6140009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:36:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753828564; a=rsa-sha256;
	cv=none;
	b=mINP9/C/6fuG0Q8hyrZ7vwCOEHpHjWL8T3ET+C3DTQYVbkBGkq9CEWcS4X69MiaeWP2CAK
	qRHHp7GKfIG57+RHfCFUqKr28b6vWTb7Dg5aRwHPuj36ZCV/n5taVKqltq/XKtOoIlmjyS
	vkPehvbmdSlOGVqTKeIzGL8OnG1COaU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753828564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkD+syMVsWnAM5uBJAtYevfoDPK0MUAHdo3g+ofmzjg=;
	b=BSWoWfhyuzubGuPectiicdQy4roInUo4Ks+eecqq9uhLFc/K2SKd4XEwhES6+KiHWNeQKo
	SFbOnDl9OGIUnhXvrk+iE3OZicUqBH8I94y98i26fhx4mdenGQg3ztNe7ATOec0cA2BTYU
	RTUtuk5KeWHq61mHZXiFuU939guDWfE=
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD80C140263;
	Tue, 29 Jul 2025 22:35:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 0B5B020026;
	Tue, 29 Jul 2025 22:35:33 +0000 (UTC)
Date: Tue, 29 Jul 2025 18:35:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, pratyush@kernel.org, jasonmiu@google.com,
 graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
 dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
 yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
 chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
 jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
 dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org,
 anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
 linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
 bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
 myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
 brauner@kernel.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, ajayachandra@nvidia.com,
 parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
Message-ID: <20250729183548.49d6c2dc@gandalf.local.home>
In-Reply-To: <20250729222157.GT36037@nvidia.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
	<20250723144649.1696299-32-pasha.tatashin@soleen.com>
	<20250729161450.GM36037@nvidia.com>
	<877bzqkc38.ffs@tglx>
	<20250729222157.GT36037@nvidia.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+oxtVU63xhP93/SX7bTvd4Dc8QYczFFgk=
X-HE-Meta: U2FsdGVkX1+SVp31L1zEXDG37UVtXoqm70naJW/igIWLrqvmCMEotY5CNRw8dlWDmbUGblNWLe3J9LSKx3hR7L2bQHS5MLhDZ3emhsQZAH8j7he0OBxdHTorWq/tTuIqRvjhOa/pfZhAhrck9wMmroKYmqPDxhcpTqRWDwl3ysMHv7F9H46Msn44g621nxUht5mjN6sz+uKsXXe5sPbrM8NTysSEAUlypv2dGg+JNutKu9XUZ3I+Gxf2ECBE3SxAmB4Vt+rW88Ro0YDc/TOQ3u/BFhWkbWO5mlIrZN6SFp3smVSeUdWdFCHFOoEqQ490+r4zBLenTW7Tcba5bSWwe799mBO+144r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9DB6140009
X-Stat-Signature: te33cm7rcnw3qh7tpbfsojk5ysnmigqg
X-HE-Tag-Orig: 1753828533-748000
X-HE-Tag: 1753828564-195637
X-HE-Meta: U2FsdGVkX18XsZQacry8CyUinlcuNJLjeb5D62au3sWo9P0g0roeCMJWXhZK3YL4KYnSZZPArYLdRsORT4DMlsBdL+b/9fwiWy19gdaykdfhZpandsjJ0LlU1CwSXr7N4fGvg06b4Bm2QISwn79xIVVEiIGeZDVU/UJasNYxmTt2QK98eO/52CzUab0yoIGk7QVjdHBjk2w2eEa5sNL8HOL3JulDUEu0XZWEXPwLMFDMNDkFfaI4N217mNy3o6WTXkwlsSKjbH7I3GgmARFn68YRtWE3VUOZdiWzWN/lxgrTIuXngTKlID4JcqWe0ONZeZQC2EhUAU/9D2itb1O6lsfX80Rpv3cLWID+WzbR0g4eM01L/cXYbwERFetZkr9IHFIgmf2UyN8X4DFfChbVVB5kA7QPflLQcd55m6ousoXg1VOlCcg3Mydr3ucJq2ZoWblPPPHRLULSGUazEzRks8QWuf/owLZ/hwWXlWkoR5tWtNfFGspld983xZrA5vT4Mn3ooPHSZcKUJCjiIhzkEwrYw7wNzyO24Ag70LwVaoBtEY7Umko9wGtyB4gkayirXeU6KFBcjBewP+Fgtjk479yfDd7iwGqt1qRBGtW0QI+vGKptgr2dEwzo5/cHJ1r2iM1CSoFdqpaABBHwun5TktgJsN3UcG//bPAZsHYGH7ufP1EwE6RsMqhLv87Aa0QekLAZZMEKxr2F6eXOaQCaSQ7fbDYdNQHRZTWoIFjHDIPtzQjU11vNH3LcNXu8QF3ClEy40p1YeDYepPC7pkcyV/3s3jjAlgwoyY+kS6+CpGKW287DYkqavjZiw/TpdOeGZbBkx3GbillfzAjUtsvSx3Y1nok9Dlel4dTOG+FWE1nAwZNFnOkHxBnBdVb44PQstLOVtKxq+1YWCYdFgXzBAIwxGrpmWy2hPCPeuS2/MqnjGuINQ8VbCIg79V+Qy928e/NxPVr92cdWtG6GsfY
 CMV8kuQ1
 2HuRqcoTugoHPB/ObvQZfe9T8Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 19:21:57 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> > As this is an evolving mechanism, having the corresponding library in
> > the kernel similar to what we do with perf and other things makes a lot
> > of sense.  
> 
> If we did this everywhere we'd have hundreds of libraries in the
> kernel tree and I would feel bad for all the distros that have to deal
> with packaging such a thing :(
> 
> It is great for development but I'm not sure mono-repo directions are
> so good for the overall ecosystem.

I have to agree here. When libtraceevent was in the kernel, it was a pain
to orchestrate releases with distros. When it was moved out of the kernel,
it made it much easier to manage.

The main issue was versioning numbers. I know the kernel versioning is
simply just "hey we added more stuff" and the numbers are meaningless.

But a library usually has a different cycle than the kernel. If it doesn't
have any changes from one kernel release to the next, the distros will make
a new version anyway, as each kernel release means a new library release.

This luoctl.c isn't even a library, as it has a "main()" and looks to me
like an application. So my question is, why is it in tools/lib?

-- Steve

