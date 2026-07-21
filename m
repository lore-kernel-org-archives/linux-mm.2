Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F7F8C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC576B0092; Tue, 21 Jul 2026 14:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CD86B0093; Tue, 21 Jul 2026 14:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EED6B0095; Tue, 21 Jul 2026 14:17:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFDE86B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:17:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F2261C02CC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:17:20 +0000 (UTC)
X-FDA: 85013591040.02.5BFE7C5
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F282C0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:17:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YuYJnbEN;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+9XXd1f5+onL8AjI4khFaIFq5nBOeaDPXuilZKVYdI=;
	b=aHlZ7u9sdrP6l+mgnxm6jG4VzyCcLAddJBBmUS2iz7cVa3hDKiAgwxebgNrWIWxtKWBe6C
	PBpp8CaW4nk4G3mkoRDY9sBDxV3oE5UbxsvPHXIqOLHbCh5PP8U3lj1rNT1qzQSfebRPkQ
	RpOnBbAoY1eocge//zAAaLsEjGotIB8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YuYJnbEN;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657837;
	b=Mu4ASx4FLOh0TdHAPKyuXJWS3Dt7lobwgo4yWoHp4S05Foh9UHjJtTBq5uXDwIa3lWsxt/
	QX6atHwFVhdt/rUSZelIx97bnFKNlMOfi61I6sMb9LiMzUYK9rypPxUg7t2+aat2IgfMoj
	IPlhtkZGtsPzVLqExyZd0anEDsGAqrY=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e50a650a0so700026685a.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784657836; x=1785262636; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f+9XXd1f5+onL8AjI4khFaIFq5nBOeaDPXuilZKVYdI=;
        b=YuYJnbENklhqCoiXjFQzQnFVHxSZ2n24+dlHF+wogHKcwo02wEL+/Uw2MdDESuu+0R
         hioGYXQnY9Y4WmTjXipVpQdwXb4habdt6TjQVp/MP3Gu3f71WpRmWChDeH1wCVG1Jwim
         FA9iBgPnwsCJziQdb5GzVChV9W9wJkVqrzG1LLDCUbSUFg6vnxk11/pk7T8IVpPFbBmH
         v5ZyjdXgHt/klQ8pLWFiEDGdnjCl5mdIobdO1UslKgitPMepwELD8rUOhayV3pWNDZcG
         q+eY3Wkq5sI7PgBl+AMl4L5j7bJ6r0wKnqM4cb2dO5ngF3et/LAvJxf20ozIjyjretAS
         8mFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657836; x=1785262636;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+9XXd1f5+onL8AjI4khFaIFq5nBOeaDPXuilZKVYdI=;
        b=dAj0aco6UrkJO/oBl7edNQY4nNQjl6++OkcyZuYEzKknqwrvDi6n1uiFiGkf33D2x6
         JcA97pm98JJ03rWw5DWvq6MRJOZDsT75+C0VELBCjx13afr4wGrU0mBtwf3DTf4O/P+N
         jwRCFqBtZnjFbTRYnAyQX0u5NSDkZDEkngBMOIxmRHl1maAIi18S/Xs2bLxrNClewBez
         A73WcUfR2pYRVhl+xtVoJHLHXYMdwybPMuTgykLr1J60OTId4piRJMygNDr8xVfggncz
         PBtkbVLMo4uypAxtnrykyj6xV3USP3QhFR/tH7Ui7h2qTwkSLdpir7trJUh3j/8/Yin6
         ocgQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpu19D0hskiSDL+aI/YpPPtQ9PpK3YOql8xb4uyVHQmsTgD0FCWTDHWCajc6KYO5D0kMjBLDF8aDA==@kvack.org
X-Gm-Message-State: AOJu0YzZssrhCRUMVcsRqdyUYK+UJTOcShDpbIcJ5/oHeM3AkCGM0HjS
	W8TF332UWGU9H4opAaz1eFq+jVPWazMxse4C/Xlqj9ZOKop+Y7vWA5qiGZSkMUmyOUk=
X-Gm-Gg: AfdE7cl6vf0F4+uxzt79MnYlBh9DKzv17HcD5yQ+sRKtf9NmpZK3RXyWsNPEYnAjf4+
	ti/4X0o9ugIvZXURhaC7UGJd3GQNAUG23GnXGVJuS1vX8btu5SQXuyJiaS1H2TinYdooMCtmcZG
	MHsF5Cd/QzyfoEFhYUuv4UPQf5IukcOBO8W1Tuv2urvH+G+4We6dDVIw+dgz3M36Z+K2+I1yOHr
	QL+RXZ1Eud0OwfTUEGOuCwNVI1GiNcLE7Om9sk3JiflH7bYoXXvCxFPuou8L3OQdo9ybKCsM4Ry
	4MxF2Vtghi1fUtw1MEh6JAfI+o023v4yVJqWa8O9ZcG+3lviwsKpbYt0xQXzuUVdJ3kIESd88Ne
	CW2EkrzMHOD6d0xXXiLR8S7CjEXzNxJf2VL2cFWExhFJVv3RbPvgRG3yvgOd6dnIARCO9GqLvkM
	D5tVkjAQ3DPfjmg+7rIPUF9u0us3i9F0YYym6xR8TZXImZ396+Rg==
X-Received: by 2002:a05:620a:708a:b0:92e:fd2c:6a21 with SMTP id af79cd13be357-930b3ed4e6bmr1951409485a.27.1784657836474;
        Tue, 21 Jul 2026 11:17:16 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52dd4c2sm1177061685a.6.2026.07.21.11.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:17:15 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding
 Enable on preserved bridges
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CALzav=eZYfYYKAGEzk4TsGFLp1TPb2iFePNmqGsjX4jEZNJ9XA@mail.gmail.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-10-dmatlack@google.com>
 <178433098576.189683.2364970585754668266.b4-review@b4>
 <CALzav=eZYfYYKAGEzk4TsGFLp1TPb2iFePNmqGsjX4jEZNJ9XA@mail.gmail.com>
Date: Tue, 21 Jul 2026 18:17:13 +0000
Message-Id: <178465783370.437204.17382376546970842455.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1819;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=Fo9WpNwT/sUGT1i7/NR5Dmr2ueLjAaW0mDLdJx/XgD0=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqX7eqlp/ogJ/HFSfe9d7gJvqY2QGlESov+8vFK
 UnrL0B5ofWJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCal+3qgAKCRC7dyhM23N6
 3rjiD/9pLAojhUZ3Gw0QkDSo7CBHc6v2wUGVKaF2iWfP34rUPJsFfVEgg0jF9wmXV0jX94tyfnY
 58vcRgopDo9BnjdD8MJiKFLY+c/1bwgj5XqBw+4EWhLvz1cWvI0pK57KzZJf31wAFALQ1n98Pex
 seGiBWeqXy76HaXMdWJDmgR4qaB2Vj75oUuWMgQjY/Rmh9diTQj64aJRo0Z0TliMy/x4gDC6h38
 +9FxcViNa0lAmfU8/om1ODmLzJYeNSkFs4cKpSTk2bzfYB9eamzgedskRKF1qKnP5mzg6GJcu2D
 OAMcwa46xXwAqfr/gFHQBaP7I/C+IJECu6cyTskw9gA3Zq6Q+2i/sSvfgeKVZQlkttlbmR126zD
 DxnnvF42qrMvHhoRSvB9sDlwSwmLklefh37cOifSHw+vVceIzCVZjS7Shfm3AddiYxSYqYcNaY3
 6MHkGOo3+A0GZ8YcJafB+8ex0TkPCLiZwlXZXCxLB9MeHjmJX0X5cFrb9n1luDPUNQVXeLK0t+4
 lawS9ROqKc2B9vkgurKqrFrmOZQjImBcdvlievMeF0JaXTh9/omvw+U/ObgJMAvq0Q+aKKb6XIi
 a5XHO7v0Lj4g+Vp6FrvyZ8Z67/Mqdn/XYGInU31avmh94um8Lqtsa1ygKrugCRiViW5TWEwES1Q
 aEb+GAhvGiNMESA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: 5F282C0009
X-Rspam-User: 
X-Stat-Signature: tb6ajepyhjf47rsrntiugafctwhke769
X-Rspamd-Server: rspam04
X-HE-Tag: 1784657837-149959
X-HE-Meta: U2FsdGVkX1/KxIV0C6w9m1gvM9LVTpP8/xPghFu2/pmcNXk3is+stnSatKd9STKIYlxsfhD9ckR8yOAmbCUbzpDjL7E6S5GVKV0N2cSAPJbAAdJabdTmA0yB2YKMQduQ6b1v5zJsB56p83/MplrEbE6dHqqJ7T3u+18y/3PD+7S0q2UhZL7B0/V/yzhZVmaVs7U68Ky4g8a7cCTeByLMxc1g8rLvKWQN00BeheupBd+PwHMGp3ABik6WJPYzKa3MnUFsdK6dPPWqSQ/tC255XFL6cByKil6loDpGMepnlPoxK+qJMWNAzjLQATc8luWQdpPX4IRQNwszX7W3leHL34I7aaMACMgcbq2/rdUNby4J8KzfjyoGGfZ/+lVJVY6P61UmlmU6KOe0zRxBRuOnOByxfD5nGj67/GCmt/znY2oVsJL8N3HBgufR2LXHoVg5VjOkU93ylAA8xTPBw8ziltNY9kkCwiCsZQW3vISHGKblLLPLcLpz/E0NrKuK33H8a78SX+iY/GZoPDAhiZDU8vyeCFHr/5g49dEEh/8lGpHXoMUDWNNJFot9YSfBFPQeWHOj3+/wblmdczYcOMgead2ZQ0eBntx1YKb7mddT3Evaorrksy71J5qBpk4H0qbA/EK303/cCZSsVPv9Ct/Ll+PJKGwMIige/q6vXZ16DvSVxOLDlu9D8QuRaaPyqECZJk4+aLNZv/6THNhmKIOwoMFww5kR7AVT0LgQDIIRUPMIq/k04c5Ymh2wcVV8YWTXrHvUM11P9eA9XW99AMuVMcNuEpqwfvQWRtsirL0JOZBaruu5xGiYANsm5V2uJLFa/shpmTaME6xX7ed1Z5p4rosrZ8wvGNAn5o1uDrmn/ZtA5Z+QxtkP4BbDUURCG+8TA0TuA9hhMM599cEG2mqd7XWghn07e4qrlP/fYZX0RNTJdjk54ZYPODTgYmo2NPFruHAmt8XwfXW1M4ZJIDS
 evIXDxAX
 iLOEpXh9isBjcn4F6P7sqAzcWPzf//bRRjrznxvQLY5CyQ1hP8HNwhlc0S2CDJ2dtp65/XCnJpD80jYL5m0ZMhbpnaaTjpcQmh1cDl0EGaUZErvopwVBDfsVLeVAobCaQ0rdsYcrPWaDwFkx+C2F/SDjNCXnkUofdMlQ1ZuORtq9mXghhhq+p6NMok34Vi1jrzdoPvNO9eymRe2c4hVvFkma27fXphz6oNTysfDEdeIJA2XQIXnozjeUQS/kWYRTkVMGqDWulkpG9ONxuQiMvQXeO9TQQhH6MeyD9RCSwicaxcXQwXJ6rymxNWX4DbcHP5EZD8goLyWQEYHHt4W2EHkc2QASkki+Nn8mTI7Yop5vLiHtp8GZc6q0ettyIKvJ68Nl4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-20 16:19:00-07:00, David Matlack wrote:
> On Fri, Jul 17, 2026 at 4:29 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> 
> > On Fri, 10 Jul 2026 21:26:12 +0000, David Matlack <dmatlack@google.com> wrote:
> >
> > unsigned int    ari_enabled:1;
> >
> > Sashiko asks a valid question, what protects other bits in this word
> > during modication?  At a very list a comment is needed.
> 
> This was my reply to Sashiko, not sure if you saw it:
> 
> .  pci_liveupdate_configure_ari() is called from pci_configure_ari()
> .  which also sets dev->ari_enabled=1 and is pre-existing code.
> .
> .  If writing to dev->ari_enabled in this path is indeed unsafe then that
> .  is a pre-existing bug.
> 
> I figured that a comment wouldn't be needed for continuing an
> established precedent (it's ok to write to ari_enabled during this
> path).

Overall, I agree that if there is a bug it is pre-existing. But we 
should also take opportunities to improve existing code and make it 
safer. In my opinion, Sashiko raises a valid concern that is not 
obvious, since there is no comment explaining the access of non-atomic 
bitfields in the header before the struct pci_dev definition.

In this path, it is safe because we run inside pci_device_add(), where 
dev is brand new and has not yet been added to the public devices list.

However, it would be great to:

1. Review the access patterns to ensure there are no concurrent writers 
   on any other paths.
2. Add a brief comment in this patch right before setting ari:
/* Safe to write without locking; device is not yet publicly visible */

or:

3. Create a new separate patch that adds a comment before the struct 
pci_dev definition explaining the bitfield access pattern, and how 
concurrent writes are avoided.


