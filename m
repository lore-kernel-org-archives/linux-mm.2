Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B1FE9D827
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 22:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929486B0088; Sun,  5 Apr 2026 18:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA1E6B0089; Sun,  5 Apr 2026 18:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8CC6B008A; Sun,  5 Apr 2026 18:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4436B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:50:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E3B21A0124
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 22:50:09 +0000 (UTC)
X-FDA: 84625996938.13.5E6A066
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id D7D281C0002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 22:50:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iuVp+LYQ;
	spf=pass (imf18.hostedemail.com: domain of dianders@chromium.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iuVp+LYQ;
	spf=pass (imf18.hostedemail.com: domain of dianders@chromium.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775429407; a=rsa-sha256;
	cv=none;
	b=BOZuL08ms1aRp7S8EFo2drrZF+zIQDatXMzPxbqZR2CSVMLTb1QHFK28jbatDd0tzx5Ha0
	F3sDjNQv0KzfdR3ZoAehhAF3eD7YRvdhKteITEkxxUdwJzQhDwJr1u2SwWZgZ9zZscym4n
	2Kw8jK1vceeS5ohH3idfpZsUKumwIt4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775429407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzjlDiAhhtCwD9FkXK7yFaosCzkOtMCSogVYlSJljQY=;
	b=gjEkK7tnsgao8pqSNRRLejzWnfDHonLUaAMpXP4r9bIofcAermUVoKn5KhRkImkxyjBgBy
	sgxyzuOr3Lr8p/mxp5lld6fVBowIBvxFqXGamSHtgydwyDB+Pzao6+JWz/tI3ibUhpMWsV
	kyfsCk3IDyHxeX1ZY0mC9Ai45rzv0dY=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66bb6eb28acso6182807a12.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 15:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775429405; x=1776034205; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzjlDiAhhtCwD9FkXK7yFaosCzkOtMCSogVYlSJljQY=;
        b=iuVp+LYQMgz3Er3wAVE5Hkx3CXj0PEs8gSyqHgBLbV29aGw6o96/MDUYuPw++gV/9r
         LbkvhWWsEsfLl3x8iNI/lwJnRCUAboOGJI1uKHc79ynMyHweHsTELZWqq8Z0Caz6q+xv
         hm9SgV3ZyaleAthDZN9I7qqNI2V445hOqjR+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775429405; x=1776034205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jzjlDiAhhtCwD9FkXK7yFaosCzkOtMCSogVYlSJljQY=;
        b=lWuPIMd2fI6jMYDjqgSgPmiSC4kh8fLExIdwAgNggXnLNvnshwnJZp2zPDHix9+NGs
         RO6e5XfLgJSnodKOBndt2Rk9imGmH1RqS+nBzg0jvdv53Z8DGzbnT6MlH9MHxh9fNJvK
         gMjdU6CTMdSqzc5M5U/FoZsDS28Iza2n4BilYz2ZyNww8lYv7kBmO7YlBYrj7NZsIj8K
         pT5AeR+olPkB2CuyrNTbzGBnCtwt7o/W4d7SGMmtEsUeP6y5rj0ktfP7++E1kaPigIZT
         TkJchFyBirSdyZDiKCvSBDm6++FvHYJkxRvyM/Uau55UqqE4IfS+GuIxO8gA8lDNY3js
         YIfg==
X-Forwarded-Encrypted: i=1; AJvYcCUNZz1sauBxDYoEAmhWCIGHKDIj3NNwAIGGCX2jIK4S9YZwm0c8kJa9Dqz+8+tSTWQjkkxAUY635Q==@kvack.org
X-Gm-Message-State: AOJu0Yw+K3ZPP3iFGZcyFvtGD28LAE+npfr5IBXzlUpJJH6ivOyKEjZ0
	7c0VdXY1noEVuuXlr7q2rnyIgq9HlaVRwAFUWivHDhfkS+0sVUoQnFQ0IOYjnBUBcPabgUk5lo7
	Mjv7Xr6KW
X-Gm-Gg: AeBDiesbi7JIUDIuu46qjVvgFGGJMycDjnfI7pNajMqaTvmB/xZzFrCRZ293bOnqQKa
	3oO/T7/HHnHpv+kAxiT03sunXGVwwMXlEkrtmJdjdeuqCn4C0tlBMo+QBVoJFkOP0t3UrSakYgw
	jhyY19mx8SHq8sG90V5v4Jh20rHD0AIPwNYiKB/sFe873FkzlJYFg7kvMTC4MayVNAZPNp//40e
	jzQuQHcAbjdvHCFM7GDfsT94EwSEW8YA8o4bNTWjfIyeKyW6QlWsWK5bQUplScB4MLmMPgRIZY4
	zrKqvhbd9x2x4yQJ44bh+RwZfjoh3tr+NfXZS4kNyojllH7Yir+VnO5VYa+Ld0/5NgNmzLqMqYP
	cv8oiunOOcpo97WE3+iRxn08FtQOSrjB/eWJ7/O14g347AGiHRKbPRPH+HSW2FyWj0RQq4omYvf
	BSKjuaYA+akDJZhGXcNAZUc7oNcvY0ejMCIsCwrTnSupnka6eGs8dEq7zoPhH61g==
X-Received: by 2002:a17:907:3d4b:b0:b9c:513e:34db with SMTP id a640c23a62f3a-b9c676a2d7bmr589066466b.23.1775429404433;
        Sun, 05 Apr 2026 15:50:04 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9c3cfeedc2sm425646766b.42.2026.04.05.15.50.04
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2026 15:50:04 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66bb6eb28acso6182793a12.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 15:50:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUGoQeyiofoNRpSaMyKlmKlRWirW2S7ysi5oBOW9J3v+JVxkMML7hR+ZO7A7C1bI5vDH9Cu2OaI8Q==@kvack.org
X-Received: by 2002:a5d:5889:0:b0:43b:47ee:4586 with SMTP id
 ffacd0b85a97d-43d292d34e1mr14051064f8f.29.1775429026066; Sun, 05 Apr 2026
 15:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260404000644.522677-1-dianders@chromium.org> <2026040539-sponge-publisher-2b42@gregkh>
In-Reply-To: <2026040539-sponge-publisher-2b42@gregkh>
From: Doug Anderson <dianders@chromium.org>
Date: Sun, 5 Apr 2026 15:43:34 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X6DRHV6k7G=p5Mno22na75G-69F-EzMkisSxMoxuvJcQ@mail.gmail.com>
X-Gm-Features: AQROBzBHjVedWun0AWH98b5RajBbraAAaRvLQSenEhaNEY8p1Czch8mAczvPiQQ
Message-ID: <CAD=FV=X6DRHV6k7G=p5Mno22na75G-69F-EzMkisSxMoxuvJcQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] driver core: Fix some race conditions
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Saravana Kannan <saravanak@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Eric Dumazet <edumazet@google.com>, Johan Hovold <johan@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Alexey Kardashevskiy <aik@ozlabs.ru>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Frank.Li@kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, alex@ghiti.fr, alexander.stein@ew.tq-group.com, 
	andre.przywara@arm.com, andrew@codeconstruct.com.au, andrew@lunn.ch, 
	andriy.shevchenko@linux.intel.com, aou@eecs.berkeley.edu, ardb@kernel.org, 
	bhelgaas@google.com, brgl@kernel.org, broonie@kernel.org, 
	catalin.marinas@arm.com, chleroy@kernel.org, davem@davemloft.net, 
	david@kernel.org, devicetree@vger.kernel.org, dmaengine@vger.kernel.org, 
	driver-core@lists.linux.dev, gbatra@linux.ibm.com, 
	gregory.clement@bootlin.com, hkallweit1@gmail.com, iommu@lists.linux.dev, 
	jirislaby@kernel.org, joel@jms.id.au, joro@8bytes.org, kees@kernel.org, 
	kevin.brodsky@arm.com, kuba@kernel.org, lenb@kernel.org, lgirdwood@gmail.com, 
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-serial@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-usb@vger.kernel.org, linux@armlinux.org.uk, 
	linuxppc-dev@lists.ozlabs.org, m.szyprowski@samsung.com, maddy@linux.ibm.com, 
	mani@kernel.org, maz@kernel.org, miko.lenczewski@arm.com, mpe@ellerman.id.au, 
	netdev@vger.kernel.org, npiggin@gmail.com, osalvador@suse.de, 
	oupton@kernel.org, pabeni@redhat.com, palmer@dabbelt.com, 
	peter.ujfalusi@gmail.com, peterz@infradead.org, pjw@kernel.org, 
	robh@kernel.org, sebastian.hesselbarth@gmail.com, tglx@kernel.org, 
	tsbogend@alpha.franken.de, vgupta@kernel.org, vkoul@kernel.org, 
	will@kernel.org, willy@infradead.org, yangyicong@hisilicon.com, 
	yeoreum.yun@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7D281C0002
X-Stat-Signature: d885y6duhwxmpd9oh4zw7y3acanes8t9
X-Rspam-User: 
X-HE-Tag: 1775429406-622778
X-HE-Meta: U2FsdGVkX18aofhMInXrSjOPlRmTHL6PsVPUA8TzstX2SVSQIh6+7JUieAY6juSInzh8+RfDrB7Fg+ISeKDQt1BfC7i3ybGa56yKdfWyH67GJVL3HKTjImACrbvJunlqtBxdK3QbzJbPEqPr4jYGI7Gj/GaupSSh4jm92MAzApaBlb29ChBe+7PiWhYUy8Z5gzbDnv4E9thPhaynFAfwMx+OzCsi4O0O5Fjra2Eae8xQPMHkSkpXGbERKdzrv3P0J1TMDa55jQ2ggltJXMdpsg8kMTpzVlCm8eBlE0JFCdMYSLcmx1rYsr4L41K4o5n7XeXJNHYUqUd/2WGo6lMnoI22GOXSNLpfnkaExx8z4JT3B59V4ftQv4Idf8iNbPJqxOFj4nYHlIXik27IMrt/1UwMRioD91EBTfZu/dPhQ320QSDqQAP5TQB/X8cmc8MP0fDeNfsoJdA02No/jDNiU/ZZvaxhXtbSMdvBA0wJvsw/94TKnCL+ARtCNwRH8I8WsaKWfVZXLiMMlRbcoO3KR/aQ+bdVyqLhNFs+iX7e96m9a05+BZN1DWdsa35xFUzqIE3QcVQIpR24I8akBtfOMQTMdJ/Qu+U7JrXTJLNyMjK86IIgcfuvFIYH00CFg7XR7LuejiX69xIXu/VZULJXffMps2imbix/Zg79AZWQaqYZBBf889K1YcNV1bmafrKcuM5erlwFjJ0ZzN6A60GeW+CCStEQvEGcSEnSW9V3h+9KbzvUhsv7IK1q3xIFtxqegLlbfWXHwiuXnznVqr02CBQ/swORDRpQ+XLffJipmk71A0NV6B44BANrfa7uF91tqg88hZyLPIs0fR19BkWuW3g9d3d/z7fq1Gkq2HzpK7v0RM1h17kIN4/S5fu0Zo+tVN6espN4Y/rKQ8QnzIHHHfyX+vjxcLyOX9anjKt2yUgkrR24NGuF5GbMnaDr+UhmqvU0me8dO7zZyGkLJzw
 u0vlwpPd
 Dhi8zOGkhaSKpg091mQMyTqUa8hx8U80fZu3GVGwGtjUSpVnTacCYSexlfF4QVNI11HRYjmmaatbSKavEDSpT7UHbcO1J0nSaIrSvBpkUZ/Rr5zlyX+G9u4Xt1UwtjWWGlJ5a7koXzQVhA3OSX1R32dY5ln6wIr64KtvgcJ+bMG5KXEvrbcwISCZzvSCXazYBH4c0IoHWrvZUoWRvxxy9QXKehp5uU6QynqADcbgLFw3ct3E38eXagpiOB7CHErbMtGOrRNNlo0bagoN7BfTiIv/Z8Vl/VH+pl2x+t/+wZQbWYM1qaaEVbqgC1QHGY9NOgCc2I8jqXLJhY7yzqqZoZlKCT0AHgqP4VQTJr63xFkD1oexGesdIQFZckmv6q4XzR0ts/Ha6GiKGLuCwveVMB7lisSHE/IY3aVzq3TqdRgjGhCWqWBRGW0o2DjPkDMlIsQn1freuaJUoTx8VDGLMkUV6IB4ie58HvYEs/ezzlX7o2hm1SH5GqVohJC8e5radQAhA03230va44nZvE8aI5MGKfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Apr 4, 2026 at 10:28=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Apr 03, 2026 at 05:04:54PM -0700, Douglas Anderson wrote:
> > NOTE: one potentially "controversial" choice I made in some patches
> > was to always reserve a flag ID even if a flag is only used under
> > certain CONFIG_ settings. This is a change from how things were
> > before. Keeping the numbering consistent and allowing easy
> > compile-testing of both CONFIG settings seemed worth it, especially
> > since it won't take up any extra space until we've added a lot more
> > flags.
>
> Nah, this is fine, I don't see any problems with this as the original
> code kind of was doing the same thing with the "hole" in the structure
> if those options were not enabled.
>
> > I only marked the first patch as a "Fix" since it is the only one
> > fixing observed problems. Other patches could be considered fixes too
> > if folks want.
> >
> > I tested the first patch in the series backported to kernel 6.6 on the
> > Pixel phone that was experiencing the race. I added extra printouts to
> > make sure that the problem was hitting / addressed. The rest of the
> > patches are tested with allmodconfig with arm32, arm64, ppc, and
> > x86. I boot tested on an arm64 Chromebook running mainline.
>
> I'm guessing your tests passed?  :)

Yup, all the tests that I've run have passed. I also threw in an
"allnoconfig" compile test just for good measure.


> Anyway, this looks great, unless there are any objections, other than
> the "needs to be undefined", which a follow-on patch can handle, I'll
> queue them up next week for 7.1-rc1.

Thanks. As per the other thread, I'm happy if you or Danilo want to
apply it, and I'm happy if you want to make minor fixups when
applying.

When I see the patches applied, I'll send a followup patch to address
the "needs to be undefined" comment, unless Danilo makes that change
himself when applying.

-Doug

