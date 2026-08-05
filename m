Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55AEC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BCA6B0096; Wed,  5 Aug 2026 10:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA316B0099; Wed,  5 Aug 2026 10:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB98E6B009B; Wed,  5 Aug 2026 10:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92BA46B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:14:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23C90404C1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:14:59 +0000 (UTC)
X-FDA: 85067412318.20.A577143
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id EAC5520009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:14:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=itSTciAc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SLaqhckWEc3QyNtTsd3YEo6O8h5dl7e0vqZloeFzhQ=;
	b=KhJjFO3CMfV6bPLf725YprR5mclqGmZ8zu2HyVtSR4x1aIvPRYySi+e6+NyM+nB0H8mrC+
	uKr+f9oiE3+OoImTwIR0gftJlfAoUdxm+n8MWrtFLMRaw82VmDb4zzDre+ZgRcFlgiRxZG
	GxPfUjL4qL0U+JAaM2wNqrKrNvnVA5k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=itSTciAc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939296;
	b=iNHSEf9RBkRHg02pemCblE2dycZ3rZQ3RIVd8HkahIaNfA/UuadLGoH2E1RFxNNAM0cp3A
	GknruIWpP6CNO2iwXE8Om+eWuRmFX9Y7SE8Rj1Kl49y1lLSKtLgZxFhe4iybtNeX8SkXyG
	RzZ/JiYczlvLW6qB7/u7FxpYOpN9/Hk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785939291; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=0SLaqhckWEc3QyNtTsd3YEo6O8h5dl7e0vqZloeFzhQ=;
	b=itSTciAcDLaY2UXYSLQxo9KWBRJIx9RB4MBqkcUXbgS48r+BuWL3A3LgxsoCnT9O1N3mLNGC7ni/N72EbUt59vHshMCs8+XVex66OyPy9ek6lVq3GMsPxQ7xzMp6Tv3YiT4FvlXaPeKp82NnCBTsZMK1kFFH1l+7maX53VFLR1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=48;SR=0;TI=SMTPD_---0X8RNYkg_1785939272;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X8RNYkg_1785939272 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 22:14:48 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@kernel.org>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@kernel.org>,  Mike
 Rapoport <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Michal Hocko <mhocko@suse.com>,  Trond Myklebust <trondmy@kernel.org>,
  Anna Schumaker <anna@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew
 Brost <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,
  Gregory Price <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  Steven Rostedt <rostedt@goodmis.org>,  Masami Hiramatsu
 <mhiramat@kernel.org>,  Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>,  Brendan Jackman <jackmanb@google.com>,
  Johannes Weiner <hannes@cmpxchg.org>,  David Rientjes
 <rientjes@google.com>,  Davidlohr Bueso <dave@stgolabs.net>,  Fan Ni
 <nifan.cxl@gmail.com>,  Frank van der Linden <fvdl@google.com>,  Jonathan
 Cameron <jic23@kernel.org>,  Raghavendra K T <rkodsara@amd.com>,  "Rao,
 Bharata Bhasker" <bharata@amd.com>,  SeongJae Park <sj@kernel.org>,  Wei
 Xu <weixugc@google.com>,  Xuezheng Chu <xuezhengchu@huawei.com>,  Yiannis
 Nikolakopoulos <yiannis@zptcorp.com>,  dimitrios@palyvos.net,  Ryan
 Roberts <ryan.roberts@arm.com>,  Huan Nguyen <nhuhuan@google.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-nfs@vger.kernel.org,  linux-trace-kernel@vger.kernel.org,  Alirad
 Malek <alirad.malek@zptcorp.com>
Subject: Re: [PATCH RFC v2 2/3] mm: new migrate_mode flag for async using
 non-temporal stores
In-Reply-To: <20260730-rfc-nt-demote-v2-2-452dbe3b5073@zptcorp.com> (Yiannis
	Nikolakopoulos's message of "Thu, 30 Jul 2026 17:02:58 +0200")
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
	<20260730-rfc-nt-demote-v2-2-452dbe3b5073@zptcorp.com>
Date: Wed, 05 Aug 2026 22:14:31 +0800
Message-ID: <87h5l88xiw.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EAC5520009
X-Stat-Signature: 5kgiba3zy7gk46qgdodp9z1ceq6at43q
X-Rspam-User: 
X-HE-Tag: 1785939294-517803
X-HE-Meta: U2FsdGVkX1+6pWsdjhnGhNHB1CumofU/FGEyH45SBpr3MSldr9IcQo4MIZrk9OMwMYLMgIMUloJIJico3BO6Cu9oMbsBZPR3vdBL34VpE7X8krWKReZmSqMsHyrcfR3YlMNRN8bM25YS6+CM1cY96Zqu73zRDJp2cFEYoiypWxHzE0My3VcWBw57fWFuVSINTaiHBfe8c4EMmZHowb+k2blO/bOwn4kKd1+JPg4M90wloTsixh5752RTmxKJzwbhq9h9fa4hChPWWocyudOLNh7XyX3zIPXjXXfAPkt2U/5mhsVqW66xKO2DC0dXbHepRZ1xhQHEuTSvkGv0whKRB0GvzEzeugChWGz6Ba2hv9YuZpl1TQ90pxzes77m9+gn1f9sAnJi90wldJEStElNa3r6245x1Ntf9U+pXXIBxRT4oONmIB/NyF4Ogtt6xac5Gc7zPumeLK8+BjCXxj6K6Bef/sY2ZeLstTg3dsX8TobOf7saTllAouDEUkJQsFyOvXv7OY8kTcxoCrR5FSCdOzj40y0ZlH6bmn5PIZz7b6Y3AjGQvBQ1faDpNZjnDI+86V6qS+0oDnKOARzx6IpQ26XIET2q9NKEa5ORQWtRmel032DXkVydfaz1AftJlj8zx5bDiTb3xhWfHYChu5tReSPCVbmpSXjLQjfnF4u3IWHXgRSjUGnm6FiRIqhzKx15v9fHJHUMRG8e2HUSR8CfNKm8i5kq0wtbIM7zDLBDDqStihCCavnXvvECc9mCD7AVpBKgoQuf/Nukl9i1rXkWNMqZUGc8SFI/PnMSIcHH04AbCiNLrfe6MIbUeAu4wh6NLdebWDFtRImfc3TuMcQy0WIL8xjXB5ten93tqonDa1m3uAFTh7QY2JBduCuTMikH/QZxeSY8XDNBpQWRV911XOhx/2h9anmTyWo/HnIK4PEOhZ0psiRKUayMjZPiZbZM2/1ObBL/4vCWAXvXHKZ
 5SznKP15
 McFHyc5QKs3/BVYIbhht/muwgZzPMNO+XHqc02WUsQGMoSwxsF98rHe3TUlo60xzMkIf280C1Ab4G/aEdc1z5QGu8j2AQtbgfHtA1KNxE9EakGX7kRmDhWr/TyawmlgXMJO3PK5I8kQNKanggqBREpfG9IvAJZ+25OFJlaQoHzSoeU1TABvgAfHG9HcotCFFjpWaCYHYTk1o+T3XVprwCjqfKhJhL09tl2vSxv5Mzpd7hsHMXNX7bVdNyKOlqdrSMHVU50eeYm72Qs+SljgS2vdsUKAbpuupwpcYdncOzvhIKomYbLyqlu8rzbfspVc3IBu0RjPLnRcponxw5gZyZGdZ5GKGHtWEz8We00FATUj0EohGOTV5lcXTbBVY/ys4t19jah9UwBfkSXVoOskatv4LZHd4aye+s3KKGpQ5S8gdOPPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com> writes:

[snip]

> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
> index 265c4328b36a..f7186e705b48 100644
> --- a/include/linux/migrate_mode.h
> +++ b/include/linux/migrate_mode.h
> @@ -3,6 +3,8 @@
>  #define MIGRATE_MODE_H_INCLUDED
>  /*
>   * MIGRATE_ASYNC means never block
> + * MIGRATE_ASYNC_NON_TEMPORAL_STORES means never block and use non-temporal
> + * stores if supported by the architecture
>   * MIGRATE_SYNC_LIGHT in the current implementation means to allow blocking
>   *	on most operations but not ->writepage as the potential stall time
>   *	is too significant
> @@ -10,10 +12,17 @@
>   */
>  enum migrate_mode {
>  	MIGRATE_ASYNC,
> +	MIGRATE_ASYNC_NON_TEMPORAL_STORES,
>  	MIGRATE_SYNC_LIGHT,
>  	MIGRATE_SYNC,
>  };

Is it better to turn migrate_mode parameter into migrate_flags?

---
Best Regards,
Huang, Ying

