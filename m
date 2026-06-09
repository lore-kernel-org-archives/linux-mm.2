Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA78CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC8C6B0005; Tue,  9 Jun 2026 07:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3EE6B0088; Tue,  9 Jun 2026 07:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11196B008A; Tue,  9 Jun 2026 07:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2B496B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:27:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BB5A40544
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:27:28 +0000 (UTC)
X-FDA: 84860148576.13.E03A205
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5082D20004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:27:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFXve4yO;
	spf=pass (imf03.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRzrIj77L0zVy+UX7XtTmfveLp3SQGUbaxdcOyZ2jHg=;
	b=zsRFvPwcgHVN7z7i9Tf/8NKEykNpwYFFuJlUIjG7MlZUjA06os4jI41u/aPPey0lSYZrk5
	7gZMo96LvgzB4X0P6LRUY8JEjuD8a8n+F6DjUjasJNH4myoamuuGyIj+v+dd0R6ZkpcLlh
	MoHPRjxKDPhGmHybGvrwTq47dQIF4eE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFXve4yO;
	spf=pass (imf03.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781004446;
	b=Oi4F1QknFAd35Ghp/7JEsM2v4YRxlofPUWk9EHFrCfGSQeHYNJFaNxXBzVxuVXgDXH5Pd8
	N7bVq5xVpszsjhG2BZ8tacygCJZOsh5xg7UmfmKDzBmMoIeoa5iq3FDqBeRIdtp2/EXz4L
	baui05uZHzpVU173KyDBcHDv/U+SbXU=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7e2fc11088dso48682547b3.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:27:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781004445; cv=none;
        d=google.com; s=arc-20240605;
        b=OrjuGF4q/amacPdLjEiP7cvH5oo6YomRr6KUSRMQBCGTJXm/rfs1nefeArUB24B0XH
         5+1w9G0AoB18LRBIJigwLfNCqzzACeol/kkFt0PCQNfiaUnqr97XLqo+EjsE+Y7QitdR
         AGRBO5Q4WxBFIZj8ldSfFesA0WJ8hYm+JcElDS2FiMVvsOskvKqTxgUqqkUi0to9eMim
         QQUj3X1nsuhjIFoSkbXb5639b3zL50xZJg9lzwo9YA5i+pJf7/JYOjErPvzOWDYJX0XS
         +BIhd54TT5ahYwwCMg/82BpuizFwWnkZm/jE5dTJew6cF2UH+PsuqREAQ3EDfEUq9bkj
         OlOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xRzrIj77L0zVy+UX7XtTmfveLp3SQGUbaxdcOyZ2jHg=;
        fh=D5/xL+61VTDEZQ4Uu3x4POaMpDbJn9g17zo6//nRfJQ=;
        b=UBjPmf5WJVOfbdo9bxRRs4+p/QEaW/1V/mxzWbnWbMtdQfbTBueWwNdjq01n9KH9TV
         xji0gf0QwO4fsUyfA3h8ws5pBGT8NQcG9ejqFbx+1Dqr0BU/XNKXqPtSCDXoO/dzsCh1
         h8dRrQ4Y/bYPaesRVNRFt/e5UmomSyutabCx+kcufqdc7G2tWdj8XLp+fTu/XCX405sx
         A+SM+Cbe4a+Y83Su1AeW6/Q9IdbvulbArM5dgEeT7eWZzxSTGv5fLCGWnhxmWEZdmj/W
         PcHXhY4jq6/IgmrFATAfdNhn78/2pghMY+MyU7SN+EABOF5gww5rvXMfAXHLkVw9Xtva
         TWlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004445; x=1781609245; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRzrIj77L0zVy+UX7XtTmfveLp3SQGUbaxdcOyZ2jHg=;
        b=TFXve4yOvezUWCLL/Ay91voTa1w2MFmK9q3gRDdyzgVfY8Kv3MJMnwEPsANXhIowSO
         uQZVL/DPoj7rJBmKsyqu/fvwOhtE7qr74ge3I9i+NMeEFv9Yk5/IrVzOJ3oekshK1kKX
         gmWlP6YUyw/NqwtmgQna5YP5yPU4q1jNQ88MCMXcc7EPw49gCKo9rQb4UgEVzoweMbQx
         2vAhplwENo7WIySz/zKNUqc9WqG4XqXKpC6+Smqp3EGQohEDZd/smy04aZ9LTkuErJ8q
         slHAjpGZ/suVlmNZbeIt+eXzr9PWYCZRauxM1X+ldOGhrf6PUrTnwSVUv5HoQ3ZLLSc4
         9SwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004445; x=1781609245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xRzrIj77L0zVy+UX7XtTmfveLp3SQGUbaxdcOyZ2jHg=;
        b=ODXZchibuTlMMMSViHbwnqRjQjgkq8CUFWZ/Pu3TYOdnjI3zBF7T4B/7pYjxuy/OKm
         o8YjN3Vq/fwGAK8nV39LJV6jb115IQa35WDUkcnulymOwr/Mysk7zmNGPuCeg8ETeHGo
         X1NtqL54TnD+Gbl7Ypk336RiekSs2nEugK697N1WLk1npMA/DYsVcD4rOHRUbUJvWzSt
         NQ09lyw8ivtKg1GeIOb4h+zOU4hXhPZ5MgWNldgGye/20PfPstX0MKMN1Cs2MAwOZWGS
         g5yA7XjTTdX3Wgj65TwE/+zVHWUy7/a7lzhOp5O6Ca8NjBGgKHg/y2Yh+Wa7g3+v9xTo
         3wlA==
X-Forwarded-Encrypted: i=1; AFNElJ/yNs5Tzyo/m+DKbae9Bs7bkGEVvaMT+25/OGJTs7UpFbbiOGxZKs7iTjfFsF2gUvY1onFgd14XiQ==@kvack.org
X-Gm-Message-State: AOJu0YyhJosHFeVqz5EJfvw7Bv5e3kOzLXaGKusrPZLmjhcVcRHxym+r
	t2aB2NzsG5NyoMUqYkeZym93kWvzkayxGfdC7Qn4aDGwT/zpivHPr4w12f9aICcAuCmaZSnj83I
	9PEn6g34HR1y6b1Y5QpHUwtAgZcKgw2A=
X-Gm-Gg: Acq92OGTTSVYSZAJVMUohI6RD6GWPUU9D7EVWbCQgnXYsWFfah3ZUYkReW8KIWH1Eoz
	26HzWI3VtlTipm5areJ8rdvJMaRT+gqiYFa/QjN6QQr6CBn5AXe35guLbGZQbD3SkHeev4h3Xd6
	cTtGYNjvn5HSwuvZy4USCgLfnulKDsf+8uUt6bQPcVugA8TcQlw5uTbWqD0ppsxtLkuI8VMyQmt
	cLnZO4y4n4tVf+h84pOMLVHrDwms1KHVKJTfCKRUSJowv/7J4/rtp3mMUny0y+5eoTneY2hGk3+
	dZCCw2RjM3aLsSBrls0=
X-Received: by 2002:a05:690c:c508:b0:7d1:c256:b5a8 with SMTP id
 00721157ae682-7ed0cee7e6fmr175286587b3.40.1781004445317; Tue, 09 Jun 2026
 04:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260605084242.1549811-1-haowenchao22@gmail.com> <20260605181931.d6fed8b62c8d91b27d151e71@linux-foundation.org>
In-Reply-To: <20260605181931.d6fed8b62c8d91b27d151e71@linux-foundation.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Tue, 9 Jun 2026 19:27:14 +0800
X-Gm-Features: AVVi8CfdXerbUrRJUJXWWm63rA7gOcgqb4-MG3fJTg2Hu5ZWYteWG3E4Wg43Zng
Message-ID: <CAOptpSPfonSY+HUZD8vRgzg4GE8E6-iV7TYLwYXDrCPDrnxw9A@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] mm/zsmalloc: reduce lock contention in zs_free()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <nphamcs@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5082D20004
X-Stat-Signature: 9p9fer3gyo9z6h7jxwqxjriq9zaeism9
X-Rspam-User: 
X-HE-Tag: 1781004446-697256
X-HE-Meta: U2FsdGVkX1/Gza8rXR5/tbXCD9ZvCFBs8votEohBlyx+ou39LrkjwKAw29UYz44eX5OVETnyzRlUSKeRk+WikeLE3iMuSHMAFzjFMXtjHfJbJP38CGXqbDDdybqyV6V4oM85ISE+VbtPecVwpKCli3krq02OGgyAzzGERrdps/KQVNo7OkswZW5pYQDo9IEP9uv5dRUe1E6VNfsT/3k9URGzg5ZVXfOLd5U/yvzuDFYBIFOH8PQ96qMmg0m/r2SrBdFuyu66UMQfCi9hmOC//4L30ZQO8FodGdchvQ3sVD5OV7oX2hfW6xcviUfGTfhlbhM4z+bjrtx3a/pJgG/ieejnbIYl6cvyhxAOwqmCwFjhZn5ynNzbqiv8LGLw7jM9+RdStkwUjaM4sPHPyTO43KlSWX6mvIH0auVkBsyk4iJvDDrJytExcTxRvdBWqKsRZqhp8s5sDp15wKVfYjJzFJtIh2lalGZv/SaCiOHN1q/Y7ENrtaCdQagw2dm9lSkLBMEsRu7gMaU2VEO8IFNFTreUsTplWjD32TG45yX40b8y7uOX2QunqNA0Gj0jWaN8+Xwmse6+uEoWRGOmhbUUKfWwY5E4yloWmcgtvfaRhjr5MjNbZfuxyjYIfzQakcD54ZCWNR28Xf92QRhYhyCFJje1dcmFwHeUpXCDOKjTXgJZm4urxI0AifFGLmWrpvKubAVTWIMlPy2aDAq+X1gTYDfphPLOXesfGmH5grHwql6AC3J9I5DcdqSCIq17Q2tywwnWnOb5GIKlmywK/tKB62gotRirGd6PxMZtNbzFrbKH+ufcl7ZL9uXsIxeGN3bSe/7gCRBxp20rcDBYMdsKWBR1AiJGrMu7GXF3PCw5TzdshE8AsFYsAgwv2gyRgDNw4BNpUgq79U/boHeWwKJdwP2pK2PcEZd/uBmHhaJDBldAQlWo+sVAXTfw+FPhtDaSGkJU4wWLbBe789xkWO5
 ZPaAOtbK
 SAyOfEpiWvBFYy2D2IyM6uh95Jtfd6GluOIqGypGDaTtKMdT6Zb4ksuorfzA8rksEtlIaewrhBL/hqKQ6N38rboX9LyEAPfnklCPlJIVBpc7/r0yKQX7xOllOd+HeKiy8p7hceh5BzMQZtG9bd8ecpaThAUS8JWACyvBw4QV7c8GHaXZgqx6ToouEDzHpNVFMd6Il4KEJ3DzCZI/G4JOLD7VEhhfm7JYz6mDhuhBjtSBHpNrd41GHLDGjmUKdJgzC7SY2CcL9VBMf8erspiqpkwRhhYvX6KaZBjxwyOoRTonPK64bcIiylqnf14jj52W7XwxEuB6seCQN/mvn+cDUN1GmecLMg0OZ01wxDLtVjDGxXgWAz0pW0HPWNh7XM+T4YUiXhAWapua3HdwePBZqF8h801ecpahz/APT/laeyob5Eh1d4N8bJBdKYEjK37xXcBEmDTEEteT17o5Zu5NpBvtPJrtlrFLGMVyG0AG74438vo58If+grL6XAOB+nktVE2OBV3TbabUq3WQiRWMwIESRT2LheAS+1kd5MMIW7Vq1CEXVRdxjxkPSgOTdxPvImG6BOwb8+Ct6vc+vyykQKFPJ/y16sgniLA9P/HO4HyRHBD0oAnkA4eH0AnBfvxk/FT61TxXEZbCZZUX5J84OYc0VIJBVcL8x1jOCDJJzzgot30HQvKhWXu8tQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 6, 2026 at 9:19=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri,  5 Jun 2026 16:42:38 +0800 Wenchao Hao <haowenchao22@gmail.com> w=
rote:
>
> > This series reduces lock contention in zs_free(), which dominates the
> > unmap path under memory pressure on Android (LMK kills) and on x86
> > servers running zswap-heavy workloads.
>
> Thanks.  It's late in the cycle so I'd prefer to merge this after 7.2-rc1=
, please.
>
> AI review said a few things:
>         https://sashiko.dev/#/patchset/20260605084242.1549811-1-haowencha=
o22@gmail.com

Thanks Andrew.  Both AI findings are valid and have been fixed in v4
(just sent):

 - 1/4: on 64-bit systems without sparsemem (e.g. UML) obj had no spare
   bits for class_idx; gate ZS_OBJ_CLASS_BITS on a spare-bit check so
   such configs fall back to [PFN | obj_idx].

 - 2/4: annotate the lockless handle access with READ_ONCE/WRITE_ONCE.

Wenchao

