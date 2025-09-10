Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4FECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5770D8E0006; Wed, 10 Sep 2025 09:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527BC8E0001; Wed, 10 Sep 2025 09:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417938E0006; Wed, 10 Sep 2025 09:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29AFE8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:56:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 581BABC133
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:56:48 +0000 (UTC)
X-FDA: 83873491296.24.7B84D37
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F108160004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:56:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="bQYnO/VB";
	spf=pass (imf08.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757512606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6za6ztX7suRaul/zgf9vzPbpK/mGuLRtUmptZDqt9E=;
	b=SKekFDww/ocXCFqjMt63t6m2MTuj+c7+AhQtZWrBYN89YMClGJRckYnrgUEDh3/F/QI2z2
	FGr4z5A0sIF6maD16pQRKg8CESob3PXPLZGxlDp2gsVtaU1i0/5qL0vtie6MCvQsRREBQP
	DeeVdqW7wZdeIbZ/wMVP3zHXnoKD45Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757512606; a=rsa-sha256;
	cv=none;
	b=IrzOt4Zn7zRvcQwEdrOTT32v88mczDt0fw7aqXFl7u3x6sFGQzvENObjlPUZb6CgkA6d78
	9he/lUb7GLVNWMSaIsWKlvNPUHZGRI9kb2xguvh5B96Gifde1DtUtvygzKCDBG6Vu+PlY/
	uYIBBEEgj7e2l5qQp1iNgLRaW5Sa0qc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="bQYnO/VB";
	spf=pass (imf08.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cMMgF6vXxz9sNb;
	Wed, 10 Sep 2025 15:56:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757512602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P6za6ztX7suRaul/zgf9vzPbpK/mGuLRtUmptZDqt9E=;
	b=bQYnO/VB4mMKgAWdyfCqgyZNoUqaOGx8f1vprAq8sFU0ImkF/W6PTmi2O+FnXmSED0S+65
	zjR5N5HVYmS7/hMWtn23GdPPQGT4yGeZWtZMONe2RJhQYxJLsZd3T0KvbWTlTCw538J1XL
	bu9SkrfC/F09MpMXyIW30O+PYMnWD2dA3xHubaD9UNNRM9YLEPdXnXnWphqota/FyoH0zM
	FvBrcO6QgT8HllZ2657/PEUi3bMLSfTlMVfWSoSsM/p0kV09soaQXuYU3pK+BIPAtRFkgQ
	SaO2Q43PBJAqa751wMnBosq98p+DdzbxuqfATNMqjtN0/rP05pRrwreCEcXVnw==
Date: Wed, 10 Sep 2025 15:56:34 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] readahead: Add trace points
Message-ID: <4yz5w6vjnqfidjwss5d4ekprx46u6jityq2b3kq5z7imjj5lpn@de3hz3lglonl>
References: <20250909145849.5090-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909145849.5090-2-jack@suse.cz>
X-Stat-Signature: 3ukr8n1koxxb1qi168swcjaf6gikmaob
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F108160004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757512606-882401
X-HE-Meta: U2FsdGVkX1+OfFakedS3IDK/WLSHN/lniG66VJ0/SFOE2Z/8s+06RlHlY1NEmSE6kJuQ03EfXkRLBseG0nOFkPavlnr2An3BI4W/Vl3TNL2SddbRjtxXMbSlEzBUSSDUjNV52wL4JKGc/l7l4uS3vCxFZHrPt2BVWLofVVjyKHpxVSU3hKPi+twIVba/yQa0DA4bVULbCVxHHaM/1c4x/ed0fkP/r0iiVhq5cAwclEl0jaLzMn5lGXtH2CtyEqqx01O0k9OW3oVadHy02u2SEjDxeGhj3uvGUh4TMni98k7rL2LoViqLUmHgJkWjRH6H6jBDHXVL8PYwcFUG6T4RdyffzQY9RMDGCJWIFVtdDj2LmxsfcqHOvd1PPLE9HmLI4ZaYrApY7T+UM/be5kVDVHSSaGst8hCXd21/0kfv6DXvx3z03pGIvnoWuPPW6pQ68HvrSWzmj9/jGmXy9usEB0typPgywjANpl/00uL9fJvW1tIpDOXflUe4oSswPciuJ/DjI1WsfOiLsDK23EqIE2eQKQULBBgTsv7FoFogI0NhXdutII4KkP2wz9sL5GNiIm+YdeaF8GH2C7+pB/vXEkvKuNftsuOrog0bvPmFvsM0N2fzikoojPLNpVkAb/tER4pqqXAVAfyfM5BEIOnaOYmm6mz8aAUZ0ZHLhz1vLiLiCphay3AH8XEE8vqEBIckdHaqND7y2WtcuzydsMCzrBovdo3Jp9kObqexGO47K232jxy7E2jqhjILSQyGHgV6SDiGguqZ01Z31zPhePTZMr5nH9ndz7GPdbWge5Bx5Tk5PCDDR0D0WMBa+ls5qlfqlz8yxJlvcALfvqAUGGlzSaQHo+sOhmE1o+cArET6xMIw5QM7+PR8Fd04ENRm3/5q1mlmmoN97QVs0BeduPe2orIO0s5G9LcZXUal/g2y3DtTKAV6MD+Io0zRykRYqzTzbxJ5Nz97uI4SNOolxgP
 i6Cx6Ofm
 7NrdNVo1y28IWFHVepETZ4md67TxJ/+gA+IgZn1QlfIBdH9wsJz7dDAiw5AVVm/BUB11vWk+1qj7baMatZMtqiRpdH4otf9eyQkxDJvtWJeGCFFYkPYI14k6uu/OoDixhon9GfhVhfKZazDQeQzTLPYxNgpu2Zg0Vp1Ac8ojH7H/lf2yPt2CqiOjACuxufYNHDUGYC68IN2wExMiwXV1plplkEzEMhuvIphF7vxd0k7nmhRJEF+ZjBBMxVwqW1XLxVlh2/07n1RQ3NkAEFsSSGqLKox5dq0zuUADhtheYDLNFqB0rwYni6fXLe3xfZ9WZ1mMd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:58:50PM +0200, Jan Kara wrote:
> Add a couple of trace points to make debugging readahead logic easier.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/trace/events/readahead.h | 132 +++++++++++++++++++++++++++++++
>  mm/readahead.c                   |   8 ++
>  2 files changed, 140 insertions(+)
>  create mode 100644 include/trace/events/readahead.h
> 
> Changes since v1:
> - moved tracepoint from do_page_cache_ra() to page_cache_ra_unbounded() as
>   that is a more standard function.

Looks good.
Tested-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj

