Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A9EE73163
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0BF6B00B2; Mon,  2 Feb 2026 08:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9016B00B3; Mon,  2 Feb 2026 08:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A6A6B00B4; Mon,  2 Feb 2026 08:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 580446B00B2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:15:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1719A1BD6A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:15:26 +0000 (UTC)
X-FDA: 84399563052.17.6D3A15C
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C8A7100006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:15:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bfDs+aPo;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770038124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQ9VPANLPV2MRMw4JagXV3bIpuMJZSsxWz7UV26Ck/w=;
	b=vQhqZOrSwyOLxuSW7OYlkSdMx5owuiN189P6Emp4qGSyjok+QzuJyhC0UWcqBqvn5HmxLW
	svaGKVoxKPPfYQrUTL5SHN4XiS2QLyXkK4T2PmMnN3MY4ZKcaXnu3Lv+GK/FWbLQ95xbYW
	69AX33tDAHQv/Fn5KHePG8uSa7owvOM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bfDs+aPo;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770038124; a=rsa-sha256;
	cv=none;
	b=b/r17C/lGb+tZMYeEZcMEbabUJBUp+e5qFPwAxp2ZbEPIAEkBX9cH6W4WV3WZP57yFupRt
	lG0Pd8xwU7RYrXZdP3xAz50JE2l17xjBssMCa2mP+/shmAOI5bgRkKX2Y0l8PMr56UKAPi
	TNxZDKMk5W6hsANNTwwsW5kUWVNZHuE=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-435a11957f6so3506012f8f.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 05:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770038122; x=1770642922; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sQ9VPANLPV2MRMw4JagXV3bIpuMJZSsxWz7UV26Ck/w=;
        b=bfDs+aPo+xUzST1+uz5NRcTDy9tOT4Ma7EFOsRSjCqrOabfTfzn52yrBhpkLC7/B0y
         NrkO9GXOMo8qJy819cGGBD4rJIIo+oMuW9cQrTsgMJJVUW8o4B9nYvsy6BTcbI/TtkYP
         kDD6BuR8NE0fm6SzUlrCyiTpdB1LKm87C3ujjjhP7yjeJwtg3iiUcCy8tp6PZbXBS3LH
         BPHS0x01F3NeASR977R/FgGuXx37ubc0djxE2Ip7xpGwfIS+/xKP93wwbZvGEAzQy1R8
         QVQv6NypIkLDsyPfqWmSfUZ2XBAy4PzYXorWdfwNK/+658Gxsa68fLXtNwuKFN0ORlBn
         8oZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770038122; x=1770642922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQ9VPANLPV2MRMw4JagXV3bIpuMJZSsxWz7UV26Ck/w=;
        b=sv3hZLSDxVDFchEVHlTA6t2qetM4Qqc/fDf8FJtAO9CgQ1glpAUAY4ON7KBDsKlE/r
         xk5ZUbBpZjiWaLGSn1AN8bfUriWIB9Fj+w75m1bmOMyTorlCHSLiCLeBQdaA56qnSUZk
         E734/G48eo3LjE0OI4MtjDYH8ED8Y8FwP5P0SoT/NRFrZjVHyiafKkYy5sqFOrwg/2H+
         rfDl/w9wdvbLxQiHlzq9SmLk0zRJkFhcKjLSnARQuDeVbOThtS2Xg0zM0f6nmVp3xwnm
         M4lXgnuJ0xl6G/O0t3eOsQgwGtevcKnwTxBmRUeHrsTgiPgUAwIGWuCVEcyvh5FN9qce
         js2w==
X-Forwarded-Encrypted: i=1; AJvYcCULRUQa+tnXPmVFACHAeoIPYdr1bgbJieClMUUUnd+R8ZtPcZCooYQlz1/SuPFzOlHuVZbtnqUnPA==@kvack.org
X-Gm-Message-State: AOJu0YwGtO8y04iBvcO7pXhQP2YWz109e7Q10Yz1urWJjSws0ty4Ctoe
	QcVnFnxkBTK9/7o3IiXXenfiYL2INzJ8pGbEUlXAOLEytHMl/hOXPQNCBwRUZgf+a6s=
X-Gm-Gg: AZuq6aLrBN+JbD1n92Q4P/HT6n4Pr4+2AkkboDXazoSK/s/NHkxiJ5MOOgt6VMjB8Ct
	KZQD9knKzTOqW4Aa2tnWYaoUp3OGEcXh4KkfpXOhjjdzCJgfPYATtpyG1/80eOJhpKm8VoofcKC
	9VOeDS7cUemUFsq67gLtl3+Z3NKT9nfN5WrOYfLadLsnxaYtTdlwaDPxIN8Gu7JuupcyRAmILSc
	0IkWMU9R1+Dc5AOd4ZkKU+omD6w84FxFaSLjab3JVxDET+nXw+Wum6kNEna1TzvhD8vv8Y9Odji
	FUhGr6wZxh+cYHhiiwOXSa2/bcN+EksC/TTAkzXe7jxajy/UNoKr82QtjFoNeNz8HmC398UxsMH
	8RrwwaN6XxLwNlM+BVCOgy8yhYr7BVZc9zCJ7sv3biDqM/kwIEfCPZY51UphXOJ2rYTFa5NOK1z
	0TX1FCAywiuUYOeLA46PrvX6Uc
X-Received: by 2002:a05:6000:40c9:b0:431:35a:4a8f with SMTP id ffacd0b85a97d-435f3aaf7d9mr16391654f8f.47.1770038122563;
        Mon, 02 Feb 2026 05:15:22 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e1323770sm45183583f8f.32.2026.02.02.05.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 05:15:22 -0800 (PST)
Date: Mon, 2 Feb 2026 14:15:21 +0100
From: Michal Hocko <mhocko@suse.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aYCjaVJZLijzk9oe@tiehlicka>
References: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
 <20260127220003.3993576-1-joshua.hahnjy@gmail.com>
 <CAC5umyhqbW_qXaApO8OGg1wo706GfVPuak5JwdBfBgS751Ka5Q@mail.gmail.com>
 <aYCiboGiXO2lQC0W@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYCiboGiXO2lQC0W@tiehlicka>
X-Stat-Signature: wfgw7957ct8bbi9uuf53mkpjpnjfcbg6
X-Rspamd-Queue-Id: 2C8A7100006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770038123-799648
X-HE-Meta: U2FsdGVkX18KMIwKnuXl4HGZMAe/vBPBE4R5f20nixND3LuFBhYeUtIfImiGpQpeN22IjncvJ1a0qR7RQihk7cHMTz9Z8I1V3CMn6HU4B/AQMeDbTm9nSnXol3jMn2QezUOns+YoPAZ/ubeGStNKA3lxIgiTO5p3pjkVJXVWjq8wHWEHXL7C+CsHirU96MOZ32eUUNWRZAQ2iBfQhEpVbfbwjZ+wyH4mMldxuRS7luem5B5uqq8WQeCh8FQOSuO5lN2Wc/9KwI63MGneJxawElH57mDhXqZbmgSfyrgsNT3Bu1mOpGj8fc0kKth1zj/wPG6hDf4GfMqn3bsFg90CKxkOoCC6+mvZTx1/9f7LAXMioUb2+8YgorClMikC9HXTOTOafXGC+whAGUUIWIxr8Gly6+uREyv/GpMZkCUr2H5Xg2yfIWNovvDSDqWFS+RQHw1lMDqscESiKrMit9wAocZgs2Kyd+39sRKm2DL8urL8eXfte7/eog4moIf61N6N1w39GKZzpY4AMnDdJR4wlK1zoeL6RIffLCLk2nigQMpD7YNhgOBpFXIvYfcDaqiZ0Z1+QsL83+B6x14ywWuGsQ8vfDcpKbJpB13lBu1jp5uyQBSobSC6dgsIwDTeL6grT5S45oyYbk55kfVWefPpLTNt2PxDMZBuqcCCsKsJ3NKbA0Zb/u8JX2g3e7Nwf2WzfKulSiN2489h+aVO/ANKgXV4y17DFrsXWAZmnglr5TNPgAyYusjucATvbgzvquGrwkvViWcMtVEMK40jur8tEAG8VyYfxzf9dNWzJOBkLk26AmUxkNE5XXZY1ZCv6HcOHdkTnc2UzMJNQmcB7bXaGaN6CjKB81sJ6ZuKUPryLvgEuaYj1YTGvr/YJ8ymB2LCP/nBsZ9OV2LHm0Ce4ifr4C9mmprOI/TfOQCmwSU3J6OFdXr7WdtZv2Vwp5L199R50V8GEN+nIK5c+ZS9GME
 2P7uH8i4
 /9kxpeC9CGBByG9ymVACFUKZsvJKqW7Xd2Vh2O1opKYSKQGmnUD/qRpuV1sP6gJAUZvSCXiXS/0dYH75NWMsvNxTL8w0LNFCy+/GDGyEndM5AHmoZPHOJtxg8zbRhjDb0W7da+ADpoIM4JlR+SJgL8tzVY/GqoI1hG4DLXS5/eTiexvtDT8M7ALrsqhah1/N3h2vqa+tScQwG1lkGE+mJPRMyeacnpPx3SdOlK38WmIWI6Po3s3Nj8610jN812AZ6yjXXCIRInbBHbY0iamRwtlMokuDSMGdZKhfKMsH2c7HT0jOMU1MYkvbYKSb6l7e4Am2BHbFVmWUcDe/yNlyrsKBZI164/1MRhFOgEr/XK7zHLKs3fg8gGZ/0qht849JVtjLnxl0IJaYUGLLc5cVXQ4g9z2JKCpgPDreebnkhd7o93Wwcq+5zMffpniMRC3/U7tTTLSn+n+ChAMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Btw. collecting /proc/vmstat during this test could give you a better
insight into what is going on. Especially reclaim stats (pgscan*,
pgsteal*, pgdemote*, workingset*).
-- 
Michal Hocko
SUSE Labs

