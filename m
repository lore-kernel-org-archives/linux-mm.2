Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4B9606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Kv9cAC5v
Received: by kanga.kvack.org (Postfix)
	id A060C6B05B0; Mon, 16 Nov 2026 18:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDC16B05B1; Mon, 16 Nov 2026 18:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F43C6B05B3; Mon, 16 Nov 2026 18:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4906B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:36:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C91A416026F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:36:10 +0000 (UTC)
X-FDA: 85442592900.22.5339F3D
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id D640CC0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:36:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kv9cAC5v;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794872169;
	b=UyEDQgH4938eItRig/mUqIf09CcZbIhGTtY/h/UjcZ+FjlCbdtf4aacx3dG1o+sshVE5im
	82IX9d4ogKI4ZIIEp+AxOeNi/gfRlngeoPZb8r76LKf2NVhf/hWwlmE2T9bPOTRAI2sDwC
	9Bylc30m91HV/9uXUsPqC0uU07hCET4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kv9cAC5v;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794872169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELsHsZ+7ho94iGmxovheRTc8jM9OxoUR6+5StKzNHo8=;
	b=rnhBJ+P2WdkSGmHWL2vxDzoWXAdr+yhQRkLrstP0gBOHiKLeQWlmX28UmtE/McIqYNNrCp
	ygwjxZ1jhjWNk+hlKUtx5MNnBo3KZA12eOZ+Wgg6ZOjCEAqTBPzYQuYDY8Kd35IZqhvYUE
	pRfkzenXRdd6pAy2JV9uKMg8a33UFgI=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91eb53957cbso77514736d6.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794872168; x=1795476968; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ELsHsZ+7ho94iGmxovheRTc8jM9OxoUR6+5StKzNHo8=;
        b=Kv9cAC5vv+bQO0qSIbKzdQa9eKqUvad1cfap9f1og+OLpfMgq/daJJNWHj9Hr4Xe8P
         OsncVTcuLtb9UUVesZWnPLz0oMUaZFlOA7ktAcasRuL51W/IIcHbRL0JFri8uTiRTy1u
         bniB4FIt2B0eHTIyw7nWdK2m82Py1TosTE965J/zq/FI/Oa8ik6VXH44Yju/7Yg9qpNJ
         OBouhh/qLpbd/whbDAikijStx08bh4H62TOBeFko8DeuIPEy3rOB+GTnLP1kLhNwULOW
         d9vwos254szJc9JDLU4Db8xTmvC+BpV+2Bz7O1ELOyyiAgcZKLv88HS03KVW72DyYZsB
         VF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794872168; x=1795476968;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ELsHsZ+7ho94iGmxovheRTc8jM9OxoUR6+5StKzNHo8=;
        b=U+7zy7HzHTrEQn6yi2zoDUVERI8plr3Udk7IH0AnzvaY3ea7PIJ0ujM1tlJPO5UmLl
         C69Twxg6IJh5ELC3A83G8tMN3J3WUYL8ouYGhz6MW3tUreAZ3vFXVnv0cfmlYGK9N+W5
         sGSIpZheFIIoNUMRF48xJnzlenSwYIJ6A+vF5YjqN49xmSppxhY52DbrfztzQfVE3257
         18vAtKbcKyiO0R2yQ2IlZVw/Uiyci0SShq8cfrC01SPj7b6l1KLal13fbqCyFooln3hV
         unYnq0STNCn4TjrFNgKGMOB8tq/h23aDFQuT2pY4W1Qa31r7JNtBW9WyU5DuH43Ovenw
         B6Ng==
X-Forwarded-Encrypted: i=1; AL+hErEWIshNS9pyR3sTev9qcjltHBKekYJ+5ai9Omv30Kb5CMtkZVhAgGWWZ0PCjIDe89a+DSADqSCLNA==@kvack.org
X-Gm-Message-State: APuU4Z8Hz36ujOnEaof96cYbQa4VbLtZnmHOqeoCxcuOEqHosFsVjW9H
	z4CQti+Xm7NOt8eKVC8AFW5kCHCV3zpw5lOO+VSjghl/ASrBfUIcg5N7nR09g4VRcVY=
X-Gm-Gg: AYBFou09thrW2PHxw8LEvXYzdetEmfSQX2qv9zC4KFRPhX8Gt3kXCbTqk9GxwL8FzR9
	1vtBSMQ54JUGulEpkH/0czgm/JBfWodHxrwcdjZ3+Z+0GEEQdhHYQP+HCH42v+RbMKNByITOu1y
	v8v5He5/afv85SBG0tsPwP2pjSF0aS7ljtvYJJZAQARMlwxdZ0pH8dIA4B5FT/Mid2cfn1iuGgH
	ewT7x/kDTH2nh5GeQQc9Sz2UG2+H5bXMbptZHDkv9NGz5uVqlE57q0ymZuFpbTTtg0mNOcwXYfO
	FDXX4YY4S2lDPRoigz0l4C5EMwQq4cqoxmDxShAtiZuAI56sxDRM9wV30PxCp4iFogAQwX9EQ5T
	aFAYLqq1tdM55eWTvcOhbcKnFkOR7f0kmrt+GWdf3PJse9Ce6uami+a7QK661SmZZgbpA5GfcpX
	7BRL5jlw+RzZH8pEU30aRt+zxMEgxQPhqUwBWZHXX4rj9jsheiQndMgvWVgvqH2o/dxTXga03f/
	bxNlZa9F17ZNVGGOD/OLDAMoa9JiBT9pjrdmllKMP+kF5ZA74L+yWm1A6hmgcCWErEA9wziQPxA
	1Nhgv2yHRb5nfPGuVo72x2uoMOZCqky+36JiEg7kd33CYGDh8w+36kK0qD1ZWxAhrsCib73vM1e
	G/oDK6w4=
X-Received: by 2002:a05:620a:2616:b0:93e:c6ff:b787 with SMTP id af79cd13be357-9494baf6061mr1926781585a.13.1794872168008;
        Mon, 16 Nov 2026 15:36:08 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c439ea1sm956840385a.0.2026.11.16.15.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:36:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] mm/page_alloc: drop unused gfp_mask from
 zone_watermark_fast()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
Date: Mon, 16 Nov 2026 18:36:06 -0500
Message-Id: <179487216685.482102.5643322867540998114.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: dazyzfbni9174tsuoj3hgeqa8ke67ffu
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D640CC0008
X-HE-Tag: 1794872168-881976
X-HE-Meta: U2FsdGVkX18vkedtYMW4z1sosA0/7G8qhXSXU80MerjhD2u0iTz42aKMJbjRserEkDHZs7ZVE2AxHA9yzpU8zyI3AmGH3jnH7KGKbAjEXM2SlgKT4/WsChpt0RkssqXBbLRKL0+iL9Pj1MPObLDoE+RTqwt2ViYRIfTA2Y53rUAC5xuX1bGv9RuHVYWO/UvmhtPHau9+Kwwpf8QknEao/QYj5MSxr9uMSf9xoqRyzqsOoNmp8y4v1autfJk8Sy63ad3Add0fY7N7fyeh9NBgsFNhwodqbeWyuK3SwxqKDbspEt621W+w52DTqRDP+xI99spXF4997roRD8iBQWXbkwsxrWZev7YTsMpmyQvXq4YwBjDGajMkhPYDM0KT+ijWl0TwyhCnigaOK9GaHznn/ffoveKZ2d4RSBCpwsLKi/bvRDKOvzQknyJCoRgR/bbmGeN/14wMYWKkKh9uaQw+TDivBXV2yynUaEDdM7QWFgc/7RHuxYkD6XWvuPgBpzY1CMwlwcSewxmT0TREhsr0N3A3ijWmssg2LU6xhKFwNi04/nKGTvqMwigR4KV+ZxeGUtp6WjMRF1JwgS5lHeAz7229vWVu0hvEHU4j0M6/JMeYuWcgKK0QAgvO+IzDGaH+38GRMsN617273Oz3aos8fXY6bO+rl+8JL/kC91jgBlMja+hW/8T8soW6NkqzlncDO/gEvZBZTpUa2CcfZt2AbyKLeeAzpWtNcaegOSK2bobyd+WxkV5Nw06DGF+LCEYzgiQ03niJaPBHEwh4G8y90rJemT2/mXi6PKGg0j6IEfV80iL9QQcfxL12c7qZlIKCJYhE04gKd7AyWaidWuHxeQzxsiq75oNXE5SfRoxY1KQomKRKjL2T0kWE7Su91k9+6vTZhtpXsd/kNTZkCbovAmb9lKgH99o5fkLHLzg4jnSZONXTJgQ/izEWMmPQATQmyHSTxTeHeRbMksnO/Uy
 yS6rkC9a
 oygUwNmy5nmRZmRIlJv1L4HXsW+TtByZHuMhEKG5CtkTch2YG8DOsruyBYqnbjunXAkXWlPZTG6aVEhWrwauZol/o+J2se47R8l7IvefAzu/Nb8UxHhIPO3HmG2wUdByabmdR9K9XOZ1+8itAaz65cHsky+SQM4wXbY/RWB6qOdS179LoX8Oa/SaaRmKELhTA9xSgG4xgG0nTZJ7uevUoyoj8/TqP43+QPkZH8W0iC/9nkXUuSo9l1Z/3ujYIAVDtscTODtSOYX5dNEz9T0OxCp//xHFe6UV+V1vdk5xZlLlTd2OPORwSTo1SNIgQ9KBHMvaU1+UJycSVTpg68rCtREqfDzVhl+K53T24h7N/HlcvN3RyvPc1cPUBnfZyZTUPoanIShMKmfMnKFufuP+/Is6Hk1glq4pNU7QttD1qN7qcrTTZuWdYqZkx8Klhpw5etZyY6pOz5FGEwZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 15:52 -0800, Joshua Hahn wrote:
> zone_watermark_fast() has not used its gfp_mask argument since commit
> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
> 
> Remove the argument, no functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


