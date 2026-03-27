Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C17E210BA430
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360DF6B0096; Fri, 27 Mar 2026 02:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316E66B0098; Fri, 27 Mar 2026 02:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227F46B0099; Fri, 27 Mar 2026 02:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1316B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:11:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7A3D1B9313
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:11:10 +0000 (UTC)
X-FDA: 84590820300.16.D7DC0C9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1829F180002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:11:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1QGou0Un;
	spf=none (imf16.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774591869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Pefj2SK0R4pgUVF/B3ymt/ORF7baBxw+/NkCgKEAxjPj6917wYgFdk4DVANjm+GT/06cDh
	IYOSvWLDbDCKZ6Z55tsgOJRTffQcwfk6wA4OwG9cCdEAhw9fS3BwPDl2mNhLPDhVNPRBpg
	ghiaI0OoW1vOiNUqECBYi94Fc5xi1fQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1QGou0Un;
	spf=none (imf16.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774591869; a=rsa-sha256;
	cv=none;
	b=jy4n5B1PcYmDyR1Q0CmV+ApGLTgye+8dK4E5fRD0kdDOuwWp93vrNyAc4bLvfNmyfWzi51
	YycTcUTLvArMXb7aQ2VwzoId+WmNRI8ZDuVu9C5VG6PvzHGtJ4mc0kjF7wpo03IK2gJY7d
	mK8XAKe3nnfPXlXi3aYlNmvnioVZPHU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1QGou0UnUgt5Kn1tS8XmgPeJ5t
	jwk4VtKUYMIHyAo9v8y5cC295kkfOj0IAWUE7TV8fAU9IXqjpDvWRP37iKFW31Fqh9cle0FpItJx4
	Yz4kkWOK0XImvDZK9XonPvbzAs5Uo0A+t1tiZ5Y77MnxRaTWM2v7ZSpnExlrQ/flfkgSYOrl7BEP/
	PUjHw0vHaHEKs+Hu9B33VZK8sT8PgIPb3J59+TLfYa/4zNqw8mNlwy62P6jfBjUMBH/+IsG6cxokq
	tBV6Db++j2R2bvEfNPD1uZ6fCmZtl9OY56diFKtVWHdTYADzHB1qRzB19tmb/dGdkevPjazOJOeiD
	VEoLi/Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60PS-00000006k1p-3B6y;
	Fri, 27 Mar 2026 06:11:06 +0000
Date: Thu, 26 Mar 2026 23:11:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, hch@infradead.org,
	hannes@cmpxchg.org, willy@infradead.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reinstate unconditional writeback start in
 balance_dirty_pages()
Message-ID: <acYfep_yPp_Gg_-d@infradead.org>
References: <20260326215127.3857682-1-joannelkoong@gmail.com>
 <20260326215127.3857682-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326215127.3857682-2-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 1829F180002
X-Stat-Signature: zpwttugk6dkrmqmdcg898awkqhsh4ufj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774591868-829641
X-HE-Meta: U2FsdGVkX19+FDZ9JaI2+XF7oQS0aRz4lqHoEnZSaykOqbuZxolX8cjp1FJc3XJziSc3gcabgrceB59ZYeYjcfEZdZ8tkKFtZ6QI9ZUky55NG47LDIE4h3TZLpRN5G2LKvfwAxmlvYCXUhMOMl/LoYmlkY3dHwgCSjtZPixfMYjQ769Rlaxe08pF9Og/B+ar8LIRfXq+dQ9quu8qPjuhvcbXUFQfAVc53jQHVOFTxqu2qd7sYy01qSpWydh+60AG4gV9xPLK0dQDAFPxLrWIvAeAX/VfUUeZht3qCSxy5+9oY5KXCmt+xm6QjnmrKvAYYOvVT9u0TJMsxzfByxSiphjIa/OpAGtJcBuRaW0Sbk6C32KGzq7Bm3rkp8XomriU2E6UjBx6d3Vdp5pxtIfaCa7Ny5APqW/UePSC8Cd1pEJvMWTXHjEfyXmZN2iir1BJ9RsMb67sV2kyUtONTIv4sQSW7zRHgiO10OER7qJkfwvj3nMs8nrBmDOsMApRdC3uY6Siq9NxJF/d9doYL4X1IGZJ9t/j5luG1xTckvxxhc28xufcou1qIQ9v3Pl5XyiI+IMDqUvN3Y7TMHGYyivcJgerwyMuEfZuwsy8c6zOYBwy/jDKcmj2usfCbKrtCs2ufH+SlMyUxtnRIKuI8U9Kp0e9bC/SK5yqjWBaU87sytt3PevRiP2tHrhMlhbPn/S8jJwLO2WM3bFPVj3rry/HnQ5DZYNRvTLI+0uTCxqnX2tfc+EuQvHihHADluXfvXlBngClOXpGEN6SCRjq5nUrQzpSHhDrB5OkCpAerUCXoiD9fX9R7WbTNLpCGpIyn2u/CZ2V1ihoIUtAgEL5RLayfACUwuPebRbmwarXn7WQQRdwwJ9ozs/+U7TibBuYAzeLlQiUR45bEManFVevujTPl7iMmxYcLUlsfqsgdpJdBFY5n/5pfemiusYUdONzG6NEE8y2SrBY20XoVdoO1Qa
 tHypFVa6
 8uAkGV1ZthYjCDAg+2qTMKSeXfDpP0TZlN5w3hUbIF/P/CW72QzV088+aY/MXI0QhTUMyin4zZByYik/oYcX4pbX2fAZml2NZVVUeJ/gEHiIxpA9DSDUDIiYSCQp8iK1ox/QtmYHZzTEfOFqVrx0QPq7OjczyVgGe11K/+3uFLt1mNzpMFJMPIzySXsmYtJjJicc31OM1oDHkIqT9MBBDybKkJJD5FjUeuJG1VfgeCNeQwsRwp8P+XqAoVC1Fy0tOZYBVvdZJ0pm/H9SkzvLNLTEniJ0M4GI2XNV6oYYDODH5VkSv9Iw1EAGcbzaxdU25OMVlJO0BRmc2DXvcureIiEK62rDU1ZLcWb80yUSeu5t/yVBVJwsUHxhwceKQtsgQv5LW7+74fM5TRINbqO7WfSKRx/rj/WIWsoxFheqyxLBHyclANeCToLX3d1QG+LDtLzF7yvFnLHvgmku5J2ZDDoopJY79VojF+QqDlL3iV4+AAdIb6Zzj35C3rlturFbSGQbb/8oxLHM6QBU/DUU12dB2jJcK628MAItocQ1G/50ah78Y7ljD5TOiru0YRx7WQ5wMNsHa7uyju9TWb+RIKT3lhFNjB+tXzc2BrCNRk8Xr0p5YICh4FwvblMJBFiAZkE8U3uHhT5h8X47/LUi5KUHoge/eJM9ipAArRFuWi86gynKvGME3YP+7zz383ZGF0E2xGGBmZsjM5yF22Dpr9xniILwiaC5yZU1w7qQCOMQv0pF/K1x8w31BqHaSJEd536On
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


