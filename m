Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC96C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C426B00D5; Mon,  3 Aug 2026 09:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1250C6B00D9; Mon,  3 Aug 2026 09:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014376B00DB; Mon,  3 Aug 2026 09:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5AE06B00D5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C58D140675
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:07:48 +0000 (UTC)
X-FDA: 85059380616.23.F3854C4
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4128F4000D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:07:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZtAqIizZ;
	spf=pass (imf01.hostedemail.com: domain of jgross@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785748066;
	b=Wj6QYa3BobDg5rB5Qtig6lUBTDYN/YX/s/9R29pxlUAIlHmATfvSts3ckx600fvIA8oiTB
	WnmOdQ2vI3KbyF7o1asQM35VDbRvMxnhHMocvhyK0I89ZblQQUpo4gdDytKiLCBoUgCZmF
	Md5piRKMOceXvRPTTROnOP4i/i2HOFE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZtAqIizZ;
	spf=pass (imf01.hostedemail.com: domain of jgross@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785748066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b16T4GW68hAFFc0osm9lAVRPnORne6TE2Xjz+8jsFek=;
	b=DV9nOG+eohWUbsVyeAouaz6Zi2BvHDUuJJvAmLtyaBO6N6uKQiEt5VcCLk28CGVaxYIZHW
	U3sKsAg8raXdvp2HWj/9KidruZGhz1vSCHbrhSbrcfcF/8we9+dwTLJQvhYAa5ggpeZgWQ
	dfsGMFbM9wQoqEsXuCgX+gr5PGQGvHI=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c167bda216fso468183566b.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 02:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785748065; x=1786352865; darn=kvack.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b16T4GW68hAFFc0osm9lAVRPnORne6TE2Xjz+8jsFek=;
        b=ZtAqIizZJUsAe5iTWGYzF0sUyvKt7yuqZp3jJS/gl4b+Xxnmn0cHdYAF8SzRqRVLYM
         ekw2Q116bu7YYlbXJqopbrgWsSPk07+EwuqukleOl9OZt8vtitHWnpPBQVAph18aCYUN
         0sSkep/l1a1aa/NkNFcY3OFh4RgJvkVhJ+0RXJzD+8B/X8Svbx+iWAKeE+s1Ig8NiaW6
         MhjPFMOCqtjGjhunjAwVIC6M6uT0Ak6vG4W1EmMqrjQChDR7isaipFtDL7NSHPJUCaRX
         jdD4IEcjBcqRom+FuXaDfFDvotjsOWfJs4EKmoXdtIf3WhyAgayQgpzRrF++U43wcUTj
         M9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785748065; x=1786352865;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b16T4GW68hAFFc0osm9lAVRPnORne6TE2Xjz+8jsFek=;
        b=mS8rAaavFo/KtiN/U1IXAx7IoFi5RWIINKhLHfs8CYu2FJ17dSgXlbCLps1XtjCkpj
         yo0JBu33Ps8N0Ydbf3iAEJT7vEAVFNMjzdKV71Fek3k5Zk9oRChvJyZTRbqhacv5eB7S
         GZJ6YlVKxnPhsiQ4Jv+w5ZPCgojJXfOJzUzI/iULUonc68/QzTAftB+F7FnSvczqwwkP
         DxpNwAdcP+LHtI6UUwOp9NSyX9uk8upwsv/I+c3KsAiuwmBZ0TFrmp7k7eouIcagxRlq
         FyCDfPqWMeW0SKLMsPiq3y9N4WlvO9dXxNKKXx/EqJm+rSK4q/CxLVLIpPGgc7K9eq4V
         yAvg==
X-Gm-Message-State: AOJu0YyYWzxpHC1mirUcBVG/fKzwH3WKQFdnJnX1DyvsmIORlAYvB07q
	TD08Rxt2WQAp6KXHp0g4aNkarYCyd8mCtCmFp8biLKbSTV0Sihy8TZiak+KGMVX7WtU=
X-Gm-Gg: AR+sD102N5eXyrs+GDY164TVx3H4YkvDN7gg0cugkeNh7Dyb8zB9SF43TK2Glato8n1
	gjs3Ln2QlcZAO2sU/vQwmI3rQqwNv5eJLroG6vWc5nxuuNOTTYlKH8IGHpuJrRFLRiOdq9dgMeF
	g5V3zpw7HLG3ESJsvrH9Benj1SJ735OodtYSYoL4z1GpwBm1dZKqxwF8DvfUJW4NgzHN96sdHFO
	zFNFUOHCLrEtvNggGGljGdiTwOm0wsEJ/u90ZA/nyBM60BpUMqdnBmFAiD2+mZ5kqKI/OJ8Jd1a
	Ii66xLiUshE6RQ71BwFvZUg7DH0U9+tIqVM5DOEzLb3g1T/0rYCvzEk2dRSkzFAkK9EmJUyo3EH
	VgAJfF55tbEz+is5wg9rMyh2kmQeccOwzq0audp064ViF+NRQDhn/F7MTS4oQJtYYJfOO8t/WgW
	TudT9Jlnj77LpcGHy2j7q/dLLDT6c2eoIK9+II0g5GIYROrLM6M894hn7k528WmEFunya/UZgj2
	e/qLtJGU4J/hT5sEbnTzAqPbQJ6e/lYD0kf0c0LibqRRvMJWGB1Edl2CN6sMdpOvOaVfDISu8SM
	86BrJUznr9UIPyg=
X-Received: by 2002:a17:907:76fa:b0:c19:fb6e:5ff0 with SMTP id a640c23a62f3a-c1fe81a5d9fmr582774266b.15.1785748061532;
        Mon, 03 Aug 2026 02:07:41 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd445432dsm507440166b.41.2026.08.03.02.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 02:07:41 -0700 (PDT)
Message-ID: <5ca4d0e4-1747-45a7-a916-a7516bb1692b@suse.com>
Date: Mon, 3 Aug 2026 11:07:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/14] Remove PG_private by using page/folio->private
 checks instead
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-fscrypt@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 Gao Xiang <xiang@kernel.org>, Jan Kara <jack@suse.cz>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-trace-kernel@vger.kernel.org,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 linux-nfs@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fygo.io>, Ilya Dryomov <idryomov@gmail.com>,
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org, ceph-devel@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Dave Young <ruirui.yang@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Vg9NJvq3ine0Gyx1IX0BEzQC"
X-Stat-Signature: whtxdxr71k4po81xc1j6z3pf6x9jk15p
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4128F4000D
X-Rspam-User: 
X-HE-Tag: 1785748066-672316
X-HE-Meta: U2FsdGVkX190b5K7/iqEovFrEfS0+Rr0QndIlAq9rX7EK5663bGAj47wV+9DKhG3h1jPv1xlN6aiPC19PvaVCvpMRyXMsWtKKsLE9K4PsLYqGZein6daEma7DnnUopKWTtBw1qCw+Uemabz+CMWa4RFRhDSRuNji1wLobAUId63vm6uaGRlaVwZXKgxprAd7rAtSMZoq2j0eOmthqfmtqgGjOuwq3TDS8BIsVF8FGVV3LWLXHcnftH9VdGhr8QZrFRPEnyNKqTNm8hSSrg4bpELlO3LXY1rfURTUevz9gUxBlhokEWt8awiImDiG1KZNhFGV1hJq2FktrMBastZUI6hCZTJyfhZeQz61ua13YSlfS901zH5yTzRHCirvLbzU9YGlePsj8VO9jhf6FldzFw1z+EnJGoHKkoBMu2V8ZgUo8ReLOnAirUSlIEiCS+V1TC4iYXJBqcea/7MXLawvkcMQsZ2ZsHJN884xkktZb5o4JZM4sO8DwwDvueakJa9TLni4L6bq++Ofaa3FFI0IIHLRJoc0uA8vrX9KlURy0qEKaALNaJfpOscLJaKgOPSrMoAIXFM/+XyuLxY+b6HBh3Nl3KlI7TjqCMu+mxpnQ482SOHrZ2ou5FDbycjH+Xk5DTak/1ksNT45qlck7bhoOyoA95ynw+8Ylss/UVkHY3U2faUlo4h4n1ktZoSZib/upGMaSCzXAj+lLTDo+HwrEJUNJJaodBwpe/ShPvZwb7bPFVPetQhUVzfbDCif9CIhAlyBSSBucMMB26t9/XJiQJz/Km+17SW1tB6Vg2WkhrTbTBeY7CV0Tp+lmbTXOvcp7omgSSZ5VzIjzaNAWp5UbL8nEn0ywcb25XVgc/I0ThfvuAaoMRNvX8qx0l2oW1+eGYUEBMimN/gkdVkTwLAHoOrTyNrB+9dlPoIEg+MCCQr9niNtdulKrkAXf0RL/DWigx/4dX8Ai/HYT2+bUFk
 MCndTNqt
 41wPmWa+f1CkGM7R8CktXv1s+E6HvqnM66/EB9muKZofoIIdvD3UvHl+m1GjwaMarIcsBUY1afrxrlt0HuJ3NK4asC4GQ4x1uwx4M/N/eAIzo0KG4JliuiZT2hlMuXrv8MZx4NsLgHYsMAnkRLvNowpipcy4IKM0wny0uvW747ndkN88RhAPHI2LUdtMGpaPgRspvi0eS2Ldd1aDo6JI4PM6i+WHsVMAciY8Yth8UtAJp5qmUwLps0a4HLm4mQ+u0coLw/20ZOYnPiCcnK7YGRPOxnOqH2bu/zD06c/E1lVXFRq/n2wjOmngGuyxMvpHEmpjAm+vUFJ0SWn9iXp38SfbiERmrVqfQOlw82MENl3vRr+wAtI/gHRLaqYanib9JNv8HtxNLC11bkf9W2P82jN5MGFMGaSrRN2RyhFX1EYtPCv4QGpYHvqzbMYzQlNNg53PDa1IuhWl3xb1cXyogkMniDWai6EEagx86kquoFra3f55N5d5xZc3ilUpEdg9VWuOvkagIYmKYvM23/5MP4CWQOsQqB1sNeJzlPOOe67Xll3zEP+zwHmt5pVtaHQhAfYY5GYD/q6CbacuVLpouueYRLIaIvRR49s81loEqLY60JMP72VGSKqesoeMbPqEx1lKnF3bPSmJW2hSV5fL40olYWmkr4V18TG3YKWm852tfRFsPtmeBRiBiVopIGSFQRPFkjBkEd+e9U2nbbJul9UDH/0NkEqVXcAlvFq42P8NZYedlBvpm28LadbE8EjknG+VAvdCnMooLcD+ykpA6cMdAm4SQJrA7JUHvWAF8Zg8PCNjfQWqqpmdVlUNmfDYZmhy0SGu0i3GTG3v8bld/Tv7KfxiG1y+1hDs3uvbkjXDabLEJHaAf3xLcRmaeYJx52QBYpRE2G3Dbu1+LFc3W36TLXPRUERjlG4RssvE73bPTAqM/tPKM8/WQeK4S3P7jOOcljbI46Lgh/jU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Vg9NJvq3ine0Gyx1IX0BEzQC
Content-Type: multipart/mixed; boundary="------------1XNOHvG0ftKOzuceeKWaT2Id";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-fscrypt@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 Gao Xiang <xiang@kernel.org>, Jan Kara <jack@suse.cz>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-trace-kernel@vger.kernel.org,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 linux-nfs@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fygo.io>, Ilya Dryomov <idryomov@gmail.com>,
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org, ceph-devel@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Dave Young <ruirui.yang@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org
Message-ID: <5ca4d0e4-1747-45a7-a916-a7516bb1692b@suse.com>
Subject: Re: [PATCH RFC 00/14] Remove PG_private by using page/folio->private
 checks instead
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>

--------------1XNOHvG0ftKOzuceeKWaT2Id
Content-Type: multipart/mixed; boundary="------------emnYBJyIfA0mAuf1FBk0JrWD"

--------------emnYBJyIfA0mAuf1FBk0JrWD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDEuMDguMjYgMDQ6MTMsIFppIFlhbiB3cm90ZToNCj4gSGkgYWxsLA0KPiANCj4gVGhp
cyBwYXRjaHNldCByZW1vdmVzIFBHX3ByaXZhdGUgdG8gbWFrZSBzcGFjZSBmb3IgdXBjb21p
bmcgUEdfZm9saW8NCj4gKHJlc2VydmVkIGFzIF9fUEdfZm9saW8pIGZvciBpZGVudGlmeWlu
ZyBwYWdlcyBmcm9tIGEgZm9saW8gKG1vcmUgZGV0YWlscw0KPiBpbiBOb3RlIGJlbG93KS4g
SW5zdGVhZCBvZiBjaGVja2luZyBQR19wcml2YXRlLCBhbGwgY29kZSBpcyBjaGFuZ2VkIHRv
DQo+IGNoZWNrIHBhZ2UvZm9saW8tPnByaXZhdGUgIT0gTlVMTCBpbnN0ZWFkLg0KDQpJJ20g
YSBsaXR0bGUgYml0IHdvcnJpZWQgdGhhdCBwYWdlL2ZvbGlvLT5wcml2YXRlIGlzIGluIGEg
dW5pb24sIHNvIHRvZGF5DQppdCBjb3VsZCAoaW4gdGhlb3J5KSBiZSAhPSBOVUxMIHdoaWxl
IFBHX3ByaXZhdGUgaXNuJ3Qgc2V0Lg0KDQpJcyBpdCByZWFsbHkgbm90IHBvc3NpYmxlIHRv
IGVudGVyIGEgcGF0aCB3aGVyZSBQR19wcml2YXRlIGlzIHRlc3RlZCB3aGlsZQ0KcGFnZS9m
b2xpby0+cHJpdmF0ZSAhPSBOVUxMIGR1ZSB0byB0aGUgdW5pb24gYmVpbmcgdXNlZCBvdGhl
cndpc2UgKFBHX3ByaXZhdGUNCm5vdCBzZXQpPw0KDQoNCkp1ZXJnZW4NCg==
--------------emnYBJyIfA0mAuf1FBk0JrWD
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------emnYBJyIfA0mAuf1FBk0JrWD--

--------------1XNOHvG0ftKOzuceeKWaT2Id--

--------------Vg9NJvq3ine0Gyx1IX0BEzQC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmpwWlsFAwAAAAAACgkQsN6d1ii/Ey/i
jgf/ZwJPxlL37xKWgHvTpcOyxx9OjPwR5NnmxhKYC+qK1G+dCKRR2aNsNRd92IvtuR/zlwoSK3Bz
7Knn/QAX+Sr8+MzzkoSZZy4464mITxuVnjBsYOy1wmVfTRA9xJ5kPDsLcow9h9fba5YWY5JKjJEr
fuIk59vC3iZC8TXbrwFnUB118QfIzPMfnHvl18ioDjqN/X6ooFJudXLB3hTrlpzsxtdu1OFI+TsY
0FUiNapbbcLYtM5X9v/bo7LSqQNdjZKmfV2DVQHs8Vj2bH/TyrIG+SvEggEztdqBgec9T7Ix66uU
FOasApx6jWOz0UmYAKKBF0iBOhSZaPnQhSA6xqkzCw==
=lraB
-----END PGP SIGNATURE-----

--------------Vg9NJvq3ine0Gyx1IX0BEzQC--

