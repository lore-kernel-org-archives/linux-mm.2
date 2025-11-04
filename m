Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EEBFCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4696B8E011E; Tue,  4 Nov 2025 04:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4190B8E0118; Tue,  4 Nov 2025 04:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1488E011E; Tue,  4 Nov 2025 04:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CDAB8E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:21:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB72D1403CE
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:21:40 +0000 (UTC)
X-FDA: 84072381960.04.1FCB3B3
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 983EF120005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:21:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PUEUN44p;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762248098; a=rsa-sha256;
	cv=none;
	b=5ZtsiIxHThX4HL5VlunsWOcxyOtVZU1mEEQhOpe5adqKHq4g7qKAG7LUI8E2VGAJInKjbn
	/H13iKBFZxk6CpqUr1tC9BhWvfhbsnLA6ctJP2445DKB2JtnFEz2XUOKzPtb6y5Ip//jDE
	MFQjEFGruxHw94jwPmDdw3YjGaZ1ifI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PUEUN44p;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762248098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3yPk3l2QmZ5sg7FNMBQuG7a498LlywoxhRJU9RTRgg=;
	b=g+nWrgXWnFCMxk/A3l59eHoyrHulNbxG1sxvIvQEbltAPKxS4y7D4W+Ax5GAebV2lyLsX0
	pjNdj8SD6umIIk5Q6xTRso3unMz0IE6gZKk0OaTjIuvHtpvv+05S1xclIMK3n8V9rAc6LJ
	Geo3I8jxNm4EWK2qQPTPHol2gXPJ40E=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42421b1514fso3087893f8f.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 01:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762248097; x=1762852897; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N3yPk3l2QmZ5sg7FNMBQuG7a498LlywoxhRJU9RTRgg=;
        b=PUEUN44pDSD0K6XhKOYpzkk2e8dOOwtjdOS6NeyhDTDOQO+mCRY1AtxLUHEO5OCKQy
         ZDYIHwNaubRO1ev2VBj+kRe4yIzZVSwit5MaTzMG/NFja4vv9A/OWA10yhPlxDD/idcf
         rsVmIkSmOJ2Twjy9aiox7zE+hR2aarehKnyejM1vZ/yMbM2b4Yt1tZzuom4D28Mo+iQG
         JON+0qpneaF7xEMc5w3lYBYQOH+dBlJ5X//h8cZ52a/lnxBOSq4+oS4oBYyELvFt4Enp
         5gW9ZIp/G20LWoD+xjMFt5SwMX9APqYY2eEjr81LgJCSiAc+v5pmgaXYnLKEkTbzPlMR
         eh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762248097; x=1762852897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3yPk3l2QmZ5sg7FNMBQuG7a498LlywoxhRJU9RTRgg=;
        b=EX/CvxjduWzo/fbuHsKcLTY5Ob/sf+4VMgCLFUJ0zBmHNtGgEZEsZz1fOLoBYBYpGO
         5LivzLGxZzoWauT8DzKgLeQPKohrWQ9kvTtN0aNmbiUMQidcNbHyHWFCmjRq6i2Hkv1d
         Dkopqitve/p8Bk+FVeFYvGQbyWtlIfbyB8we3q8N7MT8iKYRUVCf3PkEMqgKY540OypS
         MaTPrSicEzTpRUr5Qdoq9aV5KO9xuBCAdTJRkW+XOwzLWvksce1agpF81yF4Bq+Hc+f8
         e9V7QTgxfdZHaonn2UIDSdOGTvbCiSQK8kZu6JpkLhdQZpK2AqotN7M4NVtic90nE7uQ
         vPQg==
X-Gm-Message-State: AOJu0YyNPZ+H/RzcNhFVC17woNEsZs1S+ErZx0w4JVAnFfQL70v8rhNc
	/gxN+xvUB3KBateHJG/dkjp11MwFNwzK3eRdRDFYtphoLHv3d82lPhBPLve1VtsogFE=
X-Gm-Gg: ASbGnct/y7PJbtc6OG4OWyVFxUAAQijbhrDRYgq+Q+a+DbOtOegjMHKYaYakgPjhuMb
	NWUN/C4HEoIhE96Om4+RNkO7dvo/RsmLgzB9JbHKpvNxWKJSAt1ssmcWT8ZNr6kO+c+jEWhNaD2
	GHBaK24K6xm3FipdEADcQ7eO7AgTHTH9OUoNsFcbh5mIFVoj9Ntikh75zHPnKQJ03D5JVjOWLZH
	UJfUXj+lnzkawFkv9zWF9KrCxWeo3UXjnTDur22Baw3Jx/ICIfP/AcYThcXIV4d5KHF8skdPACM
	ApzEKj60M7waMM5yCjG7RS7N8QtLKIXdqY0lUJ6jb6/zjjiJkPEDuGvNkjPyE7BEhZduRFu7syv
	F6gCJq6gj9V+IW7lWhQUT96kjgTsp6amIR8xifyxt09AEBxnCjyQZ6SbXO7BWbkAGXtP3dgA6bu
	OS5RhBxbGS
X-Google-Smtp-Source: AGHT+IF4ZP/JaUkTNJYjSED1IManQD1UidWfm51jaGkLr6fndksIOYSs9Z4q0DYHoyvlN+ZlPJfjhQ==
X-Received: by 2002:a05:6000:1acc:b0:429:d40e:fa40 with SMTP id ffacd0b85a97d-429d40efbe6mr5041355f8f.45.1762248096882;
        Tue, 04 Nov 2025 01:21:36 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f9d33sm3569518f8f.36.2025.11.04.01.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 01:21:36 -0800 (PST)
Date: Tue, 4 Nov 2025 10:21:35 +0100
From: Michal Hocko <mhocko@suse.com>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
	laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
	corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new] mm/memcontrol: Introduce sysctl
 vm.memcg_stats_flush_threshold
Message-ID: <aQnFn6vPQ5D6STGw@tiehlicka>
References: <20251104031908.77313-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104031908.77313-1-leon.huangfu@shopee.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 983EF120005
X-Stat-Signature: kq1su4nmtsxa71z5zxky8nfez1t3cou5
X-HE-Tag: 1762248098-562063
X-HE-Meta: U2FsdGVkX1/SiwQCUPKt6Ca9V3WyUmdBKvG1sIRXsVqncloAQSGqK2/JrM2GRzx+s7yOyc5YH09rYQvDsXmIF/jme3+DpR9Ye+K+3ejpRzQEI3G5wK/96Kttt9C7y3mnUHVgSgmK0qAiHHFYEjI0+9BKZhoqVjGBOAL86SZCPkfzbLruz1NqhKKn6kvSmTYepOTjS30RgHJqk5jHhiwPW2OQRzB9oqTLWSKAn9g8GPgFbKTSZuVkPmqiBP0y64immIv+botUYr+LZckhpv2qtU8NaQd2gzBcpO67jde2doyU9+mlVe5j253PRjPxWR6z+fqpJgbBdoeI6Hbiaw/u63tAmyTORoxH0Q2CQojAu98BDKzDCz2mr1rsIeBEOT/WnB+b7Lgq+FN5ZScU4TFYTKvFD7Rbc2ALv4hOr1+fe1NFfdu2S/oRZYgNavXBgVwCfqATsRhUG+Es2fnQZ+rKSNWPB78185gS7nSV2DQxo5So4noJLrvlDcL4lMsjj2IGDZIjPdBhdMzCFotuHZVMQAkrGJFUAb+MPJyQJFGb7p/WVQfukxBoTkCnMFtqaXJfb9hSgxmZHqlgJ0CvJ1F07WhtxCBE3KJpt+ZChWeUNpuKVc1NRCL4P2J30fih/wz+1ovLYzEKcUHFhg27b5eCpGXk/2JsqUW4VTuuJvWcjgzNiN6EtfD3rv83ef6qqCk9M13NFDbjVMGd0UrtQEp0shfawA0FXajMyr+jSN+XupcNbFXK8lQuulCUT58/eN3lFMAdMtpzWI1VsC6ifeoaZic1X2ycFBQKHeL00/SxZBIKQaXYmnZkMF7jLMHnFEQJwWORK9xgKjyt9HgICr+KpBbgKMinOZfLJBPeP+2ujrKNJS2RSEoasNnJp5de6oTeFyfue2Fc3VF3onuj9VP1Rs1Kn5i/8Ol9aUt9KiUHM+Jlerlv14g/j740q1Hx2A6pooJyVsVabl8eI8S5D6D
 dtVlX3dD
 um3cCB/y5klkkRvXc7itGAJ1hZiJ3rjrWUMXF9NoOBfmKaxWTqOOMqC7y23px/U6kCsPZcJFtiD24rnjWqD/0SMNPTeQiO+x+9sMxDtyR7j3suKijLee66dPn100MtKIkbojYvszI6JBIF3SXtxg41OkaicDB1qQdTAulA6OjIDjPLo8P5QneGdkyzfCLlvsJ4wMQBQuMYXKKyBAfLaTcx9WU93wNKBseEoI/r4XgfYd35fZNwMrtmvoVAkJqSAytSmuHOAsXlwW6KeLFswW2J4fWHVNDRERxwLsJXf9N3ykTUUrjoWW17eVo/+/GshBipGAEjEta5CZJOnI2ywUnmXfUQ7nF7upEsNTGz69fH0NhpkYbOgFc9I+ybgymWMmJyrXSnLj14kB7e2Gcb6qyMKgLwPqI2XClPC+olKMI3wquiUSjUAKZVgbVZHr8bm95z6nc2iO3LGxL+0epagRLIkU4Cn5YOClF1prC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 04-11-25 11:19:08, Leon Huang Fu wrote:
> The current implementation uses a flush threshold calculated as
> MEMCG_CHARGE_BATCH * num_online_cpus() for determining when to
> aggregate per-CPU memory cgroup statistics. On systems with high core
> counts, this threshold can become very large (e.g., 64 * 256 = 16,384
> on a 256-core system), leading to stale statistics when userspace reads
> memory.stat files.
> 
> This is particularly problematic for monitoring and management tools
> that rely on reasonably fresh statistics, as they may observe data that
> is thousands of updates out of date.
> 
> Introduce a new sysctl, vm.memcg_stats_flush_threshold, that allows
> administrators to override the flush threshold specifically for
> userspace reads of memory.stat. When set to 0 (default), the behavior
> remains unchanged, using the automatic calculation. When set to a
> non-zero value, userspace reads will use the custom threshold for more
> frequent flushing.

How are admins supposed to know how to tune this? Wouldn't it make more
sense to allow explicit flushing on write to the file? That would allow
admins to implement their preferred accuracy tuning by writing to the file
when the precision is required.

-- 
Michal Hocko
SUSE Labs

