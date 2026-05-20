Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13F1CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6356B00E8; Wed, 20 May 2026 12:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E768F6B00EC; Wed, 20 May 2026 12:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CEC6B00ED; Wed, 20 May 2026 12:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C66416B00E8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:29:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BC1B1203B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:29:21 +0000 (UTC)
X-FDA: 84788333322.29.4F5BAF2
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B4CA180004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:29:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T9Y+Y1AI;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779294559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dK3mtN/Jziu3wUEnfMeLA3bfqP1k1QdfB+zQ0t06Gfs=;
	b=5BH3G5QOt83oyybltyeAndKqkuZ+aqc2qFLstFvWZBipAYrxFSMjAm4T97FB2DDlThgFEd
	UJwDfImrAd6ma/3PzcHTnhF3ZGi5OM3KL6riyQwOQTEmLBRhtBZLqRfScIkXRNrfWM17Pt
	DJyWMp7RbFTu7saHzlNTt2fTwtq4OUE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T9Y+Y1AI;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779294559; a=rsa-sha256;
	cv=pass;
	b=tH3aToVwwpcvx5+aZEwQh06oz5IMGosMsFLygGS5coAGajOnNbTVP/WPdgDs6McnGHoDYF
	JerEZIExiX4rWK7uFJz5ZfikWNIhJI+tsr41xdsvjtghXQa9oDic/6C+gy1d4SZxdIdfT1
	lZ6upaYp46AFjm1F5m8t0Msli380fYw=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso179a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:29:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779294558; cv=none;
        d=google.com; s=arc-20240605;
        b=G5JPOX12TbNLrE+gTjUakDPuSlDBohAhuqFQpkhYPlH1TkgDdUwxcYOC14dwZea60M
         t0h0ps2FcMysDmKew+pE60ZubgpXyV9MjUnX7fS9Uv/jbBX/lFCgQ74vlbJebF42B66p
         vfSSAfp2SAOK6p1jptsxawfQ1PpWwIPJ7lgP/Bf0tLudsSbsSeQSdR5uW/e3VTOkG8vO
         Wis6+z6qa3y+XWVzg0EZa8sH6VNIVAEEDGX2LaLScB9U2QpUTiuYo+3KhOHW55g2GUdu
         jPAJbWt89TaJbhd9wIrXtkDSne8+z4S96jEIeQUkFhfWckLRQC4t/t0P/hv4ZDyrISnE
         45aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dK3mtN/Jziu3wUEnfMeLA3bfqP1k1QdfB+zQ0t06Gfs=;
        fh=5qn/CLSw1zuIII0bhH9EqoMR7HzQOMH58v9v4mAbIsc=;
        b=LvVEY9zfB5Cvga7D2FhmihzCpjd1HRsXf9+F0IPtw4heqcKMm5+ot199dF0HTbsXnq
         QkSWckcc1t2yChEg1suKJ2r+NXN/ZI6CmWzW3GIxYEDbwq4s6W5BP6+i1qSM8qpw2D4x
         Swndo27iWqCC+vFwidOQAmM72D0Q71JVaxRh1BoHCz4hwgF5dT+2p3oOs/RmDGtc0om9
         ZO1tIx173DiQblu/YGNTeHP4GlUYvMsnT7rGxe1ESv2frsoL1FMjr60+Y9LjB/EZcWrw
         Ewtm5EeMSv5QpRIpQ4aA6SbvnqNvK0v6ltEDuj6IJiIDm3/tG2ZQNtLaBZukIx7nRo+c
         rLQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779294558; x=1779899358; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dK3mtN/Jziu3wUEnfMeLA3bfqP1k1QdfB+zQ0t06Gfs=;
        b=T9Y+Y1AI/cF45OYgqB6gxf+soKgbb8UMy5ll70yZ8sah2x/VWK+Iih7dX18u5NdVxv
         7xozGZA2I7rwfGmIAjK2dGtelHW+QNXI9r9ddpWKPD09UJMIKvb3eM7yvVpjMR+D0NR4
         A/sUTg4J89e/MpxpFUC1vb2M8qVz/aOGE6RxajY/CNTl5OeM9Nnb3nxRtherEs6GrzbC
         mA6Bhc7zZXLdlkwaZ1ljf2ehdYBH5FxmDz5/wfNDKj0Q+MrLMa0/F9qD7LZ6wlaM0rZ/
         K64rHURn225t57pcf38T/xMi6dedY4HnmhEQFEJ7Z/Ia+SJie0TRrpVYlMporMc8kbF5
         TEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779294558; x=1779899358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dK3mtN/Jziu3wUEnfMeLA3bfqP1k1QdfB+zQ0t06Gfs=;
        b=elURX6gj38eqhzXZUJTBX9HTGMzw0cVx/4UquHPnL4bEAwtg0MeuTS0TokfhM7Da5K
         xRqgZ/VUseUb0DUz5A/A/E5SKdndWP2H2a2/YufpB0l2exl8hmBTDlWYmTOHE4juZ7ZB
         E6rL0FlPGAHcB7/RDFn7S6g/2/tuA4+uM9LMRbIJmI9L/2/ngr2qp7OxeisIKM9jWVnN
         0GBCneijoUtjwTsXYj+KHEqm1JxSlE5WZ9+ZE5mF2qN/amhkPt+kOxCBCQAKvbsMgyVv
         OsKWtVcrRufCa8doYlyY9NHKMF+soRApdKqktOrE6wKAX5AptO4dOnxxzpOSY33MgKn0
         rNdQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+XsLf7mwmJ+VCZ5eA+tKFetbE5zweip3frWLQQiYLCRiQNQo5cZ3xnGuNi2ceVjq3DwWiL1IrHQ==@kvack.org
X-Gm-Message-State: AOJu0Yzn5MzEtIfxbQGAGQwLvfE37t7R/W+cx8MTVEjrkDWzsWVE5CTp
	4PD+//lWhrbfI4/huzSK8hcju4ZBG0/MdrC//Y5wt/QT+Z+PLcp7oObyBkfqjZe4vCjEFhrLiT4
	9BvNMmhZADMZh24ID2nePwYlhhuID3YDKo31QbfDN
X-Gm-Gg: Acq92OHKKZyafTiTORhGPEI0FxRuVmvNTbgzYPsGKnbjttSJF2xJavEHCt9gT4Vcuju
	dyWmg/2ShPcZwxoB1I+3ZVi1ZlMz+wN/WlatVNTspE7DKaPtOO1muM6qeJ9tr21L54bwtOhhwS7
	9ned930YBwCmIcaJ8dZOKD0TIoVsCjKCNWusIQewrYId2C0A5ecf1mB1Y6lRspfgrHnC+K2SIus
	Ral7uKGm7FfCwgrPcS32l9bHHH9/XV4ofG9rgXjRycMulUaKmcvElH7kbmNyuv28Uuu+SKyxkgZ
	kVm+pcG9HG0zTbcBg2T/brJbuuiCwwloui4ROk4FTFP32kqh
X-Received: by 2002:a05:6402:312f:b0:671:4bfd:e074 with SMTP id
 4fb4d7f45d1cf-684986f39a5mr231663a12.9.1779294557493; Wed, 20 May 2026
 09:29:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <20260520-work-task_exec_state-v2-3-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-3-9ea88ceb09e6@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 18:28:41 +0200
X-Gm-Features: AVHnY4I19Lekw0GjkgNXPhZIYkZY5uH-2kKuMt-t8V9EcUKiPyWA5Rg8NRcy_Pg
Message-ID: <CAG48ez3z7yCsONJbyS5eX5Mr_41sYgi4LJ=nYsW7kLGOX+MwgA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/5] ptrace: add ptracer_access_allowed()
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3csa841i4b5wa51wy6ogrdain6sgc6b8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B4CA180004
X-Rspam-User: 
X-HE-Tag: 1779294559-251262
X-HE-Meta: U2FsdGVkX1+6SwJj+7CCxZN8Z/Mqb+aFKbN9L3wOGMU5RUctlgYD2QH/HgSnOSSOfd2WTgs4OMigPKUZpXZysaacREvd0b8ANkIsGvAarnuqTs5wCW7kUMTxZLHvxOcUa/VxU2gRVaF6LnAPhguE6WJJHPxvEhfYiHCxG72nnsCYOqHLQWXTt9mPL3AfWXMTbkt5hYJRa3rC7CCOt0jwiL9McAHikiuaO67ijznKTTrjzrMsQn6MS1fRuHDPmwoNJkwa7/GwYXuZx58iHhFdiuW2ONY250FzWoGaiPZYXAuBso9xZ5eodw6hpronWCPYbvBTkr19AKoWF1uRBRTCwN65wC7VxBOn6/d7pa5GQWS6HIbSVSENmibswIauIxlCRQMSVOeqfEpDRNdb0rrhyQNJw8N6Y5vNAq4FVkz5oHPk+gA2lG91koeCu921RLN4iIR6e4+Vz+vny5UCSuXEIRfgJyKwwURbmG9L/m1NrmJTn0m+R8O5h6voNZieX8w4uAQriJb7dRmNqlHKG4M83umq9mjzJBqR6YSjXHPusRHFOdMDGbsYHLOMnRQc7CWYnC9FxUZLLKsqAZmQ1LrA9/D/2pbjxP9C9D1OiLbhQjmbPE3QwAzHamy6MYCJ1qWosTJSW4x7bKeuMEx7RQPB9hsiWMbNXdmpwjIdI2bpcdRq8bYWW+n3C9Fz79uNV+14oH6lPYV/H8yDsaiT1NCRA2BYrD6BZnjiVI5czWoIN5ijlkw9S5rsMbMTnwxwQko4cPXzRyrDzCTjMA/EgmmPI5agdBHS0T4DfQQ/4gmA7NFmX04sdRpO7074nyAbshyron518t9Jskk4Ntjh+91CT/QXAmSGG4dvpZVdBFCbvok8eMuEU3CLbTiQQ+4cqXu9G62FaMVX7oIhai9F3YDitdHkgDMzVP5iT2mZr8tq2Vc0iGziNFJjI8sA+Vs6LiasyIx/WAMDMKPJujQUeYf
 yOq6mCFB
 k7y8A9oefuYZSERqzoOJe2wAfS5uUuKgaSU9sr1me4BGShm7R/sI22+Apw4E7OfUEWAQcYfaQ2eAcpWazDiiD26ckeHYjxDRU/31xjZlf4WaTvVfXSxwilCuwpiu7w2674XbX6serjfMO1RcWu5FTIaKg7JSKM/MmpjXvFtoBEjItSoW5esW7iRo6DWAEIYA+iZbAT1TkvXg9ET1bqtyTTfXgX1gXMMQ08jEcZrz++tkwIqZ3Q62KGD6sMhfn05rutDj/A9wEcqHFFvBTRCXX5YU/kXyzyrpGX2XopGK+qdYdYfSVrdaRNlZgxOtuROpqsxRH8Xah1prWoIeYiYkZP8Odayo89Abz6XUBl06Djn5NabC+XFcn2mDjdOg75EF+coEMBpAq7cHdWcMKFL2QxxyofAqxRtu2nkn26ldzjIL25aFLkVOVSYJtwFhQAgUud4JdL1N8cnJcvAMLp516FvVygA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 4:43=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> Add a helper that encapsulates all of the logic for checking ptrace
> access and remove open-coded versions in follow-up patches.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Jann Horn <jannh@google.com>

