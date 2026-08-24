Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF0FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B576B008A; Mon, 24 Aug 2026 05:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405E86B0099; Mon, 24 Aug 2026 05:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD186B009D; Mon, 24 Aug 2026 05:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDBB16B008A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:31:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 629128048D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:31:00 +0000 (UTC)
X-FDA: 85135643880.14.2BA66D7
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC9AD14000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="dI+6kXI/";
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=66966d6bd7=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=66966d6bd7=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8DZUU8ws4G48jL7qrLg2Wb7OYzN6HftqEYSYKuUsMs=;
	b=1Rd+I4VKxFLpjtkTRZE/tJD5rLfZLmvVaeku1AZ9runiNXNj6cOt+slE6RDZU8mqq58Asa
	ol9icwAMdJba1rXaaz4ThQ0gLo/XPzY9kxr6wOK1y8ifN7uPF+fNEGxGQGg0NzZJYufwHG
	7n1eeFTmVpCL8vQMskshx3G1WXYAOw4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="dI+6kXI/";
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=66966d6bd7=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=66966d6bd7=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787563858;
	b=bnjJEzIZYqeNAmiwMr7u/ts/R/LpmgyM62wKT8IUBikVu7ogaQlIK3Jtw+Vgw60hdp9pWq
	fKYMc2LM+JAilI0Gw4HxF0ViBLQLx+3/YN2HlibOwPFnPh9qBKQVAJyTlx5HsuvXAWFh9/
	W+FfZ04PFmxvrz7Hz41UCyQ8eMxZWzY=
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O9ACur3507187
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=M8DZUU8ws4G48jL7qrLg2Wb7OYzN6HftqEYSY
	KuUsMs=; b=dI+6kXI/kI9/KL41RJv5l1fMuKcdyyJvzNjCrXD4BzVev9ZDDi7z6
	OG/vIlJtGFkA18TaU1Ll9XR4WBd5mZNAo5Msygm1xzO3MKCzpMzv3WKxwTEwIFJS
	mKfrvsoqxI5+/foBGfneWDdiRAO97u3oCZqgG9PqRXtS4RqP6i//DMVeFUWaF0ZQ
	Vbk9q3mlDD7611LdGvfmJ5V7wFxiueKed11ZeMgFkrzJb3ioaRCsmbMSgZni+Obq
	bkmoX5DetSJKGkUuwHeLGjVcJ86JHE1Mg7OwW5pQhcO8YQy0Mpc+kdLKk0BcCj/R
	jrewLn2Z6drNxGGVJc8wPJVgMQvM8aITw==
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g7vdhw2f4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:56 -0700 (PDT)
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so418041a12.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787563855; cv=none;
        d=google.com; s=arc-20260327;
        b=ePRn4abvv8P5NFZxzyJiEjuW5RQfzfJx9mlf3Au8ep/XEluPCQLWwWGky1oZVwwLom
         MFvs126Vbk+BBKuyHEMtsmhYi+z8uLGEO1AunZtU33KKBCajTqjZumfv9P3kU6xnz9YH
         WUrTgJ2wt0LA5l3soGXfVX3cb0tP3aqYCncVjDjkZm3IxFGEQ3Mduc9U5g/dj46iOjtq
         T1hULVLQEPIaAHynMBamMntExtMhJ65XtBFWPZsf0IuIHWDX0PzwAoCxNLnnUYf8iYYs
         kEye9AOsooFPbvDcSheH1rXpiMYdCEUmMAN5eN8HA+jxoivlJ6SDFyOJ8vtNCDHzcRDu
         RzQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=XyGahnowQGCugdhIYAolZHV0Y8fYfsB6zeG38EzMKGM=;
        fh=vZAyQkvqKCaude6K/T8rWjFaohAhilKeAoLBw+L8MEk=;
        b=EHpE0/DRGHHdmcfzD+HYJmkwK2uePGRy7pkakbRSEmmbq49lpuPQHCQmJw2iQGDi5A
         s0auS/GZe68RCOf04nq1JlMXMj0JBo48BK1BqSa0GVy/pxpW+4W4ltwqv8Q8uApJlu4p
         bvYvttr0zLjIcNhZZgQJ3VtD+XgjLN2iIYz/aXkCatqSVhifXf7sTYdHNK8C67v/BVn5
         S0/kGwE5Ul8KPisUkMJwaOnKsO697n/oG9/RmUqU1VO1+R389OO85TdY5nAn9WFc0ave
         sTX0AutMvgy09NTxqwUj0nPKVCQ7q9pE9QNSl6XPOXvz2sYyf8Av+yAKH7TjhjctaW+C
         vzAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787563855; x=1788168655;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XyGahnowQGCugdhIYAolZHV0Y8fYfsB6zeG38EzMKGM=;
        b=hz2MLoaZi5PXiUyjNCZrAzu6zNhPBZcPVu7tW7EWSp9GLxLqMWqzt9qts/8Nr1KMzi
         wUQTgBWVfjSmj3tR2D2qAeL4aK72FFSZSoNcsg47ZGm2GgLFSttyf5Var2POLWn8M6sn
         xcYtmm/yRDTO2O70e0QKyqn0ALdV81Gf36YZ2IPT2Ig8s8RLIjNa9ZqFMgqOUjQak8Yl
         gotkBK2edwnaKngM7oSj01oPWsXt0vJ2M//q3sfKva4qwHn+vpWCPqmNc+R3Db2y7klu
         5/f4sOJVhVV0A5/Avaz95T5F2zbTojjzCBM4exVfSLCmBHGHLhu0tb7AycQz13Y5moOn
         Poew==
X-Forwarded-Encrypted: i=1; AHgh+Roy9LIgJDVkdVO3St3L+eoFmNIPgDZf6+FjWn97DojgZk3Wo/9si863v727HuYAMc6XU6TwG/mKOw==@kvack.org
X-Gm-Message-State: AFuF++lGOgA6iRdIpaV9yXH1DEPff8mp84J9sMKnOjNUHnwY5qjR0/y1
	8B+NuIIX7Prj0nPjhsikLEiWtYClE+mau4PFJSYZTAFfVrGWHKJiNutRXA17rk+etzhlNPDzZan
	JJXjcbGoLdE26hqnSQhbv105aX8WivhyrUwqpxmCsm2/z/0uyvvJcJtF5ArdLVC+puQ6v5SkVpK
	X1ocd8NZbBAOo3h7Y+Sek4XAs13A==
X-Gm-Gg: AR+sD13V7SGyv8QHhOhkX+EONCXoHmHmyVqbsqYg8tWWIHSJhtX185hPvoI4LhF1dLq
	4K3Xyr3CVyTg1RFh7jLXP7VdDu0u/O5jmrquveoIoPYYmv925ZRPKAByQ8sl1aNbxuJ30OxvUFL
	VJA3iuQr3MfU/49DETbUW27um54Kv2jrNi42ht4nAtEwmvyk9L46UPz/WZ3y1JMYfxFW4LMZRz
X-Received: by 2002:a05:6402:3224:b0:6a0:a492:1f46 with SMTP id 4fb4d7f45d1cf-6a582b2851dmr22005711a12.8.1787563855588;
        Mon, 24 Aug 2026 02:30:55 -0700 (PDT)
X-Received: by 2002:a05:6402:3224:b0:6a0:a492:1f46 with SMTP id
 4fb4d7f45d1cf-6a582b2851dmr22005657a12.8.1787563855140; Mon, 24 Aug 2026
 02:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-3-alex@ghiti.fr> <20260821083500.856970-1-kunwu.chan@linux.dev>
 <CAEmasaUzCU7r7DzJfMFbQGZCJvA_wOJifPywQmy8mOz0efWn8g@mail.gmail.com>
In-Reply-To: <CAEmasaUzCU7r7DzJfMFbQGZCJvA_wOJifPywQmy8mOz0efWn8g@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 24 Aug 2026 11:30:43 +0200
X-Gm-Features: AcwNN1WLw_SK3mjZC7TcCkXWM6DR-za3ljlbeP98cJL-kpMZlruczFTOc4z7ZSk
Message-ID: <CAEmasaX8QPPNFjrTWn4jn+hoC_q9BrRhia9Zz5FYHyzbMjN2SA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Kunwu Chan <kunwu.chan@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: J87HCFbFDwtk9pZRQN4O8wL_E-G0oWYN
X-Authority-Analysis: v=2.4 cv=PZXPQChd c=1 sm=1 tr=0 ts=6a8c0f50 cx=c_pps
 a=Tczdrg5if7+wQeIJmxD/XA==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22
 a=VabnemYjAAAA:8 a=pGLkceISAAAA:8 a=N_ursDZ4C-M7ivIJBeMA:9 a=QEXdDO2ut3YA:10
 a=1oAhN8tkTtOBK6_UvoHx:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA4MiBTYWx0ZWRfX98ZRp6OjFJIv
 JmgmxN9ZVNwbY46m5AFKuVSuc4ipIj1paerH6vzR37AglKOLHqBKNIuU1x+YwbgARQy6suauVkU
 /mvxYnU8LrBHAfS0pubseS4wLwbni44=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA4MiBTYWx0ZWRfX6uUB2+I2kqoe
 VzFIemW1u3pmNzFhVkR9CzHv4ssnOIXTBiyWomtxF7FvYP9nQY39ZI02vrkeAXJiyeTF4ZoVPDw
 eybFSgppvAKKuwFMGTmnMqkkkz9+rTlHAf/vxfzu6EHyHbPZoc7J8NQWZFqHx8mBC4DG2SqB63E
 IbxKrHJimtPpRn4jumHCuK0Hvlx+xFbjG7TVEuHAyTnViQULZXCZD38gAqo6ScjZqGmr3dBb2mW
 IXsgqG6byNMcDuem6RhValqylflSDk8dRDiRjac4jqnpZyfb1pDyVNEQ1Pp2rZ6SpGWdL5tVCO1
 D+91JoXN4QmQq2r8zOvDhF2rT53IXw1nYDPNZ70I3L8Lf0Rkk9116ylhHMOseklsZ2glXo7xoUk
 QryO1fFWAlhmfeoPOkmuDXD3FVfNK1c/XBO76vEqG88vyr/JQuofPOeyvhTVsZaWPUh/zfhL3uh
 dKyuPJ8FYqeLMaT9MUA==
X-Proofpoint-ORIG-GUID: J87HCFbFDwtk9pZRQN4O8wL_E-G0oWYN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_03,2026-08-21_02,2025-10-01_01
X-Rspam-User: 
X-Stat-Signature: tw5qrm4q88bduwpj1up6fkm8hh8m6bp6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC9AD14000C
X-HE-Tag: 1787563857-977295
X-HE-Meta: U2FsdGVkX187eQmtTSzJ5bv0NoER9W6Yqxp15MDfpo0KPk8AGjwlIfSE1u2VQWsGXQeeT69Az9SVZ3qmOV+THsrhd7p6NEFbKT99qqQWToCJCE2CnvdwwksoGA3Q5Lb5MHuYBPIvBT5Tcn0Mw65y6bVW7Zl3vregYTVQWonFC5b4n8qVY4Rp6FV6vWlhMNzGCxQ8O6oYDignWZHqTcu6kEPWcYVDyDw/aYPCB/tDNLUbmaS3zwvA5pJDKzCKJX1ktPJ3oLqhsBtmy31ek14G/ABBLK1HLoD6SqXRLtRCOdGFWzoiL5tza5vdQXVeT/pN62EITj5YJwhVrHLMVEAWp6UO5Gd59Tti6bts2vqEqRT2DnjDyWyj3EecQ/k7HkSQZZtn94dS4JEEI3+mPP6WAqiW3pOGHUHkXZ5PmRxfzNX+U2nEn8tPkNyChVkNHFstE+wDV0PbgOFKe1TCejhRu9CcJLVWkIaDCC0BTib7qe3bJefTBylptBT+F4YEOW7Q3R8NlHd5aPlJmmrnGyblbjpMS2ErkqYDpeuz0beYkW2EAo94pfKaopgidj1M7aGBUR838LUWeDH5cab+z+AV6PQPA0i2ZFx/nvEEWTZYYF7sLcYbDOe3+jpdqZkiAV0ggfYq9LRVVRM0PiY8+SznwLVSe5Pz4xSY11Nr7oc+cjxfmYdgOC9XgzMxMnLmp9pdgsg07ZEPY0t50QqpXYXZDavsJSMALkCOY1hlT4V+VqVYOiyPHA6XVxYwElRdzRe5lTQLpSk55CM6evRgRa69nKcytu4+iJ8/VQJnBVbcS6BbE0OkBOWGPHpHxzdImma3CDMRQo7mKSh/cRYp0ztUbNk+I7eagC/JeKnOMxFxzye0Tp/0GYZK4OUtO169d4O5DzYPbbkDCQp72HObJD6HdGXG9Pxgsn6Ah8bCHVb6DvqLESF8kpLedCkgbuzLV7os3U/vwt1dmZiyJsQANao
 NDtM3N7o
 ZjqaKGgWsPMA6khriju1GU29Ek7TiaqAESuTcAptJgjSFfHYCjY6VPysbDKuxPOCbJV9VMxDBtSIC7mxDm4mytFrdbu45kQjnS5DVmvlvtjHuuVud1Pq5o4lLhkT5rQzSEQgPJZUT8EEB3N4Nn3dDgF09pbkPaeOW0h6bOcwLB5yQUfbhpjAQL9wZBrh8Q2Lt6Na8CDu58JuWcm0bxp2636Rx3AH5R4iHsU0JHJuCcVmuDC2tP8CMx4ojs6CckH5S4fvRGKj4unPanRNK/5zpepZyh8H3j077ixdMTK++/noIJt5jLpfD/9VYNfo1zhu13yXTHLpSraHDL/LvPE5U+U/xgQiHMc/I2agFV8zw6A/ZtgAsFuykL4AsnKIGV8BG0lNNweqw+qz/DrfIJdlOJFElz8idJAPJ4Jwqc6BuR3vRtYWC3sPk+3kfZTQaT3hykow7O/w/nedEngt8jHrHjZcrqOYYbFHIE4i8uDOm5dzyxQzK59Vt/3Zyj3jlkzv1odrMe9p7tQYNq1v9IwUjwfZErM5I9m7NCzzPnRSqacHoKnujV+sdkruBvq2NtklLvWAoC8crTJFapzYgKoIDBnX7qtJmjfi4rfQ45uGl+ptU6K1rJMlKeS50iHS0tweziZCG9enUowQazMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 11:53=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.co=
m> wrote:
>
> Hi Kunwu,
>
> On Fri, Aug 21, 2026 at 10:35=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com=
> wrote:
> >
> > > >
> >
> > Hi Alexandre,
> >
> > I have a question about the reference ownership/lifetime model in the
> > synchronous-IO case.
> >
> > Consider the synchronous writeback path in Patch 3:
> >
> >   zswap_writeback_entry()
> >     folio =3D __swap_cache_alloc_folio(...);
> >     ...
> >     __swap_writepage(folio, NULL);
> >     folio_put(folio);
> >
> > During writeback completion, Patch 2 does:
> >
> >   folio_end_writeback(folio)
> >     folio_get(folio);
> >     ...
> >     swap_writeback_dropbehind_folio(folio);
> >       llist_add()
> >       queue_work()
> >
> > With synchronous I/O, is it possible for the dropbehind worker to run
> > before zswap_writeback_entry() drops its reference after
> > __swap_writepage() returns?
>
> Yes, totally! The window is short though and in that rare case, we
> would fall back to the initial behaviour (almost, since we put the
> folio back onto lru but not rotate it). And for async devices, I don't
> think it can happen at all.
>
> >
> > If so, the worker will attempt:
> >
> >   swap_dropbehind_drop_folio(folio)
> >     ...
> >     remove_mapping(swap_address_space(folio->swap), folio, true, memcg)
> >
> > while the caller's reference is still held.  Looking at
> > __remove_mapping() in mm/vmscan.c, it expects a refcount of
> > 1 + folio_nr_pages(folio), but the extra reference still held by
> > zswap_writeback_entry() would make the actual refcount one higher.
> > It therefore looks like folio_ref_freeze() will fail in this case.
> > Is that the intended behavior here?
> >
> > If the removal can fail, the fallback is:
> >
> >     folio_clear_dropbehind(folio);
> >     folio_add_lru(folio);
> >
> > This appears semantically safe, but it means that the dropbehind
> > optimization is lost for that writeback: the cold folio goes back onto
> > the LRU and has to be found by reclaim later.
> >
> > This seems particularly worth checking because v3 intentionally removes
> > the synchronous-I/O special case from v2.  The cover letter describes
> > that special case as an optimization that was not worth the extra code,
> > which I agree is a reasonable direction if the generic path is
> > sufficiently effective.
> >
> > Could you measure the corresponding fallback rate on a synchronous
> > backend (e.g. zram)?  The 99.996% success rate in the cover letter is f=
or
> > asynchronous NVMe, so it does not tell us how often this particular race
> > occurs with synchronous completion.
> >
> > More generally, I'd like the reference ownership across
> > __swap_writepage(), folio_end_writeback(), and the deferred worker to be
> > made explicit.  If the caller's reference can overlap with the worker's
> > reference, I'd also like to understand whether that is an intentional
> > and acceptable trade-off, or whether the overlap can be avoided without
> > reintroducing the synchronous-I/O special case that v3 is trying to
> > remove.
>
> I need to look into the patchset that Matthew and Barry pointed to and
> check if it's still relevant with this patchset on top of it. If so,
> I'll add a debug counter to confirm we don't fall back too much for
> sync devices :)
>

As you noted, in my implementation, a race was possible between the
worker and the folio_put() in zswap_writeback_entry(). Now with Tal's
patchset which *only* defers atomic context to a workqueue, the
dropbehind folios on synchronous devices get freed inline which is not
possible because of the reference held by the zswap writeback path.

But it's cleanly fixable by dropping the zswap reference before
__swap_writepage(): the folio is locked (when it is allocated) until
writeback starts, then PG_writeback prevents the folio removal from
the swapcache and right before clearing PG_writeback in
folio_end_writeback_no_dropbehind(), folio_end_writeback() takes a
reference! So remove_mapping() is happy with the refcount :)

So there are no more races as you pointed out, since we drop the
reference before the writeback. I'll post the v4 today.

Thanks again for your comment.

Alex



> Thanks for your comment!
>
> Alex
>
> >
> > Thanks,
> > KunWu
> >

