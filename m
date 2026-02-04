Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0AAEA794A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 22:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664996B008A; Wed,  4 Feb 2026 17:44:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611AB6B0092; Wed,  4 Feb 2026 17:44:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510806B0093; Wed,  4 Feb 2026 17:44:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F17D6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:44:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4772140305
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:44:45 +0000 (UTC)
X-FDA: 84408255330.04.3408D1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3495640002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:44:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rh93rqzA;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770245084; a=rsa-sha256;
	cv=none;
	b=0KDe+x8CqqdrWEEMzHwxl4cvxSnEy9mo0uhHJo3oe3IjGQu3lCxWui0D0ZzjaaVTia/qlL
	63ZbVYHuOt5jLMo0UhUutoVR6gmqHQTEN9BcO985gdgzBdF6gmyxlOSPMnYoWxRtxe3WGq
	3WIsDnQtvGgvQzxZ/bFV5+Z317MbdeE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rh93rqzA;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770245084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hi1FTQYospgde6dt2oZ5A17mcgAlDsMrIodFJe740eA=;
	b=C52M1Hmf6RqJWJhJzMjfTQoAcOrKK/B/zYqxS8NvHG38RFD84+Sw+/DySPo2w0IiWNMHoh
	alNBgTYKUIg48/IMWyuaRCqnpWXMLS1mwVx/ZYeOeXWNH3R62cb9mplvxRPxlE4oVw7Aqo
	bgrH17k5FaxcDnyT3cEDlSU0m1esXAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8278560126;
	Wed,  4 Feb 2026 22:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FA8C4CEF7;
	Wed,  4 Feb 2026 22:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770245083;
	bh=wyDXzEiDI09qoOjixuC3rPHKoCE6XE1QSc7CX3XUerQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rh93rqzAkFeBAsQzplmY9WaqsNcmP6W1cbXQ/xnBK1+PJFtrUoc7rwdpWYmLXq6fW
	 WB140oJV6TKBVyn3Py9cljiJjWBbWFt7A5b6CjjZOVs/+XIH+OCBnvZ445ok2Edu7D
	 5R9zmSuLbcq4iX9J+Nb9RCpNuvUT6ozhoo+tayP4=
Date: Wed, 4 Feb 2026 14:44:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>, jane.chu@oracle.com,
 muchun.song@linux.dev, osalvador@suse.de, william.roche@oracle.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: hugetlb: simplify remove_inode_hugepages()
 return type
Message-Id: <20260204144442.4eb44f4bb933daed44d5db96@linux-foundation.org>
In-Reply-To: <17af6fe6-9318-4e9c-ba54-0b6b16ea9c0c@kernel.org>
References: <20260204214741.3161520-1-jiaqiyan@google.com>
	<17af6fe6-9318-4e9c-ba54-0b6b16ea9c0c@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3495640002
X-Stat-Signature: 1xn1g54mttzqrz7ecq9tou7k4tricayh
X-HE-Tag: 1770245084-983231
X-HE-Meta: U2FsdGVkX1+yl3w5ap09iC/p2XQGnR8A3izKkzpXyvk4R5BA/OB6u6FFhSBUtzDpYIUQXK+FMQZzzWE9G7KLlHG2a1hptDbrpNkqQTb6KwXu3ukGllV+Zxl28cbUiiHbEvqcrPx5mqPgG0l5xRzhJUsdk4tvXAeqs4Ui00TtxEyXFrQ8SKjP6Ybk7jGJNLZzfG91jdJVSJ6KyQQyMOFRg+aEkxzQrQXw14pa6A77qDoaVl1X4eH6UZk7HWmMOdM+NCVJhPZWakNwwZZU0osTn4O13RwHS1irxydYrWInYjvwEz9LHbuPJ/WsBJZDgtUW9fweDlVRKvDF411XX/xtjw0Y+F/dIEeJqhAc8nA7el0Wr4g5nmPwSsaGzLNeQPk4KLrcEFBJtNDqgc/otffr49BD4fVGtx+YQI+6pQsWC8WYnF3qwQkYpyrR2yd2bU3If3ybgx9bWRTjGF5vtij4acj1MyIhOpqab3k9KH6Kz+Du7uRzZ6kctaiGPIHhPkBBRGs6D5bENXQ940+D70CsrLVf1qOSJBm7qUQb6qCQMX4dbH5RWkwYBJXIBnyEw1sF8s2vokpzcOLX9fnAwyS+bh2ddEBBBh8ip9xxyo046QHD3Wq5aozk224r8M/9HE/KTyKzv5PWeNZISoJy/C2A23GWZbzNK1WqNgjnLc/liHOPMwgfIlX2N1nZTTYIL/z1pLcRTInjWe8h1RXvUnjvOEVd8++hcF63QYuE3Z6FKA9LqOKE7Dk3Y3K/Z+rVaoD6QQDOp3wAlTn/4WSBv2iDywVKw6PxguDkggiQsbvtjoCiwi7U9e5H0BnrTbDIGLP0v6krRQrzfb5v+fVAC7i3F/HF8ZtV74s8LMCgdjs+DLhnm3n4YrMmUjbH/dvhWubyALaIn6Yxzoj+Hja+RyVxRq5B7leMYHs4cmwYq9vxOwMi5LIyWIBp4LxOaTTGCzOmeYT67DmV6gOi+SGJccz
 uWGEIb7D
 j3iNPDHcs9b7IwGx6os7l5isz/wFi/88u1Z9y1AC15iuVxJs2Sa8y3kIplQpHp1ff78Bw/5mdZ/hu/J3NZU9f8PD1GfMSORxuC9tBcWCT+jEYXvx2+BInlzXANiKk2TTsdPOf7GHszi13RJ328pUqlrM9cX/6cEdi2UpkBzT0Y3a539yM5lBkjN9DoiKIGe3C35p9bhq9P8J5jmTJsVtV2qEoJGyNaZcA7uy3qwn+IyJJD4dctDjYADLvdaBUwU7XF7pmnZ6IQE99CPKYWBQGuks4Cvqi70UkLEkHYJO0tbpvkFkWLHOOz83ThjJGWcY7chLVaVLO2JPNWWc3gglb0C3n2L1ou4VoJq60G6K/gD9BPDaoaasSiJXEXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 22:54:48 +0100 "David Hildenbrand (arm)" <david@kernel.org> wrote:

> > Changelog
> > =========
> > 
> > v2 -> v1 [2]
> > 
> > - Use two-tab alignment for parameters wrapped to new lines.
> > 
> > - Remove return type in remove_inode_hugepages()'s comment.
> > 
> > [1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com
> > [2] https://lore.kernel.org/linux-mm/20260202233617.2350734-1-jiaqiyan@google.com
> > 
> > Suggested-by: Jane Chu <jane.chu@oracle.com>
> > Reviewed-by: Jane Chu <jane.chu@oracle.com>
> > Reviewed-by: Muchun Song <muchun.song@linux.dev>
> > Acked-by: David Hildenbrand (arm) <david@kernel.org>
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> 
> For the future, the changelog always belongs down here, under the ---, like
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
> 
> Changelog
> ...
> 
>   fs/hugetlbfs/inode.c | 18 ++++++------------
>   1 file changed, 6 insertions(+), 12 deletions(-)
> 
> I think I always add another "---" above the file list, not sure if that 
> is required.

Interpretations might vary but the "^---$" inventor sayeth that
everything below the "^---$" is not part of the changelog and is to be
removed.


Also, my preference is that the permanent upstreamable changelog not
contain short-term development-time information, as that's
uninteresting to someone who is looking at the commit three years from
now.

Material such as "how this patch differes from the previous version"
and "how I tested it" is interesting and useful, but below the "^---$",
please.


Beware that git interprets the separator more loosely: "^-----------"
will match.  So using a row of "-" characters to underline a heading is
a pitfall.


