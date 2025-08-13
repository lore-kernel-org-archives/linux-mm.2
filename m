Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6591DC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 22:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065CE9000DC; Wed, 13 Aug 2025 18:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014D6900088; Wed, 13 Aug 2025 18:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E947E9000DC; Wed, 13 Aug 2025 18:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5073900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:03:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A526B1602D3
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:03:19 +0000 (UTC)
X-FDA: 83773110918.02.E3144CD
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id D1003A000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:03:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EG4RvX+B;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755122597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyq9yo0MXfpOrzqj+endN1GoKCtTgcykAtgBOd8EPQM=;
	b=Fo81eZq+4e+XHt84OQawGGHAWQAMoHaIMUD5QTqeFElAcLaV61tBsPHF9bncOo+E4jyWpt
	4D6OuPhS3GSROTpGZOseT5dIqaSwtLOpS1fa5yWErPJFVK6W/MX/aVrUujDj1H5My2PQnu
	st3TruxCq8ahLbbs/vtDkhDYwuJVsSY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EG4RvX+B;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755122597; a=rsa-sha256;
	cv=none;
	b=sdzX1rsO43ijI5dK3vnTxBWHJirFjCPGXpWevb2w7itZrnMUfvQ+ntkpa33Quc+Dd+MnpU
	JU+qgXnKyxfFzsEReHaPnc5ROiaRewBZ5KB2yTfFAvd+MQGMDXAFj4dpD1K+cvAhLSaIey
	M4oJ8oCVlUrX8Y5Qen1xNeIilP1UB5Q=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b10993301fso5392211cf.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755122597; x=1755727397; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyq9yo0MXfpOrzqj+endN1GoKCtTgcykAtgBOd8EPQM=;
        b=EG4RvX+BdXpFu3BVzaS2n8NiDomrfBmAcS13Lidri4XPAaSA4phBxq37i4Pnn4T5YD
         ili9q47/6WMQcOmpag0Ks1BhQO08E7QQ2WSEijMll3C2rZgyNseM9S5EM6XOWgg8n2ah
         9LLHBVu39sCxsibltf3xjAQkYEPg44UMs98pTA0XyIwWInzoZ+HcEGMutw+h+YUWLpSn
         qkZ8tcgQ+w4b7/jJqlDHs6swgmwmUWe4l0nkSyrDTGkPOL/PlsLt02BCuysaoVtVOK/i
         Q98Qcbyogiukn6YOrInLm//n2pg6xvbHwnFuIL0DhYZeYpPV5MIeOFnEejVgBtCAZuP2
         zSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755122597; x=1755727397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyq9yo0MXfpOrzqj+endN1GoKCtTgcykAtgBOd8EPQM=;
        b=Z5A+8WBu1i99j3fl1O650YJdQxeUwffEmj9uOKjHBtAupMvIo7JYELi6LSf2sZim2O
         Mb1+OmcX4YVX1FtkVlYb+WZFc8uui5h7dknw7QK2WV/UCgfjI9VaKgTzUYnrQ29HIfsv
         tvpzYVMVZa0KAcl0x+OvXw9Hv1D/CuBZQTR3L+BkhOBtW+6dWkL7DLDST+PBPfw3lONF
         zIp5ly4Li+Wg9KPgR9VeKG5SS72JeXNWFmZVr39BUIqpm11J5LlzIVKIMy1FrEE1AgAa
         qU3jZ72XOpjM0wWatiN6lEtMKgeDuv0qwM0HIeymSJqXvgekqwnNK5H09+hG0mnRLHy1
         Bvqg==
X-Gm-Message-State: AOJu0Yzx9p7W3ODDeGpmHLXrCaEJBg/zgyTHaU3VmE87buUBo7v2zcuq
	3UBUqwv8/x2XNh+/dcG58PB0EJnyCC+ymha5k8v0/BLuOQubSsCQXnJygHMCqOj8XisETKXl6aw
	t9WRvg58ukTG8C5/v00aTD0BLdJkPlNp/Gw==
X-Gm-Gg: ASbGncsoDVgHtBmxjuU6B2jtKlMIrbkr8PtgpEOzs18bUxxgYfS84Gcz9vDgZBrFEsj
	tvCbSZGsChoKumWXX4YkHYHFIxfhcUDTFmCgsToGsNexQEhhAQf03taB6j9b5TrjSpG0QS2/gIx
	05SYiS04VNr85RxytGwiSmz8byH9CYzKJ+xQ2em8+PioBdPQyo67nGf0zh920n1u5RAPLpewAOG
	/8v5G8l
X-Google-Smtp-Source: AGHT+IHJxHxj3Ac7tWubJShJXGK2CcyuwC336JwgwnqUtbLQjYPCHQAnYM9BRWX5ucHSkgF0a+u5iX1WESLxzgtlSDc=
X-Received: by 2002:a05:622a:17c7:b0:4b0:8e0a:f095 with SMTP id
 d75a77b69052e-4b10a9b9e4amr13619821cf.26.1755122596778; Wed, 13 Aug 2025
 15:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-11-joannelkoong@gmail.com> <aJr4D9ec7XG92G--@infradead.org>
 <CAJnrk1aLAPqpZZJ9TLBhceVQ2-ZzDGY8qv5_bX2rt5XA5T9QTA@mail.gmail.com>
In-Reply-To: <CAJnrk1aLAPqpZZJ9TLBhceVQ2-ZzDGY8qv5_bX2rt5XA5T9QTA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 13 Aug 2025 15:03:05 -0700
X-Gm-Features: Ac12FXwh9jEKYJ553fL2_do8VzdYgYiCjErR3whJjtdZ88-ia-FLAeyu-s6fzXY
Message-ID: <CAJnrk1b=3S5YrR_wnHSuUzWHmYdY7o1Savi1DKi=GdJvQySMAw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback accounting
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, jack@suse.cz, 
	djwong@kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1003A000E
X-Stat-Signature: 748j3xpkpiybdan5xn7mghmqrkxzu5ck
X-Rspam-User: 
X-HE-Tag: 1755122597-555699
X-HE-Meta: U2FsdGVkX1/uQVBg1/8lHnScNoiTEESmWIbZ7+wdYeavZFvIHU8Z7meCQG4y97ZsbJSuC4yI3zENNJlHhsQRaNTnrA/lm1Z0DqRs3WzeDOBQTlxADehekZx9vFLGPrZqwMahuDLVlgtwuB8nxG2IhEPc9oeW0UljoC40KZqYe+xHgp9zNb319VefO4ACqEphrpoq2dvXk5ANBspnhzJ8wzxYorN+65WY5/cONgFVirju50MgNGYBbpM5gNZ01YeUnES4ugfS9YB9fxprrcfslKrzjySF5ZrYIkL2Av/0mMhHcAM+9wO0PiHyQiWkHSeDCuvEMgQXdzInTx311b82Th/JvXka/Vd6deg832dzVRIuiHdxAsbqPEJZ9TQibJFQYe2oenASoIGlW5ide43ViNt7YA/KLLAWY/uVVMjN8i3Rs0aiI5nrmRHW8aQguywDymYwUgyV7xh8FAV7FZK+rZ/WA3/72VBWro1wyc8JUdn9fOpnKNX9VDKJE0aSolBaaPJ97oKP5c3q1fX4m1iw22lj39Ecg6bn4yZ16DaSXw+qf9RMLOUUvTl4kS1mx1nOqFDuD9TwjAVuYSEJ9B3H9S/1AIZd0/CmT/vObsXdlBTwPE+ChL0SqYUNReBELqFO5U/MlVqCtqOvr7PdGSP4Wt4B65bUqwahYscB2mfXfAgeCB/5zNcZURpeGethsU6txBKKvuryfT58Bg32BoWYBc0LnlmBa9Q4oMJqk8d7u0K2I+/9bSrRggURaz5ontRDy/CJVhSe8815XwLKbya48NAghvm5bZOfj5FUtJZe88rAa11WM3XOgqgIoi4QJbwR27VQtEufw4KWWWmuXLa0S0XyklDIRKCYgFyRv5+StBljFv0sWXsPwcsCmXx9Z3aE+WFhUnUVrjTo9VG5s9GpYUrI16oiKiZooByn014DzMhuTdPK4Ze5nY46Hb5kSi33CcHhpuxorxpm4hknzLw
 Fi5nZwPu
 TbObO/np+9oiWAdx0wqOauUTPkcSd74B4Wbqylg8RyJIetQqmQtLL1u56/n8tolq0GBXuIDJipBEJhV7COSN7IURI7HcdJ0BSBS/bJnNyR8H9HU2nD5ZODMKQ8gazmXPEGwCsC6ZpYaosrGp3+ZA0WHaEG4fMjpnhYTqE9RCZymSHwULNiNgnSbmlRXRUWM23S4Ewq7ValvpeCcw9jBt6FDM9LFm8We7ug3EWSVMtSq2pNEpSReQzOX0xhYYXSP5SUP+zPcMtF6bR4zQXld2tHnOnjQsTj5SeolZngv1TtgcHbm95qOfDam43SRqwWi+kJKTN3HXCEK2WoFUS7TuAwyVf9WMdgSMF7pS4XHSHnkJgYNwzYkKMizTRmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 6:10=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> I need to look more into whether readahead/read_folio and writeback
> run concurrently or not but if not, maybe read_bytes_pending and
> write_bytes_pending could be consolidated together.

Nvm, that doesn't work. read_folio() can still get called for a folio
that's under writeback if it's not fully up to date.

