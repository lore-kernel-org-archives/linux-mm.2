Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E80606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZdNG0Qo
Received: by kanga.kvack.org (Postfix)
	id 3DDA76B09AF; Thu, 22 Oct 2026 14:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F476B09B0; Thu, 22 Oct 2026 14:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A52B6B09B1; Thu, 22 Oct 2026 14:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03BFE6B09AF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:11:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 888FC160243
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:11:27 +0000 (UTC)
X-FDA: 85351054614.12.27ED091
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB8E72000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:11:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZdNG0Qo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792692685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFgWVgLfe7OQeHc3CR1C8glp/R4J3/wE95dB+Ij2ZAc=;
	b=lp5U5c6TE1VIfWtsFHDitNZNoaIiqkfW0EMN13kbDgwC/e4n7Gy352bI++60Qrrl+u/uVS
	0mN74PkTdPG/BzUZ1LwvRVpxEOKRjgWmhYB3WkrDIAYArn7WanjhOi2/1xd6mCc7KH3V8o
	kfgc3uSgjzfbk4yDnweM2ZihucXcoaI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZdNG0Qo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792692686;
	b=pDe2GlH/JvQ+ek9DjYFBppP7Xw07rG8XWTx48U43LHdsBhfpqw2oyht5SJN2Xz4lUsVtdx
	MItw/DSnkQwUeZEwqEJXkAdp+BdrEkW3Eo5Si8VsdmH6jhfzaZSoQUTOLh0lQkXJ7gYZEw
	TLYadqg/WXjpqNtfuhb9uwdfCR60p6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEEF4600E2;
	Thu, 22 Oct 2026 18:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096D71F01825;
	Thu, 22 Oct 2026 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792692684;
	bh=VFgWVgLfe7OQeHc3CR1C8glp/R4J3/wE95dB+Ij2ZAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OZdNG0Qo4UE3rRN/7HUpzE5O1MrPxMIZXwfae4t+cP20oYdkNfSBi4C9HtR8DdunM
	 NlncAXufU6v5edZBbnLNHoSDiqBMR/VdwBII3PKHejsiMb+svgEn2VEcG6f5DeMFSW
	 VaY8Jfd8OFCNJF2fri3Edz98SH2s46xeZSKuflzxQU8NZAvHb0YeEDeVuZwep5oU62
	 1QwwD/YnvSms43Ec7XTyEjPXwoUUzv6NmoPH0rLofYmY0uHScUnAcgrd0nL2iKNc4V
	 GbHzoVdFTgPcDQcaVru9iROeUyLBBcTxFP9Bf5DpLNDGYyckK5TsILL2sEREa7X66b
	 YoCz56qNZ5YbA==
Message-ID: <sashiko-outbox-181904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: test fork of a device DAX PUD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Khorenko" <khorenko@virtuozzo.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Alistair
 Popple" <apopple@nvidia.com>, "Dan Williams" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-2-8bd88551f9be@virtuozzo.com>
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
 <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-2-8bd88551f9be@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 18:11:23 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB8E72000A
X-Stat-Signature: xoq5f5f6r3y3i7c4gb74fyk1fia51x91
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792692685-294725
X-HE-Meta: U2FsdGVkX1+wzbFGMl7yakDBviPBVP9E5TYNtGsWjvreaBRIF7Lk7DHnZbFaFeJClHgWF8NZ4dN58ithDLSJTj19g2q9LLYVEgQy5Orhi5EVToRsr9eRnUfO/aLSUPhcHlj+9G3cOw4JgmohXykqoNQXbdCZXdNrlvApg3CVBH5xImTtux/RDD/o7WavByA16ICFTAHlCiMV/TXZ4HBnkQ9ytrZU3KORqR4zv/48IJtLuZP8m74ChX4itIHJFVhvhk8UM1Tx4789OOY3ahfldlLyxg5G9WFLibgiy7Llix8Oe1Rq5qZQ0TV7DiYflh2W/FCaII/bhLkKDoGHu0tmMq+zoY3bzspc2YTdx2mSsBbMPHttMYtXkEtZi8XjSoOgOIjvRER/r9ZbvzvhYV4X+DYlr+QaLoTcx4dpze77/bXcxzFkRjj/DWHV1TCxlAvLTl1D6fH/FkM3MFnJ20zXZEL15uyxaKvTzE3fnxTz2qRXz1qhjW9E00e3tItdnJsM7LwhXau0JLIPr2vGxj9SH39NziJNV9+ERGo2dGqeYOu06uH+pEWSlF7LRXQcXg0ed6U0XMr44Een/n015+sMP58wLGRsZl1YYOUaYBoFPf7HX32uHeKvxnwbAC6ToHx1ywvY8wI/jOtrGVw70wg0/yXJBqpk2KMCzxPSHav82GL5OADPURh85QWcMeGhpLX+uKxf6LiST/Hzm9YAu4iIpaoQ099l5kmH8kCgl2g5N7RWdSHE18+OhoM2GQQipFIivzlVHrOeLOVG+d/oyTgrGlIbpQM36kmG+rs5WMYCFt6LcIBPMN0qauWEpesy2YkVzF672LnyN4aIo2jcJc/pf9Vtb5UvWWcT/2oZwuRlwsMqhFSrApHxoG9pZaGrnngotSlYISweQ/A2AQ6Ur5uS9V8uzsyRirEHpyML4YiWMHYeZcYeqF9dw43YY7jAw1YHaP0kgqxw9uMj3N0z91s
 rhjQLzWj
 MZMNlBiC7QKOJ5qjXKPakgypwo0HjH2ljIQzJF3S6eir9aVUgql0SyxFOPIftUyW2pyLIgYy5dYJOXhWG+nsLB+keqJEWLZjL1BtcNBVLPI2mrB3S/tfcnFRru7MQr6TBb8Y9AzIuSBRBhwki5w5Wdyzc0PpUJs7iZ5PRsRt+8kmw37MUm4eQWecxscReaUEc8ADEXy+lmoejj1Dmso470J5QXPAWTQjg3gPfvTUl2yi0ZRC+PJV934myXOdv/CrBf4j3CfrnCLTMAxPkW5t4+jSf8JrRtOwBPLk5fTQSLHJ75P8F3iDDL/sPDAKa3lJZpVDVSlqh7W4t+PEBcZk35DwUpYlCA70gnTLQM6broVikLP1Zk02QEb1EeBvFipFKKRIX05tSzcZ6GjzjNhLG8qnvpC3f3wgOQ/NmbDVOIo1BKOqHz8DXU0CZL79GKOgrQ4wGdilBa2kle1EA1dfTDs3/S7BfK0FvvkrZI+AV4YO9bNyr5WUYs28C0Ol4HjGhEo/f5CxLuQwNKy0T4UlOv+l/oJBcPNJnuVPunduogpUUdBRUXrdSC/GBw8Xf195u7pEjdXk+Nq8eHg1Q5iQe05oTvnePv14xkyWJi6nhF7kP6q3DL0Q8XBC/Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/mm: sysfs_ul() and rss_file_kb() duplicate vm_util.h h=
elpers
--

commit d02ba4b69f400c48de47f25c78208f1cfd2fe974
Author: Konstantin Khorenko <khorenko@virtuozzo.com>

selftests/mm: test fork of a device DAX PUD

This commit adds the fork_dax_pud selftest to verify that fork() properly
accounts a copied device DAX PUD mapping in the child's RssFile when page
tables are copied due to a guard region in the VMA.

> diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/se=
lftests/mm/fork_dax_pud.c
> new file mode 100644
> index 0000000000000..1fcf46341ace2
> --- /dev/null
> +++ b/tools/testing/selftests/mm/fork_dax_pud.c
[ ... ]
> +#include "kselftest.h"
> +#include "vm_util.h"
> +
> +#define SZ_1G		(1UL << 30)
> +#define DAX_SYSFS	"/sys/bus/dax/devices"
> +
> +static sigjmp_buf sigbus_jmp;
> +
> +static void sigbus_handler(int sig)
> +{
> +	siglongjmp(sigbus_jmp, 1);
> +}
> +
> +static unsigned long sysfs_ul(const char *dev, const char *attr)
> +{
> +	char path[PATH_MAX], buf[64];
> +	unsigned long val =3D 0;
> +	FILE *f;
> +
> +	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
> +	f =3D fopen(path, "r");
> +	if (!f)
> +		return 0;
> +	if (fgets(buf, sizeof(buf), f))
> +		val =3D strtoul(buf, NULL, 0);
> +	fclose(f);
> +	return val;
> +}
> +
> +static bool dax_dev_ok(const char *path)
> +{
> +	const char *name =3D strrchr(path, '/');
> +
> +	name =3D name ? name + 1 : path;
> +	return sysfs_ul(name, "align") =3D=3D SZ_1G &&
> +	       sysfs_ul(name, "size") >=3D 2 * SZ_1G;
> +}
> +
> +static long rss_file_kb(void)
> +{
> +	char line[256];
> +	long kb =3D -1;
> +	FILE *f =3D fopen("/proc/self/status", "r");
> +
> +	if (!f)
> +		return -1;
> +	while (fgets(line, sizeof(line), f))
> +		if (sscanf(line, "RssFile: %ld", &kb) =3D=3D 1)
> +			break;
> +	fclose(f);
> +	return kb;
> +}

[Severity: Medium]
fork_dax_pud.c includes vm_util.h and links against vm_util.c, which already
provide shared helpers for reading sysfs attributes and parsing
/proc/self/status:

tools/testing/selftests/mm/vm_util.h:
bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len=
);
uint64_t read_pmd_pagesize(void);
unsigned long rss_anon(void);
...
int write_sysfs(const char *file_path, unsigned long val);
int read_sysfs(const char *file_path, unsigned long *val);

In main() -> dax_dev_ok() -> sysfs_ul(), the test hand-rolls sysfs unsigned
long reading with fopen(), fgets(), strtoul(), and fclose() to read the
device align and size attributes under /sys/bus/dax/devices/<dev>/.

Similarly, in the child path of main() -> rss_file_kb(), the test manually
scans /proc/self/status for RssFile using fopen(), fgets(), and sscanf().

Could sysfs_ul() use read_sysfs() (or read_file()), and could rss_file_kb()
use check_for_pattern() or be added alongside rss_anon() in vm_util.c inste=
ad
of reimplementing these helpers locally?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-vstor-1501=
43-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com?part=3D2

