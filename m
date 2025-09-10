Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97453CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE25D8E000B; Tue,  9 Sep 2025 21:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA0B8E0002; Tue,  9 Sep 2025 21:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFF08E000B; Tue,  9 Sep 2025 21:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CBB8E8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:23:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76A50C0618
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:23:34 +0000 (UTC)
X-FDA: 83871593148.08.74E8AEA
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7AB6120005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:23:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=k2L9SdHw;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757467412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETfF3nXwktUoBLCMUHpmxOuNXOkjj20h9ToOxP0Cp2M=;
	b=VLJUoME9NHH9b44ifxNrmfbZePC6splesgdk3kq2OkPxGQV32Vg4Epq/nieIbWuG9Mu61M
	2vbUuHVnzcBBXn5100g3PLWYczJ2YiUPXl0voulAe9sg0h8mMvLuoima2y4R8VfXU8KL5o
	hrpHTOgBexbVg1Cr0+WHbcv4DgduTTY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=k2L9SdHw;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757467412; a=rsa-sha256;
	cv=none;
	b=61W0zPIhGKSxOlW8Te4vYUXP33AlQ8pObkMNFXVes0ekTx03dEHVOc8JGpZjHJDhS23aIt
	sSx+1CKq1uJN+0fdFuoQ/Cpu8sK4TyPJcBnT1/IjFhFxcajgVNCE6bzr8iz9dPPHSjo9ol
	8hWAfpZriNpryBFE3GLF+TiMKyxrv78=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757467408; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ETfF3nXwktUoBLCMUHpmxOuNXOkjj20h9ToOxP0Cp2M=;
	b=k2L9SdHw0IMN0jFH1fPs+cOZ7Yp7gnRrQscdBOBc9Nie5GbkL9bAf33JTVATsWv1T++9lfYzne3PzDx1uopkb/2Wt0TwHmKUuw1vSUdkjEcTMeOiR8M1VT7GgqA+Ldsrx3dXCv6QDITyzDZYgNj3qJcX7y+BmRXYx7wqL/BMStM=
Received: from 30.74.144.128(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wng1uuh_1757467404 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Sep 2025 09:23:24 +0800
Message-ID: <b9f26954-fea6-44f8-b71a-44e5b4b070e9@linux.alibaba.com>
Date: Wed, 10 Sep 2025 09:23:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: remove PROT_EXEC req from file-collapse
 tests
To: Zach O'Keefe <zokeefe@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250909190534.512801-1-zokeefe@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250909190534.512801-1-zokeefe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tckxaxta1wkpzxjgfhruu3pa79pji8m5
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AB6120005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757467411-754330
X-HE-Meta: U2FsdGVkX19bRdog7gHyaNKS0/GlGrl3lq83j5gm30Yl1js5ERT0MkJbvfHaFD6NQKVA9U/CLTs6lL0OAbR8zX4HXRLYSr/oI+Vc4DCdqJX+gUoQbjZm51mHLRWCxlcOIdllA26FZ047BskpLWnP4kmR3XO2v6OTPim53Bt+AzvIdHH0My985ObP1ZQ/Fgp7R6a7UwwVUOtl7MpEK+PQSP9HChuHCMt00JvWNP7imHiXXs4pyN21jL3J1GMsqznSaLn7gi9KSkO/+ikeEavqQ9EqP4xUiAm+49ZIdMIpMCrjxUQXXRS17d6m8Nza4MCTz1zTGli+AamN4r2Ie7D/BpJC+FgV7iYVwKdpa/8sdjHF5O6xlFTbRk1kFmCVhWBc/GgLWHDB0xMkuTOVP1zXOO0nzhqmzP02FCrlHqQHpKCcnASfZvbuNYCg8r0Cq5S1fk/E0zdPcuPX8XTN6TM2OKe13Deds1zoi2vGUcBhn5Y4TPLYQkANwOnY0qBzjBwl5WKVb6Oe92CSIptQVtogc21fW22HAA0nFbKioNyJdMJTGuhaoFmbKSvAxscnVKY3BwDuuh4K5OPNVOkds9tSl+/pNlmjEHVFAOWm4l/0ocTT4A/Qye/VDJGHUpeVdxVtwNt8PnZWdvZyatbfBpl2+8axgp1xjbwUa83UYGhbYAl+tFS9Qc+39AhKwOEOgeEGno3p9nw1uFVzqf3svghejDrEPIdE7mCZ6bWP72QxVMmca9+gtqNUSTPKyt2ywGtmqkb9TkWyxfp/fxVhkplj9PweRKZM0hHYtCRqL4+CaHcTtCbPdik3RNTZG7ZfkYvr5qHXYVbKc7d+yd3Prfst4vAhNYqClthOmmG0KIZX4OhSCQ4prH6PybC35k2ctHAVZEU0BbFGF5Xqs9HZWf65r2ExlAxXSHEde0F1dFJQATwHDHFD1fzuleNiBbknKMriHqxq9+giUdsVTt5SGCo
 Y3lHf11v
 UjbJTqQ4uKGxW53IoYhOOdAJwFuHzn4Lqrf0jhJap9aDrNJ4LApRx8RwAjir6BO0YMe4RQeVIZBHJPRtmbL0lDM4oxWVRdsOlu9bxuJZ70WQzI30lUYvtNE73pgCLJU+gvE6tpUTfX91qdiTIo/PmLwB1Xbop8nEPzd7GI04mWTnJjn4Qb6u/FLPoZAD7PUUj0tG7GoAhkqAeRlto40dpbx+f3F9FKNyw5yrvmRpHSYL7yeY4b+IIqT3aF1VOSBjQPzw5Hxs1wKK0N+q/PtydNMPzb5M50F4NVGMBSZO0iylqvw3t3ccCWUwcluwlsmWWB1Kv4DRigZg3IVkSDf5Mzi1ML/G57YQZQNuoO1DO2J/4pVORU53IWQufvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/10 03:05, Zach O'Keefe wrote:
> As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
> thp collapse no longer requires file-backed mappings be created with
> PROT_EXEC.
> 
> Remove the overly-strict dependency from thp collapse tests so we test
> the least-strict requirement for success.
> 
> Signed-off-by: Zach O'Keefe <zokeefe@google.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   tools/testing/selftests/mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a18c50d51141..3fe7ef04ac62 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -394,7 +394,7 @@ static void *file_setup_area(int nr_hpages)
>   		perror("open()");
>   		exit(EXIT_FAILURE);
>   	}
> -	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
> +	p = mmap(BASE_ADDR, size, PROT_READ,
>   		 MAP_PRIVATE, finfo.fd, 0);
>   	if (p == MAP_FAILED || p != BASE_ADDR) {
>   		perror("mmap()");


