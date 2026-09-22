Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8CBC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1376D6B009D; Tue, 22 Sep 2026 13:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8816B009E; Tue, 22 Sep 2026 13:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2566B009F; Tue, 22 Sep 2026 13:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C334F6B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:13:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C0E4A05A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:05 +0000 (UTC)
X-FDA: 85242043530.06.2C4FF83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3607CA000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HIIxexSc;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oUzDNkY/RkCUxjYpStrCAX46LJzS+IBv4LC7YvbXJ5M=;
	b=sCTJyGvF3yPlOimKuFR9Z1N8uFtIMlwka7Yfke4pn6bwvA36E/dPI+aU/z1FlkzC23ggSe
	mvnpXPP2W1QBpYsl+zWb6jivI3xF0GnUpSsgC/7trqqgC7whxoUB9I5H+JWeRFzfbEtO8H
	L8e0/qIlGxahj7JXhj5eWg/znrGvnpA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097183;
	b=dKIlmU3OwG2fq7Y006Z0r7Z6lmhXVAr7TjTnxpydZ5O3Q8m5aGSEadkttTfPcOFij+TfOX
	77+KNQUg3EbaTQBAVMmLliTBBKQjFACrOmiIV+YevOa9jVLIhc0ddEfnjBTdU/tl5g0Fbw
	JMW31oQm54dIK+bwRlqO7nEf9eapDKA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HIIxexSc;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A82B1576;
	Tue, 22 Sep 2026 10:12:58 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 153903F86C;
	Tue, 22 Sep 2026 10:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097182; bh=6fGlC+l7ZOTUAPb0qf6/jbMAeDqXx74X21kDAUYsIyk=;
	h=From:Subject:Date:To:Cc:From;
	b=HIIxexScPs77FEWrL1zKfh489AcYGH+eosy1rJu4q8Qx0Y5qygcZGRibDPK9zayy2
	 bMswKnuZyeg7Xdl5EiA/OMueeXhZkIg42q52ZYMsGuSW+3VibDu/Td+mjExBEv2p1H
	 6o6egoaJbq6J6Irg6+9TyJTuwzBdadX5XN/qqY9E=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v3 0/9] mm: distinguish HW PTE pointers from SW PTE value
 pointers
Date: Tue, 22 Sep 2026 18:12:28 +0100
Message-Id: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPy2smoC/y2NwQ6DIBAFf8XsuZgFqxVP/Y/GA8W1YoIaENPG+
 O8F2+Mk8+bt4MkZ8tBkOzjajDfzFKG4ZKAHNb2ImS4yCBQVSn5ly0rIKl3XfVlK0d0kRHVx1Jv
 3mXm0P/bhOZJe0zYZg/Hr7D7nzyaS909iwbFAFDmP+bqUjLPglVW5msZg78rZXM8W2uM4vgCpy
 qqtAAAA
X-Change-ID: 20260914-pte0-6c88f5592d79
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
X-Stat-Signature: rsg4s6tq95xfd3xrigxn9s3muu7s9gk8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3607CA000B
X-HE-Tag: 1790097183-673448
X-HE-Meta: U2FsdGVkX1/NSgLS+wF7VixTLppUv8LWgB5nOJxTrxDsODCFnRP5+fQcOrWouG4U8eRLIAoFyb29AuEgDobP9LjoXZNEaMUDEoRac7WOYKMBPxYQTQ829OZQgyvfk5px4dHLrzkRw5WRg0NfG7XjY+q1UbgD78xlcGgneryQJimFaEAUUys8ScV+05civWlfDWQRGjb7AH+H8ax7d/WwAc2jdB/cKaUwIUJvpxoVBKH+yCt5apSpjUy1W/rx1D7/gW5xK6whRuY1+Va7TDCsCSFJM8kqtt7YICEQQ0dDlAdR4rkx5mD11BSERJtZEyv1sGBLzQwTUXBlPSr42tQro2PNZTxVl89lehUZf/AzDJFNB+nThCaeScOFrSFCqOBklt2uyKSr5Dtg5n+rcacX4utBS/+OjgIGrI70uMqbCpThuZCp1I7vBqnm38pMYJvazMr+qBOxMXaJ4pI1TP7VCwePDN+3LphYPlJXtQQZtAG8HBWj6MhnLEJ4kG7p+ah6/uyQGeDgOZUuepeWgp0/4UsbVzt2B7ET3VleX1W+xrvERxfZlSlGSInmsjwb/z1b1Bt6WogD/k+OPHq/dhWOLrPEWb4VAS4prrh7ov86qNuHgYV0598f8wi7p+5k7Fmm5IF7VdAKAhdKMRDxUZRQKUuUn+6nZO8Bllt6pLbgL2YlbRpXo6Y57TDYun+5sU/rt3W8z72LuzsoK2i1fUaT9HDlZPQCFtQ/tOdqQNISnXck2enBiwIxj2Ndq3Pe7NwZEGjzpN3DSBKmroeaiPcx7PEAMXmHJbd3VMyiXHUiS3ENp6XUJ/NZKP8+Bv3CMhqxiGD75yAj+JWZbYQAPfrdcL+rr/u1nOPasPVN3+qakamoQUuDCH07ELBTOLU1btQnXAWJ6KBPti7P7aFLUS6GYLzRUH3IvDlYNKoCNSooTmU4nF6yHC7iKimB6U9pOIzWcoD3agMHDAMtXAN/+1I
 0tjZcQIB
 geVrJ6awS0HBINTFdFwDmu8w7KnDZ/y4Uf8jsa8jbhR05u5M/9oaELgt2Rwya0z7k0OnwBikk4A7EQYXIt6gb0oP9ORMVS+kWVALaMpPcsl0+ohZlF42OVOodda2ohmMm4AyslEGkJRs4X+F5+eN5BnbhTfa+BsT6UVvTgEYZWP34shdCwZnjRhIrICByRI6a/8VAydbPCnGMqcOCmZ9mlo83uIU1lLOaW/G8Yuxbr7D9VpxWoQUawYGWqwUKaH/4upnHsvNq7opr+PsgxeocHg3n1nJ0XZcWXh5ydssxRbb7xaX7PsaGT1lGKmuMhdOMNv8NwuC0oG1g758jwO/Du+faC+4bnB5WY4wjHhG0WB2CChZ84CKb9tLueqwNAfSi6CMo7aVIy0y+K7kIPH56836EvfUs+XuVWcKF8CUn1V8CHNyzVHWSSjRmlKLWJ165/mTzzeir9b+9L3AptKQqqwj32Z8eVl05FHuWP//nXig2JdLFoiwL4m7qQwl6Eo25oTqYv5cbJrM3o6TNGmWLY8sJUff55vBMraZ1In2ONW8z+B483X35PER1oY3L9P/+Pvb/WMwVPPH8oyBb2BIwHYvRODSKzWGONKFK3lmNSIGzHGaJ8NTG+revGk4vHzdvthqv8y9cTRhgv2L7Zpg3jDlm+W0RMaslVRYRX32skVgKKqgzFPc6CdI03Z4r5j+lrztankIEcDl7dcGNwhgITgjAYyWPZzUL/SmYyt2209nN6i6x5hXcXatg+Nf4PkmV2G3E00TFTgM+HLWJSoHCiul8cdYSLBWORTjN4vh8FMNGk1ndl8pIVmmSXSxNX/H4ygR6Ip+g3bNDG/cVDCyxXgmtpwBuj7qAhm+J0CQAUSFrwLXOmjXLvBTnmyPj//zmhBsdBGff+jJHyVtmYFpM9wZU+LJPrKfqNEd8HFhEPhpgahc1y4KFyUTfUXvblrTLVILpGGxFtVHd4aSAuoPgBftu9JI+
 5yQO7DHS
 GeM9bo6D/CzVObAMm3GQfx7+9BSEVX3ZfeDsKW3hO/h6Cyern/4QcQG9FacIKOnkTs1TnPk3R560W/mOPnWN5Zzc8gGb3prBrbi4ysdzrq7uvz0ITPJEsuAewLzkbYEkiJp5EFeWisn8cLreQsblWAHOcbTMApPzyDQyzkfaiDCABFTKTJ9H0CD9Pkl84Aebi4z0XIlWcUV8PAXeHreRd0J1yCwcL6utYOFMvoQfeNdpSPnPAeD1PNbvtf1q3nFMwFLEx6U6bZwBTgui0I5cmHjkKqoB8hrfgQLauSINrgF9YvCo3Q7AY+lLUbduGWMHrAZv1dvZMrS/wMXCPLF3L/D1zpRlXwA3mzScIJDHyDvLW8eYAMX5MDMbQGoAp2aAzQzKxvDDVZMBwRkZWzFmVSzMXRRRalK67y55CT0/Y2lQhCgIFHYGNXjBVOKWslP+5M0A+w/iaRv4xsErn+v2M4eobqJeZEyfXwlDzpnOOzHh8ASuZOF6umxplF27rLteflJ5ErDC5hk8bArGidbpGrxkItNypvNTXm9TUZKayOlqQDdN157K3NhesYfF9R/O9W16OsxU4XdNyk/MLfhSszdp6hCiHuSaZDwpZ5Mw9zQKsJ69OTg607rdL4nAoOACGjbopIBLvaIuUtBW3qwYqUsMHYsF2xkGHX8CB3HNPUZlU9zl1wc7UGYxhRVbwuhTM5FGkHHFLyxcdNsKHPLPEQ2Wg3MxGYGFKIQdvWIRUMMpe5JMknsmXAI6N2FbYa57KzsKWAhhAMZ/EV++R76oRvkMAt2KuOzjzoZScrB8d9dHNuazScb69YQlHHDo09jIMd3tCKPoEPJUdP2LD4m9UU6LAtVzIF3/BrH0JR5QcYM9wf6SMcLbTyk1XEm90tSwt8b8JZL10W4ErCztLNXNvy6w+g0Ehu592c6TpgEkRAohJLzerg51YCPvtmJl1CMXYwt0Wyrgx8qU4HSW5gI/fZKRBwB77
 5NRkv+uD
 eXwXwBSAKtHRJS8CA4Alni1YhNwP3lGXwgKlDez384jtiLo+YYcL3n9APwLdbWswQGSR39mRhbTswcseCsacYnVkFagVWBKVAEMnmZZ/YHspy9IcqjMRr+EnAB3iRzAY36j8SbGJXqPqjZULH8xOjg7X3BfOanlHdsDDtVrzgkrcnYuivJ/kH47VbdNTygep4aPs8eIQT/Rm8rOkunpRIgR1K8HNixNXwdQ277ubuKuiZldkBLc0bWef++670xhnFjfcQc4GIOmAsZrkznPpj+A8B4idKIhzPxG/WEQSH8bbbFZLoIt3HV7ZN2LTYlty+gsqgZ9Aa5RV7e82y8webc0Q0HVgKVfFgoM+AyuUyyuzi0BXVKjowbThJCUTxrWdYgynVHbED6Lm6nRAYmF/u9wbVixkMdX/Dih2ZKRx8pCxxopywAUgfC7B/JAnHrVqZVm0NpssGiQ2MfvLPqI/brgcs5+KPfnurpAKFleH38rO3PZpeNxuGWJyk5sRfTEWYH7URQdpUYsxyFgRrVEK0yDT3Z1nJaLEd1NOaQpjKWnzA0zAPqJfqCKBVDyX8tXs8xRkdjcFPg/FvaYFzFM8RIaavwLLVDEefYJUuMouiH+AHnaUpMAJIZcHBn3wT2cwINUDOUYOI52L41nrdST7BHfwPB1QobD+qGSvVz15SEIzDBB8kEB2Tt6oKYfjPtsy7BfqcK7vqKR4JD0VgZiQC4IH9sUxs6+pzRYMo+U5Od1NMXDs3Uo+rdTBaJ8+qQYOv4UGq+j0yjVx4SbtF/MdFH6m9wbYUTjOiaSW45NtB+3CynX6Xnz5+HNuJiVw24jg5r4Gc3W8JnuINB6Eekc0E2bhLe38YB3BydQfm9ychtWuTlWkvF1r6lcoY5OSU18NEAErkLP+gVbyU4beE5wMQvVIk8vzhjcRb5oOGvplHdZpCZmQ3QiR4Tik4O6g9XswsoxcqpoVzbEpPPd1PThEjSWPmwo1R
 qmstPL4t
 S9l14QXJ+nYMPZcl201Ow8ewBwylPBOZljeLgz0T3oWAdMhCxCRg4GtA97jvso+ZSsaQFJZyASEqCYA0+UkPcYQn6h0yzoIqoHzmcyVOV1jMxPD7E1PjrXAIkSTiNy8G5pu8T4Q3peA8l2oADH5sb1rL6U1oTzcAeETkTKJ0kReX/6JgoFbzcgfFadiBncBM4bnq792gNmRcTqTxsoC7ngVMZuyX1+K8O2W24c09kMpVDhnAkdbNqH+lUCWywM6cbzjL145MSc7aG+NWCg5bPmlVTAB0ds+c0UuaLbAOzaikjRA4p+HAhshUQfvrDB9b+MAnj00FaDu8mbUhq4Tu46YiDkSQLfRe8F0dXrpIvWSWP3mBSlzxKdWkCVROqbBBS9XD+xF1dYBb3s7ynwHNkBCKqWgB/MnrTv9oCZ0s5zBYFnXE7vaxiFbrluPlL57JBkjIVWjvi931UY0J/UI3EATpT7XtFa0zrpwdlEq2jhm3cgCmAAHEUY+Nc5qGYiIylOIAkdT6RwPExRIyZSGlhxo+JDXGyiC1CEqypmxQgGZ+dleVW2YmmOf4Zxo8mSioKOd8O8kHid/83l0oGd10jc3CuXCQeXiBjj1ns5Qt//HPY+G8wk+ExWjAFCGeOwFrA06ETNlUgvCBPu0OoS4+QYXC/DK2+ACQbS22j1Xs4IudRzYQwGFzUqwVnUxPNGbeB+dqF7/hEzelWzotFRRzVNnplg5GO33NfuJsA7lutb0+yH10c4YAYMb71JCcGO3L389/YsEuNZLrhh7lOvQXVp2xhzJf43a4AoCT9myw36T8zn28beh3TAJ8stp24ywG4wXJU1FqHtIyiIp4raQuZkzcQfxkobzvwWLkSjnGnK4Ea46KHvBmqiLfvoL7YlxC+tKl+dQQfgQo+tHy+apMdUGa11VY/50+qkiB8roISMr1gkwOgn5nEDxmgWA6h2HqMcRw91L88s/ILzQYHyJl4XBW3SSvJ
 htrfSJZA
 o5hECRB8KNAj4vzxju53zAl69C6Zmn+LcifC/2OFy2YU+Fi7TmVyKj82tTF6odQQ4nXAj3a4INW63U98FeciS3a9l4WOZax37Jvn4hOGLxmXCoC/4rm3zEZfc/2GlIwM+kshq/NsZ4Qv2Ys/JAh6twcQAhV793SJTBiIrAwIZmACtVcSi6FYWEU2bzcUFEJMtNvPpA/DB68xbhRQzZUvLRpMjwpWJwW//KBMUTJPQkv6qwl0FuuJ2573y1JIiJjA2lKZ+3vKDfkX4ohe9Th7vWWbgTuPbHtY+IYAx5UhV37Mx+TJGuB/4gOzSwipqEgjFMOtNPkx1KlLk4dCY4gp1I3YK40AT/V7T/bUWUC/HszAaLYgIzwe29Ri7fcFYE+OLss+7PmvGJ2ukSl6JbSvTLxH9ZepFEKi4I6aON9ovLXpM22bKcFVK5DQdCT1q3r9fm9ofX+Og2vG5phhRhSmpoOCftk2yMOHH2Z9l+YxvH5MU/BlxHaWlMwEj7dDvtOUx5n2SgzGMrY0CJWlkgcUSXPqzws1awkRx6XtjMtwLcePm7LUAUocH4/UM2S4cx5xjqBi9hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

pte_t currently describes both a software PTE value and an element stored
in a PTE table. Consequently, pte_t * can point either to a software PTE
value, often a stack copy, or to a PTE-table slot. The compiler cannot
distinguish these cases. A value pointer can therefore be passed to an
interface that expects table storage, while table storage can be read by
direct dereference instead of the architecture accessor.

This series begins a staged conversion at the PTE level. It introduces
hw_pte_t as the element type for PTE-table storage and converts generic
MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
intentionally return a value through pte_t *, such as install_pte,
remain value interfaces; the relevant parameters are named ptentp to
make that distinction explicit.

The generic definition aliases hw_pte_t to pte_t unless an architecture
selects ARCH_HAS_HW_PTE_T, which enables a distinct generic wrapper named
__hw_pte_t. Some architectures define pgtable_t in headers parsed before
the generic hw_pte_t typedef is visible. The structure tag allows those
headers to define pgtable_t as struct __hw_pte_t * without creating an
include-order dependency. This is required when converting s390, m68k,
powerpc and sparc.

No architecture selects ARCH_HAS_HW_PTE_T in this series, so the
representation and behavior of every architecture are preserved. ptep_get()
keeps its existing READ_ONCE() semantics and converts the stored element
through __pte_from_hw(). An architecture can later select the option and
convert its PTE interfaces to make the distinction compiler-enforced.
Architecture PTE implementations and most architecture code are
deliberately left for those later opt-in conversions.

Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
complete PTE tables use hw_pte_t whether or not they are currently
linked into a page-table hierarchy, while software PTE values use
pte_t. The distinction between complete but unlinked tables and
hardware-reachable tables was raised during discussion and remains an
important point for review.

PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
converted in later series after the PTE boundary is agreed, avoiding the
PMD-specific cases that made an all-level conversion difficult to
review.

Most mechanical pointer conversions were generated with the Coccinelle
script included below, then audited and fixed by hand.

This series does not add a second ptep_get_once() accessor and does not
remove or replace STRICT_MM_TYPECHECKS.

The design discussion is available at [1]; while the original idea came
from [2].

I've the patches here [3] for arm64 conversion which I used to find
usages in generic code which I missed during development.

[1] https://lore.kernel.org/all/6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com/
[2] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com
[3] https://lore.kernel.org/all/20260914-pte0_arm-v1-0-bb53b663e396@arm.com 

Testing:
Testing was performed with and without the series on both x86_64 and
arm64. KUnit and the MM kselftests produced matching before-and-after
results problems or regressions. Fastpath performance testing was also
completed on arm64. No regression was found.

Thanks,
Usama

---
Changes in v3:
- Retitle the series
- Moved hw_pte_val() adding helper to generic series
- Link to v2: https://patch.msgid.link/20260903103002.1091859-1-usama.anjum@arm.com

Changes in v2:
- Name the generic wrapper structure __hw_pte_t so architectures can
  forward-declare it before the generic typedef is visible.
- Use software PTE value terminology consistently
- Fold the prerequisite header includes into the generic storage
  conversion
- Explain why the NOMMU stub converts the stored entry without
  ptep_get().
- Rebase onto mm-new and rerun the Coccinelle conversion.
- Link to v1: https://lore.kernel.org/all/20260806083926.1807279-1-usama.anjum@arm.com 

Changes in v1:
- Add ARCH_HAS_HW_PTE_T so architectures can opt in to a distinct
  PTE-table storage type.
- Define the distinct hw_pte_t wrapper and its conversion helpers in
  generic code instead of requiring each architecture to define them.
- Read hw_pte_t through READ_ONCE() before converting it to pte_t.
- Drop the previous mremap patch in favour of [a]. Apply [a] first if
  it is not already present.
- Drop the previous two dead-code conversion patches; the affected
  code was cleaned up separately in [b] and [c].
- Link to RFC: https://lore.kernel.org/all/20260727164715.2866609-1-usama.anjum@arm.com 

[a] https://lore.kernel.org/linux-mm/20260720141633.501799-1-agordeev@linux.ibm.com/
[b] https://lore.kernel.org/all/20260730111316.3672672-1-usama.anjum@arm.com
[c] https://lore.kernel.org/all/20260730094501.3002718-1-usama.anjum@arm.com

---
// SPDX-License-Identifier: GPL-2.0-only
///
/// Rename raw PTE pointer types to hardware PTE pointer types.
///
/// This is a mechanical type rename. It converts common declarations,
/// function parameters, prototypes, return types and casts from "pte_t *"
/// to "hw_pte_t *". Plain "pte_t" objects are intentionally left unchanged.
/// Pointers named "ptentp" refer to temporary software PTE values and are
/// intentionally ignored in all modes.
/// Re-run in context mode afterwards to audit remaining raw pte_t pointers
/// and cases that need hand conversion, such as trace macros and mixed
/// declarations.
///
/// Confidence: Moderate
// Options: --no-includes --include-headers

virtual patch
virtual report
virtual context

@local_decl depends on patch@
identifier x != ptentp;
@@
- pte_t *x;
+ hw_pte_t *x;

@local_decl_init depends on patch@
identifier x != ptentp;
expression e;
@@
- pte_t *x = e;
+ hw_pte_t *x = e;

@param_proto depends on patch@
identifier f;
identifier x != ptentp;
type R;
@@
R f(...,
- pte_t *x
+ hw_pte_t *x
,...);

@param_proto_unnamed depends on patch@
identifier f;
type R;
@@
R f(...,
- pte_t *
+ hw_pte_t *
,...);

@param_def depends on patch@
identifier f;
identifier x != ptentp;
type R;
@@
R f(...,
- pte_t *x
+ hw_pte_t *x
,...)
{ ... }

@ret_proto depends on patch@
identifier f;
parameter list ps;
@@
- pte_t *
+ hw_pte_t *
  f(ps);

@ret_def depends on patch@
identifier f;
parameter list ps;
@@
- pte_t *
+ hw_pte_t *
  f(ps)
{ ... }

@struct_member depends on patch@
identifier S;
identifier x != ptentp;
@@
struct S {
...
- pte_t *x;
+ hw_pte_t *x;
...
};

@union_member depends on patch@
identifier x != ptentp;
@@
union {
...
- pte_t *x;
+ hw_pte_t *x;
...
};

@union_member_in_struct depends on patch@
identifier S;
identifier x != ptentp;
@@
struct S {
...
union {
...
- pte_t *x;
+ hw_pte_t *x;
...
};
...
};

@fnptr_struct_member depends on patch@
identifier S,f;
identifier x != ptentp;
type R;
@@
struct S {
...
R (*f)(...,
- pte_t *x
+ hw_pte_t *x
,...);
...
};

@fnptr_typedef_pte_fn_t depends on patch@
identifier x != ptentp;
@@
typedef int (*pte_fn_t)(...,
- pte_t *x
+ hw_pte_t *x
,...);

@cast depends on patch@
expression e;
@@
- (pte_t *)e
+ (hw_pte_t *)e

@remaining_decl depends on context || report@
identifier x != ptentp;
position p;
@@
* pte_t *x@p;

@remaining_decl_init depends on context || report@
identifier x != ptentp;
expression e;
position p;
@@
* pte_t *x@p = e;

@remaining_param_proto depends on context || report@
identifier f;
identifier x != ptentp;
type R;
position p;
@@
R f(...,
* pte_t *x@p
,...);

@remaining_param_proto_unnamed depends on context || report@
identifier f;
type R;
position p;
@@
R f(...,
* pte_t *@p
,...);

@remaining_param_def depends on context || report@
identifier f;
identifier x != ptentp;
type R;
position p;
@@
R f(...,
* pte_t *x@p
,...)
{ ... }

@remaining_ret_proto depends on context || report@
identifier f;
parameter list ps;
position p;
@@
* pte_t *f@p(ps);

@remaining_ret_def depends on context || report@
identifier f;
parameter list ps;
position p;
@@
* pte_t *f@p(ps)
{ ... }

@remaining_struct_member depends on context || report@
identifier S;
identifier x != ptentp;
position p;
@@
struct S {
...
* pte_t *x@p;
...
};

@remaining_union_member depends on context || report@
identifier x != ptentp;
position p;
@@
union {
...
* pte_t *x@p;
...
};

@remaining_union_member_in_struct depends on context || report@
identifier S;
identifier x != ptentp;
position p;
@@
struct S {
...
union {
...
* pte_t *x@p;
...
};
...
};

@remaining_fnptr_struct_member depends on context || report@
identifier S,f;
identifier x != ptentp;
type R;
position p;
@@
struct S {
...
R (*f)(...,
* pte_t *x@p
,...);
...
};

@remaining_fnptr_typedef_pte_fn_t depends on context || report@
identifier x != ptentp;
position p;
@@
typedef int (*pte_fn_t)(...,
* pte_t *x@p
,...);

---

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Xu Xin <xu.xin16@zte.com.cn>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: Jann Horn <jannh@google.com>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: Pedro Falcato <pfalcato@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
To: Nick Piggin <npiggin@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Rik van Riel <riel@surriel.com>
To: Harry Yoo <harry@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: Uladzislau Rezki <urezki@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: Andrii Nakryiko <andrii@kernel.org>
To: Eduard Zingerman <eddyz87@gmail.com>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
To: Martin KaFai Lau <martin.lau@linux.dev>
To: Song Liu <song@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
To: Jiri Olsa <jolsa@kernel.org>
To: Emil Tsalapatis <emil@etsalapatis.com>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Ian Rogers <irogers@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
To: James Clark <james.clark@linaro.org>
To: SJ Park <sj@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Jason Gunthorpe <jgg@ziepe.ca>
To: John Hubbard <jhubbard@nvidia.com>
To: Peter Xu <peterx@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Nico Pache <nico.pache@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kas@kernel.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Alexander Potapenko <glider@google.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Matthew Brost <matthew.brost@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
To: Byungchul Park <byungchul@sk.com>
To: Gregory Price <gourry@gourry.net>
To: Ying Huang <ying.huang@linux.alibaba.com>
To: Alistair Popple <apopple@nvidia.com>
To: Dennis Zhou <dennis@kernel.org>
To: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Tvrtko Ursulin <tursulin@ursulin.net>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
To: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Cc: damon@lists.linux.dev
Cc: kasan-dev@googlegroups.com
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: xen-devel@lists.xenproject.org
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

---
Muhammad Usama Anjum (9):
      mm: introduce hw_pte_t for PTE table storage
      mm: rename pointers to software PTE values as ptentp
      mm: use hw_pte_t for generic PTE table storage
      mm: convert PTE table entries in ptep_get()
      mm: convert PTE table entry to pte
      mm: add hw_pte_val for HW PTE storage
      mm/kasan: use hw_pte_t for the early shadow PTE table
      drm/i915: use hw_pte_t for PTE range callbacks
      xen: use hw_pte_t for PTE range callbacks

 MAINTAINERS                                        |  1 +
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  4 +--
 drivers/gpu/drm/i915/i915_mm.c                     |  4 +--
 drivers/xen/gntdev.c                               |  2 +-
 drivers/xen/privcmd.c                              |  2 +-
 drivers/xen/xenbus/xenbus_client.c                 |  2 +-
 drivers/xen/xlate_mmu.c                            |  4 +--
 fs/hugetlbfs/inode.c                               |  3 +-
 fs/proc/task_mmu.c                                 | 33 ++++++++++----------
 include/asm-generic/hugetlb.h                      | 15 ++++-----
 include/asm-generic/pgalloc.h                      |  6 ++--
 include/asm-generic/tlb.h                          |  5 +--
 include/linux/hugetlb.h                            | 53 +++++++++++++++++--------------
 include/linux/kasan.h                              |  2 +-
 include/linux/mm.h                                 | 26 ++++++++--------
 include/linux/page_table_check.h                   | 10 ++++--
 include/linux/pagewalk.h                           | 10 +++---
 include/linux/pgtable.h                            | 81 +++++++++++++++++++++++++-----------------------
 include/linux/pgtable_types.h                      | 23 ++++++++++++++
 include/linux/rmap.h                               |  2 +-
 include/linux/swapops.h                            |  6 ++--
 include/linux/vmalloc.h                            |  4 +--
 include/trace/events/xen.h                         | 10 +++---
 kernel/bpf/arena.c                                 |  9 +++---
 kernel/events/core.c                               |  3 +-
 mm/Kconfig                                         |  3 ++
 mm/damon/ops-common.c                              |  2 +-
 mm/damon/ops-common.h                              |  2 +-
 mm/damon/vaddr.c                                   | 20 ++++++------
 mm/debug_vm_pgtable.c                              |  2 +-
 mm/filemap.c                                       |  4 +--
 mm/gup.c                                           |  9 +++---
 mm/highmem.c                                       | 15 ++++-----
 mm/hmm.c                                           |  6 ++--
 mm/huge_memory.c                                   |  4 +--
 mm/hugetlb.c                                       | 60 ++++++++++++++++++-----------------
 mm/hugetlb_vmemmap.c                               | 13 ++++----
 mm/internal.h                                      | 16 +++++-----
 mm/kasan/init.c                                    | 14 ++++-----
 mm/kasan/shadow.c                                  |  6 ++--
 mm/khugepaged.c                                    | 50 ++++++++++++++++++------------
 mm/ksm.c                                           | 11 ++++---
 mm/madvise.c                                       | 18 ++++++-----
 mm/mapping_dirty_helpers.c                         |  4 +--
 mm/memory-failure.c                                |  6 ++--
 mm/memory.c                                        | 78 +++++++++++++++++++++++-----------------------
 mm/mempolicy.c                                     |  4 +--
 mm/migrate.c                                       |  4 +--
 mm/migrate_device.c                                |  4 +--
 mm/mincore.c                                       |  4 +--
 mm/mlock.c                                         |  4 +--
 mm/mprotect.c                                      | 19 ++++++------
 mm/mremap.c                                        |  4 +--
 mm/page_table_check.c                              |  4 +--
 mm/pagewalk.c                                      |  9 +++---
 mm/percpu.c                                        |  2 +-
 mm/pgtable-generic.c                               | 20 ++++++------
 mm/ptdump.c                                        |  4 +--
 mm/rmap.c                                          |  6 ++--
 mm/sparse-vmemmap.c                                | 22 ++++++-------
 mm/swap_state.c                                    |  3 +-
 mm/swapfile.c                                      |  5 +--
 mm/userfaultfd.c                                   | 32 ++++++++++---------
 mm/util.c                                          |  2 +-
 mm/vmalloc.c                                       | 11 ++++---
 mm/vmscan.c                                        |  6 ++--
 66 files changed, 457 insertions(+), 375 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260914-pte0-6c88f5592d79

Best regards,
--  
Usama


