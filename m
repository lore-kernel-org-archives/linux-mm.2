Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000D0C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF436B00B4; Wed, 15 Jul 2026 10:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FDC6B00B5; Wed, 15 Jul 2026 10:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37DD6B00B7; Wed, 15 Jul 2026 10:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90EBD6B00B4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:54:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27DBC401D9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:54:24 +0000 (UTC)
X-FDA: 84991306848.21.06313A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B23DA0009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:54:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aoq0Mas4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784127262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OB/1yoUb/yshfvo5DGxrFMwSBU/fSVGv+sn/IUJmK4=;
	b=f34Qen7u+oRvahZrxeiUdF0kvaloDK0qKMmOMq97o0QbF78HySS5ax6+J5bKc3tp8Khsv+
	Ue8x+5TCEhqsQy2tMbw/3HxuKylhQQ+DP1sHx6mu+9rJehONOSscWI3Qt7fl/5msuc0FTM
	4gw5i450yNnEJ+nv3CLIrGXb6Lo0Y0I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aoq0Mas4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784127262;
	b=k8S+RtY4WOhPNzhjQg1U0q6JJbOILmsd5FzqboBDPMRvM1cwznFEluEWCCRBZ3lf/UtgRu
	q8PWjTmnaoL2633Uqc+yaZzE7DsxXvZ27RhzOG6DQMBrkxbwYLXpSZXjPPAN860/rQe3k8
	4lVb5pK+rTygsE/r8DBCOD5m1ClxZI4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9431E6136E;
	Wed, 15 Jul 2026 14:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC92F1F000E9;
	Wed, 15 Jul 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127261;
	bh=/OB/1yoUb/yshfvo5DGxrFMwSBU/fSVGv+sn/IUJmK4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Aoq0Mas4msa+C0vU61Lw93LC+D9qX3vgvHr2tfhvIyH8kjExPwNqepzNwJ10uvio8
	 daLUV6JzNrdmXK1c2z3C2mkPoeQwtgHPDMoborLbq43909STfZwNoXcBGDlKCWbPAv
	 lqqUyV5jUpvPfPDhGXWHsK56IWXxhactLULK6YLE8eVEtCN8NYsv9JVyQ9UITFuQiO
	 XkKYVWHi+BMtChwXOTFsUV9blydWksfgPF0FO7H1SjBJZUp+fQvbqFJx4meLR+x3n/
	 +dVkkZ85QU65d/BIsvSB1iyhkFUeN1/GR2/b9PIrjbwzdceAyLaqy1rWWz9i1PNkXX
	 ENe6M+nOnapKg==
Message-ID: <31887d81-659f-4eec-b423-005364263a58@kernel.org>
Date: Wed, 15 Jul 2026 16:53:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/33] mm/vma: minor cleanup of expand_[upwards,
 downwards]()
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
 <20260710-b4-pre-scalable-cow-v2-16-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-16-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6B23DA0009
X-Stat-Signature: w5j4cntgkuwc8ecyk8crui8aafgt8y3e
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784127262-556245
X-HE-Meta: U2FsdGVkX1+J5ubgLHMr3PzAt5uNGomssHEHnpZb7h4JZ8UAnYU1Z6bwUuw/7ZFqewmNSot6AjTaAP7IzU3GHJIiUI1QrjMJKD0EiuGDziNIRl7thXPVgxAZ+quADdR39srnqS1TWfam9ZyQHBG0PjEh8X3AefaUNVwC5nNDfB+gJoA9QHCiTPwkluIKVxHfVNAXE7XdCfVk2csV/MIxaHmkyBR1aHkThmKWUwMPML3bENbVt59fzBIf+Fq7d5dmy4BCFJ2nkmUrM8NffCXS6wDINeNNFNeouWt6kWkkMX813bfrzI+0/i2kcVk5zw5DdrY2fKd71ta7TZAH/yotSttZDpHFPseY91e2/1E4IRUZ2VkqQjLGJ6Dh0kTLoRC2wv8vOcCgegScrivs03YFtigYf937IcFLnyPeMRv1wTrhWSAIcFjS+Wsz7lN7AS1wNRkJg4NQeB+ej/WefIUp8h17UIUTgRUl2jUYGfJxK6lYYNOv6rj3XoWP4E0QnfMl9+Fso8WcK6yfb1fzB4dOhbHgLeOm7AEmq7fVjSCokhJvjp9iHkjNeNXdf54GWYW2W6Ia0K1IKtjFqxoEqTg/3M4iLqTxMXVgQs4ejfEIWxqFAHE88TBrIo3zhFAYdLYkSx+RgO8kNu4xwQQKQn4+GydjtFPU+Ddk4PWaP639+eR6LCbfTLPjdH79eku3ClkbYv7C8WTKQihLX0MrUAJJIbCfSXsnKuuRI+YrypjwnBL3ia00CqRob6jNchfqCodjew5Lg02eoThtWuPje8zzt0DNo0n+XP6+5ilGezwB1WqtgE/YnBJJBc/4ffggt0fXZHb6eBCOzG+i3TRIJKC/gEL/mhCbPYWmBlX45aHTxxuCSxe+a+sEslR3WijbeRpQsjt4fPTSdd7xKW2sjWKaMcJXPuA0I9F0cZhb+jovFXLk8K60f3U4fRLOR4cIlDGzBQx8NlykyYDU40G0c9P
 Vzpi5yAp
 3RRVeawN9jUfvvxQBFQLIcgj4V9gFb1tv2mTiZnEqAJZ9esZoJZw0retpzBSxn4E7r95/R6AlimdBFeiZTNLlM2itF6GY72x4Iz/sFk+RhxOrINNUnqZov8WYoiN/2PasSl+SFajnDXCJpFhqt/qcQy363jVKfkL/7/Kpxm+EL/d1U9tpDHJStH251VMmYOkJFcTW+xUpOPEkSA5HdDl64DUhgZ4HDbGFIDZsSfo/jC2RtLcn7j2e4r42qYzAtcNJvn5Op27NAJs8tpNK8J1BcPUTvsxTmVDUQPZoP/LkhawYvbHmgR2XNYZEh2UodLbjC5WXogQYYcG8R3pZFzcU0bWZg12Mvy9VgSeq27JqJwHKD4EIRMeZZ5yRObsXtHh0LOSTc4GbYGdqLCR+gX9YJaNXGIsq0Ui5NOCEJY8g+Zxm6KPbFqL/Zu5v9od+bWEaj0yjzmBvWJY4EXNRM7Y1fSHleqoxD+yavgzibE/LCxi953vj2mWlQabrjEyAlIK8BEdIQxhntYLiJeTvZcpcIiWoVorkTuMjeGKupcS0du06TDgXNxJiozGhZNwYGXFnAzm+kxqlanDeU6eYjAkyS7DIFrJbvdHARy2Et8TIC2GiLSjTDl2agrSy4QnMU8VmTzzYsagu8dSiBlmEv/sleHui4Cf49j+i0/t6sBd6TNnWggFdm5V4sNF/s/UmCxfhdtPCYONk3O6C2+NesayP0s/OYLhCfm0j8S3uViMp7uvoeJuH+wi9WJRjJWLiHz54tpuai/qtrSzjl03iUOUal2Uog/5r4QJH5p1cmP2jZKtqTw55bCsvl/6LpqYT3FsNG6K1crxuK1cPWTUQ7WdWb8Ig7GDplKGcBzh2bJPYZKEhTxAE50ctHJkdOnXxtcEdCt8++GnP3t8f9R1GoQ3fgYphnVjRI0zBblRB4LYsPJx95BuJm5b9wU0y3+4gyloPLNYE93DCNHkn5XqsJEMoUoSLqKmd
 Q/xDe2JY
 mf7xiEkY04ZueIllEi4nPfwohLJ2wH+BD06yUBHVOTehLU4amR5jqMGwQqOhcH3MGZslE2XrzkKMhf04PzdhIEHSTVhn3Pdm5woQB7OUbZ2yaTjIHRSJ/DqWt5XvHyXvhkKVuokLHtLZ7gitVGmPv1Z+jTCbxk0TcksDTz9ZPV4OAtvMPG14sTZ8O0tn/EmjFxTSgT1uobsXz1bLdD6rWFSjZpkvkR++up1b7QhUSBCiwjYN6945JF9fLUKzueRzySxWf5elzExcTYiUJ2kd6q/bfpzemsIxa0Rwl1Fi46PA8NGtPWl66d2/Dr1AM1Prch0/C4UWjy+4Fl59X01GOMIV36IT3EPAYGDvmteTWpvUSV3aST/uJQW/91WDHYHR+DMFhbS1G5zMhHx/idZtlT/Lg6G+DP5HHCkqMw1cnTxfna0pZmYiXr240HUWwtBKj0b2TI0WNRbbWnTeWjISLR6vgu3w599z61/F1463zTFABmoe5v2ZIt+zKMy4s41VXveVnyBHksQrpFiuHJtKSJrX/QbL9Y7YahrTaumrEVV+Kw6ryMGrLQ/WjXpH7bYEE7TTB9xTdZhhkw7Wf/vmQFzIT0asFQ7tLx696rev57Z2QGbuy1+GGN+G8bNyz88gzzG1+YWz6g+7K0RKfsCKUDbUvGdVQlhhPD2vZcALB1iuCHcZWxtnNtjF0N7oz7REOIFjz926dbMZdmud09vDh55TYDAMsmQPSJvgQu2jE4MfQlYaww0myxTgaOxvx8tWdhBoollOipu3wMywfkg2RYul9PTNiv9lkKLw6kDo0Xbwe1jt6wGqzROk8L310ZijrSgFR6xaQH88DfUfHQ5pjCtVvbOXIABVnjJG1ltNLp7uhGgAKcDlfqyjIns8MRhdfSUOpfW38Zum3CB9cNHp60QOT5faSrld4NGbXxr5Yi/clCoLBaQ4QbqxRLl7EEWOuYTq/4+L7N9bPpnjvRj2YSrqvTwK8
 Cetjaehz
 zDHda3q8U3jMkEbN0TO4GiBGMBxonH5XfcjSvhW1mO9jm1LXgE/zeAcvhkJ9p+Yty1CO+kESzdNp4lpQ48sRiAEz9+j4ijMfmquLjzqTmoc768a+kBxeeweLplBwySJtfMq/5CiOHY4598WbRRrtaoRMkspc7/WjsojHa8OCJc/unq/AaEC7jUFqEeVDp6ermyt6UtDnVFpIlAkpfMGqKgl6DNLGBjxhvU0K9TafMDvOEgzn/XxBXWuyiVMg6CVPJLoN95atinicnlp5oTZIIwsNWgtI89DTs9jqUMqdbdwrJUy/92LmwekkeDSJ7X51jqcI98D7MSztQlguQjm6J02BNvrDbgj18d6lpEWQOIyz3lY5JyAp3BTLHnXFDgMWt84ivTSu9PAVdBzhRYklvWtarFajV58mZPs0oiMFuNbtvSlhT1+TcWEKL64179jrQDWH9b3gLoInuqb+UuQmCGvXtduWUThCjlKzbV73RC6hGk5TZxSlbsrVJyx7gIj9xb8iqoN+cF90Whnqi6n8oXs/VkvbFdW43FTySzc49ubJ/oK/6wXXQrG6ahWs2xKtIebQKeEW248y0zpUY4+7yGSYnjMaUezYgXleZdgbqJh7Lhhs9sX8B6oGuOp3FQdzQDAGimwnb3a4fR8X2Hm+jG0COJ1WpriRyz8u34UrfcdOfrHPWsXG9mbT+ypsAdYeBsajm4nEoRMcxhzG+EsTWWaBKKHpAZKZHaLH/NjXiOPh2tAMJ0TwN2aK4QVvQE+oEH/zVGixf/dkBG7NDLIM63B8JeIRMsIRLJBEi7+e0kzXH8/JO83cUE6onWYYVRXhivD1PdkqlGaKN9eGENh6qxTRXW/C/CHEsodcxqttY3BHVP7R2FicEW9V4QkHGLMZl3ovbw2ua2AboGZ+UqC2uB3zlCGYHkYTmkOUKnKYIh5uc1jC9pdbTGX7zEVa31TIAsiNWtypE6VTGXMggdaN94U34alGe
 ksfBF4FH
 YRwUsm2vJxXFQkoRivjEYvOYGpXbBKO0g8HMVWUBSWiyLQsv3qdf3R3e1YxcK673lmgMd6iUDpViQ6uKWGuLbEqoq8BSqzwRzkIMbdfJ87rlWmb8zNm0ayFTGrS1qECbi6xNx6sP7cDw1eWk9eZuVObOSxPcZ6f/yPB3AG9j384EwrzO7IAAgi3zXRRjNCzlALFPsUXjG4uQapH+TGPXsFdAybBq/9N5KF2lqYhPtU5/+mm67zUQlu/mwU3FxtQg/su8zbjZJDLai2vJkHqc0iqreU0fI27gl9/Lquismuqk8H0/Mn9iJ4aegh2NlhXwl8i4A6CMBw2vJwlxwoO49aAsyhrCF+eZVJVGpAZAzz7Lo11Kk/AJ+RzTIShUNTHG9O9890Fm3ovOricXZtcr/Znu73Al6r7E5ZadY7ZRIfIGJutznu4YNIGjXAlSMcyI+gWslEqxQtVi6DBVOS2waEt2MrNsHKh0J+ZOvALZCIQ6v186aqHHywi51RWK385B5WIH/EX1pKbRlbnvGfFMiAFC6dnKbhcbmWCLO7i27OkImrCEPyjGj/ROW3z6Y6GXdC4U+GlrlMtMaq7utlu34e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> Adjust the stack expansion functions expand_upwards() and
> expand_downwards() such that they are expressed in terms of named constant
> values, and make use of vma_start_pgoff().
> 
> This clearly documents that we are referencing the page offset of the start
> of the VMA.
> 
> Additionally this cleans up the overflow check in expand_upwards().
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vma.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 7265a054cfa3..5d5e60ea8a25 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -3216,13 +3216,12 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  
>  	/* Somebody else might have raced and expanded it already */
>  	if (address > vma->vm_end) {
> -		unsigned long size, grow;
> -
> -		size = address - vma->vm_start;
> -		grow = (address - vma->vm_end) >> PAGE_SHIFT;
> +		const unsigned long size = address - vma->vm_start;
> +		const unsigned long grow = (address - vma->vm_end) >> PAGE_SHIFT;
> +		const pgoff_t pgoff = vma_start_pgoff(vma);
>  
>  		error = -ENOMEM;
> -		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
> +		if (pgoff + (size >> PAGE_SHIFT) >= pgoff) {
>  			error = acct_stack_growth(vma, size, grow);
>  			if (!error) {
>  				if (vma_test(vma, VMA_LOCKED_BIT))
> @@ -3295,13 +3294,11 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>  
>  	/* Somebody else might have raced and expanded it already */
>  	if (address < vma->vm_start) {
> -		unsigned long size, grow;
> -
> -		size = vma->vm_end - address;
> -		grow = (vma->vm_start - address) >> PAGE_SHIFT;
> +		const unsigned long size = vma->vm_end - address;
> +		const unsigned long grow = (vma->vm_start - address) >> PAGE_SHIFT;
>  
>  		error = -ENOMEM;
> -		if (grow <= vma->vm_pgoff) {
> +		if (grow <= vma_start_pgoff(vma)) {
>  			error = acct_stack_growth(vma, size, grow);
>  			if (!error) {
>  				if (vma_test(vma, VMA_LOCKED_BIT))
> 


