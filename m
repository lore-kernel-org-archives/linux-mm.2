Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177A0CD5BC7
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C1C6B0096; Mon, 25 May 2026 01:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5996B0098; Mon, 25 May 2026 01:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5696B0099; Mon, 25 May 2026 01:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9A46B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:08:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A659BC164E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:08:57 +0000 (UTC)
X-FDA: 84804762714.05.D53F854
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7178D1C0008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:08:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IeKXi43r;
	spf=pass (imf18.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779685735; a=rsa-sha256;
	cv=none;
	b=eSdw2+1ZKPuf2ZgypF0SmQ0/Oy8lzkImp7jSlOtLs/4o4IckEA59KRMsTzeAkxa/b90w2Z
	+oz8wG/FTyNBqWamRco3ZGl8SOKxUeiZP5FwGTS3mKM9lOGN7VlVlhBNJvp/Bun7ZPBFDo
	mxyl70t+/EgsKyd5y6EjvZ7SPkq67tc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IeKXi43r;
	spf=pass (imf18.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779685735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=D56ypg4GQAVa550m6aJ5Jz6X3YhhErN+03DRM8U0W2QqBVq6yXDYPMoS1OupGnQbs6XvZi
	OzMgTtbx+oyT6sbQsId9eLhKDnWIUhAV7Yhd3UgtOM0+1Vp/rwk5PM92HNEsH+epGMUwCa
	YxoPv2Teh3J+6Vz+LdeLj0zIDR+Hkrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779685734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=IeKXi43rwCc84RDy1yeKw6K34eidyjgTbre1l3EtdJ0DfDReA4Vx5H3shupy8pYC708NuO
	OOHl5hojhi7bSpWoAr3kyx7fIGQmAuEhBLw3Wsdg2bY0I+wStbbiVnD5IXyWQBQlY2OYcm
	p1v6YwgU+AwT0oYabwAFccD93PI45BQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-DM6pW9fiNbevepf4l8dUvw-1; Mon, 25 May 2026 01:08:51 -0400
X-MC-Unique: DM6pW9fiNbevepf4l8dUvw-1
X-Mimecast-MFC-AGG-ID: DM6pW9fiNbevepf4l8dUvw_1779685730
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3954be32d30so37665921fa.1
        for <linux-mm@kvack.org>; Sun, 24 May 2026 22:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779685730; x=1780290530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
        b=q9PDUPzILCl+IWPEnmj8URUqQN/VVY9yG9W1uJ1tn2EH/8WVFv7OAbE6NJkwfYoOcD
         Q4ROjUqArdhSdbbeexOZVfw02MqvJKWpwBhWG8AG6PhlEDq9EMqy3z8jK0TTIJjCwy7o
         sVPjgBZPiYCd4UwVYPwSguqQRqb5sMMfv1kzY2bWiZ6lek9xx5FcTC8Qpb80ts+IwwjD
         tlpVeHUqhXblC1dHa9jtbgl7ewpjgGVlzpmlq9LKA6McbhI8zfrSSP/Nf8NDWtIAeV5I
         91PR9dMwQEinNJmFFdzScVY5Y5m0BrDGUwDDz9HXkYdns1Tbba6rLPwiylFSJWLKqzhb
         Y2xg==
X-Gm-Message-State: AOJu0YyhWBc9nTMiCnVvevs/Rsjwr7oLx7LtmeYtAkI/o/k1g+WeXLsm
	2eJg5l9gnytgl2zVsyXst7vq0e4PZb3jdBI0x0uvKz8nZYHHRmlKL+QEsbC3T+zaUiAbHzQ7otb
	Ni2WYQsa8FZxemKMxSHtN+0MZyzSVb/Eqnkdga4SEoKsdPeVUTRr+S2GzRRTVVQK6AmNDH8qAV8
	+eWLDoD/bWHze/7ZOQjChfYoC3sA5JIZHFOuP1xQ==
X-Gm-Gg: Acq92OEq/YIHmk0sl9+V6r16Ik11EB/OqslU7dzItStdytIr4aiATcJeSvVe9iRY1ej
	6SUOp1YdknQsT6Gz1plNArXuzYbLdqMgIc7c37HndBF0kF6ZDyikq4UIFqidzPZav59zz9dKI9t
	IW1QJnrdrj8IsFrnevCsT0RVZdblSb3GnQ9l1NLcA3lli8zeY9tHjWEjNIpzQf1Llb3GLT3Rrlv
	j2OjKGfRDgojAeq8ew/cktyq04Kz4bWJKOyBw9Z2er0vtHMxMIN+fPPdmoB2Mjjm0JO2dkWevED
	uxX01iAoXGjv5L0fK8beDhfwOwB8GsRfBGNNt3YIxeJ3fkn7WdDSBDiGhOC87BEE+gPWCWu60df
	W9ZME8v3xkXronJNr/OyW+7SAxeq2+hP3TOMQ
X-Received: by 2002:a2e:bd06:0:b0:38e:a00e:2bb5 with SMTP id 38308e7fff4ca-395d8d1d1e5mr38101501fa.19.1779685729852;
        Sun, 24 May 2026 22:08:49 -0700 (PDT)
X-Received: by 2002:a2e:bd06:0:b0:38e:a00e:2bb5 with SMTP id 38308e7fff4ca-395d8d1d1e5mr38101271fa.19.1779685729251;
        Sun, 24 May 2026 22:08:49 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm20698161fa.16.2026.05.24.22.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 22:08:48 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v11 1/5] mm/Kconfig: changes for migrate on fault for device pages
Date: Mon, 25 May 2026 08:08:26 +0300
Message-ID: <20260525050830.100254-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525050830.100254-1-mpenttil@redhat.com>
References: <20260525050830.100254-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kanSHo-6K2uzTUgHzaDw-HicOV-NoLyYYwFub1Vs2CQ_1779685730
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7178D1C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: a8xh7hyfx419oiuwum9f1nwwndb1896d
X-HE-Tag: 1779685735-9310
X-HE-Meta: U2FsdGVkX18EvXMWrlRyblcpoXgh0fwVs/LHcThjVAEfbStXvTRAykdv3BqmTcKuN4JLoRzBAfh5ybNy3kg4EH1t25lG9cvXHOHt143lbNocdNkZO2+/b1jBVDRJnVEex4Thn6bpVILBqKZxOnAvXrc/eFc+1UNWL1DCnnVSubmxhzizyMuY7zg1cplPiTkOx5LggXl0FOTPOD1pgEeyrKYhM45xOgDFWHBTv96Z0jnBL66Oihj2TcF0FJ2oAMhazVKIZsOLn6gFYKPJ6V0jZ+JA5uUFkyrWT9NT6HGQJ1lp581n+hdEEMNNM64y9rXYhPf/b+l51zxx325WpqUWpRrIewh/VgxutY839oE6xuMbeuYSutWovJamsEIVvo3JzeY+sa3xlgYGe8V9YWyhhtUC6KWATqCc8wvRaITo31s+w0LmqviFSTSB7Ihljzq9LX7gpQu37p6TZDEIQ0BKV19T8TK2AuK7/0wMCt7AcCD5TdX4IeMsz1Eei5YDmBUchCACijr3jiOy82933F8QGk68Vstp7zJ4etZGXHC9i9DkFuS579zVMhPGJ68a42XO25RDkqm/V67JBmFh7opdZnHHaTiRXQSr/wPMGMsuzpfCdkrJ4gqwqpojzUZpeHm+qSFUE4kg+FuZM2GVqd2fxYpXIDWsqpT+SDnmaFh8zSCcHYhV4z5Qo/ovVWMRleXJoVLjWrYicbA/8gWWMaZjDihqFME75QDxhD4vsQeI9gCAQPgFC5+CR/aJXhr+ApjmJ621I3RXfL7fbTXTVACoHmA5pz/ccxfYcsR4fFS8XqfxyJQ7E8Dl5jHK6rZJ4eHes/avG6NVA4L/pA4ovK6dSCKzshX3xAb5LH21ZW5BzXiJ4z8QL6h9tonxjFSxg3IESSnazKG9dnikmvsrbJ+v0LWGI2jZbm03MdWrTtTHKuEwuJzVQ4R3x6vNV5ak0LuExKo2BkRmUkCcSx2cNrb
 BzczJ+PD
 vu1w/v6S1+iPnbgdmWC8Rnp47HaPCOE1I3fCEKxTYCGtCSytvoiHJdf/ov75zwSyqri6uD9tRo8RuMZXdIxC9n+Y/+33Fsr0BX8uRStaZxPqk5YI9tGYyMrPLtfvcP7D9OCXupaeI34sgG4GCx1u9u1vM0NELNj+Ssy9WP+dBgOwZWxibH1elNoISrQb4KQ0vjUboi1zzw+0mPN3F5QS/ugb1tRD24rHscbEnZk6ZcRrowgQbBUHHjBx7XXM6kjXQji7TmzQuxA7Xd68qfv+HlFs0ekju9eW0bBs5+S8lLoTYDOeQuyLvhK6veTvuIOaEVkkcirVo6+5eksagiXsucm0LBVhk0/YfAzOZRn3nZU2zsD5DECV7/caxIVAfTnVohS8IDUVBWdovWS7LQsbKpoNOKWoZVwIi3KWaLD3sDITN8T9c7mvu2r9K6IVGp5akAJHPQjIG1qkPJSLtnBJ3wcEEpCDtWUD3DbZ+H9PvF+JfHoCqYKx6UmN7bfHrfPmIDZDjK2ETG0VvJF/WCRUpj0gCSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..0d8db75ffc23 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -646,6 +646,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1221,6 +1222,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.50.0


