Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219C1606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 17:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bDXVi+ll
Received: by kanga.kvack.org (Postfix)
	id 01E2A6B00EF; Sat, 31 Oct 2026 13:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37946B05B1; Sat, 31 Oct 2026 13:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DF16B05B2; Sat, 31 Oct 2026 13:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0E836B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:39:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DF99A866D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:39:18 +0000 (UTC)
X-FDA: 85383632796.21.F9AA7D9
Received: from mail-dy2-f4.google.com (mail-dy2-f4.google.com [74.125.229.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D50E1C0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:39:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bDXVi+ll;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.4 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793468356;
	b=Lhfz5Lu79e+Puz7zBpqGHJjLXVTyFXNJQM72kicoR0QKq7wgExAzeXbFanKpCllx5NqSwW
	SwzQ0WnciYoTJL5SNoQ2s+0OaZaGAc/ErwCbVPexEd7KMyGMeimw/Al3Cp/8f2PX9KVq2D
	ZDR9NCXo52FByUi3Z1jm2L15jtftUZ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793468356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RS4/TCOhSiJb1fSn9tcNQ8qqueFM9qglyQ2e/KfPJY=;
	b=LUn0b73HYZp17m2D9NbpoLv8sbhA/42qv9AnKA0r4h9fjbFxdRAIA4zx/a7moWIbM5JdSy
	8hvfk2ztD7Gs2DP9H3JvP1eqYV0HJx+19HyPAlU/VrHauU+aTnIF+taGnVtMXtrG2NJf1z
	0wKC8d8P8NNlA7zp9KzJ6c8kPMfr3cQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bDXVi+ll;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.4 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f4.google.com with SMTP id 5a478bee46e88-35af9712d88so86197eec.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793468355; x=1794073155; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5RS4/TCOhSiJb1fSn9tcNQ8qqueFM9qglyQ2e/KfPJY=;
        b=bDXVi+llX70h+Td0ve3fQp0ehtSFFrFnGAawjD0971BZOmGfiYBS8+ZOnAiIfJyCaE
         fGoxopwHIrgzf/a1RspWZJ8JwhM8VgUxUA6ZfAm3UQRPSIukrAqOyf4OHQDiK90BxmLf
         xucqU68LO6v0Vy7sv0oVUUKDN1uhh0tQkqIW9+CIAXKa5L9LR1n5lXTBay17GvL5xgql
         dZxpCRkLILe7VSXp/cuCcDxwECdL1TD3qem9xb714jvZqzLebQGbHnp2FXN/a7+gNDoZ
         HjsFfXphJl17KOe7C1R7xYAwzz0SLYNhuZNewltwnlzZgMUa55cNUk6TDoSzmE6T940i
         dzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793468355; x=1794073155;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:message-id:date:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5RS4/TCOhSiJb1fSn9tcNQ8qqueFM9qglyQ2e/KfPJY=;
        b=l3kis5i9LAoAIAMVqIIRqaXTq1N8SR14+Fy4QPs8dlv1NwSXs3Z7vRyCRmq0mL6Or4
         mcA+nPGLddbrbSvf08KglTqCKSUA0wqmaMtmE7wrjbspU9HRe4dkv3gHOuRuAe5lvWH5
         FY8QGvAlcHyUMWqTh6vesI9igU7LleXzLiBVogkP7vpztb5pUHXPLsUBloJZbaKcrD4x
         TJfOFwczTzoatD81UYlNWlN47slFRx7NPZmhRKyqNNkMLyCLXHR1/8en0QOoUSAqHFvx
         QnpemProlY2zKeofjuHaFkpq5+Ij+a9ysHlJ3NAVKzRQzWKf6jNu9tpPRg1AGvmiNSIU
         LoAA==
X-Forwarded-Encrypted: i=1; AKwUvBzLxduBgB8TShYVLj/lmReeT0HrJ27EZqSPh1/pt+79R5UuXdpp3eW6ogRJRfKxN/K/bOtcePkPTw==@kvack.org
X-Gm-Message-State: AFq9FYKenSM1BlSq9/saL8kFjOXYJQl/O81DrE4e0ec0w/oMqiausQED
	h15doz2q26J7vMSo3RfoLiLP/MZYZtmVfcUVs1fVPVVQf9/Xoc05nTJk
X-Gm-Gg: AYBFou12dPrxwqyvrH59VIyEp9R07VXJp+dNNJFKGhwnQY4qivtPuLuzZ83EfKd8q6j
	rL6YZvrScl0QYv1vu4AMR3NlIyOX85kfgKGJK7U/JOylNobP3zoTAvhKeUBygpH5dpPtq1LBx5A
	tLG/bfwHf4Tn2rV0JSLaPhBAsgOrro4C8kGkFT0NWVV58O4FJ7p2rO2Fa6BvJigCi0VMHxjoa54
	1k/2bHtbc855TgjC8dkjU7GgWn/4HMxaiTrzhIKIjAnRAtab8vaO6xCtjfRB90aGOEjKGBBl4Xh
	gsR9aLCZW0qJyhr5ppf0XgVx9UaS6fsU/vLFfdNMptqc+AsiFrGz1Bu1rhU5Yz6vXNly/0h+zLK
	ufxCLIfHAjDnAVKj4NFyHtUsKS8qjKh8AuHv196+32hRmSK+xWBpKFEtslhaeydi6LKP5lI6K/P
	t0MUChgz5Kcnr8Z9CD/LpL6EQpT+Epid/IpMwyhyk7LDpEAt4tYdkMomE/iYWvvPvbP/Ke7/ZsX
	rCRRlh4XWvVZZYqPUW+qz5Nb3uOEnvKEJ32ItUa+W3wskLjBw6QRfJwxshzbGizuVW4wWwt3bJn
	xrmQlr0Q6ar71d2JIWD9rtOlUXqnVZ5hcfoR8M1/lHh59K/E4SIPG9GVPdrRhA/JIMxvc/ninLw
	3rmZvnz/ArC8f3fwq7d8lImYxbXYmKw8rWw==
X-Received: by 2002:a05:7022:258f:b0:19e:78fe:9d67 with SMTP id a92af1059eb24-1ac5a680801mr9985603c88.9.1793468354679;
        Sat, 31 Oct 2026 10:39:14 -0700 (PDT)
Received: from [192.168.50.20] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac194b5437sm19811655c88.13.2026.10.31.10.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 10:39:14 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, sashiko-bot@kernel.org, sashiko-reviews@lists.linux.dev,
 Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
Date: Sun, 01 Nov 2026 03:34:41 +1100
Message-ID: <179346448183.4.15545164251841296990@gmail.com>
Subject:
 Re: [RFC PATCH] selftests/damon/sysfs_memcg_path_leak: define ksft_skip
In-Reply-To: <20261031153858.84302-1-sj@kernel.org>
References: <179342136087.2.16978105493403840270@gmail.com>
 <20261031153858.84302-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: cxwatnfpztggft5man4nicxwxk6zyqw4
X-Rspamd-Queue-Id: 6D50E1C0004
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793468356-303448
X-HE-Meta: U2FsdGVkX1/9l0dU+aeGA7WkevkCL95DZbiNFkJwRVRAWgSk/enoh8eSXqB93EtZmsRB8ZdY3UHzhtl1bJQuG2QntdYtTp+hOA48+BFJ83QyOYkaGmj2aE7ksqP++pDT3ssgGOT4To7ceuOoWA2z7Lf1qUVPyFzmQsjaN0HdfIQ9VsMlbadnzIMQxBlCjvMNqEav+5BYmob3mJUUPUdEuJAPcr/S7cQJjVze2TwggvVdo1fWxQ1u+E5LPsIhlPdvtb4eXupnEaY12+M+/pOJsp/P7Z9vX6AH+Xn/8qhLPNUqWhq47b8lBi+17kUVapp9BpyveJeNMq7iylq34peEwTUMIj4ws5GYfauur98r/5Ds4uUX2NgMn4ISCo/lOJ9bGMfI16FXJ7cxej2XyJa8ARrEe9xbn4SVJHzyGQUyeQ3nqeDbhtXyVSctbp6N6wEjUjftdTq3j1xY2GFzdEl2jOagpPck4bvy29t0QOu4bxi3hiZ5jhKursNdKY1ZDqBBi+9xD/AWXssthBCRhtepAWP6jtG11CsHQOJNgmCX0pYqfY2ey8yTDhsW/OPA4jPmrT69Cme5wVEBacv5/ZHUdZV+pCTtJPG6b3CaTuCQ99kzOszTqS1nyzhm6PECERE+mUHZV6rmkpmBFZbD6V/PJqlV490d3e22iO8bVySuE5vsNfDQ03v66vjuVenJRsTGrBzptu3IRNEWSC004fdLuOcGKJqxWur9UVV7QpsEF/T6cvdWN1XZ0+NzmmtIOksj80V2A2gGIOWNVU0dpqodHmFIuXoKc2/Zx3rQZ5gsUp3QW9AY7jxbAPj8W+yH9OHolW3ufKrV+TRwvJ7lGiS8av5iZ91I0WCPvGLKKdcvnfvNGsdSfQ3nTODWYTy8FT3IGtTX2IHXe8mms1uPvdVIlYfpAD0JRYiHWvwF15QCZftzu22DIm/KJuk9o9uRTXkn6Wugb18fLTnTrPf2MUt
 MiIQHQmv
 m/nl/7nBjB40lZgLjlZadqSnWexeSMSCRTICIT0dJnB79leZNuPlXABna3zbBhl1ORXRLGNgw6wRqs8OVSwJ8fUMEz+iMCQ/VqHvVVUmcmnCaR9A6KoFl5fseaAzKGcVEE7pvt7XeEG7ZL8w89xJqMYXeH31IOGwys7mLh4ALPjlCTDOoiquwj5TMNUS2UtZMoRFIKs7i0VWHnPkL8v1Z/ucnDhmCicZhS5VFCI2qUN0Tufaq/aD8YUSE4jWu9tGUDx1m864V9Eh7El3AXdHIeko4rBbM4ZqrbGLr4k9PGd8gnwoaPajsK1DoiBHUbl+WVxca3WivBZg6yuUVZav1UKop31+cETHLZ8D3KUpV9ehME8S+ed7UCSfS338EYeS74M0SJGofp3ZLsbirRnrakEvE2PuYDLTeGxCMaaYgIJxh4uUpjsseAbLbhdNTVmEcpHKwUTRx50l8OAX1A1C+8dP1M1no4kPstEFLjIzOIrchJ//BxIY3O5x3mrTFqc8t+S4WyiGNFYd2V54cG2PqAknCtEYZnkKpQNTJ50WFnqr+dAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 31 Oct 2026 08:38:58 -0700 SJ Park wrote:

> Thank you for reviewing, Aveline.

Oh, looks like I forgot that. Thanks for the reminder.

That also gives me an idea: maybe I could build a modular tool to help
write emails. Building on b4 might be a good starting point.

Tested the non-root skip path on x86-64 Linux with Bash 5.3.20:
the exit status changed from 0 to 4.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

