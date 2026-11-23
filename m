Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF47606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n87TUL3H
Received: by kanga.kvack.org (Postfix)
	id 50D8E6B05C7; Mon, 23 Nov 2026 07:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4B86B05C8; Mon, 23 Nov 2026 07:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB376B05C9; Mon, 23 Nov 2026 07:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 243006B05C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:04:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAB2AA08DE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:04:24 +0000 (UTC)
X-FDA: 85466251248.21.CA57347
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id B640720002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:04:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n87TUL3H;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435462;
	b=hTFRpMLxiVfhv12JZtqpPmrQ36sxcj3nV8+vMCZuNUyZJ4KRlxrZ8vfKS4IXhUBVLPL8qS
	kDpl/cXzbfskYt09/ETmu4DNrmcmDdsVfW3r3J9pQmTeNWGE8eM4fOALEBdrMe1kBW5eGO
	YYcKXf+rWMy6EYmCuTkc+sQY2eUtSPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=on4OwLeblNaonT3lNV7MZNGdksvxJ91EU4BXLnkFgWI=;
	b=8nHfR/3s3xX4v0fRYavoRbYlHHWBLHJHhYQ1WUNinHp1hMuVJ2rUWnA2o//dnHjx4RHpYh
	HOzt4Vr5CfxyaOZTnOvLvl94z5CvfiIlhLHd2LORh/IGpwGqR6qxlybqbJF3291VgbqazN
	liCg7UKAjanbe/zaS+VGEZJivdykGjk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n87TUL3H;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36a315ed211so4092664eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435462; x=1796040262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=on4OwLeblNaonT3lNV7MZNGdksvxJ91EU4BXLnkFgWI=;
        b=n87TUL3H0KnH1DQbB4Sic/br0jq6i03IjEEy/x96EbDxNC7oWy9ouDegwMErA4lnyi
         ddqQN0uqBA4u0A6uezDiD6+CW4bxCmHvI+qH1TNr5dyeedOotNlKqsUhaPwQVwOkelBC
         fVgJ59LVJJo2b+8WzsPJKgibBAGPnWw/IMj8AkLabaB/H4UPhGXmgrTgEWzH+IrUElhr
         VqwOKhg4hermnk9HIZffY6gNIK2lipa/NB1X29hGzTD5DkOJe52OrWDrer48guxzMBW/
         656EGnsJt58N0AvkEDZpFZtky0OyeBSKwtaE1mC/cCHz/EeymD/VbvzXC/F/csZuHM7N
         ML+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435462; x=1796040262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=on4OwLeblNaonT3lNV7MZNGdksvxJ91EU4BXLnkFgWI=;
        b=ap9eABR1aWXcWpU6P5CwMKQu4/oq3y9Vzd+HmbXrJUzLlg9V0TsHR7f1S3jmW31TY2
         LGo96qwyCDEKMQnVIWQx/yIEpRVm54lvFKmjmbNVDggRtiDw9QEF1rt6Z/qRm+AUO1jh
         9VlBPmYRHFq5eIAd3c7V6YmJItNcAA0B4fdvNy+c7PVAVo1FE5hrP1MAT82hnJLXcpdc
         SRK8RPenm/7MvPeBrRz3+NhcJDB1PUF1wlmZDCs8iApfbF+o1KvnMpEzWribachoSxcu
         NDED6LX5Ww2P3235bEJ1H6iZ5KXOPB/vTGkl3evqjz++pJH7ZimGufw1earC1Wo6ErdL
         Imwg==
X-Forwarded-Encrypted: i=1; AL+hErHF4JrxpILMLm4kH1ICfWgJQjeHRvVxZ2/tRojTZz6fyaUpJGy/LxENeswVNl/h3xNufzdpOh5WGA==@kvack.org
X-Gm-Message-State: APuU4Z8QZX7z+33x0uu5xIzjW6DFQkKF3x0kGDAAbWoa145UCtOMwuL2
	wfi+23Vanh2rAVcaz68rk/ESxeVXiS3GEJNe5UUIziRYxoVh4KKGA6lufE8BDQ0qikE=
X-Gm-Gg: AZFdTZdCVCgiezTZGMarZ7BD7m/WtqdNc4gzsyJ21eoaACQr4JnCFFBz5tzWg+HbSyx
	D26G+oa1FQUz+7GOtgQiUplHTBbGaIhFcwUP61LmfPkp6jnEWmRaCwEwIqrbjZMrxBoeFgANjto
	YBLngouw31T6sTg5ZlwOvzjfxd02oxL85KFj++ZcH7QnNRy0lqiZM1Y84xEiSjeeByh+xQ8/fV2
	E2s8frBLDmd6py/tKn6YnOVaSOtK7nU7fYx/zKkM7nyLn+dLNtQ9YdxdMt4W5mWPPu0fKKnxRra
	0ce6O777egtRAEvzICGhJjkNhO/lyqvEdhYsqG9id9i3ZKmDARlR2oJWRhgDULyG7D+VMKE2/Ot
	vX0JLLswWjpecxxxnmn5qLP1ZKbf3+aGM6iaL1qqjfKb/gGNSwbzfcXzymlsgnPICW3SGuUJ2sP
	4eBcdMmry0Uisk0ximohZ6cZkoVUJ2HU1X79aglqN/vRVRuLRfAn2M+3tPUNUNpswNxEadVh5W6
	KtbLWw7tdmEV3O7ouAenrN1KbKWIM2YbdZ8E2p7vvnl6GvPWCUbPMhAHzX4xqXjOaFZO3PqJxVZ
	UqIDuWZzhpswxYNqjvrK83o68ekH/Q5kpQTorvvwj02YhiwJDVh/9mDBHHPeADzdcf9l
X-Received: by 2002:a05:7301:2b5:b0:386:b8a7:a195 with SMTP id 5a478bee46e88-386b8a7a885mr850543eec.2.1795435461549;
        Mon, 23 Nov 2026 04:04:21 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm42190014eec.10.2026.11.23.04.04.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:04:21 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 25/27] Docs/mm/damon/design: update for user report support
Date: Mon, 23 Nov 2026 20:04:03 +0800
Message-ID: <20261123120410.9542-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-26-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-26-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: B640720002
X-Stat-Signature: kcejnybbpeerpqwqbr3x1n557qiutt9k
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795435462-527822
X-HE-Meta: U2FsdGVkX18AxwSoekCuYUhB9IZFyF3dP1AUz2FJj2f9und96MSGebngTCxGrQodrl2gsLqnMjbX7cgVTo4EXWYmE/Do7I3W0gNfhGhDXQC/BpONj4rtBb1Nl4XjxTY+fgIA706AWnvdp/STbw2DzONCnco7NAa051G7xjvhg+XB3iNcMQq1WrmsXW+mcpN2E+uMbn43Q5/7FqSP/Nj/kvBeJdelLszjngF3jrHdwqrPLxkKNqo7CtWa6fJlOGPJFS+onfhX21BA6EgjgDMDGksoyDnukVpUayluRREamhVuPp5ePHkTpXDdV+Yq34M+qxbTYi5OFsqplMPx38lwoRlrBiUqBSr+4w/qZoAEGc+2dqtm8X2VAkB3T2oMpA0KbRCa24vUOBaPtxuNIYCK7I/0D9hB6klavP/iCvvDdh6XR4d5YwFoiA4fU9x2oJLhdh2eXN/waJZxrK+KvHUF7Q7qOkYezWevJRNotVMxyt8PMbcBPDGBpiW9JqwTjA/PabNO/JsTrZqjI3ENwzbDAKQ37OtcqN62pRPVaaza1qDkRFaod4WNOc0VqwWTC4VdQdz8f7hCAUazfjfMaHRHNrAUKbe1KmvwBmZX2Uxq0LZSOv04FfCCpmUMI6R8STw6Qovo+7OT124uUCE79Vd1dxPtsxdyVPO6KxnNPDCwaYU1Ma7JnoMO5Ph4ppKz+QmENopNKiYr0oTTXR1KWh7WVAkoYYLVR1RV8aGDOsWA0EGaIqbGQURwAF0GEjfw43aSUYkrJxfIDsAgo+nsFHs6zoUAFsjkpd51cNq/w0zTB8LBiLeK5usRK+iwxASmpwGEFZwwitunP/UWmQWXMiQYS8ybXZFaooURTgSYUHHoyjg5eZjogkSB7fVd+PeVm6r+2CTfSBg30bMbW7HoJ6GoGVYl8txina1AJnbUjJh/53nrGD07xTG++SJbJcbXgUQUMxt5JyziObs9ydT3s6q
 ogwVJuEO
 Y6XJehQUVhLnZpV78nJJWpUXUf1mxCwm5/o6Kw64HmHzyJabG0pfE9J8cCPfJsTC/lpM+fT8LMiyIEC9sbRwA2k+rfC+BRsR/Svm2jaxEXWNWc1bMNj9/X7cwJVPcdLdnDYEzjFZmd3Ze5wFyp8/RZhWREjgL/6nUh2ZD2jWZvxdrL/4FYxxze4WCmQrNcIZqKM5Q+2pnpxTbT0gymr1pDihRKQnr4XLu19MY/n+j+szPWH5BgOMjaTLyF7LANrbi6ueMedzooLBKBK7+YuKZo6oXzX9JbVVEccGBL4gtIOrL6HYwAtEwB++OOTasYWGC+CBdYhGP35nwMU+i2335ZrwJAvZnIqnDfwj0kYrxcaRZw87YSB59xUgOeOgh6MNpRiYBhTTGJ6Fbc+b2rXawAkg2GEupkzEuIvvuaPEIuPkDLICvVVuA+kB5y7u0UjcG9OrXcMfavrWcDIjvbxqos2xpZ87PvI/QWPAsOrRgIf1NfR7dljpbMAxFX7AdiY3ibyhhi7gbP2ecz0Dbzk9UPi9u/uzjYHSa9FHJzVM83Ri9HIm1qB34L0/5UzlhG9HMrpEu07vbto7GMNbTEknK6d0GQbuQz/mtY1GkPzkY/fyffxgyRkK3z+s1BzBspZSHuXxVyrlq3K8DOS6CxrFbLkitIq29PvuzioQA5kPk234AwHYoU2RU9GNsmQM1PHg2Z6BrsCGREpZhpdBjF04gh6E8ufpSMnlwzNMY0uRK0rlRrpr3wFZLk41DwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:09 -0800 SJ Park <sj@kernel.org> wrote:

> Update DAMON design document for the newly aded user_report type data
> attribute reports.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

