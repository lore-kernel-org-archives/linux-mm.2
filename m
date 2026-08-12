Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17516C5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81606B0095; Tue, 11 Aug 2026 22:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31F46B0096; Tue, 11 Aug 2026 22:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D489B6B0098; Tue, 11 Aug 2026 22:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A84916B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:06:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ACE2C02CB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:06:15 +0000 (UTC)
X-FDA: 85090977510.08.6A14500
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 76D80180005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:06:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ytMh5R8R;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786500373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuelHEjJwc9WOENkCsuVs9GnBflpggl6MKv0gvmcy5Y=;
	b=B3WmuekLLvXwd/nlOEDP7nTeYlFYGV45WrRhLX+o8iXoBSjbi04nmdh1RsOrIgcFj/DGjX
	g2Nv3Fd5vsM2emph2cfrvesux+gNmgtIhG9y0hz3dySnulXEKAJdjzapu8utBK5HIZkrgG
	WPFpxlRRBjBSgJtSb/k851vyMDbaLPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786500373;
	b=Kta4cHZKavPHCnePTMUMvQCnW9RRJikmxVGjmlsSdrqwFdCtULRyxN7RikiweR5q3y9DmY
	KyvGZ6hKalphfypV+4Nm30MJv7A6OKDoXyFe/N4mQWpnzvi76nssgdK9Y7JhX82mV0ZL1b
	Wa+xOvnuSJWoV8jsinYMxa0PTnvsiuk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ytMh5R8R;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D13EC600AE;
	Wed, 12 Aug 2026 02:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259911F000E9;
	Wed, 12 Aug 2026 02:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786500372;
	bh=EuelHEjJwc9WOENkCsuVs9GnBflpggl6MKv0gvmcy5Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ytMh5R8RKS0Eyyxbln39Zr/MQTyJI1Sn1ybd78YJEJiwHH+BeU+ppp/q0pg5Yme2s
	 8HCjorE6Fg7DBQTsA2VjYhRAABfx3LnbJL4L8yGz2geb4s4N+gd2IPyeRDoJoSqDEn
	 UlpMNuRaqIKiRl6Zv3XBSZ3vLQggw1ku8tnxovdk=
Date: Tue, 11 Aug 2026 19:06:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>, Anshuman
 Khandual <anshuman.khandual@arm.com>, Tejun Heo <tj@kernel.org>,
 =?ISO-8859-1?Q?"Michal_Koutn=FD"?= <mkoutny@suse.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip
 test_no_kmem_bypass if debugfs is unavailable
Message-Id: <20260811190611.c72f19ada3912791a81a7a90@linux-foundation.org>
In-Reply-To: <20260811051434.3805648-1-wfelipe@google.com>
References: <20260811051434.3805648-1-wfelipe@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ahe78qf78citfqz5xzghkgewji8mc9iu
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76D80180005
X-HE-Tag: 1786500373-898278
X-HE-Meta: U2FsdGVkX18266zgrdJNyP9kxj38InXuSICCotVwTp1XQO6HezEKXq0vbNo3IHyZCUOLE+KQbyQdtj+x748Z6TWo+niZFjhABTBZhMvPJI5oSjXH8uOxIH1hgmnenodHuM60gOGcktfvUh3LzJgaE8bS9Oe3eX3SMpzyk0I9J0yOf25JGU02oSc3ZCm4lAaWsWNFJI5xqN5ow3w2tCms5ysJSb0KugBLGp1Ze73uhMJIzP+x+eftWscKjj3cyFC2fTLWCvNSsncnPipioK3BLsFiOIODnyZP5zUpZ4Z3j8R+yfVTXI/oOhujAzedEMaS6bDrmDpox+i25q4BCGqnkgTzvTN6MHDtO8Tj21TZFuN/NBBxaIsWP6YxAVYupxxcd16fTcXOQS4sG2TxM4DCJOkXMo7BTfmHJPYPGf8Rosj4IyBUZ8YYLae8BbI3XjBNlxTRhXLBLfZDYCVPmfTXLomEDXk7SvQGwsf1tAGiUtBIOvfTs0LZ4H4rDuvo2g7ZjZGS4LhBAzpmdMPYG3/Oar/GSEPNTZupPGFyuOPMurSG1hUMjq1HAtzdTQndSIBeir3beCEoz+YcpO+4x9Oi3xXNv6r79k8vw2lOOLKzvZVKHW2qAlP2VL142NKh8OCyECEvk/XculVlU31XiWCMZWaeHldOp1/IWn3go5dYnvAbcqswYmm8v3kNz1dKuh/jEvTK98b5fZotGIXDTMEhjJPdeiCyU/E0GxIQ6JRzXjRrCfm6ITpI6cq08CRCOgCJIoryEFJ7z2gNela86eJFd+nkSqvbZCSoEyI5FDPdIJqGNpQnO6sAQwa16NReHRvRmG49kCPPLPEucQ+l2ei3jDcWVHjZWYbTWruhQu5DM+U1QjHtaZ7gReD+eF6hFB6i4fHbJJ40fFlYVia4dY12WNr1tHIbmJ5JCL4v8Kdn9AQdqINopjrCyiz2VesO3lWmvOBjnR0AhZg3pMQBcZ9
 mMs/NMki
 zwg/h87eR0nG/XiDY+nOTqARCaFyQ/OMivq1HkBwghXJNK/fJZkjYPobKFKkDS5oTRpFZOhbfoDSlsl9CM0LbJ3dlQ3hVS0cU3FSbZjXrooRAR5IsZUCSeNhQUPzYER9bbsi7QiP+hAV9ZZNGzpDAJX+dUgsfVIOiRv+4yBmeDxD5D00MwcHdXZFzYlE9IWyeq+2SAsOkfZxuK25zQm/ePu9tQSWMeX+iihaYir8RcqTzXHILvJ7WUjYGXGQ1tbVm6ghEOdgO6SfEv7Gu6e+Cz4le8jcPkUr+SZuagUL2GFcn3I3QAeK176XzuRjpYoOwC17O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 05:14:11 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
> 
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
> 
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
> 
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.
> 
> ...
>
> --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
>
> ...
>
> @@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const char *root)
>  	/* Read sys info and compute test values accordingly */
>  	if (sysinfo(&sys_info) != 0)
>  		return KSFT_FAIL;
> -	if (sys_info.totalram > 5000000000)
> +	if (sys_info.totalram > GB(4)) {
> +		ksft_print_msg(
> +			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> +			(double)sys_info.totalram / GB(1));
>  		return KSFT_SKIP;
> +	}
> +	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> +		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");

Super nittynit: "mount debugfs at /sys/kernel/debug" sounds like a
progress message.  "I just mounted debugfs at ...".  I think the below is
more clear?

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
 		return KSFT_SKIP;
 	}
 	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
-		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");
 		return KSFT_SKIP;
 	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
_


