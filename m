Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF67CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924F36B008C; Thu,  1 Oct 2026 07:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD4C6B0092; Thu,  1 Oct 2026 07:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB966B0093; Thu,  1 Oct 2026 07:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 498FA6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:19:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE9921C290B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:19:49 +0000 (UTC)
X-FDA: 85273812498.05.455B25F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F333E2000D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:19:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMbvvVKz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790853588;
	b=XxLiBp2lLEH9Xlv4o/41Ue/3Q4o3NhMYnu2v/1zVI0Q+lHOaj03H4Zc5gaRmHrJR+KMC5N
	0+GPADuZuN9bd31ZmuuthCq8nqW2Le93IVQVn9Z4aGu63KtJV0ezBm0C5GCdjQzKy5ziIU
	QkPomg3+5eq0zUPE/DWY5ujQS1fzCXI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMbvvVKz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFQFkWDnC7jLqttKnpyOh/RzATFY2MNc7SamlM3r9CY=;
	b=hTwvTwW8VjSz4OyHn1KCX1izr/spXTf6Do55fp4UfokqcTIRx/SU1eXD/4r4aDiTr4OBE1
	PPXI5azSe7mSJYyPXdDpE1YcV2SeTbgs6bUItUmxcEGHL/kgBtleIYvgpJ3aRyKlrJV/Ll
	0rswdX++zYT6tcUgxlRHF/IDClGHP1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A275343C1D;
	Thu,  1 Oct 2026 11:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3D31F000FF;
	Thu,  1 Oct 2026 11:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853586;
	bh=QFQFkWDnC7jLqttKnpyOh/RzATFY2MNc7SamlM3r9CY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nMbvvVKzbLfiBDmwx5000bOF+s2wwI5IUpFYTI/iQmTRFaqEIRPkxAnIgPgtRkbJ0
	 aqsar7aBQQWF17j7qm7re98QK2MXp/SjTXPj6Jaave3l2lYP+m0Pz8NwLOPWtJii3d
	 +/JslHjvapBJl1QgKIGa/tDOAtKuTUTa7pAFOFLGVfS4bA6CsFZeBwjmyDK95aJdS1
	 9ukUJ793Yc9KrIfWLnhz27LyPhzI15LRk/k7ivImSysTbIiVyAS0KMu7lJbra/Pesz
	 pWFxc9zKJFzMFMEYqdxKzyhJGBS5wy0U/BzhIpkvR+1jEWvnD3SfLtCnn4oQTcUb0z
	 8MuItJ69xgTaw==
Message-ID: <e94dd0fc-3381-4545-9ede-513fcb2b8243@kernel.org>
Date: Thu, 1 Oct 2026 13:17:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm: convert PTE table entry to pte
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
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
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>,
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
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-5-5670b8cb9059@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922-pte0-v3-5-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: z1to9b8dyao1xdhq5qb8fr1wb78fqpi8
X-Rspam-User: 
X-Rspamd-Queue-Id: F333E2000D
X-HE-Tag: 1790853587-328563
X-HE-Meta: U2FsdGVkX1+K7+OYjpyq2j9RKM75879CGqrCZ9J7og5QYasLc/pXA1G5glf4y68BjU+kFjrhdUtfqA8xXvktmFF74EBOFQslhYo+Q6qlm+QxijAhwS04JhX8GWgivwHh5qhf0V0NfzvfVQt7XxAoV1kYSn4qvbfwRXLPkTz+kIlt+kcSYIy6EZ2SBoVeNlMydZ7+HEORLRGkQcKbGkYN1wpfuiLcAAussbIUdvdjbmdycD4Ksdp8OhZ9N5tV2qMnS5BekwLwfEEWzMOflUTrv1n1S4XDGIxKzoxXMGq0SXs5AL3aq8wWg5XH3ok2XzmqJD4luVSpai37uUKxj3qHgYFw+rUHhvyIEK7rjoGh0MLnCIHuC9LbK/J0KHAhpdvhvwOWHXyyfH36xR3MXwlnsgYa+NB9fPVCsRZQV93cZWPfYiPhlTr1SAp9mLhNT4imP9hgC6H51TIQkypzLUrNOgeP9W6Y4CRiictZdEoldC4Y1ji/PWMVK2Ig4rW2lwQZnwzl8nhS+0nsiHMI1o80yv8pDRTBe/wn5cA0eGmlcZS44IaWsjBYAOU8oZCJA57i5DDuhBiax42JstpgrtooW5Y/XfZcjrX+fj4riUxO5vCKinix5HN8d/iFW8Ul4lGjBoaHSBm1eLzleMvCFRqBfCexUJZThQG71/31FLVK7muJ29YkVyABQ1LA9F6ePAPOfxwX9k+Qk7gZbaG3meLk36SrjZ65B7PmOs+j/zvqRZdMfY715bQcraQOp6nLq+QmudWYnchQn0ms03cx59M97L6hBEay3GrGHB1/+BoxHApNdiIbGmCDhzHwPX0gVCagKK5e1eCtDw/oXS7VAovKwhG6PfALU/SaBwEp7qLK/pEt5rIalH0xazFKzZNZqempvorviwRlcPsiQz6U8QVagFP9YALJPRXgDA08sceRHnl/wEdvuq9hpDl6spG99TfZilsAv5uNNKAesiek2Hl
 NZFcwZEw
 9zcUK3JICX/o5ghLlBTDYeQtsS21/pI0Ks+dObAouQ5EYJUVv6xcP60ez95NzH45szzVzq+tetgdClpSQghM337z7Jv/faIwFVWDgyGjKHVph2+UG91drFr4CHawKj11M/m2SAj85XWiiapSgkwqcaYnpkY7YvgMnmNOMeVvuui2iEN/szDo0B7qbUNvHOQTFNKHSYH45tzx23AM3Q5SgPz+Xj17jWE0oVDSngOb3mcdrngPTtnI/W12XCCYod8gdmhoWCU3zPfoNm5L7pSsGHIKNcGbXFYttM98jL2pO9s4dQTSz4ctgl3QqgdbTGCkBDnxwPliSbvPuoNtIMi0KXh3tLwtPfKtMUQ8VNFLvt06GiYZ8whj5iINjoNmJ3j0KdnsfGewo5MxMLMzeRt7Ra/AOJuYgEhVwke9lQbrcR9tHVdtzrNgmzOFQVcuZvnXCQBeavUv6kSMb9f2GnBOmU91jgjVz5ypoFM4K5Ipnludh+1UzcitGGJsF5Sr/RqIiPTbq8jWilA90fP5YDvtlVXt638zQKoZbmqn0gZM/rKW6Tu723tHt7Bff85WL/Cy+i1vafxVLS9oDgPZZMFH7BYZSuFZusejl/cL6l5X7oudQKL4PXXUzuqlVmBu8Req6alvbVGP0qLXnnFtTw9WgU+XiT2FCSklRPts9HBw2b7v75y9ov4Tx044PdY9HlF2xCZsi+5kNefGQ+0F1Ku5JUo6AcCHAzGzC563gfApQ64FtfAeswn9KKC/k+lP/uLgnbdJv3wW7/084/a2csmFvgTBaX2ei7JjqocpfmnlWun4jI+vetUCiu385xu048DByfn3u2eCPIUh1tlk7OXkCazH+9i8FOIUFwVXkOrk0YyODw/2nqcs825O5T7jsxoIGmKaSvvdK8Kbknsf+XQloixfe/HLfWvuwMkTfgZQ4vkuIc+NWnRAIie6nb9LF6l67Ya54V730XaKxCoS0AWKUF+tV4ED/
 13W+S2xW
 r+Jx3suKXcSQc7VaNSsU83o02Iu7ntcb5wqwnY2DD4hfyoLMebLjVYBb2s6e0FqhFGX3yMnGsuSq3oSsdTlo34s6VLyZJcAuLdt7rrM1po4QFL6kPXO7N4XRpvU1VwTBJwn45u4rvX48FChgWakwc/wRGYyGfJZwxXvtsNRdK+cITxM3o+sSy10doIuwI+7WJP5GcUonBP/OlIVPuxU08t0/DL/8NW8638rHBXHu0qoCS/9kvjLOnssxcIrqj13Em1Ka8oma4XPqIWVid500QA/yjyQ/EwqdVaFIaVrVajGBYhTL0nWuwvCQA8Pl9e8Ji0Fi6kjoVWbCn4C89U785jCX2SGTeHcg2GMJRF0wjQpMVhFMds1g+xbrZcWkm/q8h0xXlK3NfJ3hc1CU/6XFqTAbJeMHBw9+4dM20YqxWgQhzFdPat8Zj1d99TZ2t0WyQWvGy9wq4254Qx8UHTIQzGLfCgyrCzSAJ0oXhXB/UvQUEOGthBZAKzJ8E4CZUV2j5zOPAERRmJxRhhbprg1IDpg6cemJUJUt8hn91oq654zV/DNkAgt/iuUTsSWJaEJ+SsHZY7MIx2GuBP4fIvaYgpviNWylEt0FBxs/Y/uQW0UkkC56sowHv1UebioOcGwn4PUbJYiaZcM1zdWgUe6iknpMqHAZzgD+lT/ebi7oDxl1EQbsN3N5rAkZxplq8QeHKXcn8U6C9su0tuSyLRnc3egjovjjPiDtIbo81styiFbDNCBvwUkJF8VkXPtAvzZUMeAgs1w8mjGQXsvr1FYfaEpgGcblL54kUMUGY7iS8oIziKIqi+s7xDAOya7lolpPk3Wt8W8Yd4bDWIwJuJqNbtcq6Msx8Qmzioi4QAcQrm/fjlq1KhTqK/4yPpzcbc11P7fpfPlp31D3iw/3hjNBKAURgPUQvpVKoJSbaDVg0FNMPofoIM0LAR8//TX12OwETSSoQTzcx9jgcxFG3P4muv1XraOsg
 B6AeG4cA
 X3A705oksW7vVzE60T3ChyaufwZRY1ssU+4aQZkJ33SXgievFDnP180A8LhMpT9B2nnuR6BFibDceFVGaPU1tQ9U2sbe+P25yKzQKqbQ+u1fYTSTzHUvki9gaiWLmpUAhJhORJ14ZcWOXjakxYvvGvQaf+SUY4GBNL1rI134gHRJouXGduIY/eNbE/jYFkNd+36tmEvbRA6kaJem2Gp9RC8Y5HpK9QMEprkLqm8nuEdwfyBl+IYuCb6XPlh0kHWYfF9w4obCT8pmgy8SA63Izf5UU6mF1OC0IS4kDjnE1j4bxRHC/Vj2/bcv3sUvoIjDDdxkl7cU7w9RJfEvxN/YO22U1RwBdinOFNB73qEvMiX9IkrC4DipRsFlSCV2kgaGfKJqreMLz7QdHutpXyigF95eU/NpRT55+BQRd07JaZKI/Tfl02H53Nly5hfmwadPZd1mZj7wrzHDIZ7NLAZpLby1tLZ4RaTi79c9nS7HrDi2H1iM1u57wyaKk/1t8N0hf6h9tn+1/UjMVsCipgjgmLqSaj2yiOOHlaVNBJVH9lVWU924QLrYlQ2eEizBy+PAE5AGNfW1EDbjHciSklVkog2wttDRhiehrP1AOZJDLSxs3/XwHqtPF3oUvx5oMCrqI/8zxPoj1ZPiM8N1en34+u6D3oLfdp7r2y7/BUThRKlefU8ROKlTtfUzBMQzFaDtbGtD8Nlh1+CbB3q6G9Qnw7YWakTx1xvjQwr8ADVRlG1fCAM62Pp3iVyk2CYHCAg6MGx4c4sS48VqNZ7s97YhC0EIXJkwvsA0De1wm1c+Uh6Kt4k+bSgsaA4HwAro/4P6A1iH2Jknwfa/QZ+1kZYzPtGO6OOCfomZuJQ6DG/URtJoNMjTn6QyHf71VKlw6qMMnFDWlJVugpuO+CsErKeJ9awgarj/0XMr8Hy6zvhzEe3quTkoYQ/PKsmrb29d4s8StaWcdH1wwqPxNvMiNXlU3HNfuAVPl
 FVApvh3A
 699D0O/5DNe0xvPVTovRci2ls4jaZUG5jnHC9NpxT48SjePlYOpOSb6/N2zCUgITsKHXuvKrzSITbgkdVSyHFLe2vr6CrZufLosuOpY8mnQbkM5REsP3o5705DFfoLQMI8HOFyqNccvQbj5gnDUtmxR6Bq/poQDoxaCich4m4dqbUgLiBuhCJg0x9Wm15qosLpv9yzMVqI3IMvN3IjaCOBa/nMv2uHr5VPYcF1zWwQW+4YLC18EGNNurXmuYZfhQGC06XL8byonKYN532XyxSGAwWO93RNfXjd0TeXLRYgfSF/HhgGWY7fnPNSwdLN9Fd1NLwKfZI9BwoW0my4qGqE9LVrjmCPioyv587EhJr2DSMP8HNYX5yTlvEV1PZXhxRZxMAvmDpKAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> The non-MMU stub receives hw_pte_t but returns a software PTE value. It
> has no attached PTE that requires ptep_get(), so convert only the stored
> entry through __pte_from_hw().
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Explain why the NOMMU stub does not use ptep_get().
> - Use software PTE value terminology.
> ---
>  include/linux/hugetlb.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 0d2101facaa50..637fc863d3687 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1278,7 +1278,8 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>  #ifdef CONFIG_MMU
>  	return ptep_get(ptep);
>  #else
> -	return *ptep;
> +	/* No attached PTE that requires ptep_get(). */
> +	return __pte_from_hw(*ptep);
>  #endif
>  }
>  
> 

Okay, that looks quite odd. No NOMMU code should ever be calling this helper. I
can understand that some NOMMU code might, for some odd reason, end up including
hguetlb.h where we have !CONFIG_HUGETLB_PAGE.

But let's see who actually calls huge_ptep_clear_flush():

arch/arm64/mm/hugetlbpage.c: only with CONFIG_HUGETLB_PAGE
mm/hugetlb.c: only with CONFIG_HUGETLB_PAGE
mm/rmap.c: only after checking folio_test_hugetlb().

I suspect we can simply do:

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..8642c863c1b7 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1268,15 +1268,8 @@ static inline void hugetlb_count_sub(long l, struct
mm_struct *mm)
 pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 unsigned long huge_pte_dirty(pte_t pte);

-static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-                                         unsigned long addr, pte_t *ptep)
-{
-#ifdef CONFIG_MMU
-       return ptep_get(ptep);
-#else
-       return *ptep;
-#endif
-}
+pte_t huge_ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr,
+               pte_t *ptep);

 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
                                   pte_t *ptep, pte_t pte, unsigned long sz)


-- 
Cheers,

David

