Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C50606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p2UZzfty
Received: by kanga.kvack.org (Postfix)
	id B35286B061C; Thu, 19 Nov 2026 14:15:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CB66B0690; Thu, 19 Nov 2026 14:15:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB376B066D; Thu, 19 Nov 2026 14:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0A36B06D0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:15:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1346E80C1F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:15:03 +0000 (UTC)
X-FDA: 85452821286.29.AC001B9
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1B227160005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:15:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p2UZzfty;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795115701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfGNZp0FqXRF14R2lEvSl2W+3CYQf21jFvNPi6RI+VM=;
	b=wq45f59K41q3ofhLtzQYHJrjJw8w50GgjLrBg+f8SV1emq4Pl24zJv4LGqbqo6fT5zxNGT
	0KNVidiGjEbioSJ5fqOp4IiBKDxYYizCEzYDGDnGNL14k3btTdgaYYeBAkhfT7mQzwnmGv
	o94uYZSbQo8pFShVmxbQ1ZGLb/ZfteQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p2UZzfty;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795115701;
	b=gispxzwI1M8aM51sC8ZQ6mMGAL1tsxxzjm8lMsMUzozTaeslFkdtuN2I7Jc8SakZJWHPxv
	dHgwPJomizLS3/WdkJfLF939Z8QdG3rcY9aoWZiTMwI0QIupR0RTQrAtrk18UDdiOuReOH
	BAmVS/ERT8vAws/gwDo94gdRWEq0i4o=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso24487f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:15:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795115699; cv=none;
        d=google.com; s=arc-20260327;
        b=V1238yVYMpdu7QnDlyKkfCHjmBLzh9PpSj8gBJzBOjo1aPVPbYA5saYPS0hRXLaGI0
         asNh2+/iBljZy0Xc9bI3STatBV5uCpqFw6SjID/RoVqzVbKDAUetobUmoCXqVxBjSBpT
         u4Z0nSBneUgyK798CeQ/RbE13urglv9r/fkMH79kLSfF9CTSrxCDVFLUHmAz2i+hiWZo
         PhEbL0uznyrV02QJy5WI0Rc57D7LYh2tK2iQrt8i6xRAE73i5/CHnTeDhoIybMgHHZVj
         frXCPhZM0PFzM3FnUm1pX5B2lW7a0XA0jJTX4V8UwzdiAPeVn2/4sGxTNBizXFj2ZiiK
         Edxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZfGNZp0FqXRF14R2lEvSl2W+3CYQf21jFvNPi6RI+VM=;
        fh=vjK/GF7150N8ooBi8cr8c0tLc0wr8wLRRvEYjfe/lpU=;
        b=a9TNlsXPr1VKRB50MX4kYdkw/cPR4LW9xLo3++Yowxna0Dcwx+PyeWdxuBqmCI2T5q
         hckz4NPDRw1twUmxjl/85cjZfonVLBe3P+R3hTFpGrhQ/Pkl7RfwWaX06yauOjwGcKwG
         O/4QWNMXdR8RQtVCbIzIU0NOvPbtTkmREYf8Y4gseVq3PnglwjKV9VPcbcZM6T2lgvD5
         3RgI3bIJ+06jsfGPr/L7DbGGqRMNXo3xb/o+xrbVA1xSlnpdqQiR8zpoMqV33x45n4cq
         ocE5/wKsB/oYEo4NB9GfwwYAbjwTUKwWnkW5X4yEofwKySeHUmrbb1/Zn3Z6NLkr90/j
         hb5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795115699; x=1795720499; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZfGNZp0FqXRF14R2lEvSl2W+3CYQf21jFvNPi6RI+VM=;
        b=p2UZzftyc2rYBWGlWZyLzXLTk6UHpFRc7G6HR3IFBXzypRx4m4UrZTtoSkZtdJkIuY
         4v/t6Vw4pzvfByvkXFRpmQ2uceAAkEIZG1fl5bsV98gwWMNAeIZrIHA/xvovbr/oRwrQ
         xblVuaXGTZz7aelwEsXiem5Ow8oVnNfmdHgJ5slAIUfheft47roPEjzXit2mbkPRJ03/
         riDjO4fefslqP8g/CRgecRPhMcHwdjS4ylw6Ar4B3nJIGy9bEb0bGJdtgZACsoCrPqHd
         Uq0Se44gyyZosmAGuObMgrVbtGmB2hOWN3UWXgxHiaRRnZObOOi/1d3MqMLwGRu7VRe+
         R7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795115699; x=1795720499;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZfGNZp0FqXRF14R2lEvSl2W+3CYQf21jFvNPi6RI+VM=;
        b=XyptJX5ipDaUFgH042lTPjswfBHtpH+Lv5cVILCLG317mw+ym/ZM/hYl6LvA74Htwg
         Ybn/EweL2m+oi1AAF4ETCNOEu77KVGaZ6Nwhw9XizBPWT8dM7/QYBaxr0EQVZdNdSz9M
         CnT1KFuh/LcCng+b5GVnrWNbcfGaR6lxVxWDWY8qy8aTUYFDkiifY94jG/5tr9QkB+EO
         ZfTaIB2OHdXjgnEu0cMKs/yf8NrNYsX++/SUGVJzh+z85NM0vg7OiwA7cGGBO8yZocwm
         QP+0vgdxyufVYPMJYGGGJ9u5eFJJk9bNu6zmvAar/imHmXLe8KmB7V5A6sMb4B+4Z58a
         ZS3A==
X-Forwarded-Encrypted: i=1; AL+hErEsGfiKaxK+KVAyB6eGfECQypup0+vAllCN1Ezs4ylyYWPgOXzVBTK6z10LU0vf1SaOrpY1mSv8Kg==@kvack.org
X-Gm-Message-State: APuU4Z/Oc8BMCvrj330qxT6bOo//lZRlhIoa7gZU3+fx4Bwf7iG8fyTW
	deQIw+NWeCYriWA6rOPjWmpBjRnpOJHVfV1Uv+Cmhq7bXFAX5tO6RdZ8xh0ySXHOBtxCYbUkulO
	F6TPCdXPOgRbUB0qMjzoR4TYyu5bRKDo=
X-Gm-Gg: AZFdTZfgt0gxRi3ZgEaL5BYMLISQUP/HpNIfxlpHxGtNnBo+tNSXw3VoULIVkY1QRqR
	qDcu816vSr6th8KxyygsT5pHrpgaYk2LXpIC+Fq8UrKfGXUJNXEImdAmONqcaUq+eCb7Y8z/DdE
	c4libbwWK8hscOWo7zFSPIAohAnBFLwk/4zVyszAGOQyIK9vGQufF9wCIzmjZBnD0LCV+UTQTei
	tCqDLJUHrr5e+2v+v2W5427TF3P5BOx7A46wGgmMmr4bnx9+Fj6s0/DYl/HUxhx/ahvRy9dNy5R
	tFEFKRPqrrHyr7xy5RowxXCzkny8laXgWO6yGQg4pcNXUsGvjc9MeXrDeTIV1XL+j9//g2asBjs
	VFN4azC2qea+Pij2J1wEkVrSgrxU6vBX134Xe67mU4f1TpDs3OTtqisCpTbmqPmH3/IEln+tjdH
	jX+iXW2vTr+hvw6YwlJUYNN+Z6XcGrlT1a9R4HN6H3dFuTePGq73AS52+7ZuRzAecpk81Oxw==
X-Received: by 2002:a05:6000:1a8d:b0:48d:f39b:83de with SMTP id
 ffacd0b85a97d-4abad6a42dbmr895329f8f.3.1795115699220; Thu, 19 Nov 2026
 11:14:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-4-2f845e94dd50@amd.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 19 Nov 2026 11:14:47 -0800
X-Gm-Features: Aa3M54ofpta_fbFOGjurxuCbx318jL9bD4qka8Yzj9XEA2lvZOYSWWxaKEQlFjA
Message-ID: <CAKEwX=OUgd9pMbMDoDsj3z8+D-8SfEc9SDe3qX_CcX30pCrPTQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 4/5] mm/zsmalloc: remove unused zpdesc_lock()
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 81f1h9op64c6rd8j8caek9bufpj9je11
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B227160005
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795115700-648545
X-HE-Meta: U2FsdGVkX18UnyVYh1H85uCHiKTNyABmmjwBdvTe/iyNkQ3jXCbk/Qv9yRp1Pmy0QGwwhHhgNsV6K+cV1xCE/BbVUhRjLziP7ngCveoipQQ979Gs1torL9M4xC1MdKFRw+L8ErPWL5gM3WPUzltT2U3VTQ+Pf9YNJ52thZWyByWVqmBzQ4QHzRw0W51dD0j4xEh+B9fpe1p90fvYTjgoVx8aCLeWsmoJfNoT+rKC+AQw+zsry7Qiyk5v+DAYT6NGFvisB4trGZEh4Wqik/6MXC2XcV1FuWGw8o2q5xj7XGl4KjFEWZ7ePoCn+xGubKm3kdyRBkPA0aYPUVOay4NhQzwoAQG3lo8uS3OIv8MDWjvd6plpiC4MjWg/ipAHhloM0xJ8IMeO56WdMIUP0QGLTI/ZW8PizhaQ6RPOm/1EfsACDTMjcn01Mi+qOVk43mnybL8A6Hk86ENy23OfPAsF3YF6wBCFIzPr8yWxUbL498BCpAej2wMnFByYjB9PwcIpYVCByKJedq8WoFdS6nLQ2mfuv82Y9YSEGQzba4rBA2fQPNv1biy/vPvFJ1179YMXnAZ6udk0SmwUz6ID77uPdji9gy6J1xwwJApA9ytAA7Iz2OjsoY1RhG1bwDlmGZTWjmD9gd28x1vY6c5Pt5KX36hSDXjxEBoyxxG9r0BPKoq5sxIHNAlRpky196ZceMsDcO0wcgwvhpxhCtS10/aLHkY4ZDOTE8hk9ISyCWOXhF4TXE/vfSSyR5pUiAX/KJGShfu/GWeHFU1XZ64ZUZMZqysfHkB20gLQ7Tqd3wAaqXxRBJrGww30eDKP9Jo6uA4+1DCXLm5b/Cnzs+tQJ6cm2XM7MAGJpOA10Z21lwPTIK47D5+5EMpv+00kqjbVBoJaTLmoNeNKply36+iTUqUHcJxl21JYMsG9v9EYkjLNqmwj3byB5/XSGHbKyKHWWV6wKDHfuDQq3HjnNTGgREl
 6fasCl+k
 dmvtftMDgf7JeE8gGrIIE1EAez87IrHU2AtSJUrYoqfFOnBvnZJp4x8SGLweisrVAPJmYYA6imTOQc1FkwMfIiBSDWertKGhJ6K7g2KczW3S3lMlbvVu2hWAdXvbOy4ju3wspGQPv3iH3tztgi6XyMqEPcGXYDd6f9oc+t0c5uXpRkOUYrPby8b0c/Gk5a/p7qT2aUuBvlTm0bFTpWzJLxmSgvKTl600Ir36Z5q1YxRc22Pqsw9iNXS1W0KmxLC1L4LS/THUrulPTnPsqDWKKFVdTt5CT799tim/vVqig9coAibhDmkBa284OtXb2KUy39v98wYP7Oyg8cm9lNjczUUGipIXB9AOTdAMVvInTCjgV7fN7iftkXAoKbBhqG6TmjJcUFL6UBQ2ER/15O3LlP/5rt5XGWkvnbrTAmq3G7/LrhVNoPLUTPTd6VjVB2t6CA3Uxt7Np8xM2j86pSDY/lcgncPrbcStYkwx+h79HxxJ1DoFo7MmJMuwwoBmev+GGsfFjSK16VI2+hnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 11:17=E2=80=AFPM Shivank Garg <shivankg@amd.com> wr=
ote:
>
> It was added in commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
> trylock_zspage()/lock_zspage()") but has never had a caller.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

