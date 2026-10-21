Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF23606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=gm7y7nKW
Received: by kanga.kvack.org (Postfix)
	id 2F9636B0194; Tue, 20 Oct 2026 22:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9D86B0196; Tue, 20 Oct 2026 22:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFCC6B0197; Tue, 20 Oct 2026 22:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3BD26B0194
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:23:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 537BC1203FB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:23:38 +0000 (UTC)
X-FDA: 85345037316.12.0BA7B1D
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FFB740002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:23:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gm7y7nKW;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792549416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouuFtypaEJ9ckJXUmMEhOp8/mEcn0FyKt1h6MgNlrj4=;
	b=FX6nIk1BOsHpneP6hAo+35PKmCZNcW4ApDWXkV52HJdxF81rQYu7TELjpv8ZlcMySr4fcr
	rwQuox+ThRaRNGrxGlwHv0Kv9AIbaPK4cQvpIDGwAOQdlQ2LwIiH7noSFGvafKI/GiCyis
	K9Ohgy1FZ0Im6Bx1SAnRQ3lFOJRL/b8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gm7y7nKW;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792549416;
	b=n/GOgDEKbkZTM3D6eRWaPylWOnuci9ezQ9/QyidIsVBFinhzm4K88Wb2Mebb6NAO56AIvo
	jJZe2/z/qTUicIHzuBdNYGxSDy0EL7E/JxDbzW7BBdeFHzF/ppGIh0MRe5FxV+OXpMe9Cj
	uAk+mEqdAhxTyG/9C1C1TzRy1EQYV1g=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93efc0452b5so22206785a.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792549415; x=1793154215; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ouuFtypaEJ9ckJXUmMEhOp8/mEcn0FyKt1h6MgNlrj4=;
        b=gm7y7nKW2y/o+3zya5SWJxlUoA7YPb4F+tGuLupw0jNdgXM1Nm2TM+S6VO3RBEk0ge
         MpCTWW1WNtNdLJngP1WuwH0tW4HAWjgg9jBNuq2RwNZOX51i5XdLBlpFawGI169FReDo
         yktBeozL4ZMfChBZZZiuMNXrtMJR1tSpIbwd2lTlNucrqiGbd17skSQPn43YF4R8z3i1
         Gg8xR43kxWDiBpeeomOTkHBi1FKadbprRzyNIPC1L91EWNyI9b80LL0tQdprMcIBbUKB
         2kTEgvJwI9l+S0lNkswajxzd6Y1NUc8L8c9ns98JtpPdq+2K10paLOKhfmeE672chsQp
         3uQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792549415; x=1793154215;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ouuFtypaEJ9ckJXUmMEhOp8/mEcn0FyKt1h6MgNlrj4=;
        b=UES+HVUEsZNtenwCcoZE7q9UOS9q4rQFDXiw73unKdvcVE+RSze3jiC/8EhYPUqSOO
         Cnd3N1zdPIjtqrYzjuyD5n/eOqxAZSLo6XpvEDhbI0tyyjU/T4uQxTPw/bUG2cioqT//
         t/5pQlnAviR89MC6yhfLRWiJinY6WKBDY1LJtHOGAYvBPD8XEMdM86ucBE3tdxK9CNbX
         qHIogoQFxlOo0DnzyRaz0TQ4WbQHvpMdnzTQZVALUJ4FmFBw6Te93bAmkg0zeXOuez1t
         EmY101mMKW5RmTWns4kvw2Hc6P99khGlnAL+AQqoVjyjrwyKekloHEdXchcwhFs9QWtN
         5gdA==
X-Forwarded-Encrypted: i=1; AKwUvBzWnPBKc/XJxIgEY8HyPJYNUMNg+6puBa95NrNmAPsd6IKWpAjiwS7EIHvB+suz8h5w5dXn7LA0nw==@kvack.org
X-Gm-Message-State: AFq9FYIAECYoEE2NVuUTJIKttYgw7rJSUrgazcYBRRG3aqL6n/wQ3euB
	B7bpRSAXN6uKl9pjKXskda6xCt9oMmVEyOnWV344oaxM3NJ9tx6nz34ivxPaTfT8+Ns=
X-Gm-Gg: AYBFou0u9ovrnS+ddGbSkx+MM0I562rlCDjXjlD5pTX0qL3cFVYYidxNa1Fn9PzNGgu
	OrjfEE++2VWyqGnxEMi7UhZi5PL5CJXr7BHJUw6GBoiIC0F84duGHhxq2MpliPL+b7Iah2vYugu
	IbT0Mu+foDKZlE2y7JhM/33nyHgYWqbdgVI7xrzrdce8gRPYt0CpBVGN0eGHECCtUg/tYP5ue+I
	dEvCm6Je+uM6SYQYLv8XR8jBnlmlcCVfeQBXYHQpMNcFhaUY571WHcob+Yh4UqOb+F7u/vrZWDZ
	3pwf4NXY+Y7O1/5Bh37mU8aPOpFN0xJ5KRi3/68+W0VIK/stQK/OlgjzWzF9zvOvNgQP00Rs3Q3
	baDOlp3ILa/pVK6U2MLVdbWQRzzqwQFIXZcQmBExG5XpVs9oqR6RayElecGsJwxnW3O4cHCMLAk
	aJ626uulKk7Aqg5zUvNrmZpBCwYKdtLeIt4yZY0wZtZPHXvhu5WAEYegT2h7+eH5rvaG+C3WfWM
	VZ49MgliwXjFtLg84eou5qjXdD4+9PbsQXh8SytKR4G/drR2OwJUBnzuftSfljc4CRaPFO/AH6q
	zW6NooyvsEqy/K8YEGMFRQm6T6yG
X-Received: by 2002:a05:620a:4621:b0:93f:a7e:e0f0 with SMTP id af79cd13be357-93f57fd3b6amr186072885a.82.1792549415263;
        Tue, 20 Oct 2026 19:23:35 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56de57e8sm135743885a.25.2026.10.20.19.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:23:34 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc()
 stub for !CONFIG_SCHED_CACHE
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, 
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, 
 tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, bpf@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261019064157.29885-2-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-2-laoar.shao@gmail.com>
Date: Tue, 20 Oct 2026 22:23:29 -0400
Message-Id: <179254940965.1919196.7604748267690139512.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FFB740002
X-Stat-Signature: 9oqgj6ouenkmn8ynph1k1thjn93hrwpa
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792549416-424137
X-HE-Meta: U2FsdGVkX18eOC0TysPBI4HUsMY1F3ms4DqpUjCV6eu3RN36rRekf7BGGmxeRE40G0GJ14sCPb7QLKH4sNHQEtCmopRX7eHzcYJcPeBhY9PYMnvWfEXAJgHQE+qLDO78SGVE7UC5HG6Lt+PKH3V9/ufki6ozwwDNzB2nJisxlOJ96zXvwRT6DQV/vx6uj6gBAEmWtUNE5PgPaWykr62F/xZFrv2CoZeiZTKgS+2jnpzodAyvTpuZ60EGuTrTY/XJ2OK3xg62Zax0iVSFvL5LLE3JAFUkRIXo+9DYinGEUu6SiL8NsdBKLsI/PsU1x4YX5payrgxlEh2gwNhVO/dsFmcpZTdOwTw+i/RiwjtNDAj84tgcZxKy74ZDx38d56owvRdwGiSi8yKU53/wJMhf5BuBHCAiPwrpPEIY8p0BmJok3j3BETPhN7b35oppO4LPEUcTVQvc1xH4ucCLBDZVgBzlm4BYYMvM09YbpYj6+QOEsqZKglgg5kopD+ukyObLIVSYLsUsG7AZt4eJwJUDorWbT6zYJg6cGRdxEIG0U6+WUBbajZ7IQHLGRimmncUYRwkIIE/nhngh4ZBLh0n4U5KV5Ylsm0+6BstCgWMH2Zd6GKbMlFjRfd2c5WPmaLJI39lGb/ueycZ4T8/nvpHF6Zs5wm4+f5ijp7SRz6S43WKaAVT8YdX5qpvMArmSBrBbpFJvY+TR4RjG/16iAI0WgBzKqvnJ6yEzKhfk5Ie5llsTRhKp7iIRBWyP5EKW2vEL7VJhNjGNeSmaXjk+Y0NlBMg7mBK8gFf11PMVZk6Q1X8SVcNqmSz0ADbkJLqs+1dLJysuBq5XLRf/RLFZDfxVmcFLiYb7oH6dhO0OsJEgQdirJIGchaHc/Di3UrR1ETWmn5asW74kGc8awagX40ZLW9X8F4q305hdAZaFyRBwZic58CouBVdQllr+qS3nZ+LHw2EbdC3ZYJTlblzU4u7
 WA828DCH
 uwwt8JMc1Wt5mfNe7L954BoVDBzGAG3bsVRAfDRtIAkax7R0sIj9bYNcH51sdHii4pB+DGvZDUDFw1VhkYwv/nTOb+r9WkWUQcndJA4jjWPZZk+HivnPwdydI8z+pHbY/KbYA4RpNcSiVUQkwG5BXkdqsh1LST7xfLOTg97UYFKygntOFOXLtJlWPZ+8+r7eAZ1PFAuZI1G00nBJQY2758r6dqWHzOcC0vPBuD6XYrMZfAHMfPK/qPX6zkuAkECg0yXabun5tDfDo9d8grsx0HZoo3SnDevtqqZd6o8O0O0Dq1XMgY0WqUm6bXiVyUaG6tebR6d5AY2hkAK/bDm2kSRJmaYCWomVXgbRSVI9hAytILyOG760c+C2Mh7adFCT7zxlQWGj9o/kk283NR9JjNKWqm91Ld2Lb6zpRlDlnAuiMYTGhb1aGylLmTgP6vIOkj3bCIsO+HS+mI82Sf2gWX+MfbxunRTWtACEc0n8tDPtXwpbfu87o2qlDRufhDcxt2z5v4/dgIxt2s8wOSKcMB7BRtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-19 14:41 +0800, Yafang Shao wrote:
> Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
> to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
> taking the task's struct sched_cache_group *, but only updated the
> CONFIG_SCHED_CACHE definition and its caller: the stub in the
> !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
> 
> Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp to fix UAF")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Chen Yu <yu.c.chen@intel.com>


Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Please submit fixes like these separate from your series.

-- 
Gregory Price (Meta) <gourry@gourry.net>

