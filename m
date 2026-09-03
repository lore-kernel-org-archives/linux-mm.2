Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F16C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32FA6B00C4; Thu,  3 Sep 2026 01:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE30F6B00C5; Thu,  3 Sep 2026 01:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01406B00C7; Thu,  3 Sep 2026 01:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFDA6B00C4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:35:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0250180428
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:35:54 +0000 (UTC)
X-FDA: 85171339470.11.6788AD2
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00E6C100003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:35:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Iq22ldOx;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788413753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c438Jw2Ysnl8O3aNj118RhL+HmVlRsuKQhpgAafxBok=;
	b=XfaVnsUXbZnitiVuURm3slBCrxckzpkHH5sqLNQnPigheNmu39a/mxfcB0oUkpUPY7V9ch
	QnhZvd+v4bDA49y8hbHwUTq9mKHY9L/8uf9nzw0gSFds473QJVRHcclP/M4ItKh+3gJniD
	Y9M6CC3bFsQw00iYhwcL9HRIPZH32VU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788413753;
	b=RcVPY829wQFzDskz48oEauOBE9JdXKdzmrCm5Vf9gLoBIlqYXI93DLcHFQHEsFBou5i/FP
	zxJOvJZ86vPwmCQlADcO0060Xk2Nii/hPjcNvflTLveMVtmDIMpCUOFx+nxuK/2GfL8zD5
	04tr2NJL3Z7YvVmG1L6pHcdGXliRPbY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Iq22ldOx;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=93pTWbsU7VFpR8xoXZI9mqztNPbLz1pkgKR/z1zYXGU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788413750; v=1; x=1789018550;
 b=Iq22ldOx79bbN3+w/Bi7g2CADtPV4/8lvNjyZnuBGj2FNDY66bzF60r9MYAcvEjlBbdC10ZP
 NImDJ9mGXXKNQ09A4dFafi7Blrbzr2sVGzkSQ0g8lPRnalEMjfSFx2Nox/Fr8O0++ROIgLUswfv
 w7SQRHlfE5TqcPF716O96EaU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 971ac4ed40a996d8;
	Thu, 03 Sep 2026 05:35:50 +0000
X-Mizu-Trace-ID: 971ac4ed40a996d8
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH 0/2] Make HWPoison helpers config-independent
Date: Thu,  3 Sep 2026 13:35:33 +0800
Message-ID: <20260903053535.17611-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00E6C100003
X-Stat-Signature: ea7iwa41woeysetqjgb6fhg5zqn68oct
X-HE-Tag: 1788413752-873033
X-HE-Meta: U2FsdGVkX19NNe8xlvfoffu7BvSFuTquIT22grrg1MDfkz10g52NrjfqTAwbTLtW3ByGcyFYXJTmotaf3xDdptSiPTz5Yzo5AdgAUIf/hfdXAtO3kRqVGgCZGZUxwE9eL0M8ozTr4o8loqY6ADDa2XOAxZ9ruk8+1tt5hb5n6e9RaXmbsAvoWFA9nw8QhfkI4mIjm8D/iYiuPqIGdhCGa4BjiRs5oTvO6dGSnrJIlVX69Y5avStGEHKy9ZOKnLgObESgu6d7Ebq4msvdF8jm0+3jv6dIAjyfRnNgUCkwV5C39UxkvHtsNp64BBanvliEII49hxg2ATs14XiaJZ5Kjg5UNqM0PHEfapJskTYeQSkcPFIk19I1Uo9LlhrGSLiCU0kZrn+xxoMMcwX/gzqM9PXTGrpnW9bK8zs7SBeRw/Xr5Cc31I9o9N/1PnchIyFRPAb+5hD2Iy1pN+Xxb8xWxLNCMcD598vqMktH/fUJSZGuk5LpDEw3F3iBzuptlUOZ6YLkcHH/ogDVGZQtJSzeInPvz9Y28jPbYxbmpODgg002xuPw0pT+SjIuVOWVQGgt4Z5NBDQeFcnn3R2WQIlCnVx/Q9NpTTSJWrmhWa3FR9pzcSFN2AfCEaUpVMAWX+56+7S1+1CqKVWAre3rQgEfeWoeXZBe6b6V153UbkykJyZqUvVNd1qSAExS8G1wwRDqhnHR3sVKsDxJKflwHES6vfLszBv7Bl4/JnXwf87iyYsgjhs6XxlB2ODRqPH+sg9f33ge5lwUYN+ciw/JWUTvq0tE4hLZr78fbobe/s/iXpTdsrARFotXoaxRpcyTvrecZjiZABNteW+2vWAvi9nzHAd0eE3Eq1D1p+ePYkvhdm9vN487uYD+zNG/NWwkRZsmLkpyxZJ2Sb9CLPDYqCoJTawv3yCqySfpoA66EXmpmjDQf+u4cC9vYOP1BRt+BGl3/2o2MmCfJx3QJyasXlS
 Zk/F7jHt
 8a3B8CIV6efuOpVjf670+7gsL8gtJIqbG4GWcyYtZS+Oz1eok0K3LW/YvToE5PNxzXSPfu7+Sqlu7xfi0hCA8sB0dV4VeVHWsf5ROY+JSfdiRqBxxc/0VfiIzYS2IHVFYkYd9rbQay49LfekfljwxKfh9+3DyRbQrBfJE6cfq3yP2w1z/KEfwRX2fHmCNpLytAAKnYDAdm4+R5aQA8aMLK9HepqQX9dMD8teZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make the HWPoison page flag's test-and-set and test-and-clear accessors
available regardless of CONFIG_MEMORY_FAILURE. When memory failure handling
is disabled, the accessors return false, matching the absence of HWPoison
state and providing a consistent interface across configurations.

Use the config-independent interface in the pmem driver to remove its
private test_and_clear_pmem_poison() wrapper and the associated header
dependency. No functional change is intended.

Kaitao Cheng (2):
  mm/page-flags: Define HWPoison test-and-change helpers unconditionally
  nvdimm/pmem: Remove test_and_clear_pmem_poison()

 drivers/nvdimm/pmem.c      |  2 +-
 drivers/nvdimm/pmem.h      | 12 ------------
 include/linux/page-flags.h |  1 +
 3 files changed, 2 insertions(+), 13 deletions(-)

-- 
2.50.1 (Apple Git-155)


