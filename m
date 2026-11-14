Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9A7606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jbvHKTMb
Received: by kanga.kvack.org (Postfix)
	id 64D846B05B1; Sat, 14 Nov 2026 14:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624CB6B05B2; Sat, 14 Nov 2026 14:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E406B05B3; Sat, 14 Nov 2026 14:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21C206B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F6651601EC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:39 +0000 (UTC)
X-FDA: 85434782118.22.CB3BE71
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71D3240005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jbvHKTMb;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.129 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686197;
	b=o88K7SycHJb7YHFF/lWexp7WairFJUZEaaXtnzg3XJ8Lx3iawlUr1rdBV6W3Obb0+w911C
	a6b52C7HHLj9Pbmem0Af5yhSMLihcvHA2RnyfzmkH62fdEpTpq/JKml0quxbGmufPaHFLp
	Y4fjmmgBsYtXCZY3xf34mJRoekUvoh0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jbvHKTMb;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.129 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5xf74SF1IJB+GwjvbT5WVTIN9Qc9W/2f2algOzAsJI=;
	b=Kzald/6Ex5bn+wL5JOAJuKy3hpFpk1C5uT3afc/0lkbMEBMLfhiH86ze86Y/+jyVY2qP3K
	oX4/sq0HlBXnAL6Gk/QwGW1R7BnkK8UFsyIG9KyBqMC7PTdH9qpptyO1WVzrs8wzSAbYpu
	lNkfgvAZwTKsn2kVRz1942MqHKx9CeY=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3b0d11b85f0so1386115a91.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686196; x=1795290996; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M5xf74SF1IJB+GwjvbT5WVTIN9Qc9W/2f2algOzAsJI=;
        b=jbvHKTMbF4Cn2C0fvvSDqDv8ZfJFNt2vVkDxiy2yK/TmG7RmYohzP/5M48yjBlJTyB
         lQ+sBWn3HMfGA8cSCRAL2704ICu6pdfnczF5I3X1LmL4McVZLzFZ8sVnYabCO6cL6dDU
         qXCZ2kAQo1CFBkdhy2L2hW9oZ2s8AwUtUKeM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686196; x=1795290996;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M5xf74SF1IJB+GwjvbT5WVTIN9Qc9W/2f2algOzAsJI=;
        b=kKKGtGXcQC13GMZ5DPUfv34U1BWbVwlfVDA/SJdxJ8rwoeovFsYJOcTmjttKVd42gw
         6/lL2x2Vwy7Z+88SMvz+VmIs6QUNz6lxjqZsQc1sP4P4BTEF5RIrO4mzfOR2LuCSChsS
         EPb6Y69WvXBG9+MB/reGXXoD8voY7Xo6v0THxh1TvgJBqgs6Q6FYPA5/wDXI1Qdwpp49
         6XiCLjt7WwSQURq4JYEFOaUmfiVuKbCkzEpeTjR0opmSX7gkDDAu25G3FAqeV2ZSeJsW
         nqXRxdsKcKL2dvZJzv9MtEDCGOKSRM1rWYkibpZ2N27Wnb9tE2D+cbwIFiTT87g0wBmx
         w/eQ==
X-Forwarded-Encrypted: i=1; AL+hErGuQqx85oVyrZguZnF/mMeNW4cwbYZZ2J8jyhAECE9dqsALh9lsxDAj8TBMfud2fbXROGd4oRNDow==@kvack.org
X-Gm-Message-State: APuU4Z8nxBfYigjJ8Ub+9M3oSwSmoAPRLOdlzC0c/UVY1DdWu0zDi1JF
	hVk2VZTR2AK5pn7434KX/4mSe6mzIF6JDeYU8Kj1kpoVPW9sATjYD7pyaDUo3ooPsYw=
X-Gm-Gg: AYBFou1qntrTUKwqbL8Q+eS9+NfN8NRh94trbKkTrAIoitUNwv5mqg6QosXUPtNSyIS
	Gz4oP6HS+jFw7mTZmHQ/4Ct6ekRr+4Rbw9gEEBSsChsVVdTswpQ5r6JZpfaDryuSfhaEFB3zto+
	clU3CORtmtNIaDH+R9CobYci+2+88UGa4jS+6VOSosq4fbBIcHe5ALi3S9o8YwLu2ZqM7acol7y
	05+RUBWD7OK8D29xZHciR0rikuuehUR/wbtP12VCVz6ND0zPMAyLpkpV9BiRj3UGg7K/0H6nSge
	VCv8jTVUwoSBiCjNLD72JKP3fa27eYFvdokCHsrrlRh7zdJy820U5QIamAtyLHC1MV0sDkrn63l
	vqKNmOadMY+AZALtCfI2v5r9pqQghG3lkRKBY2w2gAXyKhgiRNCgqd+GsY2UqzEI3Ge9KlQgyKs
	iKS66Z6jE/C203zAwp1ZCh0WJJE5llR2OLm1WAOa/4VOHHn4WOpMMbKcNxWdYqSIAqusRgvHBi2
	6EXBSeklT19rLimOxKnPniZ1lo15mrJk5KaCe0Hza0eps4QTHzKKsodhVL93tUj1gFXufe47JX4
	buQedntFbhdVrFLDnWDM6hD05/W4Re9c3jbghkFPlIcK4HvVs/y/1aLFwtFEeR5ok6m4xsUtkdJ
	8zPZLMliwJ6i3GOIc5x+6PJUQKLleL+SyQDRxR9bn5Zizkfh3IdRdXZOrFFfiV8GuJi2t3OQFKt
	RHD0wQ0on3qpU7vD4GjkdFulMURPS40XmgQVXQiISwneVCjFQHy+4MHxn4p68sdiWP2NccBWVye
	CwhQQ==
X-Received: by 2002:a17:90a:b494:b0:3b1:bdc8:c32b with SMTP id 98e67ed59e1d1-3b1bdc8c4bemr3620403a91.53.1794686195875;
        Sat, 14 Nov 2026 11:56:35 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d35525sm14940403a91.16.2026.11.14.11.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:35 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:30 -0800
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
Subject: Re: [PATCH v2 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-1-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-1-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115630.0b75d0b49869d4fa@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 71D3240005
X-Stat-Signature: itzuwas1qqfbh661m73ppcx9euqy1di8
X-Rspam-User: 
X-HE-Tag: 1794686197-361708
X-HE-Meta: U2FsdGVkX1+Ubd+NbsfbhMNXnxAV+HeW9KyyKjmTidTgvDcBaReDlrPeh3cu3Q3eQo4PC1/inIS/1D7bKAQHw3OwH1CnqW4G85PMBjopgqjJ6anqgqS46neNJlByVYkoNrww/gTfN3FjCwhYy6+QJdfyfaJv7/oMVF0XvSqVq8UTP+mndDID+S60EgjjLnWdzY/rhGb6h8W9bE/ffb0yxOyHT8FaET/sAbvSq6GFkz97zR7PrrZCaIRdwNbU3/2BLBIQu4AyjVcQcmCgstxiH3DizMJHjdlaOjslrcyVkyBkTT+nKIPU/wG2/i//mUh81/2gEgELlLu4XGFRaojThn8brMobO1mAZ2xgovBdcfkgXbUuVyTREvgv8Rhi0VuFNQfy22Tc/TLXMqGMMN3a/YnUHaifpSvl35WTxec6KUJfkaiO5HfAVb+gMPPHbI4z0vYwfkD8kTS+syMxaLoaGHwjBYi+0hrO9chJ5h4cVkmgyVwRvT/G82vjXOFeU8xSueGJhyvhNgGnbqrwBQRSQUqPCtsA0Ogi9Jbcucav421iKl+/rBpK1fUF/X0DmdKZh5Ot9EJGcUQGwn+PNblMLM/i00v2c692FSk3rI3+PWlZBUquL4Z/QMRJV/5eh7ms0XBg7DLRvi43fvF1bLxJM4CQ96h0cjk6XQWWpGtUhy5h6KYNNShSLFlYQufENgGr3CFUtgXGki2EHS6yO/t0SWlUh8kpexEgPg26blAt/KAlT0m2PVmNGGHoZTa4lRe1qfWLOqsC7se9lCbRJ9gfZR+RaO3AumwiA/Yals72yXuVrWc1aAYFEt/+pVe78os9uNwfU39XjIorBRItp5g17/9TVMHBYGELThODb7Y11tmg9d/OfG8M1LBrMArQqVFbXyulx5ZNS+42jyS89JDicVKO/Xf/1VItdmeRW6TI2Bx9UBwW5lia2iXJmWcUGZUw2esbhAbLefO6VGAJvAt
 TR1hAjam
 7Xo78WrG+iuLjwI/Kahr5/1U1UFjsrb6s4GEaom+azFfPZSfIGTvLQkdKg5bVAU4EzhBw6HvTKcjl7FPm8kjgJIr87Ug+wXFE03uXAdjZQcg3EBNHS6zvgt3U7e4mIorQP2f56RBW+aH3V8AatYpNL3x6BSLJcfoRAFtoADDB67jaK4KewrAi4GiwoJ32+yJRR/jWUQ6kcWjcqpU2lekOA6Gp/wl3u2CvS+Tb8TmyxU63v/KsEeiNsGQ2MAaM/JN2OfbTxPrTQNmu/0gbLS4NPoMum9jDiDSITMdQQVbgONJ7+j3FwtiUTu7zfbLwakj4kz3amWv5tpytixPPakTmO9s74e5uo2CRvshQCi/aLnYgnmOyKg6CNoNz4ZXF+zP045fp37Deq3+TPP2+lpTt+Ew2Xm/zflgNBsOJtL0u9E8cKucCW/+GTfNHvKU1QOA4MdB+rSKcxKGMTvPYovy5khAxkljQmK8nw3bGoFqY+QtpP7GVuOqqEoKaqnVk7t5G/S/x/Qj+s4AbquD6HVOvUvoYjy6pQqXi7gIlJ79MwDLgz4ppMjqrMjVrjk7b6y/oyHjeABl0ZDvhFFgny9z+FeN6IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this with memcg OOMs where one kill is enough to get
back under the limit, and with it the second kill is gone.

It's probably worth knowing that for a memcg OOM this also needs my
css_task_iter fix [1], which is in mm-hotfixes-unstable. Without it the
memcg task scan stops seeing the victim once its last thread starts to
exit, so oom_evaluate_task() never gets as far as checking MMF_OOM_SKIP
for it.

The test I used for this has a 48M memcg with a 30M task and a 1M task
in it, and then a third task in there faults in 26M, so one kill should
be enough. Out of 300 rounds of that, I got a second kill in 299 with
neither patch, 277 with only this one, 147 with only that one, and none
with both.

[1] https://lore.kernel.org/r/avA1wXhTMs9eY2NF@chrisdown.name

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

