Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A605AC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1886B008C; Wed,  2 Sep 2026 17:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992716B0092; Wed,  2 Sep 2026 17:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881996B0095; Wed,  2 Sep 2026 17:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4316B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:08:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD38C40396
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:08:07 +0000 (UTC)
X-FDA: 85170059814.10.9C7AF36
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB500140008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:08:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=fasheh.com header.s=google header.b=N+pXWiaH;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788383285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
	b=Gp9J7RuqkUUKvlBcaFMZw1Ov4s/+sywnZwG9TQIdx36uguSKlK30jPK7z1NRNIRe3oG5HM
	j6HMm6i08tZyUNAFbJY80NA3FEO4dCShpA3VRxxUnRHnb+WvdyeWZOqDxMfB1XuqNYmPEC
	ljTZtUEG1InmkQksjsee8WT5NKCQNI4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=fasheh.com header.s=google header.b=N+pXWiaH;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=none (imf23.hostedemail.com: domain of mark@fasheh.com has no SPF policy when checking 209.85.222.170) smtp.mailfrom=mark@fasheh.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788383285;
	b=PbmxY3vtLamo2FxcIwrj6AFqu7G+twHz/TDxL/z4m0MRTcIUDBMpTSNujsz+BTb2zjfBfC
	dwPD9ja6mIPnJRe2RnvX/IU5qOXYqxf//8sKOp3lQFoDRZb5HUFJ4h2TwWBRrT6EQrYENO
	SQh/zrIzmRYtWImOFZNFyjwtSZd/uN8=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9390f8a1c9eso128370685a.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:08:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788383285; cv=none;
        d=google.com; s=arc-20260327;
        b=P/GQP2BUMV7IJt3u83ZXFhQLX63Ln918TZcvhDcscFBC2e/z708C3pNFPf/aeUlGDz
         N+2ONs2mx650yXy5Cmk0D2X44CFlwzOUzVIitI9XHx26N5hEXYfDg+MwOjByx3cAy4bj
         TqdUUi9WLdSCgcsaPn1zI6OBynJrU3kHGz5cyTF14D+1jDvT+BS28srtCt1egLBCve0A
         LapgYOLc/5yO7jvibP9AKX/S2zjOUF3YKiaQD476b80sUgIXHneguK5CyAhPe2PXNRad
         SI7uVDUtp2jY2gzPunX2/647MNdz1ySe5sarVWy01q/onapkZhn/3YL3zxqNvBxmr4v5
         HWIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
        fh=IZE440BrJcvtQPfPGqmy9wgFn8V4LnYVDjn2h4FGzh0=;
        b=a1pTxwx2MJEQglKfgbRoRKyVeQCzXh4qG1mBFaErlxtJhDI54N15oOqWIUfRP15RjZ
         PnoCWatD3+1fTogxU+eR1iCvSz4pcWPn5bE5Px+n6tGxqS7f416BMkRjsFPIh4Z9yQnI
         0qT54OMn8nJpA8T9k6NKz/+kj6Zzicsb1lHIzK0QDQFgFVzje6iymctXY+eHhqKJxoSI
         cieCo7GSkaWh9w1rmH5S/1SxTYjx7JDei7GaY8wDRP1eISwsq5y82lhGAYmJWcnXqpWw
         /gLCAMHeqGn4/wRd9POJCYWWEEb83/xdhc6S1vI679G7jqAs3OkwLK73TRYaz6vTUbwN
         g58g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1788383285; x=1788988085; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
        b=N+pXWiaHgD+hPCI5w5cKgqW2+czZDCBsA5VhOMyJsNcu240TtNOjcHAdqq94AgLtCu
         5QEI0NOyZjgZtUIWAkwFfLYJnD5JQXUwtXY4cxdSaBl65FOIGrCcJSkG76V9KbUoYLrU
         xABbbB7I98qzIabyJF3qgrGlWt9lAb05uS0y/dWwH6B3k01tSSMxVv3nDk5Culu0rwPu
         9hj5pApN55b/o+qcQB+U7yP0HY9wUe+aeF+3hsm4Otk/F0TdzKoXrj7jd49bcvE+P3Y+
         TdfjRSkx4WpNacFefH1CYiwoQhn8XG6ObH/BRj6NhUAtIn12fmFx3P7wGkgLVniTtu2g
         ZEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788383285; x=1788988085;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
        b=Dq8USKBkUPA+DrrvCdtW/w8lRcYBfUFELTWG+XZRlmXQMvBEh0DaiFvMpkCKKJ6Xes
         18TurQxGfPnQejr/r++Axp68NJY+rNyUCZRMfCbvGAyymfIg1QzQaqB3FsINWw7OTeGI
         C2p3BpqbO6CGmADvBrF4tpm4QfzuYHHrCYvqOm6L1YCM2p4LhBrPOv8rfMxHCHnlIsN5
         8PQxi+Ch5su//wN0UgxuC4NcpP0gJZcCb3oT7Pm08Z+T5Io8vD0kaf+BJeHYlKboil9e
         uM9gHstkuHlsp4fpp63cGYVnx73uGtlxmpU586QqJ8fbIBsFWTFTAsUMVWW2z6SIuaNU
         LcVA==
X-Forwarded-Encrypted: i=1; AKwUvBxoyat//JXAO/qR06NQsKbc2PiFAp/hOwamOKwGLKtdg6uWQ4PVYiPKkXmW5XWFL74IMqDH5PkAJA==@kvack.org
X-Gm-Message-State: AFuF++lpmjdDjngdscLp5HhkylfNgrh3sF5JbcMUc5Ypzb4+5+SNLooJ
	Br19c5mtlZemBtFzJJ7ZnmQHs4JO+NM0G+AHi5RmD9+uM/3RHiBvKF7By7g57V5MP/21hWyqNB6
	8X+R7kSKxuzVYpHm+spyWYgo/0tpKVN7oo5o1PZH1X5IBkdf9CKL+
X-Gm-Gg: AYBFou3eOkO8Iok02s4gT6M4DGPaELznARLEuKzkBnT8zBeCo0hSPGyvzQsIvZVUqfy
	54H5JjkTmWsRJZpx1M1qGWt8kaGgdwKrj38gaAuv5jqXsrkhQR59v1uzGEyHQIbNeWnu6CItMPZ
	+IMUz/OiuNKQxbyKfOSD0UOhKvgVIr2ntnk2TuD/FQT1fE4YiEv6oRLWjiFu+xU4AndF19K1jGH
	pSRAFp429cuVzY7N1oYS8U5Nn6C0W9LaHa8UMwVfe2aQjPU9CDVtYkZVP8RC5MFVW7ZIu/sWiMI
	bkLTsNlGuzjORGe8JxMfVGyrqV6wMXKwr07rXNCnjlEXx9U/X5xV+17KxE4Vjq6dn0nv+x9eGDm
	PjWuOiJUZ73M=
X-Received: by 2002:a05:620a:a489:b0:938:fd23:1e29 with SMTP id
 af79cd13be357-93960cb95e6mr829447085a.4.1788383284982; Wed, 02 Sep 2026
 14:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260902132458.23590-1-jack@suse.cz> <20260902133702.1313635-3-jack@suse.cz>
In-Reply-To: <20260902133702.1313635-3-jack@suse.cz>
From: Mark Fasheh <mark@fasheh.com>
Date: Wed, 2 Sep 2026 14:07:53 -0700
X-Gm-Features: AcwNN1WtV1dqVx49J7eUpu1wKtIk7R3uNrgG2lJ_B3RcbI_Kpq3v_hSHulQC3gM
Message-ID: <CAGe7X7kgULLGViiEt1o+F32eU7cR9-vTvc3YGJXSg9Wjxa2Sqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ocfs2: Refuse to enable ocfs2 format for another filesystem
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dnodnidh8z8783d8yj9f7uo1cpata3nj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB500140008
X-Rspam-User: 
X-HE-Tag: 1788383285-311866
X-HE-Meta: U2FsdGVkX19i8bik6wGyoTB0EgDVkAvzjGB9uWctbXPnsHWuzDxj/dThX+Wp3CHvE51vaJuEknkQGUBLRkhIDQZQ26BTKdsNjo/5Ai9pTbvBYQZRqVnJUX+t4oQ6jrCyuUQSI6o3sT19yLat4e8bXcd4Wk+hZzhIXWHBv+NkkxHoBtDghs8W2HT8t8pr4yc8HcMYHjCkBaY/fp05BcOf2ckvvND8S/lP4RNt+Zr3hn0FRXyEwOGb4GXDm3HfnwPnzchOK/8zpQ9Ja8FR/gKQza3UeHWkAp7vC5ykiya6uagM0vZFvve+tjcI7d1slv0v/EJ2SFfGn6ZgrTVkBFcOP45+R5JXHRGUlYh7X7X0vh9A6DwyzQ9hnNXnqYpe5Ew3rzVX3jqGwWwoLuaZME5XYLhemO1qbaDZeL7ErEyGn4Qzf/EtFsrAyFuf5Q+w+/TwcCmUCNFrZx2yEfs8Yyccxiw/y5NRk51EGPt6DEp9jDLXeXDkKsyPYNx+JDgO9v89koGpoIMp2gnY9zC2I4mpMV+wOSUqypV1zMYgrFVdIFROP0h3+/fP8v13KE1Aexf2sCpbM5m238Q97wc27AnCfdOUZHoQzXx9gHNm7EJyCaXX2ytzY1RGNaXg9qZytWjOHMt0IXPYc5rAna0I93dNMeGuHy8UJxXgYrgFnSC6wwGTu5FrmA5WY5tWMenmMlaKO6CknVrhtzty8qPfJLLN5mtosKMk40zSaEsZI4DcdkqFByfHfKnTUNgL+sQREnToR3XSpdiJEular1RS3EDBylg3ky/+dNU46dLjsvV/l9YtydwGUXAm96vJ+2usmdmuU/Llhy0CtbovI7E6pUekWuHc3CQoMWBkpFZl9fZ36BBKvIZldfXhl0UW9aFKxgKZ8iP9C3ujly4Pti9yxLIKpr1K2zJp2eq1VssnFovf/POHAKN5WlCmFjGn91DjphCuCX5UXtQHqXpvkXWKs+c
 Tygv7aF/
 6XycikFJKb8V4JE27W/bM30DS9KohAoVh6pOwEA17gyGUutVVq1eR+wPc1Qw1Si032fLZ57bqkg8N+jltGu8afJvEiRL5qgXZBHyj3jqgcCdppUBUzE2h6vwPF3O8exTH9/UVbnGGwi0MsKmaX57Fto+nWQYI1bkFz52sDlwaYzciSDxhis8tvWMwA1kBvzaUcJIu/bNyL2BYvFT8Ym0iORkHORUKvl+Jalaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 8:26=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using ocfs2 quota format. With suitable
> passed arguments this can get upto ocfs2_local_check_quota_file() where
> the passed superblock is from the ext4 filesystem and that can cause all
> sorts of interesting things, most likely crashes. As ocfs2 quotas are
> specific to ocfs2 filesystem, verify we are indeed enabling quotas
> there.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Mark Fasheh <mark@fasheh.com>

