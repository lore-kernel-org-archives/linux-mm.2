Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A106DC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738796B02B6; Thu, 13 Aug 2026 14:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0456B059E; Thu, 13 Aug 2026 14:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8426B059F; Thu, 13 Aug 2026 14:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 245D66B02B6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:51:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7984160292
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:51:41 +0000 (UTC)
X-FDA: 85097140002.04.8CE3A28
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id AB3A220004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:51:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CN6YDwmW;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786647099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EePxyuxj/ORuNvnRcTqvK7WSqyTYRaPWHyS7fmka0Cc=;
	b=4XXdUQ6mjhXLt5ZOAHPkrMaYu+TX5K9H/G+ejOBeiSF/8zOppZ/kFA14LFjsneDSQC7uyR
	84b1iCWNO/usGeqd0ZEwrz3zv2ZT1Iq2jBbEqLXNrP0oYpzTfR2A548A/PjMLi+R1pJ73s
	dwJQWjZ1msTd8eqH/1BdLeliPZqHnGE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786647099;
	b=DCb2OAhHoiRNIPKebwGZVxYjkr/LduMvRhW8pCiYn+fLRZzZiyhwF2hMSXjM9UwXJ5d2jT
	2lfV02my/BrabH5G+wufqM6XzPO4Asw7toqE173sYgkYOkHYhJjFeGby0Zq6QqCaujcmbT
	wPZaf82E2qnPUMaNkLkAPPUB7BBrKvM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CN6YDwmW;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso103558a91.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:51:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786647098; cv=none;
        d=google.com; s=arc-20260327;
        b=EoSspTq4cXINDgM8WRUi8mW1liCwzriB8m+pPsdvqbqAblKMADAg4PebtZH5IRJXhe
         CD3LTPUDrZUpzl7azgdYhGIQksrCglN9bGU692U851aDVev1n9yrr5iKBOnH1vTmO1Ev
         WKGDmJQWCkM81BIaWkBNwktG9ImNvpPi8F+RP7LlxxiVnT0m+/2dpxZCVecDoAt214uN
         jH/Wgf0oUIoB3QqRl3M5ozzM5IDSt/BFFcqr/SB3cJn/QwX02bNrGopZ6pcASh3SuHTv
         LnTE6sFuIEwv9NjNuQvwo36KgCTzqzoLYeov+H3L/yeQGrvHuMIDPznQAnICgOCE6jdP
         vRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=EePxyuxj/ORuNvnRcTqvK7WSqyTYRaPWHyS7fmka0Cc=;
        fh=0vLt2hfrB9PTIwV1Kh669wmJd8K06ll5PSS3NvzlBoc=;
        b=E+T3RMiBjuG8ArhMsVJZCRpjDo+UCNRPWNi9rKUWKGrkaBYkuXi6nyrNwd/JUruS/t
         XrbNaSMNG13IT1FTwhtsXe05rfzyLyJ5f1OTScDsbYdmHG6xhI/DB8AbN2UfkEFJDdTw
         kJEJjyZiGMRjlZpw2AtYq4lnvgNU5vePNQ/4nZcpVYQWH2QF+IwSySdplhNMxntveV4a
         gQdZ/V8FZMi6FT+/Naxg6BxYmWp6ODf4eQvUnnIkO5esf0JX9Js9YJUrbrT/nW+L6962
         eH5I/OgzY8uLu2sITB1aWCOfzr4i41gz0kcwzdSlpObtCxHPKr7uxEYK3em5E2m7k8D8
         3F9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786647098; x=1787251898; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EePxyuxj/ORuNvnRcTqvK7WSqyTYRaPWHyS7fmka0Cc=;
        b=CN6YDwmWckThBN5Y6Z1vwY2nJwE+Q+MKKF6uuJlkm1ktGASfhMJauW1NwibnMW7e1I
         zztrwbdKFYtsvoRUD0RKjSAVcicqO6pjpCvILGCKh+iGhXvXg88UKkCB2aDyQOaEpx0b
         y5eh1ZW/eXkV7j/ksWIoz295dGSfUh4MtFl4P0clMjCVb42vec2q2NC517tNURVu/9f4
         /LW+OLGZ00qS9Mu/gZH9CkC8xb3r+QEsv1hIf2a7p4YwDjKWKAST2u3i0bCjDnfdb3KN
         eqF07aGC6YbsXK1tCLhQonwYeNBGUo4snWtzYVRlTSgKne/tcRq40A60jXmDR9zqhMV6
         oqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786647098; x=1787251898;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EePxyuxj/ORuNvnRcTqvK7WSqyTYRaPWHyS7fmka0Cc=;
        b=IOZ/9ZPNRlG02uFyyoc4hHX4qTAQmmWkwmDU+LNGZ89LFdbYpkn4jkAUxTZkFaI1D2
         eYxFVzTWvM/qnXMCaMVKPwPP2YBgMZ0728zRXTMTsE2RAA+Xsj1HNa8xW6GZO+vHKjdK
         vfAX15flr32JkQD0NHwn1rDOsdByBUmpLhZyG0lcrWqJMdTwgXJmpG29gNVzlKyOdfea
         7AF+62kHyXt5V4vMPe693r2GShOO6aLeZXLisQURhrM5rg0/6R4+7VGhhsSxrCT4/Q2g
         Q4qqmAQmGT2aXutO8W5tGixwygXc0i8HZ/CjS6qM6S0N/Z1OElcFmYkHoiZZBgzB/0xm
         C0Yw==
X-Forwarded-Encrypted: i=1; AHgh+RoVOQmtQLuWdPBbNHNB5FwEPqU29ZTriEoxLlwEvWFUwXWV2Hk0O0Som/6CZGcYEf5G+jY8YV0CqA==@kvack.org
X-Gm-Message-State: AOJu0Yw5TmNXOD3UZtWTi0hpKVmhbb9a943FLxgbVjIyJp2THwRB9d27
	C0oCho5asb7f0UENZ9eGtzzdHhmz6dwJql9MQwNwqQqhzUuebA34KeJRXGJjAvfZAhlo5D1TeZ+
	Ag9Fg9TVVZ9stYMEzJqazefxk//VRSQAaP3sA2ssX
X-Gm-Gg: AR+sD10qtHg+ERm8gLdzCy+A5sU8v0zjjZsy9HbjjidqN6QuCcX1y/mfrrZCYXGfuzN
	r5QNNWJj0kr0L8f9Iva3KvU/BfAjEQktNzf2vMrW7YTGQMElH3Ty7GkvA9SlCaPB6h0rt6kc4tf
	i5peBLO4lvtkr/ei8oAoZg7agy1cxi/Gs6b0BHS+S0PbBYcXOtbacBHU56kTvTdftETiNEWmQNz
	nz4yfmeL7TuS3E8vC+ieLRgWvdo5OZb/iVCfFI3AEEdOAMITkKT/s38ARysV4ARFkdYK22OLe8H
	wghhC4Zu7YiGA/od4ddcR38xG0yukECqGNmxX5hH0KIG3DnqiBclMCZi9fsXdEFt2JKQKEJmyUz
	jx/oNTg0wVVUP8wqDhCLiHNMX+UkqBIg=
X-Received: by 2002:a17:90b:288f:b0:380:86d8:8162 with SMTP id
 98e67ed59e1d1-3931f5f5fffmr4564862a91.18.1786647097635; Thu, 13 Aug 2026
 11:51:37 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 11:51:36 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 13 Aug 2026 11:51:36 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com> <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com> <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com> <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 11:51:36 -0700
X-Gm-Features: AUfX_myWEmd6jjOfyL-08bj4iJ8X-_1fqONSad0Pn1FbAvMHKm6jyQidagK1AHQ
Message-ID: <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>, "tabba@google.com" <tabba@google.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "forkloop@google.com" <forkloop@google.com>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, 
	"tarunsahu@google.com" <tarunsahu@google.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>, 
	"baohua@kernel.org" <baohua@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com" <shivankg@amd.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "youngjun.park@lge.com" <youngjun.park@lge.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "liam@infradead.org" <liam@infradead.org>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: so1yh343hrb131j5izgrxitykph3arax
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB3A220004
X-HE-Tag: 1786647099-206892
X-HE-Meta: U2FsdGVkX18ZXHGQ5Ulg6JopPGksdvXdDqtUVxZgJqzQrY6p7zoauGxmDOQzfNDU/ZD5GVf48FnLd91YYU0tA9WXwTePRd/7ROmAYuy5RZ9NxDCluMFvuykD8oQtCmF9goEK5h5bdg9UjdENYIwtpmq/sMNNvoVkmpUC/2TLlmLGw0mJgOiGZ++17LZe6/0AIDuYkWoVSk/jEKY68Tl/JR3jabKAjR2+pOOu3kGRhK1ScBUHfG5+sAoZjriz4nL02oO/HSxqCinl7MJr9i24DAIaNvD0wxV1oVWjPYuKztbeVp4KTiN5YedfVQM9gwzPqY+yWj3MkhI4a8Ae6P/WiKkN3++yKaSAVQ2SKXhdMDZmKJ1XtybfAWa/0qUHtx+PbOtrUPej3DQwERrgq+4rqRNWp7z4t8XIK6Sq3etA9+beVjDuyfHFb1WxtRRVZgp7GsRAnGei5M+/lJeYVXJMONUkYVPrw/TfdC91p0h9meWnKKH0gNXTAlq1l/sP8vgSWDFPm9RamIjlVC4747gBO7kX2D540uENkpVWgFFsJafmHMLfGSSa9500ebJ5zb3mwAgH26Jb38HNVL4eGrZyB3qZE15WwiPS8nL1rJIczMcAbstaedNOdcJDMybYRD90DylhaO9LRwJzMlnf4hNDK9vPG726SJRmHbP/6UeTnSsaEs0iHDbu0CusZpsZdnhwom5VG5/voWZxLnOvitD58cwOZo6jpyAcs8E0XJVkb+aKA80UF+Kni3NJFG7JIAxafgypGISYdPdWT02oS97DMdjwlyjKFidqfORiuqQ0gqmh9jGc/b12OvPtFTb8ILaPoGXNkymnvLwcHhl/MekrNXls1ZHp/oNUVt3Md8/ivHFr7WY/JP1u2HNq1JZQI+3SvDvTxWTsOSUOwmAfruEYkcoicQBo2P4OZj5RURqDd8GNRn6VkW4J6HjRaSz1Q88PcU57d1kANjlgvDxKRAm
 l9v0yxMc
 HAMbTjj2ZGV/wjUmA/tkHYHg1ZWWh8JQeL4HEDVGp2FTUyvrTmmzVbtPjPhI3kqvJ/8gXpfdmSwvg3AO0aIvmVYDu9NecgNV8MbgTXBrQiC6HwBT7+34kat9QqzfoQrTQQYxKS5y5ZLsAKLlI1FqwIlS1Q+lJlMKc2mkF8rdwFdspwvSxzmaT+yz9WQmTDRAhmxtYZ9osUuHO8I3Obr07HS4+Kvzr1IvTircUWG2/9femLWaL+PHiDVI4hzfkIn+106eM5/fgMvMSsWL8sdMNTvU9tHf5S58F4xMBA2Ykw1DNqDBxBBBJXbGj5/g8iHGpHl7Tn3yvP0LoR3YDoa97pewDrEX9ALYr9o1DEnsPy8F6yjnkdNxnH37w/e+o92ZNL7WrU12KeQUOKJQz2rtd2Ybp4fk4lx5giVX8o1YWS5M14CN8TRbxeaYXx57Xm+myjMdkdQynNmahbvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Tue, 2026-08-11 at 10:35 -0700, Ackerley Tng wrote:
>> > > Would like to see what Sean thinks of this. Either way, is it okay to
>> > > follow up after conversions lands?
>> > Let's see what Sean thinks of this :)
>> > I raised this because the issue was encountered by one TDX's stress
>> > selftest.
>>
>> Which stress selftest is this? I can try running this on my side too.
>
> We have some selftests that are built on the basic TDX selftests. One just
> hammers the MMU stuff with a bunch of zaps and also weird stuff from the guest.
> It was eventually too much work to try to keep the internal enhancements rebased

Would like all the comments we can get on TDX selftests v14 [1]!

> nicely so we actually just run an old branch's TDX selftests against newer
> kernels. So the branch is a bit of a pile, and not really suitable for sharing.
> We plan to clean it and upstream it when the path clears. So it would really
> help to get those basic ones upstream. We remain happy to help, so please let us
> know.

I guess at this point I'm hoping y'all and Sean are okay that this
conversions series merges, and we let this stress test failure be
handled later. I'll be around to fix things :)

I'd say the line of sight to fixing this would be when the KVM MMU only
gets PFNs (and no pages at all) from guest_memfd.

[1] https://lore.kernel.org/all/20260722-tdx-selftests-v14-0-15ad654a50db@google.com/

