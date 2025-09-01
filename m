Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFFCCA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4828E004A; Mon,  1 Sep 2025 08:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654B98E0013; Mon,  1 Sep 2025 08:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F66F8E004A; Mon,  1 Sep 2025 08:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 346978E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:31:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6175C0816
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:31:08 +0000 (UTC)
X-FDA: 83840616216.29.1B35CBE
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11EE8A0011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:31:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=CCipjsxM;
	spf=pass (imf15.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZckJdWYT65mLwvxCWKoPCArrn6/MXXjzKwssfU7w+U=;
	b=P/67yyh7AFAxNnJeN6hKhCPIBhwlwPogj/06Bg4/XoNfi9gMr3lg8fdPWnnGMEIwh2/W8c
	BKTzCYyZjQXdeS+ja6hND0y5p+eUOe3C/3Uapg/2S02tiPaDCU/ehvDe7byCp2KJwF6yqw
	hvaGc8etS9Ew2WUiHfXon0af74ms02U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=CCipjsxM;
	spf=pass (imf15.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729867; a=rsa-sha256;
	cv=none;
	b=v7JF+xK3w8hhCuEA40L/QBKbTZsJkRYSyLMPu5+WpAT6p6YfxM3pNfhJ/0nm8y3vA2R1CX
	tJwLC+bJm2YwB43XjWyoHIpeU0q9pAV0Yh4R4+LzT24RHVsFELv4awqsWc0AY5zqsYVbad
	C66IQYTlXTMD25qblEt/IJaCECXifrw=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7a16441so664086366b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729866; x=1757334666; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hZckJdWYT65mLwvxCWKoPCArrn6/MXXjzKwssfU7w+U=;
        b=CCipjsxMxP+4XCZUde6IJobBpr+kxTNLHngGW8gh5Ow4Rt7X8Nov33R3un9I6I9taT
         a+kYMcpd1eB4GHb4k+6ccxw8vaJTpQH2Pln4MImwViGkk5YpZ7RQUYaPJiAL0+B28Ue+
         LXQgx6kSviY2gBUuTOMF/YqNdo+pSW1ehID4Z+iTCyFYetlz7lJ/yiw/tYxMR6hez61D
         TGHYD5V8TppjRJ+QG2+wy1lxEoPSoX21aymVvKQ/6MiRI5n4CzGF+rBddwYrpEOKH3nC
         COVqNnnoJMbIOf9S+QJphdpLmHu3lhyNIGFvDHAJhZCa7bzW3q/kT9e01cwYsMY4BKAI
         bBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729866; x=1757334666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZckJdWYT65mLwvxCWKoPCArrn6/MXXjzKwssfU7w+U=;
        b=tDl9VLxIbyNNpriXZ680AuV9H89J2SOZjGa/78N96hy2RXiUrV5FBf+8vpfU5Q9byR
         pOOFhh0cN9Parh8O8avECZH0dhMv9nmDPPc1LakET4FRhi2mkjMiYGcVK4HEO9P22HNC
         u87QLuVNMMrDyE1u35I7QfRLSUxncPNG8oC4eo1lQNcF9xIl0iqfrAfAJqXVJrFzpC02
         9eUHgd73Dult936H/01DhIrG01IkzlPYeYvRFKPaqzZQmc1/afEzhilIQ+bqFyUExFIn
         KCzuQisJAbvEc3j046lAi6tsbeCS72hd5EdocUDtlcNE+I+Lbw9Ly1KLnqDik7kHCSef
         woSg==
X-Forwarded-Encrypted: i=1; AJvYcCVoW4N+YIBacqq3QhglHI+nCasph6zy0QcGL6Q6b0akRR2My4NXOWtPvvXRmNnPK5g6SKwQU6syVQ==@kvack.org
X-Gm-Message-State: AOJu0YxpP5c+LfUh08/9FE7tY1DK+dmWI+kTpwV2vq7iYuyyp0DvWsJ8
	6xJ/ZN7uxSB3JAYM4rntaQoA5FIgQ8WbTE29Sj0Ilwb9uxl4Ro9keL5zR9j6IO7QInvT+DPbjg9
	AyDNC3g8=
X-Gm-Gg: ASbGncsoJ/iMMyIOhxLBKWZMQRmSe+sBNTlhY5R433out1jfLusTZKb0n1ttt2Jw+mY
	ZfcGeRgAHZoUq6rpdxGOzy0gSEEmv1lLXqgKwcvaqKI2gZD0/LcrOsXh6VM/Af2l19ZT9Vz27r/
	T44rYrCzTIxOX2igUI8/xFlc5AWSo4mk0Vu0AM+NlWLpZEWdKBVThAo0bEtIEcDJvSLa2Eho0aU
	T86jpCjrM3QmtPWAfddHiwUtBEfAjYccdJNV+wmYuJjjUtyTScGW1Rw4X6DMq/XSI/o7qy6B9Wn
	AmRu7vPNjXoadCn5PhYHvNN4kfyOdxTa8DNOtTsTKA+0xQ7+kh6x4lVsZz9YP/Oe4JFOKIrmy/L
	IrRpH5hblKk5L6HiWUyKQaGUePsHuGSi/rjji1uPaIiFSlRahNjOtXSmX95mH/c90tcmkMuGzRM
	JFyBKCk6ld2HluOgFLYeesxg==
X-Google-Smtp-Source: AGHT+IETxUI3qvvcJof3qThaTHBjP7BahOV3yuMasi46ZJMakvC6EwAs8jjOUppbppRZ2B64GjsX3A==
X-Received: by 2002:a05:6402:5207:b0:61c:5cac:293f with SMTP id 4fb4d7f45d1cf-61d26869f4fmr7390296a12.6.1756729850374;
        Mon, 01 Sep 2025 05:30:50 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:50 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 09/12] mm: constify ptdesc_pmd_pts_count() and folio_get_private()
Date: Mon,  1 Sep 2025 14:30:25 +0200
Message-ID: <20250901123028.3383461-10-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 11EE8A0011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: a3ur7bek9m13aaow36f4isa5gnxkjxpt
X-HE-Tag: 1756729866-334956
X-HE-Meta: U2FsdGVkX19kKZGRpglIzPOYwP/vlUyw/83nFzK3mWHuyZpalyijw2twW6FQDcddF+6LtP+rlPyFN06d3cx8C3yJt8jnsEuGqrmJgN6YCnxMAs3GPS41EKNpIX75Nu/y+Nc3Pcm4MzDCyt73Qkei6iMsT78bOXgQccutgAELrv2l0BJE7QLeGU5cBcuMopl5BlpPTtsgAF6W9w0hnNbaTQISAuzXGSxjLwsGI0LLcyJ86E+8lZmZoCxw61NWv0xmHJ1GhD/9Y8mONX3+7crszvurkxOUXnnXwoFQgGN/EbE+n//7Td17ado3jPTcVNiUkNtnGdoud8p4pqzZdFWr2GE8wDinkGtKGLNRYmiU+h1piGyLGM4u3XD9gW5W4i3rFXS5B2p31OR0pc8ey3t5MGTkLXNbWKpKHUM5w5qVHwsxZTTdhF2muWMgkAsQAdEwliEFKPhbN94Q6wb6odO0A2+SUiVOICliNSQVE6Hrvy8UlyDQ0C/Om5zhbsHUG6gE4VxG7+fLGvoBXchcq04AtSZuBoWrY2Qf2mKKBDeXjXGsVJ8wIizwUv4VyxDV2W4IbhkMi7+IFHCaBV+il9l6i8CHAWt8Zrjhmyq2XWg2y1VfDw5oV6DSRKilx2ftPaJMbjQAvKWhSb5ZX8TuZ2w0SrOkg10DOB9EplzPo9PtLTDOftYnWo1dzZaLvXtskSAoTR/0hFpgdeBHTuyCgTnapmmvqXmkupm4f1Mv2vkNbauv9cmnDFRhIk17X3kR+GxKKfOfFChTIS1kSEP8zhWzE1/L7Zf6Yor9HSyVgbE09p0hYkkdFXgxDQr3DovUqaV2PoXs1GzhHgcwLjsnpWyFNkO1yiZogkJF10vWgIoYWP6P+RlSL90/PKkWOlmjsPorNZPe+pkHJz2uu2rWPlUhlWGrUwAp3Hl5AVJjXQzcMvGqbc7mU54OVL/4GvP2FBMU2zn4mt6DL/Zcp/B0OpQ
 TQk8nQei
 tdAFPNlN+KZzCnOjgjtmWAjxjna5Vd1xWdJ0VzCoQ+e3JcFY/+EEKookfK1HnUwcAYHWQEUYGOX3q83aNPWc1qFVDVfREB4ib73T1XnwK4IXsDeYNsK2EvTNndBDiFcLPGzT0EYvmFZT7y4ZLof3DVk2bXdOUSbFHNpvXY8l0L7ECBXyEz7jYZi6ZPWvVGa9IqTMKUwafIOugUeyq2J8L5Se2EdyZP/ADl+GM27wvP0pJMBTO8+2L1IsrUYz80WqVtPF21tUVrmRnzmecOCs2gYqFVM5l66wWLM2G33yKyCQCZBCQ7Epv+pbyZgd6oMzbUdw+P2Z3+71QCzKCLh7xjMwilKZ2ZdsmrqOK8roXSVvssihYfkRl9gV88ljfxai0jBcKNXlJe1hbeEs70CqrhhNCrt5aHxmkymf9o4CQxbcoQGT7rHm/Wym5FSjfOIarq2JbxUSknUaim9HpQrPMp9mvKdwk95qma7r+sxpwutvqTYi5mkF4dy76ipc8Avfv4T4p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions from mm_types.h are trivial getters that should never
write to the given pointers.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..46e27ee14bcf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -632,7 +632,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
 	atomic_dec(&ptdesc->pt_share_count);
 }
 
-static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+static inline int ptdesc_pmd_pts_count(const struct ptdesc *const ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
@@ -660,7 +660,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
 	page->private = private;
 }
 
-static inline void *folio_get_private(struct folio *folio)
+static inline void *folio_get_private(const struct folio *const folio)
 {
 	return folio->private;
 }
-- 
2.47.2


