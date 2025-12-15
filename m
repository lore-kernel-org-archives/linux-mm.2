Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41944D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 03:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2C26B0006; Sun, 14 Dec 2025 22:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472D36B0007; Sun, 14 Dec 2025 22:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3885F6B0008; Sun, 14 Dec 2025 22:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 296246B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:05:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDAF3BE304
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:05:17 +0000 (UTC)
X-FDA: 84220214274.21.CAFBF86
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0AA4D14000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:05:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tl5Vpkf4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765767916; a=rsa-sha256;
	cv=none;
	b=GSCkWIqgRALedN7FA9E6ErYJ0ZBxoXpBnFpi6xdxCZCVXr8mFQRXINv6X5vdXfm4o1iWEW
	0W+2i49k72MKIUV6nt04HbIsln7882cYnd1m3nwGFNJNw4QFHPq8zo0/t6l3ZnN5haff7t
	zggnLPSzC7c2DRyrZvvI+KjlGVg67E4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tl5Vpkf4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765767916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zXXpU/9CotrtWEEiG98xKEab5CXEiDdNLNXM5TNCU28=;
	b=m3Y3EHK1tFs7pvBis7Zz6OwXa6M+lK8dSsvWXQycz0h21Zk6tcUcdK+qLKtqWF0Vr1z/ox
	QcqHZ4qZ77eg/Sdft9zpcCm8WaKGRTHQvufGFt9Rn0wK0oN0W9AkQSEmCLgkLvo7leenON
	HL/+K7/wUd7b71bRAJD65obj4QygZSU=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so2073223b3a.2
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765767915; x=1766372715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zXXpU/9CotrtWEEiG98xKEab5CXEiDdNLNXM5TNCU28=;
        b=Tl5Vpkf4pQSDeMGt/xwz4fskDN6EpebM3pxLErU93fKyc52QMnBK3QPUqVjndF3X0M
         GXp66JSN2RjTHLxyUuZfBTSIqr/PZkRp7RmR9lYUY7xBtdM88MK4gcPxzDwrQ43dGgdA
         2n78i1PcfX3Ks0EPm2R+Qt+ENzHwx4GvCyU3+3WLGKUizmHRkmBpcvVZLC9DWJ0DSAXo
         P9HEodAgi79NcwTEibZjibT19vv3Rl+/xa0HAtYHWLZbl1rAOd21u35GyquTic6iojQj
         U+V8b67KWC/M/aDL2hmMwnRvuyrB1Eu35plfjKofEAOUOiL/cZ3JYugqze4ZwWQ8mMAu
         FMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765767915; x=1766372715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXXpU/9CotrtWEEiG98xKEab5CXEiDdNLNXM5TNCU28=;
        b=U610pxVFDZpr1zHkLGKtoJxFI4SCSh9rSwxQ0PaEqpeL5S0aD4bmkQWQ8aaFd3apbS
         T9OV3/rf5SiWBx056QBBCCJK90M8zRSYPCinHCA5RLebcq651grR6XFmG5hiZ+sYMdM9
         d8jySxJpN0JBQd/CyiBZHPUJ0+G/EwF7Gf8osDxyawRnw3ITarKcOjc/1q8jjJc8+SGr
         26fOuD4C0qF9RTTKoTDU8+PD+dpKPoqlPopJaJPCn2BhNO32KOqE2yS2NwlMoLQIEJR+
         lcccCd2Xp0urNCZ1Uq4x7t7SO4JvTSJfX9BnP4vMSQC77wdAYLq3ZzcAqj8YFWhBYYtu
         6Otw==
X-Forwarded-Encrypted: i=1; AJvYcCWsTirX2jpGdNd5/uzejcW1gI4W0jK5Efpg6XSBSzifPdvoXOYg7NBbASV742aFOV+U+oviqUOQpg==@kvack.org
X-Gm-Message-State: AOJu0YxCSFNkfj4WcWlU6Hi+N24btEIvnDRIXiDrbp3WypaKohpjGAQf
	b7Dgpi1puAgUHSGMgaoFifjZt7p/ND54oyAEz4faPcRVsIfPpymIzEtj
X-Gm-Gg: AY/fxX592C61Jx44wvoHgEMUj489Nveot4gCs+5uoXvXa4Yfj3OgjLEaEccnXtsAubW
	oTjt6YGwFvW/kVcz/AdWAllYJQMlat4x4q1otOnTqEqQrENo5A9RwM1MtM6/la+JqBjD85meb3X
	LxoCY3GCr+F8K/za+Iz1sW9dM6unrXaVlb4xkL/XkiOXeBOGzAdrBjqFhufR53ouf2kUH/dcZhe
	Oko7gK1hD88jQ+FmiIXYuW9kkYoWxJuhuTYsr45h7COF4pAPkcl1vGeQ3KwUEaU8egfp+u30Dwa
	k+fI4EMWS4f1zxdMaOcEei0zb6EdYnIevXu4xestvD6YudU1/B+HSRfntDKC2JEUNb+JwvGY+av
	sQHnpm+und+CcwdBdpVAwD4Q4BE2o8Flec3VsEfKyvsHRBMi9nOgXvi6kwVoTAD74IH74NVnDDk
	Duwy29qaGvxAwoZim9bg==
X-Google-Smtp-Source: AGHT+IEhG+s7Qdn4IqoxJXommoVwYHiYpBqW2Ql1hw6PgOHtDqOeuQwZ9k+xUgSbT5iSjK3nvYGa2g==
X-Received: by 2002:a05:6a00:4502:b0:7b9:ef46:ec61 with SMTP id d2e1a72fcca58-7f667b26cffmr7887410b3a.26.1765767914706;
        Sun, 14 Dec 2025 19:05:14 -0800 (PST)
Received: from localhost ([2a03:2880:ff:58::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c27733edsm11076298b3a.20.2025.12.14.19.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 19:05:13 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	miklos@szeredi.hu,
	linux-mm@kvack.org,
	athul.krishna.kr@protonmail.com,
	j.neuschaefer@gmx.net,
	carnil@debian.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 0/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
Date: Sun, 14 Dec 2025 19:00:42 -0800
Message-ID: <20251215030043.1431306-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AA4D14000D
X-Rspamd-Server: rspam10
X-Stat-Signature: knmighytzxww5t4z7aqhx4jzeho7hfek
X-HE-Tag: 1765767915-542085
X-HE-Meta: U2FsdGVkX19Si4DJZxgvsJNv49Aaf1GH1fPUpEuJKkN+q+NYeYrKqj7iBqfBQf9rgkk2/rcgNhVLM/H35KUEvZERyRczARFwcNj+Y51e53iB2xSOIU5vId05xdkMihhhnj2XfkOv4UXxSozBQjf8OH5xjG+yUHDasY/5/usHvEJQtGqCFSSLvNdO+wiPzzZ6byvTlLgQhBOPGZk4BFjAopkE8aLKA+BdjC1ycfPEWoJuZCWrZUFepBeIoPjEs7oSE0/XT/q8MsbPabTDP7hJoWKBAG/my/M8N7d1oEw81Z6oMiM9+mQG5x/tl0PHyI/TyZPVQ7vw32vZnQkL+I3rApC+vfWpArkBy9NtkhlIV2PwQzxncrwvnkFr13kOFmUYVp09AAjPCIfcj2Qil8wjYjtCykD2TmQtl++Iw9AtMlcAHkhO3I4GTTvmhF8iuQlsC1n9F2tTT6vouyiFvAFjanUi9DHLGmevvLO3wm9UjaepW8BHoGZCNDQa4hc04XVaSUq6Y679UwQ2cRYdRdQSSoqtMJP2HgVwX4+5Xk6piHMo1qo5UROFIAZGmTcXx7V+XYiz8BrPMMvcxKcSU5B7fdFI8DAfVnPOIMoQT5zCE32F/Z7b5fCYEAUZm0DK1dz9982+Ru6T4IIbrno6G+hEYXSOs2Q2UdEIQVZzVR4bOw9w/1nY8p7sgbgSX7upCuGEk8mVwp96DKE49z6/YEL3nEn0azGzisSS6DF+wKnS3X+Sk2/JwmbD/nKlXY7nDfE+ipMLwOzN4yF0mSEeTBfVgdl/RKv24f07u2Ezq2MCcEPv/VJcC8pMO+dixcxdwuqv+7qphyXk3MkMbDDLx5qb8yy0sJAfMQ/0Na96JrRm3KIlnEd1t5S00OwurI6MRW5NajJhOCe67IslpbqXKXYhGH03NE0FUZjkHN+NNaRRN3opFqJfE3wVp9q8p0uUZvqhGfldffFZkXZUum0215E
 Z9XqYQ0+
 dQm6n4HBD6KvIJ0CLtrF6FRcO+vTsPxXXTB5o6OWwycIPlbtXFVK1UpOWJMHmPvPwAGx84wg08cez7IopfXXHMyaa27pjMldohp4esRfVQGhxsS+lqaVj8LDEBoQ6g9lthz6rVV1uvvQZ4kECYhHlaGwVingASkXYUF1/CKqhQjWNEJJepUEv1ul7Guk3gnRIyDu/fJVlg3m5smalwCfzBsalq6nxlaFJkPRwx1pnkphuDtlAudOLlaX8DvdLYFmTs0qJ5jCbdXY03bNDw9cmgi/89kzurcN54OIb7Zg0tEWjGlqtM6oD2hQ1X7Gcpf0zP4G4/t+EowcJONZti9182X8h4QgmQBqYDSwn7dUnkUa18+EA2OWtuK8zSRwGXYUpQfnN1l7/wRdwM/sbeDiZLa7qto830Q55ChNJCgis9BpZeLZNsr86ZnB/hldUwB74c3FCEpyZoN8KdaDKNiUEWovtNHR5FO/wv2A0KzHBbsYyCK1CJ34SukJa44N7lwAC8//Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch reverts fuse back to its original behavior of sync being a no-op.

This fixes the userspace regression reported by Athul and J. upstream in
[1][2] where if there is a bug in a fuse server that causes the server to
never complete writeback, it will make wait_sb_inodes() wait forever.

Thanks,
Joanne

[1] https://lore.kernel.org/regressions/CAJnrk1ZjQ8W8NzojsvJPRXiv9TuYPNdj8Ye7=Cgkj=iV_i8EaA@mail.gmail.com/T/#t
[2] https://lore.kernel.org/linux-fsdevel/aT7JRqhUvZvfUQlV@eldamar.lan/

Changelog:
v1: https://lore.kernel.org/linux-mm/20251120184211.2379439-1-joannelkoong@gmail.com/
* Change AS_WRITEBACK_MAY_HANG to AS_NO_DATA_INTEGRITY and keep
  AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM as is.

Joanne Koong (1):
  fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()

 fs/fs-writeback.c       |  3 ++-
 fs/fuse/file.c          |  4 +++-
 include/linux/pagemap.h | 11 +++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.47.3


