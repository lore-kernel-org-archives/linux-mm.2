Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7D9CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADFF8E003E; Mon, 13 Oct 2025 08:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F318E000F; Mon, 13 Oct 2025 08:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DF48E003E; Mon, 13 Oct 2025 08:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2C3D8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:50:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95661B738D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:50:33 +0000 (UTC)
X-FDA: 83993074746.15.16CBF81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0DEC810000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:50:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ApjK8+TF;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760359831; a=rsa-sha256;
	cv=none;
	b=otOhFdU8mGCbwMmb1IG3+9dwfZmF/PIoJVNuB27QviI1JWr5gYKCSMpsheHmeSJ1rh813d
	rbieHjrgs/346yGL5szIC4g7oOR570F+/Prb4rO60vMGBov1XX2jdlzxRd/G3SlHS9jMJ2
	fEbinpNEjnT/kSZF64/gZQh/fhFRk9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ApjK8+TF;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760359831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmLpGViBdbcMLzx1bb+Kxqb3+3UtyUNscErHdno+a+c=;
	b=Iu5XI7eLaKhEbf3QXKxajTKSa6YFjbttUk6sBmx7uyU+KG0afRWu/YGqy5L7D/kyzLZkC3
	lGR6wSNbfYwhftAU1HPBro5LsKYjJIkGk3VBO5mEp2aBNVdGsOx+FywDb9rUlVzLo2n8yR
	jE/YiXHov+0SaLLAs5Cgud0/6Cf5EYs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760359830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fmLpGViBdbcMLzx1bb+Kxqb3+3UtyUNscErHdno+a+c=;
	b=ApjK8+TFmj8PXajDObDIt9yfNi3EoONxgd2NJAwnKwimYfnsS5Oir/jBFUCDgIB+kXO8Bd
	hsEiNDymu2Eb70hbPA/2uDUyE3j1Hld+btEopoW/4UU4jt88msJmn0VS3QcDn/KIAjykAZ
	pVUXyuQrVIsA8qlwe/Q2TGF5t5bpQPY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-PoI880cyP_maRRIMZ3Uasg-1; Mon, 13 Oct 2025 08:50:29 -0400
X-MC-Unique: PoI880cyP_maRRIMZ3Uasg-1
X-Mimecast-MFC-AGG-ID: PoI880cyP_maRRIMZ3Uasg_1760359828
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e3ed6540fso27944775e9.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359828; x=1760964628;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmLpGViBdbcMLzx1bb+Kxqb3+3UtyUNscErHdno+a+c=;
        b=NKkqNMwOXmCYONjLdcv3ruqUQwislCsvYFlDwR95NyMnnBScksJXtCEBJF1+z+Rdcb
         BeOMJ6D9JqHxXRuRDtyjxIJxBXJ/eSWsRtk9s3lQpwFkvQhHlGwCyPrKVqc1qGi/mDyK
         hlaPJbgtyfQbCsDIE1PlJrz9gPL24ov8Jk1VjiKdYVJ0gVay4k4jk1ZH5mcCfSagiFCE
         bpUus3nbqhSvPKYVvDzKxuqHm3f3ZOQvmJSx2EgG4elqxcnO89WAkkOB8lYe9iRzL8XA
         jdiNHbMjFroSNFJoTT+hBa8NqpmTt5h/UWvTl6XpMGxZHqSL6cs5c3ZXrAj8FNczgbzj
         3vBA==
X-Forwarded-Encrypted: i=1; AJvYcCXmbA37wXGweOOn7n+6nMG4xkvkAVMYAY+hfF2VncA+9BGVsEn2hotBk8uI/Ap8u5b7KqkGholKaA==@kvack.org
X-Gm-Message-State: AOJu0Yz+oTHOnmEgDvmXLchtmY5rhkrMd2PXrxcCFa5QQrXYC+ohzX2l
	UxI4vmMjfOvzBriKqaf/0ATjbLZOLglOE95u0ZxnIYkL3k9CK5f5X8/4eMbDLs0hszRuw7dgZKe
	d6LT/Rj9sS8cdmqW8M4xlvQKCnl/m6DfBg4U9IMA638WKNMqLLZSb
X-Gm-Gg: ASbGncvvPffC8Wzel9LVf5F7fE3xiovywoZpBRKBAfy6jzQrprric9zNd+PGqJZTlfE
	Jx5RhkPNqPxjE4Xv2TVlpJA8q4Y9L97BE2ajbGKFTQLb3GBMyDbVmg8/HnHnR66DhcZdIgJG15m
	gDKQGcu0vuWfVsWygf+W0WgHoW0vyfmOrj25PLe3pTjMFZti8SfNpv/CumIoMjqPfkajIShSKv5
	IFbbveqs4ufFefxevOsN0TdiP6xqxpdA8zT1OTb2CtJz+jx8CQMQPQd68UWKJHhmw+rxVWZVEd+
	1lVrZKktqLMmF2NdYZmjTu/XmQT1k17tEKLeHWzqLBluYxgSiqMeZFYMKc7n4do4xf8YXNd3k4R
	TciI=
X-Received: by 2002:a05:600c:6011:b0:45c:b642:87a6 with SMTP id 5b1f17b1804b1-46fa28bbca1mr126817145e9.0.1760359827994;
        Mon, 13 Oct 2025 05:50:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMMoKs4VS2gHV3gKsNnQk9DNjQ77BVoRLFBciblN4uYmPY7ldMdNRqp+3ZL0M1o/a3ErG8+Q==
X-Received: by 2002:a05:600c:6011:b0:45c:b642:87a6 with SMTP id 5b1f17b1804b1-46fa28bbca1mr126817005e9.0.1760359827614;
        Mon, 13 Oct 2025 05:50:27 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49c3e49sm183435545e9.16.2025.10.13.05.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:50:27 -0700 (PDT)
Message-ID: <3fdede63-0bb7-4618-af45-6605ed25b6c0@redhat.com>
Date: Mon, 13 Oct 2025 14:50:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] mm: remove filemap_fdatawrite_wbc
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-9-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013025808.4111128-9-hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hrVWOMUqHznOo-V24s0IJUpHoAxS5tU1OYElyrmUou4_1760359828
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 769khmhi8tza51inrgtu3aa8ce4hcxi8
X-Rspamd-Queue-Id: 0DEC810000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760359830-295885
X-HE-Meta: U2FsdGVkX1+FrzSr8dsogG0mm9qgYVfECG70wJtuswD113dphZwuh6ge56QPQnh4SPAUpmKUdblxH1wWoWHms3Czi4RbZjOl6+0tDEyTOzaBlpJHaPqoAsyQIkr/sBHtgjvTXd6pAvswus+3ymM1gdSObP9OHWmKJ+eG54p/7TwadPwn9FQrUFCyKCaaV4ViDhy+6aJB7xxfW6ic/XBwrMTWvaVL056w2htzChYbECVFw0foLi05tWQ54L5QTtK7w9qVU+UoixcLssojtQtDgtULthx8MUVVYe51zQzSUyEbuErHV92tVVf1cigeveNUMY6Pta2TI7rPjg+sjMdsOGvXis0LNdMD15mDfsUotRcexiToVw9pRh+zv4gYxv7PqcnIEVYFxWS7/4N+7lJYZYJpF8bpfqhkkGkHnxsAsbGYKcA8gpDRn32BqFcKgGxplDf97zu+VFQxgOm0btJv46Tkr2/3Qpx5/dIzLv7Q+6YU3byMIE6DkbZ9CGAIfjoJkLwGdlUz//2hAESonUobP0ToEYfOpbc1frcRGhI302lpGRLddZT61GfxPs2O9EhxmVeY8HQnmmeu/GVaSfn5bjBHfsyrAVJ36gFh7Axu/juWQvD5+VnIuZveUelBakNuIcke9LUB+VWmw1AXRnMeSLgZA54MJRvBBRwprzdtTJGHM/NWUqMJe5mYBcim+cmecVYRNWINW+XzH+YYpO9vsQohMr6QGg637sOU4lQCe4zWm1FXvzct1peViXgS30HWG12jKx0Igd4mHGITbbHUox9El1leY9nlAr5a4WldT3G13gZr2EScROP7dVug5bhO3X5cbqbudBFIJct0YABcAgFstOnMrPnO5Il5uJsSifeoJraXkaMR3ONiPcA71vr8I3BpKgrrxPE+7+0RaDfaSXvi4eU/x/37WdmpdJc7uRwQHTyjKlKabMMgPUr8mRlxXhcM9mEfkQ/7wL3dZSj
 Qf6ABHQu
 eKgBO02baW+8g+I81eoO6UCWDiRLVu6qpXBIpwv9kDVMAP5ICEJVIfox+fHqqIytz5pE3s31sO+Qxvs/CWujwc6HPZYHMad/bTtC6FjBiDdoCgTSTj44GZMJgDf0uNe+2O1R0xMRjQKGYkhCWlOPcRoblpC3zFCJL2E0IYtqqM8cbRGrpILLmAahA8HXgNtrJUtsY97s5nCnZCQC2iyHXn7TbHoCWEoR7sLdl0HGDuXA8NtD+0B7s9qQWniEp5Nxz3+oYI+sQr9nNiUc0y50RPWbPmpPTzRyboclo+2F+yrr5AZCCAYXWSjqQqMII221kNMrQMy2tEJuxRgQL0Xh0sT2zk676poA3Ry/OJO/BWNDkb4fo8EbLNWjQCcHn8a+6vkcflC41+cUGF0knTKI6g66BJ8fhj5EoImofP4G/fRNH1sZXgFJecnDvKCpsXgegPrp0jN0zKG36Ncg94UtGrtojG0O+OotCgtm3/V/7dRR+r+u11Nls2Rvcls+BfCOiDyEvXHjeymk0kkcCn9ZSelc+9h/78Lxh0KsR7clQyrPiifM77EOc6cS2GCfjVNCPC1Vs1l5BsP6WYEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 04:58, Christoph Hellwig wrote:
> Replace filemap_fdatawrite_wbc, which exposes a writeback_control to the
> callers with a __filemap_fdatawrite helper that takes all the possible
> arguments and declares the writeback_control itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


