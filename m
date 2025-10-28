Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B41C0CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F968011B; Tue, 28 Oct 2025 01:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1476B800E4; Tue, 28 Oct 2025 01:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083AF8011B; Tue, 28 Oct 2025 01:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED985800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:34:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EEB787951
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:34:09 +0000 (UTC)
X-FDA: 84046407018.03.FD1A117
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6EC3480007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:34:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=U0baE8Ij;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761629647; a=rsa-sha256;
	cv=none;
	b=H3LSLbyJujYi7XDMD8FkkzQ4p5FCJV134Feq7GlAPPVHJ2IFAXezjWPjzqeCMCo9+FSmX+
	wZp4V5xkGC7XHcH7msztrhYdEDzjXqBcikJLYgW5Q/C772V+edYFEXEh0pw1/lFgWW0y40
	8P66hza1/OADWU+b8KK+Tct/29xqhQs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=U0baE8Ij;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761629647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLpGC29sIJuMD8EW6D6+ekLf15xOznYOaep7iLxbnWw=;
	b=7dkukV9jjQdQwhuFZNrglPqtfHwGhAifIBC6EbHSjeuHyM++yIU7LyV8aN6i47J3/YtvSn
	jaXLn7BKGApkY8qY9eG470PVpx4UYHnPmuKZfkkzQ6VWdLA7ASzVxoe/9z6vsJiCxUgisn
	zWJZ/mj43ifSPdgHl8RoGo9EA4DLpNM=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-63c21467e5bso2397285a12.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761629645; x=1762234445; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kLpGC29sIJuMD8EW6D6+ekLf15xOznYOaep7iLxbnWw=;
        b=U0baE8IjODQyyuArmtwOpvvUejtTcYRXZ9IiOAk0xQBfRR5UKnstcfQ3K7HtGHv/FB
         nxPGCCl3j70TfG8Mwxjf95aixCd0EnNvgNl4x24jAiGRHKM3aQnow8sBXMVIaXvC1ZTF
         OWNyydASdsLH3+uUy+5UcbYx4U9yFXi5Og6B8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761629645; x=1762234445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLpGC29sIJuMD8EW6D6+ekLf15xOznYOaep7iLxbnWw=;
        b=bQdkPBTWXZaCv2r0cplsfidBCDONlcQpvlYXu6vhnLxvPTwZMcY9pZZKhwGGWLy+t9
         ts+KRLMbqw5AK7K5KTD7IICFheH0uuIAqRzvdBVAPc4LIHEP0vrAzgh++s/crgjLUzIp
         LOVOsH0B1pNqwvKIuBKS+5u/NKFClCEfxojh+ktR2AQ2TJ6WZfxO4PkEfG9nCpXQjy8T
         ateSuGbZAVTDvmgo04JFNjCmAzVShZ3E19HSYFCwiAQWI7Ro2yRIPimcOV1qTB5tDKQs
         itvbmOiXInXZyNxfEu9Aqskb9jif5FF4vtDP6M9GbvMsV4ldp3PDZaTCjuRxOI1T0Y13
         FNdw==
X-Forwarded-Encrypted: i=1; AJvYcCUVxgT8Pb3j3vSt1ylBNlrOGhl1Dzg8Pb+qgCFKfN4s4i5TjJWikYlSoqp/RTQCkXh8pP49aEUnBQ==@kvack.org
X-Gm-Message-State: AOJu0YwptAf6skwGDJX6rt8EYcoz+DAXQVXjj1c+IupezEeUxRf2s1gu
	qnXxfVAI/bwHn9K3Tkd7lDV/QKvL1VPGml74+N7z/OTbuKrAeqs+E+6azMIj5B9TxJjT9lc2VMj
	4XEN2wCZJMA==
X-Gm-Gg: ASbGncsY5JdQfpp+/V083h+sxW1hhepan+fOUfeoD7PXCqEVKS1kKW39p52MRbhhRsK
	Qs81R/x/ckxxj+TjqySycpprD+t3cWByN1c896syWnPuKyxPHgD7X4uwXn7ZPKdf1mGp6V4Q8rb
	3h2DpyuM9T/fFYqsNuDNDMGQkbsSOhY2mhU/GspUUsKu0xS5L2XwI/8Udd986sBDeLH9MoleocS
	OtHzmttFxpahsdMgD1ZC7eqMWvtvlMr2IVMvrUPpaCoCLzR5fWtTCmHAkvQrxWLJg0mlGJl8xPL
	BO69aMYrl0Yu6oE5BxBTv4cSJSl7Ow2h6Z0LDvgl458rEsPYIEA5m2yYT4egH5hM6t2/R2v3dZi
	4+zinn7c/dbUE+vCpRDvcBadNKZl+BV7y2YXdRUrQoThuE5ByxO5mzyQKgVVKh0BmV7YIRJD35z
	PwGylMkbrXMbPRDOClAqQdyvjZmEvkWPnV7y05BlRWzH0vJXIr0w==
X-Google-Smtp-Source: AGHT+IF3Brx6y1qxJY8ZSEiuvQ5GeVT3r9y5B1AxFw1ucl6iZI3TFLF2g6/0k83M+BQzYWeUrgnkjA==
X-Received: by 2002:a05:6402:278c:b0:63c:2e3:6cb with SMTP id 4fb4d7f45d1cf-63ed8cc030bmr2230309a12.26.1761629645432;
        Mon, 27 Oct 2025 22:34:05 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e7efb97cbsm8147992a12.26.2025.10.27.22.34.02
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 22:34:04 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62fc0b7bf62so1841900a12.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:34:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWx1Z+Tmo5dCF1mhzvqStwczmMlyimJl+HAhTUPusM0dpl3d3TgdfIP2FPR64jWMOcy+9NO7plnTQ==@kvack.org
X-Received: by 2002:a05:6402:2681:b0:63b:ef0e:dfa7 with SMTP id
 4fb4d7f45d1cf-63ed848cba3mr2102592a12.6.1761629641674; Mon, 27 Oct 2025
 22:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Oct 2025 22:33:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_FZnLha9Qr2sMQPXa1go4FPq2p5d7CnMoOnCimS2Wzg@mail.gmail.com>
X-Gm-Features: AWmQ_bkfyF7pn4e6fUY7bNVBhf2DrgjCvQYqt5ZlzergSjGB0BKOD2LLrniXl7E
Message-ID: <CAHk-=wg_FZnLha9Qr2sMQPXa1go4FPq2p5d7CnMoOnCimS2Wzg@mail.gmail.com>
Subject: Re: [PATCH v2 00/50] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6EC3480007
X-Stat-Signature: 71kt49dxk3p497w7homh9cfzr4ohe9kh
X-HE-Tag: 1761629647-957100
X-HE-Meta: U2FsdGVkX18c5Ux2spl1tlkBZ9YdoBCbh8S4pJbwhBAgvrEunYqPCxsFrT3j9+qIRb5LhLXLjlDtsC+2mk6/GqZ90jrKTn1nRzWiKGhQ0L8zkGU55+Wyog9HcdRmolXiOoSpuy+5FcnppEPiSlN1HhqqjJx5OpQ4gGNKQ+GJ+pKmdoUGM/+ncdkZLEyQy4ILf1wjSCuTlFsWEEC+qePMdWuzedf7Lc2Go5bmjNfLhVJWUFDkhOYkl1Y1vZDG24bw+blElhCjCGa3p95tMGtkGhbfz93aSd33cBmH0OUu3Zzk+M6uayMJdBrjURCVMTcN5kZ9FWDhtCNyd/PpN+NoFnsaTJPXH5yzu7oBB1wM5AutCsV39vRajv4R4SidOUZ2MtUvVzEMrw5gtPMTWe5oDVkeauqNDBOm32zQ9MQe2BPHNvgQBYSIUAE/0FYpLRwYV/rBdSHJtzJd4qrqqWz3wO45ySEIVtUEdhuZlrFC7ECA04mRKgNbyZvjeKz3Zz/Z4c3dcv+CiZS4bIKOTfvpE1EGqgwg8lH7M2xcwBcbl1p7cblG9IAFjRakv88n3jdtTkdTnntMYzFIdRYrp6FTM8uFaaCk7Itn+JhazXMDNaL/jz5JODR1VRkOkMitVZTr8zL3mAom50ckU86nBNUN/ck1IMkOwUOzkimH9wOG1f+ESNuEi7StlZIy4AxwheT3VuHaboaqNlxul8IfyRrCcCxeM8XfBRi3hGfuHDVYxqPFlb6OnlyfDqgQkoOQ5l1yhn7EC2+aVTCRowxoVNAlPQTHoIQbpo03sCDggL1ZT0lt0Dxw47ZFRtvRyJ4NFeH5zI45WMRWMK7r041ndq2xSyy1qdC4ZUTI5apH0oThjyLCnHmpmxXs34/kpsGK4VxoNIQ7jkJSU5OA7GbMia5PTImPzdmP3yZnC2PMXW8iAeGFxbejBzSfaDdP76PAL9yG9jDMNZbwdib11cwVOrJ
 BMsna2Tm
 DZIMtn5Nowsg0WrhIJnO24ZbNEx5FPUD612/4+xoI3EUqGC47snWfQMp+oGZFCPYIAgb0O/whilIyfHBGzvISF8VK8tnqsc7XP9V0IdHHKITSYXCD8a/VhWEV0ggC7Yz/ocIgWLR72LSkkGQhpzxY5ruakpRwiVdJy0B7GfVj+8jfIm4bWrBvYbxplT+O8/3VnHW4rQL3Sk23FLosNVy90WSKm/ubgWUhmU90Ryqs9qY+j6xhL2epNS5bBSCvEgLtZ5elxa0RDNo2peooSG3PNM/lRxqxAg0BGsocW4U8wLgwDd14QErEVfFiz1xxDNosSqLuvdHbD2joRc+xX60b/6yEiaEE2QCE6Zaq6f+e5rdKDhIOFWPGGz0QlSsKuVdcE6xHbjOayspHpPDN17HLlCqo3BWl3jzJHEvZpvE6reDzqf9rXUZrfxWc+G5jUos/a9uBA0IYRJZ1gzKAENHcJPf83F1mcN/vnWfWuyMm94y7beXRXOIsu03xVsDj7iw8HT1e3RGBFHwGE64oyTq1+7DK6d8um0vJyKqwxNOphpQT59Qa7Zpvppqu4vZv4qtoUKTQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 at 17:48, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
> marking those "leaked" dentries.  Having it set claims responsibility
> for +1 in refcount.
>
> The end result this series is aiming for: [...]

The series looks sane to me. Nothing made me really react negatively.
But that's just from reading the patches: I didn't apply them or -
shudder - test any of them.

            Linus

