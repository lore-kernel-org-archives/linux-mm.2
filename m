Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7B6CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181868E0005; Wed, 24 Sep 2025 22:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132A98E0001; Wed, 24 Sep 2025 22:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020458E0005; Wed, 24 Sep 2025 22:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3F5F8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:24:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DB0DC0279
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:24:53 +0000 (UTC)
X-FDA: 83926179666.08.D2D208F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7866740007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:24:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jz8NnfHD;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758767091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vV7SeQe5bJcPSRrtuQ0g5RH1V/7g70vqU608ct6DKYo=;
	b=WUoWDuS8s1HFQZW0pHpnx8q0ZEfmjEV8gDcrvQxEAqHWvqjq/C4q5xeNseSA8klK4c8Ow3
	uvh7joevJcllhu4J9YgnRrHWfYeSpZYsEjD04m602pw7NKV+7i8VRW4FrjyFMk+9kQCkb0
	BUIpTsLZK5RqCmrjxDArDT6m8Rrrrq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758767091; a=rsa-sha256;
	cv=none;
	b=TK+UKl5NtpPUQVEMhsDez2aCbmFnRLJ/agrkPWluLDvLMub9svk+MMxmYRfaFr32FnRcX6
	I9X25hnlFXKfn94rcxdyCPP5rqJ9BeK7l2QiZgaKM4Xrdl2nA89t92XW8KDqQk10sATq79
	z4NSAYQ2Oxyu1zA3GPQd4dkjLFA7taA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jz8NnfHD;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758767090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vV7SeQe5bJcPSRrtuQ0g5RH1V/7g70vqU608ct6DKYo=;
	b=Jz8NnfHDsXQoAzOLhrEVX4KwIR85EDecZPO+yrKFvKG3f4KKw+2eyn+Yvsb1saRed4JCy9
	JmtFaGoXDio0RRtNdU9IrTE5MUgPXu3rtDqccBN7v/hAsUEcpiHGrVeYy/kvv7LmfcZtk5
	tqMrszUc+PAmoexiZqx+3/Ad/uXzNn4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-TFIotD8qO7eeUqtGOPNXoQ-1; Wed,
 24 Sep 2025 22:24:47 -0400
X-MC-Unique: TFIotD8qO7eeUqtGOPNXoQ-1
X-Mimecast-MFC-AGG-ID: TFIotD8qO7eeUqtGOPNXoQ_1758767086
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BD46180048E;
	Thu, 25 Sep 2025 02:24:45 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C34F1955F19;
	Thu, 25 Sep 2025 02:24:42 +0000 (UTC)
Date: Thu, 25 Sep 2025 10:24:39 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNSn5/PENA59ZLt8@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <aNQRLGWlORrIpPmg@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aNQRLGWlORrIpPmg@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XaD5DuYKjYiQJAqmSMW6j6ZTs1No5qJZ4gZC1KHGWrU_1758767086
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7866740007
X-Stat-Signature: 5i1f3m5r5cj9k8k7u43qgep3kmq84h9q
X-Rspam-User: 
X-HE-Tag: 1758767091-937237
X-HE-Meta: U2FsdGVkX19u8vMCj9L4ceSt6giVsIVQx1UfClr0RO8jtv2QHxdgSfFz64u2oUvHJpiJjD5rrmrWzSXMu/Iqa9h2sNDPzRgvIeySqWngdngGCZkkT22d/BPZCOH181CcM9tGD+va45mWXRKU2sCXjwYR6o7r0I/tgBCSEBWFCE5PMiYfmdK5TlwLHagpzVDbWdmJ1giEtMBNeRQ6t0XNztpqQPXHgBH+m20Epv/MCdDzz4Z1SNOWJ/q7IUpcgNxW1SR9ikoywkvdfGTvgekRRcEmgE51RiVktuo7GUqLueVOLzK7bqxjGD1nT9y++Cr1EApxJxecKOM6IuyRdZGwnY9QAh8pU63/lZfykj9ltIRvj0kITfvx9U/cyDUxYf3kMKBTCaVu8Josbz7IUvDsZXsRlI5TR7aiT+/yCw4jLJuV1KUW+pTnq2MbSp2OFrzGEL449Q2uEV64yGtSaTfNW4X/4uMeWJv0f8upCo5rwgvMMMq6fzR6aeqqb4mwFoJBpeGhEo+STKQklP7tZ2uT1YGucR3WW/fhSQ88dQXK/zEco/jKnF3C4u9Sk3D8mhLIZDZKgk8DxQIiOpFzesbdprABFEU1HXp6ISBSpXXwn5mRZ2M9k4Up2rMkf0sjJP9kGk9ejuUNofwmrWx55XJtHWPCQHVuIRPZLPmwvWueHZenALVCsFt642Npzh46KnHGuyLo2X46mWMLsyUDpCkNnKhXKYqh+OrniXQnXd5sDh//pLMr4hICFui4eD13/18DwvO+yksWRKw4gALlXRC/vc24KzlEgJc382EizR4Sx0Qs2fMClR3ow09KGHwl9vVl2gKp+sAwzrIRN9GytGllGHDMsSKwOW+rAkx1g5wCp/rr6K0vOJd06aMI55tt7e1qNTx75XRUSlr0dJYOJfSUPuj3r94rqZbkPnhOmUxQFgtAnKEPKvbs/EXLTcewW5ZR7RZFDfgFUiDfuGHMSMp
 2qGLjkcQ
 AX3UNsmSp7IVXm1eijiEELlez7ybbvlIco0ibiyAiCFv0rBD3V0ihiahgTlA+gefZT9gdEdXam5ITx1/bEf/Q4I6WgDW8zJDPQ/tAMpnU58EkuB18e129RVhi1Yy5UYRMStrP3j56cqZP04o5xZA/xplc9rq82m6z82BhVU//mIDdU4rGwFtEOeOnnezm3P0Qj/wFFAOOO81rRFaR7JK/DT2vqqhzgblf556he5k+sn2ZiaPCdJ4QFWHaugZoszRYPoOX7tMIbryUfunqzXsnVK6V8AnfzrH3cZi9JFHQyJ/9iZ+fwDxo4/Nx5+/G6THwkqVX2IfmcQtfl7MWJo9oBnbk36mqKaI7Wx6Tdd57hU0Z+oEIJTH/mOFTSERU81VInG/GsuqpJ0aOf1C1ECXi7+wEXvi9ddv9NUuR81Dc0E7Es7mIl3KqZ7uSwVsImzvjjSFkZtDgHNomVrk258gSPN3xEV29Zh+fsQ8XoWiGiZjV2ZPYF71wmj8blCMFo5oM3/JXho3eenERo4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 12:41am, YoungJun Park wrote:
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/swap.h | 11 +-----
> >  mm/swapfile.c        | 94 +++++++-------------------------------------
> >  2 files changed, 16 insertions(+), 89 deletions(-)
> Hi Baoquan He,
> 
> Thanks for working on this patch.  
> Shouldn’t `Documentation/admin-guide/mm/swap_numa.rst` 
> also be removed as part of this change?

Right, will remove it in v2. Thanks a lot.


