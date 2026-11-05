Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ED1606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hm08WR4M
Received: by kanga.kvack.org (Postfix)
	id 853196B05B6; Thu,  5 Nov 2026 08:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8043A6B05B7; Thu,  5 Nov 2026 08:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F33B6B05B8; Thu,  5 Nov 2026 08:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 426206B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:37:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC6D71609C6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:37:01 +0000 (UTC)
X-FDA: 85401166242.24.398E04C
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 07B15A000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:36:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hm08WR4M;
	spf=pass (imf15.hostedemail.com: domain of 3eobsagwKCJc38I9JN9J5D1E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--chriswiseman.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3eobsagwKCJc38I9JN9J5D1E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793885820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBQ4YMiVBBvbebUf4Eh89Rb7fq5fgRCv2V9oWSzYxO8=;
	b=W0SX05YLoXY7fq4DjmM6/1iNYjx2W20Qi3ztlV6eXYq75KhS81kmW/0p5XGV7gD8FmUvdd
	eM4Ea0GK5b9rVBkKLwpfYFnfK8SDe9Rx4nJlwkhW5+HKddr61HkVhsMiiyIxbXxu2eYNMl
	cdEyziUSVZvwA3NIidh8sc/5MtsXn/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793885820;
	b=Q2Br8DQO2oDmi9thxTnNonqYxow8ZLXS78NQsTRcR5RtfwijslNV3gyDQk39DiOYZ8tcDV
	AF9GHAD2TpKgCmZDG9fLBSkzyQeM/vucQyZCO2RYd0XtEEagSIMvmzAa6hsD7o5++3iylY
	R2wVPSe1LjauWUOh06dERp19CIEcD4Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hm08WR4M;
	spf=pass (imf15.hostedemail.com: domain of 3eobsagwKCJc38I9JN9J5D1E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--chriswiseman.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3eobsagwKCJc38I9JN9J5D1E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1383723dfddso3280929c88.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 05:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793885819; x=1794490619; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WBQ4YMiVBBvbebUf4Eh89Rb7fq5fgRCv2V9oWSzYxO8=;
        b=hm08WR4MmZqOAU56AlKdLkjW0WiCeer0qYuoyDQgo6NiSbB/EYC+s9S4JOL4afWamN
         tMu131ynyoTc1OpMyy11yeXh3mypl2mQCYaFnjh+gFQtIbBBTS2zJ+7FxUiOtmnOkNc9
         HVX7R0bV4lMCj2rRi9uTLetsbQzFNJ1H+1IH7epypyixnWJlU2u1ZRQJ4FnBauK8oi9w
         Wo5wywrwtcIIwz5nUnKaSsBf/5GBhxbOY0INU5XA1Adrydrm2etVgUvfXKQiCT4EGCDD
         9KZ3WjguK4xsM8JoSyJPvttG5y5+VRE37WWYQKMZ2dw5fupzsDH2ZtA1NkcNXzM5pGFR
         a6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793885819; x=1794490619;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WBQ4YMiVBBvbebUf4Eh89Rb7fq5fgRCv2V9oWSzYxO8=;
        b=DTzD39HMsfTlmMnxyyJqpLZ9LncK9EaghwsE+vZsYfARqQavpAon3z+OQG94O7TAZs
         TZFBfnQ1SB3BEPKcs1qLqrWgDC8C5WefHfr4PZICbwZbKFACd5lDs9Ty1ypePv8XhWEO
         Q/IMxgKlq7KewKARG1Ty0EXbrdZSs+/dT9FFy4yaYIvYJf5l+S2li2WWsWxV83V3DxPi
         jXaywLzuK0piJA/Hlp03nmPaepmaU/LWf/D+w9A02e8V5ltcyPxPIya8Xwbso96q3vf4
         3JHE64gLaeMFjpI+XMHL9BACTze0MvepaxLoUoRryyCDavC/49pUpe45I5v2XUKYomfS
         ZvhA==
X-Forwarded-Encrypted: i=1; AKwUvByFYrQFD6lClIWVtqA+yoDhAfgga9X2mddpMJ2fm6pM0xS311Ti77hzYfeYJXYxNh7LJk+ITtuSsg==@kvack.org
X-Gm-Message-State: APuU4Z8GckG8QJPCpTmnggxeEGVDrWIbVehiA6WZgKrl2yxmkVhyUuF3
	5GMtwj4etck2L9KXnKBwMdHpCIYFkB4jdI3WQ1RRfLOeDP2ftkXjs9MXVqR6Q4gMeyTSFnnjfNo
	8ZX5mQ3gbpqQH8W4ayNHS8K5Ccs/xkg==
X-Received: from dlbvv4.prod.google.com ([2002:a05:7022:5f04:b0:1b2:41fa:646b])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:455a:10b0:1b2:42ae:94fb with SMTP id a92af1059eb24-1b242ae963dmr9575010c88.37.1793885818098;
 Thu, 05 Nov 2026 05:36:58 -0800 (PST)
Date: Thu, 05 Nov 2026 13:36:57 GMT
In-Reply-To: <auwOBaRtM9p_Wxfx@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
Message-ID: <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ti18zj1yxyswrdgmiyowe6b1fz3ugpk7
X-Rspamd-Queue-Id: 07B15A000C
X-Rspam-User: 
X-HE-Tag: 1793885819-5681
X-HE-Meta: U2FsdGVkX1/Yog2i9JbwT9tLuaOtel0lF2VmuZz2X0ZukLhjU6g0x9kNG4ZjvZxFA2gDCtrkF1mOpQVT9HDgCN/bSRlmiysqUSPF0vqGySH/wi6m3WDEaFRzy0JnE07CJAkQqZyh33ke08oN2vNg9ryzIRK7Lnbo69W2+KTYuTGRXVYPuRMEmZtJr7Z735ztQb5KCNFLpZ4XFd9jFyKvsTjOLjVoW7SvUczwvGBoQG1lkKCj8DzjNEgl22AXiJWytJN5o8uFF63NixnXskQqSSf0pLJYMMnwHOqF0QfPoFN7nRHgOZlLkdKA58+tpP9q4zI4nwVrEAxDFL/64xQkjOb/9gOF4+GnbUwPw+j8M6KfSX69Xggf35WDFY30+MsyClsylafDSC95AVIDyS6TqIAkdh+uXfkafPAmpT0q1ClPYs3K8VjEf5p/77ktDJMOGmR6EnuTojg7p9RUU9Il9piUYkUf/6UaIweTgy3ashcRCJp0JAH11UpbREccIvi7hv/rlUcsA21bcJ/i6BrXHnoFb2pMOSUzHJ7A5J0Me+JbGiJeT9RznQ3Vy8vwrK3wSclZg+U9etlbes8jiZJYGPwyymkE+hWiA4rke/rkNTFg9YT8AQeNWhnwQHMK/AgQurtwsTnXmugSuhpqIU8Xq7Y6uMnG+dsbqe15ywJ4Erjw1Y20fzBYuPKm/c5z5XQVtZGb5KCrefz5rlXjSglQHF6xikt91RljPtuTfdsNlQLHox7ioBvDqQSb/N1EtB+l8/PTo9d7hecD8L09ojOatjAlrcL5T0qxd4h/VjhI4Pl/N8plHQJEDBNQods5v+4CbohdUNnNqS4b/9WUcJ1ir8DJhbSaMoJ5lKYeKl/LkjFxcqEqwH67VAqdutnjonPwpYiXJAp0JFcLoRMp1DF/fNCPgZGRbTUTdGVhh3HacLD4A405TaCqFaTpC2wDzA1KXUDMzMTpqbDl+i/BTsk
 BUVSRxSR
 3uF2hgrj42zsSK4F3Gv9z9A7eFUSCEhq57oxuPys95fOgui006j6BjM8ymQFLAnUFrgzO1LUcKsOnimupQJyXtxmYqMgZxyMeezeQ+KnLb+sL2j0wCbTYC4kiA+0jmjUqj1OvLabmOC1H116/zHJ1r2/s672T27rAiEfU7ygySShAjPy8PmSwbDA57MC7hdI9AZhAexLjUCeom+yhnVYQdCI6fNZ+u7STkB7iBWpGgjDP4m5f57omXacj3/zZHDA5hCi3vwTiGdiXtoaVnn2YCs3sXRrhwkKKYGoHr4QrAQgPQEnfcT1IgK8I+Wq7Pv4Azkp5dNfKQoDrTyKrvmtFFmVcND+FJ5Sxx6vk5AROqRyaajMSpmpnDo8RaLMmv9hE23Szf2DFACS/hahmbneYlFuPD1iXjdRrJeD04eYGAzakceNtrbTQHcrdLIpA+qioGqTaXbP/2RzS7FbQ3vfz25fYEEEMHKNDp2pXcbJai9qTGTykc0+5Soia8R5xPkRW2V3rIVtCT2m1R0vukXu1h228glWobovRx5f+YMCQkFrNXBmAnsozGkRAaEwy4axL559EsjcKWraFoDGuCvgvZ5vwWBX2Hn0E7OWqApXyL0SgnHcUwXX+WWtxy8sSW1qX5vxK50mqW8pj84I+IoWl/XDQS2tjiMXyf/G0A8XrMY2yXBZLSpTu1TwPlvCd8mO2OBcHu0cd6HGJ/oO/rszSBebFkJWGnuvHTAUkVm5e2Eaj6e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 9:05 PM Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
>
> On (26/11/05 09:10), Xueyuan Chen wrote:
> [..]
> > > SGTM, but I'll let Sergey chime in!
> >
> > Thanks, Nhat and Chris, for the discussion.
> >
> > If Sergey has no objections, I'd be happy to send a follow-up series
> > to make the shrinker configurable and add the unlocked pre-check as
> > Nhat suggested.
>
> Thanks.  Sounds like you and Chris will to have "Rock-Paper-Scissors"
> to determine who sends a oatch ;)  Just joking, let's first figure
> out how exactly we want that zsmalloc-shrinker thing to behave wrt
> zswap expectations.

Haha, Xueyuan is welcome to send the patches!

Dumb question on the zswap side - aren't the zswap shrinker and the
zsmalloc shrinker independent?  Even if zswap's shrinker is turned off
at runtime, normal swap-ins still free slots and leave fragmentation
behind, and unlike zram, zswap doesn't have a manual sysfs compact knob.
Would it be simpler to just keep CONFIG_ZSMALLOC_SHRINKER as its own
standalone config rather than tying it to zswap's runtime knob?

