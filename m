Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E9EAC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C936B008C; Wed,  9 Sep 2026 12:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D196B0093; Wed,  9 Sep 2026 12:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5746B0096; Wed,  9 Sep 2026 12:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03D6E6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:12:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A66D14029D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:12:20 +0000 (UTC)
X-FDA: 85194716040.30.7D28A24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7992C000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:12:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nyx0WwC8;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HRifwmxeGvJe7kJs7f3I4hA30d5I/e+qt2AvENBJgw=;
	b=z4zy55a18U3SF2PmjivY0cTkj1K330Sq3XOocd4+895i57dhVONpe0n+gRR+Fdjw6ayfyt
	PDqNwww/sbOGFrDXetjl17F1QoU4DTpIQe0Yy9l1RLqD/Uc87BSZlrpz+ZJrvAoyqB5l6K
	TE1C3cIKb5pY/JjhwbF87if3MKVnYKM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nyx0WwC8;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970338;
	b=HM7EakkcUKCUaVeUM0RIt+9fCDKgDA47La9SJkJH/3p1c9d60sA/k2UY5GSjdKBPlE+2xZ
	nKsIEOovPaO4JP1OgXRSxAwtK0SO/XQ6JBcpuL77nyMeKdXt3HC5hYGbIbrm55qWKsPvac
	JkjTyNV5IRsRrKj42V0lehs0/UYWK24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FD83600CB;
	Wed,  9 Sep 2026 16:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A0E1F00A3A;
	Wed,  9 Sep 2026 16:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788970337;
	bh=/HRifwmxeGvJe7kJs7f3I4hA30d5I/e+qt2AvENBJgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nyx0WwC8UXgF34bKIGpOOMilC7CTqwRb74EUJPBwOD8zVZaOP/m+QoC1+1+QXBLt/
	 lTsBx6bAauoPLpTk4fvWWqGcLUFKrCg3CpY6RAd19V9JrL7mIL4Cc94wFPLTDfWLGO
	 lM/HydDSpOuuvNg6yX+FAHvfctaOsCOHCoLvs4xsWL8ydpc+CwzOAtBisx9yiDwZQM
	 /gNhRtIjpTbpgSN0MSdZpBFB8iIKswgR34L4IFdqxhL2p0oROblebe5FgYhaFL/oO+
	 ucJkyiVhZEOCzUcRGPLScUmvvJNGbpK5ozMotdNNzdvV/Vz4Gp4d54lmqJKrlJR+nW
	 WLBFC+AEdIHMg==
Message-ID: <5c856f40-35ef-49f1-9ecd-4266891bc0a3@kernel.org>
Date: Wed, 9 Sep 2026 18:11:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] mm/ksm: convert process iterator to
 for_each_process_rculock
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>,
 SJ Park <sj@kernel.org>, peterz@infradead.org, paulmck@kernel.org,
 mingo@redhat.com, rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net,
 oleg@redhat.com, tglx@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com,
 ljs@kernel.org, rientjes@google.com, shakeel.butt@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org,
 boqun@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, tony.luck@intel.com,
 reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev,
 mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com,
 mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
 babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-security-module@vger.kernel.org
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-4-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907081334.1152889-4-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7992C000E
X-Stat-Signature: tt5zffyb8df43kynbfaxywhbo5jm35c4
X-Rspam-User: 
X-HE-Tag: 1788970338-750598
X-HE-Meta: U2FsdGVkX1/7QYdzwpdrYO83VVdTqIYVdh2IVJFNqPo6pr+22k874cnfWBCYIdfFAozMAwnSihPwPmoh4OTPBEO360B8MjpmB7AZQS7P0i6e1t9Ie8bWwo6sIOajUxdHVB0Np+YkuBOx4Su32kR+zKP8coDqSEfGGKAvJgfJ1hzKGO1ly+smDNjSa9t49A7UBPEtmKGw26HKPk1j8irHGp+Kg95cqm+pp94UA+423FcWbEjsfey9E5TiJmPjV9MQt01QecxFt39lUz/SZxq5jl4IQXYxsHSxbnn1fsKsOpRahzHEiMq9wsCrOYK325iux6TuCCj29s84XzA3uwzLQoeZI62WnCLw6/BmX0wQFY62C3XwDNMUDV/rUa+OhfwE78YNPuDiJRfyP1yNcU4C5FEIRTPZlx514axlWkN/5xBNiMVT6F1dfKDoe9Bn5M1xrUt1uToVajVaLf8abZdGVjB8icd8ASr99+fA6OatzN4BCjlXaCAZ74v+7OYFZ36HYB6Zt3zar5sMPUG2Y9qVtCNUGo9ZnKvnXcpgnJqexHTz3CacsGEkXb6YwE57zSCHEPy6xtk7QyLMzUORPEq2tNGBLtekfsjy8bynBWmJTpnLXT1eChutPVEkfk6Y3KUxzS9syO+3BytwbRtfEvPVF6xKGpKK2b4esfADe3S5gfv9uvp49MMhEMEXg53RdeyWQpWJnzgqRptROT/WUk32KXmI7Jp6VmBuuaYI9eegc7PkXc1VQgtx/HCfLf2QBmdUC+pzhrgOEhfmm7fOPR50As9xrXdbUzucKGYNrD51Eet5wby30xb9Jhme5Zi+Bzrgtka4Q4vihGb6//t2R5sQgF19rKJC9GZ4hH3u+rMLQt5phaD9pDY3HgIiZZZcsQc3Yo5zpbRGt0e2r4Ohd5vpadrT/FcJbyWkt3vyuyPIjkH7/fWUHxzrc6QhYE/jh8QSsd/B4s7Mu0fuxJbOBp/
 2fQu7/yd
 /7x49zuobxW2Cq2gleT+mTjmAo4mz6/H649VCD3Gfhsh6N4a7+xWuPCxZzShmM5ncBFJQSoLgN5inPE0iCb6t0RK7Rb+UEefmXx+QzCtgM+Z9XekKw4SpixNeNiXaenvkVvr0JYPbnznDpvGAGJiEQ2MWhN6O209GZEFUval6ht+SAF27BwAcZErbiEwiJ5k5N97xvXzJuuo2obymsrw+HFYDY8yiWPhp7BhaicqFg2Cb+E6mRFB4mUXlmi8fQCUSSESr3UZEPOfK4DzHVTsM5RepHDcjKbBnYIgFpw073nzF8wvpvt0Q129mq7b+M50UUnmSHaYHy42gv99nVsma4B6jgafzhYeE3Q3fH2r7+6o3gCMVOkFNu/pYV+5blEZoDEu2lSflkilxHbk+2Xgh8sPn2W9XKTJrSRiZp0LkBFmR+gRGSLYeUJ8CfGyFnb3khU8L2D9LN8PRBq2nM664IgMEkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 10:13, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in mm/ksm.c with for_each_process_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

