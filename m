Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACE5CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78A86B009B; Fri,  5 Jun 2026 13:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A565B6B009E; Fri,  5 Jun 2026 13:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966686B009F; Fri,  5 Jun 2026 13:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 859326B009B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:50:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34CA114023F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:50:43 +0000 (UTC)
X-FDA: 84846599166.28.A2DD1C7
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2BD172000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:50:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DCyr8UGu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWtfjedIG3N0dLb3NUTN1ftwb7AjvxqbbhQR5qXgkIs=;
	b=TYkgopIqmItzeSP3ILQlUQ5yKAipEZz9w+tqHL9JD7KDd/hCu5Y7HSPE2wYeNdP9fPdyZ4
	+CXb3pcRlGb4wKbwEiqCx+/D4vE/DeRqS0Cl/XRJEndoZ8lYmTTSicXo4ZnUIHevtp1QoO
	rFu+fRAyKKS9JjCwVAoPmCORtERaMsk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DCyr8UGu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780681841;
	b=uxCELT6n9mml7XKDZaeEWQTx6TwlXJwfnU7TBlemJfo0OfUCzi3T8MBJRkdUpsKJXqxMr6
	725z5l1LfKu9heuVAM1RjUBRAel4QjMKkQgSOQlH3Zn/x2pt33SDrQZIPnM6QNbXo9yNg/
	eAR39zWw18CUnnk4mbcSvjvS+qAqUn0=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso1102216f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:50:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780681840; cv=none;
        d=google.com; s=arc-20240605;
        b=Nze+wG4V2gp1Zkz4Tud1/o5Bgne20SNvuZA1acCObr6OPmVoHR+FAlyGuQ4bhWLaSO
         j8LSw9He8IIZNRZSbuBohouvoDF1rPysCvmjLnFth2dWKnJPzgUXqE12YSDn7b7QWCfD
         hGcIym+Li0Gj62xA8H2YQlQxEj3x6bq1pWBxBGOFxYTkeiE+v+bpzAFWTVKsJ8okqYfa
         r+thZDrRzCpazuhcOhRFOM/ianI6mxzvmATlXrd3f2c8OWzuJZIb2P3rLZY7jNyOtJF0
         /j1sjvL6lVv8BssrKS9nH0G/cVGiBnN5AqXPEyXq7Yed0LwfLMgx+DupbSHEpCilUcQU
         ZqOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CWtfjedIG3N0dLb3NUTN1ftwb7AjvxqbbhQR5qXgkIs=;
        fh=NP3uzfdIgMnWzYkJCdZJ3BlWbRluauxwKRjiQPMFlAw=;
        b=PKV9Zxn2Mn+Ky+XwtzXtawZzN/3lKL1+lFIXMZN2hDvZuNbyJquGK6jqaMVC/dIQpy
         ne21STSTuF0CerBoGgPPq4KaEAhhtBZkAJmUAUHZrV4QdxyLMnDGk2RWjht9gRo8064w
         Dbv/FsQ6KYtXuhSxLMlCE3L5sc2BbmXxqPZit1a2/yzhINbtMAa/Wd+jt4Ea4+wjwALl
         A83OVlczkJRvtc95loLTnWSs3bZGNBCrBHNM2INHSqGWK5CwOcTqk/GVp2tHkp1ZgbiA
         dtnpr1nY4HR6vjJ72HvxiaRSC20caVU0UrX3EsXvuNY6Q31xfoapYyLVk/vsm/cwwW/K
         /I0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681840; x=1781286640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWtfjedIG3N0dLb3NUTN1ftwb7AjvxqbbhQR5qXgkIs=;
        b=DCyr8UGuaueJpZp00NlXxeR5khWhcoU9nktxjmEX+yk2jAwOlNYqUzN6Et6ktfzcPR
         t2IW8750rAVCDyKd5Cb+3TWlHWcczsp1z7+ise79eyDkzog6NKz63wFsNCAtGJcEd95E
         xtml/AiAPnVTuiuuyKsWkLN3QG9NXDtK/hxgyGta729wBFkdgsJSndUTcUmLIKaOz4tR
         hwdN1C8WItvvKSZW0b3VbwP1iqhZgS0BwUh7FWk73NoR12NeMq4IEL46Feyq28X1JLc6
         2JUxqyECP2w9U6Jcu8yjtZsqy/VI3u9RNkPBX4Gs3UAaPZy2/Q6nycd6rg21U+e46V2S
         4+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681840; x=1781286640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CWtfjedIG3N0dLb3NUTN1ftwb7AjvxqbbhQR5qXgkIs=;
        b=TTG1eave0T35GJW30xbQdtx1YAhksSj6CNAEbZ+muPbh7ve2lOCyalEWpDbh+LzEGE
         7bRGW2aSUoq5HBYaC/aCyoq6+4Q4HmVMAUDvO3PrMFMKNw5HhQnMa7oPSjvj5qzggZto
         ex07tW5y2oRzcKGcW5e/oikHVvluU04D40fYBJtgitZotp5RcRzxtofREwF+1U0rJSB2
         zWmOuJ+as5VEXbhZ7VNwaLh2v33UBtljJjV1HK4hBPaJ2La85KH+qjKm/stipAwnsROm
         HvjgkBhrufIF9jPe+WAGQ8nve2KchyCZz0lV36cNPGfBCgpANlffJ4WAq/y7zQpy+M2/
         MXVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2AW2Ui8I+DADRMwY7hSrvMkqhHfriCpF4UeSeXqh/mwi09xvSNXi6aLJh14Ab1sf/1mpVA3FvGw==@kvack.org
X-Gm-Message-State: AOJu0Yyn1EKcafkSWYlAxP8ghQ4ApD49GB212Q2bLMHqCQgsLg0MDWNf
	+OKEl0bh3ThMKZYvzGPSeCQ2OUlUE1FbWus0nP73LwCFZBfa2GbEDfVbQWBz+vLvdYLTZyRq20A
	wd+AOykHH7koj2/RvzxILwOOgv+bC85U=
X-Gm-Gg: Acq92OEIXHr/bdlUspYcMxpK7M5bzuocjB9ulqUTik0GprWqkrSK9CCb7wgqVa0jjf0
	sWn/usgZ56/dZ7hwQszvxkGXy8TKYoR4ghH6YEghiNQZ4Gt5bEVM7lUDJUZB8c7BSOcFXhfDimJ
	YxwC0CY4qG61eYbGk9FLC3Jvs6YxBqtx4EodWg6+Fd+BIcF5fdEbJaJAQBXGitjqmk38VJxvqPU
	4f0lGnlyzFuhNgGqW216KflKs5xxN87xxqt2xgTDhSQ67nDwWbKe31T/f3Yf+t86vLxxKkF/whh
	RKfnuOQ3AWkhI0FxBqVmvPK/oP8yGF7eECFuZNO8qq2qnUmZEw==
X-Received: by 2002:a5d:5e86:0:b0:45e:f46d:fa95 with SMTP id
 ffacd0b85a97d-460301814d3mr7727837f8f.0.1780681839734; Fri, 05 Jun 2026
 10:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-6-hch@lst.de>
In-Reply-To: <20260601113449.3464734-6-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:50:27 -0700
X-Gm-Features: AVVi8CfC1wbNx2TjHrUqjGLNgOt9Fn3Dei1FVAHhg6EnkmT2xDTr9x02LTUsonQ
Message-ID: <CAKEwX=PvysjBk+nRjTMhXSBqFwXmq-OpWF+=U5WzNqBuQa3UKg@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/swap: remove count_swpout_vm_event
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BD172000D
X-Stat-Signature: cx55r6g7o7jbwfhf913ehu1c6qpcs44p
X-Rspam-User: 
X-HE-Tag: 1780681840-444187
X-HE-Meta: U2FsdGVkX1/SQ2lndUSbAGnK9QDbjBpI0rtdV1h+bs6/CuJr3idTLEcz5babhjwhlHggy+5fJIrAvZ0+NR1KhBZZAs0rJmaap03Myya+XJ/yBj38wm44C+b0ISdvblwZ1g0LiE+1Wf32epKgsyrU9TFAONwJGIA9sngkdTjbONxetP2VqLpVW5o0gfcabbjvXV1VDgcENYdA2KSh0EimVkX61CEhOR70jO45cfpZ0yNNLczKKSNOwB4rRzeQ6CICCaXb1uLBTQl8/Qz33ppO65lt9iSDJ3ghpkz8MC387ekG1DScqiu0bVd+e/VXG+RUBZd73mDTYefWLVco5MsaAA2pDovImaAJunIIsG9CdqPHv09D600/MmJHc1IHdBAJEFh7KYFJQ2FT8jyQNLP7CrFYMIMLfvC9oA6ARtjzNwpw+oCnBjuznatGmaSriUqxlySOAUNs8LaXikQqK/i4lwhZ0ZdW4ZpDC8t5n0WmiuVpom1bFqn8tFTn9AZwDPn/pDJC4RbgYp+X/zNgkR8J1HohFQ1Xv3tASSDBwl95QAAThYh+/M2KVIJ+nuPQVRmM0KQphDZ7D7cUvLlBS7IwTerLxwbtGnK2aH1UY7ZNyVV/km9fKcAR06ZSUC6FSTMVzS2JwUNkhyflmUmjfKZmKm7n+B8QcuCmgsi3VKLZZXe/HvdjAyCSeXgzCuAS5+fwh5HyQCrhAEqbd4TGwwewV/zKjz7FUgTJDlMq0Ar+Xui1LIS6QoJMfbAz09HAd//FB9uO42BgVbfeuAyb4mXfYegsJFCl/yLSg1/XCSKR9hRl3BR/4/UsaikJTo+c8xXuAYQyXr6gOJ5O4JjXC+5B9DVCULKIH/loq1/FBDFM9GI/WNdcXtPgTd19h7dTeBYsTHBRv7UxBIXTRhzsS3tu0w/gjrDouVL6XKS42not5PC1jzl3jeBySiePq0JmMBSG5Q+J4qOWHlRSnN2/VTn
 olwEZxUv
 0FJri0dfPT4QtBnp0W3tY2khgp1TDC9VSLz2O0w0IEMpzsXqQvimIOgPiLdCU84YxE2PhPBXXGeyoqhFWmcF4+pjkZtHnKHycGoqk7D9Hj5PUmZaxdemDkUhjiabIlMvAPgjbG8k7OW6/wNQTHcoD3TKEKqZVubvjZ+ACYaCCcidjqf6XjMViN1WMC0hrlDTmlVlsfYOSsr/e/Sdr8GaubnRP7WhLfciF390pkiPLqXItC00GwMOQMNsvxdKDKKhiwg43Ge+/3ACSEns/FZej62qf4bK0A4Lo4mrslvMFRgnI02373eYN6HnJXXwedSps5UiVODUgdsz5L4wvhmUGJParzxfPNOjxzp6XvW/xz5ZOA649G6FB4urU3dkC3wXWqwW77DrjgqvfWNsCBHhiSBdIZ7X2GQf5M7UfOoPGFjqaxv5YTuqBskGFkx5f6LOypUVpDpw62jO+yc4/bSviNeI53+Kna9LVkzJ9E4reOG9VggQKmYnk+xXuGzxVkw47oZjI9ejVSGB9lan4Ck8fnDIm/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> There is only one caller left, so merge it into that.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

