Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89227C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A296B0092; Fri, 28 Aug 2026 05:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B2E6B0095; Fri, 28 Aug 2026 05:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9418E6B0096; Fri, 28 Aug 2026 05:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA4D6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:24:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06D781A0245
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:24:59 +0000 (UTC)
X-FDA: 85150143918.19.2718C42
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3935C100008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:24:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pbkERHQJ;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=//wYykVAzO56xi2ypfdxIFY7+db4T2dNiRrOYuiC9mQ=;
	b=lmQ5ldAdgWLl9NjzkYJm2QTxXPueKbVl8IK7PMuLDU0x4i69uTEjlb7pgeWh6Cf/bn07h4
	IZYZzKDo8VlZFN9AxXUghXH+r44wcQcllwl7ff6ywc4wSZ3dRsCJNVz7yYSc1zUUQi/X32
	g6VCqwAIeJt84UwdmEcD0eLXkdamT50=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pbkERHQJ;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909097;
	b=L+zZ2knU9aNYQMLDe9ertTLCJZUb5k3DFUV8+gSYGoWnj3MSIVJSHkKXL7a0ckbO9BogGa
	hA8tuwiv9FHq7CZpeQD2oE+5IIdPXNVYGdGT2fPnj6FlTmIW0OAqz42o0G9JVGmzZHwPh4
	2uoW5ah9yQoBEGBQujHDkRrCB7U0o+8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CDI22/xCoc9ddBdZXUhSYZ3MzxPYo2degC19Pq6FtgM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787909095; v=1; x=1788513895;
 b=pbkERHQJkaHElumOogHNEjWknXO+i1b5M+StdIo+zG6BnFCi7wMPV/RECNgeGCjdvJ4snv2h
 Ej0YNfsYEXscKQDCMuw7X9hMaLmy8aASChOhogmFclGZIJvs4rIk81ODwASU+uKXoHoS93ojBzg
 oHmQhIAvt0BQJv3SS/hGnSUE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 220f4142187c77b2;
	Fri, 28 Aug 2026 09:24:55 +0000
X-Mizu-Trace-ID: 220f4142187c77b2
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 17:24:30 +0800
Message-Id: <20260828092432.1257917-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 734s4s16xdbrte6upwmzgydr19ius73k
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3935C100008
X-Rspam-User: 
X-HE-Tag: 1787909096-734471
X-HE-Meta: U2FsdGVkX18yAbaliBLvfJrQbW8CNGxVLQ4pS6XpZPrBD7y/0wT8z8yM9j6blA3hVtP88cNJkA3952oHTiFZYHrl4RUN+orq7eEl1/+sSQLUnu0LEnTSCow0Cvdvd/YFxUf39Yahq1CtrPIexoiAFd+oYPAB119OwuNZsKGb5lAJ/IuDv/gSDTtaPER1WCseq30aqKiPyB/XnXfHTEHK5CN1bJ223mZxatISOyBa/3xdYbA0ZomYSqZgLtepHfxy0bx2MHruqCvWZYIvwp6c2u2R48wtcJq+hsevYyjpJO+ZiiSb87v7AvtIEIuKIUGukEAAo4Lor3MW3mWnrhXwJkZNo4LD3XKu/KGZw2ncl15YHAY8PbQ+y/hBUo68InHGy4d7CJYyXDRsn5sHKTq1BqO/qnbVnzNKtHGfbWcf1tkTfot+9niNcu73pMDFNBB9FmyL2jh+qUaZT7tV4C6CmXVYhY8ne74JMXyDdUnHbTQX2pJBKYfPYimnQbNBlBQjozhLC+VpCzYSu6y39WBx4Rc2UGA6829180HJGEK643bpN25g6rZ6EDP10NVH8pkVLHLeDbmQA2T0ss7bedl38fw4hFJMOedNCdjnTALkQD/6fKOToyN507Vs2FXSufCFpNyMxduuSqsDwNEdwtgbtwsURPw0pZOiifgKx450wWfwBom2gHzv5hjxRs3p8TEmv5p3IsTUT3QOOlj0AtU/HA7Jpf9FtQu/y6ikGUidfcSRG6A5OCVR0scbIBjsZIBBzIg1JhzxG/mmhj41i1t54xZKYLzCEOYlQI7MTDFw0g2ofF49CL6yMr069hQTIsnlplNxtAMkGC2yP0d/PkGlAuQBZfSbd2Hnumy6ndG9AJffJVPm+d5i2kfjh5nrMG1OVmEUfUNpB2YH9Oiqa2TpgYX+stE5g7bgFhHaJleqLMM3s9PBiwcns2VNSxyV1AAHrpaw/O5sEq1nCOf4Y4q
 yMNxqtFd
 /qxWC8nwHc36Jio825vot9CLaLrucqEH0Qmj415rs8VghcPB/o5lqL2jdJdJYWWgZSxkQVv1NSF/Pz4KMF+crTubZlHWCqBSvELlUZIe5XlY6gQPgLinMguhKWPGUduZEozA+GI+bnK8exeHjYAE/4TOHxafLaeiIf9WPCTSi3V9LHW2rQI8X5hrc+pFefnA5dtkfRJNCisH2DC2Os8A9R3xbww66nlSaAeNuHbmV1PzGQ0dKaVH5IJKtkDZ3S1fHqalgeMbJBMI+UYKjybLAL9Vica494uRx2QsB98f3pRYLSFYsI9EMuEmne3R+IUDQNYOrZR6s3sZfqEubxoacP+KtmoVi97U3c4X6mgE+mNdzKJMRtJML89f5ZKfQfrr+QmqY+C+fn2Y4qEuY+Bryi03LlVPws5Uka9wxaj9h4cBMeD5/lrB0j+eNFCL/9tcu2nGqVtj1TSRfIct9aRi3/wUnBrNBp5jYNad9VuV7tZgEgXHoVfHTRlte316NtuiTpLua7PUlpx8PfYvkjkHj6YlZGv8OWkQLFsslDlbtXFskpu9wpZNOapvyHaMTLRzMOXCXJX5BwxHilwGPD6ne6Vcla8XRVux02/YhHqARAXJ1iJ36kVpnoLfkENw+rOuT+VJdxMJM4XLHA3mQuBbDIswjQXAp5VOzCsr1zS0cC/+3OUV7irCWTsgsePCitZqnjv3POmtIyU+L1MhWx+d40oCJJZFdB7QECx3Hlb4nfZ1xxzNhl82o+4V92k7vskVlWOHy716mFSDa+5d6Js1ytVJlb4WNeTAX1R0XhnpMbTgjhxJHWh1CcTBmvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

This series fixes memory.min/low being silently bypassed for MGLRU
during non-kswapd global reclaim (global direct reclaim and root-level
memory.reclaim).

Patch 2 is the actual fix. Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which
patch 2's new caller would also be exposed to.

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 11 +++++++++++
 mm/memcontrol.c            | 45 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 10 ++++++----
 mm/vmscan.c                |  8 +++++++-
 4 files changed, 69 insertions(+), 5 deletions(-)

--
2.43.0

