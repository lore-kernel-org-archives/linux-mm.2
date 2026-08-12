Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118E1C5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 00:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BB76B0088; Tue, 11 Aug 2026 20:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C6B6B008A; Tue, 11 Aug 2026 20:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E1F6B0092; Tue, 11 Aug 2026 20:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6A76B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:45:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5F5640273
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:45:26 +0000 (UTC)
X-FDA: 85090773852.16.8E31B55
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 16BA340003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:45:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UXe19sBu;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786495525;
	b=GnvX2fibi15g/5VSwoJNlehxJ6vSd36da+5xcFurQkFyaY2Pd5iS2D/HdeYrP3ipl3+so5
	ob1HmBY9UIwhUQ89U4W1hIvslDjrmqmW7wg+5RT8RZRkI2V6eEY5Ma1wLgYwXDI39RgZqq
	8i4btquf9+uuduIHySkRsyvadE2/8sU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UXe19sBu;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786495525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpbiFA8KBEHzWB2KbcFFhiBo43qx2XKKHLf9CrKShXo=;
	b=y2I9fqGuRM1/vtzGjhpUOO3hyLx19YHUIElfqhcEi+XPAZSjbPp60k4RlHEV/AXOweB9WO
	rrXzb/3d+tH2ZvORjewzN+8Z5hW6A12+faodJGpdAb/NnT6eWuEM03bORlqhe64bdq/geU
	XxqFKf82QwtnmrRm154HqIli1F3W2R4=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so606013e87.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:45:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786495523; cv=none;
        d=google.com; s=arc-20260327;
        b=DacOUNpXw5QAX7HFz2NCySTPeMSW3Rj0SDG4dcfkmrbBKfYw8C2LkbnIXpEsBwKDto
         UnqxlXFxDF02ZM50O7DlArUldb04yTlEib4AZN5ev0E+umEIR6d+UhldykvG/pOzf/Di
         fK1IIAuz7wp2Wz8CXyizizl/MlW61GPE0K9bUidvEAbUo+I3qTVmuVAD0vGCw7b5wg4M
         bdc1PJl+GgqL5KYmKtPdNIQJLK7HsimfRTtOmzPcIOtLOf/ZRLYmSyZ9kHnOS9PjjSBu
         nfsF3/EWHsEzooMDIiaSBJdpWTJobRXWGhU8Cezo+RQys+tGxMeDg1s1wP10ZQTqHrdd
         R3ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KpbiFA8KBEHzWB2KbcFFhiBo43qx2XKKHLf9CrKShXo=;
        fh=FnTeqw5Sda9ic5PBHx80WvyTnZ/LRzXghBjE4EN16bI=;
        b=iqbhfajB4oopmlt56AV4B3LJ+QvAU8chXd77kPqSTV8JYH/Ycx1I76/WixrfXHYlXV
         iJI8ubuYXzNdI2iE1LPuo3CclPbwRy7iToRz7BM5d0x2gZXv7SDm81iDQCbPLd8CdUW+
         61RcOFOXDDHvs3dTJFKeuZtz8jwJL0vR6x1Im55NaBqCQVv9rIGH88Vi2B2gNfDDdkoe
         7jummx5Rb8azvGq3A+8XJBX4Fv5uLpv9SgKmU5Iu5Ai0ymIYe0pFdUZlqEnzwCSU3uRn
         9b1f1/8X902WjGvwEqY/A5BAIqe8jnKpibWYkKpmBVMJOnvdeRhmiUWS2JHYabQubVKy
         Oafg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786495523; x=1787100323; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KpbiFA8KBEHzWB2KbcFFhiBo43qx2XKKHLf9CrKShXo=;
        b=UXe19sBu3fsUCx129F8wE5YiEU3s4cgTfU+8KfVXXtvypJPIhtDxLEgtSc4EOx+Pzc
         i4w4eeIq8jEjZ3outLJL+6QI8L/BtoPiPVlwb8lL9b6TSmNdXKp0HyvpEkfRo/v1IADl
         YU6J7AezyDFtbvCXSS4Rv53SLgVweRUPpVjRCECE2wrPDkPUOJ3ndiSnuY2D16mr043j
         GiSsdwA/uUxH1ENEsp30weTxwFXcBf/xM7NuBGt3vftKdX2IBFbpTYOt+Sbsdq9WfUgp
         cbzB17RGWiGZPSBvEX0CadUvwQ4K74cILgptEjqLBRQTorjfSPbP+g3a9yqS+FuJM/Mg
         6T0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786495523; x=1787100323;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KpbiFA8KBEHzWB2KbcFFhiBo43qx2XKKHLf9CrKShXo=;
        b=tH9TQ0axgQ6GhUPgBmOgIF0jPW23GN7YPJayWRDuz6o1Ns1TsggUVntWQclXeK33A3
         B0H0SbHGoelFHFqY/6/OdkdOeJpNu1Qt28+iBBOKJYGFRIy6xL3HsZsiKNLUJqtoSWNl
         AHdiWLh1z7LRcf4QZPgL1XCXy4gecOBtaBHOYD8Gm4NpoZ3ODng3oWxREnMFWNex9joe
         tcH/DHn9mydWk+D8hPENwDiW6wk8s+mdhXyp3RxoKpM6RZi2SQ2VRZNRRNV9zk2EvC2i
         A8P+FGWhijCZyQlrZrk98i7xWdyLw3FRfUQQO888xTB7UgxfASY/NGfHbkrPjCDksP/C
         Jedw==
X-Gm-Message-State: AOJu0YxWen3I2kN36swt1TtIJ1JgwQEQdHbuGr5ubdQxmt7pRBHRZ7hv
	uZP7qhUzeIQOp8pEJ9w95Rjg1LPnl7MMXt4eBmFPNgFquW0+I3QD7qQrRoO9SUS4eqPaeGGoOgj
	CWcjhBZzw824cju+VSxn8LLDX7AP27Wo=
X-Gm-Gg: AR+sD1046Ufa8u/ELRcm1vfvGfPDeht/Pbijisz4hQ7It6AXxi5zQZxQ4LiLK7HAkC2
	+U1MMgIz63Vqwym6BsoTF4n+AlQ2/rOjNd0csQ4mCGHdU9VvYwPeLzd/nvqyAC6r1MQf5V5QGh/
	hVZ+/RGDZ6cPLccgJup7978kyMy0D/OBA7bUnnGqg0HuFxQD0IpEN3E0st0rk68+drXK2SYPnXv
	l/eC4QK0PSUyTNnlwcVe+oM6V4/ey2183wG5QwZkw+SjO0Butp0zbT0rAsTqPhvmJ0vlTD8ydd6
	/PfcybNh0ODcUnagiMhuj1nzzLj+VN8xOGLkfkNqRqvUFjbsIuCK30wXtPeq/+q7mN6tLc3i0g=
	=
X-Received: by 2002:a05:6512:3c84:b0:5b0:1f06:f1e4 with SMTP id
 2adb3069b0e04-5b44e331828mr156684e87.51.1786495523085; Tue, 11 Aug 2026
 17:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
 <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
 <anpnowepnexrNea_@google.com> <CAJxJ_jgBK+jkGztHevvGiNx1YLVHdHqnwVenycx9wd-3Vffa3w@mail.gmail.com>
 <CAO9r8zN=VjGRSv6aG+7tSFa4hFO61SkZChGpgW=+8YsuSxBnFQ@mail.gmail.com>
In-Reply-To: <CAO9r8zN=VjGRSv6aG+7tSFa4hFO61SkZChGpgW=+8YsuSxBnFQ@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 12 Aug 2026 08:45:11 +0800
X-Gm-Features: AUfX_mzjS2B6a7Oah5K0_j0Sz1CLzFURZtr3Lw8DD_PegB9Epqfjq8x38hfXUEM
Message-ID: <CAJxJ_jgpHRMXDjXsBAkY_QBoz6ZmZcbtmtxu9c8-7bW=MccPVQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/2] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 16BA340003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nsebzqx7fk4qyxpno5bc777trxb4bkcs
X-HE-Tag: 1786495524-870046
X-HE-Meta: U2FsdGVkX1+HzizNSpY68Kr6ahP9s5wYpRLYlkkn6TqmyZ49xsFca9iC9ezgn1ciB2F9EFz3Ij4f+dZsM1d0W1jS8Ro48S7ib+fmIbyCc2vBoO1+Q4SISt0+/MG9+RGzM9V0mx/WN9yygF2aTcrgOAeWpguJpsDe2Z4tFlkwKgLkc9ln+aEOaLlO7yaKUFd6GiFDkxkc496atW4i1G7EUUzGt54u7T6RL6IVnXDqLBc9Sw2nIa5Cp7caf3N7jTaaRcOvnDfl2Cd38uNQxEytiH46+0sX78bFmVD8hjR4LuYQWj81I1qyLVbcKP9o5hsW4qI9x3ezA+TNq8i8CyAekcAuMO2oSnjEfVsyCawIBgTlYp5nZRebrVVdutoZs97iR6uTrMoQzJGjChIU/X3+eahujUGcfYMVbDiFLChuzow12tzt20jlEKoMpVvZqLiPlzULmpgjW+KRus4unYe6eeGGFLXPbsXSQReb+A/2zmXPmDm2rwbGhuNaG4jXeOodUiH5a3AKkdPyMgDUlPQfLFSaedlRHggkYdlBlos9095+oc42cO4TOiM7eDUbo6VzfbFn5EO+WkEdG+M0N5ZLZpSOLF7IO1dFcp8yaTo6n4WumNh1lCf1kHet2bj1gd7ZKF//n9FEnume0s/qYZH0e1/OgexSh87+mTmagexE+bIZuVGuiheAEWSo/Uu6bOGfsOw6ARGPvmHGkm+9JADTJXIdnbwxj2q5KECZc4GqVSuBl2f5MHzE7lwpnEiu/JEmiUhQSJ74x+D+Ii92AY+q0GSyCIs6haY4QkVfIfxmLAk5M1cz+ChUTXNo/KGvSa2MGgwxW8Wg4Kn1dtHP9GfTfUxJ774Po4vtdnO0xegWQb4TbQjKRBlI0igwUOBzkMsPXSmvtvVWj9vIV2m2OJarMJJmh4DIHItdxce29pMRQ6Hto5/lF40qGROm3odmVr/bCiQv9POlYn+6AZV+UmK
 zcT9P1+U
 TwlMBiHjmwYGeoXhWFFAVkQOyhLJLCGeFfPGvbdSlHa5hG/f8QVY0MjmF3Q5LnssEmmzuBUxmuLNCBDRLnrfs4e9LxA/4+sgEMyld3VwSplPAMxV2GWSAO3oMTgzDFlAXuhmwNeFMfkMEK9S3MobzmgKhITaCCXSBFZs8SDrzWLYcHDOdPpzJf/gI8DS7w61/uvUGwFQzvy7genaSunNaGFjCfQuvVBj6TF5ix0RohKR6bFGarYVgEVsFCkAPUNre1l/MxeUl1/DgLR93/JvL27T3Fr2y3SPZLHcXq7SpE/4Fs17Is6JhKKhdgjk+9vJizA3LjMOOhL0mEoStv8rDQqM6h0aGgAaMjtliCkKGA/RhAFm+DHQXVQpDsBKVMY9i/4fe/UAQhnRprYNqQd35so/FIhJdHFVAj9c18qFNggEDaQ1Y5fp/WYKhLDG23uBlPJp127/nThpdS/TlOqp1GRo0dXTQMtQ168Vt+ip2NjVwbA/SEBXSXOKJ0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:22=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> > > > @@ -404,7 +437,11 @@ static void __zswap_pool_empty(struct percpu_r=
ef *ref)
> > > >
> > > >       WARN_ON(pool =3D=3D zswap_pool_current());
> > > >
> > > > -     list_del_rcu(&pool->list);
> > > > +     /*
> > > > +      * Clear the slot before scheduling the release so new reader=
s cannot
> > > > +      * see it; __zswap_pool_release()'s synchronize_rcu() drains =
the rest.
> > > > +      */
> > > > +     rcu_assign_pointer(zswap_pools[pool->idx], NULL);
> > > >
> > > >       INIT_WORK(&pool->release_work, __zswap_pool_release);
> > > >       schedule_work(&pool->release_work);
> > >
> > > Not related to this change, but I wonder if we can use call_rcu() or
> > > similar here instead of the manual synchronize_rcu().
> > Agree, will use call_rcu() to replace workqueue + synchronize_rcu(),
> > so it no longer synchronously waits on an RCU grace period.
>
> If you make this change, please do it in a separate patch. You can
> keep it a part of this series if it conflicts with it, otherwise you
> can send it separately. Thanks!

Thanks for the hint, I think I can use a separate patch.
I'll also check with CONFIG_DEBUG_ATOMIC_SLEEP to confirm no sleep
in atomic context.

Best regards,
Jianyue

