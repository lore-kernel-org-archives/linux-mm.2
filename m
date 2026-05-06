Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2774ACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAF96B0092; Wed,  6 May 2026 05:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BBB6B0093; Wed,  6 May 2026 05:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7910A6B0095; Wed,  6 May 2026 05:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64BF86B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:07:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1343816071B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:07:19 +0000 (UTC)
X-FDA: 84736416198.06.C5A9A3E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64CED100002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:07:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H7dHiUlk;
	spf=pass (imf05.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778058437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WG4zYSk9ctPQaMVvYx2vBjX5gEWW4bybksoWBXaiQvk=;
	b=LdwoD9oSMi/gNzUipkKVs/p9ArYHyRIBOwIAd/YtPxfhhveq0DkstCaFM7xfeWDsCdKH7T
	CnUf/YfQhmB3ZTzHaK/3gmiGTj1vCp5BLI/FBgdo0I2NBB45qfkIlcFH+TQbdv3MSTyo8t
	P5Q2dfZVbX3ee5QQD1+yq1s2oX7uVgM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H7dHiUlk;
	spf=pass (imf05.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778058437; a=rsa-sha256;
	cv=none;
	b=YdHu0uqxyZ3OHLkyo3B2iFAM5Olb8Yq4QBrh7HsvjRvNDLqOUxrsEYDvSBIcf7H0fZmo9H
	qq6/TNbSNi1ocPA0m2kfQ2giS4p+bjhITOjiCl2QdSgqcm7JfFD1ELMHSCLr3ogbmP3vKo
	UB1sENRdKGTTGfIdymAl85iF/kejgQU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4A3E1A9A;
	Wed,  6 May 2026 02:07:10 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B1463F7B4;
	Wed,  6 May 2026 02:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778058436; bh=Zc0YSgeQi3Xu2OmDuesox3uQhMleeKiM6hRzwSIBGNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H7dHiUlkBpg5qyf1/EBCrKzuTGLvjy5ZeSy9+aY/QsnroAUQp5J21lCIDA2v/Pkt1
	 HJzasdeYp7tVYr3X7w4tzNYHMeQUDEXZXHs1N2YhCxKLIQkqIK90wqW9VmSRCYcDQG
	 68UA96YVVyLM03oo3v7U/DkzQtdve9qm8JcYiv0g=
Date: Wed, 6 May 2026 10:07:03 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 1/2] Documentation: maple_tree: Point out constraint when
 using xa_{mk, to}_value
Message-ID: <5pw2rphajsj2xgjwhkbkjfv2njwz6bimyjxckdnytwfxkibinn@ev5eisyjtbha>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
 <20260504165746.1422057-2-weilin.chang@arm.com>
 <afkCZkHcn58S3GLD@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afkCZkHcn58S3GLD@casper.infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 64CED100002
X-Rspam-User: 
X-Stat-Signature: qxj6r96nefxeu74jdsfs9ustx7xebni8
X-HE-Tag: 1778058437-286870
X-HE-Meta: U2FsdGVkX1/obT4QE2ir4lJ/kSKQLMYWUlQCppmcz/HO1RwsVMb5sqOFtSH9wqPymW8bg3IMUazOyTHQOKIlJBqLSOmo+wm8PpHGPWqQ450i8iGZ/jesbDPrAj2A0DbYhLgtcBxIVF0Ax4CwJ0pIJyBD1hjHcCGvOTyE0oTHoiYR3FZNzJBJfYHpGoaBmVGzLyEliJJdMB4EW2Nc1NdQ1CpjcavzC4q5eotClB46fpcZPLe7Z8aYrWHB9bAB3JLR08jkSRaBdGrJOr0GMPkzGgQEwhjscrQIiDYXgXwMYnJqW+v0S+Iv4Ut5M6b1FOTYkqtK75fx2Lh9ckIDXTTljj5/xY/oC0wIhL40TxJGiJyOiVVlE4tbYF2GjaM5bSeDstnorX/pTst1pFBhzEw8KMwUCGpT3NIlzgNxK+9ONBUuIFpT8tzGqF9ICerwj4xMbMIssGrwQjLdWrB8ylTCCbfuw4V9HxaxApc3Flq2BWN5r2oARG+hlomk/b7qjAEBjBWL3exHY0XvH0oPA9RO7YflMFuc90pqLgS7K18nWz8tUFu7jG7q5saMpYKSMtFgqVd/punKb9yxxjtfHMMaMIMIIyLSFAA2rkEiOElI4w+RfWmQDdTVjPKs4w/BquaFqUQ23r1jVJLdnIuDdYw2ZtJokaL9+vgtXHErEP9hcjAFsWp+hpnbrjVHG7Cn5+HsDRRgflsleTd9g2Juo/2CV7Pbl3pQVs10+UGx1h5PLJyHNY0RVRcQgR44A2dz1osXW6OhnUsoq+vAB/m5nj+mAeJF5PUm/jEtQsocq4MH8RNKPGwnB/it4YDz6huT7d/syxmXzVHOpxvztu4wAPZUNwtjId3aLSFkrBABvbkIwleSfUgy3ElaUYfkR+zLguAxMHJUXH4BVEYEk0KuMvd1wvYO3j5KrksjVwPB9nOkwCforTc5QGl6HHwiAJz4eIB/m/NYBR9RSoL/i8yab1a
 rQZHWo19
 vXObnbhblEyvkyfF2zNk1nPSM4mQjMW1jhktW9Vb3QVZAVfb2nXzpzK7zfjVYc4foKGiVZ2aDMk7/FKlGFIjyecGQnlTmBPDoogzXOqvaJxgGUxw86u4Go74keNvJu192ivLs0g4lGRt96Np5JI4yf6hYFl0ApUZfw1y4IYg3n7SE+6quqkh5DIpL573MBHzrNvqi9pj4eBf1cIbWjpHHsbuMrBhQEsuIe60/T+Bban+tYA69mGDVLFL3aOtkFeYo2RoPXpnD6XTb5cWDuCW0DPkAsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 09:32:38PM +0100, Matthew Wilcox wrote:
> On Mon, May 04, 2026 at 05:57:45PM +0100, Wei-Lin Chang wrote:
> > Using xa_{mk, to}_value when storing values loses the information of
> > the top bit from the left shift, point that out in the doc.
> 
> I don't know if that's necessary ... it's obvious when looking at the
> function:
> 
> static inline void *xa_mk_value(unsigned long v)
> {
>         WARN_ON((long)v < 0);
>         return (void *)((v << 1) | 1);
> }
> 
> and if you ignore it, you'll find out.  But if this needs to be
> documented anywhere, it's in the kernel-doc for xa_mk_value()
> and not in the maple tree docs.

Yeah this makes sense, thanks for having a look.

Thanks,
Wei-Lin Chang

