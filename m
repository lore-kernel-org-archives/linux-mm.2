Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EF0105F7AF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7077A6B0089; Fri, 13 Mar 2026 10:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A936B008A; Fri, 13 Mar 2026 10:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561D06B008C; Fri, 13 Mar 2026 10:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4228D6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:42:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC7F9C08D5
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:42:28 +0000 (UTC)
X-FDA: 84541305576.13.0BDEDCF
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id E551E14000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:42:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=WeIfD1of;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.169 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773412947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6Y/n2o5yEo+tuZB5cloL22Tzkf84YmlhIt4ugqI5/U=;
	b=jgowRmvtaKU3Tq3jooC0Pm4bhx919Luvwbp5UvXln1YP3aqVEdmY6GqmfHqpMKTUZ+3Lq0
	f1UCsIis2fY1e7JU8Mv9RX8WvCp5S0F/goMHqyZfvYn0qycChKCR2/Lzum0RwHgNlUwzej
	javFz7mFQidPhNSqBnD+YlnqVlT1FiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773412947; a=rsa-sha256;
	cv=none;
	b=f9HHQi0rVZIcsDmwBqQ+/HbUpjrpbZ0/sLEoE9zl7gPxUT3+JJsScbbiozlTdjkiETccpT
	A85uIns3W6ds9jnMwYQA5RH1P5DDyqLQUKF25820TZT8Httkkg/zxHGyFk9IzbU9uqvcV3
	wWV6kKOccbqaJB/yuWq9gfSZK8kuK5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=WeIfD1of;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.169 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ae4d919f9bso14655665ad.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773412945; x=1774017745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6Y/n2o5yEo+tuZB5cloL22Tzkf84YmlhIt4ugqI5/U=;
        b=WeIfD1ofaraoEGuaGdroxi7noZ1pPAvwx0jwTtrDgW+/La78khf1a2KmJlc+zpgNwl
         OfmfBBb4xJPMzcPhllWtFFHwJVQ1RSNOx3CU/lF69XDarwUz25w18pnGS5u8syPpdBiB
         c2sX+mnzJQUXVx2CxixX6n6e8Pb/5FLfsn/2AUg6xqxSkOztXpK2J6psc46hHq7+91WD
         65nMc33PqzGNqqywc76Z1bCSM1dlQtzORjkF95Owd8DRUpwY7dvFTEEh+6IckrD8v3XL
         eMkkb2ps3TjKjSYYxlbSje9Ztvk95zYTCRcYySQk6bdcXe1SzrkPrnBXhfbDLQXN9fIe
         1e6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773412945; x=1774017745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6Y/n2o5yEo+tuZB5cloL22Tzkf84YmlhIt4ugqI5/U=;
        b=R6FnBzXSwypeOckoNifOmevjbWx7/u0FXPZ9S6NjFgUFt3auVRtAEXvBrj0LIPTuBp
         /Tjdrqz+S98ovq8oOC+X0V6HKfyAaoedeyhJyg5fanUUTV7xq2IgiEFl7eb9cLJZ216b
         NlfyfjXjdhdzNgvjFb01XcsBEwYPb6SaZWrRfpfofxDqvsGI1vIZHFrsBsL8Ctmavv4c
         RC3SPGmEYbX5a8QOzp0rocLDrSptXYKbX32H2lThAxd79yiiEmeAFvUmNlmKf4Y1WsSX
         BTpfIj3ERuvCten2hc/UxjMhL6PuTzYc6hR3k4Enisqce3C7G42H8pMoAZDvdpglspwU
         cGhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPj7j0OXa4tE9f9B6Azew9qW1X0/1k8XjQpUsQGur5kZp6pJff/Arm1Yl+SJl7mAQqRjrswBz4HA==@kvack.org
X-Gm-Message-State: AOJu0Yw5leVQuVaG734ToOnvvr3s+f7TPs99hcd5skAaX7rua1MmntSo
	Weahyym8OVxjLAGWIZfHIYBzU0TtnVcmuX2l9Zk86GHi1N56YVGe5kxAn+RaJrcrR7g=
X-Gm-Gg: ATEYQzwynHj+sxYyE2BPwSqMYDYtOsa7wyrWl+r7SB2TuCqJSL5TCkDxHFJEJ3kzuiw
	P3nzoGce6DKYatdyCUvIvTHXn2mzswgm1muRr++4U0I//qFEOYGjWKLjPSQLpusJcswJAxv8ULS
	YioN9/Eei95o/P4pxlX7Oq/e1oCRITDN2kS18HS/THE4m+aD5ObMERuhppJcL4n7WBhpfTg4xQv
	og5NQ8JWo2+Zvt3Ggw0eOn3w4QOA3nHyiqXsnq7+WaewDS19yZnZE7vbjHaGN26OQ3WGVIGok8c
	HtFnLB4u6tfxGqgtEvT5PIIGIjxZgOifMZsvUoV86z6d1mKOtSbGBHz+DKYiIyKUKY3w9MG0fZs
	DgKDUn9QtAL1akBCqyi8Q4ZEyT1GimSS5t9QsymDZ3M0ITA5yrDygrX0RlAeYUZJ7nfznJQsfXE
	5z45/hflH+V6E=
X-Received: by 2002:a17:902:cf12:b0:2a0:c1ed:d0d9 with SMTP id d9443c01a7336-2aecab32ec3mr35478735ad.46.1773412945451;
        Fri, 13 Mar 2026 07:42:25 -0700 (PDT)
Received: from gpc ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed9cdsm25651935ad.60.2026.03.13.07.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 07:42:24 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	kas@kernel.org,
	kees@kernel.org,
	kernel-team@meta.com,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	WANG Rui <r@hev.cc>
Subject: [PATCH 3/4] elf: align ET_DYN base to exec folio order for contpte mapping
Date: Fri, 13 Mar 2026 22:42:13 +0800
Message-ID: <20260313144213.95686-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310145406.3073394-4-usama.arif@linux.dev>
References: <20260310145406.3073394-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E551E14000E
X-Stat-Signature: z3d67984ti4sfak5wnw9wxgmjkg97qjp
X-Rspam-User: 
X-HE-Tag: 1773412946-616105
X-HE-Meta: U2FsdGVkX19l1kTIF9AUp+ZMsJbQUaG1l6/JyqHZracC2RTbpK/r3qqmrbchNwjSm2uKu1phFGxVO4HCkZs7mo13MYd7++BVz5hKaj0H94bIA00Px/F1JozOcdOjCjGooX24iGotvPoGXiZ06Yb/UlJu2gayaESlsYtSx5tc8WUeElsMU2e+C7ei+JzNWvi9nyOffRhl+TqWeg5WDxvxq59NlDEntlWEaYFsVHSyAjHZJ8w3YjvDYVxIy32W1J0pX/nMrNowVU+TwA8dvxXTqcOdAu33gwaCAbQ2UpBhX8Ah5sgfHRn3u/OHu85i6hVJPtYGOS9+guWvtzc1o1amKrBmlN7EAlC9KTixY+UyA6voFHqWo+3iLv35fpD83vf4IV4qpas7jM+vQTPdIjqOYlJlqXm+biiaUzel+nEcyZvZ0x9J0VmKvdS6t6KXAMm8LJ7LMuDSfhWQBdSYMK6go+8Zw2XIXMIeoBh/a2c/7xM4iEk0CMhoJ5U5WLuFNI3BxiboP0qQf3Fg3X+woakEmHeuiWc5z58qhugj9vvXRW/HKhqan82hyS5Cs5RTBrdHqrgGG6zhofC8ZACEuS44ndetve31jqLmeDT3jZOyNVfnplL7dX4k8pTk3xPIJHAvxe03I0BXbJTp1x0Sd7vjBleGC+Wo/gCl7agJhSbsBGrixpC6jxjOuPQVjn4h+B4wm9jbIAy5EiKGEJ3jpafbdiT7hZkYWLVd5rqgpyZEwikJyaRX66th4411xOnFqy8i7jjKURlLB6djpWGft9VRY0kCFDK9EtyGiThaVivOo/72zP6htRoPOsEhYo+xmX7fY1NHaue6wKdLCWxN/tHYW8XUjAnJ3GX48t5kUPYwYTUNu5aSt/xOaSS9CsAcVpdT+yKZ/3iXxbrTQHuKrwhNydiJvsujOXkYQ8aRUQFxZQlvzpIfS9nkD2RAf7htKBDgGRP6r6mvPwCGLClxs7Z
 yMtpoF4O
 FQtF1RwJ61jyZDCUGP+efWJi9R0qI2ufvv6T/geTuSbZ8kucZxL1WwOS03mbl9jgNOe9UKfCiZpFwCssqcBlqCtwrqb2cO4xtPFTcH6GsxEY/TLULQNWDM6bnGc3l7KC6eH+aMzYC2KG5GEzl/nnQ7AWEv9WmhK2Il24H8ouFNV2VTN3ZhAnsLHGAdKuWsKIZ8zLKAqJzm3wq3dqMDWpVgCfkGqDaTPf/ArqcstLlZTNGgELIwfiRg/GFFnHvk5hLjnwxIh5cJPlYoK5f3WY2KRSF7eqCEKbT9ymaQ9l2RX7SmjoFAy48qHy5WaX5p32zhnZaxhbIWLTPUpnfnyHYi0c2H6xWJCkZa5feisS9ua/Dfa4B9PfS/I6Ex7O6E3X7LRsIS1Dz1ada9fLpcFmq73YN5m753J96zaDEBkfX1pz5VP3MbgDmz3BDg67gMq43ZYsYhu+xBabm7Hz8bRZPRFFlAaGzLmgIngC1ZvNUY3EIEMSvKdMf/dSK3e9W855pz06csejAxsCq01O2rnDwOKqqClN2VU32nWWXawYhXC9MYbsBc0Rhg1VSrByYV+x3WAUUnKQy1vwBhlN22SQJ9eF5hMnogEw3zDzforWoY3J1bunbaE/VPWqFsraS2pRYdMEZ06Pg3/HmWhgjHdMi7g2YTgcYoJbbTvdmaHMG7X2GgJw1sGVPVCCEOY+TNrI/3TMHbfUPMDKXvL75c9J6X0j7zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

Glad to see you're pushing on this, I'm also following it. I first noticed this when rustc's perf regressed after a binutils upgrade. I'm trying to make ld.so to aware THP and adjust PT_LOAD alignment to increase the chances of shared libraries being mapped by THP [1]. As you're probably seen, I'm doing something similar in the kernel to improve it for executables [2].

> +			if (exec_folio_order())
> +				alignment = max(alignment,
> +					(unsigned long)PAGE_SIZE << exec_folio_order());

I’m curious, does it make sense to add some constraints here, like only increasing p_align when the segment length, virtual address, and file offset are all huge-aligned, as I did in my patch? This has come up several times in the glibc review, where increasing alignment was noted to reduce ASLR entropy.

[1] https://sourceware.org/pipermail/libc-alpha/2026-March/175776.html
[2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc

Thanks,
Rui

