Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AB5606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=S5tFMm6/
Received: by kanga.kvack.org (Postfix)
	id E3CBA6B05B2; Mon,  9 Nov 2026 11:28:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13F06B05B5; Mon,  9 Nov 2026 11:28:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A1B6B05B8; Mon,  9 Nov 2026 11:28:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B164A6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:28:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3BE0C40731
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:28:26 +0000 (UTC)
X-FDA: 85416113412.15.E6E7272
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id EC50740006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:28:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="S5tFMm6/";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794241704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXXU/zrEl8TcSV2xj8OBdFZs1lPljfbXu/prQveYVIU=;
	b=yfOLBNSh0HFZw8GHG3QjExSP8OvbVK/RpQHRFSCcpM2503lC8BM7IKctbDPAO6vq9UILfh
	xa4aaP01V/dnvtNrXZoECwCj4Kyu5bjgTzPBL0jNi+Kh+INWUJzAkAlScyd6+VvMWOMegy
	omw6BC2x5v/PXXN/y2boafU8EbYklss=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="S5tFMm6/";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794241704;
	b=CIxNKrEF4adWGLdqalJfwFR2dFwzLpu/cHkDabpJEJZuDMyHilCXnTcVJO5I1JHcGQ3j4k
	LhZLKTBcmVsxwxZiXP/65YewVhq1u2BHKmyyyP3olZnC3fn+klWeAftlFPDzx2l0/xhDfN
	jPlqjI3Er3BXpN1SKcMNPrSy8nR0qvI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso2463934a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794241702; x=1794846502; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXXU/zrEl8TcSV2xj8OBdFZs1lPljfbXu/prQveYVIU=;
        b=S5tFMm6/lMUE6cZbh36AuZ7kEzmYM2ZpPEivUyBWcYf6qRPp78gjirqjc7tQNMlRDu
         vY6CYfY81rSo/qhdEdbZug1mqhRIZJK1GcvC3q2c6kBktrCARgQWhui88ZvTVT1QitLU
         bIJNoiHenhUEkcoSgn7/PlLwMN+WF40Y4JzXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794241702; x=1794846502;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RXXU/zrEl8TcSV2xj8OBdFZs1lPljfbXu/prQveYVIU=;
        b=nRyfIF/uZEZpFTwq89juWWTy91fGAiFMfS+RnWHrbcQkuAl9bDzWpBKja8qcQFYCzk
         Uhss7dFNeinKgKf77kuJN/CQYvTRxDiI23Aeq+fakSbPWdCOB1uSx7Maxle/cCH1rRxx
         A+0M3vTLawdUD20C4M7QmUFiOy2ZbrymZ8sz+Yuyhq1rMsHAZHdMYsdhV370oVqWsdXi
         s7N36oxY5QYZOYfEIR7qZsR01yPf+M8uX8ApjXRkx4L/lAYPnJtoN7/Nw4mBho2HcTZ2
         qSOTLThZNA/L2s8s0pC/u5Jp2H8Pj3ngXfyTNQbio+wJFwWe32YyvsySYYtAIDDvm+zP
         Cmbg==
X-Forwarded-Encrypted: i=1; AL+hErGZOfUfo47RBiqy8hlZg47pNggS03EshYcfCdCqRFgArSJDfZGILLd8K7ComTTZ8gCHohM7OTAR+w==@kvack.org
X-Gm-Message-State: APuU4Z/6JEW4YEhzxw0TIOhlXBrwM0zYqiuQKbgVizRND2JAtdbyji2O
	708BNv7tRDwd9cGp9v89irOl3TNEkP+hZu14fWPgYr2xmlmR8REXRjDrlAq7wej3pdilNbhk0hK
	UVG//1JM=
X-Gm-Gg: AYBFou0/SVQsbU3lFFH7SGwvsl460GP5SZrt0mdUr0BJYwoa7+GtyrfkE3hLJxT4weg
	sL9kaUMbYiu8M6hWV6BmBIJj69cZzPLnbXIf1drL8MpCwg4mkE8DSkMMJfW2l2SLcCe4vc23wI/
	D8jB8yAaKAu25hOGlYoe5d8XfYorxahXOkFTDWkuQ6wbFG47Fq3gllaDcTg4Eq0g3dZ4jRuJWSV
	EBaMJz+/+VGxCDGrixNGxAtpRDzECs4+dR3JDisLzx89WYLNw4d1UPbGiaP82KBbVngM7ErMUz1
	tdqETNFB58Ph4/DLtphHeAxHC+cn28DaN6oAhQdGmLaGE/+PYEa52S0c2XO51wXVanXFGQHKGD0
	zLE8RZC5ZY6MyRdJ5kd5anjAqzoTeL0RUn3DaRk8vIW3GFPT9nmrN5MQXstBpLIjY7Ai7NN0kSY
	jq2Te1tC3YnSJ2mQIF0rpeBA7VG1K1Vdw+iPlwuB+ZZTtLIWw/D3BA7eN88y5cErYuJOlFXpHhV
	RK4koqHK5DPjP0EM1+nxwjLKvXhbNZuYUxy0BuH4kzI38u7dfzytTH8QMuMmWbjLKUx6SC9MBFS
	QkUqLvF1WN7zHX1XqcNslU0X2P6Wyba5v8iJpnWoZqQ6YlHK4kjSDRgp1RN3p0OcCZwCYYWgUKn
	yMnrvWdrazxdy4hdOB94pWbE=
X-Received: by 2002:a05:6402:c4d9:10b0:6b5:962e:e00f with SMTP id 4fb4d7f45d1cf-6b7564f47e5mr78673a12.28.1794241702218;
        Mon, 09 Nov 2026 08:28:22 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ed3ed1sm1810095a12.24.2026.11.09.08.28.20
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 08:28:21 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4395d31228so145013766b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:28:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEcDS9Ne5VWXI02xyR0e0dumZpDeHB0F4EyJqXfaaJnxGHZsIkyqpoquzUU+oMRo4ogGYaPoy8xbg==@kvack.org
X-Received: by 2002:a17:907:d23:b0:c4d:4ce1:e2b7 with SMTP id
 a640c23a62f3a-c4d6db81591mr423916266b.34.1794241699892; Mon, 09 Nov 2026
 08:28:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104130118.2507513-1-kas@kernel.org> <20261104130118.2507513-4-kas@kernel.org>
 <f21433af-afc6-4a8f-8d2d-3a377cd3bd6e@kernel.org>
In-Reply-To: <f21433af-afc6-4a8f-8d2d-3a377cd3bd6e@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 08:28:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=whn=xc9J3qApHWRGTaBpwVRtGbvJ0LURGF=dqC9B3swUw@mail.gmail.com>
X-Gm-Features: AclHuK-PHrKxDKHmHgqeqU9KXvHFHYbJyk2lhNjfjS1J1daidL5w5IKJYicIRls
Message-ID: <CAHk-=whn=xc9J3qApHWRGTaBpwVRtGbvJ0LURGF=dqC9B3swUw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/18] fuse: don't move a folio with PG_rcu_free
 into a fuse file
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Luis Chamberlain <mcgrof@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC50740006
X-Stat-Signature: 8a4jecu8u1wwx8cpi994pkab38a36xx5
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794241703-464845
X-HE-Meta: U2FsdGVkX1/RVghDl0sxYFbWgFhDVNbqwea8jdXM8Dx+41soCnHN2bx/eMU/ietKrfw6S61AhEmsI494nEKL82Psjd0y1qSWXB6Qo0gH5/U8MsenVmBaLLpuiO/qs/89n8d6WaElyV3az7T8SO0aWmNC0HETl7aD1LaUyg5aII6TCpRRVjlMn4LH464sNCGtQtcn3K6caIyw7ur3tYSnG47zlLgVSuyNYBsw9MK35A9Xdc0cYBww7MFfJ+RR75kGwOrLuwM13ROHy5cYGnhkbyZpVoaqP4V3Ich78Tz//l5aZc2bLxuSgyQXJjUC0WrLGgiZwN1w3WyQhPbObcRqGUKP1GB4A6renrpaT3WIatdklZmRDCjyKuhP76ENZJr1CWkiG+OTxaqJ80hpIsKXoGocv8MPTKuHSDvZjxMhnyf09X/5fYZf0LUFmVMKp4HJzMFN/XyBGmDCzypx2B9Slbd5frSoTQX9g4fIyL4kPsbCf7ZdJygwsWR1be6Y/sek2MeFFyE1rywob+Cg7qQSJFo6a+dj2tnpEYy0fAFtOIAzw8VJo8VqwG1bCAos/PvyjKAg5FMiLQseed7zrOMXRuteL8WBuLTchmF+Y2aNw0GkQzscmLFJLKR8yCZFMh+/ZzLILkLNorPRKqA7TzBAaaeO5dGsfO6eU+h9IA6llGg332EYa30v0yHYrGnJFG24wrLbCivKvx6tJcqIr2Duqgi6Bz9dkOinKQv/Vv7AvA9ODCHwnBOBW4jOHpV/ieZ/tsbXdU6+KWG3tGFsUsC0nla3CO0bCekygfvxHdSudMBBwZzuly5UFmUTrnps9K/ZKIsjTN6+nTGdmDeofRFmOOvay1IGiQOyaaOc0xXkutqcDfnIGxN0bZzeU5p31nbBz/9kL78zMuIuaT+cCOEKiDoWnh74LrURTtEcEBZxlA29Q3DPij/oDuO8NE62AQpk4ZkWMNcGxpysWFl2fHG
 N3ULf2Dp
 HvsbzdmGyVNSeTH7J0WCG7ktPM5XT3/niDdPWnBOVBTRN/JmHusfcYHmWeYExNbbkexkwJJxyx9z3GXljB/zckwOEnZWqFZmBvhU8V9/WZdtBLMjdV717yUGeM0+8S71V+BVkZsV64zq3X/A4PPHuEBOKWzf9wot+UaDoSpcuJUbGDApbq8pnUNoCuh9adcGMW3yNjJvZBWLJNpjN1BP1HbZJ3Oj3fIafMEnADJFiwmf9tycbYp7VhsEDGLfqFrDYgPOhAy8Zhn0I95v0ALmiUNCfhxkqBaD2XIvXnfyr+Z4Um/a8Sw4M8QvCqv5Zchfg4Ucigk/zHyLcmsUakR8JSrCd1Pt+a/nMUfqt75fYwT4lZGAJr+hr7iSVkwt5S7btJF6819c5mptI7e3xHrulNClL8JDdGAINhH1/0Xz4gYwCg8O9KpjWfnfjHWWmX3WcwXpq3ry4/cekUMtwdpcI3RIYFLpzRCECOL/h2tUedsMF5Bf6LHhHHy7u3JrLLbtoVQING0AwfMAKsRyhbMoqDeX7ubrF4m3w1byrIgmX+MIiYvYsO05dgPx8ppCBZFE9AySlr2DqTnYZ/24/AVH46tg1Oug8zUoWxaunUBhN5dTcbW5Ov/mHEFagVp1DFuhyCoNI5m2UdwjDuqMmKmToghw92Lr6o2OFHmNHiPm/u9iIQCrCebepx7khhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 at 06:46, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> Could we get rid of fuse_try_move_folio() entirely?

Please. That would be great.

              Linus

