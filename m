Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E098FC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C066B00A4; Mon, 31 Aug 2026 03:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3ED96B00A5; Mon, 31 Aug 2026 03:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E555A6B00A6; Mon, 31 Aug 2026 03:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C618E6B00A4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:58:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 618F0A03D4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:58:27 +0000 (UTC)
X-FDA: 85160812254.07.987F556
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6493B140006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:58:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rsZNm8eS;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788163105;
	b=V/Vh1PRGOGK+Nf+lxaHI/O6ISoJlmD0fmd5KCfx1q8n7lneJzpbk7Cy07HSGRsJc8P2yFp
	vNAjFaJWgpukxj5C//BEffthHxXkM9lxishG2sVKVpwVsnLWEwrRQsabvM/uWYlbupi72z
	GgnwW7uC96SOvPj0sfqSl+4ersRkSn8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788163105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpHd6qU1H/25OxIUyU+cfJ+VsF5+LmMRg2Jcq1Igf+k=;
	b=JqVN62BuA6ljWdVXH7NxeWbQR0h66mDF/qWXZkQYQd3MWHtnBVCgIGJbO8yZNS3nAlAxKE
	iAAfTzDugfHi8R+vubr1B7+tQRnjXRQxQceHr1dpwpxcH3UZYGW2l5Cf+jaf3Yg0UR2dbk
	IrJv7i/4qMvvN3Fex9yacjCpgW18Vaw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rsZNm8eS;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788163101; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NpHd6qU1H/25OxIUyU+cfJ+VsF5+LmMRg2Jcq1Igf+k=;
	b=rsZNm8eSghfXpzY3uS4RLwHn1cfD/h6+hMc2kIlfgYIMYDLvmwc3zwFj2E6639zMVfvIl7mukxW8wV4lgc/2FWT57bzXnf1evB55HOPd3s/Da/hkG24O0pqK3P1Vzqp0CgFzcTDKPwPg47Qsry8TVnoIGX9VZrBk64J3fBXMfWU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X9vVHwo_1788163099;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9vVHwo_1788163099 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 15:58:20 +0800
Message-ID: <f9ae614f-beef-4e83-b307-d4e743d7062c@linux.alibaba.com>
Date: Mon, 31 Aug 2026 15:58:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260828-fix_split-v3-2-374022586a4b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6493B140006
X-Stat-Signature: i65rdgiirsbsociznqc3k8aodyxaiixw
X-HE-Tag: 1788163103-988662
X-HE-Meta: U2FsdGVkX18MM4t6MwlIKQMyd6JizWaMufbohfI7qPksNjQjNy+55uhJRG5vfMIrUXpcvDZ+4AHDYd39/Gv7qkIODhrqv+fJoptGGB7/2uQOjSh8ih6hrU3rEHuErr8jO2t5hFdsYDxc187JCUxtcxXW35ydf1FOZnlEiTXPJkuydlhBBJ7dbTojEYYsDtm9OhaElxi6O1TTsCqYQCk8GOpzE8/1QVngBU1gjKrbQ0aSQEv9ABeviNb0dTCyNGVMRlgEQrPMMY9HWYQxYcjXheW8ALTNUjkzt4viyIVo1TXghKcdDraoFhif/M2k7JrA4ecgz57ikWPxfYh/deHoYAUZv2muaFG/d2DHA1i4s/ZBFsUYlAdjBNBMqBHBr+aGXGAbTpukDLyFxHotCKCEQ5FtjyprnZqCEcM2V+QmJSyCc1g4r8DByrr4pyQeKtvsHiqBIujA1GLw46TdT6ikM0YmDa+fJ6O/kCiCVU+3Ak9SijXyIAr48OnjF3FItjp96cr5XGNSnKg/NpGWPBQqbAkVMzRHgkIgMUbFTusRFbfJDR/EeYnb0E065TPmlrRHgJsTFQefzBX1oQNKbK0MyxQQ9n9Y+W45Aiwq05aF+ope5etnYmhg9CWOCLTaT0gOsTcaff7Sz50uf8xPYb3oMUurfDm8OgDPhE1Zbb7O/nC00IcChTJrNVe2dc7Fojc4Bgj3VUicqzbAMUvTePjX5AZMfg6poO44b1RZbO1PwfitGZrLIwcXUE9eWzTcYEBFUuUqatmb8nLBS090OaXkAtbDV3fI3gHyAsZJRWoQTtZAvmgaiJkfw2jkd92j1Wj7uci8dyElOuCFftK94CJPemP8JbxalBKEcUQzd6h7V4N+2HgEkxEbkLtyMtgTYqSp1UM+8WYRs3HoD/waMTFYYPJqGbbz6lI35pDpqXzCp6yquVXHp9mNQzdlv0aIPzs2Bft3GLlJiRHgdQdd9gn
 /R2kaBrI
 SB+riMpdPzGjWSBgef9Veunp8C7nrrQA9Bxy3++OvqVyCYW1el4Mhp1uz2TYYRwFXk8gqK7HkN/sJoInGWxvb234nz8wl+UkyRA6JEN5TPWxiM5OrxSSAic1AprJd0oA91sHvnYSHMBuAEa4W/WFbacqDowu3MIbfhwHTbwxJibRL4W8XMaY70Qr8uz9s1FpiVYAXszgFuJYSbCvtUGgregtFVD+Pcz2zS/Nh6XmGo9gQPeg5I7Ke4ogXV5oY39ZOddp+i/MyQSb/0uj5moIFli9EG3bKA8n42d7vX8wtEITUvvzwkhcLwtyHju68ZprFQW5KrWKGQt6CLvzQ1/f7j/3H/IXILBBKGkrwkKPbDT72v6rishH5QopJ4QQg1eU4rVqFzN/41E3Ko2RJFxAn0Rp0CZser5DJzq544hErfA15Ukz5em42uM3jyDe4v0wIAbRbC7skSsyVeg6o/uA9RdMsFJLlSDNecpTn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/28/26 4:11 PM, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
> 
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
> 
> This causes split_huge_page_test to fail because the check_huge_xxx()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
> 
> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> /proc/self/smaps to detect huge pages.
> 
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

LGTM, with comments from Lorenzo and Zi addressed.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

