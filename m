Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C025B60A2600
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=CEh1iLsc
Received: by kanga.kvack.org (Postfix)
	id E500B6B05B2; Thu, 19 Nov 2026 01:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27D36B05B4; Thu, 19 Nov 2026 01:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D178B6B05B5; Thu, 19 Nov 2026 01:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC59D6B05B2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:53:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 471E8160976
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:53:58 +0000 (UTC)
X-FDA: 85450953756.19.FF6B7AC
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40A9DA0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:53:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CEh1iLsc;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071236;
	b=U2OQncpi40bMEGJsLbCkff8DLoX3GfsOASlbhry4JQ+TBU/yzKkX39hKpd+VBtSZS8MLxl
	6iQjWGo55W9HUBpvOXD5hmJMeMJcdnq83UUZ978E8CPaCi3Mt0Y1SKLDznM0mTz92idLOJ
	EwSulxDZPkGk6ZUf+S11D+e1J+ipqkU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNJE6UZ1rBDrjDiT/mTO/LT/Bdfa8O3VHkLcxkHxptk=;
	b=09iNMiF4XGvtdLj26go2mSEg7DKwEOJ6kSVHtix/fCMdQtKqMXqI5mxrOPqUKgA+umE/KQ
	VfiBQbfBzO/cR9LIhvxqF7UD2hZ6XDvpLDHgNg3FtPc9SK0Rht7KAkX043N5HNDt5Rztig
	76fbJMJUGVf6Pgpx2yW9ZFX+meILRN8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CEh1iLsc;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5ece3ab2e91so663251e0c.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795071235; x=1795676035; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GNJE6UZ1rBDrjDiT/mTO/LT/Bdfa8O3VHkLcxkHxptk=;
        b=CEh1iLscn9yupb43z1ry2IqQv/j6bdiNVgnleKyBzfdP+IaUR5qqPBnpYAdlIuQdaG
         SA4vma/EsSdrmxNmyzkIFs8YuaimU4pU2O+rS0m98vwMPHdD/lurjDnhZJYm/T5w8qHd
         4CX+7uLeexE2KtpU4W43Tw4DdoJYvk2JspgzKjRrlB4E31Bzv2nfl0yHohCL90bbdEg5
         D5D6PB+4qhpwEV43vT0Av5QAYQ8oTdzM+Y5c6lqnvhw5Nj81BmjMMZ+9UIG4S5Mh0Iq8
         Vb3dGE86EEYvvm0+pcCdSWbmJRt8WttIa/esDq3OnRuWa5aKE3SS1rYHEc1DaRyLq493
         9G/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071235; x=1795676035;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GNJE6UZ1rBDrjDiT/mTO/LT/Bdfa8O3VHkLcxkHxptk=;
        b=USNchDsF2RR8Enu01BCXbsjNafGZeEkKjchmEYv28tbgTgu00UMjgAZ5UjlkT6umMi
         bxmPSY21Ok6n01xurW1uxlGOECu+ofjzi4LZCrA/NS7d8gqNOFB9MEkGnwQELynHEyi+
         5rweuCwceYoJ3fFxcloCxiEtrMCRYHQ4V8oU5uyc9n+/ztWeLK2v0xcT8O+pE1kqivQe
         4ctXakVZhaKfXV3BAHMhW9uGmIHIMnCcYcCUVCXhZF1e7Per91sT7JBZE+DTE0jUfFVM
         D5BUKC4C3/SXnhPv3CrRI4IkqEhxyQTFmg8us1+ALhoREqahzHcOejcwAJMtd51XmXRt
         7Vzg==
X-Forwarded-Encrypted: i=1; AL+hErGbVPbLjzvRFo6hY6B3qw5fwU60PAEV/BRRP7Hk+wqQzgXaY+gpj7n89UVSEQMsWV7Xznz6XwIVjA==@kvack.org
X-Gm-Message-State: APuU4Z/eKqBVxPQnAn3We4hmmAaVqjx3ihJc4Lkq91aoW2reHlFGVxo3
	uT4N4JGRax42D40Qu3OuxLFANQk5CchZCJgLhMJ78yvZ2Sdww2nfOw9YQUpbqYL0o2yS3s27zK0
	TyxN4
X-Gm-Gg: AYBFou1oNsP2YK7tLyKlsJPb64UyeB0FhYursfd2IrKBNwmRp537TIGW33H1ycjBquS
	Vux9pX3eR1klsEOCvpuEC/hmqPZ1jjEriXrARETWhOCFNNAP1qmC6Dy7G+fTi5HrFiCflTKt9UB
	VmOKlOpDJU6U/4zt8VCi+G+zd4ZVGhPTRbJ3CLGVecGFLycnnKxHtyxPgqw6fzkzvn+PZwQkqxW
	yMBs9Cx9YBrnfVKLiByaEpT9krWbf3dsn/yrgVRNE61gXMFjQ523qbED3r5FuJ9Gph9bdZX3fYU
	AJMyQGnSCqhd9GDrfip0dM3Lu9bSP2HzXt0ozwJurFxJl6yeSWvFgCErS1Xy2Lb9/HQuyJO7Lub
	+I0kMYBLvoetYMeZJ6TbkbB6YIg3Gozaqs1QFwJYPVa467kewzZYQLOI66+51tIOXngZlm003vb
	wPJUMG353jtJzsk8700LFH5vQsI2w1r4GVWhOyoURsg0zTAfzCM0+I4rf+i2dk9/MguX79I9oTm
	VUjHqpWZDZMZbsUNYD2N99lNbWX2qOddAqbuPcZef/hwlowq20g46g+XwH8xeLqttNgYx0Uus3j
	2k3SEsdK77f7B8aHg2QYEM4uKsK4EXUToGQ104KHGuOUOke1UswkSET29Ufyc2u2OR9uRLMUeqe
	pKEtGx7yq5fHBKOPyg7nR53utjyw5K0BO1RLJonzMobahyIw=
X-Received: by 2002:a05:6122:62a6:b0:5ec:c162:d58c with SMTP id 71dfb90a1353d-5ee646c8d94mr2473939e0c.9.1795071235328;
        Wed, 18 Nov 2026 22:53:55 -0800 (PST)
Received: from soleen.c.googlers.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee64ed7adesm3423790e0c.15.2026.11.18.22.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 22:53:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/2] kho: drop the incoming sub-blob debugfs view
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Long Wei <longwei27@huawei.com>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 akpm@linux-foundation.org, graf@amazon.com, leitao@debian.org, 
 corbet@lwn.net, rdunlap@infradead.org, linux-mm@kvack.org, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, hewenliang4@huawei.com
In-Reply-To: <20261119063800.698863-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261119063800.698863-1-longwei27@huawei.com>
Date: Thu, 19 Nov 2026 01:53:51 -0500
Message-Id: <179507123198.250261.1844561072152549258.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=693;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=yPAAYOBOOObp5DgeME+PxCgH3xqwEnbp1bk4PDjGg1w=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq/p0CnroMuBFG1w6cbj8X59tE5O5lJneO9MDj4
 lpdbHwN/SmJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCav6dAgAKCRC7dyhM23N6
 3ueZD/9IfpTbNdfM3QFnBSJ+zx3bm2JxD9dV5H5hWe+Gjsh41ZGlB0WnSHEX20Rmk1d5abeMW84
 YuOO5K7r5GSkJRKMvTTacqC2gsAKNdfqmQNE9Ga0TsIUx6HiAtnkCtLw9uR02oz172xoJc4mvO9
 +ZqbgXBHRsVLRs+xIhbKLtgRupLeYNRefvdLlgfYjdO/EvqrXKsRlsp/0kW3yaffoQAvKCsNdmW
 16aMO3CiHE6yaQAN1D3oUdn/8llK8liHPsRBBs0apFi9EfuYvH8w9AdgiNOldeInZFxG3pQ5lt2
 J68ik5kvSGmYv3otuVVHATIhtPCzpFkefbI6TnzDmHQjsOyfAdoBeT+rr7RokoIs40ggiuZWDxA
 zLnpfdyvxylfTyeKBueMX8Ld3bqo8AIIqtoVhuzYNZty9jqG8zbl7FhUCJoAvQXKPlhHUFnwY6G
 HCYj3jsg8dYK/WsOI2Gu4v5CPjLTrlGW5oUPQtaQSzsnt/zLFKTt7EFH9XVT3Zb1ABU4Tdox8Y+
 suCeKE//fMBGowWddh1UZUiThSoAVyasPp/hW3v3sYoZlglqjIdYx9ky+DoCaGj19wrMNL2nFIF
 mY1HnMljaNI4FLF36QYmGhdJvoHC/SNewPtz4kM6nVlGQZym6+GFPOWHPmDV+ClJcKQUMi5Q2kD
 hQHgp+HNhpEYXww==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: z649mx8box6yjxhtfkbuuitiowzzetwp
X-Rspamd-Queue-Id: 40A9DA0004
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795071236-233620
X-HE-Meta: U2FsdGVkX18PQKEiOEvoL/H7d5vDXdntsqiYC/qfpiAT4Ph17owK3btcR/38977ZBIrbiDUY9I2jadqw5O7eLu/0fNdJ909dq8XMcezF1Mw/m459G4MMcPdyK5Tx3XY0Fl1OZHL/q9dhktah8KvaFlkTXUkAHSuAOSsLF03aTf2EMWl2caAhVJJ/Wt0O7o+5BSk/7GggudpQGMpGMUai38F/mKh9/7C3THbE1rvs+BD7KYMLOdbCbk8Mqs5VOEbYyVeRJ83PpkySW9bPbZuM+vpbQ3j9WPeIDDzPTEvBthdVvpCGsP/q6rmqKiQsn0CuSCYRkutpV0rRVeQvxVQlqY7z6zJraln4Eo9OQoDbUW5dcJWTEXUd9xR+LwZlVMvTmqvxtSUs/XlW6xnjiGDvob/DtkYwQm+9PZE6TMEZbeza7Jhz/c71UzAdjWdC1KBijduKYEI9KNuNjev5PL+CCraeGwNL8qphOLSL7TJHyisNTJn0We+CLsviYXRlEm3fXCe1CMClrEo0Od9wRi4dKikVFvcQ+rduLDI4cG9Hf46AAcS9n/HN84XkFgOR8duys3XHry295j15F/L4Jd11o8KbIUhU3++oPCttRofMG0Y8kzCmGpNZFJE+GJXnrtCsiYPjtqGk6Wi9/ceFrC8CUaHaKSFeZkU1nM9Xe2eH29ajZdBNQIvuu5BOZ7m/MEWmaPmURw9gVQvSsAqMoHvxd0ceT5yxJ2bLw+ZTZG6Abw0Je1/NAnoWKClGAqWgjk1+tnabtzSEu7oYkaiPiT1BC0ca8OGIqEJZ4GeCHmDIpEdCVO0TYy5W9NW7ZzcSSpLcSeN7sqyEP2MTSt4YzomKAsGYlqtu6SjZwiDkqGPzbNi7+qxBdPhZu6gBt8gwl87QXSpWkTe7TLbGzNZ8rsbx7cuAHK3Re7kDzuzp90fFF8MXWv+wym7P+K0PF9IvgwNTHatoAlQjmujTchHKcD2
 M0A/7dZ/
 b68wsXjXckl7jUK2U3glaUzTaWfya5QPmGjL2kz5/VaLOqBCMQO7//VToTsAa7BazxXwgPUS19e9TltI85/WaGSqQ/fu4dF1XW1DtNuVu0j6YSm4ksbrhgQcm5/5zxeQo0RiFJ5n8zc2yKPa1Qj0n5isp0leknMam4Ttv8zpActbrg8xxNyQFFE78ZPR7d+jx5/olJ3iB0kbf522l/ArweOhT+qq1cauAAn5dPSjyTL/Y2gZUXktUkiAZA/vjRDVuKDhUn/jAbiubTaqYxvZsNq31vvQ5h5edqds/YGWbdBJPEyXhPobHC2rYpw3PBtMTMRDTZNJePxkp06jFaN7ijx9e86zYwhgyNQdfEDvyxq8gqjDxr8AKW/A4hOvQL1yWU4MnLdBhQGdFFF7+VwVlR3junUULNMJzylNgZJtKHPRAbSKMNsDLszYhnS3wCXKH2wfxxegcMTutiKY4YZcFiNY0zbgzUoDIjoMZt748kZ9o/8bYKJNvvgJ6R+RQwYmnablY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 14:37:58 +0800, Long Wei <longwei27@huawei.com> wrote:
> kho: drop the incoming sub-blob debugfs view
> 
> kho/in/sub_fdts exposes the raw contents of the sub-blobs described by
> the incoming KHO FDT.  KHO does not own those pages: they belong to the
> producers' consumers and have independent lifetimes.  LUO, for example,
> restores and frees its state in early_initcall, before kho_init()
> (fs_initcall) creates the debugfs view, so the blobs point at pages that
> are already back in the buddy allocator.  Reading them triggers a KASAN
> use-after-free in _copy_to_user().
> 
> [...]

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


