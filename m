Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6C2606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QOcphy0p
Received: by kanga.kvack.org (Postfix)
	id 713856B05B4; Mon, 26 Oct 2026 20:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB846B05B5; Mon, 26 Oct 2026 20:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628436B05B6; Mon, 26 Oct 2026 20:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4196B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:04:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 390331408C1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:04:51 +0000 (UTC)
X-FDA: 85366460382.07.94B7793
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A357340008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:04:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOcphy0p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793059489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDxvbhZaezcuLpjluifFFwSKQ6XQooG9EPlhNbrcxdI=;
	b=R1v5hSurLcsDBJtEVH7yQ/RD1cyWU8PLtKCBK0RMEGLZiSz2QLnolqVBdg2aW3CyhUWkQ6
	G054TGGDm5PJ56SveEkNy3RHNPw06SloC6kOJfTcWqb0EcGwtcJuuAIIVsUlQr1cjXODQc
	y5pY9bQb6FEbvtKn0/1OMJxcmG0jsCc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOcphy0p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793059489;
	b=ombU0wJLcLcj9ooLjgd1dMcvtjfy10F1tLGqQ7yEl2oi1t4JQV9kvP3UtgFad4LKocWNdW
	3kq24VPQRvp+llED3BqMYKRjtvfC/XNiZybBak7JjmqpU8Bq+VQwovQpvKYJtHKCpyZtR7
	M8auDarWh2qu5ourcCbS80AzmjtTeW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D052601FE;
	Tue, 27 Oct 2026 00:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6071F01825;
	Tue, 27 Oct 2026 00:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793059488;
	bh=MDxvbhZaezcuLpjluifFFwSKQ6XQooG9EPlhNbrcxdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOcphy0pHTEsRRTI7qoMCSYX15KgYQuJW3VkHHQNayFGZj99eDEH1JXS8UTTnRFJ3
	 rx4QT4EbivPdYbcpbBANlXjrwaWEKFSfIpu/yylCQVbn+2RjIlMuzRkLcefS3TD+vU
	 n2JyP1UHbtg/tTQd5lXgclF2CX7Bq4gNLJd+J8OoA528witJ4qSTQaySe52p6lpRgc
	 FxB4PcdXbQSQq1gSqK17au1Dctj/aaFGzL1EnM0nEPxALbUGaz/hKI3O+Z4KMxzAK5
	 /7r5emyfgmNcPTNQRDFG10UVqWWbhyf+gng/m/kKq7vbKHE9/8jyWOyZrv/PWgfuj8
	 BVcGuxJ49LuvA==
From: SJ Park <sj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 6.18.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 17:04:38 -0700
Message-ID: <20261027000439.156775-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026-10-26-1-daily-reply-0006-damon-zero-target-value-6-18@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A357340008
X-Stat-Signature: j9omnjkq3e9h16zb3e6z5tmobt6hdhrk
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793059489-821179
X-HE-Meta: U2FsdGVkX18ScDKDCFMHYzr10JQcP5Pq/2LUTgwj67bm9c5hSIgauSNnG3HCPPogFj6YkhynXo1zzdLi7EQiRWr3h2t1/tWlTMDxYfO3nJGU6wkqmK5j8BLDttNqniYgCwhLer0W9uvPTz0zML2FexB00c7fby9kkvPa70lK6rH+Xun41URh0z1hQH9JeJJ0mZiCMrUqL9ZYUXoqy/7haISTotD+FOOPoSiP/+950toB0rs1yBNtYSAHJumclEc+kU7nUxYC4DNfWo233QClkjJxM4NbL88RSP/pZMpOkLzY/KJOtuZdRMKDkwEy17b6XhqYqrxk68l/RniqIrhe4x2+mCNOs47qgnWTMQqUQtRtQDb5uMQQ5erLISdTOZIrE35qzk2KcK9IlCF8CpHgOxD7TnBXhYxaS3H7ZCm2flkY+V2n2cwh2dE8MhMd39Pw4O5f8py3VH6re/xV4mw3E9+30l5cDCqn2tbSMrOLbBQ4hPh83wBQ7yZFDpTv616604Q5vKVex/UE2IoIQMZTCHtR9QE46KEgeju2ftqvdhDtmyABDTv5DXwL6IZox6KENz1sNib4mvzDvfYmhn0e/sR6bp/yhtaFRqwcv+cZ2CZ8ej5in9YEy3u8yY5+v8ssCuIOS25Sic/hK43hZxXURGx0LJpNPEboLUjXNEuPGel7qBmQ/Cjjz1JwPdviKKEsyzFJ5/H2XGunOQzRBKKShpr96ucKshFBJei6Dkp42IDeB1PxgcNZoqJDisvIeZnCYd0/JhqOxAGuL4TTlaGfa/hZtGY8DWipYJL2bcCUW3jj3WlG2KNavj8mE40y2ShTj52/jeXqF908+dWuFDEc7kep0iL8hipPiSztI6ecUL8xDJaS0wXp8G1aAmSLJUBlNbQ6qRLpy7W8BSslYywnqd1PHm81G6Hb0TrDxY32YzG0tswGWfLEujzPfsX+4qOmsGqs6m/8SieRQAHd6+n
 WU6F7F/Z
 v5lEj+UXf8hw//NS+YOATovRsAyijMp1+oHVRxUTpKmiBssKN4m1BMoFppwRxEdAwNZMy78Ti28mmrQVCLTcuJhffGkJrBI9Ez/s78i+doT+InTUdAp5hZj/80Tjrg4pb7pSLtVW4rlldiB29GLfY5LlrUKrE3qtp1J4SzBVU15BS/dKK3JweKZJswqMxC27Y6bYz4Kch2y7BolDCDxdflH63KFyqyMW6Q4nKs3jdCsqN2XWJrQdOiXN1RR8BU2MTOcVhIIzH39zgRX0RUvu0cc6/nIongHEsAsDZ8Wf9bBooypc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Sasha,

On Mon, 26 Oct 2026 18:55:57 -0400 Sasha Levin <sashal@kernel.org> wrote:

> > Also, the upstream commit on this stable kernel can fix the issue for
> > parameters commit paths but DAMON start path.  That's because DAMON
> > start path does not invoke damon_commit_quota_goals().  To fix the path
> > with minimum change, add a new small validation of quota goal target
> > value before damon_start() call.
> 
> Queued for 6.18, thanks.

Thank you!  This and the porting for 7.2 [1] are ready to be queeud in my
opinion, though they have RFC tags, so no further action is needed.

That said, I add RFC tag to patches expecting those wouldn't be queued.  Could
we avoid queueing RFC DAMON patches to stable kernels from the next time?

[1] https://lore.kernel.org/20261026133645.119485-1-sj@kernel.org


Thanks,
SJ

[...]

