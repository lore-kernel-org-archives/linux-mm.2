Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8412B606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oPQBx6sc
Received: by kanga.kvack.org (Postfix)
	id 966796B05D7; Tue, 27 Oct 2026 03:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916E86B05E2; Tue, 27 Oct 2026 03:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805DD6B05E3; Tue, 27 Oct 2026 03:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF1E6B05D7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:04:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E762A12092F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:04:47 +0000 (UTC)
X-FDA: 85367518614.04.F5E949C
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23187C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:04:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oPQBx6sc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793084686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Fl5cl1odyHR+Q+dHl3S9B8sfH7/8NbuHWc+9QJ6hEU=;
	b=xQOGG037WX5Fh6ogEVgp7BEfL+rYH4AJSqaGyuJ0pIDxxH3LKvGNq2xecBUd908k3iezRQ
	dPVz4vjTf0Syyb/eUUYVNbkjpDUTm+3LXO8eW0sOkfUFKmx8ovWEctdaOk9ThB9dH4R/Bu
	QU9J9tqkrOeym4nRax15R5Tni+7t07o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oPQBx6sc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793084686;
	b=Ul1BjggrlD0hbsqw7Rh2QXduhaUC+VcTj1C8zAusA0ydLj+62fTl46d5bl7hkHk8/P+JH3
	j/fT4XRjbiNDMFQah8gX6tV+sVWk9t/NIpvB5+Asy3nKykrQtWeHxQO5sG/wx3m/neYGdQ
	gmWINWhsw9twik8/k5VKy0XQ6spKGMM=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2e7e742a2c7so4832655ad.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793084685; x=1793689485; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Fl5cl1odyHR+Q+dHl3S9B8sfH7/8NbuHWc+9QJ6hEU=;
        b=oPQBx6scWOD5ZV/7p46/gNRZ42/tlJNtsrt5cOAT/jqlK4hv6j8xVwAJLquwDiF8eM
         l4+rrhrURLTd2/9YGDXypjvLcMGmGBR74RT/TS8tfzqR+1lO0cRysijq6H7euq/v3eK7
         dq2KhOSaHKbW/42J3htaaQ+4erklEwu5od1vUEVVvHukw+rPpyepds4B8ATEoKy11AUB
         LgnKWRIsu+wEir+wL6xPr+6U8upp2q5SvgZlcUNLEzcuyl7Dxd6gtS8cRptQUMHBDglf
         Ho06kf51CzaEHgKVySh0y22TYiZOY75WCBpMf1d1JvHF/ZWSertHLvtmEy3o0rPcgGcr
         AV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793084685; x=1793689485;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Fl5cl1odyHR+Q+dHl3S9B8sfH7/8NbuHWc+9QJ6hEU=;
        b=ShfQkgzFZHVYIIgygRAHSgqdFVXaQboQBHzL/a44RXQAePk0qFFHAkLD0+XWfbv/bM
         nsG7oNZSuiih313bQssAOftvnpVA4yd9JZe3lOQ5Av3qgKl/hikZ1Sw0Ed1G8TLYIkYa
         j9NPVRPd8Yh66xE5hlwemQalzIeFQSuUU0Qy98lNEFk7g/NV44N9FsoemVMI+0LGZ86Q
         gVKlNd6jDg9Jgdx6K5qXZ4YFRBkOp/6/AWbkk6kGLmlYOxB5WArleZHuLWUUQSmHN+uT
         kAGOQO5KlZVXgrZzmpVUALuGMPPglYegvPvyeGccUwRUc0cUNyACf+UXns8WkyQMlDvo
         /nRQ==
X-Forwarded-Encrypted: i=1; AKwUvByuXGEMZ6Rl49Ltm8e8n/fiiV7JgorFtDRmnzz0LwDQab1YOxoFZKjT1RoCcjUXupExfE1Te/BVSw==@kvack.org
X-Gm-Message-State: AFq9FYKdeqG3ZriU+ON0i4baUKyU7me4Oyc64PJ1RD/weOPVfBQ+z9Mu
	P1xMhPBjC/ByY9gF1oE1FCD2GkvYjGI7oL6LzdFZmOdxiJPWKNNUmCpy
X-Gm-Gg: AYBFou2B07W9xZ2tbHuBIvsyflgeRO6KPk1toI2tg0p9MpiKXADj2oONJUV86smkh3k
	cBh2u3Iut0c6WTXjRcpmp66BUtS0mHGECuBRaoEbyPT3mg2R+Yg8rKb+u+QDX5B00k67mM1v0gP
	pvrJ2KImxrTINoj50m49KUwmtUBMoKt+tcdiqCmCxxPSlinbZsse3L6XjvzL1MLKHmafcNS+iI5
	UaJjvmd2Sh7CbHcVVaN8yewjZ12myFFzZJ8rua2zixX6KjO/2OXTCMKWG2hMXIBxydyeJL36akB
	7wuAa5CU7BriI5Uf1vbx/xvBsrCztWAi2fcRxi7jCBBRHO1Qg4ct4qZGO0Cr3zVkoYbUdkwDmZY
	/YmEpVm+qhv9//ecUDZuzlr8kgnQIKEWrz3d8DH/O+hVQxi44MYo9Hn2AdTlW1YMABPuhO7q0EJ
	cORJlizq4KWAF6eNviw9De+olTl8FxtUlbTfOL1ytw6GmV81Vgoa0TXxxxHuMe1IjRLFkN7ftpQ
	woIItOifvU2yZc1CE13OOQBkUm82k4ogPkxT/uMxJzfMZabqmC+9mFNPYyllmILDi0hLqBoDBuP
	qP0Pv/nrajADLNwyQViGEOOVkFmSp3xGDYe2B4JGRRN9e9N6on6V
X-Received: by 2002:a17:902:f541:b0:2df:34c0:72fe with SMTP id d9443c01a7336-2eae402cc5emr11077445ad.35.1793084684710;
        Tue, 27 Oct 2026 00:04:44 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b7a69csm4484635ad.13.2026.10.27.00.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:04:44 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: Daemyung Kang <charsyam@gmail.com>
Cc: sj@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org,
 akpm@linux-foundation.org, bijantabatab@micron.com, ravis.opensrc@micron.com,
 sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
Date: Tue, 27 Oct 2026 17:45:52 +1100
Message-ID: <179308355214.2.6632342460755510671.damon-migrate-weights-review-draft@gmail.com>
In-Reply-To: <20261027035431.1007584-1-charsyam@gmail.com>
References: <20261027035431.1007584-1-charsyam@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 23187C0005
X-Rspam-User: 
X-Stat-Signature: fp4oeimfy5a7bbiccou7jhq8f44q7eob
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793084685-358551
X-HE-Meta: U2FsdGVkX19xRSzJszqfxxlRWj4bL36cE9dz3avP+j6G5qIwHWi1jUYOpzNN0g7kB8w9zjoNExBlecxbjUXaUMdK65DJGyyOIRj63uLQhNKJ2xoAaFT1Cmo2dstHQM9/qxzXN53fpfG2RsiJGkChEceDeMBwPxt9f/sutUAG9rxuVozsYpfOwKBQwl+lL3aad/VRzKhsDgn5s6f0H+5IzEYxszKXnNaFnH43eMKl3e5hwultvCyiDe3EA10Y6BGhZUzUpktOYu4VQkhPjNAHQklnAvQHwwhpxDsk/lOqj3IIAX1eWy5N3OZq4afRaoCJpV1Kl5LlNxAORsbFmPidOSIQJw0T/tEW84uYCWsREnELJNXZ7H6s5uGCFjyx6VqoWNFkl6NrsAsgpjqmKpQcBTa1LxmJZsbhbTMJgblNi0D30eeJZu0ftg1YB4/zJucLuOLb2LaGHqI542FFHx5SFw/t0on6treHlBLsiaAW6y31JTwf0CJdIKHOa4veiE17m4I+h5MT/tDSZDCu5O/yPvUth7l9vvzHb86I4v3GGXHEidjn8MbVjkRLtjFoi0Plnwi9IK5z587VgiVQ22fAjsa4KG+K6YVKGI6GPHctCFzkGwh+Ci5qc6nZC2aG4pDqlyxza/P/BI26K4KXa+FVO5wQS7ST6n1jqRqgFDZ4TZlmNAMmF0zV+SunNn2o8QyK73Gzn7aNVV1J3ArQ33jfbqAVqXDCn2NksQAYitMAnqB6Xas0P1N+voWIp05hjegelL6jgX3htK0voLcMDI//W61lMt5Ous8ip5MUkN0DEFx4lQGLO6m7l3k0qHNUpCB3J0LScP2D+6wEiYe0ORyScL1/DO0MQM2H4iqS7LT0+eLewCwWhGIJDwpZKKBkBHol2lJwvRRX2CirDWKMPQB7gt99JVUAJdjA2ojlzfRQAeS9Sv2j3dFe2U7Ehr+W9l9Q37I2CKntZwANaqBG7gg
 F6haSFS1
 z2q/UTpBW4WwhgRyUmugVWdqfrceFfTC+NpmDvDaSAmwk8FO2olkkMm7EMZws+WDzFDp7EAzQVM6H9nDQigrBXZTJpVPlzcPV0mYo5klaKzHz8DEBiCRTPwdGR1OUzSHmeinIK6/xmudthArNqtEUsyxH7CC4PkXMX1dOJtfyPcuWzaRvkbuJjyQoDjhij+djw9NEsYpLUIypPIZmoV+BYLXj7oHZjPofhp2j5fE2ul+3bBpKrbcTrlkY29HeHk5E1uhf3W4MAVbCtmkr+0F2wzYge+MFJp+Pqinq+fqixv8nD6PgeLb49sp1AqTyyNuYB3pAtgekuEPA8KW9EUximchhLjbOgpN+qqlfSWVY+C4llwICZADdpwBFXQXTGVFjG/1lQ509Pv30jbNVmcCQ9BNQlBW5apOXSYGSN1znJi9t/1/hN4M5V5+RV2h4v/k4jUlVfl4tSuL7tsAC01jsrsIeFY1+uVnEUoegLr4+sYoP7hG8Xws3aFemhbF9ng2SRI/EfTP4RTGQ4S2jsPBUTmL9LWyJaHzST7kgtQKPA/eJHXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Daemyung,

On Tue, 27 Oct 2026 12:54:31 +0900 Daemyung Kang wrote:

> Sum weights into a u64 once per migration walk.  Keep the existing
> 32-bit divisor path for totals up to UINT_MAX and use a 64-bit remainder
> for larger totals.

Tested locally. Looks good to me :)

Tested in an x86_64 QEMU guest; both the buggy and corrected behavior
were verified.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

