Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5211CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430FD6B00A5; Fri, 10 Jul 2026 16:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1D06B00BE; Fri, 10 Jul 2026 16:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA086B00C7; Fri, 10 Jul 2026 16:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 014DE6B00A5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:29:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 933A61C3BE7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:09 +0000 (UTC)
X-FDA: 84974006418.24.88E68B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0428140003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HN/nTgeK";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715347;
	b=5AGjtZXyr6fpWyedSiudMaL3IAggIgRVYcTO6GX2d925PUnfyIuPw1hudISUgY3tZBrYtm
	Ghtr1XCoon0wrUV/WR0IB1IwLfpDC6wvVD+gKuBgIxClqtCFpabVWveFX3k6e8EE8JeslI
	tqeDajZD8cy1MJXF8HWk4tYpSXKUq+Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HN/nTgeK";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ql8pfD2dLkZ3j2ZLRgwxtlbsXGEbzU77QdgKu6+RW0=;
	b=jsZg6geWZxITdsSeD97w/d7b6kNCOOPLx3yM1tGHJL75eTCHFp5xT/7Djmunqsznv7+mZx
	z0K03x0+SvpBmh5OmWUZxxp+nz0caBv2nCBQMmzl8dT3bwY4syBauzefw0jmaiHHBgdGlU
	r3NriP+EmJNQ/iUcWnc7HWV92rCpu2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83392601D9;
	Fri, 10 Jul 2026 20:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563BD1F00A3D;
	Fri, 10 Jul 2026 20:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715347;
	bh=1ql8pfD2dLkZ3j2ZLRgwxtlbsXGEbzU77QdgKu6+RW0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HN/nTgeKq3AnMjIs0u7JOFWgL8V6dcLlJmk9ikJ8fDUbMBlZLUk6KpsqhTpY6f4Rk
	 cqc+QtS61rJvVT+Ieot26FX4QBYJX2NWdolyKNWZN+OpJv8b6VLbVV1oQSiHVnosL+
	 el9kwv9KVuOaHbau8QAS8wvLAfNTYvAb4ZJWcc07ARv1rGWx3AiJuSs2p6HMNHxhrr
	 yNxDfm62mwI2vkLsGoWHpLP8BEUXJ7q8pRDCBdgChs4OndWDlfPdmsS0BndIlw9ftX
	 kdZHMOwRHnn1aHsvYqf0OdH7AS7sYRrsyWJy4u0ytikVJxADHfDwEbDXZMERb/f5Qq
	 9Tw8VKMmYGVQg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:11 +0100
Subject: [PATCH v2 30/33] mm/vma: correct incorrect vma.h inclusion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-30-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4536; i=ljs@kernel.org;
 h=from:subject:message-id; bh=shpFTR/kYRzffTsm0zlgjzVGjq2PyyHz+kDqenhzfis=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg201dv0WDPnXKfD02fVrd2xmnJGosao9+KtYLrPMT
 ee3uOTFjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExk6htGhutMvdsKbROmGXpe
 9bRozf2k9WX9ovWH62umFivq6Py9+pCRoftC5fGIB3Fbpepc7q+dFC6dVurt13dkg9IG04qXXkn
 b+AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0428140003
X-Stat-Signature: i3wi4bar5yt9pamg6n78hhddeoe55x7u
X-HE-Tag: 1783715347-285898
X-HE-Meta: U2FsdGVkX19AWgoDi00Mf5he745RnI5Z+89tE0v2ynhMPeo/lPayUzNquWRMt9iFIwud5kSfbKcPKZ3SG3Zih1I1/XPEqQGv+sxTsFz5YOb8fXtSpxV0Imwrj758WExhOaJXWPOoz9Us4/M22QrIpLYnptRXuG84FIq6SQzoAZddkynLZOEN2RjlsWmOkoP8Wwo/571715nv1iYHJU85vk0P4GD6988cWm+Znong3kKqCAH5wQm1AFVAYZePOghO4nxeBfUS3sMcTbAxNk/lbq2AwpK6L1i+coHKCbdWvNAAGQOQPahn3bNO3XavlUnkDVrb5QlDDH+DEVH7z0ndQ3+02v8ZebtINPDZQhCODUXoF81ImBTT6DlhIns5znLzIAp3orHNSg/Yxz54JTd7X6180XS9j1mYCY+AoeMhnJDJ3ORcAHCmmidacpH3yXo/cfqmVPzD2nULSOu+yNH8Ma6uocHbfMUmAHjdVvT/bWnkf/8K2WM7VzhKLpgv+LxRv1G0oOoiHjEPrCZKu6mEXkLsMdd28MxMNjaYubEwsnxs+7HQ+unq6V/xtM7E8VOuXn/JQvISPl8/TE90b2zlrytKggls7UZGUEqUq1F6yQdQmA2/a9VEBFb6wCKyy5eXJikVgn9zslnkmDu2OVdVsyIheN3IukL/nNbqkTUeS43V/0U1c67mR0WIqgDH7sY/plOpHO0LZe70g8WF5GYXalPqC49nZqRnw62WLLIADigeD0f24fA6nzgPuDp4PnRU4fQGUsLS6PtzRWUo5lbbqnNGT5eE8x4CcDBXOOEIUKSqQYccLCO+7V9dJc28Jgpqm4BF4+6fvFAYCSUTJGj795ce+la8JhU7WqtIAYIGW4/5bgYmjFhQt1ndPNQCMEy+mY54+pD44A8MkizPbpLKcTTgfhE69miRF9PjRMhe9gP4FGcERsY5YJVdP4Nm7ckGQ4wrn/9wymItelh3j41
 /4BgxZ2t
 e0C6aozPFnLKQhbFfVoVC4n49LnHAwoQFm5bLKKOg9/lIN03CS18YtxiKb52li6BiOGBvigc1ormwJzJyteannDavQy8hPiGDHKZAxD3SSbs19+PP+DvUWlrLvlwR/xtGxZDQCNM8x5dJ/KPv6tMzK6V8vItYovyizIC1pactGjvfAHlAfE8+TTd8edn17j4hs9bc8/pbvAZ76vFjU1WeH1ILfiTXJci5FL2rKIaKHrWd+J/kgzSpO3vgQu4Yd9b+zY9FxTZmKICST7CrRpeYdyBr9sWGhwt5FAtuhTxCxUxphBN/nXwu1PUh2C437kaqfmJofh56Hm6Z6lNNYNShlBOgdOnBXJzJh7IKCmWijOvkgGgkDshTaZtIPkZ/990bbLOgKo1zkUcJvdff3RN8s4eitCkoNdlFwsR406iYdrwj/CqufrJx8xuz0op/TX8hoeQwx2fFP31nNJ3aVf0YaMvA+38A3MA7KbFM7jtZ/rn90Isoaj3vlY+dZa8+HYyyrfO2FdZ2wP+ZWSb2zMKv8cFvxI1yFI96DJQhjJzcD/cgcrfJT/cMwXkKcz9+2qJA8Sc3K11KtSJaSpt7e7oeWYZvpc1eZ95mmk2+fFGGJ9F8pqymcIFnJ/rMvkjZMut14ZXr1TeSPrYf/fYp0oBJ8zVOoGWfSARX6baiIjcFf0KBwl86l7EoTWFvGd1FR+tjDHYYBk0MINbgDiBoVuJEfDm883E62TKL21NED8VEsKyB4wqiLnSGd/ukJS9sZE68pTbuXV4QIeXi1zbsGjebBtkzV2wmDZNKaHRyJmLPa+r6Lwzm/S6dvSbpwWQ/MdVeyrpdPmMOOrmQwe4IeGLLsQzQdIrFuzZiWKeLyQR5CsEfXyh1gDaBCD6bAakQIzCD7rJ9RzfZrpPpNJxBt7BhReDjvuhWgYNiLBOnpBil9kNs/VWR0bvKj7+HUfbFyFJ6GmH/CI1XKwHp+R5jxUj7uFox+LU5
 ovHNdplh
 i8wXW6SWWAfURd5qE6xIBkQpjijwuoBDPHUunQWiPke7x6HelzSYXR62+ZDai5Z6NhyVXDktfxm3GpfD5U4eDItx8Wv278dJBvxygeWquxN0bwTPhsnUfqulFtgT27P/0RArgjJIqAtVJB+KnEDcZ6498s2KBmOxZfYKlYOvtSUTuy408nduKAqGf9idSFVxQ6EzdjwFvstd/YmvsNSSszrM91CfZDwYjo3PzslIlc1WWf5svMZXsdAF/s4zZytEYPkkbRiKqYv7O6cNWNSbR9wUup+N93Bu+1KGKGa8TBy03lU2Gv+x6zMppOZbs/zkkuWAajWjYM6CQPR5q1bWq6L+AHtMxIZ2ZKmqYCXU4q5dzViO0MqDOqqcgY+dpml2yBmipRUnlqC1oRA9J7Xi8dADEHvWVAmydpP/q1zoBF86Q98mEOgPOjJEFwiQjMtDLMXa2Q5c9M5fd/JbiEeOMdOiNlRSc0ZoanVf4E3C2gHgx8K0QtFFtADCLa4p9iSJV19qOss5RmZc/evZEwxJSbijmb77YrocsVE1wsdYxI6RzUA0V9zJyV6pD3/ArgGIX+KS1Na7RxMLLBSlJ9oqxxR75cvllb597wg3VKqHiwIY3hYcflMi4+DXWTdKQGxAU7rbMDw6BAScvgZvIWxEF6UNW55tmidsmdj/5ubj7Hj9iT7yosas/asYPuqsLaKUPnv2+uW1VE6hwRsERqe2psLpzNn1ENStjiEKhxhld1rdvPaWNSb3VAk8MbXYdSI5fSQMP7IiAN7pRBem6zpd4S8A13jMkrCXJAjOsvBD7548MiMt30dujGENTWWXnrq/LAlhEYwYsUolwMDeODF/7eEsmur4kmde9KPWAHZ+H0XdFGUPQp7dfBCmjai9hwEHbvQYItexkzbOFDbKKBdf44JiSXdzFRfpLMuyUtT+mKQLt6NSwEefa9wZCRVhWntc9t/tIoif7RXgPRVHXVNFWsOjrMyMY
 0NZ44fLQ
 KLTJpg2EevfERfdtYA7pgqlMysOlDYQ4j+Kxbi4ple0nVFvh8hgGB/hJIWuLkxZSkz97gj9nIafnwutNWcksJOVApEhnNoC8MWxTFlHNGHny02sVXvTplnsTKRbtE3mUWuvFLwgmuQwGXJVsg27OLE5pCdW4I/ljqQ+gucK+1n9XROpj6Bb769bXzb/pYSNF42KgqEZ8l6s++XeLlJS9neQVbCOAy3haz558SA4mA3VZvqqPoOlqsWqnuLgL4L/EDMSdQPhYubkSpU4+zpcKzMhapINa43uZmMg0H6oUsEJi5veodHm3uC6kLzZXE1I1Wc3xoDO+UKjK0NOcCeHTInPyuJqnelWcY3SFM03/ou6LGWzgnd9D6Rmy1+rkHeh6hfn/7elU7IKTSkWmJD9wyRmEoSu/oyWXunmopEzkXVKVZzch/Vg6nJpoAmE3Zv3k2OXCkZu4KRFSulElbsM2QG2HoDuIWa6NA2ZiXvyAK0/dlNf1QTgXXsoCFGAxqGfmx6HwRw6bH5dVnP7R2SOy6oEQajnYRYKVF62MYDj/6IYAspFmFqb8vvv6b8AQfZiG+ONlg9usL4rTcyxfnyySKCfjcZCiOhyOvjEsBtYZl0WmDBTpDiBO3Ph8eUQwzid2Eyb1g5vqNPyK83A2Tj4JfO5zBadenJW/DyPrpjnBtVgoA6r0hF3Kg+Y0l+uOhtNKbceRsHEO4KkV4+mX45Y5742RTMAeaXnX/CHGDzRyXSlGrZmKBFWITKe+6MQnVOcbpaXHaFelOX7nIBCBsIbcgtofcmq14Aaj2b54XnKgnUXjvl7Vey+sRc8zhnIyJ1vEgkGTnLS+rDuET+VHN1+tEN+Cc1QRZEIwTuuDJLr8dQGMKGSz4vokwboeOec7DP7CUTLeSQjEf4YgPBOZ/JR3hntCdK5VPYhz+Y//zduu/PS4W5sG5ff7TapHNZmQpp0RMDtyy8O4vqqo73XqyI0JncMf6sBCO
 dn3skBO7
 gGqQfvnpQoBnFv99A1ie3Q4sVtj3mtI6Ie1l3ughk0+U/Z0SU47juZWEri5yVpYy3OigjMDT66StM8T9ld7giFLLhbacN/mBafpOqtw3kJk7CdP10xfA3Ri5ujqgNDmbL2cqToiu6wzEv4aJ1myC9ClIOoPjBYJeGQ2QM6CnXSsbW8w/YxVjuvup9MDc9Mz8d5GPoHc83H+cPf8z7aSDAdcsqaRCPZRZY8OlT68G/mU7WeXI6MD2UmFKFs8Eg7WoPy4w2rBJ+48TLGfpCoh/VfcWLsz6zIxdVhT6dJWB/AWncDLIwSZKFdIONgBapyKqsR/Ulxv2lCAEl/xuy3iCS+DQJRYFDrwWu1y7TjHi6BIry0ElG8dxcajkTXs7377H1B9EZP+1SI0Z7hwQOTYTKd5m7ECs2o8ZFPWk5n0pux9bZv7dilMmfWznnSnXX8o4h6RNg4yVBeUplkkeIwk+AnYo2vVpFznSUhKqq2CkYEI1djBnZqHIIx9cGAuTOCl+JJ53ddcCvRig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only files which should be including vma.h are the implementation files
for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.

This is in order to allow for userland testing of core VMA logic. In this
cases, vma_internal.h and vma.h are included, providing both the
dependencies upon which the core VMA logic requires and its declarations.

Userland testable VMA logic is achieved by having separate vma_internal.h
implementations for userland and kernel.

Callers other than the core VMA implementation should include internal.h
instead. This header does not need to include vma_internal.h as it only
contains the vma.h declarations, for which the includes already present
suffice.

Update code to reflect this, update comments to reflect the fact there are
3 VMA implementation files and document things more clearly.

While we're here, slightly improve the language of the comment describing
vma_exec.c.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmu_notifier.c | 2 +-
 mm/nommu.c        | 1 -
 mm/vma.c          | 4 ++++
 mm/vma.h          | 9 ++++++++-
 mm/vma_exec.c     | 8 ++++++--
 mm/vma_init.c     | 4 ++++
 mm/vma_internal.h | 4 ++--
 7 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 245b74f39f91..df69ba6e797f 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -19,7 +19,7 @@
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 
-#include "vma.h"
+#include "internal.h"
 
 /* global SRCU for all MMs */
 DEFINE_STATIC_SRCU(srcu);
diff --git a/mm/nommu.c b/mm/nommu.c
index 21cbe8b093fc..adc0b0ca906b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -41,7 +41,6 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
-#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
diff --git a/mm/vma.c b/mm/vma.c
index 7c75dd78edef..737f0d692e6b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -4,6 +4,10 @@
  * VMA-specific functions.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
diff --git a/mm/vma.h b/mm/vma.h
index 58f48609ce22..adb7a0ba1192 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -2,7 +2,14 @@
 /*
  * vma.h
  *
- * Core VMA manipulation API implemented in vma.c.
+ * Core VMA manipulation API implemented in vma.c, vma_init.c and vma_exec.c.
+ *
+ * Note that, in order for VMA logic to be userland testable, this header
+ * intentionally includes no dependencies.
+ *
+ * This is specifically scoped to mm-only. Users of this functionality (other
+ * than the core VMA implementation itself) should not include this header
+ * directly, but rather include internal.h.
  */
 #ifndef __MM_VMA_H
 #define __MM_VMA_H
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 13a05e041195..ef1fa2b161f3 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -1,10 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 /*
- * Functions explicitly implemented for exec functionality which however are
- * explicitly VMA-only logic.
+ * Functions provided for exec functionality which however are
+ * specifically VMA-only logic.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
diff --git a/mm/vma_init.c b/mm/vma_init.c
index a459669a1654..715feee283f0 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -5,6 +5,10 @@
  * between CONFIG_MMU and non-CONFIG_MMU kernel configurations.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 2da6d224c1a8..4d300e7bbaf4 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -2,8 +2,8 @@
 /*
  * vma_internal.h
  *
- * Headers required by vma.c, which can be substituted accordingly when testing
- * VMA functionality.
+ * Headers required by vma.c, vma_init.c and vma_exec.c, which can be
+ * substituted accordingly when testing VMA functionality.
  */
 
 #ifndef __MM_VMA_INTERNAL_H

-- 
2.55.0


