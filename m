Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CCBCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 21:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118578E0019; Fri, 22 Aug 2025 17:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0A48E0018; Fri, 22 Aug 2025 17:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006098E0019; Fri, 22 Aug 2025 17:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2DF48E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:48:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71330839BA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:48:41 +0000 (UTC)
X-FDA: 83805733242.27.CB81334
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93CA6C000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:48:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hvdy1eqR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755899319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAIEX27cljqcvEISCgHpGYN/71b+wZUhIVArwfYHUjE=;
	b=yJDWs76Q28l/XRhDl+0FzCI/jcnJpJmhffyZS69vRAh1Yujc0V6ki/H/P12iYe7O51sLwZ
	JdLXsVuKhOkUrUSdwfENmXwmoUoRVPjl4FY6EvktFEcZm/9EjKna49mwZ5+iMdIggpRDUI
	0zWbatT39fuB48oQb6LqF8KmFX4+b2w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hvdy1eqR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755899319; a=rsa-sha256;
	cv=none;
	b=7IXtGkuzXXnhMolEokhMSdSuTgLZJsExxrl1V88oPuxW+XU3FjyfHa/ospUPV50r4Gy1NS
	oAt8gneOUUIRr+dYrsE/YDOnRB9dwxhCS8VIZYaqBJP8bY+7Ve4LdS/G6tct6igFcQy4X5
	kE5W1zrVydHjfcNCpELej6qWSwy2+d8=
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e57010c2bbso12376715ab.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755899318; x=1756504118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAIEX27cljqcvEISCgHpGYN/71b+wZUhIVArwfYHUjE=;
        b=Hvdy1eqRmc515OV+AaXCaKR08wa9PBHe5T3ODgeudnsaPKszXnwmhqM2NcdipF5cel
         1WYdJo12eEOWxoabZZDIeSSKTdNNZBk1+lyZfooWaPOGW/ndQ230uhM0POhILTO8sHpR
         pga/FN0rmATbWvPveu5+iJB10H6rEA843/eBUJaSnoYR0gZnIvgTGqA5rbsn44pzJtXo
         iDGW7zKZwiivp2xKEM5QK8ogw/MNZzYo07P2+XQJirMfPNCs/6C4SwxTiN/W9eLGEPLa
         yO5o/vJN4mKfBNSdJ7GZ1X85mj5KJaY5Lr9iA5DBT7OjrXwXMXe3YaDNeA3jbvJHFZnP
         I2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755899318; x=1756504118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAIEX27cljqcvEISCgHpGYN/71b+wZUhIVArwfYHUjE=;
        b=qr4XbGMuRo0Zaiy5c18wab9AJFawJFWP1HQGgkI1JRZdyiUG0gPZ7C+Ok3VCj8EvtG
         yJmOkZSmb5UJN3pjZhH7pXeuWcMr9EJ0zmOMBmiTC3e5Zm2I4k/dJG7hIy6smtEM2u7N
         bOCDV6l9hFg8pGjQRDfed8oiSDY5a9iHsj4+4cNjgSZMKejWoE5CRZkM9aZfm4vZmiM4
         NR1D0WqVdJqXoVNu9V+zDO0rsttOkcWlEooSerPonN9dMJoLwxNZx/rDFHS5tvpM6RlQ
         71tAA0pUY4Ywlgp+TRrxnz6YPuD/tana73g84Z8eY8ob6ADZiuOwNUE3vsBRpoEy0V0Z
         FpMg==
X-Forwarded-Encrypted: i=1; AJvYcCUuJTzV2LkDlkQNQOr6ZcECrnBVygqrcfcCtqDgeUPfv0cXbVd/aNwaJ/xmgExdJh9cm8yHalclJQ==@kvack.org
X-Gm-Message-State: AOJu0YzPEP27g10ao2BSyZBJTMsY2XfsRg4K9gNnyiVW8xap7hYWteQm
	jR3bgdN0ddn4bsMQVzeaw4E1z3o/DOWFFF/Bjmun6C4JVkAoUnMPbXf7KzifkDb0axV4DjBTH79
	es8bmCoGAWZL92bCghKDrvbmYWFH/O9iK3FtE
X-Gm-Gg: ASbGncsF95wRJyh4mLxuJXVhQ8sfZoU7lP0suOYNfzlDZvPxHbd9PkWRjoJoE87LJJJ
	xaKGpDmKHowx831pRnBazdqhSjhPoo9NBk+IS6nfHBkW2VD4WEO1AciN0hwlUtCY+wZ/e8a5OHl
	9+4unY9lsGRpwUrYH1JVIHeEQhacq1syvDKNIdPsMOP2mJkapHTJIEyg9vdiUq0W6ptIHC7O19t
	WeN9S8=
X-Google-Smtp-Source: AGHT+IFfbgSDdnSYcbN+8LjYRoerwSuYliGkWYiz8XOJtJi017qiYSnfomfKss31HGiJ8+cI3oMP28PIFron2nX1K9I=
X-Received: by 2002:a05:6e02:1d89:b0:3e5:41a2:d71f with SMTP id
 e9e14a558f8ab-3e921a5c909mr68305415ab.14.1755899318504; Fri, 22 Aug 2025
 14:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com> <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
 <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 22 Aug 2025 14:48:27 -0700
X-Gm-Features: Ac12FXzqUx4hJnuCRyNUz_zHahXkhP9hKAQsHKGI5_cWZzqkZgjo1ddcP3KfUPk
Message-ID: <CAKEwX=M2HCsPZVmXpvpAuF2N=4BXbXAMQMrLLRp7nCdotb=abA@mail.gmail.com>
Subject: Re: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 93CA6C000B
X-Stat-Signature: jmn87ycqay9j1cmiibdcmsijprga9m18
X-Rspam-User: 
X-HE-Tag: 1755899319-488992
X-HE-Meta: U2FsdGVkX18PKCZLGqNsOMfbZJmNnuK+Hd2LYP/r9JnYCZuRjc2STyHPQkotHagk7CgCRJ7983l1riMUEFDc52A6jgSz7mTB+zAn1zwGU6nrn3t3VWL9W4BwDlj4OnWeS8UDHbcNhAqDkHpHQEa79m91HNi7qu3nO6/lvAl2bGs7rGNtQv+vy6H4js37tzUg+HqmzydBqXyKieyO1fZepIPcVGGo+1vZmErYIbymGRSK8T36ASGJbWUTD3NQv71iHcY8X86xI6i899OV00Aq8kcyUnoM3kyET6TcF8VH4cYM6xB8cpujfYKWEOpxqMOoLmyvbA/UPazsj6Xn8w3FSi0/gVqGUJjZJhwMnUPTp4uB/7BjlCVyFZUeSWzQbuC4RvhPHQNeB5OLlz+kQyeNoU3eQ/7hm9365GJwcNwG0l4NUtIF7VR3GeytJjjakFgTCNZxbNeDwSr0d8WPWgfcKZPOEyiYfdB/VLExrJrAY3HEf2Fy9euPGdhHwNXnUeYK4IBJFZnOH+zdblrKyK460R+0M8O7LqIo50FmCGXp8td1tKM3AS8eHb0+LwnHjDocItyi2RsC9EXJ+rG3B4oX1CUl7wJbQDrlx+IE2uY9UiWVP5hiYFKifeZxUaI5DrCXKny5+rssHCvHvq+jKAf5K38Sjq2baLpsofuQ2R0TaG80yu1AOk58UKQSBoVEQIwUfvSFhr9uYqiResLZ2BJ3dz/DfmU4QahXfMt9eavkDazqXKzlmxcGptmDRxSi0SPVr2KVzkEplMO5hiiKg8nzzXXgulSnzaTrTqafTw6ITh3s1ssR8lUXR5ih4yoMJbgZwgfDc7ewmS4BpDqWxvR1EF9ODYii7UP3bU3rAnFE9RD7aSVfn41LgX7HkdbQkbSj7wd3KDxM4T4hd8EJNWguyWizbenR6jpsmPEu9WlHGMf84bIjR23qUXgjVWa9khD5tFYOa2NEKrQjF5JX9C5
 dR+3m3Rc
 wuKNwwLMeBSCB90hkq5f/1jrLoQnOe6nRCnM8p4ZmRuBV0w6yfE4jLrSTWyaKNEhoBLHHJzRtdc8JrTUW2ghU9UBUhzaILhEHjZLlMJsTNxbfGcXMMDxV/f5DuCCgQkmJeSFZE8q8iOV+srNqBFgruWXpTCWuYUWWVKGtE5wWzjytI4IQgRkzoltHwT5obHv4YOCZfOdylah50oWNzymD5i4iiDwsDhp7+NYHBY45ZxnA2w5ihV1M1kRiYSNU7yVbo+AjmmzWITr/2gfbmGQ2sRYF3qBf3ElobYMTAoC+PIUzuLsGXPVjkslNuSvImScisf82KNht3ZkAZbfqXc0j78CbwFqwxGiQJVJFdSs0c5OIEVa1xPJ+FEcghM3zzIy+y5GsaSoofZIOtiB2v5x7GegP9m2eCxzLvd4GfhA07YVCpHqp6pXxQLPzVAQ5waoP6LyWE65vx8ZZepRtjKg0tKP6UHneiYWWze4FEBT+7etWgCyBM8cBOKUmVuxqokurtULrHPCzaGiyUJpBCqDE8TVqytsGgS1J3BJfvY7fK44xflOAbYI6LrYjfcOSMtC4DexToAOg2dBqwi6Van9az6aK9jCcuA19Wz449y9Uvp25q9SxYCW2tV8q3Lazmb7O2sw0mkIR4PQrACtI/RmaBjCzzqQp4cNpjSR2OsuouJ0s+9PPqBELeCZem2swQZW3Px5BQtcDNXYaxBEXHRv3yk0MOJ9OB81xdSxUfl09SHiaK5PQhdhHYiwI6RvJHQCFj6F1M/2rUax1nYlhV85HElzqFxwGjeCU4t/PyU/a2Gdetcza1IEcE2kfDsyLAkfyZ7pUlF0J05jd6AKj/Cuf5rYqL+6QlwqLLL4um4ZCk2eXGAerOfbuDhyNgowpWXnMF6V8B9WigV7BF1V6xHh+7/o1ysnUo/RNAfFxiLuNQ9V01O4RZeD+3557m84e0I/aG5+CEYzhR/omGzr+ln9wo1wgwUHf
 jGu2SZof
 P21CI+zhj/VuF3qM+nMKiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:31=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Thursday, August 14, 2025 10:29 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.co=
m>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v11 18/24] crypto: acomp - Add
> > crypto_acomp_batch_size() to get an algorithm's batch-size.
> >
> > On Thu, Jul 31, 2025 at 09:36:36PM -0700, Kanchana P Sridhar wrote:
> > >
> > > diff --git a/include/crypto/internal/acompress.h
> > b/include/crypto/internal/acompress.h
> > > index ffffd88bbbad3..2325ee18e7a10 100644
> > > --- a/include/crypto/internal/acompress.h
> > > +++ b/include/crypto/internal/acompress.h
> > > @@ -28,6 +28,8 @@
> > >   *
> > >   * @compress:      Function performs a compress operation
> > >   * @decompress:    Function performs a de-compress operation
> > > + * @get_batch_size:        Maximum batch-size for batching
> > compress/decompress
> > > + *                 operations.
> > >   * @init:  Initialize the cryptographic transformation object.
> > >   *         This function is used to initialize the cryptographic
> > >   *         transformation object. This function is called only once =
at
> > > @@ -46,6 +48,7 @@
> > >  struct acomp_alg {
> > >     int (*compress)(struct acomp_req *req);
> > >     int (*decompress)(struct acomp_req *req);
> > > +   unsigned int (*get_batch_size)(void);
> >
> > I can't imagine a situation where this needs to be dynamic.
> > Please just make it a static value rather than a callback function.
>
> Hi Herbert,
>
> I am not sure I understand.. Kernel users such as zswap/zram need to quer=
y
> the algorithm to get the maximum supported batch-size so they can allocat=
e
> resources for dst buffers. The get_batch_size() callback and associated
> crypto_acomp_batch_size() wrapper help accomplish this.

I think he meant stored it as a static unsigned int field, rather than
a function pointer (i.e dynamic) like this.

Does batch size ever change at runtime?

