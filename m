Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06236C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2302F6B00F2; Tue,  2 Jun 2026 03:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1186B0401; Tue,  2 Jun 2026 03:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7696B0402; Tue,  2 Jun 2026 03:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236D66B00F2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:41:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B38781A03D3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:40:59 +0000 (UTC)
X-FDA: 84834176238.12.26A9673
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D3C0340016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:40:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mt4n/cit";
	spf=pass (imf01.hostedemail.com: domain of linkinjeon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780386057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYditk54Uku6bdeB4OKiDApuAv/ey2NvuAnoxzRJ+ac=;
	b=pewfPo5TZixDqwcXjCFwxVs8k4xthScE6uzbSvh5byyakceWhVKDI93Ihu7mcNerg/huHf
	08yrQhJAutzPMgtM+YWPYuNKoyz0C03Oz6SA4oKZoH9MXxDEdGkeTUDqOrBwG3kW/x0R2i
	NJMcgDTyaU3NhFboEom+8gGKwr4bULw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780386057;
	b=JEeJZqHfyFqaHeAac0Oksyad1FFg3RDBD43G/J//+lel2tuxJkSn7ynKKmet5LyDs2zfLb
	7gAfm+obVzsNLH3+k/YoRORKGvDAixnRgNf65hhUguGeZPx0XifO7nV9lDAfbQXHz/w7ZZ
	EuEG/c1sBxSwi/2pTzrUj4NHjrlOlos=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mt4n/cit";
	spf=pass (imf01.hostedemail.com: domain of linkinjeon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 327D060123
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08DE1F0089B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780386056;
	bh=fYditk54Uku6bdeB4OKiDApuAv/ey2NvuAnoxzRJ+ac=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Mt4n/cit0YTDOaHACOBbRmk0o34BjkWEM0CpWHEnL5PN43aCqwnmPlXvXFc0CU3rI
	 DsatfwC7+MfTYLARIcU537LstG7YH7keRHnF5aK+ANfAjqOC1r9JktihAggX8knOWE
	 wAiiHsgL0ZYd6SnRs4m6MWCoeprT9rHX1Yg5xGShRipGcuRKH41VL0R9WZp5DkS+6P
	 VzfJ9ruUe8ii//OL5HmIzKI6OleTYYloRY2HBNm2HheUZrYE4WQKmtPMpOx8SBOXdu
	 mythy3QXxECtzyQ7zTzds5ZOscPUdkajWGi+hIUVHm4sNFDK/1VCyD5z17s/MeNRjc
	 asLwezpzafofw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-687e7edaafeso18394754a12.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 00:40:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8g+gKuSTJ+1zdN3JtQAGhT8FmadriUR2Jrd0MNOzpHhKazCBM28SbAp3IIapz9X9lS6gvaxciRNg==@kvack.org
X-Gm-Message-State: AOJu0Ywl4TzAhyQT7OlcSndgISREu6G/me6VQG18ZKf7SHM0SiKqoejU
	5j0+O3zJ4+AlDCErgjYGTLlEHEd7dDasQjSkToHSe77VqU8dSEySl8Mb0zjZJ2AGygTIOZRMCND
	z6CsOQKXKQyREbHiQadmXHw48iSXxnDw=
X-Received: by 2002:a17:906:fe01:b0:bdd:52ef:73e3 with SMTP id
 a640c23a62f3a-beab13c0e42mr869047966b.12.1780386055618; Tue, 02 Jun 2026
 00:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260601192626.150804-1-willy@infradead.org> <20260601192626.150804-2-willy@infradead.org>
In-Reply-To: <20260601192626.150804-2-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 2 Jun 2026 16:40:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8S6MCddYeebRajNEBrPDwLNC09=uWP5XmUaE15Gu+JZQ@mail.gmail.com>
X-Gm-Features: AVHnY4Kodk94p-MYFF8ymWKX7Seg-p_3ldHd0r1g_9SuP85Dgp63IRhmvVe9TNg
Message-ID: <CAKYAXd8S6MCddYeebRajNEBrPDwLNC09=uWP5XmUaE15Gu+JZQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ntfs: Correct use of folios in handle_bounds_compressed_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D3C0340016
X-Rspam-User: 
X-Stat-Signature: 1dsyomf3sypfpxoq89rm7g86hqgjig57
X-Rspamd-Server: rspam08
X-HE-Tag: 1780386057-157512
X-HE-Meta: U2FsdGVkX18UNZ780Um/3EJP6tSOY25jGxX0mGYTGYSomAs7w/hLCD3xMIb8PTv8DHEmwuurMiSA7IPC+IuME3m8hglIpYneyzRdrWNrBGqTzO1706UpaRHPAQRydUJwV7hJCZzhrsNrrc7JE3qs55BzLtgBmRG1JbKEx5CSftIhyUNHxxKRrUc/mlK/8bQqo8g8vBknOCbvcw+SuQ25pApzGkDeQ7VQjDEZFQjmpXMJIqq/fx48WWpczASfYTZawt20YiyuatSpU4P6ogjjntz3ZW5jFClB0dHAoalMHhjT9oOdloiVezim8FdbJcWby/w4vTE+l460Alnkd3rwz9hAl9P4Od6UVeIMLgvLLA+5Uzp2D3uC4go0PIMMNpTCe/yE3aqCmQrkTOyKdD+t++k6XA5CuBfvPhUDntytONvwaydlKilDuUTjNWd0KnoBTQ3PfAU1MPsrEW6SjOUv6N5qekECr6nzCH2cpUoZ1ln0D7aznIUO85RZo9S9jyjOVQ+d+WcS+7Q40TUpoQOc+ifZzfNsTJkt1HuxSD8DtRCwjRfj5/sC4fJyKoP5tF3O4ZsaqidyTHXFB+TWUPTn05U78Ezj4dkECvsPv2NJC0h8Wi7DKZtX2YNz0m1JxsLGRYLsG7REb1GU9c5yN7ehZTax84eD5fFTSQnT16VBtxw4dPO9u63bL91AluBNbxEMH/JEKCUSoQL7yintzpQfKzUcGe6WhuLheJv4Gwd9gncW7JKzPDC5fNkL8NtSI0lJ4feln0ZasCp+mCJQXQLcXnoscg7lvf0uexsRMz6A20xnqYhPIfcnPcO79VknEtE5M2Q8uHpQPE1kV+dhWTlIcC+sW2sq4LybBpKr7jnQQl4leDSIJmQRMVfxUXYUdzWj1Ruq7vYZQncjSvxPU5TJ21Y2YRDIh+paGZWsqe/2IcgEF5gR5AUW3KWRWfWW/MMOzadLHpimjWM2SgWq2jH
 WKguwNtM
 xmfTx5+lAUqQHUOFAUAx8y7DrI/CgPM5JfE+m9sInRdVFhiQESqddg5tSYeYhTalKKr/OLvtNVolYchFqkkBxLg543ZqXaDM3tX+FqbJAXZIaO7YeLv02Q8ABkTdi9BISDTm9TP7FaxBI+gj5AnHfjvoZfGoMHPax8yLcOOCRuzc6CrO7dUTfDF3+Y1tjF0Y8/zsVCQtO15hQCg3lgTluaxNoGVg81HFM4mvd2nkMpPRGw6a1I1NYVpKVOQxh7cyMj8bYxIJDNTdyQB7oE2hc+MNeam47mwbscmDYbTi6bPrfZSXFdchxEHf9Aio1JXhOd5zOhtOem3+1dSMjjoZBSd/7EOfZXrZnvXsNJAfo7qnLxaLXPdaqyO2FZqVGjCuRedttLCGTcTvOOEwi02UjU5j2w3Letc+UUy8cNjaqSrquhRTC+c2BbbPwD4WERlbOW21bK5Agfd8bgLDtjOn6F2CTxIbraqqyOtIWPg4UmUCPYCG/K8+iUfRaTVk4OHm/O2Ha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 4:26=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Inline zero_partial_compressed_page() into its one caller, remove accesse=
s
> to page->__folio_index, fix highmem (page_address() does not work with
> kmap_local()), switch to using zero_user_segment() which includes the
> call to flush_dcache_page().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Fixes: 495e90fa3348 (ntfs: update attrib operations)
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

