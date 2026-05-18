Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE22CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D296B0093; Mon, 18 May 2026 02:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C350B6B0095; Mon, 18 May 2026 02:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71806B0096; Mon, 18 May 2026 02:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A72316B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:49:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F9A51C1DB5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:49:41 +0000 (UTC)
X-FDA: 84779614962.01.84B2AA4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB43780005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:49:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y+ZQWG99;
	spf=none (imf30.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=oDEjRfFtLz6dDEcFoWby4DYDGcDCNpefoX2uuzaCGJ6le/iXZ03usObR5Mec9ip8Yzogbf
	WQJ4ozAx9+a/+hoE0YoUeKmpso9w80UIlfoS7wUaTIiK7LvsNJCtlTQbUHOTjAAZlxnol4
	ue5iJqbrztJGKFG5PbnhOosxA3EzcCA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y+ZQWG99;
	spf=none (imf30.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086979; a=rsa-sha256;
	cv=none;
	b=g3c0ikNYVorwAOnxokRRIlChQ+PwWE70gWE5bvyBu10Sx40/1u0pGk8eoQayLgj7JMoMjm
	06eQy5vxN2SB+oQUS2SAMQSp/amrINMibfmixHvUBDPl94vxByfYB5nc3OcCsdwxpIaBRK
	WQOs7QTi3jF2RK1vDnUgrWhXefidEE0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=y+ZQWG99KWsb1eZb4FvaLqYaSS
	szp/N9NlUhi/oHPPTa2hbs+HFNsC6pOjGqv13yWoN1cyel2aVLKgAASEe2g9qGUha0HJrfzw8vm+4
	+O3Fv7vSZVw/V6K3TyE/YJoD92d/gTqp+kaf3C0SaqLpb5dFBP3Hpy0anT8uh1TebpfS3UvCN1O5K
	iXrDur0cowmlbMyD53As+vUPWRqIhaesPQ4ZuYT532qALCgd24hnumaBQQSOQq0kcCyETDTqRQ45F
	QJFl/qUuOyKLrXIUO0CxcaS7H/kpP+4fHXelfv/xrA5RufPPVZVeJCf43SHZybeVWNU+b1GZ4INhC
	lAYvz1nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrnD-0000000ETmj-2usq;
	Mon, 18 May 2026 06:49:36 +0000
Date: Sun, 17 May 2026 23:49:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
Message-ID: <agq2f2ozYfAwwqcD@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB43780005
X-Rspam-User: 
X-Stat-Signature: kacwh1c79rmz3c9tusya95yxkwfyp1x8
X-HE-Tag: 1779086979-157070
X-HE-Meta: U2FsdGVkX19yANyAWZve/9+/6HWT1w0pm0M8Opo3TfLQ1ThAEYqJZJBwXu4fNrgyNS0Fx8HGQ4y8CEN65VCJ9V/MSc8veuaH+k47yeBB94Ih09ajFhgn+n6YlUiNXpfg+CTcARtVtgtZ4ntLI94sPx9uPv/9Kkn2CPBHrh7bZF2SL8siI5w3gc1EkjNdOVJRWQvqRC2a45+U6XjUYykjvJo8Eb9WAJrmkQMNzatfC+f9AtfOr5l5NBp3kz76SZVULs5LKg7Cw4E2maA5Aqjubh/us0nT53UJaVTKuMAHTYCK0SB330shvFkoh9F7AxR+T2qA5QUiwdN6n7096B+xN+fp7WMBSgUGSvae2Q3xoCqBOgwxmbILU1Uf0eCYeooKLhrr5gfC10u34GVOBabFI6/gGNzhTxqdxVNAHUF3dT2RbOvjD5R8W3s+jaAMicfk62IGNME3oJ6nOaQEsBM2SnsJOyjtaVYW5Yyy2Ch0yBY8ZvvzGrF6miSjY6+ZLvQUDLOVgJYhWakVDO8k65IYSbbyuj+GXokGpQpStjb07VVBit9WF9thXUzAtOZLS+wYqkT0FQA8VtQtt+MdtbsKo0RK9noyDxvF/u5SPkRJAxmKU+s9/BYzq0soyZ3iYzetasSa3Hujsf1bZ1luHNrYcaFVPh470M0Nc9gxihJqjgbFOIqsbFe2oirubxhlBoa7NajA9nOq3qaeg+zzVQs/TMZ6+xE4ln0dJ2jcJuB8CPz0rGlPFyjI9lSeTAKnbVIorqVdlSVh3LlQpwJ2dFYkdZuVZYRVktLiVwnkFZjQXi0TXYJuhhIFxfh1RMCQKZIc98IKyQFv3TFxzwbeoyt1uip4vTT5iSM+f1IPC3hb1j/jJJBHIWdXC21xMNTSYxHGUVYBnmoCGaEWBG/erSBEiZdYOdQuekyaYCkXL2RWygMkpvvTSickNmQI/Ni2Wruaueq4bZ+9K12Ouu5lYZd
 17qNEpeH
 pSzlwED680LcvJ3qvbWlMAfUptobkA31F5g5dd8g6zdSkdhuqtAIPW8jdsz7mhCLb5Rdc0d7RVyu4+xpjSHieze4EuuTNfJ2ij7wsrGLU2svHVxO6UL44Em4Ar0noHZ58F3spCHgl8waFo77x5xIRekOr3ueBjKGyVyEe7tkCdgOfY02/xKaG1Ff8TQ6Gnd3syBH/Z9CJEsQ0ZKp2A5wbOlRTNct+sgIy3D0x3HhuNDrSvGyhEASwjoiyNz+i+6leuk4ubZHcN86xYTzZDp50Lq0z20k9BJuPEIjN23/xqrn1qrrZEjLBpXrPgaYTVVWCDs1UNe9rtkY0iodkJSyHx5H4LXoJSRtQD4904AxqBTwdvk0yK3FcyMRv66W+X5+Q9P0fDRkKXZKi71hDJb6AVURVW8LomUudvv2zskW+tLTibkupLvwyT+nYrFLAMqvqzJiOw6XFBVulyeeIfmnDuyenaO+IcVHXdNv1bMC7Y+3kpC5ktxZFaJg1/Txva1y6Hk+grmLl17UH4RWDqyy7EqvSfNcNbcUe2CjDJ0c0BQacy/10qabbARpoZuZTO4jaij09odPOAUEP4JBpps2ZXD7PxdY0cWR1ju/g/otZqYnXt/ITahAh8vSuWWBPuW44UDLy5FhpG8n3IB4bB5C0MCkqbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


