Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0791BC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F404F6B0095; Fri, 10 Jul 2026 16:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0696B0096; Fri, 10 Jul 2026 16:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA776B0098; Fri, 10 Jul 2026 16:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39F86B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:19:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 457BA140570
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:07 +0000 (UTC)
X-FDA: 84973981134.06.AD611F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 851A54000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNLB4wzm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hYSYZL26i46R1YNC969ZGJ/HD8KnaWEcgglVNhE+Dg=;
	b=WbMlKsbaYEolQ8knX7992d06tbweK/IvBMQpz8LBqGVvgLI9649besXjxyo1EK/e8a+XnM
	2FRyEKAA/geT0vMqJXxY6YtisCi2UO0G6g27lHVeIgMGu3KEoijxVkSynCfN7fyhBmmPzr
	BXd4JUrXnIb9FsHwVjI3+hRdL9jmLKk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNLB4wzm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714745;
	b=QX1Kzwe0nF+Ow2phYMbQs+DxUrqTAkVs77TYRGkZk92sroA15xqTMvMG0adCjCMFb4RC6y
	wt54OyqN1nWPnUy1ag50DIz/xrg2oF12Kz514x+iXOwhodWGp90DrX+9ZnivxmlBJVjNzc
	2S+j5QdjshR8APEv2yA397N3AjyoP9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23B64601D9;
	Fri, 10 Jul 2026 20:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322B91F000E9;
	Fri, 10 Jul 2026 20:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714744;
	bh=5hYSYZL26i46R1YNC969ZGJ/HD8KnaWEcgglVNhE+Dg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PNLB4wzmcFTj3lyqpCjpFNseunRPOUiWwMslZHwgnXN/dz1H6bINuUrT04kt5iEp1
	 +NIb6HuWlNuqv89DVOB740oeyMjE3pCofc2ChzUc2YR4KtFhvnDcCHt+4GCE+gyXWn
	 5N+MnWj5rOmm6UXVmu60Jc6I2MfPK0J7bSg9uQcFU6wtGwwH23rkV+6hwUKmgWbLk+
	 Tctr26pEiWgizGIADOVEl3UfVfSGQDtV+0/95Ja8Pr6D6O/cbPUvsrZRSsYIjPhVRH
	 yBJazCl6C5Rhic0/GCGXO+3WaXAvZ1vidl5uvgn9Xm7ag6HsGdXlfnoynuPxHBZ7uA
	 zki2RHAqu/Mww==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:45 +0100
Subject: [PATCH v2 04/33] mm: introduce and use vma_end_pgoff()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-4-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2641; i=ljs@kernel.org;
 h=from:subject:message-id; bh=CFZAjloP4OpDX/vjHQ9xfGU3kS1+MIW18Lzf2dxH2BQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg61qc+aHMPw9/vjPW+ln592Xp0tkZNzkUJwaKjbTT
 FZJejNnRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZy/Q3D/4hbiseXv3Ar8Z5d
 VZLvoZHiXn7OKMDymNMzVtav98Kv2TAy7BE9e6z/xf/4eWp7lK7lvvXZtTcj8M3OVfczJc+uddx
 9iQ8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 8pkexnpwpofg3bkrof11yb5e3pkq1jez
X-Rspamd-Queue-Id: 851A54000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783714745-461977
X-HE-Meta: U2FsdGVkX1/WrlO9Uoz9nS0jK6sphzBZcJTWKq3FfMOtB2GfGhYWASVpyYRseDPSd2vn1Q8vMLfe8ckl4zAGC4EDvx5DkZ7o1V3Txa3ibceHF/k8goBtnshI9nUDEIwUryaHM5yFUEk4pFeKsowCibDii3iy99r/0mVYAe4Vii5KV3BTa/TzgmkDOcVlbKB0ADKvYDTuDZtXL0/EIYvYfoFrOR67Rv+4PsWvwATk81zIGHySCXRUSZlEH8b++yEnvf6UmQJfQHJ5uZAtoTIOpel2RzZA5pk2IeVdmAWs6j6PB4VluXUcdcW1/bfGa7BBt3dt0FoDvF5MXlgakh2ywmH1/BST7tYAHAM/7qtTRfU4JPSl3Ixy/rw3QBn9DMKLQtRyfvCIWHLXDfnzQQcoxO22veaQFm/9i9xkA2/Bge+gD66McdBN+nXvwYsy8xRvacmfotRXMyjTSlGE57oQrm60GU3rfkzn4rlg7I+co9wvP6ZsTWqOzHxUUrDzOQX63qSmBdpGRw+fgqw8c7WNCGzJKam4cYbwbDgB4yvsEhqFbcK/0jfoG2ydEsT3LUrlfwdaLEl6gVEXEpggPH+kDGiMf+jvCHZ1Rvu4UcXRzg/c1DBV9UtoM7OVM9vG24/iDK6eyDfh3wMfiXjtUXao+hhxlM3/ErwbeNeNKxSa2b+ocnMpxls7ME6TOJWnF6Clnatvo/RDqqI39ZknWAnO7OZmN5aC4CU9Pd5kEDBhp0I+3iwwf+i/wFIAilsyTbAvLcLrKpkA4OkUm7T0cjSLJaBq/BVTp00eE5CJCE7KQ9lDFMKyXtiReTwq03hLcMY2FjNzod9skDcAInvgVC1JQ1kkT9Q+MeMmWzniu5J+qrLHb/zoBp6AeS1ebSI7NF3u5DDwo8pT6fCHNY1rpD8rty0yY7tGZYwOv/7L6i0/xpy7pUNe+L4/sYY6nA/cvnAi1e/s+Px+crKROaPwuC0
 aRuudjmy
 JzZ/Rup86+D+//xR9SqL7sg0L7mfuW9MC5NdkwaCCjxMYs/jB2SysWmu+nWa4DMUAKpB3AfLFmUYoPFHuGKChriQJux5gpUkAU3B+fU/iUhIe8I6u/N8dK5qiFKhbq54mvrAk436vZmjM2dyi3gbhPmcgSZtcdaVvQUEkB76ZUxn8Wmq0lSqLnoCHsTOPfgi5c6hQbRo6hSiBfIEMO888NVyjeyfLDq5YKPF/NZjY/7oe59FwRlS5WEwKVGvxOfJZmQta8ECbViEPWQrpw3BWHech7DnsS/mKNADCwM6YR1LjmeMvdw9hkeJhNOeLLawMWaz1mt+o1nGqwnEO8CGXmzDYBe8eh12SirG+l0lxtbyPfiOeHDHMenfattllqliVUPkNLuATnTUzsZPFTEkRKBaE0DB+cA5hJ7itZvzUKVp/kEDdhT8VgjOCqAyAHy19lh5OLph4larlmuloTOnczbfmdu8I1hlSmoTZvNs4/7NGDZmwtqHOFLy1TUcdru87J5kG51eZvUV2cqEPea42vctnBgLVtvN0pB41vKHahFdpnlFqRts3KaTKhbDpUdfUBYwnJcQJAllhx6pKVRhLptefTJLwDBBzFw7KxTH7oecdA2KdBBT+GUEQuzmvkYSzsXwgPnbB/OzW4rgsHPIldXFqgQyp5uF5JIbJ1LxYh6nU48uCEOyRPufxKjy7mUFHQ0bVpPM9eIIVjj/WUkZbXc0EP6rKvhysEJtvH/yxEqFclGTpomj0AmPseGsDCR5TFJ05VOTpcmlQIom4qs51/H+2nh13W3lJ2uJ1qRePuLEEyZ+WXDNrGRCYNJC8zyOXR3ZE3RfS2kPpxQjIzfF2Do20DZwwSzB6lM94XQ3rFKJRWYUlD8WKdP1ob+TD2W8+hplZHAkaQMo5dSJUFRG7+80l42kOm6eL/g3UJZ+KBan4xD23WqnzJYD1YPxibU2jyFA3k2pz4IRIKUibDe/FD3urWPk5
 b51Gm9Z7
 gJjav8aDlUI71xX6uiQ/oZ2yA5yk2mEyqtmL4y1NK2PyVVQBU1sNEBARgKWtp/eVUlDUSBpbBO/oZs5ivwfFUpDyKBPnQnSCLKwUTYO6of+2sHAGdypOM3K1yxD82luASQS0ZnKnSxLERibaMW/IY6yDVym85YC5aE2on9Vt+dufRyYODUyAF7vigfkW155GNQrGSRH7VWhNz2G8zWNkU78B8sVo1GJ0GyvH1YFIGio0sRjWQqLqNs86HEpac6HuUjF3Uxyc070r7+I0HXkw+2JdQIpbfsN/DLlAKSXgGB5Iqk17J6NWrr3n2lxSGk404lY/ybs1kmOsypv3YzKN05foInt6hAToz1kP8Rzi1w8vCENwt4Wg8tNVPENBp3W2AnLnpt+pZX252OAbiDXKAR2ribpsyNis1hjSmUU67sOYXmx6ENiITjHQLJ2f6zT34JJC2gJ26EIWC1K0nYcxuMTf5/EyYJ4Gz4ssHU3l/ypgUKj29svRFC1EptftZRBgpD8/56pbSjoxm5bnsA5Bt/nErxEVLWSyYWyRuqFIIaM01if7eZhQB7cibouBLujTENCqgDY5JSnaRjJARFzLGZ84X/cdvkYEOEewHBzZQanPzWtjVRNZqP0WZ1fEqJ3kNX3jscmX4bWdJzzCmMwalbITPPNCui8d/+djokVuYNRjEIS2wr1iEZpETyAukASO+4bXvgHH8ECD9gMGu/nUbQ9M6CXSAM4vL9fB9bTnkP04wcDtFwlW1VWOGYD22RF1J1ug3v0tIyz8YZ2ignICG5oRiluk6H+v7Pmj1m2E+lfaEiqBySQtJW+CBkL8TExhwsfxKlZA+K3AyVkfAG3etiiAs1d6EyfWkOE84ewLX8GOYQKFPBS5f5ME8HM+BJNH8ElhhOZABO9RyGUCsVKVVqBcrRDNgMkxfEgAzPTDnQ1Oj5rB0kaGIaJ4OyB4BvBc+jtNSyHcUNBWaKhV2CQ8O3VYJtook
 3jj57Hcg
 7wn6HIAW+6qDkfGqH7XbFDeOjcKAW3lfhhD3XOooFDtaWchoXA01Wmrax1k5y82vCaUiBDFHK9ay3adqDl8Q0jhWtzFTr/TjNIBxnia9qozaUcf48c4bKYsonMJcHcefV9OnK0Uaz7jJjNurr5Wu4qEl9q81nOMyG+fJfsySwv1Vs++XdH3K56bPyQewWMrGIiNrWfkbOiA9Lp/juzO8U7TZfk9JIP/2940Doc24dVlHVnknhM19fDTaeVF8ceaaMZIF7ZjCnN+MRgsu6L/AkjHWhFPvVMgq22RefBuvZWfe7AaJ7U4te23oa+hrl3Do/nn/Qz3YmfMa1eLXgg+T24HzUqqvq1Uy3ztJW4hhQy9Jl3cLR6jcMF8+wqgw5knHsHPvcHIOf+KwQ6tZm0yW/M+cqgJ2qFPQvOBhSyyAbFoJ87Jjvdbu7PnS1DTICXUB+b+TGtTm6as3iSGR7OFl/OXrTJ3mYdO4mFgrr1NG+IzFoiVhLuCRE7nd4VDX19EZmMaRDKQb6LIBXDwTh/nJWdyRH4+IzD/NrBmX6nBSX07YUJw0YdMQvz3LQhtbXaiXb8Ve4I2plHHE2ufoKD7osJECSCEqkBkkNjvLoBrNLiQUiw2NWfoh1KtW5NxyMvTsNp0EhhGTc6BEZwvEK/MIODjsnYB2HYxYhtIx0xIKGtzKOggLkNMRPZjBT9I74hn293MsriONe0n3cpkofniLVYcdPhMq7D/EJhaDqvPKs2ewceo5nUTlnC7vCJidGCqiUf3DGDm0bwEmpsCrKT3wx8f5leZtCoLcmuCJ6mdZKha+dBSojQK2KxI56Wzuif5RvB7zpSGCdMD76WBKdwZHe/tR98Fl8Gvk6INlN7k7mpYojTXJHTwNH+LQvLkMe0/WQJplCmA3cjJ1DrzzsD46S08o1K5rmTYt7AWbETen62PscVH1PKpJcLYJXlxUXK4NJHNKbJh5jTFe4SbyoRPHzN5OiwH8G
 KLYVc0Gx
 f1aV/5g1s91LT4xzOlbNQ0F2sR+lvj63tSjOuRpVcjcxZFeb39zEPJ9lX1hEOrNF8zQDTYXTPvDtuju+z1g2RpRoX/l40VBd/6qdsjJ4g8asLYotR3v0sBmeruc035SFLVKQcc5aybhk+C7CNwg5+MoLKud0jaaWsbylpyWh+gP9AYGl/fvp43MtZn86uD7L2f3ccMu9SSYFEnD+phb1un3VuhatU9TxMoLe576QCYj2lWnntN7mOt+ve7FDYbtJe9QM8f/2BsVMLj8FyXK2TulxSrW+Pmw4rXbQvvUb2EJZZ5Z1VKAMXJVGoQtQQeqPRj7rfgA5h6fOoCuUiTLm9lKckBzWISA9SCuPVFxLI4n0U2InrxKYVaajB1V21FsVYau6MpIJw2xEDnZiDrApBAMPExBOPRZlIMAsCqkhotD1ojd3Uyar+uL+eJZhIc8J6tTwiQS9fVAfD9KF/ENsm/ZbALf7YSH39QofsXctwVKXgCcjetfguM1BF9uutELscH5WSvCLO/cOhRThnn/4DMutljFHx+UIXVcPFUjyMzDXoG0qoalEPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already have vma_last_pgoff() which retrieves the last page offset
within a VMA.

However, code often wishes to span a page offset range, which requires the
exclusive end of this range.

So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
function.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              | 19 ++++++++++++++++++-
 tools/testing/vma/include/dup.h |  5 +++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index abac72785277..c56ca22d406c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4331,6 +4331,23 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_end_pgoff() - Get the page offset of the exclusive end of @vma
+ * @vma: The VMA whose end page offset is required.
+ *
+ * This returns the exclusive end page offset of @vma, which is useful for
+ * expressing page offset ranges.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The exclusive end page offset of @vma.
+ */
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 /**
  * vma_last_pgoff() - Get the page offset of the last page in @vma
  * @vma: The VMA whose last page offset is required.
@@ -4344,7 +4361,7 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
  */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
-	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
+	return vma_end_pgoff(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 668650067c7c..535747d7fee4 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1306,6 +1306,11 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 	return vma->vm_pgoff;
 }
 
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);

-- 
2.55.0


