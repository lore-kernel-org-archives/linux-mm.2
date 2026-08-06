Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E210C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 15:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAB76B0088; Thu,  6 Aug 2026 11:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989B86B008A; Thu,  6 Aug 2026 11:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8536E6B0092; Thu,  6 Aug 2026 11:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9DA6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:48:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA50B120121
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:48:49 +0000 (UTC)
X-FDA: 85071277578.21.3091734
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id DCDFA10000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:48:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fLQPEPwq;
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786031328;
	b=uOrPZTzIAAktDeUkFl9wwtGqoI1O7czdjE8phdZSGaijSSZDRrRChVE6R88KxoGVhbu3CY
	lcGXKGaj7b2ehWvUyjbd2jSfcSs6wxb0+X62r/rwnZlEtVC3pMQ+c3o1sMDm9322/EPzg8
	I+wuDZYM4KP+NxgaDGTRtFD7O/ODa+0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fLQPEPwq;
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786031328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwVSV5EsLBZnwEGlh4H7pVKLw7Dudnf8oqtelaeaz3g=;
	b=NJn+ULW0eIY6l2fRIjgJ5owPisVS3IdzktyFoVVNWBHP34/iIb7LQHpBOSClq3gKh08mTi
	PVDYMI6BuuWcni1Xhu9Kh9KV4G367FWQNFl8vgixr4U2UuOh09/edQmQFZlZnN4nj3zRjT
	KpOdzftNWkt84jcJEzstQ9WRJclsRj0=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-934944f2d22so156994385a.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 08:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786031327; x=1786636127; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QwVSV5EsLBZnwEGlh4H7pVKLw7Dudnf8oqtelaeaz3g=;
        b=fLQPEPwqdJ15WRt8Mh8oK1BbpNFgGiWP6eDqGCG05l7zCAbkF4Ypk+qzyBjAe9sa9f
         43OWLSi6jGqAxj3AaXlxwEOtJTYeJ6vrhHI1u6ln5sesvMoMX1QRhM2eiMtnKsJK5S/D
         QgQlDhSgUyldevCDq3vZcl+HH9tbqyBXFqzC0qK1DRV1pcgIaxccT/CAdUOWrrnIut+K
         NPyL0hRtFPgjZjgD4k77AKue0H6dT6HSf3PxCMT4aPp6cNKNMmxNjdUrJEi+5RnDcEu2
         QwRmaHpyvNCk1raLTZhgPpB7iw6c3O2ggSHF4DQxNOj02dy6UEsR4chFEWD7IFpUaMne
         Is1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786031327; x=1786636127;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QwVSV5EsLBZnwEGlh4H7pVKLw7Dudnf8oqtelaeaz3g=;
        b=kM7VzvWKGh9jwhkUAsO6M/n8dk3hEOqNkBsP1l1pfJ1IpuO9aj+05LXD33kWU8+onc
         CTxj912I+I1SnHvRVy4ysJGkPY86Ab6SbpW79k6aFDKdEou08As+HhsAGsQXx7lZWBf0
         1biI3n0A0IqlZsFl5l3cFcPwSJAZi/w8XWdFdnHW7zEvrETgxu4HJafGlkxyowu2RhMQ
         Oxp7D+zsCzy/8JElIvogrA0qLGd5JWvStnfRr98X10SJuvLZOZRk17DoRdH63vLevqr6
         ZnntNh1M2Ofh7Fnu8doKfNLWiO1FDAQMR4ZKo02y2k1rPTj2QgLmUmfouiiZB27NzEZN
         2fbg==
X-Forwarded-Encrypted: i=1; AHgh+RpqXHToVSdIUtPicTRyG3yAEX00wf6CBiym5FWACwKbFgQeUbgrjQVUh5vLK42GFwWLUyuxncAFvw==@kvack.org
X-Gm-Message-State: AOJu0YxIHDw7/2npCO3ZSQjIzZjYo0hZaDUG1V3MtzLs0pX/w3Rx6zbX
	KDkvcikEHKncMYRtgEJzpKFLUCU14e/kMrtE0Y611WqC60yTZTiUBxGA1TlSzUU4b2M=
X-Gm-Gg: AR+sD12656EVgTe9Z+KnmHXCYcq641NR8SkVNoQ32F4ftRrvjKndu+jSp6BQ+5UrWhj
	MACdFYkl9ho1QB8pS6V6eJJqbC7Xh5NdoU2yuxcQYXOF8CQ2oI4KNuLCaFp175zrki6uXYorV7a
	Y+oz0QdlPu+mEKH+fKKoVApxV5keyckmHW11r/IvtxPFhdA1QQFn1uzRVjS6XmfWYXaiOiJllhe
	JObLWZ75Km/ifGERrwUu33HJHDzoQ2fxJHWLkWhRbQvnYX4VARTYR4RIaTTKloWPl+sp9fiAhpb
	HiWR99zWmyGjC4nVT2/b0p8zx+zqiDgAIsnamZ8iloptCLi45oq8VbJ4tLHd/VJbIEpLCPahysH
	HVF7A/g+MhopW25JDA91xmjCOgHRvGyI21Lw2pWvxUfCbZWn5Dq78v+Hdx45B5w9DQdi/46P0Oi
	T+zdHylv5jmxR8P00l6R71Jv9o7x0wTzcMCiRp4w==
X-Received: by 2002:a05:620a:4387:b0:92e:e299:dfdc with SMTP id af79cd13be357-93649181774mr1627443785a.21.1786031326741;
        Thu, 06 Aug 2026 08:48:46 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9364a5654d4sm424036985a.36.2026.08.06.08.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 08:48:45 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ws0Kr-00000000ZDn-0FIt;
	Thu, 06 Aug 2026 12:48:45 -0300
Date: Thu, 6 Aug 2026 12:48:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, jannh@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <20260806154845.GF28508@ziepe.ca>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
 <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
 <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
X-Rspamd-Queue-Id: DCDFA10000D
X-Stat-Signature: zquwnabx1hib3h1f6dfqote3rzrtbtbk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786031327-802142
X-HE-Meta: U2FsdGVkX18NFq6R7qfyim+fbtDJjXkRAejqDPTCAME6UOdeVLT5Bobpgxy+4YBRKyVsobQA+pJf12Nyojhv4ljLWWhdgXeVDhicOWvjO9y7CUy4UTDkQ+JoxgOZ3KzpzfweFLGG8mR2KaDKwGQeWmZtfkGfvgfzcHECiqlyaT35VyBQE1/JX0ViR/DA38eA6Vthbxkjy8YrcVg0qEPWbAbi2KBJQsudA80qvrSSXVj/jaVk/cPpRJ6DxNY1CN7Ohp0wP0CI6kJ2rYHu1JgsA6jOx9wpVUypxQZGmqeS27xQom2HeeOLEZkfcATWGg3xpZnzEDOQgHrsayNCAcdIIe85NoHjHPA8u7vzDf8Zidoa+8wV73wwqmEO5HIeaZeLSKnqbpSjUYiSX6FGEk3y8w8LFezGSPu/0XkkYjs3HYhfzzzW1Xa9Ig42nA2e/k/iR4X9pbItZewfRFZBWz0pNYASS92u/4QTbMM8Wsy5NcZ5Rjok/hJPhfXz5m9ok+nHCaXhD2w6866jcm47sdp7932ibBdh+IEfUghyUsj2DF5WDR2+cF4oqm/aFbp5EgO2XaskyuDMhJcX1SfxZ4DRbtGolg8cG2SFCYxYnfkF+i82hrJVXrbVnKyyLMDUCx8TMV+le22Y9TPMaQx4l3ZKW2zOih56wZYOH3RBP2xxx/MJFFcUh+ei85n97nlS4se9iE4N0zLdWe2e1q92A5kI2Una8/7lEhuZ3ouSmJNrIvNM1N1s2EnayYeGyHL4d7YkHX6OefP13OE4t7GO1aoPMj0baKV9Etd+3iNzUt3SnuH9dR2o8ZBOtTS/CvlkkaTE5ifiFXGmS1EHGYr/03AYedtXhEMfZ1yZTfZBUbpEHmwQvJJpHuZplEhewYg2IRaTcnr8o/rIjTOAV9sY3wcBiIIyHKlZmj4brHIeLFToyhEvF9b80sWywRw+gIZNWm/x5C3joaQPbG/XpHoh7hj
 Lm6EuAYc
 n86SIveiCbqu6eyEdAmpc6hoqKfuLmDu0CLJZxQYBnC2crT2gr36zsqDkBn16L32bpJ8uNrIMw0pbSjoRtgDMjAWmDacsDalHos3hM7useKSk/uPYFpt/4Cc2fPf/HraHjxAc6WtgYeHkYkXjhDFyc88/dthZFDScna4sxv+R6OzrMAFhDtKfcDGmJAK0GWbEkpfcPcPw3+wLFCKw+2bZ/yncP5s/ONnaYt0kGg7fnWzlm7O+x8I+jjD94UJFiRS1wJkC5dl+3+SpoNImET/cfLIluHbshva4jzhJZj4BPz5Ekhru0EOvyGshbJ+oDm8/Wlb6xpAtoxVjMHN2cqe97FGhR5peOCWRbEvqY1mEmis4sM09KO53aN0pdFi7w8JM7lmAb+e30ZqlvqqTv0FGlk9ubkvLJnAJe9eq/+Pdg8mJOjIY+nRh48VEgUJaeZUCmoS6qyiDmB71Dlj2CFAXke3Aau5FbSViw31e9F8/quGY1JN8NBw8EM6Nuj9V9Un/j+njPpz4Ni4bfb5qrhRl2wU2Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 10:29:27AM -0400, Liam R. Howlett wrote:

> @@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
>  		goto store;
>  
>  	mas_alloc_nodes(mas, GFP_NOWAIT);
> -	if (mas_is_err(mas))
> -		return NULL;
> +	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);

It still feels really weird to ignore the return code from mas_nomem..

 void mas_nomem_nofail() 

? and maybe it can have a WARN_ON

Jason

