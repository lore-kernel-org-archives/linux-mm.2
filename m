Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C765606A33F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W5lgTwxa
Received: by kanga.kvack.org (Postfix)
	id 556046B02F1; Mon, 19 Oct 2026 12:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5067E6B02F2; Mon, 19 Oct 2026 12:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5396B02F4; Mon, 19 Oct 2026 12:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0256B02F1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:30:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C669C0694
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:30:43 +0000 (UTC)
X-FDA: 85339914366.30.C611306
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7A8A120011
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:30:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5lgTwxa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792427441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oUq59+j9dxvzrhFzYz9RKs+wIal5piSXczl/es8C48=;
	b=qjE14eqvvRVKnZk0F7RFhgAcEtwIs/WN8JjZ8P2JKrBAFU/6Ya1E7S0Uskbmoh+0V29E7e
	9GVxx2C+t2kUZlCrxPSijJmmS52FuEHyB4VUHgpdu7/P0402v57e1wWTAWvF1FETcPnMmq
	yWeVMA2ssmZbF2W6nA1btxZe/ppDC1E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5lgTwxa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792427441;
	b=VU1jEBIVbAlXi7c/o/4HVKiWRW7V59pTRZLhJlqK9n6/Hu1Hpq0skrOISwLmmDeOuj8L9o
	z6dKBv5AShjI6eZHylZuieyploN/uNCK/+DcRRn3WCSpvFR8xOh46zouiL3UytiEzluZ+i
	c0BVBJ8NNM0ZpjMwR9wPDnicpDzFlWs=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4911df1e196so1123081fac.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792427441; x=1793032241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1oUq59+j9dxvzrhFzYz9RKs+wIal5piSXczl/es8C48=;
        b=W5lgTwxafyf2L0WDIHy5CfaC0p34Fpq/MKX3kd4etrqi/hXjbd1s7xDtbov8n/fX2D
         iK4EEwWERENCyWzNQnXuKMGFqTzXrL7zA0sWq8bn/gD4TcE6mratGH4Uo/99aRGs0L/v
         THrZXaFKO8yI1e81jFRGpsx8ZhYpkoGB2tziUvsI+m4WzZPkc1lk0JbevuPbMERZxIHQ
         makUJ36HJNk8tnNlc2A/o/ftlU7awacZb1XGV8ZjjwpYNbNvo5oCkDjnp2wCK+5Z77y+
         aMKBwD6wa93KjUavfAy5AqQ4cOTzcDYRB9uJDKYmcdx+d6TTCtrnZMPXR8UTWJ8mP8zd
         wAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792427441; x=1793032241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1oUq59+j9dxvzrhFzYz9RKs+wIal5piSXczl/es8C48=;
        b=l76wxAM8C3uZkyr++l9GzMVNel2Ye4J560RhDu6K+/GKAREmwlSdW3ujvds2lENOfP
         DuA9tUUGt7K93jZ39jhrr+6QX2ZFz1P8WBse7+S5wH7P60TsXUbk+6i43HqHA7tN5PC5
         V0CcJJSMgzXG5hB0bcm2Rlzo7g4sV+5jxnl9xOLId0i0w8xOiUMMmvxa2F5nlXuylA+9
         GIrGwBdxBcJpzfyIDr6YcvcNzomFiDkAvrpojVxso5ie0FAd3KXDFPxtNplvsCx4yLrS
         G2xQfjrTEGUtR2G7uKazn7TSNjPGqTySbgHPB48jsYhFq/DhLnFzANlaC8GXZQiqF2FK
         ZtJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrL56I29BIlw5bGMZJ3dVnBgmiKA1FCBz+W1pVFiS2F54uDbQWjTLgX6QGwCvBuyB/kNuarUqB6g==@kvack.org
X-Gm-Message-State: AFq9FYIcV/adp71/hAn8VVrXy/4RS+UVBNSr5NWaZ3M+5adPUQEpeTm6
	2yowwQe4fVaTykDYoS+/k9OaB+rlTGbAvANn1cYr07H2l9KZjB8OaXc7
X-Gm-Gg: AYBFou36BCnR6xKoojJHIBQJmk6uwrVKQScHf+6oquj37OKHa/HmKO+LpXIHr7iq7g5
	gQJkb+Ro4HlUGE240G9BPiteUvFNgVqrrjXC3NthpC67vFJm6CUKRHOY7nySeNdNxBFywuojYjV
	f/ub4acW5+27EW95A8dZDXyZ3cY8w8IzFvfWYSuScA9yH1j7jyU4Aau9fHPVOXdwkaEtWklNA/B
	scQyL5YDDj35Q020TwyQSaK7u7/MWIc28HdBXUwhZYteio0Rvga3rTfiE8BYhWqpvzfccoAT+FS
	in7lAE+XQg/JJzW6hbupuR9+ET97OOez8fGw77qJh1TokyyT2nsrEYwytYuiF+a+qE6zEBlt8lP
	Uwg8OnAtyBggrSK1S70BoSEvNUy44KwQkevLTNWvmLom7O/IJExqkFnEOI66vwNGvxO1+6MEY7b
	6qFmzdyBIsX3sb9ZKoSQt3jg2odleQnoCvR+Cs5n1HwUU/P987Dr5guD2r0s4sWNhYq8VAePJX5
	R2sTPw2Wp31/lp2wxfFRJRYi9WmPYXEI0DZLdk1hkHQSphWkdQ6qlBLHKSc8T0J6fb8+lYdZRuO
	AyRN4FwIQCBJ0ibP342f8sZkltd1vT2Z
X-Received: by 2002:a05:6870:b3ca:b0:494:7c40:ed7c with SMTP id 586e51a60fabf-4a757a6ae5dmr6289171fac.29.1792427440574;
        Mon, 19 Oct 2026 09:30:40 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:18::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a73b5b4278sm8210010fac.6.2026.10.19.09.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:30:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu: clean up callers of pcpu_obj_full_size()
Date: Mon, 19 Oct 2026 09:30:38 -0700
Message-ID: <20261019163038.321273-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019162803.281810-1-joshua.hahnjy@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7A8A120011
X-Stat-Signature: 9sx4b5oqhfkopsert1traxtkt67uyysy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792427441-592067
X-HE-Meta: U2FsdGVkX19BFtK01pSbKJsJco+RWq/NhxmXg3QyS7c5kCjsFSSnXKiboY4nCYraNfOn9dgvdqoMvsTuuC/bhBkbrOFI34+W06DqGJYTK3MSf5urcO10TSOw12/WkbZ42xBjo/R8tM/l5z4ya0kwmkvrKMlJvpopfuXBnjYS8OX/mbnOwl3HxQFqtO/P6aQcys4GxIJQ7nuIRJXx9J4dveLfCvJq8g8GuqHZgPyCeyfQb+0XvuZU/E7Tks/rz7OeaYOI+Ds1nx1bRcUV7b3Qq8hvhqXptQY5u3NybH4Fwxa64uQ6lYi9qAs4r0jSUumE7W4jW9fyfZrlOyTtA8V9ILfo0ZsOx7kzWzmn0CIV5j9qbnA3wG2NZZLVI3cVPLxHg2QQbKFIdzIhwWGQIDhDAdrD7i/+C7//TQBHiIy9i6Phoy+8LqZV962iyfrO7hWhfEm4TUj3hxiazJZVC+VWswLkH5N0qi93ed7iRBscsPgMRctmz0H8c7Stxutlzyuz/LCyCyGHzxjUWjvZc3fIMgkMBM3U2EUkOj1twOUgiyQW3K8PyliUW5WqA8Q55x36JwUEPPZltxEQCwBGrRDhifTHgiVavyuXxNTle67oFqpPp3WyZy6FY+TezZj5zvuryUdfGUM8F8SiKA3Lu4IWIWhx0EQoKQHm4dtbMN/smeichJciu6QVu7jrmhl3phFLm0Qb36QuA69KJI72MOij26xtUjpjHOKoWO1BMkm9sFIddGO+1vbTH+PyvweZgm0EV9ZzQYN9lNeJAWbvNZMuGNr5HEEVGH5MFiC0L9LcWDLVyoidzGq8cepgKUnuEOkw7vT3oeo2gkKwWNepDLY+ByxSW5Og1Kxhh08mOJTnVsrCd5iGMXCZWw0E+Vtm5cv++OwvwhyZ1eiVb0mB2cIbS1aNTBvqbFzhabp5Un2xIXkJGsY+IIPGxvBRLMWVBjeAk4VfHjOWUlaVAwT/iqM
 UlwDof0s
 TeHohQCqvrUE4noDY5mRK/AouNDN/3YQFQ8ai60fGUPkAhIwuyTZqkHJ4o2FF5lLt2ah+R72Wmh2uhawqYRKvFZt/aO4d1D3uA4dpZDN5u+76Kxrv1uarWTrT2et9f/ErIqBY9cRzyTuVDUVC3YDJyC3kji/YCfXjLbRK+LqyiTFijT2vuDh+7Hqf3rzw92lBwOU3bDgz2vxEzwMbeUq/lmYrajv14FCzmsYBV5cDjVh/Dc10CdoL3nbn1F/2Bl2IxUGmSFURy97RIoOcEATogIKq5Fjrp+4uwe3CpO34ob8ggcokJCaPINlf5/fpmsw0R6SV2eI7a0V9zsWQGpFib/8P666OrVfb7xME0dBX+4YHUT1BlKC3+zCB3zUa14ok5kyKtt8R+aDJQH8BvOvIt2TEJ0RSb9pMKojOAxUHj+igKiDe9QQLrlqCtUlH6Z77elxkPCHunCKQSro0qgpVlY9qKjwLC6idzk0HPryyjfXLSRt9gfsYcx7ooJqdq2w8cOXmfs9CPyNRy+8QURCpyxCYztMzncPuervhbkszDhOo44eAoKhx8pC4edeB8wmoOwwLPzYWPI4QAs4VxyXKSPrw6yxGT2+2D5exItONwud4Arw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 09:28:02 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> The size of a pcpu allocation can be interpreted in two ways:
> 1. The size of the allocation attributable to a single CPU.
> 2. The total size of the allocation across all CPUs, including the
>    allocation overhead (for obj_cgroup membership).
> 
> In most accounting paths for percpu memory, we need the second
> definition (total size). Make this more obvious by coalescing the
> callers of pcpu_obj_full_size().
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

This is a follow-up to Harry's fix [1] and is intended for the next
cycle. Sorry that I did not make this clear in the original patch!

[1] https://lore.kernel.org/linux-mm/20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org/

