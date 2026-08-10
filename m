Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F24C5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38116B009F; Mon, 10 Aug 2026 12:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8876B00A0; Mon, 10 Aug 2026 12:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26836B00A1; Mon, 10 Aug 2026 12:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4D76B009F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:28:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D31BC01EE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:28:11 +0000 (UTC)
X-FDA: 85085891982.07.4A70185
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 76B831C000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:28:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=P8Bf3oH0;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfzutoXq/QhHceqFzC7g3Uo92nX5QF8uEfbvCV0Qpnk=;
	b=FJr5sw2CHtHOnaVahYK8arYQChOAT2s616fdbXrs7VMZ7zyHosRALv9X944KnPuzMlRwjo
	GLKq538pFRjNzl2oZjHQYTe9muvFyHGH6jCSLWxpCtAbkVIgH79yC4stkAigA3Gk9setap
	PNXP/kZP3Cd3ybbR+aYRIXwi+kZtsPU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=P8Bf3oH0;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786379289;
	b=wrvvaJEwxB1wPJlN4sE9PO+Y0JSnjX3LijP8hzlONl+hrq6ANH46ai1rcqZHjVRBB0Ldr0
	4L2XuIwEtCD6TRxzmKx6sSS1uGXRPuxRRa1cwIaPlQZIGu3TfaHHB3I6rxgwVv8zDw/y1y
	a95P9k6MP09Cevr6v8rl29pUhcneWDc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=QfzutoXq/QhHceqFzC7g3Uo92nX5QF8uEfbvCV0Qpnk=; b=P8Bf3oH0xACrqWSVqO4gaIQoH6
	oWVLgg5NGpmJ+zmFnkycvZlswPi7MCSTJVwXsb76e9db+GwB3J5/UxQAR3evm5U+tHZyBrg18xAHU
	q8OfPEG7pGXppy/7Bs5bDlSf5DX2h0QJULjB857W6mTg2ewYMkpy1L9a4Cy/obFHaMdDAJEjKbxbT
	nD2OaKygZ6Uj8wWDrPdcuxpjevu1LdshG2CNWDn+R9MI1pKtVB+hobU0PsTfQ8Nx8IB4UwinjILHw
	o3aWUM84DpCYRaaMPMbvKHkpAzJ7dSmmKDb/66YUsCAZZUr3jV/NqYcKf0xYjrAPKziTZoWy6JTNd
	eUFRe++Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtSr6-002ufm-2w;
	Mon, 10 Aug 2026 16:28:05 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 10 Aug 2026 09:26:51 -0700
Subject: [PATCH 3/3] mm: fail the fault on a malformed swap entry instead
 of retrying it
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-swap-v1-3-375ef0767206@debian.org>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
In-Reply-To: <20260810-swap-v1-0-375ef0767206@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=989; i=leitao@debian.org;
 h=from:subject:message-id; bh=0eADPU9A+Bin6aphy+90if2YapwKINa2j/tvvdSh++4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqefvpGtHBBh+N6jpzTsBrdYBNmMXi5BcUh3JQQ
 lHLipIx1UqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCann76QAKCRA1o5Of/Hh3
 bXmiD/9LikOkeDPB49YFIg2IhmzZtXvnNr0DB8lO72WHE1E21H4aVITrHKKdxdxMglgwsd9T2GW
 QeSKLxSfxsUo95+eCNcHn7StmJbcLjhV9i9zS/qrzpeSMRWlGOhjGJxE3K6LsVno69+3MqSKHXT
 8PzHFA/Xn2wUy94vxKXcYAaIsPCqUi+w84pOKYcMKIBfPcaHsm8FXRs2vJdaysU9nsR5Oxg39fN
 IlEKlObmPKCUHo/ylEKtjyUI6s775g7PCE4oNGDMnczXryYgr77zMJpYzvAF1sWIUph2js4AbDk
 /UzbhIJPoiDYipq0rlokHYMhhyFSzl2tZ0+cCn5+5vsmXILZvwtBbkvZMX9grBRlhG376hPZTXk
 NMOBCeu7ZXOQXdxZuUTYHLuJ7Jbdw+KMDh2WzNp28kXzCd5dZwKxh6t78TPFIJF+f1OxjFxEYnw
 iwNmbBMiA+D/yt6eUfDgxtLib2UuyA3HU9caVBHXEqAaFYRZHKtZK39IRg6FgClcfhDGa3EsM0f
 N6Clgnwb5OhBxMHU+QUuU8dpW9q4f2FrAQg/hnZ7GHRoxSFj+i6VknaTFC/R1AvSiMLsnJ7VqBw
 vvS7Eg2QesgK1EkKytzUygFS/K397+yPNVXMfXvOdH2ghcKN3kF7NbiYRvgamOfsOb1/37WGpj1
 php6GfsLKC1SmpA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76B831C000B
X-Stat-Signature: y8uyj11zj66ty5kj57h7o755eweq9jrd
X-Rspam-User: 
X-HE-Tag: 1786379289-253393
X-HE-Meta: U2FsdGVkX1/5bEi5VuiAk3KgaSosjqIivfrIVAfbOq76ZOlTuMfXUnkAjh3p4zTwNkxrfT7hI4M9+TtoJami11vi+SO0Zsd7ixlfddfiMPrCD4wrI9EB198vI+2o99eHR9R3tCIGLzwWNb3s7YLAYX/FxbJYmQF5xAmWwAuti8Z3/8AKDOqaT/IRPuRs5uP/IudolCva2ih4n8C1aUs0TwahgKY/FqVw+MAIgi32ItUBW/WfDflzmZw47bqIRP+C/SOrGu/ielTV0N/CSz6Vmv3puhbYcfSCUOv0be3UQv7ydJwSO4tR5RMqIQpkL+WwvHjKhCtTufTc2rE9QU3Pw9OnpfDC37F94UMsel5V7Jp8vEFoG9eZFkLM7uplyt28nYI3k9xfQfgLZw+7pXYlmk0ZDb85K7Ns8Rp3c05JMOkgQP/lZLBD7jR4hAHCMUqkoTaTJsc0e4mr1B6md+JBrcS1Uo6tZXga5MBeElx17w8oQ4C4ccZ15F3EDS44yJ3iAO5PZDkjANIsi2QkLOWygo6phyqMuNAsN14fkrmWRyqUhHfbkdnu7ilRuuEqYq3ro3ek5FZGjfSzbcaG3drrGITBXnuZvFG2WA5rxuREv2de9W0fdK8YadKVKv5aIRFnxnoZqXhiOtUzSnSVFHL8U+igl2udLvyUiqxbsrllT5pwYvhzPCGyhKWidkZX55LsDBRLAjaXcrHWvM3JODoCZBOtQdZEeR4y0ZvEgF6/X0S7s6HbiyqzZdM4dZTSYVMdfmzt0pk6abW061n/El3dmvGTtoOVIelS0NTfHeacDyTcXmC3u8UsjcBKkjLS2j+PDEt+nZqGOBh0K2w7CX29r0wJNbtiGcgfUJu0DdNv2dMyKvodjWYwAdLbiS0xo1vlyRQpCL0R8cs2N/HbRtOdyPG5ZDIdVtsk/BZ0G3Xsxm4ppD7Y4tirJYzTLSmpkhwxeZaFEKeM0cdSBoUp1GQ
 vX13XscQ
 LtWv514/YxUVe/cYfo0h3nJWs8dnfisary7kxtkyq05UGl/dIK7Da+k7ppIMYQ2ZhmczUvolooxC9LATGvP5UXBsdfZb4OpqY6JmIPVV8z6PPHBamWOGIQr5R8WUpUCScqRac8n7CQbncv5XQXugVdRqOJyxAP4cL/qIfnpPZXRyRiCx59Ih4cZFzV1/OwGsSCeH0rQxyhTfSAasnNmZOYn+jbNlVunQuVfa7OXrDeSkUh3nhqY0arO50wAR50snKgWR5Y2Li5Dtfv7JfItdbpjuvLJQPKXd5srGE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_swap_page() returns 0 when get_swap_device() fails, which the fault
handler reads as "handled". For an entry that can never become valid
the retry takes the same fault again, so the thread spins until it is
killed.

Return VM_FAULT_SIGBUS for a malformed entry, as the sibling arm
already does for an unrecognised non-swap entry. A NULL return still
means swapoff, which is still worth retrying.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 4238778b66c42..2842cd976f1d3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	/* Prevent swapoff from happening to us. */
 	si = get_swap_device(entry);
 	if (IS_ERR_OR_NULL(si)) {
+		/* A malformed entry never becomes valid, so don't retry it. */
+		if (IS_ERR(si))
+			ret = VM_FAULT_SIGBUS;
 		si = NULL;
 		goto out;
 	}

-- 
2.53.0-Meta


