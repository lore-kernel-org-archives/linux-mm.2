Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7927260A260F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NgWqlnkR
Received: by kanga.kvack.org (Postfix)
	id 8B5806B05C5; Tue, 10 Nov 2026 06:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CFF6B05C6; Tue, 10 Nov 2026 06:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A54B6B05C7; Tue, 10 Nov 2026 06:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4C46B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA8C412036E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:54 +0000 (UTC)
X-FDA: 85418979828.03.A69AEF2
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf14.hostedemail.com (Postfix) with ESMTP id F38F7100006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NgWqlnkR;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309953;
	b=zeIGmMMsF8DFnuDFYJ6ZB3bgPn/CUnRT1SFJJHGJuDwH07hH3o8XdhGJhfr6UQOMFk5DjE
	q+7rHpgWGab8Mop5V04zeMikIT1lyQFJmusx08HWxGG8BzaedIwBqKjs996ZfoNj5zgzXY
	9fX3i5v9xrExq3Dd0ZxmSHqrDC1rKo0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NgWqlnkR;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXtS8nqPI8bMiiZsI5aMJRhf4Xi82nV2lL/o/RcncNM=;
	b=AkYqX2aoEIsQ7aJRvlhnjKi1I/uMaHWrYPwEVNreKShMJabzMclj5VxZSIiXwO/18tyJ5E
	x+PhOeYxZoqy8nw7P52sV66MHcXh9TMWRgQTofQmZ+x6zzgrqizytTuOxsif3r/gDhvygW
	zCvNdV0EmT+A1RpG4rWdUsqOpv5gG1s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qs+zHZlkyqRDMqx7SNWEDLyLXIGQ6DciwEgGF1OF3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309951; v=1; x=1794914751;
 b=NgWqlnkRqjCIk49MKFVio9mm9PWHktC4BBp1DK7KyfVUifUVLIxERfcDf17sWV83KCpahdcp
 4c6ilH8eenxZmHvJUJWbSzIiYvPLoT+q5CS3W9XMeTDe0nJRkxt95P/RRs+f71jAjRLScYeNQ2M
 g70EFpXAULqpyxoh8lMGa7dk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0846a03f7f9c0cfe;
	Tue, 10 Nov 2026 11:25:41 +0000
X-Mizu-Trace-ID: 0846a03f7f9c0cfe
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
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
Subject: [PATCH v4 9/9] mm/percpu: stop unmapping the CPU that failed to map
Date: Tue, 10 Nov 2026 19:25:46 +0800
Message-Id: <20261110112546.261415-10-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f8nki1ntpofr8fxfyhf5n64c5h7ibz5o
X-Rspamd-Queue-Id: F38F7100006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309952-265019
X-HE-Meta: U2FsdGVkX18Zn1mNWj24IEkUYrWJiqO8zc4VVWDQAeoMCci86arTuNIbtixTOU+GZYes3uOBKW+bVrgCdpqspiZhcI8euZ4MUcBgBB1KVKZc/fS2d2AdrnSRUDSdfGU7tgKfaQeLrBhfZuCTrVw3/Xo19QefmUZCkQL1IqYwgXu+YGKGjpO3HGif2XgvaiqMp2wFwO/Qk5NESu8n1xg+tDlAnxeUeEBxi6DogN7+qVXgxwNik8iYShAghUQqF8V9PhKwDtVCj7LIsHLZU4HtuCMiKSk1j9eOT8OqDQMMvNH4N7FMD+bsqETkv2SdogUYWtqNLf72vOiIVD+BDcDUrYvX/KElDyaQ7OD/VONFS/oPb/0xk0R3/7qd9vLiq4wO4Xj4gZ45uDN02SFJxHT4D2j/Yop91VJ+/b9caRjbKKZjQTvrgOhd2AhS8xTB++ZqHx6DLGQGsa5eQlRY9q81CGuNBR2FcMgTfzXTSgUI39xGkD5VMcf2kxUOXNAxXei7Si/lP6G0N3JQ61be/HmUm19zd6eFGRNRldaMWYqdoJK++uxi/8jRxSP8ParfKYYv/8tjkUbofhncE97fCtu3JjPgBe41LZvqaX6jNy/rYa19z2nocSSaUDm6wFM0f/DlHDdrljrGUG6E72iV8LbGhsaTzpvjCPr0ldKJSoRTln/rBM/zlYrFKSiJbX6ak6wqyB8OP7W1siUxYL7uNz6pEST1++h1WsKovmPgZ4dGf0Yx9vZd9Vc5bUj2ruE987q3jS8XuE8dZ8D7ABAzJwg46zb9ckD+0YlS7g/AyOtdzcaYXwjE9T17vKkoejsdv75dIhswQhyeRPxIrdXVnbit8FMtrR6ufbF2vLoboXexkyB1+8D20Or0gVA52lN8ZdzAUhDcHKCqKXSsjeoMKsBPx8SCeBQMCRNda4PATJC6lRJZ8WweJK3DROne8Wo+4iK2huI4h37Sc7vhu7j0GRA
 /ZtVQMjX
 MCRfZ+qogn0OGGWjN5m73Yn3kFGDSyS8ZRUjBY8cw85hCOXr2GIzD284UsOfu7KlMrfQ8cj8rPLTsNzGKQXKUU4yqMqDFUMmSxL0yEbpcgJOjMTSyHG331/rwFcvkn+dup3cMvdTF/stiiUnAq3vPxg1QyX4gyFhzcwdJeEI3AW29hx4jKqy/BbKghOJXk8NLHTdmqrbe/HKZzkwy006IkW787LadUfI+ZWp22hmK+8SEr0HtSep9KB3w90xoDrW0OvENTBcA8XB4e50jcqYn75ICpuQIyYSfb4fbwRtISTzbLyQLszb8vGlqQVXX2gJxySF2uZC6dANInV9kjWQG0Ga8G0zREsvtiarH
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


