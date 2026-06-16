Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E9CCD98EC
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600876B00DD; Tue, 16 Jun 2026 17:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA416B00E1; Tue, 16 Jun 2026 17:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D436B00E6; Tue, 16 Jun 2026 17:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4CE6B00DD
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:42:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7878DC1652
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:40 +0000 (UTC)
X-FDA: 84887100480.27.80BC01A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05090100002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IXIgeFBr;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S8BsJvF6zEh1NYK1csQzbN1lg51lDIINZMD0TD5QoMM=;
	b=4tEZkPHdmao+273eR+d019oQNnKSQUChzf4kLGv3HppINoOzaOCa5TQZZgYB9ygXWm6ksi
	3Qdf/CHC8djeb40VM+crBnYdT10idzQg/quNXnRKN05yYpzUTKlCOYRobiuRMda8L2Cxc3
	S791ldo8tK7EOmduq83N7r9tvBeEduI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IXIgeFBr;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646159;
	b=d2iZ6lgDScRDUeIUj7EGKsgtkCws3uWQlCB2kMOVPuwTG8+dC6vXg7keJcrNqQE/XZLP29
	pcORGwxGZTGSWyXs//KKaVqUEv5FmEExp8wgRew2eDiNgXDr1wlbD9b+t496tEr3jPwwSh
	p7VnmarZ6ZQ88VeTcYpKVUz3tPaBSQ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=S8BsJvF6zEh1NYK1csQzbN1lg51lDIINZMD0TD5QoMM=; b=IXIgeFBrGy0wFVwSSSiP59iIDh
	8HGsh5qFq717GXuQsdxfD8wTRSkrFoh7tMRE8LvZvs7XEPTVCtYB3qHW+zfQARgwC/PRDnicA8/Hu
	UP68Ek/Nco2FjTZXQJDjdHE7/t97tE8wSTtykL+56RVubc09Fh95holHXlbRDcXjxMIpO6KHzKEzk
	LTKvEfv4IrnugHGv72p63IhouAEIorcyxvoxR7PnmFofeN7d0vRFKGQrvH6rAUgbBVpO+xSThdeWV
	XplP0J1GAQUjVsPJx8w7wpzVorPgFWY4sQ0dumEfTD2Hu2OETl6/3SQ03EOmguwAlLx8rP9Diqlzk
	qCYWWMlw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wZZ4N-000000005GL-0uRT;
	Tue, 16 Jun 2026 15:03:31 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>
Subject: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
Date: Tue, 16 Jun 2026 15:02:57 -0400
Message-ID: <20260616190300.1509639-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05090100002
X-Stat-Signature: namig9z1dssh54bnickoc5xyptiqwpmc
X-Rspam-User: 
X-HE-Tag: 1781646158-660380
X-HE-Meta: U2FsdGVkX18P0PiBl/9vR1ZjcHq7PNJJV1FzIghqbqOVJYxNHjq58k0b5mmbzQd9EKy/EZcWtQRe5ieVpE+EoJzFZKxR/sUDSUJnBxmYNxef70vl+gvhsqqpmyLml30vUDKRcXLVSWs523I2yMuR8SG4lGS0qmGwa65lwd/i3Sywm/UWl9V7kNl5783iYv+xxvtJeq97VglHRiNllbzyB1UzbRNoxUT4U7qiE/m+4w30lAtKI1nGiYZJRKVVmNvO2+N13rISGKJkzVG3rDjvOhQrSTnS8KsW2weR7JqR8+pICHADDkyt0wqudnoYlffjoqMnq8VnZ6FYM6oAB1jluBrKV3+UcrJdqcUTSI8iscXLAflg810qyr7ZkN28m+s8baW8YELsS2vkpaIpd47Mu5WTPKqDENvpaRSBPNg3zOtRje4jJQzr4YoZvkJZwEjbqWi+MAfNdzl9zgPQU0/YYxEx65pljeZNQjdxb6gMYMqF6JdHRxj8fiXIDCMRb7NCS7M1f9vZKr2YLxDnNpZly81Ix88xvEcVWgPgmyxOxhHo36PPRxxbN2lHOvPY2W2ZHHI8dADYDzcetno9ETk2dxoIk2AgIrWBHdc7QZ1BK/Jxe69JF99D5FhXLSYcO55zwehESVdrp0eH1LRAmeAz7jg+5wSY47KsGgQGSOzuitrIZwIdat/s5GmLwUp6X4to21F2+ToW6fjQp1BoE20CxosL2KMQi8FVgsxz6ztN23VLIwVPsvb67FBF8c2cTbcix8jlQa1VvO4c/vui6Upw5s58uhe4Lu5XefV1Jtb7LIW2bMMK5PXcMqE1f9iyGvvQ5aIC/5pVH9aenF9DOxGcm2wqSRRbr2fbEz8sRUQEgfJDEHPYV+h00WDsL8gIyVHmNSVfUH7lYMXOYEvQKfCkqTLRfeT3pNJpZfuerPEC/xAuj09Tun0+gHZH5PX9VUBWzerpIf4cgbvJ8ddQaBY
 oPyJa2DL
 mNeWuFYNu7gbozhsidjEIm/vGMX0b2kzx36bzIqWY3hKvcy8xElmKATGTtRMmm1gUR8BGjGnwi/wdekRoS6TL7y3VhwRf/DL8tgTsWrqIH5qB2uHiVwqDEnXfIHQwYyWywbp92P3aSM36YzrfH+IWKseE/l31LOxRWg55QZY9ko2q75nB29nv5GJJQ0VYYfAwT8fwy0bSGwxFqejQXuJqkE0IyU59VzXOoou1Df8bv0vAdi8q520/OFsKsNzWb3v9DjFa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes processes can get stuck with the mmap_lock held for
a long time. This slows down, and can even prevent system monitoring
tools from assessing and logging the situation, because they themselves
end up getting stuck on the mmap_lock.

However, with the introduction of per-VMA locks, we can improve the
reliability of system monitoring, and generally speed up __access_remote_vm
under mmap_loc contention, by adding a fast path that does not require
the process-wide mmap_lock.

This fast path is only compiled in and used when it is safe to do so,
meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
is not hugetlbfs, iomap, pfnmap, etc...

The code seems to work, but could still use some more cleaning up
and benchmarking.


