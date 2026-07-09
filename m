Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50651C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 04:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4EE6B0088; Thu,  9 Jul 2026 00:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2557D6B008A; Thu,  9 Jul 2026 00:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B7F6B008C; Thu,  9 Jul 2026 00:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5B9D6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:08:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 357B7140377
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:08:01 +0000 (UTC)
X-FDA: 84967905162.12.A9E4763
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4ACCAC0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:07:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mUmegxcY;
	spf=pass (imf22.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783570079;
	b=qQ5+7/YRvL5EovoRcfdSI1XQOdmGahOWkF7+PEMZPrEVRcyrdCtVTDUQLxpZ4M9GO5U3K/
	Hbr/2ByO/+PRlCdlJvV4MhQP4L+DxMAP0j72jqqoPs2Z/X5xJlP3oVNUpdYrm4E836GFFQ
	n1FIO2j0xv8U8P3O6MOAY6JuaG1a3Ho=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mUmegxcY;
	spf=pass (imf22.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783570079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyZ+lDUPV2qqTCzi6+PUCRvlBqToBMfsYAo+J6mLUsA=;
	b=GBLfyBF3+ZDL7hyljkZ0FLzo70Po+JdJH0MzEDKDKnn2CJJz71bhZpxtPPfCGh5eCWW3H3
	eRyvCAPa5fW/o3nlhj99vq2rHEb+nkKDNfRvm5mfOwjQpq9kXe5V9vsXLNi7NKrkYZGsQG
	UbGCJn6yNEXxiqIfa9jHRcBPMUGtTK4=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cacd69a9c0so17689985ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 21:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783570078; x=1784174878; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HyZ+lDUPV2qqTCzi6+PUCRvlBqToBMfsYAo+J6mLUsA=;
        b=mUmegxcYD1sNj4w0sft0GwrGMQq9EvvBdvuxr86MLMuOGcqjQqF9Q+a/dGbiozjawG
         Oz0/peDDMtQa/GWHdEL07Qs9xRpIGOqKJv9JPsjfdJEUTXyqRxy3P9LDH0oqGaib4D3m
         XGrmeC4lynHfI9eg9kq4HbLBvHfeN+cjolmKjLXWKbWsRXtVUhE8XRdhcftOjcqdUkU9
         ZfYSZQey6icuAsaXvGHWI5Nx6Cx48870i5plaF/qAjAB4a4z+pG6IbJNhNMO+CqzOPAB
         dJLqVi7L+LhC16wCWrmcV8SnG+XQhwZTOBqkWCkK0LT5o+AX/cZ+NJszXGPQUrBF0sfK
         q2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783570078; x=1784174878;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HyZ+lDUPV2qqTCzi6+PUCRvlBqToBMfsYAo+J6mLUsA=;
        b=sLpQSoOvUmdwpaADBVju1jotrSd9bXN3W+pEIlaC5ykeXHNtMAJ9wtgBGpaG5S/Tvo
         4YFbp1VNMpiZkeMUmg43DCbbrlIuyBDkvJJl+KjtYWaamFEnu2D+de/lTKJ0tbj2K/uG
         YRUltev1bFnhvN3jMQZmYxX2GAKWjfBJF+hzwQXUqQFueemQn/gtbJYQlYz7xKTDr6aa
         ppIr5i+8PslVsIYXz2jO8GY98H40mga5x2CiocG0fn+bnzfu56thm5lCmj2I9zYUnn1X
         bSwvR5OmfXsKTqJbhfmmiHm8CzzytT1qgGDmwGhx92q7NpejNvJ5luH4HgfFYqV03Ol9
         bRXw==
X-Forwarded-Encrypted: i=1; AHgh+RoRsEMehaniQDFMzlS8C/eBuQ57wvBYn5ogqruzWn/3ioXVeIrYC0+KcFjx14/53DXZaiFrZ3IxYw==@kvack.org
X-Gm-Message-State: AOJu0Yxsy0//2yB5D529rvJlP3wjU8YeAc17x3T73HI6ezPWg+fqcmfR
	Kzy/pyVLZ1+nexpjl92bhqsEdwu+ofa9G0YS0CvDvesBmn93p4tzr7W3BK56mb35
X-Gm-Gg: AfdE7cnn46MIVsweMvKQXYHNHfHppp0BKphYeIBmjcOgLT0+rhLEK0G5yZuCehnqxm7
	qCBdgpfu+fGnaXrxMMn+zg9uJSOdeB1zIkgSSjVQrx/Cq1GNCysF3blN10Bhm8Rztb6HR88GgVY
	0oIpOkMAsKhFp+go5lpnnYpnwk7TJTUxzO0B3ZyHG/gJfg8SRIesParS82qCzDfra3btXSv9wAj
	kWxzH89YAYBBnTqzwHqXWKJbAhvX8XNxCvpiKld2loQadUf8IpA16WqHS1x430RZT8VpeZaSVni
	8mFWIQRsIyvy+TJxWedxBDDsnxJCN7mD6GE4undqzTll4YalZyf61VrIE0aWbZp+o+iVvbDyQAq
	3zyyWbyV33SjmGcI3L05gQiPV4TYUzn51Bk8eTDvB1IdZNCQuaREEv5XAzB6ncHgYPTBXpRWIMl
	4U3JCOu3TCSgexgA==
X-Received: by 2002:a05:6a21:690:b0:3b3:fc6:622d with SMTP id adf61e73a8af0-3c0bcb7e418mr5738391637.38.1783570077959;
        Wed, 08 Jul 2026 21:07:57 -0700 (PDT)
Received: from localhost ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b65960d88sm22118188c88.6.2026.07.08.21.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 21:07:57 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 21:07:55 -0700
Message-Id: <DJTQTPG7QZSH.1YIDYKL3O985U@gmail.com>
Cc: "Farid Zakaria" <farid.m.zakaria@gmail.com>,
 <david.laight.linux@gmail.com>, <jack@suse.cz>, <jannh@google.com>,
 <kees@kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, <mail@johnericson.me>, <shuah@kernel.org>,
 <viro@zeniv.linux.org.uk>, "Gemini" <assistant@google.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260707-wortreich-kanal-zensor-9386ef4f38f7@brauner>
 <DJSPBVXTF02G.3SKLB9EO89GPT@gmail.com>
 <20260708-welken-dystopie-ertrugen-56a3b5f7ab66@brauner>
 <20260708-kordel-laben-kopfhaar-1c0dd234aae5@brauner>
In-Reply-To: <20260708-kordel-laben-kopfhaar-1c0dd234aae5@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4ACCAC0005
X-Stat-Signature: 7kw59myt16zeud1q75err4y9jrr7abab
X-HE-Tag: 1783570079-203480
X-HE-Meta: U2FsdGVkX1+L4dZz8RrTV3ZSkRjZepgGJMsHdmTYNtBotD3tIWfrnSJvJNYuyRfVNm9D9INvwj4MwfnSCGVbQBrVeJw37CsIbgMhmsATuHSR4hrWvH5PDRlcu/OQPJ5XDT59Os8XQc29o3a1x5aRb1qavg8cvs+YwZZj+zf4wfioexg1d6CxAjN21BMHdl4bo4/rKf0UI2ni0Ph2aZUy9s92wAekebQX4FeosmfYR8livoitSnTGAoyjDd78a2c3fQqwM26R1y3s1rNGDV/wmRNvFuFtq/9shVfPKoo7ICtfyXv+L9tGAX2tiMl0wWY0neNqReaCwMMBSftO2md7FQ2fKJgdV1TLGiEBu+a8oa63cVUM7Amia9GNW51bavn+lF440EBykjkeG2WWFShA8WZ5NGtr5Xv8UCQ+rN19b/mQ2RvgOW4Ko2/nNdmfIIZ/PAq8gDXMj2BBcWtfT7f2LCzAzhmvQUAAIO0DqVm/w//T0KRC9hmg+Q2/Ig7ytxUt6Ru4luz2QL2AbnZpFKp32oPT9l85cSg7JDGKUfXL6fbX4nqcc5zdwjArj3uI+l+v4QurIvOJDQGE6LCAQ6/qikdKeLRd41OlvxDanNYX684enUzVF63+JOZRpLB+mv8lDT3OWxvUXQr3+lHGEaK2MgByJbhoofB1QkRDkyTubfOM5lo3e6ACSe7ub20219us1LaFqMSNV9YfIK+V8MG8UtZcrj2cJ4CO0zrnyf8ZNNX6AEQu5ROmzI/wF3nUNlvGK+hyIk+JuE4xxC5LVXYrCN95E0bDv21AfrKr2YuttXdFcjdB/CIfzaKma9g2xleWHHikfF64xGPnk3c6Pr3jP5YbtEuwxL58/i1C0bFJdC6pt/B9el5VTDxS3SaNxCiM22pdhYp9ZhuYxDDh3AMXfBgFezun0av4EDfDDhhYp2qE228D60BxA6Y7OYkM31nbocXQmcn9F/U1SVJWyWK
 cCkN/l+Z
 SC27o0gg8rsyPhS+24seUq7liUh55cp58FDDBHMQsZhg67Jc6Zg3nmBUFZ/ZGSuCB0yjepoOhBPs9eBLn6z+HU2ooZOG+dLSR2no7z0TzG8sTptT1Z55hfAJgcaASUbsq115R/udT7kU3mzloDO5MbxmKbKog0/FVYxDc3nIlpYlv1xqYi3OpuRTpfn/caf5ooVklGlncioxDar9O7Cnhim0Lz469G5Fm7a8Ur2OaUBSu3EL9Ain9jbRcobzKTgdrjrQft6BbU5q+JaDYfwkKWCUvRQuMPfkglG5rnBjK9hQevur6SMnguXbN+SAa5cCogO9WHxRWupvYC9XOEh4xMzR5hyd57itX2/KbzZT95jPLgchjb0qU+pLAJwQGOBNoPpTM+kJeXGxXgpn4mR4khZV3OsmPec89D5KbgYl0+dRVMft9v7IgQZ5OPDL9N3xn4D7irznk1spTBnQw54q9vghhWTKDRc60zuPUgfaWEfln4MucMLvTGHz9UOPJHDCFtGTj5ljtkkVVXCxGqqHtfx5vAN8uCjhIcX0eT4ean4cRbF9Za2kt7evWrfDgQE+qGBisF6vPez+8VAqAD5rg51xj0F+d2aQumuBpWM2OdGLKNz6+X8BPH5jB2RsegmSL5/qijjFrqdUi2MnAHfhPfRjzLE89SIy20AgDhWktNf4aCVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 8, 2026 at 9:47 AM PDT, Christian Brauner wrote:
> On 2026-07-08 11:14 +0200, Christian Brauner wrote:
>> On 2026-07-07 15:44 -0700, Farid Zakaria wrote:
>> > On Tue Jul 7, 2026 at 12:45 PM PDT, Christian Brauner wrote:
>> > > On 2026-07-07 13:34 +0200, Christian Brauner wrote:
>> > >> On 2026-07-06 09:47:53-07:00, Farid Zakaria wrote:
>> > >> > On Mon, Jul 6, 2026 at 9:01=E2=80=AFAM Christian Brauner <brauner=
@kernel.org> wrote:
>> > >> >=20
>> > >> > > Ignoring the blatant bpf abuse here I think this is quite worka=
ble. So
>> > >> > > this can be turned into an actual design and patch imho...
>> > >> >=20
>> > >> > Glad to see you think this proposal is in the right direction.
>> > >> > Just for my edification, when you say "balatant bpf abuse", you m=
ean
>> > >> > how it abuses the socket bpf type?
>> > >> > If so, do you have any guidance on a new type or should I just ta=
ke a
>> > >> > stab at it.
>> > >
>> > > I drafted a POC for you that should be closer to how this should loo=
k
>> > > like with the bpf people in Cc. I'll let you lead from now on. I jus=
t
>> > > wanted to help you out and illustrate a more viable direction. Might=
 be
>> > > that the bpf people want it done differentely. Let's see.
>> >=20
>> > Cool. I just saw the POC.
>> > (I'm trying out aerc to view the patch series. I will also try b4, I'v=
e
>> > never set it up before)
>> > I will rework my qemu demo to use the struct_ops and go through my own
>> > testing to see it work.
>> >=20
>> > That looks very similar to what I was researching with an LLM. I was
>> > just going over the idea of struct_ops bpf (a new concept to me) and
>> > using traditional bpftool load, a new bpf program type and kfuncs.
>> >=20
>> > You put out a surprising amount of polished code -- thank you.
>>=20
>> I would not call this polished and it also lacks any tests... I've not
>> given the locking much thought and maybe there's easy wins on the table
>> I haven't been considering.
>>=20
>> > I would have had to lean on an LLM (heavily) and from the patches I've
>> > put up so far they still have quite the gap to cover in terms of polis=
h.
>>=20
>> This isn't my first bpf ride in both kernel and userspace.
>>=20
>> > What does "take it from here" mean in practicality?
>>=20
>> Bring it over the finish line so I can merge it into my tree. :)
>> If the bpf people have no comments or worries than we're done. If they
>> want changes I'd appreciate if you could make them and slap you
>> Co-developed-by onto the whole thing as necessary.
>>=20
>> Also, please ensure that this works for all the cases you're
>> considering.
>
> I have another cleanup series for binfmt_misc btw. That code is quite
> old. There might be a few additional series coming out of this work that
> we base the bpf bits on.

Sounds good. I just saw the patch series.
My plan at the least by the weekend is to:
* apply your binfmt_misc cleanup series
  * I will try b4 with aerc. Here  is my config if anyone wants to crib it =
[1].
* apply your POC series for the bpf to validate
* make any changes if necessary or just add selftests if it works as is

[1]: https://github.com/fzakaria/nix-home/blob/aaee67c3a6d035d06a62cb753926=
57563de58f4a/users/fmzakari/aerc.nix=20

