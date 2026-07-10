Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419DEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CB96B00A6; Fri, 10 Jul 2026 16:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C116B00A9; Fri, 10 Jul 2026 16:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115966B00AA; Fri, 10 Jul 2026 16:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA8036B00A6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:22:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68977C3BB8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:12 +0000 (UTC)
X-FDA: 84973988904.22.615676A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A896F140004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YNDixLET;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp2XcEzmrsUMsE6Z8vlg0yAD1+XKOgCHxsSBkhx0qCg=;
	b=fzHQxArHEaX+Ef3t094tQl1a2S75KcCncdWO9FQ0J234L9BK2Bz6iykhkgtDaPR5btU7av
	w+eJemp8S1XiRy69nikaRaC+EpuIBxb4PogufaHw2DEVH4PFK/6rjZ3OS7/xhiWm4J0YbG
	is2d2JDnZAT2kmI2pk1efq2LWrWquk0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YNDixLET;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714930;
	b=hD7KCUweib/ZAPtcHAXJmcXtFRG18rTnigd6k7E4CHWfbuWo0ykJ8BWpcrxU4DGz9Ry+9w
	glUEG2vYUXIG+JV3tNltpUCcQBktUKoi0B5KuOI+weaDf0PDZkn/b7DWa8konYWk6Mvx0F
	o1rY+9WSaTl6PaJMwj5eEHS4gIGmRiQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AF3D60051;
	Fri, 10 Jul 2026 20:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161461F000E9;
	Fri, 10 Jul 2026 20:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714929;
	bh=mp2XcEzmrsUMsE6Z8vlg0yAD1+XKOgCHxsSBkhx0qCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YNDixLETTihnC81MSj5vI2w82St/z2bpWmYfKR8ywUGWm3Jp3GYvqd7wjfiVfTRbg
	 J4IfC7fCrwanGf6IJfkBZoOzbWd5REyZOciwm+c+SNLmMSkNXr9JC6qBv7H5tO6MlJ
	 XLpER1fSQILJDtWnNEHpFgaEaCQjFjRgc57TuNj+cVvkEcW55HnugAjEYQRCVU4Sn8
	 lrJn3V6v4WujodJw3PNzBE6sug/YLghVyz4gNrEl98e/IZkI9SyBn7OYmnBLAraswy
	 RRmsSaDGg2eFi7Dr/+iUd6PPljAxeHSxrN/6w5OIhDkKLEDsrKLlceKXQkUDBzcxxx
	 I2w5Kwx8etXxw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:53 +0100
Subject: [PATCH v2 12/33] MAINTAINERS: Move mm/interval_tree.c to rmap
 section
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
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
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
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
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=909; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mLgNYeeooTfeSgODnN2j9KxYGDmFa4rlCkKK11Bijx0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg62b0rarxqkEWXU1vhHT+ft4/uldajUyJw9vXaP5a
 L3kyaT/HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIuxrD/0qvjxoNTUff7Xl0
 ND5tn1zYsuAJxRs7+ez43wsU8Sldfs7I8OLfR6m7kr8nLuTfXF7/67wLy+JVk03/vGQyPpKWZui
 gxg8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: rf8gxdub5t5hdyamc5d38z4dzrja15dn
X-Rspamd-Queue-Id: A896F140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783714930-861005
X-HE-Meta: U2FsdGVkX19udK9d+5OoYzo6OKiI8ME1QtvBFkcskwSsjiPFS1BMBmwzSs3YWwH2hZtB/oIo/NFtyXxTsmXcqR/oCRUf/Wql2YqSIOlHJKwzP3CZs4GzAm0koDkHxbYVlM028OmLN5DxwFJdw70kns9tlvoPJoS6AcNZLeeEbGMmmp4hPPjdwoUBCMNKBaRSG7yMfHHRq8tuESYlL5HKAa7R8htSvO6CCvF6JvEi5VofeNBVWBosx6yu8jyGfCUtoET2p6PSDXHk+YtFVVABeyC4hXs3SAqYbXYZDTBpJLu3DPb6Q5RW4YmG9E4YYQgc/rlLlSqP5jtJmnDD3BBLQS5x72iT5poA6GIhiCZIfCarhhcJw5Ua+p1IyaKfoYRVk+wnz+2zjKASB8AwVcwfSg4KEROQmTkLdDH3nJy/nfNfAgt8ih5ncFdROAkd/3mCFbBMq91RlrEmjSnxfLcTKkB7R0T/g+eRtYY47Balm9XS/ZNYJ82vs4qlo1UOxMspDo2iRKf6rIkMTCt/dnxSYdfq37WfCXG7b5btmQbUIrY4+G1lwcZdLyHhfqTC8154qCCV0MCYB0/3e8bcMmlgxw9tNA9MNKO9MF3Abj2hMMBBHWPXb3r1OqxqKDqBzNMkbqsxXixsI/eElMgOezXyVH/DbFbu7RtQv4h3X3zUnnFKCTzJjl/TVNaaybTVVPR4YYDXxCIZ8LxqUj6xBzwOuUc1pnrK7+EIoPxIWrN+FVtavMn8MssZU1O8VSRVYGJ/4aTcudVXNvMFWL2l+odFsVdotkjHjGIvLmrTLcIS/hvJscczZUBorDLeGxBqyu2zvkPhiihAM0sjdkv61zdL6EfaKvPW9PyILfPllmQ95sVKRLwaKreky9T3PyKh08N7ovgCW71UWy3J1LcV1eW4erIoDrER3OTyoAm3Ohg0q9mjlTfrT6kvehMFYXbZmsenVusN81gNSzoeCYCI/a/
 3a0zl6EH
 plIwnCDnnd1R9tyx5q63ZcuncvRcWso010YIB7mkJJpx3lLw0BTKTjJ1EGRqsA8S87RniJy5q7QicQh9Ggx7av65pz6jk0mCapYwmXoqNaKawmwFDXRhh6B3krg4Girz0BT/PvxjUf5SLi7ZixR3hEbnRCevMrEPTQMYhCz7QM2VR7d1/dBAebbfNRMYaxiWbzqzv7HJxTFiewR+UddNWVEC4kO0XmAU9YZxkIULoZGH04sLO6dxVhuxt++xAyIpyLRWLPC/gpNu4hwZr5+mWJfqwR+qmVqFoeFmqDQBGUz5OGwjOa5DilxilrQ1yMk3uO1f6kLg0vTRVPAZI/0QQU745MYZw8+Gmr1i4wDu9OViAwqheZf4W/orhQsvUPsx8npTR90RtJiKNFQPgiJzktbr4PmdkQMgdTfjCXT+UlmILjT0stvqKnsg/yziBG1UDOV8YvIk+PQWQjEfcXLsCjbAHdoRTW5xaT/Z/TnFVMW+NI3FcH3E1tESVELpNgLLmMuzccoLHmchqe6Bu+zrSjcj+e6i8veT//xJWPEFjycYVn/i/AevgAFiZds0VllaV33p8mpWcl9yclkARGpPlJWmGzGXxPKkQG0hQQFR/C8+sohbxNG4NAMNQ1MzAbfwvf6DJhkeJb5xyrNLbRnOw+9eMq4f4Z7Cwufkk4oLGq1NbTxVU3EOq5+ndiVPkW/q0cQzYSuN932jyvEZ05dow9JyKe1B5IV8NHYY3xZzYuTQjNlIKrfjZ/ceSw8WDKYUG2mULGX6iaMJSoxTPQsOeMkZ1O1Wmti85JIyF1NE5cAK8on9ZqrYN6extEOu8L3kiySAcLh6efGeYYK3pho34F5XOk6SWPPEUkWQ6VRDGifIMjp+bao80qeveYHj4usZ9uAazFNbAwcWuShT3H0MOo6NM70syyLE9rp6IOm/wOXf9ktKxvIO3rjrGN/dnaZpSQ4ytubZT2RtWjJWSLr3bOfUcwle7
 ksKbFcUx
 IJtsGWW4+wWgNDqXAr7siZztuG5MAftUypJGM0MtPnUqO7pOC38skD9wO6QPlYNE/gyylMm1ktRka1IAKgTv6fROH0pGpEI6E/EQ7wNt0cVK7YlD6oZ4s3QH6ftcRc+e1FLjBqGDWm+ENLT7H2d8H4wC5uWyxQZ8yiFrKZGIU4nbSxI0ms04BFJcX0/PBDyGIysi6J0965FE725HEVBVZhRMg/nX5bW1DvNfAhp/mNIrTl0O85kiLX/mNmpiC2ITeTSj+ji5oa0rJ2n56A0Hl7q+sbFUk+3kbkpxsrTizVpvH9Y7v5o33pSi3cZNpNsV47Abz1xZdhnziyKNcfrcrx1CslkeDs9S4axUBI017HexFJmnvjcyQyEjhFwMfJ1+Kc5j+0Vv7DNQ8k3ktuaejPfyVVRl0RosVg8+wauNrrbjEMI/vBUDCvELxW3YJEIPAx2aBvJ9uRAhhLFLVRd5W4BeDCrUTKvedzszYzGp9/TM+wqpnKollmbrxi36PgPJJCygvwNSaT76MlHI54xkQGpXRryI/0GRtpNtduMOMxyhogfkSCTW+X8+/TSOkp9N/4uqyPTaQflG1LncUWxR8qmqBc+EaePxEQnhR4UL+GS3XaeMRr1UO1i9Xl+kYI+N9X4ExARJcQ3+HzWKpsZ7/MiUt4nFc6yVpq3HITVIJPvTR34c4UG+WGsDI49iVpLhmk4Rp5spIye41DudMVqkXeOijJVSgUlp5W0/Cy20hImzNH0ESpcxhqaQ6kkCLzXAzX/JNam/7g6xL8JWgib56JA0GBSQv6R8Kd6maaXJiEeCMt+RXTgGOFI1hxKtUnGGIsaa5go/mktbcqNNeye6CsPigAmcrDzySMlPTcbw4j1T5wzuxXadFCscijrDJEwhfm/F3+P/ggxyn24ALJ2Vvs6wltwQIDJ3y8fNAUZLs2KKBvxFitd+knYDq23u4X2wxpD0uFCJqAQnYNnFrHd+QD8xPf+sJ
 oHZSttuX
 ieuJ2E/Uz1p2pdyYTpfLMNJ3u3hrK2gi2qu49wFfkgcF+Q7dFK6/zk3F/Tc3CFfCdK+EkjU8DIeYXFpnQ801y5cH2Vq1o8kS7O9qE5esJ+Sj99FNIj2AZhKRDVgyrEh3nbGoFzG5AkH9eMUPCuAyZ1QJv/O05QmsCK7/JTmjmBW5Ck3tWoH7naShViskC2nvo5+6zb1/ROgddr45q5kqVTPN8Bon91VySw86ONF/0TitppYe9pG0a0ApkanKHOlQyfP5qLKYr7y/4XAp1R0moo5ccAVoO3Fn7SgZ8jtCEdqszzKo8K64TAFuVFqySwQI3lXZA9uJxno1oRkGNt9b1X2fzfx4nrc82J4OOmayhx8+QgnYiFo4wgE8xX57pAaF1nIXnLG4isQj6L6h8njSM1YChcov7Emse8+sOYFHTbGqQKph6ZB/+Fmp1SJroUrtfsu4mqYUVA9j+L1bjmrgGeZ1PdOS8Gxqlh2Al0KFQkEdtkbgOhbZxnmLEPBwkIG8X5wKtrsCeOvWmk7zbBnSfOw6DSO7AHEtbxk4moUyb/eMhO9cD9oksIr9XIN2CkF9uHnURboXDXVyyB3ZrX1CxdwdrMzuuWWp//kO5sAk3WbSe2+7qxc7wf0/0GWaFWeohc5CM6X5ZxmF5X5gnGgQISrduMJQ0vw6FTkqCEceDi+POa5GW9GVwODrbFO6PsA0Flsfxm2NnG14NlIXcxBmAwPnk/WVaIf9hYWn9q83VldAVXstxvx1dse7THK2NP4xuBfm08EzH5gGr7oz4u0UhP3te4P+bt2ey2HNW8iSRry0WJktcXQRdz0h69d9vNYmN1o0p1u1mJhTtekpYCg49GuETDUyQbesIhk/Akxk3n5vv5VbFxIGckT/ZqBMASCcX5bxvvLrztrtZEKFMVRlY+rt8caAGW4X/ee7KBkGow/bA/CcnFkFkUBvxLYOf21V0fTAVbZUoZafTC1Ckf0iTwzWZ20yd
 p/rT/3Q7
 Q5xn1yFycetM2K7NT/kxk8b1OccL7EIpJQxAftaJf/pwlv/4IORPk74Kxy7KM0qIuLa7AbRBeWk8R4Iv9MzUErO/CtzsYabQW7Z9nlczzJPtTtx0hM/xXmWQH7bfTcDEYZAn67gNP5s/w3pbKi6thHlnI4tpq2g3nLYw/OvpWKNQvbGLX5U4HqrB+ff/26IaKRXY4vWtSG0IoXcR291HE9UK9uMrKAESAKj1X5kG6VnCyunfFmdQBVr17o5VIAYNI/hb4rcRu3HIM42xAEpDNsPNxY4RibdIlTi8lzGMWlVtr5bN+7DbTh3+1xrpU7/xbfN82zl+UvPWSN93ZjhluHDlhmIHn9v5Zhxe0/IGvM2whkhEOKBds4ICoXtJcg4YsVH1lzEtKVCeTCiqbwbUcDFl/BFdhrw3TJW+4q9nHTmXVsGzWfL/aVfTDf24LyUBRilDL2+PMqJ+ZIVd3CUXBv56j/h7tI64JQzuRUmMudX7PHYrwvT5AuTX9cq3IJbBSuNeEP8aqDvaTgrlhMBdOv8MKVPB/nro7e4GDygPA1Cbu/XAxw0P8z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This file implements code for the interval trees used by the file and anon
rmap implementation, so belongs in the rmap section.

Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3e535ca4bef..ef168b583325 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17208,6 +17208,7 @@ R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	mm/interval_tree.c
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
 F:	tools/testing/selftests/mm/rmap.c
@@ -17313,7 +17314,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
-F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c

-- 
2.55.0


