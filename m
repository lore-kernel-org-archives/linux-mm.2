Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFD8FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8156B008A; Thu, 30 Apr 2026 00:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168A96B008C; Thu, 30 Apr 2026 00:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07ED56B0092; Thu, 30 Apr 2026 00:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EDCA36B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:29:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C996A02DC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:29:05 +0000 (UTC)
X-FDA: 84713942250.22.3FF6458
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 41C55A0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:29:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iOFjQWsq;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777523343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VundzSntS2gV5ZiUeYZYQvjRIQ1VA1EGbZoM05E5Ls=;
	b=y1ENpXH2Eggt/ec2fDc6ect6T3QP1EL4h88gqfumuD4odtn7b2CxSZYNrTsQ1Mk8ms6w0M
	gCyOUM+GmmxoPIRhksA0uu0WM+/QOlbmm+ct3B3rCi6JQAM8KtRUfFCEdyie59WzPJ5rdG
	2TuEsHN6735LPuGjV5oRCXsEDY3uIGA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777523343; a=rsa-sha256;
	cv=none;
	b=RdNucdYQCAjhnAAQjkdEJUvQDMKbySqerxR9iFyVZpnIM/4wP3UsrT4I+75S2d0b11tYFE
	TpdScQT+lx8zpntpU9yUuCx1JM2hGAG5Ow9u7YzolIc/TMvC+fgqTG3onWSZN9ml3xtjJI
	T2lqDryiGNunkmWWUb6AeLuyPaf+8uc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iOFjQWsq;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777523341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+VundzSntS2gV5ZiUeYZYQvjRIQ1VA1EGbZoM05E5Ls=;
	b=iOFjQWsq7xQKQLdPc8DwBEEwfmCSpU2T+2vJ8IOEDcvQxO7GHlLeSQoDo7KCDHvXZRvrEA
	GR9SpBeC9M4ZAlym2lJ9yvN6AGGrbhXVUSsfEqXO50DMhLmnxv0WkuHD1xFg6cHiOkFAA3
	Ny7OvBnv4CdurRMIfwp7FjlKtY7Rpfo=
From: Lance Yang <lance.yang@linux.dev>
To: maobibo@loongson.cn
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in zap_huge_pmd_folio()
Date: Thu, 30 Apr 2026 12:28:34 +0800
Message-Id: <20260430042834.80895-1-lance.yang@linux.dev>
In-Reply-To: <20260430041121.2839350-1-maobibo@loongson.cn>
References: <20260430041121.2839350-1-maobibo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 41C55A0005
X-Rspam-User: 
X-Stat-Signature: ufb96wcyam7u9aingibgis4ar66u6ne7
X-HE-Tag: 1777523343-92890
X-HE-Meta: U2FsdGVkX1+Fyh/1P/Lgu7/Rj0YOTeW9eHdYTqbJH79jhKaoC2U4WPUNvvVLcpuWtqagdc8J/Hyczm7Gj6amej6lzxlhJCXaBdepMHg9ztx1rM55nSkz2uGeY+EkN1fjTM7s2yp3bRsyP0GfahcOBVL76uTo5qruEz1GezPuMdYOrOGsrBnkXJLaP/PmZhB+Y3TwLJZR/2ocZtzAoWACSO10KLMs2AoyhhoG9o7V15IVa/pcbfL2QuFtWRJumsoj9NK5ZzOQfJdJnQyJxrkuHV5kqEJZf/GeLNnSxN2rF1DlfEo241l8fciycvneDmIGtgEmh7Kfi+K3X8cWXCxhm/TiN1b0PaidhoES6zzS/GJP057DfeyIsbYpa2YNNDsKWG5trQRy3UjbXhJrxGXsgdsGx0heNRFrISDkmA0F2tgtE8D6nv7os3UezizkCVyLdbc22ccvJfW6e9rOdP6zGaxb0fqmS0k/lsGhjfBsocH5hL+Yn/Tp0pi7v5cWvfnOcdIAjeeKw1UGHsiZQl5YP3mUx4aYAoT05mEaeUizENwxxMsXOmzZ62AAjI3V0TvSKNCkUiLUctwmXi92P7LYIdffOU1m/4HVMGqvnRZDwI0A8oSbrCr/RVebjj8ufUGhEZCFzRl6i+ca460n0QONY/coLwfTXBKigs9B23FmPfbTYgjgK5CFyZAUZhXPSotGITG7EnCOMY3ShlmPPFiMy1OLT2S7sbLlMztF4XZKCmooTkH8c7EmIbhpaFzv1fwHOv1DzXGKiCt4N/juMqzzTCI7rSXIZR3wHihyvg2VpaaVks949RsFP7mReQ1Wu7wX5Cve2QX/4nDMyR1i6lm6/+EaaOtrkR5GnyWIKRWPB9qdAMbuFuNbQ6VBmH0YI/oEHX49hsItkwc2pBYgnu+2uQNCb+pI9Ui3dfCJG1MRIqI7wCzx7OnZTPONi+Vue6Cnl4sgKBK8fEFsV5pzPu0
 nJ570d8p
 Hr23PmBVKYKkioulHckk72vXZ7jD4XFBVYzVNWSujVg6e78BRAIquITS3hv799Ac3qJVro4+p4PG1pGSK0eI9s3XmEFrdUW+kM8E0KJwB7x5jYSQDWhnZG5RHfp3pXe/PuysED1lGqbgY/FkPLsfQY0EmVdVmjNU3UVrsjVWa2joQRBszfxQb2uVwfLJFmLAxPY4mYVmlPyemxOQz7QnuFBKLTpFmnMFxzxAfLi4kUsQYs20elQyFMCLoGOIPkOl1/yuIrhbslX1xv7prNYedIGfTsi1nkB0KAYyoPZtZKAic9aY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>when executing command "make check" with qemu software, there is
>error report like this:
> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825

Good catch!

>The problem is that when application exits, rss counter is calculated
>with huge_zero_pmd huge page, instead it should be skipped.

Looks like the same problem[1] we discussed recently.

[1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com/

>Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>---
> mm/huge_memory.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 970e077019b7..3cbea344d4a2 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> {
> 	const bool is_device_private = folio_is_device_private(folio);
> 
>+	if (is_huge_zero_pmd(pmdval))
>+		return;
>+

The huge zero PMD should not be returned by vm_normal_page_pmd() or
vm_normal_folio_pmd() as a normal folio. If it reaches
zap_huge_pmd_folio(), we already made the wrong normal-vs-special
decision ...

So I don't think we should special-case it in zap_huge_pmd_folio(). That
only avoids this RSS decrement :)

Could you please check whether the fix[2] also fixes your QEMU test?

[2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org/

Thanks, Lance

