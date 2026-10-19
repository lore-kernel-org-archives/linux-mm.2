Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44134CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458466B00D3; Sun, 18 Oct 2026 21:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4320C6B00D4; Sun, 18 Oct 2026 21:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345AD6B00D5; Sun, 18 Oct 2026 21:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 051DB6B00D3
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:35:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83AF41205A5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:35:17 +0000 (UTC)
X-FDA: 85337657874.29.BD22299
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id D72D320003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:35:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oSBIdu+q;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792373715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
	b=ylir2XNZCQdAUiQCunX8Vd9O9dScvdHEUzrqzJ4AlZ0vTBfoTrj4vm6OJ6VHezuoYH5Gic
	TsO7d7fnRrK0XQKT/ZMymX8ExydyOfB2RdqcUw5JNjXVwRPSBZ+RlWMsta/Cn2I2oDDwbF
	RrGT0SZJW0oOd6Zw4dE5+axmuZM7MiA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792373715;
	b=ozwAeDmiKXlkevstDecb+NLt5UhmPyHzQ9nKsE8tqEHAX4azDKH8QxKRH+V2liWOS7u6i8
	/AlvSwaddfgdrOmWwVXSzdJQ7zIdv+CGvGhEqSox1KyFNdBmyOBQEzQfWar6AuKDqz3oUE
	kFJYeOCS/83uMq95FUdByjNQyV8pm0I=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oSBIdu+q;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bcdae234ecso1306958e87.3
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:35:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792373714; cv=none;
        d=google.com; s=arc-20260327;
        b=mrTF7uhKwqX2LCNk+npAPjPbGbltRJJvWHJXop+ro1YrWvALTynMtSsL8fMUGAyEQj
         Lom6gEoqEuf0KWSXV6bm9maNwNQs3xJiFGKvVZPZJfRKx6DkIWDRVWZZfy50hrehyNv9
         /PgnD66njPiukJLZMcw+o3Uxylw5GM3GptvB29GhPhq06fHDUT3/2HfN4+ejKXLpjU1+
         AiW0qxCsdCPbsVpuXp+CEXR07rsOMyUfM9qDKvAu/JCJ3fqE5F+BMm4Kn4S0YG+xVW9T
         7maSopHdSrrKUb13UxlxHo4MHDaPfUWEYiX7Naus8ZGUFNU7nBIrJBeKZAPrd91hwoym
         2NRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
        fh=uQ731VPjP7tCq0BTL3jE//Fg6LiseZivj4LI6MYT8DA=;
        b=CU5pC9kSTLoX11gAMgGJ3K75cMShC8xYA14GySdjcuE4XGcvEM2zkkiSm65z+z9Dej
         ScLdaAn404FN9qf2GNiylpHL61bT2lmtMb2KRRIPO+OfSn0idZ0e4eQgfAHmpHfMV2DD
         Y6IOTi99QXGNVoZXAp8L/GrahVB3jHqf8quhXhY3eT0vY9waU0l0RIROaFUycToHZe5h
         USH4vfJ+ta4aQLEriw79CeiwQ5nXPj4vUY31ii0sO+VXkVSFWr+0e9JrASMlf9Jdu1CP
         /1AYr8POzMOmb/4rHcefWcjZ3dNOHHN2cEOJh9TQ7in5vf3okTdlWl2KnVjomt0Mqmiu
         41pQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792373714; x=1792978514; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
        b=oSBIdu+qdX8NmMp1ysCXEC54mfk/J442fMIX8MmokkrhwNbSHo7qeoyequJhS77Eaj
         2HgAzi5MH6ejA+Oj30FzQRplxV+uC2Sf1DiQszh1Vjhcuc9xq5OQxS05LGIzMR+gA8eD
         nStYFctzYu+UeQPgYWpdHytJCz1W14dYeq+5aSdR3I+HRVtpIx8CYqdCY6u49MOgtyFA
         u5Xiua/d1WdFxqNyBMwPKJ94+q3QutbsshyIVhvRo4bh6cYCgVoY72kntWwc8D11u1sp
         ob7ektChNLM/VFls2fCzwD3FtBOJt77QIq3s2iVkYzbBTHYwBGSeyWD7SclNUTtO//1z
         g7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792373714; x=1792978514;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nff/2Dooakw/NTwEm9AsfcojNM4c7HTexv035G2HWNQ=;
        b=TTAzD3Qu/pQMhJLfJvWa/1mHV1XJuF2Lm7BlWv30VSAlQ03YU7bq6OQpi8P2lEmOJq
         IDY+7NZoxO3OU6AoKFR6XPCsdxyvXW+J7oPskUq0ywS1FsJalQNdcUpjlujJ0AXBml1D
         BUks2GyD6bkVvYZ623hQ4eVBldxgzD+DhEF8klutdsmanNyoM+5XKRgMOVpa/X2nAwLQ
         u4KKQTuJH0UUWWgVvcjl6GsbtP7jvOj9fJ8ohGNLRen8tSwVfiT+Ta7pJ5WcqGgi3kon
         /gDs05kz2V6iUl1FpOkS90VPjQ+EW5ziAAgl2/sc2UMen5g8ZsGdEJ2MBcJUFlGwH2GB
         F2Ig==
X-Forwarded-Encrypted: i=1; AKwUvByiSKd3fa6euRf7oZq/ZuB5sCNVmrWKxVqSVaSaDYkGur25vXL/36uH7bt91CEJGrVc1s4/9N7wtQ==@kvack.org
X-Gm-Message-State: AFq9FYJCLnNu3bn/XwokYGdFelGAG1un89KtQMGR60B2hYzPhl+5yea6
	ng9UPNVWh1kFbplfG/8LyA22Tr58A/IAYdux6JAgE+l1ZQkee7kp/p0uvs/eKqU5fdcTdo9l4ts
	ZHd1vMyWfpMUukDLs3hsWPplWb9lldeU=
X-Gm-Gg: AYBFou0zD5tM0IboX+LeWx3TTwGmVP2WE2Mjcgw3o71DW+R01uADooB+BXSU/N4FAtV
	Bt7dDffQ2JyINYMSEbBza4WXP2ueE3o9GE9fRgvW+vXmTi+W+OFYp5zaAE/ubmd7gXijg68ZRf3
	nJqY3/Ktg1yKyl55LgevYPRbu/y+dqewwzMy0Huu0TV9MPfF0TIGwe3QWs4siaQrgVX8v/oDgXy
	Ldml0UZgj9B7iEtHleW1KAnqJ2ip9ljHQ70CjyEzRFfq+UAx++ijSykjc4/kiyCvqgQlRcE+U6t
	bwwDBWEzSguRqN3+nI9VDQNpqJB99yw7sd/IXyjeyxP2lg7n3EQUUi5AJoj49kY+Yw==
X-Received: by 2002:a05:6512:691:b0:5be:540f:ce48 with SMTP id
 2adb3069b0e04-5be540fcf96mr1950051e87.18.1792373713661; Sun, 18 Oct 2026
 18:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au> <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
In-Reply-To: <atMCfhB63koot230@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sun, 18 Oct 2026 18:35:01 -0700
X-Gm-Features: AclHuK-sa0bPZwSQVwxADRhzmdY4PA3aAYNaQTZ1DmSolcYDHA8wcYiAtLkFuj0
Message-ID: <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D72D320003
X-Stat-Signature: b95g6umbuxi7qwwk3hpd4gg3jp9qtqp1
X-Rspam-User: 
X-HE-Tag: 1792373715-470599
X-HE-Meta: U2FsdGVkX19UVaVuvP2yJ0NFAXjmkcTuRnKYHs0ojFoYeF2hiINRvdXadPijxRwYBpFrHFTEIXtgN+U9e6kywoDmzIWYUtbAjA9uj5LkKVQYgWbdtlgtkrgWByPVH+stxUNI87lfwgWZz5ZXYqJsJUljaTX4FXTGAdTNo3vmEuTBoq5zO5lylWXb37KE4EifG2u9hQI9fox1+oWxHweidjgl6EsQLjwJVlSYTdkmv5mAts8xpGdhoXQRJMp7vtu6lPREMq9F1+Zg4hU4NutDI/X+y3TN8vG3K9hbmjm7Z+uMJ4emA0S0HA25B3YL9VKElmPl8ZRc2+vfjJgUEargVJR37TjKbh4t/Raj1/zl5ml5hlTNe4GhCia5YSUIX+ZtXggHbmMiAppjSzr5IKeliWFd78uKV4UajtwuQ3MVtbN+oh9yWwfvVSofsq2XTglgOrt7dsXQ8TNkSU1zDAi5UVh19349FcOwv3Ljk6npAze1yCenH/xJqrygEjSEdkTJEwGp6RaNYjIrErfJ/Sl0FU+F2A5R05S+8m4Wea+syIX29mie2iCSCE18qJC6DUpPPxwxSPUpnnJZo7t1seBuNRbwpR5oCO9IKBEbPzrUJRikta8zaAiZgYTrlpbV/eWNzdhMiCAzmVMYQVpQ/Etv9tkEIhP+Fk3cMujshbCif/CN58ujjXI1rq5UersvV58R8yh9c/qjJ7survFA6LnaI0fPVE7wrLapD3w6fwR8G+5INyQrmFHYTcfErWSBZBezuC8IUscKiLFuZpDt67nv2JTrfEoy1zQKkJbjIOOAUKDCXOLtCL9A4xKAmZ3zVd5KCajWdK3wf353GJsohhtSGHlsTCiL+b1FDeiXwEQN32BCu/r1LkNBjD/pBevATG3kfzO9VOlFEtCs5EyZ/SVtu6IxADo7bNzSoR1mgYEbsK2poMT1PD8Pv4Okl5QzZr/LNE8uSVG/C/OziHCiNbC
 yBmKRUaA
 R6DBixm14vjxu3Xs/JkA3pcu/0IR0rSXzUYYyan53No2uDRKCqQpTiyp5giYtTpu00LnHoLfAfTI0kkFwUxQeXghieuj845XkmXd2UE2JBLYxUzMkpc6Mw8oqHUHypZINJNRYw7kia5ym/IJrhJrobUn5bpFyBYmrJOkQpcdkaeHGqs3BwSKZYFYKVhF6k1TkjMlcwdK85viFlMPOvPu9SOpybYgwKPs2tkMCeqdhFt8PTt0y5hUlfVe62HzIgr/FQIUktTrf0ws5riUsn8WBkCdJfP7App4wZCH3zQh46ynE2oaAsLf/o6tbv7Txfo5g1yb07TohAQGinF39BhQo+Mves4zc/OKPj6W5lTFvV6Esg4EVw0wGsgy2fRJDkS/iuw2RqpttyWnBcZFilVujuRBhnCki2xgk+xQp3QzXqyaDC4a+RG1LwYeHGBLNe35taHXPX5c7Czb/n/ppTWPNaWINaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 10:07=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> [ .. ]
>
> That isn't quite right though.  We need to ensure that it really
> is a singleton before taking the short-cut.  So you need at
> least one conditional:
>
>         if (likely(req->unit_size =3D=3D req->slen))
>                 take short-cut

I added the check for the singleton req [2]. I hope this looks Ok.

With the latest crypto_acomp_compress(), the batch compress latency
improves considerably:

usemem 10 iterations average throughput:

   patch 6 (store batching only): 19,119 KB/s
patch 8 (+ compress batching): 24,076 KB/s (+25.93%)

bpftrace measurement of zswap compress latency per-page:

Sequential_zswap_compress  nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
130,165   323,961

Batched_zswap_compress     nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page    665,267  41,511  54,915   77,707
124,648   213,962
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Latency saving (ns)                   -2,435  -2,876  -10,782
-5,517  -109,999
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Please let me know if [2] looks good and I can include this in v2, thanks!

[2]:

int crypto_acomp_compress(struct acomp_req *req)
{
struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);

if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
return -EAGAIN;

if (likely(req->unit_size && acomp_request_issg(req))) {
if (likely(!crypto_acomp_req_seg(tfm))) {
if (likely(req->unit_size =3D=3D req->slen)) {
int err =3D tfm->compress(req);

req->dst->length =3D unlikely(err) ? err : req->dlen;
return err;
} else {
return acomp_do_req_chain(req, true);
}
}

return tfm->compress(req);
}

if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
return tfm->compress(req);

return acomp_do_req_chain(req, true);
}


>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

