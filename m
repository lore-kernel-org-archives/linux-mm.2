Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94091C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5986D6B0005; Thu,  9 Jul 2026 20:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547F76B0088; Thu,  9 Jul 2026 20:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4605F6B008A; Thu,  9 Jul 2026 20:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8646B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:13:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57AE41C3391
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:13:37 +0000 (UTC)
X-FDA: 84970943274.28.68CB527
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1C09180003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:13:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUyXaCZA;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783642415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gjBmaqSneqTuRoIZKmkOm++Q8E0rqDqKSQfqW/IN64=;
	b=s10zgPFQJohOA2o3eFZmJ2IC/uWYAYCXezYW2f5qCp8Nq8upx7UCZhiZwFvpQqK4FF9ebI
	rdjtpJDOtJE9DjQux8bmB1kfc/L/+/xhgECaNq2oPZkfydfIn2GVQ2NYHSYg+X7PU02cKb
	HXGN90l9eYbq6fTSQUC0PcAngdYrR7E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUyXaCZA;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783642415;
	b=sGAwEmV78RAHTqP1MoNnHSSqa3PyGu+IWH+y4nligYemT7nlyE52ZU0Feb1Agq8tO1FrjA
	59I7QeBMRQk12g9cvtQCFYEDLPO4ElAqBBdpNg32dIEfF5CUx9k1AHo6ma9nE8jZy8IBuQ
	FWAnI4ga6z+HKZJ8+gFeSaUMBpwJCfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3738060EEF;
	Fri, 10 Jul 2026 00:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63B81F000E9;
	Fri, 10 Jul 2026 00:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783642414;
	bh=9gjBmaqSneqTuRoIZKmkOm++Q8E0rqDqKSQfqW/IN64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUyXaCZAaX3ttnttEEVV/zT4iS+V7t0wzxg+ALl7LU7XP+H5rZ4vcZ9K0mwASjdKd
	 98z37XWKnBN3JSgoRN8caw4/S9K98lzFFehmZjq9hOo8rkQC1uWXYXsMekk0zkxVyQ
	 WWFZTcox/X8ToOmCS2e+ev/feYTtU9T7ZM5kWBL7cVK4UoLTJmb/h42Di5LXTKuGO2
	 aOwnamxhd2bD3iLH4hZxQEjnK+q7zhlp3YR8tnI87sXVHbk4+EvMQgfR+GNtxsXtTL
	 OmsHiyPSmTfaqxdRILAtu/Jd2JjEf3B7kN/V6xOkOqU4bWdgGxZsCJPMt+IfVu+eUt
	 RRuJtj2DMafnw==
From: SJ Park <sj@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Alexander Potapenko <glider@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	kasan-dev@googlegroups.com,
	kexec@lists.infradead.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: split a couple of headers from internal.h
Date: Thu,  9 Jul 2026 17:13:25 -0700
Message-ID: <20260710001326.110758-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709-internal-h-v2-0-695631425968@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1C09180003
X-Stat-Signature: 6spt86oemm4u1td7fnboeo4qyye83g8i
X-HE-Tag: 1783642415-610837
X-HE-Meta: U2FsdGVkX1/v1kdv+RJU3xQEp7VTqHSFNOTgHog/UdmuEnjXkwciRVNUKHKH33btHbPTJ/pTj5pOBzdRGz75wZp9JK1YiiRLBFIKEmxxkBBv98ZK44F5JYIaj2IaC0ZfVUmigfYZgHRFmTrecluv7NrKjtjkRY4EECnahLGavHW8K0mmEtbvTM3YrRMr2f/vL33WfS9z4BJu6N2ypPVedv995nK40ZAJ1CHs4qoScoz5ksv4lKlPpL60DLbYLIMe8hMG00HLWfKp9kcvM1QLEWquS8G5ygTeCrSxj8DUF/9CLA/OgFzDuVbbPwfrOjKAHOD4IWzNjredjSyNMAccZZFZaNTE2/6eJYRJct2er76aJUXVDTYOvI9G7n84sxBswpyGlAlJ+m3aNvvx6Ep2ee3OsN/dwTYdKodF/Qb5rK3pah+2Xm243kSqypWPwY1KjC0YZcOcAUjOPvYLdypFe8sRR66UMIYMGlf0jdpg7QktLq7YtILAZ7Q9Ui8HFkxvDg223xl29hY5x7vmUoD19HszbhuJxuIpz//XWiFZrh63/TzdmnnGAPOCCEYLjGwqrr+UnlKM6Q8/sFsuMESBGqzNdcDfiNC8J7Ja5roLTjDJPJZsMS1Q9Dacq6+x1cKdF3nsa74mZB4F+/7OwVVwrsGRyUbYKhwfmwQrF9sgUryKq6xDgpLDI8QPH+wbmqFJ+GWEK+f/eFhaXPTbTniqHMki/BE6wlK3S1Ti9naY/g8gKmBACFuiK63RJg2cMUZs8GE4HZLgLwpU1FtoaE6//4uoKFtq6YWlgWRerR4zJlUoSGdxRhMnrbuUnQZiCrx1vgf4mECiFo/5iv+XNVEp9s/UaI/VFNClkFwKif9Plxf/E340hiL8FWDwTteruluTljsm1gp4I51q3AszhkS6Y9UCV/O8NsbCC2DaBa7LK6yDBUujjjIb9Z4RrdwqUb9duKTcYETGmrqe+JJcdco
 G0esSOmU
 9LxuccZZcF6yP/8TpXEot5xSXvW/0mP4DrpMXlfjJ2EcAY9glVhcMxvGU2voRvKy7gaR+ogHC9LtK/YEWFAWqeXoVuV6XdvRHsoA8XFsM5Ay/H+4uhQhKQp5UIEmWVqWS2KT2dKGSNmynCrQwqEddpKepubzURH1xmQiYKLCQCEu+0fd8A7Q6Z2mFrtAVOC6rCDE4TrmHji4470neU+YbIjVoTR51IQC29SNu5AckpnU86Rs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 09 Jul 2026 13:00:02 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> mm/internal.h becomes more and more bloated.
> 
> Split declarations related to mm_init, memblock, vmalloc and sparse into
> new headers.

Nice.  I also confirmed I can successfully build mm/ for my main test setup
after applying this series.

For the series,

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

