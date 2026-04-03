Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AE4E8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 18:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3AD66B0005; Fri,  3 Apr 2026 14:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12ED6B0088; Fri,  3 Apr 2026 14:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28A96B008A; Fri,  3 Apr 2026 14:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAA36B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:02:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0021EC28AD
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:02:47 +0000 (UTC)
X-FDA: 84618015174.06.5321234
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31C1BC0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:02:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xux6eJIG;
	spf=pass (imf28.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775239366; a=rsa-sha256;
	cv=none;
	b=QlqBsss5GDSfHjzbcRxx91DVqW+joC95R9qLRFMyDPJSBDPcJRJfa/F0XNFFuS4FajIlbE
	keZJ8icMjhtJxsAIT6CnuAHANWsfB9A1ZrSsS2jhxpmte9JTbreLUtC2b84mTr1xJHzur/
	SlCeaRza2CkodQdESJm/BCTF/Qfjc20=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775239366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+bjYnRYDK3b73ziWtMH8TtdOgQycVENyGkxU5lzBbs=;
	b=aM2eoVQ0/Y6ayxSvHLEGsMAtpSoC/6kBKklxOFf6WaEGKjR92ACXzKuB4aONue0W/8p1BZ
	+Z0N1Zm5hq6GDChp/c3ahUpKR/RXlI7N4BsZqs4276t8yROqVg5IQten0GV2mlaxa8cF+Q
	6HtVCn3G0hSLhYf73/BEFRncWJ/A3lU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xux6eJIG;
	spf=pass (imf28.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b2591757fbso112635ad.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 11:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775239365; x=1775844165; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+bjYnRYDK3b73ziWtMH8TtdOgQycVENyGkxU5lzBbs=;
        b=Xux6eJIG2ehFh5K1b8478j/Ze+Ddq2B4cwK7BdV6J39WB3MgzXeT84N3tWrCAIk472
         y3YSWEwiteVF+mVPBZFhA+o6Puv6E4gYFXM4sEK17q5b/HnTIyqSmg76fRl+ms9gXMp0
         UtTJb/wPeWWzWUiSFR64+m7+p+gxeihfqzKlM9AGspmDFDyOhNc668ts1XVGK8ph9IJN
         Tc5Jq8A7fJUXTjzLVONuqN5jYq5RARSfrYjFWNTSvGDmPZFZP1zqfmAOqrGx6wXjcuWc
         VBZy190u745EoP0PBPfr6I6pe2jXuDmJ+FEhZ+fj9zedlbV/ejiYlPW0u7C6S5Tt2dsu
         87Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775239365; x=1775844165;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T+bjYnRYDK3b73ziWtMH8TtdOgQycVENyGkxU5lzBbs=;
        b=k28fex71nqKDmOd7ztNW9SxDST3bXZQ4t4WezMyyfTP4Fkmg4r4nZlwblU/qbSXZwQ
         TkMH1GCa09DxtYt/S9IQH6Al6farNwujK0eI8aRYITqpcyJ93to5D2lQxN/bdZbbFTLt
         IWj/YTu+Dx7LVFNUInqKGpe+u66lRkkngVAG9esQlEgLEJnzacZK3oJpwJLwaI1GHr4l
         tTo3iNDarEdFL1PEyjPXRuB54FfYq1K9dvD9OuCFAnBRibYo1mAMeJ8pYYwVroKalxIa
         zF9znoiz2JKgmTGq/tHS39NW9ubTGOa8yc0/hqQlAFT7D/xJfjzocpMLs+C58zOhk664
         jBIw==
X-Forwarded-Encrypted: i=1; AJvYcCW6Cm/+d9WmudmFUQ3xuY+xVzRDy/yDVCMHxOeDCxKRLTR9AByb+sevSIK1xoU9+YaxsN7Ep9QyJA==@kvack.org
X-Gm-Message-State: AOJu0Yw/slqxmCXCxhQSb6K1so8rs/KfNkzTNJmiRjNGl5QewQMdX9UJ
	glc5USHZc8YI8blSJ8MU4/JvfD1TAAzNtCjfmbc5QYdDHvDcZvxJsfw/25nlDmfOkg==
X-Gm-Gg: AeBDietRzH3MyECsjdS7vV/5Cnv9kAEv0woiNasFuapGNrsNaC4FVxb/OtpbEXFyQWY
	FWE7dPf0yt9IrTQOQw7Kpuf1KBuSCZNHgE0xze0BLL+kT7jomhjSMZkM/ybTO0G2tlV5/Y87LoL
	Hga/MFJ9x55bE96dNkZRXqFvSSDA4Gfpdyww/f98CQEXC0WWRGtCmy+3C7W2CaY34tfKqNL1MUz
	tpOGU+pJvH0/AXm/cxEFsIVZllDpUzZhinQcgUrRCc3HM3UVUZAgd8L0Xu0sDBWVYjE73G0rLN+
	VuFIl8clmtyPvs1NG8KwWtGFbvT8s7xRFmhyQf8VeAQ56uXOyAp90/kppBvp/7BtsRDpE0e6YuX
	o39iAJ/LNITGjgf+aI59biq5ZGiQPUbS/Sb3hLgwUuqNF+IInlHkzTeoIJxeP6BBPZgleHvahS3
	B21i9pZKDbSclWKOGm7Hiqe2xv1pNbPQeJIfyK7m55zq8JE8VypRZ45rQqYmBQmF+2pWRPhGJEe
	RVxImjNdCZP7eyUBICZ/lg0Hus0wWTHxyga4q+/ddFYhWhlgvDPmg==
X-Received: by 2002:a17:903:17c8:b0:2b0:aee4:afe7 with SMTP id d9443c01a7336-2b282f4b9a3mr2742915ad.10.1775239364607;
        Fri, 03 Apr 2026 11:02:44 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:d969:9b73:e652:78a6] ([2a00:79e0:2eb0:8:d969:9b73:e652:78a6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe5e5127sm14700329a91.1.2026.04.03.11.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 11:02:44 -0700 (PDT)
Date: Fri, 3 Apr 2026 11:02:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Hao Li <hao.li@linux.dev>
cc: vbabka@kernel.org, harry.yoo@oracle.com, akpm@linux-foundation.org, 
    cl@gentwo.org, roman.gushchin@linux.dev, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle
 remote frees
In-Reply-To: <20260403073958.8722-1-hao.li@linux.dev>
Message-ID: <000a617e-4478-797c-50ba-587155139e1b@google.com>
References: <20260403073958.8722-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31C1BC0005
X-Stat-Signature: 48zct5kbqatisury4wmi7yscozrg39uh
X-HE-Tag: 1775239366-785210
X-HE-Meta: U2FsdGVkX1+Fk7GxcBH9B/jQa+2hdpvEDTtUPRIPDDVtVzHeKdubLBB2tsCg+FTtdGuD/dKxQgEcvJBw5obHSKKEbt2aEvv0xqznXw9FZz5zW8qasUXBfLQYJeUb/LIE+K/j/aFg8vycscwArpPZb89s51Xyog2pNG2GlPL6/0Nikm0JYEbtEr6uyGh1cuz8ATNsFf1RS7gvpCear+J4LAxbzvqobYWYubUbbljxIw06p3B7xWLKRyCPGXLdEiG0V0XrKAS7iB+G+ZlFtKk0GccbcihCzVpbUrSipONdNCGYqHVaBgvLNZoU+3kX3iMr97HrS20biEN4BRMQUMqpUTJt4UfH8g0aCcsKXA2oVn5NQazW9ysaip5vDK5B26rj4dGfve1Whv2tazZQCfBM8qiCj5SLsbzDrI2XWk6OcAOl6r0UUqlLMNfi1Ia0EcnbF8DJ/QKSvBySaZWN4WynhKMXRtQCSpD7fRfzApA6UMseXiN0nqv7k4ylQc5iqedeyHRE1KUmNqJ0UjZfiEe4Dz3ANFu/1TQ8GGb0GckkfFtxRFr+GjVMgyZxmaJZ5TIXk74JouLjyTx3QLF7/FGxN8fFUGY4bcG27SLyghhgT4c1s29xeUTj3LSzTwXE91hZhKiJmG8EuHi8dHn3MtC9K9pde6ojCx/fKvgacN4wQWinhbji+bgAIlgpBO0zh09wO3UahOpnkUud+fLupyrgExa99wTvC0U5xvE2f4HaxugY5NdeeRodIt0ah2boOh3mgGQS16pSx/apKJ5SLlvP4p0MaLqity5+K22lI40OObCvCCep04OxfsGuMlKKKljnactCfxnHh1029TQJJm2uAHHVmylI+P17cMrLnQJ1C9Og32wZcqXVf0QT7UlYhzpBrZ7XSDLYtANCgX6zm02ryb9BoUsZGMPfiN2LgnnD/ebCp7AQIqam8BwL6yiqL0Vi2XuPGjVCNPg5lWm54CD
 Tkt7Lo69
 Di3pAeLKQrx9B+IjYzDc0y6LixLBKckFnBoLEqP7qTZvPKSpaia/d4mX67XoxE2+0eZY7FtbUwFSho6T7cHc+c2WOxUr5Qs3zTWoFBCBDVbuggmTdM1/W2GIG88D8o5hOvxp1QEaDI/b0nwCHu/e8QZV6z6T92B0w2/TdKf0lyaaRpbw+JUYtxhZz/Y0a9UpAANH1Yc03tEkHmUKHaojhF2+/O7AeFIzbkDPbttkFTvS5JJgGBlVDDawXmMSiuz0YZhoPsEUBE/XnHfMF7YxXfefAMQ5Br9TC0YGGAmeEsSFGp3FsIYXJ2RdOqIXtHRZk2cfg68oK8Wd8lFguc+I4vO0yG3LluiyVsP8q48MgdwqxWeIivYR5jFcmKyHXi8imhz1d3FHKoG3cNgpu5rXyixgvNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Apr 2026, Hao Li wrote:

> Memory hotplug now keeps N_NORMAL_MEMORY up to date correctly, so make
> can_free_to_pcs() use it.
> 
> As a result, when freeing objects on memoryless nodes, or on nodes that
> have memory but only in ZONE_MOVABLE, the objects can be freed to the
> sheaf instead of going through the slow path.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>

Acked-by: David Rientjes <rientjes@google.com>

