Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FCC606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R+SlQOYJ
Received: by kanga.kvack.org (Postfix)
	id 0B2D26B05B8; Sun,  8 Nov 2026 03:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063D86B05B9; Sun,  8 Nov 2026 03:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95266B05BA; Sun,  8 Nov 2026 03:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C12086B05B8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:42:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2B3280149
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:42:47 +0000 (UTC)
X-FDA: 85411311174.03.3194724
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 27B0420002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:42:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R+SlQOYJ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127366;
	b=sGX4XxmG2TC+YG4Oz1GFKrCoiVjrbQuJiAUTSubT5V8pKvlxuaJb5s8FBDaJ7qr3eRqz+x
	UCwwveBU81hvuJGczD2dBhvY0H4+rZntkZWByPVMXKaaNhcHkZO29BnciGVjPdjTYEkFRh
	YQNzlRyjkChAlxnxjKpo+LIer1hWOlk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R+SlQOYJ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OvMwR2q246pcD5TId5yUQvPErCrIqP4Yqwl75kEJdv4=;
	b=KilcCp8MRyetUTW0MCB8hTIJl5p82hKArSGM0bhEki6hMZvwrmlINZursUQsordOflnsuV
	RkVb7b3fzYE886kfW77URB64iF0AAb6bWVa4bAvwQYkZboISoX54u/HGDBSdNkBpri+PSK
	aDIQvzfJuOq6mL8ZRw0Fv2SBqavRDmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62AF1448C4;
	Sun,  8 Nov 2026 08:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7861F0089F;
	Sun,  8 Nov 2026 08:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127365;
	bh=OvMwR2q246pcD5TId5yUQvPErCrIqP4Yqwl75kEJdv4=;
	h=From:Date:Subject:To:Cc;
	b=R+SlQOYJPlqMQtkVfLLLVQdln/NbRUqFxW6q8kybGmJI1Ss8JrmkDqLK/CPMlI6as
	 bIXH2ERjSanKhItHNzpQp2YWjyNIbJLQKMRBKCdsaiTxa+iQRwJ0iv2IK5Lmeqt4hM
	 ln8SZIfloQ24RJTpkL7MMm8AkApe/fkzdJGLQ7fuN1nzuSK9MMQHP/XQObI2TnFjkz
	 CHMCXy2uwEqTAXbWzPX0orhE1GqNVNEsTOapZD60AsVPV0SLpQvHGH7aILXYgo9SVh
	 jJhXEO65lpzewbkcFZBljrIEo2uiIRgtJO+HutILFfIQJnCcX5OWF8pnNCN8C/3Blo
	 9TazDZceW7c6A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:42:40 +0200
Subject: [PATCH] xen/events: replace __get_free_pages() with kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-b4-xen-v1-1-76095f25cbf4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QqDMAxFf0XyvDItpeB+ZewhrVEzWByJDkH89
 7Xb47mccw8wUiaDW3OA0oeNFynQXRrIM8pEjofC4Fsf2+iDS8HtJA67PETfZ+rHAEV+K428/47
 ujz/blp6U11pXI6GRS4qS5zotyhPL9YW2ksJ5fgHuiZ8TigAAAA==
X-Change-ID: 20260624-b4-xen-a1cd629ce9f4
To: Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: David Hildenbrand <david@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 5f44p3446nzxpqmujtqs378d9kksk9yk
X-Rspamd-Queue-Id: 27B0420002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127365-459315
X-HE-Meta: U2FsdGVkX1+2NoWm4Ei1QSKNpeE41iQLTfOme8Ch0PMyIs6ce28GaHHY3Sbbe/zLp5MqrGam+kJHjan/fjAmrg61K/EAXFbT+A7chAvbsbRQAT0k5vaCyuZlpuROLOgIspCqKCCahRYmQZFnIJIYA+q/BBo8gtEFkrIt7Vr4AblrtMd+3OvIjc65IdVV58S5jP3dl68Z+Dtxl7aSRIX5ydKtI5HhyNKBrmbC+KTI0sxFfshRkHCD6EczA6wS6G/MHx2mhTBBNPwovfpeTCBvqTcfdAIserIW4P2+aJExJRvOE//sEXWYhKN/QVDBAHqPwmJAkPQsr9ZErdalOUb9+uT6mr+Ok2P/1msj4Tu0nAqyIvWsIn6pQcXoe7kqOzQ/Cjr6J8ON+WGFFPOWPJWm/JixL1gVV4k6c8oiKvAl1JaQrBIBvC/MRKVbIadwaamkjoi6LEM9rvdui/gsLNVKOjuowYoYtSqVC+X2PQSBV9fM8snTL3viYR1X4gJWdr6ZrOT6tOCPiDKSHw2oNO0OAc40DoE+FdM1YQdAZYXV+/qN6Ns4CTlV145Fd/TP6AYIHQcr6dHt76/8DP4ISIY0BjxVVmnp0s5JsiRC/+coDFi2tpFsoxzatLADdwvrUvyE8szsMlp9kRKkKVllD5ul9cv8JFX2wJBvRpmyZSxEgVPNvJdyQbNTvX876/Frc03pmitr7fS+dAWRrCYtdzaXPS5kD3DlECf25rQ3lFa16C7NfRWH1umGUsiZDncQDqj5HmMtaMZmTVw3BlE2FpHZJ5Ku5mINFjhStNlAZ4CoYRMyUXU3nQGbRgtGekKuPlgfYp+lK/7lSKORNjyi4K0v7N5nhQJCXm7LhWQMexqdpOr8D8xY/i8IvE6KvcBXlLfcwz9A0zfTcwPemHg1JhjyTra/bjYH5Aapk35ZfohCgjx6tA1ceGe3ahGp868mOe2GcIsGJtIY6uH157VT225
 IKF26yrb
 YiZM22y1am9foO+Zab4LjdAwsfvAjyAO2PrreQRisG/yrRTCzz2gcWVB2N/SR9/2yd+9tC1uthOzqfn+qbRTkKLyx4Ta1CnayKVsuC5hE9i65iqbEUPQiXhTaRZV2HkQbyWDnNlYrzB6pq3rpOkJOwyRXXDyjRBUboaaNsk7vsNMHh1fLEPUAZ89RDU+OY/ayUf/v7x8fIP8NpEAewr0F72j5PJsSbsMWYzyt1u7VIwo7X3vMcO70sdle6R7KU0+3ha9kHAiLw6WMcy5FgQNYjJdExLYNYXnqBbF3KoN06SK0LNwxIHtn5rzD3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_evtchn_to_irq() allocates a page for the event channel to IRQ
number software lookup table.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
Removing needless calls to page allocator helps with memdesc (aka project
folio) conversion and gives a nicer API without casts.
---
 drivers/xen/events/events_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index fd16d652c81f2..8c377493429b7 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -230,7 +230,7 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 		if (irq == -1)
 			return 0;
 
-		evtchn_row = (int *) __get_free_pages(GFP_KERNEL, 0);
+		evtchn_row = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (evtchn_row == NULL)
 			return -ENOMEM;
 
@@ -241,7 +241,7 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 		 * thread was faster inserting it, we can drop ours.
 		 */
 		if (cmpxchg(&evtchn_to_irq[row], NULL, evtchn_row) != NULL)
-			free_page((unsigned long) evtchn_row);
+			kfree(evtchn_row);
 	}
 
 	WRITE_ONCE(evtchn_to_irq[row][col], irq);

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260624-b4-xen-a1cd629ce9f4

--
Sincerely yours,
Mike.


