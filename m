Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 452CFC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 17:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593FF6B008A; Wed,  5 Aug 2026 13:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543FA6B0092; Wed,  5 Aug 2026 13:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B6F6B0093; Wed,  5 Aug 2026 13:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0036B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:21:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3066CA1F89
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:21:03 +0000 (UTC)
X-FDA: 85067881206.11.F599F3B
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F7FE180008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:21:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGjGi9BE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785950461;
	b=SonUSEtQzgFHaKbarJzPLokM9i4vO2Yvy3Kl1Jcy+ANbWziJKDzUIyJrV/5XZ5WHhb/Ur3
	oHQ4leinKVCBMe/k013Vpi8Exv1UFWhSSpAUIlYLVxxxvf4wLQnOvxqFFHRhZ58L2cNp0j
	YivS7XAYLFgfk7zkaLVQ4hZaFAcfpDs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGjGi9BE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785950461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cz1E8dA+nCFkDM0OHZhKzEI4Qib+t52DoabszOc2ICI=;
	b=HBozdUHf1VhLMeuVaiQ56ZWC2LrJmBywe4dP0Tu05RbxZcC68He6jPdwlGeW+JCTs0GpKH
	GtDqV45u9ZWKET+FOA9VvHFzy3tscOO56kKhTtERIWZswsaxyyRmCbgcxnE0N/z+MncOcK
	D9XpvMOGanFclYMEwWXS19ng37Z8AeI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ccae46de39so1852355ad.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 10:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785950460; cv=none;
        d=google.com; s=arc-20260327;
        b=M2DyIGRlb2Si/cKep/EGomfl++aG48g7ic+D5E7SSQPFfYrVWC9JYii72mbPBdY+k7
         H02usRo5Zb7dHyoyapEp/EiopNd60e/LmUDLgMjzUw3jyGoSxl7HNoqPL2Y4eiHp9Uvf
         9RIOD/tjgpdIVHh7rY+bNdHo9TAOS/KH0xwcVqCYOfNBkpX0lQH82TUAr2xhLH4UTU0K
         CIZcXJp6thbStqYQ0nNSAbN2B53fEla3ngRoB96Tzd1QFRp4QXMwKCk8ybEXUvcSz+kH
         wuRq2/6b09cMep9tIVkqKn5dZiZazCOmARve2cU9/BtOBdmYiXsVt2cYVATiSonZypaQ
         /iPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cz1E8dA+nCFkDM0OHZhKzEI4Qib+t52DoabszOc2ICI=;
        fh=wgShidQCrruuleiTGfWm0S/sgmUoxzfsRB8f5QL34qo=;
        b=n4PtJs6eWLuBAWqsj44d1hlu1c7JZG0efYPJ0GJe0U7sjoPXCVksvwu+XZuTOEZWgF
         W+b8hW/S1PgamOeixqvK3ppZP2/8fJDEMSObq/+85VtTWcAYAAP0dU9x6Ysoa8a3uIr7
         Pd8m7Q6Ssi8dPnzCCAOtOE/qh8LZNZgDOWGUKd79cwNIhRcqkvA1GL58AVUz3O+D9vEP
         0Cm0gGmGMB/XYh6gfN7S/HPGBKxm6fikOd2Fiulh/UA7aH5PKYGsMYnjFGD850Gn5pVa
         SrUQY/BL5zLuHXo1N3tClQBT51eMXXlF7X78IgB3q6NnuZ5h/vhtv2+8563Icz2dwCR8
         K1ug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785950460; x=1786555260; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Cz1E8dA+nCFkDM0OHZhKzEI4Qib+t52DoabszOc2ICI=;
        b=jGjGi9BECDiIkqUz/nxvFQQa+Sjo4tL/B2F2xPjQkLf4nnr5Df60WoM3N2O2WF7q2H
         PSMw4fG62iQnQM+V/pqZy2SwiKCPeOqjM+5uB9U4ykvBGWHHaMLmfjwQdPDO+BwLMpqY
         /L1s1n/US9lsH7hN85HP+fRUekBTFJtsck7SHa6L/EiyBCHXln9SvBv/l3V+E9yLYbbS
         lf0W7ChP5ReCl4MOUTpVRrEKz4zF9arZem/hb442pVLLgQapsou0ip/Qgm3tYIaJkk+e
         5fuQ9F0OLONHanHdjs2KwoQRzzeyLknJvoCHBREpd31lqug4CGmvxICH1izJ3EVQb5HW
         715Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785950460; x=1786555260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cz1E8dA+nCFkDM0OHZhKzEI4Qib+t52DoabszOc2ICI=;
        b=GyJvS8lMc9y+9eE98/4oE3chDhiU9xmlU9t3gY+gC3bwA/5ajNef0hKjebRNsyNrhG
         j/9MFhdzEz/9SnZQpYQCPg3cbstRwTTRHU2NwcSy+V1MzytD7Vv/ix30TjRUjOUvqcyd
         RimoE04ywdtZXKyW/by6PnvUFK3oxQVlvkClHz4zcTuoCnSWRcAWulNoxPiiKoupewR/
         Lp/FdN3w26tqlrpHbeWkwBVdDebTOfB9xrteUjd8EOFwAKPnrkWf3dsLrKkwz/Fx01tg
         ipdXoKVFQ+HKj88syykOSETWHuy7jr0vfhcXNORqp9jzPTjlqRhjz7h6XnObNnFwIoke
         wATA==
X-Forwarded-Encrypted: i=1; AHgh+RpXST9BiqCFZuYXWUoxDqfNNLuEE3syO1ahrAhnATlP2xwBHFttjDv5ITJCg+mBso+7l7QnLtbnWQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2jwaVh9j+8JEzmmKK0Mzb3gE7KLCbSVai83QFVGPbyg9pKC1J
	WFr930F4eKWCGDFKVp+1OEBpmkqSLDbk41oQSnHx91MWOWzNZOTE6ZTjpQkD26gZi+kDp9qYjIV
	pJwaBepZXswda8JhYvdFTEawQTqIdZUY=
X-Gm-Gg: AR+sD12nXJrJ72xDn93Yilp9vkA4Zka4zybxFauisQCCMYvG6PFmzfeTWMFmWa6FhSq
	grca7ojXN5nQRwVzZ0Osq+si3AK/2L0LjGPO9aMPLE9UmO5yZpo6EOckLm+u+XVgffJSoKYyAB6
	ZCgtgpDqZ/YmkqPrOVGb/B6nv3vwoGc7qTrSCJhCxvZwjAL66XwDyMrqjSCcSFPvKHkcg7t/zpx
	yjQ927yXQsnaRePRAOGXdlT21d28p8kYC8ZQGP5atzxA8hbPi8ba6MlBfrChldhYKjCMcla5m9h
	yTmQn3w718bCn272VqIo4ZWJIa5JPNGA17XClBmimBCYSAXRKNUnj6s8nAWacw/mIUQGeiliFYO
	AeAWFEbqlclHlEw7ticKWZsJv1uH5sBctRt4TuTa5Q9BESRfPzem8WZpyMCDo
X-Received: by 2002:a17:902:ec8a:b0:2c9:ed4a:c3a4 with SMTP id
 d9443c01a7336-2d0ca1658f2mr73522915ad.0.1785950460122; Wed, 05 Aug 2026
 10:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <0CoR7Z5B4-PH8GYYbWlZysVJpMnNLTFzTO0tBlOpJQNFiQ2CPrhdjyD4-4jQs4n0J_1QqovCd_EaYpclyigEKw==@protonmail.internalid>
 <20260628095132.47753-1-trev@trevrosa.dev> <87pkzw9aut.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87pkzw9aut.fsf@t14s.mail-host-address-is-not-set>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 5 Aug 2026 19:20:45 +0200
X-Gm-Features: AUfX_mwN2wRwvmcNPuq0EpEyS5qgayFtXbsdflDPhbgmFxUJf-YMOIqJTLTJEvs
Message-ID: <CANiq72=wo4LOfa3hrJhTFr8UzkchW4QQtUespCTq7qRJvrr6CA@mail.gmail.com>
Subject: Re: [PATCH v6] rust: aref: make `AlwaysRefCounted::inc_ref` an
 associated function
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Trevor Chan <trev@trevrosa.dev>, gregkh@linuxfoundation.org, rafael@kernel.org, 
	dakr@kernel.org, ojeda@kernel.org, paul@paul-moore.com, aliceryhl@google.com, 
	airlied@gmail.com, simona@ffwll.ch, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, igor.korotin@linux.dev, vireshk@kernel.org, nm@ti.com, 
	sboyd@kernel.org, m.wilczynski@samsung.com, boqun@kernel.org, 
	gary@garyguo.net, axboe@kernel.dk, daniel.almeida@collabora.com, 
	shankari.ak0208@gmail.com, lyude@redhat.com, j@jananu.net, lossin@kernel.org, 
	acourbot@nvidia.com, markus.probst@posteo.de, driver-core@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, david.m.ertman@intel.com, iweiny@kernel.org, 
	leon@kernel.org, bjorn3_gh@protonmail.com, tmgross@umich.edu, 
	tamird@kernel.org, work@onurozkan.dev, sergeh@kernel.org, 
	matthew.brost@intel.com, thomas.hellstrom@linux.intel.com, jack@suse.cz, 
	ljs@kernel.org, liam@infradead.org, bhelgaas@google.com, 
	kwilczynski@kernel.org, ptikhomirov@virtuozzo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F7FE180008
X-Stat-Signature: xxz6cabhxmax9upykici7knzx8h39xje
X-Rspam-User: 
X-HE-Tag: 1785950461-620984
X-HE-Meta: U2FsdGVkX18IB90feF8V9/solZZ9w34P+ISwNzNZeZlOCy4z8rA4aVRn0b8DRTNlS6otaBLvcOqzplzXmW7IAJd+Zw95bBmY3H0UZPUHHbzJbRBCdkbb0GdImhcgtkoddvVfzdQy3PMGztt4T87B0tYqtns84E6TDP0XcO+jFcvLXVdKBFRaEJtKEoN3iAEic2vaPrp6Odu0GfLemNuhhsmyewtrElxXzMo8znRhJFIPRaFkPppm8hj4KeANrPjbnBr0eDfGsjt2sO2llbOPZgpSouo+2vr/+do7a9Qnu24FIA9zU476/JMsU+epwENsV/0Qy161wsM2EOapA0bkNDsK4AGV4XntMqT9Y8dRNa26FdADNKGcamJjIprRo2ID5eu1dY2bLZTIbPlV64KKWvKeqyFoKaDmZRAJwogovMf5uGAGMfEtBf/OVq5c5ZlXV06WPviSRb6d34OLjjukjZGAYF6YLtgWpqmezenWKjCLIQEOheTZXO2v2Wo9ZphFXsU3a7nXV93UjDQc58Btu1R2QweSTY3/woAM3KpgUlq7M/8R3PUT5bRtyxaM8Wxw9MXeVfiJjAm5WkM11Owho6iC6ujqem527B+fMgNP08KVV0BQLan47s9jwrul5+cOGWC+enzS71EF54JEsJMJtPNxeGiPhHtsuBaf14JGGDTFBLRw7yRZF9XL8KmEzs35zzLKUkDEtzT8CaZr7XvnJ5UWiRBCPv0XpaXF6bphF8in0FvYEiI2L9aVlMFFdfM7aVXOViI2m2Jz61IpUDz5loov3qRHMdbdqWMdkqi90CxiAxREZqG7HFGvija61vgHTNJpsdcEPF6KwkWwCSkuXRtHzCQUMZyqkLiEF1c6Dr0rWquyQXMZOZuepGg8u59FJefrgC45YoUR9ei3tzR2DrsMTY5R2xQBWwXiDm7VNbqRKJd9Hm5hZwmI1SLPwAdO2dsQxQGnGsq3CC+CiFE
 jghlGZVD
 wBJl865WHzNn4AMxt7rpBy6onVZ4hna1wa/buPaJP5B+R7QIDiHnu9y99YMmJSTNqNyUKRx02HH+2074GZZryGMOKWOWAAhcrQ2cC+G5ku3wGTw2LWPViqJqPIQLQunMgB3DiGoflXo4Gt2mritxn73tS6gl6WsXJW5WvvlwC/QRwIgtQh594A/yvNPemszNl1y42sdNqzdoQPtjv/mbozI6yt6eeikAJgBsLooIfGybGPAU/SfNfHqJIDLDeV1oJmajggwZLPeOtCT4PaZOMZ9OYoHgzmJ2vncJA1/jMrhWaQyo1f9VgDI3LpX89vGkG7aCFU6XT9v7z19sqan5ltn/Ik6SIQCDF5V0UoobEQ2DcYfTVaeBcsh3th4O/TYJu5FUEIN0R/uGuXOnpmCzTaVG96O7fgQqoRS/prE41XsEl7wK/m6pABafHhrVwnX6DdLjeGgE/hyQn67ydEvc1P/g4bkeaJ0k9y9oKRxYNxG51jA1W2xSSX6bqpRblVo5u0kS2Sc7hqCFBLGcJMbJn0qevoUplew0KXq4BZgku2grZJ6yM28ZBRfjxvAf16h6VMg4icjTwycWLBVDw07mAm8v5xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 11:26=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>

In case it helps, there was a v7 of this one:

  https://lore.kernel.org/rust-for-linux/20260628100731.64885-1-trev@trevro=
sa.dev/#r

Cheers,
Miguel

