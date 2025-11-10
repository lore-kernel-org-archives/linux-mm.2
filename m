Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A71CCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8188B8E0014; Mon, 10 Nov 2025 07:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFDE8E0002; Mon, 10 Nov 2025 07:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705FA8E0014; Mon, 10 Nov 2025 07:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DACA8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:36:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AC15140672
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:36:32 +0000 (UTC)
X-FDA: 84094645824.09.4BC981E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 38757C000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:36:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WjRcY54T;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3TNwRaQgKCJsE57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TNwRaQgKCJsE57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762778190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbMT84qlh+bGRnpLEEVxdC7496rODSCE09cq6dsWS5Y=;
	b=K9LiNeJEsejlizSgjbxZ77BoLcaEgN+RS1xylPn8NojGrmZuuJNG0Ntat273eCJMLPAC6r
	hYPcr213zPGKUbYZrpOdCShST1NnunSE9qUwoMqh0qRyPEUi32juxK7dvFIwX9ZJw29A5t
	HDhHh7PZuloOBORoQfLDJOHXviuVqPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762778190; a=rsa-sha256;
	cv=none;
	b=o7kvXugvh9YPSkC/Z9YvGaC6nDgzUFLyiqMnTZdTC+AKMVKWhC/Q9a9JTm32nQK4HksEAC
	6BOD36q5mmVrM1MT8ak5sN9Pbwy5vtmPmu22Tpt05cGE2puIkzf279uQWousdoQ30qwWk4
	dmX4OBZuPrSg+M58aswc0Msrtut5x3k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WjRcY54T;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3TNwRaQgKCJsE57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TNwRaQgKCJsE57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4710d174c31so24329575e9.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762778188; x=1763382988; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbMT84qlh+bGRnpLEEVxdC7496rODSCE09cq6dsWS5Y=;
        b=WjRcY54TedYyJP+hTle1WohFLPpWMlzRfeyP4LyK8QsqsB//k2uz38L1MWE4VOdwNx
         gz/0zb+d1C8FevowxESameHiGOqrRYmTbolxbjxpOPR+VgDxh3pkxgba9AvQC0OH7Vrx
         0kbDVRdgZojFLMTXMX7EWtK2Vk/1YxDliBa/l/R9qFHg7jg2HavETAPCRPfSlQopKdk6
         Z/c1kIFz9Pj8rrpEpasBOblK1VQ6whMJyYoMHN4szgnc9DbbC0eC/Eeh+preNIV5+Gaz
         foyKZG3OC/4L6hQikSPoM7IT2lbTpwyJXjkbytAFTIvJU/U3jkBIil/fDn8SrOSP0Z/M
         vj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762778188; x=1763382988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UbMT84qlh+bGRnpLEEVxdC7496rODSCE09cq6dsWS5Y=;
        b=mkLQidzrBVPk7zExAJS+cAmuOHL+Rfu3eEB5Wmr5Fl8FMcrlgT1epfN4nfui9ikpfk
         SCTBrwfvniACL9qqXQVbTst8i3Mr21cx/zzBeXfXKPIvNeNTkBD/hzDg8Kz7DD4CwXza
         z/zGO7K/yo5Z0SYIYY7FLvU0VVqma1v5XtLDUjOVRTtiqyoZh19cYyg2p+HChGFEdDgB
         Q0Gdeb/YAn9/u9mtYWEj1pLY4BA0EiKK68ZDSDm2Vcvltvk/eWwHQEUpWokscz9RFX3W
         OxQgNs0f5TGemZeOOvvjZSbmvAcvvUIsnR78lZ4HXNP2AqxEIfizwuGLsIbQUYJxIqr3
         QwmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTW0aVSpDrObRe4dVQ+CbfFUedS5bMEM/ljZUvt1IkQKBH7i90mOILJKE1hk4Go/vsrwGUz5mAnA==@kvack.org
X-Gm-Message-State: AOJu0Yyho6lO7KkYiMIozjl1apsEI/51gWRLUVxz+DUF7zlfDy22KqLj
	9UsXCYrskRG9vuE8vlsxQfuMH6prD6BupRqIJpL/if7THo9vVgx0R1Pu9neaCMjX6JVUTPB68Yk
	3c415az0RXIjh3A==
X-Google-Smtp-Source: AGHT+IFkqQ2JCO92rMhGqtD55gQ/qLw5jqO2mnH6sKx9F7OKDrhIFhpPWQqX+8AONg1NiXXzOHJAZNv39LHjig==
X-Received: from wmpo21.prod.google.com ([2002:a05:600c:3395:b0:477:7efa:f807])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:474c:b0:477:54cd:200e with SMTP id 5b1f17b1804b1-47773228b80mr56455815e9.1.1762778188545;
 Mon, 10 Nov 2025 04:36:28 -0800 (PST)
Date: Mon, 10 Nov 2025 12:36:27 +0000
In-Reply-To: <20251110113834.GWaRHOuqnXgNa0UiFn@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com> <20251025114801.GWaPy48dhlZ_EVoqKi@fat_crate.local>
 <DDSLXKU87HTE.G0XUZ5BG5M8K@google.com> <20251110113834.GWaRHOuqnXgNa0UiFn@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DE50PRYPTPD5.3MAJLOSJFMA37@google.com>
Subject: Re: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: m4gwuhb6wzw1czzano3xi3nykir4jxxz
X-Rspam-User: 
X-Rspamd-Queue-Id: 38757C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762778189-392195
X-HE-Meta: U2FsdGVkX1/FuDmhYOhWIRqbRb+2BEtjnKnpt7dGUoIdZUFtOG0PsKmGQiYD3uaruwVmSBVZbNHaAvszAcR9/PS2/NfRIcQNfnfZUcYNq0tXAaTeC4aY6UtJ9tagwx52m95iVfCMbH0vHLv8YxS8Aa/gEnKhllYEYG5c+MBNY0APigB8/48kHd0c3Y3M8pfcWWO8Jm4So5ltcJGChDeN9lm/f6xEb/hFl+LXBHMferweZENmp6z8cohl+wAfjr8UVr9roJCsfv9p3agKLZi2bP9R8OhzlCsNi9noyfvFEdr62VchbjiiHDrAnFrzqnFGFAQ05wsiE8SSl9ibNaz1K/zHl/MnazMsM30UHyO5cc1ZgRX3wX2gyAhsy6ZA8CeoeG0MQA05RV6RTQxuco4/uSsL3mZsjcdFeuzFxvv6Ocr/PIHA/CVrfy8ALXZMwoTRjfiKG8HaxJGLbr1JOSZSHcnzD6wUlx9XpEDLMPdOUMephzO4lJ0W1UFeagJDT9CpMc9IJ5QSOA2RpoEEZih1xEgTca+Pmr22lJ7sx5PFoBvrPR9dbb1lruGgn/VfX9AoSFRcPsIkOylsx+3fhf+69siJX+DUp9wVc1sFM5gKNe6VYm++JXlraKi4fKYfJHKBOusV8It35FLM6wC64GorO1G2OSdqD35HzRb4y5Rs+LG3rTmqthZrBMZqsfEgtMh00DZOf36MBLi7q9KUggIU/+MzNFaD+fdQZlhB74ldAicG02NXMgZW4J6d7ZFxFE467uzm/a2xcn7nahsMvYyDf008nEwBsTlbtJQi9Zz8APcy3hvqCrt91XWNhbWmmc5ClFVj101rLGbIcRvpDLRE8ec4/LQKLKQMEmIYN+cGZg7/j/wzyfpofDzm4bu4GRAtQJ4LT2ozTaHd841gUYyiN5WptEEGTVqNF680FAuha0xQd3jQQFutoggcmlHwAiKnDz1tPQLwf/tW9HKEofT
 lrBL9iGs
 s5gTUyprg0bpkYWosnCMJ1eJe4QdOL0cJZpUdAMTyWWLNctLBb5vHvO3TuEX4BF5y1uqTxwa7lM4KhoTEPcHQtPjqI1B3nxT9wXheH4Am7hSQZczzMV5XQ65aKqDE5IP4jjKsPErfwSpdhkg+FwQ6xRkAn79bOTTer4XFXO2/V8plSQPSnXgZshO3I/lOYzzsY7VaJqpM5/9urhNHgmCtX04RBnZ1j3ve5+AscddN3+sZU10zNXG6SBWPsUAaVl+C+yIxJy0MmB1VRJMrrnkiVM4Tni156Uh36iQgiMmolFSC9IzS2z4cnuLEVHSfm/QgLB3lAq6hbQj98yYjBJhFIfj97yCP6/yjnmL7+tz4l1x2wcSE/KBFauWR1IqLnHv59Po5yPYmPH3JvbNs74VuHGOcDFx2K++7Y+Gk+EuJt7USfVbh1RjCKaorDLfS7QBwie+eSENb3j07zwxhw9CPVoGMaXgAqktBCbT3qOsdtsRG72U1hUgyrdr8QIwAFwiSqSw2+I0hn5dfZrT28ndFHiSssnZ4luSbn9WGHnYm4HDC4GqCb2CjxPD4lQS/5jGp6ybY+OXnbDIX+xop2eE5u6NWs1lXqYhIdn0LytYwx6Uk+CvdeA4WpRNHY1DgwKU/vea23f2GLPNJ/L7vlcPbgULblYlm98aR0CVBhRAGn/r4M8GBX+efjRomG5aG85wHR/5CvIikUpPawuypD+0q9tgrDRlXuKA9EXsIBagI3wY4WHRwz+AxNYqYaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Nov 10, 2025 at 11:38 AM UTC, Borislav Petkov wrote:
> On Sun, Oct 26, 2025 at 10:29:23PM +0000, Brendan Jackman wrote:
>> Per Dave's feedback I am still slightly hopeful I can find a way to
>> come in and refactor this code so that it's gets cleaner for you guys
>> and then ASI becomes a natural addition. So far I don't come up with
>> anything in init_64.c but I'm still planning to stare at set_memory.c a
>> while longer and see if anything comes to mind. So maybe we'll be able
>> to reduce the yuck factor a bit.
>
> Cleanups like that are always more than welcome!
>
> :-)

In that case, I will advertise this (less ambitious) cleanup which is
awaiting review:

https://lore.kernel.org/all/20251003-x86-init-cleanup-v1-4-f2b7994c2ad6@google.com/

