Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C16DC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCAF6B008A; Thu, 10 Sep 2026 13:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D596B008C; Thu, 10 Sep 2026 13:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7939D6B0092; Thu, 10 Sep 2026 13:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5752B6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:37:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF849A5260
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:37:05 +0000 (UTC)
X-FDA: 85198558410.24.599EA63
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EC4A40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:37:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fYniFliX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3vuqiaggKCHsrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3vuqiaggKCHsrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789061824;
	b=ALusD4k1yfD9TErDHyK8WCS5Oi1Jdrt2Rl9ehSxYFuugSerKB6roLyx2k1tbOVhO9igLKi
	F6GxcO9nhHsNWXcSEkpaPdnPOsMatrBX5ixpsfJIEdi8ovRF06qxZHkW45F4Bo7CswaYGp
	qK/a8dNLoniGdE1+9mGNvmFE/2mXE4M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fYniFliX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3vuqiaggKCHsrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3vuqiaggKCHsrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789061824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ixa+0zFsulp4+PuCSm+LSQ3ZbsxbILCT0CSEEhgLf5Q=;
	b=5+DXOHilmQ8V/Q0iq/Hxq0c7g3qqMBZZKY8KlppQoyJ6zqmax1PqOVMXloXATZk7XFEn8b
	iRVGas3iUS0O+40AjzEuoFTIB0fs4PH7WWGkHFCEN059b49ZNXGhb1tBUZ/WsYDXcGTo+Q
	vHcRSEVc3kN8bT9frcaKyKNAQvp+Yt4=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ce7dff6253so14379605ad.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789061823; x=1789666623; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ixa+0zFsulp4+PuCSm+LSQ3ZbsxbILCT0CSEEhgLf5Q=;
        b=fYniFliXfWgC/X3P0p2zr7i4D0pTaj60yHIPWNRN7iQ7FjQfWOLuVL0+nJREGRgGey
         /nR8j3uTeEJ+j5/+RGmrXFp8Ylh49G3FZ7HbzQiSkXRqMtx31/x1XQqqnPduvhP8XwDi
         mU5Bvj1HURTzGrys22yoKF0jF43eH8ejwYqGJxPwXsO6n4i2vpsihrq6N82RdEJpeKDU
         tCstHy2WCBxHcOAmQh5W7T18i9jIQnlzMjp2g/kq1AIUiN2NfvemfkEtQ4HsbiYs+8db
         XHabGP+i+nkaLJGRkkcZFbUi6ZiFQhlAqBl2FbxGWnoDZiOCSkmGMrJytbpEhhNj6eB9
         x5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789061823; x=1789666623;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ixa+0zFsulp4+PuCSm+LSQ3ZbsxbILCT0CSEEhgLf5Q=;
        b=Jbcahgh6zS2Sa54KAZRS7pInAbhLNr3wKISvBVk7oXF29BBpfOmsIE/WP324eefZ6f
         sZ8wa0HhcCbdRQr7doo4jGKJjl8YUsSIM0IhNndrMnqxgrXkBPkoA9OaZ+LSNZumRLWu
         UfqCbHd+6jHnMvA7+wEUFnCF6pZwdVZwHaJ+UfQQxAfXm1iEHi9nbZ24q9WvRO6JRseN
         4i5npQo+eHdVEJdEkATNV8KUfSTFTLjGouK+tjkE0oGAZ8x5zVEL6BW/qqEhZRjiDYR6
         nhyu/3F2lJjAOcMSS/0cKtTsySplbca9lMo5PHZHzGduWzGvWhS4c/fS14UxKDXhqREu
         vx7Q==
X-Forwarded-Encrypted: i=1; AKwUvBwVcfRu+FHv94oVPZzo5v5tVJtMgpUsez8JLELLnP6fEcsl100bFvP9ksW/zJn/BJDzvD8VKoZg3A==@kvack.org
X-Gm-Message-State: AFuF++ki859F+lK3c/XdXA1ZJfbpPSPk2ReezaJoO7NrBcuAi3r5C2xm
	LF6v1kcqtvUJP/q2U0Tv0NOUgsmvbdrxcrwJ2wG3JPFX/DNqcGtIY1yWzM8izMG9pOCOYg4ilbI
	FVb1TUj4kWbnvpA==
X-Received: from pltt1.prod.google.com ([2002:a17:902:d141:b0:2db:1aef:28b4])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:38cc:b0:2db:3734:cfa4 with SMTP id d9443c01a7336-2dd0e8a0ef6mr59319305ad.5.1789061822647;
 Thu, 10 Sep 2026 10:37:02 -0700 (PDT)
Date: Thu, 10 Sep 2026 17:36:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260910173659.1945246-1-skhawaja@google.com>
Subject: [PATCH v2 0/1] liveupdate: Add documentation for file dependencies
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EC4A40007
X-Stat-Signature: 1dgdnz111kc8qctjhdwm7em9jwasaaq4
X-HE-Tag: 1789061824-12155
X-HE-Meta: U2FsdGVkX1/S8Z9ixnPbcWU6Ur82HSp8Ld/xbC9Ja08BsH1NRwTCSm92V270rVyJ6b61+P06NNJjQc50VGH+UTi+IiTgdGAzkX8mxhgdaDLfXLMOPA3vr/JH+dNhWlDzKWD5Uq2/nbJnC/DTZ/tfb4pKr67Y8yGoy1LU5gb2B8xR+vRueR/zjz/aKGVq7ezqqN0p5u09BFJwUWS5Wt4XYsk5Zw5QyDK5/C20fJaR/LmEBrJAAu21LNZmdyFRBF1JEVVkPPUpKFQfCTEmeS0Dj81MBj95rBdP/TM7fLFKNwiUZjyxtvDBlvnPCHPFIGr3VRXgfnxS+eMs5AOVF6gwrkeIS8VA6gryScBf4iBAWg4PUZpxGmx3uLrM+NsPX4Fu23qQPH30Ere7+na6ooEV8VTC1h4T4lT9oTA7rksy63Q8ypN/dEBG7JQ6+6Z31f7CtYlUc10K87XcMytp2/mUGxBBA13n8FKmxe3JkwPjMZ+H/vJ5WvDZ/TvBLRLI5VCpGOSA7cPuH3xd+ywyirqu2oA912VduPqAta8KITZfQjC/esyqX13h3M5c1+yVj+Va9Abzqo6ixmWWLl/agG1FHRH/C19fVPPQdCL7zQ/9QJsCMbCJogrLuQiOJ95DyIcx48P4XVusAqU0w9J09y2yOcXlLvW2JT68TRGsCEWWx9IHzRC+N7KyLRdFBvKS1f3Ejr8+lDTpXIw2h4ob/g03BToOqvqxj9+Vz8uhKVNTHqZqXxqWA9RokXdqqSGePCHwNLAWHwEHfPk1zm2r1XyObiKE5kVDzee+s2L/wiTKC3SDU9halHclrG7uGEMJIZwCD+4xO3BUhTRU+wbSJl+Zw74G6teRVsOSjl1H+kpdOieQBJVc+8Y09UYofEatpRqe9WoYOjAqEhC3uZUulx0ScQx7lSaQoF+CdlVGImqfwdCSImK2Gq//gF2peU9axEA/xLH0tr8VUaclQQnQ+z5
 k2LMoXJN
 39FyL8/dPFF9HSbiki/+GntoPkYrCRR9tmZLppoEHVXxwkYp7UxmOGzRTC7T2TQ94Btxigok8sbMI4kD7uZWe39aovky/d32R3K6V/+OfoZdx6X785aEsJ4GVR7tSbgyg6DIYRjHKvTnq2Sfe7gLgwgNhI0NNV1m/bDpR2VjqmUnX0jCibR1Cey2Jja76WTMmUYt/GXKoL2D1hOMK5G8cRND3qj6CYzhHU0PUAhNnixTB2W76KDMBuj9tdZXRbFoQ0+YvagLfVN9fAZXkT6G24ihEDgefMMVJVHA5+xuVyhQhXK8uF0GODWql3pj98lIcVxSeg9qeIQJzQA7lYLfInczcKrjbOf0ZFzIWQknSr5pHhCS2fesx9Fnup/Yc8ZekA9JQMfBYgdC2PxrJpmeioB4c4Zb39atR9EKXvJh91S9UeCGnRNBaOIdg6LKBsx+0x4oB0oSD4l4WfIbEzjRlvHdOnOAt3BYJg3yUAzfdDMGmbUX0UyTWoLSnsqLjtnAaOWCrkHTdqzIX916LT7mczPW7v8QyLrjsDnLgVDO+gsGKNSpjgcdT/uDa2htaiCWgG2kxn9JtiTl7kX5s3MNuia7QNb62FaBHalUmG0mJcGDknDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I sent out v3 of liveupdate_get_file_incoming() and
liveupdate_get_token_outgoing() series to add documentation for
dependencies.

https://lore.kernel.org/all/20260820191854.1642931-1-skhawaja@google.com/

But since v2 of that series is already merged into kho/next, I am
sending the documentation as a separate patch.

Changelog:

v2:
 - Rebased on liveupdate next branch.
 - Fixed documentation.

Samiullah Khawaja (1):
  liveupdate: luo_file: Add documentation for dependencies

 kernel/liveupdate/luo_file.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)


base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd
-- 
2.55.0.1032.g73a4cd73de-goog


