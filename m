Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36757CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E5D6B008A; Thu, 18 Jun 2026 11:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE486B0098; Thu, 18 Jun 2026 11:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2152A6B0099; Thu, 18 Jun 2026 11:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEAC56B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:02:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E576A016C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:02:05 +0000 (UTC)
X-FDA: 84893348610.14.68FF48E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf27.hostedemail.com (Postfix) with ESMTP id B734B4001D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:02:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1fX2H5ZBVf0imQ/+JuaknqKxpqJQWxoeiO/CE49iEU=;
	b=oNtWhg2IxtJjDdYkevugMwQcuLZ9rPLMwFnwChIuX74nNnrSUYUVJMFgjH/USJJIO/bP8i
	uVjlh9j2dX6jxvTzsIjQzmFDBOrk4oXfHT4aex4h31BkpDoEmKgRBGbUiFqTBfh/KJYiW8
	v9Y8mjx0boTEgTlISQtQWlLcOa7Qd9c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794923;
	b=C76X01fUEWasdU7eXakMTCGfHg70H6vtfUQK4KtaMPNOFgfnl2SxwAoA/ybtqwhAgbcXDS
	dsp0gav3Qro9p8LAiDfqIirF/f1i0dofnNopESVPRX92mtDxQJnx2A4OUWmiqQ3QxttsIp
	g7af/8JT9WSNFyV0xkLgIAQcqHRKoSI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gh3pn5pshz8Xrr9;
	Thu, 18 Jun 2026 23:01:53 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 65IF1gwN029934;
	Thu, 18 Jun 2026 23:01:42 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 18 Jun 2026 23:01:45 +0800 (CST)
X-Zmail-TransId: 2afa6a340859010-ca2d9
X-Mailer: Zmail v1.0
Message-ID: <20260618230145460xKmaa1339oL10bfyqAiVl@zte.com.cn>
In-Reply-To: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
References: 20260618113523.3913307-1-wangkefeng.wang@huawei.com
Date: Thu, 18 Jun 2026 23:01:45 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <wangkefeng.wang@huawei.com>, <akpm@linux-foundation.org>,
        <david@kernel.org>
Cc: <linux-mm@kvack.org>, <chengming.zhou@linux.dev>,
        <wangkefeng.wang@huawei.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW06IHJlbW92ZSBQYWdlVHJhbnNDb21wb3VuZCgp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65IF1gwN029934
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 18 Jun 2026 23:01:53 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A340861.000/4gh3pn5pshz8Xrr9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B734B4001D
X-Rspam-User: 
X-Stat-Signature: 6ozmeczkkhbmj8omaaptw7keu57fighp
X-HE-Tag: 1781794921-487212
X-HE-Meta: U2FsdGVkX19FfItj2A+YEYhgiB2sR/ovyk27bjIZRIWUoNA4MQYuXnrvy6axi7zS/b9GJYuJv5mKF+qe3oUfUY60hWA4ut1+lJ11xSX3utH4SFEZLMTSygogio/13uZcTxgapxgR7uAvO+rwYW8ONkEd03Xdol38gbXpN9XfXJ7pOGYOcLBW0pr0ycq6R/LQPuNOaUa5AKdknllj9SDcfq5Wq3bJMLOl5xaZlZuw3J934sotoYtp+0SH+hlgNiw5dHEsDHqOHdDBO6N4hMnImtTSpHjBMRI3zyo0iowwpzu5S28Pg9788fP/7Yk4cbW8ojimlfP364xoOAoBMa4VbmFXw3/WEDXQIwhRLfNy97kwzaXc84/dsdMg22TIri8xI1cy26n54H0lcvS04n3Suh77pDMBXoC97RXhVnuQqak+R4uf3QvwxI/zeHIMG8wnnnjRMDdEwunwEWuO1ZtKCVKF9seBAQua33eAWNvqUOWsZRn9pPRZyppoZlLi9yrL3A8Tx+D+NITBrwtlxacEnHsKTLtG0Th2DjOJpvXYEhK0KcFLcXsxG6iRE2ZZu6FoZcUhmBXYsRxjVUxtacxSHpvCG/JcPYEydwPgEFBIesKzQu76p4zu0Mc6CPkeF0kV2E0Q2awhGXwI3WkOLZDU/nDHOhC4iajFovfFmFVz229O9amY0WF1G8NaFzAHle1ZNACLbjy5r0nfsRPc4f0DdwbkO9PKTFokXCqsJ4hG0r+jENdSvcMiXkDCnzsVU5MUlViA4obIL6TkI3KwjWmtQXbe1+0dmsAIMipGkVR6uUlg/A/A0sWQMMOK4uMRt/X46sbYfJRKitELhHfXX8IUc1xd1BAOc9XtIMJ94dF0tSrAYfZ56yCT4G/KKGY9jtzaeMRMd834AoB2pxUb7+N6MVh3ErGUcctVZwWE002L1f4RaSYrfPuLzA0nyjh5LIEfSnSHGigbs2EOpkeHR4A
 /V/KZcso
 vo/tK7uqOx6paCLwbQaqbDJ7CQBgr3bwmdJBP9Jfh4/DtHwtS1FvPERJMTkN4nzkGA+bpA/Sa8PoMBqoOu8iGrwvivtVp3RHFY9uK8WxGjnKohMVp+gw/DF6xFkZyNxX6zq7LUZ97OYH+gHDlMqqU5jF9mp1Fvox0uJ3F6J4r8Q1KbfJtVtxCEMq3CaFXA7vNLlsUOmETvTs+3eBaeF4f7FL27g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..41ab25aa2a82 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>      tree_rmap_item =
>          unstable_tree_search_insert(rmap_item, page, &tree_page);
>      if (tree_rmap_item) {
> +        struct folio *tree_folio;
>          bool split;
>  
>          kfolio = try_to_merge_two_pages(rmap_item, page,
>                          tree_rmap_item, tree_page);
> +        tree_folio = page_folio(tree_page);
>          /*
> -         * If both pages we tried to merge belong to the same compound
> -         * page, then we actually ended up increasing the reference
> -         * count of the same compound page twice, and split_huge_page
> -         * failed.
> +         * If both pages we tried to merge belong to the same (large)
> +         * folio, then we actually ended up increasing the reference
> +         * count of the same folio twice, and split_huge_page failed.
> +         *
>           * Here we set a flag if that happened, and we use it later to
> -         * try split_huge_page again. Since we call put_page right
> +         * try split_huge_page again. Since we call folio_put() right
>           * afterwards, the reference count will be correct and
>           * split_huge_page should succeed.
>           */
> -        split = PageTransCompound(page)
> -            && compound_head(page) == compound_head(tree_page);
> -        put_page(tree_page);
> +        split = folio == tree_folio;
> +        folio_put(tree_folio);
>          if (kfolio) {
>              /*
>               * The pages were successfully merged: insert new
> -- 
> 2.27.0

LGTM.

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Tested-by: Xu Xin <xu.xin16@zte.com.cn>

and I test it with a reproducer about commit 77da2ba064 ("mm/ksm: fix interaction with THP")

and Test result shows OK.

Happy to share my testing program:
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <ctype.h>

#define THP_SIZE        (1UL << 21)     /* 2MB */
#define WAIT_SECONDS    10              /* time for KSM scans */

/*
 * Read a single integer from a sysfs file.
 */
static int read_sysfs_int(const char *path)
{
        FILE *fp;
        int val;

        fp = fopen(path, "r");
        if (!fp)
                return -1;
        if (fscanf(fp, "%d", &val) != 1) {
                fclose(fp);
                return -1;
        }
        fclose(fp);
        return val;
}

/*
 * Print KSM global counters.
 */
static void print_ksm_counters(int need_verify)
{
        int pages_shared, pages_sharing;

        pages_shared = read_sysfs_int("/sys/kernel/mm/ksm/pages_shared");
        pages_sharing = read_sysfs_int("/sys/kernel/mm/ksm/pages_sharing");
        if (pages_shared >= 0 && pages_sharing >= 0) {
                printf("KSM counters: pages_shared = %d, pages_sharing = %d\n",
                       pages_shared, pages_sharing);
        } else {
                printf("Failed to read KSM counters\n");
        }

        if (need_verify) {
                if (pages_sharing != 510)
                        printf("\n Test result: Failed\n");
                else
                        printf("\n Test result: Passed\n");
        }
}

/*
 * Print relevant fields from /proc/self/smaps for the VMA covering @addr.
 */
static void print_smaps_info(unsigned long addr)
{
        FILE *fp;
        char line[256];
        unsigned long start, end;
        int found = 0;
        int AnonHugePages_val = 0;

        fp = fopen("/proc/self/smaps", "r");
        if (!fp) {
                perror("fopen /proc/self/smaps");
                return;
        }

        while (fgets(line, sizeof(line), fp)) {
                if (sscanf(line, "%lx-%lx", &start, &end) == 2) {
                        if (addr >= start && addr < end) {
                                found = 1;
                                printf("\n[VMA] 0x%lx-0x%lx\n", start, end);
                                /* Read subsequent lines until next VMA */
                                while (fgets(line, sizeof(line), fp)) {
                                        unsigned long dummy_start, dummy_end;
                                        if (sscanf(line, "%lx-%lx",
                                                   &dummy_start, &dummy_end) == 2)
                                                break; /* next VMA */
                                        if (strstr(line, "Rss:") ||
                                            strstr(line, "AnonHugePages:") ||
                                            strstr(line, "Shared_Clean:") ||
                                            strstr(line, "Shared_Dirty:") ||
                                            strstr(line, "Private_Clean:") ||
                                            strstr(line, "Private_Dirty:") ||
                                            strstr(line, "MMUPageSize:"))
                                                printf("%s", line);
                                        if (strstr(line, "AnonHugePages:")) {
                                                if (sscanf(line, "AnonHugePages:%d kB", &AnonHugePages_val) != 1) {
                                                        printf("error: read AnonHugePages\n");
                                                        exit(1);
                                                }
                                        }

                                }
                                break;
                        }
                }
        }

        if (!found) {
                printf("Address 0x%lx not found in smaps\n", addr);
                exit(1);
        }
        if (AnonHugePages_val != 2048) {
                printf("AnonHugePages is not 2048 kb, not Huge page\n");
        }
        fclose(fp);
}

static int thp_is_enabled(void)
{
        FILE *fp;
        char buf[256];
        int ret = 0;

        fp = fopen("/sys/kernel/mm/transparent_hugepage/enabled", "r");
        if (!fp)
                return 0;
        if (fgets(buf, sizeof(buf), fp)) {
                if (strstr(buf, "[always]") || strstr(buf, "[madvise]"))
                        ret = 1;
        }
        fclose(fp);
        return ret;
}

int main(void)
{
        void *p;
        int ret;

        if (!thp_is_enabled()) {
                fprintf(stderr, "Warning: THP seems disabled.\n");
                fprintf(stderr, "Enable with 'echo madvise > /sys/kernel/mm/transparent_hugepage/enabled'\n");
        }

        if (read_sysfs_int("/sys/kernel/mm/ksm/run") != 1) {
                fprintf(stderr, "KSM is not running. Start with 'echo 1 > /sys/kernel/mm/ksm/run'\n");
                return 1;
        }

        ret = posix_memalign(&p, THP_SIZE, THP_SIZE);
        if (ret) {
                fprintf(stderr, "posix_memalign failed: %s\n", strerror(ret));
                return 1;
        }

        if (madvise(p, THP_SIZE, MADV_HUGEPAGE) != 0)
                perror("madvise MADV_HUGEPAGE");
        printf("Allocated %zu bytes at %p (aligned to %zu) with madvise(MADV_HUGEPAGE)\n",
               THP_SIZE, p, THP_SIZE);

        memset(p, 0x42, THP_SIZE);
        printf("Filled with 0x42\n");

        printf("\n=== Before madvise(MADV_MERGEABLE) ===\n");
        print_smaps_info((unsigned long)p);
        print_ksm_counters(0);

        if (madvise(p, THP_SIZE, MADV_MERGEABLE) != 0) {
                perror("madvise MADV_MERGEABLE");
                free(p);
                return 1;
        }
        printf("madvise(MADV_MERGEABLE) succeeded.\n");

        printf("Waiting %d seconds for KSM to scan...\n", WAIT_SECONDS);
        sleep(WAIT_SECONDS);

        printf("\n=== After waiting for KSM ===\n");
        print_smaps_info((unsigned long)p);
        print_ksm_counters(1);

        free(p);
        return 0;
}

