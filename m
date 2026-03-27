Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B3C10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11E16B008A; Fri, 27 Mar 2026 02:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99A36B0099; Fri, 27 Mar 2026 02:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9889F6B008A; Fri, 27 Mar 2026 02:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 811F46B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:20:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37DA71B96A2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:20:46 +0000 (UTC)
X-FDA: 84590844492.09.9B4C483
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01D081C000E;
	Fri, 27 Mar 2026 06:20:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yux5iMgi;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592444; a=rsa-sha256;
	cv=none;
	b=kEH/6rv12byr8Xwza72j1hFn2dhvCR8TXZyrmdVxyl1RzGvWqN2BeNe4oBQPfiFVHxhgME
	z5qdjyq/++8aHHDbaP/A1FrmR9G1jK6O23tgyHG+pGp88CHCvq7bcgoKOGbYbr3QACj0U2
	Kp4erIEQyP+ZGwzzUxlfZQ0R9vPhKLg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yux5iMgi;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=V1Z16d/EVqyGX2kSMFKzXgiq3rPRNsRyzLbDe2Gi51C7mrJ+SqlBfmSeM8R22FKEmDvghZ
	SM1ZocE/aUEO6Bq3S+VwccrSjsXyGpdO51Z05UQqn9XM0JMNp3jC99gNkp05LPlnVTYp2x
	qEtjNYPI8IIqbvtjOPMhRqTuLO/ZqYk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yux5iMgiQ83LVlWc4CbBpbSR9d
	YBSjhEy4Yj/kgNXa0UbPLwMS/JBVvWNutfQUYukXysijvFulmbijYzqduHwPl9BwMyHe0AmrOSKhn
	eh6kLdph7lzkskZa029TWqLMG6vIaptp3iBcYN1/MIZ25hkCaEPhsucQN9TKF4zpkLDp2giHBidz0
	9GiVoG2qqFPwyYkO6apa2+DZCU5QyyVao8eXHO0de0I2JAXXQ6wJbxoc9niBAyzAk8m7DM0+E0faF
	3AisFD0e0tujjAPOOJcqVe1Qkz5olge1HjOt/rZeQFnazeJt9InWIuSNfH5bYj0lDtUtUSxe/14R9
	VCgOG7ZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Ye-00000006mFp-1cC0;
	Fri, 27 Mar 2026 06:20:36 +0000
Date: Thu, 26 Mar 2026 23:20:36 -0700
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
Subject: Re: [PATCH 05/42] bdev: Drop pointless invalidate_inode_buffers()
 call
Message-ID: <acYhtFaMQxhTsOBW@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-47-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-47-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 01D081C000E
X-Stat-Signature: 6bsupd8qhyju4ggsree6n5fyfbmfz73k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774592443-952084
X-HE-Meta: U2FsdGVkX187TOQt8hpK4aUEeUOKygHkUtb5dPLut0r4hGnIBPdJlz+QLLahwIfttSwyhZNe/V8yIQjXL2yGThPqf0Cp4nUQJcN7UZeEaydIZ6Fy20cnlkKzOxsOpq+RHZIAVR3cK4KQDCKRJVVSwqzo8bn1swrARRsT/OkU8RVTbzSwHMEDTMbeJsJRCelvoXHO5wGLgTPY4FiTk1KM3QjkWP2rF0QAYIhJtC4UdK2KMBZWFeP4Tj0ehEEcF9TNjI7GtTEha75OcvMocLUTbBaBujaf3e36myFg09U07rQjeNWoezn/NVjo+NdtloZcmL+Dv7cj8zdUMOV0qzh94X1EeuWDTQKy7ZjPxgdUg2Ggn5aFYgSgcoB2AtAUDSoC6PPiKUT2f9Ghxp1udKB/YJttWzGQ+6qeKWUEJOhwI7gKx8tpyZz1gP1vp9vwGtKsYca5LdY2HooQBGVmooMckosJYr8BEga7c9APOtNCXf7r20f8uIJ5srBwLVzBo899rI84a58+iXOsD6022/ca1n1/OHEtIV6tdtHwhZGIIyw7FrrOS9f07c+/gAWVeOv12P+Rkx4mHR9uhieQqumvAIeRnacv378xM++FP/NpJLhiwp/J8mjfqNXLwy19DFNK+Dx7w57QfcFVZW8Jb52ljK6oukE6FL4UoluMxjBz9oFxKtRa/Np/5oODovZoumZbn02EPWNDeOWsAxLNkj3B+TrwF+OJCYSh/wMlj1YVHnZjBFySrRVjt9uQaK9U946b0OkOJcxVuaA94U/Jr/XYC6vsgAsWZ4gdtRxQLxsrqNu6Y203aa58ynyQpf2E/mJQh4qaifUO3YvnXRm7z4O4GDYLJ+NRV3PoM5pT1EEmWMwvUUc7D78CWwNdQruDc0VFeQjThYg5Jqiy6pqgMjX3qTe0oEpdL0UzmCyJOYuZI9oMlMUmsSLkQBC9vCujcYNrD9C85S8Z3HS2KX8S4Wz
 baBWriPM
 qI8XYe5dYnJ7LLPTJ/S6KwEi/+Oz72kiD2tBDehWmTPsUfKBnIm7b2ibQae42Lgiky+IBYUxl5xNdzZoe/SgOsAJGxcOBdAThaqnEXajLnNSK39HOVZAlloAElseer07FF0/LA2HZv4aIvnfgUDFRywUJGL6sLin/rjsd736p1EbK4iensHuYfir3VV3jhQ9L2pYUcQko81MvvIJEqEbrJ/JgW5WGeHBURWvJsHq8PlxnD90H6ytpzHMioih3MYeE6qmuDIyj7kNe6y7DtQa/+l06Z70XA/6XOgXzg1AzZbGPZj/6S/Ug2x/5MKMjqWy/4djeGABVaZ/Kk8SeFnElVlJ4BK3TIEq6SSNOVCp9VbpOgGYM5xXdheixWsJOM4woMJQgkJoyvbSjqL6Zo6PUVHj7MYUccU5HECPyzpJtl6nexR9fZFoJ8R+6EGzUiSEnvVz3CirMWKzO4U2F582onjC+2GmgIwlciSJH7Rm+4ZxjXSJp6qIJKPsSn56o8fkiV7jti3JFTkV0y4N2uZSHhhgwKsiCDDSe5kj9HheWL6dc2nvxQOuSvZ+vy5zoMfGkK3GQUs8X608FTrSSrLEE/Sd3Cv0Tf7ikdll2il780YFnjnopHhUcOG5mYRceMrVXkzW01OJwLDEc3CEf6B0NVf2aGFp+scTyZJ+0K6+WLmwKTxvVFtwXFCuSYO9y0UzytbdC8TCEVZSwlDYYZaZdOKw8aiRiVeklkX/nB0x1EHgJDjhXj9VYZbm0VhhmiJMPexmuBVYjfO+yRjV0rmwxburgpJuVF4U2y8a10FzsPtFwC0XSfGu0pKNNKrm4ud6ue+6sECdm8ailH3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


