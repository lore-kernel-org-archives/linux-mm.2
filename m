Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FC7CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54998E0025; Mon, 17 Nov 2025 12:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C458E0002; Mon, 17 Nov 2025 12:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42FA8E0025; Mon, 17 Nov 2025 12:53:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F55D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:53:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 743EE12DA68
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:53:07 +0000 (UTC)
X-FDA: 84120845214.27.4F33515
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id B519F180014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:53:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YI9F/uNB";
	spf=pass (imf16.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuSRdJI0gD0Qx6VdtPHmfYCbpVcQYOajCZUas9sNOE0=;
	b=sthw9Kuo5ki1NbHZ5ou9vuT21FbcQta0PEXklAOLbN8C3kTlE8VBBVhonU0CCt4Mh/5zxj
	JVkJeGW+gbt1bS2wcFBC63vZqXHHhGr2yejGyDeMRuTrEtmHN3YZIl7DQ9SOl7tTE0wN6Q
	UKz6p9cnLSecLr1Q8DcvV8204VRakRg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YI9F/uNB";
	spf=pass (imf16.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401985; a=rsa-sha256;
	cv=none;
	b=FIyD0wh1V/1LybzjIdTvme40miuMY8Tte+5lxntPPdGo7IBE+B4VGsS/AiIYmbmmxAU0ex
	/j//NkeHUec4sobOSut75HRcb9ATAsElkmM325TpZqjAaUJFQZTw6REKGthAcL39xCqCMU
	V/c8KRik6QN6XIm8AGKeHwIZsHzzZMc=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6574de1cda1so768293eaf.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763401984; x=1764006784; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AuSRdJI0gD0Qx6VdtPHmfYCbpVcQYOajCZUas9sNOE0=;
        b=YI9F/uNBXN7bamsFH62s/lRthwRHis/BpzI5YBbR80V/zrTiPf5UecTG30F1stFqMh
         zf9P+FOdHZcPk7jHGh0KBru0XH5mitEK8O3gHAp9271dNNu3n2FlV0lfqzkhyKxi7MXC
         VaLsZoL5bWidDCYrLoCR76Uw90JjwznXfGUSZ79pWDFuyC/OBSxuv5QX/1zTR0K8EviD
         OX0RYDty8kliuoB+0aB5zQRZvu0nzjirLr6X8r1uJQZly+tA/e8i3oVqdDJ092zEVMH+
         nD5SU8nxyNJ9FUYYMGxilnKdUbK0DtY+sa+114RCFjrUlojsz5qMYVLWbew8XWWAqyOK
         q1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401984; x=1764006784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AuSRdJI0gD0Qx6VdtPHmfYCbpVcQYOajCZUas9sNOE0=;
        b=pi7gcQlTZ8bApUUaKRyPuvrBZCmjt/9+Fj5WbQFALj5DeGk26t4kQs9v4oB9eaAA1S
         r64Bj39lIrIOenxp6q+2XkTfLqDgvE0YCRkBHYfXfoel1D/vI+sbBKAz5DBH0bIpbwwu
         u+amRwOMeIxBkXLFsFawrQIW6cHefNFslIkAP0NadDnhsXWO6/dp17Cfxb/JZMFxjV2v
         9oKj8sYw9sr2kvVQz9G0q9cUr6HHKXCG6aWewZ/dW7gcPaL0XtPPoqJEGDXAUMRUnmUk
         /qTkMgEW+vDxghi1GzQWflY4MdfB2CqBzLtWJrrzpNVMWCJjeHZxkiyhnLR8Tb8KheQd
         ungA==
X-Forwarded-Encrypted: i=1; AJvYcCX3BK7L7ldV5LHZFQ576Rv6Vpp7yZeJj1FRqVlr4VatPifjfjUFxbCDSu+VfxIsD2EIR4GPqcwyYA==@kvack.org
X-Gm-Message-State: AOJu0Yx4UjrZigIUSmCE/ONG1Z10Jso2O8JBqSMHoCHM9tIee5hrU6vI
	TpN3TGNo+Az+TGyYHLRM4TLdDdTUDzESAZfcaZPf0OaHIqSbWaB7PSY1Dk43/P+MmE8TmEkYQ6E
	hxZX2ngpmd6HjJUCAK3dk72SJJljavYM=
X-Gm-Gg: ASbGnctiMW6mHdyfuxUi5z4sheSVDK5nYNFJsWEUaNRVsNA0WTUFwMfwMu9KNthyGy2
	6pK8NNvYMg31YOH/kJxp1jq9MmcVlQX/Q6kWmxtkkAfKwB63OjlP5nfn4Wtn90NhxagJWBGzdC7
	li+eM0n7LXqUecdmyEyCrd3ykRFi+RYCpb9nY1YOny00EdJ5tqDxBIWvmofjr9ZS4NIKe8hRncc
	pQ9Hu5OhBE8E83iQ7yA2a3PtZXn9uvHQzQkf7Zu0SGPvwupZSGU+hYqNedLFu8Xo5lwLwJy
X-Google-Smtp-Source: AGHT+IFOhPvuVP97Mx7NPHF1UUaLWb+HBmCuV2cdov1Wg4E7OmDEPyLEfBGqqQQlnJBtR6wLyF5vAa0hwXJ+IzjloQc=
X-Received: by 2002:a05:6870:1951:b0:3e7:f174:ae1d with SMTP id
 586e51a60fabf-3e868ea63cfmr5408435fac.5.1763401984513; Mon, 17 Nov 2025
 09:53:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com> <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Mon, 17 Nov 2025 09:52:52 -0800
X-Gm-Features: AWmQ_bklapVnnz45ORmvR4yt1OrQiai2bKIStrRIIFocxcpx30j3kcA5143cdVg
Message-ID: <CANaxB-yqnMEP3zkoPcY8cHNh66UfHb8PNs9s7judRyJ8JC20pA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: propagate VM_SOFTDIRTY on merge
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B519F180014
X-Stat-Signature: t9pe9rgmcehgwbjc9y1u4sj3kg6e3buf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763401985-182122
X-HE-Meta: U2FsdGVkX18yIiQ05300DqAMMcxQUuymzaLyjjEeZacL/bZcw7BAhUi560JV/7e8IpYTDhC2ZY5oAjm1O+aEdh6vmQIZsWilkSoYb9iVeuhaG3vIzt5mxMGWY6yjkIwNi2Kf027YjFqAJNfIJ9YMogXpS3HR49b7TPhy9akhLg+DbOdRO47kslDPb/6GPWjveiY2k1BcuNzhDDpMXafeLJH/tTuFTFTCYmDCXcR7DY2bXMMTT+hBvZCKnuoAIdDg0lIphPbZeR+ZDh+Op2Zp1Lbbsh2S5VbvANnxrnQCj135a/4mE3XdrSgtEScCeRg1pgklAujWS96XOtwHSo/bTN0P3SgBsSTWIrWxRz4WODnrKRsSdxWzoBKjCsb0ZLtrXCqro1Y7ESAbYDWd19Z0W0DBH/D/kWshxNpncrLzTuSW6Cv0YwMGdK3tpj1v22oSfJWdBSpizW/o2rKH9XnwGSRbTrrBtQMd72xtIowtnZzkXdyuOSJ+wJ//vOsAeaHDLAOwm99XAIOYTa2hTmqmlGqaDQp1JMtMn4isRvgGCrBoso/b7UXwQBRQXqC1Wfj8GPiG5bdNZrjXb8s/B3WS9rH7NgfmJA3ePh3OcWC7tcpn4zUpYe6NTATZENwgHlne/uYpMtDDcLHBfq4IKM+B+ogzER98rxg/u2hiVCLsg+82b6arr1kZmBbwiWDE5OYTCaKkHAScrE1FNU0phmCQfhoc/0Q6Gvl6iRzRxWBw63ssSBwJNk2/FN9Tt5VYAPBuJp5Y04rIVA9viwjrDTsDOODjpD/wVmcebO1PVlQK3Gu6c0AxY3uIUL/imBqHxnYWitMfOvmeOkX25TkiKxlV8/R6ZHMnnvSWZF2HamfwCZ2+lXSHqMEz7cP1sb7NO7aYa8hofALoKi67e2fPIAdbSE0YqekB21l1EqkckoHXa32eGJ9xCeCweZd78vEvyVskIgAhOI888YoQLIvoWir
 H5yayfon
 9+//k41V1SddH1xsUA5H+p2/80842cEomybFZ8NK064NBUsJJMd88pVppGhdsxDzBUWRx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 9:40=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
>
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
>
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes
> of merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
>
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY on=
e
> which solves this issue.
>
> Additionally update VMA userland tests to propagate changes.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Acked-by: Andrey Vagin <avagin@gmail.com>

Thanks,
Andrei

