Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2B6606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CFTRgDEB
Received: by kanga.kvack.org (Postfix)
	id 0B0F16B05BF; Mon, 16 Nov 2026 02:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0888A6B05C0; Mon, 16 Nov 2026 02:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0AC6B05C1; Mon, 16 Nov 2026 02:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59786B05BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7846FA86AE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:37 +0000 (UTC)
X-FDA: 85440119394.27.A3A9D92
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf18.hostedemail.com (Postfix) with ESMTP id 921C71C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CFTRgDEB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4xwi4aHh7ZD/bHp2DRcoCULX4dT5zb31C8Z9H6qmb0=;
	b=xrxEjeT84ik9sa97xVL1pst4qog5afLHOpqPmmokbQmT8Ls8lzJO/OswK/ViG4yPI8jRUZ
	ug0drKHqqibmQp2XBLTI0G7yixmYDSQXdVtgyXJ/4lFd5ElK5Cw4cC49RTa1reCHi2rkBR
	MnLjP9dEoWpP65xUkvhkWYAgs/DHLMM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CFTRgDEB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813275;
	b=M+RKp6KRUQxaylmg4kIullUEZM9sL/7S4UUN8OyYpI3Box9jHtTMzddpeAQWunJsQZtX1m
	Xf8Zy9jnJsndxlc+WsNt2382Iy7XCi8cvMHEMgxFd4TWy0MsRq9Cxg11kw0Zk94tDQR21k
	hFVAIXgjYgagwSZxodLk57ZgGJTSxCY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EVDQOgm4eiv05oSXsLTtEpFF+tsRKuMQEvt8DaJEU2k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813274; v=1; x=1795418074;
 b=CFTRgDEBH3j6pmg1ej7njFlv3ud01xfdaOMBaTZS5DBJoWFHZXBdM8Ebo8YkQ7AyoQbXvHJk
 mGFmVZznl5qN2rMEHNFvfRCTsc8E8IoOwvYn28vfB6raIhgTC2vZ47Mamjls2WYuTAi7GiB5cM7
 bwG0TjPRZqKoCRang6O0DWVE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d81b1a6ac4fe3573;
	Mon, 16 Nov 2026 07:14:34 +0000
X-Mizu-Trace-ID: d81b1a6ac4fe3573
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
Subject: [PATCH v5 09/11] mm/vmalloc: undo what vmap_pages_range_batched() mapped on failure
Date: Mon, 16 Nov 2026 15:13:23 +0800
Message-Id: <20261116071325.263682-10-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 921C71C0004
X-Stat-Signature: p4dhq8tc8nfn1tz5wo41mixdbmf3o3qk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794813275-605202
X-HE-Meta: U2FsdGVkX1/7UqM3shcRv4ygnn0GGRT3cgupveIdVp9Y29RYP1lBcEB6JAalAyE+WUnevRGtUBiqUTIR1gpM94ewnzKZshVOE032Daw4mBnbGxnYfsfLWUWhJfzpzvdPEK58gUHZgfDeVS0rXsM995ewbJsn1x+lbzDyYJ3KkKjf8M45R+0TzjFzk3vN5oHAzaJT+LPIcFX/2ECMTONjFp3wueRt6aqHCiSmkMtwp09fgMdBCCblOyjqH+6wQIE9iLny10oD+I5SToCeTJHR/lFnOgMFT5yD+ZW46keBsyfx6c7Wk48Hz59zQywGYoViq3qaZX+Mal9EIRcEPwWY2mZPHrEnk6xrXGneru7+8X8EbAwTBjH5U5S0XxthdQTRtlLZ/aIxuhJAsKG++wBIIOdV243hQzdqEK5+sukO9eu3Tm8a+NurTXaPD9BLCvIHCR/Ftn7XtjwmGY+iwC56oxml/xnkSqAIXEJFmnL01lKQ1qY37KHOeaPAz385uA2tz3Q0ZqcycsSitvlNlfyoNIxPtXoXL2yN8LAQdA6IOJYDp3jadj3Sso5N1FhxEt69BOdP8K1x4PeL0FXH9wyZUa3O8X749mCF5/783hJeuoRi2TmofXCk6yWHYeLT/edW2XOMxx0fvgICF2XvO2opDyaA153xkVVXOZN5D/SsujnTBzMBszzC7auglBAQ9iY6aEivN59jH6oKFYhyQJYFU6axPaKLVkYW76HKm+rW9cCQ+NbbKdw+142sjlwoHTU26KCWYwrTWHSPyVOXrGehV4kz4l0J/JFtF+DCIqwbjQQgzBxk9OGLeLI5gqk50Mcin9F83eiF7RoJU3fSZqbPfbECsSNspFhwPL2gTZ9gLyuatecggFRs3d7AF5gBAj/vc9Zk9qSK07gcSavSvRFA8JenpsGR+JbEX8w1Lhabem6z3fyiycyPoY7IBZFAJvCN6pa8I5B4LyRlhH4RWBb
 8MqkbV9o
 KBpJ3St7PcviTMJXn0wCC1I9iPPQ6KMsDijfWS+vgEnjUT9SA6aDgyXSLyVEkz/Btr0IdrMwF+j5rHBmxSKPnXE+h3THDyUUujlzlD5JITdNk3Sfotcc+3RjDJzfeWnIDzP9NVqvgsMV5TGM5xeRU3e53TudLto56W4FTRiF1sYIUOZmUSmc5U4lsX4gaUE6DzbtOWYsr+VQUj8sFVjOeQ5FtUP016fGieqD3vyHAmGDwKd6OducF3lKjYPaxM6S3OYLudmf+IpXRWqMTjHPqlhn/gPQXGY9hjTFXkkjTh66uspPmLnHVdAQ+/6RSXE2tBpyiJ/2Sis6Us8OxtNrdxBBLqRXJlMhlZW+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmap_pages_range_batched() maps the range batch by batch. When a
batch fails, the batches before it are installed, and the failing
one may have installed some of its pages. mapped_end follows the
end of the last installed page, and the error path undoes
[addr, mapped_end), never past the point where the walk stopped.

The KMSAN metadata is set up for the whole range up front, so it is
torn down as a whole when the mapping fails, like in
vmap_pages_range_noflush(). The only caller, vmap(), also calls
vunmap() on its error path; the double teardown only walks over PTEs
that are already cleared.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 28e65073624a..aa80bc273ec0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3748,13 +3748,14 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
 	unsigned int prev_shift = 0, batch_idx = 0, nr_mapped;
 	unsigned long batch_start = addr, batch_end = addr;
+	unsigned long mapped_end = addr;
 	int err;
 
 	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
 					     PAGE_SHIFT, GFP_KERNEL);
 
 	if (err)
-		goto out;
+		return err;
 
 	for (unsigned int i = 0; i < nr_pages; ) {
 		unsigned int shift = PAGE_SHIFT +
@@ -3764,9 +3765,10 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 			prev_shift = shift;
 
 		if (shift != prev_shift) {
-			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
-					prot, pages + batch_idx, prev_shift,
-					&nr_mapped);
+			err = vmap_pages_range_noflush_walk(batch_start,
+					batch_end, prot, pages + batch_idx,
+					prev_shift, &nr_mapped);
+			mapped_end = batch_start + (nr_mapped * PAGE_SIZE);
 			if (err)
 				goto out;
 			prev_shift = shift;
@@ -3786,13 +3788,21 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	}
 
 	/* Remaining */
-	if (batch_start < end)
+	if (batch_start < end) {
 		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
 				pages + batch_idx, prev_shift, &nr_mapped);
+		mapped_end = batch_start + (nr_mapped * PAGE_SIZE);
+	}
 
 out:
-	if (!err)
+	if (err) {
+		/* Undo the part the batches installed before they failed. */
+		if (mapped_end > addr)
+			__vunmap_range_noflush(addr, mapped_end, true);
+		kmsan_vunmap_range_noflush(addr, end, true);
+	} else {
 		flush_cache_vmap(addr, end);
+	}
 	return err;
 }
 
-- 
2.25.1


