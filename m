Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A3CF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798B46B00A8; Mon, 23 Mar 2026 20:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7226E6B00AA; Mon, 23 Mar 2026 20:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E98F6B00AB; Mon, 23 Mar 2026 20:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5586B00A8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:23:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F005B8D3CC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:23:24 +0000 (UTC)
X-FDA: 84579057528.07.BA6E215
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 147B61C0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:23:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dcaq6Kwz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEN/hgRPrpeTdflpPR82SCQrcTa0brUyqsEDdo7uAbU=;
	b=Y00+SIUN6Bq5MCqOFYaLuUeAy26wQm/SfqyQy5Ft9Ss9s9fbX3KmrYHk3o33r0IfUxStHg
	gMbQDkbK8LWYahh5FsEO03sSzK0+cebrO5Lzr+wFoojmjpIULTmoW2hvjuiMqHcg1vmQdD
	EwzwC6URQspLTGAfrKV3qjbBLMbgT00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311803; a=rsa-sha256;
	cv=none;
	b=jqMf2V7IFKnKrgoORWqyIu4qREawxk/fuBYcrAdbdspaLKlIZOpyMl8hd90n7qKJl7XLce
	+Zz5Ftt+h0lD+AcASOwOZiCof6aYPo85F1A61H0N5QuHuRWiXlzCe3W9UyzipnyY1NJaaO
	T0mjBYA7KQQqjGVUdVtoo00Uw62bDpA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dcaq6Kwz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774311802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NEN/hgRPrpeTdflpPR82SCQrcTa0brUyqsEDdo7uAbU=;
	b=Dcaq6KwzJ8LlGt4q//eaHlS7mAk/AVfyg7+eTKXF2jOL8RKzW7aYqwYdQ3qWrip8DSV8Ht
	QMlVjRaeSe5kgMi3gOvar/875vWytznIh+yS9VqnIvxIKS7XyD7753vcPeoaoWPx3MtlKA
	KOD9IRMNTnhpfMBG//xfvTpRHPLexkU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-vstC6UL_MOuRp4ndn0wrMA-1; Mon,
 23 Mar 2026 20:23:18 -0400
X-MC-Unique: vstC6UL_MOuRp4ndn0wrMA-1
X-Mimecast-MFC-AGG-ID: vstC6UL_MOuRp4ndn0wrMA_1774311795
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 224B4195609E;
	Tue, 24 Mar 2026 00:23:15 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.53])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13DDF1800361;
	Tue, 24 Mar 2026 00:23:04 +0000 (UTC)
Date: Tue, 24 Mar 2026 08:23:00 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v5 3/6] selftests/mm: move write_file helper to vm_util
Message-ID: <acHZZMLl2IaBZmTx@gmail.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
 <20260323151753.2576137-4-chuhu@redhat.com>
 <b992bd2d-f811-407e-835f-30d9c9d707ad@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <b992bd2d-f811-407e-835f-30d9c9d707ad@lucifer.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: A2wAGOa6HG3v-IUEkPmbMcAcutSIwP5lzOkVhsxiVXE_1774311795
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 147B61C0005
X-Stat-Signature: 4655yuw7axr6s1owrfub91j7n9r8fzd4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774311802-237896
X-HE-Meta: U2FsdGVkX1/M+TXPZtbsNiKvuDvw8NXamjwwDTqPDWUdlXaBMCQZJdqwa+Exn5M0mm52UjXr8+Yn4KlI2yuCjHNoEvitiSusrK/ufOOQDq0UU+I2C0E3nYCtH644Uhvo/WE8KaBsFXPDd/10lWGgXP92D6Je6RPWk/1W4VNE/l2hV7yPRgyhciRCqo0xcP8mlrZYHBzLfmxLNALxBnpPaBs5vlkQDAhlARJpjkdZGUXaF+w1oWXDuqMW30a+GCrlfjiu0fRIIxmLIaTDrocRpiQs0KlfkKoyAi9Jb8Z/YgNEpwlWQMGDcT0hMQb5tb9Z2sSq7mQCY4x5AqJTPWYF86WomyJV2+Kvb1PgZpSKIskm8pL/F7FWasspDl51aJ0LvEJsrM0XnxiK6Ohm4z9JiFihBEBDrZyfuwNEiz83lw/HZSVx1e+B3W9tVxtU287P2p6r6boZfnVMzZXdvlHCcuIDcD7jXsn7r+RYUA1EYB4W4L4b7iew20KzoewLuB4DBNtjIalMhKodJvwZqrqjYvWpPUwfyXe9JOjzq9Fj1WU3cjlJKG6SSCuEvszcn6/9VeunMYjIfinPqZdnfyJ6j+9KjLyD6rXOJgfAo7eH7hr/m8FGnD6H1Ew/FrrUu9wqK2LUPkmw6stXGKKD6gr0Uzmq4AI/UXkAKBQs2PIUbKeHU4O6RAi8dNo7wIdjY2Pbe2r4wJxwFbwIveETEeUZyr72EjB98U92MdT1XednyMk/ALVLgfJjDO4brc0oAdbn4/83Jg37w+aSupdb9ZNkayzMd8xHqrRaNg9dtvBJbLwFq9zgWM3zoz7xtAUuk9VUDjmLUoh4TKqGrg+KzagozxW4EJ7EX0XDSN25H7prrRU7T5A9vng1xvbJt/OyD5ngB8ZjTqH4OaDnNJaS5hiwrlINscPYYcoJpBEINL6NmcJiJ44pSHAG6+Uvil731/iKSDdRKjG3vxajqzxjZ78
 YirRPSv+
 fr3kMFrbsqLHA6Msr4dgddVZCrrw43ehFQMLSs/dayDpu5j38lRIPqMHm+Oploswbe4iwqfeLlDDtDVlYmEboV9cB/LyBoC9gKsaJawQr+o2nCLgjZGLgB23Zp0EuAuAwqWiijynNFtlS3Gry1Dy7JcmWf7Lpz/F/MI2i8nyJTSmF+PMlIYis/sf4NkCL+qGzung9VSZ5mBYeaBosQEKRrhIUMDkE3d37zb/In/8PSxco2SRDAclkJ951PK9KKcP4uTFQKtgAQY65z/zAjoNKYdqGjzBp+LPzY+J+vivoKDjYZhOQPZlZxBFlfsq4bqVFK69nGevuT7opPgapo8OWF4RO0R9FCaGhYtml4k22tUfUmFjxfMRKL83n5RjOJ59D2skDMBEBKlgQc86s1L0DSAXuWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 03:48:58PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 23, 2026 at 11:17:50PM +0800, Chunyu Hu wrote:
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
> > So here we just keep the version in split_huge_page_test, and move it into
> > the vm_util. This makes it easy to maitain and user could just include one
> > vm_util.h when they don't need thp setting helpers. Keep the prototype of
> > void return as the function will exit on any error, return value is not
> > necessary, and will simply the callers like write_num() and write_string().
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Suggested-by: Mike Rapoport <rppt@kernel.org>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> 
> I already reviewed this :) but easy to accidentally forget to propagate
> tags. Anyway, as before:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Sorry I forgot adding your review in my last version. I'll add in v6. Thanks
for your review!

> 
> Cheers, Lorenzo
> 
> > ---
> > Changes in v5:
> >   - updated acked-by and reviewed-by
> > Changes in v3:
> >   - make the write_file void return
> > Changes in v2:
> >   new patch from v2
> > ---
> >  .../selftests/mm/split_huge_page_test.c       | 15 --------
> >  tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
> >  tools/testing/selftests/mm/thp_settings.h     |  1 -
> >  tools/testing/selftests/mm/vm_util.c          | 15 ++++++++
> >  tools/testing/selftests/mm/vm_util.h          |  2 ++
> >  5 files changed, 20 insertions(+), 48 deletions(-)
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
> > index 574bd0f8ae48..e748ebfb3d4e 100644
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
> > @@ -104,10 +82,7 @@ void write_num(const char *path, unsigned long num)
> >  	char buf[21];
> >
> >  	sprintf(buf, "%ld", num);
> > -	if (!write_file(path, buf, strlen(buf) + 1)) {
> > -		perror(path);
> > -		exit(EXIT_FAILURE);
> > -	}
> > +	write_file(path, buf, strlen(buf) + 1);
> >  }
> >
> >  int thp_read_string(const char *name, const char * const strings[])
> > @@ -165,11 +140,7 @@ void thp_write_string(const char *name, const char *val)
> >  		printf("%s: Pathname is too long\n", __func__);
> >  		exit(EXIT_FAILURE);
> >  	}
> > -
> > -	if (!write_file(path, val, strlen(val) + 1)) {
> > -		perror(path);
> > -		exit(EXIT_FAILURE);
> > -	}
> > +	write_file(path, val, strlen(val) + 1);
> >  }
> >
> >  unsigned long thp_read_num(const char *name)
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
> > index a6d4ff7dfdc0..ad96d19d1b85 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -764,3 +764,18 @@ int unpoison_memory(unsigned long pfn)
> >
> >  	return ret > 0 ? 0 : -errno;
> >  }
> > +
> > +void write_file(const char *path, const char *buf, size_t buflen)
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
> > +}
> > diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > index e9c4e24769c1..1a07305ceff4 100644
> > --- a/tools/testing/selftests/mm/vm_util.h
> > +++ b/tools/testing/selftests/mm/vm_util.h
> > @@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
> >
> >  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
> >  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
> > +
> > +void write_file(const char *path, const char *buf, size_t buflen);
> > --
> > 2.53.0
> >
> 


