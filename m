Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E473810AB838
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338536B0005; Thu, 26 Mar 2026 20:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F916B0089; Thu, 26 Mar 2026 20:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2256A6B008C; Thu, 26 Mar 2026 20:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D98D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:57:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC2EA1B95E4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:57:26 +0000 (UTC)
X-FDA: 84590029692.23.69319EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62039A0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:57:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bSmG2Prz;
	spf=pass (imf25.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774573044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBn0Qd0IPSXF9U6X9Wlo0FxebI498QdZ8z3o4BFj7ZE=;
	b=h2COIy0yWyq25bYKrL7HINOZ3ll4nhrdW6S0cSODxAvvO6mj+LWSsKFaNNDcpuDUW6bAm5
	9V7gaNI+EtrJMeqmAkvu/kHNLJZg3Jd7vX+/TZKeWyfSC4J0AsqO7VurbwRn3J70lLWZve
	EMAfFEwy8ivomcR5nJWKc6m/fY+p+Yw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bSmG2Prz;
	spf=pass (imf25.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774573044; a=rsa-sha256;
	cv=none;
	b=vBaOpYmC/6MQqyH7mueTnDP/2XaffE+H6VmvuXoHRRC7m9EIMJ6aiis/gWTbvZGn8z2oYu
	9Q2Hz69AKGRnnqCWrepwE+Qc6FReKeSo4z9EMdVepvtIpuqNM20jrzOAp+0YucTlbbiGKl
	OKg6Rt0VnUwmArQLFo9tQ3jFrQoadWo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774573043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBn0Qd0IPSXF9U6X9Wlo0FxebI498QdZ8z3o4BFj7ZE=;
	b=bSmG2PrzXqwNefs129gfYtqhcoYQ93GdXK7vIcFm37ikRi9zrPhdda2+ic4SJ7PrVi4Rdt
	4zCppTVQVJaImrwFcCVh6dV3gzOBlexXk1Ago+3ZZ7X/GD3nSTQn8oJEFTABY4ejpJQf9a
	VFUXlvps+Dxi3J5wBnSbYbPYM/XU+n4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-UtAw8_7dP3iUq22aRgmxlg-1; Thu, 26 Mar 2026 20:57:22 -0400
X-MC-Unique: UtAw8_7dP3iUq22aRgmxlg-1
X-Mimecast-MFC-AGG-ID: UtAw8_7dP3iUq22aRgmxlg_1774573041
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82c69a734a4so1324329b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774573041; x=1775177841;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBn0Qd0IPSXF9U6X9Wlo0FxebI498QdZ8z3o4BFj7ZE=;
        b=WR/z52Ebyne+zIlklxY8GC7LjwrXzVvSZdXM85DI2pfXRmkYZw2C9noHeAtjJzIZZQ
         wzMJS8+Cr8Q0NXL0L8YYcx9Rn1fU0D9mol3AxhkVs7wKP59/kv/b2ksUGZ92Y1szuNox
         nKsHyFiGayZ/uEAdoSw/Af60pELaJIy5XnfYNnJh7ga2P8ghJvBGP3sAwJMDOr3Ks7yg
         BL7HI1T1ZjI82XlqX/zqHwP96pNHCqF5lmyaDF96jlQaiu6g3hXXGo/f1TqxO+S9hZnC
         X32nuZc5bA3smxAeS6pFz9AEU9Aa6NVILm8N8qWzvkQyPXanR6EBXsvk7KDlGsa38Tdi
         0MBg==
X-Forwarded-Encrypted: i=1; AJvYcCWg6CnnD5chmw0eYeldb6ytvJ2apoME6U54h2N5/nHD5yycmD810Z+/NBV7X+cimdgGON6v4kxxOA==@kvack.org
X-Gm-Message-State: AOJu0Yxx4nKcTU/4GMmBbPhLE0ZHS6zLlvq/TepEM4m2FW8nj2PZFJeR
	6oqi0JpCxasPiwHQTEgljvRF1Tc3g7cbd9Z/sS63zzhxlsWg/kVFwvb1Msf7i0lm3kdJ5+izyk8
	iwQB35L+wqTm+/UVAXvbyBlz3oHlGEsmnytWSza2AqZlUv4UKDqUh
X-Gm-Gg: ATEYQzxSVN7v0rJIMuVaQ49+WBqcItpoMBIgAveb/1O2YDwv5dCtWcP4IywAHAhbWKO
	hNFfSxN5axwr9y1QT3X24Cp06MyqGN7j/BxLpvkzAUmaiADJd/9OQMyg765NAe/SJkFGAY0xvro
	DfIL40aY7EN2qrbuF+qC9KkjyBSqE3pek4uTGwrUv2hW86BUonl5e0ohexnY39jjP1ke6wX2Hwp
	g7UdGkev5BjZ78OBhj4dPhYbzDQ90Q4KgG2tR60qracxn/mO+MGQlce2Om5dmDJPLfPuaDdzkr9
	9mTidqK4ScPYkUDmkkvZR1CJhFnu0E7WSoqMpSvg7QI8kWlW7LQAw2DRYOXoa2SPIWnDZT/XrRH
	6CihvLY8zWOesFOcncA==
X-Received: by 2002:a05:6a00:1495:b0:829:8942:2ca1 with SMTP id d2e1a72fcca58-82c96037189mr557117b3a.44.1774573041045;
        Thu, 26 Mar 2026 17:57:21 -0700 (PDT)
X-Received: by 2002:a05:6a00:1495:b0:829:8942:2ca1 with SMTP id d2e1a72fcca58-82c96037189mr557083b3a.44.1774573040550;
        Thu, 26 Mar 2026 17:57:20 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d22c8e8sm3525446b3a.24.2026.03.26.17.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 17:57:19 -0700 (PDT)
Date: Fri, 27 Mar 2026 08:57:16 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nphamcs@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org,
	mkoutny@suse.com, muchun.song@linux.dev, tj@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	longman@redhat.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acXV7LhE0z5seCEA@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
 <acTSQFxTs4-t7P5t@redhat.com>
 <20260326160618.18a20227b606bc95f3c3cfa6@linux-foundation.org>
 <CAO9r8zPMtNaRuGSrHnfh6AX3DKVoR6d90X7O9UTjxbushssyuA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zPMtNaRuGSrHnfh6AX3DKVoR6d90X7O9UTjxbushssyuA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KGGS_rtDf7RpohUNv3rYYpjqen600VsNaM0t2nZa1z4_1774573041
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62039A0007
X-Stat-Signature: y9bqx33teifrpx44asziw9nwa351sbm7
X-Rspamd-Server: rspam06
X-HE-Tag: 1774573044-77194
X-HE-Meta: U2FsdGVkX19erG7iejssihbzT6oRHHFxkvtytv7nnlE6eedtk2I/byw90qlLAnBU+qjXL8vOO1dqtU6wN5CjxVdVRnOCkSlMHmuGTc8uWN14AFWyB0QVurmLSAI3GWaElG/Ztd1rVZe5Hv2BpLRkqKhfTsRE4vm3LHhycN75Mj6fFN6ncTgN75XCHzsoljHTbTm5h7iCNbaP5JWanCqoHmbZ9QyfxQpI4ccqTecarPlB8FpGcwo/zqJUUPpciFZcnBHE0IMioaSOwPOE/JO9Zt6OHdQQfOB3ix1WCvctYNGgQIP3Qop3YyYIqMGkiB+jdxtNOnPe1ucF/9MUxbpMwsrukebxhamOmt3qqZouFRn10Faki3rIHfCMd4jGfUTkTS3qmgRZJFggmS5Xp0okXjLgiVTdJWB+4MC3nlnrpLDi/jUq0cM1VopEih30TgZKYy/cr/uCWsjR4s8lupXQhQoiAv249t/W21LwdV5k9XC7RVLkooXJrzQMWIsQ07P297Rf5F4YzTvvTLO7SGW4fxIeZZNNqHBvR5vcMDfAy1ERWPS3xF5BNWsuQlVcGTODlBE3LG/Vemb88zQ7GiOC851PZw/bIE9FQqukRwLWe0mI8857wRHKFihAvtVSwG7U3fNUR2OqdjM9RBqAqbLuqGbuUOiKXsc5YNEQttOgqWWCWIOXmL8LLatCcwRHh0Y0xRvDamHc2w9EEMyrQUu8mnD942o4jZfs7SdoelyBP9w9XhUDDHWtKxv04Xl0ASUssbSFF/469mIRInbGXNYuXDWIbOx1O2NaXE/1skvbGraRf16vxfKYphxaawahnGT6JaGDX2L3rxuF5syRJJVCOYuJvQD9BX18h342T8ui4T4szYIU0MQafeENT8CuIAJsWiySpyx3XBNWcuu1Wx8E1Xnh454cohFLnXURWUA0TkpiP3nOJYKW27PZ8uBHL041vFtXC+rSF8yYbhIy1G7
 e92+QkDC
 nDWgeQFCiS9dczWJKqJTrGo7GihNJfzTuWV6XueDX264GrTRvnrELO3QSdlNeUQoKIKGAqHz7pRk/RIufQaZGOcpU2kXSugrfye4pmG6jS/jpvSZjhPUnqKY7sOEA5nY1fuOcZHj+QPGUnouKwLIhE96rjAEwZFn3h2qp8QMMBp497uPra5CvTeqR5UKaZbwObBCl2cuofuTUGl4WXxegahmeCH+dnWeR0IMpC/KQ4EZxRu9hGK0fl9nkBnb6vZQ86ZCXLUiS/ms4G+rMR4R9McUMJTq64nJDaFFv3gDf8/Bnq3xpBiHORJ6tO3fedxf3FqMVXmRbDOMyiNNC4pgD5GTwnhVMFTGqclLkOdYztWwIRW43/yulnuVLdmKQ3s+AtFvQrohedhpuLLf6uRlGuBet0WJye1X9zaeNatS1nt2rczq5cXlYQ0xaQUqlbrVQMdQkmgNYjnZFYD0/GGxtrei/tLRXi9F+QkHwiXK3E+LmmuW4hRpIjLyxvyEtJJnnLqSQ5Uhkga7Qtyo5sVXYO6PUgWTQRGvRS5RaB38LJaVWP6Tgki5Q+CYQT5y5Ckg2omWvVKa1YYudJcDevy4c116XPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 04:10:42PM -0700, Yosry Ahmed wrote:
> On Thu, Mar 26, 2026 at 4:06 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 26 Mar 2026 14:29:20 +0800 Li Wang <liwang@redhat.com> wrote:
> >
> > > > Test all passed on:
> > > >   x86_64(4k), aarch64(4K, 64K), ppc64le(64K).
> > >
> > > Hi Andrew, All,
> > >
> > > I see that Sashiko still points out minor issues in this patchset,
> > > That seems very tiny in selftest programming.
> > >
> > > I can correct all that in a new version if you'd like a perfect patchset.
> > >
> > > Sashiko comments:
> > >   https://sashiko.dev/#/patchset/20260326032658.96819-1-liwang%40redhat.com
> >
> > Ah, OK, you already looked.
> >
> > If you say they're too minor then I'm OK with that.  If there are any
> > you feel you'd like to address then go for it.  That's my opinion,
> > others might differ!
> >
> > I suggest you leave things as-is for a while (a week?), give the memcg
> > maintainers time to take a look (please).

Sounds reasonable!

> I think some of the comments are worth addressing, especially:

+1

> Patch 4:
> Using BUF_SIZE in the allocation helpers is wrong, we should use the
> actual page size.
> 
> Patch 6:
> Zero initialization of zw_allocation.

Thanks, and plus:

 Patch 7:
   Adjust the code comments.

 Patch 8:
   Declear long type for elapsed and count variables

> But yeah as Andrew said, it may be worth waiting for memcg maintainers
> to take a look before sending a new version.

Sure, I will allow a week for others to review it.

-- 
Regards,
Li Wang


