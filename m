Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D192C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 01:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3695B6B009E; Sun,  5 Jul 2026 21:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A066B009F; Sun,  5 Jul 2026 21:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2337D6B00A0; Sun,  5 Jul 2026 21:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40E76B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:18:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 217901C6B5E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:18:46 +0000 (UTC)
X-FDA: 84956592252.29.0F2DA5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 68DFC1C0007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:18:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xspm3dFI;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783300724;
	b=xBOHZK8UiKJ9635ygdJu9YaAe+KHe2PNBVAbCnGtJ18XtpPxPRoRcyKc3THK9KOPUyPBOs
	395Iw6+fvyrIbweXYIZGZ9Rx1c4WvL2CEmQoTuGpxyqpF5Iqp4+zZE1Faz7iECMpCZfC19
	DaxlWStIP9A0/Z0/KPwwfHZfSsfiiWE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xspm3dFI;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783300724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCse9pyTLSRmKmhBEW/kg3N3umOx0WojuIarGT+1LjM=;
	b=RYEUbPyPDMRgEBkXM3Ic7FN4lSjJq2MxlhAEMngAOx7J0DaqjGezFeiI3Ghlq8awWiSRha
	TcuFVLuhnWVs2MpbcVzkVCYKfUNygcw/1oPxuOZ9eJymPdTzIX8rrIUEybDZD35FKe8P2J
	3pOWAhRN1wwJRqfsMxRKnwA3i1S6xT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7AA760018;
	Mon,  6 Jul 2026 01:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D741F000E9;
	Mon,  6 Jul 2026 01:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783300723;
	bh=dCse9pyTLSRmKmhBEW/kg3N3umOx0WojuIarGT+1LjM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xspm3dFINsFpaUjIb0bOkdmGSeRBRdJkPgGxF4MG9Yf2eXwtefOV5caZkE8M+DInY
	 Z9Rvq0vXxisksxW4151QDzPxlebMOTdFgOg7uzvSMcvg1oWEmAG5JWqaB5PLQvHOxQ
	 qS4wur2bNJZqWmcktMhGmvByWelAPisfXorI5ddI=
Date: Sun, 5 Jul 2026 18:18:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yijia Wang" <wangyijia.yeah@bytedance.com>
Cc: <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <shuah@kernel.org>
Subject: Re: [PATCH] selftests: mincore: use default huge page size for
 hugetlb test
Message-Id: <20260705181843.6c7a2c4629cb05d47305cf14@linux-foundation.org>
In-Reply-To: <20260626-b4-mincore-preview-v1-1-5f07aa02ab32@bytedance.com>
References: <20260626-b4-mincore-preview-v1-1-5f07aa02ab32@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68DFC1C0007
X-Stat-Signature: ypc77h1ym4n6rp9gf97op9meot5zpju7
X-HE-Tag: 1783300724-410730
X-HE-Meta: U2FsdGVkX18p7jgNTdvQkSi47hjmEMM0PPQ3h5TpB0oJ5OqH/58yUjzRhlqRo5rqekp0dW5y7MpIXsthTlnPgAQ3ES/RMNZn2ovQiQJmh7NZdQ5GJeBXp0hwIx5y8XLklM03zbzFIp6nw3HUIT9iSRyUYe/xlCeI+DcZGegBaYA0j9eir2ahPiG8980y3WR+BV4PQj1MLzRa/DHbd13xzthLZWKtlx5TjSiEyLIInb0TPUb2Kfw9yHOXwF9q8VztPk2Y+PtUzSE/54ach0f6J+655XzNprerLkKKzvAX7bOor4TaGIzitQ7eGDmSvWbVddVRtQqoQgPDMk5YFMkeE81a7edUhuwNyRGgGMhS1+yjCvGS13rKqkLVSJKH4uSggyWarFrJXEP30ZoNlJu/EyanaDQ2Fngxh32CpuaG11C6f2eJ+axDleljK48IoiGdhe+ezYIjKNsz3ASULjgu3AvAbcbwtl7+Nj8yp+UXlM/Q+vOZQwL/xT4pUZN05Ano15VpUYpvkzwRgbbXMj4cDm/BxfZ3exFl8T50tuxHssV9e3LVPJJmPMgGxatqV4QXkBN3NeBl62GYThHei2Lt9ce2EIsSvUsSKisN2oV52bYIHFpRDs6jE3De553y8/HB9t/T/imDil/q7WiaV9QXOIxQD2J8IM9a3kZksQ4uA5GaV961WMWCIeH38NglnocVJ/wpPfc74Hj1cLv+FlScFySPJuyJNXO6BExIetzwe9SBrIGR8AYCPSEj2HaweyQ2BLMNyYL34tzrAzJnVuN1oH5imvz3+aBbilF/SxvTJ/CInREYXXSWg5J7Frw9M3HjvBTzZjQzy3oge0iWjA/hBfpRnwjedkKNxT0O7gyaXe7k3qJVi0WUzd1NdHL2FLHPuMPn0gTTw2S67aIKRV5H+gO4zBWpu4CMJDFIZa7l1DvCT1CYrnWeCgHxQlcbQuBVuOWY8Os8I3Og+1eoz1y
 r737q18I
 qY2QwDtNoa7VAJwAjzNy0Kd2vKzRgPzmYQApkz8yycWSuqjQ6a+pU23wc4XUGsivZE2LSfBZN87BrZi7h0M0YMxgM7kZ2U/2Zrv+shhgkfoUbrgopZBR8uIWfMQQV2rV+SxIokMLpF8A8uwapJwGgBa7ZKFBJGh9Mpi5l7nDDK0fv1zOGXBUEqUqV2jZf93KTeRh0keVRjryIyIFguIyJX64KShHcIzH9h+aeBNobtdAh5JfTeI0+Do3yMNnSg47pAtevFdYbB/ukMHoEUvywowV9RcBGeZ59nB/uqLJn+lWIS8TwyqFSAg5aELOgdruchWHOiQR1RGyzzKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 20:59:02 +0800 "Yijia Wang" <wangyijia.yeah@bytedance.com> wrote:

> The hugetlb mincore test passes the base page size as the MAP_HUGETLB
> mapping length.  This works on systems where the default huge page size
> is the same as the base page size, but mmap() can fail with EINVAL before
> mincore() is exercised when the default huge page size is larger, such as
> on arm64 systems with 64K base pages and 2M huge pages.
> 
> Use the default huge page size from /proc/meminfo for the hugetlb mapping
> and unmap length.  Keep the mincore() check scoped to one base page since
> the test only needs to verify the residency state before and after the
> mapping is touched.  This also avoids changing the mincore() length to the
> whole huge page, which would require a larger residency vector because
> mincore() reports one byte per base page.

Thanks.

AI review flagged a couple of possible issues - can you please take a
look?

https://sashiko.dev/#/patchset/20260626-b4-mincore-preview-v1-1-5f07aa02ab32@bytedance.com

> --- a/tools/testing/selftests/mincore/mincore_selftest.c
> +++ b/tools/testing/selftests/mincore/mincore_selftest.c
> @@ -22,6 +22,27 @@
>  #define MB (1UL << 20)
>  #define FILE_SIZE (4 * MB)
>  
> +static unsigned long default_huge_page_size(void)

This would be our fifth(?) implementation of default_huge_page_size()
in tools/testing/selftests.  There's a project for someone!


