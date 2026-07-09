Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABD1C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224916B0099; Thu,  9 Jul 2026 02:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADF76B009B; Thu,  9 Jul 2026 02:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F366B009D; Thu,  9 Jul 2026 02:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD0526B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:22:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B96E1203FE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:48 +0000 (UTC)
X-FDA: 84968244816.30.C26D8C3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3042A160003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="TxLl8m/b";
	spf=none (imf08.hostedemail.com: domain of BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAywz+hiKhqdw365nIbaeBzJ8UbXeVL7JDmIYJCVkAk=;
	b=PuxskgdQKdg7s6hbS/L2azFe1S/+JzttZKy7SVmmGzYIUEsOK0so7XGY286Iy6NjmfEcNL
	s1+k+gbjss98eps26v0UXkaexYzqOzUn1nuVOdnf2pVNywOHjtOyLLqy0Qkk01eymipF/8
	w5NVldNrN6TgiHjaxwElQbkXDcsluMg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="TxLl8m/b";
	spf=none (imf08.hostedemail.com: domain of BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3c9ebaaf6e714a689196+8355+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578166;
	b=ESusreEPpdSMITVaZsZZ55QgLr/znJ1RNACqOHZiEJa/CaeJykPl9KrS/ySdNRIiyVPl07
	eu4Fbbg+c3KDQtIY2BH6wKN8s0TO40SnGxT90jSvqio4WsELNiFEMQsyf1kdc3IWy+q4MX
	XvIMVcmE6iVo47tBajfhQmIH2QUqiCk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EAywz+hiKhqdw365nIbaeBzJ8UbXeVL7JDmIYJCVkAk=; b=TxLl8m/b9FuKBBioATGr0g8hzp
	WrjGhfz3c/eOmAJLe5S2Q4U11NzwhPtVLyi27gacDu1LoS1TzQc61S4qhG3JFfnlkCJApCkPhRxHP
	Q8lhx/csYNltvaul4EjL8c/sva/D9sy7c14WrBJ/7dBLYmpojI63mS8LoOiZmtobLEh4vVzGMyU9R
	zL1wT+v1JJ6InCDtFt9/hl3Iz7he/vxNfmEzHi+4vMiwBR+RORO4pDbnh7yxrvA/6k2/CdpK+8e92
	m+V+AAgPyspgJQHUH5vgo55JELAj+ecYzqwcQ1SroaZ4U2v9uz8pAK8VLDBRpyXlfKnMIioel51ac
	zr4pvyig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whi9k-000000018tH-2Kd7;
	Thu, 09 Jul 2026 06:22:44 +0000
Date: Wed, 8 Jul 2026 23:22:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ak8-NMsNPOB3zpF-@infradead.org>
References: <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
 <akfAgy52s_Gch2KG@infradead.org>
 <akzsO_vmYX_7Umjd@google.com>
 <ak4A6IEmWNi27I2d@infradead.org>
 <ak44z-X-SKKhkBkg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak44z-X-SKKhkBkg@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 3mz61z3negw9ty5dymbpnp6wwutgiyy1
X-Rspamd-Queue-Id: 3042A160003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783578166-576169
X-HE-Meta: U2FsdGVkX19cvEjPFlx5Fa5KHlBN3I4u2Fg6kDVj6OUGOe/UW5ekXMjRRLd0wXgcxES7DT9d+gx9TqYCZRMxxGAzesxdOgIRcVh0qeg1d69pGf9IqBX+IXGVbnimhjDUtqulTc+orDQ1j0L/aOTV7P45baKUZinUAOGzIUSaQDEAVxu4vTV1Cc9R69RMuSFubBJccoph56sVaIDXdO+UMyX2baw/iCn8JtY2FNLHcmtnIG1LODPPANU1YRQo9h6vZZvTSnNCzOfw4/FgrfhPXTX1RoKEHHPYPErt89LMttlQrZFtoQRieEKjpn9aG1HXZMrzttmxIiAY27H8mG/qShfSm8y/jOUjdKQ8CeTZv9oybtmML9Lao5bItPILyVf+PW4y5RfQ3awcjAnw9fQsw+FruhicYbTwVNa3PZ5h2Z/G7JPcsCGTrobT8aqG2j66UjLWdgtzcm09Elfyw9CLpNMrnJAjoAXTFrPY/5HnSmmBy0K6rCCCREbMZkPXVWxp+f2ssln5iqkYeNixxDzwY1I4duscDpEC+/Z7PhjjZ0lig/iS0JGQIgdaSl3ATRz1j63sfydsqw09A1vVkZz6R3Ih6cvwMEmUx2jlf6rYpLpGVkcUFEDdNfHtizDfPR1yAfkUcZa9Iai7vB9SXbNKVZo+KcMbCrAwF2weiIJcnIPC4KJlYvN8VWxnp2ve7TzJIr74xxzUInzOTnPqoEGOV+qmC773lenyGFJw0yKZ3r8uSe8RldC063j1xOkJ2HMrm9MEHO6k7Ck3MJj66GajWpY3EyIo3WBnicofCtJ9QASh60h7njp4Lp7kkGt/gKC2c0yMRdA3NKmCALsJok4MEYOCV2MCXBAa7LBuWsPUApuQsqgeINJKrBOIPhPQQbURdm+Nks/FddZ7ZowABlIzoTwtN2zrrwBTd9ljHezQjJvuuummL/1bE56RkQAsNpA9DOAPyODiM0BREV3cjpy
 IV12U+Dj
 /Nhs7FvT9cioItBp+Jyxhr769n6cU5MTHATKCHubck5JVDSgHZTLdAPA2uAOGI0kk7xIMfARWF0x2PWoBVfOcD8kXiYoQPZYsA+Ne+XvxTi+tE37hEUrqTP99X6cSVhy3NlhGRWWf81LsGfJ5dngYxX3r6rx7B7loik5ai2sD4X22ohqCP38JChTH2JZDYprFejDD4aVbU+DhL7sN+OXrfJohE8he6nfad6wPjEKclsCBadcPvQfoZLymv9nHJx76qcNgZIjC147vsEl3mHsw1213lY6dRmlkrunBBNyjQKQrYqCrBqINNbubHEZLjJLHz2T1nodPLLigi0YvuLM/K2XM48uMSzi91c29MRnvYMghvGOgK9Gq3YeHY4HNMfA7DNrNfFM8Nog5OMMR9kYn/Z202W0Im96emINIV+4llHHCn+Y6+QFI4pOqlu/hIdFztb7zC5OpRqDNG/8r9gs9AGDcnx90A+L+A8ne4bQcxjCX5N1t3x+KjaqDIs12jV0/7U4aH/Z2IVINxK6x+prGqzMC9EGt672+d/htltznN8tRVkQirBqDhfjxZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:47:27AM +0000, Pranjal Shrivastava wrote:
> > Sorry if I'm thick, but I'm not sure what "folio" move means.  In doubt
> > if you think you can get a series merged quicker without a later part
> > I'd split it.
> 
> Apologies for being unclear. I meant I could post a standalone series
> that moves NFS Direct I/O to folio, i.e. break out Patches 6 & 7 to
> another series, if that makes sense?

Sounds good.


