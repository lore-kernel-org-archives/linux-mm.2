Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3116C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37F06B0088; Wed, 15 Jul 2026 13:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FB36B0095; Wed, 15 Jul 2026 13:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF256B0096; Wed, 15 Jul 2026 13:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7906B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:46:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BCA51C013A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:46:26 +0000 (UTC)
X-FDA: 84991740372.19.A189E9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8DDF1A0002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:46:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5OU+tyC;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784137584;
	b=QJSFyurZoTeyreB8ZtJ++Pbh1i4taDgR7ttIKRzjXRTjDY3x8N1N6tOzg7UZNwmJ2ktbtt
	2fhbJER4rKA5pa7uQXWTdVwuJZAhtGvtyMz9m6sPg4yCBeNIh+KJd0zn7riytkbUVpu1tW
	U7bCm3C9JDCsyS3dqmUFaq3oPuToP1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5OU+tyC;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784137584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/u1LN79aK3IUnV77rgUOomTAlNWU5LxvGP54X7C8Ak=;
	b=y9Xq5eT2g05kDo2G57Pfnc1py+Y6RVsAGultiXSXQXUmKYsQCzzL3rRt2CNcJj5Gm8w0J7
	vJoYeBdPErRyIAsI6abPe5nLKtiyy4AO6MgpqWJ/dZrYRLfvnrt2emF0nqDO94XtGbByB2
	5Qto1rcGEe82lo5HU1UeSo++9h/n6MY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E82FC61836;
	Wed, 15 Jul 2026 17:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E961F00A3D;
	Wed, 15 Jul 2026 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784137583;
	bh=i/u1LN79aK3IUnV77rgUOomTAlNWU5LxvGP54X7C8Ak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G5OU+tyC9Uci2mg2LwO/DFWdxzlrUtSjFyPEwxUdBWJMt8He0NI4s+djB8hRv4wOG
	 7VFuxq8y9+9BxbnbuVltajRTgY3sRE8fsrNdrqMeQAPpvsgJhYp2qjvxHS3+zTCPwV
	 BKu6IMADurc9K/njpDhs42IUfi7xBFo/0LVy6ryOPdp/NJ86LNjc4rvUArFReaRCzN
	 TFcWJeZrREGRa+rRh0IaoXvC4V6L0XzTEul5Fdipj4KCnpU4EFsQK/grpq8o1ltRPy
	 aEhP5qFYigUt8IOAQlEaKa6y7ZZtkAkgO1E2W11msSgBOAan+xHgOE74SweMlVg+Z9
	 LXI2hpD/Hsqlg==
Message-ID: <b470eb19-d59c-4dd6-bf57-648b51281691@kernel.org>
Date: Wed, 15 Jul 2026 19:45:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/33] mm/vma: make vma_set_range() static, drop
 insert_vm_struct() decl
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-25-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-25-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A8DDF1A0002
X-Stat-Signature: gfxfnuc73c71pgd9xomcf8e91zbzkqrk
X-HE-Tag: 1784137584-72521
X-HE-Meta: U2FsdGVkX199tZZR0Wvzy+R8uu+MiZROjNWEhw3Tf7cukwa6d1iXNhdu76H2h8j74gHacrJTPRVfmPihWhgMshNXIvfaIWMjbtp1q52hg7X1awNzLHaFN82eK8gnbq6BY7V/8bky4fsVr5ikD25sqOiBkGFoMOjMyyYo0yZoylnvg5aPqnpHfN0AhJjN/6GRGV7YHvcnp8MA/+ffyhH1beYHHXkwIK5xZKouz2nulDzKiwQJbv72bBe8OvA0lkscv7y7EQAZ7DD7nmENqmQWsSMba9nB5yM+yiyiXevUE0csT+IEKxSmDRCA3pQRj9wLn0XottTHTu7JiOCcL3mqO/aVUQlca4N1ypGq+CldE60iuv2DwLkoVvFNS6XaFEdGVUgAxIhjnOJSFyefg59YQ4ZgS1vIYlXbyC3Nba8HdqMc46vcbinew9SnTqCuRVHdwsGRCmJYuVIVPYmMx2v2Pwh5ik2s7+d84LAlf5MhxodaIhimswL0k3uPJFQUK9TMAlj7W93wMG31cU3zwHQggcOgyosCi/idLnqSvqf/gjQZvAkaoXHwjbrwF+FQr3dUz4cMqa/cHlNmcRqMkap5IUun4NCIhiUJENF0pcoHFmyIN0Bx/6Q24pwJpQa3fFySDPESRRbUaMHqNpS65pIF3+9vwfGewc/genFoMlVlTxuUIleERX9fkCnXfViCuc+3daeLTXvnvcLjdPre7lkW350K7uZeRp0rBeHB1wMTLPzoycnOMupb2koCUf096L6eDNbk7zbqQfasVG5d3VJYI3i4CM5jKEYDrFIrZsALJw++OwsRap31WP4IzhL1MkcqvpvPRRFhMYRdU227Ak7Z06gw6EqwT27uJTOTDQkjnvWmcdApYOwyWocQyjezpqXer6qLf+i9vGyeBpVlXiUgQAEW5edRRVTPUtHxrD/YlsT9QNl3qPki1+1Y76N2r7YP9bohMHy7AVpOwuJJ7CD
 nzaEGTVO
 Sl6OgXPzDhnb2kwmhS3kPhOIfBDMjxLTiFKgoYbLQukLQwhUsvMgE7kySoqotZjqrN1Ex1IYJWSqC0McK/iWoiHqQiGt8a7gEExijbcF34kn/BSy6xkeiReHfz9J3hh8+2mZ2D78+LC/rnq3TOLblOifpJMVtSP6xI+7nXhmASM7yYu968XeXoqly2598qhO2A97j2szQ9lqr+8deHNybF38oQJNc+ubfNkHCsP61IfprI/QbUU3qgqIiO7zQ9tFh4dVrbHLMz9kJYi4ZMci8lQr/cd62w/6IgxzOxDjo9QpomN3SM7fR6uIDInosXWLcyjkxe122Be343hgBIPV/v34VFNb3nrHKAeO2abiiNg4+Pd0NimkBi46NrP2MEPOVhtOPEAUVIGPK/eGXZOE4Mqo/rYj4jSj8jTIdqXfnKw6YaR7JzHq9X2283uBfdQzNxw/mUjBsKl/VT1f1h2faEYTCoLeADnqAIoODGYKSsIAtepeazPlNRLTpvH0RAjKRbxzCjOquEay8SzV56zpd38Z15eXLn3AN+5DairwZXbAfZ5FhzB52NFuuEaMLnjGquREoB7zEqUD/8n/dFPedV5hmZKL9jjXIb8v/ngQdsKjB/Ts2vjK/GPBwQwfBmqs7q5pSemxs5vtwvPgJzVaFmt7Nxn3cjQpQLruaJf/dnJ+e0C70AwcUDD5u/EVJfH1Kjk0WKnQwLlFx5WMfF9A5pAe1i16NytEeHqgnJs35IEYNXNhgW0jYDZkZYlEGUiIElcLjoieRqYh7TnYvXJgvtur3OeKN0ti2vupuU7WGtcFvl4qyi75gqkcliqrz7DmTbthWnYpAGl4KDRALC2qnlh3JmOkzmAmeEZ6FDPXLW4bjpqgWp+XdCb6FEIkpiXNK7RoQJuqUEIed6RR2Kv+zxPJ8gb5sYyAXDG0afsgz62rRZBYbe53CG+5eildDN2gO+w0e7zOcdTjsiHLbxiSap+PK0lYF
 W9cZ6e8o
 q5qIOWBu5FJw26OQwiXUBuLkcUSVLAwSmSoKUgX4p3z+1H+QYzWFPdSFMnVdDZnz9CWZFmJmeoMXOk2lL2K3K1xAjgfpJ3UBXKPbvN+ncKyZtT77jadO9bjoXJlXKmMQj713J+MR5QQ9phq8L1/wehQGVupYiO4MH5aDUKj9AuX1DITDUrPGYLrQGLVxBrClY440lKHGFkopb7HForHlMVMMjpXwEUewJWrsTSzQIEjJfG15K5IANHwJy6MUAeVEVzVDNtgoAzynTxjRRIGOEqXdUw6c3rTGsC+LGdWzpw7fvkPS0zDncGj5w6ldFOvtFi12uv4R+XCQjtQb2kW63GZY52FVAcZfhTGgFKFnrVm3/3Fwt7N9g3H0rzaOYCO/T0dvo4bylklYmqE5SumOiQ+9ydT9ta56phphnc6+eNqe7xweX9TISt8D0bToadJWi80PDKvSLmqQWvA6Gtp/vyo2Fy5J23GWu+SHoCNe677ph0e5/l1L9KlKPg6EgnvU+eKqegEZeo6waF2QdTmDutNNdoKKpw406GRyoEodrQ2ByMb9ONx2RUJLl1wRCXCcAwGWY7niyejHsATCxd1pYKptKbarFUk2Dkk8nvFoNfAMOCVa4jAh10mdN60EfjwFJe9ULxtjqdOHC+JOiP6oRKH/KQbvV9rNCiOxObxkUsAzood6vXCJYQbKipiipVqCGogGOnQVypP8EqQMZOIj3JXUNKITpOJZQVD6IsPIYUk1hLt9UcOKTboHfR+M5JWp3xDCQ925fYDYgED4TSmHbilz8v8h3SdAqcyQD8geJm0hiYMeJ70/10TjuA2JcVB4BttmMC0M0Z6aAa37JpEaxaIkqLb/xn1EqwnaDEclIY11QNYIG18YoBnKdETswgKmzXvqG1IPhLlIzj3lCJLmuMCIFgCMOesntaEl4VW3Z7ZLdnceruquO3HXXxVwEGpTv+dHv6kc6DnXfltaG0K2UCNuMvj3D
 O5yYlxmT
 pj+i7suxWHeZN+pDxJ1MiC78Qvwz4kN+YNsQSEJ03NT5H9I1to+8GFto9s6031CW3XtfxMe3U/kZOzO5m+dbQkG+ZJPRely4E92GqDbz58YgXK4GgIsP//E+YDzWa5+TMygTImIkIhTIj+lfcXMiwc62IjnYeXTQQs830h198QDOyYHTJp4oFpI6hcscCrawHIkwAJGWElB+uczSfbBPA7j/tLx8pRe2aIqD2L1xyD2xrNiRsmWcTnDMTq49o5o1r00XFOjKIrsJyOwU8YHyKDw71uLvDjfI/3tqGpJByJVGMRcIEYoQwqrfkEPltuU7bZGYp/gcy24na4erzPKK5sb8Epvos64sI20fXCE2YQZlF9tSi4IPL1FnLveH8pv1JqY9Y2A8ID5oxxp01GslpuYPalI7gHGZFdjhoERpDKwiTiyN/99a5CP9dBAMQ3Y3AsizJX0Dp6fhDQhxy/qgjis7R9EANRGz0Lkn8NMEl203pYuS2/elDm+XqXtGtwIrGOyTfF3ekbMzKVgByZw5hJujQGDuj2uG4RmKK/jXeagocAFY53kmtqGnhqe4YZvO/IYDJiJoHsBp4ci2/GeL+FKHIxxXlD2LQCP/5CuFf9N1rXRYBVulnkVaQzCLJMNPCth6gGk8Zu6q4ymKy3/JwmB2NrJGf6XS9f5DizsbgIsdAq+HfA+AI8S8ChPNtLfEq0yWh1szKQugiMCrs62pGlSfWSAiDcvbVMSBP0pfUCFlfhwrik7zKRPlCbCKIOGkGx6Khfvx5+g5n9IteSUdc/uaauZ8EWGbWY30SXyWYoN09+XaoI+5eo0t3CRhYz9qe9IAgIPHvPsHRgiIsLFH+iM6hGQdIWyUmbkhLQwXOBmVq8d3YTVW+55qvTT1QQIQ6nfouFQT0Ow3cM/vOWMCAWb8sXFpNXLPo1GnUs+ce0/46g7JaiaMTL7Gz6/sLYNOBpbqA15A4oZst7czpgxCAuDm+maWg
 tkgXg+Rk
 ahsRrDS60/oqdaGLNcvc9zDBcYOPm/9GmHOMMWJ9qxx/LxosrcpYlCMsxGDLwDQj0x659cxJhzJ9S55jeUVX3Y48QviXUYfsXiTmtCuEbsaBOG5JVSus4Sj3TDPhSRTDU4BEpXA4OzxiiJjcZk7ILJODGEREtA8uYmtr246asjCmc5s1RuQZ2uwTo4RYu3RGb0TtrkKgNVTX5NcEFuIWU3TNtxmAtWxc0ZXeDyTSBqLwlI1L6ID1Kf6iYK5MAAQrHJH2VBNT+K8YWgVKkLJCS1BwOPIxHezdChEbcU4eq92KMVnfE+NMhbZcNoqR34Nhml9mjDwYytp8u2SomodYFaro3hGicFjlRnk4y0S8E7FJn/zp6e0SaeH2xIK4P1CxVaxhCndNc10iY0052GCoBRRZrgH771LcjVIeRxJlq8DA4dss8OcRxNHWgG96GcNvE2BBvHWYewAopwTL/A22lE0BVNNAx0LN4FJ7tbDTVszZEJ06vzYi6MPUFV7I20Ityab3va846Hfj2WYT/TopKwh9DqVkWZx90j2q1UWUVlTC10hnhq4y6V2zl7KnoehhnHlM7cI6Vy5H0ZAsbkV5rh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> With __install_special_mapping() moved to vma.c, vma_set_range() can be
> made into a static function there and is now completely isolated from the
> rest of mm.

Pedantic nit: it was already "static", but in a .h file
Yeah it was also "inline" but that's not the important part of this change.

So I'd say it was rather moved to vma.c, but you can ignore this nit if you
want.

> While we're here, we can also remove the insert_vm_struct() declaration
> from mm.h - the function is implemented in vma.c and already declared in
> vma.h, and has no users outside of mm.
> 
> Also update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mm.h         | 1 -
>  mm/internal.h              | 9 ---------
>  mm/vma.c                   | 8 ++++++++
>  tools/testing/vma/shared.c | 9 ---------
>  tools/testing/vma/shared.h | 5 -----
>  5 files changed, 8 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3d69b597b9b1..762313b47301 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4130,7 +4130,6 @@ void anon_rmap_tree_verify(struct anon_vma_chain *avc);
>  
>  /* mmap.c */
>  extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
> -extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
>  extern void exit_mmap(struct mm_struct *);
>  bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
>  				 unsigned long addr, bool write);
> diff --git a/mm/internal.h b/mm/internal.h
> index 01a762bcc2b2..2c650d280e90 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1540,15 +1540,6 @@ extern bool mirrored_kernelcore;
>  bool memblock_has_mirror(void);
>  void memblock_free_all(void);
>  
> -static __always_inline void vma_set_range(struct vm_area_struct *vma,
> -					  unsigned long start, unsigned long end,
> -					  pgoff_t pgoff)
> -{
> -	vma->vm_start = start;
> -	vma->vm_end = end;
> -	vma->vm_pgoff = pgoff;
> -}
> -
>  static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
>  {
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index 5308aa5a8c91..cc0e449ad0be 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -70,6 +70,14 @@ struct mmap_state {
>  		.state = VMA_MERGE_START,				\
>  	}
>  
> +static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
> +			  unsigned long end, pgoff_t pgoff)
> +{
> +	vma->vm_start = start;
> +	vma->vm_end = end;
> +	vma->vm_pgoff = pgoff;
> +}
> +
>  /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
>  static bool vma_is_fork_child(struct vm_area_struct *vma)
>  {
> diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
> index 2565a5aecb80..bea9ea6db02a 100644
> --- a/tools/testing/vma/shared.c
> +++ b/tools/testing/vma/shared.c
> @@ -120,12 +120,3 @@ unsigned long rlimit(unsigned int limit)
>  {
>  	return (unsigned long)-1;
>  }
> -
> -void vma_set_range(struct vm_area_struct *vma,
> -		   unsigned long start, unsigned long end,
> -		   pgoff_t pgoff)
> -{
> -	vma->vm_start = start;
> -	vma->vm_end = end;
> -	vma->vm_pgoff = pgoff;
> -}
> diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
> index 8b9e3b11c3cb..ca4f1238f1c7 100644
> --- a/tools/testing/vma/shared.h
> +++ b/tools/testing/vma/shared.h
> @@ -125,8 +125,3 @@ void __vma_set_dummy_anon_vma(struct vm_area_struct *vma,
>  /* Provide a simple dummy VMA/anon_vma dummy setup for testing. */
>  void vma_set_dummy_anon_vma(struct vm_area_struct *vma,
>  			    struct anon_vma_chain *avc);
> -
> -/* Helper function to specify a VMA's range. */
> -void vma_set_range(struct vm_area_struct *vma,
> -		   unsigned long start, unsigned long end,
> -		   pgoff_t pgoff);
> 


