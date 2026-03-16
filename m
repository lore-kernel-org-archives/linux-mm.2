Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE99BF3028B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 03:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0196B00AD; Sun, 15 Mar 2026 23:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E236B00AE; Sun, 15 Mar 2026 23:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90876B00AF; Sun, 15 Mar 2026 23:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5D2F6B00AD
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:47:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48F65BDF47
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:47:09 +0000 (UTC)
X-FDA: 84550540578.20.5C3A182
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44258100007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:47:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q6TeGEoX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773632827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0D2y5TFtNEN6pRRzkIZxioYtJ8GpAfJqrdPquInSuc=;
	b=pIwNnr+gQRMTyk1Wij6R4vZVTZlP4wOwbRQCONTkAQF/lVGfPeAnOl8yNGug9JvDrKSgQC
	WURzotr5RHZcKKHe7aSB0FnZOvqTwpu9FbBbJF4ARO0D+AXw5dZfmCbCoYNVw+sgkgsww3
	gg5u8xbxt2g965crj5c4coZh8kN3wI0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q6TeGEoX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773632827; a=rsa-sha256;
	cv=none;
	b=xJ5KwSYCGErMfpLVJ5jIkj91AhPsttKWzDx/dYbdVEV16L3IAJ0PFaKkUp6j9AsWXCMAuy
	qo6n3oi8gR93tWvKvltnLjs1+TgWfT9aBwxIJHx81+YYa3E0dCP1UuijiKUWqdgpqQ/OGU
	ePmxMv5SZPROTqYbAShKxMzcXhxHa9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773632826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0D2y5TFtNEN6pRRzkIZxioYtJ8GpAfJqrdPquInSuc=;
	b=Q6TeGEoXLb2I9QLDoucS7P6nnaRjGYJUOrDCGmR17bHJwjwH9gDNcZ841L5CU/LlLp5/wL
	yi+G1kcUZbvjXb4PbpSNbfoZpe34Wj/HnV/8j9Ti9ukJamQu4bl8kMPi13UCsrDNeANTO1
	LTr6ShNW1nBgSXoZpAabzuyaxwS55N8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-WJ8Ob1AsNZyCLRk2U-RtOw-1; Sun,
 15 Mar 2026 23:47:02 -0400
X-MC-Unique: WJ8Ob1AsNZyCLRk2U-RtOw-1
X-Mimecast-MFC-AGG-ID: WJ8Ob1AsNZyCLRk2U-RtOw_1773632819
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 056A11956048;
	Mon, 16 Mar 2026 03:46:59 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.28])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DC501955D87;
	Mon, 16 Mar 2026 03:46:47 +0000 (UTC)
Date: Mon, 16 Mar 2026 11:46:43 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, david@kernel.org,
	shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Message-ID: <abd9Iyg99E7AUtYq@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
 <abQqLQ_6QqVgzunL@kernel.org>
MIME-Version: 1.0
In-Reply-To: <abQqLQ_6QqVgzunL@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: IRsfT4y87h6Tdne7fghVvivAPrc-InZdCrl-XWPBcPg_1773632819
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44258100007
X-Stat-Signature: d9nhwfos86ho46auu97m9drceeu7d6up
X-Rspam-User: 
X-HE-Tag: 1773632827-480782
X-HE-Meta: U2FsdGVkX1/8I52zAQlsAOByk5G2z60oIz1Bc5uetiJZD6ueJB/xChXyhkx2je+ZckJ8zOml2Vcn+IQDBPiR7IEeRm782dhAPm2MdCcy4cnYqwaZ1eCOe1PPWvESxqT2g3KaeMnZbJyIl/mw8SDgGcm/y9hC9XJI06zMTQHTVWRYGlrZRnyme91pEy6BJTDERypNB/0tTF7+NVUCjyg6EKivE0TwBzccL1GjqokslIaGCiyppjMrnxXUID8eUTgOwzvuo3w9eCtpxmxhDLNq4Qg3Ie+2EueGgOdl3VObShHzRRU47uOFAP+mqk5mvekk+NP2u/R436vaCMnQc79uwYbnjU4GiaYHnY+PubGovgqYsUzAPDWsw3Udkyi0bUTq3tWY7/IUKjdRHIApqEiGNCtAYV5EsFm7n/JRUBa1CzeDo2AqJsmBXUkn2NCC2MADDiGB8c+7TOa1PAApKAJKIx74DhzNbX68ghRBebo1hGSdRg4GvLtV0s1+dcCt4FatzcUqXDEi7CbwAEU6qdhybRXrTRgCLzk/r7VIhwSoAtqO8X7gSpracgVl3m9/dXPJ3C8ycq5HoMAkJNJNvZu73/hks5DBwUJvUT9bgZ50Od0YuguBUvLYtMNC8atrOZq3FagnnSEhN8A+HLzqPtIM1XwU8+YwBMfdYv6XSrOv9ptMxidJdGBYmY/HugzhJvLxvsspitPg5YtTdpaTt5G0KM4ODahWiEVbW5Ji6c886UKnaI2H3sbPV1nmbQWvi3p7qNg7U6gXWrkv8gWQwCWR+4iW8Q61VupwNvmahw/WBKv02HhxRIhBPfGsJQ/RuXBzwAXdEK6clAO21dt/2BUCYM0CgRyC4TX0Z1m5AJ7V7qUZpf3uyNiisdIXvdGMQKWTOMw2jdfNzE2V1prWJtPthurokX1qdzplNVXU65F3Akf194mnT5RbrBuAvu6YmZaWIKr1ZZehVhkBLDPK/lE
 Oiq7YCYo
 IxpafVcskebYF8hvbUluDbKSR9VVUvVGqE6RrCeIUsr9x7Wty1EIPdAcJtWoDKLPeTeHzpHWS/BTmfVb9srkQ2jpoN6CSCXGVdbCBkBRrWWsssxattqW2a9caFrC841ary1ivKQnOJvhKeEBH0vVGFiMhIpulXxg1HL4tPJm9L/eqGbNNFNzhnR2eNgaSDXEs7IAg1sla+rc/Cp5HhoH7ymONU6VT3yAdYBYl/1u+LPF1yrzzvZfDByg8dm4hpCXozDsHDSnJsZ/GlfnFORp7+aEuHUFDPpbFCpaHp8/MatCIVb4cnrhF8pFV4uvlsI3gdtBPow6BtFWkGQI5lJVM81Le3TwIKE09TbJJ+8ou8EyRVSxNTesU+DbA1umnAwZcxPh5ADjxXS5wHTeM/jZcKSzjiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 05:15:57PM +0200, Mike Rapoport wrote:
> On Thu, Mar 12, 2026 at 10:11:12AM -0400, Zi Yan wrote:
> > On 12 Mar 2026, at 7:40, Chunyu Hu wrote:
> > 
> > > When thp is not enabled on some kernel config such as realtime kernel, the
> > > test will report failure. Fix the false positive by skipping the test
> > > directly when thp is not enabled.
> > >
> > > There's a naming conflict on write_file() function, both thp_settings.h and
> > > split_huge_page_test.c define it. To make use of thp_is_enabled() helper in
> > > the thp_settings.h, rename this local write_file to safe_write_file to
> > > avoid the conflict. The reason to use 'safe_' is it does some error check.
> > 
> > Both write_file() do safe checks. Actually the code of both functions looks
> > almost identical except that the thp_settings one does exit() instead of
> > ksft_exit_fail_msg().
> > 
> > Can you rename the split_huge_page_test’s write_file() to write_file_local()
> > and add a comment above the function like
> > /* add _local to avoid a function conflict with thp_settings.h */?
> 
> Looks like we can move the version that uses ksft_exit_fail_msg() to
> vm_util and drop the other one.

Good point. I'll try this in the v2. And I think we can keep return
value.

>  
> > With that, feel free to add:
> > 
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > 
> > Thanks.
> > 
> > >
> > > Tested with thp disabled kernel:
> > > Before The fix:
> > >   # --------------------------------------------------
> > >   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
> > >   # --------------------------------------------------
> > >   # TAP version 13
> > >   # Bail out! Reading PMD pagesize failed
> > >   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> > >   # [FAIL]
> > >   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1
> > >
> > > After the fix:
> > >   # --------------------------------------------------
> > >   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
> > >   # --------------------------------------------------
> > >   # TAP version 13
> > >   # 1..0 # SKIP Transparent Hugepages not available
> > >   # [SKIP]
> > >   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
> > >
> > > CC: Li Wang <liwang@redhat.com>
> > > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > > ---
> > >  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > > index e0167111bdd1..615b75ca62cc 100644
> > > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > > @@ -21,6 +21,7 @@
> > >  #include <time.h>
> > >  #include "vm_util.h"
> > >  #include "kselftest.h"
> > > +#include "thp_settings.h"
> > >
> > >  uint64_t pagesize;
> > >  unsigned int pageshift;
> > > @@ -255,7 +256,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
> > >  	return status;
> > >  }
> > >
> > > -static void write_file(const char *path, const char *buf, size_t buflen)
> > > +static void safe_write_file(const char *path, const char *buf, size_t buflen)
> > >  {
> > >  	int fd;
> > >  	ssize_t numwritten;
> > > @@ -283,7 +284,7 @@ static void write_debugfs(const char *fmt, ...)
> > >  	if (ret >= INPUT_MAX)
> > >  		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
> > >
> > > -	write_file(SPLIT_DEBUGFS, input, ret + 1);
> > > +	safe_write_file(SPLIT_DEBUGFS, input, ret + 1);
> > >  }
> > >
> > >  static char *allocate_zero_filled_hugepage(size_t len)
> > > @@ -772,6 +773,10 @@ int main(int argc, char **argv)
> > >  		ksft_finished();
> > >  	}
> > >
> > > +	if (!thp_is_enabled()) {
> > > +		ksft_exit_skip("Transparent Hugepages not available\n");
> > > +	}
> > > +
> > >  	if (argc > 1)
> > >  		optional_xfs_path = argv[1];
> > >
> > > -- 
> > > 2.53.0
> > 
> > 
> > Best Regards,
> > Yan, Zi
> 
> -- 
> Sincerely yours,
> Mike.
> 


