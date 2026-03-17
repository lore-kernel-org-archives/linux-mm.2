Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0439F3381D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9A56B0005; Tue, 17 Mar 2026 05:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0B96B0088; Tue, 17 Mar 2026 05:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEA86B0089; Tue, 17 Mar 2026 05:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9856B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:00:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0DE2C221D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:00:27 +0000 (UTC)
X-FDA: 84554958894.28.83B018A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A74F180013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:00:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hYiihZtc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773738025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfW4PQO+j4EnEpboaPKhMu3WfMztmYGSmgtjCkFC7Vk=;
	b=NbVNvqZ1df0wU1KwAg+haf2mPxrjFXr3o7PLBoqSoR7bLbUDnZEMLjpPaEzZBCCEl9/8SO
	S+zMkgSqJzOUpUsTTR6vaXdxhhkkHxBJZJaS8BQ1UrsJbCjc8S88j+wX1Y9cxN0tWrCSN+
	kza2d7VcPyVpf1be8KjDgYObOgQynF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773738025; a=rsa-sha256;
	cv=none;
	b=Q6exgSsjuwt91o8vap5i1lI7RgXy5sGgkIr0UgWyp+KIt7x5rNjn2ljyN5kHHSVM+Re1vV
	0XH59rIV7qxwunyEkc0cXmlk1kh5uCq20shvUqCIrPjajzWjzjpRclQpjUehetAuQXmz6J
	oPB5ILxWee2xYoQepshfALDITJtzLR4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hYiihZtc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773738024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LfW4PQO+j4EnEpboaPKhMu3WfMztmYGSmgtjCkFC7Vk=;
	b=hYiihZtcBS1RX4NgTdC0Oj24bMkpg5zdn8Tc/pYEBaWMyw49tAyXNkBTOBtABdycGyAuZ4
	Y7o6zaGHX7DUpFG6uhrcIwHaTVQWMRvRgVx+HeB3I6pwF0he85JsrZLT8YiPOaGg6FJlF1
	ovC3osVrdsgMQgKFDXzo5y1/FlRMrCs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-x904NKE3O2OvpD80PB_H_g-1; Tue,
 17 Mar 2026 05:00:21 -0400
X-MC-Unique: x904NKE3O2OvpD80PB_H_g-1
X-Mimecast-MFC-AGG-ID: x904NKE3O2OvpD80PB_H_g_1773738018
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30E0C18005B3;
	Tue, 17 Mar 2026 09:00:17 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E6D41800576;
	Tue, 17 Mar 2026 09:00:07 +0000 (UTC)
Date: Tue, 17 Mar 2026 17:00:03 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v2 3/5] selftests/mm: move write_file helper to vm_util
Message-ID: <abkYE-tUzy6cz_kH@gmail.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-4-chuhu@redhat.com>
 <abekn9aBMw1e1Rw1@kernel.org>
MIME-Version: 1.0
In-Reply-To: <abekn9aBMw1e1Rw1@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: HZJB-n1TXYlcCYG8nDuyQ5L-7ed2PXKrmfYTf767Uiw_1773738018
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A74F180013
X-Stat-Signature: 4a3qw1wkmzwn1hi7p497hrzd43htng65
X-Rspam-User: 
X-HE-Tag: 1773738025-975981
X-HE-Meta: U2FsdGVkX1/4X7Qlm2mXv21oEyO0eksnmroh00a1Yu1AF7Ae4EgKiZYPBokldb8XHqxj68RZJf63Q//HP91yeQ8AjCnErPJSF1u7CczjSwcH7FJqcmJmFIF517sPanY/ms959V9HaTjt4VHFwSwoAIa3AIw18cAzUX0pDpkj+9OT7mJzsOjiOjk+er5o+1yvmGSutQpmdGojPath+yxUAJAQQaict2NxD/73y1SjHdyMmUaGNMRxUa7b5xN8TZmgHSPFZ7n6lpfnErYgu4fRZGbVky63zWy7ewDe+3PnIzO1/Er7YHqRPKEaIWSC8fQnfhSqG/2m8aFeQOOQZVLmxfSo7pO2MmWayccDn5zECy/vKFW+qBynBb3tujRsdjrTa7xqRGg7HT273wWisGb23bhh8YOKJqF244p56NI3A/BMGvu8oemRCppAQro2YUWwO3PHa69qBkM6YsO+QD5D0ToI9CuEgdc4aEe3CqySl8F7zc6RLE1rwwLc+vJNnfA3VlBnT6366NIXEz20KUPRjPXIY3eS8gdTVaxyXT45XX5raIyT6+sZKYrk7AcnPmEuKuBVwwUEQtjkOZnXnYBOGjcovV2zcJ79TcEc+1VEr+Im1rUlMlAxgkfnr6ijTzyKDuyIrjaTuclkgBuWx6pN/xnqETn/2RXcaerQpqPeLeqfi23nRVP4RRud7BOP6aI5ewBsR72SgdAenDiqAc103hQVqn1CU1sgDVPFa0vc1XmEy2xH1Iuk3dftCh8Z4k218Kku/A4UtzRX42Ugwz7osLtqL3vQQwuShz5CD4PDjTFoKxH1woRBjQTWjs3Wjl4/13CjUftXS4XlBncmYv0VZAIn0uhJqfg7osTc/2HhjB+0hEQeTyadyHm/thIaLxWkjA9FTx7JNj7+Or0QqpXvlYnq6jw78aeCYxPLSh4i9VcjTIBIAJJujlACx0p8b2e/NGjAySApxhSUClz4LSD
 T2bDvwZ8
 bwSCzsRy5tCcgGWgi1HTjutlLK3C3/U2wT6SZyiZ4x5X76iUnQj5tGjz7pCBoQ/ys4NRsmb+WEXMpPN04bYxzmxfaprqUWh45sLPeLB06U6d2YqHOXqUTHyBdyKAIBhdnDdZnzHC3L9yI0LbiXvuA8eO2ayBYdJM6PgiQ7AlU9kPLXs9ZDyyUc7KytBcoklo56kbkKdpX+1CjGvRYK8XkE3M3YbWJL63PePl2tXatyCW0YbN2rq4hQFHSW+6KfjzHrdPHCHhZmmir2KiZyrEMfngTEdx1ASm4LqtZ0pB+k21OiwviBT4T8UXK2GzlN+5enlTaau/96hoSGASFyvrrQ4vFddXtNkMZ9LCoMLVpx3aAHbg2aX1U3k8Wvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 08:35:11AM +0200, Mike Rapoport wrote:
> On Mon, Mar 16, 2026 at 12:43:33PM +0800, Chunyu Hu wrote:
> > thp_settings provides write_file() helper for safely writing to a file and
> > exit when write failure happens. It's a very low level helper and many sub
> > tests need such a helper, not only thp tests.
> > 
> > split_huge_page_test also defines a write_file locally. The two have minior
> > differences in return type and used exit api. And there would be conflicts
> > if split_huge_page_test wanted to include thp_settings.h because of
> > different prototype, making it less convenient.
> > 
> > It's possisble to merge the two, although some tests don't use the
> > kselftest infrastrucutre for testing. It would also work when using the
> > ksft_exit_msg() to exit in my test, as the counters are all zero. Output
> > will be like:
> > 
> >   TAP version 13
> >   1..62
> >   Bail out! /proc/sys/vm/drop_caches1 open failed: No such file or directory
> >   # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > So here just leave one version of write_file, and move it into the vm_util.
> > This make it easy to maitain and user could just include one vm_util.h when
> > then don't need thp setting helpers. Keep the prototype of returning the
> > written bytes num.
> > 
> > Suggested-by: Mike Rapoport <rppt@kernel.org>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> > Changes in v2:
> >   new patch from v2
> > ---
> >  .../selftests/mm/split_huge_page_test.c       | 15 ------------
> >  tools/testing/selftests/mm/thp_settings.c     | 24 +------------------
> >  tools/testing/selftests/mm/thp_settings.h     |  1 -
> >  tools/testing/selftests/mm/vm_util.c          | 16 +++++++++++++
> >  tools/testing/selftests/mm/vm_util.h          |  2 ++
> >  5 files changed, 19 insertions(+), 39 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index e0167111bdd1..93f205327b84 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -255,21 +255,6 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
> >  	return status;
> >  }
> >  
> > -static void write_file(const char *path, const char *buf, size_t buflen)
> > -{
> > -	int fd;
> > -	ssize_t numwritten;
> > -
> > -	fd = open(path, O_WRONLY);
> > -	if (fd == -1)
> > -		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> > -
> > -	numwritten = write(fd, buf, buflen - 1);
> > -	close(fd);
> > -	if (numwritten < 1)
> > -		ksft_exit_fail_msg("Write failed\n");
> > -}
> > -
> >  static void write_debugfs(const char *fmt, ...)
> >  {
> >  	char input[INPUT_MAX];
> > diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
> > index 574bd0f8ae48..02de28ecf31a 100644
> > --- a/tools/testing/selftests/mm/thp_settings.c
> > +++ b/tools/testing/selftests/mm/thp_settings.c
> > @@ -6,6 +6,7 @@
> >  #include <string.h>
> >  #include <unistd.h>
> >  
> > +#include "vm_util.h"
> >  #include "thp_settings.h"
> >  
> >  #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
> > @@ -64,29 +65,6 @@ int read_file(const char *path, char *buf, size_t buflen)
> >  	return (unsigned int) numread;
> >  }
> >  
> > -int write_file(const char *path, const char *buf, size_t buflen)
> > -{
> > -	int fd;
> > -	ssize_t numwritten;
> > -
> > -	fd = open(path, O_WRONLY);
> > -	if (fd == -1) {
> > -		printf("open(%s)\n", path);
> > -		exit(EXIT_FAILURE);
> > -		return 0;
> > -	}
> > -
> > -	numwritten = write(fd, buf, buflen - 1);
> > -	close(fd);
> > -	if (numwritten < 1) {
> > -		printf("write(%s)\n", buf);
> > -		exit(EXIT_FAILURE);
> > -		return 0;
> > -	}
> > -
> > -	return (unsigned int) numwritten;
> > -}
> > -
> >  unsigned long read_num(const char *path)
> >  {
> >  	char buf[21];
> > diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
> > index 76eeb712e5f1..7748a9009191 100644
> > --- a/tools/testing/selftests/mm/thp_settings.h
> > +++ b/tools/testing/selftests/mm/thp_settings.h
> > @@ -63,7 +63,6 @@ struct thp_settings {
> >  };
> >  
> >  int read_file(const char *path, char *buf, size_t buflen);
> > -int write_file(const char *path, const char *buf, size_t buflen);
> >  unsigned long read_num(const char *path);
> >  void write_num(const char *path, unsigned long num);
> >  
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index a6d4ff7dfdc0..b4b3b48f8dc9 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -764,3 +764,19 @@ int unpoison_memory(unsigned long pfn)
> >  
> >  	return ret > 0 ? 0 : -errno;
> >  }
> > +
> > +unsigned int write_file(const char *path, const char *buf, size_t buflen)
> > +{
> > +	int fd;
> > +	ssize_t numwritten;
> > +
> > +	fd = open(path, O_WRONLY);
> > +	if (fd == -1)
> > +		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> > +
> > +	numwritten = write(fd, buf, buflen - 1);
> > +	close(fd);
> > +	if (numwritten < 1)
> > +		ksft_exit_fail_msg("Write failed\n");
> > +	return (unsigned int) numwritten;
> 
> If we exit on any failure, the function can be void just like in
> split_huge_page_test.c. This will also simplify write_num() and read_num()
> in thp_settigns.c

Good point. I will change it to void. I wont touch read_file() here.

> 
> > +}
> > diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > index e9c4e24769c1..22c8805e0d7a 100644
> > --- a/tools/testing/selftests/mm/vm_util.h
> > +++ b/tools/testing/selftests/mm/vm_util.h
> > @@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
> >  
> >  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
> >  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
> > +
> > +unsigned int write_file(const char *path, const char *buf, size_t buflen);
> > -- 
> > 2.53.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 


