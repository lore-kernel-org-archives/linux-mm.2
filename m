Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35B9C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44B76B0088; Fri, 28 Aug 2026 21:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F47D6B008A; Fri, 28 Aug 2026 21:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3416B008C; Fri, 28 Aug 2026 21:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 681E06B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:18:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D96161C2026
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:18:51 +0000 (UTC)
X-FDA: 85152547662.27.AAB0D81
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0425540003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:18:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lEAfsbTF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787966330;
	b=JFQlSfduMT4HKMbDTWjiBKDunrCy4vyVWeUa+Pvm2M/LWntxk3q6P/cG0icvcGwHee6uYC
	sCAn3KPG4yL2CJgs0BDUaFGSdOdEamNTPADm2mKNwkTUh0X2ySRsD3IlttecQJKloCZAdm
	/PebmeVzXPyH1vXw1TLpZJgr38A5kz8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lEAfsbTF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787966330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aE45yjI08m8/n9wR8Sbg0vb54KLTLrJEoFaJwFWHo8=;
	b=LNlZAK0EhMLRYukX5uGIYIT3Dk0f9og6k29cKXq2n62iYKpiYBizI4nbTXEQfaMvr+w3aJ
	16n6TnlZt3y1hb5eTUFNFG+9+bo3PSThdmF9J1oBb08ERHRaq3ye82GST+/NcsqFEQvS2K
	eo4+QEAMbsaCJC2gMP4y2O3VHR7FlUY=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2020421077so235653666b.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787966328; cv=none;
        d=google.com; s=arc-20260327;
        b=sZ8MdgeHswYQBPcz4j8BbLgx+9Upf7KzYzW5F/S+JkWwVFc1PVy9YHsQO6cUaxxVLA
         nhLkZUUhFETeMR3RAE3MaC6rxnWrL/9o3pWAi4sUh08WmaMd0fRdxIANVeH88GoXxfjK
         xwc8IVF2/Ng0YCdpDazuk7gLOKQTC5RFc8RyMMPk0Xukm8hYcFDNhG1Ct3JhpdIX88zz
         xN3PzAK/WDmW/cVU+5dRGRoorlwnAicP+LUcVpvfophaLDSmLQlrG9GWJOZyos12+yjY
         NNwuvwrgnX6aiHhLawNE/oLJkGZ8DGR9a3gDb4Nn/cqZ4sg7SoTi3XJ/a8NqssoohJyf
         OEVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3aE45yjI08m8/n9wR8Sbg0vb54KLTLrJEoFaJwFWHo8=;
        fh=ZSNaV7L2dWxZob434lwsAZQwVIfRC7KcpBmY2Uxl5Kk=;
        b=mvNarNL2z96truBkrCOcWXptAcQ/O03MvMkn8kc0e6DOq5Ewyhw+hKJASb+QRmrwms
         hOLt+ekbhfNjiTZ6Z6tGNWHy7KiETyqjzR0qBTMm431B+mFLaEOv402um3val5j3F4Ab
         aZEBOhKpMrLBfQbT1nkFMhXn49ulYgIZT6M+9CgY1jG5//fjzF6wOQhRZEA3X8rBehB2
         N1+W4L9RzKHx0KBy9PpQKa7kgIcJVIpv+Tx4RufNoJ9wj2rEj24OvNVIPHx6fbNlns7L
         K8AhhCxI5HrMBnklEtwxz+FNJ22jk2PQyKohdCiueIAdxQZqKOXkOypZVOYh73NuqxTR
         +Gkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787966328; x=1788571128; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3aE45yjI08m8/n9wR8Sbg0vb54KLTLrJEoFaJwFWHo8=;
        b=lEAfsbTFm9YeYzN/45ESyGD6vIXGL2ufitWD2wwoVGrpCJH3zledZr4bpulg5WokRJ
         bCQYPmm1AVvmeSc81RWMNmSha0hWcpVfBWcbJkM725yjA/VwZxsdt1A7DFZ1VoJBYJlv
         VGAxHtfbWV0tJpnuQx3+EMeWS89q2eWZHlEGIhRTFf90/+CSdPvR/i2DoLNlDiBg2N3X
         iJn2By7vZCjQBJAi+5PKAAUaDeux/K1HjWPYqkkMqcWk/Xvm9rW4QW6jAH8uv3DqiIh4
         T5bNsPty3cXYL4U9YVGfSIjHAiP74b9Wlqp/Wn/DoQF+2KSBWheQ8zBB9p0E0AG63bq8
         BylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787966328; x=1788571128;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aE45yjI08m8/n9wR8Sbg0vb54KLTLrJEoFaJwFWHo8=;
        b=TWNwN9oOdpvz57WXp8Q6ro9XUOLXozxVPSPT6Kj9jlyG0NVe7fbFWXsqWNFbjEyaw8
         SSOVNU9nmQ/EWNhNVIAA8v4cwWZZiWK+MHUd7ySm521YqhGDCoa+WTkW4F2l0YjgBFBl
         TUo6emGqPcXZw+OOsytbdTIY8DE6lh2yZ0mCxtFzOe4OjhDs34KM3sUCoXUyFNju2cor
         OlyW8BwC+ovPAK8Rd61kM+NEdC2HkBf0cA6S2PPpw2jFg5Vm3zvuDLoMFmfNkzKDikKx
         wwcnzzMpJnbtYbWxej7US5gli5ORrIVvVTYRlx4lKcsJ+Zgi0zoZ88scXOkwFRDRey8N
         ZDcg==
X-Forwarded-Encrypted: i=1; AKwUvBynfS/CTIg91BvhMvjWR0HXtGOmTBwLqYMsutkhtU9hReo7fDkzD5KE+yKd2QZr/xtFtVQGnt0Qow==@kvack.org
X-Gm-Message-State: AFuF++kOD4/JggFTnmkPnnULr7nMOQt6OT00uB3za+grTI5qOuWlUdkH
	MB0Ba/fnUuruAehDTDOSP1iaF0a2Llc+n4pvCDNDoNBT7CZ6jkyi1L1WurflTKBWFo6go7SLynm
	iRR5l4139of6gRJYeR9yKLh+6McqwfeET87xk5b2s
X-Gm-Gg: AR+sD13cYEdNXLw7hk3pqt31QurcgQW1bsAvLXWTJY56RVQUthY1SyiROqXt48hZMmv
	UKV5/Gv4lwmktVZwRfBdELphf/qdnv8bFbPXazlYNVnGSEIACuTW5J9Z71l0JCirk5J9PRRCJ7U
	15jnzauFGLL5Iww64qjeCuH+xYHyCu65V3OmOw9ptXVBWv2+x8z8CjQm5bBZy25BD9mrpjKyW1V
	meCJjLc6lA5rhd1k8+KoJ5N9OO05rCHb+6N0GdK5UdVSzexxDT8x+/SMPKWIRwRrwan0cFy1kSv
	IZFWAdwG12Q8+cR7o9VSr/SlA/n6pd+XXfCyXrlHPRoypgt9YjfW1jUb/FswdbWKoA1L+dm97L9
	aPDi4sbTqkIXPhH5PVfVE1Cw81EAaROyFX2WUJSUVNkJaxuKG8btvYXYsRjKcEnIuvrt8MBXQSl
	xdtdsp5L2lY4KI0A==
X-Received: by 2002:a05:6938:a092:10b0:c25:5eeb:4c00 with SMTP id
 a640c23a62f3a-c255eeb5579mr473776566b.7.1787966328124; Fri, 28 Aug 2026
 18:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260828222640.1638457-1-jthoughton@google.com>
 <20260828173302.29778f1bf802a1db932778ad@linux-foundation.org> <CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
In-Reply-To: <CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 28 Aug 2026 18:18:11 -0700
X-Gm-Features: AcwNN1VQFp5gp0oCn-gKtkB6rZ9iIgxR8OPs2LiIa4f6Frg3IYBz6ouINZI-z8o
Message-ID: <CADrL8HV0nUDjr432S8AdTZ_HO8fACrFSCu8cS49vR4XJQa39zg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in
 uffd-minor-registered VMAs
To: Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, 
	zokeefe@google.com, hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 9ii5sbsf9xnrqoii9mamsroj9j8anu7d
X-Rspamd-Queue-Id: 0425540003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787966329-627828
X-HE-Meta: U2FsdGVkX1/JUQuOUg8ciAEN6al5IFsJoxz31tuSOxKGNPDB3sSD5UjTHUttphte2pg8TOJoPZ+wsATbaUjO9HFnL/BRery32IFDgDVNylv0nv8HhHdjzF1ts9FJHfkMkjNz0XL1cAoruDgWB70eykhXHBPvXlIVn2AX+2GzgBGq93O3qu7Hymo9Fyc8S8q9aYZIHrVOobE2lqX/vEhevuy1Lo7jqMmvV4EjGUrmyZi2B4qiZRbR3iROnWuL0Q1tsDfM4NPdZw4GVbWS4CdiJydkLepx9Ex4NUk7g7J/9jU/kEkCDrovKI9DtTIZeOX7lcXwLiJAY6ILuoZkGGy3Plv9VT24yjOjdNi1BTGbgjvB9YickN1Dc35kBKXrUdm+P7ZUBHMAk0xCQmOA6g6nWSFQ93WvwLsqWheKnwbKnj9BoJqTP3Ei/9TdrlKkV2/GHhkaFBc8I5BkYwIHG8W1IKRCQ85nAEqsTRcBynTe6U5bxNs8LsjsiRcrUjFyBJhlv9HgSMqTedlXICxKyEbip9ItsBuOZY3HR0ZpToKwSlNUOkAmgj3gqpTfasW13zHh1s/cE9DVf5EhkWUqGTYchKX/Qw97ZsLFOBb8a8OZ3qg4XvySseugRb2Ns6Q/VrcEyB1kvWq5SmLLLD+GpMA9Xj3p7hB6sPGdzIhw7lmQH212tSxl+MD/UpOqH7NrQ77imGbQiT3s4BQLFod+DCjiz+dVX8g4tsL7sDj1W9HaOWhxia55Qchk5NArwXxAIVJNZN0AoXxOLwX1w5fw98yEH59eSXak66yl3nxaBymfO3KwoLgisQe76X3e6w5xiKytrBeKEF2madQWXa28KR4x/BihSM6MXMyDfoOR3Ui6WrINiVxkqUxQZzlBrVRwbg2d2aY2XQIURHEfzAMuDCANeRuiIImUG9MjwnXbWlJH0cJVy/VwoHqV+3vEr6R/02fTaSo805wyhyullFvfcvq
 pZOBrC/Y
 u0wmiliXNpXyMhWSOSm30dI+MVD1gTVfaHcjK8UTuPBMp2i77cA9/2mbL1ndCn/yWNoc6gWjeZbgDbdCxfvSiw52kj3xFM8uFvuIuKlkx3Q2MFw4Y1Gst5kaoNAiQqteXG17hcACDQGTQ+t1wKZECsvTK2mjIZ4/AJVbMp4eYHHJ/tsL562Gu/I/lhN8tZNnqY0RQPQWF2Jfvs0ygHZgzjJXTKUXL7ahPcajyYvE8exc5J41u5OAVGmGL16e1QAPhw+uhTKbc6I0xrUdt7RKvlAW/pVDVS7N8wix0m8y0hzwMKOZ+cKHh7ONzk1A4GrtSoVG4anyHjm0x4agxnXplrzgvMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 6:09=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Aug 28, 2026 at 5:33=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> > Wondering what Lance tested.  Was he able to reproduce the bug?
>
> I assume he just re-ran my repro, but yeah I'm not sure, heh. Lance,
> what did you test?

Ah, just to be clear, I linked a repro on v1. Here[1] is that repro.
Sorry, slipped my mind to also include it in the notes for this v2.

[1] https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664

