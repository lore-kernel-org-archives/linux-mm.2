Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00149FD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140AB6B0088; Wed, 25 Feb 2026 20:55:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDCF6B0089; Wed, 25 Feb 2026 20:55:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11D66B008A; Wed, 25 Feb 2026 20:55:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6CF06B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:55:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63B891403CE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:55:17 +0000 (UTC)
X-FDA: 84484940274.19.7FD4F9C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B5464000F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:55:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W/mBYuc7";
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772070915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcJaCH2AkpbVxWXP+tBsoHVlC8zAoMaazf8Uk0jjSSw=;
	b=QH0AFWiRpMdc5lGegJg9ClAO2EfCCjgeR4IUwn4pqm+XsZpW0nZ1fDqtPLQ32JKmpfHk1Q
	1XREnPZkfLXHrb+TCqPomMGwPGkcfjLjIvHU5mp14M24GNF+9c8/acUlDJexxcGnBh/dx7
	y8hhGB1hteGf8xDzyWg6n7rwf2jPloM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772070915; a=rsa-sha256;
	cv=pass;
	b=4oTrl30DycvIAG/sDFgPGh/v1tR3ZvdN+7q8aQfGRflN9k1lw36PuQ/QCAn+6kifxkp4gB
	yIbwuSK2t7hDbYjHTNb4a0xG0hst8f5EJI9/xUSawbnRDHzv+Fh4HZPaDU+ir3PR8U40nz
	8B3r+QNSYaqK1nvrJpaHNO4XiMJnCdo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W/mBYuc7";
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2aad8123335so29945ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:55:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772070914; cv=none;
        d=google.com; s=arc-20240605;
        b=T2JR4ykjcJIsNGKrulErngQhS99WUI0nhVNaSGmWyXCE1hy5cihfqq1HuTISjk8Hu4
         FG8nceKohK/xBGemVwZi76QF1GG7SiJRh/3OZgd0szJ/PxDw8bLguPYxxLdjqcqeEac+
         31W2sgAfkDKnkYYatfGgcwhdkLfGwqwciuxd7vBLz3d0EevDgrsNG27g9YYubqVKrBux
         9RYHMzQnZM64ICv0Fpc6pLgwymtpkHu9hBjdy2O25zzko1d0AU+RLCv3gkRQ43Vy1ijP
         KyHF258AFzW1nsknlrqeMpobrmBbftxCjMZrSHPzjb24dO05Bev2mRHt0iDD8HNbOLUh
         Wz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gcJaCH2AkpbVxWXP+tBsoHVlC8zAoMaazf8Uk0jjSSw=;
        fh=Y+6mL2uhbbejMdVL2c4g+MN02g1RZUTIBkh05bf2siE=;
        b=GsXjXuhc3OkldiojRW+G6aAE9SkOH/XBcKhokoFTvraBoMLY2ubNjDU6KUwz3mOR7U
         DXFqL7+Cae5q1ChiMDqk411ti9XMzpssV985PqUMytOCOOybUBEFpPoozw7S4B6HNRLs
         0SoaQqAuCQxng4dIXi6cXqcr17z17bKoRAwsyI8ZdVeD6MmTe5F3+c9HnbsFGi5P3o5q
         y5UWtfYwDvwJRqs5NUji4juvPRM3FHmMCA8LX92sXPqcqyzNkAyLVnRmrm2M44wR5Z5/
         MY2DAmsDlSSvyA3kf3kpbiznPTPYspIR1R88uF9GmfIHvLfyLWfbbeg/diBHSVjFRP35
         BvZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772070914; x=1772675714; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcJaCH2AkpbVxWXP+tBsoHVlC8zAoMaazf8Uk0jjSSw=;
        b=W/mBYuc7PHdEpzDn3w7UCqZWqbeG1JS/c30y8+HRi3Phoy80tH0pQl6rXIRmE8JbnI
         m4rivUqabyjLbr3XBY7bryp/tA1P7eBYdpkoaIQvJpzuAA3attFfCbx8oUAMoF3bCJ35
         9IOzxDPlSDF0o1hyaH3Nhm3DWxqwf5Zl61iB5rnlN7QuODHMvqio2yrcxXc9HvM8iptG
         lv+cDnRxs3XMycrE5IFtHb8gtssDQSe94aAe86Qs8n3+lObUjmn+PYfRvhzY7tYc1klF
         Gyqgp6FSARY13cjmeouno3W6rqD0CNiwZePCP/5X6E83AguiFvOSPwGFdl5fls/Q+IV9
         ah/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772070914; x=1772675714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gcJaCH2AkpbVxWXP+tBsoHVlC8zAoMaazf8Uk0jjSSw=;
        b=PyYO5rWKspgi/o28rY3w7eF7MPrkRyC0TVN/eOP2ddbaO4cip1TyRGCh425knV9Iaj
         yWUHewxkwjkkKFY8rHlUObsmx1kdRkQVaGD+8gp1LbVOnt2yYL4C9CjMWJSYFjC2ok1w
         EoLZ8F/+93awUBwKNoAVlUtz3Cd4r/IXTzrQtVxHOl4RDcqrC7Bws1c+98Da9sOyy5hX
         j30H67xbowPkRedIusRSIB3dtcdEi5rdoUWhQrJWpXJ/mFengxUZ/KJugvwemhul2jcH
         SDWDqQkbXm5oYxHsA0m+clkX/LNzcRmmEgoREME6x3BNiRGA5guiPNwvUL+8ALybGrtF
         az+g==
X-Forwarded-Encrypted: i=1; AJvYcCUNdn/IAvY/DujG/HfAdqx1QK6K5BJNMYmoA7kj+pUUgrIbU6L9VVPiw5dAv/JZmC9H99EKBlkwaQ==@kvack.org
X-Gm-Message-State: AOJu0Yzk5ob9hKwLJeZuBmmiXb+7mljVbJEZuwJk7qiAzAq06KQ/ssoh
	XQnXhvUOhRyMlPjjc6ylBy4sVy5Dm2g1EsL7V5RjDsJY4B/Pyj2va9RC509ZulZmwa6H3C5cA4p
	BUQScCwKPfce47Ayq0bE3t65CYUGYNFd8TRC/Gy9b
X-Gm-Gg: ATEYQzzuRrCeTeYRidTHFjPXEfhwKjaqUfIy3JA3sGs71/uqBkaNK/yfXI2a5LDKp8c
	boWwCfuW/mMOjAp3CbQScpsH+3ECiSYUiCyfvY5e5f++kCsOhJ7m9xSjq7FBsXbc8liw+qypHJa
	BfeAKDEsPyO13PVzeWpqyg/W6IRDV+ykyqPbXpHak09hrYYyANkr/zYY1nxQAzGAmM606/ZGN+F
	+kenBwbhAUt1PJeTZuntEEp0Bc5n/dwbH5uyPyHN2N5l/BEawIfdpUTQr5Yaky9SYMS9/lkIU2c
	YbaEtr17OJ+EUnp1tEkqPpCxAaQ2qmRyMXLqRhy8brl04wFK
X-Received: by 2002:a17:902:ef47:b0:290:cd63:e922 with SMTP id
 d9443c01a7336-2adff505411mr854555ad.15.1772070913489; Wed, 25 Feb 2026
 17:55:13 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
In-Reply-To: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 25 Feb 2026 17:55:01 -0800
X-Gm-Features: AaiRm52AqLENYaAs99Bw7VJE_YU5OEBfkd-ExELzPs3bmIds7daeiIvmyV6JFw8
Message-ID: <CAC_TJvfi_5n2crGHbRVO0R8jdYcSCmgzUJPzhtSvWeCN6fCbQg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>, 
	android-mm <android-mm@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: wxug3ty3ts6gxrmu6fi73owm9nfur94x
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5B5464000F
X-HE-Tag: 1772070915-388238
X-HE-Meta: U2FsdGVkX19ononqsvUV/vyoPIQG/7lN6/Uw8S8g/NDw2nVSs9M3JygESZXRYZnjq5f3K/z8VvHahPK0fpdsg7GsRHhbBfuQq0zGQIAP2PnS0OCTNZXD7ba9FIuLh0sE7Dkv8cGL/SWW2SaYVgUgGjHID9wpoclWigiA7Atqc3TIAPRT75PZtAt5ciTFby1i9Q9cWuL4cuObVPk2d635dL8dS0itfky5mP6ykNDghAWkgxFPmgJ5cOhfESPSgdhcCwNJnreEta1h/N62hX9MtkZze66cZKJhy7gmMziW1JOc8uTc1dfxPQhgtw5GJpFaKl18PDzpWKWLum3ujfh/qg5OarH2NoImsqeo7JLSa4l4Z3JYGv9JzuI8LJ5uSMhaEdOWArJB7PSFg7yGl2pRjSagFkE7drb4H/nCjuKYzOAdIfZsTM4pzKUIec6NCLOgQ0GE3hXfVOQfdtI6Sr6pNvJsvAh6ip5aGND/eqNnPYQmKURXbEarKoy9xRfUw3vuUxfoWRHwMT2dHra3Hdm+zdAzANlcdr3SbMSJbpanW4VRnqYZBrwX0Z5lGKz7m9mpwqisxWbAV9KnFNdjRbfmeBFNh/NKrcNKWzOR6cJtQyk91/UJ7f2lEYImDYHYYqUaydqxuT6A35M5nal5FDO71FVKPziCHrOg1qN99rHehb6dr2k2XzyyWK8MtDh1x5hWSxvxAGwAmuY+eUuSfHYonqtBvskMmS5q2Nh5REBoSrP3r2xf8dy9FodooMyiARS3jbS60400qCjosXGTczpcRUkU9zQ69lcDHo22EhfjRAnaEoJiAf8E3tnfCUausW8+e+OF6hrRwa3H77CQxJuyB8nXJK3rVFCJoCy9WgOWJw7MGEGeq8Fzipc9wKOqs5jYJvtOaX4pyPTeENDfZvByyDbLm8+e4w+YGIVyxO1IM2ufMSgCbqaFgJqqNy68gUTfyUUeVd98IlVPRQtFwkp
 juIkAYUy
 hUrDgziGvS5LWT0jKVd0kLMZRw+OuqA5UoYOYlMQTonmjc8bZ00W8Orx7NYeyffbGzaydK3/9lIBpBmQXolBBawZX/zWXsNG7lHxDaON2nJgq6QgNVk6WygQxT4x4x9BvX+Oaq7/1pyUtvzhIYPzmkopEIxMwfisOHbvyrMSNDLxPEFS1iVEy969jcYvwtKR1aTXlaGfejDoIKfJrSLj+XfBCa1IrMysMePkcrLosx7GJcnYyi60nhCnyw7LCK+/Hq63kK6z3GDYAV+0OgpidSzwNZCREFBZTkA6OS5jO58Flg71FnsblQ8t0CVsqiuSYEpSjiDpX+xYPXL78QzV8TOD4phznVIo1ZqMic17o6AkN3lOchnX1EemJHED3pGSEDKbT+EGQjKol/7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 9:26=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Hi All,
>
> Apologies I forgot to add the proper tag in the previous email so
> resending this.
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
> /proc/meminfo.
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

Hi Kairui,

I would be very interested in joining this discussion at LSF/MM.

We use MGLRU on Android. While the reduced CPU usage leads to power
improvements for mobile devices, we've run into a few notable issues
as well.

Off the top of my head:

1. Direct Reclaim Latency: We've observed that direct reclaim tail
latencies can sometimes be significantly higher with MGLRU.

2. PSI and OOM Response: Tying directly into your point about metrics,
the PSI memory pressure generated by MGLRU is consistently 30% to 40%
lower than the Active/Inactive LRU on Android workloads. Because
user-space OOM daemons like lmkd rely heavily on these metrics, this
causes them to be less quick to react to actual memory pressure.

3. Misleading Conventional LRU Metrics: We've noticed patterns in
standard memory tracking where nr_active and nr_inactive show sharp
vertical cliffs and rises. Since MGLRU derives these metrics by
mapping the two youngest generations to "active" and the two oldest to
"inactive," every time a new generation is created (incrementing the
seq counter), the second youngest generation (before the increment) is
suddenly recategorized as inactive (after the increment). Because the
newly created generation is empty, this manifests as a massive,
instantaneous drop in active pages and a corresponding spike in
inactive pages.

I'd love to participate and discuss how we might tackle these
regressions and metrics.

Thanks,
Kalesh

>
> Link: https://lwn.net/Articles/945266/ [1]
> Link: https://github.com/ryncsn/linux/tree/improving-mglru [2]
> Link: https://lore.kernel.org/linux-mm/20260218-swap-table-p3-v3-5-f4e34b=
e021a7@tencent.com/
> [3]
>

