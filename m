Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB7ACD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 17:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3562C6B00D3; Wed, 20 May 2026 13:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306E56B00D4; Wed, 20 May 2026 13:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5EF6B00D5; Wed, 20 May 2026 13:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F05E6B00D3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:22:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 688C08C65A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:22:40 +0000 (UTC)
X-FDA: 84788467680.30.CAEA963
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4D4A420009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:22:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=MrlB+0DM;
	spf=pass (imf03.hostedemail.com: domain of daniel@0x0f.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779297758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9W3VkVJpe4xmAojQi4bQKjxYqH9cbCOoJyQSW/zBDLo=;
	b=IgjiZQPUSWAz2T7zlHqdf3AvB73yv8DAdC7aDZsUjjlyRVXStcxFYgTOjR+OrlG7/Hoybg
	w+G8dw5znsDoNUhqqhWnebra2Fmhm8kztiYkmQ+jgPbQoCzRYmahM00sO4zzXfcT/OYDct
	MH5CqX21U6QhtVD8nzBkIhxS/nce82s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779297758; a=rsa-sha256;
	cv=pass;
	b=Cw8o0E1jVw1vCsA2o+RKGkOf8RMEtvtWtAUh/N3cAfZwv523X5Jt1zI0UOLUZ3Ujmlz9OJ
	EDPiKIvRERqI7v4YQvWl99lyIf5V7kDNui7EtHvn6JXCHtj3lmaQ37PY6Wr5awsgcGHEdv
	bdfTb8euQte5s/p0CjHm9WAqJi+P43k=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=MrlB+0DM;
	spf=pass (imf03.hostedemail.com: domain of daniel@0x0f.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1332772f6b3so6602948c88.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 10:22:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779297757; cv=none;
        d=google.com; s=arc-20240605;
        b=Al8JgXlLmoGdjJcrvuc4TS6sOhz90CIwq0zBB9cJCainrI7L5EADs4wwePbagVHyvd
         xP1F7KTCY7RJF6t0GJ2Bgoyzts/EWTi24gGHoIt6g//JLEu+JZ5VBzwE4SgfYtv3kJWr
         WO6V0zTlYCuuZvC3jSeT/FJIbED+j5YP32WnikY/Jb0l/TRqWmhEExpOG0MwYjD2BtBo
         WXI5Ae9YRucv8/B5KY2cfV011/u2bRMW12e6rEkDaGJjUVVKbkIosDIixojE9l+1KJxy
         n4itLTdS2pZB7dAnli9xq6Gv7iCYtZ7s+jvuWnWwO92lSdjmP5ILtEt0sN2qQ1s76GsO
         wSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9W3VkVJpe4xmAojQi4bQKjxYqH9cbCOoJyQSW/zBDLo=;
        fh=IsJVLyppUW8cEbxdtU8O6l+wz0ItgbapaZtDzzQHaxI=;
        b=JdXCy51DoJ2Hgb+yLQ2pIjLP/GhlIRcAV4TDWp9cG+PTLzRjdUOiig+l5QIN8sOpPM
         kr6RSveIhUv18XI9V3WsnR426WRN7S09UDbqRt8p0PIrblb0nUTPxz/TWtyEs/wgeXYr
         lOeuNxWUi9gBOqDaz4Wud0Umvf7CDnygN6O0l4kGp2h3lIX7b4t6d4QKAjwXXF2EzZ4A
         WQN8OK8fAa2pXPMZW8X/LJhqp2ZoU/0Tl/Z8GomXtx9VgjSW5Y3gPwW3BJw+03Kl6HHO
         HygNyAkNjf6qZb3m15e1wdJY4/A42/Gzgka8xQRt5etk5s2qcM7yEMqHoUlJPncbUbZj
         nidg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1779297757; x=1779902557; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9W3VkVJpe4xmAojQi4bQKjxYqH9cbCOoJyQSW/zBDLo=;
        b=MrlB+0DMRa48X4bZ8Hg9bdJLyOTeM8DTaEeIz2RAuhOnvulMRGAQX1ELY+TXHp+H7W
         G8Ws6QJcnmTyZpQAiDBl855nd/6NrMvhc3JD92b3fcg3tZnTe8M5ulhjWkBu7yis4Hsi
         R1sjrBpnTCDIqOsJewmBdcjd57uFTWWaF5kqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779297757; x=1779902557;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9W3VkVJpe4xmAojQi4bQKjxYqH9cbCOoJyQSW/zBDLo=;
        b=Jat5MAczZBqBgPWChotylsqrEP/Xmuv62xuxJk1LL/bjrYV69w6prOQnWjlm6LNAaY
         96ntWc2FEpcxtorIxnajURkSy2FpnRgfsaGFFLLYdVQgq9ORcWoe4uzcPLy7LpVPRrzP
         uhxdMIYVJLU152vlPXFHU4XS/5/GIc8eQNN9eJ9ZHluEcKW80KHDg/hIS1UsBNJMpnbd
         N9WzcNgnoHv2U+s9HmwMFbJ72whGfwO1ffs4YXmnq/QeERBurpcsTPECwqKpbWMDJanK
         cvIFcurtJ7fkI3yH5jYAwTXOaHbaN0uRsG1uTD+OQg1CVfldaB0U7GD7aulh3mA75hXG
         tdeQ==
X-Forwarded-Encrypted: i=1; AFNElJ+GGZMmTPA08b125+oUZGC1mVOLg12L8bKN0ITY0p3gvMyyiQYnbYQT2+6gM7JknG8cmycH1o37RQ==@kvack.org
X-Gm-Message-State: AOJu0YxLSd+XBdVrUM0gHWmhbZtHOQAHrS9cL7ZOXf5pvABpEp/BZ60Q
	cAp/7p7l6Y0XTxfyhTxxnhRK9sDrOmkwskdBlkaTsXy8UBabHkHzo+qYDZDvoqhc4lMesVjgELy
	0QXceqNAuoE/5wzRKw82I/ibeEvBDF6yxxoS/pok4Ig==
X-Gm-Gg: Acq92OEy8+J3pzxFaLMqw9jpq+/cZsgYxd82XgXOnyfeve1UbDfC/4BJGHpKW1Zu5W4
	LY1eq4fysV2nF/UAm+0li5YwRwmNBHQChhng7+e/KIq7SGqbEhgl6yIkjgU27VZXQ2EywGu0Imo
	RSSwwzChed5XGrCQNLg2CS3CjzxwJO4eCcumXgONTxPzk+jKBl9Vj+L5OM0EOLU3AICthsAYoG1
	MdkuIOx/JUGIBK1nFgQJODBa4MhFN8uM9LIslTkY6uhM8Hb6DP5GtkpAwcJ5AH1/RCUA533maxE
	kykst1Yl8fRGBW3c+Q==
X-Received: by 2002:a05:7022:e14:b0:135:d5d1:514 with SMTP id
 a92af1059eb24-135d5d1061cmr3358659c88.14.1779297756491; Wed, 20 May 2026
 10:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260520163442.1099667-1-daniel@thingy.jp> <ag3ozpy8ehNr8vUP@lucifer>
In-Reply-To: <ag3ozpy8ehNr8vUP@lucifer>
From: Daniel Palmer <daniel@thingy.jp>
Date: Thu, 21 May 2026 02:22:25 +0900
X-Gm-Features: AVHnY4LwA-w7_xiuuqJWWIzc1PsVgttILCJWSpHnWsH4iQL-zoIKA3G9npIquyM
Message-ID: <CAFr9PXnAMAAwnPkY=KJjSmpE5w+daoTo+zKkOFwaGq7yZTq0=g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/nommu: Implement just enough vmap that compressed
 erofs can be mounted
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D4A420009
X-Stat-Signature: jobi5kozmb1ixaj7jhe3ze7yjkz5qtnc
X-Rspam-User: 
X-HE-Tag: 1779297758-269592
X-HE-Meta: U2FsdGVkX19xfGNA/7gzw+N1M0fF3TyXaAhhcmHFjTNDmoY5qIWLuQtDIVoy0jBnf4QApVIwGv/Zk/GwgD83aJmo0zu3i0glEiBFBKArwbD5hHGNMIf6FRghRdorL/K3+nyhmvekvF6HoW6m8h7oJp7K2p5krPixMkKYcRsG1gpahElh3uP4bCsZcGRsT/b0bPMVRkrr++e1lPQXRCT/QmH/12K+MfoZGnv63ow64O3aTREGE3CT+u/KEeuLRMzqpIQoJVIMJFkFm1slqxMao1h1aQ7AtjNqWacHzh0iscQWHZuR51pLJ8/vMz8gCmltam+XKTdzu1V1gxhCKjqknxoQN8Em26tzrJ3IvU+YWGMKG9F9s4MbSzW3RAb35sSE5zZZp/34l3d4nbx5denTP6/W8Gyt7PLqcyRFl9SMWdmmMc8Q8UfyXv/XM6r+emrep7wapcMZizAcBdPFa1Kev4RJooGfMFwN5HSxVTe7WNDx6wsJeIOUVef6o8L+ywL+Sxf+FZZ30uKmE64ML4bhGjrO0FIs4s1GUd/q4Qnr8Kw4ciRYV/qjyVESfr9Ae3ciDPDHCsSWNf+hjDi6ZHJADWsL07mtCzqYmaGfSNOZeL6qV/Pl2gPSxT+sRZ5qEjwzgQB+wkvBa1qmGN2wh3LcgA1w/g6D/iglchiEJ8ckorwJPXaZbkUHgis/0LC0tK7WPLK1axHX9dMF00oTdR+TSRz1/AD6NGhHydVEth/NWCdCoNZ4i9gcKYl902nut8cNBQ5/UAWgj28ELeB3mh8X2rhQKLscQwp/hshU5y6SwY9tCFZZVOfz/R+cCOwfwqs0g7bV6p68OeldGTkDOWvbJJwtVyTeyMMaKj+uc561L/xGrOPVjdCYlVsizhCLGoYh74fJzJ49CtSPKw5mOiMy3wMWIyvYySaEUE7SYbdbMBCi/usnCFoZA04y7d5EjAJ0Jk252LCpLPIzz7ODoYF
 yum8ZOK6
 QKJpiyTfWT2VCvuYx/J3iXAmHYkI5WKdz23QXNXzCIyE27dc0Hd6hUeT5zzophmRSoGLIgLOOX95K2bbpvzL0sKregAPOPPhgSc9BWWuQbU97ujjDku4VZAAi1wIa6x+2wRwZns2zZlVkXU2nlx/Kn5XkhyE3a4JFAV93gWvKecf0xCnJjikHgJuseEk9kH7YB3L8RwviqEzsIBsyKuixvCUk6+7O9Nk94baC0DIxQ4ywRh5SyxD1qrV8FOC/3fCFYaqa8cFawC8rRMAwHVC7eYUsrR7hhEabbOSWLs/jQ/gRDvYIUKaD4lFyycGqf6WuvJGssSu4weUKmsnKb0/XqLOZGmIuS9HiOrn0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo, (and Pedro),

On Thu, 21 May 2026 at 02:05, Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> For some reason this iddn't arrive in my inbox properly... strange? Maybe
> missing To:?

Sorry, I CC'd everyone hoping I wouldn't get grilled for the silly patch.

> > Did I miss anything massive that is going to come back and bite me?
> > Maybe it would have made more sense just to change the erofs
> > code so on !CONFIG_MMU it doesn't use vmap?
>
> I think that'd probably be better honestly. I think faking out vmalloc is more
> trouble than it's worth, and it'd probably have to be everything-or-nothing.

That makes sense.
Do you think it'd be acceptable to maybe return NULL from these
functions instead of crashing the kernel?

> But yeah would gently point you towards doing something on the fs end I think
> here :)

Noted. I think I'll at least send them a patch to make compression
support depend on CONFIG_MMU.

Thanks!

Daniel

