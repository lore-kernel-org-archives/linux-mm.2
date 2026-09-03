Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAC1C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31E06B00CE; Thu,  3 Sep 2026 02:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2556B00D0; Thu,  3 Sep 2026 02:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C202E6B00D1; Thu,  3 Sep 2026 02:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A43FF6B00CE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:59:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 488D71C215D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:59:23 +0000 (UTC)
X-FDA: 85171549806.24.1A71F46
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2065914000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:59:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788418761;
	b=n7QmOY0Faa1rItzkYJn1BFMEtOH0JrpFXxnGuSq1TLKqaFWJ43vZPJH73toCjt2uuj+0fp
	5BCH3rLKa1vGAwHBSGmXaR7l81mzOH5PPGXrIPh9cjUoCw5KSPF1z3St46jnDeK6vwfSlz
	PC0uKHTThGsBPyC+EIU++1lSucE31y8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788418761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lxQxEDfiaoKYbR38AIjJMwZX2O1XFDRVDm5Ydf4g3WY=;
	b=rXeq9MnHhBqIHjBTOvqjpNm/7FjQm1RcDkvL9ohjQdXeUZC5MzuD9uWSrVIntc0gAZJ7fN
	2tmLwPwxeVmjsSu0Nz9TSGa+Utw/e/rYYa7C9qMdFC1f9POKsJaB8pAvL9dEiKINsW3iQB
	52cxfjGC8T6HMYxXZLVKN42I3v4AoPA=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.51 with ESMTP; 3 Sep 2026 15:59:16 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 3 Sep 2026 15:59:16 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 3 Sep 2026 15:59:16 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org,
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] mm, swap: refactor swapoff + add xswap_destroy
Message-ID: <apkaxIJRdo4zwnS1@yjaykim-PowerEdge-T330>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-15-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827094509.1016740-15-hebaoquan@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: gdt15occoc5rmuejp6n1ukywshmfyc54
X-Rspamd-Queue-Id: 2065914000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788418759-547225
X-HE-Meta: U2FsdGVkX1/yrm/gRDdw7LHqBKIh9eHKN0/TYHGtzramtIMApegoVcOrtvBoxpojefJ8TPNxAniiGEe9f92WsIG9S4l/v00QfxcFGee+oXZEKqnPEnvar5y1KmzO9T8vmklqz9WnnIBZUVjeed9WbA6CWVldRYyuLUtFm+Ay7s5c4TmX9oKaoKNLPBbNnk4NR5DhZUaZZckV+VIfNPZuZBkiCfPG0/2qnJN6PIg8qbwwBQCEEJ9/Tc5ckIGBipgbrCPdbWDkGqAWiDIUDwiH679kM742+fmkdvwBhJBdYru2mROGnOB8BxBNNWH+kUwzBPzehGEgm30I1KRlGbE7zVGUsn0LVr3kD0RfHbJEqFROO0LUp4dtO2FLb6wEc8bGl8TFWqXsWxwRfgO3Z3LJ8wDXxK6raXr1ouL5K2EbhlWqNA8l5tdtb47mn8ZNdKH02wkhg0jzsepT0iZDZ03dk7v/tkKGWzcJQG0Z3ofVzwN3xs23X3AXvLosKAI2ClA/ZvffyNPgAcbsB4hLHFuL2t9GPgl+VZ1vYSx7hO3GS6cSbrzeVZDt3t46Srp1jWngB9QOE6CFUAjYEb1cjiXlfuUVVVOlfD6Cbos5aYzOeRAD2gCGSVioHsoqDHvoGKm67GEMGVaHoh75ZN63UB2o8tBVzmoVOylb0sAPBvf/Lqft87qbCM6BnLlEFTEms0D4Jj7iPmWTDr2fNTFiFV3oeqG4TM7TXv7S0ME27umIvwaJrexaAGlDjPLo5RmqZlJB2OWVavl6Cgn/p85qZnjQ7U3n7gcXl2mil435aiBQP8TAdJyEnh9kGprAYV8HbChfJoiLY4qIRs4oyTTFd0ZXavowV7A39sYEt7aFaLdQyoSE9LcJdXVOlIDcpneojrOzXnTjUbJKNrleBTInFod88L8gXco++J3XMLR68Jd0OBwRhhBK4kq4LomiIFZCf9g/+wLpRbvsae1y4i+39fU
 afjqkVUs
 nx38WKGTAx14rB2k9DS20IY5o7gUXPxLjWuO9xT1h2fMkq2jRD3GS3ql+rjsXXzGn5SjT5oR6Uf51ny0EyoQ0tUGvwAXtRRRfWnA+uhWxmVuiJ/ySOKOE2IDS4zyaXzHDSQ3bb/D0pmbH0LDi2K55+NZPteoAMkFTh1bEkObxoip9ObrHgGtN4QYnfgwP15ro9NBFeZL0zuPVM1FSSiTx6fPMutxwy8G4StRZnisYhIDu9Fk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:45:04PM +0800, Baoquan He wrote:
> +/* Tear down a file-less xswap device by its swap type. */
> +static int xswap_destroy(int type)
> +{
> +	struct swap_info_struct *p;
> +
> +	p = swap_type_to_info(type);
> +	if (!p)
> +		return -EINVAL;
> +
> +	spin_lock(&swap_lock);
> +	if (!(p->flags & SWP_WRITEOK) || !(p->flags & SWP_XSWAP)) {
> +		spin_unlock(&swap_lock);
> +		return -EINVAL;
> +	}
> +	/* Refuse swapoff while the device is pinned for hibernation */
> +	if (p->flags & SWP_HIBERNATION) {
> +		spin_unlock(&swap_lock);
> +		return -EBUSY;
> +	}

non-blockfile swap device must not be chosen for Hibernation.
There is no space to hibernate.

Thanks
Youngjun


