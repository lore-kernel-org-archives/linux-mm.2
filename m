Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A95C44515
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC476B008C; Mon, 20 Jul 2026 20:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C28F6B0092; Mon, 20 Jul 2026 20:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF886B0093; Mon, 20 Jul 2026 20:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFE9C6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:56:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BCD7A0357
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:56:56 +0000 (UTC)
X-FDA: 85010969232.11.D664174
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id B5B1620005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:56:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rPXXyXKi;
	spf=pass (imf13.hostedemail.com: domain of 31cNeagUKCDIZWbYZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--linkl.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=31cNeagUKCDIZWbYZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784595414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dVZeqaiAWbMoulLNM+KQI45sBsT7cMtZAQ/ZsFxQyUg=;
	b=PY1UhEr9b6YEUKuSNiObbts1r68VLQBvchRM20fSPsstXEaEdU8WSH7mSl1goZ78Q6UFJ2
	7b1LhSs5c6vSYvIc2cCvsfJkpsSAc6pJ09QzG6h6GbYyDAAtgahHVkWEs+DTLbmcpnoC4M
	jFTOKVpD6rL+wRJpyjzHaBLlvTJLum0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rPXXyXKi;
	spf=pass (imf13.hostedemail.com: domain of 31cNeagUKCDIZWbYZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--linkl.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=31cNeagUKCDIZWbYZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784595414;
	b=KZnUnRWnan4B/SeGKhkLsq3wBSN36R/jbAIRlsVyhIhGQUcoTJ8nPLSesPuAaQMUMLsQ9h
	5Rmepc4jSBL+tePu2+iNI1vJtCp+8B5zccCNLok9CxjvBj1IRj1KEbcUl4mzAYzguor7zt
	vMsBB9CMnc+guQ9m1ouM4oDZ4Hu1gS0=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cacf17c7e0so105830515ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784595413; x=1785200213; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dVZeqaiAWbMoulLNM+KQI45sBsT7cMtZAQ/ZsFxQyUg=;
        b=rPXXyXKij015wJjpXpu+H86SzUHp7dthg/jqZ5nxJOqvCeZxBfdJaw/5XLsNdzA1o8
         OHEb6Lpn+9Q5IXDfJCx6pMp4+gu1AX9UcB2eHuHfUYM0uhSwxoEFbkHHpQgLRNOlBiEy
         lIJK3t/8DY+1JtjGznFq4D/nF12YHXOj4ZgQOekmc2+tF8dLhTbbohnGWQtLKQKc/emU
         Qcu7Stz0UOiwDBTHcs+5wR1D15yqYRFx2HNwm7Lp8UHUDuEQy7Nrr2HTX2MBtULfX56H
         h9gqyFljT1EjLey4MzmNoI/QYsNL33oxScYEMyIhI4shCd2L5sMAMJt+p9IhNnT2nbae
         4a9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784595413; x=1785200213;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dVZeqaiAWbMoulLNM+KQI45sBsT7cMtZAQ/ZsFxQyUg=;
        b=sSpsV/vE7VvZUA2b8Mp5VVrCNHq23nmItkR8e6TrzbnEIr7YrSnj+loAI7idZ21cAo
         kvnz0BrghnhsQ1YWQsyO7V8kmuYt1RQyrItSVv8sbU/vcJm4nunO2kIVcwQ6JssXHbHx
         bQR0QW31V0HQlSLRvk81d8QP+ds7wkJKUK3mASihB7+YS7+y/ZICa0JkipZYRzsz/FEl
         tDHNSwLxEB7nVaDkLHqATd6WWmHS6IiNnB5TXauxW1jVt4ErTc34CmhbdIJWciT2fsWi
         y2HGEHYTrR5WFyda/uPO4UmMxooH8sffKJc31UehdBetSoIaBVMbTI5ZHwibnLfeVtrM
         WzvQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnfxtlbHDreOwJSnxtIZb4Ch19Ovm+MPC/IR2w7BRIJ3PHJkvhytVZdxHMffS9A7zvHs/VAkXBZQ==@kvack.org
X-Gm-Message-State: AOJu0YwW7mrvwsepu/4/cDsvyocSOwUeuuRgm1hfQFtruFmIvBQK7Z/q
	v/zrGBJDvddy4Y9pRb3T7yQmofIxbDEk5O3lY6bRvXxx8BMYyG3BBYjk6HgOzyRct7qCI4q6EXO
	cWw==
X-Received: from pjbng10.prod.google.com ([2002:a17:90b:1a8a:b0:38e:7f2c:2c4b])
 (user=linkl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3886:b0:36b:944b:fd81
 with SMTP id 98e67ed59e1d1-38e4b3d27c3mr16883838a91.4.1784595413290; Mon, 20
 Jul 2026 17:56:53 -0700 (PDT)
Date: Tue, 21 Jul 2026 00:55:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260721005603.1710551-1-linkl@google.com>
Subject: [PATCH v3] mm/page_reporting: use system_freezable_wq to fix UAF
 during suspend
From: Link Lin <linkl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Link Lin <linkl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B5B1620005
X-Stat-Signature: mam7ukqeo8yzo18mhbyhz6eqf96sxbct
X-HE-Tag: 1784595414-928253
X-HE-Meta: U2FsdGVkX1/ZZRcOFQ/Kpy2b/YVFXxjJjetYD3K/Tbu5A2SGftOhHjupQebAtrC37qLMve0tirGzsQBs0VU092lKLmiMOU717q6k6+2gn0Q4Me0bmzVs9uwtcvPNlW+mUKt0k1RN4CIrsM0Fdd7vKzALkyJi6PkA8MV02GGDxG4EdFnUERoD2LTuJSWNoNl75RB3uJfOj2wqoRuiWEDyUsHVQpnLk31b4c6etBOYXpFwrc1VvixyDeUpfVt9/5Wghg3XQKFEUoToKfVEJATm06aFbjaGwvlTcJypSmwtqvEIJ7ixEnbm7td2kHeJedIk4SaeAu6O7RYOBQECPQ6bBStIfVM1HFFDu3x6xHGsxaUWZQPstDWN30lWSiJyTBMniqnHnbPdI4HSEkD9ugx1O0XTgOwkqIFKAwk5S/rDBY+jSMzhhYtEtD1EBmdEUgn7caN/n9fzl/foOhnN1fkbNYkbJGDGO1OJLnZ/Bpod/CjfEN+1yXjzYEyElI5eTw8kLV+5dEbkSv580dRh8iXwWdjqWGLj/6cm1+fG5Xum4XpVYCKwotx9OmZKfLkByGCRA0hZcTk/qa3jM6poGYMFtIVrLCuQ9zaoJhMavP20X2teURJNheFzfLMMyBU5JxyJwPiW9PeU0ceKj2GXLjPH+5BiHF08OepJ/pKLNbDHA5qxru7a/G3cQppWI7+S1nThI733Ny+XAZ4XDbuutJEmTNg2o7plomdvJDR+GfN4jnXWuqK6blsRmf3/eAGYgPErGNzpM9P91z+ktufK+mmgYGlYvDqr45gukUozXjH2EFD67nHRfWByFKfWHTrfBJzC0A8wlGUs4rDuFOjR9AeJALcHojXcKaoZeUBiquSzBdJG7qNpibA8BvVefPlSG5vSO4ZrzC8STrOFa1J5MkYm/fmuT7GkOrLXNXbnoSj8HUL2tajVsw2kecmGXnsYHE6Qsj6WWbKpMrQ7VAJpLbL
 UbiVpkNB
 gvN/eyzSr0+w+8LX9EV7ouT23/nUDravT1C1C+CyZC8l2jwzgzYldp5j8tYsci2orv9Ktog8qMirEMj1a93TopLv8CXSLNFEa7LIZT2pkKr4uQJwWHFeTIcA3/p/m6JOE50honnm559/XkfL6tjuWq4+MbTeRIKgw1ji/VawXU5eN6hhUH+eM9Y954hWgy7YgsFoPEnQhQ2Y3XnOQiAHQwkL9J2Q1zIGgR2CZaUxIJZb5+/8is+7AxOw3RXdE8rYBNG5n+TOvBu/Hhl2gc4NuLWLujSoCcylMlLpXVZyre6goVQya3YLdi89FEhH1sJxmgcQmI5T5b5fwehkfNrGxOx8ky6GS9OINzUn33meFEDH2af3jihIl5ss/QF6C8vsin4c7Rqj+raAP7C8H516LkIx1deXB7H7VnFpVno53zECYedPS3WuNHaFFqUH83do6/q+MsjDdqliMFoV/SSsYYMDoJFjM773tVZ2XXFC+UMkX0zXGxasZ+yy0kcdeQj8dIDkVr3jVC+PtQTw2E6Pm4ik3JxYPHA+D3r0G+1Svn03R7QlcfU1ClhSuyWY9oK9P9tAYzREm5jstM7Gi0xXoUxEM5UjrtlsGi+TUT00i8lQkut2EvnaIJloIJlJPxiHBGsJ5t6JgL6B4JOW0OzfxWDCeje/iHLR/CFEEZgrCU75md51nm7LkddvU+Zi7B7AxlL/Hj+xGuIOFqY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During PM freeze (e.g. S3 suspend or S4 hibernation), device drivers like
virtio_balloon reset their underlying virtio devices and delete their
virtqueues via vdev->config->del_vqs().

However, page reporting work (page_reporting_process) was scheduled on
the global system_wq. Because system_wq lacks the WQ_FREEZABLE flag, the
PM freezer skips it, leaving page_reporting_process active during suspend.

If pages are freed into the buddy allocator while suspending (for example,
when core MM invokes the balloon shrinker during S4 hibernation image
saving), page reporting triggers virtballoon_free_page_report() on deleted
virtqueues, resulting in a Use-After-Free / General Protection Fault:

    [  196.795226] general protection fault, probably for non-canonical add=
ress 0xaa1436fe70dae6df: 0000 [#1] SMP NOPTI
    [  196.825967] Workqueue: events page_reporting_process
    [  196.831038] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
    [  196.927073] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
    [  196.946943] page_reporting_process+0x370/0x4f0

Fix this by switching page reporting work to system_freezable_wq. This
ensures that the PM freezer pauses page_reporting_process before device
drivers destroy their reporting virtqueues. Because the reporting worker
is frozen, memory reclamation/freeing (e.g. via shrinker execution) can
safely return pages to MM during freeze without triggering unfrozen
reporting work on deleted virtqueues.

This aligns with the driver's existing design. The comment in
virtballoon_freeze() states:
    /*
     * The workqueue is already frozen by the PM core before this
     * function is called.
     */

Testing:
I have verified these fixes using Google=E2=80=99s virtualization infrastru=
cture by
running continuous suspend/resume iterations (40+ cycles) while churning
memory using stress-ng (`stress-ng --vm 4 --vm-bytes 60% --timeout 1`) to
constantly create free pages for the buddy allocator. We also set the
`page_reporting_order` parameter to 0 to make the page reporting worker
highly sensitive, forcing it to pick up any 4K free pages. This confirmed
that the UAF crashes are no longer reproducible.

Fixes: 924a663f75e2 ("virtio-balloon: Reporting free page reservations")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Link Lin <linkl@google.com>
---
v3:
  - Dropped Patch 2/2 (virtio_balloon shrinker flag). Freeing pages via
    the shrinker only returns pages to MM; with page reporting work now
    properly serialized on system_freezable_wq, shrinker execution during
    freeze is harmless and requires no additional locking/flags in
    virtio_balloon.
  - Link to v2: https://lore.kernel.org/all/20260717002311.681748-1-linkl@g=
oogle.com/

v2:
  - Split into a 2-patch series including explicit shrinker fencing.
  - Link to RFC: https://lore.kernel.org/all/20260709224330.946683-1-linkl@=
google.com/

 mm/page_reporting.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 7418f2e500..4dc6f4b852 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -80,7 +80,8 @@ __page_reporting_request(struct page_reporting_dev_info *=
prdev)
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			   PAGE_REPORTING_DELAY);
 }
=20
 /* notify prdev of free page reporting request */
@@ -343,7 +344,8 @@ static void page_reporting_process(struct work_struct *=
work)
 	 */
 	state =3D atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state =3D=3D PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		queue_delayed_work(system_freezable_wq, &prdev->work,
+				   PAGE_REPORTING_DELAY);
 }
=20
 static DEFINE_MUTEX(page_reporting_mutex);
--=20
2.55.0

