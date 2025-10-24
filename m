Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052D6CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B9C8E00AF; Fri, 24 Oct 2025 10:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC288E0042; Fri, 24 Oct 2025 10:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB298E00AF; Fri, 24 Oct 2025 10:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 390558E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:55:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D67085BD39
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:55:12 +0000 (UTC)
X-FDA: 84033305664.27.E377125
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED64310000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:55:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Ff8CtiSj;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761317711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5NlIoDgDHeWW4rVQCBPgiE2A9f1o4SvVODOB8YPwiI=;
	b=XUIciEbrXeR46cKygGDURxOsgsmPkTakm7ste6wioz1pF6QiSeMV7YyS8YqMmDjK4W7bMf
	aiQqfwDLBB+8GSbQyjzi1tm4ZuWSvTde30QYUotJxRyhCPfOR5cgipzjsSBES4SO+gFbPn
	v56Qeps3xGTGwQhrBo8IbfJJcXW8s+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761317711; a=rsa-sha256;
	cv=none;
	b=FuoLANZX1WQgt8y42fXGiaxMzr1PDI1DjuvdQsgmV4DvGZvM7PUHIgSH+ixepg6jiwVg6I
	7h139iC1Wbq2Vush8VhnouVY+73ZafupaJLsgolbDJWcqaNwFU0AtWRwVMNQdKPkcg0SBM
	u/r/jl8rfEKZhCdkoc3EUkuZj1yDdMM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Ff8CtiSj;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-89e93741814so32192885a.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761317710; x=1761922510; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5NlIoDgDHeWW4rVQCBPgiE2A9f1o4SvVODOB8YPwiI=;
        b=Ff8CtiSjsayKyyoX4awDh2WzH/HpxZPK/HzznpXWCvKA6HjWfaseD632nWnWwR7S0I
         s2hK8MG6fe8VPPgoKyABo/JtDUaFP37INxWz0Y4pfsowC1HrNF+jYSywqZaX31Rf4R0+
         d7CiFRGadsEYitfBas1LR5pAjTiA6Cav+ohWnMl1fsVKgx/j8z97Ze8wyustwheghzW+
         567UsGI0vdHu8CvBfgoIdNsWGCIV67t6GZOTp5CB72cHZyfXSfZ/iOpFTwr9yed3uuGG
         s1IxZIyLdLZRtjUE7BNa5YmwBdkeM2MpULJYRjUEspcNmXQGOlVm5l6j0ZN0+iAAXlaG
         9R1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761317710; x=1761922510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d5NlIoDgDHeWW4rVQCBPgiE2A9f1o4SvVODOB8YPwiI=;
        b=I6C1fgYwFMhqafWDzty3jDGZ1aNSNh1XtQJJvw1dm/F+TKrOiNwokF376Sn/Y+Eg0y
         SmniFlZSujW5OUFMUiSGoe/wYTIAn8W3d7hXvMnFe+OTs2eUgigndsKjNZ3Cpq2aMoqK
         unHpN5KrJVOX9u4ia3yUmzdNqBmtUO/iz63XAjPWskGlcjrybGHJcAZyrYnXnHjD9Vb9
         XsMAOMtqgowc4EZH+JMNHgRIQgvA9CZqZoJplgF9Wr/q/eg6WskI1gioOO7Vqi/LicMf
         AnGSKaUIJcrwJGHzvI4E0+I7E8AEyQ0Lit6qWBdv8+U8RbuFMpLB/qE2SJRUV6pf/zG4
         wSOw==
X-Forwarded-Encrypted: i=1; AJvYcCUNIzjdtIWqjBlaUR2qW7MC3pAHiCshpCcduAaBYkLYOcON1D1Q0NA9mUX+0El5IVhLHKfyaqCZJg==@kvack.org
X-Gm-Message-State: AOJu0Yxvfd/Sha+og9vizpSuQ9nDbV2IB+P6i9pDv8Ol3irEDxzcODwx
	FfrM8gRQPiu9dpDRa/tng5hQr4Yqx9fMgdAiJ+Hdq+yYZbcRRbSKU85afadA461frEQ=
X-Gm-Gg: ASbGnctEOcF5lTQRp5jHj9qjs9/Ism+MqJbbk/ApvdyzMLuk4rVFtmDbfa8CVwLoqWT
	Lg8sqwBs9EpS4aG1vDJu+mDJgMl6VkTcOF4SIzxVXArBWvlbU+F2CkL15yw+e1rwsTdueELTg2/
	TBmPFy+LfmPkvu9H6po7dPLsHyv1dTinZn1UQ7JL5mEZMOYjGxbeuImvYXY9+mCByZTy4TfWAe5
	sLAh7p8sZe306Qgj7xUbGo894tG9rLdCzWaqW1r5PvDaI4VWvnSbjLjnr+aXmhS6dvli8CEuNfc
	KVHNYhquKs4sjenOT0oCJbzUlb29OCvCjpOyGYCtKWzqmh8YQXk9naG9cuu8iMV2b53xwRUP3iK
	Mk6T2CksFBTmnhC/zXuCCU6L/zP9f4cV/Ag/eSrI6foA13ny1yYZg8KyiWdMDPujp2SzLwqfS3j
	NA33I+TCzPwWeDzP1Rn8DPLXYXApUusj9hkHKMFaq2IjgegYl09CYY9u4IJ0M7IM41j1w=
X-Google-Smtp-Source: AGHT+IE8bWbSj+1CYY4XBt2q7DKvHPV/vSXNeg3vYjWLWdmaOWjBRdAAspelX2MJNOVxeS8YnHa73Q==
X-Received: by 2002:a05:620a:2986:b0:891:993a:361e with SMTP id af79cd13be357-89dc25ba951mr300274485a.62.1761317709926;
        Fri, 24 Oct 2025 07:55:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89eadc0ab82sm32465685a.53.2025.10.24.07.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:55:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vCJC8-00000003jd8-3fUq;
	Fri, 24 Oct 2025 11:55:08 -0300
Date: Fri, 24 Oct 2025 11:55:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org,
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org,
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com,
	glider@google.com, elver@google.com
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
Message-ID: <20251024145508.GD760669@ziepe.ca>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com>
 <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
 <20251024132509.GB760669@ziepe.ca>
 <CA+CK2bA_Qb9csWvEQb-zpxgMg7vy+gw9eh0z88QBEdiFdtopMQ@mail.gmail.com>
 <20251024142014.GC760669@ziepe.ca>
 <CA+CK2bAmPN+v7SYsdHA+RL4kFfnoQvKqTqZ2YQ4wdq6dnFkotg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bAmPN+v7SYsdHA+RL4kFfnoQvKqTqZ2YQ4wdq6dnFkotg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ED64310000C
X-Rspamd-Server: rspam02
X-Stat-Signature: s38sfbipn9xk7c436einqn1d1umiae6q
X-HE-Tag: 1761317710-531566
X-HE-Meta: U2FsdGVkX19daB5ZlpedgsGs43Qw7Ap66L7bY3lLgpFwTJWDBwQbowUCc/1pyQSBf/xMP82Ui/4706E3Th+GNd8ij6bjlErCQZZTnRBHbTxi3kKUkYjxsZfLLLCz1tFIA3AbgqYiHSD7CZqbTzKnJhD0YGpHlKHxYIQjwYlgW9X1jFc02YbMAG03Txgzpnqxu5NvX2bUaBPLiRvURodLr8w/eY5FWhFXvjUQra3JAepVhOb16KR6nKwY5d5/taxAcdqQ/+kZUF3a1ZQ2wASvoLkDeA23VzI1MdnsNMQvMnDaiYScAG4D6cUe4sxuzOj+g93rXC42Q/0GJ+kld+y9GejA3/D5JZMMObboMmAMH/ZjEBkNUZbSCLH2atiu70kbzdlHrLh8G3Bf42nMNBYazMxey6DGZnBJk+6o3YQ+QJtnfaL0YfXbLAXoFMddsczBtxryEirsVg1u8nHC4BOt6OLNMZdBtlFzzvai9m6RPKHfu1sY43ckMmIs+QIPaz0I0kNfSQtqgZA3XKq3HC+GhcBiA3wRseHGw38QzZJ1N3rIeKeLKGKVRNDBJNtur9c6YmOV9sgzf5HBMCSARRt+Jn655ZSLdslHD6Duhcp9/q+yuHFPH9MkaYMS09h+VyKY77tgz4g8pwvXgpW1r+gjaCWj7dkKK/wILjsVSi2bT9tqHteFCEKbVgB9VwOHQqnuRSv6ygOSEqQi4MJ648ixEHIu1pol9TvfdZq6z72SUv2UJUpfmfUqiwBlUnMryjURGvg9NwBxK9LQqkStBJsWIfW0PKIpPrzrQWEbU+xXXTFFXK1er+NwhDgBETOkF61EVI3JLqPGUn5S7UDkIDKhXVRTArJl4H967Y8xIJsn34DCe7mz4wZGFsN8PwTLc9mpR0N5XrLoSwC5WZaoci8TEMAqQKCi6vnaqIITBpizSCWSysqShOxujVFhg/zg+LCQO/3xS93WmNNr9d5HbqM
 iNNs7v9n
 TXsJf1iatLXDeCJHRNzID9n+ftupQHJH761KdEDK6iDJucS9qRuf9i62KmIzYpVa2iRH3JaiNdjHZUc5A/tDVAngrAWqZ1wANreuJgW3/jQub8r3Cc59KHwdb0up1Dy1dhWom4qAy4K6SYbj6TaBofctHlC837W2Y5VVwzrMjDTaglRuLD1xp5Pr3nn5MDVPnkfvbhJ0SN6aiBF3GbWN6WsITEUPlsehjsGta/443yfwai5GwJNuyr74UMs5YO264II/QJ4iAxtavhGo/yvYFRAoUJCzuV394wv70
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:36:45AM -0400, Pasha Tatashin wrote:

> We do not zero memory on kexec/KHO/LU; instead, the next kernel zeroes
> memory on demand during allocation. My point is that the KHO interface
> retrieves a full page in the next kernel, not an individual slab.
> Consequently, a caller might retrieve data that was preserved as a
> slab in the previous kernel, expose that data to the user, and
> unintentionally leak the remaining part of the page as well.

I don't think preventing that is part of the kho threat model..

> 
> > > There's also the inefficiency. The unpreserved parts of that page are
> > > unusable by the new kernel until the preserved object is freed.
> >
> > Thats not how I see slab preservation working. When the slab page
> > is unpreserved all the free space in that page should be immediately
> > available to the sucessor kernel.
> 
> This ties into the same problem. The scenario I'm worried about is:
> 1. A caller preserves one small slab object.
> 2. In the new kernel, the caller retrieves the entire page that
> contains this object.
> 3. The caller uses the data from that slab object without freeing it.

4. When slab restores the page it immediately makes all the free slots
  available on its free list.

> > other patches are small and allocating a whole page is pretty wasteful
> > too.
> 
> If we're going to support this, it would have to be specifically
> engineered as full slab support for KHO preservation, where the
> interface retrieves slab objects directly, not the pages they're on,

Yes

> and I think would require using a special GFP_PRESERVED flag.

Maybe so, I was hoping not..

Jason

