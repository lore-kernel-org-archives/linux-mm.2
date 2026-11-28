Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058A1606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oZFE11Dc
Received: by kanga.kvack.org (Postfix)
	id B87AE6B05B0; Sat, 28 Nov 2026 02:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37E56B05B1; Sat, 28 Nov 2026 02:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A269D6B05B2; Sat, 28 Nov 2026 02:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 801D96B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:57:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D31F1605DC
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:57:23 +0000 (UTC)
X-FDA: 85483772766.06.81F819D
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id D39D3A0005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:57:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oZFE11Dc;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795852641;
	b=5F/ePcUgnaQtuVemRMfjikeXZeUWlzgnc6XJQmIXyyQgsoOD+UAK4zEtgvV1Azk2lN4u8Z
	NASrH97n9BXlqGubcc7zKELLZeg8pnaTgUBlQ4WerqiUpJfKLWjcb4CuJTgURFB1H1TxmD
	5+xMyA/qvyWLELR4vkJt1bEQeqTHhEU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795852641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YRc+oLAH9CSMjzqL5DaXtGZiCmjzwmhJmG8W8jBwCo=;
	b=GCbYj22e7a5Qo9BA022WlMRooxTJXxoNKq0qN5/YMc8oW2do7wuNFVhype/eWy40igKVlb
	Ui+4WLeGkB9jNACJnIE5lKHvnAu9LzTTeCjtB4iKDnmou6wyWVxP70yB73wCJb1zNmaYnr
	fCEvWMvKhb257r2+MaSI25x7IgAvO8s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oZFE11Dc;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3866a784546so12254747eec.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795852641; x=1796457441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3YRc+oLAH9CSMjzqL5DaXtGZiCmjzwmhJmG8W8jBwCo=;
        b=oZFE11DcpJ2Dn61wIbZF9Sd8H0UI10TnP29e0510ya6B3X5JF5wg5WwFZ8yhuf6Zlm
         l1oiuByu1tZD7qUXa5DqLbsMQfqpJF9Rw6YDSmlJ1qu9jYaGKuFRS6CznSxZBwOwG0H9
         Qa3QsTB9/suMf3Hb8zDZKT5eAStgInSxZIqoSOvGLowQT03t/dqBr3s7p3336gI6XLL0
         o3HEcEccmha1zv5mfGCQLBI4q0XVx3OFmQ8ncK7Z5+c7q+Hzcp73o1Af8Pu2JIPBfl0N
         FD4jAyvZlpIzTnunmrI/SmqJTfkTO0Dhiwie/PcLI+ACcytLjK/GLphAw380YdvQnuHp
         7cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795852641; x=1796457441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3YRc+oLAH9CSMjzqL5DaXtGZiCmjzwmhJmG8W8jBwCo=;
        b=j6thkQk5joLjM5J9YOB9B37lSzWz07FVTgVO1ctjTY7i00wtKO9UlEBhoXWOvFxzqL
         e668i2j5JlypZqxC/FodIrAx7NZIFzbI3TzM8RYvJ2rRPwAhLSHdsq1edFq5BV/CbtmD
         MHzY9MEtgC7klhk2mhE/K3gBb1XjETTGkpdLDsd+GDvMsCxOD/AvEjMEglmRN9rsVSh7
         tiXOiHL5GoFe3aS7RHvlCllry2XmiW0PqgfSf6gxfjmgNT7kCgajczgwviPgI60KCE1Q
         1TQR3PBP+RQ4+6P71ygZSrO9x+vhnlBKWEPtk95D62gYjbicDnhtMADD4HlwRzc33XZB
         zLxw==
X-Gm-Message-State: APuU4Z//+MNnDsIIpa9dDrRpaJHQj6wViMqaTuhYQa1q4iEgqDI31A6+
	sjwzEK33CRVCuwhN93Rv6ITiiFEmkk0MhcozcfwEICk8qCqrienj/Wwv
X-Gm-Gg: AZFdTZcBVuLg2f72R7vshhykuZENczKKKDxQ8b8As0F3vdfotgE1s4M+5mo0X6iyiBZ
	sqMhbW+r0KXBybXPzO1Kw1v6HDn8a0rfGyzhRTluQ9qlgC+B6uY2VSgDhIVsUSYD+61RoFpuXKx
	ixcs4laMEQgxII+aiiSMAj4Vvy8WBN8HXFCP/0IBAUk4Jvv9P45mJCHgKRux7rtjLU0VjuYcr/A
	gtb+l4PGkjyLSgbdaydbTOIfK2sO6wN9BpeM7mAh2bzJxskUr4x93ZKIGzsBsbyJAbcEokZVLcQ
	iyjpaUIuOHjejm2uaP1mgAm5eTHhsVkbbigT9NmOf9RhRfHyppNdpmm/KGDHJ+xGXP5dYfIGNOY
	Omy25yA3NPEMfk76QG7L/vRXYRnikzrg9rFMpV52agQW15HWczvrLsTbpYVE7Q6vxTuZ+pvclK7
	+Lz7Ol3CQUiyBbCYX+MSxUC7HBZcz6pGAbyKHQcaOKDqNYfv1cjYetri0BHpI2PWZfKNJVJsaPb
	J64c/riy/SaBJyMYkDhLFVDgAW2ZrEnY+ypuUaBX2S6viMxCWnB42UXRsqdKpJ84NQhQ7+kE15W
	sOdp9EJ0BrOmq7/8RXTZgS8G3dHeZtuNMnvo4WvcMNytq9ZF6LNyBvQ1UGiC6vJvenNMJr4Y49+
	C6dr2rC6yQfrtTJY=
X-Received: by 2002:a05:7300:1486:b0:383:6eb6:5730 with SMTP id 5a478bee46e88-38570e24c0fmr32195217eec.32.1795852640554;
        Fri, 27 Nov 2026 23:57:20 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3866f299d0bsm69117082eec.19.2026.11.27.23.57.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 27 Nov 2026 23:57:20 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 07/19] mm/swap: consolidate swap inuse accounting helpers
Date: Sat, 28 Nov 2026 15:56:52 +0800
Message-ID: <20261128075703.36392-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbXsmTWf6GNXi6W7HabdskuGRO8gfUtVgzmr03+oi20itQ@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <21e7cb1a16aed56568fa400f5385acd36513aa46.1795439990.git.lianux.mm@gmail.com> <CACePvbXsmTWf6GNXi6W7HabdskuGRO8gfUtVgzmr03+oi20itQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D39D3A0005
X-Rspam-User:
X-Stat-Signature: 7com8ksksdkokx37ca5puogtb93k4gtk
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795852641-832588
X-HE-Meta: U2FsdGVkX19SG94fBVH/8PItt5wNpLJ96Qh+zHdvRE4AG3Ti+QatyGzE3yF65OXVA+VW2cAAE+nHbu9Lb2GyUCHCNiVbFEPOW1MHIwe2bPX+tFbFgjLhV8KkSiDuVfmFULoqK6tDus95msqOx/GIo5WcA4AK+5H9YDqhbc62NgaT3hWgcT4OU7JlmsSbaiee2+dG4EJG6LYawVTZjPrXQ0nbN+Ov4woAHdhWP+7dI5yKQLw8W9mhHOzL1oTESMBgIb9H5tXxyW+ZP6jyDLg7tJbYxXZQj5+AbqisvS/Kl+mXIfJ2Inxpo4aSoLKVEZkV2efqwXiSBoZlMc/8CApe7yQ8qT3lvSqNbwF7gmt649vogL6xbFL4AzTstHKgyF79PotGVkGyLFXP01Uiu8XYk8U17d/J3fYnag8PiGqOrvMqNsQ6pSXPXNXXTM7V2/TKHBtDX7JFrnsv7u1ykH3kqpf3K+YGMDDS/uaAMP06BF5YQ/swox2IZCjIoDE+pld60HJZ2ikrVaQQ77I0om4zuXQ3GQQk4HKHhmQgtmk9AIMi7W3LDzOteHP9kngvhulVgPu96VY3CMObxJ+XUPTRC+Mx+m6qMocm9i9U1C1myINEojZyBdAwFLtLHYno1zbjQvSGboVRLWsKd3X2mEDyJuFpaTdPQ0IHJGmnGBEEeY+HA2DvoQD+VMTnDUjolnilcxT9ZvhE0j9/KuK3LtaDgaxU2TM8smViCyhuvJZszo3hmp7u4oMrz77QHbL1PwJyDC5y+xKkWLFD40CEDtQx5U0aOa0/w/KvxDBenqOqSquAoxuoDnXMwQuwhfc3t87SFlasbl0Kdhv0Yg6j+NXoePHAgF4Nv0stb6HFgwcdtECjcmidCScY/+EAYN6wHB+5qoKwcfNLj8s7mtKNQN1HdEgoTsKP337ObTmk+qmoT3dML0SaIVhwLG3KidrMjuiAFM8GXKTjtY6pgbwjume
 DHwaP6S8
 fXxDbgMBYJ/UdjtCOc+ks5jPBiHBs6Po+0Z+UKknOxM5wrMAfxNQtNkJxorktWiy19bimQAm1JeuxquWzIOk94bXW5h8emTiWAC6qPVxTPkOycxe51U2C4rV818sVLizUpKIcI8iKKFgD9wXX7eKbnVBQtqdAdJnI+JhV78P+PVXYDw6DMJhIYVa1HpzQ80MpQE7lHsxJGvq+0BtN8QxMsauQ2mdQ+zktpmmKHgcMm6fie/stoG2amZ5TmQ/Hsfn3OK2Lu7mVcfWx+VlCxMq0aG1WgSGc7Q3HSkDHxRzgTZP0UFMfW01LeGawqvYjzEst1P9CshjQh51AcU2AQRC0pisBzv7ZAFtupd2FW79MwlS0M49QjWcqDHRbAsROqJgJZ6dvOr7LX3gSCMwSukW9DpjlcfMNNZVbqNBVzDkAUfLTN8lODX0lB0y8Pho1AS3HwGiBNVgJZtBdRwugq86n0sVWWiwomoNB2tueKIPjYj688+ynFYY6Tt+lY0kpy1oK6VUTEa0jwkR108cTNgxDjAs57IG58HJtCJVzNg+njjbk+9IXI6WKfQ9Y4tIzWAjxKsWGKguCyw5vEIqFPsHGtXPtZ1qwdodp1aLdjyd+c0rHJqs3gdqDndAGUQ6GaxxfQBFM/eSc0n7R9csq6vh9wpwwUmSMeqSLTGTNjTdWL9bCnVGJ850+ET77+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 10:27:38 -0800 Chris Li <chrisl@kernel.org> wrote:

> Can you confirm this patch has no behavioral change? It is only about
> manual inline and rename functions. If so, add that to the commit
> message. It can help the reviewer.

Thanks for the suggestion, Chris. I'll clarify this in the commit
message for v6 so the patch is easier to review.

Thanks,
Lian

