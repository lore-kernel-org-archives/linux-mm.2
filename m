Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F759606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EioAxN2Q
Received: by kanga.kvack.org (Postfix)
	id 324766B05B0; Fri, 27 Nov 2026 23:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB456B05B1; Fri, 27 Nov 2026 23:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212336B05B2; Fri, 27 Nov 2026 23:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E25756B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:14:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5443214025B
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:14:23 +0000 (UTC)
X-FDA: 85483210806.20.3B87CCA
Received: from mail-oi2-f1.google.com (mail-oi2-f1.google.com [74.125.231.193])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6151640004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:14:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EioAxN2Q;
	spf=pass (imf04.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.193 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795839261;
	b=moA5spgN/h2BZtJr704WS5YQuH9LB6J77jp6gMMtjlvCfn7d7VrGDyk87MiGjmFdMR3Sci
	BGetNwDHIbtt72mIRg17yfKvO1/OQIVzaFYwxQE0nIPo2R/GQuZVM9OSCD+J2cBA7pIjl6
	5ss4dN17jlSZTvmu5jePVPPWCRZFCB4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795839261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MS//VKnhVp50xvqDF1t18JZigW1wyOpsxLJLVKtzR6o=;
	b=07ZuJacWr3R9H0mX80Iwea+C7rFo614wkesYdc73k1btG8GVZPBS/TZEGEvf7zd6fJFOu4
	hSJ15OfwF6myHHpL85ayQXO5FmMPOIYCRRZcylhvND9eIzFWx/ywGRBbL252uoADgwLydC
	RYCF/p5jK2O1sYCRIhWWJ6499KJdw4Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EioAxN2Q;
	spf=pass (imf04.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.193 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f1.google.com with SMTP id 5614622812f47-539d2baa897so2954469b6e.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795839260; cv=none;
        d=google.com; s=arc-20260327;
        b=FRUCPPX7tqMPn2m+2+GUyFOoTG9xEBZTR8C54RYUegu7voDz8Stey1k1+sxXUhtZd5
         aUZri7J7+ZFvUKODvuWVg8MQMJIzvstnOnQfVVxGAkPL7Cfu4IVs1oMrHfWEFrthlSw0
         CI/DBEBOf6ZmMlq4jwjQX8NkDFUFDraWq9th7kmJK9bKWLSztMBN7OOsu+b93WuiDGd+
         327/cmgDM0DYyqe6FmguId7NY97ps7qw2US/dNOpyTQP4EkqqgCIK/edOA+fCNSp1+nN
         l0cE/o5dTd059m9Bam2IQQG83DO78uooATII8rJiuZryjHsgcM3E4tNKdo5bzEHA69ou
         OTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=MS//VKnhVp50xvqDF1t18JZigW1wyOpsxLJLVKtzR6o=;
        fh=WxnAfA5ipgZir9xgUONUgUcsqiWjmIKUawDLcKpwzNc=;
        b=Yul5bsPsVP1ZjeQXqnCbcqw6l4UZhXgL98xEP7OQxKszgD1YoAdx1PWEY4+0CQZs8s
         60JdBKXrsAGz/9NN//5gml0ssW4nTBsblXJxlLJ2tm3e3W1s9sJPBuXB7bh1Vg+Gsbyh
         3DuX8nugblehMbY3920v8vLyxCjLuJMxbtSCy15GLHFNVT4v0VWaAD+TpceaYzuLZni7
         ++cjuZaUQ5aWycuXS3SdM1FnsImh0gK5e7orzLJT/x7YPJJea1A6NpAd/xVL2gHycK3Q
         JRkDnsM4sMzoezsIJihLOOV1SudQIVNKlXq/kBrTWitBzZQClJkm6NP9VBHNFvtrh0Oh
         NqHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795839260; x=1796444060; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MS//VKnhVp50xvqDF1t18JZigW1wyOpsxLJLVKtzR6o=;
        b=EioAxN2QNEAAUSU/QRWO+75lVP7dVEGibupj4mA+gTSDmms5QiIoZkBj9FRofuf7gP
         nlnEzTIl1fAme+8jGUXVIh284I+1kljM42lu/rFoWMm02dziWh5xFuJur7d1GynbOQor
         Rwj22T1TWapaGm36urZsFlEkOj9UEiL7aa3h7fzP5HEod6/FBZqnqbi3aHMAaUjA/ApY
         8VldaasnBeXkZ7TN256zlsYcy6w92rgg2TRKqQHUEQexWJO9oJ4WJykJA1lZISL8BnAV
         FMgRDkzF5m80MdRaE4S22/jCcdxMbrREBAOraq67NAgc4WpVWPY37cT1BQJIvBEmMhrP
         +X0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795839260; x=1796444060;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MS//VKnhVp50xvqDF1t18JZigW1wyOpsxLJLVKtzR6o=;
        b=p5fCUxYZiPHr8gR7uHClYYCwE8E1/ACKMdfZ6Q6D9d99C43YFUvy5BQCpFfhPNVI4l
         nV56Fqb77+6c+C3J3XpA9gpjQRfGCGFdS/4etNBuzdp2AwqPt3+5fUS9WVDNY63N43WJ
         8XdK5eVvaorbuf4fwsn4ZwtXE5MhOURp14fxDASSk7spfpNiw+13yXJxJrJd0oPMs3d1
         F4sqZJHwz6ZW0QqZN44VfWJBBS9dL0HzpC7DG3q7rLvVUibKonhFEMvcdxBZ7NL/7Ahs
         L48VIK2Nc9kmIYWgUYOuFPtXWvHXXDr/J7Ml22PPLGdYPpia8tIMG7BGyrH913iIrcp8
         myPg==
X-Forwarded-Encrypted: i=1; AL+hErFvfK/HKLw7AFckD6pLUpsHehXvnsG793B/fFxuuFlv2n26OlgLf0hSQoQVyd9jlQ35iJOQIaq90A==@kvack.org
X-Gm-Message-State: APuU4Z9p3FyMyIkK0GA4IbbnSrc94a9udlM6L8uSafDXctZ7+kcAVS4k
	mVw1Um+8qUUsnGaCDezm/krRGiGNE0gKlKjDLnimf1p2YAmkD005nbanG86Tv+kCKDuLhfIpAGW
	3VlXlchBz25mycoUI9kA9fg06W0p5FS0=
X-Gm-Gg: AZFdTZedyvlRi2ly19Bq4pR16DF9xwN9gBFTFZFnTdA2kpW/ezPd1nCSuHFTNXUi35h
	eNgAL6aP2BLZzYqciry55QazeMnOtezqJJChfLaZsPbrUUoQGvImP3Sn/I+fDhEzsklf3ZSJfm0
	ufXiv89B4VPN9XXTYIHa5r9pJkUilg0hMqzMLLCO3m5MmdxpdiP/zFsKyJmxL76WV+vPLKHfgGf
	wFZwezodNs5vhypfm18ZsHF740zFmpHkQIzPdm0BYANE1FI3klyjrQKNr6drgvFAgilkZ0XhxYc
	TA2FpV9FR95I/D27j2T7QRlfvqD9bW3weXxG1ngDRDNkagCLqK8qZPoaeIcM7xMaj4hqEe3OEgx
	TDvxulLVpUkffO1r12oYrb4Wso6ONaxP/EbY+5kssHnulW6U0Ksx0peim2ua+G/Es/64V4Hw09h
	sFyQM/o+rp3ogQeSMhQvVtcxtESIo=
X-Received: by 2002:a05:6808:1307:b0:4f4:f5b9:8c74 with SMTP id
 5614622812f47-57a035c6c3bmr32958979b6e.0.1795839260304; Fri, 27 Nov 2026
 20:14:20 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 27 Nov 2026 20:14:19 -0800
In-Reply-To: <43b57ca6-cffe-4fc8-9622-c3e3645d2976@kernel.org>
References: <20261126-hugetlb-resv-drgn-v1-1-345a6ee7c08c@gmail.com>
 <FDAF27F6-A5D1-4911-BB86-6645272E2BD3@linux.dev> <179578806997.38.3754686117717776990.b4-reply@b4>
 <43b57ca6-cffe-4fc8-9622-c3e3645d2976@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
Date: Fri, 27 Nov 2026 20:14:19 -0800
X-Gm-Features: Aa3M54r-r32KsiX1w3Mdj070u3Cv8hWU9sq7tSG7Lbv9wlW3EVgewOgfc-zGfmA
Message-ID: <CANOyQmF=a=iPi65witUpcEtSMtVQ4g-0g5NeS2aa755c4gKC3A@mail.gmail.com>
Subject: Re: [PATCH] tools/mm: add a drgn script to show HugeTLB reservations
To: vbabka@kernel.org, muchun.song@linux.dev
Cc: ackerleytng@google.com, akpm@linux-foundation.org, david@kernel.org, 
	enderaoelyther@gmail.com, joshua.hahnjy@gmail.com, kmehltretter@gmail.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, osalvador@suse.de, osandov@osandov.com, rppt@kernel.org, 
	usama.arif@linux.dev, zhoujinmeng@bytedance.com, ye.liu@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Queue-Id: 6151640004
X-Stat-Signature: hosorynzrb6hu9diudbda3jf1bibsm9y
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795839261-69602
X-HE-Meta: U2FsdGVkX1/cZzqIvH9Pmiwt0VaqTM8w7PHCWSU0AR0eIL0aBEbWex1D0Gxwz+nEjacc/9YY6YbXIHK9R8jYwvVncaP5MQsjVQp5GhAoYe4weRCgqRbLLzOUQnoFKL97MhT9tYbRNOfo2LVNg/RKdOQclNeLWIv4WZH/bCuqi1QdTQg6gFJ/4marzhUwmdh70xVqRfaahx0FoaUK8tP5Ox2WdVPlNWsuCZI0QvkNHG9AY5YOcb3hCP0IdvjVeCBi/THFdnk/0SHzG5DrEdaIZNyLrl6cAWs+80JegFOvl3Hd/qORf56dQWV/0wPBU14xwk6Jpf0ucnByfJa4ZUSTqYMg4Mq/QgQFVavpwc9VoaOZoahQ+fcA0mKjAK0Emf0nZ75dIfnkeLEAuq8ivOgOglolSyoRAa/M8v3IU0K4s3+TOaUrfCT/esugM45vxECYjn0GQCryHTfP+jxWb3UtuxxyVyKCb1SKLE2ydnZ7mY3W5DG0qytebJYb8ni1j0K68h/ppY818hi4KTDPR/LihtT8FrGLSs0+lDiUuBFo/89AfSsurUcfY+v0nohdmbFk9TuBMOOugZlev10OrP25cipy0b+uLbf2zRyUXx119j40Y+RInVRYBoV4KllqD/9gT3Z1lfbIYFvHNlhdfUBPJe6g83ucsf3ms6T1wzMmXShVPt4J5IH7b40FSppPGMQli8CBkdyP6IWSIgaj/6EL/TR6g5ZGIkuVmmwkO/VMRbcnKD1iWCIHwhJuG9eLjJa2u2i7zsXuPwy8n1CIkkCrCyr8ikp5BV9zkgLLbeULJ7r7+iex+Y7BvuT8OLk/zHQBPMGYaLyqGUpG1ncEgSOoIioRXuxhMxCL4cn9Q461TQKtKfp52HAWpYWwycCozE3TP3gLgzv2/v9PmJVi528S+qwymcaZiW8O3+y1vg1dLrsK9ggQDbM78xrkOYAz+owTseE9RtjnlBkGqNwSXgj
 qfUwKKYO
 Z9xIO5920mTQDNOMSqWaT+VSgA8iTrP1UQbMct2gP73oTYoreW37eN1sgHciCIUsKOPNgctg07y41wCgtCTI8MQv1+PKaX5SsxlEYO+i32+/aQslScEVY/0dLXLMCM9wU3Hnj0xZztDwHvYpylEfUj2gGfHxz1QZBfr9j8SKygL8qXiwLRjN7E/c2p/ydCLfQU1oK3AoGuTrXupxOPqNvrd3JymlXjQIL1MHA+9WpgECIJeNBN5HCkcui5L2iDuN6cI+tHLc08YDySirwv0VZVFsslhtS/5T9ED6SiQPObirSDIFl2shu2rlBLdF0r7vXAXuVmIdqxkzo6cOyS/rJkfyjoeBJE5IvPiR8fjjVhRhHb6+vFRxjrIMwJt2ZampirX/7W07vmd6Gk+/VtedbIAOLf6/lIkBFb7N61Wg94rhfnwcRuPABMSZr9sazWPYKgiveL1d/R1/FmxSP2JjVA62dlLPuz0vB+CmJcBN1hq0ixTCp2+xkU95nsylu8tErfO4yCoLta8JDS6+BD8yHzq62AGMqfpgr2hdLTTI95zYo8l36cAOhIFPy+mATmY716h3rFz8JXdS6/Mi32wBuAN7BiByZMnUk5BSi6DOONkDdAzgFADPELs7fTpEh2tOAh6eveXhOENyap2FX2GdzpynF7+keXSJ4sjE+Erl4KpLFH7gCPOXnnFF9epj6A+h357J2H0aDk088+J0VH5CIjPlKspaJ/MIzjelNhBDG4S6gnaLIaBWi5HeHWBUN5zrbEzqQAK2WsPzrwqkq5El8SOMREK4tCQEODOlOOYqjFfu0XUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vlastimil,

> and automatically detecting which scheme applies (not from version, but from
> what fields exist or not in the relevant structs, etc). Like e.g. the crash
> tool does.

LGTM! I'll work on that :)

> IMHO it's better if the support is part of drgn itself and can be adjusted
> with kernel changes while still supporting older kernels at the same time,
> [...]
> the user, who doesn't need to fish for the right kernel version's scripts.
> Which may anyway become out of sync because nobody notices, and are only
> fixed in a later version.

Regarding placement, this ties into the discussion you, Omar, and Ye had
back in July:

https://lore.kernel.org/all/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org/T/

For tools closely tied to subsystem internals and accounting logic, I
think there is still value in keeping them in-tree alongside the kernel
implementation, as it can make tracking relevant changes and maintaining
the tools easier.

It would be nice to reach some consensus on the criteria for making these
decisions. IMHO, the criteria Omar outlined previously seem quite
reasonable:

https://lore.kernel.org/r/aACaf4_molKromnT@telecaster

Adding Ye to Cc since he raised similar questions in July. I'd also be
interested in hearing Andrew's and Omar's thoughts.

Thanks,
Aveline Noir

On Fri, 27 Nov 2026 19:55:45 +0100, "Vlastimil Babka (SUSE)"
<vbabka@kernel.org> wrote:
> On 11/27/26 15:01, Aveline Noir wrote:
> > Hi Muchun,
> >
> > On Fri, 27 Nov 2026 19:30:04 +0800 Muchun Song wrote:
> >
> >> The Dragon project itself probably belongs to this type of script? See
> >> here:
> >>
> >> https://github.com/osandov/drgn/tree/main/scripts
> >
> > Thanks for the suggestion! There was a similar discussion when
> > show_page_info.py was proposed for tools/mm/:
> >
> > https://lore.kernel.org/r/aACaf4_molKromnT@telecaster
> >
> > That's mainly why I sent it to the kernel tree instead. Having it close
> > to the code it inspects should make it easier to keep the checks in sync
> > as HugeTLB reservation accounting changes, so it felt like a better fit
> > here. What do you think?
>
> IMHO it's better if the support is part of drgn itself and can be adjusted
> with kernel changes while still supporting older kernels at the same time,
> and automatically detecting which scheme applies (not from version, but from
> what fields exist or not in the relevant structs, etc). Like e.g. the crash
> tool does. Yeah the scripts are then more complex, but it's much easier for
> the user, who doesn't need to fish for the right kernel version's scripts.
> Which may anyway become out of sync because nobody notices, and are only
> fixed in a later version.
>
> > Thanks,
> > Aveline Noir

