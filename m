Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF7210BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7CF6B00A7; Fri, 27 Mar 2026 02:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FA66B00A8; Fri, 27 Mar 2026 02:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E846B00AB; Fri, 27 Mar 2026 02:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87F726B00A7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:24:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 609121B9650
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:24:22 +0000 (UTC)
X-FDA: 84590853564.11.E5B855E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24170C0008;
	Fri, 27 Mar 2026 06:24:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VxYmAxH6;
	spf=none (imf28.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=tBRue/Ud1icPGwTq3pAjDJS0FVSTjXHN4hnBc7DDke8PUwTAI0zHpod5tWGgzvyv70o28j
	9oI7ZYvEOn/j0NUkxmxS36u5GDdwLVy0SkSavMZB0qIbA2JqfKyur25+CeMTL5P1sUJyQ7
	VvWt1JTGRcFJusCCnwqGMq8re9mMQKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592660; a=rsa-sha256;
	cv=none;
	b=46cHaTCsNe7pWjODDM/OTW8g0z9DBjB+HGXYLI/acWvsOt3/YMDInKlbBy0BCWH1G1wQxo
	8Cy3jmgxJ74VtHjs67o1jopjx5WnSNAmHVN81Y00CO6f1eWsy8+ME/vHdUY1Jigd0DhZXf
	4TABoLbuFbLLuU2nu+66nESyxhxFV9E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VxYmAxH6;
	spf=none (imf28.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VxYmAxH622ZqprtyneBXwuBYpq
	rlXaq9f8q/OWJ8iP1aMo71+0yJBEZ1R+si1Kz2Y5ap4Tr2PiTxd+EpPkhqtxnGIcLgZweEzRbiMg+
	7MzNA6J/WBMlnn30duKN+uZYhgnFNly92QVI1grMTMIOlZzguaGQKcPQuU2u5PGPj9nXtMsF3yHpH
	R8AvobDX3n4BDZdLNMJEkcFto36O0rP43Hgxar8p5WYLG6D2EiUvvQ2V87+Mfh5JmrKfqKcHkykny
	IjBNh+iD4s5iuzA6Q/Ld/q720FO5GtoVAEbDztxFPHuC/S7xG5mas1vxgQPOCcXSNwhzxeGi6jpTl
	qgaQj2YA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60cC-00000006onL-38zE;
	Fri, 27 Mar 2026 06:24:16 +0000
Date: Thu, 26 Mar 2026 23:24:16 -0700
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
Subject: Re: [PATCH 42/42] fs: Drop i_private_list from address_space
Message-ID: <acYikG19JAVWxL4q@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-84-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-84-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: 9s4gwoqx67hzuigtkio7s8fmi5sgn9te
X-Rspamd-Queue-Id: 24170C0008
X-Rspam-User: 
X-HE-Tag: 1774592659-64172
X-HE-Meta: U2FsdGVkX19JIODVxmjCAjR9XQodK0bUzDmZY4VMjWdGpfUL/VfMZnPhwr7SeRGsnxcczTpdA666ZpDykVhoB9HSqQmoT3VzghRdYg0zUNWIcumGv7uAcY/jKGa027xbxyzq7BVZboMje0QjaVus3sJo8GO7FqzilNTa0Jq4tmxXq0Kx0uRLDEG77irkh0fmQ3D1BQm8MSDfOzWLxsjTbPbhK9/4x43cUrnCQFGk1k+KwI2gqjdfzEcOyRfMZISjJV/Yj1tcNt1mzbqrtvJ/ERQ2cS7rl+GEqe27WidUGykX0brExboWxAwtCir3SA5w295xfyCWul32W6vythiutExrXgXzFzOdIvzIqwMoVYCjN5T0UU7Qo0lavM0KXjB8dvUiFuRJ2maIuxozOq5tqrclFIxwjrcv6KiKIo2i+18mfvYE+h5j7r0g3O77rxqHNdik8tCVV+sjnCx1Jn4+qdkqSGAIHFc7Jv6ymnlc2pCofvAAwpWKrtFePsFhpuOc7Em8EqvIz3aK/xU5DzhAn2kj2AWcXbRC1pIzeCI7NN9mKp/f1HHPpdh8b3setanipryxOUhiYn8NzcOyajvuUJsQLXi+aKNXWbGqps2a6Rw4igGKvaCMGe+zjlcJzf/Bi0HNzsLRJrGDFwBjUJ+XBw9oNDPJDeZM1ysr0Rt/e8YtifW0W9plz1suikkYifirU/X4kKamSWsXHGjH2RyXGbxzY3YlV5GS04aBSPGPpFTDqcYszmqyh7EBnu6oN5hkiLS+RT6P1ebYVTy0ZFkl2zBQCZAblj5ZmZvkFWKnC5UrwV5Kupu+nBwa7s+o7ERyr7kOBX7hBlUr9tAvz0A/ABw+9ea1tRDkoJN1I7+ahzd85Nt/W8fA00gk0rY4UIEnqoJv55LnvUkgyGk+ZV/kM7CK48H+zHQDQZTaSKSub/psPI6raZuI8YDTQVPsDRq0SUDIvk+byIzSL6mso4W
 OZphIc6l
 XEdAVpLMnSuVjOBQpUI1f7HUd6+NVR1svG8S9Ulcuqno3pNn3H+oL/yjOsFBfbjzDp9QbYnKnQo6xKjJ9Y4CMkdxhQ7a+0X3E72mlB3qC/NllEihUMPsSMwE/llLvGoqccUmgQfxno4p4HWk3vRbOyLDVJcqyIs1VbEu+VjLVJyPDq9a00rBQwZjMyCriukG7S+X+3juuSI55SbTira6nYTBJyANRpHrgyTEAMPLdyItWuvmR1+ojAvM5DeDp4KJSvkw4HiLILZqIuKcxv8TRpm1FR4JGeuODzgVaPqWOtEqiVNloD7GQU+4I0/vdykqrVQzwkZon72hd14WnadSKVIoh/XyVLAWEcNuoH45xv/liptCSJUkvqXIeLDOpDPdz/HOIQA8v7+M4T6nbs3Z9EyO1+zcsmWGlTorM4c6KXIKP7pjsZ1jnaU+0IuNBv8SLYSJjJ+MrwHeQqRrgvygH+JSJz94ZHDjFiTHZLfgIPyTI7Fscfsue42jkowB71Es1Lns2chvmVHb/pJ1xEtcb2XV3ZX2sTKBNKyzCYTJW8wgvJyUUxtP9xywro3G0iO+lIJW5gF5fH9B2yMoJ1nQnoafhoEyy2qM1rNsFtrrloVZYT9pUCcbnBa8hUON+bmMw9kPxUQBHqgbSgOV+QSS1md6eiWmPGelMv0V22nUghT9sHvGCsNio4ICO5eDO1gVdjzML6Kt1cu9nziyU+K1Ou0Xe5IQZemcAbgA/Tz3chtz+cLkaZ2n52IkrMiUEYdbzpae0BEM0fb9a1iycz64GqWW6csxvL61Wc89nfCxZN15eapZN8CayIH9VoYt4Yqzg/aGHZ9SNy95UH0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


