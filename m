Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88B7CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED126B0092; Mon,  5 Oct 2026 04:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DDE6B0093; Mon,  5 Oct 2026 04:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4386B0095; Mon,  5 Oct 2026 04:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42BD16B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:44:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99E771C0C4F
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:44:16 +0000 (UTC)
X-FDA: 85287935712.29.C78481A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf17.hostedemail.com (Postfix) with ESMTP id D29D640009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:44:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791189855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=iY+gfYaWeyufkz9ZU6P1FXV18dVQvG3KSGJHQEnplPxSkxS/OnkRkSK2qI/5qzCqW4dz2D
	AkRqnuHJSSJ/GURLys8GGQoqFixDs4quxuwerg4JE0DZv+ew6KYH9Exyn6BbIl0HijyQWy
	yA8IcTP2bi9A4b1DQj+ILUvObSf4y8s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791189855;
	b=KoTNaNBjAPl8Q9FgjcdCueZeTntZ6jsM9f7uEL9qMRCJNPGzk9j0RQ62KF2dJTbgQDkQqs
	ltbhJdOdKhNgDfP+bfz076bPheX7YeJXaEq2YAT0kdfuzmQ0bLl7KcD0+tiWwmrNHOtQ2m
	wDdViUxVK8ii+cpgalsThONfUdpBpHE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id DE97468BFE; Mon,  5 Oct 2026 10:44:09 +0200 (CEST)
Date: Mon, 5 Oct 2026 10:44:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: submit the last readahead batch before
 unplugging
Message-ID: <20261005084409.GC8692@lst.de>
References: <20261001085730.2029773-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001085730.2029773-1-alex@ghiti.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: D29D640009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ba1iw7q431beed6b68wcn477h19uoyng
X-HE-Tag: 1791189854-506098
X-HE-Meta: U2FsdGVkX18aD/KV8n7tz4vK1iqQEKQwN64rql9qciDaofX+/aqe1DueKc3+6+ef1sblGnIQd6KbIV65YJxQqMeo/yT7UaNTOqRfmf7Qq6GVPOCYrpLVhkHGBPTu2lNs2ue27com9iRInjae4dKQsyCO1b5YRyohlHAHZ3xXApafYPvGet8E074qRHmvjNuSbcqfvkFUavDtbyDjbVwJ8kYID3olHpen4RnKiFnrlbSdWLl2edf/Fhr9iVl8w4NpPYjI635MuQ9hJjM09e2yqYHdcNAburi11C6lDbpof7DBe07l5QLhQwjXFMNwUKsuCFV7ybLO/eKBEUQ9WZo2JbVzI3eNcmYGx9DiJou9bXDrzoUUIUh9Gg/nxqVwDZw13atipsoptZnKFHYjl39+8jrkjzx8MQ2kmxzJs48B0z4qs37eoDxz1WHR+XSRq++itY2vDYLBPKplQ++xIj+NN3OVGryXsvwPWk5HKBVNJ9jw+OyqGPkUWNf4Wor7npMLfPZPxfaP0mhKPWcYXKdIuhRc5rr99/vQBlQXcvP83URd91c9J0OILc70LVbvtAuotfXKqkciHJDKlOKkfI/uSkYjPUx1krn0SYu+QijiZDONeAr/sZ8YmROQDtuOAuYsqhZZzC7rJizS92d0BA0eLoB8TML+POBfm8W0HPEvyPBTV/rIFkTOvgHYJv94lOITGMPJjru3z+GtYNWV9ErkqWVBSCYpdYDs9FaIWub2N4+qdlCsZcmigGlApJmMktPhLHDHIEO1K0AMcvSbaYc0MCxs5dE9mDesucUpjjsYNthcN/UAIuAECEsE+w1DflbQ+UteVaU9wmHhzFaeSbKbL6e79csMZQiv+S31XZJ6xx4HwWDPelHKWrA2nEtIm6RBRYBOKNDtyaDXzZbmKK2bJtdBQ8zTMWGBikcp7QUOsFJ607zL+3xkSr4Vfl73to1ZYbIaywWIMS42JwOqpZv
 ynbMEnE7
 AWwejQ0Oui7ppVjGIT/IcRChgrREnXbaDc8BAOzKrQJT2mGXJuvu6vmU0a3T5Q47CDBMbL6Ncg5IheUqPX15pEOvzin4u2FoxU4KGwwJEpswulBoMLIBLokAGLCXUZF+Q0XLLoSkkbLAWbBkZnLpEl2K/mloiqEWbIGsnbSNRz3rrNGkOlst7dNzl8jRDng8gfxKlD0NGXV3/NxElGKn88OsDO/hABOUH7ZTAtb77VQyyJsTQYuQQIUDpddklEShu43ApBM0vf4Nkz5Hh2qe6IEhn3vMltKxr5HeXP5eUipB49oITz76LkntJaat4uuJfE96ijeO8GSdLcUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


