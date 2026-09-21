Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C230DC982F0
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A386B00A2; Mon, 21 Sep 2026 16:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA40B6B00A4; Mon, 21 Sep 2026 16:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C448A6B00A5; Mon, 21 Sep 2026 16:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D16B6B00A2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F1AC402B4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:08 +0000 (UTC)
X-FDA: 85238835696.30.CCA3D52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id CEEBC120009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kfra9Kou;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSjpsnGB6PkMlYt3gFNBn+l9/iXfVXQ9UfiCD3HwhPU=;
	b=a2Tsx02ToWEcnTq0Eyccxr6MBXpyh7hPV3elwbXKw54AFZhS6XqEocO6Tk2Jj87jjjfMqH
	MqknES3LTUeDeWCo0fj4N7XLbHlD9NDhkXEpR0Vxd+Cv3UewTAPOeYs2QazXy3aqTKqWL6
	xxxjM6YHWBii+1Rs5u35QKrxe+bG1pA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kfra9Kou;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020806;
	b=jpd+GXgGk7Dvrp+lGRiwTDdp8v5chLluS+avCa0AHix6GPtAQtTYGIuvV/A1IHT4NdyNs5
	RA+cPWxTOw6bIbj6FGg0nZl2A/kFzlDYraiyGrl46L1klfhdLchu83N84ZkTZBIxGVUCgC
	87f6+KGJgy/DYFtWtKVjLIglvWCBbZw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790020805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kSjpsnGB6PkMlYt3gFNBn+l9/iXfVXQ9UfiCD3HwhPU=;
	b=Kfra9Kou/Tt0xpBjCrGgguZvZY03F1QCz0nURF7x4FohnajY8lSL5OQv6fJ7WG2vO6O0G2
	+3DDqzGGyDsyoRyuXdWn6aJ0qonJef1NyZsO/DwBGhTC3OZxz0cFa8tsYxBpWy7fbQ/6Of
	mF2KN2AurXo8fzPVwe+mZI3yWM2YGB0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-399-3P7zOuZ7Mgejg7s2FjXuEg-1; Mon,
 21 Sep 2026 16:00:01 -0400
X-MC-Unique: 3P7zOuZ7Mgejg7s2FjXuEg-1
X-Mimecast-MFC-AGG-ID: 3P7zOuZ7Mgejg7s2FjXuEg_1790020796
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 419671933E1D;
	Mon, 21 Sep 2026 19:59:55 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D76DF1800361;
	Mon, 21 Sep 2026 19:59:38 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 21:59:54 +0200 (CEST)
Date: Mon, 21 Sep 2026 21:59:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>, Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com,
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net,
	tglx@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	rafael@kernel.org, gnoack3000@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org,
	frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org,
	pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com
Subject: Re: [PATCH v4 03/15] mm/ksm: convert process iterator to
 for_each_process_rculock
Message-ID: <arGMqePU2L4q33o_@redhat.com>
References: <20260921092101.89285-1-ye.liu@linux.dev>
 <20260921092101.89285-4-ye.liu@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260921092101.89285-4-ye.liu@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X1Z0BNHAplmc9stVtl86XtjOxT_VAskL136KhoCscNM_1790020796
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEEBC120009
X-Stat-Signature: oesp16yq8rigqxh7r9fw8hp7j4wtsuqi
X-Rspam-User: 
X-HE-Tag: 1790020805-575346
X-HE-Meta: U2FsdGVkX1/rgq095JBJJ6oDnX/YvDfxwno8SqCA99+XCDNia9oNQihJ7dmlSgnOMAU8MpGCuSlBWA5uqkD8QbtYJSE+6l9hApNAlimpZ1ZHIUN7ZbgIuEDqiPAZwFbIxVIcKi9NpGBYK0Ie87OjnnnhVX14sRQPm4PskTAB8FKl9XKnI181tcafVVReKU/qc4DlX6PeLVnLrB10PHnsibDoxkpGeMTMgFHjzOXpgtrt7R56Qa5w4sZprVD3SvpFLOFOdLCJ26Q8mEj4STlafAHoiBn0EMgjxTWWhlQKQevFoOxOP7FRu97XRm99DTQY7LHtD3lcydgnvIDXD1F8e6bIhICTRKhbUooG7ahLlQpj+cb++p/jEqFcBNXQOKsZnEOlEG6GSffLuJgWhCzpfcg7Z5x3dUjWwy9gQ6yo3Cf6F3NmzNxlDg453FDYM5ZXqpbCdEotgeBgZgKL7khqSdoB+c1ZZ+uUSwm3uFWBDkWinEq3sjlAYJXzb1AUhxAo0XqOajACZyXEljWa1jswq4vu0PKMTRfnuG/Sh6ReP9jESeyzzqdDhJF4XKYnw36yqiwvV6cdg1jaRobYSiQADtjp7RdBxyW7DLDgygccrvgV45rLfmOjAe4XmPnUbxD4vsYdMS3RR/oZi2I4Ld9l57COee87BJo2ILmU57oufqGopW+iBHzwilKMmoIGjyf1h4FHbv0ZdYMrZIE7qeRjg/ZUG2s/M3dYKvTX9o13cL2PFAhh7yLXYmH9dH/zIjgLFcV+r4eGeMNy5EWdqVzWcy4SvchFs7dqtU/yWxlvFG9Q784tFaWQXDf7cY6hP1UY1+NTCB7sKc1VBmHfD/mIFotVugiCduag2fZZr1bR2ilRKE6D6J0a3APrK/0ohSYouREql/O715jIpIwn49OhZJopYEuxtLZCprI/iR1RLe+E/o9CAcBbK+pwgLa2yBNqUGFqQzpCO3tCGArNS2G
 cYjgzbmo
 amGcymrsfw17OvF6csXYaDa4NYERtSmlVnmf93DuITLe7TlKfEj1wHe/eSEN/6tnbw2LkyKeAG31AOv0mIG4Uct58BnEULIisisIgbXnf+/qOQFMVGxUbSndP674ib8l0IGE9aG3uXpPCuabPaR7zMZrmRiRWJRzLvwDh3F7Z+EPN6GUOSIbdi+AA4z2VQjl8RQUOsdIX58jV11rJULVHiecpCwYatauecZW+dA+zxye1qUjXkm/s4DkzEc6F+ysUO1qvM2RmYRSiY6Hs0R5Ioxy2YiPEFgcMctvOnFzk8yXx1JuSjLT3fDcy2Y19gC5TI+Q7XACodShT3TsZVr09SJCy6zBVBfLllAA9PhU02COrnkf91aon+lkQ5K9TCdWK+RgMnMTxoJeAFlrUj/9xYb/ZprymLKj1+7DYQgBWFjpUP6xEI/jWGqw3nxZpELUGdpAtkxxYs/35JATHeOwXbKD5KeCna3wr/jsCHXs9HWbTaDOt4D87IsiN4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Ye Liu wrote:
>
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3280,8 +3280,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  		struct anon_vma *av = rmap_item->anon_vma;
>  
>  		anon_vma_lock_read(av);
> -		rcu_read_lock();
> -		for_each_process(tsk) {
> +		for_each_process_rculock(tsk) {
>  			struct anon_vma_chain *vmac;
>  			const unsigned long addr = rmap_item->address & PAGE_MASK;
>  			const unsigned long index = rmap_item->linear_page_index;
> @@ -3298,7 +3297,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  				}
>  			}
>  		}
> -		rcu_read_unlock();

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


