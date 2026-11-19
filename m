Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B293F606A339
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tgaFkcWP
Received: by kanga.kvack.org (Postfix)
	id B725D6B0603; Thu, 19 Nov 2026 10:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B499A6B0672; Thu, 19 Nov 2026 10:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A878C6B0673; Thu, 19 Nov 2026 10:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85D9A6B0603
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:57:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28B79A7F34
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:57:38 +0000 (UTC)
X-FDA: 85452323796.09.345599F
Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C685100005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:57:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tgaFkcWP;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795103856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNN1731RXRr0vyB+I+4Vk0Kb65E7JyUhQG5+tsFjqJg=;
	b=fJZUSPx6uwkf7wq5fJL7AAVhCuoc0UFXfXH/pPgHaY0swdqK10yiOeeWnskKn+ySZ1Yj6T
	H4OpfOJ0t3V8rBqFPUY9bZHMqf7cWPKYzgBEgSPNW+ilqYY1A/UdZLxT5ZkphUr5a97ncr
	7+XJJqlWQyiZWzU+x476d5x9PcQyri8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795103856;
	b=JxaXwPmZz11rLTQ4C6sG+wl4VrfHx+/pXGiPWJmJlW7yuc9CzTDYSfFKgYw92dRNUThOhU
	ljRtL3hTKT9OhYrCyl2ABcpNUeKVwoiz9t8WjlmFZBdcAvA+YNbzSWGKCaHVZx2EsDxWVc
	2BF1VTtvg/DbYPm3AdpQLVYZlh8T8HI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tgaFkcWP;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E1Mtv6PwMAjNgu+Yqi3TMm4tWjlWRE3n2A0rfbbvK3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795103854; v=1; x=1795708654;
 b=tgaFkcWPzhiH88uxNrb8BDATZnFgWbgpInWy1MXUj2VR8nMoVFYxquGWP43wvIFfDRg0u7wk
 +VFC7wqWFujvC+Y0BoQiXJmLwTrmzfOBrHTxzKyX6CEwfmMksI9NbXHIFBpM8SfBeTnVzwsOP1l
 9sQUMP8FlyRcgT+pFU+mX41g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 79771307de0e0cf3;
	Thu, 19 Nov 2026 15:57:34 +0000
X-Mizu-Trace-ID: 79771307de0e0cf3
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 15:57:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <6b898ffecaa5b82e06613c60ed0bda6c7df292f0@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 02/18] mm/swap: clean up hibernation error
 handling
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <2951eed4feabbf1a72dbcaedfc011782d9885604.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <2951eed4feabbf1a72dbcaedfc011782d9885604.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Queue-Id: 0C685100005
X-Stat-Signature: 7gw3uqadyzzkji7xnngpo6z8dccf5kdi
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795103855-540425
X-HE-Meta: U2FsdGVkX18tQD3ul56bQjZuM6AyJ7IbRWCsShsLXs+MhZ1VpTdnCX91fqMosACBpIMr3N1trRt3R+03abdacNkva3u6Eird2WLo0Qp0BOCk0LOYjjrqPbbM4KPrG3/o1cMFSfU7qQSxoAIZN9NFGSNzvOZYIcuwLOIrNeiKXa1sfXKn902k33Mo2TH/5Yyhb4NpTRzIldGpPQyIHGJ37kLems6zRuChuKPTkVgKwe7SmZ7UFWn0eUqEZ4VUaqjGsbnuA1kBOzgiJ0uUsGivjxuOyWpYCP5pn5s5B6t4f7s6GGaF3ttS9SxOxajz44gnwfTG+lQn+gbA2sD0Tb1pmnA5vbwdDovkOgOgAOJloeuwmk3DJM0NsqWhy0CekPBEvwyFHhYIp53h0r1P+eFdf3prWa+Pz6SFHl+0SYo796mbDr/FfUaPFF5kxl1stCTpLJF1OkwPnwhHG7En4U/ubtVZy3SrG94DIJWXGHNC05e1RKrZ5cOzazef4um7R4/dP2T2MO+CxgDqYsj4jFqdUGer+hVlWjzEhUE8r5InjsN7760ukGXX9Jg7ZMxNUjWnaN37l+iuC2CxipeClpWEl5rL5N9o3d6miKPhZZAm+gCmYGYRPoaiH/xjJ9NbUtv7kZOR5YpzWaDpGKwOZ+LsCZn8C7PPqqMVaWUQZ9thaiph4Z+s23pqBelYlVkPVzM4rNexSHRCjfz47/0GCZtu3pSSdGFF3zjWjvro7rYwEJpTx/BKqcDeFtPfuxzbGKPC6uul/FFCoGgcemOH2ptbrqMTLeG49wihuRG+vjyAVf33WOJP6R9bu7PviuQ/k7/IfuTqNzpmA+T+cFge6bPf0QzuQLnKrbUdnC0HeNlI8rrfzSlSIy/kHzgN/TS3VYsXWZARSJqGYUyWyXRYuYgevfuMlKhhtOgbuO2b7tYL812pwa/+tpnoSRUCbYXzvkzKUJyWz3KIj+PUa/AdOWG
 GM+cm3Bv
 d4tJxRXhvhfG2TMp35q9uSt5UiaUPy6/Nvz4h7vd4QuTRJi98oJkLlH4h0oZqY7O341PF89YB9iBjgb/pveO7CKYWti1bRqObT064EmChUiMfKr9HPFZw2wfVI+1vuldN3/B58yZivAvBD9CJupb9oVzkHSfunOlWKbRdwQIaur3e2HLF72i/CiXU0IeXRiZdoIiC/VxrzbOMOpd0TLnR9c1sdiXjWiY0X7xsQRw4mwHVZG5wqjsTChkCAuWz5sgfQeePyIq9iDvBLBuXm+fPSE0JZn7Rky0BTv3PExMTmoh/y5cZBiHlcGa5OcFW9ifqmxDm/Hqr9y53c5LGdWdSIPC8Rcb1hnwVi0DTvkBTvebgpxhZssl+JE659iTtGFj2YlwCFEOz+THVGhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>=20
>=20From: Kairui Song <kasong@tencent.com>
>=20
>=20Restructure the error paths in pin_hibernation_swap_type() using a
> goto out pattern to avoid repeated spin_unlock() calls and simplify
> the return flow. Also simplify unpin_hibernation_swap_type() by
> making the si NULL check inline, and clean up find_first_swap() to
> avoid an early return inside the loop.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c41c4d26a7e6..c69a924acb74 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2331,21 +2331,18 @@ static int __find_hibernation_swap_type(dev_t d=
evice, sector_t offset)
>  */
>  int pin_hibernation_swap_type(dev_t device, sector_t offset)
>  {
> - int type;
> + int ret;
>  struct swap_info_struct *si;
>=20=20
>=20 spin_lock(&swap_lock);
> + ret =3D __find_hibernation_swap_type(device, offset);
> + if (ret < 0)
> + goto out;
>=20=20
>=20- type =3D __find_hibernation_swap_type(device, offset);
> - if (type < 0) {
> - spin_unlock(&swap_lock);
> - return type;
> - }
> -
> - si =3D swap_type_to_info(type);
> + si =3D swap_type_to_info(ret);
>  if (WARN_ON_ONCE(!si)) {
> - spin_unlock(&swap_lock);
> - return -ENODEV;
> + ret =3D -ENODEV;
> + goto out;
>  }
>=20=20
>=20 /*
> @@ -2354,14 +2351,15 @@ int pin_hibernation_swap_type(dev_t device, sec=
tor_t offset)
>  * the same session.
>  */
>  if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
> - spin_unlock(&swap_lock);
> - return -EBUSY;
> + ret =3D -EBUSY;
> + goto out;
>  }
>=20=20
>=20 si->flags |=3D SWP_HIBERNATION;
>=20=20
>=20+out:
>  spin_unlock(&swap_lock);
> - return type;
> + return ret;
>  }
>=20=20
>=20 /**
> @@ -2441,11 +2439,8 @@ void unpin_hibernation_swap_type(int type)
>=20=20
>=20 spin_lock(&swap_lock);
>  si =3D swap_type_to_info(type);
> - if (!si) {
> - spin_unlock(&swap_lock);
> - return;
> - }
> - si->flags &=3D ~SWP_HIBERNATION;
> + if (si)
> + si->flags &=3D ~SWP_HIBERNATION;
>  spin_unlock(&swap_lock);
>  }
>=20=20
>=20@@ -2480,7 +2475,7 @@ int find_hibernation_swap_type(dev_t device, se=
ctor_t offset)
>=20=20
>=20 int find_first_swap(dev_t *device)
>  {
> - int type;
> + int type, ret =3D -ENODEV;
>=20=20
>=20 spin_lock(&swap_lock);
>  for (type =3D 0; type < nr_swapfiles; type++) {
> @@ -2489,11 +2484,11 @@ int find_first_swap(dev_t *device)
>  if (!(sis->flags & SWP_WRITEOK))
>  continue;
>  *device =3D sis->bdev->bd_dev;
> - spin_unlock(&swap_lock);
> - return type;
> + ret =3D type;
> + break;
>  }
>  spin_unlock(&swap_lock);
> - return -ENODEV;
> + return ret;
>  }
>=20=20
>=20 /*
>

Thanks!

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

