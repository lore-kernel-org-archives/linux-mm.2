Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339B5F588F7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC0A6B0088; Mon, 20 Apr 2026 12:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CD46B0089; Mon, 20 Apr 2026 12:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472FD6B008A; Mon, 20 Apr 2026 12:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 328B66B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:33:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E6C78C5EB
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:33:44 +0000 (UTC)
X-FDA: 84679480368.28.72E19C8
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id 565BE1C0010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:33:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=eaelrQQU;
	spf=pass (imf21.hostedemail.com: domain of "prvs=563a806c7=dipiets@amazon.it" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=563a806c7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776702822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9sWbHxc0NftggCUNc8XH5sYfXjCQ2bDYjxsPR5LFRk=;
	b=Hj2+1WqJVPi4naJ+/ekvqQO3QE3uIL86aese7RUhlb25cScXHJ8BDQUySDyEdjUBLSVFnW
	RBFVgg+XedBNyLa9pOo3YCU8m/mRd2fX2d6VJvQRzqUXtP6sUdJBGbrB852HBYrd33jUsX
	RdwzHdPchMZoG+VkdDSGjxO/VQSoBbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776702822; a=rsa-sha256;
	cv=none;
	b=nmbKt6R54QUREeoSRFLx/lQM9ZWvhY/o1Z8OzeYADPgwvIRRxMe+P2j+01OakxyZ8DoWd8
	X27AXUwj2hFkb4qCvyZ1tlPThdQPHOfDd7zkzvADV5QMMT5U27GWKvt5xfUzF3OvquGmT6
	imKeG4iv7bspfsfL633Cv2Xept2EtN0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=eaelrQQU;
	spf=pass (imf21.hostedemail.com: domain of "prvs=563a806c7=dipiets@amazon.it" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=563a806c7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1776702822; x=1808238822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X9sWbHxc0NftggCUNc8XH5sYfXjCQ2bDYjxsPR5LFRk=;
  b=eaelrQQUAIybd5jgbc/Q6VBN2vA7+3BB0H/AJThImgNs5ER1o53XfjTn
   UAuFFimJ/NJNteRtsN8NggfcecvgMiULnbppug4c/40CM8P7f1wv+10Mr
   begNQaykcQ66ReJ0jYUwDLUlRnbydJOLLwqJi9pcSRmHGTUlK7/dW3nzi
   S2IXA4Ztn2I11TfOi1BKz5NJFdRD11HxzWh5IMchV69mdWPnhOC9WRmVR
   VNY5ENO7bcHbg7sf1d8ETe7XZtCYIaXiZEDIr1nrXQPvnxsARktwm+5EG
   bHvwDM8gLQPnayXrhEKoQrzlwdm2QqcJoTTALNpqZZanc5t6wQtsnn8s5
   A==;
X-CSE-ConnectionGUID: LK3GeKKVQGCI5NhP+QU3WA==
X-CSE-MsgGUID: zR+AVDFsSEiBsgS/xI+5YQ==
X-IronPort-AV: E=Sophos;i="6.23,190,1770595200"; 
   d="scan'208";a="17524416"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 16:33:37 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:9653]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.27:2525] with esmtp (Farcaster)
 id 46b80425-918d-4d73-a66a-caf3b55c19b4; Mon, 20 Apr 2026 16:33:37 +0000 (UTC)
X-Farcaster-Flow-ID: 46b80425-918d-4d73-a66a-caf3b55c19b4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 16:33:35 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 20 Apr 2026
 16:33:34 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <ritesh.list@gmail.com>
CC: <abuehaze@amazon.de>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>, <willy@infradead.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Mon, 20 Apr 2026 16:33:28 +0000
Message-ID: <20260420163328.22104-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ldenszsy.ritesh.list@gmail.com>
References: <ldenszsy.ritesh.list@gmail.com>
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5f3goeu5hfdd1rc3nd6rge3wuq7zjw9t
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 565BE1C0010
X-Rspam-User: 
X-HE-Tag: 1776702821-204392
X-HE-Meta: U2FsdGVkX190MI7Ba80Jj8UzlVLu29XYYKhEpb03AbH0fMV7iUnZltILyiJONACRzbaV2oI2dEE7H4VafI1+WUGkthsMqnNe88ENfhkG2Fr77zr2fo6Lzw09N2GrH73sEplZ3TX3bhhmeuCJ4vR7qH75kU/LX/CWvW1a1Ur6DY5JU5AYsFhnSMM/SIhCNwNSNSZ+v0nIhx1OgnVw7qznZpjmHYsclcqEigyZ0MPIo3KNJ3dJIT21mymQt9seNjR/gF5XLppZIJVRkpeYfCDk1UZImpZDazeydrY9+RFGc5ygxSkKcwaDrXaLwibqvCzcRkzjLmFKJw7VH+GKoHsn0FJeeReQLbpla5TXf/6l5rIR2Aua+Yrk/rlK5zV4/nA4O+YPAJsad9QFNnd+sN1svrxLh41hiR/mxCjx9eoEFpfrUzsEV4GYnXsu2BuSQ0J1gCZPkxBqtksBYWaxp9aZ4akIyNk/u9GXvBBvIYHu4A5D5l98RxPQgQGzo/8EHSmhrabknTUFrzaSd+e64HuLYgxMZJWoqtrDjF3Fa0yNC0jhXHJjcpyFEUqM2xk0OIWXAGQlw1O/75A4ZmLd/VSjLkwfnWzm7NWTCvE4Cmumo2pUsAvocjOMZXeSapMwvquMp6OpuHUgyz8GFb60vn2ukKgbdyYA74PRYiICQwTjrZQwsFfgJ2eBu9Yk818HgtT26wjPn8YoFhIWFGNPENsDl0pJvWfkUaUC28bpSHgGK68KEsAwQeALhOmO0fVeLX50xEb2W3hQFHSN2r/3ngh9DXh8sJbmZPns3Qo3+At+y1xO2Pw2/3WODLYxkclzVKukiQiVT5iWc7Ygy/G+YfRgyFbXKbJQTqxX4JS2C4XYrtZgopAlcO00M53tNYvruH8pkbf0lXJ5PUvS4N/MmamNuWjD03b5+pLOmf5kc7IaxIJ0ti/Hpin6UnTQBqiYoYOwbCy2yApWd+tJDplIw/1
 18Q6xYV9
 eHWpOJ0vs+AWVSYHgLlQjbhXbtlB18O+dQy94uKKf6NBMTU8H3o+cPOaORYkUsJHTbpSRkAdGn4LplMHHn7zqlE/vZ92H1L07/05BtB3fCVXuMV4rnR0ySR9HUIo3ds1cKCdS4h0T2bb2R/9PadsroMMFiOSL+Isk8tfjsvCe5X3FBkR60tdEZ27RSEnzAQltGUjiIRmtT0oxWyzuYm0JFGrILSBcVWSNZgOL8hgiNYQiY6njsAKW+dL173xgJqWfkLdPA5IknfEPilXmgkMKW6bHSigBp80ywnt5ABKYvYmxxtWVrqkFD87jE2iI+OnlNf1TdlsbsdkdsangOue75PLJAvEFAMqqsHIJbOeJ256pjUZyu53OAmILe1DrotWiznVCblr8cBZSeJieRJPt5UCOZSyBD8ViA3R6bptCUmedC5ua8OEWsepOSk+URytfYai2dponfMe1u9Yae8fyVr1l5k3CWnA/4oC3iMMTi4AiPWiDS/mXPgrBsSfv8rmfJGoz/XRz31nW8Q8LpEcKLuHeqmpWuR+4vTtUGSSuHuxIu8za5FPsNcElvPn32HyBHbHXTzUEHGYnuEou6Purjgst4LQPyjn0zf/7mlVmm6T5gTa9gF5RdkHuKWn2ZuWNbE07Yggan15dSdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have submitted a v2 of the patch based on Ritesh's suggestion.
https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u

Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




