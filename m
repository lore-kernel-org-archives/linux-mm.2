Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF03E606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwPJ9S4t
Received: by kanga.kvack.org (Postfix)
	id D86836B05B1; Mon, 16 Nov 2026 09:12:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37396B05B2; Mon, 16 Nov 2026 09:12:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C261A6B05B5; Mon, 16 Nov 2026 09:12:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A07AA6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:12:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2903CA8707
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:12:35 +0000 (UTC)
X-FDA: 85441172670.21.C8BDD16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6AC2CC0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:12:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwPJ9S4t;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794838353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+dmzKoW9rqQ/GFF0qt6AUTCWAnyMLfoMYNhlMKd90Ao=;
	b=B4rypymLkdHTOPuasSTb568olLhGy7KTiaBH7p7xiQdZAs+uAebbTwCd5eBBKBMqmA4GhB
	0SyBNXmaR7MAcGc1fr8Naqcl004edwTzZcUWZ+kCGoP2IiSen9cXGXHeFsfWI5z11syKhK
	XprWJJ4v0h0mrVFckFVGOCQzvRRggbA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794838353;
	b=a2B8mocVRCIiAoMCeyrfmRrSFxIw+I5Bsd8hrKP9oIUtMyXCmgRjaZR+I3TsaUTXbSBoqz
	25A8nCg4EggOaDtWfQ8tpksQeqhY15YTNd01TwdNrcRWpp9EklztxunvjAhtaJF5coDhRE
	bLflyQ09IDrgRADMXzhBHm/hA5JuRT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwPJ9S4t;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D25E62C60;
	Mon, 16 Nov 2026 14:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72791F000C4;
	Mon, 16 Nov 2026 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838351;
	bh=+dmzKoW9rqQ/GFF0qt6AUTCWAnyMLfoMYNhlMKd90Ao=;
	h=From:Date:Subject:To:Cc;
	b=NwPJ9S4toer+MZWLv9AL252Uy/YxDC2arIwhOOTfzI9UAD5n4Zfy1g6B2y57eiCKM
	 RKqEV2TODOQwoQqILNAmM5kxbL4U6KpULDqCgGVp1f9bxAY1G0vnRFpTrOK45JLTPO
	 i1dzS4zcwix/L91sLefxMGLEg3GLYWa/TLD6mua8oi/bg+QzxFTTni3651bNLCQ6Vz
	 R2FPzW033/l9c62TtfvjCMmAyI4Os2uLHy+8RO0B35+NppvWRnvfaP16EYPECtwU8h
	 l9lg72CE5D0N5Tg4JCz9Ha+tKShCM2qFYwTA4Ef0HjH6403tHABO2Gprf7bNowkDvi
	 cceTCIxHAoavA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 15:12:13 +0100
Subject: [PATCH] mm/util: fix retry detection and handling in
 snapshot_page()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQrCMBAF0KsMf92AUzRoriJSYpy04yINmSqF0
 ruLunybt8GkqRgCbWjyVtO5IBB3hDTFMorTBwKhP/Semb2zEqtN8zLUOMqQdXU5Cp9P4jldjug
 ItUnW9Xdeb3/b6/6UtHwj7PsHXPscFHUAAAA=
X-Change-ID: 20261116-snapshot_page_fix-fae185e61c94
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Luiz Capitulino <luizcap@redhat.com>, Shivank Garg <shivankg@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Shao Mingyin <shao.mingyin@zte.com.cn>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2764; i=david@kernel.org;
 h=from:subject:message-id; bh=oCOpJKthFANmJ/4lv+Nsq0+6JUVPxiCs7IZPnL+gr7g=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+8zucO6spVSgjlyJ3pUu780n0QtvlR9d43uXcflYqf
 cnpo5mvOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiI/ktGhvWxsSfEssvPJPM+
 uug9wfzImusp73YYb93L4+vs+jfufDgjw76Le6+ey3kqZXP3ADM7R2FfzJE8vwW502tfZu46bHv
 JnAcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 6AC2CC0005
X-Stat-Signature: mbegjh74gr6cq6z98ceggf9nyr8i3x6a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794838353-851435
X-HE-Meta: U2FsdGVkX19PYkkvyJDXKov7DSP0Y1NBmvGMqrAJGtxo8s8PiLVe6IK+zt04dc88xZZsdX6bfLDLgcuy1clAzZqkLxVINQ85V56nAz1/VMo0La+HOvEFBA2xDKWvKqUj//xSonhuGquVsGOxtCyebDDsmPPTSX3AVYUQCSGFQrjFdp52I4euTlNRC/hNZZw1OTQ1lNcIRCKFo0v2LctmHfrs8QmM4NNhkw2rWuPXgIm3jcIwqwzCs36AAQQhe6jJOaP5zgWwir2cuauD31vJXAtrzzJO736ouq1jeByHG0LVc93kbU850Qw11SG0jow0MiZlOHm4qWVz6kwvb0v2XwmnCGdhZEcVoOnwEY8V72zCAq4AKlmPJeebxGssaA66GSrAml/H0cJZT9CxypQUEcyw2y5Ldc4Wc6uIWpiMYiOU2dUBUhopKsTQWTIaDvai8igP4KDVUXxIxsI4PY4CrR28u7oyn3FiHEQlLM1jB1e3nOrQl5iBXh2VZleNlHkIcoYdt1vSlWus/l2t+voGEI7WRiC5Dicinx10y688ngaeAVTeeJebOALEURhCP+r89fkRJNnzAfkSkvqyCu7SJVOrEYuAdshfugDwQfYFKVmkvn+1+g2sJsPbIva3BWEUF5IfoEE7WFKWXvbAE3Oxv1g/K0wvJ1WqAgwV215tZKiX4TUlXeAsnlcxRpvZL7HKx61XhDgOL/QF0fbDXzpxKQiXF/neJgmGLwaT6do4a7Z42PF7VUAU+UDju4TfLbEoeWn/a6AMO1395Lh+NpIrZdXd7PxCWz2IVB8RPQz7PUh4CpeM53VCiNk1+0NN1q2wylOGjFbXZfImIGmj4V3zpPMCigofOuV/yGH66GWrSYkqwIBIp8VYlzWyPG0FA1rjqCOmss2kMGVGV4u/h09wXA+bl2LhpJkniIBljFymHCQtyzQmF1LtK4w311iCHM8xx8gc034ZpPo5shJHEtp
 F3qyp99x
 +XK6F1A5i7w0pcMGf/dO/7o4ZS63XRAZ1bgwUCXNuBvK8KDVlu6W4BAN1sZR60E/+1evGy7FyD1KQfdSsvGt9x963CTKgtOP4r3mpCp/dY12kTxDYL2ZnahLKJMP4Az+VczzAk2ESdnesEpfpYg2Zi554U1a7d/DO/ZZ230JmDS3AO30htHEGi8q62JxprGWZ7lxFxvyuLuNOSZRkFnRlxhxdzD0oy3otXrxSJCLNkLRuuHkcDpYQKUKEWWiIVEqT1ZEQblriahOB5q5lc4vZHGsHRIVvmCovNFu1XpjdrYZpOPfa17pUooIFnMivNqXReF8216NJJbazhtTkVKHpc5dGVyp76FZ9QrYX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

snapshot_page() detects races with concurrent folio split+construction by
checking whether the given page still falls into the folio. Unfortunately,
we have an off-by-one error in there, and we should be checking for
"ps->idx >= nr_pages", because idx 0 is valid.

For example, we might currently report a tail page at idx 1 as faithful,
although the snapshotted folio is now a small folio.

However, there is one complication: As we don't hold a folio reference,
folio_nr_pages() can return 0 on races (or when called from page freeing
code). Handle that by just setting it to 1 in that case, so we don't
wrongly report a head page as "page does not match folio".

In addition, we should reset ps->flags when retrying, by just resetting
it to PAGE_SNAPSHOT_FAITHFUL. Otherwise, PAGE_SNAPSHOT_PG_BUDDY and
PAGE_SNAPSHOT_PG_IDLE from a failed attempt could stick around.

These races are fairly rare, so this is not really critical, we simply
report something slightly wrong. No need to CC stable.

Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Closes: https://lore.kernel.org/r/20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/util.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 80f6c714844f2..338f259b00351 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1406,9 +1406,9 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 	int loops = 5;
 
 	ps->pfn = page_to_pfn(page);
-	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 
 again:
+	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
 	info = ps->page_snapshot.compound_info;
@@ -1437,14 +1437,15 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
-		nr_pages = folio_nr_pages(&ps->folio_snapshot);
+		/* On races, or when freeing pages, we can read 0. */
+		nr_pages = folio_nr_pages(&ps->folio_snapshot) ?: 1;
 		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
 	}
 
-	if (ps->idx > nr_pages) {
+	if (ps->idx >= nr_pages) {
 		if (loops-- > 0)
 			goto again;
 		clear_compound_head(&ps->page_snapshot);

---
base-commit: d164c7d754f0e1f020298366ea92430e62476089
change-id: 20261116-snapshot_page_fix-fae185e61c94

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


