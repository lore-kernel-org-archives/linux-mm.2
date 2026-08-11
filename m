Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BA2C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2816B008A; Tue, 11 Aug 2026 12:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8549F6B0092; Tue, 11 Aug 2026 12:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743536B0095; Tue, 11 Aug 2026 12:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 531866B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:41:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C44B714011B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:41:38 +0000 (UTC)
X-FDA: 85089554676.06.3B8FCDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8807100002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:41:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GTpKkC4R;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466497;
	b=I4NHCJAN0HBARX6RoQMNBCrT9+0EGY5nDnt8arLi50CALgI09yQYFybIzlcbv0ByxxIfQ1
	pImvO2X0kh4FbQVcvhBCw6sHDXcV0VY1VyX1/V8SjhmyLblqiLZvMuFUmgOWEjhNrmgmLM
	/tcV0CPLt9HIvnmShShV5wCTb9yqZW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GTpKkC4R;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+Epx2wcjNexkVxBVXOqQ5cvsB3ppFKz/3DXfzrT9Jk=;
	b=A6qkz8LRq2CgL1tKFSokLjVmCrf6ydbMnrz47fKcvTG8PgvfWdgHvYrClBSUjJq1FE/kig
	cOXltixX2HsGVw9NzMrSrgPmQx4vcress+K2YPmU/7miZ6Y4WmY9uVLea9KGTkl9i5xOXM
	NnDLbw4h/L+gu7UAxnWv6njq8fJH2Vc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1718440190
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9B01F00A3D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466496;
	bh=x+Epx2wcjNexkVxBVXOqQ5cvsB3ppFKz/3DXfzrT9Jk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GTpKkC4Rq+5o1GLM67JrgD5Ts2W14rznWSwUh7c6Sg0ce76FoteLtiJimwgpdwR1R
	 vhJ1dpIXdCmcNKrfF7tvG6J9trkTfyJyo5dm+fmQ/wRh3AAhzR/izfi9cGhUwmnVFf
	 M6aVZBMrjMRqPXKq3m4UMB31d6enh/3+wqqPB9lXYjHMhdkBOoBnC6Pb50Pd0I1iET
	 ynKQ04DjY3yxYtvn8MpBaECWT4hVVVilpiGxds/0z1HVJB8P6gDEdpxbnIHh3PdKEt
	 eEoVxoVg3haiTGKfidC2aqkWomiWcNHs5O0yEV23q6X1o911qySiozztxRtsiP9EDw
	 C6g7V9Otm5PTg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso3194166b.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:41:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq7xfsWLnX+DzUFY11rNgrTUWM3BARbA3vdG7Xtmcc+NltOFMe6g974jlWqnOOv9JQOWARG6F0ICw==@kvack.org
X-Gm-Message-State: AOJu0Yw3XoVgPmzn31WFBx9MNIV9ZApixaJddjL2vUT5UR5edk7X/X57
	hOtO11sWsJp6b8CTuYk5A81Ias5rk1aJXwj+sBizRUuC2nz+hfUNj0tHB/rJSsalAeX9ZqiD5fI
	Bt7+fy6SaygdqiNoWwoHmcI7qoJwMKEo=
X-Received: by 2002:a17:907:d23:b0:c16:3074:657f with SMTP id
 a640c23a62f3a-c20eca2225emr84178166b.9.1786466494869; Tue, 11 Aug 2026
 09:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260811051434.3805648-1-wfelipe@google.com>
In-Reply-To: <20260811051434.3805648-1-wfelipe@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 11 Aug 2026 09:41:22 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM0K_--=jMxuapkFxnbqBj6zqvz3GB9wmEjgDThQpzZkw@mail.gmail.com>
X-Gm-Features: AUfX_mznkferW2-XpPGZ2Jv6GhtHO1zTusbpGxdHEOAp7Q0jgcIPVx3r3MKO9os
Message-ID: <CAO9r8zM0K_--=jMxuapkFxnbqBj6zqvz3GB9wmEjgDThQpzZkw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass
 if debugfs is unavailable
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8807100002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qq4i5a3bjwrjz1cn79b4o5tbkr49y3yb
X-HE-Tag: 1786466496-373756
X-HE-Meta: U2FsdGVkX19drbEXVE+xlg8MIILAxHp6NXBVTsTVFt6sTklZgsrU5e10p8u7JV1dJqAS4wniF/mOcFa/YolCSUdJNqqFpI2L/WM7+0ZdQybUJPRX9z9nPnpd5+lMh414kw/rhbMEbHagveF551c2cuwfNhypJajJ7joqK3UI3WvNYOGcN6bp+YXfHe/oR9vdNbYWsRfWv7JpmgnwcP4Bbtw43m9R6VhEAboQpITs5CzsK2sLuHNLUGVaObGcbhn4fZW1dbuacrvw3moFLGMOKLs3oMxLkIzzCs/nmYsVZ2aX0KbUL8/iNuAaZINOQMii+Rw+HAshfxyIw9tmNT9riqiUx9vIzP3leLVPz6s+Jwhw9DpLFlMcQvUusoMDlEugkfJkRd3T43LPjd5LoQsPK11gDm2GdIs/Kfa4QK+4P/zQTerI2zqCRrPewIXFatJKhPkUN/Z+Np9yjiwfLiz2BK4nICTMWRk5kDokLYIcWQvrcp0z9JlnxLFCMJ1moJD6oeIdWRXi+1T32sR8ewxLxY2ZhR5QJsauW1SRTnxmCTOZObtmDPHpgtXluFH41Bz1yR6zloiLZBoL6mc0CSRyrpQfHfvh5gfErQuysfatdyyWG7gVTsCrAgStbYRmDBHQyIe1RWt5vbo4lAYwbH12vImSnBw3+nuCh5pEg/t39FJQeSdGMS0WW8pZD/aN/gkxpLFW+Dj8cZcWuC/KgAHax3qLtJCFjUiTQVyCUsuAzUMGBnL34ZWoIyBNrhZNfmeCpIpikNp2YMIRD81qbn86i3k1XtqPy7hRvgcvGcIopxa9tjQFXu2iiRJlFZ5zrkTP5XLRqKqY3UYmr4MuHFy/rOYBSczXv5kkxt24dlxcw0uo8OFeq/PR4XV0kRzxfxkaJNnIidbUo85xLmzFnp62eH26pJ3FHO569EdP9O3sTAF6BSeQrFflrkLUMA4vAvlJo+KyF3grG+UE0K7j6nk
 /7j2mYaz
 hIS9HkVx4XuVomlzUzGSVlBf2y3UnMh5Ig6NcysMUXCysfrNTaCgnekayYEhlzA1laKhaU1xmSFbfDbGAWkQVHYDeUJgyaN0yFXMBbI3blyGTLCYOGxrGqvmI83AF5Zt/1dPvFdwIKez2aIpsDH2/HvaRIx6M0nj823QHE0PvuoJpSF09bmXmFyYTvotskqUGqI+kssn1peoD6zi1y1TDsSIIukr3fnYD/TdYgbURrygXKcP6UJJUE7Of3+w7LWVyzSmE88BGm18vOEzlOaMcWQoL/9+aHTR0Eu7FaprImZsUesCaGxcymZYUYI36JPKTdYa2PZ+UshTsMwTHHSLW1pIfW6BB+bMtWNcZc0hif5OPa4zRGs/voImmezuOAVp/cWgVbGFA0bSoCVNupKBNfANs3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:14=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
>
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
>
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
>
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

