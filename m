Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B103C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50BD96B00AB; Tue, 22 Sep 2026 13:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2C36B00AC; Tue, 22 Sep 2026 13:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2136B00AD; Tue, 22 Sep 2026 13:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0AB6B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:15:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 797971405A8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:15:05 +0000 (UTC)
X-FDA: 85242048570.09.1D86349
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E07140014
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:15:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=I3OhF8wv;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1mYrqISDaS2yPZwNFueuDbGUgj+MleoSKc748EROD8=;
	b=OoQzBtO2Mu5d5Dc7IDfrybigTGt2SpKdC/y3FmFz1GIgSZ38cvOWhLjPiDtX6CMnHrIoW7
	5A92BC2kxQ9fERWp283GdjrQ8oXYmmZ/Y7cw0iqHnG/gReYh9IRjJ+mZlFMQINoW6fy/1f
	BvCAcyuZ0yBl+cuJF7Mj/kjJUPh35kI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097303;
	b=LJEDKVdQhh1Lri1U/sy3GIknl/WTeI4souADnBTJ8Mu6XXM1XNzCh7nTw3N/qIpyI2Tvpp
	LL77R4fxNzsir5l1TilUudkduA27RiBBNJqR2BAAHl+aMQW68TNBWy0K54cpNNXS8wVcpG
	96KRBLWoXWy9vLGaWt7W7p2XDdXW07Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=I3OhF8wv;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C71EE1595;
	Tue, 22 Sep 2026 10:14:58 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 056A83F86C;
	Tue, 22 Sep 2026 10:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097302; bh=S1+moWK8WUqQqBwq12CGGS95zxJn4CEiSQR2ZbgzAjA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=I3OhF8wvoUdplYbIAxprYhaliSqNizYMQQKPtaoeJ91myAacTy8wDEGp9P9Hk+JYc
	 Cxti/txw6TGw66MJUNH7dnKqLXhJcsVRV8TfIQ9DU6Lzstr1QT53ZIGBG3xPD9QBrO
	 98HXGpHEpdXb5XLelYBAp6ylu9J64MVVJelAF18I=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:37 +0100
Subject: [PATCH v3 9/9] xen: use hw_pte_t for PTE range callbacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-9-5670b8cb9059@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
In-Reply-To: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev, 
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: iq3wwoqngqjis6kskhj38uxxa3ipe8u6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E07140014
X-HE-Tag: 1790097303-315831
X-HE-Meta: U2FsdGVkX18y4aoyRwd1ftnkMk9xD+7sZxfYedd2pSif7XM6C1IvA6/bRgpCaXnsolVe0o2yBjzJ3W76amovtiE8VIoIFTQKYbd6t11/xdWvOiURuiYb+LFRQur43ulRrROed2Y+uks9gxb4aGnzlJciLz4Teooi7hUa6oR1uuhOhzUyIF2dCf6B6p8vJr3X6CWczIl4lAZvLjHJciefYPRa4TA45mpBRaJgVsSS8LCL3CwhaJ9+SlTTqCbUWA2hm9swDfGLR97LLFMgNhv2Oa4WcR4jA9Y031eZbAf1Whane2QKngkujoTa0u8Ow7a8wT0CtLHvxz/V6V8FAWepK9pqAV4xRp0sr4OUpoBbXVZTgvFi/dS+EeBB7vvdZwYFzPe0LS88o23ktKFK3FYudflwVHJB4is46W6QH8+SoGt8UtUCFpWJHbaomo7UA9xS11T+Ud2qch/ZICzHEJDjiHSI46Q7FGvUBcLsXhZwv2bPUCy1MpfhE4FWSyDJA7sN9k5egve66vk/PimN5FMB3wPi9sALkHEIMa4ErabCdeaIHyi/XJC7kbYrGEhDXRx5mw+ebdYrbRcA3/HoSxkRBDo21HaS6lPr/CIzZtscOXx8lLbZLLn81rXuqhS7pOY9EWDr5KRjXm1SUXX06lBxVgZpdM8tqYhYK/sBQlmMDR0ka1iRR9EIrEPvJX082Yu5lj0aDyNVCcgFCebZurro3XBtOtE0WAvSdr8kFRxwNbmA9d0KaPnhafnasBFYIaVnDZ/HXS/B29zqSQwCAvJv7gZP0RRh7pUvm1eoWk5T0yneIjf6JR6t8WmFVxsZcvlQKUEcX1Kam7q4YrDeMQia5HmWF3iyRQiLUhB33FuFyG5SV134jWEzImPTeLFqWoSjL211RSFEG1j7LjChzQkHm07bc1xvjJHOZM8NzgvQ9HHDJV9xwLy/nMvipkI4VlbDStDgeoIFX8hoK5HcDC6
 86dH+LaG
 FrKuz3tuXeJLGY5fDIoz+X0DZk0hwx4q6POBPU6bWWjx2BHrixn32pk+dQ2vv5FQnURZPWV8qCjadMzw7wg1wrpLbFn2fbRYjPpzuPRXcbvGuOA/jrDvZdSUbnmhofESXNJFtiSO9LAy0oHcGmwsq8FTCeBVb6rg2lJQHXIgAkfGrc+wBCHx1jCXpt4kPcjkWlz2/sEjk/BbCOoiL1A6sTqJy//K9elpwjDdfZMTF31kD4tqZ8WuuovYQTHm/H3XA2BW/fACwz6Y+wLyXtarn1Pcw/I6NueAnF1wcN4zqmNULQHR7qkmglttsiErpqaRVvqpAvDtat7zSHJiKZk9na3+csJbTSkSzHijbZ1VcudHSorrFRa8FKjZl7otRxsX+VxW/hjKv0DEwWoBunSrYZnmBklL77tEAg4beLTGEHc7eeRkRbRjv/qSw7e+somFVVj9fh7KcZ+RaHq39bgJIuqcDVY6pg+i4hIVHmyB5eBSc+hCl4A0tdj9PY9lwmtT6g6/Y1d9qsF3FKh6+bwDF/WUBjR5ggpOHJ/nZIMir691MyhYmqGRiMJJ0LIh/Elry2a+lHzEckgg3wbGA5MBq4+UqZqPA3zjN2vzu+IDBCgvQOtG7v94WfOHcSYy+HcvY9w+qEXK0nnFyuDfgZB7zFI8gnH79/tifLlpTK2U3cSMMjTW5yEAgaQEeAXZvPzgVHEvGRlzfpxAQYZukdouXXAzjjfU1GuoqX8YOO3X1j3LvyHeZ3cgCF2V0auvct2Vt6KNQrWPd6aAaGFHKtz4Usa9UTWi/V/1aaoUA7gX4EA0/nUvXOunMYG3HW2fgP9zZOJx2kgXmLT4KgHJmhx37ieLWft53zOPkLZm5y8PLqrFCtD/GfzVc5Nu0i7hLYz1f81FF+XAlJwYQTODh81gJrkf/VDwg44tOL3AnYtH745GLDWbVUHQQigryx/gx5Lyr0O/NTr8QHjc04QmOOti3bulvDGBZ
 SM6dm0eX
 fPzYTrHgBKlWHRo6UC4R7WAmgMAhxd5gh8bfRUasgvNIex/ebmVmnMC/VjIvpNwnRgNwZ0F5JurHI0C/6574gWFeLkLOldwo9CJewyHy2Xto9on3iqXkNODc+Ek2I1tAk2eoNiRpYUBtUeA5aNCh3Q+a4z27CCcNRDksPVVCHn6QkCE+8kIpcmDCmNn617F/J5sVkwEKM0CV9txXt/2+kmxQyfbg2huBUPGdaCCzkq6nDurLX64mACIc3yCvnQ9sBKPPkhvsjp9aR0U6uY8EPdjGuTwmPJR78zQM1hutZn1mGMObKtTl6zj8yiqS34q4FwcSKzF6k9lSdQ6dQ2yl0aU1vGjs0Cy0h9kMlFmKVYyWA1RNR+IOA8nWV2dfuyWT4wrmQRshxKjE+n1wOBM6twaRJpD7F9lGAPIOnutx6B9F4JV7znBRJtCcOT9KScXKWAdrYTwm8zPsnpt5+pfMQ4Wgvb8CkeQKNv8oyhk2XHS9VViI7auyTH9JeBJBqU6NdmS2jFKb+1z7LR4cH1B4U2Bh7tsp92w58tDdBrjUogDZbDg5bWfrgHOID/s26MlJ9Z8/9W+kq/c/im6AQMWJsGz6XTRj+Mkt9jWig7i53SgoKxfcr4IveW/RJkxmvWNxkIIRIJsdXIFxUD4HX9k0PCVZdX7YA/GXuIiQbdk1B7z2padyEY+AExZF0SRzaGOwtpBiipXUeH+VwNff6lWK1674XiY4St6mk7S+gpaHnWod19FYu7PJubx14v4YblWYfQAquAWw2JPzES1c5OTMMXYBZh7/HukJ3W0AWMvKWSn2dhQx/+GPT00u8C/FBdWUT7NVOZiO2kNliEpcP3uvBMzXfFZheHATLpEFfV3aCmV+M8hhZkOtF+MV+etJiaAk3yFJ9w3U37ZwlhMQ11WoOcuYUKY+5Alj8TUiRHkLga84OMHHN6l8nJWPbSDCxyhT6THMpYQQ23FjWDhtZC04c12Z3/PbG
 4OzB8ZD+
 HBJNJ4dUw5QWF4sBzqTlHTcj0uitt0jrwtS1IfvrKOMks12IsgnqYSk2q4cu6C+3jyljj1HXqFM3UNREmNbvkQLsQxlQjfYTBitFQnoz9P9oXSMaO0fpXMcoKhbSCRBwCmkooZlmHbMcLYvHrRVBe6xLgbJamIzgQyxZPoOgSB8+2B0Lfncq38+tqYtiD9ONJpvrYNT3YoyYtbRqNos6rhAbSIdKXRby9sg/CEpm2C3AVuGbTq2JY7DszWuVyLEyBGkoImIwBal8si+BGbRYbnbAgU5y1peSayPbDG1jxm+7nqCW+TIoujZ5Z769+bROBsOjAU3x07seWZ5lfF4+R+o6FAwjlush9/KD4FfslH64Pfic3cLsg+WhpuQ76E7ulUj3rBbPWLBsTKK9+r1xoRWFn2n4Wte3lgwolE5dy455mktlYBRqnpDb9fRc+0eLDq2KAMXlJWBwxKlut4b60L6PCXBo9/WsLmSmfDijnGNr8qqoq6iCilaniD5d7jbsjgUTTewmCqQpKulBqopeGDRNOYJK56eLBZ52P+bWTbR3eV40BHymr9hjmGUJ0i8jjTcqZpvHIsiuvB2aPwlsyYGfUEsX0bsBxyxo/R371KkwF+L4A+mxMJ8yMJFTSBU1aK+4F83x5afXWqKV3BARkbOIJKfN3RE+s0lf8BT6w7386ZUfR7KNAuW7fdNfFkuygIBFC2W4uPYFyj49wsxoDuBiFQWtYYBRZF6ClkIt45Otdqvj3jxZOnpOF8TN6EGRzQc5MJAljhD/El8+u/uqLEr5sZ56awVj8XBb8itP9a+Rwzx8B6GlFZvzyjT1IoaZUUBpPovUUIiLAPvCNe8Sf96g6ODSob6KdvwO5nLgn18S1pjRoAchotCm9hVqkG/Mz0mnEF1OJ7eDpJdzwLZ982iLixKalDuiGex4jg1ehYKTluQ+g17SzhPzGk506J3ktJNfEaNY0egDTUaBWx6MOaJw4Ps2B
 MO+/K6VR
 sk7vQJyNDiz7KaC4QFOjibKIrzZDw4yJqFQ2Ui73sgBNer1jAxoINT6D0DQA/Km/fWeCZwzSID/TfBSyf/gDDhmEoSulyO2isPu3SzkhXBNXSYoZnuHjX1fwyFh/UnHPspknw/AwA4OVLNyArmQSoQ3om3i/drJil+beXzFlUl/qKV7i9MsX4sVcq9X7a3CIZgaSZpJR4lSl1e3OuV9sHQFit4IuIiam/uxGyNxfstXB9/SEX5EZET5+JjuYEAfQzI3siUVO7cnoqIl2mwy3MZx4nv2rEb3X91O77fsFW1+dmS/jw9WxjiHNNU+Jr+7fa9Gpmr+0WYs8GceYIWS+om84YJevgM+Ajij4q16RbkVLv+oOiEIASqvN8Vs4LjzMKeiDjPZEPvAHauSXOrPeS62FB0oXUe+KAqxEOq008kUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic PTE range and remapping helpers now pass pointers to PTE table
storage as hw_pte_t *. Update the Xen callbacks to match those interfaces.

Keep software PTE values as pte_t and continue to access them through the
existing PTE helpers. This is required when Xen is built for an
architecture that selects the distinct hw_pte_t wrapper.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Clarify why the callback conversion is required after architecture
  opt-in.
---
 drivers/xen/gntdev.c               | 2 +-
 drivers/xen/privcmd.c              | 2 +-
 drivers/xen/xenbus/xenbus_client.c | 2 +-
 drivers/xen/xlate_mmu.c            | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1dcc4675580ed..b013bcad99b5b 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -301,7 +301,7 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 
 /* ------------------------------------------------------------------ */
 
-static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
+static int find_grant_ptes(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct gntdev_grant_map *map = data;
 	unsigned int pgnr = (addr - map->pages_vm_start) >> PAGE_SHIFT;
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 7cfc28f1bb86f..e724cc053e264 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1658,7 +1658,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
  * on a per pfn/pte basis. Mapping calls that fail with ENOENT
  * can be then retried until success.
  */
-static int is_mapped_fn(pte_t *pte, unsigned long addr, void *data)
+static int is_mapped_fn(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	return pte_none(ptep_get(pte)) ? 0 : -EBUSY;
 }
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 27682cb5e58ab..387f97a555594 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -749,7 +749,7 @@ int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr)
 EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
 
 #ifdef CONFIG_XEN_PV
-static int map_ring_apply(pte_t *pte, unsigned long addr, void *data)
+static int map_ring_apply(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct map_ring_valloc *info = data;
 
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 8efd7b55223fb..d7244f9f9a545 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -93,7 +93,7 @@ static void setup_hparams(unsigned long gfn, void *data)
 	info->fgfn++;
 }
 
-static int remap_pte_fn(pte_t *ptep, unsigned long addr, void *data)
+static int remap_pte_fn(hw_pte_t *ptep, unsigned long addr, void *data)
 {
 	struct remap_data *info = data;
 	struct page *page = info->pages[info->index++];
@@ -269,7 +269,7 @@ struct remap_pfn {
 	unsigned long i;
 };
 
-static int remap_pfn_fn(pte_t *ptep, unsigned long addr, void *data)
+static int remap_pfn_fn(hw_pte_t *ptep, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 	struct page *page = r->pages[r->i];

-- 
2.47.3


