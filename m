Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6DFC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4AA6B0092; Tue, 15 Sep 2026 04:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775F46B0095; Tue, 15 Sep 2026 04:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2C36B0096; Tue, 15 Sep 2026 04:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4286E6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:21:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D70B160346
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:21:07 +0000 (UTC)
X-FDA: 85215301374.28.DCD64D0
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	by imf12.hostedemail.com (Postfix) with ESMTP id AC39C40004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:21:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=B67SJOyv;
	spf=none (imf12.hostedemail.com: domain of zhenghui.hao@qq.com has no SPF policy when checking 203.205.221.221) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789460465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kghpB7ZhQGmJpX7jlJk8goCj8FvBODEx2R402a5MjFA=;
	b=L2jrJ0xEgY0crKasyWx0ve3n/tUsdJe/ulSB6ZsNftzkNOK5G4Dmo27k9vkhqTZJDEjaoX
	BHUB2KxEy8u55dkY+iMgCY2qgilIOYenqJsqp/ihxWc169ofoI7HkGPBRvWLxwRsQH6MN8
	Dkd1sHjPGekd+tGkSAr8awiJne8r/oA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=B67SJOyv;
	spf=none (imf12.hostedemail.com: domain of zhenghui.hao@qq.com has no SPF policy when checking 203.205.221.221) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789460465;
	b=Qu55583LesjXIlo74hWxGa9PGal1pYsggyab3hLvHaeM/vzH0Hd4hUSujUQi+ZsjJzhj4q
	HR18XX00hCY8KdZ9DrorSGHdehX5l1LxFfAv4+uL3VfQ1IrKDsRl9al0Lyah2ICmfW4ZmK
	ppqVNSI2cJ6Ig9qYCe+o58KaWywXz9s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789460460; bh=kghpB7ZhQGmJpX7jlJk8goCj8FvBODEx2R402a5MjFA=;
	h=From:To:Cc:Subject:Date;
	b=B67SJOyvNBIlhbB9duf6n++ztK1spw44a8+/cuOUUJHb/J6+9m7ew8TCqWBsHFCZr
	 Hsz+0z9CaDMt/FzMDp1mu3l4DdsO/QiW8Rt9+Ysc0YWE4JUu8Q9Jzi2tuF0XYJaF4+
	 rk/9GwMBiKQzfK87jL//z0UXdyiiKLIqGg+QGSpo=
Received: from XJSH01426.meizu.com ([210.13.72.171])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 53A1DE2E; Tue, 15 Sep 2026 16:20:58 +0800
X-QQ-mid: xmsmtpt1789460458t5126i1fs
Message-ID: <tencent_034C6FC23D4817C40657E5F17F64E260A009@qq.com>
X-QQ-XMAILINFO: OIkr59++0f4Qwdb1R8aaTM4CMnXSO09OXLLfl94a8ORKkoX/XuVweVBECR2FHc
	 wh5UawVPgSnceDR1fyBoJR6ZsgjM0VKZXyNluXAa9ak+/hP+nJl7fN9FPppGgRKhJfwwuANuTK7/
	 n/hkMEDcdWP1O6qi5uiLNWOesjiphyBUzxdC6iDmzszt3hKeQQppiaz5Z7HsZe1jg2tYig/JBB8x
	 Iq7DINVJOaXtcLzAglZfPD8RjyXK3gxY/TBb8j1EqpeLq1iNDTjMUuy10+DeE7h1h86dJjyfsDJj
	 HcKWhPXMnfRrju1iA87It6/nekkah0jdMWk60065ZYM2/YNCahjXtpDTBV6QgIxawsuEzTnGx85p
	 cdwHx5emRHOT5xwa4PTgW0u/pL47B2O2wQfHTOmFyiNn+kqD3EiHBqpx3DAt3stOvdRCZGby63Vg
	 g2/+XYLhnlbf7JOFq9fegDbIfdDKVumxsetFfmmZwfTB/ROENp4ty3gHFXr/MTyfeTyDZ7AA97PK
	 dZIgyBFyxhwr4sjws3nKLvCLIlY7aMEEsZDbV+WVPUOqRwpik5xOxbV0WcPO8HKNOTHFre4CsCje
	 DfKuGFmDBoWeAAnfGElfz5s3BK9G7fpVlpJCHna7dRUfnrdRwnIqffb+PhFQFSmqh4VCDNeZsvVV
	 4v6U8wi56AlcwbKRYJnZYiq5YsivHHFgqY4a6RA5/Yl1pjRS1hsLJL3DdrU/VRTfxHwMTE5aCmY5
	 zdGQm8qDKX1EJ9O3ATLKN8MEXEJYs4pwGIYzZP+MXf9d9ZM7xqADqI4zcAztJN5eIpkzvIUTT7s9
	 wAdAr7M2fhzPYBtEJSSD1TnpLqPuMTJRlQ7sKXVdNPEQcSqJUW4dzXjhBlEvAweg+OfkPr1s3PrR
	 3OqO2GyTZfL/z+fXjpE9Hoav5kn8olPXvHccmkWmkCqU+YM1B/dtq5paJENONkDSXic9Df20kAKq
	 yjdZGoke0d5dlSNCjhDpmRzaery/QrdOvjMNkPsmYTX8AMfCrl6WPwembe45GRlxVlOP04EyZCIe
	 fY6wQN+hjpL7qkGQYP1csXFPusle63in61Q7FpX8i8Yf/K9ShNbJF0JZag13qheDNM2FyOSGe6Nz
	 Po33Iy7SwzUaYZv9dQS7Amk+j10X7Nkas94vCDm/APhTlV8ke4vGtDgJysT51CH5jzj1o3Ag+bLt
	 U/dLo=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Zhenghui Hao <zhenghui.hao@qq.com>
To: linux-mm@kvack.org
Cc: Zhenghui Hao <zhenghui.hao@qq.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/hugetlb: fix misspelled parameter names in comment
Date: Tue, 15 Sep 2026 16:20:29 +0800
X-OQ-MSGID: <20260915082029.65309-1-zhenghui.hao@qq.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC39C40004
X-Stat-Signature: 8n8gor3euq9agujbhx4kzn1wepo5oraa
X-Rspam-User: 
X-HE-Tag: 1789460464-428568
X-HE-Meta: U2FsdGVkX1/mXJohsqC0O/xMVPvbdIT8Sb4lUchzZ41sfr1bznmtzIvrNjczwn+S095axuGknzV1FzdIv0C7Rer8XRJgekKGFFXh3608fR7fLY4G6k0bJLpcBvqLXYMkHlC9r4aqG/exfom/mLFtu7aj353R3m73aILVNrVccP1zfpaPrec6O3gjZkZMb/lHuBJs0i6yucyD+ar2euF/cELcwF8OaIDffFgMr/J65sVxusJl7WK6sOfGhHPuDGU0zPKk60p3rNg2zCQJWUv3MLNma/QL6o5Pv8jAQ/R3EH5A+kANX7UJv9CpX4qWqns1f5fMilDinZXDOLoohmRcIj4wicK6Wz7/nrkNuztl7XWpP1CTXSQWLLRgmJRvH/+zoI2mx2ghOcFIZ3iPx8zbQyH3TUPLWhjhXeShMC4mPliyuDO/hp6LIsTbiELUKqPNqV/vBBXv+PxLjlGyPuucBvB1HbX7hPR7/t/vRvu0a4gEIsgBHsnLBmX+q0D1OKJXw0xyJeplmDpyb/fKCoWoOb0cWbiRs0TMfM387DttqU836cS2azU6GzW8f42LsMRAPMOazgxhCFTCz+usrox1hxsqux6okh0pHymRfAuL+ccZdmEUV6boGhUIwGRw0zr7VzMzdTIRYtSuhlkoUb5qruTxoAO7rbyKhHzKZJcYIcdrZypjLizaANVxnRJBXWQuuNeoUjRz3NPpfAWNP7fztCgfXrFr8SI/oMGuKpG8+XFwmyBOFq2xagUqImX4sWX0bGVDIgmYUYGz8BrIXSaSm1hpS5wa0g8NOZru8RGBg46jIqtQb2tLOkp5oZzdGuOJyHtMuSrgUitUys2kgcp0Q37xmkjyfJqyii+IWEWHF5lcylexZrHPqAtrFEScD+MZEblLNLdjNyhKlpqUzlHITKQuVacQaQheTCvzlNBR1IgNyWwel7XSiXI9720/QE4OxjkVqeHVYeRSLXIj6O7
 Jy+vsErI
 mDXlzAJja65tbGfzTOW/xzCkUxnNAqt4aZ8aiPQqb/U0UsCgpOi6UGDnfMotplOWf8lWS7hswcW9MvQ+FL+Z7EvwQem3AZDM0Kq5kU2c+NFEMA1EckhrTT10ZQjYzgyPsn0HWs8kONBQMBpb9Cjf27HwLzwo4oFS2doSjOgr9+55KM7ZfxFPhvjNTqUXstXg8mE/qnYX/uFd1qxulsdhQaz0z10C1OKCazSSW7npsg6lgLg0R6Hb5y4Edeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment above hugepages_setup() refers to "hugepagsz" and
"default_hugepagsz", but the parameters parsed by this code are
"hugepagesz" and "default_hugepagesz".  Fix the spelling and also drop
the redundant spaces so the comment reads normally.

No functional change.

Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
---
 mm/hugetlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f6f58bf3db6..68b97893a376 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4268,9 +4268,9 @@ static __init void hugetlb_parse_params(void)
 
 /*
  * hugepages command line processing
- * hugepages normally follows a valid hugepagsz or default_hugepagsz
- * specification.  If not, ignore the hugepages value.  hugepages can also
- * be the first huge page command line  option in which case it implicitly
+ * hugepages normally follows a valid hugepagesz or default_hugepagesz
+ * specification. If not, ignore the hugepages value. hugepages can also
+ * be the first huge page command line option in which case it implicitly
  * specifies the number of huge pages for the default size.
  */
 static int __init hugepages_setup(char *s)
-- 
2.53.0


