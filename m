Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D556606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UlSnMms0
Received: by kanga.kvack.org (Postfix)
	id 036876B05CD; Fri, 20 Nov 2026 05:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29356B05CE; Fri, 20 Nov 2026 05:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FF56B05CF; Fri, 20 Nov 2026 05:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAE406B05CD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:34:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25588140E2C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:59 +0000 (UTC)
X-FDA: 85455139518.23.7ECB0F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B411C0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UlSnMms0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170897;
	b=OqAq4IEI6DLNaHu7ZTL0XseGssBAa932HXRjIlR/9c7hYEfnHual2Qppgbs5YIHUj46yVI
	osQUu4YGgFQReJm1fDab3unOJalaKKieD9B+RlwtYJgQBy2rDdYjKTo9/4/PvCyfq6Zsll
	MGRLgklym9WxcRXZXMoeaiNcUr1UCwI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11nDEItDnEf9IWVwIw4QwOtVFX0pVzD0C56dS2T97Oc=;
	b=gQ8Cbzaj9B/aeLHc0yM5iDIH3eoHCjC9XNYtZOuZruOUzdEa2LaQeHD1525QVrCiMC1jJv
	xdzfgtZMvXaS7xGlL9laLP/LC9by+72nQS872Uw5VhkhkBlIgU2VAvmFEfys42JcTH6I6A
	TLgx28wx9y7efO0uGLTsmsgTeByxvZs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UlSnMms0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9954844443;
	Fri, 20 Nov 2026 10:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD4E1F000EC;
	Fri, 20 Nov 2026 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170896;
	bh=11nDEItDnEf9IWVwIw4QwOtVFX0pVzD0C56dS2T97Oc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UlSnMms0vGikcAnJG6qqdFJR57dRq1vs5dd/Idk8ENnyAlTpNH/ktQvw6UuTEehmg
	 deVXXT8QFsBWEgzDa7PupG11Lcqk0NkMMVaOKNzRAsX7wGNPYAogxp9ZQLPLrC2Fzj
	 q9bYB4i9VT1gt7Vf9FhWJGz+ZmVagqEvVHUk+8b+EcCtpdHs7EVUvCRZo6pg86GwvB
	 E/rgZwkUpAgPKoKPClDhsgOqoNVp9lh28/t+l6BzGMbG8k/Mx/natY7KHFa7V5kC17
	 aUUDl2JuL8J9N6U6vuI4eodUxJJH1yYaMJKVeqoclRSaHs32EJhmS/onZIKSkgAIiy
	 ZT2moDUFxI/SQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Nov 2026 11:34:43 +0100
Subject: [PATCH 2/2] vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev, 
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1593; i=david@kernel.org;
 h=from:subject:message-id; bh=6FQGSQFtSeIoA04JJqzZmDwVXcEslBgR8TrlTiQR56c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIZlFy/Clz4sES/6azaEaZ/qu6b8q96HmbKiuewNn9aY
 KHow8vZUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwESeLGL4Xzgl+9UZr++bQz5p
 VjlNtwwVV7HVYJjTXisjlfH134JWG0aG67MUrfb8v20xY1lRv/nGxf2GXz4wGdar3TzPMPlSSV0
 eFwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 5B411C0003
X-Stat-Signature: ewpeqsmbzt85c7yiztom3ahmu6gptg67
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795170897-136474
X-HE-Meta: U2FsdGVkX1+hmH6NmeJoaaACSWmYz43tqQO6k00MyPbfUGp3WMZr0H79lV100VkHhiEyM+fEs0Tp03FiKZYzopA4yrNyd3h0pCVt4zeEUtMo4JpawfekhjcSnCBDSZWmsAG6AS08ZcAQESkB1y38iEKkkjNsQvB+NBCQ+whpIb6AAMFZe7d9JjFqJbnlJtItRNE+8hpGjFgGkwr4E9nolnsVAXnhRVaXPKbUnnbcRp1/pxrhl2pxq4eKAfOzf+uPo5hUpITg8anGKCBEYCkjO41/ee5NLqwwRb7d8WSrM8B7S4Pf7tK/mJiIXGjSIAe9MdmYniiMUSpehDnQSyF0ANzgYOb+RAVd72kMZq2uZCzMFUK7OeOQmFEFIKdXf2rDc7i8UK1To2biOgxJ1FxTFZOZY9lWCE8xrgbbkCpBN4xAKRggxLI7e198wDq2/+tFeBsHTqltUUvs8ZE+cPNkhXzYQxH8/CzrCm6UfVxdPfHcwwkfrHzb+TZlpjvo0K4FfY8gIzdXg069qluus9j1NdHA1XkyiI03pcZMcKVgn1x7EEB+UxsCQYtU58yV43AnOrApW+REnurJzsOnizllBpJ8gpI2OYmXhmi6Ic2WyV8qPCXE38lJUNB4mgFVf/PB7+95Wa5sUpqKtlQZ4elFGPS1MyuVjcwEb3RoJk77tv7CXdblXwMYITLi+NnOcvhZGrHh5ge1jirqu5FHyFvKMoh2+hVvFZ07ShXIycGHUpFrln+YlbY8Hzhb3VXEVDSTSTtqHPdDMXLcHhmWZlF18pjdXaS6Dhoq1Z42TU5JnULJ45T0yD9J1pn55H73VR1zjHyNjuU6zvETljJGLY93o7LvYhBohfQPfg6ivQuGZSYtb4eeXMiJwBsUcos8xmfuUG8sjzUhLFVUgXQpuyb9NfGAoTCWhpvimvk9wBDK17Nhj+nU8fcH33KqTXDYihCBBY+Ua+q6QpUEGoT8Mqr
 vzOcm00f
 cQfkoz3ZMa/PuGxDttpBjeYt0aZJk5967rTABo0bz2HXmnuZ+dWNsqHtY6DiaBhrbxWYcpPiCkWTeNIkuNtq6ignyEOl11pOXtNu6sEi8PFHq7OfbQfM75PX4WR/5lHpoC+KNfMxIKh0gq4iVMLcPB87kC+Llq0cpKsqJCwQVPQsD7nIwrcWRG9MW26EUK9BwiJVZ/Yc2LB47y1LvBzb19viUYdLlldrJVjtSMphZ2yNSM4pGyZtABPniPcuN82UbBNAN3tQwQ7Kg8n6huU9MFjLQDcdgmun2ayBZP0PgpM9zNwK/EBgbAO/VG2gUKlXfHrmC2bIKn98u9IV3b075sVgxOtp9sjtSk/zp8eIPAmhAFwqp46UawFg6xYK/MELMBYqaNsCLDAFsbLbW5QJAXhfP4vzi1CZqEoTH5unkbT3E8r+akbrbuoyoBKS1EhNzOzP+gjCsx4orTyF+FJmo37iYxtv9BUT6ap+4QMDFraCF4V1c0lsfuB5ti3ZDPbCYhhOTOQAu0bV4mtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmw_balloon keeps 2 MiB balloon-inflated pages on its own list, not
using balloon core that takes otherwise care of updating NR_BALLOON_PAGES
for base pages.

So far we didn't account 2 MiB pages under the "Balloon" counters, so
/proc/meminfo etc. would not reflect them.

Fix it by updating NR_BALLOON_PAGES when enqueuing and dequeuing for
these pages manually.

This has low urgency.

Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/misc/vmw_balloon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 3edb934dd7fd5..47dbcb3be6ed6 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1005,6 +1005,8 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 
 		list_for_each_entry(page, pages, lru) {
 			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
+			mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
+					    1 << VMW_BALLOON_2M_ORDER);
 		}
 
 		list_splice_init(pages, &b->huge_pages);
@@ -1049,6 +1051,8 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 	spin_lock(&b->huge_pages_lock);
 	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
 		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
+		mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
+				    -(1 << VMW_BALLOON_2M_ORDER));
 
 		list_move(&page->lru, pages);
 		if (++i == n_req_pages)

-- 
2.56.1


