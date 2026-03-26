Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B309210A88E5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF486B0005; Thu, 26 Mar 2026 12:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6AC6B0088; Thu, 26 Mar 2026 12:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECC96B008A; Thu, 26 Mar 2026 12:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFE546B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:32:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C514C41CD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:32:58 +0000 (UTC)
X-FDA: 84588758436.23.2C7CB17
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 848C3A0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:32:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FBw1YKlt;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774542776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kHkYNyleapDFkY2bZJbLnQJPE0yLAnN1/4w7u+RW8Y=;
	b=UQ/7Y6h+4VHC8bteZoFuqlFfovJl4HW+RPouY4NnH0YE5DU6848WrCGBj0kgtOfCnVdyhB
	dWfFVjXHhlJsUAUK9Ko0BiFaNtB50DpdMMChXsTk9CWyaV6yH4CDK4M/jecDxE3bLa2Vpt
	YSWr0fJmj4/oLT1V1TCud+sdygCRubU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FBw1YKlt;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774542776; a=rsa-sha256;
	cv=none;
	b=YXPfjzRXpVQynIp6i4oTUruuNqjCE41vy7rrxhaJYJT5dH6sAksEmJ9jRKElxHI3iXuYo7
	+LLz3R+HJOEDyhXCvebWluGbITSVZtX2WH+lzC854ZOe2lkTohudythtqx8bqdP9me6o3s
	NmthPfDiMZV8pLbUQG1HUY8dKyi8+QA=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b2b289925so11363721cf.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774542775; x=1775147575; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kHkYNyleapDFkY2bZJbLnQJPE0yLAnN1/4w7u+RW8Y=;
        b=FBw1YKltTSeA6CQ8IGSnTFlwi9HPZhQnz9getw3GB6bjAgSe4tS8KcupbJHfiTRsnv
         RpKmWWoK7RJY+xLpkCEx+6TSg0jVh3mJoHPrOmu9MOI7uVGTds0WhvR/EipWuvukKAWm
         J8Bsv9I+NyplYAYfhZ7e7GEO80PGEQ43HOSEQPTzL8RvGXlN6wDsUR2ZQKrKVllwGXrX
         xTnvsffjai6AtnJu2Tps0RURz0wdk5mcAaDQTZ0Ikc+beNO/YUCdVWCTsIyz/n691nEw
         yIFwNelpeUqQ5nD1PGlX7vsFurp3LbILqlsiqSzaT499paFOXSYzhMCOghDQv3rw/U7J
         /A3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774542775; x=1775147575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kHkYNyleapDFkY2bZJbLnQJPE0yLAnN1/4w7u+RW8Y=;
        b=UD9MJzATSCYV5JPhQ1mPZkY547V49jIcNbA8dVqaGXjlvZhP9kH8/T3ofRM3x0Eqar
         L7mvAh++anbr4KQFHe4uAhFwbFXbPsrr41uLGsuWyT8+KOcfai0L8GT8l9WmmHz8cBTN
         4+UvqbxXZKJWa+HAdMjpLkciHAFmc7jktGNO9Tum56D3A5nHA6/Qpg0BWw04MIquFmS0
         Vwtpb4tD+evvMSQgLuqzSeuNEGJUnr7TvNRyctJjgMByphnn3G9YJuIMYR4zs783+JsM
         rdztlLedIKCQveijZE/SxvgdkaO1ohc4i2c3bjGW7NerC3Qime6nydxSRwkf8aydUTb+
         q25Q==
X-Forwarded-Encrypted: i=1; AJvYcCXuOjO/udL96sGhYT+RMfeAhKHK7WBC+6bAgfxclWUhdeDpzdVlWzaL+mmkZ4Ueatt7SNg+E8RV3w==@kvack.org
X-Gm-Message-State: AOJu0Yw/HUzrojUyX4q81kYUreczJM69LqHafIp6lXlH9nqLAnvpROSs
	PJBS4HAoOh11Bfv80NWfqMobIxIAdcOM9FhnslJtW6qsBkXvibXVEmGEtEHbIrAtpsM=
X-Gm-Gg: ATEYQzxOBPHnrB3U2/7A0kmzpKszXGnU9Xt8USPLPoBPr8UgE26dH9NKoZYNaQJJ6Xd
	tUoomEFfRG15m4lNgvfsLS2RImT01WgkciiYuBpWAoa7RkJg8jM44OMPA3OurOJNk0gvNI6hgOK
	n/KPrRkq9vfKEjwCL0LQ0FLsmsq/8OZfHMHsp/jTdjn5acA802ekk0v8pqEg/Inc3D2LoyV6Asy
	/0IFuGNFnESe4xDPnYK/LeIZ1U6MmLhEJe3R2cdkEbRLjqp5SFx37/GXYwTXxBBQonigqENDFvc
	uqtFk5xgAaRpug6vAHAaeqTnil6cgU7gp5qqcKDBSV1k+QlvXzLjVC5d4+7i/dR1fU0WZCWkZ2p
	M4kgHGU/5WXIS1GnfC9VnszewjWV48j8hW4vN1WzVTXRXTufeRk+sGXzLVYw65h8TTQhAadsHwG
	xUmpHdlPvXCWq0ep18Z/Q1
X-Received: by 2002:a05:622a:5c89:b0:4f1:b714:5864 with SMTP id d75a77b69052e-50b80acc65emr118120631cf.0.1774542775296;
        Thu, 26 Mar 2026 09:32:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9216e5dasm28216811cf.12.2026.03.26.09.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 09:32:54 -0700 (PDT)
Date: Thu, 26 Mar 2026 11:32:52 -0500
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acVftLYT301ITlsO@gourry-fedora-PF4VCD3F>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: tfpyqeyr7h4gjewbnxes9nuhx8agcska
X-Rspamd-Queue-Id: 848C3A0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774542776-517003
X-HE-Meta: U2FsdGVkX18zbzVtZ0OPQ0mJmsuYur+9AbsNRpbSHKD7n/55j8FsnrJXEzA0sKQVP7z3rCoZhiP++ikkFythJLnt/LpDtAhLgklURuehFzUVYitW/3ePuaMjGkTVy4QR9oiLvHRplXP/OL4tjzamY5D9lgSPkuI2KBuluEdDl1Iwcqg1JFGcvzGREtcO2fQxUWeaURqSdJ9Ew/ZTf8c/669MDe4PxUQ5fb3R9pBEgY/oO96QnbLEIVgYJOZWrOoNfWUA1vZ/949Mg8/nbMRl4lahki4jQJtnT5/+VK/+k7qEvD9GG7ggJn8b5qljK274betY8PDVOXZvvLZff1TW1sWYU7ZvM2lRQ0eww0Pe/Spal1g434yyhtQA45DgxjTODIALuRrbIOblwLVKpiMTQg3SiBZXDSJYoRLz8LuOyAwuKKSMWQejLLpdVjiIygU6JhFrJVjWYpk+Ql8JEiRMGCgomhWdHNnvh3K37U2HSrGWFUsigpW4F3su5A1ACVhsNALow79O0yI9Bx65R5cvWfwJ79LeIU9bzRHtSofWccaIGe34j7Z8jklVWA1Pg2rnXdJ5TL7KBMht83ftRKjxxY96LzvBAr7KbVYZiM2BDn4nw7ZamI5JBwcZD1thw0tyT82SnWAdF4HleZpw7c7owad2fqzyywSBkENKtFce/Sk3MpR9pv1x1Nld+fT35lfceiVzg9jE5drCMg7dxJbadhNC3C4EUHLW7cjsMw2aaQpUhbMdfymNdS4HVl8Tf8dThLBXvjmDyka/hpB8pi9ChUVKIc+OvHY4EMOEmWpLcoq3iebq6IW2pcmZ+0Jo03MxaYsYdkGXGwJqLUae2vuCifIF3PhTzL9gILwCLF7v0VmdMv08Po3L9JNGL6z7b/uI9EecSdfbF2H/mAGxHb/6hjiEa95vXJa0RmEFINRJ6DDRE1HLLShvkUfjjxfNAzTRQxjdGgfKoX1JEwipb2l
 IajjFG8x
 wZAzX6Q9Bs6zU+3wK635K2WWXVFsHmPbRO/dfcMd7T/4DgGjKqG35fyvFKNOjNbFBls2Y/TmAk+9ba96oY2hbW2dDOvfh+9Sz68s45fYuIgElUmW5cwExYEA/AW/0UjnResn77LhxRGuCN/kVz6tLm8UnTRomgKQk9wOfJ4WImpe8Xku7+l1P4L+vNwsj2thBJAkxtd5PjGSGL5U/eudCbMVkfqRz9k3IJl87OVnuztwUEfCkf2tSrrUsqhHX9mENxVkzXSnBbWP5WZ+nJFxWDOVK2iPva3mM8cbpukvv1MKF/ZTFdSftAP+0xM4anNlYwhKcbL8m66hbCZUqzRqwMr/iYRzA5STQC3RTfgt5HVZLX/Xc2KBCcLuVE+C89HuRbqfvYUis4hMIdlF5YfwbdDaz0yEyiZt1/hsW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:35:28PM +0000, Lorenzo Stoakes (Oracle) wrote:
> 
> Maybe a stage 1 can be to separate stuff into another file, because that'd
> actually be pretty easy to do for a fair bit of it, surely?
> 
> Can use mm/internal.h to handle stuff that has to link one with other?
>

Yeah i don't think we absolutely need to jump all the way to ops right
away, and splitting into a new file would at least give our eyes a rest
from the ifdef spaghetti.

~Gregory

