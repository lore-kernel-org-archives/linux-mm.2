Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63956C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A806B0092; Tue,  8 Sep 2026 13:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BCA6B0093; Tue,  8 Sep 2026 13:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A696B0095; Tue,  8 Sep 2026 13:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 321706B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:12:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7C2E12073E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:11:59 +0000 (UTC)
X-FDA: 85191237558.04.685B5FE
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7980140007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:11:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SCf/Pb8x";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788887517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbN3NlSht2VbqNXj9ZeLJWGV/jhiHsfZo6fQ2eO9Ntg=;
	b=EdiMTqP8Bg23B7pengblGc3zYu1Dv+yCDgHjP1gAzJPaprE3R0i/X8D7o/g7o8r8ZascyR
	WVLDlD142fTYv2e82PBmFMtIwRWbrfWRk6ndUnxzwJ5gX402J8E1tLEVW9xBJXEGYIEahj
	GOMnSqewMnTBDepsGPzFw86gZ5hB0VI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SCf/Pb8x";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788887517;
	b=RphswXNCCqYW52VkLPquZjZu5ZI3BHFX4nLyCwSICxrpBESjrPctLKaO8REbFBkwDb1Qcq
	ayjUIC3zhbFWdYh/Cq/R1bohPYRXS2AoUv/6xnb8J/zrShnexjVnvdPFC8uOZKpC5UtQNy
	LtmpUdKV/ESbVVEI+T+6WgyaNXYXmZk=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-482dbe4d247so2719692f8f.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 10:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788887516; cv=none;
        d=google.com; s=arc-20260327;
        b=Ez8+MTk5N0/SuPehlgEi854LkiSv2KttPVaHzWrzVgC6Za14LjGP5jqrjS5DD5v+di
         yrnpBdwf1Fb4JuPzDEMF7muvyBn7e454umpa4pkiwjP46F9mYsr8by0RDLd7otNKz0L/
         USyFTWzi3hBe2FYXb9czOikD7r0vgHPPLMZzMS8veRKts1A2/y5cIQAXQoup3fBoNl7H
         xRr15cq+pVst0Osj/86SMF7UQKIjmAnVP8JvfumvB9+w7Huno9+MaEfQE/It4Wtd1kGV
         ItjeFBBVx/0/HdWpUjFL+3ywAB9P/qjdLBliyalZ2bvbojbamYXh92NUCOIcgaptTyxp
         gIug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JbN3NlSht2VbqNXj9ZeLJWGV/jhiHsfZo6fQ2eO9Ntg=;
        fh=tmyoipEV37CD67f7LVydid81YG8KEfuUjOle+Ekz7gw=;
        b=mOjhEJa3DljEAfUT6oxnw+h5puYCqLyyxOnpfX5OZ3PpXZhCjm7X1a9gEUOusZ7LYh
         QqkN77I/XsR1Lm3qRHi0EOkXxvw4Z044Dcb2jK9z5FY8iBPinyAiFxj7xWEOfySZ1WT3
         37RXEEQY1jXwFS68yEary85OgDQcfex+KaNVNQIruouhsEpeOCHJtv/WRLNrsWLIhzY7
         CKc+ClN+UWVyn4MqiRlnwISVqsQjFRA0KslxJGAtpaC3YXy6Dc816ecxgMdIoGr85kGS
         aIec8LbVHsPZY+RvvywbJMZat0Q1QmJWHEgtbeJVDCK7TdCEO9p0dNDRSLCpAtTGaqF/
         ZzAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788887516; x=1789492316; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JbN3NlSht2VbqNXj9ZeLJWGV/jhiHsfZo6fQ2eO9Ntg=;
        b=SCf/Pb8x+yXzjb0VB7FhPY8k32BMEAO0WQHBVnLg6DySHNe0Hd/2Cop7dUCausEZ09
         Np4lf5lm2f0oPJdbRszQTDvjl0jNOOIu6mNupkE8IaHkRk447eBVjTKMDMmAtuH6x023
         T2fYGrETV6N95ysDyhSa2x4Zw0CXxICjqutwyMeIicqdYSPprlKuOzRoQAkCMPdw7Vf9
         IuNCC9XnmzB/5wh6Ey6nv8Q8UqCRjX0ka9DKWEeSQG9L2JPa1Fb3s/wMp9a5eeZUUuhm
         BG3KKXCeWkrQMuiMJNMez8QWOQJQi7Zp8vjHAlukjVtLuVMYoiCKiixW/sRkyCE8lN5f
         dHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887516; x=1789492316;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JbN3NlSht2VbqNXj9ZeLJWGV/jhiHsfZo6fQ2eO9Ntg=;
        b=Ol5wBSCq8FRYQic3BrjVu5aV9KWT/vhDZwLzeHFZnxjV9k4oHcbiq+UprvBUHUVV8c
         4bpNxciQa0F24PHidHF7apWxJ9ORtRbpG6DmsvxjEUja5SGMxhO3Stui4odCWb4lEkVe
         BW7LD6u4cQbRZTx1Ydu/l2KcQ6A2xsyKzStvHdCPTmcc6Hl6ceHnxxfTuGpDElaxYjfw
         7pHVx8kSWODGm6oiKCs5Nzg0h/pTlX79g1CZnQbFDeaZ4oA7AwMKepmSduwfMUYSGXDk
         Of9p9kqXyo6FCiuabut1vF0XBS3wSKrT+Aj2QOdJxu+sKEXbyX1lIbtrs/zqDVM/mUKu
         fIuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSP4Rm3JltN4XEt2lYx9b2tUpl2h9QazocsQsr1LKh2VJt9QnOy/k09jfa+Z/G7mWoiWJKoAkiIA==@kvack.org
X-Gm-Message-State: AFuF++nJPI34ra/O+IpQ8sdVpXn4odCyQ2v8OqERSkOqGoJfJd5ygNp+
	SWqYkDsrvP/D6Q9gGLwWRyN7l5tYS+KiaYiFIxsImnkM2L+jadUSr+E/DMQvXJktCd3BIB9Jrj+
	0ueTd8Zpi2o5eIU/2cVq6DsAfU6wSjB88XE2Z
X-Gm-Gg: AYBFou2P7nrswh0aHwSP3ydZqe678ord+uChq7Tl/NFmt2jBlujLZVE8eeIwWJjLd3D
	SwXnDaGTjZft/dVn6sWAyUV+BswYF9/kZ5TrPsAEj009GLCrwq6WyxFsnLwMe0Cal6nHG4hd3K7
	tKJR9GEuxbSOCQtOxogJBs+/ISWlfNzOPoD6lSk/ueHaHOsjn5vPEx6kbejdj1mgrgyM8BM+ut6
	ckvDRxk5VnV69FgWBWr2pjeDAxy7zCP7Kt1/2zWnHBu/WRtPwh3jfq/gEvHCPlxbITBnBKVUfnr
	EO5QmVdH7IXgFnKR+HHEZ3XfzPYP1XEWTRPw+zSx+XKmKxknPLeEqzVrVnhbrqP5AgJmOnSUAJ7
	F
X-Received: by 2002:a05:6000:2388:b0:47f:9283:1fbe with SMTP id
 ffacd0b85a97d-48586bf25b8mr58778399f8f.0.1788887516324; Tue, 08 Sep 2026
 10:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zMhs_DQGah6mRfh2=Q_9WU4tm7SsWWGguUt4h7mXiOFRg@mail.gmail.com>
 <20260908012801.1864430-1-xialonglong2025@163.com>
In-Reply-To: <20260908012801.1864430-1-xialonglong2025@163.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 8 Sep 2026 10:11:44 -0700
X-Gm-Features: AcwNN1VdBkSgBZ-mj0Ebm5R2Qbd2WEyMj2rkIN9KM7C3VNdLM87lpTCQ2fxYk4g
Message-ID: <CAKEwX=M3axD3g2d4bT20hiicz6D57hzV6TGRYFKdd9BonoH_Kw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: publish the initial pool with list_add_rcu()
To: Longlong Xia <xialonglong2025@163.com>
Cc: yosry@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org, xialonglong@kylinos.cn, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: dyu1q3kz4csrpbfoucm71raoupzfx4zt
X-Rspamd-Queue-Id: C7980140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1788887517-999413
X-HE-Meta: U2FsdGVkX1/ofTEY4GISvx15/MHND580cmLh6L0NIaaFYsjN2m0YBShz/uIi1gvXLZwL4QArXVcKwoQcOo7EHlj6xe+SOa3xvLuQEAuZg9N7ZY8qjJepNOc5TklomhDuCj0hyK/pOT4625FyWlJu21tCMCLSM0Hxrsrgseor5lVkU6xP7U2G5ulhuRmZ0Tr00Q2prJbNPDGvwKetoUvBNQKhJvQGCmNU/JtUe27dVpn49rZWdrjUanHX9tZWnQMcBGSLPiKQRkZE/y26cYij3iQkvBR+Pjx66dGy9zLsPLHa0i3eNRw0Jl4Qd1OVGhbU/FCnAWNN9OrW2PHnYHl1/ke3KzyOIms6PmmRZshYP9d0oA9MWmjgoh7nYN2vpbVWdFahwggMJAgyp0hxx9PsCC3k3eLz6hzXkJazDFOeONV3UbASuXtJbOztcDUo9mgGrK2xD9v4COOuQkNV27dA0Xlj3TuamdcFH2d63skpAvoas400YpusxdF802JQ4RvhoWWLfZbU3Y5BcnqFHqvTFIDafeATpBB5ubRyTLEs9Va8XEZYfQ2Bqm+jYE5pE1/mVkklK+mdtW0QvQhJoZJtyp+K5oyVCEipzNHPout1PhoDJzLIaJbDYey1aLHw33HJzRI41WE2FNcoWP4umTry7xZc6uIuqcKsjfSwoCpss1cVRkBM3fnfFI9mZJ6YsNlpM96OWvE7USDLcomZkcbauuZQ8K1rIUi9PqcxXOGM8dMyw0S8Ja1M9HAo7lujEGzhktsPziUBmrDXQiRGaTrZF4DYlHsC2Fv3OCoQUhEL/YJpxa3/Tt7ssh/TEkhHdb+eFyvIOEo+FPsrExKuv5fB/JBxdnJceMVUkHWhR978G5dK9v4tyZ2gTuNZSxfRDft8/8aADTOFFk14TnSL+zVmMYLRdStIvtMxe2bmh29cRwq0gQE0oqF1fpYcaUlA6OQbPb24oJu0zh5nWDuS9AN
 6DqldH+M
 CgYToOdtzhNxLuB3mS/sRGS9XOf8oEvzUASZ4jRWjuQAX2BKMgPfkzWYvyVweeklTm6Udpji9+Hj6doAz4Jpp/3vP7bKlk+yLvzsITPSP5a+C94Njd9Bk9mJuVxjhUB5KzA7615gsmQ+IvUmXbIArj1Iu1YnaYzKgdCkzwMFWK/F/CP7l1SbV+mzg9bfrmYcWhKqoWb9P447DptZcztmgituEl+lyNF4eLP3r1atv7j6oFO4Bp4R5fNtHNMPyVsdc2D3P5RFz1x0Gc1hgzYKEpkBg/eRJB4hK31Vh1iWHyPjh8Bd5FsTz56694ycySXkQVVwHqjC0kSA55EvICmc3ySD7ZbTf5wK2NTzrrNXAqFJZkInEXi/kyTNABHbJZAfJwZg7V77AWPmpN/QalYpoRO6XpL/Nj6ojoLCRSbNiWaTP8fXkuJymYpBsN5jBCOZ7wkVBqzSKVcWkzfpkV4ZB50D/ilhtPSIDVCDoSH9zi9GcyR2d1pRCwEo0Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 6:28=E2=80=AFPM Longlong Xia <xialonglong2025@163.co=
m> wrote:
>
> From: Longlong Xia <xialonglong@kylinos.cn>
>
> zswap_setup() publishes the pool on the zswap_pools list with a
> plain list_add(), but the list is walked by concurrent RCU readers
> holding nothing but rcu_read_lock() through zswap_total_pages(), e.g.
> /proc/meminfo and the shrinker count path.
>
>     CPU 0 (writer)                          CPU 1 (reader)
>     --------------                          --------------
>     zswap_pool_create():
>       pool->zs_pool =3D zs_create_pool(); (1)
>     list_add() -> __list_add():
>       WRITE_ONCE(zswap_pools.next,
>           &pool->list);                (2)   zswap_total_pages():
>                                                 pool =3D READ_ONCE(     (=
a)
>                                                     zswap_pools.next);
>                                                 zs_get_total_pages(   (b)
>                                                     pool->zs_pool);
>
> If (2) becomes visible to CPU 1 before (1), CPU 1 finds the pool at
> (a) but dereferences a wild pointer at (b). Publish the node with
> list_add_rcu().

Acked-by: Nhat Pham <nphamcs@gmail.com>

