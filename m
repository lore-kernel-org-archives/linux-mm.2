Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310C3606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 20:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=GKW2N2iY
Received: by kanga.kvack.org (Postfix)
	id 24F286B09C0; Thu, 22 Oct 2026 16:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200466B09C2; Thu, 22 Oct 2026 16:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEE76B09C3; Thu, 22 Oct 2026 16:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6EFF6B09C0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:12:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C9CC801FD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:12:33 +0000 (UTC)
X-FDA: 85351359786.06.D46FA26
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A14518000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:12:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=GKW2N2iY;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792699951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8JrjL/Toni0rgHeKLxMi210agLPfR373jhOEmm9NDM=;
	b=mYKy27hcm11GrWKIP9pv8YCT1HJiveu2Lc6XThaIcKt02dnTnj3YlqbZY2NT/SkYAB9apj
	8+/L/gBo0qow5UH0FhOncrr8ULrtD+RtjoIURlCldJ9/nOaKwwd0vi2MY3PaevyEKhZpUi
	R9PJds51ElNTn70b29L9Lb8461J6mCQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=GKW2N2iY;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792699951;
	b=Ku8Nx00pCteReijhUQgA4/p8LswJHKXKuQOvBn9NgRMPwGKOXgkJSM4bO1Z2GAqv+xe2Bl
	d13dmCTC4XNgUIYM5KETJNeB87dcaKXc9zyIIpLvlBQA89LZptEFQbvPWBPl2CaAB1B/9n
	+cWl6EQoXKqRO9xy9Kw9yjAdkVVNerM=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5361e313e63so1136061cf.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792699950; x=1793304750; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I8JrjL/Toni0rgHeKLxMi210agLPfR373jhOEmm9NDM=;
        b=GKW2N2iYQJGeGMoCYl8mbuvw5qL4NWP73jwO5FZ7hoRpclGT79lA3CkbP1PRO5HNL5
         k+B42pIpJE70DgUWpqFzdKOkqYyapg8OMzpU/Hk5iU68sc6B9yekCtCBAPF6FwjesfNK
         IYiqUopn5DR8OECqMp3bCY0HuDbOs+cOI9td+bd2I5VG5tUTOP8u6+fV6zN+ZvVmTHc4
         aZB0zk/b9nMLLdfL4/C9hTfYfcPYeIcg2tq4wptdu5m82GcHHOigTTLEzJfGt7+MDK+m
         N7LVRrdR0VDFPTlmyIFcMS/cW+mTUkbSehEspqkJJU9ATUExRYPNLw/P6xl484w4K7V1
         LAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792699950; x=1793304750;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I8JrjL/Toni0rgHeKLxMi210agLPfR373jhOEmm9NDM=;
        b=X2TioI5Qr7VfCp0IltJ49ovYaj12PHHivsgJaVimBb1EjycDwXNNX3rPmaQau8JSCF
         4x7+W5+smYS8LW5PXjL2S+UT+/MhxWk0Nkl6bx8jd4GsTsVvqOPZ7Ygr/spVTK0Y9xXn
         C2gY6z5JKdXPxSbSXZtSCPgGdiE6poXMa0noE1Emd3FMbWSbN/o/mAC5WHUs8fXpWC9n
         DvbHhZz/ogXydE3Q5V9OY7y+as+gGkEXbCmMboeKBjFYpdJKYxs+c0ix5woyIwt99CMY
         1MbiwUmVT29bfk9h/KmzgozgDzkJBY6I763B+xOVPkau9CEhi1Mfc1eACBr9po1AeM9J
         aDvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJs2PsKZ93BiiaVZvPA3dBu1zDaEUrxBZ9GkH51QcvHrxB+XsT9AG9Cbo9BdH3wVUMH2OIhQtIaA==@kvack.org
X-Gm-Message-State: AFq9FYJv9MhLdzG7JxYC8G1WpYrxwEkSroW+zBzfumVJ/Z5cP0g/k5js
	1U97Lhi69/BmOA5TjRLfFr0Ih9ZGoEouIp3rzCgpp5Xp7rvn8v39ofQjA7p/hYexHLY=
X-Gm-Gg: AYBFou0J7gCWwbKM6qm2019VAl/e2Dg3eLP85oXyYL5tVwUbDvxPILLoA6ruc9tSbny
	rRtjswezfirBbSyAXazcp8r1h57NsuAqq3DfFx8k/fTRtrZvoO1URMqagG/ORllc0+W8Yql7B90
	uQFmlk+IS69X1ERK2b4gTNB0Cddgt1WU7aISQOZ0bSvqmWPhQKFrYZuklvaoDlA9nsekHgqtED9
	MbNGfr3kycaRWlXCxu3dZ6DVgixvLMOKS8tEsV4BPuEdkHUCoFeYlC4rq0saT2F8QxVAdMJjiDF
	3/VY8dkKjSjRhlkNI0wUXZXGef9fdF/b30O/fqLmdMGNeDajThfSCVJnBbeF4Uc7oUcZqId/uTT
	OnCJKEZXo7tA7XEEQrBgq90YhMRWqI/4ulL54zpFoNM4Tugskm+/lPWnC7vgTq0KMqDxLSiNeyx
	Lhah4oF6eXpVhBoFfaVfDY+8uPwco74hoxjcoaiyq3nBVq3lz4QC+fd2s8h8+UHh4so/M5Mb3D3
	7XY3VRrRldOJAJ0UCb3yDFYFj6tAe9/8Yax1w3XdhSJPvs8eUt2YLzc/1K2ANU09TbUlDBbjvaL
	3kqv3gJ/399GuCMEsbHsIim7fQ51YOLiSXwltQ==
X-Received: by 2002:ac8:5a85:0:b0:536:6378:c7fe with SMTP id d75a77b69052e-5369b8204d9mr99553871cf.47.1792699950468;
        Thu, 22 Oct 2026 13:12:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c14da10csm1768631cf.0.2026.10.22.13.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 13:12:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xJz9J-0000000FoSN-1XEC;
	Thu, 22 Oct 2026 17:12:29 -0300
Date: Thu, 22 Oct 2026 17:12:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Luigi Rizzo <lrizzo@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
Message-ID: <20261022201229.GH3381610@ziepe.ca>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A14518000D
X-Stat-Signature: cqc7gii9ywfnnqkb6px737it581kaxqb
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792699951-709943
X-HE-Meta: U2FsdGVkX18PljUn11aOQObD7WUiDT2Z9e9qk2HS0mXKroXGpesionVPSgtomHGvd6bOD8rayxOlvCSmD4VquAHf7vtVHMgngB6W8ltQ24dTvehGuJS62AbBqFUxTdNROhViF+rVQ1TbaDFpBNBwe0lon/gzGmklICq6z9hC9+Et0J5LXH4QIQf2kZWXPS7SqOfE/59ix5xfhb9u3nKmT1CSH/IjFH9T76hWOG4TI639oeZUvCwRqs1GUZ3dbPvRpDu4j3m6b63g7FgdVVLvG6itnNeE/cnNtAh+d6BLVxiAeqv567CJrDqHCyzsjGe+02RgoDhGiaVG4lz91/3rBUD+hVYa4QEDE8mpk0uaE9exJJAA7u2i0HyMWeVKvs2nMqsyn0XhUSc3I3ErsSRgGJG0MfUst+qszdNY5hKYaPLuzMXINeCC3WfPeieVIj2IocqRfrF/Pmhg4hveVpxUP4PESynkGH6t01NClIGVpicMF0I1TnungRJKMwjq/PepbwnMaeVcSKV9wKaa30VCImfElgCjAmkbZA8D+TseadFWKhKvfPT1sUr8WyUk5O9IZT1Z72gPWU+5jBEweHbQbBNVCgEUIaBbcN4gx2I2x+2IL3j/i0LSHqsnc+9eyv3aE9XrjUzlR1GUsSEGOKgUQihP1OQbE2LRywyuLAJDeF9wc7mgjkwxkFV2NUyU+l4DNPVamvoCExnA41EfB7RqookUGz9PkwHuA5PfRHQ5XW+f6xRzdS6HBJpaiDyPZm0JHSXcFbv/6esy8OtmyinH0qi08o1ItUhXDXKXyc3uadccH6AV3YKzgiljfR504qwjp96FV/faMo7SHsLsjSaFt8HQgFNcFusQ/rIuJqYFqmac2CbVfqX5gYM0c+oufRwLTubb4pBxg8hI+kUqGJjMVMquscwMEEYgqJFRK5dxH69/E50bYfQvT0gC/H3xWtnL/v0mvUxJ9uY45VyaPqz
 djCKj9NY
 atx81auQwBnlQeZlGEq9ES3T/Jj4ctRM4IL3b6od1XPT4wnOTOa//mM4udUQQ+HVRYOISJjz8DcZCxnYYxsPXz0khIwPjiq6J4STy1f9bAgl0BGL3wATORHlNoiNyaOQkXwMsi25hVUkxtkUI1UAsHDI7vXXuJjLWDCOeig6t5mq2ywjsOymrIElxKjPpICA95sA+ZLgqC9yhRpieFL4jtz0pZ5Qna4vZ+PW37OeYg5ZnYR0Z2KW1vEpp40B7TqxpYczt9JGRhECWjH1o0GV7miHkoIABKsYpvHgyn4YMXU3kIJsT2csAZrsZWpXyU/pdJI7Jz+d1XOmDUkabG1rBRzUf4aXe2xbcfLY4myJuEdGsQgPRsP50Ioc29ehGmY+SSpuoLPdi5YseVcghRsVfiMBB2NOe4j8AMZvu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 17, 2026 at 07:11:28PM +0200, Luigi Rizzo wrote:
> > We should probably just find a way to describe that this is a POOL that focuses
> > on physical contiguity in some configured granularity.
> 
> Before embarking in a global renaming, I would like to get opinions on
> acceptable alternative names (possibly with a short prefix usable for
> identifiers in the code). I could think of the following
> 
> DMA_PMAP (for PreMapped or Persistent Mapped)
> or, ahemm...
> DMA_PISA (Pooled IOMMU Superpage Allocator)
> both using dmap_ for internal name prefixes

Can someone explain what outside netdev would use this? And why you
couldn't do this in the netdev page pool?

It is not a common workload to have the DMA allocator be the one that
allocates the memory. Usually we are DMA'ing from memory that was
allocated someplace else.

I think Robin is right, this is just a special case of the dma pool,
and it certainly shouldn't be something as grandiose as a subsystem..

Jason

