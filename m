Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC152C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 05:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D7F8E0003; Wed, 23 Jul 2025 01:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665588E0001; Wed, 23 Jul 2025 01:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A24A8E0003; Wed, 23 Jul 2025 01:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49AF38E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:36:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6B88C0587
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:36:43 +0000 (UTC)
X-FDA: 83694419886.02.B781C86
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9979940003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:36:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k1Fah8OQ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753249002; a=rsa-sha256;
	cv=none;
	b=vn2M+j3tX93Il3dGQxeW7R9CsGMXP6VRhwKG5dpE9PBZRyuwemQG8Jo0JBGRXyDQbE49u7
	TtNzjm5AV3tklQOiYaINZKXwsZnyA7MrDIRvREx1sHmDHMoKrSzKp5oCMtUNYH3woRHMY8
	vVFPKwYCu02tXh2Tk+LmhjaXPnsR+Zo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k1Fah8OQ;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of BATV+31f8cebbe2962b054d11+8004+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31f8cebbe2962b054d11+8004+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753249002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lriBSHQn9T3/tnkp6FVPWjsBUy6Y2i0Py2+kWACQ1EM=;
	b=x5pToLhA5cH4/M2WeWJMLrL2MosFsozBbJ/9wTYdcmUmVopfXxSbwnhgCVxqdL5wSIhieg
	FZ9Z3q9RutXtYj9uL/TXDBSzpnrrXUzoUsDCImpg/DWCWYvP6waROx1/4pYOgZDuzX2/by
	Jn6Ys4ndh1axq2N6pAelhINIgYR4wDo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lriBSHQn9T3/tnkp6FVPWjsBUy6Y2i0Py2+kWACQ1EM=; b=k1Fah8OQgen41BR0+0qCE2zg76
	nYycNUiXv8aREKUKtfwW7g6l8BOc3/rYwpkuRSgUq9QZxTrIvA6dqaS1pT7yrgAL0u56Zk2SxWwUY
	R4M0h1oFfF1gSJjuyhekU+CSeoEVCPomDrE8r90q+m/KtvYR0c/9eqp+qQpdVdrnUsJBZ9c4V4S2W
	kUPOUFNV1WgZDOFTYVkGMIm7r+9wYd+F1Bo8DZ0VteqXfubO2el+Hs5EVcRLSFWCKlhCK4GH1gbi6
	O445Sg+YZM7Z4L7PfPGsOqStOXZ71DBTPC0HKOuq/OMTB3hj/B4ANkannEIc1eMcTuuRqkQs8lti4
	WRMjlZJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueS9c-000000044LH-3hQv;
	Wed, 23 Jul 2025 05:36:36 +0000
Date: Tue, 22 Jul 2025 22:36:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] MAINTAINERS: add further core files to mm core
 section
Message-ID: <aIB05LvNW9-VT82I@infradead.org>
References: <20250616203844.566056-1-lorenzo.stoakes@oracle.com>
 <727b5e89-89d7-4abf-a93c-8d6f2cb2c438@redhat.com>
 <aFDm0YrbSAvXc5Wp@kernel.org>
 <33c605a6-2b89-4b40-ba80-ed2ca665ef5a@lucifer.local>
 <bdca2e2e-acdb-4ea5-9017-6c1a58353452@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdca2e2e-acdb-4ea5-9017-6c1a58353452@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9979940003
X-Stat-Signature: rs8gpob4isr89rwkycyo81ho45fuhoff
X-HE-Tag: 1753249001-163133
X-HE-Meta: U2FsdGVkX18tPZVi9UciiPPGqdMQ36xclBbXFDlS0iN+0sOESQgho2lGpxwAp0c2YSbJBrp2UUAu4GXVP7YGzT74Irz4owpvwZze1mfS7vbcCkluGLQk9FCYb0Pfq8CE50zga+fyXs5npJqzHZijs8REMvzBtCGBZ7E5z6SKTi4w/pGcuiOcBGoSLKV618RGey9X+veiMl21tukZXWH1CnTNGcIlOM3a6GU0rWZghUzlKGEiCESDWvG6/hr3SzSECgEN9Vf1jI9p0GAtujrCHDEdtjSe/LI0Cini0rYacSk2CaDpgg6oQr25hA1J3u7bgpEleMFWOAmFI2Dh4F6eF9zB8TdgZR0xdxhHKOeK51knLLMBVw3dJGdg09zpXPAfQbLbvTq8wOkN0CnSjAlqLf6rJksQvgNY6HP3b4vh6bktxHOMhLfKyA7vzDoyq0FT01CxZ4U6iSpTVMaSaQQWPr1AUUos75M6/iOZ4jDrXdqK63grk2MAIdAWIzP1amDGlelze812Djy3M3OBreZ5ZImsLh+2JoAuDBr1LBGIr3k00k3nfDETdUb8t+6sEdUSLuwoyYoBiS25hyVrAjP0hVOVFuhZoK9sBGA2ZnOWlV3Z6v70FGAB+ts9QfGihFYfsu0MNoUfUGBrmp0AtM4LDyXyclqxJBFpgaF24lCUIQTGbTMXXR1oVoikpOGOqT+Dh/yy/0Qoteb+Ce00VwRIg7sjpejJM9vRN3maYtVca1ctUrJkdfVNhycaKZyVlAe/oBIIQqndjKTxFcF4uYGVnzs7QCBah2IWe8f1xYvvKq5sbydcJZ2FfI1bL9arZ+ex9wfPnk3Y+muucJ5pgK1XEiRkfR21QiSXkcyvuprVnon+FukV4hbZfXsKzNgjv7gjheZwDF30xDcNDm8AyuZTPM7qS/DhxCgLaVWUH95iBp3KWLeTPGXwEeJqnKAmRzwjCHtrSdD20nXpq2o72MA
 qGSihOsg
 h87outunDLPl5YNZqKCzXcxwvJJQLYO8KOoWgdQst/GXjNb1ulE/THUwCkT799Cfs/NekjK2FB1u4KHNQNSEF0BjnrHAzEm1snFGa4ejjWutSwCjSZ4F1nrc8rPkmoHCpR27qaad426czkoz0oeJf5S+ZLWRqY3crAiGCz0qyoGS+ZAUqw4W+MNKdQJ7LG5aE+day41zFx8dajJ37yuVMIswi7EeE5AvtkzXd5DC1wD0crVnWlgkxKYzqxbT0270oZmHOi8LM2m+ntc68jFDTF9KdM/TgZSWUayX/ROJYVpqivnyUvHgVBq+ona8BSvO5H3LiBf9Gr/w6bLpy/uUm5nHuWlpLfSl5p6pkln4ocofVfj+BVItNB7gp0L145jIJLPHpjajJv2PpuYv2wR2hos20jQI9+kUnb+z9iYO8y+Er5+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 04:22:59PM +0200, Vlastimil Babka wrote:
> It seems it only gained its only user in b739f125e4eb ("i915: use
> io_mapping_map_user") but reverted a month later by 0e4fe0c9f2f9 ("Revert
> "i915: use io_mapping_map_user"") all that in 2021.
> 
> Ideally i915 would be converted again with the revert reasons investigated
> properly this time. Otherwise we should remove the thing.

Yeah, someone needs to sort the i915 mess, and it's sad they just
reverted things instead of trying to understand it.

But until that happens the code is dead and should be removed.


