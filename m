Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B233EC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1FB6B03E1; Thu, 13 Aug 2026 03:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8DB6B03E2; Thu, 13 Aug 2026 03:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB1E6B03E3; Thu, 13 Aug 2026 03:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 291246B03E1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:32:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 880C91A0593
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:32:49 +0000 (UTC)
X-FDA: 85095429258.01.8622B69
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf29.hostedemail.com (Postfix) with ESMTP id 195EC120006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:32:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="11K6OQ/l";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786606367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoQ5TKlhdKb/TFvHz+bAuP7Jqfz8RbpAKs8Q7ChZ5Mc=;
	b=Ws1Zd3TbUApl7e2SBTgoSmf8r0K+B/AzApubAN1D26Qw42vwzcImo67/C6MTjAEZDZpLZ/
	lf6/8swl3QB5f2Y0LY9/4m7rLtFJ7N8VOaHi2KMOg0kF6gZXZdNOXsaxgzL+aMX0ULQ6uE
	sVzMyZoX8vofd/kHFuWGppHXFm0szw4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="11K6OQ/l";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786606367;
	b=TMsyIyihNCw3AZC/YeacNEPzBH5dDa14wEFvltvEfsT/nzpwp+cjiRvwRtfZDrqwjCJEN5
	f6YpfQYTtXznRGSOqYOFQbwKFQVRrk7DUsOI33alaAM2C/YKH+5EkMUm0fC8oli1vbKZx9
	WJ+fLxUeWFv8cu8LvolBm25wd32k9NM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zoQ5TKlhdKb/TFvHz+bAuP7Jqfz8RbpAKs8Q7ChZ5Mc=;
	b=11K6OQ/l6CX9yOZpy3sCXPQi38J0UeXCQl4f0o5jcxxCljMjDLy0aDX0PBmhRWYoAl5yFwruA
	D8CXHmEyy2TCEVn9azg+QMlAfPJekl+cOYs6qt/xgsevf8jYOi3tt7CNK+VT6s4xPoHBRO9ivcE
	4A0W3OUB1toinvjMeZoBDAs=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hLGz80LMwz1T4JN;
	Thu, 13 Aug 2026 15:22:44 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BFF734057F;
	Thu, 13 Aug 2026 15:32:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Aug 2026 15:32:35 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Aug 2026 15:32:34 +0800
Subject: Re: [PATCH v2] tools/mm: add hwpoison-panic tool
To: Breno Leitao <leitao@debian.org>
CC: SJ Park <sj@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
	<kernel-team@meta.com>, Andrew Morton <akpm@linux-foundation.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, Paul Walmsley <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, <david@kernel.org>
References: <20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <be68a841-a326-4826-8e02-5148736dd356@huawei.com>
Date: Thu, 13 Aug 2026 15:32:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 195EC120006
X-Rspamd-Server: rspam07
X-Stat-Signature: hddi8zqbhhwy97zb7hws3ntm85trebnn
X-HE-Tag: 1786606365-236499
X-HE-Meta: U2FsdGVkX19pVAk8glmw2RIDT3HKcNmOAT3aJVx+Oytjz75g3odZDKwJDzN16pAjSqJpGJAw9coC7dct+9U2HrjN3RstLt48+SJ8oNJqch0RX0cDI5WQRq9A/fyPpARj1xTL0zU2Hsee9OdIHx1g8wkOV3e+b4JoKQPD1Hr33u74eX9v1GAm8+sS6mMjornO8Bm8C6t5aloirvZ6I4bt97rTasMg+K1a7CD4ntK7HQYs+l/aNRUaxp/Jk5fJGvqtNWPc6puzl6QMcmdLHmCNHEDE8msB+z35Z7W310ATihFk6PKe5PuA42nYiYdnWV2IxKkgUreNNFIzi40jEi8KZ41XxSQh5oPfsAlLBjANUeMyfC4Ls/1hqyEQIXHwc6EVFFf++KbynDi4LZNMJeGxK9bTC9hs06K5dsiOxNfPoti8a23BSap1f5QpVLmXy1n3p2NoLEAzUZZPz93KspNi3f5I6PZ1Z6quek1WoNblkOZErh9822AKzH21X6f7V66s6N6uYVzVIMAaDVG1CoMvW/rw682PdpB+7iDYmVzdMrPTIRNv+4+QbJ5PhgVgkRdyYwxtdBw9qcB8dWL8IL+tj5zUE/2/AERFW7vb18H6LoIo7/y9rTBBru0Hpfz0MK2Yt8Zwg124fTtLY0D6vcyEXIQmSvEAgvf6DZKvz4R5b4bbih4VrjoU6hD0vIif23oZHiCeSvGDhehfYuqMigvL9D0OBUuXXbwFH/z9UWPZNaxjOtNSPkNGhmb2k/yLWpB58UZohg7U7HXTTjRG83QJ/dsLuizVnpujeebZKkEdkKDaKDHpogAiQH8LE3IYmWiFyONnBH3myoBs6+hLgdpsOO+gZ+zgfemzKIjJ8qYtRQI1VeAnn9jMGN8mrarWOSNfPKVLP0446zzc8MUCt+nzSk4/8rfRyKOEVUwIszq4KHCFlrU/mlBTUVwIRNoJESKvVA3g9GCCtzAXd8Syg6C
 pst0jTlh
 TRGGcC+geKZkGdd7AFSpRMz1uk14kDKTzLWPDithqHhPn1vh8/dwbIx9eTYiZ0mth3ZkcNLg4eM2qk9xEpV0dy35R0kh5BcyIq0czrE3QQTsG9cdapbvgWkDl+qYuDOkep9OvE89ro7YxzA5S0mcWXY53lrXOf0ITD8jNOHzqMV2QzyZCPoq6ZJvgBN+g/VXWrJKv9kzcLes2af9AUPIFweDud41r8VgnIqMkKGAKMxj4licHrELDJ5qqDEY73PnUErkoT8XboCsOwDHJ3phcM8VR1rtdwSDUVvls+c24BBhrCWF8dlozGxqMUij01baQS8lUobILfViqJnT5Bsy3ABmOka/btDfHsV2bjYXgGmhSndRo1Ui7PPX3TH7AOYCcFoI1ne7FTMjRBHEuDsg3oG51+eia4I6YxJ7AdOuvSZVaEyrt/16Wtu5h1xGuASQdq2NvTCEqZkP3IEpaIYY594RhIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/3 19:31, Breno Leitao wrote:
> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> sysctl, picks a kernel-owned PFN and writes its physical address to
> hard_offline_page.  Three page kinds are selectable with -k: rodata
> (default), slab or pgtable. In all cases the host should panic.
> 
> Example:
> 
>         # ./hwpoison-panic -k slab --yes-panic-my-kernel
>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> 
> In dmesg, you will see:
> 
>         Memory failure: 0x100032: unhandlable page.
>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> 
> This lives in tools/mm rather than selftests/mm because every successful
> run crashes the machine, which is not something to run from CI.
> 
> The --yes-panic-my-kernel argument is required so an accidental
> invocation does not take the box down.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

This patch looks good to me with some nits below.

> ---
> Changes in v2:
> - Reword the file header, the tool triggers a panic rather than
>   confirming one (SJ Park)
> - Rename -f to --yes-panic-my-kernel and say in usage() what it costs
>   (SJ Park)
> - Call check_prereqs() before getpagesize() (SJ Park)
> - Use 64-bit types for physical addresses and PFNs.  On a 32-bit build
>   the old long/unsigned long pair truncated addresses above 4G, and the
>   negative error sentinel was indistinguishable from a valid address at
>   or above 2G
> - Link to v1: https://patch.msgid.link/20260731-memory_failure_rewrite_test-v1-1-6aa8c6435693@debian.org
...
> +
> +static int pick_kpageflags_phys_addr(uint64_t want, uint64_t *phys_addr)
> +{
> +	uint64_t pfn = (16UL << 20) / page_size;

Could we use SZ_16M macro here?

> +	uint64_t flags;
> +	int ret = -1;
> +	int fd;
> +
> +	fd = open(PROC_KPAGEFLAGS, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	for (; kpageflags_read(fd, pfn, &flags) == 0; pfn++) {
> +		if ((flags & want) && !(flags & BIT(HWPOISON)) &&
> +		    !(flags & BIT(NOPAGE)) && !(flags & BIT(COMPOUND_TAIL))) {
> +			*phys_addr = pfn * page_size;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	close(fd);
> +	return ret;
> +}
> +
> +static int read_sysctl(unsigned long *val)
> +{
> +	FILE *f = fopen(SYSCTL_PATH, "r");
> +	int ret;
> +
> +	if (!f)
> +		return -1;
> +	ret = fscanf(f, "%lu", val) == 1 ? 0 : -1;
> +	fclose(f);
> +
> +	return ret;
> +}
> +
> +static int write_sysctl(unsigned long val)
> +{
> +	FILE *f = fopen(SYSCTL_PATH, "w");
> +	int ret;
> +
> +	if (!f)
> +		return -1;
> +	ret = fprintf(f, "%lu", val) < 0 ? -1 : 0;
> +	fclose(f);
> +
> +	return ret;
> +}
> +
> +/* hard_offline_page() injects with MF_SW_SIMULATED, so unpoison is allowed. */
> +static void unpoison_pfn(uint64_t pfn)
> +{
> +	char path[PATH_MAX], buf[32];
> +	const char *debugfs;
> +	int fd, len;
> +
> +	debugfs = debugfs__mount();

I might be miss something but I can't find the implementation of debugfs__mount.

> +	if (!debugfs)
> +		return;
> +
> +	snprintf(path, sizeof(path), "%s/hwpoison/unpoison-pfn", debugfs);
> +	fd = open(path, O_WRONLY);
> +	if (fd < 0)
> +		return;
> +
> +	len = snprintf(buf, sizeof(buf), "0x%llx\n", (unsigned long long)pfn);
> +	if (write(fd, buf, len) < 0)
> +		perror("unpoison-pfn");
> +	close(fd);
> +}
> +
...
> +
> +static void check_prereqs(int armed)
> +{
> +	if (geteuid())
> +		fatal("must run as root\n");
> +	if (access(SYSCTL_PATH, W_OK))
> +		fatal("%s not present (kernel without the sysctl?)\n",
> +		      SYSCTL_PATH);
> +	if (access(INJECT_PATH, W_OK))
> +		fatal("%s not present (no MEMORY_HOTPLUG?)\n", INJECT_PATH);

MEMORY_HOTPLUG?

Thanks.
.

