Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50F7E63F3C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 08:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1155B6B0005; Mon, 16 Feb 2026 03:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099236B0088; Mon, 16 Feb 2026 03:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC30E6B0089; Mon, 16 Feb 2026 03:26:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D610B6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 03:26:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4214ABD274
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:26:08 +0000 (UTC)
X-FDA: 84449637216.28.F409505
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FEA9100002
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:26:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e+ZEMHa+;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771230366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xb3Y5mpUx/KX/i4KodCYFSkUEnbxPYW1NpgmoLibx/U=;
	b=F1G4MvkYBy1krw6l/l79Ve8nxx5ffF7DTORJ+FXClWGW2X5ELd1lLbphsDQLMglHDvsjaT
	1IvyYt3boooZ0phLvSVzFrZ3FXIOquIESMbbWkJ1qNSNjEV5WiqcKBzLyPSUtLHULkUG+8
	1BMS4qPdA+4mSAxajatYHou90hebGuI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e+ZEMHa+;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771230366; a=rsa-sha256;
	cv=none;
	b=XvadAPL3qXD5QQ0GbbK5as+3++/Jkmel7cmXaqbRFXCIW4JP1m1wFwne6st6koGESpVJjX
	WC+yrnSrdg+LXVGgA340z4ZtyROAWhedwlSgBvgu6hV8skIs1EgWj0xGwwZgNXzW+2NRaF
	E/d57RDrx95nspufEACJNXDhJxohzS4=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-48371bb515eso31691855e9.1
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 00:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771230365; x=1771835165; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xb3Y5mpUx/KX/i4KodCYFSkUEnbxPYW1NpgmoLibx/U=;
        b=e+ZEMHa+Zxn8w3fRixuVOCt8/40DMky7ZBZN0vQg4c1ckW2v8xvQ74jiQMkTs8s/iw
         sJyuz1JFw0rDxqUuExj5PY6TpEq/pVomyqaHB0ze69lZvCU0qHzPQR+1tw7q4eYe+oh8
         a3pKce/fIr/nFJLu/XzabUmSQjTHFu5PqqxATQ5kyIpL/sDdfVaVJR/uJ2uhMN0hpn3w
         PfDmDf85g0lo3gxz/qvIxJSj2ERwGHNP1p4UdPUs710PXJzxZ9+Bnc00PNfX4F9BrUTR
         doMRWgPk0LKu4Cb7EmDJVzp6NhWU4FUTmwi/nE8jPgXABFQtFViJtDiaf9CNDUtkaQ4W
         jk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771230365; x=1771835165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xb3Y5mpUx/KX/i4KodCYFSkUEnbxPYW1NpgmoLibx/U=;
        b=tdIOco7myMAY5317ZFSjBuOs3qhjJ07Q9w1S0iJPG6omYWfUcjsLzCNcUreXDcWH+V
         tJUCCXP+YrxDAQ5zJEpWEQeVDCAHGA9BW990ZheaJZjDmj2/Oqxml6kjkXlNo4Sc9mKR
         03MXMEj1j3Pcm4DaTkbjL43doWjF5Xaq2+kECbAP8BQhgVDvu9GW7mctxkcwO+LinJ0N
         Qjn1u4GCPF8uhnTcjLWGmF4JY5K8phVc56c+GFgRZ4y+bFCRw8EsEtaALgm/PyhYCOb4
         3f40eB5VANagu188sk9tOEA7D7wY+0RBWchg+hbkqvXpWBvL55mNQi/cDYt6wKw2M/uh
         SBOg==
X-Gm-Message-State: AOJu0YzzCjGQXzd2NeCnMhnICR9udJ+SJeo+msZnhyrY15F/vo6t7ZI3
	6zYmbmeR/VNbimS75aY4gDAX6H8/v8ceB1Vi3RqFH2RK0REkuoCOkT8bvxpB+Mnzapo=
X-Gm-Gg: AZuq6aKNwGFFwZx7ALi+7xVGI7FEMhtjImhkkrlu4jb1JY/8ITeMz/yw4buC7D94u4V
	AB+zqlAmZFXDazQ24KN/D5X18QsalDo5KbvVD87DfoEDJmajukm9szbSbjW/OsSfj6t7yooJVbM
	525r0sM6wkHylXEJY3XM4Os29sx6fktcXrPdDXPqkcypXBwFNXHE40lIzVOSRbTlBo0ky4fScIk
	Hz3VqsI7/rBInZzSbnQPwvALfacThSKIzJ2rhC2S/z1NdVbmnizOrnywbOC6f6FirlHCRAutJX/
	GO9GXrKB2W81Adfg7ceMloaeGrqhhl3GlrVckVoNZpXjo1R5mBw4ByNPGVUuHRBARfzyPJPEJqc
	0c1Hj7oPeosD/yk0OWya6Y/DwJpaKTE3PlNWNY1VnDSUYxk4gdjjZewv5lcOOtpmFYbLiG0ahd7
	JJ0YLwYYcS3J9O/lQyfpcDov9KVymtMmT/3rrN
X-Received: by 2002:a05:600c:c170:b0:480:4a90:1afe with SMTP id 5b1f17b1804b1-48373a78d47mr149302415e9.34.1771230364694;
        Mon, 16 Feb 2026 00:26:04 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a337dfsm81435315e9.19.2026.02.16.00.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 00:26:04 -0800 (PST)
Date: Mon, 16 Feb 2026 09:26:03 +0100
From: Michal Hocko <mhocko@suse.com>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aZLUm95Y-dKkdBWI@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: j3dy74ehto74h56q51ojciahta1e36da
X-Rspamd-Queue-Id: 7FEA9100002
X-Rspam-User: 
X-HE-Tag: 1771230366-620222
X-HE-Meta: U2FsdGVkX19GamPaKuMqCpw5EUy9AJtqMG+kEplOJ9WsCjIoCdfK/kzlqESMHXSO93JN1Uyn0zn5yJNeuR+YB0lGhq+xhXpdWzh7E0zVmY56qGw+M94DOHDvhUKFaFsUcGs8FywWXTFvfGgm3RGXxpSIWJCmUoixcSKlqIwsov7eTi7dlaJw6JM2ksPlTmhXOE+2ZG9nQdmPMNjU3n/I+knO30rEAwUkEgLNPGeuXjmd0gbayTsc1funZX2jVLfEEMDIALcGLyjYHNkM87CVqGJ0gJoEhwf9XcR+Wxc+p+ZwJFhuwc/+OPo7AVd9FaSSSq0DR9Q81eMqfa9Ya7FXs/tkJrmmdHPnZEj3zPlJQ2ngZgYNNC0ZU0XCAl2cvXvOWwNpQDgw0Dlw8nuC5CJQVn2ifzb6oUCnJa3I1LXcucgIVAaf1jorwodHHstyKFXn4P+05BOV/LZ+SXn2kbB6/g/zyPDY+u6TxdeYCGAXdVrXDqlXEbrqH9D6mrfYJWy7VsQPUtY/3RgrHKRuqFtnhRPscYWSnKa/OXYSewEYNMNsBgZdu90kN/3S4FXA7t2SClnI/eTGnhw6nnwXSJZ52VtyGnyn5ZzLVg8pFXdjOujujBaM04AETBpRb6bIfm/GLsHnP0hYQZiy3AZSucqinm8pU50iniV7pXU9sYObAAJ0o46UeHL46L7EdjUTCp2APoofb5fGL305sUPDAIJObsPADd3ZlNtn85+6ZOS7F2+ilt385Uc/JEJi+3h+pxjBYhITYIgpzRWY9vrSBLvmQrdMOS+21EqqUulHMBd2m4zaXil5W1oKHhfyCfDNzJwuZ3RLH1axvqEuCnDZEtBxM9pEhCoqe72ds0qMvm6g5yQQ1FRVDNsw83Opykt1kDw0w0toFXr/KblK4korhTkf8z8lGTNeeSON27LnQRyjjYCOvCmXDCbF652K+daTecvYdq98eWh/AKo7v92z+3+
 BZUuY3uH
 33NEOoNsDpzEC4v20tg3lfrRS8nK3qWSNpjQcCuCnUfDXoEkafyrjKY/cBIYacXFG5BBSBMC3Fz0jMo/Y3atIgqFlIBJShJKEoTH7IsDANTAZ1gZCWBXuRzq7zMmqRlcTs64s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 12-02-26 13:22:56, JP Kobryn wrote:
> On 2/11/26 11:29 PM, Michal Hocko wrote:
> > On Wed 11-02-26 20:51:08, JP Kobryn wrote:
> > > It would be useful to see a breakdown of allocations to understand which
> > > NUMA policies are driving them. For example, when investigating memory
> > > pressure, having policy-specific counts could show that allocations were
> > > bound to the affected node (via MPOL_BIND).
> > > 
> > > Add per-policy page allocation counters as new node stat items. These
> > > counters can provide correlation between a mempolicy and pressure on a
> > > given node.
> > 
> > Could you be more specific how exactly do you plan to use those
> > counters?
> 
> Yes. Patch 2 allows us to find which nodes are undergoing reclaim. Once
> we identify the affected node(s), the new mpol counters (this patch)
> allow us correlate the pressure to the mempolicy driving it.

I would appreciate somehow more specificity. You are adding counters
that are not really easy to drop once they are in. Sure we have
precedence of dropping some counters in the past so this is not as hard
as usual userspace APIs but still...

How exactly do you tolerate mempolicy allocations to specific nodes?
While MPOL_MBIND is quite straightforward others are less so.
-- 
Michal Hocko
SUSE Labs

