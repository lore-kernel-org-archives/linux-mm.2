Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E1B606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JdB+MP28
Received: by kanga.kvack.org (Postfix)
	id B29276B0B41; Wed, 25 Nov 2026 20:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9E16B0B43; Wed, 25 Nov 2026 20:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB556B0B44; Wed, 25 Nov 2026 20:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 797976B0B41
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:08:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14F47A8C94
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:08:00 +0000 (UTC)
X-FDA: 85475483520.28.AB606C9
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CB9CC0009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:07:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JdB+MP28;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795655278;
	b=dW/JEHF0cJS4QP1l6zEWX+FnGF9Gu1A+45L6SOtg/18euFq/GV+JD//g/E2lEB28Jkh3yL
	D27qnr42v/bPDk+ep+DB5TgSC4LsK41qcZPhhC0taoOxy+l+SRGEUp/Dus39Nu4tHFzuuT
	TMxsgWJNtB6wDnZHs7kpUfmFEXFFzaM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795655278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e+Ouu+6oLoZy2ujzXapWcEGF96bjKcfmd5hC33j504=;
	b=kdIT9D/mZ8evsTAKGuILzHC8IKEckKxDSLMVab+00QI3w/ZJ0qc290NKO/B5zkndupHxjE
	dUpEXMHxTFN3tNeNux+XKDsEAygSD4YW7+21AG8Xcklhgg+k19c+PdBWecIVd4gk+JmN9O
	c5exkv1skgXKegi9XR2bOeqALydr4FM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JdB+MP28;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-89d6bd67045so3038746b3a.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795655277; x=1796260077; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0e+Ouu+6oLoZy2ujzXapWcEGF96bjKcfmd5hC33j504=;
        b=JdB+MP28t72ddArSYnacB7mpN37Go8N5CsQHOyEmKHiskYVH5oAyFxz3IUcs1boLTX
         uAfRbXjufqTmy1gV9l8p1ANykYs4xU9kVIPRumGpVzMADA6i6kDrM4mOfibFiBnew9JS
         ObvYhvBTLAFABQraiCpv7xoD77y79caUK5ygfrFxJu+xxPw5JesqlrJQJ7Z/dXbGUZfi
         HBS8eNztWDb164LrXESaxQPhLIqZ4L/8/QKN/RBOjiPeu6kmjWvKqOuUOZl0BkW7W13d
         3khmSQLe2Xjbvqcj3PXObq1QT6NWHbDNmjtXHEiZH0MgbdLSv9EEMyXzobEcnVlFJaOk
         Bb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795655277; x=1796260077;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0e+Ouu+6oLoZy2ujzXapWcEGF96bjKcfmd5hC33j504=;
        b=l1Xkz4itWminKXLbnRpxx5ce44NUmt9wPp6WZ8YzqeKIG6ZQFbwu3Nwxk5AEkJPvwk
         2aU3fewGwbX4bP4xsD+Bhzze1C9W8nwDhqXofGbqX/QmCLgWN26bgz3mI8kVHnETTvNV
         FzoQlfxocbLN9blnDAvGR80SHyAyWv8//thfAFOJwYwNlv8uhH/6Z9igcQuxANqY/yyp
         uzZZrM6MlVb1KJkL+ZBthkrGXVqYekHhjii4hOEKXMQ+W0PkciTkqdRFQndfE5K+XZuU
         NfDpRq5SNqzdUS3nTJsXvGr5idsYKc1ELNnduWpkkJ6f+tlfo0tIElmFkEonrrk0+wNk
         v4fQ==
X-Forwarded-Encrypted: i=1; AL+hErEQYVemhZe7PlovZOMbzNMuSV1D4I26p5xMxP2BJGiAMkJVwS4687VLbRGrJgMO5qUECl9//aZokQ==@kvack.org
X-Gm-Message-State: APuU4Z+cZlILh6H0qv2TjEt9auO6KO70IH8YfFg95V20ijXJorg2meyE
	EYJH1DlWEvB6NdfTQQNiL4McoTIpjnEkKVuNM2NHVtLKCCgWR/M9etuX
X-Gm-Gg: AZFdTZc5tSQ+G5FwaasPOTXxRDqsoDrmtbdAU51eMaW58R/pbpF8ja2wfPDdAFWfWBI
	nQvoXDLMHyHKsgOO5ZIrRRrxAsKSXhjtJQ6u63kEoXORRjYttXqw/UfMJoD6s8ilYvSfS3KcN5W
	4XC4Ibs0jq89kiph1dD7rrWI8hg14ndl3wOitK9Sl7HHwwPrvTWZoaUqd42HT/nrE7EsVTvKg8w
	yxICM53sfRUf7fC1YjUMIzG/MLuEyBApuvaIaqzxx2oEX5poGID8Xsjt/KfYnkKOdPuU7AcqlzV
	KUm+dG4JYLj+/W1DhTxga+cE7HWLouQX5pUlCEPgZeNMBhHZAMMxrb6D4zjtMu8EsU66bRAwOuy
	mmcNEYP4KMPmheYrZ96ItnaUaR1Vb+iHZ8whw5tY03Ogv8F3e7eAlOQOc8n9isKuHBKRyMGwXP5
	njxBNhuJaAYuqncCY7oYaLyDawEYw4z4+d5C7HwBEtvxLTEKfwcaaSnNHt/1dv7GKTHcH2jAR8V
	t0l5uvJcgg2S/Iux/9CmGxBp/3ZpuwSZ54sC+iBlI+HQ0B2PoUH/hcxrcm/OkqKG4KcMEhifilG
	xV22LjhKDiwpabEz/FuMgNu/DM9sf4QB1sA4kNnGLCUrfyskrpTt3h/KIGNR4OlH6zkKzvltqGr
	zjL2MZ+VaEhlXNgXns+517KPuw7rrFn4D4j8=
X-Received: by 2002:a05:6a00:c08a:20b0:8c7:f59c:e82e with SMTP id d2e1a72fcca58-8c7f59cee72mr10451362b3a.36.1795655276950;
        Wed, 25 Nov 2026 17:07:56 -0800 (PST)
Received: from localhost ([153.61.198.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4c43bsm9633902b3a.26.2026.11.25.17.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 17:07:56 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 01:07:55 +0000
Message-Id: <DN4QO5PPVN0Z.1CO2JSCYRH04R@gmail.com>
Cc: "Emil Tsalapatis" <emil@etsalapatis.com>, <bpf@vger.kernel.org>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <daniel@iogearbox.net>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>, "David Hildenbrand"
 <david@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Will Deacon"
 <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman Long"
 <longman@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>, "Harry Yoo" <harry@kernel.org>
In-Reply-To: <20261125160409.GF2668804@noisy.programming.kicks-ass.net>
References: <20261124060357.11700-1-emil@etsalapatis.com> <20261124060357.11700-2-emil@etsalapatis.com> <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation> <20261125140902.GE2668804@noisy.programming.kicks-ass.net> <awbvek-HS3OJYJGF@thinkstation> <20261125160409.GF2668804@noisy.programming.kicks-ass.net>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CB9CC0009
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: m9yy1p6qkhan443utb1kp79b9wyeoosm
X-HE-Tag: 1795655278-271987
X-HE-Meta: U2FsdGVkX1+i/hk1r94eAY71eBEsFcFgJLt+Wjq9+6BFj3znIb3VYpr13MM3OphKSBuG5hLAXbz2JH3gc3Mg6wD/NqWdYctomMk2B6lHzEdRhyJBaMx0pRUxYOT6kwyIAf0l3O/hRQnRyJYRlEZtSQ4S3gJ+pdxLTSCijT/LS3N1MmCMHpYdIY8S7qzz0NAt26tyYR+3KPlZOP1T/oW8jkIbToigUCGEvFzvYV9/DKdR7WqxU6hVSQwszNmqNmjzGr+vfqAPixeXdIJDSN3DZtwFXYZb8H4PnA8HLLyKtjmGbUqTrU48i/0LhdU4FIGHSWHYbF7SWnvE0i1M9Y+pFuJUpW3LDCzXpWGPqW+xzvIqYlcmBj2tWJO5xd9U1wM50+FU1JeqZDh18avvqUKtyxykA+SZzQ1UnMIaZioYQgQDXkJeELSoAJL9DG5VhYzr5v+KPjusxHtFTyqmgaQNafw/BncVrDcfjomszACG5/97bY+HcJLlHC68/682Ce+9Gr90t1YhGFi8A7qqnfSFReyJvsYkJDsTpFB5ftNc4f7ByvHmuiijLDYFjMilR3z37Iyr4QhpYHYC1njwhfX9+6pJJR/K9d2pvPDCdpq1Zguc/YA1aqy/JzKo5ZuhT2f/FFdWlqnJE9TFTqWNnJIvxrqEDLQfMsmUntBM8ww14hCz/ASVYOR6gzD083o9BmSFQrv1xL9UREpaLmZHjR4MaAPRaM5XbH1TYc3GFoscK+rROUOupHzHqJtl2hKT8nRTI6GB7GRkDSi+usMpBhRd61rw5ZtrjSWgLAwL3wjEsz1oUKkcx9luOPHRrW0nZDm6pV+Ip7M9gfGLvqeHHi8inmSm2WytimoNl7ydlFwpAU2cI0vBgZ5mzas/UyG91+Ayn9gS7IUfdC+V6c8aLGXgdnwGjJ5rooIPqTlkAIKcIC1c1hYRErCkanaUN/cBqF1l2u4SDadfTkIJpP/jSbb
 vTeql7ee
 dtuuK7cYsW1OceAb0IUR5eVS1qTGIx0YqYXl/4clKzhPA8/c8ktAnXMcDAMeZva0Yw0lUZnwCFsOBzVZLzRfdmv4a3lkGYMFEjbKDsjVxlfOjE7ykRgLd6WIk0T8kH1WYaS9nAbN6ldNEkcAdA7Rfc//ZVGMFgDXSJNEw8jRRLnGCYGN/dDudAP03g+bGcVot/2j+CiNwaHhH9RG7d1p1TKfFhsNcX3chPe0g76jCYjNdYFe0fvXKXx9Gz3Lky39TcVsJgcyNzGbRxE3qU90jdSZarjKCRx6466YSL0JU9jGWwti6GkCyODKxtYCujJf4C2lwZEepC6+XhsmWDbVnxomUJfDnI2/8WHGFnjOv9/0b99pGPPYDdk+gOpJ/wFRrssE7LZLEoAm6LhmRuvRiw+msgAX6abU4ySXoS+ZN1DA1OeBqWyotB62TVi0XdTxnlKhtNEri2yinJiJhzDv3iavfyZOIcr4Mp1im2A0GU5qefy7t5skqDyoALABoL7r6emokhmx+LgOimlT/0fBBnlLprbTywBOEdEXQ9XifKbIWkPHVOXWY6xS90nAqvTsYBCxohvyeMc695ljuq90J2eCdCqR9vq7Uaq9tx28N0w0Crsn6IWBSMvgDFuEsF0H0Ec2o280x2A+C5sAu+wJ8hgzTAEAJPFRGY4uPO96HhY7UUZDfuvCygGeGlFUhijdetHzTJSuHnbQs2J+vCHJmkSA/SiohKDKIDkUUKjpNxHWucE59tqVOyv3U2uewmSqX2Xqi2Sds+AbHXsVhmwqgXaVJvL4RWJaZcR4Vo02TOvoBuGpU+bevf3qijSunlBWmVyB57JJCl5k61f/Le34FjZoaEGECjOUNMiUx7J7PQqtr/olFb6Ej+deKo93MKZgvvpWosYcvIx+7RGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 08:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Nov 25, 2026 at 02:30:52PM +0000, Harry Yoo wrote:

>> One remaining accident we're aware is that we cannot attempt a
>> spin_trylock or local_trylock under pi_lock (even on !RT).

No. It's RT only. Already answered in the other email.
Nothing wrong with !RT.


