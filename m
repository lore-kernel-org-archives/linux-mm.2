Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEF1FF4934
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 03:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E97F6B0092; Sun, 29 Mar 2026 23:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1A06B0095; Sun, 29 Mar 2026 23:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE986B0096; Sun, 29 Mar 2026 23:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 122716B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:07:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90FFE160711
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:07:10 +0000 (UTC)
X-FDA: 84601243020.07.787A178
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id B298340005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:07:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XDyvwwml;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XDyvwwml;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774840029; a=rsa-sha256;
	cv=none;
	b=la3yEgWaVoJRnq1xbHkX2TsznTOgN40dxggF9iSj0EIm7cZvMjNQnoEer1EcX6Uo4DuV4B
	RUyTKwBXEz7DKgPHY/UdUgtOevVzsc33hRv9alJrsXkP58GlwIdi4OA9+TOtcGnJIPRHmR
	7PiRCat0ckBcZkBI0mNTgUy6Tx0VXMo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774840029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UalHkVycX+NXGkiL0MweP9opAxL7gDSEqcLiRlLhSqM=;
	b=aEuwnkW/pe4IVTF5cueBO+CpPWL/Hz7uDCbcpGFFKe9buMwAqtPYnMrq62QiD8yp3Ruhib
	SzA6uQ6AUeK9JDVYIA8j4rZrPK458vGJxM8bBHajhUrvTvid7FIf7xgqk069NJovd2oJ6g
	0eusu/oQQn6apzLz8E9G0UH2xXAFv1c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774840026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UalHkVycX+NXGkiL0MweP9opAxL7gDSEqcLiRlLhSqM=;
	b=XDyvwwmlZfGPBfumFMNR2CVyXrjtyNVgJFVMtJnq3L0aFHSuQh+LuuUZN2TDg03dwa8Exm
	1Tdez0OnntjgvTkKHubNbH9ehZlReMkFpLHO3+TDcG2oliblem1NJnlEGABA32ODhbc0C/
	SQ2D9YKkJ70TxxnDFRDoH2ohboq3yLY=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 04/10] fs: remove nr_thps from struct address_space
Date: Mon, 30 Mar 2026 11:06:42 +0800
Message-Id: <20260330030642.46972-1-lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-5-ziy@nvidia.com>
References: <20260327014255.2058916-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B298340005
X-Stat-Signature: q851qzzfpbwyiiccnrrd65fm3dnicgww
X-Rspam-User: 
X-HE-Tag: 1774840028-915823
X-HE-Meta: U2FsdGVkX19X8uKAQG/X8bH/FK4+BGbWSARPdVWQ0FEnRmWi7EmVSjl2rVwHRypDp0n21wFi1ArIBWWwseLSZWuGwaNzwfkL7aKGsUx5mGKe5vJziUvH4soe80hE0yK1UyeCjtXvy6OtGkuQ8Mx81w/fjzMH0mtRrQpB6F2f/xTCYmjyKzl7U4nryo0g4KrJjpZHGs6lZA/hyL7Z0OtksWwifjpKUIs3tSveSiidEDOBCmAH4OXaexF0F4IKRmfU0t0imipJ5Qg3eYX8Tl/KUi+eyr4NuEtNfVDlH4zsBfaXx6a/JZOiXASrZ6xVbbJQDPK1Vl8Uhm7LxuLkNdZtPqKhUFfQlqBhvdIN0xYrdulBUubYgVkwZrUBWEbwFfMO9pYMy+9X8Th7opHYuVr0uh9Q0coja2LtGTdZcZNP3q7ongJAu2IY/Q0IWUuXZGZAUBiBhh20wyYLYKjuOhsyeBx9Bc4Qp45v/ZtAvgRWWAMCjc/EEihkYDF9SqVMW7xyHwS/uq2fvG7zqpduTY2TFgJByrEFaSOUJq6bbFTsc1i1srFXaAqoZr9llkSZRfJcIyS7Svl9SvZEMc06bdw8fcC3JvNt+1Vo/lf58kPzWx0d3pKxZRHW3JaKVg/iwELfANw2ZaP5/DsxNZ5XdwJpxc4b5wqN5L+rKXVT+cQrGIfM3NOmACBG+mAcmYKlC2o8mAavLAGGlD4MbbBVkvYlLFxDld8d6rN+IKTFBR++qIzdBly0AsOKkcOqJvmTS2gkoIzYD/XxbGDMssrUEXP6BS43uJ3AWBjQxReC/5Z7cMlO424VbZz9kRRTv0BAV4EhRiBnp8Fc2Z7HyJ3rJQp6EVXTZQ1j5IDIy2jT81ogSHulX4g4/3Dh4AT3gugjTHTJeDh+dDApQhEHXjeZrm50KFO0krbsvp2KsBPk3gBM5wKXiazPFOI9wOrqpPHJDixdCYr856TrX1JhqX2ztin
 pdLgOpsF
 2lXzRbAAG19FWZIp1XMNnNILdvSo3V0/7Gal+aUMT4ZxOTdCVjJyzYZ0i3GiqzA2Z4RjnfeBZx+15nuV2Z4wh50BmirvGPzWQQxZ+KafTG0AzL+j3c4vXiOlWhbIar8AIL2K9DdzDdEIvGsxK4jvysWJCArtjxDMNZW+RL9BjHIFk26J/1nmwC2uCdsVYIPdjA1bBNCq9gEGPnNvqbk72pwFTlcpWO0SP43it0NgqPO8GEFHJwZBx25+9aPPjE1G34O9ceOiEX4A7yy8wf4R70nGXsVInN+LHrw0OhyXs0Kj3dIfM0YMQFq/fkGtnYk5ZtpvuaBRnSek4h9+1RM9kDYKwZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Mar 26, 2026 at 09:42:49PM -0400, Zi Yan wrote:
>filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
>is no longer needed. Remove it.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

