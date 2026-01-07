Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C14ECF6C13
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0DE6B0092; Wed,  7 Jan 2026 04:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E4C6B0093; Wed,  7 Jan 2026 04:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D886B0095; Wed,  7 Jan 2026 04:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5892E6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:04:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0759B1601F9
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:04:55 +0000 (UTC)
X-FDA: 84304582950.08.2B2FADA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id A215D140016
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:04:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MZPnVqBG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767776692; a=rsa-sha256;
	cv=none;
	b=y2H0GJMGAX8YE4oEvrLaketvwGAXPIeWZQQ7wruIcxRsLGVff0tZNDsWsG8jyZCsytC8TV
	yIytIUWppQC12VKAIxszJim1a+fFURkm4lObxK204xMLbRjadCtbkKE5jitbpyHGkURjLR
	q4BXoINT7iTOnL/T6/z2KMdTb9l4lwo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MZPnVqBG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767776692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w7aIEirXSlFElRo5Y92xYAouNeJKNZztucm0IeXzII0=;
	b=kMn0Q3OpxCkJsmYNNjKkR3IgPNtr60xki1ak/pGTLBJWfHZYViMFW2uWt++mOkTbhiFUe2
	TmWlM40FXvNOcBajFg3BPbrPhGOHRi+dcO/ki29IOVkZS8FND4ZEfp2omsI1kZP2ro6NHQ
	oljrRggxlEhz0hc0vSofPRLHQ/jyOZw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767776691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w7aIEirXSlFElRo5Y92xYAouNeJKNZztucm0IeXzII0=;
	b=MZPnVqBGax8fQ++IRDxCcqcViDaPhm1Xf/zSksbLfkw0rW83fvtLDXMoTwEwx0c579NgdR
	vumc64apvexZ6n8UfARaYDfDSeZRRZfTwbS3mGY0jxlhh43OZPPaz8CO84Dmw/RkPCvyHy
	4rBuymrUzj+ZjEGkJQKcXTW5yFLQQCY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-WSEco0wXNaiO9QUU_U9nkg-1; Wed, 07 Jan 2026 04:04:50 -0500
X-MC-Unique: WSEco0wXNaiO9QUU_U9nkg-1
X-Mimecast-MFC-AGG-ID: WSEco0wXNaiO9QUU_U9nkg_1767776689
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47a83800743so2778195e9.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 01:04:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767776689; x=1768381489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w7aIEirXSlFElRo5Y92xYAouNeJKNZztucm0IeXzII0=;
        b=ilqiofg2gp8xp+Enc5p3fRT4W1reXKvIWt0sE8ipty1koQVLMuOULPDGVyNX7fXAX8
         JtGof4xSkMIi8l+74Q8H8yRapCpj5+Bs/i6JE77nYtoeWpJJHkK0BZ/pNOjP/ydOZEP2
         d0kFWRsxS/cvL3ANj8Ejv+WE2DJyMbaEGndBg6sC1lR4wJ3ub/ZMPZtO8uVgF1BYw/Vr
         SLJtpy+bzaT01EE0lLGHsQeMNpE/OXDwucM1siz+GCKQqtBkV31kj6Nso2v+HzgDn5Yd
         gRoJhexd6QmmFALwnicxwIL5D5NqM9oDGW+hmMUd1K9J/WXuKyvaFImi3vZJ6HEPHDHM
         rwyg==
X-Forwarded-Encrypted: i=1; AJvYcCVHGjOVothWocOQL22VJ+1s0N4w5CmLl0d+ti7q8/9524LS9C6leH1n52nw1vsj2zp0zCr0gTI3eA==@kvack.org
X-Gm-Message-State: AOJu0YxzgmJEnEjZrZo6rFAtAL7KkEzlw5Sm72hsGoyyi8RkLdGRv0+P
	1K5kz953UrqnOvp4qklMgdqzSKCMXKmgsP2hkMpPi7zVm0XtugSvnghfyL+NO4HuaGqDuHx9vFz
	OaCaOr6ZoIhCZ8sxGbbHyaGARI5js63vgOao5h8+GDT6yhG/HhwKR
X-Gm-Gg: AY/fxX7dkm5qkH3+TCIQMmSKB1hwEKxLp7tKbuN98BaFwdzAptlkSKV55B7rdwlM2qI
	dRT1uMFYzsLIfJG4BXpTYdFvBeaEgO8GnMwluxAor0OFOGLrqejfZtnqsWAnqxYWYev3vTzg2ty
	dcXHnHBMDzd5a1DQfPcGnW+HtVEHbgSJBSWoI4wXvVwXYBaHGwsC5WyvdTm1JORK0YMGqjbkY0W
	u0G6Yda6aDItHOrhN3PUtXF1Jya6pPrhyZUPDLvFRWsbElc+akp6Z2lYHVivUi/pOS7MRj+9mj4
	ib2W5LBquYBg24+FOnXYZkb5FNHkhx30o9r+tJ6OF6IAVzW5+dugR4hjHLI1rBpNO355Nmu7hpv
	bRRi+Euqkk1dE8ab4g0oHFFGzxmQw3/RB61b6zLRCn6CuebCBrs8j0xSGBE0=
X-Received: by 2002:a05:600c:4685:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-47d848787d4mr19066385e9.16.1767776689294;
        Wed, 07 Jan 2026 01:04:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBxZvbctLk8Kb75sAgCNKupX5//pUrqHmf5E4ojGAgMRxBeSVD8oZNwP8f79+dr08mpm67VA==
X-Received: by 2002:a05:600c:4685:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-47d848787d4mr19066075e9.16.1767776688814;
        Wed, 07 Jan 2026 01:04:48 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:1622:5a48:afdc:799f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f69dsm88569055e9.1.2026.01.07.01.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 01:04:48 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Mike Rapoport <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] MAINTAINERS: adjust file entry in MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
Date: Wed,  7 Jan 2026 10:04:38 +0100
Message-ID: <20260107090438.22901-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mshdit-gGtCJJy31VTsjbx762bWiF7AtJJ0yaDvUjrI_1767776689
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: A215D140016
X-Rspamd-Server: rspam03
X-Stat-Signature: gcjdu4tb171w115yguakc5pw85c1ynup
X-Rspam-User: 
X-HE-Tag: 1767776692-995831
X-HE-Meta: U2FsdGVkX180MgU+DMkbWvZR48Eypw0zgRtbAlbmm87mCrsvJkDPNdIwCOCMXfFkBoijXCmT/eOPpppKfghsK5Kd/zh7gxTj0Wkyn15179xDG4rsM/4zqGbs8ltH65DpE1MmeEmKvxVg781BC9Gt8XxIXN5P8oZiAi34VRiyTZcAvPFYZPVVdV7ahky/QgBJ54XVmOlpVxXKk0B+/JB/vwOPpWRGxDg7BdXSg08xohWLMMQhB5u1SDJBy7jcZ/Hp+kPZD18bkAIJIBustrvrDyG7klFoV7SJEQa/O8vR+eJDxDNqmzP6kH8w5x3rrcPJQ3nI3B5iXFPFylT7J3bmXOw3rmFeiRT7yq9Mj/Zx7fUPtdg4Q8kMGyvBVUqylKUiTpXbCK5/VUFfqKW2UkMeCEUtmyBNPcU5F7OCocjLgKvshy3smTMkTZE8Dn7I5/SgqIPemWSkFNeu0ESBrneRoyGAgsZa3TFQUm9O4cCSgL/0485Z7Ba4I9mBTXfQ11Ky3bQNLnKIW7V5YdA1Flrd08YGzRw8pHent6G4DCQ/g/1s5w5w5EfrYKtFpbrNvkz2xhFQtzEv88CrK+bTH1P5NAzafC4tK9JtmGjjhEOITTuKLooXMBHFHdkyqkWpMkA/0Ufie9eE5jKVPiqp3zphXnFRXcaH7n1wVy8SMRAiFqMj5Fr4pIKWoh2dIl02sETj1a6luZ+8FjgQhZdX7+sUPlp8SlDw5Ct7KLwacgWILySWs2J7UJ7RAkHF0/dq8SYv51hvqakdZw9GyhLDZ42mU199d2RNGpGgikM14OP5TA7HtEc8fHSlwieB5AG1iY4dro+Of9uP/dOEhoIH3qVqwS9NXmSb3usAtABJOnRltSGjCkfhP6dPLdlKCacGtJ2wgoEPNBkBU90RSnuwfwoSj1yD1KX0Roio3lYO8aZLIPJ2KDYYt5ecOY0mzuwESPETYDn2bMFbnHdbhx+hevP
 +Yeh1bQO
 NyGGQHkiBN/lNN9HgsYBoozGyZ/mYC7J06Ay5EZvppVH7VQ30JaRj04v6JcnK4SufvD5o8YqB1rBpMN28frl6wM/d2lCIzmoiEUXYduQLZZcPyzKCtaAYjptj9F0mBXfQTW1voDbqlYBXvcMpu2t+G4uAgXHsIuOY0J92s4afklitwgnAEKSIDIZpnqQCxvYMKrpY5TShpsG/FjPonC0AmlpnGiKhKEynnRyDtWMeAxlIhWnwA5vDygzrjIm+8bbbXdSAoCNlFugE86Fh51I9OlWQqbs15+1jyWYmbtQYHsBJrgjaycqdqCA8F512bEon8qFJqvkCiqy5b5xavk2ucNOGWm6Ki/mrdFKRKXVK6t4i2GWXPgT288OrGrdLRwkE8ytzkR4TZWReufkO279ZDb5RnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit e8d87911a204 ("kho/abi: add memblock ABI header") removes the files
in Documentation/core-api/kho/bindings/memblock/ and adds the corresponding
content in include/linux/kho/abi/memblock.h, but misses to adjust the file
entry in the MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION section of the
MAINTAINERS file.

Adjust the file entry in accordance with the changes of the commit above.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b28650893f2b..1ec85c68dd4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16454,7 +16454,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
-F:	Documentation/core-api/kho/bindings/memblock/*
+F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
 F:	mm/bootmem_info.c
 F:	mm/memblock.c
-- 
2.52.0


