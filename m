Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2949FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34FA6B0005; Fri, 24 Apr 2026 17:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEE66B008A; Fri, 24 Apr 2026 17:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86976B008C; Fri, 24 Apr 2026 17:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89DD76B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:55:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B42F1B595D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:55:32 +0000 (UTC)
X-FDA: 84694806504.21.5A8659C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B5A540003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:55:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LIpcejEV;
	spf=pass (imf11.hostedemail.com: domain of avagin@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777067730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wV3WwlEXBochrsy1CA45CmB9c2B1ZTUDcYL4AxMb+u8=;
	b=3/VEykgP0yCPHDob4cm50QTuIz3PjHR+x4r1QJvN0JjGxdaY9uvMM4kqpMpFf/unFl6hF6
	TrwMfZ21zQD/RicBCkMMXkt+ZD/0d1MCpdpRV2xlAXzHd4bxz7FCrd0miTMYaaiuasHtjD
	ZX1jp+XhjiTfTbMGLrWCPYDJwBTuH9k=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LIpcejEV;
	spf=pass (imf11.hostedemail.com: domain of avagin@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777067730; a=rsa-sha256;
	cv=pass;
	b=Cc3RtWBBwsDvFfc9VxB7eF1Brg28CW0UNKFSv4qIIHHrrQ+C/N3WEUzHZlL5/cmuGiYf3v
	V+t/NWGI9MU2VhSq7JZWdF4+Tg4g/FRx92ZCSWIygPUMViaDXmG55/GmPGvyzR02dJ2lPK
	1v2uzSOMTMaBps96BN9JI+QTE50YXoU=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c76d797b180so5643227a12.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777067729; cv=none;
        d=google.com; s=arc-20240605;
        b=Z+7OwIyV1N2wXEJp5mfyFFyr0DXcvY588yytAtIqz5B1klVYqS6maa91fryh3yOIAx
         CT3DD1ChA4tt0zKFY4XO9voEkduX1QAgbGEFUOVFDDkbmRRi6tLQtpodFN7qQLEWc8Wh
         GdmMfP9FoWW5ebP8CEGZ+frGjn6mXlLyaMnqwMfGmEabPk/uE5RWd8JNJURZeaaNAGsL
         hwUyi5FIe21etx38ddRf9qiIBpsVra+5M5NJsBmATgIcCHc8xbv1OiAll+zv9xui/wHc
         TCxCmTtv4Yl+vXQ5JTVvrAluI/vCJT8KFSMDfxuI8GGSj337W4jGD0T0AmV0ydB0PBwZ
         eY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wV3WwlEXBochrsy1CA45CmB9c2B1ZTUDcYL4AxMb+u8=;
        fh=7CXvD6QROJKfSWkFxNFRQ7VUrGmczXeC681iham66YI=;
        b=ZBoXtsnw64MObqlmALu63QhbF6B5qTvrwzjqPKJo61OHlqwMASXBeuNgWSAhtF8rmx
         w+6tCW3RUTfPSmWeyT55xyBcIcThcAERRrS9bz9TLWqmswMCB1pEu2ovM8DEZJ4zjuPs
         bOnfU45gi6Dgc82Wv9ByigkVMI0dHeIlMVxoxHJHkUY0f2H0lg5xoVyc8st6wkHCj5ju
         MoQKaeBJy1uT5YDQ+WZFDCNB6ejRrPPKeWqp1z/Mglv/ZWb6lEkR+p9dkQl+mabjZhWW
         hbcywkW/odfwmwWfndMeXd4zSrxYfXsEAXZbvTCQg7IF/PJhuDKkLTOUcdXmfor29wYO
         6NdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777067729; x=1777672529; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wV3WwlEXBochrsy1CA45CmB9c2B1ZTUDcYL4AxMb+u8=;
        b=LIpcejEVYAm214lKiWbVgP4dWKFIOs2GrKJY7koaJKzSB6NZSnJKSgN+K6ovlKbZWq
         MCS+Ms4J5d43OPRWBBJwlWB+GrcoX6E0Od7l83myRO07gpAZaZzxsU+xfPFr3hKPZYpc
         vZ2rIAvc0PI5qxcYdkxpAy9PeU5dc79c3puAzjbM+/3kKVzgiyPYLWTmTEwh4zJ7PT6x
         KKVrGIgah8tycCb72y8040/uL9Qh6QZ/s0hoYfVS1fZmHgbwTZF3jvy8rAjA5mfLK13g
         U4jlZF8QO7tgi0FqrtOSDE7l5kRkVK0TvoTS1itaJ63H2y7X4XzPnl810uCM5aU4sOqy
         XTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067729; x=1777672529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wV3WwlEXBochrsy1CA45CmB9c2B1ZTUDcYL4AxMb+u8=;
        b=N/DAwdRzKe8P9w1TztqARm1WApa1ToDXnqMQvfZv8kbTwpxtr2o4uemF2QWEHhDFhY
         CXPctBtwK/LExG0NLR2QpiuB7GBCFXI17MVwob9Xd1Ac5XdO0Uh80kp3iGtJCfivWMA1
         Gm2WACMDGJcxgswmNzFdbMPULIWCLu80NhwDpkCdK4Z3x1XMJGpALqK4Q/YsVEiEv1xC
         uYMUlqqlxAPNegu47QgNtjJmO0K6S9w9OjSZP1icH/oYFJwkGlmsrXuto2te11zMv/rH
         /CUC1BtTwBf74JGmJH8A+i8zg3dkr/hnUp5tOy8kPpPuyz6S9WCI/ZsEM+UwU9xxt20g
         +t9Q==
X-Forwarded-Encrypted: i=1; AFNElJ9GcdjMOtS8HQw4x4aSnNNCOBCgKcBAcl89H19zfYtdF3fWydQhYm3C5VdivjoyAXCxyWnkMtfeOA==@kvack.org
X-Gm-Message-State: AOJu0YzFY9Ng2B+M61wb9p73JLIriIauAqoormwlvxy4sLjLtrlz1+je
	RW35DlELONiT7NmvSOCis9v8mzc2aJZKpIdSc+qzMi+U2EDBPuF4j/OD51E5+wAiDkcX5wFVX8I
	Kltw4gtOhsWNPmTW6neeATFKxfxp+Ad0=
X-Gm-Gg: AeBDievsswJajT35+BC2CB7fZLbomyIObMC0i4i/YGFrn3lT2KaE+DQU8ETUtPOxEZA
	Oq6U053Fr0RSiLYaOImQAERr+rfiMOJwnHUylcwoYoR9v1EegvPNWQ7F3yTQQuCBNi9mzMPWVDo
	bXVIz6I9pEPbjCFlmOHxk55+/j0qQev/t7KtwbO1RBrO2AIbvnSAjyMd6IDrfwh6AQC1HG+5csB
	vcnSwDSc+vH8kjZXjtRFEalmTJnw+pOm3y+DCW1kv7vk0813qRw3Lv1S9gOmD4mLPyDuIyeSvUb
	LsP+G5LDYK+jAD8UoQ==
X-Received: by 2002:a05:6a20:3949:b0:39c:39d1:dbf4 with SMTP id
 adf61e73a8af0-3a08d8ff840mr35917229637.46.1777067728871; Fri, 24 Apr 2026
 14:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260424211315.1072123-1-elaidya225@gmail.com>
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Fri, 24 Apr 2026 14:55:15 -0700
X-Gm-Features: AQROBzDN_E_Xia8560eNxbzM6hD9BoLzIKdVdqtBw9a4JXpxaFyoIMTKdTXXxG4
Message-ID: <CANaxB-y=SD7V7dcBXuAqq8=p2R46SAr1uKZtMACynvk1=Cftqg@mail.gmail.com>
Subject: Re: [PATCH 6.18.y v1 0/9] mm: backport sticky VMA flags and
 soft-dirty fix
To: Ahmed Elaidy <elaidya225@gmail.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B5A540003
X-Stat-Signature: o5df7p3g6anrwbsorgk3wfiwpgspj5fu
X-HE-Tag: 1777067729-340947
X-HE-Meta: U2FsdGVkX1/funaM4Nm7tgAUVE6gwxx/hoXw4zWVVm6NbfXcQhzWzEaffpMAaqlbBNRomhU5VdXommzv2TSC3de6e4LKn596vvZOP2JQULD6Nc+Iacq10/BEvRZ2VR1m4oQ2v3SwKY5FuOZlNZl1eXo/F4/1Nhbbpis3L6UcRp8vf9DlAfBBAI34hcucZzotoyN5GEoaA398MASLtQ4Rlz8w8UvYbYDrE0zytLVPt1cx1Ue7Nuwgg2wFl2j1aUgzpdiDfhzqoNAO1afkASKInP52s6v4I4fC7WYB/cqyDe/iuiAqMoPZoHBe5KJ6VRbNm3zC+vjSa2SFqkl20Ei4LSIrOorAPAzkwr61keikhUkqsgk7j1ZBg8rP/lX+PXZNX4olBuPMnuXR2dU3Su0+TBhfrsK119Kl0oKQIdlIeHFsB3tNUOqt+Hn0CA+PYeeeO2S674nvdUn/rNv7Rmyc8BnMkwUt2BSg+TBvROeOYJXJGqQ04neGNQJ9zwlvrrnG+7DuZ9fxKY5Q/8pKgWdVyQm3/K7sf8cz2WQ/HqBEp3OyVcRA01XYrMzkJN/dWEbwqe7DYFQLCfJjGiS73wxKpiGT8u3HCTfZSnqx91JgMXRimBnhCtqMjRg+m4GpktHy4QN4hmQ5fR74zyuzBMeL73qwbaMQY6v7h2kqjVOIxF6+XMAQLRKYeVyKvz3aUxSDew+g5odx8WiROyh/OEutqkI2JiWcmWXApM38Jvs3MVOzEa9AVsQgcx3y7T9ESA1JP0wXCOyjyVGSK/sqnvJqNMVzbVENkMcntFZLoEtNgjPG36q7raTSwixaMxb2rjQeLeS9/IssSDvZqFhcwHy0VQsKonu4A8hhVIv/9zssLkDFWjQPzPW0AuLQ+Ko3Kim3LmSyjxsC49l+zoWTAM+R0hrYrx52BKnYA1A8rBAKzcDh6B3luVOvCfcan992p4wUOoeFZkpEndEx6nlYT6P
 o9E9eP4I
 f0eETKxeFpWLsmpfzLp+xb5QCf+D8Nw8ss1KHKNkp/C/HHUUkB6OaNOMqsv18gPz5A4gugz1YBtvzeAFUIAYxZnGEQnyv/KCteP6+8PNCMfxvsWeHgu2bfhruol/kJKMwXf9/und985zCBRAq6LTYRezN32KvgnTM08qgHWjgTDyqPFqd5V0p9H829aPIRYJ18QGyHl5kDmlxd+AEwvD8y4FgnGgGzWBqGTIN8kU9Kl8i/hL/tLFNyMXSPLU3YkVGR99W+6CUmdIL7zNgTfq9wCzIVqYG3r+Pp88k6qrcTUI0PJmd1E5xTATJokrsMW7P6gIMoRVe1HP+wSn9lsd7AijzN91FqwMvDjNSbEAdSfxRRpLvE6jOY5bFCPSHklTzjk+jv1I/kl0lXkfXU7MGIH+sGuN8S3hM4u8zwoUevoEcYAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 2:13=E2=80=AFPM Ahmed Elaidy <elaidya225@gmail.com>=
 wrote:
>
> This series backports the sticky VMA flags infrastructure and the
> VM_SOFTDIRTY-on-merge fix to linux-6.18.y.
>
> Motivation: CRIU incremental dump/restore can hit a missing-parent-pagema=
p
> failure when VM_SOFTDIRTY is lost during VMA merge operations.
>
> Patch 8 is the target fix:
>   mm: propagate VM_SOFTDIRTY on merge

Have you tried fixing only the VM_SOFTDIRTY propagation issue without porti=
ng
the entire series?

I think this fix will be small, reducing the chance of breaking something e=
lse.

Thanks,
Andrei

