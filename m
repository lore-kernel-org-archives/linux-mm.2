Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15DAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA4D6B00AD; Fri, 10 Jul 2026 16:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A236B00AF; Fri, 10 Jul 2026 16:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AD86B00B0; Fri, 10 Jul 2026 16:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCB86B00AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:23:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B70D91A0578
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:23:21 +0000 (UTC)
X-FDA: 84973991802.07.B16FEAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F39BBA0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:23:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1DwmzxW;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8inNSEODGbyh/+vAWll7hEmDowJfY2XIaIfPLAyfMv8=;
	b=ee65OCNZkHP5sMAY2G5DyuJgu2Fe4PgsHRVYeEUAujHIIZnbcv0dBXLTTK/0akj3m/49ei
	zuH8nP8ZAyFvnAGw9dumWnV5PLVqFcXk09ASGH/sAzVb0BSZuPVDUQ/YV0GsUaHQlL+VXl
	33v0SxJQ8fNDc/rCMEnG8s5DeBo/oDU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1DwmzxW;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715000;
	b=EHuAigsgtVbjcb7ocwSW2fmAaRb5R5PBA/2FBXys9aTO4FMckmb3gU+xAzo+9vdrVsZzyq
	RxCy5tW51jfzo2R7A051WOYqkw+RmvYz2W2Wy+p0Vam56yE+1EU6EsEj9JajJzToP5trAF
	k8ADfZfdz8AG4pZxCNgRgmWD7q/D5GE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7367F60051;
	Fri, 10 Jul 2026 20:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751431F00A3A;
	Fri, 10 Jul 2026 20:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714999;
	bh=8inNSEODGbyh/+vAWll7hEmDowJfY2XIaIfPLAyfMv8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S1DwmzxWKK/EvOlvmXiaNgzfe9uDLXmTCD+WOfUbIAIznmeNow2bwHsqtQNnJDz6P
	 rqHs9qpnmDqZ7AXsBeyQzhFBN9oQXnRABs+LJNq40HsMI5lnNl+DSPJGinGwGnULCx
	 78OgKDP4iyqp5wUZhtC+twh9ggQujW01mEbzw5nIUKY4aWS4GEh9yM5cAf3VYB8bQx
	 mMyUoAKHPGwt0QsRpaNGnK2kAqbELgSA+bpm+oAZ4D8FAeyJdaN8Ea3X9Nm3YToX6X
	 LgnaMPze03tseVbPBRg/fzdp8E+k83ZRinjxnRZ9sKzJ6gvhECaFRdAXhf2O5a1uOD
	 zoICWtvDCZyZQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:56 +0100
Subject: [PATCH v2 15/33] mm/vma: refactor vmg_adjust_set_range() for
 clarity
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-15-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2561; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/OET8/zUpzsJ/XNmWkLK0gsvh8paST29XGIok8Z8NBo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg21eWBnkBU3wWsq2iz/TO8ZQcE3VnwrbFNZv12IU1
 viv6S/tKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwEQeuDEyfLi5azmfhOuak/Y7
 /x39eSMlunV7+X2dpoxbEw5qHn3m0MXI8NngWsiVLEV5+0l6Sf1f61cyr3mWXucy4WDe1De3LqV
 uZQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F39BBA0009
X-Stat-Signature: 7y9xpjm99ne3q8zsh6u83ro5o9bxqmpg
X-HE-Tag: 1783714999-888125
X-HE-Meta: U2FsdGVkX1+porifET+SdCcWqTTFkEHuyJzWdgakkqDHi7kcmPOtYDRfBvhMBMsjh7wPPL0VRuMJfBR1JGTsGdUbPFUWBksE2MZrsL4SG8USomq5pTY6mG7TA0p4xRIyDbq0hZkT5OulkDdlX/qpTgpgPEbIT1LMw4z+p2Dcgh5toCu7n3ov3xdpy7SH1/Gn1LblI0/V6tgDqXVtzqKLJoD+dxf6Z0T5FTg9yjFwPhLIpWFkWaAZfENjjvUG8hm6SD5WKJLf75OxeViGGeoft0sTAV8EoCeagsZjPDF2Sj7wbXlWfLAVuXH4HnY2w7yr2PI8GriXQ3e5TV02PJI9jLVtjT6T9rCwSQlgTZtfA1cc3ubn1OXY7CiALPFesizdL4oEijFZ7lpMbiQUe28nIPT7vSiovP2FYQIn6Gqfwg8kwvOAafE3BI6XU3tFulGtygJqmtZoawEXPBkNUPqKXu+jPYKh2rhV5E2w7fbGSyTd2K5RZBhPYeVVnB3br62V36or8j52BlOSqTBVwKWP5HojVFi3RWQ1r+bMh+DIguqKZHRcz+PjzZdTgck3PtNMQZD7QpQl53Zt8Dufqj6v9tUt5qDB90AmIf6uej17hJT3FWR96/k+eM63BXcUJuPCFDPW9zmMdgZlFuz+AzxW1+YYseBZw9kxCBBvVCTu4ww8Ta8jWxIkovt1f1lBGyp/jYPa7lINUCmrjp2bLMNl6k8V3OZMjIiSLClXwoSpkrrun5bWWmaquN10TWAzkgVYQfeupXp0HDoeng7R9r/BJFlJ1E8x2bHjqt9Z45/SLGzErk+Pl1zXUYkxVZ6LpkIF6/91l3ZYJ3tknwzjhdHQZxaZMfBcNYXxiyMvOQJKP8iu10oDu4Oe8lUpn3koW7XEtz1orcSpalAN61IszCG+1RnUo6Rh/0W2QFhIPsvEws0tSzrwH8q5KW7KLVmXWufHvnuD0h1IG3Y6i3W3w16
 xtX3QMA4
 qF6ugPoEOkfAh42K8v4zKTT/CVUaq2u6SSslNIZDFuHhRlXWlWd0dP0Ve/rtQ1C/XXwIxY7W9W6+IFZ16CnHcoT3jCYF6FwSQmHqqLVptNgVlGT0asPt9ENS8KN6LoawRKGzvWX7JOrX1YC4KPC5yuqNLdfwHsQvykd/EpXiaAKx/dl0oHAsT+0A4uUTYIns5lrBHfSJ9z855zbwKzCbt1LaAr9nh64UcofjnA6vl7qtYUT1/+oCb4ydzuLi0DKfXz0o0DIw1GEbd8Umpdjfyp030HPoSk7xhykWvAgT00jAo+HcsCBkhoUBqqZ+4y8EGqxRzD+Hi/vpxDG7xxAXaXZFCkUbHmdhy8dq4NQgc9jsLo+iN8144bYTmBlW1LfdU00csR81z3nXyoyWaOj6znIOJzaPoFBeI8h/EFqR4b2gb1tksn/Vv1DXSyeVkBJJ2T5zQ1CIA29vt35VZjijnFIzW1GuPS2/KpXSyiG5uigv7OxQ5jqjsOHhdoJTauguSj6A75Lyaf9r3gBzKdO2FA1Pqvv8ypQ8qUhTfrlG5mnhajIX/UYjjh/Y11Pk9LNgqBM4G7Di6qK0nXnJbf9xR8xR/5xTnRIN1JR7zILKgrYdvUSJo4y80S1Q4D+IAgu13u/iyqb6r6ShxVB3xcU2DQyb4WW18uBLMCJs94UK4m/u9ba6UBNDmM/OLzGX2YNzYkjuDwBV82pE5Xzj9HXaRHv+y0xr6WYEDDkhUgkIWkzrn1C8gC0w8jwJ/SWymLJPAdy23XY1cIOF/LwqI9qWrNsnouWk8oGJsJ25JFgb9ILqe9u9warQVw/j0YKwnMPJ2d/9RClLdu/jmHexFLRjF/1IkuXSqRQZY2epzjvx3+aOWy/X3Vb5OEuiou0m5khQ8O5shpSNshztdq/1FuqFgko9ESrFctlq3V0UGjW6eTeB5gfJatHbGAZ/OMC3tRakcjaD6qN3eQCLQipQHE6XPh3s852od
 Ky4MKh6s
 g23AhaGmRc9TaefVmsID/kCFSR/wBlj1eo+fGJbFc9mIPcnDCcb+mNzcwDtM3/6zqKk+tjxFljH4WNfxxs7/cD0/Gz7Ap/nvMBCnNQfMyCl5dAoWqa8ssaGafq8aIxsOUUBUqFFnwxBNJMfPvdJf+2ppbx70mJtjf9YWzVsXcANrONB3eaxOu98WXDQCeS6q9KNAK9z9cLjP/dGB6BpaEYE8sVWM8klk5nHzQHQ2DFaGGtYLup7Hv1C1Zic7HHlBRJUF4T+EkP1SDKl992T7WqdZS+LTu/9hLiPC+e5L3UnkDZPWfX4emhG5X+gDTFkSI1rz6wtyqppNsrcOHFpEDziRg8DKXeuE5gVkEoNq2jc+yo9PRRejCzB2InhO6q1Z62j0O9Lh7e3bY4OLZnhut9lbkw4+rdA2xhdjIxzTtscIgk8Uqh5FQWHM2QsOLCr9qFAKXdui/ZsK/EJ+iHjOu0XY4WptHmg3+CPw8o1vHZm3EqLQh1Tc5hxgiW4bLvHLlFfkaDiD4aTv4tDCIiWWiPzKmi37p7N8WFcYmaIFP3AvSxdLfSK+D1CqWnsCp4B6prW3kuQJMyfkwJMAQJYxH27xVvZfmr+DCf30VpidWUlfFon6roirSY242Cm1kbnzI0OT8oUd5j91b1uXSVGvUECLskIduzO0/95ksT/btH1z1bpxg0cxv9k7AdfdQgMfWMGp1WxvUXf2cNA4tgHiLqNk4MuaRlxP2edy6wGgvaV4pZ0sF7Lr6r7U6N7HVhBE9IU+3GsIPfxb1B2nkT3fZzJ/gpwF8qZ3F3IEvNGwzrwj9hQ62JB5UYp4OTBljRo0ezMWn5k6y7CyFmxtvfhPfz3Ud1lrNdl0pqSH6U7ZefWo3pyths36X9JMOHgerHwB/PSazWXs99/J97nz/4xIzHQRwD14ZIVaVR/BIJLsn5brKlLPx6QkPOsYRCQckouVhg3nzgmCgOUwNJ+hvGBbrQ2oxzewf
 M5UxTJz6
 d98bAsDe9kcjGnZ1SlPVTI1e/ZzvMsNN7zmsIHzHBHVRYrcQv5PePkXIlICElN4Z17d89BhENZId5QzQw5nRFRxB8m484slvFwtsc6D2hhccJxMQSWFExv1vg6KwUcPK0SIogC7NCBBEkgLkohh3JcKWII67Mu2RmJq8gpj7k+Ai/0FHg0SwwmQPbSFmgHEWJoRE3QrWQDMpW4rUeCKHtr/KcfRvEoxu7t2wfh2Puz9k41wROn84q1MM0eD8/Pnluvk8o/JyRclzxd92fGHHYzvG5/2EWm8UCQCeByWB9S8CLUBnB66b16w+OFv+vPs2xWFlS27DqMO0OgnvsTMRr7eTo0xCkNUxw3e3wo2C+Kcprs0/SF/xDsBTGTOQ+CZc2eJoSkQYz3tgQKqr+zSLIsLvKIVML/0Q8FMGlfEWw5mSF73KXO4MMNaDKKvfXYOLcJIbJPAn2CgvirMYlvKbAy9QQYd7aTYwuAOEmbpk7bnAfzO5F+J11FmNCSJ5KTQ+MztTNaqrihzPz+UiCY+HBsY+hOXn/cLQjGCogEMxolChavT2jP2iZheyZqtxABJk/WgpUd9T3YK4c4nud5/droXVc1neVW1yhwr+CfWj8hmytm6Kkh4ZmqjfXxKRBEn/Y0ZiHn4wIyDII4DkWOzszOta0MGdvXocxVjibwqN4LLi9iVw/SNx/x07omtS8HJ6up/g0PiaWB9vF1cm34mrs6XNF4uwa1SC4AepVhAvw/Y+TzqvJNdYPOtt+a9+uvkvyyhNRwfJ7/7j5UaiIkzezyo7lpXEUQZOU5MRIMov2oRwzY/eluKfRF8W+H6L/3/vpqW13adeg+V+GShjnSxKi7btDfNXiN7gqjjoXP3qBl2cAlx2hHpKUtZRqsKgNO9oYTxGtkamskLVyQmbrB8ihXM+IQCY6iSlpZ6Zx8IymSJ0y31J1vStU6Q3ncFywLLCAiUIFTJ0V82No1EwF0DsSDhtsSSgd
 ulRlnXAM
 yCofS7y3Nbgugt+rt0jVp0eLv2ebPHZku3hHuhjmARlsZ8IvbgQ5+eU9uWcTHblLFIcn1sINZ+ulmT5xW3zfQND4BgvF+bzOwfKqzoWtFZcUPOmcQ+9tqMpXlJV/h+uN8U1wHNTcf4B5ztfz7DqhAcqcrLLdHxlNMPtKlhwjlmsMdL89sXU21Bi/pzaPHWCkYsHNykZe8qOcQ1FapLN3JWoAp/TQt8dpRu4lYYbreSkilEyQrrYPN481JIRwBYL+cXJHO5vFBaKLs8hwRzIIoUGJqACaQrvbLHbsMFICEC9gznAqXTdpCRIbEZs+FtnedDV8P55pWXu737BGiX8RGADhJd/ynIZJEIj4Y2ssl6AUqvJCpFiyoqi0Sf/GJtxGNOihlClAOBLa6ieyUQtjZQdyJPuOypV/bzkpJWjz6PfrQaiG5IbJ7duzcni2JjbwtwfCt/UztKHHpEtfSiqXDY2gA0prbesZeB5tt+dMFusZqNht6ynr3LhI3yy1fZ29urtHb2dHwLOV1f9Db+NefuEeR0DxBqxo19cytF+6UP4kk0LB7OKpIw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add comments with ASCII diagrams to describe what we're doing, avoid
dubious use of PHYS_PFN(), and use vma_start_pgoff().

The most complicated scenario represented here is vmg->__adjust_next_start
- when this is set, vmg->[start, end] actually indicate the range to be
retained, so take special care to describe this accurately.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 084afdf37385..7265a054cfa3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -704,11 +704,54 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 	pgoff_t pgoff;
 
 	if (vmg->__adjust_middle_start) {
-		adjust = vmg->middle;
-		pgoff = adjust->vm_pgoff + PHYS_PFN(vmg->end - adjust->vm_start);
+		/*
+		 * vmg->start    vmg->end
+		 * |             |
+		 * v    merge    v
+		 * <------------->
+		 *         delta
+		 *        <------>
+		 * |------|----------------|
+		 * | prev |    middle      |
+		 * |------|----------------|
+		 *        ^
+		 *        |
+		 *        middle->vm_start
+		 */
+		struct vm_area_struct *middle = vmg->middle;
+		const unsigned long delta = vmg->end - middle->vm_start;
+
+		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
+		adjust = middle;
 	} else if (vmg->__adjust_next_start) {
-		adjust = vmg->next;
-		pgoff = adjust->vm_pgoff - PHYS_PFN(adjust->vm_start - vmg->end);
+		/*
+		 *                Originally:
+		 *
+		 *            vmg->start   vmg->end
+		 *            |            |
+		 *            v    merge   v
+		 *            <------------>
+		 *            .            .
+		 * merge_existing_range() updates to:
+		 *            .            .
+		 * vmg->start vmg->end     .
+		 * |          |            .
+		 * v  retain  v            .
+		 * <---------->            .
+		 *             delta       .
+		 *            <----->      .
+		 * |----------------|------|
+		 * |    middle      | next |
+		 * |----------------|------|
+		 *                  ^
+		 *                  |
+		 *                  next->vm_start
+		 */
+		struct vm_area_struct *next = vmg->next;
+		const unsigned long delta = next->vm_start - vmg->end;
+
+		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
+		adjust = next;
 	} else {
 		return;
 	}

-- 
2.55.0


