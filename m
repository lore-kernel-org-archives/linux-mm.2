Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94609F36B97
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 01:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CFD6B0005; Thu,  9 Apr 2026 21:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED9D6B0089; Thu,  9 Apr 2026 21:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03706B008A; Thu,  9 Apr 2026 21:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0E66B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:03:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DEBC8AFF7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:03:13 +0000 (UTC)
X-FDA: 84640847466.20.5A9144A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62EAC120007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:03:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umZKVLJe;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775782991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cq9xARfeF9XGkAqalvHhZXwwjflN1rJMKAnIVo/q3L8=;
	b=eEKApiG8QFGOezTz1ztHhbCNbDl8ams92nJfnVkbaDUwm0Ya39GJQEdv4zMlRh+rElyXa4
	/BXc+pQR4W/4dNB8MnRrMcPgjf/lZd+aoVdewPyuJTX1f5AzXMQDO59uH7ePM84ZeZPMri
	PcYif8ZSXMVDuFfznDZz9jegUf8rEy8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umZKVLJe;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775782991; a=rsa-sha256;
	cv=none;
	b=by7AQs6aiZy46tpeUgLnhrGxZP1cHXoBRmeDEMLJh6prHjTVZQxYQ62ciliHgBjt+nEUOT
	ExZkfAHB5nnl16zfFIe6LbdOrvrs2GLzX5Ts2NOIq312MsY6r5K50oLUv3d1h0w8aM5if0
	PBHtSdl2sXtIxhVzwrKdCmqoLO+M5pY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 791A160121
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316EAC2BCAF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775782990;
	bh=cq9xARfeF9XGkAqalvHhZXwwjflN1rJMKAnIVo/q3L8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=umZKVLJeHAWomPhY/u+0rzmeH0iD0P4hizcBUf4V8bXHcPdSpmwTvJCwHxOFomJ2S
	 RoKIPHb6Vo7Yq7M/rLaeyHZI6QbbdzQIOy9LzoehbNaQAOh3UdKb5qyNqH8t8J3Sif
	 aieMmw+UDVLko88RHxIpTX4FWHRrKWGXhZTYEEUP/KtOoshkau9c/RQVnigXolUm11
	 47J1u4Y3Ov9qToOgZkKM1YDSt6HQ7q3l9W7uAOekLtRf9lokB/W9cDRVl5l4fegyPq
	 usyDjQ6vPiib1pwW/hsOr3ldfas7egZOnkRjayQyQJ5lz/qEWLMKSYLLduzugf1Q31
	 ckCnho9CDmccA==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-899a5db525cso11990606d6.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 18:03:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUDFxFMQl1Jnq2i+EURG5pjrFchRySlLuGrQ2a4v737u0NqL/gi6wOM8QZpwEjIxYdw8yP74yw31A==@kvack.org
X-Gm-Message-State: AOJu0YzADY/W4RSi6DvbVZT2QSmSeDc6T92ZYPoqoAMVGCiJkZy4sbde
	cIT4LsJKNtNS5lwgX8x06g9xlLlhsB7kkg+K88nCv3o5DrH8HJvC3EYCbQALv4JD7yCtdX37uic
	2cFxi9K34JKpTEIv8hjvEOyGgB0A71/Y=
X-Received: by 2002:a05:6214:448b:b0:89f:2fa:a9b6 with SMTP id
 6a1803df08f44-8ac8620d89fmr18755566d6.37.1775782989537; Thu, 09 Apr 2026
 18:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-6-baohua@kernel.org>
 <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com> <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
 <add9XGTYL9sYilqO@milan>
In-Reply-To: <add9XGTYL9sYilqO@milan>
From: Barry Song <baohua@kernel.org>
Date: Fri, 10 Apr 2026 09:02:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xcCjDdFXrbhh1bJW2xT0_mx8T43yNHWCahZ3fBBqU5CQ@mail.gmail.com>
X-Gm-Features: AQROBzAl6bUdOwvzhgIdvmf429K8nFo46OcgggBCXMjaLU8ZacYb_QdEKvUDvYc
Message-ID: <CAGsJ_4xcCjDdFXrbhh1bJW2xT0_mx8T43yNHWCahZ3fBBqU5CQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	anshuman.khandual@arm.com, ryan.roberts@arm.com, ajd@linux.ibm.com, 
	rppt@kernel.org, david@kernel.org, Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kncroecs6sq6hxsr93dp1fihujejadss
X-Rspamd-Queue-Id: 62EAC120007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775782991-567126
X-HE-Meta: U2FsdGVkX1+TV+T0KUobRf1N26e/oZ/66ZB1fNdHmAuP/Z5cydhkLoxuVwo/NDJle1IyqaaFz7H2a/iAZg/jcxelRRyrcBPVyJOkeLLTRdn9N3KDW1OwpQJMCsfSetyZcs8SNRTfK3qFFNTbQq38WvqBx9Xp2TRUAi5IfSLyfTU1StCFY981i497Nr0bmEE8eds1B3iOTpzQYWm4JLrt+zpDv4+pa8mLX0onMdeXN3gVQKmQUjyVPfRQV+NnVROT8i025WQipHkH5Z9bDx5RfmZsR+ClEvBtumkR/3+sHGiDY/rWAsCPaCDrjgVTsRSY6F3jBhabTUPt/8+OdkC375LmBHQLckGpOVkJSxPwnGf5oZSYufzJKNHTzC6hJwYtKbp4f0OtEd58PG1oM61cOxYWuWSQYwsx0oYuH1LmrggsK5SQBIXhOWOGGQixCmbSBbhZg5c6W7uwHtVHUvhhWbRcCbeJkcf+bP5o93RoaHdPjZeNB9i2Lmd/rcOfatRnHwOkjSrQM4ePhlSGTclDEKawHvQ4rU4ZQCac+eZNNvrx8DTLFRZQ7myl7X+sjUeN5WooieYK3LRoztIbunfsr8nn8irlCmqFvNx1Bv4OtFJheT6Ah4FYIEgbddXUwXjXWVbXs7Dje6MQhHlaVYCR/eI5akrnWwSXpxKkl3BLqLYwAZ1quRNOIY0hL4MN6fqwFVRC3wdDPYg9b2Ax400vlXpar2FOuiag23oZUXPAiMueeGWgvyiPu4TQVqldp1cAjsK9TnJQ3OTAT0tn+9mmv3vFLPEpMTaE8URDNcy2vSanAHqEVpzoEzHxRaJD6NKyL297GW2MxhsSlGBGLfYYtt9tGGBK4qtgDzlI8xjf1ZqhVTk7tG2j+7re2dJjm9dRsqj1FPlHfhy+CasNDISZt9Oe613RMJnmGNm7d/7XNWOfE0CBpwF7NrDZGbipk2UXoTbYHfi9/Ej9mS3mz0W
 xcvCssoz
 E/exwt/9jqWXXdWqUA/Sy6wqq4JeqpcaMXfsrKdsDJmhddUWxQScWw6Q1ImTb5krcN3tKc4PFephqVVknMa8PabquItW5JNIlFyYeT/KLHjRDyEq8s/4bEfzh2rdCScsc6BnAJa8dbQjS1YszzOE7lzyn/aMx8ALJujlVb15piq6PrQQw1XIryOwjbxMGwrG8oFi61cTmwfI65Yz6yckx1u/o8jTJkmZCASVVHCcdO3imAEpnaHYwE56hIX8XB3d4aYd238KMxS4+/7QQ5Qa1OjwGF1aV/fnfz1HcgAYoGgNnsQUS4KTpzRLm/ykYR0ryTW1VwEXGfZcLm1He4xanblSN2g6lotHYBkrlW6IxZl0M1bC62LHNK9jSVlrEceaoS7cbg4B9V/ULirb/ARl9SMTeXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 6:20=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com> =
wrote:
[...]
> >
> It would be good if you could combine the work together with Jain.
>

Sure, thanks! After discussing with Dev Jain, we=E2=80=99ll also
support non-compound pages in the next version.

> --
> Uladzislau Rezki

