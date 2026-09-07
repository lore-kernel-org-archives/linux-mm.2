Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A84C8C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EAFC6B009D; Mon,  7 Sep 2026 05:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C25B6B009E; Mon,  7 Sep 2026 05:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B12F6B00A0; Mon,  7 Sep 2026 05:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3F96B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:24:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8D4F1C0B9B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:24:38 +0000 (UTC)
X-FDA: 85186431036.27.6FF7B2F
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id B54DA140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:24:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BfpHtGtQ;
	spf=pass (imf23.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788773076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfGjfP8T35WEV6rGIAsKY4f5Rwo6my7dAG0voowddxQ=;
	b=afkX08Hdiktq3EuILPJsuwkqHWaDB6Td78WUkx22fe/LptgLVfy8VZqV21DLZZps9/5uUk
	zX7yXepDR1TBi3oL2d5USGlXD/UB2i6Rp1DlKFdYVP0fLn6c99/wWl7rjx1/hRKDQzXDPy
	ru3q3/GECc4SGSij5nvhxMZDHMg1WXI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788773076;
	b=R2JEpog0NPtFNkMpR07B6CAailHBfG8wK9XwYZqL4pjm3cC15g7kZrxrx6yxYZFVL3dhmQ
	bGMNxi2Vkp75lIugmujQcMs9fgc1l8o6Ozl+Byt6AxReeuWcI8u4NTzPGOYPQhgCzI4Qbx
	DtWBinsBvj1hagS1pFLTfF9WwpuN7cY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BfpHtGtQ;
	spf=pass (imf23.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48436251906so3779625f8f.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 02:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788773075; cv=none;
        d=google.com; s=arc-20260327;
        b=av2l3FvOCSeEnjCfkc7rTdiEXh6dfY99e6mGjuCPEJrO5RHOLCRkdfGWIV4AdEKRuq
         YXSDndGd9hyR4l6RPCE574DDNUS9ftPneXi8CE2mLEfk1Z0IUT1m0lQ2W/QB5DKqsNxN
         w4G1CthrIAtjfJgXJ41PU7jkMvtdEgIKE2/cnh1ChwZ9MyQu+NIPYnUkS0ci+d8Tigkn
         q+OZ8bnORFSti5F62u66X1dkuooQKFN2T/drnPhR3ejwinXnsjuG8yh18RRtZRc877GV
         GmdgebthT76Hi6grVtKCPi4XVmtPiW4Va8yHRah+0JF7Gudz5d45zIobl28utshuh3my
         MWpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hfGjfP8T35WEV6rGIAsKY4f5Rwo6my7dAG0voowddxQ=;
        fh=EaP9VHj+1lgL6A6YjnGJf40zez8FitLK+qIzwLMSg4A=;
        b=sP1cSDyn1LE2twIYMRf/ZLVauwYcXRdvCESPhuYpyQkMf+4i9L2DrksVFxGAK6lfIx
         QAfSSghu45M+K4WqSETDJxyMGM+Kt2S8T0csQb/CAtcdCm7aDE0Vt4p/i60R0HwfMVMw
         z6PGhy8dviNPX48KxvC8XznpQj6e70r1quq2sNmZHiKfjP1WopB+3Qdn++DY8Lo/L2tR
         5FCJY6TnbirwYPHYteDUxCCAGjJTzK8BSgThNNT3J5jGs/YV080SJ7yWAPVW9bJDusJ9
         98TpRakpMKKInUqoz/niq8DRAfr0dxar79yD/pT15tlZ/d34mqmoFpXK/W3vKZkE8p7G
         PKxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788773075; x=1789377875; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hfGjfP8T35WEV6rGIAsKY4f5Rwo6my7dAG0voowddxQ=;
        b=BfpHtGtQSX/Wxp3E616F5aw1tPmQfZwL5SBbpsppqUgbZITEp82FfZ60K9ubvV99gC
         Nv9a0yOWz8Xa2qDRr2N8DEDyOkM2jXiOmJGrkVmA9wqlu03bcZiAiOa9vWQg5peP8BWC
         xwUVXXKWvN//7CHh/zlODBdQ8spPJ/qWW1wcieXa7dvjFyAGXUqsbwr5daAL6otYOrn/
         u7ioddH383HEAhR6ZB9E94KpXjrWNBOsijm/HbkiK69rDZdZr9jklQh2Al2CRfsBYWKg
         qHVi1JRi5ZdU46aqDwUrsZdWjVmYqeJTDKLDDZYwyZ4+Y6HYwdSa3+XcoJup+6hQRHZ5
         o/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788773075; x=1789377875;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hfGjfP8T35WEV6rGIAsKY4f5Rwo6my7dAG0voowddxQ=;
        b=UQVVJgJtKBjq0SaMRiyjZWRoAWaldfC0lpfy4f/4yYJpcnlLdS0xW5R1+g1EJzRQl1
         ITsltrEgZDgILxCGWmXqZWJqnzK6ltkXfox7Y3CBTAVR6h2UxzQTgOWrpYKW5LbOdG/U
         6zO+zXbxBM625zyVv91n39HSGlfnL5uYOzt93CTenFexY9BVragkSQ0fuwy2RkSR5xcu
         VCygh9FXkTKIFmwOBbUQ9qLSrpwiTtPugV/bu+wQF6oS5UtGni+a4w7zDpnGUA8kqLM4
         qnAcmrytaqxlYaEVT5ax1ukCBM11hzqyzEVnCtK0cR3rT302UTjQh5DjwvKThg/GbSbl
         0tiQ==
X-Forwarded-Encrypted: i=1; AKwUvBzNMp5FTEi9WrOOpWNfDDJtGOkQJPLyaSjEEi9PnXHY1vE2wHT6YOkA9BgkP/p3wgG3J8CLxDiXyA==@kvack.org
X-Gm-Message-State: AFuF++l+ITKajUDJF1MweGULV6jUnD5Qr4rc2plqPZNRvU9v0dxVnauC
	M9p5UilXBqTFS6oV/i3l8OI2eqWyOW7imw7qHbRSfn8tW3Qc3hYcfHbdjhV3lcTmnJeS6Q2wnhf
	IY3mqpqqnh/9qFjQjxOFIpuXOJ59kCHYLLLcNYyL9
X-Gm-Gg: AYBFou108Q4+5etwZEuv/qybu6cL9P//Mi14rxTeGeTu2MxPvZnIeDFzFREZDbV6WUk
	qaNLuB7O4PEcTqoQ3accVMehTV4YidCuVy/SkY6sHV1EzGfM12n94OExSeeOnRNIz9+XzaqwVJ5
	h2xTWGMTm8uqCQ/GKRqs9nl5l2EPU3X3SXKE9XkEAwp2kBsHkYaUCjPiCLqDiYCps2kbwJ7eRAT
	hOAQ0a4OlGFqp3N5hsaSkKyFjkbpioxl6W2HzmWBNxC3wAvdoVrAlHPxGt9WjVpGIT+XT03VcqM
	IpHV8fQ8Quc0RGRPGPC8kiHsXVJoCUUUMwH9/gIHJV9uoNC+NkRuIizx0/C58/cRtd3Hs3k5rzR
	PBLoTCB+XHda7fr8+AtvIbUnWYyBxAjM=
X-Received: by 2002:a05:6000:430b:b0:485:8ad6:3752 with SMTP id
 ffacd0b85a97d-4858ad63a6fmr37026021f8f.5.1788773074197; Mon, 07 Sep 2026
 02:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org> <ao2WubjLtDuHvRzx@google.com>
 <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
In-Reply-To: <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 7 Sep 2026 11:24:21 +0200
X-Gm-Features: AcwNN1V4plkowyMHAsnIxTQwxzR-aYAz331pg1N8okzwNx7uKX70uWh-YG4Yx6I
Message-ID: <CAH5fLggAMfBcxprKJxs4JbieKadC_mKg4B0xNETOH1QUi72UGQ@mail.gmail.com>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`'
To: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Asahi Lina <lina+kernel@asahilina.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B54DA140008
X-Stat-Signature: zoc9mehfp4jqsciduxuyonpmapwg4pxx
X-HE-Tag: 1788773076-829297
X-HE-Meta: U2FsdGVkX19IMUMLzyn0m01YQ7sjR952gMwmE8lzegCyIWHydkqalVBboi/PvmvkjNQhyfpAQQGcmizH7oWtFweMnVZWEhKpZPFw3IHXe5N+Qv5NFB87LrKaaz3vC9r7zoyHJrcSI+sDgSZYqFzIMiw0ABgl7WeBIxUQnKFsJgQqr/hMh9yS0PMa5GP9JuRG7JqWdqmuWPSQpP5WxmA5IV8iNm1cqX1P7e63IzYx1GUG+nEO3hvhgswjB89G/pwHArUYV3F4BgBvYU77LIHpeb6+/ltL6R03CQ4ejnp1RDQCR+5372EIEDyVlzy9GFBQmohL/pKaYQVyQfzPZ4vnTssB10tYqOz5r6dghBQ9Po10WF8MWvsCcYwj4z/vVveIXdgexDTiP8/HzTeQXkw6Bm5sSgkCUo6u2XP6KGq1CrLaQPuTiy7xbUXeQkSF1XVx/B6FBD95sH2pH63Q2Ixh9mQktxlU5xOZu8EtNSChqoDwimYgMNVsaddVMnb1E1fdm2jEEl2+3xb2jUQMqIS0gQCDn8WHPMR6kW60MusUispTiTPKfbMZm89ueFNBLcIx/VGLsRLRx1GB2o1dyX2WduhCvIPM9TBqyw8zRqNSJIdVEKnLfZsdLxy6HiuDFnLy45C7tRKS4ydGUo+Bf4hSB9FhmHrEmyK2Dc2jLqQl8yE4OdltNoogYbPM+pcoE0x/aqcxp24XLa1zCRfK1na0Uza1YmyAI3aikS+XKywDy0MGUr+CGrYV9czV6ZY9fqVR5V9FG2GRrG/QhV5ANig9GoojinQIlKRXE8O4Lekt9xelBVBFh9r9sFFx6BTFEabbGwAv2tsZrkVGDmZE97XKUs3idyFH8LbllSolzdEKAuuBXKOo5qCesmsM/tcSCUL0kkoSO3X6cpe+Q93i6/WT3TbO3dq8VzeN8+8zrdBndUtizwny6QUG+A9ha63XUxkThVvnzutcqXgzKQx7C/Q
 UJCDpF49
 bQJ162ZqT9nM36rktbX2W/9c6LsKmJYOvwXQLkWh2QznLdzX3tnmzavwSfFOdHVg9zBRW4vyS79gqlmPIdUi4VE/cDg0xMA70ZHqSF7Gek2vCHeaU6LtIyyR+KutwCjn99oFUVeVIx3esHLsUkyw7E4Eyr3t1vDt/NN4gBRdp3hnDOpLtW3RW7KEgaMlM2lgMMu0wyKWYnVuiakTWI7sdTBVEQN8PHRDlyX4cOE/tKzKt/1NVx6+KrZYBMTpxcHxgjEJWsLPcCaKkIr91tW2i9I56r/zK/lxj1GVPpn7jKlPnoXsjj7rScJgTTGSZb/mvoTsNjnDJ6jpMRrav8OZuHVNuj71bckWJlOELopBvsh6uMY1zP2b72NF1N1cATsP6Lr46au+soFX55Z1Z9K5ENA0dP15IU+xbGOua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 3:02=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
> > On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
> >> +        // SAFETY: We just successfully allocated a page, so we now h=
ave ownership of the newly
> >> +        // allocated page. We transfer that ownership to the new `Own=
ed<Page>` object.
> >> +        // Since `Page` is transparent, we can cast the pointer direc=
tly.
> >> +        Ok(unsafe { Owned::from_raw(page.cast()) })
> >
> > This doesn't satisfy the safety requirements of Owned::from_raw()
> > because the page may be used with vm_insert_page(), which increments it=
s
> > refcount and causes it to be shared the vma system, and this occurs
> > before Page::release() is called.
>
> I suppose the existing vm_insert_page() abstraction we have is already
> problematic, because it uses `&Page`?
>
> Maybe we want to change the API to use `ARef<Page>` so it already has to =
be
> shared? Conceptually it takes a reference count from a `&Page`, which isn=
't
> possible because `Page` is not `AlwaysRefCounted`, so it needs a `&ARef<P=
age>`
> to be able to do that op.

Honestly, the problem is the safety requirements of Owned::from_raw().
Pages have a "special" main reference, and free_page() does more than
put_page(). It even does something when the refcount does not hit
zero.

The correct behavior for Page is to allow the user to hold one
Owned<Page> whose drop calls free_page(), *plus* any number of
ARef<Page> references that invoke put_page() on drop. This way, the
owned page controls the special drop codepath.

Alice

