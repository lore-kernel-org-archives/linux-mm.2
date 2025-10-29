Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2E7CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 07:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498D68E0015; Wed, 29 Oct 2025 03:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4707B8E0002; Wed, 29 Oct 2025 03:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386708E0015; Wed, 29 Oct 2025 03:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2836D8E0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:53:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C209B1A0471
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:53:54 +0000 (UTC)
X-FDA: 84050387988.03.AC5C6AC
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id B42191C0007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:53:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RQd1e4eo;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761724433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swQK60xfML17J80u6tuXniIURK0iR+v6N89D6/+kOL8=;
	b=X6A2SmLuuTOmXeIidGQqAmxh4SM5zOgR3MrmU8xfnH+YNeOxULafv1Jwkwb19wcih8OzXl
	e3egleaVroaWFEstHTr4hG+/P3UH2FrxdRx8cRkVm8Aj4JWP3ZlNqKVFxTsmrVq5JWH63Z
	qe1DXscZgTPL1JEXLdruj3aPwxO42YY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761724433; a=rsa-sha256;
	cv=none;
	b=mUjfeMN1iuxz2wo+x6+TVEVMdcuQQMvcIAqBQ/AwbBO0mWS3GtQaOdb+Q6J6ag7h3jihnp
	Fs/gXu0gSkJ+1y+zOx5ViQ0O33qnR4xeheppmZCFFk9pTgUo/Ng3ndZCdiKvQc9GcA10Qb
	QyIrtHHGEzpAZvP0C/JFM4uhz2hdtPM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RQd1e4eo;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3f99ac9acc4so6513336f8f.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761724431; x=1762329231; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=swQK60xfML17J80u6tuXniIURK0iR+v6N89D6/+kOL8=;
        b=RQd1e4eol2k2vsAngQX5LZxuPnVp1r9YfAY88u6FWjsLkVip5pgaKBf08WqXR/FjeJ
         w6HDmY38vB039VvxLC7i6BTxYSuiemDSGbfeeDqjIHybkevqTY9tbDjt4iYGXnNooipt
         VWoACeq3XzrxlOytClKMlZR6juSpTxhBMTHppz5ohzUl6M5ZBZMqzRoEdcH1iqS7Zh3z
         fxJsBjK//eMSvA8fytBQtkrXctn5WahzdjsJnFmtF3gm6slMk/uL177jc6jlmwgABdBe
         G/rIdH6LYaJA8QDOf5tTKWQ42ZhRjDPdWEsUdLJpstwEiZeC84vTrG5TS44k08icGVqn
         YX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761724431; x=1762329231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swQK60xfML17J80u6tuXniIURK0iR+v6N89D6/+kOL8=;
        b=ULKzXGJm3pCdz8kWWxG33Sct0egT/9HMVw2+xo8uigg0kQQnjlHZDPWI7nijHDdkAR
         NZJ/9JS/dUW936yPlxiokYdSVYdROrQZcEOilkjs4Qd5tiJqU9WJsWPgdf6FFFHCtgqJ
         kr1kt5kqZwiTCwXVkh1JZth/hVlPqfOZ8Fz6DvIrCpcIg7xb9E8oKQYY71Clk+8IR7pT
         55Vtmwc0Q9uv61ie4C0j0ETqZOhb88ScEQa87roNPGcbHNoC4gJqHzr+bG+ZZ+9MmSFq
         6AwJz02xYXVpPCF8dtNbYIljezdkGfNjiIgGFkKpB4ZM+BVeYc7/nXAhcz2KpKs/TxkF
         MprA==
X-Forwarded-Encrypted: i=1; AJvYcCWpAObxHQgPMfYwfVzcfpyPJUchJ51hIMPiC6iuscZVF7Eexz2iPrQqEPRXggMLFbyCsPkiOy1sQQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5dHRtZ1VL3yfM7NpvvPX7Yd4+WamNcjLVMMR4Dh7Njxj7aoSb
	k3v9VuSkRygPAaQ1LAPKleKvodjcYXBP8EIXXpWaDURdyvAyfijr09RTbVEGsCofgBM=
X-Gm-Gg: ASbGncsXlVtwQv2XYJE7/ker+P+rSmOlXD1xZBCp95jG55P89Hwvad2QYVwjQHkO/Is
	p5lrg/8AHVjKyGGvMpYe1lJWJopeUJL662n3R+nX4zYuUwfR9zGTa0C0Qxi/yqRjYGexzxgHhOj
	akBHKRWV9H7PzWOJUtGBdz+YeYQvrSvotO2+Cz79hxqcDjLtI2r6f654y9pDED7xPArcrN2obT5
	O7GQYwbjh1izlhFavcojrQ0kHTecCe5oiSBePNUfVkvQUgayMxXVzcYZd021l1akjT+7YhVCfmq
	rTXur8pIq6VXjyMUuuN9G9Zr4cu7A2WhEkQeYVNkTm40xc3GA6ghPrTkkHaPk919rGiHPDOq/B6
	NbaGwNtG62SlWzaAaVi4K5g3r24pFAMkPXGK5lorZg1EMxP1ubKTrbAhUEkffyl+06MDdPo6zS1
	2c3VrS/RDEJIDZww==
X-Google-Smtp-Source: AGHT+IHZNv776MNAkq85ErWoiCefggPtR3LZHBTitBCxq6kWhcvpDiu2NWRGcgIae8q/Y/YRXY63yQ==
X-Received: by 2002:a05:6000:288f:b0:429:8d46:fc58 with SMTP id ffacd0b85a97d-429aefd2c2cmr1389158f8f.60.1761724431036;
        Wed, 29 Oct 2025 00:53:51 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7b2dsm24452114f8f.2.2025.10.29.00.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 00:53:50 -0700 (PDT)
Date: Wed, 29 Oct 2025 08:53:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 00/26] Eliminate Dying Memory Cgroup
Message-ID: <aQHIDWDx3puT5XZd@tiehlicka>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B42191C0007
X-Rspamd-Server: rspam02
X-Stat-Signature: wd58wq3yoo3orakfgj7tm5pr9w88pqbr
X-HE-Tag: 1761724432-658348
X-HE-Meta: U2FsdGVkX19Ahx7yRjMmhIvVy+Y4P2AoUw5lN0r3wYyqKfrNepcUu9uDNNdyOu5LElkxU9ZzUavOIszVUIxC1ukyv0VPp05k+td9p6P8E57B/wtxAot+ypV9cAUdX5wlxUi5g8ilw+E8Ktrlmw+C50meTdBV/d3KWMEtRcV2pIElrc1TExc5/XWfyY6MokH7GipqBA0czVMEdsah2/ulFS6j5cBPHoksJPIuOGPD/K6AuXZTnKrKjOah0aTnu7KyOKwf7ZL2XfqtQc6R2qLbDeLMwwDTrGm4hkDH6/dmc2yynpUwNNoEojbpC1WOL8457Hdhn/Tdo0S3xWkU/qXX18U57wXA4Pf3k+kAg83gRU7yfCOnyb64897FgG1c6Go76C9HgH8h6HJJKWqhEkgQKJcpDsuQ/lW/F09Ky4qXn1xTgv13dX+fn+YAH69iLeEG+idEcb23XBd2dX1yTeG9dBHBxB85oQl64Ivpe5T7XW4XasTz+a9bihaMuq0K3hzSjP5eHAIYtyfhoxdc++HR8r0iecLq2LbGkDGnD5zbDH8/IXcao5+eOlpnhGxSHyJOjXnx6ZXf2CUqGX7weITsQ8El6BziTGT/sGFRS39zU5YojiLJPGsle5nB/cF0ZeFJmLUjhYMgoP2J89Y4EFCh2hHFEgRXfEYw3Ol3bLlFj0djMrJipmaG9gMJMf1LNJtzBzJ4QiW3T/FncZQuDjpUQlsMzVNCQCBpccjQghlC4gDBtMMxh/a5mackxtTfIjfIz1BiTv/SG+Qh/1aVsK8HHMGn9x9VmY5qUvVOf7veCFgI2nkN+CSMBNn5RRx078dpnBgTnkU3/9gR4Hs37/4b/CzHH0xDbGal3Paz2CnTdGg7agTeCAPItV5eIICM9mfcoS3STDdwFNi3Bzr6qFYvJOlmtlZW4oDsDHhoRFr1dIdFAxRrlbsAnb0GFtVHv/aB5wGOill7vfIPgEDldCc
 1SZoI79G
 zk/fnHrJwagbn3O2vnne/V8HqGLZotF/ioHCYTdldmrivucIwwmYt3MqoivxjdtWs/exgzq4k/PeWLLRAYPu3iurmNAXtwczpCe+jFZ8fj7RnHm4+LOeWK+BPnh/ErqPox/XDi9nGdUArlMq7Dx+3Hnk6y5NhBBJYMiisVMQitBqLxJ0lBUDiCFEJQOpTEtkiZMgx8ea7J40lvflb4A2Aw5NlRNkUTz7PgutwrfigPleMAK7w1OP52yjdJI5VomhlYwEhGyvZUbnxFZ+jZJUYAzmL1e2tT/5c47pSzkGHZDWXngSoUPzVqqq5m7StE5JjdDBvD2OwlSH9ycBrOh9gOvqBzrUsW/aIKUh7AN2xaMVV/lMTXkYp5n8udnlYakj8dYSm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-10-25 21:58:13, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Hi all,
> 
> This series aims to eliminate the problem of dying memory cgroup. It completes
> the adaptation to the MGLRU scenarios based on the Muchun Song's patchset[1].

I high level summary and main design decisions should be describe in the
cover letter.

Thanks!
-- 
Michal Hocko
SUSE Labs

