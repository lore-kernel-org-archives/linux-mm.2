Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5D4606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sr5J6wic
Received: by kanga.kvack.org (Postfix)
	id B96626B05D2; Mon, 23 Nov 2026 12:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F186B05D3; Mon, 23 Nov 2026 12:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BB46B05D4; Mon, 23 Nov 2026 12:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F89F6B05D2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:39:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1414F14082B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:39:16 +0000 (UTC)
X-FDA: 85467095112.23.A194040
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf03.hostedemail.com (Postfix) with ESMTP id 22F8920004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:39:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Sr5J6wic;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455554;
	b=1nIaE8aqYXSq8g8P1bpmjTTJWB/Ltr/AxdR2A6arhAj3Nx0vlP3ujwmbQXyUSCYOEnXJaA
	WPy9ut/nfmV6Oxzs3SLLGqsNFj/ncJZes/Z3I1NTmD7ekWEAfvymEKifX/6nB+nqKoLboJ
	MqLjZe79f/zVnFc7p2Cluf41ox0icwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWfgjam6rCEomOPvrn2GA2ApJi/57i65FVTDm4cSaII=;
	b=1nij7PwGsNm4F/i+gp7BXnHq5/kto6/ZjuRpYsjJQOXr80wCutZCnc+NFzIsigregxF+Ck
	Iz4M7x1BGEUXoDCNe+kojMVRaowUa8E3DwvPnbTnS5IPQFQd49c5Cv5UiO/rg1jxtYa+Lw
	ar3Ymw8l+jIZsozeu0QtjY5VB0+q238=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Sr5J6wic;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so1088178eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455553; x=1796060353; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GWfgjam6rCEomOPvrn2GA2ApJi/57i65FVTDm4cSaII=;
        b=Sr5J6wicBCemv12GJa4w6mLP2Vvjkwzs1KhDUTTVI9pMuohC72k15pCG6yom0jaWmJ
         icncdXPEkIo+8NQhHKw88raKOxG3tIO48+YxdIjA8Lc3ByQT2CJsfmV3K8iA7FfouGiL
         7afa1f8e3BoI5Mqqlu6/xUZ8hzZI1MBPyVb46+p+f6/Ilhcf0CIx2b0wr3G5H9Q3M+H3
         +uCgEErRDYQ0s5d4PepLEy2VonTKz2zKyk0Z8GP//WCK787OPWDx7R7N4eSCvsixYjFB
         TEc5ww3k2Sp5gBG43ouNJ5zI+zRuqvYMLcE5nhKBC679aPa7IEfs2J3aunUV1gKjUepo
         hZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455553; x=1796060353;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GWfgjam6rCEomOPvrn2GA2ApJi/57i65FVTDm4cSaII=;
        b=1zZn8Nl2BhAjHiQcr6X8VAAJpsKOmqQd7EwMekVS/IOvZ3a1v+d81q/hNV7m18PNqZ
         Jfn7U3rF+Fsj+GOQwhREY1NzSMIOleRmIx+DrQjBEcq4A7avlpac/Ba6Vzx1ZoqFxMTV
         aBjAw6n1SR9P51Wzs1ahduPL81TG8WWDpkzwjyPEOAbFJAc7WPr9Lokd1k4BBkES4Yx1
         y/yfdrKh9dF1s94qiAm1YVkZfP47oNdenBmEih2sjxFkRZn/DXR7TUPiGDZIUqco+pU1
         qYQVrZovoGG2YGhRHPiWTncPlK3CoHfsd/Or2U2k85p+3ZRvmY6yaSdxpAI1uc2rCLrP
         EjvA==
X-Forwarded-Encrypted: i=1; AL+hErHejEtA7eXWNh7/dP/6lQD2BBCCyomgyJOb8S1BrA0EVfUc8s9P6p11k9U1gzNqia7/UXHbVxcCzw==@kvack.org
X-Gm-Message-State: APuU4Z+2l8eh4Ex9XFT2g+c+m5k/D4ezju5y5Mlqhd1JpHTFHAYh8pDQ
	mD3bIOs//k6o/qoD2a3bOomsV1jsIZrOoXylohyFaIiEeNFZFDly0ANbikvhPlH82+hF+w==
X-Gm-Gg: AZFdTZcnKmKIwNqQ0YJyAoQTIYkj4b4TagK0MuyrGWy457c8GmnIbI2sZCqyAW5nCG6
	Zoo4gyiVGizE8tjQ9MF0JOrdtsamKQebhn9Spm/nRyqjsyhI4tSGSDe1Kn2zgCA+RmvPhEBNox2
	6jJmP9jwUMkArFgRGLubFoAOjTeVAiYesymD6tSC4dn2NYK5+vvVIDCPlGbnbsid9OQbLlH561J
	QI/vMWIKyqDWnllg3BJdIYPe20AKBhQJHeW68++I3T2vkTfhfebltz9PSdb6hnG1pevGDdrpM/c
	ZrHyZP6yxiqYuhRl+jrUxd9ZtS6AiUT8/MY1ZgY2A7+9DjswBCm2vx33umw29lYqGAElX7zOwJz
	29aQ/cRdwsFQMbDImb/bYLlw04Sa3k7W7iAEX1NLuIXLt+U3VSdqrGeU/B7ZKRqk7VJ7qYx8K5H
	4Ia+rWx0REzE3OyU6wI7UQaN6b1744IkFYTaWeymod3x0HRTj9J0hQnikvGWPjAIEwyiTvp0P2p
	FFOlcBf1ND1zyboUVKwPYPny71Ueti2N2PItoOj2zlGmhdKIDKYblk7JicRMl0f8+vh4ywEaAxk
	n0LoXxz5ZpDcbVJR+3xWVUv9bgk5WCKT4aMwPftuTp/hnWVZqUFFXp8vbfeCj1lMh7a5dneSzKz
	vpptnBegVPxDeTrQrDRM0qf8Lh06ni5t321Ccotoki1RkiN+rItJcwIiJGnfIfQ==
X-Received: by 2002:a05:693c:88d0:10b0:386:b894:f6dc with SMTP id 5a478bee46e88-386b894f8c8mr1968476eec.2.1795455552800;
        Mon, 23 Nov 2026 09:39:12 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:39:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 27/27] Docs/ABI/damon: update for user_report report
 support
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256499.4.10698731760780955093.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-28-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-28-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 22F8920004
X-Stat-Signature: e68q8864qonfunx331ztqkcpgnqasjep
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795455553-138157
X-HE-Meta: U2FsdGVkX1/GH473K7r2fxkb8K0/oZIph3ntqe9sH6UEXihfDpaRviJF8JFyh92f8J/MQPCnthhugzAeTFeNfVwe5x/VIQg+ozvYYQYqP8lHNUHKRbLHlEShE+F1XcpXa2frpELSCCLvrhMQsrTB54BbbHgI7s1Maxjw0toPMLIdxtY56HpOWlY+qE+8E+nyYHluF20wZNJDO1Fr0rdRkohXShBlNhNRxUyxn7BKUJFHw8eoS7lzDJaofb9ZVJyhGiX2nnHUMnrQjCm1lYUwBi74GzPaXjMr155Mv1jpOoJwyu9Y2WP+fzr4pcZJaXntJzqH/UiBjS7nskGGGlQI3MCJVRNaLxa6fAVeYz1YwC1nJINLpKYsDIiNE0BqJg8mT1mWrNkghct8vq/dw1GZOpN9/lQR8vzZ0XGiDgRyp+rNVNo7Rxsi3uwSxFNwkO2OPwg+rrOctwVZrWNSyLgLwFgS2+QPHvkBf7hPSRkfdEcNDdTUPj8y67bjbFJdLRlhFAAoZrUBCyeFOR0IzZdmjTAyjeTk9x83KzHUlF8FhQoD/uI+smd/6l37ZZgJavk9Xax4eUP0BHAmp2uPTcJVQFFBKSBHzHgbIl3HGTMWUG8QxB0kio89/nwEvocfsbW2VDXKex7eZ4NN5v+k4W4hPEO2kak6MET6lsoytAAYAfbzsmOnWOQRdPawZ6WQ/wmVXAuuNO2Y8IvZUjtspkJFM7UyjDP9w9N1XJgpyW0yV3rTrYVHZ8v8H2y8KJ1vQJQBCgdphOhDwhIV11JbM23WidlmK9jp3gmfQcMAwR2aNLD5m6XwdHOB5qLlc8BqfjdjCOZBpIUnmkxLDFe5k4qqCE89z+7BytKsrWdSqM4ZQmhHEgRskzmGJLBDsBb3F+7Sz1eZ0yPYtSymSZP+5f6uzAuX/1O0RRN7/r+We2WiOazY8ztu2L8rnAVELumC83wmoGOB8UVbacA8BDgvCwN
 LsLFkYFp
 i5Jwcftc/60u+172ydVYdPgi9ZRDKfhzC7Xk5KKIfF+BJkGxyYblRmJ46A+kvc2lEMrevhyMvyDH3ui84i3Bfy1EjhFtarv2GF6jeglL8t58/npAJhfB1aEQnhyV+KGzne/cJ40mcQb0UKPdL0FOY+W/9ms7yoGJU4AWdrE7fyMMz05pavKMZrcLu7ZhUCZUzBNqzSynD1197L7TkU1fmemdJl7tcuUS6XmI8sNIX6seR4mfsi9/Z++Oc4hZQK3Jw7FmL/xUxBU4I8ccLmyr29uMw9Z3TXyXP/vJp5/MLm4hIT5MOM1ptB9sTgrb9c46awqW+3bATYV4OC91d81oL3veWNzQicDErpJYl9rCDorwtleXfQrh3o42lul4a5Ta87RMUVdSRuFh6xsIGyAyx1LhaNXKjj0ytcZXxH44xoN1ixDACKNhTBnNA0YlkjjQHlWu6nrBrohnJXP3NhMkDAk/5itFnj3Y26Opc5kYwzmAt+UE2zIKgtwi5P/YwNt7fnP1Qn/ONQDv/F5T9uAxtTOJ3oK+ggQ0ZcoAaRcpoVHmElgYHpugu3GbPwlmkTg792zqvkKWW8ZJC5uScdX7zpfD6fjADRtF9XHgaiBi1uJmq2iev7u2RyhV7hj3nwxOJJ27Y4SyInCKm/Da7NiT6ovwh9OR+Fg2md4PdyS5lQ6w8fxGH8uCtHW60xqYZDS4D4VKnHtuYtq/dHoyDY/UA/DGUxYXut7Hq5qaIFaTrZeL96hIksJxjqm9vkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:11 -0800 SJ Park wrote:

> Update DAMON ABI document for the newly added user_report type data
> attribute report support.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

