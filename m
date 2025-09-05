Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF99CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 20:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E876B000E; Fri,  5 Sep 2025 16:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975F46B0010; Fri,  5 Sep 2025 16:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3336B0011; Fri,  5 Sep 2025 16:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79D6A6B000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:32:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A9FDC0319
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:32:08 +0000 (UTC)
X-FDA: 83856343536.12.6172111
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01C7D1C0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:32:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eScJ5EMK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=yepeilin@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757104326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rE2X3Vn9vpM3bBx0U9aQSQRZhcHyw78s70MoLQoZ7Q=;
	b=DEDDTenoJt4Zwe0c4Thx8PfSsOUK3PCXYX3RYWhc0T0KPG0HybmGzqxxnkYMVlUuEFAwFp
	/fsPSgdEyY1NNPUNBMA2ySK+rMLWS0aok2/cnjVBDe4upUsLm1B/mBwk16R4GfzQhcGdY0
	xrRm6sk6jc0WUkcJdgUNq+uL//G8stM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eScJ5EMK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=yepeilin@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757104326; a=rsa-sha256;
	cv=none;
	b=xEM+g2GKox84F33K8TP3OsemjjlzryOX6kgP52tnWcOQmWlUtJJwcSaAPcHbBdbQUssu2d
	hSuY8NBBRF3JwKnh2FMqcBZrobGI00Lyb4wDfCL7X+uiS0awN85mc94n/KX1OEbuREfxx5
	lgOoRvuVHY9HX14s+FWxVRb17xuL9Jo=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24cf5bcfb60so38535ad.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 13:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757104325; x=1757709125; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3rE2X3Vn9vpM3bBx0U9aQSQRZhcHyw78s70MoLQoZ7Q=;
        b=eScJ5EMK7ZwG1oJiz3mFA9Ai+Gd60nN9CrQnlK3zfRV17t/JfymY5KgJVBirPXUO1k
         HHGpfPsNN61GbfEvYLGCIiJGo+T/xkMmo1auLh6ThFENhxedP4jf6rReht5w6h25a/CZ
         Eqwz6ykjrHgacGC5tUSVRVWOmfa4ItpCdm2Qp2BsuVTXrOzlDvCEbXlBTfWJiNkGltX9
         fGmux88bkBX/q4VPgwDlfjpZK3zJeiOkT/tSpa7yF7C2ieltWZrYG9SchKnkOb2skzxy
         z4k4dAOn+xmHtrWRpSQFkqQbYeO206A/nHm6K1QHtO8ZRt4ul/BkjyFqHZt9niyBE7pM
         wZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757104325; x=1757709125;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rE2X3Vn9vpM3bBx0U9aQSQRZhcHyw78s70MoLQoZ7Q=;
        b=Qs5mWgtlrSiPUtlAbob6ZbJTV5Tv+FU9wdz9MbmeZui2gXKwV3CMfdG9KJHAOBPro2
         +zO5dSGvuR2jQxYCv0OUum6pNXFWNFIwJ0kjVM/lhjewK97NTsllSXPMLTmrM7furQkT
         ujmGNv179u1Zum/AagUkuz/Sb0XnS1o7D7mMJ6ANcfeElHjLbW1Ai9sgW7PnNrXyFBcg
         xk7edfodsgXZGib9oB2iYy/Z7KSbNt/u+7loiqEPjBWkeJC98If9XR6U262RBanwLOCy
         YZMNfrZ9WecbDQsp+jhe219HbSSJp7sgYmoX2MCkZzNe4KTLZRjWnzo5zMDnEs3eCkdk
         aJcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwbSRNYElec4vWOJc+ONPJUvfpSOzX2wGCzIh3eMHkcmfOpCxW0g7qb6gsA+BO1JxJNA/C53bdpA==@kvack.org
X-Gm-Message-State: AOJu0YyZeWwdIkcM4oj+i64jo+cfCjR9BznAoZq4IXZO+IbKuqbuTOS6
	YpVUHvtMxLoSgFapO4B7pQyo1EhWRrq9s6UPaPtkLRmDlX1X0mqgJ6DNZvD6t8aHIA==
X-Gm-Gg: ASbGncvvs1wi0fwjW5xKxIzSg6ZWdMJxrZbyLG3TCHfpcoOIg5JENXOHYctiTw5Nn4Y
	8b/T227kJSg0to8eVqJwJ2ETEmlKxmYFiWSLPy61vQYDE8Ia3t7mIjEfFht37QcrUtBcrzVsvVX
	bZnM73pryIqJ0uAmf2IzVdUuqGVsBIfxQ3GvB8BzCktRCgZtI18KN3zSzOMI9ycSfTUfH+BSbch
	02OGEqUFn2NexWRV4KOakQBoWK9OpPtIRpURaSzRtaJ5WZ3hMAB6j4sYCLF/5mHchggwyoVrbQn
	vmG45wir82DyRgV3/No8cC4mZaUTAoQyGDPCk4iFkycCFmfcfiiaYzxFg2CmQprTVYRx+x8uRYV
	iM3RzsdOzxgbj0Jp+S6oXZj72GBKntSX8NJu0q5WjiXEYrembN9eBGxozY6Y0MLBPO5k=
X-Google-Smtp-Source: AGHT+IFFrWt6dAX9iTLze8nqy7migWMdscannmAjNvF822+axMi7X73z5ZFWeLHyKsVHaoS51AhcZQ==
X-Received: by 2002:a17:903:186:b0:24c:863a:4ccc with SMTP id d9443c01a7336-25114efbaaamr727865ad.4.1757104324449;
        Fri, 05 Sep 2025 13:32:04 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b2570d0easm102354145ad.82.2025.09.05.13.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:32:04 -0700 (PDT)
Date: Fri, 5 Sep 2025 20:31:58 +0000
From: Peilin Ye <yepeilin@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Skip memcg accounting in
 __bpf_async_init()
Message-ID: <aLtIvvxmjTkZC55H@google.com>
References: <20250905061919.439648-1-yepeilin@google.com>
 <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
 <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
 <yl3kolod3l5ejeuqhfzv6o5lrpgx3jpthodpkihkbkp2nntit7@qnnd2p7i4j7u>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yl3kolod3l5ejeuqhfzv6o5lrpgx3jpthodpkihkbkp2nntit7@qnnd2p7i4j7u>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01C7D1C0010
X-Stat-Signature: 83cf47ujman4p4tp14ca6mipk9cmxm8c
X-Rspam-User: 
X-HE-Tag: 1757104325-554325
X-HE-Meta: U2FsdGVkX1+acQeZTbKIRKY7s0vvlacS1aEaqjzCwGlB7F8i/WlqB+C0uo66Yhzx5mvR01hrytAkr3gqbzL3J9VrXLJwWD034TcQctYgmYny3lJS1499VZwtDBBbVPosagwOqgxuI0OB26AWtZPgcXcgyBcqJaVeX/McCkEgOWzaXPQPmILKE3zyDdM3cg5clkjJwK60th/Of68AWLbPG3ZiTLCVPiHeEBFxytOPaENnoycf3kl+VLwushkHpFex7yiVLu4DMQJKFPbhUCSzYDBQ+2bev2MIM70c103BWaA53SauFi93byhnl1BCFahtlMW4dSNCok3sY+DHQTJdCwbjc1WhM0lycA6oxPLIyYnXSOk6Bz+ZKL9uTkkLq+NdNZxV1Ukf3ysU6ostqo644PZK/RnkuQh0ruSEBzCHKik9PzB3m6XLJMWaZH4O9g+cSqGKstk8xvplo8o/p86OAQ5ke5pvJEqmtwFfu+hQ+K8liyW5AaVelEoXwwHOPGbnSkUmhOBDNPB2O5HmNNqgw0l0lb70YhIc75/s1QBMyh39hpqNS5FMI3e3ajKpMjnFAQ049TmXopID5gZteh1IffPv6To7loXHUO9pDsOLhRp0Ys4PlQF6/92S4A/mdBJ+k6j+aL9eClq7ERNHs9fjeog0w9KG3p1zgB6KIx64ImBLGm+3dXZ/3ZfoLgez3uXpdS7pF0MdoZovCpTVZUg7EFbzfArQw3HcuDDEcXdpqL7e55v2H0K8/0zqbaAXLQFNqLym5vHX+vVRNLFEVM0aQkB8X9POAtegwf/ofvTSKzxwE4YZ4H3qYz7EMtmDMUuIDMv2F9PMmuxUD+XosWekX/5Em5VxXHfbSplP0AJ/h/tAj9jgIpaG5L3FHNTpATtlEi3ozkv+3VBDC4qkkx9JlWL+iKHAFnlekAK4GB4qDSw7ZscC4HhgDactdeHqvIYBXbrsQ7SikcXY1dOZo7X
 0sHOXLSE
 3hrQ9kteJwmO+h4qZiZFCMbMO+AcHHRBGWI9NoaWbsGsXLSYEm2m4MHoG/OWJbpqV9Ff9hLNmU3VCMGK8ZX2/nZ9xSn0NBqLqPk7HU5LHS2+paVCwmC3MI85V4FxjC2+7zkfdXBmShBmHSMvj8606kfwfITDJHI9mO0IFFm6EgBPEYG1AwBXJthikGMuqINrtZ3Kc35hmcSa5fT+5LPDARj62FSSdyz+Qp9aR/Taw4fO8Q4ewkL0tJCTUGDohHefx+L9byqnEkXKIkxMDVZmEJEO/UZ+7yVY2snN3BG8qx+UFijoYOQ1qaK8026/WMA5Low6VbCDYnyuiUu9bpQ3E/iJ9DMOAWj71biKYJZZGaID08RaFwbXA1y5CrEoncfGit2bCPw070rU1BYi+IecJgOieja8Hb/bei9t5lLqaSlLBIb4cqGh0LHVKAkRCpy1SlNLSn9cxBQ+gD4hwvtXHeF3pxwLOnnIrTwCkuidSm5xpo74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 12:48:11PM -0700, Shakeel Butt wrote:
> On Fri, Sep 05, 2025 at 10:31:07AM -0700, Shakeel Butt wrote:
> > On Fri, Sep 05, 2025 at 08:18:25AM -0700, Alexei Starovoitov wrote:
> > > On Thu, Sep 4, 2025 at 11:20 PM Peilin Ye <yepeilin@google.com> wrote:
> > > > As pointed out by Kumar, we can use bpf_mem_alloc() and friends for
> > > > bpf_hrtimer and bpf_work, to skip memcg accounting.
> > > 
> > > This is a short term workaround that we shouldn't take.
> > > Long term bpf_mem_alloc() will use kmalloc_nolock() and
> > > memcg accounting that was already made to work from any context
> > > except that the path of memcg_memory_event() wasn't converted.
> > > 
> > > Shakeel,
> > > 
> > > Any suggestions how memcg_memory_event()->cgroup_file_notify()
> > > can be fixed?
> > > Can we just trylock and skip the event?
> > 
> > Will !gfpflags_allow_spinning(gfp_mask) be able to detect such call
> > chains? If yes, then we can change memcg_memory_event() to skip calls to
> > cgroup_file_notify() if spinning is not allowed.
> 
> Along with using __GFP_HIGH instead of GFP_ATOMIC in __bpf_async_init()

Ah, I see, thanks for the suggestion - I'll send a separate patch to do
this.

Peilin Ye


