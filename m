Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E96EDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 02:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F1B6B0088; Tue,  3 Mar 2026 21:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D4D6B0089; Tue,  3 Mar 2026 21:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21EF16B008A; Tue,  3 Mar 2026 21:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD9C6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:49:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 905F8C1A85
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:49:41 +0000 (UTC)
X-FDA: 84506850162.22.6F3E96A
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3901C0007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:49:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1pIU0LxF;
	spf=pass (imf28.hostedemail.com: domain of 3wZ2naQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3wZ2naQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772592579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlfxAiLCYE9X+ss6Nds/jzCWOjzdQvgrRAY6r5Hx7j0=;
	b=PV1y5QIlmDsWA7P20JnwR9IsuT0yqKcjXo83bskS/czFidnfFes1o23GU1+DEXAjvMm+DL
	IJFk4NimxtRM5gWjHrgxP8Av9oQ+O8QEmeSX/F0pOnN0vf+Gvc7+Bhi/9jACYwFeAZvkpO
	Vw7GKS5jxz4PuwN/8lU24V/sufeYBi4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772592579; a=rsa-sha256;
	cv=none;
	b=kPyTTHGuh1xaipFquALxvDhH3XAMnTBC4fsdT/Bt0lXEdyBSDjHOXdNT41hz/XWFK6MkxF
	jIyzkoXlZiwbgXcNR1NbgH0Dx1Y2xXo92StbMl5Nhu3P/uP0/hDDWL4uM5TBiF+uOEto0l
	uiRNpYJ7leh6nsVriD2Q7NnEYokpyhc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1pIU0LxF;
	spf=pass (imf28.hostedemail.com: domain of 3wZ2naQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3wZ2naQYKCO4iUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4a6bb316so32261825ad.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 18:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772592579; x=1773197379; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wlfxAiLCYE9X+ss6Nds/jzCWOjzdQvgrRAY6r5Hx7j0=;
        b=1pIU0LxFQl8cZtovs+q8N9d1gjT6qpzvzWMOpKlbpMPfrNah7wRF8s4MdWxndBFdzn
         ur6qKGmkOh7jd1mRmf/TagdKNHsNG0r3ksc+F11C8jay2ggsGLnuahulpzuuXY8+r+X+
         Xx5rKgy6zdeZkMKdjL1ibvgzq/FkLZgIguLLjbLwg8SS4WeD6uoTXBTzTuRRV/jNnZFq
         IEOwxH+D/gf557qsScYhZy7M90i9JbElDmge/5UwL1Vl8wz5IsjTsK8Z4K+/sM9Sdnp9
         zPiytRG9aDf1yzrUUKW2JszJB8aptQd4XSiqMhDiFaO/XB+3MhCuH5cTK/B3eWG20Tlz
         t4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772592579; x=1773197379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlfxAiLCYE9X+ss6Nds/jzCWOjzdQvgrRAY6r5Hx7j0=;
        b=pa7aDdjOPrvg+LkFoODJvLPPbzziU90VL2yPaiqLmLlgoTe3n1CfC6IeaAcMPThidh
         aqN4oVWGrWwLXj0O71U08ge56Gnc5p9eF9gz61ranY/S8gqk4o3AYH94BsDYL6sBkiin
         HGVXe1SDY27G0kuj+4UsZ890oyW6hfx3vFnJheKButCvOVMfDygozKQHvRL4SIn/Ha93
         mspheFDmAjSSlLF7tr8yvvtDbnkxLtTvpDl9xXsa6RPM1U8+Qfli7VYnLkTrKSPFw5f+
         zl7V7rAAc47naaCgpyncxYKITaAvQdEWOhH8YLnoT8GEekCe6T7Gv4qgR1/1LEa9DRlA
         ZP3w==
X-Forwarded-Encrypted: i=1; AJvYcCX7qS2/6/8p7z1k4m++ywxU3+1a/S2ZxlZw7dEnR1CjHNXM6j3eQdsvvdpCJPnpYQMoxJb5prOOmg==@kvack.org
X-Gm-Message-State: AOJu0YyKxuGwv58nzZH+XJmkHxpOkUcruZkwBfBpLvXqBwEGHX8j8GVI
	ODRfzndknbKKrQRnWymEEf9mYaeFFXM//xctEerSMHWwNBacVtG0QgF0KAeUEehMRK+glVFJ+Jz
	Y5QjV0g==
X-Received: from plzv9.prod.google.com ([2002:a17:902:b7c9:b0:2ae:6338:73ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2446:b0:2ae:483f:b239
 with SMTP id d9443c01a7336-2ae6aaf9469mr6114485ad.30.1772592577810; Tue, 03
 Mar 2026 18:49:37 -0800 (PST)
Date: Tue, 3 Mar 2026 18:49:36 -0800
In-Reply-To: <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Mime-Version: 1.0
References: <20260304012717.201797-1-ynorov@nvidia.com> <20260303182845.250bb2de@kernel.org>
 <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
Message-ID: <aaedwFwXh9QXS3Ju@google.com>
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
From: Sean Christopherson <seanjc@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jakub Kicinski <kuba@kernel.org>, Yury Norov <ynorov@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexander Duyck <alexanderduyck@fb.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexandra Winter <wintera@linux.ibm.com>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Anna Schumaker <anna@kernel.org>, Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, 
	Carlos Maiolino <cem@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Chao Yu <chao@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Airlie <airlied@gmail.com>, Dominique Martinet <asmadeus@codewreck.org>, 
	Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Dumazet <edumazet@google.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Latchesar Ionkov <lucho@ionkov.net>, 
	Linus Walleij <linusw@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>, 
	Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <pjw@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Simona Vetter <simona@ffwll.ch>, Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
	Zheng Gu <cengku@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	dm-devel@lists.linux.dev, netdev@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-sound@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: 3tadc88ifsa5wd63b7zxww4kxfpkqnhw
X-Rspam-User: 
X-Rspamd-Queue-Id: D3901C0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772592579-665960
X-HE-Meta: U2FsdGVkX18NQJyZWS1vSePjUO2wGmQHrhPXpDEZd7HiobRliTt+Xsu2gFXQRspkLuGJGejGkcnR3MvKlxMW30XYICCQH2GquHSEK9ymstx7YACsh6EumCFJjzYeSHVv8JAmdscqBSmUzeVOBaMj6EdVGwHHPKQTXMuJ++kQSQObYpcFnOsngJTNMaUjvaco3PjCcrPc3M6GqRsv6CeWwvf4qG7RK7yAfBsmU9tGLQ+G7tcH47vnVb9SnWEaQRuuaxLGNKJfzTSNklGc6Y3ugR7zRcgqNc9hNXvG/xVO8TLXMJztXU65dyL9U9QjjcNN0KyeOfpA6kwJEF5fEoo46zC0Hlb695KAfZe2G/jdcij3AyEZuK4T3uvcP4Iv9gix0HMsTPkTExn5yxE58+0MjjCzbMgfWnOyDMyZH9pyj+6PqKP8uXlRQRe1WkvPclWF7pnUtZ0750ZR6sqnenHc/EGPqm7Omyy0j7IUhu/Pz7reAclbZhyhZ4+W08iqEgFCTvWgHzIxDzHLadF9TeBZwpYeLsBkKcHMtNdB6rQ9x92vPB6/HsSORzgjqIDHvFYuVzfoS5MFNn6AGIkRKR2twPwTJVQTXZZEkVxULfnKcWdrNwb8B9hjDnFfl5iABtuwWMmQwBWYwRSwT31+fpIwSINi7TCpEbS1zGXtXf2vcZz7zRgXfDCaa97YxmVv98RdpyCvs1T+diF6axKTnf6jTjzcNRFsvcZBU7e8UgpAGD7GYwBuQYfMWaHBrWicPHLKncJ/uPVDIoty0gr8+1ZCNGKqthwAaIDs1U9ls5jCH1M99GRE4MlM/Z2PxzBlthuku2+7W3hlztY/rzj5iTTTxmRVVkMifEGIOV8QhJdIJ+2Z1m5C1qR0olpTT1mqq9sf+VVfowg+Cu7poPsJ1PmKiVwIKTxf1UJcgL9RRbUiqxENl3YKK7E/+F5M8oiTgQmbjmshChVWZQLj4T2uSaQ
 kI4JR9JB
 lF+MwxVyW91Jisf/Dxq/rIuCWMU7qCpmObUXa4g5K6tbGzuOS7cj361mMV/PorakfM84n130hvff2yOHJO2lma81FszzVtLpSo9fUjE0w5aLs73hQYCdyM0XVJzQfLwdON5+ct5CAqk6cX+Y/6+df6kE7yU3s4skBV1N71onfGX/B69mwgm7ngR1Ia7usRedbw8hqGN3KsI1VIehwMbVbs0H88uFBSowhXAij3hN9esYsIzYmUSkm7oE5otlYs0+mQE/Meu7HXuE1jwDV1HLJHoPMtt62Ps1nReLCN8dSdhq7ec0/ZkSfkpv/K3Urnv7Da+CZlSnBNH31/BUyST9wic4d4ObqkyNoQCe7Upc+DyYpL3umTSIcr9XbO4DzP01zBbh7NDRjyubDbAo8FBbuL+3pj/X/VGW/0pWUVWRMDu/1SkgMUds5i0WvFF6NDjvJQ+D987YufpTcgv880v6/zhL+V3oLOyfTWj5lOdTtj237m5WMrb4Zm+GCV6hBJjeJnPbB3w5rcmGXx+mE786uQlwF1SwDOPJ9iJo5UZ2mho/jQotlNSAVbSV0nbdVQ/roJ0quMLDhacgBi/ZZ6HmMfCgBe5MSSRiiPMNPFnozZ5ml8cVw2sZsgCTCqJ2d8rKuLNZooSIpGOoT6o6ea547lIULhW0nJvzdLM0HV+S1rSTVBbCaFpq9+D1fHpd1OE9M84kg+BY68z2RSfjhSV78Mryc8EId8lSUQ3QlWrylgbjgm5xu10WQbn1qb62LuT/MnbnhJf3ACvYLNRlJifc7E6n7qKCmqBM5tRzwlBV8gta1oZV2cKPtHPr73LzMKFph7xZeuSHckTbHlk1ZdNEJtae1Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026, Jens Axboe wrote:
> On 3/3/26 7:28 PM, Jakub Kicinski wrote:
> > On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
> >> The net/9p networking driver has a handy macro to calculate the
> >> amount of bytes from a given pointer to the end of page. Move it
> >> to core/mm, and apply tree-wide. No functional changes intended.
> >>
> >> This series was originally introduced as a single patch #07/12 in:
> >>
> >> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
> >>
> >> Split it for better granularity and submit separately.
> > 
> > I don't get what the motivation is here. Another helper developers
> > and readers of the code will need to know about just to replace 
> > obvious and easy to comprehend math.
> 
> I fully agree, I had the same thought reading this.

+1 from KVM-land.

