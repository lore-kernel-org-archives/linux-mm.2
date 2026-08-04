Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D9EC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CA06B00D2; Tue,  4 Aug 2026 16:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63256B00D3; Tue,  4 Aug 2026 16:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78BF6B00D5; Tue,  4 Aug 2026 16:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2F8A6B00D2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:48:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50A64C02D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:48:02 +0000 (UTC)
X-FDA: 85064774004.21.06FE650
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3013E100006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:48:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oQs8nYZe;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785876480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5nyhXmOrB2zUXHw11JnHUdAjL9ArQB4qSPGcWi6REo=;
	b=8VdHTyENI3CnP4GJTc4zYggQaG+QrpJD26gdQGF4TmYWF3JwqYJ+oc+JrxvMVUawHMkkRB
	eAdDt49cEY1V/iJu/dbOfaMiOmGKIsgAlk1HZVjJLxw7LswrM3fq6ZuxUwArdIp01qOnup
	yNYhUf2gEzjddwSKQIRMRBxcJOX3zg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785876480;
	b=iw/T1lcwB63u6SRqmiFRS/82Zvg0WcGoHkTcXGIfqMjwpjwXGVakOk5+33ZufKTUKsMhYS
	ErvmeSg2DNqwkV8rgvvyUoFbJZjgeTkzLPFSpvVGosE29Ssea+s52f93uJTjvpQ6h5S+ZP
	tYnA1FmiV1bdlcfMZfZTiM43faQ9m94=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oQs8nYZe;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c0a81d286so9871351cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 13:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785876479; x=1786481279; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L5nyhXmOrB2zUXHw11JnHUdAjL9ArQB4qSPGcWi6REo=;
        b=oQs8nYZeAl6NYTsCXqLywL+QY06EbKYo15B8tcjSCVXxHRspNPULF7ioexc7xzP6SY
         Z5ykmRwRLG37WQdrWjc4qLL+aMfxVKVgeul25zn3ZIXssZ8bE7VEPGF4+RMxWpUkrQ/E
         16k5Ig43tVodKwo6fW4bLmYqdM7MlTlZcum2BNXcUSWl1Dw+roYWmYO679p4Ler6huvo
         /GMTuGvssMtHLcMRY11Qi5oAQh0TBpjr9MRRj6H4UAF1V4UcuJCNtNoZvXgD4a8fJXAk
         OPCkiWJItafvQfmINKfjwK/S43eOx7gCPjlMXY62ZM6BQtJn0jJ9/XeQKpC7/a1z/BBk
         wtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785876479; x=1786481279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L5nyhXmOrB2zUXHw11JnHUdAjL9ArQB4qSPGcWi6REo=;
        b=GbrULQppjdLWXZYYK4lMWZiWx3pgsXCZ2GMm8QF0XK4m3A1VIaSBQRQkzPvzWCTspv
         nnKa5LNJTpHm1Lww0J6uLOjbXSoy6FnwUAIyfRhQYVsGUcmIbmna1HHlTRXYGK8T3z1h
         YVaQkYsTUyQ98jgXF79vMejlw8dB8huKBo3bb510ukEmO1Gmm6ovr9YjTBHj6V0FIUOF
         3R+7+Vr3ludgGRWPN1KZ/aFUyfxMJV20vg4gWLLbjULBgUbOUFOuTDoU3eEaYnMdLkZi
         aIxkPNC03BpkE8MQ6JTpII3UoPOE4iWwnIgbeC8nEEAbP7D3ZTW62TaGjBUvO6WYYMqi
         mBZA==
X-Forwarded-Encrypted: i=1; AHgh+RoTuvrl2peIa34Hb4lkrWOYmdHOF5EgSfADb3ZIL5ptADbFgG141hN67jebUs+/WekClq72NNW+Xg==@kvack.org
X-Gm-Message-State: AOJu0Yw3veqkIPFhAT7+0T8mXU6H/uCiGs9hFYCaVaLzOx2zbu5YCk3P
	kTAX7WmiFAiMAxNplsPOWmu99IUfSBFV5jiScDa3+YMQeApB9GKR7mFRCq5OgcwnVnQ=
X-Gm-Gg: AR+sD11mpnVGjJntMbIyWFNwKhFau+GgfZDAiPQ58ovqCtHAZ6/o8xC9KQ1IFEC7cRw
	L+oKZHfhJqDdnTBjx5QfjSQ/SmVcY11fddulY8J5fq2I/ooZ6tSAMmr03FIoPKBkAXRlE0Pes6E
	OdefTDH0enPNvWJuHzAwfvazWU9sqRGa4Fxp3FM5DsmY0b2JpsNG513z5hcLTLKehVK7gV4CPuE
	qnOXeZ3GKhRBWrKsmFuLdz4PaEEyMqWwGEQOHyRcZkW3BEedHuY0mKaBZKGAxkPK3F9Quu6VMsq
	tEqBC4djD+YCfMPpPXUxgK5pFvKUe4dc2UxGPdgAm/mIVX4kT5De21DreGMNyyd86jZWv8whgQC
	8GePd6QTnw9YWISf+WHkBntEBcxUXn6vkiTY7ed7X6+6wTP8QNbw/AL3x5/Xr3zTqjsdsYNH27T
	8vvwJfvyS1m7c9t9s//9HAxPdMbP2+iNQuyaDiDS1BlqFqsSHGoOM/drV7dsw=
X-Received: by 2002:a05:622a:1448:b0:51c:1ea:e290 with SMTP id d75a77b69052e-52ce5d43adbmr22028211cf.17.1785876479124;
        Tue, 04 Aug 2026 13:47:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ce87aa1a3sm1446391cf.6.2026.08.04.13.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 13:47:56 -0700 (PDT)
Date: Tue, 4 Aug 2026 16:47:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Message-ID: <anJP-FXqH3iNjTJ_@cmpxchg.org>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
 <am28pV2PEfHsi4p-@lucifer>
 <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3013E100006
X-Rspam-User: 
X-Stat-Signature: k73e3ucrgb6u6s13eiz3cohr9c73esoe
X-HE-Tag: 1785876480-338418
X-HE-Meta: U2FsdGVkX1/Q4YoeGmQlKG1XmElWq/bmkQtl2Itbtoxm1m7oWjJkyNPhIzB1E3pgC8YPN8oPZsQ846lyWcEVMCLsZTaYEO3HFu5gJ/UwdzOgDRPnI3KJGcvNKcGGtAP7pvU39joAbwHLgr4UMGGsPRIGpF2AkFSlI10Mn4YfuWwdid+QDWXh/aDciULTjBXrJUJnX15dhipcT0vDG9Z2YN2duO56jjYMi/Lu55X82nTBizpVTprrkPQYkZO6YKfv4lZ17QRhD0o/R7RkwdoWtbxVEMeMYABWgSGyXSC6eX8BdN6CFW/5CpXurcQsQBEUW5eJdjQuGyyE2A4GXxjgmNMz80vJSzd8RjSATTDt209dnRi8aXRuplRi5bWGJTQ3uMeqTbsAu5Otjq0YoyVTs8c3ge1jW4zhEHkQIeFBtSXb0AxKm5PcvlPEIKli0XvuNDFulBcmysxLoDcgqcvwzV8redc8YorUM2/EMdGxKbU2GK835LyGl21RdhdX+fAlRvtiHnEYrj1U8WPS6iJUhshNH9xH2OXa91pQInhJeFeEO5o6COQ6gF0FWxGsS2WQyiiJxYc8FnKbZ8ekaLI1RjnqPWLsNbcwI2fMU2fkGZ/38dxlyavGVl02A/JRSOtXKa+YlRgNgGBdoS+RA31nUTGA/vlWBcCccqNNuGNgcedq8UX6TvGQeq3p8yOJwHwWPl5zmQnuMJJ/JrXtlsxGeSsM2fBKqdCN4KJhFfFxyjuWQeZahJaspUV5FQpM/iigHq1YJi4cf3zI1nfDpp87k+cJKq3QUy714X1RBcNuvqSE+x7EPQn3EyOTMnc3UuAb1NIZwnh4/T/oR5qwUP3FzF7M4BQofaxFh6oHr3p/J5zWWgZY9e2B9+dsFRTk53ro2tNSx70AF/O3F62FuNKAE5LIngye3QvtiOOukXPU+BNw3TfaiTpqcvJTgFlIgn/pVJ1zp9GLYtPycX0taMJ
 m7ghiTIJ
 lc30LQAsey3MN4nPExyHPaQNoG0/CAhwy6XjcFVQxZnzqX1jIZniZHCO7rahUgT1TGEBJyed5feJXpHk21OrhonJ99ZAuav0UmuDS7Myaaza/VpKfopfuR5PBE/sh5+uZzBiuD+E49tnD/+XUEb5Yo8p1cw4/cKrNxEGRlfuV64UU+ohykzRisBuwmzAJLFLiey00o92Ed1GGahyNnuG6jcoTzLksYjIApX6+poeaPePQCldr1HKJWSN6QwiGukb9gfrW0FKULZ6bYkc5jM8QyIcjToV7qTjunhNbEcDv6GO3qWMTqHeYaW0UXyscfPAhPuXALhPfGsWRqKMn/KjLgOOdYGqeNEns0a6cftD8fVjAibC57Tbb8wrf/1cCJB8RhFEWUDp0ui449XvB6GR1UUP5E4enTaxLVlYCUmQdII/MZs1IvHImr+LFDOHSVKFPMgpMtP67QBnaNtWkKmAAoVawA9u7Is5I3w1K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:02:30AM -0400, Zi Yan wrote:
> On Sat Aug 1, 2026 at 5:36 AM EDT, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
> >> During a pagecache folio split, an xarray node allocation can happen and
> >> needs to charge at folio's memcg instead of folio split invoker's memcg,
> >> because for example folio split can happen during reclaim and reclaim's
> >> active memcg might not be folio's memcg. Switch to folio's memcg at the
> >> beginning and switch back afterwards.
> >
> > I assume this is the only allocation? I guess in general it makes sense to have
> > the folio's memcg be active here regardless.
> >
> >>
> >> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> >
> > Cc: stable?
> 
> Like you said above, only xas_split_alloc() is affected. And we have not
> seen related workingset regression report (like what Johannes reported
> in commit 7b785645e8f13 ("mm: fix page cache convergence regression")).
> It might be OK to not backport.
> 
> Johannes, what is your take on this?

Yeah, let's Cc stable.

It would be a bear to debug if you ran into this at scale. Which I
think you could with certain workloads.

The patches are straight-forward enough. It favors a backport.

