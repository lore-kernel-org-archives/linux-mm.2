Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6D5606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ypfUFiTb
Received: by kanga.kvack.org (Postfix)
	id 164646B05BA; Thu,  5 Nov 2026 04:36:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115E96B05C0; Thu,  5 Nov 2026 04:36:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0062F6B05C1; Thu,  5 Nov 2026 04:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C572A6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:36:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CE6F1A09C4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:30 +0000 (UTC)
X-FDA: 85400560140.27.F7396E0
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E8FDC0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ypfUFiTb;
	spf=pass (imf22.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871388;
	b=fg1//oOKx9YN+iXryXakQmbvVqVG+O0+EG3jKi+ASEdaKRUMdmKsa/iOVRpkBmcLUcMZt1
	JiXuVhO1XMSYpM4qVB62sxiEwK3QYgMYPQxglw6fqfr84Fu/3UpE9p7h1hRp8rM3zLys2O
	eujjRAv4Hb5sXzA9gKHOymENbBDd190=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ypfUFiTb;
	spf=pass (imf22.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KJTaDWQfowBpNKiHyeX0a8ZzSqnSx/3I5gx7OWVH6c=;
	b=7fWNhNQx20JWBTe2O85fLvrcY7+vVU82cvHiArDYaFewF6DKNNlWgZ/iYMMMlypKsNyHfI
	+pcpHhKtoygVTpqaZBy3rAXWlEfnbq0pDgAfenbtKQYlDeE4qcerG1mRfhkvMgl5tq/9bA
	MUrSPSe/aXe3vNg09U7f3NxPKz6hGrg=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1a2af4c8d00so308818c88.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793871387; x=1794476187; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4KJTaDWQfowBpNKiHyeX0a8ZzSqnSx/3I5gx7OWVH6c=;
        b=ypfUFiTbDqyilUSAnSlPvLSQvggbYbCgwjFSyY/WUgqXc3qrkhFwfNzvT26r1/P7jo
         PiTbQz5k88fxqJx+bXT57RcvDLSVWnMGx/C+I9dy0DJ9F5Qy+fKURfyfurLxC9Fg/0m/
         jk47mMZEu6t+/BowPnMzHdaT7pFVwhGr5Za3WiNMQanAbzAc64+ivjhmqWH5Sl2y17u9
         QPugVV0c8VWYUCxy8dhWROx+K/47BgsrgH1A6LXhDt8+1uaH9oKTs4anUj/RFoG/Kx+Z
         DB0LCEBaByp6ibR4TcbMr/Vdih+zFMHOf1WvpnZFkarewEDAotEHdF39YeWkbg1rgjMg
         /xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793871387; x=1794476187;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4KJTaDWQfowBpNKiHyeX0a8ZzSqnSx/3I5gx7OWVH6c=;
        b=f+roTqM/foi7cBXQqUNH6qWoalmQyzozE7EhJ9NIUk7CiBAH0zONVfTlptITkVbm3n
         K9BubMtqRHhz8wyHS+53la3elKkY+YVJPdM6D6r+puKenRblJwqq1nbOrE34ulDQtoQk
         oY5gQ5ScIq4PMTCQKkZuimci9fsaWjnWlBupcbMbkS5Vj6IraTp6L+2V5nX244Sln2Yc
         S9kqkOIju04ddpQVsde613M0IvAFcU7HTSaPCIIfUIoL4rU9MUpTSqWJdkn4uMh9hnyK
         0g7TXVIgrG7nfHbIzDzwvMolXxvVcp8Mu331MA/KZYewEaYx1QOTyGBx3cf2G+W+L1yV
         Ymvw==
X-Gm-Message-State: APuU4Z+zEJgG4rZV3UAArVLKTdZkHw6nE+PcieOMthxDcmQ0DABNJRyP
	KQMBpso9N5f8+moo4oCqEo/xGBFiqC8Go0dUs5ykr8yZSBydFRySoBPS
X-Gm-Gg: AYBFou1o3vYYwVlbQXi+N26jL1JJAVEMbuODLKMzkbaTdch+qTZNIGUqqfaFkPgckWC
	LhKJi5RFfg/TxTiZqtskRA2Fu6YD8TuJ5oXcrR2jPrIBSkxvSGWdtwnP+Oa8W2LKQ48W24RWHFq
	H5cUSvI2oG1mPBs4uxK9r9e82vCXbPrhgExDw1Nj5XX0CWgGMR3WykaU+Syuj1v+39rh1urTt8N
	xqi6u2EseCfDk4aQcp/8d3MViScDq3sp9GFOChsERObiLtqH9n7z1cpG5ITAlRGSpTb6L19KaMe
	eAggEQMRr4iQ0FkgnkrBfWbm4S7fi4T71LJ7bm/bXPnpesg6QlScIjDDLQQ7rLQZvhvOHk+C1+X
	Pl4/HlFFVH1e1XtcUgnpFp/cjF/LC9dFPddLijbI0bGMrUIgJLptSTwqWJDwIBFr/vjP0aXA7Nz
	QJ7KKW1Vhl1P32jf6quECGreNU4dAsGJ0+edAUvxhzpLcqT0NCopOeyyvRCpvOdbMyDNC3Yw+Xh
	AJSQPMpjGt0BfniUmBKfEy8sk8kbkmwm0EO0/MKY040gfMDhJKfEO9cEHHQwz4ULlVBSnhB6lS/
	ToHg3c97YbPmOCT2jpnOw1rV
X-Received: by 2002:a05:7301:160d:b0:36d:dd5a:4528 with SMTP id 5a478bee46e88-36ddd5a4f34mr3326051eec.7.1793871386171;
        Thu, 05 Nov 2026 01:36:26 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38fa273sm17363207eec.16.2026.11.05.01.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:36:25 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 05 Nov 2026 04:36:14 -0500
Subject: [PATCH v2 1/2] mm/ksm: align smart scan skips with the scan number
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-1-8a9780b6844e@gmail.com>
References: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
In-Reply-To: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8E8FDC0006
X-Stat-Signature: bdp13y4tipmck9phbbtojeitu3mso6hp
X-Rspam-User: 
X-HE-Tag: 1793871388-701438
X-HE-Meta: U2FsdGVkX1+dI5S7MkhawTt9DZLjtEHimkY/1B6jvJidNOlqetjW+u+LXe83Qck2eiuHaTyKFWgp0aHwK2TSrMzU4OxB7oTNcj6jyI+c3A3y+BAVeYS/lwBRfVshSvIDUJxGcCLEGtET6OwUNPT1ltHQdHY6EmWnEjp/QtYV0HtlNnzJK+ItZ8ieAsC6I1dA5v+UR+NjnjF9S0eKpENxMnW+d/IIXJg+fjCFAtIzj3zD7Iy5eH2VMCLDaEOmLWngruGTRFzYsv6M+ZOus4WMhvLkJ20Z3erHwbnH2PJkgBAYgNbgbicZiYKTNS4P0drXtFZX62/V/RNLYWuX7+sXGUXT5QpVPm4yqdl52CKvheX4MgZ5GRHErCY7jt4EdWB0pS4HCDiDsWHPEwTbXXdJIHzp18wz/9dUguRq9iKyttbHw8BBU8jJ/47+K6FIdQ+GEUIMzocYcEb/x5/vLCEJxi/Rw6dtJo71zoY8i/3+8hxcwNJRKQSv0gYWDvpfkpgO2goskpLoZxLqpxIkfstyKj9x/cCTmTecPxbKvE/kxjdBXjyii9zsu2oC7GKREhTiU/vGikHt18e+ThQKm13pj/sfmIYrija9GPwTYq9hkH/thpnmRYPILi01LYre62IRzunJamAynbh3eLe4+BO5BcYpGC+kpBmQHBWQNJUW1EbztUy8UZHQ7vM06hd2ik+RMrwnZyoR5ahCSoBWwpL+CWJO2Z0lmKzYlMNAzCVhDoAn/QxgjCLHJvTh1yLinpJxtnif8pWhHrrO9iU0psNycfNGLkn963HfcDFYxSNJbd2rtEZfxSo9qJPF55Y0PZ3+pZAoM+pp7BjjXFkdx8E+aC+OjdyrG9NECeLS0L7ga6wRCDV7mdkOZQKmks2Ee5uLfHEcyBZ0B5jv7IbzE5vJHXHD4Ryf4T8VEgdOj2NNeRkWo6oeURsXYrxHQ9AGwCL6wtgsyx+msBhzycbXOKz
 2FyLIy8b
 bW+6wSomnXXXZuhXlyFi8G2RcqKkku7KaHXjSevY8a/AKB9ZlyQq3+jaU4v+EPoyyVN6FIO0stqfejvxdVIno0Ch4j9j43nGRjUvdFinhBDCNhrgesalwhCrcFeQwTOyYWCy7mru7vrlZHa68cLqMVaDa5akZ2vnkW0Znul0A7j6h72SM30Jj3Vem6L3oKvzjvwqy9HXYkKwGhqfh5xNtftLDko/7miJq9w2ygnnvdKNmE/EN0gEbR0NUeRwoiMH1/4n9o/YMJawzbwSVLadXinWOZalukMgBOjcCyTqF/wm1XDXKkRI81HnxfAmUjVZpHPzi424JwfkvtJYqfzzJmgPHj39+rvgFlzAv1FlQ8jaN8cjdq82hKrtJgciU/z+pFuNmbibToP7+GqK844wn6tTzM9T7O/wzpZ1diV1lAwo9uAIccACGeBYBfHnatibQN14pICeEAr/DS9JsmNGeRYocTJewsM5F1n/yPWMZAfryswhZ6l88CJk2Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Smart scan skips pages that KSM has failed to de-duplicate for a while.
Once a page is three scans old, its rmap_item counts down its own number
of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
at every ninth scan.

The unstable tree is rebuilt on every scan, so two identical pages that
are not in the stable tree yet can only be merged in a scan that looks
at both. Each countdown runs from when its own page became mergeable, so
two pages that became mergeable at different times end up on different
phases and, once both are old, may never be looked at in the same scan
again. They then stay unmerged for as long as they live. Making a page
mergeable, waiting for 0 to 20 full scans before doing the same with an
identical page, 20 times for each wait, and checking the pair after
another 64 full scans shows this, on two boots per kernel:

                                before            after
  pairs merged (of 420)         329 / 317         420 / 420
  64M of unique pages skipped   89.0% / 89.1%     87.5% / 87.5%
  ksmd CPU time per scan        6.25 / 6.25 ms    6.88 / 7.03 ms

Pick the skipped scans by the global scan number instead, with periods
of 2, 4 and 8 scans. The periods being powers of two, every old page is
looked at on each scan that is a multiple of 8, whatever its age, so any
two pages meet at least every eighth scan. The longest period goes from
nine scans to eight, which costs 10-12% more ksmd time on memory that
never merges.

Fixes: 5e924ff54d08 ("mm/ksm: add "smart" page scanning mode")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/ksm.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b1892..a97d7563c2124 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -196,7 +196,6 @@ struct ksm_stable_node {
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
  * @age: number of scan iterations since creation (unstable node)
- * @remaining_skips: how many scans to skip (unstable node)
  * @linear_page_index: the original page's index before merged by KSM (stable node)
  */
 struct ksm_rmap_item {
@@ -213,7 +212,6 @@ struct ksm_rmap_item {
 		struct {
 			unsigned int oldchecksum;
 			rmap_age_t age;
-			rmap_age_t remaining_skips;
 		};			/* when unstable */
 		unsigned long linear_page_index;    /* for reverse mapping, when stable */
 	};
@@ -2446,16 +2444,14 @@ static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
 }
 
 /*
- * Calculate skip age for the ksm page age. The age determines how often
- * de-duplicating has already been tried unsuccessfully. If the age is
- * smaller, the scanning of this page is skipped for less scans.
+ * Calculate how often a page of the given ksm page age is scanned. The age
+ * determines how often de-duplicating has already been tried
+ * unsuccessfully. The older the page, the fewer scans look at it.
  *
  * @age: rmap_item age of page
  */
-static unsigned int skip_age(rmap_age_t age)
+static unsigned int scan_period(rmap_age_t age)
 {
-	if (age <= 3)
-		return 1;
 	if (age <= 5)
 		return 2;
 	if (age <= 8)
@@ -2505,17 +2501,17 @@ static bool should_skip_rmap_item(struct folio *folio,
 		return false;
 
 	/*
-	 * Are we still allowed to skip? If not, then don't skip it
-	 * and determine how much more often we are allowed to skip next.
+	 * The unstable tree is rebuilt on every scan, so two identical pages
+	 * can only be merged if both are looked at in the same scan. Pick the
+	 * scans by the global scan number rather than per page: the periods
+	 * are powers of two, so pages of any age meet on every scan that is a
+	 * multiple of the longest one.
 	 */
-	if (!rmap_item->remaining_skips) {
-		rmap_item->remaining_skips = skip_age(age);
+	if (!(ksm_scan.seqnr & (scan_period(age) - 1)))
 		return false;
-	}
 
 	/* Skip this page */
 	ksm_pages_skipped++;
-	rmap_item->remaining_skips--;
 	remove_rmap_item_from_tree(rmap_item);
 	return true;
 }

-- 
2.43.0


