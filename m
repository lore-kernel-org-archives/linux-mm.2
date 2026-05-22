Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25EFCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6577D6B00AE; Fri, 22 May 2026 11:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F6D6B00B2; Fri, 22 May 2026 11:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544F36B00B3; Fri, 22 May 2026 11:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4136E6B00AE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:14:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2936A085F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:14:03 +0000 (UTC)
X-FDA: 84795401166.18.A1BEAE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4566C40013
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:14:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmykpIUU;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8z/dHuRrsH69kfHsDgaXM/ZHuHT8ZYmKE+HRTueiZpU=;
	b=ZcnlZf+Y6naw71XLxR1XK2xQJ2oKg4caErsUClxM+thob0O27dBzhj48ymcZk2Y9FG2NrR
	Ix5z6GsYafT0z0H4J84jkXfA+Ci/HWHjcix/iT2MZ2RKvCwp7xMDTw7/HTYyLkv3ktCIAE
	6sPsb5yHMHzvLYSGOP/Pu27qGBYppv8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmykpIUU;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462842; a=rsa-sha256;
	cv=none;
	b=GI40MO/KUUTS5S8BWxlxXUXs+hOcUuX9MHiu+PFWqUVHhD5EZBUBDE6jlt/6gpaiT0sb6o
	jIy3mj6XR5XUn/zGNo43Hlsd/LAYhrmotGqxEZgRjB8f1p8ggGNMIHxqNxK5fbz+ekfbTG
	pTE+ps73VB3L7QIv3XK8hPCqZVGRDxM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5083942D5E;
	Fri, 22 May 2026 15:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F051F000E9;
	Fri, 22 May 2026 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779462841;
	bh=8z/dHuRrsH69kfHsDgaXM/ZHuHT8ZYmKE+HRTueiZpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nmykpIUUzqwJctPR3LtOOLGqhWqh7KcRrFtknn4Fs0FQm5So1T6OoiCg5VTwWgz9A
	 FEbM9JtFhCvlIlyj1zOUbAWvqYy4LGLYbkvmEJLlVlMIiZZpPWwHxs3VPtXNbRc68L
	 lSGh1rUkAzDG59yeupZRA7y5GRZ7DNPetY7lboa5nJIOh+L2CTb3aErKpXXPZkEHA1
	 rdxpzis1wjevMqasNM6/JUwrkNu5FvQ7QEsfSQhqB10R3eGMM/MgPfZahA1HtVM6+q
	 DpUR7LnojKa4cZ/I+DB94QJtMLAPi27zBFhA/E+w9LTkyuwI8PGa5Lqnd4TKDY+WL4
	 iLL6WRQDEegUg==
Date: Fri, 22 May 2026 16:13:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <ahBxxetoc4bMGmdU@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
X-Stat-Signature: arxynehdeip3ekq1rpr3f1euyq8ncjxo
X-Rspamd-Queue-Id: 4566C40013
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779462842-960996
X-HE-Meta: U2FsdGVkX19zfvKr9xGJJkIRqydz00yVcFu2GVrYSo2FJ17bzStUjPsItq295pkzaBUUWuFviDDeMJFCrR4BuDbqyu3zLwNN+kEtNhQg6w1aPFBIxpjX+WZSG/H4x16resZ+YenTz2M9TdpVV/wIYFkQ601ZX+gXYnHiJNCcBYFDFd/aiP3jGrzt8fWaoLMPG2QRokZtINkrkbZonOFmWh7i5c8MFS/Wk2jQ6WCq1jZQeR554mzrAppGSQxtdRwniK29zxupz74Z7Yf0KIKrzIRgER+HPYs+kA8a7tPARvT5nYHcZX0i2L51SoZ+0c0j1YLf3DlV4uqErDAI8vy3r/WjqASgG7vFoe69FW7Zk6ts0d2Z3kPlDZ0Rt/0oCFRU6yZlNey/fdbajK5UxZG7tynq+nk5Z4wOOX6y2jpUP3mAu3f418eJyNS6mIktfDFVBY9LAlqcgCIu4Vo2WzgGFTs/WSLNyUKYGizyl4RFmbGwUi9d5jSvCliSsn8mmwS0MOHY1AxuDtGcEMOLur3kayRI0dy0u6rRyhi5lbsUZ58ml9A/FpTOctnKOr/r64vWEhvhAA8V2T5MARoZWkqcgcqYORJ20rSjIYf8B4f228XNsT/E5eBWdqNbA/KQpsao4VoKoTdG8HNgwx9kI8JU9LafxKI/qJlvKajyQU6hDxzcO69m5S6swGIefMBHiBl4IQ+TPjbeCgwxYlvv/3spum/yPAHwnHMzBvgy6BugKY/msaE5IkhVzmzdXL8g8wsjcWxxf0bjJkWCGQtCbLXXde5DVB2ep2E/2cUnh5CLiOmnO3btMyKr0AfsZNNv+323nxh49JFshwddKcZ0B7FatGKwoesfF0XHQxhlulkgTzsvSN8yztFbQS9DQihif2He1mS+HXS/8f564FKrgCejH635924anUWezHJp/dr6cuD+LXyQ15CmKSCTHeaaXpEqyS4xpqGh25jiRllDzGk
 ObcvujuK
 0RvwJZccOJ7DLWHz9fAHj2uzG8gVBEc918JWSN+PAgyZTWxEk28JhqjyjDgtHaQIB7tIgVSSibtvpNkWdbrJTI7/7uFFJRIkUmQEVW6Q5/rYedBV1vy3B0eZnFMvcOYtipUOh1+uDzhm0LsaEa17vdoDulPG1jP57wMtMHXthGk20PvlbpTjmsoZ9HhQSbsG0u1TDrNP2iJMGn2g0MhMZdK4itsTH1kdsChdbr39SAhvG7+v1QuRzLQaioMHiPY5w0/NIszi2Mx501f9v6PiKY38hpSqNVc7PLTEW0KVwehnKij/hZgfbKL/ynkQsTdUix//KLkamO3KceXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

This is not a hotfixes candidate Nico. Don't send a massive series like this
with that tag please.

Thanks, Lorenzo

