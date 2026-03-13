Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14370106FD68
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 02:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413386B0005; Thu, 12 Mar 2026 22:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C49A6B0088; Thu, 12 Mar 2026 22:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299156B0089; Thu, 12 Mar 2026 22:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17F646B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:30:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DDD81606B0
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:30:08 +0000 (UTC)
X-FDA: 84539460096.15.9CA7B44
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD564C0003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:30:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E+VMS0sC;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773369006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQNvXZ3ufJq5Ptz1GhUExxZdPT0/nf/hyFjgiErUnuA=;
	b=YUZsvHXQI5o9dTPMRvAvJwOuzOB6fjalTwrAjUc1QxOXDQlq934dV5H8QpcNO5RGKsLJW4
	oX96yag+YsiPPtcCV2HPzwVb4Bl2aw646L8JgrKoxIZjfgYyE9++Y1vDpUocJf+VbrXfWM
	fbMTBx/mURilJfjP5VKmLtsIJdv14Sg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E+VMS0sC;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773369006; a=rsa-sha256;
	cv=none;
	b=glRdVc8x7TbnK7wuKjHLjonK3ujuBz8n9xOCJambgfIymVWje7e23abv286QDlH9ELOvWD
	5WYZkaLy58Q+JMDts07JuXYLCUrNOT3oduRROBsbvkzn2JZXtBgadwIezUPYfd3RoRf4N0
	j1xPtFNh8x3Oyfr+HhvC2HEqsvYdUWk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773369006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQNvXZ3ufJq5Ptz1GhUExxZdPT0/nf/hyFjgiErUnuA=;
	b=E+VMS0sCfzoMw2LAAdNyxu9ocqSWh95qXpJFPQP2jUgrFZ5JpKYjYBMw4rTb4trT2U+Ebn
	ex9WPBHfuQ3PrSQQ4hJVHtfz8rrb+ytRtkCs8b6h3Ee+YREFIKkRbGUkQLBdpRPa5Mdrdg
	n4GSRcogYvzxYG31LASx/hhwXVzrbgM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-NegBLtDyMRu4pL4U3DUivg-1; Thu,
 12 Mar 2026 22:30:04 -0400
X-MC-Unique: NegBLtDyMRu4pL4U3DUivg-1
X-Mimecast-MFC-AGG-ID: NegBLtDyMRu4pL4U3DUivg_1773369001
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE59C18005B3;
	Fri, 13 Mar 2026 02:30:00 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.171])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13038180075D;
	Fri, 13 Mar 2026 02:29:48 +0000 (UTC)
Date: Fri, 13 Mar 2026 10:29:42 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Message-ID: <abN2ljgOy80KiVNQ@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: ZtaUWUcYeE7FMI_cB6A5KfD6z9i_gHUedup-25vgPU8_1773369001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD564C0003
X-Stat-Signature: dby7w1brjx7k3f7muany6an5im1dc9uj
X-Rspam-User: 
X-HE-Tag: 1773369006-432830
X-HE-Meta: U2FsdGVkX18PLtDJ/7zCEtUKrz3ORn9qCzrz2q0mm2mqlNS/y87iy60S+UqhsrFrAD6qVuzfU/V5TJVh1Dcv9tdAB+jMAtt5oBuC7kpdkDdAnnmszKT0T1IFFT0ZyH+Q1yCCSgAR/PH9BRNe+wyuijB9JdqaEhPyaQBcQ28O9giAWQ0wMve3vp11Tcd1kEXo81267ItkGgjxhdwx6AX26Mcg1CA7u3qvO481nDWwyuw7tCW9FQ0cl0SoxzG7z4S+kTJ1/bvp6dexMVtL2zYKWbViTWsE11i/P36AcZ0p65XY1e5KegSLxdwbyaxRbcMeirRWNSMKa1rXgNMdrFynP46Yi+kaKNfFjcG7OPDZYbDnoVPGimnrt0oRq8RJkG2A3HvwxOLjyzOKzPApYRY1Fxu4z5ymagikI/DaojMf3RBCziHbZNe1hxuRJHxtzM3pdUKZgFePzAeoAVyIV1anX0YNbsaoHw+2ICKqjIGm+9o6vhQEk9bOEsk9g5xT0MxYptVwXgLEUuuceISAq9Z7M/ENeYHJGxd14exVTJ0224RHrOxyq6fxeq2pdlU0zF8vSW7Mmj7BcByVW6zn1w3QnaKhbs5qQd3CbXtPlMChB7GC0pTwa6fb7IKInhSMnYX7RufOkVMzpzIzRJOKsZ666iI3yOGgsd8z10wxriMAKpy4nr+dVRUmgY0EwMRsDT1nSCbg8zK7XBpnsPTaeoeKF/XPcs0hrh8rBAL9yCWppxw7oe5foNtOO4f2Zz/hSVT8ou1VHCHj4i+7cpGJMsDwv32RhLaKUfqi7tWGrFALz+v+qUN81z8Xm/+xT3VneCCW5wl+Pv4lqMjRAQW7bjTuU1I+JdxqE5AJD4Sbo2dKY+/jhChsyC4g4lpeRpBsDe7kV0ZStl3xdNuhD49FVien4Mi9aRA78wBDwru3JhFxiL+t/ap17tBqgJ+Ffazy8rHrVIr9uus2BpO6ehOOhmE
 4+/oGnf4
 X5VRc1SLqZKHL9Mi03+NiaR+JKqm35G788w6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 10:11:12AM -0400, Zi Yan wrote:
> On 12 Mar 2026, at 7:40, Chunyu Hu wrote:
> 
> > When thp is not enabled on some kernel config such as realtime kernel, the
> > test will report failure. Fix the false positive by skipping the test
> > directly when thp is not enabled.
> >
> > There's a naming conflict on write_file() function, both thp_settings.h and
> > split_huge_page_test.c define it. To make use of thp_is_enabled() helper in
> > the thp_settings.h, rename this local write_file to safe_write_file to
> > avoid the conflict. The reason to use 'safe_' is it does some error check.
> 
> Both write_file() do safe checks. Actually the code of both functions looks
> almost identical except that the thp_settings one does exit() instead of
> ksft_exit_fail_msg().

indeed.

> 
> Can you rename the split_huge_page_test’s write_file() to write_file_local()
> and add a comment above the function like
> /* add _local to avoid a function conflict with thp_settings.h */?

Good point. I'll add that in the v2.

> 
> With that, feel free to add:
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thank you for the rewview. Will add.

> 
> Thanks.
> 
> >
> > Tested with thp disabled kernel:
> > Before The fix:
> >   # --------------------------------------------------
> >   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
> >   # --------------------------------------------------
> >   # TAP version 13
> >   # Bail out! Reading PMD pagesize failed
> >   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> >   # [FAIL]
> >   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1
> >
> > After the fix:
> >   # --------------------------------------------------
> >   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
> >   # --------------------------------------------------
> >   # TAP version 13
> >   # 1..0 # SKIP Transparent Hugepages not available
> >   # [SKIP]
> >   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
> >
> > CC: Li Wang <liwang@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index e0167111bdd1..615b75ca62cc 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -21,6 +21,7 @@
> >  #include <time.h>
> >  #include "vm_util.h"
> >  #include "kselftest.h"
> > +#include "thp_settings.h"
> >
> >  uint64_t pagesize;
> >  unsigned int pageshift;
> > @@ -255,7 +256,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
> >  	return status;
> >  }
> >
> > -static void write_file(const char *path, const char *buf, size_t buflen)
> > +static void safe_write_file(const char *path, const char *buf, size_t buflen)
> >  {
> >  	int fd;
> >  	ssize_t numwritten;
> > @@ -283,7 +284,7 @@ static void write_debugfs(const char *fmt, ...)
> >  	if (ret >= INPUT_MAX)
> >  		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
> >
> > -	write_file(SPLIT_DEBUGFS, input, ret + 1);
> > +	safe_write_file(SPLIT_DEBUGFS, input, ret + 1);
> >  }
> >
> >  static char *allocate_zero_filled_hugepage(size_t len)
> > @@ -772,6 +773,10 @@ int main(int argc, char **argv)
> >  		ksft_finished();
> >  	}
> >
> > +	if (!thp_is_enabled()) {
> > +		ksft_exit_skip("Transparent Hugepages not available\n");
> > +	}
> > +
> >  	if (argc > 1)
> >  		optional_xfs_path = argv[1];
> >
> > -- 
> > 2.53.0
> 
> 
> Best Regards,
> Yan, Zi
> 


