Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0591C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E826B0092; Fri, 10 Jul 2026 16:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF256B0093; Fri, 10 Jul 2026 16:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB76D6B0095; Fri, 10 Jul 2026 16:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABE9C6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:18:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A78C1A0570
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:18:44 +0000 (UTC)
X-FDA: 84973980168.03.EA8A8AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7988F1C0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:18:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ut/jbAuZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmdsrY2tdwYxD0uvAcRTlLh9YiiTJVFUYVkIaWXdB+I=;
	b=MX7dsfM7hLlsxEQtqAf36jFf1eVG7L+XDfRoI5kXqf4knUK8tbJbNwj7i5zjSnaRoWUeNY
	ooz477Ugqn0RZD8MsIi1SzGM30OEfwHgLFstRW3S1FNbJ4O3qgK3hbRPqNgoav5tI1WPgI
	cv57q3Xu69Wd/IanwLEbkgWaNS7/O4k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ut/jbAuZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714722;
	b=DWlLwRtUUcLS9MYKoOq4+LZdFjqE8ByuqlZpKd64zLk8ouNSvvSUg3oTKKL5BuICSVqocp
	QPO75HVVZ+1NrM7DTicu0+65zoQrrXhGzM6X5krTaf24QrP6cn72UDGOuz/PsqzLThxPrZ
	3kd0fs3AtSXIMMuIC1QK88ZsX/sCwcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B89960052;
	Fri, 10 Jul 2026 20:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9B41F00A3A;
	Fri, 10 Jul 2026 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714721;
	bh=PmdsrY2tdwYxD0uvAcRTlLh9YiiTJVFUYVkIaWXdB+I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ut/jbAuZXYxfsPHDRbFG6AeYVoHfsMIi4RxevO30ikC2cXs/E8agujTPs3qJUINSg
	 yYDdGP7J0SUmvYO63kOXh2z/L9hG8u5g7MHtuW0YfER/BpjKuMhgXjexnNCzjcv/ln
	 VnOAWV3uW7KoliqwsBges9xe2WqrPKliwA294ZBCxF0pXsvujILvisVfI7ekVXl+EQ
	 Z2s6qaiaghbmUvgw07AZmPOxnbKWpytV69wR0saxrOc2Rtxox2KidC0z+lYmGeWkh9
	 094VrJuJl2I4KGfxsnR1HSxyrqtLTIeJ/4bX4EPZkK7JTF7PwBAkviNWxcolJMEFWF
	 hI700zBKOBohA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:44 +0100
Subject: [PATCH v2 03/33] tools/testing/vma: use vma_start_pgoff() in merge
 tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-3-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7049; i=ljs@kernel.org;
 h=from:subject:message-id; bh=t8dkzQqXmue3OqugoX734wBWe/TkjwvXfzJD/QIoxFA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg60Snb1XWu/ZYcRmVV06yVxlXtOPOQLHsuzTDvwLt
 yq10sjrKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwESaLBkZ9s649GV6ldT5BxJc
 1YF6TBY8E/jEUizPnmstcdBz/6jezfDfzcbaj0+/8kRMRdoSdrul2w5n/Hq/MWp76LXfnyWfbFv
 ACAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7988F1C0009
X-Stat-Signature: oqjbdtga4jkz4gst1djugdp36txseru3
X-Rspam-User: 
X-HE-Tag: 1783714722-892127
X-HE-Meta: U2FsdGVkX18CPBsZFKkeyfMGCyrLJsJlwxzyXGeg6pZ48kFfNiSi7cPJifOfJDdN56Wxnggisu+Qlvx6I28CGoOZDYUgaBufJRaCtMiE7GToyYTfnirvoI5aidVrEUuK4DGZjtmnvNppoRYYw9pT6JmVrMwFkMk7ag5lPcyhdjCUIliY9eZW1YBLz4EWCy1s50Wr9dfrWUuA58XVIS06HbsHKImGzhkE8FeCiQJbEsgwAT7dk7z2GkFbosGqveYmUGpq2dQ7fEhwh0i0OzwR428Ix7p8JIBZ8cLLZWINE8ILGNi+7p1i54fq9IL8X2+YgNzdWYem4cJRaalUJNDz0VbR+d8iNsGcFIO8mol9la0BEs2kkUjZGKlit5FFRNprqOsKIyvhV1bnzca/gV0tmW+l8JLMn5B7q6pDaDO+dTlMDnKwlSl4Ar06nbJdY/mLx9Ay8odTwA38fIMIswck733U0hRPZLEgz9plC220rph2KKDvcVNVnoXNZmNQAoJ09Uxy1oAaNrj8zomw8bjLVsGSXN9kjkhamH3nmNVWs705Gqtla/AWzRO6Su+VC/zD0vxqc4QC+pDoVzmjosN+8W7xAGifKtQGPdnfZDuZAx8qemTt6qOuQn2HBOgn4kHRnt6s7K+vb0kY37tbzBd3bbR5VWyyOOjWhdFtXdptWu5xbu6HHSOtlNZm8mCgTTO4zl6mRB7iYdsVk46K0I8N/YAvGUJWShEF6AEv/RmIynnvWp+7cRAUlyImEc7NTxh6goXcvD8b8Quop+DeZxRqobf7KoLiBcrkRcmGedCtD4I7paEsF6pjNJFLDZ6zR4MF2MMi+cvJh7jpUGMgHgvZOwUXpweVFVr9gUosIOolofbF8EIAxpm6LujMhjo/APH/emnVvANBvzjxDP5CgLNi4ICo4MJcwC+3p/0UlOGBghApM/hDi1DOcg8c+yRJ72Qt8/kWPoGI3k30do8STVR
 +R3Su1GT
 VvhTSvht85miaOmw70kXLGN21LE60VxytDfIkrpjYbn0jGt6MQvydNzEYK4yHH9b3UA9ChYsprfTbWkxwvXwm/L6hU24qKku1a2J3HV5ON0/UfPWFkCRgHRYgqaqoGmsfo0TVhozifSnF+3Q7IFy+Hr9TNs/g9iEDeYgLn0p9R6ZWlJaT1iPG0my6RdGTd85Sha9XUTw1TMOXmB7mRwyr0czS8iVjAAwkaJ7fvkR1sxweUZZC+IAENli4oeWdHeoOTIYF5y99ARm8vWapeHqlRFToLdn9NpLHPlkUSKN5w9vq6M6UopGdVMht2Jl7GN42MSfxN9+JBfYFtRpO9/cxc4YwJrrR6r+GLm6yUVfvSF84h/khX0uV7iaAvWAJHGeVDbmFOv5GoKkbiQ/wIxRqCJepAwHL+u7WPUuNghD04ocn1nQl2oFH5xGb15kt4gWElAx4k+EFJI0lL5PeHZ3bcxbmxYQYDvzbNaL+AjTZgu22Cjh+8akgsyE7mvCiku6H/ql+gv1arjrRUnABUci22AhIloK5439lnLj9twly6bF7gU9sfv3CIUYfYq5sBY4Rh2zZsE4keh1QHjjqt/fu5cORGOBvP6yQHDcblnsb33Wnq7s6X7oFXgm8D4xxOzvH8ysA3ohq9SOAuehdUv4wgCLHfCv9MQAc31fkvCGnjvW5VzXH6LZJs7jJ4fNUz2qTYqlU6mUcK0uHMmj+nAuUiJiFEYqzAZd2zJsJ09sEVl4z2PE6GBmc5UkAR8e0gITALwr/4iireRuoA6Ud2PKn9p62mucEqY+X0iBcYoERfdfSw3GhBnxYggEIRdXaLGEWL3I90XbawbYJSeU8tsHPyqRPKyNE3tlnc6++q3JBlGJuIkXvxeH9lgo8DquZuVDLHLtgY58VmxWGY6DKjkGl6dIZDFClYyr7IOIW/IpkCpGOAad2AsgjBLgpi5kt8+v/OMoz9L+GXmd06Xgr2WzMVbN8VOvn
 fHJFQWCA
 KstLNV3y6MnDQCmVmAIB+dNm75CdujmfxG2uLmQHHXhtMngV3lKykFaKnngr/iM/UE6shmFcC3zhTL6y7dPip8XN2G00cedFyAt3zirErpaYz1fbYGArJMgVHuUauCQV8qmZdcuWKjZnV+yLDKxZ7kUD7VR+HfrwTPuQjCpzXCUR8T8AJunxAHbDMeUjcodNNzJw7EG4BZD/eTwS84JRB9/GLRRNwExtIkVKZDffL/DZ5fx0QgE1MTAWccR9u+/sYD12NMP9PswnrOznHLarMYln05G8hlZUAL6Wx7Hgp7ojVdNYqPznjJRyBq3rWTZypVmgoeQzz4eyEVF7IlfFJkLodqlS4ENrZJH9hcNc6hi5rtB3taOSIo/6IQLswyViAjAZSlC+llbEXycNhObte//vy7tD0ZS4VfxrsEjLfsuUdXzGjA841WUrdgTQA+t/OxVuNLKifygQWRlYm2WPtMjhiXf+csrVwxkk7Mt21JU+hKpvYcO+DoMPmZ9xwrhsLIHeAB7YeOWYxG9upR5RmloVuEX0vqSXNHnHQ+1r6fKs/+xeowU/N46mK5w8UjCgCQ0DZJ1VEIo/hJziFW4dWB4f2V8C1N0kxc7saeMioKBhVYo+bAQAiQSYz7e6yPX+XGIybm5EfCN/H7nATMJEohUn6xuep3OI71cOqVhNIGTeju1z/5Lefx30kjLt0tCEgyff1J2hgm7EUg8zj7k2FkW2HbdoOFus0OCNOMvQwZQoFHXSoazLr9aS5USlwxjclFcHonooqe117V0hiTejV0210q7fV+lZEr4gbcVQuwL+9J4Ooy0AT6rEyxGfsV6bx+iP3omPV9XfWqnhuhWzkQLqzHiNfoLhs7Fi7KwNMvEsy1ohN0EJYKVOMXJBJmnwsGhZlIQAIushICM9Y6dCSAJAUyi9d8fLzr3rwoYlKTy9G54nqi0I9mR3bQXldOLFWqxD7nve35flTgRfGynlWK8g/Rc8F
 toIzm+Su
 vCX3TdYxDDZtzA4eaShjhzphcAr0ks+jgP8YpmCh95bA7tuMKShjtIquW5HAAo2WekaUuBb/GQ8lGAyAo9C4SMme2422NKJtci6/tRjWkH2wu+Cm3RO/q+dEOyjBCST+quUC5rVDAW96L01EZTB43PDZH8vuyBEMl7pKojSvTOuMGO0R91wHWTrEAEn4pcGTAtjtwEsWZr+45Sa6RbG9zkQhGwBrbDHPobK8DoAKUw78AbFhR7SsOa0Owt3odtd4gg+AQFNLm2PfdXRmFWSP1/0W20fJG46WgKmAHdHiKmjTfY4ik5V+I8eLnHJQBOFDzHkIB+gyPd6EXVFqSEaWmUBjbsASppEj0AFD7yjg9CXUsoRi7v7jvn20FaDCRonApk/ouWr/43OQKeZLz3EIlLTy6ROM9iOtGvL44lP+xGwaYSyrMORY0Xx3dow6dqQTMn8Uu/13JWz3YQJhF6rOJcer3kbfCtRnkh/0vChCDSHebnUI2s+NHUvL660EiPyo0B3t9AgpJh12PErflN2fIJVQNVVsuxTRvnj+WolNAUlE1VcXlZeP1moDleqCw4O63LcCXUNwjzaKfwSwTLwHoad+p4ym3AvCi1eWpiprYcTrK0KDn2Lny96+vEFObdAX9Gc5OncdmxcandDuxDBl4H9aitvtbib+bgOsgQswTLe/NWfjYx9mEdpfnEcCj9ujT2MMrWuWADW4QHGbUOLGNpsQO29zLp91J4Ajx4okefrUTyll2qCwuuMAqgwqj3smQpUr111ZCrmDKMfjhQk4I504RXLJKYWTb2F0584hwbosYQKlv68ADF/yC5yT8GRtCsCWDS0dLLOnUnr1xIUIejlMgbIA+HLr+6fA2wVS5+Wv76aSBlcuRGjzWc6LnWWSwz26xAGeKqOQoafoDZWAfPuEKZSqhT7w7w9WanhlZ9dDAnwjLGhTzPNpT1bod9BWSCmsPYHHhfWvxk+X9Gv/yHTD2c3EU
 khQxnmpe
 pH2CwbpKHDQj/9EANpWLVlT+XPhy7nFBYmLi2S4L4Fc6crcsCZJbw217pxoj/3GZUMu2L+mW2W2FTBJmwxx5MeaNSq6rQWOTovqUrPb4LezIavlJkirUuid6QvaQdt5TCYiXm3SnFTTvCcx3MCSJ/jHvqh2R1UtWc0DnKRrvNi2BeSHMa57XdEioCSAymQVbPV65v1QFL8yRzmgGi18sNqEzGVXli3NawQoB+wZVEd0E2y8a6ikEIu4PImBwg4cEcCyXXUR4MsdHOXxqfErlCmwROWvtaO3hclZQASJuNSKZGQ2L3IClPtMZBIdzaO8zo7yCXYomljX2HzcMJFTCAPNf+aIKOmKvNRLcGv6RxKM/8nLTvcySRSo8R2HT9f642Ik+Sod3e+9Eauo29qb30eOn4WqufBcvQKHjYhudIi5hpW71je6Ta+GS0VUtyAXo0sSj3/T/i5PCMJiO/pYYIO2HSTcb2acQ7r3z4N+vBcFGY8XUvqrliQpamObg6ZzHIYT28yJ7rQn9NQiSDBtqg65Y1TmgNWVvx0Zrwze8wtFKPWsocnyrGl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the vma_start_pgoff() helper, update the merge tests to make
use of it for consistency.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/tests/merge.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 03b6f9820e0a..f8666a755749 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -118,7 +118,7 @@ static bool test_simple_merge(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -150,7 +150,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
-	ASSERT_EQ(vma->vm_pgoff, 1);
+	ASSERT_EQ(vma_start_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -162,7 +162,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -171,7 +171,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
-	ASSERT_EQ(vma->vm_pgoff, 1);
+	ASSERT_EQ(vma_start_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -180,7 +180,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -209,7 +209,7 @@ static bool test_simple_expand(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -231,7 +231,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -324,7 +324,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -343,7 +343,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -364,7 +364,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 6);
+	ASSERT_EQ(vma_start_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -384,7 +384,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -404,7 +404,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
-	ASSERT_EQ(vma->vm_pgoff, 0xa);
+	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -423,7 +423,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -443,7 +443,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 		ASSERT_NE(vma, NULL);
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
-		ASSERT_EQ(vma->vm_pgoff, 0);
+		ASSERT_EQ(vma_start_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -805,7 +805,7 @@ static bool test_vma_merge_new_with_close(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -865,7 +865,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -931,7 +931,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
-	ASSERT_EQ(vma->vm_pgoff, 6);
+	ASSERT_EQ(vma_start_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -1416,7 +1416,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma_merge_extend(&vmi, vma, 0x2000), vma);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1456,7 +1456,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);

-- 
2.55.0


