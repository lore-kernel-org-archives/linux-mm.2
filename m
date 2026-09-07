Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5274C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02BD6B00A0; Mon,  7 Sep 2026 11:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3556B00A1; Mon,  7 Sep 2026 11:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBEB6B00A2; Mon,  7 Sep 2026 11:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDCE6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:47:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86BBDA3BF5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:47:43 +0000 (UTC)
X-FDA: 85187396406.13.F38A0C1
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id BC1CE20003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:47:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qv4MGBq+;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQkY42FeJcZwapgA9K9xQ52KS/Gzc6p9wbLWVF1hJqQ=;
	b=RtTl2rGPM9TDoWVmuIc70+GsOdD2tWJOsXIFuG86FeuOjmfNjWQZJrNKuBw9+YwfO/DJJb
	oF4tTrq1i7wwz9Gg+78s1rkQr1vWg3KFh3G0XYwWTotpbCELrzbBm+Sdo4z5DKGUQHyIeC
	mY9o0kX/RVh49B9rpmontAR0EZcHtM8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qv4MGBq+;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796061;
	b=8Cwd0G9a++5SRKpBIuhyLjsqyNNnMq3d6BOGx20hZPwp/OaiYl9AwwfgPbfNkaX3uVBshp
	0BdGYabHyjgZcz+UvF68D/KZ8rRc4teLIlclLVX74VJBsDOdsT8M/TLwG4bA1yI9oImksz
	GbgNvNPO/fOJZhnZ6AJFKeG5R5wk85g=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9399d52b1efso77700285a.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788796061; x=1789400861; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RQkY42FeJcZwapgA9K9xQ52KS/Gzc6p9wbLWVF1hJqQ=;
        b=qv4MGBq+Bx/p8stxgRKazhOThnxwNbYJKvaTWYNrBKDLiaQnLjamazLvLR0TGvsGT6
         Ifwha0vn/H8Y/AT4XMiuRjqrei7eKOrfWsCB8GNAzbJiwUgH57APjx7gGT3FngPqf+TV
         0a6OYKT3l2GHWVqjZrMIySCp44MlXkbhPy/1SmPLWWpLiEOoS3DhKNYq20In2WoCpuYx
         zZ0bkoSPDkXvCjAup2EqVjRpY/6iFL0NOScUymZi7dhOi8C5mO/W5dYyUWWT/HW0sp8+
         nafcQHBfrCDeQlBq3uE+85eivfsDoCcCk+hQ9baw+3i+VckXNfW16gOgijlBw/lRRz2h
         vc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796061; x=1789400861;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RQkY42FeJcZwapgA9K9xQ52KS/Gzc6p9wbLWVF1hJqQ=;
        b=o+i3Hyeh9FI6/x+PtUS9J4XEUd1DGVsUpvYiYAk3Y8zE2t06uvaFkH/x9gw/pPa4N9
         9K39iUWxNKx/hRrBx44AiOfAvMD+6iWolJIXW9YSqNBgFQqPuXOigc9kzL46yl/VdoTO
         IKZcITEPdnT/r8aar0AlDkgT2zxjr6Cfyl2eRifiBqiGQGnP/14mIzqzvv533ZI16YX0
         XDu8clJexNaX+ePRt7gnDwL4PzDMPt3rL1ZIC6k+PnhVUPEq0y7gn2VfWAFSijnkQ8dQ
         v9ZQKJPZapjMbpsqOM71C/M+P4cu8H3Uwuz/UfVnBe2EiHktk2SEXytMy7sgkrDkrlvC
         2u8g==
X-Forwarded-Encrypted: i=1; AKwUvBy/jwPqP8GfZgrVhNUjYYwnfH4irk39woe8Ddw8RdfJ+lADQQ6KATVDn1pcBDPPqyMwV8DMGZylrA==@kvack.org
X-Gm-Message-State: AFuF++kgwiT+8o3rkI2g6KbdV60d895p1SHIOv8CMNgmEZoqw+Dh3RP4
	XGt/hXVJXm9cfgB4tL0e8duwFCR0Hu3OWD/0f6nuafP2HYlcuLZJyAGIwUi362g+Dwo=
X-Gm-Gg: AYBFou3zFdHPcKZpoNsY8cbgWTI4fsHD09cItwqOJ5zfw9MqkZu8l36SeAg24+SdvGQ
	UCvawW8xQeMHBXv/OIKtrQMPKgQ6k2ULBFyh+cY6fKPpmJhjY1iLnYVxINnB/lghzU6hHil4iD6
	aUz5Nc3u/FpKTrZC06vEc2yd3Fd/8rMvcXQdSZRyBppFkcR9JD+ml6Je+5P394fd+d4yMQtA3cU
	bWbH+mraaq0AlTjLDUuYdJdC5+ATVKwWKO0rGoufq6vc4Npz4p3VL0gDOABNGX+eNs01fQZ7aki
	ZMD8M/TSITkurIrqHdFIc5Gjx4OSNWv7qc0BCxQ1gJmSocJAkvO8E6qWpYIWMnA8W8GuJSCRcpC
	2VzOKwOHkda5CW67UWnusZtp09XnYYzM+FZjsoNF2P0KrUKemcx8enozdKQfTR+pf9USm537Vmr
	5rcuUC1JzmZpVKIwwfrTeYDpXDFiRnB2ZvUTNT8njE8gYTuoMOgafAM8LnI50T0hTzIdkkZZShZ
	Ab3VAH8q9cRE+q2kvHiz3cS2bgOKnTkP/gVY5RCCdib
X-Received: by 2002:a05:620a:6cc7:b0:939:6de7:8768 with SMTP id af79cd13be357-939805729bbmr2426484585a.47.1788796060831;
        Mon, 07 Sep 2026 08:47:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fbb70f1sm928876585a.40.2026.09.07.08.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:47:40 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:47:37 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, 
	tglx@kernel.org, david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	rafael@kernel.org, gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org, 
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, tony.luck@intel.com, 
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org, 
	pmladek@suse.com, longman@redhat.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, dietmar.eggemann@arm.com, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 7/8] lib: convert process iterator to
 for_each_process_rculock
Message-ID: <ap7ckXealr0JMfeN@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-8-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-8-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jad5oc6gq9qieqbwy38tmgtdcedmqi14
X-Rspamd-Queue-Id: BC1CE20003
X-HE-Tag: 1788796061-985425
X-HE-Meta: U2FsdGVkX19FNU2NuR+DuV75E2v+DasYKC2Vli3TLA8ozfvz0pS/sMVPiO92LCJ1UqfThzLLs3QCsYiknzneGI6F0H9tLuH4o/EuBplDPo2uo0qURFevaWF2983F0boTHuGxzfAc3S7wea9WnJPJXjdRwT8idZbydgh0Ujj53VcmNHHqOVpEkspoLObkIiY/xhqx/Hqee0ZJFgivYcfizxJSNVWpr+L5o31b3s8Jv2rF1SLbAIMKYfWLw7Q9EeHKag+vTha9vIXP7vhEebUliMxLtq6mshj4J+K7g6eNEkWpa/Tyuy+sGuWry85O7Erxre6P1zSaTLfnuh/iNd2Cv4frRABQDdMFP7FO8wd9JoN3HtkcJ+hjePp7Gy6cIG8xrcMbpK/aYDdk19ZY8P/zLGFpV3dVlBRlFR8OpkUU/rbcfteckLTVQ0TR7AADC6JI6EcFzRLSSZyOiCeZoLcN3uQhQu+GRR1++1S5CrN+7ld5I4epdbsPsTj8mJakvtzEGwOwi4VBhADg4lkOgtlBMc/yxxRnFhUenERNggGc7soC+n/qTl2Qk1atNi4IQSfOirZYo2qJnSFBqbGDtEHqT9JSDwrnSBzTWlvsdL3/YecaUW231HCEL61oi1AnAAjtHLTPIEUsbVQBPLFCWnJbWFnI/Nsvimjq/zemauA21jzdsAdGQ6umY76sg7KG0k9AtEqg6oZo4y+1ODbQeqKhJdsiAOuSLunq/dwn39Qo6wsxHMZCOOFpdlNgQ5OPEhY3o1a+QKhBbA891OJNzfay4/fQGqO03IQDrX0u9SwYmT1tf6FcaxwgCa3hKmXyHHEAMzVCy3liT3kJlDWZ6KzrCPCKSL0GHI8adjF2mnQHkPh4zYgYvn45pibKM5CB2XQrEH+B9vxHz2Y9GhPmeYO4sf0A20JYPW/M5ZHy3v9Oz5Jqe3DJUEDT9GXED7yQ7zVdOqHJ15Na0PBCtB88p6W
 T2fWaSGB
 dmiXGiC/3ciWgBJFznmktYGFUEm9Uc2lvN8nPJDTmkOaH2TcdJub+Nkg3au25zdifx/mO7+MdXjpllsg1Mprcf0ooRxl/QI5kw/Jg5p5fKkDIpHzRqxo8yEScx9eXNJE8AX1z2iUdRr4ILcQ3bHOBkBohVo7PUAIWMLIjz3nbUNFgibcDuWzwVlH/nI8ZySzGkfdjbSeZVYUvh/61BwJg/QZ2ODJS39XBbB8/BENJU0xWUh5kkkBswBohdTfg6378o5eC2rQpNxCCVh4CgBkrlroSgX+EL0crZWBeqkeph9fMr6FhVF67/enaSsV9lZY3Fwgea3I9U5nsoIeYSwF80uVXO7EYMoToiQF88FE+0S7J44dMyV6UnAKVhRHpqMyF+2pRYkCuI74oNbJ8HOfNoGHAF+UgsTY50/fofT6dYOYtTVNpj4ozgHX3hE1HUmvk89MpkWiZPF9bA8LGmfvHdTi1nmfriaWW9Ml0WNLoaxJWdW4asEJV0VHUkjlDhp47ybyjA8E0UjEcgGQUSkGW4QQTFzsCKdl/jL8DVndwlHPogkpW2VC04Bvf7pbRhIFJQyvd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:33PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in lib/ with for_each_process_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


