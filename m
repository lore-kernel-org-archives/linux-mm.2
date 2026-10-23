Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7952E606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Sgj7wMmS
Received: by kanga.kvack.org (Postfix)
	id 729FC6B0ADD; Thu, 22 Oct 2026 23:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4306B0ADE; Thu, 22 Oct 2026 23:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E826B0ADF; Thu, 22 Oct 2026 23:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 285DF6B0ADD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:49:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD96C8029C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:49:08 +0000 (UTC)
X-FDA: 85352510376.16.91554C7
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id E2B5C1C0009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:49:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sgj7wMmS;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792727346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Wwj7dQRGUn6heeFZGN8mfvbPjpdUjCofK9/xXySq9k=;
	b=gGjEqs8iJtmFu2kzLr+IMSKK5xhSfXs34EtQpkGb0I6+V6lSsHPESb/4XMHkD9ERsxtntS
	ZUlul08e0n1aEAAxqSzm8efeD1kO0OJAYC9qbtoefeTraBifYYixmuHfINJxjS1jKYqCzB
	GFGLGVQocbMhwqEbd0OFrLlX+c8f1Fk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792727346;
	b=K+5O/EuNtwGuMYlnAtX89xZCKxYqtfcEPbPRwZTkDEm/sBSZMtgNnaGWbIp57GKmTi2xoP
	2lNAz9pidQpgdwWXZ+gXok8Ps52X57DLvdaPwkby30yKrsV2bbM7Pt+NkyU8rG7C+LNumk
	8l7m9fnm/tySHvcWX5xj//qpC4eMqNI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sgj7wMmS;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6798af41644so354196d50.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:49:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792727346; cv=none;
        d=google.com; s=arc-20260327;
        b=e/skvMCxEi+8UwsWl93irr7QhI5yit585gNVWIWKspJelsSQEsdjcHI7jjlKiXDzsP
         BElIeViVMh7vPbu/Z4xKdtuiGqvskBLLTih/UktHG+1YeZuPW+3nsBxU68sOXIxKntGv
         S3FHGLlB0TcB+VWVZeHreSMHjM1JHlRt8AKuW9c8DajzK/aqktwuh93WnhzV23NeX4QC
         FqRldqTd7O98OeZ8D4KQ2TzKCzQLP4ZMEHTyGGkjGrBzHOHTmxH9ojN7ILzPAccSDhRS
         DG39RbaQzRK4bJIoH5q9eDjgx1sigXP5szB280m8Ezl2X604OsCOXyp3xwvkXRINyixX
         a5OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Wwj7dQRGUn6heeFZGN8mfvbPjpdUjCofK9/xXySq9k=;
        fh=yfQQtM5LNu0N8GADh5hsMGtHbx5xttmolrRjHZzDIDY=;
        b=Y+43Tp/9qldQGW21Ivt74AGwbcLHyvMQnvyXcVoM8jFvJnIVbepZPZPYu2Byt/rT0F
         x8ZUGb4f1J+6vNEWIXwGMcjQeT6J0LUYAHrdERMTyLMeoHwZvGk5+zCo5ne4An1a4Vfs
         UMtpV4cifQvZfJeQKhhk8Zelo/iENEBfhePxOyfCzhKBtBhXjM4EaDpJ6zZ1YVqud3u2
         vdXvrh9SQtWwPCsRQFmeRNjvQ0XWVIW+Aa9E6S/n+o80LKpalBt675AmQOF8P5d8GIbT
         hxbyzeOFn6a/QxYTYTO6LZnfej0kPd9b7LMK6ffrJcwgXfkxo7VKTo8QbJJm8xjS35oP
         a3oA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792727346; x=1793332146; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Wwj7dQRGUn6heeFZGN8mfvbPjpdUjCofK9/xXySq9k=;
        b=Sgj7wMmSVjCgM2c9fzxcgWizLxKLz2r2XuTS13vqox2G/pa0KMFnvY6dHT+6FN4dMm
         bswQL04UIyahyyESwDeKKcfKpoZweSJ4Wkxvx3pts0968gLL/+1rOf+38dOsFSAieVA4
         h2uEyGeQ+rR1MbQ/leIacL8YLXzIAepJWki3z2CCKtqcvMGd92/2IebQCBzyLfM9izIJ
         slZ6KKRnTOrMwPqWx4F3XrTgjMKIlbDBKkcYO0vASb9RjaLAEDGqv4CdB1LZriJqXJNu
         VJd8mba5ehfbLUQnNP+8q6JzWEQUaqW2QQB2ICHadZzjKyq0U7WG+3PvyNMHorMUUZHa
         tMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792727346; x=1793332146;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Wwj7dQRGUn6heeFZGN8mfvbPjpdUjCofK9/xXySq9k=;
        b=XjfNq0WVVf224Fx/+o1YJrvD6E2WUKFC2vOcdLT2DNEEOkQ6lcO1eQsayuc2ZSr7zo
         ugh25/R94UA+bBs0KFlElDWWtQaouDeZ0Rpc25bWtswLGcJqgLDjVXRZtUm+RBfmB6xi
         kAW9NT3dpiaqaeXnzraKKHW8rnmapUxdLQMLHFh+BPDG5Iq8pAw8ZQmoPrC9DG0NCS23
         fRb2qwxQom0HepsHh6Vwesof9g0VkUK6O1viokBBfuaAXU0mUyLbM5dV75PzVDsTW2MK
         7+QIohuZrDh94NyI2E79XgSiPa7RQCW53Tjyum9WADWs0WT5eH1PoOio/mbAAKBvQ4qT
         wXnA==
X-Forwarded-Encrypted: i=1; AKwUvBwSrY/6eFA2rk0ZqfR6nSF0ZWQIZeN4ZxuEhPOBGngQVAQ1am8n3VF42JKWBf6Bo07hhbDqfELRmg==@kvack.org
X-Gm-Message-State: AFq9FYLKvXuFVUAT2/Pu1WUWLOUR1IPgOd+++RmJfi+Ez4C6SFybiKCe
	HV9gz21qDfpduL69SE+oRCSmOWAIthklZ2roCsoj4NluUt+vI5avf4wPubNhyVxpkKblyVtRPE/
	4nNIVo4Kge9juxoJhBGcUKTICS43UB04=
X-Gm-Gg: AYBFou1VvGz42uN0gMR/sUCbk36o7h+7A3FblOTg8rRdWdena/FmQ0xyhZybA1xytcw
	VRUxkrJcxK6JlArLZdntZZ4cHJt01nnOkWiO1Pu7Sjj0Y1Rq3TyLiBPJrd6mmrmswXTTT2ibnYu
	x2ovEUINy/5sJnO1FCtjyrN89Eo+OkogyvUa2LDSVVSu0++mue/0BLzK6MQOWwwhMSNptsmdlna
	dxI6Zn/ltQsKxufxhfyUkqGNmR+viG/qyt7Iul286gD/pgNkje0msW31lQBjKbVuNIk8AUgB4xg
	WEChPdj7Y4rjXBsu+oZ/BCa1cNffQqF6rQFrmQqPZiyOTu2VjNbqMdc2cGwpT1Aco+W4TW6EjXm
	9EjTTXcM13dmo81JZ527Uq+ZdOxd0oedBGedlcep7NlD2asKEmKlW2ZgravsCsJ+0W+M=
X-Received: by 2002:a05:690e:1382:b0:674:a7b:a07e with SMTP id
 956f58d0204a3-67a35b3c8demr929504d50.29.1792727345866; Thu, 22 Oct 2026
 20:49:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023023226.29783-1-laoar.shao@gmail.com> <atrUeGPZgoSACpOR@casper.infradead.org>
In-Reply-To: <atrUeGPZgoSACpOR@casper.infradead.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 23 Oct 2026 11:48:28 +0800
X-Gm-Features: AclHuK_M_4eAwVRk8vzgCcHkUZzp0EtL8_NQcauXWIU3U6Rg0QFKDzTk3hGcnwU
Message-ID: <CALOAHbARy4pSrsDLmTfntdsWONETqPrGJM+g6jM27WWnc-bCAw@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate: snapshot the source nid before the misplaced migration
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	linux-mm@kvack.org, "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2B5C1C0009
X-Stat-Signature: xt6cixajcqnpbboar7udnu4kfq4o3jp3
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792727346-467772
X-HE-Meta: U2FsdGVkX1/NxpLLGHvzE0xsYOEevTIP8vGGRki63mgGHVVmxi3GBSSm5ziTqX+532MFJgyDVraDWiYrX8kEHDGOxDxz/mmHRrBMe+Fir6zIXS5Ohw1ZAXFNfQSAVgHidMShueJm7XkgOaKrgOOuSzrFfCulHgwY3kFFe48GeEHJpv21SgCY53BCLXEXLSPWWQEUQKltrzsYEPNdpLlppYa5c71weIOzMEs4/NqQWmFODKE55g58+RA7A/i2FcB9Y5YZDb8mDXm1RjWISIdCXmclGIUP5ieyn2VmKzn8CZBqh7yCEjrt1ULsv2CaxPnn8n3VzIBeawMjM4bjlqEXPJ9n/iqnCtf1bd52T8hykK6WpCL4YuGTtQHzAchJR6r8YhIKv+gLZVy4886GnD76lHbNlqzx+Up4j6MdO6KmPb2q0EaQHYMIUjP8hmpffczJCwGfYnVnLlYkdLYIM7jtIcr1yxEEECg0OvW2auHPY7pI+KJ+m34vxfhOrfK4njs7bHNmJzKkswMqV5FTCrUvAWL4j5av/0s0pXxs5IcUd18QZFj3AHj4HrCWbONeP0Wjnq1NZz2fDm8Bx58H9dgGXgSr9qMPFOTcSkrl6IF9qi+dUdJXH/TiyhlFMdHtv/5KofSVyglD4WpjUP+EYJZNAhvheFyTEbHaFOaJ6qUXnIUaXjqWHRWdHHIgMgKSzeTWKwM3SCzZn6K3yc/BM+SPS4mqBnJBovkr93CUc12VfoUgPwb5OI2M6qqfsIiDTAQmoR4HWt68BAh8AqtTvmfNKrGnarDnwefcoYXEfeA6VRMRGAiPKXNDv6OP6cNXfAnpjfmdr/k8g9pMye5gGkg3fPauNG2+kWqz/zCrtxQdCehdAh2M6F9EQe1F+hBPRhgHQqUPZVt/iDk2QsvsWytpv4Dq0k0KicqPOhuypDktOuK+txUz2rA+DRemnsMEJTsKywZfn+PKP4RTSE+BeO1
 Pc6C96cQ
 g7/DGr7YSgP3qQ+CjobwnAIucJTGbG4JsT1PCsmgCJuZrnpNBo0Ysx74VyScSEbS55jBFkzbT5fCoRmwb9BHRDW4ME7LAMbnwAXR1hh2I2hIqnTqXcNkFhe/PXKF3xCDLMgl1CCMm3niuc7UIws3fky8VoQ2u46tLGjeZpktbiFE+JutOUxfpWhWanJKjUYnqET/TSPacvbTkq1TCy6oVm1pTVtniRK+k3jqE2yyDbk77OvRllr0ivMgIU7Q2GnK9VCfQD+WvgycSMEmMlHY4iSIGll1m+m1/4q6hwPaOUtoQ0ZSQkwVkZpZ7DBelslc1Pkdp2M2BclSOzxPqKA64m9WmxQ+4L04v6iiIUG93lvnOQ/NXVuaUHbV+0IfuBlKNxJchbOBPsrIUK2/b+X8AQESMgpsS2Y0KVsY7LGvOs+jzUnJlrb0rh/dzpVCzeLbfz7mZoqWpl1hp8ExeWidw6LOE/AiLSaD4tNcdQQ144+5CmHfUexSsGFGDwmjf29afrRmnAFAJjpOXvjfZEvsnKUcfuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 11:29=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Oct 23, 2026 at 10:32:26AM +0800, Yafang Shao wrote:
> > A successful migration frees the source folio, so the folio_nid() read
> > in the promotion counter update can pick up a reallocated page's nid.
> > Snapshot the nid before the migration, next to the memcg snapshot the
> > function already takes.
>
> I don't understand how a node ID can change even after the folio has
> been freed.  I don't think this patch is wrong, but I don't think
> there's actually a bug here that's being fixed.

You are right.
The node bits in page->flags encode the physical node and the
allocator does not touch them. There is no observable bug here.

--=20
Regards
Yafang

