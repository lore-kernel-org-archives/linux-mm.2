Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D050E606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ExyqdcVP
Received: by kanga.kvack.org (Postfix)
	id D0BDB6B05B1; Sun,  8 Nov 2026 03:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD3B6B05B2; Sun,  8 Nov 2026 03:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA246B05B3; Sun,  8 Nov 2026 03:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8CD6B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:39:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15097A7FA1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:39:48 +0000 (UTC)
X-FDA: 85411303656.06.8D71AB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6F1A340002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:39:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExyqdcVP;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TR0Ic8FdfhFovFBSqoBf8epOfPvHW3egKQVfisx1qZI=;
	b=gOgJ3Ot4nL3l7lXl/s0yxyqKKPy7IeiJgShSgltpuishkwiKv3FxKUyVVS/uawCnnvuY4x
	3dDeR5IAw4ifMvaUIbypdigYkfICRaNaHR1T5QQaZl8V8nU2yjY6ZF/8cn5r8z97EX7qFO
	+0L9xT+jLN26LdZ8jo0hUj+/X1oOGjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127186;
	b=Hz3sLtnRZG2F8Rc/Fkcy5MyAj5e4J3a2VgqCcjI85PJxwEoHcZflovWDtGHV29BwsD4hdW
	E4173WbJoyexdKz5VsjECLID9zUN3IvfqHoMTb5s/XBnZP5TDRc989XPg6MG/oL0P5/GUU
	fJ5WcLlOdST54EJPdZy5a+YtCgrHLF0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExyqdcVP;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62D546147B;
	Sun,  8 Nov 2026 08:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CE61F0089F;
	Sun,  8 Nov 2026 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127185;
	bh=TR0Ic8FdfhFovFBSqoBf8epOfPvHW3egKQVfisx1qZI=;
	h=From:Date:Subject:To:Cc;
	b=ExyqdcVPjh/2tevdniSNuiMYeTaU1jdf+KXmz4NWmnv1u1FvnNxPacb1VWuNtLldG
	 jUYtZEkWffGX9O3mVo/NrJ3yDR6Pgn9x8xdCu/I3Nsr3Jt8/UkA907JSd9J+X3y3Rh
	 rzEDZIcqYch3ay055aAfAlwRrV6mWZ3K4Ef4oTPq+GD0oFVzKbpLDko2jkSOwbOGRX
	 yOv17sn8QGCcbtZ1I1oUmtqbeVt9zpW1cDtwfaPaWFyHyhTmA5zMOYwUKzvM1FLq57
	 0kX0Ew1swRTg7rgTzQ46REGMolIscrme9qLS67sTtTGW2Awf2Tgjh9ZpCYFObVK7HS
	 lQMalzg7vr/vw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:39:34 +0200
Subject: [PATCH v2] USB: usbfs: replace __get_free_page() with kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-usb-v2-1-c9209d527559@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2OzQ6CMBCEX4X0bLUUJOLJ9zActmWB9aeYXSAaw
 rtL0eM3MzuzsxJkQlHnZFaMEwn1YQW7S5TvILSoqV5ZWWMLc7KlHsVpqM3RIqRNA7Vaky/Ght5
 by7X6sYzuhn6IpzHhQFA7huC7KPVMLYXDE2RAjn5HMvT82d6Y0tjzX8zMtjil2miALC99ZqzNi
 8sdOeBj33OrqmVZvtw9FNXJAAAA
X-Change-ID: 20260829-usb-ad052ea1ffad
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-usb@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F1A340002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t7ure6oonwk6psdf5wj4arcxu8sytyee
X-Rspam-User: 
X-HE-Tag: 1794127186-224078
X-HE-Meta: U2FsdGVkX19TM+nQCRrr4sQ2fW/0TdPilluufCpXm7fr7Hb5g/B4PWvxJf99q72MHLMH7x6PmRxP/7LF25lc/EB9MtoWiUrhlWEysTmFJLU9Mp2ixqR5XwHfMEzBpY40n4ik7+FujudRMeqCh7Wiio7N8KN/G6SQI5ZwjzzPcu+994Fnvs6pO55LkbszB9m/IUn1vIsPl/5gaQP2C+zThbFxLegN9vMh7eCSLHcmxW5apFZYcN6iI9aBRz1j9mydq47fiqDwPuTPcE+HG+ksSPCMKapT2d2tUuNJxCFwNxBSe6OJsHkrN0pmw+HbXPOHW5vH+2aT51UGhykop2wQ2NGIzMDAIHGYKdl8Jj9iuWfAnLJzhOHMdK0AT5uCqryubwGsslhph+tCk1rw6XHrwCqWb/rC0H3OIN0s+vrc9048WumRDuEWDD2p+n+LY4G46EwmUsqMqbHJwmkWCc6F2gVh45+eQcsd4k9+F9GmiuKOknl5IkanOl5cCbY8XIXX5HrIHL3nOs8pBH17WrDd3IavC68dJZsUzk+o5JYAM2QcZM5ziPiaFbV0wuAHzZ1221O1ckm12Sq6u4NjuA5Ip6MbXgdekhw6V5ddQqs3JBC1TQPp4zJpvjr5+Nao44ymzSgQmJ3qsKaH9DyNwdX4vCGYS4GpBqg+FxXhxGfN2wbPmt30GvVTfQ54NygsgxAIZ0Xf5LsSuQI7B5n+fnmeJ0m3JpWDL8DZwEuYsgsLUGX7tKFR7PmF/WLUj/RU4cRI1UMCsVUphlvL7PWBvljee6ES6zAxltXCDGCsxm42aoW8elSQcVI4+9Tu3JcjLV9fHGqfVTORIRwo50EBQS/yYvbgkH8BR1tg00e6WSzOKcyi4XSUIhilh77vYmkKdD1WGflZ75vpcuEXVRYg0YKHVU+vDQ9yOD5x0nFNaFgPjzMwDLGz0/9k+BVpBNyT2nnn2D3o3PpuV+ciT65dxQV
 /mv3RpQq
 TmSZ+Q+qd6GXXTUXsR+18ZKiNJBTww1k8TyxFqFP1Sssytc2X1wxBSkkW5uKYwLMN8faM99M4FViT/NfXR/ZbmTUP+lIaTJAzLhh7h8Oa8lVOwcnypFTe+lqDU5pJ+rAUXmdKP5f81yb34JPDl7qt3Ot1bjP1CiVBQuMHeSLWmUeR2UgiBH9FLY4U7y+58Qbu2P0MU2oxX8dJ+izEdfGKsIBj75kTx4Ng4138kvhao8UpVXkA6jR3/o14d3z4kj+hDpj4Dc+G49ffhN8iJJg/w8WPfAUzlznznok4VJANLYSUUSud7P5IofOpvjwi/21FIr+NgTFkX2RBOQP/K/oTHZzc8uzgQ8H2Y6ieuHr0YFwMZAZ8/SBEGCapJxmcVSQCC0pQCAr3nqjUruQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_proc_control() allocates a temporary buffer for the data stage of a
control transfer issued from userspace.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is essentially a resend of the "USB: usbfs: replace __get_free_page()
with kmalloc()" patch that fell between the cracks.

Alan and Vlastimil agreed on v1 that the kmalloc() overhead does not matter
for usbfs memory accounting:

https://lore.kernel.org/all/8cbe558e-7f53-4ce4-be8e-52fdba9105d4@rowland.harvard.edu
---
v2 changes:
* drop already merged patches

v1: https://patch.msgid.link/20260830-usb-v1-0-aa349c302246@kernel.org
---
 drivers/usb/core/devio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 101cb94254809..9a7cc7cdf00be 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1190,7 +1190,7 @@ static int do_proc_control(struct usb_dev_state *ps,
 		return ret;
 
 	ret = -ENOMEM;
-	tbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	tbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!tbuf)
 		goto done;
 	urb = usb_alloc_urb(0, GFP_NOIO);
@@ -1265,7 +1265,7 @@ static int do_proc_control(struct usb_dev_state *ps,
  done:
 	kfree(dr);
 	usb_free_urb(urb);
-	free_page((unsigned long) tbuf);
+	kfree(tbuf);
 	usbfs_decrease_memory_usage(PAGE_SIZE + sizeof(struct urb) +
 			sizeof(struct usb_ctrlrequest));
 	return ret;

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260829-usb-ad052ea1ffad

--
Sincerely yours,
Mike.


