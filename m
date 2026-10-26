Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48FD60A3806
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtrBeArZ
Received: by kanga.kvack.org (Postfix)
	id 78A7A6B05C7; Mon, 26 Oct 2026 05:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760A06B05C8; Mon, 26 Oct 2026 05:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E3D6B05C9; Mon, 26 Oct 2026 05:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7446B05C7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D4171606F8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:49 +0000 (UTC)
X-FDA: 85364285538.26.B3C7DDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2CCE10000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtrBeArZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91PytXVfbyE07JEL/+LQiSAiMw58uzuZZkwQELyO4Qs=;
	b=OK+agaZmbjDKYyM/iNc5jkZVY7sReHJaJXTRlPOoUYeG/ZKDBAW3I1GVMNJ3v82DBne6xW
	DoJAMwlI2u4afT1YdGi9vvnLyLJheFqhnuiwCcnAX6GyYt1Kq4Rpk+KydvFRZ8B9R7sfuf
	JTBckpV+dv7dc4ruTYl/mZKqSZZsROs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtrBeArZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007708;
	b=3flEBtLhwHpAq9CrhFwvjaCkO4EG1Fatud1GyGyV4tzHNcmT3qq2KP/ErqEwboytuIEczy
	BjbGW7J4PeFUyPy5N1i3S35KzNHKBY8J0ItvD0vVG+NMTpzn55iGkY09WDycz6gORMOXAW
	RghWh2fxpM9kE3saLe14CjlcaS6J+cA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EEB660A5F;
	Mon, 26 Oct 2026 09:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF01F031E1;
	Mon, 26 Oct 2026 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007707;
	bh=91PytXVfbyE07JEL/+LQiSAiMw58uzuZZkwQELyO4Qs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CtrBeArZuEDEQxETWypL5shpYNMU+iQRLlhoPGUUtOMb2TB1+kkCdwf0iRIzGaAys
	 hgPIC7O6i48DC+LlcrQabtn48NIdojoLdF6szMuWm31r9koBb1sNjDdnQ5xUcGZdvo
	 8zzr5O+9eaps/RF0pjeUHJif+nmHzPxIakdYulQKN0P+A++aScHEHvvcy5GtGlTvqY
	 6dH4eS21KIeQC3g0lJK/i8djRAb7MOmEeCrjwA9Uy/p8fsgfHDSyWH4VfoU7Ce2GWv
	 Cmzk8k+En8Zv56Wzzv/9YdRHzEwUl9hDh72Z/sVRIvBUPJZqo/HP/oOjnuNYFGwqnX
	 ZdoZoWvdef0Fw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:41 +0100
Subject: [PATCH 08/16] mm/shmem: stop retrying folios that cannot be split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1652; i=david@kernel.org;
 h=from:subject:message-id; bh=tnGXb7Z0f1hnh15T+i/nb2LT6YYfAxsDadBlf2K3IFI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4gfTPmpcPvHXLnZeZc2335qwrJZdJmAXYCd1r91H
 zXl1ryc21HKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEHB4z/LN43btSrqDj8JrH
 M6dfmr1OLrL5SWrXTI3ND1NkJ11PUN/PyPBi6sos3i17QpeHFp+Tkj7/Ut2wWnqXc4WsiGm4WGi
 kCDMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: F2CCE10000B
X-Stat-Signature: ntg3c6makyqgsx3adz3ucbdifxhjtqd5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007707-298627
X-HE-Meta: U2FsdGVkX182Lq9DAzMQGMnWjmuJ03bq2LGfJ051zugOia7t4+xfyOW4DbNwMgItNYwtcuFqjQxecrePANrj+lN7pm9fTrDoAIZAAcOJy0MB0zgWu4LKTBrN1PhWUNk64C+lIUHOQNi3D0hhLwv8pXKMh4C3DYIli0Q0fzrCjgqJt+GK7llGm1Nm38Hn2nhqzlFDCR3gu6RD5HkB++Lnm2Tfgjp/e1DDDcLuiqrCbMjcBr10P62A+cMEoGtnmB8BkkXGg2+CVfcank9ArgeFOlUhAiB1lhkhKQKHF00Vii9ww7QFEz0nfSBKsVNx8ljJrc1C4/y2+hFjsTLExuyBhw8/z0xbLyT8uLmS50g9brIWT4fWOqA3VRVqoIGUYwSpaWD+spfiWBtHqKCF9BhOllHUuorr31Yg6M3fw7d763ACfitoWp8WXn4qdyuI3YfnucNZP4P5HgU67tqHE1pEucRYbH9LBsdDTwm3q7bneAPS5lhppf3VCPkEwmxHuuzStkZUII4IaxfpLfHKSQ5OhFLdvw/dSEg2PAaYDgpoOzMwN0r9/DTKZO5TJpBGXEF2PUI9SbsBYtKTzqZSPvm4dhE0TjC27DkqiR3hWXM8fziAkl/vnOYNIjvRYvTFgAlkV7fk3tInyuDbO2OBxwa/WaTKUIyYi0v/SXHfJdyWOh18t87RDPc5ZHcpLDS1r047Px7v+Prqg1LHbcXQ9KC8//DQ9TMdMqBOGR35LpllMi/FP4MxEsek6VspLIpQ9Ku4f5l7nhhpApgmhh3FQRorvG/nhKz6zemIjo7eYO+OsFnS5DG2GtAzdA1Vwhw4sBfmZBPstjfks29J7iZ2WX3dV0e2bEWBDJSdL5V3ojvCR7csOtAAip0Fl3LU4hCKROp3xcX01Bt5SM9RRufTYmXVi/KUs5gFN/3x93MZbsfGsaqCidxLjIk5EwtM+OvsoU3D5SEB4QBGO43kM6QAUUY
 cKLJCt5O
 19EnzYj/63c+LE7yY8nAh1XzczUcaLTNu07NFiduNIItIuXpn0wOurIF3/zxHcmImdzdNV657K4R/GvMGH9ynhF1bTUAKbB6fB3aXfbMdWDpKanIma+fHvVt9Ft6X2nz5hUdVlPG2UFyB2QRhPAKaY5oC1DNiIec4Gf/AqUJlvabwY8qK1fsB09g2gs/oJlOdx7NGJWWUNiqVYHRZO6eLKRBaL9ae6XMwdYDtbdmcEuIhQ/M621xxKYMqL38cJZTrlolk2CrAZLWwbkyvVSjyRexpUF691ybKIcZzM6q91xOiMoEjsP8Gaus4LXFVHRyZPltf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A fault or collapse can insert a large folio crossing EOF after
shmem_undo_range() has handled the boundary folios. If splitting that
folio fails, truncate_inode_partial_folio() retains it when it is dirty.
The final scan then repeatedly finds it because it restarts from an
unchanged start.

Truncation keeps the inode lock and ignores fatal signals while looping.
A concurrent unlink() can then block other directory operations while
holding the directory lock and waiting for the file's lock.

Advance start past the retained folio, whose truncated part has already
been zeroed. Do not move start backwards if the failed split has shrunk
the folio.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: split fixes, simplify descriptions, adjust comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2410ec46ee1d1..e2c3b04051833 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1490,6 +1490,14 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 						index = start;
 						break;
 					}
+				} else {
+					/*
+					 * Splitting failed, but the part in the
+					 * range is already zeroed, so skip this
+					 * folio when restarting the scan to
+					 * avoid retrying it forever.
+					 */
+					start = max(start, folio_next_index(folio));
 				}
 			}
 			folio_unlock(folio);

-- 
2.43.0


