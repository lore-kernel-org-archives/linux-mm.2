Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE6B210F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B9C6B008C; Tue, 31 Mar 2026 14:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103166B0095; Tue, 31 Mar 2026 14:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F906B0096; Tue, 31 Mar 2026 14:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5C1F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:29:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EE5C1B7732
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:29:26 +0000 (UTC)
X-FDA: 84607195932.13.95E0EC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B538B18000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:29:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=psWL4NZu;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774981764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J00T2JxMYTG/x/x140fHqGBOqhKZUYg0rDSqmFS8gLs=;
	b=i1SOSQr6+p/R6hqZWcW2KCqUdmM3kza9oh6svOHQb60wWIZALAhO5hVubVifIoYZHLV8QX
	ybOodP99Z5fS+eR9d31sLcln0JDvPO/hTzpjRzG2mDxmqNN699ECiZPLjRxkNvh7bqmJrd
	HTMMjXtpoHKyfI9hpXFYkvgDVyn04jI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=psWL4NZu;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774981764; a=rsa-sha256;
	cv=none;
	b=K5kcIhDONfImFgPLfeEGMxAKjjKet4j1MuxYImg2+HPU4iK0mgOIztPnKQdobzw9ANuUsB
	32GVDyTnDawNhevb+WuinwlZ6m+U92aEO55DbPtIoUJKblh4sFJxH7YlnXWa/YzBbs5snn
	rYMHlH6giYOeatuTYbrH9gxLn+dSC44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F0A940A54;
	Tue, 31 Mar 2026 18:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF9FC19423;
	Tue, 31 Mar 2026 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774981763;
	bh=F+p+n3x+VzyufNJY9nXy/ifCuLJFzInK3nA+2woKvxI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=psWL4NZu9ag0FPb5FMERi89uk3vAYSdwJ6Jr11ixC6/8u6RxEisHJvG4oMZ0ss1wa
	 h0dqxH5s2StJz2k2ac1CKvcdQ53N1oEowBsSLP/n5D8dDYwwFkfqAo6gZliPYRZnJi
	 fs/N0xEVjUD6NdlZrzBZLQz+El5FY7Bxd/dn0oVM=
Date: Tue, 31 Mar 2026 11:29:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, willy@infradead.org,
 david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org,
 mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
 npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm
 syscalls
Message-Id: <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org>
In-Reply-To: <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
References: <20260327205457.604224-1-surenb@google.com>
	<20260327205457.604224-3-surenb@google.com>
	<5d90d998-9b8d-435c-b684-260600311797@lucifer.local>
	<CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B538B18000D
X-Stat-Signature: imomjpyrntntqaozshnfsnrkg515cz99
X-Rspamd-Server: rspam06
X-HE-Tag: 1774981764-241899
X-HE-Meta: U2FsdGVkX1+I7z4fd1wXbNR+zmEv0dNqqDF6m28xccztisTc0TWia31oVJQvpwYq0T/krQmPMXZgd9w30DqjZVXbgRPBwo0RAvE6aMEnFs5eDT7+yRSYt7ENDY36D+nJemhQrHbwmVXo/EVqaKB00zW8V9kb1V0xCwo8Zh719KxriCPhi1CC0WJ9g+a18YxLEqMjlGh2NSAM/2NroOwmlokYaHl6XThQQs4uXhCmMaRPZo8BaXdSuKzHRuvWbIlDfD14MTf7NowFjzYCx6GqWonN5MSJtPg0aO8YPi0wtrW7w1SaDiowGzL6WPbVqku+6rwGW1rij8yZBIeRfBUqE0Lx4HyUUKiXcNm69XfV3EBKgsEPytOhGFawtIfxywkAuu2MxXwWKEoX4rIjGAe+aRpbxtbVMx1/ZbwUUWj+NZXKD9C1o57/8mn+JFANCHoQbBmQ1lhMPEdLsoTzWQ7wOKJn8yzoWJ2w5QSEJ3PAg2gEe03FEg7Ew8K7/R/HQ8ilJK+5P2JAwXP9g5jOl6LvmVKkuy5kPFjmQyPuO2wHnCVk/T09q0VL+1Ne5ABnHeYeFIvVfXrNqC+J/cf88nDP/eCuGXHhPVDhCduyJ2j/LCk9k66xAAlBNrahum+2OFHhtlwtqeZMY1vrctE73p21SFToTm3u/YurDaTos/k+i5uUJOjlU/K/HkpQzH1ZiXmbYFX8HvIIxwqQ9eK+NcjdDZ/R0pU2U24d/8vLUVYu+yEwT+EgX9YmlyOMZOG/6P7YUZXi9uWG6+H0bIJlivkhn7XrKxiGC3Xe2ed56lvb46d9hdFVDgxrxXPk8f64h75CRoUS9AWmvX7AJbGoYgMFsnJi+pIHP+d9uKUVmhATI8dIp4BQsANTPl7XW66GOghTzvj3eBNnJltwQzNGwlitEiEL+i+GgftEJPpBjUtGZIprSx1C7rAbVYb+fXbHMDej9DRYH7FjZKGqNKUpa9i
 gBMGOc9B
 Tf/3HxnvUNnRUrKvUl0kMtaK/wxakiKbIVBJtbMod6YblDFvis3ujerAqbYpkeISUhLDqCM1dITDMzguVxoBYk2CMz+D4GqPzL/Bg0xuEEcuF6Afm0v0GNNS7QlVxuY2DhMhwbfYvrHIv33FA9aOpYYhS9g+wA01MbFIqekcB6ZfgWojxvrWIajo+b2gTa7JkU45UF1OKZm+hKnt3goyLPLLb+lWETFcgtU13s/6Lna1yOnsndKTaTBarZtihc1yIzPTViNIe8yEmv+2WcPsD8me7MEW3YG/Y+S9IS44yviNnZQEWy1XVfnh8EAtXvLXSbTRTcEZ8spFNAHfSWFhxoHPyLWodQrW3E7LDxbcg5G8X0AvIlk1uBX1naIRweCJrJDGy8JDFMNIodVlCF6WZ+z8o4/StRQSo/xPZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 08:01:11 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> > Instead? That is, assuming we really need to care about this at all.
> >
> > But I think I don't like this change at all?
> 
> Yeah, this was the part I wasn't sure if it's worth adding. With your
> vote confirming my scepticism I'll go ahead and remove the parts I
> added to avoid extra vma_start_write_killable() call (3 instances in
> all) and will post v7.

Thanks.  I'll remove v6 from mm.git and shall await Lorenzo's advice on
v7.


