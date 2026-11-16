Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA49606A336
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hwW9YhVo
Received: by kanga.kvack.org (Postfix)
	id 19B476B05C2; Mon, 16 Nov 2026 02:14:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172FE6B05C3; Mon, 16 Nov 2026 02:14:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B02F6B05C4; Mon, 16 Nov 2026 02:14:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7F856B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A6C140910
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:50 +0000 (UTC)
X-FDA: 85440119940.08.731C4F2
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf16.hostedemail.com (Postfix) with ESMTP id A034A180006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hwW9YhVo;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXtS8nqPI8bMiiZsI5aMJRhf4Xi82nV2lL/o/RcncNM=;
	b=LUM6UNJvhX5jY1r/oWBVFCb7lrnd5qUYFyqukG/ni/RlfSuQTzZ490PPKOl6L0asOK6SwV
	dJYPkZSj2g/8bnCUKzokVuX/N6Q/CB1e1iwltPfUKau1rAbQu7gTywidsHbdcRI3POjvi4
	IV+ClXnvo/daq8N4qqZaO9SXkTI0KeY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813288;
	b=rD+NrICTdd/yZ9wLVi+UIbsMRN1BkbaOPpOibqswgvStBA+olvLwS7OeGPXk3x64V3E6za
	w3MFgbvyPg3nN13MaPrGp9wdP04wBXR2c0g8fetNK3V9byLz56HTuZw9W6wpqeWSHxH3Cv
	O878mErrBS7wyczdbEQ0BMScfPKn3kc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hwW9YhVo;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qs+zHZlkyqRDMqx7SNWEDLyLXIGQ6DciwEgGF1OF3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813287; v=1; x=1795418087;
 b=hwW9YhVodGXQJ1SMJ5tKIVZJv+KYSxSceP42gqINXso1YdzeZOzoS2c40U1gZ5n9WTR6mpmi
 ChJMcf4AMP59hs1b8XuGJ/ouZsWslrs4xAfKddroMXyez2vs92fd2aBSySV0bXFVUbj16QE6IRt
 Hgpl1RWjbZEYXUnPam2X1Vvo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4fd46d42d037db8b;
	Mon, 16 Nov 2026 07:14:47 +0000
X-Mizu-Trace-ID: 4fd46d42d037db8b
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 11/11] mm/percpu: stop unmapping the CPU that failed to map
Date: Mon, 16 Nov 2026 15:13:25 +0800
Message-Id: <20261116071325.263682-12-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pb3tww9f5xucyepdrcznc93sbwtmh39n
X-Rspamd-Queue-Id: A034A180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794813288-681511
X-HE-Meta: U2FsdGVkX1+Y0/ZOSlyrEu/uUvxVoVnhQ23i9h6hMfNf4zBV12l92J3os+ePEWu4HLmcYKDe7Qy/CWzG7fL67XiayH78SnWm4QxI368iCo0rGZjmbXMpAYQnWWbRni1Y7c3s0cmwwMykcKMZy2iYTl/YPQ2brtsq6ZEYV3GDaH+efnOjZlrGQifCazqvnIQtrkWn3KJ5HNRXc0Xbyn+oDOvikDu5AhiAZXl7ZtT0DCrphymISYJcM5iEa1gpCiB9F1yE841jXME9LOg5jObaQAUeupR84000S/b4XyemfDBbQO2cAg0elxTjPh3lPuaGbuwGMhXgcZid/CshIVlkyOKPtJahOhRCSUwNmSBnl26CloJP9/g9WBs3/4ngykbghDCf4h1pfhydCCNdYPAY3WTKLxf9LUrEFM8U13GZ3pWrQBgiQsvhmT40WIi2A5fniMMKnVIhqzW3BwXonJtsjHZOQEOkMsWwmcieHOTfkDOvQg3U7Ef8t9d9xE7IomJxn/ntc+YneWiYujEQMwDiGNGUknfxfAntB6Tk7xTIaCsnggllp5vAxobK5Gm1M95325rjHiueeK32rwhoQVXRb0jpV3dcCyp5Gmp9ScYy2qSqDykBAay2jyQ5C0g5isNcctC096ETHtPlqbrhZ5T6gJenq5u0fw8nFNkl6WafsI2XUTyYAAEC5QgglrzoCHI175Y9Cw4h/hW/F7tc9J3BHJN8UvxqmW+6v8b1BkZaFCgx+Xns1V20M9yXsW/XREfLtEB8eEyLpMwiU8uo6e3onWffqe7Zq18cyzO9FW6n/LInzQB14QNzBZoKyvMKEjoyws/76l8xTwhLlJ4E/DVmeIyxixBwrj5I4zjnLqVYAlryd11Dkq629Fj8Gd1PRySvqdj013G9sy41mKa2tyMM+qdeIfkBShH2nfs0X48NIspor0fCfd6YH215zHbyPH8prrKmighs3gA1T/J95nf
 sXnqAKw8
 /lfXABSSEEZZWK2u5aDD5VwWZ+ElFXXR3EaZPPlj/lBTcJoRoqwGZ/BdwHMaglxM2vzwDGvTBx+JwQFFm4vXGqKmaA5YYmH08qYQoWI9PXZNB1GKtdXIjkFmv2AbUmV4aGPV4v0Iob2inPg8GMHrOn77eYTZYBLAqcqjoaBtmuvIWxbVugP+V1Oi3c5sns7g2Z7I9V3MREoZLyeVpZNxq6MyH7YCx7ux48e+SBachyJYfVWXu+z8+uBZXxfGclRdWzTb2pCQq3BUkbAjLCu4EU8B44N+oFMMfg1vU1A1kHBxA1+/feGiYrVHVXeojxs7qefK2hGW2LM2TgV59rpFer4hDRIi36iBSJ2Ki
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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


