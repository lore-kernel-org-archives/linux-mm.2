Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13177C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13AFB6B00A3; Fri, 10 Jul 2026 16:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC3F6B00A4; Fri, 10 Jul 2026 16:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7FB6B00A5; Fri, 10 Jul 2026 16:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C09A16B00A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:21:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 564A0169778
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:26 +0000 (UTC)
X-FDA: 84973986972.08.CC63E68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7529E20007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YA5DDqaf;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVQmK7W6QoKtw/kGvaitEcUKY+xFpiYNr8Q5ruqmHhg=;
	b=D9q6uenrtsHXAAqXXnWsePfdLP2HqXlx6kLpHk1ueev87z6CNl5KDsR/1D6ieQ5ymntAel
	Dn3pafuRwkTPFM86EyHzwr3QlSUkSkJPhITuuB/jkBaZE3/XDBxPEt+1TDmrBnLxMFafbt
	uNZt8WqQXaPSZe+SiHdldAxUlG/MgTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YA5DDqaf;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714884;
	b=ZlHPjsvhYrqkJcgvINBON0+/+cIFK4zetrkAuPginIUIl7VoB92SncMVA1V8p8GJXAgH0r
	vJY4mHgyqY4G5E1jDghILPHIYWbyOuPp4FZNeTartGuiF/D6w0PrEQyUHQ4dmy7/6JWHTH
	Q2gMOmvIsoBTjnZqLS8SzkOJrBhumTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A04BE40D7D;
	Fri, 10 Jul 2026 20:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21581F000E9;
	Fri, 10 Jul 2026 20:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714883;
	bh=gVQmK7W6QoKtw/kGvaitEcUKY+xFpiYNr8Q5ruqmHhg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YA5DDqafLIqNPLP9XGD/K2+Z42mVK146zNneUnUQphi9T6ZT5dS9mtuvVEfhJDTSi
	 s//g62lEPa/5fM6Rj+MfHLeFXY4lmP8YRRNVv/IBUuJF+3suQJzo279O+JLZ3oR0g8
	 17RPG3oi0R+HZ04oSDHcjxfiOvDAfUyl/59WBZGvYlcTsOfv5QtyYXwRI0mROoCNg6
	 bDmWqupn7Bivg41Bjy1cY8FcRJcw1cPUnFVaTBUJXi8e+rHys2oigCKJ0ZN7zH42Qh
	 xqfydxdwf+sygnAcS/tTpUOLud5oxgOgbKSoUNdV2wDLWFryUxryD6cA7pwzceYtQs
	 toirvlGHi640Q==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:51 +0100
Subject: [PATCH v2 10/33] mm/rmap: rename anon_vma_interval_tree_*() params
 and use pgoff_t
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5211; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BHX0baiEr9bg7gCqCCxbadqLVVJLcigeq+b/x/sekB0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg62/nLvR48oWtTJvwtcdDA9nW79gPecs6J5qwZB8n
 +XZu7VdHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIkw4jQxvjWqM9y/w8s1l1
 C5JkljBK2jl9eq/WKbJLfeZ/rp9NCxn+GTsztZksXHtZye1dF8fVwCnL321Zn9aseENRcKXNgt5
 7/AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7529E20007
X-Stat-Signature: 3u8npt7qg7owuqz8jrnwamfsum4ba4u6
X-HE-Tag: 1783714884-781992
X-HE-Meta: U2FsdGVkX19vNtTmTtvFb+AgwmKvPHwdIZTfPDwjtbqUDG/Pj2NH+fy1D2XlaFnR1aPzzndxYdSqLwmyUCKXMBNv1slPuewso0OlitQ0kbaVSzc/AdqExgFWItF2de06onlh9y2BThPudr1G7qdZBs9uiRALltVxyx/nowpn801DL0sIlMLR4mb8lTt9gNH2jTaR/puXMyTkTg9BVSnXrRBwJ4VFjCHnCA+exjKi/LJyD0MZMG4CD7qoS2zkzlB+hp4Yx+Rp1PNuL5NYefECBWnYqjVRPYfE4WvlNUUj4Yb5zQ+4S0kcqIjmDiAcre64dJBZjZlzfTHbXPSeMWCXieT7Y6d/zhNJowof2aL/pj4FINOjlhwQZPuGWQkAtnzRsJDGTokI0jF2O+myM+t+Z0kK2C+YG0gEfrj4Q/4sQWwBDCk5/SGpqloLQEetOUc76ryopFaOOnJWYpc1dqEb+n3WperuDwjHmcabtQRG8k4rl3H3ZFQ0lFhlx9tvmWL2nKVd8e0UNPU2HwjwRHtGUTjS+keDZVHcSU9SJDdkB6HwuBGSRh5I3dOqJEJ5S+yiOrECu7ggvtJ3plQenQbkwhP12W8yBg1ZoO0cnQ18lK7oMNUBqpLDZHgFFp+GdY9Dgx55jzTaFlKKdn/PJrM2fjctpoZvsZIpiq4wgBanBLbTpBqRReRgxSZmeaLTFhA9Tuh5qbN8kaXGqrHFu8Q3eP9UebjE6/eN1BXyF4EgAsKGXWw/h+D8FB1gUTSa1IApq5aoXdf4HpsZnjN81J3jSj52LEhSnXpHq3GKADuWbqHukOB5uLvF7bCnkSbZGP59IkVjQVxgo2OohHT0pzug8Wb4wuhXRUREbLljKhOY6CHZAdJOp0JDUbH+KaOMNn/11CKkUjbLYIIxx8//afBiAQqx76yvasKjxKWygB/vYWfm+mHUiGj/RyOnDpWV21VRnIwosa5oG+Z02rR2DHB
 MA4dmcs7
 a81wY2fQbVTrLa2jiw7XyqMUrpZ8qJZH1txXj2XVqnGwrQ03i2d5ekHyNLfFyCQtU5AsljqrN/XPolu64xCYIppyhhtRehV0xal68aGG+jfwgS5J805coWGFwzfNmnEzvVOnB3J24SWWwnWYFfTCYCqGp6z64CYNTYSasPn7DnQq1RkwEuqGxCZTyu/+WFOBltSVTKr8R8xJR8JIL4rabiNtQu7KGywDZEdGNpskZF75cyA3iivZe0B6nXCgdf5WNGNaYUmHDcQ44mPo8Fc0SVB6zgVbu8Uw4G0Vw3Y/rHeoBB2lfHx8+0c2EwTbNJYX1QwzauT83SniP2Er/8OhrukuIYofyFDv+9W+oXRcE3VrTDj4eI/Hm/V46jX36SwAdhP8v4HIq0CWbyU3s0wbrBdk38B6lNTBJxtHIFUBhs42OXa9ojepMSckhZev3G+1h+VgrZX2GDGJlkYKFLwLBIW9qAzqZPT1ELidqyd4XKLBpkJHvJrnVwi+vp3O8KoITFiN0BYbB5mNzB/K08sMQmrSkr/qR76bqgWNWL6np+WESB6TZrgT/+JiyWOEgoO23QwOBSP4NLq/sjwzl/9qvT46xs15dkXUTR8Ie1fONMBOhRP7fLsuHOBQA64WuheqQeygjbbTeZmynP8mLrHAy6AFan0UBNPCnnuQ2piHfpCiGEj1HNmz6LoEh/po6HKwMH0XtbisKaoIzowCCL5MF0EEhJk+3aqnmVQSoXUucDwKnv8WgbCcPk17K/u8O7cCNrjRA3Yd0Wajp+5l+/CGJkNya/MyVTixPJUyL167RqgmG4KrlqijDPAoZ5mSAmzMhd5nvJSnBqZ3HgLqeo7r1kCm8AibbgzEKL1F9v9gAJ1xj4II805b7Km6Tqunb/F+FnkLYmOKtpd+FkNFtGqNt1jC/2gc99qzoNyE5Bh0eA0on7QSsliHGEZPwlvSgBHKmjT/vrZrx9z+ECdonFEO+Z5xaRsl9
 o7y0sRWA
 nLchKFf2kbrVTDzVk8I5KzqCnhV42aVd4QLZ5s8aQUb+xzOifMZnbCM+6E6dQh9Y8yeTxkRWeA8swkZlpM/Bxm2qTbVvva+TZpOx2Ja0LVYZGYcA4HCqnZguAWm3Jc1734tybOhsL9krQbibEbOWdDg1xtowhtfvW92emWoeR70hSHdvGMqtgOjVwdohmpW7MFJWh+TM50vly+NyCLC15iRwvD/KaGh/1r1co2VptQTi7pqsqZL12QEclrfw3lEXOhYBvyVd2uDWMcFBhxgswF4RSOJDlUfM/MxuPmKATqJoW+DLor0VxT7m4h2T7l8x39GtJH/O83ySDIfOOKXTTQWJ0td3sY4R3J5DjsUSZp8/2BG9gbOCFyzfH1OibvNTvodorqDiCr/Y5FPW8lJId6W+zRGkVpAA7VhKC2/b4k4rj4SB5Tlz874Dt2WfB3EUclJ6I9A20mlXHiu93w/zRe6tLrlpMW7DEnb5L62dn4X1AY/Nbe1s09Of2cwROVxE+i3xGUas8W2EpYQTraZklaweci20AFcVJwI/szApjV4GYAyo1MxpTbkIjtM/dS55RtsRfTHVbpKt0q+lIwozmQGLecRr+tQIxrcO1gKI9JXEMXJNzTujpN/zZtr1+VJkIgjvrN7GXMHI0Agd3SiI0nAjYsl7gbKIhiMaMSz7dDhAkTSE3dPTQ95ABCQ+y9vWmrIE+LEKYXhPehvwuxv74mWaNXahn0+jzUof2ZAj7XfUpPe2p9wu/LcXGQHBV1P8aPVceUJ83MFP+NX+8mXXgp+C1S4T+y587Ln+7U2Kl7Mf3uHTXN5XIyZF2sK65rSYtBNEM+GF+XgnmecotfUwfkSRgIq5nrt9kL50uycNIF3XY4QKWzDc+2DaHq6gijX/Igg2HEW5u8xST4paQYtWlqvnFRGW9c/SNdRXLYvFyJIy8azv/nzfsv1MF9VoK00sHfUQxu+DpS9dCBWA1jCNkxmlxDh2i
 kK6V4B4G
 3W0GDc7ozmo0LB+82l/2Xxntl1g+il2N84joVk+Nw/Q+7PuVE4nRh/NEYcu763iyvpm1FCnENm6LCzaOKrrPHKIx0wKbhyOo0Bvc0/YV9ezbBnV1KXG/Z41izRtP0KRH+9H1YG4916xJ6kCQBo1lpvH7k+dm+W4UHGcfxsTGHM49ad5bQjQY4xmKy8LczdVqdulJuzd8ZZ4el9b/dYGnBWXEm7HV63dSMVc/boPGQaG936RQXz2uh+Zph78v0ZFwFmoF/guDoNIKQ5YDX5PA5kGbAdVs3e+nicJ5z3RNK4erZAXkcJXjI2ngIDzfeiYpkq4KwllaGEHlmZrI61dg1Vq4NhRXsU/E9rrqjZNP/Jcq5jffnuitSXpAdwrML0Gz0EGa+YTvlf+Ar8XvQ8SuvH8+1hAEkv+YrsHhAF94+564m9DHQzI81xtb82HX0W+0gdeSBm8zYCYLQfrUXiHW9UHQ+ynylVhGGGvdrLXghWd4yXlDLUu4ScL8F0VHJWLpyBC2omLDoIHgBjnB+p5vp8SpBIyYRf4aI2kxWm54zhJvTtVqxGtU+CkoDIxU+GGrLseQM6bXJDGWHzSgAX94TXEVWnuMOqA7X2OWX7iPRjTrcENzpIuSab8DaMc8MSGSI0DVmy4AmW/pECkSnJzeRu9YRy4xyL4W6eKwuTjhf8FWnkj2rrZbYKvHwPWrrUtnsbKxbDuodVTcGlBYvqHGDDQFfi9/0DYV9rBLijcfB1iyKtU9hOxZ5Bo0G5IyzCGGLMYqdUBi0EekygFDJFzDnOeG31nZ10fBpxHhGmmpWJsHlfErSVhTHVBa0E/VDs4NsYCg37Xqd1NtxTR40k0/l0WHtxj6atQKUyXwzz5e1oV2hHmXkKlXZY6tn9RcGwq7PBLz3LfPkAcsfpNTsNAcG54cpTxG5Btnc3kHVdwnW2tzfEWX7Ibxs4liW3Dp4atcPqGasoMyroXx+b/l9UgaQhBJrTa2m
 b/W33+Qc
 JoRp3QRfVuMB3APU8awuvOPGxCJOHNLwF0WhKE3QERLYsJ6di6cgVkShVm9hooSIemdmCccFXOyj2yhtvWQ6mVbNAJ1Md/PvRiR4zogg5WGunsdatrHstITDcGKg8ubwdEDle05MOPnzA69vyIjwpY/+tMA4y4a6nHXEZIMWnoX7KlW3GNg0Ew7XOXCl73G4uANqiIE2OaioH629hsHb3OPsFv1dtm2fOFEbjIn/JV97hefeQZChzWvarEfapm6eeS/DOj0HEtzGTR0AjWLP2Z4x99BqWb2rJvh95zE2+HTyHVdchA+vVOpwvLYAB0VwsalJ03dZhJkTyrQbVCIufYhg6eI4puOViwdYrdIHTpru3o787Ym+WZfWMf1lLjw2YIoq67J18C5shXajHC+28fw36TXUB5tiH8QGWS5x/Oy8Q+UXE+O5+VSlL466j0lSb4J8JfoEf+9+qMVR3DQistft7C8q1OD7oXjnrW37H7O+T0p9tddtLg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename parameters used by anon_vma_interval_tree_*() functions: 'node' to
'avc', 'start/first' to 'pgoff_start', and 'last' to 'pgoff_last' to make
clear what is being passed.

Also, express page offsets in terms of pgoff_t to be consistent.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 19 +++++++++++--------
 mm/interval_tree.c | 34 +++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5d825824f7e4..ae7c976b516a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4110,23 +4110,26 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 	     vma; vma = mapping_rmap_tree_iter_next(vma, pgoff_start,	 \
 						    pgoff_last))
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma);
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma);
+
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  unsigned long start, unsigned long last);
+				  pgoff_t pgoff_start, pgoff_t pgoff_last);
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				 unsigned long start, unsigned long last);
+				 pgoff_t pgoff_start, pgoff_t pgoff_last);
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
 #endif
 
-#define anon_vma_interval_tree_foreach(avc, root, start, last)		 \
-	for (avc = anon_vma_interval_tree_iter_first(root, start, last); \
-	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
+#define anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last) \
+	for (avc = anon_vma_interval_tree_iter_first(anon_vma, pgoff_start,    \
+						     pgoff_last);	       \
+	     avc; avc = anon_vma_interval_tree_iter_next(avc, pgoff_start,     \
+							 pgoff_last))
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index b82d2a0d9c4e..5bfe95b5cd28 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -81,55 +81,55 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
-INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
+INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
 		     static, __anon_vma_interval_tree)
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
-	node->cached_vma_start = avc_start_pgoff(node);
-	node->cached_vma_last = avc_last_pgoff(node);
+	avc->cached_vma_start = avc_start_pgoff(avc);
+	avc->cached_vma_last = avc_last_pgoff(avc);
 #endif
-	__anon_vma_interval_tree_insert(node, &anon_vma->rb_root);
+	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, &anon_vma->rb_root);
+	__anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  unsigned long first, unsigned long last)
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
 	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
-						   first, last);
+						   pgoff_start, pgoff_last);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *node,
-				 unsigned long first, unsigned long last)
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_next(node, first, last);
+	return __anon_vma_interval_tree_iter_next(avc, pgoff_start, pgoff_last);
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node)
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc)
 {
-	WARN_ON_ONCE(node->cached_vma_start != avc_start_pgoff(node));
-	WARN_ON_ONCE(node->cached_vma_last != avc_last_pgoff(node));
+	WARN_ON_ONCE(avc->cached_vma_start != avc_start_pgoff(avc));
+	WARN_ON_ONCE(avc->cached_vma_last != avc_last_pgoff(avc));
 }
 #endif

-- 
2.55.0


