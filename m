Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6ED606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=arf/kyW3
Received: by kanga.kvack.org (Postfix)
	id 3F81A6B05BE; Mon, 26 Oct 2026 11:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8B76B05BF; Mon, 26 Oct 2026 11:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE196B05C0; Mon, 26 Oct 2026 11:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A97C6B05BE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:54:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89A081C40B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:54:33 +0000 (UTC)
X-FDA: 85365224826.08.9EF0870
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf29.hostedemail.com (Postfix) with ESMTP id B714F12000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:54:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="arf/kyW3";
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8FTqo2cthF1N8/EPSwd5W+NmZQX4EUuEeAqIs6bJK8=;
	b=SFUiT4NJ64dEOd7nO8G/R1988jQ1whR+I5E/UkL/QrU5gU4k79rQeITLqHTolRqvPAjf0R
	+jmvfxCcuFl4t9EG+C/hweUcpTJTqFObjWHklH0TLrVCKsRvlLaGf5cMX6fLLgpbsF02dm
	ApwAZm/xYpbBdrtE+cg6DCEcZ2ZrTqI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="arf/kyW3";
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030071;
	b=bJvXyokV+J2vT4Q7TMqnUWrPj0k+5CSTDd3klfJyH0REwnn34Q1fN8dssGtC7EW6RSvQHz
	Mz5fpGWkP8+s++uTK7/ciIjr3RmfE5dTLYCrc2bKKs318M4rSu1+7deF1q4KdOE8ay0Mq8
	EveQC9WIvy+wr0BRF5TKm5qVW6d2KkQ=
Received: by mail-pj2-f11.google.com with SMTP id d9443c01a7336-2ea993271f2so10687505ad.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793030071; x=1793634871; darn=kvack.org;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B8FTqo2cthF1N8/EPSwd5W+NmZQX4EUuEeAqIs6bJK8=;
        b=arf/kyW3PCvHPWD+Ju4/imMqmuifKVdx+GrYgP5pYq5F/q/2Xhkn7fKl/s6wO84jKU
         VjWVw8Aw8cVz3yfipZwc+m3DME2sA/QHIyCz4/mMug+4JVKRrqnMdyWl2pmC/Pmj76aD
         1tAeyjF49sbVY8TmMtg7trPOJuVVa6AZ24evOJNvtb4W9fD/vPTVfyCaIrmrFhYPOf3y
         O9ITVVHmrZPd/CsM/UgyJbmxMibOH4S+7M+96j7YVOcj8pzCAwrSTpQqowjiqL3XdEVs
         kYMNOg1b/JtS/3skZEJ3Bz7KkgzWF6F3XLzLoMedDqBnpv+6plpnv7kPWS2N+4eu0bk8
         3JSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793030071; x=1793634871;
        h=message-id:date:mime-version:content-transfer-encoding:content-type
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B8FTqo2cthF1N8/EPSwd5W+NmZQX4EUuEeAqIs6bJK8=;
        b=mKzNWBBXQoWsOljNmuUQQHvsDTTIKHZin32tELcEpEGEzKIguIKu8baCxjhxR4q5Te
         wsFrA3mT3zFJNb0GU0dSCfYkidrzXRGlvPvHR3UxChzSE206+Vj5bPcox32OgA5dCBwW
         w600gziBqvmWDX3hJLJVGYqvxGFmLEXx768HqW0PKbGwxLl/nzstXca1eXAyFrpuZSIw
         nXc7I+19Z2y5aDtv/p2G9oWmOVZRfcwd2GdbUfdvr79bmJlTipLopY961dglX5g0cEDV
         GFIaC715ooW4DmNU4ynBSzNMysqk4nQtny+hl5uOPvSqMGs8ZjDU4sJjmzibMFaKMRuf
         2HAg==
X-Forwarded-Encrypted: i=1; AKwUvBxJp7H1BLcYHUcVnhApAAJ3Xc9pD1XOlXkKMvR8I6z7TZee1az2t6oieF+O8o5K2Oc/zQgYh7T1Fw==@kvack.org
X-Gm-Message-State: AFq9FYIJtNdg/N1o3dJrNNsm/Fsh8C5TNiXRjccZVB8JNQvhaQ5z5Qq2
	8XoI5uR47+LX1VUfA7rxeQ2Ecb7HmYck+0bD0wjDLxWZ8gBAsR0XBJAY
X-Gm-Gg: AYBFou05Wo2IwjdBl5l3leMUGvebGda4nXSaHA/VUD+02jHs8gfpympmVXmq5EFqLp9
	mgjTM5DXSjneAyeUstKSiheiD6+4AsQ5Ljo7JsoPtT0oC8hG4KK/g5ImK+kHJL5LPFSnrPT4/cF
	+cdP8SsNxpyKue3Uo9uo0GGUZFpR0WDy8JD1mhEzgatZzplSqYlWe7UBAIjW/NsYNnCQwU/tSuE
	N9RYSwa1mYVN3Q1WnKtPmiKiv60J4F+1xp+nBpNZX4dyft8U/CD9/LHyrRfuVPIDlgiX5MidiAA
	pRESBzo6LgrJO0clknDf0mR/cTDLiw36NTjRa+JAsUg5XzMnO8UCbZo+1OVG6M7dRYoRnggxPVW
	NrU2VhWqsxBMsVtRByNn3z8yb34kHgvLamJPzai/9QRTeSd9kJIBtWEPzoaG4gdOUVsXy95ej/q
	sflr1CYLD68NFmRoshXb8LS6+VDLzjL8T1fmF3Tj86O6ILCPhx0IbTFaAeyTQMbJxsoozPOtizb
	MJLaPU5c65dNkAyf8jHYDRIhE1sKbArERRBZbdn+Z9Ug1NRz0ofDmfhIGlmPCdL2HOzzRJMFIOo
	zTAdTYW+uaRbupC4kirv50U/oiTS4UNSV30dqnaDA2+g0pimjUvU
X-Received: by 2002:a17:903:988:b0:2e9:5059:4477 with SMTP id d9443c01a7336-2ea9c6c82f1mr52579075ad.23.1793030070524;
        Mon, 26 Oct 2026 08:54:30 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9b221101sm19099555ad.71.2026.10.26.08.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:54:30 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH 4/8] Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
In-Reply-To: <20261026144451.150560-1-sj@kernel.org>
References: <d054b7a2653a2ff3d419b689a50a53290c2cafbb.camel@mailbox.org>
 <20261026144451.150560-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 02:50:54 +1100
Message-ID: <179302985414.2.11997096580844017569.damon-docs-reply-04-lru-sort@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B714F12000A
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 1zihc5zzcnun9g8qqwnht1iscqkb3jde
X-HE-Tag: 1793030071-671029
X-HE-Meta: U2FsdGVkX18gAEoaEg+p1YqB1zzWUzZy317ZTlCOE3M6w4R1K3NcO+3jUeXDfRJHS4sDJIgHPaV03lIHI9X4fxs+jzC+Vw8JMrS6baoNZf5nzierfPGgRZGIPuAyn6+7j5+GIpdvutNsjTHKX2JMzoDpeW1kxT5iPC3u2HVbLt4oiAlCHKKjR+gqNK/MBnST4BEuuPl2rj2ezAfcEuYcMo+ltw/5TqaAbsiV6CHlVh8OEJl8wnfr0bx4dwxCEDwJUWqNZUU4+cLeHD3zM6kHxFv2nFuNxrz+p8unbDdj4VgNdJjRktkyuPbQN3juk/WTYDCbopOJSSUai21LXcLyxc8n0+39Tk+vN+1vAC+lm6sdVnPnM72EiZieAe0JaE+501Kqerk9tNaZOsAAHLcybTn+5j7krK4clhKWIRm93YVUmofCMoCRWR9cwibKfT5QWWbWIrvsDweGl76lgvLR04vK6/xd+5ku0bfvJMC5NC7ywcpXRUOXkF1yB3ExqZ3LwF64qP/VkFhXF4k/0qopml6oWu532KrbursgSlnf2FOlIBFTZRBWcNgISMNNlNNaIAr8jsrz1Apo7as8dy4eNOSi9SMOxiv1/GNeS/q9Ie+F5bz34dSowpLLth1k2DQZGbZvMRZTzkXh+Nxdgnb13dwOffYJ5PrWkg/1w4Lg/zRc6o9OLkFciPtiNmr8X/hrmNBcDeTXSXtfP42gxt1E2viq0cIK9KvzopXyW+8qUrpLY5GkU85YHdMRA+lpLINvAwmhkkYNMA7nGfIvJJOO7ZeJRler9QDlynox/go0S2yGNGVpMYRkZBj0DHly+PEPmASujU8+AFHitnQs8cn+u2sxpXySiOT8HiUiKeOzM6czSyb9TtHBLA9JDY1BQa2aG/YPxhPw33Pl/NE/4AtwszcWtsA6AklaXALK6Ct/ulPfg1wPwM8HHE1Il6Z+IruEFxiAP4IklbzahBwpDHX
 B8uYBKiR
 ADP1bcriHJXI8UGEda/kRx5QRA1qx3MOQC1o78zzAC/vlPHX6RhuBJ0WwZgEHNiHco+nsrlpnFR8qCkNO619Wvkx+5H45IqsDoqFKCWtJ8TiT2ixCLZ9KXYpcg/eDTPifWoZxapWmnth1Y6Rp9MIkZG+GyawDkJqpo2JrLMRgTo164FMeQLi1jucpXl0iDcKPtyyGkUHWZpDBI5bNykbK9//IrwbGKuAlozmZHOMHQs4BkrjkBmiO8wY08x5O/HCbAq4V9RkYi5g67Sa8Icg68UqweErT0lsEoaOxbQ3jjLgcqvZ3w84ZC3NDhkZozFPMbUuRE65pn5cxcxXHuiFwimHT+0zvX9tYmGIBrZLkPJ4qzzwLNyhwas74LM1TRe5SO0U+CDhs2/t1HEbnUVSoZUcC8pan7jCbRwcJC2RRN3b4uw6FhMnuGh7sb0TftAtDUv9U18zdsmEXjmJgpA/qu2ti8WKKzbq2jDdVebv8izmh9VjH9oQgCgESoO3M/exdcXJJ2h/DsATEcKyXq2YxY97l6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ and Manuel,

On Mon, 26 Oct 2026 07:44:50 -0700, SJ Park wrote:

> > Yours isn't wrong but I would make it:
> > +this scheme should automatically be activated and deactivated with three memory
> >
> > Choose as you like.

I feel my wording reads a little better here, so I might lean towards
keeping it.

> > My choice :
> > +Below are the descriptions of each parameter.

Agreed. The plural "descriptions" reads better here.

> > I would go for this, but I'm not sure:
> > +Number of times that the time quota limit for hot regions have been exceeded.
>
> I have no strong opinion.  Aveline, let me know if you have some.

I think "has been exceeded" fits here, since the subject is the
singular "time quota limit". The same applies to cold regions.

Thanks for the reviews :)
Aveline Noir

