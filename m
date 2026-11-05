Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68248606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=Fg4TyERn
Received: by kanga.kvack.org (Postfix)
	id 69AAD6B05B0; Thu,  5 Nov 2026 18:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CFB6B05B1; Thu,  5 Nov 2026 18:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513B16B05B2; Thu,  5 Nov 2026 18:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18D226B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:18:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 909DAC0C60
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:18:02 +0000 (UTC)
X-FDA: 85402630404.24.FCA9862
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9E14540009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:18:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Fg4TyERn;
	spf=pass (imf01.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793920680;
	b=IQkU0IkNJskX8Y9l6un6LyjEuUHNBMZb/HW3/8eZ7Q2EPiiWo4y2xHuPQI0aJRyhSnsaw/
	9S6hbpfvxe/RrhmxlPnPx7zskJ2A5pNvRtMqDJ2AAeggeaZqwHpUna9oXjrGdgSf5L5KdB
	3lxFZ8GoqkoBw+e+bEjHpMlhOquo5ng=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Fg4TyERn;
	spf=pass (imf01.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793920680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fuCDmSI9zu6AYuOwJkaSaRyngdfgRozjSLztTOAphqk=;
	b=ur7J2oaSwejGzdsyXmHrHUZ5EoiB+BRblBUs31OqZ9hl+p8L3GE7q7y+CNs6hjf3x4IPCo
	JblhiYIrtxDfC3o8mbNfofbkQMNj09VmSaFo6323AwG5Nixa1TLr99NTN6MSZGbNikEvHE
	GK5OhxS81McUEzKZW8tgkgNtWuM22hA=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso31366a91.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 15:18:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793920679; cv=none;
        d=google.com; s=arc-20260327;
        b=o93oaPOuAQHqpFtFKuBH8+zs7yWTw2NPT6apWZPTl4CGa0KrQY9eVLp9Wpb524kJE+
         7K3X9lt9A9ZVMG5L9BkNOS4hiXCxitQz1dqP5aLmv4AWaSdwwG2T6AN6e7x5+MrBTlWS
         XSmU4937/qvh+XzbMclMkh5UpDcIVZRD8qgUP9JxW4j/BdYaY3LrGa/kRERkRWnvJzg2
         fX1009AD00GTIh/KAvL2eb7iRmlMpmckRvFV4tq+UnsGXO1RW2U90QwjRy4MAWcDdcsv
         U2A95ORrxp5rXcpnyOnsasBi0fzh/Y4IkUQTqdHJ9GTNoGzg5QJGBu63O9zKwbksQ/vR
         DtoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fuCDmSI9zu6AYuOwJkaSaRyngdfgRozjSLztTOAphqk=;
        fh=ssbyvNVk1ssWPJHovhVri8FODGIpdkneHYwFcPlZvK4=;
        b=slbgERm2tMaVExwkwb2DdIxg8qws6i1tp9Y8vfJWXGfSaZCIOB66IrbGLNJ/P3DClk
         g7QueG310/YePdoT/AxK36wX6FLQiNB4SSztCBHF+6bPOAfCno2SR9mECAh9dpLQfWME
         WTxM1upDmxjihytXxomxEkuY+jKnKEVEj9FwaERcMrXqXJPH8dR/r2s1hbTEN0yBxHrR
         yzFSCba+e4FShKspRtCt9SC1Lc0AoJq4bbDCJbY69E3cT4k706ETDUYlswWv5iydyBkL
         D3d1CNiQd7SzVlFTodnsan5aSQ3GNS49YmWDcSr4hCzm9v8qnLMDTy/izdIXXmkftm0p
         k/0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1793920679; x=1794525479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fuCDmSI9zu6AYuOwJkaSaRyngdfgRozjSLztTOAphqk=;
        b=Fg4TyERnoucbXPk4SlbyWfE3FUWxm8/t1m3Gk/acduGyQo68IbuevPzCgqokgiEI4t
         JbcOnpoIOKMB+LwaMZDHCfnSJvvZcbSJaT8V77KQyiS02YoMB7Gl0pyksJFYnJ6IAbsH
         BuseRMIxFThuJzOVXI9mRxJ+YvD6xctrYqML94XS9Jf4+1j6OV8D9PWXe3gg3mIhbzS5
         GCGgeWbfH7xz1yLNiCyCyyP4J9vG+pzjemAeNGJz8umHqk1bLtslV5SM4K2v5UgwAra4
         c8a0iCJi0g3AppAuA1NLWLCmLjC9SVHfzN4jeb+z6e3TbsDHfJE6Q/ykDE2t3mgdRLiF
         l7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793920679; x=1794525479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fuCDmSI9zu6AYuOwJkaSaRyngdfgRozjSLztTOAphqk=;
        b=vsm8kabfeue/P2SuxPWfj/6AYJuK8UDFLn94k49nUTG5XA3c2OLtt3xir7nKrseKxn
         fYTDMbbLOqzcN4sszTd56iIvCtUdwksHi+VvtpZWuaCmEmWgwVOYRxd7h0nIowJMWE4I
         49W1tNO7g+uaZmh4Fp7Z90AU4HOWZwpsuulrOrYNqy+a/jmpWrRMiyrxRaWELXRGSxz6
         TjRY5KxRHZqnRt4qJIrgFVnTzAhrONCugcmJ7uT1dtwUsjmWwW+wu9mqudknqATyoIyw
         upEs0LbRJipoZDdPoYjUnKsLGe4evqdHWxZZQeGqh7f87piG247KiLg+vzXM2kNe1O9B
         e7kQ==
X-Forwarded-Encrypted: i=1; AKwUvBxFPXPozMjmC9DnOSme1zvEvN3caov/c2w9aUJ34m2LuixJFSx+hSqPVkMy8XNjeNh5IbhgclVl/g==@kvack.org
X-Gm-Message-State: APuU4Z/kDPgTgI12iNgf7G4WJgUTF6PcqfeAI0ojD1NoDGTgRfTH/5Nb
	/ZR1MCIXYSZ8ROOSzTB1DYJnJXepRe5wqM2QThICghRn83NDDsRkw4islqx/YJmSmU/n110nvrb
	+y8QbwhApUuTSkop9hD0YGeQJpVUq2mZbfzGun1eD
X-Gm-Gg: AYBFou2OWM4UuXCfU1vDifoZ6bU+D+0SKA0dm3qXZIAC9LdC2TPqUDB5CgQKEV5spJh
	2nQE23bagrJhCPmgOB3S2GV/E3rpv4i5Z8YxugfY3shaYFZJ5ZY3Quv7NW17mky3iyyF88tRbe8
	+LqpvjeQz+4ucEiPhkN/SeNue1a0GGE4dTnM8e5DOUdbtvvbcOMxlVdB22FxDi320dpHkVMMESn
	n02JP0yDFI39EWkh59A1a26ZpdCit00qhmvYtgok/SwFuHzOD2ywLGTRXIIArltz5hETOHiYT40
	tLY8Z2k0ou3SPcnzh0y1XyS8Xh8TgUfnZdE0Fb8c9FB+WUI4GQXADELwgrppz97AufHQ61HQbb8
	2hstpvEzjlyLwl8SevO45QPJSwQdA/Je9WeCthI8qoIVTB3Se3l8wOz0Ib8a6wqkhM+QC
X-Received: by 2002:a17:90b:1dcd:b0:3ab:f38:2b43 with SMTP id
 98e67ed59e1d1-3b0db703e39mr535625a91.34.1793920679319; Thu, 05 Nov 2026
 15:17:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org> <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 5 Nov 2026 18:17:47 -0500
X-Gm-Features: AclHuK_gkg-Hspii6U5_01_jGLQO23B7F4YXuvzvsb53ImE19wnChR3DgLruv6g
Message-ID: <CAHC9VhSR=9YNhBxeFBcTR8wgG2yDP1fW590QKjzuc4Kq9ohaiQ@mail.gmail.com>
Subject: Re: [PATCH 13/13] security: convert VMA flag tests to use vma_flags_t
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E14540009
X-Stat-Signature: fwcbouuu1qoa63phuadzaoktf13rb4ue
X-Rspam-User: 
X-HE-Tag: 1793920680-767983
X-HE-Meta: U2FsdGVkX1+izIswjXnIpxFrS+otaDC+bi9FECVSnbnhm4aBzO8tWaM6ZiD/yWYDdtMvGArtUdK12vv/DYCgP1M7+QBb+yvWopKQLhqgL1hg9VmNoQYPG6B5OYlVsMrt0r6yLQ1iR/37jHmEDUuSF9MeDLaZfOSvTzvJYPAwFRJeJCoQAAX7TXjxIQGhU8PYHXPy9nQQjbUOGKj3to+akvqKfUsypSBudhdRsbJe8AlUoWfnPvWUf+TQjfeB5z29w+4ti8eUTXMkN4tGz2aPwfStDA/DqN9mDbt8fnKpdaEofmAyJaXuL8JnB5pQojQ7ekVwuN+eMUmXEiYPxvF8fP016VLLAWk46l29ZVl674xCtpo1ozZjtYo87QYKDPTjACUaGSi2iAFFh2mSSNWhBe6gC6QRvRi8/wrwr4msjVd2x7ixJcXFRWiI89Z4GtRcC0zzioK10jCBKpanot8MGUKWmbW+6U7Yxnb+2XbMPnOhQW8qQloWYMqlRmRY2PUu/Od4t0F2yn31Zzu57vL9iwDulWfLgmlrnQ8RE8OkteMKKUemjVsc8pAH5T5iKxGUIruGeO7ONidHU+XOgmIokGRZblxxvjkYfXvwbBKBTddKwyr1SF5cJsc3g7m61eHYspM5L+MuXSjEMzs7YfjRegPpn/tM1VPi6T+ADuloJhWQnlgeQ9sGP3RPaqVzIAHmstbQcBT7TZvYmVH0tV0t3ePAdwNNlwi6hxK00nZc3cSpj5l+bqJBRrsQHBFJwCuD9IyRRdqL9SfZG5SQYoV4MVRj+rLO+Ol+2jKI/WAEQTBLFXl8MUk8H0roOcfyFnAr+BAHYq5fDpqWmKZkWVUcPsciRvLC/8OKrOH25pRvJr3zpCRinkgJOuAdtMFa+1k2HXaM1962DtwRGNjs6k51mOuZ79BfIIJcbdp7zL/pwPRpH84HtE5aLsMy8TeTvW1P1AIIzQLkVf7zq/b9drU
 ipSO4CY4
 Ex2lSm3OHCXKtm/2sDw6+QmELUuZqIitBDQ66s33TJCEIScd7YDTgAj2wBwIZ5HDkYr7MwB0oGHoYcvzPd9noltwpg9ALTb4ZBs/laae1nNtfEwswFW94ZUirVs2swUJXUPFVy5uT6TNl16ECxx62ndkNVXBSkLPUUTolRhbae2meb8YqR4/tsji9Idu9kRrvj1iACPPy48wHfCU2IbBMywKmxvTaXHtjcyROASnMyWQ/Nr3v0NYrnrFGDs52eGjD4POdkY1y5cbsFzG3EGq49P/DiQ8q9JsUxmvjhplemLyp8VCInyI1LgXyCR3yrKuZQdVt/E47LBPRZuuf/7jpgC2hZnq2plNeFa6uw0Rohw7wQkHL/rfdkg+uCCu94tuSJYLObVoeVrrGYoiT+ehLSPuK2PvJ1ZvIr4xAz5iOVeV/L1RhTgQPv8VVEHd/fCDzl1Ctk9z0upFxM4GvDdwvc227WzF4+kIEzdoq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 4:35=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  security/apparmor/lsm.c           |  2 +-
>  security/integrity/ima/ima_main.c |  2 +-
>  security/ipe/hooks.c              |  2 +-
>  security/selinux/hooks.c          | 14 +++++++-------
>  4 files changed, 10 insertions(+), 10 deletions(-)

Similar to the other patchset you just posted, is there any reason why
individual subsystem maintainers can't pick these patches up, or is
there some reason I'm missing and they need to go through a single
tree?

If they can go through multiple trees, can you split this patch up?
AppArmor, Integrity/IMA, IPE, and SELinux are all maintained by
different groups/people.

--=20
paul-moore.com

