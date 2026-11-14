Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9AD60A5BC5
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=lbpFU2i6
Received: by kanga.kvack.org (Postfix)
	id 22EE26B05BE; Sat, 14 Nov 2026 14:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0526B05C0; Sat, 14 Nov 2026 14:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7256B05BE; Sat, 14 Nov 2026 14:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C68A46B05BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 202E5120458
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:05 +0000 (UTC)
X-FDA: 85434783210.19.1E7AD00
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35CCF100004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lbpFU2i6;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686223;
	b=z693Y30DG6Y0bG/u4KyaNBwAWY8eOqE60J0EWyXecwtIVS141axlPH6BgF5mOpcCZUmhhF
	9/prz5PIFNRrI6YvC+3KHhjoEy4S25GGLtTBIXpzi01N595F7in05wy3u56qbY7tHO6huR
	tjd64upM9yHUScKin5iVYotBvkYSnU0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lbpFU2i6;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCi4ttrWWQASeF1sPChkoEBldIkxl44ii+iYdI68IA8=;
	b=q39ci+qfnJtxDMMAEdnTzt3htQanIIFQG/RjkNAprx9tyHVIP4AYGDFtz4Wc0TE6IEr3+L
	6w9PwnGT1HkEhY8xZC3punRl/soweYVxEXA5vhkn4/UnUTR0nAf4xHWz3aEt524jV3TrfC
	xqAptEQDghP6hZlilzqInZFgEl787HA=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso1124570a91.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686222; x=1795291022; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZCi4ttrWWQASeF1sPChkoEBldIkxl44ii+iYdI68IA8=;
        b=lbpFU2i6LWzwUuR/A8PHdx+uj6mKaxR6QXatPtIJHo/GYCJgjYxTxPJacPcKX0Rn2b
         0KifFqi8D3opzEchaRRG2wACR+V9AEsOAHJuWmm0tHzX2/c3asMF6Y2KCi00edDd5TOn
         EizRtwCn/xGJfn4C9Ygl++z48PJXzZcarn99Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686222; x=1795291022;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCi4ttrWWQASeF1sPChkoEBldIkxl44ii+iYdI68IA8=;
        b=yk8vxoMJs+jYUIm8v4qdMWyvnxkEz2mGi7/yzLQuCcau5uSBlB3emEk8x2y8QLG1Hx
         voG0yaAQRmxZRGSV3Zo853njJHevaSzr/WiHTd+yR0FAa9WERjer2mHMG3mw8GBnIfg4
         RJV0BajSKyuU/4+XlzZ9qTE012v337pcgVzpu4F9wcqxrp8x53zG3w8ei2gjUchFkcGH
         6fef8ofc2GRCazpF+QPICcyzBrYkovU6/lnspNMAVW3+R+iU0VYbdtDN4MwmArV1Kk5I
         +ynFT62CIHx9p/EedQ5Tu1VYXV38tVBQ5S5A87hZL1wQVEatDB9bXXpzUt5JLdK6q7CK
         2QZA==
X-Forwarded-Encrypted: i=1; AL+hErGaAoSkjju2z2OgHSQui2w4gDD9Q8GAIVY46iKjSI/QKlVRc2p4Ci1LalQ2ZqhYTETSTcFNQpP9XA==@kvack.org
X-Gm-Message-State: APuU4Z+ubIH2YNhxN20mFJLOtV1hhWaZSmL4eIwwUW+lciRNPmwrgVvq
	aXAKiw5lW5BbVof61u6heWk6IsjP76XIvR3cRDivZ0IceyT/PrMVHzzVZc+a28deaec=
X-Gm-Gg: AYBFou1PQx+vBMAkFHItfSEoGtT4t3dFxu+XhoHS82tO6dJ1rJxBSkUP+CcGo2cL8S0
	jVm5sO0JiDyKmTVRZ5Om3u5vLXaDsZv07dS9l1PMSBvsnxzOCEGyOzR4SK228EoJyUpsCD4Y9Tn
	vSYUAQlO2ym9iqae9e83/1IG2KOEKpSICUyZ23H6x5zSfJJSYj0ji8prcNyWwNIzArqeLJi9az7
	xDBxrK0Oc82DCcj7nsL38pn7BjebIXdPs0PU2BMZjo8IPSlLHjYpA+QQdxexiACIavo7umtmJdw
	VD6cPgbzqi3VN/Yj0xPOREHdswjJDm5HHBBcnCB3rx8MarkQXXKitGIZGC7gFC6pnd3u8C9w4nP
	mVu+iVOMjByTSDFHqZeRM7fbanhPsuyyw7MD0v9Ty5iZQXR7uabX4gETxAMc0/WckCZgwAe8mub
	ikMOieg743vKbxVTGXfX5vokG+PoR+LSSH5XUKlALrybKPM1UI3+r7VSDlt/OO4MnpP49ou7FOI
	NTxqX2NyyOQfYXBFFTSbCUHVXHvU9VUQvYze5ZrI/Giq0c4dr9I1eKUspamyu7iRZaEsF9zjILu
	uBadZ1/KHnHJXzXAWHLmcru5DPmenP9QZRSMX2Jx0T3elFOCP2BUr9T0jCasg3pq06FFfJkUwBC
	j+uKD3CJB8Oc37faAF/wGE5Sbgsun+rMQpjwjN0T+JNH+LIaAXBXNd89N//QvOIdNcCrawGOEPU
	WKdn5Rc4CVi+3K9v3/fxaKXpIttQ9qEmrZIRAK6xKV2t1o0WdfiGVHtQ==
X-Received: by 2002:a17:90b:2642:b0:3ab:2737:3396 with SMTP id 98e67ed59e1d1-3b1b0b9cb54mr5682263a91.65.1794686221931;
        Sat, 14 Nov 2026 11:57:01 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce460csm14709280a91.5.2026.11.14.11.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:57:00 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:57 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 08/13] mm/migrate_device: fix ksmd oops on a migrated
	KSM page
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-8-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-8-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115657.f63de4714929f7af@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: tsbjbyduw4rr7839g5ine1usxit7bnat
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35CCF100004
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686223-164407
X-HE-Meta: U2FsdGVkX180nKBSEm+ucbtv4OWduejYgvN+fXK8D2nsqZCd8xPRYbPteeJznHaoDst6svP5MSFh56gW8oQnaqV5Vfu/OV4sONd5PMSrfhQWjU6ndeyZaAW//ZHnRYLptd3lc28+n53e99spOXROepDlzArq8Wn5s6GX6zfqO/Z51Qi28grESmNysmFcwCSKpzaJ8+uvhv1UKvGwslOACYH6HeF6FU1YN6WN2wQkM0dj0ZYe8gHCJwDUKyttFcIzWhFF9E++NnkDzHW21119frnZIZX7omv5zkeuqfKudVMAAXNug2fOCP0cJnlVFwuXKtWef/oaauK7EdU7ZT0t9KBdi9G/HieRrdk6v9I+/LdoJM29g7r9FPejARmHYL4mMNEgfs8+x/Wl3rsMmEBno7U/EEuCvG97Og4ra3RldWOjLevY4MNIw3dd52TZpa8/ICU66q9Es24yBKuwzLquMbil3kQPBqBQDpKqPN8ddTW8jHPgsKXYBvPQc7E76fYJdEr6gaLkngjqfZ8NdhQpgnOnkAWxhQARIwQSyfG7Fpz7ikwoDvvKtruiGWQGec1Ixqqn1cka1TrC/NHFzBKZPiftT2tbnBnK1ApSJ7gqYmPln5FVlLmVAQwpDE3hOgdA6BiR+axLtNXYl6lCd0SNnAdtrbeqPCCEVxNb+PyEeaSgq6eHonmkmh4yXo4dMzuG4GFqKfucLxThYejNYlDP9SRu4RlDMrqel/wQHfGk1MuZAKXVayiGkIHKDXq0gnGRDbi8L8U3QY/K2/Ex9U3qu/wfoB8iyKo58GNf6dlR+4hZDoQaMNtO0guuwRFovYWtKH2gnHaAatcx7Lm3vRuHsb50asor2IkxP2OlUrLCBj4iNq9OhCo1M+YMRmoW5Tl8qZKr3ZxRh8sFWfV3DWXMModmptrFjfiNpgfQXe8tgQomM/7mUVfNK/9P7cqRVx4IQLMdkQ3QAoXpv7Giosl
 l5mk/Equ
 gISaxaKiuUn+rjPGzGGrzGK2n+S85Qyql59hLBHUELoFYolji0PMPzUDYU8BW++9gbiDCCfj61XvejVzfB29o306Jp0o4Xb107W2155E6a0/qY9dn5sTbPMfEKGzago3vRWQrj3MCVS4lfrgfedPaQRqvtv3u/lgFVBadsqwJtaFse0yVfTDRafM+WZZ+0VjZ9PbHBEa9RVha0DNAtwXRgfDrGo0XCRlIRrxmXEya0H7/nV2UUTomQS7uodsw2YodlBlNSo60wwey7ADRrJzx5pw9lt/H/bSIl3xxwE68qV4bnrqt1J8J50pqF/iGZ9JWPVBggM3i2JlKLL1o7/cHQZUeP0pUjfTxtWgsku+2qcCP+UUQqfo9FduKsigIIrJ0EK8FiElIcD2ebOnT6kqEs5GAlEJSQDaEbo9NjhOGW7fD7MRmUiYpqBcJjdXhqSNpkWZz2lyoDJGGB+aJTk5H1xIRKOTJc3g68wOuVMZpjYgC6Qza8wjLtxGiY9EMjEB60Xrxsu+dcSQohpzapaUA2SuzvgGLs1slC4s1oHE+XIM3qInciVA0aRjZchQpYaGT+FYEizUum7IRWzNsEFdqV1URNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Lorenzo Stoakes (ARM) writes:
>[ ljs: tweak commit message, comment, also refuse device coherent ]

Alistair's Reviewed-by on v1 came with the argument that KSM pages should
still be able to go to device coherent memory [1], which is the opposite of
what this does now, so it's probably worth checking that he's happy for it
to be carried over. Going by what ksmd does with zone device pages, the
change itself looks right to me.

I've tested the device private case. Without this the process hangs the
next time it touches one of the pages, and with it the migration is
refused and the pages stay merged.

[1] https://lore.kernel.org/r/avTu3LmscsttRVRp@nvdebian.thelocal

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

