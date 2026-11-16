Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1409E606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VWykdjkF
Received: by kanga.kvack.org (Postfix)
	id 275096B05B1; Mon, 16 Nov 2026 01:02:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225D76B05B2; Mon, 16 Nov 2026 01:02:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED4D6B05B3; Mon, 16 Nov 2026 01:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E10A36B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:02:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E7371608AA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:02:04 +0000 (UTC)
X-FDA: 85439936568.04.FB9755F
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 796EC180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:02:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VWykdjkF;
	spf=pass (imf06.hostedemail.com: domain of error27@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794808922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FNxbnnu/0yNQoPXbolulSs+Roxu0nUNixTH/GF4RF8=;
	b=go6NapXpAaMlXyMPf5IUkBU5TJnsbqIvEdmiU4HGvAe0jxCAST5H+D+doRnpL81B/jd9HH
	FGVYwoGCC3z9yWnEEtF9IOQSM+U/PuIh20pvLuMnUuuFcA8f7oVB/lik/SatFEe//sTESA
	Nt0SHg9SRGF696XVqiXUfk9jTyxW6EA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VWykdjkF;
	spf=pass (imf06.hostedemail.com: domain of error27@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794808922;
	b=qdBnl1Nor3lRKzEJVK5bn7tzpf2RYQvwolOeqaJTLHohgf6o/UZeWivZOyxut8dw+5zx0J
	/OFNj2gso/xImyUz8a8uSNP910id8vSvPZkmNqVH6oEQVSL4aYeVDOTBEoJpvsaCvEYT3Y
	fggcJNgeQ4dmoL6zcz9RAD64l0/gn6Q=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so2675525e9.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794808921; x=1795413721; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FNxbnnu/0yNQoPXbolulSs+Roxu0nUNixTH/GF4RF8=;
        b=VWykdjkFpFArtm5u03Y1zkSqoJL0NVMs3nJTNJgCzvIm36n5SQ+gE/A1kxpy4oRFrZ
         JCg8XWSTrzKqR0v+yqATkO/j8wBx0e5EexZZLcxKuUbylIF8ZSx7AQwu0rGfkroxMjvj
         Z9mWxa04jWrFURCHOwkw7sn15CM68al/jZ0yOgs4mxmZuKXeu53yvEjq09yGR6z6MfJk
         1+Qzb4Wnuzzu3zi+w4afg433pPZs5SY4mi+yyrj4Mi3eFVkp6snRQB3KuDPE+z2KX28F
         iZoNc/c1/D3p3+iEm5ioV26UZemoLmyTlmvZXgCjZZC5npoU5gtbs0Td7YRZ5B0Zc5di
         u/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794808921; x=1795413721;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FNxbnnu/0yNQoPXbolulSs+Roxu0nUNixTH/GF4RF8=;
        b=HooFHgZ70IhqnVOYbLq6aqXRRs34NC2b0B5cMqmT2mSpXIxcLEO3dRWkXqOW7HWNJj
         xExWpNVbFYQeiIbfiMMCzhLCQGzi7PcpwhZ01ypMX7wuX8WpdAZ5dOspYu4CO/13HEcI
         V5ZbvBJrBW5+BPsHXhNQuAb1Wrojzm/pDhDM+VSL3D/6qRG8MvR9qr2WmexKTvHqmYEa
         nsZDJdQn1Y9P3hpxf9JsyyJgQlQlZGD6oYg0736xip9N1U77RpkD6lVS45GmNvvnvys9
         eflOe7idTsGSdfkqMX0rpR/5Mgmb/fVIc+mvLS3/7ISvB05oFOoX9gvy6+MqlpUQb5dF
         51Jg==
X-Forwarded-Encrypted: i=1; AL+hErGCdgc/60Jr7qc0cXcJD7QpSNag38SbYTSVl35zOd0ICRLqSx4Mk7H+oDeD+BdMXBuN7Z34XGayEQ==@kvack.org
X-Gm-Message-State: APuU4Z/nt/GcTGSmlsyqJbtjWmabN8yW79sJq2JRb2F/X3Z/8dcxxKF3
	VeutAUrihIPrxDW/t2K2NbX8s3IB9ART8PUsKGG0r/v1VM+9mE8hV7sK
X-Gm-Gg: AYBFou0kInoCWRCMHuXq2oso4haeKWeeZUuO23ZGWqlIDbfy2x2gz55tYUzeEH+1UIw
	ORaBMViq1zv91FsG5aumDgHh95LSsGjHGrqYJosXAuC2Lpv99jkVX7FFaWGWqcj2FJN09EgOtg1
	QqHYMDqsyx8G+wIBc5Omfpq1kgs93Pyy0Eej87jRenQtiPQ5gq4p8YmzE44CnirzDBkA6x5g6Sp
	3Gjrj4+9BqMLrjoaaHFaUynFqIBTbJgA2wgL7BU2q4qaBQYG0mFXBIzKFcgzrcXn+hoAWWfg9lh
	VnfZJlqY3LFNaokriOYga2zG0fZ2Qn46DGsGcPdQl6jwlAAdTP0Wmjnc1xDoEPAiOzKMJN239m8
	3lIFB7Gow4QVdG2mx7fPKGnRLWCGWJZh/qL8x4YNB4xyyLM1aRLmx5zUadNFpcpQhI0ACh+yn4y
	1jaLSuewK8G2D7BKlr144yjb5Bd4sAWAPUz9jqO7zrZ+LU/cyvgALhA2owA1ckEq9GApML+zZ55
	RMX80oV+Yw48xNPmzEQ9IaShhrU05pprjJk73NsisnLzzaHIyyjlVyMrC8Y/+FRRqj59mD4lxLj
	cz8/DFQRYUt8Wqw92o/f1ujjOU6yDq3vMYdmrFW5J+ylOy/LJ8U/g7U4HzUW+OCuR6e9WcgWCnY
	dSK5Bn1iozcc3KavSmB9inO4x7gmkhkP3XHfOgL4aYppV1XG/7QtPEVZAsLOJZw9uBjA=
X-Received: by 2002:a05:600c:c165:b0:4bb:685e:cc42 with SMTP id 5b1f17b1804b1-4bb685ecce6mr91958735e9.18.1794808920781;
        Sun, 15 Nov 2026 22:02:00 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e29daa5sm372885465e9.12.2026.11.15.22.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:02:00 -0800 (PST)
Date: Mon, 16 Nov 2026 09:01:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-nonmm-unstable 139/151] fs/squashfs/namei.c:283
 squashfs_lookup() warn: passing zero to 'ERR_PTR'
Message-ID: <avqcVK8VjSl6RqJ_@stanley.mountain>
References: <202611131955.0Gd7ipSP-lkp@intel.com>
 <20261115215756.839150412f8e2ce4bab5105c@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115215756.839150412f8e2ce4bab5105c@linux-foundation.org>
X-Stat-Signature: otqco384qh4k4r1s6zsnqkifpqbnwkms
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 796EC180007
X-HE-Tag: 1794808922-406410
X-HE-Meta: U2FsdGVkX18SWZWFwZd6qvyIBBX7qLOfH768jF9sRHPOAbzedfGnDwfTkKadfEgxniwgHMBWzZvWG5zeDMLy4Y5CvhcjR2u/kXLkED694O0D+VYhf2ZNWa7ZghS83LAgHCaNmNKRwSmhNV5BvXIDbyqtz3BDdZve7uma80EGfXU1rpfx62sjSaRNk6CobNE9siznHUMy0jE+lcTpBgX7nl3wpti7CK3aqOLlIPGboMs95Lg/zXVuvn5lVqk1otYR3RjEw47whOd2oacyRT/SVvc6reJ+DDNtA+/X356Gx+V7u28wEPk605mHqh6JTcKrif2bOISUbRwTErCmy4btsYoteXBp3HFtLK5TfVvqToadf6QH8UWCAuBIYYz/WK1yKvafi4ae2zlU5GzqI0A2YTJHS/xFLeJAi4HrS405J8ss0iSO1hI51K0qGY3nr95M3fERhvA/lKNLkTYkzyTOYCyCTOIRvMUz5m2o+jLIgwZyphCV9RLVhUf7AUQZH3z9q/ppCWky0HhLHJVwNK25yyN58+n9p8nVZh2FDEVh9WQQWez6+Uc+I/vBoWld/CTscEIvSwjebWIICffrj4u5NksDjbkBwruWAyYnwAiOnjZbiG4LiUg52CQIll/cCoG3AIGpl/0reIIPH76OiU2ZFkkoKehK8+5ZuceKOkt4wW8EXlw+OX6NaoB0olz7jzvOW+3A36EE5JYm2kI3pDYXn9J1AiQJ3kcd9Icd71KANaPbMd+iCu6JsplT4vFDqX8x7X8jmJka0FjoX21zeJM091p2Xjwa3tf3e2uWMDy5bKH3On+A9NVEdz2GgPlYAA40Ys/8mf/+6SclC02G6U9E1/CGxIAYgmnNPxeYiqtig2tHBw8Jut7hI+GCFmcxBX4Cu0Ela0+rdYy2IIeJWK0Oais5QlKEXIWFPgfjYtPhAkzCkZXPCyqfNsJeaw7xPRte+qLpK5KFJJYTrjR+K4k
 6AX+Q68c
 +a1uUQ/HliZvfXMqyW7uXEbKsXDhqUyeLnw2yyB2uRThDmwhPJCsYvI8D7QPWcXGaqfSNFSMFsaQPcNsXrVSPgbAMPJlJS/yv/Z3pmxEBB/yr0JqSB28KtxE/LK1o6wk7Bvbzy3nsqbMeHqxO1zuUNTuczSMf2k2h64U606Ta/Frr9FYRIVR2UKeXceN53pKn9jcMGJ1DuUU6rBWVz/9L+AvpWiS2gechmMvT3ulOAi1v/xEi3YP1X4QQ4VBIb+8g8a8fm/YWIuReyewNv9PU5Ln3aS6b8xLw9f+bQ+BMirPbmvGdgXUYgsFGD/+/mQZrNjFl9j4Ed0iVXWMSsKxhaISIz3qTKuvmA2ErXc+mTYpAEIpcuG1uslx7efsfPTk4Rpo5fxc11yob1p2cNxkpteNxIaxxsLlKCXIhRiPGl5jv5THyH1SMLJzxwwZJMsFjjmlYZhEJ6TX041Dwc1LNXhUUH5A9p5oGEU/JT/GM+IPGUqvCWaedAXz16FGVt0VgZrUfu/Mx2TWhBLKS8RNifeDbSZxImCoh7VOmuTMrzH95iJydy+qjo2fz8u1LqWR1Da8y8ot/9VOl17Ni8eV6Te7upCx66isWNkuXIIFISJAkzbrZynfwVkbo+ZPlt3IVrp6DKdzMJGQeqq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 09:57:56PM -0800, Andrew Morton wrote:
> On Mon, 16 Nov 2026 08:26:18 +0300 Dan Carpenter <error27@gmail.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > head:   152f0559e66c079f717de375f133ff127afb1f58
> > commit: 5213b0a08263b2191b86b046c3a63f11e8abc399 [139/151] Squashfs: fix variables in directory code and add more sanity checks
> > config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131955.0Gd7ipSP-lkp@intel.com/config)
> > compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
> > smatch: v0.5.0-9187-g5189e3fb
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > | Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
> > 
> > New smatch warnings:
> > fs/squashfs/namei.c:283 squashfs_lookup() warn: passing zero to 'ERR_PTR'
> 
> OK.
> 
> > 5213b0a08263b21 Phillip Lougher 2026-11-11  224  			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
> > 5213b0a08263b21 Phillip Lougher 2026-11-11  225  				goto read_failure;
> > 
> > We need an error code on this path.
> > 
> 
> How's this?
> 

There were two paths which need an error code.

regards,
dan carpenter


