Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533B9CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5EE8E0006; Thu, 25 Sep 2025 11:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DF58E0003; Thu, 25 Sep 2025 11:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993A28E0006; Thu, 25 Sep 2025 11:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87C368E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:09:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5318316036F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:09:05 +0000 (UTC)
X-FDA: 83928105450.23.E2B7822
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6BE11C0016
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:09:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Ebxh3Az/";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758812943; a=rsa-sha256;
	cv=none;
	b=8Y8avI/PWmGNywgJdFZovdgF9dsI0rQwbWzUqXCOoT58bWrq/XgAeGFQxkuU6/w87ciRfw
	YxC+CQTm8qMma3n0mNAJ1xmjqMltvH86/9VUcED7sczcAtqi8K2oziw6GQYye5ZhsSTmj8
	mJgJfYKKcmLXumP+eicNetnRKBhf9eM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Ebxh3Az/";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758812943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYDLI5mwI4uh21VH+pwIKDtJ5bbVvmfXzJZa+QgeupM=;
	b=Kx9fO7mYBBU/ojRrEwRklfw1QHJgeHGZ+K5MTB9Mjz+Kg+YkfYMI2U0LifVmTBR9AYtscH
	3Kjbiq7cyHz+ERG+QZLrFC6L0BKIbKY+e6ZkAJ+0v2LiyAxmwvrcJCacUrz5BtF1XYHTt+
	EnFTZ+57FfX7++kZ6auRiKHc8GgMBMI=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4248b3204d4so4071755ab.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1758812942; x=1759417742; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mYDLI5mwI4uh21VH+pwIKDtJ5bbVvmfXzJZa+QgeupM=;
        b=Ebxh3Az/EjONK4EKZcPEyWv2SeQyAYG04gPiPytwaMfod1whbP42VpM/Hp8baFQjb5
         BTkmC8F14cixfyARdCXo1Igi7rMUEKE/SlxDIgSC+wd+FYVtbo9ttWDEde+yjyEjIiPQ
         hPM1aQV2vgcP1AZMD6E3BBu+moQemivpxIzh0uLGDOxtVVWTgX+wFVARXbxdqTY65NU2
         4qKryj80+CywAJq0DrsLwllrZ2Mw1IkifZXcAGMcRIu+aVKLp1C+ejchT53aVsCaafBv
         JU2zWU3WEuPjGuYLa6s2yVFNMf8cTPZ2yWlh/v/0YY/xNppFRpKIH/NnM5lBjHt/F/u8
         IMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758812942; x=1759417742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYDLI5mwI4uh21VH+pwIKDtJ5bbVvmfXzJZa+QgeupM=;
        b=O9qLxC4x1PWYk5CVCEpSMOCCegpuPuJC6Gipygyi++vlkNY74uWbzAjXN/hvIezdr9
         a1Rq/1+rswhgMXf7loSRmVqhBxC24ZHq/qApIl27+ZUnqMChGxYKrjyg+Uz7BbOHBsr2
         cks2pa0D7nLtxhsb2q243Dx+6MpMX6G+ePG0iL+eyEgAU2PnAgdd0HYB1McF6ciOYbEv
         0CFu61tMuXJugCiMpg3oei4rdL1eq63AOb6HYUr/dn6IeW9QjaeNSB9LaqiDdr1fdW22
         ASv4WvPVOrLArXXoV/js4BkHxbOiNJPDhjTQ343bZtsnyHUNu8CpWXy5r2YM7/yvaGS6
         uo5g==
X-Forwarded-Encrypted: i=1; AJvYcCWkaKXE4D9ARpbgOSrxF+VCSvtxj9NNcF/KgGmPhsaY9FC3YrYGa4ux3ciP4o5O484dh+btjcFJBQ==@kvack.org
X-Gm-Message-State: AOJu0YzCnVynAbAl9g4EjAhtPJ7hZmxY4znM0q0wezpFqnQ5vc4hWGKk
	JeoUKBFxwXliBC/qBkk3Uezbbraqh7WI6A2RNPihNrPCt+3wQ1f7ijuNOMCmYKlkP4Q=
X-Gm-Gg: ASbGncu/Z7pc70kC99PcScZHPCIDMwmktbJJTmdNuWcDTn6sOjLIAUgX7P9JdbYAMtR
	YTA4beiyaGp5Pzn6V2BWczooGcF2xS2xJL+QLYGwsR9zfgZO5rvfatvcBc2u0cjIY3XMQvoAgE3
	UyFhz8P40fF597SKomr1/+UmLVNUfGNZZOlodBiR3FA9mbhk+MMJgpkwPLRyjAqeg/kQfP8XTpU
	guXi/vj59Rxb2W3svAYWNxqrSyCE2bJ+dJlix4FrNDWlTfr5df3Udo0C9/GR2X5jLDL9WrEYJPt
	jgV9WdcCL5Kcx0DzhRrzj+P7yhcyc49Hg8Wg/+kKdp6nxQo7gkPMAroOIDh5VCmP8+DjW6Nw2yv
	RF5/c/fnQHvgdGezDCKfgAdYlCh9Rek53l7Qks1BA42aQuNEKM/RDNcDuWP/subUg9X3OYoFdj/
	0=
X-Google-Smtp-Source: AGHT+IFJCD646Ie93Dsteh+N9Tg3N9mTKfy3p3JlRRzccID89obtfshwZ2kYW8ICweprqMFS2clcTA==
X-Received: by 2002:a92:cd8c:0:b0:425:720f:deec with SMTP id e9e14a558f8ab-4259566e447mr49602485ab.31.1758812942274;
        Thu, 25 Sep 2025 08:09:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (50-32-2-77.vng01.dlls.pa.frontiernet.net. [50.32.2.77])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6546198fsm878831173.21.2025.09.25.08.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 08:09:01 -0700 (PDT)
Date: Thu, 25 Sep 2025 11:08:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925160058.00002645@huawei.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6BE11C0016
X-Stat-Signature: eha3go6fgzpx6rech9xfn457sptoiixh
X-Rspam-User: 
X-HE-Tag: 1758812943-616709
X-HE-Meta: U2FsdGVkX1/e16ffOsLwVdG1Rg9x1bvP85H0xZmTHrZtxlRlHbfIjDkxcbLan+Zks1E3alVsiQTU/yu1RBoMp1c/RA1OJ9NVy6Y4UD8Ss5ERofJT+TLOj9yaiTKdfMPmPUr5SJ5veWZYoskBoDXKdMvgsZummBoNo1nTSVgqaQNzMG1tlEh7VONKNkXxCdyVmxrHO+wJL2WCF9u3gtzopygUsdX4K6aLuSe7AUWO60PsG5edmIlLVYwc/GJqU5HkCqyE2eGudV1syvXDNGX8dOnELsav5yh0E+fmW/9HhXvlmI4qcBE19kczat0N0egzMRAFCdDtS/YEtcdfA37dxhiWGnm1UTa8UCiXsxN3eMJNINddkIlPA3WtQEsplGRT29k6mqvau17z9rLq+xkpojHodM+o7SCdiHl9O6gQDJtMKh0ajDeJBC8waCw2hGDSgarKQP8pg+//wlDrwgrZvM6ptrJnzlXP3P7ogvWfc3N72eHDipEGWAh7VHkloxtESDmETSKXq7efWg/KAnsHhpQFzFZX7mcNB4XeNGtJZLnkF6QeaVg7T6BIIA+t+TdF1Esq5T6okNIprMPc25JYZ7xeZs+XmhM0awNhb9XXmM4a1sExaGjMNZBIwejQ/ZUkRB3YwH6rSSvN+OeKp4Ym3PEQ8apb0sIysF/VFoKD3RSAOOxd2+1dGX+WFWVdrN5w4c036xyog/x1GdJHyi3PWsxi2aXcJeBFRUWg4gTtk0zE/Ly/v33wlrKcw6f25A48D58SZWH3hNv1+vMt2xWu8Ea8/JLpPCEyHHiJLi1cEzrxfRYvnOaP2rJfncUJbtqooOa79HgZuWyVmVwczlR4gGy7OqBY8G9EPd3FburbICFgAMnDdaATWjne3h+1b0H4g90gdN06T98qVdrtK5Xyryiy0SsIxae+ztlCfMo3Sd33TOzk05bDhGAghjD1dIIzmiBkxdlP9nMbxUdQmhD
 WBtubDh4
 HKPMsFCmEFOEETpcbwcSeV04WElhl758Gz+tmVke7A9ANN1z1nJOl6WYVwnewSTodcKP5CCeGjezpb2h/QHsRIvOt1Vsm+CzskqRrB+qFEQgvP0Tvcv2LrQjU5l0L+2V05yZjKpQ7CujIa1IYwrKqarkNNvu6ajTWSm0Huhklrl16mz0XfoiReAKo/hgiAkyD/QiMeGb/rVRfOc2JLvgtV1mXPb7zG7YVUgP0aJW0DqG47DRQbivAavs391oGA7DGY8J2vIqz7mNc+1sE5G9GO5hrkjVt2yTtD5wtKt7+i5PNZ4rBXUW6cXtAhfXakHmH0zcEnNbaySMQk05BXoXoHFUYohqrlS6Eokuah4Wrl079Gsryhhfj0Ti4mJbb3bCaWXZZl9L9BsANH6BgXzmNusEcDzOED/GPA/diInbECtakREs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 04:00:58PM +0100, Jonathan Cameron wrote:
> Now, if we can put this into a special pool where it is acceptable to drop the writes
> and return poison (so the application crashes) then that may be fine.
> 
> Or block writes.   Running compressed memory as read only CoW is one way to
> avoid this problem.
>

This is an interesting thought.  If you drop a write and return poison,
can you instead handle the poison message as a fault and promote on
fault?  Then you might just be able to turn this whole thing into a
zswap backend that promotes on write.

Then you don't particular care about stronger isolation controls
(except maybe keeping kernel memory out of those regions).

~Gregory

