Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1918C606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VxtiISzY
Received: by kanga.kvack.org (Postfix)
	id 301F86B05B6; Thu,  5 Nov 2026 10:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3806B05B7; Thu,  5 Nov 2026 10:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2A46B05B8; Thu,  5 Nov 2026 10:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3CCB6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F1501407CB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:24:32 +0000 (UTC)
X-FDA: 85401437184.24.B0DF2E4
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94A271C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:24:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VxtiISzY;
	spf=pass (imf20.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793892270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QD877pGLpHjsBFVYfF6QgCZ1NDUdDbNj4gs3GngsOM8=;
	b=s7raVubmYHzAYLn3NdJQw+LkuhYQ0scpWFn5yIAgg3llF/Z+T5/8JtwKJ74eMR/16NDrFP
	lIyxPP17wWtDwv7QHh+AZZgD+v56cOYmPZ82APIHHVyg40BKIzbbrH7svg3d1msJzOoFDv
	+DFeoa4AUnTsAlkfD5v3cpG8azwQyE8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793892270;
	b=UOYyDUADH4Jocm214YT9Mew7hPzhTXLFm9V/5nrVSihblQnU++n2AnVaUCpqyCPu1e+H3x
	v3nrW7EsckTU+GvoMLs8cahvPmuKYOhZn9HialQtHiXvJ7XMmkwHdV/jZuWK2h+I7CSlA5
	Ts5krN2z9VdZx1u2UxSxNkYNmhngIpU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VxtiISzY;
	spf=pass (imf20.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36dc20d6de3so220278eec.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793892269; x=1794497069; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QD877pGLpHjsBFVYfF6QgCZ1NDUdDbNj4gs3GngsOM8=;
        b=VxtiISzYgHjBMu7tk4VzIEIew+RqJ9bvu0tHdZmQ5fMqO1M6Bwm2l5xBKeXlD4jz++
         Wx2Dl7PvTvUbqQx5gWEe/n//TuDjD4yLGdab4cb2VCt2iKuOkk/uK4Rhkd1h+Q9qK3EI
         /552PFcUuDOkhELgDxLSqEa9J3W4DTBTTco6P3RBLWomZJguPzNqiFGcSkLYCKYvdZkM
         qTNwvAdkNZaN/dgGGHTgoRZFJW6MFMRZpLDsRZfAye3ztZjksAS4uXaC2XUBGOLfTFGy
         /aT3Q+GmpyeG+74M+wb79jny4OT10BVIa6AtgzDRr0mizhbL83GH4X6e56lrvQ55c0ou
         cPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793892269; x=1794497069;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QD877pGLpHjsBFVYfF6QgCZ1NDUdDbNj4gs3GngsOM8=;
        b=iiQVivcaevZ96Gz6K5joTnn7wZSG1ZjJS8oQDgdftZZBgXWbykL3DQeU2CCJZOMtpO
         JOSbdaRT+0JuEvbPU88Kx2x54Sp6gWxTzGaeCQ/hXePSm0GHrRfsJ7rQDLQs45M10AeU
         /gq/0M8tPdyKjO4LFLbJ9K68kC/DmI6Hbtuhh7dDV428l/U2EDgiOcsS81v3FCSG7lM3
         VMpy/gWh4NmHDUZVJqzVnJI46PGwi/sMFuUYk/qOii2MWvs65X4RPZq6OaLt3QRH0e6S
         JX1yPgl6entVP1pvBglxpDPlhQVxICIjojYgPDPh6Q/O+9luJ9ncFpMuJlRITDGg6T6c
         Dcgw==
X-Forwarded-Encrypted: i=1; AKwUvByil1+8G0N0tSIjq5lXzD/fey20y5VY0Tsj263XNzfmhxTePWZPSO9VPIh5THh6FPXdgbKJ598y4Q==@kvack.org
X-Gm-Message-State: APuU4Z8btIICCniEQwU8puuL8hmmfhFHo+pq0rpHYptEkFo0PX6W0BKS
	UjrASqcAzMnZjLTPjYeBM2ABLqEKLOupnRmu8kw1AEulLP1vp8ZV9KF+
X-Gm-Gg: AYBFou0+Mw+/JE8fYh6OGfyNEBRqQ+uq/gBX9l8nd0V+0aaSr8QG3cf0P3gy8zxAU2Z
	wSfw6h1EyLklJrYokIo4Gt814vL2I68Ic6jrghPlBRo/GJsd8ofkzqzsY/L1QlttgFG1tPn+wIW
	OrRIPVWn8Fl1zARNqhj47YZaAfsxaZ9XsVPpg7thjWkXIwihAyC/E5MHBvFWOUqM55AFBVkKPrt
	M0XIpESnCM2Jgh1jhSb8pNOVR1K/XpU7zFCfSIDs4qQKqhrBaveGWCRoV1b5QwbLUi7toIn/Hvc
	2lKZ+DD0dRBCjz+nhCANDPpotgsNs7VwDjyJjDuxQ8uYcQZBvKlWgvIwDqcA1fqzYBNh5Y4l8wq
	vVI9uUsbe6HdkqpXN4LNHt25Scy+7SlWW8DfBo5qT9rTPiZ0xU5PmpDvU4XgT8RX4FShOC03O6N
	bI8XVVjvSTZPAMUMGnxppfTXyHkssytLaqSTDOF9OVvxAN0Thpg2YXfNnX0Ag9fe6JuWu4dYO/M
	8x1GPtZ3oLYNEqTzl+36xvEyQP3tpz0WTMEExToa6aGFNLJc6rOwJTb1x5QJw61GnRoZhp17zyK
	PUvCztJu1dBCiKUpVHvtm5LbDqL/s0QpRb71bLssY6KPSM6qQTPq+9UrrbMxlDHG3As=
X-Received: by 2002:a05:693c:88d9:10b0:36d:cd5d:d809 with SMTP id 5a478bee46e88-36dcd5ddad9mr6393862eec.1.1793892268569;
        Thu, 05 Nov 2026 07:24:28 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6d3dsm21647205eec.7.2026.11.05.07.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 07:24:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Wiseman <chriswiseman@google.com>, 
 Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <auwOBaRtM9p_Wxfx@google.com>
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4>
 <auwOBaRtM9p_Wxfx@google.com>
Date: Thu, 05 Nov 2026 23:24:20 +0800
Message-Id: <179389226049.111354.14491396975794516954.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94A271C0004
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: hu38au3empr4ym8whatsugajjnw1qmxj
X-Rspam-User: 
X-HE-Tag: 1793892270-656746
X-HE-Meta: U2FsdGVkX19jC+HdXwlM4Xh+2+VYVSI0zLKipSNNRhwCHc/jaG9KRvPwB1IeJi8waUMs4idhvQE9vYc78yBLijFFJeabXPKGlgxuKrw6FNXT6mWRryGQSEd705ZG+0G3Kpx7KdAFsmokzoytKmV6enEwFtK7EIJuKJ7dnKyAW5j8TFry21VvBtjhPpAJfOvtEgnm9PSOK0K9s3MuEuyhVkNCXU3kNW+6cvm3LkEExkUUkmyVI5YjsYq7bz8MMYyDP7xtzFLpkFX1qgpRCbOgGODSnuGDhdV23h6dYIXJ16Qwow+y2d8VTTCmbrSJ5eaqm95+8mdp5+BY0FcLVACawCz9OQ5IuC3tcdanaXxHzK6TMpJmGgN3mVAk7+QdVabltJ9RsQlNehIlH8GNoUqEZeGGNwqMhOw+B0SDhNJALd2YnixGbZ7Yjiw2elLhpMSWNPzeY6gxQTQJp7O8xqxBma2T/v99859v1sYurFcY/PDBcjabCc55lFHbxvb3LCI6k24KeEfeGvZCSKer2d5qvq5NfwzLJPB8v9bmupk1TV45vt+OM1EiJ3Pclds8C5LuG0Q5xulGt7zqA0hk19v9DeYwDAmGmNLVRb8LI8wlPEAv7LxE2i/Kw/lpSHsFexXXabc+HxX6Kzgfs1k6zpz9eTsVLrvHhEbukCFTycqrl8slJooVgCQhDln7mqULL2H/D/2/ayc1WQTfMwGP0/sTnA64XGdUCC08L+K2kb4d7mTQcbSyWEAFdoKMgwdlFMrG/QHPP3pBW0aOs/N3/ouNBqJQ9xMvFd9oGPzlV6CAE5MI1Y0sbP8ttv7qTA1tmMBBxUzrp0PPUbRz8WcNYBkzj5/6ERi9FsyIYifaNzEIzSAQ4ORVjseXQKzt6K5b95OlivIL3TyX+m1UENp8GmaSltyfrHgagxWEZXUlHimbI1ZQbRsbjcL9MUiYQOurBllejxLPLrFmKLvIKAM3u/P
 CySAeJ3b
 ou1bj66A4ywNwZRx7Py+cRLBp1CfSqoXYVp6V8T7WeUENNl6AR2VVwdecy06TWicp99rlznMpFeiPCwu2UpLUWkX8UWj95I142XT4cIv7xvXwggI2xjKEF8nORu1LYz2AYdl3z8DUbHmC+8fLR0A9puPY6e4/c0pF/4twWSC6KJs+gy1W+8QM0NLPTvhm61WSEk0JhWAQnG2A1hJ5OjN8Xz9EfzdUjCY7RKldPElfMiMWxUkfilEX60twnD8gImws71NMeFdMcb4EHSHNoUQPkjZqvA6P3r1zHNK5Y8cjaVDPVpsXeMXxSgGUcjGwtDQZb7xT4zUBO82qO5Ay4rZHoN+Oaqxxk0icw8PkeJ3IKvundSSPGOksof1kU8givW2Ygf8FWG60jTedOzTFWR3vGS7RzKn12MW+UO2s0Cdl9PoNJEzUC6CR8BBUzLo4uOMfd/S2yipFLuDbrZQ+eywezkRopzcvi7fPjMOWaN1W2csJwfasduC2ZiP2Cp7duX25MdE4VRcjqWGQyxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-05 14:05 +0900, Sergey Senozhatsky wrote:
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
> 

Haha :) Either works for me.




