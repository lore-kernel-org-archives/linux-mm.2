Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4184BFF8869
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672EA6B0088; Mon, 27 Apr 2026 09:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649F66B008A; Mon, 27 Apr 2026 09:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587916B008C; Mon, 27 Apr 2026 09:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 454076B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:09:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 450CE12028F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:08:36 +0000 (UTC)
X-FDA: 84704365032.04.01C0556
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 48110140018
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:08:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrvWPqMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777295314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO0NkqYdz+HGCxGQhCN6/GLW+DDfTqt7yREwIaevQGY=;
	b=gfjHCzfGf0e/OgolpL5Xszws0Fy4Mllk/lHySKkNnFu/xDlMCE13PENLoiTMy0h4iO2pQC
	zlkkh/mUqPUv5B3NRTAKXxToYMFHBkXs0WBD4BSiZhVfQv3jLYpEPmsQAk8uJEKWcTV0g0
	sDmolEZd/KbmKJ0ortWiBCAUXYhxv+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777295314; a=rsa-sha256;
	cv=none;
	b=LhZ7wXZOO2ckRl/x4nRTjdieSbv79amsMTm3BxfYwTFJPXGO2S07bc57/979pwwm2Kk4Ma
	FDlIhrY83z2B1kKaGzgXvDTSIK+mcA93WKHkNMm+P/FHN5wZdLWgiZPl+UTuG1GIu/XCNH
	TXZ9GX4OS3BnQh/QEsAOCIFCI0AIsiQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrvWPqMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28E12438D4;
	Mon, 27 Apr 2026 13:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0FFC19425;
	Mon, 27 Apr 2026 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777295313;
	bh=Zj8hZ7u33nqWt/MVqTENCSDelYZ/mQveeppH4hdN7H0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XrvWPqMCqxm5VmQ/G7JvRjOZ0pTxS0B2T7cuhva6/kiM6eo2MlZG1OXWA2SwBjxHI
	 AP9fIs17Emyal1DHLrPugMLT4XwLsfw8VNs1awLkhR9i8rTGzbaKuOExBVeXZt0DHj
	 e88hH2zU0DQvICu6o3hSnISwB52h7pJvdGCVHJ7i1C8BJdTN8uQx0Lac8OQ8YdneXq
	 WfdAj2/x4AN4PvcGovZmtl7iZQF0FNeg1SoKXbc7o3PmR7TV9peXCZIra40FXRKeea
	 cMp4oa1HT8mbOBL0GDP2v4d+P2hStoo5+4YuhsA3u8ZjrwXqAimSWj4TjILyTZ493W
	 w0tg+xesQM7Gw==
Message-ID: <9ee16679-969d-460b-af4a-9ad5a6a1ebcf@kernel.org>
Date: Mon, 27 Apr 2026 15:08:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416091022.36823-5-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48110140018
X-Stat-Signature: gucgs1jae6yj8snrsqksbtw4bj575eo5
X-Rspam-User: 
X-HE-Tag: 1777295314-63267
X-HE-Meta: U2FsdGVkX19n1kF8xae52Lq/957Sezehl3QONPdus3bDgVjlF/9iJgi+6JPBLJHFG7317kIu5hJeoPal+PcaRZOzY1LuRTj4DB75uVXzv6+sYsBfR+0NrRj8xvMYlfQSM+pGo8g4M9uGTHpE85jF18/L4d+RF+Gq0vm2O5RNGWpby3zRZXcQezhVllaM7l/0lhy9TtjI5vzaK4bP2kcIUEhMsN8AmGqQZ3RSenzsXUjNpvJ04e9sJagjvhJdsUIz/49miLkiOqyRvaE58AOIW94WK/zYaLVeHpClYpq+5C5rc3vUvpcsYN029XG9cSl2c5JSPekuKk7pWGLFcxXUrTS7C+bjZsu6KGCqJVDx6dmzVLaJgV7LftIUi5D0X7SnvhP4EPaf8BW8Bh77VKIA7E35HAzfs9PGg9QzjOCOMnjpHgRCrXQ8rNEN5pzB+Y/UzbJgWipKobkB7a2/gATKbF+wg1FT+Lf9n93G7kqwAvew4y8nROA6AdQLtcup/HfIDF4kON7qTbCbk+pCIsOA8n2rUy/zAJXAP4LAcZb4zNZtD/jNlGjfY4z+IGjPsCPYcxkJKn935N7ZaW50eMylukK3nyz2TG1G0aYzKQoYj5K8ywDfPr7oeW0i/ylXSB4d3XseGixAxnN0kIWXco+XwGbHcY97mdfTTjp9i9zqXrD/K450meSlXclXshbSUaVDWhB3QVgFoW3Yf3qYUZt/m5kNkQktDCelKq0qa+6loSvtPOYPg0GzD/ePhLSUeTRZJP5TfTHTJUt7MzBWHk7jCaA36f4bt/i7Ufos5SnXZuqnhwDOMppgK8tXd3Bytr1vE2sa2maqlJ0NreKTlyyVDEMJ+QUC8ZmrS07uv8E1yLK+1b6pgG4sc8MU7d9Gy8FAS2Dwoa/cRGTeAcOTFV8zulzm1G302lyseruNuN+2a9QwOsJZE13e+F1siCObbmoPZVmNkWa0dGKQSRC5MAw
 UQQaQxkE
 lCr39/YuxzLzC3yhEjl2i3BimJVaSW7uVu4YPr+Bs79rPuPP8eTbxndbF9TkvAK6GN8mY14ZEFQYWl5rUO/BkwUO1Cptv3dqFe/zipQZLPsl+DaISOJhXBd+nYr/OsH65paOQEfsIKWq2hNgLFAJOllX92yBuAfhk4UlojcVddwJgYVlB7hdeGSLpvR+t4w+hfKDDw7E2XQTp8QvZSrOCxmDev03Xl5xk8jHN6y2LVAUsZ42/aeiWIslaTq2RtcDCb29VH83TrDxSzn6y9po5HfGeuMFkMu0txyFk1SQQ+ujdUzqZJkd4iCBCyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> +#ifndef CONFIG_KVFREE_RCU_BATCHED
> +void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin)
> +{
> +	if (!allow_spin) {
> +		struct kfree_rcu_cpu *krcp;
> +
> +		guard(preempt)();
> +
> +		krcp = this_cpu_ptr(&krc);
> +		if (llist_add((struct llist_node *)head, &krcp->defer_head))
> +			irq_work_queue(&krcp->defer_free);
> +		return;
> +	}
> +

Given "allow_spin" is compile-time constant, it would make more sense to
have different functions for each variant rather than calling a common one
with the extra param?

>  	if (head) {
>  		kasan_record_aux_stack(ptr);
>  		call_rcu(head, kvfree_rcu_cb);

