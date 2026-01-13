Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6741DD2D111
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3FF6B008C; Tue, 13 Jan 2026 09:25:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81EB6B0092; Tue, 13 Jan 2026 09:25:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64A76B0093; Tue, 13 Jan 2026 09:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7C926B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:25:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6060AB6414
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:25:20 +0000 (UTC)
X-FDA: 84327163200.22.4101308
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8803A40003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:25:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r291AVlf;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768314318; a=rsa-sha256;
	cv=none;
	b=ahfF7JjzuX0maqiCX/MepmJJplk90HMrxRSBQo0xfXOFnVw5X5z0zeTUCfy+9x4OGo/I90
	v5oIE4Nb0p9/0TU9Fdnj5JSgeeX8M8zvFXyMlIcZMxnpx/rVnjxjJXNen1W6QH9RruQlWF
	aqfd4UL+dDAVZz1HxLUgmsnrN/cOwYQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r291AVlf;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768314318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfoDKHA0t7YmEjvnkErYqJJlkysuyVrbP/3VHy3KXGI=;
	b=QGsgDXSge2rr6xqoTUnocNpVerlzaMzT3OgpEUdH990vUFLEt4Zjt/CkVt0s4xi6AF5v29
	KYy5WmJAabrjwypUeEZHy5mDD03RzcXwyMn/uaDpE/pZmi/ggYQbkgQ98mNLMbuxC/qege
	NabehA0FNdD4/EJK0/TUOCFQySO777M=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4f1b212ba25so69958821cf.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768314318; x=1768919118; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nfoDKHA0t7YmEjvnkErYqJJlkysuyVrbP/3VHy3KXGI=;
        b=r291AVlfSzC2lR6kB5YfK/vs42G2b0zQOFuiL05yEILK/h5ziGwucttGv1MQ9vxKCL
         Q840B6aioUJT6xHNMFQFkXmp9lYVavLkKGRYzDCzG8evJcBI8jKkHLdCcmghGxAIMoh/
         3jRWtyGyxjESMAxDABJ4b5X35L1XiZD5fcFT9AVjUdmkgAHi5hhHREcJdir1JJNTbP93
         SopoV3dPFtOpSp91+zriqzmJFu26UMJh4J6WTykSDFlTdxAHHUUjWInQ24AaNXHpmT6u
         0p400ZqBAGJ3Vl1+b9rsbIJCKcELGMekAi8LLJqiEht71SVKTcSWckOrS+R4xTDCkVEM
         8yUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768314318; x=1768919118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfoDKHA0t7YmEjvnkErYqJJlkysuyVrbP/3VHy3KXGI=;
        b=WtgUJAVV3AaM2YJaYEMz44JZtMyqIvUizGALa70pGIbxl13YwDQR+bSU63m/iY9KWW
         bFgCX5yHJiCoQcAim0kaxJMPRcpzguSZDHDyIBQvRZgqhYcHirs+E9UWEYSs+2Zf3L4n
         hhas7pqQQm94pLsbEQ21oUOiee859Qk/9JhOlGRkccgALxsfw2XTmowT3LERJIUPKR94
         A1pXgoKbqc45WDHwEN6lI91cSJh7IXdaCtRh+QvzXy/jh5l+uOG1yczGwg0OOkXko6RH
         GMQN6M7japMf8usJ5udmY3SgVcvedBvYH+OW7OjKZqk4vngNDgqzTqmksMSWsoKGeCSJ
         dOHA==
X-Forwarded-Encrypted: i=1; AJvYcCVaBopH4T1S80NcfdCDaPVc/MmAHwsDC7awQD9Fe1OC6E2Jx2qgbc/sLxWyxEOEMLrmKX/vzCftZg==@kvack.org
X-Gm-Message-State: AOJu0YzdOVfMzV+Xv4kgZVHrcPgyIw40M1eSDWYYMRqqK9Vd5apsjJ9z
	ILQDxPouVYj0qaaNUObFRCskgrLwEVGASa+iAFAbgEHwRrVm/EMSUZFugKOcDg8zSwQ=
X-Gm-Gg: AY/fxX6y90B0ZryjzJCKSFXMki2C/RtoKRxJ07WtBeBUqCodhNbs1n1OVOUGnwLP5p1
	L1oVXjWQeMGUt3CHfIfWClyGrMcyk+RN4GXBiICEQyeY5z2Nvg8u0h2lfUrqjrAB6mW/noWiHtC
	XD0wnrJbXSOjkJIIKhN9UALgzXZMnKLiUuU5qUbpIXOh9kRGnNSN3RSbEQQYAAG0OSxfovBVRX7
	XsGd9OJ5waihE1X/3DNEW63FJBArY9YP1jhxq5C4ldTrexsYVQWRZ6WUZxV787yViPCTrwJkP84
	k5GW/WOmiP6d+dU5E6jARvNB/ftnh/uNXuvX7NVrU6KQ6imvSCX8mkilt1QPyH76Z5ngkoqSipS
	vi+oo/qzzb1WonIykbOpUP2aIgt784hcMHiM6F6RqUH4JrQPdByX2ghnQJmS9y0yHhIkG1XJlkV
	SysqgpjoNNRrzNM4OfPnlisc7gg7dI4jC5Ivl0IC72a0ExHPi1xQtONnPNEE7Hpr0P0CdhYA==
X-Google-Smtp-Source: AGHT+IHaawq+QUONf9pvbM2QiUt4+mKnN+wnADsabj8wHXZd/nh0vPufWPhJwo9J7qzU6DncsK8tcQ==
X-Received: by 2002:a05:622a:292:b0:4f1:ab28:d9f6 with SMTP id d75a77b69052e-4ffb48c5703mr297765671cf.26.1768314317609;
        Tue, 13 Jan 2026 06:25:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8e4c810sm149855661cf.24.2026.01.13.06.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:25:16 -0800 (PST)
Date: Tue, 13 Jan 2026 09:24:42 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v4 0/9] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aWZVqpyzO3BikuJM@gourry-fedora-PF4VCD3F>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8803A40003
X-Stat-Signature: oqfin3xab3kj4iqk7z9abzmk4fbti1ub
X-Rspam-User: 
X-HE-Tag: 1768314318-107143
X-HE-Meta: U2FsdGVkX19BNN0hSD77tFPFA1oq7Dwb1d1iz5FEnwqyJ60tcyVE0J5P1A6LxSyKSL9UNKzfyMSrBrtcp63bys3uHaeknIWUM4fpMMhPdPb3MXUtjRG2m8ghcmMJnJpPdvxbWTq2ZrqMkcn/d3R4P9+DqRB/N+suK29jhj/DgAz6451AUYcgIWggy8xg9vqdvcjiRt91uM1ol8vHy3KoJ75sFMnbbL2UiBuRFj6meY35MQLMXIRf4ZhZ/zCo9ewet8GVJ0clJFt19OYcZOAIkco5u20owOZYF1IRSt/RbLuamVIW+/AJChWSykLrPTmR9rN4rM5CA1vurJvqrWt4/2NapXFU78ceC05N8wv7RTupOmNcQ80pi2rcAX/ie6sOHHd9xr447ezcp5BtMUDy7ut6WBVSZLq1UZ7s8XqoMlbIPZKkNUEw8aCG0KoOdzdWaTGNUOVaQv6b+C2bMAwpiLdzcnvj77MmlhP/TNdto3LEQGQE2LGmRDUdBuU6rDHekWpvlcesNWnC/e+3qAdviWhvLTq2cSTcObHxSVAkYy3U/vselYuEuE3B/LPYE6s1b/Sy/j9x87WEYS9BehSe6fAHSM58+mgNNCY2LK9eFpJZvTbU1HzgGvFbZTDq9PyudLEHU8M+hU3AsuOKj5OFsD20b8MLoZqyZdTjVckFn+gjZgGC+1ozo6R+dzanlqFUczs/+j7zn57gosj7B+N9fE10ImgBNdxXFfWJkqXuLJukMZKRHcUqyeljAJdCGm0lookS0aNR6Dv8uyPrrFTHRdyAhDzoxhVoDqv8PnCVNXdfVDarXCsBoy1xzoxLR5HqkVgD3HwSCU70f3CoKK69w9untdO2CvEgHC3etCEt3OMsBrSewADkpmBC9Om+juqgmQDAz6j/j5Oyfswajz8INt5eCM0mwjbS4huM7Os/5ecgh7kwAHNwThks0rWNx2lB1d4mUOgblaCs9RwfIPI
 u/KpEKqR
 t1Qk7DaFl/+TGv6PKGYlLh1qom0rtrAz3DRm+q5Risf/VszsEla4F3Z1Fb1ySyEdAgoTpDmNCbN/mrvY7K2W12J5Wfho6at1niqcs/3abZi7uBF2Ul+G4ljy+/LZKvZ9XuYGDwAkFfUHInhvjmNvNTBfY398YBD7/ZOY5ONKP4lKMnvR0tyiQnFwtrMW3y1UoxvO3nAZTvDVGAJvWzviF69eXii9ORBsadrUyJy7M1Fm6HExOQ/UC7PQmtTi99bDuP5cYo/MaPm8BF0UjRVO05o827sizXktxEgmQv7PLWQuIgLiMx64ilbQ4vsHCVgg4cxcQTyyhIMlnXwZNP/cgJnpU8ezJ6UKwypzauBZGR0KxzJPStVbXd5TZX2nHah5B6r39jXRXWk2YtV7+uo174dgiCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 03:44:14PM +0530, Bharata B Rao wrote:
> Hi,
> 
> This is v4 of page hotness tracking and promotion sub-system pghot.
> 

Just fyi, we haven't started real workload testing, but we're setting
up the process soon.  Just wanted to let you know it's on the radar.

We want to test this at the same time with some fixes we've been
working on for multi-tenant fairness in the demotion/reclaim path.

~Gregory

