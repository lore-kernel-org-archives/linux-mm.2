Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EF2FCCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950B86B0136; Mon, 19 Oct 2026 01:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926B86B0138; Mon, 19 Oct 2026 01:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83CEE6B0139; Mon, 19 Oct 2026 01:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22B276B0136
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:44:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A610A12061E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:55 +0000 (UTC)
X-FDA: 85338286950.15.3A82ED2
Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA1F140005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtTMn6YA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXtS8nqPI8bMiiZsI5aMJRhf4Xi82nV2lL/o/RcncNM=;
	b=7BsvVIZb5d6SHwVpRo+FAMCEDVu3hJzSTD9w7IFYO+Yz1vVaTv7Bw8TLeysqLwtT8hnUNe
	/Ea2ySzyA6B8lNMByRADIPeeUSsGxMTxxuijY63Ib5hoFnoE2sx5NwMYzBgZD9jGoY0jnP
	vYI3WdnJZq3vh+ORLYDlFPI2Ix0NT9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388693;
	b=NxiDiGmJ4b2vN6Dxs4CMP/QcySAZup/Bx/JGDLIx+dcYf2UjRyJs1IQkJxgMeTvc93AWI8
	ZSPrgj4yg3+2r/x24un9bCqDtEn1KhAZnkQg+Gh+ac++BEkNxzIH2hIBWP0zkcENiQcF1W
	JTGTH5GssBJd8Yb8Mu4XGmcx2ByLWA0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MtTMn6YA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qs+zHZlkyqRDMqx7SNWEDLyLXIGQ6DciwEgGF1OF3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388692; v=1; x=1792993492;
 b=MtTMn6YAgt63PiLZWQZLAYe+1kvKxbYndgDbrEc8qmTLzwmksGIoYCwvfdomqqHf5AdbXPsp
 MTuP30HpnA8fz0bkHTaQW10KP4JWkQkgyDnf1c28sDVJXm5YsgiCcLO0xFkNIwcm3ecF0xQ+ivM
 KRYhZEargjCrayG58dkxtj8c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 48f0776ddb594f90;
	Mon, 19 Oct 2026 05:44:52 +0000
X-Mizu-Trace-ID: 48f0776ddb594f90
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v2 5/5] mm/percpu: stop unmapping the CPU that failed to map
Date: Mon, 19 Oct 2026 13:45:30 +0800
Message-Id: <20261019054531.87652-6-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019054531.87652-1-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA1F140005
X-Stat-Signature: j1xfdq9eco1k799xzquzaqmz377ao7mn
X-Rspam-User: 
X-HE-Tag: 1792388693-597173
X-HE-Meta: U2FsdGVkX19fnIyF7w5NI0PqXoCr32uMnVMMnLync1xms5e7PrAOYl6Z3RsaA/EAVSd7sUWd1w5Qd1hlisCGvp6J2NKhCgRXuuYxVi5X4CoR5bBS8edj+FZsnfxwwmD2+j6hzacRjr9rNFIv+KxZbblN01XsCmlJUToi1+AFebzuSWY6zs0+/Kcub/pXIt01u1kDFgep7esbLVQIpdUf2DKXupM9x8evocw2PbdWwnqohpJOa9lI694Pvker9bX0q4A/WOaD4TjhTsWiMAjB3zYwKLq2Vp5qEFI1RcXzSP0nGmS2UtMDZKVMvuQb9ge07L152eS8kHqor3stRjgZt3Y3JPffJxcBTkELGb1lLtF1Ehd+4my8xMrw1k7vXPG3ob6nsdYJEI87Z6hSFLzzh07TQzwb+EGJED9K80KmBfV24wz5d2U3JLQmmlNzWd+A1VmwNPOGTxiOr+e+BHCNiy0YtvZMUNj4/DVb2RU9TMhlttk5LxWqTIq7gHxZo83eS/ZGaI8xsgVRPok6src14JViakFRXci7IOoESIJHT7yBF1AOQp30mMjwclptzbBVDlInu0DpuETeS8uPgSH8iaLxA7JsrJUm/dc5v+qovcyq8kJqT2eMd9dnuLUDleM1xH8N9L1nWBAPVVplPMdfXidKqsreg6hnRYcIRaHEnMnbrVPk+7pgO64h7vh5zATBwBJSggw1J3LtUze6xI8b3BNnEow9ZYgiH0bR5m6NZ9n2yd4NJ7B4lQDLQBMN51bjQ6QqrvV7eAHh+Mq8+zu5JvSpBevvKOiDE4FaQNU71AKDa2Rp68K6JrhNDE5e8GoJZTtW+3KuJ+92/w8Qmorb8G+I1PwlC6OvhyZGu3TW0qQcVfQADsSbHp0wSYZ8XshbNdql/0ICapCX0VR2uRtaAjjkcRPSRQDXxHrlAIzNv02KxkkuYBzjuyrqfrqKlgcee27sySuagi7LjchMnHI
 fa0J9b2B
 gRvUmJh4Efqxlm6xbsOZVeKIxl8RTIW2pASeakZ3BEbuZAolJNU9I/vpdF1IWtLN5ikE44mP+tDTMVh9tsOz2jnHqafa7CaXFZ6J7Mxqz8rbJaU7F/roltWoggsikt4tNTasDZ3ODDi/TAx/SbEXnAHXILvY3RZhELilPumlo0/gULqSsZhLc/gm7leesjPX0F7N3ZkFjN2y66+psm+LPToYaZd1dvpnFGDTEJVAJfjlgLn5P6+J6st5f8SPtNbXz4+ZKd/1QBuFED7nxTzH8oBhMzkInOpbopakUsKMdgasGQKfT/PHqq0pleQ4ESXQ6bH9G1ygYc4RfyuctH1BAXlpuPxlayJoNbLlB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__pcpu_map_pages() clears the PTEs it installed when it fails, so
pcpu_map_pages() only has to tear down the CPUs it mapped before
the failing one.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/percpu-vm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 509d8901835c..59d3a336a6bd 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -252,10 +252,11 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
-				   page_end - page_start);
+		/* The failing CPU's partial mapping undoes itself */
 		if (tcpu == cpu)
 			break;
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
+				   page_end - page_start);
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
-- 
2.25.1


