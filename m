Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5A260A380A
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSuQm1gi
Received: by kanga.kvack.org (Postfix)
	id 0D30F6B00EF; Sun,  1 Nov 2026 17:15:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB636B05B1; Sun,  1 Nov 2026 17:15:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03906B05B2; Sun,  1 Nov 2026 17:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD3FA6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:15:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 377901209B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:15:56 +0000 (UTC)
X-FDA: 85387958712.05.F8D26B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C167C0005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:15:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSuQm1gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTHI4iJKGW8nTdZJYWi2ZEsJRVp05NwkVgRYnkQTnQI=;
	b=E3xJs8KOiTYXwkDsKh981bgMQFCOwninw8Lt6L9LJEoT4SufIn7SEHzuWj6GRaJlq8sSqK
	9t0t77bI++eXZOunauaYzRnzoT5HmVf1L0gXphHiVjhy/U3bju20G+kO3KxYjHo2BlLv36
	y1Z5mAmVjD15LxEZ2BaXt2uxCOctMIE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSuQm1gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571354;
	b=P7KuCOxJyHDSJI1mLUkGEo/2VLuBY0OdHdLGefkrKXFLQvUlz5VSvBXKsHiEjfmUOdRh6v
	4BVbwGgQBkRvK0DQdhok+rUQWtrXn4pdCEUrCqoNvQPTHg2KMtkpf1Iz9D2xdkvJ+hfmIl
	kCkrnGDWiIqF8ZWtOTsoVCBXXF8H21U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5095E44009;
	Sun,  1 Nov 2026 22:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155181F00A1F;
	Sun,  1 Nov 2026 22:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571353;
	bh=FTHI4iJKGW8nTdZJYWi2ZEsJRVp05NwkVgRYnkQTnQI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kSuQm1gig26F3a5hbFrlCEgTV6KZdAUm8pVgji64pGU9IHFtmj1+0lqa6FjFwtpwY
	 RQDDMAWpx0nuTd442k2/dkXZmO3ak6/b0bODbLMMOiXHR7sqan7+OYTSomVvsVhatc
	 5sO4YlxH84ZbDrCWiv6NIlf3enn6ckTlaSH0A2hbLwanZ7TAw2vRzqI9LjdgxD9mYw
	 rVyzHjy74WbfzuCKilIc61p8YM/etpQQgk31aiPP5AoELP2cxYQDze2rDXYJz/8udp
	 9mbnMTtDK0Vamho7QvOMgWKAobDTF7XMy60kwODafcPU8OakiOi1fCrlQV4kt03Hd9
	 bPj8B6YTEsy3w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 032DA38003B8;
	Sun,  1 Nov 2026 22:15:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 00/39] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357135155.2624073.13862678489444424470.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:15:51 +0000
References: 
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: 
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
To: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 david@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, gregkh@linuxfoundation.org,
 dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org,
 paul@paul-moore.com, stephen.smalley.work@gmail.com, perex@perex.cz,
 tiwai@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, dgilbert@interlog.com,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org, simona@ffwll.ch,
 deller@gmx.de, sre@kernel.org, jhubbard@nvidia.com, peterx@redhat.com,
 mhiramat@kernel.org, oleg@redhat.com, peterz@infradead.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, riel@surriel.com,
 harry@kernel.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, arnd@arndb.de, muchun.song@linux.dev, osalvador@suse.de,
 willy@infradead.org, jack@suse.cz, maz@kernel.org, oupton@kernel.org,
 catalin.marinas@arm.com, maddy@linux.ibm.com, anup@brainfault.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chengming.zhou@linux.dev, mhocko@kernel.org, miklos@szeredi.hu,
 xu.xin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev,
 ihor.solodrai@linux.dev, spasswolf@web.de, tiwai@suse.de,
 emil@etsalapatis.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C167C0005
X-Stat-Signature: m5wzuneodx54yzi56csgz5p69aiercbk
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793571354-68644
X-HE-Meta: U2FsdGVkX1+9UYkhyfZ7V3QYCZenUz/ITrjtF9v30ZqWuknd1PFvwAZwzta+cYz4cWQqZOVisMYhbW5TW9JbCXcablIrGS1hbpsXqjHcgsn0ypySzRfn2+syRzwx7PwN72wsNxojXt7Tn91RbMLU8kwMEgdBvbuBMkGHR5KrCGs32A+6iWv4mE6du+YLKR6OBOXlnMaXx7C4y9LPYCRtH9pTds1YjFimUfkYjmNOWBzT24HKFvKDC5VTsFXwAhqSoUlAfk3qr/rqzKyFSuAEdchMZF6fUbM9rzm18IvIMIoUCoMbHlNvswCOFxWmKWk4slWvBZKIQgOIwChtuP//iKw5agLVSpclr14nGpF6Lo+0+tZvwD5ivyrIQnDJZ3+mZhgC8itoT8KBpR2IzMTKQ7gbMGRpWmBbkKneUeB/1FprvVpfXCFJkKgLxbdYyPjxTipCFrwB4L6ExTUS+zgVri8a6U2zly/k3spA//KYmPELppYzqalGytJTqq63fXtPQOC6c4QqgLrmPQb7B0AcPtRAMRNQeYvOJ7hqinU2k8VhyeYqaLpI6wB18nrTq0KhcssBuVppb3utbVnh8HriVld1V7DohEOaqVkrKhteXqs6gq2M+6Iek7wKGCht9ztc38ull+VDumd447PoiGpcWFe4CSDvYzzPfuNA0iX5+9GEnFGhtofoAYyjrPxYi5htpLEXJZLqE/ETcy2nVWbkJEVJK6K7nTEUqJNrha3vcrRxiqtZVEWPJhvZMktYSz463WQ4ZTJ8zJU8E2EqaYosWJwhc1WFjd17g+jkCjrUZym9mA08dRBSAVOpV/xxk7sQT8a9b2fCAOneBo5rxfrOs/AylmwIaJq/qJ5VzPGsWcBgPImnPXfvrzb/TeawP89AdBI1Sg6BzUGXChF7gnl01DlhB+M/B96kjxPKfgk/T4AxLTCqLmLpBZ55PU5apfkWdq/20SoEi5O3mKQfcTM
 l6XXj62q
 Cl6RAXHP+HZbJlOfUMQElQJyftrBDaE6ZSQ+Y48iDfmhDdxv+ziF7HS7HDkAaYL8G+qZmVxF3VQNLMinYjg1M5FTyV0g89Yn9TR6+HXxnmtmv2zsu2mj1jrmw/AhkR3yuXz5mi/lvAb+u4dQBFnHauzlQ2kibNw3UXV5q0PcbFv14Hfyxu/WvsSSk6xO9iumgbW4TO/gWVbHcLbPLnEnfnyypvw3xInnt+tOELM/lzx8ShD27ibbXG4QzOWl0OydIY3P7PpvDteJZi7abt+S4yv+lI0g3qtk8z2nEDSAgqAFaXbwhu3G45i2MM1P8dd1gtMiIF3RbkAjYu/ad6VQPXiKyJmWHsYY05ozk/DyDiGrkxWjo4kJvO+JNoTSXDnPZhFvEr4IJyD4MVnIpc4FiRhiJX3KG1z+prDN6HQ4Uyb60CKc0DL6OjgfVDx/0EPx39S1rxIAO3cTltzISk72wiwO3OK0oCsjRVuKUCQNvpL9aFA55j+R6+yVluAQiJhMX/+wb33oZMNMG9/J6Z4xLAI6OgggsbpQqWmtBxDySCMX/l1Hk/XtbIL29my+hOCNGrOM5h0ypNckGIJjczJKZpxiqRjFZMi3sbMQCFWXUB66pfjrdkwgknjY/TtFUWR8fEz2yReHNJr1IymjC6un1i4JHynslGxVZ1PyVfe2vKrylyaROumGnHcBU4C+Tu66PUCVYomeENcs9GiVfcWJ4wmsD5YuKSZ/0f9Wuo5xFzwjc4WtSFR1+E8iFIY5ThdWfDw++OxxvQziRd3L1otWIueRGvAyGvEA3zg4UL07OdYAFbAHidIjRb4CYnYiCCcbrYjrHthmr1i8R9VJ6x4bmHM0l6iYyCVQoA/qcPzzUN3xEP5ZMaxuW+boWaFEMdo9yHjqYTIk/ujnzkm6sNgm1nOwv+OoliLnxXdh+a+fXmSPQg8Z7pX3GO1x2+7vTVcc4CllJHYhgfsS1Xpb2rAftk+JieJAu
 lajWj1ff
 qnWBKl1ylqh6IQptbQHCMCslEHUeAvu1K3aJT8QbOUCF5wE2cfFRupE2VD9+K5WFWAwHI9NcOSbY/jm4ikGaZICePASUwXlYxBKEK5R8qsAGLKh7CaUUUBN95gw8UbCCbSKhLt9eTIUdGevvxl51rYYr3RtDNzqBVUBauznSaaygjCxelivtH9qWt08DoXrUVWq0Kqa4opsZqZOvzSjDFZuqbKW0/g21XWhwbOdw5T2XG5SEfh3Hzeo8kWzC/EabUIwHgAym3ysfIdVS9lNIHryPnFMe3jomaJAMoerqulStL2ZPyvKHb9k1AKaMaPuov9ae7qsClEEwwaQrlSfg3bEwQxFUVsWiTl+SW5MjevyViQl+KnCTIg6AmElLTMMI03OkLicvMWlnykDvUYKFGveYCGHUpROFL03QWGNvm68v1RygQXrllWxL8XXaT883zlwHz19v6NznACgAiHGtqKQ6LoF4sW0NdW2wFNcrpAeWSlxu3CHpz6xuN09rqoZr8qYarkcEAhmmZDWzZ7ZCI7UJEbhBsLwXAkPb3PyCUuiVAax03GSuboyN+2xJ3M8X8TrLp0QMy/ls/regMVrgTjVReDBHKDXsA3qy43Ib+DIB0s3nP3hL9/csiS/d240BYvnarGhGxpj9ZIPBKOsBz3bfcnVYzjQUgWDTJwfDD9kYwaxK4fQKIiEkudacsYWdOuYHt9vsoF6Jc2XqgeTvmTbDq6rYiAd/GiyVvqZyxcQdn7J2RTo1iI668q5RjAgpTa9yromQfVYjKaUR3FIyOdvYjODjRc8e9mvXWFspoMf+XWMSAivS6+JXmOUzdFeqSshEeeEeSDfrC1mz49jIIrPNKhCDzKmWzKXwelDwgHjFhadp16BYl/SuVPP8z6JHKHEZdZVDA7ZNdyEMSJvcvhVme4yDxIqUXm3KRgLXJ41DfB/2eVuLKRhALud2F+3wIQYWuQDWUbL0l5a4gEzMYiG38WIpS
 KGGC0ocL
 tdMOfK9bi24qRWzgfewmWwXIKhFwxAwi0SGGnAZoK9MBkyYQFz5ZkFPVJnSz5NZ10dsdD78yT9fZkpcjxg3yea/PKN6b3PjzBz9un/Nj9iYFttWsTgooNC73jZLOYHdPqeVAAr3xnXeSHc6NGfKcZAGNo4+wfT0iCUFTnpQtshwh985MtGETstxZyi5AYgf+/cA06ZUp6te+dk5xore3+xd5wcxA8SP8Mw6lEDGVuZWtvnkW7GaBdBIHnTgDMAiE0rKvICRYkOBTwrZk0F/38aW/dPaJDVfOG9d8MqByrkl+0ZCdyLRMdn0DeiZjrOxAmyaln7ECRtZRodJCYrn9HXoy665W6Z+Fx9kDjmuy1NjQAkuk4Z9+O8ndDrEU2+Ygej1cJtc4Sr3TV6nclMtqcyTFfv/WEtxQbQvafoJwF93SEqu7/S7MfK5xsHJFnVddsyDsZVtOhKY1lTPv7E3IPlV6XpCACaFlwntj2JkVNJ9Fu/W8XAV4a9jg3Qv48eoDpye44V3RjJ9r3O/uhW+pu+sQXg5Ifhrsq+Ue/EHdDQ6zBBaifJe5joATJRRn2IqombqZ3iFKOVjHfX6tQL40bYa0SdFMNVD/G98nNR/UxsFs/54ggbd/U4rOcCEd7MMbqj7apuwMgLgpJwFh48dLV+JhmgeOzM0s3+FNfr5Zo409aGL/ZKFo4uZjRpItessErS2izlvAD0Xuvjc0nr69PldJ5OSCFjX4S7LEjr+DTwFwKOMskXEivUe4N4/vEzlnmzLib5rxj5IedrZV/qFtlIEF7fXsCUcReI/Di+74AfuTiosfq7zDZzmXy8Xhfwl9JZ5baiPhoFbDREcPlb75l3Mb3MHaJC99lMhrLqi4hGe9CMtIpF9PT0fL7iYvCgsYV1CIh8bPHXArlH7aCUVIC5092sP27cpvr3hSmgZLMAW+JW1PAQDV6FXlqEDefz1J1dM34tip65oK+fcw+CSYp5E4uQxMe
 J74aY2yX
 fz45JLG3RLfKmO+RQbMwBPM+U2O11zCmOqWX2AUM4RjQ1DQXYcpDqg9PHhaQircrJZ/M9VRBew/t1pLCW4TWW5PJrPI7IxVk0PPQH7FE24/BgmpcVxbIax3N3ePSEsDMw/c147sW0VsoTVBBT/djFuXX6HwuAT98XrkWjyjSnuWJeCHq57rtvaMDBr+ksITaDBSCYaYnad6RWWatjWUx88KBwttpVt63+loA4kuuuDdzP8X2tCZbMYeKthi4yMdgJcFIrchydj6MBYMKBA0t0Tz4dMBjohuUCHS/KlUKjHwOyd+phaWm3IxtROC6BLR07kQuokV94s/uRBWBz8iSmN6aWNXDDm5GmvLDd94H15QSKsQZAQxiJFFlXBv31ssNOn3z89NxgaDK9P0moe5pLqWxlr3rsNBGeBJnE5rVe5w1TxFK5ftbtpnGV8xIfzmoxN5Es8Pks9nzVL+Jt904Ux6f2x/8NCjSndrtZ3FL/L0U4YCO6Woz//USFeme6kraFhYtq8XsIVRMo5eQRenQRHWsY4YntbCO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Tue, 13 Oct 2026 16:04:40 +0100 you wrote:
> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> properties:
> 
> * Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
>   pages, or even ordinary pages itself?
> * Can it be expanded or merged?
> * Is this a 'weird' case like mlock where migration might race and we
>   'have' to set invalid flags to notify?
> * Is it another 'weird' case where we just want to stop GUP from touching
>   it?
> 
> [...]

Here is the summary with links:
  - [v6,01/39] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
    (no matching commit)
  - [v6,02/39] mm/vma: introduce and use vma_[flags_]can_merge()
    https://git.kernel.org/riscv/c/86a779c53204
  - [v6,03/39] mm: consistently validate VMA state after mmap[_prepare] hooks
    https://git.kernel.org/riscv/c/9cae38dc11da
  - [v6,04/39] mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
    https://git.kernel.org/riscv/c/6335c786299f
  - [v6,05/39] mm: make map_kernel_pages_[prepare,complete] internal and unexported
    https://git.kernel.org/riscv/c/2a234f79d416
  - [v6,06/39] mm/vma: tidy up map kernel pages enum values
    https://git.kernel.org/riscv/c/4852f3421456
  - [v6,07/39] mm: assert mmap lock held, use new flags API in vm_insert_page[s]
    https://git.kernel.org/riscv/c/dad8e88fcfce
  - [v6,08/39] mm: add mmap action for discontiguous kernel page mapping
    https://git.kernel.org/riscv/c/b7b4d8f37a4f
  - [v6,09/39] docs: filesystems: update mmap_prepare docs for discontig kernel pgs
    https://git.kernel.org/riscv/c/ae60723abb65
  - [v6,10/39] drivers/usb/mon: update to use mmap_prepare + map kernel pages
    https://git.kernel.org/riscv/c/5323bb5f6ef3
  - [v6,11/39] infiniband: update hfi1 to use remap_vmalloc_range()
    (no matching commit)
  - [v6,12/39] selinux: reject writable opens of policy file, drop mmap shared/write check
    https://git.kernel.org/riscv/c/c6ce4378f20a
  - [v6,13/39] ALSA: pcm: use vm_insert_page() to map PCM status page
    https://git.kernel.org/riscv/c/ceb0de27371f
  - [v6,14/39] bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
    https://git.kernel.org/riscv/c/0c2c9885c5e9
  - [v6,15/39] mm/vma: add vma[_flags]_is_mm_managed() predicates
    https://git.kernel.org/riscv/c/7fdbc26b69c0
  - [v6,16/39] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
    https://git.kernel.org/riscv/c/d99c4a302c5a
  - [v6,17/39] mm/vma: add and use vma_[flags]_is_fixed_mapping
    https://git.kernel.org/riscv/c/9201d0f5b9d5
  - [v6,18/39] scsi: sg: convert mmap hook to mmap_prepare and rework
    https://git.kernel.org/riscv/c/abdd54cef5fc
  - [v6,19/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
    https://git.kernel.org/riscv/c/19458d015fcc
  - [v6,20/39] HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
    https://git.kernel.org/riscv/c/5605c40895fc
  - [v6,21/39] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
    https://git.kernel.org/riscv/c/2d2b1c508f21
  - [v6,22/39] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
    https://git.kernel.org/riscv/c/0d219bc3cb88
  - [v6,23/39] mm/mlock: clear VMA_LOCKED_MASK over mmap callback
    https://git.kernel.org/riscv/c/61e012ab9a1c
  - [v6,24/39] mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
    https://git.kernel.org/riscv/c/aea83f2694ed
  - [v6,25/39] mm/vma: enforce that mm-managed mappings may not set VMA_IO_BIT
    https://git.kernel.org/riscv/c/99fd6bf43d5d
  - [v6,26/39] mm: remove VMA_IO_BIT check in vma[_flags]_is_mm_managed()
    https://git.kernel.org/riscv/c/88d77002e1a1
  - [v6,27/39] mm: remove hugetlb_inline.h
    https://git.kernel.org/riscv/c/94c86564538e
  - [v6,28/39] mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
    (no matching commit)
  - [v6,29/39] mm: drop some redundant checks around hugetlb VMAs
    (no matching commit)
  - [v6,30/39] mm/vma: introduce vma[_flags]_is_mm_backed()
    https://git.kernel.org/riscv/c/44debd840ec9
  - [v6,31/39] mm/madvise: update is_valid_guard_vma() to use vma_is_mm_backed()
    https://git.kernel.org/riscv/c/fc95d1cf4a13
  - [v6,32/39] mm/uffd: use predicates for userfaultfd checks
    https://git.kernel.org/riscv/c/fb700342f506
  - [v6,33/39] mm/madvise: use predicates for madvise(..., MADV_DOFORK)
    https://git.kernel.org/riscv/c/1d1104fe6dc6
  - [v6,34/39] mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
    https://git.kernel.org/riscv/c/531e56359ffb
  - [v6,35/39] mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
    https://git.kernel.org/riscv/c/5997da57a09b
  - [v6,36/39] mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
    https://git.kernel.org/riscv/c/8bf792b7afcb
  - [v6,37/39] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
    https://git.kernel.org/riscv/c/72a993449cb0
  - [v6,38/39] fuse: dax: do not set VM_MIXEDMAP
    https://git.kernel.org/riscv/c/b0d88bfa7515
  - [v6,39/39] mm/huge_memory: remove vma_is_special_huge()
    https://git.kernel.org/riscv/c/e2a1d080f510

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



