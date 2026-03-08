Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEBBF55102
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 09:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128776B0005; Sun,  8 Mar 2026 05:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6236B0089; Sun,  8 Mar 2026 05:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC906B008A; Sun,  8 Mar 2026 05:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCAEB6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 05:57:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DFF61602FF
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 09:57:41 +0000 (UTC)
X-FDA: 84522443922.13.DB49087
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77893C0003
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 09:57:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="jrsp/u8B";
	spf=pass (imf28.hostedemail.com: domain of r@hev.cc designates 209.85.128.181 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772963859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXCC9wd6WJbv4Rkek0lOfebWInM67Hmdt26u86+GnkA=;
	b=qR9r+o21Ff78AHpQvKuc9mr0ksykwJmEHxgxxk1c4BE60+94dxB+wYjCNzKqOnTfOh2aEZ
	Uy3NYMa6e/tkObCA5O9nN/yyNBo9MQW8hcDF+chzG0qfUZ9La6Xu69/0NQ47rEUeMH89OK
	sMg7uHrN4GuKMd8l3xeoQ6eRTOJprfU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="jrsp/u8B";
	spf=pass (imf28.hostedemail.com: domain of r@hev.cc designates 209.85.128.181 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772963859; a=rsa-sha256;
	cv=pass;
	b=dwX5cUgBOffLKAP5FYUqzFOuGzczTqY/a9g5gmcioBMcgq2GAW1kveErF8NckLB0gl+Ell
	njnKYOGHFhPJlc7BWQkvg3mB5EqdzkKZ2vTjy4MgXBWbe9BUrswmhqZLAmi4zEUiaorCgj
	3TTf/IyUcMFRRghrR4BnWHvv++aDMxg=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78fc4425b6bso105938477b3.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 01:57:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772963858; cv=none;
        d=google.com; s=arc-20240605;
        b=KcYjUHjrseD9s7V726YIOIZbKmsQrOQaTWWG3oDW8KsaNvbi9vT5u1vxJGeJhO3OuX
         YwEgR8p/rksX9C8BpOIAYfyw9CL+mgmxNrj77kVJOdNBWBeaEBPFciucDf15C7YCIQxI
         SdUzK4Blx3b3QuZRNXlNFBjOYBA9m/SsoyQR7TsvnbXg/BKkXYbGtPOaf7BYMgv2IRxt
         KGolBQhdJE/FE05ltrnQHItKYD8jVvTAuGPdsfftmzV4Ob83GZ/KD7qd7z/IWz0iHBm3
         Pizxvpa+DFbD4UBlYHGbgDcED4B11E6eS051g0iLwDb/W3n69f5OzjPSuNMuiUczhEI0
         2siA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vXCC9wd6WJbv4Rkek0lOfebWInM67Hmdt26u86+GnkA=;
        fh=JR0imFxB+ZE39IiwPT8vxD6HIp2JHEZIMoUVW9ONdOI=;
        b=EkQSpMnJ3tEHM2S1UmMIEGCsV542K8itKa25EfrNj8LOYoCCPzwLX8GUCb1A/fTr5k
         hb8vSMcZVdWTF3Os6hvSAaxMBKSjAHR8R7bA/VgYZDCsr2VVBlPDwdVXhGOQeBNAyk/Y
         3maqGZa8Mn8FZgItFoE1vzs8W8zSKe1gcIWY/pmtMybYeiEs8C4YsoykjxsVus8DxNKU
         9q6ihS6fW3gbUkFJ7JntgfhtcfOxbfwUSMN/OaMR/C9Q4U2xeOccaH9FmG6Wpedp/LXY
         kOKn/JSGloDHq/iVgmb93BRGsKqDCEbZ0TzB2cn0XPJ3MAOItAd6v6m1C9Q1LkKfoKXu
         Z17Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1772963858; x=1773568658; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vXCC9wd6WJbv4Rkek0lOfebWInM67Hmdt26u86+GnkA=;
        b=jrsp/u8BsbzLaGINXlHRXzXXxwhfxBVPVaq2V8yIo70w6xzS9Pjac0xNnkgkojjS1o
         1w/9nAPkcoBG+CUtAX5VUUEDNLonI0/YtMw3GSLxNZdQ9v8YPx2ZHxzoSO4QQUjFHGeb
         Hmo3dgVJAnY4P0SKX2MjkmH0K1lm9C790YpNXwZB6G02ZCO1peE3WjipQptzSmY7FQ4Y
         Z+B+Nw6dD2+29+VQEqcOlu/3OJadKCCqcDSzi275zio16lgHurbT5kyOdV8F7sB2oaQ6
         EQ5Ut9UxExjVY06Db2UOrse7jGRY6WHUo5uVTO5lyHsHFRK4uDW1r1BaUSF61AxmwIg6
         fuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772963858; x=1773568658;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXCC9wd6WJbv4Rkek0lOfebWInM67Hmdt26u86+GnkA=;
        b=VnQGN17InQPABJJgi5611nKSHhoI1SyGf0MsXTQr+TpQBkgfbHjeAbLwIFfS/uNpec
         N4/gteDV9xUxQuPyKz9H6nrKenfvtkwdp/BhY/hAp+Z8PTL5mUE0nylzBOC8FyJyHDxK
         cEW1znFhtgdLTDNC9d6Nq3NLFJTG+VheuxzFILcr2lvoYrCLJS4rV+gFsJ/VJ9UmqheA
         j0uB2Z2HYaVaJCU2c/KJpo5CDr+2Sbo0IBZwxWkkOAPspiTcEfWaC4NBNYnjVnNmAY/w
         JnZEc+IMx0HMcNkFdItpIIuy54095QA6nwznOseDXGoSKcLIX6RQeeGTJ2lM9/MMi1TU
         f1ew==
X-Forwarded-Encrypted: i=1; AJvYcCV1akyZANfPzanPDVbN7jTRnEWFJ5XJo84+GjQ1lafiw0W/x2OWOViFVeuNtZv1+PS9ngU4877UNg==@kvack.org
X-Gm-Message-State: AOJu0Yz+cRPgyUpRJvuq1Xs8Yc/g9JrKkAuHXnT3PqIJCUiJbA/3F/0X
	HNWyvYBTCACPk3YYQdnLLFjHFdJsGDOMcjDY0vbXBrBHyYT/q7cQv77yA1dRQKkRyn6pKLxirwN
	HL/fiyoxm2COZsN+EuiW/0S53seR4v8BnymbesRoegA==
X-Gm-Gg: ATEYQzynkVmDqGzcGr6vMD9DZ6A9B2cFt2A+0fjok3ENobYM7Ga2XRBCjaQG0DbcYs0
	Efm2S3YKTHigzgOuVsbkaWoWtP5r8tv4fIZmhkfd0m0wBCdrkRIKRDIcMC0iJKolDQ/oaYnjk7o
	eNPN/npaWlw7aI5P6ITXhZB0eIqeHlOZ657aWE3wCY+p1oqHUei/0chYg87bU2/YElgZPlCHEb4
	yE56IIoRy4ja7May6Jo7/xRmUJM7anYG7HeS+NNAPoYic0TV5zGZxSShEbgvoncenYF0DoPJ/Uk
	FGs3TvaK0l4yC5W1wLJU6E0LVv8+nGtfhQoRRRnHYw==
X-Received: by 2002:a05:690c:4b87:b0:798:6ee0:2a68 with SMTP id
 00721157ae682-798dd79a7f8mr70252727b3.64.1772963858401; Sun, 08 Mar 2026
 01:57:38 -0800 (PST)
MIME-Version: 1.0
References: <20260304114727.384416-1-r@hev.cc>
In-Reply-To: <20260304114727.384416-1-r@hev.cc>
From: hev <r@hev.cc>
Date: Sun, 8 Mar 2026 17:57:27 +0800
X-Gm-Features: AaiRm52SpIZfNiOfmNNlgLYK3x_bGxvzWJa5vwCMHz9YODE09mjAuuMinHe2KyA
Message-ID: <CAHirt9hA=yw1NDS5zz0qkLEtczu1STZFBeq+soEF0GYhN8HTBw@mail.gmail.com>
Subject: Re: [PATCH v2] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xqzad3yqscb1ws7ij98uf9m45xd5fg85
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 77893C0003
X-HE-Tag: 1772963859-690866
X-HE-Meta: U2FsdGVkX1+5WWqNbVxd2m4meJvNprUEDeOlAa4u6kbBR6F6ix0je5wO8daWQDyQwl4znNZgfkUmWN6xKaLLn3cJxXmyNnzFaK5sGSg5PSLIqe0UiF8kl1HTEacu9w03JGEDvdl6hoPSGqaZG7yM4uAItP6A3dUck3FVW5ddFcJkg96vNbMoXmlpw8EbIYTG+5posY0P2CVR53tgJttvgpl2hoXxbZcVBU7VA7CDji8IkhuUbxv2XJA4zaAJxFl9g1Qd+Syc+ClO3nkGYB4Js7kWTOQJAs030cUfa3p0pbWUW6pNkLzHV129UvxFnunxHEL3oYOyrrFNu3vO0+CTBr8taQf5T7fUBP6I89OLgYQhayDBo2MS0Q+YG//hT0Q+WLbqJCPHt7/E619soYbX8xZJsO58Ypt422Uxc2ttR5kxFZ+pSJ3qhVUdvrSnRuCxpFZT3cYdrJqdYrNiPoHJKb0QQeu+vVtU4pxNZHuZEkDzGRadSn0EbLkpRnrMZwyvalHxsPrBqGOcdXi3AUYfH0wHS+HIZQDes0u9UoRyk3B+yFqTypoYbaPrQwrEHM84HvGz0JsXYVAa157uLDAxk3ARrXHFKKffqQlMXAZJWrFV/1g8DLY6e64oBEnfpi3V3dJB/cOiFIIhSNWbKdbt0PnES1y0jQm/GtepZITv6CPgVitz0/Fu4mEVpgUBWJ+UsTN/IhnHqvn9H9IKfZ3EwS7L6NLH6G3WNiNsduMFt3xu8z1I3dzLv1C6YsHSfRwLuuZ2FLaAwwR356t+ST78pF7P93nV54/t8U1N64PDd4zKv898n7pXcM2VZ28yYqqHQu09bAeuKYCy+nOCCpQd9v4CAOyTpSFicxrkuk6q+56u8EjheDsOfKr6VguheU26+n0zAxpBNzpG7bNq9SMLYoORaXRuYhQ8y5ndoz4dcf1kUeg1VTJNtm6izmBncK1u+7qJ3cUw45QumCNWHwc
 LdC2xkgj
 su+zSNumrEwpOBEjv8/zU59RUiftkQEO8HusaMeNcTUKlgiyhO/jT0E/tyIbR+iSOU700pBE7wCzPP85b4coygewAFnK3f6wHShtxvlg9P38OjI+JXS6om3ui2W6JHK3iD1I2oJrQ4gKo2aULxm/TRcxK5YUr3fClqh9MjSDQK2ofP3m7NWJ/4ebpbXmj8shQStZD8xeiGLbQOa4GQwNAmzQzTJE90L67mHQ2A8w1gb0MLyEjIq0qRIVIO0lDVaKYR/oOi5CBiS8u/zyX5tOgCfABzY6LiV/S5evndoKzW/63K1mWTfabFytQFjKbRrpxCBlahNjR0H2uOsLaH2ws6x4jG2rWQX/JgR3KmVuySuobBsNP790ix9zNJyz500xlOySO0geJ8stWcbMuHFyleuQ/WRczW4IY26q0dq7Mz9j5K+TKlDdCTQ5f6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I ran a quick benchmark on x86_64 as well.

Machine: AMD Ryzen 9 7950X
Binutils: 2.46
GCC: 15.2.1 (built with -z,noseparate-code + --enable-host-pie)

Workload: building Linux v7.0-rc1 with x86_64_defconfig.

Without patch:

 * instructions:     8,246,133,611,932
 * cpu-cycles:       8,001,028,142,928
 * itlb-misses:      3,672,158,331
 * time elapsed:     64.66 s

With patch:

 * instructions:     8,246,025,137,750
 * cpu-cycles:       7,565,925,107,502
 * itlb-misses:      26,821,242
 * time elapsed:     61.97 s

Instructions are basically unchanged. iTLB misses drop from ~3.67B to
~26M (~99.27% reduction), which results in about a ~5.44% reduction in
cycles and ~4.18% shorter wall time for this workload.

Thanks,
Rui

