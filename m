Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE39C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 22:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAD76B009D; Tue,  7 Jul 2026 18:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AD96B009E; Tue,  7 Jul 2026 18:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A2F6B009F; Tue,  7 Jul 2026 18:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE2B26B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:45:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 486BE1205D7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:45:03 +0000 (UTC)
X-FDA: 84963462486.20.0A1E704
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DEC1C0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:45:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sfI4JA5x;
	spf=pass (imf10.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783464301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCug1I8b6MFkPMgcf/mWWZNgVLJfCCmW1l4/5r+/VRc=;
	b=cGsVFiUi9KHUhDPbmjZK6bUH51rtut5vy3yCAJptlJolGnYYX5vTAI7qHb8PjbX3merj0E
	pxjsKWgErF4iXWK1Oy0ZPJjbxs2rPCSaxwgZPgjz23xFUwtZAF5GCpUG0S/Av+Cx3dSZyp
	b4i0KcByF5Cqk/bOYOGU3X5MFxH240Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sfI4JA5x;
	spf=pass (imf10.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783464301;
	b=T5WH7WlqAdCklrv9Xylfciavnjvk7y/rUKA27kqIGlfQoSzDWJAqVWVyqSipDX/FJmnCI0
	uj/3603QsvHjoDt4mm61fQlk3Np0Xppk4zIw3ynTqZ53m5fCU62gVhDDXZqo9PgkmEexPL
	0jtwEREIHTJ1z/uH33F1Ye1Xtw9iUYg=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-380cda7f00cso66227a91.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 15:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783464300; x=1784069100; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lCug1I8b6MFkPMgcf/mWWZNgVLJfCCmW1l4/5r+/VRc=;
        b=sfI4JA5xTl5kn20DgwDWP9nBy3CfS/8ctUmoDEaIp4IXiDle9yPFdyzLDb+6oqdrab
         E+8JuBI+z+flEQydGTzeV6IsPssqkOaTTcxZZGYThe6auWAeN+BrLckmSLKDgIBybN+r
         7t/+tKcnzD9VnDDA+4XgFjgdWLQuchobAUuLZg1wUsIRWPisDbucM5hIdIhH/LK7hiJW
         BkauZ+KDJOKIhKBH8fMnY3pU3epJc8eTz76xEhMBjk4DE47EV6yZnR0/jttanapd1jof
         xQQWxKpdj475X54Z2iGJIstRpGoMednfoz+DMbr0o+1J7stR2jZSXp0tRC1lIqZz1W5E
         12Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783464300; x=1784069100;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCug1I8b6MFkPMgcf/mWWZNgVLJfCCmW1l4/5r+/VRc=;
        b=HmNYI3pToWdX+odID93HK8qmE5USg+W5m2fwnqukTiKG+VMA9YuI7/fajxAVv0yLu4
         p+p0In3xs1NNHMx+5zuMU/P+oSqlTpRWi0/UJAM+bIkderhBbAQ4A+ih5Pl9mhrPPO3i
         YvKI+iTt7FKuVk9PTfAdbwwkdExL4LXxA4TIVc982M6Rd2LqYOMGfnv7e5TQHrlaGA54
         iYGSUVPFdW0z1aOglfG9gX+lJJH35smtNXYvbqm7LmlAlKrKzznl/Ko8kz9uUTwduCHu
         bHuR5nrr1slx5xBkiE9mh7QN5Xcor7MHa2YQkUNCq+s4Ru14WXcM9j4xgbqymfVv/qE0
         teDg==
X-Forwarded-Encrypted: i=1; AHgh+RqpNmLAVPdiNOZGOQXYlelGztZx6Am7ev4j8+I7FhAreXOCqXVNKI0KrkiXjl0NGHACRSMGVD2zMA==@kvack.org
X-Gm-Message-State: AOJu0YzIHKr/YDS49K5dI/Sgs8xz2px+0pfkxV/Ol3i4JCPXi6wUcsm8
	FcskxeLyZbSf3Hn+sJK1iApb03jReMXnv/aLmTd18Sez+l46epliZ8WK
X-Gm-Gg: AfdE7cm6L1Atck3xzF2twS6m0aKur8Lxr/QXYL1yQdx/WbI7o3V3lOPzyXti824KS+A
	bjJ4PBhvIWPTjBIMRKW6LcPkAAWZSZjLfqaGdPPYD0+RmskjgvKb0C5yQh3eIQEzJ0ql5vWkLdl
	z9MqnHhEEY6mzdaZZpE5I4zZceoqu+VFksx1I6GqNcMhLJjQ/0Fd7K2wgp1GEYTB31fD6RwpgAQ
	Prr8Lstzs5U2Ik6zIQ2w71ja7G7qiKUiT19nz7mZdOkWZxNkZYr5B6CotAac5WDp0cvW2P18SRk
	sLu/AK4bj6cRa+rsCs22j5Vc0YKsy7L98eZotqGQ2InEp2tL9ohCxDF9b+bvmWbDrkZxA3boF58
	Rg2/IZAtYSAp9xO0wiORu9hFkukI+t+gpRtWidt2iXMjI4MAk9kMSWI8SiugE/ON2F/gDd87nxB
	M+fT4=
X-Received: by 2002:a17:90b:53ce:b0:381:973e:fa08 with SMTP id 98e67ed59e1d1-38756ce1588mr6842488a91.18.1783464300250;
        Tue, 07 Jul 2026 15:45:00 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::3:c1a1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311747f5975sm11695855eec.4.2026.07.07.15.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 15:44:59 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 15:44:58 -0700
Message-Id: <DJSPBVXTF02G.3SKLB9EO89GPT@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Farid Zakaria" <farid.m.zakaria@gmail.com>,
 <david.laight.linux@gmail.com>, <jack@suse.cz>, <jannh@google.com>,
 <kees@kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, <mail@johnericson.me>, <shuah@kernel.org>,
 <viro@zeniv.linux.org.uk>, "Gemini" <assistant@google.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260707-wortreich-kanal-zensor-9386ef4f38f7@brauner>
In-Reply-To: <20260707-wortreich-kanal-zensor-9386ef4f38f7@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DEC1C0002
X-Stat-Signature: tc7rawihz6j67jw9p3igwazn5ybjjtix
X-HE-Tag: 1783464301-774258
X-HE-Meta: U2FsdGVkX19Igk9b4tsZNPwBLlP2ZPc30F5ZdCdF13QbPCUweNbsUhb2ATYe1LSPsRzUw++RcLXVI8joAmtt8QVw9+SmmKqZQf+1VSkq+U8Fof074NlwhdK4jOOuebWG8Z+Diz2bu6Dv1j5nvtWM8EmWcF9howQqWcfXXjb077Gz/MSmsF5w96e28stUCKOTIyWn2fkXVEqCt7JJiMomabvOqVaxR/cNDFhKBO5+WhW2+RJRGkF5Wj9mX1q7eRXIJiCakX0PnHmilUVq3Av3D4LsJcTUejE5Tl643Copu9VgeMN9C/e66D2mStSXuKRr1pYWkXyky/3vqeeul0cDcIPyOUZkmn5MXbxvjGblqO5vgO8WcxWYBP9s4Tak00Ox+JBt2zmizj+iQ/U3Aao2zxpDfGSZlQuVbgLChCI6+4N2fdXea+cHlRYKQyGpDPFGKY29sQz8liGszKVMXA1Zy9I8URht0vuOCJ8EIRQT01xzE0oOsZQiuoQdsDAUe9QaTxjG+k7yuGSIPy+3GydX+wFY3peJHZjWXyIpWkVZPL9rAQkq2vkZsl1pnZYE9NH8aPIbpxRhzQSSKf0ZEhZNdBT1lqOHZ6QEH4dBB7fImax8o+gEBB/EeYNQlQ+4hQHbGHCz0mOPDkG896LfpJhRpoBUn/i5KOCD3qwo10CgrwXXU4NLSjV/S1AuwyUFzDiffIAleM2YFOnJ5R5wHUYT8cYDn4l1SM0fOHBFQGFgvWyk0hwHXMCxWoaOYVUgNsMj+4H6PU7w3P3ftZ1HCPSqDxxid7NO6+xMDDtuqcWSL19Q2oWJIcsjfltrZRVdgBM8YUPb7kYsSHKp8WOGC2t4RYtBd9JrvsViaXkmdZuRkTwVdCsrE9QaiS+P7Em7/vv4XVUvHhEgQWfH7CIUkyLtMH/+yZYQrvHarZs5vyy7GDoBh8/1iU1jYdEDrIW6klgukZkwUhTW5k5djGuEgDH
 LJjataAF
 9mJKtvslWSi+OHdyjb2A2mauYDSEQ68z3Q75B8cBbigRBcUBdQM9OoC9VlU1qvvhxBlqj57r8lrem9u3RmBvWD9hhojzNxz8U4YTdN6kxUcMGQFrqeJP6bUV6cZat4a3TcSYmHt+dpNOm6ijGpdWWBxnvsoJSfyYSyqLoeAj4WOrYn5qLxkuoYu7bDh/eO6WeabEXvN6FplPm5KNyvrXn7aACPtLj+TDXp9Hrn7aoKxVGJjcaGm0eULX/6GPgfTptk1OX6x3LvmvmVNSa5Q4mhL4nwW/7DFVyIaw16AtKxuuXBgizvGkvtIRix6wO10qK1Cj37UT53H3/54NlwPj1YynYs01Ol51E/bDfDO1zW3toPO9ouglhuiKmQQ3TP594+jCl71PUAJS96UZiFLJJhNXTCZwRZr0cz9yYhBVDbKJtbp2zwLQl+jMk+viobrtFBhDlo6srXkZua2oK5bWC03oNDX+wLyDy3Qm8rFvml3BV7dnqXcxq0Tnzmbxu6/Vu7P9ZNRDtcWi2+DQ+uiOU0FGR2Ut/BsZIpiHsJAyKuSHDAzi2bhBA2Ec5RFwDdkeLKK1GQolB0uFuP7rS/G2Bfp2Z8XUgmhb+qRIjxuHsKY7yz2jVlp6Ntsz85o+6+tDGCZZkindwypz43SPtM0e96HIl5zwSchn0DHXg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 12:45 PM PDT, Christian Brauner wrote:
> On 2026-07-07 13:34 +0200, Christian Brauner wrote:
>> On 2026-07-06 09:47:53-07:00, Farid Zakaria wrote:
>> > On Mon, Jul 6, 2026 at 9:01=E2=80=AFAM Christian Brauner <brauner@kern=
el.org> wrote:
>> >=20
>> > > Ignoring the blatant bpf abuse here I think this is quite workable. =
So
>> > > this can be turned into an actual design and patch imho...
>> >=20
>> > Glad to see you think this proposal is in the right direction.
>> > Just for my edification, when you say "balatant bpf abuse", you mean
>> > how it abuses the socket bpf type?
>> > If so, do you have any guidance on a new type or should I just take a
>> > stab at it.
>
> I drafted a POC for you that should be closer to how this should look
> like with the bpf people in Cc. I'll let you lead from now on. I just
> wanted to help you out and illustrate a more viable direction. Might be
> that the bpf people want it done differentely. Let's see.

Cool. I just saw the POC.
(I'm trying out aerc to view the patch series. I will also try b4, I've
never set it up before)
I will rework my qemu demo to use the struct_ops and go through my own
testing to see it work.

That looks very similar to what I was researching with an LLM. I was
just going over the idea of struct_ops bpf (a new concept to me) and
using traditional bpftool load, a new bpf program type and kfuncs.

You put out a surprising amount of polished code -- thank you.
I would have had to lean on an LLM (heavily) and from the patches I've
put up so far they still have quite the gap to cover in terms of polish.

What does "take it from here" mean in practicality?
I will test & validate the changes and just wait for comments.
If there are none and it works....then I guess it's done ;P

