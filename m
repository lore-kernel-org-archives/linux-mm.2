Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF9CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 19:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41F86B00A4; Mon,  6 Jul 2026 15:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2F66B00A5; Mon,  6 Jul 2026 15:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E23E6B00A6; Mon,  6 Jul 2026 15:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77E306B00A4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:29:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEC8C4016E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:29:01 +0000 (UTC)
X-FDA: 84959339682.13.C9A16D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 289EB140007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:29:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4p73KlE;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783366140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQcrKM144IteF7RLbk69gWQNPIW8WjgMMggN5ygWDkE=;
	b=s7l7oAdaQeegca116ZhV2uOBLYR/mJHDq+NaWshdUTGOha/uVZFLxj0/74+9ED31bEJ0f1
	z89AA8nG65yP6fehl2SPGd+6A+QN0jezdZdowiItW4ewWpq9Rgw7hPV1rDOovsNIe6YJqK
	aoW8veL6vxXYzDUsNGqlQPv12QtTicM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4p73KlE;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783366140;
	b=Xy0IJqyktOt2n0nNpKmPW9AjAeadeKbdSQSfSseoRhjDUpmxf+2s3mxnLPp7hrV6TpkxsN
	NbwovG7slfaD+O8nYgPLb572mvUImlMD/7raddxZ8X45ItFzenIa1rv2/3Mf3tny5wkQ88
	kwFzEpUtYeF+85iiz+3H7FiAk7izH1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F8DC61389
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469641F00AC4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783366139;
	bh=IQcrKM144IteF7RLbk69gWQNPIW8WjgMMggN5ygWDkE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a4p73KlEHDRzOjXQJ3AFLPiKcraSRL6Z7FvrO0fRkw2zsAyQjd1biBl6QFeLvrfga
	 bk4rjDE1kfCeKgsFVS5AMThbo/mTMUQ+dmlzamV/Mb6KBK83tvi+y9gxIZOEOgU3jV
	 6VGeLaUjEEdoGDvk8XyDZet5mx2U9lSgRFYcTld6GupjmlrLpO6i7GfehhmchpwMLM
	 CKZx41bPOIBqJbMgkQAoUoPysFq7nl7XmV8pjXDp168TyS5MSi1yT3Wiw85ffgUrT0
	 pRSGhDZcDwk3kjL99ZZ8QAX7oTB9D54UzTevy7k7ar6fZRz4Erl1l1au+z2bSm+wgq
	 Nh5qmr178ZkoQ==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c12788a75abso467427566b.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 12:28:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpLZ+9yu+lwtAnixgJwrxzbL37AxpzY1gp3Za0WTPFhm9ry8wJOSudrDw9wCsbZhOMLY0JVWwUjBg==@kvack.org
X-Gm-Message-State: AOJu0YxZQyo8z8Sn6/FJPmAeV0Ri/2Km+WYkVw+hxCDzd4JHiYBe/ueD
	v7ruO94LbxNPOiePeyxEr+e01CBD0ZCDac2dupzLQdcasTmzMV6qXiRk//OjFYhhMutM+a63tvk
	wWo9LDBvq0IN+9BYtdIS0ICoENPhDueY=
X-Received: by 2002:a17:907:e107:b0:c12:61c5:c141 with SMTP id
 a640c23a62f3a-c15a690a339mr80814966b.53.1783366138212; Mon, 06 Jul 2026
 12:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com> <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com> <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
 <a1c139d9-08b8-9631-7a85-697df4c23d52@gmail.com>
In-Reply-To: <a1c139d9-08b8-9631-7a85-697df4c23d52@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 6 Jul 2026 12:28:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNOEfRadPaMv33nexQztgDxWEWi5=w=fKd+n7A+1L592g@mail.gmail.com>
X-Gm-Features: AVVi8CejFCreebY10J5qVyRaGPCWsbYJB7Ywv5bR5xAz3vYSS39OxmpII_xEK0M
Message-ID: <CAO9r8zNOEfRadPaMv33nexQztgDxWEWi5=w=fKd+n7A+1L592g@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 289EB140007
X-Stat-Signature: 1w9n3afhcisznsezh3p41tsc73k5ogjw
X-HE-Tag: 1783366140-330368
X-HE-Meta: U2FsdGVkX19YbTxDe9ptWM5drQwjv/Fal/YjUzYhgdZENeG0K7oYDcFnvmXpfjvHJ+cSDv60i9jDX5HJ6vWnPgb/M+l/Oon+FUTf88eXPqI/CfmG28TcTvW0VNOYc5mj4Q6OX8WsmX43GdRMg+LQ4YIfTfmHXQJUfV+7zj9ughI9PduqrPVC3nVwbBXWZB0XJZ5UEZWoP4jKEDwukhVYsMkNY4Fu1RVnMKK/Uk9+uMCpnjvf27HUCGsnWxHf/T4HyvOQFz+tXPWn/Pyf0+F0xgvbTJ9mosICg1MQjwZd1lrGe/C6Phdob4W8AMnNAniTAvSOTSStWjAt5KieYGATJdt8wgsXFu5cGfnCGTeRWhdGcivRAWM5gm7eAHsdVzvdn0GyspbBXnHxANB92ANJHp+IbPi3vaEGL9AJkskC4euMwIBYpnKZxymYJZzGdOlBiDx/F8oDi4PX6bXIaypic1UtOCr/fcoSw3PmisyfmLu0zU62wwb7oltFyoe40P6uezWr9GFmX74rFt07PZhLUfpF5VzEzOxIPfifHttHLOJ4y6+m/droZy12/rC3fnzG0wGytl9owEjAh6FwLexucW9Tr00KVk4byWuQbL4SjRTp61pqbM1S6ieQk/0yKhiFz4mU4c9rNn5GG8z5tUmQhbE5tiFFWV35wbL2ZTGAu8hcgNf7LKEgLwMb8V7OYsofrZ6dhEWhV9BhSAzTWGgQzCMyMU6ir6uh00rcBp2Dv7mCnTQnu94m+ohY+LKv7J9VdD/+xhG0oDksdsqd/aABBwyJ2dYhW4B2zt+ol5Q5zM4bXsUornqgVN9zq/OwuTBzYdBIgiMkPZWMSuz5YDBBPPySIWNgdLfeVSIi4qdupRLNX9IcNQuDYvwy6zARb2xwK5FNWLgGVKfbVhRYXncF9jMXm+PUVEYIMl5N+RO7k4GbVjV3SrPbTplGw681e13kt0noA5djWjXyofaq0Sl
 c4eHW9j+
 FqtuzOU26IxNApWc/EfjAOJPrAtnviTf4M/SbSC5oT90BPctCXDVBy6n4akl3IR69zOt1/Ky0o+e8wpz8MO8ihDkl+ds/wphOJEimtLwl5bPacXcP4TISo+nKBbC3Ny0uOy4txzjio0pvLKZdwzHyhQt2BwOwbJYN9qlOlbZOnQtslsLnDlDr1Ojyk8srFCubHqo6khyo1gptE1rjofT35pCadNPh7C9E4Yoz9xNzgwcSm6Q3Lb+P5tjAlj5xcpLF+SJX3Qauks2J1rMm0dR+KWNn6g8fawTV6dQIbOpTAkn7+kQa5Z4C/wt2QVlvAoQiaB1/du/nanCb50wAr3N+nIFKO0yE+9IcyTQ58BjwuhVarfl1MqR5rs3VjQio9wYQWWOpQepazEIayAH8hrvgi6iSV1B1QqvaypD8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > If you're looking for another cleanup to do, shrink_worker() should
> > probably also use mem_cgroup_online() and avoid taking/dropping an
> > extra ref :)
>
> IIRC, this might not work because zswap_next_shrink is a global variable
> and is accessed outside the lock during reclamation.
>
> Consider the following race condition between shrink_worker on CPU0 and
> zswap_memcg_offline_cleanup on CPU1:
>
>
>            CPU0                            CPU1
> spin_lock(zswap_shrink_lock)
> memcg1 = mem_cgroup_iter()
>    memcg1.ref = 1
>    zswap_next_shrink = memcg1
> spin_unlock(zswap_shrink_lock)
>                                zswap_memcg_offline_cleanup()
>                                spin_lock(zswap_shrink_lock)
>                                css_put(zswap_next_shrink)
>                                memcg1.ref = 0  <--
>
> shrink_memcg(memcg1) *maybe UAF*

You're right, thanks for double-checking. I lost track of why the
extra ref was needed.

