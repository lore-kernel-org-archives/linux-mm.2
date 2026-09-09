Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD64C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92AC6B0092; Wed,  9 Sep 2026 17:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43036B0093; Wed,  9 Sep 2026 17:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32626B0095; Wed,  9 Sep 2026 17:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95DA66B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:02:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D132EA4749
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:02:29 +0000 (UTC)
X-FDA: 85195447218.23.49D568F
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F908180014
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:02:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=nvPxz3C1;
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf06.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=nvPxz3C1;
	dmarc=pass (policy=quarantine) header.from=manguebit.org;
	spf=pass (imf06.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788987748;
	b=8q4macohHAl4JtSOMbqbckCA+XJhqYDkJMkXWyzRjB7l0D30rkC/wtBlShRDK/qt+D0OVY
	VKaqPcdFEoNjbm97mC45JqRyVTNcrl4tqplZ4e6f8kDTFX8fHqqET0yCxU57CXPoTFtJm6
	oInLmBBIOGmiso21HcKGEWTY9UHJ05Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788987748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsW6lJv/Bxdj2Oiz5fJR6QVOHYJCmPAhWfl3TIaVqsE=;
	b=y54iojBJJDp2jm6fsJu877aSZDibUqOZ/1iqVljEZRfavccWhsMNnKHIyhv0uO2a/4t1aw
	z0oDcuhkpdlMWwA/cMKmC3SCbbZ88VfZjH667O2b2KOAM/tsZPF2TlQq7t/WDuwYXklx6D
	8Z0/hkDHVhZNaJJ7SM5N+JmJm0yekpY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XsW6lJv/Bxdj2Oiz5fJR6QVOHYJCmPAhWfl3TIaVqsE=; b=nvPxz3C1HCEzGPmCdRVEArPWdb
	bAiKEoVUeEHWMf10rF39TDfqobn3II5ANtmoNi+bLfojXAY/Dj9TfjWusQtYJUMgcrTXmxeX9jx1w
	RaalzMmKyu4mlaasbHSPzH0BGEergiJtp9KOaB453dEAOXahz96SQ2VmLWzn4xC0Oe0qTqK2iXRYR
	l2g/jkSNsmpt9X7oqdXvZFPVz+mq74UdeKX5LleBRDeXEZAD8k2RK30rkw9KXPJsLgQHpMTrps641
	t5XBovqqp7Y4U7laHq/4g3TA1A4A+twfjM009AdSX7Cw5LsJHRVHkYktJ7vGfKqI4SOQyN+EPMFN1
	s/ZFOktA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4PQq-0000000146Q-3izt;
	Wed, 09 Sep 2026 18:02:12 -0300
Message-ID: <b38953d143e8949d66415c461f46eb68@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>, Matthew Wilcox
 <willy@infradead.org>, Namjae Jeon <linkinjeon@kernel.org>, Marc Dionne
 <marc.dionne@auristor.com>, Stefan Metzmacher <metze@samba.org>, Eric Van
 Hensbergen <ericvh@kernel.org>, Dominique Martinet
 <asmadeus@codewreck.org>, Ilya Dryomov <idryomov@gmail.com>,
 netfs@lists.linux.dev, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v13 8/8] netfs: Set subrequest->source at alloc before
 trace emission
In-Reply-To: <20260909072105.1663687-9-dhowells@redhat.com>
References: <20260909072105.1663687-1-dhowells@redhat.com>
 <20260909072105.1663687-9-dhowells@redhat.com>
Date: Wed, 09 Sep 2026 18:02:12 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F908180014
X-Stat-Signature: hua4id8q3xrf3hs4rc363uxisot5ckcd
X-Rspamd-Server: rspam01
X-HE-Tag: 1788987747-872152
X-HE-Meta: U2FsdGVkX1+palVnH63++S+5y9Emu/smtFE1OcXwE0yuMJPSqj2jNjPPQSBZpNgQAYlkrfBMt6DrPjVADDsSAq6VynpVxWe1aRGkxDT3trt1mPfs49DfhH46+IinZCJS2MqDb0jFX78PFyLzgElRR/aa4jzy9WBx2XBuzBpO2V2wtsjscBz214Zl7JwF+9V3pYjh/Is/ha7CFLep2H4q2PwPSdwa9ok8eHdNP9GSezARC38DJiKdFTNXJpgQxwj02ulfi3/Sxh/oB7nyrfXOu/5josAkGnLjU0jyDccM1s25IOOHWiCT5KvXy3/IzEd9TRE16cpSz0NrkWWUpORyqykIAgNO05SB5NqqEk/MjjMdWXdcbXrIYSGpk5/Vxz+clVw35zKfxSJI2lcO1+RNbDTbdcopExsnLrks4oNEUic1cHIJyBuDFnJbPQJ8lZkMkTLDFtQrHfeVc5qdAQUddwk1bPGlSw8bALqqNd3xevPUtafJ3vJCbDctf+D9LMVV5psioxRe0EagOyW8WLsEHXBCthfhIAyadOictXTdzZzdKEzrBJrA2hGMHXgNrUSHMHutVOydtjSfYCMm7f3sHpbjuCoJHjoVgvJ0bj3uiASt2FwuB8euU/c6EhUdripTj3ebjIizGIjEaDk5GsVCGv/y9tHOo+RHMHOFf1fHxF0A4FJ8BOneYx6E86qqUobIr6tu0vgWYfgabNtsKNpGZrKRqGERaeJNTEsrXJ+w5HncyJJgTrYufMRy7+zPOO2ePpNM9Dmopd4OQs3cP/cUIteSuBLdtw7g8EZMKtYsNecEWQ8SNuORBwcgT/aW9Ond/GJFQ+L6Ne9kWKGr09k1FzMTvx1TlPQ/6JisTTMI9u3qp1CsWLLbSUAv1D8p0rQ440zqV5KOXPcdcK6ZrOlTDFWKjh+s7QfNnVhZ98ROTkfOasfhVpx81wj6jMFnF6/hPUp6uSNIn25qdQG37Ub
 QcP7jnUS
 cmC2QREOBy0NPrJ0TrL8n8Sryg4lIbXCO+C8XhpcNViZVmuBvsUE/8eenF5ncDV1mK+J0oPHKv9FGlYe5fipSy44DYZdV1k3rJs7TGO/1+/f/wTB4EDZrrr++WPwaK50QFnr76MqIfc1qK40D6N0wBczZ/ti4pVXGNzelzUYMl6vCdAFG/fkFYllhUL9lEGierKKCfhvkh9yxTYhrrSXkkBZrXBLSGE7kHAlsKDncHHsB416CwvXZ9187ap40ZGEH+cRDV1DgyE6JicGlf0R2NeWkaXsc30M0cC+dTABkuDCib99dGD1aX6F7aQg5UeUylTG/ccziDDUY48Zk5K1khxfPCIzrxZEoGhq6kScHoDUdRFNcittw7iNlX7vHyK6OTTtLMOPPwLQec3mAszhZZdZ6+Av6oL/ri3QWW+qV7oDo44awU9BFyK+6FO5j48s9SEzM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Howells <dhowells@redhat.com> writes:

> Set subrequest->source in netfs_alloc_subrequest() before we emit the trace
> line indicating we allocated the subrequest.  Note that this requires the
> allocation of the subreq in netfs_read_to_pagecache() to be pushed to after
> the decision about what sort of subreq it should be.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org

Reviewed-by: Paulo Alcantara <pc@manguebit.org>

