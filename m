Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE67BCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8586B0005; Thu, 28 May 2026 09:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88FB6B0088; Thu, 28 May 2026 09:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77BF6B008A; Thu, 28 May 2026 09:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C687F6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:56:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 609D1925E5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:56:37 +0000 (UTC)
X-FDA: 84816978834.02.06D7289
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id F41E71C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:56:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aoWBZ5s4;
	spf=pass (imf18.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779976595; a=rsa-sha256;
	cv=none;
	b=xeZhzT3TwbA6llhg1UfOIRdKm3igl7EyaBeZh2XvD6Tz7+JwE560zwACPQSeWfQO1YvrNj
	A5mASC7/pMZqRBnGsONlfTOj4MvqGNXJyHI1kBSYu0/E8G9F0xUnkHXeqHvj5uvBcidPkg
	10v1j7vdiMovdRh6GS9kTb50aPVTHdo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aoWBZ5s4;
	spf=pass (imf18.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779976595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hyXTfkP1FRh0lqI2LqsI3h8mol56zeDTFZGvJgW2VWQ=;
	b=ik7uAyzAv1fHgoCjSBT5ZE8H+Aump1VczY7EfcAuqwD5Xjljzk5+VP8qV9gqx/W0eem6Vz
	4JifbPscajB2wlH2Mwsmct1IMoh8ubR22mqokNZQgYLaOruVpIGpb2xXC23viLOViPIBN6
	POwXkTSGTcO7IF3gY3cZP3AFQ80JMqI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779976594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hyXTfkP1FRh0lqI2LqsI3h8mol56zeDTFZGvJgW2VWQ=;
	b=aoWBZ5s4ZchSC56ODEgv3Rtr+s2JyowQLa1C4+gBoH/KXJOPrj3snUTLgDQhec41hY/63I
	Fy79V1oUBtttYycQlAiZVDCMNzq7g88V8K9NxMuj5QGsxudQkCt9EsIgGfJoZ9sA3pbDRy
	hutnB19IQZFStSAHmpcMrcN7skkc/dU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-mK9ovfpVOtG2iUF1MSRmHQ-1; Thu, 28 May 2026 09:56:29 -0400
X-MC-Unique: mK9ovfpVOtG2iUF1MSRmHQ-1
X-Mimecast-MFC-AGG-ID: mK9ovfpVOtG2iUF1MSRmHQ_1779976588
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9112b2755abso2853412185a.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 06:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779976588; x=1780581388;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyXTfkP1FRh0lqI2LqsI3h8mol56zeDTFZGvJgW2VWQ=;
        b=kvJ2+/JsqGDOdXsg0mMfWnNWASU/txhXNZ5f7UKAfjIUGOAK+zZbIiLutnY4bab6IT
         amgs+cYlXusDpO4bCB7zsatYuOlKP/GrUoBYtuWrpuYzJdSd0XzyPxMKZJqDzCUx41CF
         uXuY242fOW4Ciehstg8crGQxmFtRXTGO+uyFeOiAr45y8bIyzbPyO5J/kPatgWMjz4q4
         318HZqMg78FZ1BmThPHDcHS0mC0bOhcEuNdT1sTa84+dTGKWNBSPRP9Gv48l4nZDRfj5
         jz1FGoDwu9LINb5g+Dwnt41UYlZSALYoP3KqeTVh1gPrS9Eh494bcxF2aPRpdXaQ6mAj
         ih6g==
X-Gm-Message-State: AOJu0YzSAEj+NhLRhfLqXxDdBDNZ5UtLcW0UOytlv315jB6V+qqmHtRl
	TiZ4kZwarZVRxYn+tyDjoHO3s9/m84P08VliTe6jZDSpYKVHkfnXiaz/AXEdxdP5LygOyFRT/xA
	CiSAg/z1NXld9kz4wWbHHaASo/glVrROQh9iszIstFEG0c5vwIOmb
X-Gm-Gg: Acq92OFKVsotn2LYEBT1headtXJVWdPcWTzTwjpFgQuleK6EgBoy1MR4jmiUj9l2kfU
	ElQPteedwWx5ZnHsb45zQp3tGJth1pWC86KKfBmoLZftqXb3enJ8skyAodmGDCoSBeQxNTy+D+c
	eWLAY52ntcVE1JEAhvU+Fdt367fE/TAJzNui0cbBm9o/lxjujBJKCzCmNdWeuvE/H9ujqdZye19
	LD97sbDH+K8zMk+yyvSKsVFE9Ljdt8pUEFvAEOAM87cjgJl8lK8cX6qEJ7KAtFsfuKd5hY6o0tG
	iCGt2ta+4+x6mDO8JmVzlkZJ8e9bPrEkn0tsdXb95ohP0QfYL+48l6uiP6j5ObcIUny9YU0eYp2
	TtFwi11s8yxtjFpw69N8iTa1x5f18XQ3Ddg2IvxkQ7LpvwfZQzsYM/V079SIYWl1xVovQW24=
X-Received: by 2002:a05:620a:19a3:b0:914:c080:ccb0 with SMTP id af79cd13be357-914c09012c8mr3405777785a.31.1779976588493;
        Thu, 28 May 2026 06:56:28 -0700 (PDT)
X-Received: by 2002:a05:620a:19a3:b0:914:c080:ccb0 with SMTP id af79cd13be357-914c09012c8mr3405772485a.31.1779976587859;
        Thu, 28 May 2026 06:56:27 -0700 (PDT)
Received: from [192.168.1.3] (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f8810a50sm840383885a.41.2026.05.28.06.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 06:56:27 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
Date: Thu, 28 May 2026 09:56:14 -0400
Subject: [PATCH] MAINTAINERS: add vm.rst to memory management core
MIME-Version: 1.0
Message-Id: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDQAxG4atI1g04A1rpVUoXUf9pA860JCIF8
 e4OLt7i27ydHKZwejQ7GTZ1/ZaKcGto+kh5g3WuptjGvu3iwDnzltl85Sxa1hrMOekCDqNIP0v
 AHYnq4GdI+r/mz9dxnHK9OzNsAAAA
X-Change-ID: 20260528-mm-vm-rst-maintainers-file-1baa6da1e7ef
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Brian Masney <bmasney@redhat.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=900; i=bmasney@redhat.com;
 s=20250903; h=from:subject:message-id;
 bh=KfHVrPLYMrGBcgO0yiMmvFp/Yjp0kVYSrt0zeI2/AVY=;
 b=owGbwMvMwCW2/dJd9di6A+2Mp9WSGLIkPDsqCpqKj4WeKhRMFwublW7S3Ptux5mNr8Jjk3c5b
 tml+n1KRykLgxgXg6yYIsuSXKOCiNRVtvfuaLLAzGFlAhnCwMUpABP5VM7wP+TbCd85q2SP/riz
 faHyEkO+istJLw+nrZqosOA1T0P0lwOMDH3H90Qe2rM6r3fRLJb9c5xyPpvqaf5JP8GuYtR9MbL
 GhwUA
X-Developer-Key: i=bmasney@redhat.com; a=openpgp;
 fpr=A46D32705865AA3DDEDC2904B7D2DD275D7EC087
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Yi9IGLo0PyHbCZDVmTsZIRITCICsLhtugwI7t_74cws_1779976588
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F41E71C0002
X-Stat-Signature: e98iktr6p3g3k16nirdcu1bpgend7sjz
X-HE-Tag: 1779976594-59491
X-HE-Meta: U2FsdGVkX1+1mt4pNr/G3xMjjrEOU5ZlxMaAfoSeB2gzVmT7uBLMfYuC+a7LqJP9xYne4a2oGpZjkz9rBdoQ6zmZC2yTREbv7GcONRjQoL+JEizDOL3Tc54IONBSl3AYA4o9A9/laU2Gx8s4hCSHp/KLqSnu9bRLyyyx3X3uDOcuSaovLc9fzR08GnIjZHbVUcmEJ7EwUYdAL3DQ5honbWFiKgJpTliB7NF1v+uTxA66GvwNO6qJvquANGgwvgq7tA9l2z480csy8cZ/qHgPYQsYJnp0tS5iIsJR8pM/o5YYknSNHVp3T3pRgUYPdTeyA380mKvc9h3otZym9HIYNHJAHDQtcOEB57HGDYsLdcTCmlIzS7mww5VmYPxFV7ais8Zp1Ri8hxVO2m0PxS7yIskb0GQ/L3WCVGbhY5RDovTs+8CqkgV0eWBXF9rsBaIsbfEBslkC8AB6LLcNQQrspFf4O7LiUXNDnwTCqrvu+Ywc/NAbhaHvxUWME44C14qDzyTf2rcO2oAnLQaQEWe8s1qvRUdCDRG/6p2vJiHMDHzXuhqYwpAQOlqwbw5BpRY8OZA+yxQktgJesgoJ/eoS5Zi7U6OFJKSTtY6FG0Vpyco582BF7wsQsi0da92No24Xrmnpow7uOsnWTVIx7dDd89CzkpeGIvrKW3ZkbwQePv4+amIMgE8VsUw8AKSXiw/hCTgQUsczFf2iChObnZ0DutTqoqrwye1v3nnNG5rR5YOo/0+wJ7YRmnz22SxdBonLyBDES3lcE/aWRBGYMwSuwf9VCMxqlwZ4fAXrcLgHKB3O2ZYbDZYzZ+/W/+1SLmDVIG4zWVMi/zJOF4bM5CpxwFRO6ohdpwpe90VxEwLnPtWp/VVyBRCCsHbeNi8yDA/NRnkFmMvt8K7TgqS435QK399A6zMzRcEU4+K2lugJGpuAevC1FeDTQjspBzgKlZ/jQ10v+qppFoFBY9cZxZl
 DQky3JOI
 IjjsN9WjrHn/Fnm/R3VgVRXMIpkEe5EXZ27kbewAOM8c82g8SNanddkeEJemFzmr6xRRW1gXHzzh31fhCY2rV0RG73JQMnefuHlHvqAlKIr8TAVujqi+MFEfkMxSwyFgrkrrpq/z7LhczTMHRXMpzxAxApjqGfwJYb0ugi9s69nuuz8drWsMb7PvW99HDchUxid4mrjODV3SYJHP6FaTUKlOpacHxp0IFomeykhYQtanYc6FVO2Bz5fRjJyxWWaj2Y1d0P3QKXP1L5yz9yggCbf0ETvPFYbGWNARd1eMGLjjpzT0jj278XI1bl1Ce6Nqz8YB8zHQpX8KfITywjwy0qx1WZeE7rPlMv3a25oCZO8wX5n84/eyaglrIxXat+3xpkG9XYUIuczwaEKhjfgTT0YlrHDjeJJn2NKOQ45plBhVDvCUNhzmkL7JIaPOE2IHOthlRf+ERg6KT6nMDP0deN4jV7BmmygCHJ3buVnyP0L3afUqdmrJpNDS1Alv2J52io8+CmpQBOZPTPFTRYxvERgB/1t9G27BfbozAQ3J4qi2lgis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm.rst file is currently not listed in the MAINTAINERS file, so
let's go ahead and add to the MM core subsystem so that the maintainers
are CCed when changes to the documentation are proposed.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c99f0650b334..d8dcc4f25ccf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16923,6 +16923,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/sysctl/vm.rst
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h

---
base-commit: e7d700e14934e68f86338c5610cf2ae76798b663
change-id: 20260528-mm-vm-rst-maintainers-file-1baa6da1e7ef

Best regards,
-- 
Brian Masney <bmasney@redhat.com>


