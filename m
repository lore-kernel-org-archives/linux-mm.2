Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9360CCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF86B6B000E; Thu, 11 Sep 2025 21:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD05D6B0010; Thu, 11 Sep 2025 21:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D836B0011; Thu, 11 Sep 2025 21:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3A106B000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:07:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 841B91DF3CC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:07:30 +0000 (UTC)
X-FDA: 83878810260.04.2C12829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C927E40009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:07:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dLrXaBU9;
	spf=pass (imf07.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757639248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11AQSwiNVgoO7U/Dpws6/4/9vYYHtII+0izyi3NNzLg=;
	b=Bj+HGmAb0sqTPVV1NKoqw6TOVGw+sGATtmldUZnePIampHM6H6N+GZe7j1SJ/zZ1AfrKz9
	GtqeV+ltqt/PnDD+HSZmHJne+yk81KickByCbLNmDlfIr/i7dw4gme5gsuMQxiOAhSLNBK
	GoOUM3ilWkW7dlcbuTJIH7ST7CozkwM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dLrXaBU9;
	spf=pass (imf07.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757639248; a=rsa-sha256;
	cv=none;
	b=fdfxLk+vJbL3HNyZji/QneMWAeEOlgaSFOnb/OTYT/nxiIH9C7PuEfgfj1RdP2/cNp1ZFd
	nYyBiBnsB5WxPh2UK8NdL6oa+hezJu66HcNs9Kz8ePusD53VizCC4tcn6bnps1vWhEv17u
	DweO9JNgtxJ891BW17mQOc2PRmGI2sk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77BC7402E9;
	Fri, 12 Sep 2025 01:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA00C4CEF0;
	Fri, 12 Sep 2025 01:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757639247;
	bh=PXuMJATVT4V0Y16Ka+lqtvBlfX81tB2vy3KhW0U7yNw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dLrXaBU9sm6JjTx7yMnrAWHzGggmPl9ChW3HUUfCJfPQ1RupdUGBZupZevzvrNAnj
	 qqWKh9IbNcZOots0tCo95xxx38IqCC5RLsHH+wgRArii+KRrvzl9hivVoGr0Qp7Mdj
	 e6JIb3kknNcn8VC1kJf3GL6WzF9Zu/3FatptpsAQjwFcfw6BasZKVrhcMcCRTXgsKs
	 bj0uLjCJNYkas6NBhgR6Sup+5dN6l79ufOCpZ+TcaeYVhLsRtLmLFz4uAF6rYYP3VB
	 mBwt859ZmB4c1FCaydz731HnFwNvP3RJpzinCL6N042yJBgpiazhbYOpwywUejcy5V
	 f6EcX6h9WVWdQ==
Date: Fri, 12 Sep 2025 10:07:23 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-mm@kvack.org, Kees Cook
 <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro
 <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] uaccess: Comment that copy to/from inatomic requires
 page fault disabled
Message-Id: <20250912100723.4fce2b29c4d77f3a89c0b636@kernel.org>
In-Reply-To: <20250910161820.247f526a@gandalf.local.home>
References: <20250910161820.247f526a@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C927E40009
X-Stat-Signature: s84g6ue3beywzw3e5rnafd8daco6zode
X-HE-Tag: 1757639248-357889
X-HE-Meta: U2FsdGVkX18+ayi17IxRdkTIDr+Ltx92d9oJmZ6fcZC4mEnxzsuRBXLKChnfOP125+6zlzxaTeDVFeM5EFQmzhX+AkRFmwV3ADh03PsBzgKdwxZn7B4BbBr/ex3ZX00qWUgipn3QMWKkCEnrNQMmGA78imJ4tu6T5NMCOr1ca1jR/JYqdPfNeb3iMgLlX5Tjta6shAjBrrRG0Mi/KQcAejVYOVGpRtb+Y16gaN7O1pW4VCHziMgrKphIdqTZ8l6T2dL4erJHI7fM3kIBit/62tGLxbnctJprRNc8z3NXG9gT+tehfMJQ7DD5cTugrvP41zlZGPF6O8wEvkT+oSjYFoarANWwOq3WKj7eOIwANbJvLO+tUjDx5978KkLdNgnyPI3VTPDPRdAxwdaeYFFKzOMX+d1JLTcGXD/bzrgMx5JClUL/nGteRh/NNT4HrYFnhmxBXdir8N4AZfNki+maS2mopd6uENodlU8CRZTs5U726bWYFQTbwtsS9kWFFbCQi1CtlZ70y5TIfjgI15XkRE085rD34Z0KuemOP3Ihv5raoJumfX03R+KPlEiD5FSn0LmLWD8A2TX5HpoKzU5rhdeUFmPhRZDMbc+TSNQeFwG5/cjqTi1pYlRX0S6AJWN9x6hlSY6yyLQI5rmUqHiAFDjHsUGwvCAGul1/UM414xaYINQzgJvmLY0ufrdPepCozTMmk7nq5abNHVKph2x+q6Wmn+MoDHkort2EzQH2Q4MEX8qLHzyju422UIelOQ3uKxZ4xzXTAzQIsDB8tA7MkBPEeR4iHCchqIycGkyNAxvjbZ/sWO5Lg1IrEz92ePlPbDEkEm8qo70NrvL0l4o0qBKpD/V0AO0DnEXsVD3LwgktAPciei6W4t17zLm1STzFFcsxceHipuZbYsFLADelbzX8SZdYbRu1cVFyf416dc1MVGFiXwWueT48dWWp5dkKYKq/4gkX5A+EiqmD/w+
 e/zQfRUD
 EgSy1IdIUAInCHAvr45NVktrVM6phZb8Ocw8rXaM3GNM/F+kxMYrvDLYjzQMi0EycsS4IAnlqQRH7fYELtEbYWpt442ScxTAXo9EmvS0Byr/mFXgReS5N18GA/UlgW1OR5baCWBl0EFWQJHue9ithaWkNrV64S66HG2l0kx4mRJH09w+/Htonn6/SfUNj6uX1KDQKNYwf+8WHPcE7xEPLWltbvUUzf6tqaEVfXRKOuVDrRaunEnyAG3YXSXe+L4J+yjgL5hmRWX7raSLnA1EuDbyZi/EwWLkVoiHI76c/hujbf+B7Lze/HyOuhv46jLv6ezmkKZJwTGnvXPXARplG247vIkbOVGU7JB8v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 16:18:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The functions __copy_from_user_inatomic() and __copy_to_user_inatomic()
> both require that either the user space memory is pinned, or that page
> faults are disabled when they are called. If page faults are not disabled,
> and the memory is not present, the fault handling of reading or writing to
> that memory may cause the kernel to schedule. That would be bad in an
> atomic context.
> 
> Link: https://lore.kernel.org/all/20250819105152.2766363-1-luogengkun@huaweicloud.com/
> 

Looks good to me.

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks,


> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/linux/uaccess.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 1beb5b395d81..add99fa9b656 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -86,6 +86,12 @@
>   * as usual) and both source and destination can trigger faults.
>   */
>  
> +/*
> + * __copy_from_user_inatomic() is safe to use in an atomic context but
> + * the user space memory must either be pinned in memory, or page faults
> + * must be disabled, otherwise the page fault handling may cause the function
> + * to schedule.
> + */
>  static __always_inline __must_check unsigned long
>  __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
>  {
> @@ -124,7 +130,8 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
>   * Copy data from kernel space to user space.  Caller must check
>   * the specified block with access_ok() before calling this function.
>   * The caller should also make sure he pins the user space address
> - * so that we don't result in page fault and sleep.
> + * or call page_fault_disable() so that we don't result in a page fault
> + * and sleep.
>   */
>  static __always_inline __must_check unsigned long
>  __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
> -- 
> 2.50.1
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

