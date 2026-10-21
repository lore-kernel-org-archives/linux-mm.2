Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3396606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=FBC8OEah
Received: by kanga.kvack.org (Postfix)
	id C90686B07EA; Wed, 21 Oct 2026 19:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42296B07F4; Wed, 21 Oct 2026 19:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FFB6B07F6; Wed, 21 Oct 2026 19:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC126B07EA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:46:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EF66A7C53
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:46:52 +0000 (UTC)
X-FDA: 85348271064.15.B5F5543
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 331A680006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:46:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FBC8OEah;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792626410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5hOymfjgaz7xpjT1ssIdHSQ+wD4cuNPKUAfRnejzdg=;
	b=s/C0HAK7lU7WZD7OWuqMH16CrB5VDVKRDeS5NGZT3yZI/TZsY03rs4WFGI5LQirZLfZVGF
	+2wQemjziK+97yD6+K2vs7BwneRpLzZOn9fbpwJw736mF2lE3cfEjuQxN+Geov2pgdH0TF
	1uo+vuiGbmPqBxKia9LZSor1clo6CV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FBC8OEah;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792626410;
	b=N0Z8zwtuEg91X6InoQYPlU29zMPlkkfn/4QZvJK7zY0/OmLvroW93QUGfFgvfIsFkKvg+l
	b2hcGzYbJQ32Eihc5+FIksKhozHhJJUpgSZLtwTYimb6QPfafdB4xA7VOSk2NtxLY8RqY4
	Eshw1Aa6uM/X6vZDQwYqRPpIx/nOIe8=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f1cf92c9eso127759685a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792626409; x=1793231209; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n5hOymfjgaz7xpjT1ssIdHSQ+wD4cuNPKUAfRnejzdg=;
        b=FBC8OEah+MVn+W58llvkn4TOv17IEck4g7hz8zeQMKTR5s3OCDTQa/YzIooRKkZoyF
         j2bfvNLxsRDhzmZR8ql5nvuzR0XZkqyyr1BSKJFQJVSAzed8T+5FX4utcVJITtxuzPkL
         NvVuJxT7FF7YIfoKBe30XPrnZqieuz+kkilkFJwxs5+rYaj6Mp+A7hKZuhA/2INrdemD
         aOy8l7pxY8ZqgVqeWWuU4vKVRFlHhC9mVWf7R82XWeLj8IO8sjKHfMWdGZ62UQUMRK+2
         JFs+apxTxMDLxmC/hHeVDtzvt5mt1wU3HwL6hMoU20Zt4j1VcufYk/NA+ggql1UEPfq8
         S1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792626409; x=1793231209;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n5hOymfjgaz7xpjT1ssIdHSQ+wD4cuNPKUAfRnejzdg=;
        b=po4mJ1/ND2CQzw6z7UyKju4wEwdYcpWIqyZpD25JvJg0rpchELcCxR18cPJrmaA2vm
         ++tufXoe3M7n7g9P2VQmS1uz3R+3q0q47MAzJlSysUcRnpFTpVBPudHWOu4LmEqtRQvD
         sc23F8dip7QTGgnbkayOE0C8UNP3iq9RCi1ms9HJnZxjL0tctOT1M826ZsqXOipj8y+b
         rOLj7htf6lXv1idUmF2DePasOPJ+YdtLdliugq+M0shxNx5y3e8iSYXKfYrLthWpgXjg
         mgoXShkmn+vDwkfY6EJ4omsEwMQsAqLalk6m1cRZ8PbYASnQXx8nMEJ04kl2B0n91W0Y
         WoBA==
X-Forwarded-Encrypted: i=1; AKwUvBwfru5qcDIoZ4ZBGmmVBZCX4EvCTK6JNMFjpAs3sGJw/BUZ9qwW96Gjhd24ZIWyyM1E9Y0zaIHQzw==@kvack.org
X-Gm-Message-State: AFq9FYIz4KD22Ask5XuyBMn/3lrmu1vD2nwOf0wx1XxUPNfBL9zS1yZp
	Q3gKawEfTOnj3L2dJobpOvkHS9w9YxMJDtCZ/xUe4suAt5JSP5J6nTy5SnFOaf7jHr8=
X-Gm-Gg: AYBFou3/5OLD41FSQFBne6/3AGCzuRKOS88jmIgIOqpQ81D8n7F8Wc4MtK2YDvfRqN1
	kJI/LYj2JbdnVtDjAB3gsPv6A7496WS0r7ONORmOTlA//hoPCVYhxhmGSpLTpt72sYZ7MSg4kwP
	d5dXSXEFjJHWcmNwX45pFeXXPYqodiEEpxL8WhVrKGRgJnA95cgfZyGR2BuNb/bRzES86fyhAgZ
	/n//rIPJxyUcwb9d5BEzXhunKhdOz6uaK9X7QuGcb8CyT+IjbvhRJI2Kgwm1IcKqAy0E6FyE/gb
	zVtpkxljWyzPqw67AyCalvtTHKe9NwXRpTNUgPr12MA0itITn0TmrPZcBdH0FJ57ItqwunPm32s
	NIRFQLmIVHDADTvivpSfLQllJ2xdG0Y5d9sXeQBS1mZx5U1FapGWA8TBzYvxW0xub6tZbcr6sBk
	DyI0dj1NoED1FEC2VcU84N/Xl3cgRlqIGEX3Mc0tXCNIc6ajpAwf5yOAtCYNhZVMRR7VZzsFw5r
	OSBZibwn4mAFhZ1kpvzCNm4JYKdyDBSrX3wg/yOtKLzCY+OAgw7fEPJsTyunvucAZYPqkcg7BoN
	yQdbOCJjT5OJGqTqM+odWM+SbUFci1sr4F8OYBX4uiswdF3D40TY2i+g6ME=
X-Received: by 2002:a05:620a:17a1:b0:93f:22f1:97be with SMTP id af79cd13be357-93f5800e406mr694136885a.72.1792626409239;
        Wed, 21 Oct 2026 16:46:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e2bee2sm373858385a.42.2026.10.21.16.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:46:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJg19-0000000EWG8-3cjA;
	Wed, 21 Oct 2026 20:46:47 -0300
Date: Wed, 21 Oct 2026 20:46:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 06/11] iommufd: Map memory provider files
Message-ID: <20261021234647.GA3381610@ziepe.ca>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-7-griffoul@gmail.com>
 <atkO08eCJzLX6R58@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atkO08eCJzLX6R58@google.com>
X-Rspamd-Queue-Id: 331A680006
X-Rspam-User: 
X-Stat-Signature: cmd9h35mzw95is8yrnt33fnccyj8pa4f
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792626410-957742
X-HE-Meta: U2FsdGVkX19SHBeMY7ZAa47EUT1f16SWSohS1y1jslsGKqPpewym+NhxHZrvox9BCnVtQdkHte8i5YyQ0mJmx/yTlG9KWYWiA7SkiSf0tTMqZppwFPrtbW/l/TKNM5E5efBGWc22cKNakwMDuqvbQCqwUNbAA9iwWNUj2qQPk+jiYpkNBRkpqqt02NiHASoNrOeuWnsU8/9TfxcZ1dRHLL96nWqxrjQYyma2rfkFdY7Vg1/GwMG0vO8CPf3X3WJq1hFVwD/IDUAnSsXxC/69B89uE4D1Qc3jRC9aSLokeki9jzYFaiAhx0OOFAYacAy30dnfx3HoV8CpWfI5gzRLadSHf3NT4NdZ9KfCEXNhRWum6YvMV/Kl3H/b+NbYxgMKEQncqUS/G8aX4wRANwywfFwSWkqh7Ql17GkzyhT/EsW0NQ5mCX5WBlYJG4FAv3kAPXjfjSYYZoIfMonyLrg18fw5OPZCN7RL8wdGhIjbfhQzHdTqMDNvhU4XPym7U+FZGbcWsnwdvOvp4AxQQBJoW3X/R1JcRKRZS6aL8s2s7fechWIEIPExF0tTpdhKT9l2xhjMVP+AMEidBwE7IDlivG3neJ51M+IqmRWCdkcyd+qWW3gJrijYYDwzTZ/lepkK78UKLDfmWqIFCzyTPHlsCqw2YqxCM9AlXw7dXJ8lZ03nV4mfvvL/lVVrdKd85V3tbPKo3abciQOBCoIojFCpt118fEjjZPF920DcIqbgwasnmrVSKdByksFCzkji11FrX8huu3UugJ/fZN2Uq3b5NPOkJMMI4BXz9sqMEHethQxZ3T1L3oyTIaQmDUqUMCCLmO3RDP3awIydCItMZ8jZA90GFVCIISgsCxzVoxdb1WXumSL7ilqZQ/ySXLllsQlqHhX3e4BRAI74KKsYYL/uvEM7JVXaJFQbwfy1S6PqJAQB2Om0aJhwzPS8J2M3mbBUNRXhQbIEg3bugcqIw7r
 0pTlAoW8
 1dtTkKeSiEx7G2jIJdGTWqx+9+4D5TXDrraIGyMiawOFg7n8PT29fxXsweJNbLoeOd6DNNefih106Xjxh/LHqEdL5SqscxMTnzwkf9ibHUARg+1rTVvVQYRbYm4SX1YzD2l3VKusPrGYvicUH4f3S4rol4Sniv/hNgGC2tK8aeKzChW29SHYoCyKuKtzFuizrlxSwno8zh3jWKPzcLhMDqUH05yph7IoyGGhMbUC3UJ+1TcSd28o4cjocT9yZTyDgEAGEjvzUqur5EG++mfuZnOSBCBhd419gZnHlAPXS0dn90OHONqyNZNJp2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 08:17:05PM +0000, Samiullah Khawaja wrote:

> With this approach, silently skipping holes during IOAS_MAP_FILE means
> iommufd has no tracking of which IOVA ranges in the area are actually
> mapped, which complicates unmap and could also hide a bug if a hole in
> the range was not expected?

I think if we are going to do this it should only work with iommupt
and iommupt should provide an unmap that is compatible with the holes.

There are other places that would like such an operation, IIRC.

This will have to block an access reaching into a guest memfd mapping
as well, so that should be OK.

Jason

