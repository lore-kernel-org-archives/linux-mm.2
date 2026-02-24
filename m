Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59674F4BB60
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823D66B0088; Tue, 24 Feb 2026 12:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1A26B0089; Tue, 24 Feb 2026 12:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9826B008A; Tue, 24 Feb 2026 12:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5239B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:19:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1554D1B6129
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:19:41 +0000 (UTC)
X-FDA: 84480012162.14.5E1F102
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D52E100004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:19:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3BLdnXtV;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771953579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oo2St6ysvTgZpChRDuzcMsdyLl7YApmz4u51eboQAbY=;
	b=43H2pn31tgq/2l1xRQmVWa2YE1YZY2C/rEIOSnSe3Nk1H0cueV+TCCY+eguKtbg/mpm3Dd
	rYEisir801YQxIqH0iyvpm/7eZbFFcXIBXhsFx501M0OOqWuQD18+E0yIf8iR/0Ws2cbTJ
	TJ9QoCEP+1AHC3++T5a1u+d0h25lvg8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3BLdnXtV;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771953579; a=rsa-sha256;
	cv=pass;
	b=zT2MD1BAkdM2xiKsPbDgrb77aLxIe7OeAYuxnfEGvttZRrwGy/2hgzw7cRqjmQ0MIHP4zD
	R3q3ctSJ0Nzu7DmoA0Uz1P9bZVx0tro2Gg4GnsuKaD8hD94lmLlkoEHTtnW+Hx0bJXLfBv
	iw+5ysAw1ltQCyXSSY6DfS1yNuUJCbc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5069a785ed2so97041cf.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:19:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771953578; cv=none;
        d=google.com; s=arc-20240605;
        b=JbO+B8YrjytNcs/IsUQbmh8uz/H51bx8hUDeDQ2LhDvkR/oWeZgAhVUi7OVRB8sazd
         v6QvjkTLLBLgai/g0RNl2ffkviblfU7TKcAAjMSdAk+pbbQl2AV5Bnz1UrU2SdtcKlsE
         NRJGKU8YLQLvzH2psivuvyQjST2l0jRsrzVnke5TW5b66AFM+HqZiR1nE2qHniz9z/6Z
         0GzLe3KqQW18lvJpymt3zSmSpg9nJ9txv8m+8aXvIHiXhWcEUlmsXRTzp8JA2ii0qQJb
         1uFHrMcTuElgX6J5F2ODrTQiYHMOA7ptP0pBtOGFVk5n0x1rAtEoPowK5Drn62XVNS31
         97wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oo2St6ysvTgZpChRDuzcMsdyLl7YApmz4u51eboQAbY=;
        fh=Z7irXyPwE+HXnPi+anBEae7U+/H25LV0i74tl6f1ohE=;
        b=RfRoxoiq3HuM+dEi1TJUlnRa5EAkdIGSuK7HHw6hX3E69nHH3U6e5SPuwLAKz521Gp
         h6q3OS4tLMt/BH7t+VRruQIahAqzs+a7raZFh6fG5O5s4aXFkMmkvmm+ZPZJBXnEa1J+
         y+rUM1YjjZZJ5w27y16RqnSuWTdv/PhXh5/lK8pwRBPPLk5gExaeEqG/Wej9skwxdqMh
         kKiJH/73oXIwjfwXzHmLV/Dz6Zx1LKh7Xm1ZGHPYPs0aLTv558IZcVh2fz3Fu2i69DLZ
         Sat0LEyEedATzY3gHYaej3yeDPaG9saxKxefjpvKIUV19rTzRIiOPtb+TqqWDjUdTQas
         XuRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771953578; x=1772558378; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo2St6ysvTgZpChRDuzcMsdyLl7YApmz4u51eboQAbY=;
        b=3BLdnXtVzDxPRXmUyTWuCmZjj7LB57ifmag07bazyp6F4WgB+r1cFVcYTcMJgLhj6F
         TNhmJDRRURiuv1bCiQclCmt1zvJgzkYLJ45SMf9k2NqX2BaMm+vFVLLMi+k4BAJrz9Vj
         +eKldNBIhxY1OwC5seBWtSm35g5MWVnMJmABCKOMnVP0YFgkmlwU8CDEgzY5ayLo8Apz
         btkZF0uS/8MVpHzcjSJ90yhp/dWdav+EfU2EcRQONaR0aL2qiKJeXlFIOwoLZvutDpr1
         hXk4Z7CzByKm5E1E+AMExXuJ0mvEZXYogfpcgkkE9dHF2vlGO1Jk4qVljQAw2ISII3C/
         FTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771953578; x=1772558378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oo2St6ysvTgZpChRDuzcMsdyLl7YApmz4u51eboQAbY=;
        b=KeAUoq+A1IpsDLTTZURWgOkuYpVHBmbnLh9hvTpa3315e5eD6TJOw3pwLBiYywFCpS
         SYhegu0C5pgn7MAK0cPTzghO9RJPuCZc9piQcFLdSrRVNjD7rocijsNO8OfFbxK/WfaN
         iWj5LBpXoPIITf2RQXGrMIHROOHm3a4cH2Zoca7EicR6u97fLcGvtL9niaQEQUmuipKU
         rnk39ja6HjYO3anbr4Qggs2ZYzkxdwwRBkPfAB5VyUc98dmzJqb4j/yDve2RjhnuYJUm
         5o5mGAHjnLf4fmVxKL5zEU+YvtqN9krV+DeuxDaCDSfg52lj7OJxxzddG4vmmOE4VzMQ
         uqFA==
X-Forwarded-Encrypted: i=1; AJvYcCU+7PQk6OSJ/OqbgtjYwxG9JVgA05GScnOJRI+RNmf174l8WZPCSqmS2jaCY7I158DolXY7/Tb7VQ==@kvack.org
X-Gm-Message-State: AOJu0YzNmz2G2EkHPjmReG+qiRKTnUaico0ZQt84ZfsO7aT8W182upfr
	6gQJPz03KFZumuTFUrCZAy4XqLzAPVXkJhx/0JgaZWZwSTeD4rEoIiaibY2PvkZ7KZ25InkDwRQ
	Ks8cnZORYYWs/bXWt/rIMQlgq/s/gb21WClmMiZvv
X-Gm-Gg: AZuq6aJSE8PrTwEzW+rvrQrf4GHYwzw9Zvm+TS8sEmie1i3ae6Yz7pJv/kgjzG+j8N6
	rwSpGi5yXMgTtiiV+1YzIhGD6VnMSZVPTzYy2VRKR4CGrO2YpWN/bqzaDod6n8zQoeWc5CSUHsy
	9Gy2uaMlycB377wTybuLUs6b5r2tqBBrsGHOQFLzBizfFeYFq3s8+hIFEDk733ZwVAY4PF1tf9I
	QH4ZtStERO+uiKTfBDdpCgp13KRNROyzZIp8Nz+sepRJDYkC+w6iveZBCsaQcmHIn/3FJPaxgwB
	mkiua+aAuy7deUCVB0212E7otaTGhbYelswyGw==
X-Received: by 2002:ac8:7c4d:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5072de9fe4bmr11229721cf.1.1771953577485; Tue, 24 Feb 2026
 09:19:37 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com>
In-Reply-To: <CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 09:19:26 -0800
X-Gm-Features: AaiRm52Qx_Z1xpVX42eHRt7WYq1HVwzQEKnwk1V7rPiT_3xK81wWyaGP0DoeldA
Message-ID: <CAJuCfpFb7opwBdm9fzSeFguCCsq7CAiBY1C4J2o07LR6J74E-g@mail.gmail.com>
Subject: Re: [LSF/MM/BPF] Improving MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D52E100004
X-Stat-Signature: 1xeogt8muzw4urh83rtwc7icej5khru5
X-HE-Tag: 1771953578-869576
X-HE-Meta: U2FsdGVkX1/umnqw9CHHs7C4LFcb9g51pGsKRL1tBhiCNKPb+IgzQoE3VOP8pUJcK7MM2mNEUt9h0pK5/lnwjyY6vkt3Kq1qRB+yVBG2j/yq3la5v02bmf2Zg+/GsgPSMlh2Wb932oTp+59DRfKqW0njrOBXlLZj7rHiXSHZlqAiwp1HBrz9OIyIaIgY/vn7SGHqe727cvCBHZ4ZFELlf5wv1tdLpCkT2bV+H/PPuO+6Vt+zuKVrX3CiawDw3R6zy+hplFXvDbPcYUqfAh6/oet2a+n8qgY0foBKmEHv/t5r1jIgLo2PVXUyZXNGRUE9iovhMzTaCp5WQqQLTx1Xp7oJVfo5DpKN6Ue/vnzRoe8d+ta9GEubjN33gpFkK1iF62U2Cbx0nbLIPsAgHjSmwoEDTuDMnkx9Awq4gQq1u9yzadJuJ8sNuF6Mh3pX65ggMzJffBP7Agm7HcvGxQKVhxI9SpoF0Ka8VH/MqZ3BNX6yN7ifD82uTs8xc9qdxwy0y9e69y4wRrfrPzjSar62cTn1+MZ99YRik+DkaIlVoK/NTDX+NhAz2gfX71yCtUCH13GpZtEYUPVl3C2luKOYg0dBx9zqDSLquAQJtCjMq5KnSQZG0hiqxac03L+oy9jf1OnC9M/vTkrFfHSSoyCLqjVAFVnpaQo/4HY8Z1jlGNwpYgwqZwYqS1GIAU+m+qLnmOlwNxh1j7D5L8sla3D7FYzIOVvFU1jS/VYZZnQWj4N88xJoiHQkYCF/9IXBek3oMX+k2XIconLAgPjp6yRU8hONs/BJ2bqvU3lvGzMe1xv+GtbmVuR+e3ei6kuc8rhBUoRNQI8MrLQT3QnuCTcJSC4qSmlwxGm1QIDU37qgIxp6VpU/s8pVivmcT02aKwwsDwUiGhhwlVlZbKmYgZ0GaBXerDnhSU1YRG27AZnVLkjOvLWIwGORHWvBUB7YXfrw/iUOcU8NpLymMt+JWe5
 8CQBuZeH
 gFtgKsiaES9BgA6SMX0apFuUUFGQKDtz0jaWKsvfwHKkwj8DX6cUQm+vCDpo1jzpA6Y55oVSKEwPduJOzEvbZlEyDLdGgXcrXKslodmHebOc1putqyWZPCXTgnNwjD3am/v1oMbkPLH4OHhppkzyZqpXTQ/ZT1H5kAiIQHwO/FCHwOnTSoV2dAhUUG3caFqSNOFQpayFAdOEtH43wSSVuDFAKFJOa6oP+FpCzre437RZ3RrKp/Q0U79NDl+WG2G27I0zITdC8q96nBBd3P51vcEuchzAijwtAXh3d3m/ej6VmnzN1qa3VpQlz01NyuyQdi+6ZzndIoYe4/y7Un2aNjnpzQp8cv0btycdjJTJImG5ZhI06ajrZ2Isx9kC10DdzRsGZUUJKEQuQ+DMMtP8B4mJWl0krRkj8//CbFtHzh08lS9IPPkNRwK2Y9lcdU90N97qZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 9:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Hi All,
>
> MGLRU has been introduced in the mainline for years, but we still have tw=
o LRUs
> today. There are many reasons MGLRU is still not the only LRU implementat=
ion in
> the kernel.
>
> And I've been looking at a few major issues here:
>
> 1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/Inac=
tive
> LRU.
> 2. Regressions: MGLRU might cause regression, even though in many workloa=
ds it
> outperforms Active/Inactive by a lot.
> 3. Metrics: MGLRU makes some metrics work differently, for example: PSI,
> /proc/meminfo, smap.
> 4. Some reclaim behavior is less controllable.
>
> And other issues too.
> And I think there isn't a simple solution, but it can definitely be solve=
d. I
> would like to propose a session to discuss a few ideas on how to solve th=
is, and
> perhaps we can finally only have one LRU in the kernel. So I'd like topro=
pose a
> session to discuss some ideas about improving MGLRU and making it the onl=
y LRU.
>
> Some parts are just ideas, so far I have a working series [2] following t=
he
> LFU and metric unification idea below, solving 2) and 3) above, and
> providing some very basic infrastructures for 1). Would try to send that =
as
> RFC for easier review and merge once it's stable enough soon, before LSF/=
MM/BPF.
>
> So far, I already observed a 30% reduction of refault of total folios in
> some workloads, including Tpcc and YCSB, and several critical regressions
> compared to Active / Inactive are gone, PG_workingset and PG_referenced a=
re
> gone, yet things like PSI are more accurate (see below), and still stay
> bitwise compatible with Active / Inactive LRU. If it went smoothly,
> we might be able to unify and have only one LRU.
>
> Following topic and ideas are the key points:
>
> 1. Flags usage: which is solvable, and the hard part is mostly about
>    implementation details: MGLRU uses (at least) 3 extra flags for the ge=
n
>    number, and we are expecting it to use more gen flags to support more =
than 4
>    gen. These flags can be moved to the tail of the LRU pointer after car=
efully
>    modifying the kernel's convention on LRU operations. That would allow =
us to
>    use up to 6 bits for the gen number and support up to 63 gens. The low=
er bit
>    of both pointers can be packed together for CAS on gen numbers. Reduci=
ng
>    flag usage by 3. Previously, Yu also suggested moving flags like PG_ac=
tive to
>    the LRU pointer tail, which could also be a way.
>
>    struct folio {
>        /* ... */
>        union {
>                struct list_head lru;
>    +           struct lru_gen_list_head lru_gen;
>
>    So whenever the folio is on lruvec, `lru_gen_list_head` is used instea=
d of
>    `lru`, which contains encoded info. We might be able to move all LRU-r=
elated
>    flags there.
>
>    Ordinary folio lists are still just fine, since when the folio is isol=
ated,
>    `lru` is still there. But places like folio split, will need to
> check if that's
>    a lruvec folio, or folio on an ordinary list.
>
>    This part is just an idea yet. But might make us able to have up to 63=
 gens
>    in upstream and enable build for every config.
>
> 2. Regressions: Currently regression is a more major problem for us.
>    From our perspective, almost all regressions are caused by an under- o=
r
>    overprotected file cache. MGLRU's PID protection either gets too aggre=
ssive
>    or too passive or just have a too long latency. To fix that, I'd propo=
se a
>    LFU-like design and relax the PID's aggressiveness to make it much mor=
e
>    proactive and effective for file folios. The idea is always use 3 bits=
 in
>    the page flags to count the referenced time (which would also replace
>    PG_workingset and PG_referenced). Initial tests showed a 30% reduction=
 of
>    refaults, and many regressions are gone. A flow chart of how the MGLRU=
 idea
>    might work:
>
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D MGLFU Tiering =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>    Access  3 bit    lru_gen  lru_gen |(R - PG_referenced | W - PG_working=
set)
>    Count   L|W|R    refs     tier    |(L - LRU_GEN_REFS)
>    0       0|0|0    0        0       | - Readahead & Cache
>    1       0|0|1    1        0       | - LRU_REFS_REFERENCED
>    ----- WORKINGSET / PROMOTE --- <--+ - <move out of min_seq>
>    2       0|1|0    2        0       | - LRU_REFS_WORKINGSET
>    3       0|1|1    3        1       | - Frequently used
>    4       1|0|0*   4        2       |
>    5       1|0|1*   5        2       |
>    6       1|1|0*   6        3       |
>    7       1|1|1*   7        3       | - LRU_REFS_MAX
>    ---------- PROMOTION ----------> --+ - <promote to next gen>
>
>    Once a folio has an access count > LRU_REFS_WORKINGSET, it never goes =
lower
>    than that. Folios that hit LRU_REFS_MAX will be promoted to next gen o=
n
>    access, and remove the force protection of folios on eviction. This pr=
ovides
>    a more proactive protection.
>
>    And this might also give other frameworks like DAMON a nicer interface=
 to
>    interact with MGLRU, since the referenced count can promote every foli=
o and
>    count accesses in a more reasonable and unified way for MGLRU now.
>
>    NOTE: Still changing this design according to test results, e.g. maybe
>    we should optionally still use 4 bits, so the final solution might not
>    be the same.
>
>    Another potential improvement on the regression issue is implementing =
the
>    refault distance as I once proposed [1], which can have a huge gain fo=
r some
>    workloads with heavy file folio usage. Maybe we can have both.
>
> 3. Metrics: The key here is about the meaning of page flags, including
>    PG_workingset and PG_referenced. These two flags are set/cleared very
>    differently for MGLRU compared to Active / Inactive LRU, but many othe=
r
>    components are still using them as metrics for Active / Inactive LRU. =
Hence,
>    I would propose to introduce a different mechanism to unify and replac=
e these
>    two flags: Using the 3 bits in the page flags field reserved for LFU-l=
ike
>    tracking above, to determine the folio status.
>
>    Then following the above LFU-like idea, and using helpers like:
>
>    static inline bool folio_is_referenced(const struct folio *folio)
>    {
>     return folio_lru_refs(folio) >=3D LRU_REFS_REFERENCED;
>    }
>
>    static inline bool folio_is_workingset(const struct folio *folio)
>    {
>     return folio_lru_refs(folio) >=3D LRU_REFS_WORKINGSET;
>    }
>
>    static inline bool folio_is_referenced_by_bit(struct folio *folio)
>    {    /* For compatibility */
>     return !!(READ_ONCE(*folio_flags(folio, 0)) & BIT(LRU_REFS_PGOFF));
>    }
>
>    static inline void folio_mark_workingset_by_bit(struct folio *folio)
>    {    /* For compatibility */
>     set_mask_bits(folio_flags(folio, 0), BIT(LRU_REFS_PGOFF + 1),
> BIT(LRU_REFS_PGOFF + 1));
>    }
>
>    To tell if a folio belongs to a working set or is referenced. The defi=
nition
>    of workingset will be simplified as follows: a set referenced more tha=
n twice
>    for MGLRU, and decoupled from MGLRU's tiering.
>
> 4. MGLRU's swappiness is kind of useless in some situations compared to
>    Active / Inactive LRU, since its force protects the youngest two gen, =
so
>    quite often we can only reclaim one type of folios. To workaround that=
, the
>    user usually runs force aging before reclaim. So, can we just remove t=
he
>    force protection of the youngest two gens?
>
> 5. Async aging and aging optimization are also required to make the above=
 ideas
>    work better.
>
> 6. Other issues and discussion on whether the above improvements will hel=
p
>    solve them or make them worse. e.g.
>
>    For eBPF extension, using eBPF to determine which gen a folio should b=
e
>    landed given the shadow and after we have more than 4 gens, might be v=
ery
>    helpful and enough for many workload customizations.
>
>    Can we just ignore the shadow for anon folios? MGLRU basically activat=
es
>    anon folios unconditionally, especially if we combined with the LFU li=
ke
>    idea above we might only want to track the 3 bit count, and get rid of
>    the extra bit usage in the shadow. The eviction performance might be e=
ven
>    better, and other components like swap table [3] will have more bits t=
o use
>    for better performance and more features.
>
> The goal is:
>
> - Reduce MGLRU's page flag usage to be identical or less compared to Acti=
ve /
>   Inactive LRU.
> - Eliminate regressions.
> - Unify or improve the metrics.
> - Provides more extensibility.

There might be some overlap with this topic proposal:
https://lore.kernel.org/all/cb0c0a0bfc7247cf85858eecf0db6eca@honor.com/
but either way I'm interested in participating, especially on the
topics of regressions and reclaim behavior as it's very relevant for
Android.

>
> Link: https://lwn.net/Articles/945266/ [1]
> Link: https://github.com/ryncsn/linux/tree/improving-mglru [2]
> Link: https://lore.kernel.org/linux-mm/20260218-swap-table-p3-v3-5-f4e34b=
e021a7@tencent.com/
> [3]
>

