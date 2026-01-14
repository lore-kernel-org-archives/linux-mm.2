Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACB1D39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897D26B0089; Wed, 14 Jan 2026 13:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B2B6B008A; Wed, 14 Jan 2026 13:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E106B008C; Wed, 14 Jan 2026 13:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67DE16B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:01:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 330B313B599
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:01:41 +0000 (UTC)
X-FDA: 84331337202.27.C2DA677
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D4221C0011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:01:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cSRLXNw9;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkRPPvylgU3RO/ngpB1r7zD9/9eUo/J0Roj0tc+hknk=;
	b=hm6QbMJIZkY0pL07L0V+6Yfi1KFCnHDTJEnWs1C8Z0atOfpkwp1Hy9BXC0y/5+seJE+y71
	HdkSqVn3Baj58vPhAxs+KdVFQhNSPSFMZJhQKVuLwsda1q3bTjomnw4uqjfBvypMyTyhM6
	jUoOpwYnjaWMBM6r1G4OumrmQlSEI68=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cSRLXNw9;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768413699; a=rsa-sha256;
	cv=none;
	b=k0isbc3GugsR5cCwQDBCccdvIaRSvRNaOOyDB7GiCXeIdAnFhYEXmmGJvuXeMaUpbF1Abi
	RGPkYdckdAmV+l4q7BQUGz6N7ELwCGjoepYcT653q2x/gbp9liIcdavg9MsxNwTlqy1+5l
	1KgDE2mK3t/D4pNWennDBOK2LReFEwg=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-501488a12cbso474231cf.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768413698; x=1769018498; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JkRPPvylgU3RO/ngpB1r7zD9/9eUo/J0Roj0tc+hknk=;
        b=cSRLXNw9WTv3rMbWsR5g7OMPXyG3M6B/8ewOFYbwgIbhlpkDOb/dqx2yILCLB8XbJz
         mvpXPE2akGfqw7pR0CQE0G4XY071OWTaBaG8l1411tVfWkIWTHG53ZvtlBjToemegnym
         sfDMsSyND3qs0nSS2lTEBNDiwaFF+DWN8q82V8m+bd85QW2Yq4eoGmVaTr+coCghNHLQ
         QgU+u4hPMnHJX/nt/U4mH3Mie4JMyEkXTobpHVfOJ6yRALid35PXp/X1p5b1V46zRv4P
         pfLi/xEaqb6sxS1hgjj2cL8ASJ4Yg+jL6FxpzmK5SMWimbFJLosTM7ebQ3Gts/UE1Tze
         6bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413698; x=1769018498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkRPPvylgU3RO/ngpB1r7zD9/9eUo/J0Roj0tc+hknk=;
        b=N7S02/ABTqKy/KMm5GGNAu9o07aLLbYyg3El+reblyIShvuWz41WPVX5toUYjQqz8e
         gdneNDbspEKToFTvWzNbEnyl4hq1kxN8bbSWuYnA/5ZNB2Tc/PucmG2f0coaheRVUXZH
         0yKz5K/rJMD9sInrESlpDVm6KuWUlshI4V0sgYb5L1ggS+C8YPZUbKiVajm5rY33u7Be
         w9Y4zrfe4Zm/E4piGJ43pxRPzacRCfaR9DsRv5um2H5HZm0kSZxzatT4Xunhg85gPHk5
         zNOh7Z+CWlW2DXh5BlCi0kcpUM2aea47JDUSxevfGxvmmeYIUwPn96Bt516AJz+Wklw1
         10BA==
X-Forwarded-Encrypted: i=1; AJvYcCU7kI9ojr8/6OK9N2JBbdKtkqOpD8ujJw3niWyJmvvTIUZtrI70DJULQ4o3cGt7A1Q9m0GOKDoILQ==@kvack.org
X-Gm-Message-State: AOJu0YwAhr4ZuE6naRuD48+6UcTNU70X2kVckCimDnxjkTU25q6V88HD
	zzn/Vd8cJRzEeLUxW8AzYkmVzCk/K7kdnPaR+uMWP2PZka3HEB6VSyRB0jplN0uyx7U=
X-Gm-Gg: AY/fxX6DTZbqXRHOGwv3YFVP1K07JCSjwVeQBzPkTxGYuArwtN52w0p2a0fP0C1tRrQ
	CtDuwi0ro3oqfYdIJqNZCAQd9qba/kRF7HflyPv+Sbim69SNYEbOYmOtxfvMlkJzy9hVNUUHPtA
	+XXe2NgaiD4CqKdgJoE6m7xIaG42K9NmlEyOcQFahJr+dk1omDnpsXojHATf0XBecvHzi2IknUR
	nZTnoTBDwRmvjRiKNC0DdNBCY+NNp/DBTNBrbMaIicH9DLNdYWEt4fH7zJsQE1jb8iwKeNttlnm
	wYw2IBfs44MaQgKUswzt8fqtOOK0e3Ik+F4AEDNpLjsPXOuzFZNzIs3Gv/rQLi/x8CFhPjhmV4M
	qIROASW9BqKsTZuu1QKJPEcAPW6OeMsPTZVL837C0zPCDI0AEEUwnZ4F7sU46Qg9Sl0lNSLAsdo
	FEYlxNeAyzXKiQrHjGJFRtmNiGTHmv8e80LI0HdNDJ8UU9xMIB2EOUR2Kph25wt1fikAX+sAIWw
	sloTCSG
X-Received: by 2002:ac8:5884:0:b0:4ff:b2cb:a44c with SMTP id d75a77b69052e-501484b57ecmr48602601cf.83.1768413696746;
        Wed, 14 Jan 2026 10:01:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148ecc0e4sm17336781cf.23.2026.01.14.10.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 10:01:35 -0800 (PST)
Date: Wed, 14 Jan 2026 13:00:58 -0500
From: Gregory Price <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cgroup: use nodes_and() output where appropriate
Message-ID: <aWfZ2lkPQWF-gihd@gourry-fedora-PF4VCD3F>
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-4-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114172217.861204-4-ynorov@nvidia.com>
X-Stat-Signature: bgj6equzcqfqdnwj1njespwe6rd5yk4q
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D4221C0011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768413699-616602
X-HE-Meta: U2FsdGVkX1+r1gDpVIMTOPmsLM8dcNn/sQg6Se3lYsYAVGu4V95pCHaLN5VxY6Jm7n5xS/WM9ZqoZoIAp68LrhmrQ/eO2FtBdOVSyViCQt1+xHMflxX0OUrLITXjeRvr4KQnpgqteUOCYFXaw7uS9Fm2v4BycFP440DWw569uA7y62bLDVKu1O/4H+01BB55rQNKFmeGqF0far8fIImJk483TRE4+3Dt0IOr3rRXaGhnUNsQY63k4ZifQS+J0FBRJKMHzBKnt62QAxZptOpftAnKjxy9waT1fbQ4N2EPi//qVEWdTudj9W8I7ylmePbwrpenJIC7SUtus+S5Xq44pPRefrT1FLNa60B7wa3OvY9gwD1gZ5IF7mu1c2ws/wTdPpLxCTSb5E63VI+gsy4EFrkUOaQJzb0WpWluj+PC656kzypTIdG3Q0GE7YCT9cumPlkokWvbVgwJ3XCw/ZZiSr7a6OatWaT3Y6nrTe1ap9jwijobOXng8Yia4Q7jP51R7cP+rTC3inTr8l8zyUGsvFvwSU7R0H73XfyzbERDNK08r8yEOqaczFQQvchiQ8DPaIN2CYznvgn9rz+FSYYbwgnijEcfEIt9aYtwNIxFewrPc+aCsSo+hKqMnAvXOXNdQ+roGCwPnXXcOIrKjJk14bWJSg90TDglOUeKNY21EBBOuU3+3BJYC5BkBReJ4g94XALeId1hw5nLwQ5MonowgZYV8+eDG25EWKkGn3Ykr482QDNbvDivXeOdS3s15AMroq2WvU+TyXY0V6IN3+rwfYG4OdDNkLSZ729sXPf+VdwIuOlHcuGy48fXDlQhb26VQ+Cy4kF1OFHIF+PIbWZ2Hdw6q/9exmAT9l2ENVJ2yhemD0LVs6jq14UeqjBZcitDmxbhQDUhOUeiuNXWzXrWScVX/wFLJvzVXB5I65s9ABVIb5pAxxUMNksYwYOP5SxYPg2Xtb5RmJgUti+SOiQ
 YaZTGp2n
 CCyRsFOdUnjdKuxAduZ3xtKKe4aS4mvBoam9aDCa5QL05Ir5e53l61hPhgwNL8hjLDd215kh9TtruBrvlEIfKXAv9G42Bs5P0HHKMiQiGaT38N2aWVzymZMxCafEnSSmbRWSStcO3dTtKdtr4B8ldqBSlycN3cz0xayAjwqxMf0DeitdKcnlIvB+S5NKpamsLn+nV+rJeDdYAQHDeazGIydwFEABIwfb81jTcTlSEU/iHGR12DeTOqfcKtpTdGI1QT9pnGJ7D5QeHeVlB07LnrLf83SCf04fSOs7z1oO18LGeGbHsqZVm29LiqxHM9dlA0UZxC8bmdCAMV5/Prhdprk8lEUNRuV2zhMvbCtT1TVNljmcCMDqNQjVObbhmbYq9MzSPJ00VX3bnyh1jE4Y6lh8FnW6l5qS/VRmFO1Pb7XmmX7QehCAmGQmQiPn51r3D1E7+tpAVW+MzTaiIUnohiq4HAwUJT/kO0mU5TDDpungpiuP3QhyrTE7nLxXtV7nVI4z/0Pq1UwUd0VaD3iCcgb7NtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:22:15PM -0500, Yury Norov wrote:
> Now that nodes_and() returns true if the result nodemask is not empty,
> drop useless nodes_intersects() in guarantee_online_mems() and
> nodes_empty() in update_nodemasks_hier(), which both are O(N).
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

This is a nice simplification, thank you!

Reviewed-by: Gregory Price <gourry@gourry.net>


