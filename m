Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D02C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD226B0093; Fri, 10 Jul 2026 16:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EBC6B00BC; Fri, 10 Jul 2026 16:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E678D6B00C3; Fri, 10 Jul 2026 16:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD0DD6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:28:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ED9C120434
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:28:23 +0000 (UTC)
X-FDA: 84974004486.21.C3110D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9AFF9C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:28:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nbOVHA9/";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdCumzx1xelSik0fyWFl/+tFd+Vg+MajMGDgbY3wuuY=;
	b=O5imOuUOT0ECZOU46h9OU9Oa1aPG4OVXNG/gl96CwpDc0l526GABgJpUo0L012Yw3ugykQ
	cTtXknClauE6uGlCGVhUx3cAY3HHxI4+smngji5tY8+s8iTudnUlJ92cL6quRfpwR5nOGR
	HQtncEzCCOt4kP3jAlqntQ04vJTgsp8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nbOVHA9/";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715301;
	b=m2v5WHIcfqINNpkmVM5V7AFoqZQIz4mJybzrZjFKHTHT9FjWV1Xq7dWIzy6maNV1HiEbkK
	VMqvq8w9rUkHxVAkQ7guhjSUkLeuDOlxoB4Nbup+oPazPOAKIjD3YAyXX5HomYZ5m9a6ni
	oP2WKMIecCy581Q8xHbLN/nze/+KJKQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16EC560052;
	Fri, 10 Jul 2026 20:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21181F000E9;
	Fri, 10 Jul 2026 20:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715300;
	bh=LdCumzx1xelSik0fyWFl/+tFd+Vg+MajMGDgbY3wuuY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nbOVHA9/IqtgT9yYIxrcLftZNz5+z7/zCP+yCH+QUdbK0dnpIUFHQtvr6ma+nj8P6
	 ysVgzYiymU0jAt1iQ2W00psBUmJek987sS5VflSd0j/3ZCVQ6W3fDGzRjBDcoegU9m
	 Yc//0A8XW0dKzd4Ep7xQmDINJJtYg/4KxvbspQnH/3XnBxrKYPJEO75EB8xqd4xStI
	 zitF7luU1QunXTFvRCu1WXI6Wi+WMpsOlEgS8ncYsxP8WPLsMELJsBKhb8kG8Wx/H+
	 n118w20skvYfrzD8uuAYvlsRmSAqaDrR7fXYTwGnovS7jaGsP+r78VuXjaDhZ146qG
	 bYYeE+ael9tjg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:09 +0100
Subject: [PATCH v2 28/33] mm/vma: slightly rework the anonymous check in
 __mmap_new_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-28-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1719; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dboRvXWKwjAOOnw4xnLssxAAAPh9/O2DaTnoVWEou2M=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg22NmVgnP3fVulG58u0872fre+WmGyROehN8o/9Ts
 T6jYolMRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayUJOR4YuYxPGH229qFD4V
 j7uXvmN75fkHHwzWrvrlHzjba53T6bUM/70izzw9c8CzdMUxr9Li9gQOreMH7ZjOPqyPkttb0te
 hxgkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AFF9C0003
X-Stat-Signature: md1m31f7mra59jwtz35gtgfjtzibagg4
X-HE-Tag: 1783715301-380010
X-HE-Meta: U2FsdGVkX19mEYY1pgCDdSIPlpjI/GCVFnVPy8e8MIB+9zJvdCwcLE0kexvgwb0JvtDTekgBBgfEWZQXQ5H5YQTmO5fKxWlx3CUDC09wpcTKUhYSSA9NbtmviMP+hIfe8EAOEpcsjj2pBJjyf6qlvL7rKfu5XvJjtsPxqCoUB6dzHl6yMqxo/pGwODqWTQJxHEHC5BZ231/H6PkEVqicIBtnNmKw7gxAbxS3J2fHZRhFzuHoCUNmxKFT97Ld+QAskKGFSbXPwhG/fbI+b1obWeH/tBQ4fQ0DaNJbERrtbia7Y1IOETeUgwA25608jl0Uii+poz9I6HRpNu+RUGvZ2UWmFVMMFIYIFM1Z7k2t+x/yRKkng3oZhWG1bXvkZUYt+rRFXeURrR4nlbuvXJQ7lcZACEearbJa1hBCj8tXX0Qxkp+MOHtMmtatM1TarU8RFvSpUd7sL+Pw3eQ4u0Zrth6XQXceEBwryOy2pSDTbqLhz+/DNTIpZot0oroWadrb/JEy7S2l2BFZFaVJ2vEx3EJF5dXqcA5WnwNyeV1bQUhHgkXK9gNYM5nKbPtoTa6hvtrODLcEz+I/kmrVWqfqwvyFlJw1Wj6XZYsjVzSuhzgSnhlFMFwxeWcWc2y0luv8oZnWvrIL33OLcbbfIi2cOKfa8RHG0/8OuInHvz8qu8QWDjM4D07fcXujRfJqu1/CNNvEMBv1eYbWmoM2EhwTR3wxtORy30JHzhBpKmIV0RiFvZa5Tu3rUgeHBO77Hq5WJaHO6R99yNPTPmxgcJx75Tfyz+DPwf4r9V2JJFQj9yIte4US+MZwx/0ebpbW/FqIRs0a6dl/f1p904UztPT6pBQIMGgIVbEzQCnJrPcUTZ0IgyEvc1nvSbfYt40nrPqPSbM8IeThr/TvfBVV/tq6FNZoR358dBPuXKOGJ2PsNrkKX6ZPP+d/qxcn1GmYZZs5AHdBBljNiYUKePjj6Xr
 rv2ZQ9ej
 GK+8opVbHrDHOrsvOK65jQyrrf0UEOlYe6iZDW4/40sStbAnVuy3sl6AxlfX/Ksw/4rlpigkqt9PLfzdqlA9eQGGYxZvucBqH0rmPcKXdlsNpqGylZ3/mt1uhWYsu486P+XRnl0eRYXqgwvor0JtKFTYJzp8pDSnVf0MakHobbHSdkZDn0nR3tktIlHIZ2Skr1qo3rplPN8ERzyGFZQ+9U944Qwc2KJj5OrwTqXEg2arx/iU2gZ4i8v7todQbktoM8ScDdmqgy0nF6K6UMw/83e5mqIZnK7Hvwj64eLi8+vSsv++XVIMAPty/4sE+75TJfyJF01nDgwJdUKZ3nvjexOteExH3ZOfK2t9kmDfjyb1+/D6uXEpB1hZxO5GaECHyLboJ9bI/eLPZBz8Zh1u9/3TtKTrn2k72EHL4OLjiweQCx6iqpJjpg+Dr6it4SmP7J9fKLbq/01sTbrWcjFzTuZyIjQeQ1YIVT2jRNFsUfH/mA/rteGLV6tORrOYyT4IZqqQLzdVVG3R/WsVDgKs4MJMVLBJjsqWTwnh44V26eNd5oisSWzFjp/7L9rhueiHhkHfgyYVoYWDp96YbPTQqkJUqc7XO7uSesFjt2K6KFhVGDxNksoK5MuY+A3TwgrkWDnXqsL0qzhocy8qvgchPmjFwkAzwmVPOUM23c00HjTaQIb6L2DDAJHnLpzAKKe/JuZcwUWat5uNMZtwQxAi+jxQDautUsTYkcSQ/ZCEiOOpTtoJ35v1xikJ+JcJL6eDAlFcJb7Pmm13fB3OVS5WEanHcggln3kTZUIEv0CIOOA5V5t1I/V2SQ4FofDrjR1h9a41qHSIeZDtaM1kBuFKf0GiK0UFNrA8b9AVdF40yil7JU04NqHYqhotvWPl1NMzJQCsKQuY+fpB3fp7MTLIgF7KZY8ztH+0+Jw9gdAK6potQKz94ELACcbfCe5D2gnUHQwNBTle3X86ActG3RYcStZfgfe2S
 ZC+qtu3Z
 fGN7l1ZtjbC2+nyBEnOQAjjiaC44LKEnQk+S0Arco4Nq/w+aug08drLwW2p5bCyIYaWmuUcWGxOFNB0Hrlv6fIZMQUz4p1vagamHR9S5d81Hpd/eLXcoJX2XWxi34oQk6N0WM0PkCXgInYnXSveqMGTIVRqdTfgWbcgcb7QdGuCYPm3XRf6u7+QxsoEWXI/ymnBf/Vp0r2shGuf0lNpYhWbXAqkDZ7TFbm5kaJpgUY4CHgdNlYGDK5x6x3Ke70BDwVAlwnu8+01ewUcLy0T1F2SZbKPkIm3ZczRpoWYfoP9EdqK0MKcAgTuviqO0dC2Ns/HRCRJle93IU/zLZrFmKPHbVBeNc1zKt5tLH8YXBDtY4DXiUUCPZG5Ff7YaGPV2WUxSso7QV4x715h9OgiGaAl8HqK0R6EWr35Eeyf+bgs6hmVswBgFMDRyputJ7UWERmm+TlbCyTutaAs8Kj8kQH1HC6WdJ0JZSZRZamjdjqMbwb5NEQy4nuPBywiXCjBrLa5otQ90nQFWbVL9KQcWHDcroHuv67BOKEuqCV49w/snCcuvlKcC+savKLUPO5Fn6nxsQneYBd8XIQLMUpNpAnjgf1YtiwOI5AnEgRMbZ3I0Yy8VqVtxbGIMbVhvq8j51ut/R4xW/J7qy8pguL0VS1n3jHxb8yN/GAe5vcjfXxUXF+e6d6ePp1t0cr8B7zFPi319Adhn81381rGexy0/ywHr4LylYVJXt9UhWZ+JLrM0Gm1iUmwrsxhZtmYYqr5L9fhwkti0MBU25IjtUFo0tqXOOfS8u/vQ0JQ1O/GOMje6vxroAgmUTfXZ99acfWcixTV8DisRCvZvcqrC/JqwVJ79n59nqHLnbtcrJKhNoYJd2TkmVJdm+xvDR/WlddDu+46vNMiBOuoLd4oLcOUNT2F6lNQQDmlE/sBTbSAXCqxGcN8z/8VQ0jw2L3tllwSo87y3CAGaqLnDlTlp4sl528AdRrjpl
 1RuIKLqU
 SSLJnBTiIYWudDd8MyVxPXFLBmr9CuqGGim3t920pYYooXEcVm1EJJK4GnKsvobkao9aNhNJaTj/bwpAINIgVVs3Zv6vbaBzNZkc4fzMDLL3L9HVQDLCN2a5MmUpwS4frO1eg+Kx7jQKoZCZSrGZc1QBYVJhL9RzufK3cebt+Xb6+ouQ44aF1EQ4TJxmNQq0CnlEFPpLxPNaXqwK390ptWj9/1Docf2+lbH7Yy7KjozWTZDMeK3mgRFqiOKQVTXkC8tC7xBsFOaH3atW8A7X3R4hNCROFAA37RVcR0egU1fVcEnkDEdm1leaBKpYbS8CWxr+etXySOiZSaoKrNEyJmnckkEQvOxN18VISfKX8Mfd8fzRgySl7MmJPGNlnD6+1MBHosnnjuBrzTeg+8/2IuID7j/jRWEr/ou092I/n0achVHJmgS0K2SxbZuAXTqS/FbOy+XR/kYz1TmoHA8rQRf3DGcku6g1olziNlAqZ6oF4tZK4FS6XkrrTvv5hc1qGfHUnYinulFkvaNuNUmLJt0rFhkIKwhfLLd2xlKgXzddiw/VDNabrmIUa2gXnqj1kQuGOB+ChFr35Ci6yq1Y+SxM8nOCsxjlpKEyxH2EOh/AYWw8AN5kv2wMO6hoekRFIAQSDCgyQUfneMBqymevBIR2XdR0W5kazQq4aj2lohcGSrVBssW2k9N8/G15YkFSTXktustARnUHf3Eld2fwXD5HXkW9OGN73DpOOK+uQhD0GLwQWNKTv2M4QgFwKTkFqQdpjUDL2F/X7+TIO6PskEb1WOtYUsb6eoLOVhW4F92Cy201ZzKzNeR7rGvWmLGwpOZ5KaWohLZiXEDiFCsohYcvaUPdzd8YZJFZllpKK49EnDr/2vAIQFsbGH51qiVwlfvneEYwnzAsh2APduh0oqQAKA+WJ6EAN6SNm6cD5TOjBEC2kMRLQUV8jikjInBV2uhAz4QX34N+dHEO0SQ1fVbbj9uz6
 j9mfk2hc
 i/pXO8ud1egyPeEIboBLWsR9HJw71UJqd+5J4JzcirBt3SM/aLyfGHK9yA0uJAALan9uDrHeNlvaqqtCMBS60BBix9NKpB+mmwDCa+R6vMpjt6xDXD5B1ygyHsVV03Y38V1VxJkfpDOWOI4JvYM8U/CAhB0rh1dsH4UAwGTEw3A5kbGvDupp0qiDlntnnX+lADhN3yHnIpDNO5PhgU/OupgqBkMb5R0tkzJUvzCdwSBUJnSQTSvFyiJ8LIjh945j73B7KtPhFHd+1nwPh78xTn5lF2KJKA+23M7jj7DZZ5V2suMu5pb2EATSmMowPuRn8NLR7bvEjv4YY95eXSk7snnlyoJhTzPwraZnFFm2j8KcIr8wVsasJL9BtG7oiSzFW7yDP4Y1JZxJw9ERKnMfQ6Sxi3+zQnvr/80ZhFNV0/leW+XG+HzpEyxr6YnHWC16duiiDrUhiBSeRoMZQOS0xMyj5jIKh2Mj8Hr8FKG0nWYFHN8FYP2sI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Determine if the VMA is anonymous early on, so we separate the logic which
invokes callbacks from the rest of the logic.

This is in order that a subsequent commit which asserts correct virtual
page offset for anonymous mappings correctly asserts this for new anonymous
mappings.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 0699fa07c40f..ec64e179d2f9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2587,6 +2587,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
+	const bool is_anon = !map->file &&
+		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
 	struct vm_area_struct *vma;
@@ -2601,6 +2603,10 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		return -ENOMEM;
 
 	vma_iter_config(vmi, map->addr, map->end);
+
+	if (is_anon)
+		vma_set_anonymous(vma);
+
 	vma_set_range(vma, map->addr, map->end, map->pgoff);
 	vma->flags = map->vma_flags;
 	vma->vm_page_prot = map->page_prot;
@@ -2610,12 +2616,11 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		goto free_vma;
 	}
 
+	/* Invoke callbacks. */
 	if (map->file)
 		error = __mmap_new_file_vma(map, vma);
-	else if (vma_flags_test(&map->vma_flags, VMA_SHARED_BIT))
+	else if (!is_anon)
 		error = shmem_zero_setup(vma);
-	else
-		vma_set_anonymous(vma);
 
 	if (error)
 		goto free_iter_vma;

-- 
2.55.0


