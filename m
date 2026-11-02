Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6744C606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 01:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iryWmJIG
Received: by kanga.kvack.org (Postfix)
	id 6FE616B00EF; Sun,  1 Nov 2026 20:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFC66B05B1; Sun,  1 Nov 2026 20:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5BF6B05B2; Sun,  1 Nov 2026 20:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 357B56B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:15:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C00F9140B19
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:15:24 +0000 (UTC)
X-FDA: 85388410968.16.28A4143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5B53C0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:15:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iryWmJIG;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793582122;
	b=XN5TkeD8iZr/rnuTuaP2G+tDTOZiCR2c22IyU7PwsUHIHi/1k50Bs2PuvVaoolsb5NW0H8
	KpBtCDZ7f9V7+zxUxhpUncUcifgvES8zQeLzSVQgLg6UhRsOxfUGLrMJRWZ9VacAYq6dDG
	NWt2mvI8CdMEq+IdvlwzDv3W32XTbeM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793582122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1ydNhXZkrpIcDabsUGByAbljSA1UVTJnknGaWqA0AQ=;
	b=uwBXR1c+uAtj+M1bs+kq6zIFPwP9mvxZW+5soJH+jLYG33nN+cR5NoRGXpnSlkk6cjCH5s
	l9LONbKJEdTPyqFj00sR0lc2vtIWB95Julw5x5bFsVqNZhNmGEH7p/3QG1qq0Q81RvOYIN
	y8BOjYYhJqLVrx5rfGKsMDFKeJzOo9k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iryWmJIG;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C224043EA4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81A91F00A1A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793582121;
	bh=c1ydNhXZkrpIcDabsUGByAbljSA1UVTJnknGaWqA0AQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iryWmJIGRW5NS4sFryfzJ4j4sdDUtwitKp/D3zJtiRlmVvaUVim+9Ll8MzJDSJKgQ
	 l1L0z+jki3FUEaJZrc51kek2uw7n8BKlJG4Hi7zmv7LzUE9YhkfrzEMAoLQvXEsGgj
	 2c/nl4rTr4bMzbAh5wprHaqDos0QEcZZJAcVoK86mXwqrua+5g8jQPTdCrL3oIi2uC
	 fkre5HfooVMlenoUWif6nF5bUbJ6pZzzR3IVlmCpksgnuOHhVUuhIxO92ql9CTrAbk
	 nl58p31kTAU9MGwpyhL9WEz+vMYeTktpVB13Rsh9M5H5ZSU1p3Kc+H4BzT0SWIZNsz
	 k1t10Cyc2qExg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93cc1ab5f6cso305934385a.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 17:15:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz2ct+4RTchB4MPLVNGdt1GYeEI5d39/y+e+Cc7WOVgMlm1isN5GTW9R7oE0/GR7hY4B0sa61QkMQ==@kvack.org
X-Gm-Message-State: AFq9FYJ/QM2Q7sjCWqMQGX6pL6b/3iGOpwcXi+xg/fnB/N73SdPMtaXH
	cCzkLYU+f+2JOUn4/GSXS6QBgYowmTGmLWQD7AvaV6wv/lrG7WNN0o39Jvb0KHJctmpvM/HIHjj
	aNIr+gAp0wfTOJBmrFIrYwFlAtyz691U=
X-Received: by 2002:a05:620a:2709:b0:93f:571b:c72c with SMTP id
 af79cd13be357-944216b818bmr1410541785a.46.1793582120965; Sun, 01 Nov 2026
 17:15:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com> <20261012205447.2717801-6-max.kellermann@ionos.com>
In-Reply-To: <20261012205447.2717801-6-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 2 Nov 2026 09:15:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wbQtQ8zfokd44_QM39J_02xDVJoeTK20+jo03_NxAx8Q@mail.gmail.com>
X-Gm-Features: AclHuK9whBgQrct_OeJcyHaK0NXW_FaGiSG_xFHphpXJFrXesDxcsJ6xBdY9ow4
Message-ID: <CAGsJ_4wbQtQ8zfokd44_QM39J_02xDVJoeTK20+jo03_NxAx8Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] mm/mglru: reschedule between memcg reclaim attempts
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wkaze7tmd9z4bd4xqcx1k7xw46qngt3k
X-Rspamd-Queue-Id: D5B53C0006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793582122-153787
X-HE-Meta: U2FsdGVkX1+LVYQW7mdiFNLhAWm8R8fr26YyDjke/SvB37Bc7yJXMb5iKyn+U/+aixzG8SvoUP/dx0APDgYSUUrdWs2ngLFgugvsfg5T91zNBvGAGxZtoZjtpwkoWiZdOSVAxJcO4fFsBZ1Kks/ik5mCbohFX0ADPG8XMfkC6vIGTyoj93vutZliJTxdDEONtzmkWXXKIg3T0DcUstcTfUiy3uUOpWVRA7XDYCOEgtNmzyeVD4vvAQJgCNx9x8842ORBj0ENp/PGnuexxiWS76gr4cGIufNNcLc0zfxo0TV/skTM8rOzv4k+ByUpypzpmwOmid4rPsPoNXcbnFo5xIkGup9cV+jFmSmh1IUxWMwRLyEjMv1p1RTW6mXKrZNZxIgGpctw4YprvsvTPZe++PQwa2s4ExzXlxldbNXPnpig+vcZJRTcdLmSWAok30ETju89bRDEibDZZzwOIq84bnMmzSk1kabcei10bAQrQULdaMmrj1PVvoN1h07FDDeGhJ/cQ7cgYBjsjIxXAdBsrTmxW2IEyl/4dIXcnnfijgxMJTgSHbnpJ3YkVAr+yaENVz/Lh2S1xWkRP9pomaRUn8vCr+v98mucbEIcHoOEwqtUZcaR4g8WOH585KHw4p82UzBE82GF9pnd1OCCtagGcTPbcXU0h5tubYSzZkdzxYKVxmGfh8Ft3D1Tp86Js5xuMYJLvMeMtzh3KHthYWksPCKhxhdge6bo9KhDLW7c41rpUcQTbu8YbSaZpTv16IOcop2VZ7L424sI0LTioouywiGAJi3rf2ZOULT0khmxc673oEK47nWMLuzX0nxHTK53j03fXDUtCW77BwZ9cCGGh5nHE6bOyudlCbbLWn2HX+4guSiUfVrF05Zmgh1m+RVqnt+0qx49ckxdO34FrjlW4lNxtZWmHN+Fnlomvw++QyodeQYpvgLk7aqZtHgK7LU+lepEFQ7jb8+8Yaa7RFq
 EinVX9YJ
 KpAYkqklSKfVYYm/TtuC03F0NfpKOAtmtdzL2QsoVJZuxnCmK34MkEkAdGRkdWxA6N1q/ReBKiYO9M90yM09UP0lS9hxulPg6KtpckLXmYMh9Yo6oxzfQGe/fO+VSLqk6nNnyRCjEpv6w9kvEMzLVJWkeRwz+p6y2C/FzoJgktcKJpZCmcpEae2pv+1zqXT02f4Vrhk7el27k/uapDBq2TT3Q55vq2/H/0ShmyBnkVQaSLLOG4spZ4m2U40p7gr8Kqxqdp1B0oM4mg1v4EuDbt9tWL3C9u3U/PvkILtvV4ISnn0LP7bHaXarp15fHolQtFFGkk38yjVPYuekyj7P4TyIXCGcQyyaqJ2ImDlHnwlVtf3xuj55w126n7LNYccbTgQWyhRwr9TjL/4L8XxUa4hAaBv8EC3Lap6EGTZDbHY+OiX0s4jb0oOa+7ysUskrZClr+V3IYvbthUKML0osff44UAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 13, 2026 at 4:55=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> shrink_one() can return immediately for empty or protected memcgs, and
> try_to_shrink_lruvec() can break out before reaching its
> cond_resched().  A scan through many memcgs can repeatedly rotate
> entries without giving other runnable tasks a scheduling opportunity.
>
> Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
> does) after shrink_one(), while the memcg reference still pins the
> cursor and before reacquiring the RCU read lock.  Also call it between
> bins and nulls-marker retries, covering scans that skip every entry.

I'd appreciate it if you could provide more details in the
changelog. Without this patch, are we seeing an RCU stall,
a soft lockup, or something else, right?

Also, as Andrew asked [1], does this patch alone fix the
problem?

I assume patches 3/5 are needed for the performance
improvement, but patch 5/5 is also needed as a quick fix
for the stalls.

[1] https://lore.kernel.org/linux-mm/20261101135047.61fc3f209b3235ed6fc9618=
3@linux-foundation.org/

>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Best,
Barry

