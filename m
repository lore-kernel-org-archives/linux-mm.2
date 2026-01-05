Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7383CD0402
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3DF6B008A; Mon,  5 Jan 2026 16:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382046B0096; Mon,  5 Jan 2026 16:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256616B0095; Mon,  5 Jan 2026 16:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 008546B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:19:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C53C8AEC3
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:19:01 +0000 (UTC)
X-FDA: 84299175282.29.EBD2E73
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD82140015
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:18:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KGKSwhu2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767647939; a=rsa-sha256;
	cv=none;
	b=RU29TgTBQCQ1UMs57OnoLeB80295Gv9b0Q9YMfZ9fxCnbk2y4BptE4KhT1dKcGYUdaoTz9
	5tj3SE2O6+pNE3E93TF5L70UM5camy/oKNG61cKB2UJpIotaTvz3n9sNp08k9h8lK3g5hL
	ehLz7eVdO1xCzyoi83zKAHvNCnlQcRc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KGKSwhu2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767647939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P7z9UoHroCTxVDF2qFY1VGhcuFpUDlTlobm9HJWwlN0=;
	b=2F0P79vcNt4aBr4GVGPjFxvRQ8Jhz5Huonbfz+PpabILFAdLI5ZJ2UzU1iC2SAxDSTKGzI
	VoPZx7osWalO9DPyE/BVse3C3Cv42EfaqwA8EIAHkNasajZysXLFCSvN1A22g6S1hUklff
	e57yKZ12ujDx2zDU0iYXMAp+9MX6XMg=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so378199b3a.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 13:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767647938; x=1768252738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P7z9UoHroCTxVDF2qFY1VGhcuFpUDlTlobm9HJWwlN0=;
        b=KGKSwhu2/tQcSNA8SJnZCpaIh0EavyQQepl8n+YrLVkdw2yZ7sWbBil5Uel8Pv2Hpm
         k6G3YSUw+5Cx6NEwueYK05qxqtMdJ8M33CRXxerkn8w4QfP4auBSBUXe7kumxJcDTcVa
         PnrC1JzgBm+QyD4jyztPp5NjO08IcTQxMKNFhJ+kpQQ32nKeGlPiGmCWI09HdThirGTd
         f4iCg/eAjLtiW00khCULBY81JVEwGnThLYSZxCqQmjre7NpQ4AY5XoG+Vktg5UMeZWdm
         Ttl2Y37mU0ywtEUh2oKc2RAqMgXGKcGgXFTRjOJoaOOtoqbEOK1JViso9mYqpz+MVPP9
         mDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647938; x=1768252738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7z9UoHroCTxVDF2qFY1VGhcuFpUDlTlobm9HJWwlN0=;
        b=hNPVwAd0KYD6rv+2xn0yR6wmroxU7g/3X6shidOOg/hWKIorguPrlogxDctGd23DrJ
         lviPEwW0jkWyE/44NaKVM5zwLr7/DlH/hqmpCfMBLAJHvf4kMio6ITJBlTefruwJNvBD
         nVnO/VGPqCftxbcfIc2m3C3QNuUDOSiAABuiSaNHslOFI1kAjcaCQbzSgPtXNGoW5B4Q
         VOHkY4Z+uqaTLQzBbV4S9/EOPARTEtmP0w/WhZDRxqKmWsRjxWmd/T60IaQ7+IiuxATV
         cHz0mPv01NZ8RhkewuVJ0D/HnTdZ9q7XyLjl2U53pNkb/AjJuujz1FGqqAPh5rCYXC2X
         /vEg==
X-Forwarded-Encrypted: i=1; AJvYcCWYsOcWqE1JP4E4bmGoQyQeLNyC7F5FJz8Szcc8B43YQ4waNlz5H3o++3tNhWb8HyOZaI08Tw/v7g==@kvack.org
X-Gm-Message-State: AOJu0YwE3DdtGIMNvTAnjm4G2IkGhhtWd1p+3q0gOajIXeC1k7U7ABRp
	xJipXB/nrx51INWW3dnyut79MMcwplZxnvHbYFYUJO9l1AW/tJcQNlQR
X-Gm-Gg: AY/fxX7bX5us476j3I1dxLqYHMIZsdFef5COsOTrmsOKgawVNmG5XV7BcuXxk4f0j/e
	XUgVkwb5NPtRCvpQwMlHcIKlmPFylQz94+JV3221NXRKph6E8n38+K/VLv6A818SHkhdrST/m+g
	Og7gG9Q25Rov47Sgtswi5IeqG/ZcHxMj6L9fX9wVtIx2WWXIPC5ELJqm2wHQcAHEqHIwvOxXGVN
	UNqHXxU6bah7Vt+mIQQQ/ve0bxAQ/jt+T6fhOIkgqaOrEX7xYjjHwD8AJqRoSWBp0cWvltWOGHK
	YJtfLuYOshfw4zrMPPDSNg40p7ILny+URKQZ9CeqB6pU64m6Xh31Evy2kacuN9uAVgkArPmA4ea
	Bag/f7XfUPd2IJYBaWbAbhUX0+tPc5DUtjtAhed0CYVj/6n887m2XJW7XcEgwAf+R1pTSfx9lPr
	f86Ic8/YCCtlTAfOcWiA==
X-Google-Smtp-Source: AGHT+IFlZ2+kUV5KG/60Xe5C7ejVmwoBKqyiJE5D5k+mdOkyc6xWlkvWTjlN7kZFePbx4PtnaXnIZg==
X-Received: by 2002:a05:6a00:340d:b0:7e8:450c:61d0 with SMTP id d2e1a72fcca58-81882ed4e7amr858139b3a.64.1767647938441;
        Mon, 05 Jan 2026 13:18:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819baa19236sm87839b3a.2.2026.01.05.13.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:18:58 -0800 (PST)
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
Subject: [PATCH v3 0/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
Date: Mon,  5 Jan 2026 13:17:26 -0800
Message-ID: <20260105211737.4105620-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD82140015
X-Stat-Signature: knn5rd87unj71j8bin3ufrcwshefcomx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767647939-289588
X-HE-Meta: U2FsdGVkX1+e8T/HQmZ3xO3QUkIcNehf4X+PcwFawgtj7bs1f9U6nOU2brJ6j5vppDuJ4zDN5LgrQpW1d6IjNKvU4dGOmJ3jsQUPoicK2Yl1s4x5m+p0Wy6bc8tTL+4QymL094pxkRqm7g5O5LL2VYwBV7KdvUYaqfzHjyvN8Y7B1niTqyIKv4YHS4L0/V9Bn+Z9liV63x37A2Ra2nqcVZIcrP/s6IgCv6E3JB9xJ9p40QJDRsLRoUqP/IMteVxD4X3zHZtoxv4uCsQ+PyOeJ7TLkkExwMQHwDhM1s7fJoXsPjVB+4H+r+v/YGBNqh5cy01AbAB1xCRMXqO7SetHyhTCZMZt8Mhe1TrQwPNEEIa6fCXLxFUwJbS9lpAYaxOiJpebP21ajxZPUf3OvU8G8AeBVKGSDjZu4CnQwbOSo8o3YCMAdC0rcqyg8pGRVpK9HFuPG0olR1CUavRiTFy6s9adKfZ5fJUpFfGSLH7eGSxXdZQu9nAAFyafTvW8u2fZYNlrTSi39B0qk8L54CMczP7S1owAgjfwPo5Mt5XvGkD8rMtZAtreUC9oHqc3eftsfuAIYEKK2hGBlolNVXieK3+M4DUIOwYlUiT95hIGSQYbV2XzeupfA83JkS19MCGNqwU/7KaRO+pflyqwg5k6BZi8FJrGQdZs3TaNejEh7DFKsSOfSUOQ3Msi0AbcoKDo60rcvtlCR3/9lHiSOHLzlGGSCFS0tN7ukZIQrKYNjZDGo/4fJwmsp9igtiGk1kjoamZj5jjMZhbcAsyaO8NgFPb1oWK+Ed55M9pTP2Yc2aKvnn8UwmH0S4LlztJ1JPY09FGLbXHa0eUsmVXriwhDkt9lYMlT3X0LBiI+aedsu2H0gkY7OLAkwzX510O0CjjMgTY9x+VvVpoqAPbrMp3MwNV0OKj1hD/99JCFocfwrepCrxn+C7w/IEKcycOFWfRGO7a+tBVpDKpInFT9S80
 nC75h4Gl
 SYnv7QRRK9zGthmqScqDn9X0rRO9+Evbv+mg9qsHfDq5KMD40v9ab0feZFs/yFBGW3OZK/W/ootFPfAMoVNhQgXT6kU2LEebpbUqnBQiPes2yonmj69uIdirPefMNbKwolnVVrlwboCVoau2dlMyboTttu3+k2FQklJhmcjvyt9IExhXYffUyeXIlmaR2M08g9jLiuIQcPLZsTbEOF5rQ+Q5hWLaRirS9FzhYywggyRG/T0xNIAOLa+UL+FXflXoSikjgD9CYSi42fAdJSStEPWCLB50dR+aBiG3sBtlwwNbwEFMuXsmT+bRDtgXSX1GEg0kFIYpDYqyoQI7OB/Lt+mliafb9CTCAEpsBzwaTEqVPhWVb6PliJkF/0oFv7+RfLQzWK/OVIiaXthgF6XX2EvohQws0uxkrKMPzjlZCYT04/d7ONfGh214NE2y3x5GxqfUy/lTewToOJu4uKls+HbDb5R30am033O3e1qnYdp/Y5ZCg7wd3op9VOnmo+sETqQP6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a new mapping flag AS_NO_DATA_INTEGRITY which signifies that a
mapping does not have data integrity guarantees, and skips waiting on writeout
for these mappings in wait_sb_inodes(), as these mappings cannot guarantee
that data is persistently stored. This patch sets this flag on fuse mappings.

This fixes the userspace regression reported by Athul and J. upstream in
[1][2] where if there is a bug in a fuse server that causes the server to
never complete writeback, it will make wait_sb_inodes() wait forever.

Thanks,
Joanne

[1] https://lore.kernel.org/regressions/CAJnrk1ZjQ8W8NzojsvJPRXiv9TuYPNdj8Ye7=Cgkj=iV_i8EaA@mail.gmail.com/T/#t
[2] https://lore.kernel.org/linux-fsdevel/aT7JRqhUvZvfUQlV@eldamar.lan/

Changelog:
v2: https://lore.kernel.org/linux-fsdevel/20251215030043.1431306-1-joannelkoong@gmail.com/
* Add comments to commit message (David) and to wait_sb_inodes() (Andrew)
* Add Bernd's Reviewed-by and J's Tested-by

v1: https://lore.kernel.org/linux-mm/20251120184211.2379439-1-joannelkoong@gmail.com/
* Change AS_WRITEBACK_MAY_HANG to AS_NO_DATA_INTEGRITY and keep
  AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM as is.

Joanne Koong (1):
  fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()

 fs/fs-writeback.c       |  7 ++++++-
 fs/fuse/file.c          |  4 +++-
 include/linux/pagemap.h | 11 +++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.47.3


