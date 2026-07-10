Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED1CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8F86B009D; Fri, 10 Jul 2026 05:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0976B009E; Fri, 10 Jul 2026 05:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5A56B009F; Fri, 10 Jul 2026 05:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5CB66B009D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 558A01C8997
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:34 +0000 (UTC)
X-FDA: 84972354348.17.975D636
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 642C780002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iVcfloGD;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783676012;
	b=aJ9qhl8q3cHK3SH34blzTey2ucpjXfuDK/Dm544S/BjrAnpYqMVTHHQoOk258qaLlGrKqu
	7wM10+bOFcnWQd87Ao3dnx1AiPXP2P5h/gvK5Zh0BdqiTpMoLclBFnYr+U3YMmM1DUJ4xw
	RbLrq/M6RoyP9d0yQJ51JUFen7GbSj4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iVcfloGD;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOfAMidp8rQWZVqstmTup6Rkr74TOq97Goi620POv9w=;
	b=r7pah4DZyKtoqgquxvtYJ1o283XO9SeOkDAt02SBKy77gfrGhf6watX0I+zF+8rjKb2jEe
	BLedpyLEB581CTPKfRfuFABj129YnA8qC9Iv8NLYsSEQmGQCKdLyqxAhxygnxgg1G2dO/o
	wuaZxqg7B9cEHSroP1j22xAhSFm+9NU=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6a1888969ddso452379eaf.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783676011; cv=none;
        d=google.com; s=arc-20260327;
        b=P1TP7hujTCgE5Hv6ijlZn82AmWqzlqM0V9rEM7n1MnjzymfpWtE/cd/NCTcph3Y6gt
         UlorCtfMr7BnL2ruxAazzY7n3MFw2pR6r9NiYRdcvnlXW+QYqZhVDPqKyscgh9MzoKEQ
         gzPgAkzUbM962caeLOfGrXTURgGESpT2ebuA4KgvY35Y2NmmOJhEFlCS2mUcTZubL8UQ
         owumEYJJNN80zu8+va+Ushd41IXyUke8c/G1Og0FT2SYRplzbxtjaZDpiRsoK4d9IK8t
         pztIksCBv+zdzvQ//3ZQEXXvOUa5aRH2wCQGOYOIYvNRLBX98GUg26iBV7WdqKGBlYih
         Em2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FOfAMidp8rQWZVqstmTup6Rkr74TOq97Goi620POv9w=;
        fh=b1RaG1OhU6ps8+CRWpnf1IUUDdpyoF2qQxpu4VqrIdc=;
        b=CDj2C/5DlbjLfzhcl2rU7e8hNxFdpYfIm31eC4fy169RZYWf5gd8mJLb3Y42ppAQsO
         cc/JYllV32KUYOkf4lEZxQ3nzdckaSMyve2v6P6RK70vCGDB6qk0xpbykT3tLhNYCB8B
         bxRhfqBk3dUtl8wLuq61RCkAFZ/frNAXw8I7+zUVcUS3u4FrHdAcjHRMBNi0+3UCfjo2
         9sP9RXJDq4AEXkrOiSSG898Z0jX/OD7jFs4bjqhrXEAlcHUMEDo79TEeAjO3Rnr9WbZ7
         QaiKOgVik7gex/3tlZiZ9BwfTEy5PGqOd7xdyLi80xE6B1h9Ro3I1y+ZCuiWTKyxwc6n
         UqJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783676011; x=1784280811; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FOfAMidp8rQWZVqstmTup6Rkr74TOq97Goi620POv9w=;
        b=iVcfloGDPDjwb97MncGBi4IoOdtYoKA9SQTkpsT7uhC++x4EfeRDsZ9128WVwiuh15
         93AJRx+z4NlPyIWZ7p4zj82BOaNDzCveKx1PTVQa4PTfD7CXGMD9JX1Zbb+ywhExsSDb
         JU6W69ipqdkkg0KEqyP+0ioXaEo5ST8rowKBoLNPDyeVbx8eaWrDLdt70D4rjfTjGkiy
         mPRX9kBqohjWIrMACXeK2E/PhXn31jviWigPBbjtCu2Bqqp1A1cBfwXm1KZp0g4LuV7M
         wmUK+dORwEDsjRtkU75ZCRHuTZwKWZ32go9CUeWxmP8PXHRGnLmo/0R/dOJpuczyoLM8
         aOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783676011; x=1784280811;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FOfAMidp8rQWZVqstmTup6Rkr74TOq97Goi620POv9w=;
        b=lVgNQd6wYNJ7v66VQj0281/e98JBimFzEuT7auplgxXkbhhYzm0Q9n7SbUVpxoLUxT
         8XzhpA/KoC968ghcVokYNK4k5ot1bh3d5p2B/pzZqsLy81niy3iyRGDCLm2dn3JKsbAy
         efw4a3ukuJQFviU+TXpNdIuEG2ymycFoRD3Mqsqu3B20nAAMNE1HWKfYhNS9otPqbL/e
         aeXVtwYiHTT9ll7iRdHIN0weYhxwNbQQTwusitVlz7sDmirhzXBvCmUblv1FPHW1QtuN
         o4jgColaW/TZliH5X4SSCohaWS2uOrd7S+dbjqwaCR+IeLyOLM1THvSFsa8HoBWZJOr0
         nd1w==
X-Forwarded-Encrypted: i=1; AFNElJ8TtTn+KkPfP+CJWarpv85QD79twbOEIr/UQozOsbf9zMcjrb5GdVpfj2renOhA5wy1KEt9c8/qeA==@kvack.org
X-Gm-Message-State: AOJu0Yz2V4wKKk58ZlmRYJi0WoZZS9kcKn1PwEMI2CXmKJLo1dVCKv5+
	i6u1CmgRsnBbIf4CqiFPaAXyNGxYijUoZe+Q7wd9V1kmSJo4FWyGEdT9o/m8RgSW2uRXZBEaqWk
	5Y8BY7bJV19qtAcroJFTL5aexzbDFbp8=
X-Gm-Gg: AfdE7cmvyU+byWCiraZerEUzll3SX7TZUjodEaujU2Eas4cZBBJk4PgsPpdON/acZEv
	myowMODNl87y8zkst5Jfowt4Uuup58Dk8JwZdqkPYnei6Ci9RgsqFXfI1viIvOTxKbsSzctD4rV
	PAA0sqeJCSJqYeuO+02N1/ABharB+ZHe3kjCtXou+U5/hCghqF9mb4ukuyT8SgwjbD/Wed7nCwc
	3UIK8pQaob4cyPmozmKagQFtoTGn5T+RBoQzSp6XCj2RTWchSdgvINEPAwUvGCq6F8fXat6hxXg
	RnkXR5wa5AKcYGW8B+aR5lxP4VO3ejN/1mtD/w==
X-Received: by 2002:a05:6820:a09:b0:6a3:129b:e617 with SMTP id
 006d021491bc7-6a36dad9b1fmr6981190eaf.71.1783676011361; Fri, 10 Jul 2026
 02:33:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260706203128.162335-1-devnexen@gmail.com> <ak0YI9KjSstnj9rJ@lucifer>
 <CA+XhMqzvFtLq1OT-qh207aJhSf+okdE8o8Joe8e_KBvdCjcQfQ@mail.gmail.com> <alC3HqLVTBA92Prx@lucifer>
In-Reply-To: <alC3HqLVTBA92Prx@lucifer>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 10 Jul 2026 10:33:19 +0100
X-Gm-Features: AUfX_mztOU5_jS5IjGzUbvmTi3ipFisydF61T_Ppm1lypDXePa4kecWsqywAZ5E
Message-ID: <CA+XhMqzvW=Ar__NFVCLEcJYUnfmnRhTEtAV_iT62U45B7tAR6A@mail.gmail.com>
Subject: Re: [PATCH v8] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dev Jain <dev.jain@arm.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 642C780002
X-Stat-Signature: 8p8z8zcj7sw33nk7r5p5y1sy6i798shs
X-HE-Tag: 1783676012-750581
X-HE-Meta: U2FsdGVkX1/ghOP50kaE7HA06J1RN6j/LCdOnrX/a9MhoO1YoguKcf2WxewWvvxPw8/RwOvxsOdPCkKpSau0Xbl6pzf3Nkr0SwpsC9JfSBznJpkDNvncV/8wA4jELT4ir/quG580ojCJMyt0Z7L+5ctES2iSBM7LSRiQsNKuM9XS+h+ZQRGHxYdX9mGVu51ZQI1sGOEWf7R5ZGQB2qB80zOxtKKHSTEaiLWFz+tNyOUHD7O+jmi/xQV5dutQOOCQjOjF4PzfumMJFcOKGhotCwe4miCzTKmPQGTsKsJL60YFRAgdFF0SiZ3QLUEmtTzfivau5effXUQO99AegQ6dRd+gB1jmOT+1oMnPz5Kd4U2dU9Fy9YJ9wUr2+mYnA/1aHAkEQBwymkAyGLsU6YXx/PYeC84D3oHKkDySY3hFb1Mop8hP4uhG1mDvNTk00yvfHqiuX5oly5Fp/iek/rzI6BZBH0FSYagh+fwzJ+UlNxP9blZ8GhnIzAm+PxoEyNGrwVdfhdK8zGZKTkkAceQCMHeDjmqgDQ4tSrAxZw+4czro+mJaR4nMf2kVAzrYKCjhe53N5QnvwXJD0qrGfnfGUqeCb7VaGZRq2UhySFj6Qb9u/X1VnOFrpttCJTl/kNCnNmOcobhKm8y+7KotBygF1ad3pONueYCmBiJP5rnA6nETEKHAuPwxtmsxik5Enel3F1Bd3niNR6OgpOA6A0FcPwy5GmAZPShPoxG1om6KHY/yshf93/73MyNl3A9rYQ8Db8hicWIMITdt0xy2A3Jrkp6/mSXbDa7hIDmgz8qhWDvsLaKtSLZ/x40wBQqR8W6MhLJhjVsJFvVrRzpvtjCwO+Wk5ry4NohUyyYtTVL/OY7m9ZoVmciKbo7Zvvka5pTN/NsIxP2s4LaFggyduczQvgF92N6BKcQFK/bEUeiGtevAbxDspqqXkkxVZyIAe0SXuq/foUDDTANKYARBXDo
 LHHtgYWX
 KzPSmcC5C8JQtvsSEH57/Aj6tM5zJS6ecnXmoYcdZpzKwoBaX7/0UD7JWOo7mfXDL2nvpcsa3ZySL4DXbRdqE2B4ZDJLMUJXFrU/AvNRaqRdkrQHWr/qrpkL4ENLn5PgWNLkfL9jvJJq1kagffvqjjbDVCXsciDFq3YGtO96uuLLDC9DwJV/l38sQuZ8QormEffxj2wFaflLo+Fn4w3hZ4reB7HnbEKuObPoJQc7JzulnPPOvuq7TmZ0bKIFFGZ4lZcwmQBpljTvr9qEw2k69GHGrOzXaRy4FSknqoTn0agiYYtEimwNa6cCi+KOSmQbTE0gRfM3ASanXCgb0j6njBWJnb+7vS54DvEz670Fc4IMUJ9IrZLbDQHwZHNQGY8NN5HiCiayXBDnAH2iIlNLGCa7y1qa1SgieQf507O1ic07fzS5gvd/b+tsuhQ+O0pIb4KqDD/YwwXDu8yw5ZYjIduRqPzjsMDlXntDUvXUaG7xqkQIkiY9h31NjYw4xQdK2CZiHGE+fb1cIzEERz+zrad/nr83DJ47kLDSpIJHuvgZQ+d0Swc9+pc9xng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Fri, 10 Jul 2026 at 10:13, Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> On Tue, Jul 07, 2026 at 06:08:49PM +0100, David CARLIER wrote:
> > Sure thing :)
> >
> > On Tue, 7 Jul 2026 at 16:19, Lorenzo Stoakes <ljs@kernel.org> wrote:
> > >
> > > Hi David C,
> > >
> > > This has been through a lot of revisions so I think for the sake of expediency
> > > the best solution here is for me to grab this and fiddle with it a bit then post
> > > it out myself.
> > >
> > > TO BE VERY CLEAR - I will keep your authorship and attribution :), and simply
> > > stick my name on a Co-developed-by tag.
> > >
> > > So this will remain your patch.
>
> Apologies, but the approach I'm taking is very significantly different so it
> would be problematic in terms of patch provenance to do this :(
>
> I will make sure to credit you directly in the commit message so there is proper
> attribution, this patch and follow up stuff has grown a lot (been working on it
> all of yesterday afternoon/evening + this morning) and need to ensure the stable
> stuff is backported etc.
>
> Thanks for your contributions here, very much appreciated, and sorry to have
> messed you about on this!
>
> Cheers, Lorenzo

No worries I understand.

Cheers !

