Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E76CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DAC6B0093; Thu, 28 May 2026 10:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765D96B0096; Thu, 28 May 2026 10:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BB16B0098; Thu, 28 May 2026 10:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF486B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:02:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDF321C1126
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:02:13 +0000 (UTC)
X-FDA: 84816992946.13.721A163
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8B3910001F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:02:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CoQXGXR8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779976931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sb89AkexlC8S7MoHF9+cz/eT1YgX2gdgA5YSkoKvstc=;
	b=2e+aBU3fLg5VmcqguKOTu1BHG7xVbgX7AsTWCT5fwo9f8drO/7zAFOQ6oV5UfhhIX+098G
	jK1S+5d0e7dHPDlA+PqSa4s99mlDbnYCQkAsjZIxljVu/+RKtsN1bBZFl9hgPetr/efma2
	TfnW8EzSuurNhm/t8dMGgj7CAwHJ5sY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CoQXGXR8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779976931; a=rsa-sha256;
	cv=none;
	b=U9ZPmdWsu9MT+1Oqapp+jRHeIVLsDA5t+cK++IdE+4LzzY1rQt1e48eK+jYAdd7NMIEDVc
	l86wgJ7oCk1cC9KozsH/YY8jENmezV1VkmJpF1C7jyDlUMUC4WIQ20WyIEPzlwNGfuDmjG
	IsmTw7joEVnoQI3CxTonAKcfT1lTJ8s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779976930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sb89AkexlC8S7MoHF9+cz/eT1YgX2gdgA5YSkoKvstc=;
	b=CoQXGXR8ne6kxyxJL3tWne6z991E0wYQLwxSfU11mI6Q5U1/5Zhy2q3AtjtbQjEb/HSaeh
	AaDMRbGqR+L/xaXnhnPz6viELQSgjSu5nsGgttptPooU0bKydQCpPPkf7NvPoERIzO0tBH
	IW833yCKfVldMoG/R1yA0p2r8jBV1Ac=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-r1rhC1KLOxGqQ5BVnF701w-1; Thu, 28 May 2026 10:02:08 -0400
X-MC-Unique: r1rhC1KLOxGqQ5BVnF701w-1
X-Mimecast-MFC-AGG-ID: r1rhC1KLOxGqQ5BVnF701w_1779976928
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-47d193590f4so19451709b6e.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 07:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779976928; x=1780581728;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sb89AkexlC8S7MoHF9+cz/eT1YgX2gdgA5YSkoKvstc=;
        b=AJwZVHDm9Ibe+6OKOrMwl++A8wQBODfQV3wTZrWR2ZLZCtUJPNstOx9gfHGyhE69Oq
         6YL7k0Yn8jXNaxi3+pNUL5iUzizALzl8fPHiJ3gM5L8ZUe9dciEjiTL0PZp2Zf9TWpWS
         UGasXgeyMDsQtpuvmECnBAbDWrpz5c4Pq/Ba1OA3oE9FlBbxZ+PjQ1FDWBino8RRKiSi
         pV6GxQsne+kt2UTmsD3qJTmGn0+Kn4wjyAta/s4biKM/VaWoyd2ILoxhBnNtW+mBKrFE
         VCCvcSlb34O0dZIgHcyvovxu6VOkoMd8MGD5FbWHQl9scacdPTHfA5U2fRqi5/zPrdLg
         ka/w==
X-Gm-Message-State: AOJu0YyoKqMT6EeB4GKEmEDf6RN/NdjfSM5VLvxRUl5RTOPN44ZQ8FQu
	cgqaQRPh3raDwR9T2JbIOAX4LIsSLvrUJ/WHrOnkNagWMfkfmlJVJvO+oJVGqe0arzHzsLfo3Nc
	JHf6KGpt18YULlqSOI3dnpQe4L2X9E3siThMrR6ggxOCpl0nLkHDw
X-Gm-Gg: Acq92OFl+3/TfK20TKeHNoanv9cHueUFwuAO8/gbFh8z4wZCf+ijDdbJ6AdqrIxWP5b
	Ty93QnrtOSJDrktIg+sAn5VRcjIVq+QOkN2aFvOCVpIaEQE8WUB+iIc21WRXCrSg5vP1TcC4qv3
	ZY35pPTFk7vAXiARFHVrmBhSsioR8f1i9PKKoLDNs22b38+w429PBMPgetT0/dBk3lPd9ezkC2L
	d9swful+nEhvlZMiDKwUF7xl1MgE5cX+z8EefR20jv2UT46Q08DIte0dEEdxUMOpLkq3FjQBSjE
	mRLP4RS5LhmoPTt6qAmuimX3kWnCir9GY5rq4DhRUHb3PAcJ5vFfEwg1INSdiJ9DwAAXe+Ev4CJ
	XA2rraMc+qoxXqUSh98qpXgtgbmTYJw2DquX8m+ElkRKRm7gkRZpGD6c5rsZ1mCOKRaw=
X-Received: by 2002:a05:6808:1482:b0:485:5430:2bb7 with SMTP id 5614622812f47-485d94ff023mr674762b6e.6.1779976927751;
        Thu, 28 May 2026 07:02:07 -0700 (PDT)
X-Received: by 2002:a05:6808:1482:b0:485:5430:2bb7 with SMTP id 5614622812f47-485d94ff023mr674628b6e.6.1779976926679;
        Thu, 28 May 2026 07:02:06 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706adc446sm72730071cf.15.2026.05.28.07.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 07:02:04 -0700 (PDT)
Date: Thu, 28 May 2026 10:02:02 -0400
From: Brian Masney <bmasney@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Storr <mstorr@redhat.com>
Subject: Re: [PATCH] docs: mm: clarify that user_reserve_kbytes has no effect
 when overcommit_memory is set to 0 or 1
Message-ID: <ahhK2nEo-HPgodNF@redhat.com>
References: <20260528-mm-clarify-docs-v1-1-aa88e83b4bfd@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260528-mm-clarify-docs-v1-1-aa88e83b4bfd@redhat.com>
User-Agent: Mutt/2.3.1 (2026-03-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WyNbJTGBFbPzwyeaDf3RKkzuR4BRcnHFSr3jOtdDaAQ_1779976928
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: qfk98zpw84pmcsy67ur8j9pczfuy3tem
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8B3910001F
X-Rspam-User: 
X-HE-Tag: 1779976930-951352
X-HE-Meta: U2FsdGVkX18RBiM3AxLcQjAz3OKhos+JzKOPpD4ItRACUwRriXYUf4TpM83hbUhLDpT1e6h13PJyvc5z0WUX/XdiibyyOGFDEBTHXYXI6pbk0X3Fplf9SycUcKqzQEh/XI5LUkEtx5C50IrrhyzNIfLgqh8OvmSqsGINjj5cEqFTKpJRDBiRgabLf+vmfPTqOaJTvaCErrGlcPQEm01FjfDnfQ+jLG/+ztMBh1RBzyBwTi4vO+vyNe+W3amcuaJORgp/2ufA4o77Gd4zEsWK40XZPjQ4wSp7/2+a31jYqF9qsILFz+A/DAO7toyZZEhSMnbfeEAQsBSMHNLVrTiJIwUwZ60uZZTLNs2axyPG3ino6EXjkR4BPKB1EKi9MTQ8fO4+C+mUsL6dvy0+1zTAdBLCgHWrwlqO9gg7OnGQPiBA7XdaWUUt1T4Ur9SGOp9vftIWyEMXlVIDgzHlTj4zSeHXK0xWZUfFo85PAEyFTVJzGCEMg7jcc2fF0SV/q4Tdzj6AjbGqAD1bYgYDXnwTI9H+hH9WmSMamVbQnV5Xts479cuMcGzdIXC34L9ZoPLaqprG/zdyPB9bNiBJg+Ydci32geLhRCBrfbOsbw03QMwEqjpsGmZtExc5Q39Bd7HfFTBa3OOaUMqifSB96j/J9kf1ln5CVr/hPB62GgRskKH8feGEVG1tdOYxIynt/xUApP4dQPZI9U2Yhn/ccHHYSvkwBpD0GezFG3dhN52X0nUB/oizeDS2UlOZ7lzfFSfv998Ef5ts3s8viQdRzUBDUFROGw6TEkzqcKFFsLizK7Rwky6/+LnON7cYuvU8jDABq4vK5RC3YO0ohfjUgukz6Y+0xJZDurYxriDveI4BcB8yJOwfJmg9PsnwOqRGxlb3v2DHBiEeo9YF7tekGrgq7nHrC9QKzZM1uhvv8PUHMBH44LggFianC3yUb3Zkdr8sFdfTfQEQ/8cwosnopoy
 WK1k3fFw
 jZ+6gBxHefu6i/LM5L9vjiCC5yzKzLX4hETgiHbDZuQ20XjsucLl4Y1iverj8ZagCivJPBfGoUw/nO0EInS6f9asaQwiE87Es1QPY652yxFVk301FnkN1Gh9deBteURu1mEnBchumSuucANR72dKKL09wsoZZjaLpJ3pLqKhv+KiMTetpjlZfBKyFVT+Ld8PnfQl7OdWEWqon8D3/tO0QOrznWl7BnziRb+Whqz5t/tGmcsmfbNrWpO3S52SKa8Z2Q2FEyk8bPMINgssdpD7Du2cwTIXnVOZR20KH3afj/z6JqcsFFHcZq5Vchj7h51lMhKjx92zuA4FTByjQGUVVwjQoSkEO89Pp0N3odLp4yI06WkPUVJ7iGKrITREkuiKXpiBlXlX/ZSv8osnYQjSJgSnGzzdP8Yhz0C+pjG/yzOuinglV4OgTW0qtxFT4AmMr3wZFBTPQnWCRNavHJ2TkSV9X0VKmCVAkrdUIFmPoh8VHdX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:45:10AM -0400, Brian Masney wrote:
> Looking at __vm_enough_memory() in mm/util.c, user_reserve_kbytes has no
> effect when overcommit_memory is set to 0 or 1. The documentation for
> overcommit_memory already references user_reserve_kbytes when the flag
> is set to 2.
> 
> Let's go ahead and add a clarification to user_reserve_kbytes in vm.rst
> that it has no effect when overcommit_memory is set to 0 or 1.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 97e12359775c..b9b0c218bfb4 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -1034,6 +1034,8 @@ min(3% of current process size, user_reserve_kbytes) of free memory.
>  This is intended to prevent a user from starting a single memory hogging
>  process, such that they cannot recover (kill the hog).
>  
> +This setting has no effect when overcommit_memory is set to 0 or 1.
> +
>  user_reserve_kbytes defaults to min(3% of the current process size, 128MB).
>  
>  If this is reduced to zero, then the user will be allowed to allocate
> 
> ---
> base-commit: e7d700e14934e68f86338c5610cf2ae76798b663
> change-id: 20260528-mm-clarify-docs-76ab8f82826d

+ Other MM maintainers / reviewers. Sorry for not including on the
initial patch posting. I initially missed the separate MM Core subsystem
in the MAINTAINERS file.

Brian


