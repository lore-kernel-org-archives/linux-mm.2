Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2945C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 12:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD51A6B0095; Sat, 29 Aug 2026 08:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F136B0096; Sat, 29 Aug 2026 08:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9276E6B0098; Sat, 29 Aug 2026 08:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7546B0095
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:13:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03C40A06CB
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:13:43 +0000 (UTC)
X-FDA: 85154197968.06.BB60AEE
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F427160006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:13:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHHYTyWh;
	spf=pass (imf08.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788005622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qpiRKhTPXXV/T2+awybSnvPRBM65XAy0brn5CKaYMA=;
	b=VhYq5OHmercgatC89W+UFzcgsDSO7KYzRqtOhlRqIKkqApDVfEoimZRcw80oex7R2OBD1w
	5NkZ6a+ghw3eZ4MIx/Y4WiJ04BpT5LwRJ3Wydl/rIBXoxZIae6eQbxcdWb5FsZmfrL/JaQ
	7nnnGGsQIVcjzBqf3gcSJaYrp/d0u1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788005622;
	b=6wu0h8DTIL2icPK66ScGicJvdSUFwkeHWBU6t+hmG+XtjFrzDVJS9OoqYDjMLqSUn6t3X7
	cz4dNG25QoAjdLKR2UmQUL9XZKoVbWpDXx/qDq4trIcXtniilcNKU2ZpyGTDV5Ieck4quN
	Z4BE0O61KBjhYsLBXdLSLRFHYpl4b/c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHHYTyWh;
	spf=pass (imf08.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8548db7428aso1720744b3a.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 05:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788005621; x=1788610421; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3qpiRKhTPXXV/T2+awybSnvPRBM65XAy0brn5CKaYMA=;
        b=YHHYTyWhZmIv3mIG2qa3h5HQnPv5D2etQjtnW43lBLbaUoaPQkIg3SfDlqRQxhwcZU
         0ge85kPrdl3bVuLyvvJj8y/m1ncbubHk894/3yr8/1DvC2+FqFlfDlcMs41Yx8wTiklj
         ZJFmx6RUH/SYTV8V5spDaK14u7tbEMH4Bd+DsrGwvSbTEjVWO+rcMw7XVy5EvtflNJUS
         t9+MjtvKNx3v5zb15a8upToMmYZse0+vOSpBmBe5iec1QRu8qGpVxgP2j7tSYyCNCb2W
         eSbnpQZNUgryRIzhIN92VKNi/p8rXB180i5MSHrKW7NMBT9wqM5vYfdI+A1UYjzXWUFj
         ZhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788005621; x=1788610421;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3qpiRKhTPXXV/T2+awybSnvPRBM65XAy0brn5CKaYMA=;
        b=m5scV5bONw6wIDJ0E6rq4kigrRFY/tWsa7AYwVs0dO5tLOAPk8GRVtoL3AJDXmoGd7
         jvm3yeMhW6sF0Ixo5jidfCBfbmKymP1n2En4aq8C8TYG7VwDi25KNsXprMjeUqyyn/UQ
         l/7H/bM+0sauj1HohMIGUQHtTi7GHWEWyHPOmz+LgNR+N0rUPqOiZz8prGi/tGkZt4vw
         u2EVIkhlQSO7kn+r/zUKWDPoUp5601OYdMGf1lAcJLZw7JENb7+WT1HMCSRF63dXq0as
         h31jpHmSD7fnfvqBnHu+AGbces3IVoGQoxS6KnVcL6Y9LPFpFHY7ul5dTe3SBslrg/Tg
         MTTQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp7aZGyYbgrDmZ4D1mtHXDqH4GcCZVDHKnuCRGxRc/eSfc1XFkMwtFamjhK+tGwZemj3V0pXwzenQ==@kvack.org
X-Gm-Message-State: AFuF++nCG9LzxBIsIRiO0s61Gz2X97YaBiTRyX1oFaBirkcGd7I1R8zx
	+edGFud6wEwQVRD65tJebJogD10XIqpnyxeQ4vY7lT4MCGPQGF7O7DR6
X-Gm-Gg: AR+sD11oR5abSCoG1CwOl6Hh8RlBcpSeERKr7YfSrhLQlki9xSaIkli3+2QzMk/vCVr
	ZR7EMbzlmI50D/qzvPKKEEpTIK7wN4uNUKNrein7Zo9osCkUyKmodd4Wz0AXAuEU2U1TXRB9crU
	KHUIeUzXsp9+fo7GHg8YjGAXoCcJHjphLCs6ANMo3RWy2kgaFYJseTaGo6zXVrvMyi6yQjiZIyB
	Wy7t1k1B1KASAYrgI1HtHdeUX2L3AkauhWEWIvYmTmyDr2IhR6RXGzXh4mDDRINSzKf9GdDgCG4
	mad6dj0WzR4qy1GD1pZTXZDibKdqTxbmUlLJSm/fR9jG6T6ENszsyPdEv+v4phXs7VyLYHy2kcs
	0fns38TQoPnIZ8tb1+inhQejt2dmUASWRVoCpb0De1M6COG26kbm32MithJtF5ViLQ23fvcpawF
	hIx6z0h7DRXeWA9Dv7SeUhVVRLRf/lY7+wzDKoy1uVlriT7UyVRUhAGHrl60+MM6CDZjNVEbeQO
	BKIF8rLvMOhwesQQhVfBM2LONTN6zktOA==
X-Received: by 2002:a05:6a00:348d:b0:857:7337:5dbb with SMTP id d2e1a72fcca58-85773375f79mr9928458b3a.25.1788005620844;
        Sat, 29 Aug 2026 05:13:40 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8569f984f4asm1439527b3a.15.2026.08.29.05.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 05:13:40 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baohua@kernel.org,
	qiwenjie@xiaomi.com
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context check
Date: Sat, 29 Aug 2026 20:13:35 +0800
Message-ID: <20260829121335.3491374-1-qwjhust@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828181035.ce6e23970d37e38b64818f10@linux-foundation.org>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <20260828181035.ce6e23970d37e38b64818f10@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F427160006
X-Stat-Signature: jt5yqsdwjkh7f88p4naoi34zpkbnsspr
X-HE-Tag: 1788005622-518474
X-HE-Meta: U2FsdGVkX1/M/cMH/gtMb2v9piObxmUmp74uqUYBQt9y15SNKCoruh/SXZfoumwGP3IAPdPYJacRI5IoNMkrOqCe4xhbslQjXhbPhf/QICYXxlGL56ocwzz6hbXb7TIMT6bfBH9JkKCD1cLONmkYp2cO+Tws0bIJWk75TnKrzMF/ryx5X49DuhsJOpQYsklzjaSf4bLsOfkZol3qC/ap8gnWGBaAS9njeJesgCSDhAIzmc5elFYrKtwjQEYxQC3krAtF4UAfbvDavasDw6A0G/gPiG5Mn3S9+o1N5VCx705P+5CqXDMy9XxgP52S14svLLfYZv4B5plF5wRJ7GjqxYAASQjJIHPF8MTapHf3qfZdsBB5hy3hzvAaZemccKduPYpK+tpW0Mwn64ycpjJZn8epvYv1P5yhH1fbhAs8KAaL6NfYNv5oMkKGDUocvcPQ8KOXFJicxr6r3rXJPa+EgUufsiEUMed2HASKfFIVC3AyP+xPxFYWDFgzJarxEmBo8uFOJVrgXbNZ6ivqkzZbG6V8bMFs3+XfTIqmcQ05NzvWVl5j9MR1D19B1ef2NYmbncFMnFgm/veoibWRC5juULseKQG0WyOdgnZnbf+d6lRCYhiW5nn8RndtmQTB2t06UzfFjAifIN/VlMRFEpRWlMqfjbHGRqeUaCNvINzGUtr95KPqvPeOikye/miISQj25TQYlPvpr3AYfUVJ/zbA/P1HjzfggjrWVdGpm9X0SqZxUEdq7NrKU+RbwUa/p0tjbBiScdRvKBSNBiKAM1DnRzMtUCnYvK6T5A4blnIK5IJZsWIdb5zG4b/vAnFGq56WprNR5qx0VQsB1DrEeQUfHiE5QuwAhUddbliYzGuNcv6xbWxKfjzOp6KXhuQjDIbMVGgo7PQLYe+R9kW6TFhFxyK/AZis34EhY4FGOXBY1P8VT2P/6QXsT0uSs9he3KmZw2wBQrmUr7Vnt2fA1pZ
 rEcBRPCK
 u+pRq372pIuLQ+Fp+3lm27mVuWePTpHJ0eTrntyIoI9CX+oYUJimylkg3ECsF1gxZo9pWH8SCdsaC0aJdPsZDAsPBYd4hEuWxF52eAzh0xGcQGNuAYfMWnT4ufyzrvw3oYiZtW7/YG1vpm1RKiGyCftNtKp2NpgjZpS5KYG5iToGBwZntWoddvnUuenW8E4QYa+LqRxfhkl6xPrZ+aouJwkvgLG1kFMVPY8RT1+YNyNY6BUsxUezHrvV6xItSa3lZ/dwNi6Au2VhEqIQ1XDoS2s7uaxDsLrQ+2Y9pqaBLZT9lFJ68CJo/leMrOvjyjv+hP1dDflwq1aydQtZOzc2PzOk8pMyBcoAZdvhAXEJJxqE3V+JTpvjdb3GvBYNd9Xm1ugB1EX0JKuEDiU6tKiTBpNe5RAZ2tAnkdWv5RpkxxYfYDWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I kept the helper private to avoid an MM dependency on <linux/bio.h>.

After looking further at the mapped-folio case Matthew raised, I think the
better fix is to retain a dropbehind folio once it is mapped.  A mapping
represents a competing cached user, and retaining it avoids the sleeping
unmap path, so filemap no longer needs a stricter context helper; the
existing in_task() guard remains.  I will respin the patch on that basis.

