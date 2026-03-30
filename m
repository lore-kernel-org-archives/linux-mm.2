Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570CC1061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833806B008C; Mon, 30 Mar 2026 16:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3D66B0095; Mon, 30 Mar 2026 16:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA636B0096; Mon, 30 Mar 2026 16:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9BE6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D1D41B85EA
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:48:17 +0000 (UTC)
X-FDA: 84603917034.05.9EC22DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 434C340005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:48:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WqpHDmwv;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774903695; a=rsa-sha256;
	cv=none;
	b=4x3GjzbFQ+RyILa4ywWDp/hvDh80tCSKs7gaLKv9DaJd8lRzuROShwJZuUPzaQDrI30kCT
	hoxhgsgs9pg3Yo00/Ie04b/lkTUJ2Ecm6CAlnMbMJ65Zm1DZ5sR41fp/h7bH3aK9TFZZh3
	4IxNCj5p9KYMs3Rf7q3KBWCm7gzqVDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774903695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sP+elCVD82x/GULcaOvWEpGNwwM1mOq6mIvqiIwxppg=;
	b=ULU0XeizzHQHzH73xjp7XXWMMbL0cnDXhmacXesiSXE0RcCxPTdzBEvIMHfdbW56d2FdJC
	SFbyGjFVgFqg5ocLFp7uI/sor9hsmpO5NvOtpMHEoTqMUQMHagVByIqYHHXdID+cc0EsGv
	VJOBcPT2U6DXWOXCgaEfq2deZ21SgUw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WqpHDmwv;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36CDD44432;
	Mon, 30 Mar 2026 20:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0666DC2BCB2;
	Mon, 30 Mar 2026 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774903694;
	bh=AaC4BteHAcUMtfgTBPqFhez5N/O8Wu9jNTP2fUEP0Yo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WqpHDmwvIXKW+/jzj3WX55uyQ7jmHFcCXPRwU9/+TETEGtCBj+oqTTc1jLpzQy5pL
	 NORSQfbfFyImibCOwO+wzQYp5NuHyuYsSHsYxnBVgDCgoYsxYTF/cKtexdbLU4hP2W
	 669EEaI5PuvaW+cpqXI1bTvyNxK2Rfxs3y7ao7OQ=
Date: Mon, 30 Mar 2026 13:48:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Liang <ljykernel@163.com>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/page_owner: warn when stack trace depth hits
 PAGE_OWNER_STACK_DEPTH limit
Message-Id: <20260330134813.084a2becac8ffc3cca99e1d5@linux-foundation.org>
In-Reply-To: <20260328214408.2990597-1-ljykernel@163.com>
References: <20260328214408.2990597-1-ljykernel@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 434C340005
X-Stat-Signature: mo1oeugn8nq871kir3uaqynwu6bsar9g
X-HE-Tag: 1774903695-607117
X-HE-Meta: U2FsdGVkX1/EhCbp6luMawHxrgl4gGwN8xHLO3Zr+NwZQkLUk9b160EPnv2rLSo2yuUStNpG8UpkfX3jHr/PRFtcvwIio4iBg8g1Em3I3Mon83RqETZk6AO9X/Mtrj2G3Qe15ZTTB9yOMynAe9885mRbdjxf295UU999qpX1VwzHGAS9b0zElrVMim61Abs7GgCUO09aSbfOZb4ppSLY0/PRKr9v4WhHFbRd6fJaqpWBKB8j2q2JwAJkxiDzy34BHVdQrG67bu4VxbgUWphRmCzYhaUgrdoJV7p3+KGKIyq4kK8FgXxjtkES05/QqGcBCqZYvOg5foQdFwRiJ8Pmxj60XSvZxyru6b45d90xZmIFBaRzDOWMZH7TUtsl0hX+srgThN2F/trth3eywxGluDU7GF/rQ4B0LsKWHAfD8VRuCb/rZt29ScnPY7mT5MToWn1i0NqlWiAXeMatoizuPoyQFii4CXGwb4+ezgvvw7/zttfUsf34XanLaTPZ9WQomMlzODLTYiAPixC5BphRO2qre0hKsayVZURpO5mCvJU6XvR5ox4wzE48Er+wYRFaC45yaqe91YKYr1F5hcSHRbnSejTYsRKqhm60pnMotTyCpFK75cryS7z+Gjq8DBcoR1bLhZm6rEg1rvXBf8XDSGkbz3WouHQapMkOIwVHd65ZQSNkvitXr+89O2MQilYxFa+/sP9LTk6nF+YLwEUHSOJPMQQgpi9Vwjez7wyzc5eQKf/YEE9XBmcOJErrPaAdZu0ZwX2q5gAjcH09KCNXJXE4C/X4j/VUVvTnZ0/R/aBxoe/AAdFJByYROuJEDokmwLrL08gaVIUgdYPgE4XESUf4a8bXFHbkrt3EQytxG30cd8IEVJ/xC5a9FpxawNVlivtYZjwUo/Nm/UkSn6peOqw6NmjzSb0SiUBF/G6sng/5QMSMiWxiIXjn3Z8C0ZR64405Kmd8fPnXlehcwje
 8WD2TBJY
 T1fomN56x2eVh1pLJ+OriGGbAwSM1DDvXjad3HeoXmNr/dg6vGcFAOTCGBZra2c8qcfH24pdKOBKU3WSKowhgcYZdAijcqgwL814CCFruFvEHtN5P449KpzQkERn/9yznBO0oS9E2EyitbYO5AdBRpdVIHm49JVdnODn7GKC8KWnDltNtiAo7dwrJXr8YSVrQPgTYEp0CAVNHLxodE8iwlLHuQSm7lEheHIHzh5BUyHp9dnuAmBlUn9854TEFRH5huasBWG/F/8zrZAdSxy0vHgQbsH209+4I5SJDGa8pw19OyKVV6RCJY6vRNh6SmvuEKeoA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 05:44:08 +0800 Jiayuan Liang <ljykernel@163.com> wrote:

> page_owner silently truncates stack traces deeper than
> PAGE_OWNER_STACK_DEPTH (16), which hides root caller information during
> memory debugging.
> 
> Add a ratelimited warning to notify developers when this truncation occurs.
> 
> ...
>
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -163,6 +163,9 @@ static noinline depot_stack_handle_t save_stack(gfp_t flags)
>  
>  	set_current_in_page_owner();
>  	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
> +	if (nr_entries >= PAGE_OWNER_STACK_DEPTH)
> +		pr_warn_ratelimited("page_owner: stack depth %u exceeds limit %u\n",
> +			nr_entries, PAGE_OWNER_STACK_DEPTH);
>  	handle = stack_depot_save(entries, nr_entries, flags);
>  	if (!handle)
>  		handle = failure_handle;

Is it ideal to emit this warning in real time?  Would it be better to
tell the user "this was truncated" when they actually _use_ the data? 
Presumably this would require alteration to page_owner_sort.c and
page_owner.rst.


