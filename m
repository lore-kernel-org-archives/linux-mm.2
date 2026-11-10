Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1680606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fKPLbiiv
Received: by kanga.kvack.org (Postfix)
	id 9A0996B00EF; Tue, 10 Nov 2026 02:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978E16B05B0; Tue, 10 Nov 2026 02:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8913D6B05B1; Tue, 10 Nov 2026 02:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 647BF6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:14:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07660A8179
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:35 +0000 (UTC)
X-FDA: 85418346510.18.68F0F4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55ACA40002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKPLbiiv;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794294873;
	b=PTF8r51MiB3hJUzz5AgxqTBAFhLgS4f8BGbqYKQUw878Sst1/IkaXkILAxw6S+CbOoMqZI
	5d3ZfExeyolc3Xgw8npt70ybTOBIHgUHNmsYmSjDTOZnzi9wAyB4wY3wJN2ZEaHAHu4Xw0
	9Up7XeLtmK16IVI4jFIk5hQSjliGfr0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKPLbiiv;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794294873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JeBczRWUIYEnZGuPHhbnKleDwqSoORE3VajfVV+2ChI=;
	b=bEjpECRFEMXddSG1H6W/4LBqJGGNERo8HsHQBkP7g0D9pjTfMeGvC/uNd8ykyS9upYRPLN
	H1LpLPWcQTNhH6Qr3WfGUHNsZRgb0/6Wo79+DrJGOIk/rr9UBaiBuQK2NS0hnRtIWPzdJs
	cJh+LrGY5JILFkXohRGXF/2ahiGWzfY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBEBF63792;
	Tue, 10 Nov 2026 07:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DFA1F0089F;
	Tue, 10 Nov 2026 07:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794294872;
	bh=JeBczRWUIYEnZGuPHhbnKleDwqSoORE3VajfVV+2ChI=;
	h=From:Date:Subject:To:Cc;
	b=fKPLbiivanrEzD0lDTSnLnW+s/csuy7zmF/rQB69ecBnZGkkMcGW82NV5pFLA16bh
	 84z8u8ZKsezk0gYvkBpaWKmkB/ti1yMKn+uXWxAze4muXfT6Q9+ylkElk9VeSLKbd3
	 3URD86VRiixps3P+Z8PM+90U+NYNcy2eMdKeOMdHhJ++2/mcCNMufVBbVJJMfzG/p2
	 mc28TlVdjw+vnhpCmNyhtsqkpeGz5K5ogqQGT0HmG2L8a3nUHWOjuOA6DL49rUoXRX
	 vkQgdAghDuSKqy1+cSnm7w8cRkNFX/e5T8W6ZAVKr5foh+Vkwbr1ayP8ewc73Vd0Fp
	 DzSaXhkrVZFZg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 10 Nov 2026 09:14:27 +0200
Subject: [PATCH v2] xen/events: replace page allocator calls with
 k[mz]alloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-b4-xen-v2-1-21ece28be7d4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWOzQ6CMBCEX4X0bJU2pYon38NwaMsW1p/WbJFgC
 O8uxXj8ZmZndmYJCCGxczEzghETxrCC3BXM9SZ0wLFdmclS6lJLxa3iEwRuhGu1rB3UXrE1/CL
 wOG1F1+bH6W1v4IZ8nRPWJOCWTHB9liJhh+HwNGkAyn6PaYj02T4ZRe7ZRoUoT//RUXDBj7qsK
 y8rZ7263IECPPaROtYsy/IFeJUJSc8AAAA=
X-Change-ID: 20260624-b4-xen-a1cd629ce9f4
To: Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: David Hildenbrand <david@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: guiobicok196coksh1mcunjtf37ostet
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55ACA40002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794294873-108101
X-HE-Meta: U2FsdGVkX1/5XOqkSfppuJNoeOHdkHFzCop3QI8dPJ1OYd4JU6oqj1F/tpj4kzQUWsW5BJ7krrelzaUEV0Lk/tpG/7TC6Le3KyXMstzKj9qjws36ssp9PeeZgceTKBiYukQkXZsB2UEzJ+a/ixL6VbGWnbygcSdal3yOjTNJ5Aw3Uk8NCE4zHxlcSW3xuLasVNnEIrFSi8SfNHmLy1Qj5/B1SgnlcQRWTf5LrUp0hOqbuksTRXgrVn196/x+algvfJj8xuTJ2P3xTEGEMpuWBBZZDL3YfY0Q8BZUE+cnCZ+g9l8y/H3+IowuEwC1hh6jRmGqwulNnp3ATgqYt3m7rcKuH05VNn5ZT6N/aUxcTG3ny4jBFarygMradGLfNO7VpKtDDSy+3V/rObB4b73xIIv9zyf8IQBS4zFVxHd51kjsOJeyzQmMLNvaIwCikJ2ZhN0WsxiYj27C1f3SrhtMO9KxTeIcfqhV1vcKC5QqHCKBefVqc401KBA3raRojAkMv8T09EoEQF6JV206OWOhxd1uSbsBFJASXU/wFHOp3iG+tx06NYlMnsRyLgZNmp91iyeUI68gW/ULM1s5txgsxjRgGmeKikjHV3r+hfWntseNrXCdDNS9nXIQuAW9O2fjRACIFXfyBJWN6n0lKytjF3Y3ggA0zVpZ/LTCLwHqy3yVzcd/9ZbOu7SE1CKhR5lv8yio4a/bGfDz1t5ahukw0+Kl8P+EgTV7dkrGunOZ23jSoBa7sFFsknIWEZSrxv1HEEavXnUdZuq8hekWXY+6u4KnUmZTCEF1RxEPjA4JDPB1csHPmPANiyoFW4DAKIyqjYbozTsNhZF6NLN/eeaHjCzgmZruxU9dr3rIu6DmFZ35PEyvaOLso2uL7NxIOEViCa+IQODQrWNqfcdujX0QL7bvaObofvT9OE/27CYvcswL0rIMFkAxBkbuRLobDPXzGsqfVR4AgHTaO+/bnTp
 CN/xnVdx
 9LGGRgTQhQ0Xwh4quoXIwWbfcRKoF8lcBtCPP98b7anVYvjEX0hgt/wNVHnggu8T35Kmd0bIYoQplUyNuM83r+M5ia7z99amnEr9vXL2RA6keQEGpd/IYm60yAcYC4+aU6xGwEbJf0dBeNUe7Bqa/r2HDoQyTXc003MI3/gfOv7Qi+VtPlKcF+RssAEzo2TxnjpYewgauRivckRYUV3H1V8wkLj6yVOpo6JVdFtAagopawvzBwyh3DlXczRP18r9qJK7W8H4JMBy+O+mHPgUUsQJkR8jEjIBMof2U6j8ZEEPDBGeDKsPPdgz0K+le1hTwA/R7Ha7bViPJBABv0PQd0fs59XGl4xxo+1w1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_evtchn_to_irq() allocates a page for the event channel to IRQ
number software lookup table and xen_init_IRQ() allocates the PIRQ EOI
bitmap that is registered with the hypervisor in PV domains.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator. The PIRQ EOI bitmap is
passed to the hypervisor by its frame number and must occupy a whole
page, which is guaranteed for a PAGE_SIZE kmalloc() allocation as it is
naturally aligned.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kmalloc(), __get_free_page() with
__GFP_ZERO with kzalloc() and free_page[s]() with kfree().

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
Changes in v2:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v1: https://patch.msgid.link/20261108-b4-xen-v1-1-76095f25cbf4@kernel.org
---
 drivers/xen/events/events_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index fd16d652c81f2..9828ed41d7a7f 100644
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
@@ -2314,11 +2314,11 @@ void __init xen_init_IRQ(void)
 		int rc;
 		struct physdev_pirq_eoi_gmfn eoi_gmfn;
 
-		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
+		pirq_eoi_map = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		eoi_gmfn.gmfn = virt_to_gfn(pirq_eoi_map);
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
 		if (rc != 0) {
-			free_page((unsigned long) pirq_eoi_map);
+			kfree(pirq_eoi_map);
 			pirq_eoi_map = NULL;
 		} else
 			pirq_needs_eoi = pirq_check_eoi_map;

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260624-b4-xen-a1cd629ce9f4

--
Sincerely yours,
Mike.


