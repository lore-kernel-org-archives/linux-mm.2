Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D5E10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD1B6B00A1; Fri, 27 Mar 2026 02:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2606D6B00A0; Fri, 27 Mar 2026 02:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176E26B00A1; Fri, 27 Mar 2026 02:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05D266B00A3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:23:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C34FE140FF1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:23:36 +0000 (UTC)
X-FDA: 84590851632.03.177D3C0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BA77A0006;
	Fri, 27 Mar 2026 06:23:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=P3sPArVw;
	spf=none (imf15.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=CLnwr8jymtvGZuSwEJNsT6xHoD2Bq1dz2vAMKeVb/TQrBKZ20Wm/9JZmRXacrzp5wB8g+v
	uN/AwoZTzq0cx4swCefa8//9AjTUMxauUyODfXB2shcgDYcAfiENdTNRSuFwSv4VyZkdcZ
	4xNDr4/DvEllGg2eW70DOIjm7nAtNBY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=P3sPArVw;
	spf=none (imf15.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592615; a=rsa-sha256;
	cv=none;
	b=PwOA5sU+oywLzu8A856EFg+ZLhdB4OqpjS0oQTWw3rumr8OTs2gPL53/Xp2h3rgtcZC7HN
	wVpI+F0vzz3jxO0wAiPFz2MbyBqj6aTWjiqkRw1k3IDSVhoN9jfGrir8UGf27UT8H3mqwo
	1FA00/LYL/Zcg7E4pmXxrqHV5gpzlkA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P3sPArVwhQ8WCAYNEEG9YJ/BHS
	tukoQVz92DHL8dl26nQWozXziiF0y9T0hKiG+IaeR67Al2gNp8G72Ds+JZpr06YB/YfYzayz7AvF/
	iDNfMAnVWDVidH793xF8yWOYbrLo+9W32KV/6TILxtzqTBUWFnlSEVARs5MPS4IkduCDaHdUHM6yw
	uvNGH/nB2wfx+/5nDD90OO/Nc3ZBrzjDC23sZVcdHX6UpnR2yFrqpp8wOeLXn803mQGCbSTffl4jg
	2tjb26IySD6C+FDxjdZmDVCvh5kK/p1TZJn10nBpob3AWirZAiloUvqLgwBKlEo/TOJFAI22OP574
	HcMB/pRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60bS-00000006oN7-3iTK;
	Fri, 27 Mar 2026 06:23:30 +0000
Date: Thu, 26 Mar 2026 23:23:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 33/42] fs: Provide functions for handling
 mapping_metadata_bhs directly
Message-ID: <acYiYqpnz6WRDAxF@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-75-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-75-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 9BA77A0006
X-Stat-Signature: 6smykzo186scp1ixc1upcaixmzcgnks9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774592614-44056
X-HE-Meta: U2FsdGVkX19pKkJkD8na2Nrq2U8hkaMQTvnRKC335l9DbcscPSxCGx9tTBx1G1SRFzjfQBFV85VsdOKCjIbvmQsuEfMYYvFyiXos9wd19l2GQD1lZadj5JXo06DfT4wTYd4zlBcMfK6o2twHA7Z4nKHu5f/ZmhMKFawIiZ5dI7W/Vye19414QPZZZ5AbT2J0O/rcfAecNkNGE5eh5BI1PN+BtxE0quBcPNianCmoR3VI/xLX/bfdoW/XiU4c+YWC5LLMDHj/svYhqVcpGBVk//Ms3nPL4wW/6y++d7qauA/IbPOFtz6deDeSQf44rXaOxoPnjGdwg0dwfdGwjiXWTMvhk+Y3ZJ80Je4ltGMLTEV5F68+mvqDzYZFNkZDxthTN6HyPPfGE2ohRHcch1liIujRT0tWph4PvkcK8xBngD2Mm+t4pMX9JeO0AicTQRQZkRrCibo1P4B4ErQU1KFOhPMsU7obPqTQ8Ij9xG0jF21qm3dz9IjJ+xLM1BxzPiVvNPRYPzLxL59nlowJ8lCMkic6DfSvdN+nA3iEfsc0E7h4Y4NFimYqnuIWY4daahy6LwOwdEwtb1gXOlvh9Pm9KaOhHj5BId4lhwL8iIerPoaOxQ89j622BexuaVXoZh/wx3NW8vOISPStTEUHvmonKiUWJg8mTVEi9G9CkJZMwFWMpcBB15Lk+B7pBorvhdu4x11MikHNMfp2fksug2tyPGfj6yUhQO4yoQcZTVf+KwCDIlQpxYp/5PI8EkBU0BdxH+yqqGAsDXses+s0q3dsEHiR0h3hUOch4KciSrEyciriwQjG1E0FU7Vn9WLB2XuTmYU7yhF6TvOlzZoZV0BbqWEktUpq+FvOWyRLApa4WiE1dMmMugN+3tVQtrYGlddU4lL/SZOXVcBGQP7oCTPYSw4n8uGlzZeUUI1no0fddQzWYiXRiu9UbfXEyrbYAAhZO2SotyuJLdAddCvG7Iv
 vHPuz2rx
 2xKsHjvKry9uBV8HqqSrWiYchwXetkdBnWcQ9KEoQeoSui40Tr8OMPwGpV3+hFYSF9kNz/J5wM3YmAOI0u+Ad4Hh0JT/e9Aga3OQAeplm3MpV71ChoKDdY3/LySQydVIo5ZfTIwLhGZmiVlZRQcRXmVe1URJbJMV9HJQGj+VQvd1+S1S2LiZqgWvwZsijUcZvNX6w/Z0AAZRcBDn8Mhan7PcoCnJ0Q13VO6dI9Ti9Jax5WF3RZtGZgXB0tU6Cnb6t9Am6vsBZaqk66T22rpgZLTmGMcBVllKUQTSydE/sBJEAgWCfZylhwmUBdTBQD4ISP2Ca8bVSmbglsV3jdQqpy5h/YU9VsV/Sd1zNkFGlfIaPixOgUlfJmlb9DC+RI4fcURIIhqIybV0LimcYPRIiFtTI6jSOE/r8N0DNbf10w4zntfBeVBojUCVQhEj0jP5KvIsgft9/0PlS90b0L+P3WRFtF7Zqsb9eLcCGB1RNpKYU7BqqaHcczp2aIkW7IvOBJGUjQJ97EkDR+eVPTxxKi3EoTNu/VOnwqNfBShrtKFKIT1kYo0h5WRI7+Rt+o8kyQmNojlZSZcxE7UmMBy0FeHvyM3+IYzZuVAw20y23VbY+0Vnr7n/mzsPNFram0bnvEUJBywXxls/SPy7Sej8I2ExzirNa4LNwpi7nXPlYUFrXeTzx4eUMh2Dq5w+S6cN6y1tkoSRfNG4rIy2nAJseCl6k8evGx5ZxEW8oX25qtLeriHQmJmdPeaeWZlCi5gnMXVaZyCasISP3jHeLEyPbZWJI8ld+koFY03N6ZxPX2bDMrB/VjVvvgL6GMQImzyBGElX5BGNBOCqPIXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


