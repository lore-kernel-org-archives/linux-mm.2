Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C46606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=honRTN4G
Received: by kanga.kvack.org (Postfix)
	id 5A4136B05B2; Wed, 11 Nov 2026 06:21:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554E56B05B3; Wed, 11 Nov 2026 06:21:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4434C6B05B4; Wed, 11 Nov 2026 06:21:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3CF6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:21:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3A9916024F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:21:23 +0000 (UTC)
X-FDA: 85422597246.08.B6D6239
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id C940220005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:21:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=honRTN4G;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr9LUpNEHOOjAzDkbtOdFfPOarAUZcRS58IEDQefKL8=;
	b=C7Wmu2N/bxC/f1bHzU9jNRJ6FKUXbV3mcv41G/+K7yCrLl31n4epr8kWJyefbeH1xmWx1G
	bS2LqkwJnVOb6YfuhNCTF7fJTL8/rfNpgLnK5ps51XXpvPk1KRG3ieVYB8sTUD+XZ0jQrL
	H2/Fe8G+EjIhTyA/JWooTb/NEYF2u0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396081;
	b=ttqTkA5fUujbK2h4gIMVqc/MbNdIJ4WgawHHrQfHbWTUifrjWj9N0ojew9O/UAZXcKKGXI
	PaKPiIs7Sya9v9CtHmhzo84nqbBo7cUafIraAP6RJWQo13ZiAUtiDNs4WWs6LqUROdtzn/
	1UtYWcWpFJngu7khGTcq4OnHlum53H4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=honRTN4G;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36e2b1db9bfso51712eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396080; x=1795000880; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wr9LUpNEHOOjAzDkbtOdFfPOarAUZcRS58IEDQefKL8=;
        b=honRTN4Gu8AQEpHclmCZRo98QjDgOJ8ai7Y3zRF7/9Q2A+7+jyNzPAOmzFAbXZYDpn
         PcDZ5F+Es7MSZMnHozBREU8MKRj8Sa8l7kSqfql0rim20xRE1TKW7G/mCHH2M+UGAEmd
         WdQvFYNaOfv/iBg3Z7B1/8+N6eVPuwrSToZQVQby3UxlRpRuFVAvARcv+9lxjCcxhP0n
         rXT+VuG6ei+nAfSCFj9QW8HN10lQ93U54+A8EzafXeEXG3zi5zj/lTpd6jAhASWEv7Bq
         paSJPceyfa1oSDR9FRF2iVuyZnd8XwQig7DBfVETQO6gAYJWuKjfPMJHHeWyBn2MctHI
         Kdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396080; x=1795000880;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wr9LUpNEHOOjAzDkbtOdFfPOarAUZcRS58IEDQefKL8=;
        b=tIQi1ceH7yTKQh4WCtBjzYljgcuwETh1Rux+yGsLrVDzkyU4QWjOgu3OCphoE9OlKV
         18BOhlCH2m3zVF/575qzoa+902lkh4Oqswdf0kGfTxVcZE9votLjSHsDZMIsaHQFyL47
         ApeCoG4cHpKrTtFplLjf/hu6ELdOPYhizayowi30OKf6qPw1jIuYGZpN8fmu1tHcYaaQ
         1AcCXQuy2Y4i79I/0pd/7XV4kJFqerimtPm04j0w6U4d1zcLDnsjiHzYvqwdB2NEhqP6
         FmCrK2PMsBoGR+VqsZ4gBn57R7WQAT+lc0pXOLqT5kZIa+V5kGH2u62EWo2ouZ9p1YWO
         t1WQ==
X-Forwarded-Encrypted: i=1; AL+hErHU2p5GQhp9m2mUPqdJ7QjI0yYU6kXIVohFeiwClYrRrE4r0b1ITLiKZ6NE7jaOJlqFSljDerManA==@kvack.org
X-Gm-Message-State: APuU4Z83SvoEHejUm8hrgIxPrAoma2LpRaLZgLb2aaa4uQ/T0z2/wjap
	YdRUQfoXVrAiOv0lmTep3Zz+nujnKzu9Oj2atoHoYFJT6EkfVGAmLkEi
X-Gm-Gg: AYBFou1BMGRaeWiQaXqcsSjzYiIvR4IxncO7Qm9A2kltGEGan8ZEnNzIXJZRWDe1jms
	c/oaMbTPlHbteVwt38lO2r8lbWHyYKeWiy0tqJF38IicusZIyJXTANj3xlxEGfgrIH5ETvck4kE
	NA8AQS+diX6db3e6Z0or86T1XEsS5zhrsNBuGZYBJEAGj7szU+ip4Jil3JWxE8tUmfZdJAZB3J1
	jPCuHyn3TUIIQTguZYb28Zu1OdPDoZG1fB5YGCPuI4QtySzzGqFbY3L3oPxYw1muGjMQK23S3d8
	APRdcmceOUEVo87LW8zLhTcmM3/z6b5AVm1fuOn/VeLdZy/cvsov+uUJMcLhltNOZfmauCh+uFn
	DlnHbjV8GztdnpZLkEuRcs+rRjCI+l0mrUPhqknwDu+UiBz0IYZTmUCIimePhAb7WzB39nEA8nX
	ygQnDQJf3iGJz4lJUkdzpMLIa8lJARfE3kOlVYO2bpvh1k3zW/IMoyJczA2pdAK0FSBsv7zfDbZ
	gF5d6aoShbnwH8+9u7ziR+dRYJqj6fgpWeszf+aE6gC7yWdqcOpUxIrgHXmOLfLz2G5+sR992wQ
	EQkrVvvfyb6kBBhpe5sjCQu31iZybVACJqs4zhKGMmZuOieS8FiogNx1Gp12YBwPN1o=
X-Received: by 2002:a05:7300:f547:b0:36a:13fd:b5c with SMTP id 5a478bee46e88-376854b73ddmr4138428eec.2.1794396079980;
        Wed, 11 Nov 2026 03:21:19 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e7d24sm24474631eec.22.2026.11.11.03.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:21:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <CAKEwX=M6dJMccGcDqp2S-66cbegdivnB6MqQRj6tQ2u18UH62g@mail.gmail.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-1-caee41684aba@gmail.com>
 <CAKEwX=M6dJMccGcDqp2S-66cbegdivnB6MqQRj6tQ2u18UH62g@mail.gmail.com>
Date: Wed, 11 Nov 2026 19:21:15 +0800
Message-Id: <179439607522.2142163.11892098572560820648.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C940220005
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7bgra7oezgqcsauu6giojh79yjse5ywk
X-Rspam-User: 
X-HE-Tag: 1794396081-94503
X-HE-Meta: U2FsdGVkX18oqLOpUABELZj55WD6Fd5jEoj938ehj6UmbLC8EHJxMYy9zkn4j7PvVNmGh3j4YI9dBTmhKR1jHBZhbaNBdvts/OREtW5aD4lLgWJoNtaPpqAcAEFccw8mPuOkQ2jkbIeO4c7/px8zzqz/Y6D2hIMf3L2inmCZP+BFlQLLt6D6eYcZ8LKDmLSg+ga/yNTFTK7BSbatjntEGZq3MB/QehB8pqLloF9QjYOByOavg79bXym5hcREi3LfXCDWY//1NK3JZchjvkrrkCP2wxnE5CO56kBuUzDZujyjzTdO+iq8QzicK8RP2gL44hb5NW4JSBdJlea7b3vrdc56kLN65zaLWUqnUh9lDQJh6RqBjYLmZHIG7c+W4gYPxix1Q1XkDxtkITD1/XZrs3yll4nq/6WdthNPI1QHtwKbYCaHLpVYuYunJsdsiJT7CFUD8Cws8Tf8Y6i+OTpHstPsfwbF12fQVF+xs9tDI3LSNy15ptSGivaJwVimmDAyFYTFwzJFLS4xZxpnjoEYKxxnjY0tQHry/7K0k1AhVau2uKqwWst8m/meGoeRVenJJBqlD0HlZ7jJsLhqigHAVa7JmP/2GDgaPNWmDGiVq+HB/1jQiAvmrcPZ37f9a7rSL89xyy7ooe9rsMEaIiJ3DiU0pM2Q0sCckBy2WY2g1xV7aqamrfoW04/JAGHr++hSpltTAEFpewPy6xLdfMThyunVcJIQohNxfCFSy4VES10ye7ccn63ex0KPR9x/VqhLLLKS9CTLxsc+79iCZXtKMCc/d+QeEiUs40K2yviCdzhJHfFHq4ygSsjlD2Nqdf2F+bTfSeZOuxomgOjNL5/zooZZChlWyvMKSnQ7z+X4+p5kmvJ9O/KyTLq2OtmES+ZjTp8EnGZcoXqDMtxdoDcd86uFYd92ZMlw3pF1j4Qqq8WeZuduFYNePequVZUtCRngJ6zpJCbroE9YStNpvwp
 Mmg97ziJ
 TPEOHJ0NcZ6sIKjUh9075QskqyJSUsPvePk62+W5TREpnLnD8nNLXv4y++erPsgi/goVsyL9ltxdNbPc394qETvvJX5Jx497vC8ivYyIk4Zz/16D83WMA6fpNA1a6imZNNX9ya2xR3koh95uG0iSEARCf6goS0VR8/IT1+ZfTMpJNdLamsvua495O69/cHupIlz9FEQJKrLJH9BfEAnek8jfxb0bRo7Khcpx0uSzf8k4Ni46cTpS+KwWbLwyKYFIIfIvs1K2jTGxCB8nheqCqKUcaRHEKQ1mwjmh36HYkOD8eNc8zZN0pcEGalyTd2/9jgaHPqZRXfHFurVrlK1FpWDpad9rHCqSwPQLBT8i58lsxfQudsljmrXQ9WMdw43J9YXtwL+12Aiud6iXS0k0A9uN6OEKAJ2tqJZ0vEeO97EPNwuKD4JK78fWzVi+OYCst1yCfy/tL2jAe+rujaGpEOAoRztus4Ham9mtmaREo9Bh5v1iMVd/udEuXHJxsQw06tnCn9eeiDFjNheJC9CuJtR66iVPDkCgPqkmD7N6pz0KsjQZS1AyhNX8yNLMW5v1l3eOktFM6Hc/cjjp/UnEfr/Ole9qFzHrdx4rhZNKJCX3hL8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 08:00 -0700, Nhat Pham wrote:
> On Mon, Nov 9, 2026 at 5:59 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> >
> > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > counters are updated regardless of this option.
> >
> > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > debugfs is unavailable.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/zsmalloc.c | 33 ++-------------------------------
> >  1 file changed, 2 insertions(+), 31 deletions(-)
> 
> FWIW, LGTM:
> 
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>

Thanks for the review!

> 
> But I come from the perspective of large(r) server machines - I'd wait
> for the feedback of embedded folks too :)

I also tested the memory overhead. For a typical Android setup with
one zram pool, the additional inode/dentry slab object footprint is about 2.11 KB.
Even with 32 pools, it's only about 45.7 KB.

I think this overhead is acceptable for embedded devices.

>
> Sergey, how do you feel about this direction? We've run the stats
> collection (even before we select CONFIG_ZSMALLOC_STAT to expose the
> stats to userspace) for eons, and it was never a bottleneck AFAICS in
> our fleet...  And the stats files seem trivial, relatively speaking?
> 



