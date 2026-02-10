Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29770EA3F0D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 06:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8236B0005; Tue, 10 Feb 2026 01:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485F46B0088; Tue, 10 Feb 2026 01:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364C96B0089; Tue, 10 Feb 2026 01:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2595F6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:31:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7EA78B78A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:31:53 +0000 (UTC)
X-FDA: 84427576506.29.69136C8
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf20.hostedemail.com (Postfix) with ESMTP id 941771C000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:31:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=jPlD6xDk;
	spf=pass (imf20.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.65 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770705111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=PuIvHjahYrqUwfgodntxdfFSIIlE9ggIgaeNW8+YxZc=;
	b=3tCD6m9kGjXbvfG3kKrvrEKJ4YLKnR/ns7xsjjlVetdcZMG0/8utt1LWoCCDLe+pkS9LFY
	uuB/2uEYYRHa9eNF6KD9Al4dc6ilklIsOcBBGu7IcBtvWqIfDX5TGX19XD0UdPwfUYumSS
	GDglvqN3xUZrBRWIJYzVBEj1qYX1aHE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=jPlD6xDk;
	spf=pass (imf20.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.65 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770705111; a=rsa-sha256;
	cv=none;
	b=U2UaA/McH1CeQXbxLGY6XSuDeoSyUqH5xgiG+uPGxUAv5+vzljqmv1HK6WUP7otW1ZDAlI
	t4JfK8W9CFEBj25/9akaM2qWHxwFyNxQRfQicKfMeZdWSwtvbGujdbX0VfJwSVh5sD/5TG
	5vLbxFlmL6eChSe2lELbya3xS7u4LMw=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-48327b8350dso31542675e9.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 22:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770705110; x=1771309910; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PuIvHjahYrqUwfgodntxdfFSIIlE9ggIgaeNW8+YxZc=;
        b=jPlD6xDknkHOkegZEPPCOx7R/RvDG+AR3w9ly6V4T0J7tNAdTtqGEzJ2WBPYQwZ2oa
         5V89SX7KHbK8AT5E0wiOm2YXM1jQfI6igwJ+LKfHt8UONbSdTbRTBy2QOZAmv4pfeiRg
         Vcu7SL3+/tAT9kknfSkqRuNSTyj2Tj76falnKHptGJRs9mhwd1TzCOaeWMWO93NePG9T
         kFvlZ1hFKBpcNIV22/j+zhIbcFAD/0v9dCCv1T8fPAgk02LQxxvRqmSKwMTmlBm72IS3
         iFdcoJ1GpUr6WOsoz0Rdkd78FjfqAbRL7c2bTEPTLgVYrYqAgyZ2b0amklaMBSn10whh
         a+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770705110; x=1771309910;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuIvHjahYrqUwfgodntxdfFSIIlE9ggIgaeNW8+YxZc=;
        b=tnoGSLwjPmjVNOGGh5alWKTjVbydveUXBljfQ6Go95shrwAwcqMiomT2+5T97NbpwJ
         TU2Z482dcn0ZM1i22QU1ZrkU3jzfSfsdefjuUZgniyr4MGb20dIISYOaqk/yx+qL6wWZ
         sihIimK5voJZmJO6+ejZpTzC9SJ7hhXdfwL3heVkGhoZq4HH1jAvU/M0orn6TmUDD56v
         j2aEjXKKhiNmdkjpcXBVNOCNyIY/s7zpCM78ydchAGORbBBVMygTJeyTbieZR4Z2nUx5
         4cMzuWdocg8cebHHlQ0wCZkLawTJQKSZfZhZzfTcAKfMz+bOAGa+YH3NOOUgxcFqzbdw
         NP+A==
X-Forwarded-Encrypted: i=1; AJvYcCV7hjndPdsZoC/pErP+nJAgCNtAk6VKeyGYRn+TilBVlJcKClY0kOxRDI/Ak+HyineJLZW1y4bt4w==@kvack.org
X-Gm-Message-State: AOJu0YzOi3VdWrDRR2yb2r+d0I4bBzh0kaM/Zs1AGBRxSTRneKvVsnjc
	Y06xqi46AupPieaOZgugcZaib2smq2G62WZtew+G4/yGLMPnhf4oh56qqskGAx4P8+Q=
X-Gm-Gg: AZuq6aKcxLVOhiVLxd0BiwowTe+ZYfhN/qs7ZtNj32R/MVwKxsw7Rq3Nr8lxw6z/w74
	akBHJNw0lsgSfCmrghPTvzwaGDFS7DBg3OHTPD9lviPevWofeCcfd9ovmFeV5NRE6tWmKkl7iYL
	cPXye+pINjhjmal4HH19DzZu/maSBztvMRzbRkl6mEeiV321ko3LY45jWntTGpZmwu6B2GkYXxI
	O6rmlmRhYAx/F2xsK2uqtgIA82L7wQjhSMX+LUJFmswra+awiyZJ8NB5zBY3uUKEHqWtU53sc4Z
	G/eBBe/AsdG5voL3WfkcVDJRXce4UaFdf6y5TVlmlOeuNxECpfnScwuIegHfvaILAbQTZHQi77A
	ujGyhpRc2h8PlHIbyUpgHpYnaU8IGKSh6V1Es0LhNX3kmLe4Ih1RrrGz5lO79WIgrLlsrkBpLuB
	Gd4LANxYhOnnD6xrwe9BgdiOuXMSVW
X-Received: by 2002:a05:600c:4f8a:b0:47a:8cce:2940 with SMTP id 5b1f17b1804b1-483201e3aaemr189459165e9.14.1770705109669;
        Mon, 09 Feb 2026 22:31:49 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48320961505sm215017735e9.4.2026.02.09.22.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 22:31:49 -0800 (PST)
Date: Tue, 10 Feb 2026 09:31:46 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	hannes@cmpxchg.org, hughd@google.com, yosry.ahmed@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu,
	pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com
Subject: Re: [PATCH v3 14/20] mm: swap: decouple virtual swap slot from
 backing store
Message-ID: <202602092300.lZO4Ee4N-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208215839.87595-15-nphamcs@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 941771C000A
X-Stat-Signature: beujyomj6pg4xoxoautsmrnrengimwwn
X-Rspam-User: 
X-HE-Tag: 1770705111-858303
X-HE-Meta: U2FsdGVkX1/ytTJyh5ubuWuxrXD5tor9uHC9wApuNSqNp1sTQj3wBSZxviU/A5RiYwyy/yGZJveEmD86Ihlfczk8TIRBNuA2tlOMkZbv5xiSRuPcRxX/SVHnbSaIriMfZFldEiUSeJoXnmpEBFQh8s88Mjaaggy8ZOo19YsMjTo4iymJuXXDEAbbCixCrTJpDhg5ubzkds/ogaXD0nN4iqQcLkpIJ6BBJskv7NoKpqiE+v3vy1L1seLs3cikEAXncbd7oqZd66ZtGx/nqUOLIiMnJJc11kl4ZfeZ/UpBr/5Y94NYDdclplLlqugOdaU0r/6gm5yj5fcjmfaAOrOvafunC7A/sIKBomG5bcqzndZAjKYYaEaQHNW/0qyz6N+97VRe1Ov/jxBLIDCWjJ63h5RZOk7p2MwM8fHnlZ+W2Bsuchg7gxBIeQEtr6P32ekUNqOOae4bk/15RL/hJ1Ll9AN8yhJSUgZZE30bjPXEWvFb+7JfLzrA9yR7q9CXroFFNBTFUjVIJdiv/5xXNEtbofZiwzmy8fXAOsaXe6HVNufbgHseNbHAGW7rwQ9Uk3h05tRZzTDScFXIO+KDjqBOAg0lWluyqkHyiCnekIkSBGBFMVgZR/D8B7J2QjrsJwxzyxhY0k04sUqvM4hMxfcCfUQOSrdLMmy6WmcU9plclwlYkqJTEiSfIkhrO97XM8QryLEKOcEyZ5oGwNpiiBXCq7SG/vtFe3dpdAQOu2rB4MiVxsicYHvKXVEzzIvhhZ+O5qZADhw5skvpiqBBxmmXMdoP/JhmJiWjmTY7OVJ7SvQ5PurZ1fduW18anx/q6hSiM1qUuQJi5kqqy005iQp6IyY+ZzOafpq+ghvxsYalOydp2N9ksXw2ZnaqZJ94ygQZigUjE3QmSnFIFPPT1q4NLMn8c2k0GdzDeqK880DX9sMbs362wpLZQWoZSuV05FHWf/xedm9rkcOVBgKV6Zv
 lfZowjOv
 oZZ+HrSe0uhw8u+u3/Wkbz1eAiQQRWoIYdaZrgDb104XutVIngh/TVb2K/womTID4fU1SRaymOoaRRocRYYKRER2ahgr5Bc5u5MgeZy6yZXnOLR2T794ZgXUTEqZNuo6zF1cKTDzGj2w0luw84MkwSO8jDzm+9dSowgSP82Mil93bVcmnIokk8CKLH1oAufK3RpZmlXIuPRIDtrRcQMx5tD20r7Yd+FMhqozB+BhXEjKZ9hNo2lGFESK6LqQYfOvLejfVQoD/haKaYKuelQziphjrMIgC2OsGiml2YTffpmbrvQkkLsUfoPJfbBIXQtmgA49Njq7d2sXSaMVVTvucUx/V7m+dzR8NJrmY88EeRWl4SW0hj8/7DM3poU3lJBg4xlinn7NcNbQFl/hQpNRm+zoYoXQatiByLDAFkVkepymHH5P1/YZuyKGGMh2qDgRQFFPRne5zUh7/4t+7DIziz63GK5fVjGMML5rZHn1qiVXw+Z2SUd1RsKw30asKQmZdLXldfKUtqjUspZKK6/dQaIIt4ctksGutscJzbn6ZyxXu+RURtzG5byTttgjWOlVCPkZM42CxhQRztUaqSzqBjSBqVZpTgfKF4jeNchUtRBpoIlAbHew0dzwdve54rqzry2THM3ZmXVcOlk7o0nICJXXJ7SfJ95BXwFCVBOT/ELlRDv25/wcM9UVnVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Nhat-Pham/mm-swap-decouple-swap-cache-from-physical-swap-infrastructure/20260209-120606
base:   05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
patch link:    https://lore.kernel.org/r/20260208215839.87595-15-nphamcs%40gmail.com
patch subject: [PATCH v3 14/20] mm: swap: decouple virtual swap slot from backing store
config: powerpc-randconfig-r073-20260209 (https://download.01.org/0day-ci/archive/20260209/202602092300.lZO4Ee4N-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 15.2.0
smatch version: v0.5.0-8994-gd50c5a4c

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202602092300.lZO4Ee4N-lkp@intel.com/

smatch warnings:
mm/vswap.c:733 vswap_alloc_swap_slot() warn: variable dereferenced before check 'folio' (see line 701)

vim +/folio +733 mm/vswap.c

19a5fe94e9aae4 Nhat Pham 2026-02-08  694  bool vswap_alloc_swap_slot(struct folio *folio)
19a5fe94e9aae4 Nhat Pham 2026-02-08  695  {
19a5fe94e9aae4 Nhat Pham 2026-02-08  696  	int i, nr = folio_nr_pages(folio);
19a5fe94e9aae4 Nhat Pham 2026-02-08  697  	struct vswap_cluster *cluster = NULL;
19a5fe94e9aae4 Nhat Pham 2026-02-08  698  	struct swap_info_struct *si;
19a5fe94e9aae4 Nhat Pham 2026-02-08  699  	struct swap_cluster_info *ci;
19a5fe94e9aae4 Nhat Pham 2026-02-08  700  	swp_slot_t slot = { .val = 0 };
19a5fe94e9aae4 Nhat Pham 2026-02-08 @701  	swp_entry_t entry = folio->swap;

folio dereference here

19a5fe94e9aae4 Nhat Pham 2026-02-08  702  	struct swp_desc *desc;
19a5fe94e9aae4 Nhat Pham 2026-02-08  703  	bool fallback = false;
19a5fe94e9aae4 Nhat Pham 2026-02-08  704  
19a5fe94e9aae4 Nhat Pham 2026-02-08  705  	/*
19a5fe94e9aae4 Nhat Pham 2026-02-08  706  	 * We might have already allocated a backing physical swap slot in past
19a5fe94e9aae4 Nhat Pham 2026-02-08  707  	 * attempts (for instance, when we disable zswap). If the entire range is
19a5fe94e9aae4 Nhat Pham 2026-02-08  708  	 * already swapfile-backed we can skip swapfile case.
19a5fe94e9aae4 Nhat Pham 2026-02-08  709  	 */
19a5fe94e9aae4 Nhat Pham 2026-02-08  710  	if (vswap_swapfile_backed(entry, nr))
19a5fe94e9aae4 Nhat Pham 2026-02-08  711  		return true;
19a5fe94e9aae4 Nhat Pham 2026-02-08  712  
19a5fe94e9aae4 Nhat Pham 2026-02-08  713  	if (swap_slot_alloc(&slot, folio_order(folio)))

and here

19a5fe94e9aae4 Nhat Pham 2026-02-08  714  		return false;
19a5fe94e9aae4 Nhat Pham 2026-02-08  715  
19a5fe94e9aae4 Nhat Pham 2026-02-08  716  	if (!slot.val)
19a5fe94e9aae4 Nhat Pham 2026-02-08  717  		return false;
19a5fe94e9aae4 Nhat Pham 2026-02-08  718  
7f88e3ea20f231 Nhat Pham 2026-02-08  719  	/* establish the vrtual <-> physical swap slots linkages. */
7f88e3ea20f231 Nhat Pham 2026-02-08  720  	si = __swap_slot_to_info(slot);
7f88e3ea20f231 Nhat Pham 2026-02-08  721  	ci = swap_cluster_lock(si, swp_slot_offset(slot));
7f88e3ea20f231 Nhat Pham 2026-02-08  722  	vswap_rmap_set(ci, slot, entry.val, nr);
7f88e3ea20f231 Nhat Pham 2026-02-08  723  	swap_cluster_unlock(ci);
7f88e3ea20f231 Nhat Pham 2026-02-08  724  
7f88e3ea20f231 Nhat Pham 2026-02-08  725  	rcu_read_lock();
7f88e3ea20f231 Nhat Pham 2026-02-08  726  	for (i = 0; i < nr; i++) {
7f88e3ea20f231 Nhat Pham 2026-02-08  727  		desc = vswap_iter(&cluster, entry.val + i);
7f88e3ea20f231 Nhat Pham 2026-02-08  728  		VM_WARN_ON(!desc);
7f88e3ea20f231 Nhat Pham 2026-02-08  729  
19a5fe94e9aae4 Nhat Pham 2026-02-08  730  		if (desc->type == VSWAP_FOLIO) {
19a5fe94e9aae4 Nhat Pham 2026-02-08  731  			/* case 1: fallback from zswap store failure */
19a5fe94e9aae4 Nhat Pham 2026-02-08  732  			fallback = true;
19a5fe94e9aae4 Nhat Pham 2026-02-08 @733  			if (!folio)

So it can't be NULL here.

19a5fe94e9aae4 Nhat Pham 2026-02-08  734  				folio = desc->swap_cache;

So we'll never do this assignment and it will never become NULL.

19a5fe94e9aae4 Nhat Pham 2026-02-08  735  			else
19a5fe94e9aae4 Nhat Pham 2026-02-08  736  				VM_WARN_ON(folio != desc->swap_cache);
19a5fe94e9aae4 Nhat Pham 2026-02-08  737  		} else {
19a5fe94e9aae4 Nhat Pham 2026-02-08  738  			/*
19a5fe94e9aae4 Nhat Pham 2026-02-08  739  			 * Case 2: zswap writeback.
19a5fe94e9aae4 Nhat Pham 2026-02-08  740  			 *
19a5fe94e9aae4 Nhat Pham 2026-02-08  741  			 * No need to free zswap entry here - it will be freed once zswap
19a5fe94e9aae4 Nhat Pham 2026-02-08  742  			 * writeback suceeds.
19a5fe94e9aae4 Nhat Pham 2026-02-08  743  			 */
19a5fe94e9aae4 Nhat Pham 2026-02-08  744  			VM_WARN_ON(desc->type != VSWAP_ZSWAP);
19a5fe94e9aae4 Nhat Pham 2026-02-08  745  			VM_WARN_ON(fallback);
19a5fe94e9aae4 Nhat Pham 2026-02-08  746  		}
19a5fe94e9aae4 Nhat Pham 2026-02-08  747  		desc->type = VSWAP_SWAPFILE;
7f88e3ea20f231 Nhat Pham 2026-02-08  748  		desc->slot.val = slot.val + i;
7f88e3ea20f231 Nhat Pham 2026-02-08  749  	}
7f88e3ea20f231 Nhat Pham 2026-02-08  750  	spin_unlock(&cluster->lock);
7f88e3ea20f231 Nhat Pham 2026-02-08  751  	rcu_read_unlock();
19a5fe94e9aae4 Nhat Pham 2026-02-08  752  	return true;
7f88e3ea20f231 Nhat Pham 2026-02-08  753  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


