Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9513DC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605156B0092; Wed, 15 Jul 2026 13:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBC76B0093; Wed, 15 Jul 2026 13:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A57B6B0095; Wed, 15 Jul 2026 13:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A82D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:28:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99146160241
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:28:28 +0000 (UTC)
X-FDA: 84991695096.08.1F908D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E999780004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:28:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YgDnipMK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784136506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHWStHru8HkMHnXA70eivNeP0TUQLXilHTpPmDY1vwc=;
	b=Ovp/H+w7T0QoMtBQLQAbkqzT4AM8kTplVPHlF7OjxqBpq+Upo+Ar/sHKKKWQlAzS82gfpc
	b3OC1+EX5VO4BPWistbOzX8OajLZyrMd3ZnhYUkT5V92LIhUanv4jKKB0K5/vN+iEdGCJ2
	8Jy2zl6pZZ/0swEZ4tGE1phQl0GEDXs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YgDnipMK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784136506;
	b=J0uOURwGck9kXeaO0RbuSIkG+Tadjl+GnyhamoLv7l+0IVVx2tq9T4Jh6S3Pt7SJ3tFb/T
	Is6nrb6gyydHjZueAKT2tFo0TM2hqGWKzhdflIyMMjhLcPd0x/wElEJ/WdKtyHzXVV4Lj0
	4aFI2Dhemn4aWXSZs1A2CqLpNNXCc04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9EF6187D;
	Wed, 15 Jul 2026 17:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510621F000E9;
	Wed, 15 Jul 2026 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136505;
	bh=yHWStHru8HkMHnXA70eivNeP0TUQLXilHTpPmDY1vwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YgDnipMKxEbf1h/N/L2iU3jIjviNesSjHguylh5vNGCSyn7JDlbl8f8/hqe0eoXK1
	 JPBNOehVyi0jsLYaE1N237I89/zC0TkjsZkRNakVvLHnsYhZPd5j8JnvAs1k4QZIUb
	 Cry5BgUBnfBM5XZ1In8aj19Wcr1cH891VOGxIxlM3jB+Q6gP3365fiLjFdC0wXWHuB
	 nlPIVTt3S1mhooUVePij3jT5R3XIuSwXYmcSMzN2t0Kj0cmjKQ4+IOfZCkjng0TVuo
	 N/1KV3jAIpGuKxZDU3P3FHqMlE909NlJIaNlch9zDmj9TkW+UcvhyguRwDZVF7vM48
	 VSKNHKxT8S0Zg==
Message-ID: <aab69bfe-41a6-4616-9a6f-d93a446781b2@kernel.org>
Date: Wed, 15 Jul 2026 19:28:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/33] mm/vma: remove duplicative vma_pgoff_offset()
 helper
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
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
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
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
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-20-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-20-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E999780004
X-Stat-Signature: awahzyaop877go6bzn75czhwtkadgzei
X-HE-Tag: 1784136506-284203
X-HE-Meta: U2FsdGVkX1/nz0TLPxPaqmAWFVJCD3iCutCM2OYiHfdONzDno+e6ik1opIJEmNctL68iEGyJBsZ1e8LPFzl1sWZ4Kf/TggSw8/iY8IlLCgbtFAAtxKbHePrY2hUIUXf1cOmxiHl7Nw5Si3r57A6eiArAsIo6uy3NKMi0JbGGIh4iEG9eyLhHTPx927VL8ZIyvOY5wThy/OQssgCTNbzKUnv3DZOki2PCuV/deawp/swSkHw9KimenqtVJUNg5TgbdFTm4Q5TUbVzwXwQeVHtsgSLwg4iFz/zfukjYKiGlIjVOoAWEw1mcVy0HjkAHUWO4NzPQpER3o+ZuYy3oslEQS+4zHahsUdAhI6wCwvOD/0JeKKvquMYRqNkYMeXsiBmaCV4Vp7Xcz2mFZsaQnMGZIpMrtYSqOny0lDOzoaZaK9PObucmGIDVnpwTOKQeYrZQzEn09fH24lPz0gB2/QaWV9yjEGJS1pOGrEa9wzDezd8Ps9GY00kRjb/08ce3xi4t6mjW9pcaMBoxxUP/5TKAoFCs9cFxh41vBlNqAp9ewevqId9pjo0eyredOO31lMYvtuCgWf/77NB0ItOIuQCARIjd3BGI4vgbOkQTQRXNnNDiIXsBUlmudjnpdc5kxKWEu1KeAA6YY1nni9B6tNkCCwY9sWL+govqCmbtffOKfq8bOUbuVTVT0or88Kj/xpi8rV8BL1Q+oRVGbIB3PKKU+DukDJ3SnNTAo3ym8w9p+cyB7qHttZQgHjLYWzsCz89fK59N3NvwJBR6gZeVzDlyq0kDAhvHZX2xAUwq1PqbSWT34AdzONtUwN1p0S2A6l7XRGdhovstdOnBCuiWPkLau3/tcOnQamN0SBR1fNi2YC/LmRnbfEUBSk0PAOvHWwZ6Bo+dw4K0WYWTM/TVD+zfVedJaUkOFLMqpCiaYdpN+9XEW899ntHmFU1+Pfm3qisBBwzAiQ8+KpEr9DVm3b
 gTmD2kTX
 BT2sFn/W+N+URAkzRRIsBXTDG9YhqOolaQCNfwDHW5BvS8X90b/1wi68NmsNZMVHL2qGDkxyBdbZLCoVF/FZPQfqRW75ayRsS2DtyfeE5LWDnyxYi7JUeNjLUDEECPs7sYP3rwSQy76vaRBukzsBJkr0/JiWbIUzgkJP/8RGSYVxJQ6bUVetXWyXCDHwwAHVUpEat+IRLmtjB4IyUN43UCY4DnyvO0c9LxtZ3L08mG5N41+nE0UtvQj5e08nSoDCcSJnjpXYxtMS82DDD1mUmG3gjG4aGu6/Qwtc/wYsc8pQlSeJL38dc1ipy2lIYwJFT2q6YyU49cSfq7pezbjNMq8hLyuZ47PQ61Ip4LUhwKkPKiMKq6ztzmgItCIf42lUpuV9vAbeyikvfY3IWM/XfIIun9uzst7d6+cGdYZffzJ6n7JPbdPrVBZhgEVM5GakU4BPFyNHEN5+z34JOcrTnkSoL/VKFBljr4HVVf8oHdD1uuQLebe4TCnm1en2RN2JIYoMWPfoja6/pgpZbhKHVPmMixGCUPn3aSBeJ0aantpLXiEJAlsuWYStxKqKcc+fzY8veHiKwWyV/OQEsFxhBGX3BBozT/cZhKS9TN5BglgRlSLLZ6UL0oMi/KEK+sDHR/2k26gUjitbecCqyOJTK1H6OnkrhOEhPYwtxMhxl94coO12zA4lYW4wLHgrEvyO81Av8g4bevsQ81ube4H7i/dMG+JBWL699JE0evOufFM2RIVApJFfFTyjcyIkN7SKThIrqjoCAInpAqziGUawE7h2ZyEIrFKT+gN8O7U9ZZX0Q6xYw8xnCSKralF7f1fz6jHAR77M1nJf+WkdIQ4CbDaICo8gfLVHGpDqdqHK45GAk9+PqY8+rjndrEDReRmSORP0XV6pdMva9TN+CCx2n2FtTLz8OQtF1H1sVKX7QVr1z47gqHl7Eoj50KEMcFWPaE/X9tbZpCnQ3aGzX+Nd1PVThq82M
 I6l0R7oX
 N/fzJQcGAoJiH/Rb/j9jcW8nLX28Wyl7qdxcJyvak+uFDzyz+h8BmrT+cGbVr7NuUFsK3G9lZ4DrtEXIEzD6o9AnVb9DS7l4sXCIpfM7zuetIUahO+uqWEVNskqRzRmTHW8YrgXy7fj9Q53TddhTLbPHcVViv2odO7AgoI02323HCSnbuTlH8YSCgaeW8mssBF8Odkdf3y1AHjiQjhBpbtL4ooERTrYY++MQJDjJJWWBTP83jCmtqEYl83kpk+TpSqNSKh7TdzEiNB4XJbjPP3EfYnxKzsUW12Rtu4blv9amsNU9rlXDOwr3kuO5V/2hOoWv4sS9jfIoo8PA+Y8NAax3nWdwgtouky/1JmUVDW4jqi2cHffhaOIwj+oAwnhF+R1PwL2wKhE3+FxVWknkvnPzCQQ+BPzYq80/NEBs2e3ZicdHcoL8jCbEe9BVNQyAgYa8GssTVOU8449ZA5EtXFaX0dso5UXvPxYAq+R2+07ALslBtjPa5sYjHGgsNmTOeHMEIQ3Sw0bK5kRppE437i5PIn4p5JQLIy4UZmDxL1sfgnx/7ngB/XDbEbdOQIA6/kkDl2qHDAYNmI79kSRcoHpc5ed96F5pXxOAkgqMvxs1bX8wEvNOKOHECt7Uw/z+YDfT4BM2NM9dmGIk0QTZoQxPe3tR1uf2f+7h2WpeHBtHNyCybndL79jMTcaR7ncoGhlmmSi6odBXIvmaYamLIIaETwYgW3Xn7OeA/4ZAts1mXyUKE+W8Hf6WjadaHpby3wTTgRyOqYtWVc/pYayV2LlxIIi/eNeDBW0vd0/StRn3RJCUoDDYuQL0G3GrrXS/TgsYu3JSV+fKIGqOaTxhYqmkjL1OjSdgu7J424D7CDuAcPDKvKp5G3Rq/dKCiiaBxVTB3WofUTHMJ7cO62w45d6miVWPJuFCxhPkEq44+YliufFoldOV2tw6C3ljMj8cBUm3zz2ctgXEZ505xIeTxOycVZ73e
 5BFh5vCz
 K2zi9CV98YwYjKBJJl4/DOJI2bIEZXdGPvggEmt1tGigIkAegwN3v1elMT4vDJTvwwVx9X5atyzWCccbt0pWdNtF0bmeLhtO6T9qz5PimUXKZ58bGu/LwwxGOpheOZDxUOvkKNNLfd6teb2hagCwOGeesvJm9kivB9vMhCzdR12VFICNLbk7vfxIauBE32IBc/xEJk6KqFI4UBjqSuL0CkVLkSG+CfIqoSYdA5YBNo5qj+M5lXawok/oGSFzS9d3FgcZA/PEo8TO2HkTmNsfMZbisk9onVVy0b6xC9KsysW2AMIml0U4KxsH7KASCo8ORfGU+i6GgS+TiUZE6yTo9k0r28+6ukDU/68NH+WJ6ZLZuKCkaqCJV5N6+UBOsMOAd6cmUnIVuuaaEPkOxbPMTCqubj7U8PCWYocfTzUtA8hn8g6hK9qzLc2fn7N/J2tRN7aqPX4K+3n0fhf/78Jsmj3URECkfuR8QisWJgnR+E6XMmzUtXJievFZihIpQxhx3LYHWiw2ZEsQye1yzxHCPspllohyAygykdJWWYsfLljU1cjVfEv0YOoSEK0TDCxIovR0hF0hBc0qguJSNDur6Q+W/jYLMulR4BfZ0We6+/KlyKMwUEtl+jPZd5IPTQjVka0P3ZTAhhKm0U7xOxg0R15c5VLiuGmIabR06Oa5XitZQI3Vry9m/1GdR2VFRwVkqPSL73ul5Uh/EDEnx/7GXFTkMdZMl5sf8RXel0gRU1zkKndB08FIYTbJto8i47h6m0fBSK/Y+/I61fecABXxfpVRhSkdLz3/Ipjd7T/38wZOGyfvxjx/mLKy6YZUxy5LKxYfRJ4ZjDaTelydAgulUjN2yiaCzujxXrAYTHDlrjYF0DDsoRPWE8QZOzTUPKV4tMPsOS7sP8qpmBBNspjBIB2bjN+MZvj5JIm+v9rgC8UrfEk2233TRzOmgg4XIhChoZlMIkxDhCrH+x9fC+MHIkfiax54G
 5DNA0UDf
 6shzdFpBMHOc2afcZkAbOJ9Agwxt9TMr0A0nMUoru2RpaQdl6vpeu6hwQINpKhOOSsfoScfJXQIjr1eF7ja8IhRq+2vPSHYldYCjMeg7/9TNuQ0ilHKkCeJUQYogHSbhpYnYERul+DKc32RDVlJG4twIonHQrgJ1lJdnZnBuqUH0bEhkvlWr/ZY9fx8FKljopTZ6Pg5VoKKx7425WqkyG5ngNqJ+iZoJXOGT11cXwLIFLYmKbqxW6yapPD8PFREJvvsfgXhWIbD7RfimPkWEnNm/wfcs21cbQeemQgwUNVKEY/ml95Oxoj4dqfTtya1ZL/qiKuA0QMYvIP2/ZpYN/rd15HIpipk3YU52V93JoZOLT1I3HTJMPtpo5vQfjNIOiCBs8Y+F+5/qh6nv/CrBXiNJ6bKHvRI0hs9/YGGeIIBsK1fn+I13HmWehk17+h5TpKpiAg3a6AQQucyuk/WPwC+ic8XCqHFLAxRb448isB37t17CJAM7quGNuOLYtRyfnvwAg0IamudmlkLSGCM0WMTiSzNMQq69wKOOP3WRQJ/qdydNpnGOWX8Oy3R/wG16VY/zM2ERi5yJ71DjY8bBTlNf/lpIpPANC0q+kveMl2blrYarstbv6LFCgHVYWvNqnVw86HAdtOqww6WJm/TXfOExxEPH0tB04qPI1AjPZJ1yjnxhtIlRdvQrMSUWumQag7CN9HSS9MQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> This is doing what linear_page_index() does, so eliminate it and replace it
> with linear_page_index().
> 
> Update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


