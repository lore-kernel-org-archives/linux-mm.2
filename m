Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D10A7CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B28B8E0090; Wed, 17 Sep 2025 19:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2883D8E006B; Wed, 17 Sep 2025 19:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5268E0090; Wed, 17 Sep 2025 19:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7D48E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:50:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF6341A0706
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:50:48 +0000 (UTC)
X-FDA: 83900389776.30.87AC4B2
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 169B6140007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:50:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ky8B7iiv;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758153047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9+O1OqYBXulm61p1ERwP1q/meGeBE4HmC2D5TX8SAc=;
	b=bMldsoKgr+MRdQ02036kK7hgwmD1/AkXss3Ie0uj1TSR9QpZicmL70q33wEd0T3KbwIQxx
	UyUnHy4lpAOpM8rXzbuOgmVQYalHRlYg914yuCJ/npqcAox9tXMccZghxkDpOem65hnltv
	/IxsWOepQylr88wanqehDZ0OE4P3oeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758153047; a=rsa-sha256;
	cv=none;
	b=hMTamQJl7Oyj1ZgOF4Lr05CO3vhQPasNjPz2XjCpCNsq+O4/+l5IEOXVdQYwLECf56X7Xg
	MLMwvDOy0CO7qjwiCPP4fDXAWovpCxvTDKiREL4EHLvNnwl/tGUZ3Y3zs1MxDbtjXWG8Ot
	NqvVZBEts3NZWCmDF4eWxNRUE0/abcE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ky8B7iiv;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8287fedae95so50686585a.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758153046; x=1758757846; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H9+O1OqYBXulm61p1ERwP1q/meGeBE4HmC2D5TX8SAc=;
        b=Ky8B7iivdYwtWEm0JLJLdWyfM22tU1DASqRazrUFjVXfardOKqXbpmlSF0PzHAxp6D
         XO5PF62rhH1aR7PDaxPL5bHg7jRGG3R8RwyA7EgjlDT+seNy675hvmOEPfjvxiAe3Dov
         fqLINcc7qUGVmgKEGJHmOprLgmt3Bz7esykD1WYA4ANwL5JKWH5J908Xo3wrVe1ZW50K
         6HFUTCEjBurN8nyJ+Z7secK58RHYtNrUeFJN0SzyKE864iJh95cts2ZaMqoYzMyzwpgN
         jpp5YDIOhj51q2ES+O3/3Li23TVK9csgZNTIbPtNgLam0At9L3NE7qMGB5HFyF2irKpg
         J0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758153046; x=1758757846;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9+O1OqYBXulm61p1ERwP1q/meGeBE4HmC2D5TX8SAc=;
        b=skdFUQj10GvUbjMSrkKc1u+/dXqe/vIk/Ldl3+8itlld1NriZINjavqotwn7MxajyC
         BMvT3E65gdR9sboPRFgJ/vRbb60DA4I7YIUoZvYLvtUPajaYiIttX+xhGgULeY1BJYtx
         wtm6cMMmX0zKIDAkxil4l5OGOFUbkumMwLL9d9d8S23nCbG8xmt9czSh8pvbz/pe9UAx
         khDFIzq77DN3ljKxCJ1bKsQNSLSmitYwieToFAYA+bfdVVNEVJ8xmV5wf+b6cwhQY7EK
         4JbcS1PLYQWoSnztgaCrQhEUmFVkd2d/W+OU9DwIHDI1dmWki3vb99pxbZ+2G1Uythug
         HNRg==
X-Forwarded-Encrypted: i=1; AJvYcCXhdYWu53yZkO5EhKO7EACHmT/yIOAauBLy4p1pCVDQLEFOCZW0CjWgs49W6yXTvYXu4vPttZFFHw==@kvack.org
X-Gm-Message-State: AOJu0Yx69BYntFwERix0S4qZxR3tdwe3XK+T91oqI0y8Ph07krsM27ft
	RNPJk+63jGp8i/IXDuei0TeN9rqWfgKyC0JOvb+bEo5ZxdBL3vuENwtJq80ErwmMczcGeo+ygEB
	C7bymsqfI/PpWhCJrXIrTYQTgwkN6VnU=
X-Gm-Gg: ASbGnctnWrWZlwKjzPT/OIoTcM89XF409ZnKxs3OZUZzRo7zWvfeB7nr5/hVdo3eO1J
	IDkoVhE9bZOkIP3gr5Vfe/7uY6qLfVG4l6mXgyqg7JmFSwRVddEzyCjKerG9ZUuWxvpv/WL+5sQ
	DO0Kl5Ok7q/lj74l6i5w+YmBlcvKwyX0X8Lhv3ezlwV1dHLe++iDuetoIw2HIKdaG3HyzcJbM+r
	QBw+9alhNlU3u6xLx7PYJnA0NGqtMCWePR7BIxpkH5Bs4c4vHCy1lELp9rh6yhpa1iUQpw=
X-Google-Smtp-Source: AGHT+IFJL2CJP3uAzbra1ybzJTukuqDvEDP7eQvl2rLg43pEVlZyTdk5GR3/awpXrLF8fxzamaO6EK4oI+hndM5gC/Q=
X-Received: by 2002:a05:620a:46a4:b0:815:630d:2cbd with SMTP id
 af79cd13be357-831096e9fc5mr440866485a.34.1758153046104; Wed, 17 Sep 2025
 16:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com> <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
In-Reply-To: <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 18 Sep 2025 07:50:34 +0800
X-Gm-Features: AS18NWASEv1_Mi_lbIVC978vKQXdnz7rSZ51ahk117211gXUBICfxJ64AqF1yvM
Message-ID: <CAGsJ_4xTPJo7+kCkkiZhn8b7xjH7yXeJ2XPoXeoJm+XwJB_o9A@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 169B6140007
X-Stat-Signature: cni3xfjsfkkb8tdasyu3oka4owrgxutx
X-Rspam-User: 
X-HE-Tag: 1758153046-750003
X-HE-Meta: U2FsdGVkX1/5LZCNLwZSqCSSf3dkLIxC0JeMiAdI3W99DOIyeG5AK1BOdEmsZu4knXAZv2nLDFOFEoJY46USA2H2SRq3FBqFYlw0fskFxUodO1AijQwLcsblutoTC8QQZrX0P2MkhIBB8o3RWJX4urRJzg5uXvpgtf63OonkO6u9y1bj4S5/HUgR9BE8hkcEO0FdrUW756U9M1h0JFCHO6jKX1wt8fLPKbx/cNo3T5LSKkZBK0yVkns5EpseY1MocJrzo/dDh0UxyDRsSruvbCsQFp7SSuNa7agMGQidtaml09K9IhwSBlQRz1fmCb683ACFcZgk7hbJ6sKjja2uA2PheMi396o3/Jc55ilnMivEqZvyo6P7q79MpZHTEA1qHSvApH2wSkaq/g9iBLv/KFBT9RSuTn4sXEKqMpLvkQ01Fxak2Cgnadq29ZstDW57MV+47br4H06eqnavvJd01UqYXYrkpBQuMv4H1VwtgOS3fC3UPwltPUP8jK1HWH0zVXzV+4bN1/BLZlbeXhvXAqwH8KQZUyMWrRzPJgpMdvNW+vb7CPftW6wB+0RZ2ezPGMYgmqTGwAr2JdNet6bc7H4b/uQWL14Yx/aeFhIdY4xxE17+rBnd4ztfxlQRf2TLspZ16Bb2FMz/VJX9EhAq/9Ub3NidX4pew8RQtEErkZYbl7WcPawWq+ISJi9tEkoH4sLR4hsOPjmWL7rz+/6dMcRcV3TUfLleomJwZLbzVUFQ6kmhxT3k+WUKssZEQ2Kp7ilVYGchgQ6O/iarEPiGJ0hniyBJlt10i/yoFW3KTAbrekY7fEyHy1xw6bmr/sEpdMB8g9bTxcQyAcCKzRTJmLN+npQTR0MepDPrc7+zq7YcwuWTLgHxBvOTx2iGF2w6LzFCps7vwDm1IYthMuPCFj+3nO7LirCNXw45BPLVC6h7K92eQl12ZneKt1DWFH+IHqclSgCHyGNojoQI29O
 mQcQWepL
 FZJAuzjQb8xVAvfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Perhaps you could describe the swap table as similar to a PTE page table
> representing the swap cache mapping.
> That is correct for most 32-bit and 64-bit systems,
> but not for every machine.
>
> The only exception is a 32-bit system with a 64-bit physical address
> (Large Physical Address Extension, LPAE), which uses a 4 KB PTE table
> but a 2 KB swap table because the pointer is 32 bit while each page
> table entry is 64 bit.
>
> Maybe we can simply say that the number of entries in the swap table
> is the same as in a PTE page table?

BTW, as Kairui mentioned, you plan to store the PFN instead of a
pointer in phase 2.

I wonder whether we need to switch to atomic64_t on systems where the
physical address is 64 bit but the virtual address is 32 bit :-)

Thanks
Barry

