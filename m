Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F9E606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=NYaBPN6D
Received: by kanga.kvack.org (Postfix)
	id 4FE7F6B05C2; Mon, 26 Oct 2026 22:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5A16B05C3; Mon, 26 Oct 2026 22:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6076B05C4; Mon, 26 Oct 2026 22:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 101496B05C2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74CA7C08E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:01 +0000 (UTC)
X-FDA: 85366894242.20.167989E
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB825180004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NYaBPN6D;
	spf=pass (imf24.hostedemail.com: domain of 3-hLgag0KCP0pj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3-hLgag0KCP0pj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+w6uCJntt3i4Wr5zbmAS2QfetxR0x7f970do0XgFlo=;
	b=T7v2Uh5VLurJsM9Bpiv2ZLChHN8L/mf7EcxkHB+aMOaR5/iUjvLJByBSmpQFYchNh/XUPJ
	L4d44xdNMb0m+G8CbcqXuBafCnWwuO8ybm2u8uRIIq3evbPktI6Uu0Wc63xCJ2V4P8fTXu
	BwJyTXj8+FWiNWz/3JAWh98E92wPupc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NYaBPN6D;
	spf=pass (imf24.hostedemail.com: domain of 3-hLgag0KCP0pj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3-hLgag0KCP0pj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069819;
	b=Z7Vc348hUaBD7JC0jqgBdoQznd1JCDxcScG+/Xyy+Lqi41qIs1++zJwWilhij+WSHrt9KP
	LWmOQ2desDiuYMHWpuqkVVZBMIPPEWhIfepCIEAdIIPSSfPNE5RxoXKsy7+Qjglrmd1zKp
	O7/KUHrFr/zMjFq8tvqoUlMbmRSCH04=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4c734afb8deso5325518b6e.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069819; x=1793674619; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j+w6uCJntt3i4Wr5zbmAS2QfetxR0x7f970do0XgFlo=;
        b=NYaBPN6DYisJcqKgcr13478Dd9ftAP1/+OQeZwI3+Mtii674PUc0iDwZwo2Y4rdcJE
         9Gml8Sy1+1cCx/iMZRwT1vAoOnkBb0CG3YcuUX89PPAtFYyuhAfgmwgAHnv1QfB2La6L
         C+RjhP9b+8ahvoK4eejvqE+apurksrZ8Vc7T5S//KMT5kNDXv2phtmKhqucz8y5gJD4C
         qdmPdiCTk9wDSrBwi8TgKFzs9arOaNrrgdRaE/M4blUW9FeFgKrY8IPfEh6D9uxqzEka
         VzzjtOkQo6lL9JVQj6sWAlmJ/a5jP1xVqbYbzpic2Xua5wvUI6aVBPxNLCN51c/l8M7g
         IQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069819; x=1793674619;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j+w6uCJntt3i4Wr5zbmAS2QfetxR0x7f970do0XgFlo=;
        b=MCd4OiFqpcVBzt3cUM+DgO0K6kqJmCuE9MQQl3Qzsd7TV0ewXLW38u40H4An+bT/qI
         WFK8mQ8lu+NbUapaslEE9QBAA+Hjz3UYMqX4RTEO0UgkDAWsVsZSUsXXjsffB9O5ehqn
         yQ2cXkG/iRMZSvD/RvYkRjvPgPynalG8rB7n825Jk/kaqujLx0IpyxSFXKMawe7VOO1b
         Xy66WautuqHikSisIzGnF7wPNIqXRHRW5t1oKN0VENl/i2HgrdGSfUwQ+0IahSJK06h9
         U9oM2nJTW3H7srsHQvRwRlOntlC7cE8zO66xYL3TPZvkj1vYrDAfcHRK9HfTIEbLruCS
         xxGg==
X-Forwarded-Encrypted: i=1; AKwUvBweDtb1FEZIxhcAJwchmeRjef3Xe2gxDXWQ2sGEzUkmcLbAKqT1ms7mMP77BbaeGMZdlMJQ86AGyg==@kvack.org
X-Gm-Message-State: AFq9FYKXaif6m9dya/ax22AvE8dBZu/J8lS3AOZtznbjfgGaRRIaZstp
	GtPscZwMRiuXtKEFVKCTmAkrSAQyqwrVOcC/qKOQxnTK3k3pF1KQrCdOLWjmkrm6z5xeGu4rexa
	WFGbGSHXZnCYCH8IWDo6wQPaDjsh3pCdYmA==
X-Received: from ioo6-n2.prod.google.com ([2002:a05:6602:8646:20b0:9c7:5a22:a4be])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1b2b:b0:4f4:73a9:f853 with SMTP id 5614622812f47-55bfff91bbdmr5294378b6e.1.1793069818445;
 Mon, 26 Oct 2026 19:56:58 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:14 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-12-kevinloughlin@google.com>
Subject: [PATCH 11/13] virtio_balloon: unaccept free reporting ranges
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB825180004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: abqfdtmhne8h9gxymn64y9u6jhkcn8bc
X-HE-Tag: 1793069819-514835
X-HE-Meta: U2FsdGVkX1/W56gGCzskDlQHavTrI/vytz9cx1HO6U/tRmuK0zepIOQIYyoZy4PhwRqv7nQwd0Yqd/uAgfFW/e7D2LlzdEoYj30IRNc1BZ4scs1XZo7BpMrhiHs+ifNYzAgupVlSXXgk3H9m9VuGDNsAQWwkFyU+UhZpXrzxer6YatWHarENrIcKoJoPYqttt3lHHEHQGSU1s5O9EIHEBcSAnL+0IV8tNxp8dX2wgB5or4LKInqDeACdAzpVIpcZGtnpc+/COihnNSk7n4N90OAmphX4ys9bmbw2V4U2gtt3TGqVKoTK4T4HlmzvlPCPRTYM7pb1F7vRALQq6XAotkU8HpnI4p9qDMPAd45tFmX7GNAUcAKsvwXmKubFHsizY0lBc0ATjEyta0PEN6F7P5d+nc7GmiA4s6J2gi6nWa+gRwnfiPSf42k1lLB7Zr32zYY1WhECkYdOZjxfDFxL06w8oFOClWKVnJ15+WjJAZDFGU9Pr9ICcSKD1rnnoLtxdN2fMt8Owf2Koh7NUJcPv+wkc8NxEdAIPA4MKr82/R25Ci5pUSWV6aDkM0EeGSTOwlLHnBzR4PzawHsw7saDI1FSyYNJCrLDdeAa4tSxyaJzHujpvkZUcvxYm9Z2kWlNS6a2GDDsapdfqK0wZi+ZfzjfG39XiKXVK1bp7Pr/oPGkWrr1r8PNleCZ1Nnq+uaDHCVspMEQk0/zCV3GOlBK7sN/l49yiQgg6fXqLLYplIgJpBaUAtU2i1nq0loRmrvije/tslKAIu+03xQ6PPwSKZkp2+Gxgr3xeMfSzjKx+EaewSwJVka/fefbPJcjKHkp2cWiUTfYfsXUlswNEGF0Cy6jTR5UhJ4T9ICDLGC90prNzrIgdrZsoLhHGNpuEMSx6mOJq2vZjrt6c+zDM9nzZRkjh5et76Vctre+5PrvvadpbX9BBe1KRQpjOa+Epmbkza2ZxlJ9rlJ50TeueFD
 EA61bkC+
 2aB7biQ3MZVGvq51OZMXO0aabtIQ/fQ3h+tciv7ZskjApdlHFqms+XQKCOwBq/xrDBPQoByff2v5hzcMNs7u6IKcwTE24F247ZGoqLAc1tQbEkKPWwKeUXVMDIGm/JEcLx2k2sWxY0zGXcGZ5Qy9ugQBJRq2gngPgCsnVrhmvJ3Vw/x+Uim0t/OMu1MyOtm3pyoClfLNbkutbSJO0SiCL+bgeP45nw+2VlyUdrpaT/MuB3box2MoyEpTvPH7Oe0E2WQ4EbmSBBnbdjG5N9PN26+MSYMcGPiXZwPDL79Dls4Fh7BOVYoZ89eGu+K7qtIS/D/L063DySZg6U0AnIR8n1Z/zGmcbxEdEL23OBbwUfaHnisk/s9pWCituRMP44/VHiDymy6ODM8HQgy2frlqmPUwT7HEQ9lPb/STMvGHddUwHyQIZBAxBSN0QxJcRDULAqBWCtgUVJsm8TL50DxZfert5P8GYJfDkk0yB1CqSIs7N7+Eapu6zBGbFdM4Bn8cW1QlchatF5WsXPZ/WQ2FAvuaMjivdw8mw0RArtypQ1XyZoljIh1bI3j/q5cRPz2mUItOrjS0943q1XVv4OiIFm9LfIWV5z1eeiqSRXaTHCx41VqXUd+2gJVRCiNl9DAaGhoZ1vH95y/WUkQ+j0fciTIUqppi2k8hJJhMNDJlDyvbOJCG8HhVqXDobSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In confidential computing guests with dynamic unaccepted memory
transitions, configure the free page reporting order to
unaccepted_memory_order(). Invoke mark_memory_unaccepted() on each
scatterlist range in virtballoon_free_page_report() before adding the
scatterlist to reporting_vq and kicking the host.

Unaccepting the pages prior to virtqueue_add_inbuf() and virtqueue_kick()
guarantees that the guest finishes PVALIDATE(validate=false) before the
host VMM can observe the reporting request in the virtqueue ring and
punch a hole in guest_memfd, eliminating any race where the guest
re-allocates and re-accepts a page before a deferred host hole-punch
executes.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d162c162b496..e10bd792ef7c 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -213,7 +213,26 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtio_balloon *vb =
 		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
 	struct virtqueue *vq = vb->reporting_vq;
-	unsigned int unused, err;
+	unsigned int unused;
+	int err;
+
+	if (virtballoon_cc_needs_state_transition()) {
+		unsigned long unit_size = PAGE_SIZE << unaccepted_memory_order();
+		struct scatterlist *sgl;
+		unsigned int i;
+
+		for_each_sg(sg, sgl, nents, i) {
+			if (WARN_ON_ONCE(!IS_ALIGNED(sg_phys(sgl), unit_size) ||
+					 !IS_ALIGNED(sgl->length, unit_size)))
+				return -EINVAL;
+		}
+		for_each_sg(sg, sgl, nents, i) {
+			err = mark_memory_unaccepted(sg_phys(sgl), sgl->length);
+			if (err)
+				return err;
+			cond_resched();
+		}
+	}
 
 	/* We should always be able to add these buffers to an empty queue. */
 	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT);
@@ -1142,8 +1161,11 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		 * host's base page size. However, it needs more work to report
 		 * that value. The hard-coded order would be fine currently.
 		 */
+		if (virtballoon_cc_needs_state_transition())
+			vb->pr_dev_info.order = unaccepted_memory_order();
 #if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
-		vb->pr_dev_info.order = 5;
+		else
+			vb->pr_dev_info.order = 5;
 #endif
 
 		vb->pr_dev_info.capacity = capacity;
-- 
2.56.0.307.g5fe7bd680c-goog


