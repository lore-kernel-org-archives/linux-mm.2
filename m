Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7B5CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 11:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C824E6B008C; Sun, 11 Oct 2026 07:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BA16B0092; Sun, 11 Oct 2026 07:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7526B0095; Sun, 11 Oct 2026 07:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D48E6B008C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 07:54:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3C041C3FD9
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 11:54:05 +0000 (UTC)
X-FDA: 85310186850.25.DB4E25E
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf01.hostedemail.com (Postfix) with ESMTP id E286840002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 11:54:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=AEH0DjWj;
	spf=pass (imf01.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791719644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tP9Ock7YEMVFTnRWgynRTIWH8Z1OWVvG889g72gXvsY=;
	b=XSwudjP85A2wp8bb+e/E8w6PzYP5v5mVNvKlWhNRhKpJRfsEz/QRk+kLnkUdGucYZiRzk1
	bvnoY15scZ2RQRic2a7hfb1+gKNSeNxAAvDhZZ9OKi3QrCNN340XcsW4Ho5bUq1ekG/ueb
	8F04PD46MVyY+WflSJWxfwk6DAdCMM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791719644;
	b=VcA1kJ1K29fOCJswAhPoPw8IDLwTwV0ByKl12nDTNSB3nZy2pw5RUsccFbHJ+r81aV7EN+
	iRXgo+gf40df9M0FpiktyH/sOh5Gr6aK+J3stjR3KD/UTStTQ/gRyelPsWvo+QKILIuEhq
	tw8Wm+ST+hPurQ0hPwIgnwJ8Au6o0/8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=AEH0DjWj;
	spf=pass (imf01.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tP9Ock7YEMVFTnRWgynRTIWH8Z1OWVvG889g72gXvsY=; t=1791719643; x=1792583643; 
	b=AEH0DjWjBF44wzCj2v26PNRzzH7SbtXDjJF5+3HzyG+qDdTPLnXZBUl25ZXv3G/yZFtRC7jXMmP
	voK+HeL2ZIQbn4EozrKzhlWTNNLsgB0zrdBZ1y4FUQCVq40OyGKvtlVEMhKvDBh9SkVtqTU5UQg1L
	hG/rWxxwy5WYhuKxNEzHnG2hxiIe1CznNflCmg6x065vhe0Z8ATNt6OqONgGtyBKSqGpnQhRknTfl
	jODFXVVkhT/HDU3tLE/vuF8zwx39sgHVgpvy6hyhikAHQGCEmpzvacly3T1oVAUYL/Ifwn2X6xj1L
	TKr94uLz0+QQ2n7xzs7oEmX93iQsnv/BokuQ==;
Received: from mail-dl1-f54.google.com ([74.125.82.54])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xFs7v-00A4ar-B3
	for linux-mm@kvack.org;
	Sun, 11 Oct 2026 07:54:03 -0400
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-141395927feso1879524c88.0
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:54:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByVhBHbtJvWVdhmwt2dma7YZyR0AFzdJ/zwvxG22rfO2eyTqjBS0bbjn/eO03lo5o9d9mfq7+tXkA==@kvack.org
X-Gm-Message-State: AFq9FYLGRi0zmgpIrkc6ky/xSFwPCla2LFI4fbfzFtd6viPWrWN3JAjr
	sbMRg/zS0M5PBnuzvMTPYmZiNE3JAeB6V+n1pj9XgP0olkeJeOgyBdqEH0ey94hrzvdwHIh0zmZ
	ZtIYFyQw+BxdDeGiLh8FYpsyjTL73ni8=
X-Received: by 2002:a05:701b:4211:10b0:14a:a6dc:9cd7 with SMTP id
 a92af1059eb24-16a57a16ef2mr9484052c88.2.1791719642208; Sun, 11 Oct 2026
 04:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
 <20261011012245.765558-1-nickolai@csail.mit.edu> <20261010211804.2d8a5f6180c74b08e18ad48a@linux-foundation.org>
In-Reply-To: <20261010211804.2d8a5f6180c74b08e18ad48a@linux-foundation.org>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Sun, 11 Oct 2026 07:53:50 -0400
X-Gmail-Original-Message-ID: <CADGQE7GzpGyTYKznykdN++Swo=Gwx7hGfoWxY-BOqHhx5reJ5g@mail.gmail.com>
X-Gm-Features: AclHuK--8xB7R6c--WfyPx9s5OXlga2T92h3ZOhe-bcyVaefvPE4WrRAKnsZPzg
Message-ID: <CADGQE7GzpGyTYKznykdN++Swo=Gwx7hGfoWxY-BOqHhx5reJ5g@mail.gmail.com>
Subject: Re: [PATCH] lib/plist: add a plist_test case for plist_requeue() on
 the last priority bucket
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Harshbarger <handyhandyman.adam@gmail.com>, I Hsin Cheng <richard120310@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E286840002
X-Rspam-User: 
X-Stat-Signature: hsbeytzgft1htigecqm3cb86ickegc3t
X-HE-Tag: 1791719643-687006
X-HE-Meta: U2FsdGVkX19KFePEWa5DSCO+LZZYCBwhUkIzXjVt+QEtllpcjwgsB3KOSjJ4ql3gOuGWgfzGW3xVZxSrI4GkrxRp8pgiSQVSWzfyfKT/ev/rq//DRP73PD6o8fdh/0JVN61A5SdhKvGEX+0VbqN8du4as83BVaoAkfiAN7N74yKETSBK9jFfvJDZmywi5l6z+hkpa3UOBhFuLYsjrXxBWPov8H4MdRtE+Ddjor8H2eFaHpO1lAyzYWuESq6TINOm7QujLcqE4UJdWrBX/QMQDm3bOgsb9GPtdn+0cb4QNVCsx/TTw/kbET+3/zwwPsGAP18WOE03RcRrKfPTYv7BT77Wijh1sqgOeDN/YcWShEkTsVSCazHXKVr7fdVmWPsylGaQcbyXrg0YLtCyM/W91GDpZ71vFa8QWanezQ9RAze0LN2VptBsBnRBp9LZl1QHRBFdJpv00TVWVPeqeArlKKO0FG/yHqUJbqjSkzHLDf7wGmKFU0AgC0O69KFVDC7nbIerLPQuj3C7qflPij7x6mOYvkKnL7uGe8Amg8xXfAJWeWBwIkK003RKuNuGmkXbjQgzYXbm6wx5pf/g3MpEmu0hbJZP60XO3wsZvOyIykdLTdjcttHq5vFz3k1KTYiPZjo+48tmcCs7PzOuEWdijGPQLrzcHzyKxICBXzmKMa6fdSw52HyJ4Ft3qAXjfnTWdTO6EDgZUSrW4cODMsy2/vJ3lpW8YmrAxlZqGsC4QxVPgRnIjGkSVouYMQ18j8xyJRPJN2d+8f7w8k8u3aUKoaK7Sq0qgs+jtf+v/HIDWUytozL3FJCgr8hoA7lLNtAUkXLJeiVPTwoiCqrVOOuVj7GaMZm2jwTuvigFK793I1Gp6EH02YyWiyy32061RAmV9SH1AQa6I4f92N/lRxPHu4wAPUVMGfmjL+2G3i8v4crdzawVFNciubHOhe5/wPpgzYolPupgyobKj2A21LW
 VqWDZlKA
 wW3u+LZe6hR6/KeLm2X+UQ9HI5XFZwmBfzzTj6qA19C3sD9+B7enRj8kUA7RP5hH73ci/ihiw2r9gTureMT7jRlElPpkDi5uxR56OIpNLJnV8G6OYVecjzwlNWJPeH/71RpgkvyQ12ZbxM+sgF6bGFRUtCRNQjhK/8S+XH6igUYxCNOOMNJsNp9oNVOGmagtComFnIicwKmD0nC5fpb+dXY4bySigfPou0IlOHvr4y30rM+UxbmAxYLj9MF8CAOkN8mt4H2wUkcL3fkkWK0spkEMLIwO+ohkYNKKxlRQH1BVKE5OU/os5nLOWvvPZKZWSRqkKp8WO1DskPOnbvGtVrd0fFowhoA2AVKEgQjM30rMA7b1XlRUy4M9l9T6iK8ipHpTzNzjccB/4NQnIQGtZFOQoq9fburYNpfa2UqOazULLc3q7+YSl+QPW1hS0tD9jEHohGFLCNz6Xn8mDlwktLMmah88unP7Pz8+hdRb2ja7UoKt9M9aUQKEPs7KPss/BUYzv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 11, 2026 at 12:18=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 10 Oct 2026 21:22:33 -0400 Nickolai Zeldovich <nickolai@csail.mit=
.edu> wrote:
> >  Not booted.
>
> err, it should be,  If this is wrong, we crash every kernel at boot.
>
> > +     BUG_ON(plist_last(&test_head) !=3D test_node + 1);
>
> No, let's not add a BUG_ON for some selftest.  Emit a loud warning and
> proceed.  If it triggers, someone will report it.

Fixed, boot-tested, and re-sent as a v2 patch; thanks for the feedback!

Nickolai.

