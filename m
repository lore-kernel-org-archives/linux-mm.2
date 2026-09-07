Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D279C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 22:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04796B008C; Mon,  7 Sep 2026 18:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC306B0092; Mon,  7 Sep 2026 18:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF47C6B0093; Mon,  7 Sep 2026 18:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB6E96B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:27:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A519A44E7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:27:21 +0000 (UTC)
X-FDA: 85188403482.05.F6AE95A
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 666ADC0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:27:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sNPjK+jv;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788820039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voF+0uPdvqMWSZZsE3DB359nSHA2KdFl0fM0Svv/P2k=;
	b=5RuP+fQgUAzTm7c3zCBDKvarDXga7tv4ehUE7UI4/Flz5hi8vrRWRdECyaLwdWL27oIOV7
	gQmgx66w12twETIr3ZcPQjnX6+i+hmE9sm+5EgiyNQ/3vMDH4J54Y2POLDc7lRM5NRLGKF
	BIhazgatTaJj5mIVPBR/U4vPZscjuJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sNPjK+jv;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788820039;
	b=AA2nyvbqDmwFP7PoqvJixwmQQQYUvGQLdTD/J40Ojr+l64uG4ppq77ryXkly13cH6ts5U5
	3P37H9wojk76MK10aN812tJO8OO9sl1oJr2/jNXEXROHOunNWU9MBq2clXenzIG/vEhrWY
	WL5v7aZ99P6MF1kBPXkJ1fnCjyleCYA=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c0c45c580so43905341cf.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 15:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788820038; x=1789424838; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=voF+0uPdvqMWSZZsE3DB359nSHA2KdFl0fM0Svv/P2k=;
        b=sNPjK+jvz/K/sCyyrGbRUF+bmqP1yP4BSViUqaQSFkr77HPnRU0AKSvhWEogMj1NrU
         M4fMva+mnEjHgt3F0Aq2fzy8QgNiSIg/PcVUa/XyDc2v/DUAaMIGk/2JpICVMFHg3mSf
         hvlCapP9gP85SPngfyazEVLnnFYVJxuJKkziZYSTn+Zk36IZdZhmf9yz2iUdbZU28P2+
         vjcXkqjQIj8z5L2DMgRYqN+OirApTn+Yro0fM9+GKQRyobILYxpX+0nSo3DvkEY6BuB/
         K/fSFlpsIfz1uYt8eV9PRlFVtySRGBQXcTlZ4LGAVNUWwFAZRkZLGTxgJJ7diGL48ASS
         YAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788820038; x=1789424838;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=voF+0uPdvqMWSZZsE3DB359nSHA2KdFl0fM0Svv/P2k=;
        b=bD/ETLmTeSI7vYknfoVk6CmMd6hf/qVCiPuNY2EvPwe9A7qmoflwRSC1TrGPOEGaK5
         rlODF5UCzeo/zLMSJZBNXofbZnsXLeen5Ngg2OqGXl/Iv4YxIN6VidVD39wMx+k5XWpN
         rliNjvba+Nv34ZDpg/7m6C6m0LviXVduzngWJAjOCDWWiYVrjHk6y4Eh2Gf4B+f9bXOO
         fdinDujjgEfyTfdEM/LXw31jksBif3Owntfhl7OkSteFFPh0ZElWl5IH30s0EW+gEFDE
         OZ+9pLPzGx8ofgSN5IEzQ2Irc0YTekwSlXB8HU9FLnFLI+EXH64hKwEd8pYj5wQxN4hl
         RDuw==
X-Forwarded-Encrypted: i=1; AKwUvBys1yr8Hqpo42TSI9rr2+xAJszur4BKlNkOtE9xr1cHlkOtPvvjM+IVx8HX5HqWkjI2RQS1Uze7Sg==@kvack.org
X-Gm-Message-State: AFuF++nJToXbcr6V6iGuA8WDBCsOffKKKUwUpdl7Zyf8MNgeo1xqZPuk
	VczlF/CJH0PBZmjCtjTmM3USIv22OpwtMG4Sj6kWfbn2r6QZ/m/oV24R6K3KpEMdKW0=
X-Gm-Gg: AYBFou34Oj9nIw5iGR45RrcCg7hC35hdloeQm7t+QPf9vNsR7Fhsqfzy569aDCOaOVQ
	FAtSoasCRK9OMK26UUK+nPtwoSeZXHF2cyzZs/GapBMO4fwXk0+F85ZUBvMcozsBbfLhPXsVWSR
	4exZrtV+VKxnHRhyCP2jb/GFO4AjrOwvfVsEKHc8lhfUlPY2GzEePeoaFDXGO5MU7ZETnH+kms2
	ZWmEx6CAM2sR/0jCFsrvSfnvYQtvXoZSDbk+3Dq+/QHpRzvLJhN8ZxgOx+/QzywYXq7BnUVGff0
	pGFnKSdwhvi7tV/m8vkrjXYRbV9r6CoBxilSK0xsE1oaJe0cD+kZAb1tqdI+UCZovDjqkV2plje
	gWejdM+iyNvQtWrXQZiGQJoehkwIcI+xZomtcCZsNM3ebnYB2OAqLnNdrSX0BVuj5ykX5LlaFBj
	AjMQpE7Ba2B9peyzrLA95BYR6izcv07xzB3oGPNRnqtOCvOYUO3fyliburuKt+gcwcjdGtTtVvy
	xMZCMpWJ9trqzJ2UoGzuwOxWR9/g6fMndOkGudUfOcV
X-Received: by 2002:ac8:594c:0:b0:52f:b1b6:a4aa with SMTP id d75a77b69052e-530547fb02fmr300586681cf.4.1788820038503;
        Mon, 07 Sep 2026 15:27:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53080ce82aesm39676931cf.31.2026.09.07.15.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 15:27:18 -0700 (PDT)
Date: Mon, 7 Sep 2026 18:27:14 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, david@kernel.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org, 
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap83lNf0bUXX4ZS8@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
 <ap76-0-hN6CAcYXX@redhat.com>
 <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
 <ap8yoW37GY17pHYS@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap8yoW37GY17pHYS@redhat.com>
X-Stat-Signature: rqg74x1z4qb651nqpizit7g8m8f85qb3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 666ADC0003
X-Rspam-User: 
X-HE-Tag: 1788820039-425561
X-HE-Meta: U2FsdGVkX18cSOWRfhcyR/a06ystLDBgmJyuvDAliCM6bSan7y6NKqbybeAH6f3zU6NiPsv9WBsdtZmxnCBX33Bw3OUuEKKyRSHmhUPP1ULE1zHyKSVhrh8yVCv+rJHrvmcULo5/7SgXFDBAPHfzebbbgU8whHNh8jUx6NLHQg5MnPb6/zfFMxZ9pd/Q70uhqYf5yfew/VfRd3WgJfYfsz8iEVvt7/ubQkBkUx3xN2nvE/BMt4Pub82lpr8bwRjJN7rkhVbvpE1uOcuwcydp+mIsNLWsrsJT3STuh0CPgDU4OymyydDAUi3IOMnvSSJdZ2NzivggEP3RK3Z6IAQJ2KovO2etbd2CqXigEY4Mgp594KC2gP7Zo5lZ8gBeRhbv10ok7ZhtUZ7dt2eGzFoj2ESwyA65+IorIeNpmz26dWeX0yanw67vhOE3UepTJ+HbPwrwCrFfndoRDSg8R0Um8EjwqwjeuiJBUHuTL9Mnlr5iQ89qC1TUs+Dzy4i/WKkcRFor5jdisTh0Clbvk528q9yNIfg5Qmj125l0KKd/SahSmbrUUCKp+iQ7ORgsWDv3iHiwKX+OawP9edtNbJaE1EEq/H+fZdWNB0eIHevhTzex4xeOzouOKK3ZZ+xGW7hyn/iq1oVwgBrJ7SGQ2L4rA32opjT6OICS2MvnzFFaKI6oWjTL9saIsqW2b3iq7NcgwTEHNl1WqXMpjse0V6VeqskUYs8eQyulAs4kUtG2Xq39ZwJnDcinDS/pOs7xqEs4iW46dY9P3etGiQAoE9vXXgDCeLS7nt2bfgRjYfSDVC806DVlld0cN5hz1NIMWUwqb5LYJEuSBoTqvjFnf8ldaNcNo7mOGq9uy0l5ZIipSGYYUGblK3Sbvoolu7xVHCPpSQRVwPVi0cucASRj2XMSaBoF1CHSLMtehHsFc3i4dkt9tyXKsVp1xt638WUJuA1DaadevcTQbnwMCzRAfss
 JSZbD+Hg
 jyxklcYeUWVoA1YWDRZ35sXDD9yMkq9bQK9kFNYDT9QFWpPOl0U44s8psvPBSt9sZeoTLxoVQP9hpXayKcn7g4RWNub41iIsgp8Vkg1B2iv7pidnW5Nly5KM3e/gkSzqVOA9L3g5nhjSw/pQZb6C2odACmovmf+iIyxkLVmuAax/+eZaVP6VXlFzLPKKBzGugpcQDnmXSAUKVWsOWZQWm5noEmKA/RIXDhFfzVeMycVExDy9kkmkyobVgGezEDf38iu0u5DqqztYoA9S7KjSsKPLRQsZpHS5LPot4X495MtsglSMEgoPG1JoGHa8Pt+BzJprGfy3clkRL3rOOJyI2DufjCSSkefNDDxtDrpSVhBQMI4P8+QyF2e5HBpyLPJKzUTPsEXMSIcSrcPKf3oNNyPduCVBEDm3A08UP7uOCp9ccM4uVRvqGHWqZ78fqDlnHxQ3j16KhiNYRa/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 11:54:41PM +0200, Oleg Nesterov wrote:
> >
> > This might be my - admittedly shallow - understanding of scoped_guard,
> > but does scoped guard handle goto correctly?
> 
> Yes, it does,
> 
> > and why it's generally discouraged to mix cleanup.h and goto.
> 
> Hmm, why? I didn't know...
> 

one of the reasons to use cleanup.h it is to eliminate the "goto
for exit cleanup" mechanism in the first place (says so in the first
paragraph of cleanup.h).

Later in the header is explicit says don't mix:
 
 * Lastly, given that the benefit of cleanup helpers is removal of
 * "goto", and that the "goto" statement can jump between scopes, the
 * expectation is that usage of "goto" and cleanup helpers is never
 * mixed in the same function. I.e. for a given routine, convert all
 * resources that need a "goto" cleanup to scope-based cleanup, or
 * convert none of them.

This particular patch only does a partial conversion - so it's a
bit of an anti-pattern.

Reading up on scoped_guard a bit more it seems you're right it handles
the issue to jump-out, but i can see why cleanup.h says "don't do that"
because it's confusing to look at / hard to reason about.

~Gregory

