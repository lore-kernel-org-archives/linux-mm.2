Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D4E606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xsYfOmBO
Received: by kanga.kvack.org (Postfix)
	id A35E66B00EF; Sat, 21 Nov 2026 10:27:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7276B05B0; Sat, 21 Nov 2026 10:27:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC226B05B1; Sat, 21 Nov 2026 10:27:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7256B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 10:27:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2189A80F8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:27:14 +0000 (UTC)
X-FDA: 85459504788.09.04D518F
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id C4CDB40005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:27:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xsYfOmBO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of dingf3ng@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795274832;
	b=77Eqqo4muQeHFRK1EUIsccc+aMSnJcflxyRPfqBWblWJ0dOJ1gbzHPq7Na0Xh0gXaXQ5Vv
	+r3xoTsfalcmF1aeE+Bszhl8ROJQeb5ccRVk7zDG7SgECepJVNxEzATjIz9lFFtE0YHlVc
	tWaI3pLI2exrtCm9wTWmVThVq1z2XJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795274832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9cm6g6KW11muvDi7BUi+KAlpExbOMzowH01441DqPU=;
	b=MEfDCvgV5X3IFuuLIKOtnAslquXRUxqrLznO43gEQkr6dJB9VzsLLoNwiEvGTep2D+tj+3
	EN/GZEIIQIEniIPSckFD7gwc31yYdFcHTCi36nMv+Ydrmzx5tllfldNLwu0UdresBpd5SS
	KEHDNS3RVAbgrIopTRg7ug0G7S9i2fQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xsYfOmBO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of dingf3ng@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=dingf3ng@gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-385c497bf94so3794854eec.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795274831; x=1795879631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K9cm6g6KW11muvDi7BUi+KAlpExbOMzowH01441DqPU=;
        b=xsYfOmBOZj7mTGhSv5mW6bzZ5CcBSFsqd2UmO5BDMnCDxnBScy9P/cYuneChSy24q9
         UMv7lAJinxqudRXHqvW46GqQLv4vaQ320S1igJ3rBxgwi4bKrm8Gx2x8qU+6di0OLpJp
         BHL9Z3PjqASdWDPgrJqGWy5vhUVY0RGQkX5sNGWTCc8pvX9Nf0I17Tt3e6nTnTLF0tLn
         H8E7y+6ZBX8qfagvhIXsKzAkHEc/wikKaKI95jDkpdre/O6HVgbMouF8eccX8MI+uAzn
         bPPeLnXZ3s/f80vY8gJsK9AkqLuKTOEzCOIK5DoxoMUKJpMjTkpL0fUtahgpp88R+dCB
         xX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795274831; x=1795879631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K9cm6g6KW11muvDi7BUi+KAlpExbOMzowH01441DqPU=;
        b=bi18F76/bNV1mUWHz1RlIhS5lvjJHmdKZ82WrEUXOBwiOZG6RIygWIqAGwGyDdU5S1
         ckqAf1IxHm0orOQaveDsPtFKC15QC5xBAbhGFiEZAV2vixxKZE5G2GilLLNR9iiSrcP/
         H2RMb1KBoFDZOKsWPoBBljqV9BLFVtSySRM3mJHyLEP5Jyd0S2tR60BKddO7odSOuc4V
         880rb28ClNbh9HZxYx7MZUBodY1J94cG8q8IgyJhKtbea/t1rBn6g5wst4maMg6kd8iJ
         HuOsaRsxo3hgEy4egvRyZRmr0pRero4/7H2pg58D6cF6lyYxpiAKgQdHETTc4/QXaR4X
         qXJw==
X-Forwarded-Encrypted: i=1; AL+hErF8BFwSKqgMdmQiOtkm7BzOquZxyX5IdS7DnimC7As7ZNI69u9O0wGlc4y7JoXYlq+O5VhorxCmPg==@kvack.org
X-Gm-Message-State: APuU4Z8DW+Dz9ME48anLKZTj+uYm4eKQAQE9uLOt5d1o+Av4TTd/4AnW
	LiuKmd8i59qjLdCa8pDcPwHc6riv087Nqa1sjvPVQvHZwMY9V7OaYCMC
X-Gm-Gg: AZFdTZdjqJymX4MYkHv7lyrmiz0RkhK8qEDfQHGAsyM1eSrM5BuDb7WqL4c8tvbseZN
	t2FNa9Jm1ru3e1TjdZhr1IcuyFiBEgsesEithUNiAQfqD5FTsJv+e7+CMzZyfMj0jmq4bGYntPZ
	Fu68QckKGM+pVQZAxEk/GXFs2TSJoXezO4chXY3gSqJI0Xbblp7rN51P+gD7xDiH5HzkjoC0lXv
	zJJPCkl6/LXYdETuwUDUwblESoCTDFxFPwkYAcWbpoQe7dejMDIiJMrJ7Qpk+vJWZqF6K2Buc8u
	kqohI5xGfDcbBAZwxGaRcsT3q86q3Zkj5ndz+Kd/xiRfoy0SpXBuRPdkxCt55svRckg8fMaQ8pK
	fUa/c4iWYL8zaidWXgtV/XxpK9FC0wEbIUHIgnHyQYpmR59Gk1TgKOGiV43rvIZgyDUjTovfNvo
	Uwoh9H9hxW6B2Bh/rfg6SYYVIXLEC8wu/NaM0IumXP+Fl11V2gRk/CBUmXSKEE0U7IsUEaquCZo
	I5wNL3Qs1ItplaBcguZ+InVxYReY0W5tP2kEBhl1Ll5cw8VIeAs73xfLRIsFjZJyVZ26iBxRq4x
	171Ef+TLU3uXBMJWVIsE0TyhlvozhVx1szLiSeXaxUaOwbeAPGdvwIDr
X-Received: by 2002:a05:7300:ce11:b0:381:a037:b060 with SMTP id 5a478bee46e88-3856e63b3dfmr6669489eec.9.1795274831139;
        Sat, 21 Nov 2026 07:27:11 -0800 (PST)
Received: from localhost.localdomain ([27.125.146.195])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567cafec4sm21645140eec.26.2026.11.21.07.27.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 07:27:10 -0800 (PST)
From: Ding Feng <dingf3ng@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] tmpfs: zero post-eof ranges on file extension
Date: Sat, 21 Nov 2026 23:27:06 +0800
Message-ID: <20261121152706.34523-1-dingf3ng@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <7cc5ca1f-fbeb-422f-bc05-55b3f6b6db20@kernel.org>
References: <7cc5ca1f-fbeb-422f-bc05-55b3f6b6db20@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rmgoy9itdzd1td76f53zjgk4jkzg14jh
X-Rspam-User:
X-Rspamd-Queue-Id: C4CDB40005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795274832-802438
X-HE-Meta: U2FsdGVkX19UXUk7/6nBJJoPo4MvLDkYuU06FROw7lmJ8sobUgLr4FSZmyXNhQ3eNj5dXh6J9U+cG5e6PXIabBukb7EZCCrH6nhISyeWF859JnZm80pfPz5uLoZE3yAEUauClvetkydmjV1wE+2VQv368UZ623jwOIOkjJ6uoUqkBUNTp4SnON8iYZoEHUgO7emSPuYXMVT6zd5YnIneOkT+x9wyVc7JA7y9B3N/I8slreRCuUmD9uYGT9BT6UYoQyB78ST4i+luQoXGvH6GnJN/lsmSCAAQFnd27NZuqaZwrbzXf8mNYtLJOrLBdntttR6dAaIDkSKUUnhezf5kEB80scPA/kDluhTHpJY5BHBLWIL3fMB3l11AijMQvK7ecVGxgDWocJ6PYGTaZIK26EPHmqmT1MPddh4gon2NgW3QJrbd7eJNv4nGsGfg+gjvlt5FCMuTTwvUcOb/JhpqnMnyzIutUPFYN9UpSzDG9Yh7suxGzeVBNHM60EA+8tKtJTda6NCGPDdbbQZ1W6b3jR/YB22fHua0AaMBxZuNLH0N7KegyBdA/mJ78vxtUXLW5TjsmaGa9VM1tkbP81o6O2pSLIykYytDPTNeKmdVggPgAuHUNsBpXkxDV5NVs4tgdGNbet/O4MAjkHvK0WSPTmeoha+QMVgtjf2kvtidJBIhjiikIgslDTGj9hLsJcJuGajx1ANiXMsyWBnFpRWHKrgVq8OaVzXiCZtKV5tTfDy915Iw5NjfBas4YJXPq08EwJoIjxQUAzYr9gn2Tcx8mlxn62bILd1KMk/Vnijp9LRshNRQr0D54BX4knCAMWkzKE7e4jRXvZQMEebfAXs50UcM2tIecpIp/t7aUr/wT6SCv4hdyqz4kvxJ6FMnzQ38MFBjoSRhQ/nw/SAhKf1KYyKoCl/yO0AIyO5yaeF3MxVdLry5Z0WYLGkMVx35hApy88EijKjiuK5fDZaIT1e
 DmRpJ5uz
 YY2UCAMqOrksjNrLOAWN6U9QgpKgqUdj8fBcVis4Oq2Eay2qVcSJFzzbO1f9zoHMrAvxjOjKGa/GRdCiLgwAm3eId2ChamZ2jNljiw05hKD8C3snAx2zRf48Z/dkAlQyyDulG0nPKANILQP9fnm2bJX3o1lI20t/xdt3OXQ/wyxMznP/i23K4N7uEPpm8Bm5ilMmjnoRnjX8k/SQ87hvwI/qCT6yUKAKvHRQEdvpkV4dhe0F+JPdohdMPpHagNWJovWohUDkATCfAHj7Wp+VlDPETLioBZQcapZVJojbELcPNa5xYOXltWIIt0sVL2FSRPm0RxcbmEWF2Gyv4YauzRCUpkSM72mG9G7t1TojgnmY/EQByeWL2C+8dMaYAnxiCOYeEHbRWT8GIf1xX7gSZT7RNQPmXATUDbJMcftiG5YbXPkce70BgB0zCTxw/XIvGGjOus11qS3Nl39jZD9RZn8wejZd8dIOi6G/N3U9DaMmjVoakh80TDwegIhZDQFxwpF7X5e1etyxfHMQIwdDC5/sYUPSj9c6muIwyAv7OdsjYsurs8VeLuKhfX6oQNGHPnBsTCqbL5sX4S6TiFM6E88vjUYGN6KD/bQxE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Understood, thanks.

Brian, do you plan to revive this? If not, I can rebase it onto
current mainline and resend it as v4 with your authorship kept. Is
there anything from the v3 review that still needs to be addressed?

Thanks,
Ding Feng

