Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8441FC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A306B009F; Tue, 22 Sep 2026 13:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9E76B00A0; Tue, 22 Sep 2026 13:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1D06B00A1; Tue, 22 Sep 2026 13:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 679E36B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:13:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECDD51605C8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:30 +0000 (UTC)
X-FDA: 85242044580.23.BBD0061
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39905160005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=igT401m5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097209;
	b=qbzXofE1FjJpjYCxlqp7d4EdwGfGKxIcvEBS2d/7RvSt5So0bGOjPHLVs1+fzWqubXkLAe
	7Bh7ERtY5/vUjeOwyOK8bI09F3hPJLcK6fzMVUMEOQYtsrH5YTRziUcjTdYmuKg26CDwtI
	LvTdKiS9vAiYRQGuYSo8dLxtYVP74K0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=igT401m5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFyuweiLUpM0sbEjZp0r+u3hPxnCR8dojGFlsJ8KrlU=;
	b=Wqc6KRNDZ7kePU6ww4OrawdDvbUyVM6WEEt1prO/Il4n4MFye6fcwVIRtIqNZxIiWDTaDj
	tYMDALsdlAuEYL0A6MmsMLtia4khrtQ8BZKT5Q/QxA29T5v8Bu2scoYr3TS78QF3yavpGC
	KSYNi38aPX50XhSrwUcTy/h2PUHVY50=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1CBF1595;
	Tue, 22 Sep 2026 10:13:24 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 742013F86C;
	Tue, 22 Sep 2026 10:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097208; bh=A5NzDbD1noDwzYUVi8ldHdR4UZ15jpqj+KvUR0EDrHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=igT401m5Ukd+3+6wB+UgkDK63LspXcTemyvQIbaw1+BgwuYsVHrX2DMhqhgHk3LXY
	 kHy/IQiBkermaVeOcybtnCdoQu7KcLnO6cNeXQ+B00DQhjxLMdA8FG5xp3QHrnYKlq
	 HpbAzdd9QkzACrgJ3YINIW0HcgeXtIyLmi4yHh8c=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:30 +0100
Subject: [PATCH v3 2/9] mm: rename pointers to software PTE values as
 ptentp
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-2-5670b8cb9059@arm.com>
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
X-Rspamd-Server: rspam06
X-Stat-Signature: xhyysaigqbnbyf3n9xanajf6rmof48ao
X-Rspam-User: 
X-Rspamd-Queue-Id: 39905160005
X-HE-Tag: 1790097209-523809
X-HE-Meta: U2FsdGVkX1/mA2fRxIJUd0hHL7yMpepcFX78xHCfzSMP0uYYMZqB1LYXP773ag1idfOTCcds95mvarwiUVqIgAOirUt81ls3GTF64M6LscNPlFhwyqL7dszWSTAtD78tMDNvV/uGURUynKCCPCa6+sofGge1/tyRjIVHZJ9yZaOHFlRUnQGfNoXiQ8umpCqbFDYM6N8/iEmOSCmhDld6x+zT49SEwRzp8Bg9Z6UmG6RrMuQCi4Pk315TTqbwlgephzQJgp9Wdt9pvhoyJRYjXyBZnIq0oNkIfETExoslC8iPALy/9HQ0xDfsI6P/1PEIsk7E4HJg9QFug10k6VZzQ/WhNUJRTWLaF0SA2oCcaXReMEhfi2MqylAHbAi3pdK5ghBP8/H129lxrDof2YMWg2+YikEVXQR0dZ/l2Aw57I6324CXCQI/gzKBfAmo+O+tgF7Ir1YD5DdZL9uw4z+YkYA9yml+j0S8DmsuU9b0CTPzfP6hP9PRaIIFm/rvIOe4bANFnwzmKnUPtAPm4kTCiVC+hvHU7PVWzrnUGfBxpKDagMgkl7po75as4IH5jBz9AlVzY3hH/+gYKW2F1zbVmFlc0Y/KpWbgckIld2lses7QrEU8PWWFPZXB1IeIG7ovdqR8GLwVypHkVKnWk1/SQAWmIT5dp/lYN8Eg6OEdJ84uvSEOOjk7KZK8xCDE6iSJW5/EsODfvkwuhBrDgPc8jzA/OsXGjbIETsVjYHKSwlcWByn+MDFY1sL7AgC+FZ35SimUPnuqBqy6wu5LsrM0Y2glf4ux64J9MVFIQVIECzakSkvC2mq1JYRJhNWRoFl+WePGPEGc+IUee0oVHLbPGthPgbiCORFjM2nhqfU3lDYvC+//p1TK8VZGl2+egB6QCO5bAV2t80Luix0gLQa09c/RHa7ijRzM7r0TD/OVxPcGmx6mA/11Goif6sb6vhsDXfZVJ2IIFF7CLuKCci7
 p8l6+vjf
 AvL4Dsr0tGwNJzoAsoPL4/voJ+uGy+lbUFEpoaum/zW3/UheOZP0XeBiYWSk4bwJj9ci01NeXH3eNcdUvrr3tYn2qBnwKWNWCrdcwCLA4tX88dMPEhMZaufmBj+CmxRAzUV6V2eoOARoSOh001f7C+G07EK8PjWwMytOdrYMrdGh+jGJNNSJZaOlM6H9uPSsro8wJCvaCZLerCQeJCh/5SpdeS4UngX1RZ7t6g0PHXdY3wd/5nr5CWWaBKBoxv+wKCeMzxAa8RsGpUW7WEVZWNmYvwxGbgQudBKGhUtWXkrLUKTOikfGrTeGv8cnraNWzTvX9l1hIGIe5cV4l9Jv4TJ5u1XgrISDHcphpJ0sJIF1cXakAV/pmpPMWvxaTw5QoxUvjVPG6PU+kfcJrumASiS3+Sm8R8yb8o5FQ3xjni2d4TZADEDAMGr/ILmCUHFsl6vjLZJpOoBCvwCH8YTuM4PdEsJ4mzzFhy2jkF5drHzuZENs9tfQyEp1VeaxAWakqLo8rcHEydz50QziPixkmh7O/VLCYd7dlPEgKYkV4yx3jL1cKAEKdY5HMAhb3246m0Yt6R6nDcoWPsAIDj/RDr6lrOROZFsBPCji2jWT+s7jcfwDup4p0mGFSb4OOwj4/aJR5n70hKABwpDeM1seoM4JgKNv9pI/tPekOL3z/iBKsDtQuWEPJQo3g45Kt9fF5jIgWMYSPXMwBQvkitqhtkPQukunT11albu3RVRxRJ9LeoJEUGBzNPlk7UHucYHFvXP1ienpHfHI2+I+LMSfuNbrsy9e9oG3MIvAGazAeAizL4QLU3rUQmGK5M8QSY/4eBUEYF8JaA4Pra09ceS6tm2JTLS32/WNjO7E9n5hZMqYRiIef3WnwOjAaLQDVviHy7XGeNLca0051ANAWMi2c2xenbpnyaSfCLUXXYk7upjcad13TyeaAFB3s3rZd0BZ3f12vGmaFV2n6zlaxWVVhuT3Ba8Tq
 v5qYzYCe
 XKg+zRPCpF/IFcmQIz+6/wHuLFz//e/rKn3/WrL4WYsAX8Pavmt3O6WryOOSrcBhIbpRF9OkdmeNB5ut0wj+UD09M+rcqXmGnaFJmuhKBcsJhxc7cislBj5A90BSa+lXT9DKfFypnmtT3zrk5L+crKeltDXsEX5TGiEyCjlg3/ef/Yyla7QvbOP2DiaKajAWWvTvGmNxEXbm2hMq5BQsgTj+6n+DbCUmATDPahc30reSrUcrcfkPU8+8+MllNlMdh0nP9kKqh89f98u1CuNnKv0UtDKKVrm5oLi2y58mdrNUou8HvcKTD98Oju3qX4rlrtGU5p/7O4sYGvppH3a4UIq8qXvlpVGNtOyFA0BRW5NZ97tzvTJtmaVecDlqv5jww+iX6lDWNY9oNfwihnACm/EYv/icB//ExalJ3YMpKBU28Qc5gUZ6TG4jxAhsn856ywlldJZ/ovmXdPoNbmbejLskU4Ou390fyMJT6q4ewE8UnkVpKb45CGS78KYtxvnJZ1YGz0/tblRSs5SgUOf1M2RZnQ/12cVIlcojHJM2QE+vLbK8sxT9CS0x21Zr3LPQWjikEF48Rr/MFKUa2BDf6wmfMbckMw4yN8vgHHew/eznZ5ZJWoWcW9dcwlzhXzdNOtmH9KNIUwtoTNNagZRgpqrKU5HcJtV5J+zNQQTcJn2x/Yc4VuaWmEdKogpGCqRts/dPjPp3ArWfkoyCuFqXv4gzy0g7DmtByNxM2zWA21MJkitQAFHf/+0neoQ5WpDlEv+4KTkZV5rrVSkBLf+sdfu8G+/ripUs7/M2RKk7wBWKVIkHQOh9fxWOYoyLIkgKO7ySeAI1n4Bh/PmgjQfNIXRDpzff5mRb671rauwW39o/R/rM1tqe/Cx/95Xlpp2Odd0SWiQxnx/jPypniwlylKfPfuHo5x4JlWkzzHZ9d7uYLKi2t9VQDQW6r8ShImnYspKqs7bG/QM9rr3PGD5i+fRen5YFF
 K0rURsld
 rysPHNDl3UDbpyXJTO4ar/i26OVru9jeTm6+RJSSZ4x4CZwIRJEAxnagleJ4cXdMezYQmWpXHGo17Pb2S1TIkPn2kRTXRBSv6ErUdk6cx254x3Khp20v8nMOwgmslEwUm0bL3yelJKkBYztZLgPEXR5b3Tj3xttbAGSpKwriGbxvIvnJtUj996+LfCR4UTJ/erQRE5YH5zRx0a3c+0SUdyPwgUZXja3kVIKJ1B2+Rp8LHq+U1hSd7bjIHH1i7wNwX6dL1Scc8RCqW45rZI4oBW4jIUk4Bw2SH4LwxUbQB1FY7JnBMJmeSuAfLAskqRKzr71aFkD7sJQggc3asw16sQTqzE3wHKCcLFs4fhfRX2xipL0iaaCeA75V36FKJU0gnezEdrn5Vb2tx/FWEakfspiFfsIM7CPB4vlwEa2ADxtHBicEKd4TJ2tW9hbDGeSMOlUX+FadT1CUNtqt61vrgWd5Cn1zxJjXQlZQYthgWBppIBE2MXmkBKc747GOmD5RvlmbXz3gw6Ct2LQ6T46QTOUcjz74LNJKSiMZx/n8Qb+aLDeeIbFT+wUd+F5nN4V2IrrvLD7yt3k2NqNNzP/p8aRdcqaI7jzGKcGC1CvdSVsO7Y43oXpjpNFJ6fX1NA5y19RPux7rJNihwiBf54Uc23yPDJNPAeNZc5ECexl3mluiq0yAypiYGDG2El+fWJKShpTkFh6iv3PKAK2EKhtzMLDzsfRa8vydw6qg0mXErmAwUDQj9OiX/zQ2ddx9CKoS3hEqTab0Xcl4g/cCVK4gf795F/+EvJvV928rikiNEpBdiu05SZ2SLWqTvpCYhJl9c3EjQiHYk/J8bBBKT+WQQj0HsflBji2UaxFOrrxZanzFwypz9/MQtcMeKF2PmatlegKacvpRZ5DJAu1GAzArg5qkRVSGFIo6eW17u+i1VYo4P+DVtNvcelsDPiDtwMHifPIwydEkw9NyaufMIAhQXaCz0UPPo
 nVvSEbqW
 ppvggI9m5eYJPRhj/9Ixl78hE4lX99kWiL1a8CbJwUl5osOLV0F+4QcvGKhbH5Ctqs1TZzQiFAIJa7uQzOz1BQC2sDtFmYY872tEIYMTYUyXzzj+lMkHW9D0bjJN1oboUuQO1V668H6Fw9wE8MIY2L9STU17qsAaLcl1hsTJkOqRwBDcY/EeKqLgukolniim+2nRBmZxpTeXE/Ofv6oOVRVqohtR5eX17IAQEac08abwdos9WNFrNjlMHEYWMbxl1nW843k5lAMbUvY1wDvxq4JO08PMWN0nUKlVhIGKQHr67eG1rLxcnyF2s/PopEtZbJxe8TUNSssKJfu4AlltMzM5dy5gNtBwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some interfaces use pte_t * for a software PTE value rather than for an
entry stored in a PTE table. These pointers must remain pte_t * when
pointers to PTE table storage are converted to hw_pte_t *.

Rename these parameters in the install_pte callback,
write_protect_page(), and guard_install_set_pte() to ptentp. The later
Coccinelle conversion skips pointers named ptentp, allowing it to convert
the remaining PTE table pointers without changing these interfaces.

Some functions already use ptentp for such pointers, including:
- madvise_folio_pte_batch()
- folio_pte_batch_flags()
No need to rename them.

This patch only renames parameters and makes no functional change.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Rewrite the subject and description to distinguish software PTE
  values from PTE table storage.

Changes since RFC v1:
- Update the description for the architecture opt-in conversion.
---
 include/linux/pagewalk.h | 2 +-
 mm/ksm.c                 | 4 ++--
 mm/madvise.c             | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01bc..c34d826c5e4a2 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -89,7 +89,7 @@ struct mm_walk_ops {
 		       struct mm_walk *walk);
 	void (*post_vma)(struct mm_walk *walk);
 	int (*install_pte)(unsigned long addr, unsigned long next,
-			   pte_t *ptep, struct mm_walk *walk);
+			   pte_t *ptentp, struct mm_walk *walk);
 	enum page_walk_lock walk_lock;
 };
 
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e129..2a4f19fe0f696 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
 }
 
 static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
-			      pte_t *orig_pte)
+			      pte_t *ptentp)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
@@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 
 		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 	}
-	*orig_pte = entry;
+	*ptentp = entry;
 	err = 0;
 
 out_unlock:
diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adbf..dd75a673e108f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1113,12 +1113,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
 }
 
 static int guard_install_set_pte(unsigned long addr, unsigned long next,
-				 pte_t *ptep, struct mm_walk *walk)
+				 pte_t *ptentp, struct mm_walk *walk)
 {
 	unsigned long *nr_pages = (unsigned long *)walk->private;
 
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep = make_pte_marker(PTE_MARKER_GUARD);
+	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
 	(*nr_pages)++;
 
 	return 0;

-- 
2.47.3


