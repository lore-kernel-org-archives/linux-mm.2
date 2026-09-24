Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B733C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206136B008A; Thu, 24 Sep 2026 16:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5F06B009B; Thu, 24 Sep 2026 16:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC7D6B009D; Thu, 24 Sep 2026 16:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEA956B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:20:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F73D1204B8
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:20:10 +0000 (UTC)
X-FDA: 85249772580.03.94BA64B
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 139CA8000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:20:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cFjqLUpS;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790281208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rij/XOPRufC7Ydvy7i9poFa79a5QAPV83S5VKBw2RzU=;
	b=P2cUAGeDtZSUmv7EdLq8qop6gFcKB4Jf7CXgba/y4dYgX5UWttGbTRja6EAevmcEr4jd4A
	On7E5Zxml7PNr3aXhDQdHVTGCq3JTYBos0kTeRUu12Sp6AJmSFzz0BOgxuPmyI/ITfsHKc
	WPlVNd2iaHTLFhRc4OsDsT2zDROGLZc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cFjqLUpS;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790281208;
	b=8Mk6qF/1gpljj3WhtvSLWY3D/LJLMGCuLTW0VpASUmDaY51eDQqi7JjhJ98xEhJa2pb+tU
	ms8EAqoaJ1oyx2C7S7mzghEb6c8TtlvhYhQsnbKNtcknSdZgHXLIAp6DKSqQXLfWv+1iTV
	C1u2CgUG+w13zG1wbYGO1rolveTDCRM=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910704e63a9so1222626d6.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790281207; x=1790886007; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rij/XOPRufC7Ydvy7i9poFa79a5QAPV83S5VKBw2RzU=;
        b=cFjqLUpSphvNHBo6j4jmnOaqGh7tIHeDd7wGFeJHF68wm5NEnPMtk8ACX5tufpkWx4
         ba/v+5nd82kUWRH2Q1vEhE7jIf4Sh34yGWJt85SUx2JIFfkscDLL+ZPrl3C+ucmjfybq
         IQXvJjozzUlhKrPeYsVp4NdOtqbrg5Y6V8iiqTkBS/v8MHLRbUgBekgzuwT1zKU82BOb
         C9vX32yjoFazL7qWtUMW2EgN9lZ5degbK92jenycfr+DCqnCiIY47WeMVvqZfwJO/4aa
         vVZGhmlDF1wYcE7CMtWfhu5FaEbYGhB1qoloOr0NRXqnCbPIR2vOfl3Cif9SeV3a5sXg
         M6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790281207; x=1790886007;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rij/XOPRufC7Ydvy7i9poFa79a5QAPV83S5VKBw2RzU=;
        b=JJH3p9V+7882MhB3sTwC2nWOHrvGGfkgobT8AX/nC50YF7YXCnR2VCyNhbPT5+pVjk
         xSe/vi0YIT05M3vC/tkGf0AkHZvvlRqOO59G9JZ6+KBkclFyVZ+2AEY0OU9jj2p+LzGC
         tra0ExptVkZKusARoRzc4LRFgt6dNjoT64W2iOMlaaCagWDN8k2falS1vLRtubkP1WZ+
         XDsaCeeMdS+mj8y+Fu5WPlRCfDB8qjInxUSG5IZRh6NzvlZaVw1ov9IYoSCJ6gWZPliC
         SJ3ZLrSC1zks5focefHTt/i4TcwmpTObsD7XTTpjyk0pwoGbsgEPRwwDEyaHpqvek/47
         2Abg==
X-Forwarded-Encrypted: i=1; AKwUvByNeASGQdKTA4w3J2fw+F5bsLcAjyZMCxJJBZMgrirgNeXBJSbEcem5mX66VGUehWdrqqk49KiWMQ==@kvack.org
X-Gm-Message-State: AFuF++kNO/7SGGfIao76r0maux+2MCj6dNCDGW+GZaZnhPSa+OVEGkK6
	+hyGB6xcwVK5SmwLb736gv930rRSJw8KnT3KGABj6SRftTLTv1+z7k6P8vQneysNA2M=
X-Gm-Gg: AYBFou0qTqGEHeI5VgU61nAdY9Ez0o9kK3A7af/0QnCXdFI+NsPTAsore2AzTWG10z+
	H1aKGH2FAbr2FkhNwrYyPXWdEjSQgO6wK4xvOIaTblDtd7WhLE/oYvVi9e5RCk44kZySiRuVnFo
	0k4GvV47MAd5KPEglq9EBOB0ec6EpijRCtjg2C0wraZYt0PEQB0JC4zHeS9vW0CBr1SrkybgMmG
	FXUVN94Hu6gc0tVSKlBvtvfzevTE5VWQFKjyyC24RrlZ3HjHZVvPXBa4fX0Qd8M1v4iTBfwf8V8
	16wYAz3y1fW2c36/lSQ+LIOuXPWFH97oeaJCygjbmJ2B/FvAErgblKdQ+9Z20FTBSf4FlY3doXL
	3u5O5qJU1Z2LjYF1r0ejmpeUEvkK+vjXFBJ+ABDP7Nzt4iVVU1X4Rji++kraHmPXPncyomruaio
	BjZHIAsp+XAXCXWPvJQkPt2JHueVwZBh7xKfG0ZLLI3+f6OToaIi2Mhg7DbIGrSuPOENot
X-Received: by 2002:a05:6214:202b:b0:912:517a:7243 with SMTP id 6a1803df08f44-9142f9662f7mr6439846d6.22.1790281205969;
        Thu, 24 Sep 2026 13:20:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430e09ce4sm1581146d6.28.2026.09.24.13.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 13:20:04 -0700 (PDT)
Date: Thu, 24 Sep 2026 16:20:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, axelrasmussen@google.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev, david@kernel.org, kasong@tencent.com,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com,
	qi.zheng@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev,
	surenb@google.com, vbabka@kernel.org, weixugc@google.com,
	yuanchu@google.com, kernel-team@meta.com
Subject: Re: [PATCH] mm: remove the unused zone->unaccepted_cleanup
Message-ID: <arWA5paTALxnFGpq@cmpxchg.org>
References: <20260924191103.3475117-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924191103.3475117-1-usama.arif@linux.dev>
X-Stat-Signature: bixnizzeii1x1rzuop34oqa5urk3nuxm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 139CA8000B
X-HE-Tag: 1790281207-754793
X-HE-Meta: U2FsdGVkX1+aCi8OB5fgjgVa9ZvS4dT0BM7LFhsZVZj/RmE/ItfVUxA7SrARVxef1KBy3SA5YGOwjnXqEqM7Fqp0l1OnAS8QHbWxlTgc/y+AfDS178RtfCW0qTJg1gHnIO7Pdw7vvZ7D8cZHwZ+N7CKF6ygFf3c5+TVSNTGMG3ZyshnAzqfeMRlb47Yu3wPXKe+LONLs2M/B9thTh1+iSbSBrnla2IUQtLyZjTjDdDxWcnNitRHPOaD3UuWYUk5Y4EHDpAQZ8yYFM24f60lF+l89tePWFrelOYZPdAj970KX345m6+Cw8/KxfcY5EpP2bfTlMIL+GspWcE9LKVZsA/XvyI7mbU8IbgKOzeIzCxLaTXXd53LfNDfLpYojPQWQ03IIkcMMx6DlMnONfdWxWluwRB/F56DZWLFJdGf37Ry1vpME0/w9WwqlJUMnK+/ACDFA40ykzHvbLBDT7EK+qz4f+nV8vVmQRbZJYuLYqZi6xc95j7noJNUfQa6P8qgPHAi2ZFz7GhRtgJab7v5NEoJih+++oBYGPC4XrH+UDRqekLU7VuIVkvqyEv+KP9FG9wnE73RavUlM3f3TeQ0vYAB3O6yk1eV83zKiPTmoONG/CeS67c7AXC3pOqsbc3YXIll8c+v5HzgyvfPc/MxQBkchVovvCAvqt30tXTIdrEJkcFd8AGA1KMZAWqHOhfy6OiGhDur0msxDMcV/KsYlkRsfz+oa3L9vG3+w5QZYImbthkYclP9WungWNx+LUIh+Wff2cAljfQK+ZIb7ZgKAy07aDxBvOenKggEPXv0KAaTaVntPo9exRQclCIKHCjjKH90Zk1gKeG/+kmQfTqNeaQ4BGf1nFfibJunxden0gOA0bnxUSznSoNFwRt4OdJcfRYJkSPoHKHWI8iUU/yjvb3pAK2vkPZs1fcFZgQcF+ESc5SNBDGKpx9rfs4+YOu1sXSgNBV2LaQIQf2HOlS3
 lEyakKC+
 nlDaUikggA9wvnjWYp3SMaN3LhztocQcvpiQCmU5X0pJEE4/RO46Ftm/JfZeSLap0hvMbNQZkpSFd+MKG0BvAI428PVN3ys5IHY6A2WgCzZ3t5WUPogKdrDML7d7fRQrRP2iu0Q+dLNAlolM2jdS/NsckcY52Cjy3Jb+NFCxQEvIV2e3Jb+OSz6ZkKczm5DLUykVMoJuShiWDSlN3EOVHYDEyu1h20MDo7MgyKiMWJI5UtzUnKZd0GASV1AgbBVcojlIWUvzlooKKfg6ovzG+iC5JdIpBSXL9rJ7dFXZOn5wsTr/MkQyfOUEP3QCnXiQJhqaEybxQuaW+nUiqdzXu9l5fXOQmkRQ/JkQIEv90VhOhV9twcw0IPkgIIYaYixR0qdn3tx7LdDFJrtuTFLjJId8n8fGMRAxooDBb5NLMrJwJ1txg6/U/m/bF4fveooj98heju0ZhEwIB52SGLYoxK0uiA7jUVQXnQ+dF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:11:03PM -0700, Usama Arif wrote:
> Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
> memory handling") removed the zones_with_unaccepted_pages static key and
> the work that decremented it, but left the work_struct behind in struct
> zone. Nothing uses it anymore, so let's remove it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

