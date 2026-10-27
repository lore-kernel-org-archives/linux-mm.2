Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E13606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kF3p+lyH
Received: by kanga.kvack.org (Postfix)
	id BB1846B05DA; Tue, 27 Oct 2026 09:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61E96B05DB; Tue, 27 Oct 2026 09:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29F96B05DE; Tue, 27 Oct 2026 09:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7EA6B05DA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:17:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DC8AC09E7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:17:05 +0000 (UTC)
X-FDA: 85368456810.19.2666720
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE33EC0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:17:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kF3p+lyH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793107023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpBt8CQ3npaNOOqrYPrj/fast8Ozf2jDF5Bzncmp5BU=;
	b=gFse/IfkNYC2g3HjwVMYLldhczIO7d79HUuOtzNbMcJpQmvIPgUw7VdkNPyf3B4EE4OpCh
	yVnAFVoZYMARqzBZrDD/DPFmR/wSrpcAHtgGzwJ7mgSiJkxN2IuT76qswf8BS+PqQcplop
	Eyz89+KtYmND3bALRcihF9xTOW+JOP4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kF3p+lyH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793107023;
	b=ZWw0EZvkxhWIzaZbtsNaIUtSpE1KYT/liTykpgUS6NwewZOOXp77Vb3cjBQ8+7RI0jULKc
	3v31oLsTeYhu6N+F1YaC3LNpp9TuEEuf3gV20XF/jlrYrQQVgP724JF3r4SjwaaJVBbTgz
	VSeQgE4Pxd7XnXDydB0U6yMijKtU308=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EpBt8CQ3npaNOOqrYPrj/fast8Ozf2jDF5Bzncmp5BU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793107021; v=1; x=1793711821;
 b=kF3p+lyH7Xv8GL4EeSsKMr8iP9F8HUhvpSCBZoG7WRrYdAk/KCQpl/DSdeEG3tOOu5QNf2Dg
 5mlfjDRbPe3Khj3l3Nyce/jRhB8pcSTGaA2rimxWZBne4stDM8Wj6S8Um3cum9SU0CDpoUcn4+A
 Fs//ki1BzmnEScCTcWX3ZhnE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 7fa098b483a16b6b;
	Tue, 27 Oct 2026 13:17:01 +0000
X-Mizu-Trace-ID: 7fa098b483a16b6b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 05/14] hugetlbfs: enforce F_SEAL_EXEC in setattr
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027-fixes_shmem-v2-5-86a00952acb9@kernel.org>
Date: Tue, 27 Oct 2026 21:16:28 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>,
 Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>,
 Jeff Xu <jeffxu@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
 stable@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CD47E54C-571F-4D1C-9529-20A2D177E2A2@linux.dev>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-5-86a00952acb9@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE33EC0006
X-Stat-Signature: yhbxkrrx65bcsnnwpe6n8mmpdp979gzy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793107022-433292
X-HE-Meta: U2FsdGVkX1+NDqeBRHnNvCRQDgRH94hY/vv2+/wa0NOJmmTOaJvJ+VvSje5XUyvNuWvL6gfLO1kn8nxPw6+nKq9y89TscMbfVj4AyoC5rTYuxK7cyaZIcmBhMN+be8kUYJFOSMqYAUtJZjOkP3K7Q3SEGTEhlVQbAuydFoGNehd1iXHdIP+3e25GR9fDH0Q/daS1brRpHQj408wWQpF9AoANXkLp1SfYiif8Z4Ym7bF6CElT7SpFigTIBul2XaJnOY6kGer45MqRxgGDp4HEe/xAfywPPIKoN7rw8RdIGbvM5ozA6VFkQGx8rCw5xP+3xelxfm37hlGLSD1aM5T7tYvQ1eDwl31ZyevY2dD6Kp1artDrPTbm+MJIoIG3lkvvYXMTiWuVzwfFai+3ElzcPUBbhZURouxsH3vhlQsQ/KW83SA1/zyxGkIWSu0ntfap0vcRK5HE0X8UwhBzjVt54HEXMqTv9i86ezE4vNlZHS8u1wpmlHo9NrGy1DOJEls+TI+tOl1LOtXVG/KAXdMkbKyNgZZtWqQpdt1q7wfOSbTF7V/M8Ypp2DVlU+llfjOegUk9xE60bLJrGCQGMAXGsEpqgOx0MvLh8yEtI85fA6neOCM1xJW8JmIEEmqJ7gpAv84Wk+B3yVmuCL7mJD/wECzs/qAIFw9RV8w529JbEFmYEUGsU3VBdoSyZnoYqPybeSbppscpt0EZUmxYB+tVlAqiAuxqe7NEcTLSGCZ4mGeZnLNAay4+RYmWZRILORPDuB/o96FvR2cwbfYqzW6zoKJQqWh/yvs+dwzA404mNBrcMJn2BgUMf74PsdLqnz4eewTbl0+XoC9nsKmo7udr0QGIQSAyFtOPyNDCg6JLlg9NjykEj/5sTSBIRueRxq4iPjmsSyNknlVXi7Y+I9BjzhDNjKd3fST+V0P8nTF/kbW0WzylS+4XWZvz0VXIlK6GLy19wHNR47/1MkPk7iG
 TMze0GZ8
 MvcMW5LjHk/xHVsJvQIKnntrDNO35hwjzkllJcuoC5OWuIQxg3q/uQCx4kBBvPKqAduQhseOHTOaQNexH/r3vi8X+xqL0HYIIh8gXmjTZ0SjDQIfM2FqnetaOuhSzBD+fuDCB+FqojBIIXsEnKBIe1EW1ibv2Y0y7QCqqoAQcLkjqqcf8/7YPuS4b+3hC3iYLF/OATva/yvwSYAieBMNizxqeIqcMM4+OZZeiDC2BwrIBVWtkd5SX1gTceX5/80kb9mdhZP2oPgoxf92xu47Qwf8WNKlf/QkWXrFtUxBecXpXQT5a0L8LArqNIUzu+JTD+BhxZ1ycuGGas/BpnLzUxUiCLl1CXfARYHQFaW8CxmyUT8whVpJgoSwpTTlD/0AGPLAUpcybLnjGEzaO/VvwL2sfMEw9BB07YcSn+tP6QI/qTWZEW4jebeBJCQ/b+6HsoKaDBQrOvMfwEbV55xy3FRDs5cokLO0BDDiP4579lGFJb5z4JscKc5FgLASDtTNSlSfzZHeSidErRgsSo+ohyM+LQU7SRWV0eGgM/utMyim9hj6//gnMya7BadiiCHJci/tUewtCyC0qdr8BFexg7hU3a1/iNJkQWV8eGVjN3uRmyoWhIfhrnFwh6OXywZwBi0Xt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 21:03, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
>=20
> F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() =
does
> not check it. As a result, fchmod() can change the execute bits of a
> sealed hugetlbfs memfd.
>=20
> Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
> to execute bits when F_SEAL_EXEC is set.
>=20
> This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
> fchmod() incorrectly succeeded after applying F_SEAL_EXEC.
>=20
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> Link: =
https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo=
.com
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> [ david: use common helper; fixup Fixes:; check only regular files ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


