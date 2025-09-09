Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C21CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 04:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A114F8E000C; Tue,  9 Sep 2025 00:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0B18E0009; Tue,  9 Sep 2025 00:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889D88E000C; Tue,  9 Sep 2025 00:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 753D28E0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:25:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1B93140306
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:25:25 +0000 (UTC)
X-FDA: 83868422610.19.1AB4503
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E60820005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:25:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i9pJ18PL;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757391924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDNbPtcfIaumxIyBJ2RGyPKbViivs7UqJ3a/5CcYXNc=;
	b=huUyhFHQZ2hvdd9nEHxx2Y4p1uIG6nD8+PFUwVpExcrySspzSX5dCgTZmWZSMCfyLSIWjc
	ouMxtN4BWvY/m25HbqxtnpmyBpeM0oOIlzIPotYEMZTtXieB8yZqRDj1c7rUesiWJLN5R+
	WYXmobwqK0cV93JgXwvZ0R1qhlmhkqI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i9pJ18PL;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757391924; a=rsa-sha256;
	cv=none;
	b=0qrSC854Lbgu6RlT9Zv+cYoq0F8F/b+VedSq+G1u5t8UsjhBkDf/racI69W0fX4Qp4+6Qs
	23yJeV3FSS3on4LZxgsLMrewrV5A1/w97Sj8G258LTUDA3sgHQJ0DrUGX2WThH/mjWHcdq
	7A5FlCpl5EmbynYLxh31mFaqCqDwdmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05467449E2;
	Tue,  9 Sep 2025 04:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9D2C4CEF4;
	Tue,  9 Sep 2025 04:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757391922;
	bh=RrzY4SDc18Ci2TyOyhCgyGYX7hmnnBCU2e/pxbH8zRw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i9pJ18PLXuxKbzs/Iruw3PpLBgKXy9ssEffV+i7Q9gMAvoRB7kzd+iGGYRZ4Vjd4z
	 nsdDoX1b8RjqFfB2U020ZMoVgWz32DH/3KHr9yu4W24HNyAdp4ShFmw5Gwb3/8dyxq
	 YI0F046jfWbWEKO92OxW3X9LzuK+WjtFkn1xH7Gk=
Date: Mon, 8 Sep 2025 21:25:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Brendan Jackman
 <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou
 <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe
 <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner
 <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-Id: <20250908212518.77671b31aaad2832c17eab07@linux-foundation.org>
In-Reply-To: <64fe4c61-f9cc-4a5a-9c33-07bd0f089e94@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
	<20250901150359.867252-20-david@redhat.com>
	<5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
	<20250905230006.GA1776@sol>
	<64fe4c61-f9cc-4a5a-9c33-07bd0f089e94@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rzipjpb6np8uicc3zdetbn4fq6qb4knp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E60820005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757391924-412615
X-HE-Meta: U2FsdGVkX19Iko8Za1bTTOqL2M9yno32XA8d1Olnep7mUm6x224ijohwKT4pEG9zNPh+ef0GWi+nujwLqF3w0tSHDZDzVlzB+pw+zFCDIiCl0oWT4uPjW+DVAuirOd+et+O61uYdZKSz9mV7H9vubfPdhhb7S+CXszMV2J/UPUYFETpfO2Z0EPe0pTbR+sG4czJF666E8KlGjHhdtPVvvbRbEXcLbiGm4Mbl8fdXvAVhKtXe2nA3WXr0/mdOymgYUsypjwlleMSxe6p/wIJSw9rQFkWDw7RFkhij0PPHJkyj/poV1cVo/0znRmClAWO4M7knecucfZCaVinrfkOQKo/VlqqasSUV/HsGP5LbDWL0+CCFJ+RGwuYlvgWPYBfQXsh8IfXIjRg17EEQr5rmAqvRv9kmXgLIVMlmp7D6HuNjjJNScr53/I/6iqaLXPH3E2ktAl5IVtUsplrMW6NtAQ7kcL1qCluMMJ53ySsBIBqtWcX15q5iM3fS3qNlE5lzQzFEhwHnArcqEQSWBSuVmJAJXj0ZUyMYsoPFNnigWegzptApFUoKYG9OGklCOUW3gsEGms/2JJ0ceG38EZ3Ug6/BAUU9FNgGHossgflPSn7A9GOGJo/AufpK7lLMqrypNASnC6htrXm4C+SPv9anqFLjELpNhl9PIWmzc9Xn3RCrqOFIogf5e1P4l4/aq/+zyBLdaMN3oUGSoFqYv5Z9J4BqH1eNGIMI9BTVuT4XnQ+OFr206ot2wjGZHOFguyk8AYhFYtj/gLx9pujKwj+3fKWoFlidvTgJfOh7mx5rlAKwZcfzG1b4YyBmglMQ9u4m/MK0aD4c/pf4izXBfj526UfRrGSY8YtRIQYgsGdrFYL6sKEgX6zrOUTlkJJxjWSGmhGAfVXWro/+QylKykxFMYbsODteIXxIVoK0uMdcCz8WzwC0cXfGkArMgUXh91VlDAJQNOfkZpM4RFI4WNA
 OfsqVICS
 D/u/HySVJB84EP8EtQ3G6TSfsWFiV8V6EN8BoYjwh6luZhcw9xn3Ddk/NSXow2TcLFYUoPl4RUlYgnCYvtzhZ1U3ZQ9xiwg5LTWnUa0EIT8Ad40UdQmh4BpnRLk5kLsmHop3+JxnjtwckPxBUcd1bllYnp3DC1tk03MCKPGeR01aW3lYTzDXn0N/sakXYG6VjgT0tmFBPBBpdguHZi/5QUoZhc6qaBb85evq0okXid27vkHEYDBLHuBdJ5ohQUKYDbJ+Nabac1ojBQzyyLoFuD2ajxuhxIyqLOEZL9QEcW9TthWafVsKJnX8MecKNXvVG5o0J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 6 Sep 2025 08:57:37 +0200 David Hildenbrand <david@redhat.com> wrote:

> >> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >>                  return 0;
> >>          }
> >> +       pages += *nr;
> >>          *nr += refs;
> >>          for (; refs; refs--)
> >>                  *(pages++) = page++;
> > 
> > Can this get folded in soon?  This bug is causing crashes in AF_ALG too.
> 
> Andrew immediately dropped the original patch, so it's gone from 
> mm-unstable and should be gone from next soon (today?).

I restored it once you sent out the fix.  It doesn't seem to be in
present -next but it should be there in the next one.

