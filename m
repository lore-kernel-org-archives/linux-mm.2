Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61352F94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59636B00A8; Tue, 21 Apr 2026 18:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94DD6B00AA; Tue, 21 Apr 2026 18:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0EE56B00AB; Tue, 21 Apr 2026 18:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5FE6B00A8
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62547BEB9E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:02 +0000 (UTC)
X-FDA: 84683936484.07.E3F0ED0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 280CBC001A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cqZsnL4e;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAiu8nAu6jsdbD59MaLaRp9DyOH1KPADlHXUZUyeJ14=;
	b=BPAdNLldyB7sWiR1utm4nPQ/7x4PkxOK6rKrTXtVE3GLQ78uCvSaiKGG8TpGM7qbUyOU3v
	1ciJw4gi8FXlUcKF75X+ebUBZ0Mrtz46fGNdIf/zbKivl3Ry/Lsa46T64PJSNv04LS/t4M
	Xqg2xNqJPYeZYT7PeZSji3/O2oVtyvw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cqZsnL4e;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808920; a=rsa-sha256;
	cv=none;
	b=s0Ug+OfE9ogPMkvHi2nrWo/RgDOK2yXdkE6LjOzVHL7iMN2FjhJRXTlGV1Ojt93cvL5+4F
	XW3sh7wThfbcToS0LET8XSn152xusl/YdT2WcgK7mgCD4PcGUZ91wchK9sQgqxRYEWF9n0
	4yQRWRdEWXpAkqCIGj3Scm+fqbbd+08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NAiu8nAu6jsdbD59MaLaRp9DyOH1KPADlHXUZUyeJ14=;
	b=cqZsnL4e1NcgQZkmPgabzzOhP+wxzQMePvBr4P5fi3o+Uf811Qsjwc4RSrM7LsOqwN0gW8
	a5K23Ihy5Drjj+Aya+dKVbkIjSiptNqcaJbBBwLCgyekjmEKlFGHEdvsbbIYYpy/48Qy3B
	bqbcODI1WK4/vHatwvOW0fm9XVz/Q9o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-V758GYYNNMuFSTxFIFfAgQ-1; Tue, 21 Apr 2026 18:01:58 -0400
X-MC-Unique: V758GYYNNMuFSTxFIFfAgQ-1
X-Mimecast-MFC-AGG-ID: V758GYYNNMuFSTxFIFfAgQ_1776808917
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4411a572dc5so2081908f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808917; x=1777413717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NAiu8nAu6jsdbD59MaLaRp9DyOH1KPADlHXUZUyeJ14=;
        b=pZjQCCWMJTxhebgvXiJ8G0sEH4op9H2c8XXfXs30dsg7O26jx4wKznSROKmeAjLp7z
         m4J/EFf3TZmw7tc7Kd0VGWz0rcilI+Ks/4ajexq8XJrVewdxpk0AV2l9qYq311DmPM7e
         Kge6FvOqSoO9yugpDKkg9mt8LHUrTEF2CHi+g+KoGH4vktjrRd/rgLDiqVL/MYogQSS0
         eYSJy0wQBYbalbLIU/7QtR1iE88Plo5quvs/368yeGMJSi75D98wxqnL68hN6suK1t5z
         CIgdfB7o7DmJM4WoGD3WvK+5a34GQhKYkQkEUC06sqTtEXHieKfyxDJ8BWZfvMfY4pIP
         BTfg==
X-Forwarded-Encrypted: i=1; AFNElJ+1/LQ/GF/upc/nXyyHcW9+fTS8GxhC0CJoIAaekrdaabwjGJFaN+bqMsMmS8E/KcxTiGHznvDCdQ==@kvack.org
X-Gm-Message-State: AOJu0YyyzBkL2Wvs8QokUDjIt5Bo+rdEdVZ/kUISauacxMTK5qyvYbNJ
	XCCwkCqa/gE5YPKhp15bF1pEMoSAomSWnv/5UEi+HiWlenVWBwsbt5ravL4jXS0EzLYh3yHjoJ/
	XcrPwQskrFyIdCsrY41o7IDRJ8BBH4a1foQR6FgBqEwklKwW/cgaw
X-Gm-Gg: AeBDietFevQ9itPJrFbg7odHSYGxHDGt8z0SkDuns64aoxn1BRm2rgzuyPcZWhQPv+7
	PI7cyNjTgaKnSVKW2g2BH9kt7mIihvQtP0U+bitYiSNQwmOgJNqe9vcTSR5S/ymKWYq0+qMmA5j
	ZfoDsmydhGTpqRPuwW+4p17K+hGo1NQCT4xIWoh7OWT/xYgPvOJFzXQYYGrjvnkQNMahPx6gSCI
	9cfQargumt9i7Kz1fahNw6cKb7hMUzAIkFkelHDJcR1b63JnhTRPhQ1EWtPIKAmaj5nZXQr2TZa
	MNgLXTc934Khn1HcmGl8TufrcNdPMhi3IdwclEJYDIUoMkMVjg8BprQNChZi5P9Gorgt0Dh9eqJ
	QFJFMJqStoDg9mrpaQiJKC4OHfqYTNWFc3prFDoGWw5phvIBSSlGpsQ==
X-Received: by 2002:a05:6000:184b:b0:43f:e231:6721 with SMTP id ffacd0b85a97d-43fe3db2c4emr30836525f8f.2.1776808916854;
        Tue, 21 Apr 2026 15:01:56 -0700 (PDT)
X-Received: by 2002:a05:6000:184b:b0:43f:e231:6721 with SMTP id ffacd0b85a97d-43fe3db2c4emr30836484f8f.2.1776808916351;
        Tue, 21 Apr 2026 15:01:56 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e46471sm39731110f8f.28.2026.04.21.15.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:55 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Subject: [PATCH RFC v3 13/19] virtio_balloon: a hack to enable host-zeroed
 page optimization
Message-ID: <585a71dace8705d604da7d3093c70896eef5b2bc.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HrFMu5972J6mqxFwt4BJfU7ERsjf2ENfZJx4IckafoU_1776808917
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 280CBC001A
X-Stat-Signature: 1ndp7gk3dq33uaj8jgcx3anm6rggsod8
X-Rspam-User: 
X-HE-Tag: 1776808919-549447
X-HE-Meta: U2FsdGVkX19dg72QAWGRnBq985asxjP4CagDQfwUb4S3r61nxDzMxOXobzxxuN+/mMa60G1FhUDXyfzSZ/9JndbHHbB+KB9T066ZYgA1NOYXwi5fH+FAxtgQdlazID4LNRPEul6lRG7lHqPwfXRhYRW/y/DaCWYWcNmjydMtsCUlyrs5/f0PdXmCNSwZ8Q44MGMhE48rxtA/Kc8p51GaRLA7wjX1+dXcbTur8DCgZg785JWVMwEC/rw2gTEoJCEIjv01/n/q0yDNJBRY7IqlWn5YsjlXSfC0FzfsdVY5ooOvUJFlpPV3ZVBMskS50Uuat/a5frybsAnaeQHqTxMJ8YZaD75FxDbkKNZD2eaJkDIORIEDpRj0P0zX6DQvsxnPN+G3juMCTxikFCuXQiumaaDJ1VTnxOOCSuMFJLchcGDzR/fkRFHLUVS3GR/reADG/m/ntHBz+pOtKGSBL+qR9sNqPJZFwAhKim9OTA4Wsqe6ATQUkJSxhifTWPHgT7anBJEJCwKRHotF5/jA+rJtRlR/T5CMHI3MTPggFJK3+Y5exLcM6VPlRq+GP9EYaZwfeXc5M6oH/WUYKormpXnwLHxHwDNhCDP0yUYGQITl3ETBFPhrAYB1zMXh0Pb5PM2Qn8l6iAN0KsUA7tFcowi/Qq2yw/cZCpP1daAt30lgjLUft1O+6yFjBY3sHqsS2qXGAixvYl8hRt/dVTHNEtqmks/qkMYZ/Mb9G7HBoLTnGWtr5dxc09DYQX2oPpp/hnV1fZkAuiLnPv4Y4Mc4G8SjFQMjdiRh4nG05D0fMnXp5Lvz7IX3NLiLEdSbz025gjulhkHbsVAvvw2yL58sHoSeHwWLgGEVS43ihTn8eaJdP/vyALHwOMwpkV2BPd2xhza8pvbJ6vUP5nAIJftiuzT97KMMxnNi61oXEu0TU/1U+NWh/uqkl5cf+XmZXEn9bM0K2Q27Z2LcBznvAl1XPkI
 hk02kl3n
 GW2CdgGJRQy0GBVfYmXchnK9xvsNkmb0dHswOHQKqB4lj/i/Gn6hssIZWJ0lmJ0T5e/lIHvD0s+yEjcB1AjqSRJdiHBIU+ir9wGOwqv/gTRY1f17NzHmwCYBZ8oPH6GsXR4gj96l0Z9ALZ82Ifk0yFDa+wJIuwb6DPp2zH9E5whLlLqxMWF43JVAm5LyoNeoyOLGfAviRx7Rnop5v7qlr71ap2acJGGUGeHjRNnwuHOOwKckwVq+3liTNTXW7MlcXB5KuQWeqJwc+jvTnD1lSZiTHub4bHWufqolNK9YxpvTqvFcNUJ3gg3wC6tLUUiy5ECaHgdvYZBxcEph1EOXMo6V66+c2+kt0FSeuthOocOB/jZ8LWMjnia/GAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a module parameter host_zeroes_pages to opt in to the zeroed
page optimization.  A proper virtio feature flag is needed before
this can be merged.

  insmod virtio_balloon.ko host_zeroes_pages=1

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d1fbc8fe8470..165b123caa64 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,11 @@
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
 
+static bool host_zeroes_pages;
+module_param(host_zeroes_pages, bool, 0444);
+MODULE_PARM_DESC(host_zeroes_pages,
+		 "Host zeroes reported pages, skip guest re-zeroing");
+
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
  * multiple balloon pages.  All memory counters in this driver are in balloon
@@ -1039,6 +1044,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		vb->pr_dev_info.order = 5;
 #endif
 
+		/* TODO: needs a virtio feature flag */
+		vb->pr_dev_info.host_zeroes_pages = host_zeroes_pages;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
-- 
MST


