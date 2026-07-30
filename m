Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2231AC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B1B6B00A1; Thu, 30 Jul 2026 05:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3F56B00AA; Thu, 30 Jul 2026 05:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F3E6B00A1; Thu, 30 Jul 2026 05:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E087F6B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:35:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75201A091E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:35:22 +0000 (UTC)
X-FDA: 85044934884.25.1CB5930
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 908D2140004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:35:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EOcoQvbM;
	spf=pass (imf26.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NryIn5+QOfV5q6ne7Ag2M6p8wAK1ISxZjdVgOE/cIdQ=;
	b=J6GxjewDS7jLNwbXcl8zzFPxoGnA3jmiPlMe5iacZu/H/PEohHMg2ZV2GluP+nKSydTALp
	Yi5VvPP1U80Xcn972ed89ntGi2Q1o7JbZ06BI0/EDfAaQu1VI6wZIY6uMoqQbRWNx5VdLQ
	km1SZiEN78MxrhglTplMK27aYOLewBM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785404120;
	b=EA0xQ6553ntbGtggwm2fhtbFcfrCIYtsjSGzTPDYtKo6hWDLkVdZRNyOON29srtjbAMVF+
	tQTtCX78QINwN+Rak9Clgklz7M1wG3H4wpaKRgAqhWNSPigDSKEzVaEtWxmOU07LPZNtZ9
	8+M9ks6/8fKFuY0SiwZ7VH76/VkN+og=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EOcoQvbM;
	spf=pass (imf26.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39dba1ea83bso588141fa.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:35:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785404119; cv=none;
        d=google.com; s=arc-20260327;
        b=b+hU7lrNa1NgB1XxZouICEBcdB2hznmyfMRdojjC3LAP2RUYq4sXpwp72l2MA9sWFG
         wHc85y9XB5wrMCuhHnf9SpLA5EM3saR8LFrLdpyc9CdvTY9mDyus72RMd1Nf6ZIHkcmR
         ZWBP2LKBQCvUtpIb4v/vmtKsWOXV4oKIKM75htywDAO5KDAkDhcGxT2K0A5QS3DtQBsA
         gIlm2fZRessqeMBvl86fWEf2gZ5B+FpR0ZZ9njGOsbGPXKNvOsFeXEj0Z4OhaXE4M2Pp
         xl3VWteusVRIPnHnxYArwfVfDTVzMriTdk5UMYnxqIDdmTpsp904buhrlg9FjxK9o563
         S2Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NryIn5+QOfV5q6ne7Ag2M6p8wAK1ISxZjdVgOE/cIdQ=;
        fh=mOf5cvNS6a5+9beTXxkKaUSQSNCSxRrqqlPP0oH175w=;
        b=ORBim+71R3HIgyOpDW5TeGP9DVSIUiAXpQvYh9uP2mIEcpLt5fEYVvdJLzXf23q0rf
         aUIglrM1suJXPmB3VoiHOic3Qdy9bTjQnhefl1z8E1Y23u05yMZ4UpV0XMgZy2UBjCeH
         zptLChGKhNhcoGFNB/duHF8UmKaVXN+ZelD60mlvj06btdMG/gLLT+Ahmk72XSUY7lIG
         Mc+5fauBimX73Q+Azrkg/oX1m9ifzTiTa0Ysx1KAIggk+aQzMmnn6SrMalyxhMaeNdQ+
         ZvmePrOwjq3ArRfBMthhtxTdVxOSd1Ajbp2lSTXTI2meyb19yaLiA4qEg5jCbxoXmdWA
         XsRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785404119; x=1786008919; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NryIn5+QOfV5q6ne7Ag2M6p8wAK1ISxZjdVgOE/cIdQ=;
        b=EOcoQvbMLX4JrYDtKtw/YGwwTb745yWv2R8gq/yuOlBuZmgwVToTTiEleRM6vO0dm/
         0l7I+NselAIoIqzSJ9KAGSYXGZN7vw7ilTrYzD5XlOwLw8GYD0rlYXzCMwpTsA+wpcby
         TzSG1QsSgolXECTp0Mj/fqP6jpsaHDonz4hphPd4M+hrF1weV80NjZ70Q3zbny2N/ceK
         qtob6ulZp6FPByLihSg4LCevfy7ltFRHyrqVG1QFAXBuJOFKEWd266BPIuWpwKaM7CzS
         iGrSLFeMIr11daiS/Tv9ke02PaWEnch1ZMvh+C6maKhzqSVv7+HUmmwiQ5VGfhRTXZEr
         MEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785404119; x=1786008919;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NryIn5+QOfV5q6ne7Ag2M6p8wAK1ISxZjdVgOE/cIdQ=;
        b=TXuqgM/pagyM4HVRQDYZlnZ3FUKjW3spybmM6pg1g02hXJzKByVWctrDkQySnngkXk
         oxgeV8IeLFf8YDJsD1C6YPqInuob/fHl+kZTBz51tKMiJEMb5HrPSm2iODDEjAT2pFmp
         GpyEfhWyny4pd8Ncvjy8EaYlzX154uCz7kJA6kBtot/ZuCvWaEHGQwITx3XbBPlGDC47
         OtwMUdryFtjmbTIBzkaUt3aU037/3nqQZg/BsOc1TPI5LQk5iU/jYr8kFHivcXcPyGY8
         hOYOkqDix07EAh2hjoZcYe2kc6G3ddlr0fJC8PM/v1dL5/ybP0D1sjjy/MUEhCcc+o/T
         AsFg==
X-Forwarded-Encrypted: i=1; AHgh+RpF0e7//ZpG3rjJTHedMpgULTpKqaTP0WbkzDTZouBCfRG2MzmOs7zjhHL3wCsbtCubl3k6mJy3LA==@kvack.org
X-Gm-Message-State: AOJu0YwmrAbQSbOJGoaGVayP+JYxETGKwpVrzJWG9/lCNPsuDfGOEWYS
	KlPY1TGAEuJDm35JAWwWy+X2EpZomrg8WLhUEowEs7Irc0zhwq024oJIQsZIAuSUOHfJ2///h45
	3lkfaiKl650g1ybqoPQCA3arz/CRTGXo=
X-Gm-Gg: AR+sD10FODoLmlyONLz8RErQ3d14IM68UY+i5/CUQRBo4k1b8mlTOXESne1+WbbW/hy
	avjAEEIsQkg35Ci+a7OJ/MnFUmA5yR0oxYCRdNcMRnA//OJO8g73he2g+cOsNMh0RNSe3M98zGv
	Q306LKyE/FgjWCHKcMxEsWWb9vJWO6x0zOS1qBWWlb0DfcPDrIm7OZOm4QiOFUMvtE7JIYsLuLr
	UgsnqIC7A9lEARVZ6ZMvFOU/H8i2LgTsODHSdZl2leg6W7J1xycFj6aKIbH63HSCu97r4czq1Dz
	rnwKpOBJXE3TYcqaCI54ekQbslYjlkVUi07eFA5tfI1UfzmPKslcWlEy
X-Received: by 2002:a2e:bc06:0:b0:39c:9b7b:7e4a with SMTP id
 38308e7fff4ca-39f6b66ca43mr3973561fa.0.1785404118676; Thu, 30 Jul 2026
 02:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
 <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com> <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com>
In-Reply-To: <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 30 Jul 2026 17:35:06 +0800
X-Gm-Features: AUfX_mxfH-6xCYvo18fBqxaOOig6pKieEVfJffFKpWvj8n2KBPjawQWpAH6IPe0
Message-ID: <CAGWkznFCzz=ow2eDyzQR6UsAkLvuamEYpyc4PXJXXd6rF4HHcg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Barry Song <baohua@kernel.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fpsqym6zrcspjt8hemn1ixpws7zjubmi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 908D2140004
X-HE-Tag: 1785404120-667888
X-HE-Meta: U2FsdGVkX1/wbvuNv96pOoGWXXJXkkJ8TAW5qImP0smIsx3oCfY6T0KCHonmv3qrvmxXSSeH+kNvvE58c/uJEF2Bl8A34n1pl8+F4gzDsW9zY45oSc5/I++pl9GZPqJjjvHLgD+No6o6La84KcXXp+3+lyxBtFz9P9VsI+KQQRLqXskaBmdiqh3iH2ZKGURxMqSfAoIgX3BDSzFXHHPNOxJGijZsB+t8iIJIaHXW9CUb4asB2B8dYaSwA6zVA8cLXS/3vyhS94mkaDMsXuzbt4wR/l17317CoN4sdYgKh5SgbrvGe4ipxCSI0TlwMt7/CaYT4NK/+Qw3l0dax7UXntl6DJrsx1UJaoXJJZM3TJIYQ+CthwUzOb1AIj9DN8Ph8lKKjl61lcOOyDDG7EECYTOBA89Dpr6TLxc7NOL+Z6g9yhaZX4Mu320pB5Ma1QDRwVoQi5+RXzLFxCBsuMPrwruGTkqGkuzlmi6pblW9ca/s4GH5MOkBUWxGPjf38LuDWogbHHVAOi/Zd3sOt/uuW7uzIH4A9IZxnMJIsyGkhzAH5628X7UK4WhhVGqjyMSuPIW2uMeRxTgz7s4NyIEDZz23PSItL0oFWhLJTBwH8YmmcH3Nb+bmH0ZDw+1UJxy3reAguJxYqPqD+c+9Z4quHkmZ+QXtdk9tgAEZzjHUko5uotvF9Jmx+EjPOQ/ZMv/JficOsksVHLqCUCQya0msZQzuGz0E9QNlbURgjshh073Pug6jHg4yhgV3M4HrfH+mfn+dRW02vyX5DdDaXtgc9Zc83UNQq9eYN2GY0wxKNcC/KZAgeEgtH/6nhQ/6odrEUz9Eugw7i+yqeUqaIPLIBj2/O0+FYhHnoT/s1BDKPNpgmv5QHLMI7EOyYlPY4lejLnilAQN+un+RgPOBu1lKJ0RuRRjNFK+KcEEv5qz5mm9h2WtMW/gJOZ3yVmNo8SMf0YZ3sHJKu+xyyYQFSu0
 RjThut2R
 MMRj/Oyx2g112vURaeyq7NrfFs4PEvNlLELTocYK034wewZORMZlIsy4OOZ6azyQDl/hqol33hTjU2rfzp6dGCa3W9QDLuzT+LD1b/QSTmgQTfmrEFRWAs4VRqwHiNFYAufxFSEH+H7gZ8SWuX6e3OV+0UVcy9DE4xx8rkFxnCtxFplFoLa5+tGietZDTU2nczHCiDssxEvA64f3TukYkiKnTQJdILQotobLJ0sicAZOkBmqGGpMWCoo2LRddQ8HmbpaA4HYJ24CffheqtxWb6SeX90VjOkg6rKeH55NOzK4lYw82vkfHl7WPXhioKADnDohuLQsaZFutqNDjKvgzgwEuz1iVawMetY5KFgkItFM7/849zViKaa1dQTsxWXjJUI5M/8MOnqfxzHOmMp1Qcn4ln0tFggnWqUeIYriRPvKvNQ70OZU0GM6VQ7dDjuEDVLZqbN09vmiUcBri4ULsbYlaID24h03Qjtyo4G87FJs4eJ62XGaY4BFNZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:31=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Jul 30, 2026 at 5:20=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gma=
il.com> wrote:
> [...]
> > >
> > > This is very weird. This seems like using a sledgehammer to kill a fl=
y :-)
> > >
> > > Do you mean that isolate_folio() fails, the folio is put back
> > > into the oldest generation, and the next time it is scanned, it
> > > still fails to be isolated? As a result, scan_folios() makes
> > > no progress at all?
> > > And is it because the oldest generation contains only this
> > > folio, leaving no other folios for scan_folios() to scan?
> > >
> > > Why can't you simply promote the folio?
> > > Do you know why isolate_folio() keeps failing? I suspect it's
> > > because folio_try_get(folio) fails repeatedly?
> > Yes. As described in commit message, the orphan folio is an abnormal
> > one as it is on page cache but has folio->refcount=3D0 which makes it
> > isolated and putback to lru forever and finally be the only one in
> > min_seq. IMO, MGLRU should keep make progress with bringing this
> > orphan folio together with.
> > >
>
> Why is a folio with folio->refcount =3D=3D 0 still in the page
> cache? Can this be fixed at the source instead?
Yes, it is a bug and should be fixed. But I think it should not affect
LRU in this way while the legacy LRU could move forward in the same
scenario.

