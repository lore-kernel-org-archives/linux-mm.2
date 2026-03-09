Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89365EA8542
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 03:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3C96B0089; Sun,  8 Mar 2026 23:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC536B008A; Sun,  8 Mar 2026 23:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D566B008C; Sun,  8 Mar 2026 23:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6B16B0089
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:31:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24AC0C3DBE
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:31:03 +0000 (UTC)
X-FDA: 84525098406.08.F600AC9
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 041A640004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:31:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1WPgWyD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773027061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGRzB9NB7RnJy1AFfNjO4UdJlA1IIFldq9U5XbxXvLE=;
	b=LOKaSbCVFy3WeDY6XjtwPr+eF1IGM8pASJ9LvssyHQ9bI7tv4E5pzxINYsbPCOpbYqnDL3
	0mSJQyIz/S3ZkAVbqgqesTJKKTRAirdHBiv18hen8Jc3tdxgAXPiZA25phgcZtaIXxVO54
	xASJUvpIoFNz/XdQDRBOWo6SigVM5NY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1WPgWyD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773027061; a=rsa-sha256;
	cv=none;
	b=hxXmw1WOFJkz2nKNrjmAMgAem+12hNucIfUiMAKyH0pb8LB0SfmtNOlCZTBssYAxMqeV5P
	gtlwe5k8nO+Mebo4fdMnmKEj/tt3fp5pXU3Mj880nRVagYWhqPctBQs1cy7BjJRlPhZbYx
	R1nyyNKFykc3c3646Xy6LqnLLcVeiCw=
Message-ID: <c64681a1-2069-421c-9e62-bb63e4ce261a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773027058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGRzB9NB7RnJy1AFfNjO4UdJlA1IIFldq9U5XbxXvLE=;
	b=I1WPgWyDe1PpSkWi58Zt5V7YwT8hbeXPtsYCQU2giIVSqguWg0dr5EDnvQX68WY0JDajo9
	tmo9uHiI36ZHcYV17iiu58tmXfGiZvnz/M6Mgeww97WrWDnV7hmN4VjOCNQ1+WVMItxj8U
	hawDYa8Qn46vurq+8oinWUsny/0xQRQ=
Date: Sun, 8 Mar 2026 20:30:47 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260308192438.1363382-1-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <20260308192438.1363382-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 041A640004
X-Stat-Signature: ymrhtkkm9ajx9d79tg85gj39uzha5pik
X-Rspam-User: 
X-HE-Tag: 1773027060-975185
X-HE-Meta: U2FsdGVkX19YBaAfW52XYAxxK8xuhmm+eCnEy05txr/O1qbae8qbnv6CvcJELpa5e+JuqUzjX96ii+azIfAtzc/b0+NksGSaeP5uBax9w7iU8kB2qBFIcsesW51vPnVZeY13sFZRvZto2eYvlm9QkGp5CL+SW+u7i16rndmGaVeZJZebnQ+Tr1pB0wM+rCWOl3IEFOOjS6BQyuwWGd7hrngbkz0Edi5K8cZxm4SgHfcECI2k72NRe6gUcpNYxEfPKZPNvKMusy5H3sgLuGLqEnxkA9n4DF5DRqLDi9qAx/WchRQeDMTE7KirfPE7n4UG+EalEUK/l8BoDuCVnh1v0G/pXoRqUlLH2BZofM1ENyOGbh4W6RIDHeOIVAtR4BBm2bPVg4NJwPa27XTRwlUjuXSCFXJpDsFPRJOxT6JIPrWKuoRbUP4zbZCkaTHek85njc6fMz1PJdeJccjpwnoTEIIEFoZdLkmDYchVUynYWlI30Njle4JMNNGce8egIbtf+Yg+aShLvCuN/PcAxe8hiPr/cq/D/W2XnLpWmsdRray/1OOAnzari17I0YFhCFOWGXl17qAgsYtlz2hJd0NnzHSR34riPHhGfxtZTyeZDKEYFg8cPt2vB1VYTyUrQ8cIpICJ11WZU395ESZdAznaIO5DKsFG2N0YKnTff+KyLqVSboTBe1NickV91excLwD9z6uV8Tijqwthxt3nbEjq/VTPt6D3LVHkP08oeIK4j7eQCp86CkcOtLRQKdIdkLyg+7UVCUBHhEnYOeX5cuQFAwOlYqFF8CSo2Az+pck8jnMhZmFuercOPdTtRm1cGtiGpkBN4PJyHZb5z7Ze9QDMzItotTcQkSRFW2YiH5hM+q+B9wST1vPHV43vLHmEWb2+2PYXeRJuLJmY28oDyIB1QW/jpX+yxs9jC7q9MGYilbep/N3Uc7I392b8Sm5tumnSTeu0T4NQV8KL+z5CBx4
 j2kVIQ2u
 3sHe6NAAbk3tAyKgdhpq31khvRD2W7TqHFlIMejvFfi3mGN/sjqn0DlJlcCnTCRg7usTS3nOXV5gklJA++TCtbgcQAnVAZqioeQHTCDX4dV7RSDV69pSDyWbycPsKYm6NharZOt3xAfxra8JKxS+i8ls1b7aA6vMr0ZXeJKjfO4nJWBa8rUljQdhR99aGvsEbYed/SJm1W6VthqO5uaIDrDnQzAKFBswrWpbLsnKj1i7cu/tZBJSDri1c8Xmwz29UfIbLLMW5TGaJQqmF+JA+71iiqhuK0E/RPB8H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/8/26 12:24 PM, Usama Arif wrote:
> On Fri,  6 Mar 2026 20:55:20 -0800 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:
[...]
>> +static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
>> +				  struct page *page, unsigned int order)
>> +{
>> +	int actual_nid = page_to_nid(page);
>> +	long nr_pages = 1L << order;
>> +	enum node_stat_item hit_idx;
>> +	struct mem_cgroup *memcg;
>> +	struct lruvec *lruvec;
>> +	bool is_hit;
>> +
>> +	if (!root_mem_cgroup || mem_cgroup_disabled())
>> +		return;
> 
> Hello JP!
> 
> The stats are exposed via /proc/vmstat and are guarded by CONFIG_NUMA, not
> CONFIG_MEMCG. Early returning overhere would make it inaccuate. Does
> it make sense to use mod_node_page_state if memcg is not available,
> so that these global counters work regardless of cgroup configuration.
>

Good call. I can instead do:

if (!mem_cgroup_disabled() && root_mem_cgroup) {
	struct mem_cgroup *memcg;
	struct lruvec *lruvec;
	/* use lruvec for updating stats */
} else {
	/* use node for updating stats */
}

This should also take care of the bot warning on mem_cgroup_from_task()
not being available.

