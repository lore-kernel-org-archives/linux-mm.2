Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F37C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 05:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E8F6B0088; Wed, 30 Sep 2026 01:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8596B008A; Wed, 30 Sep 2026 01:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380336B008C; Wed, 30 Sep 2026 01:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE6E6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:10:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 688241C35D9
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:10:40 +0000 (UTC)
X-FDA: 85269253440.11.825ACF4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CA74100002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:10:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XyyFJBwu;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790745038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oW3AvlDdNTKHgXBHsjwYnhwhpxTAsRjPnzJ/d+6YUE=;
	b=0xsoTvcUpcLAIJ7CVZDyiFsLmnruPdRmYuL5qC7NuprTkHNzczFTlC7uQUXvnab1XO8v+8
	ViePqSCC9/K2eirOoAPcMEyGYLoGGa1/eR1hvTmzQjdSdBG7e1XMi/kmAr8957X2v1t9Dz
	okayRdv52XqbYuzckkN8Mikl61riSco=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XyyFJBwu;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790745038;
	b=Re5Vs8fXaqPuMSfB8d+yFVWI3tOxy7w3511yTlvenJbV9cjvqulPLPbn9UVUhkj0YsBy2t
	cp3gkC2/3l4Z3DWy6/RdqlBOeqD4ZYMNWBDWxEP5IFkz1GjQB1EekC2KHy/M8TAJ9c4z0M
	2iS060R36ysC+k3mX5cIDMwSt4p3JK8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD6551477;
	Tue, 29 Sep 2026 22:10:33 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBBB73F763;
	Tue, 29 Sep 2026 22:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790745037; bh=HBnOiO4lKi56PuSH4xu/j4eJs0RVLoWx4P6ztp2ydZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XyyFJBwudHElfeviZ00ITo1a6Xr9Q3NyTSeWfTWp8zjFH4KJEZuFNbQ9z9esgxx36
	 t4IFgPHmQLaWxfB8mibALu5LHDRYKETtddlKsa/mrM3VuXEUZdR5WzTLOHscsAE3WY
	 77cVlx5yRsj+dQ5Rtn3DsHPDmyL7aOM2T6haf/KA=
Date: Wed, 30 Sep 2026 10:40:33 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, damon@lists.linux.dev, kasan-dev@googlegroups.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 4/9] mm: convert PTE table entries in ptep_get()
Message-ID: <dhokijjou3rh3poqnqqpyoyac7wrqeprl4vlhzqokvh4lgjyya@g5hwn7sve3uw>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-4-5670b8cb9059@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-pte0-v3-4-5670b8cb9059@arm.com>
X-Stat-Signature: fszcosgb9zrjcz8smphxj3dwqco9bgyg
X-Rspamd-Queue-Id: 5CA74100002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790745038-17205
X-HE-Meta: U2FsdGVkX191bcPnPCVpCMfYlB8d2Qe/pgAy7IFKaeryYVxJQB5TVjZ0FvfrgvT4/uCv0+qjcMAViHQiIlFVXrRCf2Q8DJPNMLulWtX1hndPxELV1IStFQA3IyAO6UL7hRatfnZUDXr77sJdKG/BUNI/OEBvngab5/4pH082ZpmVzgu7Bq/mHuyg0H4FLY6PC7fEQlDW7HlaYuNUc0deDGRLAfoW4EN1q9nkH2TMOBnP+hC0AQ+TNnDTwG4VUqhyfadlMbtJmT3avH3xP+aKbzf0q4Zk4VKyoW+Ou09CnAUtT46ozKHsl5niAY0xpPEgn1N+lK4eygmKcr6gUVfjuALZmTYJKfnn4dCczDcafDJdm7y8PxknUznX4QCZdEAYjiyTWrxnaksAAcIrjd/jJ4LM7If/EfsgspmXwIEvC0U554XupzxpC55Km7seacpJnanxm+u09wqylprDG4n001eSgEoTNTEPcb7bbmDUqJ+X7Dj1x+LFEA+cG7w3eQ00u/LPiYtFS3pWYKH05Kp4C1DsNiTDvJ3rg2GwZP2jgylJewaCqgim6kkg6IyiNNHyuybypNu8xcqahSDU96sjF0yCUMOxaB43oTp9mCKN5/Fwy7jnWsllPKJg4wGT0nymYagGIqX9OTgKl48wGT7x6Wa1z3jqLNzDk9ZYjtdCkd4ahTaNxB8gdb59RItOnJMBa8cWkUrier3yYM+jjhxbR45RfKcXgGuyKIVpXrjIdY0NeBxur8n9MVTYRHVapNC5CkSf6AD9wdZFtRHgm33d2qx/Pz0cL9Hgs/daSBKk3Hr9yGZz4HP0gzjk7G5YtblsrMJgsmmvzdDhAkwYDJG38/r7PbDy78kAnDeJmvky1c4CTcoP8WLP3DpyQK8pdSQi9ERro72xfYmyZfwwHIUTBADKR/z+wHXNsi128FiEnln+MEHzGERhk2hlncoyTdof93Fh2XfktHp6cWPcefz
 K4M7qzoJ
 mLtoHB0+S7EnQ+s5cVwG+RCEgsNK5uQ22Kqn/zxjXFHKU7y/5MORG/Zln8tI9Us1JsefzvvtNG6Af+0O8vXUupgtAZ4HDuvBJwahAxOWg58p1mvvhNvXYpYA//zwiZJ3LAU1qKzC9nsOaJtiqM1j32dtgidUnt6tu4dLwrNv2SJg3PwcwBfB0sq8TWJF08P59MDKkYXOVa1S/zisQVAITE6TCEWA8EvVEUpRuSMMtDfy7e7SGcG2rSquKYLj4aJfFTDHTOtGPynmKVMwbXB9OdMN/RvWT8bSoJsHeDEjx+HVDwlQY+DFzcCSzHqdaL4zyTK335KGnsqmKaQolC2dOd6g96blcfv4AKEvhKJNMG2LqKu9/JNWNWWVPeXhzTeV4GnuUQOTFMAguxumKOhdFHPWXHry/31Kwu10rY7FCJUhVbNZcJpbosQB+7lUsFk7PiTxgqKqRpVqYcFFWtgTqUlR4Op3oWC0pxk6l+pkN7VhidiqoW1snPMEBHPR1nrKc+7rglQa00t5ULIdQo0LbjmduqWYdDtf4ggbMYOKxmlYampHeq1NsIaP+JqkPFUg1vo6UsUZo/PG3Wk6f/DwTLJEZBqR2kX+xH2QNn/YxFJshMmwLc6Toj4y3jYtfCy2h4fqQWpbAjRRmK7iZmsfOP0MUHey0Houva6Xust4On4gBeejvXkcQvOl47EzZCebJF2YviL/tLm4XUEQOa3TuPkt+Iine7v7Gc3IcdGQAEwAIEgMSxpf3makgGmpsLDIfoWS/yx/zkMYBTXZsdx8+3zroaEWZI+3kUdCyXp5pjT8MdclPE9/U9TvxyCHD2DANsqTSxfDMpBRTKCa93n/iGMUHJq0ymyfuU0Dld3Vbh+d6YltjRLq4pnZ9n1WtMf5QAV/X8J4d3y3ovqg94A3H9eBct6T4RIg2SaNRarfImeFKN/S7nxDPmY5vh0LdBjkw4btclUzp68caEIu+p6+3srdydeSr
 WSJdlDuD
 H7bpFqTOphdcF7ihetjoK/woADsmI5vpNJoHH///T+Rld1pzoScxRu31Bax8D5am3aaTBTrAUJmd1MHF/8SsjD+on9HXxBBZurjF2kXHrpV1hFgURfQSjHsGdUbT771NUVIKr7SoRvAkio1n6aU0GvA9o7YQPoavCaCmGR9Ass7PRr8pnRfiiuY8fzlry6GxN0P3iuydKaLJNxyFm/zIIgsQY+YnP1YYd8TRWGDdLRkdspQ1d31V2HjbZzglEE7FzfKmBZLM8XD2XgMMj5T/kIQqnwSPj0KBhSkC8HWpOJfDg7NJdlhf2JC7UEygAqfhV6DoLo0wkjNoIRgFJ0mxZ45JRCgbKU7cbjLt59xL2DH+fqNYi1VENY5mDhfH8js7Nse9cXOvOBpo/BH2HLoKrxJ4CoePBek77m/shuGYSvYhGmklFCj3svve3KfNYhsEy2o4cMQ03oeugD8H9hvI7/khSve3ptNDvH9DY75oUrOBpcIunlvEjzO9uZKLcoyn9hPqM5NgRYEZ/7+llt4z87c0giukgRfVlHGv98eqyCY/raOiJ8s3RxsxIc7ZJsxORhLywgb54rj7gbG0zXmwKzXzOX9vJXtvcQ40kECkCzLBVzSsFnbmSV/R9WEw1YG1wdO+wVWowoW3z25um/RMFOEy8/gFFSLxhVUaIs3eynhuX0Rj1uz63roPTYlZQelJrROKMHszIhZ6JnkL5ITLgfUGA4p1IPMk4dwDbhqk+u0DuWEMDskRZ574bS/qRJuErHCcltm3qnQKEWS1Rfoesx1ki7w6/0qGhq0nvXeEQCFciNMLzhBEp4HdpGndCUUQCn2USm8r0DmDumBkL35wS7uDAZKggc/NtB6yMqVrII2IcbmrFma3HPS5yw3gUeZeoi8xk4K1WQbijwhVN1A1sedNFj0OimfFmSGaE8M1c69izhlXWBAdvu7J3lV0b4lGCHL7mpZqXw9TYVE7OdxH46mjCJs7t
 dHW9KKKM
 lWojKBJLJOQXxrSzkrW36GYCsRTFETYxSotFxafmY4ApGsBiVg8ebKqsHS9VuRT0jIBJiPzSunhYsZvl8KLDGEIPoH4hLTbaV6JSZMACIOhYZWmoh+Hzfm4FBjcENVNWz30X0MJLREHgO0RVUhu7CQ8vPs3E4SmyDVtjYs4LonLugMjFgU5a6jqMHPrLkADImJv1ZSAwSsZKkAxCl8Lr9oRP8ptbw9P1tdaT+kizm+cl+4+h46ubArm4zC3A434Q3uJuEz5o4ZaD4AZIGui34WYiQ0c0XYZZvVveOgnhMG+fUneZP7JBC+47Sds601ocxpH+o0uhl0JGR++79v+TfFHnWDDEJKaV3LC496QHLGIUdfgSviKN2/lAwlGlM7bnIwTLeFuSCAaWY9G/S/W3i+J+BGGQ4niK2v9kcvQ7ywXUqrb9+C9cLYgD1gOQlK6u5A6V+LPjzjxUNTwQ8dY186KcTGYcER8DoikiuzOkkvNUeAJGDWGC9hNJlUovFypBkqRJaFhD7ytlVXa38lPTb1d2iaSc82uBq/fTwjGbTCvD1lM4AjpIKdmjzUcx/MZpwXYmvb1v0IIbtAJdgaQjkQaF5I2qnH1GGvFeReeGcdOkhdbffYTot3eaDmx014Hu5byjhAlmCJBgA11xiJzy/5UQH6E9FjoWussoknorm1cSay88N6cHJSEXeT2C6VRiJXw2mk4mwznc6/2G1PsvEDSvDbixEfLfl/YNJ7o0jzcfOgea8VHqVCQVHj1ZwXeIuzAmvZSMf5iz7YURAp2sDOEUdHrQWA4hH3R9oK4TWjgkzLDmUWTRztzL4qlxcfFunqERuhns21pqutPoHeGyU8D/Vn+S/X4Qycc09UeO6jhIBeJSCMA07nyPJ/2als10wyUXDKOgMLbt+DAHJgYsMJPQu06RanIDhG2hF2HOVl04ZUwuC/3CneChjj2/fonovAlBwf3uwSbq+u3YGyBT9yK78SvgA
 k/MTCLfk
 7yEpIDx4ZXDCmNkmHYbta9gapu02slaNZdGjLZROpQwkSrD9JqTu5eJwbOL8K9OwJDE/PpBgib2q+5YqrucnZPat3V3OCALLmbOaYcklvZeJJWu3IAZT4EglPqsQlppEqTHLdANaKL8wt2U/7pYSAQUYKQyxh92m6sCE2GWKOzLfwSpEV0y9dB/JWGBu+iyF3vuONDxEFlO96rz3cl7hvfTPRUjZQTDdKjixKAjXnlZteev9daKlJuhWT0c5J6T7NltVcwhhtkL5MBa2VkonyvIDxiZY4UgJUmGATMClrYeP+FdNDPwKqaU/RW9FAxw+ZJB/K5id+1InqvBjtkaRk3KVaeUGlkOZAnjDp7NUygv/sGIvGUYjssxVG4hS4KNHmgPl5Fp5F6Cn0pTy1NnDU4bLHc/jlkMXq42VHU43KTfNjITcPPgQ4H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:12:32PM +0100, Muhammad Usama Anjum wrote:
> ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
> return a software PTE value. Add __pte_from_hw for both generic hw_pte_t
> definitions. Read the hw_pte_t table element atomically before converting
> it to pte_t.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Use software PTE value terminology.
> 
> Changes since RFC v1:
> - Define __pte_from_hw for the opted-in generic wrapper.
> - Apply READ_ONCE() to hw_pte_t before converting it to pte_t.
> ---
>  include/linux/pgtable.h       | 2 +-
>  include/linux/pgtable_types.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 19098e302b75a..41337da0d65aa 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  #ifndef ptep_get
>  static inline pte_t ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return __pte_from_hw(READ_ONCE(*ptep));
>  }

Just curious - when would other pgtable levels (PMD, PUD, P4D and PGD) be converted
in this format as well ?

>  #endif
>  
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index 07da05d375c2c..d6c5a7548550b 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -8,8 +8,10 @@
>  
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
> +#define __pte_from_hw(pte)	((pte).__pte)
>  #else
>  #define hw_pte_t pte_t
> +#define __pte_from_hw(pte)	(pte)
>  #endif
>  
>  #endif /* !__ASSEMBLY__ */
> 
> -- 
> 2.47.3
> 

