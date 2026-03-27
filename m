Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1E610BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7419B6B0095; Fri, 27 Mar 2026 02:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F20B6B0099; Fri, 27 Mar 2026 02:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EDA6B009B; Fri, 27 Mar 2026 02:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54B696B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:21:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A5311B9691
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:21:35 +0000 (UTC)
X-FDA: 84590846550.16.1A69669
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCD61120011;
	Fri, 27 Mar 2026 06:21:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rZMZxQZV;
	spf=none (imf29.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rZMZxQZV;
	spf=none (imf29.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592493; a=rsa-sha256;
	cv=none;
	b=38mRUEW6peWFxVFk+KE9m5sju/P3vUKSzQjz/kwRBKttZsfp0WNZYMMebgFFxzj36DvOTM
	cLBirmSAhbU4fIkESJLMQt06KO7oZNAylnycFqiNAGfDdiqliX504vTXIJZHRg7wZQiOf4
	iX3Q5DF5WJAKv2OYPha50XEB+wGLFQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Cd+DTClLKM81aKdipmdxsRIpf8rIV/CgLy/aPoktRoiCXo25XgqQez+hLRacJLA2u3b0ci
	EKqzjS23gklZgCUGrvhFHMSU8OpntzYJN/YisptqzsJBWpX2THiAKQug3PTANkN9e49mXo
	sC857NegKNDoZcFmSYD9JeuCW7fZFPw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rZMZxQZVt2Gy5NHLy87XGHPb2O
	t8UOhJLwShM3bxa+9/Y0ys6+zNjUdl6L2L45KVBQWdQNh0Q/qcylHCVQ5j0hgaUJgGzV82YSOGMAt
	4WeERQEYkPNjgAB56G3fOu3V3aIeZENSWgNNRIPa9uFjyjCZJTDt53zSycK3nCq7VjWmv0TxgZ4sB
	maWSmnRmAgymI4B7pvFhxQw98Z+04BH3DVt6xBJhgHkvo+a3DMoL8mVlDDSGrvy0Hdw2YeUJniC6T
	pzU8UoSJyzHYQDCfQM0r4PI71sGTlzaCbp+Y72JH+Jh7k2+XjXGRfbmHQzios9gqPx88CJNPd13po
	/rNwIiOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60ZU-00000006mxw-2THp;
	Fri, 27 Mar 2026 06:21:28 +0000
Date: Thu, 26 Mar 2026 23:21:28 -0700
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
Subject: Re: [PATCH 13/42] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acYh6LSOPzia4N03@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-55-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-55-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DCD61120011
X-Stat-Signature: gbuycxufiorc555sf4htqthtgq8ob5w4
X-Rspam-User: 
X-HE-Tag: 1774592492-478841
X-HE-Meta: U2FsdGVkX18926Y8OU7/K94H0k06iKk589vqCJEdy7yAETQKKhNr6dqdDIXgu4e/4pZeQfifPCg7cHg1eZxic9cSr8pAfaXOcCf3k8w620HYiV8OXnA160G3slo6r1E8NK5aRp9i6chyqYe60UE8bsmgKfTkL3Qn0Vy/ijDTbp1av007MI8DlsT0mPvwkWvWo9pa00KayUTnbwuLqaWZJvsY1KJghMMLDzYVCgTQUl0PIgKpOw7S6pWNm/bH2152iz/oNCpqVyMc5yhJFTPpf6XktmkqeREdrunlVygoF6oTqm8U37hd4YTJ72dw+x28Qr5hupKYN8FIf6Nz97k1+NpZG8gGj3mwN6ycKGtW4e0R7XUA1PnNf+HQQW9xfSwlJvc3eBDoLD9XVWl6RMRK2p7AuyneqPVAGgGAciHiJIDXH8p9CN02xED7eGsdE47QjTLNLiT88Ji2iMkOOdw6uyYOI6LW4JskGwljwirpzXMw8ZLbO8CXb5K1zOHCsvd3W5WvMLL4XczCoYI9qVXkRK4jCXU8Dzlrmj9ffl6VNpsaYGFEey+9SfYhIbzwkMXTdeEpk4PIGYHsEi80m+QlmObxvPBP/XJBG9HNh8jDOrjAj2u0XYK8bGY/rn441HYlHvsVFjG7JioMeJZvNT26qocBm8cJOoft0DkhObMX2KayNJbHodXb0ap6ehDUAfuuMbO79UOEE3KviswCAvSbQ73OPaXqaQFn2x43gDMMxG/MFz0Oj/t7/GctlClZ8enn0ITUUHlk62HBzRYLiVUdQbucjMkpTsFLA1ttN7LlK8lHkAmZSYx3UZTt/FEA0sTP5wav7Tr0S3nJaWvyS0a1tnu+zyCuXKejGMv8NposyyRxIgBJ89ssFDIsghstZz3LwBbbtl4VaVan6XAu+BSGXhYsqgiqb98j/pdWN6dxRrn7+XSInYKzN7eT4Gr9lKsZ3Rz24M0rrpvtK2qwQJZ
 uMw/kEYG
 /rrRCIqBtLIZ3bIu3mrdrcA/hiPsxKBqZJpCo3ndV38hZzUcT2t5hYETLR3mP6PUQmL3ewTej1OVbZsWYKJBqWfeODPIpWoHOOVpGjNFYS9bv3ARSpP1I+a9yvOHykIDf7Zu6Yx0Qc2kbD5b4CTKTfUPdRmgdWmWxn0sT2KdMYZUzPbj0bpIoH6kSu6CiOG7cwx0bHGJ5g4+YOW1YW2DPyAZUrL99J2sY+NoHaeSkjU1QYWeU6BCFVQ0gg0ywbVyhw1MZBOh9TtrNLuYNeKTAckIHbTr1TY/awOArLVitN4wDXgS4nvhqdvHXWOrgDX6N7rz7UuNvOB1/jehdtTtcx3EdFE9xVaJudhzC3UKKXCePMZi8IyjWBK3RalyTIiBsI/Y+XUxfVcmNbarb71sDUrmoHz8x7B57dmOmwE3eVhKAo+gXEmuKEOqvfzyHoqDDsAGfANpWVnh66/0/EiGOr4+f6UZHZ9Cwt/wFUI5kH7rq6Q7X7+woloNniYNZwllrnqLBA9ISRUObtwXWB0C/n5IPuo3HgYysLAMFouru8TNAHSBJkKyeh59g+rGG5bwdPRHeYYSt4RLvvd+n83Iw8qzx5OKAwkarBZcMAw2jFnKb553ugYnJdzhw/A8yiPkkEaqkSkZoNp8CPNmvZ9xg6GI1JT9vTLzFn+lGsUfpiN2SMSxAxRfRiNYZL9IQWs4nvOLRNR4iLuzKjq0qxCdNLVPSI6kgRU5cgRhEU+XZtUqF24BcEFGBAEingJ79la7PseRrI3sEzdRcEQXDYSHWFVcAyPqIFcw8/8xaDY2Knv4nks0aG+PmDRburfabw4mR+YqoD/JfMIM9Ud8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

