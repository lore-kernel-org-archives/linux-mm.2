Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D6AF41998
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8946B0088; Wed, 15 Apr 2026 08:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478736B0092; Wed, 15 Apr 2026 08:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346F86B0005; Wed, 15 Apr 2026 08:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2340B6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:55:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD77B13A56F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:55:53 +0000 (UTC)
X-FDA: 84660787386.10.5531660
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id F21B2120005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:55:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IFJ+GOGS
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776257752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DOYW7+fbeL2VNYTSascVM/JMexV13XGSf3P0Srb5Ds=;
	b=8O86jtpWza7e/+788xj0Ayq4mUxdna42epW1le0m+zAOWRXe0H/9qKvVV/Za0CHUrCyWDy
	oq2KyNP58eyWyuuTdIqkGoqMXUzsz+JnWFxxfeg8N57SHrbZrbc8H69qu3cm3Ia3W5Z4bx
	w2r5bC3RYILsYh9ykPBufTFIZTMC+KI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IFJ+GOGS;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776257752; a=rsa-sha256;
	cv=none;
	b=ta/vCuSygpdnVtclKLkEme8MGw17clo8jn8lV75KghGY5nFaG/NHysxL0D7MxRzUErEfg5
	l+hC9ETiCmfEW2EPFyc/hKUvPLccX8PhalQpoOGYzIY0iLeC4PDs4FPI2PvPjlwF+swMqg
	cSDErBBIMfzcoFtOnwwdRfGuHGkP0nU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=2DOYW7+fbeL2VNYTSascVM/JMexV13XGSf3P0Srb5Ds=; b=IFJ+GOGS0YQUYc6mik52wA1cDD
	MFWB463UWmaMPNuGOyI5IdsLAdUyBFiCLDQCZASKw3tPfwYScMXeqQAQz13uDHKbgwvwTfRRwFfEH
	+Fg7Ls0UDOaH0lwEYehEtvGKp/PtN2YY88ezIsrVVNDCR5gBiOgva7pXQzkpajNCvz+6gN+iHXh+y
	M9dFguDy1xu3052goKY6mEjGVfn5NWXj77n4kOQBInXRo31aK4goaN1yoC8xGHHQIjY/4fD885eU9
	bnDgqpcXP8Ty+BPYa0/CCTah9+LbpbNtup3JfVma6pkNxUalMwDhC4dgxg3c/Gr+d3e0mbX6Ep5g2
	Qfx6T/6A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCzmT-00Dqoz-0H;
	Wed, 15 Apr 2026 12:55:45 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 15 Apr 2026 05:55:00 -0700
Subject: [PATCH v4 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260415-ecc_panic-v4-1-2d0277f8f601@debian.org>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
In-Reply-To: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1134; i=leitao@debian.org;
 h=from:subject:message-id; bh=gqQVMT9Twy239JXZaAdY+DqLzM5N7ASaSKNxyeQsFwM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp34rHDcA5eHUSdXrkgeIaYk41TbbLb9TXl+BjY
 6x77pV5theJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCad+KxwAKCRA1o5Of/Hh3
 bQIKEACD+IGdXtgFH+lisYO7YsRhhqel9PluKZzzcoUfGdc6P14H+TFb2464+DI2oIPNAwvgEwX
 jH9rCYctvOXLOw+xWMLkV93suYqaue4pinawsq7dlXzc1HakW3UH76VhN5H5MH7MfO9H4hRCjgg
 HNyZJ1mpxffHuF8X+Jfd4JKSAXYrBJBAvIWfJviY1wCvEF+h68XRH2HI2RHkv2yNCnXAMlsjRBT
 31tfanmOy4aoiTryVFnKyT25hYzyV1Xo5nxLUX9r/Xb/ZiDwLzAEGmS/+TDGM9Yea8F5+yBBU9S
 RS6s+AwbWWz4v+ivEIdpdTcvPkMQQJZEVkV3y0xXCOONj/AipjpNtZV9VBG+PbsbD0dJMPCZnUv
 67DIBtdwz578QF3Y8rDlYvHLEumQdONxvgbtoW6ojj14MQewkKXoFA7lD38Yvr+VcSITd66WpxD
 BmBCO/CEaoEjuYM17Q8xHmaUFBKAasx3iLhZcUrJVWVk1fFAJHmhdwHSpIsXeZeR1BDw65iZBkG
 yFrHFacYkad0q04Vr0wjHxNvsEnLiSYvCGjKnF87lixM2iiTa3jNbPTv7dtEQtw9YmVLqgYSJ1W
 fDcxEAwGxw/ghBrItBe4N7Ug9I45U0k1DQ7jI05E75/BX5AtDMvl9seHv7zlU0Ez5Yz6Da991zw
 52c86c15KsiVUHw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: khzef66qb84fp4n5wb89hgzgceumnjtm
X-Rspamd-Queue-Id: F21B2120005
X-Rspamd-Server: rspam09
X-HE-Tag: 1776257751-480755
X-HE-Meta: U2FsdGVkX1+B1ASUmu98QD9mw9X+3dmgouP5oVBqCUA7MVXDpknKdEGdQCWt5v60P1Ia1YBTulDZU1UP/UGGMw4AtVNrtYuR93fl5xBuRE3HbifBYJwaCEE5pbB2gH/qkQFpoYpJvWhLbgocfaFiQdQb6u50vgQ+MmitOFzPlPDpZSHUudnDokElroL/Sk+q32tLSkuXdVPJ2o/QAacoQZ+Zt2KGnyxxsrSLH0gVZx/5XhV/rnxf5s+9Z/FL3E6ZhfU2DJkfv7naXTJ3TmZZ5cddjLC3eEZSmX+5L1hFJLzDWeR6/j7f8BU0+2pua0ak6TlE3d7AhFoCnYXfOwOwuC57v51HVt+qxhwpdI7GxfR88UaSFOy2MiAn6lu8O8iEZWaJzmchLhvZdqogwHoAxdjQaqDrACitv6fZLLu4XL4Ry5yrz9Py5CGe+wb2gBKeV32fzlPQGngY6GiUgnswi3tKelLk8nJh2QCJc0lWs618aS2eQLryodazeu6syJqIFOa6fzTaA4/HrVbioZEVKezPG1ykjyjAwoEFLWqtFOI0+f2/XApnFW/erlicO+VaPzB5QjXcog7cS62EDqayhA5F143tJVr8tdcnVDm7Iz0xWEr7/F+gBoesxPdSpS/TR0KjKvCTjcD0qmemqB0i1YoRfgD4+QXE8r2bohGDCAysSlKfVu9ngP3bpomnfC2KVFeUiih/ahrCSaCLetMXHazkzQD3QVzU+GL73CpuV1LQJe3Tnx32laHzJjYsD8nioiKjVy+0ya3BpTDIxdrJDIWxGwGy16yN5nQiUebSUvXl3QNbAwz1tyCWnDoMiL4Vf4Rd0log4Uhci1a/Y17hwGxVo9xubfjCGf4+vS9HtDztn6B/kq2DcXXeZc+V7+dDHk6CUZoPR64NOhM4PSA84e/JTYeEf1iX+ZimFwmbajJdAWpgVtE2znVGfdijn4aX/6G78zrwwYN4ieFwRU8
 QjeYWfZV
 kKKmJxDATN+AAv5Si0FJIGPuTua833zfSdHcPtKeX/0aTx5wvfTv03d5axzCOqRNFUzlpgpYFGrKKnKLvvy/L8UybBIKuGzL87+YyLT+jxqC15+U3DiVdpHcCUpnybiwnp26vf812E+cgKlghtXsqcFaYnoPq684vrblUOieE1Or8W9O7VWBGCgDzltyeYWDxGugt9bH8GqTPlhaZrNOGiNTZLZEstLxGD0ETTG0lTHRqta6ZlaxdwLtUkjHAAPSqRSVd4vTJTwV4ZATYjBxmeFJTpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When get_hwpoison_page() returns a negative value, distinguish
reserved pages from other failure cases by reporting MF_MSG_KERNEL
instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
and should be classified accordingly for proper handling.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d43613097..7b67e43dafbd1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2432,7 +2432,16 @@ int memory_failure(unsigned long pfn, int flags)
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		/*
+		 * PageReserved is stable here: reserved pages have
+		 * PG_reserved set at boot or by drivers and are never
+		 * freed through the page allocator.
+		 */
+		if (PageReserved(p))
+			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		else
+			res = action_result(pfn, MF_MSG_GET_HWPOISON,
+					    MF_IGNORED);
 		goto unlock_mutex;
 	}
 

-- 
2.52.0


