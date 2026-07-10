Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D9CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06AC66B00AC; Fri, 10 Jul 2026 17:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041956B00AD; Fri, 10 Jul 2026 17:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C666B00AE; Fri, 10 Jul 2026 17:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1C186B00AC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:24:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B7FDC3187
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:24:13 +0000 (UTC)
X-FDA: 84974145186.10.3B16385
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81DE240008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:24:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QAVnUe31;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyoj4hjMSeCH2l8wiR4N5JqU7D2zu2bS+BNg0w05A5I=;
	b=gT5fJKe636oCa0XBuMYQ+s4Qo8KUQ2h7IP1IMNgLsAbx68dJloUakEIe3/Z4foJ2B3zOPC
	/sE6yjQBHWFr+S/Km3tocAjDIRm9Jl06ri9sJKTKRIawBQILteflu49lZZwZfeFcSbo/8K
	5zgROYrZeyMiJHnF5YPrrpBNYbnjv+4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QAVnUe31;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718651;
	b=ubejiELQ7DVsnp5RNs+F0mOC9/vJ7bPXOtI66XiGMNzLRF3vzaOdJO2cqy3YhaRS+V6QNZ
	gDEB6fCczY5kqtMVjTQOD8m/Br/vM9gBi5tORdhizMBMtC17u2M3J0n1x8oMJY0RMOUrz+
	/vqB+pzdyoLI+PFksMV5onO93Vnx5oQ=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so11790026d6.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718651; x=1784323451; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hyoj4hjMSeCH2l8wiR4N5JqU7D2zu2bS+BNg0w05A5I=;
        b=QAVnUe31iW7Jdi3O55+vb2n521GtPVUy+6ocmuesPbX6KDTzcVLZxBD/m2uus2FapC
         aWCMRmy5hl15noMQhqYoMsJM6sZKSixBH4ekSmdJ83h6JSM6e1Z0fzOqFqSLNZmFw0oN
         RZofBXHc5KcWwaMFLWiBy6zKjQtn0vgGqy0A910AxIVNipB49CHZsoV9Aj/oTchbY2RT
         G3AAL+BrlwRXzeGxudA1QOen+Rs97uZRlQZa5KKMuiROW7kVsIxR9w+BvL49S4X1HZYE
         sNzjqH+Ow6kdf0MOTdd/peyJ6725dCxeAvCkuUjDsqAnfQogY4EUUPqY88D1W2vC1Rb4
         foBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718651; x=1784323451;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hyoj4hjMSeCH2l8wiR4N5JqU7D2zu2bS+BNg0w05A5I=;
        b=PFoAsGZro3S50hg3WsS4IiiDquxTnWw8JidQVgxWVrDUvOKKMxu69LsrBtcXH8ryXR
         eaE1MWKWSAdgzrIeoF2SXwCUcbAga6qV9RkEuSB4PHXQZLql8ppDQ2omtvjz7sM/CAbD
         QNnssQcZYfmP/wjUSMJtZhH1eUvc7RTGESE1fK7OjFGJb9kw43IpOJiAAlYvA2hXtFVF
         Yqpi4pxCGbNPaSIsOIng0RjdX/OHGlQtznkOwOYo/QqVk8KLwr+3wdeB3nmjltmLklSN
         czJCBehrhb0APiyVeZ4BemZxchpvfWxOXG6oB1OMWWydcE1TMR3LpGUbdhhpVhf/EljT
         3Tkg==
X-Forwarded-Encrypted: i=1; AHgh+RqkTRKTn9RI0SIrkD95liK2tFgWuilSvFzfU/Wqq2okEovP5e4L89k8ezgp+c8hzW5CIX2bZAZCag==@kvack.org
X-Gm-Message-State: AOJu0YysOJZt8VJw0fX7UlRdRtoK5N+UJTxrYxErRgjQY6rGnJZF2t+s
	LJMZMmUhxu9g4pWUs4xLg6u//IZPZ6GwcUs53ds3r5cS+PnwflK6/mgFwWgXeqXM/Rg=
X-Gm-Gg: AfdE7clDJBxxQpxHFwsuRzyu6rf8kI/hsIkhCuWBuhRp3Z8S48fWBCSGiH8OnAwbDmk
	p7vYn1AdSuMQTUvTTj+ZhCnIz5hApf6ilCfiFIUhCNo25OJkLto438irZSPhPbpEbhjvZjaChFD
	tkLUxXSMFCnlmVsdFZ4Wips7Mdx9MsCjtldEgR8CV3soz6w1HREpj09QPIipePDuXN1nBpV/Xm8
	+3gVlQTtPGiXd6RyFHu3TMTcjdbf8yqic+/VGyecpHWKBL/lAMcA+SPdNqkBoP2rE+tLmsOiaoE
	YH3HywNssIr/x0W6LFOXzAUFmht0NefcaR3CbPSrgLSJ3ja+uPm660IwhiZ091lnGmXaqHdBSnD
	y5qcNy62C38aej9f/vTLa6G2ZWBUCxnSliFbbNApUoMDiWpZ72z4ADB3Cau/pI2jcdmQYhh9sIm
	EbOdsasli4fUtT3VskdSLqRLcOaRmoNHkbXmmU6OztmhOHpgwdmt+xe4QiC5P2z7JlpCTR
X-Received: by 2002:a05:6214:5b10:b0:901:730f:5eab with SMTP id 6a1803df08f44-9040038208amr9843886d6.27.1783718650605;
        Fri, 10 Jul 2026 14:24:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd82e9d5csm50431486d6.41.2026.07.10.14.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:24:09 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:24:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 22/33] mm/vma: introduce vma_assert_can_modify()
Message-ID: <alFi5J3-UQtvTzxV@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 81DE240008
X-Stat-Signature: mphxpksji8e6gff3o1poyzryh3fdmqyf
X-Rspam-User: 
X-HE-Tag: 1783718651-252363
X-HE-Meta: U2FsdGVkX185OEB/FmcwwgakYEU1/XrSMnpgvwxKHNUj1r4NpqNjzMO+4fWDzWNKZkihO0N6D5UPB0jXehYmd76+2VokhM+iG7dmUC16ZLGZl98jcrtYdo/b7xy2fJ4Zpf9XtNfx+F9p6Jzsto6nYZofKXCs4fXEew3TcBTWFBs/T8j1e/KxgcP6r8ooQZBnV+X2bZ69eYKzeM0FRSEr8h7969E2aStrAHZV9MkWJal9DSLSo1gGyVtoH8Bbbc7/4uZ3Iyuk9TkEDSW2ZENmr+Rbt5LsPZKrNIbJcx2B9k9KxKdIUSl03/LZ6wCcF+QIyNiISTYaBVjIEv+QERSzSb5uGsaT0yz6HeGSl0k28XLVfDhZ3V1NTDBk5D+FPiumDr5BJzlD76iQyWjb9nMwcVTp1Qp5NqBYUcF1ENJDFFthQKO9RHp38VDlIsHUc4InkLAo/3Mf0YKDjZWQHImNVA3CnznTbvC+Crp4UnMRDPJKa29ZnHqbhuMw0ssA7B2/3PuGF3eTZtGJmeRYtyPZNhJyAFqsddabXD4icoRHrkRnGwuWzyAVU/qoLbGH0dbzdRHGbKRFtPHQ7EMPIC57TTXgnta0gzewj6hX7FujqVYY9EnDR4hOk3sIr8NwlCZhZFKSYj9cn8Wgj6EB/Jm3vi6S6GSzyCDfMTS7ftuFk1yQQFchFs7b2lWn0/R4DmH653V68fj3CIdLYWVTnU8nF+0bXtGGQZrKmUnf/VZU1yvctXm0CCot6JaBUDxBTUewpmaz9fT+IJJf6rX+ROEnxrdpVwnVO2+TpeE4vMXw9TCqoU0wBoGwvRyJF28hJ9jVD8MzSmwJuLIkKzbIvPHF7LKbNaxMmQGEmk2zjxa9hXJmVjj/CQXp0DlYZYZ+TWexVmGLKxLwtCDV2WZyk8tmNCrWcnjfmjvixlOG9DvmODzMDuMauwLbe8kO9XNyZevX/Nn+kYumzIjpjMINZoP
 nN5g/xGl
 w8vLATMVNN4JwtKrDygLvvvZGHxqhTv5/QoTkSZJUiI7KDrImcAE0GjKRszGy9SZZ72j4kJF1nFDRNYScvQXh2Rd1kvHFF3CwVm+jb27zynf9aGvg+0KhDYIZw93uGCwItFesAY8yNvnzDGt/jk1ZAvUAkm97Z46n1rXEQE/g5VswbI5y67KoMNhSDoXWOt1OOa3hTykmyUAgf4AI04+NU6cMbqw56TIXl8WdI0Sqa5gfurMhG4AypZ3XzpZlXAChmZCTEKZWipPy/vKmx4JBPcVKsjb0mYihYU7XQsX4xgmc1gOuC8oLIb3QYtUc0XLHKQXH4eHIcYp3cSTariKA8inhm5zqLulSoS2H6iNqcrcBFpuUDFnthN5zuXypY7QeH/UdjvpqS0eQw/UXUhK0WVBmfbmZWMwIxo29DyD6ic2wpg7mlj3k2o4I1GgkS0l4tywl/di7Cc23MrkklZDjFjdyWdubvw/U+g0cWjWXwqs5aUqs0cyfnIBvUpq9g0FqZUlTUK/zZNDSIrdfiNEAJ0AFWwUGVQY7M2cB8bxjMMQa/2qyi31vCtQn8beMYRijR5Y+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:17:03PM +0100, Lorenzo Stoakes wrote:
> vma_assert_write_locked() and vma_assert_attached() are useful for their
> own purposes, however VMA code absolutely does allow the modification of
> non-write locked VMAs if they are at that point detached (i.e. unreachable
> from anywhere).
> 
> It's therefore useful to be able to assert that a VMA is either
> detached (modification doesn't matter) or write locked (you're explicitly
> locked for modification).
> 
> Therefore introduce vma_assert_can_modify() for this purpose.
> 
> While we're here, make vma_is_attached() available generally - if
> !CONFIG_PER_VMA_LOCK, then there's no sense in which a VMA is
> detached (vma_mark_detached() is a noop), so have this default to true in
> this case.
> 
> Also update VMA userland tests to reflect this change, correcting the
> previously open-coded vma_assert_[attached,detached]() there.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

