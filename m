Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D103C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D7B6B0278; Thu, 13 Aug 2026 09:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E7B6B027C; Thu, 13 Aug 2026 09:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FC76B027F; Thu, 13 Aug 2026 09:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 558326B0278
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:51:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3C0B1C0154
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:51:54 +0000 (UTC)
X-FDA: 85096384548.27.D3ED960
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 184781C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:51:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=Jou+P0RC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of daniel@0x0f.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/TpxUYDdMY4Q9xfy8YfqP8QfSVp9kiSqoVc/8L35II=;
	b=BNN81Bx+/mYF5blTkeHEgMsl+udN8nhCw41dNDl6NuXl8AILwjuhqtzBGmcZJTXYvRzzgx
	z16cnHUCCZ7WUBFjInEJsJG5NWSIKB6PfywoDXfdpQaSyiw3+8i6hiYxxPyVQyiEuE0KGy
	2u6meOT/cz6BwKt8dMjEFYKyc2bsgzs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=Jou+P0RC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of daniel@0x0f.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786629113;
	b=lnrNllwTqE5pPH/P3rmE4sN6NjR0nBjuXrfd7tSwmbMVkvBDwFnZbHeabB95/gYyfAjEBy
	OzG8vMuLHJrXA5Lf2qXdIANDNMkqMcCYJyQF1gF4QMEUGq9eaQuLIAV1HXXI5PqaRAGj7g
	iujz0kQatueyC5W05YKbxcwOqyt8vPE=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ca7c1176317so617496a12.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786629111; cv=none;
        d=google.com; s=arc-20260327;
        b=lxggz5BEHwkS0fzulhi0WY2LsXFEReS9sFLMNdWuZ8shC+2l82sJfuCSLh1Kgl0jms
         P5Lso6SpHdZWpIhfYzD3pHEI4Nnsj8hQv/fzcexkHqCy9bPTpM3jH2jm3J1S3slHBsiE
         Y7ikP5WxoDoy1dWf2TAE+C23JKN3TWBmprmmHwe5yhQGMUFY1UeHIJSaQjR1gLlz7VLw
         bwXcMbtx1K3m10ngdfC5NQZ8kKGbJzVf1OBvlo0HAyECxGXkg0ByKpj3sc3S08tqg24X
         8UzGIH/AjDkKgHZllaPrZ+ADwuuWOSOt43HYm3RTm/1/QjQftOxs7E3dWG9e9B+Ev+AR
         nxJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i/TpxUYDdMY4Q9xfy8YfqP8QfSVp9kiSqoVc/8L35II=;
        fh=3oNK/EYIEKivSyoNwfl6YUceSy7XwWZ1p8ry/dzrEcQ=;
        b=izfTjVLBQh9fgmgrPMpVf9inrgWtiTFJpkxcpViNmoLjSGmBswyyFbGla6y96ICskz
         GyqoszZ5ilzFy7EjbNSssu1/Bgj6QtzyzitPFat4eOVOnSJgFzIXod+3AxUnAiRKZI9J
         FIMJ/oluvJIIIs5PVpVglfyxISalbmAADNSNAWE8CSeQlwdrJ9caI7Itf1PzumsMK1xg
         XrpMifOeKSnMB5xHb5mfKFvWlOHFFHYTO1N5G3qVBgKeZIZAGp7ChjPXaehZ+ooD8v7Q
         f2+ke3J5+7qTM5rNw8zAEe5ZgvDgva2Ci2bOrMTKY4S8OaYeJysWTiZ5bksA5XFtCqar
         MGrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1786629111; x=1787233911; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i/TpxUYDdMY4Q9xfy8YfqP8QfSVp9kiSqoVc/8L35II=;
        b=Jou+P0RCvLn7njxJtsaXGctQk1Dfnz/UPAL7v2JUVvMtCymKhv7SxscANLv24mIbjh
         Nk/0dWvhYMR/yzu1wi8JCJ8c9egij6vzu9+ORTHdMIXfxUQxKYhmmgFNi9PHdhCKa2yG
         R8U7WWJrzRbwctgIyvgK/W7hoLGqkNy5LByIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786629111; x=1787233911;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i/TpxUYDdMY4Q9xfy8YfqP8QfSVp9kiSqoVc/8L35II=;
        b=A1B641bWbYXy6p8g5EFK+qK/BKreQxCCJjqOeWM1wCeTH2OKFskkmOZAdNGuQkMd1b
         NbGRB2ufrxv9A2NBrFEaUE8PHFKydVqg3jlB7Nd+lRptkA5YpSvDDcYirPAjETubu2k4
         PROplAUBtdPu04JL00ff0W+qpUu3hmdLWqpr5wHkyMIlMI5V/EtgsrWHUen3okJqX1uU
         239pILxPrU5qyR9RB8s4T6VQ61VzizbDq9CtBy7dHb9q9Oc6A8f+ViIWMHO4mKduYRa8
         0veyVzJi0++Dt6xyA3RUKz240VVOMm9KzzEKBRu6XXZnPzoixmpS4NlE8sYyGxDL8Ktr
         t6sQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/kO8xhfjp9qxNW0LB5sXmLP+mX9NMA9bS77XbXq0dqaQR3gmVq3KKOe3c8qQlZKGPJk+poG324g==@kvack.org
X-Gm-Message-State: AOJu0YyvubNARhytKRlSzmwHrJoUp0ZYzlxXe8N2C5AZJrMw/ErMuOEA
	x4+uGOJAXca9GejHqAG4IrxRIUN3aUDdvpdME0nBq4mxmyNdBUSUxtvBC1TcZ2QayZKppWRuHEk
	+UaEAxiDrNh6hsUp5Bxdd4OYQnfg37WefdJCdo3iPVA==
X-Gm-Gg: AR+sD10DvEUap0Bg3OC8K4SX64bHXx9s1SJ6dR4aimBCh+cKdcaErIPlAXXz911Zov8
	uKBKCiUGolZ5e7UHtazBUm6L40MllT2OVBWI1kxzPMLbgfJiJd5EuZ/jx1IHD4PWero3Y6Ei+Id
	F19PlAx5ALuYDVjR3AuWk4juMg850hgmlqG9EgmrDUDQG6jGMeIsa5lxB0vdanZwQypR0SHAzH3
	9fYW52UjP8TJsDEAVIPBV49rwDL/9mTp8KIbflSsxJUaNIsiELi3N8mu69nv9g+F5UyXCqrodIS
	SeIHIoXxYozapbZd4lLvx2c/ZWwJ06gUZlAMI9rlIq2Harjj8Ey4C6iOZO8WINyHPj3AoN6/NQ=
	=
X-Received: by 2002:a05:6a21:62c7:b0:3c1:85d:fa2f with SMTP id
 adf61e73a8af0-3cc554d4f6dmr8080310637.36.1786629110629; Thu, 13 Aug 2026
 06:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260813063401.1786548-1-thehajime@gmail.com> <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh> <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
 <an3COKVbgQKdY52d@lucifer>
In-Reply-To: <an3COKVbgQKdY52d@lucifer>
From: Daniel Palmer <daniel@thingy.jp>
Date: Thu, 13 Aug 2026 22:51:39 +0900
X-Gm-Features: AUfX_mzxGDAqX_BvwA0fMZR4ykuQ8TryBISoFdwPrCVEwtYNSaZSFJLhnRKlb64
Message-ID: <CAFr9PX=dkFhD5Q7JWaR+rXt_Ah5n2hxi2W3biqQsUC77dAaZgQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, 
	geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 184781C0003
X-Stat-Signature: 8qetjmpgiqi696o3mztuf8usy3ewsn9u
X-Rspam-User: 
X-HE-Tag: 1786629111-731040
X-HE-Meta: U2FsdGVkX192ubveXXXMBnq9Fy2/NEeJIU5sV4GDdJ/cSA8L94eUj2pfMLVk8LDlQFzq0EmX9407mR81quoWnZlGjZ7v9fSozxoxM6Ei4LdD3ee3UnZ0zykqy5W8ct3fGGn8QIi0CzZonyo+cMJ1GUPoiOmOd/s38tYqdr7vAelOHAielL6xHqI10j7V1DAdXJEtWThelGiEenVs6VzlEzDpaAizn3VX1k/WhLK58lnsvpVXh9E/Dl9NG/CxP268IZ+G89U+ifTB3u+uRnruO00aijm8mneFWzAXKsHpOTPjEOs3CQZSKeDz5Fb74hbQepKxXREL6HcZzLaoVShY6UJt4+w0VbdUNAFMfczuB+H0uvFgQwtDiU7CUc9HirtwNQP+EkkZXam4xYA/MFkhx4tptjcNN0jOasMOZ7VSqYXIB/zj+63fIPhzpqemSujKtAClbKrNJa+SRdAwhiDBFqjc/6X+96RMFFm5e1nPFyr2uC5YgGw3J+2n83AgMx2yDeIi/D4Szl0Y7nk+H+wwUdmOJU9N20wOcXzSmDwfDSLMZlGxXGNQVxD5DtocmFwV3cIv8PRTJoQW5R62h8D035I4uUrzb/Bkv999Lf6tTD2az48c7G7Y7wsWDMiH7dWiHT9Oyis4dmrfVWwGTuLJjlkfPcBN5EniG0YkBlTvsVZUR0lOB7b9xsTiPZ9gxc/ownRW1qTCahCfKvSXb6gb08WERE2bn8KSdpE2kGRQF+XgwER5nDwWD0jeyq6kRuU5arBUpUBW685yS9WDIjVxzYmNK80Kr5BvXzPIfWp8jS135e+25ert14JKOnxCkNO0FTqJ1imHuFBYl//PNNlFGeiHq1Tt+O83eY9pRoulFfCvLi9W6105Uv+PtSDewNiYpKFW8Goph9I9J4I4dg/pnF9f8zBNdk52xksSOJ4HjQ46OP/mPQzwskmYA3GmVY2c/VR10rt1b8iAyUWTvhF
 WYlRkm61
 PupRWSLrUKvmG1p2Sy+tZUcYwVHP6/V7LSufi6ChnnwnxwDFHm+4kPX+4pOjn/W2l1YtNOL9ORt+DGBvOx2jAGS4d25lJvNm3EkKqUgC+adtvrziUnjFawxE/a/y+DFQ23vq2Y7tW+iUHVNd+/bws9hjeV3IRRNWBtKppt3Mnb844IKanuUNuVdKvM3tBT7GUCGNmtiXrgEHK8IMkQCsB4g+z7UucLgzky2UjQnfIApsKwcV00BAung6IT75IuLRAW24l+R6i+Dh+ShoAeiP6Zc9KcB85MhCF4BvuObDFAvh0FrDZ23D+BTQOgZgNjsFwIBrXNBQH8SCi7kaHDFn093c3d9po5u/9MjbG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HI Lorenzo,

On Thu, 13 Aug 2026 at 22:30, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > One of the big problems for nommu seems to be that everyone is
> > convinced it is completely unused and totally broken. :)
>
> No, the issue is that nobody seems to do any testing or contribute any code
> aside from at least Hajime (thanks Haijme :), and possibly others (forgive me if
> I am missing people's names here!)

> There's been situtions where nommu has been broken for a year and _nobody
> noticed_.
>
> And yet whenever nommu comes up people always seem to pop up and say how
> important it is, then mention a talk etc.

It also broke sometime around LPC 2025, I spotted it, reported it..
and told the people in the room at LPC for the nommu talk that it was
borken and maybe they should take a look. :)
I think I maybe even told Tazaki-san in person that it was currently
broken in the hall outside of the session.

> Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
> code. Any or all of it :)

I rebase my 68000 tree on mainline regularly and make sure it still
works. That's how I noticed and reported the above bug.
I have a bunch of stuff that claude fable found, validated with QEMU
and then I checked on real hardware but I'm not sure how to send that
without it getting instantly marked as slop. :(

Cheers,

Daniel

