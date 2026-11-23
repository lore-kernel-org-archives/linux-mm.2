Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BD8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NXwiHHJy
Received: by kanga.kvack.org (Postfix)
	id 240676B05B8; Mon, 23 Nov 2026 12:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218616B05B9; Mon, 23 Nov 2026 12:36:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106FF6B05BA; Mon, 23 Nov 2026 12:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E45FB6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C9D1C09DB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:02 +0000 (UTC)
X-FDA: 85467086964.14.3A5D919
Received: from mail-dy2-f2.google.com (mail-dy2-f2.google.com [74.125.229.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A2EB180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NXwiHHJy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.2 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455360;
	b=ceRPhgnGI67kKy68KW7J145jqPQ92cPLSXyUW/wTQe8KLui/IO4djE2VCc4uFJkrP+1UIY
	SPT1jZG+fUdQPkWbZEoK86OsfM5LULfSPfMLLuXlTqZUfZqbszlunh4WWaEVf6tf15rhty
	jTpJ+rOXhx4HbB5Yh6lleAOZh9mSq8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHHA4/UW1I46SlD7mVUoQdEpZOeV32bGQSJyTeGuf7k=;
	b=EDcJ5ouiNt8/7C3NBCTt/NRo4N2f0wp4c8XYe+Xd/p4mNzydHjEF1+/tA6JnPavTJQX1zW
	56234hhEWTnlSQQUUfJaui15xW/GijC1dAr9KkpjNEc631LrG+7w+MmUJyxyRho9axqY1Z
	ohDXe/7/citrS7+drSSMfQ64pElCk6U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NXwiHHJy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.2 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f2.google.com with SMTP id 5a478bee46e88-327b1d5824fso3106460eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455359; x=1796060159; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PHHA4/UW1I46SlD7mVUoQdEpZOeV32bGQSJyTeGuf7k=;
        b=NXwiHHJyDXdl2CKENkp5UW0oeSmK/4F1CP0v3o1zHaJeUOpf66eM0jxIBBONhNHA6A
         mBXPQWFkRhqZsE9068HYlPBBsUiCcMsIdpuKQEgNVOUdWuuVEFCsVE80c5oolIHdiRpt
         c8y/Rs/PIZ1nAiO4PvDeDbgyWFWFiguUt/ezisTPO/Y5Sdb1EB8yIKLh68533MdnB+H4
         2JHcUoAXnPzhnEWJcxHuONcQUC1xslrv6kr8sC/j84zE9/ZloGJGrO5JwIvEwLox8A8n
         mojBU7gZ/MBeds05C7xso1QupCfXLqasgLQ42zEsXAySORdkwBSDUMnuQQzMThSSfqv5
         fiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455359; x=1796060159;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PHHA4/UW1I46SlD7mVUoQdEpZOeV32bGQSJyTeGuf7k=;
        b=MyLGY29wZFGoxuxMfHY3YbXvn2dmtkMdeDFY7YffQ5VJqEw0Io3WsJyM4pX7VxXex+
         7HqQQqZIBpSeoN+Nm23txdUjg8a9+cf0KmAMadpgNX8bcFNtP7pl7HN9TFIcvzju2LeO
         an4sHnq7PTPnllQWDhFjCKF0QMKqHA+iz0uoXuUIrM0RbO2WM64d5+t5UDZLASU/tXC7
         YqBRrTsOCRn4lPVUWjJAyopy9CHQMx7T9/chb26Tb6KhW1trpzaVCoxka9YovX92uAgu
         qn6rrUesdQesUy5k3WvBcbkcnQ3lF/rzOrJtGWfYhFGeiBmgJcsKxO3N3+SqKJ88OpcS
         F3cQ==
X-Forwarded-Encrypted: i=1; AL+hErGDa9sGsnotjcJpuyYDq1mT0FwS8ow61nua3+eXW6KL4qi/SusDtMMiLMjqL1x/W6lgih3RhFVgNw==@kvack.org
X-Gm-Message-State: APuU4Z8IAVXo2xeARShjsN8zchnkL3BMgY84pXWaodBY2OHwfReQKOJZ
	85ibPfGvh9SKOehuhh+z8LfDyXeuNAYfnunMrAO9HX+vUVljcId1nOov
X-Gm-Gg: AZFdTZcINQ5hMd4nXHAraEiVRKCfdXDvyoql5vxlpjtFr+R9RphgAJB3RB9QJ2UDGL6
	hBAEaM/ZRwvXk2QYBydw/i3tfnKoiCtyRjDeOOgFcAilZ8WdyqD1VRWqG3XeGPgCNMPn32LQdSw
	NaCWSla45nst1pMpD+CauBLbAySPoT1V++IgfiQ5ckhQVfpvSQv0GVTBABS07migy2Negb3pXaJ
	/xEjDITZZwFyNkdldCabmV1EFiKh8HMJ1Ke52DedjCTmIt4/bgRAl9TR4vAvLXOcHeREWItAR/0
	TDvXQPpkaaimC6DipX/En3SCRpnbgW/l7JeHDTfdLCmqyKw/RBEqsWbyXNXp/527huAYtFqms4g
	5IZoBmkRP8Rhk105yhsLDcpn29sfX1hX5HL+aPo2PCc1S3Bd5zHJLM9lMpflUyvxZmijcsfbrLi
	E1u6Rl39RUsXDXfYaJEREdlgfbfr3J7GHJH4c/QRBD2RWBYG8Pp1VyintSQqBE4Hlnq5Xw/swj1
	fSqe+G6PBHBgixK8Bt7IwHE+mkGr/GCAoLsaRssnfWdjtzHhJ7hHnh9lP+ORQ412UW4lBxFVr4G
	1uu+RrC9IHAdr87PiqEorwJityYSdplVGrCxmcmWphmix2hF31WslCUTujZKJjmZSubPy4Yvd8L
	CxHUibVvAnHmQv302hRGGNHsAjLp2XEK4cddFqP5DquyW0EoiVVI4PjofsQJxBQ==
X-Received: by 2002:a05:693c:20ce:20b0:37a:a9db:6bd2 with SMTP id 5a478bee46e88-3856e63b064mr13581504eec.11.1795455358808;
        Mon, 23 Nov 2026 09:35:58 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:35:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/27] mm/damon/sysfs: add producers/nr_producers file
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256507.4.17207740152936961062.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-7-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-7-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 2A2EB180003
X-Stat-Signature: j1rwtmn15bn7mttz8bcmsmpkgt1p4o6p
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795455360-793944
X-HE-Meta: U2FsdGVkX1+Vq6X4wiJk1jP6f5Lmb/nLxq0oDujpg130wtmRGftB6gDp4kpnD//1HcyrFyIra+AxYG6ip0/ONSsU2FWmST98imAKCVDxjIM/26bGrxxowOdILZ4wVjGvc21Tdlh1BIpxHeY8D0Xd9/SjHf04dyduQM/KaE7rChnpui4dzmrIIvwkXWkxEzCWRutUUqUjhy0MaSHzaJRSBkk/HOF6rqc6+0LCfv1yOiEBwzlXLnSDeW1okgvX1t7a7cXE5T5A80po6fAvfi3twzPjeh0BGQE4Aa5/Me3KJr9XdQAJ7BKAvMn4OrP5kimcSRjlKONtnRmON7Df5Zfk2N08PXHQ/VCrEdX6oFUYSBx89op1gs7c5Jmi6nT/YMu0ECZKwR9A7sH4YqO/cvtlkV1wfCqfnGeP6M0fcXs29fnRXXOMkT67hPQLtSZ3tlTTOX2w2OVDWxRpUTFXnSiSS8hZtkfeS2MksQP8ln0cCW0k1Ou1zlsQPswygfq9rGDcfz+jYLinAkmS7Mfr4NYYtUlzP53ZtO+SxOGDK4vZVsfoc+a8vJqWM/ceLVq/l2GbDnR5FMrG7iniBdMGHUORlqGihByToOWwZZU8DYmBP475f8wDsTqfccyQZmnRb0u4IRFSY8LbUOGLQWmlR5Q3go49vxWEemUgn0CNzb47iSfYEOJoUJ2b8NevwnbDayu9WdL9tuS3tqh6cSZMS1Y5wA8VHhcV7/pe0NHlXbyzJj7Iokp7Dk23MyRX7AoPzdPdK2mXj22LQHyLJA1jZEUWGGAi7Rs2xwcFDjtNDINCHWMxKtfDjMg7NGnxWlB2/Vw6iQ09WoAuxA5rluhUJsEgTTNWorIW/k0JYl+pJ/sd1ncWH0RF599mYn72K3UGgm1jSFMd+dQsr3NCnqnw5BpYVJ/s/qxQJWqMHiMguLrCfjzdV1sqTcJ9I+pxrJbT7oZfvJ2rZVMlGY02lyhbsKP
 IiEOzNY2
 9MVFofrYpapHJUH4dIdWxeoAhHRXUyjj0MS12PgwYT0wI6TtO6tU94iLJGhbP/O/UFLEomRUDXheLMOxoNnAqP/ooCSt1tijfE5N37xS9D1fBWiYTf2jPi2XVQMMRwztVVc1nQe4+6BXu3FLJS7zV91Xuj7+zXRzc/Cj6G2Yi9s48Z07FfFyLS6xJIcy8du9JlWnFRJyQl+1iMryuY3zPJPU93jN/ZXoGaosbfBVvaR9FDhy71moDvcAg4fH9t9CAYY6QPd0rdWRzsKP73I6KZoW7JFei/+rVSq5r+dujCc2IatMpv9ov22YtGx82rwGNNw5S/Ki+Vieuf076XZEHsn15xIgBZ9ccn78B5q7spHslpVoof9f1a1fCfN2sugHsr3TVrSxCtI92ZLmfQCqrA1J+RCeHgPR6HALw2XoqpNXjAs84dwNB1XENQm3d9AR/Zt+5bON31oJu4GsfcG5px2Gf1RqaUKgfJJI4zCjUxUoMGedAkJ5btCNimfAzsJxoyBOW+dzMhb4aqWPvOi0a9PYOXRjL8gQUJEzkIBGkGI/K2ZH0HtrzkIl+VES3kxa+m5Lo+EaQVgXEuZ5eE8CXYhc9jhrTXJapTE7hzurs1pY7MVKk2151CTawEnh1eNivjd4hIKz4vX4ajcC/EVRVDcbzxyOrAjWYsCZbf4S+XxuJGyUjZmKdgOJlAGeapU/SF4GsEaEkKk2Glmb1zOO8jMo56jKYvsP1IgiZAsmn1Wvmq1wqECZWGW2adL6N6/djmE9HJyM7n1bL7J8ZJ4JJs111yaQ5L0byjM+iXv180j9513s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:50 -0800 SJ Park wrote:

> Implement a new sysfs file, nr_producers, under the producers/
> directory.  The file will be used for generating directories for each
> report producer, in a manner that is similar to the nr_kdamonds file.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

