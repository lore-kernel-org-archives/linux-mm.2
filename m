Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A0BC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742C96B0098; Wed, 15 Jul 2026 13:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4656B0099; Wed, 15 Jul 2026 13:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5DF6B009B; Wed, 15 Jul 2026 13:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 251236B0098
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:31:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB531A025E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:31:02 +0000 (UTC)
X-FDA: 84991701564.16.28FAD3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C85751C0010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:31:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJ2vIVoB;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784136660;
	b=bJqYYykIoQeitnJE+xrgDU72qB5jnv55B06PaDizR88S8+RrD82iJ8NvcWQFf1AlJpekx3
	6m3HEDOmRF+Oo79G5Zy+57n1gmTqAKeWm/LdHkYXQE6U/Z2hxrCbtYXisOwfo/q/m4Qpn7
	3mE/C2CmlDWWDeiK6sfUrrOn8757I7o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJ2vIVoB;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784136660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mn8oct4HW8vssYVWtxQHphxPwvPDO5eabbxzgczXegY=;
	b=LGK1tdSmrxytCNTabuT4Vbajsha22TDHemwuX+JeX5hWJ3p6G7HAPUVMWTJmMpCmmOQrob
	+CxfV0GFd8uipC2xXmKZBycpAMpa/CUegdpFi+4qcqZSQhvAqhOEcyzuOQsOEb50BYzpJD
	P9ULNTxq2lCCCYybq+W1n54OtoYiZAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B99E042B72;
	Wed, 15 Jul 2026 17:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14401F000E9;
	Wed, 15 Jul 2026 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136659;
	bh=Mn8oct4HW8vssYVWtxQHphxPwvPDO5eabbxzgczXegY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NJ2vIVoBzjUtT4ioB4s1p+a4H+WhbDamfXKkdQ2iDI05seVhaT+i00hofCw0+HIAn
	 ksJLqEMik4pOD8dVwbbp/F2grlpq2DvNIuariG0w7Rt+V0mmQs31uuMLyBAsqi0bep
	 VhNbafEZ6cQ+3rIw91s7rGhAyry1PRjmuQSLU6T7GA2xX2BzFJKpAAnO+sYjmpyUqT
	 8Fzi449V9qcI1dEXKzQhmyILoG9bPx9uEy9ZFMXObYKvJqxUHo6z4bL4Z5IkQIPWKH
	 xk5jDrhlLlnX5DEolBMp7Jw99VvCPM+M6IFE/K8XZj8+X9t3a4O8J6QIA+jKulrtnv
	 vCRrWw9gTvsDw==
Message-ID: <0925897e-1a19-4e7e-84bd-43bcd2310a49@kernel.org>
Date: Wed, 15 Jul 2026 19:30:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 21/33] mm: use linear_page_[index, delta]()
 consistently
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
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>,
 Kai Huang <kai.huang@intel.com>, Ackerley Tng <ackerleytng@google.com>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-21-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-21-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C85751C0010
X-Stat-Signature: e6q5t8ophupdjkhzikjjq1385e5qbkzp
X-HE-Tag: 1784136660-769516
X-HE-Meta: U2FsdGVkX1+6qK8ibUPFDVaZDahNLBtZVhWOSCSnqwRpVKkl6hxvDqp7YkAQpokCZez8e+H0Slq6sshpBgNJ2PlfbA9wSmPkUzSzssZ6y8z0fCF0vYh0QniIet5mcufR6Y9Cip/816CYgAeexaBilDc7hvUmHRkq9D2mssO2qn9GyOdlJBjmeeNLrBaLcIb93WDbnekySKWfHuCGVVip38jvopfh7hKLP5VTJ1UTa/1Fr2SKhj1m5OmTdxm/EP1424C8NcioUVituDkGH1rpaJ0CntPcXCizI4EgxKmGI5cxXfj9hlgMTJZhyIh6W49G4A8P8VFJYSND+8H7CG0hORq2EtS+7/9KrytQLrF+Zky0yNKVULknjKlnUxwhAe+sxbaVV3NpK7+/5RfJ8AP2DyTqyEjx3eyHZ13fDXRmSLt2OX1HueD80UlNsPj1vOp6Sx+N9gV5cuNrix5mMkOLPsVxz9FRZl5Xrzpym0YXBVZM6oUWP9AcYuH8w9Qh2dSSA/zLMxRg/rNxz22KPcr3ZqFqeVRcpsNf5euYYTv4cEQhgNmkzpKAxG5l4QuUtRX/NjINJdWuAmpjE0MZhchKJIJb2mvn5S1VyeYDuRnH3eFX+vr4W1kAS/hAAFLCWcKPvn0BTcmibGsdRai9xhxZsM/NpcgftwrOpz+RrZ7ECjUqeg+HphRxmRCx93ZAqNwfLuxWXPeSv7Nh1leIanboQ948BnC+x7OICmht3F8IQklViwn0ztlvjB+A1DYPbPC/nDgG3j82p/oHoeQgCQPP+yyCKKWhaeVclYa2vdLld+yYAH8mMY0MoQquM384aAqU9tdvR1vfJIqsdcg2L2moAvcXo3iIMMwnWgPZlzvSCKdmW5sHgkWJnDWHex7gBj9lHeE/S33jma2crpwxQ/I1y2sDfPshd7Cvy45sySpjVSrmdVr4Qgt4B0pHiZ47fAaIG7Kx3iKl5AbyKnW1fmf
 87flUSpx
 zoMskG1mu1dsvpZFQZUPRiwAN9PBdRcPQWpAkNy2IhMXMDZIhFv7sLh+/LUHWykJzYYSpGJ5G42i1BfJ5odfGf8VOow4vbJk0egE5sTSfSSRLJE4gRn/1RJGJIDH4frUTTFf/tAgux03WTp7Vd2pXsrBbhYvGjamFr81U+PSINo3IrYDpwborlHCGazpFnuMq3rovQKegpd7/XaqvQTmQTRniIIQsN+s9NsVa/RnzFTgZPPfXKWNDG+Pa8o0YdCLxhG2EeOwX40XjwpTvLMIJJbQStUFYbVZL/TakHtpfGH+SIZHSsQLLwNkrdb+r08MG2ynjnsJtLh/mdHUR/kB99a7de9zn9cij5R0nzrQNMWvqETbg4GI+rn2ymrc061Q2iGc4df9c6Ib9gYf4dFP/vrx+pk3DSY3MDo0bs8UcfpQusc5lvv1vrAoGHNoUaB443/hWSlKNZOGZ84uai1TGC5ruBxdyzKCEtDpQzFYq120m3cgBO+2q1isqDEkO4lGHQpiGEbHnJyU3jxV67Cliyd4kD5ENZJEx3LKO4QapzL6UX6yimHd83BZAYtpaanT4r9F3Pm/b+RgwMeYVeYH01O74dR4XmcwBI/e+uNHhB6xEQJkeX/Ak/cHyXxsieo1foezGzkZ5mV+G7oOca4qf6nJhw1g2XOh3qmGY/om8v1RoxW3gPPfUL2vf3WQutgeGmBSrONPjRVcHj/bRGVQG6Nf7XJR+9X7zDqJL3YDDoKN3HCwfMR04Iwr/VDj78Z8/NQ4JDZNyZT7+uDmMTm7u4oWxtyoybPjOg27D2s748oLui0fihwnepFy9Mbi+TNkw7zqZGb5Jy7wjaH0JW3Nw2ATKqrhZ1FlD2apvid3QYb43atzqMNFkoZEJzUdv4gFqVMVH5lHDXRAGNuYlQvUpvV9D89ehOhpDS57JNLJC8tuMGGtR7WBVoLNUuWoibky6XBX3PJat6QM6Oym7rQny7ISCrRjx
 5WMU9tRr
 ER1G7FDqYbsRhWJ0b0IZzn3Hwx4yZi0qhKIO+0vhSwZ+Bj0btiXtbt+JmVmvAb21wsgHrPHUVsuFi6xOpvj3Gh4S9+6bOVH/v+KMJTz4jdsyVbtomqkXlNx/ZcSMUNxlk0jPIC5C+huQVzcNcn2xl0Us16s0z4lH4gwJPOqoD6oSfPGFJVdHD1Gnwya9hpIEm4jp/i0EhvUE5f2mEsJUvwFrWI7x0pW1qbjGSpiwV/cvZgmUAJbld8nF3BDCWPoaQzbCK9+qA7SA23cTBeUSBB0BBzJYdYtUOg+6uvFAQ/aOFRrmAFobmI8YiF6xa7s6aBIvrD9UxnvRpkhRRtaeZlXvVpIadSbyDNhsU/DY9Ie80vMuNPnCb8qZXUCu0zgoarR9OkhXknVekmnDa9ysL2PeTz0HRfFRKqQ+Pdp19pU/onFOBARFUbqNf0RzN7W7vBr+az0jvg6kiTbrT6kFQJ7+Vl6NbgyKHfCGEneloKAzOwNTOMnbi3x6eWT742T+KQWjP7ww68srJG089QyBYKApmah62eYGGxaziAm+WEJ0H8b85+0tZPurOpPw4VNik4JrByhvSxQU9D4rheJdQ78YZ7ya70oEx429c84JwCqfgGK30u76pmfUQWxEQRsBE0rjW6FH53U8DqHG4cTVcZyINn+lOgP9i1jUfSZ4oEdX0qQFBI967UH1sLYYMeTDamNt1JFHnToT4T2xsfvYqVDFbX9rFKuZIW9cGClvZALKz+upLks2AcPD9NAGBvQITm8GqMhGWt3avLho6sgdcy/IVGjGvmPo+L4dajEAvQFLG7VdXVW3aC2aBf/WILO22MhzbgurxjHFmWIE83vl6Qw2Mk6KCyl/T9Y7u3zGUIFCLC2Np4UZNhZX7P3zTV/G89TStbGX8A0ee8wzse244HRtKAIyFL3qz0+OdUFwIQzLYKbZdSCoSwR2BhQK/Q9JII9sDKQMlay4FBOK13Md1HnMWuhbd
 5ipB7N40
 V+I+W0pwIowo9Q8X04FqBMXkA12HrBZyQAl9dNujxUHY6UKWSaWklRugm6e3E2VSHr7kRDR71u1Quk5MBGxprxphp2srME0DJeYPOxl6vGHRW6zafeVC6bTXw4GCI8quNkBz1CyeZTSv8gLR1DnSFDXF3MjgsEr2onJC01wfKqyTbw05MYagQ05rfN8DKm8SJk1VDetWm1Lp4BbiWgNbxud/12jkdgfRdBzv5tPNKv93dEWgqErX4lYxckNjAYrH7iNgFdemCAIiFFYJ6sX+ASbYP4Y6V1xWYePLPkKOqQxMGJkmMfLNl1iHKzD6rpLVEmBDb3zOk5hS6qyzCFG7LJ6c/yfyNxVHBLTORUe+fTFAdXur7myiy9S7IhUblHzMIErvb6JUbvEcsI9gmZjyT+jj2FQr8XshYU9ux0scQz+DHXCrTDjl5fXBx02/DR4jGcaL2Y/BS/dKJ66woAxoAeXJhSItWy5AjX9i+ky6PKiG4vxmWrc14dFPFbIzu2EsMGGvTxjzY1ZMdKosRerNjP+Wmg1s6XvbRCf0ocrCuWtMoE1hTrSVfSn+umBFV4HTSmGCOaVj/o0FVqH4LKYlSi9QjaMrxbcbGZONFb8MrYuWpjTnt9nTdvJO9kqvCz/QfUqFBYObXAeBviRNEiu/lw6Xi21fXruax1uRyHC5VUtXaF8PA/2aRfI8Q1NhbNDK11wlGxea5Xf6lQJfjCXx3+1Mui+vBhGqZO2kNGDMaJJKUBm4aMXZWuzvC2Iy9e/IK8ABgXg3Fk+mvUj1IXr1WM0SuBg1aNq5FXGHrDb41nxDBxg3QQiYLwikymwfgvgSeOA39LtsNCFDPimAjjXBCcy7zlon7zlMMMU1jMfGTdrgIjtYZTeckslo0wFzV9mQEZ6+GRTPvb6wM6dbQuklitwl6w5LlHKcFbidvt1gyvMLf5IjxoQaz2qzIOfsVvNpi5T+fN0MmxFL8LRIQiqEJ7nkiI4AB
 3X6483Dp
 PHKNAvnX64JEeuFWMtx3xnBYqa/C5I316/ttZXMCYgHm31NU3AZIeEhzYR9bC7skaFYRKYdowfTdAUHbqBFITuUI5v9kFumhCUVJSWPF9fGLuBh432naziGLde7TxmosEuBYGiC0oRCbvSdx8QwbpsJsQ64l5UuJJqh3tPZoVirMMNYbZwMJER0UBo4d80GqZo0rnAORu/43D0oO+pBdeY2cOBhqcpgO63smdxAdPDM5em9l/Tkox6asK9hGIccWDZk2aTwKZzQNOwn+iNg/N0wdQzo3H+t0uLqV1+wHDVxN0pAdTUqEcoLAuP4n8Ijloop1ivTlGdTgCzGbwqzVSgMUIQ/K+xjbBJlCRIzJtJrD20XAJqgv3uQzRT9YiZFCN9UoHS2OPoTlKrXweWRgrbZGij3xtdu+pH7o8sbWyg2geg3e5Abt4AcL/AchhtThclbr8GQg8R9Wp7UHgatsAkK0Bin2ITU772sePakJS7C290lcBkx3ycCMUWDDCFkiITeMHtsQr2MvTUUuNEN/f0HLjq7OBS+c7dPFu3pkcgvvpcaLJMHGWo6OwoGlKk+e8/1tdmpnLLYSNQM0MhJQxGFXaXK5HHccjDdKgOHE5B/eH/aGRsAVxFtS2lsSLRgh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> There are a number of places where we open code what linear_page_index()
> and linear_page_delta() calculate.
> 
> Replace this code with the appropriate functions for consistency.
> 
> No functional change intended.
> 
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de> # for DRM
> Acked-by: Kai Huang <kai.huang@intel.com> # for sgx
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de> # for mm
> Reviewed-by: Ackerley Tng <ackerleytng@google.com> # for guest_memfd
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


