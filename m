Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B63C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D956B0088; Tue, 22 Sep 2026 23:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEDD6B0092; Tue, 22 Sep 2026 23:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED216B0096; Tue, 22 Sep 2026 23:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32FA66B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:45:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23126C067D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:45:49 +0000 (UTC)
X-FDA: 85243638018.25.1B4CE8C
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf18.hostedemail.com (Postfix) with ESMTP id 55DC11C0007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:45:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eoIP2hD+;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790135147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoBrlOKKae5h9YawjwIgBVWbvwNAnx3gQiwI9yKP0ug=;
	b=NP6DvbOf5SVDfeoQNED9Rj2c7gxmbhjBHBx9e3QMSngj/Du1Eofl/F3Eew6LOuXF6iyT5m
	X+zIprNWiaJTx1X5xZhBY01JPp1kMQDCjy5NQ5TIfEJ6nhvq4TjVwURijw67z13wTPkaZZ
	c/ftOzQseJP7ejsSRc9YMBvcEgXtHSc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eoIP2hD+;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790135147;
	b=eeVDQq0tP55/14+7QohG2+KJvxSW7pYGGNVs0QO2iWZtho/U9KFndxksXi5YDB9nC/Iszd
	iqiO2KbPvBMjf/uO66hM7P+41YvPl1a3naqvvzLjc8pqvuxCfFEKqh0GDB7zJdcHUrNal2
	LhQGjnvVUsIH6/PwfL6yfdmBbrreDME=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109fafd6so45676885a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790135146; x=1790739946; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZoBrlOKKae5h9YawjwIgBVWbvwNAnx3gQiwI9yKP0ug=;
        b=eoIP2hD+NRzQ0Q/nCqID4RaO1sOOyHp6HUP7Ogr67NRXeC/LumzVhbi4FyMjBwaNgm
         tCT14ojtuGF5oGk3XpKq489JAFYyDphgNz/M8r7UmpyoNMb6hTai0uLMZFfC3nW+NGUc
         E80lRRsJDNhDVj/fbCp6DwZ2aQyZ+NrFuGXTb0RIAEZuyrySQFR5FPp7LdUI4MyM5/0z
         AiLuHdUVtJLKx3tp7x70aFgd2RuXQpcYsxXpLe4hF17NekmPCtW2Zk8SqfrN3DI/xynD
         wzfzDknXhrOdMfXz/qEloJCDwqdVyp4uekh85+uq8QMhwK1Cl6rkSK9311XxntVGRcNU
         f6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790135146; x=1790739946;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZoBrlOKKae5h9YawjwIgBVWbvwNAnx3gQiwI9yKP0ug=;
        b=BQGGwsCKrfeiqkrziKjawnGIHjtF8t7ELAXKKUpmH+AWErR1d4EDtP6bMVAmsfTg25
         4RagoD22MPMXxr+TRjk8AzkBy/RdYJtAELT5DrJz4LCE3KJ3FmZSHRybJKn+pm3NoMi2
         5j6hMSTYFrlaVOZqXNYGYksR2KfNtgCJV7JZKW6vO4cb6QAUKldYOl8aHyn7ewhjWiNO
         6SJiBWWEOekahG2W1Qcl9HANHvABOPiBHLhPqyReYslqSTLQageE3/0RmLks6PF/tIs4
         mXZ3Ph7VPqhMvRaYC2tjeqRvDgSp4QCsKmmRKqSRR5z/YyF9QTbzCJjid1EKhGBJD3rl
         5MLA==
X-Forwarded-Encrypted: i=1; AKwUvBzXghO7dQQYdNYuQtF8DNfvPefsXIWh1UZelXH199ofRJeLrIf/WgOJuboaAA73w3Jl0+3ZjUS+0A==@kvack.org
X-Gm-Message-State: AFuF++lTOVM9xkOsQQDX+O++Cg153irfZ3C9gNrR51N4itdpefT6x6Dh
	VJXSyprnayr65dftWkGEc7UeY8cVddaTE0PnKQZiZUYtZuLfQi16mXSTt5PpvktjDuE=
X-Gm-Gg: AYBFou37ZQFF31xC7CBI08brWiq8sf1hkkWspsDq+n5a/c1u2crFCurASCYoBjtwLlF
	LNUtAIZbx7aiJXMqLMzkWeLT81K1aIdUhQbUOWk1QyTMSEjoVz4WY9XkmSDxAJe9OvaV7Po22e9
	PruKsA+QPlkf+uKVv0BiiYh/dhc6iO++C86NHLfgTVenR7mzfyb0CrBxEVbEMKPeqvTBGdEZ8GY
	4bxVTRA5k8z7cVsRNInjXilTBZQBRZ4KwI4NQaJj1ZXC2s48Qe7JgzopQQQ952E71nbwdZVYt6T
	mhRmULe4IxFcXv7ruV+JEvAbMcXbZUKzJ+Yetk2KqDs+84POrlUa24swVGX3jr0MnhxjPiKVKNb
	kXafLjcW8mcJLAvEspkGtKXxv+1jTAr8x9XbHWf7ce9BAOyacTlk1w5FuCNU06ZHjSaw6tojbgo
	ccI75Od4GbIkvsFXWP1AKbnvvVbofpcfT+wcjPPPvWNeGmaDPjiAD/DU+yfLQEucHfb0O9h8Em2
	XOwdCl0SgQlnG1L1jaOBLJtwFfYiAqCqrQxvE7xMPxu0duOe5uieqg=
X-Received: by 2002:a05:620a:6f04:b0:93b:d79e:18f6 with SMTP id af79cd13be357-93c2521bb42mr221267385a.57.1790135146524;
        Tue, 22 Sep 2026 20:45:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248a1481sm136441685a.35.2026.09.22.20.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 20:45:46 -0700 (PDT)
Date: Tue, 22 Sep 2026 23:45:44 -0400
From: Gregory Price <gourry@gourry.net>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
Message-ID: <arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: zrsaknp3kqf9ymbwetjqwirhsikoigas
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55DC11C0007
X-HE-Tag: 1790135147-138510
X-HE-Meta: U2FsdGVkX19G2sh1xA0wtn/xyedqBXK1+HgAhm5iN8D1IWG0z4pJQQmi0XsHTb+7gXq36x8EacD8eO89MQlWIKtB/fjqsdzkllTLdf5tOVgOZars0Okjtmlwq7oJg0LBtV5vII01yyAWVbh5R4GIPbYDZiWG8TXMwKzaDO9wzDzODpR0HiOzxAQ71n1CBAYoIooJKAMldn8qXNuAOlZg+eJHn4wjCjovpVwZ9/GR6/D1L1479MSyC9FMS6EXlN3pUpCUG95Fflk0hej/vNQ3iIZWSjAUUQNlRLlSjmGLQkMSByhpLABK+3PCmmhl9nvC/ZYnWxVvjAxqlXTKXYm/JorA4SNNd7+uEbzsKAaxn0T0ifQdRwK1Rz6RgdPz7odwla5Io/TDvHEkv5HZvwFzY+9x8EqlKxTjYjYkde2a42ZtYGf9Kp5d8kNwmsxrwnJIZN3QSYFrShTTEPg57vOW+s+7DxbA/BZN9xv3O7uw4TFU8ZRrD56Hurb0uUkCcsdpa5HbkWyxoln/gN30Wek+0GiXTzwpYueiwzv8e7pfX8oZx5qYUVSjldgQZm6RDC+E3OQ0cZOI7x/ewIMSzHDidoEH80m7TlwDKP9BckMX1HqsSVaBxKWlCFnqEgUVO7prYh36YfrpViqMBIXnhZi82NrU4q/Psl8+FTpXySS2QzLVx8qySc4QS5ZZY3SvOZlmKtMor0Uwt8aonEGfYDJD1EjhmnJLBKZercrmJZJoboo/7fLZ2Cgfz4RtH7d81RfxwNAvjL9cYFa34iKtRGjjlr9slgeZ7kd7+jxW6kJeI4YsTa9qtBlelVg5psRWkHm05YpqzCCPcVbQRKtXFBT3jLFSTxQS/LYouYMg8x2f05GaRWltG5SNls5bztrOaOELefqbnWApDAa9REWWZuDuxAxdNudW81aNnR/Zsj6kGFzGZFqA82edkyVnMoDiK9J6JscEw3JWrDSymoKp1X1
 g1qaJ7Ru
 uAbLxG17U9039uDIaAh6bQ+dBbSdLJdcLfCvdKO2PBTF7LqpU1fdR7VHKztp8O40wQ2j0DSVlXSH7zyNM7i5LkKLMY0keKXyH06q+r3zgJnvqhsmWmMnOUdpwgDN2LIPHgwGo76JKAcqwTk32v61/wH19TWjHRl7zSuJg5ECzscQjvZYn4+6/JKwRuBx72rglnS/OuDUk4bmGqcZHTYTqsf9txMsDQsWXIR9IFD2XVpLExQYf4N4et9FNY4Z3p9nWjB8JHFX5okSuVH5C+n5Onv0SvkhBBY4zxH4UsNzUU79UxeU1fYhATSCRyKwKW1H4wLNLaaiUr/ONjB+v3kcDptrUMAZnVAo1e9yOmvvJB1VBw9vFaYYZ5VqXESOC56VlJqUL4UiFJc668L4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
> kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
> and is only used as the list_lru xarray index.  With
> cgroup.memory=nokmem the assignment never happens, so every memcg
> resolves to the per-node lists.  The next patch needs the index to
> work under nokmem as well, so drop the copy and use the memcg ID.
> 
> The ID works just as well as the copy did: root and NULL still
> return -1 and use the per-node lists, and the ID is only released
> after the list_lru reparenting, so a stale or recycled ID can never
> reach a live list_lru entry.
> 
> The early return of memcg_offline_kmem() under nokmem is dropped as
> well, so the reparenting also covers lrus that stay memcg aware
> without kmem accounting.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

This breaks an assert in memcg_struct_check - i think you want to drop
this line as well

---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5d7a26c91610..fcba9eb55659 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5886,8 +5886,6 @@ static void __init memcg_struct_check(void)
 				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 

