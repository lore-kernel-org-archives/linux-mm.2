Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C08CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CA38E0007; Wed,  5 Nov 2025 12:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154DF8E0002; Wed,  5 Nov 2025 12:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043D98E0007; Wed,  5 Nov 2025 12:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E786F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:21:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DAB512C41D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:21:19 +0000 (UTC)
X-FDA: 84077219478.01.94E7053
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id B159A4000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:21:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="R0RID/r4";
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762363277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cq2mS+yWhZev0zm4YEm/j+lSP0FbcQSTW4gUm6tSNU=;
	b=2buwrQomgCS8v1rqEfAkPBGAKNZ7ZykrFDheWUn6tPIXUBEG90fbmoTDTDXSCpqknmtfuh
	LrnFIiakwGTMtWMcDYMiVxDlQQ35cBgOui1yx+HoCtKhK2W/tndaaxtHCaOARCGHvZRiNg
	Wv/VakDUu4Iaaka/q1KKCAO8hgbHKiU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="R0RID/r4";
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762363277; a=rsa-sha256;
	cv=none;
	b=lj6qQrs+WmKgsbNjSdDncqJDvNYSxe1FJDuKmqgP/iAnqR3tNejpE9FYWafIJT+rfI+nmi
	MaKUn5PSIeVOp3+3jFazC39eR87il85yh97wvihciS232ejDIGU73tHHomBxqkHypn6mqg
	CfpT0xPdn5LcegEccqmELjHN0mXPy/k=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87dfd3cfafbso1391136d6.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762363277; x=1762968077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cq2mS+yWhZev0zm4YEm/j+lSP0FbcQSTW4gUm6tSNU=;
        b=R0RID/r4P8Hi/pP5zCIzu7pEckr/Hc2tdMQjrn8Q4lbqWdzNAHASi/tDsDaDubz7sC
         fYXu62R0LhUgpxgN08bA3nYYoT5nlHap7D/5jpSiy5dvDgPfiW+3Hgn2JaFcIci9z0Zz
         01liHXsSVN9qizd3+QEOB45Zg3UDaJ/nmua9d6D+m8mET7j4bAIx7hZebBm1mYGWtAQf
         qLGEbVcfbYf34QSPhFwcXW/agHbri3H1vVEhSNWsyaj5NOwdNFLNihMAeATyvrQYR8Vx
         6PCKEGWGXZSDohXy1kyW/N6vK03pGKl1ICbPvVKZKyUTbgAcN994jQBsEz7uxShbwcPR
         2VAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762363277; x=1762968077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cq2mS+yWhZev0zm4YEm/j+lSP0FbcQSTW4gUm6tSNU=;
        b=GtbzpPMPoL1h+SLnfelsI8SrUD9F9uL8xa7SGGRZnYjLmnOfbPM20NO0/3wVMCiH72
         h9afJqW+Q9XhT/j2xYIuovLEu97XK8dH4IuxVT/Ni3I/3OTpqFfoTQonAQxr+DWeflF7
         ciW0C6UbDm345FjBucOD+cLTIAhjn2m/SRPdAsQk9ERsZc7Q0hxOZv1OHqgFZ53DzRMN
         P+8lFoNN6liuG/kfpJ5glsRdSXiunh5pS6vK3/XJ90/3wem5y03Dzx6Jdr6Tgf9Uy5C4
         zLhrSgIcqdFrcfp5FrUPhhY5n88rG84+TQ6SieHCzRIw+E3PgBaPjKY8tVJKezSSCX+A
         TGSw==
X-Forwarded-Encrypted: i=1; AJvYcCVmtSFnfMq91GRmNOEX6UbJDJ0eCIwWGQGmhqWlaoPDcusmu6MSArt8GB+NC+TzsJeicU7qXpdqNg==@kvack.org
X-Gm-Message-State: AOJu0YyjBOkjmfA2EeS98acZJdmttq8FFsuse0pSs1EGmZ8JhzAunoM0
	lqhe3xZMHnUArn+jU5RehHD55PohwpT5BZdZSBLs4G+p2IySPfKseJ8r9K/7oR/+e38=
X-Gm-Gg: ASbGncsSaobQXQE7gI/mKDya6SKz+ZrOxwLyTZ4JNUFBK8F6dffoC6jpuVPHhGMi4z4
	0LbszNR1GlJe9NnH1Z7/pu7ctbBdlhXRyB+A4UqPYfNzKeJ8OvFEHP3aV0HuygFNSs6gJgfD+Mh
	nex5koOs7ZOMLKvdYOSE2JNmhZ49TwyeSCPw/EODXwPs78oO50Ipl11GMog5sxBlIW/q2q4FhYI
	cJPCIRnvE1cocEY/CtehJPlgB3nEn99MFHU2O2jkZ2TavKtKGmIvTmArvAuQx9TMhXdMGHp4pgH
	aQAMPw9O+uao7mA9ccPdzQaRbZwYqB7SS8DRrDPW53rhJ2xqrvy1Fxbfosu2QrcdcQP9jhl5o2m
	UTNm3nzDXXnaAc4JIbPWSxT3RTUDo8XQJv4M4zlMli8YKBsibhmO8dO78IBuNicSTG1Q+nBZ6mi
	kkZN1ipH8MAmB/W54uO74cWyyjgJLltx9RK1bpMa2u83eXuw==
X-Google-Smtp-Source: AGHT+IGCK5Ht7P6eoqM7YgVZ6ef4jlofMTj5LlbxF9x0JfdkYp0y/H774e8UOGf7CmqXFow5BgQdlA==
X-Received: by 2002:ad4:576e:0:b0:880:5779:d489 with SMTP id 6a1803df08f44-88071095623mr52524556d6.3.1762363276490;
        Wed, 05 Nov 2025 09:21:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880828c457bsm996916d6.5.2025.11.05.09.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:21:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGhC7-00000007Bv7-1e20;
	Wed, 05 Nov 2025 13:21:15 -0400
Date: Wed, 5 Nov 2025 13:21:15 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <20251105172115.GQ1204670@ziepe.ca>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B159A4000E
X-Stat-Signature: t9p98joueiupmxm5kow3wfoaeaqx61cj
X-Rspam-User: 
X-HE-Tag: 1762363277-938137
X-HE-Meta: U2FsdGVkX189CnRtvIDNNjwEGzJorv2ReVfUKeSv6Z+XqjAS85W/CK3dVHsuMV2u+SD9kBDcB2O2VyjUE7Pm4l9yhSFJIDV3oTl4mwHD4aeWKEZhovJ7/0jquxd8Lvu1W6r2CLFm3wlzLn1VErMtHlTG/HrVjeDaTK4fdWzIVtHKvJM2/UlYYHphabNX5+GUMDi3Gct2yAalqEZ6E2/72mYOZox3HwZA0YHn5ItbwmpLAPyeUtl04XnbvafJxX2nWRkVwMgobtxMJb4fFcXovC1QTTzuRJZKmOY18ynENNA1mWbJYVIlyJeam4QZL4VstfnH8acsFSQ56qyrzT/+dyjkOrqwE+2/N9coI8EvEmyFUxdKqRFqUmHkkENQvek3E8eq61QBMtIaZ6ErHXdttPUiDUY2MlEM70I8W5IWdour8+A6BWTCH4kU7nRsOGxalgWOmmF0iwEMs6k1/r7vp33o5To2BWVFnv0P418XlABjwIzHeIlnJdZRSvGMGT86vWw6N+CqhxXo1ntwLW1hpN6hinF4gfXiO3E13eZDG5Ji+8WQdXam77Y9M8roHPDprDWqtMm5tTT8/irM7JSBfnNWQHAbQ6m/R37iLB8yWeAbXM4zaXu71qDSus//Ye/g2g7/bHjeTQg8vyZHo3/AcHLwDP4Bp4dw2+fB5O+QG2MI82e78GxOKT/xuidnb+fdIcpnRgKwlhVVPNBP2H+MegvPneSVJHjptrn36EWe4CQ46gcN9OCBlvqhPJLh/oPKlJKyN50Nfe7QPo+QYiYEsDhlWOFTIQ5QIHilmiq2jyJ7qv15G5qXFyCI8n6gyknCfyDX+ximQMlh3Cn1Z2l/E6+4RlKA2T0fNE3SjdofVoPMVUXiAEywUs+PXHAuyXqbS8MCfTCZ/E95f8DVfDSC9vGmvVb/PKGw4sfSQxb9fz2kIKOm0cM4TI4+5kGc3ry1fN2k1cFHEliF+dFzR26
 tC5CHrQk
 RX5xE5z9iNXEVCfh0a3NWHVp+pkPZHyNvt1Ph0bIMyPAKQmsx9gxabK1z+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 09:42:24AM -0500, Gregory Price wrote:
> On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> > +typedef swp_entry_t leaf_entry_t;
> > +
> > +#ifdef CONFIG_MMU
> > +
> > +/* Temporary until swp_entry_t eliminated. */
> > +#define LEAF_TYPE_SHIFT SWP_TYPE_SHIFT
> > +
> > +enum leaf_entry_type {
> > +	/* Fundamental types. */
> > +	LEAFENT_NONE,
> > +	LEAFENT_SWAP,
> > +	/* Migration types. */
> > +	LEAFENT_MIGRATION_READ,
> > +	LEAFENT_MIGRATION_READ_EXCLUSIVE,
> > +	LEAFENT_MIGRATION_WRITE,
> > +	/* Device types. */
> > +	LEAFENT_DEVICE_PRIVATE_READ,
> > +	LEAFENT_DEVICE_PRIVATE_WRITE,
> > +	LEAFENT_DEVICE_EXCLUSIVE,
> > +	/* H/W posion types. */
> > +	LEAFENT_HWPOISON,
> > +	/* Marker types. */
> > +	LEAFENT_MARKER,
> > +};
> > +
> 
> Have been browsing the patch set again, will get around a deeper review,
> but just wanted to say this is a thing of beauty :]

+1 I thought the same thing. So much clearer what is going on here,
and I didn't realize we had so many types already..

Jason

