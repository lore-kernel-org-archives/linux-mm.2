Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56DEFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D1D6B008C; Thu, 30 Apr 2026 09:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545E66B0092; Thu, 30 Apr 2026 09:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E066B0093; Thu, 30 Apr 2026 09:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1C76B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:19:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C40DA120A6F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:10:17 +0000 (UTC)
X-FDA: 84715255674.23.7DFAF1C
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9DC5AC0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:10:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mb9+D1fQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBE8NSUW3+02PQvvq4r+eXFnlCl3NEybfip8JuueoZE=;
	b=EyNNFWlIYv9Hiu7gKkScMOkX5A7QAkrQyJy7DFdXegoRpb6HQGKSNP3km349416FQv+4kG
	+LmUuu5JZlwqWXJu8clOTnkY+gX7/KFa9uC5YrokWV4uiSrHvDTZfGEFiJGWPS53X7/JY7
	6eiYhtG3kmgGc8qZ/Gwjfs2AZJB0l+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554615; a=rsa-sha256;
	cv=none;
	b=gmjsc4spxTMpdNzfGhhSIgJuwo7rhTOGU6q7EEjm7MobJEuez4BuQG1H9cXoYW9hw4Q1XO
	+tGcCnNIk3yF/Y/hhyXRApLPmWP0ajVYI9lclvJz4OyC0arsbOU8gW4STxAS957jS5CLrK
	+75AxJiQVPW4xGzWkvN+oTzseblxY50=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mb9+D1fQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=li.wang@linux.dev
Date: Thu, 30 Apr 2026 21:09:40 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777554613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qBE8NSUW3+02PQvvq4r+eXFnlCl3NEybfip8JuueoZE=;
	b=mb9+D1fQvZfKWfRDrG3QeEXxE0x3tqzEDw+JtE0gMPGYgAk8zIec1MHCeLYTQ8NR1w+bld
	xH4WmsU9eonXYVnpfv/pVUdCjFTiKPjcSfCHCFiTDAqqN2Kq7ihnj9zIWW3G8wFkP7hJTA
	78DTXzFVi4bb6npsHsZPslzzDPmeAN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Li Wang <li.wang@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 12/54] selftests/mm: hugetlb-read-hwpoison: use
 kselftest framework
Message-ID: <afNUlEMw2MiAKL33@linux.dev>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-13-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428204240.1924129-13-rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9DC5AC0002
X-Stat-Signature: 8i6dqi88xxn8c5hu96j6yujc37i7p44g
X-Rspam-User: 
X-HE-Tag: 1777554615-283455
X-HE-Meta: U2FsdGVkX19tCMvMTcT0LP/6Sh3rS0NfvVaI2i43I1K/fzBwsPwKAGUdoOUQWLsz1LNcNn1xaksGj3lGaimfgnblXdQGq3wZWBpbW7mOIEkRXE4UxoeKW3hbGsVa9QYjTrp7VK83f6jcgm5KHuluq8B2NgZ4Cg4ZSi6J31GtWiSsYHMEMXWiDUU2hH/HpXI9LFtOo1UWYpOhsxc39YrHn80UyBZ4tIavOEGj46rr82NFIIS4xfzCDgT44Pwr1S+T6CQwWFsd39aAhJFdUmOCsSVsYA9j8bcOnwdK3Nir9sVb+zXkE/zNM9DBhSR3B1jtdNUy9ZJt62gtf4EhALYhx41T0pJP+mGQT2EjFkojrL8ADE/8QJq5c7wpH03xTmAmpWcMuAF+AlxcpxyBHm0DBGQJzfIbby1gorkMIbGw+Mlhr5Dzouu+Pf1Qq0S3gf4RJNstxs2Yqe2xxy0Npcc1lESU1dlqRTrecolcyBz3KuVipuvl8gaz3hwwb/pk/umlBW76kHtBsunRWmSbiYfXUF+UAyvAg+RF38+VQ7DbOXGLFkbbvBdw2/Q1biH0IAUCpAwazwHKUQeOPSpozZ3ZJKH7PgvIDbzcAWXwwEE6LGRMgFS5t4urF8S9Z4MlLMltJE36uhXqsRTLFGOVal4RrPctL25L5uik4pH9uDSq68EgIU3xzs1OO1jxiYceWjltqpgEzG4aZ7+MFLQm9wFU6AQYRwUZXmKH3+81tgJokMUSfigT166n9d9LXeBc113kU78AWSVxJELN1giDnDhzl5/2BtjeA712Tp5JfGFm/uS5JQU+cavILesXuo1QVTvco3b9812OFSn+619MFNYeaX7fCp4spyIAfG5wJPD8cohv0Z3CftnkFMEG9r1m8xcvrsNT95+jI8pxy0okVOHpcpfzFQn3X0eZ2jKfYMH9XRGxmvo9KMsxvmDqIN+KbsUEV+egvnpsohGUiv0xAUS
 7YA8pNEL
 hRmEV75ujpxfTIp4H55g2+3o/aqmxXYUJxsgTpFIhzZosTDIccCoG1ociI37po10O1g5cseQ4aJJF3Ln4UrdxBKw+4qG9Unmiw+Fqmju4mDU+iJNXWuishAQVC+5uubePXp/zwAgbGnIoB3EIAu0E5J+7MqBT0Q9DHy/e1vGTTpntm5NbX6OTeLE4dlCSjHpawq6KFEdYkdiE5kQEut2EQmXIehheKVZqMqLMg1yKN7k7fMcFiD8slBfR5Z5u5AwEiIkJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert hugetlb-read-hwpoison test to use kselftest framework for
> reporting and tracking successful and failing runs.
> 
> Reviewed-by: Donet Tom <donettom@linux.ibm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>


-- 
Regards,
Li Wang

