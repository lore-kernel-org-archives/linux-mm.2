Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26942E67495
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 03:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2DB6B0005; Sat, 20 Dec 2025 22:25:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A2E6B0089; Sat, 20 Dec 2025 22:25:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BA06B008A; Sat, 20 Dec 2025 22:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 250426B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 22:25:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EF7213BA9C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:25:17 +0000 (UTC)
X-FDA: 84242037474.09.4764122
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id ADC34140003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:25:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WoPffjJ+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766287515; a=rsa-sha256;
	cv=none;
	b=oVokfzTB4SaoyehGKKOeUm8LskicWuflNbA9WLu7JHZKSZDOI40HBRhD0FjhduqGPgSqq1
	m9RO0Jx+g5dimt/y8dLnw8307+1uW4GU98dmwm+yvPLYlCiywWdkF9kbGCK0w+KkEKxuRH
	PQCT+o7bq/XSvWF4Eee6J4IHndERx4M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WoPffjJ+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766287515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpOhK118LaDWKm765ndboJZL+xQDVhQwHQhCepJJnh8=;
	b=RossQ8M7heFoSNCp9KMpAah++iZq6Qd4g9oudC/IHDN2/bpt3yet/B3GeIvx2WnnAhEjsu
	mkt57FbbAHepdpXmF6eVqgBxD7FPPna1cjXH4XItQNmG6CEoIQbJhL18TRdOmxe11CWBqT
	riLEE5ACNLB2tk0e6YjpKVSEf5VmCWs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766287515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HpOhK118LaDWKm765ndboJZL+xQDVhQwHQhCepJJnh8=;
	b=WoPffjJ+21shXlnj1u1H6teMjJPcGgxPbKDkZ0Xap1W4gPVibbIhT07QkRyvjRUxB1R2AU
	idufRUVppaJ9NauV7JscU6VAeUEuss/s2yntm2qsultAqngFHcXJZzuWPlWxzJq0bl5X6d
	YYcLFNsyJmDZQEXQTTB0SiTmXaOzeYI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-1PfFEtf5P3CDFsRYVvXxsw-1; Sat,
 20 Dec 2025 22:25:09 -0500
X-MC-Unique: 1PfFEtf5P3CDFsRYVvXxsw-1
X-Mimecast-MFC-AGG-ID: 1PfFEtf5P3CDFsRYVvXxsw_1766287507
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C216180035A;
	Sun, 21 Dec 2025 03:25:07 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B09311955F1A;
	Sun, 21 Dec 2025 03:24:59 +0000 (UTC)
Date: Sun, 21 Dec 2025 11:24:52 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v1 1/3] selftests/mm: fix va_high_addr_switch.sh return
 value
Message-ID: <aUdohHjAfaYmjH3a@gmail.com>
References: <20251207122239.3228920-1-chuhu@redhat.com>
 <f8d1e504-2009-4bd6-b1b7-c98c1f49374a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d1e504-2009-4bd6-b1b7-c98c1f49374a@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADC34140003
X-Stat-Signature: fhkjdb3eei73ncxaobcmwcxm4arsr3q3
X-HE-Tag: 1766287515-876283
X-HE-Meta: U2FsdGVkX198qdTtkU4eePlPNyneGZVLZPR4jbwQOQCgZ18Yx2co2QcxOy3ScWL6oA96dCtv1UM+guWinhweMLsZ+YLziGeNn8R79LDsXA2G64dIra3o3bLziLt13BDR8e8/4H0+HuB2YujFcP+AhqSLVG42h67hUOGHuJfpBrp/f+68OI5pMGhEI2zrV8dxwxFbXiov59OGfisPAR1Pk3rx1JiWXZbpBKM8nXLZw1YPoF4V9zfwxEzC2Qh1e4I/ZxiL8TwrZ6BiwhBxdNxrKrES0u+8U5ZYxzNsT279vJgMNT78653oGX/1S4LsWrnBZdwuRVYQ6CLmulINKtNOZGQTeOJA863g84eZq0AzcFLCavlYUnRbBvRRNVuGmgJ9/N+DdONVYOxm6LR/veHqS5xxYmuMWFOilBls2nHpATeMgk1bvOkQwKjT4WivwQRtNKXZK5ORVthbpXABSWIfUWsnIlyqNkdbwQbgNrHjg1iaPPTDRBWw9gCIolRiMZjxKoF3jkfuDRHuswQtywcuWtYacAXDASDTXaHe3j1UouZgBEsIt0IcYRH6sfc6GUcAQeFuX4M42WLMxGCWE5rXrpaa0IPqAEHtPs5D2oemAnUupgShvXtD1W/ITYFDZgL4ylHncJxq5aisnSkGvNQhMCBPC0xBkQkQ60m7vfKcTJkAnt0bwpxWc6TlnCv+aWcn6m/k7AyjUv4fCP9bcOTnphT75FfO1qiJ2er2DNM+r2HsLcORFYidFLDmL03XOAq/D7ISJoi2DAAOCTbrLrV4uDul8nN+ClS/tNrfbOmEQaqym8/t7Bk8Xll49V8ge0mEUMNA/h9xuaPjQzV/tcr4oomhyRluFoZkVtjZjI9aCVIHJkGEfq4X65mnhoW82vDSdEu4hXaVmW1EiLWR4Jr+y6neoLyiyzwkXiWM4snXnxqgC53kD/CClY260dHWzrqQy2QxPntz5nt9as69nZl
 WXOUt/Xf
 11a/03TUy3/m3zF8CcJYB9h6s02KMxo3EAzGa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 10:44:45AM -0500, Luiz Capitulino wrote:
> On 2025-12-07 07:22, Chunyu Hu wrote:
> > Patch series "Fix va_high_addr_switch.sh test failure - again", v1.
> > 
> > There are two issues exist for the  va_high_addr_switch test. One issue is
> > the test return value is ignored in va_high_addr_switch.sh. The second is
> > the va_high_addr_switch requires 6 hugepages but it requires 5.
> > 
> > Besides that, the nr_hugepages setup in run_vmtests.sh for arm64 can be
> > done in va_high_addr_switch.sh too.
> > 
> > This patch: (of 3)
> > 
> > The return value should be return value of va_high_addr_switch, otherwise
> > a test failure would be silently ignored.
> > 
> > Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> > CC: Luiz Capitulino <luizcap@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> 
> This fix is good, but there are two additional issues that need fixing
> (maybe in separate patches):
> 
> 1. In main() we do:
> 
> """
>         ret = run_test(testcases, sz_testcases);
>         if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
>                 ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> """
> 
> The second run_test() overwrites the return code of the first one, so if
> the first fails and the second one succeeds, the test will report
> success.

Good catch. I can add a fix for this in v2.

> 
> 2. The following comment in va_high_addr_switch.sh is wrong in two
> counts: there's an eligibility check for powerpc64 and the test doesn't
> reject other architectures as it runs on arm64 as well.
> 
> """
>     # The test supports x86_64 and powerpc64. We currently have no useful
>     # eligibility check for powerpc64, and the test itself will reject other
>     # architectures.
> """

I can update the comment in v2.

> 
> For this fix:
> 
> Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
> 
> > ---
> >   tools/testing/selftests/mm/va_high_addr_switch.sh | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> > index a7d4b02b21dd..f89fe078a8e6 100755
> > --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> > +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> > @@ -114,4 +114,6 @@ save_nr_hugepages
> >   # 4 keep_mapped pages, and one for tmp usage
> >   setup_nr_hugepages 5
> >   ./va_high_addr_switch --run-hugetlb
> > +retcode=$?
> >   restore_nr_hugepages
> > +exit $retcode
> 
> 
> 
> 
> 
> 
> 
> 
> 


