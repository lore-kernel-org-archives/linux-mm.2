Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F95CD2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB516B0423; Tue, 20 Jan 2026 09:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3006B0424; Tue, 20 Jan 2026 09:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7BA6B0425; Tue, 20 Jan 2026 09:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B77916B0423
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:26:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5981C1A05EA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:26:48 +0000 (UTC)
X-FDA: 84352568496.27.DE28890
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 657114000E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:26:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DB7pOINn;
	spf=pass (imf01.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768919206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRq3V9TGTshUsvROKLlwVrfXJ6Y0o2eUwLmYrdqr/HA=;
	b=pEUY03toL+0HvyTvh2y6zKZof/B4JeS1ZZrIaNg3HW7CZqNJi4dGSBydgza1DfMOz7+NyG
	tPD5r/5jaQkqBqmZdCGMqYnXnoHfyu6Cikm8unZJuNyo2/p2aNnv1Szrejvf7dHSCsZp7E
	cgICzYuSN4BpbTmvfpNCgkuy1pko+oI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DB7pOINn;
	spf=pass (imf01.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768919206; a=rsa-sha256;
	cv=pass;
	b=Sp1jZVieQMR8Rm8Bo8pCoURFUmpCAbWb1/87QH09L+j25vTwMJ3+5JjxkvOBa0Trs1onu8
	+oyucTbkBV2vx6LOYviVBxh88zRS9UDTbDCNfzc9p5CSBkoW3rxaYkRi/p5ODS2anHOmq5
	X5fP7Bhjt+YZDZndjJk80qyR/oej2Mk=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50150bc7731so82132411cf.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:26:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768919205; cv=none;
        d=google.com; s=arc-20240605;
        b=V/ncbVzNfzmhaMfA2Ko5j9nwGcqFWdOaahTYhjdvlQGjh0z7w4P9g4B2yqIa8VCpKu
         nIyNd9nb7dzY8CnI9in+fOEtOaK6axxOMqBw4GTE2Ji7lZVkEWFdVd4p/T5RXrTy6RRv
         sDLhrke4Qn7ziqHApvHb9j1triaDxVI9OjhIZVH+GLrZWMgE9ltl7FUPGvwvuPT658yF
         9usS+1z8/btQSgwEmMVi9//mXzb8YOtOthxQcu9OKEaVLgaEvukIUdlBMa7ptk+MxuYz
         Mgwkpd3rs8c9pYuted/d8UY+Fzq6DvZtN1rqAHbHRWHI4rTHoN9CldGfx16nTij32K0q
         t8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iRq3V9TGTshUsvROKLlwVrfXJ6Y0o2eUwLmYrdqr/HA=;
        fh=XddUyj8CR4VUSyw9N7wTfheNvR18OpEy8kt7ocntbaY=;
        b=GfzptUtbQ8rMcJDYkfjMgEE9AZkzVitWcE+mAbr7d9WNaqdktlq31PgzBw5JaNiWb3
         BoiTDt/zR7x+IenMAf6Wegryg81zJf6WpmyttakIyv3icSc4Zq5K7hRSJHNubaw+nnqu
         NCh2PpQGqr9QzZ1kGbDKLLti2gyq1R0QKNLzPp0w/mxwPR2h7uMYfQWgXyT7UxGLuPp1
         av331eGz4p1D+zYp55jOljaWCf5lwWbdSCZmlba2JCH4NE/DfUsR274ykjpaAAL3Pa0B
         kjvLPu3AHka45t1TDAOgfLDmlC35daMTPzCala6irlsID7XDpi3aa+Q3ZfH7P0h4CNgS
         wMOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768919205; x=1769524005; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRq3V9TGTshUsvROKLlwVrfXJ6Y0o2eUwLmYrdqr/HA=;
        b=DB7pOINnnFiLuHbxJyr+UQ6ISHllzOsSyX/Awil/2KmP8xDZkb9i3DrBjtxQtWN3up
         SUzl8skMUHMcOL3yD9JLzVFWwB4G97MNdC7wRvf7Tf46CMZBLy898AT0O+JOJCldtx/e
         sngDl8k9Ggchv4w5Otj/j25HHS2eoB1jiHMts328hcJZEEoEWVRr3oySPBcn+51aeGfZ
         2cFgXqu9qvV3QKGHLGXXPOQAVtqw/TWomow1Ic+OsmOfAk8vxJ9AhXu3MCXdty8sC5w3
         jGHsga6caOZM+aUtMQaIqYoev/q3N2LWcvfvUG5E7ULAirqnHjroX2qvh6BE+0X7HhoJ
         JPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768919205; x=1769524005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iRq3V9TGTshUsvROKLlwVrfXJ6Y0o2eUwLmYrdqr/HA=;
        b=nPVKvLRl9uwsC7zuPI8oCEhFYvIBvcFtLqRZtASrqQq8wF18fxGVOHjDpwURxNFcS7
         MSCLwiZxvdJUU0/wiy8XluSgIEuixgh0QyOXERnIxZqv4+QGT9/OtyU1hSn4cK18i8zL
         IDxqwHw10CeJyYjsS3vZjwHF974HyC1yC9gjwErH8hnSnjjZNc8h1rh7aRvCUvZEVrGr
         /aqnJMnmMmpGh6+kiOrOQsMd5AwWhsIyZfUuduDv2TLwk8JWg8Xoi95G/09WYW2ESbBd
         gxp+36pUn6usvffiYoJyHl4W44G3Jld13O3vVxD4oTdmyiVROVmcpClDGNb5ntKJ8hQh
         u5lg==
X-Forwarded-Encrypted: i=1; AJvYcCVAbNy56d01ySINb+WQJrGPO39emeaElxG6rwxVLSIV641Kh/C3mJm8AGvqMHIdYy0kQKzvlE3KoA==@kvack.org
X-Gm-Message-State: AOJu0YwdpujyVK1+Ue7KLeLYc7AMreHAAkoipUFsHsWhX8vNoANMh7/Z
	r6oiPdTwXJEQ16hmhDGtnmPxDmGmtfnnhqPWVdtKtG+HMdhONq6xRAG6hu/anN3m3AzvmWfqv9S
	YNUsqoM52LwxQPlj7903afpE8d4nFn71PVFKsfdCp
X-Gm-Gg: AY/fxX45vxJj1sZgvr7X+f2BOyhBHuMTwpkgEkFqCSVG6GqWVx99OMTRbnwx8ngcW0k
	Zq9FwQnm9p+hKNDCiX+OIL5rNgLE7Q2DJ/CmTtocvleAy03JBh0Cyp3ezTjEgX4oSE4MARlACfB
	KltH1vVOQzhKvBiS3phEKmm9akVceE+8LIvUBZn69SaeZenshrrCVOubbSIvcNJ5kvgyUsTkpgU
	20LNHysg2mcKVRfnp5xtbyVSMD5ye/NKQk64HXJ543bzkNeZH4v6Tmg97QkYNzgH1qizZvH/66K
	Ndl9SggHUJCWTcGjjZ4MEeSD
X-Received: by 2002:ac8:7d56:0:b0:501:426b:d497 with SMTP id
 d75a77b69052e-502a1f2213fmr247099121cf.52.1768919204813; Tue, 20 Jan 2026
 06:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 15:26:07 +0100
X-Gm-Features: AZwV_QhNTGTWINIBPMZao5ljKIiGVxjHAO6q_kPP3h9eB_FkxoIYM4qby5HyYlU
Message-ID: <CAG_fn=W6wdFHYsEqkS37iWOkJUZqS0LUEg-N2HWo+3Rw-76v4A@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cae4u7dobx363947mzx9ogm793mbja4q
X-Rspam-User: 
X-Rspamd-Queue-Id: 657114000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768919206-882619
X-HE-Meta: U2FsdGVkX18mw3XmZaOd08SNJVNAnvC0Mw+IfcZv6RqFy5crvlmcwiNl5a5RkGFEqLWRxb9udvt9mLrr5FzfDDfKjeutXh+CSMNCukeEhrOkKJJqiMAXRy+psGdkRrjoS3S5NW5qtj2+mlHNXNvN+479amNn29Y1QtHK+SI2YgP0W1gNHBw92HHNoEZ9ATKdmHmemmFCQeDdHUrx5gyXCd0ZrLe3a++8X5hhKsTVpExya69jAKIBIwZLCU2rtx1ZadkH1+OyyEggSAPB2CAFcaRt/7G3LGebw8LocKBD0w+NC1J0stziN8jm1PX3FFvZIK2eWR70IUdr0Iz+fdrhT4VOYedRpU1Co5wZsvU5sS8QoEZQqLqe+GyM0hHnY9dtqfm46hdYQJ6sH4V9gp+g9y+HDBpU+uT6LvwdDa8uug9+Oi3AV0WFCiFYlMbp14dlgNJbT8j8de0cNhuZzcU9rwowK4T+rYwV/ijX1KjbCo3+OcJ/7ZAzelN/+J68MAr2DeRIG3aAei9xFah18qTxsGjoe5myJUHBSfOkLhu5kKM9bE+7FLL0Cal4hdm3TkngVZ8H5or/ow9cwWhb4gHAPgfkH+i1se7NXvFNFo+a/wkRFeH6TmQLWFiExhhtwrd6QLlkUi0oy1k/A4vmYnKLNaZwkIWtrg/C/6u9uuz7BlY/RQKPlO+das72IhXq+v+ejm1KSowQLZcUw84YvmWpsXrn+82u1L6U7lwcEnONgoHmIRtEDntqO2tr8sn2zPu4R7/mHO/rct0TLwp52WbUat/NHFBc7r3Y/hHvvnMnRLqHuB5GUtZOc0F/t7Sxvn1sJYzXAY3g3ATnAkx4MINqjhXSieBroDKbNhUCFExKxPlEN5ITsa7NNqN2uyHNRv5pLIupaqwzEzwncZb6j2QJ3/IMzO7DWbGb/3tg5MzuybyUrwAEfogOa1b9OEpkTurlwB/ipyKLyy41v80+Oo2
 0DfKmafR
 gCzs1ng2LPtJ97as8xWehbOXsR1wOAMIOApnbunJj+6yfVRYcNJskY5KHytCbemvgGPlNvxlswCpNYdIhBhX5JDCTP/3ZVMflhgtFlayx112xTYjb8C0V3ttHKV1t/2dW+p3UwTuj26mF/q9liwhAozJ6lf+2HDWiZg7caDO5Obj6qur44aPjc+lUnrWChimGMBSVr3O0Z2W/bmD2zHLCzPMDd717XZ3W0uLJsHv3xuDuyxF/6p7V/5RcUv5IfRzv2bBRfvdXHcJOE0P+Ojq6WyOIFS6zbmaWLS87Kv5ZagLGEvLRa6TYTjk9baDGsyWkkDS18NrmFlikR+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out.
>
> Following feedback from the Linux Plumbers Conference and mailing list
> discussions, this version of the framework has been significantly
> simplified. It now focuses exclusively on handling raw binary inputs,
> removing the complexity of the custom serialization format and DWARF
> parsing found in previous iterations.

Thanks, Ethan!
I left some comments, but overall I think we are almost there :)

A remaining open question is how to handle concurrent attempts to
write data to debugfs.
Some kernel functions may not support reentrancy, so we'll need to
either document this limitation or implement proper per-test case
locking.

