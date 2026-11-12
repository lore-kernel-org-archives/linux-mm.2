Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5619606A8BD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c+nB5sGY
Received: by kanga.kvack.org (Postfix)
	id DC9B66B05D4; Thu, 12 Nov 2026 06:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A576B05D5; Thu, 12 Nov 2026 06:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91096B05D6; Thu, 12 Nov 2026 06:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A9C336B05D4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:26:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A302E12055E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:30 +0000 (UTC)
X-FDA: 85426238940.27.4F3C668
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9E1814000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c+nB5sGY;
	spf=pass (imf09.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nWBtEEn4hd48cIOC+JW/bLoHA1gTBtQ/8nPmmpZzBk=;
	b=b4J03TTDwCan52p/RY1V3zWs0pD4xpvqpPeNrhv6PON7ITAzmptAVIdFOPa9aCAU+UyOCA
	6DdZyIIpXhTUPD7Ngxt5s2iQnBJ48Vbwh090s0WOT8pou0pnLxwEMRybbPTzdxsHtqn02C
	b7NC4IwxpPWwolsiNa0iTyfAdxuITYk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482788;
	b=mv/RDVGVLh2sWOzx6XlN9ftmwxxXmiOEoYSkC1RkeVCpiLihKNoIvxdLMjezEw9ARaDiMH
	AQYSkKu5Wa3LINe3wcFP1Chv6OEdvUUGZt2yF8zN7bIMgKWWHXqlLv0CGMt+KOxtOBCpA1
	7l6I9ypmnAdaUQREKDuHbjVvpgkco7U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c+nB5sGY;
	spf=pass (imf09.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36e90071735so256081eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794482787; x=1795087587; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2nWBtEEn4hd48cIOC+JW/bLoHA1gTBtQ/8nPmmpZzBk=;
        b=c+nB5sGYwTeYBxVLgkb4gso0RmryT+fDv+YgUgsriIsTAZTayl9zgv2xx4RaHQ6bQo
         dSiPFYnEkelzD05W/cTJm140+3K3eXivPvNlejWnFaUZ2Bz+fU9WqRungVP/Z2yE9BLd
         ieX+SLjpn1vdiff1e+ZVhX4qPGsbUgmb3LoxrMeT84ZihaVxMk6p/RnOry2X++jifTny
         8uPrRa4kXGDehE6n1foP2GQwC7s/SM7gdNDfzEA2nfIfAFRL4DAW72pmAKeP1pk4R0to
         11PrBSmjQJLN1kKTxvh6sJIEFq16APD0oCz8erfSAJSruWsstHIB/9NS/jJ2Yf6M615I
         gLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794482787; x=1795087587;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2nWBtEEn4hd48cIOC+JW/bLoHA1gTBtQ/8nPmmpZzBk=;
        b=YP5c5C72VsYxEt9WqMzKxkcnuCtDr5yyakDVo+8HtlUFodN7rnx9F/BcoexCJhDoo0
         fRbGWpDlvQ0RsT3NSI88Yf8vD5jVrDYNA2ou7lTsi/4gIbhgqAtpK5hvVSmcaT9nfVIV
         Y+CFNjFaRyJElSFS7d3w++PjzIbnC/Tyn0XQF9lCZX4eDQ50pDbwAVB4SiKpASeuomQZ
         yhFmtWOOg5vXN1zwsBkfrQtMqcuOCAJNtg1vx6iM2HyDxVW7rBm0C3ga7YtKO7uUZExc
         zZ0AYSGMuUsRfZ72wiXp2DlgXcPfMK5iJQVVUe6BdOxmHC+i9QOwwAyKQO+HEKnIOH8M
         yjhg==
X-Forwarded-Encrypted: i=1; AL+hErGOajGaQEUlOrOK8SfCwDQaHaws7+M3WK9AUYCe8MMCr0uoaRk0yf2rfTwV8LHTEmVPcEsD5Zi/cQ==@kvack.org
X-Gm-Message-State: APuU4Z8OLgaNTC4xFet3hb+9sFTnWt/WIcgAzINJrnIqvjjD4/z7/kZd
	0eoRlq5XW/MGsmSl8bU0b4xcf+UvbnSYKJX+GfD43MY1bAJT81qKYsqx
X-Gm-Gg: AYBFou20nu3+37GH8lvJCSJoBid2pbWe1hv55c0NPbWEhqVhupCP/BodjhEDhrNHjiV
	vmNEa25MSOrDRp8Dap7+R6X8CIYEJ+I2mMMy6F/p3tQULfj3clOoAW1YEAy870nk4lq2fBdZRPt
	g8/LOOKRXYXSC0TgxTeVKrVvs/uGvMN1Gv1OscjG2s/EgYd6HygjmG247srhuWhi0NXcq2aYxbI
	dTGsG2pgztst53FjbiRBuvL+7KohHemrAfQ4aLRWyueo2Ksnc2ox2RzRhlWSwfjQJbCs8D/4hkQ
	A7Zfkz09zjuSQWguZlvwfCGJszDfgUUeWksDM3yXCHbmdaQcl+yOm1eD/ra0RCejApthTIV6RXi
	j6QNqEB7v5labBph+jUTTDzn+s12CdItGnepPAr345ehAFY3HxKxRTeKsKjj8xIKigY4XkWPm35
	8o6C7jshurqrN/T8nDwTi+mO0HkLx4MBs4SbWHYxN9VmK/2kpiiEn65ot1zORZqnMopMszcbs1q
	NeGFE9qRqr0uMEPb+N/3tP7PWFeNhUpiVmu6ImUEs+UljX4EL94M+d+UgukEj8+vstVyPvOKZr2
	pcWOhvACVRkET084KYVqSWmXBEdf7HpGVwTWfhwu15v1HCU07l0mSo9uzvcLmlJVjOc=
X-Received: by 2002:a05:693c:8113:b0:35f:ea17:d171 with SMTP id 5a478bee46e88-37684ceea1emr9219901eec.2.1794482787103;
        Thu, 12 Nov 2026 03:26:27 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751fe306e3sm27380131eec.7.2026.11.12.03.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 03:26:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Nhat Pham <nphamcs@gmail.com>
In-Reply-To: <avUet_6jVqlWSP00@google.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
 <avUet_6jVqlWSP00@google.com>
Date: Thu, 12 Nov 2026 19:26:15 +0800
Message-Id: <179448277582.2553194.12524350925159624366.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: i3piicnuidfuddu1xyiurzqku8jhfexj
X-Rspamd-Queue-Id: C9E1814000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794482788-48503
X-HE-Meta: U2FsdGVkX1+ubgu6r14HMdwXj8MNfNSTvVrzutpIO1cdBkB/ei+MFIUsA8UrJar74kMeNSZ1vnuvlrPCltLwzb3APal5VqR09XAJJDKuxtYjJ8/zPpDup4iGe99raMtvysNOa2JiDY45pjFaiwX0WeKPQmKZAvpEbt/Fo72VQ7+VYaVT9/hboKCimayBye5UOoWw/eGm6lF7r8UDpTfr1sfeaaI70I8RvArpgj/EiQIlzuhi+mz44QipgNG+VBUDmEDeIcKdgse+zJJeUOJ/Yk7Eq2rvPH5dX5UB8XdusEuP1ndOKd3//4XidiFaaGWUtK6n3RNgwOk11aTRA+kxBNK2RikFfOWFx35wETBtwBFoIWS/oBJvzJZv6y5TlnE2XfxkLKReYSpT6del9NGeES7jEeZz1YwYjT5KU4j0hiKjCn01iYNNNIS4frOf0JBDSz0ceMSIQfomJDlT4cXr8ovP+ZmH8QuOMsiBPUqLD6f+00TDBC8a9jabSNmP6/GNakCgM9doKYeJ/7mYc4lQ/uMFbmlcYMZBNOrgUrTUuFYNaA3ckd8p3cZLnX0cZPVNUobTsHm6OuuuOx9we9Oz/el7ZSnebCP16aifXWS+B61fsw1sLD0NlDEV2PWzNhUBW8jRpKx/JsiUQIEvq0BpbWVETvdvLLPJqp4uMm5SGDZ8KJTwD+tlu5+VPMMZwOqArjZEHO/pn/1IKrQVc+xzz4pkdkyDDgQFP4gmDkkfDom7QEjkHBdy17tuxY9ToV9DaJl9z1Zkf+FMccyWqelJqZnJN/SJCRdqWR5ZRnY0VqrTJRFfPcGEPhZD80AnT1XwpoLzYv8NTqZBqSVk1Q9n1Ip7ASmnXiR3n2TcMNHTIIvSHjZtGJ986wB7wkBVBLQ3GglHA+NsQex+4neidtuWCWN8QtotXROCt6tjHAWGW3C8ikEoDctlLekBXxFqy7zflm4YhuDHruQ/goVX9kW
 sjDT+NAH
 qjB1e/p2xNJrtzJEauCj1Ix13KHZapRkiAqLAs8s4KCjwjIV3Jc7zfq/ly0pcggJ/kPUa7kjurIpJIBzrZCDLRWJPp4OJiKvBNrHgDhSvqTnxy9J+wO5+v8DQ8tLWBgDv2UfJZOOWY79/LlPf6g529Tezvpe3Hgk1QGcp06Dyyb+L7nPnup5mAhqPTH01xi953wBTBWr14qqd3IHWeyD9guRsMT4bP0e0U1gONKGi5Dq6XEjTJheyAhRdr0OEP8rEvjxzQO8xqp8FM5gWrb/wMCdF62AZoGR5uNhTr5NFUWJAyojTLVY8jdy1FL4799nvDXzpgICYVIAqpgJ4/ukb+E7hx7PmaFY4OVlnUD7GEhED+4rMMxl0Vl4B1XB19G+rINBQ3fp41C4ztmZWCaAVCXhRLTdcM0PO6jF6hU+ovmZ2wGO2EYBFFUIauVu+tgK2R7n7qyDYDAa/Kp4dszht+Eoz+Bu/M8YMB5fB5Dyj6vTy7wyBXkWJvVknckG0q0LohcLtAZI2MvQNFA2aIhFJnOco111X4dA0rK+cX03L7roTUtmyN1ezqDD4bWqNEJPQ3djr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 11:05 +0900, Sergey Senozhatsky wrote:
> On (26/11/11 20:41), Xueyuan Chen wrote:
> > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > counters are updated regardless of this option.
> > 
> > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > debugfs is unavailable.
> > 
> > Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> > settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> > documentation to match, and clarify the pool name in the debugfs path.
> > 
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Thanks!
> 
> 



