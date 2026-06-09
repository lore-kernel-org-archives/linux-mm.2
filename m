Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECFFCD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B176B008C; Tue,  9 Jun 2026 11:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052506B0092; Tue,  9 Jun 2026 11:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB346B0093; Tue,  9 Jun 2026 11:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D989E6B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:42:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A52D116499F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:42:59 +0000 (UTC)
X-FDA: 84860792478.15.40ED267
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id D23F240005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:42:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k9BXu2x2;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781019777;
	b=c6Zz/OlDrhlvWmntMZPVhNEXsLQ7Gd3ujLiIeCEi78F2sA8h//YxR8CDgGBFAz6myOYZCs
	uGzYAQjFcwhQypVcGoqBJzxz8izeNas9UtPOqP51PTqJu/fZUToTh8L2E+bn5pgbcFBZDn
	Ka4bZwQyAcSheqDwwk6pUXjlPLAhte4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k9BXu2x2;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781019777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m1lBs+cPKEi9J2sI7ojOxRGjTO3OcUCSuFxlAgPpsc=;
	b=IsA2asdc8uQeSGGA1qRtM7OOcEvjIcsqEGWeCm55wEo8PoeWM/vvW1rdeC2O61NQRRg9T3
	Ar4UL0yzGnlDTtgPZ1nHlXn3V7krQd/3CH0mrPJh5LkDgeYW5J5QFMyMS5Q6+nRT7hajD7
	PGfCuWc0dIdyGNQcuTyNs75rIZSarYU=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-9639b1ef167so2024042241.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781019777; x=1781624577; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5m1lBs+cPKEi9J2sI7ojOxRGjTO3OcUCSuFxlAgPpsc=;
        b=k9BXu2x20xuluvjmOdyspJca44EQlqQn5DJdX8ozsUaNhbngi0FcI1MQBv3+75r3vI
         NG7BZ3CsMHxVaGGUXAvpZuN6tw4yM29AWZa48yeDBPKVXX5qLxLvEQ8H/LZi4Z5Hkppo
         WW2hXkGq3oln/6qrI06Y2nDIw0ksubEqXnMpe8eTG4iBjR9NDr9+mS09Ox8NiDqQXEvB
         gMKPbJeKUDQRgB0PDq3gosuqKVaMhvywUasKvCqTn8MKWrwa1fQYF3aCNZ/gGUm3ADsS
         x34DwPx34SITRmcWD4ccd3wgshsT+m00bB8xlQRRxcx6PWFX3Fl+nePa+iajFz7v5UmT
         5z5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019777; x=1781624577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5m1lBs+cPKEi9J2sI7ojOxRGjTO3OcUCSuFxlAgPpsc=;
        b=RTXB7BfmQEjTGlasloCJtvBRXUCufbEFIw9h5xcIdGzT4CdimS0mfY1w8/wbLk+WIK
         4m78GzVjHsmDSApz5j/6FaDbeE0fPKylg715a5jICvs29rWhSeiEcfDuBZr5FceZAcUh
         NWCakzECMXXFtjoXx/NjRbQYMcc8OqSe9QhhSWLasOnGNwnASJrS3NFussI0solxn1E5
         kwJ8BEqyOqpqCaPS196TQyBr6lvXdrJLCmck/uXJNtyrped0DFlTnx3EFyZu4NR7z6uj
         lB5sVXOM8s64g5vB1D9SR83qZ/m7ri5yimwour+rI6HkQJ0pOYDS2UIX2Sh+1kRlMI2w
         hD5A==
X-Gm-Message-State: AOJu0YxSm8aQ04s95KKAeOTHl4KDpsfHgMKE9DtQ9cVGW3jQr5AFYudY
	RAB+aQCoQVT3pDRKphux5VogJZ7uH7gzhWS1L6f3bKLtP2ASwuWllosIhtJtmQ3b9Ps=
X-Gm-Gg: Acq92OHcIjTpy2ToAS5qq94Gjb2GcGHwSiv9DNAuzlqkBBIEhtCeviQx95mydznDMqu
	NZAkRrSskybTlHm0ioppk7pcCFSgK67lTETD+LYHIFp5LVjFX0aHWbI9wtaHQKX/PFZ1FYMiALD
	l5wfsEByYpyR/AJ2DosI0jZ1JNMPpn9YhObwYLvEA9QnEHipEsY+G/aoJ0yfquX1en9xTj23d3L
	3y5SdpA2Sd+DtGcbtUESaVjxWP6JQ2M0H7GbBOZreG8w8Xxo9U6Gofv2F7+IARliV7Yl65U9GzL
	JpccRbrsI23SbV4VAR29WeYtGhjYUIXpeSE3OVwUD1o6hY785+iBHBZySfwZxIQ9SEvHD37b92w
	wZv+ptPgUnWXAPjVX8pe2FyqDLxlAa9yP9tZUCwXICzUX6F/oX+k610iv1PfnYNwlPYZVXaKUcO
	WLz98t/B0lwJw0bcJfRcuaplgquqtyp2diT7iKF5/CjN2CSyuTSv6SIUaByRQG6yN+AQHJm6jNm
	COtPPowCwH5XYD/Pw==
X-Received: by 2002:a05:6102:149a:b0:636:c0c:4d91 with SMTP id ada2fe7eead31-6ff07fd12f7mr12087727137.28.1781019776857;
        Tue, 09 Jun 2026 08:42:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccdb5e92sm205961926d6.11.2026.06.09.08.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:42:56 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:42:54 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
	chenridong@huaweicloud.com, akpm@linux-foundation.org,
	david@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, rientjes@google.com, chrisl@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, ziy@nvidia.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and
 alloc_context nodemask
Message-ID: <aig0flBMN-sCCogW@gourry-fedora-PF4VCD3F>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <aifDlU96HSRy72Rb@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aifDlU96HSRy72Rb@lucifer>
X-Rspamd-Queue-Id: D23F240005
X-Stat-Signature: p7uhy16unbtzozfzxjqz1by1n6hcenia
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781019777-175246
X-HE-Meta: U2FsdGVkX1/xks0XQIei/vx+TCp2QYjZhZ6qVGGADAHA0Vi5meOmss7EgHRMXpkd9DM/x5dWUOx8BFOXjqbxTGhIqskkDml33957wa+yVlkuIxrVyomS3ubYO2LyNHVs43K+UfOP7PsL1EJHgQX0MsAdtjMh1T8/jBq7lF2VCk9WO4t3RoQsN8W/Hz/FQOZ7cpNiTas3cZcrGMb+wOnL3jJ4sD+/AZhHdsoIchO6ZhQqo4pXeiPz2GtcYjAlOimmfSMOAMlucMV0s5Ep6HWyJ+kQndxeT+6mxbrxISTWh/cmwugZhUteud+pOUS4WVEpclEfwyXmm4AhMFSauPcigurblJIRWWxsg900POBEfYy0NSN3kaJg318Lm3MZ/OzOyUIiyC+loipontNBUTpbEVzjKlUXO1n60UzdEZqojskDN1IWYdW0VUvXyGSeTZQV3bEvAHOLhse1caqEibWmBcfiuUSRuG4ol3kLfgNgQ7Uc055AaekhDb52nCrLuQ8Y5gCRh8JIqh8wQo9IOwRRXnokYuTazoLnRZWq87aN3SncbBI3kBFlbk4mIKd+3mnHVkmHeR+OmKvvQAgB2Mr/Hs0FWiOUsHHS/jn4HKpsYb9CQvVlkay/aFbyYY9BMsRbCYS6uXA2cX4bayVXqkrnfO9SmukjsgQMcjEl3auE8VS0lNq6HVj/LQirRcSvGRGrdlNxcKBlxchX+E1XMp9r8EjvguApJk3lRb1yDORioCvPd8N5Gn+kU/94QkH3yhVZy+YU1gKnyXgYNemfXcmnwmJ41MNeukdg91jACkL0asSdW9tRtknO1JVrsNfm9glKjxFIocFjdcUZxBqtZN9AUqPzRfDhvh/K8dhGtEYqgSdeVFjJFDPlcP92SqZTjRFIxkOcDO5sg18jbPz7wKw5F4NR5H4gsslj5qWkBI57yC6GJac7pcRsX9yZ85LmPh3PcQKZXkqbFeVk2VKUMyz
 sdASdG9J
 QpLK4mGVl4qtW4schn46NInrNrx3D4u8VTldOzJMoxVaOQ7mZhV2mKljP04jo4w83XvqT57ZWy9DgUHQD7YGMXdsUfCUlyf7XzylVJP9/l64RV4ZTZO5fBWOvCKI0mkglxp2HITkjgP59Nd9Yxk9sgwsluf5Is4gWHNM58IUdHk/r1jyw/LHSmrbqkxf6ougkUeaRS6XQt1pywBBBd9caNYufv/v+oLprKQkEpMsKcNtd12kgTsohHeeHiYUb5SAYKt0sg967aOlBGbjHW/s2BdMOgSyNiF02SW4oYAvJt2hephkJ+1JYT+Jqev/pxvVUrPivAp7Jn1zF2QkDBBSvT4u/jbxZdSyN+Ol640miKk+m0i4NUfvjIE/JyFx94W8xPZipQHGckggvaDAjUdJQnV8BK2jBBuSz9P/nim6lXVVyW7jd07QP4Py7XDyafEk1cRF5NzpFz74tcSqRnX0bEjEjMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:41:59AM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 08:29:19PM -0400, Gregory Price wrote:
> > The nodemasks in these structures may come from a variety of sources,
> > including tasks and cpusets - and should never be modified by any code
> > when being passed around inside another context.
> >
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Thanks for doing this, it's nice to gradually up our const correctness game
> (as much as C can ever be const correct :)
> 

I've actually been carrying this patch locally for about a year in the
private nodes work.  Sorry i didn't send it sooner.  There is likely
more work to be done here.

> LGTM, builds locally too, so:
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> 

