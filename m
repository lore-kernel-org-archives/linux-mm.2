Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75757D6E2BF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1856B0088; Thu, 18 Dec 2025 12:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2C36B0089; Thu, 18 Dec 2025 12:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC066B008A; Thu, 18 Dec 2025 12:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C55E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:48:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0669D135AA8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:02 +0000 (UTC)
X-FDA: 84233325204.15.40204E7
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 71CC11C0020
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aQEc95lb;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yvi6EEyWQGpmoQ+sKyKT1UGoOl5UFeYLCESoPn30Km8=;
	b=M/X0Fodvo9ko+R3fKfxXRsNIIKEiX5gbWQBz9PTVe5hdn0iGnnBy9i2L4pTzcFyaeqWsDG
	n9D1O85V1y4Ak3qe8VxVOHp2oqfQBKm2bP7BZbm5M0SFb6FXuqw0VN8dijQBQ5Vl1z30K6
	gMVS1DQ9uGBxOqaIOHVZM7L8YiS5WTo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aQEc95lb;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080080; a=rsa-sha256;
	cv=none;
	b=tueeqVCKs2Jk2zqN/NfrJqBxpiGYr9vCi0ofW2dTxrwwpMTIULXNpJrxzPcMfUGjXK1P00
	2mwnJ3oQovLb0C+VgjcJVFCrmxZTlHjeQupMOof1rMD8EZZFSsZNPL+wv+cLwsKk8EYq4a
	AEJ/K/aBsIRHvhkKqqjyhSFcJtuRVwY=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso1476156b3a.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766080079; x=1766684879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yvi6EEyWQGpmoQ+sKyKT1UGoOl5UFeYLCESoPn30Km8=;
        b=aQEc95lbaHBasJ1J8ZWjjtuZ18To3g7/evBjXP3UegVlZEJ4xyJVNNzm6rwlxZ1i+P
         JobJ6F6l08Bwen/k06Ey/QmW1alTek4lfx7LIHT6jVHF/pzj7cTM2/yA7s4OhGyX6rlZ
         VxsMVadJEtIzBU30CPOBq+WaGSv5KYvUxZQhZCn4YtJfqepc7NFbCBsaZlVLVDXsTqoC
         9GO5ph3jBRht8OWAUuc97/5swrmK1OJZOZEqhR4z/o+SrkKCt7CxY4DpbszV8hGONiSV
         E1ZhncDZPZpdbZwlKGVOk8Y8Wr6dSjF8Hvu0jEvuX3kOPo0SCk6bbHkAJYOmngXhGw4W
         ypjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080079; x=1766684879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yvi6EEyWQGpmoQ+sKyKT1UGoOl5UFeYLCESoPn30Km8=;
        b=V2EqTx147j+nZTjIZU1ksJ40ymBTI9qRoFoxO+fx3WjzMAcnQWP1tLDBqK6+kONmtx
         onbkXVzCZy/aD16G8naukwQBJYjTEUOevbZfPBLoqm0xHKo6196hUbuylDCGARtxrAS3
         FFjhSOUn++XbEWdpYXY5bu52iW7pKmUYJpB9LEcUeU6JUD53WV7yJ7uvs4/D04tTreGa
         9MJ5Jfysqhwk1qrfMwSlb5PE2HulHl4Y3PsOjRMpqu8gHKCKlayNF1781uAzQqonJ5Uz
         0p9z6EaTQXRl4XH9SGLsQSCaQJ00jyw7OQ7OJ35pNtQ+XdYjDPyQIlkErD1j2CJ06YL1
         duow==
X-Forwarded-Encrypted: i=1; AJvYcCU6MsW8FlL5LZAvpFlhigjAIfnKfNZV1iBaT/gl5UMdb1kXnC0kggGSPl3w+4F2YT0dlbOwObIEyQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl/+IiieEVDrUbBrqSitbRygpNqN5nYO+A/Ca7593Ira99/uhC
	PsyInmsIWgLxDdh2/jHayR3tYAAaUud2iBaDww0g8CBtJWto0W9dn3Jc
X-Gm-Gg: AY/fxX6goy+zOvO8sELZclXRVuyUTmmefYomFBD1MZkXWNx5FhsoFjRcGB9p2GE9S5U
	IgXWNwKHPa4RCSLdS4IotL13DE0x2KEMpYkjQbMNGFsqBaWBBiqrhLHHZwg5gO2qkhI1Op/8gEo
	AHxOP6qfg04BQEsLJpAjREKbySaBCI66TvQ0LbU4MbcE5vkPOl8339m5B0/zh9xf9tz5WPMzDQI
	D1xDSo+JUWaTgO7GN1mF9uddTaL9+czeu62TK6STOqziYuUeC2telngLpGL9cuBf0FYJNf60uxH
	WQUZLXF7H7ERlw6S0gvYBHiGUtbLdqYiURI30ArcYfmwIwGfL6wWk/4YjIOuSOPPAgnD33ZZDoN
	3lrlQKftTAOpa009sRFSWrAFS0PRaQjY0T8Tqpl2h9IKDjhpjC9HzwFIYL5i+4M0eOkFaFGG/Pl
	Twz1zDoD6SbWMqupsSxJN8sIgj02wYyy4wqEVU82GHo9k=
X-Google-Smtp-Source: AGHT+IFWmt4iH/1kf4fkAJoa+/tbrjhvDMeZi8TMTmoV9V69RJumexby9oqnT8yZuZgLFEmR98CpTQ==
X-Received: by 2002:a05:6a20:72a4:b0:35d:cad7:cd63 with SMTP id adf61e73a8af0-376a8eb1773mr271781637.30.1766080079248;
        Thu, 18 Dec 2025 09:47:59 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.152])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fffa3e7sm2847400a12.24.2025.12.18.09.47.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Dec 2025 09:47:58 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	chengkaitao <pilgrimtao@gmail.com>
Subject: [PATCH v3 0/3] Generalize vmemmap_populate_hugepages to sparc
Date: Fri, 19 Dec 2025 01:47:46 +0800
Message-ID: <20251218174749.45965-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m7r4jxkuue8fbtxadjxr6akidrbe6x89
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 71CC11C0020
X-HE-Tag: 1766080080-539992
X-HE-Meta: U2FsdGVkX1+/Vqizpfv6Pe2ez+qET5RLHXs3opmbdpskm0YQhCKh1YXv55wXxb3EbneVqSYQVUSgjDCXh9uqyAoaFTFhu2SIqZ+ODWQMZe823AiT61cA4MQhCAnKKbE5OZ3lCBTlBJYdIJ3pisk2waj8onyDzZU8mURTHNuay9QNfNoWT0jhbV31zmfIBKzZaQa+02eMSsVoKhcp5tETHZV+XskL5TTpc32WRn2u6K71nTaRt0OMDZ0QqmdS0N+3NBa3C7JsKzLL2HjRbWsYf6hwhvHUHUzu6FlTbfU53SQeAOYs62byfs+qVgTGIgN0OoiNQbtVSumCRJXAfiAvVEY4z2omr56Ohl7kl7613hMqV0xqFKVhKFXliFHPK3MGMOFe0QdilZPDdvd2JPo2PWKVHzXDn138U5p3Mk7aJzCamKmXNQpJqbomneHc5NClVBeRVvbqMkKwM38ZD8azHdtDOJ6bWQUurflqbzDvGMITSTQDCT7oe7HSWGT2BMZo5vjyev+T7q0T9oAEGkz6ZzEoh+Jvrs3LLbAwjYzy59jfBGDLZWzWcqlEftKx/j80UYD3wk46+20GbHdpXRiJq2cbm1cLNSUvyhEpnn7aGyrikN1nXze8Pg6tJvT2OjYltPfoEPxAb9o37FL7ol+ViO+lE9tIEYa6EpRVFPd7zhMmdqqrzVllbUifSG5iwuuxsiBCewwW2LBte9GrP69AfFpA8APwXcYcqliI3qoxY9pC5WiPkojEylCZB2X7NmlHsAGhKapRmkss90ffQLjnQ/2IiNephuCOZGWq3xglQCAfGf7iZn1ebDVUTZoL5EcTcK/sEmuwr8ZPaUhVq6pNmLYSASztRNpcIEFSVPFuKJab6Pr2FsWEIE0jYAW193dSOmTn+rnezB99EZ7Ki/Jr1PELKjADmjzKItKIBLqMKYEoDD8Rgz/qu0ivsPgWVJHvddsImGV8bjKQVeKzUcU
 fnxy6/up
 0jCCwYfONh6n92ESbLbSrhuZyCipOEN9RWOc/aba/vn6Rka2B6U2R3B4OguykAlv2VuM5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sparc implement vmemmap_populate using vmemmap_populate_hugepages
to streamline the code. Another benefit is that it allows us to
eliminate the external declarations of vmemmap_p?d_populate
functions and convert them to static functions.

Since vmemmap_populate_hugepages may fallback to vmemmap_populate-
_basepages, which differs from sparc's original implementation.
During the v1 discussion with Mike Rapoport, sparc uses base pages
in the kernel page tables, so it should be able to use them in
vmemmap as well. Consequently, no additional special handling is
required.

Remove unnecessary whitespace from sparc.

Changes in v3:
- Allow sparc to fallback to vmemmap_populate_basepages
- Convert vmemmap_p?d_populate() to static functions
- Split the v1 patch

Changes in v2:
- Revert the whitespace deletions
- Change vmemmap_false_pmd to vmemmap_pte_fallback_allowed

Link to V1:
https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/

Chengkaitao (3):
  sparc: Use vmemmap_populate_hugepages for vmemmap_populate
  mm: Convert vmemmap_p?d_populate() to static functions
  sparc: Remove unnecessary whitespace

 arch/sparc/mm/fault_64.c   |  4 +--
 arch/sparc/mm/hypersparc.S |  4 +--
 arch/sparc/mm/init_64.c    | 53 ++++++++++++--------------------------
 arch/sparc/mm/io-unit.c    | 12 ++++-----
 arch/sparc/mm/iommu.c      |  2 +-
 arch/sparc/mm/swift.S      |  2 +-
 arch/sparc/mm/ultra.S      |  4 +--
 include/linux/mm.h         |  7 -----
 mm/sparse-vmemmap.c        | 10 +++----
 9 files changed, 36 insertions(+), 62 deletions(-)

-- 
2.50.1 (Apple Git-155)


