Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0CE106FD69
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 02:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE60F6B0005; Thu, 12 Mar 2026 22:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C931F6B0088; Thu, 12 Mar 2026 22:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF626B0089; Thu, 12 Mar 2026 22:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADAAB6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:43:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43DE713B5A9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:43:59 +0000 (UTC)
X-FDA: 84539494998.06.39F3BB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E4304000A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:43:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjHDCZWG;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773369837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeHgzSLyZ7aK5854PlJ8F3nfqrFFnUsJALq71bji/28=;
	b=VOMa6Lv/qN/W7zOnr9JPnU/V/337uOXt34XTKC9jGkVogYByZHJd8EVE8ZgKlQoAvoCBT9
	vEdbDl5Spps+YyDn6kQUwXXOg0Rmkey63Gq/V/2HUeoJ6blHFcl8GSBQ675P8WuFsz3bTq
	rmIfxlZpgb0Zg1F0ebsgVuuj5zKwgX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773369837; a=rsa-sha256;
	cv=none;
	b=p5h8zTfUIQzGRvJ4q2yn5+m21WyBi78cx6eII5mAxyJeW8O+WCAitVK8c8RPAtADckHmCl
	St7Iic5Gmd6lO83TsbEB+OWGuFpeSpWtbklUIzHEUnJhl5ZNM9WsQFKhxRdnhWio7DSmYL
	2GJQuQ8d351aSqgWGUL/kVTyFGTDb7Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjHDCZWG;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773369836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PeHgzSLyZ7aK5854PlJ8F3nfqrFFnUsJALq71bji/28=;
	b=UjHDCZWGMmsPpaTZNxnBlsxe2wb9tw+GVZDYclM5PWiBxSB7m0zhuCW+bgInlI870kqzXH
	xw0klWUyLqJhUmFF7PgGV4QYpT+13FWu/2Px7kIIP0eE1mbE1M+W5okFxUrUFcgzODFV2H
	9LziipWsXxywNKjAb/mHsXmGPfgAsD4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-iONvXC-aN0a6dNsF4I1NCQ-1; Thu,
 12 Mar 2026 22:43:50 -0400
X-MC-Unique: iONvXC-aN0a6dNsF4I1NCQ-1
X-Mimecast-MFC-AGG-ID: iONvXC-aN0a6dNsF4I1NCQ_1773369826
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C98C51956088;
	Fri, 13 Mar 2026 02:43:45 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.171])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92CBE19540C2;
	Fri, 13 Mar 2026 02:43:32 +0000 (UTC)
Date: Fri, 13 Mar 2026 10:43:27 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 4/4] selftests/mm: transhuge_stress: skip the test
 when thp not available
Message-ID: <abN5z5jpKL2GOWc3@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-5-chuhu@redhat.com>
 <708647e9-fc49-430c-a12c-f2b44caa273d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <708647e9-fc49-430c-a12c-f2b44caa273d@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 5WDz9wPFWvHbXcASl1yXJY_LXJr83IOPJhfsD4Pw9Cc_1773369826
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E4304000A
X-Stat-Signature: 1f68d8uzptkitza4ktzd6ch3kn87zi69
X-HE-Tag: 1773369836-873342
X-HE-Meta: U2FsdGVkX18H29dK82X7KLOln1oiajK/R/0r3ceQlMCk151UxkpH6ldJTECVp2ybFxVSF3Fe5tVkDrNJDXdMNIDBznd4tS+eX07R6QXlkSde5BiVQmxa77J+7ohrCjjAh+vqgOJ4uVY2QZ9q1ceUSjC9JLAVYjCH1rWpkyhzR7xJunhbfFeeEXX8Rs3MKwnJJ1OEGkyWwum+cv6XU+Qy0axS2ad1Gkq3PoRzcjn+dUqkttz+C+r3J+BO6YOGGtEbnsAunUSiwCkDHbRNdou/69W8k1wyqoVmxsqZyAj+1i5MMHOsLp/vyXOExsh6OekDXzVYUj9PlnMuKZMsOPjhgqssFwvzfxL5ZvFlL6iUmHO5Tl86uRea8HpHpBhHaNFaHl+rlJLFXqGB9aTWfcsH7fKtt64IZTPAbU78tmW9PV7iyFnQHx1bPpSQ/9lUWpkzSplQhbgTMxZOesQ5b9Axygr8bqnacYTa1o9rDWqhCVXgX3iNhqBixvoLCe6c6L3ruxJNaleBOdZvN5fmDcNyjIDnOnJRJenjUvQsMN2YVPsWn8KebfgCu55F1cmlGRffoXptedw3V9TQfAujMDIE0yp0j0wV6dUhVQqq20PzJsdZEM2W9lmagidR+bi5+fUiHZBD6gTzi/AU6ewpiQ9SsaVJv+JNEDNKYfBipVb5EM+6CoLufNbbd7ZYmZaA4QiQFXiZjzgF2C70c3vw8Ly3D5wN0WpHCYcfGiRhENASIrWEzjlFJYF8FPfr9GVRdS8UzYas5Sxq1x1qwt5OqrGbYVr1bmeE7tXbRIF5N8IBA2AuWWi+fMspxX1aXAZszRdeYMxqhYj2z3agIIHyoR13tQ5D0JbItIzKywegm3P7vv5dowXcDyMuQ9T5P4e46Yb9L1NF/5wKZlcGeoUqp9RiiwtkbWwFOqbygPawgzFLcEfhVeMFgLXhCtM9zAbbX8Naj6TBNvoq2rV6UZiFd2y
 y7RCLfV1
 0rpe/7zxllV5pjiHXw9lagCBzWnjtR+iilDyBNDqqHzmF1eQpQ4Xjzxme5vM+eUAZya5Q4Z754gOG1Y9bMpCZJYlEPVzlzIF7o/l+t60pM6OIp8AJ/tsbjdNPN3pm7Y+1d0VGA8f3UITjrXCQTwpqiw5vOO3NJGGVNbnXI/opokYj6hmWJKto2DOW8ejO+9MSmTd9EjEh0nn1QjRVYT2Rucae2xMWCnMgx5uOoSYWBsuB8Y6F1JFw2ysCdAp/Iyuv3I1K4/nHHTDbRYGQnUHD31eXIJ9zhAX1wlBOf9ayst0qDkkdgrUqhXqgN7LtcYLUPRF78DC2pgKAlKYoZnEjDMqEsWABSGaM+aIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 08:46:23PM +0100, David Hildenbrand (Arm) wrote:
> On 3/12/26 12:40, Chunyu Hu wrote:
> > The test requires thp, skip the test when thp is not available to avoid
> > false positive.
> > 
> > Tested with thp disabled kernel.
> > Before the fix:
> >   # --------------------------------
> >   # running ./transhuge-stress -d 20
> >   # --------------------------------
> >   # TAP version 13
> >   # 1..1
> >   # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
> >   # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
> >   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> >   # [FAIL]
> >   not ok 60 transhuge-stress -d 20 # exit=1
> > 
> > After the fix:
> >   # --------------------------------
> >   # running ./transhuge-stress -d 20
> >   # --------------------------------
> >   # 1..0 # SKIP Transparent Hugepages not available
> >   # [SKIP]
> >   ok 5 transhuge-stress -d 20 # SKIP
> > 
> > CC: Li Wang <liwang@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >  tools/testing/selftests/mm/transhuge-stress.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> > index bcad47c09518..76316696426d 100644
> > --- a/tools/testing/selftests/mm/transhuge-stress.c
> > +++ b/tools/testing/selftests/mm/transhuge-stress.c
> > @@ -17,6 +17,7 @@
> >  #include <sys/mman.h>
> >  #include "vm_util.h"
> >  #include "kselftest.h"
> > +#include "thp_settings.h"
> >  
> >  int backing_fd = -1;
> >  int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
> > @@ -35,6 +36,9 @@ int main(int argc, char **argv)
> >  	int pagemap_fd;
> >  	int duration = 0;
> >  
> > +	if (!thp_is_enabled())
> > +		ksft_exit_skip("Transparent Hugepages not available\n");
> > +
> >  	ksft_print_header();
> 
> Shouldn't that go under the ksft_print_header(), like you did in patch #3?

It will print the TAP version. I'll change in v2 as you suggested. Thanks!

> 
> -- 
> Cheers,
> 
> David
> 


