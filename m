Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A95FCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 04:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7167A6B0005; Thu, 28 May 2026 00:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A02F6B0088; Thu, 28 May 2026 00:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568766B008A; Thu, 28 May 2026 00:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 410CC6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:29:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEFA014070F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:29:35 +0000 (UTC)
X-FDA: 84815549910.22.F04BD4A
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7966180002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:29:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=juIY0feu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779942573; a=rsa-sha256;
	cv=pass;
	b=8hOcoBwSs4rK0XGI7mbuY2HFKgcySvx0ZSC1s9EW411+8POw9lHlPVhxnXoJQYuCeA5wpd
	ugkyXVnNe13XujZjCSFcIOkHyXsywtl4D2jPJPrELNGW/xCRFVwpcr6UwztSCu+qEMaCK3
	BLmshIzQ+76V8T+HDilN1tnSUEpS+T0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=juIY0feu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779942573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TzdROHO5b7Xc+7yDI5d2KwPwgdS008IMiT5jPN0ctv4=;
	b=UKowzcwlJJC5Rh6zkQHJ8yTrQJT12zOoJAI5gNucmlS6MV2aT68P1z0kxWAccxn5VkqF+O
	FbrOZnRAuFHJGFEhGOs3Z1nWcHjQ9uezRUUzyimAemafIukUavC/CDzOyZb3FKtRAGMiRo
	vMSUUr6JIWnnbWqXFgXSOrlaKKC2zZ8=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49045e2a8a2so245e9.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 21:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779942572; cv=none;
        d=google.com; s=arc-20240605;
        b=AM/MKbrWnwUCjHTO8fiua7mU/9s5Zj15SJenPX1EF3azs+XlX618KZqxuvmZOmcQpt
         jOCaOaCbvnfTYK9qBs7z7hkR5806vaUjLTryL0ftGupUSZVIh48JXxFRBH7sP01aAyds
         yf37T3Hjv0PyEdXTRwkBNDEWbwyiUG/9d2UE1S4hzs80mxPADInIVGxryzVVAmyT4Qes
         ih456bmb3OpojCL002OYiMrc5gRnRYaXRIU2dj22RS0WqDrlZ9T1P/Sk5H6J7fd8vwAK
         7TS5NgQU88AwyOYnXVuE5jqQZyIa9OVCjn+CzxNpeT5/9ygqmqTqY7fkouOn4RP9U4rR
         8smQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TzdROHO5b7Xc+7yDI5d2KwPwgdS008IMiT5jPN0ctv4=;
        fh=nTdOhYIpsCoa10pi7C3zq7uQPlSzaEabGoexnLBOx0k=;
        b=bUsXAJzfyG7JNZFyrVpFC3ybse5b9adTU3jpfc+s8zqYoDzgNUBVNIJlvllimiX2Ud
         ZOGACJp//wlQBpxnSK5s5U0BBFsUIfYOY8s9Q0Pwq7R1cCAk9aXjlpp4QMkxiMsL/FpK
         hVtnEhv/IAMXoMShxnNHE1a/EDoHVHqz+MdOJarlRjQDo3gLYqwx0fJ/eLv66yj5z1nG
         Z4gLPjEoz1EWMwzX04mhJTSbwY4Gabwnx4aBjnkVnQ7ix+nk6JrQHslSUSUAk9wT2oDK
         gSgSP2oNKY/IfcLW7spyi+6USNvQ8Zl1Tmo87akM9JNaFUseaqbtxhH/LUAm4goUQszQ
         7kjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779942572; x=1780547372; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TzdROHO5b7Xc+7yDI5d2KwPwgdS008IMiT5jPN0ctv4=;
        b=juIY0feuk8c66SO4NMp+kVxpXM6JyWgXZaj+V5blA9lEumJkizPfEygkj+9JUz5sBk
         gLpKf+KohyjWpoxjLwbcH4yQb52Cmxoyn9h6YT0hmdJXmF574MJdPiApgqBYFrgHypN5
         +40VghPGQTv6vsraGVGBgoxHBoOiptBEH9Sjavr4iI8djasXcT2GJDzZWB8nLv7fgpgm
         RXII8yQsFyaTpsJo3RfuqN1l8x65vArsCXwCpw+LNucrV/kv8CZo2kbfauG0u40LBebD
         fIzTb+h5oodWh+iPCf4O5Ppx49GHc6nmH/xHmEWbAfHHkWef7SrkldF1+VhqDpNXikQL
         viGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779942572; x=1780547372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TzdROHO5b7Xc+7yDI5d2KwPwgdS008IMiT5jPN0ctv4=;
        b=F06inKLSd2BkC8kBVSRr7kBf5h+SP8QQBd1DQNsv/8gdkhfI3k1ifcWaelFw/SDmKW
         lSyFUOuaO0teC9XczT9YeUKn9BDDiria84TWwow6zkpO6QPq5GK+/jbqUwU+2iK400Ol
         chwgkab39GbOV8H4smJW6R3QkpnuYy0GStOvT2u6SgssTNJG/FNDZc6IL13qcMN/tCmc
         t1dJYb6R6/KCf2Bwpr1z5aztmfLImkTQhjf91YJZ2fNdih6LR5olxjvclQeIKo1RRCI6
         4fWdHpOP08CImCmAbVVB5G9nQZ8TgiAmACf60YQP87PIrdNja+lwXdg3OqRcnI497Sxu
         KZrA==
X-Forwarded-Encrypted: i=1; AFNElJ884+Yln+q9ySJDk7DX+BVGRtsX3DzaqSDRjfVAccSm7Hi9Y9qnco1Kv+ybvYRqkQvfvKYUKBSoxA==@kvack.org
X-Gm-Message-State: AOJu0YzPfC4rLYmir179rtzJf6vqbHVIfQNFQQRC4GFsesjWraDvVGHP
	ZosUkE6s6DBiwe/Wzu8mbI+vgOBRjHYY4Yw4PsTkJoCf1mKHIClwYlVgmegZSLxUrtONlWTR5xf
	YGDqgVpAaBYVvDM6980Y9dPob3GXGko3mMEjCLXG+
X-Gm-Gg: Acq92OFc/HBJwvD5rgXFaofuP5rYquUQ4UitJr1hDyudDFnl9Ozuh3GvpHukmSkd3ZX
	EtgHbRoGbM9auM6Zsuk9A2tOSeXgCDGlmYIC/aH4nX6al27PxDvkUw2lcNosleG4JmJxPSmFWx7
	6sp85VYpZ8BLIBWR+FzFOq9uJj2IiQBQbW79goX3cxEfeRHKKqGzyD3q/9blYAWPMoQIwhIui3U
	ywPxrdSe36jwpcsFxTPJDnM5Xgae9wHJcaK+S1lcF3YnRPpvqsPN7+8K9t6OsRhjOIUwRzdS+iW
	yCYqnBS24Dgjy70pKnu0bAVXt1el25S3dsyx+BKxwzFq+Zrwk+Q=
X-Received: by 2002:a05:600c:4793:b0:48a:5d55:c194 with SMTP id
 5b1f17b1804b1-49093b0717bmr48645e9.7.1779942572019; Wed, 27 May 2026 21:29:32
 -0700 (PDT)
MIME-Version: 1.0
References: <20260202194125.2191216-1-jiaqiyan@google.com> <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
 <ahXFPh-a_Zt1Q_r_@lucifer> <ahXVuBoNUeEvLRrb@localhost.localdomain>
 <CACw3F51tWMjcCX-xkfUEKb+nUo+O_Q_gpAi+UhiBL+8i+T8MQg@mail.gmail.com> <ahaNtdwdLvHxFCg4@lucifer>
In-Reply-To: <ahaNtdwdLvHxFCg4@lucifer>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 27 May 2026 21:29:19 -0700
X-Gm-Features: AVHnY4KDlPlm14G43-m-c2HQ_7TvViHAjeEdScdRnJArQw38dPlPhU-7EUksJJE
Message-ID: <CACw3F51nnzwZ3cYqBXU33+DfiAfDd1r3BoH_7DD55OD-4mxH=A@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, linmiaohe@huawei.com, hannes@cmpxchg.org, 
	jackmanb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7966180002
X-Stat-Signature: huaw8439c95pegxb9tb43jed1kss1qez
X-HE-Tag: 1779942573-660444
X-HE-Meta: U2FsdGVkX1/Ksd8wDUpXXD97KSluiAo8WGCuTWM+YG4jCsw5PNxqwvIswqFWAEfbMNjgQ86+Bmta7jCflttQ/2iaR/N+IWLd36JvJSIVySVj22EdOuuP1xF21pO2VAMmRo087R6mpLDg9M2WG3P2a7g4D1txOit5oWu+Dbo/tyXFhw1cYaClWZinsnrmht6gYiSpGABu9I+hVmDD9m/IFJj84uLX3eIOFUNKKz3+YFYFx/gRnb6IEb9E6mDdOsE3B524WDpbXnM9r7gVPVjvxDgfkqiocELs22gl0JyOdSoGe/XWGfmroZZePFjXWsMH5sfugRWSwwpQYblLGqxn2M1y1h2LIgH+hBxR5xUDgePFJZDfM9URgjJF1VkkrrKVHuil9nX6BNWFVXjcItdrce0p0OJ23gsJ85xOOp9cfMjSDYibOmU0ti6acIWCvQHOfAQlx6OR1SuBRlUR8Aorp1W2DuQRR3rm+XaCvocjT3fZ73tzfbOZLwpEdPSVjrkoSAbeqQOIg+0XPsJUdRmKpd4u/JKd0yROKtBwAMb3n8848tkzy+QCVkCtuKyOqoYeXGJHPyt9NWWRjytx96lyn/SLOdwQ4g1w2eBk+RN+tCA2siK7nNWM0rjwA6OAtVxVeCL9OkZRbWxVyhmSw9KSgyUk3T8M3YUfqw0RngtPw2p6PovemLr5GRvxSoaQ61iDFzjvPi0iErpLMJe0/Nt9PMbzjtXUbh/0PrRk05gfT2A/bHC/Kkf3lpyQgEzFE7N2P3xbZhmgyJsnZH4c9jYtytw8oeLjOfeJ5TKDPHGflCttPXF5Wcic/cLJMfXgMWdvX4IUT+P2KmWJrS3JymZjX0vzIQJohYfIBTCjLAZCkmbJi00Vfjyo7nr3iRffwnZ79SAYWXM2ISWmLuW1D91NvNJ4HHKx2S09MFh8jZIb46zjBk3u9JybEcUJkFemAeEK2NGb3tbCKVCN38ClIgb
 wjzwTxgP
 10XHUDUWm/KtmWp0HegdPJPZWkzuy0O1BD/sZ2RlnnjJBxNKuOUXm7j/iQaZPP3vV58MRImue6rd1r+H4EFV5XxVMW+xCNmc2gnAtXUJXRRvLBbqfKxvIedkNZhdbYO3bOXTOVEAXkdC5e6LXhUoYhxzEal0yawuGvaA0QO6hr4lLBIYU7jRN8awH7BYhjIHPaw/aPXQgBCdDM587qJ3AhqkDJAoP1pZOq/GTesKaVvl6yP62jTj2hbe7fWEBHejS9cu2sdCgTQrIiIrpHLZahRsklDoKZ6YWGAA5uIADqw89QPjnZp+pCkY3Y/ixnK49cCcuAROAB3Eg8D0e3Mfl+3+V0UF4eL7Swaa1+DA/3+OSAqTn2ujUc35ZSR9w05R30HMfSPe1hSIZKShQ6T5nVjxYcFfEwYMmxthZp1ob1Y9OtdRSUYIVIdFP1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:36=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Tue, May 26, 2026 at 10:00:06PM -0700, Jiaqi Yan wrote:
> > Thanks Lorenzo and Oscar.
> >
> > On Tue, May 26, 2026 at 10:17=E2=80=AFAM Oscar Salvador (SUSE)
> > <osalvador@kernel.org> wrote:
> > >
> > > On Tue, May 26, 2026 at 05:09:28PM +0100, Lorenzo Stoakes wrote:
> > > > On Mon, Feb 23, 2026 at 03:17:57PM -0800, Jiaqi Yan wrote:
> > > > > Hi Vlastimil,
> > > > >
> > > > > Could you and other page_alloc.c reviewers share your thoughts on=
 this
> > > > > patchset? Thanks!
> > > >
> > > > Hi Jiaqi,
> > > >
> > > > I guess you are blocked on review here, did you intend to return to=
 this?
> >
> > Yes, as long as this patchset is useful to the community.
>
> Yes it is, thanks!
>
> >
> > > >
> > > > I'd suggest attempted a respin to get some movement here as clearly=
 this slipped
> > > > through the gaps last cycle.
> > >
> > > This fell off my radar, I plan to have a look this week/early next we=
ek.
>
> Thanks Oscar!
>
> > >
> > >
> >
> > By "respin" do you mean I should re-work the patches on top of the
> > latest akpm/mm-stable or linus/master, for whatever the changes in
> > mm/page_alloc.c and mm/memory-failure.c since Feb?
>
> Rebase on to mm-unstable would be easiest, we're late in the cycle now (r=
c5) so
> this will probably have to wait for next cycle, but doing this early make=
s
> reviewing easier :)
>
> You can either do a v4 RESEND or it may be simplier to just send a v5 whe=
re the
> latest version is just the rebase to avoid confusion.

Ack. I am preparing v5 on top of mm-unstable.

Interestingly, I notice [1] introduced free_prepared_contig_range()
which does almost exactly what free_contiguous_pages() in my patch 1/3
does. I will try to re-use free_prepared_contig_range() during the
rebase.

[1] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.co=
m

>
> >
> > > --
> > > Oscar Salvador
> > > SUSE Labs
>
> Cheers, Lorenzo

