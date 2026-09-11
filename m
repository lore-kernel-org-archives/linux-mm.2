Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73593C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8426B0096; Thu, 10 Sep 2026 20:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0486B0099; Thu, 10 Sep 2026 20:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5746B009B; Thu, 10 Sep 2026 20:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43C736B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:07:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 368651606B4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:07:26 +0000 (UTC)
X-FDA: 85199542092.06.3690F9C
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 481C614000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:07:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eDSuyAhW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789085244;
	b=zfMeWv8AGCnwKPKhOTTOZG5EJL3k1H84ufoGYVxZrJkz9K0q8PUEhabYp4P6YjxKj+vFTK
	kyXLjmuYZEgBipNHH3zD4wHvBp9QP0YbukgJSU8vWhHQUVnLnBTCi+HZUEBGcUJWb68rEi
	wLC6tfpwxPYvwFAub+x/HjJoS1qmW10=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eDSuyAhW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwwWcBN+tgHNQvnGqgqfng+hX1+EnAWmj1LkksOOo0g=;
	b=jwwhMNAY9RCdP5ovi+DYLd5olMztIQaUUBRwq4hq2h5XvokImLtWrNEf0bjrOG2ljswoD9
	nmQEwA5wfqRmmu/zr6aGXf9DoJmfmkBXaFFW67n+opgWWATz7UbyO1b/p9yILC5JE4iVAr
	VMnXz7gPXJOFYVVgo9ETIKnoQD+YP88=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2938116fefso65727766b.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:07:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789085243; cv=none;
        d=google.com; s=arc-20260327;
        b=onGIVekwePXNkYZk0+EJTcw2V/yIYwDZVrAsONGGVx0iXAfWYs6aqG0L5eHh6dMe/O
         lhUs0oXl+YQMv3zp3PHRXcm6ArZZqOzf93bfh7uga02aG/Sp5Bc4VxV6GFB8bRETe7Qh
         Lj7WmtZZaAZ3hN3yObn/572/idG5bmaxjmner3iD6KEwD//6CAb+Ana7JlJlanhtkoNo
         AGn4iIqNYx40oem63o4g4XTK20FHqW8As3qv8L28iAJc/vDdN183RifDOFAHldVMecLV
         XPt6yoOKvByTsTGoP8khRjG15dzQWmZyCGU06LyZ6B1h1HrYeafc+Js6df8voat/enaY
         ot2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IwwWcBN+tgHNQvnGqgqfng+hX1+EnAWmj1LkksOOo0g=;
        fh=hpwRqnMcyMxR+XIp/kKnxghewoglbz8phXTmVlkRaTc=;
        b=ZLqFr39VMVk5H+WTbD+KWBNAUH/IS9WxxTWFWSClBcZ8T8S0C/RaBElVknYM9AAZ4j
         0lKFtZ6HB8gY6doQMRHvOr2FiMG151dsLP7OgRNPdSaXYpn0O8hRki0hPacrWfpDo1KZ
         tlpMqg8cub2bEwd3JLY9oruS/inIutoA8CQj258mPfywp4CAvTMBmccblg+FWZEYbr5j
         D2ykqZsnMRY0N0Tmi4a7z5toHQ7K7SshMVymFqSeoCvJ/j8QVXwCyh67GOFhkD6SuxUe
         pKaZPHyO9dMmmdUNNMTxfoL/XH26kK9nY+B2gzmLdeK0FPexY6v0SrLRhdqjNMXN5cYW
         9xVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789085243; x=1789690043; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IwwWcBN+tgHNQvnGqgqfng+hX1+EnAWmj1LkksOOo0g=;
        b=eDSuyAhWav/T2MUCfFMvvzwaA7qHix5CGTZLJ9h5vCIt/8SR39nn6Cf+ZaBFjRWLNr
         i+jXHsziexM4m24xnQU8vORsJzB+Y63qC0zGwpUWUUx/Qo3G8MtUCK+FFPkgsyBashJF
         yMgCGYdH+0HCIZyG/yEg4ti2e1OB2OXg6jbZS9EcB4tsC6GbsBMgLOn8C3PRKXOUFXu4
         8/LVPUtsFWGSEauG9PlBPaFi9FDTYvAqr5gTnS30jYd1V/SmtePUz+uQG8vW+bfrNZJG
         Mv9mM2b4DBikD4pCAjpsGHTCA9fdleJrOmPkUWB9A5CCTGmLP4Qflz2AILhMX5TEXXV4
         ElqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085243; x=1789690043;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IwwWcBN+tgHNQvnGqgqfng+hX1+EnAWmj1LkksOOo0g=;
        b=cxB1v5q12sURzGz6K13sdzG0A4KmI10Jh6b76hh1ME28GWRZSS2ckEnJG79eGD1F2q
         H4s7l5q+ozVfB6mjbTYXm5nCZFzVTzN4N2nSuVxwPKFETehkA5djXK8blyjnxorfid57
         fNSvrWFtYxj9x2a8jc+0MXanmu0rZ5FZ+qH7sISIw+Nztkw/4DspwaFDf9Ge9lSWmf6y
         3eEK0Ned7xnd+V+PVYxtdLnL7NAVJj7x3dXRc9Hnjt1wIaMSmCM/e4ahkV2BKVNbPb+U
         /k5FHSFriU4YLqIY/5TVf4IIjGMjlLZ9Qz2Q+dvIFFERKcNzUbKa0BHi3cBN5jnDXmOU
         XFJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwujRRaOgx8KGC1YqUNL7Pbu7KUJ4YhCkjPyq3iD8TLjAQk+8j8F1ilgtXTyoZ4bNnJk6CcKwB5Jw==@kvack.org
X-Gm-Message-State: AFuF++ks2W4fhbG+CJ13Cs3+2VhUimDHDcwaEMQ7WdksEO0pzp1SyejW
	01/rM4wTaGs9Oo18BKhRutxp+NMMOjhlhs72jnKlvfxE0tmJ8KXueHkSIajSZflLOKpY3CoMJ2a
	9/kePUX6ZPPbTTT/L296k8LoZY/Kw83Iq6wntMcuT
X-Gm-Gg: AYBFou0LaAm3uaFiU+DAs1MHJwZjj6AdyXB/u013ihOILys62gtddyJwae3tJ02MSd7
	OHhbdmIHKJcR/KYvHKyAmz3ruMLTp4I7nMr7XRcroQDkC5vaWQ1UHfzwoKm/GMyzjKXFONO7BB8
	sPYjOk0v3O9OMghEm4CavtB3UGgoT8NJhqxRx2aphz7fZxJv8p0lQtooptqDhEahSy/BBF+LI1V
	LHYLm+nmV/A69DWiJEbeOTDElRxcxhHCGOs06eqfSHNgPsCLw/OdLFkNuHozYuzQ14S7QhevvQk
	8P2vF/8f7D67lhku+Zoz2s0h9Gsznaf/1jAdtXW1ejJE/FYNs+0D7LwI0xC+XPJE1mpNWjFDcF4
	vdc0JdBsyc4sEUWV2CF7K/Gpfmmjt6aQ/JRK1TF51R10j5cuW07vwRxTA9bw6RcN3srmD6gGIH1
	uw88n2AMMFRannzGM8ONx4Hwc=
X-Received: by 2002:a17:907:3f1c:b0:c26:19de:9acd with SMTP id
 a640c23a62f3a-c29666d6e67mr44961766b.37.1789085242261; Thu, 10 Sep 2026
 17:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260910162411.d3bd211927c10e049c6652b8@linux-foundation.org> <20260911000300.1052582-1-jthoughton@google.com>
In-Reply-To: <20260911000300.1052582-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 10 Sep 2026 17:06:45 -0700
X-Gm-Features: AcwNN1X0dJedX_Oh1493PKimMiAb_MFffFLVsT6i1Q2bbVinjsu48pu3aGeEvKE
Message-ID: <CADrL8HXtaLLheoY=DchtwxOq=nWRzVA=-1r9zi8=aebi3j1rtw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
To: akpm@linux-foundation.org
Cc: baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, 
	dev.jain@arm.com, hughd@google.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	shy828301@gmail.com, usama.arif@linux.dev, ziy@nvidia.com, zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 481C614000C
X-Stat-Signature: kqfaxct674szp45syiusx7waionf3iyi
X-HE-Tag: 1789085244-59072
X-HE-Meta: U2FsdGVkX192yB2rSA3ghwOT5w+bORy6JfEd+KyuiFu0Uf35hFqsJh0B6ZP1k1IVa4VewKd+9UqxZMsWYBiukmLVyc9/d2K5Zq2D9u9Gw71w/IM1V3dz+lYoWxNJDQdH+TzDjoFbpFAawOgxKNRuaNPg0xwtjHAD3J32guql+LgwQxCAkLo1JuAvDGsj6UPe4bof6+Csz/DUFeuqpwmlIBVALNEzWkjZSe4FVWEeauH9qIVZ5nyMB4ctcRmUZg9W/NXKSXHF5PAnoNvhnjAtQ6fwnDQNdML7VY2mJfj65HiN6cwT+qfawBKgbpEgm/1zTcrNL1JFL2CNx/pss4hFw7JLbzmnVTJ9wd6pFa8n8BKpbBExFZjMaxLkidW2OxbEYnOGX+EdJbUEACDJEAT5O8XXyuhPkDZVZoNTVVlWIrW6sy5UbfwEoxu94+6YyEX1PFobCQHZ6ydug35qWjQ/reOsrpPS3AqipoWyEmH7NgYoxixt3eTd8ov6epGL23BNM4ooqaT3/G5nnQM2XunjhnYI9whFknYcBAhOARH8ENQ2HvKDeMcC+0yujyGfWFGv2lIgTE8WDvC8nQOWhBwiqR/zKZPHYl+B7+s4G2kH36aK8XjL/iwxaDI41g6L5EDSw9WPESTtzWMzhGkQuyjixliMw4zzNrhwNFNmDl7ZNLbvOQz0YCo61WgcM/AnJKax0+MAt+rnGjT1PHxkOe4oYA7FidigFcZ4zVyfhdifaN8xzgg6Xp1atJtLkpeHtXzWEypu4mHlsABslFso0bamijXMg3BAckyE221O1wUkFenFiEh9FDMJuMsseldBN31YrezV7JqFHIOnp3nAEJsvNJn8UUzZqkFqdPX50FLGBqwghsz1apn5sXiXhbc31ocgL4AjMENlInt43VxoB6MQpHjI60Vb4nRE4HuLGDr5bt9hXu9dW0QYDeGbLiU2muZLUnwwwxSWeyBu+QZG+B/
 fkrFMFt4
 TT7uCvDyoEn1TJjpXmnLIWFoWAzLu3GuuV9wC0v4igo1uVsl1GPACAWxL34IKGoE/Ue0AjKdxMWUBwgstPt52iSI7iTrkoI4+GOCwomtrbHKgBc1uPq+y6iXpVKpX69gewafAEwl3LKazZ0lN0R12Eu1nU/T8icNjr435zeKA7Em6uGa5VjxuI3AvwLN9CZqoPFXUsMF4fkZXOjdnc64M2uBXPNWj0FtBlXoRMjQfdbpQdez+Sz36evYL/SiGy9hwWk3Y7uRikXQnGkrZq2BZ6olSfBm3xJ2gnFMjyrMI0QV24oa34VdC/AZW2hCMr0JRj0kRXZOQ96JbjtYq2VxVpaf/HeJSkGSokpg3gSQJMERu/ltkEPNU8hiYRdhkeBe0+bw4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 5:03=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Thu, Sep 10, 2026 at 4:24=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> > Sashiko had a stupid niggle about the selftest change and made quite
> > disturbing claims about the existing try_collapse_pte_mapped_thp() code=
:
> >
> >         https://sashiko.dev/#/patchset/20260910023411.514987-1-jthought=
on@google.com
>
> Thanks, it looks like the note it wrote about the selftest is genuine; it=
 is
> okay for MADV_COLLAPSE to fail. So I shouldn't have changed uffd_test_ski=
p() to
> uffd_test_fail().
>
> Andrew, if you can, please add this diff as part of the patch to queue. (=
It's
> a partial revert.) Or I could send the a new version of the patch as a re=
ply
> to patch #2 email. Or a whole v4, whatever's easiest.
>
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing=
/selftests/mm/uffd-unit-tests.c
> index 6f2360f9b75d..d8e40b770d88 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -639,7 +639,8 @@ static void uffd_minor_test_common(uffd_global_test_o=
pts_t *gopts, bool test_col
>                 /* MADV_COLLAPSE should succeed with userfaultfd unregist=
ered. */
>                 if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopt=
s->page_size,
>                             MADV_COLLAPSE)) {
> -                       uffd_test_fail("MADV_COLLAPSE failed");
> +                       /* It's fine to fail for this one... */
> +                       uffd_test_skip("MADV_COLLAPSE failed");
>                         return;
>                 }

Ah, the

  /* MADV_COLLAPSE should succeed with userfaultfd unregistered. */

comment at the top of that hunk should also be removed.

