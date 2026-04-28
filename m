Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F8BFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 02:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303956B0088; Mon, 27 Apr 2026 22:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B36F6B008A; Mon, 27 Apr 2026 22:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1CC6B008C; Mon, 27 Apr 2026 22:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09E8F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:22:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 864B61A03B0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:22:23 +0000 (UTC)
X-FDA: 84706365366.22.B4C82DA
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf13.hostedemail.com (Postfix) with ESMTP id 16ED020009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:22:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pqFmWNTk;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777342940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slP5ntnfvW78WgZpNY2pjWv8ZV6WHz7JT2kbRbb2KJ4=;
	b=F6XGqNQL9ho6bfM60jumiDM77f+6dKXM31p0leOTuzkKzudlyavyry4ZQXx7Z0F/pRrZ+V
	4g8UgUsPA9wF0/uGIb4jGgg+rFg+U3dps80wQoNVm8NY68MTirVoRuD5LrngmWf6oM8Q8j
	7uzJnRWf0uO2eXRlf/I0r8a3q9NOp70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777342940; a=rsa-sha256;
	cv=none;
	b=Kc3ubo/zQIWUOi92Qhg+VlNGgvu7yNetZP3bZxcZnmkOWUsrhOZkRYy2bLSXOi2ZmM/Tql
	3x4OF5uFQDw8jFJJZni9U8wKmXALCTZFptkNeC2wGD8pcJGvWj4QAN/OLAHEb5dVy/1SyK
	91qzNJxNN0LOP+2LrHXTsywhrH29q1g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pqFmWNTk;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=slP5ntnfvW78WgZpNY2pjWv8ZV6WHz7JT2kbRbb2KJ4=;
	b=pqFmWNTkK87kfZU/JQ4oAl25srib3lq/JTh7+sRo25TEI+3y5H6bRMZjg1E3mf7OgQ3g2c22s
	ONcOVvkx5Mp5aksFISBORfwQ7ZDUVBmPY+rTkUjU2SGsBGnQDewO3WK7GVtD1CfDVQhhvEpKXDh
	hRtgiZaJ5qlUB++Kzi2Z0BI=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4g4PCT1JyvznTWv;
	Tue, 28 Apr 2026 10:15:01 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id CC7804055B;
	Tue, 28 Apr 2026 10:22:12 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 10:22:12 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 10:22:11 +0800
Subject: Re: [PATCH v5 4/4] selftests/mm: regression test for
 panic_on_unrecoverable_memory_failure
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<kernel-team@meta.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
 <20260424-ecc_panic-v5-4-a35f4b50425c@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4d8cdc38-113d-f268-a0de-d77dd2337635@huawei.com>
Date: Tue, 28 Apr 2026 10:22:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260424-ecc_panic-v5-4-a35f4b50425c@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16ED020009
X-Stat-Signature: acjwajc3yyzxrsbpygf1apbtofjk48ri
X-Rspam-User: 
X-HE-Tag: 1777342938-952808
X-HE-Meta: U2FsdGVkX18ddyJQLEeO5l6Wd3xN5d/eVhwbPTDIrL2mm76yZkXsenN2MJu5Xpna7ESJlscpca2DJXolE5FMAjd+k7lRqyO/DpuLVbjNywKZW9GwYQ4jcAseD/dm9fMI9s/wPBUFn2P14/FerfmwCA2ErDN7uq/NOyS0iwVQdLSaT0fz2z1ZhuoWr+UYeObSMFUyA2yoLs+5fjOOnAkjAsr4ucI2Zpl70vk2YsitXJsa7iRsDuI4DFUgm25M+g1F8pB2ZaXfBXkMUkT2GRUolurdZbVb4QCjeO93KdOFCEb/QCP7s1cWotRZhgCN5iPp8Ynxa+NY/ePxeP9Lpr/XevEkqeacXnewHtifn+DSGnCa4pzqkQYIoYN2xi/IQLb4ZtKn8cUAX7Ob+hvxsRhI4UXifl7q9tHxYwwOJi2OXhK++JJ9QJCWIy7cYhCsPayi0I/kglzsG0XCNJAaQmF/7Ika+GNS1F1AlV1eQe+pxMtwSPy3tSI3Y/2j6JLQ9JPO8dFbYVpMEH2CiUEjAuDNaCgRUzEoPQs46Nbp1nOx5IDP/XigD0pQX6oKe4/FMLjaKO56ouHJnLQBKF4XjW0Tzx0nZV3EsBoAnkwW3yRC5/8O0P3lKHn2fw+MKDdnvzraPjsYtMzaw/zwQ3K9Aun97zSBmMbUxZMf4RiOWrUDrhY7yt5vJ2m+rL5Jfp2f9vT05faIF043wA+AZpBc0Vmz4nYF0C2OjziKTCvXrBjaO6QwpRdcm722jHZA7NldtQ5ha7SckYTM0GV0mLm5ucvkgwrZm6VfmpZGTjwqO50rNVsTsyNOdHRRC7kkv9t6n31dzqKe3CoBSSqHkNpTy29kn6s0gaB7T+rfQmb3YicmgQjyjhGYPNYnUVYclWukdXHMAivwnElZq8suz+VRWb7Amf+3cxwEknAdsIeoU4IJmOwN6b7qZpjT+/YFwrBjsj9+U3iUxEYY56X17DemWEP
 00fKMzqi
 Livys1nycY8oBN5hKSR+CE6Rl2K+LtZUfYtQvDLTRA+Q2GNIAIaDdvuy0BaOlHXqY0XwKU9FsxTMOyFyMGpMBPkfTdhggEOWdbONEJUkGjKszlTkghL1MpgB7wZDv7du17eEkO1W+t7FY/zJT6rlP9Y23oa5I/XRlNIUS39VnBhCw8yHeEnBpsd00H+3QZLSU/4xcovRXpsbth6iQc3PxgWkKJvRlu2An9J4JMZe/dgQXGQ7+QHh1/qri9ntmRmgiYPKDKTukwE0AROg2NaaO944kTh65FRdrmbJZpq5bTDpw5pPCS9EoHNqxPdpwxOIiMvblNl3BbeJ9LBvFjBXFsHwAhiATfADv54C9pcvhCHphQ5/J6DJP5MDsXKlTEsktxlfsWFq+lp5srPXk7rq3tBm4Q0ubxxuYnwouFHleNCyABFqQD97tip+6f8beKqcKXPTxTdjpomePQGyF0HXUFw7X1d7iy+YHrCwO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/24 20:24, Breno Leitao wrote:
> Add a test that enables vm.panic_on_unrecoverable_memory_failure and
> injects MADV_HWPOISON on a userspace anonymous page. The page must
> still be recovered via SIGBUS — it must not trigger a kernel panic.
> 
> This is the regression test for the panic_on_unrecoverable_mf()
> recheck: a buddy page being concurrently allocated to userspace can
> briefly land on the MF_MSG_KERNEL_HIGH_ORDER branch (refcount 0, not in
> buddy), and without the recheck the kernel would panic on what is
> actually a recoverable userspace page.
> 
> Run in a forked child so the SIGBUS path is fully exercised; if the
> kernel ever regresses and panics, the host VM dies and the harness
> reports the binary as never returning, which is itself a clear
> failure signal.
> 
> Skips when the sysctl is not present (feature not built in) or when
> the test cannot write to it (insufficient privilege). Saves and
> restores the original sysctl value.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Thanks for adding a selftest. Some comments below.

> ---
>  tools/testing/selftests/mm/memory-failure.c | 84 +++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 032ed952057c6..9cb8d694aee94 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -17,9 +17,13 @@
>  #include <sys/vfs.h>
>  #include <linux/magic.h>
>  #include <errno.h>
> +#include <sys/wait.h>
> +#include <stdlib.h>
>  
>  #include "vm_util.h"
>  
> +#define PANIC_SYSCTL "/proc/sys/vm/panic_on_unrecoverable_memory_failure"
> +
>  enum inject_type {
>  	MADV_HARD,
>  	MADV_SOFT,
> @@ -355,4 +359,84 @@ TEST_F(memory_failure, dirty_pagecache)
>  	ASSERT_EQ(close(fd), 0);
>  }
>  
> +static int read_sysctl_int(const char *path, int *out)
> +{
> +	char buf[16];
> +	int fd, n;
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +	n = read(fd, buf, sizeof(buf) - 1);
> +	close(fd);
> +	if (n <= 0)
> +		return -1;
> +	buf[n] = '\0';
> +	*out = atoi(buf);
> +	return 0;
> +}
> +
> +static int write_sysctl_int(const char *path, int val)
> +{
> +	char buf[16];
> +	int fd, len, ret = 0;
> +
> +	fd = open(path, O_WRONLY);
> +	if (fd < 0)
> +		return -1;
> +	len = snprintf(buf, sizeof(buf), "%d\n", val);
> +	if (write(fd, buf, len) != len)
> +		ret = -1;
> +	close(fd);
> +	return ret;
> +}

There are write_sysfs and read_sysfs in vm_util.c. Can we reuse those?

> +
> +/*
> + * Regression test for vm.panic_on_unrecoverable_memory_failure.
> + *
> + * With the sysctl on, hwpoison injection on a userspace anonymous page
> + * must still be recovered via SIGBUS — it must not trigger a kernel
> + * panic. This guards the panic_on_unrecoverable_mf() recheck that rules
> + * out concurrent buddy allocations being misclassified as unrecoverable
> + * kernel pages (MF_MSG_KERNEL_HIGH_ORDER).
> + *
> + * If the kernel regresses and panics, the host VM dies and the test
> + * harness will report the binary as never having returned — which is
> + * itself a clear failure signal.
> + */
> +TEST(panic_on_unrecoverable_user_page)
> +{
> +	unsigned long page_size;
> +	int saved, status;
> +	void *addr;
> +	pid_t pid;
> +
> +	if (read_sysctl_int(PANIC_SYSCTL, &saved))
> +		SKIP(return, "%s not available\n", PANIC_SYSCTL);
> +	if (write_sysctl_int(PANIC_SYSCTL, 1))
> +		SKIP(return, "cannot enable %s (need root?)\n", PANIC_SYSCTL);
> +
> +	page_size = sysconf(_SC_PAGESIZE);
> +
> +	pid = fork();
> +	ASSERT_NE(pid, -1);
> +	if (pid == 0) {
> +		addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
> +			    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +		if (addr == MAP_FAILED)
> +			_exit(1);
> +		*(volatile char *)addr = 1;
> +		if (madvise(addr, page_size, MADV_HWPOISON))
> +			_exit(2);
> +		FORCE_READ(*(volatile char *)addr);
> +		_exit(0); /* unreachable: SIGBUS expected */
> +	}
> +
> +	ASSERT_EQ(waitpid(pid, &status, 0), pid);
> +	write_sysctl_int(PANIC_SYSCTL, saved);
> +
> +	ASSERT_TRUE(WIFSIGNALED(status));
> +	ASSERT_EQ(WTERMSIG(status), SIGBUS);
> +}

Could you restructure this test using the similar format as other functions, e.g. TEST_F(memory_failure, anon), in
this file? It would be good to keep them in same style.

Thanks.
.



