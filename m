Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E2D6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E3F6B00F0; Mon, 17 Aug 2026 10:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6E76B0171; Mon, 17 Aug 2026 10:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C436B041D; Mon, 17 Aug 2026 10:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA0706B00F0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:10:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E2EEC078A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:10:05 +0000 (UTC)
X-FDA: 85110945570.04.1B0E928
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4BA52180002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:10:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="OPU/nTh2";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MKoSFy0sjpfHZygpH5fwT4llQ68LAYzLIxwAjtZT14=;
	b=kEG/nbyZLs40aTR5Z8ICuoLSc5K3gNVqvNWuETUrrKXQkgBPD6YhFKGfoQrv0scC8Q30mX
	b33AF6zX5Z3DKBJVaLSDBvTPLm8WaOdkM2Y0IqlQ4JehyDS7IQCNCoC8B8KbtKLBlL+mL0
	C5mAE84UWC8oLwo0KMbVvhiJ3TqfMz0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="OPU/nTh2";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975803;
	b=fI6L2HCXzUgI7l1RrGlWq4MN502SLJpqPsvF97jnXrFWW57xdlqtM07ewizh9/pu01UGS0
	X251WsLidBj2nnrqleLpqQGDt3WY5OgAxCxlQ8aomRPnrlmXURlKb5dwLgembYaZDtzEQH
	Jh+VZaMnF1xMnf7+esTlUU29rBjlAWw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49978908b35so26960295e9.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786975802; x=1787580602; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8MKoSFy0sjpfHZygpH5fwT4llQ68LAYzLIxwAjtZT14=;
        b=OPU/nTh2odVUu935C+ig/u4Q+/BjT0FXCtnXGNF+ajp6e4qnXQpw4zTs95gR/4Zk0K
         JoNt4GJeiraMd1kxmWa/TmU3nBYnQ5FChThFAQ8F1PtfHfr7QF9z1nq/L6jn5i1aTBbd
         xrncR6zdu8/fQ2/pX5fpa+yaglEP3kkXlvJJkvIAAJDm/uKlIfwX2ySnJoBqU5bA2kcD
         InRVyVpSKMq+iLlWVhId18+xI3XS/zC4hcZ8bahCFRr8qiMC67BDq7yYJGE8MJWfa/1R
         QfLo1pmuhy/MQ5bPGBo8hJ1yKQgHY8dEr+DuyO514IR+uuiMCTDhfA55oTBuG7RMbA9M
         o+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786975802; x=1787580602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8MKoSFy0sjpfHZygpH5fwT4llQ68LAYzLIxwAjtZT14=;
        b=tFwiWf4WAgNwIixrOpjkiFqOiC6FCdckDT8RPBBlbUbwFSmg9a2uxGztTR5XsIoRnN
         SEK57Z4/x5fBsAePBdryaW7g4yy8Si0TRXN96WZCeUxIQymhkUJqhCsOT4jOTesWejkT
         n2vUA2gfgYlo0KhPoheegWXjeUwuXFFmYbaoVdDnDFB3+SJE9O2B/l0v9Yoe18ozchNL
         +v2GfYwVdE45s9SAxI/SsFNw0OQmcJbM60b24DfDFUkXhw0nrZVrXtMrJ6OPK+CK1I/+
         qX1pyf+VxW1Sp7A4PR4s0aSrmLA5oppVSwn1IESRFJl9Ks3TEzFPrreYyfqasP0wFc9Q
         i2sQ==
X-Forwarded-Encrypted: i=1; AHgh+RrYRsv48PDHAyyb3Z+0O6zoA+4lM18yt5Qf3ZKhiBf5B27ZyNo3gF70NPW+IQSDgiAPrTabbPUCeA==@kvack.org
X-Gm-Message-State: AOJu0YyCDDGMh1TZwCfOKIy6ktIascHjZxtVMbM9THF6BZRXpohzpaW2
	ZhIKmFh0k2k9tcaAF4chKyvj/GLV1HZaYwUC2bjmLR6blwsFfpfdghaNo1j4bx4iIzY=
X-Gm-Gg: AR+sD12bNdAkp9ivMX34cGJcvODZgaNzNL1F2uPQ5XEbzPlGG1l66ahxJtEei0Mea5D
	BNqJo+uNe+8Da0qP32H2RoSN8IwJtewemEeRyWQq1yMcGdWajwBYbDAbOysHKFjKr1Uo9/EHxBj
	jAoRWaNHaPhQG1EhkFkEb8NnOaLMwik/dBc/kXLRJf77fVVnWC1rvKieV7VvOzw1uWPHUBrLYMf
	dHzdLCp/Jxnnzg+xYAJpFjYOabyDJW/FZdd3iRJiIs5qzeTpWrTZaiEE6O9SYGP0Zm9pTqKXrtV
	lx6A7s5s0TMBZgaWNlotMZ4MfrI39JE270GaCjnT9cgPG1fIcgiEmrKSZCqhMj49r6cmotCc3AM
	bIJi5JJiabpvBgb7rSgU9qkkGxfAqUiVDaDdInvuDgLLF4GeayANAGmXsdKvzYtYtIS22Z2q1ZB
	2LfIQA3fr6/G5oUdvlZMAFEnp7j0c/X7JaKmDp+X4xLaddEEJyOxYKZN8GDHA2YQUuh95Vt6w=
X-Received: by 2002:a05:600c:3b8f:b0:495:4491:b8c2 with SMTP id 5b1f17b1804b1-499906ce446mr290282905e9.3.1786975801738;
        Mon, 17 Aug 2026 07:10:01 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d078523sm45861335e9.6.2026.08.17.07.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:10:01 -0700 (PDT)
Date: Mon, 17 Aug 2026 16:10:00 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, audra@redhat.com, bingfangguo@tencent.com,
	cgroups@vger.kernel.org, hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoMWOILN9A-GgXJN@tiehlicka>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn>
 <aoMMr6kEX7pW1dSF@tiehlicka>
 <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
X-Stat-Signature: 76uk9u3krjjwpyfzdj7n3k6f3g4dwrfq
X-Rspamd-Queue-Id: 4BA52180002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786975803-829313
X-HE-Meta: U2FsdGVkX19TWVXQjihaqT5igoydYW1VEa4RSvktIbbSk4VCg21iLv4XhEpsQawGrwCZxgTD34kvx/Of3IEkoXaRl5YdMBjCyNK5PlC/Fa30c2z+o/CEvWWdJZUcLBo267w9LsdPJxroAG70QnEHw/bjpGEpe2lbcJ+4o8rhkC6uKMUtFB6w5MKSBL34KY2fUkKLo6EPQJ03X1Y6cusqbg0a7TUTzQnMApZbgia68bWzljpFBsjQjU6SY4UadOVfzVYE2E3tCUhnyohnln8a9jHC89Rr42FHEPlO53QiNjGONCpaewOIxtNJigNpHqQqgZyExMcQ8zVQDMXHFYlTE+LkglH8cJisvsE0kJaDeH0UT2xQb9hZBdhoIDnjQ/tEtjE80PBHDz6AZ9/8B5zqzsbgQfWnE1jsbHrdP6tI0SttGG3i1sbAYkRa0wNhP4b8Fq7jYWapnG3hFTL/yoYA65UyQW4g1XWWQ/ZCgniYLQ8s+03M625wviGESh0KIhUn8rHlcC3iFA8xZJcOCUojQLUfBa9tW0i1c54chWSnjE0e+VViLCtLKeIHt6oDUfFYvCO1M0cBbMBdOXMWilmHTsTGdtHXzS+r972CuwJrTrjneWiAeOe5xLPtU0D9WFX4fqqpMktiJaKdARcQLGNOCE3N+nRR9AVsFt+5YZLDIedSniNCkrYK9tzbFq//Gg78Cdg2rcKbF0ci/xHoSRM+O10KH9/i+hG0+6x+WvkeJR2w15vl7YdDeQchStfo2V5yI1dpycBPrb+Xsn1qI42FcoPwfcOfUMAPFNe+4o4JxXkwbYMsqGz7+aqFMpcxtoH4PYDnXg3XJ9AJh3opcmnWxM902I5cwDgdO9YDFOtf9BW3HuJdKHQ9RdtN9X2fxI4RpA5eCyEJ6hLqT06OsA0nHroeoajRVn892pS4sjIQ3+mfGEmOXjL3+A4C8wRqk8Zp0XaKtac3F0yD5P0GBtX
 K8xobFtm
 AdZopqsIPT6lYXL8GDnoNuWaNNPlyLBpZocTAOWPyeJy0gIAej61c7vQJImjPfn0DtDyOBvamFTHN7Aw4CMi9nyK67eZZwd/gpj9C6qsTg8U4c2nTX915qxZEKX0YdyFGYGP4KqiDuBQgXpOWhVZtHls8cOUY4dxXmFnjVr2YeDciOqAED9hjI+zPH2S9YLAP9xiYf1Xzq34fPUTwBhSxm/7hfL2FOILqTEYU0DxVxifqxgxp9XXgvs6K6DKrGv4pKDV8Dl7NR/vr8TxqaKSM7qbOfjAc/qAdRELqT03PonmpSjj9vlGhWouE0vOpAjClTJHcu3qiD1JjCqZ9JoC94+cGcJ9u2Up62l9FaB5tWs5lx0x1GjleZnGzIeU2f2MGwn9EJfAsv+pMbL59bgEueDLC4cf3q98NqwAL8GV9XIa7LvkKIp/9hS7z116g0uKGKVzH4+E0Q+057Sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 21:58:39, Song Hu wrote:
> Hi,Michal
> 
> 在 2026/8/17 21:29, Michal Hocko 写道:
> > On Mon 17-08-26 21:12:21, Song Hu wrote:
> >> On Mon 17-08-26, Michal Hocko wrote:
> >>> Is there any specific reason why the memcg stays in the cache slot
> >>> without any pages?
> >>
> >> consume_stock() doesn't release the slot when nr_pages hits zero.  It
> >> is kept for the next charge of the same task and only gets displaced
> >> by a charge under a different memcg or by CPU hotplug.  The problem is
> >> that the offlining drain skips empty slots, so the css reference they
> >> hold is never dropped unless something unrelated displaces them.
> > 
> > This doesn't answer my question, really, does it? Is there any good
> > reason for this implementation? Why do we need to drop references
> > remotely when we can do so when the last cached charge is consumed?
> > 
> 
> Fair enough.  There is no strong reason.  Keeping the slot
> populated after the last page is consumed only saves a
> css_get()/css_put() pair when the same memcg charges again on that
> CPU - a micro-optimization from the original single-slot
> implementation.

This would also allow more effective use of the stock because it
wouldn't need to throw other stock away when refilling.

-- 
Michal Hocko
SUSE Labs

