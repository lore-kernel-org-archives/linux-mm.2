Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C907ECCF9F0
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 01:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF548E00B8; Thu, 30 Oct 2025 21:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878748E006B; Thu, 30 Oct 2025 21:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78DC88E00B8; Thu, 30 Oct 2025 21:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 621A68E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:36:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2827C0349
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:36:24 +0000 (UTC)
X-FDA: 84056694288.20.41AA14B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3BFDB18000D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:36:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DyL9QH92;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761874583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCm979f+J3jhIi23rQzAYF5awUaKneiA/jyLW1W4duk=;
	b=wlp2r02q18B0Cz+fAe2pomTkuYWsx1rCPvG7EqjvQcv2GPcxn/MjM+lQFiMnBdoZt1spY9
	XdYcfmTzkevtGp87363RJUlBCdHAgaRYuto01dT9fUkKKYXrsB7FnWKLNqceB8cFIg+xAQ
	9qgXE8v7SelOlK1z17avz2rhmQl8U68=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DyL9QH92;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761874583; a=rsa-sha256;
	cv=none;
	b=aA1oWHeB5oIxtJq5xardJEy0uM3uKOYDQV6Mi14V5CgUhDMWx2x4XdB6BtU+4F4vMLo8cW
	S+WQ6Errktf7c0sDErZbEzBDiCugGhggPO42+8OOgCZDnXaE0yxzWqSxPl5ap551ezmD6E
	aH9nVVxxqTS6Jtmz6sIasTR8Bh+kEjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 034C040A73;
	Fri, 31 Oct 2025 01:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38F5C4CEFD;
	Fri, 31 Oct 2025 01:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761874581;
	bh=4tm9pA2jShcu+N9lUPnseKrroHmNle8ZIjjmbwf9rlQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DyL9QH92nFivkqSoVwg+5QuGmkfoNOkl8LqwiZfabUFEw78GFh5GqBly/EmJKKUuN
	 cLySKH7548j4QUJf4/1UBcjPb1VIt3ull8LMTtN/1aSpzvtW22mFEo6Dzs4zbgPhQj
	 xgDLkAYuKEzUz2HkckVkk/O0ggDj0BdumdxunLjA=
Date: Thu, 30 Oct 2025 18:36:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Big Sleep <big-sleep-vuln-reports@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: Oops in secretmem_fault()
Message-Id: <20251030183621.39ea843ebba82ae133b2b38b@linux-foundation.org>
In-Reply-To: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BFDB18000D
X-Stat-Signature: ide9eu33dnpr59w4d31shkmfbf6fhxgh
X-Rspam-User: 
X-HE-Tag: 1761874583-851096
X-HE-Meta: U2FsdGVkX18FA8cy0PV9z7xRSy5Rv27Yt0nPxAlgOLfK7ViVe105V4ec/9wVviOvjkd3CMGITLqs38zSn2JTToE4Sc9BYwA+YnHT2nVtFvqF25W7POIxnopudRBP8ybYBKvLB9etFqi9gd1FKC6sjRvPTwucg6o66Iohq+hGhLyq7lvrA4M0WjWd9se3dY9dVjb5QH7QYs/rHtCGl6/Xjz44/+I5gqH8d4+2GxZiuBuEtrmG61DsenVEffdS5iSKcdOsYoJSoNs+O58NQqXZ9tWWL+v82iFg/PubMwZy1OgUeFWqv8OfiaHXGx4YlqZwshrkh4+GVzMATE/hrZpyP4VKphrstjR0cEse7vrBUU/ifvniG5gdSKPFE2A8F6um9tV3tG3co5MoJs7aJvc5IFEeGxBfr4ZTkB36tXE/zLuwDijs+HiZKC0MZFXSr4jzA3vdCRc4Ykahj+7aag6NMTnn2KZrvmor4d9Y1AyVO+4AqnOsEdEuMZXKNhJDaAkYv9Dz9q2HBuinMuFN61WQgv3KLAqe1Pv+VesMehD+EYFBdj327V+qenuFhnYMluMoCUrSO/leAnzPO4V+k9q9dO9eFzNzvZjKhlaQaDViQR8xdIwji1N4hz9U7kr1rbrJo8A4DGeJOT4nO/KUVVHNPb0m1C0dhvnmxsekFC9iZ/hru7TDv6lCazXmQYS31+1JJVS4vsCS70G39iIpYgztxHuYbvPbNv5dHf2BMYec9abtZk2aQCDgAb/LcP8zDk9WoXF93rDAvz4BZwkUHO5VWHdXKWnDCDTIxdH5tzUCB5GJ+WGFTBZoHyZmpnZl6q9IlnvO85LeAD1RMtOqWPWnJBP++KIOVXBCGvRJhTsVqoklWsXEUNLbZ2hxLUjJFot4fz+QV/0RgJbiAlaNdYGGFn5Z/QrvJiwnVSPBL42zjk/tzqcv/TtT1PHaLyiz1lyOfYTh+CPyVnQ7qtd81ih
 XDxEVT7J
 VHO0n1HDFlOWD+q0GDbAb+f/dZAd7itbkV2KE/NGtY9v9IfB6Ezzz7OTcUlQie3U7Z1nQoLBRVoBQmCecHL3MkdYToVyMhvBb9DyUTKoy6lkr2xQji3FqHx4S3dtUdDy9Ekk+5pgNgFuJOT8TIZtP9FS4HE/1a2dwxhZpLeJeNnldB63XboANVv6mvl5SkS/i3Ssx2p06cLsvYlB9oQPBw0sM3iAGHUrPyhZ9jaIcuXwuK3qS8m4rUtsBTtlST4o/xFkQmqvczSDNmKnR0vlL13kO62IT+CKc10b/1ie0bgDeuEwDPlYDNd3EUppzUl0nAJYuB9RA9qUGf8LXT470cnkyPHh3p9XI9HIh8Vx4m95H20EGMp9BEdh/HPIeRBkPc+l2RvolnjhkUrrPLDp8m4IzQ3MWfvG3QNMn8G8f6jqzaOYTGuXsQjAzD7MSr9lEa5jqKnvQ5cpLZ5Ew6Zly/5c6bioQeEhzKnFYK8WBI0xvqU9GMzhpG3HzGIVvyyOR7eThYSxX0OCTRk5siQskfXhmyT9zYUfsWFmQzHC+jbSBCgU7y0qUptf6dB2vXuzBIMnjIoxWV8BzOtNSBymCyl+aZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Oct 2025 16:34:29 +0100 Big Sleep <big-sleep-vuln-reports@google.com> wrote:

> Hello Mike and Andrew,
> 
> we found a bug in secretmem_fault() - please see below for details!
> 
> --Google Big Sleep

Didn't know about this - it looks neat.

https://issuetracker.google.com/issues/430375499

: Big Sleep is a collaboration between Google Project Zero and Google
: DeepMind to build an agentic AI system to help automate software
: vulnerability research

>
> ## Reporter Credit
> 
> Google Big Sleep
> 

You might want to include a token here so we (you!) can track the
report through to its resolution.  See what the sysbot people are
doing.  For example,

https://lkml.rescloud.iu.edu/2408.2/07972.html included:

: IMPORTANT: if you fix the issue, please add the following tag to the commit:
: Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com

and when Dmitry fixed this he included that info in the patch metadata:

https://lore.kernel.org/all/20251028101447.693289-1-dmantipov@yandex.ru/T/#u

and that Reported-by: will be carried all the way into the mainline tree.


btw, it would be nice to Cc some human on these reports.  One cannot
be very confident that emails sent to big-sleep-vuln-reports@google.com
will actually be read by someone.

