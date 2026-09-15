Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8866CC88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0F86B008C; Tue, 15 Sep 2026 12:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0BE6B0092; Tue, 15 Sep 2026 12:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7F46B0093; Tue, 15 Sep 2026 12:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5FD6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:17:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 927CDA04AF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:17:39 +0000 (UTC)
X-FDA: 85216502238.30.75D9150
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7DD0C120008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:17:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=J6HuFXQZ;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789489057;
	b=SCzb2NbOUQ4a4RYdE+AmSKurKRH9ObGhYjRedFuy5Q8BmF+TGFWPfmP2CdRpdqHrfp28Ra
	NWGLWA1pzNYv5pk3nmUgAvyJp0XiLjRwxqMAzeKNjEnkoXpL6JJ6dzdeiFeavI8bJB/5Ro
	dtwpmPDQQzuOiBnOt2Q482rU/YO0/aI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=J6HuFXQZ;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789489057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXoaSOzLcSniPHeJqnrgZd+b23tx7/MvhGFOoQXutdY=;
	b=bk07BLLliz9tawrqf9tNeZnS6QKRUB+qDigAY3+irAeqRzBCohRnKgkn6Y1tpS+wD3NXvF
	ybZhEEFbrSiu3QRV/1pOp23fYFSCV0ZA71kg0OS0tgaxD/qBQPxxIKmqoIlg3GhrSIEwbY
	lXG6zPMsQsi9sqpYABa6KCtTFnLdZjo=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93a0fb2f9efso78060785a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789489056; x=1790093856; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dXoaSOzLcSniPHeJqnrgZd+b23tx7/MvhGFOoQXutdY=;
        b=J6HuFXQZYUBEHu0xrbK680ivDkp3AU+Vfi9aqYK6h56lKqpk7ThzliVq9zenGqF0lN
         CSbGA6y63QZWFEtb7SEf7Pj5RGVO9FQbElDUj08wDF9qVco42ljQBxoZ1Q78geZs4ttw
         B+MnEbDFTwXR2FJNRPlkWGnlOPm3KVtUfeQmI0GoUumvu+G1Z5NRipeK15W1d7uCEYbG
         a5uO5rYDM+mokTnNMdtCqWHQAhQPfAEFPHswKTWqm+jdM8dSPg09NFnFdGebY73D3PXB
         Ns2yGl6pNlASxoSa196ufZRCMtgzUman8SZn6QNG2ML6bp5Ch29deYMsMYUAzf8yCihY
         mGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789489056; x=1790093856;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dXoaSOzLcSniPHeJqnrgZd+b23tx7/MvhGFOoQXutdY=;
        b=v+XxncQvROTPxkvgCLE6vu8+WVCNlGepbNw7vYZbwr5hKLtaIMswcOyyrjHTze41vl
         q4CG8+/ul4CK7dfAmxt8voKInOHjKkvGqReVBn56SODsSsHcHqSIK0nUvhM3oqaX0jHY
         WWMaH9JSJqkumnTEuKgBmEnSbTsyJaxE91G9tU0osqahF7hmNZYPeZiIha2bHYGPudYN
         Bv0LwCOorSNsJBVWxfjbhS4fopvVl6luF9M0Hcx2Z9DXluRUZC+VcU386YrdvxJZYnzy
         lqP3lwM0/RUjkiO2I9KQUX0C3LUnrDwQktrpHKtC5ZPegHgchk9iga2RbXfUFNjGem/J
         1+TQ==
X-Forwarded-Encrypted: i=1; AKwUvBzGdgnZbtJxo4UVIXfQEfpPpTIHOETGFykIn8yoK7HeEW6NFYkCEaMH4OJAeUQCntHuXhZb68hUtA==@kvack.org
X-Gm-Message-State: AFuF++nrdq3t2Xanidh3HWXrrbtJBfnf7eGzAcGQMSFmT6HCmxVRzcPd
	89FK51iuBFP+ToCYCDcSEbNIpsxNNepZo+BAHJ5i65t9PYxd4K+q++Ugm59lCB93CKk=
X-Gm-Gg: AYBFou2C+DjeCE9++tF5kBftgMcVVSsyiPyrqxA/oGDRwxKYSZ6cCkoKQlUdZWa8XMB
	yqeTDszKs5tpmnZnCeaJUMW1WKnvb5cHq3Un35gpkmRbAdYazoLO7oVNzSmazGre/adl2gYrpvf
	gVCYktFcdp2dzG1LUOSTNxwOKiQIEx6dY3I3Fx4xV4qUdhIpqReJ98w0KiUCtBmVnvG9YdvZivK
	Ks9U+4jC7RlU5QfFoujCqdArBNIyQm7JSdRgfIzmso8x8MieL/QiHJoJT3kiTJW+24CMPLAXzst
	92bFZLJjFGpkSzlJ42jioTSyG3k8ObKv6ELtPq1hQbchGTH3AKuiSUQ3OJAObkb761cVannviwx
	brmk2a8prRp0pOyGKgQd3k4igDdsck/KFIU2dOAH+a4Y7eGn54AhkxLDbRzfFfNCixNyfPyiN0b
	MS7N6schOpemx5iemmxjYyMbUpfrX/CUFa5bfSAFGd1db3UgRXf0OUzU/Jv1dq0xzr+Q/v/A==
X-Received: by 2002:a05:620a:2607:b0:939:b7f4:c7dd with SMTP id af79cd13be357-93a3477ff9cmr603922085a.47.1789489055702;
        Tue, 15 Sep 2026 09:17:35 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123bddd5e1sm2362876d6.3.2026.09.15.09.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 09:17:35 -0700 (PDT)
Date: Tue, 15 Sep 2026 12:17:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hch@infradead.org, hch@lst.de,
	jackmanb@google.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, vbabka@suse.cz, willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aqlvnm8AKp5f_UhG@cmpxchg.org>
References: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
 <20260915160042.1265958-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915160042.1265958-1-dipiets@amazon.it>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DD0C120008
X-Rspam-User: 
X-Stat-Signature: cky51pamiog5hr4mjt69rjquixrkyiur
X-HE-Tag: 1789489057-840024
X-HE-Meta: U2FsdGVkX1+m/gxys732knMhja1exkCbfOtCyclUfqODkudKQs9FCIvkB59PTQCfB3CvlH/mnSvqyVALxowLElgwOPpOK48yJoe0x6/MCer7mT3thBThZesfzYdwlXlGhUOt4SvngIZ/VdGK4Xr/yoJgAGm4n18w9ZDnTR6QvhGdyFx6XIh3Te56H5IZSO4BGzYjUdPxtganiWRmUYM0UqktMHfNTTX3aw1kmX046TpP8VKk1miEFiG4WJZyxg87faBpFLCBpNkvbKsad2bomxeYE9vfm+SptbCgI68B7Zg7o3EiuKeRzMm9dPDmPRzsaZV1HmUuXDxhQjS3XCpga3eXvMxZ4VgWQ/Ig0VaEgTYTHLOtuAHdqxRXCf+qbg5g2rLVaN1LAwVd39/VXwa34ieaHZHDVYK+Pn2+qjv0nqGh8ZEO7I4/7lvXQ2RMspJt1PHt/chqU/qzD8QcGslJKX+lKv7uHdhbqji9fHGalk1EWi1Pbw6FHcSTevRDkdg/1nu0qehLwrooPRUhQp7XA3cfqeXv12JOpu/VDGwfU3IpwdHezFyR5194vqVD7lQTIiSWst75FMSX5xswIH/yAnQjH9//kBscYnlO3wfF9A6dTCmGu2oyeFpktxQADxPLRAZLVtOOaUtPEefxy1TE/H32zJdVJLrNU+b1q0KnVt1ZXUjqSMUlz0FZaVGlE5mXIck+ezOakGgdd6fXXH0RJcY4nd+0jtaitND5t0RIKfiDVMMEyVfwgDbU3gIKUSsYo9MHak64VRXePPUXNJjDb4g5poxmEfm7msVy8NJpr8m4Q+wSjG26AVi8ZIMzuDsqmi0MNEDw+FGZGQvKvMRG/4ApPvb3z3RmF7bYaTq7MHVDzq+dmVPHYaM50MCdrISkCUn1mv0jxNPFT4wLE9E2fvfIIxoVGlMMEfTccJ3imYsLoIaJHnnuHiJNFH2xvW/2jhbjmn33CTyN39qcTRC
 hptV/ZhA
 KT4n687zK6yAZ7PHhcgrb8WDXL5JcbtvnTHYVXa0R/enajr0pfjvVUvRqT1iXIu1YmsCB3Seu0F5b20PKqsg9uJpj8KzTmmA96f14GIDp9nUR5F/io000mojUUxfz3ZMl5n3YAcziT2W+Z/EfMBqZFIWmZRdWEO7aZC9gyRXweAmUTogSm7yGS8Zh3HTgI2Nh/8QxTF16IqfXaTS/XcseoZkgb5IeKJ+FD/VPlXYEqFPu94Xzio2xLNhogcbX8wOefsDSZ7TRg0J2s7CUTefYjV+k4Hj838lU2SpqxyAG/vmxCNiSMbPYNQ+EqbDoeIAjNcor2ro6y8uvsrEY5FBmWU8Cp6DIXRUL1FWKLoCtiXIG/2S2YkD5P35/CMbZyrAyeaRSsMoQeR5GFclTqzLYRrJPOFD/Dl+CsJ4XEokWt0L0zk3f9zqKhbLmUxhwaZNTuV2vc99EePBimzHriqdqGATHqAz5ZvUtJ4Ackjfvd3QezvCcRLfpCEEhNaWgWCt5l7c6NRuqlJdj0FjeR95rGzKdDTElsYyznkYSjlo5ceO2es+RacECXTRBTiCmig+rS0Uuay6k4E3An7xYl5/Fv3NHig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 04:00:42PM +0000, Salvatore Dipietro wrote:
> 
> On Fri, 11 Sep 2026 09:32:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > does any of this look real?
> 
> The mechanism seems real, but it only shows up with vm.defrag_mode=1,
> which is off by default.
> 
> With defrag_mode=1, a costly __GFP_NORETRY allocation that used to fail
> cleanly can now succeed by fragmenting another migratetype's pageblock,
> which seems like the wrong trade for a caller whose premise is a cheap
> lower-order fallback. Johannes, do we want to keep it strict?

Yes, avoiding the fallback is a good idea. The user already
communicated they can handle failure and have fallback options.

> If so, we could add a condition like below. It is equally
> applicable to v4 and v5. Happy to send it separately or in v6.
> 
> 	/*
> 	 * Reclaim/compaction cannot run, so defrag_mode's strategy
> 	 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
> 	 * fallbacks rather than failing the allocation outright.
> 	 * Not for costly __GFP_NORETRY: those have a cheap lower
> 	 * order fallback, so failing beats fragmenting.
> 	 */
> 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
> 	    !(costly_order && (gfp_mask & __GFP_NORETRY)) &&

It would be possible to remove the costly_order gate here and just
bail on __GFP_NORETRY. But no strong feelings.

