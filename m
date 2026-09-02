Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA86C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1C06B0088; Wed,  2 Sep 2026 02:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872F76B008A; Wed,  2 Sep 2026 02:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760C86B008C; Wed,  2 Sep 2026 02:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8FF6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:43:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE397A077B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:43:24 +0000 (UTC)
X-FDA: 85167880728.20.E34569B
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf27.hostedemail.com (Postfix) with ESMTP id C65854000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:43:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788331402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9iRZSOl8Tt/Kh07e/86WqYizMIyCf13BvOcPpY5xIU=;
	b=dzOCWqWHyt4eccaKPBtl66hjTnXwnHCfxW8tTsm4p2PsP6rvqssWQx8tz+pkYeqlvfZpGb
	zE95PHm2Ze8zVmseqaItvhSj78wFCwY2fzYm1PfnEzq8GLFmAsLq5EgMuQoObtMacfW3DI
	Khf7QFjHp681tI0/rR/PNgsHFQLoTEE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788331402;
	b=B6j85cV+I8Wo09hx0vfaM3I9/CWelFFyLlgwB0w3BSxiQthHgOUzAJ8/2oKsYi9mXLItuB
	0JLh0p/VogBkUs1zlEdF5fweL8wI5EcJBM2aXD0DYbkrlTKGkxvAe5FEs2YBk6mLLzOlIq
	2jYNQFCmQKPMbj3qNhkvVFs1D8AsVgQ=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZY8K4nwCz3kRHS;
	Wed,  2 Sep 2026 14:43:13 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZY8J0t11zB2MsD;
	Wed,  2 Sep 2026 14:43:12 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 9BC1936F1F84;
	Wed,  2 Sep 2026 14:39:19 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 2 Sep
 2026 14:43:12 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Wed, 2 Sep 2026 14:43:12 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>, Dietmar Eggemann
	<dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall
	<bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
	<vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, Phil Auld <pauld@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "jianyong.wu@outlook.com"
	<jianyong.wu@outlook.com>, Yuan Zhong <zhongyuan@hygon.cn>, Huangsj
	<huangsj@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>, Zhiwei Ying
	<yingzhiwei@hygon.cn>, "justin.he@arm.com" <justin.he@arm.com>
Subject: RE: [RFC PATCH v2 17/23] sched/fair: Fine-granularity NUMA balancing
Thread-Topic: [RFC PATCH v2 17/23] sched/fair: Fine-granularity NUMA balancing
Thread-Index: AQHdNpKMDbSLcq9Yek+pOPkvBmkkCba5LN8AgAGoa8A=
Date: Wed, 2 Sep 2026 06:43:12 +0000
Message-ID: <cad0ece3700c4ff894c1d6d26fa24a77@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260828020731.785556-1-wujianyong@hygon.cn>
 <20260901124736.GI776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901124736.GI776954@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: j7j8qftx77zufjk59p1ymaqgieutfgo5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C65854000D
X-Rspam-User: 
X-HE-Tag: 1788331400-36242
X-HE-Meta: U2FsdGVkX1+USAWE9RJA+w0kG7FnnSiImgIneG/BUVd1VNAYV7c+yQEcT2Xy1I/4cI7o1uAbBBAWtLVLMak1PNYCe84RclRoyZsJmfpo9imO3K7ms+76yhW9yUKti5ED0/Wf0ME1cou00KrmTV5uGJlX4LyXVQgkQJyfshR55D2dqWySsRHT+O7bv/Lul+aoxa/MEypyZk2aQ08HUFr0FPtSZFvHesbviRepDQar/qCztQYWW9YW3gPm3OJsSt68d3NrRvcC/5Gan0aJ9wgU/pm7xzrY+LSGTdumr52aGOucyn5/XxOKVtS2Y+vWct/lrYD7uJGUQTM3gL4aFJY47hi7PSxe01Efm4MH5fmJIdnYJWmTpZ0vHEiTiR1L7KxTa/U3ZjII2cnhIHfVcW+R9mSbqGQlI1jX411FcRqTT6BfvmkiN4S/iTBgZPSPE26DNG2G19+5xgUU4WGHi92qZCpIbF/yBC3to/uujF9Ii0bnHWkszwfg2Lf6OmMQWRoZo4/Fx8Djgyhbv0wN5WO8UplBPRGW1C/U9wzNism+vTef3Fh7O0qujp8pBnPWPggHfLJdwyBZj0emxy3UXlIXdyTuQEV/mUmrtgXsMhv8FqJ8vdlmqvPdd/CodJ0tLOKGoDhUK0iSxLhaKvWGl1N0iRZOcJOecRXp/XqLWVqjH8ya22IukgabekD01KRjkAxb8pgvrgOmoDhxDoFEok/kjSnJaUTFr5awj2LwCLEIdkbU69un37eyDZ9i5RDyzCXNFgfyImNYKdqkjsFB+f/4wAzrzrxlG/tFlqu1r/56ricT+lVnZhpf+m8uihXIs4oHk6JEteBwxQErGA+7x4j2ukjrni7u3v0QnxjnEJmMTYqwwhgNVtkWRlfBjLbrhyEmdYABsV/qh3ibf4RHFL2AFmNMrAkjOf7mPyqqByHZGdFGLLmiF4VFgD1Jqc/Hb+u47zNIAQGgfEm8E+lShpl
 TPB++WOP
 jPoirlQPWB9dKfvJPVbTRsAmtYzoQHTInWf8O81Ry+yHA5A+SoynvBnMW7GDK+aWB9Vk5eSNO4XcDkIhMgk0eFgx/0pQ+9gt8v5hw6Y6acjz4f7x9LHWP0WCBy5caFxYfzn3dAQoG1m4SlKcYNrctw6/pkfYzhI/ucFwlKUKqqZbzADDQwga87uERw6mhMnc7+gnVDfLSAkU6894xctYAAsYfDU8VpBdmz8ThBk89012jY0h1pNCsJ4O/lPNXD91a32IdHuM+c5PvW9ztOOoNtCtgSZb+sUcik1QSJharJ64BbJs8Ha3Z2tyZC+CrYqh8XjojcG80JELVVD135sttH7SnKF/LVTycHFrw/TOaXzpGobT+/kvQ7HLA7CIbHUXIQcphiWoN8Yper1SNKatKstWn6+/iPVMg6+FRneCGP6vqJt3iSFco8GeihFO1+4YgpcFpXz4jrNQVeelc4oYI9Hk7/9iH7ddQlkjZUX0h+jIES69l/SLtHRl4Tq/G6lCH9fJ/iTOtxffZBYWeWj6vuOoOBkDDXS8+OevrpiVC10QZ4BGI3r/yViYdh9jx9MdPz5UwdQbmY4FbDN6pkyMaE9TPACMRDYDCjYYOvXhQ1tgcOJY6iMh1PahIuTOZFXxoaI5mMee56hFJhVotYrLgOkaCOwDnTAGK3ydjvJiNAKBnvefBOqKnfgwxGuuGo8x9fuxPqRrztf0dS/KA6ghbP1Xo0qU6OSBjETiE/1R3TJwHehwyQzMz/25noBuoj/oHAGKiMzwUFRlDIdZudnMfZ6i68chXDEx19aHg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 8:48 PM
> To: Jianyong Wu <wujianyong@hygon.cn>
> Cc: Ingo Molnar <mingo@redhat.com>; Juri Lelli <juri.lelli@redhat.com>;
> Vincent Guittot <vincent.guittot@linaro.org>; Chen Yu
> <yu.c.chen@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Dietmar
> Eggemann <dietmar.eggemann@arm.com>; Steven Rostedt
> <rostedt@goodmis.org>; Ben Segall <bsegall@google.com>; Mel Gorman
> <mgorman@suse.de>; Valentin Schneider <vschneid@redhat.com>; K
> Prateek Nayak <kprateek.nayak@amd.com>; Shrikanth Hegde
> <sshegde@linux.ibm.com>; Phil Auld <pauld@redhat.com>; Andrew
> Morton <akpm@linux-foundation.org>; David Hildenbrand
> <david@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> jianyong.wu@outlook.com; Yuan Zhong <zhongyuan@hygon.cn>; Huangsj
> <huangsj@hygon.cn>; Fengyu Wang <wangfengyu@hygon.cn>; Zhiwei Ying
> <yingzhiwei@hygon.cn>; justin.he@arm.com
> Subject: Re: [RFC PATCH v2 17/23] sched/fair: Fine-granularity NUMA
> balancing
>=20
> On Fri, Aug 28, 2026 at 10:07:31AM +0800, Jianyong Wu wrote:
> > NUMA balancing currently consists of two coupled components:
> > task migration and page migration. These two mechanisms work in
> tandem.
> > However, task migration may conflict with other subsystems such as CAS,
> > which aggregates tasks solely via task migration. Conflicts arise when
> > both CAS and NUMA balancing are enabled simultaneously.
> >
> > This patch addresses the problem by introducing a fine-grained NUMA
> > balancing mechanism, allowing task migration and page migration to
> > be enabled or disabled independently.
>=20
> Sorry, but this doesn't make sense.
>=20
> At every point NUMA migration should take precedence over LLC. The
> remote node penalty is much greater than the 'other' llc penalty.
>=20
> It is always beneficial to get tasks placed near the memory, and if
> tasks cannot be so moved, to move memory near to where the tasks are.
>=20
> As a secondary concern, it is beneficial to keep tasks constrained to a
> minimal set of LLCs inside this node.
>=20
> Disabling page-migration or numa task-migration separately completely
> wrecks things and you might as well just disable NUMA balancing.
>

Understood. My intention was to avoid conflicting task-migration decisions
between NUMA balancing and cache-aware scheduling. I agree that separating
NUMA task migration from page migration breaks the coordination between
task and memory placement. I will drop this patch.

I think patch 18, which folds the preferred nodes of all tasks in the
thread group into the scan range, may help mitigate the conflict between
CAS and NUMA balancing.

> Now, if the process spans multiple nodes we should go do the same again
> as this patch set does for llc, spread/interleave over the minimal set
> of nodes that do fit.

I think this patch set has the ability to spread threads into the minimal s=
et of LLCs
even when the tasks span multiple nodes. This is the main aim of this patch=
 set.

Thanks
Jianyong


