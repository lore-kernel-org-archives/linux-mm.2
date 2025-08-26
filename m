Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402A0CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AE18E0108; Tue, 26 Aug 2025 16:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD1B8E0105; Tue, 26 Aug 2025 16:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA048E0108; Tue, 26 Aug 2025 16:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B70078E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AFDE13931D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:39 +0000 (UTC)
X-FDA: 83820117318.02.840E161
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id B63CB18000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IScVRFBe;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UgrS4RlDzmuPVEoYRuL5n3FdVX6RzYDiuXN16UyzzCo=;
	b=11U33kH9fzdR1AUHDmeTcIWIA8du+6P4hqylrrNv6PlKvyPmZbsoc9XTBSy9Okzt+G9d6B
	Vbax04BUo5L2igJd7AearY0fwJtXPPFP5Bloo7Ua8XBbAw5U8jdTnjrrtjurEN0aTNO69m
	8Nb77mrIn4xClw3DcapKQXtwQZp44Po=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241797; a=rsa-sha256;
	cv=none;
	b=WGXnuk/sSb6OPpKcndLWNSGpJaF4OPg7xirtyqc3TiawNfrSAmTM6nwVb+rrX6oT55TElP
	Lm9ghaYdv4qeEfP8iH6n3rAI00s0ulLbJW73myeYkhftpPS04gfUNt3RB9fqhyB/VTKJb/
	HzT+ahyBIvFBrdjE2fNemr/uBmv7Auk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IScVRFBe;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-771f90a45easo1212833b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241796; x=1756846596; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgrS4RlDzmuPVEoYRuL5n3FdVX6RzYDiuXN16UyzzCo=;
        b=IScVRFBefxVEKwu+/8YjY46Ot4sIckfEeU7HcJn0vXERrXhiRZpo4lZKebem3my9PC
         kDqc+ZJiPG6bqcTV4nNDaYlmTl+gq0vgx7I1Nl586frTulkxrYioKq76PmfgiWUsvCka
         TPEzIBPqCl49wjQoFwPN9PjS/D8N89H0IZ43CKiDerSXM9qyunoo1Cxyot9sjDHhvGTv
         /Z5b4Y05jaynpgzlQW4gHItcsipDIdBtWT3hCaOby04Zjgyn+7aaHiExUDQ/nB0k0SWf
         KH8MoCKFA1rQryYdsuDqvjHfCnL6gi48rjiIOrkHo0gANWk63ICKKbbm1hCSRaoqtu2e
         tfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241796; x=1756846596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgrS4RlDzmuPVEoYRuL5n3FdVX6RzYDiuXN16UyzzCo=;
        b=Q5zgq/Po6b5EUyHIHHMOCWXtSWn7hVfvzpdET+HQKs3BuR6vvZtL05EjNdP49n/b5i
         Ei6AGIkKQI9x2vb7Jh9K9prHapUYklpO5yQA1flYwgR2MbDEfnfQZRMoCzZ21ogPZcnT
         cw61PrEAfIpt+6e7uqK9CMQQvrfNkMdv1Ncxce4gxrH3544r3/IJQW7Agd5ZRyR4uLkY
         br07dxEt0/lJdfsWiAyx4ddWD4+5tmXhUlUq8Do8AftsCFS2PQiNefqIp/ZWg3c9sHT0
         qmjs1ZH/hYs0zAf6ZLsUCi7tOMJ8DiobKNMSrxucE8YRFK3AEbC7NkF9eGB2tcdSyEwN
         2q6A==
X-Gm-Message-State: AOJu0Yw9hkHrz+97J/AHlCC1HyrTfcQcyMLAgtKa5khgIBPGo0gsxLJI
	MuJV9UFVpCxo32IJk1pu0CyMDKTSEx1LH/8EKPWkPjdNk+lp0Y5DfPq/XhFftA==
X-Gm-Gg: ASbGncuGuIa/OTSs6M9Xc3/QW77N/4Gi9IuKdufMgsjJgeUA0E8heRTGfKOrl8rEoS4
	OtzrZ2GebwG8o/rBVg5Qyt5cXJ15Ty8APGxCsP0pJ4Nb8fYMC2lDvHhIZrjzr6muiWlJI+vZqHO
	kLm71pQarCDfY6rmy7GzDYCIJL5VfoER+m54Ws+7jHa28I4xUxLYj162SJOHOkd/nR7SCo/x6Yu
	2GhSKdut1KUTRxKimOSWYsk3UrkdHwqvgtempqsdxJHbhTDcbleJ9K27n7kCuUVCQCnG5HZNhnF
	Wx0xK1izGRS+4dp32nTQxKPWVZe1bSrQhnIszfY0lG6sGHdDc3Xlw8KzBjRxaEbVU8YkYaKWa7x
	dhTxuAyjWpw7sjN5mfc7dr3Tl6QIr/VwwXT8qgtGpb3wpBA5PKEXrBg==
X-Google-Smtp-Source: AGHT+IEbOPgwcWY4znAzk+xsxvGrwmBJQhhbWaA2d4cWZJEHNQJ6Rz2YR1r4+4mBHFS8WJ+nt+eFzQ==
X-Received: by 2002:a05:6a00:398a:b0:76b:c882:e0a with SMTP id d2e1a72fcca58-7702f9d8ebamr18348240b3a.5.1756241796134;
        Tue, 26 Aug 2025 13:56:36 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:35 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:17 -0700
Message-ID: <20250826205617.1032945-8-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B63CB18000B
X-Stat-Signature: di8aj5kjkmc3imnnqhkp1o9wzy1bnota
X-Rspam-User: 
X-HE-Tag: 1756241797-745089
X-HE-Meta: U2FsdGVkX1/KQDcnBEl0rAZMIufHY332I0oj+Cl8pgRPtn6MuF2N6DxvnyodlAtK/5Pcl0HFV8dYzRFtheF10nzEKvLJy/dIp6jYQiBXFOnwI0yCCWnrmiNiRvNUdJl/VgBuAJVX54GhKXUNf8CMQJLxhafRjGuNWFgBMS8H59KNE0DJp8z3nKlUZm3hjHnvAfyBxwPGAccVk6V5valk4JXWxnnaFvkMcMy4RG6XjYhlwoIJuoa6797rYoH7WF3f6+U5Yd01ZuEOOEc7EcW1vKvsGOC7dLsQ1L1Ft3zD686x6EgOoPLG8RcxWbgTXELWLexHp03LJEAvAMubY2n99XwJK9tUkwC14Lw827FK/CraTyK8dMOYRlA7PaGLKAfzqZ08g9/nJuAaolH9wE8Yp5I3119LnR3bNt42yiWzOEtTSSG3UynOHoU6lCqXihJLloLFEypmqTvOKTqZZ70QwSA4Xh7f6FfBBkaQfjeu8e4DW9c4Gplx2gS2QwGn+6AlzsnmtNXXu1sR0JaiTUxqSX0aRnaJusV8T3feUoOR/vXEXi7ZvMk+I0Me8sTar27nghMtriDcU++dxTsTKEOiY8HfAMOYPMbxcC5NRNt0MsbcNp7fIZz8xtFxVEqKyYRpsIYm8fv2aiQUtAxcxqixo2WvUi4hYX/MrpgY9Amq7WSbNraqUMI2YB1RGTZ2ctPZPL27AKZOkR2ASkoG1eA3rSIczMfyggkRy1Q9ZH4wRVEK2TfaciwLKv3VlKvMSVXkoE3zInKcSxohEMvROw62MdhESGpfNeRZDmnCVR8h4tsdol6VrzdPEQuwmakUeqd/cyMeWVgr2qGVs9jNYEw9/mOczl2pS9pE+F0dqOiqPtM75TAsIU6qIFLmtFE3thOChO6bwQrpiAmEQTaKUXWqCHKRqK6rMFXKWovllueVnf3r5GdK0Jzqyr3Bel1VXCEWYY5aH60hHHt13U323tO
 X+aqerpJ
 onxt0IYq1m/vsppZUZuaHFTMsnYsIXbiDaU0Y4nh+DflWqPvP+sMG0Kvm6bNhxBMGvzre3jIqHqSBm+uVGr20bpFxSDhL8Z4BElMGSf7UVI0rehywn/Bm1ICFlQwpOIXOdNxGpp9ZAPnes72I/oCM8PYkaB82ABPTQ5Z3nVj0bTeskkRTLpjousVltrYGrvRJxycJAJauaw37slCH+68y8qCJYnfqtCgpwNzzTr4Pkcukmp/HGHpNHlswtpsW8gP8hPHW9QfFo/SweveNbaj1bMMoWOXl+uX+gBm7Iy7JghcB5I0BuE2sxGdKrNvQCd28n5MjttXZIuyTbrVj7cIH6MqXFVbxMNwGTpTavvz6g9WuLAxAr3572DDFKGG9i3OGB/RR3j/JiIZNMtLYbdqGd8oUWK7mJAy372OuBvIEgtD9W6A8biUnYfqj3gG4qppciypXSccxrUN//D+5YJwtSfjjU25MNOIs3hkj7b4PlvnclcKoZQ0B5lgY55p4YHy+EInf37F/WNL9Iw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 drivers/virtio/virtio_balloon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index eae65136cdfb..d4e6865ce355 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 		page = balloon_page_pop(&vb->free_page_list);
 		if (!page)
 			break;
-		free_pages((unsigned long)page_address(page),
-			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
-- 
2.51.0


