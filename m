Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3647C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85DD6B0095; Fri, 10 Jul 2026 16:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36E66B0099; Fri, 10 Jul 2026 16:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7C46B009B; Fri, 10 Jul 2026 16:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 526C46B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:19:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E14B41C8899
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:53 +0000 (UTC)
X-FDA: 84973983066.22.9855CE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0006C1A0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJG2R20R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTpEXCYyEBDssM0LXmlPBhbdcFdvloAKFT95xd9ND2E=;
	b=Bn3+fjbipgOUOXRdnC1u3HpsHuXfsXxSIwPRtGzR9zw78Xw6VmZJP4/1J6BcGGFuBlKG3Q
	xcBNJbYlq/vNWZH/3Q+r3JKGmh7+tLm/UJCNir0ycz35MDeK2enTde8vXGgwp+DaWBOheS
	PUJ9DS/YMPlBTM1qJUu7Hdvwo3Rzslk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJG2R20R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714792;
	b=fpdvZt+kAdJEWO6I2LWoe6GTmLXP6COfS8eLd/YdVxs+ZCw2C0snsIxhjbPNgk2Li9ZzEm
	skgEznpoF+bszQFVNXQRs4Cogn8kf5voaJhAGR6z9yH/0923al/2l9f/VvdVu2a14wAKvB
	rcPCLfI7DevSseVKRxVd0g5y3jQqWtE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D87D43E22;
	Fri, 10 Jul 2026 20:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623841F000E9;
	Fri, 10 Jul 2026 20:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714791;
	bh=yTpEXCYyEBDssM0LXmlPBhbdcFdvloAKFT95xd9ND2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dJG2R20RS+ApyjgMsPxuzZUiPonPDpQSeCwtum1pQxYenuifhCDBec5AidB3GhKUO
	 eCJ649sAicKn2q5tryjVOsVYFvIDOLvlTt++rEjL1v09Uf1kUXl5JoY5JdpXGso69C
	 Ts/3B/u/d+o/c0gl4cya43kV3gK7sWCg5ncpfcUvZESCTWpk6G2Iaut6DI3fWKsQeC
	 +DAYhKXzDEcXJqvM1ZywVW2Go90fdRor4SKKZ29CZjyk5M7G3cl+LS+k7oGPxHrZXB
	 Ov9bXXWEnlI0qwJxKWM3r23dPvRJ83SJ+Z3LHjs87hJMKq4MdtK+x8EU0XbnCmNQwW
	 pHyHNik67WVUw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:47 +0100
Subject: [PATCH v2 06/33] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-6-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=23248; i=ljs@kernel.org;
 h=from:subject:message-id; bh=l37OTGuevZc5gXyVHaBH6LTDa3GZBR26w5oXVQ6z530=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg63PONzsnuP3/tlETZUjqzJ1pprsO16To7hp0k2bw
 spLtzbId5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiruwMv1lkF+a5CFZNcVFu
 8r3BH8b/443PjTe9p1g3hfO4BcVFXmdk2G/4tdB7ukr3nD1/xKK2XHimqvrhznoZ3ZpFDxdH3+F
 i4wYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0006C1A0005
X-Stat-Signature: wxusfwu514uxznxmuf9ctjswy9tu97e4
X-Rspam-User: 
X-HE-Tag: 1783714791-302325
X-HE-Meta: U2FsdGVkX19ztkxGK47dci2QQEloUK5mX1mYRSFOeQ9DdWZthCoSAm+DrwwTG92ynTfNVYjTXpwJUbC0a6kFajGqPFHCbdIchNaiijrKE3hyxJYcvac2Nhzb5uCj/JR278bIHRcYpDEZszE6wPAHm4sAIR9Pkd1UBKZAdfMcCO1D/N7Ion9ingU8uUr8fY8ZRRp+D2nUqGM6+RH5OAtIo6ws5P+A2YnUzM3DFjK65RWbF+HGm573yRcDIQtEvd6ScFyWYVG3/BzR6eGmPEaJzgVdXl5L9x7LTjyam3KLkLQJVWC6SGpgp5Url9GcChTnxMjGckNRPW2Dq31104fcAw2czYTyhPsu0DUHQ6aPznwLN0AI/koIwBfiT4Wl4cPqjf96wDNmYeTB+mnRn2pnifcE8vp/1xbrvUvlCDuhJMg3CZhYbl86mhu+sE/wPMpNaXpZnDYl5eC7M10eYGu7Bz9ktGYRT5xNrem2WX7XHgXZ9uBDfD9LGSNPYg/h8QqVnGEkVuiL70aiu4p7ZjdFGcM1MuHWglvzU3Bp+6JRCI5t4ClUYk6aPftdlv+usqx2YyRw7wJxmL85TZUymv+rZdI8ryOGV/1M6juXzBdlfNQbOMO5wfNDgClaNS1MLKaE+OsnvqrS01qMaO/ZAlgyVvrhCuxzAMTTP/1qbTKoLtabn6b549dcrqvwgMcJpL0b696crKwJlwGwx5IpNgmOg7BAcbXZjcgox57pc8XZwPPrk0t58cGxyQ23GfFQ7I5X7KQdqky6pbXM3n410B8FvsVMzEnHYzx955wdFDHCVCrmYM/Vya3otmf2Ru7IHPx8ZI+RJREAgEabLiDHuLW6xD9A61UdlAnYoG+jXy0JFvfuZF+zlYxI7Ayr9t8Yvww+rXtvIEcvDrJieH52K6tLYyTP9Lvw7+HjwjEsYS1Stn4cV2G+b4RK8MihILTZWB1ASPCs2RHY0nbQFrGdYxG
 bKEIpeeD
 5b/8WQYElmjoTAWQPh8kmjr6J3f4zzYlIGz5LpfjMlsfPkTwJgP5/85gQUQykeGzyMEO1Vkq0N41HdGafkmaFs+jaob7M2iR2bzHkkaBXxOWSnU0uToGea0LNzUOYXh+AqboEQeDUBmk8QVnPN0QrjjEl3UKn1mkoW/lPvJXJA5OmwjFdWq+puYi+ene7aCvkvKNTL69uzKtluzeo1ft+lzUClSsUvolwLcz0/RlogJPf9lYjO5LqdOz2ERCa8ZR7miDlgFL7zw/wZ/uh86Rnb9B+5OkJHV8Vd3qotCRC0uOlFuU/BtnkEAfLdxZorlQSnq0McEP71X1NFXUo023JjUOydct/kcs6BGQCuGmJ4b0jh5FYpYGq4KzKEsfai4614WGRRZSJIZjlOr0N/uoFod4Fek32AKK3g00iObf4RQB83EBfOe7L3raDpicKqtDUCEtAC1eW7wUXDBVQ/6Ccj24Ml7VkeDwcBWcNXV+UuxFDf7tw16HN/dhq2E9lAaLj7HC0JVO8emYWLAGxytJOtDBY6YcExrNq9GeDi78xp2pBe9xhum7oNIFijVEhsD+QDzYHajkdr/YsjiZ0WnsqKcjZKQWh3H+97VjFIsor1iF5rQqNVlBECKtqxDhGK/6PGpHYrqBfoBc954yIBrWYXoiGj5Oyr8E3vnhjcHBwmdpWCa01GliXOxirPL33iD/Acne60R1lbVD8x9HXxox8YKSIcDwGoUlsy7QEkY+c3bFxVyP6WiVGiA8ZbdtVppTtNmD98s6D/93uG9UZbNK1hhrEZvDX7XN5xwbMBf02PkQRaYhDsn04wDj8IBuGbDpiXLFeV9Fll9tdn8VG9ck+FNPBuFelb0pBLH7TAMqOBqQejIABEMv4H51nMKMbdjl9W7likvZvYJta/8mOzvtBcgYQP0OKPeKQTQ5MgOeaptC45ZgzqpFwbXvisZZH6SybTUxAO5WV96JKqdQhZfysGcISrJCM
 ngapT1UJ
 qbV9NVxYe5yg09bPWkDvz8ObVvNTrtaNdTVeZG5xhoUOpq5v3yFEOZnLx75vE18pnWrRHu1h07eEpZWJvu8Xiw4sHw9K7NJKPBsMCHTLkswl4q7U+nqIhZH/acG9/GTHyUn/DTfF7ovhlHXuR4g3PbS+a8H/ow5wQ6QvSAxZ7QNWl8xefwy2r+WHje1IPC0xuRNslqz3eE5iUi9BIZOlCjEzWjWPl8wcvUZTmg868jnSHXyTTkRFVa5X6336luAkWkyTOMH5vO4ZKw6gtasyWyvcQN/ZYu4vgEazAyV8IChU92DTuhvn232dZ78qPM7EDpGdox/YdJL5aeH2q41mSBMBCo67SKHT8fgTjXDoxrMVmvhcGG6g0QKMU6tJFEzTXX6g4G1i+JXjI6zk8E1sEu1Ili+QKW7QkonDf9eszqzfrKv7Nrd6UAV3I7Vdc0R/TWcOzcJGlijRfp+OzEKHLBuy1OtE3ISWtPSLTbGjgI6sSHNSztTSiMxDES8vEzoCbKWTs8w4t0pYDh9TgaSI5y/tpTgVaOiiS7AQhHM1rty/085KPgGJAZ08X8TtaUAhQOg2BNJ1uQQPeo+o8O2IGOtu/kH4fwUctwAK3cUF9OVqplxVWGgUbGemxmynTUqNeAcBG0omv1AT+nEHB+NsUUQL3pvkJKpd17eREHIzWUEzjhP8iEu2Z77WWRgkjarfCXHDb4B7LvIl++Ed4ThwI8ZPYpFSnUZEd7iCGrZV2MKvkQ6VrmeBaiUu04n6yekW6mrBHyxirNOKBlDr0/D13J1M8JRXKMNG5kLOvbCznpVMyH67HqHQP4rvTdfYD+CqWfNA62Uldn1IF2DP6qrA/UX8W15TTQiIA41urwql9Mj1JtRF56iwlVuBAAoRqVBLldCBpaQ2WmEtapkjzUY0aYCKEdP9pQQ8xfV2x09Z94OolQAImcfMix2BYmUdcgZIpdqk0cSqm2fCKyFs5xWwwz2DWvZha
 8NtL6lUT
 oJcT1Ocm0Rg4vAY/L98qHONlLiS7Qx7eoY2Cf/2/uWnRbfFJQITYZuCEX9j4svrCR/y/MMleh0J6c++Fzrdk42sYAqiBB3veJnX5jdV+NCqYZmYv0GSrnOnpojTXH9Dvp2Pqk19/rWdhJ9k76FJAtiO5YMuuA+A3TLSrjKf36FOs8Pt32rvl0lnB12yP+wBotzQ7rpp84ak/28k8Gp/C3otq3+jnS2ja08o7uf0SYT3MqqbsIpQ1MLm6N2WWqdguBx18ZNaE3oS4daP/GhCWlcz8UW5JrRGmqRrj4Zk0nB/v9ef+DOK2PS/TDHvHdT/GlhvDWNH/xcdbB2qe9E+m7tVKrybfFUsPxonVrH9vxvvsGzBL8rQ3bJNE6rhA6JKUUjbRcuAk0cxQtMcx+TAaOJ9GFLjabDM8taE3csgREVQea9dXnWz1vs49bjtjcgnpxt1S0IiAofmhfC3ioWLmeqlUnrfSDTFxJSfkkY5PKNdBWgDvFBB3tcWCpKPjzkSNr6u7dnXtB4+sHWNY/7iE/rKw8DSdM2o8ku8NbPxdcT92BBlkxz4m+VUBmV5ouicH6b2yLNwQhzSma5/lNP5OKMe4MwcqDWlBSTdLoY8U806w5e48iYBMWEzEY7UKjghaN5IqbNWQtH6wKgNIei96W0e/4jV2SJMxH8OMgmNWsYbhD8YL1ECzlUSCc9f5P6SXt/vr+ifPzHbUeJGEaPdugYdmmRK056SUnwL7ovmDleQTWGFnYe0D9N5W8egqwndJYsOaOzPRG8ukH8prQDOCljOLxIEYraeRcqNeL+q6s+2i+EgRDbP6MiFayCDbX4r3ZAjyk+coYPd0D4XRGOWapzP8rqj5CBovTT2vBHfx7GW6+ti2Z5gc1cF4VG+W49Mi4OipItoKkazpDXrKPL4HRDNzms6BzpIwy9tn/YU0dQHlhSpgX7BpQjJs+cDEdQJvFAqXP1vy8xlgODoXhFwSwWDUyr7cA
 2swxFav/
 hyv1axVaZ9zS50ho/j/pvc3P4GK3G1Bn626OQsPGxu/xEFwKFa0NEnNej+q8VxXjuIBSNCeR9z2QXdC8YJt8ZoNvdaltyuzNTuet+MuXMFkv9EX9Du8vmJuRhdO+hOVKMrO5VHixdlZSPysf8auThSu43/JwuOEGB3CbrmjHazMMlTN6lYdhBmeOVnCHt0ETC25OHUVgHpNgB+i8aH1/Pd3LDVSbQLnUYzDpYtV0QBwO3QJgapVo9uylcdWsKb+tJXLfwOi+JeGFBVWiEveWzEZvN6c9sd9f6yCzTQVmWRQC0QuuXTKHMOaKILJl50A3pU9etkyuAU+u3o0OWlZqHwxxW9xF1MioPsVw0C3mufk/MMy3MTPvcyQydzGGk0z2v/U3u4q9iXYlJCGSHvD5i9pN9C5DMlK7dXpm7fwbvZ6SnO5WfxSJT5kPYxIJSysvEGySGmsPnOeGLVj9BR4FnuOMopzB3qqeyBntiRnaZ9PWCID7qOIp6Lr0qfppBhNfioHlEhn1q4bu0+1eKLy8K+YL70U1fxpKSF+xwVSwSJwGXPLfgr1SfT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The file-backed mapping interval tree functions vma_interval_tree_*()
accept a raw rb_root_cached pointer to determine the tree in which they are
operating.

However, in each case, this is always associated with an address_space data
type.

So simply pass a pointer to that instead to simplify the code, and more
clearly differentiate between these operations and those concerning
anonymous mappings.

While we're here, make the generated interval tree functions static as they
do not need to be used externally (any previously existing external users
have now been removed).

We also rename VMA parameters from 'node' to 'vma' as calling this a node
is simply confusing, update the input index types to pgoff_t since they
reference page offsets and rename the parameters to pgoff_start and
pgoff_last.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 arch/arm/mm/fault-armv.c          |  2 +-
 arch/arm/mm/flush.c               |  2 +-
 arch/nios2/mm/cacheflush.c        |  2 +-
 arch/parisc/kernel/cache.c        |  2 +-
 fs/dax.c                          |  2 +-
 fs/hugetlbfs/inode.c              | 15 +++++-----
 include/linux/mm.h                | 34 ++++++++++++-----------
 kernel/events/uprobes.c           |  2 +-
 mm/hugetlb.c                      |  4 +--
 mm/interval_tree.c                | 58 +++++++++++++++++++++++++++++----------
 mm/khugepaged.c                   |  4 +--
 mm/memory-failure.c               |  7 ++---
 mm/memory.c                       |  8 +++---
 mm/mmap.c                         |  3 +-
 mm/nommu.c                        |  8 +++---
 mm/pagewalk.c                     |  2 +-
 mm/rmap.c                         |  3 +-
 mm/vma.c                          | 14 ++++------
 tools/testing/vma/include/stubs.h |  4 +--
 19 files changed, 100 insertions(+), 76 deletions(-)

diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index 91e488767783..cd52cf7f8874 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -140,7 +140,7 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
 	 * cache coherency.
 	 */
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(mpnt, mapping, pgoff, pgoff) {
 		/*
 		 * If we are using split PTE locks, then we need to take the pte
 		 * lock. Otherwise we are using shared mm->page_table_lock which
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 4d7ef5cc36b6..8c593e9898ee 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -251,7 +251,7 @@ static void __flush_dcache_aliases(struct address_space *mapping, struct folio *
 	pgoff_end = pgoff + folio_nr_pages(folio) - 1;
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff_end) {
+	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff_end) {
 		unsigned long start, offset, pfn;
 		unsigned int nr;
 
diff --git a/arch/nios2/mm/cacheflush.c b/arch/nios2/mm/cacheflush.c
index 8321182eb927..42e3bf892316 100644
--- a/arch/nios2/mm/cacheflush.c
+++ b/arch/nios2/mm/cacheflush.c
@@ -82,7 +82,7 @@ static void flush_aliases(struct address_space *mapping, struct folio *folio)
 	pgoff = folio->index;
 
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff + nr - 1) {
 		unsigned long start;
 
 		if (vma->vm_mm != mm)
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 0170b69a21d3..f28aa7884cbf 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -503,7 +503,7 @@ void flush_dcache_folio(struct folio *folio)
 	 * on machines that support equivalent aliasing
 	 */
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff + nr - 1) {
 		unsigned long offset = pgoff - vma->vm_pgoff;
 		unsigned long pfn = folio_pfn(folio);
 
diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..2f0818a68a7f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1201,7 +1201,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 
 	/* Walk all mappings of a given index of a file and writeprotect them */
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, end) {
+	vma_interval_tree_foreach(vma, mapping, index, end) {
 		pfn_mkclean_range(pfn, count, index, vma);
 		cond_resched();
 	}
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..4ea1798f1ffb 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -380,7 +380,6 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 					struct address_space *mapping,
 					struct folio *folio, pgoff_t index)
 {
-	struct rb_root_cached *root = &mapping->i_mmap;
 	struct hugetlb_vma_lock *vma_lock;
 	unsigned long pfn = folio_pfn(folio);
 	struct vm_area_struct *vma;
@@ -394,7 +393,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 	i_mmap_lock_write(mapping);
 retry:
 	vma_lock = NULL;
-	vma_interval_tree_foreach(vma, root, start, end - 1) {
+	vma_interval_tree_foreach(vma, mapping, start, end - 1) {
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -460,8 +459,8 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 }
 
 static void
-hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
-		      zap_flags_t zap_flags)
+hugetlb_vmdelete_list(struct address_space *mapping, pgoff_t start,
+		      pgoff_t end, zap_flags_t zap_flags)
 {
 	struct vm_area_struct *vma;
 
@@ -470,7 +469,8 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 	 * unmapped.  Note, end is exclusive, whereas the interval tree takes
 	 * an inclusive "last".
 	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
+	vma_interval_tree_foreach(vma, mapping, start,
+				  end ? end - 1 : ULONG_MAX) {
 		unsigned long v_start;
 		unsigned long v_end;
 
@@ -615,8 +615,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
 	if (mapping_mapped(mapping))
-		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
-				      ZAP_FLAG_DROP_MARKER);
+		hugetlb_vmdelete_list(mapping, pgoff, 0, ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
 }
@@ -676,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
 		if (mapping_mapped(mapping))
-			hugetlb_vmdelete_list(&mapping->i_mmap,
+			hugetlb_vmdelete_list(mapping,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c56ca22d406c..da4b7540837d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4090,23 +4090,25 @@ extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
 
 /* interval_tree.c */
-void vma_interval_tree_insert(struct vm_area_struct *node,
-			      struct rb_root_cached *root);
-void vma_interval_tree_insert_after(struct vm_area_struct *node,
+void vma_interval_tree_insert(struct vm_area_struct *vma,
+			      struct address_space *mapping);
+void vma_interval_tree_insert_after(struct vm_area_struct *vma,
 				    struct vm_area_struct *prev,
-				    struct rb_root_cached *root);
-void vma_interval_tree_remove(struct vm_area_struct *node,
-			      struct rb_root_cached *root);
-struct vm_area_struct *vma_interval_tree_subtree_search(struct vm_area_struct *node,
-				unsigned long start, unsigned long last);
-struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
-				unsigned long start, unsigned long last);
-struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
-				unsigned long start, unsigned long last);
-
-#define vma_interval_tree_foreach(vma, root, start, last)		\
-	for (vma = vma_interval_tree_iter_first(root, start, last);	\
-	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
+				    struct address_space *mapping);
+void vma_interval_tree_remove(struct vm_area_struct *vma,
+			      struct address_space *mapping);
+struct vm_area_struct *
+vma_interval_tree_iter_first(struct address_space *mapping,
+			     pgoff_t pgoff_start, pgoff_t pgoff_last);
+struct vm_area_struct *
+vma_interval_tree_iter_next(struct vm_area_struct *vma,
+			    pgoff_t pgoff_start, pgoff_t pgoff_last);
+
+#define vma_interval_tree_foreach(vma, mapping, pgoff_start, pgoff_last) \
+	for (vma = vma_interval_tree_iter_first(mapping, pgoff_start,	 \
+						pgoff_last);		 \
+	     vma; vma = vma_interval_tree_iter_next(vma, pgoff_start,	 \
+						    pgoff_last))
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4084e926e284..50a96a4d812d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1210,7 +1210,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 
  again:
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a85ea663b192..9dddd4227dbf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5454,7 +5454,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
 	i_mmap_lock_write(mapping);
-	vma_interval_tree_foreach(iter_vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(iter_vma, mapping, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
 			continue;
@@ -6997,7 +6997,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *pte;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
+	vma_interval_tree_foreach(svma, mapping, idx, idx) {
 		if (svma == vma)
 			continue;
 
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 2d50bc6228c4..ff36fd14ef37 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -14,19 +14,26 @@
 /* File-backed interval tree (address_space->i_mmap) */
 
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
-		     unsigned long, shared.rb_subtree_last,
-		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
+		     pgoff_t, shared.rb_subtree_last,
+		     vma_start_pgoff, vma_last_pgoff, static,
+		     __vma_interval_tree)
 
-/* Insert node immediately after prev in the interval tree */
-void vma_interval_tree_insert_after(struct vm_area_struct *node,
+void vma_interval_tree_insert(struct vm_area_struct *vma,
+			      struct address_space *mapping)
+{
+	__vma_interval_tree_insert(vma, &mapping->i_mmap);
+}
+
+/* Insert vma immediately after prev in the interval tree */
+void vma_interval_tree_insert_after(struct vm_area_struct *vma,
 				    struct vm_area_struct *prev,
-				    struct rb_root_cached *root)
+				    struct address_space *mapping)
 {
 	struct rb_node **link;
 	struct vm_area_struct *parent;
-	unsigned long last = vma_last_pgoff(node);
+	const pgoff_t pgoff_last = vma_last_pgoff(vma);
 
-	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
+	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(vma) != vma_start_pgoff(prev), vma);
 
 	if (!prev->shared.rb.rb_right) {
 		parent = prev;
@@ -34,21 +41,42 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 	} else {
 		parent = rb_entry(prev->shared.rb.rb_right,
 				  struct vm_area_struct, shared.rb);
-		if (parent->shared.rb_subtree_last < last)
-			parent->shared.rb_subtree_last = last;
+		if (parent->shared.rb_subtree_last < pgoff_last)
+			parent->shared.rb_subtree_last = pgoff_last;
 		while (parent->shared.rb.rb_left) {
 			parent = rb_entry(parent->shared.rb.rb_left,
 				struct vm_area_struct, shared.rb);
-			if (parent->shared.rb_subtree_last < last)
-				parent->shared.rb_subtree_last = last;
+			if (parent->shared.rb_subtree_last < pgoff_last)
+				parent->shared.rb_subtree_last = pgoff_last;
 		}
 		link = &parent->shared.rb.rb_left;
 	}
 
-	node->shared.rb_subtree_last = last;
-	rb_link_node(&node->shared.rb, &parent->shared.rb, link);
-	rb_insert_augmented(&node->shared.rb, &root->rb_root,
-			    &vma_interval_tree_augment);
+	vma->shared.rb_subtree_last = pgoff_last;
+	rb_link_node(&vma->shared.rb, &parent->shared.rb, link);
+	rb_insert_augmented(&vma->shared.rb, &mapping->i_mmap.rb_root,
+			    &__vma_interval_tree_augment);
+}
+
+void vma_interval_tree_remove(struct vm_area_struct *vma,
+			      struct address_space *mapping)
+{
+	__vma_interval_tree_remove(vma, &mapping->i_mmap);
+}
+
+struct vm_area_struct *
+vma_interval_tree_iter_first(struct address_space *mapping,
+			     pgoff_t pgoff_start, pgoff_t pgoff_last)
+{
+	return __vma_interval_tree_iter_first(&mapping->i_mmap,
+					      pgoff_start, pgoff_last);
+}
+
+struct vm_area_struct *
+vma_interval_tree_iter_next(struct vm_area_struct *vma,
+			    pgoff_t pgoff_start, pgoff_t pgoff_last)
+{
+	return __vma_interval_tree_iter_next(vma, pgoff_start, pgoff_last);
 }
 
 /* Anonymous interval tree (anon_vma->rb_root) */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 55157567dc4c..e5462e026642 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2141,7 +2141,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 	struct vm_area_struct *vma;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
 		struct mmu_notifier_range range;
 		struct mm_struct *mm;
 		unsigned long addr;
@@ -2573,7 +2573,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * not be able to observe any missing pages due to the
 		 * previously inserted retry entries.
 		 */
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
+		vma_interval_tree_foreach(vma, mapping, start, end) {
 			if (userfaultfd_missing(vma)) {
 				result = SCAN_EXCEED_NONE_PTE;
 				goto immap_locked;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index bf717ec59508..4358856e764f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -598,8 +598,7 @@ static void collect_procs_file(const struct folio *folio,
 
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
-				      pgoff) {
+		vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
 			 * the page but the corrupted page is not necessarily
@@ -650,7 +649,7 @@ static void collect_procs_fsdax(const struct page *page,
 			t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
 			if (vma->vm_mm == t->mm)
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
@@ -2297,7 +2296,7 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+		vma_interval_tree_foreach(vma, mapping, 0, ULONG_MAX) {
 			pgoff_t pgoff;
 
 			if (vma->vm_mm == t->mm &&
diff --git a/mm/memory.c b/mm/memory.c
index 87db93f35bcf..6ce92badc38a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4360,7 +4360,7 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	return wp_page_copy(vmf);
 }
 
-static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
+static inline void unmap_mapping_range_tree(struct address_space *mapping,
 					    pgoff_t first_index,
 					    pgoff_t last_index,
 					    struct zap_details *details)
@@ -4369,7 +4369,7 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 	unsigned long start, size;
 	struct mmu_gather tlb;
 
-	vma_interval_tree_foreach(vma, root, first_index, last_index) {
+	vma_interval_tree_foreach(vma, mapping, first_index, last_index) {
 		const pgoff_t start_idx = max(first_index, vma->vm_pgoff);
 		const pgoff_t end_idx = min(last_index, vma_last_pgoff(vma)) + 1;
 
@@ -4411,7 +4411,7 @@ void unmap_mapping_folio(struct folio *folio)
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(mapping_mapped(mapping)))
-		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+		unmap_mapping_range_tree(mapping, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
@@ -4441,7 +4441,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(mapping_mapped(mapping)))
-		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+		unmap_mapping_range_tree(mapping, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..2f22fb0d068d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1830,8 +1830,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
-			vma_interval_tree_insert_after(tmp, mpnt,
-					&mapping->i_mmap);
+			vma_interval_tree_insert_after(tmp, mpnt, mapping);
 			flush_dcache_mmap_unlock(mapping);
 			i_mmap_unlock_write(mapping);
 		}
diff --git a/mm/nommu.c b/mm/nommu.c
index 852ec9bd0505..13023d73d1e4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -569,7 +569,7 @@ static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, &mapping->i_mmap);
+		vma_interval_tree_insert(vma, mapping);
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -585,7 +585,7 @@ static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, &mapping->i_mmap);
+		vma_interval_tree_remove(vma, mapping);
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -1843,7 +1843,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	i_mmap_lock_read(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
+	vma_interval_tree_foreach(vma, inode->i_mapping, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
@@ -1859,7 +1859,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, 0, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, inode->i_mapping, 0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..490a14691660 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -810,7 +810,7 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
 		return -EINVAL;
 
 	lockdep_assert_held(&mapping->i_mmap_rwsem);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, first_index,
+	vma_interval_tree_foreach(vma, mapping, first_index,
 				  first_index + nr - 1) {
 		/* Clip to the vma */
 		vba = vma->vm_pgoff;
diff --git a/mm/rmap.c b/mm/rmap.c
index 26166a6b8cb9..73673cd3961e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -3053,8 +3053,7 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 		i_mmap_lock_read(mapping);
 	}
 lookup:
-	vma_interval_tree_foreach(vma, &mapping->i_mmap,
-			pgoff_start, pgoff_end) {
+	vma_interval_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a..ce4ec4b71138 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -234,7 +234,7 @@ static void __vma_link_file(struct vm_area_struct *vma,
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	vma_interval_tree_insert(vma, mapping);
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -248,7 +248,7 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, &mapping->i_mmap);
+	vma_interval_tree_remove(vma, mapping);
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -319,10 +319,9 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		vma_interval_tree_remove(vp->vma, &vp->mapping->i_mmap);
+		vma_interval_tree_remove(vp->vma, vp->mapping);
 		if (vp->adj_next)
-			vma_interval_tree_remove(vp->adj_next,
-						 &vp->mapping->i_mmap);
+			vma_interval_tree_remove(vp->adj_next, vp->mapping);
 	}
 
 }
@@ -340,9 +339,8 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 {
 	if (vp->file) {
 		if (vp->adj_next)
-			vma_interval_tree_insert(vp->adj_next,
-						 &vp->mapping->i_mmap);
-		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
+			vma_interval_tree_insert(vp->adj_next, vp->mapping);
+		vma_interval_tree_insert(vp->vma, vp->mapping);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 64164e25658f..94442b29458d 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -258,12 +258,12 @@ static inline void vm_acct_memory(long pages)
 }
 
 static inline void vma_interval_tree_insert(struct vm_area_struct *vma,
-					    struct rb_root_cached *rb)
+					    struct address_space *mapping)
 {
 }
 
 static inline void vma_interval_tree_remove(struct vm_area_struct *vma,
-					    struct rb_root_cached *rb)
+					    struct address_space *mapping)
 {
 }
 

-- 
2.55.0


