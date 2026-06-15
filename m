Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF825CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 06:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE156B0005; Mon, 15 Jun 2026 02:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA00C6B008A; Mon, 15 Jun 2026 02:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB50F6B008C; Mon, 15 Jun 2026 02:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9C736B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:12:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FCDB1C3070
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:12:26 +0000 (UTC)
X-FDA: 84881127492.05.0FE6E7D
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9624180002
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:12:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781503944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sCTDUmii5lLQQcKt1l0AcYHEaoTOiEeDl/wS7+ETL2U=;
	b=Ds3BfZ95+83SQWflIfiAn9rdUvyK3xF0GPq7wQ1yBXFQFEsU3deAFY5RqjpbKFb+qTr1DC
	SQLOdYp5y0zgr3JfH3gSCS+1bErumGEivjHhCO32ppClI6aii08il8Tu8derm+QuDDu2OV
	fi6mP36J8VDiZIxHCfF5Eph1fIw2ZqI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781503944;
	b=g1B/ltPD/RUVdhWqtKiu/RRXFkk9yDttUEdphmLljzIvobtd8+zoTTOum670ikPZpmThqh
	yb/PNFg8LAb2smyy5XwYV5US96OMvNvTAvqA9oTXuAYm3KbXTqwiOmDK+wzLOV7DD7X+mQ
	WoU7hhpNdAOcFJs67DrV9vLgAWa9fyM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn;
	dmarc=none
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowABnvhG9ly9qUNiSEw--.62981S2;
	Mon, 15 Jun 2026 14:12:13 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Harry Yoo <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
Date: Mon, 15 Jun 2026 14:12:02 +0800
Message-ID: <20260615061202.23715-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <763e61e9-9270-4057-938f-daf9184a41ae@kernel.org>
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn> <55b1b674-6487-4585-8a0d-919373e66d3a@kernel.org> <763e61e9-9270-4057-938f-daf9184a41ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnvhG9ly9qUNiSEw--.62981S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry7Ww4kXw4DZF1fJr4kCrg_yoW8JFWfp3
	yrGw4rJ3ZFqF9rCa4DA3WxJ3409rWrWF1DG3s0grW29a1Yg3WxArWfKF1Yqa4UCrZ2y3Wq
	vr1jgwsxJws5AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRiSdgUUUUU=
X-Originating-IP: [111.196.245.140]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9624180002
X-Stat-Signature: 89eoz6cibzzugmbw6u798jkt6tnsxdn5
X-HE-Tag: 1781503942-410197
X-HE-Meta: U2FsdGVkX1/RMkX8YMpQqdXWXkbHSmKgWYpVc1xT3xoVoJgx12j8oeWADDq7yv2Hddsa4sTUZIB4q3mKytwA34z2ZVeajYtBjnaP5XEdPh3TsMTvJdh1RmkypmwjcFTiptOwY5asP5WM93Vt1IO5sK7+FjHnemOiMaqbt+kQwG19Nue8idB/8fWXm6LCIeUIYJRG5Y9vHMCU6GGO4GYPvdcHNt0KSXPiGBri647HTP77VHrmTjdsWqAZllvAZ5OH8CiupKI83YV2lDhH+/HJlRcvLIRDTBHpouya9EcW76SkkycceJTl5d9grx7LfHQoN81pNBYY55g95btN443badfHq+hgCNN6YPuKuxysyTkBOw4vLkBDmlcuancBcpwWf75qC8HU8niZf0tYRVeKZGeMKsmn7ZdgBc+Y0Fq2uOWYrInQwnFfCFrSV4etcVMQXxjQGlgRS8Gxs8LeY7p/io1NiK9BBLg+RMk6Rzh4uWq+Wmqn6ofINEUd6bTQKipA+XXGWIkS6a879kefX8pcJbVOgO0rPzttcVL6FBYTO+M7ZjmZ8OgV1XATLLLTnfOGS14DuZZ2Cr14MxMyq5BVtKYGpzaEuB/SBdRg7JuE8bmre0RCZaANqfYLNLCweIAh3JsONqlmtQfn9cZk/hbDtD3fs9f+uUhFK1moAWdnrCCIKDJpZzWJSKNtTGsp+sorA4j388xbmlV41OFpKD5EMOTCTtaDnWbJOPWpMyAKjefT/Wm87Vncs84DTiYibM0Pp7HrABRJyyiTwVmQKY77XcVNu+E7tiOXK4bMC2gHNNKVog5pMgqsT9AWF0ASK7vXBGhopfcQYu4YHZguu0lqnV0NbDT6/YGoJ+xvyI6rtYHLAu/TOUiI9CVko1cgA5LFqZ42ILh/09NpgdyGggGM1N3qpDfu28hn8MQCz5l0ben+EWBkGQ/oNtmpcJUGxJj4KxZNnxRmRtR6frIaClw
 dJshz/md
 lyO5NyVDKY1FWnM2z31+oL7K6sGrZXbQGzlgPbcGAwCk58BceFm+3I25EbqiZG6YthDouHIWq0stB8bWTcqUbLskFfT776IYuKbIroyCKaEtUSgJkgaHHyUWRuit7iExDMx+gerNpueDHURxTSdDtbpf6sfwBUlqH8LpOKD2eRBxtZYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil, Harry,

Thanks for the feedback.

I agree that the terminology in the RFC cover letter was not precise
enough. The case I was trying to describe is a duplicate/stale free by a
previous owner after the object has already been freed and then reused by
another user. In that case, the current SLAB_STORE_USER records can show
the current allocation and the later bad free/check, but the previous
completed alloc/free lifetime that explains where the stale pointer came
from has already been overwritten.

This is not intended to compete with KASAN or infer semantic ownership.
KASAN is better when it can be used, but the motivation here is the lower
barrier of enabling slub_debug for a specific cache on an existing kernel,
especially in field debugging environments.

Based on your comments, I will rework the non-RFC version to fold this
into the existing U tracking instead of adding a separate H option, unless
there is a preference for keeping the extra history behind an explicit
flag. I will keep the scope to one previous completed lifetime and avoid a
larger history table/ring for now.

I will also add a small reproducer or KUnit coverage showing the lost
previous-lifetime case, plus object-size/order comparison data for a few
representative caches.

Thanks,
Pengpeng


