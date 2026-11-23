Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4D8606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dlBydcnf
Received: by kanga.kvack.org (Postfix)
	id F04236B05B0; Mon, 23 Nov 2026 01:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB8A6B05B1; Mon, 23 Nov 2026 01:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1956B05B2; Mon, 23 Nov 2026 01:34:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2F6F6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:34:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AC0B1607BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:34:43 +0000 (UTC)
X-FDA: 85465420446.21.AF28261
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2A18C40002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:34:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dlBydcnf;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795415681;
	b=6ETFOrrg+UsOFomqoYjsR15tUTyUTvrMw+eIolxITgmC86IKEddxIRni+Lwi4knn5KgBp5
	LRpo7yZQMrCF/LAKop8/9X8vt15jEpcUFhdenAt/fcd2ike9SFxafWP/hPSuQoF+e37+/N
	AqPjoBo6xv8XXGB0cfz8FI1YTzcEwBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795415681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmlXveCSZnpBPgqF5aW5G0Y7xoxhrlf/pvo5jEKUvxU=;
	b=vLf8nQdFC0AWVFVpBddVNfC7WLTAI5VcAUY5LCb1UnTzS5P6qa5MMlO+D+PSftsHfi0N9o
	dZ83H96JlUv4PsFACloKyFs0XLONky0lmtOWrab1uqw8ZY+s3kQClyaCHVjynkJx4YhbN8
	5c9HmC9cAb88oDH9X2O4RmsUx/tPaJk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dlBydcnf;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dmlXveCSZnpBPgqF5aW5G0Y7xoxhrlf/pvo5jEKUvxU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795415679; v=1; x=1796020479;
 b=dlBydcnfQX12oRR8uydjfFNalP6lYwPHDZCy6hmywmxHuo952ryyGAAepLiDfoCEtfpaRzzm
 wApFdueyiocb2Ktsgqp4hFv8Z/M5BEz+tDi72i1Lhg4EtB8Lc8iqQyvAaQDqYyA8VMdGE8L5Xs6
 Mm56EnvkWC59K4BDGst5DI58=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0039204fecbaf92e;
	Mon, 23 Nov 2026 06:34:39 +0000
X-Mizu-Trace-ID: 0039204fecbaf92e
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	nico.pache@linux.dev,
	jerrin.shaji-george@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES
Date: Mon, 23 Nov 2026 14:34:34 +0800
Message-ID: <20261123063434.99254-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
References: <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 2A18C40002
X-Stat-Signature: aepmkhbake3o5fdp551xn1atwpfompgj
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795415680-357675
X-HE-Meta: U2FsdGVkX1+M3QA3vq4KfLtj8G7WWxJkSQh4AML7i/o0dZXngDO6LMXCi8AvTmGkKL+GUN+D9zroFALFFiS3jMA8t04Sih0u/+6D/D15NF78Z/31WkFdjeFkDwm/r58WP9qwFpqRdggWqeTeYY8rWuOOvIqH233sG0dzWZjC5ZGiMknt9JvbTzAVk93GpG7dIBevIbbYiEn0aXRcDRxd3CClH0JW/Vkyq126mSFaJ0zDsUEIGppTet75thJmnp8wFjP0UoTDlmkFpYt9PYbtmL9nBR2k4IqfkdvTyMXhEyi9q7cMh9GuNIYk/6dueNbjhWdYzmivVOn71i2jtu9I6Tg82n4qlIMKxR3qcRLxo/73DPfO4UquivTkHMBf0JMf7SRReSnDF/tFp0QDF/nMA5FgGx5F/pWI2lMgjMHuOzxAGqzh9RkMGZpmj/GeUtq/a8x1umuPaPNq7xR31d1BirBPbHfO8ZV9+7jzDaj1RJEdMj/1AECfwCzqiOhI2D66LfCfFPW/eYZdDb9e+0I1MxQzJryh2sCodKj7Q0l4ftZxHtiw1NXsHa1wRP5XUgYzr4J8g/hL7LMSBaNP5PEsDUgm1MRktfJ7W8rorqmjgnbzUIfsngT6PUviXfyKige2FAqYuRjw1wDgR9Rm1o58zIsxYyTZf/00/rkGdcedWTT6ZkcOLHW8NJOwsD0VkFd4KiHuuvhRdO/WmS6rWtGUhzspQt9Rww4FlIXR4IndDH0GkmZwAMhEPpmcrSJj7AZI4mEPDYZbhZ9BgTAw8SL5jkuIa2BmVDsC8H9PftwcanGMxxYDg/GDlZFc1T9QLZkWrHOVK3Sy82/4y4MW9XWdZnA43xqIM79nArtiNNzqmpwu55+nI1wy/p5eTcrs9dU//5aaS5pHvjyuLgDYs0BT9F3V/V2IEmgYuZc8q1jfx80p9/wltrz7vfybdvEnPiCUdLD4FBDLdF2zYgaB31m
 tYSvZcR9
 X2IWGrdoCgpqImaCVETuLHNBLe/UHpcnEUWCZoYu/NMPRZ02uExEjPqhg4adjxJS+t1Yei5iLrccCVs+nzZfv02InfVKnVwTWEqTL1M9LHBe8VnbDLjt6HIdXAft2HsoTa0QPnP8KdOICBLMYJrAZrHVWJVHBGFivdF05tQtY6oArTlUmZ4+6Inbgkye/1R6I6VyH1DuuY7Un8gTQMdOdgWlAQUsiQobwFyCcdp+luow/C2BnLVcMX/HSSwqZ+Pqn3XH+ZyTHX/iJxjeJXJTakyBSBe/jn6/E1M1Lptq27ydi7yz7tlSpF8vFNp4MrwHsV7Q8KfiI+l3V7f7x+LvLBj8RTM+2u73ztNA6i8BRCjHCUPp6t9wuKawcNX9SmuJIetVjeMV2anoF7ulNVvdZ70S2oIUm59hqJNqaz+TV4FZC19IOwV9lvQteBfSAYPMc0Up06EFg6bXS7+zJy6w4F2nxpa7zWf1jt/7IZvOrYaXtoBvVfJniv4NKsY9Zkc7SP2i4+5cn6xcnzRBoXKl0FvrJbT/IPew/dD5sb+DLcw3h9kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 20, 2026 at 11:34:43AM +0100, David Hildenbrand (Arm) wrote:
>vmw_balloon keeps 2 MiB balloon-inflated pages on its own list, not
>using balloon core that takes otherwise care of updating NR_BALLOON_PAGES
>for base pages.
>
>So far we didn't account 2 MiB pages under the "Balloon" counters, so
>/proc/meminfo etc. would not reflect them.
>
>Fix it by updating NR_BALLOON_PAGES when enqueuing and dequeuing for
>these pages manually.
>
>This has low urgency.
>
>Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

