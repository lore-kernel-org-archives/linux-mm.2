Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785F3606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=bBXIOsup
Received: by kanga.kvack.org (Postfix)
	id 996566B00EF; Thu, 12 Nov 2026 10:28:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DBD6B05B0; Thu, 12 Nov 2026 10:28:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887666B05B1; Thu, 12 Nov 2026 10:28:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0FF6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:28:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09D85C0616
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:28:35 +0000 (UTC)
X-FDA: 85426848990.15.214AE3E
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id DBCE8C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:28:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bBXIOsup;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.161.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794497313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrQWj8i0KMpWLvGJmSZCRH/S1lTxVViz3a0mVq2HUbU=;
	b=JWgWV1kRIYGfFGm2ejicmgTxUB3gXkN3AIloQHKQXRvVRWHbPXnATBQU1IBTWXbZNhsglo
	xMJIbWWyREnb8KKNVANbn03z5WLD9TfSFr2jubzMjeIlJzDMa1V5jsK8uxdh5agZKYFz2M
	A2eVeec0SEbCgst+2dBSx72kZOMw+ek=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794497313;
	b=YyD/GY6f1eW8exXIyCibazmMhh+JONteQU6Dj07s2SmGDmhy+Eqz/sMJmuQJnaLGiLmeZl
	EgHSKrcqykTbOrdEif9NHuwsQDk8rcPxZtsTlswIynNuBxkPRpjkhDTrZvdHxVgZyI1JCG
	bKps1L+J0/RoWnwKne2+3DzDYaREVPY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bBXIOsup;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.161.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-702fd86d674so2264901eaf.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794497312; x=1795102112; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GrQWj8i0KMpWLvGJmSZCRH/S1lTxVViz3a0mVq2HUbU=;
        b=bBXIOsupQbv3Hu050tP/lWat+wiScOsAqq4zRl0SyQcW8m6R5fnCPEtK+dGqZuhoNa
         fI9YkF3FCNA5wn0n3OVfvIhIEL3CVQjrerf/TikKoFLJzjgSjcJsHp7rRu1JFI/aEegj
         HaaBG8Jtt1gYaWWCzZCg2+15eowlQ9adxq2uguN1zQebBi+nV+Q+ScZD30Ksvtm4FqWk
         lNbeK8QvMILlWu4JjiKSxYaL8Rfjkuf74ucQQh98VwXocpxdZWVUQaQaSvuuiwXWl3PO
         oKPJ2UK0z0wnaAcV1ZSWr+FErkZzRaX+pvZAbOtL9SZZNnSAMhASQSEc9SHaChHn8vzG
         QMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794497312; x=1795102112;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GrQWj8i0KMpWLvGJmSZCRH/S1lTxVViz3a0mVq2HUbU=;
        b=ZC0nPunet5fAPRFRdnvwJGotxt0v6Y4HDLTPdujzUqG/qM4RLm2MgreQtSF4H04CiY
         I6vlMq06K2eeHqov8bTQjm5UsAxyrFlORueS2xLtu0CRM78inHIXjRKdbr7rBWAvAsD7
         NYl5lEfxqJcRPqxEOvn5dyRdW0ILVcND1l4p9Cj3bg3j2a2JgH6vqV8ImOCn8ljZf9+U
         17juKKYI6jHGT/BLG+wT6ti5Lptevr8h9TNayyT6YfI8lx+RVPujcJZZDr351LJhgjTu
         X6ytZ+Ay6E4RSaz4nP+u09dyO2a0RvngF4mzO667MRh4cJBT6I9inX2Tp/oL03N24BWT
         DKCA==
X-Forwarded-Encrypted: i=1; AL+hErGUu/nIn2w2v6QjAiQAULKb1ftfLm2QlDSc6OfJGf5rsCInozY35WtQpHdrEcNR4tDlIkvdKEoVHA==@kvack.org
X-Gm-Message-State: APuU4Z81FbYNH1cDe0wgHtAXtYxrxvSGawXG+2fiOPE5FYJHXyI2u84O
	lgt159xoTxswnBQJkM8iCywmJ07CxdBWOW+VII9Zj29RbAZ/h+ohh2Ch18i1aCH0ktnZ8bQah6w
	Hdu/q
X-Gm-Gg: AYBFou0OZTPGcXzgajzCIcR3poYyENjkFCKIBa2xrwDEz/odQcwe6nItI6X1RAdlOLn
	EzZCzOyGuJrFp7zy+LtYW9OZ4Ts2ieOikIBI1fGeAL8LE+y2Naz8NLOT3wwY5peKFzAq1RaWN5D
	p/lLZ6sGyzNVfqi+JjPFtuwMjdQW4S4gpd9oihXwEptXbd2U6qMgpnh6Yg+frs6t59GOL1zfmSa
	dGd4NYRCm6WM8MydZKTRXrd47fK1vsSYeoz8tWGK0AH/CZMw8NtkIg2U1D8JSTEn6MHuE5h86qq
	OpZxp6wsXZBQTbakmu0mhoXoenuP35GDdQP8OSEMfl2u7UNCjC1xcTHYr4VkiVkWbK4snec+1qZ
	JD4pnZ9mAs0lQ4Scb7UWFVejyVGFVgT5AgLySm/fjZQa1UhUdwTNPoOw6ukwv2i60VtnGTwk6wB
	krqc8cqUuovL7J5G9idm+1BPGw5hC3asDyaIlWERNm8csVMYjOHtVip2So7lsSiiVG6hRZ2zXwn
	QFhf2va073VGYiRDpHR/1zuZWT7PMFngN1xHez9NvrXbmhzI5uK0ImYJ+ahVLo4LUouCyJbMdQu
	yTHjeEP8V4MSYVxn+TWEJoUWaN2Js2ue8L5g1Wx0krExma1G6A==
X-Received: by 2002:a05:690e:1519:b0:67c:23f2:41e4 with SMTP id 956f58d0204a3-67c67ee5aecmr3870192d50.27.1794496862680;
        Thu, 12 Nov 2026 07:21:02 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c58a0f312sm7504466d50.19.2026.11.12.07.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:21:00 -0800 (PST)
Date: Thu, 12 Nov 2026 10:21:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock
 fails
Message-ID: <avXZXMp_r5VVXS-W@cmpxchg.org>
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gb4nnddmch4tnyhhfp56q4s4pq4nkzyf
X-Rspamd-Queue-Id: DBCE8C0003
X-Rspam-User: 
X-HE-Tag: 1794497312-891914
X-HE-Meta: U2FsdGVkX187c+WvyL8OloY8GFyuzWCkyDzYkJrsCVO1txwf66Eom+HsmrSqTDbfgSuve2Z24iTsTxGswqFvRAZdIHPUf/G7mz2QiIuOgGIQT30QhBoBg1hSag5Rgmwk3JNCC+IXEkaprPIOcDVbIMCpw7muXWdyQaE862d3EhXOaAMkM9lC9Ym4sWEicrs7Iwu7eZUUZJmh4Kiqmdrv+02m/IwGnua2cTiDnbhWckmW8pYVr4aLxpG5F9i+XCDB2aHj//gOq3rPCcNFy2FT66ZSbH5ilpEaXvCWaJ+JqJIHUihA9fZKs7At2aXHvqqprUkSrz8W7qEGKSkKztlftnEiHWtQ048B1GoJNtIRi05Ek7RCezhMWR9QQ8S0XNYO5KwF7OjTfuowzBlZ6hylCHEk3BLHx+J0sXvPG+Ojw2QZA42ieyiPfjzzfkQSMz7jyT7Osj9kOsKvxNg4zJLjYBvodiMquELMQvh9cJxHxW2dYUY5JsCvO+wypdAmTHHxZV8Gj9/j+KS1OKtQd/RbU1VwaMZtYkH42faEYjeNH4Z956qSxYYs92Pm83AEQlaRSXeAGF1dlpyQs0qNdJyCPCVjteeRKpnZEcOzmuq0NOCMEl/UcT0dudEoRoH4PAQnXz/uYJwItniQ7T704bPo+P+NXT/dRkXwFrI2fn7VJZ6r/gXkM0Tub2I3ytKWQ9R7mUVy3VbDEVNWfwaEJauhjak7Ch3hZ/9v9p29VUUzrb9JDVDl5ezlpS26roGsRIHS3e74qJxQIGO60QIRmJnHklP2dEaXYrXR/2+mAsYpFe7JjSwKVAd8hAvE+7ktcPZ4vfWRp4jWZW4h2Hbs8sZm3HUYKxbqK/NQtraxOx5V4AtWka9H4ocanSCALls73M7TtlvUDtL0vQuaZzVjj1NNbYPUDU5ATL1yq2TLW/kBaNCwfnBd2F194awOctol0WQ5jtXByAkQtT4Uh4DBAIz
 z6fz3blv
 QLFWXpJzUj3O1ynu3COIyeNpgwPoQqTv5ADuRUkWx4KVZA57i2IjQ7QXV1UYMxs0Ogb4dP7F34YZ9IfuD2DpMQcQz4GZxk4KPQtmrX4bLNEvSx8DlngLv485K9CIWlYwCUpGa41oP/kbwMv7Mh9pXUA1jbA/QNmmY8ud14XJAT3fiFoWjuXL1RK5v2yG3Vo+qfxshhvITi0G3wmOk/N4yMS/p3EoWWLi9u0kWJ5NC4uSJWw0oH/seC8QYQvzkN5D3o4FFB1ux2gguGkYfnDI2pX2GwF0Bpdn5haTFUkhhzK/ejEWxameAkF0ys55N9UyKMQsSmT4LtrNBZnGk2P527G4Qou0fBy7ZwxcdFm4v+3QsghCN6BA39eWwQwm0+8ZoBPGrWyNfRJvkrx6q8f2+7mQnJzGJukGs4R4LC5JX4Xa4LPifNJeidPJhmQied2/Ns3xQHj4MNSy0r+/S3Shzxxk7prxTg31kP7apECUY6sgsQFIUXMnRYmLUaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 05:32:20PM -0800, Shakeel Butt wrote:
> When interrupt code, such as an RCU callback in softirq, runs on top of
> a task that holds the obj stock lock, its trylock fails and the bytes go
> to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
> using the objcg keeps it in its stock, so it can grow without limit.
> 
> Users see memory.current and the "kernel" field of memory.stat keep
> growing while the cgroup's real usage does not. With memory.high or
> memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
> for memory it does not use. The counter is 32-bit, so after 4 GiB it
> wraps, and those 4 GiB stay charged to the cgroup and its ancestors
> until reboot, even after the cgroup is removed.
> 
> Fix it by uncharging the whole pages in nr_charged_bytes whenever the
> trylock fails.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: stable@vger.kernel.org

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

