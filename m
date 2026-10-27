Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9FD60A3826
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HDCPap0x
Received: by kanga.kvack.org (Postfix)
	id 3E5C66B06E4; Tue, 27 Oct 2026 08:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395C26B06E5; Tue, 27 Oct 2026 08:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E6E6B06E6; Tue, 27 Oct 2026 08:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F09446B06E4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:13:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BE661609F6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:32 +0000 (UTC)
X-FDA: 85368296664.11.F383DAC
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf29.hostedemail.com (Postfix) with ESMTP id 720AA12000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HDCPap0x;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlGykhvYvV4AMDSttZyw/gEEK1mkWyFBP60xF4DLDos=;
	b=eRIigxUCppVbwcdtOTb8BVylLsyK7aN+70Q9x7P+MRHD7P4986OUnRTTlBNy/lCHBjqPmx
	yzjkMQIXluWtJbDVwvA8wfdEPtk5MJxy/SA3kp4+gCLvI4Z8e3Aw1dwVi9T8Mnbi3XIXJY
	McHP74wrRUq22B+FZu9Gj8xWhMU8xic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HDCPap0x;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103210;
	b=4xMLTr5qGdVB9D/ZEtPzI02nPdMmSdaCRcBzc8WW+i98Ogt0v0Ilythu9WsTUl3ezdKxzK
	EL05bFwCb9m8W5/WJcystUgp3ZDQCmaVZ4dDgZ1fOX6eqw+tfwMAmwr/R0JzhDivwMAUPb
	e3zwV09n82mzWwyecTqWmIRhUwCnSKA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793103205; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=mlGykhvYvV4AMDSttZyw/gEEK1mkWyFBP60xF4DLDos=;
	b=HDCPap0xZff7wPxyv0SWtkW2M+WmWll8sXEFQZe2gSWVhcxXkzzE+weMux5OROYlc+dVbvlvmD4ItyqTypmZIAUPSJfCoh6nb35ytgbHe6H1g7mzYRyxjvj3pxGQwybD7yiGCOpQbYttqzBuG/C5WcI/dyh4hyPNVkC/Fs87FmE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XDdofvE_1793103195;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDdofvE_1793103195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 20:13:24 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
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
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Tue, 27 Oct 2026 20:13:14 +0800
Message-ID: <20261027121314.1221539-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <f28b2414-ff07-427c-8e18-e950b492b351@kernel.org>
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com> <f28b2414-ff07-427c-8e18-e950b492b351@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 720AA12000A
X-Stat-Signature: bd4uaotehgcz634ct77mopamnoae61ey
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103209-26181
X-HE-Meta: U2FsdGVkX1+HPTsdPy3unyeuV+yXBnP6RW9BbdwyCLEvQLAj1ZSKNA6RWF3Bc/2XoGg2UVvR+wKCk83X89px1XNboYr39AEuKRBY+dbsfq6EaBALjiRYdyiwi7NLDAFnOlvPEEKZE8v0R2hodA3DnVfu2r1SHLaxoBAO5rQ1vGR6NZxH5rvyMoEpdXIfjUbmEKqAuxDHXHc3/J9ikmlaXd5J+zZojrfjoCOKQqOQ8O67oUePeP+DOK/KFz2SlC/RBSZPApOj0/L0bUpTTRzeJXtFyAR0I4CTqS3DeZ4G1AnvJ2t2CqjDQCdshazdkaDsNuz255NzfYQzj3TD/DUFXtbeVHS02dQFWn3gAKOcWpYO7cZmFLwbKyowzw0y/VEL4XBXhsgnue7L9N3Ix+lUz9QjBNfcELzFAGjc045OmxZi/rrgaHEEG1Gda8kMVzQ3D+oooHZa1cnKW4miH6BPwhtyAShqBMv2pMkRWgtWavFYX+O7mG8dbfTznhZH1dwvMX2Z58Iin8+vD19VWCbXAAmUFnWXbaV1AVjBeqzwkONes4lgsqm4gCp10LXGf4dI25NJ1CIKDR2R6jXjSQU8la2KpIciOPmm1Xe3VZG7L/HO4Qs8Dj6IShNuEGCpsx3mg84wP2W+xbcVZ1ieSU9UgJIOtCQ/6sLNe1zVM7Grp9DzpNRIplPciBOr1E11O79ZA3xpyHOfja6w2KGGhx8GSFcQPqfTyb/4/YNKEWtohdLol6oxXBUbseIYcmglIREJGqYHhQ+f7zlzuY+HcbpnQtJUrTWyJWALjQcp5oXmJWXNWqE2Oq/oZfbMxxDxaxDX2X2938mz+yZeApK5PC5ksk6cXBR892uDVjSv+zZmtK6GHUAx3QtG2c220T7DI2Agzm5AAjmGyR9QR/HIUSsDACS3j2sOAZqnxQoyV5MzlTl77wYqmJvCH+mngMf+x1JLzTAnXOsg+l12lBg318Z
 pFZIoYAL
 Ak4oVzsM7MmDNuDKvXFQm4pF/TY5TZjO2jVJFHBjbLMar8iKYMt4dcF9QC1KiR7tnj689JRq70HEwc8A+2B0AqmG/xAC6d3RZBFFlfuanVwWDa45LomktKHp1Xcwdrp1WQE38sy56RF9WPVyBzZuaK9wAvFrNKnjy6ys+5MM+ghskyBgsRffH2eAtYq1sQMFBCq2NsRadms5lBEwA2LvlIeaSAEOuUb5Ek73iMDks7jfDzcw4dXnM1ZUHan/opZr5kXly1PcdrUgBs+4dd85GE6xxAdg74AmR4XZLuR6OTCN3ZmZ6ZuTEm8OKfTCALpxGp95rn8CRp+2c4/ip+M5dDtSzDMEvrDNC96D9Fqx6TDD7QMv9NigWowl1auSsXzN4yKqM5MKTjiIG+GexSzJLeNwgkBEJzVLmvF2BfYhmkBglLOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 09:55, David Hildenbrand wrote:
> As I said in the other thread, how is copying data that was already
> poisoned (and might trigger another MCE) reasonable?
>
> (although I do wonder about memory barriers ... hmmm)

Agreed, the next version will shorten it.

On the copy itself: you are right, it is not reasonable.  Huang Ying
suggests the same in his reply - the next version checks before the
copy as well, so data the flag already condemns is not read at all.
The check after the copy stays for the flag that lands while the copy
runs: the data has been read already, the destination folio carries
no marker, and the callers discard it on refusal.

On the memory barriers: PG_hwpoison is set atomically and not
cleared while the page is alive.  An unsynchronized check can only
miss a concurrently set flag.  That is the residual window.  And a
check that sees the flag set is never wrong.

-- 
Yuanhe

