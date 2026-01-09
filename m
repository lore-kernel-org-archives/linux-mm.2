Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CEC1D26D94
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 19:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DC16B0005; Fri,  9 Jan 2026 14:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB0A6B0089; Fri,  9 Jan 2026 14:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D5E6B008A; Fri,  9 Jan 2026 14:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18D536B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:51:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C1B38C755
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:51:15 +0000 (UTC)
X-FDA: 84313469310.26.2DD432F
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7DC101A000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:51:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=VdqRLgxh;
	spf=pass (imf19.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767988273; a=rsa-sha256;
	cv=none;
	b=yfI8PvG72ccBTQ7q9PuYYV6CHAYfzW+xT66kyui6ZS/T4CMsIOli3V6PyT65akEYSkWGJF
	85RdVOEsc9v0UU1Cd1KgpcQfdVofeAnT6etidzgeug5bC5P5yur4gkCCwd9VqFHh0SecRD
	HXSwJ7k3LjyEL9p4KsQpoF9GMjHhpCQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=VdqRLgxh;
	spf=pass (imf19.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767988273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HhQrwHPYHs7tKqcm2gO84BH3BiFPGmtv9DkIKXa95Q=;
	b=3f1d2pT4xN9FDDNLiLTE15bCaqHWZxxdJN3A5PkTWGI82HiYw/qYmAue5MLQSr3SEo2toU
	/sC+IGN4d8Mcs1ef0fykUynhc7AZTrU2mwUnEPN0e0vN9IsLk8NNz3y8u37GCWS6VMN4fk
	pNQxQsihzrgaKO2IThc7J9NkNSWfmPs=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b25ed53fcbso621959085a.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 11:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767988272; x=1768593072; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1HhQrwHPYHs7tKqcm2gO84BH3BiFPGmtv9DkIKXa95Q=;
        b=VdqRLgxhysA2fpopFpXqaZVrN8Xrq6FArBH5K75G5Zgk86Ke1E0CLgdtkDnQ5IazY9
         II987h9jWFAwLufSUI5/pIDDEVcUvABYrp37UsaPSPPP5I0ajtDZ0ld93M4HEEw0Jdzx
         2CqJGFPHZAdJbRJQZvALGCmoxP3pF1khFScpHo/6GeCfeBRbf3ozeSTNRw9OTMQeHLU8
         TD6arNMFz1cPfhzzv0axEXYHWkjFvWYXYPRmBQRdGmN+DEELBpzBv456mGfV80zEzdca
         FmqsMWAKiyRsK9D0AxF2wYLJLFFUXI+AjAjo2N1IZBk4wX9qnah8je6wN56zz4AqqHyj
         NwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767988272; x=1768593072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1HhQrwHPYHs7tKqcm2gO84BH3BiFPGmtv9DkIKXa95Q=;
        b=ZC3sSbJY5nqSjMAs+Yhhwf7z2ITggiAD39oIftjlkVMW6AFSYLAEOYpHCxa9oVCoVp
         mtp9JAeXLUZpUL4lcd/wLn5mdJTWvJ8zfCqIT4pT1tfat5f6xjo7JEYxava+amWvUWIm
         uKZQC4gY+Eq90Gd2oK1RnfM0Yn/92xNOQpxd4UjQcN9vqItITMgdWVapwt53GCSWlLEc
         SnywMKXy2lZoybzyA7tP23Bt+WBSxSKQ7QlBplMKFOF9CgvCg4nuREh35UyPGOl2EwWY
         yRD4UOQH+TCEwv79UH+jyJAc4uuRNnHcLiqVbGWGmk2s1vI5qXMvv/mIHwTu10e0snQv
         l4Aw==
X-Gm-Message-State: AOJu0YyjECpWiYLr2ZTB97oGM5Gi5fQeY3IwseOvLDg/0j/wOUscgRWi
	dQge/H7CA9VsRbylS+wMFtPTzFnXBxMqoUsm1Rg1PFzWBH+QqP+cl6tSdz+95XyR6RU=
X-Gm-Gg: AY/fxX70CPADQdwxxmdwh2NAtXDwQG4tSybIq2TuFkeKlCQlb8ODpSK0s1wrR24ci+u
	88yZunMtnFwfAVw2Y1eeAD3zd6qLIh0P6K3t+p1nYjmUkzlsZv4Gw+Js71i6lr9IIi83HkAjizp
	fo6L7iPHpddarK0rxXgG+tpOyGrJBcEfEfoBFgHAFC/XurDmVuXW5EDD80z1zSEZOOgDtf/PmX5
	yOIki7mrkZk1bpda+EMTnBdZkrdinpZ2OKTVozRbmC83QgMll/QQapDfgFKmCBwYGeI6/XAAXng
	/xYjRvZaYkbVy+K9RdFNX2p7cl9VIZQa/CMxQCgmRcoR3bikcnQhdbElSSYRhSk9eysSSCQtviJ
	1QTdfD4+GBJO7SvwVaYFCLYIrdDVeu/LtlsYOjohTWsvzwO4BkTmzYQdsIanCHsqP+YuVSWqPIr
	96YZH6IS3CGy46JgdgdpotinKpzvZEiYW3+rGE5Mah5wzg1uem9xz7IRwXVORBbgbGu90=
X-Google-Smtp-Source: AGHT+IEZlrPxi+avVlluweNPtX7JEzZwtpBy5iyUb1htiohwK8TIi/Gv4SrQxJebEESGgl3Hi3a9jA==
X-Received: by 2002:a05:620a:414a:b0:8c0:995b:e729 with SMTP id af79cd13be357-8c3893aa18cmr1552234485a.38.1767988272405;
        Fri, 09 Jan 2026 11:51:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f400b59sm888623785a.0.2026.01.09.11.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 11:51:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1veIVr-0000000381J-1kSA;
	Fri, 09 Jan 2026 15:51:11 -0400
Date: Fri, 9 Jan 2026 15:51:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <20260109195111.GQ545276@ziepe.ca>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109171805.901995-4-smostafa@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DC101A000B
X-Stat-Signature: nr3wbwxxa88u1s1damzk94cnstbdy4de
X-Rspam-User: 
X-HE-Tag: 1767988273-281072
X-HE-Meta: U2FsdGVkX1+nhWbLA/foGGzzJ6CC0GqkOfoGL6KawmIba/SaF2l84BifO18NCZAWknkOBSiRcNaRzuo72ek7LEJkru0M90oNmV0ESbajBunK1wp9tPt+xDZcZKV/e4YJSWE5l3ztr/aPFNTfwgoBe7+lqJuK91J3pIb4iKyUJWa/7BO8hUD4B+3pmUb2rStyxp3S4JUGgBTCC5Z2hZK33D1j5ui8kYl0522bfC9mAnazMwYiXFF9wGz/vY6Ebpbef1FxDwpe/Qin9dUwTFhnaFq2t9v5yKVT1hq750qC26dP3yiFiU9ofNB1t7Yoq2Zk3nBAxFweE8EgDWAYRNuHc+Y0YaRtyM5smVWJ98cioTKnoY7n8rdgNS79nnBIiqj1jLrE9cqmu3deLwa6mi90KIfJ8RWBAkra73cU7z6mQJbUS0hB9WsA3ruwx+kq31M7NNK1IPKEUFg7/BeC8cPCp5U11VyxVNEs+h+0ANAfBmFhknIx2M+Y/pLlcmetV1aeXBquEq5ovEEk6IaLCuUapGCgEGkhVtvH4C+FLi60g5tGEIW3Mifb7dOqIQCSF+OYVu5LHd6svP3WHYQzPLv6K0JkwkqyQWyZoDCqJ41gBvVixi2eSNZw0B8JwgNO6iyKpumqb0YOkez3ha9T1ULWR4DvzEwu++ktsWg4cjZDybhdm6tL06julr3DQGpJcMkCJolA5DRag6JL1O1ZeRUuiNebibMa3oK2Of2e6DvyJRN0Kth+izTuG2ZX7ql65IBolqRSbIB1Jcqid/x4DqLx4UHrPT05SVBE6DMU/PqygXXsCsxlky/thZ96q2rptqFQ0a9eGsogPEXrFPmGZXTZorMmqN1J3yRvRqPXHa7Kqep6VdLvc6i9aEZEtR+3xAdkDhldLoJDvEkZ2xoFtypeWYNCZShpKE2j7ThFcS+vEOKxBtI705rSmJXrduv/JGWC3jHQSrgxelVL8ebPp92
 OlYC/0lV
 VR2HZfbaKFTzSCG/pbERxhzBH18/gi55SM6SeeWO7+iICVv3Ci59OlgIZahXsNPBXgqfA/08YwCexMMF1RTMdFuwMmwC2w1dwgX3itTlMejmFo8K+1E3HjomJWl0c5gNidefYB2BQ7m+7DR3mIhjtZ66WAY/kFo/4H/7c1uCV4i3sOQZqNqLd5e3JD6SPnanQM3iQTYuM5qA29PaYv01I/pCGOSBYnghTGGMnPTWgKSCMXXX6mK2SkIYe6C9hqwqmQ0pqcz4iylqU4E9OjmdG1IkeFU762RwDcNwG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 05:18:04PM +0000, Mostafa Saleh wrote:
> +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> +{
> +	struct page *page = phys_to_page(phys);
> +	struct page_ext *page_ext = page_ext_get(page);
> +
> +	return page_ext;
> +}
> +
> +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
> +{
> +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> +}
> +
> +static void iommu_debug_inc_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);

You cannot do this - phys_to_page() can only be called if we already
know that phys is a struct page backed item and by the time you get
here that information is lost.

Probably the only way to resolve this is to somehow pass in an iommu
prot flag that can tell the difference between struct page and
non-struct page addresses.

But I have to NAK this approach of blindly calling phys_to_page().

Jason

