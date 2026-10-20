Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4F4606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LAqfIotp
Received: by kanga.kvack.org (Postfix)
	id DF8AB6B041B; Tue, 20 Oct 2026 03:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0346B041C; Tue, 20 Oct 2026 03:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6D86B041D; Tue, 20 Oct 2026 03:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD3616B041B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:16:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28E75C08BD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:16:18 +0000 (UTC)
X-FDA: 85342146036.09.EA461F5
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf21.hostedemail.com (Postfix) with ESMTP id 942D71C0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:16:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LAqfIotp;
	spf=pass (imf21.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792480576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqgtHFw5MEgnIKqfkHc1RGsoxWJA/tEPR7ZLeAJ/8+8=;
	b=pDN3IYVTlCIOvc+4+Wr3l034aGr+nYixJL1/mhqlZzY1FBKL/bUQwweX/maFfTkZUv3LT2
	9QsVBztANQjft8z3z4Fb8uv2u71BrmzXLho4YLvmEuHke7/4U+zd+szrD9K9BGOVlybFRA
	+AYNHVKSmXx0HaVMxFdJYaVF6lu+cHo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LAqfIotp;
	spf=pass (imf21.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792480576;
	b=HAH/aEwhVoMi4+FSatwI0hDCjBaDeZ3mto0eRvHJ8yL/Sj50RWmODfueRA8wxzywS8x5ih
	dBJ0/D4NFWMhjBsvdU9jowGDxV4HIQ1VuttbLP4AImD/n0cxaf1DNUc30Hja1zR0RTkDgD
	IKIzFV1bCRlIdKs9RZvH5GY8sl7kBBw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792480571; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=AqgtHFw5MEgnIKqfkHc1RGsoxWJA/tEPR7ZLeAJ/8+8=;
	b=LAqfIotpDC0fTx90MfWsVFGypU1hCAGrmYA/BjPxf8Ucd9Zo835OAdaUOLv9af4EEYBwnDJEAW3srVccmQ9c2RVCKcWhJ8Tgq9yVgbVPTvHFpTM8wdy1Kgy2exaS4jvUnbw60ZbQxGyOoBx2801I6U7SF75n8wgHdWGw+4MUAfo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDC30jo_1792480560;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDC30jo_1792480560 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 15:16:09 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: ying.huang@linux.alibaba.com,
	kaitao.cheng@linux.dev
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned pages
Date: Tue, 20 Oct 2026 15:16:00 +0800
Message-ID: <20261020071600.3695395-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <877bjowf9i.fsf@DESKTOP-5N7EMDA>
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com> <20260928105805.1215770-2-xiangzao@linux.alibaba.com> <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org> <20260929034123.2705745-1-xiangzao@linux.alibaba.com> <331b4e40-8d0c-4333-b2b6-b81e4c4b2e17@linux.dev> <877bjowf9i.fsf@DESKTOP-5N7EMDA>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 942D71C0005
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: duxqf8g8egjwzn4k6w4kh8hmftymc17i
X-HE-Tag: 1792480574-492829
X-HE-Meta: U2FsdGVkX18Br08TFKhGK/pnXH69ix0sN6bS85BOBchbJl87z2TD7p0omAHIdtjesj3GNjUYc8uPpJ2UWOQ6yV8SMGQvWkVWK0DJoZZTOKXy+gSnppjXWogu5lxrZSjglpPH07+O7D2wcsMqRr4vzXSC6wqwzsMJEYwAwpsdTF7Q0wRSfWWmdj7yDLQ6BIgoaneT2onPHek0qB9Lvkfmt89fSnV9Jh5za5TXY52VHrzYOZhmdws30aadfS/6wVojW8ZL3s7+ut9umZXvA6tdXjdrvMANnKQO2ZRFJ9VPMfe/XOafP0QXQ9VlKbGEBO6SftzOP2IDdLv8jIWV5DddnvubmiiOBe2VZ4wWCk3dbhKqJAS8yBM+J4km5EM44pi2ARJLg1KJENAZwQvbt7hPNgOsLihC/9SmZ/tKzD+A4ZjvyoTggtl/a9jbuAmm6L/HpwEQDpk/0FfOv4ziyOcpF0eU4ESSCYH4NhmS90hvKsDd5rA5O1waubpS+msYRBT24VFAFk/1KWRnzIQpCWFaGDOc3WBix/9hVjIOiz8aS6Z3YztiJNDj/9b39Q7HKGmIze5SfjYc8KcVfpkuDFX89cf87ApqJGSbnLzJ5OP1T2sFKqqSRx/K2u5xn4j53v7tPc8974F8sH9Tuet5PDiGldlX2TbLOOJXjkQR4XAyQI8TtK0klqHUEACFxITXpElKz4eRYzj0RVeBmKwb3aNV60OS62sea3658g1PqgzRnQBGsX3z2rTbW9dEq5IZpETMoNdfWFkZkkGvX4MMp2d4lWSBOAqeTsj8WO2p0s6t9Fipoqffguj6oiJxeWwC+q7qNUSdDZr1Nob31WkC28UJMt+IwskJCElsBQOhL/TcNMioX01Yic30nbTutRS3h3E59AEoHsL6p3osWArZsl5GuvurI+MjDbykzGtg1T2VDZ2vvGh5L0W8UD68PLOmX1sAskrDXaoRBRisjrtIvyn
 NqDg0lg+
 hkwEFtlqcQq02H2l/3d7FvvAwv/ihbsw8GClHgnnlJ0swQ1RJaz0X2xHQHmgXNss1GLQ/WJk7L6nE1m3umO3xUk2Z7MRe6vCXkIqHLut1KBLSaFYxA/r+bK2BtEFCvJxFwcJ6PwkXEpCBHu2Zlh2HgX0aNy8Q+KFjJNHaTynA3ADPIE2L+8G/+2F/aj14FnJ+Z+9cp3jrio7RjFPfeYesod2YKstrwvE0xPwJc8+JSiDLoW0nfLZmFHBYeV93BHZxRQVqkBTKsJ9K9y5iA6+TNp6sNWSAhPsxj+iseo9m8pDfQnC30Mz3ArjttkRVrft65SMpxcWispXVbaXvQII/WnAm5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/26 21:14, Huang, Ying wrote:
> Is it good to implement the trick in copy_mc_user_highpage() and
> copy_mc_highpage() if the macro copy_mc_to_kernel is undefined?

Sounds good.  That also covers the non-migration callers of the
fallbacks (COW, khugepaged, KSM), and composes with a real copy_mc
implementation for actual MCEs.  I'll prepare it as a separate patch
with your Suggested-by, referenced from the v2 cover letter.

On 10/10/26 16:35, Kaitao Cheng wrote:
> Could we recheck PG_hwpoison on the source page after folio_mc_copy()
> completes, but before the mapping is transferred, and abort migration
> if the flag is set? This would prevent PG_hwpoison from being lost
> after migration.

Patch 2 already rechecks before the copy - your v2 check, moved a few
lines earlier.  What it doesn't cover is the copy window itself: the
debugfs corrupt-pfn injector has no GUP ordering and can set the flag
mid-copy.  Happy to carry the post-copy recheck in v2 as well.

-- 
Yuanhe

