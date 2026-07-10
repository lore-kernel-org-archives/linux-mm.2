Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D39C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA476B0088; Fri, 10 Jul 2026 16:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A8B6B008A; Fri, 10 Jul 2026 16:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C5A6B008C; Fri, 10 Jul 2026 16:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEB3E6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:17:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BFBF8F960
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:17:58 +0000 (UTC)
X-FDA: 84973978236.22.1E0F7A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 68C4C4000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:17:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crprP81d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxpK9XX46eW0L+tqH28ZLcMFfpOyeN/E3/HTbuiL4M0=;
	b=mOiocRvL6GBnOBxajE0o5YLtgh6waDj6hsoKpswY4eW2p4GJMnx9D0HPgb0zsonH4kqYRy
	yxPFb0Cs9x0Vnx9CgdNO9Ow6X+jfvPO353TaIokMB0w0I2JHiuUCFZ/d024MB9orK5914d
	7RwuwQQgVqaorFnDkZyaTQpQY6csv4M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crprP81d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714676;
	b=RpOjwmL2EFYQvLutmASNAqlueiyi7ej1V9IzgQT5sRoul0FfY9U1H4FvSD+IkIhmI40D7p
	cI11dCskXOkTsCTt2f0li9QNWWVcjjkzfGRnrhUnUkofOyxj4ikH6J/FXLB+SrnPtpbfLf
	AmMWpfiA6qk9j6JcC5Gh6N1w3vUyaPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD0C943959;
	Fri, 10 Jul 2026 20:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80C21F00A3A;
	Fri, 10 Jul 2026 20:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714675;
	bh=HxpK9XX46eW0L+tqH28ZLcMFfpOyeN/E3/HTbuiL4M0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=crprP81d+96c/TTwiZmsO+H7tWi1mNaoxDlqQRcSYZuQqqkg1QzqPt0iFZfttiZK+
	 t4WwILxuWLOXMO+/GKkcB6ADW67x/mjMGunr/40MELjJXsiE47AXvXvcbrM+Vx4Cul
	 j8JCYVYPrR9sY+nQK75daNWNTYL4FEQtE5ns/5S1h27Vc+3t08PouRetPzb7JDKC5i
	 daYQ5g0xkNxJDzAB2NgoXYWVT+B/NiJ59t8xKUhG7MwKImCSkPEbqyDKoutKTBdwY/
	 +NbNWFuSgmoYmeulGhIqH+uasLK9U97/UzQP8yowhigWXgAJhc53ZbipSOIbjNJikQ
	 uAEHj6Dpl8Brg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:42 +0100
Subject: [PATCH v2 01/33] mm: move vma_start_pgoff() into mm.h and clean up
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2900; i=ljs@kernel.org;
 h=from:subject:message-id; bh=TWkwoMMp5D7fMtC0wshgLRRXywv8s28zC1aXHfR5Epo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg62mKuRVT1v09eEFm5LHf4uv9XS48Nw4/CP+8KTV8
 jk2Jm+md5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiz88w/OFb6tCz94OiVED+
 k957fJLbm8tad3CHBZT0eOnuPfJ0x3xGht2H2C/WLgrb3V/0YZ7I7r2Tp79WjOxU1Yy53zet9Mf
 8DCYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68C4C4000B
X-Stat-Signature: 7tmgchh94mwy5ktdqordfooi7cuxb9t7
X-Rspam-User: 
X-HE-Tag: 1783714676-106340
X-HE-Meta: U2FsdGVkX1+FbAgppouz3bPNHDov4ZG78ndamWBoCmrEzn7UEkauMckVZ29m+XSOcW37TZQmadw19JfQHalMwvSjYvFEoclpVq0sn9qshAGVmoAOsL9TsZd7i6SblQDZsD8VSreMiMTh4QJlUfjc/vppsu3O5+d8eyXo4a19P9cWoNPdCxOodbDJujVCmMhltw6CfmH2bLtHqa3BxvBtnPh6PTso0UxgrPW8i9AIVpaIqLVQKySrA92zUxaIPFLKj+sj5x5a7lynhvBBkeEXvOuiDJUvegtCv4yDYwS3nTDpZYixfxBUbf9MQLHkcT5+ULJXIPCc5wjYg7b+KdWpISCnvEKE/judM/ipJI4H+aLvLgR228k7s9QgiQE6A5xLlTGAdAN70wGYk77DFjtd2WdQq+hK+B9PXJf0nhB/hAaCFg6oAJf87d9XbJJcyFlZj6gUf3s1SWQSUC5hkoYmmMK4xKRoKWb0tA/nJCPVid56fN9MCG9A6Ckm2SBPVDtBVie3Kbkkin0/pnS0FROo39f6B+G5WprPB2j0ZoOyfKLelKMzV9HgW5D6UyfEx8OkaDbKMhGHd+yrEWQOWSQBXzfR82mSHZ6prrBix8icPUNAZHG1cmDMYhM4YUnrv6Tb8qzzq5UdLyCKMadTGVv1Y0OOLfoJKFVPwpTdZQS3rWWTBCoQqGW1UhrkRL1MxLTgWM6G8RLuP4nwBsEiOL3mswDj1ASBUAZ39h6RyGJlxUZNCKuz16VRUbpkuUU8yQMLlwAVnLi+rr/NsgP+hhWDg4H+dkwNywiW4YoQ7fQTMuGANr1or/q7T+1HCh1O3qLWMa6evilWmkDXkzu/BonQQJCDTJ63theJykeDwaRG6yb4NgGEZhQ13UoaS+ZB7RX77uig/gm978E45KlpCnxJU+F+20XVwOCCkibWGU8JrV0rq35V40y7pbSXlaOokXjfzvPAZOzd4+GuZS5l7Iz
 xK2niLWl
 d5iauBF358tg58c/ByQGB8G9g79wWbDJd/2CJprxMDF7XSyx5/bV0E7JbW1l24dgN6Zzg2gnd3fsBOPqQWNwnye+WR/N7qzHa8svcsMay9DClP0ZrTRmSi5qISFIp78myKvcsnmDhrobCQyK9fftF03/3BDezvtFQTY7bb9tD2kixWy1YcON6RJh2D1eZZ7zAbY8/XtmNUVXU75/JbxdLE0HYu48oqTiKOsCkhnz/guoG4/q3paeaafokraLumDZvRg7B0qu7T5y3k5K1WGwd1FdwxIJb/fcxRagiHF4DDBljGhcSO7AVDMsweQVCksX0h3NjVlDaojif//WAHux06RVbvl+X/apj+HMXpmbGZianaSpOlwdH8m022SbHrPpixJvgXmWqadmSVifEIrbf7cQ8QBsZRlXfj0a6NjMWa4hcRVlEgOJaNv1J6vNdr3tQCwYQIGBIiKdGVUog0w3qwKwxQEnvhxP+i70+K/ioMF0e1Ld/mGdTV2TCXPuk02jekfXv5IAPYyRijgEwG7Kc1wQIv/msuLDgLaXW0jTsRpsAZZv5UyKe1hMsu0DIf3NJ6ldQAg+aXVxMddWQePfFI0ersy0XNpfVwKO693Nh0N/3HEaAKEvZh/J8lQXbQpfCTaiIhA4pyf49FBBdNrfY5v0wC/m9j9Wydt1htfo1jtGNDSpcVnA7Dft9bv9+VDHvizBJ63Lmho59kcG5WG+eM0DSWV7n8QKuDBL7sGLZd1Pm20sqJ+LxCAiiDkMNLoOM9lWrh11t/h27sILMCHhR/M4rUA1jN8ji19GXIHVREsHmimvlOB+SBg1/B3ATgtg8SJA5seZ1ACZ2bonb61NVRRLMrVami0rgByg04/OlvH4No+bJP/Jd0uunfZcEhV3z6zbW2uxxrGDwzsMs7uWqrEb5GrfsbwrhImk7f0rNnnTgXe4A6zojzU7Obaw2f/+Eqd+mehFrU4Ss2zbrtPYLqAsRJ6qQ
 IwCJ/PoI
 9IhPZ3+2z23LS0vYwgX02t6SRCcsc9RONmEkEK1FgV09JoWc2g2mgpGEOaQ7hz4XjL+NocGIbt2q8jU4HaS36r4SKojpFb6iGxerPKVi2WBaaNxLFj5zR+fQGuNb7PxMmTswo3S95tTKBriZD7HggoUHVky8t5cAKwVTIo+8scwhuQiQg5uX0N5eJPzYuGdWssIvdY6y5sQAB3xXV4jj6Se3s8WbUZgnAurgVTSSikVB5wf9GpodOShO7M0NpZw4ClNUMsdMTqm6eMsd2irQxTcRd+7q4vQKhQPlfSoV0jir/A1xTw4WwWh/vTEqghwUAGXjDdXRSo2Va4Pf+xhjWyZTJDxRtLkISIVGphgCo+RPjY/Hj6H37te4YXAjLqy88LVRxdxYsNuiz9IM3fiT+12EVR9/HLKZ4I5hcuz7oVMy+45rR1As3owznSOFu/bkE7ix3SJ+4F0bRTaOHjlhD+2TxiocAJ8Xmo53sR7QoHghp7eShuTlEO9YuLcZyZmYpkU1AFuWGGFY+3+b2SBc5gg9i+VoSfEw3ejFhceZ5o/lFGSOkKaXbJblaFsyCM7GqGPM4VSq1GkgzR8Sa+/0vm0u63fQw5Dy845E7txE5Cm7VTGIcsO/doDvHG72jiHwYpzmI9XDKujMjjNhrtrYrApmc3+WKkXbK2OYc8I3+BiEC6ptbzr3IYYkp8j2hXZ3AzcN7pWDfM2xpF1A0pVevxW/Y5ypQLKl+jL9rQbpBUnNu+/zNWw8bZcPcqSLsVGVxzigyx+MAVoDnCowq28bupnJYH7N0c/pdCzyF6WdzmB5N9Ym2SgIpBRS02+7Rxs7eo7bp+Oz0SKC5lo44BEwtblPhND0PBac7P3htofIUHG+NqsSI1zQ6PoEetHz4Mjp0TmYqojw9Lcxg3Vp5d1uxDr5TB1H57kBw2PVWzzOnLQB67LycEYBnqI4H36NrP179I4LY5aHguNA69Q9PHHykcPGORGkp
 48NU8pkF
 +l6pMYrCQ2OezowOlsdKReKryBuo64XDck3DEN76/TIpELB4ec9fFS+qrzvQgWszYVWmGIfCP9pZVVP8CdAoIWGYpgXGDTH4hHVM+AqgoPseOWtjLjkwFrjXVBDaBtI4a4snS6H1BX82ahBT/ersWg2t+LMQ1cuKOJQatQCcPJUMagG68rdYfB2/rp4nuwPTUVTgiGh3HlkitWjWHlxV9Cy8JzPvoNKsnl16UVkTw4KE5bif6BDe3WnHzlbdVc6WSeXwxDrnExO8XfvZ6VOdx1hjtdK7aaQHB6qovgy4JGiXTnBbfSteMptV6vJ3SvxS7M8q027adoAZQ+Ze7RPeDVyzB8hltgpRO0uNoaM30KidkqTFnk7RHWJQcq/87CqVIXx7p2bpEyxj4DUz/lrlJs1klFQZkhdPQeAC8AwwYaD8SmTGYZSNsNUeuskUmPdaUajVnYnkS6hm56a9EerDKwehmYSLkQdqn10vKaobuFxsoPhmanOwDVW+azWtGl15A6Mq0I9Cs2ji3LdQLnzLQp9kIUMDao+ZTD4V3pWu6QXaAsg1I+5pqin4y+keEh354HBBBBmO5FkzKrGPzhlEXIuzEabkwl6s6cq3+ZI0rn2NsL5SR6xtz4t+aAlHSRsXb6kWsW8IMrraZuvexTkmsTxT4NVwIqy8e0KJiY/Gw8pSHfaTdHKMFY+KxQgEwUwtL+KG0MZChobfm4tBRxva7OIQURDZxvZGtHT+DpTDJwwuJhc4yhGkk/e3E6aCcGzlT6ulkTA0Srrhpnuhe0/NoI8jjUQ+jvceUmn11bCsNHXbcFBPlK4M2Qt1TcG1Wrvhipbcpfxt2J9YIDc+u1a3pcKGGR/uSN9gu4Ncsfk94P6HGgb5rfA5LnP5BzTqksY2iYguOgxM2nQ8+9WKKzljGm7BjrgkWa2QxWrbQKyCs9bHlep2wT0mbINEueGuDqp01TS5TLR+LXia+1wZJJ/7OLyC2K0Wz
 cXKNSUAA
 2UxejdH2jb3awGXHocR6SlmQp2HW4HWgJ7iy4Mu0phWc8/oh6oaD7EWEYhQk5GvqErXCf7NeK5YaGKrs9k1rdv4Akci4cris5QnXrEPEStezfI5KPeuUKDd0CctBG6JkK9xQZVqkhZM1shR/NMCvDkTxMa1HedbuVfyIOA7KNkjXAoOHs0bXGs6I7q98YU51fdsSisrHaDIPbuFBMInkm94ELngeSG1Cpts1Eq6saLECS3gyKtRBQS5vVj77atDPzWJ2gk0GhGRFQzsvBdvjQKLwq75t6qEP0gVIMGvYwoZM7wq7dS1U0/YdjY82rdrBam2TVo4uu5TmU+XZKbM57ZsOt1HwB4P+R6r8mSk3J2efIr2nL4XwoejLQp4FlJTsP58hK9de2l5paH799BMANUMDDtIfsvjqXdvVa8jE/ai/2EauBUQC5dsGQrVL0SC7YXrS5Ac8LiDjqxETLcu3LOCJPc80dGl+Vlq7IR1Hz3me/dsH/oN3KaipLTX2t+w/2tFotybhd5Kqym0UZQEuuLRRTKEzrN5pZQpxGFr+B98c4/bFHo1hnL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_last_pgoff() already lives there, so it's a bit odd to keep
vma_start_pgoff() in mm/interval_tree.c. Move them together.

These each return unsigned long, which pgoff_t is typedef'd to. Make this
consistent and have these functions return pgoff_t instead.

Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
we wrap the vma->vm_pgoff access, we may as well use it here.

Also while we're here, const-ify the VMA and cleanup a bit.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              | 9 +++++++--
 mm/interval_tree.c              | 5 -----
 tools/testing/vma/include/dup.h | 5 +++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 25e669632d2c..09b06d8fea74 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4307,9 +4307,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
-	return vma->vm_pgoff + vma_pages(vma) - 1;
+	return vma->vm_pgoff;
+}
+
+static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 32bcfbfcf15f..344d1f5946c7 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -10,11 +10,6 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
-static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
-{
-	return v->vm_pgoff;
-}
-
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index bf26b3f48d3a..668650067c7c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1301,6 +1301,11 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
+{
+	return vma->vm_pgoff;
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);

-- 
2.55.0


