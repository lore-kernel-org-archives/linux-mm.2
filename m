Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0170C47BD0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14AF96B008A; Tue,  6 Jan 2026 04:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8636B0093; Tue,  6 Jan 2026 04:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CE56B0095; Tue,  6 Jan 2026 04:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E59086B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:47:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84AF8C1DDD
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:47:14 +0000 (UTC)
X-FDA: 84301060788.14.2A27229
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E12F120002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:47:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SiB3YFfZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767692832; a=rsa-sha256;
	cv=none;
	b=bgagYLz8+l6quM5OM5Vdu/yndGkvv4Wi+45vs81IZuiiBUKwNkxnINKQcmyOKAxKc2S6tH
	k4JeiT9RN4ZdpRj4H0TMUPRZAUsnTiXfb0hxqEUVckv5QgykKVWtpt8iROXDgkuemzC3uV
	DWEkG31Ps2KdcskumIoPKTOI0qRNiR4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SiB3YFfZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767692832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJXQ4Wd2y2qV/yJPfn8lP+tueGk0lD0a+quRej+wuvM=;
	b=JrEBeXwuudJkhwfI1y4m/a1Im8BRBklZxP0weoXdYSwBoiN4shYLwQE+MaClGCX/8jk7FF
	BJxzu50qbg5MMXhmpj2ZrCEnJhidKy5OMMbfT9+YcyPtVwnREQNykLU4YXTzI1T9xprsLh
	CzGG3FNCNPUjdersTBOyjL6IknlYua4=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7f89d0b37f0so1191816b3a.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 01:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767692831; x=1768297631; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJXQ4Wd2y2qV/yJPfn8lP+tueGk0lD0a+quRej+wuvM=;
        b=SiB3YFfZW19uodJxKHWH1dLlgv6ErfX6Uhl31fdDybxdkkY61f/9pbj3z6inCW2AfX
         eS3FNBpWMEgIo4S8Apf7GL71fTWAm1Lco/7gT4XMv9mN/T0egYGaNtHe9hlcmv28TyjE
         6wyjXE5gbVbpaXoUd1ESiPungQHYqT8oVRY4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767692831; x=1768297631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJXQ4Wd2y2qV/yJPfn8lP+tueGk0lD0a+quRej+wuvM=;
        b=HbhGoj+zRaGSYFcSQVb3VSKPIg8LYEcWVrwKKlb1hsEm5nmTpH3whSlnGreW/zzB5M
         C7SS3P83dmhtqGxOJDDWdSHllzTimwPCa2gteMiAw1/tVy5UITy/d8OIoOm43FKy0pdX
         XzjwIQFSQGpXqk/tqb030EiWPZAG13HlPAz3WzchHrUbGdJTvn1p7Jt4/YmGWhp/xQ44
         5mYsjG6phM0QgocEy/X7k3tjGLXghDst14XfNxLmTumgThsgRcMbK6uWc1GcS2EROhmv
         4O9b6oNOOxNXXN6BqXNJfh1m2Ihb1VAJYTRpF12G6CTAYwbYClW2iv/78nu0l6+DZ5sb
         z84w==
X-Forwarded-Encrypted: i=1; AJvYcCWVeOpH6QWnyXerMnNWRYKzyVISxhrUDtQgQanjf9/lXPCoHq2ttiLuUA3mT5S/BIuxrv9bCNZcYA==@kvack.org
X-Gm-Message-State: AOJu0YyCFWZxA4Ag4KOdeOU8GSxxhsfw7rx/nQ597BRnSYVCLxFdYuH6
	PDwFndExa+6/CGi22T4LfKmdKttP/D9wS/wgR5TtGAVFyMsRCo0rxvniNiuwOrTVlg==
X-Gm-Gg: AY/fxX4eUrNI0JwAwwAPGkv1gAEJG52nYxuvz3q97prubG+pCVu21aLCmRebWuTluwC
	s4nPNzGDedSFg1nMc9YZBDZvqNIR8SIK5oDNmfhy5EXSD6CBB0J1Tg8EeHJKNdGxzD5NY7rIMM6
	hPI+DkriSB0XrlAvjCMxHeVPFu6F1DzbgkwSn3LKr0z2TNxuu+YWBR6KkfffwvCCzCmf6jQczL8
	n5ynFJNaPkGUt3sIYcJEbQH45APMee1i4kqyh0GHEIua96ov1QjWEb6GVyiN0YPzrCMqu3lxnCX
	YU4L+evKurK9pEAIMnQ153H1L1GZ1thdXRXLFy7EdWgHNChhOz330StJN7Qn+gQu8FkQcDe6SlM
	rVhEk/J7qS6DLDJaA5ZK4+ZNcPUqIUROSlXjjKVsYZTmfe5E9hGU1oJYL55ZyDVATfLT7+s9L5v
	epGnNewGr6Pl/ZscJlL9hxXdLNYHsv17rmPaKbdz6h87MQ6LpE67M=
X-Google-Smtp-Source: AGHT+IGpAMvNG5pRJJflVY45rokqvptz5oyKx3i7Xxx3gYwE1ZwQz6+oJctbCyU69G0avbqPtFt4wg==
X-Received: by 2002:a05:6a20:7489:b0:371:b0c2:4acf with SMTP id adf61e73a8af0-38982a55826mr1930940637.7.1767692831281;
        Tue, 06 Jan 2026 01:47:11 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cbf28f6cdsm1851021a12.6.2026.01.06.01.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 01:47:10 -0800 (PST)
Date: Tue, 6 Jan 2026 18:47:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <b6mzgm4cgl2sgervqymz6cldgxtck7em7hzzgamucm572k4ayd@bhp3msgnitbh>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E12F120002
X-Stat-Signature: eb469sxn78ktq7c1zbqfch1az9cpcqbb
X-Rspam-User: 
X-HE-Tag: 1767692832-14243
X-HE-Meta: U2FsdGVkX1+oOprRJa4DEClmZpkQcEO17L1W8LzTQ5ucseQSMgmDK0W56IZwURBAJjzey0YbiZ3MSGva9SDOwXdJPOH88ICAmk02FNXJFN94OvDWXbbWOEhvM4UZxjusqMgd0elGvk8ISlhy4xssdRm65s/DJq8z0FERbtMmXKAghOuoyPkmhi7OHaVp8JcdlBTsvgL/ukj+7hkO39ifPWm2cUxxXG/4/WA8kRY9zCV77D3SFQNRCLIbKeyCDEGP0t4BY1FuO5zQzufPE7CBGMhxPjIhXLsPzxR8PZO0ALACqAXKbfLRKdeuDFLNv683bcXGYk2KUVu9ZrdVXTG9jDXQKInPKf1CeIKV7tMg/3OGah4mK9tbAinNN89h76kEoBRYPUYW31cFof3cChKph5TY/jNgyEn79k6nkjVcvvghC7Kc4XDjSIkAYinF1mDhIXBiVBpUWk4msruXkEgo4EhvOuBruQGgOuTvTFH1pTyRiQHl99H6LzYN8rswlhatNI19CPUDOyy6yHSPi3ythj9pSXRw8koUg3aSHLPn9GRDvO8M1zhB48axUtiZ1MxBXR5qM+iGIt/MzpzldxaB3HFiFdVCSzYzvSYMuLuxFoAPz4WfR0FL28mJEOUJF/QonfA+L/iEfec1HPnEWVeXPw3alIXlMbMJU6qG3b/ccdS5XvaVAGxb2liZsdpAtfPlXd0wxOo8FCVLCNbfhgVpNCWVRRjdzwZ7mQqIQqwpIiEyKkzEsoOjwGQ1Z/zPihuZXp+pP6f7+uHMz5VyBw+mjqXcssTGKtJdbqDrPfsMR0hyYcYynvdquXaP9MfLwN6uHffyXCi8dgbMCou6K5a5PtEiuZMP1qMk/vkbt6KPRnX7FZdLpeRIwsSpDzNR5/+Ui44ewTziQZ8OOVxznnoRuJ0bHXpgsP8F89EagY3im9LvoyC359/0DGRwQUAp75VE9LJINZ0Fs68yRu7tddD
 YPZBdF9Q
 XR65p/LbbNLi1Bt1sDIwk6QNwEafr4lcPUAEBuZCfkUuWFsMsUzA8+2JLxwXccSY5XzPbCLQfoT2JHvQThzsVHSaVFUC8Eh3Z6Tb8PiByQcGN4ginHXbWuctJdREny7RL/CSUuVD/YeyNeSbQg0zJeHsSQLyr5Jf72lWTN3aGdr+02KR9kNFDL+5pHwSBTpt/gHRpr4qNKogUXhaEMClPfC/Aqmjy0MBGnhoq6lNwn4WdcpXPS/BkkjDUw7YfShpb0W0ajQ0xFyffqKxFfbap3I7Z5t6IknxDg2Y/WZPJoYhKHiMijcs3D2Cmsn+FSIJHdbDiy0IhZ6aRQk3xU0ANBDIeEbzGodMi4FXQvQ4ObEiFxTk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/06 13:20), Sergey Senozhatsky wrote:
> Another area where we potentially could apply similar heuristics
> is size-calsses merge logic: sheer fact that two size-classes have
> similar objects per zspage and pages per zspage does not necessarily
> mean that merging them will be beneficial.

That's nonsense.

