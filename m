Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DF5C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B3C6B0095; Mon,  7 Sep 2026 11:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BD16B0096; Mon,  7 Sep 2026 11:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B7A6B0098; Mon,  7 Sep 2026 11:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF986B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:42:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A97D1C09DA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:42:58 +0000 (UTC)
X-FDA: 85187384436.04.360996C
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id B0E1820006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:42:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=taa1k1SX;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788795776;
	b=wgun5rRfHzuCrUZEiR/O0yLh6zD+y5dMy4Zy6FQe5zAq/hAPCQ7MzuYAy5R1rXm+/boQZ2
	cM+yoSUKMaWJ3KkzYABsdBQUnCSf86Ko54Xc3wwa8YOn9WNOLS59aaHyzcJ0pdMNawvEWw
	HUoVWWS6RUFklPkswoDFIacDlFYMmCg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=taa1k1SX;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788795776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2bTzYuWDSR0jh+E6xDNAXwrxj96pyu9ESjj25Dc22Y=;
	b=nDBB0xq/Lhsj0Y17YungqXf2u/EaSzZmUFlEAYM/p2vFfHMsNLks6kzcs7QfqdV0qIRheR
	Z1HnfkwEJ3EJdji09PVCM3aNMrMOOP4jIt9GwM3/mBEaV8VzmR5VY2S4BmwXlEWC1UY4rO
	P+7OrGT1gyxlxraw1RFc6RwYjE63QPc=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-9104956083aso24897646d6.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788795776; x=1789400576; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K2bTzYuWDSR0jh+E6xDNAXwrxj96pyu9ESjj25Dc22Y=;
        b=taa1k1SXYMMAYjzh61OMig7weMxY4uVUNLiYD6k82mkAolua620qtpAYdSC/BVIKo4
         L86S0yByeOC/GkNoHO3lRRmzUFT+33art980hhRLnyYX50X7h3lwe0W2AYqf7bAMgIdO
         z+aWEMkhshz4FnDMbA//AEr7j/5q6xBduIkDsX++cXVUEes8mrm+Eykwded9BVNQwSh5
         GLiuuuD6M//MCHF++0el80kSQdF1I6fewBm/UdCpcF0C2fhLH82DEbow2gg7/CBxLW8i
         1alqPxovUB89RE5TJl6re+n3OHSxaAmbl2onA7dyKCSls/KCJiwP00wjVrMe0WGHDvA6
         Bs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788795776; x=1789400576;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K2bTzYuWDSR0jh+E6xDNAXwrxj96pyu9ESjj25Dc22Y=;
        b=IxvHJXJVYdBNZXWXzPgWu9N1YDHg6MXadn5l6f9Qi+4XIHCY2ClUE70xjMduaAIP30
         PG0NT0M0xtFfvJz2zv+In+CcbA0b5w+ZCRk075fidV3rPZkEb65D6QJrZkuhNZRNpb3z
         FAr25PUcWyne/oHpGQq8mf5PrfLupLsntwN00qyCLFsHPneSLPm4mzotTDjgJ6kQ24Zw
         FkLmxtu8nIG3ltpJzw8BSyuwSdT4RbAInzmUwKLtdiLKz8FeMfQLYGlRHYxaQhUYN58v
         QDUkCe+ouG+o320Lh38rr2xZ1L/TnbLSKvUEvcFP5V0xW8WAV9or0wgynvPZmShR4QgM
         si6g==
X-Forwarded-Encrypted: i=1; AKwUvBz2UksdN+RViRgVs9zYDfov4dm8UPul/+vD0ut1gYP4BV0C9Reom/QJu/6AgzeyhhmwbiXwZSkBJQ==@kvack.org
X-Gm-Message-State: AFuF++na4x4r+bqEWZr8uME2DYmm89fRUN3DggFFL4iTXmgLNZnQzS6V
	NJlzHEe+0rmI+nd5q6yfUjj+2C7b3+6hTNTB9ipjK9KfL0en3jzOC/41YhVrllLQ+Cc=
X-Gm-Gg: AYBFou3BBGt1VhudZBZmVlLA5xa7UYJ7PcDWRBNJQinislXgEEdua6hLR0PlqLrNZHV
	Kg4FFjeL7Hcwt9bbDapgr1BN+exl02NCq4gIBxkvsPsVLMn7HBmoTxHu+Fj+15Lf3KJC2XZqCLC
	7Ku9ygL8OxQzi5gdOsOCNmOc5+kmB3BeK4o/mcm83rmylZgTt0u2VmyJ0jfOpbFOXQnGxrohr0T
	wHm9J3b+YvMX4Xs616aZwoaDkVD6wnUrhzok60g9xryfIjr1lxYrWdG0asky8hgk89KFLZJ7up1
	FlkjUfQlfSlXA7OCtjipBbDIq9fDRkGdg5jq39774fClCvBXNbZMY3JvmJlec6vLPEGHwGukks8
	Jih0YGyEj1sshhsRl3pixF/+5mZJO4curnJqIIsqxcrk548dmXvmP/t2P6fX4EtsUEM/R4nb6mi
	NnUgH3jcAhER0TbsX8fCq/84dTmzVm8oqj0H2mKgesbNC5xg9y9/NxFKrjkFGfovFuiT6tEPAxB
	WLrBCR4Xmq2dIXQblHVu9BK3TVpvk9i0HgMqdwXq01P
X-Received: by 2002:a05:6214:ca4:b0:910:5235:14f1 with SMTP id 6a1803df08f44-910523515c6mr109464606d6.22.1788795775829;
        Mon, 07 Sep 2026 08:42:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406625d9sm93010046d6.20.2026.09.07.08.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:42:55 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:42:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>, SJ Park <sj@kernel.org>, 
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, tglx@kernel.org, 
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, 
	gnoack3000@gmail.com, ljs@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 2/8] mm/oom_kill: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap7bdHdjGgmIzi_P@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-3-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-3-ye.liu@linux.dev>
X-Rspam-User: 
X-Stat-Signature: taiegjokxonpt1d36fryotfz3iq89we4
X-Rspamd-Queue-Id: B0E1820006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788795776-110902
X-HE-Meta: U2FsdGVkX1/y9PhFH8ffdMYGSNLQwNVnq3lF7pmTWGAJrlP+PI3aJomZVdEpJvWaNNWzly3ZMWtRLYki6rLeOGVNFWIns1CMTBkbH9jhGLzl3ngh/zw+HrQUJrD+tczv+dPK17D8lLZz+aq1cbV80R8OAVe15guHS0xEIg05/cNC7Aj7y5ch1durY7OmUzDzsG5B8nszHZmHmoVax1DZyeLYQZ/TF1ahNMNMWWbJ2InWbPQ7oDWFip5BtRAuri66OPilFAx1jzoIdi7nyMzgGLdA9os+qGtvWPfE/zKYmwoW4WRO9d647s/JH1SxUWECpyF2+B0IG+hdv0xiFpi9RKEY3fHeIlWFVvtEYLXf2Zleyb7Eb2iB0AUZHc5/s2nYFXKjKhloyUs/SL48AkcNDMuARaTIkWf83t5F4ct9pVADMPx+v9wguOC8goUpi7dp8k7o/zNNc/rOGrcGbU/KVAcBbhAHzzpfMwZldsHOs0XULU+2vqG3nnYAi8lNny2/fvxuC4EwhDb3YbZEszvejY+QnXOsugi5PEqJfOSxgI+KK5X+0GSMZVWb6T2s+9v7k0lTYABFrjbxo/0Y0dPaxpoxQEu83jkFdGL2lH5Y4x8qcFCRsRfwXTS8xn7ZAGXp0R6wUJnS/DPbWmxvdeNz7EdU0yYqqzE2VsoYSJwQEM1SL0PA4HTWhlMIWeT4ux2c5h0HjhrZmoYJbvhkFdRZhSFgWHlGQo154C3WDOVKEoJjawAZ8eRLqS0ymq+3ZiXnjnxa4hTE33FPz32Tp/BCY8jc6kUUzpG32hhMF0Obvu9lIOKWtcMWEc+bkkuAaWH5unMROk4r3qfRWojAS+8XhIaqT5SkmlTGctn0yDOwLm42iZgOBMJWtlOmk0L1PBunwhvYhzhzmsvNzKmeUZ4vIq/Jlddu69F+h6DREga6MuLQIEwx73pCKRwRPNfBhzBMPLPFIRbX4NNsxRupMwq
 U74W/9tm
 HWrB3Zx/R2+XMwY48CEpxB0uAouSK3V0mCHlDQSQMXF9BgPHIu/5elbAOR9AlOeoI4Mh+F4830pDzGmos/1Dt3yrwFOgL4CoRUXIbYxawuwibonIYJBwNynNwSPg6gpJ5OaEV1EhFtFcW4orXyun+fXoL0EWSaBpY88zh3Uj+vQl4zxKGTsJmzSgmSYXVbzer7FouMyuGAGUOC1wir8LYUam+9tJTu35ClnQ2Ul97wkoJs1fgQ4rHzsW6AOxmL+CeMV4mtVCr00ZlXEJzdbIbico9w71H49MqNtZ3wycAihH1JU3HGexJZpPVgWAg2v4hmr9COgKjZ8qcWhSr7aIcY+Rxm3IqM3Hdxc1qwfteP/woxuoBIajIF0qNpI2c2dV7DCUGkDL3N4zZcN14PVZyWZheSboDMKeRZMIZp/jU3mLF0EXlLY7JJ5CLb5XdVJaXnpLpxBrKrG1Yiv0163ykItZ+JWQPRnqDUdm/vlfocl7AGnFsS3ethIVi+0+yBGo5WhL+fqx2CTrPC5zlN1W5qLMb5zGrPVfhXhrR39RzsoDhQ7qYHOLDK8Xzn+FYZtFxWbPQ09YhNsnh9qLqG1wtkyQ/tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:28PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs wrapping
> for_each_process()/for_each_thread() loops with for_each_process_rculock()
> and for_each_thread_rculock(), which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

