Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C5C606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pm7sHsOH
Received: by kanga.kvack.org (Postfix)
	id 9BF696B05C7; Mon, 23 Nov 2026 12:37:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995D96B05C8; Mon, 23 Nov 2026 12:37:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DA86B05C9; Mon, 23 Nov 2026 12:37:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD6E6B05C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:37:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08AE8C097A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:55 +0000 (UTC)
X-FDA: 85467091710.13.9A3AB7F
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F24212000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Pm7sHsOH;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455473;
	b=SSMnADgYCsSd7qFqiwmgb7IXApPMX0Bgrx7kwVjDLjvqU5HX+e4vJH7jBjQA2R47WOir9G
	5thiXqm1FZTTxwPvPtj1wDr9zjYFWPjdhT/Ke5NM31n/N1QB7OulKoX9tvJzcuNmPBdu2f
	hF4EXM31aUk2D8x1atEvien3FG6AUWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgtEXJffBQpLVIiTDFBBAZOSsnPW9SZ70tTul+WiIJQ=;
	b=frnL6ienQp7n52ZVG299GqYssnFFpLgBy3fr8cA4e7zICtR4PsjSI5/PrPXtU5F914CAfU
	Exq2b7okfNraACOMHrgzHUtoj8qoezOtdBq4bxzTubacI7tj0LXS835paBU2F3T9eWUjT9
	uLmORSBHyn3VCWAwvwkLaDG6FL5DuXc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Pm7sHsOH;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-3678f64d078so4260245eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455472; x=1796060272; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NgtEXJffBQpLVIiTDFBBAZOSsnPW9SZ70tTul+WiIJQ=;
        b=Pm7sHsOHQXhzi6EBEThrV4Zpbei18GgVXU7FTwM2afPvkh6xYQgTBNy9hctb3eVPO/
         A+gYQQCuVaY7KwchcvBgsu1jnoT1CCwmfsLmnLv1N+6nxWqt79MPtTSSDK+aYKsQ2tj0
         jVzWpT1buLOfDFKhlFQirjfHwCfr2ypk4eNRezklkV1Wn8VHgjuW6XXznV30N56onxY0
         oewT96LtA4cRM8b/nSYLjXRVl5T5+WeZ8qQwZa23uGADbc3TYxi6/G3Sbbnu2LmHC9cq
         e6UifQYxr3rYZGyFno1FybBwFiLXBU3tcOlkeT9YO6CsdKp93cbrFJMulGAI3Y6kPwi+
         VA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455472; x=1796060272;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NgtEXJffBQpLVIiTDFBBAZOSsnPW9SZ70tTul+WiIJQ=;
        b=CB8eoiD0+nC7pMLBQBjD2Pcx2GlriQ+0s+KC7qO2RGFr09GWvow204Vt63HxqSHy+D
         JrUZj8aBfHtD2lo0hyzjRRhxs8x8+T/jD8HyiJj304S/U17R3BGeOOlej2BHByrbVtZd
         0TqE3CaXmm8sh5sCHzUEyEGL+blNvCZLCBBtSvUeiwzaSzIz4v1ChhQsY1qecH2k9+NO
         gsL8NznFso0e8hikTu0+n6mmXee3LXxE83NyA2Kw5bg9hZm61fvdY0oJxMaw0TMN1lnH
         Z4gJheOuirynpw7Us0gJNu24+Oyg+pirTxofdgK0o4qQy11ImkNoqbQejZxfBnJNWmk3
         2xRA==
X-Forwarded-Encrypted: i=1; AL+hErFk0+s22WgLeIBxcSjryLmqILNg4yG/9ldGghbdiNU0g3fmyk94IU/BtPQEOoPHlm93TfjHifJ+Pw==@kvack.org
X-Gm-Message-State: APuU4Z9EzYszW/arsIW6giBXPHxL51YMQ7KzAEhMrrM6gDh33wwU3dx4
	DM25KNLQ69hhaLYaRl7tgdoNyECD2eFd9Br1X4hPCYUDoRQJHLSeEkQt
X-Gm-Gg: AZFdTZfMWWsaiJmLiav7gL6/HXBADQhIoJ1MB6qkf7GH9v/xdqfiBnLPWvT7N9jIvSq
	Pg2snwePDiApA97vYPWidGWk2VJF5lqHdyokN4h7Fd2SstcHwujd2FmsmJoTou3IlOH2UvVFRko
	nGL2lsBUb0O4O3M5FIM/L62+rRqBKjbktvvJ8hthQROZWUVl/cpjCrU4r6vP6wbDp9b94WKMWr2
	rMAqs6Oyem0PRzvDofW1psiKMUL3ND7boaERlYqpx+KL0bq4bDKS9Y813abzKjy8M0u9oigrXoJ
	Ud6SNWoKJ5WybwUGQsohOL8BKyY3bIvc6h6IZUbjJCWZzPpBYgIZBbzlAilCLOgZWkAxxGBFBY+
	Skm5Xkg63C5DtgnFPXd1fUImJXAlL+A+UjWSCQvr7F2RdvbsHR3juxyGLSnCUf4gG20udhl/STj
	AqbEoZbymYzdS/t/af8kdnxCBJXllfH/r42ovWAQjq05S+eg9mhJw1UI7giYKdhuI1n2RnH5bPP
	seJTS4ALq52RoDMNTUuQqAJLgV56lbmowA6tB0HtWqGyDRhPQqqTGipbPLpwjGkBDZ7rfU56udi
	8vYv564+gjNnoIZsZRTQsYnAYGitpotRrGGvGoQhskRke81Q5RtendrBtgjhNPkcof0yj7exbBi
	BCb+nsDYGQ4m0Arxi7FoPuK+IkBut14WDsq+Ui+kjTkdMEgb6rx1+KDe5bXtwkw==
X-Received: by 2002:a05:7301:e0cd:b0:375:dbeb:b363 with SMTP id 5a478bee46e88-38570f221dcmr13195033eec.28.1795455471745;
        Mon, 23 Nov 2026 09:37:51 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 18/27] Docs/admin-guide/mm/damon/usage: update for
 REPORT_MADE probe filter
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256491.4.1283840104529125616.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261121210013.130397-19-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-19-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: 3j1j53y6gczjxu1uuwikrjw8n95yxka3
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F24212000E
X-HE-Tag: 1795455473-62258
X-HE-Meta: U2FsdGVkX198XCESQEWsh7zXjcLUr2r5Uhd9Uk3UhctTDpKlklRyAJkTMF9NX+2ZbsRCciU4wMLSNj1LJg3aDWTDfqwG7brA3G70kRt9EvJ1GKjNFfd3OZvZ1vcfMtrEbY8C0XT/zk4+6hnuB6/TFcK2av1MyOGlklmprAnRyjWqKZ3xN6wdD4KH62FIMud6CSkXGruxSO8tO/hoUqr7RjX8tPKCEmDrrW5BZ4FZhP1dOW27NHhsB2T3f4M0wBTLmn1Wi6TKZkloDx1OCQ4cafNkb9og52A/OY8Nv6kQAfY6LFl71cgUyH5y/V0RTna87rkJiMkTQV1cyZFwSu8Wd8g5LwndqNYXTMB8l6+WzzVHJ+QU03z/jRZYCOtThAUk72ML0131Tt6nJ1BOfnglws4DWRRQtVriPEROT1aCn5LCptu83birGOcf12bZgADNWJVdyD3KBWB9y1JGrneePhMNGrmvpdrV7TD92RWQ9sxMgEHFyau0/r/BfyLBW6I66vZPH9fiyBdvzP/KzNeji8lgBBtNMpCvNah6ou4amBeKP4vZYnl5acQjsmxq2vdoAxYQhx+ad5HF4E72K52LqmONSOjYhRs6blwntZitom1b5z3qKXJCWKwRepriHYttEz85DrOEE2L6KNWAorW1oOXBdBoS8pJw9x1TUDmguaO4Qc6fCGXdX/414axg26uMs8Sy9NaFvoOZjAz+eNW2aad7A0F/vQVf7IToTYfqb01+Ss8Wo0HA7GZHZwDMF66fVwLf8mWF2ZB0B/3Hc9gdv8cQvTYoGdJlBjNU0c+HjHa/aIRyRaNHZ6P+cmDuiOumuhA1E520Fmbamz8sSgdg2CPB1X635Rwm5EtRMfgVWpdnrvIETivo/ANuYcL7pUfNq3PULJRvRdPWgWUB3/JLWKo/tjfWodtG5zzuJMZrIn06V063XHxKBUwYF15uyUm9MPeg7syZAwvVmkeYhVY
 vPybIoL6
 oWzId9pNIarAN7G0y0xUCKNauSxEUNjufidiCUf7rGcBoRg6Y2i9GwQu2m4xr80nJ10mmf1mb3fQRzeRAzXcht1947UMMXSCJBVytATY8r80ae1GxmGCH8tPRt/nY8ywLR8BuHco0Yxvz+OKyiPMHIT1/IgG938Y14kVf02+3PJBkIv0UfzbEcAdmYG9d/Ii/RdHC73mqysYPeVQiFthESkAsaFye+umg9qlDpIoLpzsE3j0pl1elaLfCbh/7oNM7DhQ5sexYb/VpfZYRqUz83Jp65QVJgzmCL3aq8CtOkwuyjq1Civ1fO1XEeMRMPC1ExSGwojx/OErdr4MZfC5JRRbF9Mdvkt39fyXdW5iXuTixgXXjMJOQLqM724akHKPw03fITPmqAmbkuwJays/8QNLhp2ue5mDRHYcqNxgPCPWVV5xyNGu3+VL91oy6Duqf6g1QlMP6Ulu3SaOQmwNGzAUUV3VOfwNZSc0ubtzD3JjT+fRtWfKPgaNDhl1tBdE+cOnMPBSypF1f5he/t4S8/+1versJj8E+ug5XZbDaSCZ8cOWe23Y9NFpWY3ls8Vy7hS8vEqzufCQjYBvliYvik/ZEGgj3AkLYv2L5AbGOTF/VvkqJUjcuIvgnGYFDPX2Eo9rcIe8NsDZSOeuEivxQLNAOA+mkvCYgdk1lsXeHlTG3qr3Te+1dRcQFvbgoIhQ+kAmTvYM78kGYyqceA+vOMldrBnB2Ph0Qt6qqCX6ByQGs3KL2Yc+eLZCQDTBQyy/iSw8QevRGl4biltXMwtk5xUfnv15epb5P1puvp1Ee+1UfDgQfbRNjipYpXfB45S7UpM+LsXBWWGdnAns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:02 -0800 SJ Park wrote:

> Update DAMON usage document for the newly added REPORT_MADE type probe
> filter support.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

